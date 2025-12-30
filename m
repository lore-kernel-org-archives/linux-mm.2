Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E40DE9411C
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 07:24:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 188686B0092; Tue, 30 Dec 2025 02:24:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 111D36B0005; Tue, 30 Dec 2025 02:24:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E98976B0096; Tue, 30 Dec 2025 02:24:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B52AE6B0005
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 02:24:54 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1962F1615FB
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 07:24:54 +0000 (UTC)
X-FDA: 84275300508.17.A39CA58
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf04.hostedemail.com (Postfix) with ESMTP id 967814000E
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 07:24:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="f2/pAxU9";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767079492; a=rsa-sha256;
	cv=none;
	b=ceyajVk/HDE8jRom0mYCBHmzVvJXRN98nB15cB6gQT/PNHdbNnYLSX+Rr3TyCn70E57l8v
	TNWvVDAlb098rzGf18dA4qILCx/CDN+dO4hV6JimR7QD/BvI2jvaAR9J0ML4SJYbJCre26
	/+sdSoyOO7SkOWdZejiAhEvHT9psAeA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="f2/pAxU9";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767079492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hnmqvn/rVYvd9aluOTddeaa4VNANisaWVhBaLjSScsg=;
	b=lqaWAUJwwI83Smf0NEHJ+o6yCdrBK7zjGkGs1Z35vyEjULz8ABHF3wbvzhFYzxS/bT4q8c
	mRATbV6pxH24I9Xrpp5IrrZSrDrf77KhgfWfFh4ADNbhVDXdsS6+o8U5N+ky4XamflgZqE
	LPZpbmojFWDBZLP99PXzCeKsanky/u4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=hnmqvn/rVYvd9aluOTddeaa4VNANisaWVhBaLjSScsg=;
	b=f2/pAxU91MMhoLEbIEE//RrO6P4eT3Vhi5dXsnRcg33wISlMCzeZlcGk8w37BiRyKR3DcJ98x
	/ypiHPZCwX9GIiFiueYZ65T1Dvl82LQyJY9+wenSVFkImnav1N1TyQ8vb+a2sUlrm3QyCWphjOd
	93JAVHixslDzof13owkmZZE=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4dgPf96fhCz12LDG;
	Tue, 30 Dec 2025 15:21:37 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id E1C854036C;
	Tue, 30 Dec 2025 15:24:46 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 30 Dec 2025 15:24:46 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v5 2/6] mm: page_alloc: add __split_page()
Date: Tue, 30 Dec 2025 15:24:18 +0800
Message-ID: <20251230072422.265265-3-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
References: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 967814000E
X-Stat-Signature: qzeyxmzibgbibgh3htnm4jkkjf5u4ra6
X-Rspam-User: 
X-HE-Tag: 1767079491-357900
X-HE-Meta: U2FsdGVkX1+gbuLSalcgCj6sl79VgNoqsIfnJfLNQcu+anyMiuaGr3bHch5C+9ChtMl1LVuTTG6Fgkw6VzwG/XEizGFalmgShk+RdtbdOOZgM50TMfMkq2vzf9jA3aT/wb7VBdKovaRXpiFH7UFED1MHXifpu4xaJcya34rqubNMiHRTxDXYDhr1TKnk2orle00TeXcLl6rf4QeAd3MqsR3cAJ0dG/xJlgOgNuMvrkkZIaEyIUdFqRoExdlb9ICS1i6AHiitMiHXe+xsGQKEZFDh28815ZI+oG0mcXI5nP3JeNe2entF65LhzV+XSn9MD2RY0ozlkG5NkOL33ZH95auL7b/kTDKsZWpt58UvDFjVlPvNBnpDi5mDzVsDu2YeKg/poa9864qf6mQxq2UaTAOPapC6V15zy0PlKaOSUYn6CMI47E2KmHQeXdZgrAoPTO0nEx/m1xHg8q0sWxLIhRl4D8CBvOi83FjgKgn1ePvm2XM7aN3FJhnjeV22FFYNrorB2+mvh1deUvPR6duPzVdJkcSCmSzx899FsxBgGKC6FwPdSLDlzg4eAaTx93zTL8Tb3zgTxak1TUb0YQn3GCmktps+kXh7w8tblij+CtKNk3thUYJQ5MuEdwgCt8psM7NQI/kNui5jlQFE0lpjNDDdOlBtmUddF/oyKInwTqvJNqWisuFO9DTsqQZv52Lah5pSMKJu7j/MjTYtdgC2ylCntZ2sGe16IbHJikc6VtK1Ca7pXRKGdytf1ZaAK3omC5owGLeGzFNfcj+YNY34ULp5Txz/MCxJfKbTRmAf7iTgs1aO1DBqrJYH8DMdGATLEn3G9FTSkIqmo3grsmCbmbbyL/1r8i4irxflR3DGLx2q0LXCdE7hKWYrnCdO/bdGM+kKWIR1pyQT04nBbOol0VCJFUYi+4g/DKq0v875FltjCmziiFqvuEhG9uQ98KMBBkOQFLnZ65BdaQjJlbn
 r7eF2Iuu
 dmdJPCEjiQ4wUERwhmBokfMN6Y+EENeTjGaGPWL0QLhiuxxxUbmqrFlaJxX3YVxLxO+jb0+MNm9za4vhZWq7SUY9XUyG8LjSRudsMMYxGfJpUy60efjdHVFNdpEUfCjH3KjKlfVOP89iiK1V23NR96kBH5aAQEYqW4u/6+1RRVR65ts8q9smgB6pVNk7PiiOv7gCP2I7aqIjr8pFAUWm26ULrC9YaFNaDRN8fVtKZJumwOMNBD0vYYOLSSr0bSPOl7498ZudF5Td6UNVZh8jTJUztg79RA24wo17r2TJQQtsjbhi2W5BVEEi2pWWSz7vSe7PYVsG1HKeHWFL/QOWPHIumXg==
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
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
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
index 206397ed33a7..b9bfbb69537e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3080,6 +3080,15 @@ void free_unref_folios(struct folio_batch *folios)
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
@@ -3092,14 +3101,12 @@ void split_page(struct page *page, unsigned int order)
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
 
@@ -5383,9 +5390,7 @@ static void *make_alloc_exact(unsigned long addr, unsigned int order,
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


