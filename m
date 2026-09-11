Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25B34C88E41
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 00:18:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2C316B0093; Thu, 10 Sep 2026 20:18:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE33F6B0095; Thu, 10 Sep 2026 20:18:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C56746B0096; Thu, 10 Sep 2026 20:18:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7E3256B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 20:18:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8CC72120616
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:18:37 +0000 (UTC)
X-FDA: 85199570274.18.03F6CDF
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id C6B2F40008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:18:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XY8ZAFwH;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789085915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XlfoGyQgrNSRVIxWxP7qSy7UsF5M3AH+3KUxqb60W44=;
	b=yGIfAW5mUhnLj3nfcLJIyUigasVYaeXe8Bg02BPCGq5oUBjE6vSifFNUwXym+E4iuHMsGi
	cxEMOybEkoPBKLBtUzuHrQeSzOPmygUZVpD/aFg1vuw0gcF6liw2FWPJkHFo3U880FE2+5
	kdOoIw4N3Cw0r+xOwbzw5XDyfuBBLL4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XY8ZAFwH;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789085915;
	b=64x5eNXvU6UPcO8SZg6ansU+YWpuAkHFxf3MkicgBwU73Yu/6o9NuITMjVWdY+W8JPkiTF
	gu1vJicEjGKkjVGRK0IMDlC690uN1hPHo2ra0vbhKJ0TlBhfffyCdwh+BaqVaP8wGJnviS
	Lm1MwbIXfsdnB/bgqq48XpWEMzNKbEs=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-9309d4ea213so34380785a.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789085915; x=1789690715; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XlfoGyQgrNSRVIxWxP7qSy7UsF5M3AH+3KUxqb60W44=;
        b=XY8ZAFwHj4zb/gl5x90NcGp5/lJeI0XyvXCpLqtPpDoAIoP8348V4+oCT6wkwi+loE
         JoxarqRLF4eQnOvt/22yxUdtTdV51ZTQep0T5rurYae3VIDJjXFG0xf+FeaDrQs1mJyn
         zJJRVSa30Fxs0Qqc/RmxQYfz9ajXbPLSXsV15k+QeoUGH97Bos3xJ5U5gmqQAdpk7N40
         lcLOL1Vv3figubkHwpSx7dT2YyFgt4ZWbXCvL+cIFvvZrqexZP8275MjEYdS89AzIDZx
         nRr1dP/62utFoBHTalo5/v82LngXia56gcKipX+KFwv3AjQM7pVh0AKn0rXjuXDpkEzj
         EUnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789085915; x=1789690715;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XlfoGyQgrNSRVIxWxP7qSy7UsF5M3AH+3KUxqb60W44=;
        b=r8vCvGrF8YXMcxMm6nmi6Ui11kEjq2R7WkCqqV0JBJEbDowZ553OKBZx6uNmDZ4MYh
         2C3aLBuTH5/ASJpE9bXoD9/xrXICMyb5n6a796YKGNoLb3HdyXp8FEvTV6MMkuktRraC
         LQNjvhdYrHbchDJLS2LcNqCFx+6AVKDJHRxHOkejE+OUzdwMEAoVHLfYn3FFb1AJ6CLe
         1sO02FGoeiPQGo8FVfRD/mhdMgu4Hq4eOCSFKxBu3siKhmmJM5clvyUiF3T2rJF14GBA
         Q0pTWh36LoEL+ohjIO7Egk6OYus7h0z3k/C1vPOC3B1D/w2nZE503BpWkkzgN1JkNtgj
         93pA==
X-Gm-Message-State: AFuF++lpLI4ODtlb1r/FAXaCZe/NUgfoqq5DGYALq0wciO+NNFPI2wH3
	UIMFvnwyYMjTbQz8L0wSk7XzEmm6aeZcIunzyeouAJwiCcLVH8hFT8vJa1bGgLS4Y+53zqsNUtk
	paePh
X-Gm-Gg: AYBFou332a9aQERtYQibeWlN2zgprT6UDzU3ozBsgMHV8HztQr+SHXi8GFbmqf89MGY
	bYNPFxKhY6KYY6vojDsZ0jzpSnLY7f1aHCyuOv9osjktiyhFQd95CnghTl41UzGVnhr6eJd1If7
	yRiOzF7vXEbK7aw9drcfG90g8liy2LoQLl3tWe90AQADN7O0hM5tJjEa0+KqgOyFco2nCIOUdsm
	vkLnIXGbk+zBZeCn3EnmHvQdzcVa1QYvSj+mJfeeldt9rtadAjExfa9JTqbA8+mCB2c18z28k0d
	ximhDEfVMHeDWp09h1DehGBDap+Dyq+fnu8yJ3d1X3qkjpvUj2Wwz+vSjrsJve5EX6XzWGtv8vU
	IryOnhxE1xCm/CNZmABzEAH28BoAy4+6PTRzeD53ohXoTMvUyvUmE9oWZ4iTG4SwddxMbLS/z1A
	fNdio1KBH4BTH2Z1blY8iQnUPEZMB1NiQ4BEoTFrGzRboQEgYSfwqSuC7qKuCCxgmKQ7qdOKyEp
	mF/PGsb4IGjwsJthZBHxIkYTQWa7+RbJAOMsjs35UKEKsLTjcMXV55QM6M9yg==
X-Received: by 2002:a05:620a:2989:b0:939:7f2f:b17e with SMTP id af79cd13be357-939e9efcaf8mr205827185a.30.1789085914637;
        Thu, 10 Sep 2026 17:18:34 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e80e4c36sm108896485a.40.2026.09.10.17.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 17:18:34 -0700 (PDT)
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
	osalvador@suse.de,
	hannes@cmpxchg.org,
	raghavendra.kt@amd.com,
	stable@vger.kernel.org
Subject: [PATCH v2 1/4] mm: support promotion-only NUMA hinting scans
Date: Thu, 10 Sep 2026 20:18:23 -0400
Message-ID: <20260911001826.2109390-2-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911001826.2109390-1-gourry@gourry.net>
References: <20260911001826.2109390-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C6B2F40008
X-Stat-Signature: ycsxeqzga7593sawzijh395tygtex4nf
X-Rspam-User: 
X-HE-Tag: 1789085915-860028
X-HE-Meta: U2FsdGVkX18XrWS3xHfCfgq1FI4zP37pnblJmzBq5DILbSx4CDyWlDFztM1oBNmX3wphwI0TaC65akp+84mDygV+SVpDtgWqpKLF6LLw9RmGDyY3l8Iq8P0a77ddB4u8slxiBvwmnNQiQEoC3PKI8/AjN2DZf39CxXKmFvMlldaD6DtAek7ckk1RWsaZBuhNNrNo7fXyQNOvWVNpylNooV9pMnj5Ff+Yj+HPYV1kKJYhwBFBbnFH/ePZ1DENbEQ7xFhXrdGBW3sA0IjEeNidupZ7Gt4Ra81A+yen28v21t9a2x4xr3SK5xsoqgfZfv3/UAdlByxdXZj7wMd0yMbTcefIEWkwf5g4UDZfBSvvYezPOBC2XSnEGhLwy+NfNSxV1bM96DWY6lMbSBlwqaLdnrGkufIcn3awdrQ5QVq0jae+EYR45l+kwIsvbFHmzaCi1bHHhoGxlMCRPsGhkeYOPuD+riS2rY2g8bcE5obI9YOysdJPfacpER13RR0ekpEckYqErYxA2Pn1v8fz7PCLU4HJeNLtYZSChgGeYxs6DOIRS8Z8FMfQRzjBBvQjwlbDEZZPbj9aKfQCf031YR0iTwdWlxv/h1VOeaQq92rJMzWxjqVvmsP9dO0x4jZ4E3BmyAcFaWzjLaSQjT9WqnFAYqPwDwSwF1IiCunrouU08BZFi1N66KsVC2Ei5WN03fVBpBlSw5VK8M3CwRf9bMdNW+abJSkza32tefHk7M+NbwA5rhOPjSXHww0rVXzqniviQNWvrBRMPrm545dFVvQ1rzXHHeL7XuBQdo6HBH/IIYBBw2wFlwrOVSdToKAqgrSCofrr6ueMuIcm1kLorjNFEJSXLJlf95DtnY7JqPgU+Y8GyZXO7qt5LWtW1mu7m2SDJRmy6v+IKR/klV1TJhg3h2snBNSLpJ8anF6fVEnhek9HvD/UIGM5vML8T7Z3zIZRhxdseMntkv6FZs60Y6b
 XC+JJsSw
 znKIPDwaFzoOeFVZEBstZ4nuPYZYK0E555Afj5tHoSPLYbyDnzD/VZSuOGUh9909ZPjtadIMq80mz9MJZzs7ql5C8wUso4S/i0aUsCSoad4jNdqAhbSOAghxJasPuBYJEst7/TL4e+ZlPu31at9FlQW8mubmmBR3K64eLzCxIvGxF/Dar/cxRBlDcXpSz+KeEgj9MTaMVBdsn+O4F1ajvLDkOhtl/ZhZyKsGDKUJsu5ML2x5RBFcNILoK48iESeWAq2q8bLpl+6wUmhYGLQqcy7cTVzPZh/vHPNd4+HB5pthN/SlSddwKkAdh9Sm1KSN3HBoEmWQpwc/fBYNugk00t3l45WZkDPTZoQmrA7ByppV1PmxCOVFZ9BQdD+xvMr5hVjbOnPeMyIRasY7iEljnMrOp4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Gregory Price (Meta)" <gourry@gourry.net>

folio_can_map_prot_numa() derives the eligible memory from the global
balancing mode. Combined mode needs the scanner to distinguish placement
scans from promotion-only scans.

Add MM_CP_PROT_NUMA_PROMO_ONLY and let change_prot_numa() callers request
a promotion-only protection walk. Carry the choice with each walk so the
PTE and PMD paths use the same decision.

Initially derive the value from the normal balancing mode, preserving the
existing behavior for the following fixes.

Fixes: c574bbe91703 ("NUMA balancing: optimize page placement for memory tiering system")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/mm.h  |  4 +++-
 kernel/sched/fair.c |  7 ++++++-
 mm/huge_memory.c    |  3 ++-
 mm/internal.h       |  5 +++--
 mm/mempolicy.c      | 22 +++++++++++++---------
 mm/mprotect.c       |  4 +++-
 6 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 969594074fd2..2d1b59a27629 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3408,6 +3408,8 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
 #define  MM_CP_UFFD_RWP_RESOLVE            (1UL << 5) /* resolve rwp */
 #define  MM_CP_UFFD_RWP_ALL                (MM_CP_UFFD_RWP | \
 					    MM_CP_UFFD_RWP_RESOLVE)
+/* Whether a MM_CP_PROT_NUMA change is for promotion only */
+#define  MM_CP_PROT_NUMA_PROMO_ONLY        (1UL << 6)
 
 bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t pte);
@@ -4736,7 +4738,7 @@ void vma_set_file(struct vm_area_struct *vma, struct file *file);
 
 #ifdef CONFIG_NUMA_BALANCING
 unsigned long change_prot_numa(struct vm_area_struct *vma,
-			unsigned long start, unsigned long end);
+			unsigned long start, unsigned long end, bool promo_only);
 #endif
 
 struct vm_area_struct *find_extend_vma_locked(struct mm_struct *,
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8dff37059faf..81359b414947 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4129,8 +4129,10 @@ static void task_numa_work(struct callback_head *work)
 	unsigned long nr_pte_updates = 0;
 	long pages, virtpages;
 	struct vma_iterator vmi;
+	unsigned int numab_mode = READ_ONCE(sysctl_numa_balancing_mode);
 	bool vma_pids_skipped;
 	bool vma_pids_forced = false;
+	bool promo_only;
 
 	WARN_ON_ONCE(p != container_of(work, struct task_struct, numa_work));
 
@@ -4304,11 +4306,14 @@ static void task_numa_work(struct callback_head *work)
 			continue;
 		}
 
+		promo_only = !(numab_mode & NUMA_BALANCING_NORMAL);
+
 		do {
 			start = max(start, vma->vm_start);
 			end = ALIGN(start + (pages << PAGE_SHIFT), HPAGE_SIZE);
 			end = min(end, vma->vm_end);
-			nr_pte_updates = change_prot_numa(vma, start, end);
+			nr_pte_updates = change_prot_numa(vma, start, end,
+							  promo_only);
 
 			/*
 			 * Try to scan sysctl_numa_balancing_size worth of
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 30b7c63b0e35..2f9ada1bbcfc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2784,7 +2784,8 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			goto unlock;
 
 		if (!folio_can_map_prot_numa(pmd_folio(*pmd), vma,
-					     vma_is_single_threaded_private(vma)))
+					     vma_is_single_threaded_private(vma),
+					     cp_flags & MM_CP_PROT_NUMA_PROMO_ONLY))
 			goto unlock;
 	}
 	/*
diff --git a/mm/internal.h b/mm/internal.h
index 0dca33db068f..f3e093168f84 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1237,11 +1237,12 @@ static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
 
 #ifdef CONFIG_NUMA_BALANCING
 bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
-		bool is_private_single_threaded);
+		bool is_private_single_threaded, bool promo_only);
 
 #else
 static inline bool folio_can_map_prot_numa(struct folio *folio,
-		struct vm_area_struct *vma, bool is_private_single_threaded)
+		struct vm_area_struct *vma, bool is_private_single_threaded,
+		bool promo_only)
 {
 	return false;
 }
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 2ad0a5f18280..a082ccfa09ec 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -846,6 +846,7 @@ static int queue_folios_hugetlb(pte_t *pte, unsigned long hmask,
  * @folio: The folio whose mapping considered for being made NUMA hintable
  * @vma: The VMA that the folio belongs to.
  * @is_private_single_threaded: Is this a single-threaded private VMA or not
+ * @promo_only: Whether this scan should only collect promotion candidates
  *
  * This function checks to see if the folio actually indicates that
  * we need to make the mapping one which causes a NUMA hinting fault,
@@ -855,7 +856,7 @@ static int queue_folios_hugetlb(pte_t *pte, unsigned long hmask,
  * Return: True if the mapping of the folio needs to be changed, false otherwise.
  */
 bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
-		bool is_private_single_threaded)
+		bool is_private_single_threaded, bool promo_only)
 {
 	int nid;
 
@@ -886,12 +887,8 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
 	if (is_private_single_threaded && (nid == numa_node_id()))
 		return false;
 
-	/*
-	 * Skip scanning top tier node if normal numa
-	 * balancing is disabled
-	 */
-	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
-	    node_is_toptier(nid))
+	/* Promotion-only scans do not collect NUMA placement samples */
+	if (promo_only && node_is_toptier(nid))
 		return false;
 
 	if (folio_use_access_time(folio))
@@ -905,19 +902,26 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
  * These are later cleared by a NUMA hinting fault. Depending on these
  * faults, pages may be migrated for better NUMA placement.
  *
+ * With @promo_only only folios eligible for promotion are made
+ * hint-faultable, without also sampling for task placement.
+ *
  * This is assuming that NUMA faults are handled using PROT_NONE. If
  * an architecture makes a different choice, it will need further
  * changes to the core.
  */
 unsigned long change_prot_numa(struct vm_area_struct *vma,
-			unsigned long addr, unsigned long end)
+			unsigned long addr, unsigned long end, bool promo_only)
 {
+	unsigned long cp_flags = MM_CP_PROT_NUMA;
 	struct mmu_gather tlb;
 	long nr_updated;
 
+	if (promo_only)
+		cp_flags |= MM_CP_PROT_NUMA_PROMO_ONLY;
+
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 
-	nr_updated = change_protection(&tlb, vma, addr, end, MM_CP_PROT_NUMA);
+	nr_updated = change_protection(&tlb, vma, addr, end, cp_flags);
 	if (nr_updated > 0) {
 		count_vm_numa_events(NUMA_PTE_UPDATES, nr_updated);
 		count_memcg_events_mm(vma->vm_mm, NUMA_PTE_UPDATES, nr_updated);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 2888ee638d87..4e66e4c7665b 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -337,6 +337,7 @@ static long change_pte_range(struct mmu_gather *tlb,
 	long pages = 0;
 	bool is_private_single_threaded;
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
+	bool numa_promo_only = cp_flags & MM_CP_PROT_NUMA_PROMO_ONLY;
 	bool uffd_rwp = cp_flags & MM_CP_UFFD_RWP;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	int nr_ptes;
@@ -384,7 +385,8 @@ static long change_pte_range(struct mmu_gather *tlb,
 			 */
 			if (prot_numa &&
 			    !folio_can_map_prot_numa(folio, vma,
-						is_private_single_threaded)) {
+						is_private_single_threaded,
+						numa_promo_only)) {
 
 				/* determine batch to skip */
 				nr_ptes = mprotect_folio_pte_batch(folio,
-- 
2.55.0


