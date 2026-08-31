Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87586C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FAC56B008C; Mon, 31 Aug 2026 05:59:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D2B56B0095; Mon, 31 Aug 2026 05:59:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E8C06B0098; Mon, 31 Aug 2026 05:59:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 56B046B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:59:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E3FD040416
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:59:51 +0000 (UTC)
X-FDA: 85161118182.16.BBC2610
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 79FA3140004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:59:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="dW2nKgD/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KmcOhO0z;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=r9+5dkfj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vayhPUMM;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788170390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9NwnR8kMEaTJTYkoxBQW5G3izVgqGS7StBEwaJ2omhE=;
	b=DZQyHb/6Rb85fZ1EeU5HjFNQO35XZcviQYZyRVl7XQFXN9+p3iC3ajNnUlBecnmvBFk447
	jq3Z0rwRNA6VqwuYWKfU6z47Ho7INjchh1iXJ1CIdhwMzK0GN5UsuUSPeSC0eFd43mFEHp
	VtssmybCdv6H+NlDcO1WN2XtPmDPzSo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788170390;
	b=qK0VMj6ujmoNzoerkqLSUTNmZZQwCWhgZCh1s/6YfUmqf4Vgex4u9KmLDNad7xwv0SlBR8
	oHbQee9WOHy1T+DWYd7qAS2aULyfqxbTdlZFaCCSCfKhcldXNdmKg2aEjcTsXR2RcLvTrV
	2Oed0j6AkdSpQhuyiNG71VOMaoPlo4M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="dW2nKgD/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KmcOhO0z;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=r9+5dkfj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vayhPUMM;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BCE4E1FAAB;
	Mon, 31 Aug 2026 09:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788170383; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9NwnR8kMEaTJTYkoxBQW5G3izVgqGS7StBEwaJ2omhE=;
	b=dW2nKgD/72GHfPDPSkIXHWa4TQlW9zo4m5ZJZt18et8r8SpFKwl3fSOhDCUde4WrGHhX1k
	HthafQUnqSZwcZK8Hdcs9U36lkHKEFP7wcuFYQxjwio2w5aV+Vt72W3ZXcuri1mhWwTdMf
	dP+uDJvuZa7oiZHnAx8jWbEbvlydq4E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788170383;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9NwnR8kMEaTJTYkoxBQW5G3izVgqGS7StBEwaJ2omhE=;
	b=KmcOhO0zo72Y4OHAa8RvceB+zt8rPD1OtYKdTL75AERgXOIdssNGME6lJ09SSLwG+HwP6H
	WPniXvtYYYJ7buDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788170379; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9NwnR8kMEaTJTYkoxBQW5G3izVgqGS7StBEwaJ2omhE=;
	b=r9+5dkfj5zv2zJtacQf2HZljTAw/25dZVX8yvLicsAhmPie/8z4lpxN7aqnWa4UN22X30z
	VqtIUOoyqHhMMot3U+vyaxuyjejWrLJMumjOQ8E3Br8VcDxJXDazwa4lekbK2hbqemViUC
	LVdcCgmonttzkdd8su0ehz6W1kl120w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788170379;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9NwnR8kMEaTJTYkoxBQW5G3izVgqGS7StBEwaJ2omhE=;
	b=vayhPUMMZNg3rW2xgsNzuc/IUtzfsyNI4zFxAL3JrlK7XeBEytvIqcNyZdaxkU8YXY20/9
	vR13eZLPIsgFyYDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 98AE413694;
	Mon, 31 Aug 2026 09:59:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2pBAJYtQlWp8cAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 31 Aug 2026 09:59:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 29D40A13B5; Mon, 31 Aug 2026 11:59:35 +0200 (CEST)
Date: Mon, 31 Aug 2026 11:59:35 +0200
From: Jan Kara <jack@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <christian@brauner.io>, Jan Kara <jack@suse.cz>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Theodore Tso <tytso@mit.edu>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, ntfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/9] mm: Improve memalloc_nofs_save() documentation
Message-ID: <wriwrbwg3sx5kpl6s7yggam5x7ljml2sul5rz4dm7ftbyyoqyu@yqjepgxxtd3g>
References: <20260830041901.2668-1-willy@infradead.org>
 <20260830041901.2668-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260830041901.2668-2-willy@infradead.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 79FA3140004
X-Stat-Signature: ahwx1ith5j3rqm8mcgohy9h6m11cstqm
X-Rspam-User: 
X-HE-Tag: 1788170389-635598
X-HE-Meta: U2FsdGVkX1/DeMdsvr0HwcsDVpoQXAtVVlpxs1AppWk5K09ziMzLWhEI1VEy9Za3Xg3rE3CqsDiKj6ZyJ7j5E5KbUYlbYmnge61CP4XPoNihL7Bxw7rR7V91paV4AtSE1Nl8VHwTHZSI0ckcLQTGrcSezu/fJAek1K266bPG9/qICEygxM9flnA2sv6QKbfFj9ut9KmLRZtGtb2PKqJM+N82zt0+brmkjj4xe4zytLrAYx6tWuLzosar1HyjVWp4KwDHgi2k/sTZukTGB5jhIKjvzxums1aw77iwCM8cd9bSyhzcr4iT5+t/hInuBmVn/ilTqZZ7M0dgSQ2t5Y+sHTwHKD7sYyXNgZXpvfkGZ9xm7R+g4NBpSja3adh/W+9BI3wKAuLnv0HTTXedv+3+kqq7PeraqY1FqDgdLJ1siQ+ix3TYAMFu5YtmsTXiwh/N3NNYguDIHQxVPHHibUur8P+4Wl6wVhsec2ywDYBFMYnc/TUcnK6Wn8FqtRaTHmzAXRj29IDtBcq0/uaX+Q/9h75drGN9b80hidTXoawsk65zX7qZI3lFAMF3kRpM8iYT1p0ryXFJQk+llFb8wFXsR51DzKYCQhyqjrGUq721l5s4nSJWCtDUUDlsegoYKvs6/qkEYjep5DhLilYeW5lqPTvxjAjEdHXjGVtyffMCuvhTM+bGbWmeZn6N4nyON9PHWmrHyz4r+qZcQh4s/0i80Z0KXa8yckFrBxk25T2t9DmEGU3QjC+VP7Y33etHTqEoWNDfUVZtZ9IYuSX4S36QPJSbxiR8S2Ja4CUxTXr6x/WkVpAWvdXW7nKDWAFeD/LQG+VVITm1EXQ8G3C902fWAgZAKSThqKViYQW5BtF4XHNozNNBG3YjPP3wVtOiYIJmlYHKnDIxVFPrXAaL+jSP1L2OG0iK5X6T9XbMhulJTdMVSezA9KIhRQXNk+ZJuliGYbetkBO91kYplXlm9De
 eKLMScTm
 vV7WQJ6h3yrxhZyG84j0u0HJulaw+jk8OZVHEjtutpN8bWamrGBB5J5TKTtE3uxYZIUCzFXE1KXvbDzAHB4D45h9DYJkkxUCcJhwEC2tb0cefXODtPAMkFHlo7KD/k/whKHIDmeZskM+fgEZxuPxARroNzHjWhwK37AR8qWfEscbfZnrVeZME9qb38nVPy6MRmV9W9RSp3S9H3mfD09dg5rUeKpTvrke7qq2YThZhFoJ83aviYE7XnOutSMcCcxvi9qbN2MffwqULtntjJ+jvOvOchsCjMFiUY4HwYKSs4JAVnktkVCiXHPcZXLctCUuwn7qYJfzymvfaPMfIyPX3q8gAKY+d3y8cXoAZaKXkuxwqi50HzK9jmIjbFllbWnRiYs9M6Qi+Mxuwe0unvEAdj4z75kmlSATpXkztUWZpVk1fu75mG/wvDVpxtuTjooQwoR3vrddQIr0TdgZJzdVEFjJTst/hk1au5jSWObzMljrRFDT8/WVGwOT+ne13KDVS6H8k2aVhRhlu2pM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 30-08-26 05:18:48, Matthew Wilcox (Oracle) wrote:
> Talk about why someone should call this function instead of
> what this function does.  This makes the long comment in mm/readahead.c
> obsolete; replace it with a comment about which case we're protecting
> against.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Yeah, I think the documentation is better. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/sched/mm.h | 31 +++++++++++++++++++++++--------
>  mm/readahead.c           | 14 ++------------
>  2 files changed, 25 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> index d7c6a942aa7e..f76be1141b06 100644
> --- a/include/linux/sched/mm.h
> +++ b/include/linux/sched/mm.h
> @@ -372,13 +372,26 @@ static inline void memalloc_noio_restore(unsigned int flags)
>  }
>  
>  /**
> - * memalloc_nofs_save - Marks implicit GFP_NOFS allocation scope.
> + * memalloc_nofs_save - Prevent recursion into the filesystem.
>   *
> - * This functions marks the beginning of the GFP_NOFS allocation scope.
> - * All further allocations will implicitly drop __GFP_FS flag and so
> - * they are safe for the FS critical section from the allocation recursion
> - * point of view. Use memalloc_nofs_restore to end the scope with flags
> - * returned by this function.
> + * All memory allocations between calling this function and calling
> + * memalloc_nofs_restore() will be prevented from calling into filesystems
> + * to reclaim memory.  Clean page cache memory can still be reclaimed,
> + * but (for example) inodes will not be.
> + *
> + * The primary reason to do this is that the caller has taken a lock
> + * which would be needed by FS reclaim.  While we could theoretically
> + * call into a different filesystem in this case, it can be a deep call
> + * stack so it is better to avoid all filesystems.
> + *
> + * Filesystems often choose to incorporate a call to this function as part
> + * of starting a journal transaction.  While not a lock in the normal
> + * sense, it has much the same effect as nested journal transactions
> + * are either prohibited or expensive.
> + *
> + * Also call this function if you need to allocate memory while holding
> + * a file folio locked.  High order allocations (such as those requested
> + * by slab) can trigger compaction which will attempt to lock the folio.
>   *
>   * Context: This function is safe to be used from any context.
>   * Return: The saved flags to be passed to memalloc_nofs_restore.
> @@ -389,10 +402,12 @@ static inline unsigned int memalloc_nofs_save(void)
>  }
>  
>  /**
> - * memalloc_nofs_restore - Ends the implicit GFP_NOFS scope.
> + * memalloc_nofs_restore - End filesystem reclaim scope.
>   * @flags: Flags to restore.
>   *
> - * Ends the implicit GFP_NOFS scope started by memalloc_nofs_save function.
> + * Ends the implicit memory allocation scope started by
> + * memalloc_nofs_save().  This may not enable access to filesystem reclaim
> + * if it was already disabled at the time memalloc_nofs_save() was called.
>   * Always make sure that the given flags is the return value from the
>   * pairing memalloc_nofs_save call.
>   */
> diff --git a/mm/readahead.c b/mm/readahead.c
> index 6e5563290287..9c116d4ba963 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -227,17 +227,7 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
>  	gfp_t gfp_mask = readahead_gfp_mask(mapping);
>  	unsigned long mark = ULONG_MAX, i = 0;
>  	unsigned int min_nrpages = mapping_min_folio_nrpages(mapping);
> -
> -	/*
> -	 * Partway through the readahead operation, we will have added
> -	 * locked pages to the page cache, but will not yet have submitted
> -	 * them for I/O.  Adding another page may need to allocate memory,
> -	 * which can trigger memory reclaim.  Telling the VM we're in
> -	 * the middle of a filesystem operation will cause it to not
> -	 * touch file-backed pages, preventing a deadlock.  Most (all?)
> -	 * filesystems already specify __GFP_NOFS in their mapping's
> -	 * gfp_mask, but let's be explicit here.
> -	 */
> +	/* Allocating with locked folios */
>  	unsigned int nofs = memalloc_nofs_save();
>  
>  	lockdep_assert_held(&mapping->invalidate_lock);
> @@ -512,7 +502,7 @@ void page_cache_ra_order(struct readahead_control *ractl,
>  
>  	ra->order = new_order;
>  
> -	/* See comment in page_cache_ra_unbounded() */
> +	/* Allocating with locked folios */
>  	nofs = memalloc_nofs_save();
>  	filemap_invalidate_lock_shared(mapping);
>  	/*
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

