Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7B49606A33C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 07:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XimPrw1i
Received: by kanga.kvack.org (Postfix)
	id CAEF16B05C2; Fri, 20 Nov 2026 02:44:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5EAC6B05C4; Fri, 20 Nov 2026 02:44:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9C076B05C5; Fri, 20 Nov 2026 02:44:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99C556B05C2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:44:18 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A5C9140D39
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:44:18 +0000 (UTC)
X-FDA: 85454709396.19.E0F0613
Received: from mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3B7AA1C0004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:44:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XimPrw1i;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795160656;
	b=ev4p/nHGYlv4/m565b+mAuCbbbTO3omhq38+BqWh/8JndQdbOzhyYDFDNCJrd/SdpvFrLy
	NSnjD5TNspzDDF7GYqKHWUu2Q09ep8DN7jRtKgezpp4TwTkUT9csSZfkzFkp6krWDdtTtQ
	1KkWOEClRTIGEbvIH3PFyoinKTFouOk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795160656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wS8YTXUEYmlpow8QFrpCI11WZWGA6i9kEdPiCMgtarw=;
	b=KcqZpUafdgsMa/3wD9b0+Ztt0EjhDsJUW7q0g/EkA4qPW/KO8RPIwekq84Z1PnDqyKYFAr
	YW5CxKPyDFsBpH3N3abzmNbHRGc2iFenYBrDYCJfekNVWNYasiuxAdgvDqM+UjDqVdDkYP
	6Dg0kF1TtoMPVcmLN10qVn/evM18YPI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XimPrw1i;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=l4lLHnbLURw2R0LQLtIWt2VlgrpY8/rwx1HMfQXWaYo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795160654; v=1; x=1795765454;
 b=XimPrw1izPqOXLRwj5kSrM6oXjcvnKTSQ+yZ0EO4uAbJm/qjOWED6fwZehQBFTx20/PQycmk
 5tILXP6BnV1Fis3mcokiwhIF4aWVRx8NjPN52gaDDfKZ6exH3tqn/YW+XnUqOhmnxK2SClX1tFM
 a6sytOEoGgkxB7G5FQBwnHMI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 6334611df7694553;
	Fri, 20 Nov 2026 07:44:14 +0000
X-Mizu-Trace-ID: 6334611df7694553
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: xu.xin@linux.dev
Cc: akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
	david@kernel.org,
	donettom@linux.ibm.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [PATCH v2 1/3] mm/ksm: do not inherit ksm_zero_pages counter or PTE markers on fork
Date: Fri, 20 Nov 2026 15:43:59 +0800
Message-Id: <20261120074359.41019-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261120074230.40269-1-xu.xin@linux.dev>
References: <20261120074230.40269-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 3B7AA1C0004
X-Stat-Signature: z84biqg9i1aaoiwx8gu7yj7bsrb5xehc
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795160655-832828
X-HE-Meta: U2FsdGVkX1+ddJU3Y5ZJpQ0ZS2wjuWRXvwOURZuOzRYssnfFXWRAGx2bg+hHiAuR2/ijQMs/jMw+ioggBprMWiTLbU0AYjAxUFLH+m5gZwW62R5SvFnZgxoTMe/5xaQGSaHzBwuPBakOypd5/nzJYA4SIdIh2l5KnwUR6Nly5ueE/cEk0by348XN70/DNbmHfeTBUtXbC4VbRgZj5nzOJ4oLsqicCAD5ffxXPPSmTUpXs1BK7xRMrDmO+tHcXONEdDVQHiJhs8i0UFR28sndZ69Vg7kruyJ8jih+orbJtv7fuwLi1hkD+EPt2ocudG9/oKsdOwt6ub5o6+nq/9hAItYHP5QlG6X/93qyxEUhSyWAUS6lyASIZx8EB7Y2T5Fx0uWantO4LslLAKsi7U8pRvD5w2StgRstf/1QfBhVauO1efzdTE2xas4jDoRjC5Ohna9IGrsiVARYe8diygOOh18jcSab3iuDMuyAZBhfz18SPPepq00qjZ8F7v6M8gwuy3+1wJbrJnHE1RvXo/aQIohe4g+VwfeDvsOWvLNSNqwLbFlubnI7LQ/5a3/VVosy76wSToS4fXnD2+yIZP+H6RTjL4tBx+500G5plKz+KVO0lDzDDRj5M1m7Nxew6lkMrTO3Qikpz8qjmOk5N52Jn5Wj2piIEjkpaEZEqUuF0ldhHCTpiIxbwAEiGleL8JBEcDhyWJVgYFpNb2Vjra/MAy99E0C83meOfMcO7CK1Vm5hq1XD9RQP4K5rTiPjSvaiIaoura31sH/bqGUklNo1bo3oqd+FSi3+YeAW/bLWb9bd0kNGFEwR2TXK/pum14/F/otKX+91F3R96T6sGVFVndqjpYYsevm6zObIYNnQzeQjdEc9Hca0AuuuZGOYZYDyC1yfjn6v8S70wrzv1oSgJtwnoeHLrHZdlcoHb52pFQRehu+q23mmpsAxwcAVN2lPqdReZ/ZOx+ERH/WpLQB
 NzZBKvq3
 yow0TH1StnUCZR09ZMlJDi7WAUK8RfsQbgT7LYfPMwB/5AniJ4d6bjvkxs7pqQ+oySGc6YDQsTiP3oi0INxvHTzbpDSnpNOc9YOTj4wE0Bxq0BX2g+9u3qsDBdt0crXCVEqRfqsa9EVvm8HKuR7G34vpfFU5LOm3n+wfZw594bvmkjPyRtjPWUAfW1T7+IlCq/9pH77XkX3HIp989wv+9YpmLkbaIij38Xn3jw1mTvxoI5DpfiGfPVNPxJFNO5BfhqgPwFuc38o+MKpO6KW8uOPVm2bLq+41i1i9Y1anFyqav/5URtMl8Q4Cn024pqEmzXWkiA3i5Nx047dYV5PanIa3+/DjcYYtLBhvB2OGunGMH9wSWX6G2oCfRSgN92uE4TXN/pTqfz1tTyoqj5EbPdNqPGzPANSTWbJcLGH6aA3LMnRKr7XPZIJWU37QPCrtTW/9RFmud8d6mTHoVhdlNnKTj7AQ8Q6Wt4kQaZhGndYYiCI6xUk1C2RTMWGtOxdlQQEIMzJYUh9bwbW3sZMRBpYWKsw==
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
zero-page marker via might_clear_ksm_zero_pte() when copying present
PTEs in __copy_present_ptes(). With the marker cleared,
ksm_might_unmap_zero_page() will not decrement the counters on child
exit, MADV_UNMERGEABLE in the child will not unnecessarily unshare
inherited zero pages, and the global counter remains untouched.

[1] https://lore.kernel.org/all/53a7bf3d-843d-4e19-b0a3-cc6852fe72c1@redhat.com/

Fixes: 4d6fc29f3634 ("mm/ksm: fix incorrect KSM counter handling in mm_struct during fork")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
---
 Documentation/admin-guide/mm/ksm.rst |  7 ++++++-
 include/linux/ksm.h                  | 18 +++++++++++++++---
 mm/memory.c                          |  2 ++
 3 files changed, 23 insertions(+), 4 deletions(-)

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
index 596c04ca7326..62fa8ca803ed 100644
--- a/include/linux/ksm.h
+++ b/include/linux/ksm.h
@@ -32,6 +32,15 @@ void __ksm_exit(struct mm_struct *mm);
  */
 #define is_ksm_zero_pte(pte)	(is_zero_pfn(pte_pfn(pte)) && pte_dirty(pte))
 
+/* Clear KSM's marker on zero-page PTEs (e.g., on fork). */
+static inline pte_t might_clear_ksm_zero_pte(pte_t pte)
+{
+	if (is_ksm_zero_pte(pte))
+		return pte_mkclean(pte);
+
+	return pte;
+}
+
 extern atomic_long_t ksm_zero_pages;
 
 static inline void ksm_map_zero_page(struct mm_struct *mm)
@@ -57,11 +66,9 @@ static inline void ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
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
@@ -114,6 +121,11 @@ static inline void ksm_exit(struct mm_struct *mm)
 {
 }
 
+static inline pte_t might_clear_ksm_zero_pte(pte_t pte)
+{
+	return pte;
+}
+
 static inline void ksm_might_unmap_zero_page(struct mm_struct *mm, pte_t pte)
 {
 }
diff --git a/mm/memory.c b/mm/memory.c
index d2f48d78b0d7..79ebaa1e3368 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1160,6 +1160,8 @@ static __always_inline void __copy_present_ptes(struct vm_area_struct *dst_vma,
 		pte = pte_mkclean(pte);
 	pte = pte_mkold(pte);
 
+	pte = might_clear_ksm_zero_pte(pte);
+
 	set_ptes(dst_vma->vm_mm, addr, dst_pte, pte, nr);
 }
 
-- 
2.34.1


