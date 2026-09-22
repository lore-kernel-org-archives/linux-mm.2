Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76E45C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 18:29:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3490B6B009B; Tue, 22 Sep 2026 14:29:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3217A6B009D; Tue, 22 Sep 2026 14:29:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 236CD6B009E; Tue, 22 Sep 2026 14:29:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E2E226B009B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:29:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F3B6160610
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:29:36 +0000 (UTC)
X-FDA: 85242236352.20.1E9DB80
Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6FE60140012
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:29:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mTHMsNFV;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790101774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I23ituCzWdUZNH9RRsiqmg7x+KgPhziEZ7cFA0c9iYo=;
	b=DWnUEQfRDcIdJpSP0vKcUPLdaNJxZBufvlgQVaHOkqlL9Alv7H2BXYRr1y0KotPjo4mBbo
	pmG3QIcI3MjAIKFXN6bbldoF7PKVTanT2m78MRJzjE/yxBVq2r3s6JDaajIDpnmO+m882g
	bJF+Hof4y7oL7b9rqNGisOcgurZ29o4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mTHMsNFV;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790101774;
	b=ByN+N4M+OZil2j2mOEeNcnn7x/teLP3wpon6Vj2cmcYvXItHTj8ruBbkYtS2CjQ7/6iRAE
	2sfYk/fv4kdII+wi+ArgjnYtpSyp2j9PgTvf+EokXjDBGwLAfTtDIed77D5jGw5o69nTEK
	X7cavyB8784jLhl30nP7ffk/vOTHx58=
Received: by mail-qk2-f43.google.com with SMTP id af79cd13be357-93910a0cefaso16811685a.2
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790101773; x=1790706573; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I23ituCzWdUZNH9RRsiqmg7x+KgPhziEZ7cFA0c9iYo=;
        b=mTHMsNFVEHYf3/BzIj5v5jcxDRiMZXNQTb3vC0QO9MiC0nti0c2AtYVI3HkELdjWRg
         ivqdeUd/UHUIjgb1PEKZO3cqohUT8ZmQ6pRpj0m1+HAwds6GyaiTZjsW5AExaBCtevy4
         a9WyXfkOvjwRkE4mC1DjudZVNLblNUXD0Cw36QCTEYq7TzpJpfIZ4vS3ohp2T9kJghGs
         pvpW6H/jYnUB1s8uSVaqN2xsmuaptBXpR3qyjuDKMLkXIDdtUWzBLpUaiT5E3pvvNx0r
         VvoSFh3fFU5iXvVO13nwT/3eUvPe7a9BQeEsnZ0qcKpFSlCkswbyGf284/KGWnNcnvNp
         KBkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790101773; x=1790706573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=I23ituCzWdUZNH9RRsiqmg7x+KgPhziEZ7cFA0c9iYo=;
        b=WQb/T1Z35AOBWG+YRtfYpINQyfBte4lYOXKIvmuTtkoyUBDlSKUiX2ZEXJ59zE2qyN
         BNEMgVMsFu62xaz14aampmP+3f8VP61/f4nke2oqVD7tBWUR951yEiY9nlEgu6xwRkHb
         vtOzFEEe1Qglw11zbuzwWn+Vw4A635wA8pIG2S0q5kY2ilymZtqQcNCmqrpu9pCOkF9q
         nvdzrDOKd5vDhJN2EF81I9I3//CxPDa+Pe0zhqfMx09LIBXtXUUZCQI2L4wuvDiNjZv5
         P/Eqk/O8QbcRdUnFE4mVN+jHHDyghzcC+Wxm2Xi10bUBXzXrJEMQ9Gu3oOsi22hZKqGf
         vEVA==
X-Gm-Message-State: AFuF++nQoQ8NBg+teKKrOXEVoNURnN+EyWxY1nnUU98GBoSedT35GlXO
	/kS0sHt622DOjhuKKTpOdhC1C5Hh4nj0LGSUPX1g8MPVKRfUDLL1IRPuA7X/S4S5O8eTyTtcfRy
	77pgx
X-Gm-Gg: AYBFou1uetZwJchbaBIEl+huz/yTY8sk11cIc30UGUFPgnugZ/TV3FBt4T6PoEgKKX9
	zRDh0iUdCQOSxcIuAh9a8GhqKDZvaZoReF8H/i8XZRx1xoHEFdx92LYT7cxNrh3gfL2LhXotYRr
	fNaqS6Cc30KRZtXKKOiedbnQ+/UwslJTM3qofAHuOuR/JGKiV9kXapt+0cf8D4IZ7zx0K5r8akG
	znPjcUD4crajUyoCLvaaqzPCzP63H8gAU+1e5evhvZTVChDgvkMtH9kSVwBvPghqsVx/tDlhasC
	3Ah/tSPP4rZjsdEEPbIh4Qm2xwhTHtvCLhm4kP6243URkSXeUQ/KI2Vj8QY142apzlpAkoXzzLD
	GSLMbPIRE6N/oizLdxYCHSC5OBpyH6KLKtH0rJD/8W4XYFIGqTMXXUKnKqAHMlSChKZzn52Z1T1
	/4T4L0PrREXJIZTnfZMDRqaxGCy1e87Rhor8NZ7itJ+xFjQ3+uw6Dv737J9hW+ebiCkBioV4UVM
	wuanyUClT5/26bA7i7YC0rvh0SB+H73dnnZMPTjHtIT7kMKrALdhhB0oesu
X-Received: by 2002:a05:620a:31a4:b0:93a:2e8:5afa with SMTP id af79cd13be357-93c2514141amr37871485a.30.1790101773423;
        Tue, 22 Sep 2026 11:29:33 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c24889ac9sm37130085a.27.2026.09.22.11.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 11:29:33 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
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
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
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
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	hannes@cmpxchg.org,
	shy828301@gmail.com,
	raghavendra.kt@amd.com,
	stable@vger.kernel.org
Subject: [PATCH v3 1/7] mm: support promotion-only NUMA hinting scans
Date: Tue, 22 Sep 2026 14:29:22 -0400
Message-ID: <20260922182928.2199090-2-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922182928.2199090-1-gourry@gourry.net>
References: <20260922182928.2199090-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6FE60140012
X-Rspam-User: 
X-Stat-Signature: e7mnwmdwx7zcbur7rmguxg9b1ninf88j
X-HE-Tag: 1790101774-507580
X-HE-Meta: U2FsdGVkX1+xI9bPzocZnGlB0vDmiDKVj8hCw2pIDpX8yLqe7eu54QY9IPN4+W+DW0Nzh1FjmXYLNJZM8XBSgRjh7TaQODwMT1mWhnQT1q5LnwWnuMzk+KDpPtiZoX3IygEozybx8LR0uHk1aPay5q9LHggFQCguPG/vF9gPpUwAhA6TXTEzhjiqpyh437VeslRFbK6ssYWbVajh5WzTJuGt7fn+0er4cU1lRt8UmqZAM3OR3ZCJ3MYNpiJXO1zOrOTrUI0yLkM3YjjR/8cifP2qc1el9kua8R4lHBtWD53n5ZCcebQ0Ej55O0XXZXxZBTN30Ktvpt0Iy2x3mRJJ7D0IkxvPy3JxdeHojjCJH2qv1z2LOKCNuktyfpRZWgz5o1POg75J7oYibnOrnoxzYgzbzIUfpYf+jd1qzpGeV7CbZd6nJ5ZU6v5K3/KjcqHZjHRVlESe+egLVpune+r4rg/Tx+M6bXiO1KuI62syhEu+Mk6at7MyGl2DIw1iH9ijxu81msNpYxD9h3tkeEO69AS9DmhgS4oKJrbl72/uaRi8BBS2XcuJtmgjd+2VVMlJgdyVZyxp3DwtuolSx0Ub4PaKC/jd7VTSbtGVZWC200hOn5i3ZFzYsrKKcsZTAf/0VMFBIk7q4OffXJrEun1jZ+h1X6D9rO4c3y9OM3DXtrpGk8jl7FBL5mcPKDAWgv37mkgtu19QtjiaAG4Hox3Puq/MJMzLmLhfpxRBCZgJqRa+JCVt46Q2LYDKI8HTMV8cApco9QW/SSOcbxnffaFDEeETC/KvwWQsSZZXZsTEZQI5olIhOPrTfE1GXGs02EIISl2tzi4MMcKBWmPsjsp7PsKVv257zw6GMHOgsNAVZhyuu2R+oO1KgXaOG7V8wn2Kg2garTEoprE6wtGnLrwGCm3+x6MwlcPD+FpD4CR2oX3/LCIZVxHuuEQm5DfeBlhJnEigjtOOkEsDgi6t1Oo
 HBR/82eR
 kfmqsb5vy9ojexQXA+ddoSK0Wjb9VC3EbiTYG1iTf4tHatwEBSr2EPqFLRcpVJfpYCraBKhGAhA66W+CZGI0sCBMxkk37vHWsanEur95olIa+YmNfKan7y3Af2OzgLzyJTeiiUtOALO0HPnUCuzNz1j8nRtjiSmvX93EVKOdH90TlMEmutjOhJ1DrkLgvdH+zKx4+p182gto6bj2jdCPNL8tEPuM6uAXy2Exj2/ldSEY3WGf17oV/bvv2g7L7ySIVrhaHUmhyDErM74wE+CqJJqy8Oag0sIxgM3MsRLPv8096ALOILfflBevc/Xja1w7soLqmD/ufSgiH5F8GO4lLXxtnNRAtvc1wyltGbK3s5ZlR+NbCHHiTWUFFRgmUE9LRluSCBho0fmJvd1Veegl3qQyWQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Gregory Price (Meta)" <gourry@gourry.net>

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
   becomes active.  Applying it in tiering modes causes

 - Opting Read-only file VMAs out of scanning is just incorrect for
   tiering modes because its intent is to prevent bouncing between
   sockets (east-west), while tiering controls tier migration
   (north-south).  The result is hot read-only files can overload
   lower tier bandwidth.

Add MM_CP_PROT_NUMA_PROMO_ONLY and let task_numa_work() select the type
of walk. Build the change-protection flags there and pass them unchanged
through change_prot_numa() so its PTE/PMD paths use the same decision.

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
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/mm.h  |  6 ++++--
 kernel/sched/fair.c |  7 ++++++-
 mm/huge_memory.c    |  3 +--
 mm/internal.h       |  4 ++--
 mm/mempolicy.c      | 27 ++++++++++++---------------
 mm/mprotect.c       |  7 +------
 6 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index e3d29f87567f8..beab621e6f88d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3608,6 +3608,8 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
 #define  MM_CP_UFFD_RWP_RESOLVE            (1UL << 5) /* resolve rwp */
 #define  MM_CP_UFFD_RWP_ALL                (MM_CP_UFFD_RWP | \
 					    MM_CP_UFFD_RWP_RESOLVE)
+/* Whether a MM_CP_PROT_NUMA change is for promotion only */
+#define  MM_CP_PROT_NUMA_PROMO_ONLY        (1UL << 6)
 
 bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t pte);
@@ -4980,8 +4982,8 @@ static inline void vma_set_page_prot(struct vm_area_struct *vma)
 void vma_set_file(struct vm_area_struct *vma, struct file *file);
 
 #ifdef CONFIG_NUMA_BALANCING
-unsigned long change_prot_numa(struct vm_area_struct *vma,
-			unsigned long start, unsigned long end);
+unsigned long change_prot_numa(struct vm_area_struct *vma, unsigned long start,
+		unsigned long end, unsigned long cp_flags);
 #endif
 
 struct vm_area_struct *find_extend_vma_locked(struct mm_struct *,
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ae6c1a606eb5d..9f544e3df9490 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4124,6 +4124,7 @@ static void task_numa_work(struct callback_head *work)
 	struct mm_struct *mm = p->mm;
 	u64 runtime = p->se.sum_exec_runtime;
 	struct vm_area_struct *vma;
+	unsigned long cp_flags = MM_CP_PROT_NUMA;
 	unsigned long start, end;
 	unsigned long nr_pte_updates = 0;
 	long pages, virtpages;
@@ -4131,6 +4132,9 @@ static void task_numa_work(struct callback_head *work)
 	bool vma_pids_skipped;
 	bool vma_pids_forced = false;
 
+	if (!(READ_ONCE(sysctl_numa_balancing_mode) & NUMA_BALANCING_NORMAL))
+		cp_flags |= MM_CP_PROT_NUMA_PROMO_ONLY;
+
 	WARN_ON_ONCE(p != container_of(work, struct task_struct, numa_work));
 
 	work->next = work;
@@ -4307,7 +4311,8 @@ static void task_numa_work(struct callback_head *work)
 			start = max(start, vma->vm_start);
 			end = ALIGN(start + (pages << PAGE_SHIFT), HPAGE_SIZE);
 			end = min(end, vma->vm_end);
-			nr_pte_updates = change_prot_numa(vma, start, end);
+			nr_pte_updates = change_prot_numa(vma, start, end,
+							  cp_flags);
 
 			/*
 			 * Try to scan sysctl_numa_balancing_size worth of
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 493b29cabee59..da9cf87903a55 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2769,8 +2769,7 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		if (is_huge_zero_pmd(*pmd))
 			goto unlock;
 
-		if (!folio_can_map_prot_numa(pmd_folio(*pmd), vma,
-					     vma_is_single_threaded_private(vma)))
+		if (!folio_can_map_prot_numa(pmd_folio(*pmd), vma, cp_flags))
 			goto unlock;
 	}
 	/*
diff --git a/mm/internal.h b/mm/internal.h
index 0434dfcfc36f1..cbeaf1fc38cfc 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1248,11 +1248,11 @@ static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
 
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
index 4c0b8ff1a7e66..1427e1b6213b6 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -847,7 +847,7 @@ static int queue_folios_hugetlb(pte_t *pte, unsigned long hmask,
  * folio_can_map_prot_numa() - check whether the folio can map prot numa
  * @folio: The folio whose mapping considered for being made NUMA hintable
  * @vma: The VMA that the folio belongs to.
- * @is_private_single_threaded: Is this a single-threaded private VMA or not
+ * @cp_flags: Flags describing the protection change
  *
  * This function checks to see if the folio actually indicates that
  * we need to make the mapping one which causes a NUMA hinting fault,
@@ -857,7 +857,7 @@ static int queue_folios_hugetlb(pte_t *pte, unsigned long hmask,
  * Return: True if the mapping of the folio needs to be changed, false otherwise.
  */
 bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
-		bool is_private_single_threaded)
+		unsigned long cp_flags)
 {
 	int nid;
 
@@ -880,22 +880,17 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
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
-
 	if (folio_use_access_time(folio))
 		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
 
@@ -907,19 +902,21 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
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
index e59c69cb5a238..7a247ed4cd55f 100644
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


