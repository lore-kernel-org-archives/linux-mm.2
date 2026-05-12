Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ACC4CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:07:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A643E6B0092; Tue, 12 May 2026 10:07:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3B6C6B0093; Tue, 12 May 2026 10:07:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 951DB6B0099; Tue, 12 May 2026 10:07:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87DEE6B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:07:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EDF7BC1B1C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:07:52 +0000 (UTC)
X-FDA: 84758946384.10.0B9A1B7
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id 778321C000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:07:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KtSb694V;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=07i9D6CY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Xtmy561O;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PpfP8HUb;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778594870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=myGkdDpGAqSiI3QSlhAm4i2daq28KmwVMURWssNipPI=;
	b=gNDJMzmJp1tsfy7WMAvJdhM+dxHQmnAb0Fe++5ROcniQnX0A52CTC8rTv3MBrd2BTzI/xH
	20ytiHUdEB6kaP+xHr8WpR6LUd8xLgPyyt7uuKPfr08xwDhftbIu3B+kvvGI6L2dgz2IZE
	vK5HZ5ZXTQyC8HlvxRaqdbek/qKgXTo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KtSb694V;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=07i9D6CY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Xtmy561O;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PpfP8HUb;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778594871; a=rsa-sha256;
	cv=none;
	b=LHaR3ZlqDGv+dxendd3xvk9E8q8IBa26DVVgp4rTYdtmyybMe6KaIB9qeVjCVAw4+g6qoS
	RHIJPIpLejTYyhngRLPfzeJSEzGTrFVwLM2cqsuXAXkmQYUywj5MqV8M9X+7ZtR+ylrafb
	v7kOOSc3L5GU2PjEmibeLUyNQeDhGG4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0401F6AA91;
	Tue, 12 May 2026 14:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778594868; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=myGkdDpGAqSiI3QSlhAm4i2daq28KmwVMURWssNipPI=;
	b=KtSb694VmCELXmqgZnPEngDMakMrNBERjnMeDodHXAGcR1VX270vKnWiShrPFfQN1o2txZ
	whmdsE147Tk0/6LqrWJFwEitO+pYJ6utGWhXfh9veEmD8OpICdKQTNJjT5hF1fmtTKPDwy
	4bT33pRnOXdwYf9LbvwQ7fBrxAcynqw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778594868;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=myGkdDpGAqSiI3QSlhAm4i2daq28KmwVMURWssNipPI=;
	b=07i9D6CYmzIzsiMbTH5lPWkp/Giu/rOle1pHFnATcajbEchkGrLj9gR9taGZyoFk8qg6BH
	AA+7m7MnYhjKg9Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778594864; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=myGkdDpGAqSiI3QSlhAm4i2daq28KmwVMURWssNipPI=;
	b=Xtmy561OWIEx/0hUNMgGEB5yCeyA6eo7nwzyDR8Y6B6zw3EIWDohibr9IndC9YFAb0/p1O
	d2dFILmeQiD7g/u7WVcggmmMhgJEEYiN5iJjG5j1O41w/H7EGtwLAODky1phZIOz19pKzK
	Xed/0jhml+oU5s2CYopsOFhUUW7ueSY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778594864;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=myGkdDpGAqSiI3QSlhAm4i2daq28KmwVMURWssNipPI=;
	b=PpfP8HUbJnFTzcmVurynbgcHfOnITcrYBRWcJZcHTZTMv2/HUe0aiAt2D2lXGDKbIWwDVZ
	oiGltw4Lpnp3ctDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D93FE593A9;
	Tue, 12 May 2026 14:07:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IMMCNS80A2oGfQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 12 May 2026 14:07:43 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 83CD8A07B5; Tue, 12 May 2026 16:07:39 +0200 (CEST)
Date: Tue, 12 May 2026 16:07:39 +0200
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
Subject: Re: [PATCH v7 2/3] mm: track DONTCACHE dirty pages per bdi_writeback
Message-ID: <6hh3mzfix2bpddij7zrhm7n3wcwt56vmuystjw4r7zfzj4ut4b@hsxatltdleka>
References: <20260511-dontcache-v7-0-2848ddce8090@kernel.org>
 <20260511-dontcache-v7-2-2848ddce8090@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511-dontcache-v7-2-2848ddce8090@kernel.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 778321C000B
X-Stat-Signature: hkrxbxbb36ae9m9hu1syyt53wa783gog
X-HE-Tag: 1778594870-359997
X-HE-Meta: U2FsdGVkX1+rPt2unO463YJkz1oOAb19gR3N7f7bvtz4Hlr/LoQXDoK3SiVRHAbikXrc0GyqKn+ieWmjXf5lTOkf6h5YSV5T2zh1zkvFxDh3nXWEJTlcy3AKI82J51r3o4WY6yFXD+Vrj2hi/7Ph6SmBhmRnhM9RRvuoQHdEVI+gTDyiW1jixGk17eU29DPgDUlLJHiuYmLx95T5GFaaGl9CuMrkzlR/4d/swRw79tbNt96rG+qojYfaA3Cz5KYuEhl26s4dJnSpklc/8d9Y2M46uc8Q3JxdSCAMLTy9CdQeY+YNkJPwqpeRV3VRnzSPmzwTvXPCMv9SjoRdxF9dYddlR3uFSU2fdy4Riej6bncewA3FpzrvGVBom/RgHAhTFdiuuITE0rxfNkSTIc31xF2xe5pmaZou29bRsWxr5Rt10ePAQseGIxdB2ADfw2jd1Q85dgzXOUFvEm5Q5KcHq8TThQ6OVAUqX0/+9Ewe4WPsmRYnUbzqz/TLnf6SWoy6ggjPVraIHqACKvr3BVZIZ9/Lqu9Rqtj5cqFxKO6njrizW+5e2l4ezDqRyUGl2H3Rd8YGGDIvezs6ov7bkunugKwbkRzXdCbBhyC19fJjy2UWXLmCxw98tYd0OYUdhFGYZQf3T6pQP4ZeBUNTVXytpOKrDoUS9OekFqkAtObPThXNjm/ZNVF4WmqcxdRVB4upni9VkPyVY2U9SYASS+DftepjuHqQGzPCW3UtTDCt3BE+wE6bRXYE5ppLNAFi5pX47GfrRiZv+Il/RpDVX9OovRJNSWeWGrvLchcXh+GJdyAtLxnHjnNTVz+GqmK7FPrCKHlJIJ9yFNquI3oOWpOGLj0i4SX5nSpXGlzSdMJcU33QBF/RYzdmyzm6RXMWTVOmITBA8tGT9gvMhd9805kw1telBmcLJNLbyUvr1gn/i/B0ZGMnWKR4Vztq7WMuOOrG/4NJSx3MUXM6aizFHyf
 qm4WoLCp
 4qbkT3d/LwoTvu7xYI1lLIsTsVj7ZLd+hAtzAmSzu+rDGoIWXWD+tKEVRyLLO7Ep2maOf4yc4kHudsorZAQWNBu28BoO6M4x82XuXrASQGAdF7kisHWdNQ/LtPYHh1n2pkYp9+Sp3iYQzDMeKbe9d1Uzsni/xvk+l3ZvQNTbwx7ohUs1C3IVUWc4aXTbDA0pWyjoFjQmWhOp9//KUk4PFWpMI+XMTV6Hk6J1bci8Fq0WThPaQZ99MJx0H/1cSsKKOwOuLyYlBAO8LbM2ZmRYbpuA0MDNIipUGmp8J0hPgmRiij/O4s9CBewHFG3PSU+wNKI6oQ9xqyLUV7z4zhrd8UvH9IzdZxt1bzDNnoEko8hV7PA4O0LDZ3VxSG9RhzKAJZhr+zktK/pRb9OhlKPv9GJYVMH5LcHTokIYKw+Dp0i5W88LsfZoaJrFWtVdyN3qXdvAq/2BzrWJXDqXrY0b08/NGBG4sjK+xCzJx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 11-05-26 07:58:28, Jeff Layton wrote:
> Add a per-wb WB_DONTCACHE_DIRTY counter that tracks the number of dirty
> pages with the dropbehind flag set (i.e., pages dirtied via RWF_DONTCACHE
> writes).
> 
> Increment the counter alongside WB_RECLAIMABLE in folio_account_dirtied()
> when the folio has the dropbehind flag set, and decrement it in
> folio_clear_dirty_for_io() and folio_account_cleaned(). Also decrement it
> when a non-DONTCACHE lookup atomically clears the dropbehind flag on a
> dirty folio in __filemap_get_folio_mpol(), using folio_test_clear_dropbehind()
> to prevent concurrent lookups from double-decrementing the counter, and
> guarding the decrement with mapping_can_writeback() to match the increment
> path.
> 
> Transfer the counter alongside WB_RECLAIMABLE in inode_do_switch_wbs() so
> that the stat is properly migrated when an inode switches cgroup writeback
> domains.
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
>  fs/fs-writeback.c                |  4 ++++
>  include/linux/backing-dev-defs.h |  1 +
>  mm/filemap.c                     | 15 +++++++++++++--
>  mm/page-writeback.c              |  6 ++++++
>  4 files changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index a65694cbfe68..32ecc745f5f7 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -432,6 +432,10 @@ static bool inode_do_switch_wbs(struct inode *inode,
>  			long nr = folio_nr_pages(folio);
>  			wb_stat_mod(old_wb, WB_RECLAIMABLE, -nr);
>  			wb_stat_mod(new_wb, WB_RECLAIMABLE, nr);
> +			if (folio_test_dropbehind(folio)) {
> +				wb_stat_mod(old_wb, WB_DONTCACHE_DIRTY, -nr);
> +				wb_stat_mod(new_wb, WB_DONTCACHE_DIRTY, nr);
> +			}
>  		}
>  	}
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
> index 4e636647100c..179f2886f8c0 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2052,8 +2052,19 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
>  	if (!folio)
>  		return ERR_PTR(-ENOENT);
>  	/* not an uncached lookup, clear uncached if set */
> -	if (folio_test_dropbehind(folio) && !(fgp_flags & FGP_DONTCACHE))
> -		folio_clear_dropbehind(folio);
> +	if (!(fgp_flags & FGP_DONTCACHE) && folio_test_clear_dropbehind(folio)) {
> +		if (folio_test_dirty(folio) &&
> +		    mapping_can_writeback(mapping)) {
> +			struct inode *inode = mapping->host;
> +			struct bdi_writeback *wb;
> +			struct wb_lock_cookie cookie = {};
> +			long nr = folio_nr_pages(folio);
> +
> +			wb = unlocked_inode_to_wb_begin(inode, &cookie);
> +			wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
> +			unlocked_inode_to_wb_end(inode, &cookie);
> +		}
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

