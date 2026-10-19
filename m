Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 910EFCCF2D3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 11:32:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B64366B01AA; Mon, 19 Oct 2026 07:32:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AED436B01AE; Mon, 19 Oct 2026 07:32:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DF516B01B1; Mon, 19 Oct 2026 07:32:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A6BD6B01AA
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:32:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0896B1A06E6
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:32:00 +0000 (UTC)
X-FDA: 85339161600.21.FA105C9
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf29.hostedemail.com (Postfix) with ESMTP id E3A64120004
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:31:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=C1hHcavP;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792409518;
	b=dhGD3kbW+8aJ6d86e7eROEKXWLt9QCErmdWZYT88AvsLI0mgWa2SzYdId6Ub3KQJaq59am
	M7eMExc82bkrDyzxuXYv8YNkWMJYbfA2pwaTtYD8HMedh0824xQPTMqCn1HcDVDwFtoJW/
	pUg84xZyVHi157mSNRW+NjQlrcBz6mc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=C1hHcavP;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792409518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2rGbpA7JEM1Wj9hm1mqEIsnxU9V+I7EK/CIn3DY2zZg=;
	b=Lazw3WmwY4LPRdkY8WzEI8zhbsP4DHmORmkN9A3bzD07Sj+NygQYQpiovvXpxM5lc7H5f/
	vyGdZmwU+R6EL2Et0lg+SSM1StMJQXzc2Pn58sfOJtcT2GcJXgGqVO0Fx3z0AOYk5HUX2w
	/Tw4JFv7Rdn68nKgg4UocKe/VUzxZ4w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792409513; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=2rGbpA7JEM1Wj9hm1mqEIsnxU9V+I7EK/CIn3DY2zZg=;
 b=C1hHcavPwUAex1kHMXHzQlgY6eKvMRA/RAVpJFiVxw8JGu1qdPpBWoRgFMY9ZkgXGA+KVb
 4Qa8Faz1sehTSbVlOhxWK0fGHOyaml27iGcWGesAiR3CRTDjaSy7q1vI0yOMAlUjF3fbTf
 JkkuNytRmqz4ZUIQ3qWKp/t0z3mme4zHSt1+J0O79dAaIdxFkvpTykaJWHKhtclVM0X5fe
 He56bXVf7J6c+pdGQO752sS7gsVoOmOWvIAwLtEVz2RJXYxItm+4rDeY1CQQVWbk95zpyn
 +EUiAPaWuw2p5AvYk3mkUSyFjvxAowx4kpFJdOIUT5SyZ681V4CA0dkUm4LVkA==
X-Mailer: git-send-email 2.45.2
X-Lms-Return-Path: <lba+26ad5ffa7+36c5d4+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 19 Oct 2026 19:30:34 +0800
Message-Id: <20261019113034.97690-4-lizhe.67@bytedance.com>
Mime-Version: 1.0
In-Reply-To: <20261019113034.97690-1-lizhe.67@bytedance.com>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <rppt@kernel.org>, <peterx@redhat.com>
Subject: [PATCH V2 3/3] mm/hugetlb: fix mremap deadlock when PMD sharing is possible
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>, <stable@vger.kernel.org>
References: <20261019113034.97690-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E3A64120004
X-Stat-Signature: t9nnwrn4ywwuihrwoo4kcu1tfkcq7gz9
X-Rspam-User: 
X-HE-Tag: 1792409517-605566
X-HE-Meta: U2FsdGVkX1+zuQ82DynQpMlFNC34HsBlbesH5tyUPEONbELZE6epqWVvtVh5OBCrfGey8AP1ke9gnHe+srU66JtnQQQM8rS2Q44DqEEOxmKUb7W9DHXIr7a9LLCDiiUxky0DnOgwG/3M1uXyFSpPJJWjTfbztC7rToRM0rmWSs0GAfEDzD3L6a6DAoVkY/EuLelOcFgvKYaGzsuRdAlKgvSOt/2KsuoEh7of/QXYaiTjLuZmVA02Lz07QizIJ/JGxYmm9ddCBpDIqI0S5hBZRMa9KG2+/V/A2oBfWEFpz5vjtJuc8aMXtytQremmBlazOcKLyNXAxaNhGLoqEl4gWE0mwdK+acM4dq1eoGa2T/SPvkmSwV+g++Ukymaoyhec3UnglHv1/V6v48PkAYl3hWoKP331wAqmvfZZG34jfisZkPWdIKTmOfpH9IoVU19Za7Dp1VqsP6YZ6RbE3icimGEKlEsh/N4kUvsdORGJd9s6S8kBepTK5372lw32dCd+FmEv1hhVr1038VFDgJL/SBcqVCa/8qjF0se9Hup1bEqNfzOIAcHAUq9xH088VTqkQQxHIaGwRxqEcblQ/MBIF78VnDNkL4Yh/+wl+TE/g3aCOq0RoCjKukkHhGpB72UGdTSHK7r3RongoVQBwKogA9IFnirjjKxoDjdIMWgNlv46EEYnALVYegdJqyc3EMj2eDDr9uh/I6iPbTIE20wGt3F95HqedbecQ/ZhBRQMjhz902eLd81eU31kZmpuVWw3Iya3pKLQkDF1rInVDsSvthPrBDVnaX5ZmwlJqMQIgO05BJwouDg/Vf8EKS3fc1R2X81c9YlDe7wjIJa89PD9GI+tPcBBUXSF+IZe48wcz5w7rfGr71NVf7eJTW7OrH3odrkSNUkshDMeI/s7r10Na1iy68q0utROiD72cutfiAZBFJrE+4/ZbhdrgVKwj8IzjsNQhf6dbIWECO/yPIN
 7vCFboHN
 8nZ1RjZKG4XgxHS/YKeL5/HiUVdM746auEG+OTVaocfLikU8fgMsKH8TXCaCJmDbPwSXtl063HFl4CjA2BBHGPdsVXDJNKpKqehagRXpjat8MvHgJG7iUe9cSYiYVvA72ScHS//8MKV6JWcKpOvj1ZOQ1sXqdSjLeZhhFR4+4p2N1EUxrA5InnmTTdE6tzxBvVsGKfvo/JNlEUfUz0cnymXXlJ9dxV6lRssQxtdM/y+MUxMsUUaG5nxcet9RoOc/msrzrl10orE3ubzvNvZtYIM5OSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

move_hugetlb_page_tables() holds the mapping's i_mmap_rwsem for
write while moving hugetlb PTEs. This prevents races with truncation
and protects huge_pmd_unshare(), but the move loop must not call
helpers that can acquire the same rwsem for read.

huge_pte_alloc() can do that when the destination can use PMD
sharing: it may call huge_pmd_share(), which takes i_mmap_rwsem for
read while searching for a shareable PMD table. Calling it while the
move path already holds i_mmap_rwsem for write can deadlock.

Avoid that path for PMD-sized hugetlb mappings that can use PMD
sharing. Instead of allocating or sharing the destination page table
while moving, zap the source range and let the destination fault path
populate or share the PMD lazily.

Reuse the hugetlb unmap logic for the source-side zap by splitting
the core loop out of __unmap_hugepage_range(). The wrapper keeps the
existing tlb_start_vma(), tlb_end_vma() and huge_pmd_unshare_flush()
behavior, while move_hugetlb_page_tables() can reuse the unmap loop
with its existing mmu_gather.

Fixes: 550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage backed vma")
Cc: stable@vger.kernel.org
Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/hugetlb.c | 47 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index fdd65e019a55..46a2a9b9222b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -124,6 +124,10 @@ static int __huge_pmd_unshare(struct mmu_gather *tlb,
 		bool check_locks);
 static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, bool take_locks);
+static void hugetlb_unmap_range(struct mmu_gather *tlb,
+				struct vm_area_struct *vma, unsigned long start,
+				unsigned long end, struct folio *folio,
+				zap_flags_t zap_flags);
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
 
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
@@ -5172,6 +5176,8 @@ unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
 	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
 		const unsigned long offset_to_last_entry =
 			(old_addr | last_addr_mask) - old_addr;
+		const unsigned long offset_to_last_dst_entry =
+			(new_addr | last_addr_mask) - new_addr;
 
 		src_pte = hugetlb_walk(vma, old_addr, sz);
 		if (!src_pte) {
@@ -5188,6 +5194,24 @@ unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
 			continue;
 		}
 
+		/*
+		 * Avoid entering the destination PMD sharing path while holding
+		 * i_mmap_rwsem for write. Leave destination page table
+		 * population to the fault path, which can share the PMD lazily.
+		 */
+		if (sz == PMD_SIZE && want_pmd_share(new_vma, new_addr)) {
+			const unsigned long unmap_size =
+				min(old_end - old_addr,
+				    offset_to_last_dst_entry + sz);
+
+			hugetlb_unmap_range(&tlb, vma, old_addr,
+					    old_addr + unmap_size, NULL,
+					    ZAP_FLAG_DROP_MARKER);
+			old_addr += unmap_size - sz;
+			new_addr += unmap_size - sz;
+			continue;
+		}
+
 		dst_pte = huge_pte_alloc(mm, new_vma, new_addr, sz);
 		if (!dst_pte)
 			break;
@@ -5207,9 +5231,10 @@ unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
 	return len + old_addr - old_end;
 }
 
-void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
-			    unsigned long start, unsigned long end,
-			    struct folio *folio, zap_flags_t zap_flags)
+static void hugetlb_unmap_range(struct mmu_gather *tlb,
+				struct vm_area_struct *vma, unsigned long start,
+				unsigned long end, struct folio *folio,
+				zap_flags_t zap_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	const bool folio_provided = !!folio;
@@ -5227,13 +5252,6 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	BUG_ON(start & ~huge_page_mask(h));
 	BUG_ON(end & ~huge_page_mask(h));
 
-	/*
-	 * This is a hugetlb vma, all the pte entries should point
-	 * to huge page.
-	 */
-	tlb_change_page_size(tlb, sz);
-	tlb_start_vma(tlb, vma);
-
 	last_addr_mask = hugetlb_mask_last_page(h);
 	address = start;
 	for (; address < end; address += sz) {
@@ -5362,6 +5380,15 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		if (folio_provided)
 			break;
 	}
+}
+
+void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
+			    unsigned long start, unsigned long end,
+			    struct folio *folio, zap_flags_t zap_flags)
+{
+	tlb_change_page_size(tlb, huge_page_size(hstate_vma(vma)));
+	tlb_start_vma(tlb, vma);
+	hugetlb_unmap_range(tlb, vma, start, end, folio, zap_flags);
 	tlb_end_vma(tlb, vma);
 
 	huge_pmd_unshare_flush(tlb, vma);
-- 
2.20.1

