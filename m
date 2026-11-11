Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3689960A261A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=PTtmjfVi
Received: by kanga.kvack.org (Postfix)
	id 23BB26B05B9; Wed, 11 Nov 2026 01:47:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19E7D6B05BA; Wed, 11 Nov 2026 01:47:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B4476B05BB; Wed, 11 Nov 2026 01:47:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE6806B05B9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:47:29 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 572341A021F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:29 +0000 (UTC)
X-FDA: 85421907018.02.D3FC174
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf18.hostedemail.com (Postfix) with ESMTP id 779AF1C0002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=PTtmjfVi;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.42 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794379647;
	b=42Bsbae+JDvUIWOanYRuHWP/1Zv+bBuf/EsaHbDwB1zMfKqMFjhcVOwWA2vHszgg6MsnDQ
	O4QLTP83Rd2ov/pHWsvsc3VB64eZyAb0/oY95pkQRG4DSUdl/1YIuvoEIYC3ccnUjT1Ebn
	ZRyT+Tq1HmbWWXDjc32se6lNPqytXzw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=PTtmjfVi;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.42 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794379647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bS6YrLfLjVr/kV9VYjIl/D8QMpcJDNfCyQFxSGbAF7I=;
	b=EQwZR5Jyf/96y+lNy0MUDPpCj8nkxqGyaB70Y9yxYHzl/fXrmnuAnpDv3WfDsGy3k4dDg4
	HYEI125HCub5AnR1wKk6dWnRtde6cL2A62SkY/CwDnZvoiO6IgCSDBnDwFfh4QkJhLu+9u
	J9Da1kAhihb1pcuTiPuyCgKk7I/LZS0=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3b0ae87069dso1445211a91.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794379646; x=1794984446; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bS6YrLfLjVr/kV9VYjIl/D8QMpcJDNfCyQFxSGbAF7I=;
        b=PTtmjfViVtmUE2jxggynz1R/gi7w10rRDzeUnot4zrWqZrGxbR5uP39LAkPPRtwtYJ
         dGjVT0N3PAeAE7T7w61utkQSR4cP3sXsiSD9yR3ZNb4xi8d9UAjmKECKXAqEG1eMTgFX
         LxCM7YzynZ5HgIsKlTQRh0nYzQUj6cVyW18/I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794379646; x=1794984446;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bS6YrLfLjVr/kV9VYjIl/D8QMpcJDNfCyQFxSGbAF7I=;
        b=si6fIwuNS90dckBE5cbDH5+sRQBqynSb5BIL1Ncw9HNEUWjB6uWlPVfZ/BwD7y2AE8
         AC36fT3kybhtVR0dBis+VRk9Dtqo0UUx2Z5iyyQJ+jWvV+Ikq/sUcOTWX8ccHaTaGMlY
         ekwyJnAdyvI2NXJxu3K/t3R6jEt+Sbs2dk2P/kEevFpZEf1os40QLXrg/G8ek6IjDsuD
         64bcASmFIHkW+uo0zGonRs04JGdSlvAkS/OkdDHLQ6OQ0QIOqAui4fbjngjR4YGQfkg8
         X0LLVUHimBUu8HilkEAe+eY06YKCk6SQ9eO7WRLxmeMD+jeQ5P7Y5yVvLGZm/EMw54c9
         I3uQ==
X-Forwarded-Encrypted: i=1; AL+hErHOoLAI+BDlpEi3pOj5843LPSVGhwumgHqTkKW0hD+MtnIQVrNPbfTvzSKlHzU2nv7OsJWZx9yYsQ==@kvack.org
X-Gm-Message-State: APuU4Z+wcXcQXegXvrbLhd7+3BkAjJ4pw9TTBBIS0D9v+5FYOzr8CNgD
	BYed2lP8XZnGatRKcClTXkZdzYcgSifzHCtsaDUeAIR5v8ukT4mfaNXzLR8d97tx4w==
X-Gm-Gg: AYBFou1QJ8zWNXFzA/r/ancSLSAsxzTbOvwx7025/MzzMYVJ7F0yrIKprgTHLof14kj
	eW51i1TQ2LD5Ovvcu54fMMKFZDb4G392IL0icT+njxA89+lURGdfRlCrQyonk8oRT4Bw70KdygH
	o0XvljViAQJYIhho5cf1v2ZGgsm4rgQ5juMjvBIUer/5bNZaTbQqXbMCp9e8ip2CqSc+wUELup5
	wTDF+GpzP8RR6BaoaGRLA4WnUQAF0oIdSeWIr508LKfhq4KrIapjq/7MmBO4EgS19CCXJ9aTTNU
	xIqEiHMimY5t6Hx9S1tNBScV+py1TT0xGQBzXqpgzpH2Wh3CYTdIRg3bSPoj53RT8HJcJoPdc1g
	wQ98Ghm5SZDq4txQ8MwhxNZXePjd8eHUqZvBpvGPbDxp5EJcTAODG5BCPhFj7CO5Xj0hrYplzYQ
	7h0PVJ4wuPhdTU12a6PY8lpY+lqWrAsOFrDZcQWUsHcqN9/ghNZnvIRwZmKnt/5Z4zyBNuWb5Sm
	ONfXgnYiFtYmkM9NOY/2TNbdXHhebWOA6iLKv/G/N4KWcmEEgpiKh2+Vj5i7fkQCxlS5W6xxyJi
	TcusJkm4AJ7UpLwnv+fXRt1MOyAVqvKj0aWBXey5QNRdup0xcMdllCKE28kDfCeYiLbIKGQcaIN
	ttEXqd/c4i2IS5zRXFg==
X-Received: by 2002:a17:90b:4d05:b0:3a6:f1d2:57f8 with SMTP id 98e67ed59e1d1-3b182e13d8amr1718256a91.2.1794379646190;
        Tue, 10 Nov 2026 22:47:26 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:ad6a:b446:df00:78dc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17db85a9bsm3268666a91.14.2026.11.10.22.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 22:47:25 -0800 (PST)
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
Subject: [PATCH v3 04/11] zsmalloc: switch handle type to struct zs_handle
Date: Wed, 11 Nov 2026 15:46:27 +0900
Message-ID: <20261111064707.2568433-5-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
In-Reply-To: <20261111064707.2568433-1-senozhatsky@chromium.org>
References: <20261111064707.2568433-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ndkyts9gzebjpekfx7u6hjze599p8qe6
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 779AF1C0002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794379647-196150
X-HE-Meta: U2FsdGVkX18AioqhW8fsjS3VM+D8p3ouGTlGO9rpE7iDCY+CGMCcY7UNTSN3qlPA1vX5hpBqkNfh9EhCVv+X1H3+auOcTI+nsoJNkMnji7mKT5Fa6umxnbwNaua1TOvNzfRMq+5Z4MwhWN37SaVyps0iQdIJKe6HsPoRHsIqKmenSnUHMFxgChrOunzzs7EjY/0SGsBrOvQ0wX1EZLGabLYlwQCIY195R3g+SQXQ1/6WM57kA7XKukHAHbmMLmqirdM1sEWOpU9hBrlH25jE14g4acKsi1T0WK7zG/NruQTqe8gcrmAUldYS4HewUxZPVxeAPBuEeyrOouIelXsp3Gh4GCVhAECEMjg1KaS7mJtgJaqNZHLU9EiQdcqzaYMTZuzzBShpLC7WRvy0VGCo+uIMjtuQYtcRvoPzsxtiWjRIgYYt4QlA4mzYwg2kObJJnpyhGAvYgXt62Drl1XgYKP0iu5xQvIMU2xZb4oFxrXKLBrcHd6J+i1+Mi+01xbdvi8HzXB/XVdT14rrBQGJuofUFQKYJqp56ZSgKAtOsHZ/pBBd63dya+vOdNluKsmHcdgQfoiVjXFaB7Zv3VRaIxqvPNTgH3CFD3MrsyZ0nAvcnX+pcuXC/me/2aZuDt6sNGZ/yAqWX5esZSYvSGAYI+IXBjBimHWNlj9CbcNjeSt1UizgLv3otqPzCIlgVefsBU+cgnLHu4JFCcBU+nSPyoFjoUwcZNNUXmJyUS2GGoMsuEEql0bByFECtc97fyIr223PEs7HmaPVgNsgmnWXYuExugU2Jj/BEsUM8r5ZLkCsyXob+1cOcEyrY0BlZ5AyKX1Z0/NdwPlGDqo7d90Pww3UnXIRccPKbhV3XBJnWlOAHKncBNZAscNrAlRP2nYeew/bKHbgA0Kjomx8Zk51BSDqf0OSIck/WIwxF6/8nNxElIw36LbZAB7Ql/0N1T69hqv4+hLqwhWYvAJbPlYK
 UKBVsXd3
 rlefpgrLNETAeuamKdrCiyKP0u6N9h6uuzisPJ8WXyUin71YaamtpgOkgyLNKRYylprQgybt4cgqHs7lIbn+6I4RM/PwTU683Gl15qdD32GK1Xi+o2+tpXbga7+NE32rhuzY14/2EybFK33wqHjPGJlsiq9vHuMPDaYPjXaCY4BZY+i0n3ofBfOdHWy/kg65R8LnVRTfOOgdiEg6+PLJjsgDLuzSEQpMI36zcoVjHaBV9rm5BKejlYcZkKgcjUgeOL85PGCbycW9mzwlRLhsxOR25OlctQA8/HsZHQOuZoF7wTarT1iO1GY7fDg7dec1V5FoMjLYoYhqgsRH4tMmXpvA0U+1fey3Fs/oLmrnX+w4JsvfKidopGJvKDoN8qODgJ5yO3HC1Pg1aWDSd5n68Hg0S0g==
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

Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 28 +++++------
 drivers/block/zram/zram_drv.h |  2 +-
 include/linux/zsmalloc.h      | 13 +++---
 mm/zsmalloc.c                 | 87 +++++++++++++++++++----------------
 mm/zswap.c                    |  8 ++--
 5 files changed, 74 insertions(+), 64 deletions(-)

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
index dab71f582103..2385c1951ca7 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -55,7 +55,7 @@
  */
 #define ZS_ALIGN		8
 
-#define ZS_HANDLE_SIZE (sizeof(unsigned long))
+#define ZS_HANDLE_SIZE sizeof(struct zs_handle *)
 
 /*
  * Object location (<PFN>, <obj_idx>) is encoded as
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
2.56.0.542.g3ef89b7020-goog


