Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0198C98317
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 10:57:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF0326B008C; Thu, 24 Sep 2026 06:57:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B800B6B0092; Thu, 24 Sep 2026 06:57:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1A356B0093; Thu, 24 Sep 2026 06:57:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60F556B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:57:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C7EFBA5EC1
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:57:50 +0000 (UTC)
X-FDA: 85248355500.16.608E64A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4CD99180007
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:57:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="rwkH7yk/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZcaR9tcI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VGdEVve7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lQcXohwT;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790247468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qGe1Uyoj3hhwaqMmmb4P4GWQZZ0XVbX1aCs+aO9Y1iA=;
	b=I1DU3CjMNthSpmcgRr57YkpGG1pv20pXgHThgy7CivGj0dkzBC2hY8dUs8bcMnccQI4EHI
	JzaryzGcgJOA5w1Bp6S24Ge4LdPLuG7g1NQrTckUfISuCERLLmabYkOvzD09wnsAGDbHtD
	aD1RFLeXjxUMzXhSOSNteyYcf0FgEBI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="rwkH7yk/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZcaR9tcI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VGdEVve7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lQcXohwT;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790247468;
	b=K3xL25dils1rs7FTL2p+GZTwZqLNioF5/vexAKfFUPhTiE0W3PUyJH/9hlz/q2qKIV4PZH
	KG62iwXzEOfEHI0UFVYG8abwWCOQORU2vK/wxGfd3D0TiLXGmAuO0oIneDtqNoIKpVOGvp
	Wqb+0bPByXrkoBnBsFFEf0EU5tAb5ik=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BAD6A21F05;
	Thu, 24 Sep 2026 10:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790247463; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qGe1Uyoj3hhwaqMmmb4P4GWQZZ0XVbX1aCs+aO9Y1iA=;
	b=rwkH7yk/nadi0w+6IrC3tuhGWnNWPkleBFeW/8SVSb7/yEL5RvRcN7EKX91i9dGkvCfrSl
	JhxQj7nh/5RfVYKaOBUlwys1qbT/5pxgrPVDkaYyn2hy4vG5JpVF/fCAXzNPrlTonHmO5c
	S7A0BtSAbMfg4+bag4QKVCZh54D85uk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790247463;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qGe1Uyoj3hhwaqMmmb4P4GWQZZ0XVbX1aCs+aO9Y1iA=;
	b=ZcaR9tcIrRhdwUhtPcQUMDU/BnzZD1b2TbxVw1Ln1mjLffpVUzU9Pyy+M4ae0dlCGg2r9t
	ffEYs6mm2LwOUWCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790247458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qGe1Uyoj3hhwaqMmmb4P4GWQZZ0XVbX1aCs+aO9Y1iA=;
	b=VGdEVve7YyDaxnDIgn08n2nt1Hb+Rhy8pzwOvhyxpkOhY2jiGd8MALSMaKMiHo16n/c1yJ
	bO1ieKBMGNnp3GQVIWdNG1QSkhSnwLc5bHSdtCKULjtjpg3L9sDUBFA6GI8YvA3108+pHx
	+D+snlQkaUCM9jXELaSKS9GipaQ6uVw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790247458;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qGe1Uyoj3hhwaqMmmb4P4GWQZZ0XVbX1aCs+aO9Y1iA=;
	b=lQcXohwTmm7KFljPOB4yE7ES2ohOCoH4SMLNRblhmwysOdz2dxoWV1F8ZSqaAnIgXxRqAT
	MiEGr4/JwtQAmTCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8EF8B13668;
	Thu, 24 Sep 2026 10:57:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kOtDGiICtWqoAQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 24 Sep 2026 10:57:38 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 20EC2A132E; Thu, 24 Sep 2026 12:57:34 +0200 (CEST)
Date: Thu, 24 Sep 2026 12:57:34 +0200
From: Jan Kara <jack@suse.cz>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, willy@infradead.org, jack@suse.cz, 
	tj@kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v8 3/3] writeback: record bdev targets in foreign
 writeback tracepoints
Message-ID: <xktq4fmpdlbtrncw2zjdu73mgstjsceq7qurdmatditlqhhavz@53m37febbjki>
References: <20260922125015.3435215-1-sunjunchao@bytedance.com>
 <20260922125015.3435215-4-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922125015.3435215-4-sunjunchao@bytedance.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4CD99180007
X-Stat-Signature: 5bxpd69sjw368dbr7qnp3rrmawora1nf
X-Rspam-User: 
X-HE-Tag: 1790247468-470640
X-HE-Meta: U2FsdGVkX19YM+/WEEvsm4HUnY7xaxVCMTsvLFIUnuvNqAxzfce2pfmrfmdTDvFXZCVwGc4+4OYJqHj/nsgl+cN3aSHt4MKjLLhV2Xk7crNnNVoyyCvT13z3ZXm+GqlznmtEB1OcZPOs7xnfdnC+Y82oYWP7eyoYKdhLNkX2dvn2rbUbEx9jvdCilE4vRIcQt/Ipeyn3kaQpZcFT44v9+l6LZfjOPKsMmr7N4icxP2lKo+Z0otsuFn+azdzWL5mS/iZooUvyUGlDHM0lgmKM/Qybf7sicywM8aDmEvK1NdrsKrc61dZ66cpTpR6INuB0swf6hY8p1Tb3wTWp/BGoCMdNbkhUakJpX8xCPGZ1xt5+eO3xvubwGtupG6gjVK2rIqbOshBp8Gd46UGVF1gixDizeQiu1iVDFuvXsg+82M/wo3HtIZddByMD7fAbylMMrvNmKwH4k1Rx6TQYIrRxb12r+o9u+1MlZFAB3KLmbsw1U6yNUUs++z8z/k6QQlRDwsZRIBDmMaJKLEXdRmVYbB01CNzM9ePreS1bHHBq1Np914SinrwXuf6PgQRh9pkT//dGcd0eSBGJSNAt+jzRHZVsCWM1kCnM+dTfKyrwf1odZYBrH2D9MJQ0Vc85qC4UkKFdRgKwZnKtWf3nyC190fh8Q2VA52AEUJ1T4F836+Su8qnYdWn3rJPnBN+l/z6AQvB9nHl2ZIHWaCIZspU0k69oxEKJtH+DPA/OA5NRtMf8hWAhnXhmHBNVqfkAPw4b5l4rmzLagdS6ScltOGs09rASfK1QEEqehGFP2/RzBXhOGz5nCuB+GU1bEXAdyCOlDFsWtV96cOiRONa/tC9aDDE60oygLiyZq866UM5iXW7V8r2ruF9v9lkCko3XwicgMeJRXKjN0KSuuOk6ILjRLdo+xIcyd6hkose2pON0y8/bxY6hqEV19oZ270rghZUmN+ZA108Rdf2Cy08efcR
 KLv+uMPs
 0JWZLkBFoP8hC66GWm0Ja+eu7IABHYkYChThJx7IfE1/vehjJBgrUO/clAFiydw+mU3ZFZJU30LuhgRE5l7wANFRwibvOSvUgTJcS7zn57Bo9cz7HCTZVYpHqaONsWPCBhioHml36DoXabwAVWgkxKWs9HB4OGPruAdwtO/RQtcNY9OTKx2JWGOyaD/b+dveNYHm7tSAIEDG1YOTGw+7lyC+smcMzeuonRf+UNxnDqeHA63Cq9PH+0XkkfRUiHyy6ZUsUg6JSYJRKWNeVS6MMpFzWd327DlQLiRfIat0OkIMgldlca1VhTv3+vJlH7Hp+nb1Tsd6O0riCuOTCqaIok3N7cmpUL4gtIliPYSIyXrSgfYQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 22-09-26 20:50:15, Julian Sun wrote:
> Add dev to track_foreign_dirty and flush_foreign so traces can
> distinguish foreign-wb tracking from the bdev-only path. Append the
> field to each event and print it as major:minor; zero denotes the
> normal foreign-wb path.
> 
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

Hum, won't it be better to introduce new tracepoints instead of kind of
abusing the existing ones and filling in zeros? At least if I were to use
these tracepoints, I'd prefer that.

								Honza

> ---
>  include/trace/events/writeback.h | 22 ++++++++++++++--------
>  mm/memcontrol.c                  |  8 +++++---
>  2 files changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
> index 13ee076ccd16..ffd1b8df4231 100644
> --- a/include/trace/events/writeback.h
> +++ b/include/trace/events/writeback.h
> @@ -273,9 +273,9 @@ TRACE_EVENT(inode_switch_wbs,
>  
>  TRACE_EVENT(track_foreign_dirty,
>  
> -	TP_PROTO(struct folio *folio, struct bdi_writeback *wb),
> +	TP_PROTO(struct folio *folio, struct bdi_writeback *wb, dev_t dev),
>  
> -	TP_ARGS(folio, wb),
> +	TP_ARGS(folio, wb, dev),
>  
>  	TP_STRUCT__entry(
>  		__array(char,		name, 32)
> @@ -284,6 +284,7 @@ TRACE_EVENT(track_foreign_dirty,
>  		__field(u64,		cgroup_ino)
>  		__field(u64,		page_cgroup_ino)
>  		__field(unsigned int,	memcg_id)
> +		__field(dev_t,		dev)
>  	),
>  
>  	TP_fast_assign(
> @@ -295,34 +296,37 @@ TRACE_EVENT(track_foreign_dirty,
>  		__entry->ino		= inode ? inode->i_ino : 0;
>  		__entry->memcg_id	= wb->memcg_css->id;
>  		__entry->cgroup_ino	= __trace_wb_assign_cgroup(wb);
> +		__entry->dev		= dev;
>  
>  		rcu_read_lock();
>  		__entry->page_cgroup_ino = cgroup_ino(folio_memcg(folio)->css.cgroup);
>  		rcu_read_unlock();
>  	),
>  
> -	TP_printk("bdi %s[%llu]: ino=%llu memcg_id=%u cgroup_ino=%llu page_cgroup_ino=%llu",
> +	TP_printk("bdi %s[%llu]: ino=%llu memcg_id=%u cgroup_ino=%llu page_cgroup_ino=%llu dev=%u:%u",
>  		__entry->name,
>  		__entry->bdi_id,
>  		__entry->ino,
>  		__entry->memcg_id,
>  		__entry->cgroup_ino,
> -		__entry->page_cgroup_ino
> +		__entry->page_cgroup_ino,
> +		MAJOR(__entry->dev), MINOR(__entry->dev)
>  	)
>  );
>  
>  TRACE_EVENT(flush_foreign,
>  
>  	TP_PROTO(struct bdi_writeback *wb, unsigned int frn_bdi_id,
> -		 unsigned int frn_memcg_id),
> +		 unsigned int frn_memcg_id, dev_t dev),
>  
> -	TP_ARGS(wb, frn_bdi_id, frn_memcg_id),
> +	TP_ARGS(wb, frn_bdi_id, frn_memcg_id, dev),
>  
>  	TP_STRUCT__entry(
>  		__array(char,		name, 32)
>  		__field(u64,		cgroup_ino)
>  		__field(unsigned int,	frn_bdi_id)
>  		__field(unsigned int,	frn_memcg_id)
> +		__field(dev_t,		dev)
>  	),
>  
>  	TP_fast_assign(
> @@ -330,13 +334,15 @@ TRACE_EVENT(flush_foreign,
>  		__entry->cgroup_ino	= __trace_wb_assign_cgroup(wb);
>  		__entry->frn_bdi_id	= frn_bdi_id;
>  		__entry->frn_memcg_id	= frn_memcg_id;
> +		__entry->dev		= dev;
>  	),
>  
> -	TP_printk("bdi %s: cgroup_ino=%llu frn_bdi_id=%u frn_memcg_id=%u",
> +	TP_printk("bdi %s: cgroup_ino=%llu frn_bdi_id=%u frn_memcg_id=%u dev=%u:%u",
>  		__entry->name,
>  		__entry->cgroup_ino,
>  		__entry->frn_bdi_id,
> -		__entry->frn_memcg_id
> +		__entry->frn_memcg_id,
> +		MAJOR(__entry->dev), MINOR(__entry->dev)
>  	)
>  );
>  #endif
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6042c694d56c..534b0d537a09 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3956,12 +3956,12 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
>  	struct inode *inode = mapping->host;
>  
>  	if (memcg_bdev_frn_wq && sb_is_blkdev_sb(inode->i_sb)) {
> -		trace_track_foreign_dirty(folio, wb);
> +		trace_track_foreign_dirty(folio, wb, inode->i_rdev);
>  		mem_cgroup_track_foreign_bdev(memcg, inode->i_rdev);
>  		return;
>  	}
>  
> -	trace_track_foreign_dirty(folio, wb);
> +	trace_track_foreign_dirty(folio, wb, 0);
>  
>  	/*
>  	 * Pick the slot to use.  If there is already a slot for @wb, keep
> @@ -4032,6 +4032,7 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
>  			 * the timestamp for a later flush.
>  			 */
>  			frn->at = 0;
> +			trace_flush_foreign(wb, 0, 0, frn->dev);
>  			queue_work(memcg_bdev_frn_wq, &frn->work);
>  		}
>  	}
> @@ -4048,7 +4049,8 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
>  		if (time_after64(frn->at, now - intv) &&
>  		    atomic_read(&frn->done.cnt) == 1) {
>  			frn->at = 0;
> -			trace_flush_foreign(wb, frn->bdi_id, frn->memcg_id);
> +			trace_flush_foreign(wb, frn->bdi_id, frn->memcg_id,
> +					    0);
>  			cgroup_writeback_by_id(frn->bdi_id, frn->memcg_id,
>  					       WB_REASON_FOREIGN_FLUSH,
>  					       &frn->done);
> -- 
> 2.39.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

