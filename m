Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1213C88E45
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 03:44:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5A006B0088; Fri, 11 Sep 2026 23:44:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0BB86B008C; Fri, 11 Sep 2026 23:44:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D212B6B0092; Fri, 11 Sep 2026 23:44:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AC26E6B0088
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 23:44:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F7B81203E7
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 03:44:50 +0000 (UTC)
X-FDA: 85203718740.22.EC4776F
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf22.hostedemail.com (Postfix) with ESMTP id CECD9C0003
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 03:44:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=gBvc+pXu;
	spf=pass (imf22.hostedemail.com: domain of sh_def@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789184689;
	b=rNNaiQDyIToS7bqYja7gdQrR95wHea4aQBC7tRdNIpvL/U+F54G/L2upLMMykQxnGsVHua
	i6RKtzI66sGtppLNMUcXtf3SygkRCzUEpbuQihvsgRVTpAFJqkSgY2kpIP39nytXEhnaMs
	wm770T5tA/uWVXLu928clNwpuFG2TXg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=gBvc+pXu;
	spf=pass (imf22.hostedemail.com: domain of sh_def@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789184689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GjVmVH5S4Dxs6ChmY6XlrEUo+G/7AHP0A242MZDHi70=;
	b=Kz4C+kEb8WdT5PfkM4tDHok1hVN3G6x8MlZd29nHaBHDsP0txJSIm/FhNx4b6UgQiG1rOy
	fVT5AASBZ+GQpLaSX+ejMiqdQdpcko9uM26eWRv0sDNoyX+V5Ae58eq4Q2prcboqV6eJrM
	9TKZdohKe4K4iE55uc0PiMmPYtZhaTk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Gj
	VmVH5S4Dxs6ChmY6XlrEUo+G/7AHP0A242MZDHi70=; b=gBvc+pXuOrnoiSmTtG
	kzAIlnlNC6z/4AEO4NWd/lPf1aeQ43IQat+MWgWOovmemn2RZx41dH3wHEUhbeNI
	Lhaa4z31Fl6fTlhQV3dazHdB4CZVmJVqUVMFib11uIrX7sUg2Px1gifFKoReKON9
	UE8+EhDJGyRfzfzDV0KZnToDg=
Received: from localhost (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wDnyxSOyqRqs6a7AA--.33047S2;
	Sat, 12 Sep 2026 11:44:15 +0800 (CST)
From: Hui Su <sh_def@163.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hui Su <sh_def@163.com>
Subject: [PATCH v2] mm/migrate_device: consolidate compound folio handling
Date: Sat, 12 Sep 2026 12:44:14 +0900
Message-ID: <20260912034414.1943342-1-sh_def@163.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnyxSOyqRqs6a7AA--.33047S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Jr1UJrWfAr43GFyDAr1fJFb_yoW7Xr13pF
	40g3W7trZrWry2kw13Zr18Ar13ur93Xa1fKFZrGrn2kFs8JFy5uw1Iq3Z5XF45W397XFyx
	ZFW7tFy7Z3WDGF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piHa0PUUUUU=
X-CM-SenderInfo: xvkbvvri6rljoofrz/xtbC6RGa+WqkypGQdgAA3o
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CECD9C0003
X-Stat-Signature: crwk8emjfs6yogomhtu6p4bw3f53cnow
X-Rspam-User: 
X-HE-Tag: 1789184687-409457
X-HE-Meta: U2FsdGVkX185Eidr5NNSBNVNkHWZtf3JjFa/6mdSJ7StLMOQz9pAjDboeXbOeT7Hctww8MH+EmQBn1vT00IWExFaSTo/rQfSyTMZIK183xEtw7VuF0E684gUtH/ZBYPLuvVb2jj9MCS2Rf5cvI2GTBxoSiBCwMHdBrYY//bTG0hPvutXBMwiIC1LqAvpUqt0wwKRsyCaE9grPZdGfsVYLtIXpfKVJ/5TNRF7+2A2f0P52u8x9DMyCD/CK7AFXIgRbBDE4tkTj5VzCKRGX5NEqqqrw4ADattmUh8MY+4aA1rz9stz/4BFeXUSL097VIaUsQMJMO1QD/Bqij890xFiGAea2RDZp8cN2pQfm0kMpi5WtCUBH442vV3EjO95pvT3k+MVDLCw6H391j8ljoVYCf+R99K8pJo1nKde7Xv53HqS/GWNeNXjwolFrgkNUmG++9dvhghdcRnKnWu3cP5o4nR9livy6VNMZak38fAWPBCFQtl45apZqJNchDnYyxrjh/6eZhV5VHeEz217Yop5j9EZ2mq6uXwIdEe/zYS5QFZ588uwUMDdMG4rraY1DbPQRjL8G02mX7NycctOstEd2OqPnn1hZUqvTqRawP19JQyHQIuj6JIVFUv0qSXmuYVLKubTObGj9aJ2qOlb54TmhphNp7WY4DwXqV2TAtvOuLSd2dP5URznH/u+VhL1dowSR5IKSAZQuJE4sNbo570kQoXwjAGpVTCNe5ahPeu4ekch/Y7xs+8BVGZ5DYR4pbpAZSb4cAQNqKE+1KxkCpMhLaXsdP+PnvrZ9zZphCDsZ8/FMi7ZXDrBI5X6DtqZN4peYblE8CyFQuvcjGL+GaHBU5qBgRsqFWVu2tr6Sn3c8hJ1ifQJPvnMbZjySrum73/8kfVfwsW/rCiOlknDG02CtVKsi3/tOsv9PDwNZUW6oj120bHnaAlwX7hTwrIRGKA4O0nV8z7Fkeq+PqmbkJZ
 U70X1Blj
 xgnddZuiF0DGMXbCT81Niygj0hvtc0C5rtk1czB30erOIipmj8hZfNSpgkZYPZVZciUl2uJU+m1QePESzdNf0oZWiKK0MlMJB2d6kJeWs1UQs2ulYBILq1ZIHc6vHkBOnT34FzgJLhMdNWUDd8azEyRymGnUw0Zd46/Ts1UZF07uennd6E3DTHzUjRRNcJKyZUWfDcqhY8nlLrZ5GbphL3qkDo4kgS7C1vUlwGjJvRORGXEAy20C4kKLQ8AYH3zadD0NakDWmJdgRZFKFZUFqXrf/Xqqu2tHUwKZUQoJLD0hTCPHcJH4XWr3T7WhPFpcxFVEOTM5s/nksiIR6ZcJ8x5edM8O+ccN6823q8WwPDftGI2orPUTtorc6C8QSxgWKo0CzaeNlOBBU99wiarG1ZbAOsNzm5I53H1uZ9S5LL4xj+Mx8sLbGEeGt0K+U0i+NnDNNc1VKDSOAcZ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit dc41e961a269 ("mm/migrate_device: avoid out-of-bounds writes for
compound folios") added handling for compound folios that do not fit in
the remaining PFN array.

migrate_device_range() and migrate_device_pfns() duplicate the logic for
locking device PFNs, encoding compound folios, and handling this boundary
condition.

A compound folio cannot be represented partially for migration. Warn when
one does not fit in the remaining PFN array, while retaining the existing
defensive handling: release any lock and reference acquired for the
current folio, clear the remaining entries, and stop collecting.

Move the shared collection and encoding logic into a helper so both
interfaces handle compound folios consistently. Also use memset() for
the compound-folio tail entries instead of open-coding the clearing loop.

Document that an encountered compound folio must fit entirely in the
remaining range or PFN array.

Link: https://lore.kernel.org/r/c99ca53a-73ef-4a0c-8738-eba1cc89bea2@kernel.org
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Hui Su <sh_def@163.com>
---

Notes:
    Changes in v2:
    - Fix the helper parameter indentation and keep the declaration to two
      lines, as suggested by David Hildenbrand.

 mm/migrate_device.c | 89 ++++++++++++++++++++++++---------------------
 1 file changed, 48 insertions(+), 41 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 009bfa8b212d..ace543fd6946 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1392,6 +1392,38 @@ static unsigned long migrate_device_pfn_lock(unsigned long pfn)
 	return migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
 }
 
+/*
+ * Collect a device folio into the page-granular PFN array.
+ *
+ * Return the number of entries consumed, or 0 if the folio does not fit in
+ * the remaining array.
+ */
+static unsigned int migrate_device_collect_folio(unsigned long *src_pfn,
+		unsigned long pfn, unsigned long remaining)
+{
+	struct folio *folio = page_folio(pfn_to_page(pfn));
+	unsigned int nr;
+
+	*src_pfn = migrate_device_pfn_lock(pfn);
+	nr = folio_nr_pages(folio);
+
+	if (WARN_ON_ONCE(nr > remaining)) {
+		if (*src_pfn & MIGRATE_PFN_MIGRATE) {
+			folio_unlock(folio);
+			folio_put(folio);
+		}
+		memset(src_pfn, 0, remaining * sizeof(*src_pfn));
+		return 0;
+	}
+
+	if (nr > 1) {
+		*src_pfn |= MIGRATE_PFN_COMPOUND;
+		memset(src_pfn + 1, 0, (nr - 1) * sizeof(*src_pfn));
+	}
+
+	return nr;
+}
+
 /**
  * migrate_device_range() - migrate device private pfns to normal memory.
  * @src_pfns: array large enough to hold migrating source device private pfns.
@@ -1410,35 +1442,22 @@ static unsigned long migrate_device_pfn_lock(unsigned long pfn)
  * migrating pages that aren't free before unmapping them. Drivers may then
  * allocate destination pages and start copying data from the device to CPU
  * memory before calling migrate_device_pages().
+ *
+ * A compound folio must fit entirely in the remaining range.
  */
 int migrate_device_range(unsigned long *src_pfns, unsigned long start,
 			unsigned long npages)
 {
-	unsigned long i, j, pfn;
+	unsigned long i, pfn;
 
 	for (pfn = start, i = 0; i < npages; pfn++, i++) {
-		struct page *page = pfn_to_page(pfn);
-		struct folio *folio = page_folio(page);
-		unsigned int nr = 1;
+		unsigned int nr;
 
-		src_pfns[i] = migrate_device_pfn_lock(pfn);
-		nr = folio_nr_pages(folio);
-		if (nr > npages - i) {
-			if (src_pfns[i] & MIGRATE_PFN_MIGRATE) {
-				folio_unlock(folio);
-				folio_put(folio);
-			}
-			memset(&src_pfns[i], 0,
-			       (npages - i) * sizeof(*src_pfns));
+		nr = migrate_device_collect_folio(&src_pfns[i], pfn, npages - i);
+		if (!nr)
 			break;
-		}
-		if (nr > 1) {
-			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
-			for (j = 1; j < nr; j++)
-				src_pfns[i+j] = 0;
-			i += j - 1;
-			pfn += j - 1;
-		}
+		i += nr - 1;
+		pfn += nr - 1;
 	}
 
 	migrate_device_unmap(src_pfns, npages, NULL);
@@ -1454,33 +1473,21 @@ EXPORT_SYMBOL(migrate_device_range);
  *
  * Similar to migrate_device_range() but supports non-contiguous pre-populated
  * array of device pages to migrate.
+ *
+ * A compound folio must fit entirely in the remaining PFN array.
  */
 int migrate_device_pfns(unsigned long *src_pfns, unsigned long npages)
 {
-	unsigned long i, j;
+	unsigned long i;
 
 	for (i = 0; i < npages; i++) {
-		struct page *page = pfn_to_page(src_pfns[i]);
-		struct folio *folio = page_folio(page);
-		unsigned int nr = 1;
+		unsigned long pfn = src_pfns[i];
+		unsigned int nr;
 
-		src_pfns[i] = migrate_device_pfn_lock(src_pfns[i]);
-		nr = folio_nr_pages(folio);
-		if (nr > npages - i) {
-			if (src_pfns[i] & MIGRATE_PFN_MIGRATE) {
-				folio_unlock(folio);
-				folio_put(folio);
-			}
-			memset(&src_pfns[i], 0,
-			       (npages - i) * sizeof(*src_pfns));
+		nr = migrate_device_collect_folio(&src_pfns[i], pfn, npages - i);
+		if (!nr)
 			break;
-		}
-		if (nr > 1) {
-			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
-			for (j = 1; j < nr; j++)
-				src_pfns[i+j] = 0;
-			i += j - 1;
-		}
+		i += nr - 1;
 	}
 
 	migrate_device_unmap(src_pfns, npages, NULL);

base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
2.55.0


