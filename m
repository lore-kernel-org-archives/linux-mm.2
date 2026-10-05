Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B942DCA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 12:21:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B55AD6B0096; Mon,  5 Oct 2026 08:21:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2CF26B0098; Mon,  5 Oct 2026 08:21:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1C226B0099; Mon,  5 Oct 2026 08:21:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 809B66B0096
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:21:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 09B72120244
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:21:02 +0000 (UTC)
X-FDA: 85288481964.02.6CA9FEC
Received: from mail-pj2-f40.google.com (mail-pj2-f40.google.com [74.125.227.168])
	by imf30.hostedemail.com (Postfix) with ESMTP id 375598000D
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:21:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="V/bPNU9+";
	spf=pass (imf30.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.227.168 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791202860;
	b=Lz+6eB0eBQFUTiGuBABITgikBuDPsYyfOECD/b1mjZ+lg8NU2zhspeWbS5nHywvjOflfKl
	wWiLoSynoFoytPGRhqCgAuGHE5r5mbzOTG06xK4Lqg7K1I4Bp4GBjq473XsT1E6UFpAfLG
	/69n14txiCGiYYqItsVTv/pSEZJluog=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="V/bPNU9+";
	spf=pass (imf30.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.227.168 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791202860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qBy3Qhx5x3GHz21HDgx33swSeoCPkTH3zJT6nvmx4+w=;
	b=0oAD6Yq0HIfDCFD0/l9mFpZ1qNX2g6I9/eeySq3s+NL7GRCDzqQFQGKpM7jXEF3sIphxVp
	wgvarhW069iQbpcwX2sRXEGwY5MTzLsh7esvcztsgDMH/F3jWSX2jDZR0+4E4AIvAa5alw
	i+YAq41YQtFpsvt+5KVaTBs2E76JxB0=
Received: by mail-pj2-f40.google.com with SMTP id 98e67ed59e1d1-3a2adb9bc3cso789273a91.2
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 05:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791202859; x=1791807659; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qBy3Qhx5x3GHz21HDgx33swSeoCPkTH3zJT6nvmx4+w=;
        b=V/bPNU9+FhgUw5d0nxyfTeOX57udj3O4ULbKVFjdK3d1HvGKkcGP4KHYi0FICLViKX
         ReFJkaTHCdpv9ddQ98Czd85IlkG30P8Oc7e2aLwktZrBY3wf8gacVp4TEIIUm6Nsd0/h
         EtQIVavVU6T6ko1WxqvZG/8ZxObbvl+Yv0kHM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791202859; x=1791807659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qBy3Qhx5x3GHz21HDgx33swSeoCPkTH3zJT6nvmx4+w=;
        b=07HqrKWeIXfppvmdNct82A91m93U8w18iv0fOaM1PLpTQPuR4d8QZZNaphNXuFj5jg
         yFhv3En+SdV5He/TaLh9m9ToOjWuRJ14iO0wP2e8AM+2Ul8pH0rRSutAjx+70OBtKpSG
         WL2GtvB6GRsvRqTpA6A/fAIIuZobpLXjI3NFNiypfvOitDLjdPXXeM71BSFTFbccNh6t
         aEaVhR5NxU9kgdpYYFq/PmKnendC8GXko7QxddJEt0J43JbCiRWQqa7gwWuTSAeSsoEA
         M9Zb2y5escEEejWoh/7OO/qvRHnwVJQYiWOzgzueipCjC625oSIkU7x1No48MrgOcxOX
         XUCw==
X-Forwarded-Encrypted: i=1; AKwUvBzH+3Vu3hMN+SKH0rdvIySQBnsO+CArCjQUV8Yin5t9DyOtTlLzfsg3UNU1nLjnryWeaGk4Hf2IsQ==@kvack.org
X-Gm-Message-State: AFq9FYL/xYtCq3ticEBqzbAX2URq0UJzsSxov85A/qOlTT+nYy09ugay
	JLIP67IbwJ1U3l/ysPTyIzql3T47h/OEe0AxyZjYzzkDNmFTSmUoZ2J8SwzZP/9GPw==
X-Gm-Gg: AYBFou21b9cvBSDVLj16UmPLn4vIDW+JWfOW4sGOgFDWadAcOnR1hnUZ+OefzfFxr6/
	65C5tMQCtNeDDbmct5hlm7gk9xiKWpD0vR5DBl/PihRN4rpzv8IaRKJA/UInxnmqL8aPCNV008y
	qbQBua65pbr0W/DGEuFqyzmdMsWO8l1eA2rCV5D4dwTNZ6KEGOqtT1ZgX5xk6S/68aADC34IBZX
	V307e8w4j41WPFASX6lgbqTlYi9EfeUspJkleHxjaJVlg5ALXNF7nNenkBaZ/eM0noZQCZ4h4Uh
	n35gYS9uWLgR5/9fmZYxxGv7xDnF68JB9nJkeWm/9LaJ+eG24V+7PibeVUebk5jjxE4xFnK617C
	WYBOCesd6ebYaeTMlE8NKlENea6CG7O281f18k9uLxtKvaoSRxKF55NcjztHN1ZLV1D63fyHrUD
	ZqWTltyoi6v/7D9RI1hhGS4swiWnYWSDURMXQgSjhW3iwpcbyRdM5q72GMOdTX+Ia/PGLEZOcr8
	gaW2amnQrm7lrP+wDTzJWNsx6/9aqDJ+Wdt7nO/dW05JuSU9FmIyX4zUu9xu8A=
X-Received: by 2002:a17:90b:2791:b0:3a8:e2c:af52 with SMTP id 98e67ed59e1d1-3a80e2cb9c7mr810510a91.24.1791202858970;
        Mon, 05 Oct 2026 05:20:58 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9211:ddf0:3c6a:bf9e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a7e4b00de6sm3342997a91.1.2026.10.05.05.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 05:20:54 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 01/10] zram: prefix backends printk-s
Date: Mon,  5 Oct 2026 21:20:16 +0900
Message-ID: <20261005122036.718976-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <20261005122036.718976-1-senozhatsky@chromium.org>
References: <20261005122036.718976-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 375598000D
X-Stat-Signature: qyod4w5fxo8od5yjqrk1h9rp898coreh
X-HE-Tag: 1791202860-956070
X-HE-Meta: U2FsdGVkX19ZYt7SF2e1iMAwgNa7UEh5a8u5+BFudBcbhY4f5k47nKpZjkrmF9YG/H1lqwdsyWEiv2URZ6ydkwmWs5k9VkJ4PAaBl3WzKeG/+FSuXY6TZ0UvZjERCGlplmAQ8DZ/KJOFXnIv0pXTq6GmxWNWasINPZx0JC1wqeXhMJDZ7NM5cY5QcWL1aH/FOvFa4r2dtnqjHALNTtANSeLPFn70Qlzqq123+tVPKNP/2tKJX6aRpmp8QPpN1TltElHKUWVsQzQe1JOvkMGoQpdfkNTvtCZp5s3DydtLYzCULmTHlcXf5xqYDvEuIomybptveQiB1vPQrmATtQfPlI35xBOPh6ODv2hiI+0lp/gFQPMo4c2cO1Nt73t7VRNHCiGjsYuPP8enDkH2VgB97HXKUoUtFiLI/GWD+4SkCvqa4UikaDxrxH3BGAEvhKVeCE8+E91xm6yrNSCcu+SjMTleMwDf7V4uKkFDenVsU9QFBNQWM1tfJrn67Gon8bPn98sVfZl1WqK5IoiMDnQQho6Z13ZLCKl3aPQVUO4QOCvQAbe46VgkcHhG8FUbTF6Z9tCS9MOXkYwtfmkMHFkBPpvd499ORmKJ00Ao7n9v8p/GZtcWjbCSZYtWQ/6J8AX1EDS7a/5zyzqaa9rMRu9JW5ZPXuMjpW8zsbidRrDeWf64Nt1iFdpVGi+9XRJF/4n1ceVSt08flXmam0ZUS9b6MzVwX94ZjrcW+TqEAh4t/+wflSdAoR0LHLvflI9Zkcz8krhM7q0Tv14Z0h0EaTpnNYOWKT8wq+vp1guiB4E3CFfstCJ8ItOcjcZAEoiqBuUevtpomUFQx27o5Q+I9P5b7ahu+iP66jCTfKVn2gxnqv86K/vMwyG7yNjyXJN5uaimwDlbRSZ6myzvNS5GRLvw8YzZM9SbvgyZVDLY33gteZW7OlsaL6uvvF7PpEPSXdNbkAe1P8Hp+BA4xnIberI
 c53EDtuH
 1za0uIigDcOsighrTOVmQKJOlDAPDwkzURiS3Ghuh9qraR4V7jJkLSCZWcMtT/9Yd6ItV5ZYZ3mL23V1qkAPn4aq4pzRuVA4WBNJaHYcQXpIFhCaN+Co7894u1piv6u9r27oSb9IV038faxLUda7tlCOLJZOmkOtYbQ95e1Pn7kGVMhf5k4HDSJMj+AfWshVDaFTqwzTmk/7QV6FxPe6Icm2L96VHIe2GRZuZCnokpwUFdyeTH5DT7ED7HoFIDdloHbNz3U19u/D6nXKSpdY2FwHHAjyaVbcHaglZ+1rAXAoNaH4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, zram backends prefix printk-s with their names,
which may look a little confusing, e.g.

	[   30.859567] zstd: alloc size 408128

In addition, prefix backend names with "zram:" so it's
clear that the message is coming from a zram backend.

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
2.56.0.rc1.315.gc6ed9934b7-goog


