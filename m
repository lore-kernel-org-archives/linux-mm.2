Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06552CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 13:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E69136B0093; Mon, 22 Jun 2026 09:46:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1B116B0095; Mon, 22 Jun 2026 09:46:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0A296B0096; Mon, 22 Jun 2026 09:46:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A6A9E6B0093
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:46:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 053E1140176
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:46:49 +0000 (UTC)
X-FDA: 84907674180.09.34B561A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6798CA0006
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:46:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n1L1W/pK";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782136008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KBrYpAt0fcYYHAE06TXqvrMNJSvx95b7CU6adYHciUQ=;
	b=1aC1RygBGkNhXW7+F8oW2VyVO9Oh5NPBWUqn5X3gOHAly9jQGeWQeCzEWrfrCONixo7Tg7
	0OTzJMJZyR4/XiOn/D5UcA6HkUUWdoB6Se9iTdbbKT4+Z5vYkVWFF9ilz1yRgv7PmsWnwY
	1m8nZvE5uA0mZvXWj8L27rzVpTufSMA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n1L1W/pK";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782136008;
	b=nm7K10t5kLVMTEXC5wSUQ1COpaST0eMyylMrk8jv544t+TENGh4rRMYxWUaUifZLmF6WHa
	pAGp1ZWdGxIMI/ZEhGPDugLACQbYAPUbnz8zhP9sFLNZYX8E6ixCav2CZl108Abnn88cpA
	UZenEwL1f1eG8qftIUfhmtCTMgYvl5g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D9163601F3;
	Mon, 22 Jun 2026 13:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38AFE1F000E9;
	Mon, 22 Jun 2026 13:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782136007;
	bh=KBrYpAt0fcYYHAE06TXqvrMNJSvx95b7CU6adYHciUQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n1L1W/pKS03XydAfkjGJXl8EGD/W2L8vpd+vjCBHE4vZJpr/yxPmwO3xtV5prNw5m
	 QAIhosGROdRNBFiPFSLiLZ700JCXa4ljxF9IbB0ppS7TqVD9e6FEiWIQULWspTXb/7
	 AGQGPCEx7WW3MzyFohJw1XGYD8BgkaFLcnZ7wRNpFya8ZqwZZdov/oqeEFjeWlahoc
	 YqyNXqkRNEBfKUhmIcuN/UY8b/e7+/3lYOXCm7AL6LYdBRAIbypoH4NWqD30jVVrP1
	 ClNxPf/1/YfXEmoOChPwRK8X/eS3HYGGY+CN6k0F8Kx+qU0Dl9XU9AEiM5J3CbuKjI
	 GMu5dIjAZgWpA==
Date: Mon, 22 Jun 2026 14:46:40 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, riel@surriel.com, 
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com, 
	sj@kernel.org, ziy@nvidia.com, balbirs@nvidia.com, linux-mm@kvack.org, 
	stable@vger.kernel.org, Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_vma_mapped: revalidate and do proper check
 before return device-private pmd
Message-ID: <ajk0N3Aekapljaoh@lucifer>
References: <20260622130651.23359-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622130651.23359-1-richard.weiyang@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6798CA0006
X-Stat-Signature: 5wx5cqrish64o9y3jagnn8eu68boegb9
X-Rspam-User: 
X-HE-Tag: 1782136008-240997
X-HE-Meta: U2FsdGVkX1+xt08CT6iceGC690sLSUtdioYgejSK6hz2TeUkACv++8ITjqT0Iz15vhz5LXWzefu0IXmSxQ9v0xM849478Dop2F+rBBbvOx45ntbEAYwgTTDoY8YW4Wuy+BOMHx1Y0VF1n9b2r8dIhx7Oaix2wyxmaySH4rradurRJJRQdDDmovEP7hm2PcWLyoshcIIYXS9Q+U8l/HE+OwKnOTfigjZEoZ8RtemabTDcCgj6VcPmAshM0qM7av4SMVU54MMuY5drX1FOM5wVkHdWYYdeWMZE18Vuh0zWu0SxUoSpe7x+Nl/bFBNh4lXBkk6Kh+jWbcueWuGhhJMxZYgGyathGHyP7g6TNsRPD0fJar2r6Y3ZIe47SKbfcU1o/z35RpDe4ExvnuMyCF5t7kHy/ZqWXGPaq6tk61wkNGdPP8BWLoP3FwFD4k0NPIVkmZlUeumsIu19mxZJeS10sm2gFRyR8adMJi3C7s+6FwV3s4zxzlyBN3ZETzxuG1m2GmPY0ZIlu7wSJcbyRUwV7Z/aQYCbvliZapzKfk1Md5KoU2iC1tmfDl7rYJQnN3edlSRVTTtQsom65EaRTPSvn2b1LD4gZNcSVkkI/rO7P5J8rB5ldNEROqyLM+3Fo3HIoU65sbjMQIXs5qTIx9sHQfzbn4yhVbvNvaeaKZCBTQW9IoKpZWrzkKYMn7ry15p7tf0LuWV2M3xhR5pSEKdG+MlRirU2ynRR4sEPjWd3b6dyhvHBf39dAwJ1ACZr+NkYeM3JFnvLDYGQ8zj9St6wxjJvjuRxZouZC8kjvSCNVZSa1yKEP9uzBiKaREAQNawvKVVpeH5pgnVg6/sRXSjw97EOZ1hfIICLoQfpQijcgWAyYt1K+acHmxP61kuIBc1UIshw7Gy7a5w8cJ3+9mLfs9wCFQWUWh+D1rGAV9YwnUlBUuYmck9m0Nb2TuH0O1wDHZcqDJD0ovLCq1Cjms/
 eB1Yb/sN
 UDSKe3OY+g2+paTThLDB4DxiifcpL4N8yaBHx4HiIsfj0q6dxUVFts02U1IxA63E9o8Me3wb0LfyTWK7YO+j1E+ATfvEmFZTb7SXkKD68nCqaAYEZ5mVOeobUljiu9ABZyMGwhY9B58XnV6VKyBO2dU4bJxBmp0nil6murEtp//E2mM+WKlKwprl9Q9925TmaWnW5wPDqSzC8udXQ5kfWypRJIGQnIODCXTsNtZcwiAlkD2L6f2rvmz9Ns8m+Q3ITm1x2N3rmAtZMNkYDabfEoIoDAFJSOQ5FMNNsCznx9f34KsuyJVwSmahRB49N7Y6+QcSV27MZYtLYdDLeb2bGWPKBm2NjYMXeqFCLV3tiMxPOpbDqNIowkJXEs17hOjUWWKQydcOU56OH13vD2ENHrCS0ZIsQacs+Fbr4K61+7r0Mp/kuAXjt1+9sZWL+29oUjmPc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Lance, linux-kernel

Your subject line is 83 characters long and is way too detailed how about 'fix
device-private PMD handling'?

You forgot to include linux-kernel@vger.kernel.org on the mail, lore seems to be
a bit broken atm but in general it's helpful to include that.

Also is useful to make this [PATCH mm-hotfixes] to make it really clear it's
intended as a hotfix.

Some commit msg language nits:

On Mon, Jun 22, 2026 at 01:06:51PM +0000, Wei Yang wrote:
> For pmd_trans_huge() and pmd_is_migration_entry(), we does following
> before return the pmd entry:

Sounds better as:

	For PMD entries that satisfy pmd_trans_huge() or pmd_is_migration_entry(), we
	perform the following actions:

>
>   * re-validate pmd entry after PTL
>   * check PVMW_MIGRATION
>   * check_pmd()
>   * handle on pte level if split under us
>
> But for device-private pmd, we just return after pmd_lock().

->

	However, for device-private PMD entries, we simply acquire the PMD lock
	and return.

Also can you please give some justification here as to why all this also applies
to device-private PMD? Right now it sounds hand wavey.

>
> If a softleaf entry is present, e.g. device-private pmd, the existing
> code simply acquires the PMD lock and returns success even if
> PVMW_MIGRATION is set (indicating a migration entry is sought), meaning
> that the caller can incorrectly interpret the entry as something it is
> not, causing data corruption.

This is repetitive, you already mentioned device-private PMD, you already
mentioned that it simply acquires the PMD lock.

You should talk about what issue it caused and why:

	This is particularly problematic when PVMW_MIGRATION is set (meaning a
	migration entry is sought), as it causes a device-private PMD entry to
	be returned with a different data layout, causing memory corruption.

>
> This patch fixes commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration
> support device-private entries") by following the same pattern as
> pmd_trans_huge() and pmd_is_migration_entry() for device private entry.

This is pretty useless. We see what patch it fixes in the Fixes tag, and you're
just repeating things you said above, I'd drop it.

>
> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
>
> ---
> v3:
>   * remove cleanup part, only fix the issue for device-private entry
>   * refine user effect description based on Lorenzo's suggestion
> v2: https://lore.kernel.org/all/20260616063436.20455-1-richard.weiyang@gmail.com/T/#u
>   * specify the possible error case of current code and user visible effect
>   * besides fix, cleanup the pmd entry handling based on David's suggestion
>
> v1: https://lore.kernel.org/linux-mm/20260508013728.21285-1-richard.weiyang@gmail.com/
> ---
>  mm/page_vma_mapped.c | 32 ++++++++++++++++++++++----------
>  1 file changed, 22 insertions(+), 10 deletions(-)
>
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index 2ccbabfb2cc1..8de3c6b82df6 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -270,21 +270,33 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  			spin_unlock(pvmw->ptl);
>  			pvmw->ptl = NULL;
>  		} else if (!pmd_present(pmde)) {
> -			const softleaf_t entry = softleaf_from_pmd(pmde);
> +			softleaf_t entry = softleaf_from_pmd(pmde);
>
>  			if (softleaf_is_device_private(entry)) {
>  				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
> -				return true;
> -			}
>
> -			if ((pvmw->flags & PVMW_SYNC) &&
> -			    thp_vma_suitable_order(vma, pvmw->address,
> -						   PMD_ORDER) &&
> -			    (pvmw->nr_pages >= HPAGE_PMD_NR))
> -				sync_with_folio_pmd_zap(mm, pvmw->pmd);
> +				entry = softleaf_from_pmd(*pvmw->pmd);
>
> -			step_forward(pvmw, PMD_SIZE);
> -			continue;
> +				if (softleaf_is_device_private(entry)) {

This is all very horrible. You have an example of how pmde is re-got in the
pmd_trans_huge() branch and pmd_is_device_private_entry() exists...

We can just make this another branch and do the re-check more neatly.

I enclose a patch that does that (untested, please check).


> +					if (pvmw->flags & PVMW_MIGRATION)
> +						return not_found(pvmw);
> +					if (!check_pmd(softleaf_to_pfn(entry), pvmw))
> +						return not_found(pvmw);
> +					return true;
> +				}
> +				/* device-private pmd was split under us: handle on pte level */
> +				spin_unlock(pvmw->ptl);
> +				pvmw->ptl = NULL;
> +			} else {
> +				if ((pvmw->flags & PVMW_SYNC) &&
> +				    thp_vma_suitable_order(vma, pvmw->address,
> +							   PMD_ORDER) &&
> +				    (pvmw->nr_pages >= HPAGE_PMD_NR))
> +					sync_with_folio_pmd_zap(mm, pvmw->pmd);
> +
> +				step_forward(pvmw, PMD_SIZE);
> +				continue;
> +			}
>  		}
>  		if (!map_pte(pvmw, &pmde, &ptl)) {
>  			if (!pvmw->pte)
> --
> 2.34.1
>

Thanks, Lorenzo

----8<----
From e6a3c1c782714ed831c4d46a14bb99226423bf59 Mon Sep 17 00:00:00 2001
From: Wei Yang <richard.weiyang@gmail.com>
Date: Mon, 22 Jun 2026 13:06:51 +0000
Subject: [PATCH] refactored

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/page_vma_mapped.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 2ccbabfb2cc1..17dff8aab9f9 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -269,14 +269,24 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			/* THP pmd was split under us: handle on pte level */
 			spin_unlock(pvmw->ptl);
 			pvmw->ptl = NULL;
-		} else if (!pmd_present(pmde)) {
-			const softleaf_t entry = softleaf_from_pmd(pmde);
+		} else if (pmd_is_device_private_entry(pmde)) {
+			softleaf_t entry;
+
+			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
+			pmde = *pvmw->pmd;
+			entry = softleaf_from_pmd(pmde);

-			if (softleaf_is_device_private(entry)) {
-				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
+			if (likely(softleaf_is_device_private(entry))) {
+				if (pvmw->flags & PVMW_MIGRATION)
+					return not_found(pvmw);
+				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
+					return not_found(pvmw);
 				return true;
 			}
-
+			/* device-private pmd was split under us: handle on pte level */
+			spin_unlock(pvmw->ptl);
+			pvmw->ptl = NULL;
+		} else if (!pmd_present(pmde)) {
 			if ((pvmw->flags & PVMW_SYNC) &&
 			    thp_vma_suitable_order(vma, pvmw->address,
 						   PMD_ORDER) &&
--
2.54.0

