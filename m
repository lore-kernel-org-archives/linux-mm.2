Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 221EAC531D4
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 14:31:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC9306B009D; Thu, 23 Jul 2026 10:31:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B79DA6B009E; Thu, 23 Jul 2026 10:31:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB8296B009F; Thu, 23 Jul 2026 10:31:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 876936B009D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:31:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1B35BA11DA
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:31:04 +0000 (UTC)
X-FDA: 85020278448.02.FE6AE99
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 85B1014000D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:31:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Ry6u6IeF;
	spf=pass (imf23.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784817062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H+0pTh0RBBzp29dclQVhPImRa45jGpqQ8sF2JtQbo/4=;
	b=vuqImoh+dFe20Dy6FQkANWXBARvCgrbvmYaSv73mAWuIyOCB8dBkDUDt6CB8NIGM3VUxzB
	2FfhnEs3zJdrWj2oBPbvRVMDFaImdY0yV4cNAfyqPYVU01CwGki5N7xAoW/0YyqjTufaLk
	spRWsdar96Lix8s/NrbByJd8aY3PRmU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784817062;
	b=KDTVvrRCCuR90tJ4M9PsXr9PAzcQpiFq5k04YhLWOijMbS+KSL382JaPILrAdrtZD1i8ab
	4dWL4KXSOrpU80vr9Vk0TzoXEtbfKq9yqsxer1LFoUZgTFKoOQOgcvAVtQSCchJl4Wr9cA
	SWkFyfCxWGrZLIh/yhpYekpF/P/WU2Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Ry6u6IeF;
	spf=pass (imf23.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=H+0pTh0RBBzp29dclQVhPImRa45jGpqQ8sF2JtQbo/4=; b=Ry6u6IeFS2Y46r4OEm2zrFMEG0
	x5KmKX8KHBRzr086fM7HpbrI2pJtmQAgZHu5zsVB4LQHKwgWxUaXe7yCUBufnbOgYMA2MwIAYhLr0
	edfNBymxBvN7G6MBSQ5zd4toOnJVtyt6K5jGHFCsHDRAzJ9uXOuGfAzugb3q/glE7RwUyg9TPeEmi
	/cKFvrrw1KtcKr6t+aTzwXk21n7159wMvyYO07Li3AjGK2Tvy5plEE1eYvjrFgdYPj8wJFrlwDvYp
	Vh//wUkBLPWGONawRazFJ7cCDHhk2y/nQp8ThqaamW1kPm3wL6/f6zRxUxlSYO5jIsrF3Fm896eDj
	4KjBfymA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmuRZ-00000000ji9-2Qmb;
	Thu, 23 Jul 2026 14:30:37 +0000
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
Subject: [PATCH v4 11/14] filemap: Remove checks in mapping_set_folio_order_range()
Date: Thu, 23 Jul 2026 15:30:28 +0100
Message-ID: <20260723143034.175661-12-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260723143034.175661-1-willy@infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 85B1014000D
X-Stat-Signature: 4f8c9jkmtoqunxr89pxqe148jmh5oecc
X-HE-Tag: 1784817062-571369
X-HE-Meta: U2FsdGVkX1+y0VbQL41NyerciRV3kNrPF0BsU7M5IRJTpVAPBpwxFkHL3LLUlN+qZL+mgYn/D21FMRgs4wqWJcMZfuVcS/fS4AnHYbCXhUo3PYYzEE8Ibyv21EpB0WtMjr6SEh6T6VcJXM49vhGomUvfhjQ48F/0ExOk/ZmokBdkAvEqVVXbIsW8MFKxJaSicNuaF6yFSnld0OmEEjAhUN+lDsongl6ZEgAS+1RUCeev6g9TAPCWVkaUKrrI8rfhtCM85irWebEGepvY2exwmGyOIWRmXA2vc2vYflgdWqpy7ED+rkXZ3AT904DimrdTPn9ei+I1plGQcOrq8jtMaPYtq9owOk3q3vPHwRPjBNX+waTIszNWIvmv30sCGZuQpY5oPYQwz3TIqb0ESorCR+Y64CqNCNmNZTuzFgi2iQel1uoa486ipnxLKc98/Ac72OuIAg6RervwDlAjvuoNvGBKu6exOfjlA2ucu6uM/JY0dz4c9RAF5VgFv1/RL0qAsCBG7bhKUKZkgrWWYxR7R5cNRRUQ2XQFhgRg0X+19BCWW7pmLKMN/qqH3eX6HWeQ0I6aSG1msmzvuKfXRdaugYhOj9LDc32of3qmKjCKDsSG01lGPR3hTg4YzIN7c4MY8GFMoxjyFHiQYinW1196QM6fD6wAIFdklgonIH/3RP6XoXD5SK3WrkAbXzL11CBEIshB046JaaJb3I1qi1SJCwguSOFrGhfifuE4S0sAQiB4HZLaxh8s32g0VfobQBgYaROgPyTpKILQY79y2Drh5zmtpraKnvRwIsEFDspfNZuggiPP5BdIf1asT36cTlKiTJaaV/TOG4D0CwNBNVa0A6DX5asuNrg4R4Z+Sqacbbx8Kp9nCdpSv8kyxXNCiNo+6qK/Np3KtVyJdQhhZi4q2Ud8bAidFkmuSfW67JoleIEpxNxF+lODhawdYLymmDFW7A9lQb79QOx9TecnXss
 6M/1p8fC
 NU9tSGfvNxDXsV3PCR2iTxIxfmb6P2A3+eapzLEcvNlDWf7LAjEfMXNz5/+HrUEIIYqLQX6FSjUUnsSoCgFhYv2GdG9BdJKOHIEOOiZJTK/wFwzbz7lo3SqNROLThETu8upKllaV6DbAgH1gg6GQZwKS0lXsSRy74KJurFk3cEwSjTCyhULUqkYnTjMMu9w0HWfVfewovOl60ob1WnvJrtwkW5JDPh3f+7MdS2BBFsz8UiFoHx1MjR89TLFugsxUiTls7Jg0KXv5KdZRZ3PCAcEXj2vyqDFTEE/IKhbTKFRI5oqhz1UUxwgL5WOavlJv6EkSKnzeEI4EMLDQHcbzMMTAnKubMjq0TJiWh4mtx0SRvYnKtK3YEsBKLgp8VedSu6Pn3tLH6f7QlhpoOraCG1PWMag==
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
index 2c3718d592d6..436987f47aed 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -373,7 +373,7 @@ static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
  * assumptions about maximum order if THP are disabled, but 8 seems like
  * a good order (that's 1MB if you're using 4kB pages)
  */
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#ifdef CONFIG_FILEMAP_LARGE_FOLIO
 #define PREFERRED_MAX_PAGECACHE_ORDER	HPAGE_PMD_ORDER
 #else
 #define PREFERRED_MAX_PAGECACHE_ORDER	8
@@ -394,7 +394,7 @@ static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
  */
 static inline size_t mapping_max_folio_size_supported(void)
 {
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+	if (IS_ENABLED(CONFIG_FILEMAP_LARGE_FOLIO))
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
+	if (!IS_ENABLED(CONFIG_FILEMAP_LARGE_FOLIO))
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
+	if (!IS_ENABLED(CONFIG_FILEMAP_LARGE_FOLIO))
 		return 0;
 	return (mapping->flags & AS_FOLIO_ORDER_MAX_MASK) >> AS_FOLIO_ORDER_MAX;
 }
@@ -468,7 +462,7 @@ mapping_max_folio_order(const struct address_space *mapping)
 static inline unsigned int
 mapping_min_folio_order(const struct address_space *mapping)
 {
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+	if (!IS_ENABLED(CONFIG_FILEMAP_LARGE_FOLIO))
 		return 0;
 	return (mapping->flags & AS_FOLIO_ORDER_MIN_MASK) >> AS_FOLIO_ORDER_MIN;
 }
@@ -524,7 +518,7 @@ static inline bool mapping_large_folio_support(const struct address_space *mappi
  *
  * Return: True if PMD-sized folios are supported, otherwise false.
  */
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#ifdef CONFIG_FILEMAP_LARGE_FOLIO
 static inline bool mapping_pmd_folio_support(const struct address_space *mapping)
 {
 	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
-- 
2.47.3


