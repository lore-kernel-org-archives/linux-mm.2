Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2E4EC98332
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 10:51:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE8A36B008A; Sat, 26 Sep 2026 06:51:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC0716B008C; Sat, 26 Sep 2026 06:51:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAF2E6B00A2; Sat, 26 Sep 2026 06:51:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9119E6B008A
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 06:51:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 26BDC4081E
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:51:18 +0000 (UTC)
X-FDA: 85255596636.23.1EC8DA7
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6A5411C0005
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:51:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tauXva5N;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790419876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=reM3bvpTAJ659qLf9u3c5WYxIz1dkkiHph331s5crXk=;
	b=pgpFOMW3jfOSo1S2O6YDqFZsUlkpdwgQqZ3h2FmWRCSZmXGjx1x/KO3XVf9NR28iwYhTw+
	cZO9XIJpXN1WOEZJbBb27/EexkcGZvYM07vbjrfzAdK5J6FZpZ4YJcMRiRdE7MaSc62+/y
	Ol3TarJiIn3PKRWZReli83PpDkS1AmM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tauXva5N;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790419876;
	b=3gZOl9qTVMjiWNF2Dzdod3YKon46S7DTKdcN3yClKYBlLri3nUBA12ZcXccY1LqCWbubr6
	orcu6zEdIvskwWPUEargo2PRzbWYvlFg9b65cBKRyHjvvi/PyrrzAcUGdYkikddjth1OPL
	KZgOXu6odL6mxdL9UFfkqmGbzD4eZWk=
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-530d0d5ae11so19630001cf.0
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 03:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790419875; x=1791024675; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=reM3bvpTAJ659qLf9u3c5WYxIz1dkkiHph331s5crXk=;
        b=tauXva5Ni5HTSywqYyxqk5QcS8b4bYmf4azcKCO2T6HkTPKeyVH6u+ySf2MXemLj25
         TojKY5LzW4BAlrlRS57ne92K6tUOuHj6vC+uKDLpFihp34PCX23NivbSL5FmmZupaVW9
         RgwY/mvgu/faYCCcRd4vGA6ac84pJZipDI2rmFHeGrR5e40WF07AMKHvZqAf3moqBHmt
         KZZbptQ+HFPqMRv8iG95+W1hLoSWAO8tjMX/C2C5R6PGDBoPEUu0X7D9UckWj+7VCi0j
         r3qmIAq49vXKqwJEU2U26vJRHw5nejaDQ3lCmW5Ce2JKuzstMURuRhwaoOFwiyKM2ni0
         4idw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790419875; x=1791024675;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=reM3bvpTAJ659qLf9u3c5WYxIz1dkkiHph331s5crXk=;
        b=xZmOUZCIjuijpsDoNB03dUgbCXjtETYGaRTQlNGT2q0YllMz3t1dNX01qKHZmzb0BT
         gRhnv9W91SDMpv/UxTZ8p9vK+vUgxHRtug0UEflQhbFjyp9/y8lJS8JG5GPIOkKDWuHR
         ol9lw4slR5tC8/agP7L0VtScl+mKbx5LfE9GzFyhlCs1KqGet2ZQv7GrdAFW7qpxTK1R
         TCwXK/T+U9a6Cwt6OrXBz3uao3fbtT1N3cr3x+dI0VlVEGPok9OUUkTxyV6odT3qeCYN
         TNgSpHWRKIw6pcZ9CBY77jHzu0UMgE+ZNzSekDzPYNAjueXefp1fPzoOyUm2OOUpj0eC
         bvRw==
X-Gm-Message-State: AFuF++k1tj5L9Gi0Xs0imy5CZCbla41yrSO3MgdXyuQ8ZtLGub0mFCOJ
	fVx14lk3l1PWJMdCi0zB9OnvDacX6t8eUtbqDAJP2ExRAg4wuNDLDqunw7O2SnKoTjob6HCJJgY
	k2pXS+l8=
X-Gm-Gg: AYBFou0RoPvfxded9NGgsjDsnti1CLLZjSIhrxb8SLJJIupgLHNujRq7And3qCOMcH1
	+ZDGdprByAaRdYrvk8Z7nn+LCeyjoHKJ3S2BQnVAWG58Rf7STF4IM4Hz32cxpUwmy2zXka54iXV
	pLVVkCYO/3cWIf/8scfVL3pK8yF90ncrk0RdguCR2c/zEalMPGexGk4oM6+HH3AQ4CodLJBaTjZ
	ZpmzzUAh8hj21QB4PJY5Zxp7SU5hZIMHa+6baxHeGrwIpqYbM2p8dWHKMoYbrtueiZVDejcdR1W
	YZ4gpaBkPHWn2FQTqo8fwyyivTeb42QgUIIv2zLwjOjKTAXSAnvgh0rMxm9oj5D2k9ul6e7uUPP
	a/xRvQIKdWOBxLTq6xFoJe3MVilfu0GT+X1fK4Drce9QGNDKTNg0+45E79zxkKx9MYhsWEOnXWT
	PboaM6CsyhP9zm1ScAXA7eLqXck+22PDAGMMn/K6oqoe39aBj9CX816o6rCh8PQB5UpLhU8/On0
	aHMu2qLRN/M0UoKXYfYX7rAuvytVOxRm4sn24tJk2lK+8qKqGIJu+rRkalx
X-Received: by 2002:a05:622a:4c89:b0:51a:896c:9aae with SMTP id d75a77b69052e-5330b58ea31mr96997851cf.13.1790419875616;
        Sat, 26 Sep 2026 03:51:15 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53322422063sm15060361cf.28.2026.09.26.03.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 03:51:14 -0700 (PDT)
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
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	peterx@redhat.com,
	jgg@ziepe.ca,
	sashiko-bot <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v3 1/2] mm/mempolicy: use vm_normal_folio_pmd() in queue_folios_pmd()
Date: Sat, 26 Sep 2026 06:51:09 -0400
Message-ID: <20260926105110.2156652-2-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260926105110.2156652-1-gourry@gourry.net>
References: <20260926105110.2156652-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5we8qogf9jiar7h63sczcest1wjbs57p
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6A5411C0005
X-HE-Tag: 1790419876-332660
X-HE-Meta: U2FsdGVkX1/PP22cyEfy4cTsnKYnewt8HQFoF4P4hmr7Lpi0cmGK/oA8t/ITG44r17LBscwqDrORyeKo+v+uSkoS64TZn7jwoDEs79wQ2AO30wbVBr1x7lqpoDddXKtVDwsp1G4t0SH3NiUAlErlHZsb9Yb4zyGcu406bEY0WEwH+0qdDs8LXSYLgo29MCTjXNBiSxn28uJoo88lp3EWhqBokTKMlhxFRoaWMqrtANpZ5B8H+zWK7x+G5yb5UMeKS2wIEENlvD4ozD48YPzqU0xbhcq4Yrw+vnuR0LDQ84XY4ZNpLP/DXXpzB1rxn7iVW5z5rvlKGiNqQDf3dsx7ky//qNW3YJaTSZ9ftGagncrRaraUH1Dd5vkTHMDPPQuymNbRY7dQK6as/CV6iSR1D64O1yl0zV6gBgsLjQ/hU44ZRRN1XIn8yN2RiGb7uSoSBUlDrTsGw6NVc5ZXSIlWiNgyEWZ44PrOL5cmQQbZQpoIbiAa3puc6mWiI6Dr6yJhK8vSO7wIK7GWS7O7kZM1FdUBp5sy2n65H9DLC5iwbyHVFBrmfBqjfXxz9InQxa1AODxPKM2JvHHqiQLtrLhWDGPKhU0YYzF+VFfblC56weIWX+qIv9PCfoaZ0x8NYGk99I0xdSoTORhfDciBI53nVBmpH/A7UdH+04dfky7I2cJlyYIsN1AMMvt9kwn84Mf4AkvYYX+Bn6AYY7A69XxZoOEf0uoFltHHkVBK48wwnFvOosbet0EHp0W/xSr1b3vXk88UJThUaC96TFR7Cf7iNiD+GkJmzBg19ooxzuY6xq03o+PUkrDJUawOiYunKjXbOPf/LqravkRKwGTXU3RnRl7p5X+IXIpSFKxnHAQjkQo8RHfaZqupTmTrWOo2yIyq3zOCDpkI6v7c44GAHyN78gk/qsk68fVVcuPsNCNJLgA42Pqa5zUJTf5JPa2yZ+awMStAShWPvdVw2iueUpD
 P7qB2DJT
 u6I8xqxQVidyGS62Gaz+aaF6G5clMVXDCHneegnu7za4MWwaALL8h38La7MiqLlVgfgoSKiArZTpk9Srx7gxu1IMl+i2+Q//kbXc/x1jTrnCJP5LrGsU/mvfau0h0ucHEkVoFTQ4jKROiLXsPK/5QnsfBX5pNMf7GBr4uWs51fF/nhLgwO6MLzQJgyim19Z7D2uIrxZ6NPkdZB+4pLcmsMhutv2c2wq5O//x1S9PlLFf6GzwnkBPCaTtGgouGq6NX3OO7Zz9GcPzi/XqgjLSpXngsnTK7ZeGwCuXn7G94dRuIDlYJ+CC6A2ox5DKlToxuoMuzcuxTlr5vgXLcR/6eOLtkDm4QEVFBmhX/rS3+fzv5pAoCF1LOa/Zf0daDPV8wAIKLl8kWQ7IoQBWR/GGU+zHqJDsN4mbMcLODXyl4wAFAonMQ6WGhG2OkxIgSxnB5J5jm7fa/R3Fdknzmlb7JCpr+2ZgyIsEYKRHugHyfboUXG6vfbmo3IIvIfFYtWD7uyO0H4UBgjvOr58LnaHS+GmVEnw==
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
queue_folios_pte_range() already does with vm_normal_folio().  This also
filters the huge zero PMD, so its separate check is no longer needed.

mbind(MPOL_MF_STRICT) over a PMD mapped VM_PFNMAP region now returns 0
rather than -EIO.  The PTE loop already returned 0 there.

Fixes: 3c8e44c9b369 ("mm: mark special bits for huge pfn mappings when inject")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260817220810.1175596-1-gourry%40gourry.net
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
---
 mm/mempolicy.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 2063ab7577d7..40744658483b 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -667,7 +667,8 @@ static inline bool queue_folio_required(struct folio *folio,
 	return node_isset(nid, *qp->nmask) == !(flags & MPOL_MF_INVERT);
 }
 
-static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
+static void queue_folios_pmd(pmd_t *pmd, unsigned long addr,
+		struct mm_walk *walk)
 {
 	struct folio *folio;
 	struct queue_pages *qp = walk->private;
@@ -678,13 +679,9 @@ static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
 			qp->nr_failed++;
 		return;
 	}
-	folio = pmd_folio(pmdval);
-	if (folio_is_zone_device(folio))
+	folio = vm_normal_folio_pmd(walk->vma, addr, pmdval);
+	if (!folio || folio_is_zone_device(folio))
 		return;
-	if (is_huge_zero_folio(folio)) {
-		walk->action = ACTION_CONTINUE;
-		return;
-	}
 	if (!queue_folio_required(folio, qp))
 		return;
 	if (!(qp->flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) ||
@@ -717,7 +714,7 @@ static int queue_folios_pte_range(pmd_t *pmd, unsigned long addr,
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (ptl) {
-		queue_folios_pmd(pmd, walk);
+		queue_folios_pmd(pmd, addr, walk);
 		spin_unlock(ptl);
 		goto out;
 	}
-- 
2.55.0


