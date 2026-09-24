Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FA3EC98304
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 05:43:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C4B66B0092; Thu, 24 Sep 2026 01:43:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 074BE6B0093; Thu, 24 Sep 2026 01:43:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA6436B0095; Thu, 24 Sep 2026 01:43:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B96AC6B0092
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 01:43:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 483D5A014B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:43:27 +0000 (UTC)
X-FDA: 85247563254.28.B9EFA5C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf12.hostedemail.com (Postfix) with ESMTP id A471440002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:43:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NcxhIdww;
	spf=pass (imf12.hostedemail.com: domain of pan.deng@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=pan.deng@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790228605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kTOc/qof4zOpFXLyLL77HblTdrgly07fJ1s7N9icwTI=;
	b=xq/FxoFRTTuD8GadG3JdhB2wx9DXsd1cZsM7Oxm159YXB0/yPk7XmqTjmWKsmQl2wSHN4C
	Z9ryM9tRfsqvoUpMzYALGYJqMTljJy1Zp5674fPIST8FTslfH/QNmLMDqnvDDCjtkyVGVq
	pvDMxNk9/egOOhR5XWO5Rg9VdYz0tTA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NcxhIdww;
	spf=pass (imf12.hostedemail.com: domain of pan.deng@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=pan.deng@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790228605;
	b=iL3XOcbAMvsHMfbDgo9kSuvflSXTGyuPGfxIeJP0gjROmuy2OtSjeRI14IziD02LpRf7HH
	W58hlJPRtClkgXSrak2ethvnBWYwPn7xsxAMz+0vjAAxWWEyk0rn4cTQ9vHYhJDSziK7ot
	reak4oXzW/mxIChGoWQf6mOqJps3b7o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790228605; x=1821764605;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UyNcwb9UBjEd4LNKzNSR126TJWgimVj/XZKwh+zDpgg=;
  b=NcxhIdwwK7Plox15nBmHsONN70HjmZzN9cj8BrX1BoRV32l1x1MiIhXB
   cAsCJUFwI34uUgQkj2zMDSwIo4OhKvvF++Xl1O71APOcfI4aFbGcM5VmR
   kOGpJ7+6Fq4fyLGjrbk8unLHyyXTIa14jWWuNqIQlvk1337vC+L/t9dSY
   +B03qDUGFPqxZ7HThJTaxnVVSe9uJyGyuxDbkBK2MbigCe5M//Vl3jwvv
   a0W+sjik0MtkqVkuPhzWEo0nds19ZtkPbS2df0x48jNBNsSYryRzJBLmp
   xH2f4UFX1adNperIsgx7s9KRlHEpAHOqBoYyIw/xdhI+sh4vxyxbKqrbM
   g==;
X-CSE-ConnectionGUID: WuOIXZmVT1aTtqwpoXw1XA==
X-CSE-MsgGUID: JyJSyyKQSNC1/drqnOsWTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11914"; a="89761771"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="89761771"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 22:43:23 -0700
X-CSE-ConnectionGUID: D9IIlMmRR+qJbdbJs9L2lw==
X-CSE-MsgGUID: 47sN1UB9R5mCTtuwQLSFOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="303452120"
Received: from linux-pnp-server-17.sh.intel.com ([10.239.166.49])
  by orviesa002.jf.intel.com with ESMTP; 23 Sep 2026 22:43:20 -0700
From: Pan Deng <pan.deng@intel.com>
To: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Tianyou Li <tianyou.li@intel.com>,
	Wangyang Guo <wangyang.guo@intel.com>,
	Zhiguo Zhou <zhiguo.zhou@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH] mm/vma: avoid redundant file rmap tree re-insert on new_below=0 split
Date: Thu, 24 Sep 2026 13:43:01 +0800
Message-ID: <20260924054301.2330822-1-pan.deng@intel.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A471440002
X-Rspam-User: 
X-Stat-Signature: x8ajxcg7tim1fccab7z1bc8dhggrjygx
X-HE-Tag: 1790228604-539705
X-HE-Meta: U2FsdGVkX1/dUpOiPvzKHOhWjrSyixOoQZHPAyLPe3Y4wi/jBhrXU5mewZjjfkb2ZvBu8Q8ayrtxACkVg5kaGphz97Nt68tmK00cfuwqlmQIS/IDmU7uM/dtOrHtEBO/PJXehfqVl7r9ZoR8ihvDh1ePz7yixMEzdvSAF1C1eyXbFPGK2vXr4wOqhSoe/2xBfUOdeZ3pwzb4bv4eAc3e0aYsaVtWmgYmlXh2J7Jr6/4x2AbEEyHbYNxdsE/qqP8Qw1qtGevkg8XeejXNAWvTV6o+1Li+ltpyOZRj4xPayPsQKQFtnMsnaIDhCPxBucwb7l/lsStHP3fuzSNqpvvRbHFE7MyZ5iaRFzANOaU0N+ed9rJqKkSXCYS9KPzEdY++g3hOkF1CwGPQ+FwqBxYRZIg66S7KY4t0VzbJkBxRQ9m8Tp9/zCutspQozn+G/hU8DeGnUETCMvCTmaviVgnRu8d3uf18R5/unl3PE61f8vtPPs8werWCvclj6Vd4DRdMNetjf5TIYPccBt+HsXzDxdXSJjarlFauvCeqNg1Vd2cVfginaKx8A1mASR4SslfX783NMtByI6Wci6TnBAjn/6yQ8PM1+PQaaU61GLwRah6WuJK5h1TP39SpbSfrTlRiqtDgyQdbt0404MZQZdFZ4wU4hVJ43HjUA+jYTh92uOwp2EX8Pls0T2Zo6Fvv4/LJiL+OPo2EvnN50SkJfHLA0wkLllVhdca43yZwmHw249lUCzbc7UbxFlwPvnxZJ4z+1yqzLhoCz+NCplnhaDNC+UpqthJHADQlsOaZ5vtHAGeYDIqUw7+WPlomq5FRt8aT3bo7U0U3lgGh3lgdFzIGU9V5IMAGUsyjXa1hnmdVM9G80jYWCLa8AgUXGwfmvEjQDQ5PJdpwNYsZftDujxLJ3JELqCpqONF9kHduKj6qlxCtl9OzmReehE3Vz43zFEwQFm0uuCL4HVOajmRGJzi
 cbPGuO69
 eWpATs4CKJo13BzZr6HyM8gNz4tDHT/w9gn+VTIt8AtzUW0ULryYFejwo4oN9c+mf40n2JZsQ0HyEmIPsoxn8SfYvr/GoTMLR7uWJMXDUwrr/wGXqqtWD3bu+0S6hb/cGogymQ3V84tdQsxfeiiN/n6Nrym8xYZt5RpoE3K4ZrzOsbpcFdwwoU5N12SEGBv6/go506Jq0fheYIQ2C8AnAKREXesOKm73kUfFPvd8teY5qJ0efNp+XWc6hEgFVbXixXnous+/vddrH9rA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Splitting a file-backed VMA removes it from the mapping's i_mmap interval
tree and re-inserts it, two O(log n) walks with rebalancing, all inside
the i_mmap_rwsem write-side critical section.  For a file mapped by many
processes that lock is a single serialization point, so the cost translates
into reduced exec throughput.

While the re-insert is needed whenever the sort key changes, it is not for
a new_below=0 split: there the new VMA takes the upper half and only the
original VMA's vm_end shrinks, so vma_start_pgoff(), the sort key of the
interval tree, stays constant and the VMA is already in the correct
position.

This change skips the re-insert for that case.  vma_prepare() no longer
removes vp->vma from the tree; instead vma_complete() detects that case and
only recomputes shared.rb_subtree_last up the ancestor chain.  Everything
else keeps the remove + re-insert path.

The case is detected by comparing vma_start_pgoff(vp->insert) against
vma_start_pgoff(vp->vma): only a new_below=0 split leaves the former
greater.  __split_vma() adjusts pgoff via vma_add_pgoff(new,
linear_page_delta(vma, addr)), and linear_page_delta() is
(addr - vm_start) >> PAGE_SHIFT with addr strictly inside the VMA, so the
delta is at least one page and the new VMA's pgoff is strictly greater.
For new_below=1 the two are initially equal and vp->vma's pgoff then
increases, so the comparison is false both before and after the caller's
endpoint updates, and the original path is taken.

Inferring the case this way keeps the change small: struct vma_prepare
gains no field and no caller changes.

Moving the remove() out of vma_prepare() leaves vp->vma in the tree with a
possibly stale sort key across the caller's endpoint updates, so
vma_complete() re-keys it *before* inserting vp->adj_next: otherwise that
key-driven descent could place adj_next in the wrong subtree.

Measured on v7.3-rc4, on a 2-socket 192C/384T system running UnixBench
execl (384 concurrent execve of the same binary), dropping the redundant
remove + re-insert yields ~14% higher throughput by shortening the
i_mmap_rwsem write-side critical section during the file VMA splits that
execve performs on the shared libraries.

Signed-off-by: Pan Deng <pan.deng@intel.com>
Reviewed-by: Tianyou Li <tianyou.li@intel.com>
Reviewed-by: Wangyang Guo <wangyang.guo@intel.com>
Reviewed-by: Zhiguo Zhou <zhiguo.zhou@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Assisted-by: LLM
---
 include/linux/mm.h                |  1 +
 mm/interval_tree.c                | 13 ++++++++
 mm/vma.c                          | 54 +++++++++++++++++++++++++++++--
 mm/vma.h                          |  1 +
 tools/testing/vma/include/stubs.h |  4 +++
 5 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index dd09c438fa23..baf489343f86 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4181,6 +4181,7 @@ void mapping_rmap_tree_insert_after(struct vm_area_struct *vma,
 				    struct address_space *mapping);
 void mapping_rmap_tree_remove(struct vm_area_struct *vma,
 			      struct address_space *mapping);
+void mapping_rmap_tree_propagate(struct vm_area_struct *vma);
 struct vm_area_struct *
 mapping_rmap_tree_iter_first(struct address_space *mapping,
 			     pgoff_t pgoff_start, pgoff_t pgoff_last);
diff --git a/mm/interval_tree.c b/mm/interval_tree.c
index 7bbbf15cfbf0..3b81c990aab2 100644
--- a/mm/interval_tree.c
+++ b/mm/interval_tree.c
@@ -64,6 +64,19 @@ void mapping_rmap_tree_remove(struct vm_area_struct *vma,
 	__mapping_rmap_tree_remove(vma, &mapping->i_mmap);
 }
 
+/*
+ * Recompute shared.rb_subtree_last for vma and its ancestors, for a vma whose
+ * interval changed but whose vma_start_pgoff() (the tree's sort key) did not.
+ * The NULL stop node makes the walk run up to the root, though it ends early
+ * once the recomputed value stops changing.
+ *
+ * Wrapper because INTERVAL_TREE_DEFINE() above declares the callbacks static.
+ */
+void mapping_rmap_tree_propagate(struct vm_area_struct *vma)
+{
+	__mapping_rmap_tree_augment.propagate(&vma->shared.rb, NULL);
+}
+
 struct vm_area_struct *
 mapping_rmap_tree_iter_first(struct address_space *mapping,
 			     pgoff_t pgoff_start, pgoff_t pgoff_last)
diff --git a/mm/vma.c b/mm/vma.c
index f29abb30956b..e1dbfd5094cd 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -365,11 +365,43 @@ static void vma_prepare(struct vma_prepare *vp)
 
 	if (vp->file) {
 		flush_dcache_mmap_lock(vp->mapping);
-		mapping_rmap_tree_remove(vp->vma, vp->mapping);
+		/* vp->vma is re-keyed by vma_complete(), if it needs to be. */
 		if (vp->adj_next)
 			mapping_rmap_tree_remove(vp->adj_next, vp->mapping);
 	}
+}
 
+/*
+ * vma_split_keeps_rmap_key() - Check if vp->vma keeps its file rmap tree key
+ * @vp: The vma_prepare struct
+ *
+ * True only for a new_below=0 __split_vma(): the new VMA takes the upper half,
+ * so its vma_start_pgoff() is strictly greater, while vp->vma's (its key in the
+ * file rmap interval tree) is unchanged and its tree position still correct, so
+ * only shared.rb_subtree_last has to be recomputed.
+ *
+ * Relies on vp->insert being assigned by __split_vma() only; the check below
+ * catches a second assignment site whose VMA does not abut vp->vma.
+ */
+static bool vma_split_keeps_rmap_key(const struct vma_prepare *vp)
+{
+	if (!vp->insert ||
+	    vma_start_pgoff(vp->insert) <= vma_start_pgoff(vp->vma))
+		return false;
+
+	/*
+	 * Today only a new_below=0 __split_vma() reaches here, where the new
+	 * VMA abuts vp->vma at the split point once the caller has updated
+	 * vp->vma->vm_end.  If a future vp->insert user ever violates that,
+	 * fall back to the safe remove + re-insert instead of trusting the
+	 * fast path.
+	 */
+	if (vp->insert->vm_start != vp->vma->vm_end) {
+		VM_WARN_ON_ONCE(1);
+		return false;
+	}
+
+	return true;
 }
 
 /*
@@ -384,9 +416,27 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 			 struct mm_struct *mm)
 {
 	if (vp->file) {
+		if (vma_split_keeps_rmap_key(vp)) {
+			/*
+			 * Split paths go through init_vma_prep(), which
+			 * passes a NULL vmg, so vp->adj_next is never set.
+			 */
+			VM_WARN_ON_ONCE(vp->adj_next);
+			mapping_rmap_tree_propagate(vp->vma);
+		} else {
+			/*
+			 * Re-key vp->vma *before* the insert of vp->adj_next
+			 * below, so that the latter descends a valid
+			 * search tree: vp->vma is the only node left in
+			 * the tree that may carry a stale sort key
+			 * (vp->adj_next itself was removed in
+			 * vma_prepare()).
+			 */
+			mapping_rmap_tree_remove(vp->vma, vp->mapping);
+			mapping_rmap_tree_insert(vp->vma, vp->mapping);
+		}
 		if (vp->adj_next)
 			mapping_rmap_tree_insert(vp->adj_next, vp->mapping);
-		mapping_rmap_tree_insert(vp->vma, vp->mapping);
 		flush_dcache_mmap_unlock(vp->mapping);
 	}
 
diff --git a/mm/vma.h b/mm/vma.h
index 024fabe63560..3f791e4d13f6 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -23,6 +23,7 @@ struct vma_prepare {
 	struct file *file;
 	struct address_space *mapping;
 	struct anon_vma *anon_vma;
+	/* Set by __split_vma() only; see vma_split_keeps_rmap_key(). */
 	struct vm_area_struct *insert;
 	struct vm_area_struct *remove;
 	struct vm_area_struct *remove2;
diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
index d6136e19a8af..3b5184aeee54 100644
--- a/tools/testing/vma/include/stubs.h
+++ b/tools/testing/vma/include/stubs.h
@@ -267,6 +267,10 @@ static inline void mapping_rmap_tree_remove(struct vm_area_struct *vma,
 {
 }
 
+static inline void mapping_rmap_tree_propagate(struct vm_area_struct *vma)
+{
+}
+
 static inline void flush_dcache_mmap_unlock(struct address_space *mapping)
 {
 }
-- 
2.43.5


