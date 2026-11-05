Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47B25606A32D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=NEzItG/3
Received: by kanga.kvack.org (Postfix)
	id EB3CA6B05C3; Wed,  4 Nov 2026 23:48:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E89F26B05C2; Wed,  4 Nov 2026 23:48:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2ADA6B05C3; Wed,  4 Nov 2026 23:48:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A1AF46B05C1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:48:18 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 92A4F80913
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:48:17 +0000 (UTC)
X-FDA: 85399833834.14.F7C84A1
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id BCF6340007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:48:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="NEzItG/3";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793854095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MPPjTKlf1KE39a7c47Z0O+dylLY3ZRlAYaAs3S22poM=;
	b=nVZsxar72Ze/Y391pg2JjxZA9ldzu64ksfnL3ewbeT9N9R50zUFuOwaeJhNWLF6KEWnJg+
	HPcqMmR6+gxgho6IE3kw4CILcuflG3qT+lPRqOUXn5OUDaK2Mv8lf7ymZZVFaVtxfH61Kq
	3+jsCJ9U2yoSOMntdeUnYGZgBwMtHqg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="NEzItG/3";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793854095;
	b=GaGmNatCTf7ep+kpRv9E/HCQ+8eBvGkmMdXWDv6D6yqYgw27CQRPPseLleaW1exLHRjPfO
	CKAwZymX82IsDFisOwnyl8AYPJ58a/YvRV+CuD2y/hGEJU9r3C4zOU8sxV8epBtUXk1/c6
	lw6rH7zx2WDyQrwYw4soaYLOr/WCIOs=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cdb2dfcca94so650591a12.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 20:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1793854094; x=1794458894; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MPPjTKlf1KE39a7c47Z0O+dylLY3ZRlAYaAs3S22poM=;
        b=NEzItG/3PcEZxo4tPRSOJLAKhtt/8j+mB8BILuxK0kT13I3s8OSygOQRpZlaIU6WqH
         DcDP9Hcn0bJE3PeQan9EVtHhKgM8CgDqvQu2hMZhtuFGR/HxRN++seqGBwL02kUrflMr
         dICqWGJ2lplZmqwkHGEX5g6YUosKWYlfWDjQg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793854094; x=1794458894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MPPjTKlf1KE39a7c47Z0O+dylLY3ZRlAYaAs3S22poM=;
        b=B3Q+5gwkV926Ji+2/Wbp8TJoU7h+M9XlSoHW1z8T47UDs6PisyBvDmAa0sa7ZUYhtK
         VU+kAlwosSKag7+4HZTA3q/X5ftogV4+l4BkU0zr9FadTZXHZJF2WiTihTrWL40RM1YS
         Bs/aUMTw2aIQv0YIpSon7LgjPELZAq/gKO6tYiSEZKJy0NfN0xTtiIFG+jpsUG5xpeKM
         O2vN09hRXJEwpQvh9vKGTaiyhYDtalQd+PCOMntlzBWRmYSRBEQTibCT8ofO2648EA31
         Sp0BhFhZznA54QoFJLycUvXB445u5W2L5TMq8b21gfhGMH31MpdfWciOBnBdiQaBt85o
         dcJw==
X-Forwarded-Encrypted: i=1; AKwUvBxU+Qp4GAgCjXzPuVbvy5vk6u2N66mF3kV6GzDbnaePwVU0NiddRhJR6YzCsXZOzuSoiJOzb5uGSw==@kvack.org
X-Gm-Message-State: APuU4Z8k0JQJRFRwjh/mC1pIlt1Hu+4upzR8IA4uJL9Uqppwu2AeJKv0
	BQUKd1jb7Zaw5bDiDj6rJwJ83I+e/08t4ICzd5GMfGeoeQS+FRoFI9r/qsjkkp0XtQ==
X-Gm-Gg: AYBFou3WVk+gs0gE5fVjadwVPQi3K8TPuNHI7vro80h7gg8Er4Q79Rp3owGPndEuWhc
	yIW5BGdPvJ7nRTl7fJqEoy/7NOTumUiX7qHx0KmTghARZpvpsawkJCUmJgurIM1jIJlJA1LP7wr
	BET3UNk0O8qQSbgjf4lZqb2VSvoKUe6RSuyLCJoZFjdztHSVUrMOkjpipOok8+0DHrSoyZBrjTu
	g2T4t+WbhKphMd5j/tVpkU9JBxaaW1CcTkDQadLxUBgLdhGmumbNG/khousMWsnfrgj0nEXmJ5P
	3PJtCRfZcl4OLrImJe6k4ku+tjQwvEsQ9BDdeW2oVhF9rwplGudcl5lhLVr2iOhLAaZazHAK3YX
	hSIQmAOtp2CYjIqeO+pBeMEe3FGrxbJndqeWHAAHGIlskl2aZoBagZts7v7j4eeZWQpquH7pNvR
	LkWTh65lXMnL2loT/DXFguSu/T63SxBnv4zZhS6xJJ2JxXDR64xqciAvUP0mbbYSFdsy39vX+3b
	PAYvZ8+ZLXT3yzPfktMyJ2DYk1MIrwC90saH+a5JUdtgnIE09F8JBDYD+orpxyhQUp0wacysZaH
	LG8D3ielh+lHH/qcIYqzm0DvItZhCu8oyf6oPt1HYgkrzANfXuk1L7Zhqgcd5nnmzCawazT/Rfo
	gjm/HPQqyP2PRgYdWKQ==
X-Received: by 2002:a05:7022:ea46:20b0:143:5266:48ee with SMTP id a92af1059eb24-1ac5ecb4ad3mr29694277c88.42.1793854094168;
        Wed, 04 Nov 2026 20:48:14 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:37bc:b763:7ec7:65b4])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm17142927c88.21.2026.11.04.20.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 20:48:13 -0800 (PST)
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
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 5/7] zsmalloc: embed struct zs_handle into zram and zswap entries
Date: Thu,  5 Nov 2026 13:47:35 +0900
Message-ID: <20261105044752.1997895-6-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.398.g882cbad275-goog
In-Reply-To: <20261105044752.1997895-1-senozhatsky@chromium.org>
References: <20261105044752.1997895-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BCF6340007
X-Stat-Signature: n3woch8g4yeua49hz8xtb3um63bphaqc
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793854095-121687
X-HE-Meta: U2FsdGVkX1/zKs5etuGz/yQiXIaq8+RswamEK5SazX5zqKHaOgjWlMp76uvGzRn4S5sj+tc5hsiMB7zF71a2CmZtH54EYIP+gtnu/Y+c8VH2tmi9weDyTdyIsrTCyPT72P2B+VjP9F2AvXNVUHwWWoi+cGxDGAd/TfGYksxQTKSisvOxtNHplg8XYr9Y1IM0F4mKlQCEeBuVb3Oc2afR0+jP28zThOxoxQqa7ytyQG1j1BuEjw82xNdz8AleZN3GSTE74RKTv8cp7t/FlPc1vIvpTPpAwJAxuf+hmfUKiUtf9v4pUd61hTjgVTpJn7vLWqfhtSx03Y43Adly0g9GX4Gc3R+gkc1CShNDJ6+mMLUJNnyhO8JeA2kV2Wcoxr4Sm9L3fVPO0dok4T5f6LYwHbgTEI6t0Fus4iPzS16WDsMf0HS3vpwcshWl8ia6cZVEBicb98HSN4A8smzWPWF8u4JJUuRv1pQNR1kkoOtds2zOLB1yh+6VjpsuEwnUCx8xaC0iMGpSAn+hwn/1wMMxXncAPC98Q2yAPHljOCE5BwBfmfaiKPn1X/HSBRRdRFstIwDfO1USiAo9Os0ALTSDsLDIZGVk+k/ds4iJsmczuA8otpm31FbV0hthtqLCDaCpP8jLHJxxVh+OViun50gxwlyd1DLZ9dn+9bNRE8oiTVNdIIt5XQleE5rRq6MsLmRqzGusDPjw020thYvnIAZMAxBUsvpP9pt3982ZbyJfb+z8H785d9eGfY63MTcpxffE+BFeicxBEE6BIVLPqtvy8sYb/muv2k1FDICaYt+pRLHfI2LrT7wNPfMCz8JCMw2Kc0Teygg2pO7QdKV9F7csP9d1kmoUzGJ4H+OuCR19vekDPqv87nWc02CEdTBXPy62ur6KiTEzAVJo0jlRpJs1wOxMJtOmM7IFlozShC67g2hwIbHYzJTdQu8GlbFggWETcxb0zq5qtXflzwcjaIh
 UAAlYPu8
 Us5amLAuwSDX9lzQfao1sAyZCPBHRIRQhcKjSmEjdd1+L9NwYfaOe2X7lVocHNlRA8OSh1jK32f6P/xhvEGTxZqVgdyLXspDyEtVwgZsOwROVtyKCv7ybq35eERtBFbEcFL1Ir55Z7MwsdjlS20eZDAZ3fvMp44QlDI7zJd1U+3YSQVanw4Q5JfXYSmpPWxAbfvUKymNIyaSehUFOgmKcocrXq7g1I1YyO5jRUsLLmTn1MXCwHSvxiiZkbqINZ4kXbh+f9dzBinUygrui6n+I65TzES7oZ5PLEPTgQ/sCFhoADS9qojAmSG0M/sDK5eKg3k9KphcuzutWFKhN86nLnVMcw0souN1rSnqP+bx1ikLeTt8sk1LR+xnOUY99+bvbZAON
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zsmalloc allocates an object from handle_cachep for every stored
object, just to have a stable address which compaction and page
migration can update when the object moves.  Both zram and zswap
already have per-entry structures that hold the handle, so we basically
keep a pointer to a pointer, which costs 8 bytes per stored object,
slab alloc/free on every store and free, and one more memory load on
every access.

Make struct zs_handle public and embed it into zram_table_entry and
zswap_entry (their sizes don't change), so that zsmalloc writes object
location directly there, and remove handle_cachep.  zs_malloc() now
takes a handle pointer and returns an error code, zs_free() resets the
handle.

Since compaction and migration update the handle in place, it must not
be on the stack (zs_malloc() warns about that) and must not be copied.
zram recompression allocates a new object before it frees the old one,
so it uses zram->recomp_handle, protected by ->dev_lock, and
zs_rebind_handle() moves the new object to the slot handle. zram
recompression is the only user of zs_rebind_handle().

This saves 8 bytes per stored page, e.g. 2MB per 1GB of swapped out
4K pages.  Since handle is per-entry the memory savings scale.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 Documentation/admin-guide/mm/slab.rst |   2 +-
 Documentation/mm/zsmalloc.rst         |   4 +-
 drivers/block/zram/Kconfig            |   1 +
 drivers/block/zram/zram_drv.c         |  74 ++++++++---------
 drivers/block/zram/zram_drv.h         |   6 +-
 include/linux/zsmalloc.h              |  30 ++++++-
 mm/Kconfig                            |   3 +
 mm/zsmalloc.c                         | 110 ++++++++++++++++----------
 mm/zswap.c                            |  22 +++---
 9 files changed, 154 insertions(+), 98 deletions(-)

diff --git a/Documentation/admin-guide/mm/slab.rst b/Documentation/admin-guide/mm/slab.rst
index 14429ab90611..57e4a118a391 100644
--- a/Documentation/admin-guide/mm/slab.rst
+++ b/Documentation/admin-guide/mm/slab.rst
@@ -96,7 +96,7 @@ except some that are deemed too performance critical and don't need to be
 debugged by specifying global debug options followed by a list of slab names
 with "-" as options::
 
-	slab_debug=FZ;-,zs_handle,zspage
+	slab_debug=FZ;-,zspage
 
 The state of each debug option for a slab can be found in the respective files
 under::
diff --git a/Documentation/mm/zsmalloc.rst b/Documentation/mm/zsmalloc.rst
index d2bbecd78e14..dbb5c1a8dcc3 100644
--- a/Documentation/mm/zsmalloc.rst
+++ b/Documentation/mm/zsmalloc.rst
@@ -23,8 +23,8 @@ uncompressed form). For allocation requests larger than this size, failure
 is returned (see zs_malloc).
 
 Additionally, zs_malloc() does not return a dereferenceable pointer.
-Instead, it returns an opaque handle (unsigned long) which encodes actual
-location of the allocated object. The reason for this indirection is that
+Instead, it stores the encoded location of the allocated object in the
+provided ``struct zs_handle``. The reason for this indirection is that
 zsmalloc does not keep zspages permanently mapped since that would cause
 issues on 32-bit systems where the VA region for kernel space mappings
 is very small. So, using the allocated memory should be done through the
diff --git a/drivers/block/zram/Kconfig b/drivers/block/zram/Kconfig
index 402b7b175863..18da3a0333f4 100644
--- a/drivers/block/zram/Kconfig
+++ b/drivers/block/zram/Kconfig
@@ -140,6 +140,7 @@ config ZRAM_MEMORY_TRACKING
 config ZRAM_MULTI_COMP
 	bool "Enable multiple compression streams"
 	depends on ZRAM
+	select ZSMALLOC_REBIND_HANDLE
 	help
 	  This will enable multi-compression streams, so that ZRAM can
 	  re-compress pages using a potentially slower but more effective
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index e2710ce35b1f..7c80db51b29a 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -951,7 +951,7 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 	if (test_slot_flag(zram, index, ZRAM_HUGE))
 		atomic64_dec(&zram->stats.huge_pages);
 	atomic64_sub(get_slot_size(zram, index), &zram->stats.compr_data_size);
-	zs_free(zram->mem_pool, zram->table[index].handle);
+	zs_free(zram->mem_pool, &zram->table[index].handle);
 	zram->table[index].blk_idx = req->blk_idx;
 	set_slot_flag(zram, index, ZRAM_WB);
 
@@ -2067,8 +2067,8 @@ static void slot_free(struct zram *zram, unsigned long index)
 		goto out;
 	}
 
-	handle = zram->table[index].handle;
-	if (!handle)
+	handle = &zram->table[index].handle;
+	if (!zs_handle_is_allocated(handle))
 		return;
 
 	zs_free(zram->mem_pool, handle);
@@ -2099,7 +2099,7 @@ static int read_incompressible_page(struct zram *zram, struct page *page,
 	struct zs_handle *handle;
 	void *src, *dst;
 
-	handle = zram->table[index].handle;
+	handle = &zram->table[index].handle;
 	zs_obj_read_sg_begin(zram->mem_pool, handle, sg, PAGE_SIZE);
 	/* an incompressible object never spans two pages */
 	src = kmap_local_page(sg_page(sg));
@@ -2123,7 +2123,7 @@ static int read_compressed_page(struct zram *zram, struct page *page,
 	void *dst;
 	int ret, prio;
 
-	handle = zram->table[index].handle;
+	handle = &zram->table[index].handle;
 	size = get_slot_size(zram, index);
 	prio = get_slot_comp_priority(zram, index);
 
@@ -2150,7 +2150,7 @@ static int read_from_zspool_raw(struct zram *zram, struct page *page,
 	unsigned int size;
 	void *dst;
 
-	handle = zram->table[index].handle;
+	handle = &zram->table[index].handle;
 	size = get_slot_size(zram, index);
 
 	/*
@@ -2177,7 +2177,7 @@ static int read_from_zspool(struct zram *zram, struct page *page,
 			    unsigned long index)
 {
 	if (test_slot_flag(zram, index, ZRAM_SAME) ||
-	    !zram->table[index].handle)
+	    !zs_handle_is_allocated(&zram->table[index].handle))
 		return read_same_filled_page(zram, page, index);
 
 	if (!test_slot_flag(zram, index, ZRAM_HUGE))
@@ -2257,31 +2257,31 @@ static int write_same_filled_page(struct zram *zram, unsigned long fill,
 static int write_incompressible_page(struct zram *zram, struct page *page,
 				     unsigned long index)
 {
-	struct zs_handle *handle;
 	void *src;
+	int ret;
 
 	slot_lock(zram, index);
 	slot_free(zram, index);
-	handle = zs_malloc(zram->mem_pool, PAGE_SIZE,
-			   GFP_NOIO | __GFP_NOWARN |
-			   __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
-	if (IS_ERR(handle)) {
+	ret = zs_malloc(zram->mem_pool, &zram->table[index].handle, PAGE_SIZE,
+			GFP_NOIO | __GFP_NOWARN |
+			__GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
+	if (ret) {
 		slot_unlock(zram, index);
-		return PTR_ERR(handle);
+		return ret;
 	}
 
 	if (!zram_can_store_page(zram)) {
-		zs_free(zram->mem_pool, handle);
+		zs_free(zram->mem_pool, &zram->table[index].handle);
 		slot_unlock(zram, index);
 		return -ENOMEM;
 	}
 
 	src = kmap_local_page(page);
-	zs_obj_write(zram->mem_pool, handle, src, PAGE_SIZE);
+	zs_obj_write(zram->mem_pool, &zram->table[index].handle, src,
+		     PAGE_SIZE);
 	kunmap_local(src);
 
 	set_slot_flag(zram, index, ZRAM_HUGE);
-	zram->table[index].handle = handle;
 	set_slot_size(zram, index, PAGE_SIZE);
 	mark_slot_accessed(zram, index);
 	slot_unlock(zram, index);
@@ -2298,7 +2298,6 @@ static int zram_write_page(struct zram *zram, struct page *page,
 			   unsigned long index)
 {
 	int ret = 0;
-	struct zs_handle *handle;
 	unsigned int comp_len;
 	void *mem;
 	struct zcomp_cstrm *zstrm;
@@ -2330,26 +2329,26 @@ static int zram_write_page(struct zram *zram, struct page *page,
 
 	slot_lock(zram, index);
 	slot_free(zram, index);
-	handle = zs_malloc(zram->mem_pool, comp_len,
-			   GFP_NOIO | __GFP_NOWARN |
-			   __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
-	if (IS_ERR(handle)) {
+	ret = zs_malloc(zram->mem_pool, &zram->table[index].handle, comp_len,
+			GFP_NOIO | __GFP_NOWARN |
+			__GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
+	if (ret) {
 		zcomp_cstrm_put(zstrm);
 		slot_unlock(zram, index);
-		return PTR_ERR(handle);
+		return ret;
 	}
 
 	if (!zram_can_store_page(zram)) {
 		zcomp_cstrm_put(zstrm);
-		zs_free(zram->mem_pool, handle);
+		zs_free(zram->mem_pool, &zram->table[index].handle);
 		slot_unlock(zram, index);
 		return -ENOMEM;
 	}
 
-	zs_obj_write(zram->mem_pool, handle, zstrm->buffer, comp_len);
+	zs_obj_write(zram->mem_pool, &zram->table[index].handle, zstrm->buffer,
+		     comp_len);
 	zcomp_cstrm_put(zstrm);
 
-	zram->table[index].handle = handle;
 	set_slot_size(zram, index, comp_len);
 	mark_slot_accessed(zram, index);
 	slot_unlock(zram, index);
@@ -2456,8 +2455,6 @@ static int recompress_slot(struct zram *zram, unsigned long index,
 			   u32 threshold, u32 prio)
 {
 	struct zcomp_cstrm *zstrm = NULL;
-	struct zs_handle *handle_old;
-	struct zs_handle *handle_new;
 	unsigned int comp_len_old;
 	unsigned int comp_len_new;
 	unsigned int class_index_old;
@@ -2465,8 +2462,9 @@ static int recompress_slot(struct zram *zram, unsigned long index,
 	void *src;
 	int ret = 0;
 
-	handle_old = zram->table[index].handle;
-	if (!handle_old)
+	lockdep_assert_held_write(&zram->dev_lock);
+
+	if (!zs_handle_is_allocated(&zram->table[index].handle))
 		return -EINVAL;
 
 	comp_len_old = get_slot_size(zram, index);
@@ -2535,20 +2533,22 @@ static int recompress_slot(struct zram *zram, unsigned long index,
 	 * modify zsmalloc API to return this information. For now, we will
 	 * make do with the node of the page allocated for recompression.
 	 */
-	handle_new = zs_malloc(zram->mem_pool, comp_len_new,
-			       GFP_NOIO | __GFP_NOWARN |
-			       __GFP_HIGHMEM | __GFP_MOVABLE,
-			       page_to_nid(page));
-	if (IS_ERR(handle_new)) {
+	ret = zs_malloc(zram->mem_pool, &zram->recomp_handle, comp_len_new,
+			GFP_NOIO | __GFP_NOWARN |
+			__GFP_HIGHMEM | __GFP_MOVABLE,
+			page_to_nid(page));
+	if (ret) {
 		zcomp_cstrm_put(zstrm);
-		return PTR_ERR(handle_new);
+		return ret;
 	}
 
-	zs_obj_write(zram->mem_pool, handle_new, zstrm->buffer, comp_len_new);
+	zs_obj_write(zram->mem_pool, &zram->recomp_handle, zstrm->buffer,
+		     comp_len_new);
 	zcomp_cstrm_put(zstrm);
 
 	slot_free(zram, index);
-	zram->table[index].handle = handle_new;
+	zs_rebind_handle(zram->mem_pool, &zram->table[index].handle,
+			 &zram->recomp_handle);
 	set_slot_size(zram, index, comp_len_new);
 	set_slot_comp_priority(zram, index, prio);
 
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 5b211a9f314c..d64c99b74214 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -79,7 +79,7 @@ enum zram_pageflags {
  */
 struct zram_table_entry {
 	union {
-		struct zs_handle *handle;
+		struct zs_handle handle;
 		unsigned long element;
 		unsigned long blk_idx;
 	};
@@ -159,6 +159,10 @@ struct zram {
 	unsigned long bitmap_cursor;
 	unsigned long nr_pages;
 #endif
+#ifdef CONFIG_ZRAM_MULTI_COMP
+	/* Pseudo slot for recompression, protected by ->dev_lock */
+	struct zs_handle recomp_handle;
+#endif
 #ifdef CONFIG_ZRAM_MEMORY_TRACKING
 	struct dentry *debugfs_dir;
 #endif
diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 693c9484b638..6c76fd10344e 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -14,6 +14,7 @@
 #ifndef _ZS_MALLOC_H_
 #define _ZS_MALLOC_H_
 
+#include <linux/compiler.h>
 #include <linux/types.h>
 
 struct zs_pool_stats {
@@ -21,16 +22,39 @@ struct zs_pool_stats {
 	atomic_long_t pages_compacted;
 };
 
+/*
+ * zsmalloc writes object location into the handle and updates it when
+ * the object moves (compaction, page migration), so the handle must not
+ * be on the stack and must not be copied.  Use zs_rebind_handle() to
+ * move an object to another handle.
+ */
+struct zs_handle {
+	unsigned long __private obj;
+} __aligned(sizeof(unsigned long));
+
+static inline void zs_handle_init(struct zs_handle *handle)
+{
+	ACCESS_PRIVATE(handle, obj) = 0;
+}
+
+static inline bool zs_handle_is_allocated(const struct zs_handle *handle)
+{
+	return READ_ONCE(ACCESS_PRIVATE(handle, obj)) != 0;
+}
+
 struct zs_pool;
-struct zs_handle;
 struct scatterlist;
 
 struct zs_pool *zs_create_pool(const char *name);
 void zs_destroy_pool(struct zs_pool *pool);
 
-struct zs_handle *zs_malloc(struct zs_pool *pool, size_t size, gfp_t flags,
-			    const int nid);
+int zs_malloc(struct zs_pool *pool, struct zs_handle *handle, size_t size,
+	      gfp_t flags, const int nid);
 void zs_free(struct zs_pool *pool, struct zs_handle *handle);
+#ifdef CONFIG_ZSMALLOC_REBIND_HANDLE
+void zs_rebind_handle(struct zs_pool *pool, struct zs_handle *dst,
+		      struct zs_handle *src);
+#endif
 
 size_t zs_huge_class_size(struct zs_pool *pool);
 
diff --git a/mm/Kconfig b/mm/Kconfig
index afff1b25b543..2525fc40f2de 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -125,6 +125,9 @@ config ZSWAP_COMPRESSOR_DEFAULT
 config ZSMALLOC
 	tristate
 
+config ZSMALLOC_REBIND_HANDLE
+	bool
+
 menu "Zsmalloc allocator options"
 	depends on ZSMALLOC
 
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 7d8aab56f5cd..71e6dcb1fb3f 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
+#include <linux/sched/task_stack.h>
 #include <linux/errno.h>
 #include <linux/highmem.h>
 #include <linux/string.h>
@@ -264,11 +265,6 @@ struct link_free {
 	};
 };
 
-struct zs_handle {
-	unsigned long __private obj;
-};
-
-static struct kmem_cache *handle_cachep;
 static struct kmem_cache *zspage_cachep;
 
 struct zs_pool {
@@ -442,18 +438,6 @@ static void init_deferred_free(struct zs_pool *pool) {}
 static void SetZsPageMovable(struct zs_pool *pool, struct zspage *zspage) {}
 #endif
 
-static struct zs_handle *cache_alloc_handle(gfp_t gfp)
-{
-	gfp = gfp & ~(__GFP_HIGHMEM | __GFP_MOVABLE);
-
-	return kmem_cache_alloc(handle_cachep, gfp);
-}
-
-static void cache_free_handle(struct zs_handle *handle)
-{
-	kmem_cache_free(handle_cachep, handle);
-}
-
 static struct zspage *cache_alloc_zspage(gfp_t gfp)
 {
 	gfp = gfp & ~(__GFP_HIGHMEM | __GFP_MOVABLE);
@@ -1302,31 +1286,31 @@ static unsigned long obj_malloc(struct zs_pool *pool,
 /**
  * zs_malloc - Allocate block of given size from pool.
  * @pool: pool to allocate from
+ * @handle: handle to store allocated object in (must not be on the stack)
  * @size: size of block to allocate
  * @gfp: gfp flags when allocating object
  * @nid: The preferred node id to allocate new zspage (if needed)
  *
- * On success, handle to the allocated object is returned,
- * otherwise an ERR_PTR().
  * Allocation requests with size > ZS_MAX_ALLOC_SIZE will fail.
+ *
+ * Return: 0 on success, negative error code otherwise.
  */
-struct zs_handle *zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp,
-			    const int nid)
+int zs_malloc(struct zs_pool *pool, struct zs_handle *handle, size_t size,
+	      gfp_t gfp, const int nid)
 {
-	struct zs_handle *handle;
 	struct size_class *class;
 	int newfg;
 	struct zspage *zspage;
 
+	if (WARN_ON_ONCE(object_is_on_stack(handle) ||
+			 zs_handle_is_allocated(handle)))
+		return -EINVAL;
+
 	if (unlikely(!size))
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
 	if (unlikely(size > ZS_MAX_ALLOC_SIZE))
-		return ERR_PTR(-ENOSPC);
-
-	handle = cache_alloc_handle(gfp);
-	if (!handle)
-		return ERR_PTR(-ENOMEM);
+		return -ENOSPC;
 
 	class = lookup_size_class(pool, size);
 
@@ -1345,10 +1329,8 @@ struct zs_handle *zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp,
 	spin_unlock(&class->lock);
 
 	zspage = alloc_zspage(pool, class, gfp, nid);
-	if (!zspage) {
-		cache_free_handle(handle);
-		return ERR_PTR(-ENOMEM);
-	}
+	if (!zspage)
+		return -ENOMEM;
 
 	spin_lock(&class->lock);
 	obj_malloc(pool, zspage, handle);
@@ -1363,7 +1345,7 @@ struct zs_handle *zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp,
 out:
 	spin_unlock(&class->lock);
 
-	return handle;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(zs_malloc);
 
@@ -1464,13 +1446,14 @@ void zs_free(struct zs_pool *pool, struct zs_handle *handle)
 	int fullness;
 	struct zspage *zspage_to_free = NULL;
 
-	if (IS_ERR_OR_NULL(handle))
+	if (!zs_handle_is_allocated(handle))
 		return;
 
 	obj_class_get_and_lock(pool, handle, &obj, &zspage, &class);
 
 	class_stat_sub(class, ZS_OBJS_INUSE, 1);
 	obj_free(class->size, obj);
+	record_obj(handle, 0);
 
 	fullness = fix_fullness_group(class, zspage);
 	if (fullness == ZS_INUSE_RATIO_0) {
@@ -1490,10 +1473,59 @@ void zs_free(struct zs_pool *pool, struct zs_handle *handle)
 		__free_zspage_lockless(zspage_to_free);
 		atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
 	}
-	cache_free_handle(handle);
 }
 EXPORT_SYMBOL_GPL(zs_free);
 
+#ifdef CONFIG_ZSMALLOC_REBIND_HANDLE
+/**
+ * zs_rebind_handle() - Rebind an allocated object to a new handle.
+ * @pool: pool the object belongs to
+ * @dst: unallocated destination handle (must not be on the stack)
+ * @src: source handle that currently owns the object
+ *
+ * Rebinds the object from @src to @dst, updating the object header so
+ * compaction and page migration update @dst instead of @src, and resets
+ * @src.
+ */
+void zs_rebind_handle(struct zs_pool *pool, struct zs_handle *dst,
+		      struct zs_handle *src)
+{
+	struct size_class *class;
+	struct zspage *zspage;
+	unsigned long obj;
+
+	if (WARN_ON_ONCE(object_is_on_stack(dst) ||
+			 zs_handle_is_allocated(dst) ||
+			 !zs_handle_is_allocated(src)))
+		return;
+
+	obj_class_get_and_lock(pool, src, &obj, &zspage, &class);
+
+	if (likely(!ZsHugePage(zspage))) {
+		struct zpdesc *zpdesc;
+		struct link_free *link;
+		unsigned int obj_idx;
+		unsigned long off;
+		void *vaddr;
+
+		obj_to_location(obj, &zpdesc, &obj_idx);
+		off = offset_in_page(class->size * obj_idx);
+		vaddr = kmap_local_zpdesc(zpdesc);
+		link = (struct link_free *)(vaddr + off);
+		link->handle = (unsigned long)dst | OBJ_ALLOCATED_TAG;
+		kunmap_local(vaddr);
+	} else {
+		zspage->first_zpdesc->handle =
+			(unsigned long)dst | OBJ_ALLOCATED_TAG;
+	}
+
+	record_obj(dst, obj);
+	record_obj(src, 0);
+	spin_unlock(&class->lock);
+}
+EXPORT_SYMBOL_GPL(zs_rebind_handle);
+#endif
+
 static void zs_object_copy(struct size_class *class, unsigned long dst,
 				unsigned long src)
 {
@@ -2292,23 +2324,17 @@ EXPORT_SYMBOL_GPL(zs_destroy_pool);
 
 static void zs_destroy_caches(void)
 {
-	kmem_cache_destroy(handle_cachep);
-	handle_cachep = NULL;
 	kmem_cache_destroy(zspage_cachep);
 	zspage_cachep = NULL;
 }
 
 static int __init zs_init_caches(void)
 {
-	handle_cachep = kmem_cache_create("zs_handle", sizeof(struct zs_handle),
-					  0, 0, NULL);
 	zspage_cachep = kmem_cache_create("zspage", sizeof(struct zspage),
 					  0, 0, NULL);
 
-	if (!handle_cachep || !zspage_cachep) {
-		zs_destroy_caches();
+	if (!zspage_cachep)
 		return -ENOMEM;
-	}
 	return 0;
 }
 
diff --git a/mm/zswap.c b/mm/zswap.c
index 397b06c9f33b..f28a46cae1e1 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -215,7 +215,7 @@ struct zswap_entry {
 	unsigned int length;
 	bool referenced;
 	u8 pool_idx;
-	struct zs_handle *handle;
+	struct zs_handle handle;
 	struct obj_cgroup *objcg;
 	struct list_head lru;
 };
@@ -769,6 +769,7 @@ static struct zswap_entry *zswap_entry_cache_alloc(gfp_t gfp, int nid)
 	entry = kmem_cache_alloc_node(zswap_entry_cache, gfp, nid);
 	if (!entry)
 		return NULL;
+	zs_handle_init(&entry->handle);
 	return entry;
 }
 
@@ -787,7 +788,7 @@ static void zswap_entry_free(struct zswap_entry *entry)
 
 	zswap_lru_del(entry);
 	if (!WARN_ON_ONCE(!pool)) {
-		zs_free(pool->zs_pool, entry->handle);
+		zs_free(pool->zs_pool, &entry->handle);
 		zswap_pool_put(pool);
 	}
 	if (entry->objcg) {
@@ -888,7 +889,6 @@ static bool zswap_compress(struct folio *folio, long index,
 	struct scatterlist input, output;
 	int comp_ret = 0, alloc_ret = 0;
 	unsigned int dlen = PAGE_SIZE;
-	struct zs_handle *handle;
 	gfp_t gfp;
 	u8 *dst;
 	bool mapped = false;
@@ -948,14 +948,12 @@ static bool zswap_compress(struct folio *folio, long index,
 	}
 
 	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
-	handle = zs_malloc(pool->zs_pool, dlen, gfp, folio_nid(folio));
-	if (IS_ERR(handle)) {
-		alloc_ret = PTR_ERR(handle);
+	alloc_ret = zs_malloc(pool->zs_pool, &entry->handle, dlen, gfp,
+			      folio_nid(folio));
+	if (alloc_ret)
 		goto unlock;
-	}
 
-	zs_obj_write(pool->zs_pool, handle, dst, dlen);
-	entry->handle = handle;
+	zs_obj_write(pool->zs_pool, &entry->handle, dst, dlen);
 	entry->length = dlen;
 
 unlock:
@@ -980,7 +978,7 @@ static bool __zswap_decompress(struct zswap_entry *entry,
 	struct scatterlist output;
 	int ret = 0, dlen;
 
-	zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->length);
+	zs_obj_read_sg_begin(pool->zs_pool, &entry->handle, input, entry->length);
 
 	/* zswap entries of length PAGE_SIZE are not compressed. */
 	if (entry->length == PAGE_SIZE) {
@@ -1002,7 +1000,7 @@ static bool __zswap_decompress(struct zswap_entry *entry,
 		dlen = req->dlen;
 	}
 
-	zs_obj_read_sg_end(pool->zs_pool, entry->handle);
+	zs_obj_read_sg_end(pool->zs_pool, &entry->handle);
 
 	if (!ret && dlen == PAGE_SIZE)
 		return true;
@@ -1575,7 +1573,7 @@ static bool zswap_store_page(struct folio *folio, long index,
 	return true;
 
 store_failed:
-	zs_free(pool->zs_pool, entry->handle);
+	zs_free(pool->zs_pool, &entry->handle);
 compress_failed:
 	zswap_entry_cache_free(entry);
 	return false;
-- 
2.56.0.398.g882cbad275-goog


