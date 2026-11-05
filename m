Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CD26606D804
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=iBEZcxq1
Received: by kanga.kvack.org (Postfix)
	id 58A9B6B05BE; Wed,  4 Nov 2026 23:48:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 562216B05BF; Wed,  4 Nov 2026 23:48:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 451426B05C0; Wed,  4 Nov 2026 23:48:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1BF336B05BE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:48:12 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8B5E51C4337
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:48:11 +0000 (UTC)
X-FDA: 85399833582.11.3303296
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id B7E0F140003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:48:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=iBEZcxq1;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.51 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793854089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ty0pxF0Y4y567rYue/e29XaeUplt8CeYzKMMjvhBvo=;
	b=OXsiFax8VkRCE0XLgFdjT4caanXalX9pa5Y9GRvqW51mKNPLTNsBoGlbK8DsvbiQ4nI5ml
	ezqyfkXiOY5aCnPV2lMnT7PxL437guj4WaMzD2bBc0EgVWKNlx1lGq4vvcOgxI9EMfKuM5
	22eUGLe5iwviiNQBtHX0R2bNxDRtxIY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=iBEZcxq1;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.51 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793854089;
	b=6eHpn5ElOHgM5mwd4DKWsNhnuCowaPTcsHlWx+wpBYrk8zwjul/GiGCB5a9WvMLzxfjTgH
	UeAOTIvN9IWS+1mARgwWuOZqqQ4K80FzJ8SGsGf+zP3Qacgq9wI5JME0gJ8CA9ttbBalJk
	JmnzVdkRmCesR7Mf1LxIqMYAo00p8nU=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-14394530ec6so2075232c88.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 20:48:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1793854088; x=1794458888; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3ty0pxF0Y4y567rYue/e29XaeUplt8CeYzKMMjvhBvo=;
        b=iBEZcxq12A4xwyOcOl0FJCw3nsCcuR4LYI3a1iUM02ttqf+g+o42gwTb8xDN83WKTv
         EtsYd8+Kkg3j6gNb7YkME8DMOgFEUGv0xGYeQGAkGb5pG/szczeH55hOwFmtb2i0fYef
         s5CpOeUrxGFa3+BQzQ2CxolDuLOwJZUzLIHUY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793854088; x=1794458888;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3ty0pxF0Y4y567rYue/e29XaeUplt8CeYzKMMjvhBvo=;
        b=lgLqOcGRjshEMNa1X4lgpBEDXiPHePfAc5iUDvwgK0mn8qBCtxz+Kask8/eyIWua/S
         E9bHCGipDogwigB8t8MlRylWwN2vt3S1NJQSttUVBwqw1oCCrA2L0bjf6zkmjC2MBkfu
         7+LwmzIq0525VYtsFzD0GLjoiFh/VjEWXWFD8E8Y2hhRvFVJiMvRHUiMZpOtTtYQambo
         OJLpkNEJSTO6a5VLCcviokWQJURpHAzymZPC5cVqCGF1s19YRUYuqlAbERA74PnrfyMV
         I00t+nsunNQwRaOLNJ4UgN4lOz3uTlg4YkaxsaM3onDqlb6cl2KsmqZ/uuFDv2K8Ah7j
         zR9w==
X-Forwarded-Encrypted: i=1; AKwUvBz2jm6PEiy+jdfIItiQk4+UrYHPA6z+st6n3Knpiutfpblh9AGGiTcQrmRoKvDA8agqmJFEyOxSPA==@kvack.org
X-Gm-Message-State: APuU4Z823SqtFayOEGekEiio+BlzoOHYBGXWXNBFM2uvM+ZVRE49FmUp
	qNI2nRCqxX5t0+tSorfElZF0wBsxoCmF9VBuSwpfuDtWd5p6NResCqcS+d7fgoLTjg==
X-Gm-Gg: AYBFou33rXMXFALfRzQzcL+nXcz6hPHhnpJLdNaX6aug6kMNAMwIHhWUCVnGk1davq6
	/PFdg+/7ZlvZv25Qvv5esRO7wz1IovypXQz6VXEuzyhkCwSINZSshIYCgjhXZepSQZv5hYH2uR6
	tGpsbMpQFN7OZifsvc/QG/4GUK0Wk0GKnH4JkfpbpDFnSCT0z6uhYBO4GKozTYfpWdbAvZEN0tw
	t+0fGm2klvVp2Llv9isxvRcZ5xzN+eVcUnrFnO8Uys0uMfgS7JOo4y5+T2qoPlm6N/8oSBtwCOW
	+F1pidN+Uhb0QusilBj5j/OH6u6hsd0omeSyhb8lWyit9v0pLHzXkWjyZvpL60+uHmf9rm715nt
	KQ+bp6JFyb4k5ZyAeCkk8gPD3MegagahV3FjNEMMHI5W4Md2WL5K01124X3eJZQ1aSMjrxsqo1Q
	EeZJGoz1BcEBxN73damKVcA5VsvYPzYvo3mh1oYA8pyS28X4QyJ3hWzDl02oCgwzQYnybYXX+Sc
	JPg0gT+kAjn35HF1iy1FA+cE3MQZEorFm0lS1pUWRlTfo5MIAZBpWtgS3rFK/E6f/tO0SK+zEE8
	RHeUYuabsW/dP4J4V06zM8+rKA1vu20PgMRyCKsyQU1vsmaG3yXk0H2r9Xa4USg1H3J++5nKjYF
	Vk1bbenmU//pCapK+zho=
X-Received: by 2002:a05:7022:f115:b0:183:7d42:cfb5 with SMTP id a92af1059eb24-1ac5d88c1famr24632184c88.19.1793854088224;
        Wed, 04 Nov 2026 20:48:08 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:37bc:b763:7ec7:65b4])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm17142927c88.21.2026.11.04.20.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 20:48:07 -0800 (PST)
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
Subject: [PATCH 3/7] zsmalloc: switch handle type to struct zs_handle
Date: Thu,  5 Nov 2026 13:47:33 +0900
Message-ID: <20261105044752.1997895-4-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.398.g882cbad275-goog
In-Reply-To: <20261105044752.1997895-1-senozhatsky@chromium.org>
References: <20261105044752.1997895-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B7E0F140003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: nwenc9gmhpqcgcnwpft3p3k6y4sss55z
X-HE-Tag: 1793854089-580577
X-HE-Meta: U2FsdGVkX18vFwq2s/0HZqFAI8PdDLMnsEm9uAlnkkbqhspVtRTQhMx+wghhTHFZncOeeOjW1Ci0nc6yJ4i83w5k+c2TZ//H8cNInAy6s6OOpo4oriZFMz+ld9Ks4hig5eiD2O/y7AeoEW6baTG05yREgKqX6CXMzyYWIn8euabUDqTtobIEOqCzvIsQzp/72FeYIcaRRISO56fCpzTlSvy8VKeIt3ODyco57MLHPaUe+i8r4JY1PCHzn1P1CjNi9WDogsgvP91c2YqxnVAiL/mLfS3wI132p5/Ah1zbZFLtGFCeqdVs/q0Xqz/+ukw7UopXTp2CQeFOwQiJ2smPlCmeoESCBYzjcnyGw1SHrMB4w9pAzrz/0WsNaDIkw7p9AmlzCBtTIJCKoQotf0o2hhCmceuHyETItAC3iCAJgBsBFKBiwRrq9+hTIqvsCtWNzGpezXXTwAMrLZotE6mNdrHvnyU4zic85XE4Cnd4WB2RgXnXICSSU2fzVKPXduGns5i6LPAEUplxA+Ne8hWpwpaZYnz9xxl9RuDuPkjl5KV1WyxzyNNZ46m2PIorxKc3YR2Us4zgB4i+aiRIH1s5w73bB85FXijY9ugQ+lVGW8Ez8csFjAIqWy+5M5RvSYzELYjxptjOmFNxeOXGKRCBtgos5JQYaYqwDIrLO4nKxkz3QOXo4yTUvLeZ3WEBgjGnaXVEgFg5vCDgD+ovib+rWIqFZlR4Tv55xc2UtNjJaTx6R8mGgHlBDZ1SPca2EiizBnDPC/FgIMn1E9EVoB7N5Gg5RwQTJsKYSmDOuEJzHZc3RUD7VEoWUFwOrjDkVduqLVj8w8EZKomzOKieLWU2216vmxk4Fl3mCKQZnsVqhiehdVH7741JshdOXf/vxbkJd8WO43SFcDEDvnKpvHK7Yyeecf6YT27tlRt0Bmef/N+MzG7a1LrKlo9yGiDtpAaVfKZaRI0sON8s1pFvEWQ
 fU7+DMzA
 CPsjrJXRxcdkkqROoFk7ND2c0vu6K7TG6VM7BFvGFT0MdcCGbozCJvSuCn8+Ch9xM6YULMV/R7+7Z0+eejbzzc8/pvjWK2y7C1aU8jTudPF6L419TuKIxKvmwShKtg8WI/B5RYwGrT0MRz/dfrxhrpyZnm6Bm8GlbCDL1FQK4kvJSMUpF3OoTd2LSNBhSgXTJccvwjaHOVona7w/UiM79E4KyF6VKSpb/m58zktA9iQ978P2FJS//6BkRCinfatnhTHO4urWdGMV3j6xSbzfDkyLqzci/nHCG2mMW/RwQndRfFJfyPPdTnJYBejD+0E0PSDesJ+5vRbKcKwM2z6S2pa+SpVUW7RQpjes1
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
zram and zswap to struct zs_handle pointers.

This is a preparation for the next patches, which embed struct
zs_handle into zram and zswap entries.  No functional change.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 28 ++++++------
 drivers/block/zram/zram_drv.h |  2 +-
 include/linux/zsmalloc.h      | 13 +++---
 mm/zsmalloc.c                 | 83 +++++++++++++++++++----------------
 mm/zswap.c                    |  8 ++--
 5 files changed, 72 insertions(+), 62 deletions(-)

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
index 5b7298a5026b..693c9484b638 100644
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
+void zs_obj_read_sg_begin(struct zs_pool *pool, struct zs_handle *handle,
 			  struct scatterlist *sg, size_t mem_len);
-void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle);
-void zs_obj_write(struct zs_pool *pool, unsigned long handle,
+void zs_obj_read_sg_end(struct zs_pool *pool, struct zs_handle *handle);
+void zs_obj_write(struct zs_pool *pool, struct zs_handle *handle,
 		  void *handle_mem, size_t mem_len);
 
 extern const struct movable_operations zsmalloc_mops;
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 7ef80e0da626..7d8aab56f5cd 100644
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
@@ -817,13 +821,13 @@ static unsigned long location_to_obj(struct zpdesc *zpdesc, unsigned int obj_idx
 	return obj;
 }
 
-static unsigned long handle_to_obj(unsigned long handle)
+static unsigned long handle_to_obj(struct zs_handle *handle)
 {
-	return READ_ONCE(*(unsigned long *)handle);
+	return READ_ONCE(ACCESS_PRIVATE(handle, obj));
 }
 
 static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
-				 unsigned long *phandle)
+				 struct zs_handle **phandle)
 {
 	unsigned long handle;
 	struct zspage *zspage = get_zspage(zpdesc);
@@ -839,7 +843,7 @@ static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
 		return false;
 
 	/* Clear all tags before returning the handle */
-	*phandle = handle & ~OBJ_TAG_MASK;
+	*phandle = (struct zs_handle *)(handle & ~OBJ_TAG_MASK);
 	return true;
 }
 
@@ -1122,7 +1126,7 @@ unsigned long zs_get_total_pages(struct zs_pool *pool)
 }
 EXPORT_SYMBOL_GPL(zs_get_total_pages);
 
-void zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
+void zs_obj_read_sg_begin(struct zs_pool *pool, struct zs_handle *handle,
 			  struct scatterlist *sg, size_t mem_len)
 {
 	struct zspage *zspage;
@@ -1169,7 +1173,7 @@ void zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
 }
 EXPORT_SYMBOL_GPL(zs_obj_read_sg_begin);
 
-void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle)
+void zs_obj_read_sg_end(struct zs_pool *pool, struct zs_handle *handle)
 {
 	struct zspage *zspage;
 	struct zpdesc *zpdesc;
@@ -1184,7 +1188,7 @@ void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle)
 }
 EXPORT_SYMBOL_GPL(zs_obj_read_sg_end);
 
-void zs_obj_write(struct zs_pool *pool, unsigned long handle,
+void zs_obj_write(struct zs_pool *pool, struct zs_handle *handle,
 		  void *handle_mem, size_t mem_len)
 {
 	struct zspage *zspage;
@@ -1253,7 +1257,7 @@ size_t zs_huge_class_size(struct zs_pool *pool)
 EXPORT_SYMBOL_GPL(zs_huge_class_size);
 
 static unsigned long obj_malloc(struct zs_pool *pool,
-				struct zspage *zspage, unsigned long handle)
+				struct zspage *zspage, struct zs_handle *handle)
 {
 	int i, nr_zpdesc, offset;
 	unsigned long obj;
@@ -1280,9 +1284,10 @@ static unsigned long obj_malloc(struct zs_pool *pool,
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
@@ -1305,23 +1310,23 @@ static unsigned long obj_malloc(struct zs_pool *pool,
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
 
@@ -1342,7 +1347,7 @@ unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp,
 	zspage = alloc_zspage(pool, class, gfp, nid);
 	if (!zspage) {
 		cache_free_handle(handle);
-		return (unsigned long)ERR_PTR(-ENOMEM);
+		return ERR_PTR(-ENOMEM);
 	}
 
 	spin_lock(&class->lock);
@@ -1410,9 +1415,11 @@ static unsigned int obj_to_class_idx(unsigned long obj)
  * encoding is disabled), fall back to pool->lock for the lookup.
  */
 #if ZS_OBJ_CLASS_BITS > 0
-static inline void obj_class_get_and_lock(struct zs_pool *pool, unsigned long handle,
-					 unsigned long *objp, struct zspage **zspagep,
-					 struct size_class **classp)
+static inline void obj_class_get_and_lock(struct zs_pool *pool,
+					  struct zs_handle *handle,
+					  unsigned long *objp,
+					  struct zspage **zspagep,
+					  struct size_class **classp)
 	__acquires(&(*classp)->lock)
 {
 	struct zpdesc *f_zpdesc;
@@ -1428,9 +1435,11 @@ static inline void obj_class_get_and_lock(struct zs_pool *pool, unsigned long ha
 	*objp = obj;
 }
 #else
-static inline void obj_class_get_and_lock(struct zs_pool *pool, unsigned long handle,
-					 unsigned long *objp, struct zspage **zspagep,
-					 struct size_class **classp)
+static inline void obj_class_get_and_lock(struct zs_pool *pool,
+					  struct zs_handle *handle,
+					  unsigned long *objp,
+					  struct zspage **zspagep,
+					  struct size_class **classp)
 	__acquires(&(*classp)->lock)
 {
 	struct zpdesc *f_zpdesc;
@@ -1447,7 +1456,7 @@ static inline void obj_class_get_and_lock(struct zs_pool *pool, unsigned long ha
 }
 #endif
 
-void zs_free(struct zs_pool *pool, unsigned long handle)
+void zs_free(struct zs_pool *pool, struct zs_handle *handle)
 {
 	struct zspage *zspage;
 	unsigned long obj;
@@ -1455,7 +1464,7 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 	int fullness;
 	struct zspage *zspage_to_free = NULL;
 
-	if (IS_ERR_OR_NULL((void *)handle))
+	if (IS_ERR_OR_NULL(handle))
 		return;
 
 	obj_class_get_and_lock(pool, handle, &obj, &zspage, &class);
@@ -1559,12 +1568,12 @@ static void zs_object_copy(struct size_class *class, unsigned long dst,
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
@@ -1589,7 +1598,7 @@ static void migrate_zspage(struct zs_pool *pool, struct zspage *src_zspage,
 			   struct zspage *dst_zspage)
 {
 	unsigned long used_obj, free_obj;
-	unsigned long handle;
+	struct zs_handle *handle;
 	int obj_idx = 0;
 	struct zpdesc *s_zpdesc = get_first_zpdesc(src_zspage);
 	struct size_class *class = pool->size_class[src_zspage->class];
@@ -1760,7 +1769,7 @@ static int zs_page_migrate(struct page *newpage, struct page *page,
 	struct zpdesc *zpdesc = page_zpdesc(page);
 	void *s_addr, *d_addr, *addr;
 	unsigned int offset;
-	unsigned long handle;
+	struct zs_handle *handle;
 	unsigned long old_obj, new_obj;
 	unsigned int obj_idx;
 
@@ -2291,7 +2300,7 @@ static void zs_destroy_caches(void)
 
 static int __init zs_init_caches(void)
 {
-	handle_cachep = kmem_cache_create("zs_handle", ZS_HANDLE_SIZE,
+	handle_cachep = kmem_cache_create("zs_handle", sizeof(struct zs_handle),
 					  0, 0, NULL);
 	zspage_cachep = kmem_cache_create("zspage", sizeof(struct zspage),
 					  0, 0, NULL);
diff --git a/mm/zswap.c b/mm/zswap.c
index ad01c691a263..397b06c9f33b 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -215,7 +215,7 @@ struct zswap_entry {
 	unsigned int length;
 	bool referenced;
 	u8 pool_idx;
-	unsigned long handle;
+	struct zs_handle *handle;
 	struct obj_cgroup *objcg;
 	struct list_head lru;
 };
@@ -888,7 +888,7 @@ static bool zswap_compress(struct folio *folio, long index,
 	struct scatterlist input, output;
 	int comp_ret = 0, alloc_ret = 0;
 	unsigned int dlen = PAGE_SIZE;
-	unsigned long handle;
+	struct zs_handle *handle;
 	gfp_t gfp;
 	u8 *dst;
 	bool mapped = false;
@@ -949,8 +949,8 @@ static bool zswap_compress(struct folio *folio, long index,
 
 	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
 	handle = zs_malloc(pool->zs_pool, dlen, gfp, folio_nid(folio));
-	if (IS_ERR_VALUE(handle)) {
-		alloc_ret = PTR_ERR((void *)handle);
+	if (IS_ERR(handle)) {
+		alloc_ret = PTR_ERR(handle);
 		goto unlock;
 	}
 
-- 
2.56.0.398.g882cbad275-goog


