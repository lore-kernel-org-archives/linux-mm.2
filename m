Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C3F2CA6012
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 07:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E17D6B0093; Fri,  9 Oct 2026 03:12:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B92D6B0095; Fri,  9 Oct 2026 03:12:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A8286B0096; Fri,  9 Oct 2026 03:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4EBFA6B0093
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 03:12:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BD050120285
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:12:15 +0000 (UTC)
X-FDA: 85302219030.11.E5D747A
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id E42228000B
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:12:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Ka1nPvGe;
	spf=pass (imf30.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791529933;
	b=Rz/6e0RQpjROdWmHp4wfnfKfpH8qlU1PAi8wMFqs/LZ/iUp2TsgHt7y+bZKuAIU+IIaSCc
	2VYWtTO518z/S/H/mj/PbfX4TiVzsEq7B16h5uZ/N5KYfrnU6DMw4P+kOJZUc2FMVPrsdL
	t/nQCAgkvUOaFazTnMgVo68G1/59U6M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Ka1nPvGe;
	spf=pass (imf30.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791529933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YQcIZ2/VwpQTz4ABr7ZY83hVTh19wqfR20fZu++knFU=;
	b=ilQyhwShXsdmeIRfO/Pb5LxxxhpEy7eracZB6L8TM5l0RxKOcqrsxyE/2cgeo+oH2GQim/
	B53300y2/4NtR4FDrmv0Dl5q14M6uP4iP+JvYNEYdcvGDJia8fg+42rzXCK3j5jHpq3Unm
	76cz6Ld/8UQT4QySQYQu6SYURBeDDgI=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2d6e954afbdso26299515ad.2
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 00:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791529933; x=1792134733; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YQcIZ2/VwpQTz4ABr7ZY83hVTh19wqfR20fZu++knFU=;
        b=Ka1nPvGeEIm3H4zqDI2XPmw3oTs2hsN7vRZ09Mo3i6BKNDZZouXs6EtiGx16YQAKfA
         BTaCkf9yoKhOFLbjHD+PZlN9FMJ+7zy9FVWgDf2VpwHmC0pULiNH2PmbeHHfSpsjvmgB
         8akpN2Zc14usWCZasDQwvN/IEyOUP2KUP40xc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791529933; x=1792134733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YQcIZ2/VwpQTz4ABr7ZY83hVTh19wqfR20fZu++knFU=;
        b=wb55/033o1eNHZnL/Ke8pP8/k+6hd6/2K+51CIiNy8xzdUnMBbxE3LuU2jSaS+s+wN
         bPDd+BQhDG0PIyvw5OpEFWKcNMRaLmG7hEmf6bj5bGwM6MFydB+TNAVRZRu1wNcBW29Y
         qTpdd+7aVpa0EMPgKLNssfkmO35wx3lDkxJXXj7JXc3avVwH1OSdOVcQxneIR9+5nl7H
         Yq5nxeVZneoTjyM9JZCjsyfmhW/s03sOauDp813kxfQUyz4339RCec0X+fJri1p0XUMe
         gn7PENkotBx0wTXEGM98i/Ud0ostAmeVpK2EHjQmvDCavJ2tc0b1mn13t7/GChSt3Qjh
         bQtw==
X-Forwarded-Encrypted: i=1; AKwUvBzhOFVDjlZ4DQHiegwy99HeREdY4vGOObJK0j+VY4CMSi0ttnk+EWE8yISNdGTJkUpYTdV77R+5lg==@kvack.org
X-Gm-Message-State: AFq9FYJ0f4VYsuKOP4fbomt6ewAu2qW6vQKDwElz9ZIR8XcAD1iKqPUP
	pO9T1q3TyJ1fHa93A1FKj1QDwRGne0NlFSRqVR9CjCSQYwT9zBMqxM50BWSmn1wbFw==
X-Gm-Gg: AYBFou1lqwW/JPpXZZRgvF8B8FczrjuNkFPoi3qoD4KarvfgLrZLtfsrKB6hmJx6j9C
	moYbYW+d6FbRxX/JrZrB5l6CEJT8vXz9tuabKJfdKRhQnX/PUdrEfvyFdROq3rxxpxbn4N7excf
	0UjGicYFUoF5jU63ncains8O3rWSjzOAv55rJ/lCzKQggzF9StBy80JTB9vas9zcxy7UP1mwzBD
	nJJzc+/WZi/y5Z1lfEzLCb9eShMGdlVcgfL6f+gJJOZzyPPQig3wE5gMxJcPK+I9Vw6DbpRvKzJ
	4q4tzp1kNVTU8YunZjvK5GGbvbko39+6GEKuLomrqefihsgSYtLvJJZ+SQM54cUl2NSsSdxBiK+
	i3Mb9k8Djrzflfw5H1fD+gKNKE+Pl/HBHth8gZFraYPWxEJEWmeYJ6Xfob1rRkvVeDXGWovPorG
	E/2YwEHJoRT4witRhlWDiz/h87hI3DiVB419msneaRs1OZUWtrBYeP5mn7IJIsJfFAqbAyCFHKg
	PWy6LQkL45nQwtMfcluM43ydftG7jC9Kt6KQ2VLyp1ySTVgIza2qCOhbn7FVKw=
X-Received: by 2002:a17:903:2f8b:b0:2e6:943:39de with SMTP id d9443c01a7336-2e842bcdb8amr9044785ad.30.1791529932758;
        Fri, 09 Oct 2026 00:12:12 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:383b:5817:8167:5051])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8421b19a2sm4483535ad.46.2026.10.09.00.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 00:12:11 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 01/11] zram: prefix backends printk-s
Date: Fri,  9 Oct 2026 16:11:24 +0900
Message-ID: <20261009071157.3730698-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261009071157.3730698-1-senozhatsky@chromium.org>
References: <20261009071157.3730698-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E42228000B
X-Rspam-User: 
X-Stat-Signature: q3b89pr7iwfy7wf4m3duoadeahr8znka
X-HE-Tag: 1791529933-642142
X-HE-Meta: U2FsdGVkX19Qc62cz46ijrF1NlKnmMtl7XKPv0O2XOax02wHXP5uW001KhjZmLLEfb5ExG6IML93zvaJmfNRg7UyuA27uCdsQbatZw51fzWE0DxO4NNPo3KaYX3vVugwLPZ4HnLTvzdYeizhXA/JNCq7ri4xEVVf5VdXRiAAomAAjwUYxGuTqpcnXWiT5xsyGIJ/lZhiM1fHoeFl5I9qDqXVZgAclADDr/WqYzEyWcbbTdQFF9IRaxSgNgtOHCQN/KChcUgmpE5Vu6VuDrwkKEskztPmL+jl+TQFTOtF5/aqTjjyQb8uzFesuNfxMHe+4mRIFQ/2dW1DhSGb8gKB8kiHrUB4GExA307vkHwtoVgMk35Nr16caCKOlISYhjy6UisJXExGjMpYlQGBAxKREq9/4DgYT9I5v3lcoRBohMYnqPlIN+u+/pbnfl3v7EunQaCGXSrKfRkvOuAYhMg8QT7MOWTxkEyT97CozxbLtLfHc9mxfE0k0JWqaQv3lNDUKGAtsc3wNa4qz+HGIBrgQ39JTCjBGwA/XzPswLBgOBpr++Bvn7rrhbfaI3enka319ohwxWFKijd2Gla1xgiT6vHOfAhDTYQQzoi1/7axFqJpryVE14zHDg2MeJNR2Y4oB+H97koCnepg082PtJKDI7jn4ZirVpo78jJrzLJAnzVe+yKbhvn98lZrdQmaS57Q99skZCotmY1B7APfUr1n+c2geqEd5DRq9eVhlB6i4yk0FZpYwvZNu/m8jxyKRGtyMncEUG3lcDVBd14nIsqYUfGij/e48VJ72VXPr1XYz6C6xkhqVHM80UDgvQe86ZfL3g0QDFlMcH64ZsXMxMZjKnii7lnfd+fc53LywBOQhesTzHp1luJL8Irbavk0pANfgKg9p3KMZQFaOByAJfJ5gKGTryY99omQLS4E+s5M18NCkxIOpdDJCFWgyx8uUAJV+DaDWDNTei0KwiK6+RA
 QZyRlr7f
 ncF9zfTwokTSRTZtKTVfyMpn8YMhYQbvKeQX1BsGVu9pp1U7Ue/zOoOCvrKI02sK6JT1ltbX5y7g80FQm2MzTv7fBNoRPsSyYTfR473Vw83kqDvmmsWJGdQ1UZ2/Jou+jj5iEu2s06+R21OUeSk/yHcuG9kzzE8a6P3hIbXMGg3MG5tiBwbO30xMB3sTrflShiKTdF4nOd3gIU8R3KS2MqsZQTo3/bfQysZpV3xyxak+nQuObCgWDhhbBZu+zeKtBZoYJ3GFPjQWxNZBk5dcv1EYIXAX0k3nvmZcSkBID4cMZDXD6h18y/hqrRA==
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
2.56.0.385.gd3acb90ef8-goog


