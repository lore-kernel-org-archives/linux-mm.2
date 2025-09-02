Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C08D0CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 12:49:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D03F8E0011; Tue,  2 Sep 2025 08:49:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45A0B8E000F; Tue,  2 Sep 2025 08:49:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D3768E0011; Tue,  2 Sep 2025 08:49:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0CDEA8E000F
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:49:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CD4FE160120
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:49:21 +0000 (UTC)
X-FDA: 83844290922.19.17862EB
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9011540004
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:49:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756817360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/TeEJO9ohjzWhzbVvpgsPP/t3mbIAYZSyNNL5XMSIms=;
	b=AXu2NIflge1Bvp5BTXRQZjZQxmW467dKgArGrOA7wu+laYDQnMG7bIfdYK0Pbk/qw6aILU
	SzuSWgbxrwySRX2Eg4tFYvXM3tikJPSgee+yNBcdxUbhYh4kWA9AZXZmC/yHr8owD6madJ
	NAP8NKAnXh2vUQ/WR9Ibdo3FORpIlZ4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756817360; a=rsa-sha256;
	cv=none;
	b=2cBiL2pPmOzBxM/YebH9BrVZIp8+zwY+JwHsTJdMFUx4FsmCep05FrJb5r5KfUSPZYheDe
	j3ACEv2LjMHSu+8hCFjIGSJXAbvp6nXjTs6+tD3ha5T+USan2pqMJcf1O1rqSPkpQMG9Ve
	qpqlYdmCia/vh2ycaNTOy9/AwhzK27U=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4cGQRx4WzRz1T4Yp;
	Tue,  2 Sep 2025 20:44:45 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 86F15180488;
	Tue,  2 Sep 2025 20:49:14 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Sep 2025 20:49:13 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v2 4/9] mm: hugetlb: remove struct hstate from init_new_hugetlb_folio()
Date: Tue, 2 Sep 2025 20:48:15 +0800
Message-ID: <20250902124820.3081488-5-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: ikj84jte5brtbzmaoyhps8wgfo9d4p3y
X-Rspam-User: 
X-Rspamd-Queue-Id: 9011540004
X-Rspamd-Server: rspam01
X-HE-Tag: 1756817359-669535
X-HE-Meta: U2FsdGVkX1/uoo/bPuID6nQki+WTrj8prRWI20OJQ0+0MfpQqVJAwSxWDekijwUe4JItLfpT6DZLigY7jLG9l/zsndJZ6gbzVndpB8z2mXO/kaY6E4uRybMDYGxAQHIuOj3c20ha+ufXzQoOy3anDQIZKb35FYQxa/v8gM7cr4GzaDeFLLQgLe32xsYTPvuFMBDner52TfnnlwJb5wK1lr/xzq7Q/ZfMkKfVg5TUb+btXXlt2AVLgxcIbuIUl7Ns5IPLyyLunL/UN/uwVnADopxSNBuFUsBbKW8H/rZJI8VqMyzh283xnJbSsdlC+4tfYtoGe/DOgymijMFvOm0szFFpj8nO69+G41oLvObOCshQAMM+FtzqdGEG9/TtBEsdl3Iv3pM/AV3Ln8fIl1N96R7FDZskYfBdGwRIyLSpp/Fpa6uota3muv6ec/Hnv+VPJeqy9U4iqK0GAkk8bfyPZd0kG/Yxoe9kGWgmstbtAnTXgBs0wLs6Gm8XkWYMTBjeALIDZG8/onAaRmNTncXEOj2wHeZC+TaEHbsbmQgVPjFkIz4TukWkkK/VvFjmTqrI1MkhY1SuqDagXCIDtbhCjE+VhMP9kILkOQCGtACdx+8Y2sHu4pslc0e4lwmfChix5zbCXnalQuL31dZSgZuk61P+ZahnM652ioHp115hoBL3pl4Og5mACba4cH4+NsIwtXcgErTYu1XTAHxQ9DPKdRO1DJ08zrCW3s6ut5TkxRQd7ddYn3Q+WBN0dGh/AfVqzBa/+7CK1N31Pus/mC6ubz6AKJjskWOpOuadpMcrCmGyygg9bv53Gc3pSbGA/afQn6Db3gnMwayMLUV/DbTt4DpDqLrcd9jmO94LCAKGHS+9DrDvRfRGvjo7LPl34AzlZCUdg7fC2nyqR2tEOARR9T/G8Frymug1mG7DyovZ/kqNlpPHwil/xnqICErvieCQo2XbEiF3369I8eWIkK8
 KaJxqXHd
 1hGt/opbNJMEP+omKnXeay/YDRcd/KVa/M888qrSBdZrdxPjyiXF4l1fkGb0jQ6p/yopW2s25wjkmhTLdouTFZXcrJtId5EMf67TBGpISFcRxmH6J4X19bA5KqrK9TY10dzjfdgzJf6foKEA0Pv4Q82MdArm/qUHB7WAty3cG/S/71UNTkSMy8jm4bv49ryDr9G7Fcb+8HI92nc/7NQF2XkuVohCFxJ1KqZtuH1qKH94CpAqu5bAdbtPcP8evsqN1Tsi7jywIbLQe6iM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The struct hstate is never used, remove it.

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/hugetlb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 5c93faf82674..ab748964d219 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1896,7 +1896,7 @@ static void account_new_hugetlb_folio(struct hstate *h, struct folio *folio)
 	h->nr_huge_pages_node[folio_nid(folio)]++;
 }
 
-static void init_new_hugetlb_folio(struct hstate *h, struct folio *folio)
+static void init_new_hugetlb_folio(struct folio *folio)
 {
 	__folio_set_hugetlb(folio);
 	INIT_LIST_HEAD(&folio->lru);
@@ -1985,7 +1985,7 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 		folio = alloc_buddy_hugetlb_folio(order, gfp_mask, nid, nmask,
 						  node_alloc_noretry);
 	if (folio)
-		init_new_hugetlb_folio(h, folio);
+		init_new_hugetlb_folio(folio);
 	return folio;
 }
 
@@ -3404,7 +3404,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 
 		hugetlb_folio_init_vmemmap(folio, h,
 					   HUGETLB_VMEMMAP_RESERVE_PAGES);
-		init_new_hugetlb_folio(h, folio);
+		init_new_hugetlb_folio(folio);
 
 		if (hugetlb_bootmem_page_prehvo(m))
 			/*
@@ -4019,7 +4019,7 @@ static long demote_free_hugetlb_folios(struct hstate *src, struct hstate *dst,
 			prep_compound_page(page, dst->order);
 
 			new_folio->mapping = NULL;
-			init_new_hugetlb_folio(dst, new_folio);
+			init_new_hugetlb_folio(new_folio);
 			/* Copy the CMA flag so that it is freed correctly */
 			if (cma)
 				folio_set_hugetlb_cma(new_folio);
-- 
2.27.0


