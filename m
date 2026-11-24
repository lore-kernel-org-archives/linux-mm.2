Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB21F606A327
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Me35IaIN
Received: by kanga.kvack.org (Postfix)
	id EFD556B06AD; Tue, 24 Nov 2026 08:03:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EADDE6B06AF; Tue, 24 Nov 2026 08:03:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEB136B06B0; Tue, 24 Nov 2026 08:03:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B83116B06AD
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:03:24 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 48710160A31
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:03:24 +0000 (UTC)
X-FDA: 85470028728.17.AF7B94E
Received: from mta0.migadu.com (out-252.mta0.migadu.com [91.218.175.252])
	by imf08.hostedemail.com (Postfix) with ESMTP id 18B85160012
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:03:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Me35IaIN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.252 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795525402;
	b=Us4ulDO5uqYGXVfg5mT4QgS5cY5Udg2lyUk8e4/m7dLTJ6ocAuQKWrs7BkQaZ8Y+xaGCQM
	3ospOkEhyzLySP/w3sGlli3U6k3gbP30dbFdzBKGBAcseaa8mGaTfxI3tav5CobKQCiyvK
	KNNRHW5wgCtjBXAcmhRlt7807nTVh/s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795525402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JVHLEYAxNa4Dvgv8Io3xDvD4y7L4a95BYkxQq8J9m/U=;
	b=FkKHl1JZo4i8Lm02nzCUUv18b8rurxNVzVyr+kmV7WyJ/GxrHvOed/WMb035LoWcwPDtka
	4zmI5FS1ThaSKIbS6mE+MGBYA+6bXWqDsyNy6iqvkLpFzXpCNg70ZW5Q46zruogkUq6ix+
	1sK0VYw+lJgc2B8K1yPROV0oaDDLamc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Me35IaIN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.252 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Fu0rsKQAZrfCktxfotE/Ohpe0PhLWQFg59dQ6VQp7fE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795525400; v=1; x=1796130200;
 b=Me35IaINL1brybDQNfdKd5AR1sK57ARturyPZZR3lK9s4JqbLC37U1TjduX5oYG5wghvCwIb
 SD8SZ3bIRgSEDJDJId9TfdO998++vtGXWGmJqHdSDiDBEcu/2F+xV5Xc8j7C95WO0dxs/vVmEOe
 3VVIw13B2NiU1JJKyU2S0qXM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id de87c2880bc93fb1;
	Tue, 24 Nov 2026 13:03:20 +0000
X-Mizu-Trace-ID: de87c2880bc93fb1
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: xu.xin@linux.dev
Cc: akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
	david@kernel.org,
	donettom@linux.ibm.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	Karl Mehltretter <kmehltretter@gmail.com>
Subject: [PATCH v4 1/3] mm/ksm: do not inherit ksm_zero_pages counter or PTE markers on fork
Date: Tue, 24 Nov 2026 21:03:10 +0800
Message-Id: <20261124130310.131140-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261124130143.128411-1-xu.xin@linux.dev>
References: <20261124130143.128411-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 18B85160012
X-Stat-Signature: qzeezy6crzc8pbx7cmhgwpd8meo65bbw
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795525401-557713
X-HE-Meta: U2FsdGVkX1/83awEnPL4Ys1YQmzUgh9vz2vM4Oh4Z2OMoVThJewWZOzqDLs/k/z1K76DwTdioyNG7iY0zLzo3Nx5lYKylN0JTeZ4NgyYiq39B/i+Y5vx+hRqKY581dxLMdkxgMjIFCWRCJ10etEyq/FcF4zeZXBZkDvEgk3YFbR9JIl59HVTNM7kEvbpFA537yCq0VGQpj+chv31fTCbR+USgSiuXxvnLNr+Q0KtqiAzmz3RpeCOM6bwuuys2EsAxpM5SNUWxX6UNgh67tUodaZG0Bb9plMKAJUGXe46J6XktJ6rKQbByO5JPwn5YoFbIM/nKSCGTkDJ97S0pR13z/j5zH5+DbYTtcbdbJoxsW5G25i6CeIzj4lCIPqsdTWEPfP6Fl//24aDgIOIYKvKKFOtAyfHn6jw9b5mpwd2CLpR7BxA8U7wgJAqUR0Czlc/6n0U2zDUcCCoSBm6J2CbFLZyVKPYwPYnoaLVjaFczYOWYtGcbY2N6Z2DcudKJr+UUzb6oL2P1pvr20J/2QZP+2+Y7DiC9KCp6aiUB8/PpTHYsbeaK1Bws8+Iu13YEIM3Ovsxmep9jkFTdndvB4X2uOwWb8bDQcI+f2GXCVkdj2ykGxsaN15sfpiZkM2Mg1t0hfbXBKF4FqhboWnWDIbvStspCh2l+jBlOboX5rqyr9l4pDJNwXraaIif46NzZPyswPV+n4+6TTXqOpX/MAPEA2yy4zFOGiGBflPV/2VxhaLYdi4Mf4zJiHGHNDpVTsoWM/LPUZrh85eczl5Q3s8qfvkrgvhuC9i3p7oRCiWVjPoZ+bHuwygDKR+Y0U4aoMp+HCpXYfqf6KNRfIRVH3VgMuPSFPLsPOoKPYzmyR23W9cugmhyy9DhsbTa/4uY//2IqWnJZEw0hIDymJY92XxM5qIR/BBlvev4cP1Y2QwgnKVCzLtdYRF8Ry4B2Lht5F7MV4FiiUWlIXjGYyTKHSw
 N9gvXrre
 JN2ED6gqyKozJU9el4UvaQK2QGqqGAmbkIeLt2eJL439xC0l0GXgRM9SJsS4yMRgCzyl2FasyhwUNe17+z83cETwNDLppbzOh7vxGpetiyc4I5wyj5yiqg1QCU65e6R/KAvnUUin3ppiYvpTTSYlggks50xNT44z46eR/k7FT2GU8dfLrhXUhUOFbzmL/qQHf5HGiMSzqkOU3+7cUjqYoN9ED/8ASMhUtZ23Cs7ggR6fK1sj4TIj2wIynjXFIXcX5dqwtVyd9XA1PWaJ/Vhsfq+m63p8QFHl1kV5fw0wYi/ARVIDdUAUPu2mxxwgiSAX24WwlFt9u/2dBxlTVQE04ecuBhdofbFwGE5djYRqrayptDapq+QMdEZTM8h1A6+BOvrdB2tNQkVQuIpMZMi1zwbo4C2Qszl2lNTUcTZaIBPytt5aDKXWmpzn/QBFmp9c3vy/yMwmS5JVGlvIE8WWmZ0Eo/V/82m8t+av7eTsW4CaSOV9DuOdA/CSANexU7KklIYM2wOG3+JUjDDjTmoHxaVNmT/keICLVthNCfYb5Ak0Q32Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

As documented in Documentation/admin-guide/mm/ksm.rst, ksm_zero_pages
accounts only for zero pages actually placed by KSM.  However, the
current implementation wrongly accounts for forked zero-page PTEs as
KSM's contribution, inflating both the child's per-mm counter and the
global ksm_zero_pages counter.

Originally, commit e2942062e01d ("ksm: count all zero pages placed by
KSM") marked KSM-placed zero-page PTEs with the dirty bit for unmap
accounting, but forgot to clear this marker during fork().  Later, to
prevent ksm_might_unmap_zero_page() from underflowing the counters on
child exit[1], commit 4d6fc29f3634 ("mm/ksm: fix incorrect KSM counter
handling in mm_struct during fork") kept the child's inherited per-mm
counter and added it to the global counter.

Instead of inflating the counters, fix the root cause by resetting the
child's mm->ksm_zero_pages to 0 in ksm_fork() and clearing the KSM
zero-page marker via ksm_fork_pte() when copying present PTEs in
copy_present_ptes().  With the marker cleared,
ksm_might_unmap_zero_page() will not decrement the counters on child
exit, MADV_UNMERGEABLE in the child will not unnecessarily unshare
inherited zero pages, and the global counter remains untouched.

[1] https://lore.kernel.org/all/53a7bf3d-843d-4e19-b0a3-cc6852fe72c1@redhat.com/

Fixes: 4d6fc29f3634 ("mm/ksm: fix incorrect KSM counter handling in mm_struct during fork")
Cc: stable@vger.kernel.org
Tested-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
---
Changes in v4:
- Replace the comments of ksm_fork_pte() with what David suggested.

 Documentation/admin-guide/mm/ksm.rst |  7 ++++++-
 include/linux/ksm.h                  | 24 +++++++++++++++++++++---
 mm/memory.c                          |  5 ++++-
 3 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/mm/ksm.rst b/Documentation/admin-guide/mm/ksm.rst
index c329ca747b8c..8968ae3f55c0 100644
--- a/Documentation/admin-guide/mm/ksm.rst
+++ b/Documentation/admin-guide/mm/ksm.rst
@@ -214,7 +214,12 @@ stable_node_dups
         number of duplicated KSM pages
 ksm_zero_pages
         how many zero pages that are still mapped into processes were mapped by
-        KSM when deduplicating.
+        KSM when deduplicating. Note: on fork(), the child process does not
+        inherit the ``ksm_zero_pages`` counter, and any inherited KSM-placed
+        zero-page mappings are converted into ordinary shared zero-page
+        mappings. Consequently, these mappings are neither accounted for in
+        the child's counter nor unshared when ``MADV_UNMERGEABLE`` is called
+        in the child.
 
 When ``use_zero_pages`` is/was enabled, the sum of ``pages_sharing`` +
 ``ksm_zero_pages`` represents the actual number of pages saved by KSM.
diff --git a/include/linux/ksm.h b/include/linux/ksm.h
index 596c04ca7326..276bee5af80a 100644
--- a/include/linux/ksm.h
+++ b/include/linux/ksm.h
@@ -32,6 +32,16 @@ void __ksm_exit(struct mm_struct *mm);
  */
 #define is_ksm_zero_pte(pte)	(is_zero_pfn(pte_pfn(pte)) && pte_dirty(pte))
 
+/*
+ * Strip KSM information from the PTE for the child to simplify
+ * ksm_zero_pages accounting, and to indicate each deduplicated zeropage
+ * only once towards the user.
+ */
+static inline pte_t ksm_fork_pte(pte_t pte)
+{
+	return pte_mkclean(pte);
+}
+
 extern atomic_long_t ksm_zero_pages;
 
 static inline void ksm_map_zero_page(struct mm_struct *mm)
@@ -57,11 +67,9 @@ static inline void ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
 	/* Adding mm to ksm is best effort on fork. */
 	if (mm_flags_test(MMF_VM_MERGEABLE, oldmm)) {
-		long nr_ksm_zero_pages = atomic_long_read(&mm->ksm_zero_pages);
-
 		mm->ksm_merging_pages = 0;
 		mm->ksm_rmap_items = 0;
-		atomic_long_add(nr_ksm_zero_pages, &ksm_zero_pages);
+		atomic_long_set(&mm->ksm_zero_pages, 0);
 		__ksm_enter(mm);
 	}
 }
@@ -95,6 +103,11 @@ bool ksm_process_mergeable(struct mm_struct *mm);
 
 #else  /* !CONFIG_KSM */
 
+static inline bool is_ksm_zero_pte(pte_t pte)
+{
+	return false;
+}
+
 static inline vma_flags_t ksm_vma_flags(struct mm_struct *mm,
 		const struct file *file, vma_flags_t vma_flags)
 {
@@ -114,6 +127,11 @@ static inline void ksm_exit(struct mm_struct *mm)
 {
 }
 
+static inline pte_t ksm_fork_pte(pte_t pte)
+{
+	return pte;
+}
+
 static inline void ksm_might_unmap_zero_page(struct mm_struct *mm, pte_t pte)
 {
 }
diff --git a/mm/memory.c b/mm/memory.c
index 6a23198c1c67..f0b5df879e6f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1184,8 +1184,11 @@ copy_present_ptes(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma
 	int err, nr;
 
 	page = vm_normal_page(src_vma, addr, pte);
-	if (unlikely(!page))
+	if (unlikely(!page)) {
+		if (unlikely(is_ksm_zero_pte(pte)))
+			pte = ksm_fork_pte(pte);
 		goto copy_pte;
+	}
 
 	folio = page_folio(page);
 
-- 
2.34.1


