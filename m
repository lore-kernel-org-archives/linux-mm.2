Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77BC2C3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 18:30:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 816D66B00A3; Wed, 14 Oct 2026 14:30:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A0CE6B00A4; Wed, 14 Oct 2026 14:30:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F28F6B00A5; Wed, 14 Oct 2026 14:30:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3278C6B00A3
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:30:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B3ECBA845E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:30:42 +0000 (UTC)
X-FDA: 85322072724.06.DDDD412
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id E650C1A0011
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:30:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FHhdT7BT;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792002640;
	b=KB8vDtaAspvhasdhEhCajPjYwAa5k4/NlSHJQIN3OTvrX3SulprXlWyVh9gSsWTh9n1Xyh
	rBIKRlVEMU5XQBpoMxF7MVR9YgHjpGufW4b+nYiL+eWQSBx1ZZXOWUB5FcGs0DQld1qiyc
	o2/CpAZgYjGzjpcZ4vBd3klPYETw66g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FHhdT7BT;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792002640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6rnuGk4ufowJ9LY5euPS4WtjSZLrLvn92pFDqhxj834=;
	b=1q0jMHFpaYTCjsoN/teL77YpqnUDM9pukcrUXDwfU7jN3EP/t6BnLgZJXhasbJjjo6TKFX
	IpFsAjSUMpn/eSl6sBjQ8aFtLO/RbmxCaWXablejvmzhc/Jg1xVke7EzpPjkHOk4A50458
	X5AlDFA4v+96J6EAAxcyez8Oq772Chc=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-91791ec1b83so6298046d6.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792002640; x=1792607440; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6rnuGk4ufowJ9LY5euPS4WtjSZLrLvn92pFDqhxj834=;
        b=FHhdT7BTl+0LcWjadxbAvRuAOhpiHdIjifxdGuiDrXCbCsw9XpZvMmv4mRhWHQuijS
         yGoiTA8ASocrcKjc2zQhtxKDpt3dmwMpo3AnlWQkin3CeJfwmHYsK9L/IAxKRMetX2kF
         jIQLkuawxbf8Fss7jw5ujndEFjn39mNtDVr++JLSFY4q/aTPn9jYJC2QYav+wE56x4Cu
         QsE5QC+q6QkqesEAu9nVCpu7DIin99066eTgLmrr79ZnnFi9MDyHUrzrVKjMrhGjVubK
         C3tablaavOa6ZNdqxDa+fWpVIEzxpYQEefooTBKA/d+h2FBvmALMto5tVkjPX9t8cm3I
         0bkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792002640; x=1792607440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6rnuGk4ufowJ9LY5euPS4WtjSZLrLvn92pFDqhxj834=;
        b=THiGOagr/jqS0PxRRBGkUhkPJyC89tpIpEp2j6fLA2/ojQicuojCUJB0kXWP8L7ZX0
         9TJG2h6XJyn3MTvKyEFGCUg18UZS7xIsYcT70FUnYpCbApv8+DXnK/1dgaUZ7pqESlOe
         6G1MFWSrvGIpmBHL5epzUlPcAxt9I5ylonrWvVKlrtxjlAaRkH4gInQosFBVG76XkEQB
         P3m0j83Zuje4BxnZeMkWe4M10sZfpyH31ofvwDio1Y2tyzYYj/NpcyOp0u9gN+MhjdKd
         FSVydW5jVQg7pEl8vewRt0K6OraLY3zCgtG3Jfz5U4uA8zHF1S4YL5bzuWXK7LqAyoDz
         YHqg==
X-Gm-Message-State: AFq9FYKqttfJO7R9LoFiKYuiQKjPCl9CjnstSTOVH9pHrWWhhqzxJ91o
	HpGbnRe5Zuzom050Pz2WTeti62rI1RiqGF4tEhA5bT3UuDDBDGiDOXRHxSIVibttLPbSlADH1mW
	yX7mhyH8=
X-Gm-Gg: AYBFou31qaHhQF06WQDL69FwNvgk9OM2MKxtchg0yQtf/ffHk5f/Mf1MylfGtVi+Qa2
	plGj2ok0FyEfIjel2t1udwRwpMZLW5oPAL7mfIa+ccgRUbObT7wS0TCb2W2YAGz4z1JZaPdVH3a
	tfecHtyRMUF6TwdpsYcjC7dwsUajhUIVPzIZMeQnkm0VaVH0sYq/wNgWVHIOEIcVS4/+xkoNsLM
	w1MS0lvxO1jCw6zcDbTtX+y/Y3booIK5R0zPBnpB51cJzj0Nec/VBq/WBaYKP0hDY+qtOln+Uma
	a/lHLJuobpoitfW+RNDZiTNify3R6WHQ9jyu0yiGafM/L3r2bPqKGAdck7Qf9qcuXKeAf4xv/8p
	lGqoxkfXwWBgwEh+wxFGcvteGrKozMeyHSu2YG5d3D+wpfOSM/NVd+nxc1O84/+BcPd3FOhfTpO
	hcSdn2vst13QrGgzk7/TrsQZ3zDbYQQx0yuQBrXVfh2QSUcUSnN8f944GsRB05yVlFZtCEdG/nf
	Yb2lWzDTAP/k2Zb2biFbyslyp0D7+8XbNLwjOCothUF2F6IXS0kUURSc9VO
X-Received: by 2002:a05:620a:2715:b0:93e:6709:bc7f with SMTP id af79cd13be357-93ebd2113a5mr2385591185a.15.1792002639693;
        Wed, 14 Oct 2026 11:30:39 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef508811esm556593085a.36.2026.10.14.11.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 11:30:39 -0700 (PDT)
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
Subject: [PATCH v2 07/10] mm/madvise: separate PTE-batch folio processing
Date: Wed, 14 Oct 2026 14:30:21 -0400
Message-ID: <20261014183024.2075709-8-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014183024.2075709-1-gourry@gourry.net>
References: <20261014183024.2075709-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E650C1A0011
X-Rspam-User: 
X-Stat-Signature: ncjky4iwmtxbzis8gz94bimunzf46bnt
X-HE-Tag: 1792002640-682624
X-HE-Meta: U2FsdGVkX18CtEqnb/i6jvFt/EFNn/N6JlIq7TP/8etXc3in9V+16h9l8gKxXLW6Wd/LlfaCHRZ2M9uV3Id2h3B+XraErlHYu2mk2idLVm9teYVIQkcbskyk4DczwrdsHdakrqSS+mkMZJytyf2JvHMyK6Q3IIDMZbAIOA5FYev+Dt5lKPEtZiULNs4YFWENNHdJRvnhbZ5RAFSnvYfhSsSiuq69BfRTYmqR76QbqFpqMTAGwHiXHvZpWWMpVStTZj+nreZWe4jKWUcJC8Q8AH6fO6kJ92jmoK+tmUQXfdMcUKIO8AmOH70KlkSlZBogNPCpR4oKsvHgUWKdA6k3Pg2n6CzzjGEYv5GovXMqEki36DXX/H+ORE0d26NWEIRWkAj4kzUo3fpAPqiQot7MkIHtBsVmMH5Zyb+m27+N3efDQQoSgQgsanYpINfqr1wYUoHHV1qrNXdA8d5bTSZwwzDhz0dqacfmMaY2JxvRqCFtfyjXaXkVfB4nu6qvxex8hBE6w14ug133fPT50WhAftf2lwxfxSyfph0ywtp8VDLBvhng349ouUm4uzqURUXtSiRqacOONDBAMgjWnc+PvBdKhrKLnBDDWB6P3eBm93sCz8ZnQQVFiaR4UunqEnarIQnSzrh3AwatMQO1iEyUDFY2Mt+UqFBYsL7PqP2KMUMicsshUMIvrVXOT3VaKoj6oy+22HM+KquojYfKYkwlyHPfMIRHMWKTQbSpIxQ4cnymFyLCuSMletiuCWQ6avl3+hf9cqLKyK19viqed4oeJYPRe/Fe12dcn3f9WoB1ExDyuTnsGviwTzBkQa/ErnoPwq0KHUwpBLA419i1lQZkyk4idTAEOVMKxVbp93iYS7i74LLUpGCfcoME7EkzQBPC1LSgM0m2DmfEgjr1teT4WJM/UaEmaAcYFJ6TL3j2AtMVISJ4EC5eG2DhTh15ib4ZppE7odhGMMZxF4WU9Rs
 Xn1XhmmF
 aj1sgm63MDb6ucioUIGVzsgmj3G7FWlH9MGLuBjnCM0k7mtctlNxRpWIL2GfpXkqgl6qHO/KizE82PgAFLEq3ld8Exee2VoIMtHT5kYdjfu+upDJ2R4gLZYhs10C5M9jgG0zOdoAwMQ6OuIZJu7nTwnPY2nY9fsMF2AX85HbkETYqzBaA/OueIMM+946hwBQewV4SHO3fOJFx3yuMUIIWLU5c0oZTRupvaI5g5Kkzalk714cztna5n+P7GlVtfDSIaJe+HqOdVbcyn38vqnB35qXQiBugp23F7lsIlW9ralD6KAcxY7dU+mkX2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Each pass of the PTE loop validates the entry, batches the PTEs that
map one large folio, decides whether a partly mapped large folio must
be split, and ages or isolates the folio.

The split path also drops and retakes the PTE lock in the middle of
that sequence.

Move the per-batch work into madvise_lru_pte_batch_locked(), which
runs under the PTE lock and returns a folio that needs splitting locked
and referenced.

The folio lookup goes into madvise_lru_pte_folio() and the MADV_COLD
young-bit clearing into madvise_cold_ptes(). The loop drops the lock,
splits the folio and maps the PTE table again at the same address.

No functional change intended.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/madvise.c | 151 +++++++++++++++++++++++++++++----------------------
 1 file changed, 86 insertions(+), 65 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index a9e5a3e2fab4..0c0a840102eb 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -407,6 +407,77 @@ static int madvise_lru_split_folio(struct folio *folio)
 	return err;
 }
 
+static void madvise_cold_ptes(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, pte_t *pte, unsigned long addr,
+		int nr, pte_t ptent)
+{
+	if (!pte_young(ptent))
+		return;
+
+	clear_young_dirty_ptes(vma, addr, pte, nr, CYDP_CLEAR_YOUNG);
+	tlb_remove_tlb_entries(tlb, pte, nr, addr);
+}
+
+/* Return the normal folio mapped by a present PTE, or NULL. */
+static struct folio *madvise_lru_pte_folio(struct vm_area_struct *vma,
+		unsigned long addr, pte_t ptent)
+{
+	struct folio *folio;
+
+	if (pte_none(ptent) || !pte_present(ptent))
+		return NULL;
+
+	folio = vm_normal_folio(vma, addr, ptent);
+	if (!folio || folio_is_zone_device(folio))
+		return NULL;
+	return folio;
+}
+
+/* Return a split candidate locked and referenced for use after the PTL drop. */
+static struct folio *madvise_lru_pte_batch_locked(pte_t *pte,
+		unsigned long addr, unsigned long end, struct mm_walk *walk,
+		struct list_head *folio_list, bool pageout_anon_only, int *nr)
+{
+	const struct madvise_walk_private *private = walk->private;
+	struct vm_area_struct *vma = walk->vma;
+	pte_t ptent = ptep_get(pte);
+	struct folio *folio;
+
+	*nr = 1;
+	folio = madvise_lru_pte_folio(vma, addr, ptent);
+	if (!folio)
+		return NULL;
+
+	/* Split a large folio that the range only partly maps. */
+	if (folio_test_large(folio)) {
+		*nr = madvise_folio_pte_batch(addr, end, folio, pte, &ptent);
+		if (*nr < folio_nr_pages(folio)) {
+			if (madvise_lru_folio_is_filtered(folio, pageout_anon_only))
+				return NULL;
+			if (!folio_trylock(folio))
+				return NULL;
+			folio_get(folio);
+			return folio;
+		}
+	}
+
+	/*
+	 * Skip non-LRU folios and folios mapped elsewhere. A large folio here
+	 * is fully mapped, so it is exclusive if its mapcount equals its page
+	 * count.
+	 */
+	if (!folio_test_lru(folio) ||
+	    folio_mapcount(folio) != folio_nr_pages(folio))
+		return NULL;
+	if (pageout_anon_only && !folio_test_anon(folio))
+		return NULL;
+
+	if (!private->pageout)
+		madvise_cold_ptes(private->tlb, vma, pte, addr, *nr, ptent);
+	madvise_lru_folio(folio, private->pageout, folio_list);
+	return NULL;
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static void madvise_cold_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		pmd_t *pmd, unsigned long addr, pmd_t orig_pmd)
@@ -502,7 +573,7 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 	bool pageout = private->pageout;
 	struct mm_struct *mm = tlb->mm;
 	struct vm_area_struct *vma = walk->vma;
-	pte_t *start_pte, *pte, ptent;
+	pte_t *start_pte, *pte;
 	spinlock_t *ptl;
 	struct folio *folio = NULL;
 	LIST_HEAD(folio_list);
@@ -526,9 +597,6 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 	flush_tlb_batched_pending(mm);
 	lazy_mmu_mode_enable();
 	for (; addr < end; pte += nr, addr += nr * PAGE_SIZE) {
-		nr = 1;
-		ptent = ptep_get(pte);
-
 		if (++batch_count == SWAP_CLUSTER_MAX) {
 			batch_count = 0;
 			if (need_resched()) {
@@ -539,69 +607,22 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 			}
 		}
 
-		if (pte_none(ptent))
-			continue;
-
-		if (!pte_present(ptent))
-			continue;
-
-		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio || folio_is_zone_device(folio))
-			continue;
-
-		/*
-		 * If we encounter a large folio, only split it if it is not
-		 * fully mapped within the range we are operating on. Otherwise
-		 * leave it as is so that it can be swapped out whole. If we
-		 * fail to split a folio, leave it in place and advance to the
-		 * next pte in the range.
-		 */
-		if (folio_test_large(folio)) {
-			nr = madvise_folio_pte_batch(addr, end, folio, pte, &ptent);
-			if (nr < folio_nr_pages(folio)) {
-				int err;
-
-				if (madvise_lru_folio_is_filtered(folio, pageout_anon_only))
-					continue;
-				if (!folio_trylock(folio))
-					continue;
-				folio_get(folio);
-				lazy_mmu_mode_disable();
-				pte_unmap_unlock(start_pte, ptl);
-				start_pte = NULL;
-				err = madvise_lru_split_folio(folio);
-				start_pte = pte =
-					pte_offset_map_lock(mm, pmd, addr, &ptl);
-				if (!start_pte)
-					break;
-				flush_tlb_batched_pending(mm);
-				lazy_mmu_mode_enable();
-				if (!err)
-					nr = 0;
-				continue;
-			}
-		}
-
-		/*
-		 * Do not interfere with other mappings of this folio and
-		 * non-LRU folio. If we have a large folio at this point, we
-		 * know it is fully mapped so if its mapcount is the same as its
-		 * number of pages, it must be exclusive.
-		 */
-		if (!folio_test_lru(folio) ||
-		    folio_mapcount(folio) != folio_nr_pages(folio))
+		folio = madvise_lru_pte_batch_locked(pte, addr, end, walk,
+				&folio_list, pageout_anon_only, &nr);
+		if (!folio)
 			continue;
 
-		if (pageout_anon_only && !folio_test_anon(folio))
-			continue;
-
-		if (!pageout && pte_young(ptent)) {
-			clear_young_dirty_ptes(vma, addr, pte, nr,
-					       CYDP_CLEAR_YOUNG);
-			tlb_remove_tlb_entries(tlb, pte, nr, addr);
-		}
-
-		madvise_lru_folio(folio, pageout, &folio_list);
+		lazy_mmu_mode_disable();
+		pte_unmap_unlock(start_pte, ptl);
+		start_pte = NULL;
+		if (!madvise_lru_split_folio(folio))
+			nr = 0;
+		start_pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+		if (!start_pte)
+			break;
+		pte = start_pte;
+		flush_tlb_batched_pending(mm);
+		lazy_mmu_mode_enable();
 	}
 
 out:
-- 
2.56.0


