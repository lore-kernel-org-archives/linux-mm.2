Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 348FCC5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:48:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8ECF6B0890; Sun, 16 Aug 2026 18:47:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3F446B0891; Sun, 16 Aug 2026 18:47:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BB6F6B0892; Sun, 16 Aug 2026 18:47:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 650E06B0890
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D26AD1205FA
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:24 +0000 (UTC)
X-FDA: 85108620408.12.3C1D0AA
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf01.hostedemail.com (Postfix) with ESMTP id D2EA940009
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="0 TKJLNx";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Qt1zivLi;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4iXJOXAQHj2CY1FuoUAjEsT25SgdR4G2WYeHbr672pA=;
	b=yd3CQ0OsrHofIUeMj/eGLaAOTlSbV9YYT9BJI9rKcRFBe1OyGkOAi6Jx8mGbteHxNmeEdK
	4DYVesEyM4plpVW2Aek1HIXKDVRmZysVewfaKYv9U1JO1f521CX23cGeVuZl1KANbv629d
	fYjAUUArRmlv+QM8HU8grGk4hzRY9BU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="0 TKJLNx";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Qt1zivLi;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920442;
	b=JMtS7w4Z4pK/GX3yyKxcz552C9OXDW/OnjqGaS0uWLkDcTuqGjMP08oDwjVOHyOCUt7vxy
	rSCsMvkPNo61TU7UIaxQAA1JiVOLCYeud9ot+m3QONlsFHo3rI5XWzmUioIQyA09emF2n7
	PcRrKu9XiRUtcDrc23ujsdNKGNebcg0=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 6ACC9EC0243;
	Sun, 16 Aug 2026 18:47:22 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Sun, 16 Aug 2026 18:47:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920442; x=
	1787006842; bh=4iXJOXAQHj2CY1FuoUAjEsT25SgdR4G2WYeHbr672pA=; b=0
	TKJLNxHxHvDTi1JO5KJFcfrhZXanz89LFVOf4ilaSlwQgpSTm7QWtQRimntdF5p0
	n/EF9qklNjR2uCIUuju2KAWMJconEDDI495F5fd5elc8QcCjl04Xw/HqGjgwwPDy
	LVmCJPf7Zym5bLWqQoLBElgKw0KaINCDJwYq5PEWclF5fahzo+Al+tVzVZduzc8V
	iq/kKSfK8pqQSFP26270CsOOjSP14QNSTn3cbn4MiOF0356ySRInnronoVsxOsYo
	zwiVM3T3eCshiUGrfSZe2bt0w0AU3a8u3ylEZqzIlJhajEFrNxgO/be7y9iknHtj
	NRgN5LRz2RFsqLwsAnikA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920442; x=1787006842; bh=4
	iXJOXAQHj2CY1FuoUAjEsT25SgdR4G2WYeHbr672pA=; b=Qt1zivLiWpZFt3wta
	bvZjbH7EaUemCPXzSummZwE1ZYZZ+6g95taLyQ5c5hMMMuXVQ/ilzOkJgaxb0puk
	0nTZDEf5RW9ym/62Hb3gWGIYzHDgFP8RM/fOS95BZBrzZ89obtp+2N13jNwTVcdI
	e5913E0SIptTjhlwKKcMAfLybKLnNWDf/8BDWifYF146YNmqh54PiWDeeFELOHK/
	Frw4AAZohmormhTAtH4Zhp8BGUAY5zke/tK3SbhhfD558L27tgsKDZbL/bPCbId3
	l407ebVIaTf7VKi3FXwmxA1FouJCNGepkRskrPVhE3dZISl/4d0lfWJNApLkm+N0
	LAjng==
X-ME-Sender: <xms:-j2CatpOsRSeIzXwzJjVN6iN-YKGHJXF7KHAFYYA4UKNHOeqfYdesA>
    <xme:-j2Cavmvr9jsnn_Hnua-KN4Q5cfOCVKJ9M9Ye_p9yykq2DseAztpl4hXM7QnTBFk9
    R7X99TC0VO1LveYo_7bn0yQwswZXxpwUTBrV5DVOarRWNROkhYOzPR1>
X-ME-Received: <xmr:-j2CalzBdFJVfCxzvh9XKkL1d--pWSi8DqtWH6uhPuJwpOvtuaNjHYNMgvU>
X-ME-Proxy-Cause: dmFkZTGQiHMMNOd1xnoN6lXQSIrGAe7MwYo75Qud3VSOh3aIjL1T4IX+wE1i/v23Y8aWnG
    m9SHT5inuXsr6fNeLF7q+XcMZ+pkZJxjpb2XQQyKrFdYKaLz7QDFEiegvQaT+Y5rGxRgjF
    euipinLXiFMtCpFgMqQP9Dwn4SHq3YG285QsMU4KB7YfRQHYWKIG6dJTmdP/7bPKv1qUNe
    3LkhBXaaROXWrLGafj+UVrogU8Abxo2OvgWTBKIlLl3SY5Eb27sggkfdoaZJgpjY1+W5mK
    IYgTH3bmg7umgeRjJmx+WAhyhWPmGn2xLzWKHa3nzXVCTdFk2+6Uh9D41+s+1+4ThvFtWC
    NAyvoHSHbEIY0NAsm0LaLE+G1U7bQRd7xlETqJv5zW95qYCPd700IVMa68R8Moc34GA1i+
    gm9TISZCFWIb/mVF32aBjGXoy9/OTcQw1SJLqFnJ6MVH8f+sWdnXGMmNW9GJViGimaynlq
    Bgx2NQMcbYJRpelOJJtGx1D9s5SAzCfWiUQHyjvO4/TDl+cGEWwR6X5GpK7r/VDxSI0yQM
    Dekgauzsswp5pbCNuPQ8dAYstyi2KSMy+pRNFz4PJ2Ef5H5Gbge/Q8j2nN2vOVsoIApq4q
    u2dDI9evWydLU7pmgESPRnN5Pdm1JBhAmbUcJZHRjU0rpmb9GBH+ONBAp33Q
X-ME-Proxy: <xmx:-j2Cat1QB2e4JtilKVL7vUJi-dduDBHXCDQJEAY3SLsYJNWP-T2CgQ>
    <xmx:-j2CamageT91UOjGGsIoKRAdtY3DXtAfV-bSYkAblP2dzBP6iLEvtQ>
    <xmx:-j2CaslMwLuey05SWgD3U837nfZvDXsLlmfcFE_og_pG3FiCqgNu7A>
    <xmx:-j2CanxdVkZXhUlqdGsalLPzsNCzmG1IWn8xDP_H2DJpWHXOkpdX2w>
    <xmx:-j2CasA802Rjs8caf0x8B44jsYS_t0Zk-Thr-aTrKNOJ5s2xjq0lctsD>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:21 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 34/57] mm/collapse: implement MADV_COLLAPSE in madvise.c
Date: Sun, 16 Aug 2026 23:45:46 +0100
Message-ID: <20260816224609.308019-35-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D2EA940009
X-Rspamd-Server: rspam07
X-Stat-Signature: yogmun3q93qiyrs4pd9b1ufmwkmawnx1
X-HE-Tag: 1786920442-900693
X-HE-Meta: U2FsdGVkX18y+yXXPGLgovtlB525GcJaFcFOeorvLZXwEuHDyxMYlzaKi7SiBAwCgY+YnzSYaQ6uvpx+WG5NYW7BrvGz2TL8ZoGLgvz1dWjkyfVoPkKDtA6NKBWHF0h69UUQZfYyVPfZO2cQLHMebvfQFXf3ulpUvC/Cyef5551NgxGSnD1z5g1tTaZU+seJ37B0jVGW42iVYNTqKScU86CflScZI3tWY4IpI7Vf0nHNKTRMmXK5sg5VUBpEMvnCiMns/40ykQGhbHiCkibX5c7FdeaIFwYAmkoHEe05rm3rIgKxO/LonHw6lv2ZGl+JV4oQp/ILI8Nl1VcUiX7Mlqd9n6moe23LEix1czppqcqI0fgEW/Jk4hIX5TsS0xqzQSQs2gT+yu4HKLwswHO50Bh5bWMOTUEkyYosEZXAnLMaVDQXogak1NGVdNkdL1GV/mnmnqeqigsPim/4T5oAqwXZC23nOI6AdzZWMhELzu2i4Us2kkcOOZPExprD3sdFYqcw8gQsk3e5uuxNAwaW0fLXQ0PCTsSEFnuZzQU2pF2tmevSLwv4ozhC6nwkseCVxHkBdyCjc5mleMwsrrgicg8b1lakpjsVuWftVeGVX4KExWmd2sob2qbGzYfJcdl2IARwWaclTqYjrUiuAQZP7n9ydI1eWk3PvkKo+7IQPOMOkV8HtGe8JSWeKf4rzi7CTKtPCQu8m4wTo2bASYK4bNjlvd1ZB1tDb1JqgrGLekKYaB/N3CUut2anqLa7abVWIjnTrQK4vnSMBayu/VfyOs8s6igt1YGICXQIHbLzble5af6G9uSLRECFyMU7ZEdGgFxTOFXpxWUhd5+dPo7ynBCethEwvUMibe4KBpUuHHz5Rx83JYL5rQIepHkYrfbiVi5jVKqrZ30t+EYOqENLqCddV9gSUxpZ0pDuUbrcCR41i7maJehrNr5frBCpFaHU8FzcRId4dCR8YubGO2n
 dQf/YRF8
 ifg1b6gAD6877VNClKKaWcYRtpu8RpG0F7uupxevEhfP7S9uf0mHzmyIsgfGWiVqniFfR4t5Ara27kXhbFx6P2v9aXbeZWs8ojtmDkw04vQJJFQQZTaoKDVwpQtZNcp3abqJY81lLc1MNdKSbtClVgiyr25nw6qPFWzyUBfIso7OZdVKqqaLv8IeXrwv3K0w5ZAXx8UnbE5esSE+DPJsYIp1fM3+UBUZ9Yo8S2wJtbVFmhx4AjUlJCrxDsVaaUzqDuvan+KUkB+TUe2w8RJl/HzodijWtUPIPhk+FDFzf8Kexq+gy8qMyu8v4dqBzHLBxpJEwcn6dq0KLhE0Trs34ROIFQmX6QgEcGDwR3ZfDTg8GRyQ3SR7zBb53UeF9uaNYdtvXBD0/9td+MIQN/MeKzTOybajQcA75Y3svAezrDssLGaENYPxS/pmz3eQr/lcVxcaqsc0MKKFlepL1pWswIDXIVtHfaYjiA/ic8kJl8fcvllmifkhJMHHqoA==
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
range, the per-PMD loop, and the errno translation that reports back
through madvise(2).

Move it to madvise.c, among the operations it belongs with, along with the
errno map and the policy it states for itself.  It takes a struct
madvise_behavior like every one of those operations, which is where the
range, the VMA and the lock-dropped flag it used to be handed separately
already live.

It stays a caller of the same interface khugepaged uses, so nothing about
the collapse changes.  The eligibility test reads
collapse_possible_orders() rather than collapse_possible(), a static
wrapper around it that madvise.c cannot reach.

With the declaration in huge_mm.h no longer needed, the
!CONFIG_TRANSPARENT_HUGEPAGE stub moves in with it.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/huge_mm.h |   9 --
 mm/khugepaged.c         | 182 -------------------------------------
 mm/madvise.c            | 195 +++++++++++++++++++++++++++++++++++++++-
 3 files changed, 193 insertions(+), 193 deletions(-)

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
index 47c134cd4129..967cc472b6dc 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -844,185 +844,3 @@ bool current_is_khugepaged(void)
 {
 	return kthread_func(current) == khugepaged;
 }
-
-/* MADV_COLLAPSE was asked for explicitly, so it is not held to those. */
-static void collapse_policy_forced(struct collapse_policy *p)
-{
-	p->max_ptes_none = HPAGE_PMD_NR;
-	p->max_ptes_swap = HPAGE_PMD_NR;
-	p->max_ptes_shared = HPAGE_PMD_NR;
-	p->strict_sub_pmd = false;
-	p->skip_lazyfree = false;
-	p->require_referenced = false;
-	p->install_pmd = true;
-	p->writeback_dirty = true;
-	p->gfp = GFP_TRANSHUGE;
-	p->tva_type = TVA_FORCED_COLLAPSE;
-}
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
-	unsigned long hstart, hend, addr;
-	/* What the VMA allows; valid only while its lock is held */
-	unsigned long vma_orders;
-	enum scan_result last_fail = SCAN_FAIL;
-	int thps = 0;
-	int err;
-
-	BUG_ON(vma->vm_start > start);
-	BUG_ON(vma->vm_end < end);
-
-	if (!collapse_possible(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
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
-	collapse_policy_forced(&cc->policy);
-	cc->progress = 0;
-	err = collapse_control_init(cc);
-	if (err) {
-		kfree(cc);
-		return err;
-	}
-
-	mmgrab(mm);
-
-	/*
-	 * Nothing below wants the lock the VMA walk left held, and
-	 * lru_add_drain_all() waits on every CPU, so give it up first.  The
-	 * walk carries on under mmap_lock and its own caller is what drops it,
-	 * so reporting this only tells the walk that its VMA is now stale.
-	 */
-	mmap_read_unlock(mm);
-	*lock_dropped = true;
-	vma = NULL;
-	vma_orders = 0;
-	lru_add_drain_all();
-
-	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
-		enum scan_result result;
-
-		/*
-		 * A collapse gives the lock up, and the VMA has to be found
-		 * again after one: it can shrink while nothing is held.  A scan
-		 * that finds nothing to collapse leaves the lock alone, so a
-		 * range that is already collapsed walks it without relocking.
-		 *
-		 * Reschedule only here, where nothing is held: a preemption
-		 * point under a lock is a writer waiting longer.
-		 */
-		if (!vma) {
-			cond_resched();
-			mmap_read_lock(mm);
-			vma = vma_lookup(mm, addr);
-			if (!vma) {
-				mmap_read_unlock(mm);
-				hend = addr;
-				break;
-			}
-			vma_orders = collapse_possible_orders(vma,
-					vma->vm_flags, TVA_FORCED_COLLAPSE);
-		}
-
-		/* If nothing to collapse, the lock is still ours */
-		if (!collapse_scan_pmd(vma, addr, addr + HPAGE_PMD_SIZE, cc,
-				       vma_orders)) {
-			result = cc->scan_refusal;
-		} else {
-			/* collapse_run_pmd() takes its own locks, so give this up */
-			mmap_read_unlock(mm);
-			vma = NULL;
-			/* The mask belonged to that lock, not to this range */
-			vma_orders = 0;
-
-			result = collapse_run_pmd(mm, addr,
-						  addr + HPAGE_PMD_SIZE, cc);
-		}
-
-		/*
-		 * The VMA shrank under us, so the rest of the range was never
-		 * ours to collapse: stop, and expect only what came before.
-		 */
-		if (result == SCAN_VMA_NULL || result == SCAN_ADDRESS_RANGE) {
-			hend = addr;
-			break;
-		}
-
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
-	/* The VMA walk this returns to expects the lock it was holding */
-	if (!vma)
-		mmap_read_lock(mm);
-	mmdrop(mm);
-	collapse_control_release(cc);
-	kfree(cc);
-
-	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
-			: madvise_collapse_errno(last_fail);
-}
diff --git a/mm/madvise.c b/mm/madvise.c
index c179938097bf..76ddf61f043f 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -894,6 +894,198 @@ bool madvise_dontneed_free_valid_vma(struct madvise_behavior *madv_behavior)
 	return true;
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#include "collapse.h"
+
+/* MADV_COLLAPSE was asked for explicitly, so it is not held to those. */
+static void collapse_policy_forced(struct collapse_policy *p)
+{
+	p->max_ptes_none = HPAGE_PMD_NR;
+	p->max_ptes_swap = HPAGE_PMD_NR;
+	p->max_ptes_shared = HPAGE_PMD_NR;
+	p->strict_sub_pmd = false;
+	p->skip_lazyfree = false;
+	p->require_referenced = false;
+	p->install_pmd = true;
+	p->writeback_dirty = true;
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
+	unsigned long hstart, hend, addr;
+	struct collapse_control *cc;
+	unsigned long vma_orders;
+	enum scan_result last_fail = SCAN_FAIL;
+	int thps = 0;
+	int err;
+
+	BUG_ON(vma->vm_start > range->start);
+	BUG_ON(vma->vm_end < range->end);
+
+	if (!collapse_possible_orders(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
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
+	collapse_policy_forced(&cc->policy);
+	cc->progress = 0;
+	err = collapse_control_init(cc);
+	if (err) {
+		kfree(cc);
+		return err;
+	}
+
+	mmgrab(mm);
+
+	/*
+	 * Nothing below wants the lock the VMA walk left held, and
+	 * lru_add_drain_all() waits on every CPU, so give it up first.  The
+	 * walk carries on under mmap_lock and its own caller is what drops it,
+	 * so reporting this only tells the walk that its VMA is now stale.
+	 */
+	mmap_read_unlock(mm);
+	mark_mmap_lock_dropped(madv_behavior);
+	vma = NULL;
+	vma_orders = 0;
+	lru_add_drain_all();
+
+	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
+		enum scan_result result;
+
+		/*
+		 * A collapse gives the lock up, and the VMA has to be found
+		 * again after one: it can shrink while nothing is held.  A scan
+		 * that finds nothing to collapse leaves the lock alone, so a
+		 * range that is already collapsed walks it without relocking.
+		 *
+		 * Reschedule only here, where nothing is held: a preemption
+		 * point under a lock is a writer waiting longer.
+		 */
+		if (!vma) {
+			cond_resched();
+			mmap_read_lock(mm);
+			vma = vma_lookup(mm, addr);
+			if (!vma) {
+				mmap_read_unlock(mm);
+				hend = addr;
+				break;
+			}
+			vma_orders = collapse_possible_orders(vma,
+					vma->vm_flags, TVA_FORCED_COLLAPSE);
+		}
+
+		/* If nothing to collapse, the lock is still ours */
+		if (!collapse_scan_pmd(vma, addr, addr + HPAGE_PMD_SIZE, cc,
+				       vma_orders)) {
+			result = cc->scan_refusal;
+		} else {
+			/* collapse_run_pmd() takes its own locks, so give this up */
+			mmap_read_unlock(mm);
+			vma = NULL;
+			/* The mask belonged to that lock, not to this range */
+			vma_orders = 0;
+
+			result = collapse_run_pmd(mm, addr,
+						  addr + HPAGE_PMD_SIZE, cc);
+		}
+
+		/*
+		 * The VMA shrank under us, so the rest of the range was never
+		 * ours to collapse: stop, and expect only what came before.
+		 */
+		if (result == SCAN_VMA_NULL || result == SCAN_ADDRESS_RANGE) {
+			hend = addr;
+			break;
+		}
+
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
+	/* The VMA walk this returns to expects the lock it was holding */
+	if (!vma)
+		mmap_read_lock(mm);
+	mmdrop(mm);
+	collapse_control_release(cc);
+	kfree(cc);
+
+	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
+			: madvise_collapse_errno(last_fail);
+}
+
+#else
+static int madvise_collapse(struct madvise_behavior *madv_behavior)
+{
+	return -EINVAL;
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
 static long madvise_dontneed_free(struct madvise_behavior *madv_behavior)
 {
 	struct mm_struct *mm = madv_behavior->mm;
@@ -1361,8 +1553,7 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
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


