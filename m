Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C825FCD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 18:17:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 309356B008C; Sun,  3 May 2026 14:17:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0E56B0092; Sun,  3 May 2026 14:17:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F71C6B0093; Sun,  3 May 2026 14:17:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E3CB6B008C
	for <linux-mm@kvack.org>; Sun,  3 May 2026 14:17:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C06ED160593
	for <linux-mm@kvack.org>; Sun,  3 May 2026 18:17:45 +0000 (UTC)
X-FDA: 84726916890.10.F6C2016
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7D9614000F
	for <linux-mm@kvack.org>; Sun,  3 May 2026 18:17:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JNnOtsfd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Uwx1gS/O";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JNnOtsfd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Uwx1gS/O";
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777832263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vejb/G9cClvZHxy5gifEMwQcvS/7NoCZj9V2DWPTf+Y=;
	b=acGTuPbOp+DdicAkNhOgiQTIWNLcb7Owv3Sg+kcm35axFXpTlvaG82ZyxOITd6+Nko8xfI
	/jQpatgAxhRs0gJkTXWVIXlKoUzHuJmK48gyfwIZRCfJdS2vH2243r7+Oec948p7r0hQ7G
	XGoxHftqzUb2E3xGl9Fqck2LONTma8o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JNnOtsfd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Uwx1gS/O";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JNnOtsfd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Uwx1gS/O";
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777832263; a=rsa-sha256;
	cv=none;
	b=17UPxJz2wR+MD5iUdGesGqXNPM8Y+nwwMksBSEkEm7iHRMwmpIiVg+xjhGHQdC4Gl2VQ7V
	o2YwhNgteq2PY06ZCMDybREN6GD94K3dOOV9gL1UJ3p+paCEqyjw67U4RCpHtNx2ZBJEVL
	TaE7hnb8Xhfs99CpdWXSBxBhctUASVE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9AF546AC14;
	Sun,  3 May 2026 18:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777832255; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vejb/G9cClvZHxy5gifEMwQcvS/7NoCZj9V2DWPTf+Y=;
	b=JNnOtsfdia6KNeiWF/zx6UmGMlyd7MovighKfDpbipWcdICHWOyAWdUdIHnNg26ISosfcE
	1vhhhQx0enMHLf8gCDJ3U3A1PI1//jmY4yLWHBCi6uzrihaeCN/zDu5G6bMuodmAEBTytD
	sywVPBV32c+X721DpOigCPrJerl7mWM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777832255;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vejb/G9cClvZHxy5gifEMwQcvS/7NoCZj9V2DWPTf+Y=;
	b=Uwx1gS/Og/X2yT7c6rFcHwYxYjc3O5eZU/ab3xJaQ8s0HkzspghdERq4rp30NfBiSRzyTZ
	mp+GNFSRN3hluyCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777832255; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vejb/G9cClvZHxy5gifEMwQcvS/7NoCZj9V2DWPTf+Y=;
	b=JNnOtsfdia6KNeiWF/zx6UmGMlyd7MovighKfDpbipWcdICHWOyAWdUdIHnNg26ISosfcE
	1vhhhQx0enMHLf8gCDJ3U3A1PI1//jmY4yLWHBCi6uzrihaeCN/zDu5G6bMuodmAEBTytD
	sywVPBV32c+X721DpOigCPrJerl7mWM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777832255;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vejb/G9cClvZHxy5gifEMwQcvS/7NoCZj9V2DWPTf+Y=;
	b=Uwx1gS/Og/X2yT7c6rFcHwYxYjc3O5eZU/ab3xJaQ8s0HkzspghdERq4rp30NfBiSRzyTZ
	mp+GNFSRN3hluyCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8177E593A6;
	Sun,  3 May 2026 18:17:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id X9weHz+R92kjFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Sun, 03 May 2026 18:17:35 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D5645A078F; Sun, 03 May 2026 16:37:03 +0200 (CEST)
Date: Sun, 3 May 2026 16:37:03 +0200
From: Jan Kara <jack@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Chuck Lever <chuck.lever@oracle.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v4 1/4] mm: track DONTCACHE dirty pages per bdi_writeback
Message-ID: <7awcgzgxkpav4krxe4qtyfzzlhfpziw56ptfchuai5r4txz4ib@hzycmy5syvjo>
References: <20260501-dontcache-v4-0-5d5e6dc71cb3@kernel.org>
 <20260501-dontcache-v4-1-5d5e6dc71cb3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260501-dontcache-v4-1-5d5e6dc71cb3@kernel.org>
X-Rspamd-Action: no action
X-Stat-Signature: ups99d6mxqcmxez4gbmdt144mg61ahso
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7D9614000F
X-Rspam-User: 
X-HE-Tag: 1777832263-899188
X-HE-Meta: U2FsdGVkX1965kRi1Pe0F5tjnI5YrjVR3V2H/VepA54fsuLTpEO2cKYcLPcx61qRtu2csC8KJLkvvKIyq5FIDreUByP929IfD/iIYPBIXLQxv66uboiaCiXoprgO/rsQTbrzt0Pgk/3Otzm2NuG9P11bT2xY+0dLquBm2rjncOf14GMAJqfpy2E32i6yfR6PYaVopbdTeoH/yNro5FSBldihR3NJMbblkZXjYomEdfmC3uZY5+swGFpA6hWe9NoeB3qu3YaDENcXIjtrn7zuBymUAeNSkW6e8FaDyVtPqgv0YrzedE3W1uo37lKm8rRd/IR6IYjjUIdpMUTR+2Wn0DTB1gsuaYePLXITlD5wHSfSB7Bl3OlOFstN2nTq8dwKOvv0E6k1if5AJYIKQlvCC5xtUWlP5Utc+jwqLXqAC3g/uqrXT0aczK2wXAknUQYqhkUYkr578n6CEvE/Mxh5Ko8LdvMacfnxQse4/grMlhu3vmA5yJ1AvYgnGw7wlAiNN99omlqTUZSeuMQoTjD/CQgvYWc+tizWoocKai5x37nT2umnSkK630jQeY3iJuvKNh4t8wO/+sdXCz5bSKRcCuZvTzWAs8ZrvXKhUDIUldp09JK4BmREGxeV4/pPnqkFEwtIszuwU3VbSrlvNpRHQHBNYGF8RUl+yU1qj2Kldg7HuWmS66f2Y8cyfyPxpTng9firrkw8Z1BAYuKDNfFwiDiFRTwQdqHPjmIUmLZYcnw/ys2kYR7/V1LNeip064vd7E6lhI9LH0zQ4bUtrwvzkKuO7LzS4JFEPtqdyf/NaNW1mgKW/Xlo9EvpwGslFv7QvBc9JaacjancY5ZXQDhMUGKKHEs4l7qedmWvUm+2BZ0CEX/3RvtHC90vumpSnmeXwHJELqDd0qNb4WkV1EvTzTd7UbLJp0ivFEB2wn5A6KxIJZ+cavQvybq+fDt+zi8AgtqF6kkAdyxwvTFwGYl
 E1Klb5AP
 2VDyAgIPuFvdqEddGU+CQUCfdozLqArrfyJBQLaRb368t1mtEEJVg/WsUkPmC9jsuZHwjJUQDsLOBEfAzyQwbLUrsNRo6tfVmsaXRBmlXGBKZym5pDYDygeN3+MHDgiUgpD6LH7JdadkrIKjfDrgAP8dgjhRMTsaWFuVaYE3HtF5hdIdQoxDwlR6LYQbmSukXbn+uAERJ+WFuNR53dPxKKcTYbvQ7J0lzOW4LfiNfzeJ35qg5sfoshr1/qgWgiJ61zpb1iZrY5xq2LEE36Xb+ZOMX3+cAN9M8U05aE5TXBmgi8M2SDNf9TiNHPgH1MQTOwQovc5l5tYDn3WKFDOk+HhDDbgXvEhLLoqMJAA3cdE52rUF07CCZPaNhxCvo4lV60W/tlnPJhUdV7vMpLkijko2cpAmlnLcxnfHHIKp2fa60f3IW5nc93i6PFzJCAPZ/tvymPALRiSZx5vjwmOu6EMLSOFf7iOaTPhmH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 01-05-26 10:49:35, Jeff Layton wrote:
> Add a per-wb WB_DONTCACHE_DIRTY counter that tracks the number of dirty
> pages with the dropbehind flag set (i.e., pages dirtied via RWF_DONTCACHE
> writes).
> 
> Increment the counter alongside WB_RECLAIMABLE in folio_account_dirtied()
> when the folio has the dropbehind flag set, and decrement it in
> folio_clear_dirty_for_io() and folio_account_cleaned(). Also decrement it
> when a non-DONTCACHE lookup clears the dropbehind flag on a dirty folio in
> __filemap_get_folio_mpol(), using proper writeback domain locking.
> 
> The counter will be used by the writeback flusher to determine how many
> pages to write back when expediting writeback for IOCB_DONTCACHE writes,
> without flushing the entire BDI's dirty pages.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Assisted-by: Claude:claude-opus-4-6
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/backing-dev-defs.h |  1 +
>  mm/filemap.c                     | 13 ++++++++++++-
>  mm/page-writeback.c              |  6 ++++++
>  3 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
> index a06b93446d10..cb660dd37286 100644
> --- a/include/linux/backing-dev-defs.h
> +++ b/include/linux/backing-dev-defs.h
> @@ -33,6 +33,7 @@ enum wb_stat_item {
>  	WB_WRITEBACK,
>  	WB_DIRTIED,
>  	WB_WRITTEN,
> +	WB_DONTCACHE_DIRTY,
>  	NR_WB_STAT_ITEMS
>  };
>  
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 4e636647100c..1c9c0d5f495f 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2052,8 +2052,19 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
>  	if (!folio)
>  		return ERR_PTR(-ENOENT);
>  	/* not an uncached lookup, clear uncached if set */
> -	if (folio_test_dropbehind(folio) && !(fgp_flags & FGP_DONTCACHE))
> +	if (folio_test_dropbehind(folio) && !(fgp_flags & FGP_DONTCACHE)) {
> +		if (folio_test_dirty(folio)) {
> +			struct inode *inode = mapping->host;
> +			struct bdi_writeback *wb;
> +			struct wb_lock_cookie cookie = {};
> +
> +			wb = unlocked_inode_to_wb_begin(inode, &cookie);
> +			wb_stat_mod(wb, WB_DONTCACHE_DIRTY,
> +				    -folio_nr_pages(folio));
> +			unlocked_inode_to_wb_end(inode, &cookie);
> +		}
>  		folio_clear_dropbehind(folio);
> +	}
>  	return folio;
>  }
>  EXPORT_SYMBOL(__filemap_get_folio_mpol);
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 88cd53d4ba09..8e520717d1f6 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2630,6 +2630,8 @@ static void folio_account_dirtied(struct folio *folio,
>  		wb = inode_to_wb(inode);
>  
>  		lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
> +		if (folio_test_dropbehind(folio))
> +			wb_stat_mod(wb, WB_DONTCACHE_DIRTY, nr);
>  		__zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
>  		__node_stat_mod_folio(folio, NR_DIRTIED, nr);
>  		wb_stat_mod(wb, WB_RECLAIMABLE, nr);
> @@ -2651,6 +2653,8 @@ void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb)
>  	long nr = folio_nr_pages(folio);
>  
>  	lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
> +	if (folio_test_dropbehind(folio))
> +		wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
>  	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
>  	wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
>  	task_io_account_cancelled_write(nr * PAGE_SIZE);
> @@ -2920,6 +2924,8 @@ bool folio_clear_dirty_for_io(struct folio *folio)
>  		if (folio_test_clear_dirty(folio)) {
>  			long nr = folio_nr_pages(folio);
>  			lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
> +			if (folio_test_dropbehind(folio))
> +				wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
>  			zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
>  			wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
>  			ret = true;
> 
> -- 
> 2.54.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

