Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 268B1C5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:49:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A564E6B08A5; Sun, 16 Aug 2026 18:47:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07296B08A7; Sun, 16 Aug 2026 18:47:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F5A36B08A9; Sun, 16 Aug 2026 18:47:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 43B6E6B08A5
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5E63B12051E
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:45 +0000 (UTC)
X-FDA: 85108621290.08.8F89900
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf14.hostedemail.com (Postfix) with ESMTP id 75794100002
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="O SA76d6";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=WoWhU4ye;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ftB1HJ8Y15YVxr5O+cxOqWPRClS84lYkjsQI5VetnJA=;
	b=mKAt/eY5yGAkk0M+tdQoQ9bBi8WPJCe8cqkqwMWDaKTJlp0wa7mxUSkiIHSzjTSF4Jeicf
	1HyTWywDFNFRnr52LU9XlpeqF5V/PfxcEO8+YEqzrF/zVrpNF/KklPiEqx0A9X1S1h3eHJ
	53CFkNyvT/6FIKXWGO8prmwzyoTnrTU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920463;
	b=SNZL4reDawM938u0kA9UvAAf4WJ26tZm6klN65OoXm/WyJ9ub10ZXTgDizhBN38qwLvPBK
	ajmg+0LGpN63ynWL/5wKAIDS+Hcec2eHnvE0uwr5A/P5EExfubuC6JTRJMeu/ydVB8r7Li
	RJ8ldCzS06/HKpcxcii6gTzRSMc8ECQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="O SA76d6";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=WoWhU4ye;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 1197514000EB;
	Sun, 16 Aug 2026 18:47:43 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Sun, 16 Aug 2026 18:47:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920463; x=
	1787006863; bh=ftB1HJ8Y15YVxr5O+cxOqWPRClS84lYkjsQI5VetnJA=; b=O
	SA76d6nMTniIxLQ415JPsCD5DMqyGlEennXopHdxKTGu8qymvPyWzNMyvAZDGpAh
	hJf8Q74k9BzfvmJSAjmYJQCNGMutYbLSPUVm8dhMKEgi6U/lgX2ErtYzuZXEIXvI
	GxBu39nmjYPX4XycBzI/f1grk/PMJwaT0YdVsz6dXCDdrqmhrqZ5d0meTTOaJlxa
	JfMCD/yl+P5VEjyHyQai3w42hESA0DEUAwKGw62UAcSBVVTRgKHk0X602Oc3ZbNR
	Nvn4lar9sCGySd6c7QFVeN7zKbdtMm88FXHM1+ZuosVQ6nJSHTM/xeR+KB7zYZ3y
	kF/HP0BU4WseZZiNC/Eiw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920463; x=1787006863; bh=f
	tB1HJ8Y15YVxr5O+cxOqWPRClS84lYkjsQI5VetnJA=; b=WoWhU4yeuVWdXErGT
	FSsCSrQXGPmIxaMq8DPs7WSJw09tPvWM2cER/r/TNCJ9BYH8ZWlJISEpI4oUWF5A
	kmPb0AM4PSOX5z/iG6YXq5PvCAuXCa+H8Ns73K+etHAEVSoxSm4THccwyKdSKjy1
	BDA8bmo4cPNyiwtWDEUhWSVS/84wWVa+jCp1yG4RTGzDo60VssqMr/EG4wLQlvZU
	k0zP072hYNpL5H/sLBbS+byxeWL2PWlppyGcLF3vlgBlPeveGj/JBQvEipfOnYd4
	79IuMK9evW5eRERezTRxUxcgnpUj26TDiQRnkfrZJxHJPWyBe8nUxRj6Nox3/pAZ
	WyBUQ==
X-ME-Sender: <xms:Dj6Cav2zIIklEfM_Vq5-pbI9SZN4pRw70oRHHPtjMDMQetxa0KLyGw>
    <xme:Dj6Canroq3Q8WOutU2MSeHt3VBMr73-zoovLckArOx5Msnt5qKyB9pd5O9NDUKLqj
    aFIkjpvVKCRVrfFdCmhWFcH74gIBOONxw3Q3Ly4B8TfUH9975BQswVG>
X-ME-Received: <xmr:Dj6CarV6FBqK8O7btQ1T_JkFQmu4z0J_LG72HHFezgu4hF3YAAV39ES-ZDE>
X-ME-Proxy-Cause: dmFkZTFkhNC7YI+Ei0MrF6zu90W9yR7z714JmmtstcBEn9fnZ0JEx8KxNru7XjOIPijUAd
    VrNDumTIvQCtLJHAbrPKMRdbJsCYKY1AWxa28xNEDdkQaDqy3PIOJVA9R+OjsTN2M4dnB4
    WQk97ejO2lmWwXR5mw6146Dl5x2vSRCf1uehpA4Z3DNP/uvzS8DmGwE+/LsFmt9BQO6ZtJ
    eWd0dPZ2F0WrWW1tiYo0zV8d4Xgh8ztMbcUaDgwCK69ZeQi0ebesOWu50OSj19NNGHzec3
    w5R1etyOsXXy4NxsI/YxbKwNbzdBv+aWoLN5/PFLP+n740pr735uP0KJxEPqjezkxGUEae
    VbV3rMngkaPxQKuJpJI13Iuy9BW4VdoLWVjHaMCTYZzuReZcweII6OV6N7/eDhyeqRnM3U
    ZaRP0X5mK4wstAamKJjGnw1uyl2I1fZsgwkT91DxkdavZuHiuRFeu9WzlEiV6bYzz8TpAA
    dLfkb9PE5A3JzRKardx2vbuSZ+Ht+1ceDrUA3aw09PbBDyLGrX2AOrLz43qEIUSlbyaGxC
    tSayGSOXDkXXT0rR32+d3CFxt9XK340pkIj6m0BjxG9p46OD0dxAkc1BBoLJPIJT6NlKs5
    LWq6FThsDA/9lLgOC1LEnx6RW9EGDOFGdJ7sV1UKB0t2r9/y4E3uyLBgb/cg
X-ME-Proxy: <xmx:Dj6CajgeNJVjMjOFUvGdHB8B62tTaYEtDp5R-FK_kOXW2dmeyKcY2A>
    <xmx:Dz6Cai9M-NXN-KFHeh4OHi0nj20KmtlhpiVA3OpsYnmgy7EhxHFCFg>
    <xmx:Dz6CarT-RolCGw-rVuczxJhUjyMg_fFvJM1lUR0WHwMTILyso5fRVA>
    <xmx:Dz6CavHO-b5p_x5oDjoqf53-yvb50TvinlnsJ0zA8ALbjLbYoyKc7A>
    <xmx:Dz6CatidA6KwxzRiO4LuvG6JpL2qEzfBAJynxGBPj9bv55BCvXdR-6bh>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:42 -0400 (EDT)
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
Subject: [RFC PATCH 46/57] mm/khugepaged: scan under a per-VMA read lock
Date: Sun, 16 Aug 2026 23:45:58 +0100
Message-ID: <20260816224609.308019-47-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: excuw5rwx78bito8i1upmg4iw9r4drrn
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 75794100002
X-HE-Tag: 1786920463-998546
X-HE-Meta: U2FsdGVkX1+5hZ5jy9SXMOnODWBnzoO6WaAVJlsVYRAsPzfsom2zsRLZFQCp2nTMiY9B5kDs5yIGV5fBFVBZlnUHCapMsLDyJX6ACLHtI5onh0QBx/0t3DsRQ6H9gbLsD5c/EMHP+FHOdFd6/PgmcXvZUhu1OKhdGjy5BcdwQ+QjQ0xHMIcAe3PztmK7FC/50WihT0OcFNre5Wanoq0DX+JsDzpAJ4EwvK9fdaLUCQqf40gQEvaE4GeijYN3zToT9n8ONYL+0Qzm+7AB9MObRsmvT5BepCyWl50eOdRB2wkSSBRMNLZqKyag00xCKSZNElqwY55v23R3iepHEmDp/WvERw8vOKYjk5Dcwie0MCe1wtGEvtyY6bEEviMWtU6N7iR/0Ac0cwgaGNKjKvr003riYhnHLeSkvwzC69jNS7tm/lRoIHZx8ShGgTTV8U5sPMkeqPlfps7vKNtKvTcQy7AL2naFtiQVSMTUpRxzM5Tg2mHao3zdfwc9voXXtnIFBilhhnqxeouAvWfzTYAQ8X8zqG5fr8I3Ff6n+ZbtshTnGicE/IbPNMn4T0iyonUUIt0JKo1FwQn2Epkp4r9rI97/EB10afCpM/vESORcudGEk94dn7KxfZiIm7eg78GbF8rSE1f8mLC9bewaebAqYoBOjpVhN4af/NpvixeCaKzRl4EEvOEvyrB6bQv/uAI8MtKFzx2xjwKCYDrflFuB+BgxM5Ia91rYXN8cjVzA5pHUMQWVgB2C1OAV6KJHRmqmIxlw0bvJ0lhQv+etZdeG3NioM1imdm/0KJJLeAtVtAYGPGvrPypg7yelD134CcrfUfu5i1GN/vCCJihYD6TucHjTsnmFN1Qm1mUw2biDW9J/5hWItXytvhOMzKuNrkfIZEAfsE2qvahX6pAN6gkECVJl9IYWvLjICPqjjIN03VBPZT0FpYTNZpBkrcA0zCcvykapif+vwMXeqj1erK9
 PYKZNj+N
 Tu8H6jA+xBLTiR1JZTMxGef8lYeOPy5veFVMscVOYC+xpUJhRyq/wpwiMzworITHaUi7f6wyfFikodlPH/2zjafFsN6ICU0Z1Ba9b0vp/DZzu7t+lpHMCrouu/NHMz8viXDY9JW05vQzSEWkuuj6zg3mJ5Oz08Y7ktgugstukkWAqrEBYHwGCVyEKxz/XmNf7WllM71texGooYGjskzm+rwETYoFkh5INKuUPakIz6qp47vbCtpwf3h3MaIyuV6a+TIukbghD8mBgfgtyu0OIhAtnRcdUDng8Ti+ah40nz8se0Wst9GPiFuTZ0hcRTuo3BDUNV1gyh7meg+LQWf5f4lX3ciS6NDbDhWRiv6apXTRSD2ePxMyea614gHAFu46zamY7obn1ac64S+3j8MBf2Scg9WzKToehgaRsDE82xB2lQ3tN0zbeFTczPV+X8BCG7WAEpI05jdBIgrR9LYa3oyzRgKUmg3IUaC3jfT9ZmUu2+00=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

A pass took mmap_lock for the whole walk: every VMA of the address space
judged, and every table of every VMA scanned, under one lock.  A writer
anywhere in the mm waits for all of it.  And a pass that finds nothing to
collapse -- which is what a pass over an already-collapsed address space
is -- holds the lock for the whole sweep to say so.

Take a read lock on one VMA at a time instead.  lock_next_vma() finds the
next VMA at or after the cursor and locks it, falling back to mmap_lock
only where it cannot.  A scan holds that lock across every table of that
VMA and no longer.

What a round has to be excluded from already takes vma_start_write() on
the VMA it touches, so the exclusion is the same.  What changes is that it
is scoped to the VMA being scanned.

Two things follow from the iterator no longer being carried by mmap_lock.

The cursor moves by hand, because nothing else advances it now: past a VMA
that was walked, past one skipped without being looked at, and past each
table a scan was offered.

And the end of the address space has to be recognised rather than fallen
out of.  scan_complete says whether lock_next_vma() ran out of VMAs: an
error is not the end, and treating it as one would release the slot with
the address space half scanned.

The scan asserted mmap_assert_locked() on the way in.  Its two callers no
longer agree on what they hold -- khugepaged a VMA read lock from here,
MADV_COLLAPSE still mmap_lock -- so there is no single lock to assert, and
the assert goes.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.c   |  25 +++++-----
 mm/khugepaged.c | 128 +++++++++++++++++++++++++++++++-----------------
 2 files changed, 96 insertions(+), 57 deletions(-)

diff --git a/mm/collapse.c b/mm/collapse.c
index b6e92e24a3c5..b3343595bdf2 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -52,8 +52,8 @@ enum collapse_pass {
  * The folios mapped across a window of PTEs become one folio of that window's
  * order, with the sources quiesced by the two barriers migration uses --
  * migration entries in their PTEs, then a frozen refcount -- so the copy itself
- * needs no lock.  A collapse takes a read lock on the VMA for each round; a
- * scan still runs under the mmap_lock its caller holds.
+ * needs no lock.  A scan runs under a read lock on the VMA it was handed; a
+ * collapse is given none and takes its own, for one round at a time.
  *
  * A round carries a batch of candidate windows through the passes together,
  * rather than carrying one window through the whole collapse.  [ptl] and
@@ -1949,9 +1949,10 @@ static enum scan_result collapse_scan_table(struct vm_area_struct *vma,
 	 * wait for a scan of the whole table.
 	 *
 	 * pte_offset_map() holds rcu_read_lock() until pte_unmap(), which is
-	 * what keeps the table itself from being freed underneath the walk;
-	 * mmap_lock keeps the VMA attached, without which free_pgtables() could
-	 * free it without waiting for RCU at all.  Nothing below here sleeps.
+	 * what keeps the table itself from being freed underneath the walk; the
+	 * VMA read lock keeps the VMA attached, without which free_pgtables()
+	 * could free it without waiting for RCU at all.  Nothing below here
+	 * sleeps.
 	 */
 	pte = pte_offset_map(pmd, start);
 	if (!pte) {
@@ -2174,9 +2175,9 @@ static void collapse_anon_scan_init(struct collapse_control *cc)
 /*
  * Judge one table's worth of @vma, leaving in @cc what a collapse could use:
  * which orders are still worth attempting, and why the table was turned down if
- * some order was.  Holds mmap_lock throughout -- it only reads -- and a caller
- * that acts on what it found hands the range to collapse_anon_pmd() afterwards,
- * without the lock.
+ * some order was.  Holds the read lock it was called under throughout -- it only
+ * reads -- and a caller that acts on what it found hands the range to
+ * collapse_anon_pmd() afterwards, without any lock.
  */
 static enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
 					unsigned long start, unsigned long end,
@@ -3745,9 +3746,9 @@ static enum scan_result collapse_file_pmd(struct mm_struct *mm,
 
 /*
  * Scan one table's worth of @vma and decide whether there is anything to collapse
- * in it.  The caller holds mmap_lock for reading and still holds it when this
- * returns: what is looked at is either the VMA or a page table that the lock
- * keeps in place.
+ * in it.  The caller holds a read lock and still holds it when this returns:
+ * what is looked at is either the VMA or a page table that the lock keeps in
+ * place.
  *
  * Returns whether collapse_run_pmd() has anything to do, and a scan that found
  * something has to be run: the file side takes a reference on the file while it
@@ -3760,8 +3761,6 @@ bool collapse_scan_pmd(struct vm_area_struct *vma, unsigned long addr,
 {
 	struct mm_struct *mm = vma->vm_mm;
 
-	mmap_assert_locked(mm);
-
 	/*
 	 * What the scan answers with, so cleared before it runs.
 	 * collapse_anon_scan_init() clears the orders too, but only once the
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f3ea1846990e..1d77d9a8046d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -511,10 +511,10 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 	__releases(&khugepaged_mm_lock)
 	__acquires(&khugepaged_mm_lock)
 {
-	struct vma_iterator vmi;
 	struct mm_slot *slot;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
+	bool scan_complete = false;
 	unsigned int progress_prev = cc->progress;
 
 	lockdep_assert_held(&khugepaged_mm_lock);
@@ -534,55 +534,82 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 	vma = NULL;
 
 	/*
-	 * A reference on mm_users for as long as the pass works on this address
-	 * space.  __mmput() cannot start while one is held, so neither can
-	 * exit_mmap(), and the VMAs and page tables stay where they are.
+	 * Hold the address space open for the pass.  A collapse works under a
+	 * per-VMA read lock, and the barrier __khugepaged_exit() puts in front
+	 * of exit_mmap() -- mmap_write_lock() -- waits for a reader of
+	 * mmap_lock, not for a reader of one VMA.  A reference on mm_users
+	 * stops __mmput(), and so both of those, from starting at all.
 	 *
-	 * Once per pass, not once per table: the reference is what makes the
-	 * address space safe to work on, and a pass is how long that is wanted
-	 * for.  Nothing else in mm takes it per unit of work -- DAMON takes one
-	 * per target and walks every region under it, swapoff one per mm across
-	 * the whole address space, userfaultfd one per call.
+	 * Once per pass rather than once per table: the reference is what makes
+	 * the address space safe to work on, and the pass is how long that is
+	 * wanted for.  Nothing else in mm takes it per unit of work -- DAMON
+	 * takes one per target and walks every region under it, swapoff one per
+	 * mm across the whole address space, userfaultfd one per call.  It is
+	 * dropped below before the exiting mm is judged, so that judgement still
+	 * sees the true count.
 	 */
 	if (!mmget_not_zero(mm))
 		goto breakouterloop_no_mmput;
 
-	/*
-	 * Don't wait for semaphore (to avoid long wait times).  Just move to
-	 * the next mm on the list.
-	 */
-	if (unlikely(!mmap_read_trylock(mm)))
-		goto breakouterloop_mmap_lock;
-
 	cc->progress++;
-	if (unlikely(collapse_test_exit_or_disable_mmref(mm)))
-		goto breakouterloop;
 
-	vma_iter_init(&vmi, mm, khugepaged_scan.address);
-	for_each_vma(vmi, vma) {
+	/*
+	 * One VMA at a time, each held by its own read lock rather than by
+	 * mmap_lock over the whole address space.  lock_next_vma() locks what it
+	 * finds, falling back to mmap_lock only where it cannot.
+	 *
+	 * Whether this mm still wants collapsing is asked once, at the top of
+	 * each round of the loop.  Asking again before entering it only repeats
+	 * the same question: nothing between the two can answer it differently.
+	 */
+	for (;;) {
 		unsigned long hstart, hend, window;
+		struct vma_iterator vmi;
 		unsigned long orders;
 
 		cond_resched();
+		/*
+		 * Our reference is the reason the count cannot fall to zero, so
+		 * it is also what an address space whose owner has gone looks
+		 * like.  Stopping is what frees it: nothing else here would.
+		 */
 		if (unlikely(collapse_test_exit_or_disable_mmref(mm))) {
 			cc->progress++;
-			break;
+			goto breakouterloop;
 		}
 
 		/*
-		 * Before the VMA is judged, so that a pass over an address space
-		 * of VMAs it skips is bounded by the budget too: each one is
-		 * charged for, and none of them was being asked to be scanned.
+		 * Before a VMA is locked, so that a pass over an address space
+		 * of VMAs it skips is bounded by the budget too, and so that a
+		 * collapse returning here does not lock one to be told it is
+		 * out of budget.
 		 */
 		if (cc->progress >= progress_max)
-			break;
+			goto breakouterloop;
+
+		/* The first VMA at or after the cursor, which often sits in a gap */
+		rcu_read_lock();
+		vma_iter_init(&vmi, mm, khugepaged_scan.address);
+		vma = lock_next_vma(mm, &vmi, khugepaged_scan.address);
+		rcu_read_unlock();
+
+		/*
+		 * NULL is the end of the address space, and the only thing that
+		 * finishes this mm.  An error is a fatal signal or the unlikely
+		 * reference count overflow: leave the mm for the next pass
+		 * rather than treat it as walked.
+		 */
+		if (IS_ERR_OR_NULL(vma)) {
+			scan_complete = !IS_ERR(vma);
+			vma = NULL;
+			goto breakouterloop;
+		}
 
 		orders = collapse_possible_orders(vma, vma->vm_flags,
 						  TVA_KHUGEPAGED);
 		if (!orders) {
-			khugepaged_scan.address = vma->vm_end;
 			cc->progress++;
-			continue;
+			goto next_vma;
 		}
 
 		/*
@@ -595,9 +622,8 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 		hstart = ALIGN(vma->vm_start, window);
 		hend = ALIGN_DOWN(vma->vm_end, window);
 		if (khugepaged_scan.address > hend) {
-			khugepaged_scan.address = vma->vm_end;
 			cc->progress++;
-			continue;
+			goto next_vma;
 		}
 		if (khugepaged_scan.address < hstart)
 			khugepaged_scan.address = hstart;
@@ -605,19 +631,24 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 		while (khugepaged_scan.address < hend) {
 			unsigned long pmd_addr, range_end, start;
 
+			cond_resched();
+
+			if (unlikely(collapse_test_exit_or_disable_mmref(mm)) ||
+			    cc->progress >= progress_max) {
+				vma_end_read(vma);
+				vma = NULL;
+				goto breakouterloop;
+			}
+
 			/* One table's worth at most, and never past the VMA */
 			pmd_addr = khugepaged_scan.address & HPAGE_PMD_MASK;
 			range_end = min(hend, pmd_addr + HPAGE_PMD_SIZE);
-
-			cond_resched();
-			if (unlikely(collapse_test_exit_or_disable_mmref(mm)) ||
-			    cc->progress >= progress_max)
-				goto breakouterloop;
+			start = khugepaged_scan.address;
 
 			VM_WARN_ON_ONCE(khugepaged_scan.address < hstart);
+			VM_WARN_ON_ONCE(range_end > hend);
 
-			start = khugepaged_scan.address;
-			/* move to next address */
+			/* Move the cursor on regardless of what the scan says */
 			khugepaged_scan.address = range_end;
 
 			/* If nothing to collapse, the lock is still ours */
@@ -627,21 +658,30 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			}
 
 			/* collapse_run_pmd() takes its own locks, so give this up */
-			mmap_read_unlock(mm);
+			vma_end_read(vma);
+			vma = NULL;
+
 			*result = collapse_run_pmd(mm, start, range_end, cc);
 			if (*result == SCAN_SUCCEED)
-				++khugepaged_pages_collapsed;
-			goto breakouterloop_mmap_lock;
+				khugepaged_pages_collapsed++;
+			goto breakouterloop;
 		}
+next_vma:
+		/*
+		 * Past this VMA: the cursor has to move by hand, where the
+		 * mmap_lock iterator used to carry it.  A VMA that was walked
+		 * is charged by the scan itself, one table at a time; only one
+		 * passed over without being looked at is charged here.
+		 */
+		khugepaged_scan.address = vma->vm_end;
+		vma_end_read(vma);
+		vma = NULL;
 	}
+
 breakouterloop:
-	mmap_read_unlock(mm); /* exit_mmap will destroy ptes after this */
-breakouterloop_mmap_lock:
 	/*
 	 * Not mmput(): the last reference would run exit_mmap() here, and
 	 * khugepaged is not the thread that should tear an address space down.
-	 * Dropped before the exiting mm is judged below, so that judgement still
-	 * sees the true count.
 	 */
 	mmput_async(mm);
 breakouterloop_no_mmput:
@@ -652,7 +692,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 	 * Release the current mm_slot if this mm is about to die, or
 	 * if we scanned all vmas of this mm, or THP got disabled.
 	 */
-	if (collapse_test_exit_or_disable(mm) || !vma) {
+	if (collapse_test_exit_or_disable(mm) || scan_complete) {
 		/*
 		 * Make sure that if mm_users is reaching zero while
 		 * khugepaged runs here, khugepaged_exit will find
-- 
2.54.0


