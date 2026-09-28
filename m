Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2211CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 10:07:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2FA06B00A6; Mon, 28 Sep 2026 06:07:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E077D6B00A7; Mon, 28 Sep 2026 06:07:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1EF36B00A9; Mon, 28 Sep 2026 06:07:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA9A96B00A6
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:07:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2E6974016C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:07:01 +0000 (UTC)
X-FDA: 85262742642.12.DF290F9
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3CD84A0006
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:06:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="b tgI9kA";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Hp9dJgvf;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790590019;
	b=Cf4HgKZMfEZpT31G/H3rlWqFjARRo0XjAxVDYXMp05OJbvBJxTgFkjznuBdMEIWMv0RT/C
	AKGnuO3I4L3HUdSG023Ly0xQoSQzYXmMwW1M6fAXXhf8RMntLYbbpMCP5hF9HrcpDfnOb9
	Omw5dSqJUUXkMLjMohELYkspF343iFk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="b tgI9kA";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Hp9dJgvf;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790590019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Os3PLDtwmcHuV9XLIXxswiPlM9QWS3yP3dG2bw7DGes=;
	b=l40R4i6tuMabwxNjJqGjvck+A5VBvekV4VP8MRp4/QqyD6AB0mYBgZ+Q8g6gfsryCUdrsc
	+RWPPIxoR3H3yToUkkNvZyrMuc/HVtzIxgMFlkE4PHtuK1merBpp2u/mb/T5uP5DZFVBJb
	TSO6EW+Ne3jp49QME+mDUO1e634KND4=
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.phl.internal (Postfix) with ESMTP id B977DEC005A;
	Mon, 28 Sep 2026 06:06:58 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Mon, 28 Sep 2026 06:06:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1790590018; x=
	1790676418; bh=Os3PLDtwmcHuV9XLIXxswiPlM9QWS3yP3dG2bw7DGes=; b=b
	tgI9kAg9dPhorG2bGGzwOm3zL6stuY7q+4idNRCqwDgLTCtG5xvfmJNEFU39bOAG
	sdsHoZ79lnYJ5nbKZ1z1zSIsDIP37NAOpa0TkkOlEXTep+gdsQZxySFbKhOZdm40
	DMDP67DQxBVS1J8Cz9imjKHTx9KPIEG/zd6HRXogoZRduciBQcpGdaPFWZrqUJwU
	bkGOq1Z4kSa69sTk0UsDTLBuIG7yEYjB3wAkyhLD7yrTt2FZkPu4q3eQLE+AmwAh
	rQwVYn5EIkIh1beipuQOGb/VvfYETDY3muzv6/sJnMTGxG5JxX3IN2RRMyRTk+Na
	fdWspfwadsAakM/YCNn1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790590018; x=1790676418; bh=O
	s3PLDtwmcHuV9XLIXxswiPlM9QWS3yP3dG2bw7DGes=; b=Hp9dJgvf86hYJsOqT
	jq9y2cXE5yzZgs5et+JEebLRPPV1fZPI6p04YLYC4ECtX/QZv71fYdB/kQmvvoyV
	o3SlbLEFqcgU60/jEieIA+eMEIBYK8O84mmOpAAVivcRKPwCCaAl0Wn5/B+jEch7
	XH4oYewAkfqliDzG/PQ5T1BL5rsu0WpD9z1UIS6+k4HbAQoLXJkSnIbb7rIjPRd+
	EXeZeYfhgJoi70XXBPDL4PGNx+Fi+ds6dNNAYapVPPTsb0qN/XapLVwAJYf55yzI
	i6Nb7yi4rfnyQO3g0jts4IUXIZve/KqiCfcDDWYUUgsMP65MjlZmaf0xnmw9v9HM
	WrgxA==
X-ME-Sender: <xms:Qjy6akN737CFqvROeWvwAiNuHhsUXCrQ2r3hGrsUNmiIMP74XdUi8A>
    <xme:Qjy6am5s7hz3sl2I1Vo6Uzghlolm0F4HgK0PovKzZqsvU5zglkTlvzW_DBUw4hn5F
    Zl3bKej7kRYPMkVmUBfGv-yA6sskQ2VxqNn0X5hRwtqdhqQ-ZrTFgE>
X-ME-Received: <xmr:Qjy6ahabOKP4IxpMpOnBGAIQLMD-XyfFS45yn9i3AnOa-ubPCGY9mY1a2TM>
X-ME-Proxy-Cause: dmFkZTF8+FzWl2kPFFw+2+MUnNndpG3Es29zlM3W8MqBD0QW9993JqL27RjsdWHL5iQTuv
    8LHkef+10EFcRNyu6aMfBJblGtUMhigK1wvWUg5pa/T2F4HZOycwBRl+2S+z7tqw2cJfHU
    gdsF/P6BOMqpKS9LZRm0d8oBtyKEEqCXwj8zji6pXjSixGW9yMDmevXCSXRhMug+RBOuj6
    H/TPGEbj0UBxBpkklI8Q2dk1KPN1FfxQ05T6kAzB+fcPQyWzSSafNh6004OlOqdREfhbRG
    BHI+j7BDMASDclZuapGmxVrXolh8JlQnm8Hn+THchpsYHB/1yAmWKg/yew9Ltzw86nEqAR
    hroSqA5eExChhmjWtQsuysQEyKCidMBYDNujlOfc7luc/BprsKsI3q/2fy8Ai2kE6QwcAY
    +NKA9FO4SimJ5QvQPSyIOqPTh/3n2IJwzhPFIpcd9VtZ9GEZ8iXtkYIMCaQYqxusCc/0Ag
    v3zA93TL38S9PQvg1TuITN2s3vbjbbTB5oe4gQIONjCfdJr4rJxkBsbHo6DSPef0hy3k9a
    doaUq4wTlpcYetNXpcV5zEx5AjP/CKqL3jGKezKyzRXYyIze6LVen/WUwdC+C6Z+fiVjRK
    0ROSB10NROBgALTHL/lT3IVhPK0sCvJ217ZsYRkklainefSikHaoM0Vtvh4g
X-ME-Proxy: <xmx:Qjy6ajGlXYlj27sehQB6CXDXtBNgmomUrCZz8MtiSXu_aVEYUNOECQ>
    <xmx:Qjy6aqkONXPfZ5eM9rDScgFm9hyUwYXfeWVVcg4Sd05aBt-CUXAqIw>
    <xmx:Qjy6aqmvt2cvMkmYFSSWWUWhMZBnABs5gujqoGFs_qnuX9t682XYGA>
    <xmx:Qjy6anXAcvm3MzFIM_eXfkFLoziOWYWTfLa-6jk7Xh63vtW3m5KyiQ>
    <xmx:Qjy6avv33Np3nIf6Szv8kF4rNZBbMxkK5-_e6QxRqrVo2r2yc7PhQgex>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 06:06:58 -0400 (EDT)
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
Subject: [PATCH v4 13/13] mm/collapse: implement MADV_COLLAPSE in madvise.c
Date: Mon, 28 Sep 2026 11:06:27 +0100
Message-ID: <20260928100630.21870-14-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260928100630.21870-1-kirill@shutemov.name>
References: <20260928100630.21870-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: se5jh7n4ggx8da36uft9dh9my4w6tsrk
X-Rspam-User: 
X-Rspamd-Queue-Id: 3CD84A0006
X-HE-Tag: 1790590019-685995
X-HE-Meta: U2FsdGVkX19c3U3GIhOUXjnn2x2aD5uvbwIp+VJIcelDW9x0hQCIQyI4ZIgW8dY4H8S5VxsUT0cR/VelbD9gxp2wcrER1clk5u9mlY9PSfJq+0tjjbckSh7jKd0n8KOuW7Zw3YpJrkyLOAIQwJTWQA/kbNcXfF7ojlQn4TMRrpkfZZ7V+fjdGeUwdp3fg6TDY60zou8htxbR6m6wxXalmR27AyNjEJSaeFCGVP4OqbABZKs+hxrBLLzhjpCXw3+TrqSVIoAgRvuLr/1vbiaZ2+1sxPgGfoROdVeuyVrNEKTa3xYTbZLsDfK9wdBKS1w+wzMThP+4J3cku6RUbgR80Xa2lBzYuAufevSMnR7ESh3awVkdUHBlV5HtplGmREgsFMGEqb9aBTMm+XlZ7u9UML07vCGfzSBZt2HOUwifD+06/Llc3JkFc9Y0TemPqmJHJhbo8APEkfOzyhDrPriBWhSwLGvhZDCAZhDLZMUh4wmLc96cbkappZMNZous2q6TBusodB4sDj5G9tYzwJQb4U9l7FEeec/rg5dbY8I+rmZWVercFRfZlvnpPurBFohe+mPO2bkcf1nZYRH4eP3ew3LKt7WZvLWh6B3Dx6yU2fVTRZ1XYWqx+K4OMdXyZ1lBP4kHvBb6sL2nA15zDGcy3gKAR0RS62mycRF5/XCaG9+XDa7glE28BVos9T912zniKAkvfpZJVekaWjvJF2vROZmGK0JeDi4TSmeVa5mewaMpf7LisrtqPTiXMqJUUJfSpW9nisuFgfStDAHWSMed5DFCEgFjFDhmdQ7tQZ7KFZ+5tnftB1a24PtWMI89G8UeUN7EvSbt1VNmswQVosV9sKQH26ALb/R7+KCpDsP/49vsMW9Htk2goIe9KwfQEws31s1RCfVulxfueaFzwlgans6VawwxU5Hx5r0jCqvSRXTt1UYVmeOlHk/D/expslldcIXMFaOtbZThtvEE/gr
 0CApymLv
 DbFnfMOGGLEOW0BoMOZfdVHbh+oLyUH4gpbajdAn1ZxUxnJiEQpXNM270PZb3SzjAKkc0J/A119rOFmpiVwGp3iCW0a1oVxETX19rzNHW57mgP/ZAXklriPJvQ5Mr3iQow8aZThD69mDrsk41pjthQvBuur/K3woMWP09Siy679CrH7HvM8dkcsC29hs2GV1S1BlHv+PxOfWXPTbl9GUk2fAHd8CN8E3ovn6O4fcHRYYZQ1gaJq4L1Qo2sR6r3RNIZo4TSr0g5i4SvsSB8ACX6oQHJ+oxU0Ji5vULoEF92EnT9pyBhhdWWFgvfdk0vX01FN3QPgW4TUNp+cDia7Sht8x9oxf6hZ2I3i/Y1y1/jhCCPUq3BpFPuI92e5LdfP2CfuRI3uVgzbWLrwLY4htp93g/6NPkO92fB42B23W3K3ixBBI6QuHrCVnB7inILW5hmija6MypmQJZFrta/fXPfio47iL6dbmAl+3p000CYSqVcUKWlMKbfGWu2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

MADV_COLLAPSE is a madvise operation, but its implementation sat in
khugepaged.c.  The daemon's file therefore also held a syscall's worth of
code that has nothing to do with the daemon: the walk over the user's
range, the per-PMD loop, and the errno translation.

Move it to madvise.c, among the operations it belongs with, along with the
errno map and the policy it states for itself.  It takes a struct
madvise_behavior like every one of those operations, which is where the
range, the VMA and the lock-dropped flag it used to be handed separately
already live.

It stays a caller of the interface khugepaged uses, so nothing about the
collapse changes.

The !CONFIG_TRANSPARENT_HUGEPAGE stub moves in with it.

Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/huge_mm.h |   9 ---
 mm/khugepaged.c         | 159 +------------------------------------
 mm/madvise.c            | 170 +++++++++++++++++++++++++++++++++++++++-
 3 files changed, 170 insertions(+), 168 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index c745f7ad2298..8ca0fa3be2ac 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -510,8 +510,6 @@ change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 int hugepage_madvise(struct vm_area_struct *vma, vm_flags_t *vm_flags,
 		     int advice);
-int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
-		     unsigned long end, bool *lock_dropped);
 void vma_adjust_trans_huge(struct vm_area_struct *vma, unsigned long start,
 			   unsigned long end, struct vm_area_struct *next);
 spinlock_t *__pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma);
@@ -715,13 +713,6 @@ static inline int hugepage_madvise(struct vm_area_struct *vma,
 	return -EINVAL;
 }
 
-static inline int madvise_collapse(struct vm_area_struct *vma,
-				   unsigned long start,
-				   unsigned long end, bool *lock_dropped)
-{
-	return -EINVAL;
-}
-
 static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
 					 unsigned long start,
 					 unsigned long end,
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f79ba6d1bf49..3870d096bb86 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -972,23 +972,6 @@ static void collapse_policy_khugepaged(struct collapse_policy *p)
 	p->tva_type = TVA_KHUGEPAGED;
 }
 
-/* MADV_COLLAPSE was asked for explicitly, so it is not held to those */
-static void collapse_policy_madvise(struct collapse_policy *p)
-{
-	p->pmd.max_ptes_none = HPAGE_PMD_NR;
-	p->pmd.max_ptes_swap = HPAGE_PMD_NR;
-	p->pmd.max_ptes_shared = HPAGE_PMD_NR;
-	/* Never read: MADV_COLLAPSE collapses to PMD order only */
-	p->sub_pmd = p->pmd;
-
-	p->anon_skip_lazyfree = false;
-	p->anon_require_referenced = false;
-	p->file_install_pmd = true;
-	p->file_writeback_dirty = true;
-	p->gfp = GFP_TRANSHUGE;
-	p->tva_type = TVA_FORCED_COLLAPSE;
-}
-
 #ifdef CONFIG_NUMA
 static int collapse_find_target_node(struct collapse_control *cc)
 {
@@ -2834,9 +2817,8 @@ enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
  *
  * Return: what the collapse made of the table.
  */
-enum scan_result collapse_run_pmd(struct mm_struct *mm,
-		unsigned long addr, enum scan_result result,
-		struct collapse_control *cc)
+enum scan_result collapse_run_pmd(struct mm_struct *mm, unsigned long addr,
+		enum scan_result result, struct collapse_control *cc)
 {
 	struct file *file = cc->scan_file;
 	bool triggered_wb = false;
@@ -3207,140 +3189,3 @@ bool current_is_khugepaged(void)
 {
 	return kthread_func(current) == khugepaged;
 }
-
-static int madvise_collapse_errno(enum scan_result r)
-{
-	/*
-	 * MADV_COLLAPSE breaks from existing madvise(2) conventions to provide
-	 * actionable feedback to caller, so they may take an appropriate
-	 * fallback measure depending on the nature of the failure.
-	 */
-	switch (r) {
-	case SCAN_ALLOC_HUGE_PAGE_FAIL:
-		return -ENOMEM;
-	case SCAN_CGROUP_CHARGE_FAIL:
-	case SCAN_EXCEED_NONE_PTE:
-		return -EBUSY;
-	/* Resource temporary unavailable - trying again might succeed */
-	case SCAN_PAGE_COUNT:
-	case SCAN_PAGE_LOCK:
-	case SCAN_PAGE_LRU:
-	case SCAN_DEL_PAGE_LRU:
-	case SCAN_PAGE_FILLED:
-	case SCAN_PAGE_HAS_PRIVATE:
-	case SCAN_PAGE_DIRTY_OR_WRITEBACK:
-		return -EAGAIN;
-	/*
-	 * Other: Trying again likely not to succeed / error intrinsic to
-	 * specified memory range. khugepaged likely won't be able to collapse
-	 * either.
-	 */
-	default:
-		return -EINVAL;
-	}
-}
-
-int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
-		     unsigned long end, bool *lock_dropped)
-{
-	struct collapse_control *cc;
-	struct mm_struct *mm = vma->vm_mm;
-	unsigned long hstart, hend, addr, orders;
-	enum scan_result last_fail = SCAN_FAIL;
-	int thps = 0;
-
-	BUG_ON(vma->vm_start > start);
-	BUG_ON(vma->vm_end < end);
-
-	orders = collapse_possible_orders(vma, vma->vm_flags,
-					  TVA_FORCED_COLLAPSE);
-	if (!orders)
-		return -EINVAL;
-
-	hstart = ALIGN(start, HPAGE_PMD_SIZE);
-	hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);
-
-	if (hstart >= hend)
-		return 0;
-
-	cc = kmalloc_obj(*cc);
-	if (!cc)
-		return -ENOMEM;
-	collapse_control_init(cc);
-	collapse_policy_madvise(&cc->policy);
-
-	lru_add_drain_all();
-
-	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
-		struct vm_area_struct *found;
-		enum scan_result result;
-
-		/*
-		 * A collapse gives the lock up, so the VMA has to be found
-		 * again after one: it can shrink while nothing is held.  A scan
-		 * that finds nothing to collapse leaves the lock alone, so a
-		 * range that is already collapsed walks on without relocking.
-		 */
-		if (!vma) {
-			cond_resched();
-			mmap_read_lock(mm);
-			result = collapse_vma_revalidate(mm, addr, false, &found,
-							 cc, HPAGE_PMD_ORDER);
-			if (result != SCAN_SUCCEED) {
-				last_fail = result;
-				goto out_locked;
-			}
-			vma = found;
-			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
-			orders = collapse_possible_orders(vma, vma->vm_flags,
-							  TVA_FORCED_COLLAPSE);
-		}
-
-		result = collapse_scan_pmd(vma, addr, cc, orders);
-		/* Nothing to do here, and the lock is still ours */
-		if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
-			goto tally;
-
-		/* The collapse takes its own locks, so give this up */
-		mmap_read_unlock(mm);
-		*lock_dropped = true;
-		vma = NULL;
-
-		result = collapse_run_pmd(mm, addr, result, cc);
-tally:
-		switch (result) {
-		case SCAN_SUCCEED:
-		case SCAN_PMD_MAPPED:
-			++thps;
-			break;
-		/* Whitelisted set of results where continuing OK */
-		case SCAN_NO_PTE_TABLE:
-		case SCAN_PTE_NON_PRESENT:
-		case SCAN_PTE_UFFD:
-		case SCAN_LACK_REFERENCED_PAGE:
-		case SCAN_PAGE_NULL:
-		case SCAN_PAGE_COUNT:
-		case SCAN_PAGE_LOCK:
-		case SCAN_PAGE_COMPOUND:
-		case SCAN_PAGE_LRU:
-		case SCAN_DEL_PAGE_LRU:
-			last_fail = result;
-			break;
-		default:
-			last_fail = result;
-			/* Other error, exit */
-			goto out;
-		}
-	}
-
-out:
-	/* Caller expects us to hold mmap_lock on return */
-	if (!vma)
-		mmap_read_lock(mm);
-out_locked:
-	mmap_assert_locked(mm);
-	kfree(cc);
-
-	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
-			: madvise_collapse_errno(last_fail);
-}
diff --git a/mm/madvise.c b/mm/madvise.c
index 963337f93a7a..acb5215e2f07 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -38,6 +38,7 @@
 
 #include "internal.h"
 #include "swap.h"
+#include "collapse.h"
 
 #define __MADV_SET_ANON_VMA_NAME (-1)
 
@@ -906,6 +907,172 @@ bool madvise_dontneed_free_valid_vma(struct madvise_behavior *madv_behavior)
 	return true;
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+
+/* MADV_COLLAPSE was asked for explicitly, so it is not held to those */
+static void collapse_policy_madvise(struct collapse_policy *p)
+{
+	p->pmd.max_ptes_none = HPAGE_PMD_NR;
+	p->pmd.max_ptes_swap = HPAGE_PMD_NR;
+	p->pmd.max_ptes_shared = HPAGE_PMD_NR;
+	/* Never read: MADV_COLLAPSE collapses to PMD order only */
+	p->sub_pmd = p->pmd;
+
+	p->anon_skip_lazyfree = false;
+	p->anon_require_referenced = false;
+	p->file_install_pmd = true;
+	p->file_writeback_dirty = true;
+	p->gfp = GFP_TRANSHUGE;
+	p->tva_type = TVA_FORCED_COLLAPSE;
+}
+
+static int madvise_collapse_errno(enum scan_result r)
+{
+	/*
+	 * MADV_COLLAPSE breaks from existing madvise(2) conventions to provide
+	 * actionable feedback to caller, so they may take an appropriate
+	 * fallback measure depending on the nature of the failure.
+	 */
+	switch (r) {
+	case SCAN_ALLOC_HUGE_PAGE_FAIL:
+		return -ENOMEM;
+	case SCAN_CGROUP_CHARGE_FAIL:
+	case SCAN_EXCEED_NONE_PTE:
+		return -EBUSY;
+	/* Resource temporary unavailable - trying again might succeed */
+	case SCAN_PAGE_COUNT:
+	case SCAN_PAGE_LOCK:
+	case SCAN_PAGE_LRU:
+	case SCAN_DEL_PAGE_LRU:
+	case SCAN_PAGE_FILLED:
+	case SCAN_PAGE_HAS_PRIVATE:
+	case SCAN_PAGE_DIRTY_OR_WRITEBACK:
+		return -EAGAIN;
+	/*
+	 * Other: Trying again likely not to succeed / error intrinsic to
+	 * specified memory range. khugepaged likely won't be able to collapse
+	 * either.
+	 */
+	default:
+		return -EINVAL;
+	}
+}
+
+static int madvise_collapse(struct madvise_behavior *madv_behavior)
+{
+	struct madvise_behavior_range *range = &madv_behavior->range;
+	struct vm_area_struct *vma = madv_behavior->vma;
+	struct mm_struct *mm = madv_behavior->mm;
+	struct collapse_control *cc;
+	unsigned long hstart, hend, addr, orders;
+	enum scan_result last_fail = SCAN_FAIL;
+	int thps = 0;
+
+	BUG_ON(vma->vm_start > range->start);
+	BUG_ON(vma->vm_end < range->end);
+
+	orders = collapse_possible_orders(vma, vma->vm_flags,
+					  TVA_FORCED_COLLAPSE);
+	if (!orders)
+		return -EINVAL;
+
+	hstart = ALIGN(range->start, HPAGE_PMD_SIZE);
+	hend = ALIGN_DOWN(range->end, HPAGE_PMD_SIZE);
+
+	if (hstart >= hend)
+		return 0;
+
+	cc = kmalloc_obj(*cc);
+	if (!cc)
+		return -ENOMEM;
+	collapse_control_init(cc);
+	collapse_policy_madvise(&cc->policy);
+
+	lru_add_drain_all();
+
+	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
+		struct vm_area_struct *found;
+		enum scan_result result;
+
+		/*
+		 * A collapse gives the lock up, so the VMA has to be found
+		 * again after one: it can shrink while nothing is held.  A scan
+		 * that finds nothing to collapse leaves the lock alone, so a
+		 * range that is already collapsed walks on without relocking.
+		 */
+		if (!vma) {
+			cond_resched();
+			mmap_read_lock(mm);
+			result = collapse_vma_revalidate(mm, addr, false, &found,
+							 cc, HPAGE_PMD_ORDER);
+			if (result != SCAN_SUCCEED) {
+				last_fail = result;
+				goto out_locked;
+			}
+			vma = found;
+			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
+			orders = collapse_possible_orders(vma, vma->vm_flags,
+							  TVA_FORCED_COLLAPSE);
+		}
+
+		result = collapse_scan_pmd(vma, addr, cc, orders);
+		/* Nothing to do here, and the lock is still ours */
+		if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
+			goto tally;
+
+		/* The collapse takes its own locks, so give this up */
+		mmap_read_unlock(mm);
+		mark_mmap_lock_dropped(madv_behavior);
+		vma = NULL;
+
+		result = collapse_run_pmd(mm, addr, result, cc);
+tally:
+		switch (result) {
+		case SCAN_SUCCEED:
+		case SCAN_PMD_MAPPED:
+			++thps;
+			break;
+		/* Whitelisted set of results where continuing OK */
+		case SCAN_NO_PTE_TABLE:
+		case SCAN_PTE_NON_PRESENT:
+		case SCAN_PTE_UFFD:
+		case SCAN_LACK_REFERENCED_PAGE:
+		case SCAN_PAGE_NULL:
+		case SCAN_PAGE_COUNT:
+		case SCAN_PAGE_LOCK:
+		case SCAN_PAGE_COMPOUND:
+		case SCAN_PAGE_LRU:
+		case SCAN_DEL_PAGE_LRU:
+			last_fail = result;
+			break;
+		default:
+			last_fail = result;
+			/* Other error, exit */
+			goto out;
+		}
+	}
+
+out:
+	/* Caller expects us to hold mmap_lock on return */
+	if (!vma)
+		mmap_read_lock(mm);
+out_locked:
+	mmap_assert_locked(mm);
+	kfree(cc);
+
+	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
+			: madvise_collapse_errno(last_fail);
+}
+
+#else	/* CONFIG_TRANSPARENT_HUGEPAGE */
+
+static int madvise_collapse(struct madvise_behavior *madv_behavior)
+{
+	return -EINVAL;
+}
+
+#endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
+
 static long madvise_dontneed_free(struct madvise_behavior *madv_behavior)
 {
 	struct mm_struct *mm = madv_behavior->mm;
@@ -1373,8 +1540,7 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 	case MADV_DONTNEED_LOCKED:
 		return madvise_dontneed_free(madv_behavior);
 	case MADV_COLLAPSE:
-		return madvise_collapse(vma, range->start, range->end,
-			&madv_behavior->lock_dropped);
+		return madvise_collapse(madv_behavior);
 	case MADV_GUARD_INSTALL:
 		return madvise_guard_install(madv_behavior);
 	case MADV_GUARD_REMOVE:
-- 
2.54.0


