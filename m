Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D313CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 19:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 887758E0003; Fri, 22 Aug 2025 15:21:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E5768E000F; Fri, 22 Aug 2025 15:21:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60D2B8E0003; Fri, 22 Aug 2025 15:21:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F5A88E000D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:21:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 08CE7160316
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:21:37 +0000 (UTC)
X-FDA: 83805362634.07.3FDD101
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1D6891C0006
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:21:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Yy2tFI7Q;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755890495;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2L+hJE+IB0iUcVlUYZZhbpmVEvEPmj5Vj/KEQQntKcM=;
	b=FIUfUeeTRsZf9LdBtkSEbSSzQk2EmZunooPUJA2BTTQDGCzkfmA7vCOJTsgW+N3XXoM89g
	G06hT/Tdb1NyIGj+t7Rm1+tQpv7BXEpeQWmeTh/s9hdi+gu7f3Az3X+Rp1GpwcQQI33Kxn
	9FYZVWuZ7K7ZIresLePoVU9usnuWGSU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755890495; a=rsa-sha256;
	cv=none;
	b=hhJHjruf8n58AphZ8isrLsU1hGVXj4qPcjWSleb/TLjJct38K6RAJn0Pk4vttdnVMR4oos
	eRUXWWu5fqcArtwNl6CW4vCKRNGhHC+MSShlmALMimQEfgJOts7o/s9obDOlTzSvj3q2sz
	oHi70fwCVe0ZnWvM2PZAO0JuoGzfrek=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Yy2tFI7Q;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-70d9f5bdf63so5975026d6.0
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755890494; x=1756495294; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2L+hJE+IB0iUcVlUYZZhbpmVEvEPmj5Vj/KEQQntKcM=;
        b=Yy2tFI7QGSnyIEiiGj5CdU25d0Mg4U9TUC795qJK5vUXdnm5TxoOYwfufDhr2QL6Qa
         4e5FQoPruh0Pm9NftSFhZYby6lkptxgPzv0kdN8XH8sWiZM1RWapcL0hGG6lxkGxDq24
         eQ9d70IEmBGCXjFLDvyscM10MNTNQiCMXVSQ7gk/944vatSPkEG5+q0Bf9RTl08ybTw8
         mPOjyy5wM0G/Vm1pPV0jQ4MPqQQHgVNByNSfVr3OBCv75JHF7SuaHMwHnj5OyoPWxffm
         /GjqlsO1GlbpnucQBwZIhRZhI0Z9xD7zbWgRx0kNYku5O2G4ZTS+4pIYlUxKc7r9Xm4g
         08/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755890494; x=1756495294;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2L+hJE+IB0iUcVlUYZZhbpmVEvEPmj5Vj/KEQQntKcM=;
        b=IL/Ui/vyeT3R3VS3cTO9RZZI2Qmy06HprWpIZh1umyV8cALZEiUzXdabWSLnQ9Q/e3
         Lx1P5eKphTu68PEhUcfUoFMekoln1FHlJRUUi6qwDz0YHFWmNxC08rJRVITIAmgzT1QX
         vYKCd96m5UKodhuIxq7HiN2+CZb0jZWKkeOxN3ftpuAhvZr6Rz56EFDAYIN/PDVOSx1g
         BQ3OvuDiMI+EoP9uiVt7zzqYqMBYZoBrY8Trzt39tJ1VuErZKZ23ZMu61GFFXAC5Aqyx
         sE1yTgiWC6wWm/NQqN9GeoL6YMrPtJ7OYM4kccGH015kZIJuGFRbvrIk8SeR+IoPQpCu
         tOQg==
X-Gm-Message-State: AOJu0YxvXwpOwmjU/4zrEqYJ+TXAOa5wiZ/qxP7EtHYJDHOAi7nvcY08
	FERy7xzbkizfv1mA8xS8W6yAmkGPxAxbh8VsIFNqgBucnlludfAtv7IjL9BlDfCurn4=
X-Gm-Gg: ASbGncsz9YgagLPqb5PioUhmMCgY3u2/pz5rrgWGtW06kuDWUfJQHDt29Xj1SdCYcy5
	mtAXvAucCvoiTvMq9Jl3Es7qXIgJrpBf9lP48/1r2pjCGQGQggRaDWh2ozoZX0T1yxApS9UPUy4
	Nt1yt1RiYoSfdkmi/5DsItmyBU5DqGWCIOo/oTpoh+r5STiD5mpKXm3szkRpqpmBRW5W55Z96GH
	VVE1sCciz6nPYcU1qnzbhHo0rrTyzW7FjVg7DVfG7t3J4C2FwwJwuliz5xHs4pQKeyw1MIFyVSd
	Y8EZuNJ4s6ekYUeHhHkdz+YAU1EkJt8XSQstaUAOynzYQClKkHChXqyuKrGn0QUoa3RJFM7nEBy
	Vnrq1QWje7waQYSwccA/2cvlYhZvZ/afb+rObeGCkfYs=
X-Google-Smtp-Source: AGHT+IGGbnFrGqyosDOoF0G2Qyk9vRWcSTgBb+CggxPJw9xuwtxeZh8Y9UnfLYcZ+rG800PIBXDPzQ==
X-Received: by 2002:a05:6214:21cd:b0:709:f305:705d with SMTP id 6a1803df08f44-70d9722c613mr53385776d6.19.1755890493703;
        Fri, 22 Aug 2025 12:21:33 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70da72b04a6sm3843656d6.52.2025.08.22.12.21.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 22 Aug 2025 12:21:33 -0700 (PDT)
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
Subject: [PATCH 8/9] mm, swap: implement dynamic allocation of swap table
Date: Sat, 23 Aug 2025 03:20:22 +0800
Message-ID: <20250822192023.13477-9-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250822192023.13477-1-ryncsn@gmail.com>
References: <20250822192023.13477-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1D6891C0006
X-Stat-Signature: n7y7at74xny9ne6gtpabcyypdmr4rkzi
X-HE-Tag: 1755890494-461862
X-HE-Meta: U2FsdGVkX19d+5GZr5sncP6EgSYwS5O3f1hQ88Z7MRt/SSxL/BPW3xYr24+KOEo5s7n9mkmkAb/9vmIXq5MEgui7EE2vMYHamMeSLUbRONykfZ1y00g4MTYRYN1Xy2yySjOAbQLhqmpJsXJH9BVZdQmlLK30hS0igRbiAZm5BUIXa6yKz9rPsA3+jY13K8yXLpgx3DDJwPwZDMRp6g1kN+i12Xt419gD5G4DRxcvDPV4ukBQv/gV9mH1XVOWWuR3kAt0jjVWcXQiYN7qbYEknLYnxHqCMSmeYZUOJbGVWvW/x+1K8SfGmCbbCTthrcM3ddVCPuYARAN2n5tNirygOeUrOpQXPRUScncllTjPqC3rDUBNC639rYZo/BaS499sm+HoZrhJJlRw3kWFx5J3AoHWQjts3uVXBBM56URuYJBDpvwtSkxtTqK7twGEBGP798Kwlrqf9RFr95Y8d02GlU/07KK7udzH/gSHBF9yoGu8Wp+j6HF118//G6POLz/W5Q/XkkjpAEa24hdh4ae6hzQ9HRTPzP3359VnXh9Lzw0f+FOMoVHBRAaKdPg+TaISQmoVMJh3azWkGUAQcuSLGlN98r5FL3grIAiNCDhM83lKRPrK2cnTa7uCQP9KEHkWUbCAsYl9j5l1XPB0Qgtj4zUCEjQOWdYX+v/2Tn0QNMFVC+uA4VwHN3Ppk3bKDswHkwx9WlxWCmgm7IYqQYGNx7h0b8VCRPkpzMnUm/8z8ZO0olQ4MT84r4CMJolwuEVXUpbdXjuM2JRvrxKJ0GlgbSx+mWtVZSaRg4XR/X/Oy+/B3yhzR/wolJHzshQzSormWpZvqBIoema0goVDjZpR2B9Pqb8bhZP6wmXswG3o9A6A5gjCBSA8KY/BagC10X920ckKlRnUehKEImkz0ifN5f535PdB+Ywkc/oNGvtqXcHu8XP6rb670bEhN2qq+/na0zAq1LCycMbGIz7TC2/
 xCi5HeKN
 8Vkt/UZqEF6tD+tvwVDp/MKeFbom2VY80ED9nmQcS2+1yYj64b7X4j+qOTHRfVGDR8ARnf/FnfN2JyTdJIwLpW9+p/JplmUKR3wByCo/bIuvKKAYzxaw56OHuIvtduyTC9+IWGRo7O2hbGRl86DchDZZv9WDa6tPLHP1yxF47Om/JaryvKrjYsjs6SRT0UQSh10rPVoogJlDY1NRXyKE6rI5gNu7XxMUWw8eVJI4ac5wB6CO1vMFnGgko9KVcMVnhjtQ+YNdOBLRKaCzMJjuUjKHc7OhhDoKz+4NRb8jRvJ9LYW44m+LRRKxsP3pQOhhDNXNyntKpmzW9+6sCy7e8+eZm2CV2kAUDWOB38N0D+LSJJ2icaY4H6VcIofZYsv3J2vGkKdsJvYlFD3ibOzAD06TwuppXWSbZm9F2NuIABQjnEYU+TVqadNLfHlqjEhnMDUs3L54IEPeYEQtf4q9vKcLULFJ2t07OpcgKVDvqjL5nA3pEmfxyzX77t1WlwQbUdad9cFUOc4HmcrwaWEPgX8lfAMd5CNZP0JH5hgIfwRTAbWW/UNQuacVVHXeNZlCQ/U98tcKiyuS41AAFDFti1jCE9nAXS8clzTALt3TG39G7RgwGanNjoYxzOT1ErFbjSDjSyBtTQR7drnBAcUH/ViFQZdgAvGOY6Hig
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
them by making them RCU safe. All swap table should be filled with null
entries before free, so such readers will either see a NULL pointer or
a null filled table being lazy freed.

On allocation, allocate the table when a cluster is used by any order.

This way, we can reduce the memory usage of large swap device
significantly.

This idea to dynamically release unused swap cluster data was initially
suggested by Chris Li while proposing the cluster swap allocator and
I found it suits the swap table idea very well.

Co-developed-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap.h       |   2 +-
 mm/swap_state.c |   9 ++-
 mm/swap_table.h |  32 +++++++-
 mm/swapfile.c   | 202 ++++++++++++++++++++++++++++++++++++++----------
 4 files changed, 197 insertions(+), 48 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index ce3ec62cc05e..ee33733027f4 100644
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
index c0342024b4a8..a0120d822fbe 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -87,7 +87,8 @@ struct folio *swap_cache_get_folio(swp_entry_t entry)
 	struct folio *folio;
 
 	for (;;) {
-		swp_tb = __swap_table_get(swp_cluster(entry), swp_cluster_offset(entry));
+		swp_tb = swap_table_get(swp_cluster(entry),
+					swp_cluster_offset(entry));
 		if (!swp_tb_is_folio(swp_tb))
 			return NULL;
 		folio = swp_tb_to_folio(swp_tb);
@@ -107,10 +108,9 @@ void *swap_cache_get_shadow(swp_entry_t entry)
 {
 	unsigned long swp_tb;
 
-	swp_tb = __swap_table_get(swp_cluster(entry), swp_cluster_offset(entry));
+	swp_tb = swap_table_get(swp_cluster(entry), swp_cluster_offset(entry));
 	if (swp_tb_is_shadow(swp_tb))
 		return swp_tb_to_shadow(swp_tb);
-
 	return NULL;
 }
 
@@ -135,6 +135,9 @@ int swap_cache_add_folio(swp_entry_t entry, struct folio *folio, void **shadowp)
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
 
 	ci = swap_cluster_lock(swp_info(entry), swp_offset(entry));
+	if (unlikely(!ci->table))
+		goto fail;
+
 	ci_start = swp_cluster_offset(entry);
 	ci_end = ci_start + nr_pages;
 	ci_off = ci_start;
diff --git a/mm/swap_table.h b/mm/swap_table.h
index ed9676547071..4e97513b11ef 100644
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
@@ -76,15 +83,36 @@ static inline void *swp_tb_to_shadow(unsigned long swp_tb)
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
 
 static inline void __swap_table_set_folio(struct swap_cluster_info *ci,
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0c8001c99f30..00651e947eb2 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -105,6 +105,8 @@ static DEFINE_SPINLOCK(swap_avail_lock);
 
 struct swap_info_struct *swap_info[MAX_SWAPFILES];
 
+static struct kmem_cache *swap_table_cachep;
+
 static DEFINE_MUTEX(swapon_mutex);
 
 static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
@@ -402,10 +404,17 @@ static inline bool cluster_is_discard(struct swap_cluster_info *info)
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
@@ -423,32 +432,98 @@ static inline unsigned int cluster_offset(struct swap_info_struct *si,
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
@@ -480,7 +555,7 @@ static void swap_cluster_schedule_discard(struct swap_info_struct *si,
 
 static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info *ci)
 {
-	lockdep_assert_held(&ci->lock);
+	swap_cluster_free_table(ci);
 	move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 	ci->order = 0;
 }
@@ -495,15 +570,11 @@ static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info
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
@@ -515,13 +586,19 @@ static struct swap_cluster_info *isolate_lock_cluster(
 
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
@@ -654,17 +731,27 @@ static void relocate_cluster(struct swap_info_struct *si,
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
@@ -845,7 +932,7 @@ static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 	unsigned int found = SWAP_ENTRY_INVALID;
 
 	do {
-		struct swap_cluster_info *ci = isolate_lock_cluster(si, list);
+		struct swap_cluster_info *ci = isolate_lock_cluster(si, list, order);
 		unsigned long offset;
 
 		if (!ci)
@@ -870,7 +957,7 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 	if (force)
 		to_scan = swap_usage_in_pages(si) / SWAPFILE_CLUSTER;
 
-	while ((ci = isolate_lock_cluster(si, &si->full_clusters))) {
+	while ((ci = isolate_lock_cluster(si, &si->full_clusters, 0))) {
 		offset = cluster_offset(si, ci);
 		end = min(si->max, offset + SWAPFILE_CLUSTER);
 		to_scan--;
@@ -1018,6 +1105,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 done:
 	if (!(si->flags & SWP_SOLIDSTATE))
 		spin_unlock(&si->global_cluster_lock);
+
 	return found;
 }
 
@@ -1885,7 +1973,13 @@ swp_entry_t get_swap_page_of_type(int type)
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
-		if (swap_table_alloc_table(&cluster_info[i]))
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


