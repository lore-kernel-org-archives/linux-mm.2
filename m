Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A2E41090223
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 13:00:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D81EF6B04BA; Thu, 19 Mar 2026 09:00:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5B136B04BC; Thu, 19 Mar 2026 09:00:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C96196B04BD; Thu, 19 Mar 2026 09:00:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B74AC6B04BA
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:00:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7F4D21A04E5
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:00:48 +0000 (UTC)
X-FDA: 84562822176.21.2D1646C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id A7E2420013
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:00:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OA9gxtDY;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773925246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GTrq3nvyzbNtPUQROwrYGopVFAaxZGtsWbKSU+liMKc=;
	b=qbkMxiHKj9ieht6RPYhYd0SL7nr4YQbkLTjsPMw5hA4oR3H6YH2/v2Fd7MbeeU13ZOzd3k
	QgXEI7buKgxTWJfCHKOkqlLZYg9W0UOOsDPwLpjYhf4EedlrGzsHpMxo00M5u9b1x1TLOL
	m4WWQ4yMyePvUMTri9Xw3Z8TkJoZEgw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OA9gxtDY;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773925246; a=rsa-sha256;
	cv=none;
	b=AiqG+b1iB6NWE06oNFkuqHwEXxWw44ZykRFvbYp552XzTIY+oe5OlDnQXguzcOHOO7t/Ja
	7J1qJIBOEMEARxqmdbEtAN0aXqOwNKDkypR1XqaP78LO8MbamYbEfXggiQ7WoCdcthLnyA
	ejneSpP92ZfAkNrjUS1IKbKcSvkCyLA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D25A9436A3;
	Thu, 19 Mar 2026 13:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9DAC2BC9E;
	Thu, 19 Mar 2026 13:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773925245;
	bh=9GL71TGtr4Xl48AxLVp+Sw8hVkXKWEDVrPJDeJyAQmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OA9gxtDYCARiW/xFj3Sq62/bn+4nR4RBKTIioCsZQ28gTNNA9AcNWYSFoBaWEpGas
	 LddWivmQh6y897zbvCavLhQY8U+wF9VqufAyVfsIP/KcCpP43VuFcu27fwppyYMCRq
	 ZmpwL6pd5CoX+a6a/TfzSb9tBw6ND/qHm2ufVxR+5H6hAtMLSvB7BKQSb7tGtPRsYz
	 UHA9O3fRmq76zqwEex9NpH2fefSW0+bYKjCNzvxYbanyFd4ankQcsFD4fPts6tIUW2
	 uJMQWIrTHVw33/FrL+K6yWQWUyu+e10K9vnX0fXZwvXoBwZz97LTIsVJvBrfYJMLQS
	 bM5OYt36Az/9A==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 9/9] mm/huge_memory: have zap_huge_pmd() use vm_normal_folio_pmd()
Date: Thu, 19 Mar 2026 13:00:15 +0000
Message-ID: <d2bfe24c36ab1cc28f3dd6bea2835fd895c1ae4e.1773924928.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773924928.git.ljs@kernel.org>
References: <cover.1773924928.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A7E2420013
X-Rspamd-Server: rspam08
X-Stat-Signature: r5h1z1oxeiwc4grugx1kfztgzi6cz53t
X-HE-Tag: 1773925246-707986
X-HE-Meta: U2FsdGVkX1+GtfApJNiQj1w2rQobciRh0Y4+uOOCxzKrJ90zjO1Dcy1YbQzyEEntfEbdUU8VDkToE266/lfxlidjnOIxikc50pQ+lIK+f/eBD+nsBTmzHjizUN3UNR4tn882Qo+l2jEigbhuIvs6In7UY5sapgMPTnc1nWbzOA1PVIraWU4KmgA8gsLgum6nJ23JGK8TgY1ZxOt7NBzbn7UN8xxdRVr0iBrydhozRTM2xW2Uk4F/ncoEfSOipaTEorSeaswvRbnLTwV4lqscKS2bv2rR/reVwv/ORTzUHE04TZKStJVqhnX9Zqf+QIHmCV0DbWJ/Y2++E7ocQQy8WDRw6Mr3AOM/UxxjljSSsf694273onO2wondPyITaFxSwFjo3e74yuhcPU2c0btCWTNh9zVCZ/nkRp0ttRcavss5PZQzVI9NvJ9EobnMVcR9Bb7pqbchsp1Qnf+/TS11pX0HIgBaDlIAiGRTf3S7AqhmQUCWpVHA/Yd/ZfVt4PbZVz/PIDIsuxtfJn2WEHQyYxaNp9jOVAQcBO5TQ99OHJsoKUREWx3XSV7MyaN264eVJvx2OngOBMyN3FDzlvIry/hW3NE7vcg30ZETqvOGQY/t37laH9BoxYXEOcEES7si4IGXIfjCVjNWSc4qaYdu2lzv45oodomwP/KUvfngNaTfxJZPcFvU/8jfzJqBtipycvUzEKuzzFLa/iwKspXM9ZBwJKc8lZut7RWxNWhaWiYR+k8mzXGAEzC1dwV3ASCQn8wMsAh/kWzzFW1+EHWBYVVZ6T3eLPijei3lUppNVHVYFE5JVm6fGGvHLelExmTa90J6C9g1Pv0kmYkTUAYw15FueswH7huBBmPy2a97ulXwt2H2bF+4MacWDTtQ2XyVfG4v+T+WESyYrCQp3hJx3qXy8OgJhm4iasf/sn+V7eyOjKVsHP7zIqi3p8f48dQyXJ1fu0fCqkf20F4HTzF
 8uW5S9KT
 WF/fYqaMubgTmeqfaXgEbKEMnXYme2fAOQtEPylmaMY0Q/dt8ZemOZrzCoC7+QdElAhsOP8LafXuzNMW2tkBl5ponL+LytJ/nQfYD9LLdSDpfSH6apl8ViOYqFKHzl3C2ujzamEYTbSwTCtAGUtXIJ87TwhTKS5q6rjxSGhqD+dH9Y5zwgmT+VBjryI8MVf8vYhLCmDuN5rZxzdB6v9YP4jwqvshzmKf2X/Sb0cZwiE+rUo5nOJBM549EH6sQD/yeyrMPpHJGyB5ATv2bKwMzjI/tDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rather than having special handling for the 'special huge' and huge zero
pages, have vm_normal_folio_pmd() figure this out for us, and use the
presence of a folio to determine whether to exit early.

We can therefore delete code, move the 'present or not' logic up and make
things clearer this way.

Suggested-by: David Hildenbrand (ARM) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 22715027e56c..5ffe3334c80d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2431,9 +2431,9 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
 	bool needs_remove_rmap = false;
-	struct folio *folio = NULL;
 	bool needs_deposit = false;
 	bool is_present = false;
+	struct folio *folio;
 	spinlock_t *ptl;
 	pmd_t orig_pmd;
 
@@ -2453,28 +2453,26 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 	arch_check_zapped_pmd(vma, orig_pmd);
 	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
-	if (vma_is_special_huge(vma))
-		goto out;
-	if (is_huge_zero_pmd(orig_pmd)) {
-		needs_deposit = !vma_is_dax(vma);
-		goto out;
-	}
 
-	is_present = pmd_present(orig_pmd);
-	if (is_present) {
-		folio = pmd_folio(orig_pmd);
-		needs_remove_rmap = true;
+	if (pmd_present(orig_pmd)) {
+		folio = vm_normal_folio_pmd(vma, addr, orig_pmd);
+		if (folio) {
+			needs_remove_rmap = true;
+			is_present = true;
+		} else if (is_huge_zero_pmd(orig_pmd)) {
+			needs_deposit = !vma_is_dax(vma);
+		}
 	} else if (pmd_is_valid_softleaf(orig_pmd)) {
-		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
-
-		folio = softleaf_to_folio(entry);
+		folio = softleaf_to_folio(softleaf_from_pmd(orig_pmd));
 		needs_remove_rmap = folio_is_device_private(folio);
 		if (!thp_migration_supported())
 			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
 	} else {
 		WARN_ON_ONCE(true);
-		goto out;
+		folio = NULL;
 	}
+	if (!folio)
+		goto out;
 
 	if (folio_test_anon(folio)) {
 		needs_deposit = true;
-- 
2.53.0


