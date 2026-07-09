Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6814FC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 18:48:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A829A6B00A3; Thu,  9 Jul 2026 14:47:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A59BF6B00A9; Thu,  9 Jul 2026 14:47:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 997526B00AA; Thu,  9 Jul 2026 14:47:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6BDAD6B00A3
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:47:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0D79E1A0270
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:47:59 +0000 (UTC)
X-FDA: 84970122678.07.F34D921
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6E16B100006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:47:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NA2Yy5FE;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783622877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GmGu0ZW869EgCRLGssVX9FmgzrTbftZn/wQC0xTCXeE=;
	b=eiD1eB4TSEwT3hwNFnJxwaYSiyGGoNO4HsQl6gE1ytbG+Wbja81ZJs2ta1jgDOEt67o8Hv
	cYJynLY8BEIgA/sGpBySA8E2WuAVNnsAQ8zAoT6Kzf/ETJSX8mk34ffNDLriruuFAU7pwh
	owz6DT9Tc1M6dSLxRDwbLN3TGyK8kbs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NA2Yy5FE;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783622877;
	b=huuoKiZAKSPaoonK+tB2OLbP4tBYBnWlGzSDWIydeHX+n9k19Ol4AawYeqTdar6i9zS+5K
	4qYgRQn26aMMJlFAJ/EH1KV2IBhD6EMp7HbnQQA3B/dYin1eDROp8JJGnmRLp0kNlS5Cpk
	nkk8Z3xgtzWdnVGBk1/FOVc4HD/47gk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=GmGu0ZW869EgCRLGssVX9FmgzrTbftZn/wQC0xTCXeE=; b=NA2Yy5FEDPYZqDoitTVsegoTVd
	u8/y5bur397sLmdVuCNQOMVkmPYLUPwX9dIO7ePq6f0hatp1qCbcTCfZECKQmJCvB/OB/IhDY1Rky
	Afkuvrk76ZKJP2m3Tt8WH629Edbb3axlgH8Cd4+ebbtxRf1ugL5/EDCwufMtqKlCM70MNBicS9/uk
	DeULo2wC12S2muQrWUDbpK89l7gup2cwT9xp+TOimn2feR5WZJ97V3JaTdPbk0lhh5t6Ne4xNlM72
	Xedcwz5KlMAz+PsHrB+ZplR4hgntgQIc7DnVlLdKG5QAYKcmfdrJrbvBG7vDpqXCasYuFwS5lsFYa
	LfQgXM6g==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whtmg-00000005OhB-1FzS;
	Thu, 09 Jul 2026 18:47:42 +0000
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
Subject: [PATCH v2 01/10] mm: Rename folio_contain_hwpoison_page() to folio_has_hwpoison_page()
Date: Thu,  9 Jul 2026 19:47:29 +0100
Message-ID: <20260709184740.1286561-2-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260709184740.1286561-1-willy@infradead.org>
References: <20260709184740.1286561-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6E16B100006
X-Stat-Signature: aqdq9f1jz9k4a6ib6xieqkmpm5513bpr
X-Rspam-User: 
X-HE-Tag: 1783622877-690339
X-HE-Meta: U2FsdGVkX19QV/d8j6RF85O1K7gpiutnDYG9uU2HH1AvB0sO+MH6KEMJwLzCJWq6GCu64G5QTcehK43SL7cd5gnUmqnY9KGF47BJ2Vx+zETdnRnFHnilJbPR6sWxX2rphljHNQPCkc+1dayG8M9LY67DhuG/+AnGRbVo4YlEXwgvE7Nu9a1DDxkkrTidGRT1wecZtCc1kXGphYmDClyvKvjDj8FU9H0gKd5xIRa+4X9eTBDWCDPBP/315q73hgn3mifeoNzqHmvROYiNkPKl6JfXoLorXtji+3Aa8C+oTVvHMbYNArmwHkJEkWvS7I5eJGzEFurQuUDKyvhITZTFaoqpavXi+TxUfV0+gKEg29Q9ER0wChnbcfVUj0PnTdz0hBECdPfN1aZF/J5Byi/5mmveFp/bAHCNuhtZPJ4Jfqku1N/P4D0TP5+DxDSwcztgJrUFjjIBXlMuQ642wg2r6VxDoKFuv5FA67mVFj0n68ucq6ySzBpOrPNVrZyWFhgBgBhM1pPm8QJ/IuNH5HSvcrKvjzN2IgnP24mkvmBBwZknpWUTk0f8jKxWYvJWoSe2yH6ZVRHz17hEPETRmZGm/P8cEAU48MBIuiFEqEQLNRTYTgAmkIDKL2TOeml/758FoRf9go2fHVsCAVX1FvJy0ki2Z4qmDkup3ojst7ta5WKcTLSzqUpCeAIfHtCcsVz9JhXYiyG5VVyM6ClEsmZP1GLkvMm5zCfcnoHeTzw0TIYdBB9/ojR2w6H54SXkSi8cYMQRhIEY9r1oJYc8yovdHYpjuO++NM6VTl16+aIp5oYxmSTg72aeiTkuIxmbhN82ZXty6RIuqD/VycICi1+sRaYrcWWKN0BZBkQouSuklHpCDOf0Jt3M7LWniREeFgsdB4gGxvkLwy5q6iGe/91aEPaKWAhO9U7qB0Rxpyjrz9ALHO5AnSSOQ7ub9zWo1s8UpGZwSXlyCCSp8Pbcou/
 KChBLlIM
 w6LPwaanNplw8njIZcGQxP5OD/btGEjXDZLwTdJH+CBKX7K+bAe3Jyk0sFPzLkiohjESgJQszMmXYho+HtTwZamoFwP825JFm5TJVEK/3Pnvt7fQNfGnBR0wJfMyMlOjy0vlfWOQcoxRhICXO6wr3d0Y802Zg1k1qYvfEDRBgRBFEXrocE3hM84Vy1ToqVYGy/EPvW1sSdeowWaHxNgrks4lA/rr8hMmF5gFXOTFAYEXArfs1jHDUObjv9daGnPVuS/iN8E2bmCvZZ0nczMG+k7BaJe7QYNCIch+/twkw0bGvuYm1PhadybRE16jcXaoSel88IAlZAuFudhPkxe04mPxQEJt4Nm+KyBZ+6hS5iGUvarQItZNl4a7mtayWKtOeWGVDN0N/I4cYO2OsO6VwrceWig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a better name for this predicate.  Also make the argument const
to allow other callers to be made const.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/page-flags.h | 4 ++--
 mm/huge_memory.c           | 2 +-
 mm/memory_hotplug.c        | 2 +-
 mm/shmem.c                 | 2 +-
 mm/vmscan.c                | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 7223f6f4e2b4..4185a03a45cf 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1083,10 +1083,10 @@ static inline bool is_page_hwpoison(const struct page *page)
 	return folio_test_hugetlb(folio) && PageHWPoison(&folio->page);
 }
 
-static inline bool folio_contain_hwpoisoned_page(struct folio *folio)
+static inline bool folio_has_hwpoisoned_page(const struct folio *folio)
 {
 	return folio_test_hwpoison(folio) ||
-	    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio));
+	       (folio_test_large(folio) && folio_test_has_hwpoisoned(folio));
 }
 
 bool is_free_buddy_page(const struct page *page);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2bccb0a53a0a..353340309107 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4413,7 +4413,7 @@ static bool thp_underused(struct folio *folio)
 	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
 		return false;
 
-	if (folio_contain_hwpoisoned_page(folio))
+	if (folio_has_hwpoisoned_page(folio))
 		return false;
 
 	for (i = 0; i < folio_nr_pages(folio); i++) {
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 7ac19fab2263..33007e8e546a 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1813,7 +1813,7 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 		if (folio_test_large(folio))
 			pfn = folio_pfn(folio) + folio_nr_pages(folio) - 1;
 
-		if (folio_contain_hwpoisoned_page(folio)) {
+		if (folio_has_hwpoisoned_page(folio)) {
 			/*
 			 * unmap_poisoned_folio() cannot handle large folios
 			 * in all cases yet.
diff --git a/mm/shmem.c b/mm/shmem.c
index b51f83c970bb..492c9bef3620 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3240,7 +3240,7 @@ shmem_write_begin(const struct kiocb *iocb, struct address_space *mapping,
 	if (ret)
 		return ret;
 
-	if (folio_contain_hwpoisoned_page(folio)) {
+	if (folio_has_hwpoisoned_page(folio)) {
 		folio_unlock(folio);
 		folio_put(folio);
 		return -EIO;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96..70e54ace0e74 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1086,7 +1086,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		if (!folio_trylock(folio))
 			goto keep;
 
-		if (folio_contain_hwpoisoned_page(folio)) {
+		if (folio_has_hwpoisoned_page(folio)) {
 			/*
 			 * unmap_poisoned_folio() can't handle large
 			 * folio, just skip it. memory_failure() will
-- 
2.47.3


