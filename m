Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2299DC624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 15:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79D8B6B00A1; Fri,  4 Sep 2026 11:10:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77A836B00A2; Fri,  4 Sep 2026 11:10:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F0B46B00A4; Fri,  4 Sep 2026 11:10:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 360216B00A1
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:10:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C581AA01EF
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:10:52 +0000 (UTC)
X-FDA: 85176417144.21.A51D5ED
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf03.hostedemail.com (Postfix) with ESMTP id DF69E2000C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:10:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="h Q6Tp+K";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=U5+vtqbo;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788534650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IyGYt/hGSRRfip2XU7o0oYq5+nS3sb9WHKUu0hUMGJs=;
	b=l/EDJIQcAqpUzkyJ9PRxf5PzAipQLqOFFPyQyUi+9fNJQqlA0NTy3jFF/YKhdPGgImzmtb
	K0lB2GLMl+oIOmJ6cGoZWlKmb68biUa5oM/r2S5q+jazpD/hOVTZAEV39D2yb/6kiXO5hX
	TwXXlKAiWi8ho9n0NikG+k5k4MzdOz8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="h Q6Tp+K";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=U5+vtqbo;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788534650;
	b=oFWWDdcdGN1sXXZ1zdi9y//dAIdnVfrTC7hrp4hYLCONSzrMWN+MqCM3U+hXfsJe7y5tCU
	loiZRSQ/Uf8BfVMNDiL2VYSLQtAtWZ2+xvv35nUKOc1XO4TDEMkk2A2gf31Vr7shNEnxGX
	xY20F584pus8odZPoeht9Ifar2BOgK8=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 605FA1400106;
	Fri,  4 Sep 2026 11:10:50 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 04 Sep 2026 11:10:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788534650; x=
	1788621050; bh=IyGYt/hGSRRfip2XU7o0oYq5+nS3sb9WHKUu0hUMGJs=; b=h
	Q6Tp+KevTAL6klGeElULZhwBqt2vBtH+Rb+By+1KsAo+tGSTxklPVxEYarT6yx+z
	7MXi1TiarSEFZpUJDrM27bnCV1WJ2bnWqKzcpjFSoQoBxlCOqn98WTk6ZCUmLSvM
	+kkugRC82knUvSVjcidxCAZeIL3CZ+MeZZnpnxkV9RkPBh6qOZtUM62USenPj1Kh
	jBilwgz/krits9LLm1clhkzPHjC2GBwajiXgnBmLtDEh6r4dXB8DHJe/lghz0UYb
	Fd3x+r5A5kktD006Hy/knALpUdbYtmlw6z2KZu1pbp8geZy1tDQEg/tfdEAtb0hJ
	SCxcBrPE38ikwcX0dDdRQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788534650; x=1788621050; bh=I
	yGYt/hGSRRfip2XU7o0oYq5+nS3sb9WHKUu0hUMGJs=; b=U5+vtqbocwSs8M5p4
	OfvVBotzWFoSSF3/iNLmjaoVMz7vvALSsIBriEbS4bTyw+JW3BwpYtUYHLoaqA5p
	4xUNhtrKUoN1SS7osx1oMWszSE7fVu6/wByk/ZLPGarmHCeBiKwrViDfnGUvZMCN
	JPsD5veAROMMJeM+qqLmkM6rimBKFDKyY/3dpztrNLw2i+LEQ2VRDbmmZ8+BDDjz
	kaT981QAgQccWfJUxSfIeIfR9xbqzSs1gIpYy6Vh2Zt/Lgft+hufZxNUnzLa+1J6
	5B2UQdrAyq7QK5X9RJJzXJauI283jq6kH47Vs/tgxksjlL1eegARtlmeyu7lzTl+
	cx8kA==
X-ME-Sender: <xms:et-aajqzv8If1Pzex8taJmsTysiTCytnZh2KM-ZC9EVVMH9x6b7vcQ>
    <xme:et-aapkqYvX8PVdDjnFNk21Xx4jFuOE1buAOCrB9CvJrJrti_pZgy_m365l47H-9V
    qyidlrM_pu76oUDdBNOHfenB_enT7awdaCnMCyC_cwAxxa3GHgvF8g8>
X-ME-Received: <xmr:et-aamU1_2IuuG6Vtegnih1LCmsdjOZWNAvD3nkxAcKfjJHx2O_3Hlyw77A>
X-ME-Proxy-Cause: dmFkZTFdOocfRN4jOpcQf0AqfSai/YCGo+xlO94MLvzn7lqitof50EENUNEgJzLPt2H+RQ
    DWgrwJL5dg2BaLkWQfjz0w8mX09EzID7A24sM1R0CcrzJ0aCsxP+pgO1accdG5RnvXKoNP
    Qi2+ranCgsFBQlrx3RUM64Xgm9l9zr2TPWbzFNtan3mUwkVlJ/gBEGXolzLuuMZ3CJ6e8L
    gmzum6oDDF3av5ecJE/wINba64+XlYa/U9oL8c0Dkr16eu3wp8w8wOsHTRTsCgO4oV0meO
    0fb7rtZliPO8XPlA3k/rGcTv+01JWMnSe6fG3OACTE4UctUjoP9cM2YnBbUckeF0hhckL5
    D6MHrUzf167y2omQL0hymJoFC8UpYyFDv/iBC5j4SYdLZ84BhZnQdV7WTJmUex23TQmx1h
    gjgtmvz28+cPVK/JOJqAk+MNlvRziAEZ+CTcq0wtB0tp6LhJcm02nOa/ojCMYITHqb24A7
    QIqUCFztbGQ+NHmwRoRVMAhkTPbFHhTTCa4PD3iaWyXlHN0H6ZMmAvUd2dPwR4gEgwXbGx
    uk8dkf2xdbLJbLQfCbfCYZe81/Gzhlg+sy8BCfAmWyKlKsqP3LRm5mQ7PMvMI7NYBG1G65
    JdoexBRqSTE0TqifcgFHhWz9ADIfHMm6UETnZObymJ+CMf79bNsYA0KDTw5g
X-ME-Proxy: <xmx:et-aatRSZGIxC18fbKpOQEnTEegrLO89PHMh5m5WxthSW0kmgOHpHA>
    <xmx:et-aahBvUUczV1drlHQontNedgfLKdObGLvIfK3llWZ21kXHoM1GOw>
    <xmx:et-aaoRFXWcpwkUvudYLX3NVANRBQg7K-LoENulRAlGXxgfI3Q2lEg>
    <xmx:et-aarRQeqfU4VNefSfp6jTHZ1wCzQIBgHpLDeOPfJ-BlavpBaBC_g>
    <xmx:et-aamhkqVoqDQnd0aN1_PVcEu72_xwDDPPmgmPeHMzVqmdgvZ6PYKJl>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 4 Sep 2026 11:10:49 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 11/12] mm/collapse: declare the collapse interface in collapse.h
Date: Fri,  4 Sep 2026 16:10:25 +0100
Message-ID: <3b698ec5d0d8f2fe51a298369778cb7d6a6a1f4b.1788533997.git.kas@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788533997.git.kas@kernel.org>
References: <cover.1788533997.git.kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cru4zc5d1gxr3eky3c33q655giy8yckx
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DF69E2000C
X-Rspam-User: 
X-HE-Tag: 1788534650-404419
X-HE-Meta: U2FsdGVkX1/EU6/tk2XHSkCKlWY8Fy/Lg2416zOE+OozdyqrwmbMw22KUlRaKYPLhAMsViuim9RCqKJWJxyHZDg12jwKMXTewUCXGP+WazjFkXSl4vAmhQlF94t87PYAp/y5gaeou8tpkWg8srExf1WjHzgOHhmwZtHBx2H93c9jdE7c+15yemUr08I9q+NrecHmBTtmjjxWlmZFIia2iGqmYcGkL+43wqmbO6IelxNPrcxDQtbdxyzdqIk4sTHVTgPmLxGpjVRCJ92a4JuvV/P31ALwQs0RbRcSqTjro+XpaJB301DcTCmlR7VghNym9C9Zi/EILkNLKY2TTd5wT5q164gYeEQ/geoz2awqZWzmcjvVfN8TecuObONJ52OB4mHKwjNwHtsWDOtgJGSm+CI6YOXPFZDnUzVcWfWSCDHPzaZNaTbJZpHHburWyQXwtujjPGuglmLf/w3ARV9BpxUDciGClwD2bAnbMstCfEGNAC9oyuV1DsbVDlSujsfQiKaIsIfeHcWNlfgwTXD3BTEC454tcELEQ/UcrT4flq7atHeM8bkAP6HnboB9pKA913j7f7lD1qNTsw47eMfh6dx8CDgqyLJvpL+2YkRJp58bxAXOoE6kYqd4USMoNjDlzpgP/nhC5Dayqha/Q1iqtDSvwB0Yr9SPxu01amDu5P360fGnAu/34LllSOlLRU9Mg40l8HHXZQQc8LpfnnOOYFi+UZhwTURx/DmVBG31XDINZE/17CfJu6uI/DgXDeEuKFkn7GR1bQr7ZtjRp9QqSI85PBCLPuS0HW6fyfj5EHRQBWS3fqIn/xQjbOWp/V6KypPq3WNFuo4XU9PHJd7EJ0oXj703Z5yxGq3mF5Mmmt9IQosk3sTtHN4RUsqeziKIgqlUe5gLraOaOOWkprPD6/8lDztMsxrcGpZiZxrYAOndM2nMoqRGfypp8YRBL1aqhZeArd9Yk0I5TqZD/kX
 udywFh7t
 M69D9rQVJbH/cEzTQJF//e6WVkZMteH4K0OGXNb17W9zS9FXIWgpckDZXGgioM8UrV6dW74g8BfKOvAbjbui21xFZcPEMShMO0j5AXIwu6qt0LqVkgImnxuEZFYlW3UF+0DJ242EvJeutmji9LSojT/VyYHiHJF9OBa4txvYSZT+l6yenW1Kvdjxz7UEg3fgCzyEhmL1byiVGXS9msylJY1hFeRGOiLWmtbk0IJlO70tlJIOQhBe5F+vi52xJDMkqhlzSoKQqjD2hxAaUQYdsPkjqGZyBTN3rCcifxbCZr+F98ZLL0gdZztLk50+qi6wfH00uVAujsU5RBDzPBZ8zNviuCWCtsxiwvR7EHU0WTlrj15U5UaTjNwvvvDcqWNN+K4wd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

A collapse takes four calls:

  - collapse_control_init() - set up the control a caller carries;
  - collapse_scan_pmd() - scan one PTE table, under mmap_lock;
  - collapse_run_pmd() - collapse what the scan found, no mmap_lock;
  - collapse_control_release() - done with the control.

All four are static in khugepaged.c, as are collapse_possible_orders(),
which says what a VMA allows, and the revalidate a caller needs once a
collapse has given the mmap_lock up.  No other file can ask for a collapse
without them.

Declare them in collapse.h, with a comment stating the order they are
called in and who holds the lock over each step.

hugepage_vma_revalidate() becomes collapse_vma_revalidate(): it is part of
what a collapse offers now, not a helper of the daemon.

Preparation for implementing MADV_COLLAPSE in madvise.c.

No functional change.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.h   | 44 ++++++++++++++++++++++++++++++++++++++++++++
 mm/khugepaged.c | 18 +++++++++---------
 2 files changed, 53 insertions(+), 9 deletions(-)

diff --git a/mm/collapse.h b/mm/collapse.h
index f03cad8ed40e..c5773e273e15 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -116,4 +116,48 @@ struct collapse_control {
 	pgoff_t scan_pgoff;
 };
 
+/* Which orders a VMA may collapse to, zero when it may not collapse at all */
+unsigned long collapse_possible_orders(struct vm_area_struct *vma,
+		vm_flags_t vm_flags, enum tva_type tva_flags);
+
+/*
+ * A caller states what it allows in cc->policy and then hands over one PTE
+ * table's worth of a VMA at a time:
+ *
+ *     collapse_control_init(cc)         once, before the first table
+ *     collapse_scan_pmd(vma, addr, ...) per table
+ *     collapse_run_pmd(mm, addr, cc)    when a scan found work
+ *     collapse_control_release(cc)      once, when done with the control
+ *
+ * The caller holds mmap_lock for reading over the scan and passes an address
+ * within @vma, aligned to the PTE table the scan is to judge.
+ *
+ * The scan returns with that lock still held.  It only reads, and almost every
+ * table it is offered has nothing to collapse, so a caller walks a whole VMA
+ * under the one lock it took to get there.  SCAN_SUCCEED means there is
+ * something to collapse; anything else is why there is not.
+ *
+ * The run is called without the lock and returns without it, taking what it
+ * needs in between: what it does -- allocate, isolate, copy, flush -- is slow
+ * enough that a writer would wait behind it.  The caller gives the lock up
+ * first, and with it @vma and anything derived under it, so a caller carrying
+ * on has to look up again with collapse_vma_revalidate().  The run revalidates
+ * for itself rather than trusting what the scan saw.
+ *
+ * A scan that found something has to be run: the file side takes a reference on
+ * the file while it still has the VMA to take it from, and the run is what
+ * gives it back.
+ */
+void collapse_control_init(struct collapse_control *cc);
+void collapse_control_release(struct collapse_control *cc);
+enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
+		unsigned long addr, struct collapse_control *cc,
+		unsigned long orders);
+enum scan_result collapse_run_pmd(struct mm_struct *mm, unsigned long addr,
+		struct collapse_control *cc);
+enum scan_result collapse_vma_revalidate(struct mm_struct *mm,
+		unsigned long address, bool expect_anon,
+		struct vm_area_struct **vmap, struct collapse_control *cc,
+		unsigned int order);
+
 #endif	/* __MM_COLLAPSE_H */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f862abb1dbbd..13c4dbf04379 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -498,7 +498,7 @@ void __khugepaged_enter(struct mm_struct *mm)
  * Check what orders are possible based on the vma and collapse type.
  * This is used to determine if mTHP collapse is a viable option.
  */
-static unsigned long collapse_possible_orders(struct vm_area_struct *vma,
+unsigned long collapse_possible_orders(struct vm_area_struct *vma,
 		vm_flags_t vm_flags, enum tva_type tva_flags)
 {
 	unsigned long orders;
@@ -1016,7 +1016,7 @@ static int collapse_find_target_node(struct collapse_control *cc)
  * Returns enum scan_result value.
  */
 
-static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
+enum scan_result collapse_vma_revalidate(struct mm_struct *mm, unsigned long address,
 		bool expect_anon, struct vm_area_struct **vmap,
 		struct collapse_control *cc, unsigned int order)
 {
@@ -1264,7 +1264,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 	}
 
 	mmap_read_lock(mm);
-	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
+	result = collapse_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
 					 &vma, cc, order);
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
@@ -1299,7 +1299,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 	 * mmap_lock.
 	 */
 	mmap_write_lock(mm);
-	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
+	result = collapse_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
 					 &vma, cc, order);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
@@ -2754,13 +2754,13 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 	return result;
 }
 
-static void collapse_control_init(struct collapse_control *cc)
+void collapse_control_init(struct collapse_control *cc)
 {
 	cc->progress = 0;
 	cc->scan_file = NULL;
 }
 
-static void collapse_control_release(struct collapse_control *cc)
+void collapse_control_release(struct collapse_control *cc)
 {
 	/* A scan that took a file reference should have been run */
 	if (WARN_ON_ONCE(cc->scan_file)) {
@@ -2769,7 +2769,7 @@ static void collapse_control_release(struct collapse_control *cc)
 	}
 }
 
-static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
+enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 		unsigned long addr, struct collapse_control *cc,
 		unsigned long orders)
 {
@@ -2793,7 +2793,7 @@ static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 	return SCAN_SUCCEED;
 }
 
-static enum scan_result collapse_run_pmd(struct mm_struct *mm,
+enum scan_result collapse_run_pmd(struct mm_struct *mm,
 		unsigned long addr, struct collapse_control *cc)
 {
 	struct file *file = cc->scan_file;
@@ -3237,7 +3237,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 		if (!vma) {
 			cond_resched();
 			mmap_read_lock(mm);
-			result = hugepage_vma_revalidate(mm, addr, false, &found,
+			result = collapse_vma_revalidate(mm, addr, false, &found,
 							 cc, HPAGE_PMD_ORDER);
 			if (result != SCAN_SUCCEED) {
 				last_fail = result;
-- 
2.54.0


