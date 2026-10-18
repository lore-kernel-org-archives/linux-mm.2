Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 569E4CCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 03:51:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D5F66B008C; Sat, 17 Oct 2026 23:51:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 486826B0092; Sat, 17 Oct 2026 23:51:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39CE16B0093; Sat, 17 Oct 2026 23:51:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09F8E6B008C
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 23:51:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7FFEEA7F38
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:51:39 +0000 (UTC)
X-FDA: 85334372718.11.755D635
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id AC89E140003
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:51:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="hFnmM3/v";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.52 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792295497;
	b=ws1nX7r/O3I4v2njcreArmoHseek4Wdta42vE18U3/lR0mHmmZ6e95Ee4Ec5IahKmB2KJd
	mwMXEoskX9FWO6qWVrjqhieGZD3rLXye3QvqdJBkzMzVirwOaTiRUOQ+8847AhNGE5wf7K
	hbzhp15usx5Ff0AWftAzOxPO6FK7sZs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="hFnmM3/v";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.52 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792295497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RdQPj6ORXxug2+szeCJ4g7yFuGdwCBNIowOh0yWYffM=;
	b=FhVGWk4QJLHrCivB/peNyg42ytSDo+toSrOgTy2V5F4J1AD7XgLFowwvnW/TuTDUIldixd
	v8qOiR4y2oidoJC0YtJKY8CvZrwfdB9m8FJWGtPZ/kqm59QTG0NW9K1UB2vlK9gI0DcHOw
	x/1o5x9tqK5lUb1ulROd0X1VfAASzWE=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3ac7c7b3a90so517203a91.3
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 20:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792295496; x=1792900296; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RdQPj6ORXxug2+szeCJ4g7yFuGdwCBNIowOh0yWYffM=;
        b=hFnmM3/vLHqIzXsiltEsfAHSLWxjPOsCEfrCw/7cicvnpdxw75QLUd8qpFIiCpzijJ
         Olmz2uqTr0ETUZq+5x1em+7buX8v5BYGCY3Hj4eDw7iM4lO6YVDSsrj/oy1x3mHJqDHp
         qS8y9tFNNCbtD60i10KE38psP00QgNzIobfdw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792295496; x=1792900296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RdQPj6ORXxug2+szeCJ4g7yFuGdwCBNIowOh0yWYffM=;
        b=ax3lX7zIoy6cCPT2rIjnXTNR3iAzcyANEq7S9WdBFvuY11CcZ2MhmIH+BGGwah/8Ht
         vs6lKbhbocaKD+AH9t12nNwfNuJkuEH/5oZoHqTWcjG9gfUE35ROZLET/ZiHq1NHOxR7
         9nisBCLzeejD2Aiaq8i98vQ/TOgSUXm49hvXHyNhbDpiF+MSYFIdyTLxo8Q50w71L595
         +EJ+teR46zYZVVG+dpQXkaz5NKU8sr9znLTNKu+Xx1n22AeoVyTfUOGobOd7gnKjXm1b
         4Bc2evIYDrAWpUKyntd5O5/wMQ3l4y8JXfRYycsoQiXz0nESmtUVox0mLZxffJX8Lhwl
         S6IA==
X-Forwarded-Encrypted: i=1; AKwUvByge/j2GqvWMWxYMQqi8P/rbVom5oP4F2Td9Uqu63aRmroikUl/vNGkV1Eqdmm/0yGhxhScyZOfwA==@kvack.org
X-Gm-Message-State: AFq9FYIgpCBpHN94n8/hhWp2uXHNpxpJtitH+f85EsSfpxfF4LN93hdv
	b+Z7w1RRef/BEXIldDe5YwP41T/ggwgvLZTJWC0AsyMzFA6XqSPgTOGS01WFPLDnVQ==
X-Gm-Gg: AYBFou28Ql4IRAbA5zie0odLKblOYKgjdTJJm1nk+chZodEXgp+L+9PWgv8nTcUe1A0
	dVJ3lns70pCDthVtI/R7rxxxFrXsmwFCtINTtAOX0kJPmcv4EQoY7L9Z0r8RzRxEPnmMRNH+Yyo
	dQ3bsHhA8EyL51x5Ix+qi1usyXAG//1TS3iRWgG7iTDQiuE+U2VnWgtH43WykCJwdALh6HMxqa+
	ek3h3GCMak+Yn7Q+loUlpcDpbQ6lh43BohfBSqzyIFJMn4Wod4tL72yC+1G3GCdxj8hCpGRDIjG
	wtPUgDhGKhprAHsck7qSd+JsLFDDWEBK4W/R2yySfT/um9krI07b4WywQxqfNBCFiT7Ot/ieLUT
	Ip1HTb2dUCF5Lx0WWYehZuyR8TqX5DcHFwvjwFnqz3KwKJj8Gc68kAkrMjx5YwOjMdFgRe5kIJe
	V94gJvRd7mz0PFeUFY1vdhphyYeFJ+FDCJhL/L3Bv40Nrgf7pj29rRLbI9nOUIzu6xWgD8QSt0s
	R2Gs2CrQlc2PsAfQ48knd11Mo4zPwELVZ9PlCKoa3BWPT4LkmhcETGXPI1id58=
X-Received: by 2002:a17:90b:390f:b0:3ac:8897:7ba5 with SMTP id 98e67ed59e1d1-3acef5f5bd8mr3660899a91.59.1792295496583;
        Sat, 17 Oct 2026 20:51:36 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:4569:b311:f3ea:5f8d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad25d5d1b4sm253024a91.16.2026.10.17.20.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 20:51:36 -0700 (PDT)
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
Subject: [PATCH v5 01/13] zram: prefix backends printk-s
Date: Sun, 18 Oct 2026 12:51:03 +0900
Message-ID: <20261018035125.3120704-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261018035125.3120704-1-senozhatsky@chromium.org>
References: <20261018035125.3120704-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AC89E140003
X-Stat-Signature: q5as7jxzj11amrmxqrc59id945rnwmk7
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1792295497-533851
X-HE-Meta: U2FsdGVkX18ba0N6g6mPqUa1iMDTsQtNevM9o89ghaOjP88aJ2JDSMc8WYeZxDLXAzZwDFEy0nObFCOMuXxWkxf5gCMTDq1Mx3/glArIe/PrLTEETyOJlnfZRttneomKRF9OMJDSf4aGJcXHm20Uae51i022k+a4CgTTs/583oMBg6s2BdGZj37dOTetlyvyqceGL4XNL7/Dl7EHL3fNTjC437NZKXj0XG1xJdmZfB2toJe0EGpRgg7GYoNiqpiSmanSoHqtKVTgCvZJ0uhd5xD7jJJ63ai7VNDfJd1GgBhDD9/ZtFBg+t9Lxzhpj4L2T0KRw3cvKQoArSA4tI/1ZnfooZ1YqmoZJogdWfepRK4a3N/w/zgGv8OMKCCh6TP8+PvogdSrzDNRlHr+WIbctxunaQ03Vm9vDLk1lPN0fxWr3/KPrJtruEfUzAM0ZtipDXHPic78GDLEdvY5IV8yYbFyI95hMZs9B9yJqJQd7CSEZIJFR2S3G+NS395qyNW7DZ3MWjTNaKmenPeyr14amTa28YtG+AF1FKe9uKv6HadQv8NwPjZOqXmYWbaYUGnqpPed+5xFe6lg8umJPOGCaDWdxTt+SKY0yDpYosyZz8OX6hcXD0OrrFeNzl305CDu7YuNPL+OUFBgD+OUTY3pA7UAVAD9tugBUZu+xde20TqNo5Jfdy+q43S7nzMyXFJa/uhpj5WbdDOIdaPDX+WL7lO4htwpyMrZGEvFeW9YZhLCtZjsax2aTwPY8yA66Kt7fasaNOHYgm5B9AzqyYKKtGCGTvyfiYhf8wbxiOBTfohgmYkrQL7eZIwHYHOwVeNIokw5QQXTC555w7vnA2VF0/dl0WWV5BRaML1MdEG1jBPTRz41iWIoKtV3vZ09u+7gWLkMh9L1mDHbP6WFx2Rjjj2X925XRF7Wwi0MvrEwppL+xLTkMpKBlDi0lARar1BwlbbvGpXW5agob6IzEgt
 XuUnVvUg
 gJhzxXL6fgi6q3u00DGzfkgIUfKCJVO598uk1vUCKpD1lgieVkl5gPjqeAJXDdSlpnQ+I9/MesxWgt/yWgzpO3f96daol43GghHqp5qJeck2YqN9L58ldOwWb3ZGMzikqrBTNMxXUXJSivqlrPjR30KcQhPkK91hVukSVWsnME4LucpiV5zUccWc85dJlBvT6//UeEb3dWHzJZB3gBjKyUDBMslKkYKDa/xfN11NvpHRTmWke0jnPXzJwNyugwUIotwevQgoQ5Bodbtih0otg9V+Er8fN0pHfIHDLRsqe0NsWyqY7d85DbharlQ==
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


