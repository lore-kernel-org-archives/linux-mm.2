Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8958BC624D2
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 08:49:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E79E16B00AE; Sun, 22 Feb 2026 03:49:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFAB06B00B0; Sun, 22 Feb 2026 03:49:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDBA16B00B1; Sun, 22 Feb 2026 03:49:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B693D6B00AE
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:49:55 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7D08159D19
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:55 +0000 (UTC)
X-FDA: 84471469950.10.C645183
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id A025540006
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iwy07F+u;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771750192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0FaS5B9cAZ3FLbrF/E2Ph8lRS4c3BU4jWIQ83JN7l+U=;
	b=WyJChW6Imf0TNBqM4z55ku+aW0vN1qnqmyAJXkWrzR4EhBkbPVV+tlX8uqf0Me2njL317H
	2n3bdPQ+2oEendbd5t/rHgqDiMUX6Jrt1WcGmTrjVDj7e25qQNLyg8/Gp5uYmWzBJsobhD
	844A0BnxZTlXYFJebDcLZzcJamea/Go=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iwy07F+u;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771750192; a=rsa-sha256;
	cv=none;
	b=J5bQl1yomks3CmlYxjZoNS7O84Nmw6kSQjWDPk18pfqCipogK/8oT/CGYe1sA3W8Lv0kUR
	giHQCELBQ9y6ZhVguaYMjL4jnmbxlfbGlJfozxP1T5rjx10OT2KDnIbxQx4w0RSc5pEFFE
	MENC0/XStnCdFS6W+ocBstTmhpQOO+E=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5062fc5d86aso33210021cf.1
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771750192; x=1772354992; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0FaS5B9cAZ3FLbrF/E2Ph8lRS4c3BU4jWIQ83JN7l+U=;
        b=iwy07F+uwimXQVFBNtdrbCLtf8IIe5E16lZigHFjn7fgdDFp89wUaaKNWfiarudhtw
         bgrDvwlH9r7uAM1yjFr5Hgv0t7qRRAcbUZ21zZdkPdoMOOEzNPdQEjNfSHrTWx8Y6Zb/
         Ryi895oS+UMMwZfhmBXO1N8ydI61pR3tf2mQsS8rbd6YzqmTLP4Kq35YEtpnwGntU/wQ
         p1XINmsU5KFc8QRdi0yBLqxIFzMJnoPuzoFCRH9cMPNNjCa7FZ7maOZaYHAZkRvUaTbO
         JcUxw/0pZtpPk0dQdLVUkXrw4idbqXscEzKvseho8WMtZ6s9VkQ2+maHSXU/ePD2zr9Q
         TE1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771750192; x=1772354992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0FaS5B9cAZ3FLbrF/E2Ph8lRS4c3BU4jWIQ83JN7l+U=;
        b=dd+DSyz34YWBfBQguLHC09jwyQkygDwQVD9VmpaUi9F+kZgi+9bDnrlchrmzHvX1j0
         Z/ay2iOb6flSrJwvMxIK7lXuupAl7js/CBkNdqHtWzIktw4psx3FJeoJTodXX7Zl+qh+
         +BHZtBGxcSuLyhHFZ0ZdFlHAhlzuPtwkhshjieC2VxeP2N5X7rTm8H4MTpa98dL5C4Uj
         XUD5TGfrBfJmaPVFsL/79nzv5bhJVk5POQKi2AW086jkQ9cvZekggz/VEJK8nv88KphT
         9cBmBqKbQulLkruN9r7p7VV83LyE+FB7giS6Uv3hOvWe7zhh6HA1Q3XSkGYFu1y1BjQD
         Lrfw==
X-Forwarded-Encrypted: i=1; AJvYcCW15A7DB8hvFBN0yqdXbaiUyPXELdWgRvSCRgB+y0FKwjCFY0BVZoxYf/Yu+Hwi3b6xCcv2ytOW7A==@kvack.org
X-Gm-Message-State: AOJu0YxxoGtbKM9JL+r+HDLaWonzOu8KWFw3IsNSBultixzqmnR4yQjO
	6HY4x8bnufG66AJj2D33fwjObkGFB7yElF7PQQEiqPuZvxZWOJTc/YgjfSLWdBhdhpE=
X-Gm-Gg: AZuq6aKi7qbR5eOxU0wnUbVXLa92GZMe2dqjy/yqBSvNUaS9BeF+/7a4vY8lPWaQ8ym
	4eGDTzxrTPtZ80uZ2IRwxNjNfoT82Ah2txYVE5cXT6bzevY9ZMqOn2daO0TX3W3JkwjqVmZ8i+5
	3e2W/2idEJAmqI+CU4dX+stfRgYMIb52lkHWax1zQC+Q7AkxE6kK1+T6Dbosuo5/bK8itSshlKM
	mNJo8uyu0N9PDAuYABS5pSoemsdiF5DCunb9pn6lWut+Nb+u7FHSCA+t+W1ibuWk7TkltDMf/cO
	cXCUby2f6WyKz3wA1FOYnvS2y+qwgMwlLbe4kwLKILwdVSZm86TmMi3k88Eqde21YROYACEtxZI
	i+XiunIGC/WRjDP2DWzsXcobB4HpRBUbWq0adJTsYuEYbaemLQPZDmLHfCEoZ1p+VoRs3S8cPnW
	RUWxoNbh3lIw7OxKQdXAE9sXu4HNgX6BkLW+kh6gnRb2wddT/jmZsiINMlTAftFLJqNbA/ipdrU
	RBY3nlVd/iXZkU=
X-Received: by 2002:a05:622a:19a1:b0:4ff:c04c:3d75 with SMTP id d75a77b69052e-5070bc4b9ddmr74426531cf.43.1771750191585;
        Sun, 22 Feb 2026 00:49:51 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d53f0fcsm38640631cf.9.2026.02.22.00.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 00:49:51 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	jackmanb@google.com,
	sj@kernel.org,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	jannh@google.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	pfalcato@suse.de,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	harry.yoo@oracle.com,
	cl@gentwo.org,
	roman.gushchin@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	zhengqi.arch@bytedance.com,
	terry.bowman@amd.com
Subject: [RFC PATCH v4 15/27] mm/mprotect: NP_OPS_PROTECT_WRITE - gate PTE/PMD write-upgrades
Date: Sun, 22 Feb 2026 03:48:30 -0500
Message-ID: <20260222084842.1824063-16-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
References: <20260222084842.1824063-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A025540006
X-Rspamd-Server: rspam02
X-Stat-Signature: d3oyofaeepkc67etrk47jc4wyc3swmwc
X-HE-Tag: 1771750192-131964
X-HE-Meta: U2FsdGVkX1/U7bkRcLtgywu/VF4DjOY9h+wnBBuvK8NeT6TQu1HXM7u51F8aKuMSTIXhaCwANHJ1KW2D/fHctFkAbQ/Ahsa4Ox1iGefD3thgBst4YirbRbi4z26+tSKmDnU1gVNSXc3NMRYdIjOTkxPq8iYajNAMo32y2ay0xGCpWcdsd/Upbzxxvri2euE/vFBN8QOAPEV2WBLc3d23v8QMZ1jHStlDmHDQ1SgmVXqosc9bhL/NNJ7U5Y3I4g5+xWD2S/wiUu4XsRuO5BqRMKXoWIA2drEoJEHFIHuqshFvEyw2Kjd0uZZs3SliHLIl5c8zpmoEN9Fw3hxpUkMlWCP0yRoWvbMaMeLd4btOWcl/hjPL/tJoO3NZ1M+ShKWGuS+ceDQq6fDR4BwSN8qTfS1/jlAap+ZpHGx2+REv9VPWVY7qhsSJv8ZuLmPhDegmp9LtQm3gaWT+yyNVWlRrgBzgBhdyCbkJ2b9o1oDydgd8beWt6mfP3ElXhwwsQ1/gPDqlKks7t56T7KAG4eN4VWzppsP66gNfkILBBgwwR/1c+g5Z64jtF8uNApniyjAYUAQSoOlkLVvur0OqPmt+qTzNCOytjDxtP4nnOYESL4FjIBhb+2gZIXaYpjX2wkTvsqE2nhnHmEaxvcjosPPEN/9iVq/qgaSNQ7d9q7fVcQOxY4arH7mI/ETp7f6uiGODlwX9M6Eptpu9lNgLmz3z2dYr2SNZrGN9m2p9/vSeeB+t97w+Ov3eM1gq8FQxMz8XTM0LsbJMKQLEqhSHRiVtS5sPx1yRs0/6aVVSIq5pkROQOx8bcCL5p6Gmx4X4knAnrUYU5wb6eVMouTGaDE+n/JA8P+TPn/11ncWoePukVA3H5IAjQbpmD1Hrog0CaY5UON2nONAZKDKCmY+t4S8eMHbKADb0GP9vJWGrTAHAZO5KhWKuSPDB5uk9FNc1DSA3KY63rWY41gK7b8nPGGx
 eW6pzbo7
 TdK3Fz5FisnMqJk54+ztVa+ngv8YliSD3LIIy1SubdHUfKLz20he6r8mHBBnsXL4WrMTzO/5kYnPr+sHKhc3bEy0S2pncc+9FueDclxjJEBM684YXxX1VyAT2WwANBBl2TiskdAeBCZrNbxmezqFINY+yGUTjHmFyb3p7r/1q4bz0GcBDsdZzBv659kzQ9HDHN6GOSKpdeLdeorLd70FIy8IA7aJTTtO1uXFbhahORideIwDKvAtJ4Ns/UH6SCKQDYYfl8b5EQBrIqzXpWFaj3XARsWukNLZUqUZSfFNcKdk8lb5MZAIhIHY5H638gIGHbw7R8kf4tKJSNX7ffRcYeYEfcqz5h53LeRjrVLknrcTyIH2LQyn1Vz+ioefDG+akOHbXn9ZTPdB/SLX1oifajT5K8VRMSzTtCRbYPJRvV5XtZyE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Services that intercept write faults (e.g., for promotion tracking)
need PTEs to stay read-only. This requires preventing mprotect
from silently upgrade the PTE, bypassing the service's handle_fault
callback.

Add NP_OPS_PROTECT_WRITE and folio_managed_wrprotect().

In change_pte_range() and change_huge_pmd(), suppress PTE write-upgrade
when MM_CP_TRY_CHANGE_WRITABLE is sees the folio is write-protected.

In handle_pte_fault() and do_huge_pmd_wp_page(), dispatch to the node's
ops->handle_fault callback when set, allowing the service to handle write
faults with promotion or other custom logic.

NP_OPS_MEMPOLICY is incompatible with NP_OPS_PROTECT_WRITE to avoid the
footgun of binding a writable VMA to a write-protected node.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/base/node.c          |  4 ++
 include/linux/node_private.h | 22 ++++++++
 mm/huge_memory.c             | 17 ++++++-
 mm/internal.h                | 99 ++++++++++++++++++++++++++++++++++++
 mm/memory.c                  | 15 ++++++
 mm/migrate.c                 | 14 +----
 mm/mprotect.c                |  4 +-
 7 files changed, 159 insertions(+), 16 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index c08b5a948779..a4955b9b5b93 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -957,6 +957,10 @@ int node_private_set_ops(int nid, const struct node_private_ops *ops)
 	    !(ops->flags & NP_OPS_MIGRATION))
 		return -EINVAL;
 
+	if ((ops->flags & NP_OPS_MEMPOLICY) &&
+	    (ops->flags & NP_OPS_PROTECT_WRITE))
+		return -EINVAL;
+
 	mutex_lock(&node_private_lock);
 	np = rcu_dereference_protected(NODE_DATA(nid)->node_private,
 				       lockdep_is_held(&node_private_lock));
diff --git a/include/linux/node_private.h b/include/linux/node_private.h
index e254e36056cd..27d6e5d84e61 100644
--- a/include/linux/node_private.h
+++ b/include/linux/node_private.h
@@ -70,6 +70,24 @@ struct vm_fault;
  *     PFN-based metadata (compression tables, device page tables, DMA
  *     mappings, etc.) before any access through the page tables.
  *
+ * @handle_fault: Handle fault on folio on this private node.
+ *   [folio-referenced callback, PTL held on entry]
+ *
+ *   Called from handle_pte_fault() (PTE level) or do_huge_pmd_wp_page()
+ *   (PMD level) after lock acquisition and entry verification.
+ *   @folio is the faulting folio, @level indicates the page table level.
+ *
+ *   For PGTABLE_LEVEL_PTE: vmf->pte is mapped and vmf->ptl is the
+ *   PTE lock.  Release via pte_unmap_unlock(vmf->pte, vmf->ptl).
+ *
+ *   For PGTABLE_LEVEL_PMD: vmf->pte is NULL and vmf->ptl is the
+ *   PMD lock.  Release via spin_unlock(vmf->ptl).
+ *
+ *   The callback MUST release PTL on ALL paths.
+ *   The caller will NOT touch the page table entry after this returns.
+ *
+ *   Returns: vm_fault_t result (0, VM_FAULT_RETRY, etc.)
+ *
  * @flags: Operation exclusion flags (NP_OPS_* constants).
  *
  */
@@ -81,6 +99,8 @@ struct node_private_ops {
 				  enum migrate_reason reason,
 				  unsigned int *nr_succeeded);
 	void (*folio_migrate)(struct folio *src, struct folio *dst);
+	vm_fault_t (*handle_fault)(struct folio *folio, struct vm_fault *vmf,
+				   enum pgtable_level level);
 	unsigned long flags;
 };
 
@@ -90,6 +110,8 @@ struct node_private_ops {
 #define NP_OPS_MEMPOLICY		BIT(1)
 /* Node participates as a demotion target in memory-tiers */
 #define NP_OPS_DEMOTION			BIT(2)
+/* Prevent mprotect/NUMA from upgrading PTEs to writable on this node */
+#define NP_OPS_PROTECT_WRITE		BIT(3)
 
 /**
  * struct node_private - Per-node container for N_MEMORY_PRIVATE nodes
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2ecae494291a..d9ba6593244d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2063,12 +2063,14 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf)
 	struct page *page;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 	pmd_t orig_pmd = vmf->orig_pmd;
+	vm_fault_t ret;
+
 
 	vmf->ptl = pmd_lockptr(vma->vm_mm, vmf->pmd);
 	VM_BUG_ON_VMA(!vma->anon_vma, vma);
 
 	if (is_huge_zero_pmd(orig_pmd)) {
-		vm_fault_t ret = do_huge_zero_wp_pmd(vmf);
+		ret = do_huge_zero_wp_pmd(vmf);
 
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
@@ -2088,6 +2090,13 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf)
 	folio = page_folio(page);
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 
+	/* Private-managed write-protect: let the service handle the fault */
+	if (unlikely(folio_is_private_managed(folio))) {
+		if (folio_managed_handle_fault(folio, vmf,
+					      PGTABLE_LEVEL_PMD, &ret))
+			return ret;
+	}
+
 	/* Early check when only holding the PT lock. */
 	if (PageAnonExclusive(page))
 		goto reuse;
@@ -2633,7 +2642,8 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 	/* See change_pte_range(). */
 	if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) && !pmd_write(entry) &&
-	    can_change_pmd_writable(vma, addr, entry))
+	    can_change_pmd_writable(vma, addr, entry) &&
+	    !folio_managed_wrprotect(pmd_folio(entry)))
 		entry = pmd_mkwrite(entry, vma);
 
 	ret = HPAGE_PMD_NR;
@@ -4943,6 +4953,9 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 	if (folio_test_dirty(folio) && softleaf_is_migration_dirty(entry))
 		pmde = pmd_mkdirty(pmde);
 
+	if (folio_managed_wrprotect(folio))
+		pmde = pmd_wrprotect(pmde);
+
 	if (folio_is_device_private(folio)) {
 		swp_entry_t entry;
 
diff --git a/mm/internal.h b/mm/internal.h
index 5950e20d4023..ae4ff86e8dc6 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -11,6 +11,7 @@
 #include <linux/khugepaged.h>
 #include <linux/mm.h>
 #include <linux/mm_inline.h>
+#include <linux/node_private.h>
 #include <linux/pagemap.h>
 #include <linux/pagewalk.h>
 #include <linux/rmap.h>
@@ -18,6 +19,7 @@
 #include <linux/leafops.h>
 #include <linux/swap_cgroup.h>
 #include <linux/tracepoint-defs.h>
+#include <linux/node_private.h>
 
 /* Internal core VMA manipulation functions. */
 #include "vma.h"
@@ -1449,6 +1451,103 @@ static inline bool folio_managed_on_free(struct folio *folio)
 	return false;
 }
 
+/*
+ * folio_managed_handle_fault - Dispatch fault on managed-memory folio
+ * @folio: the faulting folio (must not be NULL)
+ * @vmf: the vm_fault descriptor (PTL held: vmf->ptl locked)
+ * @level: page table level (PGTABLE_LEVEL_PTE or PGTABLE_LEVEL_PMD)
+ * @ret: output fault result if handled
+ *
+ * Called with PTL held.  If a handle_fault callback exists, it is invoked
+ * with PTL still held.  The callback is responsible for releasing PTL on
+ * all paths.
+ *
+ * Returns true if the service handled the fault (PTL released by callback,
+ * caller returns *ret).  Returns false if no handler exists (PTL still held,
+ * caller continues with normal fault handling).
+ */
+static inline bool folio_managed_handle_fault(struct folio *folio,
+					      struct vm_fault *vmf,
+					      enum pgtable_level level,
+					      vm_fault_t *ret)
+{
+	/* Zone device pages use swap entries; handled in do_swap_page */
+	if (folio_is_zone_device(folio))
+		return false;
+
+	if (folio_is_private_node(folio)) {
+		const struct node_private_ops *ops =
+			folio_node_private_ops(folio);
+
+		if (ops && ops->handle_fault) {
+			*ret = ops->handle_fault(folio, vmf, level);
+			return true;
+		}
+	}
+	return false;
+}
+
+/**
+ * folio_managed_wrprotect - Should this folio's mappings stay write-protected?
+ * @folio: the folio to check
+ *
+ * Returns true if the folio is on a private node with NP_OPS_PROTECT_WRITE,
+ * meaning page table entries (PTE or PMD) should not be made writable.
+ * Write faults are intercepted by the service's handle_fault callback
+ * to promote the folio to DRAM.
+ *
+ * Used by:
+ *   - change_pte_range() / change_huge_pmd(): prevent mprotect write-upgrade
+ *   - remove_migration_pte() / remove_migration_pmd(): strip write after migration
+ *   - do_huge_pmd_wp_page(): dispatch to fault handler instead of reuse
+ */
+static inline bool folio_managed_wrprotect(struct folio *folio)
+{
+	return unlikely(folio_is_private_node(folio) &&
+			folio_private_flags(folio, NP_OPS_PROTECT_WRITE));
+}
+
+/**
+ * folio_managed_fixup_migration_pte - Fixup PTE after migration for
+ *                                     managed memory pages.
+ * @new: the destination page
+ * @pte: the PTE being installed (normal PTE built by caller)
+ * @old_pte: the original PTE (before migration, for swap entry flags)
+ * @vma: the VMA
+ *
+ * For MEMORY_DEVICE_PRIVATE pages: replaces the PTE with a device-private
+ * swap entry, preserving soft_dirty and uffd_wp from old_pte.
+ *
+ * For N_MEMORY_PRIVATE pages with NP_OPS_PROTECT_WRITE: strips the write
+ * bit so the next write triggers the fault handler for promotion.
+ *
+ * For normal pages: returns pte unmodified.
+ */
+static inline pte_t folio_managed_fixup_migration_pte(struct page *new,
+						      pte_t pte,
+						      pte_t old_pte,
+						      struct vm_area_struct *vma)
+{
+	if (unlikely(is_device_private_page(new))) {
+		softleaf_t entry;
+
+		if (pte_write(pte))
+			entry = make_writable_device_private_entry(
+						page_to_pfn(new));
+		else
+			entry = make_readable_device_private_entry(
+						page_to_pfn(new));
+		pte = softleaf_to_pte(entry);
+		if (pte_swp_soft_dirty(old_pte))
+			pte = pte_swp_mksoft_dirty(pte);
+		if (pte_swp_uffd_wp(old_pte))
+			pte = pte_swp_mkuffd_wp(pte);
+	} else if (folio_managed_wrprotect(page_folio(new))) {
+		pte = pte_wrprotect(pte);
+	}
+	return pte;
+}
+
 /**
  * folio_managed_migrate_notify - Notify service that a folio changed location
  * @src: the old folio (about to be freed)
diff --git a/mm/memory.c b/mm/memory.c
index 2a55edc48a65..0f78988befef 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6079,6 +6079,10 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
 	 * Make it present again, depending on how arch implements
 	 * non-accessible ptes, some can allow access by kernel mode.
 	 */
+	if (unlikely(folio && folio_managed_wrprotect(folio))) {
+		writable = false;
+		ignore_writable = true;
+	}
 	if (folio && folio_test_large(folio))
 		numa_rebuild_large_mapping(vmf, vma, folio, pte, ignore_writable,
 					   pte_write_upgrade);
@@ -6228,6 +6232,7 @@ static void fix_spurious_fault(struct vm_fault *vmf,
  */
 static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
 {
+	struct folio *folio;
 	pte_t entry;
 
 	if (unlikely(pmd_none(*vmf->pmd))) {
@@ -6284,6 +6289,16 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
 		update_mmu_tlb(vmf->vma, vmf->address, vmf->pte);
 		goto unlock;
 	}
+
+	folio = vm_normal_folio(vmf->vma, vmf->address, entry);
+	if (unlikely(folio && folio_is_private_managed(folio))) {
+		vm_fault_t fault_ret;
+
+		if (folio_managed_handle_fault(folio, vmf, PGTABLE_LEVEL_PTE,
+					       &fault_ret))
+			return fault_ret;
+	}
+
 	if (vmf->flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) {
 		if (!pte_write(entry))
 			return do_wp_page(vmf);
diff --git a/mm/migrate.c b/mm/migrate.c
index a54d4af04df3..f632e8b03504 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -398,19 +398,7 @@ static bool remove_migration_pte(struct folio *folio,
 		if (folio_test_anon(folio) && !softleaf_is_migration_read(entry))
 			rmap_flags |= RMAP_EXCLUSIVE;
 
-		if (unlikely(is_device_private_page(new))) {
-			if (pte_write(pte))
-				entry = make_writable_device_private_entry(
-							page_to_pfn(new));
-			else
-				entry = make_readable_device_private_entry(
-							page_to_pfn(new));
-			pte = softleaf_to_pte(entry);
-			if (pte_swp_soft_dirty(old_pte))
-				pte = pte_swp_mksoft_dirty(pte);
-			if (pte_swp_uffd_wp(old_pte))
-				pte = pte_swp_mkuffd_wp(pte);
-		}
+		pte = folio_managed_fixup_migration_pte(new, pte, old_pte, vma);
 
 #ifdef CONFIG_HUGETLB_PAGE
 		if (folio_test_hugetlb(folio)) {
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 283889e4f1ce..830be609bc24 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -30,6 +30,7 @@
 #include <linux/mm_inline.h>
 #include <linux/pgtable.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/node_private.h>
 #include <uapi/linux/mman.h>
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
@@ -290,7 +291,8 @@ static long change_pte_range(struct mmu_gather *tlb,
 			 * COW or special handling is required.
 			 */
 			if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) &&
-			     !pte_write(ptent))
+			     !pte_write(ptent) &&
+			     !(folio && folio_managed_wrprotect(folio)))
 				set_write_prot_commit_flush_ptes(vma, folio, page,
 				addr, pte, oldpte, ptent, nr_ptes, tlb);
 			else
-- 
2.53.0


