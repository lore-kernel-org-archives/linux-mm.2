Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8773B606D804
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=E15LN4Y+
Received: by kanga.kvack.org (Postfix)
	id 319F86B05C1; Wed,  4 Nov 2026 23:48:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CDF76B05C2; Wed,  4 Nov 2026 23:48:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E04B6B05C4; Wed,  4 Nov 2026 23:48:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E43316B05C1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:48:20 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7842816093F
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:48:20 +0000 (UTC)
X-FDA: 85399833960.26.2550876
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id AAFFC100002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:48:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=E15LN4Y+;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793854098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8nPV4Na2r4fuMLpiAdFjk8iBGsrOdFxnXJMgNy6oG6E=;
	b=BhIf+VMEdCcct8FT9sotH2OLlThZhBlwMiD4fuaLIGK6ykmiJqzk13zKCNz3cUvFNxYfVO
	TPSzq5Q5fJP60vkZQ9M+e7YmF0gZHdYs9i+1OXBkGosH8Eo7CZBC94qGLr8kSkvaBdlKhY
	4RUqF7+eHEfKKNJY/dfigivRgstxSuo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793854098;
	b=feT6wUd0gV2qFBu/eM9BE0dpqEdpXDv5eDuHoPSQhaCqzUZJ7BfIMkOM9OVCL/lVAFQCUi
	pythc8uAgaGzYD846FqSMZS3FVnDhfEzQXDpMZYg5VYm+UAvhav/SXRcq10dey4Kkq686K
	YtBzBh/sWeMUw6vIB13YHHohbsQ6tUg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=E15LN4Y+;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-36cedf1bd63so334512eec.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 20:48:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1793854097; x=1794458897; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8nPV4Na2r4fuMLpiAdFjk8iBGsrOdFxnXJMgNy6oG6E=;
        b=E15LN4Y+4zgL0jfVmycR4JVQdO8TZo/zrvtH1rdb5c66YPLQQG3gP7eqmHgSQeoN/3
         0OO6LisuXPfD9k+BsDBJ1BIrdwUHJ4b4ODgvTojUqGbFD4hok5XH0xxk8rbjEWk0eiBE
         2cZR6UGXFbxQ+CH4zV8/I4PFb7VKMdlAQoggM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793854097; x=1794458897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8nPV4Na2r4fuMLpiAdFjk8iBGsrOdFxnXJMgNy6oG6E=;
        b=HeMmQnRCz6SIr6o5JLdE+Wf3rU++2Fe1JxnBhZ2nFu+JyhG3/MXSM8WCTxShCQ8Jo5
         EiWX4XSae9ZmvBqV/suQaPqBwG+3SHO0umTOz1M3ZpObzeFp1Bfms5GNy6KnGm7FI1sd
         TgF/6e1oo3wj5dpSUELGvgA2oAyJAMl7LN/u5neEniqnZ2ztbvhguraFWcR6eSNJ3ckM
         QPZXgy6jNk+A/sRDGoiS97lgcWKkVtxkMdE+U+V/W3ru1e1fV8JGDHy2lV5YSZU8ZF9K
         MJ+z2gyqBTZHCooz1xbZ14fyjMATO0H/pkBokOBqpAZ+MqQ/xj0kwzYxdArGGgJgVWKl
         sctg==
X-Forwarded-Encrypted: i=1; AKwUvBxecDInGYFxzZWks2AAAW4KQSmnZuFangfnd3woD1s8DFuLXdi+6iHi+154mwigBbJUHEApjum5Zg==@kvack.org
X-Gm-Message-State: APuU4Z+eMQA7xkE+/qU/qJSUDFDfxMJyhOuaFgwdMVLJQS7Ugz3SIv0M
	BRaezmCK5bbT9f1xX2ypPmKLiyaoTBsU2fYVH8CLh5Wk2RDDt3te15/6TTHHrl5Bnw==
X-Gm-Gg: AYBFou2GDh2gkEPTwkjjYoUNqFtFliz6L9vnI5GN1NEVKYVMY15g6J1rP/I6oO/QOYM
	8if0yh2wrbOneXEywCCgOFUynb0CwqL/D7MpjQDmB6pELwt0ebFkAoRo70/HOry/EkO8hzJ1VGu
	8PX0bIWqYx5M5c71Vt0uG0uLIyh81F3AO+dIOuG2TZZm0z9amAgVN2t0hPPkm1LHCvWrNP1+omB
	zgUJ9Ej7Oub8e/6OiZ6PSN8Nojpx7ZSXSvDwHtJ2nDdA1AILVE+lPTyVbtPWZLd473AvsLmt9vL
	YJfGtvpgjBm1gO4rMOrO6gbnjwWMtvw/0+hsZgndo1c0TOvYZNZ+Fr/Iml3MinxnCQrSDExKliy
	86/odG8WNWekNUaaIkLIs+8S1RHEmK/fF9w9R+L3tIGSuCTsP5jooSDZshmonQ0i1G4VE71dRc6
	dPzkRSDvacx0ZIcYV/aIjGPdmCjlWD2Pk3mBrj1PDGYEwmKCEiHN4gNAeBEH9Azd5rrb1hxlBXN
	LP8XDEkI5Otq9QXS4bMsr2MsJHjFH+3wq0rHVLEAS+wcsgparyl4EHd/aYJckUEKkUwumzV0HcL
	c3pR7CUqgYfF1fZnwUegKfRmt88ng13vpEIUk7u+zvsRK6DdX0SXQF1YNltd5SBezgJQCEmEhdi
	irQuHd/SAmlkoCInvgQ==
X-Received: by 2002:a05:701b:4591:20b0:1a7:77ae:11f6 with SMTP id a92af1059eb24-1b24f45f23dmr2037579c88.17.1793854097305;
        Wed, 04 Nov 2026 20:48:17 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:37bc:b763:7ec7:65b4])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm17142927c88.21.2026.11.04.20.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 20:48:16 -0800 (PST)
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
Subject: [PATCH 6/7] zsmalloc: fold zs_obj_write() into zs_store()
Date: Thu,  5 Nov 2026 13:47:36 +0900
Message-ID: <20261105044752.1997895-7-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.398.g882cbad275-goog
In-Reply-To: <20261105044752.1997895-1-senozhatsky@chromium.org>
References: <20261105044752.1997895-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: me9pcq7dybjff946f5npgrxqgzb1ct9d
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: AAFFC100002
X-Rspam-User: 
X-HE-Tag: 1793854098-453229
X-HE-Meta: U2FsdGVkX18o3dVSFHyVwpek6fJcChwz55iVsyoEOtBXt8oNca4SegVW5TuGcl0QvspcMqbVAGlhjZU7Q6S//WZGY05yXtGUfEi8KGXfX+7swCnMeJusA93Rq6idZ3iEO0Gjnbu333tEhnA1msNz+1Yp5LNc/1fYhJuxCjsorfYn5d/IdTUUw21MFDifDy/4vyYIZcoV7C/foaJ9HZq7TwEnCo3H37UqgeUu2yvu3/b4F/Htypg1nbjljzf6U4DyhadYZUT8MUbg/B2zE+/myACqFCpvboQ7LtYCLqQXI/diDy5EKXVJfqcQfLZlK6envFTKDyl34HYawvTQ4I7mXodAtDgN3XUI9MDQ/Ei9VDrtRY/SfuB2zN8TKlmYU5toUq8c9w0jcHV5oZa8LuVQ3NCJBU/RBPf+AIC4z1c61UKiAtK6g5t6KIOE8wkU9TPHPCt0Zmg8KglDHYyQmhASAk5SBNOJcr7v/PjkRXJDx8bysaYzeJTjwvQXXuCwbFn0sX9INMA3qaMaeWA7CEpxJ0Xie9FUfvmqI/Vnom0h7Zhh7zfkh7f7JZGqsx+qLrfyrpLPWEGjOUuy+Cxe8kFB9VRFJUMkaOvL+2mBIqO2VEmptvIkHScXUzMQ4RcrHyOo6pov1A5iSv999BXX5LeHKZ13KxlCGz80qapkVxMTYPmCX7vZ+McTu4OU5L292T2iP0B7nr3proa4gUok9A9/X1F5IG0kejqbqBXkJnT43aYm/3sBlVHXarlzbULyoD/oslVLGScintIxtpxz8zGwoZESAAuEibh3s2g7HyZXyjIFmxXPn0Q9valKfx20mufT7I99V4/MlR3XtKJZhFEr0RuJIBcDWp6yIoTHMT98OXglZgZ77mYbSgedZX0QPxbwgoBE0CFAVjNqCq3cqjFI6PNWebRMkOD1M3mSziGCVu3XEmsl1eedzQFtGKNGbAuikINL5d1Wjz7iGUvK+Dl
 /dulJExa
 FTCKiUdYe/FKqqZ0uYvwgFKw414Ki9UnGscnIvfZvLIFDVnPFpvBy26NI5lNCGuSsoPOMzoWMaDzOHT6KOO1xFClPKz3/l4Qcg/KzA37gHoybiEJ7mNVQl/BHJYNpI839AhgCvYm3zJ5nHOjnNSR+tpJX11ESt7imPkUauJpqzvIcPen4daXTaJ+Ah+ju7ucxhWXbpE+2YRHRib4MM0XUcybgTWLWQZiQoYvdmlmzxMw7nAN8i1LcP0L8ohKW1zHxy7/kT8qKrhZ/n4HeV5Z6NLhorgU2y8ORChP5k/2QeZmzBtVIntN1PHc2ARnvTskPS3V7MYhGOhKXdqN2jP8/WKWmIBPJbA+Fj9Lt
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

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 Documentation/core-api/memory-allocation.rst |  2 +-
 Documentation/mm/zsmalloc.rst                |  4 +-
 drivers/block/zram/zram_drv.c                | 43 ++++++-----------
 include/linux/zsmalloc.h                     |  6 +--
 mm/zsmalloc.c                                | 51 +++++++++-----------
 mm/zswap.c                                   |  5 +-
 6 files changed, 46 insertions(+), 65 deletions(-)

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
index dbb5c1a8dcc3..52eaba8f97e9 100644
--- a/Documentation/mm/zsmalloc.rst
+++ b/Documentation/mm/zsmalloc.rst
@@ -20,9 +20,9 @@ For simplicity, zsmalloc can only allocate objects of size up to PAGE_SIZE
 since this satisfies the requirements of all its current users (in the
 worst case, page is incompressible and is thus stored "as-is" i.e. in
 uncompressed form). For allocation requests larger than this size, failure
-is returned (see zs_malloc).
+is returned (see zs_store).
 
-Additionally, zs_malloc() does not return a dereferenceable pointer.
+Additionally, zs_store() does not return a dereferenceable pointer.
 Instead, it stores the encoded location of the allocated object in the
 provided ``struct zs_handle``. The reason for this indirection is that
 zsmalloc does not keep zspages permanently mapped since that would cause
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 7c80db51b29a..223e4151fc9d 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2262,9 +2262,11 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 
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
@@ -2276,11 +2278,6 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 		return -ENOMEM;
 	}
 
-	src = kmap_local_page(page);
-	zs_obj_write(zram->mem_pool, &zram->table[index].handle, src,
-		     PAGE_SIZE);
-	kunmap_local(src);
-
 	set_slot_flag(zram, index, ZRAM_HUGE);
 	set_slot_size(zram, index, PAGE_SIZE);
 	mark_slot_accessed(zram, index);
@@ -2329,26 +2326,22 @@ static int zram_write_page(struct zram *zram, struct page *page,
 
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
 
 	if (!zram_can_store_page(zram)) {
-		zcomp_cstrm_put(zstrm);
 		zs_free(zram->mem_pool, &zram->table[index].handle);
 		slot_unlock(zram, index);
 		return -ENOMEM;
 	}
 
-	zs_obj_write(zram->mem_pool, &zram->table[index].handle, zstrm->buffer,
-		     comp_len);
-	zcomp_cstrm_put(zstrm);
-
 	set_slot_size(zram, index, comp_len);
 	mark_slot_accessed(zram, index);
 	slot_unlock(zram, index);
@@ -2533,18 +2526,12 @@ static int recompress_slot(struct zram *zram, unsigned long index,
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
index 6c76fd10344e..674358f39191 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -48,8 +48,8 @@ struct scatterlist;
 struct zs_pool *zs_create_pool(const char *name);
 void zs_destroy_pool(struct zs_pool *pool);
 
-int zs_malloc(struct zs_pool *pool, struct zs_handle *handle, size_t size,
-	      gfp_t flags, const int nid);
+int zs_store(struct zs_pool *pool, struct zs_handle *handle, const void *src,
+	     size_t size, gfp_t flags, const int nid);
 void zs_free(struct zs_pool *pool, struct zs_handle *handle);
 #ifdef CONFIG_ZSMALLOC_REBIND_HANDLE
 void zs_rebind_handle(struct zs_pool *pool, struct zs_handle *dst,
@@ -68,8 +68,6 @@ void zs_pool_stats(struct zs_pool *pool, struct zs_pool_stats *stats);
 void zs_obj_read_sg_begin(struct zs_pool *pool, struct zs_handle *handle,
 			  struct scatterlist *sg, size_t mem_len);
 void zs_obj_read_sg_end(struct zs_pool *pool, struct zs_handle *handle);
-void zs_obj_write(struct zs_pool *pool, struct zs_handle *handle,
-		  void *handle_mem, size_t mem_len);
 
 extern const struct movable_operations zsmalloc_mops;
 
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 71e6dcb1fb3f..ff1cde4c5dc2 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1172,26 +1172,15 @@ void zs_obj_read_sg_end(struct zs_pool *pool, struct zs_handle *handle)
 }
 EXPORT_SYMBOL_GPL(zs_obj_read_sg_end);
 
-void zs_obj_write(struct zs_pool *pool, struct zs_handle *handle,
-		  void *handle_mem, size_t mem_len)
+static void obj_write(struct size_class *class, struct zspage *zspage,
+		      unsigned long obj, const void *handle_mem,
+		      size_t mem_len)
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
@@ -1216,10 +1205,7 @@ void zs_obj_write(struct zs_pool *pool, struct zs_handle *handle,
 		memcpy_to_page(zpdesc_page(zpdesc), 0,
 			       handle_mem + sizes[0], sizes[1]);
 	}
-
-	zspage_read_unlock(zspage);
 }
-EXPORT_SYMBOL_GPL(zs_obj_write);
 
 /**
  * zs_huge_class_size() - Returns the size (in bytes) of the first huge
@@ -1284,9 +1270,10 @@ static unsigned long obj_malloc(struct zs_pool *pool,
 
 
 /**
- * zs_malloc - Allocate block of given size from pool.
+ * zs_store() - Allocate block of given size from pool and copy data into it.
  * @pool: pool to allocate from
  * @handle: handle to store allocated object in (must not be on the stack)
+ * @src: data to copy into the allocated object
  * @size: size of block to allocate
  * @gfp: gfp flags when allocating object
  * @nid: The preferred node id to allocate new zspage (if needed)
@@ -1295,10 +1282,11 @@ static unsigned long obj_malloc(struct zs_pool *pool,
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
 
@@ -1318,12 +1306,16 @@ int zs_malloc(struct zs_pool *pool, struct zs_handle *handle, size_t size,
 	spin_lock(&class->lock);
 	zspage = find_get_zspage(class);
 	if (likely(zspage)) {
-		obj_malloc(pool, zspage, handle);
+		obj = obj_malloc(pool, zspage, handle);
 		/* Now move the zspage to another fullness group, if required */
 		fix_fullness_group(class, zspage);
 		class_stat_add(class, ZS_OBJS_INUSE, 1);
+		zspage_read_lock(zspage);
+		spin_unlock(&class->lock);
 
-		goto out;
+		obj_write(class, zspage, obj, src, size);
+		zspage_read_unlock(zspage);
+		return 0;
 	}
 
 	spin_unlock(&class->lock);
@@ -1332,8 +1324,14 @@ int zs_malloc(struct zs_pool *pool, struct zs_handle *handle, size_t size,
 	if (!zspage)
 		return -ENOMEM;
 
+	/*
+	 * New zspage is not in class->fullness_list or movable yet, so we
+	 * can allocate the object and copy data before taking class->lock.
+	 */
+	obj = obj_malloc(pool, zspage, handle);
+	obj_write(class, zspage, obj, src, size);
+
 	spin_lock(&class->lock);
-	obj_malloc(pool, zspage, handle);
 	newfg = get_fullness_group(class, zspage);
 	insert_zspage(class, zspage, newfg);
 	atomic_long_add(class->pages_per_zspage, &pool->pages_allocated);
@@ -1342,12 +1340,11 @@ int zs_malloc(struct zs_pool *pool, struct zs_handle *handle, size_t size,
 
 	/* We completely set up zspage so mark them as movable */
 	SetZsPageMovable(pool, zspage);
-out:
 	spin_unlock(&class->lock);
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(zs_malloc);
+EXPORT_SYMBOL_GPL(zs_store);
 
 static void obj_free(int class_size, unsigned long obj)
 {
@@ -2224,7 +2221,7 @@ struct zs_pool *zs_create_pool(const char *name)
 			huge_class_size = size;
 			/*
 			 * The object uses ZS_HANDLE_SIZE bytes to store the
-			 * handle. We need to subtract it, because zs_malloc()
+			 * handle. We need to subtract it, because zs_store()
 			 * unconditionally adds handle size before it performs
 			 * size class search - so object may be smaller than
 			 * huge class size, yet it still can end up in the huge
diff --git a/mm/zswap.c b/mm/zswap.c
index f28a46cae1e1..f4cfc552a6fc 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -948,12 +948,11 @@ static bool zswap_compress(struct folio *folio, long index,
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
2.56.0.398.g882cbad275-goog


