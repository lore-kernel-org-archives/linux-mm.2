Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F075CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 16:10:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D27B8E0034; Wed, 10 Sep 2025 12:10:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 883688E0005; Wed, 10 Sep 2025 12:10:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 772298E0034; Wed, 10 Sep 2025 12:10:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63C8D8E0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:10:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 337B2160108
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:10:04 +0000 (UTC)
X-FDA: 83873827128.04.C638C82
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 48AD61A0011
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:10:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="fYbhz/2D";
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757520602;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9X8IezR3SoWMo8wYuh3xUkeHhs7bAkncRRB5ILkQmNw=;
	b=TgkiDbftV07tugLMKA1fkdhJXqnHLc7WBI0hjN9HJ/+QD/WSPFqEJeXEBnePnvjJxz0qgH
	CTZe72zb7RIh7hpCEEHOkqXUNFg/wgXlEFvANlZ9vOkh3lVi914fJBY7qs0vVI1LcccL3Z
	8+UBbHUczk1UVRefU2CyScoE3I4rn9M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757520602; a=rsa-sha256;
	cv=none;
	b=RFJ++IzG0u3VMHEDCMJWpdKDhPWjCQuOkGtN29jKyLE5q9IxN6XeOsdP4Hx6SdsETH15+R
	6slzViq4QBLpmKy/MCRl55VpgIyTjeWflTDGRc5MWI36SbQNueVboAKszrob+lYIa7beMd
	cW00T8yaCwKYWmQGRcVzn3rghz1PwnA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="fYbhz/2D";
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b523fb676efso2602160a12.3
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757520601; x=1758125401; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9X8IezR3SoWMo8wYuh3xUkeHhs7bAkncRRB5ILkQmNw=;
        b=fYbhz/2DNs3k0nzhxN2RcXNnZYZtjMPPBxJ+4RO5p82RkpmCIijl9bKGAXMUtIer8D
         VFs0g4NLXUgvvu5RKF7wE9gfntSEqFWQbZOu3M7ol7q3yESG/v4+55McCaDf9zkY5zBl
         GUZ/SBUTZ5w5o4QOruAg6a7aHx7H6qAagJsYtTLjguAlmgupV40m4SsC0CWV9sK+fdiD
         Kca86e+tsCfiHfcu6Y+ZvIs1pROQ7VSnv6VNimCjqK5cnkYMC8bW4/2ymT1JplBnyN8f
         Y0sD4e4dK3Woz/35DbJzxfcVgt5nQWB6u686CieqP/wM5STF5c0s+aToWe/OnPe46F4H
         +KOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757520601; x=1758125401;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9X8IezR3SoWMo8wYuh3xUkeHhs7bAkncRRB5ILkQmNw=;
        b=ZGwe3xPgJ4jwcWVPVF8Dw1CIXkmEYcukIIDz1VHtjTNktJSYEcjRw3lvFI+sJNSo+T
         vJFM/b4iW71D007Y5TURpV7GYuc3hzDlmBp+pJ2bTtvADtJ8UYMsACVDD42iM72k25Sq
         JrDbOkd6YivYgNeuIjLxgsmckMkVhPrxZwLpA7x9gwI/X2bIHZ2nwmcD+zmMHSwRc6CA
         nsT1NRQEMwDQhnGp1RHZ9oyX1kSgyIHz3b8dMqmAax+nn/qQg+V+IyiUbPItRHIBIF1X
         6I2Kha3UJhB2/9qloE6dErwDLLnS86rFJJtjtNoYUQO3SyQNoz87iRNLjfEceMOxSw5t
         unlg==
X-Gm-Message-State: AOJu0YyfQMJKSULzrvxUHctE5su85bBKwiVSWdUXybMu0e5oeoxSI2Uy
	t6VA3q+eM7lg0CU2CDdIC50kHU59DReJDFU7LiB8zB2fZ/KyQWK8fxQFYmLnIBHv4vk=
X-Gm-Gg: ASbGncvd2nLI9e6stji8SmaT9tlrFHg2NSwi42IP2qaRb3MuGe9CD4GAcvF4mFlxNhU
	GQ5wAfyu8QJttG/qLfEF2BPc+npW/6Q2Fz628EhJvyWwV6EkGqXUtw2t7tqT35Eh85Vp/mdn0g7
	xc8XR2+eDNWP2WpOsE9R2rQORLRnEbIVqRBgNmTlOtgibN7Ko5YNeYHpm77I/dfH9N3kttZ6FNw
	hxfyZb53kYmg9LfDOR5XSWVKGf4Kktnn6erkPeiPkLj3ItWDrfvR0hpocohBbopVM92Ce/lnTLJ
	8nlskjh12kkxbaVxIq2Qv5BcrsPa9tthznWjLwIsD1ZSO1TTHfB/YI46aUkqeHhifDxPu0k0NVS
	Y9O2NVJdZXnO21vNOl7DO60092uR7iUlst239pPd77Ew62T+RXzS590/M1A==
X-Google-Smtp-Source: AGHT+IGH73IxV7jUuJYAM9aSrRqAGj9iR4ECuxZxMfuieRYNWITXMqhhRKZss7t1YGKHwvp/sLs/2Q==
X-Received: by 2002:a17:90b:3d4e:b0:32d:cab5:a51b with SMTP id 98e67ed59e1d1-32dcab5a716mr1672236a91.29.1757520600531;
        Wed, 10 Sep 2025 09:10:00 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54998a1068sm1000142a12.31.2025.09.10.09.09.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 10 Sep 2025 09:09:59 -0700 (PDT)
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
Subject: [PATCH v3 15/15] mm, swap: use a single page for swap table when the size fits
Date: Thu, 11 Sep 2025 00:08:33 +0800
Message-ID: <20250910160833.3464-16-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910160833.3464-1-ryncsn@gmail.com>
References: <20250910160833.3464-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: srghmx9jhucf6gz7bdrto8k7xz83no1a
X-Rspam-User: 
X-Rspamd-Queue-Id: 48AD61A0011
X-Rspamd-Server: rspam10
X-HE-Tag: 1757520602-968913
X-HE-Meta: U2FsdGVkX19w65CZwtlHOHBGYdxXaWkW0WRoAc8vCa3NPcD6YtvEmGijgOsCcwFnVHdNElvyt301mjpfSsePFENNENv4vjO2mDW4WaGpk2H/dFK6EHgtYjob2xz5pCLJ+NZBNYyCi0UnSE+Ihdh5rdIWcw4oeVoQVrP/nw4OLGipM/aIP5led+fy54XqZoMbqwESihjfcq5Eem2CMAj4zRBP8rTYa/qSk88oQcwH0KuNKu1Ft4Ujv9Du3D1pvjynWfaPuT1u1hSNdGIEjdGjCrcm5uW1gSG8DCKTLQKN67BCI/zo0a3J30idgYYVqjhBB+9AG8nuATJesCyL/HiFIZADqHlFyaP11qW+qMi5sX0bKGh14YJe2b0lp0jqf+dK5ZE8uu19nDTVDBg1VQL/rsC8BQe+ki7GSEzEXA2YHPrNjUXev9QRVwNL4cSbVB9AFA4Lnbtk3NjCiNscIICXM4xVO0lnXuQ5O11IoiDnCPin8xbWcd1+nGeGvaivzR05hjv7ps7zL6bwgIGri8q3U1j2PoZ0KTNyUd+062f/3071mFpvK7fdgs4D5sWNQS4D5n7RZAXa/4iBeeCY0cdygvJJ4ZDzroV0dXIJ9xfVmh+EUAnSz+qZ9Z0F0wpP8KwYZt5CIXwmimE4GsOPwuA5p5I8rEH1Q9b6xJmUw/EZfQCYIIGOqDpMj/6qRmsqIsRA2pRL7yqmY21zChA4aWlIVL8W9EyYSkZzaxHetWL7hNHted51q7z4HYOJcLM0rL703ioMCmfry3hLowgb4rD5xMlyRZA61dKPoPUXRAC26v9yj1C6zzZupzm2432/jDdknU1E5nDRhWExQanGyvEkNTx0W/Aa+QuO9gpTLkyNwgX4JgRXC347b6rY0LDc4bSiPhYolgamN9iAQ2JGl9NT3k0eBFn7rZYmynKphgD/8qFb0pBqWVG5YJyYfj+SZRp5kqkZyv3Is8N4RgXd7ut
 UEzLKez2
 TGOsbFLqdbINB/vGCVLWEticLDr4BewtyPmCL74A6fxCZwmW5inAsBnh6Mz3YWglesOtoNZD1sg2hO722Z9qsvAuVsIfmP854rK8tk03wPcSSvo1x3qJ1UZTSF2oqIP5IM8Yzqz5u1BQmy+nLZTcsp1BfimvP0ku+NABDOWlWdWMNZZw2JdW6jfxAqLHLDg7qBkddUevOkXMuu0+NzDSMteAXPgxWk/Gv5eG08MY6KyWTxTW8z+sgbf6IQG4qSxkHm3aMnWmF8oenfZob8FjQ88HX9KwYHCU/Yrxz/egWGPasPtyx9ySiavDQyMcfh+jL8pVk3R8guWYg2TDY+Dl4QFfAlg3vQVRJt+JJNsVFg1pSu9OR7GDGz6T+XbeBFngH43btNAqbfVkWLUV/b9eU6uwcmhJLfjB4QeMSJwJg7eEx8BuAXpVragJGZu8ja74miDvxZ4mPuMZTvL9wUCw2B2DnJ4gvk+7b9TOLNX6JJ8BW2LrVo/rVNStF23DozBS5VGIDGpkk7QWGfmYfg7yG4sFP2YPbWNVA/J/3S9ZRKyc/oJjbwGQ+jO4ay6xOBbD3YH/yNS3urShywKuCcXqQ1qO1YUhL9cgXaV/K6/95gvt5SiI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

We have a cluster size of 512 slots. Each slot consumes 8 bytes in swap
table so the swap table size of each cluster is exactly one page (4K).

If that condition is true, allocate one page direct and disable the slab
cache to reduce the memory usage of swap table and avoid fragmentation.

Co-developed-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
---
 mm/swap_table.h |  2 ++
 mm/swapfile.c   | 50 ++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/mm/swap_table.h b/mm/swap_table.h
index 52254e455304..ea244a57a5b7 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -11,6 +11,8 @@ struct swap_table {
 	atomic_long_t entries[SWAPFILE_CLUSTER];
 };
 
+#define SWP_TABLE_USE_PAGE (sizeof(struct swap_table) == PAGE_SIZE)
+
 /*
  * A swap table entry represents the status of a swap slot on a swap
  * (physical or virtual) device. The swap table in each cluster is a
diff --git a/mm/swapfile.c b/mm/swapfile.c
index faf867a6c5c1..cebf2dcfaab0 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -430,6 +430,38 @@ static inline unsigned int cluster_offset(struct swap_info_struct *si,
 	return cluster_index(si, ci) * SWAPFILE_CLUSTER;
 }
 
+static struct swap_table *swap_table_alloc(gfp_t gfp)
+{
+	struct folio *folio;
+
+	if (!SWP_TABLE_USE_PAGE)
+		return kmem_cache_zalloc(swap_table_cachep, gfp);
+
+	folio = folio_alloc(gfp | __GFP_ZERO, 0);
+	if (folio)
+		return folio_address(folio);
+	return NULL;
+}
+
+static void swap_table_free_folio_rcu_cb(struct rcu_head *head)
+{
+	struct folio *folio;
+
+	folio = page_folio(container_of(head, struct page, rcu_head));
+	folio_put(folio);
+}
+
+static void swap_table_free(struct swap_table *table)
+{
+	if (!SWP_TABLE_USE_PAGE) {
+		kmem_cache_free(swap_table_cachep, table);
+		return;
+	}
+
+	call_rcu(&(folio_page(virt_to_folio(table), 0)->rcu_head),
+		 swap_table_free_folio_rcu_cb);
+}
+
 static void swap_cluster_free_table(struct swap_cluster_info *ci)
 {
 	unsigned int ci_off;
@@ -443,7 +475,7 @@ static void swap_cluster_free_table(struct swap_cluster_info *ci)
 	table = (void *)rcu_dereference_protected(ci->table, true);
 	rcu_assign_pointer(ci->table, NULL);
 
-	kmem_cache_free(swap_table_cachep, table);
+	swap_table_free(table);
 }
 
 /*
@@ -467,8 +499,7 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 	lockdep_assert_held(&ci->lock);
 	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
 
-	table = kmem_cache_zalloc(swap_table_cachep,
-				  __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
+	table = swap_table_alloc(__GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
 	if (table) {
 		rcu_assign_pointer(ci->table, table);
 		return ci;
@@ -483,7 +514,7 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 	if (!(si->flags & SWP_SOLIDSTATE))
 		spin_unlock(&si->global_cluster_lock);
 	local_unlock(&percpu_swap_cluster.lock);
-	table = kmem_cache_zalloc(swap_table_cachep, __GFP_HIGH | GFP_KERNEL);
+	table = swap_table_alloc(__GFP_HIGH | GFP_KERNEL);
 
 	local_lock(&percpu_swap_cluster.lock);
 	if (!(si->flags & SWP_SOLIDSTATE))
@@ -520,7 +551,7 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 
 free_table:
 	if (table)
-		kmem_cache_free(swap_table_cachep, table);
+		swap_table_free(table);
 	return ci;
 }
 
@@ -738,7 +769,7 @@ static int inc_cluster_info_page(struct swap_info_struct *si,
 
 	ci = cluster_info + idx;
 	if (!ci->table) {
-		table = kmem_cache_zalloc(swap_table_cachep, GFP_KERNEL);
+		table = swap_table_alloc(GFP_KERNEL);
 		if (!table)
 			return -ENOMEM;
 		rcu_assign_pointer(ci->table, table);
@@ -4076,9 +4107,10 @@ static int __init swapfile_init(void)
 	 * only, and all swap cache readers (swap_cache_*) verifies
 	 * the content before use. So it's safe to use RCU slab here.
 	 */
-	swap_table_cachep = kmem_cache_create("swap_table",
-			    sizeof(struct swap_table),
-			    0, SLAB_PANIC | SLAB_TYPESAFE_BY_RCU, NULL);
+	if (!SWP_TABLE_USE_PAGE)
+		swap_table_cachep = kmem_cache_create("swap_table",
+				    sizeof(struct swap_table),
+				    0, SLAB_PANIC | SLAB_TYPESAFE_BY_RCU, NULL);
 
 #ifdef CONFIG_MIGRATION
 	if (swapfile_maximum_size >= (1UL << SWP_MIG_TOTAL_BITS))
-- 
2.51.0


