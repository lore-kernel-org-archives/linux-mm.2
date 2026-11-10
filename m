Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ADC960A262E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=GRAPNM3R
Received: by kanga.kvack.org (Postfix)
	id AD6086B05C1; Tue, 10 Nov 2026 00:49:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A85A96B05C2; Tue, 10 Nov 2026 00:49:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B1EC6B05C3; Tue, 10 Nov 2026 00:49:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 534B06B05C1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:49:15 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C93E4120546
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:49:14 +0000 (UTC)
X-FDA: 85418131428.03.3F0B956
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf08.hostedemail.com (Postfix) with ESMTP id E527B16000A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:49:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=GRAPNM3R;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794289753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rzn6uYVSoFNgPBAe93AhtbDYbT5dWun34j54vuX2pmM=;
	b=2GtXH97tXIw4enhgZ3SpJgPUMwJvFsaxtgL0z1ZH7CZg5OjGk9GMwMfpH62AFImhkKBxMF
	IX5ylBqCC/p7ov1iu0ygL86hJ+Uexp9lNwVI/Bt3MAVisgpj3E0Od2QskZYZsG3h3HWJrv
	FSXnnAzNRSv0OjuGVhoYy1SPZTrQ84Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794289753;
	b=BenxdXis4e91OiYsc7dfcIgDDVYRz/5dJRR3d1GkekwSYKOxMFxceeaBif5/J8zEj3wJe9
	Jv/2vzMen7AGkFMLhbC42hAXlY0kY4v4XqsDTj3BAxfRaBiU2xKebGue4EkyMr5e3PkAck
	AIgcUU0Fvd6PenCo3xaQiA4ObZq7GSs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=GRAPNM3R;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8b9c51097e2so605586b3a.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794289752; x=1794894552; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rzn6uYVSoFNgPBAe93AhtbDYbT5dWun34j54vuX2pmM=;
        b=GRAPNM3RkPmOoXjJenyrea24bt/4yyZHrYvSYmhZghkFJIhUzwXk5MxGws8CNDwKH6
         zjOLNTZ2V9tq/8fQius/BMRCXoN0pAv9H00+F0xAxwjIzdL45NhGfrevnoFYHciPfl0z
         u94qGePXn74V5mxpk9V7mS7XFD+8KkZZRl+LY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794289752; x=1794894552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rzn6uYVSoFNgPBAe93AhtbDYbT5dWun34j54vuX2pmM=;
        b=0bqZyVOoHgKneDNBc4+sp5WiPwVxh7cgPYFr1fkiMWukWpK0ngUzI+BCY+yldBXymy
         YXBFG5hjqll5qusRv2oBzsoAD61ANOIfNa5VeUbJpombD54MSCLrdOksjSpzVoQjoeXS
         4FkjKNmdJd/i+ww68TAaOvUweBUi/dv+6gHkrk1DFATJVSVnEMWiUyd2rk1gQFxoBNjg
         5nX/K1A7/awbtE+uu8O5kkNPUgR2DuBKZwASwK1XdF2bYAuhZkWA4S+prydMjihiH7+V
         XQ3Ui+AbN+xseRIE398b+MVDyPrLgrGIanALxOy1o4hfdFaIXjbvzIF/TyD37ynpYK3S
         T59g==
X-Forwarded-Encrypted: i=1; AL+hErHe0Ffvmy0DAXzZdjWEGf5odX5qxCsiq/dnRE4o2g7Zrv6Pq32BxnltvB1NWXtloWbpyo0CE9WVSQ==@kvack.org
X-Gm-Message-State: APuU4Z9sXvddVE4M9or/p9G1sc1PR/vWzGm+qnsWvdfTcRPQRVq7sBZk
	e45C5P0bI6DnhAhbuQLpzkHKXHsgJFnKWe1UIiYQ/BWJI2hE5pvwNn/CM/6mJnAn4A==
X-Gm-Gg: AYBFou0XvXLv3nmTRakoZd76/Q4CL8gxuefeWS8Vu7rrTdiN4EzExDkDnIwIwFoCPFr
	TZ44MFOJYUFsc5bIKqQIBsQ6707WEwwCHRq3CfWTDbtbWDhQm7g5nQ59Mm3xqvV51DDZBTDX8F0
	QZmVED1RO6nM7evv1OKVCn2fYlBBRORcrY2Vsfs/xO++2qfeAiRrvfHBXWnUqJQbRVP/t13NqdS
	l8pu4U+Ses80xvubSzIE47I3eew2RPr9qayaPXzv/XBV02/qeV9hVApdHTLak0Rjir0C3hPNuGp
	aajRr2xJK2eQB+b3BghwRWxVg7xzKh6SDG/qYJYttqPy243nm6VohjeB/meDKh2ccpkuTIoSMm2
	rd3teFDYwUVBOiKD88rm1a/P9qVPs2o9zt7ZYseSGofN6JtVzpNXZgBBcub/0JtBeIb/JB/Etxa
	GdOV2g8B/hDK77E6yX5rugy0lUM5cByol2OMWcpIh2tFedCzohxgFS6swl+xg2JVmFHkzSle74f
	D0OTeV1zEpT7MdaR+Za7JFspHt483Ra4tQY3mPSH1uagMI6Lrl3PHc2V+GTrUwCZUU0Asj0/q2H
	hthdowHRR1pYM1WLvzHyEUd3kJAuCpUxQ7k2ouueZFQgYfAPm3wH9WxUmJFOtFeP13FFMdxWOya
	i55RTdhXxidT8v2W+Kw==
X-Received: by 2002:a05:6a21:3b49:b0:3e1:fa57:1d4f with SMTP id adf61e73a8af0-3f190473172mr1069788637.59.1794289751666;
        Mon, 09 Nov 2026 21:49:11 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:e137:9384:7cd8:6e40])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdd8d67e53asm444634a12.5.2026.11.09.21.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 21:49:11 -0800 (PST)
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
Subject: [PATCH v2 09/11] zsmalloc: embed struct zs_handle into zram and zswap entries
Date: Tue, 10 Nov 2026 14:48:14 +0900
Message-ID: <20261110054836.1515030-10-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
In-Reply-To: <20261110054836.1515030-1-senozhatsky@chromium.org>
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E527B16000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: gyg3snsdimiiph4d4zi5ag4txeh7ontm
X-Rspam-User: 
X-HE-Tag: 1794289752-462660
X-HE-Meta: U2FsdGVkX19d8xeZcoVIO2A0dr4NtGHRd8suBNns4hT+zqOepdy69QDS0CIrQnna7U+rVHB8hKJJI26q4afShO6bGiAH1Tuw9Jgv3pOlLyQ2sPXHEUZo4fzfZ60y6bW7ghz4EBuTRyyX8nosrL1TJTsLy4uGdGgk/zIc+ydXmGcfQhhSH+WwwQmxP0d3VXEfc+DzsUN0F8kk+pwhIXxY/kjSEvxQHt/G/ulX/m9g0hexy+HCtQ4zUKz5wlbOcTuNckr/WfJIcWjns1cZwNWjqKWK8YWiifIpV9QZKQBn0fJrylXIEJQXaYObLCMW3WZcrh/CV/mBxzsJw78N6pX9/iZ09qVYiyyQB7I0l9HLNgt3VmMEIo+Zhc7haipzx27XZSPjBff00dUZkgDNjiTpDkSDtbEusy/FoDwNEnZH4ZJCCA6czFvOeFlcrSts2i6hNhSNBudYzAtj+f3zpo9nwpfA7IVEqmnIpnQT/G0uWuafkSg/DGQEkXk+s7n2JKH6hTmJqXB6eLujmNJNPROUlo/XXq2BHGyRm3pTxh9CzoETrQmP4SaXwS3xIARFSClovQ6HWiYk0zhM+WLuCM6cpB4dx1VHu2Q6JihyWlq5b4oSPSTaoAjYFzVb85QOtaWBvFwKMU/CMPNSJuHbUviv/4ViT/p+EZg3KwDmkS1MENuiUsfhqaSuXQF45vyArThIsM1vmObZK8deQZkq9pqBV+Q7q6uJJu1ND2nip+zUqSy6khg/2QMOmEyhFou+0GTFnHxCKl7ukCwoxypLgAraQ3qhLJbc4U1UhNuS9Ey6n/OkOzSys4Hm0Ht4lDL2skmd3MwWAPyTquiNupHtYYr16OSpOcMO5l/DJoyxgYy5BwL+27qBprOvf3nmUkguYGfjnF3eHZ9aZL+FS0ru44MSSEG/UMCT1FtChrBpHXldo+inlEhGlrK3Ez3DW8ehH9yYKjoMkI8jllM2XmWhlfI
 eRm9kJKE
 ffOFicSkUkCczeKXWYd2laxjNsPseiBBrcYHvFAvHmPt+qkceHIP3a5YK3n+yvz+/wLIuEOSLDUw5Y2gg4xVMhgbJce3A/r0cMhqzux079uV6adN4MULIjQvB9oHJ+pfEhBBzFztIwzpuVb+3TdAY6IeM+FV36VNA3l0PuXS4sJLReqs3DIyu0w8KGmbPXLpZDu2c1o2CQucBhC0/k3miuZFpfkt3ZjT8a9J0vc2z0ki7bK+WAu7KyyV3Q0FB0t8hTTBAYUxpFm5AHlld+SEiNHSTxf9O3M6a9fIzPCDTyLgS5/seAw7mnjECtT8m5Pq8arzN1ch2vEugHRtKJ0vQiMG/S2OGGO1xBmjVYAbfEf220UU=
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

Since compaction and migration update the handle in place, it must be
naturally aligned, must not be on the stack (zs_malloc() warns about
both), must not be copied, and must stay allocated until zs_free() or
zs_rebind_handle().  zram recompression allocates a new object before
it frees the old one, so it uses zram->recomp_handle, protected by
->dev_lock, and zs_rebind_handle() moves the new object to the slot
handle.  zram recompression is the only user of zs_rebind_handle().

This saves 8 bytes per stored page, e.g. 2MB per 1GB of swapped out
4K pages.  Since handle is per-entry the memory savings scale.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 Documentation/admin-guide/mm/slab.rst |   2 +-
 Documentation/mm/zsmalloc.rst         |  18 ++--
 drivers/block/zram/zram_drv.c         |  70 ++++++-------
 drivers/block/zram/zram_drv.h         |   6 +-
 include/linux/zsmalloc.h              |  29 +++++-
 mm/zsmalloc.c                         | 144 ++++++++++++++++----------
 mm/zswap.c                            |  22 ++--
 7 files changed, 177 insertions(+), 114 deletions(-)

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
index d2bbecd78e14..d6b21a0c0694 100644
--- a/Documentation/mm/zsmalloc.rst
+++ b/Documentation/mm/zsmalloc.rst
@@ -22,13 +22,17 @@ worst case, page is incompressible and is thus stored "as-is" i.e. in
 uncompressed form). For allocation requests larger than this size, failure
 is returned (see zs_malloc).
 
-Additionally, zs_malloc() does not return a dereferenceable pointer.
-Instead, it returns an opaque handle (unsigned long) which encodes actual
-location of the allocated object. The reason for this indirection is that
-zsmalloc does not keep zspages permanently mapped since that would cause
-issues on 32-bit systems where the VA region for kernel space mappings
-is very small. So, using the allocated memory should be done through the
-proper handle-based APIs.
+Additionally, zs_malloc() does not return a pointer; instead, it returns 0
+(or a negative error code) and stores the encoded location of the allocated
+object in the caller-provided ``struct zs_handle``. The reason for this
+indirection is that zsmalloc does not keep zspages permanently mapped since
+that would cause issues on 32-bit systems where the VA region for kernel
+space mappings is very small. zsmalloc also keeps a back-pointer to the
+provided ``struct zs_handle`` and updates it asynchronously during
+compaction and page migration, so the owner must not modify or copy the
+handle and must keep it allocated until ``zs_free()`` or
+``zs_rebind_handle()``. Using the allocated memory should be done through
+the proper handle-based APIs.
 
 stat
 ====
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index aa3ab88f1259..7c3d04d9c5bc 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -950,7 +950,7 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 	if (test_slot_flag(zram, index, ZRAM_HUGE))
 		atomic64_dec(&zram->stats.huge_pages);
 	atomic64_sub(get_slot_size(zram, index), &zram->stats.compr_data_size);
-	zs_free(zram->mem_pool, zram->table[index].handle);
+	zs_free(zram->mem_pool, &zram->table[index].handle);
 	zram->table[index].blk_idx = req->blk_idx;
 	set_slot_flag(zram, index, ZRAM_WB);
 
@@ -2066,8 +2066,8 @@ static void slot_free(struct zram *zram, unsigned long index)
 		goto out;
 	}
 
-	handle = zram->table[index].handle;
-	if (!handle)
+	handle = &zram->table[index].handle;
+	if (!zs_handle_is_allocated(handle))
 		return;
 
 	zs_free(zram->mem_pool, handle);
@@ -2098,7 +2098,7 @@ static int read_incompressible_page(struct zram *zram, struct page *page,
 	struct zs_handle *handle;
 	void *src, *dst;
 
-	handle = zram->table[index].handle;
+	handle = &zram->table[index].handle;
 	zs_obj_read_sg_begin(zram->mem_pool, handle, sg, PAGE_SIZE);
 	/* an incompressible object never spans two pages */
 	src = kmap_local_page(sg_page(sg));
@@ -2122,7 +2122,7 @@ static int read_compressed_page(struct zram *zram, struct page *page,
 	void *dst;
 	int ret, prio;
 
-	handle = zram->table[index].handle;
+	handle = &zram->table[index].handle;
 	size = get_slot_size(zram, index);
 	prio = get_slot_comp_priority(zram, index);
 
@@ -2149,7 +2149,7 @@ static int read_from_zspool_raw(struct zram *zram, struct page *page,
 	unsigned int size;
 	void *dst;
 
-	handle = zram->table[index].handle;
+	handle = &zram->table[index].handle;
 	size = get_slot_size(zram, index);
 
 	/*
@@ -2176,7 +2176,7 @@ static int read_from_zspool(struct zram *zram, struct page *page,
 			    unsigned long index)
 {
 	if (test_slot_flag(zram, index, ZRAM_SAME) ||
-	    !zram->table[index].handle)
+	    !zs_handle_is_allocated(&zram->table[index].handle))
 		return read_same_filled_page(zram, page, index);
 
 	if (!test_slot_flag(zram, index, ZRAM_HUGE))
@@ -2256,27 +2256,27 @@ static int write_same_filled_page(struct zram *zram, unsigned long fill,
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
 
 	update_used_max(zram);
 
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
@@ -2293,7 +2293,6 @@ static int zram_write_page(struct zram *zram, struct page *page,
 			   unsigned long index)
 {
 	int ret = 0;
-	struct zs_handle *handle;
 	unsigned int comp_len;
 	void *mem;
 	struct zcomp_cstrm *zstrm;
@@ -2328,21 +2327,21 @@ static int zram_write_page(struct zram *zram, struct page *page,
 
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
 
 	update_used_max(zram);
 
-	zs_obj_write(zram->mem_pool, handle, zstrm->buffer, comp_len);
+	zs_obj_write(zram->mem_pool, &zram->table[index].handle, zstrm->buffer,
+		     comp_len);
 	zcomp_cstrm_put(zstrm);
 
-	zram->table[index].handle = handle;
 	set_slot_size(zram, index, comp_len);
 	mark_slot_accessed(zram, index);
 	slot_unlock(zram, index);
@@ -2449,8 +2448,6 @@ static int recompress_slot(struct zram *zram, unsigned long index,
 			   u32 threshold, u32 prio)
 {
 	struct zcomp_cstrm *zstrm = NULL;
-	struct zs_handle *handle_old;
-	struct zs_handle *handle_new;
 	unsigned int comp_len_old;
 	unsigned int comp_len_new;
 	unsigned int class_index_old;
@@ -2458,8 +2455,9 @@ static int recompress_slot(struct zram *zram, unsigned long index,
 	void *src;
 	int ret = 0;
 
-	handle_old = zram->table[index].handle;
-	if (!handle_old)
+	lockdep_assert_held_write(&zram->dev_lock);
+
+	if (!zs_handle_is_allocated(&zram->table[index].handle))
 		return -EINVAL;
 
 	comp_len_old = get_slot_size(zram, index);
@@ -2528,20 +2526,22 @@ static int recompress_slot(struct zram *zram, unsigned long index,
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
index 7fa500ae2653..8273ae924153 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -14,6 +14,7 @@
 #ifndef _ZS_MALLOC_H_
 #define _ZS_MALLOC_H_
 
+#include <linux/compiler.h>
 #include <linux/types.h>
 
 struct zs_pool_stats {
@@ -21,16 +22,38 @@ struct zs_pool_stats {
 	atomic_long_t pages_compacted;
 };
 
+/*
+ * zsmalloc writes object location into the handle, keeps a back-pointer to
+ * it, and updates it asynchronously when the object moves (compaction, page
+ * migration).  Therefore the owner must not modify or copy the handle, must
+ * not put it on the stack or misalign it (e.g. inside a __packed struct),
+ * and must keep it allocated until zs_free() or zs_rebind_handle().
+ */
+struct zs_handle {
+	unsigned long __private obj;
+};
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
+void zs_rebind_handle(struct zs_pool *pool, struct zs_handle *dst,
+		      struct zs_handle *src);
 
 size_t zs_huge_class_size(struct zs_pool *pool);
 
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index aa436df0cc4d..fd466139e158 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -22,14 +22,15 @@
  *	class->lock
  *	zspage->lock
  *
- * When ZS_OBJ_CLASS_BITS > 0, zs_free() skips pool->lock; it picks
- * the size_class from obj's encoded class_idx and serializes against
- * page migration via class->lock.
+ * When ZS_OBJ_CLASS_BITS > 0, zs_free() and zs_rebind_handle() skip
+ * pool->lock; they pick the size_class from obj's encoded class_idx and
+ * serialize against page migration via class->lock.
  */
 
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
+#include <linux/sched/task_stack.h>
 #include <linux/errno.h>
 #include <linux/highmem.h>
 #include <linux/string.h>
@@ -104,10 +105,10 @@
  *                     |
  *                     +-- ZS_OBJ_PFN_SHIFT
  *
- * Encoding class_idx into obj lets zs_free() locate the size_class
- * without holding pool->lock; class_idx is invariant across page
- * migration (only PFN changes), so a lockless read of the obj value
- * always yields a valid class_idx.
+ * Encoding class_idx into obj lets zs_free() and zs_rebind_handle()
+ * locate the size_class without holding pool->lock; class_idx is
+ * invariant across page migration (only PFN changes), so a lockless
+ * read of the obj value always yields a valid class_idx.
  */
 #define ZS_OBJ_PFN_SHIFT	(BITS_PER_LONG - _PFN_BITS)
 
@@ -267,11 +268,6 @@ struct link_free {
 	};
 };
 
-struct zs_handle {
-	unsigned long __private obj;
-};
-
-static struct kmem_cache *handle_cachep;
 static struct kmem_cache *zspage_cachep;
 
 struct zs_pool {
@@ -445,18 +441,6 @@ static void init_deferred_free(struct zs_pool *pool) {}
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
@@ -470,8 +454,9 @@ static void cache_free_zspage(struct zspage *zspage)
 }
 
 /*
- * Pairs with READ_ONCE() in handle_to_obj(): zs_free() may read the
- * handle locklessly, so prevent store tearing here.
+ * Pairs with READ_ONCE() in handle_to_obj() and zs_handle_is_allocated():
+ * zs_free(), zs_rebind_handle(), and zs_handle_is_allocated() may read
+ * the handle locklessly, so prevent store tearing here.
  */
 static void record_obj(struct zs_handle *handle, unsigned long obj)
 {
@@ -1307,31 +1292,37 @@ static unsigned long obj_malloc(struct zs_pool *pool,
 /**
  * zs_malloc - Allocate block of given size from pool.
  * @pool: pool to allocate from
+ * @handle: handle to store allocated object in
  * @size: size of block to allocate
  * @gfp: gfp flags when allocating object
  * @nid: The preferred node id to allocate new zspage (if needed)
  *
- * On success, handle to the allocated object is returned,
- * otherwise an ERR_PTR().
  * Allocation requests with size > ZS_MAX_ALLOC_SIZE will fail.
+ * zsmalloc keeps a back-pointer to @handle and updates it asynchronously
+ * when the object moves, so @handle must be unsigned-long aligned, must
+ * not be on the stack or modified/copied by the caller, and must remain
+ * allocated until zs_free() or zs_rebind_handle().
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
 
+	if (WARN_ON_ONCE(!IS_ALIGNED((unsigned long)handle,
+				     __alignof__(unsigned long)) ||
+			 object_is_on_stack(handle) ||
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
 
@@ -1350,10 +1341,8 @@ struct zs_handle *zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp,
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
@@ -1368,7 +1357,7 @@ struct zs_handle *zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp,
 out:
 	spin_unlock(&class->lock);
 
-	return handle;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(zs_malloc);
 
@@ -1469,13 +1458,14 @@ void zs_free(struct zs_pool *pool, struct zs_handle *handle)
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
@@ -1495,10 +1485,59 @@ void zs_free(struct zs_pool *pool, struct zs_handle *handle)
 		__free_zspage_lockless(zspage_to_free);
 		atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
 	}
-	cache_free_handle(handle);
 }
 EXPORT_SYMBOL_GPL(zs_free);
 
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
+	struct zpdesc *zpdesc;
+	struct link_free *link;
+	unsigned int obj_idx;
+	unsigned long obj;
+	unsigned long off;
+	void *vaddr;
+
+	/* Should never happen; bail out rather than corrupting handles */
+	if (WARN_ON_ONCE(!IS_ALIGNED((unsigned long)dst,
+				     __alignof__(unsigned long)) ||
+			 object_is_on_stack(dst) ||
+			 zs_handle_is_allocated(dst) ||
+			 !zs_handle_is_allocated(src)))
+		return;
+
+	obj_class_get_and_lock(pool, src, &obj, &zspage, &class);
+
+	if (likely(!ZsHugePage(zspage))) {
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
+
 static void zs_object_copy(struct size_class *class, unsigned long dst,
 				unsigned long src)
 {
@@ -1795,7 +1834,8 @@ static int zs_page_migrate(struct page *newpage, struct page *page,
 
 	/*
 	 * The pool migrate_lock protects against races between zpage migration
-	 * and zs_free(), but only when ZS_OBJ_CLASS_BITS does not apply.
+	 * and zs_free() / zs_rebind_handle(), but only when ZS_OBJ_CLASS_BITS
+	 * does not apply.
 	 */
 	write_lock(&pool->lock);
 	class = zspage_class(pool, zspage);
@@ -1974,9 +2014,9 @@ static unsigned long __zs_compact(struct zs_pool *pool,
 	unsigned long pages_freed = 0;
 
 	/*
-	 * Protect against races between zpage migration and zs_free()
-	 * (only when ZS_OBJ_CLASS_BITS does not apply), as well as
-	 * zpage allocation and free.
+	 * Protect against races between zpage migration and zs_free() /
+	 * zs_rebind_handle() (only when ZS_OBJ_CLASS_BITS does not apply),
+	 * as well as zpage allocation and free.
 	 */
 	write_lock(&pool->lock);
 	spin_lock(&class->lock);
@@ -2298,23 +2338,17 @@ EXPORT_SYMBOL_GPL(zs_destroy_pool);
 
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
index dc0400d7e1a3..241f9fdebaad 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -216,7 +216,7 @@ struct zswap_entry {
 	unsigned int length;
 	bool referenced;
 	u8 pool_idx;
-	struct zs_handle *handle;
+	struct zs_handle handle;
 	struct obj_cgroup *objcg;
 	struct list_head lru;
 };
@@ -770,6 +770,7 @@ static struct zswap_entry *zswap_entry_cache_alloc(gfp_t gfp, int nid)
 	entry = kmem_cache_alloc_node(zswap_entry_cache, gfp, nid);
 	if (!entry)
 		return NULL;
+	zs_handle_init(&entry->handle);
 	return entry;
 }
 
@@ -790,7 +791,7 @@ static void zswap_entry_free(struct zswap_entry *entry)
 	if (WARN_ON_ONCE(!pool))
 		return;
 
-	zs_free(pool->zs_pool, entry->handle);
+	zs_free(pool->zs_pool, &entry->handle);
 	zswap_pool_put(pool);
 	if (entry->objcg) {
 		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
@@ -890,7 +891,6 @@ static bool zswap_compress(struct folio *folio, long index,
 	struct scatterlist input, output;
 	int comp_ret = 0, alloc_ret = 0;
 	unsigned int dlen = PAGE_SIZE;
-	struct zs_handle *handle;
 	gfp_t gfp;
 	u8 *dst;
 	bool mapped = false;
@@ -950,14 +950,12 @@ static bool zswap_compress(struct folio *folio, long index,
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
@@ -982,7 +980,7 @@ static bool __zswap_decompress(struct zswap_entry *entry,
 	struct scatterlist output;
 	int ret = 0, dlen;
 
-	zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->length);
+	zs_obj_read_sg_begin(pool->zs_pool, &entry->handle, input, entry->length);
 
 	/* zswap entries of length PAGE_SIZE are not compressed. */
 	if (entry->length == PAGE_SIZE) {
@@ -1004,7 +1002,7 @@ static bool __zswap_decompress(struct zswap_entry *entry,
 		dlen = req->dlen;
 	}
 
-	zs_obj_read_sg_end(pool->zs_pool, entry->handle);
+	zs_obj_read_sg_end(pool->zs_pool, &entry->handle);
 
 	if (!ret && dlen == PAGE_SIZE)
 		return true;
@@ -1608,7 +1606,7 @@ static bool zswap_store_page(struct folio *folio, long index,
 	return true;
 
 store_failed:
-	zs_free(pool->zs_pool, entry->handle);
+	zs_free(pool->zs_pool, &entry->handle);
 compress_failed:
 	zswap_entry_cache_free(entry);
 	return false;
-- 
2.56.0.506.g506a7eabc5-goog


