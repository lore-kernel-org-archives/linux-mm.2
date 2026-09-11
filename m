Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75D72C79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:10:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 887F06B0098; Fri, 11 Sep 2026 04:10:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 831776B0099; Fri, 11 Sep 2026 04:10:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7470C6B009E; Fri, 11 Sep 2026 04:10:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5562F6B0098
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:10:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E7BC51C0457
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:10:00 +0000 (UTC)
X-FDA: 85200758160.09.1B41FD1
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf23.hostedemail.com (Postfix) with ESMTP id 03AC8140007
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:09:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789114199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/5y+FsthTJI0eWILMOQzIIY0oegy+gmTqJFTs/Ievv8=;
	b=xcTG+l2DeY9J9kzihB3MZii6pvM8/Uw1Xc4zxYDKB1GAziXDlcU465bvmi3XnQhqxQUA34
	B3kfCEdRQXIPQSO0w9tLVsBPo1fdoWY7yXpKMkuzEjE7aJ2bzFZ9JIFHvI+LF7uDePdD2h
	jvqm6UzShfCV5nckoQymiZsA37EMlI4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789114199;
	b=g0BbOVcefVjCAQaKHIPhA6HRxeZSUXTt0n/i/iIPbmeic9n8e7l1Nxetxk36qn/U8Y9n5n
	pxi+q6H8IxiAcWIl+Z8zggh2dkMedydV9rST7MW+KI74TGY1L6C5wQwMsXwtUGWPPkz8fb
	yKt5X2A+9iDy4a7P89YgaxFr4YWOWTE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4hh6f24N3gz58fdY;
	Fri, 11 Sep 2026 16:09:46 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 68B89dvq051060;
	Fri, 11 Sep 2026 16:09:39 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 11 Sep 2026 16:09:42 +0800 (CST)
X-Zmail-TransId: 2afb6aa3b746af2-9faf8
X-Mailer: Zmail v1.0
Message-ID: <20260911160942109wy2iDTGJslK6rHl8E56si@zte.com.cn>
In-Reply-To: <20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn>
References: 20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn
Date: Fri, 11 Sep 2026 16:09:42 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <liam@infradead.org>,
        <surenb@google.com>, <rppt@kernel.org>, <ziy@nvidia.com>,
        <baolin.wang@linux.alibaba.com>, <nico.pache@linux.dev>,
        <dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
        <chengming.zhou@linux.dev>, <usama.arif@linux.dev>,
        <gourry@gourry.net>, <harry@kernel.org>, <vbabka@kernel.org>,
        <peterz@infradead.org>, <borntraeger@linux.ibm.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: =?UTF-8?B?W1BBVENIIDIvNF0gbW06IG1ha2UgZm9saW9fd2Fsa19zdGFydCgpJ3MgbG9ja2luZyBhc3NlcnRzIHNjYWxhYmxl?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 68B89dvq051060
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Fri, 11 Sep 2026 16:09:46 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AA3B74A.000/4hh6f24N3gz58fdY
X-Stat-Signature: yrhmjdu3bwetuf5xwqqsi9o4x9xah67d
X-Rspam-User: 
X-Rspamd-Queue-Id: 03AC8140007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789114197-342955
X-HE-Meta: U2FsdGVkX1+feONtNZoilgMz3KVL+tcBR5SkL55FrosjsOR9IlzmlvTeoHixKRMNgkzXzYU+SJCHFbgKIxN/A33JO/YOzbmvtV/CU6HQlQoHexXxRPwscTnwPvS1DB1FIm4HbSoUJ+STZTuWyf5kKSaS3pMc47fQbO4SQOSKGlqwNVfJJlH/Y4g13mtUWo23DAzdsSw893302Mb5yfYL8+cwz3n0lLtNOO3D9y+cHPoEMOocwjTdL4QQV0E4/t47VeFNsIqL1SGJ1r/Ee1deH7gK/vgI88T1CcjwDMXlrP2rLp2xelRZHn03w92Sxik4oLkbF80/xz4YYLtDTM7RMBso0IJ4FzD9Q8g+KmCA3sp8rs6buNIDZMqDlsodUjSmNxMRwM390hKriR/j45sQM88NMcjBZfvZQR4pPfXLlIq0t7PiEBj+PDY/ho2tqtX1QqckODFLlfoGvDf7caFsJD3GhFf6KGs8BJ+fX5IQc0mdJNyIbSFvM/QW6kUDx2KxfLUumPJ0cEefT+6Ipwp2PxNMHBYn7cKlkE9oW5V8Tzl8vMaSBVjXJmuZaSwuj6pdZVdg+FjeD5pRKziT1A4IX+LhCzfgCymAJQXN6G29zlHGSp7ZHs9YA5kosQQfBQ2yTpragJqKT//VwRVvAA7zGA2uPqyPyzG6NCid/LD7OQfE12ussrp+8xmX1gRpChEhfSjYLOhTAIHmdcfQpYXKY/4C9dox2PXp8Lzpbhe5BkwIaQMzG39VNELiFpdE9NSMmy6OY4E5PcBMXh7/K1EDF0Y4KlcjhB5N1KEbVN1ll2r+i1FN6rSmGSB0mJJSlMuhuRtg9j65m/6mjSuoC8rKscN25s74nbCx3ekoSs+5L+jc2jGBSS+aGk/lzrN9Ixu3qWv5U5i7ygfeHv1tYPpw4+zb2bGsgF8e4d9jIjfg6tsWv1ly2Fq8NEmWBhSLGWm5yKLWZvb6umTCcKDOIew
 ZlZlmbTO
 bR4R2b/FzLnELQiJesn32GceS7Bf5JvwGUh768aUdHl6WAHRFBYXnIeIH6Mp+Fj+POR06T/4OartMJKXFmBI9WYUYiMlsp5cdIwYm5AP/UfLlSkzrGHwERZzx4iE5a66pUjtkh1zMwnXwP9lsSA2z3J5YovntQJNc86IyuTdXD0UB7T1StBPMHbzFtANY5cV2bYhkVP0oWoWtvF5+AeukHW16qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xu Xin (ZTE) <xu.xin@linux.dev>

Add an additional member 'walk_lock' to folio_walk to indicate
locking requirements for the walk. Similar to commit 49b0638502da0
("mm: enable page walking API to lock vmas during the walk").
But no change is made on any existing locking behavior,
all existing folio_walk_start() callers are currently still
under mmap_read_lock() protection.

This change is prepared for the latter patch to enable VMA locking
asserts. folio_walk_start now operate under write-locked mmap_lock.
With introduction of vma locks at the next patch, the vmas have to
be locked as well during such walks to prevent concurrent page
faults in these areas.

No functional change intended.

Signed-off-by: Xu Xin (ZTE) <xu.xin@linux.dev>
---
 arch/s390/mm/fault.c     |  4 +++-
 include/linux/pagewalk.h |  1 +
 kernel/events/uprobes.c  |  4 +++-
 mm/huge_memory.c         |  4 +++-
 mm/ksm.c                 |  4 +++-
 mm/migrate.c             |  8 ++++++--
 mm/pagewalk.c            | 10 +++++++++-
 mm/rmap.c                |  4 +++-
 8 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 46d828926009..968f128a5232 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -412,7 +412,9 @@ __context_unsafe(/* folio_walk_end() not instrumented */)
 	unsigned long addr = get_fault_address(regs);
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	struct folio_walk fw;
+	struct folio_walk fw = {
+		.walk_lock  = PGWALK_RDLOCK,
+	};
 	struct folio *folio;
 	int rc;

diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
index 1c397be0d092..455428eaf1fc 100644
--- a/include/linux/pagewalk.h
+++ b/include/linux/pagewalk.h
@@ -184,6 +184,7 @@ struct folio_walk {
 	};
 	/* private */
 	spinlock_t *ptl;
+	enum page_walk_lock walk_lock;
 };

 struct folio *folio_walk_start(struct folio_walk *fw,
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 7709ea882477..054fdcb52136 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -507,7 +507,9 @@ int uprobe_write(struct arch_uprobe *auprobe, struct vm_area_struct *vma,
 	int ret, ref_ctr_updated = 0;
 	unsigned int gup_flags = FOLL_FORCE;
 	struct mmu_notifier_range range;
-	struct folio_walk fw;
+	struct folio_walk fw = {
+		.walk_lock  = PGWALK_RDLOCK,
+	};
 	struct folio *folio;
 	struct page *page;

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index dd66c6ad5af1..b714677e2f20 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4795,7 +4795,9 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
 	 */
 	for (addr = vaddr_start; addr < vaddr_end; addr += PAGE_SIZE) {
 		struct vm_area_struct *vma = vma_lookup(mm, addr);
-		struct folio_walk fw;
+		struct folio_walk fw = {
+			.walk_lock  = PGWALK_RDLOCK,
+		};
 		struct folio *folio;
 		struct address_space *mapping;
 		unsigned int target_order = new_order;
diff --git a/mm/ksm.c b/mm/ksm.c
index 624f37975e12..8df66b4e5de0 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -817,8 +817,10 @@ static struct page *get_mergeable_page(struct ksm_rmap_item *rmap_item)
 	unsigned long addr = rmap_item->address;
 	struct vm_area_struct *vma;
 	struct page *page = NULL;
-	struct folio_walk fw;
 	struct folio *folio;
+	struct folio_walk fw = {
+		.walk_lock  = PGWALK_RDLOCK,
+	};

 	mmap_read_lock(mm);
 	vma = find_mergeable_vma(mm, addr);
diff --git a/mm/migrate.c b/mm/migrate.c
index 15b45832bcfa..fa638adfb0de 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2302,7 +2302,9 @@ static int add_folio_for_migration(struct mm_struct *mm, const void __user *p,
 		int node, struct list_head *pagelist, bool migrate_all)
 {
 	struct vm_area_struct *vma;
-	struct folio_walk fw;
+	struct folio_walk fw = {
+		.walk_lock  = PGWALK_RDLOCK,
+	};
 	struct folio *folio;
 	unsigned long addr;
 	int err = -EFAULT;
@@ -2464,7 +2466,9 @@ static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
 	for (i = 0; i < nr_pages; i++) {
 		unsigned long addr = (unsigned long)(*pages);
 		struct vm_area_struct *vma;
-		struct folio_walk fw;
+		struct folio_walk fw = {
+			.walk_lock  = PGWALK_RDLOCK,
+		};
 		struct folio *folio;
 		int err = -EFAULT;

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 7411702a37f5..8eb29fba20ad 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -910,7 +910,15 @@ struct folio *folio_walk_start(struct folio_walk *fw,
 	pgd_t *pgdp;
 	p4d_t *p4dp;

-	mmap_assert_locked(vma->vm_mm);
+	/*
+	 * Other locking modes except for mmap or vma read locking are not
+	 * expected.
+	 */
+	if (fw->walk_lock != PGWALK_RDLOCK && fw->walk_lock != PGWALK_VMA_RDLOCK_VERIFY)
+		WARN_ONCE(1, "walk_lock is not expected!\n");
+	process_mm_walk_lock(vma->vm_mm, fw->walk_lock);
+	process_vma_walk_lock(vma, fw->walk_lock);
+
 	vma_pgtable_walk_begin(vma);

 	if (WARN_ON_ONCE(addr < vma->vm_start || addr >= vma->vm_end))
diff --git a/mm/rmap.c b/mm/rmap.c
index 5fefe5b060b1..fd8e1c9e4424 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2871,7 +2871,9 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
 	struct mmu_notifier_range range;
 	struct folio *folio, *fw_folio;
 	struct vm_area_struct *vma;
-	struct folio_walk fw;
+	struct folio_walk fw = {
+		.walk_lock  = PGWALK_RDLOCK,
+	};
 	struct page *page;
 	swp_entry_t entry;
 	pte_t swp_pte;
-- 
2.25.1

