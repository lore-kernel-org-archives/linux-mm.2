Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0690CC79F99
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 07:47:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A19DD6B0095; Sun,  6 Sep 2026 03:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A33C6B0096; Sun,  6 Sep 2026 03:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 891D76B0098; Sun,  6 Sep 2026 03:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5FEBD6B0095
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 03:47:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 02CDA1204C3
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 07:47:38 +0000 (UTC)
X-FDA: 85182557838.26.79D3477
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0B25B1C0005
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 07:47:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CuBDkrQH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788680857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xoId2o2x9KdlacVuk+UZ2/vbMr0aP2lUNDh5bJfaWLA=;
	b=8KQS8C/8Gh4o0q2ugCDlJs8bEpHn7x+JbL61z32e7LM/olw3czey+hFXtSGWhOx1fNtsOx
	qbJDYKVUCfdikn5rbUjaQ3Qm16ONKTpZQzTHUcUCeeDXhSbRieDcWcIeCIfzTOfI7G8bRJ
	pQgWWZgD1Nw3VWAndBN8jpiy6+5fTxg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788680857;
	b=FrXDyIrsU8yZMOEMeMcqYc87v68KnbHHIIDgRIQLcSBG8qV/QVPkBIYrFnw/hUdZCxo650
	F6XkWuN9j7brY1D2TcTNlHo5KmL6gy4Q8KKrujugnl+xpTXhYDg/d2xgAZfaLqyzefhZAo
	XSiPeVh8k5fOV7w1AGfHHHG9gWJNpfE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CuBDkrQH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-ca97d139d5fso2261919a12.0
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 00:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788680856; x=1789285656; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xoId2o2x9KdlacVuk+UZ2/vbMr0aP2lUNDh5bJfaWLA=;
        b=CuBDkrQHwQIClTxWEgJxDuQ8DcHJqnc6UJ6zYjNHfIDdtfdBCZ6W/VhGYEOTcyFDCa
         X0IciDqEzhhBX9OuxfpHNEJUyUH6c/khgRvtoPh/k9CsKT+K4Zcx1pp9KTnupJlgjLUk
         sNqkDRiWoIs5ETckS8jLe9YDD0zus5mFjArY7FPLGtY78pdVersqL/ogWIcmj/3QzvnB
         YkERqRY1uIeWYlTe7CMnrujd6YEXq7RiBqv8j39V63Mj5bVS/11mSjfnzURB3j6uPN9I
         YOGa0iYtOxWzfoKrSPSlY+Z6+iZwpa9ksv2cRMsRxgs4e0KC1Zl5aB0co9lY0JfKsiTF
         Es4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788680856; x=1789285656;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xoId2o2x9KdlacVuk+UZ2/vbMr0aP2lUNDh5bJfaWLA=;
        b=FnsKqwztk+VgCrOIVFEvOmL5Nyj5hVEVf0A51SdQiooLsxnBDJRAHU+vVaz34be3P+
         Vp7mAdgzGD14BmWe35/Qi9Xnc8XshLVrr5GDQnDwleK7abSrv+6jIlumRVMgrtMjK6ca
         BaxqlvaoXBX5ouzkouZmq3T7dvBQcKGzBoREBldRAEH+fIPruvbAXQShyS42f7gZMDMy
         0wvJQTDNiwl97wRYGaetGyGnj8Uz0yyJCHGtB3gw/Lb1yRI3bRZTL3Y6bNT9xstk+WFF
         y/SmyWVVIdBj9VW1LT1o8hHkZMS9T0aYhOjbRKPaFWIRUBiqTwTnDcAxkwVlAeHtkj/F
         Jz/w==
X-Forwarded-Encrypted: i=1; AKwUvBx7Re0MULJ4A20lkPQW9a0DuPPGiZFuV5qR4w7HFPYrvE8MiXuXJNXaPWhpCyPo8JUXG1rDb0iXCw==@kvack.org
X-Gm-Message-State: AFuF++m5Y3So374tHDFgGTmkVrQ/gOdDqIm/fAHArpJHeahqGDoHDAi0
	9LFS33CPQNoupN+BFlndC8xFstz6cwaXkBi8xslE2tp2P97yaKwCDwgc
X-Gm-Gg: AYBFou1+x9W/pey58Orgsg/UAytUGGOoICzTGXhhSfraLBM3rfT8+tjDNlpTpXJTny7
	64XEFIbvqFmaL2lYS4DK+p8UdbUZWeBF47qY1RabQU1s1R/6hLZ6QOdyRCufNTzFlDypZfPCSCh
	/XDWa5lpmdMEfWOj5Yc3FldG4b0BIW1AVEqZFGckX1gPR+jmoQMx+PVcJhbFWEnUTXecvgxouJH
	xWTtgnLKocgikxptEHGlR8dEfo24EGys6Pfa7BRexXK+qIArLZzsDoVZ/IQvi5I5v/k0m3U9o49
	x9u3oOqUaSh46cypBZQtQpJOh49OENHEP3OWfYptHIIRcRWUzwGyJeNrZARb3ACxSNlz3cqgaeq
	Lwjiug9JvRg9rYdgrGBeIv4rYaBD1MZBsKxAvu2iW64YHMnAqE1VCHYxYvNgAfuz4r7/RmpWIeE
	9NlFSqz39zFWn2dWkASztFCzMdlxFX2pb6p4d/kLheEfZvLY9C0FxnxYnR4uZV/8jT3Pe12cLG3
	dAAleY9qnM2tAlVZX9MxSbzKRxAvwMHWwgohc4=
X-Received: by 2002:a17:90b:3b8c:b0:398:9bd4:d13 with SMTP id 98e67ed59e1d1-39b26242a75mr22448300a91.18.1788680855786;
        Sun, 06 Sep 2026 00:47:35 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08d0d7e8sm21138905a91.16.2026.09.06.00.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 00:47:35 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Sun, 06 Sep 2026 15:47:19 +0800
Subject: [PATCH v6 3/3] mm/zswap: reference the pool by id to shrink struct
 zswap_entry
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260906-shrink_zswap_entry_v6-v6-3-ac4cf61565fb@gmail.com>
References: <20260906-shrink_zswap_entry_v6-v6-0-ac4cf61565fb@gmail.com>
In-Reply-To: <20260906-shrink_zswap_entry_v6-v6-0-ac4cf61565fb@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1788680840; l=4916;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=aySURi7Iu1LgXwQtkFbM8kcAXTbBl9vxZBkFnJ9ZVdk=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QPpwHMd9/QdHAzFgAbtJaK6isCG2rxSbIwPWQYshJrQ5IblpffIxNYW2Cc8NvsfLkXjSqcFV+5/
 /JAf50ZMmygY=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0B25B1C0005
X-Stat-Signature: p6feneb8it8eom1bd69zpwdtsxmfdume
X-Rspam-User: 
X-HE-Tag: 1788680856-386511
X-HE-Meta: U2FsdGVkX1/3ZpNf+QieVKhr2gneu5gzth9oHNDdWh6tX3aGE/a20y2GNVB0NI4Ehvt8ah8p2l2Ej6jKTvHAPRLF0E5nXTbvVH2ImGCVv/jRViSiHW+q6D+A+QmAQeXR/Gkash6GQC0xqJI+uzKNqkFunjuBtC41EY5g6T//ANU34Qw7GzDuBIomBcosiiK60Mttgp3Gp8wlxFA1FOSsrDpQxI7jfjc76LCuuO7ka13ccv+7TyHjeLsdXU9QY9XG94A/dQe18sBODE2q2GFKi6va1C+EGKhF+hqXC2R/qqeWQnuK+gBwUGQXgSgIZx1TkqlGfwoJhxeizlLhVb0+3uBDnJj8kqrspbkQXlzqP8fi/yoRZkc6gSe1AwGRHdtAkszdgsWohJHvHLf6dNX50ahL31jx0VkmUEHMtkwImb0MU+EZDPqkSa9jNrdnj0nTaIQfEkiL1YWMwqJP3gIJb+iuOtZYQh88NDLLD3Ja07EAJAFaJOVI1VG5t/7D8mGJQ18mhUwbHugs23SfF5n/SKLbN09GlbmMJn4BRuUSxKIv8b8dz1NTwhA6PyIeuPkLmuz6apr3KqTizWOVNIOhXYA8O72gn2YVtkBRJ/v2acVoI3mevstWmF2DmL9d+o1vA+UYMAKlvFXiwcpINBHW6dNoTlF6OzEEj+e1biM4ox+EJw+Hgo8YYpf9MLEWpeHqYpNEiOpHFHKjFtOvvV5qYBOw7Exqpo/uN6J8Wt4p9a+ITRDTnaJEyxYYzlGgSrbq3KRtkOeUQPygD6DYDC7Z4wf3IxAu+tsI1ukdJG1Y3eQd/BEbwjwLqaolRav5Swf7OvEcJjl5Up16jkCsy8h6QpkLKlG/d6d/p3aUICIA/HZTUD29MkEdSMqFEeHfvPPJdUID61kbl6wCtD32dzHufWo7cXpiNhXR593HNCua4hCjRsmBwnWwsPFPz7CP2odYp1q9EQNB+UJPWnG+kk3
 MQc6+B/C
 E1brT7+qr4ItJW/qp9jUajy/V2XCqMNeqjprXpd9dacgFa1rMtnBBS8IUEGVM9obds4bGS29sPREF8H47PPv95VVlADUZFJ+T9BdVVeIHo2ATqZ8bk0UJ5TA5eps9mD8ZbBD1ivbm+YHfy/lcCqPr4e25k2/AU5wXixaKdsRSem+uEhJl//UJEHrmWUCNW3UBAX+3sKgvavN3KpLXq1kuDTDh4arZHxfd9kxzSpCaHvfYbr1oHvI/LfWHpTzDRjxXScIQ83exhzv9b9V0qmdsD2jg+LxFBqclTmDjDWAeVuOgQek8p9fSj4R7s4Ci4nyWGb5vm4/TJ6To5SdgvQYACKXwsUJRvVbmYIuZZSachuBVZIVRNdmaaK8KJsiL5Jsxc9SB8bP5ge2RDnpjzOjCIBjztzMC7PlWaxGTSKhM8Rcnm0TF6v1iHcuGgyoGIJPS4eU8gRUqu+Fvr+bx7LAkWPmB3/JrQHbjLru7AT6lyWLILews7CTXbNJKpbSox471lp3+iwi57tcyfEs=
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
through the xarray with xa_load(). xa_load() does its own RCU-protected
lookup, so the caller needs no rcu_read_lock() section of its own. The
resolved pool stays valid because a live entry pins it via percpu_ref
(taken in zswap_store_page()), so its id cannot be reused. A live entry
never uses the reserved id 0, so a zeroed id resolves to NULL and trips
a WARN rather than aliasing a live pool.

The u8 fits in the padding after the bool referenced field, shrinking
the entry from 56 to 48 bytes on 64-bit. This raises objs_per_slab from
73 to 85 and saves about 2MiB of metadata per 1GiB of data held in
zswap.

Suggested-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 mm/zswap.c | 37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 86db023d63ed..253eebb971b9 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -194,7 +194,7 @@ static struct shrinker *zswap_shrinker;
  *              writeback logic. The entry is only reclaimed by the writeback
  *              logic if referenced is unset. See comments in the shrinker
  *              section for context.
- * pool - the zswap_pool the entry's data is in
+ * pool_idx - id of the zswap_pool that the entry's data is in.
  * handle - zsmalloc allocation handle that stores the compressed page data
  * objcg - the obj_cgroup that the compressed memory is charged to
  * lru - handle to the pool's lru used to evict pages.
@@ -203,12 +203,22 @@ struct zswap_entry {
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
+ * No RCU section is needed around the returned pointer: a stored entry pins
+ * its pool via percpu_ref (taken in zswap_store_page()), so the id cannot be
+ * reused under us.  Callers WARN and handle a NULL from a corrupt pool_idx.
+ */
+static struct zswap_pool *zswap_entry_pool(struct zswap_entry *entry)
+{
+	return xa_load(&zswap_pools, entry->pool_idx);
+}
+
 static struct xarray *zswap_trees[MAX_SWAPFILES];
 static unsigned int nr_zswap_trees[MAX_SWAPFILES];
 
@@ -759,9 +769,13 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
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
@@ -918,12 +932,15 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 
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
@@ -959,7 +976,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	pr_alert_ratelimited("Decompression error from zswap (%d:%lu %s %u->%d)\n",
 						swp_type(entry->swpentry),
 						swp_offset(entry->swpentry),
-						entry->pool->tfm_name,
+						pool->tfm_name,
 						entry->length, dlen);
 	return false;
 }
@@ -1417,6 +1434,13 @@ static bool zswap_store_page(struct page *page,
 	if (!zswap_compress(page, entry, pool))
 		goto compress_failed;
 
+	/*
+	 * Set pool_idx before the xa_store() below publishes the entry, or a
+	 * concurrent reader could resolve a stale pool_idx left by slab reuse
+	 * to an unrelated live pool.
+	 */
+	entry->pool_idx = pool->idx;
+
 	old = xa_store(swap_zswap_tree(page_swpentry),
 		       swp_offset(page_swpentry),
 		       entry, GFP_KERNEL);
@@ -1462,7 +1486,6 @@ static bool zswap_store_page(struct page *page,
 	 *    The publishing order matters to prevent writeback from seeing
 	 *    an incoherent entry.
 	 */
-	entry->pool = pool;
 	entry->swpentry = page_swpentry;
 	entry->objcg = objcg;
 	entry->referenced = true;

-- 
2.43.0


