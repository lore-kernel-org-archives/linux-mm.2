Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60F5C606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=Us7mPIp5
Received: by kanga.kvack.org (Postfix)
	id 0B5466B05CE; Tue, 20 Oct 2026 22:43:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05F0E6B05CF; Tue, 20 Oct 2026 22:43:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E90C26B05D0; Tue, 20 Oct 2026 22:43:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C0D6F6B05CE
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:43:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 49121A041B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:43:18 +0000 (UTC)
X-FDA: 85345086876.16.6D227DC
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7B17720006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:43:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Us7mPIp5;
	spf=pass (imf13.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792550596;
	b=cFX1z73PB3Z3TuAuuiuOZggJyj+ehvouYHmPJVsM2Jvt9hIjRbtGQYqlRWOG07eWvHvKzk
	gTFwYSO1LLhLzxeKopcM5Be6Sr8DmLjtrqMiN4WBH6GARY4ZD5x8dMt0K6XJ84QwMcM+if
	l5bLNHoD1z9wqY6QZXucZ8gg5cc9fVM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Us7mPIp5;
	spf=pass (imf13.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792550596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N8IV0Vqz5Q6I5nTn4QvolcrjBnOVRJOSSIVFXSYU6fk=;
	b=LmeVe+aqmbGaoTFtKxG4kg5RHNekfXSVI4pvjILCjziMgIhFfHUScES8vHld0bu9eo8Gzu
	2avgE0gw68W96yPgAiZYn8mFFtKIYvT9icnFUqeiyfrK48nBceIcN2NqTDPG6kL6AP9mj3
	LlZ3YqcyJ/iWY+WeV2z4TP8zmow7NXY=
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-3645f0f3fcdso440219eec.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792550595; x=1793155395; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N8IV0Vqz5Q6I5nTn4QvolcrjBnOVRJOSSIVFXSYU6fk=;
        b=Us7mPIp5iJMCUpG4K087AmX1rIw90p9VubvR+3HyrlwkDI1Yu90FIJaDbd8MMcjo44
         USsHEPf4FwROygcAJIry+0hsuWDk8ES9pOyuxN8KhTiCTpDeCEXiouwkdB7Mp5FddKxS
         qT8+a5KM81/iIxJG1YW0evWnw2WwxQxjpLs3E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792550595; x=1793155395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=N8IV0Vqz5Q6I5nTn4QvolcrjBnOVRJOSSIVFXSYU6fk=;
        b=tjGiqtWLIlXFP9zcgJl492RikiLghKJ+/fEFYRJPBzY2bx9l0HaiDWwqIZUqFBB7N9
         Dfygbw0HLONFG+HyNb0ih2LPTZ5lKXT0zQ9EwM7A9MwG/fWyjSWfMkgUxFHQn3sXWJ/I
         t3KPSqxIOIVL0l/GcgXUXPKlRZ7u0IPwn43RRhK8mQJoDMKyS5iHdFeoJWYOiKFcLOiY
         44NO4QflEvw7wTBrN6ohr3ctBSHiGuwKW/Ht/FAxQ5X5ZRZ8VGZa8xcaqMw8P4VaZ6eH
         A3Z7ZeEzIsFbxhYhj0AjlQyYNzwGWjgJrqxc+OLMF2QoEBcDj5Obkco3N3MhOsW09yBI
         VX5g==
X-Forwarded-Encrypted: i=1; AKwUvBwVlGNWSnf3dWpfMxbFoNnqpikC8Zet2dSrROB7JImyjqGU70nzYLHBEtD5pOfGT7klyn6wO++zoQ==@kvack.org
X-Gm-Message-State: AFq9FYLFW9fiHZLHYjJx26gGKPmvdsMjSQISeBxjEI943jw/O3iKOg5i
	wR0Bp6KCDsmPtCmskUB446o55eJodMXYUyih0ReFhtWt+Ds+XL6Zbppg5kWe3UBVLg==
X-Gm-Gg: AYBFou0q9tuwQaMgG/VNV7G+HE5KCq/+PtVUQ4bs5HlPbGUgZpnTACNBJ/aTDDVLLPn
	cZQX+Qpv9s54j2TtscJbLlR4GcBYfH6AO0ipr+4leZl82RKOccPgZvjJA+Ua7hgtzJMOPqSjnI2
	1Haii11LR0X1Dk58uG9nBZ1lD1EyPlKSviOfcHQBMj2bFe3EHPWuDyTLxfg23axt+xQimkMq0/5
	uhmKmnqBDGahl9yYY9RLXX3MvjLcD/9T/cz0Grm3aKG65d7ZbdvH3j7TkLha5ZRclL0u0P97eZb
	jhdt+53wAc8Gvme6rXn/mZomgMNr2vP7/CdiIc4GWFMXSdTYA1ii3HeRoMpBpChjcMPnzn5cvNa
	76kuiC5hSPoIX5pwagczc02uGGLeN6eiGt+LSeQFKqV9Q9tYSDSsdpBRhLSd9KUEQKzwtvzzuTL
	/2zMFF68y1x3inoCOfAy1nXBJ4J23clauTZq2UUL2ak/aSbFpZtaUNjMgJNsaE3cz0XQguGEXrW
	MBLgLjL8YWAYW5Va0KCBvLAMl2mXkQCPQCKv/a2V687T4Wp/SN+rOb+46qIDDzjKofmzwc2WX6h
	DWzyxaTeeQCHicOzQZzokEomVcz6gJZUDv0XFYrVJQkS
X-Received: by 2002:a05:701b:4584:b0:163:c5eb:d42f with SMTP id a92af1059eb24-190a0428eedmr769830c88.5.1792550595143;
        Tue, 20 Oct 2026 19:43:15 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:97d1:a8be:236d:bf79])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19035c0c9a6sm2392047c88.3.2026.10.20.19.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:43:14 -0700 (PDT)
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
Subject: [PATCH v6 11/13] zram: allocate bounce buffer for spanning objects
Date: Wed, 21 Oct 2026 11:42:21 +0900
Message-ID: <20261021024236.1787884-12-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
In-Reply-To: <20261021024236.1787884-1-senozhatsky@chromium.org>
References: <20261021024236.1787884-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p46xr8z7qpwb3acwih9mkrtkhr5praxs
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7B17720006
X-Rspam-User: 
X-HE-Tag: 1792550596-935481
X-HE-Meta: U2FsdGVkX18Kp9oDPHUQe0KfSW39ljimsPgqbAxW9C5EtQ3x2spo5yzfGMz4MMVFORAVHLc40K3N0ZoXQ61trHz1f5+eIbFAm9QOssXjMJdfIdvH0s7QPUtwBZ/0B+vn3CydIwKOFNhkqA1q+nONGP15jPBcZBv0XLNB/Ru+yDvfESDyuggB24g4NKRyjOXEngGWvNvUO6dCweRRciLQ0vk+Q+j3YAQ1BizoDVJhHM5K0Vk8C3bAwvVUw0PWj6+Z+gIR9lLrEYj1OlLv2aXo2xCuMlhytR52SljQDQa4TcN1A5S+8PW4f6eVTA9lGYVDYDlyQZzWyk4zvgRcNc+Hb/0n4MjiQmoYxa5pji/jAl/WmUskchpnUn56AKhWOzFprws2SlThRZ/rPPayhJdCksxkfsO4fvsMEx2R2kYWc5LkkG5DUwFJ+UFbF1HmtOEeBRIDBuqRUaJ2i01yMwg7fSfW1dqCKZJhRj4ced7+/Z5YzRm1Gg/u6lfo54bPTO0sH6wAo1eqW0g5qv91392q3d6bSxD8lQvnZV+mSa0y31GRkDEo083n6rSb06lKTjW7buy1Ou3jjIMhBEh7BhZ+QHjC+kx4w/jyJmsSA7pNkzOdXcz/nU+lQHYtcGYil6aQep9OXwWxvuA7aVrDDbXWD6TbWKMfIUAVTkdQkjV7YekddF5xvy/3NpIpiW+2kAfEgS53Dz13pVJ6Oag/A4B4XWuF8kHdeYfucMRswt5JNn3P7dRZtcX5cVuhMwxi816FDdsm3cf+FAcOle6dbN+6ikc89+ytz4iXTvif6Ye5WbOVxwSUjEuU4KexWiG/79eBUM312Lx+99Fx62f3BK0lubL1i9QOB+jc/Vw8NH3uIXHV+EfeYxqrxnec1Wu+roOy2dRtdilaaGkCo9v6oEruIYXdHRRfqsQ/2T3s9f6Vnvg1xeaef6I1P4XWGD5l5nW5JhRgnd+jcQzLoCmGJyg
 lH1EDtKh
 QYTFPrKvmm6zmBBmINM3UEtKnRUM54Y7mm9gs4RaHTP5BX2aNtDLltjvTPk0tD0x8uM/TVIViB0DEFtqq200frFeXzoOT7OAZWLHmuDHj6/R7xnx0ywK4bKnIae3JA/UUvU++ewQsWneYsZDMES2GA1nccnkK5OLypkFo9zZZkmL4r2kG2zbwgzjLb9Xa2W3UiCTJW8ItR5YHKt+DJc4haMY+SdJmch4Z5J/PBeKh622VPV21m5UVD1Y2CyydOuZuzP56moBp5yYAJEah+DpZOcQsKYacAQoYtF+v6kCR4N+cu1C2ThX0cHPEikcWPfLEXmGdwZC2xRK4rx5uWo4b2X9yjqPyIDHWR4Yu
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
 and 24 high priority readers), average of 3 runs:

  Metric           Base               Patched
  ----------------------------------------------------------
  Read IOPS        1,452k             1,466k        (+1.0%)
  Read clat avg    3.46 us            3.30 us       (-4.9%)
  Read clat stdev  165.37 us          15.69 us      (-10.5x)
  Read clat max    306,679 us         7,060 us      (-43.4x)

An alternative approach is to vm_map_ram() scattered objects
(two pages), which fixes the tail latency in the same way,
but deferred TLB flushes add more cost, so it was rejected.

[1] https://lore.kernel.org/linux-kernel/20261014153603.1365617-1-zhangbo56@xiaomi.com
[2] https://lore.kernel.org/linux-kernel/20261015112440.1491168-1-zhangbo56@xiaomi.com
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
index a34859ff0461..b429c52cb37d 100644
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
2.56.0.212.g129ede20d9-goog


