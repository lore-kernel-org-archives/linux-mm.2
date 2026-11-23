Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5038606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 03:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=sym98uDI
Received: by kanga.kvack.org (Postfix)
	id 5426F6B05B1; Sun, 22 Nov 2026 22:43:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E9F66B05B2; Sun, 22 Nov 2026 22:43:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4270B6B05B3; Sun, 22 Nov 2026 22:43:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A7B36B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:43:26 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 87EE1A8427
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:43:22 +0000 (UTC)
X-FDA: 85464988644.18.DC1BF6D
Received: from mta1.migadu.com (out-200.mta1.migadu.com [95.215.58.200])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9A83140006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:43:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sym98uDI;
	spf=pass (imf04.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.200 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795405400;
	b=yqYptutWn/Aynn9HJaFF2re8GmNzAn5s3vzlMR0CejSk6K10YldiWQM+fU8DJy4R6/MAcR
	x/RvnHKISUiTR8+iZNR6z/C9H76vCDk90WpRBRs0eRfWuEK7k7YNTDrzCKD2YRPqhVPRMv
	53qbmsL2DQ6Vtl8nX+1PEf49heHmBrw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795405400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/dSSnvt29VXMuqEAAa81mXAdbrbhqEv++QT9+xRYhg=;
	b=CSC59AmxGTPKMUqPOdF0JUBo50R1OgkG455opYHAU28pTKb90q9tBQuryz9f+25FDy9sya
	sFbJRkcTuJWDTO2EYYhoOQkzlajb8KhYRrJXBKecMc7RL4rquoxexXRVCA+sB8rzcuKR/w
	+wGQmOW6tdC+KY9aw3uAxOy39Ns8Plo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sym98uDI;
	spf=pass (imf04.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.200 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=u4K0EQqDi4+xhHfJPHjH7LQ7MYMicDcjgwVFleEBNuM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795405399; v=1; x=1796010199;
 b=sym98uDIogUQEVzQ57BtWFFt9Lo0yVdauWGeKKZLwDg6jJADX1S8k4zgKh5ONHgbDFhurkMK
 n23ugOKub2PpV5+WNX0IZz83zQ0Q6CLMi5FsPRTiOi4sV9uGT8ZKJz8Vq0vQeAAG9l+Mf8rx+DV
 ZHFqO7Q4VPkh4Ai1On/OOOAg=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id b23e18659fa0a669;
	Mon, 23 Nov 2026 03:43:19 +0000
X-Mizu-Trace-ID: b23e18659fa0a669
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
Date: Mon, 23 Nov 2026 11:43:07 +0800
Message-Id: <20261123034307.236032-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261123034136.209410-1-xu.xin@linux.dev>
References: <20261123034136.209410-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 9A83140006
X-Stat-Signature: cuooshpc3zy7n4fqckxnk4y3pkrsx35a
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795405400-668144
X-HE-Meta: U2FsdGVkX1+4NSSw2eKsxbwgkqK6fS0lqmCG3NZyYubnlmLWPG5ltepuf80jXj50GvHJyGS6YESwOZXSx1/RGJ9HaMdeZtH+XGVt5HldD+sl5VB+81PTdohK8varFpXDCO9fcA98VyXrO434vAVtNHDbtxoidGvk4qjnOXoWICdZyZ5dfdGYGwXccFCrwc/zE6nSeXGqJzZpPe6Nzc+4i5IsQhUbwWufZm6u8i37i2pxOSwBAIRusfandfVjT0IJnA/LZuKMzx53XNn12hS5zEPq3cDkBVpZ99IpksWjXloLgqGBs5Hi97yPeHKbMeRPw0Wy4bmryNX2aKysiWxYqGh0CY5nPVwqZn7wS3HVsFYweHghyyQJKKzp8f5GPQhx3ncTENDW0ijZqiYzzyOsA79NAe+4Ql/WNyN9+t3Zsguy8YpKohAg/OvZRquttYn9LTKr0XwsgvEHAz/WE/XfSIR0gwFyhSXMVF5yR54eO0Z5HILBqSp9yylITOdRPfWA340mpv1gvwNoTJ6rZc4YXLMs3MCpBb74Ygvn8bVJFRjWmpK42AhCcQOxil6DgjgNekH52Y8zgAQb572OEzjlDp0StGLCwElK3rY0texbV7xeuEi4HeLlU2cnIWXUzgTsIEX3HhNLiRZaSulv0oB5+DayUCtBFDCF6EhU6kUM1Ie05AShH2N0M4yP4j8Kj2xGIBO2SijRntRmI82zsEc47uyVflPj3KRRf5TC7HwuUQrsKunXSuHWE8bz4X/xyebluodXPhO8+7iO7MajaTziIr86cJAkZVd3MyMBbVILHA6i6ZdfFaTCjqkG/VlVn5duHGsvRTPe5szcfIfThUpfpTAls023potTxY1/VW3bZMHV7dKShehkKyyj3+1PvVMMoKgHS4IdmKt6MV8dSIk7oAK6imhRCSgiIGcurzVndxcw6QNpi/t66zW7WdYpzppJPqY3yfl5kgmmC+7wgNt
 vL+1PM8+
 hl13JmFE/hG3WZag70h8iqMC9v49gYjZPMepE0M6kXHQbSmWOdyB5ZWOKbc7mgh6f5PLQFKHXOQWssuuXvcGRYZ1dPdYHUtLQ33WscV6ArPWEN9mb1Ia7z5zx9+KS9Iv+yKuTWYAsXRbzPDYN+XtE2RTd5h62aUxovKTRYdSSZ8VepS1P6XGHIWIUevfNeSAQkW72SXnYAg1GewXCzAmeQ9wRzr8qb8hNrXyTswv1cvnd1bOUbGCG1f0E/9bRGnFfK+D788ITfx83K9BPfOaUV+KTO99MXItqAPCUddBwAUEHZGkY1wjgcXNYCeTtccvHOdxp014LH1Dd1iROAdaRrIyD7RX2/dFjJy31KuQfmn9970vmoVuCV4ZOR5+0zgNv9klCMGLU0snOyQUGJdvMjpS9j+G47++WNyB2YRCbE9cyxhvSJpUMDAma6bxt2v6eKh/HkONTVRVGvcFkKorA8mULRFKHAgwuoKpSi7RsuAIrpKnoSx5RLeT+kvXTevX1KB/Emr58Vc/gnVqEn5eqYi28UJQnNSqqGo/0Q/cXXImEZvc=
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


