Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD4DA60A261C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=KBCsRd82
Received: by kanga.kvack.org (Postfix)
	id C20ED6B05BD; Tue, 10 Nov 2026 10:04:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFEBD6B05C0; Tue, 10 Nov 2026 10:04:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9366E6B05BD; Tue, 10 Nov 2026 10:04:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5339B6B05BD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:04:56 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5FF3A0958
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:04:55 +0000 (UTC)
X-FDA: 85419531750.22.E0D15F8
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf11.hostedemail.com (Postfix) with ESMTP id EE74740019
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:04:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=KBCsRd82;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794323094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mch4iZRzweRd1dIkwLWbrFi7MIz51SJR1zGEaUbpjgg=;
	b=knkl1Cx7HiJ/XabTHYXCcEi1tFnkvYRJNmyf3w6E3WWMRNzyd2f/VpUuOzgneG9QZ/pdOC
	BMhzLlJXSNwEw1HvHYtcPI6JQ8IElkARg7yc/U8SobXTmDzpJ/wTbgYeI0kQu4OkLi3j3q
	/dAaSLKue+nrGsAupO08Yi+o+lxCQd4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=KBCsRd82;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794323094;
	b=Bs682uzfMNp73pY5+Plu/FvOj2gn59cKApIQjrOlSzaTZzs3M7BirTdOtbXg4GMLal0svN
	Wdiii8gvaN1F+XtlL0g7CrUG80RvU9UIWr6KDvprWIG7yM+8LjOnTno8TIxJudjXe+l7+2
	5C4TWI/4xa99pZduL4axRbjpCHCE25A=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-91ea2e29d90so21688486d6.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794323093; x=1794927893; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mch4iZRzweRd1dIkwLWbrFi7MIz51SJR1zGEaUbpjgg=;
        b=KBCsRd8212hpOY04WEihihb2Dv2Hhcq1VwqiDYDZDPitqbmbuPpm1/WdTwCV0XD+gJ
         y1j+ugNxBLG2HMz8fZnWUbar8N0KAMMre9lS/3zyiIU0ltWdVsxC9zHne/CFR8wr1Wf0
         IoGD8M2SBK6cbB3lcsql/DgRbtvMlrVBMpxejHLTtJQia5QicCu2Zps8VGV7lMuJn0IZ
         ryyVWjCtWsgBX8UIBXBDlEGopZ6sItY2nBbL8+zns9C0vNPxOEfj7Bp729PD1do1hk3v
         8YKjrBwTtdmmbDJLE3z5XIfOWhhqC13jma0ysvNN1BZo5YN1xrrCIYafmC/aiceZ8gKU
         nZkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794323093; x=1794927893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Mch4iZRzweRd1dIkwLWbrFi7MIz51SJR1zGEaUbpjgg=;
        b=SFKcIP0+b5FxAv1tx50102/5ckbbi23ZKrKaTZO/eH71yz+DIwmLR35hGDX0CfN+FU
         zHTbAtK3yvM//Jhwbk0CyK+MW1KuESxdtD07GiEoCRPYfRc7LAa+Zf9zWXb5riDCl1xQ
         b9T2+Uon+/B6WokeNTfe9drdUHrzkVwLNHEAzgxzGqJz36oeld0KIA6k5bLsgvnaRmsx
         3FaBMO8Kf3llhy4YNRK5QRzBx3Mo8Wdrdw1l5uw9TEPOCEk3EfvfOrsfmWh+GY+2rA33
         p7dplN1fAQEmeC/2oyA1xETadoXnPvf07Tg+7Gda3Et/Ckzc5qH6BIQ+cLfMRZYIasJU
         Go7w==
X-Gm-Message-State: APuU4Z/VCZ/WokYe07EbVBNe6cRZlsZJVs+8Z4apE+PAVM2Gz0aSdY2S
	/jelpAJzpkhagL1fJuN8SMfoIHicu2X9/T4Ues/JoGwgbvNSfi6dTb5PIzBD8BrbWfcrM44UIrN
	aqO3Z
X-Gm-Gg: AYBFou1hfQ6AwLqlnJD+83bdtT7zOZcnwqWLNrrxlCKfhDDc75yLlBkfixjRe26eH1p
	3zsCYPXwxmrghKrKS6hg/WtaBpmBKDKXeUdufsd6p01O0KsN4Y/GNmThvLokbyMgn7pcu9Unuqc
	XLjbQBc96SsG1TRA/u+94vDuHno4rLxCryJvicWy/3tu3FSVyCm4RXVjBcVXSTSNKB1k5SAXXAa
	vL7MznDnt+x0x54GramhXJuwmhQ3GyJET7KBJd+FBDnCPp4vytrVWPTfG6uzfpjCnt1ZJdk494h
	otMWyOW9tdjQ3GnN5u5dAzmKMNvEsn95HHkBoC0BRcNb+zZR0i9b+1yW4fJ3Oj8jgqA98akt92H
	3D3OQveWH9WEtbZ6jdDeQ1+J3NMRQUqcbFsWNVBdBWhTHBuW07iYUygigst4T7Z/uZKDExMUhzF
	UMYcYjfkBgPMh4gPpe8wVNTmhX6zCAYZuGjd5VsBCXk2Wlli9T4R2Dd0eB1PBYjOFphnB4kY7Pe
	8I9N6aC6LN+2CdkPbtgixLS+zpgS5cnNaV9pXwWARW+r7B6ExLy/FQdgxn/FzurIicGAQGC2Zx2
	VD8zQdgINCmnXLI3QIYvVYw297REXjObRU6kEJISECDttk7iA+k/omx6KQ21nHmZvw3EVNHd7g3
	EYj4RtS9AldF7iXdiL2pAlpcLgAXLpQ2Knbiq
X-Received: by 2002:a05:6214:401a:b0:91b:5d39:e133 with SMTP id 6a1803df08f44-91ef02f0932mr38917826d6.30.1794323092936;
        Tue, 10 Nov 2026 07:04:52 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef031c7dasm22902406d6.1.2026.11.10.07.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 07:04:52 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@techsingularity.net,
	mingo@kernel.org,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	hannes@cmpxchg.org,
	osalvador@suse.de,
	raghavendra.kt@amd.com,
	stable@vger.kernel.org
Subject: [PATCH v5 1/7] mm: support promotion-only NUMA hinting scans
Date: Tue, 10 Nov 2026 10:04:40 -0500
Message-ID: <20261110150446.2452975-2-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261110150446.2452975-1-gourry@gourry.net>
References: <20261110150446.2452975-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EE74740019
X-Stat-Signature: emqa361ja34w19hz8hxo4et1uxwrbg7w
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794323093-547552
X-HE-Meta: U2FsdGVkX1/PSXO4G4SplSK3CewLIJWny1W0/nwvSGJvu76wt7IvQX2G2qpAK/vAjQao1p7nh8yuAszadVTnvKxh5RH7jbvULIPb55Bz4RvMrVwuEwAOc7fRL5Pg6+/yCCqmux1IkYFgeyIeZgtkDdUiZFoZrpb+/5UesYHyokHwy8dqEb4rY8kEkJIXpFeXr7Z/yO4sFDsuASiTExom6UQB/eYBrt+YH6DEOAJLg2i3p7Etmkt6fqcoahrA0YQFXBsOYt3MkqkOIYzqzYHLS6ZbwYP0dHIefB08oQZY2wGn1RPN1WkHKIh2emEpOgrnRSFuIhrqmhwtxg+gRdSTFc9dKV3bmBxV+vzT5ctgjirQG96SNckT20375KInQafMOcO/hy07uwXLFNEXYpOa9EQYs5qSG1LPNF7rcTcOPI69UNjLts33XBqCKVf8tLoc6zpndaf08HgaZpgiZ5k6Wc7kUMUrJUmFSChNkzk69B4d1TseDEGVO8EhfTGaPG1eY1GdqP9ScA9A/mApirE4pP6bIiumQlXijCoW9UiN7FHHxYsar8G0eiai60zqHOpXu7qqsMaRAWOuxLtq+Vp2jI4DSlLCB2onP0TbD1ZmSgyh6s66QL6eWxUOM5ahFwB2jioR48WVhh23bW3dJRTiLnoRntiexXxJ0XL14hItA/N0sdwRTu3PJaYuwqssRzqZ8NX5DDr9qNrZdePg91h29fQi9rXbd+RsWmaBf8PufeGxQoR9J2ClbjVYtiRDaTFMa1B/00t+vCmGvujRZeDjUn0yvrUMAonV3qKqN1ax/gj/UJ5uu7RDjegxPbP12WTxao+PSjs6Se0A9Rus4bMPDrusrsy7LVF6gACXVrSZCmhAebYoErsgDsYxqP5LZCLFYSxDJm6JK6ixCSXMMaB1tchfxam1SNWfkt/GOhkli6bt77ve2p7YlNb3fKggHLkweRYb2ttanoQhoaW1gIs
 AI0cpE62
 YAwwA8FFn1e8Gk/40/Cuesz0QhMOAGAgMGfz/WCJBspqmvy26L9UYTvkx9QsYsEGAIs1kRTDvfQ5HHZ92IDwBWz5aAkPvFW/RoDQ/Hs5s85lWa3mYGe40ATVLLl1BrJGWF9GY8bM4eLXL+baSLJgagFlJTJl+qigi2xXYdTp2rmjKpemaOvFgeQVmUDEBuYNWumn2bns3KZA7efXkQ/r75qTxb7gTskHkJ/ibAYy7JeDe/8P9tgO4wvgN21ZZGbl7Lo5ekt1cQsjBPluADJAAbtSUCPgV9YkFISwGvyYy8MG9GnzW8Lut+j3QZY8KgOdgwliTiBBitO0x9eTi+ynjP8LMT2mlOuQ3PfxmcbzGG3zZm06gYBVfgd5A7mSvrzOv7TPDG4OTLZpxt51o63W1UQlw7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

folio_can_map_prot_numa() derives folio eligibility from the global
balancing mode. The mode (normal, tiering, or combined) describes
which balancing mechanisms are enabled (placement vs promotion).

The global setting itself cannot describe the intent of an individual
protection walk because normal-mode tempers its scanning activity based
on a number of heuristics (read-only VMAs, activeness of VMA, etc).

In tiering or combined mode, applying these normal-mode optimizations
to an entire VMA is incorrect and breaks tiering.

 - Opting VMAs out of scanning because they became inactive obviously
   breaks tiering - because the intent is to identify when a VMA
   becomes active. Applying it in tiering modes causes VMAs to become
   permanently stranded on lower tiers.

 - Opting Read-only file VMAs out of scanning is just incorrect for
   tiering modes because its intent is to prevent bouncing between
   sockets (east-west), while tiering controls tier migration
   (north-south).  The result is hot read-only files can overload
   lower tier bandwidth.

Add MM_CP_PROT_NUMA_PROMO_ONLY and let task_numa_work() select the type
of walk from a single read of the balancing mode. Build the
change-protection flags there and pass them unchanged through
change_prot_numa() so its PTE/PMD paths use the same decision.

Have folio_can_map_prot_numa() derive the single-threaded private state at
the point of use instead of adding another precomputed boolean to the
protection-walk interface. This keeps the interface focused on scan intent
and avoids plumbing VMA-derived state beside cp_flags.

The tradeoff for the cleaner interface is an atomic mm_users read for each
folio, rather than once per PTE range. Check the promotion-only top-tier
exclusion bit first as a mild optimization.

The scan-intent interface is required by the following memory-tiering
fixes and must accompany them when backported.

Fixes: c574bbe91703 ("NUMA balancing: optimize page placement for memory tiering system")
Cc: stable@vger.kernel.org
Suggested-by: David Hildenbrand <david@kernel.org>
Link: https://lore.kernel.org/r/4d2853c9-edf4-4685-b186-7214ed6abd84@kernel.org
Assisted-by: LLM
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/mm.h  |  6 ++++--
 kernel/sched/fair.c |  9 ++++++++-
 mm/huge_memory.c    |  3 +--
 mm/internal.h       |  4 ++--
 mm/mempolicy.c      | 26 ++++++++++++--------------
 mm/mprotect.c       |  7 +------
 6 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 77b5d450fe45b..40de653041f92 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3584,6 +3584,8 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
 #define  MM_CP_UFFD_RWP_RESOLVE            (1UL << 5) /* resolve rwp */
 #define  MM_CP_UFFD_RWP_ALL                (MM_CP_UFFD_RWP | \
 					    MM_CP_UFFD_RWP_RESOLVE)
+/* Whether a MM_CP_PROT_NUMA change is for promotion only */
+#define  MM_CP_PROT_NUMA_PROMO_ONLY        (1UL << 6)
 
 bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t pte);
@@ -4959,8 +4961,8 @@ static inline void vma_set_page_prot(struct vm_area_struct *vma)
 void vma_set_file(struct vm_area_struct *vma, struct file *file);
 
 #ifdef CONFIG_NUMA_BALANCING
-unsigned long change_prot_numa(struct vm_area_struct *vma,
-			unsigned long start, unsigned long end);
+unsigned long change_prot_numa(struct vm_area_struct *vma, unsigned long start,
+		unsigned long end, unsigned long cp_flags);
 #endif
 
 struct vm_area_struct *find_extend_vma_locked(struct mm_struct *,
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cfc982205b98c..5d3d7b61d0257 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4271,11 +4271,14 @@ static bool vma_is_accessed(struct mm_struct *mm, struct vm_area_struct *vma)
  */
 static void task_numa_work(struct callback_head *work)
 {
+	const unsigned int numab_mode = READ_ONCE(sysctl_numa_balancing_mode);
+	const bool balancing = numab_mode & NUMA_BALANCING_NORMAL;
 	unsigned long migrate, next_scan, now = jiffies;
 	struct task_struct *p = current;
 	struct mm_struct *mm = p->mm;
 	u64 runtime = p->se.sum_exec_runtime;
 	struct vm_area_struct *vma;
+	unsigned long cp_flags = MM_CP_PROT_NUMA;
 	unsigned long start, end;
 	unsigned long nr_pte_updates = 0;
 	long pages, virtpages;
@@ -4283,6 +4286,9 @@ static void task_numa_work(struct callback_head *work)
 	bool vma_pids_skipped;
 	bool vma_pids_forced = false;
 
+	if (!balancing)
+		cp_flags |= MM_CP_PROT_NUMA_PROMO_ONLY;
+
 	WARN_ON_ONCE(p != container_of(work, struct task_struct, numa_work));
 
 	work->next = work;
@@ -4459,7 +4465,8 @@ static void task_numa_work(struct callback_head *work)
 			start = max(start, vma->vm_start);
 			end = ALIGN(start + (pages << PAGE_SHIFT), HPAGE_SIZE);
 			end = min(end, vma->vm_end);
-			nr_pte_updates = change_prot_numa(vma, start, end);
+			nr_pte_updates = change_prot_numa(vma, start, end,
+							  cp_flags);
 
 			/*
 			 * Try to scan sysctl_numa_balancing_size worth of
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0d589be136d21..54ece00a457f8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2776,8 +2776,7 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		if (is_huge_zero_pmd(*pmd))
 			goto unlock;
 
-		if (!folio_can_map_prot_numa(pmd_folio(*pmd), vma,
-					     vma_is_single_threaded_private(vma)))
+		if (!folio_can_map_prot_numa(pmd_folio(*pmd), vma, cp_flags))
 			goto unlock;
 	}
 	/*
diff --git a/mm/internal.h b/mm/internal.h
index cd3675c044e0a..6e7c247781a16 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1256,11 +1256,11 @@ static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
 
 #ifdef CONFIG_NUMA_BALANCING
 bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
-		bool is_private_single_threaded);
+		unsigned long cp_flags);
 
 #else
 static inline bool folio_can_map_prot_numa(struct folio *folio,
-		struct vm_area_struct *vma, bool is_private_single_threaded)
+		struct vm_area_struct *vma, unsigned long cp_flags)
 {
 	return false;
 }
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index fb627b37afcbb..f0933e9b209c9 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -849,7 +849,7 @@ static int queue_folios_hugetlb(pte_t *pte, unsigned long hmask,
  * folio_can_map_prot_numa() - check whether the folio can map prot numa
  * @folio: The folio whose mapping considered for being made NUMA hintable
  * @vma: The VMA that the folio belongs to.
- * @is_private_single_threaded: Is this a single-threaded private VMA or not
+ * @cp_flags: Flags describing the protection change
  *
  * This function checks to see if the folio actually indicates that
  * we need to make the mapping one which causes a NUMA hinting fault,
@@ -859,7 +859,7 @@ static int queue_folios_hugetlb(pte_t *pte, unsigned long hmask,
  * Return: True if the mapping of the folio needs to be changed, false otherwise.
  */
 bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
-		bool is_private_single_threaded)
+		unsigned long cp_flags)
 {
 	int nid;
 
@@ -882,20 +882,16 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
 	if (folio_is_file_lru(folio) && folio_test_dirty(folio))
 		return false;
 
-	/*
-	 * Don't mess with PTEs if folio is already on the node
-	 * a single-threaded process is running on.
-	 */
 	nid = folio_nid(folio);
-	if (is_private_single_threaded && (nid == numa_node_id()))
+	/* Promotion-only scans do not mark top-tier folios. */
+	if ((cp_flags & MM_CP_PROT_NUMA_PROMO_ONLY) && node_is_toptier(nid))
 		return false;
 
 	/*
-	 * Skip scanning top tier node if normal numa
-	 * balancing is disabled
+	 * Don't mess with PTEs if folio is already on the node
+	 * a single-threaded process is running on.
 	 */
-	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
-	    node_is_toptier(nid))
+	if (vma_is_single_threaded_private(vma) && nid == numa_node_id())
 		return false;
 
 	if (folio_use_access_time(folio))
@@ -909,19 +905,21 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
  * These are later cleared by a NUMA hinting fault. Depending on these
  * faults, pages may be migrated for better NUMA placement.
  *
+ * @cp_flags carries the NUMA scan policy through the protection walk.
+ *
  * This is assuming that NUMA faults are handled using PROT_NONE. If
  * an architecture makes a different choice, it will need further
  * changes to the core.
  */
-unsigned long change_prot_numa(struct vm_area_struct *vma,
-			unsigned long addr, unsigned long end)
+unsigned long change_prot_numa(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long end, unsigned long cp_flags)
 {
 	struct mmu_gather tlb;
 	long nr_updated;
 
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 
-	nr_updated = change_protection(&tlb, vma, addr, end, MM_CP_PROT_NUMA);
+	nr_updated = change_protection(&tlb, vma, addr, end, cp_flags);
 	if (nr_updated > 0) {
 		count_vm_numa_events(NUMA_PTE_UPDATES, nr_updated);
 		count_memcg_events_mm(vma->vm_mm, NUMA_PTE_UPDATES, nr_updated);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index ef4e7188e24da..22049b265a289 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -335,7 +335,6 @@ static long change_pte_range(struct mmu_gather *tlb,
 	pte_t *pte, oldpte;
 	spinlock_t *ptl;
 	long pages = 0;
-	bool is_private_single_threaded;
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
 	bool uffd_rwp = cp_flags & MM_CP_UFFD_RWP;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
@@ -346,9 +345,6 @@ static long change_pte_range(struct mmu_gather *tlb,
 	if (!pte)
 		return -EAGAIN;
 
-	if (prot_numa)
-		is_private_single_threaded = vma_is_single_threaded_private(vma);
-
 	flush_tlb_batched_pending(vma->vm_mm);
 	lazy_mmu_mode_enable();
 	do {
@@ -383,8 +379,7 @@ static long change_pte_range(struct mmu_gather *tlb,
 			 * must set protnone regardless of NUMA placement.
 			 */
 			if (prot_numa &&
-			    !folio_can_map_prot_numa(folio, vma,
-						is_private_single_threaded)) {
+			    !folio_can_map_prot_numa(folio, vma, cp_flags)) {
 
 				/* determine batch to skip */
 				nr_ptes = mprotect_folio_pte_batch(folio,
-- 
2.53.0-Meta


