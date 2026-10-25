Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47772606A332
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 02:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=F2LRpToz
Received: by kanga.kvack.org (Postfix)
	id 893486B05B3; Sat, 24 Oct 2026 22:18:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 864F46B05B4; Sat, 24 Oct 2026 22:18:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 704E66B05B5; Sat, 24 Oct 2026 22:18:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4649F6B05B3
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:18:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D845C160545
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:18:50 +0000 (UTC)
X-FDA: 85359540420.17.B883B9E
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf08.hostedemail.com (Postfix) with ESMTP id 18636160002
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:18:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=F2LRpToz;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792894729;
	b=C1FDUfN8pRvAXYiSopP5+dt1snDhB3nkvIQWxQHpXm/PnrmDnPxOOv0sqswFxZis2++yxO
	F2bDwwNZtdAm6oCQZjkG9dHvC1N1onD25CqCcvPzlrNG5CKFnnVHFfbq+rB20hcEPU46Ia
	M0imy9knYD+gc7YkcTG46tsIbIzo67k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=F2LRpToz;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792894729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NBoVZyDPXGY96HrSU5SgYmE9fzVyxsjGoqNqHA/swwo=;
	b=eUJiiADV9cH/9wfHXl10eflDQARxJW5BbvKTKDt4TgcB5ExlC+RYz9FIi3es7U4FVtJ3+N
	lFMRP9BADuwgzWvMNkUdap3Wi+p7R/xFzVMHEdN6ywKDBOXRYbZAdZZixF4QqGvFmOVs7J
	WRwoyPZCeu9eCQSbfL1ol/mu2E/b3m8=
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-354ba08cfd1so3563789eec.1
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792894728; x=1793499528; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NBoVZyDPXGY96HrSU5SgYmE9fzVyxsjGoqNqHA/swwo=;
        b=F2LRpTozbTbief8cZYPN0tXe6Gkk43b/mbP+rNAszgrBseO8++ac1r8is4KYNDnYaF
         ngnrik+7TII0fzsg+52UU3B40J5r1otkRYIp+sm8aiIwXYdj6L+kmkSu/0jh5/Jmke9K
         EtIa95HGY17R2NQt5zugQWAKj6GfWob4njeNU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792894728; x=1793499528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NBoVZyDPXGY96HrSU5SgYmE9fzVyxsjGoqNqHA/swwo=;
        b=ETHvs8dhbIsLDnpCMu27agqZoNtr5n6yxWFA9Zxa154sDHulL5RDhXCsxetbFKcFCL
         +UT+r4aB10MyZydDQwC0QmC3Dvo2r8ne7obU95ncEYoPQC2xBblZ0aSZiuHmgQLfwTQG
         gjmd0sgJ1TqrZDt3gEA2AQgvH+pY/hY8LpfLPukNYV+aU8/2tqJQdT73x1a7B4pS00BV
         WU1Wmjpa517jemS7j/RX9hxPp7lU2jo/Npone+13rEm+Z2eUajHQRUvtnzsA6oWZhFff
         M45cWsxFUVOX2xC/KsoHXeKkkcIbLIK15pScAwD+NokrYnl83bTcJM+gQx9ATqksJmvi
         irCw==
X-Forwarded-Encrypted: i=1; AKwUvBw9M/O1g/2ZYBzKEgS9kgRR7dBB6g3yW6cYWN3lxz4zqBtRwMwoX5Hm0t5Akhlx/WXyXYFn937Euw==@kvack.org
X-Gm-Message-State: AFq9FYKVTLAUvrDD5MxtIuXHoMXZMUJZspKa5LQAVQS5jN1iEsnkq1DQ
	MGMl4fezqSwTwLPUfkQni/j5qgfPK1Ih10hl4MJxIQGfWk1QnTqUpyDMv4SSIjfBAw==
X-Gm-Gg: AYBFou0MtPmqEfYuq2jQZygBPpBuX52vL5CfVsMumjt5Bk8ofxnIQ13n2/jWTmRRML6
	7L4pU35NH3vZugqYjIWG8CRymmVbTkg8NzFAWwFJSgaunHSoBVV2xPBm+KUPvF0QQJgwwK5+ePo
	G+ENBd87mu5P9hhbmIvMGG7JaBdQEW7dR51AxVgbs9iBdBZHp8MR9S0Ls/L67ndHg5O/RtSntnG
	Nr6DiPPLSZxnvImjLA86mGy0daG/ahVLzW5+tE48arWSJXY3ixn3MLsKUgS9FaQEw02U7LH9DYn
	1n3iBFHHEs/KoYS+qtEpNsK0jZ8OrIg83O+TSyzJbvYVtos0qwDOBXnmOHsk520OODu+Sf9aw6u
	lb3oBhWnfz5lBA46ZT2qOCw2+6GocvYZNKswUpIyhkkWy1o+a6jcOChujRzAYzZFNzLd3ivvbcd
	MhPbepaWCKBpw9d0jjug1JU+FKJZEByomwiua8PXt6BVlYVS582k/MiFe3YBxXXoH5IS/yyHRaw
	c6BSxjqIbrXk6v8oY5eCPrZIPIDteqcuP2IST9jX4M0LonBIcscKNV9F0zXecEc06OglwY+f+H0
	xM3uEFPfk4gsftwFGrH+kwh1THIq+uBdsqRga/zxB1df
X-Received: by 2002:a05:7022:ea9c:b0:18d:c38c:bcc9 with SMTP id a92af1059eb24-199290fe50amr4386210c88.3.1792894727665;
        Sat, 24 Oct 2026 19:18:47 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9f87:66fc:8c85:11bb])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1989ff2ee5asm10387242c88.8.2026.10.24.19.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 19:18:47 -0700 (PDT)
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
Subject: [PATCH v7 01/15] zram: prefix backends printk-s
Date: Sun, 25 Oct 2026 11:18:17 +0900
Message-ID: <20261025021839.1542805-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
In-Reply-To: <20261025021839.1542805-1-senozhatsky@chromium.org>
References: <20261025021839.1542805-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 18636160002
X-Stat-Signature: qf4f77y46abetc4z9bcmaqwfnh839x5n
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792894728-879003
X-HE-Meta: U2FsdGVkX19gSCZAlxYhBSQADIJhnoTmxJsRFA49bZP6WZT5Je4eXHiUwMwAVfir+67rTBUHNvVHxs/24+m5n+oXAzQIqKjkQI2ukI6h58z8D7ZR7u3bGp5+zGyfyPYgS/qb4yiZxXg9I3d4+0NgSFuiODuVPWhaJFJZdfvtxSC2ZF2OSf0zVSiHsnwFF+V1MqlJrne7fcrFPZh2PippwPPpATaqX+KJEFb80x4iwjSAquBgX8bNV1DY+g+gWqUZPbYNOKnEs7Ico87AE+kcZmzyKZpsQJzHbIBvnzNKiZ0ZsfTY3OCEzcw+hANsb5LfW8dbc0AT9/u0pLOK5cuTZRRb+rt8QJq9+O5jIDphGcMabAj5ZSUQGV+N9iX39KjFI2aFV1W1PPe1h0MEExIBWjwSPSpwqG+TZBfmEubzE53u7bO+Vx9iGsEnfsLkrkQ45q4CjfokYzD4qiv/xBF4Qq0JYB8kiy8YGpclbJvV3BtbinWRxF9RdFCeSSVp+mc24iPhB5H8htRCE9H5INChRFqZrmKu10xY5IMs+XtQCsuGXjVNKf8SWt1cBi50frZ05DES4hRNaTnoiqddcn4znKh6rA3Kk7BIYH6MdaPBInDJNrfnocTJotCLjxdfYxXyII5frSA0Z1CZb1B31CqPGFIuBOkWK0qStnJtLngfBsl8TQVFU4HJi7WGh6PEzTNiZfFhl3z114CsE/QEthFasnWXCvxDP/Q/A2e3LKbxCn2w8OI7TDyDCsk7RAujFFFxVaRVf+3IB4/r/+J4iV99uI0UXb0vne/7sZUzApZq/FCI1GWes96qFu+ncO6y9NDMsLGrNnz0SHw12VxXy75u1VaFwNgKL1wOh7JKR39aaX55jgs57SyGQ/FV3EHFZCUgHKS1lYP14iIJCWGjCHQEOH5bYQWSiLu5ZBWHGT+/K41eL5YAuPwvZfq1sz323a7VnR/Bh22FHrJQVjuqdxR
 ewsEThTt
 4ufKGLst1YEtg3r67UYOWeoR7cSVj0PuTIPacsEHFH5OWJvbFDOVUTo6eC8VnkBKiiN4Bj4STO0BJWCIw2gz4YN7c3b6IjbNrjinEG28pv2GRPVDFcqgiCNxCKiSqvZdxWsku4JkShu0LrmzItIJkMhPKHTU+dEMOt3Rtn19JOqXGNByBwr8caFZqhK8ZYIZ++g+EuPwqCUuObRW+I8x7VwKLomEHmqWacnAV10rIJ7W4BoO+7BMRTN3VXUVFikvbYBdlDFinXo7mXlyfuOuP9LpyL1Jz/BzKb0Z2RO3GvrS4+OO29byLg/DRXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently, zram backends prefix printk-s with their names, which may
look a little confusing, e.g. "zstd: alloc size 408128".  Prefix
backend names with "zram:" so it's clear that the message is coming
from a zram backend.

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
2.56.0.257.gf7497c7d27-goog


