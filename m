Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FF19C3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 18:30:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A87646B00A1; Wed, 14 Oct 2026 14:30:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A112C6B00A2; Wed, 14 Oct 2026 14:30:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 906266B00A3; Wed, 14 Oct 2026 14:30:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 665876B00A1
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:30:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E824C160296
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:30:40 +0000 (UTC)
X-FDA: 85322072640.20.AA1FA9D
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1FDE01C0007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:30:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=O0jNtjsV;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792002639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oviJZuz7wJ3+WoQ9W/TGlT7rNjNMCITRK6EOVD5+7G0=;
	b=535k9wQFgOHu8M5UzuLSdSYLHFKW6nhNYuEiO4VSZQAUdnXhid2h7DrbyDEbl8uWkK4L3e
	ujKRqvv1cv6iyEhGcstbcfQx1mWVTGCe526j+x4YzyDiHc+jhndqADhQvexOtrQiw+iCjl
	Tp5Frk+ekzSp3pfxmkoqRI/h9ppB6lA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=O0jNtjsV;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792002639;
	b=AndrgFZI/8IhcEQ85ZEvlgq3/HE5CS8+OyUGl2nRYdkQ6LRRyPbuYfP/cjZ3I8pFM7vX+z
	0U25TOiVT3EDXC7dwKXSkVknZJ71pJF0XLkA/ryZWSL9BJs0htkwatyavkpTjkf4cvCS8r
	xZxkpnpCdWyf3eAku7fjlWdw6hD/vPM=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-93e64d52949so421671485a.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792002638; x=1792607438; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oviJZuz7wJ3+WoQ9W/TGlT7rNjNMCITRK6EOVD5+7G0=;
        b=O0jNtjsVNc2EJpqAUGpnOxFalO2eVv94HDFLIEJB1PSY3LWjjY5fJmy9nmmGRZmGPW
         3Cs6jSe4eBbdjdM+tooYwQRQnelw1AB3ky0Aubj6SZw93WBL+bL1KqTTAACKKHxB+1Pa
         wyC3NwOmxdbYkMlOU1x+sXWFlXjqnzRGXGv9w39m0cgVGxSDd/xLsa6dEyY1luNJJMFs
         4h2wsS3CoKKsdCJRuiAH22XfUFCLkHxxsoqq8zbXh/BSq/FwA5yh2JfR1vwmzrGuytQj
         /6OsIq01lW4oFtVi41gffsBO+AeajNsHd/inInlpHAcqq1zLZ9FiziVCpZboDezM5PzL
         fAYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792002638; x=1792607438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oviJZuz7wJ3+WoQ9W/TGlT7rNjNMCITRK6EOVD5+7G0=;
        b=LK2oOUujfWuoJOoi5ZKk51sxqlxQxsNhJip+ViUmDzBC5jfJw5YfDQ3EF+89NgDtos
         8EvmzkSLwrbWeW7Pu5Pr/ZCGMF7Mu/R1OuvdyYe7fB2/VipamUlpjjfIXHcyuUSgOz8I
         ZO0fI9Cso+3Lwj1oHF/sPrX1cnxId9c0DC7akDwTkb/UO9WscVlHeR9P1mCx+7PgchW3
         3deqNjPDaZZbyqzzBOLbRUlHJqFj787ef9TfF/j+Fj1BzOnZ2e2ZffaYnNip8E1uLSVy
         y60eidF/DOxm26mXw7hPRf5plchUkw/ko9NcI3UstGP6rt9pZRCWiuIMDBVZlIGiOelG
         SnNA==
X-Gm-Message-State: AFq9FYKnzi3vwkorf2ViXRsScUMbuwAPtu+cijJfdtMF+YHzDsDfG7mL
	3+WC2I55dQX5et2toQbavQzIz8Kz65SnK6JmwPl4Z4FcCNYmy/8VFDaTPveIjSPW8svm47ZNlpz
	a9k5K7SI=
X-Gm-Gg: AYBFou3Fi5CA3s72m7Ih2T26ANVPRHABgeA8I4TZtk6iwIUl0j0VNXMwH+v0cP/Bp9g
	WnWqZN9Y3taLbbQViopRb4kDFdQ/bwiV6wPPfDqlBi2BOXYm/SyXTxk2ZtRMe/oEPgibgZhgszw
	k5Gr3XabO508tRz5lwlieBS1w29kjlso1+tppjMWONOeDzMvLWDjGEXJXeJzsRgV21SGh11Ea0F
	bRgm/FmwRh8+69NFdftMNGOYgJqv2Lm8fQZXF1nhOVJ9FcFvqquhPco1X7pXkPRrtYzWGqIUqzY
	qhMCuTUbHd6VJeYL9HO1JVG0kkVTJNvvPJP3pAhrjDwl/ZwQw1kpKqiZnzY9AHJOdYzycLRuucT
	iBywIGrB9kZYhef8DfZnbqouBrXEqJlTQQdQvT2v+U7A+OG0SITpM3rZZN7NKOWMTDs1OVMywT6
	XcncBcxFxcfRG4qZ5f0TG04Tpt2pgvh89fEzlShHkre0noz6bczW3rnnDl2JX4jV7dGN6/sz4Og
	T46TQSb2aLQs7FEQ4DT22nQ/tudNQVN9QjzmxeHFqo2KlX+b+6a8FPiWTOO
X-Received: by 2002:a05:620a:7106:b0:93e:c12c:f11b with SMTP id af79cd13be357-93ec12d0658mr2477753285a.71.1792002638192;
        Wed, 14 Oct 2026 11:30:38 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef508811esm556593085a.36.2026.10.14.11.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 11:30:37 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com
Subject: [PATCH v2 06/10] mm/madvise: separate huge PMDs from the PTE walk
Date: Wed, 14 Oct 2026 14:30:20 -0400
Message-ID: <20261014183024.2075709-7-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014183024.2075709-1-gourry@gourry.net>
References: <20261014183024.2075709-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xsrrw1f6z6659yjtxmy9yhkjectmcsq3
X-Rspam-User: 
X-Rspamd-Queue-Id: 1FDE01C0007
X-Rspamd-Server: rspam08
X-HE-Tag: 1792002638-300756
X-HE-Meta: U2FsdGVkX1+xN+LgBxOYKY+nVNDk8oXDppbQRHLbr7OeWhxZeS22eF961zO4buJhh1b6AZE/qd9Ubz8AmJ7wkjcczZ3sTSJH213oi1BnuVuSn+/Mglm4Lb3bIC4aPbhIzd9dfuDd+fKGymGXNp0juJfs90Pcxh72X+i2Tx5LlxK9PSR/TdLofCux0xrk5VTB6lUwSvEk17F3/osEPd2ytVrlgagQrgT26ZeJ7qMWr8wsbd52gbM3B/4hB7Pw6+PGiHgyEHpY1WYaQIh3LzgXE/P15+PbzX+QmqF3z5LC6u89sphM3Oe9ZX9nS5+j1bOX3u5Sv9Cr+0rC9AeKDkL1R2m0rM932SpxBkegMiqWckUjidTmIueE5nPOeg5v+6Tb+GlCo+vf7jjpVJMgfDBtd0gJVHSmZ0oDTZicfkmyfgEp3usFMXGI2QW2+4VNXVvB+VetTr0Q3YzEqrBPuRbqXBnstkbYn6K4ONWJcEij+Nqz06l6G4mySCh2kDDy/vhu0DGw6tDbLZiRXeNzUKh7YXP2F8nWYbSMl/RE6uxHOu+vs7mcQuA6TklBBplkeEcqwDrJVKtdwhl3bj00H0rlpBwmAPJwC6ev338BgIQ9cpxGvbJBOfckq1NpTiEgNwsb2P6CIJz6zh+ZNgL6Itq/p++q8FxZWoiyKyiN50PwXYzWZdn5h7XonvIv3g3rqFAV3cKvKvG5kZmIQjJvMmpwbAcT2ZXywhf3qzq87pIaUQAVq1oo1bkEmU+JG0AIDErqSa/6A8yJhpiLrbmKQV5v2WfKJGcobuX5LiyjlYqFa1+9DNe0TobFbplns1Zqkmqn225DpKd+xy3ud/gDWwTwSyELApCtoccrcUyc3qfPFFHWQoj3XoIBC6mlQtxFKt5RUU1ER7QeoIjq1BzrRVYT3v/bOVyj5UHHQlibia/WBtatDczOFPhaGbTgi6JlFh5drHSf87Je47o1KUq4QzZ
 pAhlsA7y
 xbNhMpDnjP4QhV8SbI76FmfoSTdnpevFDDR/NNTmee8j1Ai3FxOChravs+99PXsr2OMkDpbD0QEWwwhXI2s71ZoW44Dt0xWS/MUOdhiCWazlu8XLX8IecY/4jsv/CuxHgYcFr+kybhN/XGr1s5qAqyBGdDF5jPFdqu+qBCHsgyp23iGMcL927c87p8x3xNRHqxDb/AoyRzy/QScInuX8cegvV9pol5ARn72yAM2/HEC5vkS9+FpwGgMdGCj4i0AFA72Dru+iGxlNamLf+/KBMhn6QXWWZ3fLnSOUHAAqU12PM2TQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

madvise_lru_pmd_entry() still handles a huge PMD inline, and jumps
into its PTE walk with a goto when the huge-PMD folio was split.

The PMD lock, the split and the reclaim of the advised folio all
share a function with the PTE-table loop.

Move the huge-PMD path into madvise_lru_huge_pmd(), which takes the
PMD lock, advises or splits the folio and reclaims, and returns false
only when the caller must walk the new PTEs.

It uses the end address passed by walk_pmd_range(), which is already
clamped to the PMD boundary, instead of recomputing it.

No functional change intended.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/madvise.c | 97 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 58 insertions(+), 39 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index f847dddada8a..a9e5a3e2fab4 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -436,6 +436,62 @@ static struct folio *madvise_lru_huge_pmd_folio(struct vm_area_struct *vma,
 		return NULL;
 	return folio;
 }
+
+/*
+ * Return false only when the folio was split and the caller must walk the
+ * new PTEs.
+ */
+static bool madvise_lru_huge_pmd(pmd_t *pmd, unsigned long addr,
+		unsigned long next, struct mm_walk *walk,
+		bool pageout_anon_only)
+{
+	const struct madvise_walk_private *private = walk->private;
+	const bool spans_pmd = next - addr == HPAGE_PMD_SIZE;
+	struct mmu_gather *tlb = private->tlb;
+	struct vm_area_struct *vma = walk->vma;
+	bool pageout = private->pageout;
+	LIST_HEAD(folio_list);
+	struct folio *folio;
+	spinlock_t *ptl;
+	pmd_t orig_pmd;
+
+	tlb_change_page_size(tlb, HPAGE_PMD_SIZE);
+	ptl = pmd_trans_huge_lock(pmd, vma);
+	if (!ptl)
+		return true;
+
+	orig_pmd = *pmd;
+	folio = madvise_lru_huge_pmd_folio(vma, addr, orig_pmd,
+			pageout_anon_only);
+	if (!folio)
+		goto unlock;
+
+	if (!spans_pmd) {
+		if (!folio_trylock(folio))
+			goto unlock;
+		folio_get(folio);
+		spin_unlock(ptl);
+		return madvise_lru_split_folio(folio) != 0;
+	}
+
+	if (!pageout)
+		madvise_cold_pmd(tlb, vma, pmd, addr, orig_pmd);
+	madvise_lru_folio(folio, pageout, &folio_list);
+unlock:
+	spin_unlock(ptl);
+	if (pageout)
+		reclaim_pages(&folio_list);
+	cond_resched();
+	return true;
+}
+#else
+/* pmd_trans_huge() is always false without THP, so this is never called. */
+static bool madvise_lru_huge_pmd(pmd_t *pmd, unsigned long addr,
+		unsigned long next, struct mm_walk *walk,
+		bool pageout_anon_only)
+{
+	return false;
+}
 #endif
 
 static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
@@ -459,46 +515,9 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 	pageout_anon_only = pageout && !vma_is_anonymous(vma) &&
 			    !can_do_file_pageout(vma);
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (pmd_trans_huge(*pmd)) {
-		pmd_t orig_pmd;
-		unsigned long next = pmd_addr_end(addr, end);
-		const bool spans_pmd = next - addr == HPAGE_PMD_SIZE;
-
-		tlb_change_page_size(tlb, HPAGE_PMD_SIZE);
-		ptl = pmd_trans_huge_lock(pmd, vma);
-		if (!ptl)
-			return 0;
-
-		orig_pmd = *pmd;
-		folio = madvise_lru_huge_pmd_folio(vma, addr, orig_pmd,
-				pageout_anon_only);
-		if (!folio)
-			goto huge_unlock;
-
-		if (!spans_pmd) {
-			if (!folio_trylock(folio))
-				goto huge_unlock;
-			folio_get(folio);
-			spin_unlock(ptl);
-			if (!madvise_lru_split_folio(folio))
-				goto regular_folio;
-			return 0;
-		}
-
-		if (!pageout)
-			madvise_cold_pmd(tlb, vma, pmd, addr, orig_pmd);
-		madvise_lru_folio(folio, pageout, &folio_list);
-huge_unlock:
-		spin_unlock(ptl);
-		if (pageout)
-			reclaim_pages(&folio_list);
-		cond_resched();
+	if (pmd_trans_huge(*pmd) &&
+	    madvise_lru_huge_pmd(pmd, addr, end, walk, pageout_anon_only))
 		return 0;
-	}
-
-regular_folio:
-#endif
 	tlb_change_page_size(tlb, PAGE_SIZE);
 restart:
 	start_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-- 
2.56.0


