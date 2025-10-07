Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3811CCA472
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 11:41:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC6F18E000F; Tue,  7 Oct 2025 07:41:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9EF28E0005; Tue,  7 Oct 2025 07:41:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8D978E000F; Tue,  7 Oct 2025 07:41:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A78518E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 07:41:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5E05983E3C
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 11:41:37 +0000 (UTC)
X-FDA: 83971128234.15.586D5F7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 18BA2180008
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 11:41:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="cd9/Sv7m";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rpUKT5Al;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="cd9/Sv7m";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rpUKT5Al;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759837295; a=rsa-sha256;
	cv=none;
	b=Xysb7Rpqx8d8FCpJ+RJClrvfTyio+oOxLh4ZpNnXi/HcHvROGH0OSvOivcUxbn2ejYU+d/
	d647UVxcnc5v5NRVT15YmRHWxTZCkTSqemb9WCFZtYrwnIfGR51sItnw3xww2of5d5bfxQ
	pQTtEZ4I56KOqCHiPKYr1sEp8teOTg0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="cd9/Sv7m";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rpUKT5Al;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="cd9/Sv7m";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rpUKT5Al;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759837295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZkgiUG8s/GGxknPnnCcFa5imKmgKW71ZK0Go84byCA=;
	b=EHT4cMP8gooy7DdSMpoD/biOhHbPEV6AnFFPGvM6vUZ+1olMvYaIrf9l5qunwtVGwqsPpk
	o/jDyX7u3sEMBlihMQQ/W/ciGh1Nsk1O88CVMklKGr/G7Bi5s+iQAXdCVDsSD1m+ZZEg6k
	cm6BX7j1z9RHtUY/Ee6XBojCKDsg9KY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 475591F44F;
	Tue,  7 Oct 2025 11:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759837293; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LZkgiUG8s/GGxknPnnCcFa5imKmgKW71ZK0Go84byCA=;
	b=cd9/Sv7mbpynR0vya1gE3ucWIpSg3BoLSgUPV+Uf/PPVYRuwYktGc5g90fPwDNF/2joFZC
	hBAYZxjYlcQRqZJnynu3FYyHNPO1yTn4MT2hrkUnMpVCPN9zsPTEN49CvBdhFoTSW37R3o
	PfUlYOpn1TUOe9ea+dlL4H7ruajbadU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759837293;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LZkgiUG8s/GGxknPnnCcFa5imKmgKW71ZK0Go84byCA=;
	b=rpUKT5AlcUCjq3cJ9UJebhZPr0XORcscgMMXrQuhKsqksuJUp7us2S/3ACi99bhjxM1FBk
	wBEXj03Jdem6TYBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759837293; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LZkgiUG8s/GGxknPnnCcFa5imKmgKW71ZK0Go84byCA=;
	b=cd9/Sv7mbpynR0vya1gE3ucWIpSg3BoLSgUPV+Uf/PPVYRuwYktGc5g90fPwDNF/2joFZC
	hBAYZxjYlcQRqZJnynu3FYyHNPO1yTn4MT2hrkUnMpVCPN9zsPTEN49CvBdhFoTSW37R3o
	PfUlYOpn1TUOe9ea+dlL4H7ruajbadU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759837293;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LZkgiUG8s/GGxknPnnCcFa5imKmgKW71ZK0Go84byCA=;
	b=rpUKT5AlcUCjq3cJ9UJebhZPr0XORcscgMMXrQuhKsqksuJUp7us2S/3ACi99bhjxM1FBk
	wBEXj03Jdem6TYBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3BB4613693;
	Tue,  7 Oct 2025 11:41:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2+WMDm385GgnfAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 07 Oct 2025 11:41:33 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E1051A0A58; Tue,  7 Oct 2025 13:41:28 +0200 (CEST)
Date: Tue, 7 Oct 2025 13:41:28 +0200
From: Jan Kara <jack@suse.cz>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org
Subject: Re: [PATCH v3] mm: readahead: make thp readahead conditional to
 mmap_miss logic
Message-ID: <3hgw6hizjyjz3c7hpuyyevehd4lqasucuitgphh37rmtztfmcd@q4j7ytdnnwje>
References: <20251006175106.377411-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251006175106.377411-1-roman.gushchin@linux.dev>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 18BA2180008
X-Stat-Signature: hk8o6gw8z7tjs3ffft6dyy6m6e99hfpt
X-HE-Tag: 1759837294-227814
X-HE-Meta: U2FsdGVkX1/bRHCTaV5RjBQS6hLBTAMOnq4h14BvYBUPICPE40asTJSUH/t5Qj5EogStnTcSf/ofDQLMb34KeK9GwPSB2BtMCezyTaOGvFdFFJd3ZWuUP9ykhNK1Rrca1XC3l8y31HNRX1zMf2SjQmQgCLORfkLUbd7Z+KUQd0qBVzEjZochzz5QHdeOySiCiqXo9tdk5osq+cprH22A/EiygAnUHeVFjdbohsm1LiNnXy2nAEGZPSUytPvo3kXb/O0c4kjS/oCdh3Jd5hbl2dtEe3Fm0XpRDNWQsA50ihwi9bz815AIq92H7/haEzHEOEDjJ/dNHkprLtD/Sa4KscbaKmRonDQFV34YNTc43LmWbwFVS8IkoP2GqR+4gm76n071GSOmZ0e9NMP92/Pp6bfN45iC40ty2jsytbNqUcy8KCBCMz8My1HrshUaO6c+28lmmpoyNevVDUMLyR6sYC0azAvXCmaAQl2mxHRa6gaEcBuHfip4K6snuuvLbgeLC+4X71st1XWTrS+N9YIoD4BCEv1Ev9Ganc6aj9PnHM5EYpRdbL2xh2blZ6CIJXZZt/QLdQ2UaG9t1IozHb5+hrE/X5tYV2VuGgBtUHmSX4Bu8AFAob75X4iBBwYHohjT7TNyFE8oBYc2dTH05/y1UwCjtaro5rNBvkmCcti7Cz7V0fOjerx19KAWbSS8Yj6J799yiG0FNXQZHkgtjb+nnbahtThgrRgQbDAF1CEKqJkubaMv+SvYovG9OZUhKy7jKvy6dVSJp8MEfESTtDo3gHLXH3hugvQy3RHObaV0c3ofFRALZuiIcB2IECHEOvt1lJPQDF3EX7V37y1Ddayl2zuQjT+4ygeFJsJI9LPgRu+ufzUx+6BQNYeiLQtidQtldMp3wAOdzfAZ+q1gcNcgYoNlg9bXiPoU3jOaja7u37/NBSrFENcQ4udvhtNmR5kpNCxvEff7jvOVGx18HX6
 U0rgzUjb
 zmEP/j0c6gRJhkO6e2YtnbkXeF7eySDcgFSPB9dwgRz5BU88+nAfhWRWxM62IAzmQuFueKRkaGEKpN+x7J9vng/JH7y9MMCtAp8bDntFzlJi9RBHGi8wOlhNwHPCPCyQZuocS/rdnPshwZRXPYr44g5dwACJZjebJ4gPWhl4JvojGTvTT7dJV9RfUsSN4wGTeRBLu2FoBc2whk6+bYoe84AvyY+cGNKB2sSGPBkq3LSSuPN8Rr59+/JJRTGZzclEmkqEXpN2Rp861f/fCOESl+3Ekz8olpPC9ZVAz2VoWhCOsO+r8/i7jQ5qt3cRkdK3pA8q/MJuvEzG7GcJZOEfjwisSESoLtgMqCnC0xdZ/mbumUYN5OgCVT5yCwYwOeAZBRia/M+kJeCWamynBv7x21PQewDTLQM0SxBJMYgQi66eigl9dAu4nbz0c1MMYTZI1a7mCCOb3QGnHavlOVrProeEb7HwP/d0QgNcMC97tXP6c4hfRkDzBao442zqVSBJgc8/siD4RrEEcshMilJMGuiEaqFF81QUOm8nKx6TcCeB2Ya1zmvR7te16og==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 06-10-25 10:51:06, Roman Gushchin wrote:
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
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: linux-mm@kvack.org

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> --
> 
> v3: fixed VM_SEQ_READ handling for the THP case (by Jan Kara)
> v2: fixed VM_SEQ_READ handling (by Dev Jain)
> ---
>  mm/filemap.c | 68 +++++++++++++++++++++++++++++-----------------------
>  1 file changed, 38 insertions(+), 30 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index a52dd38d2b4a..ec731ac05551 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3235,11 +3235,47 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>  	DEFINE_READAHEAD(ractl, file, ra, mapping, vmf->pgoff);
>  	struct file *fpin = NULL;
>  	vm_flags_t vm_flags = vmf->vma->vm_flags;
> +	bool force_thp_readahead = false;
>  	unsigned short mmap_miss;
>  
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  	/* Use the readahead code, even if readahead is disabled */
> -	if ((vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER) {
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> +	    (vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER)
> +		force_thp_readahead = true;
> +
> +	if (!force_thp_readahead) {
> +		/*
> +		 * If we don't want any read-ahead, don't bother.
> +		 * VM_EXEC case below is already intended for random access.
> +		 */
> +		if ((vm_flags & (VM_RAND_READ | VM_EXEC)) == VM_RAND_READ)
> +			return fpin;
> +
> +		if (!ra->ra_pages)
> +			return fpin;
> +
> +		if (vm_flags & VM_SEQ_READ) {
> +			fpin = maybe_unlock_mmap_for_io(vmf, fpin);
> +			page_cache_sync_ra(&ractl, ra->ra_pages);
> +			return fpin;
> +		}
> +	}
> +
> +	if (!(vm_flags & VM_SEQ_READ)) {
> +		/* Avoid banging the cache line if not needed */
> +		mmap_miss = READ_ONCE(ra->mmap_miss);
> +		if (mmap_miss < MMAP_LOTSAMISS * 10)
> +			WRITE_ONCE(ra->mmap_miss, ++mmap_miss);
> +
> +		/*
> +		 * Do we miss much more than hit in this file? If so,
> +		 * stop bothering with read-ahead. It will only hurt.
> +		 */
> +		if (mmap_miss > MMAP_LOTSAMISS)
> +			return fpin;
> +	}
> +
> +	if (force_thp_readahead) {
>  		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
>  		ractl._index &= ~((unsigned long)HPAGE_PMD_NR - 1);
>  		ra->size = HPAGE_PMD_NR;
> @@ -3254,34 +3290,6 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>  		page_cache_ra_order(&ractl, ra);
>  		return fpin;
>  	}
> -#endif
> -
> -	/*
> -	 * If we don't want any read-ahead, don't bother. VM_EXEC case below is
> -	 * already intended for random access.
> -	 */
> -	if ((vm_flags & (VM_RAND_READ | VM_EXEC)) == VM_RAND_READ)
> -		return fpin;
> -	if (!ra->ra_pages)
> -		return fpin;
> -
> -	if (vm_flags & VM_SEQ_READ) {
> -		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
> -		page_cache_sync_ra(&ractl, ra->ra_pages);
> -		return fpin;
> -	}
> -
> -	/* Avoid banging the cache line if not needed */
> -	mmap_miss = READ_ONCE(ra->mmap_miss);
> -	if (mmap_miss < MMAP_LOTSAMISS * 10)
> -		WRITE_ONCE(ra->mmap_miss, ++mmap_miss);
> -
> -	/*
> -	 * Do we miss much more than hit in this file? If so,
> -	 * stop bothering with read-ahead. It will only hurt.
> -	 */
> -	if (mmap_miss > MMAP_LOTSAMISS)
> -		return fpin;
>  
>  	if (vm_flags & VM_EXEC) {
>  		/*
> -- 
> 2.51.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

