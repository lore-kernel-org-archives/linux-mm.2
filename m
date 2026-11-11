Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1842606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=hJiq4PL8
Received: by kanga.kvack.org (Postfix)
	id CEB2A6B05C3; Wed, 11 Nov 2026 01:47:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC6006B05C4; Wed, 11 Nov 2026 01:47:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8AB66B05C5; Wed, 11 Nov 2026 01:47:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 847726B05C3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:47:47 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 914854020C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:46 +0000 (UTC)
X-FDA: 85421907732.01.9895D2E
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf27.hostedemail.com (Postfix) with ESMTP id CA2EF40009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=hJiq4PL8;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.48 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794379664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g28+tavLB0lAEvj5/W5N95PkXK37OPKvpEh4+PqsI6M=;
	b=IIt7jNO5+o+8v9XimgHuAIJywLA5X6w862IN3NwdKAmSP7eixraKgNFq4dDfPoGUopUdx1
	Cq2jUzq2AmtlFkK/OIbCtYjdQ36D77HZzOPYW5u3ACTK8HJYZXAHmyZpFk76e2+CFchs6r
	Dm9DOcBC1QAJugKKReDXdamhijPLQUI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794379664;
	b=yNq4LDo2PozYVGing5qMQX980mUYXrQEWPpUoIeSXpfWWIHAvRQltsnNqxim+Sj2VeqNjk
	JbcOW7n8PAFIK6VpIgY/aTzm0WDgPmpqj6soahwQq5yh09r5aKLMn1auru+otvbLOFJQgz
	UUWgMG5vmrhSdi9bgliPaERS6mMmr3Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=hJiq4PL8;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.48 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3ae691283ecso1586138a91.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794379663; x=1794984463; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g28+tavLB0lAEvj5/W5N95PkXK37OPKvpEh4+PqsI6M=;
        b=hJiq4PL81W1MA5KExgWg+3/qEf8w43B2uVEtMjQ86wUqvDy3Cyk42bO38Xoa/nIban
         jFwQT0vI7NQE3q0dzzAQmCoi1zWZcy38yO2HgubQYMf+9DYMc7bAp8WzsVHRSR0Y3UHD
         qIeR1JWrsULpz18VehjUFNKROQ6Cj7fClheTw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794379663; x=1794984463;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=g28+tavLB0lAEvj5/W5N95PkXK37OPKvpEh4+PqsI6M=;
        b=H1v0kP5PuN0lAoB1zpnHKU8bSmFL/e6C0VZUAXYU2nPVBgR/w3A7UBvKOCnvy0n+xd
         No+1S/SwapPe5arKqsA9V8uhw1AopnKBcyXAElk3snmpKJzXGzH8NbS7JdDHtQ1eqWEj
         Tjel2p+oIO1HqEhZD0DiojHt2TItrtCbxNb+rU1gF1E+FVcNRPX7aiEgri5WVetx4/2x
         G0NKht1lb8hieoj6UU35CsSc7slDI3uDn4r636V28wiaCHFGGSgmGxm1GcAiMdg1b8tR
         OyrcSRL1q8Rkg9h1nNiDrkMsTAvLRNLibFkTlOgmfq4Iw0q0cpWemx5sLfZV15oMBHfM
         BlwQ==
X-Forwarded-Encrypted: i=1; AL+hErEohZqfP70Ofmrxgx5g8+cMQXIWlMGIY9V7uCJlhUmqBf1RK9h4ysEiM+aY1drDI28khS/FFq5W3g==@kvack.org
X-Gm-Message-State: APuU4Z88SG4dnRmGhotRaA2QZqX5X7K00kSZZ3wz538w2RaOK3Rz4kR1
	P5j0AFZoYqwJceIh0Y07a56NZT5G4PPOpyDAd1UNVYIzblx2PxY/01tIVapMrk6zXw==
X-Gm-Gg: AYBFou2hfbOxBrOa8BRtGQvqdQAP0ZWUSxsfIq7osd1YYcdEAEc2UfEAVX6dWtHAGJj
	qbCIkw719ZB+YM8HklOxm69DT2iG60ntjoAbQ+XLNw7q7Ggfrqtesc6LfjuAXXVgyhrmV/sXFrO
	jUwqzk9yPEWPUgQLfDv5FyHXPsqIRHWC8jMux3pObK62XiLlwtM/Tzco1xo2k6vcnPysxrOI0h/
	8VCJcA/tPND9k2c5XPeZtpOvi/y81rxsZa22gMe9wIYh/XOobuGKlCWnJSC8GGT1ouShH3JTAhp
	6t2sBncGAvtCvw4vhSa4GanfNmAi+y+B6DuDKzZ09qt1S4wxM/Tj5D6SkkdkpNwlQl40AQoCiMA
	uqFCUnT8HmCOX0Z+EsmKD7n+/njRAIrQBjbbIIeodBVI/eZWnzqdRY785DWQfM6zCrlodnLLT7x
	OwpZFjHy3twESyFtr3YqiJ/FdrX/2qdHN6bR7PKZJZ7WmV7eYNyXlOPSBsUXoH2E2i1S0EUW7DY
	taMpxJq91yOJHccfSskyvsji2F1e3XntPaTVqDidgeXG5myWfjCJ+3jMXIsIW7pN3jn4SnRU4v9
	jCUF5mOnlburMskGOzKNgh/BXXdCybxucW8cf81srK4AYZ6kRq9cZLvk2Sg1iPnlozu7ps5X9My
	AkN/qPzc9ZA8WhlETocnu3NcZJvHC1/qepLBdnhA=
X-Received: by 2002:a17:90b:4b8c:b0:3ab:8288:b8ce with SMTP id 98e67ed59e1d1-3b182f25969mr1169183a91.24.1794379663450;
        Tue, 10 Nov 2026 22:47:43 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:ad6a:b446:df00:78dc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17db85a9bsm3268666a91.14.2026.11.10.22.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 22:47:42 -0800 (PST)
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
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v3 10/11] zsmalloc: fold zs_obj_write() into zs_store()
Date: Wed, 11 Nov 2026 15:46:33 +0900
Message-ID: <20261111064707.2568433-11-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
In-Reply-To: <20261111064707.2568433-1-senozhatsky@chromium.org>
References: <20261111064707.2568433-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: b6mjxtkyzytty3gnz9ezr5ws1ohg84ek
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: CA2EF40009
X-Rspam-User: 
X-HE-Tag: 1794379664-784678
X-HE-Meta: U2FsdGVkX19bU/GUPxOpPwre+zdcayJQSSr+wtUR2sAHP2AT8m6cqjoHTH6H3RCta59fQvy/v7+FSX7gzbzfyL6b33w17z4IlBn8bqm+3Mqh65xOLU6mBFjy8L7pOvJ23+s2l/GRBHhoSpynu8MC2wBW88uJ/1dn5Ntw6Ydnp3FZMiDUOp9SVNPBYDtKnT8zkxV7zNAjuHK6m9QK/Ibiypf+cUppMbs6Z3wC+SVeVCSNq98rDZMQhCpknuTY8tEiqwOJOXd4fuhdQQD6PK5DiVC9ZtsmnKVEWenuA53RzM2LbQnNHTfKDmN+6rwnG6YgWinOoKZR2O09ggFl1PpnxWhOUCDWRfc0qTRbJw72f2sKv1AhHomfHxU3pzZxCQrkyulao3qImzJzaV56Hs1E0ByhKzLxWZM1y7zzCqsNFOeeCGENRZaNcS041tB+rJhjTYgaWK6qev1ia0jjYLFrrQrptjwOErGr/dUtChO7oMAa7viMnOp5BgdOOr5yLDfFI2q7lORRBtVUO5g4Ipx3VAQdrG0JzC3tQGSpE/tMpU/ju2fCb9f519wa4Rt21DooAPgAywybLqm3TiCUYEyIoNBZL7wWC4Er5DcD467FWIgfTVMYrhb6+GwJ6V+nRtPsxfj4dWv53oMPQ0GeqdkNKHOZ7QcEFcZmhpnVi4ifB+exnxPOSj7W2jUA4j4aD8FWigZAX0bevPwPLiJkYC6nlSQPJSpEkVmEp+8tASPgksClQXe6hX7D8gT2YPiR9ZfwC0V8bgNyNpb7Hb10yXA8V0qWNyfDYeGJ4H8euOZX1HnLo+H0xn4vHtzzLltZ34RMav0iw968RYYZ+m0AvjkzZ4H/2XA/SSQAxA+j35aqcH97aGQ1sn4D80ayrGEndcpFDAgPo3V2ckV4F3poVcg06/gSjHTyPd8owYMrVkLOOwVMCyO0v6X7iX0RwzOcaHn9apnVnoHS9XEDRq6ldHM
 aamBOr8O
 lI8ot8AV/3lWXyb4+9i/OKEuM8D1Zzm+gjDW08QO/pyJ9tPeRBqdNaJjaIA09lpg/vlMaO5qbzCrhSf26EAGX34kr2mjJgDlzpnzvOXQjVevkffheG3HlCpWvxkhkkRZqFkE7u29+0KKj860SGPqjx1t/Bf39m8+JpueceV3wRux0MRB47iKWHoyDydIDez4OQQUaAivz3+HaN2rGhOR07m0by2jWSS2cVpn+dt+0p7Kl99fJndGyTNkl+XXZnzodoFiZ1SM8PARE7MYhAldysSnekRvMrvaDqRo5lV2Qdgo0TbshvAAxL1aULbCpucgfhrG9HckMApQnrCpkxmrgJk7lKdFuc+wR+nMkWSnzfOJVmNhIlW8WZWJxjOQj1cbUfZALy/bsKr0xB6qXanOqfZMQOQ==
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

Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
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
index 878582cb1e33..946b625761f8 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2263,9 +2263,11 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 
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
@@ -2273,11 +2275,6 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 
 	update_used_max(zram);
 
-	src = kmap_local_page(page);
-	zs_obj_write(zram->mem_pool, &zram->table[index].handle, src,
-		     PAGE_SIZE);
-	kunmap_local(src);
-
 	set_slot_flag(zram, index, ZRAM_HUGE);
 	set_slot_size(zram, index, PAGE_SIZE);
 	mark_slot_accessed(zram, index);
@@ -2329,21 +2326,18 @@ static int zram_write_page(struct zram *zram, struct page *page,
 
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
@@ -2528,18 +2522,12 @@ static int recompress_slot(struct zram *zram, unsigned long index,
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
index 54d4fe8ada53..7f1cedd34081 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1185,54 +1185,37 @@ void zs_obj_read_sg_end(struct zs_pool *pool, const struct zs_handle *handle)
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
@@ -1297,9 +1280,10 @@ static unsigned long obj_malloc(struct zs_pool *pool,
 
 
 /**
- * zs_malloc - Allocate block of given size from pool.
+ * zs_store() - Allocate block of given size from pool and copy data into it.
  * @pool: pool to allocate from
  * @handle: handle to store allocated object in
+ * @src: data to copy into the allocated object
  * @size: size of block to allocate
  * @gfp: gfp flags when allocating object
  * @nid: The preferred node id to allocate new zspage (if needed)
@@ -1312,10 +1296,11 @@ static unsigned long obj_malloc(struct zs_pool *pool,
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
 
@@ -1334,7 +1319,7 @@ int zs_malloc(struct zs_pool *pool, struct zs_handle *handle, size_t size,
 	spin_lock(&class->lock);
 	zspage = find_get_zspage(class);
 	if (likely(zspage)) {
-		obj_malloc(pool, zspage, handle);
+		obj = obj_malloc(pool, zspage, handle);
 		/* Now move the zspage to another fullness group, if required */
 		fix_fullness_group(class, zspage);
 		class_stat_add(class, ZS_OBJS_INUSE, 1);
@@ -1349,7 +1334,7 @@ int zs_malloc(struct zs_pool *pool, struct zs_handle *handle, size_t size,
 		return -ENOMEM;
 
 	spin_lock(&class->lock);
-	obj_malloc(pool, zspage, handle);
+	obj = obj_malloc(pool, zspage, handle);
 	newfg = get_fullness_group(class, zspage);
 	insert_zspage(class, zspage, newfg);
 	atomic_long_add(class->pages_per_zspage, &pool->pages_allocated);
@@ -1359,11 +1344,15 @@ int zs_malloc(struct zs_pool *pool, struct zs_handle *handle, size_t size,
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
@@ -1845,7 +1834,10 @@ static int zs_page_migrate(struct page *newpage, struct page *page,
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
@@ -2239,7 +2231,7 @@ struct zs_pool *zs_create_pool(const char *name)
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
2.56.0.542.g3ef89b7020-goog


