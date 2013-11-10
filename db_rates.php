<?php
/**
 * Plugin Name: A Rates cached in DB
 * Plugin URI: http://
 * Description: таблица - currencies. rates.pl в кроне заполняет базу.
 * Version: 0.1
 * Author: Дмитрий Пекаровский
 * Author URI: http://
 * License: ГПЛ в2
 */
 
class DB_Rates extends WP_Widget {
	public function __construct() {
		parent::__construct(
			'db_rates',
			__('A CBR Rates from database', 'text_domain'),
			array( 'description' => __( 'A CBR Rates from DB', 'text_domain' ), )
		);
	}
  
	public function widget($args, $instance){
    global $wpdb;
    $title = apply_filters( 'widget_title', $instance['title'] );
    echo $args['before_widget'];
    if ( ! empty( $title ) ){
			echo $args['before_title'] . $title . $args['after_title'];
    }
		$table_name = $wpdb->prefix . 'currencies';
		$ids = $wpdb->get_results('SELECT * FROM ' . $table_name, ARRAY_A);
		echo __('<div class="CBR_rates"><table>', 'text_domain');
		foreach($ids as $i){
			echo __( '<tr>' .
        '<td>' . $i['nominal'] . '</td>' .
        '<td>' . $i['charcode'] . '</td>' .
        '<td>' . $i['value'] . '</td>' .
        '</tr>', 'text_domain'); 
		}
		echo __('</table>', 'text_domain');
		echo __('</div>', 'text_domain');
    echo $args['after_widget'];
	}
}

add_action( 'widgets_init', function(){ register_widget( 'DB_Rates' ); });
?>
