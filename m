Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAD05CC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 16:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D53B86B008A; Thu, 15 Oct 2026 12:07:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDDBB6B0095; Thu, 15 Oct 2026 12:07:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA5546B0096; Thu, 15 Oct 2026 12:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 945C96B008A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:07:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 25192A8821
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:07:44 +0000 (UTC)
X-FDA: 85325341248.20.6817120
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5852C140005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:07:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DxcQo8mE;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792080462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sxQdEIHHQczO8FrqgYpZ12aLH3TYfe0Zx2M3uMQqQ28=;
	b=pb2fnGGt1lnp8m5M1Ik4frB1jOUd1Iae+B3+UDUvDyEucz78HwojGC2lnHKv2cDPyGLy6M
	qzGAfStd28j9SJzTT8GSpur0EbicF91YSWcV0n/QtKxZKLwsEvNEvk7d04DHZROuAzStDu
	iIKyxZQ+SVKDfCs9ymwYoD2DrJ9S7MQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792080462;
	b=APfiTvU05BSj4c/x1NKfq7gT4NTwoMo92v+VUHDIVMboV+9Vst5IV9nTfi2oI0iKJsU3Pe
	Pz0cUgDupaDQCL8x4CniQft43i2FlYFoHd258HLIrOg8BYALlADcY4BhpujZNQlqDbdI6W
	6VlU/zJ+0zeYDtvLRdIGMZPSCBC9SRg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DxcQo8mE;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D187437EB;
	Thu, 15 Oct 2026 16:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B271F000C6;
	Thu, 15 Oct 2026 16:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792080461;
	bh=sxQdEIHHQczO8FrqgYpZ12aLH3TYfe0Zx2M3uMQqQ28=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DxcQo8mEM+dyXRPVyXdvrAZHITYnPqATklWnP6c59RjxxpgAJdcqsEUGv6vSESwuo
	 eB9X1OXRRgFh33CpYLk7UAJvucKXNiBOU3KoHPXbngY0/RxAYO/wCI8gTS8PWD6/Gl
	 Tm9e0MhdEORTNg42IQUZJ4XIqn4Q3uVIni4Nz9PQ0iXrDo02th0CuF74ZJN9sajcQu
	 V3CK+tIUf/ZwqXsbvaBcjAcI8oupGumCCFqOh7f05ozc+Z6DhDI4/WYfqo2otdZoST
	 xv1BcXxPfntQ0o4QPK+3KYFU/HycxYTVTgwi0RZcp6KxhVQBIO8Ad4GCIrR1ZAifnh
	 lb6XfpoIUL/9A==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 15 Oct 2026 18:07:09 +0200
Subject: [PATCH 03/10] mm/hugetlb: fix use-after-free in
 hugetlb_mfill_atomic_pte()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-urgent_fixes-v1-3-42796911043b@kernel.org>
References: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
In-Reply-To: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Adam Litke <agl@us.ibm.com>, 
 Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@surriel.com>, 
 Peter Xu <peterx@redhat.com>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1279; i=david@kernel.org;
 h=from:subject:message-id; bh=Hw68Xl0G1E+o58UO13jm0l+jupYSoJKy2G+eUgleY7o=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIu/DJ+9yLJdP5cZrYNExY1eXS39HxtTig98JP114lf2
 /w53H53dZSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjCR4+KMDHMk9zFM7L1bMGV3
 0LszuusCAo0a7r1esybkwsMjsu/mfg1mZNjnuv3dokxf6SsGdczXQk0m6JwP2nh3BvtZtmdiMWv
 /7mMHAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5852C140005
X-Stat-Signature: fzr9jijcfj33g1piehso11u5bjz48n4c
X-HE-Tag: 1792080462-922297
X-HE-Meta: U2FsdGVkX19ltvYQ6AmcwFmg03yA5ipTEa8i6dpq4j7AvhaXwHH+dWM3l0fnIqA2fL1AdNwTNG9JGnyR8lNamse1WL/03c9TrblZcmPAxZbhEePGfpOfYZwWkM2v+O7VPyb0naZoEAocZTwkni/7GMtVarHnupe7bUhtTPwx0qZkKGdQQlY6xqzNpMsfpR8KGmfmwRfKAcqcGk0y4bhqT9bJvdwiTaxjmKHyfRT1vgyuGgkOvV4gCUOVRW/E3EobOsKYbcpttdP4Z+JveICrP6WalmUOOfdJbLdBo0gpPQpydrfCi53kc8a9Hdp/gqh2rFbUtb8zNsGC5Mqw9Z4WrRSv9ktXb/k+BmLtlnNpWDHsu5DXzGB1MskPUojuUPjbVtxVzPHastmip/2I/uQbuWFqqzRTeYGd/G9pfOcIans0zjrcNjqJNQgFIRqlACu/2Yb4vGq6mxGc1Dwc2kPhyWrltnpXkYPo5H1VFAYHrwzOAxHEEaL8NUgtzDd4E0Z46acmgk4tL1Y3gNFNEhdWlGuEb/GOf+G4lEP+O8v2DC0fpzyXVuApmc+SvO8wq5PHblxKqCMcg5XZGzm4ZVVSj8mN0bRTe6D3TIetRO1MI2eA2A5urXsT4lv1c/U+zC/aVVv1Xoep2oxhi7LifpWgcNmhusI+hl1zW/reB97mgO8UU+hmfXvinMAPiVEibZdcG7q1KgA3KKhG5wsX+YqzztE507Spb1g/Js+mZmqxSDkd37luo2lWCT+XI6L0u/HzCK2XaRKg5SwrRWIwkoBY8qL9iCC63//Fh5wrG7+YCTn/+g2Cu8NwixhkSbHUMRJTrYVJpGYsM1olscBQ4sCnm8hBgBkghKLkJG/HLK3bk1tNdSJxQjNvwo0A5Z3LAdLWFxqKjEzPGbZVvOg7PXHA0f6ejQR8wf8YOGpAteI3hPlZbGj4Rcrcmb6Kygj4BMXOyD65Uk6oGIzHi9LedDe
 oWy9qCza
 l+PondCf5kzl4HFo1Gp0NjPVGmaFXOxENbjifOFXq59LFtAenyzjRjQB2ZEaA2R97VugNCcRAZPHDvQ0MiX+i/w37RTPdMH99cNJnaCppvhtIKLzjHQR1FkP6ZKA1nngY7CFtagUYd9e1Q1XvYWzJUZ3INsq/AiEM/PoO9wd95TduwehHOQhgk63X80BYON+aqbEI8plaMC0AzDu9bqPIC9d/XAPePfWj16uc5TonqGo/cfsPtSx9dvspAQMRug+g/I2nDluUEibPxbly7y1l+ImHKQowNhsWlnpv5aKsg7LHpB6ePXDBCtmUc731cXEKqkyOB/r9UTyWXEbjKcXjc0MKq535MH2I6PBBtvr4ug3ue9hFcMGRaeKmBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's fix another instance where we use a folio after dropping the PTL,
where someone else could e.g., MADV_DONTNEED it once we drop the PTL,
making us trigger a use-after-free on the folio.

Fixes: cb6acd01e2e4 ("hugetlbfs: fix races and page leaks during migration")
Fixes: 1c9e8def43a3 ("userfaultfd: hugetlbfs: add UFFDIO_COPY support for shared mappings")
Cc: stable@vger.kernel.org
Reported-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ce9e87228ec62..86928d76ef12d 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6478,11 +6478,16 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 	/* No need to invalidate - it was non-present before */
 	update_mmu_cache(dst_vma, dst_addr, dst_pte);
 
-	spin_unlock(ptl);
 	if (!is_continue)
 		folio_set_hugetlb_migratable(folio);
 	if (vm_shared || is_continue)
 		folio_unlock(folio);
+
+	/*
+	 * Hold the PTL until we're done with the folio: the page table owns the
+	 * folio reference now.
+	 */
+	spin_unlock(ptl);
 	ret = 0;
 out:
 	return ret;

-- 
2.43.0


