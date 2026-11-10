Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 174D960A2609
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=BTREeddx
Received: by kanga.kvack.org (Postfix)
	id 8DA576B05C2; Tue, 10 Nov 2026 00:49:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86B016B05C3; Tue, 10 Nov 2026 00:49:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68F396B05C4; Tue, 10 Nov 2026 00:49:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 324266B05C2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:49:18 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B48F5408CF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:49:17 +0000 (UTC)
X-FDA: 85418131554.13.AB86E74
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf05.hostedemail.com (Postfix) with ESMTP id D8AF5100008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:49:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=BTREeddx;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf05.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794289756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YCSQzGAMUPcdpnnuOgggDzx++ldY+CPnHPReM+DbQnM=;
	b=5ECs4TaWJInm7u08fVLTthyryS8l/6IHJUjnZDADO6k9UvrJaUeu54aIJG42zzKrelyUGq
	CprMakcTd+4tF15picHwCDkMNRXw4V5eQsBRWHOHC9HMJnPU+hqgQvnK6oEflw1EsvRVmC
	k7A8HlSx6M1OdjoYMPRenkNyzlft190=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=BTREeddx;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf05.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794289756;
	b=4hmyVF7iMpfBzz+p+Ac/+Kx/kpn4zoNwhm66iFdkwAYjmw1Ek2eMdCMi+X7aRmjzvjII/W
	cqgyzr4IckSno7JgM3eudVhX5FKoQQn9HY7cF8npNxFf//4p1c9L5HTA7VroT8M2VpVwek
	+jEAKbvsP106HAqlS3G9pl/PXtGAM6c=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8b6b22be970so596203b3a.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794289755; x=1794894555; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YCSQzGAMUPcdpnnuOgggDzx++ldY+CPnHPReM+DbQnM=;
        b=BTREeddxhsuGtuaN71vUnklDzu2xYFte+Ck9oQN8NME78kkXO7aBdYK7EOgli7S5dk
         xUf6voUpwlXvuzsJIdleryWz6zfnxRNmc9oydQ6ByvFUxqos9K304I/vT/1Ba8dktLyv
         9KPbrZ56fNUNUidvdmDgtSsHa2y1mwypwm6f0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794289755; x=1794894555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YCSQzGAMUPcdpnnuOgggDzx++ldY+CPnHPReM+DbQnM=;
        b=VW+UZqRyYDTx5/5OsXscOqgFuh3VXU4NWi1GE8CIwNqATJUsFbo3dHmFHD/V85zAJW
         CG8PbqNazqKBorx7jrBpj0wkJCm4XrAfpUpaeFtuyD95luM4T3LoAypPzbF88n1b7ZOd
         IFMmKPZPyTIr45QvzIKrNXmI7zpmefBG340SqZSXVciNaMWgjCK+gxlbbPZVp7/E+Cs8
         pQL7myrif4epA4aITqgDGgnKOmVlTSuS3yHGakHqvLSnk/AI8XrXdDM/E2nufKrfSawr
         caVIQ7gXSCpIdBYVi2V4ZCuqMGvM7GPLtJLdGC3hP62C9jGPaSzDp6AEGWmZV43Gvz3t
         UVwg==
X-Forwarded-Encrypted: i=1; AL+hErEqIxXLjJ1dabeelXYqq0sUVLcyrpMT+sTwTbdvkbjRQ7cxgBBJfuDmcVnpPW+YCy3QDFMtqpi4/A==@kvack.org
X-Gm-Message-State: APuU4Z+jwzLyMH61xmUnSTJ8fpHRX7O7+4uu1JrBU4yZ0fR+SSsWw2Hl
	b3uKRfTg5rmB8FUhbJOhGzWiZ7/NXjm0k27jYDwObAjqQIZVY5561SFzcQDna4yl8w==
X-Gm-Gg: AYBFou1Gi+fpjp4cnsYfUxCkDEImcuQGyd/lE3YBCLoB9Wl7uKk3/xUbpsL/mGW+orI
	bXrn4gLxTdN2vO2FViPj+wJXAlh026U2Zt0iND5yPfQzEK1bGl1cBisC+aH36my/LYPOS7Wf8gG
	lwjTf8lK94/F6zS/de0TuAcY5e2E4TLoQTnFj2rxXiU+w1u37CqqrrjpZzRDGa+/CUzSfaC3MWf
	5qolA+CnqRfsrE1iIKGGkB4urjJnfW4Cl6UuouGDstyPCR0s6nWr86XXZDdKeyIov5RMc8fhbnQ
	6CVLyIfO4U9wQKsInMLJWy0odswxW8u/0glQWc9OqP06pGo40idiXkqjlZkQRxYvUAVwQayrtKB
	yYSi2Je1w4LkdNLeppbIurhay7Nk2LwVxR+GgkTa7aRYeMzfIcApox3UYMu77MyibFK/jBw72QO
	HQl25pmSDMKtUHjziME9xylVF/BLbr3PlmTCyrY7RMlCn4LI7Nyyley+58wJ1ZvMV+fEpJU/40z
	VPuy8fFd1ALC/3WPAyTPnxMK6qhmo/i4MDMLiYVyEX9AouyJ7SZnxz+dFQ2YxTt2zIHi3apWG5h
	lhpi1EUPI9Wd/x1dNu1Oyfww6GBQbXzB+AaByI7+cYnKyWZDNlyrgpp7YxHxv1A5yxLx3ZfT2Hy
	jM3v2lxszA/8jcAORhw==
X-Received: by 2002:a05:6300:49c:b0:3de:71c4:a228 with SMTP id adf61e73a8af0-3f18f4acd21mr1304920637.15.1794289754509;
        Mon, 09 Nov 2026 21:49:14 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:e137:9384:7cd8:6e40])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdd8d67e53asm444634a12.5.2026.11.09.21.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 21:49:13 -0800 (PST)
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
Subject: [PATCH v2 10/11] zsmalloc: fold zs_obj_write() into zs_store()
Date: Tue, 10 Nov 2026 14:48:15 +0900
Message-ID: <20261110054836.1515030-11-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
In-Reply-To: <20261110054836.1515030-1-senozhatsky@chromium.org>
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D8AF5100008
X-Stat-Signature: 8isdgwxsgh9map13sr8rersziaaez5oo
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794289755-935245
X-HE-Meta: U2FsdGVkX19rSZ5678RM7SZsfASIRjy7so+QGLIbz5PYtucIGVy7TBY7dLL+8vxvn+81IdPNv8Ih4Q05Jb30VtfWllw/+U6Cj+YXvzYp/wcvuGZCttDKbnVVY4T5oUNve3I7OKZxqCG4FofbHd9CeNougD7OEWb4klkq6gF2Vc3D9I6E51zK7a0ydPT58NNF2tLH4n+9VgghsYbSw7UG275+Xb/VzLQvuGGD9PJxWgTU8grfxD6Tpr/NXWq6/8zQwXpi40J6WTRe9rdbdNiAgqDARwsF7q5OTKNOmqo+2Y0t3SOUFfCYw0g2lyl0Lxx8b71Bc0bm0T/31vqQM+ACmNEo/J+zUyVHJN8+LDHfIwZm1HdLr1A6fs6E8us86sNsXMIEvWTGW4gebsawwL2FU9xTJqpo15f9MICTy7RypagriF+EFQeBBcEZe+SC2u7nIrsAgtRMkwNzdWzkDNgXnJ+WinhanbtxMAeoFZphsmkDGS1B7R7u1khLvcOcHpDmcl6EobYPBhwfDSczkMzLCtsPFC0LEX6XJIynRcNL1BIUE/bF1w6pLtwXcAoqxBnf0TX3RuyYcakTk/94eelmucyCGUcIyZPDncLUAw7UZIDAg6EqEJlrINFUlyRVi2P7l+wMUWaqpeMNt8vU1C9Cpl5ctpXW6dYYjrO05FiMlM7Wuw57ZahzaIjUTRfS3pSvBiyuY1nBr01r7baKmkvfcW1ZDEe0PENxCnF4fmCiIxhFXIkCtBjI8ZrH6DwIbC74/++jWsdibsJtYR4uzUOAnwDoVwqFPewa3jUrORDUHyY4uMliNKdylwjpUEYYWGq3xnhNvZ50HD+M2sNhWhq/xuiUvxaWRwpPgjlqijpJbafNYcb7E1FKGONVuut8XyN3YTfiAkx+/qPCryUGXwkFvFe0lfl6yOzGl3OyRsrt+CCYl9ZX91XrrpbukS7/KKYjuU/Do2oO9Y4UvCeTAFg
 AZZuAZa/
 KJCf7BiWTgj9FGWk8hDfZ7eqjBFHzv20rD+oqzbUU0jTspf/ZCPSzSqh8lTIMW1/3jylCeAe/ii7B81pVRZWYWCfyuLy7hyJnLzz1wHWMRd3tGPoVaPm/dz0uW51pYDqqVEWDYC4/nXD2193L2ypaa3oV/Yv3mE2BulW3pdK4UQFDm5uJTQ+XGUGyzZPW7YkPLb58ws8hZoISedKL45T6MNBHC+vmzQAZFyD3Ppt0t0ONru60hCEtsOlP6EuBVqeRtujq9raXH54f864ibCsMazY+Cnomr5FbwXDkJEF7GZfBM43ZOnPxsXgj/vODjJ6BG4dopXixVZMnbU5XvnehH9JU1WfF0mjR0daNaxxNgXQHrZE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zram and zswap always call zs_obj_write() right after zs_malloc(), and
zs_obj_write() has to take pool->lock and look up object location
again, which zs_malloc() just did.

Replace zs_malloc() and zs_obj_write() with one single zs_store()
call.

zs_store() takes zspage read lock under class->lock, before it drops
class->lock to copy the data, while zs_obj_write() used to take it
under pool->lock.  Compaction and page migration already take zspage
lock under class->lock, so this follows the existing pool->lock ->
class->lock -> zspage->lock order.  We don't need pool->lock there,
zs_store() doesn't look up the object via the handle, it already has
the zspage from the allocation.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 Documentation/core-api/memory-allocation.rst |  2 +-
 Documentation/mm/zsmalloc.rst                |  4 +-
 drivers/block/zram/zram_drv.c                | 42 +++++---------
 include/linux/zsmalloc.h                     |  6 +-
 mm/zsmalloc.c                                | 58 +++++++++-----------
 mm/zswap.c                                   |  5 +-
 6 files changed, 47 insertions(+), 70 deletions(-)

diff --git a/Documentation/core-api/memory-allocation.rst b/Documentation/core-api/memory-allocation.rst
index 648222b6c857..5069ac72b857 100644
--- a/Documentation/core-api/memory-allocation.rst
+++ b/Documentation/core-api/memory-allocation.rst
@@ -9,7 +9,7 @@ allocate small chunks using `kmalloc` or `kmem_cache_alloc` families,
 large virtually contiguous areas using `vmalloc` and its derivatives,
 or you can directly request pages from the page allocator with
 `alloc_pages`. It is also possible to use more specialized allocators,
-for instance `cma_alloc` or `zs_malloc`.
+for instance `cma_alloc` or `zs_store`.
 
 Most of the memory allocation APIs use GFP flags to express how that
 memory should be allocated. The GFP acronym stands for "get free
diff --git a/Documentation/mm/zsmalloc.rst b/Documentation/mm/zsmalloc.rst
index d6b21a0c0694..034daae0d37e 100644
--- a/Documentation/mm/zsmalloc.rst
+++ b/Documentation/mm/zsmalloc.rst
@@ -20,9 +20,9 @@ For simplicity, zsmalloc can only allocate objects of size up to PAGE_SIZE
 since this satisfies the requirements of all its current users (in the
 worst case, page is incompressible and is thus stored "as-is" i.e. in
 uncompressed form). For allocation requests larger than this size, failure
-is returned (see zs_malloc).
+is returned (see zs_store).
 
-Additionally, zs_malloc() does not return a pointer; instead, it returns 0
+Additionally, zs_store() does not return a pointer; instead, it returns 0
 (or a negative error code) and stores the encoded location of the allocated
 object in the caller-provided ``struct zs_handle``. The reason for this
 indirection is that zsmalloc does not keep zspages permanently mapped since
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 7c3d04d9c5bc..42852a4116e0 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2261,9 +2261,11 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 
 	slot_lock(zram, index);
 	slot_free(zram, index);
-	ret = zs_malloc(zram->mem_pool, &zram->table[index].handle, PAGE_SIZE,
-			GFP_NOIO | __GFP_NOWARN |
-			__GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
+	src = kmap_local_page(page);
+	ret = zs_store(zram->mem_pool, &zram->table[index].handle, src,
+		       PAGE_SIZE, GFP_NOIO | __GFP_NOWARN |
+		       __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
+	kunmap_local(src);
 	if (ret) {
 		slot_unlock(zram, index);
 		return ret;
@@ -2271,11 +2273,6 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 
 	update_used_max(zram);
 
-	src = kmap_local_page(page);
-	zs_obj_write(zram->mem_pool, &zram->table[index].handle, src,
-		     PAGE_SIZE);
-	kunmap_local(src);
-
 	set_slot_flag(zram, index, ZRAM_HUGE);
 	set_slot_size(zram, index, PAGE_SIZE);
 	mark_slot_accessed(zram, index);
@@ -2327,21 +2324,18 @@ static int zram_write_page(struct zram *zram, struct page *page,
 
 	slot_lock(zram, index);
 	slot_free(zram, index);
-	ret = zs_malloc(zram->mem_pool, &zram->table[index].handle, comp_len,
-			GFP_NOIO | __GFP_NOWARN |
-			__GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
+	ret = zs_store(zram->mem_pool, &zram->table[index].handle,
+		       zstrm->buffer, comp_len,
+		       GFP_NOIO | __GFP_NOWARN |
+		       __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
+	zcomp_cstrm_put(zstrm);
 	if (ret) {
-		zcomp_cstrm_put(zstrm);
 		slot_unlock(zram, index);
 		return ret;
 	}
 
 	update_used_max(zram);
 
-	zs_obj_write(zram->mem_pool, &zram->table[index].handle, zstrm->buffer,
-		     comp_len);
-	zcomp_cstrm_put(zstrm);
-
 	set_slot_size(zram, index, comp_len);
 	mark_slot_accessed(zram, index);
 	slot_unlock(zram, index);
@@ -2526,18 +2520,12 @@ static int recompress_slot(struct zram *zram, unsigned long index,
 	 * modify zsmalloc API to return this information. For now, we will
 	 * make do with the node of the page allocated for recompression.
 	 */
-	ret = zs_malloc(zram->mem_pool, &zram->recomp_handle, comp_len_new,
-			GFP_NOIO | __GFP_NOWARN |
-			__GFP_HIGHMEM | __GFP_MOVABLE,
-			page_to_nid(page));
-	if (ret) {
-		zcomp_cstrm_put(zstrm);
-		return ret;
-	}
-
-	zs_obj_write(zram->mem_pool, &zram->recomp_handle, zstrm->buffer,
-		     comp_len_new);
+	ret = zs_store(zram->mem_pool, &zram->recomp_handle, zstrm->buffer,
+		       comp_len_new, GFP_NOIO | __GFP_NOWARN |
+		       __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
 	zcomp_cstrm_put(zstrm);
+	if (ret)
+		return ret;
 
 	slot_free(zram, index);
 	zs_rebind_handle(zram->mem_pool, &zram->table[index].handle,
diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 8273ae924153..8971eef333ba 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -49,8 +49,8 @@ struct scatterlist;
 struct zs_pool *zs_create_pool(const char *name);
 void zs_destroy_pool(struct zs_pool *pool);
 
-int zs_malloc(struct zs_pool *pool, struct zs_handle *handle, size_t size,
-	      gfp_t flags, const int nid);
+int zs_store(struct zs_pool *pool, struct zs_handle *handle, const void *src,
+	     size_t size, gfp_t flags, const int nid);
 void zs_free(struct zs_pool *pool, struct zs_handle *handle);
 void zs_rebind_handle(struct zs_pool *pool, struct zs_handle *dst,
 		      struct zs_handle *src);
@@ -67,8 +67,6 @@ void zs_pool_stats(struct zs_pool *pool, struct zs_pool_stats *stats);
 void zs_obj_read_sg_begin(struct zs_pool *pool, const struct zs_handle *handle,
 			  struct scatterlist *sg, size_t mem_len);
 void zs_obj_read_sg_end(struct zs_pool *pool, const struct zs_handle *handle);
-void zs_obj_write(struct zs_pool *pool, const struct zs_handle *handle,
-		  void *handle_mem, size_t mem_len);
 
 extern const struct movable_operations zsmalloc_mops;
 
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index fd466139e158..09ce8c294c5e 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1178,54 +1178,37 @@ void zs_obj_read_sg_end(struct zs_pool *pool, const struct zs_handle *handle)
 }
 EXPORT_SYMBOL_GPL(zs_obj_read_sg_end);
 
-void zs_obj_write(struct zs_pool *pool, const struct zs_handle *handle,
-		  void *handle_mem, size_t mem_len)
+static void obj_write(struct size_class *class, struct zspage *zspage,
+		      unsigned long obj, const void *src, size_t size)
 {
-	struct zspage *zspage;
 	struct zpdesc *zpdesc;
-	unsigned long obj, off;
+	unsigned long off;
 	unsigned int obj_idx;
-	struct size_class *class;
 
-	/* Guarantee we can get zspage from handle safely */
-	read_lock(&pool->lock);
-	obj = handle_to_obj(handle);
 	obj_to_location(obj, &zpdesc, &obj_idx);
-	zspage = get_zspage(zpdesc);
-
-	/* Make sure migration doesn't move any pages in this zspage */
-	zspage_read_lock(zspage);
-	read_unlock(&pool->lock);
-
-	class = zspage_class(pool, zspage);
 	off = offset_in_page(class->size * obj_idx);
 
 	if (!ZsHugePage(zspage))
 		off += ZS_HANDLE_SIZE;
 
-	if (off + mem_len <= PAGE_SIZE) {
+	if (off + size <= PAGE_SIZE) {
 		/* this object is contained entirely within a page */
 		void *dst = kmap_local_zpdesc(zpdesc);
 
-		memcpy(dst + off, handle_mem, mem_len);
+		memcpy(dst + off, src, size);
 		kunmap_local(dst);
 	} else {
 		/* this object spans two pages */
 		size_t sizes[2];
 
 		sizes[0] = PAGE_SIZE - off;
-		sizes[1] = mem_len - sizes[0];
+		sizes[1] = size - sizes[0];
 
-		memcpy_to_page(zpdesc_page(zpdesc), off,
-			       handle_mem, sizes[0]);
+		memcpy_to_page(zpdesc_page(zpdesc), off, src, sizes[0]);
 		zpdesc = get_next_zpdesc(zpdesc);
-		memcpy_to_page(zpdesc_page(zpdesc), 0,
-			       handle_mem + sizes[0], sizes[1]);
+		memcpy_to_page(zpdesc_page(zpdesc), 0, src + sizes[0], sizes[1]);
 	}
-
-	zspage_read_unlock(zspage);
 }
-EXPORT_SYMBOL_GPL(zs_obj_write);
 
 /**
  * zs_huge_class_size() - Returns the size (in bytes) of the first huge
@@ -1290,9 +1273,10 @@ static unsigned long obj_malloc(struct zs_pool *pool,
 
 
 /**
- * zs_malloc - Allocate block of given size from pool.
+ * zs_store() - Allocate block of given size from pool and copy data into it.
  * @pool: pool to allocate from
  * @handle: handle to store allocated object in
+ * @src: data to copy into the allocated object
  * @size: size of block to allocate
  * @gfp: gfp flags when allocating object
  * @nid: The preferred node id to allocate new zspage (if needed)
@@ -1305,10 +1289,11 @@ static unsigned long obj_malloc(struct zs_pool *pool,
  *
  * Return: 0 on success, negative error code otherwise.
  */
-int zs_malloc(struct zs_pool *pool, struct zs_handle *handle, size_t size,
-	      gfp_t gfp, const int nid)
+int zs_store(struct zs_pool *pool, struct zs_handle *handle, const void *src,
+	     size_t size, gfp_t gfp, const int nid)
 {
 	struct size_class *class;
+	unsigned long obj;
 	int newfg;
 	struct zspage *zspage;
 
@@ -1330,7 +1315,7 @@ int zs_malloc(struct zs_pool *pool, struct zs_handle *handle, size_t size,
 	spin_lock(&class->lock);
 	zspage = find_get_zspage(class);
 	if (likely(zspage)) {
-		obj_malloc(pool, zspage, handle);
+		obj = obj_malloc(pool, zspage, handle);
 		/* Now move the zspage to another fullness group, if required */
 		fix_fullness_group(class, zspage);
 		class_stat_add(class, ZS_OBJS_INUSE, 1);
@@ -1345,7 +1330,7 @@ int zs_malloc(struct zs_pool *pool, struct zs_handle *handle, size_t size,
 		return -ENOMEM;
 
 	spin_lock(&class->lock);
-	obj_malloc(pool, zspage, handle);
+	obj = obj_malloc(pool, zspage, handle);
 	newfg = get_fullness_group(class, zspage);
 	insert_zspage(class, zspage, newfg);
 	atomic_long_add(class->pages_per_zspage, &pool->pages_allocated);
@@ -1355,11 +1340,15 @@ int zs_malloc(struct zs_pool *pool, struct zs_handle *handle, size_t size,
 	/* We completely set up zspage so mark them as movable */
 	SetZsPageMovable(pool, zspage);
 out:
+	zspage_read_lock(zspage);
 	spin_unlock(&class->lock);
 
+	obj_write(class, zspage, obj, src, size);
+	zspage_read_unlock(zspage);
+
 	return 0;
 }
-EXPORT_SYMBOL_GPL(zs_malloc);
+EXPORT_SYMBOL_GPL(zs_store);
 
 static void obj_free(int class_size, unsigned long obj)
 {
@@ -1844,7 +1833,10 @@ static int zs_page_migrate(struct page *newpage, struct page *page,
 	 * the class lock protects zpage alloc/free in the zspage.
 	 */
 	spin_lock(&class->lock);
-	/* the zspage write_lock protects zpage access via zs_obj_read/write() */
+	/*
+	 * The zspage write_lock protects zpage access via zs_obj_read_sg_*()
+	 * and zs_store().
+	 */
 	if (!zspage_write_trylock(zspage)) {
 		spin_unlock(&class->lock);
 		write_unlock(&pool->lock);
@@ -2238,7 +2230,7 @@ struct zs_pool *zs_create_pool(const char *name)
 			huge_class_size = size;
 			/*
 			 * The object uses ZS_HANDLE_SIZE bytes to store the
-			 * handle. We need to subtract it, because zs_malloc()
+			 * handle. We need to subtract it, because zs_store()
 			 * unconditionally adds handle size before it performs
 			 * size class search - so object may be smaller than
 			 * huge class size, yet it still can end up in the huge
diff --git a/mm/zswap.c b/mm/zswap.c
index 241f9fdebaad..a2e0314db1cf 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -950,12 +950,11 @@ static bool zswap_compress(struct folio *folio, long index,
 	}
 
 	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
-	alloc_ret = zs_malloc(pool->zs_pool, &entry->handle, dlen, gfp,
-			      folio_nid(folio));
+	alloc_ret = zs_store(pool->zs_pool, &entry->handle, dst, dlen, gfp,
+			     folio_nid(folio));
 	if (alloc_ret)
 		goto unlock;
 
-	zs_obj_write(pool->zs_pool, &entry->handle, dst, dlen);
 	entry->length = dlen;
 
 unlock:
-- 
2.56.0.506.g506a7eabc5-goog


