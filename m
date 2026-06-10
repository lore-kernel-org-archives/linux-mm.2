Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3689CD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 10:29:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8946C6B0098; Wed, 10 Jun 2026 06:29:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81DA06B0099; Wed, 10 Jun 2026 06:29:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 732E96B009B; Wed, 10 Jun 2026 06:29:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BBEB6B0098
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 06:29:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 01F991A0926
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:29:43 +0000 (UTC)
X-FDA: 84863631888.11.2A026D5
Received: from out199-11.us.a.mail.aliyun.com (out199-11.us.a.mail.aliyun.com [47.90.199.11])
	by imf12.hostedemail.com (Postfix) with ESMTP id 953C140006
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:29:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Tg9+DRkx;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 47.90.199.11 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781087382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CJahy7zB3OklBuIOghVRfBNSCYpp64IAvawu3272VZE=;
	b=pAZx+66g2jk+1d7qQG53D4T6AFQqCUMqlYYslJxYD36izFEXfchApYIjuc4bL3LdapWtOW
	EifWtQmr+2NVbvgnbmDRlGt1uDyYaC1ZYkFBJgE7psDLckwnmnj3NbVZ/1lFVFaKQkR15y
	ISUPs8M2zh9AKIt0T8qBw7eE5MhCPE8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Tg9+DRkx;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 47.90.199.11 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781087382;
	b=AqKYkwcw3BwzznLVbODtcfqWwC/nu+Cj3KI+MI31jU79XGpm/Ag5CHrZ/R7d/hlBe9DztI
	nCEXkWtJdut86d29aEznuNOzdmjG4/TsXXh2jyYZaCfVP9LhvxGAVm8fz59GBQ/WzVpBZw
	7geGHkxQwNBXBYix3A+OrngGWmtjyz8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781087376; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=CJahy7zB3OklBuIOghVRfBNSCYpp64IAvawu3272VZE=;
	b=Tg9+DRkxywdXzzC+oTGDhlioJeG/E/GGrTqpH+Pe/MHWb/lnEFny5ZWa8zESc8greUwfsB1wwwR+lLcD8tzOf7nGXEfGKMeI5wl9H0w8v8nZA9gi0eeAjKy3yk0ci+Jv7Uc5Xx6omx6LofnkoQeX9hQG5jzaP7SolaL8aJU3niQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X4aHmig_1781087375;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4aHmig_1781087375 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 10 Jun 2026 18:29:35 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com
Cc: willy@infradead.org,
	ziy@nvidia.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 07/11] mm: khugepaged: skip large folios that don't need to be collapsed
Date: Wed, 10 Jun 2026 18:29:15 +0800
Message-ID: <9e05e5ca589e1156f75078951efe874118f88587.1781083630.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
References: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 953C140006
X-Stat-Signature: kik46j51ugeuw1cuqr5wxn5fg9gfkcbw
X-Rspam-User: 
X-HE-Tag: 1781087381-670620
X-HE-Meta: U2FsdGVkX1/aZD7vNrwZ4qM2ZQDHsLMyDWs6DcLNeTUb5lErHQk3zdVKLGVn935ug8ltvhskri3oBNYZWRQEvyv7WgZcHGnbfIAooh0J4259q3mgdt0jt7aMXWJtAPOR0HC4n7if4tsg0q2ZLqJbiu8mzIZXsFm1lGFMk6VWttD8KcuqBd3+rVwGtcA6PoCZZBxeZYZvzw25mEpDWZNt2wchxmrBt1xRBClZ2WO/L/y4kA58iH1tdh1mWiREHYAFOKQ/2o/ToUDBiQHOS9wb4IIabx+LSlhcni8bFqvYhRT1V8acw95QiLGW6663qwrEzKaw/OdS3t0PURQxsbeCLyLSh4ehRlwV02bwQRygOZXMnvgaRuJtJrV4gNm3UBUqbAah/90jraGRxC/LKaUfHJgXXjjLFGe4vRC22JIyPPSUm9zaKm6NjhScguP7eMsjH31/Hp3VA+bR6QtxWqKK6v8uewdzQFC6aknf9ScYufl95CtRufHRQBQ0BLJypCKg9lgXJv41Ge1furkc16FBFXb4WLahHqVMzAbOo0UXGo+EgA30yfwh1x9BtIkRf9jQNTid5yTPIs3fid3EH/Sy1lByhqLQKazJ5Y+MFcBvupUYFq8IDJwcomTyTH4wyRLRfVkK2xi7XJwDfFmMNk7D6kNV73eCSE7vKJwZ5HN9ptjT9bmCYFIdVzLM3rH9gMKAsyhQzx9W0SqZIL3IIrvyMEDUD8JCzAM8jlTgc3gU1orTEa964kOFkBXt5SMf+rpLOW33NnubyOyeQ2VvLRNrhOHCMCVgJSD1AGi6n3OaNXXsw/z9cr/qi2//81KHqMSEI1A0u407LflJpD2gZsblexqaJ46IQFBJ46bdD5e3bkBIeOf6a9mqOrifgaojnwNIhpgnl+2DyaGVY93uHPatJYvp/63APaEEiIv1oTpDH+tCjjdO3cfL5d6PU4dcKirlc+zbZlnw+MSVokw+6a0
 3mkdiLbH
 W2X27hC7kafuSJtfyaOWCffiOPgbkq8crMsKyFIZzGxKQwK6VTlAM9xITqVvXhMvck4D8jUidz8rNEOswCQVD5Dsn7A9r4htRvq9QSJ+2ObVgof+tI5aVkxK61NI4XphcEUT4AAJ0yVaaITGBTACCTrcAGfJpQpNI6f0BGpbwoF0rKtOUyw69gv+a0e0CGK9AVKbqqNPS4wORhPCPzHMRALYLwBx1x0HymjEu3ENohdZDdkDCanpe7PN9zZCS04CfIkFX3icm7lJAz0/giaHdzAv32hDTzuH84Dn3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If a VMA has already created a mapping of large folios after a successful
mTHP collapse, we can skip those folios that exceed the 'highest_enabled_order'
when scanning the VMA range again, as they can no longer be collapsed further.
This helps prevent wasting CPU cycles.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/khugepaged.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index a87918b7e18c..a9664ac26f11 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2724,12 +2724,12 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
 	struct address_space *mapping = file->f_mapping;
 	XA_STATE(xas, &mapping->i_pages, start);
+	unsigned int highest_enabled_order = 0;
 	enum scan_result result = SCAN_SUCCEED;
 	unsigned long enabled_orders, nr_pages;
 	struct folio *folio = NULL;
 	int node = NUMA_NO_NODE;
 	int present, swap;
-	pgoff_t pgoff;
 
 	present = 0;
 	swap = 0;
@@ -2738,6 +2738,9 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 	nodes_clear(cc->alloc_nmask);
 
 	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
+	if (enabled_orders > 0)
+		highest_enabled_order = highest_order(enabled_orders);
+
 	/*
 	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
 	 * scan all pages to populate the bitmap for mTHP collapse.
@@ -2814,10 +2817,17 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 		/*
 		 * If there are folios present, keep track of it in the bitmap
 		 * for file/shmem mTHP collapse.
+		 *
+		 * Skip those folios whose order has already exceeded the
+		 * 'highest_enabled_order', meaning they cannot be collapsed
+		 * into larger order folios.
 		 */
-		pgoff = max_t(pgoff_t, start, folio->index) - start;
-		nr_pages = min_t(int, HPAGE_PMD_NR - pgoff, nr_pages);
-		bitmap_set(cc->mthp_present_ptes, pgoff, nr_pages);
+		if (folio_order(folio) < highest_enabled_order) {
+			pgoff_t pgoff = max_t(pgoff_t, start, folio->index) - start;
+
+			nr_pages = min_t(int, HPAGE_PMD_NR - pgoff, nr_pages);
+			bitmap_set(cc->mthp_present_ptes, pgoff, nr_pages);
+		}
 
 		folio_put(folio);
 
@@ -2843,6 +2853,11 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 		goto out;
 	}
 
+	if (bitmap_empty(cc->mthp_present_ptes, MAX_PTRS_PER_PTE)) {
+		result = SCAN_FAIL;
+		goto out;
+	}
+
 	result = mthp_collapse(mm, file, start, addr, 0, 0, cc, enabled_orders);
 	if (result == SCAN_SUCCEED && !cc->is_khugepaged) {
 		/* If MADV_COLLAPSE, adjust result to call collapse_pte_mapped_thp(). */
-- 
2.47.3


