Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 989DBCF6BEF
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 05:24:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E88196B0005; Wed,  7 Jan 2026 00:24:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E487D6B0092; Wed,  7 Jan 2026 00:24:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D92456B0093; Wed,  7 Jan 2026 00:24:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CC8646B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 00:24:11 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E7BA51986
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:24:11 +0000 (UTC)
X-FDA: 84304026702.14.D029BBA
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 759BE120004
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:24:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ESfW+LXc;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf29.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767763449; a=rsa-sha256;
	cv=none;
	b=5cgOQIIZT4BChDmdHzGodWuzbacbtvYpMV+r3ZaCEFTPj6e3eOhR9YsQWRQ+qQbiop3rm2
	Yk8RRC2bFvJ2j0TMHzq/D3h0Mm7W27kOldH6ERA3pCrrnsBpRb9WyK5fNgDOv3rRhWskaH
	jWUANyRStqPhRLmctFNL+iopXZSB6Fw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ESfW+LXc;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf29.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767763449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qX2M30eGHCk52mXySW1cyDnmcJCSqt9PD2ACDZL4eR4=;
	b=D8/y/oF13awKU7uGCqJiAfOtxpVGvkUYvIZ8YVvQxA17lA+R+lK6/24rrLZgvCJF3CNMjH
	ZlV5XroskMnaPtkCXIjrAOcZbkPhucGRpVcxRR4iEBol18DG+vfCNLCCfqrLiCzv8Z6vfe
	Pety8Rhn71l0LLa/HEBb78E1mJo4mjk=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-bde0f62464cso1092793a12.2
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 21:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767763448; x=1768368248; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qX2M30eGHCk52mXySW1cyDnmcJCSqt9PD2ACDZL4eR4=;
        b=ESfW+LXcT5BJ0Dko/4hlxOvaXGU30yJbxDjIW9+7+2j9+kglwkQhJPIdZa7niOWXsn
         yUEw5xsihUA96WGuYhPaDQXzL94GFxo0+ozBUI/cx7+oPnt771RXEFKVMV3c0QRI5Zv1
         cRWzyqWfqjKM5RNDllWCdInncIByBRERT2Pxk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767763448; x=1768368248;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qX2M30eGHCk52mXySW1cyDnmcJCSqt9PD2ACDZL4eR4=;
        b=Z1rhlsdQKYx9D+btknWowgiP5oW1nptPAupeNz+VdBQtTaFIqFAN/VrRdlam/wlHC4
         BUtyIQVHZH8Lf6NEOOpJ4yeKrqFL93U0MI0gqsSNJRWktewk0Q5i88ScyBkaV1e10S8+
         nUoDclBIDwEe5ay7JEhbsVWqCYXq2+0zpgcHvHor0v9gA3IfHf+jQJFXe5Zhm+MLa5wp
         ooDIjIhfg7L5q9H3aEHV8JntCSlvGrYFzPJpPmKyiBMwisRjh2+yJjV1zQ4AiUB2Ep0w
         29UfKavTH7dBgRqg4m2fkhZFqDCzPBPtclPqXWaTyAmtOL+s8t5M+NW2fSj4bOReGutz
         chGg==
X-Forwarded-Encrypted: i=1; AJvYcCXGUC3X8UXoNKnPRGvuhlTWCFT3WZsrPA5CDyIop+CXRo8IFDmKkeAdunGslCX7c3nHEIBgrkodpQ==@kvack.org
X-Gm-Message-State: AOJu0YwhIeZuVcLvp8UCWshtZj8updOBvWxr/EHgI5YcDKVlijYiMAa9
	/rqZJITabwIQg6hLsf47MDjT6Diq48NU4kr/kkEtkxr7MQqAC3UKNG2tpdCyFDRPjQ==
X-Gm-Gg: AY/fxX5wd0b55DnYNx49ogQpZnUIPJmbt+ec8Msr+ysu8d6s8h+c+RnvnJOsE2Ca+Lf
	sifO0QBgl0mmL2dFYv1IyeKc9dH8quHHtxx0IZyf7wSyy/d6hKUH7DP6XDFZK2hx+Cyzbjm6ZVM
	8f5a6ClLtLaSi9NYEp4M5akTIRAy0mh35ZgqkqSsvV7PBE5LGiblzgZL5Hxp+57WwNUH3lZbt83
	FReJqrtyhYM0mYunGd/DwbrUNWxA34bMPQGhWUv3yrPseA8+PWAyCRJhagJD1PKPwyeUi7qolSB
	QXZ4upyUCvxRHKfmin2mr5HmBdK5cdNfKVwUqTjdFkwVZBleV/r/k94s6kQJj/QJNYhFY+l9XKE
	FW6Ff6+e2vc77yTE1k467Nd8ObQCxZ/wprkn/3imGBlun27cibcNCNFFF2YPLNJFszQ8tscFNSu
	JcwbTz+8OQXC4vtX3g3Fem1Zmi0wo6dtWj5+vu9GiQtKTZnt1xY2wqMHKVgG8mUzsvfhWi4B7DB
	g==
X-Google-Smtp-Source: AGHT+IHb4V+g2TMe59SooynLMfTLVLZEH8yuk1niMC7+aXskKLk0m3usjjjR1GCoTPdIYVZTh/Yjjw==
X-Received: by 2002:a05:6a20:6a05:b0:35d:3f07:ba34 with SMTP id adf61e73a8af0-3898f8f4860mr1272538637.31.1767763448264;
        Tue, 06 Jan 2026 21:24:08 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:9f6a:2617:8891:93ff])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c47390sm37069545ad.25.2026.01.06.21.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 21:24:07 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHv2 1/2] zsmalloc: use actual object size to detect spans
Date: Wed,  7 Jan 2026 14:21:44 +0900
Message-ID: <20260107052145.3586917-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 759BE120004
X-Stat-Signature: mcgrkfhmhokuqesuygsd4w5t6f9ikfk4
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767763449-207624
X-HE-Meta: U2FsdGVkX1/T+rKfqPAhe/Kg3qtVZ4EbGZkIGLknxqZZB9AbFu3hpcYMni6ACSK69gTFAzNsjeXDFySmh5hyu5Ihp0SCCovR/bXBpGLIxX7H15BrHN6kDaNUSuyLS65UBUU/OuuieHnvenormCej9PWbuVy91c/GLHuo5duE0ss3ZUE3FeLjuAamakR76GmQnv8mC4nG4anWO4GMSHCS0xVYuJ7YtO25aKrtaVxQ7ejcxM21AuzXHgeNfxafw+iYxl5kzpAchKZCsV914k7qJmZsDY6V9jxt8js4kfAQbwnHvuIF/TQgKKZiLI0XrQnPrpIOEax2Y0X5YIamGYjD82VhEdo+EuM3BtE0AblhWSO8X26+N+cN3zaRE4YM/usyqRzf7gI76IdngWSXPlCXqSA85j7O1EWYFy9ZqrHNBF/Abq9iy5Xs4Ddpu6twOq0WO3V4Zq+FAFS5ZqYqM/EIgcRCNIeGEAq3CayhrXLYXslkO3Oq2+KQG7nCWeBL8AdbRGdc64j+nVs91eGZFCVMDEusZdzapsRtmGdUodUQOh9jyrnaLf7hmGmresX0b4Ts23LBb6niPy8swKpHgEoSeN8WEsUAlFXhaaYZG4oDhcbuDY0F3INgxD+cWa7j9vbIJIhExEp3Tm3Ei0ZUOYPCxWCXgqRoocQ8x8D1M249m1bRvNc77s1kEcVV1y4fHwinHUcPCwvKNvE+TJghz83Jz7gLRGcTXFuZpE1oyU06jzLc39GwwChjR6FA+BYbFY4QR5pEt9bqKPhJTzi6iIhU8Q0YFVk39c4bpj1A5yQVoemnbX0j8/ikvWDRI2yRHMNuCunJusND2lDL5+PULGBt6RMIw2k7a1Dblt1E3or2QW3UKj0xzaMtiuy/7J+ZVzUdj/GsbnqPTcHc0xdb0Xwthv9BZYLw+DxsIneenqX1ZtREO3ZYqO0p4txdvjq7aJfp++MltWs/e78u/gMTBSn
 DPR+/L2H
 ZWlFiJq6KXxbnNhHc9ONs57n5EV/JUxKLTJmE8ZUqODvCx4geME435iCCm0yfDhT8mIp0hkL1+dIbp0Kbhp27AvE0gaiL84hheYLelLrgCQaJ2ICscUC9hj8BEfmZPhipsAkE2EEt9ojYiEyFMuVijdWjlKSevSbTS4fqi/diFhvZRGY1upQQerHI6bWHeoDL8ldaIlCrCUOfN5tZuiGDJrZ6T6tJWsS7kls0SIZmjZ7odfjfltiR102yjXLOMy5QxB0NreNWrUTM90k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Using class->size to detect spanning objects is not entirely correct,
because some size classes can hold a range of object sizes of up to
class->size bytes in length, due to size-classes merge.  Such classes
use padding for cases when actually written objects are smaller than
class->size.  zs_obj_read_begin() can incorrectly hit the slow path
and perform memcpy of such objects, basically copying padding bytes.
Instead of class->size zs_obj_read_begin() should use the actual
compressed object length (both zram and zswap know it) so that it can
correctly handle situations when a written object is small enough to
fit into the first physical page.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---

v1->v2:
- use mem_len for second memcpy size calculation (Yosry)
- simplified read_begin/end logic (Yosry)

 drivers/block/zram/zram_drv.c | 14 ++++++++------
 include/linux/zsmalloc.h      |  4 ++--
 mm/zsmalloc.c                 | 16 +++++++++++-----
 mm/zswap.c                    |  5 +++--
 4 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index a6587bed6a03..76a54eabe889 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2065,11 +2065,11 @@ static int read_incompressible_page(struct zram *zram, struct page *page,
 	void *src, *dst;
 
 	handle = get_slot_handle(zram, index);
-	src = zs_obj_read_begin(zram->mem_pool, handle, NULL);
+	src = zs_obj_read_begin(zram->mem_pool, handle, PAGE_SIZE, NULL);
 	dst = kmap_local_page(page);
 	copy_page(dst, src);
 	kunmap_local(dst);
-	zs_obj_read_end(zram->mem_pool, handle, src);
+	zs_obj_read_end(zram->mem_pool, handle, PAGE_SIZE, src);
 
 	return 0;
 }
@@ -2087,11 +2087,12 @@ static int read_compressed_page(struct zram *zram, struct page *page, u32 index)
 	prio = get_slot_comp_priority(zram, index);
 
 	zstrm = zcomp_stream_get(zram->comps[prio]);
-	src = zs_obj_read_begin(zram->mem_pool, handle, zstrm->local_copy);
+	src = zs_obj_read_begin(zram->mem_pool, handle, size,
+				zstrm->local_copy);
 	dst = kmap_local_page(page);
 	ret = zcomp_decompress(zram->comps[prio], zstrm, src, size, dst);
 	kunmap_local(dst);
-	zs_obj_read_end(zram->mem_pool, handle, src);
+	zs_obj_read_end(zram->mem_pool, handle, size, src);
 	zcomp_stream_put(zstrm);
 
 	return ret;
@@ -2114,9 +2115,10 @@ static int read_from_zspool_raw(struct zram *zram, struct page *page, u32 index)
 	 * takes place here, as we read raw compressed data.
 	 */
 	zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
-	src = zs_obj_read_begin(zram->mem_pool, handle, zstrm->local_copy);
+	src = zs_obj_read_begin(zram->mem_pool, handle, size,
+				zstrm->local_copy);
 	memcpy_to_page(page, 0, src, size);
-	zs_obj_read_end(zram->mem_pool, handle, src);
+	zs_obj_read_end(zram->mem_pool, handle, size, src);
 	zcomp_stream_put(zstrm);
 
 	return 0;
diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index f3ccff2d966c..5565c3171007 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -40,9 +40,9 @@ unsigned int zs_lookup_class_index(struct zs_pool *pool, unsigned int size);
 void zs_pool_stats(struct zs_pool *pool, struct zs_pool_stats *stats);
 
 void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
-			void *local_copy);
+			size_t mem_len, void *local_copy);
 void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
-		     void *handle_mem);
+		     size_t mem_len, void *handle_mem);
 void zs_obj_write(struct zs_pool *pool, unsigned long handle,
 		  void *handle_mem, size_t mem_len);
 
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 84da164dcbc5..119c196a287a 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1065,7 +1065,7 @@ unsigned long zs_get_total_pages(struct zs_pool *pool)
 EXPORT_SYMBOL_GPL(zs_get_total_pages);
 
 void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
-			void *local_copy)
+			size_t mem_len, void *local_copy)
 {
 	struct zspage *zspage;
 	struct zpdesc *zpdesc;
@@ -1087,7 +1087,10 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
 	class = zspage_class(pool, zspage);
 	off = offset_in_page(class->size * obj_idx);
 
-	if (off + class->size <= PAGE_SIZE) {
+	if (!ZsHugePage(zspage))
+		mem_len += ZS_HANDLE_SIZE;
+
+	if (off + mem_len <= PAGE_SIZE) {
 		/* this object is contained entirely within a page */
 		addr = kmap_local_zpdesc(zpdesc);
 		addr += off;
@@ -1096,7 +1099,7 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
 
 		/* this object spans two pages */
 		sizes[0] = PAGE_SIZE - off;
-		sizes[1] = class->size - sizes[0];
+		sizes[1] = mem_len - sizes[0];
 		addr = local_copy;
 
 		memcpy_from_page(addr, zpdesc_page(zpdesc),
@@ -1115,7 +1118,7 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
 EXPORT_SYMBOL_GPL(zs_obj_read_begin);
 
 void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
-		     void *handle_mem)
+		     size_t mem_len, void *handle_mem)
 {
 	struct zspage *zspage;
 	struct zpdesc *zpdesc;
@@ -1129,7 +1132,10 @@ void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
 	class = zspage_class(pool, zspage);
 	off = offset_in_page(class->size * obj_idx);
 
-	if (off + class->size <= PAGE_SIZE) {
+	if (!ZsHugePage(zspage))
+		mem_len += ZS_HANDLE_SIZE;
+
+	if (off + mem_len <= PAGE_SIZE) {
 		if (!ZsHugePage(zspage))
 			off += ZS_HANDLE_SIZE;
 		handle_mem -= off;
diff --git a/mm/zswap.c b/mm/zswap.c
index de8858ff1521..a3811b05ab57 100644
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
@@ -966,7 +967,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	dlen = acomp_ctx->req->dlen;
 
 read_done:
-	zs_obj_read_end(pool->zs_pool, entry->handle, obj);
+	zs_obj_read_end(pool->zs_pool, entry->handle, entry->length, obj);
 	acomp_ctx_put_unlock(acomp_ctx);
 
 	if (!decomp_ret && dlen == PAGE_SIZE)
-- 
2.52.0.351.gbe84eed79e-goog


