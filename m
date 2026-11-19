Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2943606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 04:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=OT5CKELv
Received: by kanga.kvack.org (Postfix)
	id C88366B05CB; Wed, 18 Nov 2026 23:14:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C398D6B05D4; Wed, 18 Nov 2026 23:14:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B283B6B0664; Wed, 18 Nov 2026 23:14:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CB6B6B05CB
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:14:15 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D124480966
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:14:14 +0000 (UTC)
X-FDA: 85450551228.22.E711EDB
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf20.hostedemail.com (Postfix) with ESMTP id F2F411C0005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:14:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=OT5CKELv;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795061653;
	b=ZG0iP7aRXsejEuAs4vma3zl6UuGx3I8YcaqChb88tSDk6t4LEAvmXGVCxXHS6MHrhVFmTE
	olV2zmiY0W0D4lRQuqT21snu9NhRru3z2jytmkuURG6Ld8ce29DMFtrRAC+lbEJL5Xf96N
	ac0C6gqTGq8HYHBXSic1RCrrjIqPg2E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=OT5CKELv;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795061653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GikVTWoTtBeNiGifZTjdMmvaA9rmr+argKFGtvFCNYM=;
	b=LqylCOAviYIgCHiU9vQF5NJdy6kLTlIV7ZDpSFHqmeB0CziT6FvT7Yr2b/ZUa8PNEicQ10
	F5UWkfuNXlDGEVSPddklvfuINraCXjPb45mVvQuL2GF2FAvKKPZhaAY3GjYMnkX9tiOF4f
	2fJ4UrEnUjsEGc9YdfE3XbT38bbWAM0=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3adac5c10e3so1124496a91.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 20:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795061652; x=1795666452; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GikVTWoTtBeNiGifZTjdMmvaA9rmr+argKFGtvFCNYM=;
        b=OT5CKELvDJwMfmBnOAtd0cWVv6hKE9kuoAdePa3kH+VMWobac//y4OoHME2ZELm1A1
         dXUAL4ogu8pkuX0u8QnCJ+rnMD3MfjQsetcmDYaaqTWT+WE7gReWiy0i4N7QKtnLBtsY
         DgPTlnxS3doe4qdiH30mnKVIsKA27iahwxQVk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795061652; x=1795666452;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GikVTWoTtBeNiGifZTjdMmvaA9rmr+argKFGtvFCNYM=;
        b=m97mwsfPwTNF0s5NmKs3Zk/W2qIZ7xHqglYFjqEuNDPNDJdDEflBeyZ8aCxZK5meAs
         DXjNoF3Hv3sUykE69PUC/F4WoJF7/dwTVJocEESiPk3XsQ/vo8H091gK19J3o944Wvz6
         vFIuc1a/rWhT0EhUTx2ynPzvFhuxiJ0yzW++BtnIo1nx4gPrpR0KtYdoOJdMZAGh/wwW
         HoovqwMohllJRd+ud7PHRzvF59q4FbA4dM/UVYq0tYxFj87BloqTOc2SF1VwtWq1DLl2
         e/cr3hbsHZANuVj0f39lURNErBa/wuvwk179QT5pyXmXQo6jsWyqOtWXEGnG13jiS/xD
         ICxQ==
X-Forwarded-Encrypted: i=1; AL+hErFHBav+pUNlIN83T3TU7PF+8LigiA3AtS1+lP8b4Yg16ZFhmDwS/KgP8b+J9dFaybL+z3hn8UfuWw==@kvack.org
X-Gm-Message-State: APuU4Z9uW79lwsJM3lhhcFDBGjEmZj1OiJu5+UmSXdzufRCQjaC7Lyqn
	PmG+TIvg0a1/hClf+S37f3hQvfDcjMu7vOrBltvfBsf4rDmuGvzJ/sA+ABrcmgGhOA==
X-Gm-Gg: AZFdTZd1XavVx5ljQ8Xy5jI6kLCIrtntFE3e3F+5yHE05xBGdtxEHB5+e7lLl6VW+mW
	qAD7rH8F+Qn8r8SxDot5LNC/SoFutB1cEShoroH1lZGE2nACA9w5yM2ItNYddaD+YF16b+CuWuz
	RZ8gIvhSD+uZf0i/7WpSzJBfNXxTOlVYtuqlReaLRCEWYPYsncoKzfqvoexjB16HSpD/Axt7rLj
	MlIfuHkYCq1uJew/Tw56Cntfn7Fzg0dGIKa4LgsnfDtRaBzo3Is+RbeRGe9R+8/BzB4xeIOOb/r
	FbHWOm2IbTpFDF5bSpRQm+GCrFTn7z3YpesIVvMqIFGPzlAFD/rRMyoYNICw7M12ccDiyoz74Zq
	1WQrb8lyYQf/659BA/XLCskP3zOSVR3HASfrTsoEut0W3cCP10wQmYeSfgUrberPkULdoHgUWC3
	ObjMPFyn5dOXW8d4ufEJEpSkS9jZa/alpUKrS0xpj8IfvIUIcg7C3SOgeMkVr2dwfvqunlbKSkB
	CYbkmeRprmG4gBoBJ5TKW3dB0T/O/wUj5fyO1GZbWCok878Qog5YOoU3TaME54aKw1EAryHBCI4
	/xgXaDpfH2VSk1D0AKRfG8SM5LiAWE7gFLZ0+eOqsElVailOjXeflFHj4bm1/AQ1ShXqTuRgw3K
	ONYxKPTw8+iywMXRWUw==
X-Received: by 2002:a17:90b:3f88:b0:3ac:a203:e0a1 with SMTP id 98e67ed59e1d1-3b3d07a9f77mr4492120a91.37.1795061651613;
        Wed, 18 Nov 2026 20:14:11 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9297:4989:4c44:dad6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b40593719esm438795a91.13.2026.11.18.20.14.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 20:14:11 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 1/2] zsmalloc: fix SPDX license identifier
Date: Thu, 19 Nov 2026 13:13:51 +0900
Message-ID: <39f6056e0c8834fc3eca2001fcb44f3b6048f74d.1795061575.git.senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F2F411C0005
X-Stat-Signature: mb73wypwaaca73whooymhm6xub4j37nf
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795061652-954257
X-HE-Meta: U2FsdGVkX18uOXctvcYo47QVv7FkhQ6KQB9evz1HQzs3ncaCOMK/E+WXTJCoLljaR2wdIn7lBfKpQBKvbxt47orZv6O7Fu+xS58vM+tSio5BxwAhaCer1nXPa95+T9L29Pc8h18Ks5V9P+/m/FLUIAQAuvjzaxVkqNQhNVm4c/xqEPr9p5y/dNZTxwQ0usU9KdtbtK/RxYdNHfUhffMEhmRJjxvTWpBzPZprI0sIdzpzBKUvlBvXLI+jKVW6CbUpzKqlB0ZHXWMzuBbvz+aW46W5Am75jg/n1LenfdJ4lWSzBxu8lrKLAASaLFTiE4KgkoZfIS5ClGak+cxi2Hx7sQdwobty8JFvXxXGU7/vDtKNhPoTZh8MzMHX3zfAOiqVJ1PjYiFD/OtdmV+Mi117lmP4A60pH/pFe1rV4k16ZScjHEtoV8sX/h7/Un0T3LkmQr/Bv+BZwMCuEgVWujYspS1GBKKA9ob6VjICR1PvVF61PzBNKJAsk0EQ22qs10GeG1OICo8I+W5ODoyfIwMleOEA62jc7YUs/RUIl0ZyX8KoESZLNW9wSDxTpqX6y8Glk7XmsIsDpJAeMpvdbQKdRP54cWF5PUy+IvJDk/1xS2G976TJS4qrTp5oM851/24oSCBAh9PfGnEQ0apBoGWhBwqBnr5YSJqxSLN3FHzjncIZT0ONB2vgycv5MbQpXBc86By+D1ZE27UdSD2u/011ANayMxJFI0oU4M2Dv8jWmr3wMld21j4dMFoEDc1OhLsp8DqWgg7TayFAKUj0d8+/s0PbON1aNxFrzK9VuEzPJlGki2C3bR++rgb/1Ec/I48TFi9Iqjek17BlN5VOp2yU5u8dJsWgFywMHWfcU4U5CDJkoxOZcNbhPqdKgmFmuk0OVVTW/hvzMfVnqOyLRhCd9qr9BL0zAjDNkJOlYIVRSLdwFXb1/XrqlumcYclVI9ybzj7yHYqIXwt2Ke7gRZJ
 SEb+reCZ
 whKSa2LFmZRRZaOhU8mrVjfbPQ1C21tVcwRYMYY1Wg3aX+/JKfphwSPajxm095FLsUSfnYtaYmdg0tIOBC0IRoZbTuWXzpKTH7yRZRSarhUeq883h61pD4otH4aMUEDbHAMtjbmPs+5icVnEJjyONjrQiLyEgu/7x+x5KF5eQJoFUBP4QGeE3xw+6GenCu25O98r5/02+/5P2m7Yrd1i9pssAS1mvLksZacHBaBa47bj3GjW/RYMunsWOrzRrSoeVdKUXJHsncPgrTydCKWsN7NeN9bP53zU/fy9lo4YeoJVsaah0Bk8TNZoCSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zsmalloc is released under MODULE_LICENSE("Dual BSD/GPL") so
the existing SPDX license identifier is incorrect.

Use the matching identifier, (GPL-2.0-only OR BSD-3-Clause),
and drop the license text that it replaces.  The copyright
notices stay as they are.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 include/linux/zsmalloc.h | 7 +------
 mm/zsmalloc.c            | 8 +-------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 8971eef333ba..3232bc9c33b2 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -1,14 +1,9 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
 /*
  * zsmalloc memory allocator
  *
  * Copyright (C) 2011  Nitin Gupta
  * Copyright (C) 2012, 2013 Minchan Kim
- *
- * This code is released using a dual license strategy: BSD/GPL
- * You can choose the license that better fits your requirements.
- *
- * Released under the terms of 3-clause BSD License
- * Released under the terms of GNU General Public License Version 2.0
  */
 
 #ifndef _ZS_MALLOC_H_
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 4a6ec43f418b..f571b3c9e9ca 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1,16 +1,10 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 
 /*
  * zsmalloc memory allocator
  *
  * Copyright (C) 2011  Nitin Gupta
  * Copyright (C) 2012, 2013 Minchan Kim
- *
- * This code is released using a dual license strategy: BSD/GPL
- * You can choose the license that better fits your requirements.
- *
- * Released under the terms of 3-clause BSD License
- * Released under the terms of GNU General Public License Version 2.0
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-- 
2.56.1.708.g77570a6a1d-goog


