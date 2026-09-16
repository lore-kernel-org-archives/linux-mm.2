Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF0E7C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 09:32:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 972506B00AC; Wed, 16 Sep 2026 05:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FCCD6B00AD; Wed, 16 Sep 2026 05:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EBC16B00AE; Wed, 16 Sep 2026 05:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52D846B00AC
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:32:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D3D2880642
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:32:18 +0000 (UTC)
X-FDA: 85219109556.11.86B2AA1
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	by imf08.hostedemail.com (Postfix) with ESMTP id EAFF8160010
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:32:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="H IOeenO";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=QkHXyoxt;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789551137;
	b=wSAJkO+X/OLca0MXrI6+9z/ezs8o322XnpcRy0uJ43X4ldXCrf4RdpEiU4ODI2CFy3xtoZ
	SrR5Dr6dAnhCY0enedN38eYbAFUSVTcI7/Lzxaa4KWmaQmKm8l47N7ibP1fGQfUoPzKboW
	tRrlLF/uIrUWNp1571gisGHX1lKeQ+E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="H IOeenO";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=QkHXyoxt;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789551137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+GwJCdLgfVk4XVCX9cK4EkSAFLB/3dv31DwWiTLRd6k=;
	b=zqKLsXCKr04R6775/yV/GIdcjZKA52Cbut87ibVx3EBtJOS9hd27RZwCFas+DCj5ZsSQkD
	JLayjEuzCSVPIHq97+QLgnVrbNd3OzuJS2vZebDwlk9bZO2bRpba6vth1dcXPB1WP3uDet
	GPpO2GWW2wlQDiCVHEnfQ4g/ItkA1vw=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id ECC1F7A008D;
	Wed, 16 Sep 2026 05:32:15 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 16 Sep 2026 05:32:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789551135; x=
	1789637535; bh=+GwJCdLgfVk4XVCX9cK4EkSAFLB/3dv31DwWiTLRd6k=; b=H
	IOeenOiQbKHmpxeuLJtbAqJZzufrpJTko83KblrjAmmYduhhRnUOzU/qyCsRvO/3
	l01f6xf7YAbstF2pHIG2hsxHcZhozHLq4k6IlpbUncv/V6L6g8i9R/vYzgZH+4S9
	wDuy8t+ilff7AFjwhgIGvG3XkiLpvLRS5LwC8PI9TZa/7cmmWvaZRWnZRdlVdxm5
	K6k99LwMc4wNF1dm8UtI8D/HK0OJB59yi/KPLDvQNIUeh1ZnOvnYT3MZf9t07H6F
	qXystXzYgY4rVLACl87e1Q45BjWm8EB/EVTAohoKESFVRNU41wkKZCh8SGf4R0S6
	gfeeI7RWS9VTR6vyjMmXQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789551135; x=1789637535; bh=+
	GwJCdLgfVk4XVCX9cK4EkSAFLB/3dv31DwWiTLRd6k=; b=QkHXyoxta8LOGefHY
	X+iOI1IPTymo3VpXx3oUoU5VKA1U1KTvX03RT/475gAzHQ2VHLx3ix0+omswYSmc
	ZnEsjWlvGcWrHfkZFzwnP+ZH3Gn2owyGa3+Mas0xU4pgIBAEf5R5WI+m9CTi0Kgy
	IWT5/RzzAvQX1SqN4gFAlg0dODkFOl7HVIR/9hTFFSDAl8S3/Zbo5h2bp2uvU3CZ
	lWGjjUWiReeh6xbNLEA6MCg0eDAYtGNGxpxfDcFntjaHyd+boELjogtmc0bm+xbq
	zG/jqd8zN4/e61B6YaimF9071l2ZmBgJ2qEv5QKJwSvVmOVjRJuScpqrhJG8PPTU
	/oMhQ==
X-ME-Sender: <xms:H2KqasFSdgJ-IRjIOk1jMYkwkIAXE8_7t2N0DdRidxXba7QVQ0QQcw>
    <xme:H2KqahRh60vgtqhW5W3z3-ARMdZY5idMwyweLJY1BNE70uI2l7virw6LZiVLiyR3s
    UjGEMND9iJM6bJRkE7TADwUT-QJfYFeIlq9zWAVjolfCKg5oDAf_kQd1Q>
X-ME-Received: <xmr:H2KqasTpwWWqVGiXX37BB_eZ99XMV_iDgxLdlPnRUnU6IHw1rjBoda4nlLg>
X-ME-Proxy-Cause: dmFkZTE31qL+uaIHQKQPvpaICSxxs7QGWvIquuW8cKaqYQWKvt9pKCqy5bgk//TApl3wTl
    ad4FQSRAknjhMkzVuMAZNh0T12ywqROLvU4AnUXGVwd2kiN78Ar+1NR+fesCkATu1LALh1
    4LvX/9qk4pAfO725ECjoAkI82P3z755hZxEkAV0An15e7Wr2vIbgLFM815SfkNmTU/eBmL
    ORNXO2IPaHkpkCtL9iOfg4dR3lpAdl3Xvq/Y35opAbs/zzbuDBIkBs44NTO3w5x5Bedurt
    thFl4kzzMjhv7UlAxOBz4vPRXQMYZm6skstaNA0N2ZkZEKrpjBUX5624wA8G4zEpHd89Hy
    JWBgDmmn5MPLPofWTx3R3L45pyo841HrYYAE+89PVJJU4o+WwYro+D32vc7H4Yx7Q3Vc98
    plplj6RkZ9Jv99KgXpVQugI7WQ4LjTf4BuFTOYrbMrU9ih6DpsH+/KcRPPG7HyPOQnRo1Q
    724eB8mBiDEJ4UM4zYeRHWV3M9LrtGOxiJ06ryxnaga020c85YShHFNxHD49sQzALMGtT3
    BbqdGFWmc9+Nu/oTaALVi+Fv+VIXvWuXxGzVcMSrmXXMWA6jXL/x+AvPp6ZhdAvPovhwZR
    WikTKhMom3IW4T9M+VciV7O8q7BAufrtyLV015pg1Ukzgyef1cFMh5wPBrYQ
X-ME-Proxy: <xmx:H2Kqakd57CZLEyNOUJP_g7BqpYvzFoF8EsMka4AGG5ZfC-yTioKRwg>
    <xmx:H2Kqagcg2XOBaE4V5L83aMbLKidyBXh5fGOs_pml_VIAkEjLKCcRrA>
    <xmx:H2Kqaq-I1ZunJzjbgupiYap19ZQbqCeFvRTPyln7vPQL6g8Cj3fnmw>
    <xmx:H2KqagOMq0A-RP38FGusH0MWeLFnM6mrcFOHhEuZsu60HQH1gZ-Qog>
    <xmx:H2KqaklhzR6WHf9JfMuy9tLL5mf4jzwC-dFo2VuualKEMrJtSJF-KHl->
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Sep 2026 05:32:15 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v3 11/12] mm/collapse: declare the collapse interface in collapse.h
Date: Wed, 16 Sep 2026 10:31:38 +0100
Message-ID: <20260916093145.4022188-12-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916093145.4022188-1-kirill@shutemov.name>
References: <20260916093145.4022188-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EAFF8160010
X-Stat-Signature: audhbujhiat8zrn4jbucxzyim18owmeh
X-HE-Tag: 1789551136-340677
X-HE-Meta: U2FsdGVkX18hFLqbn4BF+8t6fVfHB0hb0ywG7cHWa8bBE1+Nvz+oXKqBOhdpu7Tuy9tmWF58mKvjz1/OXM6JdFzkjRsMz3kani1rZdAB/qmmutO8l4zG7QR1amB3sfRyaRttSx5cb5jM9ONGJGaYbLjGn09uNgAR0Pnwi8lgHOl/EX2vhX7MO396a/Tc7zeea+IE550UT5/rmJZhq+TXSoBnmMYUg6yQptE1vqHsvRLus38KchvuKArtfm7Xkn/83ZDfXmzlqruJLZPfPy6jKFwulkzmOIWxhb5XyXaQwrbW9QjjGdt6fs0fWaJc4oELZWEOLpbxOFe27mGsuCIK55bUijwBpy3lW8g7qwh8j+ugdK2YiV1Xr3e1tFwMvzq0hBiOF/uTzAP8Y80o8kG0YPypugmgfihwuwrr3Kf+SmCwlim1Kd56wr/4pdZXIArsuZ/PMA9oU077i+IDSVeF59IUunOlySe4sVmbttgSXOoOR//n71WMjMHZIx4fMs+om/bKWG/UwGM1+YUhFDJfGBSCLi0OjQ43WQc5R1Rtd+oA+wXvSQQrMzELffke8o9VsTnYyGwNDIp2/cIU61bem/H38DjQauv9UXjTsgrv8CpGH0Z0TivxQqZ9t0L4xNU1Tj795roIMm77lyhMYln+4VLkTz4ZQ9lW4JBzwypGn9L5eH5mUNRppUQ10MUKjk0OIMLlkWBSX3whLQRpdVMveqYQhODengRLaWBs9IfMixZUAh1/Z4TOre2/tsz05qOiVIEDkNz5SfShadEp093Q8SZtY/frv08733ha8dekeU/aPtNjqnvWw5tMlpPwNNgyuIagYQ2daPyGSapDjJn+FQKDHPdpV5R9Irk8B2ducWr9QQ3Ecy03S9YcEvwRcWG/8zKzTXVewIP5ZNWqHZznzTcyBRxfGuwCJrN8bTHFWbTrr8fIEXojFN4vFNH9B6mJAZ/2916OyzZm2xhuqW6
 pdKMOMuy
 s/+4zTXjx7CJ1sb4dDe1cuOlSy5dSx+RmD4PIv/sC3F6ciAFHJVtLpjcO16LPuqtbCbhgHIyOJ4QyDKU6Hb3S5A27xZO3z/6NnkKibY9MXiaaGls4fDg49v0lf25UTqqVkZ+TzZzOBr0a6s7nY61HyVv88t+sIxVG8LYY68QBwNwNtVbMmp5lCdgDFKYAxKznSpnzolIZ2WkBkp+IrCbMSKrHPUBJJDbvU4AfJTuN1NBvWRP6/zt/1jw0nCefSTXb2/EdTethI5u8T/femtPPIsmKT2BkEoCsbWQaNyz7xIYge8dgI8HTTEJjP+LuCVs+zFiF3lPj8PFcLE0Yl9SSiw/6exmGOguLMYVlNlCACBrgl0DI3DP/Fp5e3pZk0o0gMGAFQrLAuoYRpOqKGBYyg+DmnoJaz4zunA/r6dsODijlfl6xLph5BXlPDgmVHgWHjgDWdmXGZ2oFPNw=
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
called in and who holds the lock over each step.  Each function says
what it needs and what it does where it is defined.

hugepage_vma_revalidate() becomes collapse_vma_revalidate(): it is part of
what a collapse offers now, not a helper of the daemon.

Preparation for implementing MADV_COLLAPSE in madvise.c.

No functional change.

Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.h   | 47 ++++++++++++++++++++++++++++++++++++++++++
 mm/khugepaged.c | 55 +++++++++++++++++++++++++++++++++++++------------
 2 files changed, 89 insertions(+), 13 deletions(-)

diff --git a/mm/collapse.h b/mm/collapse.h
index 9764011bad86..e52969965262 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -104,4 +104,51 @@ struct collapse_control {
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
+ *     collapse_control_init(cc)              once, before the first table
+ *     collapse_scan_pmd(vma, addr, ...)      per table
+ *     collapse_run_pmd(mm, addr, result, cc) when a scan found work
+ *     collapse_control_release(cc)           once, when done with the control
+ *
+ * The caller holds mmap_lock for reading over the scan and passes an address
+ * within @vma, aligned to the PTE table to scan.
+ *
+ * The scan returns with that lock still held.  It only reads, and almost every
+ * table it is offered has nothing to collapse, so a caller walks a whole VMA
+ * under the one lock it took to get there.  SCAN_SUCCEED means there is
+ * something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE means the page cache
+ * already holds the PMD folio and only the PTE table is left to retract.
+ * Both are work for the run, which is handed what the scan returned; anything
+ * else is why there is nothing to do.
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
+		enum scan_result result, struct collapse_control *cc);
+enum scan_result collapse_vma_revalidate(struct mm_struct *mm,
+		unsigned long address, bool expect_anon,
+		struct vm_area_struct **vmap, struct collapse_control *cc,
+		unsigned int order);
+
 #endif	/* __MM_COLLAPSE_H */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 12cb67d8df32..d4e0674a05d7 100644
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
@@ -1011,12 +1011,12 @@ static int collapse_find_target_node(struct collapse_control *cc)
 #endif
 
 /*
- * If mmap_lock temporarily dropped, revalidate vma
- * after taking the mmap_lock again.
- * Returns enum scan_result value.
+ * Find the VMA at @address again once mmap_lock has been given up and taken
+ * back, and check it still allows a collapse of @order there.  The VMA has to
+ * span the whole PMD whatever @order is; with @expect_anon it also has to be
+ * anonymous and have an anon_vma.  *@vmap is the VMA found, if any.
  */
-
-static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
+enum scan_result collapse_vma_revalidate(struct mm_struct *mm, unsigned long address,
 		bool expect_anon, struct vm_area_struct **vmap,
 		struct collapse_control *cc, unsigned int order)
 {
@@ -1264,7 +1264,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm,
 	}
 
 	mmap_read_lock(mm);
-	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
+	result = collapse_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
 					 &vma, cc, order);
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
@@ -1299,7 +1299,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm,
 	 * mmap_lock.
 	 */
 	mmap_write_lock(mm);
-	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
+	result = collapse_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
 					 &vma, cc, order);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
@@ -2741,7 +2741,8 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 	return result;
 }
 
-static void collapse_control_init(struct collapse_control *cc)
+/* Set up a control before its first scan; cc->policy is the caller's to fill */
+void collapse_control_init(struct collapse_control *cc)
 {
 	cc->progress = 0;
 	cc->scan_file = NULL;
@@ -2756,12 +2757,30 @@ static void collapse_put_scan_file(struct collapse_control *cc)
 	}
 }
 
-static void collapse_control_release(struct collapse_control *cc)
+/*
+ * Done with a control.  A scan that found something has to have been run by
+ * then: the file side takes a reference on the file while it still has the
+ * VMA to take it from, and the run is what gives it back.
+ */
+void collapse_control_release(struct collapse_control *cc)
 {
 	collapse_put_scan_file(cc);
 }
 
-static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
+/*
+ * Scan the PTE table of @vma at @addr for a collapse candidate.  @addr is
+ * aligned to the table; @orders is what the caller allows there.
+ *
+ * Called with mmap_lock held for reading and returns with it still held.  It
+ * only reads, and almost every table it is offered has nothing to collapse,
+ * so a caller walks a whole VMA under the one lock it took to get there.
+ *
+ * SCAN_SUCCEED means there is something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE
+ * means the page cache already holds the PMD folio and only the PTE table is
+ * left to retract.  Both are work for collapse_run_pmd(), which is handed
+ * what the scan returned; anything else is why there is nothing to do.
+ */
+enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 		unsigned long addr, struct collapse_control *cc,
 		unsigned long orders)
 {
@@ -2793,7 +2812,17 @@ static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 	return result;
 }
 
-static enum scan_result collapse_run_pmd(struct mm_struct *mm,
+/*
+ * Collapse the table a scan found work in.  @result is what the scan
+ * returned.
+ *
+ * Called without mmap_lock and returns without it, taking what it needs in
+ * between: what it does -- allocate, isolate, copy, flush -- is slow enough
+ * that a writer would wait behind it.  The caller gives the lock up first,
+ * and with it the VMA and anything derived under it.  The run revalidates for
+ * itself rather than trusting what the scan saw.
+ */
+enum scan_result collapse_run_pmd(struct mm_struct *mm,
 		unsigned long addr, enum scan_result result,
 		struct collapse_control *cc)
 {
@@ -3246,7 +3275,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
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


