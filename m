Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACD65CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 18:31:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 223386B00A5; Wed, 14 Oct 2026 14:30:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FBB66B00A6; Wed, 14 Oct 2026 14:30:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C20E6B00A7; Wed, 14 Oct 2026 14:30:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB2B26B00A5
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:30:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 714C114022B
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:30:45 +0000 (UTC)
X-FDA: 85322072850.23.650590C
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id AB6742000A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:30:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FFC+tXmM;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792002643;
	b=6BkqgVfLcuSGBk5BPzkJeRAh14Ly52bOOrXeiFclo3Q0MdLQCfiWgwbAltVXUDwiIzZ0Tf
	MvNE5BsctfzDFo/jT4d/DzocqXMdE46l4qmpeUw7M9PbcpjlKJQc7NRnNa+sTR3UOqGhws
	aRCEJM7lAyUoLVOwxMKtmlYcU4JjnNk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FFC+tXmM;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792002643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z27Ij9K379BsUAXeMo35PAyhHA0HasTqw8AxKpcrJV4=;
	b=iz0+Aw8jFEZFj+bnvrW9micHdlxzS6WdRHN0ZeB/wtbm4ew1Pd0yxHQKGrae9vLgzOu9xY
	ttVrKQjjCGuINHTrCkUoAWb1CZNNpyxuE7uQDULNZ//3SAKt2mXkDShPcyn61Bt90A6l8T
	DfYE4/ZkAGfCME43TDWhyLAcPchrY5Y=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-917bab38b14so7702236d6.3
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792002643; x=1792607443; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z27Ij9K379BsUAXeMo35PAyhHA0HasTqw8AxKpcrJV4=;
        b=FFC+tXmMKAYAKE3NafZR7J93SH9FzudnKxQVRmEzn95/s5zuUFfxSBKHQQF5fSKxme
         mxhqihpC+MIr9NXBHL2SHsO/SdBnjUgAbf6APt8czKiLKKWLY9kx5ey/JVHHJwjiScbP
         9/9s1YYf4+RFf7YJEDW/DujdU0caKutzRvbZGkmQMSlQFIF0YbhNS3/BIRItsoXxa/qe
         5YJv6nY9LdCdQMOxQNSuqsOmg7h0ZcLQygcKR9Xqa7EoCTlUcSf/KBcJrjPGGJeWZYnI
         zPRkd42Nnllw7M/KlJvZKmZFX1xV7BMQGwp2UxuHGApoVgeXU3GcdyzJB5897PcGZ9Di
         wwEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792002643; x=1792607443;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=z27Ij9K379BsUAXeMo35PAyhHA0HasTqw8AxKpcrJV4=;
        b=VDueuZKKBalMBZ4R64saENnyGpsNaM5t39ij8NUaA4nFrS5lMlz9kM/6ZWbKaWYCPs
         qwi25wDuP6mkwuuMqIHU+dCB0XyKmF4SI6in2zkHrQiMk2Cg+AJ7TvXJCnHelKw2L75t
         fMWmNDqy82FERo4MFpj0XZdPIzXM3Fmey9c4Yptf/FvhsjiOIB2GkNlZucyssO1/x8m/
         eGU3r4951Gv9loprU31anoqM6do8nRkO7iqENLUPpkNWgBfjeDBxLOZdhsRRhIdd7hyQ
         nBUtG5ECunHmHlHDujHEYkXjNFdeJj8gMkbBj1RbHo4dbDD5qIZzzFvl3kyjvZpZH4pZ
         u4Ag==
X-Gm-Message-State: AFq9FYKmFlVoC2dLvd0ymKS6b79MpMQ0nhGMzmJ/1OKPduVeRgQ2GGP5
	EU3LykprZavO1nYyK52JonfKGVN0aYe0uSYfR6yoXxLaclQFhtsW9dRMxuVUeDAKHMugDKTvX7b
	YP5m6DqY=
X-Gm-Gg: AYBFou2mh8fmXYDtAVnKlG96MTREj6QgMvbAjuhiBqyoT7sNpnAxJyQRaxo1y79mMIS
	I99Sojp41OMXVVeQLDRvMu1F2UvUBGkKAQ0K1yAfwQG1z0vvLAP2yT/r5sIKv/zd0CVkSHoBOwD
	cu9SiyQbQBbKcWiTMtaP7cj/BbyRZo7uEl4Kh1G1m+6Un/oUBwiXTesau2V4w/4yJXmnZldkyIv
	pPyIjaBS+WKiAZKoCE5VdT3hXwI3DscJGp63CpJllCKVAG56i/AjVtQlWhGRnr74XnsCE9nAER6
	tEdaly1JSqZe72nLDPtjQ1h4WRauNT+Z251jlsyfzMp5lxfww57dpiX/xne5fu6w3EQTUpbucSR
	tuzVzqMP1mVQ/ScJUnrlPr6tFjlPCRCPe/F+5TuJWHQPn5tgnbdYeHyUuOAaRwFd9F7dUPAPY1C
	9mZMGjDpuAIbTikrkhVD3uXJ0Ev7EcTkp7OfJKhzuets7szkhMsXMDkIfl8VP9SIh9daBlDBGL/
	hKiRMtqxXFj7kBHSxluVzygpuSRVne8aJPGUPXmChrB/sDtMyJkW06oBNpH
X-Received: by 2002:a05:620a:270d:b0:93e:7939:43f0 with SMTP id af79cd13be357-93ebd247f8dmr2807496785a.32.1792002642732;
        Wed, 14 Oct 2026 11:30:42 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef508811esm556593085a.36.2026.10.14.11.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 11:30:42 -0700 (PDT)
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
Subject: [PATCH v2 09/10] mm/madvise: make cold and pageout PTE lock ownership explicit
Date: Wed, 14 Oct 2026 14:30:23 -0400
Message-ID: <20261014183024.2075709-10-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014183024.2075709-1-gourry@gourry.net>
References: <20261014183024.2075709-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AB6742000A
X-Rspam-User: 
X-Stat-Signature: iixumi5rdu4qeqp89x4zef95nync483h
X-HE-Tag: 1792002643-859398
X-HE-Meta: U2FsdGVkX18oIXGNTYH0COdtk1RYHnUJZUkfuvITr89IndBif4aUOrBZckadjVP6cQEBmZmZMZsa47Pvttyqnx+rMTDK8i8RlyhX4ENfLv2YFHOKLeGoL6pT3pwyLOJtfkdywJk8ur3JBB/bwIeld6znOxJIBltk2EEbeaOeUhx3bf6c23S3P+lUjs273f9dlIPh3x04tXAh0njHA9JDFAqhiixMgDwWNhT7wxhyjCEJuh7PBPYdjt5adVBqi0KWDz9iK08/M/SHvqgyFWlvcZu0bbtkTTsvl+c+ttd6KlCyqOyFjNHgsHKkHofphBAbrvXGqgsm9HVoIWyWHpMfqTdtX+mqR5E/Uf7my3qlbdUrvCyTgeztVn2hRN4pNDPWs6Y+sEBCTmvQk0iw4Tmd5iuv/vxdY41/AnSy5wqVU8zX9XEDNld7934WZ17c08wPPCgJS1cmMN83ilprZBdGYghmpcBy8ljEV3QvVIJGSGvH9EqfXGtCyScNAxy4SOaU20utGKrEwcWUvRPCSVgDPiLNhzX4kdFvbzax7oLQHtQZRLSBN9qnIg64G2CPtFm24aEP0lb2LIF7ZOJ3CmEMvs68NpB/pdDqTfyxR1ydQF4VXGGnSuCSfqfXw+8m1txS+ublCB7snG5ANc5xVTckLGgbw0sbmMdMAz/+nSGp3AgGFc+nqf+cVqmEo7uspJrmh3gNvmqQcTO0jEntMT6o7Joqsxe4/AJpUYN7JklDdB7FhPpYGTBAp5f+TRYCiIT4HhHqoGgDAN9xAZ7XlZqWmhCQn/zgbbhvddpsOhkHeiKTeLHowpwWsY20MyTvHw8XYiganTKaHIV5q2aS9r5kFWl77AE/zgl2+4kTH/xtF20e3ljh12ndoV3EFa4Ef0sg6fC8ZRSLmGWl5Au7oKHtjN0VkjNPtbY6/vbJM2a4UE0iUpISHfhqblloEsaIqgWMoFFb/NhtZ99GuopkB/V
 LxbK8bbq
 UH22+QFiEKrNAujqwd9oW4iE1WSBPUIVVe5TCVfNURLbaFl3BBCxSZybckD1F+0DFvmH/K7/04/7PdXKrs30X5OVAbS9ZewPSTzGLijKgMcRFXx9HVHPKqCC6ILLZC85gnAziWK6HK9+1Ags4VlPSEA5FQ895HF1LBmrQx3lwjDFLT4nAeZvjScfeeqIhNWoJRTbcf4/QJti787p/UgKVNlL3UabQYXbr+ELq3YZBJGfvq1REp9jPoVSY+vIGyYYhGJgHd+dyiyfU2viX7dbamFRRMOikPtOaQX12GcyqdL3Iw2+kYLmlLwYNQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

madvise_lru_pmd_entry() maps and unmaps the PTE table through a
restart label and an out label, so finding where the PTE lock is
held means following every goto.

Move the PTE path into madvise_lru_pte_range(), whose loop takes
the lock at the top of each pass and drops it before splitting or
rescheduling.

madvise_lru_pmd_entry() now only checks for a fatal signal, computes
the anon-only filter and dispatches to the huge-PMD or PTE path.

No functional change intended.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/madvise.c | 91 +++++++++++++++++++++++++---------------------------
 1 file changed, 44 insertions(+), 47 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 3ebc14d30e0b..acfe5b945eea 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -592,64 +592,61 @@ static struct folio *madvise_lru_pte_range_locked(pte_t *pte,
 	return NULL;
 }
 
-static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
-		unsigned long end, struct mm_walk *walk)
+static void madvise_lru_pte_range(pmd_t *pmd, unsigned long addr,
+		unsigned long end, struct mm_walk *walk,
+		bool pageout_anon_only)
 {
-	struct madvise_walk_private *private = walk->private;
-	struct mmu_gather *tlb = private->tlb;
-	bool pageout = private->pageout;
-	struct mm_struct *mm = tlb->mm;
-	struct vm_area_struct *vma = walk->vma;
-	pte_t *start_pte, *pte;
-	spinlock_t *ptl;
-	struct folio *folio = NULL;
+	const struct madvise_walk_private *private = walk->private;
+	struct mm_struct *mm = private->tlb->mm;
 	LIST_HEAD(folio_list);
 	unsigned int batch_count = 0;
-	bool pageout_anon_only;
+	struct folio *folio;
+	pte_t *start_pte;
+	spinlock_t *ptl;
 	int nr;
 
-	if (fatal_signal_pending(current))
-		return -EINTR;
-	pageout_anon_only = pageout && !vma_is_anonymous(vma) &&
-			    !can_do_file_pageout(vma);
-
-	if (pmd_trans_huge(*pmd) &&
-	    madvise_lru_huge_pmd(pmd, addr, end, walk, pageout_anon_only))
-		return 0;
-	tlb_change_page_size(tlb, PAGE_SIZE);
-restart:
-	start_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	if (!start_pte)
-		goto out;
-	flush_tlb_batched_pending(mm);
-	lazy_mmu_mode_enable();
-	folio = madvise_lru_pte_range_locked(pte, &addr, end, walk,
-			&folio_list, pageout_anon_only, &nr, &batch_count);
-	if (!folio && addr < end) {
+	tlb_change_page_size(private->tlb, PAGE_SIZE);
+	while (addr < end) {
+		start_pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+		if (!start_pte)
+			break;
+		flush_tlb_batched_pending(mm);
+		lazy_mmu_mode_enable();
+		folio = madvise_lru_pte_range_locked(start_pte, &addr, end,
+				walk, &folio_list, pageout_anon_only, &nr,
+				&batch_count);
 		lazy_mmu_mode_disable();
 		pte_unmap_unlock(start_pte, ptl);
-		cond_resched();
-		goto restart;
-	}
-	if (!folio)
-		goto out;
 
-	lazy_mmu_mode_disable();
-	pte_unmap_unlock(start_pte, ptl);
-	start_pte = NULL;
-	if (!madvise_lru_split_folio(folio))
-		nr = 0;
-	addr += nr * PAGE_SIZE;
-	goto restart;
-
-out:
-	if (start_pte) {
-		lazy_mmu_mode_disable();
-		pte_unmap_unlock(start_pte, ptl);
+		if (folio) {
+			if (!madvise_lru_split_folio(folio))
+				nr = 0;
+			addr += nr * PAGE_SIZE;
+		} else if (addr < end) {
+			cond_resched();
+		}
 	}
-	if (pageout)
+	if (private->pageout)
 		reclaim_pages(&folio_list);
 	cond_resched();
+}
+
+static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
+		unsigned long next, struct mm_walk *walk)
+{
+	const struct madvise_walk_private *private = walk->private;
+	struct vm_area_struct *vma = walk->vma;
+	bool pageout_anon_only;
+
+	if (fatal_signal_pending(current))
+		return -EINTR;
+	pageout_anon_only = private->pageout && !vma_is_anonymous(vma) &&
+			    !can_do_file_pageout(vma);
+
+	if (pmd_trans_huge(*pmd) &&
+	    madvise_lru_huge_pmd(pmd, addr, next, walk, pageout_anon_only))
+		return 0;
+	madvise_lru_pte_range(pmd, addr, next, walk, pageout_anon_only);
 
 	return 0;
 }
-- 
2.56.0


