Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C2B5D277D0
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 04:21:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 601C76B00AF; Fri,  9 Jan 2026 23:21:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59EC66B00AB; Fri,  9 Jan 2026 23:21:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40EA76B00AF; Fri,  9 Jan 2026 23:21:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 230296B00AD
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 23:21:33 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D34B4C016A
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:21:32 +0000 (UTC)
X-FDA: 84314755224.04.E992C71
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf14.hostedemail.com (Postfix) with ESMTP id 919A7100003
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:21:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=AvPdTXIv;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768018891; a=rsa-sha256;
	cv=none;
	b=H7L5+bIGoc9FhN6Z480L/LmDqYiulYPvGY0Xd5LXA9QRX8d0yhigLp6HmJ/mMMjhZGqzqn
	V8NjAPg43nPruYMVEAwhAPKP7gyRcmTxs4tcDFRdHIMD61UvrSux1cJUVzfb77YPM/YwkL
	luMfwivUSRNgidkyrwOoIxBYfYkCk+A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=AvPdTXIv;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768018891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3sok3w+EKcWG8672Zt1cWgHM+04imj24Z0uUlURlgNQ=;
	b=ZiHqvehbtLO/44DQEYbEtsOwwvc6mk8kjxWsU/0eBctUCqSwcTFlnLxEg1iHnkeDkNjp9I
	yr3jjy0ganm9u/riqVhlhEwnIwl3xhXq7tFhHB0/L1Xvvc5IoPL1ErClqoFH3MSP/VGEQk
	3Y67uG1hb8ZNX/jyvH3+QKQZIZfl8vc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3sok3w+EKcWG8672Zt1cWgHM+04imj24Z0uUlURlgNQ=;
	b=AvPdTXIv1NJmmXXm6nadLRtyixPKm1JNWVr57QBNUtQOLY8Bom/dG2cSUbvN7weFeNmJnStYU
	MjN4LUCgBwFjLhMOL5gxQX1MG0l8iCeg+jGUkHuz+qfSs8e4n5ggggtiAd1n5U99GLoVbwPbBY9
	vOPJ0jf4yBxL9F/KPnvJWx4=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dp53N58G8zKm4y;
	Sat, 10 Jan 2026 12:18:08 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 78D4B4056C;
	Sat, 10 Jan 2026 12:21:26 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 10 Jan 2026 12:21:25 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 3/3] mm: hugetlb_cma: optimize hugetlb_cma_alloc_frozen_folio()
Date: Sat, 10 Jan 2026 12:21:11 +0800
Message-ID: <20260110042111.1541894-4-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260110042111.1541894-1-wangkefeng.wang@huawei.com>
References: <20260110042111.1541894-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 919A7100003
X-Stat-Signature: e1jzqskhqinszm5qcs9zo34cwwy364o5
X-Rspam-User: 
X-HE-Tag: 1768018890-149704
X-HE-Meta: U2FsdGVkX18ikfDW6YXcDrclZvmotVFj6mLgSgRhuH+L3WxDaZ2ZwWzQxSx39BI0NrHHhYvO883VXiyfM9IBSFUPJjWVJso8VZLehio06q3jVsYflCJmPIdyh2RjBOGR3OIjoznKMbOKh8y97NBMtQBobCHuao1DWXxKiZIp4BICsCsxG1ahpJMFcgiZq6Xvz559Dj+cT8kKzdWmLKLpkTeLjVL24wCUyA2fxxWpTDn7HMfi2ZJMFLma9FLCWRNuhODJKTzKlC4XmPU3ljKwz6N9s9WnM2jAliIvGsX0aO0cfZecKr4lXoYZ3/WmnfGpW44e1XOQmiMcqP0comKpWzpXyJcEtMQ0EJrjFLieT8joK1lSQ3OVNGGqpgjmrYA7DIeQoXOLFhFIAUK4a7eK+ZwLIkUG/A9GXEuKYfRKkohOl387hYxZeXuDAvcv1tEXxHcK1p18gZoooYF+EO4QfoQPMxnKPvBhzH4Jf39PfblH2SXU8U/Dd++xRRMpB4/1yq0NwN9kaprQxjjfZrPDjE3AHAs2BChbSLhGy5/wny89OGfbegigqSG1JVaQbrFUjMRRplAXCitUB1D4agLLK5HdXStuQFLes3mtn/jFn4FVuLLQPl4TYihJ5cDif1u4tyd+Zhi0yu2k4s5BXzh8ru8TyY4mJe77N661gbN5eV4IFwJz3H5qdqm44IpvgQAggRHvhl++fv4VN+SxoEDiD2Xyty7xW+nAcG2+A2qM0K+q8uG7dmqjtTEinQP8Bu+21fijh1Iexgt+DImUTWMuIQI01NxvLQ6H/a9fqDqc6shqRJzIKVYFn66nKJvYDpdWlshizA2H3Ib3RP+S0Kjp4V4IOA+MjPE8se8UkKJeWZbHO2CdvRevpIR1P8ccCPGe1RlcNMZdcsDhZQG/26ECeB8Ie54wzZlGGY3DBzwIyUgu5k448H9ZVcWi2RRN8U5XAPfAEO8TQQn0JepOmYQ
 bpQ5ARdg
 LyA2HXJrPt2xFEG0AjeRwDm/nMWkcRpHHkWY4ZmJtwQIsmk3oFpXGr7hbr0rEonW46Q9euJNqPESRHubeGGB04vY3hutcJ2aXC7MElKReG3i0+Cu3uyboSi/xcbfuB0MhM/UqyTppayHdsh6aA7cG3MwD+RhKhcfAWJdWJ3k5igGNYRpJUupK9h1H50rPQiE7+RUU1uVyWw+DaBTiXZ43LNMQzSKAXu5oTRVPXpR+4zhZHIu05h8JPDK5Ea0gPkrrwFj7qkcTy3V/DzOpm/aw6x4Mm8ImQnUo92rmuBaiGE0wXiwe+ZYzngPko0AD7gZym8j0qP4p7wHccMrGSKUBP91nYNaclBBnFtjc90jwe1xUsi0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Check hugetlb_cma_size which helps to avoid unnecessary gfp check
or nodemask traversal.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/hugetlb_cma.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 0ddf9755c090..d8fa93825992 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -16,7 +16,7 @@
 static struct cma *hugetlb_cma[MAX_NUMNODES];
 static unsigned long hugetlb_cma_size_in_node[MAX_NUMNODES] __initdata;
 static bool hugetlb_cma_only;
-static unsigned long hugetlb_cma_size __initdata;
+static unsigned long hugetlb_cma_size __ro_after_init;
 
 void hugetlb_cma_free_frozen_folio(struct folio *folio)
 {
@@ -31,6 +31,9 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 	struct folio *folio;
 	struct page *page = NULL;
 
+	if (!hugetlb_cma_size)
+		return NULL;
+
 	if (hugetlb_cma[nid])
 		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
 
-- 
2.27.0


