Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72AE2CD0435
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 04:25:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6EFA6B008A; Mon,  5 Jan 2026 23:25:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D05756B0093; Mon,  5 Jan 2026 23:25:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C070A6B0095; Mon,  5 Jan 2026 23:25:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AF18C6B008A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 23:25:28 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53429C1A85
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 04:25:28 +0000 (UTC)
X-FDA: 84300249936.17.0237CF1
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id 90517A0007
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 04:25:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=d+UbmHvp;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.44 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767673526; a=rsa-sha256;
	cv=none;
	b=yyj4RxV+xAFDemhqDhbKFV364eogiZZdmWrJrsZXzB82xOoimEDUBkKK1rH9enrnpyjzef
	fpuIsezjFBweZATUeDTMN+2fcaw9KZZGCU0uR3NDeo7BrgvhMkVe3+409PnSK2tjXVfT9L
	70owWGbOCHEMplXepXDhiTNdtriGoYo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=d+UbmHvp;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.44 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767673526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lq3Ohnpab5DQq25Q+sv7xbXXPGC9BStobw4xE/Sx5u4=;
	b=4JxZfXWMpLwUff0opdbywC3TSy2myfyJOVrIl1B17C5AgXEKxM85XWcNU67PrE1TpdWCrW
	cs1MZpkGnLjaJsgZa81eRPGJFGvzYHbvMOKl/nZUrRSFhM8sMh8epLRIjQrBXoAUOVtrE5
	M0BfLQF0luOAwxtB3NGdVD1T57QiekM=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-34c24f4dfb7so532958a91.0
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 20:25:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767673525; x=1768278325; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lq3Ohnpab5DQq25Q+sv7xbXXPGC9BStobw4xE/Sx5u4=;
        b=d+UbmHvpz8zCEZhK32oDq5yRg7I4naU63R36sunYFLeZFOW80ZPW5nuZQoGV798fI4
         u5LaehvUfoCLqN8foNLWQASDaAT/Yj+RZuhVNSH8Llas/0G15D6QpSRTrunk5Hy2kPtd
         uFbtfxM2pVv6FU3qxTumsObtDPyLfyDTxGnHg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767673525; x=1768278325;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lq3Ohnpab5DQq25Q+sv7xbXXPGC9BStobw4xE/Sx5u4=;
        b=EJR/J613vPWZ8Y1bSr8uxaoDxVly6gs5oZQxqCmHB10+bY4Nm7dijD5K77AFUtSaoP
         QW9yQNbK9PucBWMXZbcf1OVLQc4wn7NDs5BC3iABYP3d0NP1kxD9W0fVFWxvx9ViFcr5
         B2Gv8PUh/GNxaF7Jh6SirWW4JE0tt7WOEPiuSqr+PoUOEWMUKp9GoL9eGPFdZ2Ds+bch
         KcMScYL6ut1TQ3GBy8ez+tMGETJ64dlqrlB9tvoxpMG8AG4olOmMFLiUsFSQMrjucw99
         5PcckNYAhP+J9iUKOPf46lIx4laKovMYp0RTmZdyuo0KCeRDjYEl35VGSNKIYz75OjY+
         U9Vw==
X-Forwarded-Encrypted: i=1; AJvYcCVk7Sc4R0EsLzNgXbcgwb6HKrkrt3cDyoBqY4sNI4Q3qzTyUXfjVkqGQH/4NrrBm/9zG5I2PJp5yg==@kvack.org
X-Gm-Message-State: AOJu0YyYbUH5NFMV2D/MTbHbyqG7ongqWo6Psq4vCNbN8bHORQq5sh2B
	cLE6vlevUf95gwGMbFU8b2sxbtFtRuXa1vOHmLG6gjNv/wBB+BOO+DB8DLGqkQrRog==
X-Gm-Gg: AY/fxX6y24hhnhiSkOAo3V/fBzZpfY7JL7CZIv4wty/CX4G2VUHk36cvUzNdZtPDTPQ
	RXK/klsxjq0BE5QZ9ohZKjy5spwpnDxBUEJ1S4yd4dcuHmxkJ8j3ZOJNLYESWj/o0RMavwqlQdL
	/R1c5IFDSPlcYOffwlRGMkzlHaXyZ6TJKvzuDucjLiAWZXiWT3KLCJlJlnYYEKuvMXP50gS3dqX
	wVZ1WK6C3zXW2sEO1uXClSs9S1rlMMYqrrLDMi85A2WINAnup64Q/0AAfS4wIJ2dMjTu46gWLbb
	oc5G4OljKOIEf7r1rOyFFb+vLxMJNzvxZXosofXxcHDtHH+aJSpga9HKeZSayV7S8cBI4lfpAg0
	T8HkKeG49MYRzdVf590ekLQLZ52cYWRFTejqNZBV51fDDnerv6HDN7sTxPFFsTS8nY4RgC9DSMn
	kN/1CNaKXxdU9KrAgyTDcbu6CtuQwA+eLmblg4aMwBatGF2dMabwZu208Tl93U2twSVDfXLam38
	g==
X-Google-Smtp-Source: AGHT+IGYjclC6FbGk5UZwgYn7mK3ZWwTvjAfnLdpbTmbDTNkgRskr70mtpA6vSYpoMTh2PTgd1sHfQ==
X-Received: by 2002:a17:90b:350d:b0:34c:6e10:fe71 with SMTP id 98e67ed59e1d1-34f5f32cc47mr1319918a91.25.1767673525504;
        Mon, 05 Jan 2026 20:25:25 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:f5eb:5af6:e88e:8a77])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f5f8afba8sm775477a91.13.2026.01.05.20.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 20:25:23 -0800 (PST)
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
Subject: [PATCH] zsmalloc: use actual object size to detect spans
Date: Tue,  6 Jan 2026 13:25:07 +0900
Message-ID: <20260106042507.2579150-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 90517A0007
X-Stat-Signature: d17q8m149kh9q6hq11uoegnndds3ncqy
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767673526-732102
X-HE-Meta: U2FsdGVkX18uEqpBDehNQqFDA8v5Asa4fZYZ602EuAmkJRQjDRpWzkJyFfLdy42a9N2/HOz/2J7+MNcoWqn7K2ervVJBrd7RxnJAFPe9JJ6FrYYFn5CxPyFRdmONS2zkXdKRNhEwWnpP3+Phiu6LHGJB1RZqDBywUppVPFRzOd8qh+v6f+1KFb9rMpLHvxLDXrB0En9L7gQRzISD1Az9J9g2dm4waj+EUxwiZhicpU3jz+lQRTIkEqBqe/rNkLBJJlmYMX6JwMTonslL8yDvSqX2PT/wtJxvdYbbbz6ogHGsdgeDwz6vBPzi037hvyljJCCi4kfxiEo/bUaxzxcYIlHGJS5y69Ukp6MDpirW0bllG8DEefYCWX2NmQvUq0fTdwl9mvkRkHvd3coI3Ufh12e8A8//LfXfamifD8emch7dMA261xoKBO7BYBLTl+h9cwu4DrG4HQLc7SzqZ9zAhGqehURMVC4u4MRMcIjpOwQUUDEJnlfVPuv1wXJbp/STfWRZhAeWVxbXRwrQ5ta5sl5KtbjpBC1yUqtrU6FiqAdnhLIgU1iwPBC1O0WetgrU4To85G6BDFipJN92d5Al1NQLidWJAUlI94ND6xbU+TkC3h+Zr3Bo/H7iepQcUTo6r9g3bT4k26cojD20kFehGD7LaG6ghaeFz4XwZrKh/oyyxtJfkstDMFzdg/Jqe2XVnL3fie5T60B0Vww+TbOZ3GsWnAA7+3Z+9l6Tgz1kt5fh0oKv6NbhOXP8FQfEXhEZ44gea0zJYaauG8fHeLFwJDCtTJul3//VzP5YStlnK3wIQkSGW+HsdUGZJag0zKbBEtfo9qRoWHmPIFKPUiC/DgK1s0+eMFl8XOfDgaUhF+Yfj2O2RXOEgK71VDJlrOBjx5D9oiIwNVZgMVBjoI8I57FSiRSO9nSmbm92wP9rouGh/fG7QOjczwNenLH4BOYCBN0JyfV7JGOmHXaJyj/
 6/eQ+ZsL
 BFndh/mksiEca8ojTVLrK1RlWlUrF7d5yEAphmPea3jn+RpejsqN7efKHCxStlUHk6cOJepv35yDMxHLVZtBC+Vth7ZHRLFIEPpeI+6avJv5A9UU8gGshyQuuR60jawS2Y9VQLgwi/T5lzBybyQ/5bIgl01zVjgdU69hNYGuHalQu9rwU3XaUz3gsvLK89NwMebwY+9lytepqJY2QW8cIbJh7DZZ2Jlz4dohIaGhBasPJezUk3V5zHUbc23IA8Zg6zR9MEN83wAu2KMo=
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
 drivers/block/zram/zram_drv.c | 14 ++++++++------
 include/linux/zsmalloc.h      |  4 ++--
 mm/zsmalloc.c                 | 16 ++++++++++++----
 mm/zswap.c                    |  5 +++--
 4 files changed, 25 insertions(+), 14 deletions(-)

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
index 84da164dcbc5..ab7767d9d87d 100644
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
@@ -1087,7 +1087,11 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
 	class = zspage_class(pool, zspage);
 	off = offset_in_page(class->size * obj_idx);
 
-	if (off + class->size <= PAGE_SIZE) {
+	/* Normal classes have inlined handle */
+	if (!ZsHugePage(zspage))
+		mem_len += ZS_HANDLE_SIZE;
+
+	if (off + mem_len <= PAGE_SIZE) {
 		/* this object is contained entirely within a page */
 		addr = kmap_local_zpdesc(zpdesc);
 		addr += off;
@@ -1115,7 +1119,7 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
 EXPORT_SYMBOL_GPL(zs_obj_read_begin);
 
 void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
-		     void *handle_mem)
+		     size_t mem_len, void *handle_mem)
 {
 	struct zspage *zspage;
 	struct zpdesc *zpdesc;
@@ -1129,7 +1133,11 @@ void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
 	class = zspage_class(pool, zspage);
 	off = offset_in_page(class->size * obj_idx);
 
-	if (off + class->size <= PAGE_SIZE) {
+	/* Normal classes have inlined handle */
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


