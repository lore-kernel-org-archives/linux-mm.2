Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2736606BF52
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 02:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=UP5quJwF
Received: by kanga.kvack.org (Postfix)
	id 1FF3B6B05C4; Sat, 24 Oct 2026 22:19:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D5DF6B05C5; Sat, 24 Oct 2026 22:19:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1D0D6B05C6; Sat, 24 Oct 2026 22:19:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B47026B05C4
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:19:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3526DC04D6
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:19:18 +0000 (UTC)
X-FDA: 85359541596.24.509E182
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6F64C120005
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:19:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=UP5quJwF;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf29.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792894756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YDh1xSMVK7zZ4d6sP80ijQWBEa0qBw5fh14J44qEXMo=;
	b=CfMH/ezqW9ZevqA5/jiJjvK80192Cny5ylZxPZNBTLx3Jq5BpcLmt8PFKFtdpkl0orDtcz
	MINWbWVj+c2cwWF6sMWkF/kfeXgmGxvZ3m9nR38LPc4VQeHaxQ95AY7USDjFSJw1LeSWH9
	p6LIN7ZKjGTPRDp55mJzA0UFitTZF0E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=UP5quJwF;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf29.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792894756;
	b=O1RIdYkPgOXGQpdX+OPbKoCPA43oL8XIAObFmg0YXU8N2kxVK1+dE598VtRrPIg79t6cRW
	605PJdK7DKXPAmqhqO1JLzLwiTe8C+bSZJwPQ5QW98ZwQzaxkzxsI/PNIR7os7Z0FeKTBw
	6KhWtx2q192UJ+DbsMRwQqnJfcYQksM=
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-15dd124bbe7so773717c88.1
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792894755; x=1793499555; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YDh1xSMVK7zZ4d6sP80ijQWBEa0qBw5fh14J44qEXMo=;
        b=UP5quJwFqUFxqESjUFPfCcP3pU+5MVeZ5GpQ89ZFHNMcwDcxU6i4089UGlrTH2E2ku
         BRjekonVppRzPadf4y430yusLSxYjLC2XnFtFLQcusrWtYGs2i6kZCcbN/be5FKvTsrI
         VMUZ2uBGMqY8WM0cmplrzqlirB5sPpK6WntP4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792894755; x=1793499555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YDh1xSMVK7zZ4d6sP80ijQWBEa0qBw5fh14J44qEXMo=;
        b=vFhv/ze/gusnf/BZjFbnI8zAiJF2S3GDVokjZkiMesk8oBjsInBW5fy7ioJX3pNk7E
         RnKP8zUhUHiZc3ljgwQS8N2G48bb9XyDkX+QhfP6GSK/WGYoeLZhep3URZICTOVvxtV7
         e4z12+FLQqn7DvbUkRBGpdZxOV1TwpJoNBL7injHPqhlJB/8xJBzaeeCnns2NGLCvhFN
         yhCA1eL8ONuPr+D/5n6ns6jUPr44uQ8AAzXHOl//KC9yClfASh1wGPZxHmaC6uC9ZnSf
         URanpRQIWYE0gpb9vvuHOsE736ARVqVl1K+o3Qy8QBjffe+eF/NubiO9YidkxN639QvK
         qGHQ==
X-Forwarded-Encrypted: i=1; AKwUvByNt9GVIfesnZJyow7SIr9HeA0+gmOKj08xlktG7IVdiQ1yYudAzn4SXgspEhPDnGQGZ23lCbSqtw==@kvack.org
X-Gm-Message-State: AFq9FYIAVhNDD25Pqb/gVAcdK28BYZ/UhcliQjXvtfBkIAIUSwu/O4mk
	Q4g7sU/LV/TgDGBxRTBk8SoeldaDDzHyWQYgS+bvLlJ8xo+TeXVFSHfsNIqWZ1UXqw==
X-Gm-Gg: AYBFou1z7c1f9YPwY6S3gyyeNjcbk9Fi7llhi6d1yGjO8zt/Dy+GdT0v0cDi2QgHg4Z
	/xJO2pHZOiZnPrtjkog3zpvsFVALJMQf5dAaQnggpkA51dY2HP4HboPku32bjAIAIpXtZHgkWGs
	rABkuyRUz7P8UJqWmLhNzQz28CynHd+y7jO0pu+Js25/exRe2URzZpo9uXFYuw9JC+ESziaMqpp
	2H5xQhxW6DgB91cvnjgTtZ9hvbiedaRXTPwP8A67ibCi0fYnBBTsHCm241+oPKhWjOjfBoz9fG4
	32ZlnxuqLRuNS/6DbUvM4SMbEUJAKZ3XJ7ycYVFq410RQfpuSRIWX5o+8i8OrPasRVWOcfOGu+l
	p12i9HkmfcqJSA0cGHxJpoNxiNB0vCj+dBdZ9exxI/02Qa4XrFMAMdfRaHWSol24bZTPE4zu+Dk
	lWRJbL5wlGvjUbVzDYBfvcuyGbN0o1ffcpP6+hCP3MNKJBXttWDk+GNc97/n1z1orclbeM8UuR2
	zSidjIerIT6/Oaf1t2LHqXc6ZseaQ6e6Cs5mHvqUibG3ln2LuCyysx0EWEKKJsS6uQL76kqO0O0
	rMtISBmnozUwzzbNoxzAKzXutDw55zbg7YDW8/DptExl
X-Received: by 2002:a05:701b:271b:b0:186:4a57:94e5 with SMTP id a92af1059eb24-199377d902amr4696620c88.34.1792894755143;
        Sat, 24 Oct 2026 19:19:15 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9f87:66fc:8c85:11bb])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1989ff2ee5asm10387242c88.8.2026.10.24.19.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 19:19:14 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Barry Song <baohua@kernel.org>,
	Bo Zhang <zhangbo0325@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v7 13/15] zram: allocate bounce buffer for spanning objects
Date: Sun, 25 Oct 2026 11:18:29 +0900
Message-ID: <20261025021839.1542805-14-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
In-Reply-To: <20261025021839.1542805-1-senozhatsky@chromium.org>
References: <20261025021839.1542805-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6F64C120005
X-Rspam-User: 
X-Stat-Signature: n9tgmo5b5x7z6czs8yjfbxb8sen4ezo7
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792894756-966372
X-HE-Meta: U2FsdGVkX1+MEQIRMFXt9n/zUhsZtcghvX1XHGoGFKcyNljQNvMicvYtyrcjz60sXKRRczscFE27zQjRMr+oCJY8aMLoJcKA53Sjv3mqzYKmsw/f7ivvZe1CfzT3NsCYPNHhR0ex/Gl/YH0wH/2KlquMaG3jMOnDQm9uGvKRZuJ+tPj7uf7rCSmYn5SF8wBeBQEwqfVT9H2qF0LTkcAs7SCXKhOGfACN+kBs1fMjqPCxkaEd0gzV4f6f0bHS/BCf+aZUAyxzXAnokndqlflj3D8ypJMuWfpZ0Nq1wybfjYnLGn7aA38tavRrKZBvGQhUliuR0QFCFWZOxfIjvsWteKxdIoOhL2HkTADKExYtydTKI28b1ByP+jnMi/5ZVkq3KQy73pANkdnfxE8UMPOQ7qzTTY7ro/YOtFoxno994xk06OM4FHM0LHNRybcx93LYhBUtCcvT5gNFAsxFURLSaBj3dSRFHbE/cDi3GZcfuw2rxBofrmHJsQOHD/jaYV+LdDja4I8H7cnJvTdtMeXKEPyHCLEicuJlltXhS7SjmrX7qi06NBoqbmk/BzJy/s8L0zVFDyJ5hLJUqQWj6hVJn4cs6K/fkMgs7PBZsv45QVEla1UPTwNIMKD/Nqui4/D4JJaYgg/xEwVzGG+OGnLGS6xWgSeqwrnnvElHN+an30Q2ivjmjblJtsLiqe6Sd/XYUv7NCBWoaHkwWSbqi1g3l47oNIDjxDqgHnPJxtpLkQjiF/jZm0A5+2ENzFwc8aeve6So2HT4c5vWmUd1KMTneYbkDa5qdVSQOgxc01YQvbAqDq1Bu66IfkatzxDD3M8GuajfaqoX0V0g2IN/dRt0rMR+Un9P1pEaDRN/iQZREfP7OjudBNbYoh35Y2yXHrlx0cn3XdFIz18FJ72KEZeUcl7WG4FEIjMv6CdNau9j6iPpEJeBQVfpOYa+K2aFklPzvDWvJE6y0DxEh6IIKSW
 WCzZoH4i
 ePKWrJeqw/XLFV2WdtTVoc8569FCdA3MwKHUcXCPRCItrN8RRAUQ2Zeu2p6CCrUIQqf9ad69KYSER/xsPBHa+h7+zolNxW3Kvc6GprHlQ3QsfuOG3JnudEHsOZyH5GGMyc/Oz7pZQHeu0+oifQ5h5o5M30AGXwgyVRDikY4Tv2bHWB2ISuWE7TtjAEOYWwsbxRZ4KnLkd5Dy8ZkJ4IYHkoT+FYezTWecqVjWW9jtv1O8hY7WBu8NHncv4UUQH9d+J2wSEYsnPql2lWDqBnE+DBVFeQ2wCws7TU+TDHGMT2dU4tdvGCheERAfD2sdZxfopjNgvDOe0Tk8GcA7TJaNkWbd7yv+RMZEM56Oooae0PLiqm3ELyfocrxuilA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zsmalloc objects that span two physical pages need to be linearized
before decompression, which zcomp does using stream's ->local_copy
buffer.  That buffer cannot be used concurrently, so such reads take
the stream in exclusive mode, even when the backend has stateless
decompression.  And spanning objects are not rare: Bo Zhang measured
23.3% of reads on lzo-rle going through the exclusive path, causing
contention on ->excl_lock of up to 72-96 ms [1].

Allocate a temporary bounce buffer for spanning objects instead, so
that backends with stateless decompression can always use shared mode.
If the allocation fails we fall back to ->local_copy under ->excl_lock.

Per-request bounce buffer fixes the remaining tail latency, as was
measured by Bo Zhang [2]:

  Metric          Base      kmalloc bounce
  ----------------------------------------
  read contended  ~1,959    0
  shared          76.7%     100%

A quick synthetic fio test for Reader vs Reader inversion on 24 CPUs
(lz4, 48 low priority (nice 19) readers, 24 normal priority CPU hogs
and 24 high priority readers), average of 3 runs.  Base is the
previous patch (shared streams without bounce buffer):

  Metric           Base               Patched
  ----------------------------------------------------------
  Read IOPS        1,452k             1,466k        (+1.0%)
  Read clat avg    3.46 us            3.30 us       (-4.9%)
  Read clat stdev  165 us             15.69 us      (-10.5x)
  Read clat max    306,679 us         7,060 us      (-43.4x)

An alternative approach is to vm_map_ram() scattered objects
(two pages), which fixes the tail latency in the same way,
but deferred TLB flushes add more cost, so it was rejected.

[1] https://lore.kernel.org/linux-kernel/20261014153603.1365617-1-zhangbo56@xiaomi.com
[2] https://lore.kernel.org/linux-kernel/20261016134847.1620103-1-zhangbo0325@gmail.com

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zcomp.c    | 47 +++++++++++++++++++++++++----------
 drivers/block/zram/zcomp.h    |  2 +-
 drivers/block/zram/zram_drv.c |  2 +-
 3 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index da122bf4dd15..4fda13aac896 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -176,14 +176,13 @@ void zcomp_cstrm_put(struct zcomp_cstrm *zstrm)
 	mutex_unlock(&zstrm->lock);
 }
 
-bool zcomp_shared_decomp(struct zcomp *comp, struct scatterlist *sg)
+bool zcomp_shared_decomp(struct zcomp *comp)
 {
 	/*
 	 * Shared decompression is only safe when the backend has no
-	 * mutable per-stream decompression context and the object is
-	 * contained within a single page (no ->local_copy bounce needed).
+	 * mutable per-stream decompression context.
 	 */
-	return !comp->ops->create_dctx && sg_is_last(sg);
+	return !comp->ops->create_dctx;
 }
 
 struct zcomp_dstrm *zcomp_dstrm_get(struct zcomp *comp,
@@ -239,6 +238,15 @@ int zcomp_compress(struct zcomp *comp, struct zcomp_cstrm *zstrm,
 	return ret;
 }
 
+static int zcomp_decompress_buf(struct zcomp *comp, struct zcomp_dstrm *zstrm,
+				struct scatterlist *sg, void *buf,
+				struct zcomp_req *req)
+{
+	sg_copy_to_buffer(sg, 2, buf, req->src_len);
+	req->src = buf;
+	return comp->ops->decompress(comp->params, &zstrm->ctx, req);
+}
+
 int zcomp_decompress(struct zcomp *comp, struct zcomp_dstrm *zstrm,
 		     struct scatterlist *sg, unsigned int src_len, void *dst)
 {
@@ -247,27 +255,40 @@ int zcomp_decompress(struct zcomp *comp, struct zcomp_dstrm *zstrm,
 		.src_len = src_len,
 		.dst_len = PAGE_SIZE,
 	};
-	void *src = NULL;
+	void *src;
 	int ret;
 
 	might_sleep();
 	lockdep_assert_held(&zstrm->lock);
-	if (!zcomp_shared_decomp(comp, sg))
+	if (!zcomp_shared_decomp(comp))
 		lockdep_assert_held(&zstrm->excl_lock);
 
 	if (sg_is_last(sg)) {
 		/* the object is contained within one page, read it in-place */
 		src = kmap_local_page(sg_page(sg));
 		req.src = src + sg->offset;
-	} else {
-		/* the object spans two pages, linearize it into local copy */
-		sg_copy_to_buffer(sg, 2, zstrm->local_copy, src_len);
-		req.src = zstrm->local_copy;
+		ret = comp->ops->decompress(comp->params, &zstrm->ctx, &req);
+		kunmap_local(src);
+		return ret;
 	}
 
-	ret = comp->ops->decompress(comp->params, &zstrm->ctx, &req);
-	if (src)
-		kunmap_local(src);
+	/* exclusive mode already holds ->excl_lock */
+	if (!zcomp_shared_decomp(comp))
+		return zcomp_decompress_buf(comp, zstrm, sg, zstrm->local_copy,
+					    &req);
+
+	/* shared mode: try a per-request bounce buffer first */
+	src = kmalloc(src_len, GFP_NOWAIT | __GFP_NOWARN);
+	if (src) {
+		ret = zcomp_decompress_buf(comp, zstrm, sg, src, &req);
+		kfree(src);
+		return ret;
+	}
+
+	/* fall back to ->local_copy serialized by ->excl_lock */
+	mutex_lock(&zstrm->excl_lock);
+	ret = zcomp_decompress_buf(comp, zstrm, sg, zstrm->local_copy, &req);
+	mutex_unlock(&zstrm->excl_lock);
 	return ret;
 }
 
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index bf41b27958c4..362a6da014aa 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -112,7 +112,7 @@ void zcomp_destroy(struct zcomp *comp);
 struct zcomp_cstrm *zcomp_cstrm_get(struct zcomp *comp);
 void zcomp_cstrm_put(struct zcomp_cstrm *zstrm);
 
-bool zcomp_shared_decomp(struct zcomp *comp, struct scatterlist *sg);
+bool zcomp_shared_decomp(struct zcomp *comp);
 struct zcomp_dstrm *zcomp_dstrm_get(struct zcomp *comp,
 				    enum zcomp_dstrm_mode mode);
 void zcomp_dstrm_put(struct zcomp_dstrm *zstrm, enum zcomp_dstrm_mode mode);
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 768c9a6d81e5..8c0fe34b7a28 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2128,7 +2128,7 @@ static int read_compressed_page(struct zram *zram, struct page *page,
 	prio = get_slot_comp_priority(zram, index);
 
 	zs_obj_read_sg_begin(zram->mem_pool, handle, sg, size);
-	if (zcomp_shared_decomp(zram->comps[prio], sg))
+	if (zcomp_shared_decomp(zram->comps[prio]))
 		mode = ZCOMP_DSTRM_SHARED;
 
 	zstrm = zcomp_dstrm_get(zram->comps[prio], mode);
-- 
2.56.0.257.gf7497c7d27-goog


