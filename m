Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A078FC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:03:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBF316B00AB; Thu, 10 Sep 2026 08:03:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6FC86B00AC; Thu, 10 Sep 2026 08:03:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D17A86B00AD; Thu, 10 Sep 2026 08:03:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A869B6B00AB
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:03:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA92D1C24C0
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:03:16 +0000 (UTC)
X-FDA: 85197717192.12.0A913B7
Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	by imf16.hostedemail.com (Postfix) with ESMTP id BB306180010
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:03:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="J YuMWBx";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=XAB7hUSF;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789041794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U3fJN6p296lB8xQAGr9+sipff9HImTdOJUAonJMUUhM=;
	b=Kp8J9EY1ULUgLXbQ4Bd/ogMS0fPHPyuEPpHCkN3Y3DW0jCqzM3m1MMxVzNeUwsyq3IO+Ss
	zPeICpa/chWNT7LmbZMEWlNX8zG2o4y7r9OcX2/Bc3ZjdBAo+TkZrCsyBt95dwyhXwEzJS
	dXn966bpVhZNRA2gjcCg9sVqgKkaXAA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789041794;
	b=5AloyF84zbW0htOoXz0eoCnBoZQSAm1mt+tY/FgRC2gDapalJ4lhnc7ISUlMEwrHkq7GTR
	KMHaGG5CK7HfkfECA8XkgJ3XtjEaVZtG3zmjeG55Jjm9FyHNk4UY9iki+J3gWD98CNOW4P
	L1cuDVETxjHBN9Od8uGlDgjsCMb+cvE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="J YuMWBx";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=XAB7hUSF;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id B07721D000AF;
	Thu, 10 Sep 2026 08:03:13 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 10 Sep 2026 08:03:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789041793; x=
	1789128193; bh=U3fJN6p296lB8xQAGr9+sipff9HImTdOJUAonJMUUhM=; b=J
	YuMWBx4T1Oe8RKUAsbsHTo9RuPm9QxNeyXXP7Kur7rWtkK21LZKwq7Pl6DwcMct0
	5s3FS1tKOS8vh8/x1CI8GtIw0E/6Z9QuoZTw5rqLF/ikTvt5ur3h+cZCv1dfgPN2
	fVh3UrlWEuuQs/0y13eddIgQe8utwbFytt0wPWL/NOsf+kAUPz8FMpFpskiabVeZ
	u8rkxQd0VlGS03Fsz5eAOd8ts8cFjJOeGoePwAiK6+WwMFDcD/tvY3iv4zt64bdR
	1nRZ9a9Tu42BnT+kMUCIdqMCKdduJfNYCLKe/Ru07GaQUnYmkJ8CUoHuaejSk0FR
	EVGhzwnuaB/pEzq7nQ6Rw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789041793; x=1789128193; bh=U
	3fJN6p296lB8xQAGr9+sipff9HImTdOJUAonJMUUhM=; b=XAB7hUSFpA12cCPJM
	OMDqYRLFct9E/qNWpFh9WOaKkBgGDBuo0OWLQ0k4cdSWLGEe6I01MZxXtkTHRvyl
	quHDuLMGAUPV/7a8RT1THTqviv3A/hRciKXzJgXngMUngjH1sDRmpAikw1nvPpHH
	wlthYfptb5vddwMXqBj3fvOudK8I8FsX1W7IeKhqqg+j3nxLhzpcWMNQ8zUyskIZ
	59jitQ/Hfw1XQp60giP7FFJjdgHCLYTc3fvBDub8fRX5XrBkEGBxTq6tXhE26e+8
	YY3sRCZXt+je++5NcBa3utZyv2QZTsk3OZFBQshOWcSsAqCY09cUPhlXgiY+XdCB
	UDZIg==
X-ME-Sender: <xms:gZyiavy00eWV_iPEYIGlDAipRFfDzzfGK5wh4Fr1fEQPPk1_8g7kEA>
    <xme:gZyiajM2eezg6hqzbA1onUy8PIsZYGl441XjwnbCIO8R699VZDXIJMrDhcnCZvQgr
    LbHSAyJ0UxalSLBCPi6UajbfvBXFj5LrJijCUNZQWQg1OhTQaAKGAg>
X-ME-Received: <xmr:gZyiaveBM4pbIwV_8dYi5rdNKZKUtPyobM6deX3xrDuPFrneW3wfWpXrdlc>
X-ME-Proxy-Cause: dmFkZTGUwtybjwPNTLo6R8Djs851CxE4dYABoksc5DOLebDAdjF/7kz2LTXedMZaJHaEsl
    u+9R36zRT1ZhtRkJBR4Xz/EwBimHSAG+mwOmEGehzEiv3PYSuq6Z2mKTclu6l8ZCGLaRVv
    RupVEjOuMXLaHhEvmZ7MRnQK4S/jaA4Fn+A/pUOz8kiJx7aYiU9MigP37WKT+MGxNap2wz
    dRarL4pe9tmhsdpwwUXZj55Ji6mi71ZgLtAGecz1FGZAcB1ieVS0L457vxQ1F9sxIDxLwT
    QcbTU8EZJEacVnPbAL6aT/vW8eX/g2TSMrM6YxxBPc/XsEEo+/bzW/w+LZ0gFhc/ZZneV+
    vBUhDdd1wrc7OOZstiDjdJu3h/8fXkEkTVsJWdfGlzoNfbRCw8ttRXYEMeIWUbm/cXSR4L
    0eKZQ8+Dm52lOCDT4lAOt1AIzAq4SRNVZG94DY+1cHz6Wr+rdWScldoDGWCVh0TgCnQvX+
    Vsc8iMYu7wteWYcCiBcAtfKxwZV66W02PEgzgOvGxpevqvlGLEyzy8Mr8lBBhpF+WFjwU/
    60RCAixwv13lRN3dbWksHjFMLsqo3WnZ6aV0/CpAK5N13BPRs2YFczS7JV8rfw5eEboqu3
    c1ww/CKHpIPKYiFUkb1Cnqv8n2/vWAueO8W2qFX4yGVL8DFNiVEohvoyHhMw
X-ME-Proxy: <xmx:gZyiav4YDEMnD9T5yYUASUcgh3Dyc9fi2FLXvovlcsJMxUgXja6WaQ>
    <xmx:gZyiavKKgsUgzy-TipYLV6gIyG5zkzehSCCSig-EfTfN8mgYY4XMEA>
    <xmx:gZyiar4wq_HxErhgO-yqfRIEx9whimrsGik4KPEKbDctDAyVX9ZhIg>
    <xmx:gZyiamaUdbGZbaPtVQext43voPkENd4d85k9vIegT6zCxU79GRakUw>
    <xmx:gZyiavpWv7Dmhu5ZqVOwiZC6l-3X8UXuMqCmMjimgNd5vn2nN5rv5FvV>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 08:03:13 -0400 (EDT)
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
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v2 11/12] mm/collapse: declare the collapse interface in collapse.h
Date: Thu, 10 Sep 2026 13:02:31 +0100
Message-ID: <20260910120238.2529819-12-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910120238.2529819-1-kirill@shutemov.name>
References: <20260910120238.2529819-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BB306180010
X-Stat-Signature: xbnnhwi4eff84sqiq1p5tywtxcdp1gaf
X-HE-Tag: 1789041794-22412
X-HE-Meta: U2FsdGVkX19rBPuH3YaXbZbqL/ExYEe+C8AL+mRXim3FLpRax1HqtpMlFsRjzwyv6tJg820l6NkaRT4JE2sPFDDo4xHqmkY/P/hzD6tSYhpXHDZWxo6+kXkozeayaqm5UiLDcDoHG/CYYw2Dt7Bm4vdQ9bZ+1TOvzOHFT1Dgy+D3vMmvCwzcVqBpwt6yneOZOl0Rd6ZojdtJzrmQ54AwpIMUrRrk3ZfeIVR+j855pG8pRMQ6G7uJgVbJD2rR+0bG9rmCFGJgp0fHidMc/5NTRdaclM+X1AmSVXVgHfJnj4K7fSX/Tq9z+pcosa7519qZmFqFxwSFjVUmCCaRloazk8xLm36heqP8K0O+logf5CvLsZhjMIGCWK7F01BWF1AIFsfKe7kehDyh/a8bMeCH2BNOSy1yE38hHkzs25a1Ib732rcodmoZWjGGdY0VA47QUGmCk19alYKCLp974pIlx5OSzOuyd3kermRSW6SXfB1HMMf5JaiU/uCyOqytYFRHU+joKEw7LvqRXNKp0qlLiwzFNGEAS+pq5TdyoYyGBc2t6/TwfGIPQD7pq/hzPp7NTaGMWG5xhkFeq5yK8t62v/pUJB1F/7R3sa+bIePgnWdigUjgPx4l6yBJUKeoctl5KQw/Ww/BnrPqlPQVj8r4Z5AVr/Not2Rk4xHaZqIGmaXEND4T/0gzjOsndQvhz/H9zCuUS2bfN/l2c7hirHY8SF3D8pAPiePH6dlqnsOwQN+VUe0AdyiE56ebHXYLvsy7rO//M4pZLKBeuPVLtBt9ko2vgB2/Iv0Svu57oS/SLCtnj1o4WOvG5e5//YtD4y/nHfdAJT5w7fCWWGL9+uJ8vpoBIMvKzlhxmoC+VjYTwWqmLKKMMiPneXKn/oYzP6X0uXewZ18Jh++AJkj6ZZNBSW+oqEGegMW8cahm8IYAUibzxAGKQaePMRqjdLwGGSxAV6Aa0o7pR7qJrOysqdp
 bZDuLLqd
 zAkGRp/xRJqy49LRs2swfHnV9WE+zWYAOQucciASEmaLIiW6UFs57XnWXx4HCsK1lrw1ET2Gg7bcEbN5BFXhsCGqOeoyZys0JWAYfLel62OECOk7+NyKr/CyUrtUxWA5Uh5rrZZgA/+dBJOPTVCfOzMIGfQJi5aoaUJ1Vg9a2pUOOIl2zh8pDhkPkAceLLc0PCBV/yxtVDrZzhd/q/y2BvvZr+r2h+F8DIsaDtCgLIld5q3lWWl6C0OGBOb2asgz1t1nEnNq08jP9VafvmcpUiU6J1WgCerT25CbLNi3pXvN3t5983tiUcuMQ91vw9tRwxIZFhWn97HKeEza/aztHnmM74hrvMBo55F5GdEurMX1UZWwuLMqTMfeaGrv/8PojU16Hw6svojx01oBbFQY7IcMgJhn/PZqnUZljqF/L3sKj080Oh8d4DRcGDjl73OYt6FZYXgue+omPwRA=
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

Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.h   | 44 ++++++++++++++++++++++++++++++++++++++++++++
 mm/khugepaged.c | 18 +++++++++---------
 2 files changed, 53 insertions(+), 9 deletions(-)

diff --git a/mm/collapse.h b/mm/collapse.h
index 346859a2184f..1ebbbf63fb25 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -106,4 +106,48 @@ struct collapse_control {
 	bool scan_retract_only;
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
index 9e77f71a788d..77f34aedf0f2 100644
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
@@ -2743,13 +2743,13 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
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
@@ -2758,7 +2758,7 @@ static void collapse_control_release(struct collapse_control *cc)
 	}
 }
 
-static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
+enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 		unsigned long addr, struct collapse_control *cc,
 		unsigned long orders)
 {
@@ -2802,7 +2802,7 @@ static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 	return result;
 }
 
-static enum scan_result collapse_run_pmd(struct mm_struct *mm,
+enum scan_result collapse_run_pmd(struct mm_struct *mm,
 		unsigned long addr, struct collapse_control *cc)
 {
 	struct file *file = cc->scan_file;
@@ -3256,7 +3256,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
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


