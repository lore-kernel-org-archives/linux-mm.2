Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E4D9CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 11:42:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E79B98E001A; Thu, 23 Oct 2025 07:42:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8D558E0002; Thu, 23 Oct 2025 07:42:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE0388E0019; Thu, 23 Oct 2025 07:42:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A2368E0019
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:42:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 56B5A1A0AFA
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:42:47 +0000 (UTC)
X-FDA: 84029191974.04.7505E2D
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id A43FA140011
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:42:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761219765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RIurXfUJfV6435wKRcX4TA0Lnr5XdEl2aKx/+Ksphrs=;
	b=sB0hWQHBNbsxKiLlScnj38t0t/qio+zqrPRXYxSCPGSwe66yKuG+xAQR35blg588SKN/0T
	R4/9pQg5iNYWISoWVZ7iMJWicaK7Rr3OS9s/jPiW4IVymBVKcB4EXrBLdZkW6DCtYSwRnG
	04lo+7cfAa5J+nyNGi0AlLvNpjqqDgw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761219765; a=rsa-sha256;
	cv=none;
	b=0W6j+SNKi6+ZqH3EZdoHorzLH3z7YbUQOm9M/pdg83L6RGG6GAukUnCDAogZEN2QpQRAvC
	vVxljpz740lOZIKF/o2ui3MrsgBHHYF74VgaTT9T0aP7pkUaFBnnhBuJ1CyJRzq8tQqsZu
	ny5empsodqf3AFtDfln/sqeKv3QJplQ=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4cskhB4Tsfz11SYw;
	Thu, 23 Oct 2025 19:43:54 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 650141401F1;
	Thu, 23 Oct 2025 19:42:38 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 23 Oct 2025 19:42:37 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	<linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: [PATCH v5 4/4] mm: huge_memory: use folio_can_map_prot_numa() for pmd folio
Date: Thu, 23 Oct 2025 19:37:37 +0800
Message-ID: <20251023113737.3572790-5-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251023113737.3572790-1-wangkefeng.wang@huawei.com>
References: <20251023113737.3572790-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A43FA140011
X-Stat-Signature: fc47g7qdf57ssi8r4cnq49jzyfexpwhw
X-Rspam-User: 
X-HE-Tag: 1761219764-614005
X-HE-Meta: U2FsdGVkX19N49WarkbePUlXO5Vvs/MhDkTIIE9CtOWXYt90QxO2RcpDAh8oauKsqh4v+NzFx67FykgsaainGl87NZQRZs10Do95A7cAQ6bbws6I/otNzkCa9SlCptKOdoSVQya4N3IgIcJa7Ohc08hmucriDXWwxNGbvQr1h7shG6gpMkWe2u4UwFv5UKnNmJGaaDgsXxJA/O4PzU3thkDAbzXv1noUFTN0SoBJMB+KZcErEocP6UxCrSrcyP1x/Re7GTtuPPooCTMjTKIxnyLt9skeAgxUCyJC0wPHd7qq5XTPj0N8dQgvnseMlI3Gj0ov9/Rr28Vd1YcqvPpd4N6c2fulynmI3R8J4g1kGU1R3T1EVeqs2RjAW1s732zHyOg7VPCATvdhi5EpqYMY30kmKDQAy1fmVuw1DGJw0fZj2M6GAlNf2UmLPGs3sek91xUlcNcxI5DQuUGOaabVUckY49MjaH1hme8fO4U5/rODP10lS+/UAFTV1BY/0ZglHo8sAGGAPPISYFVoSvdUEWOXILm9fxgYUju8r8IcSr5QmPHs1TPDCOyYPfB6NmhcuU7pS9Tpza7RsnN/AjsyiyT84l/pKf28Wqu3hUBCntCtwewCCeMtMuuONDO0WM6Osx2AbYU6LGf+1eSezO07FvRk23AK5mOb0dBMhdgNd/WKA8hqO1ATRoXXUJsja1mg0iUUgzS3eyV8mmO9GKrUN2MEyUx6y6NzK1XwyccCsZL3ZwEi1VCj8rpb7pOv+vKJDL+GHMizwXbDLJlnaD/nXKJhUdwd8UcYka2sUXhvIklkDnKU9gnnGOJ0pR3U0HhJHMrYF0FukTFVoUAhPDgIbVVpnVuc4Z8c/lHjLc517AixQ297rbcjq03qkW4r04qX2mtZ6fpdxWWjzSiko0wzYUD4+7ATFcYJz6wLvuPyo7KPt+7xVVgAD09+YFx4E8P+bOzIBR6aZDBqiPBb8Po
 NABwOIaa
 AfiPUaSH1at6NZ0P/t/SfHa2Twe6N+O+rGYmvKx/lEYk70xdks/hg1O3kyZLj9HA7O8wfRzGFoikY60jkPXuKdhvEpyrvSXuQwIvw+LOHLKedwG/nJwu1sSCnfOLRwLwnMs6DuHyKUfsvwIzaj8Dkmvne6H7JM0fzbHHnSQOloynBGFPpzeXhDTAaolyNc4ckB0ZkCwwhd+EMvtCZ72BPsQ3UTJwwDgqaflBLzpp6LHfQXAKi61+WxFQ36A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The folio_can_map_prot_numa() checks whether the folio can map prot
numa, which skips unsuitable folio, i.e. zone device, shared folios
(KSM, CoW), non-movable dma pinned, dirty file folio and folios that
already have the expected node affinity. Although the ksm only applies
to small folios, an extra test was added for large folios, but the
other policies should be applied to pmd folio, which helps to avoid
unnecessary pmd change and folio migration attempts.

Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/huge_memory.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2764613a9b3d..eda9316f71b3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2477,8 +2477,7 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 #endif
 
 	if (prot_numa) {
-		struct folio *folio;
-		bool toptier;
+
 		/*
 		 * Avoid trapping faults against the zero page. The read-only
 		 * data is likely to be read-cached on the local CPU and
@@ -2490,19 +2489,9 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		if (pmd_protnone(*pmd))
 			goto unlock;
 
-		folio = pmd_folio(*pmd);
-		toptier = node_is_toptier(folio_nid(folio));
-		/*
-		 * Skip scanning top tier node if normal numa
-		 * balancing is disabled
-		 */
-		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
-		    toptier)
+		if (!folio_can_map_prot_numa(pmd_folio(*pmd), vma,
+					     vma_is_single_threaded_private(vma)))
 			goto unlock;
-
-		if (folio_use_access_time(folio))
-			folio_xchg_access_time(folio,
-					       jiffies_to_msecs(jiffies));
 	}
 	/*
 	 * In case prot_numa, we are under mmap_read_lock(mm). It's critical
-- 
2.27.0


