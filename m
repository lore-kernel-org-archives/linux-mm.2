Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CB13CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 04:44:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C00256B0096; Fri, 16 Oct 2026 00:44:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAFE06B0098; Fri, 16 Oct 2026 00:44:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AED966B0099; Fri, 16 Oct 2026 00:44:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 333C76B0096
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:44:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EBC35140291
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:44:41 +0000 (UTC)
X-FDA: 85327248762.24.2784045
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id 237F9A0003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:44:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=PtKsxKAh;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792125880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RdQPj6ORXxug2+szeCJ4g7yFuGdwCBNIowOh0yWYffM=;
	b=NB6qxK94Uc5R0QWPACOQfNoHOCavRlUGT786MIoI7tuaT0bw3jZLzjZiR5erLF0AwUv8Kw
	5eFGAl6tNxoJEtwShnnpir3q4JH/J0o8Uclja1tMxmK9hIi7unRGgv6z7aqo0izkDCpbEY
	lWeqf5CE/COiPpORoD4ove5ELnLcTog=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792125880;
	b=Z9R61c69XMNN3EcyyC1H984dwLmUIvTCMMUla4N7TEmspgwhkI8RUPSOshveJ2ziNF8+6H
	Mix47vJzIM5xVdnumi0cv0J2dsxe0aq2auLF9qFq+v6aTxBMbofj470R7GUIMsyVF0uH5L
	ztNbu7rYJPN/PWWBFTFbQenqqo1135U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=PtKsxKAh;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2e5378b281aso34532615ad.2
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792125879; x=1792730679; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RdQPj6ORXxug2+szeCJ4g7yFuGdwCBNIowOh0yWYffM=;
        b=PtKsxKAh+EVGK7He5ozUdXHpNvmF20oqHcG+XrPn/B/HPaEdahDkRR90nYHAUA+x2T
         dlRkuEhgZ+6Mygjb+po6f24iOflZvAodio1uUbv9RHU7YEUwYpQ6e04Hs3j3WjUC8E1Q
         WBkM0NYJht4ZZG+55AeLS1Srd0pSmlWc3WBIg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792125879; x=1792730679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RdQPj6ORXxug2+szeCJ4g7yFuGdwCBNIowOh0yWYffM=;
        b=YNxTGYMhLIWlJyJ1i0zHieAZ5VLVg/NJ7v66Ij+7BVhEJCrG3nigj6tDHG/4ZasVq1
         uqbioxxQRCoHraemHQOAH1LJKKT0a6xFfLjm/5k+uLx04qb9tpAvMoUC0b6b3RduqKGL
         mcWQh1ch2ssUnjLyVyP/5nXHn5wRHDiy1v7cwbKQ5wuLWniO8kRqmtWvYa86Uqknd2YE
         BjbmvC4YELIHAt6nXGYuN3YcFUF33HAqmW6dfyBOlHSfHStppcVy9TjvWuKoY9iKIh3i
         dhcgwzWrG+X6YF0Q4wxyUXDOlVedJTh+J+Aa61o6/oiyhB5MvSjEDKBRRMk12cb4w29N
         5ERg==
X-Forwarded-Encrypted: i=1; AKwUvBzA9VvwNvr6Oah4rSjjXkgQ1RshvABv0TqdR149jCODDY6auRbfMHML3t1a7iqRJhU+fqKXzwWdkA==@kvack.org
X-Gm-Message-State: AFq9FYK9+4Ys8prPgV44091t2QLGjJDLh7k2/mxY6pPWpKHmF44QCFDQ
	zvo7ZRVP78QMirs/yOWCgt8poFgTn/NDjDmWGrMjZQd/eFNKCbcT+rAv/ytqiH3R2A==
X-Gm-Gg: AYBFou0vCebgjKtPMz3hdvzqGl5mRg65tLnwnWsfn0G3uYeRhqqpWRBvCCc9hRKaL+H
	hofbEHBlwYWcaFfN/r/wDUmj7bVTGawTMy0qPT6nGZYq2w0PQ86D6+pPnrRo3Z/9o40K+EbJLVC
	VR6SmjJMwMgLB4So5esCkweSxI8KWPr3Wz++AOfBHrwiXWwGR1I8DYlj/6od3dWZEPFGO/0Ua0c
	GzQAHVRCmReV7BPiBq6wOEzxjs8HIDIMjzwxtoRtI/Vesw0wLYc483/vOdMBk5pIZ2Wkg2tKWO8
	7ojxSvuX2EHBCcsyK3qNI1W177TyF/LJUW02UXFv33kflc80I18mXJ5J/Zpui+2lxDm+jmttS85
	alu1Vaa3BVh8bZ7jHlNhu3g0i7qtFcCyqpPCTFC52vuaK9TpLtfG0YBlQzfFKlYxsJdFrUL/tMz
	Qz77UMakqBjtQZ5Q26x3CiHBQyp10I4HYTx1ODDjACqdiw7NT1gV+dhNd9ZF91tbnBXin0hxr7F
	QhyBNHLLwayEmadBIk9bNIqYHt5JOIVnr9+3QhU3j/DrEED0P6SK415l16l874=
X-Received: by 2002:a17:902:ef4f:b0:2e5:c563:c0dc with SMTP id d9443c01a7336-2e842cdb0f8mr195353235ad.42.1792125879042;
        Thu, 15 Oct 2026 21:44:39 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:a579:8b87:8304:7ac2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e8b1b5esm4137235ad.67.2026.10.15.21.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 21:44:38 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Barry Song <baohua@kernel.org>,
	Bo Zhang <zhangbo0325@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v4 01/12] zram: prefix backends printk-s
Date: Fri, 16 Oct 2026 13:44:06 +0900
Message-ID: <20261016044429.1304561-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261016044429.1304561-1-senozhatsky@chromium.org>
References: <20261016044429.1304561-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 237F9A0003
X-Rspam-User: 
X-Stat-Signature: dd3bf67scouomch97ttcfd4bhc797d5m
X-HE-Tag: 1792125880-247977
X-HE-Meta: U2FsdGVkX1+imR9TjjRhmzVqOWL60dKwG/wRBtzGfXdrwmQsCswftYXAd+/ek9h3vh7dMC0gzLR4lTqNOv9jvvZQyLcaF8hc6ilbPN8jLBiu2ipHooUBvqD53DY1kC411WYYm45uTMSIhpUuBSDvMiKujFpGnJVnHqztWjEfYq/LkjN9r+Bu6yAUlI+HqqXPtAqolxjdskk8KNFuGS8L1v4uhW0y7D4A4VNyNaZt9nfmKqQrwLKzCREfGG6FqngeFzPSB1cyMt2dVC69d2c5u9fnAmzRNC/qh8xJpg/PCC+u2W6UI5jF0JOlXSHkbsZJbKuwfErydEH+RRexUhVfPY7RCbww2PiQ2JFIgkkYW+1Ks2fQyaWcIeUhWtWBEMjd8PndoohrOVoQcIQpi3Yw5NXlYGohQBYGS7FpmFLobppeI2TlUcjuWkuFZEVTDiEGhR8rw/MDNiVvT12+e9LEAx6qglwUL/m8wjpF436MhG5x3dSLLpAVIJcXUBz3dfI5lOVgtHI4nYXI8OjsivxjMQS/TfNZZw5Ed3HfglJGvfcYWqfvRfqsrJNpaVKuOkEk2EvFmy4oMiv7VQLztxqocoSz/YDbs2MAgKMcpFek5yX19ZCiDJmvAMjVfzByVs2935bKc2xPA7n5mzJgBnRCOlr/FJM2OAVg0iS/rH/4VFKxy4PpLKMPtjPyn6UpFtQhwMsLIVNsz554Jy4NwtnL1TVouujO5ojVlyR41w+T8bu65ZCkQ0Cu62iAZExbJjMJbFY2KtMtIY57l4+cHZCpl/fjaFWebmLQPPh/b5VgYLRxnTB+hdPiBipLCEd2zwDwcZ1CqMxt4T0rIvDrtkaStaHy6KswFURQnTlgvG+ND9DmsKXV7xRmHZB6Fg3K5n9p/Ligd0Zzkt3fQCLT8mIKqVcnCECg4P7hMG4E7AVqRT9uO9p8bOSmQkESY2ButBqvCNpEwb4fAElkv92zAvH
 imY5LE9m
 iw+BnzIvx3B6WdXFBcSxme9JY6WfUlASeOJ9ZvGkiVQDvLz9Y9rtf+QQPJCEkheDw36EcfQWH5THvLoXHzqEWimyhZ/vXeCFnDeTXgkcMqeZZ+P1FJrasR+caM1+psYADUKYpgFkxp02yZHrAhX5Lmta1DSXZtgkUqofsfAPtibh4JbWIeboMvusEuZhYhZ++yQJdN0NeXssY8g8zBHacqVCNp2xG/Zbd1dtzwsPRWesw/ocOVKLwQ7yAsp97baekIJu6gpGYbcf9+O1DgoxkWYd9/NN2CFXRQrOVBSy2fMBs5KLEv1PSjBKf9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, zram backends prefix printk-s with their
names, which may look a little confusing, e.g.
"zstd: alloc size 408128".  In addition, prefix
backend names with "zram:" so it's clear that the
message is coming from a zram backend.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/backend_842.c     | 2 +-
 drivers/block/zram/backend_deflate.c | 2 +-
 drivers/block/zram/backend_lz4.c     | 2 +-
 drivers/block/zram/backend_lz4hc.c   | 2 +-
 drivers/block/zram/backend_lzo.c     | 2 +-
 drivers/block/zram/backend_lzorle.c  | 2 +-
 drivers/block/zram/backend_zstd.c    | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/block/zram/backend_842.c b/drivers/block/zram/backend_842.c
index 3846a04c69d7..56ffda201727 100644
--- a/drivers/block/zram/backend_842.c
+++ b/drivers/block/zram/backend_842.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
-#define pr_fmt(fmt) "842: " fmt
+#define pr_fmt(fmt) "zram: 842: " fmt
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
diff --git a/drivers/block/zram/backend_deflate.c b/drivers/block/zram/backend_deflate.c
index f71b11bcac78..20685aca9bdc 100644
--- a/drivers/block/zram/backend_deflate.c
+++ b/drivers/block/zram/backend_deflate.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
-#define pr_fmt(fmt) "deflate: " fmt
+#define pr_fmt(fmt) "zram: deflate: " fmt
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
diff --git a/drivers/block/zram/backend_lz4.c b/drivers/block/zram/backend_lz4.c
index 1e4ad31d39a6..158fd8b5e8a9 100644
--- a/drivers/block/zram/backend_lz4.c
+++ b/drivers/block/zram/backend_lz4.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
-#define pr_fmt(fmt) "lz4: " fmt
+#define pr_fmt(fmt) "zram: lz4: " fmt
 
 #include <linux/kernel.h>
 #include <linux/lz4.h>
diff --git a/drivers/block/zram/backend_lz4hc.c b/drivers/block/zram/backend_lz4hc.c
index d8aa01bb258f..5c009835a684 100644
--- a/drivers/block/zram/backend_lz4hc.c
+++ b/drivers/block/zram/backend_lz4hc.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
-#define pr_fmt(fmt) "lz4hc: " fmt
+#define pr_fmt(fmt) "zram: lz4hc: " fmt
 
 #include <linux/kernel.h>
 #include <linux/lz4.h>
diff --git a/drivers/block/zram/backend_lzo.c b/drivers/block/zram/backend_lzo.c
index d83f92cf757c..78538479c511 100644
--- a/drivers/block/zram/backend_lzo.c
+++ b/drivers/block/zram/backend_lzo.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
-#define pr_fmt(fmt) "lzo: " fmt
+#define pr_fmt(fmt) "zram: lzo: " fmt
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
diff --git a/drivers/block/zram/backend_lzorle.c b/drivers/block/zram/backend_lzorle.c
index 1b120d062c92..011787f1430b 100644
--- a/drivers/block/zram/backend_lzorle.c
+++ b/drivers/block/zram/backend_lzorle.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
-#define pr_fmt(fmt) "lzo-rle: " fmt
+#define pr_fmt(fmt) "zram: lzo-rle: " fmt
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
diff --git a/drivers/block/zram/backend_zstd.c b/drivers/block/zram/backend_zstd.c
index 08da3810cffd..127976b5455b 100644
--- a/drivers/block/zram/backend_zstd.c
+++ b/drivers/block/zram/backend_zstd.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
-#define pr_fmt(fmt) "zstd: " fmt
+#define pr_fmt(fmt) "zram: zstd: " fmt
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
-- 
2.56.0.176.g3575e65682-goog


