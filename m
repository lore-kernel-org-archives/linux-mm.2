Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FBCACA5FC1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 17:53:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAE676B0088; Wed, 30 Sep 2026 13:53:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5F906B008A; Wed, 30 Sep 2026 13:53:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4DF06B008C; Wed, 30 Sep 2026 13:53:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 963026B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 13:53:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1636012011C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 17:53:53 +0000 (UTC)
X-FDA: 85271176746.10.2430CE6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6B39B40007
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 17:53:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wi3QbhlE;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790790831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=H5f6mYX7zUuljbbM5ONB5c1sCOASZNSuLoqxUSnKaRg=;
	b=iPOWmJsjrppCQiHiDFmHi/NEe1spDjMcP1X6/NeB5bNPaRjFUZ46lVyqfslhDL0TZGD65x
	0Lhot8KZr6/c+DcicpuIHYmV/jbNrRO64ueO2zGFneIZyCGwxCzxZI8cvI0Qn46Bjx9KcN
	uQ2+/kQxdW+qeOzulN5CSbyHfloNk7c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790790831;
	b=WWzMfV8b+cxjnzTSLv6ol9+sluLwmpqVZwOhMijHLNt6rHDIhLsrIlKRSoCVoirDMfarUx
	LV6quvq6i0+Cjgv7LmFezi2jg4H7NntE91UBdQB38Eouxi8dsn4RZhPlQzrkSnR/ffF2Ue
	bY1xJsdgztGMw7a2vOICsmumDXxo7TU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wi3QbhlE;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 436A5602A8;
	Wed, 30 Sep 2026 17:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F711F000FF;
	Wed, 30 Sep 2026 17:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790790830;
	bh=H5f6mYX7zUuljbbM5ONB5c1sCOASZNSuLoqxUSnKaRg=;
	h=From:Date:Subject:To:Cc;
	b=Wi3QbhlEoSR4I60NqHejXvoGMpBnPpP34GsGzASRn0RUonsJouN4btDCSSW7RH0/I
	 wpPZ2zLtPTteoi7Ay4NajoD8B+vgDZl+K8efvNE6wltkkQVPWnw4oMKLMRlv+13TvH
	 zsPmd2CHk9Rnz23V/TCW1Vnw5mNKoghhi/kxDn0n8+nWubGwiYAFQWcsGw1mf+WABC
	 L/8WSe7227y8BpByehY5OvuAdEAiPg7xdY4K3F/YrnVBfmqGPnzcikByv9UsMev+0S
	 kzvyWaiMiQiDFjFJ6CQr6TnKE+Mpbwj7sJbRS5HcrXeUGJgZCj3QtJ6Rt2/OhN3JD+
	 q0uHHIuRv9fhA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 30 Sep 2026 18:53:36 +0100
Subject: [PATCH v2] mm/vma: don't remove VMA from rmap if pgoff unchanged
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-speed-up-inplace-rmap-v2-1-ac1aa19708aa@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/4WNQQ6CMBBFr0Jm7RgooJWV9zAs2jLARCzNVImGc
 HcrF3D5XvLfXyGSMEVoshWEFo48+wTqkIEbjR8IuUsMKlen/KJqjIGow1dA9mEyjlAeJqDOdW9
 tqSvd15C2Qajn9969tYlHjs9ZPvvNUvzsv+JSYIHWWFdpR2eny+udxNN0nGWAdtu2LyRtCb67A
 AAA
X-Change-ID: 20260925-speed-up-inplace-rmap-808fbb3848f5
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
 Pan Deng <pan.deng@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=15717; i=ljs@kernel.org;
 h=from:subject:message-id; bh=/u9v33iWlwBpydsQ/YBjmpqjj1cY7t5FLqRteGGl3iY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLL2+qy0MJ4q8JyDf6vLP6U3cTlG0+5+Wv4jw8oiIsPwt
 NHXIJE7HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjIs0JGhmty7/bvKLpqrsC0
 SNfYUmjDmYePDy1zY81Knpd86cRitY2MDJ/15W/39ssUL7htsbCrXHxe5Tzt9GXN6d217B2sigd
 CuAE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: b4yuh5dabfb8hyfis9tep6znojnjfud8
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6B39B40007
X-HE-Tag: 1790790831-769275
X-HE-Meta: U2FsdGVkX1/QdMJYHE9trCV9/PJ2GpEL2YGRLze2mH6Qzb08fNyAg5klvJT9e6h4A2Z0mXeDu41ZO/DR5G8NWD4OVkWu6UCod6YM7O9D5xKcU9vvJv1P0NQX/ctytVmhTNJXycaSoLzUFfAhscf7OqqSq48IV7N0oAcsoxdKII9KmjCRMFDKkusZ6og7a2pG4yJOJEQ2AaAOQn+wvXc2fL12D3AqhCa3EzicRkBg3f6e4IKzo1ATT7mSvCx5MX/Ec7ubCx2lHZxQxg0O/3+JKU0Mydtx2QDUtKxO2sDBqfV10pwGIc+AinUJRhzVpIIMyL59Zv0sdyLmGHSHJuUsqo2IWNEMZj9Y/9jfHsXjHcVL3VRVHaMCOBtRnZGNMzxoHhFZndVxkEoqDLvfEGeiiMKO2XLomnryc7OS8WISiXmQQwlNYEOE/jhT9DL3X6eJlbeFPTphskQxxWCFrkT96hKfbQkyBxk2747sEAn1hHoZP+9LpNj+8YHHKzvIk3RoBXgsV08LpgsE88crjdAS8WKk8fqrehomXFiIsRraoOkAPsobmXyRhxdXsLbovzG5oa+kU9E21Gvq0whKWhi0loK+plJhKT/sQ8YzMPyA0ef6Mqws8ADm3LLIBkxfjSCXqgeRx15mdRBWMWbLsc6lYHKy/Hf0dVZulkIMncXzcOPtonO1K95X5LwtqcDFDQUWk6pIwruiasB8b+CFF+VIoX25mIORrJsiGM8dnezH23FM8q/xsNMD7En0aVE1ASYeuI9TPdZ5p602IXtt+aFZvvOxxuXd2C3QKFyzTvhmiPH0a8jMwGeQ/+7bCssSv8YnZVxxJjtgNnuqoBJSXGbGb4y+Obknf9c4BgC4ddp92bCl1xQcPlogYsI0FTIgnremwDq4S7mv6TOXXn6VrTwi96JQxN/1wC9FTPwadI3IuowZRYnbJ7C7uft3huUrjP5EfbYcFXO8X7TwDLhCvbn
 xBALtYAX
 spFGz83gfCJXOnjkE9BXsCxJp8EWWdT5MQbRVZLNK2ODOB4Y3Piw6njjUleoGr+jGTplWcVSd4vLV/6EWWgBk6b1NDABsqLMW4vulo3zR1CukEb8/C/jXxIUYd/UlCSBkgaYE0bk153SH9O927kTAezgBsj2T4FekHGpUki/cpDp0IEKX1yG+mZw2w3bDarjKJm772oJ0SUT46LegFfHFXXV/F3c7fxjtrFmyZ1erUT6AgBdO4mJD8PMUhOnF5a9BYWDhgp3cIw9hiVFodgpNqz/3ZusPmn9y5p92oGm2CrLJEH70op7dXJd5eJ1HMJ+7DvscLKzX6Cvjdpc=
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
vp->file_pgoff_unchanged and vp->anon_pgoff_unchanged fields, and use them
to determine whether to remove the VMA or not.

The rmap lock keeps things safe as no rmap walks can concurrently occur
during the operation.

Additionally, some architectures (arm, parisc, nios2, csky) have dcache
flush rmap walkers which take only flush_dcache_mmap_lock(), which is
likewise held across the operation.

If the VMA remains in the tree, it's necessary to keep the augmented
rb_subtree_last field updated to reflect its changed range.

Provide mapping_rmap_tree_[pre, post]_update() and
anon_rmap_tree_[pre, post]_update_vma() (replacing the existing logic in
the anonymous case) to handle both the changed and unchanged cases.

For the anon rmap case, with CONFIG_DEBUG_VM_RB set, avc->cached_vma_last
is also updated when propagating in place.

When performing a VMA shrink or a split where the VMA is the lower one, the
page offset cannot change, so set the flags unconditionally in these cases.

When merging VMAs the page offset is unchanged only in some cases, so
update init_multi_vma_prep() to set the flags only if the page offsets
remain the same.

Finally, while we're here, also update expand_upwards() similarly.

These changes ultimately result in less rmap lock contention.

Pan Deng reported results using the UnixBench/excel benchmark on a 2-socket
192 core, 384 thread x86-64 system for v7.3-rc4 with/without the patch
applied:

Execl Throughput, index score:

                    avg    %stdev      min        max
  v7.3-rc4        3511.5     0.44%    3494.5    3543.4
  + patch         4069.0     0.48%    4047.4    4109.5 (+15.9%)

Average wait on file rmap lock in ms, 5 runs per kernel:

               avg      %stdev     min       max
  v7.3-rc4    9.470     2.91%     9.070     9.820
  + patch     8.420     3.34%     8.100     8.770 (-11.1%)

Profiling data obtained during the operation highlighted the file rmap lock
as the primary source of contention.

Suggested-by: Pan Deng <pan.deng@intel.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
v2:
* Added Suggested-by, as per Pan.
* Added tags (Thanks Rik!)
* Updated commit message to provide perf data from Pan (thanks! :).
* Renamed pgoff_unchanged to file_pgoff_unchanged as per Pedro.
* Implemented mapping_rmap_tree_[pre, post]_update() and
  anon_rmap_tree_[pre, post]_update_vma() to separate out logic into the
  rmap/interval tree code as per Pedro.
* Since this change touched other code, and expand_upwards() is one such
  case, correctly mark it as pgoff unchanged.

v1:
https://lore.kernel.org/r/20260925-speed-up-inplace-rmap-v1-1-babc48ce7c83@kernel.org
---
 include/linux/mm.h                |  10 ++++
 mm/interval_tree.c                | 101 ++++++++++++++++++++++++++++++++++++++
 mm/vma.c                          |  74 +++++++++++-----------------
 mm/vma.h                          |   2 +
 tools/testing/vma/include/stubs.h |  22 +++++++++
 5 files changed, 164 insertions(+), 45 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6e71eaa4af3f..6da674fe3a93 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4357,6 +4357,12 @@ void mapping_rmap_tree_insert_after(struct vm_area_struct *vma,
 				    struct address_space *mapping);
 void mapping_rmap_tree_remove(struct vm_area_struct *vma,
 			      struct address_space *mapping);
+void mapping_rmap_tree_pre_update(struct vm_area_struct *vma,
+				  struct address_space *mapping,
+				  bool pgoff_unchanged);
+void mapping_rmap_tree_post_update(struct vm_area_struct *vma,
+				   struct address_space *mapping,
+				   bool pgoff_unchanged);
 struct vm_area_struct *
 mapping_rmap_tree_iter_first(struct address_space *mapping,
 			     pgoff_t pgoff_start, pgoff_t pgoff_last);
@@ -4374,6 +4380,10 @@ void anon_rmap_tree_insert(struct anon_vma_chain *avc,
 			   struct anon_vma *anon_vma);
 void anon_rmap_tree_remove(struct anon_vma_chain *avc,
 			   struct anon_vma *anon_vma);
+void anon_rmap_tree_pre_update_vma(struct vm_area_struct *vma,
+				   bool anon_pgoff_unchanged);
+void anon_rmap_tree_post_update_vma(struct vm_area_struct *vma,
+				    bool anon_pgoff_unchanged);
 struct anon_vma_chain *
 anon_rmap_tree_iter_first(struct anon_vma *anon_vma,
 			  pgoff_t pgoff_start, pgoff_t pgoff_last);
diff --git a/mm/interval_tree.c b/mm/interval_tree.c
index 7bbbf15cfbf0..9e24bb99fd80 100644
--- a/mm/interval_tree.c
+++ b/mm/interval_tree.c
@@ -64,6 +64,51 @@ void mapping_rmap_tree_remove(struct vm_area_struct *vma,
 	__mapping_rmap_tree_remove(vma, &mapping->i_mmap);
 }
 
+static void mapping_rmap_tree_update_inplace(struct vm_area_struct *vma)
+{
+	/* Propagate all the way up the tree. */
+	__mapping_rmap_tree_augment.propagate(&vma->shared.rb, NULL);
+}
+
+/**
+ * mapping_rmap_tree_pre_update() - Prepare the file rmap tree for a change to
+ * be made to @vma.
+ * @vma: The VMA about to be updated.
+ * @mapping: The file rmap to which @vma belongs.
+ * @pgoff_unchanged: Whether @vma's page offset will remain unchanged.
+ *
+ * The file rmap lock must be held across the entire update.
+ */
+void mapping_rmap_tree_pre_update(struct vm_area_struct *vma,
+				  struct address_space *mapping,
+				  bool pgoff_unchanged)
+{
+	/* If the pgoff has changed, then remove and reinsert afterwards. */
+	if (!pgoff_unchanged)
+		mapping_rmap_tree_remove(vma, mapping);
+}
+
+/**
+ * mapping_rmap_tree_post_update() - Update the file rmap tree to reflect a
+ * change that has been made to @vma.
+ * @vma: The VMA that has been updated.
+ * @mapping: The file rmap to which @vma belongs.
+ * @pgoff_unchanged: Whether @vma's page offset remained unchanged.
+ *
+ * mapping_rmap_tree_pre_update() must have been called prior to this.
+ *
+ * The file rmap lock must be held across the entire update.
+ */
+void mapping_rmap_tree_post_update(struct vm_area_struct *vma,
+				   struct address_space *mapping,
+				   bool pgoff_unchanged)
+{
+	if (pgoff_unchanged)
+		mapping_rmap_tree_update_inplace(vma);
+	else
+		mapping_rmap_tree_insert(vma, mapping);
+}
+
 struct vm_area_struct *
 mapping_rmap_tree_iter_first(struct address_space *mapping,
 			     pgoff_t pgoff_start, pgoff_t pgoff_last)
@@ -111,6 +156,62 @@ void anon_rmap_tree_remove(struct anon_vma_chain *avc,
 	__anon_rmap_tree_remove(avc, &anon_vma->rb_root);
 }
 
+static void anon_rmap_tree_update_inplace(struct anon_vma_chain *avc)
+{
+#ifdef CONFIG_DEBUG_VM_RB
+	avc->cached_vma_last = avc_last_pgoff(avc);
+#endif
+	/* Propagate all the way up the tree. */
+	__anon_rmap_tree_augment.propagate(&avc->rb, NULL);
+}
+
+/**
+ * anon_rmap_tree_pre_update_vma() - Prepare the anon rmap trees for a change
+ * to be made to @vma.
+ * @vma: The VMA about to be updated, which has an anon rmap assigned and is
+ *       already inserted on its interval trees.
+ * @anon_pgoff_unchanged: Whether @vma's anonymous page offset will remain
+ *                        unchanged.
+ *
+ * The anon rmap lock must be held across the entire update.
+ */
+void anon_rmap_tree_pre_update_vma(struct vm_area_struct *vma,
+				   bool anon_pgoff_unchanged)
+{
+	struct anon_vma_chain *avc;
+
+	if (anon_pgoff_unchanged)
+		return;
+
+	/* If the pgoff has changed, then remove and reinsert afterwards. */
+	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
+		anon_rmap_tree_remove(avc, avc->anon_vma);
+}
+
+/**
+ * anon_rmap_tree_post_update_vma() - Update the anon rmap trees to reflect a
+ * change that has been made to @vma.
+ * @vma: The VMA that has been updated.
+ * @anon_pgoff_unchanged: Whether @vma's anonymous page offset remained
+ *                        unchanged.
+ *
+ * anon_rmap_tree_pre_update_vma() must have been called prior to this.
+ *
+ * The anon rmap lock must be held across the entire update.
+ */
+void anon_rmap_tree_post_update_vma(struct vm_area_struct *vma,
+				    bool anon_pgoff_unchanged)
+{
+	struct anon_vma_chain *avc;
+
+	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma) {
+		if (anon_pgoff_unchanged)
+			anon_rmap_tree_update_inplace(avc);
+		else
+			anon_rmap_tree_insert(avc, avc->anon_vma);
+	}
+}
+
 struct anon_vma_chain *
 anon_rmap_tree_iter_first(struct anon_vma *anon_vma,
 			  pgoff_t pgoff_start, pgoff_t pgoff_last)
diff --git a/mm/vma.c b/mm/vma.c
index 077e23694143..ad6be42cc65a 100644
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
+		vp->file_pgoff_unchanged = true;
+	if (vma_start_anon_pgoff(vma) == vmg_start_anon_pgoff(vmg))
+		vp->anon_pgoff_unchanged = true;
 }
 
 /*
@@ -299,38 +306,6 @@ static void __remove_shared_vm_struct(struct vm_area_struct *vma,
 	flush_dcache_mmap_unlock(mapping);
 }
 
-/*
- * vma has an anon rmap assigned, and is already inserted on its interval
- * trees.
- *
- * Before updating the vma's vm_start / vm_end / vm_pgoff fields, the
- * vma must be removed from the anon rmap's interval trees using
- * anon_rmap_tree_pre_update_vma().
- *
- * After the update, the vma will be reinserted using
- * anon_rmap_tree_post_update_vma().
- *
- * The entire update must be protected by exclusive mmap_lock and by
- * the anon rmap root lock.
- */
-static void
-anon_rmap_tree_pre_update_vma(struct vm_area_struct *vma)
-{
-	struct anon_vma_chain *avc;
-
-	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
-		anon_rmap_tree_remove(avc, avc->anon_vma);
-}
-
-static void
-anon_rmap_tree_post_update_vma(struct vm_area_struct *vma)
-{
-	struct anon_vma_chain *avc;
-
-	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
-		anon_rmap_tree_insert(avc, avc->anon_vma);
-}
-
 /*
  * vma_prepare() - Helper function for handling locking VMAs prior to altering
  * @vp: The initialized vma_prepare struct
@@ -359,16 +334,19 @@ static void vma_prepare(struct vma_prepare *vp)
 
 	if (vp->anon_vma) {
 		anon_vma_lock_write(vp->anon_vma);
-		anon_rmap_tree_pre_update_vma(vp->vma);
+		anon_rmap_tree_pre_update_vma(vp->vma, vp->anon_pgoff_unchanged);
+		/* The adjacent VMA's start is moved, so its page offset changes. */
 		if (vp->adj_next)
-			anon_rmap_tree_pre_update_vma(vp->adj_next);
+			anon_rmap_tree_pre_update_vma(vp->adj_next, false);
 	}
 
 	if (vp->file) {
 		flush_dcache_mmap_lock(vp->mapping);
-		mapping_rmap_tree_remove(vp->vma, vp->mapping);
+		mapping_rmap_tree_pre_update(vp->vma, vp->mapping,
+					     vp->file_pgoff_unchanged);
 		if (vp->adj_next)
-			mapping_rmap_tree_remove(vp->adj_next, vp->mapping);
+			mapping_rmap_tree_pre_update(vp->adj_next, vp->mapping,
+						     false);
 	}
 
 }
@@ -386,8 +364,10 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 {
 	if (vp->file) {
 		if (vp->adj_next)
-			mapping_rmap_tree_insert(vp->adj_next, vp->mapping);
-		mapping_rmap_tree_insert(vp->vma, vp->mapping);
+			mapping_rmap_tree_post_update(vp->adj_next, vp->mapping,
+						      false);
+		mapping_rmap_tree_post_update(vp->vma, vp->mapping,
+					      vp->file_pgoff_unchanged);
 		flush_dcache_mmap_unlock(vp->mapping);
 	}
 
@@ -406,9 +386,9 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 	}
 
 	if (vp->anon_vma) {
-		anon_rmap_tree_post_update_vma(vp->vma);
+		anon_rmap_tree_post_update_vma(vp->vma, vp->anon_pgoff_unchanged);
 		if (vp->adj_next)
-			anon_rmap_tree_post_update_vma(vp->adj_next);
+			anon_rmap_tree_post_update_vma(vp->adj_next, false);
 		anon_vma_unlock_write(vp->anon_vma);
 	}
 
@@ -593,6 +573,8 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 
 	init_vma_prep(&vp, vma);
 	vp.insert = new;
+	vp.file_pgoff_unchanged = !new_below;
+	vp.anon_pgoff_unchanged = !new_below;
 	vma_prepare(&vp);
 
 	/*
@@ -1346,6 +1328,8 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	vma_start_write(vma);
 
 	init_vma_prep(&vp, vma);
+	vp.file_pgoff_unchanged = true;
+	vp.anon_pgoff_unchanged = true;
 	vma_prepare(&vp);
 	vma_adjust_trans_huge(vma, vma->vm_start, end, NULL);
 
@@ -3453,11 +3437,11 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 				if (vma_test(vma, VMA_LOCKED_BIT))
 					mm->locked_vm += grow;
 				vm_stat_account(mm, vma->vm_flags, grow);
-				anon_rmap_tree_pre_update_vma(vma);
+				anon_rmap_tree_pre_update_vma(vma, true);
 				vma->vm_end = address;
 				/* Overwrite old entry in mtree. */
 				vma_iter_store_overwrite(&vmi, vma);
-				anon_rmap_tree_post_update_vma(vma);
+				anon_rmap_tree_post_update_vma(vma, true);
 
 				perf_event_mmap(vma);
 			}
@@ -3530,12 +3514,12 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 				if (vma_test(vma, VMA_LOCKED_BIT))
 					mm->locked_vm += grow;
 				vm_stat_account(mm, vma->vm_flags, grow);
-				anon_rmap_tree_pre_update_vma(vma);
+				anon_rmap_tree_pre_update_vma(vma, false);
 				vma->vm_start = address;
 				vma_sub_pgoff(vma, grow);
 				/* Overwrite old entry in mtree. */
 				vma_iter_store_overwrite(&vmi, vma);
-				anon_rmap_tree_post_update_vma(vma);
+				anon_rmap_tree_post_update_vma(vma, false);
 
 				perf_event_mmap(vma);
 			}
diff --git a/mm/vma.h b/mm/vma.h
index 7a683272c0a8..074419f2c102 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -28,6 +28,8 @@ struct vma_prepare {
 	struct vm_area_struct *remove2;
 
 	bool skip_vma_uprobe :1;
+	bool file_pgoff_unchanged :1;
+	bool anon_pgoff_unchanged :1;
 };
 
 struct unlink_vma_file_batch {
diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
index e4acc6f1fe7b..5d4944581b8d 100644
--- a/tools/testing/vma/include/stubs.h
+++ b/tools/testing/vma/include/stubs.h
@@ -267,6 +267,18 @@ static inline void mapping_rmap_tree_remove(struct vm_area_struct *vma,
 {
 }
 
+static inline void mapping_rmap_tree_pre_update(struct vm_area_struct *vma,
+						struct address_space *mapping,
+						bool pgoff_unchanged)
+{
+}
+
+static inline void mapping_rmap_tree_post_update(struct vm_area_struct *vma,
+						 struct address_space *mapping,
+						 bool pgoff_unchanged)
+{
+}
+
 static inline void flush_dcache_mmap_unlock(struct address_space *mapping)
 {
 }
@@ -281,6 +293,16 @@ static inline void anon_rmap_tree_remove(struct anon_vma_chain *avc,
 {
 }
 
+static inline void anon_rmap_tree_pre_update_vma(struct vm_area_struct *vma,
+						 bool anon_pgoff_unchanged)
+{
+}
+
+static inline void anon_rmap_tree_post_update_vma(struct vm_area_struct *vma,
+						  bool anon_pgoff_unchanged)
+{
+}
+
 static inline void uprobe_mmap(struct vm_area_struct *vma)
 {
 }

---
base-commit: e8d0f6a1b2a447d02845984fa6288787543cb03c
change-id: 20260925-speed-up-inplace-rmap-808fbb3848f5

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


