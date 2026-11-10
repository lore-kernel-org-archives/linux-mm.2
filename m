Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9632160A380D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=hxBRQ48b
Received: by kanga.kvack.org (Postfix)
	id 1FB3C6B05B9; Tue, 10 Nov 2026 00:49:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 185376B05BA; Tue, 10 Nov 2026 00:49:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04CBD6B05BC; Tue, 10 Nov 2026 00:49:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D2D5C6B05B9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:49:03 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 64C4DC088C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:49:03 +0000 (UTC)
X-FDA: 85418130966.06.0924B96
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8E92E140005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:49:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=hxBRQ48b;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794289741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xEWSzx4ZGcyPZGxiCFnQgQ4OA1lpLc+LVHPbJjOB2UQ=;
	b=7nE6wczTXP5qRlZh1gW/hC6Vb5Qf6ceE/DdtP4SgX4CmRUCujwivft86cSwmCuFmsurFrw
	O2M7/ztns05I37A1SQFqvhuzPteFgKERTaQuwXpoZfxY3bB2bF6AkseoGtxOjlK3wPO+pp
	gOATs/bmD7AxbyYTbH+HrQNQ3Q7tFmY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=hxBRQ48b;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794289741;
	b=hLXn5Jm3cxrCS3YwfoweYNP+bDM+0yoYx7AvdQFiALRRiRuk+qliPNjbu+mkgIyAs6VwZt
	Ou11CrIklij8a8/lOKoKwNzz6OZAn/3LGbEXEuijsJ60UyAyKn/sNgCr+0OXnKrxiAM2nL
	cVHXGfz0rMt9ewYGK+okgy2bdvuk01Q=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8a05b210703so811739b3a.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:49:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794289740; x=1794894540; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xEWSzx4ZGcyPZGxiCFnQgQ4OA1lpLc+LVHPbJjOB2UQ=;
        b=hxBRQ48b7R05LeiK3eqEgQl5sSro+lLwkc6+qRqgFkjWa+MzfldxuDvkn7pRhwUaof
         DUuaAg3pHQTAq2WvxCkN9QQpEztLGiKcUAqIcPdZQBCGWGxgcWrPKEUJIq0LmesfbE6G
         F2xzzPc4c6psSyTkn6XBlkF5+qBVZzM7FGzTQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794289740; x=1794894540;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xEWSzx4ZGcyPZGxiCFnQgQ4OA1lpLc+LVHPbJjOB2UQ=;
        b=YlIszrIbPAkoktdwSUKCMYm282HeuNMZBCJ1J507nU9OWIsQ4svxzppwByAvJBtg6X
         UYSwDCqeILUVjHdpSbR0NbSq/3ukWl9jfVeGNNHlwSHhqVOwFXPIMLCdu6X9eljyNz5K
         U6LoE1k3vZwYm4+MmeXh3fEt++JnMY8g85j2AQ3W3jFwDKXa+FEweZmp4qQiQTXmB1s5
         vkIQx34xJtMbK3RzhkCPN8p+qDTY0cC3i6+sjUvqXb8nbfYKUhf3QZF9vBQpw02yO6gI
         osaDFefun8u0h77clFg1dzUayPeyXcrszM/JMjwa1Mi6Zvzj/F+8Alpzgbb4lYStgzXe
         rauw==
X-Forwarded-Encrypted: i=1; AL+hErH/6Q82AO7oX9XUHCNVvlSCp31krwT6U38fDFVB1vh/eym4nlAboBauRjuPITtfKnuh2ue12TcKMw==@kvack.org
X-Gm-Message-State: APuU4Z/l6iXfYDeEgH5DlJZGzbz/QS6bWE9vJeY4xpyp3/l+Yei3chpH
	4q7o8G4Lkl72I3tYNnlrTxLmZetXdpML0YQVupOI8N6tZHvueQasj0mNBYQ/4UKhag==
X-Gm-Gg: AYBFou3zW+UH0jCgam9BjuxJoVuLjlM64vXR5ZzBAlm6sNdvQ9FIpaU5TNka3VG/swL
	Joihka9vl/6CdmGQs4HmfpPeZ5L0tBtM96jVBR9VVBA4/KRq5JccqrVFULRvael6P7r7n2t3xRy
	dr2nld7Yc+6t+sOcY80I5j3T1WRRpTKERaabEtmpWpyHLMV6VLVuGbWudDAeTuPjKU4d+g2rah/
	o66XTdHA0xhQv9Ldwm164lLDNnNogJxshw4cMVhuavZOYE+dv00mOgVJ9GBdzsRwg9OU/wEnXT3
	OGGq+CzSdCGyuUjv2b7b/Zkb0G3UOx4NupxTpeUGCktOz6FYJ95y6RAkY45YjrsDx9OCV++N5XY
	BdiV/BSbFoNpapw9xNySJ7aVSrt9Xg3r28Kpr3wNpWpnkvX3kZE9fAPH9j8ghbgj4xt1kuGjpS7
	YbH4XQ/RHw/t2Lf9U6svcdjGluOnxCyVwJpJPKi8mcRxs0gzFHTPwZadCwymyKJ45N2o9ES7aku
	kegy3iI47953hGDSnkTvSl4ddN/XnmOl4rihNEWYcJ1xOPGt8RF0asnAYw7zzp7jYEREEVDx4dT
	uEMSbmAaG7tp8x1BnSNnnZsSsy06DNLD3U7z79qfWSJ/cDGSP0EZSTj2Od1aZLJFDNhoQZA7bLu
	7BzeMjfmv+zRpWtdWwg==
X-Received: by 2002:a05:6a21:6e04:b0:3e2:3392:53f1 with SMTP id adf61e73a8af0-3f18c6267ebmr1458477637.5.1794289740404;
        Mon, 09 Nov 2026 21:49:00 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:e137:9384:7cd8:6e40])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdd8d67e53asm444634a12.5.2026.11.09.21.48.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 21:48:59 -0800 (PST)
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
Subject: [PATCH v2 05/11] zram: check mem_limit before allocating zsmalloc object
Date: Tue, 10 Nov 2026 14:48:10 +0900
Message-ID: <20261110054836.1515030-6-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
In-Reply-To: <20261110054836.1515030-1-senozhatsky@chromium.org>
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8E92E140005
X-Stat-Signature: eijwx4sn6m1g6redtns5efb48ecfnnpf
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794289741-258067
X-HE-Meta: U2FsdGVkX18gMxSY977MOHlG9cX40kD3Vf8txAgVVgWw2/O0HVvEourPpOh+CjxJMtAYpJ3/4pJrRGLtRyBkEiK9UV/Umx1KSIuYrfG7+rneYYQHCTnFc50aZXO1GoRQOaw+Phr0fdr99kbTmub7z+9y79Xv+yM+jDmKQBYelraSUoPKjmtZNAK6OGBH54IOgaKapqNq02ma+tPDYpeRUhaa73crl/CCEc/LzduqjIrG506NptPlQjPu26coAjAlXx+DqCfCxl7SkjQHzq1pFdyPac7gkwwEV04gpZTrnOwu+gMdMDPk1dJqsKZvzhJTd2XhKPK+dbwawjnaYg48t3hY0rppx6AIWMR6jZV4UUFgqnjCmMT0xBcMp5a5zgS9GH/+WAhSYFg0DCTxT5voWOjomZ0lPhK2fh8FBif5haZHfZrNdpn60NZ26P8qn3HfRzW+I5RI9Y9YDWtT4MwksWfu/9SZ7ahJcdU6SOFdP/5l1rfceyz5YA5NjhwjZjKs6n8e6wcgyBXOlDlbOoPviywk6zdSu/0tAe0XLcFnNFHXFUqqUdRxbmFBt6Qe0TfDW8rrWw1tl2kGa/ztpw3xvmq+7O08cBC4zWLhpTuj5Yl3N/kJFJWAh/XIEkEAHy1sJ0bjOK3GJoHgz+uO6inJnBi1ETU1qqIGr+YWwDgGAe5MBSjOa7YwhhaMnkUq6N3NK6LVGzPSpwUv+OQNn+y6cuDB+AP/8FZsUFe98qvzWvBGeM6mczO4wXAt4FasfS7/zoeAZhN0h1dcQyMX8vZOB8JNIUcbh2ohrVzg4ShRgM5GlLrfHbV9M8evBhUqTqMRV+DfO27TxbrCrhpGFKTZngevT3gzPStqus7jSUjlWvOdzuYArc8oVTjpu65awzsxf9RFqC6lJjmW2BpRluuAJi1qmAL4tIQvbWO7Ek7iKv+L2OQ95kfk2PVYH00iPTPZpHnAhrwxWhji+7FnU7O
 Q5eeTGNb
 L5H+EpXXG3SgcjH0Kn7L+3nWcgteA25PlCJQ+O4tKlBMQYrZJ8oqZWgZbs/4Wo2ct9A2LM9Sw0xP9o3tO8Ymi6Z7ixQHicvlIBsQTCOjWUD+BiyBXZ50Fm5tVzREZKC+1hk8pus1rKx16CzIIpkaGWFlq2QIBbDBv1JM0MFmLnjduqd8gf0m1Rqu9UopK56OI+wVjeNMR/fDFYIdOYZZzV6mTMceQksX/7s6SBwyQyL8zwbPFSFkpv819t1YlHT4n+Q8yAUlx5lO6DElYNL2wTsMrfAiuIHaNw3vsguuswNtN9kS1p9/djMIvdwPJpcfV725Yusj3IcUHRrothiiPN6o53nY/ZISjqdO2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zram_can_store_page() is called after zs_malloc(), so once we reach
mem_limit every write that doesn't fit into a partial zspage allocates
a new zspage only to free it right away.

Check mem_limit in zram_write_page() before compressing the page and
allocating from zsmalloc, and update max_used_pages after zs_malloc()
succeeds.  mem_limit was never a hard limit, the allocation that
crosses it happens before the check anyway, so now we can go over the
limit by up to one zspage per concurrent writer, and writes fail early
until enough slots are freed.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 Documentation/admin-guide/blockdev/zram.rst |  4 +++-
 drivers/block/zram/zram_drv.c               | 25 +++++++++------------
 2 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/Documentation/admin-guide/blockdev/zram.rst b/Documentation/admin-guide/blockdev/zram.rst
index 148b7cf3b924..db256c53b127 100644
--- a/Documentation/admin-guide/blockdev/zram.rst
+++ b/Documentation/admin-guide/blockdev/zram.rst
@@ -181,7 +181,9 @@ Set memory limit: Optional
 
 Set memory limit by writing the value to sysfs node 'mem_limit'.
 The value can be either in bytes or you can use mem suffixes.
-In addition, you could change the value in runtime.
+In addition, you could change the value in runtime.  The limit is
+checked before zsmalloc allocation, so memory usage may slightly
+exceed it (by up to one zspage per concurrent writer).
 Examples::
 
 	# limit /dev/zram0 with 50MB memory
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 2c2e11b2b663..d38b20a22595 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -177,8 +177,9 @@ static void mark_slot_accessed(struct zram *zram, unsigned long index)
 #endif
 }
 
-static inline void update_used_max(struct zram *zram, const unsigned long pages)
+static inline void update_used_max(struct zram *zram)
 {
+	unsigned long pages = zs_get_total_pages(zram->mem_pool);
 	unsigned long cur_max = atomic_long_read(&zram->stats.max_used_pages);
 
 	do {
@@ -190,12 +191,10 @@ static inline void update_used_max(struct zram *zram, const unsigned long pages)
 
 static bool zram_can_store_page(struct zram *zram)
 {
-	unsigned long alloced_pages;
-
-	alloced_pages = zs_get_total_pages(zram->mem_pool);
-	update_used_max(zram, alloced_pages);
+	if (!zram->limit_pages)
+		return true;
 
-	return !zram->limit_pages || alloced_pages <= zram->limit_pages;
+	return zs_get_total_pages(zram->mem_pool) <= zram->limit_pages;
 }
 
 #if PAGE_SIZE != 4096
@@ -2266,10 +2265,7 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
-	if (!zram_can_store_page(zram)) {
-		zs_free(zram->mem_pool, handle);
-		return -ENOMEM;
-	}
+	update_used_max(zram);
 
 	src = kmap_local_page(page);
 	zs_obj_write(zram->mem_pool, handle, src, PAGE_SIZE);
@@ -2308,6 +2304,9 @@ static int zram_write_page(struct zram *zram, struct page *page,
 	if (same_filled)
 		return write_same_filled_page(zram, element, index);
 
+	if (!zram_can_store_page(zram))
+		return -ENOMEM;
+
 	zstrm = zcomp_cstrm_get(zram->comps[ZRAM_PRIMARY_COMP]);
 	mem = kmap_local_page(page);
 	ret = zcomp_compress(zram->comps[ZRAM_PRIMARY_COMP], zstrm,
@@ -2333,11 +2332,7 @@ static int zram_write_page(struct zram *zram, struct page *page,
 		return PTR_ERR(handle);
 	}
 
-	if (!zram_can_store_page(zram)) {
-		zcomp_cstrm_put(zstrm);
-		zs_free(zram->mem_pool, handle);
-		return -ENOMEM;
-	}
+	update_used_max(zram);
 
 	zs_obj_write(zram->mem_pool, handle, zstrm->buffer, comp_len);
 	zcomp_cstrm_put(zstrm);
-- 
2.56.0.506.g506a7eabc5-goog


