Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 795CE60A261C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 03:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=oEIIGS9K
Received: by kanga.kvack.org (Postfix)
	id 826C66B05B3; Sun, 22 Nov 2026 22:43:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D0A46B05B4; Sun, 22 Nov 2026 22:43:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E6716B05B5; Sun, 22 Nov 2026 22:43:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EE756B05B3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:43:48 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AFF8B1A0782
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:43:47 +0000 (UTC)
X-FDA: 85464989694.09.5DBC343
Received: from mta0.migadu.com (out-218.mta0.migadu.com [91.218.175.218])
	by imf30.hostedemail.com (Postfix) with ESMTP id AB13E80002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:43:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oEIIGS9K;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.218 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795405426;
	b=fTyBaoWlFN4DgUbxYLhUppOjRIno5AcGICMHthh+Xw0jpMG+zelqhVWi5/DrwBasMlfstY
	g5Kiac11ncOvuqAlfOCVFcMP61yZnKOq2vlRW4VB94cBhsP0zKeWyBM+D9gnrGLPLCpaon
	yg+HDQSoPg5mvMeE6DAssEM8XxxoZ+c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795405426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/dSSnvt29VXMuqEAAa81mXAdbrbhqEv++QT9+xRYhg=;
	b=Fhml5TI6BS8NaE268AJcWnsFtavKk6pTzlvVbs9WlSPNGfcOElVJe2pI+soKKcb68+wlia
	OFzIgs0uhtTayzqRVIOe+j0yNPWnsln3b8S8qOB9RmFI7SbA34XC6Y40ykdAnP7TSh9nbP
	RKNZHGhoXCPCAW9+c8+a9Bi7B6O7VPg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oEIIGS9K;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.218 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=u4K0EQqDi4+xhHfJPHjH7LQ7MYMicDcjgwVFleEBNuM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795405424; v=1; x=1796010224;
 b=oEIIGS9Ka5spYlhYLlfawa+ZXJ12Zna0ZEFeJEE7giXqmS3hI6VfU5abnWm9O5dKcBXdhDr3
 chFS9abhBmm/TkSVGVES9Fbe9qxxhndJ2h06+g34MMv9B9xjfE5uGLlQjOAPDphORiVdJwtVHXf
 T8NO827T1NAkp4Q7nbd81vvk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id cec765d6627a4390;
	Mon, 23 Nov 2026 03:43:44 +0000
X-Mizu-Trace-ID: cec765d6627a4390
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
Subject: [PATCH v3 1/3] mm/ksm: do not inherit ksm_zero_pages counter or PTE markers on fork
Date: Mon, 23 Nov 2026 11:43:31 +0800
Message-Id: <20261123034331.236509-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261123034136.209410-1-xu.xin@linux.dev>
References: <20261123034136.209410-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AB13E80002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: cuooshpc3zy7n4fqckxnk4y3pkrsx35a
X-HE-Tag: 1795405425-276703
X-HE-Meta: U2FsdGVkX19S/U2B1Y1OH/YPXNs1lMgY6qUymtduR75IVGlydeLMK9pxIYhaCyWY++d+ACpsb+uP/ohKLsjapvWheE5WbEIr75w4OfPw6rpHEZITdRbA6fJEggSjmW7OFhVhTX8X0jUV56xt7GlgMGLp0r3wlp6FSDqTSHM5k2LLjeAhPJDtK6m0IYXXO2ipYXzns8HNT4Bq9RVDzozimPxNfE01GfiJ0Ftips39nNwqah66/zRcF8RmWjECWz/dfw4xoOUWzkYugc5wqhflKzXaZL7h6ZGcR+FmTKNd8O1ZeHbrpxOdz44VeAOQQT6CpGIvkJHFwfMw31Fn8L0vY280DyzKH7rjWaC70oinyAJudoTtvlX6dAN2sjDVDt+VA13BcX9Dr/t/xOcKYHi9+WiiZ0H97EvbW+I3dFX9aykdid+dhq7nRlwXDnUEZkV8iNJ02S1OVO6stFIObCW2pWkKuyen2UhHsgE5BO6b0sE1S4pFtm+xnfBHAG1KfkAzaa6/iH2LB4N11P36b5oJ40p4QYnEf/OuKKVcKDydFxuD7OTLDPuOzGDM0jPfo1rjZYzkCNOmlRHIP1dqZfMhz+pGZYp3c9D9AGupxHdnFc4RSsu7ekRPH1FmUwWsELaXY3r4euyj60XnXd8ETJlEp+FxPKziThteWpBdA++x3qj5zapnTkN1tU0AEfWGWKXXy7C5bxJ2PQDFXJpnOeshSoQLSo6vmJHXcPpFPsglEXsG3pCeMDUVJXqO9psGM1Dhe2tFU3hJzdazfHUTZyIoX9bSHkkipZAcbgfVo8+Olm44GL6ATp6avWCD5F+oG3sfibC5pHOdybmwrzE5uCoooN1Uj7+GGRt3jn9rWV1XNDPL4gmVF2pF+bbjSztxK0TArHRTk/y5vu8bcqLCptSZ+M+bQeLjz640Q4Z7WkTGpnC6T7YHqtFttBXg3MdozXXnQLgNM9Cqys3SHF/fk6v
 59vOdgXZ
 nMqWea785C9ux2f2OGYnu8U3HnFh4/NAj2I8NDe00qELPX1t0JQZIElzCxjTLDvMakt+hrKtalJBbmt/Y1t7phjFYF9yFVT70EqNkIiqEKCUm7fJw1bbiO6oWq2jjQ9DNomVpyYjfh1BYrAnho3SPQptoGAA50kcaeyJv20cv8js9fcs/OUVuI3z9du5ygPL52Yket4yMxLjuIuNUt5lRyML/TIFb06zqAA1p+x0kIFnpIFE/bGXrcojyd6Vc66vo60YzSvPwSsD2+jzK8RfqAFWVEkFG+Du4vCR206TkadVPCNYeg8+4qPU0MDjF0fOpCTYA/hT0MZ9qXnHBON661ULallAAr/Ef/23C/joVXldpJyrBp1P6d39f4lWL8sN/1zT3MkutAvVX8wcFFXQHFGlMxgRhsBQUXfxFp7KBDxEACyb3d6rhNis0NOBAKM1vCpE1rYCx6aCr9gpe9PIuI1Zlsfjx5CASSAfdElDhNyNmantIN0xe17ZN5EgGl3jib30Itam0cMTXeKyuTxdZsXD2BLVYFTATmftUsZvHvAaHsaI=
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
Changes in v3:
- Rename might_clear_ksm_zero_pte() to ksm_fork_pte() and move the
  is_ksm_zero_pte() check into copy_present_ptes() under the !page
  branch, as suggested by David Hildenbrand.
- Expand the comment above ksm_fork_pte() to explain why the marker is
  cleared on fork.
- Add Tested-by tag from Karl Mehltretter.

 Documentation/admin-guide/mm/ksm.rst |  7 ++++++-
 include/linux/ksm.h                  | 22 +++++++++++++++++++---
 mm/memory.c                          |  5 ++++-
 3 files changed, 29 insertions(+), 5 deletions(-)

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
index 596c04ca7326..f29aec4496d0 100644
--- a/include/linux/ksm.h
+++ b/include/linux/ksm.h
@@ -32,6 +32,17 @@ void __ksm_exit(struct mm_struct *mm);
  */
 #define is_ksm_zero_pte(pte)	(is_zero_pfn(pte_pfn(pte)) && pte_dirty(pte))
 
+/*
+ * Since the inherited mappings on fork are not expected to be accounted for
+ * in the child's ksm_zero_pages counter (reset in ksm_fork()), we must
+ * clear KSM's dirty-bit marker on KSM-placed zero-page PTEs to avoid
+ * underflowing the counters on child exit.
+ */
+static inline pte_t ksm_fork_pte(pte_t pte)
+{
+	return pte_mkclean(pte);
+}
+
 extern atomic_long_t ksm_zero_pages;
 
 static inline void ksm_map_zero_page(struct mm_struct *mm)
@@ -57,11 +68,9 @@ static inline void ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
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
@@ -95,6 +104,8 @@ bool ksm_process_mergeable(struct mm_struct *mm);
 
 #else  /* !CONFIG_KSM */
 
+#define is_ksm_zero_pte(pte)	false
+
 static inline vma_flags_t ksm_vma_flags(struct mm_struct *mm,
 		const struct file *file, vma_flags_t vma_flags)
 {
@@ -114,6 +125,11 @@ static inline void ksm_exit(struct mm_struct *mm)
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


