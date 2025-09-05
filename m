Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA499CA1017
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:15:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54A94940007; Fri,  5 Sep 2025 15:15:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FB43900002; Fri,  5 Sep 2025 15:15:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C352940007; Fri,  5 Sep 2025 15:15:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F6B2900002
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:15:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D1EA6840FB
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:15:30 +0000 (UTC)
X-FDA: 83856150420.26.48EA81F
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id E044D18000B
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:15:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YlB6gstJ;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757099729;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+lEkM5bIq6/Z03Z2MzIXOrrBa0ZEPgMosVL9NAQvMio=;
	b=jecge0UIj7PaBqQ3JtiXBH17doVznaeCL6bHu4+BNF1cTSsYzwWXQ1tVTqx6/pATdU7W/Q
	hW1fBiae7GmWiAsA4gASGJ2zwSgW0XON7yF9g/kKDDVsX/1wS0q9d5rdkeS0BfZvGcnFQ8
	f5L5dz5WhFuBF9zL6Q3aaYt8o+mREhY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YlB6gstJ;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757099729; a=rsa-sha256;
	cv=none;
	b=QyoFYnvyhhVnthJrGkNJA5T5/SWhQuUqQ1ST254LSp1DHw8JZtd9whGjyswbpJYB32w/1I
	IFYiRsUBis8nWVf4Ir3Nmrj3rWBzSywlFHX8VCxfmsVG3CzR5ZZyvSCHpr7SNS5wOA9/z9
	zobVWpSvMuS9h4Q+q3gL6d+Je9iTwLI=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7723f0924a3so3403599b3a.2
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 12:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757099727; x=1757704527; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+lEkM5bIq6/Z03Z2MzIXOrrBa0ZEPgMosVL9NAQvMio=;
        b=YlB6gstJowqAhWlEEnT9tWoC+ZlrdyzflIUXarKu5ZAhS4t/NbyWC2sX+GhgGSD8PZ
         oLv0AeNgJkuQDSF1OmjxOZcXE4lwEXgoPPhbEoM0bmCFOcLEfhH09h+VY+ws7wpLbHUB
         9LHYwjlkI8l9p56PQVUbsUm+uXtchmzYW7PIyHmgwwBuRYX3rnj0lwqo9GMF4N6XXJ4s
         xAZMm15UqAG2lBwGEicD5MbLheAp4pHpxoDkPnn54TlVf8h40Qi7ncXikk4CU4FRWKue
         rNSN5AfeVV5f6bI2QSX/aHiTlD0U6Gw+s6NzMe9hPJskneMpizdvUdFtPPwW/Vc8jG4/
         KgCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757099727; x=1757704527;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+lEkM5bIq6/Z03Z2MzIXOrrBa0ZEPgMosVL9NAQvMio=;
        b=DWbe4isPz8a73M/Pr+8SNfesJh9VWyeKsY32s1OvXV3DW0axSp3V3YjuWHlgMpc9mi
         rqlnYdxvBYs0+b37JJsBDzwSPKxzMoEJuMWmKwnMyIMvG8Bg80FTZGfG5PEAJYJ+/M0o
         j2+o5zsSS+0hYlvhMM7JU3l+pxYiK2SRhK69vEM0KhtZtvZQevIBnw3HZ74RyRnGF5UW
         AFW6AMoBdI4Y721aJINvfhfivaTOYMinFHzRpFflrR+05PINyqmFhgRN658paHctBJG2
         F61x38RCus7qoEDsTkNkhv5mp8apiuE220Qb0jP4GI51G5OL/MMnlFL8zYDzeAgEe6w+
         Gx/w==
X-Gm-Message-State: AOJu0Ywo4KSyrhmwCdeQi4C1pi0/NY5DCp4uqtSYzZtuHni5ipKOrP19
	hL410reXLiadefVR48Ia9JDEE9IAc/YXTd5xsDtTgpBhob1mTr20U0yLR7n8dQL55+M=
X-Gm-Gg: ASbGnctROfR1Hkyl54l5YdkCrSO0owSFA/FIZToaP3IQHw8lnG3Y76UH9MbT8sVtQUB
	sxxY9hWqiAdeo92h7yE2SFhABSjEFol6AbfU+pdH3uz62ATNWqarUhuxqBEgY9/Ww7SRwpcWGTg
	BDxkTwn3OmXjNhsevzrOSn3WY9LXdLwrr93Qmb172p54EI6hjwWxjxdkhk1i0B6PdIH1m7fbo2/
	nngm/xUQvZwfGaqKyOefKeyvmqXPCHAQAojqMHLxILnaoXgDp7KpVkljLIHz9atdi/YXLTqujNH
	/F25nLMCA1Kjo7tUVLPhCWNwwuH/sLRoKI4AFIIYbAlJlG4jRIDe9IyKmE2evpkRUdqZCdvy29k
	AplB1cokOZhkj0shGISZjHCVBzHwanrAGz+Bf94grmYt8A/00b22tlQPPOQ==
X-Google-Smtp-Source: AGHT+IFX1AsNYufNSGbWrppi99g9MPF4m602yXU0boYUFaYnzpDBnO4BP28Q0xPFgPU4tjs3kQ4Hwg==
X-Received: by 2002:a05:6a00:3c89:b0:772:5a3f:7cb3 with SMTP id d2e1a72fcca58-7725a3f8497mr23849253b3a.1.1757099726844;
        Fri, 05 Sep 2025 12:15:26 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77256a0f916sm15871442b3a.63.2025.09.05.12.15.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 05 Sep 2025 12:15:26 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [PATCH v2 14/15] mm, swap: implement dynamic allocation of swap table
Date: Sat,  6 Sep 2025 03:13:56 +0800
Message-ID: <20250905191357.78298-15-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250905191357.78298-1-ryncsn@gmail.com>
References: <20250905191357.78298-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E044D18000B
X-Rspam-User: 
X-Stat-Signature: 1o3jjp3usnwmxm6a74drgqtodwosjfus
X-Rspamd-Server: rspam09
X-HE-Tag: 1757099728-523113
X-HE-Meta: U2FsdGVkX18g3xt0keyLOQ6Hs9H76O7fPMpjFQxvKmwGoxwgxUNpmbUlS6mlLtqNiHXvgG16YsYBpcFOjkMahchCxAHjqKJJhjSQT659zDst3i9VxlTPJgxLXzHZ/K1qpI0xcKGcntSoSXooIV7MmryN2rnUyBFo0hqB4m0zoxU4B9IvH8l/TKWNKcmJZSpuNcBMEv9VBY0GFx2KCMB0nPVpNm9fb2sQ5l4Fb9QfElal5huLQ2yoB6+PTtDVylxFpMis67tk7A6wtSfl7MCtmFm8Exu0tHLoB4yLTWJosFIhXoyP0gPY4CtArKkkXFv44KTFU2NloV1PhG8v+ggMtb86uTzrfz0EO2LfRddbyB9fOeGhrkDEKfwl35CyAnVze8Id357BpqC466brv3l+/xz/sqeXcMkl0MkZbeZyplKhL5jTtKcVi7hJmsgW6DXjRE3GyPWhTdRXOYXvkAUrCLUl0rZCpY3QiJ1TjlpFEKzDtJUfTeKBLVMfXJL6a4OsHNLZuH2SDdHsvxv6/qLea7o1EiTzJyHcmN5UONICY98MTPOHsGJqGnL/1lBcZvOzogie1cVqNvQdpyMY6LX54mw/5eMc2M3iZhioz0k/lJRlg0D3Bc7Y6NcczR90Xm++MJWqftj0jD5JRvX80wn/PjXGfpsG2VJtWBvXzz9Bw6Wf3Tb1vG9nCCt3L3G/YQs8SN7ct1B5MrfY7wsYYNAYnuI1r1EFVupNouMJ7AJB+SkcNj5xuz4CeENoiA71vfTfVvEt9WVi16DWw0W3wkx/kxeozLGzKHkKfoAlE8vDKAlBJJkSYEp5RlYnQOFudSX3T1PlJBZU242cnWkh2nvTmGDBR8sTZqvYOEWr5WW4JoHdw3SOpb36JiNXNm442c6TWbQlr1ZEfMT8TlgnDCKdOle1CaWDtsuKNBmKj53TcaYZIaHeUwa+HRlvDqJVGStYcTlRCNvT4vk04yMsAR7
 pb6LOCVk
 6nj7MHaGq7OjZ0Pk1/DvtbMXd+AR/Af4msk5CV0dLaDjowBlOb3pUotx9qPpurvzho51SQ/HquzVejmR9vgN5QKdBADL78wR77GHQHQxVay/hAtpsVNvGriG11+P8snNNzvXLzvyLfPpuI7qf0yu6gDWO/rqV07xN6CoPt2ufdygF1Z+DbuC+2XwkUaZHPldVQXI88xH60yKdwkV3Btl9vyh4FH7VTmQFXvHzZYfyRJmRGjqyoM1yxS8fepOK8UzkIitMrIQOpHilF/2v48NnOT/kUBP3siRmI8GNq1n3yG4QQ4ByigixHrP3TfTSwlnCsjC7jHAJBZeHpZGdpVmPaMZ5+gtLMPtboIXZ+xrjnu95ZUHBdUajlLf9o5BCuO4ub1E2FqJNBZ1K25QH4Mb+DLjL+e/gwnewTyeB0RU/ucnCYJzxqbZXdbQeTSnUZq7LvDDJP2vYUTTGulIFGsWUJma9VE+P1C+OQQFnGVpnfY5FkayBVaFF0cStr6jO96Pl110kvwui3oPXt1gcXuVsG9y+ZmXmeS5eOwRJxynDdZifNCfu0lwPBz4wNYOPSHN+3KVCVGTQSgMeCIsZxRv+FsAXy63tGMndVWZEpJfl32zK6qzg/bgzJkdCKjCl65wnP7Usnb5RLBAT1ZoismEaUj2SQLjQo6aHCmOR
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
index c4fb28845d77..caff4fe30fc5 100644
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
index 209d5e9e8d90..dfe8f42fc309 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -92,8 +92,8 @@ struct folio *swap_cache_get_folio(swp_entry_t entry)
 	struct folio *folio;
 
 	for (;;) {
-		swp_tb = __swap_table_get(__swap_entry_to_cluster(entry),
-					  swp_cluster_offset(entry));
+		swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
+					swp_cluster_offset(entry));
 		if (!swp_tb_is_folio(swp_tb))
 			return NULL;
 		folio = swp_tb_to_folio(swp_tb);
@@ -116,11 +116,10 @@ void *swap_cache_get_shadow(swp_entry_t entry)
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
index 6b3b35a7ddd9..49f93069faef 100644
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
 
-static int swap_table_alloc_table(struct swap_cluster_info *ci)
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
@@ -2677,12 +2771,21 @@ static void wait_for_allocation(struct swap_info_struct *si)
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
 
@@ -2718,6 +2821,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	struct address_space *mapping;
 	struct inode *inode;
 	struct filename *pathname;
+	unsigned int maxpages;
 	int err, found = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -2824,8 +2928,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->swap_map = NULL;
 	zeromap = p->zeromap;
 	p->zeromap = NULL;
+	maxpages = p->max;
 	cluster_info = p->cluster_info;
-	free_cluster_info(cluster_info, p->max);
 	p->max = 0;
 	p->cluster_info = NULL;
 	spin_unlock(&p->lock);
@@ -2837,6 +2941,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->global_cluster = NULL;
 	vfree(swap_map);
 	kvfree(zeromap);
+	free_cluster_info(cluster_info, maxpages);
 	/* Destroy swap account information */
 	swap_cgroup_swapoff(p->type);
 
@@ -3215,11 +3320,8 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 	if (!cluster_info)
 		goto err;
 
-	for (i = 0; i < nr_clusters; i++) {
+	for (i = 0; i < nr_clusters; i++)
 		spin_lock_init(&cluster_info[i].lock);
-		if (swap_table_alloc_table(&cluster_info[i]))
-			goto err_free;
-	}
 
 	if (!(si->flags & SWP_SOLIDSTATE)) {
 		si->global_cluster = kmalloc(sizeof(*si->global_cluster),
@@ -3238,16 +3340,23 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
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
@@ -3961,6 +4070,15 @@ static int __init swapfile_init(void)
 
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


