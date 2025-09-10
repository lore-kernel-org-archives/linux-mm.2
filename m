Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 845E8CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 16:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDB018E002D; Wed, 10 Sep 2025 12:09:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8AAD8E0005; Wed, 10 Sep 2025 12:09:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2C5E8E002D; Wed, 10 Sep 2025 12:09:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A6AEE8E0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:09:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B3921D8D97
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:09:29 +0000 (UTC)
X-FDA: 83873825658.09.C0E3620
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id 772291C0007
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:09:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P0TQ8bBR;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757520567;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41IrheQrU1uNONBC2D87eHUDc3ROCWh6baPpZqwFKeI=;
	b=HnmskN+pDWkCgIZAmryVBX9vJVyPA8vPKI79DKwil7LiH8EQlnHqbgSdKExYLWLkbdzK3G
	9q90wChwRiz0bu0rPWNIb2a8k8HoSxKVyjt31mFY6WF11/OLLq8QMi6Cmyu7YW0vG3WzAE
	fTrP8ZbxWwoBXfxrV1ru24rd/aOXVc4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757520567; a=rsa-sha256;
	cv=none;
	b=ya2n7Z3J/6MMT2PGNvo8QlLieqnV/kZKSnQ0xvZxsK557vIw7F2llvbHmjn/622zwygfKk
	lQbM2GefNae9jP8UXZdrqhnFDID9KivrkX7XP2sI/+I/7K2BWCOOy6/57KcbEvsTXWIiPM
	O3KJrGU0gQmBslc5g63B8SZ9MctM+2s=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P0TQ8bBR;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-76e4f2e4c40so5653563b3a.2
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757520566; x=1758125366; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=41IrheQrU1uNONBC2D87eHUDc3ROCWh6baPpZqwFKeI=;
        b=P0TQ8bBRT+OMxq78hFm5gBL6PuowO6c1bgg41t9YM41hlmw4JhqxkbPyp/dqZD/uab
         VC7YeiYxqEQj7UPYVlj41porICwI/auFg9o+sXBLXveJAuc2zRcCm/p3ppqX5bLcPaVY
         VyEKLfO1DBBcuBJHVCKL9kOuhAEaD1AP45zGRoIRgwnpy/HbglYdcJV/DhpOrsH5vOcT
         ltT65rH4xtK4B4KyN+Kwp2RqXqQkq8sp16IAxT5p8S2+YzXV7nU2fvi1C5OmRWaMvT53
         imDHgCVB+DYAhLOZd4btRYSwTo1IBpkruTKiPisnCH5v4K35gVb4iDehflSXn37QUzZH
         ZAGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757520566; x=1758125366;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=41IrheQrU1uNONBC2D87eHUDc3ROCWh6baPpZqwFKeI=;
        b=hEfbQt68G9PM0w3a81b4RV4PSPeaVKzeBF8QO9iSpAmdKt22joZUaGIjHDQ3TI0m8B
         R2wSpunq0UKORUG8cRcObEm67iIPRFFi5Mm3W4XZbM01x2qIWxEd+I1V5aHyNX5+8w1R
         heRy4CmtUrHhMqUWEBeeOqCoqjXqztbfmwvY/EjAuWMd7r8gHnutR7J/6Wwn01/xuZWD
         9atJJkwH05yCqd/EaoBikeTcmPINE/VPd+NQtPLu/QckaT6uKXPkz2U06ZndHm4B71zE
         7t3nGVhS5j/bkMba3M38icUAeS8DVUZZtpB/kYTkepOcKNDUkpdW+GyF5iDdXUoQ/8Co
         aJJw==
X-Gm-Message-State: AOJu0YxyTnoZqgKS/9LJkDe+NbatHGdgbWwkg7vqg7bBqpsS9wv5Fxfn
	6hFiZmAZqGvle2pQ+bFt4PYc38ekpy5ksJuPdBmN0bIzKxmHsPpjVWEYlyEBMEUqRsQ=
X-Gm-Gg: ASbGnctV/T7B4cMt9BaM8v7L3oN/WgMLQf3YhpoHIc2x44qhmLCIOoi8uNKUY/yg+SX
	x2wUOludHXBx+4O/QoXvDjDfwJAi0QbHSjf3qGM6ckcLJ5UD9T271r9ZcL8XlLDahljzuDWGfro
	eG3cRL2fVCZeuz1JVhkZcUNuU+ydDTs4sByq+vPXMY07H9FgjeloImChsGUfOUMHhQ6kO7kOWlG
	fbeeoTpiLhjXURK3pvZl6Lh6yNt/5VI1+y0ZMrHcmMwEueli/cZ6W6/OGbpnwEei3gw4SyTKvgT
	4r9KxFsPY9V715vHJtPu+SAzOWwnFAa7+NQaMh1o+TaemSkuRprEJvtoqC0nL45RehMSsp8MGqv
	ad+ojANVu2rHJ8Dvdms6SsesXYQ6Zy/tIXwTKQvwH4OJj+4l/nLKy5W4pmg==
X-Google-Smtp-Source: AGHT+IGX1OhgXhkIxofCcoD4B7nQIR9FtlH0Q7qIyxMOhhjXQBkvBpqTM/Oc2XmvflNOYzzMsOTu9A==
X-Received: by 2002:a05:6a20:2591:b0:24e:c235:d7e6 with SMTP id adf61e73a8af0-2533d5fed90mr25408969637.5.1757520565690;
        Wed, 10 Sep 2025 09:09:25 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54998a1068sm1000142a12.31.2025.09.10.09.09.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 10 Sep 2025 09:09:25 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v3 08/15] mm, swap: cleanup swap cache API and add kerneldoc
Date: Thu, 11 Sep 2025 00:08:26 +0800
Message-ID: <20250910160833.3464-9-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910160833.3464-1-ryncsn@gmail.com>
References: <20250910160833.3464-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m5sb194x9z1mwr5a339n1fnhzncnwjac
X-Rspam-User: 
X-Rspamd-Queue-Id: 772291C0007
X-Rspamd-Server: rspam10
X-HE-Tag: 1757520567-529321
X-HE-Meta: U2FsdGVkX1/QYabS6w/rrm870UpO1uzgHgByRTqadArXaDqoJO8WIDlq9hUbCJFkz4ezCVIWP5vQqzHZnEbHjDu1rPiraTKmVcipKAB2dajhI28VQppA4vEABrQG0BmS1uUwR7kvnUYzcbEl1V95gezhSBDG0QOKY2Z2HqWU4zUCK3ALPJ9pdJlONGc9nogiwHxlCmM6/htGdHyH+OjU5TqtjGfS2JOyRoMl+3iWS8tND0wajs4/tzip3uyfVXiejGBvj5qYurToegfMkVP8STO+GPX3yY3Tp8bwHSxTI7aojTnPFvTlyFnfRyCozLWv7D3P9NGgNrOI+WVpQWVZOg1x+0uTNSM/QsYnm+Z387L19b+2XS/ivVukZ+DCGNfQiZZmm3nQUSTZcVV7A4xwuP6pppjuBxKg28W4xrye0/qd6SvvEQu7qMt97O3BtHGTUqpBgevgyMAnaN00OZYnFZ4ZUlm9lmYnEh5OpTZiuAj59te0w+869YEI7aNfTuG4F8jPuYvD1HzqukRaptDJWP3oIOvtgMl7YF9WgcXCTuX8uKTgQrMvxuZ6YVVJfQPntWxTUXJhv2HnlHBTjT6A7QuNSt1o/lZjomB22hbMRUZq5OGhtU0yAvpM3jvq7jcy7YXTkxiiEyr4BHXNd5BnddnbfjvvR8Z6dV5xgxdLvqPKn1JMQL+JYRx4FI9G7CPAdisZhuOB7EkeyUjqRECsf5y6WTdTMQx6eYfHOMrZY0VphgO2aCff4YjNJ6KwUG2jEdT0OIJqPTGcdoOKKqHjB2ALtRVZrzgAf193RwjfPzEYLRfO/V2e9vILxp0TaJ0szo9F6qCfAbs3mB7DsoDvnz83ueFRtl/SsoNGVo0d9H/Y5OX0Uqa/AkKfouPKK05i1+dmw8vIS1HDsD9XsVp0Cn/Hsz0nkiUidVfeF/SFhjbINGqggX5Sn3m2S/TMIGqEDVFEy/BBCGgz4NbW/O3
 5kixl3CA
 HHS2pbBbhow9KE8QiF9pOjcfnK0AvIl3MTW0xUXxj6OGSpZfrcaTwXpSzIVP8Bn6hRb7JBzPxz+/JyoGwiNAfGKgbSA81w36xqZzv7NrlaBZNt/vg9f288hTsFa4KLVEDWNK5GzmgHjJBfyGPV/7XGnhQ+lq1hbj9U89N8qZcjratCobh9poJoBDjrSa2bDHYDHTfx/f+x8YkLRurHInP2sPbIayJSprxFYNfTbaH8AqobB933SFv/pl4xBPoLuajmdgIfxD+rqxyUTq4gIowrCiUXTsCUA54TrmzOYOTken32rBQtFBa4AGOU6xE62iauFdOmt8ty5B14iDnQ3wVrmS1Cpp+bJ55O1WujWTe275tbFWBNscMi2xrp+ntVs8jRJVurN88aW4HTgRqxwmJMaeM1KQcBE7thD/dF2gaYmphHpoHkwNiNShRa/tBhm8kwo/nk9l5eF8lIow0OHGjSElTSsfGaCqTU5caydpd2LpKhWm7Kxk3oqfxX8i+hKvhuAoYue9IUiMdWgAWolrFBMake5VfRp+OdByXVICbqpaOeitmlGitkfa6zqTNh/EQr6/giOVtU1jWWnYAVv39bCH6YBRbztq7dj5MNemy7bOWHK6Gi5MR3Pb05a179WvG8zKl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

In preparation for replacing the swap cache backend with the swap table,
clean up and add proper kernel doc for all swap cache APIs. Now all swap
cache APIs are well-defined with consistent names.

No feature change, only renaming and documenting.

Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 mm/filemap.c        |  2 +-
 mm/memory-failure.c |  2 +-
 mm/memory.c         |  2 +-
 mm/swap.h           | 48 ++++++++++++++-----------
 mm/swap_state.c     | 86 ++++++++++++++++++++++++++++++++-------------
 mm/swapfile.c       |  8 ++---
 mm/vmscan.c         |  2 +-
 mm/zswap.c          |  2 +-
 8 files changed, 98 insertions(+), 54 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 8d078aa2738a..2a05b1fdd445 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4525,7 +4525,7 @@ static void filemap_cachestat(struct address_space *mapping,
 				 * invalidation, so there might not be
 				 * a shadow in the swapcache (yet).
 				 */
-				shadow = get_shadow_from_swap_cache(swp);
+				shadow = swap_cache_get_shadow(swp);
 				if (!shadow)
 					goto resched;
 			}
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 6d9134e3d115..3edebb0cda30 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1127,7 +1127,7 @@ static int me_swapcache_clean(struct page_state *ps, struct page *p)
 	struct folio *folio = page_folio(p);
 	int ret;
 
-	delete_from_swap_cache(folio);
+	swap_cache_del_folio(folio);
 
 	ret = delete_from_lru_cache(folio) ? MF_FAILED : MF_RECOVERED;
 	folio_unlock(folio);
diff --git a/mm/memory.c b/mm/memory.c
index 5808c4ef21b3..41e641823558 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4699,7 +4699,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 
 				memcg1_swapin(entry, nr_pages);
 
-				shadow = get_shadow_from_swap_cache(entry);
+				shadow = swap_cache_get_shadow(entry);
 				if (shadow)
 					workingset_refault(folio, shadow);
 
diff --git a/mm/swap.h b/mm/swap.h
index 30b1039c27fe..6c4acb549bec 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -167,17 +167,29 @@ static inline bool folio_matches_swap_entry(const struct folio *folio,
 	return folio_entry.val == round_down(entry.val, nr_pages);
 }
 
+/*
+ * All swap cache helpers below require the caller to ensure the swap entries
+ * used are valid and stablize the device by any of the following ways:
+ * - Hold a reference by get_swap_device(): this ensures a single entry is
+ *   valid and increases the swap device's refcount.
+ * - Locking a folio in the swap cache: this ensures the folio's swap entries
+ *   are valid and pinned, also implies reference to the device.
+ * - Locking anything referencing the swap entry: e.g. PTL that protects
+ *   swap entries in the page table, similar to locking swap cache folio.
+ * - See the comment of get_swap_device() for more complex usage.
+ */
+struct folio *swap_cache_get_folio(swp_entry_t entry);
+void *swap_cache_get_shadow(swp_entry_t entry);
+int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
+			 gfp_t gfp, void **shadow);
+void swap_cache_del_folio(struct folio *folio);
+void __swap_cache_del_folio(struct folio *folio,
+			    swp_entry_t entry, void *shadow);
+void swap_cache_clear_shadow(int type, unsigned long begin,
+			     unsigned long end);
+
 void show_swap_cache_info(void);
-void *get_shadow_from_swap_cache(swp_entry_t entry);
-int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
-		      gfp_t gfp, void **shadowp);
-void __delete_from_swap_cache(struct folio *folio,
-			      swp_entry_t entry, void *shadow);
-void delete_from_swap_cache(struct folio *folio);
-void clear_shadow_from_swap_cache(int type, unsigned long begin,
-				  unsigned long end);
 void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
-struct folio *swap_cache_get_folio(swp_entry_t entry);
 struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		struct vm_area_struct *vma, unsigned long addr,
 		struct swap_iocb **plug);
@@ -305,28 +317,22 @@ static inline struct folio *swap_cache_get_folio(swp_entry_t entry)
 	return NULL;
 }
 
-static inline void *get_shadow_from_swap_cache(swp_entry_t entry)
+static inline void *swap_cache_get_shadow(swp_entry_t entry)
 {
 	return NULL;
 }
 
-static inline int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
-					gfp_t gfp_mask, void **shadowp)
-{
-	return -1;
-}
-
-static inline void __delete_from_swap_cache(struct folio *folio,
-					swp_entry_t entry, void *shadow)
+static inline int swap_cache_add_folio(swp_entry_t entry, struct folio *folio,
+				       gfp_t gfp, void **shadow)
 {
+	return -EINVAL;
 }
 
-static inline void delete_from_swap_cache(struct folio *folio)
+static inline void swap_cache_del_folio(struct folio *folio)
 {
 }
 
-static inline void clear_shadow_from_swap_cache(int type, unsigned long begin,
-				unsigned long end)
+static inline void __swap_cache_del_folio(struct folio *folio, swp_entry_t entry, void *shadow)
 {
 }
 
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 0ad4f3b41f1b..f3a32a06a950 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -78,8 +78,8 @@ void show_swap_cache_info(void)
  * Context: Caller must ensure @entry is valid and protect the swap device
  * with reference count or locks.
  * Return: Returns the found folio on success, NULL otherwise. The caller
- * must lock and check if the folio still matches the swap entry before
- * use (e.g. with folio_matches_swap_entry).
+ * must lock nd check if the folio still matches the swap entry before
+ * use (e.g., folio_matches_swap_entry).
  */
 struct folio *swap_cache_get_folio(swp_entry_t entry)
 {
@@ -90,7 +90,15 @@ struct folio *swap_cache_get_folio(swp_entry_t entry)
 	return folio;
 }
 
-void *get_shadow_from_swap_cache(swp_entry_t entry)
+/**
+ * swap_cache_get_shadow - Looks up a shadow in the swap cache.
+ * @entry: swap entry used for the lookup.
+ *
+ * Context: Caller must ensure @entry is valid and protect the swap device
+ * with reference count or locks.
+ * Return: Returns either NULL or an XA_VALUE (shadow).
+ */
+void *swap_cache_get_shadow(swp_entry_t entry)
 {
 	struct address_space *address_space = swap_address_space(entry);
 	pgoff_t idx = swap_cache_index(entry);
@@ -102,12 +110,21 @@ void *get_shadow_from_swap_cache(swp_entry_t entry)
 	return NULL;
 }
 
-/*
- * add_to_swap_cache resembles filemap_add_folio on swapper_space,
- * but sets SwapCache flag and 'swap' instead of mapping and index.
+/**
+ * swap_cache_add_folio - Add a folio into the swap cache.
+ * @folio: The folio to be added.
+ * @entry: The swap entry corresponding to the folio.
+ * @gfp: gfp_mask for XArray node allocation.
+ * @shadowp: If a shadow is found, return the shadow.
+ *
+ * Context: Caller must ensure @entry is valid and protect the swap device
+ * with reference count or locks.
+ * The caller also needs to mark the corresponding swap_map slots with
+ * SWAP_HAS_CACHE to avoid race or conflict.
+ * Return: Returns 0 on success, error code otherwise.
  */
-int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
-			gfp_t gfp, void **shadowp)
+int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
+			 gfp_t gfp, void **shadowp)
 {
 	struct address_space *address_space = swap_address_space(entry);
 	pgoff_t idx = swap_cache_index(entry);
@@ -155,12 +172,20 @@ int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
 	return xas_error(&xas);
 }
 
-/*
- * This must be called only on folios that have
- * been verified to be in the swap cache.
+/**
+ * __swap_cache_del_folio - Removes a folio from the swap cache.
+ * @folio: The folio.
+ * @entry: The first swap entry that the folio corresponds to.
+ * @shadow: shadow value to be filled in the swap cache.
+ *
+ * Removes a folio from the swap cache and fills a shadow in place.
+ * This won't put the folio's refcount. The caller has to do that.
+ *
+ * Context: Caller must hold the xa_lock, ensure the folio is
+ * locked and in the swap cache, using the index of @entry.
  */
-void __delete_from_swap_cache(struct folio *folio,
-			swp_entry_t entry, void *shadow)
+void __swap_cache_del_folio(struct folio *folio,
+			    swp_entry_t entry, void *shadow)
 {
 	struct address_space *address_space = swap_address_space(entry);
 	int i;
@@ -186,27 +211,40 @@ void __delete_from_swap_cache(struct folio *folio,
 	__lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr);
 }
 
-/*
- * This must be called only on folios that have
- * been verified to be in the swap cache and locked.
- * It will never put the folio into the free list,
- * the caller has a reference on the folio.
+/**
+ * swap_cache_del_folio - Removes a folio from the swap cache.
+ * @folio: The folio.
+ *
+ * Same as __swap_cache_del_folio, but handles lock and refcount. The
+ * caller must ensure the folio is either clean or has a swap count
+ * equal to zero, or it may cause data loss.
+ *
+ * Context: Caller must ensure the folio is locked and in the swap cache.
  */
-void delete_from_swap_cache(struct folio *folio)
+void swap_cache_del_folio(struct folio *folio)
 {
 	swp_entry_t entry = folio->swap;
 	struct address_space *address_space = swap_address_space(entry);
 
 	xa_lock_irq(&address_space->i_pages);
-	__delete_from_swap_cache(folio, entry, NULL);
+	__swap_cache_del_folio(folio, entry, NULL);
 	xa_unlock_irq(&address_space->i_pages);
 
 	put_swap_folio(folio, entry);
 	folio_ref_sub(folio, folio_nr_pages(folio));
 }
 
-void clear_shadow_from_swap_cache(int type, unsigned long begin,
-				unsigned long end)
+/**
+ * swap_cache_clear_shadow - Clears a set of shadows in the swap cache.
+ * @type: Indicates the swap device.
+ * @begin: Beginning offset of the range.
+ * @end: Ending offset of the range.
+ *
+ * Context: Caller must ensure the range is valid and hold a reference to
+ * the swap device.
+ */
+void swap_cache_clear_shadow(int type, unsigned long begin,
+			     unsigned long end)
 {
 	unsigned long curr = begin;
 	void *old;
@@ -393,7 +431,7 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 			goto put_and_return;
 
 		/*
-		 * We might race against __delete_from_swap_cache(), and
+		 * We might race against __swap_cache_del_folio(), and
 		 * stumble across a swap_map entry whose SWAP_HAS_CACHE
 		 * has not yet been cleared.  Or race against another
 		 * __read_swap_cache_async(), which has set SWAP_HAS_CACHE
@@ -412,7 +450,7 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		goto fail_unlock;
 
 	/* May fail (-ENOMEM) if XArray node allocation failed. */
-	if (add_to_swap_cache(new_folio, entry, gfp_mask & GFP_RECLAIM_MASK, &shadow))
+	if (swap_cache_add_folio(new_folio, entry, gfp_mask & GFP_RECLAIM_MASK, &shadow))
 		goto fail_unlock;
 
 	memcg1_swapin(entry, 1);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 51c159aa646c..6f5206255789 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -266,7 +266,7 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
 	if (!need_reclaim)
 		goto out_unlock;
 
-	delete_from_swap_cache(folio);
+	swap_cache_del_folio(folio);
 	folio_set_dirty(folio);
 	ret = nr_pages;
 out_unlock:
@@ -1123,7 +1123,7 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 			swap_slot_free_notify(si->bdev, offset);
 		offset++;
 	}
-	clear_shadow_from_swap_cache(si->type, begin, end);
+	swap_cache_clear_shadow(si->type, begin, end);
 
 	/*
 	 * Make sure that try_to_unuse() observes si->inuse_pages reaching 0
@@ -1288,7 +1288,7 @@ int folio_alloc_swap(struct folio *folio, gfp_t gfp)
 	 * TODO: this could cause a theoretical memory reclaim
 	 * deadlock in the swap out path.
 	 */
-	if (add_to_swap_cache(folio, entry, gfp | __GFP_NOMEMALLOC, NULL))
+	if (swap_cache_add_folio(folio, entry, gfp | __GFP_NOMEMALLOC, NULL))
 		goto out_free;
 
 	return 0;
@@ -1758,7 +1758,7 @@ bool folio_free_swap(struct folio *folio)
 	if (folio_swapped(folio))
 		return false;
 
-	delete_from_swap_cache(folio);
+	swap_cache_del_folio(folio);
 	folio_set_dirty(folio);
 	return true;
 }
diff --git a/mm/vmscan.c b/mm/vmscan.c
index ca9e1cd3cd68..c79c6806560b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -776,7 +776,7 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 
 		if (reclaimed && !mapping_exiting(mapping))
 			shadow = workingset_eviction(folio, target_memcg);
-		__delete_from_swap_cache(folio, swap, shadow);
+		__swap_cache_del_folio(folio, swap, shadow);
 		memcg1_swapout(folio, swap);
 		xa_unlock_irq(&mapping->i_pages);
 		put_swap_folio(folio, swap);
diff --git a/mm/zswap.c b/mm/zswap.c
index c88ad61b232c..3dda4310099e 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1069,7 +1069,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 
 out:
 	if (ret && ret != -EEXIST) {
-		delete_from_swap_cache(folio);
+		swap_cache_del_folio(folio);
 		folio_unlock(folio);
 	}
 	folio_put(folio);
-- 
2.51.0


