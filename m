Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 243D8CC6B09
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 03:52:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 350046B008A; Mon, 12 Oct 2026 23:52:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 328C96B008C; Mon, 12 Oct 2026 23:52:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23EB76B0092; Mon, 12 Oct 2026 23:52:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F00526B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:52:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B08DA0A72
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:52:14 +0000 (UTC)
X-FDA: 85316230188.19.A0F2FF4
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id AA5F880005
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:52:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=HHLcTOiD;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791863532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kck/eLyUGfb+c2Plo1iRp4ljs5N+AUj2dW9HbonDGoE=;
	b=FEgStEVj/jZB4j+l/eJP1r6fJC8t+FlDF9UKImISzISGf+xPcMhzb4/Mxbxy7Z8bou3I+e
	x8f8RGEmRVYbstGqjwahB1/3ASyvAeOWTZyc0hka1e8wU2DhTYQZHEpq2m+8IA6NeYw5/B
	vJ0bD99hn8bvZ1Kifnp45JlzHJ1tskY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791863532;
	b=o/bVGxIAMFhHSIuRquPIBZLf7FsUcaHESz104gkdyhIPKXY/n8DBasAVKNS+bgSgrjCNwl
	b9kbz4bOkU/oXG+JVcJxQYgoO+FXe3eD2/LmeEYwJhwhYgDhFZGuIMeZl1bYcnEeXeZYCC
	ndM6ZnGbjkKgPe0h5p00JPu2mM9aTSU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=HHLcTOiD;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cc4aa0246b7so1032821a12.3
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791863531; x=1792468331; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Kck/eLyUGfb+c2Plo1iRp4ljs5N+AUj2dW9HbonDGoE=;
        b=HHLcTOiD8WnybDo7ElKqtXSgZ0o/HhjE6DesUuYZWenFSP96AY5oey5hve90bBRthY
         RIAX7L7AH0ryo+Lu7GRB5ZI32jTGffNK6138mSca4sSwrcekdSZeo9kiB6iOblfIRK4S
         94kwJUn6GU95qJ/PmlEFKOgbUxmp1cFgTTZjA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791863531; x=1792468331;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Kck/eLyUGfb+c2Plo1iRp4ljs5N+AUj2dW9HbonDGoE=;
        b=KtBBalHujq10OPtCfkTz0F+pU7DJdOQnPja0X43dNfTk6fYiRL6EVyX2HxMPnnUUW1
         KT8vMoW1E8FVbOsTV9jPTY4vUOJ53M7MRzsRtNMMYXvnRsoRq1Of3VdsySc0GlnLx7wM
         oWq1lwhyaiyg/3MsoKTtjOvr2KbwWIxlo81gNRi5TShjnyFRkMph0ab6ru5C5c+xlShi
         olQTpXQoLVP+hQCzzWHcB8Jz7wOo4wC2ApsN2k7D1bpoJ+8LP/7IpjSHEVRWRvjUsTlU
         lxgUWEDLHviqNV8YHL2NLQLdhuzqlwuxA05DvZFWBYABgvNGd+D+oXJGBkR5TEV1myw2
         XJ2g==
X-Forwarded-Encrypted: i=1; AKwUvBx2Ug3/yqWqn642fegBEKhnPIDyMP7Lorr27ingpiL4f830OqJ/9H8Zrybqfe7rz0rgOM6xGh6qLw==@kvack.org
X-Gm-Message-State: AFq9FYIpgvJOeZFsdeJcP0eqLpz9VgwGEUfdg+G6maKRWpEzlwRCfePM
	Hitd/f6RZkvP4gDfePh/19iQNGantRMYN246rc6RybE+K1AyKEjbO72p1ke9vlgjAQ==
X-Gm-Gg: AYBFou2HAN6ssIw827J1TO85OgBh2KQqPdGz0LrRxRHeMs3hfYq9g2SEjBBJcL5gwAc
	9L3vz+y/bj0bB4my8SYH5sf92gWsl0OcbXcoBS+J1lv+6ead/14DVkU13NOgppfeaeL+w8YpoeV
	vzlmDuBT9c9mWYQ8o1cefq4CoqwfGYk2phBvVQFX+ravd1ex5vceuRFre+KBiD9hkbD2337J7r9
	ou7ZkVrLDEdG5OVBamuwXcMqfP00q0k/PnadRuP5sQC0CxSGsWc6FDAZAc01rTcNBPwUS8pNGGt
	DIpOam5M75CFLZGktdoJ2t3jdSLPVIxWrzDTTywP0EA5OmvCslGCiPi697y8F+JoYr/JPvWGPfA
	lX8bXWmZcimmeHmD1KNvqpqXA7heYE5s8WCoZc7KhFuc4BrkMS/ZkJuc/JDLGWhrnWgcQAFwLBw
	51VhXAyDfuUx6YJ5cJKx39lV8NJIZB+pfxK8qMWwLJL6AvCx9zA7usI0FqGad7pytw7LSDe2Hyb
	O5SyQNFjuiZejt+N+gCCpx3fRW8+dpRwnHmtP/afN7j28xmDfIIsJGzSHwa4g==
X-Received: by 2002:a05:6a21:a383:b0:3e1:a8fc:18f9 with SMTP id adf61e73a8af0-3e1a8fc1b58mr3084223637.62.1791863531492;
        Mon, 12 Oct 2026 20:52:11 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:476:d384:7c2e:1579])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c41bbb27sm4326818b3a.40.2026.10.12.20.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 20:52:10 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v3 01/11] zram: prefix backends printk-s
Date: Tue, 13 Oct 2026 12:50:48 +0900
Message-ID: <20261013035201.2809924-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261013035201.2809924-1-senozhatsky@chromium.org>
References: <20261013035201.2809924-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AA5F880005
X-Stat-Signature: cw9yztxa644g5z4qeiikuxi3q6u6ao1e
X-HE-Tag: 1791863532-744512
X-HE-Meta: U2FsdGVkX19rj0U7T05cQ7rAUEmFkNcbW58PikjDwzUc+jUosiIeapnExG4038q8z6LewmMMCI7IZt+gAWTOoQZxAA2XU/Kx8rgsn8xZad1U/oHXngNljP8dlQ4MH3qv4RZV49amrbTL3g8LkEFraNbtgayORq7vxBDIgxp4zOjjBw8bgyCyflXbI8JqYBqcltV9Tvc4807YwUgb6imbErSvL9+hIfiyHSncen2eQQ82MBrnF5GP64MdH8qjpuEJK2l/waCMLGDO+Yt5D7mfVvlaZMNus9zP5GmUfI+T4vEAinAVnMtMFg4vYYkMq9ZDjiTCUsWBMt+xZHniutgqMIuNpK++qN6aWzcEYlNyzeE2aHgkdq2MYUq1ccCWwnIfKSPnDt4tU8HbzNF/ZkY5qNhz/J3xUEvqzbri8ZJG//76+rQoa3WwILBNn+Cj0QaJjrQq/jozJgleZHiWatRF7RkSWWmst/hKVa4Lmz8c6holU4JbcKdu/mafq7cMARjv5ofr105ga/5xddBrJlpIM8LbAEfBW8v20ZK+Xkg/M0+TbNButNlNXbggAcyQDW5GvNdw40ri6oCAswSPZ0GM5Vi3BQAz9T/UtTu9xLZEmsaVz6JRCQKXObyvdTW4td3fIxLaoV4hq3b20txzTxeqH1pVvAWBM/g8ss108Zy7SV8WPoeo9aHoZWob/FheuSEbtmxkA/hbeRYoB0c9B3VpCsYvjGSw402KId2SMNGBgsG5GHJzu4wS9QcPVuwZpmXY61PVzn0zTRh+PK49a/CEUOAzAs2HDbo7BRD5hoEzepR6x5sBRE5hxp4xAvbgTWb6I6HBW5jRyj7uo/B6VH4T4/r7RZeZBCPFKxaKQyq079KtD3saIOM4eqAF3BmA9hUSAJSJ4YtlONu/3oJ90Fr3ZQlxofHOjfDWizD1Awhet7S7afSMZH2vaW8H+nXU2Rb7SK0ZaWbnKH3TLugP/vT
 4GEZYRhA
 itywdtIItm6aNvU8PA0Unq1+U4y9KGTCQ32WvLr8cSMclGzV9Q/RLtq2wBqVq3DEp/C5Oe2Q33HCZCnZD3PzCn5vtpuQLcOg6vsCxo515SdqLRT7d4Pta3bPHvPIxVeXAjrGdTCno0zM7AaLMn/fBFy9JJ4jLHd4hj4Kv9SMUflkrZH2QtkLdS/gPTX06TChJx80MJch1/i8KeGZGbKNJz28hMfVaBczWfZiLisfEuqR2ppLBRFsBH7v+zTOC/PJo3sdDtDlepy0iXsLF3FNQNenSgb4E5rW3BrVmzwDE1ykVLMmqmy4CfTz+7Q==
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
2.56.0.385.gd3acb90ef8-goog


