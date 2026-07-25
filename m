Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41DC3C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 16:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 594F96B00A4; Sat, 25 Jul 2026 12:01:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56D776B00A5; Sat, 25 Jul 2026 12:01:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AAAA6B00A6; Sat, 25 Jul 2026 12:01:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 104C76B00A4
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 12:01:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6E6601C0918
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:01:02 +0000 (UTC)
X-FDA: 85027762764.20.514405F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id CC94940003
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:01:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LLwTDJ3V;
	spf=pass (imf07.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784995260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ouvowIcM8jLtrmPgXBz2U3nMcb3XnRPv2XSwdzDzMKk=;
	b=rJY4H/3GCebOIPjx7Cq7tZ2ogX8kpksWAYrgxV+b1JqbNCDyMVVf8mApTSCpJee4VmnIhu
	zemn6AIanxa1tRyz/gQ0GcSZ2Ot2y8AqocWUwepDHhRxoBUYezkyWNRFuNkEjdxtO/niZH
	DL6YZNgMweyFY9Km3t7v21YcSFmBHrY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784995260;
	b=pciZcLchEzBTgszLfuS/8MPhE0MHCbAqD8SfUuhyNTh0CaMpLJW4CrNjqyWVY3y/O11LM8
	8sX4MI36sntj/j9Z45KH0N/zpFENh8lzxFzuDuzqDFSyVoJz0KsMRKDqV3aaxWnT6j5pJv
	V568riFayncdArhCFEsRoQtt9/PCqlA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LLwTDJ3V;
	spf=pass (imf07.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=ouvowIcM8jLtrmPgXBz2U3nMcb3XnRPv2XSwdzDzMKk=; b=LLwTDJ3Vdpn/V8OH2U8BHiho7A
	EgRQx7cATKuvjKkNpc9OO/T1CskXTuTraQpKplEnzR8OdTcTpMOl2Q67iZ6aC2UYgPJKX3w0Bd69i
	3t7dkVmKg14Wqrd1NTLRBT5TfaX0O4HEKCV+A+byRS7ImcUlvummNlUEDU3YIRN1ro1ekvm9uvTgC
	87mTpa1AkFE24b7Mg4z/Hvl9UFdt9Q2SthZ37bzmC6nz4PsvF62CwPIKHV3wlkKqIgUGO50lV0Q5f
	j8pxizxBjurx+tKzvObJyF5rZLMhzXReQnGGjm4VOhknqWL5tRXlSQU2SmK87K1ud1zJNgz9nTQof
	7AmE25Iw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnens-00000006X7g-1TLU;
	Sat, 25 Jul 2026 16:00:44 +0000
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
Subject: [PATCH v5 09/12] filemap: Remove checks in mapping_set_folio_order_range()
Date: Sat, 25 Jul 2026 17:00:37 +0100
Message-ID: <20260725160042.1557264-10-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260725160042.1557264-1-willy@infradead.org>
References: <20260725160042.1557264-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CC94940003
X-Stat-Signature: hq999nmgfxx9urxgcfmnj54h8jxuikh6
X-Rspam-User: 
X-HE-Tag: 1784995260-845858
X-HE-Meta: U2FsdGVkX195nFyXQDTpzuWVFDi1/ww2G5YtH8RTAXgEcO8MW7zi1q6CSTEzQyRoKzmKhJA6EwB6cvLpxo7PdXnTMJkeoN9BQkTOp1Dj0xx4PY6ZM01/4nHc98MPg2K8dtJOtj8h+k4cVgCpf2hBt/3GLLD+upz2QF13XTpGpWQ3TWD54G+61GxRuva6xMrVxFRiS1ReCtK1akqVTFmQ1K+79NsWDPlZwbvtLWAN8u8EnPIPzNGxLMuHvUoEuHQUgRgF6waNEOsOtvdFphQxMMtnXS55KakavLNfMhKrSWMGCyRav9mx+vKiJQJBtYi2Shh0sEDjwB8sfPs/2GpqfGRwcm81Fm77hkJXvZqAnxaXgR7iShOk8YjAi0d0w5/tB6mg9oeWj4vz9ZljwXZJhwTHSgLww8X9nyQYv+2iaCOdsGYTR/VEiGjGMdeVekW6jchQJahiLARQAQerMSITOxrELGqBW8Ra2ht3Q/gEwvz2H1zr8iNhWnojDGqXeEkNj259Oq1J0WQkDanPdfvrimxBVMGIKu74v05LBS2F7XbzICRmnvInjzfIoalSIPBxbsQiK6xgM2UC757dK4T0S+9e77d4kCLGbgr4XPD49V0vt80nBgo8s3HCxSf3pDVcaBVZb2YHTbYcFuKQwaA6RGXE81d7IgjNwoSOrvJNbWQdgNJXtvGd5n+kFAdc/YusGqREFvql5StFXT5CgBFpaDSY/deqiNCaxV2FLSD9Sv94PfzXAhsqv/7M7DfQSRjN6wgcgPsp5LpGPKnrT71dpZ+X6bMX/SEBBnkBB14574GbIwzqOitYjlpVj7td72Cr6G4bRPhquqHk+ezVO+N/nzddzT9jQP+rQfnlgprgwNQic8gPcwqihCagD33MUxc7Sf0iGMkAdKhK22XC8skUa9QjBMTeR5i548MV3nZxcI5LzYFLqeC2OnyCzXyAb/yh3Yb9/xzpsF5Dwpio4zJ
 BjVcevmj
 Fi30AoueQUPEXA3U0iiyxUFUJ9Ak5N2EhNlpolFOCWQdyQNBUzf1PyYYw0xdGT34cGTCinVdZ/D1QWAqAPoiMWBpaLlXuriWpng20XtqqP0Qkadp6P/65KHrah6em2+Of/hG481jxBOzyjzzcZ3h+Ap+aB0t6R166IEmyHtpZNK73CYfMrHhad2qBIrXAAEOTrOd2cNvvcJjK+778TyYxCc41VsKgJPA9RHRfqpyE81Pin8G7kp+zKh0fkOa2G5mOaPktAnA2JlwaW+wlLtDkjnvw9tLGVm74h4Tmkx71oRTMRFh+0GVWLBtB1HO2VkEhHQJYjrLfIJHsUwJof/2lbt0mTAJrv5jgnu9K9kFMGlnnj+zhhLi77H8o8SAmNaLv9+WM
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


