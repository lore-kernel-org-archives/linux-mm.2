Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0734DC5516F
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 20:08:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F7F76B00A1; Fri, 31 Jul 2026 16:08:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CC766B00A2; Fri, 31 Jul 2026 16:08:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 394226B00A3; Fri, 31 Jul 2026 16:08:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E1C36B00A1
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:08:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 62B231C0094
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:23 +0000 (UTC)
X-FDA: 85050158886.23.0770526
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id DD56140008
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sbzhydkM;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785528501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ouvowIcM8jLtrmPgXBz2U3nMcb3XnRPv2XSwdzDzMKk=;
	b=ws0sdskvEKe67qgjdzMCcQOhxvJxMI+qg+v3/w2D4DA/fgKb4pTAre55/r32FsymZ3JtfY
	ZxO6QDJ8wKBHKSelePrQl7lb0+kDoljhUZ/o43gu3avgOZnjZ4Prff9HsmWCcP7DWE+YEV
	dxlS/WuDaErQljXNudJsUM5+KjiIzK8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sbzhydkM;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785528501;
	b=sv/jttWAcgjEsx1MX3fn+bCOGb7QW6ER9O1I1DidzEavei4wCmZ+IO56pbvqadnJsoqEge
	DtfgTY/BB6KgI+wRlS5xLeVMktWfn47JMqToju/wNTFLcT/AY4utqlQsz0U7e2jIvYKtGS
	4b2LWIfaXvGd9qA05dkZ50hjnFFLZwM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=ouvowIcM8jLtrmPgXBz2U3nMcb3XnRPv2XSwdzDzMKk=; b=sbzhydkMA/qQS9B/BefM2m8Eri
	oNaM2GVM3KoXp5QH4bmZSG+z3NqDS9wU4sSj6dMXpHJmvdLDajX4S+J/xBr8NoXtNwkC2Q1UPkDyd
	AIRkO4UsXA7bu6vihFc2mIRgck4Mm96RjqvpBZJAOmvn/rq5tGFvBlHGfxMPxNlwm7cvwfz7HQPiW
	oEs0gxs7Cm6iUFSlAyaVi6JWIC3ssTeTqKGRCZlZkXvpyH4jVo60IMiJnGoyiviz6KA+Zc0uRFISz
	0cN0VUmmrYkjwan22HQbwFd5ylyXre46jXrv8A1UQe0CH0vvWb4zheY6aPq0Li/TEwB5CR+UhkZIW
	WC0qGZjg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wptWX-00000002Pnj-2Jy3;
	Fri, 31 Jul 2026 20:08:05 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: [PATCH v8 12/15] filemap: Remove checks in mapping_set_folio_order_range()
Date: Fri, 31 Jul 2026 21:07:57 +0100
Message-ID: <20260731200802.574821-13-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260731200802.574821-1-willy@infradead.org>
References: <20260731200802.574821-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DD56140008
X-Stat-Signature: gjgwayfsyygbxuthq3x9b1q7auh458or
X-HE-Tag: 1785528501-179379
X-HE-Meta: U2FsdGVkX1+UK6x9DB3z99HWGkIPy8jK4+8BkY5GZ+35gTVM0toHInXeMXBBBlpNjol+2tlAy3CqTL/basklvWy4iASzKpHMqK2XjNrVDi0E+OYbq/4q6PoSc8kzZnj4S7dJNfiB8cuDvxM9/rekqGidsFTQmtwKlIVYnwZKbrbCSQu+rBaXx1rpqZJ5V6uyh5i7f8LSuzu82lI8UwXOlL0hyf8j0q6b4qRDK73N8C0ufYiMjYhlJTEMCkgAshmbIL/9Wo+Y6IMUNTafoDRW2SbGzhQvjfo1BkDfZE4YuneJpXEluk/nw7bl0Pt8FnivdPC3vgGXBQRBSPtX0Z/aE/rUs+0oD1XP1h6f6xuKRYutW7UnRRehkluQ5/pInzoiZcETZapJ68fl58jZNvll6Tf73H3Jzev9nKdgtWjJQxASDTry2shRbT/xQf27OrxVNVPG6ByImi50cc7HW5JeQj5C/+uPxNt6t8Y2DBopvhX5msozP8O4siNbVR/3AF9EEDNQimYC/shueaP/noQmpG19n7TSjlXEdDo5r63Y7AHzCCflzdk7de9BDp8v2EGdvXgYtyHnjDgn2zgbjmR2jmQPKXzRC+DZjqgoHtQz68hYHh0Rd+BwnnCniyEYwGnlFV84tU218MQjtIE87GLdgAPfeRllQtnH6xgoZmeCLvrc/+3OQnHeZ3c/keXGB8cHu3k9RWx77grFWI5RaQn4o9lm/mBwKBWncOgY3ec4tTOGXcZjz6RLn66qtx0lrHu1qCS2/fbMu6Eu0LKKgJ/8nEmZKhZRnMTONPRh+Qt5xU1v8jeZI4+u+SD/9P1K6BMdaYzNp0CUTaJ1amDp60gDurPGcNCH/DP9C9uojlJI8Hi04UfxNfiJWmxs5uBb5LpekTczDctOVmwCi70ZNfb+heLHuhip959cTpBWeeq06bVUP+CfgHSEEiALu4a9ntaFsLQqP20witMYD9s1cfC
 YP6SFdE3
 e4RT0CNaCq9bhxtthSi9goLmJqyuNpiP70KTCkzjJSoY1SqKKO5TrNenuLRSPEh/9nD/7742RjtHpgIwa9U5xgpgnGKWy+MHKxgu69n/9uJss5TL1p7+J1/PVXDmjGU0MaCqUl+0zAYqm8TSfV58OnIfmUiBiptiAdDvNnaesHs7EtLt2oI3hwTf8qKrR0tazC5qY6kRfIaAb+WibcuTc9p90UNI2w0IWid6v0X0gIJPqhXqfr6g8l9e0heqp8wSjVqDzFZWDb9+sK8rMlYdGCjIFDnvlzZzNrCF6TzqiRWUkXHDSFzGl9H/DCTxtpCOT5/UkPXtS5ny4GxpuxNHBtnHyOK0h5LcS4eIZCkM+RHSnh+zFGsny5oMJxEkRGRFj0Gk3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These checks make it impossible to use mapping_set_folio_order_range()
in hugetlb.  They add very little value and can simply be removed.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/pagemap.h | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 2c3718d592d6..968b791cfd14 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -373,7 +373,7 @@ static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
  * assumptions about maximum order if THP are disabled, but 8 seems like
  * a good order (that's 1MB if you're using 4kB pages)
  */
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#ifdef CONFIG_LARGE_FOLIO
 #define PREFERRED_MAX_PAGECACHE_ORDER	HPAGE_PMD_ORDER
 #else
 #define PREFERRED_MAX_PAGECACHE_ORDER	8
@@ -394,7 +394,7 @@ static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
  */
 static inline size_t mapping_max_folio_size_supported(void)
 {
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+	if (IS_ENABLED(CONFIG_LARGE_FOLIO))
 		return 1U << (PAGE_SHIFT + MAX_PAGECACHE_ORDER);
 	return PAGE_SIZE;
 }
@@ -405,29 +405,23 @@ static inline size_t mapping_max_folio_size_supported(void)
  * @min: Minimum folio order (between 0-MAX_PAGECACHE_ORDER inclusive).
  * @max: Maximum folio order (between @min-MAX_PAGECACHE_ORDER inclusive).
  *
- * The filesystem should call this function in its inode constructor to
- * indicate which base size (min) and maximum size (max) of folio the VFS
- * can use to cache the contents of the file.  This should only be used
- * if the filesystem needs special handling of folio sizes (ie there is
- * something the core cannot know).
+ * The filesystem should call this function in its inode constructor
+ * to indicate which size folios can be used to cache the contents of
+ * the inode.  This should only be used if the filesystem needs special
+ * handling of folio sizes (ie there is something the core cannot know).
  * Do not tune it based on, eg, i_size.
  *
+ * hugetlb calls this with orders larger than MAX_PAGECACHE_ORDER.
+ * Normal filesystems should not do this.
+ *
  * Context: This should not be called while the inode is active as it
  * is non-atomic.
  */
 static inline void mapping_set_folio_order_range(struct address_space *mapping,
-						 unsigned int min,
-						 unsigned int max)
+		unsigned int min, unsigned int max)
 {
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+	if (!IS_ENABLED(CONFIG_LARGE_FOLIO))
 		return;
-
-	if (min > MAX_PAGECACHE_ORDER)
-		min = MAX_PAGECACHE_ORDER;
-
-	if (max > MAX_PAGECACHE_ORDER)
-		max = MAX_PAGECACHE_ORDER;
-
 	if (max < min)
 		max = min;
 
@@ -460,7 +454,7 @@ static inline void mapping_set_large_folios(struct address_space *mapping)
 static inline unsigned int
 mapping_max_folio_order(const struct address_space *mapping)
 {
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+	if (!IS_ENABLED(CONFIG_LARGE_FOLIO))
 		return 0;
 	return (mapping->flags & AS_FOLIO_ORDER_MAX_MASK) >> AS_FOLIO_ORDER_MAX;
 }
@@ -468,7 +462,7 @@ mapping_max_folio_order(const struct address_space *mapping)
 static inline unsigned int
 mapping_min_folio_order(const struct address_space *mapping)
 {
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+	if (!IS_ENABLED(CONFIG_LARGE_FOLIO))
 		return 0;
 	return (mapping->flags & AS_FOLIO_ORDER_MIN_MASK) >> AS_FOLIO_ORDER_MIN;
 }
@@ -524,7 +518,7 @@ static inline bool mapping_large_folio_support(const struct address_space *mappi
  *
  * Return: True if PMD-sized folios are supported, otherwise false.
  */
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#ifdef CONFIG_LARGE_FOLIO
 static inline bool mapping_pmd_folio_support(const struct address_space *mapping)
 {
 	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
-- 
2.47.3


