Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45382CC6B2D
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 01:41:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA0896B008C; Wed, 14 Oct 2026 21:41:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E02D96B0092; Wed, 14 Oct 2026 21:41:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF16E6B0095; Wed, 14 Oct 2026 21:41:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9A1E66B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 21:41:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28368A08C0
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 01:41:10 +0000 (UTC)
X-FDA: 85323157500.07.D64470A
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id 54E521C0005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 01:41:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=e+n2rkXL;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792028468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Rn/uJVhfyYtA3tBXf0jKeMnRRwU6eZkuv2ioiXCGGw=;
	b=q299lbiSD08PbM842iVy/JTc/W+9vv2ZJSSydYt09AyCSFmde8i9QUFi1KpJJgXeRJ1hq8
	y6FsO2eEH+P18s7k9njhbGpZHgwTdgctsONQFS6zIHoLcKpKUWlogXfcE3XvmKov9hd7zQ
	HP5939Syc7Fee5/OJ69POTxZ5/Z94JY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792028468;
	b=owPTiRp+vIGT3RekhAlCqogcOIRWlOC9S3YJ3uSM1QklH3YKxJ8KZgWoYXujTXfgBpcgUd
	3iyScorviXZUGTR5uLSO5eEydVzqIiJm0Z8Ge4+9+SSmE1G1MfS3oZXD5el2zEcbkKvm2w
	JCDtFsXJHPHk54c6BayF28kZrtxGjmU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=e+n2rkXL;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2e82462a3f1so9131385ad.3
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792028467; x=1792633267; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2Rn/uJVhfyYtA3tBXf0jKeMnRRwU6eZkuv2ioiXCGGw=;
        b=e+n2rkXLigh+G+KHbskuutaukMxg+G5+KKIrvimGhy+uI1ENQMMH/MSSdxIHtMtJpR
         9rWVBFSUm0h9xUBRoGwxgzSVrooZd/E/YY17KebF1FNNlpfbQO5SfnEAJUiJ0Iqxt5ph
         xI2IXEnAve/EHP9X02VxznsQYi0HVD7LHpRVc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792028467; x=1792633267;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2Rn/uJVhfyYtA3tBXf0jKeMnRRwU6eZkuv2ioiXCGGw=;
        b=FXkNYbQ99s4tEExDw7spq2R86aTygxyTr2X7fM+0j+tw3jGxOKxByuaJNgDFX8m5OJ
         kk8FuftCLF01tbrII61QT3VwlyYGsjdzQ6PIL5z4ihRy2GAB2paaPwWfpLZJcAjDoBEy
         YKzwvdLfUAmmPdhvxG2UQyF1A87tuXXr1J7V86NI5+z+GBbpvDn5JNccEqmnnhBDBnEN
         UKJPYsQjtM2vIhGesDgo/eUBrJVeFivllEpYzedzCVRtO+sSpaLq2JOlBpuvTbBgViU4
         lwajD1XwBFd59Pv9M71jbb5CEknZC3khS+gcBAJJAh/syVXIWUPLFgNwSf3l221oHJSi
         stFw==
X-Forwarded-Encrypted: i=1; AKwUvBxxJiiOVhRzKcWLSIH1xPk6yiswXmvxP8bmZexgX2q79DTid4QCpfW7uKRilr45bewSuomKYaUQ0A==@kvack.org
X-Gm-Message-State: AFq9FYJzGkmvGaNNfg2Sjka8Kk1yl7OIrpUyEssQHkUKigk0L9pD5oD4
	H3hdR6UMVtxUzNk/Zjv+Golxmz2eKxY8zNiBx3vUvMwGGvfOEEGQsiBOvoJybcz7ZQ==
X-Gm-Gg: AYBFou0DIO3joULG+fg1xdnmP6rxYk9bDRRlA5YbTQQ2hkPXMncrwcn4XW8zSsVqiUm
	nb9aoJ/DRtkCuY5kmGaJ9uJaXjV0vsQuI8+K1JDLdfKZKQfqdGchFxBo7ENXsviTfGEgYH8yYCT
	qZkSzlTOSO57vOUi7rGcX5QXB8DyxzGaolShgFva5rr1MtKlKhDvYTfLLmTgosKQQMcsuc9id8m
	at+o3hUF2gBMJt77G/BiBCzPPgg629elyKfYnh2Id6llr4cipqBfwkNaiHPZbK2VNfLMf4L2bAj
	8h/E7vy9MuLKF2x2mxrPX0d13wEFbXVEMskGBO76H36lIrmawhgLTaLXXWKqdQ9IBRTZ3umdABa
	tF2sXGm+aeuMUYSOsD4PCzu8KArWJlojhutplbvsuiCheuYJxDbKN4F5i0dTmyTnaosiF333tMn
	DmY9QkFphidwMbJC8DVeNCoc8GyRdCHtAxHgvgbGUGN1snI6OgFnY3SaCCmscqDlL1/PQoyswwk
	dbQBd/8mW12uOexOak3vwJ+KcLAUfGyJGe/06l4LJpIfuzjPw==
X-Received: by 2002:a17:903:19e8:b0:2e8:79d:15ec with SMTP id d9443c01a7336-2e84280afc4mr161603165ad.6.1792028467036;
        Wed, 14 Oct 2026 18:41:07 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:8455:7899:5a2e:26f8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e94ba30f6asm9486375ad.57.2026.10.14.18.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 18:41:05 -0700 (PDT)
Date: Thu, 15 Oct 2026 10:41:01 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: senozhatsky@chromium.org, akpm@linux-foundation.org, 
	bgeffon@google.com, minchan@kernel.org, richardycc@google.com, baohua@kernel.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 10/11] zram: use rw_semaphore for decompression streams
Message-ID: <atAj9o5IgrAeiGiW@google.com>
References: <20261013035201.2809924-11-senozhatsky@chromium.org>
 <20261014153603.1365617-1-zhangbo56@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014153603.1365617-1-zhangbo56@xiaomi.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 54E521C0005
X-Stat-Signature: mahgxnj6x6pjmef61ows19zzgkgkaerd
X-HE-Tag: 1792028468-175868
X-HE-Meta: U2FsdGVkX18NaHORm28yL9LH8Mk4GWaw1Uq1ImFMEZANx2sqcH8T/bTRihTs0s0ld2zybdLugAY2pGgV5spVXQBboHtUEGcHD4SxjcwHhktnRbRWueWNTRlBpPaJI1KbGoBPhTk/3NON3pWXqg1A26U1bWxY/0R212NJPOeHryfXqjbVlc7SW82UJAPr5MZ5LNyMIHJNSnMaIlmLzqHafgGAvLUMxdghB73cmYl/U3MMDN/EfrhHwyXcZFqvQXq2Drh16TqZsUjlT+h8i5jxks/IJNEOH2vqwjW+Lv9/hrOKeMlvUweewFPmoBAqwSPGxRwehZWBkwiLEywqPT6zoQS3HMq0zWOHRDuP/nR8v2rtlHi/mTDW2fh728wBtwnE4wSxbdBPmp/2MhsNTxzOLCWhyLYRzuP1aixJ9KZbiI68DV5BaiAg/inbuJe8iaX7z+50+U+SxntoPzO0KippRlkQuD5YS13lL38fS/gmCAd8wJDvGBVIekhdvsuHIkuoD8Z/0J1CHYsHNRsC1OX3xGDggFQj+F1WzLpT8KcHs8lpAakzySltdxtxz+W8Mw5x+fBZnrELf1O4yQNyHy1i1oyhf96Iy+tJSBElJX5UR6xypJH5Yu2QcW4gw9wPKmbyD4IP5XCuLR0Uta5mECNurSFz9PWDbWQ/f70zeVqvD91yNGEhR8EFQyNz5PJmL2uNBm3m7rGlzduqKbznEXWJdWjqUQbk3q7Wo/zRKQv8P/8LJl0EHQlIQoyLTlWAS3IUqvHGuJp2WDqdEaPsudPvHUVZYBlBk0xH7Q7h3+ePLKhu9teb7VH1RbtPeOUkIJui5d3gdeF3es9tjaXws6V9Jo2UrB5irw5ROWPLCye91M0HSC21KGA2ECyP6gxNkcQSpkeUqrIGlNBtz3LYYabPF9vS4CrRfqJ3sYSI36tIZKREFe8yUPuz52YDgNO/FvWoBnH6q7MLCfMCvVOTDnt
 cJtvCOGq
 PSyAdLN1YL6gmF44vBXtT4szHBqVv00RAoi0YCFPVKZdo6S3DOQFDpAY1VvGdASpJSLb5MQEIBe66O0nsvbkYdcoLL1gvw7dSMC+oZYDDJXYzUqifs1tLF0rM374DAyUNQ3tJFI4AUGGJ6iQ5/sab4K3wIP7GfUxRyjOHB3Wrmg4Q0HFYchLd8zyfZYyn4gX8IGPkV3ouEB447KdToC5e8N/PehcCSbAsOOZECaetTBZOBWOZEOJUnZeIhIk2vUwyO8TZ1rU9KBqaJHkjKk8+tSNfqLnEaEB2dcQy/S6s2c21oO863QbxR9yKFfdPCqSxXyeElZ4vCLKi00usAZuxM4jGhOxUBtjgY2v1vtQjHcJEqK17d1elIktETpHzOfJLxC8iOmxieHs0nuv7MedpQQbZ+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/10/14 23:36), Bo Zhang wrote:
> Following up on the RFC thread [1]: Sergey pointed me at this series as
> the reworked version of the by-direction split I had tested, so I applied
> patches 9 and 10 and re-ran the same A/B. Big improvement.

Thanks!

> I use decompress acquire count (swapped-in pages) as the comparability anchor
> instead of swap volume, which stays within ~20% across builds.
> 
>                       baseline   preempt-disable   9 + 10
>   read contended      24,749     406               1,959
>   read wait_ns total  239.8 s    3.78 s            ~12 s
>   read wait_ns max    757 ms     51.7 ms           72-96 ms
>   read acquire        3,948,150  4,305,078         3,510,610

So... these numbers don't disappoint.  Combined with memory
savings (and zcomp redesign) this series looks like a decent
start.

> Decompression on 9+10 splits into:
>   shared (stateless backend, single-page): 76.7% -> down_read never
>       blocked (dpin_contended = 0)
>   exclusive (cross-page object): 23.3% -> excl_lock, ~1,959 contended

23.3% is a slightly high bounce reads number, basically almost 1/4 of
reads are exclusive.  I wonder if we can do better.  Technically, the
number of bounce reads depends on the data.  Data that are not compressed
good enough can results in much higher numbers.  E.g. if most of the
objects compress to say 2500 bytes then every second object in the size
class becomes a spanning object.

I have a quick and dirty patch that turns ->local_copy into a fallback
slowpath and uses vm_map_ram() for fast path.

A synthetic fio test in VM (reader vs reader inversion test).

BASE (local_copy + excl_lock for spanning objects):
 Run #0: 1,434k IOPS, avg 3.74 us, stdev 443.11 us, p99.99 23.94 us, max 741,374 us (741 ms)
 Run #1: 1,465k IOPS, avg 3.36 us, stdev 99.88 us, p99.99 26.50 us, max 187,415 us (187 ms)
 Run #2: 1,454k IOPS, avg 3.51 us, stdev 171.87 us, p99.99 24.45 us, max 257,715 us (258 ms)
PATCHED (vm_map_ram() for spanning objects):
 Run #0: 1,471k IOPS, avg 3.33 us, stdev 14.69 us, p99.99 28.29 us, max 2,844 us (2.8 ms)
 Run #1: 1,463k IOPS, avg 3.32 us, stdev 15.93 us, p99.99 24.96 us, max 5,182 us (5.2 ms)
 Run #2: 1,458k IOPS, avg 3.34 us, stdev 14.70 us, p99.99 24.96 us, max 5,619 us (5.6 ms)

Just as an idea.

---

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 39d1f9384939..0a9bfa36f5ce 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -6,6 +6,7 @@
 #include <linux/slab.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
+#include <linux/sched/mm.h>
 #include <linux/cpuhotplug.h>
 #include <linux/highmem.h>
 #include <linux/scatterlist.h>
@@ -181,14 +182,13 @@ void zcomp_cstrm_put(struct zcomp_cstrm *zstrm)
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
@@ -257,22 +257,44 @@ int zcomp_decompress(struct zcomp *comp, struct zcomp_dstrm *zstrm,
 
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
 
+	if (zcomp_shared_decomp(comp)) {
+		struct page *pages[2];
+		unsigned int flags;
+
+		pages[0] = sg_page(sg);
+		pages[1] = sg_page(sg_next(sg));
+
+		flags = memalloc_noreclaim_save();
+		src = vm_map_ram(pages, 2, NUMA_NO_NODE);
+		memalloc_noreclaim_restore(flags);
+		if (src) {
+			req.src = src + sg->offset;
+			ret = comp->ops->decompress(comp->params, &zstrm->ctx,
+						    &req);
+			vm_unmap_ram(src, 2);
+			return ret;
+		}
+		mutex_lock(&zstrm->excl_lock);
+	}
+
+	/* the object spans two pages, linearize it into local copy */
+	sg_copy_to_buffer(sg, 2, zstrm->local_copy, src_len);
+	req.src = zstrm->local_copy;
 	ret = comp->ops->decompress(comp->params, &zstrm->ctx, &req);
-	if (src)
-		kunmap_local(src);
+	if (zcomp_shared_decomp(comp))
+		mutex_unlock(&zstrm->excl_lock);
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

