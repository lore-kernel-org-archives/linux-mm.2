Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23D28606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=NQ+KEAOU
Received: by kanga.kvack.org (Postfix)
	id 60C176B05B5; Wed, 11 Nov 2026 01:47:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BC8C6B05B6; Wed, 11 Nov 2026 01:47:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40FAB6B05B7; Wed, 11 Nov 2026 01:47:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 105666B05B5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:47:24 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 888511C2830
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:23 +0000 (UTC)
X-FDA: 85421906766.07.D3C26A8
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id BB4CCA000B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=NQ+KEAOU;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794379641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tu9NrHqKlXzz55x+volPwRYKOdbYof5nwc5oAEpTpeM=;
	b=BkWizqSJrkrfbk3brhfLACQohySUhFy/6Jh0zLbmRx96FhaP4q43dVM2ZPwqjhqykxajSv
	x1HbtJWBvnIwyIpg0C4wwCjosbiQH9aXoDi8/RoR5BS+ymfjAgUt6dPywGNF4jckNDpzXb
	3XRCBeE+NiTvK080S0DRJU1x9/2dV2w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794379641;
	b=YYrhKry0i4A/wfsl6OzoFCjl8Z0k+K3AtCo0om4fbkt1r+ZzmPyapDEYbShZlyw7vTsWZs
	ezWAtxZnfQtSR2onkY1Q5z3+jmT1CjPtSMJOVCkYpLdpVsBprfEjVydeb5BvKIQhgYOlMy
	HMHFP2lYk61Di/aH3gI3/MlKC1Oc2Tg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=NQ+KEAOU;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ed06b725fdso21306405ad.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794379640; x=1794984440; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Tu9NrHqKlXzz55x+volPwRYKOdbYof5nwc5oAEpTpeM=;
        b=NQ+KEAOUJAC8uc8//A/5Xu34lLrm6rGkLuuAinyI7EcyrUSZo7oTTiAXv+A7M7SwpK
         uc3UAaW5o4vQTGneqgU0MHzVFhYZBMIqGt5hnD+tphwjEwNuIxZBfY1+eWsHDkwvUxCm
         GfERk0x8HhODf5HxG5ZX3xDPcMDtuZaidQ3RQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794379640; x=1794984440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Tu9NrHqKlXzz55x+volPwRYKOdbYof5nwc5oAEpTpeM=;
        b=ReVoI/BmtHDeYhAj7TmJbTsRkaGluHbBq8eOXhAjIlaLYwZWtXV/UdzsYZ2tQWj47H
         nY8Jdw1Ok0Bl8L/kjq+cfnRNT8WaGcM1pgP2qryAmWNtyBMqmbzwChfQGCRx8YU5As8p
         3y+HbYv1zLlNa8DkBYC/AtPhsPQNndacTjwUbRdJYwFXAL1lp0u8lpufu8/ovtnojx6O
         V7TlPt2Os090XCD7CLCFmH9lQ0xQwmYV0oO/wPVArNL05oT/XbnHUgBhoD5PXXvB3b8K
         R03fgEeYdwOyQQRpfFLA84cIn3+RRDBVAUiJSPeFaVT2WQ+G6BmU3ZaXH4j0L1xerxkz
         ofVA==
X-Forwarded-Encrypted: i=1; AL+hErFl1vLwseshYknuM05fyQ6sUVwPnV9J6THP9qu5dTDvSsf2uKOIjD0wgirhF0kzqO/p/oUGlA3OhQ==@kvack.org
X-Gm-Message-State: APuU4Z+ZrjTdKWCO6UhSmR8hGaNzaB7lWyeFFTIeGqAldy2mHWaZZJvy
	jLSiPvk9r9qSVcUnGKlkXoMoRfA+YH/HKW12j1b+Naj7v/g/N/HBFsRtkZ2IgYTSwg==
X-Gm-Gg: AYBFou3tzWD5q6Ya441VCAlEZdn0vP6GTeSzeqqweKUzCYCFiPOksgqYP4PJ8S73z6s
	HMjveH+QKsua4/H/O+/RIwZe9pFjDiXhTR7QlEpwxsd2XEkOYJdLDtLeKML3CPj4Ot411iz8xaR
	5LEjT6sLsLGzEeKF/ZNgmK4uyTBG/OLHio0D3oHtxJoHVoqVRx7OBZuYPfPLwaw43a9Q6bJGPem
	CxJev+IiIV+SQgiELiNZufb2GNHirW2j6yYHPfTYSmwfbA30rzUxgmVzUVc3Nk8I+Bz5em3QGFD
	nSpNfMLuucCthMgcD1YYxlz0zKsnvuhbNVj1MYOlmXaeZ4FjcvtMmCuRL6YsjvwjpH1DsuR4638
	9m62EoFks/o+8dzGct1dRSZ1BHYz2cDsvy95IHGNaCDYOBCoL8huuujxvH1haVdkNHzY/kTTvVp
	NPSu+LGLHN6U3R08AVh02Ibf/XrT5WqBWQF9+ZHuhbvOZyRJshkzojsM+/A2ULBkSOsaYiEGycT
	fd6riCln2smUmzZbsSp6dExV6MAkNPs1FxMygCdil/oTA7jDSnV1YFVuj3BI0p0b2iUkoMUtowZ
	3wXRfIjBRPzaA/DQIMmLsM8xdW5RINtJog1a24Hn4FTMMoGllNIhaoytLorNCWjzO1iTN8hhldC
	l+O3aMhuTxfTy9xvP7A==
X-Received: by 2002:a17:90b:2b43:b0:3a4:b509:88bd with SMTP id 98e67ed59e1d1-3b182e0c1fcmr1171979a91.2.1794379640543;
        Tue, 10 Nov 2026 22:47:20 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:ad6a:b446:df00:78dc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17db85a9bsm3268666a91.14.2026.11.10.22.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 22:47:19 -0800 (PST)
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
Subject: [PATCH v3 02/11] zram: drop get_slot_handle() and set_slot_handle()
Date: Wed, 11 Nov 2026 15:46:25 +0900
Message-ID: <20261111064707.2568433-3-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
In-Reply-To: <20261111064707.2568433-1-senozhatsky@chromium.org>
References: <20261111064707.2568433-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: hokd3bpsq6fxyi5jemcgdubsaweguyfo
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: BB4CCA000B
X-Rspam-User: 
X-HE-Tag: 1794379641-765118
X-HE-Meta: U2FsdGVkX188RcGv5QloupYcR9tYPO/M8C3osjsr1rUhklE2/ISnM42MF9PIxeXcz5x+s30jYZVv744OWlHmludHJq9sNjBXE7bN1bTbnEq644Q3Lw8ZBUWPpJHr7WAso9m8MusfsCm7+YmE4aoaY6rATBDBe6Fi/3ISShWptkHBF90dboFzHRflJfmnsHl/UPYPjLryc7DbTrTLxryVduGjT1ClxPq1Y1/kIFTfSrlZUBo1m8PBpHK6xfKA+bEhn7ZTrhraTvio8mh6LW5rlxYZSSF1u28tMkWMp2wwm/4TRYxZzs1siFT/lLOrY3e9vKYxWaUk5kcYgDx14l1ww/xsTUVZ6b+BxNw3TvbZC8rHCUbsdVC491q4xkIUFucGjzeq/xOvFUFD842eJb85PBJmCid8wduYuId+3MiipHO9H3sdqfL0o47WaejzvqYvQYpUFUg3p6+6A00q7paYcHgDIV5qfYsAvBjweNB77bhQXBmmWUx3zspoM2X5pbt2nFf5FdCmZSVbGggM8IcfHxgb0N0dQnwcAHDetzI10WZ7EcLOA9Hh+wuOMPLwLI4A9rs3LAX4GQVBzsOhuMzZyiIZCtwJ19fHnF7K13qki8Oh1sQhIFWcSf1zPI/ZtAuYOnUPcAKGMJaEAix4BySI/dGpeVcfCBt99f0t830EwlnGqlQmNTzDLDNKGVK9SyE5jxn8ty4jHyYJPnUZUNfReKit3m1bJlFZxSN0PHBkk//XglB2XtDPwX8dOOFNLGudj0BOJb8qB8PJwUhwzGg5NRsxUQ/DUjQHqEgtcAeXM+AmYXD3Gvj8sDGX92AcccwTw1UwYxoZk9GUZ8pddeUPMYBLt8drEjx4LtC5Tilx6sW/qin36msuvHy998MiHTs6GJZRybsG1ETDpiw8E2PLyCfjl/NtBvT/AxnNws44l/7mwoNClyKIrufJN8adBu63SBqLrTnwNgbFDXJV4Rs
 Jnb0dA85
 FAAaJMEmUUofkofQmOrs5yxhsTTAAgcNFETkAjD4tVWKJ4pBsXKKcbAnLnu4WH6MyZNcESu4xTZ7Z0pzRgihGA77OvM7ADYvEKis1ephdAAt78x3IcsBiUMqox4YIGmy2UleKyngO64v9jO7qeAVIuPAAU80+SFLxDp2ZaTnpH21OYNb2PqlGU5yHKWpQ8s86lwCRHAwJSWzvL8bO/UIq+x+l9FG2ryaaRzNcSGg74wMTYHRhdG1mYfHIavE6SEwCljQ4WCVzYrZBjYLUrHVO/llPx0TkGaboeC58GPuep+vc+N2RAxRzzpY1PXLl3Ow1QqGCgA+eitmmRnEawNapcox5DjPtXCG/LSyH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zram_table_entry ->handle is overloaded to store zsmalloc handle,
same-filled page pattern and writeback block index, so calling
set_slot_handle() or get_slot_handle() for blk_idx and same-filled
pattern is confusing.

Turn ->handle into a union of handle, element and blk_idx, drop
get_slot_handle() and set_slot_handle(), and open-code field
accesses.  No functional change.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 43 +++++++++++++----------------------
 drivers/block/zram/zram_drv.h |  6 ++++-
 2 files changed, 21 insertions(+), 28 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 380615b73446..5c13addd22f6 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -111,17 +111,6 @@ static inline struct zram *dev_to_zram(struct device *dev)
 	return (struct zram *)dev_to_disk(dev)->private_data;
 }
 
-static unsigned long get_slot_handle(struct zram *zram, unsigned long index)
-{
-	return zram->table[index].handle;
-}
-
-static void set_slot_handle(struct zram *zram, unsigned long index,
-			    unsigned long handle)
-{
-	zram->table[index].handle = handle;
-}
-
 static bool test_slot_flag(struct zram *zram, unsigned long index,
 			   enum zram_pageflags flag)
 {
@@ -962,8 +951,8 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 	if (test_slot_flag(zram, index, ZRAM_HUGE))
 		atomic64_dec(&zram->stats.huge_pages);
 	atomic64_sub(get_slot_size(zram, index), &zram->stats.compr_data_size);
-	zs_free(zram->mem_pool, get_slot_handle(zram, index));
-	set_slot_handle(zram, index, req->blk_idx);
+	zs_free(zram->mem_pool, zram->table[index].handle);
+	zram->table[index].blk_idx = req->blk_idx;
 	set_slot_flag(zram, index, ZRAM_WB);
 
 out:
@@ -2064,7 +2053,7 @@ static void slot_free(struct zram *zram, unsigned long index)
 
 	if (test_slot_flag(zram, index, ZRAM_WB)) {
 		clear_slot_flag(zram, index, ZRAM_WB);
-		zram_release_bdev_block(zram, get_slot_handle(zram, index));
+		zram_release_bdev_block(zram, zram->table[index].blk_idx);
 		goto out;
 	}
 
@@ -2078,7 +2067,7 @@ static void slot_free(struct zram *zram, unsigned long index)
 		goto out;
 	}
 
-	handle = get_slot_handle(zram, index);
+	handle = zram->table[index].handle;
 	if (!handle)
 		return;
 
@@ -2088,7 +2077,7 @@ static void slot_free(struct zram *zram, unsigned long index)
 		     &zram->stats.compr_data_size);
 out:
 	atomic64_dec(&zram->stats.pages_stored);
-	set_slot_handle(zram, index, 0);
+	zram->table[index].element = 0;
 	set_slot_size(zram, index, 0);
 }
 
@@ -2098,7 +2087,7 @@ static int read_same_filled_page(struct zram *zram, struct page *page,
 	void *mem;
 
 	mem = kmap_local_page(page);
-	zram_fill_page(mem, PAGE_SIZE, get_slot_handle(zram, index));
+	zram_fill_page(mem, PAGE_SIZE, zram->table[index].element);
 	kunmap_local(mem);
 	return 0;
 }
@@ -2110,7 +2099,7 @@ static int read_incompressible_page(struct zram *zram, struct page *page,
 	unsigned long handle;
 	void *src, *dst;
 
-	handle = get_slot_handle(zram, index);
+	handle = zram->table[index].handle;
 	zs_obj_read_sg_begin(zram->mem_pool, handle, sg, PAGE_SIZE);
 	/* an incompressible object never spans two pages */
 	src = kmap_local_page(sg_page(sg));
@@ -2134,7 +2123,7 @@ static int read_compressed_page(struct zram *zram, struct page *page,
 	void *dst;
 	int ret, prio;
 
-	handle = get_slot_handle(zram, index);
+	handle = zram->table[index].handle;
 	size = get_slot_size(zram, index);
 	prio = get_slot_comp_priority(zram, index);
 
@@ -2161,7 +2150,7 @@ static int read_from_zspool_raw(struct zram *zram, struct page *page,
 	unsigned int size;
 	void *dst;
 
-	handle = get_slot_handle(zram, index);
+	handle = zram->table[index].handle;
 	size = get_slot_size(zram, index);
 
 	/*
@@ -2188,7 +2177,7 @@ static int read_from_zspool(struct zram *zram, struct page *page,
 			    unsigned long index)
 {
 	if (test_slot_flag(zram, index, ZRAM_SAME) ||
-	    !get_slot_handle(zram, index))
+	    !zram->table[index].handle)
 		return read_same_filled_page(zram, page, index);
 
 	if (!test_slot_flag(zram, index, ZRAM_HUGE))
@@ -2209,7 +2198,7 @@ static int zram_read_page(struct zram *zram, struct page *page,
 		ret = read_from_zspool(zram, page, index);
 		slot_unlock(zram, index);
 	} else {
-		unsigned long blk_idx = get_slot_handle(zram, index);
+		unsigned long blk_idx = zram->table[index].blk_idx;
 
 		/*
 		 * The slot should be unlocked before reading from the backing
@@ -2255,7 +2244,7 @@ static int write_same_filled_page(struct zram *zram, unsigned long fill,
 	slot_lock(zram, index);
 	slot_free(zram, index);
 	set_slot_flag(zram, index, ZRAM_SAME);
-	set_slot_handle(zram, index, fill);
+	zram->table[index].element = fill;
 	mark_slot_accessed(zram, index);
 	slot_unlock(zram, index);
 
@@ -2289,7 +2278,7 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 	slot_lock(zram, index);
 	slot_free(zram, index);
 	set_slot_flag(zram, index, ZRAM_HUGE);
-	set_slot_handle(zram, index, handle);
+	zram->table[index].handle = handle;
 	set_slot_size(zram, index, PAGE_SIZE);
 	mark_slot_accessed(zram, index);
 	slot_unlock(zram, index);
@@ -2355,7 +2344,7 @@ static int zram_write_page(struct zram *zram, struct page *page,
 
 	slot_lock(zram, index);
 	slot_free(zram, index);
-	set_slot_handle(zram, index, handle);
+	zram->table[index].handle = handle;
 	set_slot_size(zram, index, comp_len);
 	mark_slot_accessed(zram, index);
 	slot_unlock(zram, index);
@@ -2471,7 +2460,7 @@ static int recompress_slot(struct zram *zram, unsigned long index,
 	void *src;
 	int ret = 0;
 
-	handle_old = get_slot_handle(zram, index);
+	handle_old = zram->table[index].handle;
 	if (!handle_old)
 		return -EINVAL;
 
@@ -2554,7 +2543,7 @@ static int recompress_slot(struct zram *zram, unsigned long index,
 	zcomp_cstrm_put(zstrm);
 
 	slot_free(zram, index);
-	set_slot_handle(zram, index, handle_new);
+	zram->table[index].handle = handle_new;
 	set_slot_size(zram, index, comp_len_new);
 	set_slot_comp_priority(zram, index, prio);
 
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index c563a7c13a49..5416e25e64e8 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -78,7 +78,11 @@ enum zram_pageflags {
  * of each entry and hence of the meta table.
  */
 struct zram_table_entry {
-	unsigned long handle;
+	union {
+		unsigned long handle;
+		unsigned long element;
+		unsigned long blk_idx;
+	};
 	union {
 		unsigned long __lock;
 		struct attr {
-- 
2.56.0.542.g3ef89b7020-goog


