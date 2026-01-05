Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48E40C2A072
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 07:23:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54C9D6B00E4; Mon,  5 Jan 2026 02:23:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51A056B00E5; Mon,  5 Jan 2026 02:23:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A3A66B00E6; Mon,  5 Jan 2026 02:23:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1D14F6B00E4
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 02:23:49 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8595E16238A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 07:23:48 +0000 (UTC)
X-FDA: 84297070536.22.CF55A6D
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id 97BB340006
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 07:23:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=h9RTx+Fb;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.45 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767597826; a=rsa-sha256;
	cv=none;
	b=jW7Sgq5ro79mlK7REBQYfZiXeY+GLc3IWDVq19l1wE9q8mBknRKHlepRtylNsGoS64ncKX
	ZZsKMrjMlt8Qu2mQ+8kBXoAVoNOndYC1UtQ2SNBNt6R7P8bhzPCZ5pmb3SDqy1fhq5dbmM
	AwdSwq9s++KAV1RB3jgf5J+HIlwvDIs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=h9RTx+Fb;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.45 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767597826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QSxp5OH076gMrGxUPr3s0H7dbp9DxnQK1qQdqLTmlac=;
	b=s1aUaMk/qjJaGxj8CsgqWfu+j23t3TYMNILPKe9SU9fGXwDq+wbh8s1AGKQ6vgwJJtsHY3
	IEFklrPxeZJDO9dz/nGOVo6JX1bA7yMyxdd5LeC3+log9CsVQdGMFtwvenpHtDMgOPriAp
	AX+73W3sphKC29wTA/jbHTQTzpi+I7I=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-34ab8e0df53so13231994a91.3
        for <linux-mm@kvack.org>; Sun, 04 Jan 2026 23:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767597825; x=1768202625; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QSxp5OH076gMrGxUPr3s0H7dbp9DxnQK1qQdqLTmlac=;
        b=h9RTx+FbNJ7DX8KVVuT3ZgWmmnA2LEMxRwvxPsFRNowrvRZvWnfazWAcojKM/QjolG
         PjZnSVqW2VQJn0FQdmYxJWjQN98mLDbpPMnDaJFMNQLdvhGMDb4l6lgD+e7B2I1RqD3J
         9GuzIhYRpJrnzL4FLdnuJNPcBmu3PoYDX3y3g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767597825; x=1768202625;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QSxp5OH076gMrGxUPr3s0H7dbp9DxnQK1qQdqLTmlac=;
        b=PeUWjCe3Sdtz4VtnxBQqFt04i9dLRQ+oK7x68QbRG99JvyIqkmG5SUiF5JCWzoGFOk
         RrbnHPCg5fku4T6+rvy8oUWiTt2gYk2V/p1Uy8e8a8p33w+L0qhfIRVOc2gpxBIL2p0Z
         dhUjMxkIidj4ougy+x2ciCKA6iI9NG14xN9MdvEu8X1k7R5FC25tpXz07n0mwfaN0/tq
         m5uHTFIk/+A9d9TZbY4RWosKAdA0igSJr4r24TGZjyAFPlKZhXAHRKn5CCAu43dE/fdI
         MecAkWoTHlQn+hfZq5nExl7pdbq2grj0zFXQdJ1K8CkzhfCehUaqqOSJjNv42KMlg0wd
         b4DQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQc3WjLc5i5UD6k4PhIBHDAqHk3/osnVY3/pQ9lWKKS6coLjuxLoI9aPq1MwDt81GCE+Vsf3dUuw==@kvack.org
X-Gm-Message-State: AOJu0Yx+rLpwmkeNyVnF2d6K/rbSApOxYgcYn14tiXwq50jkzT1BFeLE
	EU58uqv6HLi/lSU1ZKPmeT4UKf7AguSqSwTWXaQNrxtSOjX9KAYKfNcL8m4nCCkVcA==
X-Gm-Gg: AY/fxX7vFWcCYSz2V7ECGO4TwN0wT1VcxWAO4/impuiqFaRqDADWszBl6QAVHTD3vUZ
	8Tlq+32up3ImbEMgT2lqzj6bEwQiMd6ih4PPCTMz2jWOKOz3fWCuKHIRpHA8JRPHJOc/ipYapFl
	ZRtffVlzKnR8SeTf6Mj2TeMN4TQOy8e7SVks8nmL3ZEIho+HgrKHKviQAtIp3gOsz0UE6ooYMC5
	3HfkAU7eYIUfaFs8zEkbcY4asIamhnc+nOjrGkUuZNLOEA/g26paX8KPPl/qtbvEBGAA8ex82w7
	qyI8gbqkT6w/sPlGXW6rUHujaNl9y6WsWhCr70ITfF34hwJuBRdt+nRQXo9qc/G5vRnNiWldCWM
	/7TptJoFyyygM1OvL/u4gv/SfOk+ZgVo5XjDhhOvQkD7/r92WxZgiFlwG68EZxWN/Uid/t2f7Bl
	wHwX1kyWW9yuw9f5Y0pqqBCSFEsncB33PogbJG3gk9wlBlwrdicoPCB2Sp8FRARg==
X-Google-Smtp-Source: AGHT+IG9b8NEn5tQUUjPXLsTW33wdMdtjEkBXF0N9Mx3x4wdkKXPA9twh21llcHj8xSlk9p5iMqf+g==
X-Received: by 2002:a17:90b:2804:b0:339:a243:e96d with SMTP id 98e67ed59e1d1-34e921f7bb8mr36771622a91.36.1767597825432;
        Sun, 04 Jan 2026 23:23:45 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:3657:db4a:faff:666f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f477077adsm5206179a91.10.2026.01.04.23.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jan 2026 23:23:44 -0800 (PST)
Date: Mon, 5 Jan 2026 16:23:39 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [RFC PATCH 2/2] zsmalloc: chain-length configuration should
 consider other metrics
Message-ID: <gdtbjepmea65zajh6dafxiekv2wmoerje7v3qxjundbezdnpps@f5ofogyw7wnl>
References: <20260101013814.2312147-1-senozhatsky@chromium.org>
 <20260101013814.2312147-3-senozhatsky@chromium.org>
 <ddfs43qldaws5urlnpah3ibp5xeu7st37p5hgdfajvdtwor4sd@fkcm3brinygo>
 <gg5zdpzrk47tljbnaudcy2gnsodyhmmar23qb57b67bhx6ntje@eq2fcrl2dk4z>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gg5zdpzrk47tljbnaudcy2gnsodyhmmar23qb57b67bhx6ntje@eq2fcrl2dk4z>
X-Rspam-User: 
X-Rspamd-Queue-Id: 97BB340006
X-Rspamd-Server: rspam10
X-Stat-Signature: 1xfc1g5ar7ikfmt67nxdk51rg4xy1dkg
X-HE-Tag: 1767597826-386614
X-HE-Meta: U2FsdGVkX1/rhP2jpBV4qBdc2AQQTk2wY1IzSRjk1csYPUze8shKs4/KK5a6PeUTe7KI+WDavKTwHIonkC2YQ+SrcAgAWHJvqFwX91/ggHzlHWUT52/ptp6GRfgVE2fOl0otOeg5AsEBMptzL4bCtB8sCjy6QzBk+NESMA3tVP/mgwNPZcyRcvNcNbYMppmlJuMvQmLXFBqIgQv/9t2mH+jtrU+9qKUDhA4yOLo77H5ZLjETBgtmJnwMMOI7O4zKYH5FiNoNkUyD2WoQ4dT6/otHXO/WjLp5HMmpekpRQ/M4YzqVCg6mVRZEfEIXzgAZOOUD4jHhNARh9nuVNnPvgLmiZicC6vAuNgFD+0HT0b0U8fN4e5jU7C3Essx6LVrbnkc2TAgg/u4OTbOAFsBrpbVylv9GwMz6XQorNsdsOfkl0LWPXVfMFsx0/0hE2PfjUmEYlMqyIa9HENsfdGqCJVxvrX7+ft0PHbjL0KsuglqBue/i3xPUeSwGwjSmQu1ysq7NLlp09WWpZ8sliq/NAel1ccQXtWcYGPzUFE3MZOk4SBxRl5RJE5+9K98vsZxZR43rWGhC4dbyaQr/H1sxluwndgc6tUHudT5bH1flLrvgNGDcF78LjkFpPrg1f4JOBCIe2ST6+50ty/TR/FX6B4ujscUCSkz+Lq+EfdBT1avh5Elek8v6JY5ztGkOkUp6RgG+yPhqPnZb/+QDdYFnvMjAwwF9Nxgxktn/xrwkMQnuJiS8I4kcUb8kP3t8VYjDCx1TIPr9yhhIPm8eh96WvWSBHiIsjt0c2R60Qbv/aJtnNe2n82wa8gL5jNyy05h1mn3OI1SPqzkLL79hIc8FaJ+qGa56QiD+2ikbKGVrMFyzqYKFx+7Li5idtPoYFbnKqQvCTP+md1wBiHaefyTnibzPKRdXpBmDWmhDZWYjffaKxoGCIoKAMoyQGdP/sv1T59AQqywPgCq6R7D0zdH
 6DfbCPBy
 qYyYDzKt8W9+qAUxd8dHYZg2bM97W7Zg6bnz7gMHI4M68/VIF94XUq58GfNTw4O52fgVAjBB1SmlfVMuzceAleVjjiJMsSBJwYLd479nB72zsGWm0ATubGMtALNL4/h8wPMx2XdwSYNbT+4qS33N9X0mHG1ikLXZdTmlUqo5+DqUITSYoHckuvUiNYlfcRi9Aq7+B1USyTNjVLyPJB/de8CLXLKIcVciKB3AjbWBn2spcLgesTOwwW2Lzm0aWSTAGZjk+OA8yY/vA5g/dZhXnwa3jJutx23qoA9bwjoOFPUnIB63B+mXfzpTjwdQsPQ9+7D8y6otLw/ymLhP+7XvoDm/qHGixZ8QjhaTKavIqHWj+vM4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/05 10:42), Sergey Senozhatsky wrote:
> On (26/01/02 18:29), Yosry Ahmed wrote:
> > On Thu, Jan 01, 2026 at 10:38:14AM +0900, Sergey Senozhatsky wrote:
> [..]
> > 
> > I worry that the heuristics are too hand-wavy
> 
> I don't disagree.  Am not super excited about the heuristics either.
> 
> > and I wonder if the memcpy savings actually show up as perf improvements
> > in any real life workload. Do we have data about this?
> 
> I don't have real life 16K PAGE_SIZE devices.  However, on 16K PAGE_SIZE
> systems we have "normal" size-classes up to a very large size, and normal
> class means chaining of 0-order physical pages, and chaining means spanning.
> So on 16K memcpy overhead is expected to be somewhat noticeable.

By the way, while looking at it, I think we need to "fix" obj_read_begin().
Currently, it uses "off + class->size" to detect spanning objects, which is
incorrect: size classes get merged, so a typical size class can hold a range
of sizes, using padding for smaller objects.  So instead of class->size we
need to use the actual compressed objects size, just in case if actual written
size was small enough to fit into the first physical page (we do that in
obj_write()).  I'll cook a patch.

Something like this:

---

 drivers/block/zram/zram_drv.c | 8 +++++---
 include/linux/zsmalloc.h      | 2 +-
 mm/zsmalloc.c                 | 4 ++--
 mm/zswap.c                    | 3 ++-
 4 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index a6587bed6a03..b371ba6bfec2 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2065,7 +2065,7 @@ static int read_incompressible_page(struct zram *zram, struct page *page,
 	void *src, *dst;
 
 	handle = get_slot_handle(zram, index);
-	src = zs_obj_read_begin(zram->mem_pool, handle, NULL);
+	src = zs_obj_read_begin(zram->mem_pool, handle, PAGE_SIZE, NULL);
 	dst = kmap_local_page(page);
 	copy_page(dst, src);
 	kunmap_local(dst);
@@ -2087,7 +2087,8 @@ static int read_compressed_page(struct zram *zram, struct page *page, u32 index)
 	prio = get_slot_comp_priority(zram, index);
 
 	zstrm = zcomp_stream_get(zram->comps[prio]);
-	src = zs_obj_read_begin(zram->mem_pool, handle, zstrm->local_copy);
+	src = zs_obj_read_begin(zram->mem_pool, handle, size,
+				zstrm->local_copy);
 	dst = kmap_local_page(page);
 	ret = zcomp_decompress(zram->comps[prio], zstrm, src, size, dst);
 	kunmap_local(dst);
@@ -2114,7 +2115,8 @@ static int read_from_zspool_raw(struct zram *zram, struct page *page, u32 index)
 	 * takes place here, as we read raw compressed data.
 	 */
 	zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
-	src = zs_obj_read_begin(zram->mem_pool, handle, zstrm->local_copy);
+	src = zs_obj_read_begin(zram->mem_pool, handle, size,
+				zstrm->local_copy);
 	memcpy_to_page(page, 0, src, size);
 	zs_obj_read_end(zram->mem_pool, handle, src);
 	zcomp_stream_put(zstrm);
diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index f3ccff2d966c..64f65c1f14d6 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -40,7 +40,7 @@ unsigned int zs_lookup_class_index(struct zs_pool *pool, unsigned int size);
 void zs_pool_stats(struct zs_pool *pool, struct zs_pool_stats *stats);
 
 void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
-			void *local_copy);
+			size_t mem_len, void *local_copy);
 void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
 		     void *handle_mem);
 void zs_obj_write(struct zs_pool *pool, unsigned long handle,
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index be385609ef8a..2da60c23cd18 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1070,7 +1070,7 @@ unsigned long zs_get_total_pages(struct zs_pool *pool)
 EXPORT_SYMBOL_GPL(zs_get_total_pages);
 
 void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
-			void *local_copy)
+			size_t mem_len, void *local_copy)
 {
 	struct zspage *zspage;
 	struct zpdesc *zpdesc;
@@ -1092,7 +1092,7 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
 	class = zspage_class(pool, zspage);
 	off = offset_in_page(class->size * obj_idx);
 
-	if (off + class->size <= PAGE_SIZE) {
+	if (off + mem_len <= PAGE_SIZE) {
 		/* this object is contained entirely within a page */
 		addr = kmap_local_zpdesc(zpdesc);
 		addr += off;
diff --git a/mm/zswap.c b/mm/zswap.c
index de8858ff1521..291352629616 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -937,7 +937,8 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	u8 *src, *obj;
 
 	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
-	obj = zs_obj_read_begin(pool->zs_pool, entry->handle, acomp_ctx->buffer);
+	obj = zs_obj_read_begin(pool->zs_pool, entry->handle, entry->length,
+				acomp_ctx->buffer);
 
 	/* zswap entries of length PAGE_SIZE are not compressed. */
 	if (entry->length == PAGE_SIZE) {
-- 
2.52.0.351.gbe84eed79e-goog

