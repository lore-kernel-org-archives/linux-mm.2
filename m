Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1428FE937EE
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 19:01:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B4CE6B00A5; Sun, 12 Apr 2026 15:01:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7854A6B00A7; Sun, 12 Apr 2026 15:01:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69AE06B00A8; Sun, 12 Apr 2026 15:01:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 55CD96B00A5
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:01:05 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0BBB51608C3
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 19:01:05 +0000 (UTC)
X-FDA: 84650821290.26.1AABE9C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6345140013
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 19:01:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q164J1pa;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776020463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5V3IIBVqq2i4LJHyO9CuzkxjHnl2URF1CytdCMqY+cE=;
	b=fdA0950MCWor9ZB7974lNa9+qGkmXEZzu2G2LmXl1Wqy9WVGhVzZQVsPPeJH917hHVBEkH
	2COrs0B9x/upzMPep/PcJ6J0gVAwAVNr1gyZcXbN67RKgbpLZgx04dRVG65ZeW6dKReUpf
	kTGcEsDje5zfEW0czJr1U2yuMRwKBk4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q164J1pa;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776020463; a=rsa-sha256;
	cv=none;
	b=oJO//M7rsp3tqEgpD+feZBbuw03tURiyxcIz+pir3FrPxP8jkGaX7tiJP82miY690Kwjjr
	6OI++Mr5ueyxJoBWPg3G7THaojtA39nwcbHV1MKbFGh93i+UKFNLQARPgzB8rrLjx33sAN
	r6pLlRuG2BYtf/QFHkL+oQZpmyqy3uY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D5A4A6132F;
	Sun, 12 Apr 2026 19:01:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD326C19424;
	Sun, 12 Apr 2026 19:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776020462;
	bh=k8TV/mQzckSwoxZFZIPvSw0wxio7o/z3Stq1Dmp0NZo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Q164J1pajjP4GBWPj23Lp4mHTBftGYsPTAk2vvdxdR/yQe+DD7tj2pRK8pcMKN634
	 +GAdTuR6FVgGt3/WAZXgGtlQ984Z24P8H+PirEXkevyNklnZEL4D7G7wwRUak4ZMeN
	 k+6v8smDNXW2RTuj294tKZxMvWuyyTgP+sD7wZOXa6ZGFQVa//ETaavK1A2OzCpQEG
	 +qMp+227FiOVegvRcSgAZL88fSP9wyn0gykkYJTd3EGJZOdL6Ozdoq3p+jOfgK252Z
	 u/jyERY99l2LOXyf011ZvhceXK8RGQbnnceVAsg2bTXj5lBfbmhyIwuxdBr+spdGHB
	 VnXsbGFVt1YaQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sun, 12 Apr 2026 20:59:41 +0200
Subject: [PATCH RFC 10/13] mm: re-consolidate folio->_pincount
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260412-mapcount-v1-10-05e8dfab52e0@kernel.org>
References: <20260412-mapcount-v1-0-05e8dfab52e0@kernel.org>
In-Reply-To: <20260412-mapcount-v1-0-05e8dfab52e0@kernel.org>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Brendan Jackman <jackmanb@google.com>, 
 Zi Yan <ziy@nvidia.com>, Pedro Falcato <pfalcato@suse.de>, 
 Matthew Wilcox <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: 6345140013
X-Stat-Signature: aokabscs3atrxkjhrukx86ae559f49yr
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776020463-90484
X-HE-Meta: U2FsdGVkX19W3l55ZNdrmQS/6lhWwBkZerQBBrN4wVUer7v1MJpmY1g4F6V0uV/81O+Q1VUM1P3qp3iOaUsg5R42IqEqIdP8Dthx0zK2sQdnDyVu17IQI3K1+T4mJv2DuGWZx0nncqe1XK/YW1WS5l62Rlysv8jHzBI61njNx6uXNfom9bLTL/P/aIRJ6wm3laWDQlDb2BIpIR63s9wm/TsmkrGBApDEte7bKjsjg9p7TAHlEU/5z0dBMYCEzehsKamgcpkofFDesS6wrblTQDlRGTYOxVKfs5j0kuAyun71bKtLkQbUrlwcWbz+NEVjUad1jOAAZ7bD+ZTbi0yghur6O9C26ONcLOzNcq2METR5MRHrSt9l9nMEiFSZ0t5KqY+VtGn95vCPT7dKOp6q+0uAAcGaIHtlRWuD5mq1CiuQJj+LctBYfRTd0eJ2CK52A6fG+unXRMmGC9sDXtN7U8QVg2pntHSkl8SAVE6WEOm6hgrAyN9J9pd6sMo4tAFj9sPvb0dQB5ojrQfN3sijjbD6G3dRusvGVM6tIyAvh6SBxDFSchPLmEmhm7HEDpHBD7urp8FzEZOfBsG++DXGbqwFiMCNlxj+VkRZ7QKoDySBCey6gxOD4YP4xt6lmTUYo3kHRE0YpmfanSnMMgicWSlBqWadkE2OlQ2djMnavDF5xIUgxcCAwFSHFUhhlxkIPdSwB0ho14pw+2+Kt/z32k9qOfs9TG5+gH8/byayeT03MUhnS8vy/cZrH3zl6JRQdK9JgaOZbNOw3p2hWTfFXMFpvbquFkTJhfNX+kl9Ouztg8w+YPnnzhQF7PeiOWh4Vj0Lt9SIbzQLhGr9qMZQ5w9H0UVuWhevkGi3hEUr+DDsHM9SFxVbF93k8lEdlKca7Bg1lb64IEl5kuUhjNdwt+t7dWe5Mojq/XeEWATL50htsoOvqmRDskqmz1O+slWysevo+Q5Fak5fsIp2JxV
 ldh0xYbu
 LFnJs8UPrK/xeedwsERen2FwWsp1DLaHE7QBNASZZ0+BC9eQ3DwMJkdYVjZu+RAvm7/rLh3i+Cdc2w/eXuTPkSIIZmiJNK2EaYp9FzudlTJhbIYmaXuZ3llXUVl9veiKbH4CV+j5//nY3KqSXMh35+TGlcoNBf9qSwG9Ro13hAnNd4Ra+94UmKpgEjpFngROSaYGVB0EqF3ezI0pxWNfJTPdjuiaefoP2KltHy2FrBExPs+p00h1lIa38BeKSUgzmVgWKM5lI7kGHFugDgIItXK0famme5dVrLSPyIktPzTwr+zcNDMK+gaCVrCF0oQzCEo2LiKNCxO9I610=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that we have some space left in page[1] of a large folio on 32bit,
we can re-consolidate folio->_pincount.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mm.h       |  4 +---
 include/linux/mm_types.h |  7 ++-----
 mm/debug.c               |  5 +----
 mm/internal.h            |  3 +--
 mm/page_alloc.c          | 14 +++-----------
 5 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1715c6ed14d4..6dd906585420 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2593,9 +2593,7 @@ static inline pud_t folio_mk_pud(const struct folio *folio, pgprot_t pgprot)
 
 static inline bool folio_has_pincount(const struct folio *folio)
 {
-	if (IS_ENABLED(CONFIG_64BIT))
-		return folio_test_large(folio);
-	return folio_order(folio) > 1;
+	return folio_test_large(folio);
 }
 
 /**
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index e59571d2f81d..450f61cad678 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -451,11 +451,11 @@ struct folio {
 			union {
 				struct {
 	/* public: */
-					unsigned int _unused_2;
+					atomic_t _pincount;
 					atomic_t _entire_mapcount;
 #ifdef CONFIG_64BIT
 					unsigned int _unused_1;
-					atomic_t _pincount;
+					unsigned int _unused_2;
 #endif /* CONFIG_64BIT */
 					mm_id_mapcount_t _mm_id_mapcount[2];
 					union {
@@ -482,9 +482,6 @@ struct folio {
 			unsigned long _head_2;
 	/* public: */
 			struct list_head _deferred_list;
-#ifndef CONFIG_64BIT
-			atomic_t _pincount;
-#endif /* !CONFIG_64BIT */
 	/* private: the union with struct page is transitional */
 		};
 		struct page __page_2;
diff --git a/mm/debug.c b/mm/debug.c
index bfb41ef17a5e..80e050bf29ba 100644
--- a/mm/debug.c
+++ b/mm/debug.c
@@ -81,10 +81,7 @@ static void __dump_folio(const struct folio *folio, const struct page *page,
 			folio_ref_count(folio), mapcount, mapping,
 			folio->index + idx, pfn);
 	if (folio_test_large(folio)) {
-		int pincount = 0;
-
-		if (folio_has_pincount(folio))
-			pincount = atomic_read(&folio->_pincount);
+		int pincount = atomic_read(&folio->_pincount);
 
 		pr_warn("head: order:%u mapcount:%d entire_mapcount:%d pincount:%d\n",
 				folio_order(folio),
diff --git a/mm/internal.h b/mm/internal.h
index 53b20de141b9..aa1206495bc6 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -869,8 +869,7 @@ static inline void prep_compound_head(struct page *page, unsigned int order)
 		folio->_mm_id_mapcount[1] = -1;
 	}
 	atomic_set(&folio->_entire_mapcount, -1);
-	if (IS_ENABLED(CONFIG_64BIT) || order > 1)
-		atomic_set(&folio->_pincount, 0);
+	atomic_set(&folio->_pincount, 0);
 	if (order > 1)
 		INIT_LIST_HEAD(&folio->_deferred_list);
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1c09d79cade3..8ed4c73fdba4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1125,11 +1125,9 @@ static int free_tail_page_prepare(struct page *head_page, struct page *page)
 			bad_page(page, "nonzero entire_mapcount");
 			goto out;
 		}
-		if (IS_ENABLED(CONFIG_64BIT)) {
-			if (unlikely(atomic_read(&folio->_pincount))) {
-				bad_page(page, "nonzero pincount");
-				goto out;
-			}
+		if (unlikely(atomic_read(&folio->_pincount))) {
+			bad_page(page, "nonzero pincount");
+			goto out;
 		}
 		break;
 	case 2:
@@ -1138,12 +1136,6 @@ static int free_tail_page_prepare(struct page *head_page, struct page *page)
 			bad_page(page, "on deferred list");
 			goto out;
 		}
-		if (!IS_ENABLED(CONFIG_64BIT)) {
-			if (unlikely(atomic_read(&folio->_pincount))) {
-				bad_page(page, "nonzero pincount");
-				goto out;
-			}
-		}
 		break;
 	case 3:
 		/* the third tail page: hugetlb specifics overlap ->mappings */

-- 
2.43.0


