Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A132EEC1116
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 17:58:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B86046B0005; Mon, 23 Feb 2026 12:58:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33876B0089; Mon, 23 Feb 2026 12:58:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A35A06B008A; Mon, 23 Feb 2026 12:58:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8BF7B6B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:58:53 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E739D1B586D
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:58:52 +0000 (UTC)
X-FDA: 84476482104.03.4DDC917
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 43EAB20004
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:58:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qypjK432;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771869531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X6hhQd/zwZB5Y7oNLD/9Y+hbvtBW2IoFn4XVI5CiByI=;
	b=X4HoHkH9MHs+Uxix88AITLqmO7wtIB4MZ6bofUrSBv7M/dqzHqYDErz8giLHlbrP+ueiId
	GbpKjYBzwdJHwjBmNIy/k5UW8YKKtgKFAEJZD4k3GyA8FAy+sf8TdVYnew+2cEBqKdAs7C
	zYke0AQOTF4LlpLtOOIlzANpSfRWVm0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771869531; a=rsa-sha256;
	cv=none;
	b=gln3rW5Q4gi0GefmTtmc9ov/KOfZsoCCnAEjQAZCY6no8BrvP0QLkmABHpx+JI79GyBrUw
	4WCwULO+6AU6qWdcey27+OYdVmv6V8U00OnhqU7fe2RUAJs/SXu2vYnBH9TcEzRVAjLA92
	wJIht4IoJtIhdA5QorrJT1QRf09FL3A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qypjK432;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=X6hhQd/zwZB5Y7oNLD/9Y+hbvtBW2IoFn4XVI5CiByI=; b=qypjK4329fPA5rLc8olYDtNU8g
	6elZ6tCXsbzQ3+WJaFIBDU6ZH8WMYywiC7Aum8RitYn0INkKO5qeF8Gu2Hb/9ldRrBXFAk2wUhq2t
	GbnZ9eozDGHRw11crd1NOto27vnQ8vuHVhZxCwP+WLzGwNZrocwg7AvIa7ZJdOkB3QuDKG610de6b
	rhDUUYMpxFhu8s5Jp/NpCk/zlr7hlhwlcE6Evg9Vx2oiuuwDr1foWQQ40GhXbj3lv9g+pTm9jS69f
	AiOA/otQNvoDJFXXziwBwSJ7R1WIDoHYtaZr0hQQSrs1Xd56/7N2fDfegr9pti9K4oBSZnAQo/d43
	kObriIIg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vuaCk-0000000ErtN-392U;
	Mon, 23 Feb 2026 17:58:46 +0000
Date: Mon, 23 Feb 2026 17:58:46 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH v1] mm: centralize+fix comments about compound_mapcount()
 in new sync_with_folio_pmd_zap()
Message-ID: <aZyVVl5qcJsfhKuE@casper.infradead.org>
References: <20260223163920.287720-1-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260223163920.287720-1-david@kernel.org>
X-Rspam-User: 
X-Stat-Signature: 89imzhsgbgzfxb1b43ew9i41wtr8ix7e
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 43EAB20004
X-HE-Tag: 1771869530-763423
X-HE-Meta: U2FsdGVkX1+sw7IgZkEkOPIO7glm2JhvGaSJ0LWgSG/FoFxD7rkhSH2AZqZ6pBm+wHOaP7LTMjpETYK9OxlKR8QmFgAhIR+2aLOIH2hEFfmD+5+xJoVfnfhB5l97cRlJjKmsOaJDEkxkQZ0Wi1JP5ixptwUHOs+cnie0+ES4reyLsIEulkZz/eGot54cjvG4jUnyMMV9Ocy5x+9X1VCG5XvVTz7zqWK8pImCw8DlmPG2byYw+fpS1ZenlL30pAcupEOmVrRRI4OT2bGRi8u9Wf79nBu7pDvI6YP26irsV6IhOgaO36mJXdBRX6srjYQIidYzrmn+/wmNZWTEYBcX5TfXDEZdnW7JqDGkGKHCeWWC27jPaAa7s1swE529oOzCdd9q5mCYYOe4m0hSKp4C83wDVyU/5nWS5N0BrOUN/iKlM/00MFiDFXzRLbjEeaE/tto+DFXK5xg8DglBe3h//0/BAZa/uWzx8vLVnYsyTXgf8ELut04bbXn/gHXf4XxNyBlNIl7Nx0TgsTLvqsHfUJRGpckN3MAUv29aW3hAlBFhAdP2ZcEYe6v6847t+WecrbhQPTcCtXxi+Yw9YI+5nPr5CvzFSx8Qi+sj1QbII01XC830IJRIbAJ5nuXNOyH7gfu7lqale4SPKJcm7a9LuiJ68u0sOqX2d1bx+NJ2SKS3u3mH2QDZMqbUkdKjg134xZ5Yh9/K9gEUUB/KXFZP+zNrgCrjtKF8g57078mYgAtLJZ5tevz8jQT20hW3exUQBrJD4+uWyCwy9UEjxBcrgQoZsks3rriOA6lvs7ynM8Vu3RkwT0kGEaFIiw5DVhUq/W+0A+hXihVetuiy9wOoa0m9Q6+DKefAnNQwSdc5DIu+DsUxGYAY+S0U8BMCbOZwoCuE1apeL2eBPPdOR9jhN4oELP0RxHTMNzwd8IvV+BN47BVZWg7GubVSzJXmNqHxh87ekf1JlCtQIDm8p2S
 W2oLz8h8
 Ij2UhJSVWtZJK0IN+04++dVCKx0Rl2wmhU8nIbF9ya6EyILifIYyXe0/Q5t3QLzOdBsWFQPsY5d0HhpT2M2gnSRlfZ+Fjk+Y7884g2LSPemKhd5oh1MwEN0HWh6o3u6mOX+FjfciyNdVVybI+gcqCggTAWWUxZ1zzvMgykyzmkcgFEHPhgCx89CffVDnTVZ6EitylE1tbtUpgbVSwmDpkru6A7gYQWdzk1Z/H5bLxsT5bq+Kdg1hnP0nppqzdBe5Rr4EfyKSqzcWFiXFz4Oy6hP9XvkaSTnkWhgw9uEUhS7doU5OTUPOjnXJuqE229MWQyDtWgVx6Sl+ioZs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 05:39:20PM +0100, David Hildenbrand (Arm) wrote:
>  void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
>  
> +/**
> + * sync_with_folio_pmd_zap - sync with concurrent zapping of a folio PMD
> + * @mm: The mm_struct.
> + * @pmdp: Pointer to the pmd that was found to be pmd_none().
> + *
> + * When we stumble over a pmd_none() without holding the PTL while unmapping a
> + * folio that could have been mapped at that PMD, it could be that concurrent
> + * zapping of the PMD is not complete yet. While the PMD might be pmd_none()
> + * already, the folio might still appear to be mapped (folio_mapped()).
> + *
> + * Wait for concurrent zapping to complete by grabbing the PTL.
> + */

I like this.  The one thing we've lost is the name of the function which
does the zapping, which I think was a helpful detail.  Perhaps not to
someone who's deep in "how page tables work", but I wouldn't know where
to look for the counterpart to this.  So how about:

Option A:
+ * When we stumble over a pmd_none() without holding the PTL while
+ * unmapping a folio that could have been mapped at that PMD, 
+ * zap_huge_pmd() may not be complete yet. While the PMD might be pmd_none()
+ * already, the folio might still appear to be mapped (folio_mapped()).

Option B:
+ * When we find a pmd_none() while unmapping a folio without holding
+ * the PTL, zap_huge_pmd() may have cleared the PMD but not yet
+ * modified the folio to indicate that it's unmapped.

(for both options, I'm just changing that one paragraph; the paragraph
starting "Wait", I would leave unchanged)

> +static inline void sync_with_folio_pmd_zap(struct mm_struct *mm, pmd_t *pmdp)
> +{
> +	spinlock_t *ptl = pmd_lock(mm, pmdp);
> +
> +	spin_unlock(ptl);
> +}
> +
>  struct zap_details;
>  void unmap_page_range(struct mmu_gather *tlb,
>  			     struct vm_area_struct *vma,
> diff --git a/mm/memory.c b/mm/memory.c
> index 876bf73959c6..c87d796050ba 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2006,13 +2006,7 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
>  		} else if (details && details->single_folio &&
>  			   folio_test_pmd_mappable(details->single_folio) &&
>  			   next - addr == HPAGE_PMD_SIZE && pmd_none(*pmd)) {
> -			spinlock_t *ptl = pmd_lock(tlb->mm, pmd);
> -			/*
> -			 * Take and drop THP pmd lock so that we cannot return
> -			 * prematurely, while zap_huge_pmd() has cleared *pmd,
> -			 * but not yet decremented compound_mapcount().
> -			 */
> -			spin_unlock(ptl);
> +			sync_with_folio_pmd_zap(tlb->mm, pmd);
>  		}
>  		if (pmd_none(*pmd)) {
>  			addr = next;
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index b38a1d00c971..a4d52fdb3056 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -269,11 +269,6 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  			spin_unlock(pvmw->ptl);
>  			pvmw->ptl = NULL;
>  		} else if (!pmd_present(pmde)) {
> -			/*
> -			 * If PVMW_SYNC, take and drop THP pmd lock so that we
> -			 * cannot return prematurely, while zap_huge_pmd() has
> -			 * cleared *pmd but not decremented compound_mapcount().
> -			 */
>  			const softleaf_t entry = softleaf_from_pmd(pmde);
>  
>  			if (softleaf_is_device_private(entry)) {
> @@ -284,11 +279,9 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  			if ((pvmw->flags & PVMW_SYNC) &&
>  			    thp_vma_suitable_order(vma, pvmw->address,
>  						   PMD_ORDER) &&
> -			    (pvmw->nr_pages >= HPAGE_PMD_NR)) {
> -				spinlock_t *ptl = pmd_lock(mm, pvmw->pmd);
> +			    (pvmw->nr_pages >= HPAGE_PMD_NR))
> +				sync_with_folio_pmd_zap(mm, pvmw->pmd);
>  
> -				spin_unlock(ptl);
> -			}
>  			step_forward(pvmw, PMD_SIZE);
>  			continue;
>  		}
> -- 
> 2.43.0
> 
> 

