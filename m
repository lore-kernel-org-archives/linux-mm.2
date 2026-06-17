Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23994CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 08:27:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6E6B6B0005; Wed, 17 Jun 2026 04:27:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3D066B0092; Wed, 17 Jun 2026 04:27:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADEBF6B0095; Wed, 17 Jun 2026 04:27:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 829556B008A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 04:27:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 146F11C1D3A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:27:47 +0000 (UTC)
X-FDA: 84888726174.29.BE885DA
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf11.hostedemail.com (Postfix) with ESMTP id C775E40009
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:27:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=4LrTLi05;
	spf=pass (imf11.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781684865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CV+0FbQGwu1i3oc594LYjq0ExT4bfRNISwi4Pv8B+f4=;
	b=QoeV/eNrEmiz5tGNKetyXCCvXFhr5Qp8tzhpr/CAQKKMzaRDokn1Pnzlaa/QdheKVHXeGK
	z66a4vt1nML4q36RYrBHRiqDGWSoULFy84Ze9UEc29Du/XtkYzG3Elczt+uGR3I0uSAzw/
	6jPmyMihbs0U79n4AK/segZtMv707lo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781684865;
	b=cnKoEcn89teoyAMve4spjLtfa0Ud11AUDjRAsDQCKNFzUe51MNEDRTLx27wkvUX+EZso5e
	7+K2JSXp1WJO/VDrUMAN7Muet83533KXkoMM6B334xX+u8gnV8nNq5UIBP1IRnbu3vo5/d
	KnEjuuQH3PmosRYlYcQOxRp5JuPft5I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=4LrTLi05;
	spf=pass (imf11.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=CV+0FbQGwu1i3oc594LYjq0ExT4bfRNISwi4Pv8B+f4=;
	b=4LrTLi05421WjKcepReyajgJK+i6iF9mvoOc0tM5oGsG1ynqAU/JPUZS0jTxItgK8roz2vTiY
	hobfYeeAjLdCaW5ccZGY4d3lcxyiGzCmvrVZ5TU/CgHIixwj3FncJT35ozQZE/tJ7m4FqU1pMOi
	NHaWXlTua/CNpCAUrjnhA4w=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4ggGxB2T8VzmVjc;
	Wed, 17 Jun 2026 16:19:42 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 1A231405D1;
	Wed, 17 Jun 2026 16:27:42 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 17 Jun 2026 16:27:41 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, "Liam R.
 Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 4/4] mm: migrate_device: use walk_page_range_vma() in migrate_vma_collect()
Date: Wed, 17 Jun 2026 16:26:22 +0800
Message-ID: <20260617082622.3397584-5-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260617082622.3397584-1-wangkefeng.wang@huawei.com>
References: <20260617082622.3397584-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: C775E40009
X-Rspam-User: 
X-Stat-Signature: bsyxbcfmj4z69bexy9f4gpp1penptdqj
X-Rspamd-Server: rspam08
X-HE-Tag: 1781684864-360889
X-HE-Meta: U2FsdGVkX18APn0ZsWtcoMTkS2UKiINyZFdhe/3QTjvjR4+UHo/rzfWPXTUzcHOFrIx68jk0/zNSNVYOJXi6qeKdWI+wKdTVy1Xu19KfrCV6TrDi5InOGoSWN5JJzhrhr/Z73b5JyW7T/2GQvPAfaRVaujbO8yfC7coTbnDK3TXpL9G8Y5Jrqv/zFD8qWRLKjjb632TREBrf6gjdoOW2d5TIuVu9wYaEpLOofYDVq1kTQWv2DMa0B/6Bex6nSMsNcRr47YzfUAyvRU9VPZFGHvEBwReJDyngVm5X6shn5UiHNsDxf46twcHv5OFXx+qjEiS5hY1XdYwgST1L8nj00P+S1mccfGDTuRfM4G8wUcQ2m363XfJRrB46Ct41f4aXMZKgsBvsx9bLc2NVj9ppHvK9UAC/dF3GJMaJeozD3zfl9c9r0zt4P1n8LLJeyBNKvf9cAf/CbutphD2ZVxTVaBs9SvDs5/O3ouJ/kRhsGCheG+2dizrZJAOkcaQe5QcctiFdoejQM4S2I9u3+QfAp0Do4lo92to0s3J2lnhkf7A1m8omFSWFEaof2JbSHqLCZ8Lm8bvNGdLLHpl3iJfqUgiT24sZZZYm+5FJQGsQ/n+bAVmTtGaKRTyR8rwLRFY+9bY+hayc7Z39Hdn2ziFlAS3ni563MWOHlH8reFh3R+slF7rutt8DEH56zxRJxKynTHlKK0YR0eiQ3H0R8PQM98cVb03HsMeHSuIryRcToY74+x0ilRur4WMPsFDTDWYFVeMkdWX3g0RikikUP3gVHn0L7P75+FvHlPchzErk996vRapEN3eiKXH6SdbS/AeCi7hUQ8ZpiiyKwxYl9jem/h47YRQBUH5PY9NvGW0Xh5xOIFPGkm+sHbjsmsvu4+7/scVPMMuqgpstfq5wTTFBkNCNL1zrCNT09oGXdCnCXJPLjzhMeaxU5l63l72DTSBIgpy6ovj24djGsE++V1o
 SVNLL9sZ
 Q+YhvA+Krfl7Uc5B8FiEuXNnCPm1ZsBs/aoXFG86uign0qE1I9Djg+8nN2UfOSAtT68e4bSUQtU8eCZLZRuHPjjyCHTZqw3RNI8ZtM5zchmTHLJecXeGCyVTOL6s8BB3JWcVmx7DYeSfVPmRklWiNgvR8UaIWsVgDBhLG5tVmJDSvTk6rQkKAWh1dT99sKwfpdfu+sXAvPQ4omT1GOo9IPwPe2b40kIWfNoIs1DkcLJJN72ZxkwCaZ+cafCVz8RyqSbmTe/VHxIorux5V0KFyAO812eBJMCI8lI6VXqPjNmRLY/XXlUWvirZJojDTfRr+ri6A4qPjrnpF5wTct6huZk7p/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The migrate_vma_collect() uses walk_page_range() to walk the page
table. Fortunately, migrate_vma_setup() already validates that the
entire range falls within a single VMA.

Since there is no .test_walk in migrate_vma_walk_ops and VM_PFNMAP
VM_PFNMAP has filtered by  migrate_vma_setup(), it's safetly replace
walk_page_range() with walk_page_range_vma() to eliminates an
unnecessary find_vma() lookup.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/migrate_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 554754eb26ff..ae39173d6a0e 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -513,7 +513,7 @@ static void migrate_vma_collect(struct migrate_vma *migrate)
 		migrate->pgmap_owner);
 	mmu_notifier_invalidate_range_start(&range);
 
-	walk_page_range(migrate->vma->vm_mm, migrate->start, migrate->end,
+	walk_page_range_vma(migrate->vma, migrate->start, migrate->end,
 			&migrate_vma_walk_ops, migrate);
 
 	mmu_notifier_invalidate_range_end(&range);
-- 
2.27.0


