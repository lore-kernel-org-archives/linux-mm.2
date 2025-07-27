Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C07DC87FCC
	for <linux-mm@archiver.kernel.org>; Sun, 27 Jul 2025 20:18:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AD566B0095; Sun, 27 Jul 2025 16:18:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 685356B0096; Sun, 27 Jul 2025 16:18:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C2606B0098; Sun, 27 Jul 2025 16:18:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4BB706B0095
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 16:18:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1926E1A0C7C
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 20:18:26 +0000 (UTC)
X-FDA: 83711157012.01.AB9D4A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7D1DBA000C
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 20:18:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pwk10txZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753647504; a=rsa-sha256;
	cv=none;
	b=IZ66tNIJJkx+NODJrJmUGZoh9b22rPYBJ+/jIXaLn+ZSfRyzt5s7jvoqI+JKZ+ugVCf336
	pr6gHNg2yIGeAccWntq2rr6Q2DJSr248KLuSd+JxceNLaNlfJRTspnP3b5JZZAih89+OQU
	YIxVohm2jCpcGkrrlC6jNsYpraho99Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pwk10txZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753647504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mBXMTfXE2QrsFLNZuTsAF8CgUSErqMQWJDBOt2odzjo=;
	b=laeGXPCaYnUrA/uV+H/MTOpRhz0coT7bjQ5qRHGAZyIjfaPVHl+5G1R8Ku3f5XWxnWRtfc
	qJ/G9Osy19wVs2Oldfrwg+GDIuTL6a+EH5hbOJaQK2tfTLZa1XcZBtQuu4uu5kbGagEjkT
	ZchD8I65Hyih7eTb8+LEkCdOajgE02Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EF103601CF;
	Sun, 27 Jul 2025 20:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76AEDC4CEEF;
	Sun, 27 Jul 2025 20:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753647503;
	bh=WGQcM9UnLZgKBQqcVI81lbDDPjMMbRc1qGpPElDOEoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pwk10txZDLZxjPwQc1qT4zeUjOU9Po7GZs0gkYhI9apYTp89LeOs+ML2c2IstQ5oz
	 2oJxTDKqVp9sz5jghf6QByvyejV8Xt+Z3bGx2snEozm5e6JwbcsLsgEQrR6VUnAAgv
	 2UzrHdggs5IlMth+PJsPs5B9DKF3xHu5yj3PXxb8z+RnJvzPOAtBEarANZEJztZnPV
	 jL2UWDQ7NQuED2XQWMSzxZc/ERzdNYvafbVpQDyZgcy7r1pnHsXAf9OZz1QQmyAb4s
	 GnuxF99fxHci/Dh4AyWaio8GSn1u0150UlDt9NvZ/feTj/7XeQUPlyD975a2jXPdd1
	 7WWY3/E1wR5EA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Jann Horn <jannh@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC v2 5/7] mm/memory: implement MM_CP_DAMON
Date: Sun, 27 Jul 2025 13:18:11 -0700
Message-Id: <20250727201813.53858-6-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250727201813.53858-1-sj@kernel.org>
References: <20250727201813.53858-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7D1DBA000C
X-Stat-Signature: 5ix5h3shys1o1wzix4skuktbb1nwchfr
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753647504-301602
X-HE-Meta: U2FsdGVkX18n//aGzu7oSzrDVT+4EAlmvbUuyXqnety11ksCpLwHHOsOMRaevjQ8ju4q7eICe0s4t5Dud5opeyh7YRLieRTI83Xm8XkokoZwVcPkaK3VqRTSBVMh4qokHucT27B4f3JqaxTGv+CaCqd69ICKqfj3/P0WMnfmnceicGjUs19AkLO4HahuRobqW24xQvEpXKGVTRFirXUXyO819XopFaJmm9lUfzLmUwgZrqhnw0qpoMKrKgtslIZ5Y0AsuVFalIM1dYoPusqKYScxBACPskrm9XBC2Kj+ZVnGPXTNVqljkqQjyiAuNOIqMhjWR115IqO3RssNE/kdsJtsOS5mlVb+/WJyreqeGI36vgZzredtQqRBTQSM617BrsUcWCGnsb0bjWKyyxqhehWB67KmIcgPSydoTqyJfnu24KzYoadfHCzRiSYgrD5sOTE+NCkH9pbUV2gUqJHLLWEUw45wGBuHOFi4dCVAKs+LOthEQcGkaJgovFG8jsVPt+IZNhxQAx5kvfqQsMhzBw1D+I9q4tCnRYlFosdJQaNlXpXRZoErSAR5ndU7b5vN0/OMMxQZwMpNBD3s/H5kIKIGjChgeTxi5+gsAf6iIWR+0f8uqW2+C1JRxrNwhNUClH4Xq7GjMOvHra6kN2rMKQzie3ue+AmHQj+hbw0hkuKoI8jxDHcT3zYIlGEhkskpLvUaTzb9GeqgXo7IW3AEyvRbLxjZ+vmb7qTjfppDpjnGycMC7IHiRjL21lv3+2wNPzH/Gh7Hc4nUKXUTXKVwttbxxdlT/iBJTeYnxKbLd1PkADXkLCyK2v6DxTl9TArf/qVA67CKRFAtkAIyGUA8I3e0htg1Nzc3EalirzPLxF2hbZ4jrmUx8dYEpIDv26ECXch1JgeNPJKHm4Sdltvf9VB7TUFQNqyS3KKkQL5c11OcZEwS+FLdFxk2GzsApRemeOKiI3kJRBHQh5vFW1t
 5NzM1BwO
 mMFrBIkJnGzpi2aEMSvEw+jabK4NPayljVGnOhVTZR6kPlpoZ6/4+iYNAd8QgUVPmxH/V0QgJzE/4joRtWcf6bettOXkzqX+x3L++oBtM2Z72E11RN20TcBN/TsS7TCtYLnoye7aGHs9bVmsZDmkf+x3s2/uQs0fl+Zv7bSNj4ADN9U4cqjouNCog2huDQ3mjl64zatFtwsCAAqq9M/OlZCaQ0jmY9mLUKnvfzCdZ9slfEWMAn9tLIW0NuTUKOe/n6X0/vMYx1Ru4UNGLoBG5mu3rRptIfougHDjJycL+VhB/S9b/+6O8YcTSg0YHJFpMBlhQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON is using Accessed bits of page table entries as the major source
of the access information.  It lacks some additional information such as
which CPU was making the access.  Page faults could be another source of
information for such additional information.

Implement another change_protection() flag for such use case, namely
MM_CP_DAMON.  DAMON will install PAGE_NONE protections using the flag.
To avoid interfering with NUMA_BALANCING, which is also using PAGE_NON
protection, pass the faults to DAMON only when NUMA_BALANCING is
disabled.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/mm.h |  1 +
 mm/memory.c        | 53 ++++++++++++++++++++++++++++++++++++++++++++--
 mm/mprotect.c      |  5 +++++
 3 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 21270f1664a4..ad92b77bf782 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2567,6 +2567,7 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
 #define  MM_CP_UFFD_WP_RESOLVE             (1UL << 3) /* Resolve wp */
 #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
 					    MM_CP_UFFD_WP_RESOLVE)
+#define MM_CP_DAMON                        (1UL << 4)
 
 bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t pte);
diff --git a/mm/memory.c b/mm/memory.c
index 92fd18a5d8d1..656e610867b0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -75,6 +75,7 @@
 #include <linux/ptrace.h>
 #include <linux/vmalloc.h>
 #include <linux/sched/sysctl.h>
+#include <linux/damon.h>
 
 #include <trace/events/kmem.h>
 
@@ -5972,6 +5973,47 @@ static vm_fault_t wp_huge_pud(struct vm_fault *vmf, pud_t orig_pud)
 	return VM_FAULT_FALLBACK;
 }
 
+static vm_fault_t do_damon_page(struct vm_fault *vmf, bool huge_pmd)
+{
+	struct damon_access_report access_report = {
+		.addr = vmf->address,
+		.size = 1,
+	};
+	struct vm_area_struct *vma = vmf->vma;
+	struct folio *folio;
+	pte_t pte, old_pte;
+	bool writable = false, ignore_writable = false;
+	bool pte_write_upgrade = vma_wants_manual_pte_write_upgrade(vma);
+
+	if (huge_pmd)
+		access_report.addr = PFN_PHYS(pmd_pfn(vmf->orig_pmd));
+	else
+		access_report.addr = PFN_PHYS(pte_pfn(vmf->orig_pte));
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
+	damon_report_access(&access_report);
+	return 0;
+}
+
 /*
  * These routines also need to handle stuff like marking pages dirty
  * and/or accessed for architectures that don't do it in hardware (most
@@ -6036,8 +6078,11 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
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
@@ -6159,8 +6204,12 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 			return 0;
 		}
 		if (pmd_trans_huge(vmf.orig_pmd)) {
-			if (pmd_protnone(vmf.orig_pmd) && vma_is_accessible(vma))
+			if (pmd_protnone(vmf.orig_pmd) && vma_is_accessible(vma)) {
+				if (sysctl_numa_balancing_mode ==
+						NUMA_BALANCING_DISABLED)
+					return do_damon_page(&vmf, true);
 				return do_huge_pmd_numa_page(&vmf);
+			}
 
 			if ((flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) &&
 			    !pmd_write(vmf.orig_pmd)) {
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 78bded7acf79..e8a76114e4f9 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -714,6 +714,11 @@ long change_protection(struct mmu_gather *tlb,
 	WARN_ON_ONCE(cp_flags & MM_CP_PROT_NUMA);
 #endif
 
+#ifdef CONFIG_ARCH_SUPPORTS_NUMA_BALANCING
+	if (cp_flags & MM_CP_DAMON)
+		newprot = PAGE_NONE;
+#endif
+
 	if (is_vm_hugetlb_page(vma))
 		pages = hugetlb_change_protection(vma, start, end, newprot,
 						  cp_flags);
-- 
2.39.5

