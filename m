Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86B33C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 18:32:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 382456B008C; Fri, 25 Sep 2026 14:32:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 333696B0092; Fri, 25 Sep 2026 14:32:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2492B6B0093; Fri, 25 Sep 2026 14:32:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB8446B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:32:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A88D1C2B74
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 18:32:36 +0000 (UTC)
X-FDA: 85253130312.10.161B427
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5CCC518000D
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 18:32:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DPXcgoer;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790361154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=r9iJK8cubIy4yqj3FqVyjDFMADrnpXNYWjGeV7uEiTs=;
	b=RIb7tIyqixEyEJhFlEfH92zkn5/xSPBuDBupkQ0ApjxvXFNMhmU5huA9VYIHrTtWEjH9sG
	nsW71t2Kukbfk1oQvIYz0rZVQGDWoA0D5GBynZUFdeyFgi0vFSBkett3BKjrIZNEk1T15q
	SUFXiFvsxFAoBxZd33fyC0wvweA/vm8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790361154;
	b=KDWyuM6EEyM6BC6efeExj7l83ACc9ah3/XxM3tPRwGbQB+2rflOegadtiktzy9zmHydonF
	FE468Mk4XlYbbCpdWJZX+q9xq7GMUdNKV7rfNCshk3ZFgwFkk3+w1aF7KZR7YcG++uCAtj
	ViSW7q73Pf7qVUCLRLJo/DUYSRvcnCc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DPXcgoer;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 940C441891;
	Fri, 25 Sep 2026 18:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26E61F000FF;
	Fri, 25 Sep 2026 18:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790361152;
	bh=r9iJK8cubIy4yqj3FqVyjDFMADrnpXNYWjGeV7uEiTs=;
	h=From:Date:Subject:To:Cc;
	b=DPXcgoer43IdLffnMouUeh1bb0EpInVuAwiBWPNMIUbvphW514ePK5gHs8YImhCbl
	 QJGYT7IaFbgduLd18n0/IcsJL3MoaKpK02ptbGcQrZ9Yh4X6QfOAqSGD4UR5/s79N/
	 fCD5tWcOsGMAL+WVZ42sFK5VzFpt5Z45t1RVOiAmBThyM/3OKxv1/OsLYQf4d437+m
	 iNOL1GdC4S+kLrVZOgBcjafTLT04PneRWN0VvFrVzk26cRF1tV/ZxpiJOQ6WOBbL6q
	 vb2MRaH2ScbNFxjO3oiv18R/BGLmR9pR8BfQXFz6VFTSit4T/s7/f5HWxat+IcxumS
	 bEOzUZ2yyO/xA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 25 Sep 2026 19:32:20 +0100
Subject: [PATCH] mm/vma: don't remove VMA from rmap if pgoff unchanged
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-speed-up-inplace-rmap-v1-1-babc48ce7c83@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MSwqAMAwA0atI1gZq/VC9iriommpAa2hRBPHuF
 pdvMfNApMAUocseCHRx5MMnFHkG02r9QshzMmilG9XqGqMQzXgKspfNToRht4JGGTeOpamMqyG
 1Esjx/X/74X0/jHNRwmcAAAA=
X-Change-ID: 20260925-speed-up-inplace-rmap-808fbb3848f5
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Pan Deng <pan.deng@intel.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=9617; i=ljs@kernel.org;
 h=from:subject:message-id; bh=wRe/8mmf8QrohRi4fFapd+vGEtGbc4T83bKKTeu/h+8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK27bOcFnvCy1y47k2N2YewF4zL4+J3q14+xpd4arGCk
 t+eqhWJHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZgIdxgjwyehaYF1FrUPNBUu
 tUml3Fz06O3vtEdfRf0MDjec29cVJM3IcItxae6r4PRZXH/djrKfuHnMKpXF6d8P9cZz66/PjW1
 fxgoA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5CCC518000D
X-Stat-Signature: 18jogws6e3c7rc395ku5rm6yy84hr1g8
X-HE-Tag: 1790361154-300616
X-HE-Meta: U2FsdGVkX1872wfYCMxgv6oE00bUuoxrg5F0RMMuJU2n3OEzWljDpWGScVHhZTv4zRWz/BEeeO0aOsF2FNReUHrkMaJ/MNNFqjGSZcCGySR30+FUS4GhEghHr+IJluiv0GtIYRL/gAcXVA9zTdbSo7hwBuzaVT/JqDwANMAHjlqjZSeHfHT0U3SQtrKcjQbTcxlceOWHm46AenenID0/i/vchmafn+EanX+di46BnoL9MoZl0+ggVXRfaVpAg/MeRRgJDdSCRAZ+OCvLOmBdEp8p7nBTbjXe1ZTVqi3hqsjITW8oOkeJoZCPU7x7uIO8vS/JDWH+S4knmSJkp6FJHLFJrjIObC2aQKO6q76k3KLq4PSJ+0BAyzPA3MCTQVQr4qnLv04pazgJMLEDJ9TVvHj7EvSba3ci2syx9IvwRES6HWS2T0OWm/4jIUbrJSQ3DlEfyqXFB17R8r1Yg8gWMDmnoj0oNlRuRbqqOjzy4IY7SlEzLb6DWTqVD/X64xON2MiSQJdXpeWPtpGkTJRzynrvCHoL1vszx3eqy7CPZyxai8Nu1C6K8oBPus4m4MB/W3j62Z0f/iWCgtg6NuCZuqbZHqd+exxZtgz+lOZ0pmFaM9RVrVrIPXbK4pst0kTa8X5GqMyIG97zYUfcjqa+n5kUfntXTBQMMH/Pdf1WJ6YpW289c2S53lmFT75GS9gDXSqtQiPhHBzGiViKAch6Oe+hOfQA6MbY3H8I1IFswtLLJhQ6j5wBaX0auYXc/7FgY9uwJ4CRE4zxthNT6WJkBisllZQWdT59WAKSiny8UM5gMI4SVXTDrNvP0P8fou73VgrOJziKVC8lEaeT14C50F9ZwrW8gfRu1bgQnODchzkPNZZgJ/GEEmmVjkkQ7S0VjZm014HJle7SKdPf0JXhW2TTIaMmUBRP8ZWbuW1Ec6Nz6tQ/UEyJfCcPWq4NmXMDR5d17gKfBI+7XvPU3o6
 l/vFSjAW
 1RGSLkBEa1fTvvY9Pi6GCjz8hHG9+5O17nuQkgCrZuE63TTybgf3TLy3J+xfc+q8oUOgrXe/drbg1Ed3dXPngeZfo/qaC6CkqI8/+q9FCaiYezt4xL0vXsupa17ASpYcUMFOm3JaLfp+hiJEyIdRzaDfKCjroM7ZabpDNZfVf6QNzwm44msOecvowG3MK3yYH6FBGa0YYKSm7d5H1CN37upG8ZhPIBs2vC5R8CfeSb8BkrxTpziWqFEShdTsodNOEPelx3DU7CZqbTxg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When updating a VMA, vma_prepare() unconditionally removes it from its rmap
interval trees under the rmap lock, and vma_complete() reinserts it before
releasing the lock.

This is wholly unnecessary if its page offset (file rmap) or anonymous page
offset (anon rmap) is unchanged.

So, track whether they will change in the newly introduced
vp->anon_pgoff_unchanged and vp->pgoff_unchanged fields, and use them to
determine whether to remove the VMA or not.

The rmap lock keeps things safe as no rmap walks can concurrently occur
during the operation.

Additionally, some architectures (arm, parisc, nios2, csky) have dcache
flush rmap walkers which take only flush_dcache_mmap_lock(), which is
likewise held across the operation.

It's also necessary to keep the rb_subtree_last field updated in the
interval tree so implement anon_rmap_tree_update_inplace() and
mapping_rmap_tree_update_inplace() to do that.

This is done in vma_complete(), after the VMA's range has been updated, so
in the interim the field may be invalid. However, given the locks described
above, this cannot be observed until after the state is corrected.

The anonymous rmap is keyed on anon_vma_chains not VMAs, so in those
instances anon_rmap_tree_update_vma_inplace() iterates over
vma->anon_vma_chain, invoking anon_rmap_tree_update_inplace() on each one.

For the anon rmap case, with CONFIG_DEBUG_VM_RB set, avc->cached_vma_last
is also updated in anon_rmap_tree_update_inplace().

When performing a VMA shrink or a split where the VMA is the lower one, the
page offset cannot change, so set the flags unconditionally in these cases.

When merging VMAs the page offset is unchanged only in some cases, so
update init_multi_vma_prep() to set the flags only if the page offsets
remain the same.

These changes ultimately result in less rmap lock contention.

Reported-by: Pan Deng <pan.deng@intel.com>
Closes: https://lore.kernel.org/linux-mm/20260924054301.2330822-1-pan.deng@intel.com/
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h                |  3 +++
 mm/interval_tree.c                | 33 ++++++++++++++++++++++++++++++++
 mm/vma.c                          | 40 ++++++++++++++++++++++++++++++++++-----
 mm/vma.h                          |  2 ++
 tools/testing/vma/include/stubs.h |  8 ++++++++
 5 files changed, 81 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6e71eaa4af3f..94c2eb055716 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4357,6 +4357,8 @@ void mapping_rmap_tree_insert_after(struct vm_area_struct *vma,
 				    struct address_space *mapping);
 void mapping_rmap_tree_remove(struct vm_area_struct *vma,
 			      struct address_space *mapping);
+void mapping_rmap_tree_update_inplace(struct vm_area_struct *vma);
+
 struct vm_area_struct *
 mapping_rmap_tree_iter_first(struct address_space *mapping,
 			     pgoff_t pgoff_start, pgoff_t pgoff_last);
@@ -4374,6 +4376,7 @@ void anon_rmap_tree_insert(struct anon_vma_chain *avc,
 			   struct anon_vma *anon_vma);
 void anon_rmap_tree_remove(struct anon_vma_chain *avc,
 			   struct anon_vma *anon_vma);
+void anon_rmap_tree_update_inplace(struct anon_vma_chain *avc);
 struct anon_vma_chain *
 anon_rmap_tree_iter_first(struct anon_vma *anon_vma,
 			  pgoff_t pgoff_start, pgoff_t pgoff_last);
diff --git a/mm/interval_tree.c b/mm/interval_tree.c
index 7bbbf15cfbf0..eafde5d12ef5 100644
--- a/mm/interval_tree.c
+++ b/mm/interval_tree.c
@@ -64,6 +64,21 @@ void mapping_rmap_tree_remove(struct vm_area_struct *vma,
 	__mapping_rmap_tree_remove(vma, &mapping->i_mmap);
 }
 
+/**
+ * mapping_rmap_tree_update_inplace() - Update file rmap tree to reflect an
+ * in-place change in a VMA's size.
+ * @vma: The VMA whose size has changed.
+ *
+ * The file rmap lock must be held.
+ *
+ * Invalid to do so if @vma->vm_pgoff has changed.
+ */
+void mapping_rmap_tree_update_inplace(struct vm_area_struct *vma)
+{
+	/* Propagate all the way up the tree. */
+	__mapping_rmap_tree_augment.propagate(&vma->shared.rb, NULL);
+}
+
 struct vm_area_struct *
 mapping_rmap_tree_iter_first(struct address_space *mapping,
 			     pgoff_t pgoff_start, pgoff_t pgoff_last)
@@ -111,6 +126,24 @@ void anon_rmap_tree_remove(struct anon_vma_chain *avc,
 	__anon_rmap_tree_remove(avc, &anon_vma->rb_root);
 }
 
+/**
+ * anon_rmap_tree_update_inplace() - Update anon rmap tree to reflect an
+ * in-place change in the size of @avc's VMA.
+ * @avc: The anon_vma_chain whose VMA's size has changed.
+ *
+ * The anon rmap root lock must be held.
+ *
+ * Invalid to do so if the VMA's anonymous pgoff has changed.
+ */
+void anon_rmap_tree_update_inplace(struct anon_vma_chain *avc)
+{
+#ifdef CONFIG_DEBUG_VM_RB
+	avc->cached_vma_last = avc_last_pgoff(avc);
+#endif
+	/* Propagate all the way up the tree. */
+	__anon_rmap_tree_augment.propagate(&avc->rb, NULL);
+}
+
 struct anon_vma_chain *
 anon_rmap_tree_iter_first(struct anon_vma *anon_vma,
 			  pgoff_t pgoff_start, pgoff_t pgoff_last)
diff --git a/mm/vma.c b/mm/vma.c
index 077e23694143..8b333ec0c958 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -201,8 +201,15 @@ static void init_multi_vma_prep(struct vma_prepare *vp,
 	if (vp->file)
 		vp->mapping = vma->vm_file->f_mapping;
 
-	if (vmg && vmg->skip_vma_uprobe)
+	if (!vmg)
+		return;
+
+	if (vmg->skip_vma_uprobe)
 		vp->skip_vma_uprobe = true;
+	if (vma_start_pgoff(vma) == vmg_start_pgoff(vmg))
+		vp->pgoff_unchanged = true;
+	if (vma_start_anon_pgoff(vma) == vmg_start_anon_pgoff(vmg))
+		vp->anon_pgoff_unchanged = true;
 }
 
 /*
@@ -331,6 +338,15 @@ anon_rmap_tree_post_update_vma(struct vm_area_struct *vma)
 		anon_rmap_tree_insert(avc, avc->anon_vma);
 }
 
+static void
+anon_rmap_tree_update_vma_inplace(struct vm_area_struct *vma)
+{
+	struct anon_vma_chain *avc;
+
+	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
+		anon_rmap_tree_update_inplace(avc);
+}
+
 /*
  * vma_prepare() - Helper function for handling locking VMAs prior to altering
  * @vp: The initialized vma_prepare struct
@@ -359,14 +375,16 @@ static void vma_prepare(struct vma_prepare *vp)
 
 	if (vp->anon_vma) {
 		anon_vma_lock_write(vp->anon_vma);
-		anon_rmap_tree_pre_update_vma(vp->vma);
+		if (!vp->anon_pgoff_unchanged)
+			anon_rmap_tree_pre_update_vma(vp->vma);
 		if (vp->adj_next)
 			anon_rmap_tree_pre_update_vma(vp->adj_next);
 	}
 
 	if (vp->file) {
 		flush_dcache_mmap_lock(vp->mapping);
-		mapping_rmap_tree_remove(vp->vma, vp->mapping);
+		if (!vp->pgoff_unchanged)
+			mapping_rmap_tree_remove(vp->vma, vp->mapping);
 		if (vp->adj_next)
 			mapping_rmap_tree_remove(vp->adj_next, vp->mapping);
 	}
@@ -387,7 +405,11 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 	if (vp->file) {
 		if (vp->adj_next)
 			mapping_rmap_tree_insert(vp->adj_next, vp->mapping);
-		mapping_rmap_tree_insert(vp->vma, vp->mapping);
+		/* Need only propagate the change inplace. */
+		if (vp->pgoff_unchanged)
+			mapping_rmap_tree_update_inplace(vp->vma);
+		else
+			mapping_rmap_tree_insert(vp->vma, vp->mapping);
 		flush_dcache_mmap_unlock(vp->mapping);
 	}
 
@@ -406,7 +428,11 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 	}
 
 	if (vp->anon_vma) {
-		anon_rmap_tree_post_update_vma(vp->vma);
+		/* Need only propagate the change inplace. */
+		if (vp->anon_pgoff_unchanged)
+			anon_rmap_tree_update_vma_inplace(vp->vma);
+		else
+			anon_rmap_tree_post_update_vma(vp->vma);
 		if (vp->adj_next)
 			anon_rmap_tree_post_update_vma(vp->adj_next);
 		anon_vma_unlock_write(vp->anon_vma);
@@ -593,6 +619,8 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 
 	init_vma_prep(&vp, vma);
 	vp.insert = new;
+	vp.pgoff_unchanged = !new_below;
+	vp.anon_pgoff_unchanged = !new_below;
 	vma_prepare(&vp);
 
 	/*
@@ -1346,6 +1374,8 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	vma_start_write(vma);
 
 	init_vma_prep(&vp, vma);
+	vp.pgoff_unchanged = true;
+	vp.anon_pgoff_unchanged = true;
 	vma_prepare(&vp);
 	vma_adjust_trans_huge(vma, vma->vm_start, end, NULL);
 
diff --git a/mm/vma.h b/mm/vma.h
index 7a683272c0a8..336b4ced82c9 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -28,6 +28,8 @@ struct vma_prepare {
 	struct vm_area_struct *remove2;
 
 	bool skip_vma_uprobe :1;
+	bool pgoff_unchanged :1;
+	bool anon_pgoff_unchanged :1;
 };
 
 struct unlink_vma_file_batch {
diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
index e4acc6f1fe7b..f0a69393c02a 100644
--- a/tools/testing/vma/include/stubs.h
+++ b/tools/testing/vma/include/stubs.h
@@ -267,6 +267,10 @@ static inline void mapping_rmap_tree_remove(struct vm_area_struct *vma,
 {
 }
 
+static inline void mapping_rmap_tree_update_inplace(struct vm_area_struct *vma)
+{
+}
+
 static inline void flush_dcache_mmap_unlock(struct address_space *mapping)
 {
 }
@@ -281,6 +285,10 @@ static inline void anon_rmap_tree_remove(struct anon_vma_chain *avc,
 {
 }
 
+static inline void anon_rmap_tree_update_inplace(struct anon_vma_chain *avc)
+{
+}
+
 static inline void uprobe_mmap(struct vm_area_struct *vma)
 {
 }

---
base-commit: e8d0f6a1b2a447d02845984fa6288787543cb03c
change-id: 20260925-speed-up-inplace-rmap-808fbb3848f5

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


