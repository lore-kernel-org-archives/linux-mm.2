Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BCF3C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:09:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D61F16B00D0; Tue, 14 Jul 2026 14:09:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D38A26B00D1; Tue, 14 Jul 2026 14:09:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C29C66B00D2; Tue, 14 Jul 2026 14:09:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A00B6B00D0
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:09:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F3C018041E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:09:12 +0000 (UTC)
X-FDA: 84988168944.16.5B4B04A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 720E88000D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:09:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=v8nKAws7;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf02.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784052551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ruQV6BXbVPwvEhDZkjS7q1A7ZoTnDpeDx7ntto0HXI=;
	b=qMPjKq4lKjDEo0cEtUIGUZwglrQCgQbxkCuU8ix7xT3GjgBWYlCOfJDXPg5KMZMJILsXPg
	+AHdV4CiTL0WDdIrGeyTxEaCoe/z5Tsv/PfYJEH9BBcoX3Hb6jXjszCp1iBSh2Ns9dAZn0
	5ND8a9+ijWpxswZ7W9soPcx9zMGbcmU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=v8nKAws7;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf02.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784052551;
	b=Vh7pL9JWc/f5ipG3ywrBGnGkTpZbiZHR3RSvEkdJcjyhHTQERwEllbanmK/8XyzR3LQWe3
	OIDe2rZzzwpDwXVKxziZAp/LoPEml0KAsAN4ws/lW9a3x5OdFORIpk7PLxkn9XFVht7VD4
	rsVbxQ6gSDOMXTVCv1F1V4gag3lXprk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=1ruQV6BXbVPwvEhDZkjS7q1A7ZoTnDpeDx7ntto0HXI=; b=v8nKAws7vezXrjctM/dFe86Kfe
	daRklssmEAJiQ4jDm0etHCot+Jp1d07fejfGQp+bRWKsEur4CTTFfRHBXRdHf6CKGAn7VZ8nq6s1n
	E2Q/hreFE3TBoIThV4Zwn4ZX8jY+t/npgykH7T7XxC0glzEPKBhErOXxKudBjXBzjkn9kVc9zQjGu
	aLBsmIhgMHXCwUWxQetc8Mrjyuyhb/AwAqKRhfAGcj0ynsXS8AlJhCUC5waqMGUAfd0wAnEadUbS9
	kvSB/o/cEuwkChEdiY67rOjWSsfZRnI2+27ePnjpgpnO/o9tNb3WzzVSFbXxZw05PdS/sU+I/RBu1
	w2V/1/bw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjhYh-0000000FegX-0BT8;
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
Subject: [PATCH v3 4/9] mm: Handle hugetlb correctly in is_page_hwpoison()
Date: Tue, 14 Jul 2026 19:08:34 +0100
Message-ID: <20260714180840.3731244-5-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260714180840.3731244-1-willy@infradead.org>
References: <20260714180840.3731244-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 720E88000D
X-Stat-Signature: hzfqwy4bn17nkjmsycncbrwoutpyaazf
X-HE-Tag: 1784052551-898244
X-HE-Meta: U2FsdGVkX1+EP9nYEYfOo+cGXHU2+Ds/NkcEN/j4mSe7Nm1oJy/t2LBLSYCb8Y7FWFsaE6IyyT1BBDgHUn1RK9Q+Nab1jcqqCOW1f//LgAVE6dDQgO2iVumG0eTx7njw8mPcXcdb82xwQot3qA6BCuUDDTRvvfPnH9CVY0GhMIZquQ9V7q4bOrBtb8PdKrTbqgxIv7bwZL5C1PGG6DEbBKCmt8I8dWrVida2LIwAdmxGONRWM/UbhfsgcgKjc138GdJPZ9+sCHyAW8PViWo/3fhTmgb6JDDcCxWZDi8iepxhi6siP/BtK5R+SkeiwB3efINSp3PXI1E5Mu6mMpB7t64Re4Fifp1MEf9XJwCHP3049jM5DAgeruDhhqBYl7ukpbGhGSjTQfGUu69/43PmiJl50QQ/MZDxPh3lnMVwsr4uODhaZW0hC+jAHGL69vuczs1452B7HZM3c3M7Ie7WWmBHNkuHnwXoFfAxHxyrQuv5U49KD5Kb+XQu7u6f5aSJcSlEN3abgTiMmC3uZpK7WlTgx09tle4MZlly3pninCa3MoZScxRriAOSED7XHMV/Ko/ir4QvwfdEJapPOg7/7j/4v5OzOC2lfoXUX3Xm+kNbKfmSDVD2d0Ez8Gvbu8tDUr3f+LieW2hHQLp3pzrOhVmrInESGY4bZOs4z8rug4fxU3BZuYYkViin0IMHJC300GB2/06QddK45MFVgWTBplSEqVbk7imhEQhiYeu8tsKE7/v4fgitZNWSv2aaYibUlCKzqXAgnrhpW3hoq60xYttWgqU5d+gap1jfK1O6vRZh3fxzqUVEmktJ0WNAACJ4wa7K8n66DfnfiYczDgee2SbGzoRIvii5YcfDuHOZNb0XSSab1OV9WkyaKrAttwjHF67LHU3GTt8/x5N//EdLn5imbuwcLfvmUfWeZ39I1mj7uHnEOlMmsPCxf9CHytz0/Gv4GKNrYBaveEFSkFV
 J6G9iQW8
 ejMQNLQh/g5Ygdxs8+MExzKaJahHTEf/TMYrpOO4VU83l9EmkW+fy2ngZ/e01C4a8dIBxyTCWEWIpJjz7di7fjkLRJgnhTkBYyP03T67ftqgf9O7D52VwEjn+1LY1wGcWg6Q7zE3eNz+TgvD+oMtIyOs2dFDgBC3p/Xqa8T0ViOsEs6nvXyE73A8U6eR9gtAZjf/2My0oDpm9exipZgrof/5t71bTqHdYZqpmpW/1wS0hMGjki+wJsXvtSs88s8TG2BfWHfQycQ3X8tYNfkkaQqrjZgjIb0lDKVIANoWbkiBKmZsqQF8ui21MISGbYw6cAtK+SEaWrpRLxjpKgrAU4t1UPAHCCCZy4s8sfz/DrsUdi4LffS7FMKN4Bfv9eBPef1S2Za0ynSz8jyRABRR4mfBQAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Checking to see whether a page inside a hugetlb folio is hardware
poisoned is more complicated than I realised.  The correct logic was
in is_raw_hwpoison_page_in_hugepage().  Make is_page_hwpoison() the
official entry point for "is this page hwpoison", no matter what kind
of folio it belongs to.  Rename is_raw_hwpoison_page_in_hugepage() to
hugetlb_page_hwpoison(), and remove the attempt to handle non-hugetlb
folios from it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/hugetlbfs/inode.c       |  4 ++--
 include/linux/hugetlb.h    |  5 -----
 include/linux/page-flags.h | 24 +++++++++++++++++++-----
 mm/memory-failure.c        | 11 +++++------
 4 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 216e1a0dd0b2..f1d4e511d9b1 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -198,7 +198,7 @@ static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
 	struct page *page = folio_page(folio, offset / PAGE_SIZE);
 	size_t safe_bytes;
 
-	if (is_raw_hwpoison_page_in_hugepage(page))
+	if (hugetlb_page_hwpoison(folio, page))
 		return 0;
 	/* Safe to read the remaining bytes in this page. */
 	safe_bytes = PAGE_SIZE - (offset % PAGE_SIZE);
@@ -206,7 +206,7 @@ static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
 
 	/* Check each remaining page as long as we are not done yet. */
 	for (; safe_bytes < bytes; safe_bytes += PAGE_SIZE, page++)
-		if (is_raw_hwpoison_page_in_hugepage(page))
+		if (hugetlb_page_hwpoison(folio, page))
 			break;
 
 	return min(safe_bytes, bytes);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 18661a7cdb37..1878642e75ec 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1069,11 +1069,6 @@ void hugetlb_register_node(struct node *node);
 void hugetlb_unregister_node(struct node *node);
 #endif
 
-/*
- * Check if a given raw @page in a hugepage is HWPOISON.
- */
-bool is_raw_hwpoison_page_in_hugepage(struct page *page);
-
 static inline unsigned long huge_page_mask_align(struct file *file)
 {
 	return PAGE_MASK & ~huge_page_mask(hstate_file(file));
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 4185a03a45cf..8e57c12a7301 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1068,6 +1068,9 @@ static inline bool PageHuge(const struct page *page)
 	return folio_test_hugetlb(page_folio(page));
 }
 
+#ifdef CONFIG_MEMORY_FAILURE
+bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page);
+
 /*
  * Check if a page is currently marked HWPoisoned. Note that this check is
  * best effort only and inherently racy: there is no way to synchronize with
@@ -1075,13 +1078,24 @@ static inline bool PageHuge(const struct page *page)
  */
 static inline bool is_page_hwpoison(const struct page *page)
 {
-	const struct folio *folio;
+	const struct folio *folio = page_folio(page);
+
+	if (folio_test_hugetlb(folio))
+		return hugetlb_page_hwpoison(folio, page);
+	return PageHWPoison(page);
+}
+#else
+static inline bool hugetlb_page_hwpoison(const struct folio *folio,
+		const struct page *page)
+{
+	return false;
+}
 
-	if (PageHWPoison(page))
-		return true;
-	folio = page_folio(page);
-	return folio_test_hugetlb(folio) && PageHWPoison(&folio->page);
+static inline bool is_page_hwpoison(const struct page *page)
+{
+	return false;
 }
+#endif
 
 static inline bool folio_has_hwpoisoned_page(const struct folio *folio)
 {
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 490aed0b25b4..9e4ee5d93905 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1818,18 +1818,17 @@ struct hwp_page {
 	struct page *page;
 };
 
-bool is_raw_hwpoison_page_in_hugepage(struct page *page)
+/*
+ * Check if a given @page in a hugetlb folio is HWPOISON.
+ */
+bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page)
 {
-	struct hwp_page *p;
-	struct folio *folio = page_folio(page);
+	const struct hwp_page *p;
 	bool ret = false;
 
 	if (!folio_test_hwpoison(folio))
 		return false;
 
-	if (!folio_test_hugetlb(folio))
-		return PageHWPoison(page);
-
 	/*
 	 * When RawHwpUnreliable is set, kernel lost track of which subpages
 	 * are HWPOISON. So return as if ALL subpages are HWPOISONed.
-- 
2.47.3


