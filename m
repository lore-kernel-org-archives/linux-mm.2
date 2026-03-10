Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03C94FCC9D4
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 07:32:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64F206B00A2; Tue, 10 Mar 2026 03:32:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 606156B00A3; Tue, 10 Mar 2026 03:32:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 530026B00A4; Tue, 10 Mar 2026 03:32:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3FDF56B00A2
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:32:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 06C61B9B13
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:32:04 +0000 (UTC)
X-FDA: 84529334568.30.5FA3BAE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4B9DA4000D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:32:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773127922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FLqFH271Y3/zw4GtdwiVfN32CFo9cT7KYB/HjhCGuJ0=;
	b=aZAmB0Nw3Ng21a4579+bNaaNULJhxStyq/uqJKdYbHxbfWB5oHGvFmJcbjDXjitYXsE061
	VUMTng0eM6ljum3qPwSk064itoCBsAAUNpXKucSzWmdZJZj+4NoKPGwcrxhtqYiyid5dNq
	qjAQphUcj+nGQCyUtYlqBJ2vNhy3zHQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773127922; a=rsa-sha256;
	cv=none;
	b=cwIvlkX2ZyCD+MDU1nUrzyYbfvVVc+Ln1i/5c2ZDDFNaqiJnAHhdvUwj83tG4+h2iWsJ5u
	fQWlFFIaDmFivG3AnlqaxzKveXAZS8Xxv5vhDhC9ghrF3vNsxSY/+r40fYQpUBxvmHsNPv
	ISjK29LUoTf5vAXAXK+QH+RyBvCpeEg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 28E431F37;
	Tue, 10 Mar 2026 00:31:55 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8352E3F73B;
	Tue, 10 Mar 2026 00:31:52 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	david@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: weixugc@google.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	pfalcato@suse.de,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	ziy@nvidia.com,
	kas@kernel.org,
	willy@infradead.org,
	yuzhao@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH 8/9] mm/rmap: introduce folio_try_share_anon_rmap_ptes
Date: Tue, 10 Mar 2026 13:00:12 +0530
Message-Id: <20260310073013.4069309-9-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260310073013.4069309-1-dev.jain@arm.com>
References: <20260310073013.4069309-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4B9DA4000D
X-Stat-Signature: okjw1o9eargb3f8io5jir99eqeei88md
X-Rspam-User: 
X-HE-Tag: 1773127922-606176
X-HE-Meta: U2FsdGVkX1+ucRpyB2x09Ilf7KVBln46hstdI/I8Gpz920iZjz06KDmZtSE1Zlm8zH3sp3hZqy7eq8T2d7uCdE20Bh4atjLrD9oAVCVUnD2Xz0DTU1sD5Kcri6N42q5KeHoHKzNAbcYU5PuhJ0Lld9dAKD9Xt4YEn+vbCxcR/W0a1lkMMcNxEa++Ic3j9XGOoWO5sTkR7+RzSM6fdqrPCSmDcfqmdXK1SOZ+LwwmFqGIovNCZqsoxL0kHTpp/YPlDjXtDkiqjK46nPyVhMsA/42obcxsxpLTtgLLcLT5qZ9OawQ2UdClyhfGR2qzDk0T6nUAtP7HlDZrDP0RM7xScpJ+p8L5GPF1lxj2AO/dcd1FuKe95dq69rJUohe89mI4tuvHMrrrW6RgTjsDysefQuBc7UcFdurcq25FhMXzRrRoRQ5xDZj8ew3S3weH6QXTMwIVZtGDvK1599GnxXF0szDehc85Tq5HHG/HiEFpXlqAlmYIXBrcRUuFqN7kPSxEkM3Ny5rQ7F0WpXm7zxxdbOXVRcq2GYJPn8dAXTpUR7K/c3CmNRI3Mgfbd8HH/rrToTkRs7q1N5Yzp2sUZjCoIUhsM/YfO5ea9yenaFakaCS8kt1YIXH59I6Cg4dhM+hZz2WpII8mlXSZY3Whzi3Naxv2kmHTc3fVv90vgJzwrwcsZo3J5FGZKlkMp/E1OUK5XOSRgsA372aXZWvcjymnvrER1zr9igg2yQtPK5PfA3hmDeEWwY/1SNeQij0bXJ90a/1wWB8Jes6wct9Df3CiW0rW8Yo3UfGyrXFLCsxplBHn81xXfpt/jmCFV40NjXmsZZ7l0qiVeiPh8pslkhEXGpzAU+R8az2X+fw+uO5n37hY6BeYWpW+1LsbOeWIAvEdCdP9snqQLKZwuyNsMpnj1xZjeRdbPe4IEpXaL8tXxGatzEaGepLc1tN20CxN6htuN13RN2SD8yFjFNg22rz
 t4R6QxFC
 G7Ggst1cVFDu1aNh+40zfIs4CWV9nzPzDtSGOGm/YSUYz/ucAL2Q2bN9KyCx2dVCniJdA5SNcHFzvb8xQwx2uCGjc4WGfE0FSwB30qSoXUR5ANUgxpYUt2BCHu/quFbE7MH/UZs+sQ1VLX/IcRJ30F8W8TSm1PYy5eIrwnO79jTjVY92yB9PCvXhybp4y1b+VbKNtNKk+SH8tdwg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the quest of enabling batched unmapping of anonymous folios, we need to
handle the sharing of exclusive pages. Hence, a batched version of
folio_try_share_anon_rmap_pte is required.

Currently, the sole purpose of nr_pages in __folio_try_share_anon_rmap is
to do some rmap sanity checks. Add helpers to set and clear the
PageAnonExclusive bit on a batch of nr_pages. Note that
__folio_try_share_anon_rmap can receive nr_pages == HPAGE_PMD_NR from the
PMD path, but currently we only clear the bit on the head page. Retain this
behaviour by setting nr_pages = 1 in case the caller is
folio_try_share_anon_rmap_pmd.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 include/linux/page-flags.h | 11 +++++++++++
 include/linux/rmap.h       | 28 ++++++++++++++++++++++++++--
 mm/rmap.c                  |  2 +-
 3 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 0e03d816e8b9d..1d74ed9a28c41 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1178,6 +1178,17 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
 	__clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags.f);
 }
 
+static __always_inline void ClearPagesAnonExclusive(struct page *page,
+		unsigned int nr)
+{
+	for (;;) {
+		ClearPageAnonExclusive(page);
+		if (--nr == 0)
+			break;
+		++page;
+	}
+}
+
 #ifdef CONFIG_MMU
 #define __PG_MLOCKED		(1UL << PG_mlocked)
 #else
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 1b7720c66ac87..7a67776dca3fe 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -712,9 +712,13 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
 	VM_WARN_ON_FOLIO(!PageAnonExclusive(page), folio);
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
+	/* We only clear anon-exclusive from head page of PMD folio */
+	if (level == PGTABLE_LEVEL_PMD)
+		nr_pages = 1;
+
 	/* device private folios cannot get pinned via GUP. */
 	if (unlikely(folio_is_device_private(folio))) {
-		ClearPageAnonExclusive(page);
+		ClearPagesAnonExclusive(page, nr_pages);
 		return 0;
 	}
 
@@ -766,7 +770,7 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
 
 	if (unlikely(folio_maybe_dma_pinned(folio)))
 		return -EBUSY;
-	ClearPageAnonExclusive(page);
+	ClearPagesAnonExclusive(page, nr_pages);
 
 	/*
 	 * This is conceptually a smp_wmb() paired with the smp_rmb() in
@@ -804,6 +808,26 @@ static inline int folio_try_share_anon_rmap_pte(struct folio *folio,
 	return __folio_try_share_anon_rmap(folio, page, 1, PGTABLE_LEVEL_PTE);
 }
 
+/**
+ * folio_try_share_anon_rmap_ptes - try marking exclusive anonymous pages
+ *				    mapped by PTEs possibly shared to prepare
+ *				   for KSM or temporary unmapping
+ * @folio:	The folio to share a mapping of
+ * @page:	The first mapped exclusive page of the batch
+ * @nr_pages:	The number of pages to share (batch size)
+ *
+ * See folio_try_share_anon_rmap_pte for full description.
+ *
+ * Context: The caller needs to hold the page table lock and has to have the
+ * page table entries cleared/invalidated. Those PTEs used to map consecutive
+ * pages of the folio passed here. The PTEs are all in the same PMD and VMA.
+ */
+static inline int folio_try_share_anon_rmap_ptes(struct folio *folio,
+		struct page *page, unsigned int nr)
+{
+	return __folio_try_share_anon_rmap(folio, page, nr, PGTABLE_LEVEL_PTE);
+}
+
 /**
  * folio_try_share_anon_rmap_pmd - try marking an exclusive anonymous page
  *				   range mapped by a PMD possibly shared to
diff --git a/mm/rmap.c b/mm/rmap.c
index 42f6b00cced01..bba5b571946d8 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2300,7 +2300,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 			/* See folio_try_share_anon_rmap(): clear PTE first. */
 			if (anon_exclusive &&
-			    folio_try_share_anon_rmap_pte(folio, subpage)) {
+			    folio_try_share_anon_rmap_ptes(folio, subpage, 1)) {
 				folio_put_swap(folio, subpage, 1);
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				goto walk_abort;
-- 
2.34.1


