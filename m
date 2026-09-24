Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7E62C98304
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 04:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB2C96B008C; Thu, 24 Sep 2026 00:13:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D64636B0098; Thu, 24 Sep 2026 00:13:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7A2E6B0099; Thu, 24 Sep 2026 00:13:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A90936B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 00:13:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 153A1401E1
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:13:05 +0000 (UTC)
X-FDA: 85247335530.08.6B55004
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf23.hostedemail.com (Postfix) with ESMTP id 103D7140004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:13:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ZjqTNrHw;
	spf=pass (imf23.hostedemail.com: domain of sh_def@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790223183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iv81RNA485adQFvrL4+HZjzDjbdgSHwKqirIAdW4HY4=;
	b=esJOe4LlvsMrr6/OL1e4DBTVuFzY5/Aly926i8jqm0oRI8tdRupjlAd7YdKQ8lzWTZni2G
	gd9Gltcbz9Jgzo51tbcwB3AGai6dsVt1nMjewnnb1wWufFMGouakF2b6EYuOszj7EGeM1q
	Hy0HYKEOf6n7zBGoWPcLcYGqbPjQmzI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ZjqTNrHw;
	spf=pass (imf23.hostedemail.com: domain of sh_def@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790223183;
	b=T7Yj2PZxFI5KGTIFz689DV7mJpE5sGK5ImPAyDsB7zwTQQ52fvLr3OIQR9xMGNQEdJ96Pr
	NDyhyFAqoBKjtwerATZNo/g+o2849AG08vT7vdXSV3burQbGkmCPFxQcV1NtfXboSeQT/R
	weG5ocbAY8jFuCWPu1iL8sZ+ikZV6TU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version:
	Content-Type; bh=iv81RNA485adQFvrL4+HZjzDjbdgSHwKqirIAdW4HY4=;
	b=ZjqTNrHwAlJ2M/cArk9hKPvbBufLBaJtptxYdQb7413DMPTmJwjJeoRfyEviU0
	kuF3Wh4Sw1iOEGSb/5uIz6/8tK+l+S0QaDGZkwe9a8AsQovXL95HSAl3Oiif0x8N
	r9T7e/mOzeJIIH7r3m4cch0AkYv/DJzJOUyYtiwsyQ3B8=
Received: from localhost (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD3X9Y0o7RqWqn_AQ--.41231S2;
	Thu, 24 Sep 2026 12:12:37 +0800 (CST)
From: Hui Su <sh_def@163.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Hui Su <sh_def@163.com>, Balbir Singh <balbirs@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4] mm/migrate_device: consolidate compound folio handling
Date: Thu, 24 Sep 2026 13:12:10 +0900
Message-ID: <20260924041210.13d04b8be24495fc593665283d2e4453d449502f@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wD3X9Y0o7RqWqn_AQ--.41231S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3GFW3WFyDCF47Ww48uFWktFb_yoWxKFy3pF
	40gasrJrZrWryjkr13Aa18Ar13urZ3Xa13GFZxGrn7uFZ8JFyfuw1Iq3Z5XFs8CrZ7XFyx
	Zay7tFy7Z3WDXaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piWlk3UUUUU=
X-CM-SenderInfo: xvkbvvri6rljoofrz/xtbC6ha9HWq0ozZl7AAA3e
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 103D7140004
X-Stat-Signature: s1x5qayu5zjnikz6kggzxzzcfybk1htp
X-HE-Tag: 1790223181-588161
X-HE-Meta: U2FsdGVkX18PyvW/n9RfjTfvHSqYXZmMpaImON+pws6YHzpqt3XOTdQza4ffBW6omXh2WCgGmggAK8Y77tBJOhoTL/4uH2IECMOUAQIlMGLIEPesWlIQ0m1ipzmtwcg4rBPR2WxK37Sr+8zuDfezWHGtD5nsnTs7ASLnnBz1HuBWTpQVKDb+DhVOwq/FVkL6EkwgFQVd3Pe60L1xQIp7NMsIp6SxJUE+wZFasWtPzV7tKde6bJ5boJuSw9AF787+wAfWTjJ7UPGLQfmRscxSWrPkCyNg3YTxiBou2wsFzSLUDeT5VeT6gAbS3qWGsJq/TyM/N0ZWhc7Zy5XV782Nz/aZT1mWYAA5ux/puGLscr44X5NxSsvl8eRjmdzofT+jsc1IAehGbhnkXtxHyZWK4YizXQriGL12wE8+HnqbguwdB1IsQyVeEo6gSUMo6HXsChGL46aoEy0WkUzWOPAqkXa7tXIiOwsSX8AN60P1IkFbqRJeExsDiNtdsqV52swmBPoK8R2hVNm0Lir172Va0MQ+XewBBqEkljPFyN91ZWfoZRaB9Zarc6JyFPTfuZ23yozSa4uVhPpik1o8vlaP+Nkh6P+YmNkhTJ1jLdlEdhPUcHP0ON8JiqaVyxJ5CeOQsxcC2csY11HO3Pvp7QSEk6cHk1UZznwVi8IWwRStkM9DpxphowD9FNe0xp5s7/Y/ryf78RdSI6K2PnM/A8T24xdpPCDcwGhHMszZJPT/6V4svTqxOkSC7uuGJkKQmGmSQA9oNbigcoQ/IaFcKpbPntPLjaXO9cs1pGLQ+exmAu6GjKE4wV8atNw+HLIQQuD/cTurh2J+XrI1R1+WSuRpwZs35mT65ED83NMGhnegVvcYXbbvORc9HSSkiDrmrmiDZDMCctgxNVDMp6DVL5g5CVZujkhR2Wo3JSP9lU5hJbEw3cC9AiAOqjHjO0YRBem5wVLdB3tgBbY530lh+Zx
 MAzxS6ls
 mbXVvzhHtV4X/BERXtSgdUTDznEGiRuZ2ED2jlioLDz2WEO23YKe7Hn3wYZAXTWyEV/ErjXgg5GwvhtDvzJ3sAZp93QQl7QudiiJmQH/qkbsgWgKzs+b9WPfRHhi4gupkmZNoQtWkVs9p4gx165g/OjJuCqmMIh5JIC9B5UTutZyGyBdebEbR0A3Jzydlj9n36ezGTRzzn9RXCMI3VQ1ywW0J8A/xRRtKb91V4Lrv4jbX3Ll1MRIwLI0Kue0yHzaoLH/okyB0iqMwbHluK6bNIlKUapRKID+fxiNH8Xp/c67Zi2e5aO1Tq3Oh9hXl3WNNmZY3CFcuDQqRXrDnfGHyG0EU7rqaNukVBPPfkwhNLi2DJpr83Ar7fhXfopfoQ40Gk69c7Csd7iDtXuorqYN9SKQ2+jSJfzyH7JPWiflS72HfK472kmr6gKg5CEnGGKiugYb4ldm8SYfl1IHrNoEqr7fVV4AH9C8btPm19u4khIkIGKiBEFuEUxukYUpXgZk1ACMp
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
WARN_ON_ONCE() when one does not fit in the remaining PFN array, while
retaining the defensive handling: release the current folio's lock and
reference, clear the remaining entries, and stop collecting.

Move the shared collection and encoding logic into a helper so both
interfaces handle compound folios consistently. Keep the reference,
lock, size lookup, and PFN encoding together so cleanup acts on the folio
whose reference and lock were acquired. Also use memset() for compound
folio tail entries instead of open-coding the clearing loop.

If a PFN cannot be referenced or its folio cannot be locked, leave that
source entry clear and continue at page granularity. Compound tail pages
have a zero page->_refcount, so folio_get_nontail_page() cannot acquire
them. They are therefore skipped one slot at a time. This preserves
collection of later allocated pages in a device chunk containing free
PFNs.

Document that an encountered compound folio must fit entirely in the
remaining range or PFN array.

Link: https://lore.kernel.org/r/c99ca53a-73ef-4a0c-8738-eba1cc89bea2@kernel.org
Link: https://lore.kernel.org/r/60634ab5-3fcc-42fb-8722-4ba6771acfda@kernel.org
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Hui Su <sh_def@163.com>
---
Tested on x86_64 with KASAN:
- 7/7 private-device HMM THP cases passed on the exact v4 tree.
- Local KUnit validation covered success, get/trylock failure, and
  truncated compound-folio paths.

Changes in v4:
- Fold migrate_device_pfn_lock() into migrate_device_collect_folio() so the
  folio whose reference and lock are acquired is also used for size and
  cleanup decisions.
- When a PFN cannot be referenced or its folio cannot be locked, leave only
  the current entry clear and continue at page granularity. Compound tails
  have a zero page->_refcount, so folio_get_nontail_page() cannot acquire them.
- Use WARN_ON_ONCE() with defensive cleanup when a compound folio does not
  fit in the remaining array, as suggested by David Hildenbrand.
- Document that a compound folio occupies consecutive page-granular entries
  and must fit entirely in the remaining PFN array.

Changes in v3:
- Keep the source entry zero when migrate_device_pfn_lock() fails instead
  of setting MIGRATE_PFN_COMPOUND, while still consuming and clearing all
  slots belonging to the compound folio.
- Use VM_WARN_ON_ONCE() for the truncated compound-folio invariant while
  keeping defensive cleanup independent of CONFIG_DEBUG_VM, as suggested by
  Balbir Singh.

Changes in v2:
- Fix the helper parameter indentation and keep the declaration to two
  lines, as suggested by David Hildenbrand.

 mm/migrate_device.c | 92 +++++++++++++++++++++++----------------------
 1 file changed, 48 insertions(+), 44 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 009bfa8b212d..34d687882d85 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1376,20 +1376,47 @@ void migrate_vma_finalize(struct migrate_vma *migrate)
 }
 EXPORT_SYMBOL(migrate_vma_finalize);
 
-static unsigned long migrate_device_pfn_lock(unsigned long pfn)
+/*
+ * Collect a device folio into the page-granular PFN array.
+ *
+ * Return the number of entries consumed. Return 1 with a clear source entry
+ * if the current PFN cannot be referenced or locked. Return 0 if a compound
+ * folio does not fit in the remaining array and collection should stop.
+ */
+static unsigned int migrate_device_collect_folio(unsigned long *src_pfn,
+		unsigned long pfn, unsigned long remaining)
 {
 	struct folio *folio;
+	unsigned int nr;
+
+	*src_pfn = 0;
 
 	folio = folio_get_nontail_page(pfn_to_page(pfn));
 	if (!folio)
-		return 0;
+		return 1;
 
 	if (!folio_trylock(folio)) {
 		folio_put(folio);
+		return 1;
+	}
+
+	nr = folio_nr_pages(folio);
+
+	if (WARN_ON_ONCE(nr > remaining)) {
+		folio_unlock(folio);
+		folio_put(folio);
+		memset(src_pfn, 0, remaining * sizeof(*src_pfn));
 		return 0;
 	}
 
-	return migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
+	*src_pfn = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
+
+	if (nr > 1) {
+		*src_pfn |= MIGRATE_PFN_COMPOUND;
+		memset(src_pfn + 1, 0, (nr - 1) * sizeof(*src_pfn));
+	}
+
+	return nr;
 }
 
 /**
@@ -1410,35 +1437,22 @@ static unsigned long migrate_device_pfn_lock(unsigned long pfn)
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
@@ -1454,33 +1468,23 @@ EXPORT_SYMBOL(migrate_device_range);
  *
  * Similar to migrate_device_range() but supports non-contiguous pre-populated
  * array of device pages to migrate.
+ *
+ * Entries for different folios may be non-contiguous, but a compound folio
+ * must occupy consecutive page-granular entries and fit entirely in the
+ * remaining PFN array.
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


