Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E17FCD5E133
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 11:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC9996B008C; Tue, 16 Dec 2025 06:49:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB3E06B0093; Tue, 16 Dec 2025 06:49:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A15116B0092; Tue, 16 Dec 2025 06:49:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FFC16B008A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:49:40 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 39A641A060A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:49:40 +0000 (UTC)
X-FDA: 84225164520.28.9DB7C83
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5347240003
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:49:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=UOEUMqzP;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765885778; a=rsa-sha256;
	cv=none;
	b=ZpE0ew9DzjED5vPJdA8/BsxrSS3+yb2Pz9BgpKgp0bn82VKSeuYQZeVt5Pkz6mtBv/MBCe
	VG7/c9VAypYK3jYvGQsGIZ2othh9jdvv0KbGiJJphXMh5JqW99XIxSGi+DB2nAz11e6Mea
	2hINx8s1U7t4QE5XeUNAbLg3kdy9uq0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=UOEUMqzP;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765885778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PLXWML4kOnPvJEp190cbIpl/DIQgKHyb1lIiyVZ1HEw=;
	b=vDSISRkayBYBwe4HYxmqnZZHd75fvqmL0c1GTNNW+JcETMfc6TCrPyWcvptxvP+Rs9LwcV
	2pLKqsQA4dBdUadrj3jjR8TzKqSjBKnJUfecV2cTQtoDzVzGbyM4eae3DHBG8WO4G5V/+Y
	u5kr3p/yViWDyFLTaTLAJCHPSDnHdPM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=PLXWML4kOnPvJEp190cbIpl/DIQgKHyb1lIiyVZ1HEw=;
	b=UOEUMqzP6F4MVgQgpSPWQ34ou33tLzhdNG3hpx0IbM21e8DDve0xs1csZzkw1sxSHjgG7ezEW
	9y9ZUle5IcF3N9ypMW6/R9XGGEbp9hIw3GX+EP1LnEDh6Lh0ua8oWhrkNAyGx067gEJ7/J4HZb6
	Rj9AmUlWxEWOXQRi5QuiqcQ=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4dVwCT1t82zLlSw;
	Tue, 16 Dec 2025 19:47:33 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 0CEA71400D4;
	Tue, 16 Dec 2025 19:49:33 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 16 Dec 2025 19:49:32 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, David Hildenbrand <david@kernel.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v4 2/6] mm: page_alloc: add __split_page()
Date: Tue, 16 Dec 2025 19:48:40 +0800
Message-ID: <20251216114844.2126250-3-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 5347240003
X-Stat-Signature: 516hx4ufjbb8cqrtkaiwzbeugjk893f5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765885776-370573
X-HE-Meta: U2FsdGVkX19TbKftZ9pxYwIfOgU86vTM3Vyn6Ld2PCCxVHlbx4DXz0kR/nSfmE1uo07u1QeFAjMAOLi3jyotttBJhvmqyWskiCm+jSU/Jwlv0/gXQh2k155DO4e35DL9k1vvoBrY2b9b7Mqf3DmA4odL2SGMmsJroNtY8D8FGSynEm3TpZlHQXSLD4TR25Fhe6zhqbB6bImzLnIqoclmndgbPMZwHS15gO9M96IRq7JzLAMzBBZtX3IH3yM3nLVdZecB0Yc6rFwOkSfSEoFPNIpGk/tkycNQozfwCsQBmcIDD8HMwzjGU7SOuTYic0UGA3ojx+MB1qYZ6ikSLtjXlQNIADjsziF8UfKrANV6Qxw6hZG/mivFxzWD8miriEVOX/XeV5K/d7/iMN7xHdSghDGkhfKSD++dqIo+UZfXMoIpqQXhExfBI7FpOY6mf7lHURAdbXBHIxek5TjCr2fUlMb6cu2O2cxcDopeLAasKu3bRDZH+dxB4NDV1sptxOmmz5v+En38zg73boOxL+2JG3SgiEJ+7R1j3TOY3QoOVmV6aWPNseB8cVE7qvDTvBv+ymZTNKw8ggRdpxX8OtQVZv08+gcIzU0Q1XP+6ef6cDhxvDKNk56DNMfr434nNWa5aBJrsant17WzViMa01OYJVXwTiWycD1eMJ1RfqlYktd3Fs020DTlxH57MV99O9n1rGjfYpSdAMWtJhkq6VWX7UmGK3Z04//rEM3DRPY9yWqa044M7EdhioKvXTKCXovzmPwpdI4cbFoaE4lPvf/24fTTyMoeofZIq2iEZY+jCGb2uQoBcMgsClVeFLVGNwiret7ZiuZ6t3bxnvNHUKfdlS7ptlLP1b8pbYwCCD+A1oWg+GVzc5zFDSzsipQTTHWwPMi3OAsP94pX/ic5k3VsPyrPC3V7ttOfX95k6e5fqi9cOfK6FRL/udl66RZFhCZ3t7eoCIF32Rm08hcV0DS
 s5E5YDTF
 VzMtkefupKKrvw6mqCVW+FuoioTAB+0QIFvfDFZEWXv+FZLuv2lx4qUwrhQBWvGqdQWFQWSsYMUZk58saVscC48qptLGEA66xIJFBpY/3//Yybc1ePBzv2vEj/lYoFfexr4I1JkWXns31G8oJj9tlURaAO4HmGzeAzjWnySsKQmDfBYJPpKcLzhoXoNNczkL5lVxa+CbXmEs7KgK20VkNXogaxaKGj9u7KR3S+QKv1dLOHiJLTewBTvLNd5O/JzoXVWlrUg5pIKp82jqPzQ24y4FBAD4Wq3OSTD3NjuK0dwKvJI68y+DmxDjE7Cn/fVVrfMz0KcvxBi2rg6jwZKNToneWhz5ovRDEoxMhcXlrmxL3uNg2Cuw3ilFpDzz/FlqsFej9Mpdr9LDWsdw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Factor out the splitting of non-compound page from make_alloc_exact()
and split_page() into a new helper function __split_page().

While at it, convert the VM_BUG_ON_PAGE() into a VM_WARN_ON_PAGE().

Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/mmdebug.h | 10 ++++++++++
 mm/page_alloc.c         | 19 ++++++++++++-------
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
index 14a45979cccc..ab60ffba08f5 100644
--- a/include/linux/mmdebug.h
+++ b/include/linux/mmdebug.h
@@ -47,6 +47,15 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
 			BUG();						\
 		}							\
 	} while (0)
+#define VM_WARN_ON_PAGE(cond, page)		({			\
+	int __ret_warn = !!(cond);					\
+									\
+	if (unlikely(__ret_warn)) {					\
+		dump_page(page, "VM_WARN_ON_PAGE(" __stringify(cond)")");\
+		WARN_ON(1);						\
+	}								\
+	unlikely(__ret_warn);						\
+})
 #define VM_WARN_ON_ONCE_PAGE(cond, page)	({			\
 	static bool __section(".data..once") __warned;			\
 	int __ret_warn_once = !!(cond);					\
@@ -122,6 +131,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
 #define VM_BUG_ON_MM(cond, mm) VM_BUG_ON(cond)
 #define VM_WARN_ON(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
+#define VM_WARN_ON_PAGE(cond, page)  BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_ONCE_PAGE(cond, page)  BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_FOLIO(cond, folio)  BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_ONCE_FOLIO(cond, folio)  BUILD_BUG_ON_INVALID(cond)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index da32397b4313..aa30d4436296 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3077,6 +3077,15 @@ void free_unref_folios(struct folio_batch *folios)
 	folio_batch_reinit(folios);
 }
 
+static void __split_page(struct page *page, unsigned int order)
+{
+	VM_WARN_ON_PAGE(PageCompound(page), page);
+
+	split_page_owner(page, order, 0);
+	pgalloc_tag_split(page_folio(page), order, 0);
+	split_page_memcg(page, order);
+}
+
 /*
  * split_page takes a non-compound higher-order page, and splits it into
  * n (1<<order) sub-pages: page[0..n]
@@ -3089,14 +3098,12 @@ void split_page(struct page *page, unsigned int order)
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
 
@@ -5366,9 +5373,7 @@ static void *make_alloc_exact(unsigned long addr, unsigned int order,
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


