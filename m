Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0639C87FD2
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 07:31:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D972A6B0093; Sat,  2 Aug 2025 03:31:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD13A6B0089; Sat,  2 Aug 2025 03:31:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC0A16B0092; Sat,  2 Aug 2025 03:31:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A82AE6B0089
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 03:31:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 381BC5BC19
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 07:31:37 +0000 (UTC)
X-FDA: 83730997434.27.4383858
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf20.hostedemail.com (Postfix) with ESMTP id CDC621C000B
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 07:31:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754119895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jpwoB1M/ze/6PcxBup83ExSdNP2kItNJRPyf9ZhMRiQ=;
	b=lvFxcNYt3lUERsMFORcWWrlbiUTGFNUAjc1EmzhRoG7WbZWVCjq/LkB1baEuoe3nPdgz6x
	0tu+O/Q6hbK8+AcMa9OZdTZbk/N0iKj6fTtL6cpISTjUragQEw3XobSPfAFwI2AW4b2Pql
	gBC5z62E62ds4rdqDGpzLw9Ku5jhlTQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754119895; a=rsa-sha256;
	cv=none;
	b=K80U7SgNAUYObCiY/f/QRMqKtUYiAVsLeLvhz4Jd2ctofB0QS4i2953Fi8P7x8gaZcDT/i
	SEXu4WCRXN6/BWMYK67AGZ8R3XR/4g+PMyOeGKngFh3k6l7LppWmPU9ERRUjqqkrwbWJgD
	5zCewurfCf29GKgqjwgUjkT/R1IlCsM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4bvDsw6FLtz2Cg01;
	Sat,  2 Aug 2025 15:27:16 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 7D470140278;
	Sat,  2 Aug 2025 15:31:31 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 2 Aug 2025 15:31:30 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Muchun Song
	<muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@redhat.com>
CC: <linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 2/7] mm: hugetlb: convert to prep_account_new_hugetlb_folio()
Date: Sat, 2 Aug 2025 15:31:02 +0800
Message-ID: <20250802073107.2787975-3-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CDC621C000B
X-Stat-Signature: wweedoo1zroih8z4nwyjh5g1twr8iq5x
X-Rspam-User: 
X-HE-Tag: 1754119894-421116
X-HE-Meta: U2FsdGVkX1+nTWkD9J13jAHq7MvnfrCARWGcxT5IRQZu3BSWMqzTDe+ZXfokKQZ2sWSiD4vZyf/vUTG6VAlBlbT/nZaXUcPzmYbbUVAVOPjUCbRC9lZdaDB0KdKxi2BfzJdsneJJw3pgfL6ClQF/Vuqe+6P6SN5jzu6EeuafB3u1eXJLW9W/Whn5ux8r4TyKxTCcfn+R3+g7KhwLFzVy6cUTNKLG3J0HPxr25iozyc54p/7zQz1f7YdcML9yda11vnN2anvtkHIlL8fNEOKzxK8SvardbJG4JzatLS39VWWdT3YJxHkjHuY08VjY+E68YxF24O+x87/5SbCELRvKa4Htd+hjvF9vNXin4QDt0tQ/VxPOJi5/xbFE3m3K9oKcgcHwStSbiMWzMM+5UmSI7x1dDnhe3vNQHJpebTiOtuptFLfqreAy+9ztD1t1KFLkEnGy9gYqmMsj3zidjYR7QICW/6wv3gDx38mc6HVk6uKQBe2OdGlVZYBeoUnTFtPcvAQAqEhXE5zqDtVl5kXpD2ia+2Nhh//Wa5WNQwu15kHY03jHPJ3w32+MevmABOZB1080pEDUJ9GWV/X/0DYdscSk6yuHeRaTzPvvHqqV8TaYNOjLyyhkFtTsVB1jkOIu28OjEnwRYU0j6F5qVe/1CG+jOmClqaCgBupGuqJXFpGwTK2e/nhDh+ptL1Sib3zBYLIxA8174zh5XehdEoQx0u3oLcy9QrZKkeAJe/ciGe/Us78G5fOJPV5ptAPcA4fwOQ1sEnn+8QVZiG/3/q0jA3XKCTMmGkWEYVV8ICfTDJHvlvt6cK6Je6rTbpuDXHVe2HfXLzXIjVD4nzLtuDvZk1CcMlab+ALPHXZynLWFg+I7VsMR/RvF0Jjr4kfsVEn5HAYYUH5G8TamR+lE0o6tywr7efbIYcSeTgc3S6EmmeMkFQ4vNoxR0YpobmGX7WBNEHuYEvmuqCnEe1QJvJ0
 mS2YbG6g
 yCG7CWTrfCgMniyHDm5/40NDoaWBl9hIXZHgow3JBSWEhcw/kt3JlRTemPs7k4lW0oI7abjEm9CiKICK535IA8AC1Y5M4hbvdfEbWd/lpaHIGKK2y7Zb+FYz30EtlAgW6mQcneLgKcK419S0RJ8LbPEd0XBhhaOfuMvSoV9iqghsDhLRyI4vTZvkG5qD3KlV2Nn+v8W3DuunRcFSG910Y5nx/37fd9pLAdfsyNnCSzPABgfs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to avoid the wrong nid passed into the account, it's better
to move folio_nid() into prep_account_new_hugetlb_folio().

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/hugetlb.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 5b4c19e7a5f7..afec5a6a8aca 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1890,11 +1890,11 @@ void free_huge_folio(struct folio *folio)
 /*
  * Must be called with the hugetlb lock held
  */
-static void __prep_account_new_huge_page(struct hstate *h, int nid)
+static void prep_account_new_hugetlb_folio(struct hstate *h, struct folio *folio)
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
+		prep_account_new_hugetlb_folio(h, folio);
 		enqueue_hugetlb_folio(h, folio);
 	}
 	spin_unlock_irqrestore(&hugetlb_lock, flags);
@@ -2232,7 +2232,7 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 	 * as surplus_pages, otherwise it might confuse
 	 * persistent_huge_pages() momentarily.
 	 */
-	__prep_account_new_huge_page(h, folio_nid(folio));
+	prep_account_new_hugetlb_folio(h, folio);
 
 	/*
 	 * We could have raced with the pool size change.
@@ -2270,7 +2270,7 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
 		return NULL;
 
 	spin_lock_irq(&hugetlb_lock);
-	__prep_account_new_huge_page(h, folio_nid(folio));
+	prep_account_new_hugetlb_folio(h, folio);
 	spin_unlock_irq(&hugetlb_lock);
 
 	/* fresh huge pages are frozen */
@@ -2829,7 +2829,7 @@ static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
 		/*
 		 * Ok, old_folio is still a genuine free hugepage. Remove it from
 		 * the freelist and decrease the counters. These will be
-		 * incremented again when calling __prep_account_new_huge_page()
+		 * incremented again when calling prep_account_new_hugetlb_folio()
 		 * and enqueue_hugetlb_folio() for new_folio. The counters will
 		 * remain stable since this happens under the lock.
 		 */
@@ -2839,7 +2839,7 @@ static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
 		 * Ref count on new_folio is already zero as it was dropped
 		 * earlier.  It can be directly added to the pool free list.
 		 */
-		__prep_account_new_huge_page(h, nid);
+		prep_account_new_hugetlb_folio(h, new_folio);
 		enqueue_hugetlb_folio(h, new_folio);
 
 		/*
@@ -3309,7 +3309,7 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 		hugetlb_bootmem_init_migratetype(folio, h);
 		/* Subdivide locks to achieve better parallel performance */
 		spin_lock_irqsave(&hugetlb_lock, flags);
-		__prep_account_new_huge_page(h, folio_nid(folio));
+		prep_account_new_hugetlb_folio(h, folio);
 		enqueue_hugetlb_folio(h, folio);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 	}
-- 
2.27.0


