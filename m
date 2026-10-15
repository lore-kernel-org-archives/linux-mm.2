Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A0AECC6B30
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 03:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 797D46B008A; Wed, 14 Oct 2026 23:19:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748F86B008C; Wed, 14 Oct 2026 23:19:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 637A16B0092; Wed, 14 Oct 2026 23:19:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20B936B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 23:19:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 87DC314088D
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 03:19:57 +0000 (UTC)
X-FDA: 85323406434.17.4DB5952
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id B3895100003
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 03:19:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="itXG/BTk";
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792034395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V9QLU7Zy1JxvuPwl1RadI1Kh1ZC3AW3elrtvC4EPZVY=;
	b=Fg8j93dNJJbWCzu/FHPK6lOqZUKpsPu4ztL5Psgkw3qnuoAvHV2FBSDAWkJjQrZqqzXkSo
	NL0qxitB+qKxFwczh34EIbjn7ENaLj+dvtXE2lRmoElJe/aWfXaJKP2y3E0PJwA8dl0uf6
	BL3HEJ+K8EJzQa+JjNiS32+c7j5eN/k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="itXG/BTk";
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792034395;
	b=mw5skMSdj5d725EBxfLOIKwLMwJVCQbdbjPOhKhmSJbkCskFPODdHqmWnpWyEKe+nxJr8y
	zNSiXjMHWjFRGI/3/9/40gQhEcU4abLEsa4OCwuLzjJcYwXAUllPXy7JUSHx60LYoJQY8b
	+A9C98LbXbvXl18V5r8pCN0t+Crc+dI=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cc7e79c1eaaso2160256a12.2
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792034394; x=1792639194; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=V9QLU7Zy1JxvuPwl1RadI1Kh1ZC3AW3elrtvC4EPZVY=;
        b=itXG/BTkZ5aBzPYkbwtY3xzxgkL4fnESpAeRJJfmJyI/oLxuVQcHA3neT2WZ3eS6pj
         ndLwPCnN/9NkUnFh8Ap1l5+RdaNq93PhR3dTcMaVTY0Mws/OWA09jbPnrrrPbQDQDgZX
         gwomeEd0tB/hOf/lxsyVmspApnQPQSYeM2L6c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792034394; x=1792639194;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V9QLU7Zy1JxvuPwl1RadI1Kh1ZC3AW3elrtvC4EPZVY=;
        b=URzFeYwEzQ9IONP1BqhwPpqVj//17kqaU2aYo/ZpCL/IBY1pKXF4KxsCQrZ6eLBp1Q
         fgVyycOGBBqy4OjW4p/CfiM/F6PFIU/zjWCFqHwchKh41O4IXkF7RcwPHTLGKkQNr8NX
         pV24DjnyDhT00JJGXUJS3tBxms5SC5oe9X8DLZ2ZbwlJDI8cui7cgXC7M3FFKUlNLUXm
         zgAMbXCQLAozwj5FPlIZecctsoWCVjRESfySDrKb/ZNirLjWlLFMklVIaghQOFxHFTgf
         +BAaPnPjHZrq5iZsxCn56B38Ydj1rHxYKaUQvxPo63OtlTPOP7zAV+iTvwyY+HQwle4a
         pRXQ==
X-Forwarded-Encrypted: i=1; AKwUvBymTBO4eQ14i2vVMTCBIpega7dipoUSHUKAMqehoGA4F4LTxm8C2lkONOJ9NUWFyZiqjlvS00+bAA==@kvack.org
X-Gm-Message-State: AFq9FYJYK+zebhxRiN+wtwYEy2BsFnq4/eualun9VAiJ/XjBPCtTbXbV
	bcLqz1MEnVG3zycd5wzxavOH8zkKWMVNp4ejStBircwr96WA4M48RAgAf0LMx5sSQw==
X-Gm-Gg: AYBFou2/iNFP2nADwBCKTiFLkq8oCplmfrICXzQZUA2SxwhrrrrA1bJDpkYkoakYbNP
	dsVPFA5EfEWSLyZmPeEoF0/moWojJ5rBD1XIQje93uJlVMPgCJhoX4gmmDaVFFX9WH6DfRjLyKI
	CUP1QrGMf56uVT0yZ8vAsj16whpv+JBtKH5n7PFY34CFtnNPob7WHWy8MrRUUTxpMwPng3qJUdY
	Bt59FNeDBa//W44Eb2N3inR+8sFa4I0Rinm2tyhq1C2DjgGDsA08muBOhojgCt5TtxeHA6G7wwx
	5HH8oMJsaTMMoQ+iUO8BuCydGHRrPCKwnAoVwy747/1sn7iqR4Ra1L1etvVADIa7Uo1NHO8d4+a
	afVxr5c200/4DiYOlkTI+6jX7uP1+OU+iEI5/ziR9WZS+6fMCnDFTxPQ+yygH3LiG6f78Br19ez
	iBgdsGGI723l3iYgsxmhCyCJXztq5MWMwxuLLuyB+80HEHf4QvMvUDBs6uu7C6Qm7+u65PhPdNk
	J3+c77mEA1i1GpZJ1qW1u3gYoEgkRDP0hVVTAI=
X-Received: by 2002:a17:90b:39a4:b0:3ac:8ee5:e007 with SMTP id 98e67ed59e1d1-3ac8ee5e69cmr1654880a91.20.1792034394534;
        Wed, 14 Oct 2026 20:19:54 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:8455:7899:5a2e:26f8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac93849da5sm1176737a91.4.2026.10.14.20.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 20:19:54 -0700 (PDT)
Date: Thu, 15 Oct 2026 12:19:49 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Bo Zhang <zhangbo0325@gmail.com>, akpm@linux-foundation.org, 
	bgeffon@google.com, minchan@kernel.org, richardycc@google.com, baohua@kernel.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 10/11] zram: use rw_semaphore for decompression streams
Message-ID: <atBAWZ3WZvat3UA1@google.com>
References: <20261013035201.2809924-11-senozhatsky@chromium.org>
 <20261014153603.1365617-1-zhangbo56@xiaomi.com>
 <atAj9o5IgrAeiGiW@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atAj9o5IgrAeiGiW@google.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B3895100003
X-Rspam-User: 
X-Stat-Signature: hr871g3xnwuzbrx5bnqx1tga946i9yez
X-HE-Tag: 1792034395-262136
X-HE-Meta: U2FsdGVkX18eD7BZ84x7CNaSyVj4XhwfQUaBFRKOuktA7JcW1gyFPiDFauYd85SGs4OH30+0xZX+O4nZ01ll24O33iZp2+q2uVV+R3EjBsVmG/i6X/qh0uSNOaqJilH/2XJ7zI3FVnavYrMO3RTAPAY8oH/qyHC0KI2i4rh1bojEZljV3XQccurmUJgV4lAEqWJ/5ijXhAV/nP49WZLNe7k0MTMbyBgn53V+wTlO4X/WhZExqt/9fqyjxYwFOdhFIa5ebkHXt3I1znBRE7Vdi1Bf0ip0IbBquoq7nPRO8CQn84UIHZwdow+rRa7xyN6X1pRx3ym/uxt3oHn0vQu7x+B5vq3iDxH0dopr5fxZQpxIllrJN/MDLaOFhzkXr800zFH9P1K7+tMB5fZKm5AfdrY1EhYyYvPVbB/4/GLk8CN05N0af5hLOOWwMSLflveReGQaye+/e5Fa64Z9zBHCxuAb8rjFaA0N+0vivlc76SvP2FWJQ7kwjMLz+iKr2mlAcddebUXcTVZzYPQE1CQfV1I6WDi5H8UEyK/l+IRTqWTH1Y5WO/VT1YJlST5RHG53IXRNNPMyQ1zkOZ5l7xthrT9aiO/1lyqre5PlmC1nBCo8KeNzjb/mKRdJ7M+UTatWYeYPUEgnSxtvzMIJcwAUmk1wHUW1kpheXv0qPChDNze4lx/mhL1zgnTuXtwEQwL7eycn7rv56ALxv8xOxQmXjntCw7YwreMFnxzod/2v8T9vqFoFkAZGsVEM9J5L1W8fi3v/8Dlnw/KDNxtrKgbKhnd+gk6IB3uC9GPgExdH1fdQwHAoW9FSDoZKv+2kVEzOHM8WEBxCkg9qSRUgRGXk53Aen3rDYuZmFJsjSEzEQYJ/5zsrj2qwP3vn9pvP0vesc1Z5CDRdaPqH7woyiirOT/5aweHz07AS+IEumVgD9zCXfI9zxyiOvcN8ybeWOkIzXxXk9fTbe6bPXWcqQ1R
 ejvnYjHq
 hpFaC9cjLvPTsQIB5qBxcQiAhYJCFv9DKIZyS3cW8Cz/WMQcRyyR3op/fQIp6wLQcz8Qmy3snT4Igj9MMG0x9dNg/txrF9pCnfvPQgHMo60Ma7r1EZpCPLfpFr3V4oybsdMtFgVUQsTS4D6yrPCJZXmGS1EIEkd3PEfLQCrbrw8y94py9QD4Wa43Syj3xsuyE5CsqjtMzxd+WuJoUSHd6LfYI/8z+zAzsYPZzp9FLFFO0YglHk6iHy5z4UiTaIITcp24RsleYTLA3p9zGmQt20Ty2z+PB9DEm1khXRuh6WxvoA+38BpJAeCgQjls8GQiU0x1NaQkaklwhkzsD7H1jr/DWDnn3FF5keMXq7PtG6PZ5rl5/XT1WvcVBel9VRo3TXuS339W3DjnPkzvYlA3kC1A/tQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/10/15 10:41), Sergey Senozhatsky wrote:
> 23.3% is a slightly high bounce reads number, basically almost 1/4 of
> reads are exclusive.  I wonder if we can do better.  Technically, the
> number of bounce reads depends on the data.  Data that are not compressed
> good enough can results in much higher numbers.  E.g. if most of the
> objects compress to say 2500 bytes then every second object in the size
> class becomes a spanning object.
> 
> I have a quick and dirty patch that turns ->local_copy into a fallback
> slowpath and uses vm_map_ram() for fast path.
> 
> A synthetic fio test in VM (reader vs reader inversion test).
> 
> BASE (local_copy + excl_lock for spanning objects):
>  Run #0: 1,434k IOPS, avg 3.74 us, stdev 443.11 us, p99.99 23.94 us, max 741,374 us (741 ms)
>  Run #1: 1,465k IOPS, avg 3.36 us, stdev 99.88 us, p99.99 26.50 us, max 187,415 us (187 ms)
>  Run #2: 1,454k IOPS, avg 3.51 us, stdev 171.87 us, p99.99 24.45 us, max 257,715 us (258 ms)
> PATCHED (vm_map_ram() for spanning objects):
>  Run #0: 1,471k IOPS, avg 3.33 us, stdev 14.69 us, p99.99 28.29 us, max 2,844 us (2.8 ms)
>  Run #1: 1,463k IOPS, avg 3.32 us, stdev 15.93 us, p99.99 24.96 us, max 5,182 us (5.2 ms)
>  Run #2: 1,458k IOPS, avg 3.34 us, stdev 14.70 us, p99.99 24.96 us, max 5,619 us (5.6 ms)

Or perhaps we can avoid vm_map/unmap.  A slightly different approach.
kmalloc on fast path + memcpy (zsmalloc objects are strictly less than
PAGE_SIZE bytes)

   Run #0: 1,475k IOPS, avg 3.26 us, stdev 14.24 us, p99.99 24.45 us, max 5,617 us (5.62 ms)
   Run #1: 1,472k IOPS, avg 3.27 us, stdev 15.35 us, p99.99 23.94 us, max 5,619 us (5.62 ms)
   Run #2: 1,473k IOPS, avg 3.29 us, stdev 15.37 us, p99.99 24.45 us, max 7,190 us (7.19 ms)

---

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 39d1f9384939..1838057475f4 100644
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
@@ -257,22 +256,37 @@ int zcomp_decompress(struct zcomp *comp, struct zcomp_dstrm *zstrm,
 
 	might_sleep();
 	lockdep_assert_held(&zstrm->lock);
-	if (!zcomp_shared_decomp(comp, sg))
+	if (!zcomp_shared_decomp(comp))
 		lockdep_assert_held(&zstrm->excl_lock);
 
 	if (sg_is_last(sg)) {
 		/* the object is contained within one page, read it in-place */
 		src = kmap_local_page(sg_page(sg));
 		req.src = src + sg->offset;
+		ret = comp->ops->decompress(comp->params, &zstrm->ctx, &req);
+		kunmap_local(src);
+		return ret;
+	}
+
+	/* the object spans two pages, linearize it */
+	if (zcomp_shared_decomp(comp)) {
+		src = kmalloc(src_len, GFP_NOWAIT | __GFP_NOWARN);
+		if (!src) {
+			mutex_lock(&zstrm->excl_lock);
+			src = zstrm->local_copy;
+		}
 	} else {
-		/* the object spans two pages, linearize it into local copy */
-		sg_copy_to_buffer(sg, 2, zstrm->local_copy, src_len);
-		req.src = zstrm->local_copy;
+		src = zstrm->local_copy;
 	}
 
+	sg_copy_to_buffer(sg, 2, src, src_len);
+	req.src = src;
 	ret = comp->ops->decompress(comp->params, &zstrm->ctx, &req);
-	if (src)
-		kunmap_local(src);
+
+	if (src != zstrm->local_copy)
+		kfree(src);
+	else if (zcomp_shared_decomp(comp))
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

