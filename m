Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4540EC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BC8C6B00AF; Wed,  1 Jul 2026 10:07:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16D026B00BA; Wed,  1 Jul 2026 10:07:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 035B96B00BB; Wed,  1 Jul 2026 10:07:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C86AF6B00AF
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:07:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 527431669A3
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:07:22 +0000 (UTC)
X-FDA: 84940385124.24.9ADC39B
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id DB59E14000C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:07:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VSR20mxP;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782914840;
	b=d7wmhnfBzODd6bB3VYt3jvdscTJ5p4PeDahrQMMlo+XvBCOE46p8/Fdawtw/eTTu8RGxr8
	ZvByUIQV3V5GKHaFvwlJZUd3fPxVjGC7h399zcue8SJA3uJycreHXyQJEzdu9skNv1DqcN
	B1gCWCwLQO+HzqgYWAUJPDKEptULebg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782914840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+oTWLw7UwF38UExEYP9OuHXWaad05pihfyj+4u0Flgs=;
	b=xK0X0+vmgbI9ZWPUmwnR02bZg1CskxVBxX3fPNdZm09o/HomcEi1vFXHXHKY2UtRKfeF/2
	auSc7BmGijUTDbyUZKBMYjwh3yBlfUrI44PHPeMMQGOlrOuap2+8zGcRsXfeOnGOIA3Gs6
	vcBA36029+LxM4unAu4qOq2agC3HqR8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VSR20mxP;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782914835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+oTWLw7UwF38UExEYP9OuHXWaad05pihfyj+4u0Flgs=;
	b=VSR20mxPyhfE0mj0ljIXKzkdvtBwXGGCPBjDGG+X1r+9yhEDmiO2Fwnpg2YmCdZjA3qFiU
	ARmhEWvOwGwgRez4vWCQFGNS4X3L4b2g1ymqpkvattNgyMjIcu5sWHw37VAB/vSPP8BF9r
	OIb7mGsX+u6jnJ1swL63SSYXMKCw4/Y=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	apopple@nvidia.com,
	byungchul@sk.com,
	david@kernel.org,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	matthew.brost@intel.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com
Cc: shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>,
	sashiko-bot <sashiko-bot@kernel.org>
Subject: [PATCH] mm/migrate_device: pin large folios before splitting
Date: Wed,  1 Jul 2026 07:06:38 -0700
Message-ID: <20260701140638.840773-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: hhzzsbms4yjx4tyx3ywx687cz54eenbe
X-Rspamd-Queue-Id: DB59E14000C
X-Rspamd-Server: rspam06
X-HE-Tag: 1782914838-236551
X-HE-Meta: U2FsdGVkX1+74y6ZowcGs6cBzKAN1IMGbsmDNQ7xw13xJocGPGEg0yUUSdfnuZk3u8vnanJMfs0PqRkqIERFR6x5SzlaH3+O1NuKWXSe4bV7EwrQosHdJjI2yA+3/dpCOMnpCgTbVUZL8peelAyZqCa9GH2JM02LkBgYO/iw9mYr6wUdTiz8KKXZW7XQUxutm3aZkA6y2Wkj0aVacAaz+TzKdfVYhR9jhE3RFGzU37/w/yMwIjj0R6s5JCvJ+Ggh+26ejCu7gY789ERETqFpsRb1LaxQfoxZ4N40ZQIpqzH7WxF9qMWOcHLsJfU8ZRjuz6ez2ZQIaMWfCYLe3mjXY1txen8s7Z/8q6IwV3391UpjfC1VatRKf9lN/JthMiVM1noX0oNl65SNSmHqDHiaKytEuf96WupAUxYGxREK8nnbKNcsSD0kIfHWcLvhTiTe0UJplbgrmFh09oFXxua183qwYKAB51/6JTzUgk4NTBRE9i5m7JcAIEFIHsNCdLjJi1fpmDbFjogXHXMxpcYy/BHqrO5kNj38++PvTNG5qucJ/aVsWnHIvoeKpnYVByfYPRdzzMl+F/K67E0W6/2fWzUHhJg8dYtYw+kzfxVAVCRLhlLkgYPcyjKoqqSC8IeipYp9ZZ+EeZnxO96h+k4IhFLN3kR4P0MoSqoIByD2eaPmgXnpK/NKH2svP7J7Hgl8H9QJAIGz+HaPFJdSxGNe0bt3yHuif4mFS8ZAjDAvH0ZC1jgnyVMmzj1JlDSKLtH4eQDgQYvWPHazYbAd3QCryYuGpRWpGLcY2VWaDiWxgqBlynsS2c1/E1hMYF6m+GzCepXUb22e1trDAfcIp18WMDLHkP0KsCacPWt3BEotTBnk4Fn0CJzoEu/USVAlbSe14AUm+Ln5o6MTzPEaL2kWVJA/IXNd1TMhez5+5dZJ5P+4bYpcOwo5TXPNMItAlZVVt94mAVhmAWYdfbjUjW9
 6q76RqHZ
 DMDPEkf0+c2e5yEssM9syBDvsRZPqVEVIccI/cSbKicOazLXWRkI9x7p0S7IOl5FSKtTGCua3U2fjXVW73u2yMQ+hGYQJd9HLyEENBT67JUaVvuBvk5XNK7rQF7RF73SdM4ejEQOLt/WQ6wR6WEPYZMv6vnTXjla++QRSESsbSDIuI6pgc1MYf7B9QGYFbRRe1ddRY9lWE08cCpAUm8ulVI36GpDchcNiW5+ELFwnE3nwlOAi7q+LkPmrxZxXMwcPod9d6W+toWVQCfmwxAC/p8NVH4Pr/VU41IZRFtxcmJpCzmg3z1sFNWHYgiABEFWXJK+3rEtTdAgV3ZvL8WZu2iF9lixj3wV28y58kcedIe/qolvRBNAxJs5AgzyLQ7wHblovAf7IxejeWoYJVyY5dbjlAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

migrate_vma_collect_pmd() can detect a large folio while holding the PTE
lock, then drop the PTE lock before calling migrate_vma_split_folio(). The
split helper took its own reference, but only after the lock had already
been dropped.

One way to hit this is device migration over a range that contains a large
folio. The walker reads the PTE while holding the PTE lock and derives the
folio either from a present PTE via vm_normal_page(), or from a non-present
PTE that encodes a device-private softleaf entry. It then has to drop the
PTE lock because split_folio() can block. Before migrate_vma_split_folio()
gets a folio reference, concurrent reclaim, migration, or truncation can
replace or clear the entry and drop the last reference to the folio. The
split helper would then take a reference and lock on a stale folio pointer.

Take a temporary reference before dropping the PTE lock and pass that
reference into migrate_vma_split_folio(). The helper consumes the
reference, so split_folio() still sees only the expected caller pin instead
of an extra pin that could make the split fail.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260630164143.1595669-1-usama.arif%40linux.dev
Fixes: 022a12deda53 ("mm/migrate_device: handle partially mapped folios during collection")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/migrate_device.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 2f8b646302c2..f5a5f699e98e 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -77,6 +77,9 @@ static int migrate_vma_collect_hole(unsigned long start,
  * @folio: the folio to split
  * @fault_page: struct page associated with the fault if any
  *
+ * If @folio is not the folio containing @fault_page, the caller must hold a
+ * reference on @folio. The helper consumes that reference.
+ *
  * Returns 0 on success
  */
 static int migrate_vma_split_folio(struct folio *folio,
@@ -86,10 +89,8 @@ static int migrate_vma_split_folio(struct folio *folio,
 	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
 	struct folio *new_fault_folio = NULL;
 
-	if (folio != fault_folio) {
-		folio_get(folio);
+	if (folio != fault_folio)
 		folio_lock(folio);
-	}
 
 	ret = split_folio(folio);
 	if (ret) {
@@ -310,6 +311,13 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			if (folio_test_large(folio)) {
 				int ret;
 
+				/*
+				 * Keep the folio stable after dropping the PTE
+				 * lock. migrate_vma_split_folio() consumes this
+				 * reference.
+				 */
+				if (folio != fault_folio)
+					folio_get(folio);
 				lazy_mmu_mode_disable();
 				pte_unmap_unlock(ptep, ptl);
 				ret = migrate_vma_split_folio(folio,
@@ -353,6 +361,13 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			if (folio && folio_test_large(folio)) {
 				int ret;
 
+				/*
+				 * Keep the folio stable after dropping the
+				 * PTE lock. migrate_vma_split_folio() consumes
+				 * this reference.
+				 */
+				if (folio != fault_folio)
+					folio_get(folio);
 				lazy_mmu_mode_disable();
 				pte_unmap_unlock(ptep, ptl);
 				ret = migrate_vma_split_folio(folio,
-- 
2.53.0-Meta


