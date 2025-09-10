Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D152CAC58E
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 23:57:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 988D68E0008; Wed, 10 Sep 2025 19:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 939478E0001; Wed, 10 Sep 2025 19:57:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801968E0008; Wed, 10 Sep 2025 19:57:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 648CD8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 19:57:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 271191DE139
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 23:57:43 +0000 (UTC)
X-FDA: 83875005606.21.64D41FD
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6608B20008
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 23:57:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MRNKjVBL;
	spf=pass (imf13.hostedemail.com: domain of 3cxDCaAgKCOgUSXcOiRYQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--kinseyho.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3cxDCaAgKCOgUSXcOiRYQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--kinseyho.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757548661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fKWU0JCSGAal/YneTCB+xLzgEtertXC6DRFwV85LNoU=;
	b=kx/j5LrZzcdQpCBrZ9p1+b3QVlk77oXDOzs7CLr2itiRl4zqbaCtwKiGViamN7ebYSEUBX
	zIvDbX80jDZ4P96zQzeO/kARwfObge9x04LWGxtJuxkquAWeaj7zJUOMAS5ELn1UW48BYZ
	27kmF0G+SbqyrkZjhePLAs0KOpSmc8s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MRNKjVBL;
	spf=pass (imf13.hostedemail.com: domain of 3cxDCaAgKCOgUSXcOiRYQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--kinseyho.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3cxDCaAgKCOgUSXcOiRYQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--kinseyho.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757548661; a=rsa-sha256;
	cv=none;
	b=vA6feQGdRdOT5VHYe6941T2BnMXRI1HMkalDZxOb4S6PEMBTAL4VQ2Qi13iHuWZNKXRlOA
	d2zhQs9UFx5BdlFl3+NdQ3hljgWAGQy7SSuS4ulkrGN04tNb2qJ/HLxwOyNFBdAJp28hcE
	t0stCzQxjvlJSCfHWSDGm8YnZYjyUQk=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-25c1dba8d26so369955ad.1
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757548660; x=1758153460; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fKWU0JCSGAal/YneTCB+xLzgEtertXC6DRFwV85LNoU=;
        b=MRNKjVBLUNzNnUv6wAnrK9+Y/joPnQMw/VVAY9yJ/yvKFVCl2UG+5v9g7/e86rDKNi
         75LKWzm4SaetZeWU5LR+yo1c6Vd22JDOCEm01jZ33sd97BxRr/fiiKASByS/EAzNpy2u
         z3fHOEduoBCKkDdeX0qRi18m6jXe+i2TEXglUDq1K9eJxzhH0xTEyLvFN0pPwfmki0Vx
         hESukrCFPkUYXNc9cQlPoD241ovNclbwyNx5eB9d4ReIdWOsMpjMvCY2W95WiMt1yG4B
         rG46/LKSAC6CxANxoa2+yW1KiIbIeNwR7BvM9rVkZTUz7Zns84DrM4MusRQdhU8waqVW
         98Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757548660; x=1758153460;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fKWU0JCSGAal/YneTCB+xLzgEtertXC6DRFwV85LNoU=;
        b=U49bhfE9QRjAsvM3zUj3kyniIFDJzKHOsQ31A8gAOCT3NKracb2JxW94ZWYUYJ7HEx
         B6VEI3A8rYxycx1D3aFesrVRnMhEXxOU/e/NWfDt1QLTXgqQ4rIqVOcbtN6pJLZ7GPxj
         f/K4tfgk7qhoKr8AcW5wyYoDJbLMECCmHYbKS9uilgiFYePTHyryctRExHc5To1chRh6
         4rtcndfYovyQoUr45VohHDaAuwEUq/stVXFscoCJCClaDviSPo/P58OAAr2bZzE+HwIg
         vlSUs0H0I0V8HS1TSy7k8fsqHPxdXd5+eZvuFpzHvoa8no+rjgt2m1I9bkCBlIovllvE
         ZtKw==
X-Gm-Message-State: AOJu0Yyr0Dhbsm7sv61F4PGOhDO1re/X80H7Zs56ihnZC9k2TqyJMFOy
	Hpt5zytX5AGecLKwtjQ8HtyvgriKgDPHqiyLUE25u/ynm0CWdPLC1qE9U5B+yFe2bF+bgZ+NVy9
	0u3TrDe9HugDkihGCQcXg1dVSZ/3AMDLMkqFdCdIy3gMIZT4VTDNfBql6Q9nZFDz5YmcFBsr3/0
	G9iSh3Essyz5cXumQTM3TIVUl7jUJdzqalcDKEU418PQ==
X-Google-Smtp-Source: AGHT+IFq8VkhrHeJOG3/Ln7wQEcgZo8IP0bqwkSRXeXCOz+z/QeqWuym37ouwoU6uQh35ghe7DgvgPGcQOUmDQ==
X-Received: from plbe19.prod.google.com ([2002:a17:902:f113:b0:245:f81c:1553])
 (user=kinseyho job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f690:b0:248:79d4:93ba with SMTP id d9443c01a7336-25170c432b4mr230955415ad.39.1757548659989;
 Wed, 10 Sep 2025 16:57:39 -0700 (PDT)
Date: Wed, 10 Sep 2025 16:51:20 -0700
In-Reply-To: <20250910235121.2544928-1-kinseyho@google.com>
Mime-Version: 1.0
References: <20250910235121.2544928-1-kinseyho@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250910235121.2544928-2-kinseyho@google.com>
Subject: [RFC PATCH v2 1/2] mm: mglru: generalize page table walk
From: Kinsey Ho <kinseyho@google.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Jonathan.Cameron@huawei.com, dave.hansen@intel.com, gourry@gourry.net, 
	hannes@cmpxchg.org, mgorman@techsingularity.net, mingo@redhat.com, 
	peterz@infradead.org, raghavendra.kt@amd.com, riel@surriel.com, 
	rientjes@google.com, sj@kernel.org, weixugc@google.com, willy@infradead.org, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net, 
	nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com, 
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com, 
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com, 
	balbirs@nvidia.com, alok.rathore@samsung.com, lorenzo.stoakes@oracle.com, 
	axelrasmussen@google.com, Liam.Howlett@oracle.com, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 6608B20008
X-Stat-Signature: wpi3a185wdph49m16zmpze61bgu4es8o
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757548661-960834
X-HE-Meta: U2FsdGVkX18ffqkHU8v55Van32ol0yrq3Anx9YbrdJyKAfYQsj8YEPQB7DKvEoFPRtIg0U59h9Gl3m7Vy5H80XuyTwusWDGN3CjDmefALeKMJuTrFuOePpEmLK5pPwk8Y41VOzT3veThzCsb3XstSt8pAIDtxvWjBY84GYrLoPxs/5EStoVtBjcQz1wO7s2DPTxRRvHsKQI+TH/YN7KogEVu/BROmarrbKgpoHmIDqOsQDOu074/oNwmDrWrEAkA1c+2tPsqBIodd18GpzXlGoYNufL62IZd+K0ZSWjyr0x1afbXH99qOylLvEuiedN0Fonsvl8m5OSchikL0A4c1dvS+51vFKLt28Yw4mhJiM5qF8YJB/MbIkvnlCMiHayiqrI1acouvo3ghdAG4L6FlfcY/xf+J7S9BGUF/HRKHDZtUfDI1mPTqmPwqTZvsLtdMWGI8aC8pEiQZab/OsuaP8IXtJiln6mIK2MuLFp79lbpr6B0iRFRYFny57T8ccL/kZKGR2KZcBw5McjNY19oVSthf0jtbM0l7ws7IwCbAcDVmAvGQnQ9WQdc91yF3dXgKkJ8AbI5OrjxxI8UH/2eiM0dVx0aFbQFwatTp5+uQAm2oy3HK253a6N0D8SSWJrBskbsy4JB8O+gvy033vVsv+XU1krInRfSsEr2/iDNMo90XnRZRw+QcxfDJ6TJeYU8Mf3RAkhgFHxnHQNEZ0RFY/fkrtCqmtYJoePADIT1DJR9mCIAflIZXKpxe1OAgZ3ScWC3h0rXYmUm1DZBKu4NAMC8VarN7GV1QWQW1VJ5kgrgIbmca6zw70lXiTJRyC7Eeg1on9frIFxy1S/FY5yCQObA8UKMRvmE3TSfI1h9cSEQlufCFxuVAUcv28hvn94GG9N342WkrSwWUjjqD4rNTR6i8y16ow/ZY1Pk3NypqaXThFL7LXTb/tB+tjM8D77mHaOG1/s1Z3XNiIDqgqZ
 DHZgYI7x
 IJkGX2uEffJGAx19ZnOuqEIRB4rEAcrUrYBOmaIKJ+Mi6/eGCLFP7os1AXwKQlVhiTaKD3rZZJL35ClQXv2d2mivRDEQWojipPtgmIybv4g0n6iQUCo8Orz8TVYWt4Pd88UDkO5GQlgMNW25k2Q4QhGA8emYZYypMSmkA55ck04HYcDwFZWWpVQ6nRamkaJi2g9xnhI3YftzQ2m51H4yItey8N8w5Xy2OhiCH1DcNHBt+/9KbGj5qXRdMQ1sI4Ogq/UjhO82Z7Uh71/5wMv0ljUkxHMNWqAh6PVNGqQdQc8+5nG9s0uWLx0f2bS5N9BBFiTxJgfluZqz5wn3xsnLR+5IxUyNxCXEqhmoJFi6mfkszP57/5UyFhWZqBhgm4LOZQbar2CZ6CJBECgSxCxwKTIqBUbQrzmWTwDNW+BqMSfkhSfC30OPr1WK00Qw8T0d1krBZH++4A2oceiJqyPsEzyPe4k4h9TJ0kDf4TWMFgQ9fY/GzESLqD1qYRqbEkIXk9N6z/L3BjHPihLpQdC50LEIjXRPNfP1Lmc/dZkshUyRfXt0QvWT+nBMxgfD3hJN6f7aS7QTz5SRqeFY1PEyTYcla041Q8X1pKeolrAoA851ESNrnErLsIW6o1J47Ubb12O9L
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor the existing MGLRU page table walking logic to make it
resumable.

Additionally, introduce two hooks into the MGLRU page table walk:
accessed callback and flush callback. The accessed callback is called
for each accessed page detected via the scanned accessed bit. The flush
callback is called when the accessed callback reports that a flush is
required. This allows for processing pages in batches for efficiency.

With a generalised page table walk, introduce a new scan function which
repeatedly scans on the same young generation and does not add a new
young generation.

Signed-off-by: Kinsey Ho <kinseyho@google.com>
Signed-off-by: Yuanchu Xie <yuanchu@google.com>
---
 include/linux/mmzone.h |   5 ++
 mm/internal.h          |   4 +
 mm/vmscan.c            | 181 +++++++++++++++++++++++++++++++----------
 3 files changed, 145 insertions(+), 45 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index f7094babed10..a30fbdbb1a57 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -533,6 +533,8 @@ struct lru_gen_mm_walk {
 	unsigned long seq;
 	/* the next address within an mm to scan */
 	unsigned long next_addr;
+	/* called for each accessed pte/pmd */
+	bool (*accessed_cb)(unsigned long pfn);
 	/* to batch promoted pages */
 	int nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
 	/* to batch the mm stats */
@@ -540,6 +542,9 @@ struct lru_gen_mm_walk {
 	/* total batched items */
 	int batched;
 	int swappiness;
+	/* for the pmd under scanning */
+	int nr_young_pte;
+	int nr_total_pte;
 	bool force_scan;
 };
 
diff --git a/mm/internal.h b/mm/internal.h
index 45b725c3dc03..f8ca128f61ab 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -538,6 +538,10 @@ extern unsigned long highest_memmap_pfn;
 bool folio_isolate_lru(struct folio *folio);
 void folio_putback_lru(struct folio *folio);
 extern void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason);
+void set_task_reclaim_state(struct task_struct *task,
+				   struct reclaim_state *rs);
+void lru_gen_scan_lruvec(struct lruvec *lruvec, unsigned long seq,
+			 bool (*accessed_cb)(unsigned long), void (*flush_cb)(void));
 #ifdef CONFIG_NUMA
 int user_proactive_reclaim(char *buf,
 			   struct mem_cgroup *memcg, pg_data_t *pgdat);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index a48aec8bfd92..88db10f1aee2 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -289,7 +289,7 @@ static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
 			continue;				\
 		else
 
-static void set_task_reclaim_state(struct task_struct *task,
+void set_task_reclaim_state(struct task_struct *task,
 				   struct reclaim_state *rs)
 {
 	/* Check for an overwrite */
@@ -3092,7 +3092,7 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
 
 	VM_WARN_ON_ONCE(mm_state->seq + 1 < walk->seq);
 
-	if (walk->seq <= mm_state->seq)
+	if (!walk->accessed_cb && walk->seq <= mm_state->seq)
 		goto done;
 
 	if (!mm_state->head)
@@ -3518,16 +3518,14 @@ static void walk_update_folio(struct lru_gen_mm_walk *walk, struct folio *folio,
 	}
 }
 
-static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
-			   struct mm_walk *args)
+static int walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
+			   struct mm_walk *args, bool *suitable)
 {
 	int i;
 	bool dirty;
 	pte_t *pte;
 	spinlock_t *ptl;
 	unsigned long addr;
-	int total = 0;
-	int young = 0;
 	struct folio *last = NULL;
 	struct lru_gen_mm_walk *walk = args->private;
 	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
@@ -3535,19 +3533,24 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 	DEFINE_MAX_SEQ(walk->lruvec);
 	int gen = lru_gen_from_seq(max_seq);
 	pmd_t pmdval;
+	int err = 0;
 
 	pte = pte_offset_map_rw_nolock(args->mm, pmd, start & PMD_MASK, &pmdval, &ptl);
-	if (!pte)
-		return false;
+	if (!pte) {
+		*suitable = false;
+		return err;
+	}
 
 	if (!spin_trylock(ptl)) {
 		pte_unmap(pte);
-		return true;
+		*suitable = true;
+		return err;
 	}
 
 	if (unlikely(!pmd_same(pmdval, pmdp_get_lockless(pmd)))) {
 		pte_unmap_unlock(pte, ptl);
-		return false;
+		*suitable = false;
+		return err;
 	}
 
 	arch_enter_lazy_mmu_mode();
@@ -3556,8 +3559,9 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		unsigned long pfn;
 		struct folio *folio;
 		pte_t ptent = ptep_get(pte + i);
+		bool do_flush;
 
-		total++;
+		walk->nr_total_pte++;
 		walk->mm_stats[MM_LEAF_TOTAL]++;
 
 		pfn = get_pte_pfn(ptent, args->vma, addr, pgdat);
@@ -3581,23 +3585,36 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		if (pte_dirty(ptent))
 			dirty = true;
 
-		young++;
+		walk->nr_young_pte++;
 		walk->mm_stats[MM_LEAF_YOUNG]++;
+
+		if (!walk->accessed_cb)
+			continue;
+
+		do_flush = walk->accessed_cb(pfn);
+		if (do_flush) {
+			walk->next_addr = addr + PAGE_SIZE;
+
+			err = -EAGAIN;
+			break;
+		}
 	}
 
 	walk_update_folio(walk, last, gen, dirty);
 	last = NULL;
 
-	if (i < PTRS_PER_PTE && get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
+	if (!err && i < PTRS_PER_PTE &&
+	    get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
 		goto restart;
 
 	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(pte, ptl);
 
-	return suitable_to_scan(total, young);
+	*suitable = suitable_to_scan(walk->nr_total_pte, walk->nr_young_pte);
+	return err;
 }
 
-static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area_struct *vma,
+static int walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area_struct *vma,
 				  struct mm_walk *args, unsigned long *bitmap, unsigned long *first)
 {
 	int i;
@@ -3610,6 +3627,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
 	DEFINE_MAX_SEQ(walk->lruvec);
 	int gen = lru_gen_from_seq(max_seq);
+	int err = 0;
 
 	VM_WARN_ON_ONCE(pud_leaf(*pud));
 
@@ -3617,13 +3635,13 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	if (*first == -1) {
 		*first = addr;
 		bitmap_zero(bitmap, MIN_LRU_BATCH);
-		return;
+		return err;
 	}
 
 	i = addr == -1 ? 0 : pmd_index(addr) - pmd_index(*first);
 	if (i && i <= MIN_LRU_BATCH) {
 		__set_bit(i - 1, bitmap);
-		return;
+		return err;
 	}
 
 	pmd = pmd_offset(pud, *first);
@@ -3637,6 +3655,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	do {
 		unsigned long pfn;
 		struct folio *folio;
+		bool do_flush;
 
 		/* don't round down the first address */
 		addr = i ? (*first & PMD_MASK) + i * PMD_SIZE : *first;
@@ -3673,6 +3692,17 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 			dirty = true;
 
 		walk->mm_stats[MM_LEAF_YOUNG]++;
+		if (!walk->accessed_cb)
+			goto next;
+
+		do_flush = walk->accessed_cb(pfn);
+		if (do_flush) {
+			i = find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
+
+			walk->next_addr = (*first & PMD_MASK) + i * PMD_SIZE;
+			err = -EAGAIN;
+			break;
+		}
 next:
 		i = i > MIN_LRU_BATCH ? 0 : find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
 	} while (i <= MIN_LRU_BATCH);
@@ -3683,9 +3713,10 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	spin_unlock(ptl);
 done:
 	*first = -1;
+	return err;
 }
 
-static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
+static int walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			   struct mm_walk *args)
 {
 	int i;
@@ -3697,6 +3728,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 	unsigned long first = -1;
 	struct lru_gen_mm_walk *walk = args->private;
 	struct lru_gen_mm_state *mm_state = get_mm_state(walk->lruvec);
+	int err = 0;
 
 	VM_WARN_ON_ONCE(pud_leaf(*pud));
 
@@ -3710,6 +3742,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 	/* walk_pte_range() may call get_next_vma() */
 	vma = args->vma;
 	for (i = pmd_index(start), addr = start; addr != end; i++, addr = next) {
+		bool suitable;
 		pmd_t val = pmdp_get_lockless(pmd + i);
 
 		next = pmd_addr_end(addr, end);
@@ -3726,7 +3759,10 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			walk->mm_stats[MM_LEAF_TOTAL]++;
 
 			if (pfn != -1)
-				walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
+				err = walk_pmd_range_locked(pud, addr, vma, args,
+						bitmap, &first);
+			if (err)
+				return err;
 			continue;
 		}
 
@@ -3735,33 +3771,51 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			if (!pmd_young(val))
 				continue;
 
-			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
+			err = walk_pmd_range_locked(pud, addr, vma, args,
+						bitmap, &first);
+			if (err)
+				return err;
 		}
 
 		if (!walk->force_scan && !test_bloom_filter(mm_state, walk->seq, pmd + i))
 			continue;
 
+		err = walk_pte_range(&val, addr, next, args, &suitable);
+		if (err && walk->next_addr < next && first == -1)
+			return err;
+
+		walk->nr_total_pte = 0;
+		walk->nr_young_pte = 0;
+
 		walk->mm_stats[MM_NONLEAF_FOUND]++;
 
-		if (!walk_pte_range(&val, addr, next, args))
-			continue;
+		if (!suitable)
+			goto next;
 
 		walk->mm_stats[MM_NONLEAF_ADDED]++;
 
 		/* carry over to the next generation */
 		update_bloom_filter(mm_state, walk->seq + 1, pmd + i);
+next:
+		if (err) {
+			walk->next_addr = first;
+			return err;
+		}
 	}
 
-	walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
+	err = walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
 
-	if (i < PTRS_PER_PMD && get_next_vma(PUD_MASK, PMD_SIZE, args, &start, &end))
+	if (!err && i < PTRS_PER_PMD &&
+	    get_next_vma(PUD_MASK, PMD_SIZE, args, &start, &end))
 		goto restart;
+
+	return err;
 }
 
 static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 			  struct mm_walk *args)
 {
-	int i;
+	int i, err;
 	pud_t *pud;
 	unsigned long addr;
 	unsigned long next;
@@ -3779,7 +3833,9 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 		if (!pud_present(val) || WARN_ON_ONCE(pud_leaf(val)))
 			continue;
 
-		walk_pmd_range(&val, addr, next, args);
+		err = walk_pmd_range(&val, addr, next, args);
+		if (err)
+			return err;
 
 		if (need_resched() || walk->batched >= MAX_LRU_BATCH) {
 			end = (addr | ~PUD_MASK) + 1;
@@ -3800,40 +3856,48 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 	return -EAGAIN;
 }
 
-static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
+static int try_walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
 {
+	int err;
 	static const struct mm_walk_ops mm_walk_ops = {
 		.test_walk = should_skip_vma,
 		.p4d_entry = walk_pud_range,
 		.walk_lock = PGWALK_RDLOCK,
 	};
-	int err;
 	struct lruvec *lruvec = walk->lruvec;
 
-	walk->next_addr = FIRST_USER_ADDRESS;
+	DEFINE_MAX_SEQ(lruvec);
 
-	do {
-		DEFINE_MAX_SEQ(lruvec);
+	err = -EBUSY;
 
-		err = -EBUSY;
+	/* another thread might have called inc_max_seq() */
+	if (walk->seq != max_seq)
+		return err;
 
-		/* another thread might have called inc_max_seq() */
-		if (walk->seq != max_seq)
-			break;
+	/* the caller might be holding the lock for write */
+	if (mmap_read_trylock(mm)) {
+		err = walk_page_range(mm, walk->next_addr, ULONG_MAX,
+				      &mm_walk_ops, walk);
 
-		/* the caller might be holding the lock for write */
-		if (mmap_read_trylock(mm)) {
-			err = walk_page_range(mm, walk->next_addr, ULONG_MAX, &mm_walk_ops, walk);
+		mmap_read_unlock(mm);
+	}
 
-			mmap_read_unlock(mm);
-		}
+	if (walk->batched) {
+		spin_lock_irq(&lruvec->lru_lock);
+		reset_batch_size(walk);
+		spin_unlock_irq(&lruvec->lru_lock);
+	}
 
-		if (walk->batched) {
-			spin_lock_irq(&lruvec->lru_lock);
-			reset_batch_size(walk);
-			spin_unlock_irq(&lruvec->lru_lock);
-		}
+	return err;
+}
+
+static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
+{
+	int err;
 
+	walk->next_addr = FIRST_USER_ADDRESS;
+	do {
+		err = try_walk_mm(mm, walk);
 		cond_resched();
 	} while (err == -EAGAIN);
 }
@@ -4045,6 +4109,33 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	return success;
 }
 
+void lru_gen_scan_lruvec(struct lruvec *lruvec, unsigned long seq,
+			 bool (*accessed_cb)(unsigned long), void (*flush_cb)(void))
+{
+	struct lru_gen_mm_walk *walk = current->reclaim_state->mm_walk;
+	struct mm_struct *mm = NULL;
+
+	walk->lruvec = lruvec;
+	walk->seq = seq;
+	walk->accessed_cb = accessed_cb;
+	walk->swappiness = MAX_SWAPPINESS;
+
+	do {
+		int err = -EBUSY;
+
+		iterate_mm_list(walk, &mm);
+		if (!mm)
+			break;
+
+		walk->next_addr = FIRST_USER_ADDRESS;
+		do {
+			err = try_walk_mm(mm, walk);
+			cond_resched();
+			flush_cb();
+		} while (err == -EAGAIN);
+	} while (mm);
+}
+
 static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
 			       int swappiness, bool force_scan)
 {
-- 
2.51.0.384.g4c02a37b29-goog


