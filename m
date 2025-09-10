Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56E44CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 16:10:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACEBA8E0033; Wed, 10 Sep 2025 12:09:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7ED78E0005; Wed, 10 Sep 2025 12:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 946768E0033; Wed, 10 Sep 2025 12:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C4038E0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:09:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 40288138AD2
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:09:59 +0000 (UTC)
X-FDA: 83873826918.10.5AFCCB8
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf13.hostedemail.com (Postfix) with ESMTP id 332612000C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:09:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NGxyjbVO;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757520597;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gqqOh+GurbkmfIODxteOTLsF6NzKFWqzUJ203IGMWLQ=;
	b=gxTo0Rp4GpiJA9P00bAjsoXTJr5lJlxXitChp8Fie46TXb6HWcm9FrdwOQfcka8OdpauJg
	pZThWrddp15/vBO0Lw6j6M/To2FBBvTXauhkSF5wkljr6N1O5IQvUuY2Dnt6HMdUu2IiiW
	Cse4gHWmB8hrjtebx6m2DAkHFpHQi14=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757520597; a=rsa-sha256;
	cv=none;
	b=JhnadEgCLc9xfyY6/NlPetj9SZL4UyViZiAuISpNPAN92UmK0MAKI5PTdEgdj39bdnqe0M
	wzV9il+P5p7OwXwPaFJwGUnk3PzjX8WYQL5g4eztxShbd/H5o9Yhy08DkZfr+OH6L6pr1n
	Kw20TAEQrbOYeKq7+fylBVQaEsBphvs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NGxyjbVO;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-32d6c194134so5779957a91.0
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757520596; x=1758125396; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gqqOh+GurbkmfIODxteOTLsF6NzKFWqzUJ203IGMWLQ=;
        b=NGxyjbVOrXw2txT+qvU16uBxIXJkEE5sozWVzZ60IDk6UBBLprNz5q53A2WjaFEENE
         LnRpJzq5qM73bLYTsv8dUkKzEiYuFnKkhVuxnJbue1ujtCYG5t3gO5h3SAMex8A4fqTV
         CE1QUydeSr6mYYR9lmxQSuUMO3gkxThehhlD9EYHTJKPu+i3OuKNFGnc88f+YIyhbWEv
         21Nmwk7954/LgDsir7/Tkrty6D20XaCUi6OsGfe3v0BJbrKm8kz2GuqvGtteD9DEtYf1
         jD26T9VHE+cL1vs5wZgwN9HWRSb3NvFbjFaXXlck8ceIW/Oa7z9rs+vn6dxPOLkgjVwf
         oHhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757520596; x=1758125396;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gqqOh+GurbkmfIODxteOTLsF6NzKFWqzUJ203IGMWLQ=;
        b=GPHMWrdpzT5piqhsKtbZQdKBgyT3sUdywBwWJmGeM8ilGqlSeJLGAV2chwXsZkst58
         ZCwVjU/oC6UOpZh9s0s6RrE/MFEbiTXi8w4UgUAMjpdyydTB4mc+d9EOdU4NpT0D7Iwq
         Rs2qkeH/q0ns1+gTbp7bjdt3KJk6FyQSU5hCXNwEaOofNNxYGLn3SHxw79AmiE05e/ac
         GppD+5BkzBRdAYYES6DxejU78q039ePpA3TpzDoGvZXEtkI4SbgGCqyc5FpFu/+8DJX3
         t3nr1dlj9QvzNS471M8m8rlCHepEjtXf2CZ21SduG6RnOlKyDEy87JJdRuCT6QsGeMpt
         pvUw==
X-Gm-Message-State: AOJu0YzKwDLd0ijUDNGcELY8+QYiFUkovKtOCBJUPMU6sQqvYn3abUP7
	vjUogpEJSP+WweISFAWxLqsWBqLop+f50l1l3bBJN00aJ6wdf3Eq3a7i/1Br9Y2dDhM=
X-Gm-Gg: ASbGnct9l8yYcVxMjUAoE4toWA6Eu1tu6nOTyspQVwLkA4wid0X+uIYBAvB/OEhp1tu
	qKMDD07NGR7ixy9sfUhUD9rGz55uew3cqxuqWmaYeEixEL5LcXqrXhAJ6R6qwulo4y6orTDtlLh
	Xv75dfoMmPwT3vn/hDRsL86jfJMKjoMYsp6CkpwU+k5qmSVlsDEOBG6b2w5aFwSSpiif/09Han6
	JWAmhPVWhzbEtcg6E2PDWeKNuuH/3Zn0VWmM4aq1Xdj6YE0wlaG0YFVZiRmSlV3/EY3zA9rZg2E
	1JQ+InUn9zaLnTZuqU5ODjfCVf6qg6lNBDdf9sALG9NdBIG4pDWj2/9XyDo3F8JBxT6irsybWgo
	p9EFyDv7rw9pp8YHqw1vL40O+ezJXx84pAvT2vaW/PhZdNvh5UCE/lgoryg==
X-Google-Smtp-Source: AGHT+IG2o7GH+yYlWdqcHRNV6LJZ6go0DoQV2Ggmh0ko7bTKjKCSNDKVLaOYql/uI8eSn27eyHKBeQ==
X-Received: by 2002:a17:90b:1802:b0:32b:ca6f:1231 with SMTP id 98e67ed59e1d1-32d43f05005mr19821868a91.1.1757520595521;
        Wed, 10 Sep 2025 09:09:55 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54998a1068sm1000142a12.31.2025.09.10.09.09.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 10 Sep 2025 09:09:55 -0700 (PDT)
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
Subject: [PATCH v3 14/15] mm, swap: implement dynamic allocation of swap table
Date: Thu, 11 Sep 2025 00:08:32 +0800
Message-ID: <20250910160833.3464-15-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910160833.3464-1-ryncsn@gmail.com>
References: <20250910160833.3464-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 332612000C
X-Stat-Signature: rihqajgdhodtqr9i7jidb9yct9acehi7
X-Rspam-User: 
X-HE-Tag: 1757520597-215338
X-HE-Meta: U2FsdGVkX1+gOk8wAs5fOg2Vy13JkQ24US4dmFbLg4oPoV/OpuPTsfk9cYOaQfWs4vYDNE+Php3Rlp8wsnv4ok3cuqa8JesfW4fVFWDqUQniscTBAVkyZFV3T5V6IUraLvA1W7IWZvUx5/YOs8VfStcy28rMVY6GlQE/TI0RhUjOe9wViLqppV7rVLEJKw+zykbT5j04UGthUnK6S4UMOUy084B1TRp7rDOkaWikLkxgFzB35zSMCgJq/DSCJuVJSN7mUrLvO+++FmaF/YKuxaSsTlwUxMSTP7SbHQvApVeQxLNtmyYx2PeF8EiotdS5qJedyHeINmjuf56rJcCkJppbE/BpeURir+kGMN9BOrgQ1/pWP7oh4zh//ht56s1bsRy27PK+0ZqwQsFr+nBNres0C/D2xzQpXz8bf/yY1Dgm7ioy6KlqvMaW97cICz4FRUOlX3lmesEEvUf0Ir1f1bylsvoO6cf9Kz3Yqm5O9WMYP1hAEUzZtGfylgfmu2yR7oFdx61rDRUeSjXw9mbYIMkj/u1HBd7KHKUI9jjlGLmMHKvpG7CSjmoeqiZGBwv9qupvSaysmxtMiTIqhOrbp6OiAJIO5/vLtLqaoegihuKG1oN1s/d1XsrK+v/utybfHk/smSbEhgeC4DrWg0E+qbFjSsPBl6rJVX70M7/+gksFOVpTZCqv2b3hpwqisSDEI8Yf6iL9hLUqq+lF+po1akLKuPPFsdiJDmI5fnuvYAGcqbY6nN9kdJt8jKfTLYBuPD3xFixbMBRc9FOIo4/vaj8uqbbn8xXX1S3S7YV9ONn3+0sGtFo51Lzw4pV1pDppLWwDfliZ+u7Lz00RjJnXMJ8E+K8LyA2/zJ99dfEnlJLeFwApO86IQzawWfHerqsNjAArjtFX5f9ojoFQVczdpdTncWZ5NtFyd6bBj92t6++2LA80RiRstsSarf4cln6kUPHgcpOONNwXPO0OjC3
 RhPpVQ0r
 26pUc2bKfxxevSs7l/hO+0fyEwwOxGvHbjI2tleI42hNCvU74OKPCmU8oI4vJEHY9HlL5m6iQtFOuVUwmUNUiZ6aliV0mkMp/EBczZecLe/n0NxWK0tZDPDYNzXKwutvngh7yWBm/UDVbS63xovjUJirPLVYR4x75qvPzDHC8auGHaZibrdGwjGovUFgMoG+xfQ+IZJ+xb4T3oD8mUh8LUUptSz1r96cRxGYMgf6y3UlwfFlnaclvDqhLakaA0xBYDCF7F+2vIbALTb8EN8il/4YBf5hBibXWeaNTmn3/zVdok0/SxrbM9YQxbH+uvUERPP3Bfki1kFV36CcVEge6miX/4MiKGs6mwA9SXgItEXNb77Khk+zbWY0Fq2cNyE3KWZORULMYNwVczFAltdj89ooq5CNlUkumMQInDmP26Sp1tgbollO+jn1fWc83pt/KTqPcpF6LQEw/NUgQ4c5Mi+zWrwF559z/aKih+BW+DyRRhSdd6o/hvlTaJc2j3Juckr1z7g3gho57vGkXBaOrgYoyB5l09JpadwdvQxhOjOP8srOSZDmvDAgb6K0vnl63ev8uCS9CsvSygJE=
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
Acked-by: Chris Li <chrisl@kernel.org>
---
 mm/swap.h       |   2 +-
 mm/swap_state.c |   9 +--
 mm/swap_table.h |  37 ++++++++-
 mm/swapfile.c   | 202 ++++++++++++++++++++++++++++++++++++++----------
 4 files changed, 199 insertions(+), 51 deletions(-)

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
index 97372539a575..1fc3a9eff8f2 100644
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
index 89659928465e..faf867a6c5c1 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -105,6 +105,8 @@ static DEFINE_SPINLOCK(swap_avail_lock);
 
 struct swap_info_struct *swap_info[MAX_SWAPFILES];
 
+static struct kmem_cache *swap_table_cachep;
+
 static DEFINE_MUTEX(swapon_mutex);
 
 static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
@@ -400,10 +402,17 @@ static inline bool cluster_is_discard(struct swap_cluster_info *info)
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
@@ -421,32 +430,98 @@ static inline unsigned int cluster_offset(struct swap_info_struct *si,
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
+ * Allocate a swap table may need to sleep, which leads to migration,
+ * so attempt an atomic allocation first then fallback and handle
+ * potential race.
+ */
+static struct swap_cluster_info *
+swap_cluster_alloc_table(struct swap_info_struct *si,
+			 struct swap_cluster_info *ci,
+			 int order)
 {
-	unsigned int ci_off;
-	unsigned long swp_tb;
+	struct swap_cluster_info *pcp_ci;
+	struct swap_table *table;
+	unsigned long offset;
 
-	if (!ci->table)
-		return;
+	/*
+	 * Only cluster isolation from the allocator does table allocation.
+	 * Swap allocator uses a percpu cluster and holds the local lock.
+	 */
+	lockdep_assert_held(&ci->lock);
+	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
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
+	 * the potential recursive allocation should be limited.
+	 */
+	spin_unlock(&ci->lock);
+	if (!(si->flags & SWP_SOLIDSTATE))
+		spin_unlock(&si->global_cluster_lock);
+	local_unlock(&percpu_swap_cluster.lock);
+	table = kmem_cache_zalloc(swap_table_cachep, __GFP_HIGH | GFP_KERNEL);
 
-	for (ci_off = 0; ci_off < SWAPFILE_CLUSTER; ci_off++) {
-		swp_tb = __swap_table_get(ci, ci_off);
-		if (!swp_tb_is_null(swp_tb))
-			pr_err_once("swap: unclean swap space on swapoff: 0x%lx",
-				    swp_tb);
+	local_lock(&percpu_swap_cluster.lock);
+	if (!(si->flags & SWP_SOLIDSTATE))
+		spin_lock(&si->global_cluster_lock);
+	/*
+	 * Back to atomic context. First, check if we migrated to a new
+	 * CPU with a usable percpu cluster. If so, try using that instead.
+	 * No need to check it for the spinning device, as swap is
+	 * serialized by the global lock on them.
+	 *
+	 * The is_usable check is a bit rough, but ensures order 0 success.
+	 */
+	offset = this_cpu_read(percpu_swap_cluster.offset[order]);
+	if ((si->flags & SWP_SOLIDSTATE) && offset) {
+		pcp_ci = swap_cluster_lock(si, offset);
+		if (cluster_is_usable(pcp_ci, order) &&
+		    pcp_ci->count < SWAPFILE_CLUSTER) {
+			ci = pcp_ci;
+			goto free_table;
+		}
+		swap_cluster_unlock(pcp_ci);
 	}
 
-	kfree(ci->table);
-	ci->table = NULL;
+	if (!table)
+		return NULL;
+
+	spin_lock(&ci->lock);
+	/* Nothing should have touched the dangling empty cluster. */
+	if (WARN_ON_ONCE(cluster_table_is_alloced(ci)))
+		goto free_table;
+
+	rcu_assign_pointer(ci->table, table);
+	return ci;
+
+free_table:
+	if (table)
+		kmem_cache_free(swap_table_cachep, table);
+	return ci;
 }
 
 static void move_cluster(struct swap_info_struct *si,
@@ -478,7 +553,7 @@ static void swap_cluster_schedule_discard(struct swap_info_struct *si,
 
 static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info *ci)
 {
-	lockdep_assert_held(&ci->lock);
+	swap_cluster_free_table(ci);
 	move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 	ci->order = 0;
 }
@@ -493,15 +568,11 @@ static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info
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
@@ -513,13 +584,19 @@ static struct swap_cluster_info *isolate_lock_cluster(
 
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
+		return swap_cluster_alloc_table(si, found, order);
+	}
+
+	return found;
 }
 
 /*
@@ -652,17 +729,27 @@ static void relocate_cluster(struct swap_info_struct *si,
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
@@ -844,7 +931,7 @@ static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 	unsigned int found = SWAP_ENTRY_INVALID;
 
 	do {
-		struct swap_cluster_info *ci = isolate_lock_cluster(si, list);
+		struct swap_cluster_info *ci = isolate_lock_cluster(si, list, order);
 		unsigned long offset;
 
 		if (!ci)
@@ -869,7 +956,7 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 	if (force)
 		to_scan = swap_usage_in_pages(si) / SWAPFILE_CLUSTER;
 
-	while ((ci = isolate_lock_cluster(si, &si->full_clusters))) {
+	while ((ci = isolate_lock_cluster(si, &si->full_clusters, 0))) {
 		offset = cluster_offset(si, ci);
 		end = min(si->max, offset + SWAPFILE_CLUSTER);
 		to_scan--;
@@ -1017,6 +1104,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 done:
 	if (!(si->flags & SWP_SOLIDSTATE))
 		spin_unlock(&si->global_cluster_lock);
+
 	return found;
 }
 
@@ -1884,7 +1972,13 @@ swp_entry_t get_swap_page_of_type(int type)
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
@@ -2678,12 +2772,21 @@ static void wait_for_allocation(struct swap_info_struct *si)
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
 
@@ -2719,6 +2822,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	struct address_space *mapping;
 	struct inode *inode;
 	struct filename *pathname;
+	unsigned int maxpages;
 	int err, found = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -2825,8 +2929,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->swap_map = NULL;
 	zeromap = p->zeromap;
 	p->zeromap = NULL;
+	maxpages = p->max;
 	cluster_info = p->cluster_info;
-	free_cluster_info(cluster_info, p->max);
 	p->max = 0;
 	p->cluster_info = NULL;
 	spin_unlock(&p->lock);
@@ -2838,6 +2942,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->global_cluster = NULL;
 	vfree(swap_map);
 	kvfree(zeromap);
+	free_cluster_info(cluster_info, maxpages);
 	/* Destroy swap account information */
 	swap_cgroup_swapoff(p->type);
 
@@ -3216,11 +3321,8 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
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
@@ -3239,16 +3341,23 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
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
@@ -3962,6 +4071,15 @@ static int __init swapfile_init(void)
 
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


