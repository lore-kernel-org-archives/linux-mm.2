Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E69C87FC9
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 07:31:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 274146B0099; Sat,  2 Aug 2025 03:31:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D65D6B009A; Sat,  2 Aug 2025 03:31:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04EBA6B009B; Sat,  2 Aug 2025 03:31:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9EC66B0099
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 03:31:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A61391357F4
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 07:31:41 +0000 (UTC)
X-FDA: 83730997602.06.0344A07
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf12.hostedemail.com (Postfix) with ESMTP id A350940007
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 07:31:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754119900; a=rsa-sha256;
	cv=none;
	b=xCPMMj0ItGJKLxx24EZdy8hiEs3BopdqwptqiMhzfSmO26XMOObT3ytIB/+udqKFJSycmP
	DbdUw46anJz28bPKUW49/V32O4mwBxBaoyN/bMvlKOl3Ergf8t442ryuN3JMwx5xKNJglN
	0uKccMaHJrvsrPZ3xLufNSWI6aYFd+g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754119900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3fJ/B7S6tYL9x4RQ5onmHwEOyFm0bpsrdqSV03ftmPw=;
	b=R/dtp8kpeoku5K3CbWMqTBPHwdxgiwoK+Fdkv1C6Z+6e7SGkULsFPyaejg2FLq43z1fcsT
	cj9pKWnJnE2Mt4LVyC0DpLlTG0R2xgu/pPRpBPwtPrsn/NPw+v74U1JZW08WP7bLIAXucS
	qF8COUZqfZLOjwGexz4Cq6r81dTmFzg=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4bvDsz4pR3z2CfmR;
	Sat,  2 Aug 2025 15:27:19 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 4B65B1A0171;
	Sat,  2 Aug 2025 15:31:34 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 2 Aug 2025 15:31:33 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Muchun Song
	<muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@redhat.com>
CC: <linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 6/7] mm: hugeltb: check NUMA_NO_NODE in only_alloc_fresh_hugetlb_folio()
Date: Sat, 2 Aug 2025 15:31:06 +0800
Message-ID: <20250802073107.2787975-7-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: 8p7irxan9jahhun46pb13qy9dzkf3mn6
X-Rspam-User: 
X-Rspamd-Queue-Id: A350940007
X-Rspamd-Server: rspam02
X-HE-Tag: 1754119899-245473
X-HE-Meta: U2FsdGVkX19k6d9WpkuerCE4T7wP2d4OVXVjZmwP7dBFypw8jipyWPu6j0AhRG+ykWHevLAmziSKzl2O5WLvSUPZi6IqpwWTAXbhLuQ6KwOH2Jg/w4AHD0j6mOcj4B1I/rD98/gm2w9xnp3Af10TbAY1N3Pvk2ZE4rx4cZzRR71XVAsGwdyr8B5Zb0O5PLdrPMkMG8Ixis3KznJc9tvlz2cSDvZ99uyn9wg8MEuEul6/gAB8CtEA6wTzGHoOfpKeSmN6Oyc1tM7FwM/CgrLBEISGvQ8cfTv4T8SqBIf7f13h2mKcPS2xSCFZJI9V6DTikM8NHp5fv3shTO+mSKvO8Z0OWeK5bGoUOsUQ2TyDjHyVkWMm7n02K3MXG2K1DMPPE+HMtH2dz2WN7sIG9l3K3+plq1grgLD3iIR0tksbf0j3pakyTEUphLmKKKVShfTermsp9YPCBTpjYT0nfw63jSjTlH6aGwWtrACxKv9/TTqto6CT00L4T6zWpjscExaNrEPHXsY37X/U1rDZzNey1l1F33I0kaw9raLsODB9kezRDT3terhYcpu2GPcuimRe3kOEXE4nIiUCISxoMEAeYIYTUkkbP2xd+pC0HAMMteR9Y0Hn5TMpxi1whm7GXbpLqU7eQlaEIs3u9uO2a2FAGCNO7ps/5CMS1gUtfBE7erWIzBAyZy9tfwRcExUTp0FIknwknTqqIH2+IDK85Z/9+G+1uVpEKeXuYwN9J9nFiJQdhsSk+tkWpfCA1Te+Qrx1SyEzlDJGRfG71mPf1DOgQosrUAuFVtEFFyeTU3UlBrGu3F9wSD+7SDFeT6QppWmT4dOwC5oQUTiVuLFNH7s+fqHcSEM+ur5Ym2d2pU26nFv8Fs23RZoZw8Xir9H5x7ENpU6e3TUbJsKckeW06f6szElrrUr3V1wTO3DQij3l3gZgyuveStIKo//nGv/5lyj+HUvR6jTn8eLZo99p8Uu
 1xbg79Yy
 9Dp4W
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the NUMA_NO_NODE check out of buddy and gigantic folio allocation
to cleanup code a bit.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/hugetlb.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b16011c9645d..4f73b74a2cff 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1479,8 +1479,6 @@ static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
 	struct folio *folio;
 	bool retried = false;
 
-	if (nid == NUMA_NO_NODE)
-		nid = numa_mem_id();
 retry:
 	folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
 	if (!folio) {
@@ -1942,8 +1940,6 @@ static struct folio *alloc_buddy_hugetlb_folio(int order, gfp_t gfp_mask,
 		alloc_try_hard = false;
 	if (alloc_try_hard)
 		gfp_mask |= __GFP_RETRY_MAYFAIL;
-	if (nid == NUMA_NO_NODE)
-		nid = numa_mem_id();
 
 	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
 	if (folio) {
@@ -1976,6 +1972,9 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 	struct folio *folio;
 	int order = huge_page_order(h);
 
+	if (nid == NUMA_NO_NODE)
+		nid = numa_mem_id();
+
 	if (order > MAX_PAGE_ORDER)
 		folio = alloc_gigantic_folio(order, gfp_mask, nid, nmask);
 	else
-- 
2.27.0


