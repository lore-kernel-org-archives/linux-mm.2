Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B00AD3B7E1
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 275F26B000D; Mon,  8 Dec 2025 01:30:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FEF96B000E; Mon,  8 Dec 2025 01:30:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13D6E6B0010; Mon,  8 Dec 2025 01:30:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E8C786B000D
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:29:59 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8813E1A0980
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:29:59 +0000 (UTC)
X-FDA: 84195328518.15.FCD7036
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id D6AD6A000C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:29:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rrkKJurf;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yfS+BlhQJqeO7lgzc5qntPtm8788Expbnrlic/Caw6k=;
	b=WxknOQ6rpstmz7eg82sB1Vqhw9M2Il/Cvkps7P7nUTkyrFklCOQ4XG5PnAiCs8jLg39v6P
	UIA9jcYu95aEMOMS4/Yl0FFd9p07CmLvPe/HwtZqVx+8zb71wePIq5wkmYspuAoYqe2H71
	OFhG6iyLwMK/MhRzUh/yUCMvybM5l34=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175398; a=rsa-sha256;
	cv=none;
	b=npfP6hcl/BeprtsQ4AD4S5Ey6byRyeO1yFnBTJ7nVcX4fKMVFliI9EvDqMtVUi4OgadCGF
	/w/RMj07f+lEn5M6ZdOYUkbsZF0aJgKKUshU4tQmsrOC2nGNuzmZ8XCn2LWek8BoK1HFvB
	N8HNbw3KzKaLBFayIexVmzaFfEhPvEU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rrkKJurf;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C501444B1;
	Mon,  8 Dec 2025 06:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35AEC19424;
	Mon,  8 Dec 2025 06:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175396;
	bh=IsAQBy+/F0THMv/6pxlb7dlCDTvmO/F43GY/84Lx7Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrkKJurf/ekHLTqr3oXC4YqVnKygVWt0HJT+83gq/Sz7EFTeS1jr0l3zZ3x3TwyZh
	 uRswznSYSjtlgylkCypij/Ca+pKIB1LnH8V2t5o8RUaD+dlzdGd0OYo08Ek9z5f3dT
	 R1HLsTu7RvLf2loccy9ldM0/g9rnq8W30RR2OV/3lg0Gq61og2650e77nJqi8EBgMK
	 04/1zCu7TbWB1cErBqV1C3ZFWqnYOt1J0upc/zfA0B53yngOk1KwXdH+pfIszva00f
	 ETh14f5tGl6dakWTIosb3VkJlpnfEiXyFUSpK3CbHj87TKWd4cPyWgK/WjoT06T/2W
	 UbEDolHGhNslg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jann Horn <jannh@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 05/37] mm/{mprotect,memory}: (no upstream-aimed hack) implement MM_CP_DAMON
Date: Sun,  7 Dec 2025 22:29:09 -0800
Message-ID: <20251208062943.68824-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D6AD6A000C
X-Stat-Signature: exdk8eyhuex6fk58ibfwzne8wmrs7pej
X-Rspam-User: 
X-HE-Tag: 1765175397-299375
X-HE-Meta: U2FsdGVkX19ct6fG4jfy2M+YkBs5jx4FLTXLaBs7KTh0xAjDdFRseKgFl3RvJga17jT0n2Y09etIL+HEm0WH/JgSyqjfRJJgmQX0rr8diEDQ0ZNSNzIep+LaXEengIAH0kGX42HloLEYupMCugzWnbBTkkGoCJAXzG4GISTiGjU/GCNHeufXY4Z9BlJ9zSh2x6R6iUbXd8R6TjUwPQpMd1WbHe75TeATT8P2+sm13rY1VzIgAMzN95S9xtCEug+Vu7c36swAQapJH7A3WTxWH0+Ol1DuaqLNKIR8OIuKJItzOmtKRQ7Ikl9U58PDZv9YKt0RoM8CP9kWxmVSGqE4PC6pp9mIGNIMtOI9r4UVb5wkcRH110UlcrGo5PN1LrU9Jxx0uh2jU0FxvmaeLN4YUQnQ6hv/G/foB/U+RLoLmbao/QvRt7qPqTbT9DgUAsWUFq1u5umhWyEzbwz5mq9U6maXbY7AmrCeIBM9Qv5LsWVtq2FsBPA0g13GWOKPSY6cLF1Lv5F4qosQLBpn5BGlqty8huuzemSgSYvePuskln+Z0ZiCvKWoFaRTpPDwEy2vG75PGBdQjI4SbVb+2dqfS74QPYnxIzeE6hSXswX0zW78i5GYawFLcyHeo5rjMfwkUAbUmW802p5ctvH2jOU1mFMJrR3bZOZbGh3JgBT5pKnMNMukJvxp6nu48l+7iVIWUZBlpiw74U/gEpodEhcmtvQn5AcW3GU0hxQzaQKd0uK34+RwtIufJCxhHHrcE+wVw9MTmUir6oNGZy9Gs1noRCSsZPKww9b0ZhWKUfTZiBUt9C2Hl47VcfN4IFw/EbojDUE/2zFvmaWKerDpkNrm/5Xje8MnbFST+w0jB/iqbzvd+6EnM9SjKWfFzWFANxSMtr1ObI+dcxw4a2dAoQ5fi3ww142eaW8qU3tEpZQxIgDcJRqEYRDsND9w3BDgPKgkSMaerccO1zvMEudwoI/
 4IZf3NVH
 6m+8fFIaW1l6ogo0rmJrGSEpyfmffLDYoiDIn627f2EPz3TfoLYgXx0vICvVJ6ChOo8HhkzFTJ+I5YnDiuKO6GHKff7TNA9Ujlsx5Xg92Z9pMMoQmU7Yzi1egqmL3s9xiOrspBHfvNknyzqCuQpcrgdcoBLK5CCT3kJ6nuEXWhcui9tjSlfBVWX6h9Q+60IxtAR/nmYk/Useqw8Zx0+OxKt+Rf10acK+jO/9QhE/2H2O4Gr541UzbRLsD/0MaJ7czUFggPEqzeRcbQMXIoGv6bbbWTxhRNZr7QU34DaRAo25plP7V8JvFpFsnvQua74Pi4c5b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Note that this is not upstreamable as-is.  This is only for helping
discussion of other changes of its series.

DAMON is using Accessed bits of page table entries as the major source
of the access information.  It lacks some additional information such as
which CPU was making the access.  Page faults could be another source of
information for such additional information.

Implement another change_protection() flag for such use cases, namely
MM_CP_DAMON.  DAMON will install PAGE_NONE protections using the flag.
To avoid interfering with NUMA_BALANCING, which is also using PAGE_NON
protection, pass the faults to DAMON only when NUMA_BALANCING is
disabled.

Again, this is not upstreamable as-is.  There were comments about this
on the previous version, and I was unable to take time on addressing
those.  As a result, this version is not addressing any of those
previous comments.  I'm sending this, though, to help discussions on
patches of its series, except this one.  Please forgive me adding this
to your inbox without addressing your comments, and ignore.  I will
establish another discussion for this part later.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/mm.h |  1 +
 mm/memory.c        | 60 ++++++++++++++++++++++++++++++++++++++++++++--
 mm/mprotect.c      |  5 ++++
 3 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 553cf9f438f1..2cba5a0196da 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2848,6 +2848,7 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
 #define  MM_CP_UFFD_WP_RESOLVE             (1UL << 3) /* Resolve wp */
 #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
 					    MM_CP_UFFD_WP_RESOLVE)
+#define MM_CP_DAMON                        (1UL << 4)
 
 bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t pte);
diff --git a/mm/memory.c b/mm/memory.c
index 6675e87eb7dd..5dc85adb1e59 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -78,6 +78,7 @@
 #include <linux/sched/sysctl.h>
 #include <linux/pgalloc.h>
 #include <linux/uaccess.h>
+#include <linux/damon.h>
 
 #include <trace/events/kmem.h>
 
@@ -6172,6 +6173,54 @@ static vm_fault_t wp_huge_pud(struct vm_fault *vmf, pud_t orig_pud)
 	return VM_FAULT_FALLBACK;
 }
 
+/*
+ * NOTE: This is only poc purpose "hack" that will not be upstreamed as is.
+ * More discussions between all stakeholders including maintainers of MM core,
+ * NUMA balancing, and DAMON should be made to make this upstreamable.
+ * (https://lore.kernel.org/20251128193947.80866-1-sj@kernel.org)
+ *
+ * This function is called from page fault handler, for page faults on
+ * P{TE,MD}-protected but vma-accessible pages.  DAMON is making the fake
+ * protection for access sampling purpose.  This function simply clear the
+ * protection and report this access to DAMON, by calling
+ * damon_report_page_fault().
+ *
+ * The protection clear code is copied from NUMA fault handling code for PTE.
+ * Again, this is only poc purpose "hack" to show what information DAMON want
+ * from page fault events, rather than an upstream-aimed version.
+ */
+static vm_fault_t do_damon_page(struct vm_fault *vmf, bool huge_pmd)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct folio *folio;
+	pte_t pte, old_pte;
+	bool writable = false, ignore_writable = false;
+	bool pte_write_upgrade = vma_wants_manual_pte_write_upgrade(vma);
+
+	spin_lock(vmf->ptl);
+	old_pte = ptep_get(vmf->pte);
+	if (unlikely(!pte_same(old_pte, vmf->orig_pte))) {
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		return 0;
+	}
+	pte = pte_modify(old_pte, vma->vm_page_prot);
+	writable = pte_write(pte);
+	if (!writable && pte_write_upgrade &&
+			can_change_pte_writable(vma, vmf->address, pte))
+		writable = true;
+	folio = vm_normal_folio(vma, vmf->address, pte);
+	if (folio && folio_test_large(folio))
+		numa_rebuild_large_mapping(vmf, vma, folio, pte,
+				ignore_writable, pte_write_upgrade);
+	else
+		numa_rebuild_single_mapping(vmf, vma, vmf->address, vmf->pte,
+				writable);
+	pte_unmap_unlock(vmf->pte, vmf->ptl);
+
+	damon_report_page_fault(vmf, huge_pmd);
+	return 0;
+}
+
 /*
  * These routines also need to handle stuff like marking pages dirty
  * and/or accessed for architectures that don't do it in hardware (most
@@ -6236,8 +6285,11 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
 	if (!pte_present(vmf->orig_pte))
 		return do_swap_page(vmf);
 
-	if (pte_protnone(vmf->orig_pte) && vma_is_accessible(vmf->vma))
+	if (pte_protnone(vmf->orig_pte) && vma_is_accessible(vmf->vma)) {
+		if (sysctl_numa_balancing_mode == NUMA_BALANCING_DISABLED)
+			return do_damon_page(vmf, false);
 		return do_numa_page(vmf);
+	}
 
 	spin_lock(vmf->ptl);
 	entry = vmf->orig_pte;
@@ -6363,8 +6415,12 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 		return 0;
 	}
 	if (pmd_trans_huge(vmf.orig_pmd)) {
-		if (pmd_protnone(vmf.orig_pmd) && vma_is_accessible(vma))
+		if (pmd_protnone(vmf.orig_pmd) && vma_is_accessible(vma)) {
+			if (sysctl_numa_balancing_mode ==
+					NUMA_BALANCING_DISABLED)
+				return do_damon_page(&vmf, true);
 			return do_huge_pmd_numa_page(&vmf);
+		}
 
 		if ((flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) &&
 		    !pmd_write(vmf.orig_pmd)) {
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 5c330e817129..d2c14162f93d 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -651,6 +651,11 @@ long change_protection(struct mmu_gather *tlb,
 	WARN_ON_ONCE(cp_flags & MM_CP_PROT_NUMA);
 #endif
 
+#ifdef CONFIG_ARCH_SUPPORTS_NUMA_BALANCING
+	if (cp_flags & MM_CP_DAMON)
+		newprot = PAGE_NONE;
+#endif
+
 	if (is_vm_hugetlb_page(vma))
 		pages = hugetlb_change_protection(tlb, vma, start, end, newprot,
 						  cp_flags);
-- 
2.47.3

