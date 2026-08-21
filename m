Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2A6CC5DF93
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 14:50:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B102F6B009F; Fri, 21 Aug 2026 10:50:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE78C6B00A0; Fri, 21 Aug 2026 10:50:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AEE46B00A1; Fri, 21 Aug 2026 10:50:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5EEAE6B009F
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:50:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D8070120161
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:50:09 +0000 (UTC)
X-FDA: 85125561738.07.CB072C5
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2514C140009
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:50:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=o7fcDkHs;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787323808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YBxF99leEnpt7qYGsswqI3Af5X25GbnSBysudSQY9XU=;
	b=dWnG/0HkBnEZ7pogFYs2zwIwZWAxj+AN7RYqfeakEkNwcg0bqzBhRwClhQa1mGbxOoWD5c
	2t0ToStpp5mziC/DJT4KyAVStJiGr+lCYCTiO8jNQxpbrxQlZtT1HkHPLnELvRkA2LZ7QG
	wx218L3Box/nq/9hscIQ5pKsE58lm1I=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=o7fcDkHs;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787323808;
	b=ePxERwXQYOrw84aVz0FHjth8ohExI3fRVs/0uQbmlBWucRLnw8PG+0gRDsQmN/RucFD4Ey
	fKKJda/z94oHG2k/elS1q0NEgzcEeUdp3SXSEx3q0grQGiRXedrUee0svhZLIZMlYu8I2T
	cDyjRsHZVv06s3nvwVB+7e8JiLpYmCE=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-936dfd009d1so171651385a.1
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787323807; x=1787928607; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YBxF99leEnpt7qYGsswqI3Af5X25GbnSBysudSQY9XU=;
        b=o7fcDkHs5i9SGtsznxyxtwdwRstCS8OwDgHFIkDWUlQC9SaFNpRwnVuByWXMhvLftv
         mLwPez3ul1GwyWVHSMZUy+ipMXschTGjjFIRhcZopaSKg7zlbmeqiqVY1wyGLd7thsQ9
         qzgP7jukbTstBU0XhplZVx6Vu9QaGkudoyFGvrPldvDYp1KwrPNaXWjWd4Q/MZDmyHOe
         FECPtEBc+LasscCb3i4CUiM2W+oDwtqvhvctZt+GgkSEr4RZF8/7gWBJDVql0yxKKZmC
         6J7zerj0DxP2X28yyTr/7psBR40za8p+wzx4F0PQAvMJz3gNWzOv7GbfLtS6xKBnDipS
         hraw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787323807; x=1787928607;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YBxF99leEnpt7qYGsswqI3Af5X25GbnSBysudSQY9XU=;
        b=IQH4RpjZsy83EdReWw+4f77jtGnXynRhRZlW/9wDwbZmKbMz57q7kTrBtClpIWNOkY
         EXDZRI1bt3zMAet+TpPZsP3jLeunE0n1eeUqdpj6ZfbSu/rc5gv8Q8rC5K2ePMtN+vfq
         zM3pgUF+bc8Lq+M2XIo/jF2EiTC6r9mkuRHFg0gLxQPAqcOhqiXL+FwcfRJUQUHOCQ+H
         4D7UpmjPfoefTzprYmEtQbIoxjAeSmmR5owOeHlx7upK2/lX0+DbWRQXHnUQ7H4coulJ
         AB7zOV/m24qiHSHh0lXg0OM7vgfytKgphVVtxr5WgAnL1emwePl++RTsG3byMXSy0JWb
         tBoQ==
X-Gm-Message-State: AOJu0YxrXy9UFLELiENhu4u5mn9lI1I5uhzBXT1n6kDBGsXtFbS4JflB
	DNmG4NL2PfcPQZdqBdiRqBuZGAxR0bfQKj+WN+XmY9PRX10mCgZ69sIcn0mhR+vyx56tcBqWnx9
	lFxiRAu0=
X-Gm-Gg: AR+sD11Dim5UL1vlpmu5v8T9PEcB6oYf1r9+aY7cebBU1cOGcdW3Si96/Sg1wC4sjNe
	MlTPgeLFCPWFPErcn0WpdKRTp8vGsxVDMWHZIZwK/ZuFr2NxOjPQXMmpmsxpHeFC2zosvqHafJz
	Jy6kW4UfoF0o68EtYz0Yk9ANojBqkJNo2X1Oj/Xw4yJUoS53VftPeXZGmEKwEd3lYsvcfz5AwXT
	EZ4ryuiDv93Ac7GjTFvyH3bhZrhN//kFAno/Pz1FZ5UhsDOW/2/bRu8ThaOiAmIw/ftmp3PFCy4
	MsCt5lcGD5E9baTo1taWQBfnP/vE3H+g0ikWxOY0QZNa4l4Ipvyh/UmGGLExgzopPMebjStPpIZ
	sjfIFHh/B0uagduwXK7qmLplM4Z0gL8w641JOJVy8xz65FQfXW3YzDrtKTfX1LQlGwVamEALatO
	qBXTOFLETx6rdobrW6dHj2VChM7pNkjge3I/0jc+7/EcAiUSMDaJtez/GmT0flL+op1Tl1v7iNA
	JN9FLTsnEEts9ThwOexxDTWJHsCli6QGuDvVs9JAqG2Qa0wzRdEvCPM4mjc
X-Received: by 2002:a05:620a:44d1:b0:936:e84a:b983 with SMTP id af79cd13be357-9373977c305mr408285485a.6.1787323807059;
        Fri, 21 Aug 2026 07:50:07 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93720493f35sm609512385a.9.2026.08.21.07.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 07:50:06 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	peterx@redhat.com,
	jgg@ziepe.ca,
	sashiko-bot <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] mm/mempolicy: use vm_normal_folio_pmd() in queue_folios_pmd()
Date: Fri, 21 Aug 2026 10:49:46 -0400
Message-ID: <20260821144947.167382-2-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260821144947.167382-1-gourry@gourry.net>
References: <20260821144947.167382-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2514C140009
X-Stat-Signature: kjkrob366kuuw15n5p3bxuy9wfos9kxm
X-Rspam-User: 
X-HE-Tag: 1787323807-732
X-HE-Meta: U2FsdGVkX19RuhbrKWMy6Avz+TOZn5knCBlOJXc8iP31lUDBcRLW3KIpGf5yccjoVkkC3VRNQmfD+Z4x2+j6FBGlgmhaOr1DSzNWaHFISmeMj+WpMLbKkP7FrFuP+OERsdbFL6/lJSVsMRJY6d/qnkdTpcuDjnqL/I4jyPVl14MNTbEpQ9Cccof1+5V1Z2tnfDmSPTCSIf5CuanqmXYeoqbdl/MGN9FwccfSrIHfoaVh9VjJ5KRey7cJ/yv9MeBKd4Onu6SeEmdZsSMhsa7OIthvRk+UlMjnDQcMNmpan5kLUZD4KS5iWGHwGfJpWXpJok/jl+Nljy3NekZI/rejCZDeKpoT6HWWXVYWf2HeSTp9ceqG8Jw3IUqh5/8Pij4kdRT33+E0STjFs/KrZ+1P43m9G5dxyShWe5YcSsFHVnhbJkQhqPzKipR7zJ7SG2qwtwSIZvvzfnk+e6G0zXVFwYOdNNJe3LKS+uZ66ZWhU+Bm+PENyJpm3PuYNzGMYPzuO2YZ4Ob633w9pEGtGMS9mTpe3pwyeEeP4d5FK8cjWb/v1PdnaJlD2zyC7UPQP1R0BL/P60mtJW2etrucytA/fROvI0SooLzUGPMmFt54K6ykV2LdXmjemr3C/RMquRusKCNcj0PLlCM1xY2mXd5VeORaz9o1dDpFgQKAihalSMrcW9tV5V41B96Y7D+zD/E08Wn4xddYtDVXWt6CzeVrrQVHu0SIoAcxhGLw3j6rn3pmlrMn99WpEXrkIsZrXcVNF2CMED1aqeBJ/u6eUhnGQxZ4b8O8+F/C5fswi9Rk26+EexPqR9uwkfnyXKIvxnwWcPpnMEGgI2OGc9W1uPeFGV/Xu4AxaGtvQ/mikXKpJ9pE7muQHi2v/2sz48rvs40BTn/Lv8aK0xLf8ETs+zKKUjeJRXwzv1h+36uewSi4hW58/B+XdGr4qkYxTcTOq2xn/Fbeez7pQJXa61xAmET
 mvcMZaeF
 uOGZsT7Bx+vDLfMrkcaClwDSssO2J9wtj6DjtfHEsAGzjXBBRv5Dq28myNBrjE5iYiXUl+tud5CfRe9VHDYQn8TsdrJrjGcG9Lh2pRNFG2J6cCm+lajtuhOp043/v+lMeU7jw/5EYicde3NqkVEqz8QrvP+GWarF+JAQVMtF0LEG22Cw/Ox59S2i3C/eJPBakGBGrjEvanSOvx/CAwYZbfeuNDR/CpItrOd2vsgsrZciVjbhCk0jl5xl+dBJAU87kadfskfqkL9Z6KbMaI3DbWAE1WRgqYWKKJZouoEIBo1gvFm55KJVKxyMIJdXykletA4B8MKEI0d5T48dcEVbwPUZCODp0EN58LybkUGH2H4qaGFiLPs7ZCdiTnuIVnvlLzi0nO9L6Y9hoHGGz6QX6ZYeo97nM25zayhSr6ap3nfKBR0w5byTXMYmQcqV/Vkc4hgkmsgbKVeEynV7tEMTPut4gJNyftNclqFbZOuoVG5GOP+xHeRrY9zjJlCPM1ccw1aml
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mmap a VM_PFNMAP region whose ->huge_fault installs a PMD through
vmf_insert_pfn_pmd() - a vfio-pci MMIO BAR does this - then

	mbind(p, len, MPOL_BIND, &mask, maxnode, MPOL_MF_STRICT);

With a stand-in module for the driver:

  BUG: unable to handle page fault for address: fffff96dc0000008
  RIP: 0010:queue_folios_pte_range+0xaf/0x440
   walk_pgd_range+0x52b/0xaf0
   __walk_page_range+0x6a/0x1d0
   walk_page_range_mm_unsafe+0x193/0x230
   queue_pages_range+0x64/0xa0
   do_mbind+0x25e/0x640

queue_folios_pmd(), inlined above, calls pmd_folio() on that PMD.  The pfn
is raw MMIO with no memmap entry, so the folio lands in unpopulated
vmemmap.  Neither guard stops the walk:

  walk_page_test()         skips VM_PFNMAP, but queue_pages_walk_ops
                           supplies ->test_walk, so it never runs
  queue_pages_test_walk()  honours vma_migratable(), but only while
                           MPOL_MF_STRICT is clear

A VM_MIXEDMAP vma needs neither flag, being vma_migratable(), so plain
mbind(MPOL_MF_MOVE) reaches this too - and there the bad folio carries on
into migrate_folio_add() and folio_isolate_lru().  mshv_vtl_low is such a
mapping.

Use vm_normal_folio_pmd() and skip on NULL, as the PTE loop in
queue_folios_pte_range() already does with vm_normal_folio().  The huge
zero PMD moves ahead of the lookup, since vm_normal_folio_pmd() returns
NULL for it and its ACTION_CONTINUE would be lost.

mbind(MPOL_MF_STRICT) over a PMD mapped VM_PFNMAP region now returns 0
rather than -EIO.  The PTE loop already returned 0 there.

Fixes: 3c8e44c9b369 ("mm: mark special bits for huge pfn mappings when inject")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260817220810.1175596-1-gourry%40gourry.net
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mempolicy.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index f1aba551f9f1..85803c845965 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -650,7 +650,8 @@ static inline bool queue_folio_required(struct folio *folio,
 	return node_isset(nid, *qp->nmask) == !(flags & MPOL_MF_INVERT);
 }
 
-static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
+static void queue_folios_pmd(pmd_t *pmd, unsigned long addr,
+			     struct mm_walk *walk)
 {
 	struct folio *folio;
 	struct queue_pages *qp = walk->private;
@@ -661,13 +662,15 @@ static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
 			qp->nr_failed++;
 		return;
 	}
-	folio = pmd_folio(pmdval);
-	if (folio_is_zone_device(folio))
-		return;
-	if (is_huge_zero_folio(folio)) {
+	if (is_huge_zero_pmd(pmdval)) {
 		walk->action = ACTION_CONTINUE;
 		return;
 	}
+	folio = vm_normal_folio_pmd(walk->vma, addr, pmdval);
+	if (!folio)
+		return;
+	if (folio_is_zone_device(folio))
+		return;
 	if (!queue_folio_required(folio, qp))
 		return;
 	if (!(qp->flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) ||
@@ -700,7 +703,7 @@ static int queue_folios_pte_range(pmd_t *pmd, unsigned long addr,
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (ptl) {
-		queue_folios_pmd(pmd, walk);
+		queue_folios_pmd(pmd, addr, walk);
 		spin_unlock(ptl);
 		goto out;
 	}
-- 
2.55.0


