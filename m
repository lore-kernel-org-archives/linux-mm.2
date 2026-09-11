Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1328C88E41
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 06:14:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81E5F6B008A; Fri, 11 Sep 2026 02:14:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CF6C6B008C; Fri, 11 Sep 2026 02:14:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BE1B6B0092; Fri, 11 Sep 2026 02:14:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3CF646B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:14:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B4255C0714
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 06:14:24 +0000 (UTC)
X-FDA: 85200466848.15.1354C1A
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf20.hostedemail.com (Postfix) with ESMTP id D07AE1C0003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 06:14:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=JcZNXKdw;
	spf=pass (imf20.hostedemail.com: domain of sh_def@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789107263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ITRZwaWcwWuX2g0cojXkBG3pqK5ruRtYawbd56FZ/iw=;
	b=scJnIcZf5zg1CYSVeOAH3azX114OUZUb74elSdoaP6Zd7ESvtBkklk0brGE9YL8XXd47mS
	UdDnvLauzH70HQnTTL2MD7fiBg36WjILzVbh+yr5K5QwOM1UIIF13mE3RVc8wu3itSMcMq
	7oxi6/ERE+YuDSKXenVmxNn7NHz43cM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789107263;
	b=K6EbmpAKRnUO7XfSaN8sPMSO/OggXum354tgiBnQaRIKArb6O/Gw+oz1cmVSLUFjMIebTc
	n6rEfhZZYR3xW188afB+K/CjUGcaApfd6Zdj0YuN3cGfhU7k6ufI2nsbDoeIPqQCR6rrj0
	TwAMIJ1nFONV1g8bjAXRLJoKCRZKtH0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=JcZNXKdw;
	spf=pass (imf20.hostedemail.com: domain of sh_def@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=IT
	RZwaWcwWuX2g0cojXkBG3pqK5ruRtYawbd56FZ/iw=; b=JcZNXKdwgFSq5xIa+O
	J/i8DWS40+FicY+uqWjmugO3+bzub/soJaGebkcwLgL/SVWuVWwBuHgrtlSNmgpM
	cpSagybLFU0ubhc6KO4Ch5nwTnr/+3OaP3Jg3UvQrRiIYqM+C5dCz3kNuEPzv4DT
	prkJuPDdvIDeEPQi0lbfQhbKc=
Received: from localhost (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3X5scnKNqVYkPAA--.7067S2;
	Fri, 11 Sep 2026 14:13:49 +0800 (CST)
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
Subject: [PATCH] mm/migrate_device: consolidate compound folio handling
Date: Fri, 11 Sep 2026 15:13:48 +0900
Message-ID: <20260911061348.2869524-1-sh_def@163.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3X5scnKNqVYkPAA--.7067S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Jr1UJrWfAr4fJr4UJrWfuFg_yoW7XF1fpF
	4Fg3ZrtrZrWry2kw13Zr18Ar13ur93Xa1fKFZrGrn2kFs8JF13uw1Iq3Z5XFs8W397JFyx
	Zay7ta4xZ3WDJF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piHa0PUUUUU=
X-CM-SenderInfo: xvkbvvri6rljoofrz/xtbC6R+xEWqjnB9IFgAA3C
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D07AE1C0003
X-Stat-Signature: 6k8aed3669ipgu4p8zzas8qz93r163ao
X-Rspam-User: 
X-HE-Tag: 1789107261-811881
X-HE-Meta: U2FsdGVkX1/D19y12LTSAieVPivVZWiBN2vYtLopKuVY19cryjM9TgGjXOhA+CvyKEWQ0L0XEniyxOYiBAaFnz8k7x+lLIODoDjBmWHTMSxqn3eApM2ZEZVbOJCO6rMgTmQ7COUTU4LlYgw5GbyuhEyouVSWYh4xoKQdjdMDo9MfosUVUaCcEcVCUCqlI7/JXLpKpQoBK+XpRqT5h0buUP3eAFfCFwiFUguHSAEPkYJZ8vE9ZP6JHq75w7GoQ2qVUK4PXvvg1zw0QMM4dezduRGX+Iyj9iTXr3Zvy+d5Xv3+Vj3mALbsO/+o20Lp3iAk3puogecPWJa1eMVXVjFo2fqPNIEJeJunpPPoy8oF//nmIP5Ze2pRFgscsg0HW9J6sZOnkd6/2nD9/qg+NRY4/uhDLn3iP6vI34o3GBgD2GSMKGzlqWwubq6yRMEUvr6Tp4R/IRLEcdUQbj2Fiyz/NrQUv3RCVyXUxU7aXR9CvkpgnhfUvSfRhTKH1MoVMzrgauJi23rtaJkOpr3iECz1mrG6WrxOcnpW68HuBoSPNQa35fcB9SepnRu7RgRUYSZ3/YE2M4YfF6Iik30ssS54dWM0J1XLmSFHUA5NCctgu8a7MN5JerLYHu6TUooBkroFCHbRJ5tb+kLiDw3QhHLGRSxVaMGAIbFCTPr2qC6vj5TFuRpOoL7BOBrTGKYSwRd78P7gzJz10d+ZeW7nNEWEjMvvDU8BZqFxZ1CZv0OIU26ZGZzraYk2Y0TgQplWKV8gCQfO49TwH/f0O8cRLr0sdEOD1k5LNyA6vW3yhbsxD7t8X2GA4XhxnmIi5tg8ekD5QLPSlU+4xjqRpHN3TGanvFtnK+4yOD4kIqc2qXXFI6VyH7dsZ4EVL/O4d9nE4o17AbKnhnB5zjtG2yos7whoMNfJvZzNudJG8VbKKdvnJRhHom0sN87XKHHOIU3amcqNfc9/Yvbz4CzuC4X+dGV
 LiYNun2t
 kSwIHBy5bkCn1X1zYXgqt7Q9UC1pjLVm3NGChxKp+3QaqrSY+tu9mSmx1pk+5XX/bBw900+NHtAjZcWdIUEUf74bQ8lSJwnmbP1V6c0ndsUkARMFaz2dOuPDji75SZT4sQUtltkzjbkNnNYrqgFZw+GuP7Y65tXmCjZd+b0EP7CypMyEFYGwTeb+H7vJL8yfhdEWN4IrGwj5sH1TO6UY+RId/dsKAe+Ykmzuqr0nl6PYLvHAdyrqZSsb2jcRzn0xAYFTRls2X1CERwzEJOklYdR2zFf9GY9P/l0DmcU79wi9fgdK9VuLfuHDhcKGp8ImQaT53wFoMaiJkty1FN854yRJo9531qRQc+8xnf3fKZK+3loK768VA5xMWIPmBsWXBoNMyfmGx+CEyAWYEed2pp/prUMozssq8PAHKiymWDfK0/+/pHAQNt6VJt2AekwWitibxJAvaphpYYWtFFX/NvDEC8Q==
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
Tested on x86_64 with KASAN enabled:

- Built mm/migrate_device.o and the kernel successfully.
- Ran the HMM migrate_anon_huge_zero selftest; the private-device case
  passed.
- No KASAN report or truncated compound-folio WARN was observed.

 mm/migrate_device.c | 90 ++++++++++++++++++++++++---------------------
 1 file changed, 49 insertions(+), 41 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 009bfa8b212d..c57eadea6565 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1392,6 +1392,39 @@ static unsigned long migrate_device_pfn_lock(unsigned long pfn)
 	return migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
 }
 
+/*
+ * Collect a device folio into the page-granular PFN array.
+ *
+ * Return the number of entries consumed, or 0 if the folio does not fit in
+ * the remaining array.
+ */
+static unsigned int migrate_device_collect_folio(unsigned long *src_pfn,
+						 unsigned long pfn,
+						 unsigned long remaining)
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
@@ -1410,35 +1443,22 @@ static unsigned long migrate_device_pfn_lock(unsigned long pfn)
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
@@ -1454,33 +1474,21 @@ EXPORT_SYMBOL(migrate_device_range);
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
-- 
2.55.0


