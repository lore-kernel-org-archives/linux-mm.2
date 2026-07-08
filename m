Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F00DC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 00:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36C5A6B0088; Tue,  7 Jul 2026 20:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31E7D6B009D; Tue,  7 Jul 2026 20:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2323E6B0096; Tue,  7 Jul 2026 20:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB70A6B0088
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:40:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A5DA4060D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 00:40:17 +0000 (UTC)
X-FDA: 84963752874.26.5B538FE
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8D5DA20006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 00:40:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="1QNtpTQ/";
	spf=pass (imf13.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783471215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Fk3MIUF4Gkn1bddZDU2fyqFtcDmI5XfWkObgOV3oB24=;
	b=nnQIGQxA8dCKlpMXNm+kBufU84bAj+5Kt0U39IwNEwaJA9k4PIodrdTiC/CJBmB0DFNbSF
	NozxMhWYjPH40ow/q6gy84MaFOAuQuBZ7UnLGrh3miX7Q0mnwqnSKZVDJ4Cn/k7TM2Gjvm
	gfMJVkx8XZksAO3uAc7q7GjtcgNe0kw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="1QNtpTQ/";
	spf=pass (imf13.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783471215;
	b=ioQEqp6mkygLB9gZNiYux53INnEdKvIDY1Yd6SPBhsXhEe5MVsJUDIQCjrnLT05pV15VEV
	VpzSQJqQqTk8sOTy1OvEHCXQk3uvEqUJI/UDecVSNe0JNbX54Cwkd63ou+D5VxxTHxr6w7
	Osr0uOPoTjgu9bqaHnJ3I3LfdrYg3J4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Fk3MIUF4Gkn1bddZDU2fyqFtcDmI5XfWkObgOV3oB24=;
	b=1QNtpTQ/NKaR0DmWSQ3Ej99RRFEfxx4IaVhMQuYjlxPjBfGsnZHzQ98hYS/a8HKZ9YVZVjYvY
	YGAVGLDsa7efarxebUpAt/Oey0XrUbniEOXY/npjcqWIlqX4mevMNK+nhWdMqc/2MFgD5dMqhRK
	ampRiTPJRFb3j0/i8gYFq0w=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gvzXX6fllzKmYb;
	Wed,  8 Jul 2026 08:30:52 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 3F23B402AB;
	Wed,  8 Jul 2026 08:40:09 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 8 Jul 2026 08:40:08 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>
CC: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, Joshua
 Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
	<byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
	<ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>,
	<stable@vger.kernel.org>
Subject: [PATCH v2] mm: migrate_device: fix pte_pfn/pte_dirty called on non-present PTE
Date: Wed, 8 Jul 2026 08:39:55 +0800
Message-ID: <20260708003955.4024340-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: 8qizpd7owjbxf9x69ijzddcsq9b1mjq8
X-Rspamd-Queue-Id: 8D5DA20006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783471214-69302
X-HE-Meta: U2FsdGVkX18uUBJs16oEizVebyQ4rh3ivHrBnS08vTq+Bo2DDfszrIPtLaiyuMWs95jPYI8WFAoza7VnzZPy3hsdEQItUVUlqO5av+GXMqHOPgjnSaN0bgY/fa3hSS2SLgOdCXAEa5G65sUYeVqudObcjV774FQC5asK+yAP6ojJDWZluQL7OcOxnIYi/MUuSA8z25NUAalF6PW8PmWBdNJ5MX5qvn8KjBQCR3dMf9QbBbLwc0GKiIeGyG6eJlBf/5kYqnzDFQ3BMcH1etJyCbev9C6wqz/5YZLFOtpkPqQPBkrjJjAsvoE8uL4Njtp1G55eFMxLxa7CY+hzr9zf+qsWuZxi7O3lmgrfAGc/8WhCpxNtzzcmGBz09lYujolWvOM7nBcy0hDiL39GFBplt6SDvzkp/ygcdW5m6Hx3THElzi7YwZM7IqThs6eQjfCVMy5+PEY2zFywJZSS8XOP5g9EVjU0qUTwvCo6uM6SCBKJ8XIIJnUN6nEweH+FLBq7Y58461y08UowGmCmTdHfPe37OGsJiTGONU8QOkMu4THaQ1OWYlL0hHSuRTCieBsTN1DdAII9qqE0xLXfnbocVRMVh+gN+6CnmJEQH6Wx5qZh4kzlSjkWpHlFcctZDGWCZpPytWdz2CbVdVCbCz416s+RcNOfcGtUtGGiSCvIZVXR3boQA5FqjWnXPkq/Qfm/A5QYIG5ovg0hRLfoOGjCHaSYPW91lgCWWMAINTxUIQkju2N37AhQgMW3ADNPAt8qDh+5w//Aoy25ZqWQtiEQJG/bS/jE/ZrEd910fiGFYbT6U8lr7FOMXHPWhteNVRzUJzX0TORm9mqWdjptRRa7bdNdQT1GhXK6pyKKGhymZohf9G3K3B9TkCNwxjnUZekULxEyLPbrfoJMOb8e4QRio9cd2+wH+Sx6dd22MfSdofNq6U8KRPJbsxEHM25AduIGuJUNndM494709O2lJZw
 agRy/Epp
 VwkZuSObwEWetvNSxLZYdpqUfn8CtzQYiZ1GhkJ6NdVT9atFqQMEwUH1zSWRwFx5SU+Tr/v011uglSR1QgHnc52Alo/dTPpQpJaSQXbZodhd88Y7sv3bCcAMRm7XmkLvBpSYRdv/l3s2vL2KfmKBObZ9Vf0mUBwMafjE2fWO0lpelzNGoE1NU/zgceltC/mCXK2I1ipq9L/ip75lyfyHuJytvq7S+MU1b+B0G8bxktLxNwpq4ybM1ec3qxiOfM2UTMszVTdb+jRzxv2lFVtBXaYHN9eVwzGecLTcVjLuJ3ZnB9SpDUExDwdSgKyUPDW53cuqexN8BkTYPi7LX4RuovCI3IzPy6emYvBqQ6jLcoT/9IuOnCLx3SKePAwjqOPXA9xcrBlDD2jg+c0W4R5eVf/3JG/t69cmZR53GgLUEB8B435Ht0RDmn//Z+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pte_pfn() and pte_dirty() have undefined behaviour when called on a
non-present PTE. In migrate_vma_collect_pmd(), these functions may be
invoked on non-present entries (e.g., device-private entries), leading
to potential crashes from pte_pfn() or incorrect dirty folio accounting
from pte_dirty(). Fix both by guarding with pte_present() checks.

Fixes: fd35ca3d12cc ("mm/migrate_device.c: copy pte dirty bit to page")
Fixes: 6c287605fd56 ("mm: remember exclusively mapped anonymous pages with PG_anon_exclusive")
Cc: <stable@vger.kernel.org>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
v2:
- correct changelog and Fixes tags, suggested by David.
- cc stable, suggested by Andrew.

 mm/migrate_device.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 052167f9ad54..6e711381f092 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -411,7 +411,8 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			bool anon_exclusive;
 			pte_t swp_pte;
 
-			flush_cache_page(vma, addr, pte_pfn(pte));
+			if (pte_present(pte))
+				flush_cache_page(vma, addr, pte_pfn(pte));
 			anon_exclusive = folio_test_anon(folio) &&
 					  PageAnonExclusive(page);
 			if (anon_exclusive) {
@@ -432,7 +433,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			migrate->cpages++;
 
 			/* Set the dirty flag on the folio now the pte is gone. */
-			if (pte_dirty(pte))
+			if (pte_present(pte) && pte_dirty(pte))
 				folio_mark_dirty(folio);
 
 			/* Setup special migration page table entry */
-- 
2.27.0


