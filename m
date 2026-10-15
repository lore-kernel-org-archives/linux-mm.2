Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1103DCC6B2E
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 05:19:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5B186B0088; Thu, 15 Oct 2026 01:19:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0D2E6B008A; Thu, 15 Oct 2026 01:19:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D4256B008C; Thu, 15 Oct 2026 01:19:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B6D76B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 01:19:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CDC86408A3
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 05:19:04 +0000 (UTC)
X-FDA: 85323706608.20.9CF18F7
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf12.hostedemail.com (Postfix) with ESMTP id DC98240007
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 05:19:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Hhb8U3Wx;
	spf=pass (imf12.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792041542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aL42kwtpY9xz2nUxaLVspyn822mepZz266L04+MLaso=;
	b=jNSbOM/gmQOfWa0ePt3emmiIaUqC3R9xopZbx3UmaK3xOV/Jgy3Z2MiG2YTpqYrQFQvpSH
	hi3sm9zoRUrb2PB/We/cpiYsgNN7qHcbNtduKVRVL1pkZcERBEN2lFWB1s7By3mW+n3N1Z
	PoEGsev3vqN8tBpWf9PG0ShoSDk6PTA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Hhb8U3Wx;
	spf=pass (imf12.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792041543;
	b=PT+29tdt+BPIjNX7a6wKtiHXVE3EgmFaL6vdvL46w+tgHGgGxKsyadz3TplxrEYYlI7cZK
	BSbDM3RgNh5lwrcTqYn3h1tkoiBeOt5oi96vcoGKbPh4g01hbIb3FFyyQgDCdVMtB5xPGp
	Jo/35U8SiNGQNFnc5WjCqjeQBS68yPk=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2df8c28a0b1so22764385ad.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 22:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792041541; x=1792646341; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aL42kwtpY9xz2nUxaLVspyn822mepZz266L04+MLaso=;
        b=Hhb8U3Wxn8IS7AsnA6obZ2DumyUCq01l9SkqMS+uQT13JtQppKwlLtkWjVb+qK9DUx
         PlzADdbczsRr+CfVrDpsWa0Bl2Pz4wTM06y9QIn/9Nq/qdRq8M+pd2KuEGg7n7chT/Xf
         sUDZLaq+H7hmPoTlfKWNSAhnMDwvnvqT7jp7E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792041541; x=1792646341;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aL42kwtpY9xz2nUxaLVspyn822mepZz266L04+MLaso=;
        b=uwtYrUklsVwSHtExA0YwG+RvzZx8bL+HhHccOoHxwNHNrYrHOj2xzfgVWq7RFZFVu/
         sx6FcDMBEsu4+bKzn/ICEN47OkbRaexS+jfjrAUR2B8LI5t6/a4AmddB8EIL7N0k7owf
         FoXWf0N3AEWWPSmWOG3+eE6t+vSLQuuPenlCc39KPVhciLLJapgUFhoehXEXg+l2YvhL
         xiX2R/n/b4Ipoth75wt5BJJ7zmjbtwwzo6X9mgWM3KCGECaMSq/gxGSydpIGd8i3HH9d
         vGSVwdsxNvhVbIEjFAtBVW+oWcwmIT8RhavDiY6f3iyQilH9bSkJA6pFD1mb90JkURCx
         QDxg==
X-Forwarded-Encrypted: i=1; AKwUvBx8rvzfhB3WLpuOq4bsKl/GUjAo5uoISRhwMNrD8X3s1nlQ48mLz5pqgLXd1xtnm6dBShRVJj4FMg==@kvack.org
X-Gm-Message-State: AFq9FYJ/91yeOoQQ7HVjnTYHQ2wVAaLrMX9cHdiVgRYwhHfKBGOqH13w
	w88YfzpJ2/AbjItRjRDasbjdqBqvM+a5Yurb43r/5ZHt8QUiLNEFu7jxGsWUQqMLbw==
X-Gm-Gg: AYBFou3ncdxwZ7+O027GgG0lm5ou6RRrH61+MY/Cnvf9XyJIVjJ9QhIrMYVTAqOzTLd
	SVWBfrJsg/Y3toTvWg3a7k0oH4oCLbc2SBvrW29dyOFLlg2CSeZ6rdxBhuXkwkGZlMTdav36+v0
	kETsHJeyBGqqdZyY7LLd6dQaLWfN1neAlwnU+BtDQIuSHVGaokDwdN8mMWBfYV1+8u0/FNR3YSV
	onADaQWt1Nz3fmbnfCiasEHaQtO18PsXo62uScBrWvMX7nDjfeIAKSPmLh9RB+I4+KqnKlH1qnX
	OYfQMmQTWwKN4SKATW5Sn+blcOtjqaHMZQeq7mcjBM4YPAR1VIJu60wrihoAlF8uVLfAI6J0WZE
	Jlg/S67KkPUnSjAnR+doRXa1vlrBEJyDHNn9w/Fn1NX8XtUCUi/hVqQjrtcE164IFu3OuOftg9K
	yDFWbI1+F+VQm2UaAg8yFbNZ5+IUjZq3HBt6vO5RhM2PhzApg5EzJ6m1scxWZJDctzojAt2bxmw
	Vcd2dVVUDWCiiyEvZa7V7Mdf39UUDeIE+kRrZY=
X-Received: by 2002:a17:902:e748:b0:2dd:c053:e669 with SMTP id d9443c01a7336-2e842ab7902mr153442525ad.47.1792041541599;
        Wed, 14 Oct 2026 22:19:01 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:8455:7899:5a2e:26f8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8421b1562sm77412345ad.34.2026.10.14.22.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 22:19:00 -0700 (PDT)
Date: Thu, 15 Oct 2026 14:18:55 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Bo Zhang <zhangbo0325@gmail.com>, akpm@linux-foundation.org, 
	bgeffon@google.com, minchan@kernel.org, richardycc@google.com, baohua@kernel.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 10/11] zram: use rw_semaphore for decompression streams
Message-ID: <atBh9xfpOji_A7A_@google.com>
References: <20261013035201.2809924-11-senozhatsky@chromium.org>
 <20261014153603.1365617-1-zhangbo56@xiaomi.com>
 <atAj9o5IgrAeiGiW@google.com>
 <atBAWZ3WZvat3UA1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atBAWZ3WZvat3UA1@google.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DC98240007
X-Rspam-User: 
X-Stat-Signature: ygdkipighy6q9y5gfkmwaoubqfkpgqhd
X-HE-Tag: 1792041542-908803
X-HE-Meta: U2FsdGVkX1/r6gxKBxtDxrKR8GENfZWOB0pg2Ui17q2xTWDW6mROf6DeJFK/detckMtSCacXJVEZYgD+Izjp0LCWGeABpV7HVJIdDfviYREuCogjvyhMylAZ4bK/2+/aKBCekly6r8PZgLnj+CfY/oryAMgkBzzJX84qzHDpeyBSaoG2WFnoK1fy/45SYzRO5rwYxyHeBp0CO/uJub5hpZbCZN3wyrnYU42lNUrs+IcIwzMnRQZvcfqAgYgYIca+cCElbAo1dZJ+6H5tJkUxKwhSxt2aZMdRltsCA0VdBl0ABb+WWu0aTJavcJx4ga9RV8t3Gy7bof43mck9SaF+pFGeN60nGP0QFM+jTBmoTJInraqkEMo3Ap3RfM8YhmY3tewlEXCekWfoey4MCloZJKKxhrFz+917QxDecKqe0eOeqRA3KEKUg2uuRKt0rsg2k9Wilqdd8EZydphl/4fqUX8Xzh8fpgawELu3KeagXYF4MT7jKWuD0gUCz84ahCso298kLum+0Md3KIX1/T8BhJpsbaaDCvlqVHCzTODzaqPbC3iy3RkpUtBDL+/OVtaSrWjG6e9R255UkNiyM+Fun99FNkZ3CJh5Rz/tQloVkK5BZ57re+N69eRlAiJNVHAjaL52zOW26EbHTKCj9zRzF7DCs/LypbMaE69Lpn9oM83zylWOhgFf/USat9hx9Jmtn38wMvnEuw8EBkrd0/wp7aLCrjsITmOX88aR74l/JkO/sBQeh99KipZn3+5KGHofd8DY6xh4CY2urcwziZgcyJEzWhe+Tn7E2OV+EPxHGvpqLPTrd6IyuQKUbeTaz7SqTwXAeCy7mG5Mt1EubtDj4uNjWj4PcafdhBfkQ+6vKpP4gx/k29jSdrApMO73Y1lSY9V4BJRRu4PPtjCVg9nGtMBYBu1g8G49xUKHeeyAYeeqvGImkAH32Ow8anPAx0xcMojQBwbrAHDQRAjXrsk
 64No5nHo
 wAUPwlzAvYPQQrJlTEPt+8IqfllEzYsNAv2k+xpUHnx4jyR70mWaEwBYwDptFvZzLfK7hiaAI/go8P+tFQsYQNeti8ArisMkQ21IN3Ks4snGutzWjCPYorhUw4OjJSEiOGn5rrxuJezm/t+4rkHRR6UJtFKIJ2seR2dJ29qD8SJmUlT32WgHeWKekVbmzTNywA5wAjYy+HOI25wDZfw686gUVJlxyoPtU7a1pbAsFGUvbPHXzTsHGK/ICDKCJ4pOjhS2AndPHD9ENkD56qv5i5ijoVQ1hJhlHEI9Pq94ma/hdhG2EfElgH+CgcBmfAsyW644DOGeeEd/tS01gmg/hCiOGGpEA+QOAirMVkhy8DQUdJfZRPqSYgt6ekY5ekYo9a7I3D8iGeuS5BmwME1HZpTrJIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/10/15 12:19), Sergey Senozhatsky wrote:
> Or perhaps we can avoid vm_map/unmap.  A slightly different approach.
> kmalloc on fast path + memcpy (zsmalloc objects are strictly less than
> PAGE_SIZE bytes)
> 
>    Run #0: 1,475k IOPS, avg 3.26 us, stdev 14.24 us, p99.99 24.45 us, max 5,617 us (5.62 ms)
>    Run #1: 1,472k IOPS, avg 3.27 us, stdev 15.35 us, p99.99 23.94 us, max 5,619 us (5.62 ms)
>    Run #2: 1,473k IOPS, avg 3.29 us, stdev 15.37 us, p99.99 24.45 us, max 7,190 us (7.19 ms)

Just a better looking code (but same idea).

---
 drivers/block/zram/zcomp.c    | 47 +++++++++++++++++++++++++----------
 drivers/block/zram/zcomp.h    |  2 +-
 drivers/block/zram/zram_drv.c |  2 +-
 3 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 39d1f9384939..81f21bad787e 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -181,14 +181,13 @@ void zcomp_cstrm_put(struct zcomp_cstrm *zstrm)
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
@@ -244,6 +243,15 @@ int zcomp_compress(struct zcomp *comp, struct zcomp_cstrm *zstrm,
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
@@ -252,27 +260,40 @@ int zcomp_decompress(struct zcomp *comp, struct zcomp_dstrm *zstrm,
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
index 924c4185abe9..6764818d2a9f 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -115,7 +115,7 @@ void zcomp_destroy(struct zcomp *comp);
 struct zcomp_cstrm *zcomp_cstrm_get(struct zcomp *comp);
 void zcomp_cstrm_put(struct zcomp_cstrm *zstrm);
 
-bool zcomp_shared_decomp(struct zcomp *comp, struct scatterlist *sg);
+bool zcomp_shared_decomp(struct zcomp *comp);
 struct zcomp_dstrm *zcomp_dstrm_get(struct zcomp *comp,
 				    enum zcomp_dstrm_mode mode);
 void zcomp_dstrm_put(struct zcomp_dstrm *zstrm, enum zcomp_dstrm_mode mode);
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index ad244624d4a5..e608769bfad5 100644
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
2.56.0.385.gd3acb90ef8-goog


