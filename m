Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F6F3CD98C5
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 19:35:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A626D6B0099; Sat, 13 Jun 2026 15:35:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EC286B009B; Sat, 13 Jun 2026 15:35:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DB476B009D; Sat, 13 Jun 2026 15:35:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77EE36B0099
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 15:35:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 19B688E778
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 19:35:55 +0000 (UTC)
X-FDA: 84875894670.13.1BD95AE
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id 599E680008
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 19:35:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T5Eh1MUi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=devnexen@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781379353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3Cmhs58uQKi44yY5Y2hGII54QusWM4xNolmjeKKYnbs=;
	b=UreBDkJMM5C2Uz6J+Yrcy4R/xjHnTSrPnSd3Iz8/POtLvx9jyZhA8BTHKKMofzQMo4ucqU
	nMNkajpvVEmDi3g0lS61YqMUoMpMm7qmzZ3kL6SdKlv6s3MR3JA5XCdKexK0Izo8cF0eEG
	LQkHOELFmcJ+QqKv6TnJExhHyXCcS58=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T5Eh1MUi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=devnexen@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781379353;
	b=Be1jJ2f8KqShcvlVsar/sMb0b8aR+1uJIwV4tpXs6cPGr310jHB0yjEmfbV3STxwROeSx2
	SKh7S7sdPuk7yT1FHNz04/KGmEkZbqaqr0IrgGBCiDYN8iV3HP98WsjUYBPffHR0WfF32c
	wsuJKuM76hFjDs/GMf3nJJiJAO52j90=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490bb83a3f6so15712095e9.0
        for <linux-mm@kvack.org>; Sat, 13 Jun 2026 12:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781379352; x=1781984152; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3Cmhs58uQKi44yY5Y2hGII54QusWM4xNolmjeKKYnbs=;
        b=T5Eh1MUiRtrGl7k7Qn55KZfxzL4UofZKAa4JyFboEv0KRFicMXJChWp9AcMaPV91il
         oH8MwBvCuivf/UYtgx1KvdRwqy5wNea1tBQGV6SdfEBAlTdTOgDIQG3xlkKaauE9zGZS
         CFCf/ler01JFE7S625QrgCqIAYOZyFEPbSggUKYFcv4nxxDuVG9V2kdsK73NThcUN67V
         q2IgBiGoc4WYAX2UXiAzmEJn2EZv4l+fATse72UVfyLU9Crgr9CEIyVA7maujgrqp0dY
         yJe3A/bXdL6PNznYfTIgI1Tn4aZeAOKWtFBeM2M0+44DP6bv/6AJSifBfLMqE/Eu4wnB
         y11g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781379352; x=1781984152;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Cmhs58uQKi44yY5Y2hGII54QusWM4xNolmjeKKYnbs=;
        b=NidZ77qXdmOLEsYCpIkJItePKnBlz87SOOup487McqzCEZ3O8P3fevswejt0hy+cTs
         1H+/ZEiz6SLRcxGEmlcir7MxYIEYsel3TofjgUGl+OuU+orTjaAHTzKHHKigxS48ibEl
         iU7mSQLBBgX6tFJGv6hSheqxwYwtwm2G1LF5M5WRK8a8CcsMLyR9kWe0jZ9+OMKSPyA0
         8g0vbsorGx8lIxsnBkjJJ44Pf2Q9iJhvZRHFPdD+uTWUyH461cVPfrhHjoIeqkjMY3Zp
         iQIhp3s27ARS62t9kKJDROwIfI2UH7loGKFDkbk80AHMZAlTPOmop/gx6E7F41yzRdYh
         OiiQ==
X-Gm-Message-State: AOJu0YwlRZbQt7x/7f/UVFkrMZO4fIcgs/TaC1s0k1MOpmoBYWY+sI9l
	UCcQoS2DvWExVOuWyKUGO587jKdNoGa7Cc0PI95HWecXlXP3Kss8K7+3
X-Gm-Gg: Acq92OGtWwOOLb9SVsslS3BOlu6hX0GuLz3gBEX5/AWtxz7wJzImdf11cbrrQiYTNyN
	gELpPU1N9kR+crd0uivw4WWk6TbX2z1XcWh37FfqHbPcy/1mAUDzb5bS/duqtjxyPUA6sKqATaX
	iim/sLPNKv4PAGUAaqSgtjeX+Wz5Pi6Qg87lahxswPPdk9EyVN9OhQjvjl62YgOhovK+8qerhtj
	jdAHLVaOiIqozgqkM1yF+wypl6EKRkHrS0bvNDBNvlIZ09S0lCWJCr5468Bg9Vi8zhBfrtHZc4d
	q8mH9N4W7kr2rtf5z/VFRmSuSHIuhOUwQTfQMZU0UNZ3O0rg3FeKzZh+4CrngSDxqVBSPekFHhw
	IVg/sVgIwT2g0fEPxIuiNwfm7rLf+l6nxZElJZx8/vjAFyjFZTwWZjWyu3LPBmTvKXnjXtxzzZU
	N7hvHjLlvFvSVva0N84JJeYCQmceU6E4HyEZDLy5EUmQ9sNI/cszYExvlbE+J/yWY1M+ilaDgai
	7zaJfctdSE=
X-Received: by 2002:a7b:cbc3:0:b0:48a:5565:ec3d with SMTP id 5b1f17b1804b1-490ec502d01mr70797785e9.22.1781379351223;
        Sat, 13 Jun 2026 12:35:51 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-492202edf89sm105098115e9.1.2026.06.13.12.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 12:35:50 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com,
	David Carlier <devnexen@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4] mm: pgtable: free kernel page tables via RCU to fix ptdump UAF
Date: Sat, 13 Jun 2026 20:35:47 +0100
Message-ID: <20260613193547.183867-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 599E680008
X-Stat-Signature: yp7mjpt8ub1q1t78bbcekm7bxonqro9c
X-Rspam-User: 
X-HE-Tag: 1781379353-664579
X-HE-Meta: U2FsdGVkX1/kGtJ+UyCFFPp3aw4zfrsL7jTwoPtFTY+EPSMH6yT28LcXb6ydNMm4cTj9upVoWaZJsCv+SpmSCn5xbfiquNYdLUuQt8s+53pnASIry/ULYdOHvdlN/ZapZEMWBn7wus0n3eyUyg374nmjZiUlHDLkAvimiTBmgxMK8mNQETeS6uxhakBkFoVAtT9BEHJXqCRo9RTeuN4EqXws8I6VGBtTCxCpuSPaAEgWvOIGN0N46pAAzFLTean2YolvueXq+KwFKg//er+DCinur0qhsKzxMwy3oE4W+bjpPMwER4yTk35dOFRKS/QDycMwXwime+tE3EWO5JbgA+xL3/m/K+vw8Z2SjcU9eIZhezqPzWsJva4/jUelRaUEPhXb88AtDXmahu9QL5eY+PTlIZKVdJu3jhnxdRXkw1faQtjITY00YrDPns7sRxQf+AR+Q/jCEsjdy+rzhr4J39t2M4LPfw6x4WNXWRN9D6UEmU4zIp6qEufc5mWKRXYE2AZeFD27H+ji9IXA9SW6zdcCO30PGISdOMOcPVbuFdNLIGhQSFdRWXXkg9zMyDsoii5FG4DC0xXDmHh+rMx5yY+0p+7MaSL3T8CKheorYo/951ljuF+yPnQjMwcuEpMDMNvKXWqQfelNAYeV7TspbW4RbGYZrD3vBQva74Harfg0O6pX8y3c3svIYTxuhlUsKGHd+Fc39zDRM98wVWmoGrrQmFJULuPX5DbIpdyvW0YCQy7qLy2SD+7rBKw/lp38SXf5vAH48PIDLvXjZh+TRT9l3kVyJdN6DYeE4VRhjUE8kttwFn4imOKj06NwOEtDv4kUUcOO9LZfHImmeeitTff3oMrqVrj6oT3JCyyo6aTQaQ5qx9ghBvI1Qs1JMWgUrREC2n4jtE42u8sqQRVxjnWkP88Okc52jOfcplgzQsI1Cb9gs1DwpjRx0A3DmNCWRi1zeIYkwp8+FGrkwDZ
 kKbj3BYQ
 /n6B7LhVL4cExH87VAd4ndAtWXrONJIAKlUsAaHUUI1jAW+WN+i+dPmoHPBKRhoIkKo1u21pl7TjWVSaTaWy7y5zMx8RU9X+wuZ+RKhKIx+mq6gKuhLDr78UTrFZumJc7NckNaIbsw9xXEx3Ywd7Jb0qwf4uqzeSwzh9KhrPC3LxYq/zWK97rBOWRaQqLoUviKk/lWBDsSh2u9wnCQ4QIwnPbWCGZ3L03EjNgY73ezUlz6BonSkUPxIBOS3SzI0eE+BlzRkjz/WWzRiP3uSmlkjO6mnXJdNWBZ35QFss8hHmreRK7Q+kJQVchj2yfAM7th5kZUltJBnpW3E5n1DW2ClRvO6r8Cnv/T28Tt0VPYY6lzEsi4n0FtHr368eH2LMGD/9iH8lwLyzsegUIBNZV123kpcv2YV88DNG7JXo7wEueWUZ20XYyau6KUQ++EpNFcxB+J0QHN9qXWzPD/cGESrvJHeMPPciTKlug0b9IWEabksPlZ/gZS1mKxqCRiP/Hy11di4+3u8Wkc9rfwTZXO87oek/O4t0+PS/WCBwKaEpmSfy/u3OXcpG/rT/J5IFTlS7sdPzvUdYt2VXnhxKOp1Wi5tZbiOUeOckFfmv3XctxSLzHxFkK9fqfHSsBAExv9aoWM6IY2ATy+ckpjwHncVJCOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ptdump walks the kernel page tables holding only the init_mm mmap lock
and the memory hotplug lock. Neither of those stops vmalloc or ioremap
from freeing a kernel PTE page underneath the walk. When
vmap_try_huge_pmd() installs a huge mapping it collapses the existing
PTE table and frees it through pmd_free_pte_page(), and on x86 that
happens without the init_mm mmap lock. syzbot caught the resulting
use after free in ptdump_pte_entry() reading a page table that had
already been freed.

pagetable_free_kernel() used to free the page immediately on
configurations without CONFIG_ASYNC_KERNEL_PGTABLE_FREE, and on the
async ones it only batched a TLB flush before freeing. In both cases a
lockless walker could still be dereferencing the page.

Defer the free by a grace period instead. pagetable_free_kernel() now
hands every kernel page table to call_rcu(), so the page stays valid
until any walk that may have observed it has finished. The async path
keeps doing its TLB flush first and then queues the RCU free per page.

On the read side, walk_page_range_debug() takes the RCU read lock
around the kernel walk through the new walk_kernel_page_table_range_rcu()
helper. A walker either sees the cleared PMD and skips the page, or
keeps it alive until it drops the lock. The plain
walk_kernel_page_table_range() stays as it is for callers that already
own their range and cannot race a free, such as the arm64 page table
split paths.

Fixes: 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables")
Reported-by: syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a287988.39669fcc.33b062.00a0.GAE@google.com/T/
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: David Carlier <devnexen@gmail.com>
---
v4: defer the free in both the async and non async configs, not just
    the async one. Move the walk under a named
    walk_kernel_page_table_range_rcu() helper instead of open coding
    rcu_read_lock() in walk_page_range_debug().
v3: take rcu_read_lock() in the init_mm branch of
    walk_page_range_debug() rather than inside the lockless walker,
    which the arm64 split paths also use with GFP_PGTABLE_KERNEL and
    can sleep.
v2: use call_rcu() instead of synchronize_rcu().
---
 include/linux/mm.h   |  7 -------
 mm/pagewalk.c        | 18 ++++++++++++++++--
 mm/pgtable-generic.c | 21 ++++++++++++++++++++-
 3 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..79408a17a1b0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3695,14 +3695,7 @@ static inline void __pagetable_free(struct ptdesc *pt)
 	__free_pages(page, compound_order(page));
 }
 
-#ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
 void pagetable_free_kernel(struct ptdesc *pt);
-#else
-static inline void pagetable_free_kernel(struct ptdesc *pt)
-{
-	__pagetable_free(pt);
-}
-#endif
 /**
  * pagetable_free - Free pagetables
  * @pt:	The page table descriptor
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 3ae2586ff45b..5b5807a88394 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -664,6 +664,19 @@ int walk_kernel_page_table_range_lockless(unsigned long start, unsigned long end
 	return walk_pgd_range(start, end, &walk);
 }
 
+static int walk_kernel_page_table_range_rcu(unsigned long start, unsigned long end,
+		const struct mm_walk_ops *ops, pgd_t *pgd,
+		void *private)
+{
+	int err;
+
+	rcu_read_lock();
+	err = walk_kernel_page_table_range(start, end, ops, pgd, private);
+	rcu_read_unlock();
+
+	return err;
+}
+
 /**
  * walk_page_range_debug - walk a range of pagetables not backed by a vma
  * @mm:		mm_struct representing the target process of page table walk
@@ -693,8 +706,9 @@ int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
 
 	/* For convenience, we allow traversal of kernel mappings. */
 	if (mm == &init_mm)
-		return walk_kernel_page_table_range(start, end, ops,
-						    pgd, private);
+		return walk_kernel_page_table_range_rcu(start, end, ops, pgd,
+							private);
+
 	if (start >= end || !walk.mm)
 		return -EINVAL;
 	if (!check_ops_safe(ops))
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index b91b1a98029c..d45a556b4021 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -410,6 +410,13 @@ pte_t *pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
 	goto again;
 }
 
+static void kernel_pgtable_free_rcu(struct rcu_head *head)
+{
+	struct ptdesc *pt = container_of(head, struct ptdesc, pt_rcu_head);
+
+	__pagetable_free(pt);
+}
+
 #ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
 static void kernel_pgtable_work_func(struct work_struct *work);
 
@@ -434,8 +441,15 @@ static void kernel_pgtable_work_func(struct work_struct *work)
 	spin_unlock(&kernel_pgtable_work.lock);
 
 	iommu_sva_invalidate_kva_range(PAGE_OFFSET, TLB_FLUSH_ALL);
+
+	/*
+	 * Lockless kernel page table walkers (ptdump, and any other user of
+	 * walk_kernel_page_table_range_lockless()) dereference these pages
+	 * under rcu_read_lock(). Free them after a grace period so a walker
+	 * cannot still be reading a page we release.
+	 */
 	list_for_each_entry_safe(pt, next, &page_list, pt_list)
-		__pagetable_free(pt);
+		call_rcu(&pt->pt_rcu_head, kernel_pgtable_free_rcu);
 }
 
 void pagetable_free_kernel(struct ptdesc *pt)
@@ -446,4 +460,9 @@ void pagetable_free_kernel(struct ptdesc *pt)
 
 	schedule_work(&kernel_pgtable_work.work);
 }
+#else
+void pagetable_free_kernel(struct ptdesc *pt)
+{
+	call_rcu(&pt->pt_rcu_head, kernel_pgtable_free_rcu);
+}
 #endif
-- 
2.53.0


