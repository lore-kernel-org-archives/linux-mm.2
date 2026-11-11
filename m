Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62D8C606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XJcML6AK
Received: by kanga.kvack.org (Postfix)
	id 0DD996B05C1; Wed, 11 Nov 2026 01:47:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03F706B05C2; Wed, 11 Nov 2026 01:47:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2D3C6B05C3; Wed, 11 Nov 2026 01:47:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B95186B05C1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:47:42 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5BEC04020C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:42 +0000 (UTC)
X-FDA: 85421907564.06.AD625F8
Received: from mta0.migadu.com (out-6.mta0.migadu.com [91.218.175.6])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5C62B40006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XJcML6AK;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.6 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794379660;
	b=7dsgQ9tVdryJF83HKbyuFYcnyexTniQDRez2RSfJNQbBA61nLCzPSQrECPxi5GwaSDPxgt
	mb37MltbrVsrTy8E/jVHCFZ56YcRzKV2KLChhICxjqfuRMEaEKqo43YUPvC0fkw107chXE
	am0fXxtscF/3K5oXGMatBDAtkRMy+BY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XJcML6AK;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.6 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794379660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qywovdRbToMGzmjoli0y7eSQdslGzewck1NjQbLchao=;
	b=ufeVw8qSojyi4VID9mMfi1P0X4K/5YlLQ4YCHRv9sX1xUE4Cbr4vS/Tyohrp06VbozLWO2
	5DDnVk8pLSoL7txjoeRbGsN7ti/4cnNZsY+ivysgA8PBher+bBhftkAxuFnMDrhPOG8ECl
	4rZNipAd1l9ZziouuwTBZG51hWOQuPI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MlDtQZENV6yVDOEvaF4niEP2XzPBjBwAlns6mA8+YjI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794379658; v=1; x=1794984458;
 b=XJcML6AK9AqE09UAUb7a8ZvOxFUy1m7U4HsxWfw+sEdTNBGqQI11ivE6BHxRFEUVWWmIUpPi
 MNgp/XVG0MSpyEoaVTBC8/AJD/NoT5HrfKKIxsP5LGW1dm175pze2meDLVbCpXAfcLAqRXIVAB+
 J6V0REYE1K5gS+TEtQlXBoE0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d7154aaffd6544fb;
	Wed, 11 Nov 2026 06:47:38 +0000
X-Mizu-Trace-ID: d7154aaffd6544fb
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	azpijr@gmail.com,
	lance.yang@linux.dev
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v4 2/3] mm: gup: allow long-term pins of CMA-allocated HugeTLB folios
Date: Wed, 11 Nov 2026 14:46:51 +0800
Message-ID: <503c9f6d869e3206c6fd591de962c3d619b73825.1794379433.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1794379433.git.zhengqi.arch@bytedance.com>
References: <cover.1794379433.git.zhengqi.arch@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5C62B40006
X-Stat-Signature: qhgf1apzet3wfhxspjt859h75tsbb657
X-Rspam-User: 
X-HE-Tag: 1794379660-648859
X-HE-Meta: U2FsdGVkX1/Vpj+BJB8jR5jpx3UOnODtWHG3W5EIGPsHc57MWqaafgh4tQbc0w1p+1+Md3B/UH0EdnSCJrROtjnI6M2WWFPzJV59BFXxGPuZ1Lu5FwVs7JfUXQq9b6nq5SrSDoCQgn5/f3rzEBFaeQQiGzTEaXkBYIGd4g/jgY8jmsi1pUFdPsoN1k2rHhCeQLUExKcKoyuZ5fE/XY6FoYS33LP9bJifXpXcyRerO0qTPfDrOqfRCG96sbgaNyf0z83je5q7JlvUi4GyxERmeK0fkw/8/9083emx1BZ39uMYhquh6KddNhFZr1KMVEeU0v49c3laz1opGvbExrHUwwj8s3cMi8eSy5RbybnWkQP+sTEPDTcft1uf+P8cEIq8aLOcn8hjVka+Bk/8RUNMiFUOqyzXsccvuJ+BDlq7KJmIgqkxHopcVNwlQutEaMd8ebeDMpvWgRbXfkPRpt4nU/rb9XUvdBPdBD+89ARSvV0POJCgFuXoRPwORZr/KgPmJgs1eefQo6eKUmbjkuZWNcpA6WHWdsBIbl4QpMqVH9M+YsNVfp78ZWnDnvbt6u3hC41wOnDNJkeL0BGTmWDuom5TchTxg1nojuJAld4j0N/l5BD3bAACsAY2/lRZs7yIAx4l1uTzKMp4z5FwrBkDSME6JUSMi2O3oYu1kAUyYjnkCP4Z4hIanxSluvZg6ITzy+CDqIC8Bam13iiha4Cs09FDFvAXVn73+Gd4x9OdN9LpILv/MFb4bjjkGwYuQ6yA7RbfvqcV7R9sAQ25hZdWUmOqDWigW1mUKppBRMk/91kBkUeoGNyviGx9e6h06rsZJdflocG49pdez805I2EM3Z2MEI6yvnQ2nsI98+fMRtV/g7XwMCTbYanOhzlDUz1hZH3zvk0kzuc/tULBA5200TE3QjiPbqNSlYsq45G4c9B4XdRQP/3v8I4OQEAKmTn4x3WrmvfgaCJVbxP57Hc
 KpDcbL0Q
 WkHMPF67nlydOi8ge66T0UfJD4leEV1djr7RcMcZgSKsEy9BgwSiInquVCIzKSlyTUqRn9U+zJq7Ul/mfrBCYQsCyrtqOqxihG/rkzmpavO53YBTtPGknNYrjXlXUl4O68UQ/zwNfRqmDEuZTN3ndtwJEV/W7uLrTFVmtWOHXrVooWFK6HsNO83n09HsxLsJ6Irhjz2+0nwck9TSoKcvAyt9OYWt76ywGcFLKaBc9pKSUMquzBYkgjsxJIIoZn3h89Nhm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Qi Zheng <zhengqi.arch@bytedance.com>

Long-term pinning treats explicitly CMA-allocated HugeTLB folios as
unpinnable, causing unnecessary migration or pinning failures.

These folios already own their CMA bitmap ranges, and memory blocks
overlapping CMA areas cannot be offlined. Allow HugeTLB folios with
HPG_cma to be pinned directly, including in ZONE_MOVABLE.

Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Cc: stable@vger.kernel.org
Suggested-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
 include/linux/mm.h | 29 +----------------------------
 mm/gup.c           | 31 +++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index b0da9be413098..47d1d96bfc7fd 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2954,35 +2954,8 @@ static inline bool is_zero_folio(const struct folio *folio)
 	return is_zero_page(&folio->page);
 }
 
-/* MIGRATE_CMA and ZONE_MOVABLE do not allow pin folios */
 #ifdef CONFIG_MIGRATION
-static inline bool folio_is_longterm_pinnable(struct folio *folio)
-{
-#ifdef CONFIG_CMA
-	int mt = folio_migratetype(folio);
-
-	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
-		return false;
-#endif
-	/* The zero page can be "pinned" but gets special handling. */
-	if (is_zero_folio(folio))
-		return true;
-
-	/* Coherent device memory must always allow eviction. */
-	if (folio_is_device_coherent(folio))
-		return false;
-
-	/*
-	 * Filesystems can only tolerate transient delays to truncate and
-	 * hole-punch operations
-	 */
-	if (folio_is_fsdax(folio))
-		return false;
-
-	/* Otherwise, non-movable zone folios can be pinned. */
-	return !folio_is_zone_movable(folio);
-
-}
+bool folio_is_longterm_pinnable(struct folio *folio);
 #else
 static inline bool folio_is_longterm_pinnable(struct folio *folio)
 {
diff --git a/mm/gup.c b/mm/gup.c
index ebbfee09b7278..fdafc5a1b78ed 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2219,6 +2219,37 @@ struct page *get_dump_page(unsigned long addr, int *locked)
 
 #ifdef CONFIG_MIGRATION
 
+bool folio_is_longterm_pinnable(struct folio *folio)
+{
+#ifdef CONFIG_CMA
+	int mt = folio_migratetype(folio);
+
+	/* These HugeTLB folios own the CMA memory, so they can be long-term pinned. */
+	if (folio_test_hugetlb(folio) && folio_test_hugetlb_cma(folio))
+		return true;
+
+	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
+		return false;
+#endif
+	/* The zero page can be "pinned" but gets special handling. */
+	if (is_zero_folio(folio))
+		return true;
+
+	/* Coherent device memory must always allow eviction. */
+	if (folio_is_device_coherent(folio))
+		return false;
+
+	/*
+	 * Filesystems can only tolerate transient delays to truncate and
+	 * hole-punch operations
+	 */
+	if (folio_is_fsdax(folio))
+		return false;
+
+	/* Otherwise, non-movable zone folios can be pinned. */
+	return !folio_is_zone_movable(folio);
+}
+
 /*
  * An array of either pages or folios ("pofs"). Although it may seem tempting to
  * avoid this complication, by simply interpreting a list of folios as a list of
-- 
2.54.0


