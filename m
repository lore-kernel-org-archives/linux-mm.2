Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D29C606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=ZH6wXfdB
Received: by kanga.kvack.org (Postfix)
	id 3E2AE6B05BE; Tue, 20 Oct 2026 22:42:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B95C6B05C0; Tue, 20 Oct 2026 22:42:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25A916B05C1; Tue, 20 Oct 2026 22:42:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0566F6B05BE
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:42:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E99901A044E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:42:49 +0000 (UTC)
X-FDA: 85345085658.10.291DE07
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2807340007
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:42:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ZH6wXfdB;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792550568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mz2Ta6sSCS/adIOr1Yl6IEh9cTq0/Y7T2NePoCn0BS4=;
	b=Zmc5nS7MMWNo3hsC9L+VWdNOHJXZTPeE7qae+aybU1tenf0xDDX+YaKCyD5t6N4RmyjyZt
	ARw/CHMbO6LbJlQ4QubnG5H+1WQUb+ISXWMAzHnS9tVUIM8wKFXBenT/9wAXuLMiSh3xdw
	w8nrfVqYXcDc0P9ED3Lx2TJtMa7H/vo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ZH6wXfdB;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792550568;
	b=tosFDmcg3SrSTixxKNi1+vic0AhH3PLhhAm3PyUMc8alGblLI+O+VuuxpSUyalaOTFU+sX
	jkrvvBcmlwGJrXv5BYt+KjK4uv9BzCaDH1ilz+nSxgmlyjVfSpWqgRlwAuyQ5ULBhTb2xg
	0g8ug61Ff6kHA/hfTgdpHbb0oGN7pmI=
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-35829219da8so1673750eec.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792550567; x=1793155367; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mz2Ta6sSCS/adIOr1Yl6IEh9cTq0/Y7T2NePoCn0BS4=;
        b=ZH6wXfdBYCioGYPdX8kcila2j6xVq6gvEdxQyuercNlCK5nU5RUaCsOErA8+wtKYdM
         Uu0n7pdm8fJMECTIqhBn/1SP/ZPoAbfii5BSF5zu11yPTbJlIcah+qYqDXjC0mBM6on9
         Ec9ctO2OvZy+7U48CGOQwRNyHCwIn1E9TGHpo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792550567; x=1793155367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mz2Ta6sSCS/adIOr1Yl6IEh9cTq0/Y7T2NePoCn0BS4=;
        b=oi+G4JOtpMwVCq71yFxmqhLMeqDYSTaaR0N/QM+D5wRSY1kloK2d6BYasvauC8NsvV
         lK6Ow5+rGd9qmRLJanR4C7C0FKvR8IHZP28i38C7sm3te78cQlZt6g0rs9L9xUV4J18J
         FmVDax5EYLJgrS+iWdORl/3PH2oYLS88v8Rm8Ng/il+SwIJ/EX3/L6p6ZT4ZNAB83z7a
         TIrh5Jdw7zdL7iARsaND/AoupJSAtDjf87n24J9ddTRLR+NP5KJvc2vQCrFMUt48FDh1
         uXqSR12G6M2IqW77lVEU4BbbFaEbuKga259BdLr3sRHeNx7tYv94qop1eOT9Smgb7fAo
         NYfg==
X-Forwarded-Encrypted: i=1; AKwUvBwDDv51yjHTevwMJBzzYsJbQp+ZpVlUGL7oJ1hx8pHCq4LsgTi6c+HH2RwTpb4fpJrzreA80Bhlmg==@kvack.org
X-Gm-Message-State: AFq9FYJutbieQ1YFYr/PDQrd3kqL/9BG64Y2717xwlSz61uqmgaN4ce5
	B4EFWV8k0dtOmyY1unXhYNja6dCuJVwPINM9Jzpl7IXQ1s/R4V/5oHNhtBSG7YGZ+w==
X-Gm-Gg: AYBFou3TM51SficePclXwLrwFcyMdHVD1HAKHoQWOXGeJY2SzYA2MAKt+TzK3B8b8DB
	frfIUf1BFCGnaIrm4JQXlHv3hxMxalD3+LF7fqNmX9IwIi/722aPK0Bq53WP1BiJzBDF3LgUY6G
	lLYqsoXCixwiNnWvvKUc/bgdeEgDnpEKrm8Pyg4KPx+3eI2xc2/G0mxEMZ7okPL37yduxTkKCln
	fTI/LNWLr3LlRG3Nip0HgVChF4l4LPMLdB787dzj66aDIX2VE8MSVeFgbGj1xfSLWz+yH6Ioo18
	9AqoiBzCCqo6T26e+uxVnsaDzzL0FEQeDt5MgppRnlQ3z1sSSwyQP3Sw9xDROzPfUknC2jE+Z8e
	YJvf0IitAmdB1YyakL4gUva2tUJKoSflJiJoTZQU9JXEo21jhpHKSox8e/w4nuCGDaUKFcdmIjX
	QzpcebYkyOrUl2aLKNOsIBmP35wkrt1Ln5wamB26LHieOd2dYvYXPMbdWUI59bYImVSzWNlUhN0
	0HDkMUX2MKsymhZKFmEaHhyYFCr7fGhWJ8mkC+4fTclqQg2G2Efvxs1JC7G7bjnTdIdZJ1MyOuf
	Po2ECPegTs5rmCinoSUIBgM9jYoPA9npG8Pm8IaIBbMF
X-Received: by 2002:a05:7022:3c0c:b0:184:ae11:51c8 with SMTP id a92af1059eb24-18dc094b1ffmr3601255c88.23.1792550566648;
        Tue, 20 Oct 2026 19:42:46 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:97d1:a8be:236d:bf79])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19035c0c9a6sm2392047c88.3.2026.10.20.19.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:42:46 -0700 (PDT)
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
Subject: [PATCH v6 01/13] zram: prefix backends printk-s
Date: Wed, 21 Oct 2026 11:42:11 +0900
Message-ID: <20261021024236.1787884-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
In-Reply-To: <20261021024236.1787884-1-senozhatsky@chromium.org>
References: <20261021024236.1787884-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2807340007
X-Stat-Signature: o8mgyhj6xidn1zgger5tmzx4gmfk4pfn
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792550568-372569
X-HE-Meta: U2FsdGVkX19G7WKEEqMA9JGqCbchVWGL4wAWuih1+3hRwDXEw8BDZueOS052qccy7mL+ghXY5E+Q2h5TICsb7yTcz+Tc8UX75EM7UGoQ+vBnweUTJ2wp59esug50ZTld6URYsnmga6Ezb9/iOEqr/q5RUi0zGmQs3Z+UMSwTYQP6NJE/fb/dqrlJtXKzt0ofoBlfaC+/VVJ3UysKI9DjN7iY7nzgUzIl8x3I36WJ7l+0potBQxO2UepqvnOnkwDKMxpOpH3k2npFe7hWrCQogjydZRwrAo+2qEaj7sJQLtguML4k1YdTPnhYTUK2DE7mRc3oHyd3sggbew3fmuilXjYxbr4KfbG77HBk/0rc3TRXyZEj/QaR+0Nc3y3I1blSxxeUAZ/zUC8o6R6Ugp0aGAJBUAbSUkjeYJZfMAU70APoK97LUoFu83yga0e3/KsvaCXOPWPXgM/hUrCA4mUNuy44KKFnW1fB15tq3RXCjRt7Ebrl4PN7kUJecLBd/+bqFiWsMqMkyQgCZew5Obanm4eIpk0A0xMwO2AEG8dmvHrr9QbNbtST7BwZc5vn4bAXsa/G3gWdDjMJ5tiLfc8m3rU3vO9P8E/Mjsd6/Je7I+Ksa//o/dMdl5g1E03Erpd3xmWE3neD0qzzM7kAz4PibB0RPXK4rqLGW8aYhDa9e27sAuMtuMed67HLDA24REmDXFDFDMNGxD352LcCvndo00wrENVv4rCAk6sH5ZaNNFL+w3ikq9a8K7NncxcSLeNrgk8Dqg+4unpKoSTCXPxoDROGG/dkCXNUa+/TVaOiR4G+gD1CuQqOfKsvZQbgo5txFaPjxkQyEpckkb6YhWb47pSMPQmpIveYba5PaO72F3bygTYVfi7V1KptPT5qMA8Yj09OilQO4pV5t1aAxaH5lG6RlHEovc+vYYniBKx/q2HzUk3xti93XZG9ZXI/YrgVJL0ZEZlu3kglPJlhNoI
 cBKzoCXm
 JcTnYfyVaAizc9Gxn3Pl1cOJJkhFI0XHuFUPVQhiKS4LzSlrsO4voc7SugCc4WcAWD3YO0bVNHo/jMYF6mVSllLcUZKwA2Gsn9lwwT8gBwHsICyaHOSn0TpJBOScGicc6gdabT0gg14IRKpHaYDtbSnFbxZLWKtHC/uoo+C+7qEnWT45UXWEuLLtgSlp423//NzPzYeEIzVvWnb4yih+UgHkuJyr0gyteWJa+7SP8wEvhjXn1vkTDbCe/ywQMmalD6451PxlFbiQEHloTHdCWuIIyUvqtXK/gfEm2ELOuKk0xGBAQjnci0S9btA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
2.56.0.212.g129ede20d9-goog


