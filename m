Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23B60CDB47C
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 01:51:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80A8B6B009E; Wed, 24 Jun 2026 21:51:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76B876B009D; Wed, 24 Jun 2026 21:51:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60C306B0096; Wed, 24 Jun 2026 21:51:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 172B86B0096
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:51:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6D6D812051E
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:51:21 +0000 (UTC)
X-FDA: 84916757562.04.E235BD6
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf11.hostedemail.com (Postfix) with ESMTP id DD2E740006
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:51:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=IX33nwhF;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782352279;
	b=3g/xB+JM/8u77tOs/FQPwwA8OXzqBkpYwcmXc8pYSZfx8+jBtoEk1IplpdpeHJh1YDXtcp
	FfPjnHQLLNO+xYZTxJYI6VD3YXhorWVMgNx6Nj9z99sTAyoGvYpoMYvvhU5qIefm7HT+6l
	XFmleCQ/XPmACdDtIQMe+xAgLBAdffI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782352279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xmq18u+aZ3R3zjSmFpi6jjGs08uIHYwgJWkswlXPCNo=;
	b=8qs62SnGvbzySqQiWfdU9boZ+OU7Gf+yT7ONHYT6f+QY6MQIf7el7l6DhLLbTKiK4P+VaT
	DQweDOcrj0+5bCkuKqcFjwkhQA822maHlrId5CqkXWCWCRmJCkwiTGIBbZvqseGXp9gZFS
	Kp5RX1bSok3tOy1CQVebhHMDuJWk7PU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=IX33nwhF;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xmq18u+aZ3R3zjSmFpi6jjGs08uIHYwgJWkswlXPCNo=; b=IX33nwhFWy4iz09trcl5hDMnfl
	/8BN8QKka2zqaH0dUWN5YKRmgbLBVdI6BuVNY6gdkluftzW9NZVmQKivNDDHM6mNU5C7Is8aKBQrv
	KBgmC5lLxAPk8dvekfjDWRTF2gQcFzRgstjxpM5tuz0vbaZTpc2GdiYRNeKeG3cFxxFWK1MiTTzEA
	2VzGMn5fIMMAmi+mGFb1jNgT0Y7KCLd1r7PcaxEx/X/SLTwMG9msxIgGbo745gRa44YWii/JJr0Fu
	IRZOd34fYRk6ynHbCJuUWnqJUR52CYvPbVlwOahlN4OiL3QjQgp+u/2mzBLaPZJYJIowULK9hqjFU
	TtNc6AQw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wcZF7-0000000043x-42H9;
	Wed, 24 Jun 2026 21:51:01 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Rik van Riel <riel@surriel.com>,
	x86@kernel.org,
	linux-mm@kvack.org,
	"Thomas Gleixner" <tglx@kernel.org>,
	"Ingo Molnar" <mingo@redhat.com>,
	"Dmitry Ilvokhin" <d@ilvokhin.com>,
	"Borislav Petkov" <bp@alien8.de>,
	"Dave Hansen" <dave.hansen@linux.intel.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"David Hildenbrand" <david@kernel.org>,
	"Lorenzo Stoakes" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka" <vbabka@kernel.org>,
	"Suren Baghdasaryan" <surenb@google.com>,
	kernel-team@meta.com
Subject: [PATCH 2/3] mm/pagewalk: let folio_walk_start() run under the per-VMA lock
Date: Wed, 24 Jun 2026 21:50:52 -0400
Message-ID: <20260625015053.2445008-3-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625015053.2445008-1-riel@surriel.com>
References: <20260625015053.2445008-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DD2E740006
X-Stat-Signature: uqt6kektz7eboaoufh5fnyex8brwkrwh
X-HE-Tag: 1782352279-965419
X-HE-Meta: U2FsdGVkX1/ufW+8RZCRDGwk93mhQqkvi821ASaWGazbMsEHlckK/Iz6ylho9+ZXaemhNZ2nPY8NIh5HWc7c4I2E6PjtFxJYoi/7sKiabwP/fCott1BDlEDOXgbpHU4be1PYzbQ9TQgbEDDrW+dnF6xlyU3ej3sXZ0OctQZVUoNkqjeezhKr4EM2pEkCUByJKpWXq+WlxFXwTpuEHKCkRtRDOwG0XAhgEwN4FpVFMVfU333ydUpWtJ8Rn6QSmQocJ9KfL8FFwHwLGyO73U5MpPALKEl3p0OS+WCCJ1Hz4CEdfE4xfkai2gDiHqinGQWNJ9RvXgUpyOj3AKKAcQhprsalVFzvLX41iwAS8SYc4BsnNTd20Srb6huhwdGl1fY7p1oNbiFTW+itE2uSGrZajNTl94WlKbNbY7+7OF+tvod0tu8V+peknFYSqHgjuc2bZjzgEt/eilJRz0POudmZ/9R2UrSdBDvIdJPIH7HT24V3muvHmEKuREh19N5Zp8KIV76stD/inS+VJnWG2m8wx9WZEsXrccRnu9n3/VIpbdu4jDbRZXBHpwJVLW2ldeS5zIuW9VHT51QQXftR6nb416PnCSqJC0mh1uZzwhZ+aHf2WztsTSYE6IW16Hr1sevbIQEDGO1yHE/b1R70KVHuB6YWPwTy2te4e+PdOLB/EUs4+FAW+02038d500D/7dFN32KO6DmKvbyFuv2dDX92PLdfOGnzuiz7b6i8LAmggEMfo3ul44+2pc2ShFUtj3/7GNic7f1LufR6529pbV3Ce6POAFMgPLifvWyecRWkp/JOvQL2qQtRj+ch+/QOUMaIKTr04xOic8+oGaqyApmm/kuTxdqCd7QDGe06vnbncCiTl6fOomi4mGXhQW/qifVjSDIpbgAq6bhGKtk20NVX4EVi6Fm25CXnaFFNjAqOW6Zk7iovw7IcplCgsqeAn4XxNgo4mvSSCdZafOV+eUY
 bcwOA+9b
 71RgL0N8lRFEwDg40jh+5lR4iSaiYf5RIDjjCfgxqy+1lbTlkSZrywDDPT5S/f9B+eVjckt6ooKJ1O0R9niV22POUC36b0w6ts/8EQWDeP5i5OSB8G/o59F8yer/KCsejNULOvRwztmCG3pwq17Ii6R5Z281vFMLI8gk6MjqT4LcR67ncobmrNEpx63Sd7XiRYQeIWTibRfaqMTXo8CdqhWG4GFGcn7GSSCYzGewR2hk15IcTuIkUBxh2hzyD85+laHCivKzJz4M6vUEatLJG/QAMgBx0jfQVoD/Vst4iAfznMJxDyCBdUN2+mPfiDOkxQJR3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_walk_start() asserts the mmap lock is held.  For callers that only
need to read a single, already-present page, the mmap lock is a heavy and
often badly contended hammer.  Such a caller can instead hold the per-VMA
lock, which keeps the VMA itself stable.

The per-VMA lock does not, however, keep the page tables walked below that
VMA from being freed.  A concurrent munmap() or THP collapse of an
adjacent region in the same mm can free a shared upper-level table, and
THP collapse (collapse_huge_page() -> retract_page_tables()) frees page
tables of VMAs whose lock it does not hold.  Page table freeing
synchronizes against lockless walkers the way gup_fast relies on:
tlb_remove_table_sync_one() sends an IPI and waits for every CPU to enable
interrupts, so a walker that keeps interrupts disabled across the walk
cannot be observing a table that is about to be freed.  rcu_read_lock() is
not sufficient -- it does not block that IPI -- so the caller must keep
interrupts disabled, not merely hold an RCU read-side critical section.

Add an FW_VMA_LOCKED flag.  When passed, folio_walk_start() asserts the
per-VMA lock and that interrupts are disabled, instead of asserting the
mmap lock; it requires CONFIG_MMU_GATHER_RCU_TABLE_FREE and refuses
hugetlb VMAs (PMD sharing maps page tables this VMA's lock does not
cover).  The caller must keep interrupts disabled until folio_walk_end().

No existing caller passes FW_VMA_LOCKED, so behaviour is unchanged.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 include/linux/pagewalk.h |  7 +++++++
 mm/pagewalk.c            | 29 +++++++++++++++++++++++++++--
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
index b41d7265c01b..d0387470d732 100644
--- a/include/linux/pagewalk.h
+++ b/include/linux/pagewalk.h
@@ -150,6 +150,13 @@ typedef int __bitwise folio_walk_flags_t;
 
 /* Walk shared zeropages (small + huge) as well. */
 #define FW_ZEROPAGE			((__force folio_walk_flags_t)BIT(0))
+/*
+ * The caller holds the per-VMA lock instead of the mmap lock, with interrupts
+ * disabled across the walk (until folio_walk_end()) to serialize against page
+ * table freeing, the same way gup_fast does. Only valid with RCU-freed page
+ * tables (CONFIG_MMU_GATHER_RCU_TABLE_FREE) and not for hugetlb.
+ */
+#define FW_VMA_LOCKED			((__force folio_walk_flags_t)BIT(1))
 
 enum folio_walk_level {
 	FW_LEVEL_PTE,
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 3ae2586ff45b..ab1e81983cb8 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -890,7 +890,10 @@ int walk_page_mapping(struct address_space *mapping, pgoff_t first_index,
  * huge_ptep_set_*, ...). Note that the page table entry stored in @fw might
  * not correspond to the first physical entry of a logical hugetlb entry.
  *
- * The mmap lock must be held in read mode.
+ * The mmap lock must be held in read mode. Alternatively, if @FW_VMA_LOCKED is
+ * passed, the VMA's per-VMA lock must be held and interrupts must be disabled
+ * across the walk and until folio_walk_end() (only supported with RCU-freed page
+ * tables, i.e. CONFIG_MMU_GATHER_RCU_TABLE_FREE, and not for hugetlb).
  *
  * Return: folio pointer on success, otherwise NULL.
  */
@@ -908,7 +911,29 @@ struct folio *folio_walk_start(struct folio_walk *fw,
 	pgd_t *pgdp;
 	p4d_t *p4dp;
 
-	mmap_assert_locked(vma->vm_mm);
+	if (flags & FW_VMA_LOCKED) {
+		/*
+		 * Lockless walk under the per-VMA lock instead of the mmap
+		 * lock. The VMA lock keeps the VMA stable, but the page tables
+		 * walked below it can still be freed concurrently: a munmap() or
+		 * THP collapse of an adjacent region in the same mm can free a
+		 * shared upper-level table, and collapse_huge_page() ->
+		 * retract_page_tables() frees page tables of VMAs whose lock it
+		 * does not hold. Page table freeing serializes against lockless
+		 * walkers via tlb_remove_table_sync_one(), which IPIs and waits
+		 * for every CPU to enable interrupts; an RCU read-side critical
+		 * section does not block that IPI, so the caller must keep
+		 * interrupts disabled across the whole walk, like gup_fast.
+		 * Hugetlb (PMD sharing) maps page tables not covered by this
+		 * VMA's lock and is not supported.
+		 */
+		VM_WARN_ON_ONCE(!IS_ENABLED(CONFIG_MMU_GATHER_RCU_TABLE_FREE));
+		VM_WARN_ON_ONCE(is_vm_hugetlb_page(vma));
+		lockdep_assert_irqs_disabled();
+		vma_assert_locked(vma);
+	} else {
+		mmap_assert_locked(vma->vm_mm);
+	}
 	vma_pgtable_walk_begin(vma);
 
 	if (WARN_ON_ONCE(addr < vma->vm_start || addr >= vma->vm_end))
-- 
2.53.0-Meta


