Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48FF1D3E78D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 04:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC4C76B0005; Wed, 10 Dec 2025 23:21:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C26B66B0007; Wed, 10 Dec 2025 23:21:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEE956B0008; Wed, 10 Dec 2025 23:21:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A6DD6B0005
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 23:21:40 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4ADE48AB2A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 04:21:40 +0000 (UTC)
X-FDA: 84205891560.05.FDADB50
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7B9212000C
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 04:21:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=S+WkzXkF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765426898; a=rsa-sha256;
	cv=none;
	b=lEReqKBX0PGlNOvBoSKDk4XZGxhIcvYXPhWfxBiFhwVYZnumm8lWsssxjLaTS2+cAqZLJV
	6HZ6yVet4VLEwEF0H2+8XwxtW9KFbgkwwkTWUlvevSeDbqVq48dWZLZ3KtITt5F08Utcy1
	ddGB+WUniViw/6rZ5gxDNW3FTAhYlxk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=S+WkzXkF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765426898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6yd3nUaH+JVSycTF7AKt0rbB2xusebsv+tukG2IUDQs=;
	b=dRLyccqRB6oZj1WcndWFr2dRUgXbcZNZS/IKONdpH2sOj2jjf8cv6JjmPi6Mtpk5xGTYIy
	BwhFDtcU6c3SesSj++qz4cDn9W3NYaSb1uTGnvjt8onFtfj9MKN6QHb4iXE1rU/iOt0GvE
	UNHiV2cVxdU1PnB+jup1AJ3gPzUD+1E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765426897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6yd3nUaH+JVSycTF7AKt0rbB2xusebsv+tukG2IUDQs=;
	b=S+WkzXkFMgmHceM/QDEHzjsXQ8P0/9116jrq3EvHYWkKV6DT+n6NMoyrQ/UEEurBWbTFny
	wlokNNt01Wh9bA1ewuT8kf+DS5ZJ1G/L4gV0Clyx41M7WKN5UAiBbk3uCKnOU6R6SjTf5d
	wlFfXq/GyYReuqwZ8M6cCVS+nFZ980g=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-330-iGScH-pBN-K2E6ksIt0ztQ-1; Wed,
 10 Dec 2025 23:21:34 -0500
X-MC-Unique: iGScH-pBN-K2E6ksIt0ztQ-1
X-Mimecast-MFC-AGG-ID: iGScH-pBN-K2E6ksIt0ztQ_1765426892
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 401681956060;
	Thu, 11 Dec 2025 04:21:30 +0000 (UTC)
Received: from localhost (unknown [10.72.112.161])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F43C19560AD;
	Thu, 11 Dec 2025 04:21:27 +0000 (UTC)
Date: Thu, 11 Dec 2025 12:21:22 +0800
From: Baoquan He <bhe@redhat.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v4 06/19] mm, swap: free the swap cache after folio is
 mapped
Message-ID: <aTpGwg7tHfDJzek9@MiWiFi-R3L-srv>
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
 <20251205-swap-table-p2-v4-6-cb7e28a26a40@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205-swap-table-p2-v4-6-cb7e28a26a40@tencent.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: 7B9212000C
X-Stat-Signature: 8dych5ig1yk95nbsefk1mnyz78o4jwmr
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765426898-774222
X-HE-Meta: U2FsdGVkX19ktelXY+NNGptE7kCr7hOgct22qOhWLEvzu5hIoY0srSooAWezGgNVfhzGsuOM0KwF/W5SlHgESmm9wVcvRUDAN3RzvJ1qpaPFCZ5VaF3pzaAu6XdLhnPtOkO1WLjPMUkp+tBb7o8Qctz30SRzB3eDN1k5ZAXeVQb8S0brqPTvKmzW5Ns2Jsidl610LlDyLhUTK3KDDvPrYn+OycMOkV/r8ns2T/20Lk2bCr/lxvYco3+2i5el+BqEiNzrfG8wdNFBH6MtCQVQe/pDNguqG1a16Dmr0VoKLBv5MZTKE/Pzw9H0ej7XUN8hLyNugg/qjP5+D4iwmiPx/2cd3KLlJBi2WOXnXaZs+8H47U6+EuvQuayRCDbISpfcmtc2Ae9pOO+08TjqrhWsLYLJf6tQGUf7wiMpvU0VvQd1NpM2BCaM7yzXgyQDzkW1nZBcyEenhutv2eYBBmdz+gjSsrB+N7OMhabUAk+TW+u9qCgTeNfIFU66xkbw0fAeCx7l7jtnfEm4IEXvnF07KovDOp/2sougLCTH66THqtap35D5M81hC/wGFrp7Gp/MnizKxMuok3Rx9HrvhIfCV47DXKjGj0y91IblFlep/0/T+iIelszW+hCT5Nxe3JbEZ1k6oXWf0kVHssr8MB7qXHxXumvYvywJHbFghmaJHaDdzcrh5afgztsSq6DYRBxc6O6T4Mii9kGSf/yQo8NhdbQrVWTdwVR8rBIJ7IgZjKEqvgEXzaFqLeG7sAWbmr27TKVQL0BAMOR2/Tl6B+xfvOmFciCv9FQUE2enLltM5fxn0ZoAqqpcodGK/MAbSYlYkeM/e2hNa/WNBgP6rdaPqTZame1ZN1577nqVj81/LZh4YiWD7tLv7O/v47NlFVuymIMo6nU474f1LBc2T8BgnpVt7/QNtfGkUHqXJygxGgMlCm8N2vOaLHABYXGo918FqGQqq/WzVbgUlCI5Rnm
 m9ctM1Oy
 g/tl8lzf6Y7t70Soqyr4XVbIjlu+F+QcgIY2YAQbO2HszZqn/o8E2MMAbbiC/CeMxgyOZGTxiWiC/gM7DooURvLZVsWq7Xpwsg2M8OK28V2kkSJE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/05/25 at 03:29am, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> To reduce repeated faults due to parallel swapins of the same PTE,
> remove the folio from the swap cache after it is mapped. So new faults
> from the swap PTE will be much more likely to see the folio in the swap
> cache and wait on it. This does not eliminate all swapin races: an
> ongoing swapin fault may still see an empty swap cache. That's harmless,
> as the PTE is changed before the swap cache is cleared, so it will just
> return and not trigger any repeated faults.

It may be clearer to mention that this patch makes change to defer the
swap cache freeing from before pte mapping to after pte mapping.

Other than this nit pick, it looks good to me.

Reviewed-by: Baoquan He <bhe@redhat.com>

> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/memory.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 3f707275d540..ce9f56f77ae5 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4362,6 +4362,7 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
>  static inline bool should_try_to_free_swap(struct swap_info_struct *si,
>  					   struct folio *folio,
>  					   struct vm_area_struct *vma,
> +					   unsigned int extra_refs,
>  					   unsigned int fault_flags)
>  {
>  	if (!folio_test_swapcache(folio))
> @@ -4384,7 +4385,7 @@ static inline bool should_try_to_free_swap(struct swap_info_struct *si,
>  	 * reference only in case it's likely that we'll be the exclusive user.
>  	 */
>  	return (fault_flags & FAULT_FLAG_WRITE) && !folio_test_ksm(folio) &&
> -		folio_ref_count(folio) == (1 + folio_nr_pages(folio));
> +		folio_ref_count(folio) == (extra_refs + folio_nr_pages(folio));
>  }
>  
>  static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
> @@ -4936,15 +4937,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  	 */
>  	arch_swap_restore(folio_swap(entry, folio), folio);
>  
> -	/*
> -	 * Remove the swap entry and conditionally try to free up the swapcache.
> -	 * We're already holding a reference on the page but haven't mapped it
> -	 * yet.
> -	 */
> -	swap_free_nr(entry, nr_pages);
> -	if (should_try_to_free_swap(si, folio, vma, vmf->flags))
> -		folio_free_swap(folio);
> -
>  	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
>  	add_mm_counter(vma->vm_mm, MM_SWAPENTS, -nr_pages);
>  	pte = mk_pte(page, vma->vm_page_prot);
> @@ -4998,6 +4990,15 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  	arch_do_swap_page_nr(vma->vm_mm, vma, address,
>  			pte, pte, nr_pages);
>  
> +	/*
> +	 * Remove the swap entry and conditionally try to free up the swapcache.
> +	 * Do it after mapping, so raced page faults will likely see the folio
> +	 * in swap cache and wait on the folio lock.
> +	 */
> +	swap_free_nr(entry, nr_pages);
> +	if (should_try_to_free_swap(si, folio, vma, nr_pages, vmf->flags))
> +		folio_free_swap(folio);
> +
>  	folio_unlock(folio);
>  	if (unlikely(folio != swapcache)) {
>  		/*
> 
> -- 
> 2.52.0
> 


