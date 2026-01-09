Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A6C1D167E9
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 09:32:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F0F36B0096; Fri,  9 Jan 2026 04:32:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09A9E6B0095; Fri,  9 Jan 2026 04:32:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCB5E6B0099; Fri,  9 Jan 2026 04:32:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8C326B0095
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 04:32:02 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 873161AB518
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:32:02 +0000 (UTC)
X-FDA: 84311908884.22.80C4690
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf03.hostedemail.com (Postfix) with ESMTP id 152FD20002
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:31:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=OxeJ76x+;
	spf=pass (imf03.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767951120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ju413pk+X7OZOjx7Isz69EdS2j8wMMLZdWEnm2KwEk=;
	b=4yE2XR1DUTFwDVqAEDIXR95fiyXxKc1bo3HSZA01btg0i18qZy1poOfJ7Pyc3Za0/qh1qs
	2Pm8pZk4Nq+O1HIeRYvxmQeE7+dWFZcUpqpCHlZrnwTOabaIm/CyOg9fu+ptapbp6VWe27
	p+Mof2LdCGf5JWURyYJZlJ2qp69rtFM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=OxeJ76x+;
	spf=pass (imf03.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767951120; a=rsa-sha256;
	cv=none;
	b=Nnt3PX6y4KGUeogCEK4YJLNduOQ596BeO5GIzRm+sj/X7N/1yWJerURpamqpQ+YPfCJKkG
	9+OjIZMO4hv17BRQoDIeErZlVtwY9AfLULAl+J/ecPaBW7xXVZ/ahs+HbR+NTVg+90B2W5
	bJ0DsaWEiNP1970DmqrjL81tWhYfhfc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=5ju413pk+X7OZOjx7Isz69EdS2j8wMMLZdWEnm2KwEk=;
	b=OxeJ76x+Ft0GO46Y63/oQb9vbNDWyxP9/wkzY/cQtIX1DHdwFWKWDljZRlZ3glE5502FWYltr
	vv1fmOslpZVlSrL88Pur7ilqgajHEfflN2/bwEoEYk1MqAiHilHRxVZwfQALp0XYatuHtbNpoAi
	v47jcFKvUknad5Np+YOfFb8=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dnc0L3642znTWV;
	Fri,  9 Jan 2026 17:28:50 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 868A6402AB;
	Fri,  9 Jan 2026 17:31:53 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 9 Jan 2026 17:31:52 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, <broonie@kernel.org>, Claudiu Beznea
	<claudiu.beznea.uj@bp.renesas.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v6 2/6] mm: page_alloc: add __split_page()
Date: Fri, 9 Jan 2026 17:31:32 +0800
Message-ID: <20260109093136.1491549-3-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260109093136.1491549-1-wangkefeng.wang@huawei.com>
References: <20260109093136.1491549-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Stat-Signature: qwub8pypcbjr4syzn41ry8mes6nj17w9
X-Rspamd-Queue-Id: 152FD20002
X-Rspamd-Server: rspam04
X-HE-Tag: 1767951119-729497
X-HE-Meta: U2FsdGVkX18p++d0P5RV+jjLXtzjZ+5dYUDsKXw8vFmkBQw7th4OGsnVWA4ttl2aFdTzj9qRUD/0hRZwBIycrtK213Nh8jzmXgtOFpgBaJ/GfdUJAKnWWO+0/apNt7OVqUbdqAG4yDZNbGmFahIPwrigPIVlHfZqYa9R1kBmOwN4C0fiK1C6nfEe0s+VsxrD8S6hPCC7XP3dqQ2iIITc57yHAhNjaMHhhJi5J5a13UKMLgKv/4XLEODqfdC53djP4DwxRnMLJOUwHyYX6NVGfe1B4CMrMG9oOLWRQlGLIT27r7L53IoM+gSiMsV1/lI4VWqfkPbN8cx3gJOecGRPlpb3xAle5Y5adkmM1T6K1JEvp6uoAJeNpwxr33pfJK2Qj1c599fzUPRq0fV8xBnwrxajJw1S2i7rvC/ZfnkIkKoU7e54ME9rXIaHgD3PujeqNeKh5HadgGnI4pzPsqqZweV4C0jMu7X8jCybanWd1RNqVo+j5mAfM3vyjPIno9DJrDQRfTwf9bTHwXNnLIHQfPFkDAD+Iy5W5Rk9Sf/It3BBXQCYwy65k76sHzZetfe1iaxB9iIvvqGwvdYzfxnd2J1EANBKaOz+AxhE3X8qwN+QFm0J+QVlqoRV7S6VGlp8RF13VuJJSDi9L56ORytjbDV6gf4RsBIBIjjbl8ZYkzi0xwfltUKtbmslDauU3KCzmRqNI8XsVHtvBOjK4n7kkP02lOEY9lIMxGY6Wka+n1ZaPZ7TT43djR3qDs4Nukk/hdtiYqdjGgi/vNPAywaFR8MtNquWJzbzBhYyJP4qgqBwU07GunRikr0QALyF8Tkzeb9MB2fhS0q4/hdJvYiv58QtyJyllkLDH45o1JLvMszP9bjVHJ3RnS+/r9IA3PW7g3thBMaXCjJqrqFpv0WPFojXyLCjkhXoGEp31DxxhewjXIUAuf0eACE3a6SwgOe6YvTryV68z09MEk8FJOy
 YmdUntB0
 WY4ORfslUTFpGW+FovxowK6gjW8MKtL1tM9DJdhneyNKeVSvvEdzazpXfpPiyy1zWuNJ6Ijp6EZpqS5mLGti8Kuau1xqCNxGojeNRt67MUqUx6X0L7FjBSokd0maDs8pXa2p7Bng9Xk6hh1sBmOJJnqfCKgqm56Ic38zfj2KSEbF5EM8CpwvvZwGyEMjftMzcJe+G1LZN84/ziLSHbEv3/4JM/+SAABsKjjvpAngNFra6hMJGPnQG9tMbrcOHVDNVszi10v23TJfLpVBuMbdw8+Tjje7fn9LzDgJkd7b509CMOsD3i3+pdvEd4ipJu89beuTrvZFPrP8QUGoPGqlo5riN5LjqddHY8VQj47v3BuVFAk66a84w1rtk7RJhuHul152VbHWysNXt7zK1B6cC2QrF3e8vyPUs5Yx+pIf4+Syss5oMo+2DvlcY/zqAkWL85Xs1xkH9nZ1AObO1RjxgfOuxm35EEgQZyF23jEc7oUBidYz3c+yMOK+zQFXwVVCryZZRZO2BW52qyLwmm33LTsEyRzzGuWpcuqcze55XFfumyevfU2y0kstKaBvIyBfReZ3r
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Factor out the splitting of non-compound page from make_alloc_exact() and
split_page() into a new helper function __split_page().

While at it, convert the VM_BUG_ON_PAGE() into a VM_WARN_ON_PAGE().

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/mmdebug.h | 10 ++++++++++
 mm/page_alloc.c         | 21 +++++++++++++--------
 2 files changed, 23 insertions(+), 8 deletions(-)

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
index b0eba56a40d3..2a16c2833439 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3110,6 +3110,15 @@ void free_unref_folios(struct folio_batch *folios)
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
@@ -3122,14 +3131,12 @@ void split_page(struct page *page, unsigned int order)
 {
 	int i;
 
-	VM_BUG_ON_PAGE(PageCompound(page), page);
-	VM_BUG_ON_PAGE(!page_count(page), page);
+	VM_WARN_ON_PAGE(!page_count(page), page);
 
 	for (i = 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
-	split_page_owner(page, order, 0);
-	pgalloc_tag_split(page_folio(page), order, 0);
-	split_page_memcg(page, order);
+
+	__split_page(page, order);
 }
 EXPORT_SYMBOL_GPL(split_page);
 
@@ -5392,9 +5399,7 @@ static void *make_alloc_exact(unsigned long addr, unsigned int order,
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


