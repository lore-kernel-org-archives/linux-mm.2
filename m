Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D67F0CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 10:07:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30B726B00A0; Mon, 28 Sep 2026 06:06:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E3CF6B00A1; Mon, 28 Sep 2026 06:06:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1845C6B00A2; Mon, 28 Sep 2026 06:06:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CEFB66B00A0
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:06:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 31FCD12017B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:06:54 +0000 (UTC)
X-FDA: 85262742348.16.7DDDC87
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2FA674000E
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:06:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="f oOmcOW";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=LtpAFbak;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790590012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lhJy89hwXDF93raSeShDbn4xvxxMtdU4+EoHHaB7PjA=;
	b=CUUmvPDsEamTNbfVvwUZ3Um4cISu7fWPB4T1dgVA7PcKo5j+Ka8EBLzZXLctQHJc13CObG
	R3b2AfboPBn8cmQGM0OkD+oBnndR0/v9yyZCUcbP0GzkOBsFD16i7EqD697BSQhuGxEpTG
	TIsayUwtPPM3ofNcmSoU7trHRPfsRRU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="f oOmcOW";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=LtpAFbak;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790590012;
	b=7AlCYn4EtnPE8N0fXjWPUM3m6V/DNIyN1uz14o6AaHUuM/Fxr6riEogmPH80sqqWvH+5ct
	Bg9gTxqRSY8w04CkYj9vZHfDs9k36xhZP6QVFQGdGCcMQivcyyGbUHXh1qixQ0iojre2WF
	XA28Pzi00V4N5RBOUYQJeBsjf6mzcHA=
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id BCE5214000A9;
	Mon, 28 Sep 2026 06:06:51 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Mon, 28 Sep 2026 06:06:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1790590011; x=
	1790676411; bh=lhJy89hwXDF93raSeShDbn4xvxxMtdU4+EoHHaB7PjA=; b=f
	oOmcOWn5NbYU5RLxoXt+ipk0481SThlrUUHlOz3T4swnCdqkISotGxE4pasgGxWb
	rKAvi3lTffz5NQ/1fG7MTJpD2Px9+uFNnTLyiTDOq68ZAJcf6D0W+IiT4+GosPMI
	fr9JPrYo8O0IUGEDfHVf44Siyk6Teju4DcXv5ZOu2m9XpRzXlSR4xQVp8zxmF4F5
	cDwC1iztkNgxKpAcUVYvuZ/LXpg92j+Wzxtl9C2qrV4Lqfa7ZlcVz0ANtDbwq05I
	9zpuF0tv1x1XXa0iUxaRbwC6L9rzmfvgVNyFRnUFFjNJozLN9fNXAAuHZHAd2Q2z
	vbAS2tRkskKXxIAfGwOLA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790590011; x=1790676411; bh=l
	hJy89hwXDF93raSeShDbn4xvxxMtdU4+EoHHaB7PjA=; b=LtpAFbakwlo5PhgH0
	1/EgFrByutZi2fyuFTT8Xr89qLEWU/XrquTFjTN8ixeZXQRPpg4ZayCYhQWipd0A
	RyYuZck3Cq+rfrVaxQaOa76I0/8w+MhCBhFcKSaEHnZbAgojTYYDtG3LixZm/HG8
	QXz9FJzPr+q/96NP2QFmfAPsHGuzgvOaiQJbaFOTeJ4+xs6ag8tKVITeh4m4+8dV
	4s0fYL/jOz+VmHmoQBOmuELMRKG1pgZQJMHq65a29AdVfZhCPb8l0OoVmQ3ljNvR
	zx2oyD+ycga9LPK80UeJ4vSofToTgyKJCupphxmh/bggl8eqgTYVDyrAVsK6ZSX6
	dA3jQ==
X-ME-Sender: <xms:Ozy6amUD_aPXfhtffVQqHS6Sj3yGv_x7NjmGPeHJRuS2Yw52QEla5g>
    <xme:Ozy6aujuJyRI4VefnQsnjVTSuCCrT0tDGR2ri5iMIGMhOj9Z1x4AQXDp3OL78-jnR
    thgz7anDFZTCLbYTf6b7nGliefjdIVsuPyKWyROrWHiU6-V26i2Eh9f>
X-ME-Received: <xmr:Ozy6agjFZnYMuooh-jtW4VWXpEq3-5FFVEYmmmQNWBjDTikOLx3zt5_2dNc>
X-ME-Proxy-Cause: dmFkZTF8+FzWl2kPFFw+2+MUnNndpG3Es29zlM3W8MqBD0QW9993JqL27RjsdWHL5iQTuv
    8LHkef+10EFcRNyu6aMfBJblGtUMhigK1wvWUg5pa/T2F4HZOycwBRl+2S+z7tqw2cJfHU
    gdsF/P6BOMqpKS9LZRm0d8oBtyKEEqCXwj8zji6pXjSixGW9yMDmevXCSXRhMug+RBOuj6
    H/TPGEbj0UBxBpkklI8Q2dk1KPN1FfxQ05T6kAzB+fcPQyWzSSafNh6004OlOqdREfhbRG
    BHI+j7BDMASDclZuapGmxVrXolh8JlQnm8Hn+THchpsYHB/1yAmWKg/yew9Ltzw86nEqLc
    v1WDkPJODu7rPxOtAcz01can+1S2zdzohq0oAt/2ZvJm5gFf18BF/yQRlMsAlFAU7rs3fJ
    iEnizx39te6Z12bfa7wUZR1rLocYgmb0KXXCajtt9qzD+w0AbaZkvRih4CPGuDFIL09HFT
    uTNwQ+P7Eca7n+9TPc217RB9U9tzqzNPqRY0Yk4ac3wZRQRx5MHKZB+kpxCwT0b29e2PwU
    8mNehtafqVDSjepjg52eQYNrsHafnRgyWx0zjbChul7BO+nAYWdR0HHf2dzJsbXkCFnZtc
    SgRF84zHWb7J7sDNUBK9cBdWPs8a0jjazfEpuaRqtSWw7mwaqtkE5DMdz2uw
X-ME-Proxy: <xmx:Ozy6ajvtzHQSsP0ULHIxEDShyf_yZvu14MpPpIaDup-Ovc_2ZIg2CQ>
    <xmx:Ozy6auu2h8HPA8WunUehbdGZkCRdVI8J8MP9FYtAOryiJ8Vz6EUtgA>
    <xmx:Ozy6asOf7FwF8i7Add7SGV5-K4zCY23HztgigXOGjxxXegZAX2v_0w>
    <xmx:Ozy6aodXrNSny-0P3sZNMjZO2y1paERjWcJRMexw0a2YzSzBDfGtHw>
    <xmx:Ozy6ak2FA1rCl0LwIrV6Cla6741-E6QL7L0jKHj0Dh9Nzxo0k7RHxyQR>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 06:06:50 -0400 (EDT)
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
Subject: [PATCH v4 09/13] mm/collapse: separate scanning a PTE table from collapsing it
Date: Mon, 28 Sep 2026 11:06:23 +0100
Message-ID: <20260928100630.21870-10-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260928100630.21870-1-kirill@shutemov.name>
References: <20260928100630.21870-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4r9qd8qjsyorbzqhbqha1fri1r5nik78
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2FA674000E
X-HE-Tag: 1790590012-242673
X-HE-Meta: U2FsdGVkX19d46S8XcLa2lIIWvw215hFUCDHpc/oI1R8VKiMShBS9fPMx6E2NLX8d8NK1keSfr6cQwQETpPLpQZB0Izw6y+ufGLkv/HuWoof7LnmwdU0AKcKvJ8P0vgg5yBFb2qKKwbtrQkyr4LWuhyqH+4sEwN8u4zjxETgy3M9x05+b2+fHs2jeD9r9mLsYQJr2dgfR4uFQYOonJLrYUGIJ8FCfg70rNRRTY/fBCJ36ZkyHbpF3Yy8CGIcaS1un6N/Ss2xoZluRulsGHjzhV4cwgvPqJ8EcgqhTQruYwQPayFttGGb4QsAGoj3OtqnDXPpiDftpZXSrMnQh6EwjlNEFdylxh2xdoNek73L9Gm3gRSCtjBvMrEPPQrmdvW/wjNWuvTSfvQsffXyEY7U9kKRhQAMQKxT+9BSZ1lQfZn0NKghJG3b3XDA9eNComrUJsV+bofxMjSwRRu18VdDlnlawcIP8KOWQ18jiYwsPV/HZmfDUgh24ifh0vPhbvp2qP697psRt8tUNpunCXyOaFqS8F2pahBNrLnkw6tNY8ItuHouGkEUY58NyoQMu/mKeXkbXGrnyvGv7K5P+HnbKJI/rhWyIpiKPGGK+kwAEl+BhqYUPhHHCwodHNFYFe6LNvvkPQeQVPSoHYyX5WD/PJL9ziUkqGGpO5g/oXx1euWjXD/arE2+KAKkViLXCtjhjcJUZApmXuabAKHoXbhzVUtZrI2d9i30pi3pyApakynRuCge0LA/hN4LztsSaHt9Q/yWiJnlUQ+1zqijXAwYL7XXBcMz9Z9WBIcRMP8I/iTt3/ez9iyeo6oYpk1ztXIs5iewfJ8l5PgPlu5A7sgh9RXf74cmDM8vVTVP4LCwOIXDDzz7KczHIO06z7rZm2P37PqKBczYN6AapcK/0QvhXumOCUwhLS188VdmuSfa9QuYU4efkpETSjDrxqtl2wWPX5isYRf6MNWKzblerzp
 vdany+cm
 fcEdKivocko1f2fVlkQL+zfmMqiOstkYbCWSEhI76/P+yi8W62RPoB7AbA2foDY6aS9wm/6tT/Jcch3Bgl6oRQf1T1kL5kGEoKb8UG1BYgl8rnrrw9tAaQG3bSbKsiTfJCSnlnZZ3iRWtkGQpKSzuMPGt8IzMRB54WCCGdj4DrrINCCclA11T/YitweIFfILcXL9n4Qvupc9urcvxQKw0HU5yHFNhc+fa383ERc5ijxsWbbrpym3O032S74h5Sxm9ZwLPvHiDww4nSVAoWV0ezKTI4ORgQuw8/FyoL+Bv0QlD1CARZA7aT6Amvaz9ucfQk7qQSgabKPsQrRCyrG/PGq/NmA2Fn+0Ve6fqPItL0ZvN4GRoI77iE2OutJWVWt9svk8aZgIN3+OQlJmRHUFkkWJa+5kd1qgHk30lSrB9qy/12qncqqkbJa3E9ZD5SNIl24piHFyKwgmjoZs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

A collapse is two jobs.  One reads a PTE table under mmap_lock and decides
whether the range is worth collapsing.  The other allocates, isolates,
copies and flushes, and wants the lock given up first.

collapse_single_pmd() did both, so the boundary between them was somewhere
in the middle of a function.

Give each half its own function:

  - collapse_scan_pmd() scans one table.  The anonymous scan that used to
    carry that name keeps its body as collapse_scan_anon_pmd(), and
    collapse_scan_pmd() is now the entry that picks the anonymous or the
    file side.

  - collapse_run_pmd() does the collapse the scan asked for, and is
    handed what the scan returned.  SCAN_SUCCEED means there is
    something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE means the page
    cache already holds the PMD folio and only the PTE table is left to
    retract.  Both are work for the run; anything else is why there is
    nothing to do.

collapse_single_pmd() is now the two of them with the mmap_lock drop in
between, so its callers see what they saw before.  collapse_control_init()
sets a control up before its first scan.

What the scan found and the run needs travels in collapse_control.  For
an anonymous table that is the orders and the referenced and swapped-out
counts, which mthp_collapse() and collapse_huge_page() now read from
there instead of taking as arguments.  For a file it is the file itself
and the offset in it: a file collapse works on the page cache and never
sees a VMA, so the scan takes the reference while it still has one and
the run gives it back.

The file scan moves under mmap_lock with the anonymous one, where before
the lock was given up first.  The lock is now held over the page cache
walk, an RCU walk over one table's worth of slots with no PTL, and taken
fewer times.  collapse_scan_mm_slot() ends its walk whenever the lock was
dropped, so a refused file table used to cost khugepaged an unlock, a
trip back through khugepaged_do_scan(), a relock and a VMA lookup.  Now
only a table that goes on to be collapsed does.

Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.h   |  14 +++++
 mm/khugepaged.c | 141 ++++++++++++++++++++++++++++++++----------------
 2 files changed, 108 insertions(+), 47 deletions(-)

diff --git a/mm/collapse.h b/mm/collapse.h
index dcd117071955..ca7b367c89cb 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -98,6 +98,20 @@ struct collapse_control {
 
 	/* Each bit marks a PTE the scan accepted as a collapse source */
 	DECLARE_BITMAP(eligible_ptes, MAX_PTRS_PER_PTE);
+
+	/*
+	 * What a scan found and the run after it needs.  Live only between the
+	 * two, and read by nobody else.
+	 *
+	 * The file side takes a reference while it still has the VMA, since a
+	 * file collapse works on the page cache and never sees one; the run is
+	 * what gives it back.
+	 */
+	unsigned long scan_orders;
+	int scan_referenced;
+	int scan_unmapped;
+	struct file *scan_file;
+	pgoff_t scan_pgoff;
 };
 
 #endif	/* __MM_COLLAPSE_H */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 89a4c3f5a91c..2b044e63d8c9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1235,8 +1235,8 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
  * while allocating a THP, as that could trigger direct reclaim/compaction.
  * Note that the VMA must be rechecked after grabbing the mmap_lock again.
  */
-static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
-		int referenced, int unmapped, struct collapse_control *cc,
+static enum scan_result collapse_huge_page(struct mm_struct *mm,
+		unsigned long start_addr, struct collapse_control *cc,
 		unsigned int order)
 {
 	const unsigned long pmd_addr = start_addr & HPAGE_PMD_MASK;
@@ -1275,14 +1275,14 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 		goto out_nolock;
 	}
 
-	if (unmapped) {
+	if (cc->scan_unmapped) {
 		/*
 		 * __collapse_huge_page_swapin() will return with mmap_lock
 		 * released when it fails. So we jump out_nolock directly in
 		 * that case.  Continuing to collapse causes inconsistency.
 		 */
 		result = __collapse_huge_page_swapin(mm, vma, start_addr, pmd,
-						     referenced, order);
+						     cc->scan_referenced, order);
 		if (result != SCAN_SUCCEED)
 			goto out_nolock;
 	}
@@ -1446,9 +1446,8 @@ static unsigned int max_order_from_offset(unsigned int offset)
  * If a collapse is permitted, we attempt to collapse the PTE range into a
  * mTHP.
  */
-static enum scan_result mthp_collapse(struct mm_struct *mm,
-		unsigned long address, int referenced, int unmapped,
-		struct collapse_control *cc, unsigned long enabled_orders)
+static enum scan_result mthp_collapse(struct mm_struct *mm, unsigned long address,
+		struct collapse_control *cc)
 {
 	unsigned int nr_eligible_ptes, nr_ptes, max_ptes_none;
 	enum scan_result last_result = SCAN_FAIL;
@@ -1461,7 +1460,7 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 	while (offset < HPAGE_PMD_NR) {
 		nr_ptes = 1UL << order;
 
-		if (!test_bit(order, &enabled_orders))
+		if (!test_bit(order, &cc->scan_orders))
 			goto next_order;
 
 		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
@@ -1469,19 +1468,18 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 						      offset + nr_ptes);
 
 		/*
-		 * Swap PTEs accepted during the scan are counted in @unmapped,
-		 * not in cc->eligible_ptes. Account them for the PMD-order
-		 * candidate.
+		 * Swap PTEs accepted during the scan are counted in
+		 * cc->scan_unmapped, not in cc->eligible_ptes. Account them for
+		 * the PMD-order candidate.
 		 */
 		if (is_pmd_order(order))
-			nr_eligible_ptes += unmapped;
+			nr_eligible_ptes += cc->scan_unmapped;
 
 		if (nr_eligible_ptes >= nr_ptes - max_ptes_none) {
 			enum scan_result ret;
 
 			collapse_address = address + offset * PAGE_SIZE;
-			ret = collapse_huge_page(mm, collapse_address, referenced,
-						 unmapped, cc, order);
+			ret = collapse_huge_page(mm, collapse_address, cc, order);
 
 			switch (ret) {
 			/* Cases where we continue to next collapse candidate */
@@ -1523,7 +1521,7 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 		 * we must always move to the next offset.
 		 */
 		if (order > COLLAPSE_MIN_MTHP_ORDER &&
-		    (enabled_orders & GENMASK(order - 1, 0))) {
+		    (cc->scan_orders & GENMASK(order - 1, 0))) {
 			order--;
 			continue;
 		}
@@ -1548,14 +1546,14 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 	return last_result;
 }
 
-static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
-		struct vm_area_struct *vma, unsigned long start_addr,
-		bool *lock_dropped, struct collapse_control *cc)
+static enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
+		unsigned long start_addr, struct collapse_control *cc)
 {
 	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
 	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
 	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
 	enum tva_type tva_flags = cc->policy.tva_type;
+	struct mm_struct *mm = vma->vm_mm;
 	pmd_t *pmd;
 	pte_t *pte, *_pte, pteval;
 	int i;
@@ -1735,12 +1733,9 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
-		/* collapse_huge_page() expects the lock to be dropped before calling */
-		mmap_read_unlock(mm);
-		result = mthp_collapse(mm, start_addr, referenced,
-				       unmapped, cc, enabled_orders);
-		/* mmap_lock was released above, set lock_dropped */
-		*lock_dropped = true;
+		cc->scan_orders = enabled_orders;
+		cc->scan_referenced = referenced;
+		cc->scan_unmapped = unmapped;
 	}
 out:
 	trace_mm_khugepaged_scan_pmd(mm, failed_pfn, referenced,
@@ -2742,41 +2737,67 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 		count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 	}
 
-	trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present, swap, result);
+	trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present, swap,
+				      result);
 	return result;
 }
 
-/*
- * Try to collapse a single PMD starting at a PMD aligned addr, and return
- * the results.
- */
-static enum scan_result collapse_single_pmd(unsigned long addr,
-		struct vm_area_struct *vma, bool *lock_dropped,
-		struct collapse_control *cc)
+static void collapse_control_init(struct collapse_control *cc)
+{
+	cc->progress = 0;
+	cc->scan_file = NULL;
+}
+
+static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
+		unsigned long addr, struct collapse_control *cc)
 {
-	struct mm_struct *mm = vma->vm_mm;
-	bool triggered_wb = false;
 	enum scan_result result;
-	struct file *file;
 	pgoff_t pgoff;
 
-	mmap_assert_locked(mm);
+	mmap_assert_locked(vma->vm_mm);
+	/* Whatever the last scan found has to have been run by now */
+	if (WARN_ON_ONCE(cc->scan_file)) {
+		fput(cc->scan_file);
+		cc->scan_file = NULL;
+	}
 
 	if (vma_is_anonymous(vma))
-		return collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
+		return collapse_scan_anon_pmd(vma, addr, cc);
 
-	file = get_file(vma->vm_file);
 	pgoff = linear_page_index(vma, addr);
-
-	mmap_read_unlock(mm);
-	*lock_dropped = true;
-
+	result = collapse_scan_file(vma->vm_mm, addr, vma->vm_file, pgoff, cc);
 	/*
 	 * SCAN_PTE_MAPPED_HUGEPAGE is work too: the page cache already holds
-	 * the PMD folio, and only the PTE table is left to retract.
+	 * the PMD folio, and retracting the PTE table is the run's job.
 	 */
-	result = collapse_scan_file(mm, addr, file, pgoff, cc);
-	if (result != SCAN_SUCCEED)
+	if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
+		return result;
+
+	/*
+	 * A file collapse works on the page cache and never sees a VMA, so take
+	 * what it needs from this one while it is still here.
+	 */
+	cc->scan_file = get_file(vma->vm_file);
+	cc->scan_pgoff = pgoff;
+	return result;
+}
+
+static enum scan_result collapse_run_pmd(struct mm_struct *mm,
+		unsigned long addr, enum scan_result result,
+		struct collapse_control *cc)
+{
+	struct file *file = cc->scan_file;
+	bool triggered_wb = false;
+	pgoff_t pgoff;
+
+	if (!file)
+		return mthp_collapse(mm, addr, cc);
+
+	cc->scan_file = NULL;
+	pgoff = cc->scan_pgoff;
+
+	/* The scan found the PMD folio in place: nothing to collapse */
+	if (result == SCAN_PTE_MAPPED_HUGEPAGE)
 		goto put;
 retry:
 	result = collapse_file(mm, addr, file, pgoff, cc);
@@ -2794,6 +2815,10 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 put:
 	fput(file);
 
+	/*
+	 * A PMD folio is in the page cache, whether the collapse just put it
+	 * there or found it: retract the PTE table, and map the PMD if asked.
+	 */
 	if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
 		mmap_read_lock(mm);
 		if (collapse_test_exit_or_disable(mm))
@@ -2808,6 +2833,28 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 	return result;
 }
 
+/*
+ * Try to collapse a single PMD starting at a PMD aligned addr, and return
+ * the results.
+ */
+static enum scan_result collapse_single_pmd(unsigned long addr,
+		struct vm_area_struct *vma, bool *lock_dropped,
+		struct collapse_control *cc)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	enum scan_result result;
+
+	result = collapse_scan_pmd(vma, addr, cc);
+	if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
+		return result;
+
+	/* The collapse takes its own locks, so give this up */
+	mmap_read_unlock(mm);
+	*lock_dropped = true;
+
+	return collapse_run_pmd(mm, addr, result, cc);
+}
+
 static void collapse_scan_mm_slot(unsigned int progress_max,
 		enum scan_result *result, struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
@@ -2950,9 +2997,9 @@ static void khugepaged_do_scan(struct collapse_control *cc)
 
 	lru_add_drain_all();
 
+	collapse_control_init(cc);
 	collapse_policy_khugepaged(&cc->policy);
 
-	cc->progress = 0;
 	while (true) {
 		cond_resched();
 
@@ -3179,8 +3226,8 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	cc = kmalloc_obj(*cc);
 	if (!cc)
 		return -ENOMEM;
+	collapse_control_init(cc);
 	collapse_policy_madvise(&cc->policy);
-	cc->progress = 0;
 
 	lru_add_drain_all();
 
-- 
2.54.0


