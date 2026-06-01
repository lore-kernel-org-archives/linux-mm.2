Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52647CD6E57
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 16:22:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2DAD6B0421; Mon,  1 Jun 2026 12:22:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADE4E6B045B; Mon,  1 Jun 2026 12:22:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A6736B045C; Mon,  1 Jun 2026 12:22:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8501C6B0421
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:22:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 531041C1AD5
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:22:11 +0000 (UTC)
X-FDA: 84831860862.15.5E5A213
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id CF19B18000A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:22:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="DPm/IEwl";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=T3+UC3Ca;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="DPm/IEwl";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=T3+UC3Ca;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780330929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gZ72TgsJrRv/vGY/p+18ZB9GO9DQ5TW6tac2G606Edg=;
	b=wxKElSK3c5V29VQsTvVMCZgTLBrjbcT03U6OHFM2XMSjmR9KuJBTXQCsd0kLVk/9i7ewzB
	9pcy2uZs/5vR+zxZbnU0oZ7UAo7YL95S6gtzwqLbSHb56wUzbGjjxxL2kCfsG/9Euh0Og+
	aYWw7DHRn56z8I6kA++BBlZarqtGilM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780330929;
	b=uRJUpeUQhg7dXHLOj9mGFNhle90i2oJQky5ubAT2DiG2wUsAVEvypG0NZxSBKgkJaccMjb
	huLDZ9m3l6+uUVe2cUhwrd/tJd8lVGjt3LTw8mV6M8vtveNMdwCuU85LlFagKDwa/XFbwv
	/dyVANWCPhvUtju1CyCSJhLBg6l7wkg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="DPm/IEwl";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=T3+UC3Ca;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="DPm/IEwl";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=T3+UC3Ca;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6CD78686BF;
	Mon,  1 Jun 2026 16:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780330927; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gZ72TgsJrRv/vGY/p+18ZB9GO9DQ5TW6tac2G606Edg=;
	b=DPm/IEwlGpkf8NfyX+80UyDZbZ2hucyaoC16feayRVX7XSuuWtIqBDRm5Om34HWmnazyZl
	L6rMA++cI7goHDO5iLaBApGIYXhSv/ssJyTq4x+YJNT4h2mOqQJCmlyFNHIKaytsmbGj3I
	VQ7lqCXTOTJXHiq+kNAOMZFCjg2ixe0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780330927;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gZ72TgsJrRv/vGY/p+18ZB9GO9DQ5TW6tac2G606Edg=;
	b=T3+UC3CaTyEWfE5yipWF50DW+yQJdmohfKIaRY+q46sfLFXgCL8qJj6KcxxWxbv6JL7o2B
	IyCdMbhbiL1n1cBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780330927; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gZ72TgsJrRv/vGY/p+18ZB9GO9DQ5TW6tac2G606Edg=;
	b=DPm/IEwlGpkf8NfyX+80UyDZbZ2hucyaoC16feayRVX7XSuuWtIqBDRm5Om34HWmnazyZl
	L6rMA++cI7goHDO5iLaBApGIYXhSv/ssJyTq4x+YJNT4h2mOqQJCmlyFNHIKaytsmbGj3I
	VQ7lqCXTOTJXHiq+kNAOMZFCjg2ixe0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780330927;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gZ72TgsJrRv/vGY/p+18ZB9GO9DQ5TW6tac2G606Edg=;
	b=T3+UC3CaTyEWfE5yipWF50DW+yQJdmohfKIaRY+q46sfLFXgCL8qJj6KcxxWxbv6JL7o2B
	IyCdMbhbiL1n1cBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5A802779A7;
	Mon,  1 Jun 2026 16:22:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hFxsFa+xHWqYdQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 01 Jun 2026 16:22:07 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F171AA0EC0; Mon, 01 Jun 2026 18:22:02 +0200 (CEST)
Date: Mon, 1 Jun 2026 18:22:02 +0200
From: Jan Kara <jack@suse.cz>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	willy@infradead.org, ryan.roberts@arm.com, linux-mm@kvack.org, pfalcato@suse.de, 
	r@hev.cc, jack@suse.cz, Andrew Donnellan <andrew+kernel@donnellan.id.au>, 
	apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	brauner@kernel.org, catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org, 
	kevin.brodsky@arm.com, lance.yang@linux.dev, "Liam R. Howlett" <liam@infradead.org>, 
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ljs@kernel.org, mhocko@suse.com, npache@redhat.com, pasha.tatashin@soleen.com, 
	rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	Al Viro <viro@zeniv.linux.org.uk>, ziy@nvidia.com, hannes@cmpxchg.org, kas@kernel.org, 
	shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v7 2/2] mm: use mapping_max_folio_order() for
 force_thp_readahead order
Message-ID: <yoma5mzdqkkcgjnq3qawaeytjx6cjmk7etzxnmkk53mov46sub@ldzkwojakaxs>
References: <20260601102205.3985788-1-usama.arif@linux.dev>
 <20260601102205.3985788-3-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601102205.3985788-3-usama.arif@linux.dev>
X-Rspamd-Queue-Id: CF19B18000A
X-Rspam-User: 
X-Stat-Signature: 6of5eieacn9c6k4qs4jf5k4u1gn8ipni
X-Rspamd-Server: rspam08
X-HE-Tag: 1780330928-291540
X-HE-Meta: U2FsdGVkX189FxymVM8i1R/f1pOVH+pw2zX3VpDdy+uEnEPhuXbSTzoaGPndCA2v7FhSL2WImp3Czr3Qxksr3njAQTsqWD+qyzeGdSSg3/z5L1vECiGA3mmgFluVxf3deAQ3V4VRydVnd/0Q31rlDb8NlZfYS2Ud23gBZXuZo5al3F6f7FPF+OKS/3e3qdxB45m82quVEI9Vec/mbgHreTWiu/N73b2ratJQIgROJ76W18/6iuyqFa6gnjgkM3Lc2ivUXbDz3l3HSklMIU1MshaS0ovyYSNOdTQFfYm/jo1i/zjBxK7cmotCsEcPvLs9/uglaWoeAmvSepoFeal78x0YM0B0e8c4xq/7Gy5KOH+T/Rd0K7Psmoc29VhzO0c9Ao6hxGXw04zvyPYRTd1oh9VH7JTnfOUwa6B7wFQXcpFtLHmn281BVPf4h3VVkuVN6lNO9GYCQMiRbnjRsIJRjPISt2X7EiOCXgqd+SYBGG+I6AklJsvAyO4aXGP8MZqR4EW4LdP+Jg4YhsC+UnAFzwHF8+CKdsXCxb4Mqj/braIgnTkCMNs2oXZkSFX3IU1GgaqCKFDMb1BBvbrq78kisFH4nTC48FAcq1J/z8qQYrgnv+es2k57YQbUZt63DE1g4oXowpsNVeMCxk8bNH6WqD1cOpHsQUUdca4+m6rvat7ADStCWmfjXqHHWUyFkTQViWorAxwkSydGzkC4ALiauWC3R6IyZa4Z1WE51Pvg2rQETjD7TAccMkF2p1dyt0IbhQJ4DzBD3NiuGsPbrINtgBFflsGc75PjUnjcSd6/odhminBrE09pDqvdIqkHPgmk+ArZ1MK8AQQ/cU8vHOo8sSbLU+5UbxTkO7FZ5u40yJwLllpP32h9tT+w9aQb0DgCHsRnqbvDvlxx8poOYrihrNHFDPbG1omsw0rDtltQoXthiXlp6lrPoDdnEXa9U9gdW+qN3Uy5//wxtFBEo7I
 gT32TXay
 LNX2GZ/kpj71FnKc/4tYXcFP6fAegrf4hqO0MfMGW58B9lMTkAZQzaDPvhXCsI8HOhacNSCoqsdO57/8i0A3jyoSwCzInVHCJxb9sDjwJgJO3uZnhHccGKHNYb55E0flFfAuYv4B9LkmFMZoc2ZnhWx2lRnLujHU88cEENvzoNfUGmhJOdxue+GjwVDi3x67khfvZJHV13K7VQdXWC+oachuhhEMX5GHiUNaDpCH0CpqdT/6XxdAwoju7qtgpDv+ZVTFYo0sJUtCgoIrGU6+Cd/iEG8bfFMoBySkNOhL20RPjfHn17YKs/3fX9khRThPskcW9flOTurf2KPQ7XYat7Ed4xctEX1FggHkvdPXzavasQwuSF25nr7tw7ECcunqrN5e+O/h55AxN/DB95agQA6+gjdbAGnq5f90eCuLJWRW4TO7LjG/VhXj3GcMwBBUlB4tmWYUnvxSqu89JHJMtZAnx1yFFkuIUadrR+ISibBzQhCPllFo5G0GIKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 01-06-26 03:21:18, Usama Arif wrote:
> The force_thp_readahead path in do_sync_mmap_readahead() is gated on
> HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER and always requests
> HPAGE_PMD_ORDER / HPAGE_PMD_NR. On configurations where HPAGE_PMD_ORDER
> exceeds MAX_PAGECACHE_ORDER, notably arm64 with a 64K base page size,
> VM_HUGEPAGE mappings cannot use this path and fall back to the non-forced
> mmap readahead path even when the mapping supports useful large folios.
> 
> Enable forced readahead for mappings that support large folios and request
> the max folio order supported by the mapping, capped at 2M.
> 2MB is chosen as the cap because it matches the PMD size on x86_64
> and on arm64 with 4K base pages, so the size/memory-pressure tradeoff
> for folios of that size is already well understood. On arm64 with 16K
> and 64K base page sizes, 2MB is also the contiguous-PTE (contpte)
> block size, so the resulting folios coalesce into a single TLB entry
> and reduce TLB pressure on the readahead path. This will result
> in 32M folios not being faulted in with 16K base page size for arm64,
> but with contpte, the performance difference should be negligible.
> 
> The final allocation order may still be clamped by page_cache_ra_order()
> to the mapping and request geometry, but this gives VM_HUGEPAGE mappings
> on such configurations a large-folio readahead request instead of
> dropping back to base-page readahead.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/filemap.c | 30 ++++++++++++++++++++++--------
>  1 file changed, 22 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index a16b33e0fc71..9cf89efaf3f1 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3312,14 +3312,26 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
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
> +		/*
> +		 * Cap max THP order at 2MB: this is the common PMD-sized
> +		 * hugepage size, and it avoids memory pressure from very
> +		 * large forced readahead when mapping_max_folio_order() is
> +		 * high (for example, 128MB with 64K base pages on arm64).
> +		 */
> +		if (mapping_large_folio_support(mapping)) {
> +			force_thp_readahead = true;
> +			thp_order = min_t(unsigned int,
> +					  mapping_max_folio_order(mapping),
> +					  get_order(SZ_2M));
> +		}
> +	}
>  
>  	if (!force_thp_readahead) {
>  		/*
> @@ -3354,17 +3366,19 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
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
>  		 * readahead, unless we've been told not to.
>  		 */
>  		if (!(vm_flags & VM_RAND_READ))
>  			ra->size *= 2;
> -		ra->async_size = HPAGE_PMD_NR;
> -		ra->order = HPAGE_PMD_ORDER;
> +		ra->async_size = folio_nr_pages;
> +		ra->order = thp_order;
>  		page_cache_ra_order(&ractl, ra);
>  		return fpin;
>  	}
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

