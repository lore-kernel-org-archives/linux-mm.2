Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 880FCC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 20:44:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4481D6B00A1; Tue, 28 Jul 2026 16:44:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 419446B00A3; Tue, 28 Jul 2026 16:44:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 309FF6B00A4; Tue, 28 Jul 2026 16:44:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0AFFB6B00A1
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:44:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9BD6D80512
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:44:20 +0000 (UTC)
X-FDA: 85039363080.03.8DB15E6
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id C6A2180008
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:44:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Ob4g1vrL;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785271459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ouvowIcM8jLtrmPgXBz2U3nMcb3XnRPv2XSwdzDzMKk=;
	b=vOwCPul531qu4PxtvHhKQ2rk00X/VKSBdV8eAHHNpi4EzPk/+DbNOeIk4mJqK6+pjEgZIz
	xbvs1BXllj3L4bw3Q31CYrHDah50O6CNAqHuywpNmoROrYgXUqT2y4iaxEKbmFhT7x3NwK
	+BlbYyrwo477pRClPp09G+u9NZGdLxw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785271459;
	b=3CqYjPYVkp0I+TM9ykgkwal+TLQRWIERWR8iTxWhuoNlFpHUWGJ7il6WkNzVh2zqG5ZEgw
	6cZ37h6WzuHTri3/w2S5PaTfYyM3cyVCTHQZFDeLjglaytUbSuvNikywuB61QIIPxM0TC9
	Tjb+njKEncSoKvKr6+2hICmV63rPyno=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Ob4g1vrL;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=ouvowIcM8jLtrmPgXBz2U3nMcb3XnRPv2XSwdzDzMKk=; b=Ob4g1vrLWsoi9O+qJLgBZ1nYaI
	hXynsEFaO+DnDuT1eDOQwtdYw6tHNdoCsP3GW1h2dS0yZWoSPijgO53PoCG1r4TRnAekiQb7Fmy1m
	nWZdfnYJUHgfBr3xXd3BWqsK71g2BrE87eobfRhCKbizq2R9ewMeVjQIXMysYNz00trpeHBODFDRM
	xmliwdA5R0MdKVQIXldnVkkNtFc+4Xl88qes93Z0KVxQcJGA8wJCeLL1QEPjp8HCUNT3HLzleFZZR
	Iy96iX+dSSIwrz1IOJumHaT+aFN5pRzzGOB3Tpsctxq+Z4H293VBNx6+wvAt5kgkzrLzfcui1G+rK
	a+tSpEcQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wooeq-0000000EFWt-11UH;
	Tue, 28 Jul 2026 20:44:12 +0000
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
Subject: [PATCH v7 10/13] filemap: Remove checks in mapping_set_folio_order_range()
Date: Tue, 28 Jul 2026 21:44:02 +0100
Message-ID: <20260728204409.3396238-11-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260728204409.3396238-1-willy@infradead.org>
References: <20260728204409.3396238-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C6A2180008
X-Stat-Signature: nxicaj8kddju79t7mi5hczxdob4s1rom
X-Rspam-User: 
X-HE-Tag: 1785271458-313263
X-HE-Meta: U2FsdGVkX1/LdOtZp5lfkBkRGp+qFZgPKP0jyxj6qi1bDl4Ea4vEGIak5pVbfD2c9URKyLiMQVWP9KId9IWQtIhe30HLeZ73QL7U5mOB3pq7ZMJoSMEsO7zSeMoWkDfNKOfLqokWS3ePsumUQlmGwAcYb+kGWqOf1XpRJbmsnba22Y3n1kUdgYw94/+OgIZt8VsPP5lqcDl5tj08B8u9/82OvlMRP9OPj6xXCN3/cWP9lvrRS5Hrk641l3gYE6jFfiqCRr92zCAy/GZaLYuavyeik5LDTDKlXg6RR8/lqomAOF0aTbvbZ/4/v6Wsa/+JM9kMZu234XCkhRdfUfulGuEAo7A09G33EtwQeheSTzUelOvEztYcweFHMyadr6GVb/UjTDfrqRLf55fVrb94WXL8u3A6HYIsSIctIX7kATwMFlGZVddWFgJwyTNv48pQmMHcpv2TD+nrRTVJ9tFiwbqXFyBCCoYtzwnEzqP4mGqY2jnCjHwmyKzSxZmvfHMqD3bOO12sjdvYiD0zQM0VZ3QQDHhNxa6TIvwb92pomRkbcHPhLbBFJ0OceWG8hiMti7k459KzlopRW9Bfsas2OeyZI3ozKu2vQTfxA4uYUBJzvME0LMeBy3s0NH1NIy6/dJvZV7Dd+Drn4Bx3oazskq+KmI45+n8+ggsJzs6Q0EjqqaUTYocP2rS9rzTU5x7NDMiIA2XWeU6BQTgXYt9B7zztQVKiiMqvRQT1gOjxC2hh67RxQzHwe9j7/MrzsW1TCIF8RYGzFameInM3C49J+y4TahThtU2++qA2GCBzQMNOF28EzReQB7Ib17XL+t4d5bu6tmj1dR5hM6iM9C1DQ2NBFCqpFah738MW5/VjepRif1Fr+8rXQqmf6H8wYUV5G8WGZ7Q4PWzsqDS1p6+3dTB1iKMdDNW+VLYuvyoYNXOvuHjcuTYVo1OErNd37Hxgf47NiAxtDj/fntdkuYK
 2DvaKPsR
 2b8rJBnozr8QVBtKJBBPWnPqaLPdLwiV90InBX5pBfE22hZ3l49O7qPgu2VDHPz4/TLehQOIVrJ5aCV2unjx2AdoApfTq3IlY1zm6GJqHscIenlrzIp633qw55qcLBYhOOcRRbJLCJawbwMNUVpPfHjajv2TF6Q79VL6d5FH8RrDoe3bLOasB4ydXWATXrFsFMWoNgBNogkNxCiFTUoCcGWqpgByG4zQ8sNVQewCRZ+/FuCJeQmQmWeP6lTyvgkkcgpdcgz9OaM7Nief2kP//OItN32xffuAmq7Ysw08Dty0re8CN53uvneZZKiAd+LowwYfCkpFtIKzIw7zKV2JZHWaMwAWcbakSTKLfLf6mYZDKmUq0mOHNmU6IjjCHaZ2Yf/scXk32C4naSOUV1+ECe5LL9g==
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


