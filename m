Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D2B7CD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 10:01:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9B076B0088; Fri, 29 May 2026 06:01:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4B8E6B008A; Fri, 29 May 2026 06:01:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93A726B008C; Fri, 29 May 2026 06:01:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8054E6B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 06:01:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D0851C0BB9
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:01:31 +0000 (UTC)
X-FDA: 84820015182.16.69C549E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3A3DD10000F
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:01:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=reQyoAZg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1ck1i2jT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=R9MbOLjn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8dtnSBU8;
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780048889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IDCpu1/nuWgxfdw1LsjaHJ9L6YwcwToPNO7yEAIUT+Q=;
	b=fFj6BDOJdtmfQeIMNjuD1ub+sjLz6+YEvRokhVQR2/MoSlwHnYIu3oAWYUq7aBrvqqR8hD
	JOmgNg5hy/SNl/j9SXRKgIHCZ+iBoMR9TguHWHJb3sYPAkQhXtAjoMYllKGM8KOn4RhPQA
	anjFbSzr2QHpNL8TMwU1CQvygbNpp+M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=reQyoAZg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1ck1i2jT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=R9MbOLjn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8dtnSBU8;
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780048889; a=rsa-sha256;
	cv=none;
	b=AuBVhZJWgjaTWvtzu0XgwIAs8ikSf26PLiDV5+UZes1D2N9MjXiQOPqasWElGJ/oQtBp5D
	03lrJ/TulBQdkoOGfe580XgwoaNnVcJnPqbjd4M9944lP3qgboE53rsleGLLRAfSp+m6U+
	cJj1vqBf/kGITBv9+LAhAZ3/LZ9TCHM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DDF066AADA;
	Fri, 29 May 2026 10:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780048887; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IDCpu1/nuWgxfdw1LsjaHJ9L6YwcwToPNO7yEAIUT+Q=;
	b=reQyoAZggaokCNF1+0IkBjyJV72pNQ5r6ET1CR/g/LQfhNd6xCcPR9XLudh+nM7iUKWBVf
	BuQ1Cpazko0Of4tlGW5M0CH7OTeTuoJe6VwIy8g1nuE71kvaeTCaBnYc1027ZUUimsUJtS
	Hy9cHwMBT6yCLUf2aJZhQZzweUj4JJ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780048887;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IDCpu1/nuWgxfdw1LsjaHJ9L6YwcwToPNO7yEAIUT+Q=;
	b=1ck1i2jT0HYfHibf1hHQDlmVSZbD6UgcIrXbtrCJzfHZuSETmb/WiPxaV6xxJj7MqJiAXi
	3FQNPTLDZGvG3lDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780048883; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IDCpu1/nuWgxfdw1LsjaHJ9L6YwcwToPNO7yEAIUT+Q=;
	b=R9MbOLjnfaB2OW5h+RPzQd1GQdd/hX9knnauDawYIpyznWihIT9ezMl7VjfwWKHA8ehS+7
	5Si53dwcl4+/Xo4JPBj6XnR1v/f4o14yiMnDDiXi22woGtIPSlOXMe21y5gtUcA5s7SwW2
	CBWkiDImwPBOD75ig5qfV1Cgcrao6nI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780048883;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IDCpu1/nuWgxfdw1LsjaHJ9L6YwcwToPNO7yEAIUT+Q=;
	b=8dtnSBU8SRtvS0iRSEMWihwBKq5EHV3pfDBhkQnqsaV46vO3PCbFFla6qu6WdqzEqV9/sv
	DwiELJFLHklF+sAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8797A779A7;
	Fri, 29 May 2026 10:01:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id I2KYHfFjGWrNcwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 29 May 2026 10:01:21 +0000
Date: Fri, 29 May 2026 11:01:19 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	willy@infradead.org, ryan.roberts@arm.com, linux-mm@kvack.org, r@hev.cc, jack@suse.cz, 
	Andrew Donnellan <andrew+kernel@donnellan.id.au>, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, brauner@kernel.org, catalin.marinas@arm.com, dev.jain@arm.com, 
	kees@kernel.org, kevin.brodsky@arm.com, lance.yang@linux.dev, 
	"Liam R. Howlett" <liam@infradead.org>, linux-arm-kernel@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com, 
	npache@redhat.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com, 
	rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	Al Viro <viro@zeniv.linux.org.uk>, wilts.infradead.org@pedro-suse.lan, ziy@nvidia.com, 
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v6 2/2] mm: use mapping_max_folio_order() for
 force_thp_readahead order
Message-ID: <ahlh2vdHEGo6ZSot@pedro-suse.lan>
References: <20260528165635.2068012-1-usama.arif@linux.dev>
 <20260528165635.2068012-3-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528165635.2068012-3-usama.arif@linux.dev>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3A3DD10000F
X-Stat-Signature: y17nczy9nwjjoxdi944k35kbwzhppthm
X-HE-Tag: 1780048889-138589
X-HE-Meta: U2FsdGVkX1+w/XbS50Xrmx7I4q96Yjjk20F3ju2EWjZ7QOhUdMsgJYbuKsgKZzAIQEfCcQbVLdT2Pbf2Ta6J7j8/G84JnS50Vpl8IeiAiPQ7xUGLu5dqwD9Gjgmr3yP5PwinsHq+r2eRbd88Y0/5gt9zf6xNbAJsjNaPVl6R4Kz1DlD9WdHVvBLdbJ/ahKZ1d9RjpQ9TOh8hHp/U/iVNzoYKzY6knUS3DTepJa9+/3tWaW/6WBgD30CZKRZq2Y8cuAE2KNwHWJMYVVB2V1JmUkBC79qJkQBlxM1p35h3W7gH6rZO3dlY00ITF3RTVywFMUxhvgs0/Azep4SAgEABSIXo42Q+npYxgWGa5A+VKasxhzuWLO7ogZvxfAPtls6hDNMoe1joa4KcHhn0VaSN/q38qZfR/7UgFNgCCDwi1fwnq3vZYk4HTWdjR4PLq7290sZG085sYDRE1llhDUx/SGprFKns/piI6KXrwzzhPYrk1cCM0UtO+O8M1aQwM+0KKQT2Y224wF8QeInpjhy0TUeiyBmVtEEU8gxef02k59SnsNmA9QTObdZtiH2n7KriW5Hawe4giyXMCpPQ9Lf05ZRBdTo2ipNGLwVmu2HfDkUhvpW7nv8NdnUwt54PP02qy3B8LVOz47SYHZuFJwEOy0isAGQs0JLUfstW9EDPkOMyIUONpGPtUtwShlPYZuRUgFkee4R5p10VhRBqfxxjfPzYTDvTmb7EikhbjlhcVv8YTa5EHyxwpF9BwKosM6sdd9F4EO2bU7WZlLWbjyjxLDhyW1FVyfC2oT7UE6mJOgnVsFfrITE84ZZwNJDMztrO/uXODLRTlM9Ak0bfBRlxHW6nb7B9i+Gcw9XY7mr4LuF5YndPjjLUgRbphY98E8z9Oz1Mu0Jc6gxNSArucOnz8gzAzTOePrdUZyP74SohVsqZp1nJGTGzTKfpjxtFlC50MGg6ZNc0p5MtfHqdBnu
 CsAP5b/g
 nG6bpezVJX7RbTpdgQe+UeXhBhFfqV2qLzMUrd3YcasJv6Syqn9qBNF4H1vpqaMyWnUDyEFita1baMEk84E5o0O1mQ5Z44F2Jhkc0eQS/R6qUHV2NNJBpmBU6TExbEKFqctRg4aFIgSAU8S2U1bjbbsjXMA3BV3z05FqZndwOqadbTNKyIl7z4LgPF1VbB8vZmg7+eCAXEfiFARrkA2ZuEM5TkAN9hXUhqrUcXM6Hbq7Pxq/fHQaHdO1/5LQDs3qZ58teuvWZoiMeysADsIlbPm3BcPkmuPQfqKpp4+i2RUVuatoUFtJAV7OAWJD2wDDcVfbanO0rUDlJFH7f5mqNblRl3XJVB5suGqS+K7Oh1a4LrAuCqrYGSHXtkedf4hosqx01Ptc5Vp/BQmk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 09:55:20AM -0700, Usama Arif wrote:
> The force_thp_readahead path in do_sync_mmap_readahead() is gated on
> HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER and always requests
> HPAGE_PMD_ORDER / HPAGE_PMD_NR. On configurations where HPAGE_PMD_ORDER
> exceeds MAX_PAGECACHE_ORDER, notably arm64 with a 64K base page size,
> VM_HUGEPAGE mappings cannot use this path and fall back to the non-forced
> mmap readahead path even when the mapping supports useful large folios.
> 
> Keep the existing PMD-sized behavior when HPAGE_PMD_ORDER fits in the
> page cache. When it does not, enable forced readahead for mappings that
> support large folios and request an order capped by both
> mapping_max_folio_order(mapping) and 2MB.
> 
> 2MB is chosen as the cap because it matches the PMD size on x86_64
> and on arm64 with 4K or 16K base pages, so the size/memory-pressure

16K base page size's PMDs should be 32M, no? Am I misunderstanding what
you mean here?

> tradeoff for folios of that size is already well understood. On arm64
> with a 64K base page size, 2MB is also the contiguous-PTE (contpte)
> block size, so the resulting folios coalesce into a single TLB entry
> and reduce TLB pressure on the readahead path.
> 
> The final allocation order may still be clamped by page_cache_ra_order()
> to the mapping and request geometry, but this gives VM_HUGEPAGE mappings
> on such configurations a large-folio readahead request instead of
> dropping back to base-page readahead.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/filemap.c | 27 +++++++++++++++++++--------
>  1 file changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index a16b33e0fc71..bfb891d9da1f 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3312,14 +3312,23 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>  	struct file *fpin = NULL;
>  	vm_flags_t vm_flags = vmf->vma->vm_flags;
>  	bool force_thp_readahead = false;
> +	unsigned int thp_order = 0;
>  	unsigned short mmap_miss;
>  
>  	ractl._max_index = vmf->vma->vm_pgoff + vma_pages(vmf->vma) - 1;
>  
>  	/* Use the readahead code, even if readahead is disabled */
> -	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> -	    (vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER)
> -		force_thp_readahead = true;
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && (vm_flags & VM_HUGEPAGE)) {
> +		if (HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER) {
> +			force_thp_readahead = true;
> +			thp_order = HPAGE_PMD_ORDER;
> +		} else if (mapping_large_folio_support(mapping)) {
> +			force_thp_readahead = true;
> +			thp_order = min_t(unsigned int,
> +					  mapping_max_folio_order(mapping),
> +					  get_order(SZ_2M));

This looks somewhat arbitrary to me (as does the old logic). It seems more
natural (correct?) to do this:

	if (THP_ENABLED && (vm_flags & VM_HUGEPAGE)) {
		if (mapping_large_folio_support(mapping)) {
			force_thp_readahead = true;
			/*
			 * Cap THP readahead to either the max folio order the
			 * mapping supports, or the max order the page cache
			 * supports (useless to try more), or the hugepage PMD
			 * order (CPU can't benefit from larger).
			 */
			thp_order = min3(mapping_max_folio_order(mapping),
					MAX_PAGECACHE_ORDER, HPAGE_PMD_ORDER);
		}
	}

> +		}
> +	}
>  
>  	if (!force_thp_readahead) {
>  		/*
> @@ -3354,17 +3363,19 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>  	}
>  
>  	if (force_thp_readahead) {
> +		unsigned long folio_nr_pages = 1UL << thp_order;
> +
>  		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
> -		ractl._index &= ~((unsigned long)HPAGE_PMD_NR - 1);
> -		ra->size = HPAGE_PMD_NR;
> +		ractl._index &= ~(folio_nr_pages - 1);
> +		ra->size = folio_nr_pages;
>  		/*
> -		 * Fetch two PMD folios, so we get the chance to actually
> +		 * Fetch two folios so we get the chance to actually
			  ^^ large folios?
>  		 * readahead, unless we've been told not to.
>  		 */
>  		if (!(vm_flags & VM_RAND_READ))
>  			ra->size *= 2;
> -		ra->async_size = HPAGE_PMD_NR;
> -		ra->order = HPAGE_PMD_ORDER;
> +		ra->async_size = folio_nr_pages;
> +		ra->order = thp_order;

This part LGTM.

-- 
Pedro

