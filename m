Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46F02CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 13:40:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77CEB8E003C; Mon, 13 Oct 2025 09:40:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 754A18E0024; Mon, 13 Oct 2025 09:40:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 691508E003C; Mon, 13 Oct 2025 09:40:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 58DF28E0024
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:40:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1052858DD7
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:40:42 +0000 (UTC)
X-FDA: 83993201124.12.33219CB
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf20.hostedemail.com (Postfix) with ESMTP id C4C2C1C000C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:40:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="X/pXsh7c";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760362840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PVGQ2gfuLUyOKQMDVIrb3M5o+ITMssO0UGqKhmwQGgo=;
	b=e2oSIPpRmMVgSOGA7NJ10cX5oIlqQRKd52E7v/FApyRqh2Ksf50Xp322g5haLcw6gCeVQj
	Kyg3VikoZBQMykqkmUu86QuV0mUxzdP5N8XV45xQdRyr12p2fsn8PR3Giw28Bsg9NKEXRC
	jALYEWg2dLb/4md0+NJZhx0LftBZGkk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760362840; a=rsa-sha256;
	cv=none;
	b=xa3giIw05hZU/iSQiJ0mL2gNchZ0iiKAPGDVAzpFV7cvxa1GLuzH5ZkxCnnaIjBInxPRK9
	atyoUVq1JXZNVhgHU6J5yA/cHZJXuRTr07iyjluXF/whY82QdDX5yFlOMglFoMHvQJVLhn
	K0Cj68kBxvyV6vrUGlIzi0fjnGKIe7I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="X/pXsh7c";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=PVGQ2gfuLUyOKQMDVIrb3M5o+ITMssO0UGqKhmwQGgo=;
	b=X/pXsh7c/OV5PUPjUOM0PssPytu/PnXVn3A6wV8TB4DxXKjrZsPWcruUkiwytN1tWxQOp/qZI
	v49C6U1MURMt2wNSAdkk90q/ocVzWCf53HAFh75WxtVNvWtC0bhQ4CyFqpVKX9KVSYdEFoqVnZj
	e7Y7NfQc2WsFnqRuJrfZQJ0=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4cldl40J7gz1prLh;
	Mon, 13 Oct 2025 21:40:16 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 86099180064;
	Mon, 13 Oct 2025 21:40:35 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 13 Oct 2025 21:40:34 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v3 2/6] mm: page_alloc: add __split_page()
Date: Mon, 13 Oct 2025 21:38:50 +0800
Message-ID: <20251013133854.2466530-3-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251013133854.2466530-1-wangkefeng.wang@huawei.com>
References: <20251013133854.2466530-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Queue-Id: C4C2C1C000C
X-Rspamd-Server: rspam02
X-Stat-Signature: j7b9wxzrbc1pipqy5wfqoq11g1arcnox
X-HE-Tag: 1760362839-218003
X-HE-Meta: U2FsdGVkX19HnqJMewpjCFqKK5yJ+4DhS3QtsfaKWLjfod076gYUhdt8TSVg4uBvw04LhdWtkyrJjM+BeVcV/Xp+mkmw2EVBr21yyfb/en/dx3QaMhiD9Csq9he0GadH+xzeiGjryrxxKaOt1BbEjjjD+1FhKHWLWcUcNgx1cKPlzaYivXYEvCL0AXAmNxTXypYKGpFDFMwapH8UCZ5M6evbotp9/K/7am2KI3RPP4py4HAOa2Eo45glWiwcd61L2poRd7yToHhZCCjhNN37KWliVyE5RMjRzHbUrJiTFhtZsZ3RFWSOmIKRjafA2ZXRrBSZ/nKIenJMhRuRuhvx6MYQd5DyaCX285sB0PjipxQP2mw6sAq1xmMOumA+bk8IJDRPQygo/L9RFPyYQamY1MEFFjt8kQsv+Jih2RvWn+Myi5iDXhFv/onUKRecY8N1WVq/UHxy1I36l6kKCu2TJDBneJwFVtJOL64ifsdQILj1wAhVatmDecAAC++ME1OR8P8hXnv8J+V65l2qYieeWMJnm1ut8Qk3sl0+WFLMr5KCkzbPfvgjp4622Y4H3jQeUyhx24yvCPQS/t/1HgkuK4THU2eeP6zdcfs+dFhxKTEOXKdqHDmaLM9BrHGHzxLDENeCt7TQKOYIuUcaC+4zE3udh+ISF22roLUtIn18+KcmTeJ5n0J/FxfiT7BxRi1sn5gLIq613Kab0V23CI03dlcdh59SEUglsEoMuY2JWiIp+4BBunKnw8jKncjAihc2ZVkg6HLuRPJIeTUc4FVP/qc9WWnqIQXOCE5EgEMeA4iPtWtoPL7YTVWhmqiq9xYBi3TdZZtYz3kiscSM5jRkiypoDnzH5FJ1q8qDmAGuJu6sYIjsgY57wD1bmTHfa93HGdrFwGwWQ5zCy/EjUOq5ZA9YhTi4Ktfk0ctE4iIsEuT+deoPlqhY5U1LjEfUf4Lqg+3uA+wq0D7rHmXl/oH
 ym5Hmhhh
 chcPy/rym3yORBHU3mWtd0bkbaCb8YG0m8wZB/Pe3Mz5L8SB1xFWLoRf3q4x/+MAhbeWjgRznQrLdzVDdwMzP6o6fsB/fjWCPm61gLjVP5dszm7mBeEBMrOqid+S3wDEtCCcEt+LN4mBc0RubLeS5VuirC9eGaWFPmp4N8T4ffiNLW356JoeGQUz0faDep1o5IZZ6LI+pL5cszrabGJoCQ4wO9M1KI5v8iDMGGAnqUZIp9K/ygcDoGEQzjMq/94H6C0gbmYFcrow1hhvqwMckwjvSNF/bYep+0iPtUWiJd9O7PwmzdI3P2a/SmjUbxZ5zXtGsje7pzgnQ8UOatX9zSPgMeA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Factor out the splitting of non-compound page from make_alloc_exact()
and split_page() into a new helper function __split_page().

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/page_alloc.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 949b01f293d4..646a6c2293f9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3042,6 +3042,15 @@ void free_unref_folios(struct folio_batch *folios)
 	folio_batch_reinit(folios);
 }
 
+static void __split_page(struct page *page, unsigned int order)
+{
+	VM_BUG_ON_PAGE(PageCompound(page), page);
+
+	split_page_owner(page, order, 0);
+	pgalloc_tag_split(page_folio(page), order, 0);
+	split_page_memcg(page, order);
+}
+
 /*
  * split_page takes a non-compound higher-order page, and splits it into
  * n (1<<order) sub-pages: page[0..n]
@@ -3054,14 +3063,12 @@ void split_page(struct page *page, unsigned int order)
 {
 	int i;
 
-	VM_BUG_ON_PAGE(PageCompound(page), page);
 	VM_BUG_ON_PAGE(!page_count(page), page);
 
 	for (i = 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
-	split_page_owner(page, order, 0);
-	pgalloc_tag_split(page_folio(page), order, 0);
-	split_page_memcg(page, order);
+
+	__split_page(page, order);
 }
 EXPORT_SYMBOL_GPL(split_page);
 
@@ -5339,9 +5346,7 @@ static void *make_alloc_exact(unsigned long addr, unsigned int order,
 		struct page *page = virt_to_page((void *)addr);
 		struct page *last = page + nr;
 
-		split_page_owner(page, order, 0);
-		pgalloc_tag_split(page_folio(page), order, 0);
-		split_page_memcg(page, order);
+		__split_page(page, order);
 		while (page < --last)
 			set_page_refcounted(last);
 
-- 
2.27.0


