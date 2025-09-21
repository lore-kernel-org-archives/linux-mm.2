Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E463DCAC59A
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 05:45:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FE148E0005; Sun, 21 Sep 2025 01:45:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D5508E0001; Sun, 21 Sep 2025 01:45:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14F2E8E0005; Sun, 21 Sep 2025 01:45:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 03B2B8E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 01:45:16 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 89DE585F05
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 05:45:15 +0000 (UTC)
X-FDA: 83912169390.04.185CAE5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0A5B2180011
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 05:45:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cP7+OzSC;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758433514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d09I0gx0vM2ABW2lViaaLBreri8ZnZNeoLoezLCj/18=;
	b=v1l5uOeQJ/j6FZ94qBN0Ij//GehCw3Yj8ZPfH2/XWFNKnOfs1rJ9j+oiahWK4hSC14XPcK
	Dkl/9PG0ySZWcPJSb+vMw0GkWltQZuHsZUFd2mrdz8rG8iZwD05/K6EnOe0OHtABzXWls3
	j3/yp+PSidjP2A7wNgtnKPM9i/xtHBA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758433514; a=rsa-sha256;
	cv=none;
	b=DxOwuCSz3+e61Zou5cqVQEqSRvU8EOuzp0JdoME38F0sc+E99aOc1kADDuvkMRQuaz9Yxm
	5QF1DUHWNcZYUlaVhYEnoa8poq5D5L9pppv8LJuSPwud3FzCpdS+d+nsgjMWX7tCzWDihF
	lESM8O+sr4ggGTD399QLYxBE/FxjhrY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cP7+OzSC;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 843CA600AC;
	Sun, 21 Sep 2025 05:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36412C4CEE7;
	Sun, 21 Sep 2025 05:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758433513;
	bh=CO7FNMIzfL/eCqrPH8bakqiqnseo/pXbiUH3kfW/r1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cP7+OzSCDmtZoUwnaIa9QgC/3G3YIMlw+CgaaUfOdyEyR5wXl6Jo0yazZNiYfy86u
	 20FRGejyMcuuTEyFGRFvmN1FUaBbXLRDVr8gvoH8Bc2E+IA6P9A0TCNL+0TP/7inTR
	 uZwsne8BGIG3lPC0pJlYo6aJpgzcz7jcsmXk8P943xdBtbMhMuUL2nwmqCx3MGRpid
	 b020Orae28Q+ldT4mxsyvC9St9IESBAOUr95lEYNmFOlj9bssmjbtbjX69dMbREZKk
	 uV7mlUxjLhb48KL77rWLAtqjBAeTcfWrtPTtUr2ghzZ11puNG2GzqJqc8S6RxjdnA1
	 61O2BHRIUQ+WQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Chris Li <chrisl@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 2/4] kho: replace kho_preserve_phys() with kho_preserve_pages()
Date: Sun, 21 Sep 2025 08:44:56 +0300
Message-ID: <20250921054458.4043761-3-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250921054458.4043761-1-rppt@kernel.org>
References: <20250921054458.4043761-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0A5B2180011
X-Stat-Signature: 16yyr5oyg9cggstj5uohh9unfxoiyetr
X-Rspam-User: 
X-HE-Tag: 1758433513-190342
X-HE-Meta: U2FsdGVkX18yhBdhA4cH4cpOs2yQBM57uYFD9dfwwc1D8Mlm3F72FXYTsXdphfg1RKall1TFnvfdcRLbuICJfzRYvpE67n1owMdp+e9c7gL++P/TZIwG/vwUzU6o66jhdCtFvSRHX9BgVVoTWlrvHwm/lppfBO21YFHsbcD5VJd0xCoE4wGDMRCjEQ+9tdSPUKAm0AGJaouFASmvbKuelDn/bEQxkHdikVTRz/CMvxRJyWJ1cnFH0QA6gr1ECrYTzmQAO6zr1gBzHJUy4CdAO47ZOWfYYeO8jT0Ptj4s707WEEmiQ4NRWjXz9H8cEkjBJe8j6Z+GwQcuCYAZegsWu1LG7u6iZaTbMgKAGgc6e3lmuX7SdlVUkr9nQqs61gSLdAVg5HDWdArsk3yZqaK1hP0CMjMzEFfgvQWTCwFLXKnqxcLbb13Z/JR75RFzTFUU5E2wIVo16+DzCsib8E9SllT5KgaH5Fj/JGuZpZQmLts8Ghtufwh9LtayuwftM0eYP+bpogPCESQc8japf1YSZXjmdKERIicXzFiHoXsKf7EBUW6iB40IzuRgnl1T/GZ9dgEtErUTsvLW5XRQXfhKAQi4dD2VrwVELnCZPp5spfBTfUOSuwSQdKOYCYUfjatHm+NqRSEv2Xk8rCK40WEcxlBeYCjNd5GPmOGzRhHFX1tHmIAoEw8Oza6/pvN3FOtt+0D2NMXlHWOJEUtIahzZ6Tn/w+TttDGrhSN5kkeB+nMoB8I5RqviO5SfPkjWHF79wAVr4MEdB6hnQ9BycDhZeEVvC/kyDZsxrNoCPfmb8z10P0rFwcRFo7upuPwBjF1v5zvcJyjs87NfljcseFIWbiYv7Bh+C4gYkBDQvTrO1gL9dUOoPvkY3ZSpGeosr04ZxyHwQ92eVUCKaEPH3zv2p3Zx62ARXOXzIg9LEYvaePxSZ/BRTkhRc1dLGF0J/AzwEPWlWNS8WT/ElzYlZIp
 LPP4lykv
 8RyGMaJTstTQX/HfEs/YpkY9Q48rc1E5pti5xAH35UUkDtR0u9gNpxHx7OLBGp+d/716kcoY9ydy6tUhisWGaUeFq8ZzNGQDD4sd+XG/JdzQNYQHMxu+YBnSYHCT7kKgiL/EstbFRcFykrE5LhcxyDkkygEbxJPdXcvncFpbI2wrHOwtKkty4GgHAh4+m/srWVG9pQoUbSMv8gKNEnKP+JKbY6iMMxDkrvl51RJcQ8kKzyEjh65TOTj7iedFVhjdxKUln5pVCgmET/IGZrx1loa7I6d9wvI/GaxGzO9cl0WR480lGNQyIJhoPlEXZazk9bBrR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

to make it clear that KHO operates on pages rather than on a random
physical address.

The kho_preserve_pages() will be also used in upcoming support for
vmalloc preservation.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/kexec_handover.h |  5 +++--
 kernel/kexec_handover.c        | 25 +++++++++++--------------
 mm/memblock.c                  |  4 +++-
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 348844cffb13..cc5c49b0612b 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -18,6 +18,7 @@ enum kho_event {
 
 struct folio;
 struct notifier_block;
+struct page;
 
 #define DECLARE_KHOSER_PTR(name, type) \
 	union {                        \
@@ -42,7 +43,7 @@ struct kho_serialization;
 bool kho_is_enabled(void);
 
 int kho_preserve_folio(struct folio *folio);
-int kho_preserve_phys(phys_addr_t phys, size_t size);
+int kho_preserve_pages(struct page *page, unsigned int nr_pages);
 struct folio *kho_restore_folio(phys_addr_t phys);
 int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
@@ -65,7 +66,7 @@ static inline int kho_preserve_folio(struct folio *folio)
 	return -EOPNOTSUPP;
 }
 
-static inline int kho_preserve_phys(phys_addr_t phys, size_t size)
+static inline int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 85f1bf38b123..fd80be3b12fd 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -725,26 +725,23 @@ int kho_preserve_folio(struct folio *folio)
 EXPORT_SYMBOL_GPL(kho_preserve_folio);
 
 /**
- * kho_preserve_phys - preserve a physically contiguous range across kexec.
- * @phys: physical address of the range.
- * @size: size of the range.
+ * kho_preserve_pages - preserve contiguous pages across kexec
+ * @page: first page in the list.
+ * @nr_pages: number of pages.
  *
- * Instructs KHO to preserve the memory range from @phys to @phys + @size
- * across kexec.
+ * Preserve a contiguous list of order 0 pages. Must be restored using
+ * kho_restore_pages() to ensure the pages are restored properly as order 0.
  *
  * Return: 0 on success, error code on failure
  */
-int kho_preserve_phys(phys_addr_t phys, size_t size)
+int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 {
-	unsigned long pfn = PHYS_PFN(phys);
+	struct kho_mem_track *track = &kho_out.ser.track;
+	const unsigned long start_pfn = page_to_pfn(page);
+	const unsigned long end_pfn = start_pfn + nr_pages;
+	unsigned long pfn = start_pfn;
 	unsigned long failed_pfn = 0;
-	const unsigned long start_pfn = pfn;
-	const unsigned long end_pfn = PHYS_PFN(phys + size);
 	int err = 0;
-	struct kho_mem_track *track = &kho_out.ser.track;
-
-	if (!PAGE_ALIGNED(phys) || !PAGE_ALIGNED(size))
-		return -EINVAL;
 
 	while (pfn < end_pfn) {
 		const unsigned int order =
@@ -764,7 +761,7 @@ int kho_preserve_phys(phys_addr_t phys, size_t size)
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(kho_preserve_phys);
+EXPORT_SYMBOL_GPL(kho_preserve_pages);
 
 /* Handling for debug/kho/out */
 
diff --git a/mm/memblock.c b/mm/memblock.c
index 117d963e677c..6ec3eaa4e8d1 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2516,8 +2516,10 @@ static int reserve_mem_kho_finalize(struct kho_serialization *ser)
 
 	for (i = 0; i < reserved_mem_count; i++) {
 		struct reserve_mem_table *map = &reserved_mem_table[i];
+		struct page *page = phys_to_page(map->start);
+		unsigned int nr_pages = map->size >> PAGE_SHIFT;
 
-		err |= kho_preserve_phys(map->start, map->size);
+		err |= kho_preserve_pages(page, nr_pages);
 	}
 
 	err |= kho_preserve_folio(page_folio(kho_fdt));
-- 
2.50.1


