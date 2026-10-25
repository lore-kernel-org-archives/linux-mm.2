Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5622F606A31D
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 17:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Ts1cgX5X
Received: by kanga.kvack.org (Postfix)
	id F34EF6B05C0; Sun, 25 Oct 2026 13:40:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE6726B05C1; Sun, 25 Oct 2026 13:40:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD48B6B05C2; Sun, 25 Oct 2026 13:40:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9CE206B05C0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:40:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 148DE12064C
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:40:54 +0000 (UTC)
X-FDA: 85361864028.04.54C235B
Received: from mta0.migadu.com (out-210.mta0.migadu.com [91.218.175.210])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0C7E31C0005
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:40:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ts1cgX5X;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.210 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792950052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EFcn0IkG5YBPfWOvPb8EahamKp0w+ts2teBO5+lqi6Y=;
	b=3gJ5/+9/nXWfQfRpQkef0JoRIzfqUf/CLL7q5QxRC919n4gCMDzrgzAQxk94v7b9Cb4Y6Y
	t2mtz5+RzS9BhSfhpAnH2LpbfqJIaXB53uvk4r9s6nQ3TnVLpq78RYpKOgsHqup4mulhMx
	ezjbcVCQqRuzch09YnzxkGAwe+TKBiA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ts1cgX5X;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.210 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792950052;
	b=Qn/FRfT84hLOqB6vksdVHweesDzF8LHDQz9PO8g2Yxt7CcG2gC1c/F87Huv2IUPR4dj1Gf
	4o3K4BBx4gsjLHlMo1I7LLIBT17sS9PV75u/Xx249ePenoHIa/WEkVV9XD5Lj6Q6kSNzxQ
	zl9YukExEP3NnabzO8bFjrsrsFlzbG0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kRLF/HRsqERTBPSJ8Ot+uxyMxQc9Tghc4vnCRz+O19U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792950050; v=1; x=1793554850;
 b=Ts1cgX5X6ddWyNQriS86kNTRUCXh0OBNgQ3Ua0wxRXcUNcLWbb3fhAYJbvWBj3p7KsMH8XQ7
 NjSYuF8xHriVZ0CmhfvCilmB1a9ABLX1hR9GxwPeOZFFlBs1TKTPXAGG9M/h2gDQXCZMuiHlRxn
 niSEJhPBgqmqbPSwUUwGQcRc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 8008230ebac73f13;
	Sun, 25 Oct 2026 17:40:50 +0000
X-Mizu-Trace-ID: 8008230ebac73f13
X-Migadu-Flow: FLOW_OUT
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Date: Sun, 25 Oct 2026 11:39:47 -0600
Subject: [PATCH v2 2/2] mm/ksm: prevent zero-page remapping during
 ksmd-triggered THP splits
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261025-b4-ksm_fixv2-v2-2-8b61ad0491f1@linux.dev>
References: <20261025-b4-ksm_fixv2-v2-0-8b61ad0491f1@linux.dev>
In-Reply-To: <20261025-b4-ksm_fixv2-v2-0-8b61ad0491f1@linux.dev>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu Zhao <yuzhao@google.com>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usamaarif642@gmail.com>, 
 aarcange@redhat.com, "Nico Pache (Red Hat)" <nico.pache@linux.dev>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 0C7E31C0005
X-Rspam-User: 
X-Stat-Signature: teezgyrm7ata7os7irsrircbya6d1gfh
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792950051-458134
X-HE-Meta: U2FsdGVkX1+YZOQi+aTXLjD3LtZsKtPg7bX+d1RRUNOMKfYsCMGkTHEvHDBbPXJcgFtpQrj6QBNz97KWTuBWsZHAB9TpTmlgrdeK7b7HBnNURDJ7S8fvB363Gs7ryX8CfOMtA37cw1o/F2wdtDltcaVpxFMuIgCUppY2xsqLVgleXza1GpA5JSE4bK5bC4zaoCk1FzB/sR5fKP8kLbKTgtvyz2DLkGS62TkP/9WfrC2KG6oqy0C54C56aqrjdt6Kyea/PYCvSapKVejrSa8iFSfDc3MrKcsuKDiYWFmbynh3j9PgBW1jBEPGnad0gI0cNqFgLBXvlf3nQeI0nNkl+PbI7SWEDkfN3vXmaQjFGnq9X27gTmaCScRq03WKgXFOAQh92ZLc2auYgyUs0nMTtJi6ObtIPB6D4cIgkR5pFqfQh40lv4xl2vjqTDfRmocaGr4uYdm7gXOPtJL9RYg9pt8Fjf0O+QHDoOlKK4X9/7pbkNCHwHQnFOmF7SGXuaGiTIm7Tuxut4wY9C+RQeTQOjWoXXvMY4/FZX6L0rkS6kZcjIuyVBR2W2X7caFviAq9MDwlwxXrz/8HHTljOqLR0H9deH0bGnNJIKoOE51FnEc1C9W0Fmjz/1aQXAaWgC7I/tvaW4Ezsg0416+Nmg7numZLuLc9W3Cgm3h93EiVISX3oAsAGgKOWkyX1/OdRjWlyzpozLSr3wVCbHDuHBsqr1icQPx+QC1VI1aP9EmEhfRTGC7vafcoMN6bEcnEulfaF4UOXG3xMBclZM/l0cpNA9ga4bTjzMKJXBoM+M46mPoViUB6M/qM41kPD+3bkHJZhZcAJ/W00+n+6CrGshVk9pC6CSN1S5W06sUE3ldL6RxYoIIn+FecWaunJuqMzFsFyLDDyz8ykH6MaysYwedL2ArSUO6WDFHwr9G3ZZOr7VFXQbp5dKtOVz1Bw7BVzEI2u6CjLO6jexY1FZSyFoy
 vs3CObDo
 DyjXEUVYzaS+ayf8ZUJQLTWlo5gKu3gTfLKVpzt82xvzfNw4x42xRIY8fWOd8UOzdeNEl/kCDJOuy+8ww+TCe0bMIhZOzFUlEqaXP3TJVQWxa15Cq0BVMrEcDDtN6CyanklKlnJPyzd0LaOwu3ioWbbbMurJ4dWlTjMlqLBZvvb91CybzcbUmc6QT7u94fn1tq6vErdN5JFex0J8ySw23W8Ibe5+elm4XAKKSvZiCRB9HOz7NEUUQ6bQkuXyXhzRmoE39J+rmFYp2Y00xyf0aNPZJvOS7A9VGLS2A9uxEBKZ3uZ1PO+d4C4ZZvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit b1f202060afe ("mm: remap unused subpages to shared zeropage
when splitting isolated thp"), splitting an anonymous THP remaps all
zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPAGE.
This flag is set unconditionally for every anonymous folio split,
including splits triggered by KSM.

When KSM is enabled with THP=always, this causes two regressions:

1. use_zero_pages=1: KSM calls try_to_merge_one_page() which triggers
   split_huge_page(). The split remaps all 512 zero-filled subpages to
   the shared zeropage at once, freeing the entire 2MB THP when KSM only
   intended to process a single 4KB page. This bypasses KSM's
   pages_to_scan rate limiting, causing ~1GB to be freed almost
   instantly.

2. use_zero_pages=0: The same split side-effect occurs through the
   stable/unstable tree merge paths. Each pages_to_scan iteration
   triggers an expensive split_huge_page() that silently frees 2MB,
   while the scanner wastes cycles on tree searches for zero-filled
   pages that were already freed as a side-effect.

Introduce current_is_ksmd(), which uses kthread_func() to check whether
the current task is the KSM scanning thread, and use it in
try_to_map_unused_to_zeropage() to skip zero-page remapping when the
split is triggered by ksmd.

Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
---
 include/linux/ksm.h | 6 ++++++
 mm/ksm.c            | 5 +++++
 mm/migrate.c        | 3 +++
 3 files changed, 14 insertions(+)

diff --git a/include/linux/ksm.h b/include/linux/ksm.h
index d39d0d5483a2..41c06a6abf60 100644
--- a/include/linux/ksm.h
+++ b/include/linux/ksm.h
@@ -17,6 +17,7 @@
 #ifdef CONFIG_KSM
 int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 		unsigned long end, int advice, vm_flags_t *vm_flags);
+bool current_is_ksmd(void);
 vma_flags_t ksm_vma_flags(struct mm_struct *mm, const struct file *file,
 			  vma_flags_t vma_flags);
 int ksm_enable_merge_any(struct mm_struct *mm);
@@ -144,6 +145,11 @@ static inline int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 	return 0;
 }
 
+static inline bool current_is_ksmd(void)
+{
+	return false;
+}
+
 static inline struct folio *ksm_might_need_to_copy(struct folio *folio,
 			struct vm_area_struct *vma, unsigned long addr)
 {
diff --git a/mm/ksm.c b/mm/ksm.c
index 910a1307ac9f..e3ab037b1ebe 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2866,6 +2866,11 @@ static int ksm_scan_thread(void *nothing)
 	return 0;
 }
 
+bool current_is_ksmd(void)
+{
+	return kthread_func(current) == ksm_scan_thread;
+}
+
 static bool __ksm_should_add_vma(const struct file *file, vma_flags_t vma_flags)
 {
 	if (vma_flags_test(&vma_flags, VMA_MERGEABLE_BIT))
diff --git a/mm/migrate.c b/mm/migrate.c
index 7bdcdb57652f..c33ae3fa1043 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -305,6 +305,9 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 	if (PageCompound(page) || PageHWPoison(page))
 		return false;
 
+	if (current_is_ksmd())
+		return false;
+
 	VM_BUG_ON_PAGE(!PageAnon(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(pte_present(old_pte), page);

-- 
2.56.0


