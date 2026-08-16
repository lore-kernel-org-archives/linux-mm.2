Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8B62C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:48:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDD8A6B088D; Sun, 16 Aug 2026 18:47:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8F2E6B088F; Sun, 16 Aug 2026 18:47:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2EDD6B0890; Sun, 16 Aug 2026 18:47:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C2036B088D
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DE4EB805E5
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:22 +0000 (UTC)
X-FDA: 85108620324.02.3096F13
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf27.hostedemail.com (Postfix) with ESMTP id F37C540003
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="U FFDVb0";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=mGaveY87;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920441;
	b=J3izgpRZbu859MMfjk8snMedbY36BlMw890CRLuADV2mHEQmzBaOujLdS91dPiW26jMN81
	bBZW8/OQoMtSRfmz5gnsGytxKKOdgqWC7qa4ptTk5jj0vxmx2oKHTo6yXzAs9OpCf3njgm
	LJGyL1MeytZZbe1xczYY9OFb9AAHnNI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="U FFDVb0";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=mGaveY87;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tVba+XTZdHa/dscPQvmcm/U9IhQHpFwuT7yBDkbY0DQ=;
	b=E8fJqI3OQWIl2r2SI2xJkryD6MDc5MJXOW0TNe7mVHCXC0hDiid880kITBmKfhq0O0wHL7
	RnQ4MJCHV6bht+Tx5XcHqPuejS+bxtQBh2MhpOVM36yo+dRTmVlvTn3F4iud2lQ5fnd6GC
	SfGzQg4pBQJQqvWjWjWyEav0hGGXiAU=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 9D6A8EC0235;
	Sun, 16 Aug 2026 18:47:20 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Sun, 16 Aug 2026 18:47:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920440; x=
	1787006840; bh=tVba+XTZdHa/dscPQvmcm/U9IhQHpFwuT7yBDkbY0DQ=; b=U
	FFDVb02XU3S3G1WNkrD19eUsTXs3NXE/7zdrXGCajZ2AlfDj5SMBX+byeh4mxPWJ
	TKRXOSYfCwXtLLQem3j3pmqKgIjr+sg2eEQr/pJsbRvfzW5rVXTz0AhYQjuN7juN
	CKAC248x7rsmyYL3l7DDphqHJX7cDiKQHgBP9PHEqgUkX/1pnZTxGVuKfUZoD/7H
	Thbcgy3SSYVksF1wjmz6frXWWr5x7H8joPfNbSFZM9fO24Unwv1zrETrcWVgy8Cz
	GaFEEz63U2z5aFBUghZZ51st9lwBI3E8jatPZZjqZ+gKVTecogzsU4CRchpbLUsS
	mFVX998aI2PSTLzi0BHhA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920440; x=1787006840; bh=t
	Vba+XTZdHa/dscPQvmcm/U9IhQHpFwuT7yBDkbY0DQ=; b=mGaveY87oB0cm5+aj
	FjboME9vnpTTfu8BXkJK7CVtLM0qhHtzHBiv2XBjmsu5r9YytlGNkwoekJ8y2ZEH
	kWudNpiWzyDHp74yr4BMdhhcT2eW3QJ8Y5cRBDjyBIqXv20SHQDghzDxwfKnInjN
	MeV0pyPNBYEYK8DeNcw1bcKksWHhn8MtKJ/pANsFd/JLBwgIVkrVcbi768+GM5Fc
	aoRpkWUojerhDgpbIDSPwtLrhTwzuUXTJHA0YtkUOZvoLnbis4vABLunXdjUQAKR
	m0R6T0NsmqzVcgbtllIFM4cqoBaFLkjnsNJ+H53RYmGXD4YQqXxw63xBy6VUAKcV
	txqXg==
X-ME-Sender: <xms:-D2Cav1c3HCO1-iRLd9F-2QRcmpAoDwFeyYPWPZAWM53sK7Rlv_gfA>
    <xme:-D2CajYbDvOIVMnstmQl59dVs5p6XniU1k4aAxKoRLVJRwhCMXT9VvWe0OnBhfprC
    bp1Vau4hFhXDrNSu7EgY9lg-uTFzllxxfpnUcisXEXsCEqX0t15Cpfb>
X-ME-Received: <xmr:-D2Car8RCnDkU1dW_1jjStjmUL3TMBgeLcsM4DMaxOz3f6cvHUtwVN5tS_g>
X-ME-Proxy-Cause: dmFkZTEWPmjqOfRj5F992yj4B4BZj1raD29b+9/uQ9rFyvaV+kr+0iJRDW/7N8sznN5hp3
    Jd0ytp1vu59bDzCFT/O8S/efKgYbCfD2rLp5ESvFXHBu+C+T7VPMHXocEWQmqRcTwN39e9
    beda2Ri+DmyXoylgECNlOmesAYSvAqjyQbPp39VciQhjDZLAdlalALq+T39tfvcBsAftOx
    0pZrMKicu8IddtrFqvBcFdG/5WkfJWvoJzqNqmEsI17lT+SJI8PEV94Md+CC1CjuERkMm2
    pW/0xtbQUhoKznxP8UdY68yvPC1FKG1sdD5CGoRhqiz0Y+ik+TmkR1x+Rv8Bp8o0DAMUDe
    xJSVVh9q+2wDLRmgw31VvVHCgFkXWkjkLBfJJme8xEC58rxNNC+IyRv4f9KacmZj6IY27S
    0qJosTUoPozktMyQF2/JdGirbhA3Foe35GQVTQBcL2hQC4RgWN+wR3pptB2L1mOR4QgPZV
    9Y9aDr4bo2/3/ib4cGB+zVs0l3x4xH9StKATJd518qqststirjaxVvywUp62WSv62liYbN
    10KCxs6d5IK3xDagGF7hK8wEZkYw1vdi0HigrV2bOrp6O70pSP6CQz5YssphOA8iCncGAn
    8wFh8GOHT2iQyCN4Y+jCXlqjoDjtf8JNd1dIh8jfIInw86kzHOYd5Yy81sqg
X-ME-Proxy: <xmx:-D2CahYL3JuzUrdamHu90feb3mFm7QpWQLaKS8cthJwBPLMMGcpA_A>
    <xmx:-D2CaoW9T1o5IDiv0q2LYiQWf4wcgTUe0BTLmXanZCVILYkAShkP3g>
    <xmx:-D2CavhN1jS9JAQWUECj40rupDdXjzC6G7b14Dj__QKY0029X9UcfQ>
    <xmx:-D2CaklXtFay76mlHcnIbhFDAeo0NI7eUMVbqlO6M-x92I45lN1YWA>
    <xmx:-D2CalLUkusK7YyRZAwizEhWU-KRzVelwUaXu-a0J3A9wTUgoo6rb1hI>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:19 -0400 (EDT)
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
Subject: [RFC PATCH 33/57] mm/collapse: split collapse into a scan and a run
Date: Sun, 16 Aug 2026 23:45:45 +0100
Message-ID: <20260816224609.308019-34-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F37C540003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: e4s69isj48tio69q1ts3xjcnxp88wpm9
X-HE-Tag: 1786920440-982635
X-HE-Meta: U2FsdGVkX19exPVQaIg46Ag/hQTnfUK0qXnqQjnvj0NkkoRZgEvKX3n+KKIkgXEJC9EfVI4yt6snOd6jFsayumJ+0TDvCWQ4SLiaqElWoDeczSyudxfCwWCjk6ynpYUqbSWHARm1ufwMB1y7YhDhq1QB4IMP8huR41zZmvT5Hq5BQuD0KVKyaMuCtr+5HemolShy/RtDGyF9xkMBhRwl6pBqSUNNxiJjrcTiIuzvu0eq05hzdFHFyE3qbgGtrK1Ptgno5wfpA/y7JsLzoDOl7ZjP6o8zA8rhomTrkNzGl1zzrVUJjYU5SOinZLdebRGDlmWFVU8iDL4KXiZ1hRSetA2lm/kb7lo9FgF/nTRNfhgCKtpQYHxhMATimYLqrTIm4r7NrJU1auSH+5bXRji0WPKPcszj8ioRd13onlNOJi57947SL/ixjeguwtHeKofpZ1Gfqw+sWgEzTO53a09WYdZvwj8s9KOOFF8TxxKjhajIAwzBzqc8AVAtnGsUh1z+XdIAoWsT/VrcPugA8FrOdJSPtocLOxZdo6MpQQQZR9vbJQiDC9MtLXQoXrOIB+RC2misDP53nPVEjnQGQPlXeI2/TWpM4rK2wFoT9ODpaLGeitsznyInLlRccDKywUW3/zizvXyrGWGzMh7NnW6sJt2rlhT2njxZ0LrMeY9vdyX0ShZ7vGSYqxINg+CwlUmDyRzXU6/rw4hZwDlDb4UvdaUYk4cviaGAjIKl48cm4DmFRJskKEfZ74gTt7Ttc4IAHjDzgrO9JBeL11TgSNgpW/yL426gZ1w/675YSkB1GpiOphjCOshW6yOdeVxwJ/+GxO6qtvjf2bEffDuO/bPphEtBS6xYwVBCDjyhcfHUMg7RD73FkBS0pvMqMS0/UDtlq0G0AND/IUa5y1WArFieG2TyREAUwNqtGKoUcR1uLUyEffMOcL+7p1x60xCNo5aWnxe+CnUAVA/2HGEXLim
 sJL1Ra8l
 D8r+6kdLX+b2V2HNOp1yWknS8rfoi/hnwQ40NDcqdPYvoK4I2R7CQUpTUo3sU3Q33nXQi/G5/fGY/ChN6NAn8fUBpCkPU4JlbGS88/Xsk1HIIx81A9ahdFqdtxnF5+ujbJU9ri4wUT8E9zWtKDYbXzntXO2F98DIR1dfHYo/mDNUo1ygZIMIuqaiLaYRU6dYTfXOjIT0Wz4RY8ue53nIylB+cSghqcMParpPY13wpZV8FP1oi1SAqID2S6Ts1NZSh3BKvQT9AhwMdJvh5f72PpE2IW+Ik4DL1QzkUdxFKSkSERYkj6jnQyLYAujExaWiAW4J3glEKFN2erFVeo6uw1AlUbO0SzMLk+OyqyPHkx5Bru4H9+PyJ/fWVLljvjFPbrwVPspan3OTl1y5gRBBqPK9JRB3meEP0XWj5+TSLmXvdBiR4DmzlWJL5zXsGI93rRpLrQpR+vdoWFS4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_single_pmd() did both halves of a collapse behind one call, and
dropped mmap_lock somewhere in the middle.  Which of its paths dropped it
was not something a caller could see, so it was handed back a bool and had
to keep track.

Both callers did that badly: khugepaged broke out of its VMA walk after
every table, collapsed or not, and MADV_COLLAPSE carried lock state
through its loop and re-took the lock only to hand it back.

Split it in two, with the lock as the boundary:

 - collapse_scan_pmd() judges one table and returns with mmap_lock still
   held.  It only reads, and almost every table it is offered has nothing
   in it, so a caller walks a whole VMA under the one lock it took to get
   there.
 - collapse_run_pmd() is called without the lock, which the caller gives
   up first, and takes it again per round.  What it does is slow enough
   that a writer would otherwise wait behind all of it.

Whether there is anything to run is the scan's return value, so no caller
has to ask about the lock.

The file side is what makes this more than a rename.  A file collapse
works on the page cache and never sees a VMA, but the file and the offset
have to come from one: the scan takes them while it still has the VMA, in
cc->scan_file and cc->scan_pgoff, and the run is what gives the reference
back.  A scan that found file work therefore has to be run, and
collapse_control_release() warns and drops the reference rather than rest
on callers getting that right.

The orders a VMA allows now come in as an argument.  khugepaged's walk
already computes that mask once per VMA, where the old shape recomputed it
twice for every table.  MADV_COLLAPSE keeps its own copy only while it
holds the VMA, and clears it beside vma = NULL: after the lock is given
up, the next lookup may return a different VMA.

khugepaged now stays in its VMA walk across every table it refuses, and
gives the lock up only for a table it is going to collapse.

MADV_COLLAPSE does the same.  It gives up the lock the VMA walk left held,
so lru_add_drain_all() does not wait on every CPU under it, then takes it
once and walks its whole range.  It drops that lock only around a
collapse, and looks the VMA up again only then, since nothing else can
have moved it.

Holding on across refusals is not new for anonymous memory -- the old
entry already returned with the lock held when a table had nothing in it
-- but it was never true of file ranges, and never something a caller
could rely on.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.c   | 167 +++++++++++++++++++++++++++++++-----------
 mm/collapse.h   |  48 ++++++++++++-
 mm/khugepaged.c | 188 +++++++++++++++++++++++-------------------------
 mm/mremap.c     |   2 +-
 4 files changed, 262 insertions(+), 143 deletions(-)

diff --git a/mm/collapse.c b/mm/collapse.c
index 21bfbc038044..f0d80204c2bd 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -401,6 +401,10 @@ static unsigned int candidate_offset(const struct collapse_candidate *cand,
 
 void collapse_control_release(struct collapse_control *cc)
 {
+	/* Only a scan that was never run leaves this behind */
+	if (WARN_ON_ONCE(cc->scan_file))
+		fput(cc->scan_file);
+
 	kfree(cc->candidates);
 	kfree(cc->saved_ptes);
 	kfree(cc->retries);
@@ -413,6 +417,10 @@ int collapse_control_init(struct collapse_control *cc)
 {
 	cc->nr_candidates = 0;
 	cc->nr_retries = 0;
+	cc->select_orders = 0;
+	cc->scan_refusal = SCAN_FAIL;
+	cc->scan_file = NULL;
+	cc->scan_pgoff = 0;
 	cc->candidates = kmalloc_objs(*cc->candidates, COLLAPSE_MAX_CANDIDATES);
 	cc->saved_ptes = kmalloc_objs(*cc->saved_ptes, COLLAPSE_SAVED_PTES);
 	cc->retries = kmalloc_objs(*cc->retries, COLLAPSE_RETRY_STORE_SIZE);
@@ -2116,7 +2124,8 @@ static void collapse_anon_scan_init(struct collapse_control *cc)
  */
 static enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
 					unsigned long start, unsigned long end,
-					struct collapse_control *cc)
+					struct collapse_control *cc,
+					unsigned long vma_orders)
 {
 	const unsigned long pmd_addr = start & HPAGE_PMD_MASK;
 	struct mm_struct *mm = vma->vm_mm;
@@ -2135,12 +2144,7 @@ static enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
 	/* Cleared only once a table has turned out to be there */
 	collapse_anon_scan_init(cc);
 
-	cc->select_orders = collapse_possible_orders(vma, vma->vm_flags,
-						     cc->policy.tva_type);
-	if (!cc->select_orders) {
-		cc->scan_refusal = SCAN_VMA_CHECK;
-		return cc->scan_refusal;
-	}
+	cc->select_orders = vma_orders;
 
 	/* The scan narrows select_orders to whatever is left worth trying */
 	cc->scan_refusal = collapse_scan_table(vma, pmd, start, end, cc);
@@ -2596,7 +2600,7 @@ static void count_collapse_event(unsigned int order, enum vm_event_item vm_event
 	count_mthp_stat(order, mthp_event);
 }
 
-static void collapse_control_init_scan(struct collapse_control *cc)
+static void collapse_file_scan_init(struct collapse_control *cc)
 {
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
@@ -3493,7 +3497,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	return result;
 }
 
-static enum scan_result collapse_scan_file(struct mm_struct *mm,
+static enum scan_result collapse_pagecache_pmd(struct mm_struct *mm,
 		unsigned long addr, struct file *file, pgoff_t start,
 		struct collapse_control *cc)
 {
@@ -3508,7 +3512,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 
 	present = 0;
 	swap = 0;
-	collapse_control_init_scan(cc);
+	collapse_file_scan_init(cc);
 	rcu_read_lock();
 	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
 		if (xas_retry(&xas, folio))
@@ -3600,46 +3604,65 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 }
 
 /*
- * Try to collapse a single PMD starting at a PMD aligned addr, and return
- * the results.
+ * Judge one table's worth of a file VMA.  All it needs of the VMA is the file and
+ * the offset, which it takes while it still has both; the collapse works on the
+ * page cache and never sees a VMA.
  */
-enum scan_result collapse_single_pmd(unsigned long addr,
-		unsigned long end, struct vm_area_struct *vma,
-		bool *lock_dropped, struct collapse_control *cc)
+static enum scan_result collapse_scan_file_pmd(struct vm_area_struct *vma,
+		unsigned long addr, struct collapse_control *cc)
 {
-	struct mm_struct *mm = vma->vm_mm;
+	enum scan_result result;
+	pmd_t *pmd;
+
+	/*
+	 * A file collapse only ever builds a PMD, so the whole table has to be
+	 * the VMA's -- a PMD shared with another VMA would need all of them
+	 * locked.  Not the question collapse_possible_orders() answered, which is
+	 * whether the VMA may use the order at all: this is whether the table at
+	 * @addr is wholly inside it.  While a file VMA collapses at PMD order
+	 * alone its callers hand over whole tables and this cannot fire, but the
+	 * anonymous side already hands over parts of one.
+	 */
+	if (!thp_vma_suitable_order(vma, addr, HPAGE_PMD_ORDER))
+		return SCAN_ADDRESS_RANGE;
+
+	/*
+	 * A PMD that is huge already has nothing left to collapse, and skipping
+	 * it here is what keeps mmap_lock out of a collapse that would find
+	 * nothing.  Everything else is worth the page cache scan, pmd_none()
+	 * included: a file range can be collapsed out of the cache without being
+	 * mapped first, which is why this is not the test the anonymous side
+	 * makes.
+	 */
+	result = find_pmd_or_thp_or_none(vma->vm_mm, addr & HPAGE_PMD_MASK, &pmd);
+	if (result == SCAN_PMD_MAPPED)
+		return result;
+
+	cc->scan_file = get_file(vma->vm_file);
+	cc->scan_pgoff = linear_page_index(vma, addr);
+
+	return SCAN_SUCCEED;
+}
+
+/*
+ * Build a PMD over what the page cache holds, and map it over the range if a huge
+ * folio is already there but mapped by PTEs.  Runs with no mmap_lock, which the
+ * caller gave up, and takes it again only for that last step.
+ */
+static enum scan_result collapse_file_pmd(struct mm_struct *mm,
+		unsigned long addr, struct collapse_control *cc)
+{
+	struct file *file = cc->scan_file;
 	bool triggered_wb = false;
 	enum scan_result result;
-	struct file *file;
-	pgoff_t pgoff;
 
-	mmap_assert_locked(mm);
-
-	if (vma_is_anonymous(vma)) {
-		result = collapse_scan_anon_pmd(vma, addr, end, cc);
-		if (!cc->select_orders)
-			goto end;
-
-		/* collapse_anon_pmd() takes mmap_lock itself, where it needs it */
-		mmap_read_unlock(mm);
-		*lock_dropped = true;
-
-		result = collapse_anon_pmd(mm, addr, end, cc);
-		goto end;
-	}
-
-	file = get_file(vma->vm_file);
-	pgoff = linear_page_index(vma, addr);
-
-	mmap_read_unlock(mm);
-	*lock_dropped = true;
 retry:
-	result = collapse_scan_file(mm, addr, file, pgoff, cc);
+	result = collapse_pagecache_pmd(mm, addr, file, cc->scan_pgoff, cc);
 
 	/* Dirty pages are worth a writeback and one more try, if asked for */
 	if (cc->policy.writeback_dirty && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
 	    !triggered_wb && mapping_can_writeback(file->f_mapping)) {
-		const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
+		const loff_t lstart = (loff_t)cc->scan_pgoff << PAGE_SHIFT;
 		const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
 
 		filemap_write_and_wait_range(file->f_mapping, lstart, lend);
@@ -3647,6 +3670,7 @@ enum scan_result collapse_single_pmd(unsigned long addr,
 		goto retry;
 	}
 	fput(file);
+	cc->scan_file = NULL;
 
 	if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
 		mmap_read_lock(mm);
@@ -3659,6 +3683,67 @@ enum scan_result collapse_single_pmd(unsigned long addr,
 			result = SCAN_SUCCEED;
 		mmap_read_unlock(mm);
 	}
-end:
+
 	return result;
 }
+
+/*
+ * Scan one table's worth of @vma and decide whether there is anything to collapse
+ * in it.  The caller holds mmap_lock for reading and still holds it when this
+ * returns: what is looked at is either the VMA or a page table that the lock
+ * keeps in place.
+ *
+ * Returns whether collapse_run_pmd() has anything to do, and a scan that found
+ * something has to be run: the file side takes a reference on the file while it
+ * still has the VMA to take it from, and the run is what gives it back.  What the
+ * scan turned down is left in cc->scan_refusal either way.
+ */
+bool collapse_scan_pmd(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long end, struct collapse_control *cc,
+		unsigned long vma_orders)
+{
+	struct mm_struct *mm = vma->vm_mm;
+
+	mmap_assert_locked(mm);
+
+	/*
+	 * What the scan answers with, so cleared before it runs.
+	 * collapse_anon_scan_init() clears the orders too, but only once the
+	 * table has turned out to be there.
+	 */
+	cc->select_orders = 0;
+
+	/* Ours to give back only if the last scan was never run */
+	if (WARN_ON_ONCE(cc->scan_file)) {
+		fput(cc->scan_file);
+		cc->scan_file = NULL;
+	}
+
+	if (unlikely(collapse_test_exit_or_disable(mm)))
+		cc->scan_refusal = SCAN_ANY_PROCESS;
+	else if (addr < vma->vm_start || end > vma->vm_end)
+		cc->scan_refusal = SCAN_ADDRESS_RANGE;
+	else if (!vma_orders)
+		cc->scan_refusal = SCAN_VMA_CHECK;
+	else if (vma_is_anonymous(vma))
+		collapse_scan_anon_pmd(vma, addr, end, cc, vma_orders);
+	else
+		cc->scan_refusal = collapse_scan_file_pmd(vma, addr, cc);
+
+	return cc->select_orders || cc->scan_file;
+}
+
+/*
+ * Collapse what the scan selected.  Called with no mmap_lock: the caller gives it
+ * up first, because a collapse takes it again for each round and revalidates
+ * under it, and holding it across the whole collapse would keep a writer to the
+ * address space waiting for it.
+ */
+enum scan_result collapse_run_pmd(struct mm_struct *mm, unsigned long addr,
+		unsigned long end, struct collapse_control *cc)
+{
+	if (cc->scan_file)
+		return collapse_file_pmd(mm, addr, cc);
+	else
+		return collapse_anon_pmd(mm, addr, end, cc);
+}
diff --git a/mm/collapse.h b/mm/collapse.h
index dc60806fb81e..4af7bb9c4261 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -150,6 +150,13 @@ struct collapse_control {
 	 */
 	enum scan_result scan_refusal;
 
+	/*
+	 * A reference the file side takes while it still has the VMA, since the
+	 * collapse runs without it, and the offset it decided on.
+	 */
+	struct file *scan_file;
+	pgoff_t scan_pgoff;
+
 	/* Why the last window was refused */
 	enum scan_result select_result;
 
@@ -187,12 +194,47 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
 		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
 }
 
+/*
+ * A caller states what it allows in the policy, takes a control for the arrays a
+ * round needs, and then hands over one PTE table's worth of a VMA at a time:
+ *
+ *	collapse_control_init(cc);		once per control
+ *	fill in cc->policy;			what this caller allows
+ *	collapse_scan_pmd(vma, addr, end, cc);	per table, as often as wanted
+ *	collapse_run_pmd(mm, addr, end, cc);	when the scan found work
+ *	collapse_control_release(cc);
+ *
+ * The caller holds mmap_lock for reading and passes a range within one PTE table
+ * of @vma.  A range the VMA does not cover is refused, which is also how a caller
+ * learns that its own range shrank.
+ *
+ * A scan returns with that lock still held: it only reads, and almost every table
+ * it is offered has nothing to collapse, so a caller walks a whole VMA under the
+ * one lock it took to get there.
+ *
+ * A collapse is called without it: the caller gives the lock up first, and with it
+ * @vma and anything derived under it, so a caller carrying on has to look up
+ * again.  What the collapse does -- allocate, quiesce, copy, flush -- is slow
+ * enough that a writer would wait behind it, so it takes the lock again per round
+ * instead, and revalidates rather than trusting what the scan saw.
+ *
+ * A scan that found something has to be run: the file side takes a reference on
+ * the file while it still has the VMA to take it from, and the run is what gives
+ * it back.  What it turned down is left in cc->scan_refusal, for a caller that has
+ * to report why a table was not collapsed.
+ *
+ * A control is not reentrant: it carries the arrays a round works out of, so one
+ * per collapsing thread.
+ */
 int collapse_control_init(struct collapse_control *cc);
 void collapse_control_release(struct collapse_control *cc);
-enum scan_result collapse_single_pmd(unsigned long addr, unsigned long end,
-		struct vm_area_struct *vma, bool *lock_dropped,
-		struct collapse_control *cc);
+bool collapse_scan_pmd(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long end, struct collapse_control *cc,
+		unsigned long vma_orders);
+enum scan_result collapse_run_pmd(struct mm_struct *mm, unsigned long addr,
+		unsigned long end, struct collapse_control *cc);
 
+/* Which orders a VMA may collapse to, empty when it may not collapse at all */
 unsigned long collapse_possible_orders(struct vm_area_struct *vma,
 		vm_flags_t vm_flags, enum tva_type tva_flags);
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b7fc93e11d6b..47c134cd4129 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -485,64 +485,6 @@ static void collapse_policy_khugepaged(struct collapse_policy *p)
 	p->tva_type = TVA_KHUGEPAGED;
 }
 
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
-/*
- * If mmap_lock temporarily dropped, revalidate vma
- * after taking the mmap_lock again.
- * Returns enum scan_result value.
- */
-
-static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
-		bool expect_anon, struct vm_area_struct **vmap,
-		struct collapse_control *cc, unsigned int order)
-{
-	struct vm_area_struct *vma;
-	enum tva_type type = cc->policy.tva_type;
-
-	if (unlikely(collapse_test_exit_or_disable(mm)))
-		return SCAN_ANY_PROCESS;
-
-	*vmap = vma = find_vma(mm, address);
-	if (!vma)
-		return SCAN_VMA_NULL;
-
-	/*
-	 * We cannot collapse VMA regions that do not span the full PMD. This is
-	 * due to the potential of the PMD being shared by another VMA leaving
-	 * us vulnerable to a race condition. Always check the PMD order here to
-	 * ensure its not shared by another VMA. We'd need to lock all VMAs in
-	 * the PMD range to support this.
-	 */
-	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
-		return SCAN_ADDRESS_RANGE;
-	if (!thp_vma_allowable_orders(vma, vma->vm_flags, type, BIT(order)))
-		return SCAN_VMA_CHECK;
-	/*
-	 * Anon VMA expected, the address may be unmapped then
-	 * remapped to file after khugepaged reacquired the mmap_lock.
-	 *
-	 * thp_vma_allowable_orders() may return true for qualified file
-	 * vmas.
-	 */
-	if (expect_anon && (!(*vmap)->anon_vma || !vma_is_anonymous(*vmap)))
-		return SCAN_PAGE_ANON;
-	return SCAN_SUCCEED;
-}
-
 static void collect_mm_slot(struct mm_slot *slot)
 {
 	struct mm_struct *mm = slot->mm;
@@ -636,8 +578,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			khugepaged_scan.address = hstart;
 
 		while (khugepaged_scan.address < hend) {
-			unsigned long pmd_addr, range_end;
-			bool lock_dropped = false;
+			unsigned long pmd_addr, range_end, start;
 
 			/* One table's worth at most, and never past the VMA */
 			pmd_addr = khugepaged_scan.address & HPAGE_PMD_MASK;
@@ -649,24 +590,24 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 
 			VM_WARN_ON_ONCE(khugepaged_scan.address < hstart);
 
-			*result = collapse_single_pmd(khugepaged_scan.address,
-						      range_end, vma,
-						      &lock_dropped, cc);
-			if (*result == SCAN_SUCCEED)
-				++khugepaged_pages_collapsed;
+			start = khugepaged_scan.address;
 			/* move to next address */
 			khugepaged_scan.address = range_end;
-			if (lock_dropped)
-				/*
-				 * We released mmap_lock so break loop.  Note
-				 * that we drop mmap_lock before all hugepage
-				 * allocations, so if allocation fails, we are
-				 * guaranteed to break here and report the
-				 * correct result back to caller.
-				 */
-				goto breakouterloop_mmap_lock;
-			if (cc->progress >= progress_max)
-				goto breakouterloop;
+
+			/* If nothing to collapse, the lock is still ours */
+			if (!collapse_scan_pmd(vma, start, range_end, cc, orders)) {
+				*result = cc->scan_refusal;
+				if (cc->progress >= progress_max)
+					goto breakouterloop;
+				continue;
+			}
+
+			/* collapse_run_pmd() takes its own locks, so give this up */
+			mmap_read_unlock(mm);
+			*result = collapse_run_pmd(mm, start, range_end, cc);
+			if (*result == SCAN_SUCCEED)
+				++khugepaged_pages_collapsed;
+			goto breakouterloop_mmap_lock;
 		}
 	}
 breakouterloop:
@@ -904,6 +845,21 @@ bool current_is_khugepaged(void)
 	return kthread_func(current) == khugepaged;
 }
 
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
 static int madvise_collapse_errno(enum scan_result r)
 {
 	/*
@@ -942,9 +898,10 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	struct collapse_control *cc;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long hstart, hend, addr;
+	/* What the VMA allows; valid only while its lock is held */
+	unsigned long vma_orders;
 	enum scan_result last_fail = SCAN_FAIL;
 	int thps = 0;
-	bool mmap_unlocked = false;
 	int err;
 
 	BUG_ON(vma->vm_start > start);
@@ -971,28 +928,67 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	}
 
 	mmgrab(mm);
+
+	/*
+	 * Nothing below wants the lock the VMA walk left held, and
+	 * lru_add_drain_all() waits on every CPU, so give it up first.  The
+	 * walk carries on under mmap_lock and its own caller is what drops it,
+	 * so reporting this only tells the walk that its VMA is now stale.
+	 */
+	mmap_read_unlock(mm);
+	*lock_dropped = true;
+	vma = NULL;
+	vma_orders = 0;
 	lru_add_drain_all();
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
-		enum scan_result result = SCAN_FAIL;
+		enum scan_result result;
 
-		if (mmap_unlocked) {
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
 			cond_resched();
 			mmap_read_lock(mm);
-			mmap_unlocked = false;
-			*lock_dropped = true;
-			result = hugepage_vma_revalidate(mm, addr, false, &vma,
-							 cc, HPAGE_PMD_ORDER);
-			if (result != SCAN_SUCCEED) {
-				last_fail = result;
-				goto out_nolock;
+			vma = vma_lookup(mm, addr);
+			if (!vma) {
+				mmap_read_unlock(mm);
+				hend = addr;
+				break;
 			}
-
-			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
+			vma_orders = collapse_possible_orders(vma,
+					vma->vm_flags, TVA_FORCED_COLLAPSE);
 		}
 
-		result = collapse_single_pmd(addr, addr + HPAGE_PMD_SIZE, vma,
-					     &mmap_unlocked, cc);
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
 
 		switch (result) {
 		case SCAN_SUCCEED:
@@ -1015,18 +1011,14 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 		default:
 			last_fail = result;
 			/* Other error, exit */
-			goto out_maybelock;
+			goto out;
 		}
 	}
 
-out_maybelock:
-	/* Caller expects us to hold mmap_lock on return */
-	if (mmap_unlocked) {
-		*lock_dropped = true;
+out:
+	/* The VMA walk this returns to expects the lock it was holding */
+	if (!vma)
 		mmap_read_lock(mm);
-	}
-out_nolock:
-	mmap_assert_locked(mm);
 	mmdrop(mm);
 	collapse_control_release(cc);
 	kfree(cc);
diff --git a/mm/mremap.c b/mm/mremap.c
index e8df5cdb0ac9..a25ac3db787a 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -244,7 +244,7 @@ static int move_ptes(struct pagetable_move_control *pmc,
 		goto out;
 	}
 	/*
-	 * Now new_pte is none, so collapse_scan_file() path can not find
+	 * Now new_pte is none, so collapse_pagecache_pmd() path can not find
 	 * this by traversing file->f_mapping, so there is no concurrency with
 	 * retract_page_tables(). In addition, we already hold the exclusive
 	 * mmap_lock, so this new_pte page is stable, so there is no need to get
-- 
2.54.0


