Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69604606A339
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=bkk4fV7X
Received: by kanga.kvack.org (Postfix)
	id F41FA6B00EF; Tue, 10 Nov 2026 00:49:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEFB96B05B9; Tue, 10 Nov 2026 00:49:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6C666B05BA; Tue, 10 Nov 2026 00:49:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9FE806B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:49:01 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 99DBC120489
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:49:00 +0000 (UTC)
X-FDA: 85418130840.06.4D7ADA1
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id BFCB6A0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:48:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=bkk4fV7X;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794289738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1kCFvXE1I6TMTzcovLh/jNTD4puJnNsyYl7iqOayhW0=;
	b=gD8BY5NPj+kAv8tO69KUteDGGI6qWBb4pSQiU5YBYshhOahkPbkGLYDUCcvonU4mD97K10
	zej5fkrsLVb0ko6C0oqbMPh+qFZSr3YHSMjKbEdQjNJy1gY5lyDoD5afTqj/7QANjqCzq+
	mpjBbgC7OSt5utaYBpm3eR3ySJ1WK5k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794289738;
	b=jkivUOawNGCaTgBIs+4Hkabxb527VcNx2poe5PcfCkQ4xd2VlvATcaOz6TUo5heu2I3v2p
	geZYX/bwvhB0rMB9MlytlWPZZfX7L88Nd+NPGG2LU55D4YgLtelews4y6McROR8xi/Y+Th
	kWt/7wTjb2TCmDaSQH5da24TICYZFuQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=bkk4fV7X;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8b32bc605d9so681471b3a.2
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794289738; x=1794894538; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1kCFvXE1I6TMTzcovLh/jNTD4puJnNsyYl7iqOayhW0=;
        b=bkk4fV7XfUbZ+OvuOtL/G/nip4aQUdJmNQLR6/pnE6koro2WaEge2qd6rjPbe+3GnJ
         lahrNTEvasxg8jkqg6tuhW6WfQdpVwyRrLUwZ4WwATjvGwC4+8Eq7wDHvvoocdknpbKM
         LyYQi506rJVud6TL06jTChgV9hyRxM/BNxxRc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794289738; x=1794894538;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1kCFvXE1I6TMTzcovLh/jNTD4puJnNsyYl7iqOayhW0=;
        b=XS0U51sEkZEKPRSsDiew1zshNbNBzhExXdXVKKmwkkOf+zUQnIO1lHqodd+TqcFk1b
         MfIetSeTI/K7k6SqdHe4PhUE7C44jOa778+Rfqlxlvq6NMZr0i8zoZegCXK1xPeuYLai
         eccWzFgcZBDZXKTMXonq5nJQ+Z1mWwbDUA7UOT4UUigKrJOEnQfaxndpAR9QWFrhwgCE
         3EN5H6eTKAupDKn6fKQtLMH+NfUuqxH7DZih/NrRprq1IsfLWnRyv5UbSmrMB28Bh3+A
         AZFUO5/M74WuzUmdRhZDZbylH+zcGNSDAfVRzvhJvEVpNt60s/CXdwHuSH1+OEbE4Wuo
         8CoQ==
X-Forwarded-Encrypted: i=1; AL+hErGeC1v1CGM94F9WA3sP1/k3vxbLA9pYa83/ciGXrctBlL4UKGK8Y3WfYwYRgtMgLIAa1kgshbi8zg==@kvack.org
X-Gm-Message-State: APuU4Z9Z1AE60BCT3XfWAgPEjQdeuxScLf1qyhhcBheFSHCmnx8hfCE9
	0xOn0FiJl2CPfbapISA9rIoNxUYU/7w3UrWPKs0+kHgeEPxshiAddhQ0g7jHGnD/XQ==
X-Gm-Gg: AYBFou3cfEkcV+LFmc4OeMrsbvG9V7EUdw8nlCXHB4bLqd9dd71rjPqjtXISLXtuUAK
	fXqWg8iEdWgH+cjBHp722w4I0tE3bHTcvhU95ZnvlFsetqV7wXEm8Nic3L1TmpP5iCLmoZoKSty
	gJrKcAd7aNXsGOyInRWEFX4wg/pxGH0TT2IUqPVDz7P1FkkGaz7+xKry4G901UIIOrznTZNBJ6e
	oD+mVDIndCfAQZXCLzqqr3C0m+SxkEwUddv6S05zFjb3qdm/kUHRv1nnuGtKb5usVEhhw19vOMH
	dHTWk/gpwHWwH4cgVgE/EDzZFQxVehJhgn39BU/O+oOHKBSnXUuLozLPBx6yIk1F8Ihyp6E2bFu
	XJJQBgyp7M03S1S9CXcV3hvYzSNQKzYiPJelEIkRwnxsT7TQrQT5QSChD1zVGcfE3sEJAYX4GsL
	WXs4ZLAV7UfXfSZR+Ta+N/bC2+uND+GPwkTPPtF0ou/UAQkdsyPiIIK2YZLDVGIcYHsGo9fslj3
	sthjoV9Me/RTBFcRu44TPzGtwgzEjPZRYF/XLOE/fXG9t0BjquGPlUH5D/hF13Avo+twYwen5P0
	Q3jipEIWYofNHzr4G0mj+S6ZKp0WT/vKAu3lLO16cYjOZ2RcWJ52/pECUV8ykd27R3Wk2xF+eWt
	Cp8N6JYMWGiTbqqQQCIk=
X-Received: by 2002:a05:6a20:4394:b0:3d4:52bd:b89d with SMTP id adf61e73a8af0-3f18ebb376cmr1436126637.23.1794289737457;
        Mon, 09 Nov 2026 21:48:57 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:e137:9384:7cd8:6e40])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdd8d67e53asm444634a12.5.2026.11.09.21.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 21:48:57 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 04/11] zsmalloc: switch handle type to struct zs_handle
Date: Tue, 10 Nov 2026 14:48:09 +0900
Message-ID: <20261110054836.1515030-5-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
In-Reply-To: <20261110054836.1515030-1-senozhatsky@chromium.org>
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BFCB6A0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 15ybddag9bk5ymyfpmg4ryrtzbma9cif
X-Rspam-User: 
X-HE-Tag: 1794289738-718015
X-HE-Meta: U2FsdGVkX19wHpTYnM1usmN31GvIy9qOOgPkDErPnDWoAkSfTlw9lIQhf2JqmHYWj1/4mmXt7m2F2q9RSgS6Sdc61gsDnas7n2aijGAxFzT55fbnIvwRXps82sSpwPnlMueH3fLzEhlnRQq1C6oF1P65FZZBf8OaW56GLDRVec6lsDyOENIUPf92OZC+LycZldun9eSjJE0ibkwu9pKqY+/NYIkrQntxsBVcCJzEvanjMHlSgv75qg1vXVflr8egGtaxyWnRR4forHKiBx2PY+VEASu0TiDaca9ccho0xGTfJBy2nyjOhU/ZiLJEiEnmX0oifnZFPrYjYll0rxH3212KPoxzOO+s07kxyNM55duLBSejOp8uEW6Na36XuXL4QxXbNhbEbXAjI1S40ccbFLDxXnW+M8CupGc+FaSPQdUFSi5P1fG8YNgyy8gjZX9qsVk4fHIH63tokN1LaKyqcXfkZo7eXDQKRKtK55Uu6tYZiUm8e5lvE2v3Hxi9janXOQ20xnHLhMDQh5DG+9IwdZNstciqPCe/iosFQYVC5w0vBgEAleJ4sh6XM8zkixI+IpTrUoqKEz7FeVHOK9cabt5fuYV9j1LW3ZR14E7OYJZbIoG3XLh9tO8ErH0AxPbxXeRi20sl5fLiD82lIjh53wFFLyRScX2jCI+AHyO0soNWgejz4p87/P3v/BYFjJxQjd/A5sStyuOrmrdSf1zsWv/6u3Jrfn/3DdCe5RenMftqzQ9QCzOPJ4Ijl0jXqia/T5xzcTZG5ZFr152ay2w1+kIyvm+0jeENyeU7huSVcSjGdWnwK6O6D7ZlFE/ODkbUixMJh/5L4Kdpplmg9lzXJL0SKGisylIVxEvvcZXSO53GlCTCndtZNVP0uu9KQS9HJrUJIf9FqVsEuVaeNO9aCAiihiiBfjl3R0orXl8m24mfNEmXF6xA+OkwxSYlQ0ytza8sGNwZ2AUf/3nUD8B
 PQg0gxHk
 gcELp5A+SuzNONy6jx18oPPf4VAZZwnD9iOgRgq3zCXl0P7HqVy65k/ZpeD3oYjd4ZRBW05DhbgU+7aNGRd4gDYJD6ElfcFfxYvZLfq2LoUuSGLX/oeE7wAdoTDaA9CFJdEDzQK58TCo20hAqFc6lxjR3RI9tTgBFMmN3seYtZsKPOjs6aVyTcIQHwlsEBlh7GYm6IcGQ8LAfpBFiWZ3oEzm6uSjKjYClU8WWHOaqsJ0jGb9zh08830QSc2HbOQ7GX/duYgIwcLOZwHGekw2b4R7P+T3fOn2xeHgbtNCxA7DP0JGPWWMXQnp56ujXSGAyn5umHwVkqi4gF2xegOmKOmxfaYPvFpp5d3qx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zsmalloc handle is an unsigned long that holds an address of a
handle_cachep object, so zsmalloc and its users have to cast it
back and forth.  Introduce struct zs_handle and switch zsmalloc,
zram and zswap to struct zs_handle pointers.  Functions that only
read the handle take a const pointer.

This is a preparation for embedding struct zs_handle into zram and
zswap entries.  No functional change.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 28 ++++++------
 drivers/block/zram/zram_drv.h |  2 +-
 include/linux/zsmalloc.h      | 13 +++---
 mm/zsmalloc.c                 | 85 +++++++++++++++++++----------------
 mm/zswap.c                    |  8 ++--
 5 files changed, 73 insertions(+), 63 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 5c13addd22f6..2c2e11b2b663 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2030,7 +2030,7 @@ static bool zram_meta_alloc(struct zram *zram, u64 disksize)
 
 static void slot_free(struct zram *zram, unsigned long index)
 {
-	unsigned long handle;
+	struct zs_handle *handle;
 
 #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
 	zram->table[index].attr.ac_time = 0;
@@ -2096,7 +2096,7 @@ static int read_incompressible_page(struct zram *zram, struct page *page,
 				    unsigned long index)
 {
 	struct scatterlist sg[2];
-	unsigned long handle;
+	struct zs_handle *handle;
 	void *src, *dst;
 
 	handle = zram->table[index].handle;
@@ -2118,7 +2118,7 @@ static int read_compressed_page(struct zram *zram, struct page *page,
 	enum zcomp_dstrm_mode mode = ZCOMP_DSTRM_EXCLUSIVE;
 	struct zcomp_dstrm *zstrm;
 	struct scatterlist sg[2];
-	unsigned long handle;
+	struct zs_handle *handle;
 	unsigned int size;
 	void *dst;
 	int ret, prio;
@@ -2146,7 +2146,7 @@ static int read_from_zspool_raw(struct zram *zram, struct page *page,
 				unsigned long index)
 {
 	struct scatterlist sg[2];
-	unsigned long handle;
+	struct zs_handle *handle;
 	unsigned int size;
 	void *dst;
 
@@ -2257,14 +2257,14 @@ static int write_same_filled_page(struct zram *zram, unsigned long fill,
 static int write_incompressible_page(struct zram *zram, struct page *page,
 				     unsigned long index)
 {
-	unsigned long handle;
+	struct zs_handle *handle;
 	void *src;
 
 	handle = zs_malloc(zram->mem_pool, PAGE_SIZE,
 			   GFP_NOIO | __GFP_NOWARN |
 			   __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
-	if (IS_ERR_VALUE(handle))
-		return PTR_ERR((void *)handle);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
 
 	if (!zram_can_store_page(zram)) {
 		zs_free(zram->mem_pool, handle);
@@ -2295,7 +2295,7 @@ static int zram_write_page(struct zram *zram, struct page *page,
 			   unsigned long index)
 {
 	int ret = 0;
-	unsigned long handle;
+	struct zs_handle *handle;
 	unsigned int comp_len;
 	void *mem;
 	struct zcomp_cstrm *zstrm;
@@ -2328,9 +2328,9 @@ static int zram_write_page(struct zram *zram, struct page *page,
 	handle = zs_malloc(zram->mem_pool, comp_len,
 			   GFP_NOIO | __GFP_NOWARN |
 			   __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
-	if (IS_ERR_VALUE(handle)) {
+	if (IS_ERR(handle)) {
 		zcomp_cstrm_put(zstrm);
-		return PTR_ERR((void *)handle);
+		return PTR_ERR(handle);
 	}
 
 	if (!zram_can_store_page(zram)) {
@@ -2451,8 +2451,8 @@ static int recompress_slot(struct zram *zram, unsigned long index,
 			   u32 threshold, u32 prio)
 {
 	struct zcomp_cstrm *zstrm = NULL;
-	unsigned long handle_old;
-	unsigned long handle_new;
+	struct zs_handle *handle_old;
+	struct zs_handle *handle_new;
 	unsigned int comp_len_old;
 	unsigned int comp_len_new;
 	unsigned int class_index_old;
@@ -2534,9 +2534,9 @@ static int recompress_slot(struct zram *zram, unsigned long index,
 			       GFP_NOIO | __GFP_NOWARN |
 			       __GFP_HIGHMEM | __GFP_MOVABLE,
 			       page_to_nid(page));
-	if (IS_ERR_VALUE(handle_new)) {
+	if (IS_ERR(handle_new)) {
 		zcomp_cstrm_put(zstrm);
-		return PTR_ERR((void *)handle_new);
+		return PTR_ERR(handle_new);
 	}
 
 	zs_obj_write(zram->mem_pool, handle_new, zstrm->buffer, comp_len_new);
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 5416e25e64e8..5b211a9f314c 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -79,7 +79,7 @@ enum zram_pageflags {
  */
 struct zram_table_entry {
 	union {
-		unsigned long handle;
+		struct zs_handle *handle;
 		unsigned long element;
 		unsigned long blk_idx;
 	};
diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 5b7298a5026b..7fa500ae2653 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -22,14 +22,15 @@ struct zs_pool_stats {
 };
 
 struct zs_pool;
+struct zs_handle;
 struct scatterlist;
 
 struct zs_pool *zs_create_pool(const char *name);
 void zs_destroy_pool(struct zs_pool *pool);
 
-unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t flags,
-			const int nid);
-void zs_free(struct zs_pool *pool, unsigned long obj);
+struct zs_handle *zs_malloc(struct zs_pool *pool, size_t size, gfp_t flags,
+			    const int nid);
+void zs_free(struct zs_pool *pool, struct zs_handle *handle);
 
 size_t zs_huge_class_size(struct zs_pool *pool);
 
@@ -40,10 +41,10 @@ unsigned int zs_lookup_class_index(struct zs_pool *pool, unsigned int size);
 
 void zs_pool_stats(struct zs_pool *pool, struct zs_pool_stats *stats);
 
-void zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
+void zs_obj_read_sg_begin(struct zs_pool *pool, const struct zs_handle *handle,
 			  struct scatterlist *sg, size_t mem_len);
-void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle);
-void zs_obj_write(struct zs_pool *pool, unsigned long handle,
+void zs_obj_read_sg_end(struct zs_pool *pool, const struct zs_handle *handle);
+void zs_obj_write(struct zs_pool *pool, const struct zs_handle *handle,
 		  void *handle_mem, size_t mem_len);
 
 extern const struct movable_operations zsmalloc_mops;
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index dab71f582103..3a6a7253fd01 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -264,6 +264,10 @@ struct link_free {
 	};
 };
 
+struct zs_handle {
+	unsigned long __private obj;
+};
+
 static struct kmem_cache *handle_cachep;
 static struct kmem_cache *zspage_cachep;
 
@@ -438,16 +442,16 @@ static void init_deferred_free(struct zs_pool *pool) {}
 static void SetZsPageMovable(struct zs_pool *pool, struct zspage *zspage) {}
 #endif
 
-static unsigned long cache_alloc_handle(gfp_t gfp)
+static struct zs_handle *cache_alloc_handle(gfp_t gfp)
 {
 	gfp = gfp & ~(__GFP_HIGHMEM | __GFP_MOVABLE);
 
-	return (unsigned long)kmem_cache_alloc(handle_cachep, gfp);
+	return kmem_cache_alloc(handle_cachep, gfp);
 }
 
-static void cache_free_handle(unsigned long handle)
+static void cache_free_handle(struct zs_handle *handle)
 {
-	kmem_cache_free(handle_cachep, (void *)handle);
+	kmem_cache_free(handle_cachep, handle);
 }
 
 static struct zspage *cache_alloc_zspage(gfp_t gfp)
@@ -466,9 +470,9 @@ static void cache_free_zspage(struct zspage *zspage)
  * Pairs with READ_ONCE() in handle_to_obj(): zs_free() may read the
  * handle locklessly, so prevent store tearing here.
  */
-static void record_obj(unsigned long handle, unsigned long obj)
+static void record_obj(struct zs_handle *handle, unsigned long obj)
 {
-	WRITE_ONCE(*(unsigned long *)handle, obj);
+	WRITE_ONCE(ACCESS_PRIVATE(handle, obj), obj);
 }
 
 /* Protected by class->lock */
@@ -817,12 +821,12 @@ static unsigned long location_to_obj(struct zpdesc *zpdesc, unsigned int obj_idx
 	return obj;
 }
 
-static unsigned long handle_to_obj(unsigned long handle)
+static unsigned long handle_to_obj(const struct zs_handle *handle)
 {
-	return READ_ONCE(*(unsigned long *)handle);
+	return READ_ONCE(ACCESS_PRIVATE(handle, obj));
 }
 
-static inline unsigned long obj_allocated(struct zpdesc *zpdesc, void *obj)
+static inline struct zs_handle *obj_allocated(struct zpdesc *zpdesc, void *obj)
 {
 	unsigned long handle;
 	struct zspage *zspage = get_zspage(zpdesc);
@@ -835,10 +839,10 @@ static inline unsigned long obj_allocated(struct zpdesc *zpdesc, void *obj)
 		handle = *(unsigned long *)obj;
 
 	if (!(handle & OBJ_ALLOCATED_TAG))
-		return 0;
+		return NULL;
 
 	/* Clear all tags before returning the handle */
-	return handle & ~OBJ_TAG_MASK;
+	return (struct zs_handle *)(handle & ~OBJ_TAG_MASK);
 }
 
 static void reset_zpdesc(struct zpdesc *zpdesc)
@@ -1120,7 +1124,7 @@ unsigned long zs_get_total_pages(struct zs_pool *pool)
 }
 EXPORT_SYMBOL_GPL(zs_get_total_pages);
 
-void zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
+void zs_obj_read_sg_begin(struct zs_pool *pool, const struct zs_handle *handle,
 			  struct scatterlist *sg, size_t mem_len)
 {
 	struct zspage *zspage;
@@ -1167,7 +1171,7 @@ void zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
 }
 EXPORT_SYMBOL_GPL(zs_obj_read_sg_begin);
 
-void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle)
+void zs_obj_read_sg_end(struct zs_pool *pool, const struct zs_handle *handle)
 {
 	struct zspage *zspage;
 	struct zpdesc *zpdesc;
@@ -1182,7 +1186,7 @@ void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle)
 }
 EXPORT_SYMBOL_GPL(zs_obj_read_sg_end);
 
-void zs_obj_write(struct zs_pool *pool, unsigned long handle,
+void zs_obj_write(struct zs_pool *pool, const struct zs_handle *handle,
 		  void *handle_mem, size_t mem_len)
 {
 	struct zspage *zspage;
@@ -1251,7 +1255,7 @@ size_t zs_huge_class_size(struct zs_pool *pool)
 EXPORT_SYMBOL_GPL(zs_huge_class_size);
 
 static unsigned long obj_malloc(struct zs_pool *pool,
-				struct zspage *zspage, unsigned long handle)
+				struct zspage *zspage, struct zs_handle *handle)
 {
 	int i, nr_zpdesc, offset;
 	unsigned long obj;
@@ -1278,9 +1282,10 @@ static unsigned long obj_malloc(struct zs_pool *pool,
 	set_freeobj(zspage, link->next >> OBJ_TAG_BITS);
 	if (likely(!ZsHugePage(zspage)))
 		/* record handle in the header of allocated chunk */
-		link->handle = handle | OBJ_ALLOCATED_TAG;
+		link->handle = (unsigned long)handle | OBJ_ALLOCATED_TAG;
 	else
-		zspage->first_zpdesc->handle = handle | OBJ_ALLOCATED_TAG;
+		zspage->first_zpdesc->handle =
+			(unsigned long)handle | OBJ_ALLOCATED_TAG;
 
 	kunmap_local(vaddr);
 	mod_zspage_inuse(zspage, 1);
@@ -1303,23 +1308,23 @@ static unsigned long obj_malloc(struct zs_pool *pool,
  * otherwise an ERR_PTR().
  * Allocation requests with size > ZS_MAX_ALLOC_SIZE will fail.
  */
-unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp,
-			const int nid)
+struct zs_handle *zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp,
+			    const int nid)
 {
-	unsigned long handle;
+	struct zs_handle *handle;
 	struct size_class *class;
 	int newfg;
 	struct zspage *zspage;
 
 	if (unlikely(!size))
-		return (unsigned long)ERR_PTR(-EINVAL);
+		return ERR_PTR(-EINVAL);
 
 	if (unlikely(size > ZS_MAX_ALLOC_SIZE))
-		return (unsigned long)ERR_PTR(-ENOSPC);
+		return ERR_PTR(-ENOSPC);
 
 	handle = cache_alloc_handle(gfp);
 	if (!handle)
-		return (unsigned long)ERR_PTR(-ENOMEM);
+		return ERR_PTR(-ENOMEM);
 
 	class = lookup_size_class(pool, size);
 
@@ -1340,7 +1345,7 @@ unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp,
 	zspage = alloc_zspage(pool, class, gfp, nid);
 	if (!zspage) {
 		cache_free_handle(handle);
-		return (unsigned long)ERR_PTR(-ENOMEM);
+		return ERR_PTR(-ENOMEM);
 	}
 
 	spin_lock(&class->lock);
@@ -1408,9 +1413,11 @@ static unsigned int obj_to_class_idx(unsigned long obj)
  * encoding is disabled), fall back to pool->lock for the lookup.
  */
 #if ZS_OBJ_CLASS_BITS > 0
-static inline void obj_class_get_and_lock(struct zs_pool *pool, unsigned long handle,
-					 unsigned long *objp, struct zspage **zspagep,
-					 struct size_class **classp)
+static inline void obj_class_get_and_lock(struct zs_pool *pool,
+					  const struct zs_handle *handle,
+					  unsigned long *objp,
+					  struct zspage **zspagep,
+					  struct size_class **classp)
 	__acquires(&(*classp)->lock)
 {
 	struct zpdesc *f_zpdesc;
@@ -1426,9 +1433,11 @@ static inline void obj_class_get_and_lock(struct zs_pool *pool, unsigned long ha
 	*objp = obj;
 }
 #else
-static inline void obj_class_get_and_lock(struct zs_pool *pool, unsigned long handle,
-					 unsigned long *objp, struct zspage **zspagep,
-					 struct size_class **classp)
+static inline void obj_class_get_and_lock(struct zs_pool *pool,
+					  const struct zs_handle *handle,
+					  unsigned long *objp,
+					  struct zspage **zspagep,
+					  struct size_class **classp)
 	__acquires(&(*classp)->lock)
 {
 	struct zpdesc *f_zpdesc;
@@ -1445,7 +1454,7 @@ static inline void obj_class_get_and_lock(struct zs_pool *pool, unsigned long ha
 }
 #endif
 
-void zs_free(struct zs_pool *pool, unsigned long handle)
+void zs_free(struct zs_pool *pool, struct zs_handle *handle)
 {
 	struct zspage *zspage;
 	unsigned long obj;
@@ -1453,7 +1462,7 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 	int fullness;
 	struct zspage *zspage_to_free = NULL;
 
-	if (IS_ERR_OR_NULL((void *)handle))
+	if (IS_ERR_OR_NULL(handle))
 		return;
 
 	obj_class_get_and_lock(pool, handle, &obj, &zspage, &class);
@@ -1557,12 +1566,12 @@ static void zs_object_copy(struct size_class *class, unsigned long dst,
  * Find alloced object in zspage from index object and
  * return handle.
  */
-static unsigned long find_alloced_obj(struct size_class *class,
-				      struct zpdesc *zpdesc, int *obj_idx)
+static struct zs_handle *find_alloced_obj(struct size_class *class,
+					  struct zpdesc *zpdesc, int *obj_idx)
 {
 	unsigned int offset;
 	int index = *obj_idx;
-	unsigned long handle = 0;
+	struct zs_handle *handle = NULL;
 	void *addr = kmap_local_zpdesc(zpdesc);
 
 	offset = get_first_obj_offset(zpdesc);
@@ -1588,7 +1597,7 @@ static void migrate_zspage(struct zs_pool *pool, struct zspage *src_zspage,
 			   struct zspage *dst_zspage)
 {
 	unsigned long used_obj, free_obj;
-	unsigned long handle;
+	struct zs_handle *handle;
 	int obj_idx = 0;
 	struct zpdesc *s_zpdesc = get_first_zpdesc(src_zspage);
 	struct size_class *class = pool->size_class[src_zspage->class];
@@ -1759,7 +1768,7 @@ static int zs_page_migrate(struct page *newpage, struct page *page,
 	struct zpdesc *zpdesc = page_zpdesc(page);
 	void *s_addr, *d_addr, *addr;
 	unsigned int offset;
-	unsigned long handle;
+	struct zs_handle *handle;
 	unsigned long old_obj, new_obj;
 	unsigned int obj_idx;
 
@@ -2290,7 +2299,7 @@ static void zs_destroy_caches(void)
 
 static int __init zs_init_caches(void)
 {
-	handle_cachep = kmem_cache_create("zs_handle", ZS_HANDLE_SIZE,
+	handle_cachep = kmem_cache_create("zs_handle", sizeof(struct zs_handle),
 					  0, 0, NULL);
 	zspage_cachep = kmem_cache_create("zspage", sizeof(struct zspage),
 					  0, 0, NULL);
diff --git a/mm/zswap.c b/mm/zswap.c
index 37d217860a6b..1160bd34e289 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -216,7 +216,7 @@ struct zswap_entry {
 	unsigned int length;
 	bool referenced;
 	u8 pool_idx;
-	unsigned long handle;
+	struct zs_handle *handle;
 	struct obj_cgroup *objcg;
 	struct list_head lru;
 };
@@ -889,7 +889,7 @@ static bool zswap_compress(struct folio *folio, long index,
 	struct scatterlist input, output;
 	int comp_ret = 0, alloc_ret = 0;
 	unsigned int dlen = PAGE_SIZE;
-	unsigned long handle;
+	struct zs_handle *handle;
 	gfp_t gfp;
 	u8 *dst;
 	bool mapped = false;
@@ -950,8 +950,8 @@ static bool zswap_compress(struct folio *folio, long index,
 
 	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
 	handle = zs_malloc(pool->zs_pool, dlen, gfp, folio_nid(folio));
-	if (IS_ERR_VALUE(handle)) {
-		alloc_ret = PTR_ERR((void *)handle);
+	if (IS_ERR(handle)) {
+		alloc_ret = PTR_ERR(handle);
 		goto unlock;
 	}
 
-- 
2.56.0.506.g506a7eabc5-goog


