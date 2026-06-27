Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0B2AC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 07:27:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 810F56B00B5; Sat, 27 Jun 2026 03:27:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C1346B00B6; Sat, 27 Jun 2026 03:27:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B0126B00B7; Sat, 27 Jun 2026 03:27:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BCFF6B00B5
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 03:27:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 97E678FB2E
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:27:54 +0000 (UTC)
X-FDA: 84924863268.06.F479E31
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id DD05E140002
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:27:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sZYiqigO;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782545273;
	b=5Vpl+tNv3gCW1/wX7v7R9yCL9YQlOVPJac7Nl1D+cYUcBofcxqRo2hPnpsug7rRcjmeFgg
	rYnHrF/6JehaoL5709YFfR9AMtKEc/Zh75W/gvkR56xrYl7TQP5Y4Uc6MBxHbY8khWm+SQ
	YARYsnQ99d/kPRDjMkiAktv6DPxkBAI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782545273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UHtddMQ5l0jeR9cQaglj+dt/LUSWNwvctZzH2qSyB+Q=;
	b=hDZAPt5TDiSFmYr6/JPErHkdpuhdD4BsiJkNp30li0HnI+y5yUaEet1JPgXiCTPJ7t4pEt
	pX0zFsFvZROpJee//0eZ+a2byuaQoAjLkSpn/wgu7RBO1ItR2k3h8eY+46jTG/N7LooAlf
	OVh6KlD//YIvn8B1C5tJtVX8L4VEWnA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sZYiqigO;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782545271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UHtddMQ5l0jeR9cQaglj+dt/LUSWNwvctZzH2qSyB+Q=;
	b=sZYiqigO9EwhkQ5du7srmFAf5h2ae2Zn2Ebs0oijiGc5OKyDV5d1eTnyVsfbKv/UcWsZTn
	btt13StpGnqiQcqJyMzweISfjMmIprN7jNccluQaCDQFP3AcXn8qxgRPtznuLAGgRrfQQy
	mwTEXBS40yF2dg9kmJWsnj+72G0V9YM=
From: Qi Zheng <qi.zheng@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	osalvador@suse.de,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	peterx@redhat.com,
	usama.arif@linux.dev,
	willy@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [RFC PATCH 6/8] mm: maintain reserved THP quota across VMA changes
Date: Sat, 27 Jun 2026 15:26:42 +0800
Message-ID: <2380a4ba5805017917715994c6d49e7cbf5de27a.1782538002.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1782538002.git.zhengqi.arch@bytedance.com>
References: <cover.1782538002.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: qmyq3jrzp8wh8bz13g3p4o8ec8okmijp
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DD05E140002
X-HE-Tag: 1782545272-720074
X-HE-Meta: U2FsdGVkX1+dF/fWtc9Zqv5idMyVGraZF20gFcwkFyPOiXKKSFLODYmGtJm5NMxpw0Dxdc6dWbj+gsxo6CSpNYQZm0Qvji/jOVM7lL0MNYv66HqkihJKaOCnMMbWlLuvyOfS/O2n4w9mKfOUCXyPMXtFbADUY/iI8AxzNhjORaOxoTMoh3ItDikY+NxdVtRSkI0jb7w5bhY9TBRJAc4e3JV+cG8o7I9hatjDU3ywx3PwsPrg8hmAbP+NnjP5RgNR1LKrpnx4WETALs+01olwcm/L2GtTZMPQVrUA6WWuVftWGqVzV68u334qTnz/T+MnrvrKTRD8YfWR7clMwVS0vRchQpHXS4B5huXbY72MaYjMDmu0Lltl2Wr6KLRrIDqLX0aDsUoG62/kNxKDP88Mz/HFOlHWCYMn8Tdw7XfcCbW+KBeDOKIhSbp727y0FPuyDdOSxq/bqonL5sn1rvUNwBSAKNQdB327GfQc5/9t9CiZLSi+DdSJP0VcyAwMP+VZfS9A3W/pfFiVGjoxiKwzYbj5g8y7MOHJlA5VK3GCkAC8lUk3oQiWfs6QBPef7Z1uFYXUxDo0zdL8aFeYPj41EMDYa1V07yyVi706RhZ8/FWpJ6y9X9ALyTzU2teaft9RXZvNd+OS81x0zw90JGnlYRG0tMUcqpKulw6rT+hftdwxJolrRNnIHw1T9V+4Zf/xZPMxJpa6CmRBNEApbA2AJmUwHfgHH9fY/Hmy/8Dxg2pQHhEdVRHqqT5+fC9Qko1Zmf3kz1A+3aUucbnuPEVJeSENeZlvpLKYCOsmsqeYT7KEBaSRvmy6isDtdb9erdszNRfstfmrjKUU8s9Dai4YopM5B2ZqtSZQRIK8HgoCVQSDmbK2OcD406NytjhQQ+kqa0kaHOH7wbqfb/Ph5CpcrkpM3A8kw/YUFzRrbYzNE6zym/KpXeO41L7+Xn/koqXoRKeix8xt612kRDEu+8P
 97v7cn9J
 seqtTLcm79n0k0dgMVooCWucI7dtcXse8qVoY0Eui28GlNPnPSBg4UKW6nTY/vYZSTK+RaeDY/L8pzs0FvGhN9dvPGjoylfe6KBXJfVrSwwyPlvOy0rgfy8LGw/GP8I9J2b6TWDKVe2NEyav9S5Icsl/v8cANy4Xda9vYJCoxXeQ5wtiZ79/DhmFvnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Since reserved THP represents a PMD-sized VMA reservation, VMA operations
must maintain the alignment of reserved ranges and keep the quota balanced.

Handle the lifecycle of VM_RESERVED_THP VMAs by:
- Rejecting non-PMD-aligned splits.
- Uncharging reserved ranges during munmap and teardown.
- Charging copied ranges during fork.
- Updating mremap accounting when a reserved VMA grows or moves.

This prepares the necessary lifecycle management before exposing the
user-visible MADV_RESERVED_THP entry point.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/mmap.c   |  18 ++++++++
 mm/mremap.c | 121 ++++++++++++++++++++++++++++++++++++++--------------
 mm/vma.c    |  23 ++++++++++
 mm/vma.h    |   1 +
 4 files changed, 132 insertions(+), 31 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 2311ae7c2ff45..4818b14ec0ff6 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1251,6 +1251,7 @@ unsigned long tear_down_vmas(struct mm_struct *mm, struct vma_iterator *vmi,
 		struct vm_area_struct *vma, unsigned long end)
 {
 	unsigned long nr_accounted = 0;
+	unsigned long nr_reserved_thp = 0;
 	int count = 0;
 
 	mmap_assert_write_locked(mm);
@@ -1258,6 +1259,10 @@ unsigned long tear_down_vmas(struct mm_struct *mm, struct vma_iterator *vmi,
 	do {
 		if (vma->vm_flags & VM_ACCOUNT)
 			nr_accounted += vma_pages(vma);
+		if (vma->vm_flags & VM_RESERVED_THP)
+			nr_reserved_thp +=
+				reserved_thp_hpage_nr(vma->vm_start,
+						      vma->vm_end);
 		vma_mark_detached(vma);
 		remove_vma(vma);
 		count++;
@@ -1266,6 +1271,7 @@ unsigned long tear_down_vmas(struct mm_struct *mm, struct vma_iterator *vmi,
 	} while (vma && vma->vm_end <= end);
 
 	VM_WARN_ON_ONCE(count != mm->map_count);
+	reserved_thp_uncharge(nr_reserved_thp);
 	return nr_accounted;
 }
 
@@ -1733,6 +1739,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 	struct vm_area_struct *mpnt, *tmp;
 	int retval;
 	unsigned long charge = 0;
+	unsigned long reserved_charge = 0;
 	LIST_HEAD(uf);
 	VMA_ITERATOR(vmi, mm, 0);
 
@@ -1775,6 +1782,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 			continue;
 		}
 		charge = 0;
+		reserved_charge = 0;
 		if (mpnt->vm_flags & VM_ACCOUNT) {
 			unsigned long len = vma_pages(mpnt);
 
@@ -1782,6 +1790,15 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 				goto fail_nomem;
 			charge = len;
 		}
+		if (mpnt->vm_flags & VM_RESERVED_THP) {
+			unsigned long len;
+
+			len = reserved_thp_hpage_nr(mpnt->vm_start,
+						    mpnt->vm_end);
+			if (reserved_thp_charge(len))
+				goto fail_nomem;
+			reserved_charge = len;
+		}
 
 		tmp = vm_area_dup(mpnt);
 		if (!tmp)
@@ -1916,6 +1933,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 	vm_area_free(tmp);
 fail_nomem:
 	retval = -ENOMEM;
+	reserved_thp_uncharge(reserved_charge);
 	vm_unacct_memory(charge);
 	goto loop_out;
 }
diff --git a/mm/mremap.c b/mm/mremap.c
index e9c8b1d05832b..ae37e0b3ce788 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -24,6 +24,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/uaccess.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/huge_mm.h>
 #include <linux/mempolicy.h>
 #include <linux/pgalloc.h>
 
@@ -69,6 +70,7 @@ struct vma_remap_struct {
 	enum mremap_type remap_type;	/* expand, shrink, etc. */
 	bool mmap_locked;		/* Is mm currently write-locked? */
 	unsigned long charged;		/* If VM_ACCOUNT, # pages to account. */
+	unsigned long reserved_thp_charged; /* If VM_RESERVED_THP, # hpages. */
 	bool vmi_needs_invalidate;	/* Is the VMA iterator invalidated? */
 };
 
@@ -962,6 +964,9 @@ static unsigned long vrm_set_new_addr(struct vma_remap_struct *vrm)
 				map_flags);
 	if (IS_ERR_VALUE(res))
 		return res;
+	if ((vma->vm_flags & VM_RESERVED_THP) &&
+	    !IS_ALIGNED(res, HPAGE_PMD_SIZE))
+		return -ENOMEM;
 
 	vrm->new_addr = res;
 	return 0;
@@ -977,24 +982,44 @@ static bool vrm_calc_charge(struct vma_remap_struct *vrm)
 {
 	unsigned long charged;
 
-	if (!(vrm->vma->vm_flags & VM_ACCOUNT))
-		return true;
+	vrm->charged = 0;
+	vrm->reserved_thp_charged = 0;
 
-	/*
-	 * If we don't unmap the old mapping, then we account the entirety of
-	 * the length of the new one. Otherwise it's just the delta in size.
-	 */
-	if (vrm->flags & MREMAP_DONTUNMAP)
-		charged = vrm->new_len >> PAGE_SHIFT;
-	else
-		charged = vrm->delta >> PAGE_SHIFT;
+	if (vrm->vma->vm_flags & VM_ACCOUNT) {
+		/*
+		 * If we don't unmap the old mapping, then we account the
+		 * entirety of the length of the new one. Otherwise it's just
+		 * the delta in size.
+		 */
+		if (vrm->flags & MREMAP_DONTUNMAP)
+			charged = vrm->new_len >> PAGE_SHIFT;
+		else
+			charged = vrm->delta >> PAGE_SHIFT;
 
 
-	/* This accounts 'charged' pages of memory. */
-	if (security_vm_enough_memory_mm(current->mm, charged))
-		return false;
+		/* This accounts 'charged' pages of memory. */
+		if (security_vm_enough_memory_mm(current->mm, charged))
+			return false;
 
-	vrm->charged = charged;
+		vrm->charged = charged;
+	}
+
+	if (vrm->vma->vm_flags & VM_RESERVED_THP) {
+		unsigned long hpages;
+
+		if (vrm->flags & MREMAP_DONTUNMAP)
+			hpages = reserved_thp_hpage_nr(0, vrm->new_len);
+		else
+			hpages = reserved_thp_hpage_nr(0, vrm->delta);
+
+		if (reserved_thp_charge(hpages)) {
+			vm_unacct_memory(vrm->charged);
+			vrm->charged = 0;
+			return false;
+		}
+
+		vrm->reserved_thp_charged = hpages;
+	}
 	return true;
 }
 
@@ -1004,11 +1029,10 @@ static bool vrm_calc_charge(struct vma_remap_struct *vrm)
  */
 static void vrm_uncharge(struct vma_remap_struct *vrm)
 {
-	if (!(vrm->vma->vm_flags & VM_ACCOUNT))
-		return;
-
 	vm_unacct_memory(vrm->charged);
 	vrm->charged = 0;
+	reserved_thp_uncharge(vrm->reserved_thp_charged);
+	vrm->reserved_thp_charged = 0;
 }
 
 /*
@@ -1157,8 +1181,8 @@ static void unmap_source_vma(struct vma_remap_struct *vrm)
 	struct vm_area_struct *vma = vrm->vma;
 	VMA_ITERATOR(vmi, mm, addr);
 	int err;
-	unsigned long vm_start;
-	unsigned long vm_end;
+	unsigned long vm_start = 0;
+	unsigned long vm_end = 0;
 	/*
 	 * It might seem odd that we check for MREMAP_DONTUNMAP here, given this
 	 * function implies that we unmap the original VMA, which seems
@@ -1170,6 +1194,8 @@ static void unmap_source_vma(struct vma_remap_struct *vrm)
 	 */
 	bool accountable_move = (vma->vm_flags & VM_ACCOUNT) &&
 		!(vrm->flags & MREMAP_DONTUNMAP);
+	bool reserved_thp_move = (vma->vm_flags & VM_RESERVED_THP) &&
+		!(vrm->flags & MREMAP_DONTUNMAP);
 
 	/*
 	 * So we perform a trick here to prevent incorrect accounting. Any merge
@@ -1192,6 +1218,13 @@ static void unmap_source_vma(struct vma_remap_struct *vrm)
 		vm_start = vma->vm_start;
 		vm_end = vma->vm_end;
 	}
+	if (reserved_thp_move) {
+		vm_flags_clear(vma, VM_RESERVED_THP);
+		if (!accountable_move) {
+			vm_start = vma->vm_start;
+			vm_end = vma->vm_end;
+		}
+	}
 
 	err = do_vmi_munmap(&vmi, mm, addr, len, vrm->uf_unmap, /* unlock= */false);
 	vrm->vma = NULL; /* Invalidated. */
@@ -1227,19 +1260,27 @@ static void unmap_source_vma(struct vma_remap_struct *vrm)
 	 *
 	 * do_vmi_munmap() will have restored the VMI back to addr.
 	 */
-	if (accountable_move) {
+	if (accountable_move || reserved_thp_move) {
 		unsigned long end = addr + len;
-
-		if (vm_start < addr) {
-			struct vm_area_struct *prev = vma_prev(&vmi);
-
-			vm_flags_set(prev, VM_ACCOUNT); /* Acquires VMA lock. */
+		struct vm_area_struct *prev = NULL;
+		struct vm_area_struct *next = NULL;
+
+		if (vm_start < addr)
+			prev = vma_prev(&vmi);
+		if (vm_end > end)
+			next = vma_next(&vmi);
+
+		if (accountable_move) {
+			if (prev)
+				vm_flags_set(prev, VM_ACCOUNT); /* Acquires VMA lock. */
+			if (next)
+				vm_flags_set(next, VM_ACCOUNT); /* Acquires VMA lock. */
 		}
-
-		if (vm_end > end) {
-			struct vm_area_struct *next = vma_next(&vmi);
-
-			vm_flags_set(next, VM_ACCOUNT); /* Acquires VMA lock. */
+		if (reserved_thp_move) {
+			if (prev)
+				vm_flags_set(prev, VM_RESERVED_THP);
+			if (next)
+				vm_flags_set(next, VM_RESERVED_THP);
 		}
 	}
 }
@@ -1309,7 +1350,6 @@ static int copy_vma_and_data(struct vma_remap_struct *vrm,
 	*new_vma_ptr = new_vma;
 	return err;
 }
-
 /*
  * Perform final tasks for MADV_DONTUNMAP operation, clearing mlock() flag on
  * remaining VMA by convention (it cannot be mlock()'d any longer, as pages in
@@ -1576,6 +1616,23 @@ static bool align_hugetlb(struct vma_remap_struct *vrm)
 	return true;
 }
 
+static bool check_reserved_thp_alignment(struct vma_remap_struct *vrm)
+{
+	if (!(vrm->vma->vm_flags & VM_RESERVED_THP))
+		return true;
+
+	if (!IS_ALIGNED(vrm->addr, HPAGE_PMD_SIZE) ||
+	    !IS_ALIGNED(vrm->old_len, HPAGE_PMD_SIZE) ||
+	    !IS_ALIGNED(vrm->new_len, HPAGE_PMD_SIZE))
+		return false;
+
+	if ((vrm->remap_type == MREMAP_EXPAND || vrm_implies_new_addr(vrm)) &&
+	    !IS_ALIGNED(vrm->new_addr, HPAGE_PMD_SIZE))
+		return false;
+
+	return true;
+}
+
 /*
  * We are mremap()'ing without specifying a fixed address to move to, but are
  * requesting that the VMA's size be increased.
@@ -1745,6 +1802,8 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
 	/* For convenience, we set new_addr even if VMA won't move. */
 	if (!vrm_implies_new_addr(vrm))
 		vrm->new_addr = addr;
+	if (!check_reserved_thp_alignment(vrm))
+		return -EINVAL;
 
 	/* Below only meaningful if we expand or move a VMA. */
 	if (!vrm_will_map_new(vrm))
diff --git a/mm/vma.c b/mm/vma.c
index 9eea2850818a8..8c4cd7c97a984 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -7,6 +7,8 @@
 #include "vma_internal.h"
 #include "vma.h"
 
+#include <linux/huge_mm.h>
+
 struct mmap_state {
 	struct mm_struct *mm;
 	struct vma_iterator *vmi;
@@ -507,6 +509,10 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	WARN_ON(vma->vm_start >= addr);
 	WARN_ON(vma->vm_end <= addr);
 
+	if ((vma->vm_flags & VM_RESERVED_THP) &&
+	    !IS_ALIGNED(addr, HPAGE_PMD_SIZE))
+		return -EINVAL;
+
 	if (vma->vm_ops && vma->vm_ops->may_split) {
 		err = vma->vm_ops->may_split(vma, addr);
 		if (err)
@@ -1361,6 +1367,7 @@ static void vms_complete_munmap_vmas(struct vma_munmap_struct *vms,
 		remove_vma(vma);
 
 	vm_unacct_memory(vms->nr_accounted);
+	reserved_thp_uncharge(vms->nr_reserved_thp);
 	validate_mm(mm);
 	if (vms->unlock)
 		mmap_read_unlock(mm);
@@ -1423,6 +1430,11 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
 			error = -EPERM;
 			goto start_split_failed;
 		}
+		if ((vms->vma->vm_flags & VM_RESERVED_THP) &&
+		    !IS_ALIGNED(vms->start, HPAGE_PMD_SIZE)) {
+			error = -EINVAL;
+			goto start_split_failed;
+		}
 
 		error = __split_vma(vms->vmi, vms->vma, vms->start, 1);
 		if (error)
@@ -1445,6 +1457,11 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
 		}
 		/* Does it split the end? */
 		if (next->vm_end > vms->end) {
+			if ((next->vm_flags & VM_RESERVED_THP) &&
+			    !IS_ALIGNED(vms->end, HPAGE_PMD_SIZE)) {
+				error = -EINVAL;
+				goto end_split_failed;
+			}
 			error = __split_vma(vms->vmi, next, vms->end, 0);
 			if (error)
 				goto end_split_failed;
@@ -1465,6 +1482,11 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
 		if (vma_test(next, VMA_ACCOUNT_BIT))
 			vms->nr_accounted += nrpages;
 
+		if (next->vm_flags & VM_RESERVED_THP)
+			vms->nr_reserved_thp +=
+				reserved_thp_hpage_nr(next->vm_start,
+						      next->vm_end);
+
 		if (is_exec_mapping(next->vm_flags))
 			vms->exec_vm += nrpages;
 		else if (is_stack_mapping(next->vm_flags))
@@ -1560,6 +1582,7 @@ static void init_vma_munmap(struct vma_munmap_struct *vms,
 	vms->uf = uf;
 	vms->vma_count = 0;
 	vms->nr_pages = vms->locked_vm = vms->nr_accounted = 0;
+	vms->nr_reserved_thp = 0;
 	vms->exec_vm = vms->stack_vm = vms->data_vm = 0;
 	vms->unmap_start = FIRST_USER_ADDRESS;
 	vms->unmap_end = USER_PGTABLES_CEILING;
diff --git a/mm/vma.h b/mm/vma.h
index 8e4b61a7304c6..68e44adee5c89 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -48,6 +48,7 @@ struct vma_munmap_struct {
 	unsigned long nr_pages;         /* Number of pages being removed */
 	unsigned long locked_vm;        /* Number of locked pages */
 	unsigned long nr_accounted;     /* Number of VM_ACCOUNT pages */
+	unsigned long nr_reserved_thp;  /* Number of reserved PMD THP slots */
 	unsigned long exec_vm;
 	unsigned long stack_vm;
 	unsigned long data_vm;
-- 
2.54.0


