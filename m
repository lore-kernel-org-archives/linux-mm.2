Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2413ACA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 03:52:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 445986B02F8; Tue, 26 Aug 2025 23:52:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41D918E0105; Tue, 26 Aug 2025 23:52:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3332F6B02FA; Tue, 26 Aug 2025 23:52:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1EFC86B02F8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 23:52:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C0DACC0247
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 03:52:41 +0000 (UTC)
X-FDA: 83821165722.07.141E718
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id B3C4980008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 03:52:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IY43vQdq;
	spf=pass (imf30.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756266760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sv1GyWM+sC/GNWSw17NBq91CsCOpfd89bfoVZTZKtAY=;
	b=ebRn9mIBYRNMDBxCtaJMbDYLLPjDcJkAszZgw6SZh/ww3ABILsSXM3O1hBshLXAmBM1lWa
	62Y46qvF03VeEGsXTNOpd9BHXGfDKDHkG3pGGhurPcHGhpOl3weqjCIM1at58OrncTn1zr
	rYKdcxiaBAnoD85R1745TkedLVDiCmY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IY43vQdq;
	spf=pass (imf30.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756266760; a=rsa-sha256;
	cv=none;
	b=JUpJPnNcx6yCG5HkcWZXTwnxNb/JHpIwFyGDN4V4iy7G9B2Aif3IGJqIYOUEX/DPaHsV+j
	CKhSSpTU9+BCLovXVUnCxTmKaV8npLniS2uwhB3kptTDEM4lM/A/sl1OWtBpYWJR2yPsy6
	H6DKrGi6LL3F3d3Av9XedOQWwIWHbtM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756266759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Sv1GyWM+sC/GNWSw17NBq91CsCOpfd89bfoVZTZKtAY=;
	b=IY43vQdq2T16xTa7vKlR62NrGJFr1sqGy6+mY426tUwqah5SLIvWTXE5xGesdC5E2jZkAt
	m+j27X2oZzyYqwW8eRdWZk2HN9ehCT9ZOCuBAAB1U9VGTCVguI79r+jGBaq/tcIMYlll50
	V2f7cF5i3VsVj1wTKCkyGXstD/ewjo0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-638-LFAt1coCM56G21_qlnRySQ-1; Tue,
 26 Aug 2025 23:52:35 -0400
X-MC-Unique: LFAt1coCM56G21_qlnRySQ-1
X-Mimecast-MFC-AGG-ID: LFAt1coCM56G21_qlnRySQ_1756266753
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A1CC019560B2;
	Wed, 27 Aug 2025 03:52:32 +0000 (UTC)
Received: from localhost (unknown [10.72.112.154])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 40574180047F;
	Wed, 27 Aug 2025 03:52:29 +0000 (UTC)
Date: Wed, 27 Aug 2025 11:52:15 +0800
From: Baoquan He <bhe@redhat.com>
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] mm, swap: use unified helper for swap cache look up
Message-ID: <aK6A76NVcV2j+J57@MiWiFi-R3L-srv>
References: <20250822192023.13477-1-ryncsn@gmail.com>
 <20250822192023.13477-2-ryncsn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250822192023.13477-2-ryncsn@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: B3C4980008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: fx7bjsoui8o1b7exkncjdhbyefk4p3qg
X-HE-Tag: 1756266759-355781
X-HE-Meta: U2FsdGVkX19FMvWxUZWRnl3xngf1Mi77b0OdYw3vJZet1FGNG3NbpnST8TSWicgf1YrN2Q3kw/DpTtyRMXhs2LZsrbZc2wCpLBMGqsfqO64855XEk/Ty/tnjGIzRVEkh3kC4muxbpfdtej+RVFGa77DZwJ7HpZkexXGz/4DCV402exu9Msvjg4zHSnTqLpO++BWGKRAYaXtEPpBBvumgdzleWimfneTTYXWA5/PRgFkKYS5bRhF3SsoOeKVhcoDLsTkFh4zOoYMSS1U5H9tox1LHFl7kp5om9tL4o1QicXwYizcVRIJwHFH/HW9N74DutfimG9iotMlxTic3WTBIayxNB90bgtGBcK81Wu5DqTh9y0W+xLvzS3yzvMGBoweL0PlObVQu1YJg0uFDnRoOvshlWQylNZCe+eQ0w0kLL70zbgM0819J87F+MIn4BQk1p1DTIjP124ACoRVfMOrFqJTq1BG3FkwLxfRzpd5ZBjc9NUa7oHsHJ73TbwWrgYhOdmFQxpgQisSc4q6dzo/y3ZD6VOVLqMeELum35Oe1GzM+KFPCartQgD0pIieOeFCZ+GsYNfPvkEjWpDLxtK6+Lw0ZJpDBh7fMO349RfSsRT9buAqDvWt5tXoAxjabvdEo/PGB8KHv7dN3fl9evd1zvuY9uEO/mOHlH0fKil0jclYdRa2G8rcTMF9MKZU0dXLnLGKuCx4jFvkGQz7833ITDRr/mNpPWZJ7DFJ+gzLDXsQhQzruM/RkR6ULcUh0qGNhQdulHxTiwpwhjZKb/nf2XWd3b4IPqd5SV17eE24zHjBwChlJr7wQyPrwDge0ULoJ7eP5iWiiEB2LNEu1YsMSNgZ/AA+gZjwqFP7P4+zOAbzY6NiZGlfUcOjOg1IBVV07884Ky4qHsT8PjcwrneaEMMKbF006325vaEaxD0DlDZHLAVXFGl93jdzixRv43kvLQGZ6H8RevAkj8ReugHz
 NWyMWPDR
 ylP0MXr+93aqxIfOR/QrscWJ4cd74a9Rk8S2MvcFHteUF1PXFJJi4V7ElWcma8rpcV8IKR8r83jmyLjmwvLKFi3ktIVymbYDFnRfo9W/6wbDtinxK4pcpAo263f9dv0h3DY8+u6UVoW8gfkKIXi5gOhrR5BKzYouppfCU4K9fXKarHfctydvDI0vHwMYM4HeqhU6i5W73KO8r7dISDFftEW0iXle3Rf6I11en9bGp33b/zo6WqpM2RaTOAIXnfhJNioRwJKbsjxO8DlkhgHgMRPplHEP7jKGXkzakk+1aFNscszc0H70qCptiPsqC3PmkHViFuHZOl83RGoku0eA/0JAaKOkadkU0UFhRlrn9BQgeT/ef50VcD2p0Nkuzqhe2Ixfqj0IDm2g/DhTID2WAYPNABkURMwA9MExQGJOznf2Xff4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/23/25 at 03:20am, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
......snip...
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 99513b74b5d8..ff9eb761a103 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -69,6 +69,21 @@ void show_swap_cache_info(void)
>  	printk("Total swap = %lukB\n", K(total_swap_pages));
>  }
>  
> +/*
> + * Lookup a swap entry in the swap cache. A found folio will be returned

Lookup is a noun, we should use 'look up' which is a verb here instead?

And all other places in swap code, even though they are not introduced
by this patchset. Just a nitpick.

> + * unlocked and with its refcount incremented.
> + *
> + * Caller must lock the swap device or hold a reference to keep it valid.
> + */
> +struct folio *swap_cache_get_folio(swp_entry_t entry)
> +{
> +	struct folio *folio = filemap_get_folio(swap_address_space(entry),
> +						swap_cache_index(entry));
> +	if (!IS_ERR(folio))
> +		return folio;
> +	return NULL;
> +}
> +
>  void *get_shadow_from_swap_cache(swp_entry_t entry)
>  {
>  	struct address_space *address_space = swap_address_space(entry);
> @@ -273,54 +288,40 @@ static inline bool swap_use_vma_readahead(void)
>  }
>  
>  /*
> - * Lookup a swap entry in the swap cache. A found folio will be returned
> - * unlocked and with its refcount incremented - we rely on the kernel
> - * lock getting page table operations atomic even if we drop the folio
> - * lock before returning.
> - *
> - * Caller must lock the swap device or hold a reference to keep it valid.
> + * Update the readahead statistics of a vma or globally.
>   */
> -struct folio *swap_cache_get_folio(swp_entry_t entry,
> -		struct vm_area_struct *vma, unsigned long addr)
> +void swap_update_readahead(struct folio *folio,
> +			   struct vm_area_struct *vma,
> +			   unsigned long addr)
>  {
> -	struct folio *folio;
> -
> -	folio = filemap_get_folio(swap_address_space(entry), swap_cache_index(entry));
> -	if (!IS_ERR(folio)) {
> -		bool vma_ra = swap_use_vma_readahead();
> -		bool readahead;
> +	bool readahead, vma_ra = swap_use_vma_readahead();
>  
> -		/*
> -		 * At the moment, we don't support PG_readahead for anon THP
> -		 * so let's bail out rather than confusing the readahead stat.
> -		 */
> -		if (unlikely(folio_test_large(folio)))
> -			return folio;
> -
> -		readahead = folio_test_clear_readahead(folio);
> -		if (vma && vma_ra) {
> -			unsigned long ra_val;
> -			int win, hits;
> -
> -			ra_val = GET_SWAP_RA_VAL(vma);
> -			win = SWAP_RA_WIN(ra_val);
> -			hits = SWAP_RA_HITS(ra_val);
> -			if (readahead)
> -				hits = min_t(int, hits + 1, SWAP_RA_HITS_MAX);
> -			atomic_long_set(&vma->swap_readahead_info,
> -					SWAP_RA_VAL(addr, win, hits));
> -		}
> -
> -		if (readahead) {
> -			count_vm_event(SWAP_RA_HIT);
> -			if (!vma || !vma_ra)
> -				atomic_inc(&swapin_readahead_hits);
> -		}
> -	} else {
> -		folio = NULL;
> +	/*
> +	 * At the moment, we don't support PG_readahead for anon THP
> +	 * so let's bail out rather than confusing the readahead stat.
> +	 */
> +	if (unlikely(folio_test_large(folio)))
> +		return;
> +
> +	readahead = folio_test_clear_readahead(folio);
> +	if (vma && vma_ra) {
> +		unsigned long ra_val;
> +		int win, hits;
> +
> +		ra_val = GET_SWAP_RA_VAL(vma);
> +		win = SWAP_RA_WIN(ra_val);
> +		hits = SWAP_RA_HITS(ra_val);
> +		if (readahead)
> +			hits = min_t(int, hits + 1, SWAP_RA_HITS_MAX);
> +		atomic_long_set(&vma->swap_readahead_info,
> +				SWAP_RA_VAL(addr, win, hits));
>  	}
>  
> -	return folio;
> +	if (readahead) {
> +		count_vm_event(SWAP_RA_HIT);
> +		if (!vma || !vma_ra)
> +			atomic_inc(&swapin_readahead_hits);
> +	}
>  }
>  
>  struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
> @@ -336,14 +337,10 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  	*new_page_allocated = false;
>  	for (;;) {
>  		int err;
> -		/*
> -		 * First check the swap cache.  Since this is normally
> -		 * called after swap_cache_get_folio() failed, re-calling
> -		 * that would confuse statistics.
> -		 */
> -		folio = filemap_get_folio(swap_address_space(entry),
> -					  swap_cache_index(entry));
> -		if (!IS_ERR(folio))
> +
> +		/* Check the swap cache in case the folio is already there */
> +		folio = swap_cache_get_folio(entry);
> +		if (folio)
>  			goto got_folio;
>  
>  		/*
......


