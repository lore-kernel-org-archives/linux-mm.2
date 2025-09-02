Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAB43CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 12:49:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35D038E0001; Tue,  2 Sep 2025 08:49:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 154018E000F; Tue,  2 Sep 2025 08:49:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E93258E0001; Tue,  2 Sep 2025 08:49:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C37228E000E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:49:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 92A451D8949
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:49:18 +0000 (UTC)
X-FDA: 83844290796.22.548B9F7
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf18.hostedemail.com (Postfix) with ESMTP id 170761C0003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:49:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756817356; a=rsa-sha256;
	cv=none;
	b=1u8VxZDOadlGiait6WSv5/VK3u4dACfwytCmJN4v/zd7ctp2A7y1y58egO2aIDnm4htixF
	IqMbO86Zos84UJlotlxCsmOlsTQi0tQDa/fZR5z4TCsZ/jFsxHm7dhfR/lGYH4bFP6yTEF
	FYh5OhCsqemx9lSgAL22/yRNnfAg5Sw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756817356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P12jBTjQte/keqXxg6gAnGZE1UoT1JIALiE0K2KBdas=;
	b=S6TGICABA1CVBUBHf448GXkQwtJPEmmn/RfOsP8p33xPr2YbV69amAK+GFNCq6WnnpZMhi
	8JTSj8cKUJp9rTR/BD2jb62pbyS9DgNwTB8ekUTxAZOOtlDxVL5B6VyZEp0gluKQVBUsyJ
	5q6T9+7aXz+AMcLz1oVOi53ej+7ZETc=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cGQRl702yzPqbG;
	Tue,  2 Sep 2025 20:44:35 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 84052140258;
	Tue,  2 Sep 2025 20:49:12 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Sep 2025 20:49:11 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v2 2/9] mm: hugetlb: convert to account_new_hugetlb_folio()
Date: Tue, 2 Sep 2025 20:48:13 +0800
Message-ID: <20250902124820.3081488-3-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 170761C0003
X-Stat-Signature: d7kg4k4gm54zaqcrkybsnhknofmryx1h
X-HE-Tag: 1756817355-298068
X-HE-Meta: U2FsdGVkX194AZCW2HHAiMExdm1HsdV/zQ1HmYl/Ct1W8VXqctWEklf4v6AEOAisQdcJbuh3OK0MDOqV6EcEKaRCEOqI7+2UEm5LFV0po4v4iDfTxulo069g35DXkutB1xhxIzVgtVbMEpwvsP4Drd1YboFINlGLtUy0h5YX4w19qpnNJWcL1OFflc7X+jBfB7VczrsRRSiNZwjTQYqA94nEYX6zPHj5H74VIYkzjFfZuHi92RJHZzLFFK+p/vtmM5RTXYItlXxM+Dl6NUY83oEpWL91z15h5Fll5wSb56g1FuaDI7FoxJWbpBW+ksZQqpr2nKbeHtLNJ4wsLGcr5OECJdUiqvbUh/mTvg3Kcn9hCK+QcgHeiyL/iAG4Y6HSMjREhqHwGRR0LHNkmAxhwltMlP8rmPGoky6OT39N0jS91QeWJ14tj/2Q96neEhxOJJQ9V7fiYu8JcuOhHTCcfKcDguYR6IB2WrA3kSSGwZM8I21RIS3nPyAApNgGpMkmFm+SlPkskSvkmHYgKQGoyvq7YdxKOLZKwZ7ADkDNXkjdGkh6dj/JEeGwnhMvigReKA872jfKgzRLwvN2tSh/ykS1AabFPnymJSVzcExDQ9lAktT7sIgPsHG0gZsQSGfKs60fkmYTzqKSEhJDOt1r+GFc44/TGaOhm8P4cy67rV75Twy3XvxaXGHCbmPchlalKi4+HddBLG3iNekksPqinZjUyxnuta8EckNGkwEr4qJNY1d2QT0nKITXeoTTKMHrzNtLfD+vu2+P8/3pZNOij9M9EW3kBSzT/OX2dqhor3EYAcdA/hk9zzOLUZiHhFTatGMaGIbyp3I8Ycvd6gBqJvRDg9AbKtZsT0wBbuUEplEkd6Rj3agWv8Ehx5gbv7807tiOLNvwFTICrkV2mX12eyjwZjKopptF615o4PHMulZHSIL+HxBmGfcsA7n1o4btv05JzMGgaIuHUCYbwxr
 dS9O8fgZ
 +/aLX/7AMxHcybYvMnvFKxhFe6UsXCJBZuSW6/NvvHnzftOj1aG533mrCILc5dBTrNK7HkHA7sy6yWCrooilJNl12YJD8+VJUeL/Rb4P7b+scNFhfKijH/FP+JrrgjhZ+dvPZlIZ3NbpcH3Qr95dc2lqSfCMK38OWduq4eMMjm5/XGa9kntWJaWKmMDBUekBJxO3I9dnFnDIx+Bh9VF9LeYdmBxOPMl8okVkZptuTSn/5JJyRj6RXAXCYln0uRNgsA+MXV29EiBvIuvc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to avoid the wrong nid passed into the account, it's better
to move folio_nid() into account_new_hugetlb_folio().

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/hugetlb.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 93aa32c51265..4131467fc1cd 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1890,11 +1890,11 @@ void free_huge_folio(struct folio *folio)
 /*
  * Must be called with the hugetlb lock held
  */
-static void __prep_account_new_huge_page(struct hstate *h, int nid)
+static void account_new_hugetlb_folio(struct hstate *h, struct folio *folio)
 {
 	lockdep_assert_held(&hugetlb_lock);
 	h->nr_huge_pages++;
-	h->nr_huge_pages_node[nid]++;
+	h->nr_huge_pages_node[folio_nid(folio)]++;
 }
 
 static void init_new_hugetlb_folio(struct hstate *h, struct folio *folio)
@@ -2020,7 +2020,7 @@ static void prep_and_add_allocated_folios(struct hstate *h,
 	/* Add all new pool pages to free lists in one lock cycle */
 	spin_lock_irqsave(&hugetlb_lock, flags);
 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
-		__prep_account_new_huge_page(h, folio_nid(folio));
+		account_new_hugetlb_folio(h, folio);
 		enqueue_hugetlb_folio(h, folio);
 	}
 	spin_unlock_irqrestore(&hugetlb_lock, flags);
@@ -2232,7 +2232,7 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 	 * as surplus_pages, otherwise it might confuse
 	 * persistent_huge_pages() momentarily.
 	 */
-	__prep_account_new_huge_page(h, folio_nid(folio));
+	account_new_hugetlb_folio(h, folio);
 
 	/*
 	 * We could have raced with the pool size change.
@@ -2270,7 +2270,7 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
 		return NULL;
 
 	spin_lock_irq(&hugetlb_lock);
-	__prep_account_new_huge_page(h, folio_nid(folio));
+	account_new_hugetlb_folio(h, folio);
 	spin_unlock_irq(&hugetlb_lock);
 
 	/* fresh huge pages are frozen */
@@ -2829,7 +2829,7 @@ static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
 		/*
 		 * Ok, old_folio is still a genuine free hugepage. Remove it from
 		 * the freelist and decrease the counters. These will be
-		 * incremented again when calling __prep_account_new_huge_page()
+		 * incremented again when calling account_new_hugetlb_folio()
 		 * and enqueue_hugetlb_folio() for new_folio. The counters will
 		 * remain stable since this happens under the lock.
 		 */
@@ -2839,7 +2839,7 @@ static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
 		 * Ref count on new_folio is already zero as it was dropped
 		 * earlier.  It can be directly added to the pool free list.
 		 */
-		__prep_account_new_huge_page(h, nid);
+		account_new_hugetlb_folio(h, new_folio);
 		enqueue_hugetlb_folio(h, new_folio);
 
 		/*
@@ -3309,7 +3309,7 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 		hugetlb_bootmem_init_migratetype(folio, h);
 		/* Subdivide locks to achieve better parallel performance */
 		spin_lock_irqsave(&hugetlb_lock, flags);
-		__prep_account_new_huge_page(h, folio_nid(folio));
+		account_new_hugetlb_folio(h, folio);
 		enqueue_hugetlb_folio(h, folio);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 	}
-- 
2.27.0


