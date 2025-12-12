Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16C61D43363
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 07:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FE766B0008; Fri, 12 Dec 2025 02:10:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D5966B000A; Fri, 12 Dec 2025 02:10:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 712F86B000C; Fri, 12 Dec 2025 02:10:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6303C6B0008
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 02:10:37 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2ACDDB97A3
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 07:10:37 +0000 (UTC)
X-FDA: 84209946114.27.0770614
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 87FE98000A
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 07:10:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=se6W7wJX;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765523435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cUXWAP7dEfEEUrj5xqoHj+9QFfwOyQVqbIR6i/GInO0=;
	b=qiwLwb19n05yQRard8gCHnpwxLU1eBcj18hGUkxLO1gkZoiU0ZvmE1CnPQqkF8JOXSSGqx
	VIeCdA0TvptoWoEolEbt3dyG0CA++u7mwt8dKNTtSSqGnm54WiYyTR6ADvc3Oun84QE5vr
	/77Wo5llfTVAxhf2m8MQdb9vI5A7VAI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=se6W7wJX;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765523435; a=rsa-sha256;
	cv=none;
	b=BhCb+5N3bn1eqX3hcOFQnvSDSHGnVWRwuJdrV12RTgVMNVXhXugCCyP+h6L3n/kxE5Yo48
	cVVnS3KYalMh70fXBopdK/YjkSKV/M8KdfGBtKZ0q/U/LSiuvyLITLc0oc71S4W1UyyYTd
	6PFZidUvW3qH1vCMqLZS/rpSq3utOVg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A3B07600C3;
	Fri, 12 Dec 2025 07:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A91C4CEF1;
	Fri, 12 Dec 2025 07:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765523434;
	bh=0RZwH8fvxgrQifnKyq2TorkfWiaSbHYH9Z5fLbKuKTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=se6W7wJXAJn000CvW1Idyi+iVZ21IWzMA00M/0FwGvJNR+0B4xpu/0uLD82YIKc/6
	 2oLF+AWZHXRxaKht06GtmcT/ZqXx6GXGVIUIrNxDLRRO7dPpHNYYSFCyVYXebWX7zu
	 Hs/zwXMCnXdX6380gB6s9LR4sb0q+gLv1qrM29qgosDeLfrtcm0quCXRrLyVXdz7jT
	 2HrEESmd2VgETIrI5XyxrdiHctqZaEOg/1W7Tk0Mnb9fUiVCyy72oNq6wXOzdEHC6f
	 9vjPe2ANh8uZSCFvTrSHTRFnILOC3Aa1LGEtmXtWJGfnUsd0k4wGq4FzmzmwoZKJ00
	 1iDRh4pGqB2eg==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Laurence Oberman <loberman@redhat.com>,
	Prakash Sangappa <prakash.sangappa@oracle.com>,
	Nadav Amit <nadav.amit@gmail.com>,
	Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH v2 2/4] mm/hugetlb: fix two comments related to huge_pmd_unshare()
Date: Fri, 12 Dec 2025 08:10:17 +0100
Message-ID: <20251212071019.471146-3-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251212071019.471146-1-david@kernel.org>
References: <20251212071019.471146-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: wb9948bz8mb11qdj5yq9seak3eps5pat
X-Rspam-User: 
X-Rspamd-Queue-Id: 87FE98000A
X-HE-Tag: 1765523435-37845
X-HE-Meta: U2FsdGVkX19qloO+WuMRlK4afOmC5fJnxkqUOhCMXAQ4npLf4AzLSgMT0k7nj3b2Hambi6NbTLafShddd7BnnKtYcMPBsqfcC/iqhmVBQaf5zeMjNiPOnrllqRsiXKhveLetRxC0oZtFKJ8Ktyy/bn/VCULF9e1Zc8r/J8Y/3vV0Lh5pTLppY7yq4RYChSqpqqvfZJB5bQVmYS+K/EIXGfVSMEHLvkXtzcx9WLXiSVEB0XLPrlRgVo+SsYFsyi3TMgNPUrhVy9LTGQ0jutf/3bY/OHw8ou/MhpW6kVhDTugXnx7jZ0EQru85Co9J40qnQ3XGOQelAz/97QexCBKNiDg5AX/kLMYa8jeMhiByKg09f8K8W1T59xyeA8FY+jLzUK8cdD2jKPWh/uNjc/roHhZO/t7Fk7+f8k5tGThN5SKgLZBSVj/r3UFILa2YDP9J1Va632fPIpQFvcfACCH3sSa41S70OBdpkfym1Bm/Xd7XgQ/fXjfZksCuxVpvsh87Oeol1bZhAFfpIPCfH17gozzacpVL8PUwO77We6rSFAcNWrJk08ZbysSr0t1fVfelM8XpIdzkUw9lZUdG5iIUKBixA5l+Qn3LYo3NFDILm6da+LZIBBKCaEHKmITBJTMWfJBul89d3xxj0J4zEtsuuvtRFO5F3nENFIvr6uRatPiTt6uVgRdOYMV8RKzHIW/vCE33dnQNdlF0KzPr0/4KxPjSIX1nytAw7gHVX7WwdKYFP6jkK3gClcPn41AS4oYz/+MYTfn2AFmsZ5DOQ1HMGKR9zxV51bqNJI2K6G43PtjmRwC2fepPWx/8tkgPHAI5jfNcfMBrs47SWJ19SQeOwYphQxYOe8t80KM/oSSg5PU8JzaHCrJr+7ODOmnSLWmTX8umcpmMG0wYoxH10T9O4Qmhsbq3IssGfoRP7YZCe+xaWeS/wQrMf2OlGrPUEOz0xbqM+TjAdOXQk1Yvmhv
 iRHtVZ6d
 gl6g7PnAIWtJIre6yaaM++FNC/CUy/0cLls2mK98YcIRB4HZx8zrO2lOafgE39gBPQRk4WUl5xVfsgFl9tZ56Qo8+zLp54AM+GKwERLVVYcRo2mfGucD2FHzKxD35G/lbL+C8c9yJ/Q8k9N4j+jbeGRly+QC3fPlQ7+AFmBdwu+HBthaQU41NCxLdRswJfVElmeCWSsPSMemUjboi0im1BUCAJsRZZ+K27kIVvFYhKwMs/kfhQBfGxDkhv4DBiM26vSzXetVfeCbHC5bSAKZtomkc5hWBOZMCCfKgWZz0BJLWCzlPWjAkJZq1y0Ldt1+DYHtcLeh7h5SQSTJaWE/zlXzYJOqq1fdjWy+4NGix28NwPYspxzokW0HLAxTtSxmCdNiNCPZMpFkIYs90pP/Z0hn9lJZHbi9Lw2L5G2peL10wnFEEDc9gGpTmN1L3OUB2J7b1v9t5UI03tMF/iIQmgMqf3GLpquTGWX3f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ever since we stopped using the page count to detect shared PMD
page tables, these comments are outdated.

The only reason we have to flush the TLB early is because once we drop
the i_mmap_rwsem, the previously shared page table could get freed (to
then get reallocated and used for other purpose). So we really have to
flush the TLB before that could happen.

So let's simplify the comments a bit.

The "If we unshared PMDs, the TLB flush was not recorded in mmu_gather."
part introduced as in commit a4a118f2eead ("hugetlbfs: flush TLBs
correctly after huge_pmd_unshare") was confusing: sure it is recorded
in the mmu_gather, otherwise tlb_flush_mmu_tlbonly() wouldn't do
anything. So let's drop that comment while at it as well.

We'll centralize these comments in a single helper as we rework the code
next.

Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Reviewed-by: Rik van Riel <riel@surriel.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 mm/hugetlb.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 51273baec9e5d..3c77cdef12a32 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5304,17 +5304,10 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	tlb_end_vma(tlb, vma);
 
 	/*
-	 * If we unshared PMDs, the TLB flush was not recorded in mmu_gather. We
-	 * could defer the flush until now, since by holding i_mmap_rwsem we
-	 * guaranteed that the last reference would not be dropped. But we must
-	 * do the flushing before we return, as otherwise i_mmap_rwsem will be
-	 * dropped and the last reference to the shared PMDs page might be
-	 * dropped as well.
-	 *
-	 * In theory we could defer the freeing of the PMD pages as well, but
-	 * huge_pmd_unshare() relies on the exact page_count for the PMD page to
-	 * detect sharing, so we cannot defer the release of the page either.
-	 * Instead, do flush now.
+	 * There is nothing protecting a previously-shared page table that we
+	 * unshared through huge_pmd_unshare() from getting freed after we
+	 * release i_mmap_rwsem, so flush the TLB now. If huge_pmd_unshare()
+	 * succeeded, flush the range corresponding to the pud.
 	 */
 	if (force_flush)
 		tlb_flush_mmu_tlbonly(tlb);
@@ -6536,11 +6529,10 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 		cond_resched();
 	}
 	/*
-	 * Must flush TLB before releasing i_mmap_rwsem: x86's huge_pmd_unshare
-	 * may have cleared our pud entry and done put_page on the page table:
-	 * once we release i_mmap_rwsem, another task can do the final put_page
-	 * and that page table be reused and filled with junk.  If we actually
-	 * did unshare a page of pmds, flush the range corresponding to the pud.
+	 * There is nothing protecting a previously-shared page table that we
+	 * unshared through huge_pmd_unshare() from getting freed after we
+	 * release i_mmap_rwsem, so flush the TLB now. If huge_pmd_unshare()
+	 * succeeded, flush the range corresponding to the pud.
 	 */
 	if (shared_pmd)
 		flush_hugetlb_tlb_range(vma, range.start, range.end);
-- 
2.52.0


