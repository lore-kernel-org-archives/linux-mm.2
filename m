Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3914606A33D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aTRgtmOz
Received: by kanga.kvack.org (Postfix)
	id C5BE56B05B1; Mon,  2 Nov 2026 07:10:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C338F6B05B2; Mon,  2 Nov 2026 07:10:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B49D06B05B3; Mon,  2 Nov 2026 07:10:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86FD46B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:10:30 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 281B640CFE
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:10:30 +0000 (UTC)
X-FDA: 85390061820.29.30500DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6A69440005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:10:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aTRgtmOz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793621428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3utIN8YKJONR4bZfSrqvEFZtlbFS+VytSozFfR8XdPY=;
	b=eajjUNtEdMZGreLj1yurHCqrJ/eCrPzu2k7QUbP0kUbcDZc94K2QjfEReKpa7BkJqUsHVq
	TAhhE1dBWb9+PmWXj/NfCzDxFoYzWdEtre6+6Oudrv7VgUnbET7tmVkBeu91bBKQxKDUhp
	OqDRdBi5rdpqqxzDnwESk98K3kmVg0c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aTRgtmOz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793621428;
	b=c/TvW65Od+4/NMK4MLw3rgS9c3RXZI7R5iOjC0ytCx+Kt3kprmw2EWr5Io3ycpkJ5HVG1q
	IY7Jn661jaxxYKCEhZjuj93ISV4mWcUvinkNfKyr60wVDIaJ2jlkWGmjLtb3ROvdn1MRgs
	vSZS2fbLoOA9HsGzqCkSM20tjWdrsLw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6B21860DC0;
	Mon,  2 Nov 2026 12:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A701F00A16;
	Mon,  2 Nov 2026 12:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793621427;
	bh=3utIN8YKJONR4bZfSrqvEFZtlbFS+VytSozFfR8XdPY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aTRgtmOzmbjZMD8o/Yfhau75xpDuPVwSjbUdT9/1ddYs0vxkVN5gfVtfa6AeHugJE
	 6p0EjfwBz1QCy7cUFXbxSMmd++Zuci3wL9KZY9HkNjNqA6RZ6fWvzK9WWwXPLIt5P+
	 nTlCWkKdvpHWsmQc6PNH2XYPgh1VnpFf6WTmaREU8N0AM/gEvaSqYRinEK4MoBqs32
	 1b69rW65aABhTvPO0WcTzb5fPeQCqUqUbgkFL7DkjSLSiw9b8mWGjPm2os0u/kfsHI
	 PNzZ8QlmuNnlfL0+s7C277kCdDO1OzsZ+sr/ypd7OPV6snYJo7/9p9Iac8Rkb//PrI
	 n+SfqjJzKjj1w==
Message-ID: <85c4a87b-2c8b-4ef5-bb30-6518080f8be0@kernel.org>
Date: Mon, 2 Nov 2026 13:10:21 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm: internal: fix inconsistent in
 folio_pte_batch_flags() for shadow stack
To: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@surriel.com>,
 Yuan-Hao Hsu <aa9736195201@gmail.com>
References: <20261102-refactor_gup_fast-v2-0-bc1ac018c834@arm.com>
 <20261102-refactor_gup_fast-v2-2-bc1ac018c834@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261102-refactor_gup_fast-v2-2-bc1ac018c834@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6A69440005
X-Stat-Signature: d38mmdfsxxje7pqq3si3fkzetsum3t1f
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793621428-64769
X-HE-Meta: U2FsdGVkX1+4cjR4p4RrYzAnRIB3whuqzvX60BxBIWcyHtKKXT7sXG9g0x8UJI51ytn7oUQmJu77R6eV1DLuNdChSHukvTFpLCNvULL+3yZzZuXJ/KE/mDRwop3ejo6U57wGVgn0vpUV4dGy8SPoSqn7Ttjdm2JURRCmk22QgJs2Ctu3ECGynOwd4C1MZTa8puG4izIs2uvQLStBVItqWyz1vuRRXyx7jH3qc6tTvfZl54Ae/ZVUT7tMwa6fkU347Ood1hGIXO3+9yBL8j4l0aVzpZxSbK4F9ChDShH66mnAvbGGXCFRwVB6AQ07b99YZbU8tCOrMF1HI6p1xF5hLCLz636Hz/AIL6XyEUaZxvj5Rbevy93kW2sMGYCwl03agywYzZrGNjEM4gyMWIAjJm+BPxNqPdKmk5wKYpaHBYz8uMJ1/OX+a4yr0sTcrKBRPaev5o41/WYD3U/JUqKnXkE+n99k0dvbVkkZTKVCUk+mVMSuu7tYOcb2nUeJ6STVvhU0zpGbUHbdKcgYhRrGuVElQZpG9LBCP3n+npqenKuntSh9fbQEO8uuhfWdWZ0OjsjOvi1tyaY5nJU/kheP7I9yHKQPJQegA6E8FVGrJl5muLJJEQc6/w5k4qVYo1aZzZJfTVp6IC7UHenJoscunSUnRxl7FIEU0vY25sM9XjxIq9fE2rpZeACGInKcIte7Sh4Q/d6RoOfxjWaKb+ak5YpDaY5eOb5TWOtsZwSPQfQ+9w9NktgkN5m5JIFeQP6F/Iut271eC2gSuiVgE2I3eObn4l9VkuqWN1+8lfmpFOKP1uXpp3j9lWlrDtiAkeBENCSK+XAKI8IKOnNMFVHcruTqRkEIZqe4tg8R7M1O+WIMYH1ujbyqBVOXZZF9UmkLzGRz6N1MFLWtch6VwIGe4itJE49qP+69N56q2JaibcLLVPoN9hZXmuQp/PKMDlApa6qTszLAcX/QNWk6j+/
 3wMPIofo
 +ITL3kTCpCgUyxr/ySrAYwSUyUeV/QjcbhSkPvaijGxk6C5duViV1hgPLsVu1U+zkPETci9DXZZS0LGF/BfDPjFVR6wawBft1s3dKUl3yngt0ZwOgrPMOEldQxaqdnTD5HcSm0Cm9XMAfjsTs8eaduADsjX8MmaxZpP/jxM8KRiXv4K3f1/0XrJp4Lw9X/PWY/hHRENGEn8KxdV8lrRvDMlYDwQ09NepYtdr/zEX7HHJSoqYynWCzbGx57hHnm/PD2sxVkdorp5Zck07sE6yeuZlpGTwJV6xQFPooaCIojYfhpJ7IHftoZDz2FQGNZ6akxBSAE5+szridkwQ7Vxin3ZmkB0g0CtOnaBY1WD5pDXzJYeY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 12:30, Yeoreum Yun wrote:
> In x86, shadow stack PTE is marked with PAGE_RW=0 and PAGE_DIRTY=1.
> If the shadow stack pte entry is consequence with the read-only pte
> like PAGE_RW=0 and PAGE_DIRTY=0, folio_pte_batch_flags()
> with FPB_RESPECT_WRITE without FPB_RESPECT_DIRTY considers both are
> the same.
> 
> To address this, save the first pte's writable and compare subsequence
> pte's writablity with pte_write() when FPB_RESPECT_WRITE is set
> without FPB_RESPECT_DIRTY.


I think this should be patch #1 and likely carry a Fixes: tag.

I think we can already create an inconsistency by using a mixture of

* MADV_HUGEPAGE (overwrite for nohugepage for shadow stack)
* MADV_DONTFORK + fork() + MADV_DOFORK
* FPB_RESPECT_WRITE users

Not that it would matter in practice.

> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  mm/internal.h | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 35016b1afc8bf..b4d0df4c35adf 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -418,7 +418,7 @@ static inline unsigned int folio_pte_batch_flags(struct folio *folio,
>  		struct vm_area_struct *vma, pte_t *ptep, pte_t *ptentp,
>  		unsigned int max_nr, fpb_t flags)
>  {
> -	bool any_writable = false, any_young = false, any_dirty = false;
> +	bool any_writable = false, any_young = false, any_dirty = false, writable;
>  	pte_t expected_pte, pte = *ptentp;
>  	unsigned int nr, cur_nr;
>  
> @@ -438,6 +438,7 @@ static inline unsigned int folio_pte_batch_flags(struct folio *folio,
>  
>  	nr = pte_batch_hint(ptep, pte);
>  	expected_pte = __pte_batch_clear_ignored(pte_advance_pfn(pte, nr), flags);
> +	writable = !!pte_write(pte);
>  	ptep = ptep + nr;
>  
>  	while (nr < max_nr) {
> @@ -446,6 +447,16 @@ static inline unsigned int folio_pte_batch_flags(struct folio *folio,
>  		if (!pte_same(__pte_batch_clear_ignored(pte, flags), expected_pte))
>  			break;
>  
> +		/*
> +		 * x86 shadow-stack PTEs encode writability as RW=0, DIRTY=1.
> +		 * Without FPB_RESPECT_DIRTY, __pte_batch_clear_ignored()
> +		 * considers shadow-stack PTE as the same with subsequent
> +		 * ordinary read-only PTEs. Therefore, check whether pte writable.
> +		 */

That information doesn't really belong in here in that detail level.

"/* pte_mkclean() can remove the writable bit in some cases. */"

> +		if (unlikely((flags & (FPB_RESPECT_WRITE | FPB_RESPECT_DIRTY)) == FPB_RESPECT_WRITE &&
> +			     writable != !!pte_write(pte)))

It might be nicer and more efficient to track if any was readonly/not-writable and

	any_unwritable = !pte_write(pte);

And checking once after the loop.


I checked and we cannot really fix x86 without an additional sw bit to remember
"shadow stack PTE".

As discussed, the simpler alternative would be to just disallow large folios in
shadow stacks entirely for now, given that vm_mmap_shadow_stack() already
disables large folios explicitly.

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4b71d010b2aff..9a2dc90ef9690 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -367,6 +367,9 @@ int hugepage_madvise(struct vm_area_struct *vma,
 {
        switch (advice) {
        case MADV_HUGEPAGE:
+               /* PTE batching doesn't work reliably. */
+               if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
+                       break;
                *vm_flags &= ~VM_NOHUGEPAGE;
                *vm_flags |= VM_HUGEPAGE;
                break;

-- 
Cheers,

David

