Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 302AACCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 12:31:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 768F08E0005; Mon,  6 Oct 2025 08:31:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7196A8E0002; Mon,  6 Oct 2025 08:31:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 608888E0005; Mon,  6 Oct 2025 08:31:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A2528E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 08:31:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 097AF13B4E2
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 12:31:15 +0000 (UTC)
X-FDA: 83967624510.14.AD01528
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id A56B110000F
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 12:31:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=J7bxAt3E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=W3epdj9H;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=J7bxAt3E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=W3epdj9H;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759753873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EP7uvhEtK4igyHtfrvI5g+ND5YjZHvOvQglSG3RCGgM=;
	b=fjnnoBWJPm67rpkPPPVM7KvDGmZZs1AmV1Ckhq8zgKXcJ3O3bjtAPcX27qYRpsyvXTfibV
	N7Mr/UtN9N2rNtDs7rdF+FJrPrNcTV2ShCC3UMYNYgHK2JNChDsvZI2SzvCqFsk6051Xfs
	fQBNPECxFsayoZW0tjrqDV6nNfrfQv8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=J7bxAt3E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=W3epdj9H;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=J7bxAt3E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=W3epdj9H;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759753873; a=rsa-sha256;
	cv=none;
	b=meDVnN/Fxg3m6YVDFo3AbVteGccZ7dEh7PtNpolKa7z7vDz1h6jypr4PI5TvxwCzG944La
	Q3SEmktDTzUNViFatTzf+aNgdq5YeFjdpowVnS/rQxavBJ+2kBd3aWHb8jnUPIjF8jpzft
	J4SRS6FViOaJO6K52NmbRfoRAC5pLlw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 234DF336EF;
	Mon,  6 Oct 2025 12:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759753871; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EP7uvhEtK4igyHtfrvI5g+ND5YjZHvOvQglSG3RCGgM=;
	b=J7bxAt3ELKNOAW28bhqZq0mY0RJEYp7iq7J4R6EqC7DMrUv0hGCYc+ly2p79RcqQ881Ynk
	OyZ+VZF8grYf49d3xn4RmOtlvNhPbMTpOb7mqdy1d8yCW0kAEg8Ui7kQSxIFJbsHFUa1yv
	8HdTTyzrA6M8n22eannfyX8JdTJcxQM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759753871;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EP7uvhEtK4igyHtfrvI5g+ND5YjZHvOvQglSG3RCGgM=;
	b=W3epdj9H4NDcUQVz0ue68CavaFu/fe5hEBIGypSP6KhRt33Z8dguMbvpUHfKuaz9b6dOR2
	VwybxvJm3x6v86BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759753871; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EP7uvhEtK4igyHtfrvI5g+ND5YjZHvOvQglSG3RCGgM=;
	b=J7bxAt3ELKNOAW28bhqZq0mY0RJEYp7iq7J4R6EqC7DMrUv0hGCYc+ly2p79RcqQ881Ynk
	OyZ+VZF8grYf49d3xn4RmOtlvNhPbMTpOb7mqdy1d8yCW0kAEg8Ui7kQSxIFJbsHFUa1yv
	8HdTTyzrA6M8n22eannfyX8JdTJcxQM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759753871;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EP7uvhEtK4igyHtfrvI5g+ND5YjZHvOvQglSG3RCGgM=;
	b=W3epdj9H4NDcUQVz0ue68CavaFu/fe5hEBIGypSP6KhRt33Z8dguMbvpUHfKuaz9b6dOR2
	VwybxvJm3x6v86BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 131CC13995;
	Mon,  6 Oct 2025 12:31:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bUWjBI+242i2dwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 06 Oct 2025 12:31:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B1508A0ABD; Mon,  6 Oct 2025 14:31:06 +0200 (CEST)
Date: Mon, 6 Oct 2025 14:31:06 +0200
From: Jan Kara <jack@suse.cz>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2] mm: readahead: make thp readahead conditional to
 mmap_miss logic
Message-ID: <e2zblaknfnzjtlo3df4aozoxuir6zgnycdjj4ywbu7rsnpw6hr@ocemkpucjd2d>
References: <20251006015409.342697-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251006015409.342697-1-roman.gushchin@linux.dev>
X-Rspamd-Action: no action
X-Stat-Signature: 6gcq57fkzd8do9bb59517ms963gxeudu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A56B110000F
X-HE-Tag: 1759753872-716421
X-HE-Meta: U2FsdGVkX19DLBMZj4lbRNpB93XsqLChduDmE4AvQR3suS9cNt3wMlYJAGEHQb+lE/WuN9mF8tdsHDYiuq26DVxNwH3OlARtdQQuNMtS8LzSrUvx+rk868WCakJKnk0Q0Dr1x/T/+l0s8M/5tkS2UDXQ/D/f9J/uWgeHtJN4kv5EXLkCt/h/h0e31GsfCuMAkqM9lkP2qpZq1b5u8S130k21q7FSzCMTHckqUhSM6TaBP38GfvI2Mnulehiiiem5rI1R9b1ooLvsVp/prZV5JdPXbk1zj0lxdiVInNEzPmPwUNr6fzHWPtSpGpWZQpk3ZsXZ2LT7G0/XzKJepbDXNoIbXQTFxtqr0QMHUxIOVGucip+vUpRNTNKDNa6ZpKWc9KGPQGshTNEIawzg/LseyUTyp75C6Q8LXYPUG77LagTGGvrZhuDcvvTf5Dw6DVIr3v2it/zyuZDm2IgBjetcGkrymZwZ/dY31V4V6soqU+4l8Ub1/ZppxNo64pqiKSER4tkDqCmB7MYfEoZcUyfRxHcE1fKoYFasoFguhqZyLDPRqQDLjBfD5XMeFDZ4lvUSiKLn266ch9rDxk/K/uRA192qRbj2SQjYPpmUGfmqMMQcg3WlVBmPfMdbvoynAVVJY+0aj4/9tgCoomWw3aYTAMv9B1/YMvhz7xwzUX6OmyUWWWXXdbBvxx+/Ykl5wPEDDK1/tpeqgmXeX+lisdpPbvCfkecLFhjouyoTKZ9qgYPQ5/0BPu1QQu0DG5/hgUtOga+CeN5XW4CJXUgRlau0G+KXFx9MMnVpnIkEnQAKta22cBG/p9xPUywCYbb9WLPgLOTXq9x+0QGvJkvSiBPljHtQ5LMcGcva4G8ND0c3PqNGlu1T6VfWyrkEGFPHH0dRjSUfD0r2oGUQyER8gTrVbKaPg+PEh70Ex3xzDSDS3xv6LEYHChkq1AnhBKdqYvqGZ6ZMEeMzPmoCg9obOQo
 YqiJ+mj6
 Q+OcIA5TMzbJP3aDiKWBWjNTZ9ZB6W+zro2YTUKm7xGHTOrj9/u665tv+jmnxxLYqT2usLAXEuSKfZ5Ue2GwMZmfhUp1Hbuh5/WzK1qiJEm7muEjpvUVXhDh1+GuWmsAFMhXmCBPa5SOPF7ivKBhc5Wle962BfQWctG8gv0kG+v6P//HTvdG5gZxmZZU0ICE3x0AKbX2mEJKYUf2WX0/ck/m/8w2lvL8kcpZuSYe2WrDBx93n9nR2Q8SFh80amExRQRAwaZlCUU8TvhIJ6ZEi6y6kmEu6LCWMrScnuTZ83gS99L6wMm9/voa0mf+HSmjNc/As1PUoc1L7+FkdyXGG95SKm07gQ1WAZTiPijdm4VaxJv/GzIzZcjFxmBSGIM/Trdytj/Kx1NvzJx0TP0CjAE2dmzdy/yyqS5U06/s31YTw56a8vNktgaMUkvGwDsPQgsBvTlm7z0366RZBEDHpJXG0Y4V6tMNVvRbdPHm+vmBeGx0YtTkn6Ubx2AlThpqTOFajz+CnE4kHaN25RTxavSovfcVT5KfktvY2ZphZVh4L3QGWwrhPKlvqSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 05-10-25 18:54:09, Roman Gushchin wrote:
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
> Reviewed-by: Jan Kara <jack@suse.cz>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: linux-mm@kvack.org
> 
> --
> 
> v2: fixed VM_SEQ_READ handling (by Dev Jain)

OK, but now we'll do mmap_miss detection and bail-out even for VM_SEQ_READ
| VM_HUGEPAGE vmas. And without VM_HUGEPAGE we won't do it which is really
odd. So I think you want to make the whole mmap_miss logic conditional on
!VM_SEQ_READ...

								Honza

> ---
>  mm/filemap.c | 42 ++++++++++++++++++++++--------------------
>  1 file changed, 22 insertions(+), 20 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index a52dd38d2b4a..446e591d57e5 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3235,37 +3235,23 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
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
> -	if (vm_flags & VM_SEQ_READ) {
> +	if ((vm_flags & VM_SEQ_READ) && !force_thp_readahead) {
>  		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
>  		page_cache_sync_ra(&ractl, ra->ra_pages);
>  		return fpin;
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

