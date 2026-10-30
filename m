Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C694606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 04:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=Qs+AXR7M
Received: by kanga.kvack.org (Postfix)
	id 7052E6B05B2; Fri, 30 Oct 2026 00:17:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B50B6B05B3; Fri, 30 Oct 2026 00:17:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57CEF6B05B4; Fri, 30 Oct 2026 00:17:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 230996B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:17:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8DAD81A05F3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 04:17:13 +0000 (UTC)
X-FDA: 85377982746.08.83E00AA
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf26.hostedemail.com (Postfix) with ESMTP id D6B4C140004
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 04:17:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Qs+AXR7M;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793333831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ziKDLwdi7Xg2BI9BGIHbHFAW0eYl874oVOo8/AYqvjQ=;
	b=mA0w1lSEuvdwJSYNkV8xwLZ8faFs4xnhlQdr7wgPX70enUgjYJ0rf7z0UUJJInyI2muaAK
	4x8QQu02GjFmXUFz1826xcey79l+k222aMfoWI4WV9Ws+MEP9Psnit5NODNhzfFEZEvrR7
	di0Hsb6iUfaxZ4bB6oBVhE2i4ODwhpo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Qs+AXR7M;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793333831;
	b=l8u+CLy0f/NGzbv8WPTJN6ZtJFwKapsiAuFnbWf1bHdb4JOsQueBp/2lo7RwJKaTz21h56
	blFGcMwvRyXN3yBzqi2E7El/qJbMFr8OUDG0P2Jf+272bS6ZzmU89/ahKKdRY1AsRaNECM
	Ov2RD9/GTmB8P0OdUzGF8JuMsisPauA=
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-3535a54bed9so515807eec.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1793333831; x=1793938631; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ziKDLwdi7Xg2BI9BGIHbHFAW0eYl874oVOo8/AYqvjQ=;
        b=Qs+AXR7MQmRAhJ7ZNnmOpmUAyIKTfEf5Qjp0MJLOg3G1K7xpo9k1uE7GUNER5LX5nf
         VgIigS3qYOMTuqGhOtTct9df5ZiCmBXn/MW6DyOma8aaOWY0DOeOLFtIr7l4XmS7v1En
         LSHfxTED4zTSpFkv6dYe9NkgU1mBkGe4N5N7k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793333831; x=1793938631;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ziKDLwdi7Xg2BI9BGIHbHFAW0eYl874oVOo8/AYqvjQ=;
        b=Crqrqb7k5hDFJx4HggI3o8eHJABJfpaTgxr1N3LDNQrG1335j90en2dS/Xl8arAU1a
         wAWu62fzTYN0ynjYo+YVe6oLvb1SKjfTegJwwQUavuUo/hg0/ptUJ8qVC4A5HwnYsk6m
         PtuBPpe+I3ptxHbFAi7k4mgvGx88EgSiGb1w+P/noUhVRfZMv/jpr9NB7oGjVa7GWXLJ
         Gn8R9pjn0EYbqMJL2jVyhXkOiHxUVJBgxYkPEIAn4N5rMSmhLA+t/a+nhNfwxryoiJAL
         3tqWxjy2wkrb4ITg4r8xIcLBQIKa+/cYihw11xqR6gCqTPRLAA+jFxVHvkfUBuGSoHJ1
         sNcg==
X-Forwarded-Encrypted: i=1; AKwUvBwZLbVZ89brrpkhoaceu0Q0sI+zNiEouzRBqMx5eNk0geWqrOI1NslIAl+qwwPn6+uJpBhCq6oULw==@kvack.org
X-Gm-Message-State: AFq9FYI6CGZu7iroaPxPnAZ1jXHNn9rcgcEwQlr+xrhJN/gTKGP3PCS6
	GFcV4uI6EBI8ex3/z0RTteJccYX8wQZXRjRog573t3LdgoBn6rL0q4zl4zRZ2aXhHQ==
X-Gm-Gg: AYBFou3StdKvxqMRtdPMUKR7Ril/YidqFrjGCFhUPFIrvMOtzvMm3/JWbiOsz8sgfv6
	VlSH/Cpj8EIh5vXKjOiZl6VQLqG+fI3cqofpCrHZZ12oXKrzsLY/XoCvMefG0s6WvkTEIDNOFnu
	a9MhZyzBG/hQgwe9GbP4nn3nBCtKbO7I9T87hm4VLTOWd6av0Sy+gTj94LHypD7T//Zs6dtZwiZ
	LzmPZmMcKAPy5ztJFDd3po2fNDGJnMLGcEWDPsejM4Zkd7SaLzl9B+BkexSzL1fnXdwnd5Og9ew
	d/nAfJX5bMRK2/kGXzpw96yaD+A+2flW6ppirLviS6DdnITVmNulPNK13Qmq5WkR0XvUSDld8qM
	8Kg1U7e/l5GGV0fE8W3xw61zli9mUqB+JWDwINQx99JegZygemzkz39XPcJbpNGxe0JNzEFdfdK
	ZVHYcgrI2KKy+S+DU1gZcwjFr7gUysdGPt2gQ3fZ1jt2RzFOSVxtRTIEbTACEnws12TCrsdKtev
	nVoZ1brsmWlMlIQ7VpN0cJDR8YpioCBgHPacvJhncQ9NwTSJ1FUWiVxVdKpcQPVXNg03LK97+Vr
	d//Hz5GmNDU5N7f9hCOyimDfpwANfbJrtvk/KRZzbo8ce1qj2VU1XS2G1c6uFgCg7QfwI+dLwIc
	Ugf1TTgLsL4XmOryCzw==
X-Received: by 2002:a05:693c:880e:10b0:369:987f:d15e with SMTP id 5a478bee46e88-36a4221b055mr2051888eec.2.1793333830552;
        Thu, 29 Oct 2026 21:17:10 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:7476:5b7a:d979:2d91])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a429467cdsm3329154eec.19.2026.10.29.21.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 21:17:10 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 1/2] zram: fix quadratic writeback bitmap search
Date: Fri, 30 Oct 2026 13:16:49 +0900
Message-ID: <20da9e9a5ffefd1e6875e311d3740b9f3c1061f3.1793333729.git.senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D6B4C140004
X-Stat-Signature: yjsjip5xykp6c9iqug4qax9k8rqwoodt
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793333831-144849
X-HE-Meta: U2FsdGVkX1/urLLvsLf2zEwujrbzN3W5cmpY+1CzXTIk+vP3GqRZjqIJ0lKGcT/0XtGIwNXvbBcDQwxibPR6OxIkxPyGuVX4BWpDJOTAAif2koEW6aZ9mOqynXYsFkn/pLX3Tf5DG4v5+TplpFrcNPlDhUfao0TifmD1nXBk9fh4R+YjlpDxgjAr/9J/5HiHJAC4Ca4l6+/7t8Z4v3tXjayUpSoNUhp/4NBs+Ek8qXoaWqsBnEQ8ZRlnvBRJmc+OLf+/WScOq6e3Tkhqqlmw5mE8Q/a1HzNSRnF2UdDk199cqBTh1R9vMVw/AhowzgjQHpuCHkqmjDQGFmzqG+aajR40sRTcIw4XN2to0J6wZngtUM7n6WfwDt5yF/fgeMydVjm9NOaXK32/Rb4fblBbNsUzkSJa92di+o+CKe1HVkvK1cv9DSQqlFrmKw9x5HqUwTxEX1tJIz/IVbZ8cXst0xEoDhQ+KoyySGLOs0zcNG2W06ApJ1wq/Cy5Y9yY1o8YDaNOMxW07EjWl4Cxao9WXSO21W8WOfxaib8x+GAE/aZPdwGY7m9d70mpkcL7Uy14bpHSWq12HCGmW/1+xU8rDvzAlH2Fx70wtub6zQ9QkY1/pNamt4jFFzjOZ8ULaIzWDuaCRvjrImbD7Mr3ACFX/J9QZO/HMgjI1abkXbKM5GcTRJAAEWw1sC1Gz4IQA3IXf2YPvDtyiUPh1kh739YfVqvCtdWdYm86b7ZlG1+bckWcHhuXGrbnCt5gkXhqBJ98UXqgFpaMPPP6z4SHOnP77866XPJKBJ4F25ceCa+0FNVIFEXBs7GWxn0kgrBageWZg/ohULhWbAAALdVwVv57g/KcXzKmxVxPlwY/qp8UAjxXLtd+aHu2klgUbWpKfY+QuxzfMIW2QoR/Dk4pEvzy9T4Ywa6OYn6QWZTjTXJX4wQGnDjHR72fBFqys1Ach0+egEBUkohpBukm9HOxwUC
 ImNxIgnh
 pdqQqpT/ewrVTk/3b5X0GIYspb4VkU3ikVsqEoCU4qK1DpBSMr0jqf7g644L3M3vFleYlYzuIMNijY3N6qksCfr8YdeGW1LxZ2JQPjSUZsr88f9MK+iOo7O8mFXLOHxDeLb8ZLZGJPn7Pk8ODYVLN2H2HzOUGTcnQlhSOKl1zKZLfYZTRE+CKZa0P4WGb69fTI2pkPlztJEknlRH6Cx3jTmFpw035wgD3g4L+MjBjEC5vULL20VkNX2LDPncS3j2X8mzEgLazIBoldGEFbAbUiJy+XBZiL7ij145WhgT+3w45HWU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zram_reserve_bdev_block() always scans writeback's bitmap from
offset 0, which results in quadratic complexity.  Introduce
per-device bitmap cursor member that is set to next to most
recently allocated bit, so next time the bitmap scan starts
from that offset.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 17 ++++++++++++++---
 drivers/block/zram/zram_drv.h |  1 +
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 9593c14a1f81..632045b65bdb 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -694,6 +694,7 @@ static void reset_bdev(struct zram *zram)
 	zram->disk->fops = &zram_devops;
 	kvfree(zram->bitmap);
 	zram->bitmap = NULL;
+	zram->bitmap_cursor = 0;
 	zram->nr_pages = 0;
 }
 
@@ -786,6 +787,7 @@ static ssize_t backing_dev_store(struct device *dev,
 	zram->bdev = I_BDEV(inode);
 	zram->backing_dev = backing_dev;
 	zram->bitmap = bitmap;
+	zram->bitmap_cursor = 0;
 	zram->nr_pages = nr_pages;
 
 	pr_info("setup backing device %s\n", file_name);
@@ -807,10 +809,19 @@ static unsigned long zram_reserve_bdev_block(struct zram *zram)
 {
 	unsigned long blk_idx;
 
-	blk_idx = find_next_zero_bit(zram->bitmap, zram->nr_pages, 0);
-	if (blk_idx == zram->nr_pages)
-		return INVALID_BDEV_BLOCK;
+	/* continue after the last allocated block */
+	blk_idx = find_next_zero_bit(zram->bitmap, zram->nr_pages,
+				     zram->bitmap_cursor);
+	/* wrap */
+	if (blk_idx == zram->nr_pages) {
+		blk_idx = find_next_zero_bit(zram->bitmap, zram->bitmap_cursor,
+					     0);
+		/* bitmap is full */
+		if (blk_idx == zram->bitmap_cursor)
+			return INVALID_BDEV_BLOCK;
+	}
 
+	zram->bitmap_cursor = blk_idx + 1;
 	set_bit(blk_idx, zram->bitmap);
 	atomic64_inc(&zram->stats.bd_count);
 	return blk_idx;
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 7a55d751417e..c563a7c13a49 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -152,6 +152,7 @@ struct zram {
 	u64 bd_wb_limit;
 	struct block_device *bdev;
 	unsigned long *bitmap;
+	unsigned long bitmap_cursor;
 	unsigned long nr_pages;
 #endif
 #ifdef CONFIG_ZRAM_MEMORY_TRACKING
-- 
2.56.0.317.g454f8302e1-goog


