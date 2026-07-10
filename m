Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FF11C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 05:59:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A4206B0093; Fri, 10 Jul 2026 01:59:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87C0E6B0095; Fri, 10 Jul 2026 01:59:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 792646B0096; Fri, 10 Jul 2026 01:59:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 573996B0093
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:59:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D9313403A9
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:59:42 +0000 (UTC)
X-FDA: 84971815404.25.D383511
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0272840006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:59:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HxLlEY6O;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783663181;
	b=YFm2ersvbjbXIp3HKaKTEDyfMWhV+fMnGRvlSkkE9enfQ/VcI2uIGaginnKLgfkoYLX0jL
	lgW7/QOv8DB/OUKEUMc4FnxoDUAmKxWL7IfDSiiFgzgX54d+xqLdEC2CCJcAdCKwPNCR+W
	kkLZFBZUwy3VZjKjiJYGw4E02EaFtI4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HxLlEY6O;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783663181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xNBfcO5MJ4m6GM8tuJmSc882ckVdfuRkPs1UsllBZ6c=;
	b=1yQcH8EIK30dm+Edi4iHad69KZV9TMENQlhO3cu9D7iX7B82BC2MIWIxJqg5zSsofXcuMU
	YDYoXtiG9u3zIqk8sVxssP4Cxq0xJkdcV4Z9fQx898N584dq51MnBOOtUlGHbR5ZRe480D
	s5MtqL9xKh2OtMWYKLryI5P+74AY6Ms=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D8C4A1EDB;
	Thu,  9 Jul 2026 22:59:35 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D91483F85F;
	Thu,  9 Jul 2026 22:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783663180; bh=FgUtsZV87Er+LpX20OEApXF+QJbBQ1nWb1Paa5r9bWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HxLlEY6OT2vv9Fxt5/aE5ju6W4pRN2XA+v8I4kX/p2/h7gVqCLPWVxJhNcBLAOFid
	 bSznY/cn9nA0UiI+6ksyeN57JByqiUeiluKFevbtJ91o5aA4DQEi8lYAKT6bl+NrpU
	 5W4pNydy9Mh6gpppSzwhx3xWbMqPZzxmHs+IUAiU=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v2 3/5] mm/rmap: refactor some code around lazyfree folio unmapping
Date: Fri, 10 Jul 2026 05:59:12 +0000
Message-ID: <20260710055915.638659-4-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260710055915.638659-1-dev.jain@arm.com>
References: <20260710055915.638659-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0272840006
X-Stat-Signature: sujk8xhuyukqdunaz1xe3em8bf6kg6de
X-HE-Tag: 1783663180-501331
X-HE-Meta: U2FsdGVkX18EZ1NH1YaSA+LwBlrDpAlup3QlBjqOlPGN7mpPPEG5tIOwOsiRiXeGgt3P6g3NjCO/JDBiBQ1UheHDVLKrJsp6/mWummVSk0vpWI/yHxyQFOIA2B05gbjbBgcq0Nmktdis25sCDc+FU8wLfWJR8tudVzkQ1Jj5CXFJTIdOZz6xxKCxU4E86d8b5ey9MFIRnkUbbGyDKFVTXXXqyv78BZ7XaCrlz6V18qHB0Q7kAYOTbkS7OXW62QTfe8jQXxBbqLjCUMhXcIw7nTatQ/Nc6Kcv620lDw0FlcWi/JDXEKr8ZsSeIrUKLoSEzwHWhF1VbCK1h/wUBqrlHeSnbPuDvWMc6Y14qU7XcVpSDJFBYlZBOBt6VFo22+g+niLEmVm0PDJt8bQ/sX1J+ITi4xu95GZKsRd6b3dh6z9zz54KXSXQhRT3MF027kBV2IFh1gJ2QtyV1e5wupBAZis05NT9yRvwScgKGojLnCuGhWKgkLLhQ1fG1nhZGZAQgtpFYDJiXfI76FEAOSJ9CM0h44x+JGjVJVF6HI2pb++c936wgE72ZnJTIBqzDORU8I7RRh+Q+uoZnZTPUucnXLcF5QofINK36MfMVYdOrB03VXl2DygbbLe+RLfYdREQ3x5nI36wbRQb8Pyao84Zf9f07qKj4bX7uhAqdfboeyZS9JN3blZrGMnjVrBZLzbjN6uWTYK/SoRHMwFq8tvCnWHzf8tjRv4Re1fuzsdqvktBrJvB/sMkYjrtxegRBIGhnkvce4cSFS5zhZYF7QJnRze2tbxg8PR6XPyAT1Q4fySLcjyn/sSDQGK5inDAdQYlbgeC8PRYLAI9AYYK7kmjltQe59zJy2szEwUWS4e3HrHbz0fede1Wn3Pl/z1bH+Era9/RALGcK+MRhwbtVVTaqdardIu8+FQSiODHccbdTygDQv7PKMeFcZjv5Qv6apKk21y4hFkIn8/uo1eK7Iu
 JVQmoQUA
 SUv+r2+O+uHdUKxnrJVN81DcbesV47yrUXb1MqGCOBJYrf9OCz38a76jVii0srwU6p8H5sa1TrEelmUW/Q6KXv3vVy8dYNVJpVflZA66VbBQ3hMddY0WnVtpi7bt1E2L0ziBCGF2dQ0lTHdbcLSzTt/dA18InrIFf6AVT+eD/hZwZmgJWYG4ZoidIgfKYUmOPd94By5WfBkhJJocuQvG6QcW2uGa+5tQ5kIXXgP126P6RNTnT7lc8Qz7fQSRxByI7NSfG84aDsvRa7yo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For lazyfree folio unmapping, after clearing the ptes we must abort the
operation if the folio got dirtied or it has unexpected references.

Refactor this logic into a function which will return whether we need
to abort or not.

If we abort, we restore the ptes and bail out of try_to_unmap_one.
Otherwise adjust the rss stats of the mm and jump to a label.

Also rename that label from "discard" to "finish_unmap"; the former
is appropriate in the lazyfree context, but the code following the label
is executed for other successful unmap code paths too, so 'discard' does
not sound correct for them.

No functional change intended.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 87 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 48 insertions(+), 39 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index cf02b315a2ead..4851c9f2a34e7 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2068,6 +2068,50 @@ static bool try_to_unmap_hugetlb_one(struct folio *folio,
 	return ret;
 }
 
+static bool ttu_anon_lazyfree_folio(struct vm_area_struct *vma,
+		struct folio *folio, unsigned long nr_pages)
+{
+	int ref_count, map_count;
+
+	/*
+	 * Synchronize with gup_pte_range():
+	 * - clear PTE; barrier; read refcount
+	 * - inc refcount; barrier; read PTE
+	 */
+	smp_mb();
+
+	ref_count = folio_ref_count(folio);
+	map_count = folio_mapcount(folio);
+
+	/*
+	 * Order reads for page refcount and dirty flag
+	 * (see comments in __remove_mapping()).
+	 */
+	smp_rmb();
+
+	if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
+		/*
+		 * redirtied either using the page table or a previously
+		 * obtained GUP reference.
+		 */
+		folio_set_swapbacked(folio);
+		return false;
+	}
+
+	/*
+	 * Additional references could be due to GUP or speculative lookups.
+	 * GUP users must mark the folio dirty if there was a modification.
+	 * This folio cannot be reclaimed right now either way, so act just
+	 * like nothing happened. We'll come back here later and detect if the
+	 * folio was dirtied when the additional reference is gone.
+	 */
+	if (ref_count != 1 + map_count)
+		return false;
+
+	add_mm_counter(vma->vm_mm, MM_ANONPAGES, -nr_pages);
+	return true;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -2264,47 +2308,12 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 			/* MADV_FREE page check */
 			if (!folio_test_swapbacked(folio)) {
-				int ref_count, map_count;
-
-				/*
-				 * Synchronize with gup_pte_range():
-				 * - clear PTE; barrier; read refcount
-				 * - inc refcount; barrier; read PTE
-				 */
-				smp_mb();
-
-				ref_count = folio_ref_count(folio);
-				map_count = folio_mapcount(folio);
-
-				/*
-				 * Order reads for page refcount and dirty flag
-				 * (see comments in __remove_mapping()).
-				 */
-				smp_rmb();
-
-				if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
-					/*
-					 * redirtied either using the page table or a previously
-					 * obtained GUP reference.
-					 */
-					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
-					folio_set_swapbacked(folio);
-					goto walk_abort;
-				} else if (ref_count != 1 + map_count) {
-					/*
-					 * Additional reference. Could be a GUP reference or any
-					 * speculative reference. GUP users must mark the folio
-					 * dirty if there was a modification. This folio cannot be
-					 * reclaimed right now either way, so act just like nothing
-					 * happened.
-					 * We'll come back here later and detect if the folio was
-					 * dirtied when the additional reference is gone.
-					 */
+				if (!ttu_anon_lazyfree_folio(vma, folio,
+							     nr_pages)) {
 					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
 					goto walk_abort;
 				}
-				add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
-				goto discard;
+				goto finish_unmap;
 			}
 
 			if (folio_dup_swap(folio, subpage) < 0) {
@@ -2362,7 +2371,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
 		}
-discard:
+finish_unmap:
 		folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_drain_local();
-- 
2.43.0


