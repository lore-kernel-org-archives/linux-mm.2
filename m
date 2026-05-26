Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01613CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 14:42:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 432696B00C5; Tue, 26 May 2026 10:42:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E3856B00C6; Tue, 26 May 2026 10:42:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D2326B00CE; Tue, 26 May 2026 10:42:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B25D6B00C5
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:42:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DDD521A0105
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:42:03 +0000 (UTC)
X-FDA: 84809835726.04.A78583E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 93C1B160007
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:42:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jNNbT1hR;
	spf=pass (imf08.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779806521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p+9Pg6pe8laYawihyMaaO6J8jVwFkXlO5bNdGB91WSE=;
	b=k6BsU2qvC3a+mFxYUfpSaWKrwzc1wgYfsEE+hddmBB4w8aDUi+xS/i5B6vEDRNPyyIYksP
	UxKoG0Q9Jo4Ra4ouMFvV9jaZV2FawmXEHypfSaxmdFF9rpnm6FtcVGQLoy+xv8tvbuEoiW
	wp4rXRY+sXddMQ28LA1YYqZuf8T8Y68=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jNNbT1hR;
	spf=pass (imf08.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779806521; a=rsa-sha256;
	cv=none;
	b=fCVzlb6VqewCuhigPi+/NLe3rL0gR+qe418RlqHr5UytJe64CA8djn8g96xz5UuA4YLza5
	0TASzMDpDRElNhpQuUxGn2IT5p3OBBs/ahZxP4Zw+S8CB86rInMZ8yHwm30a6t7y+UXs5m
	iINGmScs7o0cRNqjdU+WP3PcJTouHs0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779806521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p+9Pg6pe8laYawihyMaaO6J8jVwFkXlO5bNdGB91WSE=;
	b=jNNbT1hR2DW+yMcs66onaKw/CTD0AHidGe6WRENyMH02Bkqu+yjH9Yz6odIiQjT5+347/s
	Ek6JhACjIuM3JNCUzMP70vF3pist97YoGrnpdmSxzBKqg6SujHnXFBITXkItWziaPzzFUM
	mkKtPJ0FAizRijfMhJfJuK7HIhovRC8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-150-LWoLEqpxOJiSnpSyP-8-gg-1; Tue, 26 May 2026 10:41:57 -0400
X-MC-Unique: LWoLEqpxOJiSnpSyP-8-gg-1
X-Mimecast-MFC-AGG-ID: LWoLEqpxOJiSnpSyP-8-gg_1779806515
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48e89faa62eso62925885e9.1
        for <linux-mm@kvack.org>; Tue, 26 May 2026 07:41:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779806515; x=1780411315;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p+9Pg6pe8laYawihyMaaO6J8jVwFkXlO5bNdGB91WSE=;
        b=YgGbJhdDTkV5vPD3IrHEW0Xv/9LloOcy+PDnYRNRbDrw8g7yMwrFbTbKHWU6sqKfWd
         dv7+k/PNMHP+VktFgnCk39IoKnwqRF4HcF5EnwWKwAprTrGuFcW5EsFR7sx56MNh6Ba4
         ajOP/TiZjyakQeVh4gXWNtL2j9KXzNLxwFJOX0OWjduF6FHYMZsTkEnaLAPiI0LfmVX9
         0Tgi9wJPUQ2RNUKgt7+34XpKltKeO8cwvUHd7yxftf6zsTXtcPJc8Oxsrwhl+eaHT3TE
         yeZkN/VoVraMqeSYFLU3UzWw6HbdCMQ5U8fibzbEU3rQhylFl0bnSdY83xqfUPphyvxY
         Iukg==
X-Forwarded-Encrypted: i=1; AFNElJ8fFODG3jnTqyL2zstwF+C1SipfpmlAkeZwg/NZntqn139UQqUZqlpsOvhXRujPzVwLZL/y87xRrQ==@kvack.org
X-Gm-Message-State: AOJu0YyxwrcPNFKT92RSE0vLkgb/opu8Ebm2JtUkpuWDDiLSNWfi5CIK
	4I///fHxoW9PlRtvH67xuMPkhPDGuQ0qDXH6Y9C3WX/qGmo9kdTGnyr3eSTFmfU0UMEwNNutlMY
	+cuG1VHAL7c0oUkhYbcorTRYmp+DCb0BbawbwoLjXjOHg3gSXSnri
X-Gm-Gg: Acq92OEvFGnAuiWh72PhJXxSbgBDRZPgh5/k8ugkKgjmpvTGFQp6axkOXQTxwft2RXZ
	ndqW0frqqoooaFsToL5pjm3d6QTHU9F753ljO89OUtZsdaoKHB7S2ZlfYDMYkkft7BVRbSYqDza
	IqSHxRuHtvzcf8Q2wTTw2C5zGd8m+3rLIYBIBvr040KtM7OU52YCDfq7HYdBuvnsRufNmJyNf+l
	1isAZmKnkfkzrhsOB3CchWyGUZw/dEceTyVRJJkLaxsHva6Vs7Z2z68eNyKo2sDk/QSMfjicEEi
	DrCS8kJPO0K1qphu0fg8U2pTi30Lma2BUTOj2NcI0HaOw90nMrVIDenZYhFM+IMh7UVuXUOXxt8
	4d9spR/zYytAEx6WJXoezRoE=
X-Received: by 2002:a05:600c:3496:b0:48e:6f39:f7be with SMTP id 5b1f17b1804b1-490424a683bmr332132925e9.10.1779806514983;
        Tue, 26 May 2026 07:41:54 -0700 (PDT)
X-Received: by 2002:a05:600c:3496:b0:48e:6f39:f7be with SMTP id 5b1f17b1804b1-490424a683bmr332131765e9.10.1779806514301;
        Tue, 26 May 2026 07:41:54 -0700 (PDT)
Received: from [192.168.1.144] ([88.147.84.123])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d48e23sm34838505f8f.20.2026.05.26.07.41.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2026 07:41:53 -0700 (PDT)
Message-ID: <a48032dd-7881-43c0-b439-5cda6124ea58@redhat.com>
Date: Tue, 26 May 2026 08:42:49 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v18 06/14] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 akpm@linux-foundation.org
Cc: aarcange@redhat.com, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz,
 jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com,
 Usama Arif <usama.arif@linux.dev>
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-7-npache@redhat.com>
From: Nico Pache <npache@redhat.com>
In-Reply-To: <20260522150009.121603-7-npache@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: khsp_akJ0sBDJoOQoVpz8U-ATGhV-KrbNkn9FBa6l3M_1779806515
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3zqzxt1yw3gmoz73cymwxrere8hj8pgd
X-Rspamd-Queue-Id: 93C1B160007
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779806521-840247
X-HE-Meta: U2FsdGVkX18X8OR3lOEmWoy2BeD0ZDIuQKHgy1TGMYB4ehDrekehJo0698heoz2bxos2qK0EzIRiNO+gNOuPvrXoMme2EcQINao7Bo2gPpOE/lLBHb3iXLzVuqA+ahRe0fTM1qSDl8skceA26hrTtrrpg0XGY+AslRiYhGFkUxGmtzHXlDhRkdEfkdzLUtpT7tTUW7bNBbAD3LEIyxPNKav166sw49X/VUclcPIlvcvA7XGx49NIp143XthE4HGEYvi/EN0ZMcTVWjVj7DumJ3VnKwfeTFBjftInlBJcRbu9IriEtsN03NVDGfh+h5SQnKqoJMaRD0Z7QnZYloX6WEG69vucKBLGpgW08N3cFG5Dc0tf2BpNlHHls66HJ0qQthgyzBrEcefXhkJB2LctdtcObrFH0HvnHG2RSYIIPj56Ps+bGQbwBESOcoSYL4Hy3t2TPaTgJhSkn9fmmfSVFAiUs2TBDZL43ucbsEWntlE7Q4R+mwLrTK8CnqPDJrIJVk22QY/p29Vg2YkcDBCsAXweBO9wUUpZV3M1+8LNFYbt7K7cEh6mZXfTaoSec4UNh9YAqkDRxK1zjXGpUg7rNwTayGxQ8IMe2vdlpIOboMj7RoboxeYtDzxkDYaxCNtxtd4NunrZHnT65KHnu+/qfoOh9Tent0RKFZIv++JWwsa2VzpJuSNxkVOQiSKGe7sM3T6h1xt4ZCsp4BPgtQmfzmYO5nvZeR9/u0Wl+UNxUfkrcnmeaisZvll7n0IPedyIiBwjl4BLFKB6jZoNH618mRuwJV4LD4yVqraonQsI35sTNowH1MIyRcm0T2eZsZfBGaRC2AFjckWhvDzbk0g33DheC8q8/j8jApUK2lLJx3D+PygBEZcM2+hgH9euev31+Ckbre1FYgENWrpZWIIA2Y67Sl/ZBgcRbEjYwzOtTvmfJbqjKojVCTjokZkMzdLf64XzPd7/9hsZwKgIDD7
 Z6RVGapy
 Xup9OUa5FJ3tIC1v7agMGIgOhW4Q9Y2ujfTPV2Dg0FHWTOlBexbuuVcYJNu8mTEprFZOQ3VCcAUBeNVrWOavn0A04eYUG9CPvkUTnL4xb76YxYWlVZHnN8sDCS78gpuspW8okQK6MbGS8fFUwprV0GJtPOp4qU54aEpKQFptpngOUB2PS1/adaGP4L30JJqub1Lq+4RbyKVwe2vhMRaaimpRkuj3+2k1xyYUXFZTUSPK/0OwqDts06hCLyBcwYZ0U6qE06ffI2U2bQU0/upV15P1De540oF2KVkPaT1I/zCpKFYl/BaoOLLaiAgEhco5AqWPhPgw6Fo5W60dKID0Cb9WyoxOhSoSHSPDl0rIDsNvmgzXvEf0PEQOxKZX0rhRZAGriio9o8Xof65rp1RwcI1fa0U2dsoeTNHmqoz8x+3v109kUUO0zOsEqlA+7ZyghYwJXz+mXKLDAWNO05J2U0h98Hd255tbAGGG3ONunx0kDTG8kqRqdt9pl0rWJzVHbAX8KJmEm3zAUDoEfiGzCGXi0Kdwil8QZI7jh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/22/26 9:00 AM, Nico Pache wrote:
> Pass an order and offset to collapse_huge_page to support collapsing anon
> memory to arbitrary orders within a PMD. order indicates what mTHP size we
> are attempting to collapse to, and offset indicates were in the PMD to
> start the collapse attempt.
> 
> For non-PMD collapse we must leave the anon VMA write locked until after
> we collapse the mTHP-- in the PMD case all the pages are isolated, but in
> the mTHP case this is not true, and we must keep the lock to prevent
> access/changes to the page tables. This can happen if the rmap walkers hit
> a pmd_none while the PMD entry is currently unavailable due to being
> temporarily removed during the collapse phase.
> 
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

Hi Andrew can you please append the following fixup to this commit!

Changes are described below. 

Thank you :)

commit ed96f34ba40ffd2d6a5b54abe46fd6b480fc89af
Author: Nico Pache <npache@redhat.com>
Date:   Tue May 26 05:54:04 2026 -0600

    fixup: add a clarifying comment and change warn_on
    
    Add a clarifying comment describing how the locking/mmu notifer is handled
    and change the WARN_ON_ONCE to VM_WARN_ON_ONCE per davids suggestion.
    
    Acked-by: David Hildenbrand (arm) <david@kernel.org>
    Signed-off-by: Nico Pache <npache@redhat.com>

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 9ab54397ae08..61d9494293b9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1283,6 +1283,13 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 	anon_vma_lock_write(vma->anon_vma);
 	anon_vma_locked = true;
 
+	/*
+	 * Only notify about the PTE range we will actually modify. While we
+	 * temporary unmap the whole PTE table for mTHP collapse, we'll remap
+	 * it later, leaving other PTEs effectively unmodified. The locks we
+	 * hold prevent anybody from stumbling over such temporarily unmapped
+	 * PTE tables.
+	 */
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, start_addr,
 				end_addr);
 	mmu_notifier_invalidate_range_start(&range);
@@ -1348,7 +1355,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 	 */
 	__folio_mark_uptodate(folio);
 	spin_lock(pmd_ptl);
-	WARN_ON_ONCE(!pmd_none(*pmd));
+	VM_WARN_ON_ONCE(!pmd_none(*pmd));
 	if (is_pmd_order(order)) {
 		pgtable = pmd_pgtable(_pmd);
 		pgtable_trans_huge_deposit(mm, pmd, pgtable);


>  mm/khugepaged.c | 93 +++++++++++++++++++++++++++++--------------------
>  1 file changed, 55 insertions(+), 38 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index fab35d318641..d64f42f66236 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1214,34 +1214,36 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
>   * while allocating a THP, as that could trigger direct reclaim/compaction.
>   * Note that the VMA must be rechecked after grabbing the mmap_lock again.
>   */
> -static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long address,
> -		int referenced, int unmapped, struct collapse_control *cc)
> +static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
> +		int referenced, int unmapped, struct collapse_control *cc,
> +		unsigned int order)
>  {
> +	const unsigned long pmd_addr = start_addr & HPAGE_PMD_MASK;
> +	const unsigned long end_addr = start_addr + (PAGE_SIZE << order);
>  	LIST_HEAD(compound_pagelist);
>  	pmd_t *pmd, _pmd;
> -	pte_t *pte;
> +	pte_t *pte = NULL;
>  	pgtable_t pgtable;
>  	struct folio *folio;
>  	spinlock_t *pmd_ptl, *pte_ptl;
>  	enum scan_result result = SCAN_FAIL;
>  	struct vm_area_struct *vma;
>  	struct mmu_notifier_range range;
> +	bool anon_vma_locked = false;
>  
> -	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
> -
> -	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
> +	result = alloc_charge_folio(&folio, mm, cc, order);
>  	if (result != SCAN_SUCCEED)
>  		goto out_nolock;
>  
>  	mmap_read_lock(mm);
> -	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> -					 HPAGE_PMD_ORDER);
> +	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
> +					 &vma, cc, order);
>  	if (result != SCAN_SUCCEED) {
>  		mmap_read_unlock(mm);
>  		goto out_nolock;
>  	}
>  
> -	result = find_pmd_or_thp_or_none(mm, address, &pmd);
> +	result = find_pmd_or_thp_or_none(mm, pmd_addr, &pmd);
>  	if (result != SCAN_SUCCEED) {
>  		mmap_read_unlock(mm);
>  		goto out_nolock;
> @@ -1253,8 +1255,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  		 * released when it fails. So we jump out_nolock directly in
>  		 * that case.  Continuing to collapse causes inconsistency.
>  		 */
> -		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
> -						     referenced, HPAGE_PMD_ORDER);
> +		result = __collapse_huge_page_swapin(mm, vma, start_addr, pmd,
> +						     referenced, order);
>  		if (result != SCAN_SUCCEED)
>  			goto out_nolock;
>  	}
> @@ -1269,20 +1271,21 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  	 * mmap_lock.
>  	 */
>  	mmap_write_lock(mm);
> -	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> -					 HPAGE_PMD_ORDER);
> +	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
> +					 &vma, cc, order);
>  	if (result != SCAN_SUCCEED)
>  		goto out_up_write;
>  	/* check if the pmd is still valid */
>  	vma_start_write(vma);
> -	result = check_pmd_still_valid(mm, address, pmd);
> +	result = check_pmd_still_valid(mm, pmd_addr, pmd);
>  	if (result != SCAN_SUCCEED)
>  		goto out_up_write;
>  
>  	anon_vma_lock_write(vma->anon_vma);
> +	anon_vma_locked = true;
>  
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
> -				address + HPAGE_PMD_SIZE);
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, start_addr,
> +				end_addr);
>  	mmu_notifier_invalidate_range_start(&range);
>  
>  	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
> @@ -1294,26 +1297,23 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  	 * Parallel GUP-fast is fine since GUP-fast will back off when
>  	 * it detects PMD is changed.
>  	 */
> -	_pmd = pmdp_collapse_flush(vma, address, pmd);
> +	_pmd = pmdp_collapse_flush(vma, pmd_addr, pmd);
>  	spin_unlock(pmd_ptl);
>  	mmu_notifier_invalidate_range_end(&range);
>  	tlb_remove_table_sync_one();
>  
> -	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
> +	pte = pte_offset_map_lock(mm, &_pmd, start_addr, &pte_ptl);
>  	if (pte) {
> -		result = __collapse_huge_page_isolate(vma, address, pte, cc,
> -						      HPAGE_PMD_ORDER,
> -						      &compound_pagelist);
> +		result = __collapse_huge_page_isolate(vma, start_addr, pte, cc,
> +						      order, &compound_pagelist);
>  		spin_unlock(pte_ptl);
>  	} else {
>  		result = SCAN_NO_PTE_TABLE;
>  	}
>  
>  	if (unlikely(result != SCAN_SUCCEED)) {
> -		if (pte)
> -			pte_unmap(pte);
>  		spin_lock(pmd_ptl);
> -		BUG_ON(!pmd_none(*pmd));
> +		WARN_ON_ONCE(!pmd_none(*pmd));
>  		/*
>  		 * We can only use set_pmd_at when establishing
>  		 * hugepmds and never for establishing regular pmds that
> @@ -1321,21 +1321,24 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  		 */
>  		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
>  		spin_unlock(pmd_ptl);
> -		anon_vma_unlock_write(vma->anon_vma);
>  		goto out_up_write;
>  	}
>  
>  	/*
> -	 * All pages are isolated and locked so anon_vma rmap
> -	 * can't run anymore.
> +	 * For PMD collapse all pages are isolated and locked so anon_vma
> +	 * rmap can't run anymore. For mTHP collapse the PMD entry has been
> +	 * removed and not all pages are isolated and locked, so we must hold
> +	 * the lock to prevent neighboring folios from attempting to access
> +	 * this PMD until its reinstalled.
>  	 */
> -	anon_vma_unlock_write(vma->anon_vma);
> +	if (is_pmd_order(order)) {
> +		anon_vma_unlock_write(vma->anon_vma);
> +		anon_vma_locked = false;
> +	}
>  
>  	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
> -					   vma, address, pte_ptl,
> -					   HPAGE_PMD_ORDER,
> -					   &compound_pagelist);
> -	pte_unmap(pte);
> +					   vma, start_addr, pte_ptl,
> +					   order, &compound_pagelist);
>  	if (unlikely(result != SCAN_SUCCEED))
>  		goto out_up_write;
>  
> @@ -1345,18 +1348,32 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  	 * write.
>  	 */
>  	__folio_mark_uptodate(folio);
> -	pgtable = pmd_pgtable(_pmd);
> -
>  	spin_lock(pmd_ptl);
> -	BUG_ON(!pmd_none(*pmd));
> -	pgtable_trans_huge_deposit(mm, pmd, pgtable);
> -	map_anon_folio_pmd_nopf(folio, pmd, vma, address);
> +	WARN_ON_ONCE(!pmd_none(*pmd));
> +	if (is_pmd_order(order)) {
> +		pgtable = pmd_pgtable(_pmd);
> +		pgtable_trans_huge_deposit(mm, pmd, pgtable);
> +		map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
> +	} else {
> +		/*
> +		 * set_ptes is called in map_anon_folio_pte_nopf with the
> +		 * pmd_ptl lock still held; this is safe as the PMD is expected
> +		 * to be none. The pmd entry is then repopulated below.
> +		 */
> +		map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /*uffd_wp=*/ false);
> +		smp_wmb(); /* make PTEs visible before PMD. See pmd_install() */
> +		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
> +	}
>  	spin_unlock(pmd_ptl);
>  
>  	folio = NULL;
>  
>  	result = SCAN_SUCCEED;
>  out_up_write:
> +	if (anon_vma_locked)
> +		anon_vma_unlock_write(vma->anon_vma);
> +	if (pte)
> +		pte_unmap(pte);
>  	mmap_write_unlock(mm);
>  out_nolock:
>  	if (folio)
> @@ -1536,7 +1553,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		/* collapse_huge_page expects the lock to be dropped before calling */
>  		mmap_read_unlock(mm);
>  		result = collapse_huge_page(mm, start_addr, referenced,
> -					    unmapped, cc);
> +					    unmapped, cc, HPAGE_PMD_ORDER);
>  		/* collapse_huge_page will return with the mmap_lock released */
>  		*lock_dropped = true;
>  	}


