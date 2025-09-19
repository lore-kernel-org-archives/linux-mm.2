Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 651BACAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 21:27:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C20368E000B; Fri, 19 Sep 2025 17:27:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA9A08E0001; Fri, 19 Sep 2025 17:27:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A71998E000B; Fri, 19 Sep 2025 17:27:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F6BE8E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 17:27:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E82AC0284
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 21:27:51 +0000 (UTC)
X-FDA: 83907287142.18.793F1F9
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf02.hostedemail.com (Postfix) with ESMTP id 598A580004
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 21:27:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fDz9MGq6;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758317269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8gyzPijsRQmycSlmSoB0622QIHLdkNIiCzOl4oHy+DM=;
	b=PDdO2YYtSTcwo3PWSvpQNyKGVmDqvRtkgzIgAHH3if00VBsYWb95pQOLIh8+Nux8ttUwo+
	SwSDZ6etNI/KSpuzvsA0E/9TeuoXzCl8fw5PUMKPhDiS3U7/L6BSTkPshABgmLy6Z57UKb
	ON7X0A9okWBgHJe00Zb1Jk4VyGdQ+qM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fDz9MGq6;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758317269; a=rsa-sha256;
	cv=none;
	b=xMtl3T4ukeQWFBOEqlFB5iy3rdT4pU+Dx/2aC+jIrUxn1Ld5/L+yGUQNZdEaCEcw2E1YgS
	f+O75uWrwdBME5LwYuTif/GlSnx4kRVqGZFdFBlDJvXODrQnZpo0mfiuRQiZCJ/z8xtcnn
	AEXuX7upfID9rLE7g7bRGSxdRpJlaRw=
Date: Fri, 19 Sep 2025 14:27:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758317267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8gyzPijsRQmycSlmSoB0622QIHLdkNIiCzOl4oHy+DM=;
	b=fDz9MGq6DnN1sSS2hVmApGdHwuv9k1E5krScublyJNvR3lORvZetxJil1pMfHTiPQApxQZ
	iIca+2QNrwk1IcuFVi0Nr6oNY0/MpgyrrEwZC3g2dlm9JwYrirRhzVl1p61F+WpeW1rdXk
	p2nlhkRmS4FkAL+i9WZ1IhPuwvCPoFc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCHv2 3/5] mm/rmap: mlock large folios in try_to_unmap_one()
Message-ID: <27wxlfhnkxaat57lzyzlpo66vse3jjhp422ziswbl4oyjnamif@2jx25dwgkame>
References: <20250919124036.455709-1-kirill@shutemov.name>
 <20250919124036.455709-4-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919124036.455709-4-kirill@shutemov.name>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: duro9fbageyxw1hyufcmhossaa58dx8t
X-Rspam-User: 
X-Rspamd-Queue-Id: 598A580004
X-Rspamd-Server: rspam04
X-HE-Tag: 1758317269-498653
X-HE-Meta: U2FsdGVkX1/Zkg/gQVC/QKLeR8vW2IDdTxo+EiXv7dXei+y9N0cJe+dNo0hlrc/Y9cUNxIJWs2oZhOV9LYqqIphu1ZUWg0bRvWtmSaomCaBkh0a6xpiPWXYy6iLXih6xobDD4ZmFr3v2+bHoe/ZmKV3zr1u+XXNdl+26iQtzC/GVPZJhGBfIsBJdf7dshqbIUrUD+UmWIUxSYbI27B5Wbx4Y2zlLSx9Cr3Qh5ZTRyDrrCV96HYm0+zoltEqHEPf2WOfwl8cB9eFO5Cb1EoFVLmb8tJZMH0kRNGSZ/HKkHttv21+6yWF7ncQ3pfFYcwgic7J8U3fkCtcQXPi3dagFuhwW2cAUIG2BtuxvnCxZhadH4aPOMiQb0ygr+Jm8MES3KtjvmaivY/y7cjOL5TiOoDB7ni7nEUQQg0WdsAm3aH7HxtSvDfIaDtjqEqmbnN3RTDOofh1Pte6Iyj9R/7CSvY6uDZ64YFX88T+5GGx2Sa7dz/JTEWQarc2tVfRQWsE+gBe29NOEDIGqihCeRVkOkSNMuejyxVCPDGLZ562ZMJse9Ps7hfoRlBklSiqTY5fir9Bbt0ZW49m45t+6P1ndAOQtE1Su1qbxjpLqRTTidoZbs3EzRphM49eUWmQROlwWRqeDLjBWUrS/9WlGi7KhqYSr/ZM00oThzORr5iqtUq4QQbsRgk0fEUy9/hcA9p06jySpSPBqMFK0GFovhD1QR4iALqLm35gkRhvUU4Erz/OTWjK7EWlswRy9ve1JPSB1P6ASpbpSjHqaNAEro/AXFQp8MyVmSOicldHTfBpBY9y6aYmvbUUOl8d77FaD6Lz1trjkMjbId/etZ+qd3fcRXXxsa/N4onezCPcy5iJEPJ+PXC2U4dwenE5e8uGEE4g33Pe+JL1l+xY8uoFuy+QocTdTWJXi9//x0/eUl3lEJJoKV7pVj5qa1jyeOTa8YUPeoGjid2qkd6bbfnOHQvG
 cixQmvlp
 H1QROJq7P+hKgFYEOFn4q2pzMVz9yn/yIyb2xMBoqDFEdM+6QpEXP0kkunSBw5v/Vkeex5eMDAEBvLs7km6tYK1n4zcVDzSnp2UXPxVxLVTzd3fOdsuzGG3HLQ2ir7NE9XMQNh5F5OAZ05JOv9Wp8kpE2U43Yd2GkC3Es5Ea37Y+dBdUyrE2uV3txgeZ44uTjNsv/ASgcDNP1nVl0OlLQMvgi5ZjxS8uVBCUvp++icZIZ2M9TXQSFf9wA2q8eD8FTXVMZ6SMAmGYh9IR5Kdv3gke0Og==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 01:40:34PM +0100, Kiryl Shutsemau wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> Currently, try_to_unmap_once() only tries to mlock small folios.
> 
> Use logic similar to folio_referenced_one() to mlock large folios:
> only do this for fully mapped folios and under page table lock that
> protects all page table entries.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---
>  mm/rmap.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 3d0235f332de..482e6504fa88 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1870,6 +1870,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  	unsigned long nr_pages = 1, end_addr;
>  	unsigned long pfn;
>  	unsigned long hsz = 0;
> +	int ptes = 0;
>  
>  	/*
>  	 * When racing against e.g. zap_pte_range() on another cpu,
> @@ -1910,10 +1911,26 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  		 */
>  		if (!(flags & TTU_IGNORE_MLOCK) &&
>  		    (vma->vm_flags & VM_LOCKED)) {
> +			ptes++;
> +			ret = false;
> +
> +			/* Only mlock fully mapped pages */
> +			if (pvmw.pte && ptes != pvmw.nr_pages)
> +				continue;
> +
> +			/*
> +			 * All PTEs must be protected by page table lock in
> +			 * order to mlock the page.
> +			 *
> +			 * If page table boundary has been cross, current ptl
> +			 * only protect part of ptes.
> +			 */
> +			if (pvmw.flags & PVMW_PGTABLE_CROSSSED)
> +				goto walk_done;

Should it be goto walk_abort?

> +
>  			/* Restore the mlock which got missed */
> -			if (!folio_test_large(folio))
> -				mlock_vma_folio(folio, vma);
> -			goto walk_abort;
> +			mlock_vma_folio(folio, vma);
> +			goto walk_done;

Here too?

>  		}
>  
>  		if (!pvmw.pte) {
> -- 
> 2.50.1
> 

