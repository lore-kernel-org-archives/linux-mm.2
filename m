Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B162AC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 14:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 544936B00A2; Wed,  6 Aug 2025 10:56:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51C3C6B00A3; Wed,  6 Aug 2025 10:56:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 459216B00A4; Wed,  6 Aug 2025 10:56:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 33FDE6B00A2
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:56:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 01CC81A0529
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:56:47 +0000 (UTC)
X-FDA: 83746634496.15.D487389
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 01FBEA000B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:56:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754492206; a=rsa-sha256;
	cv=none;
	b=QuIIjLqIvn0CdG483TLFddFGmF8cv4xFFbHWQ+ugiteNoHJAMLJR9MPVMI8djQoZy05QgT
	BR9IuwwfMskcYzM0UzDS/wIvEMfamv1SpXSEywCw+8DnQsyJ/MgOg8dHMH6RFP7OCFwuhl
	0RmUL1i74ou46Pq5S3RiDIOPULDCyQQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754492206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=8S7VbRDRKJO4kP2n5QemvpxnIXDGJbZUoyPIRuHALsk=;
	b=d844+pC0tEC2GotMviI1yXEwgQzDZGLWvuZ50P2cVSc8Z3Eg6QIiPDwM07Kn/KCKN21Wvz
	R4VCNC821cNbaNz7zefjzfV+DekFzaUXDtriHZHkoTCtPLzRdPdoAJfTyizCWcwUOWEmBQ
	r8HClkJ3bRtCCEuhPZuNYos/F/bUykA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BBC72176C;
	Wed,  6 Aug 2025 07:56:36 -0700 (PDT)
Received: from localhost.localdomain (unknown [10.163.64.125])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 532773F5A1;
	Wed,  6 Aug 2025 07:56:34 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org
Cc: ryan.roberts@arm.com,
	david@redhat.com,
	willy@infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	vbabka@suse.cz,
	jannh@google.com,
	anshuman.khandual@arm.com,
	peterx@redhat.com,
	joey.gouly@arm.com,
	ioworker0@gmail.com,
	baohua@kernel.org,
	kevin.brodsky@arm.com,
	quic_zhenhuah@quicinc.com,
	christophe.leroy@csgroup.eu,
	yangyicong@hisilicon.com,
	linux-arm-kernel@lists.infradead.org,
	hughd@google.com,
	yang@os.amperecomputing.com,
	ziy@nvidia.com,
	Dev Jain <dev.jain@arm.com>,
	syzbot+57bcc752f0df8bb1365c@syzkaller.appspotmail.com
Subject: [PATCH mm-hotfixes-unstable] mm: Pass page directly instead of using folio_page
Date: Wed,  6 Aug 2025 20:26:11 +0530
Message-Id: <20250806145611.3962-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 01FBEA000B
X-Stat-Signature: 5pmewdwzjr1zg8rewai8y8fpsjun365z
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754492205-781310
X-HE-Meta: U2FsdGVkX18Mb5AY8vtywA3SqfKrnfG1HVemihizqrZv+d9VJt7sV6UzubSMnQsb1OKMIPgWMK+u7JrUj3+F9AvRx0Af0mbYcDQCwQnYo9S0sDY9OO7iGDIiFwUaB03CFHHn8Lp9TtBuz53NnCIMt8/5haod+I+QjfXrr91UrxdytGoZNaNhAz5pYF4M5F4o1MB1Q6NuQ85FtUEB6rMd7GvBUwFB9AvydxzA7wr1Y+oJTsMTtWM8+zmHsfS7MkFDHrLz8rpk+v/YTVt5Qwy6zusBXSpnvtP6/hN5iuis9zE61jKmMC0ZER1tFb8j7UOix/ipQGK69b16PwvWA7y3to4It8LoGsHzL+kLba/7lORnJN90vdID7A1cpaCtkKe+y4LMMIUnmBRQYf4mu/j7qfPw2md4QKJB8FvnwYU0SVHT+izUJtD/icd0cGWkH9yRTZ5XaCLYmRxSLKxUbDGpjITWky8YTNIMzKEPYmmyURTsW0YWMUUtv4t4fBNP/p5Qb/2XHrnSJjJovlO7hVYHn43u0l9m5fubE0sjskmW/ipJNNBrF+/SzW6el7XvHQy73B59aTqoJwpt1sMwyoykrcwdiZzBbRG5za5vEp2VS0LGh7iNaofjFCZOJFvV+9U1AwvEzHHpT3NFzvbYMhdVTtujjjPR7Gme2gWh4HSizuNkx1RsInODM6oQLyx5MzWst/GQoJqfME65pPPb6n/rVaGMjvFX44wlDbS3d+uG/+/+Jn9JX8W/mtAQkp7l5mPHl6BkWVVedV+kBkU16KQlrG09FYWgm8IimwfzQ3K1kmm/7IXbpYu96ZeQ5RNJo+WL/VGwYzPds5IGTg8XZmGu0ZMRtAu2SjWZHiSsDe4V1Ih0oTgyF2eaxnAIteTH6L+WFGPGlVyGSOeZJeirTs9Kg+tjeax3r+Gww25mLBG9zmRWrkn7PcDHZ4+SmlGoevUsdbFcdOfyckYRGq+PwDu
 nj1NNHDR
 EnO3HvCC5ie5+Y1vMlH8zSI3MjOZV+UtlwZnVzS8PZoDOaFxtHQ5bpI97TYbwUv++YGtqQAQ+aaQzrk6mkSsjlbWPf0ZJ9kz65ruy4S+UI2eeg9arKQj+5TKnbWExneHRwVms8+viP0rIQWVGNtJZDBmnqArpiTWbnMRv0M2FglZVdjbeak1oQ3QufV6DR2WBk+xhvaMjVtv5lmqF8D+/n0RD/YxhlSOHWpexcSUwoRqOYOw/I+zp3eIT67XNsRaSwz6MWmi8esjE1Pr0YFJjEjlVKi3cwsFhNvbx8OhQ7CahT/O+He9P5NZPr9ENg4XqfQkLSKG7Q2mWcCv+onMTADBOjqTFYr/sMxTFHUVUxxe7F4c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In commit_anon_folio_batch(), we iterate over all pages pointed to by the
PTE batch. Therefore we need to know the first page of the batch;
currently we derive that via folio_page(folio, 0), but, that takes us
to the first (head) page of the folio instead - our PTE batch may lie
in the middle of the folio, leading to incorrectness.

Bite the bullet and throw away the micro-optimization of reusing the
folio in favour of code simplicity. Derive the page and the folio in
change_pte_range, and pass the page too to commit_anon_folio_batch to
fix the aforementioned issue.

Reported-by: syzbot+57bcc752f0df8bb1365c@syzkaller.appspotmail.com
Fixes: cac1db8c3aad ("mm: optimize mprotect() by PTE batching")
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/mprotect.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 78bded7acf79..113b48985834 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -120,9 +120,8 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
 
 static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
 			   pte_t oldpte, pte_t *pte, int target_node,
-			   struct folio **foliop)
+			   struct folio *folio)
 {
-	struct folio *folio = NULL;
 	bool ret = true;
 	bool toptier;
 	int nid;
@@ -131,7 +130,6 @@ static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
 	if (pte_protnone(oldpte))
 		goto skip;
 
-	folio = vm_normal_folio(vma, addr, oldpte);
 	if (!folio)
 		goto skip;
 
@@ -173,7 +171,6 @@ static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
 		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
 
 skip:
-	*foliop = folio;
 	return ret;
 }
 
@@ -231,10 +228,9 @@ static int page_anon_exclusive_sub_batch(int start_idx, int max_len,
  * retrieve sub-batches.
  */
 static void commit_anon_folio_batch(struct vm_area_struct *vma,
-		struct folio *folio, unsigned long addr, pte_t *ptep,
+		struct folio *folio, struct page *first_page, unsigned long addr, pte_t *ptep,
 		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
 {
-	struct page *first_page = folio_page(folio, 0);
 	bool expected_anon_exclusive;
 	int sub_batch_idx = 0;
 	int len;
@@ -251,7 +247,7 @@ static void commit_anon_folio_batch(struct vm_area_struct *vma,
 }
 
 static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
-		struct folio *folio, unsigned long addr, pte_t *ptep,
+		struct folio *folio, struct page *page, unsigned long addr, pte_t *ptep,
 		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
 {
 	bool set_write;
@@ -270,7 +266,7 @@ static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
 				       /* idx = */ 0, set_write, tlb);
 		return;
 	}
-	commit_anon_folio_batch(vma, folio, addr, ptep, oldpte, ptent, nr_ptes, tlb);
+	commit_anon_folio_batch(vma, folio, page, addr, ptep, oldpte, ptent, nr_ptes, tlb);
 }
 
 static long change_pte_range(struct mmu_gather *tlb,
@@ -305,15 +301,19 @@ static long change_pte_range(struct mmu_gather *tlb,
 			const fpb_t flags = FPB_RESPECT_SOFT_DIRTY | FPB_RESPECT_WRITE;
 			int max_nr_ptes = (end - addr) >> PAGE_SHIFT;
 			struct folio *folio = NULL;
+			struct page *page;
 			pte_t ptent;
 
+			page = vm_normal_page(vma, addr, oldpte);
+			if (page)
+				folio = page_folio(page);
 			/*
 			 * Avoid trapping faults against the zero or KSM
 			 * pages. See similar comment in change_huge_pmd.
 			 */
 			if (prot_numa) {
 				int ret = prot_numa_skip(vma, addr, oldpte, pte,
-							 target_node, &folio);
+							 target_node, folio);
 				if (ret) {
 
 					/* determine batch to skip */
@@ -323,9 +323,6 @@ static long change_pte_range(struct mmu_gather *tlb,
 				}
 			}
 
-			if (!folio)
-				folio = vm_normal_folio(vma, addr, oldpte);
-
 			nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_ptes, flags);
 
 			oldpte = modify_prot_start_ptes(vma, addr, pte, nr_ptes);
@@ -351,7 +348,7 @@ static long change_pte_range(struct mmu_gather *tlb,
 			 */
 			if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) &&
 			     !pte_write(ptent))
-				set_write_prot_commit_flush_ptes(vma, folio,
+				set_write_prot_commit_flush_ptes(vma, folio, page,
 				addr, pte, oldpte, ptent, nr_ptes, tlb);
 			else
 				prot_commit_flush_ptes(vma, addr, pte, oldpte, ptent,
-- 
2.30.2


