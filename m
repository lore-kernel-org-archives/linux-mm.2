Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38653CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 16:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 947098E0027; Tue, 16 Sep 2025 12:02:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91EDC8E0001; Tue, 16 Sep 2025 12:02:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8352C8E0027; Tue, 16 Sep 2025 12:02:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 728A58E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:02:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 404791DCE79
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:02:54 +0000 (UTC)
X-FDA: 83895581868.17.A2BAEA5
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id 59DCF1C001B
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:02:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V3yBlQkt;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758038572;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y9A/r73fYL/BjndHTsKAtIDgbtMgmgaZIN32sPZEUv0=;
	b=cjhQJpeaTPlbYKKw+U/SecwrcIoW58ERO+BZiHEzjaxC5LaKG+OQAGm6taTJm18pT/kH9X
	fL2YRjiVWKbwG1rB2AEXa57U7MEw1SxXbiCkyi3+QpsIZmB4uRTd8X3J1D4hTl+zgphz+m
	eHSbFx/7gUzP8Vw0zdTafMcnbJv8fTI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758038572; a=rsa-sha256;
	cv=none;
	b=swq1q8rulq11IZFoAi61FpksHFcrBMDExBE7iGtl+DWZDXM7LDPdIaN/jkUbVkxIat0rDG
	sh8jP0aE4wIhtm/8Q134RkjVYuUVJkfDZEVPn5N9pO/cnz9uMs8lYQui90vkvzA4cYkj1r
	szRuWUiQgYjAOcu+U2v5fbGyVe24dw0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V3yBlQkt;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-80a6937c8c6so674021985a.2
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758038571; x=1758643371; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Y9A/r73fYL/BjndHTsKAtIDgbtMgmgaZIN32sPZEUv0=;
        b=V3yBlQktFEWJwyFEX9H4fgdVzA3HbYEBJh/0S/+fFXdzUtmP2QOAd/FZAMYyq7p8zi
         BCj/HQt4YHZ3F8+SL+lNTBY8gjfzHraL0i0QACao1oNgql+jrIwVMapBY47EFVbSSvxt
         KMaFYS2QazosKs/j8bKO/Eyn0heGK3mkuN1Q7cEui4BUcfiVd1gjBZ0ZC7ejUpNZEeSU
         5LRVFOu/zM1gKhFKM5cs3c6pSKvtXe3u2mft5pHEibmY6SP7SWIRpTNaGixCzuLBExkM
         Qs7DeORgKccaxd1fuaUXCvyAgHagh9WMbBH5F1CdX2LswZSppKCqiIhrOHaFxN97PAdA
         TAsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758038571; x=1758643371;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y9A/r73fYL/BjndHTsKAtIDgbtMgmgaZIN32sPZEUv0=;
        b=XynWcbWRZNdWTpVKkw3Wo1OtLLGKM61AmVTdYeKYxDpHvSdfd1RRnnBjkWBH7trTke
         IxWQfUwSLGD2Oy0JLMQNB1YC4XqIpvH2QeSJyRZX6MWgjp3Vxp5FD185+/7arx8sgCFv
         6gidaqM5o+w+2ImXFOJMRcKFRhIBbxOTpOxoLYLO6204FushEoHsR4Mv0NihdsBgXYfK
         yLT9S6yYkzamk93RwtGGGgU2BNEGZ+3TIsJle4QXJNRU5G8eN2UB3hEKTxms/xbEKcrw
         jLmJgH5444VPgFl55Qkh6k+NealWDmJcAMJaygACwZ+EXFydlCkqLbMGZuwFMr1/VRDp
         JmOg==
X-Gm-Message-State: AOJu0YxDTlERKzABjvpiba+VwY9GiL5l8WzHsCIQqck4qQWCgNo18hNk
	mT2kk23IXVJNBm6HjvHZbrr4W1ixEejP1IDW2fWA5p3ds18TL0JvOGoIQPA3iER9guc=
X-Gm-Gg: ASbGncsfO3ZmtVJXxYxj9rjwAvI5rLSuuAVETDsB34w4wRyDYqYRKLF6FRSrVUwjRkm
	ruJQZvft0TTtkCPtTh8krF5PdeCaq6ILp0bgI5WyDBBRe8h2Hl4FvxFdBkkSfwnpoHz/QCbTaVj
	jecvrknpyjWuIjFP1chbGjC+kwpNwn3YeVN/BjhHfOiRTdRY1AQG/iOdoxM/zmtfjLQsgABZMb1
	3Mxe/cOtq6AitSJI53O/OfIbRVEJsqPtJH1xNXobD9uBVtbZvKeWW1F76DER73M4+rsmmjJ/jaS
	q6U8rBNFtHCck281yWlSJvxcA4O/kYutb03iipGC/AD+uDCI1pBxtj4enHndHrZ9ssrVreGK+5H
	EQaA8d8hnZGJJynoE91iHKAPzpehymgvQ94Y5tzkwI49RNUU=
X-Google-Smtp-Source: AGHT+IF5wX/REvlgTwvjKzwh4z5xhh7WT1WZw3CdRiSULPQtDINM9vMmX/dyP5zoX4P09Uasw0kMqw==
X-Received: by 2002:a05:620a:2951:b0:82b:3775:666e with SMTP id af79cd13be357-82b37756728mr503323685a.36.1758038570391;
        Tue, 16 Sep 2025 09:02:50 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-820cd703f54sm969765485a.37.2025.09.16.09.02.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Sep 2025 09:02:49 -0700 (PDT)
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
Subject: [PATCH v4 15/15] mm, swap: use a single page for swap table when the size fits
Date: Wed, 17 Sep 2025 00:01:00 +0800
Message-ID: <20250916160100.31545-16-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250916160100.31545-1-ryncsn@gmail.com>
References: <20250916160100.31545-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 59DCF1C001B
X-Stat-Signature: as9ftmp4qi7isz1cwnuhbi6m58h3zkt8
X-Rspam-User: 
X-HE-Tag: 1758038572-355736
X-HE-Meta: U2FsdGVkX19hA7g/8+ClmOXAf/MaBAAOOvEj9LHJHkysJUHjbYat7hRKBMrZRKRDJiobB+Qf702ITrDteuLlN2TJryl5iyhlI88xtNd3q0N+u3mqPJsNi6JW5nO8Ivss6ES+/HgMqV9pHD/VcsDmpqu8+btuIUhfH4bvE00uhRUuhSLkg9NewiXFkD12RqgC46FKToFfOqOJnoKm3DXucULJ8ARE9/5c5BUc4oVCnyrEyTftsjj0gQkBZaAmNnySn3/TaaDlFcbkODF0+Fhw3VdRP0vloSasVS65umbPbakkYynf1+VIRhNTdUCtDsjSJmM6sVWMLSe/rXecC9bW5Z4e5SzX6h9q6XSEcLMNWQZRRoZ0tBwgQt4VVfPkhKZ691AHBDC1waFUazWzKBA3DSeBURVfzE97NqjCTbqfeVqNaZ0gCJcShgJWtVPBYPOmgXPR4fXeQJkZzvW9Oc87MDxlQYfuj9mMd8m6sPfNOny+7yzYw9pcQJowEh6WGNAM34CrcTyZHY/9VCaugc5Loy7gSyAbHVFiuFvrSS8zMTH1spIewNYsDzuOc+OSKIYLGrKbACQIhjsd60WZ4whpa5MucVq8wJ0KwszSDvbwWTFNQI8MOmSOIAQWLzf3k4tWZKmshRCELidVZjk2Pc/sRw4gAVAvc8YJV6UM3H0FcqXeEIFILb3y4YeWtksLGYc8P7RS6Az1ao7hsllP6HsLX7oaYx+QeQIz8oFzzrZf8iDiMZ5gDULlmoOYmMBvtN9rBbBqdOHWSSNdDIbWtETJjR8DcOj5AQcqQCsc2jnyl1RonAS4RCaG8GrwbFb82HzhK4lkB0I6FzonUNCu17IL/NKriBUayIwwJosMUZv9Ycs8mkKLpEQxPv5eK1P1GjyiHHBi2ZtrxoS7Gxhn9V3R6RV9Cu3n7mH/kFrUU+7bX6XXrybK8akDYBCLXTZIA/iLJqNDEJi4ZQ5OMJ4TH32
 HZn6cer9
 EkEVRqA749L+NlKr0aoImALSgtpCyM6ecF/d7PmxcezUQ+KWDEZs9+kYhzedt6MQBs/hj7HlkSinnP37lPSVBiNBATh7grvVdNZslqxniKYtPjEtRV0Zt6MI3lNoIh9FC0ievAt4jAD50Y46tvowaEcLUc7o7ZcdsWL7vCjWb6LbIM4CvEv9coiGWYgf1XQv5H8BC4tdAr84MY4y6K9MXaMY4A/91evg//IvTTe/9C/Jud5NrZIUui7G2jeFjdqUO+h/H0/75EEl5a0f39+/t25x3yAgz9ysEpJXzY8sbnxYxTmhJ5yp0+i9OtGXF5EH8GBh6Iaf6JDI+h6ikuXAsX1qLm24aPMaFhxV3YNE5qVlwcxOdKfGXmzIOp+vzYnoO1GYsXPxA9LGdGjQoZGBMja5yn7GkSTnK4AlpCCaEQF/TCTMwiHersuTOiBnUzaRekwuTOTZsKfjhFWvib+SN8hfAj7U/CS7UtEPvy61Gi+Wj2lZhOr5Y+vTDKu0YLBubPG/mGXy1e++gxeImgTfiZ2VeG7SOtmHsXeO8mmedVAE4pdVSqU9g3n61+TtRmRmRq/3VVfuAF5+vHFDJ0md31Zih7vSOvQsR5ugrqmUxubsu9pk=
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
 mm/swapfile.c   | 51 +++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 43 insertions(+), 10 deletions(-)

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
index 094e3e75849f..890b410d77b6 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -434,6 +434,38 @@ static inline unsigned int cluster_offset(struct swap_info_struct *si,
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
@@ -447,7 +479,7 @@ static void swap_cluster_free_table(struct swap_cluster_info *ci)
 	table = (void *)rcu_dereference_protected(ci->table, true);
 	rcu_assign_pointer(ci->table, NULL);
 
-	kmem_cache_free(swap_table_cachep, table);
+	swap_table_free(table);
 }
 
 /*
@@ -470,8 +502,7 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 	/* The cluster must be free and was just isolated from the free list. */
 	VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
 
-	table = kmem_cache_zalloc(swap_table_cachep,
-				  __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
+	table = swap_table_alloc(__GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
 	if (table) {
 		rcu_assign_pointer(ci->table, table);
 		return ci;
@@ -487,8 +518,7 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 		spin_unlock(&si->global_cluster_lock);
 	local_unlock(&percpu_swap_cluster.lock);
 
-	table = kmem_cache_zalloc(swap_table_cachep,
-				  __GFP_HIGH | __GFP_NOMEMALLOC | GFP_KERNEL);
+	table = swap_table_alloc(__GFP_HIGH | __GFP_NOMEMALLOC | GFP_KERNEL);
 
 	/*
 	 * Back to atomic context. We might have migrated to a new CPU with a
@@ -506,7 +536,7 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 	/* Nothing except this helper should touch a dangling empty cluster. */
 	if (WARN_ON_ONCE(cluster_table_is_alloced(ci))) {
 		if (table)
-			kmem_cache_free(swap_table_cachep, table);
+			swap_table_free(table);
 		return ci;
 	}
 
@@ -734,7 +764,7 @@ static int inc_cluster_info_page(struct swap_info_struct *si,
 
 	ci = cluster_info + idx;
 	if (!ci->table) {
-		table = kmem_cache_zalloc(swap_table_cachep, GFP_KERNEL);
+		table = swap_table_alloc(GFP_KERNEL);
 		if (!table)
 			return -ENOMEM;
 		rcu_assign_pointer(ci->table, table);
@@ -4072,9 +4102,10 @@ static int __init swapfile_init(void)
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


