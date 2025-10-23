Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDFF3CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 11:59:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3E0F8E000D; Thu, 23 Oct 2025 07:59:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA3518E001A; Thu, 23 Oct 2025 07:59:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0A1C8E0002; Thu, 23 Oct 2025 07:59:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 82A368E0019
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:59:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3596DBD0E0
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:59:56 +0000 (UTC)
X-FDA: 84029235192.12.73021F4
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf11.hostedemail.com (Postfix) with ESMTP id AA06940002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:59:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761220794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6Rn8fwpVvdbTtXZ2wue8g40xzet/N/LefS/vvorgUNU=;
	b=sJSGbtxkdDl1WnVPZpSYKfWVVVoZCGtE+oVcekhN2fKCYOy13DeWWnno0Yem3R1w46K152
	Ut8PBLPSmXt8WDFWB6GAxCLKxn2cKbyaGmFulwZEYAmPz6muJIMYSd1Op1hDnOrtsjRXfh
	N/xIAyyVDiZ032EUvCtqIQAkn/qZe8A=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761220794; a=rsa-sha256;
	cv=none;
	b=1aEVWcJNUyjW+zPWcPiWNGgOK43aVu8ou5p56AYiCjkbKQ7BLUc/Jlpg3OYOlhpWSaJNnA
	cTv1Mn+Od+WcfS0gMTThq/r3avp7x27fE3rWq594k9vc9/Yut7UHWCihg3TBehFdX77jXM
	faocq48RFasnTQlUCYg3Jbt290S6ncs=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cskwy3wMwz2CgrB;
	Thu, 23 Oct 2025 19:54:58 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 56DCF1401E9;
	Thu, 23 Oct 2025 19:59:50 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 23 Oct 2025 19:59:49 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v4 2/6] mm: page_alloc: add __split_page()
Date: Thu, 23 Oct 2025 19:59:36 +0800
Message-ID: <20251023115940.3573158-3-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251023115940.3573158-1-wangkefeng.wang@huawei.com>
References: <20251023115940.3573158-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Queue-Id: AA06940002
X-Rspamd-Server: rspam03
X-Stat-Signature: hio3xdcq7ranhxt76wo3n544fkurgwyg
X-HE-Tag: 1761220793-588674
X-HE-Meta: U2FsdGVkX1+SVb3aX6vVmAC3cdtrjocYxbb4pzBygKeYPhSyKcMqFbMr+HVPBQOl+R48LNjhLmsDrRplasop3sGiwH7uPmNhSqgu0YgooG1d4breR+wm630KiMzr5gD66J/xBm7hqVG2k/rIh7LAViQ+DZxWnlysq0kVr5+Yk0mpDyMSuv/+6GeCWTAojjgCvynMQ08g+TZGTIdsBxahY0iG51ocf11/fR4YwtZbD/c7nlv5qdzB+tBat3A9GpZe3Kn2rASeOF911D1u1K5Gn88Rcu33GB1gBn6BMTKjqGT37eRUsT+uU65oGTUzG5FONqWrR4B3SixvVhUxgB7S2rP+EGUQbbfqVSIa570rFuky9FtIDqxu7cW/nJ1cBsCJvnpPc1CylliOZf7YU1kcQ38PtZwjjhcowwhXZisFjKZ3RQaPCi068Hxggvob+JR98jxhColORxg2GRArDeOcV125NosDHiTm3B+2TqXsouhGanKSFE5WXwqM+zoAVBrbttGa6/t2IBIUuPvwyJVE31JkRLrQ6KYUuTLmpiiDDj91W9sFKMcFcrHZZTvsZePtlsmx8yFnU22ekHOTVypVpyQLzmqjgHgfSHxxk97SN9ZiY5oQs61WFcfuXIzxHPogFMZUjjh8FpUO5ydlNBlNiTyHodVn2LfGIYuL+9n0IohudKmjLNQXllM4FkGe7RlbKS31pBO0jbT9duwzZJOPbwStmQFDx/4A7gNrDkdFgjDwUJB1JqOzBixOygOTT5U23JBSAnKUOIhUvgWVh+/YwgsAlMFyduz3Ofpy13EoyOXT4V2riivfhjPlGzBGq9qZhO7JajuuOuLY87Ats3J7/lKsIPlPF4QZvCgKShljhO9jaD4GZPHzDFSd1toUfwFN8F67MPmobOx0RJCJeJMuOA68A9n8om9aq6Fm0ZE+huvGxx6LcrGvBxoSvcksBZwUxGE+b4yVcfJrGWAIPvF
 qUJ/ujst
 Q5vY+iZmCtWj9a9FhuEAZoWo+iz+TS1o/mDlOWixHqdMBD6A7YvWMt4b8Cvs3hhDfVkjWovuhBAegzJ0kPQd1L/USaenk+dFpOhVrFf2xGPbviOonCSdcNm7UErKDkvZ4uUvZYUJdq2D5F2ssVpYITptBye/34z8hYLfgHkwtgMfDWghsjo1uCiDw+tSK8dQ/3ZsHJxan3IZFGD/zdChwtsKcC2UmquX9Ras8gRtq5noNGSn1OzrAvJe+s4iZ0X4LSLePyA0PGGndtXQJMSLx+ytGaK2E1lQwh7wwF3pIdSkrMrs=
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
 include/linux/mmdebug.h |  9 +++++++++
 mm/page_alloc.c         | 19 ++++++++++++-------
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
index 14a45979cccc..282735a858ef 100644
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
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index aeb57ac45e22..d619c70c6892 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3082,6 +3082,15 @@ void free_unref_folios(struct folio_batch *folios)
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
@@ -3094,14 +3103,12 @@ void split_page(struct page *page, unsigned int order)
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
 
@@ -5370,9 +5377,7 @@ static void *make_alloc_exact(unsigned long addr, unsigned int order,
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


