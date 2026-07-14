Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 251E6C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E23CB6B00C8; Tue, 14 Jul 2026 14:08:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAE586B00C9; Tue, 14 Jul 2026 14:08:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C76626B00CA; Tue, 14 Jul 2026 14:08:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8F8A86B00C8
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:08:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07EB0C0458
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:08:55 +0000 (UTC)
X-FDA: 84988168230.24.B32FDB9
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 394E340005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:08:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MvLsoMlH;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784052533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qv8hFHlEbSof/OmPedBDHALVoDRrfi7Tqx+xXO2FeDw=;
	b=mjoIyjsHwAzKHOasW2PxdAxkNfOdzqLDocmK6vm122e8iPy1aRVf+fi953htUq9SN3XwOR
	657onYEBniRb7tydlgTH+W2lI2OHFHE1N9yDhv0bj3AEvlOBnKD/cSayQlGFiLs4jgRcxM
	IesCJA2/WaX2vgcLSELZk2KSuVkPX+Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784052533;
	b=oswrCWZHh3lG4OPKPZw+JstrCUkB3k8dEHKKvns6fUNF0D/IWtbnpmODuiIqwYH1kVcNvD
	fUW9fBGHfIkVJqMgN0KwQxDvpAC1MPch3v/CvjVYiMTcUDBtUcL72V+bsbLlTisYKyB2Pz
	ndikmhPSVZNsvPinyAkgLN+Of5LVlwM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MvLsoMlH;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=qv8hFHlEbSof/OmPedBDHALVoDRrfi7Tqx+xXO2FeDw=; b=MvLsoMlHnZki0JJPUFMHeIUc80
	HbaiQjitjDKizF+8XvcHnVtnJ2Nt3J6seFhIw2Hor+r0tjykMd1iQIOVOZGLnuOBwUDuZeZObcuTd
	BUD/uXDOh/azpheb+Wuv8PiM8bZdYfE4X82TZI33OrlMWFz5cO4DDzOLe+x0JjDoeeX12VV+cA2Na
	tnCkhCO2K9lyb3N2l0iAsMyBDRfgVWTCuQN1im7MvAhunH8i01iMwL6VIcQNrZewbAqpVE4btqG+A
	zYqU9/Sp7VJfQpZX02bYSHP4kWBq0OOHJU8x6ekSf5OxNQoyC5ZAIEHylWIUhdvR2AXru2MONLGHs
	/0EM2Cqg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjhYh-0000000Fegc-1HIY;
	Tue, 14 Jul 2026 18:08:43 +0000
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
	Christian Brauner <christian@brauner.io>
Subject: [PATCH v3 6/9] filemap: Remove checks in mapping_set_folio_order_range()
Date: Tue, 14 Jul 2026 19:08:36 +0100
Message-ID: <20260714180840.3731244-7-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260714180840.3731244-1-willy@infradead.org>
References: <20260714180840.3731244-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 394E340005
X-Stat-Signature: faezrk9jgume1yb4a7emb8ihdycoaxeg
X-HE-Tag: 1784052533-160393
X-HE-Meta: U2FsdGVkX19do/IDDxQcgE/RCKyNFfzP0HQfVEUKM63G7n7njf2SJ2gO8HS7arXw3XJJ2widFRybEM4lmTj0nP97xBObnp/dnnh47HeBfCWW90xZkUnkQ5UDsjbORISeFKp1RQZVC6t7xz8nP7Ar2jTeLDGiglMH1JJImCnwzd7XU5wip3uKLLLc/9j9EYcKuRfk9vIc9MSxRuPo+0fN14Mmjg6y+QrHRYvssm77cMnJR4AdeeA7dUY/Zt8aGWMQkQO7QCity4WDbeiJtspwrjO9hP/sYW0uDwVPUVTzSglty96KaROKdlDR+o+a04e6LGbmJJOAcCzdhjk8S164k12vdmoDh0aj04dGMXc1T856f5jSTzGEVwVQqRPyPRd43orV+mxuL7rzjxII7InRyovuMedesL9sWAFKkQ8Z1dgZyU9F1bOu4vSZEoFNY7URu+vBsUYNz4NWI0yywQq6CypfUKWMMrdMUDumCaCgqS794f2gcDk5ohwZGTewWhAc6zOhzHONmT5pPiYqmuMVHgRkw5RWTcoAaH7depzkJDCOU+L9stMNm1apxfsOS38JP1FF2gRQlysrQhepMlxC6Jyd2HsnJ1KbtKSwYfcDjJz0R87vHixh29H/ZHtotcBHcrJ7/KsfJ/fokTwYdeFrbiL/aPH6lwS+YFHPby/TfKkOgtqZKo7dUDNMNVejeT8P8lyfB0EytRUHCVZSUaNIuZTTanCDDMyiwJ5tfzajeH9VdE4bOS6R9PPD8Xx4tWTmTdCiDBqMdlkBCXazdejDrSJvG5U4uI/Rhnge8CgCAwULGHfioahmWpvFZaw/i7af7lztqhkkWUhwmLO93D/vWsB0QyJCYl0+HNxUO5Jgtm1rFYuwHR8dxibaJQe8mjeTrmdLZdZweiYA1oDwc62dARGOJvkY8She11pq+DwvVrIJHu7XSaTCVuDQxPjlbm7gENDqT61EXDzs8FioUbl
 vnYmY982
 F4RBdqpEqMyrr3tiua/WylPgigSyUkzTRgwvu+dT7GKaG6VoboylxOQV/+UFFaHpjitPfcmv+/XUDl5NPVzLtj+TDRyYv0TBqwmx6YMt/WSMO1rBO/zGe1Ev6/XWPf5DjvQPD6c3j40gGUt0Kv3T8FPjyRwbUaZH38Aa06lmEgAUyWnDSshmTM2WEOpEkaCrkOF05kkfJdod/jfFO8K0o8q14AammtEtvkkouF1Lae67JV82nykMroslU4PhTLEBJtmZpgFpeE7ZYHMmVRqm2zYh+o2L1HD+wCck6c6dYM8npyfkl0hcL7vWI8AeyzRmuGuc6YVYOO1Y5Pzmt+TmnW2v6o5IeLqF5s2D4qcOxiRktcVtJ2Gq+u0S7PhmIIJi0bo78xxhl6bozIZ9RIjFE1UTGIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These checks make it impossible to use mapping_set_folio_order_range()
in hugetlb.  They add very little value and can simply be removed.
Use CONFIG_FILEMAP_LARGE_FOLIO to mean "do we support HUGETLB or THP".

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/Kconfig              |  1 +
 include/linux/pagemap.h | 34 ++++++++++++++--------------------
 mm/Kconfig              |  4 ++++
 3 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index cf6ae64776e6..4922adf5bc85 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -272,6 +272,7 @@ endif # HUGETLBFS
 
 config HUGETLB_PAGE
 	def_bool HUGETLBFS
+	select FILEMAP_LARGE_FOLIO
 	select XARRAY_MULTI
 
 config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 2c3718d592d6..346b77fa95ef 100644
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
+	if (IS_ENABLED(CONFIG_FILEMAP_LARGE_FOLIO))
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
diff --git a/mm/Kconfig b/mm/Kconfig
index 9e0ca4824905..992e7ae0b2bf 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -843,11 +843,15 @@ config PERSISTENT_HUGE_ZERO_FOLIO
 config MM_ID
 	def_bool n
 
+config FILEMAP_LARGE_FOLIO
+	def_bool n
+
 menuconfig TRANSPARENT_HUGEPAGE
 	bool "Transparent Hugepage Support"
 	depends on HAVE_ARCH_TRANSPARENT_HUGEPAGE && !PREEMPT_RT
 	select COMPACTION
 	select XARRAY_MULTI
+	select FILEMAP_LARGE_FOLIO
 	select MM_ID
 	help
 	  Transparent Hugepages allows the kernel to use huge pages and
-- 
2.47.3


