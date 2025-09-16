Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1085ECAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 16:02:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 528008E0026; Tue, 16 Sep 2025 12:02:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D83F8E0001; Tue, 16 Sep 2025 12:02:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EF2E8E0026; Tue, 16 Sep 2025 12:02:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 287368E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:02:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E310D118CBC
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:02:47 +0000 (UTC)
X-FDA: 83895581574.02.D1BF4EF
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id D4D541C001A
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:02:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NZYNshwg;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758038565;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gTSGPwTupsl07mG7Sko3GwC2DzpjYWJjLeYVvC9wd5M=;
	b=p3CY4Xl9fdS6588lRVlNE3qZSCoBC9YKLfXQPGe133kwoISiBINTx4Fyv6DYhLkpEztMx1
	rFN+u9URivXZERDi30g0mcHDAS9KarCevhC/Hf+rL9JFD+AagB8o+AZTYJzWN/mKRYhJi2
	0LP8iB0IyM1rFt1b0r0ROrriQAiTI6o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758038566; a=rsa-sha256;
	cv=none;
	b=hKwbGwCDWbrl8aM4ysZG+Ws10o46LCFYBLkPD2MzW3ZBnqEKrsC40JgsTq67/+rZcjoEzz
	0P2SqTJZzXe+ij8i/lFPx58spasB2i8X9qq4GvVcyCJYFdK9DHacJDPPq7BZg7AJrdidAY
	vHl5PxTzbDuPT1eCv+i79pJkSDh1F78=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NZYNshwg;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-816ac9f9507so757637585a.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758038564; x=1758643364; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gTSGPwTupsl07mG7Sko3GwC2DzpjYWJjLeYVvC9wd5M=;
        b=NZYNshwg6a34WNQzF5qZj6efa6DfmTakYI48OccOkE+Ds6eA4HskZlpN5ucQoP/YX+
         9CimDkAdnYPmhKEQakuPqYPz0Rb4Ev89YI5+4JBGawOJqAKhFR+O2drjyLLQszNt4RDJ
         5XU6f4riERfHloyEhVwMIduz8sv/oeBfEFpJmffsYfwE7l7brvMZyZtMHjQABfPuewmV
         CpuaeM9Lal0xzv7tqr+v9n+VjxpsONYEZLW8U0s9zogR9a34BJckTrJ1+ewVgZjA6giu
         ++JeEPaa2jJ6VU+OldwGgu79xDoHuzalZ6QKjLty35pbI+OdZaUuQ9buKQXMk4vJZUSU
         cJ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758038564; x=1758643364;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gTSGPwTupsl07mG7Sko3GwC2DzpjYWJjLeYVvC9wd5M=;
        b=oDvLX5Ws0OiqzQL9sUui/yb3M8oip533BQ1p7uBhFGfS8IPoUTd36T4UQbvK+slMqj
         ETKsFttjLRZB3W2j2iPepklLkc23DCuH+BySWp4brs5jbZNht4rTDY+cVnkC6cxLKQAA
         b2qee5ag0seImb4wI25ISOLwfh+oSj87bkdsfc0qoUU8Cwm8L+UhzMVEUmCQ5l0mzeSB
         +R/ucm7aNx1eoNRwrNb7c4ozwpdm3EQ6mj1ZHrYOdc0mo7isQxanu0F14E/NZOovn44W
         IySdTjlivMGd/IgJGttioGeiV/uWwlnFITrJWpTLG4UDpFsaR64LOEGP5TOOLeHcQyCt
         jgDA==
X-Gm-Message-State: AOJu0YxQXz4ieXpTRyhJBFJT+g9NzhIeIRDi5aAeto/OkvlPOxwPW1WU
	/UEnwsrVYhkUl+6SPXPi7ZUxyb5ESmTq69KQ1UpvrTr+X80z5APM+W2uVBjThuyAopI=
X-Gm-Gg: ASbGnctLegmlNjoj8gE0bAbYdC8M+YkbUVh21PL0rn5fr1z7GOLaiclHKW5bjecfrU5
	5QIXPkposANnmLa3g6lXN3zQRYRSkMfdSamRgbkRRycLXpeq4Jw6WrMtBx+SdRS5Xi+TzhxSG7j
	pTfyonrbNc2FGp3tPeXbx9awiTUkdvT3RnOEOW8O5HdWq4fyIE3vJkqgw3OsCCCTUCq2LZBjlvs
	TIrfngRIazW6JpSIKn/vHiNvdt+tn5r7N17xwwla0G9rh1124lHSXlF9UxXg8iaVveAf59KLCx3
	b2yI8MZWEQhNiIH6hiUv2ddJT+U203Gd7gzFDpXv1EF+1bGuhMjnmD4NQTlILdC508pXyL0nlck
	HbNsaH9sEgue5NwUTQxdtnyyo6XXfXJRPi5/asBhl9i0t65zRp4s8YkciSg==
X-Google-Smtp-Source: AGHT+IGsq3cAoMQCpRVCszGVkcOQBHFep3v4Kswe//NGVefOdyjKK7yL5pcrQVxxAUWszoihv1qb/g==
X-Received: by 2002:a05:620a:170f:b0:81a:c1cc:b01b with SMTP id af79cd13be357-82b9d2fe192mr314137685a.27.1758038564020;
        Tue, 16 Sep 2025 09:02:44 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-820cd703f54sm969765485a.37.2025.09.16.09.02.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Sep 2025 09:02:43 -0700 (PDT)
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
Subject: [PATCH v4 14/15] mm, swap: implement dynamic allocation of swap table
Date: Wed, 17 Sep 2025 00:00:59 +0800
Message-ID: <20250916160100.31545-15-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250916160100.31545-1-ryncsn@gmail.com>
References: <20250916160100.31545-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zfdqfjizkf3stcq8qqkdcg3hftm4af1z
X-Rspam-User: 
X-Rspamd-Queue-Id: D4D541C001A
X-Rspamd-Server: rspam10
X-HE-Tag: 1758038565-950637
X-HE-Meta: U2FsdGVkX19CL18juN6KC45vfeIqBN9ScIoc+POE/BriDwMWQUyDHYH3GEJqDlkV6IyNESiOLYNP7YjoIsCTerlQTUWmbXDgAjAH6ZcNsbBu2WFcOQ7wsUY7NxVPcqzkFHfvfqDRcqYtBNYqMkbSbZSw+zzOVbKkK3rOBz1tSJd9YTIiXaBuzf3XVpnklHFwLxTIWoUUk25MCM/35df9QGbuwHNTMRuZbzxCOEg3HEcCc9RPWnW+iwiqj4iK7GCnsh11GepHX3+GPsEmWfDHbYkiCkY5QHd0Ln+zP2jfhb8wNB/WwOGUvdsIHwR+co7DrtIHltlYo+lf3jviHzEK74MlvFsa0LN0m6N1JkrTy3mTLHOEhRr2JwJtQN4pocKDHLK3bAM9uquPn4DRjxtSfHV5hAwjI3Tl2pndgWuRDTNYAXGYOd7FTzA/+uPk7IZ+Hhc1aW0JL1imFqR5LU63DlZjg+BXS0c6/oQ1Wrp1vvmUEE+X13XGXIcxhko9AQgH3EOgR1JAS1PG1DnLBdZ+lCK204dR3RcfieU6JPj9QOgEg6SdYDI5kEatOGmQMZII6qqSdZuA25ItuPQ45SIBVgwY9iOm6g/BNSRict5TGOHHgkft48+hj0SKiUcv3I+LbwNBy1TI2g3KyMmF+c2PxwaI1CAx0bwz8Ol44De5OulZlO1LHygBORuR33JMaJrP/lEulxbfOhqecqLLRdwpyGEAa1uB/xNCh/LfUFj/HMzPFUYlGAB5Mb9uwg5xWPXIFT+nU8FP7F+kZZs2futd/XRs6IpBUqOFi3GiY/O/03zPCHmoJAIh1ILt1F4fCybfDm8wNmoA/isaUjh0hWh0X9xyHbSZbSaY36U+iYDpaEygru69xoNUwKqReFPxutPP5kd+vQpPIJ6b3joi/sWz9976l8Zbtc6gqqHtnGcLZhe2Ok5+IKSKb6OjvyhNhxu9WRR+STtUkuUygqFxBf/
 KVi1vHro
 Z6dimYvCNuYD0E6P4TSciRZBInNAtE5sjkewRsOPg3V6j75ksxSkaDARZ+eEwvVidkM+jUAKDb1gIRzOEdw+lMIY/7V4oamNFI2K/lQw74pbZx4oAnN9P6eoQ3qGheEFDKv0g1ag3uqXog8NY8mfHoMAEiVBhdcLr0jvxA1bkMfG/S70NT6bqjmRFkL3mdRpeu6OU09yXx/H4p89NNtLfvSVUUThWqFvVqoP7zkNIl4ZUnndkKF0xrFBYBilaQ8mzxpSw0LUpybnwS4ACYFxR/DeTvhbISimtyooSP9zeXj4xj6W/vv5YsrB1g5056YwFTePEvFCxinno3POQtP9ZN9m5RMtBIEeLDm2PHAcj/mrQjxB5HGzy75zC4NBN7U0I30UgBdH900wHqyNU6AkMQNauQd4xPfxo5Bb+BKvdFXPk1od9UST+l6u3HSpl+DoG91P22aKFmgNbnIUZrZDQmCLQhAj6XbLWcbbcIwpww8QST3VUVd/TWkvgU0h3jDqBQccfba2t/qqD3qNQjS7FebF8EFxkngLbk4dNC3H3JxnDMAaGUU7M+8aaCXOin6c7xb6il//DyjMmzKy7mtRrQL8lSsn16z+9+GqH+Lsqk9Uy7Zo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now swap table is cluster based, which means free clusters can free its
table since no one should modify it.

There could be speculative readers, like swap cache look up, protect
them by making them RCU protected. All swap table should be filled with
null entries before free, so such readers will either see a NULL pointer
or a null filled table being lazy freed.

On allocation, allocate the table when a cluster is used by any order.

This way, we can reduce the memory usage of large swap device
significantly.

This idea to dynamically release unused swap cluster data was initially
suggested by Chris Li while proposing the cluster swap allocator and
it suits the swap table idea very well.

Co-developed-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap.h       |   2 +-
 mm/swap_state.c |   9 +--
 mm/swap_table.h |  37 ++++++++-
 mm/swapfile.c   | 197 +++++++++++++++++++++++++++++++++++++-----------
 4 files changed, 194 insertions(+), 51 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index fe5c20922082..8d8efdf1297a 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -36,7 +36,7 @@ struct swap_cluster_info {
 	u16 count;
 	u8 flags;
 	u8 order;
-	atomic_long_t *table;	/* Swap table entries, see mm/swap_table.h */
+	atomic_long_t __rcu *table;	/* Swap table entries, see mm/swap_table.h */
 	struct list_head list;
 };
 
diff --git a/mm/swap_state.c b/mm/swap_state.c
index a1478cbff384..b13e9c4baa90 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -91,8 +91,8 @@ struct folio *swap_cache_get_folio(swp_entry_t entry)
 	struct folio *folio;
 
 	for (;;) {
-		swp_tb = __swap_table_get(__swap_entry_to_cluster(entry),
-					  swp_cluster_offset(entry));
+		swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
+					swp_cluster_offset(entry));
 		if (!swp_tb_is_folio(swp_tb))
 			return NULL;
 		folio = swp_tb_to_folio(swp_tb);
@@ -115,11 +115,10 @@ void *swap_cache_get_shadow(swp_entry_t entry)
 {
 	unsigned long swp_tb;
 
-	swp_tb = __swap_table_get(__swap_entry_to_cluster(entry),
-				  swp_cluster_offset(entry));
+	swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
+				swp_cluster_offset(entry));
 	if (swp_tb_is_shadow(swp_tb))
 		return swp_tb_to_shadow(swp_tb);
-
 	return NULL;
 }
 
diff --git a/mm/swap_table.h b/mm/swap_table.h
index e1f7cc009701..52254e455304 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -2,8 +2,15 @@
 #ifndef _MM_SWAP_TABLE_H
 #define _MM_SWAP_TABLE_H
 
+#include <linux/rcupdate.h>
+#include <linux/atomic.h>
 #include "swap.h"
 
+/* A typical flat array in each cluster as swap table */
+struct swap_table {
+	atomic_long_t entries[SWAPFILE_CLUSTER];
+};
+
 /*
  * A swap table entry represents the status of a swap slot on a swap
  * (physical or virtual) device. The swap table in each cluster is a
@@ -76,22 +83,46 @@ static inline void *swp_tb_to_shadow(unsigned long swp_tb)
 static inline void __swap_table_set(struct swap_cluster_info *ci,
 				    unsigned int off, unsigned long swp_tb)
 {
+	atomic_long_t *table = rcu_dereference_protected(ci->table, true);
+
+	lockdep_assert_held(&ci->lock);
 	VM_WARN_ON_ONCE(off >= SWAPFILE_CLUSTER);
-	atomic_long_set(&ci->table[off], swp_tb);
+	atomic_long_set(&table[off], swp_tb);
 }
 
 static inline unsigned long __swap_table_xchg(struct swap_cluster_info *ci,
 					      unsigned int off, unsigned long swp_tb)
 {
+	atomic_long_t *table = rcu_dereference_protected(ci->table, true);
+
+	lockdep_assert_held(&ci->lock);
 	VM_WARN_ON_ONCE(off >= SWAPFILE_CLUSTER);
 	/* Ordering is guaranteed by cluster lock, relax */
-	return atomic_long_xchg_relaxed(&ci->table[off], swp_tb);
+	return atomic_long_xchg_relaxed(&table[off], swp_tb);
 }
 
 static inline unsigned long __swap_table_get(struct swap_cluster_info *ci,
 					     unsigned int off)
 {
+	atomic_long_t *table;
+
 	VM_WARN_ON_ONCE(off >= SWAPFILE_CLUSTER);
-	return atomic_long_read(&ci->table[off]);
+	table = rcu_dereference_check(ci->table, lockdep_is_held(&ci->lock));
+
+	return atomic_long_read(&table[off]);
+}
+
+static inline unsigned long swap_table_get(struct swap_cluster_info *ci,
+					unsigned int off)
+{
+	atomic_long_t *table;
+	unsigned long swp_tb;
+
+	rcu_read_lock();
+	table = rcu_dereference(ci->table);
+	swp_tb = table ? atomic_long_read(&table[off]) : null_to_swp_tb();
+	rcu_read_unlock();
+
+	return swp_tb;
 }
 #endif
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 314c5c10d3bd..094e3e75849f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -59,6 +59,9 @@ static void swap_entries_free(struct swap_info_struct *si,
 static void swap_range_alloc(struct swap_info_struct *si,
 			     unsigned int nr_entries);
 static bool folio_swapcache_freeable(struct folio *folio);
+static void move_cluster(struct swap_info_struct *si,
+			 struct swap_cluster_info *ci, struct list_head *list,
+			 enum swap_cluster_flags new_flags);
 
 static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
@@ -105,6 +108,8 @@ static DEFINE_SPINLOCK(swap_avail_lock);
 
 struct swap_info_struct *swap_info[MAX_SWAPFILES];
 
+static struct kmem_cache *swap_table_cachep;
+
 static DEFINE_MUTEX(swapon_mutex);
 
 static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
@@ -401,10 +406,17 @@ static inline bool cluster_is_discard(struct swap_cluster_info *info)
 	return info->flags == CLUSTER_FLAG_DISCARD;
 }
 
+static inline bool cluster_table_is_alloced(struct swap_cluster_info *ci)
+{
+	return rcu_dereference_protected(ci->table, lockdep_is_held(&ci->lock));
+}
+
 static inline bool cluster_is_usable(struct swap_cluster_info *ci, int order)
 {
 	if (unlikely(ci->flags > CLUSTER_FLAG_USABLE))
 		return false;
+	if (!cluster_table_is_alloced(ci))
+		return false;
 	if (!order)
 		return true;
 	return cluster_is_empty(ci) || order == ci->order;
@@ -422,32 +434,90 @@ static inline unsigned int cluster_offset(struct swap_info_struct *si,
 	return cluster_index(si, ci) * SWAPFILE_CLUSTER;
 }
 
-static int swap_cluster_alloc_table(struct swap_cluster_info *ci)
+static void swap_cluster_free_table(struct swap_cluster_info *ci)
 {
-	WARN_ON(ci->table);
-	ci->table = kzalloc(sizeof(unsigned long) * SWAPFILE_CLUSTER, GFP_KERNEL);
-	if (!ci->table)
-		return -ENOMEM;
-	return 0;
+	unsigned int ci_off;
+	struct swap_table *table;
+
+	/* Only empty cluster's table is allow to be freed  */
+	lockdep_assert_held(&ci->lock);
+	VM_WARN_ON_ONCE(!cluster_is_empty(ci));
+	for (ci_off = 0; ci_off < SWAPFILE_CLUSTER; ci_off++)
+		VM_WARN_ON_ONCE(!swp_tb_is_null(__swap_table_get(ci, ci_off)));
+	table = (void *)rcu_dereference_protected(ci->table, true);
+	rcu_assign_pointer(ci->table, NULL);
+
+	kmem_cache_free(swap_table_cachep, table);
 }
 
-static void swap_cluster_free_table(struct swap_cluster_info *ci)
+/*
+ * Allocate swap table for one cluster. Attempt an atomic allocation first,
+ * then fallback to sleeping allocation.
+ */
+static struct swap_cluster_info *
+swap_cluster_alloc_table(struct swap_info_struct *si,
+			 struct swap_cluster_info *ci)
 {
-	unsigned int ci_off;
-	unsigned long swp_tb;
+	struct swap_table *table;
 
-	if (!ci->table)
-		return;
+	/*
+	 * Only cluster isolation from the allocator does table allocation.
+	 * Swap allocator uses percpu clusters and holds the local lock.
+	 */
+	lockdep_assert_held(&ci->lock);
+	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
+
+	/* The cluster must be free and was just isolated from the free list. */
+	VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
+
+	table = kmem_cache_zalloc(swap_table_cachep,
+				  __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
+	if (table) {
+		rcu_assign_pointer(ci->table, table);
+		return ci;
+	}
+
+	/*
+	 * Try a sleep allocation. Each isolated free cluster may cause
+	 * a sleep allocation, but there is a limited number of them, so
+	 * the potential recursive allocation is limited.
+	 */
+	spin_unlock(&ci->lock);
+	if (!(si->flags & SWP_SOLIDSTATE))
+		spin_unlock(&si->global_cluster_lock);
+	local_unlock(&percpu_swap_cluster.lock);
+
+	table = kmem_cache_zalloc(swap_table_cachep,
+				  __GFP_HIGH | __GFP_NOMEMALLOC | GFP_KERNEL);
+
+	/*
+	 * Back to atomic context. We might have migrated to a new CPU with a
+	 * usable percpu cluster. But just keep using the isolated cluster to
+	 * make things easier. Migration indicates a slight change of workload
+	 * so using a new free cluster might not be a bad idea, and the worst
+	 * could happen with ignoring the percpu cluster is fragmentation,
+	 * which is acceptable since this fallback and race is rare.
+	 */
+	local_lock(&percpu_swap_cluster.lock);
+	if (!(si->flags & SWP_SOLIDSTATE))
+		spin_lock(&si->global_cluster_lock);
+	spin_lock(&ci->lock);
 
-	for (ci_off = 0; ci_off < SWAPFILE_CLUSTER; ci_off++) {
-		swp_tb = __swap_table_get(ci, ci_off);
-		if (!swp_tb_is_null(swp_tb))
-			pr_err_once("swap: unclean swap space on swapoff: 0x%lx",
-				    swp_tb);
+	/* Nothing except this helper should touch a dangling empty cluster. */
+	if (WARN_ON_ONCE(cluster_table_is_alloced(ci))) {
+		if (table)
+			kmem_cache_free(swap_table_cachep, table);
+		return ci;
 	}
 
-	kfree(ci->table);
-	ci->table = NULL;
+	if (!table) {
+		move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
+		spin_unlock(&ci->lock);
+		return NULL;
+	}
+
+	rcu_assign_pointer(ci->table, table);
+	return ci;
 }
 
 static void move_cluster(struct swap_info_struct *si,
@@ -479,7 +549,7 @@ static void swap_cluster_schedule_discard(struct swap_info_struct *si,
 
 static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info *ci)
 {
-	lockdep_assert_held(&ci->lock);
+	swap_cluster_free_table(ci);
 	move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 	ci->order = 0;
 }
@@ -494,15 +564,11 @@ static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info
  * this returns NULL for an non-empty list.
  */
 static struct swap_cluster_info *isolate_lock_cluster(
-		struct swap_info_struct *si, struct list_head *list)
+		struct swap_info_struct *si, struct list_head *list, int order)
 {
-	struct swap_cluster_info *ci, *ret = NULL;
+	struct swap_cluster_info *ci, *found = NULL;
 
 	spin_lock(&si->lock);
-
-	if (unlikely(!(si->flags & SWP_WRITEOK)))
-		goto out;
-
 	list_for_each_entry(ci, list, list) {
 		if (!spin_trylock(&ci->lock))
 			continue;
@@ -514,13 +580,19 @@ static struct swap_cluster_info *isolate_lock_cluster(
 
 		list_del(&ci->list);
 		ci->flags = CLUSTER_FLAG_NONE;
-		ret = ci;
+		found = ci;
 		break;
 	}
-out:
 	spin_unlock(&si->lock);
 
-	return ret;
+	if (found && !cluster_table_is_alloced(found)) {
+		/* Only an empty free cluster's swap table can be freed. */
+		VM_WARN_ON_ONCE(list != &si->free_clusters);
+		VM_WARN_ON_ONCE(!cluster_is_empty(found));
+		return swap_cluster_alloc_table(si, found);
+	}
+
+	return found;
 }
 
 /*
@@ -653,17 +725,27 @@ static void relocate_cluster(struct swap_info_struct *si,
  * added to free cluster list and its usage counter will be increased by 1.
  * Only used for initialization.
  */
-static void inc_cluster_info_page(struct swap_info_struct *si,
+static int inc_cluster_info_page(struct swap_info_struct *si,
 	struct swap_cluster_info *cluster_info, unsigned long page_nr)
 {
 	unsigned long idx = page_nr / SWAPFILE_CLUSTER;
+	struct swap_table *table;
 	struct swap_cluster_info *ci;
 
 	ci = cluster_info + idx;
+	if (!ci->table) {
+		table = kmem_cache_zalloc(swap_table_cachep, GFP_KERNEL);
+		if (!table)
+			return -ENOMEM;
+		rcu_assign_pointer(ci->table, table);
+	}
+
 	ci->count++;
 
 	VM_BUG_ON(ci->count > SWAPFILE_CLUSTER);
 	VM_BUG_ON(ci->flags);
+
+	return 0;
 }
 
 static bool cluster_reclaim_range(struct swap_info_struct *si,
@@ -845,7 +927,7 @@ static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 	unsigned int found = SWAP_ENTRY_INVALID;
 
 	do {
-		struct swap_cluster_info *ci = isolate_lock_cluster(si, list);
+		struct swap_cluster_info *ci = isolate_lock_cluster(si, list, order);
 		unsigned long offset;
 
 		if (!ci)
@@ -870,7 +952,7 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 	if (force)
 		to_scan = swap_usage_in_pages(si) / SWAPFILE_CLUSTER;
 
-	while ((ci = isolate_lock_cluster(si, &si->full_clusters))) {
+	while ((ci = isolate_lock_cluster(si, &si->full_clusters, 0))) {
 		offset = cluster_offset(si, ci);
 		end = min(si->max, offset + SWAPFILE_CLUSTER);
 		to_scan--;
@@ -1018,6 +1100,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 done:
 	if (!(si->flags & SWP_SOLIDSTATE))
 		spin_unlock(&si->global_cluster_lock);
+
 	return found;
 }
 
@@ -1885,7 +1968,13 @@ swp_entry_t get_swap_page_of_type(int type)
 	/* This is called for allocating swap entry, not cache */
 	if (get_swap_device_info(si)) {
 		if (si->flags & SWP_WRITEOK) {
+			/*
+			 * Grab the local lock to be complaint
+			 * with swap table allocation.
+			 */
+			local_lock(&percpu_swap_cluster.lock);
 			offset = cluster_alloc_swap_entry(si, 0, 1);
+			local_unlock(&percpu_swap_cluster.lock);
 			if (offset) {
 				entry = swp_entry(si->type, offset);
 				atomic_long_dec(&nr_swap_pages);
@@ -2679,12 +2768,21 @@ static void wait_for_allocation(struct swap_info_struct *si)
 static void free_cluster_info(struct swap_cluster_info *cluster_info,
 			      unsigned long maxpages)
 {
+	struct swap_cluster_info *ci;
 	int i, nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 
 	if (!cluster_info)
 		return;
-	for (i = 0; i < nr_clusters; i++)
-		swap_cluster_free_table(&cluster_info[i]);
+	for (i = 0; i < nr_clusters; i++) {
+		ci = cluster_info + i;
+		/* Cluster with bad marks count will have a remaining table */
+		spin_lock(&ci->lock);
+		if (rcu_dereference_protected(ci->table, true)) {
+			ci->count = 0;
+			swap_cluster_free_table(ci);
+		}
+		spin_unlock(&ci->lock);
+	}
 	kvfree(cluster_info);
 }
 
@@ -2720,6 +2818,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	struct address_space *mapping;
 	struct inode *inode;
 	struct filename *pathname;
+	unsigned int maxpages;
 	int err, found = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -2826,8 +2925,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->swap_map = NULL;
 	zeromap = p->zeromap;
 	p->zeromap = NULL;
+	maxpages = p->max;
 	cluster_info = p->cluster_info;
-	free_cluster_info(cluster_info, p->max);
 	p->max = 0;
 	p->cluster_info = NULL;
 	spin_unlock(&p->lock);
@@ -2839,6 +2938,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->global_cluster = NULL;
 	vfree(swap_map);
 	kvfree(zeromap);
+	free_cluster_info(cluster_info, maxpages);
 	/* Destroy swap account information */
 	swap_cgroup_swapoff(p->type);
 
@@ -3217,11 +3317,8 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 	if (!cluster_info)
 		goto err;
 
-	for (i = 0; i < nr_clusters; i++) {
+	for (i = 0; i < nr_clusters; i++)
 		spin_lock_init(&cluster_info[i].lock);
-		if (swap_cluster_alloc_table(&cluster_info[i]))
-			goto err_free;
-	}
 
 	if (!(si->flags & SWP_SOLIDSTATE)) {
 		si->global_cluster = kmalloc(sizeof(*si->global_cluster),
@@ -3240,16 +3337,23 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 	 * See setup_swap_map(): header page, bad pages,
 	 * and the EOF part of the last cluster.
 	 */
-	inc_cluster_info_page(si, cluster_info, 0);
+	err = inc_cluster_info_page(si, cluster_info, 0);
+	if (err)
+		goto err;
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
 		unsigned int page_nr = swap_header->info.badpages[i];
 
 		if (page_nr >= maxpages)
 			continue;
-		inc_cluster_info_page(si, cluster_info, page_nr);
+		err = inc_cluster_info_page(si, cluster_info, page_nr);
+		if (err)
+			goto err;
+	}
+	for (i = maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i++) {
+		err = inc_cluster_info_page(si, cluster_info, i);
+		if (err)
+			goto err;
 	}
-	for (i = maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i++)
-		inc_cluster_info_page(si, cluster_info, i);
 
 	INIT_LIST_HEAD(&si->free_clusters);
 	INIT_LIST_HEAD(&si->full_clusters);
@@ -3963,6 +4067,15 @@ static int __init swapfile_init(void)
 
 	swapfile_maximum_size = arch_max_swapfile_size();
 
+	/*
+	 * Once a cluster is freed, it's swap table content is read
+	 * only, and all swap cache readers (swap_cache_*) verifies
+	 * the content before use. So it's safe to use RCU slab here.
+	 */
+	swap_table_cachep = kmem_cache_create("swap_table",
+			    sizeof(struct swap_table),
+			    0, SLAB_PANIC | SLAB_TYPESAFE_BY_RCU, NULL);
+
 #ifdef CONFIG_MIGRATION
 	if (swapfile_maximum_size >= (1UL << SWP_MIG_TOTAL_BITS))
 		swap_migration_ad_supported = true;
-- 
2.51.0


