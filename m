Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54F95C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:08:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 041106B00C6; Tue, 14 Jul 2026 14:08:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE7346B00C7; Tue, 14 Jul 2026 14:08:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E23AF6B00C8; Tue, 14 Jul 2026 14:08:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B58CB6B00C6
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:08:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 375C316047F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:08:52 +0000 (UTC)
X-FDA: 84988168104.24.5B49453
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 325C7180006
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:08:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=bmlqlz6H;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784052530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cwsU3Mhrg9KcuFxTAl0Tes+dvmZix99ipM91bAbmnN8=;
	b=QDt0fQVEVJCp65mxdHE4y/aM2/IeHRbIAXOITQwfXedi6jZusjbff1s+licT/0YhyW4spE
	ekU+QfsprovW9PmB8eiXQkUepMNuNS/wwBic3glFR2QWKcvZBXjwr5s0bwhruAjDYJyTY8
	y3WkF1YbmDWmZbKOYsBk+X1ON73GDkI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=bmlqlz6H;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784052530;
	b=PNWpvdxLKBilW0b2D5tDN83QjwCsP6gmm2WfnSAYtwzQcoZ3Vyku/G0guKqld+SGikXO5/
	rVz/32Ez0zg8RuO1knjmSUcF1sbLeQD4/S5pWCYD2AWWxBwIUWF9oDx1hCo+3CGYs+gn24
	9ncwKxn8RmOflVyeKuI6+CbneADs5e8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=cwsU3Mhrg9KcuFxTAl0Tes+dvmZix99ipM91bAbmnN8=; b=bmlqlz6H4p63xGToZanvOy6sVH
	CM/Uqu/rwgjjuziyDb6VcGKH+yGhNjGiLpGDSmuJZTzliEBJ3f0/qMfgnhKUQx2Qf0/LOSnaJHkOe
	9YIWUKEqHgr0z+Tyj7OuHca4wXGM8VSIMrsay+f8zWwIOpr7lOi1TIPeI1KyZvo4sycjSS+Vs9Zp2
	mQFoxUQOMzT4HX2XuoHFhXqXOQuRYwcOLRUvQ76bow9yU2CMAUZ8muUzbTWVd1VJAfrqSJRiiq9yE
	hfUy/H0cpKX+5cfXQfzqJYvDjCtU7QEXIdWMPumUuxx5LEgFYx1SPCB19nZ3jKDR38GRGugwy3Kep
	EJNoS1vg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjhYg-0000000FegP-2l8J;
	Tue, 14 Jul 2026 18:08:42 +0000
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
	Christian Brauner <christian@brauner.io>,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v3 1/9] mm: Rename folio_contain_hwpoison_page() to folio_has_hwpoison_page()
Date: Tue, 14 Jul 2026 19:08:31 +0100
Message-ID: <20260714180840.3731244-2-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260714180840.3731244-1-willy@infradead.org>
References: <20260714180840.3731244-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ky3wx45q9ctt8fr4hrypctpkedxnqks3
X-Rspamd-Queue-Id: 325C7180006
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784052530-247569
X-HE-Meta: U2FsdGVkX1+YzLzEZcaKL4gY3iPB7jQCaXAzCrP7jKLUGq3zmYqn/pIGCY8HqieHhB2iZtH1gc6DKffvqhfG7DbS8OphKLLqhblDm1OI38JjnIhEFjbfkXrKPtY2hJSP8LKdyZvOdqIkRjeGs/tij9jCf0NT8LEbkI9o1EyzHTRAW/gZXm4ePG3Hc8HMVIa0ZtgLkhHQG02MNKL1W6DC173s8Pad745hl6ouTSW3WeKzghO29oSDaHFV/RXi9ocerY50L2g9Vvj171v99N2TPNAJOteH3b1TESfRb91xlEApRTcHelfDgDU8I/58a+PsApvSLrBMJRJTyyJnywSiacSWR4bGM2Szpa08CBuZV5O3JvrYGDyxxsrv3GpCBz7Jb2aDPYLyOxa3nC0PW5+NMSJgC1aYS+OMNVbjyUUF7BZL7xg+KExZ9qioOvnfEi0Kqa0c8hTKjMmYfop9USwccJNBbiODW7M5V4TBSBuUykaSC8mRpq8Fr6NzWMFgOzaZD+ACeJeXb48p7OmpvY2XdouXlizppCF3zqwTxHZyGEHP5dxCl0+xbgRxHBnv+tBCjkBJdcGLadpbTlpan2CUQ+Hvcx0BmWIIq0COLmmhMcOQ5VgI8IRqRw5GTS/aNFp/DJ1+yOwOWsxOKJzjJse7Nra8jLfMqn8kEJedn05hu6xAmYs5eXdLvu82CpIBWu4Jg6jPyD1tNSR/4320PTyrJ0iFPRyopdWjq7OplOCji1JsFk6xl3L8b0yLxz5j5nZ3Oe+91VIzR2dWu0g2CD60qXDuWTA9fuugsP66DPaVsQbr4iiqAPuEisElXvU6H6dj2+IAeFek3E6FyGBFHEEuzXshqWO08t9ij82CgDC+RdbJhKItN/pwlU5U2Qu2ZmrIqVFz7nAzGYiedI7JrdgOhn+0LbgxO3wGHc0L5/RRGSwtghqi7iP1JVmFM/O8/C2M6idnqP0r6pk0EFFCqR2
 9hy4pOkh
 LzN6ArlNJ45nYxDi7wg1Wq0gxg3X+FNt5t1s+oroo50y2TLrwC3p9tOuj0TQ7XFz98Zg0H9p0zWm29Dg4DE6m1PNErOiaHQg6BGcsxC6+QnClfFZ35DBNwAXTEzC2AeEW+dPcwJOaUsAs86sU2j9k55yq0YgQTtxcgnxkGTMBpNVGmm3ZGj07U/A0vv5cOYV2Q4YlvYfkbUj68kEdPHyUGxFavqqXrFiddvnE/U88gBnoZ49xCwJkQhXEgUu2P1DkutnG5A8DlsyrgAyYDi2KXy9mXFrUKBhXGVqVW4CbVRXxD9/KbfTekXMBYutqBcKfOvel1E2cID2ck+XVOWEpaWE0LANNzksleYYieeeJtldh43U6KJOMohB6OQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a better name for this predicate.  Also make the argument const
to allow other callers to be made const.  No functional change.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
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


