Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B91ABC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 11:43:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A2CD6B00BC; Fri,  3 Jul 2026 07:43:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 979B66B00BD; Fri,  3 Jul 2026 07:43:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7756B00BE; Fri,  3 Jul 2026 07:43:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5FA096B00BC
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 07:43:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C22481C37F9
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:43:16 +0000 (UTC)
X-FDA: 84947279592.22.D1101EF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 302931C000A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:43:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=frv6OjcR;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783078995;
	b=FMSEu8QbKsNtV8elnq8LZg1Ai1IXlkpYGKuIWe3thEGhK65bTexfNkDFUYSN4WEZF7moyu
	gVxsGYgbDCamG2gyypv44RqF+MYA5JixxMV9IEmN9cl2prWRt85IGLcn+XFL5NnyhuRHBw
	owGNQaK2hp+2DJ17Vq7iIxLNZT5pvE4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783078995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kETVRXOfDZHqUOgqbdTLgZz+ohdBy7lxZEmFyArpnPQ=;
	b=wD5u9co1p4hD/Pc+8V/zFiJWp7/5ErbfLvkLJxIluiACXNCq30iIRn07Mdd0Xofi3XZ1i6
	oY2+iCgpYr2aca/hfbV4UjgOVTxTVZTkWRPzVY2PwYlcPeXppeMATidhG8MJTVbKu7NdFh
	8xRvBUbTGxNPsfoKH4AbBA/jigh4fuc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=frv6OjcR;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD0364633;
	Fri,  3 Jul 2026 04:43:09 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AECA53F673;
	Fri,  3 Jul 2026 04:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783078994; bh=wiwVsHpgxADZ6sgHPhYudBvvewn5Ey8PcYOiNNo5dWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=frv6OjcRCp9RNieuUFr+tvxMitLV6jdeMCkuHQGfqfM/+/tgqPv3jYVVISUQMA8qP
	 QWTWm1P2tqS2zsuDuWVg1Cv+sh3g6s/501G07N5KGlOjHdJ2ghk5+91Ajplm2wsmzx
	 Kbug0ZTaeOhhx3auUe59py5N0eRGzI2PqokQI+RQ=
From: Dev Jain <dev.jain@arm.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	david@kernel.org,
	liam@infradead.org
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	kas@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	apopple@nvidia.com,
	rcampbell@nvidia.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	ak@linux.intel.com,
	nao.horiguchi@gmail.com,
	mel@csn.ul.ie,
	j-nomura@ce.jp.nec.com,
	pfalcato@suse.de,
	tglx@kernel.org,
	dave.hansen@intel.com,
	jpoimboe@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH v3 5/6] mm/page_vma_mapped: use huge_ptep_get() for hugetlb
Date: Fri,  3 Jul 2026 11:41:58 +0000
Message-ID: <20260703114202.365553-6-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260703114202.365553-1-dev.jain@arm.com>
References: <20260703114202.365553-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 302931C000A
X-Rspam-User: 
X-Stat-Signature: psz5gwr1kinnhunja4phi5tgymk77w1z
X-HE-Tag: 1783078995-429119
X-HE-Meta: U2FsdGVkX194+xF4LQQFbtOu6EJpFQwnEfRL5jBrfLK72xRRTsYQ90AWV0uNtslZpDh1oYNxe+shpqhNo0n//g3o9DoSWFIdwJiWJ/mjWRR7DrCr3AOD7SoH/x5hnrMydN4nPJFS1TDj/k+BQ8m/A8/8/EuKFuVuvb1rYBE+sUELeZZnhaENW4MH6LYHGPMhgvzU4q2yvTb+FPc0QTPUa/iQrKn2Ck5MCWO4eHfb0Hy8TQvm3wc9cPmddHvAypN+yp+lJKNNwgNxn7lImBZO+Uk+YtFg6N0iG6e/qsYNfIeWm4UsXsKwgEcaGelqdmN1Zf7DNam1DOGnFtBIChyuTqQN6+JbmOIIoet6ae5bw0/uhG6vIWhQ8ScSMtpb1Ad3JqPfO7Dyo8+d+iCO+1b9gf4fyi3lJkHTzKdqpffgRQnFNnHC+xRU/SkCCtxCtSdccCq0keyG+/zOnRCaQw+wmG/8qlD6SsCN6kAYm4vbE2gOaCHX/waNq3NJxubyX4bezoRzALyEaVoqptrdLahVF2pyQbpKwaZEuD0NwTqaPbhfCgiFom2yIytl52t6JT0bV3eA8kyIbvsAm0Hasancp2IPCAclb6p+0IWoZo2zwPzB9LbnO/RU2oGn6lflJXZAisWdWtzoJJ7kDM6xhsih89XpQlT8qGhLKOXCooAFX2Ww0/eOyQ/PwoOQdA8y1u1Q7OaWz63Pxyrv+++prUSQtagAYLYOPx6cwjNgg0iS/+ljce9wB4IQmH++BtL+pV+/WmsF6eWVphYQoJbvJimceTrNHILctk2MuImcn4Ea3oNhIaCwFvlg/5MEBHZfJwgCA2nfhYDIn3pUmrCZV2ZR4iMeVn/GDiA8YlVH2xfvnP4Pu1NsjQMHZ6a+FYno6zNTtsVL9b37uIL5N7D/QTTjOhJR6YRczfTtMfNjlFzy7K/N+BaLvn+E0yZqxgjuGzx3kPg2J4EABYBeowDj42m
 WwHjYN1m
 Z3Lr/3nQRiOf4lElU63NbijoLorvy9MhngX4SfLEiKZZkAB/ayudUx5dn1ukai/PcIq/2oO71BE8xiacSjFRhUATyC1UTSWCZVG/gQjteLwqdnb0KGxCYuakAL9aWLa3gHzv192hrlWoVZ/S/vnPb+4njjxkJwmFChvOgXmtC2I2NsBlDjVrdfBHvxgaCrYAh1A/boDgFT/AqAoB1Kr8URlPxaYi2UkfPvwTsGyPUTQ2Q86tp1auFxhMviDNHiWMUXbA+ci5PRpQdyWIViMFFHw9DyjmPSSQq444VbpuUNqPk9PKv7shut5RiLD3rve3iz6CyjM6JKFwxd8uLQy2ypTy7JwFgfcbs+eu8V75Vl+RnxpvaqRNTynyg8kuk3bDPNqWxjcgZb2+r3Kw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

check_pte() is the final validation step in page_vma_mapped_walk().
It reads pvmw->pte with ptep_get() to decide whether the entry maps
the PFN range being walked. For hugetlb VMAs, that pointer refers
to a hugetlb entry.

On arches which provide their own huge_ptep_get() to dereference a huge
pte pointer, accessing via ptep_get() would cause pte_pfn(),
pte_present() etc to misbehave.

It is not clear whether this has a trivially visible effect to userspace.

Use huge_ptep_get() to dereference a huge pte pointer.

Fixes: ace71a19cec5 ("mm: introduce page_vma_mapped_walk()")
Cc: stable@vger.kernel.org
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/page_vma_mapped.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 2ccbabfb2cc17..18e1d341f463c 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -107,7 +107,13 @@ static bool map_pte(struct page_vma_mapped_walk *pvmw, pmd_t *pmdvalp,
 static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
 {
 	unsigned long pfn;
-	pte_t ptent = ptep_get(pvmw->pte);
+	pte_t ptent;
+
+	if (is_vm_hugetlb_page(pvmw->vma))
+		ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
+				      pvmw->pte);
+	else
+		ptent = ptep_get(pvmw->pte);
 
 	if (pvmw->flags & PVMW_MIGRATION) {
 		const softleaf_t entry = softleaf_from_pte(ptent);
-- 
2.43.0


