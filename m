Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7567EC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 23:59:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DEA76B009E; Tue, 22 Sep 2026 19:58:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B70D6B009F; Tue, 22 Sep 2026 19:58:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7302C6B00A0; Tue, 22 Sep 2026 19:58:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3CE2E6B009E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 19:58:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 21296120633
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:58:53 +0000 (UTC)
X-FDA: 85243066146.24.5CADFF6
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf05.hostedemail.com (Postfix) with ESMTP id 67B31100002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:58:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GVHo1ap2;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790121531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l3xhM/OIBt/SuFbuoCQCsVkZeh3BpJl7fkoqP+MrWAM=;
	b=uEQ7RuTd3mGSKt6Z7dRSv8+ntmK7Q31zeBYwYaqUkOrVnFJ0nAvPZ63jWO8/C208vZ9OfN
	pi1DXf2vJd6fieW1f12CSi3RnrzAHakDUTGsBexz1ESqadA3nupZAI+qhgCozLFc3ogT/R
	A8DPdpXjIuWRKk8rH49qGzhBFFncjbA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GVHo1ap2;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790121531;
	b=4e490V45Xd3VlADNycB++7qvLtXNAb4F1RS1gHJObecCPvf4HUKsJsH1PkLnms0LFR/SIM
	pXkGe3q30399oXktBaKzJQt4VpPfkX1p9z8xDnblNqLRdMfQYpVBG2QXTadS+CIGp018jd
	61IwtNStX6Has2uxh3XmErKw46l4G1Y=
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-52fb76c9df1so4217511cf.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 16:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790121530; x=1790726330; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l3xhM/OIBt/SuFbuoCQCsVkZeh3BpJl7fkoqP+MrWAM=;
        b=GVHo1ap2TxTE75f7vkEYvRV1Rrx4Xi5lIi+y7qoNDX56lwLZ0A1Oe/pNjuArCMHaVf
         aNE1DARnHpq4/9Sofknz1kRygf2eGCSsKh/RaQ6Fm7GTKo4epg2+/rcNai7erSl/Y8rk
         FgYfkdTi2nQrL2enY362wvEqpDPPsi8IYWkjzmyc9eGBV/Z9eVQID0F24XWw6ACf3Rws
         5NPoy329xl14gWpa8IydXdp9BxNXJWBhF7WKNou3+l96RHaQ88B5gXLuHtPa/GkqseN2
         Yau/r5rGfabHe+dZlKCMSxuQQ2WXy00Xy0VesluXffAR5RmkFSx5eY9DhPtKqDooIHDk
         gmBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790121530; x=1790726330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=l3xhM/OIBt/SuFbuoCQCsVkZeh3BpJl7fkoqP+MrWAM=;
        b=RGT9tV/qk6E3ww6xMVvkC9LPjreb+3gQ8PBKh1r8Nv8uBV2CMN1NQZr6U1y/0eyq6Z
         HTkqatVobFBfK6OTdfKNsSnriXtrz6/WqwqCJorcH3Lce72JmlZjSeFrPRl/NV4B55Ac
         Zn5UA+cdg6lJhNwkdGWJosMK/D8F4+NNY6F1UFVp/3WRCoSD2j7Em3+vBIDOCPaRY7P5
         DyPMJJdrXfihcmGCUrQEiJeeanPDo9kh0ThBzZunQSDyVNsSSSjHIrTXQBDvq0iASXwL
         tR06z6YAvcGvgca7cr1Pc4/pnRosvx44lSq3F2m0E4KZLJG1y9JX1S2rTF4ZT641VD8I
         NCew==
X-Gm-Message-State: AFuF++ntAGsWQvSFCppcG+MV0Xd4y1mAfn/ZdaQnGltmt1qw4UuLqbfe
	Uzfrluemta4IDJdmaCsqHzKUPnIubcv7Ooxqi5mg4CbPy1wNVZR/+m6VtbPfbXNj0b4b5cyhoRt
	fWzdtifY=
X-Gm-Gg: AYBFou1IHgMzxC/lvKbLWTrwhH1RAZaKAcf0QvhwoftcPUW2+OB1O+6fGL581/fsfPX
	JKNFG8CgV7OPJxPPmz0WzQJItAGy5ah7O8oIVxAPXIndNgfZfpde+3FAPP0s80xWZbTJJspBYAW
	36frOwC4zuIP0yolt4fJg2sjgB9xOOwOYJ/dcm4KPAN1j6FS5Z44CZvwgHgD2xTfCdOnHKHggpT
	CPMcvgonwmaUztONiUEfhD5iKomqP3MqF+1DOhbIgT71cu7cWZ8IGVWIkv19QI+4nvWVqjgDqWu
	qxQ5B9b/rhl83lNl45Y73G06gnmgyhrimXG/WJtyJSBfEggpU1agON7J4p79Po2Qa4ilzI02E1t
	XERLYHj047jZG6zDlcIuXyeyoTQja53BwnGXPq2Ot9Q1N3Qak5dzRg7YyT8X0lDtmwn+HrLrlJ+
	0NJxKHGqdtgW61E4u8/ni7R5tgvfvqMdNRtKXGStivFdpiWptJ/43pLB2DoKHgrpN+8ZA/SfKwQ
	Fyml++AkPfGCxDMZGZJEtU5rH7hIfXuxwEZOVb0iJs65z7xhwtsdHLEXFQy+2xiQusf+38=
X-Received: by 2002:a05:622a:411a:b0:52f:f73c:3269 with SMTP id d75a77b69052e-532ead1e0c5mr18771951cf.36.1790121530629;
        Tue, 22 Sep 2026 16:58:50 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532eb3c6715sm8323261cf.30.2026.09.22.16.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 16:58:50 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: [PATCH 09/10] mm/madvise: make cold and pageout PTE lock ownership explicit
Date: Tue, 22 Sep 2026 19:58:29 -0400
Message-ID: <20260922235830.2350770-10-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922235830.2350770-1-gourry@gourry.net>
References: <20260922235830.2350770-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 67B31100002
X-Stat-Signature: gt4dn195eofcwyzex59kh5nkcoox1mai
X-HE-Tag: 1790121531-934525
X-HE-Meta: U2FsdGVkX18fl0AJRayQ0TMeI2OcmFoy2uRGiaIrQcWAeV2N27GQarqfvKbAnofBKN9aQqYomwlVPRg+o3mh5BZqi5q9GHpPGjYgV9BcrKFBvA5kBwAJSEhGjmz+GB3yGAnP2wyJW4UJgGTaVo8YDZ20Xe6gb38HICXg9rpUjaTMzmXOond2UDmdckGWr55Rl0fj9OVwu53a1SevmvIhjtgYOxTVDTr33VgLO0guAlPB6VIElUYBnXvTlQ2sjTPLH67TGwKfTXbo34mmRw1KdR/0H6eD3U6Jufv/Iy5ssUoSRQC33jTBjnrPqnzbFaVHz5MVcu+uRqW4PQ8U9Dpr3jDOMNTxe86oxp0zn0pP8GDPliE6O7IdsolEsL8Xkjq2YzqaAagsyRaFCYnOfRq8Li9MMLXmeK1sH4t1IUCdnfxMr1+xSDn87CP8Qsz0/EA/SIVDeoDncB5VoDITcO3tUqynNWYZvNX1qp/uvE6a84MbXksFRJ9YpczuV16fBLwipjEUCj+jSVV7/08m7gSEYv0hNMFSm+PcF8hQ3426S4DgXpasHJZNM2sB1KILZu6sICrY49vRq1iUg/28bBQiR6Tpm6/Nk4On020waWrf/3D9oqS2dbQtvDcEWM4Lf2ptgwfU2xhQXXZwMuk/IYwPXerUyA05TFSKZz30TzKlhX0ELLs8LWlZThQSaVuQrlNrUH62vD3lK7ASynCPDfx1vLcG52ucOHtOvVUK05XjYsYl9n+xeAP202fH0cE6qcYrI7hE+LuBz1VW6cAtAn6lK6VMieCkPEfduoFFyM9vl6iHnRWr5x+bj5pqWk/qEjEyiNQypFV198xhWK8N2r/iFLSXlk/0KDaKodw25yOqeDCHh+fmbixtqYmeDVi5GWx1IQlLMfphfzqNDesZ19DVXad0R2bEerPTRhr0XSvYWGqq7RUPlHo2wuDYk5kbfupOakRmxIMw0PVnsWq1I8t
 CerKvVKJ
 9MMgK7I2jE7anrn6Wy3LM/h3Cp27U4G0jzawOKxBcF/hbvn8CrnmTwfwJyXZPjoTWmrT4MT9f0XIHcqb66JrC7hfA5vjNmmvAEVq7EyFtRggGC9fZllKuhYkqNfjzGjhNsGzKTUjxfHV3ihnS/tRO1rsIcOAnc/4AzRLQqMeHjEOrB1HARx5PxAidC1bhugAForMmAthT+DaSGb1YQ6u47JYBLjaZeHXHMiKuMaj2fAI3otLjs7yN/M4iPxT7wYPWbnqzPUg5qTTNV9Pvp2cpJvfogwMwboVeENt6BgMb8utgGj4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The PMD callback still maps and unmaps the PTE table, drives split retries
and handles rescheduling after dispatching huge PMDs. This leaves PTE lock
ownership mixed with the page-walk callback.

Move that lifecycle into madvise_lru_pte_range(). Its outer loop drops the
lock before splitting or yielding and resumes at the current address,
leaving the PMD callback to select the huge-PMD or PTE path.

No functional change intended.

Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/madvise.c | 94 ++++++++++++++++++++++++++--------------------------
 1 file changed, 47 insertions(+), 47 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index e3c3acfcd9b66..88a4a03dee04c 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -553,66 +553,66 @@ madvise_lru_pte_range_locked(pte_t *pte, unsigned long *addr,
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
+	const struct madvise_walk_private *private = walk->private;
+	struct mm_struct *mm = private->tlb->mm;
+	LIST_HEAD(folio_list);
 	pte_t *start_pte, *pte;
 	spinlock_t *ptl;
-	struct folio *folio = NULL;
-	LIST_HEAD(folio_list);
+	struct folio *folio;
 	unsigned int batch_count = 0;
-	bool pageout_anon_only;
 	int nr;
 
-	if (fatal_signal_pending(current))
-		return -EINTR;
-	pageout_anon_only = pageout && !vma_is_anonymous(vma) &&
-				       !can_do_file_pageout(vma);
+	tlb_change_page_size(private->tlb, PAGE_SIZE);
+	while (addr < end) {
+		start_pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+		if (!start_pte)
+			break;
+		pte = start_pte;
+		flush_tlb_batched_pending(mm);
+		lazy_mmu_mode_enable();
+		folio = madvise_lru_pte_range_locked(pte, &addr, end, walk,
+				&folio_list, pageout_anon_only, &nr, &batch_count);
 
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
-	if (!split_folio(folio))
-		nr = 0;
-	folio_unlock(folio);
-	folio_put(folio);
-	addr += nr * PAGE_SIZE;
-	goto restart;
-
-out:
-	if (start_pte) {
-		lazy_mmu_mode_disable();
-		pte_unmap_unlock(start_pte, ptl);
+		if (!folio && addr < end) {
+			cond_resched();
+			continue;
+		}
+		if (folio) {
+			if (!split_folio(folio))
+				nr = 0;
+			folio_unlock(folio);
+			folio_put(folio);
+			addr += nr * PAGE_SIZE;
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
2.53.0-Meta


