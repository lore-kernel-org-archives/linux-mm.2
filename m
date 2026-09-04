Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 568BAC624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 13:25:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 701746B0095; Fri,  4 Sep 2026 09:25:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2BA6B0096; Fri,  4 Sep 2026 09:25:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 553EC6B0098; Fri,  4 Sep 2026 09:25:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 283706B0095
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:25:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A62A3A13B2
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 13:25:21 +0000 (UTC)
X-FDA: 85176151242.17.50BD35F
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id CCCE120002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 13:25:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ROtfhc7q;
	spf=pass (imf13.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788528319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cSh3mJfdO0nEIzhBW2LVy8p7WdUuzr0B9b3+/UuFCgI=;
	b=Cad9rjARPjWlPm7RzuRl2mwPVtHA6JFEmHdsokmW4Rhd62aQqd5lBllpI8sohog5ihDvaT
	CyTsJYzcmVU7XnSUntinzK8LsY9qY8n3zB4Uz0Ddr6Q24sRyz0dRXREhGKnHcCXYnkxPfB
	giHH8Gpy5pZTQbrTRyWKCNqNfciW8bY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788528319;
	b=6on8YtgGX1XRvU57Hc5QHYj7OhuFapDpmVTgDN9DHDeU9HptskvqTcQFastt5sshZ7gMjw
	uBkM4vr4kLpTB7Iz/hhvy9i6q60QxWyGI6tGPLNRLGrmo/flhfnAxHht+nXUR3STp4O7Ju
	DQmktzQPmQaETrobX3OfRVOuhFyc9eA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ROtfhc7q;
	spf=pass (imf13.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cc1a4c62804so897931a12.3
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 06:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788528318; x=1789133118; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cSh3mJfdO0nEIzhBW2LVy8p7WdUuzr0B9b3+/UuFCgI=;
        b=ROtfhc7q1tsZdeyhyi3ARF9bsZsAuWHOYmvQpcAiki3k549uoQLedK3PzxJlX6fmFI
         nj0uddk3tVCEcWi1bXli1X1Kz+gkTROvbGx/+j4w8AaT/2T2twtmstwz+HRngD09wDAU
         DLh4zH6GorAljb0RoqbKULUhmz2xOQJj/JAo2IXKFs+S29+WDJbbRp3jc8XgNGG944Gx
         EYucJVxZYyrvYNkiEmF9XzpfNjS12d0ZyaJPQl94RisUJC9FVOHuY7wTz3fsGYdyAvPY
         27OLhqG+DqT3VECLnDCOvgucpGVRWOWPRD6rXq8WfOFAdl7bQ8fLKbFDqRGNR1mRd6to
         JruA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788528318; x=1789133118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cSh3mJfdO0nEIzhBW2LVy8p7WdUuzr0B9b3+/UuFCgI=;
        b=ITwWkrcURVtDf/8NJZnWo6qGnqvtrzamhlnfLxwtCEJ3Tyi5aQEKxpPYcwLNP2oLvM
         haOTIUaI/JO+/j4ngTh7Jx0S9s/vlWVdxkSoAVUebfc1BeRZnJ0Z3PVcnRaEgoGwYyJ8
         K+1YvME1jH5Xm/A3/+f2/tVs3WNR6dkZ4UHIn6/AK/zw7+UXwePCU8vyQuEQ+xZtY7ep
         5ayu8fjNVqOoIz2260aXqDL2cNblJ9Jbfp1TXgbqYFGF3R4ei+9IDXKeUmWjOF15DpSD
         Dr/JiFvUeeeWboGspoat2qsdjkGcJSWZ5C4YogS69Qu0h3/6IMeXTcaOu6WWCBMj0kXr
         T/3w==
X-Forwarded-Encrypted: i=1; AKwUvByn/sLyK3iChHHn1cAND7tHwwHBZ/4JsYtzw2203WcKtZVD4j+fjqR5zYyvm6eDq1P1s1SLgdxewA==@kvack.org
X-Gm-Message-State: AFuF++m1LF33Tk53KWCjI6QnkYdWF+8DzR/7i/QTrRPgMsX4sNrm9t7B
	nTS15ZWQ2wFmOmmw5OnArznYjAqnQLU7y9djeTLQMBS3VEtyCznUEHcb
X-Gm-Gg: AYBFou1EuBotLTYwD0d4X2b35bA2mOndIeYVXGHCWWkR6E4J3bx+IL6prvP7WKsefdP
	ccZh4YE2a6aYNUyB/0PQCtygzlwKD+gBZAQIl0pqPhqD82b7egQFgV2SqYtgih++BafaehseYUX
	ab8lNEnxKNtIeZX/wMOieUFts0+YUXvM2w/HPhJxKpAQSGE4Vy3S/D5qr60V6TCK11OHr8o1wwM
	dYpe32vTinJH9mud7lUmUYa7Zomf/etDrOa2BW7Z6dwDdH63RSmI3UGxLj4gh7YwuzY8L6qTPxZ
	NEAbiTEfFHcZybt9z9gLpZ4cFRh2zIg+EvOg1vN3i5XygKc8eYOE3xs4R2xlMn8Tm+tWvnq2u81
	3+UHx6q89mmTPsRP3dezjMIjrVdvgll4JYxVF5Nmyr5bgihzr8Ia3csmbF/ZZ1kav29lYodoNSo
	ijdpo19bX7ZQLtPDn8zTV43DME4uWIwSP0TX14MViouA+tDcsUeg9yNyitr6rI5m3uYvxZ7m/Dq
	yW0W3if8qRBEEuiwNOzes69XtBReYC7qRWd/Q==
X-Received: by 2002:a05:6a21:680d:b0:3d3:aee4:66f3 with SMTP id adf61e73a8af0-3da3a22a052mr9685866637.25.1788528318470;
        Fri, 04 Sep 2026 06:25:18 -0700 (PDT)
Received: from NV-J4GCB44.nvidia.com ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86152c2a52asm1147302b3a.30.2026.09.04.06.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 06:25:17 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 3/3] mm/zswap: reference the pool by id to shrink struct zswap_entry
Date: Fri,  4 Sep 2026 21:24:56 +0800
Message-ID: <5c4f72f1ffbd5f15d0b57fb1a87f73b4249ab424.1788528216.git.wujianyue000@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788528216.git.wujianyue000@gmail.com>
References: <20260830114731.8322-1-wujianyue000@gmail.com> <cover.1788528216.git.wujianyue000@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CCCE120002
X-Stat-Signature: kia7q13sqfrpzz7ae1gdxiutezfatp5i
X-HE-Tag: 1788528319-228455
X-HE-Meta: U2FsdGVkX18wxKK1/wpanSX+QMeEq9XqWI39UhkqyU8MTkFwQHBWX3s1DZxs2DafMG2z7R2xCndYtmLvUjgaxM5YzmD6NW3pRaHa9j6gWKxxfPl7AsfenwOR6riLBYSvwbe9reu9bu+fY5CDiJVWddhsNk5ytJzceeYYw3mGT/sCz5RmQUB1sRzDC+xQHrWM5hF9dCElI6tesw1CRnfBLENGiL2WbJXAZMBoynEupGbRmCyticfjQJ8pCc+Ve9d3J8gUMxBISZBPM/LPm+nHYeKl9LkNhLhOJ2SAvs9n7obX66l6eg6C/9mqMwtRrLD3ffAKZrb+z9W/wcH4B40S/U+4hK15j7AHHsCSvTl7MrWHESvZnj06rQ4ZvOpRSW9zrA2JbtCEhesBLzSaCI0dGL1ELiPmDKsFp7a2wBQzgCs0BqZwXyDYdtVbArC+gs2uqKQQEoIy+GdyoDOwWzSCFDCq6bMGwg6HrPQFaGMPKqjwchH6qEBXVT0fqowmxyqmT58A6zENOqxWuCXVbBl48zvbK7kkz6zb5gReHKTvR9U+i3WG51zmsPkoyQkMCptkEdZy8qYFy1xSOwC3/yfnJONIUzC7NT1Mk+sR4251BLqtNhYJNE2orTziDcUcGJ0+U5qViSPh7RklhrWmKNJ0oupBtGZfKR70aKfylnDRNXvWj3bqLIn4NIdKANH3oRS3ZgQMENdEZWJevoRMX8KoSGVNwfx/wfpaGaKeEFCf8m3eRSQlNXAlPmKsulvEFMt2rq4ohL68vfmH4pdVg31ohs4cH28ik8uzLO7+7P/gF8CIyQcsfdCqT0SfJH1S2ez+R4vS9Z9E48bcbsekbakkmLTrxoKAkUPsKUQ5kkbB+/uH0Fo7Mr6n4eUSubXbvG07XG2SDT6tGkFSn7sRCKnIwAZGDcbAT+1+3fFgUcVjW9ZleqdztZf5GrYm3JHkhCtO7zteYr9+3ZclqQrJtJf
 JVIYPNF4
 YXG1eThXbQkUP+ucNmwxEQXWXGPvP8PlvZDqQzlkjb8dT/TbcbvG6ZSCcGCRLZwcpMccORzGOFvQdEDOG+9gxunrZw3VozqhK2fWzRB27iUVFjMNEOerdA8vz6LEIwtQn99ZrqkWIaeaUkVb+KvAP0mYETv2Q25Mz4DNMyKmPIOECPcGWlkcMW+m/EDoAXUaz+m1fRwUX1SzOKcZ1ohVEZIPiR63sCNXlmz+QOBNr20Ri7n2F29Vz5S5kGq7ftGdnS0tIjeBwh1i+GOoZw7Tqletaga/z722kMadXz7euc1HGmEsDm+3lXUQ2eObvNlU/kDNBhJfdbppa4Zd5WqMuZZLgMgoTbw0sdSsj6iUqqwi8dcSiqJKw3iUd+cK10ijZZTTy97enoqlaQavHz7mkx2STUWlkss5q+15aFYEWErGkUn5w1nrjOyiBNtI241i8vmI5qBiGGYeDja6Yn4eZclECWCgIXfZE7TJPZGvLJnsnjI/mleb3Agd3hYmDoxdP4DEl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

struct zswap_entry is one allocation per stored page, so its size is
pure overhead. It currently embeds an 8-byte pool pointer, even though
the live pools now sit in an allocating xarray keyed by a small integer
id that fits in a u8.

Replace the per-entry pool pointer with that u8 id and resolve it
through the xarray with xa_load(). A live entry holds a reference to its
pool, so the id cannot be reused under it; xa_load() is lockless and
only needs an rcu_read_lock() section, no zswap_pools_lock. A live entry
never uses the reserved id 0, so looking up that id resolves to NULL
and trips a WARN rather than aliasing a live pool.

The u8 fits in the padding after the bool referenced field, shrinking
the entry from 56 to 48 bytes on 64-bit. This raises objs_per_slab from
73 to 85 and saves about 2MiB of metadata per 1GiB of data held in
zswap.

Suggested-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 mm/zswap.c | 45 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 74876acfa9dc..31cf0ef43d23 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -195,7 +195,7 @@ static struct shrinker *zswap_shrinker;
  *              writeback logic. The entry is only reclaimed by the writeback
  *              logic if referenced is unset. See comments in the shrinker
  *              section for context.
- * pool - the zswap_pool the entry's data is in
+ * pool_idx - id of the zswap_pool that the entry's data is in.
  * handle - zsmalloc allocation handle that stores the compressed page data
  * objcg - the obj_cgroup that the compressed memory is charged to
  * lru - handle to the pool's lru used to evict pages.
@@ -204,12 +204,27 @@ struct zswap_entry {
 	swp_entry_t swpentry;
 	unsigned int length;
 	bool referenced;
-	struct zswap_pool *pool;
+	u8 pool_idx;
 	unsigned long handle;
 	struct obj_cgroup *objcg;
 	struct list_head lru;
 };
 
+/*
+ * The pool stays alive after this returns because a stored entry holds a
+ * reference to its pool (taken in zswap_store_page()).
+ */
+static struct zswap_pool *zswap_entry_pool(struct zswap_entry *entry)
+{
+	struct zswap_pool *pool;
+
+	rcu_read_lock();
+	pool = xa_load(&zswap_pools, entry->pool_idx);
+	rcu_read_unlock();
+
+	return pool;
+}
+
 static struct xarray *zswap_trees[MAX_SWAPFILES];
 static unsigned int nr_zswap_trees[MAX_SWAPFILES];
 
@@ -770,9 +785,13 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
  */
 static void zswap_entry_free(struct zswap_entry *entry)
 {
+	struct zswap_pool *pool = zswap_entry_pool(entry);
+
 	zswap_lru_del(entry);
-	zs_free(entry->pool->zs_pool, entry->handle);
-	zswap_pool_put(entry->pool);
+	if (!WARN_ON_ONCE(!pool)) {
+		zs_free(pool->zs_pool, entry->handle);
+		zswap_pool_put(pool);
+	}
 	if (entry->objcg) {
 		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
 		obj_cgroup_put(entry->objcg);
@@ -929,12 +948,15 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 
 static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 {
-	struct zswap_pool *pool = entry->pool;
+	struct zswap_pool *pool = zswap_entry_pool(entry);
 	struct scatterlist input[2]; /* zsmalloc returns an SG list 1-2 entries */
 	struct scatterlist output;
 	struct crypto_acomp_ctx *acomp_ctx;
 	int ret = 0, dlen;
 
+	if (WARN_ON_ONCE(!pool))
+		return false;
+
 	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
 	mutex_lock(&acomp_ctx->mutex);
 	zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->length);
@@ -970,7 +992,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	pr_alert_ratelimited("Decompression error from zswap (%d:%lu %s %u->%d)\n",
 						swp_type(entry->swpentry),
 						swp_offset(entry->swpentry),
-						entry->pool->tfm_name,
+						pool->tfm_name,
 						entry->length, dlen);
 	return false;
 }
@@ -1428,6 +1450,16 @@ static bool zswap_store_page(struct page *page,
 	if (!zswap_compress(page, entry, pool))
 		goto compress_failed;
 
+	/*
+	 * Set pool_idx before publishing the entry: compression has
+	 * succeeded and the pool is already pinned by this store, so the id is
+	 * final.  Doing it here (rather than after xa_store()) means the entry
+	 * is never briefly visible with a stale pool_idx left over from slab
+	 * reuse, which zswap_entry_pool() would otherwise resolve to an
+	 * unrelated live pool.
+	 */
+	entry->pool_idx = pool->idx;
+
 	old = xa_store(swap_zswap_tree(page_swpentry),
 		       swp_offset(page_swpentry),
 		       entry, GFP_KERNEL);
@@ -1473,7 +1505,6 @@ static bool zswap_store_page(struct page *page,
 	 *    The publishing order matters to prevent writeback from seeing
 	 *    an incoherent entry.
 	 */
-	entry->pool = pool;
 	entry->swpentry = page_swpentry;
 	entry->objcg = objcg;
 	entry->referenced = true;
-- 
2.43.0


