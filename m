Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2CBFCAC5A0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 13:20:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B35958E0110; Thu, 18 Sep 2025 09:20:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B06528E010E; Thu, 18 Sep 2025 09:20:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A6638E0110; Thu, 18 Sep 2025 09:20:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 858518E010E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:20:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4E4CC118069
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:20:42 +0000 (UTC)
X-FDA: 83902430724.19.F27C435
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf24.hostedemail.com (Postfix) with ESMTP id F0819180019
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:20:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758201640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GJL0SyKzEA0r4IFf2wEXk9iAaLLpPCCyz/PY5cSiKyc=;
	b=t/4i4ZXqSrFTtkA0E0stavOsvlMd7ku6pZeMNvO/lHUqiBki4BRvjiADV7p3sIVr+u6I+M
	Vh0azua7E1mQW4ItWyNS+amP+UMBpLp7vx7qlkI5YegWfJgx1qQdJPFfzmU6wunmp+8d9u
	YMUDlHscWl/Vce7Ko9USsMNH8IBoogk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758201640; a=rsa-sha256;
	cv=none;
	b=jCWt4Yizs36KwarbHpEn6yQpF96MiAtVUAkCiz072htENNujAu0hvWj7F7F3h9OgJYhOp3
	0D/Ho6EMy/g6/ic4pY4bCC3UoWrdLWqqos47I6Pi4N94j255ZQrFnKQwJWZTC3eOWNUkQf
	q0F2mgxiD9ZXU2WrbvksA0bAKCCq3k8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cSGP43jkQz13Njx;
	Thu, 18 Sep 2025 21:16:24 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id A3EB0140137;
	Thu, 18 Sep 2025 21:20:35 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Sep 2025 21:20:34 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, Matthew Wilcox
	<willy@infradead.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v2 4/8] mm: page_alloc: add split_non_compound_page()
Date: Thu, 18 Sep 2025 21:19:56 +0800
Message-ID: <20250918132000.1951232-5-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
References: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: afxo8kzk5nn47hbsz5snk4ysw4pjw7db
X-Rspam-User: 
X-Rspamd-Queue-Id: F0819180019
X-Rspamd-Server: rspam10
X-HE-Tag: 1758201639-523743
X-HE-Meta: U2FsdGVkX1/pwkhR//t65hMzmclQ2lt8BnCFm3QETwb0FSc7fTUJEhbr8lukcCJMJP3q8Cpj2Irt9+PdtUzFG3Vhgmc+U38bokBULheKC+KXOsYL+2FKomGS9MoO+47EKJX20wTU6OkuR+S7UlTmyVskqXujHC1dePnGfLZoMvvOAC5/+3/Kcz1Nox+CzCRoROs42HqUVr1mOxzCdoRnStBcHHLhGZPCcJza/dsvsJivy4dAMmz1Lrt7LQ6ME6UD1r1Hk0Gj92cJ5vzmVzBdctrTIi1i/Q9HoFybAmDZkB7N3r1jrxdSlwX3QPcoaQE2abk/TeUIahx/pBkh8qM2NnXsse2NzoRMQpQxYFZ7O1jveUjdlfsCBBWIszxAWWNEKsRw7P40gwXWkOgn+iIZ0SihamIHSXNmuD0R6Cv9dfWqZwMweFGQ3DKj7X3C/ed+Zc063NPlwJmtDbDlmno2t6PgGcPJEXJMibZa7ZbmCWUenxykQFXR48YZ1VVt/fmWEedGnyVs3sPAdWbtJS6p5r/qozawcNhWx4dpg7cDGkMww2SNlhZ7DrxBonRFhnOe7dg+HWwfL1WXK9lGVo+oRy96y+2BxeC36zsJ4zBpqiEwIun7YsN6y1x4xZ/lq9ZVr3jICWn6fkswYi/w6qYjDqRK5q9hx0WQ0vErzBM9mUKWPCldgv+ZG7ghiOozkf0AwA/+osJ/F4VJOpwjvG62o1Uvzjt4dZinmX6yo1YYRyOlfcvKR7hXmUkQcXGo+eEAjTaAqey5rlNXyFRGkmdjtmm3LZSXdET0uYlgKrbw1B12SBS8OeN0i7caYbdB4UHeUhkuqbmAOanoTSpb9ds+zXkptdWcVYynIDO66x+6axWCfpw+tOUYoVsAi3fIz/5chbV2Hl4Kriqmvgw2XlqxItxFEyizpJ0d2rPln+YpfsY8b1T1Y/iiD7OeGmmhlhTSRpBxGta88bLphHMYuxc
 6MU/cCLK
 triFSG3TCWcUOz72piXa8K718E/Xu3wO6GNVZTL+eYbngj3smdscURYsGxqYv6OOwcVLeBOXNp0roriQNCeSQaV8KzqmoGd5lWJ4T+uu947b6N0Q1bpCTj75CNcWIS0woQ5rq5nHgL/CzUwG87wYvLlStlLIustQ0sSfW6vcnhijvpC8kw0kZmKbUgjAy11aOTaEJhDM9hmFrgt2b+prB0nv3PhTskSDC7ycxiK/TZJXGok0ot13TOhut4Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add new split_non_compound_page() to simplify make_alloc_exact().

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/page_alloc.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b6eeae39f4d0..e1d229b75f27 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3042,6 +3042,15 @@ void free_unref_folios(struct folio_batch *folios)
 	folio_batch_reinit(folios);
 }
 
+static void split_non_compound_page(struct page *page, unsigned int order)
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
+	split_non_compound_page(page, order);
 }
 EXPORT_SYMBOL_GPL(split_page);
 
@@ -5315,9 +5322,7 @@ static void *make_alloc_exact(unsigned long addr, unsigned int order,
 		struct page *page = virt_to_page((void *)addr);
 		struct page *last = page + nr;
 
-		split_page_owner(page, order, 0);
-		pgalloc_tag_split(page_folio(page), order, 0);
-		split_page_memcg(page, order);
+		split_non_compound_page(page, order);
 		while (page < --last)
 			set_page_refcounted(last);
 
-- 
2.27.0


