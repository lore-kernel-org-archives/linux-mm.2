Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C00A8CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 11:35:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D53F28E0006; Wed,  1 Oct 2025 07:35:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D05258E0002; Wed,  1 Oct 2025 07:35:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF3218E0006; Wed,  1 Oct 2025 07:35:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC1548E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 07:35:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 540831A0923
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 11:35:49 +0000 (UTC)
X-FDA: 83949340818.01.66ECE10
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0A4FA4000D
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 11:35:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="szEo/DGw";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2XT83wDD;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="szEo/DGw";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2XT83wDD;
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759318547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WDEo3ASRhQvw+aReLbl1V7zNFjYQm+NIo9wkgd7UiqI=;
	b=SqC/SWeRG63dfB+VQL+rrOXxyUQonpZOA77i6JjfYFCbHtiOk94IfDPYG79MgoFOquYC3U
	0XVpiERUiWzORrrYq/33sBeIS2Xhp3ofnPS7Uv8buLKp5tpJQukmQVDwtl1tBNUpTBJaLJ
	FIkAo0R72ptgo3K/Y+wppc8/47cCTpw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="szEo/DGw";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2XT83wDD;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="szEo/DGw";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2XT83wDD;
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759318547; a=rsa-sha256;
	cv=none;
	b=7Khx8JmwxqkxLX/M1wDnQamNWzbjoxk964akGCg+cSKyS2i4bCUM7P52+6OhSq5J49KjMW
	tFCvHlSRG2tbfnn3u2Rkk+s6zdEv0WEsj9ntqWhXwUcWfT7+ZbjaxI8hrauUy4JnZVkQ7v
	0JR8X+N5TG6SizPAusvVQVCnZPFK6ss=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 186F3336CE;
	Wed,  1 Oct 2025 11:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759318544; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WDEo3ASRhQvw+aReLbl1V7zNFjYQm+NIo9wkgd7UiqI=;
	b=szEo/DGwXESSdOXMZl+okmUt/nifNcaF5R9rEV1NVdU9gFqb0iIpCfTfcPnqUn6cKvxjf9
	1MuzlNiReDOz+zcvKz+UBUmWUddhPDEpUNfRCFE4kIiWM9tfc+/YVkxNkXUJ0Frgkvtmhn
	2C0CaHeu6U8oxKI8bu0x4R56SO88V2I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759318544;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WDEo3ASRhQvw+aReLbl1V7zNFjYQm+NIo9wkgd7UiqI=;
	b=2XT83wDDRKig0YV7MR1f4REKgD1p1C9m27DggWEXFST8WaxoB80Mo0C/3tvTQRjttv6rqb
	vjLKWvWLOcHLc6Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759318544; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WDEo3ASRhQvw+aReLbl1V7zNFjYQm+NIo9wkgd7UiqI=;
	b=szEo/DGwXESSdOXMZl+okmUt/nifNcaF5R9rEV1NVdU9gFqb0iIpCfTfcPnqUn6cKvxjf9
	1MuzlNiReDOz+zcvKz+UBUmWUddhPDEpUNfRCFE4kIiWM9tfc+/YVkxNkXUJ0Frgkvtmhn
	2C0CaHeu6U8oxKI8bu0x4R56SO88V2I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759318544;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WDEo3ASRhQvw+aReLbl1V7zNFjYQm+NIo9wkgd7UiqI=;
	b=2XT83wDDRKig0YV7MR1f4REKgD1p1C9m27DggWEXFST8WaxoB80Mo0C/3tvTQRjttv6rqb
	vjLKWvWLOcHLc6Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0B64113A3F;
	Wed,  1 Oct 2025 11:35:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6LjAAhAS3Wi2bAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 01 Oct 2025 11:35:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B01F8A0A2D; Wed,  1 Oct 2025 13:35:39 +0200 (CEST)
Date: Wed, 1 Oct 2025 13:35:39 +0200
From: Jan Kara <jack@suse.cz>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: readahead: make thp readahead conditional to
 mmap_miss logic
Message-ID: <hm56lqfeqcpjjpwkzuo4ktv7ayt763htehpi7ie2d47q52gm3w@mgbj42ivvv5g>
References: <20250930054815.132075-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250930054815.132075-1-roman.gushchin@linux.dev>
X-Stat-Signature: 96hw97uggz6ef38i58ab8kmc36mnhtfn
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A4FA4000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1759318546-101420
X-HE-Meta: U2FsdGVkX1/yN3Z43an3scpgLLk0+/dmvYyeLn112HQy513DvkJo8h9je6r0KrkbaB+hHiCjkbgpOWn1GGf69BD+2i2KWUe3KfAmrPtt7CjIceGJ06NqCEvRJT2zM899mlJoMLiJzcVAwVchoAwxKFgemzKA+XIeUiZeEWF4lZfL+yxChMdRx7MiArWhD3SOQbsBCDYMPZCwg31urh3lI88i+ZINfI10VPtMrnTkBBCd7fyA8E68ie7nwRQ+0Ihsw9+DKFrc4s0v44kCmBSVaIV8MLlmpKvXszZUCdYMtt8RyXI3ZCHdY4k6X4vWUJMUh0WidLt6Vwacv7yYjFMGda9zKK7sRn0mORCzLXftrsrnMrlG/li2PDxEz9CDEOwSzUmVm2doXpT2gsaEDlzriTkqWjLNl62izwCyoRvoe4cBFsduP5Eiq9tebzvbZL2e11/S9GPHw5BHCwPRLfD+bxXdoAyaLu5wcWFzXWLyfR8VcUFHLWlMtWJEQs9BqIFP3Scw0+aXvn4K7GcFtdUP87PJmGNYnNEutTH27MaqpeD070/IoFw1BwZO5ihbxPpn5ZaccxcREuM/BnGWoz2yBKP3v60O+AO5lr7LG2BWlaohMUyHBbM1NiRym4NkPdD29/kT2q0rmirLrNsBEQtZbN8ywtL9f8ODzSjkcwOgpCJFSWpdjBk+g6AAQi3HwS8+TKM5q/XBxstzsOpkzPugJXbSdK+I5HvIOe7SHqAB0eYCfmz/c3KL6JXQi4TYeSPX9fIV4ZWmksOLKCtU3ocy1GH0nk/catQujKuSz3WUV/BiJ1v0NBQT+YG9d9orIkz2k7f0dR5Y+J2WMJyXPkoXe2tOsoEGk2HU75ywghfN00JylEev1Ag0uh4rMNHbfQY8hI63hQF8CPvwj8EJIzO7by89geH7Zvg0pv4Pcyzv7D4Is720pUeQc8rtElQbQa5ifD2tCO3pggbLUTrx4hy
 gx6GK4Eq
 DdttYlc1SX6KmaskBvtiFKjDDAPG8OOp0ooVywIvjB0encK29ZkMMeO00hhilkDF7Q8EkCglDZvCg5pzmlbSy6elSW9vpGSorL3W9Ze2VzwunB8q1EosNCI08lku2C726KcwmrOK0F8bQ/TT48pZ+RiL2qMzS06RTOfOh+crrp5/Mwpud6SBeelRdvBful78bGuk4lz1dmSxKzRctuTbY5dp07DAi1rlzjGnmqMwoi5/9T/9/2BO7U23gLheR/XE7qRh4NFCfeHZ7vjoMq/brRA3rOGZpPFD4pssbC0v9aAuw3Vmxh6WwBAoO6/pwsuCoIBNoRWKnnEaD7PfqrM5EgsO7Cb0t9vTRvLZ1lv+aUXqekvKjkZ84mvBKBDm8j4gdU7vue3Dk8UYxC3cayYyemNWLm6WHQjpk4VN+rtnYUwPz4MZsSnBMRBLIXcuV0iFwDKsJK9c9bMdaMrTN6vzP31fNSTxmT1GopY/179Rluw3BDJ9n92Kh+qB7cQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 30-09-25 07:48:15, Roman Gushchin wrote:
> Commit 4687fdbb805a ("mm/filemap: Support VM_HUGEPAGE for file mappings")
> introduced a special handling for VM_HUGEPAGE mappings: even if the
> readahead is disabled, 1 or 2 HPAGE_PMD_ORDER pages are
> allocated.
> 
> This change causes a significant regression for containers with a
> tight memory.max limit, if VM_HUGEPAGE is widely used. Prior to this
> commit, mmap_miss logic would eventually lead to the readahead
> disablement, effectively reducing the memory pressure in the
> cgroup. With this change the kernel is trying to allocate 1-2 huge
> pages for each fault, no matter if these pages are used or not
> before being evicted, increasing the memory pressure multi-fold.
> 
> To fix the regression, let's make the new VM_HUGEPAGE conditional
> to the mmap_miss check, but keep independent from the ra->ra_pages.
> This way the main intention of commit 4687fdbb805a ("mm/filemap:
> Support VM_HUGEPAGE for file mappings") stays intact, but the
> regression is resolved.
> 
> The logic behind this changes is simple: even if a user explicitly
> requests using huge pages to back the file mapping (using VM_HUGEPAGE
> flag), under a very strong memory pressure it's better to fall back
> to ordinary pages.
> 
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: linux-mm@kvack.org

It would be good to get confirmation from Matthew that indeed this
preserves what he had in mind with commit 4687fdbb805a92 but the change
looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/filemap.c | 40 +++++++++++++++++++++-------------------
>  1 file changed, 21 insertions(+), 19 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index a52dd38d2b4a..b67d7981fafb 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3235,34 +3235,20 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>  	DEFINE_READAHEAD(ractl, file, ra, mapping, vmf->pgoff);
>  	struct file *fpin = NULL;
>  	vm_flags_t vm_flags = vmf->vma->vm_flags;
> +	bool force_thp_readahead = false;
>  	unsigned short mmap_miss;
>  
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  	/* Use the readahead code, even if readahead is disabled */
> -	if ((vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER) {
> -		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
> -		ractl._index &= ~((unsigned long)HPAGE_PMD_NR - 1);
> -		ra->size = HPAGE_PMD_NR;
> -		/*
> -		 * Fetch two PMD folios, so we get the chance to actually
> -		 * readahead, unless we've been told not to.
> -		 */
> -		if (!(vm_flags & VM_RAND_READ))
> -			ra->size *= 2;
> -		ra->async_size = HPAGE_PMD_NR;
> -		ra->order = HPAGE_PMD_ORDER;
> -		page_cache_ra_order(&ractl, ra);
> -		return fpin;
> -	}
> -#endif
> -
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> +	    (vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER)
> +		force_thp_readahead = true;
>  	/*
>  	 * If we don't want any read-ahead, don't bother. VM_EXEC case below is
>  	 * already intended for random access.
>  	 */
>  	if ((vm_flags & (VM_RAND_READ | VM_EXEC)) == VM_RAND_READ)
>  		return fpin;
> -	if (!ra->ra_pages)
> +	if (!ra->ra_pages && !force_thp_readahead)
>  		return fpin;
>  
>  	if (vm_flags & VM_SEQ_READ) {
> @@ -3283,6 +3269,22 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>  	if (mmap_miss > MMAP_LOTSAMISS)
>  		return fpin;
>  
> +	if (force_thp_readahead) {
> +		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
> +		ractl._index &= ~((unsigned long)HPAGE_PMD_NR - 1);
> +		ra->size = HPAGE_PMD_NR;
> +		/*
> +		 * Fetch two PMD folios, so we get the chance to actually
> +		 * readahead, unless we've been told not to.
> +		 */
> +		if (!(vm_flags & VM_RAND_READ))
> +			ra->size *= 2;
> +		ra->async_size = HPAGE_PMD_NR;
> +		ra->order = HPAGE_PMD_ORDER;
> +		page_cache_ra_order(&ractl, ra);
> +		return fpin;
> +	}
> +
>  	if (vm_flags & VM_EXEC) {
>  		/*
>  		 * Allow arch to request a preferred minimum folio order for
> -- 
> 2.51.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

