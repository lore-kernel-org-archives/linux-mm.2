Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8E05C5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:49:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2946B08A7; Sun, 16 Aug 2026 18:47:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B18256B08AA; Sun, 16 Aug 2026 18:47:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96B546B08A8; Sun, 16 Aug 2026 18:47:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 528BF6B08A7
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E812BA047D
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:41 +0000 (UTC)
X-FDA: 85108621122.08.8B631D3
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1BCE7120002
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="S o8MRp2";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=WqwC9yGZ;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rve110aQ3RGnUPR/SGf577VtfeusB/RC8s8suU08YA0=;
	b=Nd0iwmnWBEToYfgH+0N8mmYV4/iANzvDz9v8GtvnFrSAHf86TAAEllcnXJUvuQbnqDJ2yi
	MTPw5qL0A97euT1cLmWJCUiaIXPzcLkGZY9xDdZ2JkKKU3dlpmZMVQLB5G2CDMELlE36Fk
	PkHGezPLqVDLwDgB9DwslqzyShfUV2s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="S o8MRp2";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=WqwC9yGZ;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920460;
	b=xAaTJ35xcvA95vBa4bj4lWXP4hUKQdKfXTyc1UzZbgY7N41z8zD4abqq9ADfrx92XTziOt
	DT1oUiEvgcxYjCVy8OCtG0AvCNVW0Oew+Mh9Gza3jf7FAI0vfqyQp5iOUFJVcBoBbRsJyk
	bmP3jRc+teRhnXWnVr0rVNwUEUC4ykU=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id A0F0414000EE;
	Sun, 16 Aug 2026 18:47:39 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Sun, 16 Aug 2026 18:47:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920459; x=
	1787006859; bh=rve110aQ3RGnUPR/SGf577VtfeusB/RC8s8suU08YA0=; b=S
	o8MRp2F4cOuq2Egj9t90m7zBXPLSOh4s2sJaWpbNCEsDpxDH5niH9wmr309FDA78
	1OzaTFbiZFp1h8NrcnJqTBlMadRuMzbQ1kPvkYVQRAml8XfPbMkZ9nktmDOL8ME0
	wnn1cQXtTsTsT8knZLP04tQvy1fZdPgYCyP2eDgs/r35BTKg9//jXwYYZXP9waEl
	rfeI+G3yL7oHE5jvUCYmMNMprAESzri9dKTAaMBByxsyLc5cg5ruWQ1YPU3sHV7s
	0ET7jvgag123GHU2HHi72b2NbT4ae26E+ne335R05JPqgaZUy7EsR60SzBZtUgDY
	UriCvMdhkxPvjwXwFBmZw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920459; x=1787006859; bh=r
	ve110aQ3RGnUPR/SGf577VtfeusB/RC8s8suU08YA0=; b=WqwC9yGZLz5sX585z
	qfhZev1SIyDpPNU4cAMc3llRXuREEPAnm0z2vOkFa9aeG2QGBZ2yHpRV/ynjoxLY
	XDbJuKnzKQXNOEkTHGqOcRTzOau5jyeZj0M8UDQy0rPTIOYC3fT19PG2PmnZtKrh
	wxvFz4S45pqbmAnfcT5g6r3JOW8KVp+MgM7oe11MUl/Cn0LDYV7YLOLihBhlG6Gb
	OvUOi2yZEtHoI4VES/ClhjVVLgSt8b6SpFX7nSoEBzwLszdR3AfDkyh14SCcOwDy
	IQ3gXxc7IxtTISx4Wz9MNFFCRS4IJBPhewm13UZ4w8dGFtUGdMcL8zK36q/iXr+N
	LZAgQ==
X-ME-Sender: <xms:Cz6CankzVr3sYtFxxw5JbEvkoaGJerFl08IpnmhtyXsAxKeyHcTl7g>
    <xme:Cz6CagLW8TtWgw5HEN8R51eDcy0Jlgtm2gqtANuB4zbjUSYBO0z4QpHS0SJtGQtJW
    -gB0Gqt7KKP4FSdeirR3d7zV7UjzWVd5mHI8jcc8Vaxn20l97jIpZU>
X-ME-Received: <xmr:Cz6Capvi4y6aphOEHuHhFMwILzW6JLwMdt4VK3GroC6tPc07dvvEAW0T9S8>
X-ME-Proxy-Cause: dmFkZTFxktHaoHQCGyR7uz2gXQdTgUX0nZzUatWYXQdVxBJb4A/qMuEZ/RMKYvGIBz31Rt
    TR5Nu17EPBqNyeZSjkVnK7sHElwU57b8x3/cyZ9PHHSfAaSWNWLOdeLuZVBbf5zubb18Bw
    fy/mf5jpQtxpZDPvMPXwjw+an+TW+7k/Tw/n4sb2tNNa7d9nLnQnX6Rw+vp6wioFQOuuev
    fpJbCZJSwa4xWiqXHUsCfuVr3o0xcsLHyTasHEYEkAGMtBoAwl7gOHcd9Yu3HcCvuVHzqL
    dMVburb2rGaTCsZcGe3UWITClIJ34iPVxiKzwGBtfazzXdWK1ezlWroYFXdEl+xlvbcPRE
    EcGSAauGtulKcfHD8ZMEdZcshXjw82HKplkBk4CvuYSebHShQKOtVqcQB5KLfW6zdhaS3a
    mbuLEIL7G4MY9vEby2aIRAMWWkEF1kzHPkEQkq/lnTs1/5ZDVFuLhKaVNJcmrgM2fUTNkB
    shFf0eOpWUoU11ZJeeiE5nU9Jt3xDrIEhEMqYNU4bSEQoZ+QrLRVRj7ONEhBcvCVmgucac
    BfN63HDXEl38M4gvW2+m8SBIw1tIkubTmLQrx+CsHTLU0oP5oubte9XGIc9aAb78AQbkG0
    3X8/DFAOIVARw+t/zbAJiZ3xPnE62YxRdeKmqylaoL7xZz3mHhxjUn6SNXdA
X-ME-Proxy: <xmx:Cz6CasKgD-OYH1eJbK9EHsihSpW4BrAowNyg1Q1UIGoAK4m8oeu-3Q>
    <xmx:Cz6CasH_TialyD8YS469fdLZA66wGXEmNVUJFuU44R4fAFrpn21F5A>
    <xmx:Cz6CaoRpV30SfKca-CXlPKr7festGf4wrlSISop27KUJV8cN9F91Jw>
    <xmx:Cz6CauXZfAGfXxmVjJ7jKAAZH4xr3Hj7GpUrVODTf0emu3snS9iX_g>
    <xmx:Cz6Cap42ON-oq6Qt18pq-uQhyow7lf3dMWvu8G8MFZBMzxgsADilh6e7>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:39 -0400 (EDT)
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
Subject: [RFC PATCH 44/57] mm/khugepaged: hold the address space open across a scan
Date: Sun, 16 Aug 2026 23:45:56 +0100
Message-ID: <20260816224609.308019-45-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: u7hnq3hgzqx5nz6abgu4hsbhdwnmq7a8
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1BCE7120002
X-HE-Tag: 1786920459-999685
X-HE-Meta: U2FsdGVkX1/gfZxOcdVhGgup5CMSTD0Hhgq/loBaU8wwO+4wgXjbI9aGszj+MiHgGI5NKdyknyGrX0YTl7G7m/XEsQnEUlgj7zuaSwAEw09KDovnKgMn7c5/WNYT3SUA7uTjm1TizCkAR9+V7JdeHsBodwQk4DNBX+7quRPqSVtYkG+LPkVVZsSe1SY10Q6Du8ZbyuCJCwcgu2pa+FEQZEXp8sqR1eyv0AiwHDCcOYZ4LPkNqxclDX2Ugwu04fGc73S7k28r+xIOy01g5pv40ucq9rX2oZ+o58WRa1+Ku/Q2bgWgV/P8eMRxzrP0b4TzIZII9ZlpAJKHnlwTKtR+g8CpO70u0Q6qMVbx4eJWzMtMF+xXpROYCPmo9yFtMfprowhCKUmnHvlMf3sggjwy48cnvCcJly9/JMFp6URjj58Q//m8XBMD7DCBirXYywhmJ9NmllnagY1YsJTgr+nxUKXuYo2taZD4u0Zotd7Zwo67BaXv1oGNQ+TQIw8h4rT1MLOcJK0U4aAgXN6+7t0DPg+ryB5Y5HQxRiQ+O2sRHjjQ9SQbRWkLwCoWmlPy/7KALjHGnV9ijKkz09GP0h4Sv/tOpYQQyq86zB864r1M/pQqd+xWoxT8enlXXlKEkhZH75CSUyN6MFQklWswSvPLgNV5OsUS3eUzNueECaeoPTkFV0094krR1W1JseyNHhY53rlwKV69Hcc2OKF2SuQwKx7TgetU+wFjm+P9djR4TCJNFm0/O+s6ozC3IjSzEIE/DOzn65+NmRSayhh8BdD2XvvTcStcTKTAZ8J7GuVc8uhdJSwJxB40BZOtZPTISY0TT79OFXB2wHkVgmfaMVBpUlCPBouF4GtxHLIh/LXJ/wKyoK/Jk8cltGuyHeVmeJ3oDrVKkEPwjq+JIhWk+UMEbbUbHEVKEzv8QIEHE7YbQtj1LJx2Ec4uDR3UYOTgLI5rsrTgXRhq78HbwWhwlRn
 u5wb4qq4
 Qp2P+TvaCxLKLRuwk8HIuAoUTAZXJrLiJiwmyG2QQOOgVsnTbKff1Dql6eTOE5hfFr6ZNEvwQxLpyGxFFWjwviWLYEuLUy1OfbueA74zPP9XgdPgc82xq6dV1iNGSg7jpmvMoTgezk0kMkU8GBLM7Kr2ln8XvafO9KwdbcJogvne+IdHbj/ETOYnNMv0T1QmsUAZD21XLQs2Gy3izwPaBb2+PzM+eA1ZHk2Qgu2V5bFdFUwHmf9ZjR5aheCfT9KkbuSpgVeq769A8cyJpXLgl+8yUSSdxN5FDlVRSV5DH9Xw84ctCYziOHl1HCMozkkQEQKDueURV7yGHeatRImqvC3iMxx7rQnnRW+1ex5hNGNJJgpw13hzqzgW8oBtBB63X/dsB0aUWcznl7kspSqPiHvs/gbZqiVkSzN9vPCM6KSO6gCtowsTxlCClj4MGDrVIExC21xSPzLOTmFk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Preparation for taking a per-VMA read lock instead of mmap_lock.

What tells khugepaged an address space is going away is the barrier in
__khugepaged_exit(): it runs before exit_mmap() and takes mmap_lock for
writing, which waits for a scan holding it for reading.  A scan under a
per-VMA lock holds no mmap_lock, so nothing waits for it and exit_mmap()
frees the page tables it is walking.

Take a reference on mm_users for the pass instead.  __mmput() cannot start
while one is held, so neither can exit_mmap(), whatever lock the pass
uses.

Drop it with mmput_async(), so the last reference does not tear an address
space down inside khugepaged.  Drop it before the exiting mm is judged,
too: that judgement needs the true count to release the slot.

The reference is also what the exiting-mm checks were reading, so an
address space whose owner has gone now shows as one reference rather than
none.  The three checks inside the pass ask collapse_test_exit_mmref()
instead; the slot-release judgement keeps the old test, running after the
reference is dropped.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.h   | 19 +++++++++++++++++--
 mm/khugepaged.c | 31 +++++++++++++++++++++++++++----
 2 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/mm/collapse.h b/mm/collapse.h
index 9e2cec1f250b..74e513c5c76c 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -170,6 +170,11 @@ struct collapse_control {
 	pte_t *saved_ptes;
 };
 
+static inline int collapse_disabled(struct mm_struct *mm)
+{
+	return mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
+}
+
 static inline int collapse_test_exit(struct mm_struct *mm)
 {
 	return atomic_read(&mm->mm_users) == 0;
@@ -177,8 +182,18 @@ static inline int collapse_test_exit(struct mm_struct *mm)
 
 static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
 {
-	return collapse_test_exit(mm) ||
-		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
+	return collapse_test_exit(mm) || collapse_disabled(mm);
+}
+
+/* The owner has gone: the caller's own reference is the only one left */
+static inline int collapse_test_exit_mmref(struct mm_struct *mm)
+{
+	return atomic_read(&mm->mm_users) == 1;
+}
+
+static inline int collapse_test_exit_or_disable_mmref(struct mm_struct *mm)
+{
+	return collapse_test_exit_mmref(mm) || collapse_disabled(mm);
 }
 
 /*
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index cc5ff429d811..f3ea1846990e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -531,16 +531,31 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 	spin_unlock(&khugepaged_mm_lock);
 
 	mm = slot->mm;
+	vma = NULL;
+
+	/*
+	 * A reference on mm_users for as long as the pass works on this address
+	 * space.  __mmput() cannot start while one is held, so neither can
+	 * exit_mmap(), and the VMAs and page tables stay where they are.
+	 *
+	 * Once per pass, not once per table: the reference is what makes the
+	 * address space safe to work on, and a pass is how long that is wanted
+	 * for.  Nothing else in mm takes it per unit of work -- DAMON takes one
+	 * per target and walks every region under it, swapoff one per mm across
+	 * the whole address space, userfaultfd one per call.
+	 */
+	if (!mmget_not_zero(mm))
+		goto breakouterloop_no_mmput;
+
 	/*
 	 * Don't wait for semaphore (to avoid long wait times).  Just move to
 	 * the next mm on the list.
 	 */
-	vma = NULL;
 	if (unlikely(!mmap_read_trylock(mm)))
 		goto breakouterloop_mmap_lock;
 
 	cc->progress++;
-	if (unlikely(collapse_test_exit_or_disable(mm)))
+	if (unlikely(collapse_test_exit_or_disable_mmref(mm)))
 		goto breakouterloop;
 
 	vma_iter_init(&vmi, mm, khugepaged_scan.address);
@@ -549,7 +564,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 		unsigned long orders;
 
 		cond_resched();
-		if (unlikely(collapse_test_exit_or_disable(mm))) {
+		if (unlikely(collapse_test_exit_or_disable_mmref(mm))) {
 			cc->progress++;
 			break;
 		}
@@ -595,7 +610,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			range_end = min(hend, pmd_addr + HPAGE_PMD_SIZE);
 
 			cond_resched();
-			if (unlikely(collapse_test_exit_or_disable(mm)) ||
+			if (unlikely(collapse_test_exit_or_disable_mmref(mm)) ||
 			    cc->progress >= progress_max)
 				goto breakouterloop;
 
@@ -622,6 +637,14 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 breakouterloop:
 	mmap_read_unlock(mm); /* exit_mmap will destroy ptes after this */
 breakouterloop_mmap_lock:
+	/*
+	 * Not mmput(): the last reference would run exit_mmap() here, and
+	 * khugepaged is not the thread that should tear an address space down.
+	 * Dropped before the exiting mm is judged below, so that judgement still
+	 * sees the true count.
+	 */
+	mmput_async(mm);
+breakouterloop_no_mmput:
 
 	spin_lock(&khugepaged_mm_lock);
 	VM_BUG_ON(khugepaged_scan.mm_slot != slot);
-- 
2.54.0


