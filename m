Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63ED9606A8BF
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 16:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=OR/O0ICL
Received: by kanga.kvack.org (Postfix)
	id 4B2AD6B05BC; Fri, 13 Nov 2026 11:26:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 462FF6B05BF; Fri, 13 Nov 2026 11:26:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 351AA6B05C0; Fri, 13 Nov 2026 11:26:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F4AA6B05BC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:26:01 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0CD66120277
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:25:59 +0000 (UTC)
X-FDA: 85430622438.04.0363873
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf08.hostedemail.com (Postfix) with ESMTP id CF51C16000B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:25:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="OR/O0ICL";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of matthew.auld@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=matthew.auld@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794587157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XfjhOT0S45aDpDQ6n0GeU9QRl5ZXQ95JDVE3b3sWMao=;
	b=y2nomnjUB+NG/6Z1r+TvIIfeHlUS8g37Gy4sHmx0W0i6HT1y7ztWLmM5l0ucpyzjQQr/bc
	nzkEReZbqTMUjKi0qKvqZ2HtxwXSFYIhijJ8XwTac1E2Ds41nZnV8zs0YdMbHu2kF2R6fJ
	wysSO/Vnih+rXkU6ibbUR2/2A02GQrE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="OR/O0ICL";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of matthew.auld@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=matthew.auld@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794587157;
	b=0yWGc82dTcP4Wp3uTl6/vkcQoALNrcvGkvQ6eXiLB5X4DhpkG3uN2QA0n9pz0io/YU6mMJ
	jQEU30PQn34CCLLnGx0eEl3Bh1iuhJwH4oCpidpM/BgI2MfuFlbSuTv7oymkx4DfJphjwI
	c8F/sHA/2WRcJXrifzS8mmFosn+jkTo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794587156; x=1826123156;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UPBL6CYZiOLgk3Wya2d7czaTmGhGsvKoKKlBggwDPwo=;
  b=OR/O0ICLKx6v9eiJtcG37xHdz1rlWdsE51t1L90JohlNPSm/BCGb4nZJ
   V2oA0j1kGA3zFaYcj91mobehq6nKRzbtPg/GLH8qwXzvcQa4vgAyzQcZJ
   rcZXldlxYnH/3S0LKuDRESxpXXFyt8VHqXU1gqYgyC2sAR3hh+kbyf1uV
   sg75tRh1gWzrnaGQc1X8ZutpuQsYynkDUMgQj30Vn9Q43G53vylG3Iult
   xfPT66wHRxIMxXrQs0FroDQFdJSGSWmtiqAQs223jtlJl7lFeKNQ7iunr
   pLcjpm2Wbnih1lNLwiKaJB7DaIvJbVUTmN/XZcrPBuzjezTOUoloUZQbR
   Q==;
X-CSE-ConnectionGUID: ZeEhT2ujQLeunbQky3iZmQ==
X-CSE-MsgGUID: pD3UgmpXTwi2zut2Bg6fww==
X-IronPort-AV: E=McAfee;i="6800,10657,11965"; a="3382644"
X-IronPort-AV: E=Sophos;i="6.27,212,1787036400"; 
   d="scan'208";a="3382644"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 08:25:55 -0800
X-CSE-ConnectionGUID: rCG2ULUiRKW+rzFItF/tyA==
X-CSE-MsgGUID: pDXxuM1DTTmAqROBanmyjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,212,1787036400"; 
   d="scan'208";a="9226402"
Received: from ncintean-mobl1.ger.corp.intel.com (HELO mwauld-desk.intel.com) ([10.245.244.186])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 08:25:53 -0800
From: Matthew Auld <matthew.auld@intel.com>
To: linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	David Hildenbrand <david@kernel.org>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH] mm/hmm: skip NUMA balancing on protnone faults
Date: Fri, 13 Nov 2026 16:25:22 +0000
Message-ID: <20261112-numa-v1-1-ad9cbca8f49a@intel.com>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Change-ID: 20261112-numa-3649f4bf57c9
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CF51C16000B
X-Stat-Signature: y71ochr8qouhcfo69hdnt4rqzmnrcyr1
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794587155-52128
X-HE-Meta: U2FsdGVkX18sbXeHWu/lHjUgZnYbT+ZEz//FTQjaB4INRmytUHz0QzA5Rng9Rl2CtFjMgXiAtJXgXapoNeezwg7xh8buz8TNN8w5JDb9MrOrEeQLhLX1Z0eSZ9WkEtpygYDwdE2CTz5Mkgo+UbfMDBwZBeetzCp5isHpNOm8T0YlBrznU4cS8KzAy37aCZRXIVkIqLNu3ErYguHozNvPoFMBvEcvuD+PD36Q6a8FqjvL3mnUbNPMmePtOkKVNkhuqV21efn/JFiVsdPZMeClmTRiD3G6SdVRObOBUOs1ndGENtYPHBQXYsElKRtWjdniroRCIjXQlayotcbQILrAsZsk7jLsPpSgUjROXsvNb+xNqIXkbl0MTEzCHubTPf/SX9NsbOVOJSjb5XtCmaVaSs4ZLAGcllLi5b2vd535MrjdhYegZT0R3LzwXw1Yncc1OPjgG7VcEqz/bDqdXLypE/6PLiKwdlyjieBOwpIjucZYUXXRfL3K4jDUUPTJ1BIhXpRWYaYJ1PRo1VIobkW6EaSuyhC/mVLeU6MQQBtGfTJxwDcS8CLHEQ86L1d2zG0OUwKQLQYW14DV1QLI6NEWeytZ7STx69hpsm4FG4dc2faE/VfMOy0lqe5UfP6+Kac5lcTZn+E/01Tvx8HIIa9kf/GC/LfgQGj7V5ad6JtjBPV+Vu0spmeyFE2HJg/IS1g1AjLnIXTeKC7GDki1tINcrSqw5gaIsIGRPU4xWGR8j6Jvvb0dH+aZJ4t8oIoMXbYr6s/+YiVi43YtwUGH3EM6TS8ffxL0NujyTHyI2lAeA673sU4+vIRVMCnmcOgGD0mNFHfm2fc1UBXHeV0I5OuxD6B02eFLT7NnYD4ok3Vwx7k7cHAaPdw/fAo4gVgiwfvYzd82DihqbOkIswfNOtr2b7p6nT/uhF/rfMG7rqnQJye0jdXFfSgRgcGyVOCagnZ0AqIRjPLUHi9Zas7JqtD
 ZP9lZPxD
 Ut3LrCGKJsnLj+xZU+GDjoL/xaFSUzVxnIbZg7wzNvn76vOIEOTSky0hNkfSBr1J2ASsyqe49AU9vs57qSG9wBb/sFHiWHAMwK97sJnOu3TVJf6Uk+B2O3I/Xft+MXApk1renU8G9+ceTu3B+J0BH8M5cwZrLKFA5pxzIR2EOMalOAtZGSFDIFeQwZtPBbo8p+3bkwqnYJnggXZ6CqgzfMI+lQLsLulQ7DvzbYNhBF/KtKHNwI8CP8MP/zFhIwUeeuzut+hEwggSSC8PcGRqLv8oI3DouI371cmbrvAoIqitm7O4EfnW/KnOQQjD8tqaUN+YV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When automatic NUMA balancing marks a PTE or PMD as protnone
(PAGE_NONE), hmm_pte_need_fault() requests a fault to restore access
permissions, including _PAGE_RW when write access is needed.

Calling handle_mm_fault() from hmm_do_fault() currently triggers NUMA
balancing in do_numa_page() and do_huge_pmd_numa_page(). When
hmm_range_fault() runs from a device driver or kworker context (such as
a GPU SVM or userptr rebind worker), folios get migrated toward the CPU
node executing the remote fault.

Also, each folio migration invokes try_to_migrate_one() ->
mmu_notifier_invalidate_range_start(), which invalidates the
caller's mmu_interval_notifier while holding mmap_lock. That causes
hmm_range_fault() to abort with -EBUSY after every 2 MiB PMD and exhaust
its retry timeout on large buffers, which has been observed with large
imported Xe userptr buffers.

Add FAULT_FLAG_NO_NUMA and set it in hmm_do_fault() so protnone entries
restore PTE/PMD permissions in-place without performing NUMA balancing,
matching GUP's default !FOLL_HONOR_NUMA_FAULT behaviour.

Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
---
 include/linux/mm.h       | 3 ++-
 include/linux/mm_types.h | 3 +++
 mm/hmm.c                 | 2 +-
 mm/huge_memory.c         | 3 +++
 mm/memory.c              | 3 +++
 5 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 77b5d450fe45..4b6ad3c0b591 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -717,7 +717,8 @@ static inline bool fault_flag_allow_retry_first(enum fault_flag flags)
 	{ FAULT_FLAG_REMOTE,		"REMOTE" }, \
 	{ FAULT_FLAG_INSTRUCTION,	"INSTRUCTION" }, \
 	{ FAULT_FLAG_INTERRUPTIBLE,	"INTERRUPTIBLE" }, \
-	{ FAULT_FLAG_VMA_LOCK,		"VMA_LOCK" }
+	{ FAULT_FLAG_VMA_LOCK,		"VMA_LOCK" }, \
+	{ FAULT_FLAG_NO_NUMA,		"NO_NUMA" }
 
 /*
  * vm_fault is filled by the pagefault handler and passed to the vma's
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 1ed35d258d2e..2ea71c1bb170 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1819,6 +1819,8 @@ enum tlb_flush_reason {
  * @FAULT_FLAG_ORIG_PTE_VALID: whether the fault has vmf->orig_pte cached.
  *                        We should only access orig_pte if this flag set.
  * @FAULT_FLAG_VMA_LOCK: The fault is handled under VMA lock.
+ * @FAULT_FLAG_NO_NUMA: Do not perform NUMA balancing migration or NUMA
+ *                      task access accounting on protnone faults.
  *
  * About @FAULT_FLAG_ALLOW_RETRY and @FAULT_FLAG_TRIED: we can specify
  * whether we would allow page faults to retry by specifying these two
@@ -1857,6 +1859,7 @@ enum fault_flag {
 	FAULT_FLAG_UNSHARE =		1 << 10,
 	FAULT_FLAG_ORIG_PTE_VALID =	1 << 11,
 	FAULT_FLAG_VMA_LOCK =		1 << 12,
+	FAULT_FLAG_NO_NUMA =		1 << 13,
 };
 
 typedef unsigned int __bitwise zap_flags_t;
diff --git a/mm/hmm.c b/mm/hmm.c
index 2f1e98c6b644..62cdeb071781 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -648,7 +648,7 @@ static int hmm_do_fault(struct mm_struct *mm,
 	unsigned long addr = hmm_vma_walk->last;
 	unsigned long end = hmm_vma_walk->end;
 	unsigned int required_fault = hmm_vma_walk->required_fault;
-	unsigned int fault_flags = FAULT_FLAG_REMOTE;
+	unsigned int fault_flags = FAULT_FLAG_REMOTE | FAULT_FLAG_NO_NUMA;
 	struct vm_area_struct *vma;
 
 	if (hmm_vma_walk->locked)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0d589be136d2..ea380bf45df0 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2361,6 +2361,9 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 	if (!folio)
 		goto out_map;
 
+	if (vmf->flags & FAULT_FLAG_NO_NUMA)
+		goto out_map;
+
 	nid = folio_nid(folio);
 
 	target_nid = numa_migrate_check(folio, vmf, haddr, &flags, writable,
diff --git a/mm/memory.c b/mm/memory.c
index fe72e66c9c2e..53c819a6e49a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6404,6 +6404,9 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
 	if (!folio || folio_is_zone_device(folio))
 		goto out_map;
 
+	if (vmf->flags & FAULT_FLAG_NO_NUMA)
+		goto out_map;
+
 	nid = folio_nid(folio);
 	nr_pages = folio_nr_pages(folio);
 

---
base-commit: 4318887a3efa4c53d6f083ccfd7105b809a3ac65
change-id: 20261112-numa-3649f4bf57c9

