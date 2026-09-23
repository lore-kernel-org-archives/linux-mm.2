Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78819C982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 11:21:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 843C46B0093; Wed, 23 Sep 2026 07:21:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F4AE6B0095; Wed, 23 Sep 2026 07:21:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E46C6B0096; Wed, 23 Sep 2026 07:21:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 441886B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:21:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF317A0729
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:21:20 +0000 (UTC)
X-FDA: 85244785920.01.89E020D
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf18.hostedemail.com (Postfix) with ESMTP id 738A51C0008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:21:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ahMOEPjT;
	spf=pass (imf18.hostedemail.com: domain of sh_def@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790162479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=D59ll9Cqgn4VIwMdD2H3ggT0fglPHG03tnHtRxDpyso=;
	b=OxTf1ADLddomrHIdj1dgxubrcqcxhc3zVRS+E8sLUT0GmcgxiZFt+Hz8kKiPlvwCosL3Rw
	pVyyr28KfzfV4I6jbdqPxqMTyBniBpMQ6o+OAFuErZdjFmetUPTXdxkhqsUSyGXFFKQffy
	dhn2G7P1O9A3S6tZj/rtuRviOZY84SA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ahMOEPjT;
	spf=pass (imf18.hostedemail.com: domain of sh_def@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790162479;
	b=UHO8h2yJG8xltDwq3kLC6TH3D9LMMyOJ9x3YHB/xNDkQKE7sOLB4FND+nXrthk0ZkhtMI1
	mLA7vJFYYpBalwlfgQZLwlC5SliEtZiXbDdnU2NRI0Qk05Eh+VRCogZRBivEUkxtqH0doK
	oXu6ajMkfdVg7o2hdCUY1mNSssW5GBw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=D5
	9ll9Cqgn4VIwMdD2H3ggT0fglPHG03tnHtRxDpyso=; b=ahMOEPjT1wiz58wN6i
	GaFqKzCkFYIdEG3J876IqJUV0WHafDPhuqpRjlNegc54ua3WCl462yA/uYD7Tc34
	9AQBYeJgj2Rlwbj52x7ZYHjnazKwJGdF33PmPc/N/TXq3vDWrqep0lrnKBpHGDfx
	L0mH/jcBmGvqB7bnNsBo6F19M=
Received: from localhost (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDXn08JtrNqnlFPAQ--.25126S2;
	Wed, 23 Sep 2026 19:20:42 +0800 (CST)
From: Hui Su <sh_def@163.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Hui Su <sh_def@163.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] mm/migrate_device: consolidate compound folio handling
Date: Wed, 23 Sep 2026 20:20:41 +0900
Message-ID: <20260923112041.2103427-1-sh_def@163.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXn08JtrNqnlFPAQ--.25126S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxtFy8CrW3Cry3Aw13KFyrXrb_yoW7uw4kpF
	40g3WDtrZrWryjkw13Zr48Ar13urZ3Xa1fKFZrGwna9Fs8JFy3uw1Iq3Z8XFs8u397AFyx
	Zay7ta4xu3WDJF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piHa0PUUUUU=
X-CM-SenderInfo: xvkbvvri6rljoofrz/xtbC6Qs3lmqztgsF1AAA32
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 738A51C0008
X-Stat-Signature: 6j75yfe38ntjoq7mg7puw6bhwobyt46h
X-HE-Tag: 1790162477-76519
X-HE-Meta: U2FsdGVkX1/O+N2H/rQ/nirEkecm+fApNUg8gv56tp4Runqf+5D8cajVN+fMYr7uf46r4ZWwkZhoUvUGR7wL4U5kskuDvDFN4AjtyPtWndRZLT5b+5PBsILRuWlKLkAd0RwvuyohJk2RO3cvAHj5KnAYldm7zOyB1JJs3eDU0R2uugyZwORJHoOnswWEFXOSr4/DfVbzc18QOE8Fk7nUFlh1p8io1oIxknhMWbUBANZv5p1TfToxV+HHFr1SjQSS4dIwM8X+DtsNfy5pir5jgEibTYhpp6DywZ9lXxMbXb4/qEOHFTPjointO3z2jsQkaCkjDUo1/RvB2tGsWjz29gZRviCkpwdGpDGjWf8P/c66/X88TAP+one7cHqxgfyPV9UaqG8NaJUo/w+DjVyGp6BJHcRoOUrVTFr1xSiZGJ8MVe4qBGPXoNtHQplFS4wAOx7NtYWmues1bRrVdup5a6gWSXmasM9WvFFjMxpNDdz6y9LsbKeiVpCeKhXuOsgQA/nyzn/9rvEkq1qW2kRgdhU2PvPdh57fpbZ+WM8nvddB31Fl1LkJpN5Hq94OIifH3GJn0NQMv1GN5em8gWnEh9S/zcWPEHl6AzP20IuXHamX3V1Ye2XKk0jmKcj4odvRwnX0/8oPpDz1pURTI7ugMqJUgYtrPrD8oEDDyVsGGE9+VEKkO9QPqG9AJokwUJ53bas5dMM84Lr0KXIjdZr6k1TEMvEN4Zus3qFA1RN7U5Wj4z/9tFpdn9CoiDaOSbHxTqTwNAL1TFx1zX3IbOkU7HFYn075cmbuL9kkg9TJmRCb4RajyJ4LDgIeyu1DbCQFDjV5d3Xqo3tTsrk0KfIWd8v9SkeNb4WeKmaTcQnyLGE0F7v5vQzkzvH2fUkH/Zje+3EuDNTUVzIqJynI5CoML8S+OBCiPdvLNPXNwqfFiDCs1dAX8fkELlkjKHLqRE+ee7S5ascPPCeLKD+Pca1
 pCzeHz6L
 109XkOBH+bOklAs/n7GSPiY/OaBv4x5Ljcnx+0b3VytV1XW7o6W4Q3y9mA2pbNc/1Gxkw80zRkC7loAbEk5vcMPTefxJzfC7YGTHU9YK/GStXdVku25SBQXgBY/gRwRTZiXHy7DYB/XuQTlR0QOHvoohQ+JTazVaOOAyXyK5RRjA4E5TlU8u1kkyt25ojiCzadgccZTE+9oZhsn2vbsU75Nbbaui5SfIqH/F+6Ju6b7OiMgWZWmbpF47DpPvFVKSYFPFktuzOFpzj4nt3beF75BDqLdH9O9KsCWSY4dgrSGt1FP84MyjiCYAr7pTwCd7tp/rz4M5sZzk3594IZwkwDggXTm1zIt792BbGTVNNtoX1SajrQgo/aFn/UfRzsHdqYD+H55uvUS6IePqGW9L3ilErbXw6kgY1AmtonytBJ6cerG+X1ukH8PtQMIqroEQbt6oSh3MZkDv8zeBsG4YTyfhA6k2d/3UisK1q3/9BxhFf7LQ=
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

A compound folio cannot be represented partially for migration. Use
VM_WARN_ON_ONCE() when one does not fit in the remaining PFN array, while
retaining the existing defensive handling: release any lock and reference
acquired for the current folio, clear the remaining entries, and stop
collecting.

Move the shared collection and encoding logic into a helper so both
interfaces handle compound folios consistently. Also use memset() for the
compound-folio tail entries instead of open-coding the clearing loop.

If locking a folio fails, leave its source entry zero while still consuming
and clearing the slots belonging to the whole folio. This prevents a tail
page from being treated as a new source PFN by the caller's next iteration.

Document that an encountered compound folio must fit entirely in the
remaining range or PFN array.

Link: https://lore.kernel.org/r/c99ca53a-73ef-4a0c-8738-eba1cc89bea2@kernel.org
Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Hui Su <sh_def@163.com>
---

Changes in v3:
- Keep the source entry zero when migrate_device_pfn_lock() fails instead
  of setting MIGRATE_PFN_COMPOUND, while still consuming and clearing all
  slots belonging to the compound folio.
- Use VM_WARN_ON_ONCE() for the truncated compound-folio invariant while
  keeping the defensive clear-and-stop path independent of CONFIG_DEBUG_VM,
  as suggested by Balbir Singh.

Changes in v2:
- Fix the helper parameter indentation and keep the declaration to two
  lines, as suggested by David Hildenbrand.

 mm/migrate_device.c | 91 +++++++++++++++++++++++++--------------------
 1 file changed, 50 insertions(+), 41 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 009bfa8b212d..68b787bdc8be 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1392,6 +1392,40 @@ static unsigned long migrate_device_pfn_lock(unsigned long pfn)
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
+	VM_WARN_ON_ONCE(nr > remaining);
+	if (nr > remaining) {
+		if (*src_pfn & MIGRATE_PFN_MIGRATE) {
+			folio_unlock(folio);
+			folio_put(folio);
+		}
+		memset(src_pfn, 0, remaining * sizeof(*src_pfn));
+		return 0;
+	}
+
+	if (nr > 1) {
+		if (*src_pfn)
+			*src_pfn |= MIGRATE_PFN_COMPOUND;
+		memset(src_pfn + 1, 0, (nr - 1) * sizeof(*src_pfn));
+	}
+
+	return nr;
+}
+
 /**
  * migrate_device_range() - migrate device private pfns to normal memory.
  * @src_pfns: array large enough to hold migrating source device private pfns.
@@ -1410,35 +1444,22 @@ static unsigned long migrate_device_pfn_lock(unsigned long pfn)
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
@@ -1454,33 +1475,21 @@ EXPORT_SYMBOL(migrate_device_range);
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

base-commit: fe2ec83746e501645709761605c2464a44fd2929
-- 
2.55.0


