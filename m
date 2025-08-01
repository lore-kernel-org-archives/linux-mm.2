Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35499C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 04:37:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40C946B00A2; Fri,  1 Aug 2025 00:36:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AD876B00A6; Fri,  1 Aug 2025 00:36:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 163556B00A3; Fri,  1 Aug 2025 00:36:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDE416B00A2
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:36:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C3D4C1DD890
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:57 +0000 (UTC)
X-FDA: 83726928474.15.EF8F45B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf23.hostedemail.com (Postfix) with ESMTP id E9DBC140007
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="La4S1M2/";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754023016; a=rsa-sha256;
	cv=none;
	b=kE/ftlGATTRlEBitNQzo0QZ1k6lf6IYBHvC5HzaGXHA2UzAFOdMzWGCtz0ST4yz/WxvAg6
	5Hvl+XITXrXkr3kxWEPADUYJWM0O/U6UELYl06AJJi9rmpOmkVkJe49v5ZQJamuT4pGvGa
	KwR82LeHNdAYKgvnjHeP9/DZtXP2pug=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="La4S1M2/";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754023016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GzFbI6au7GKFtXKcBr357XmMY2rngA6jZljtTNPfRGw=;
	b=flqUdmurc94imdxKKY+Y1swv7u6KviYKm4l2uR5npjMhAdkrQQ6tNOLjvcPWTHjDL5cPMN
	8KKFcAGqLSYwo62AKyKOecp4iGCxLWHjoeMCb8vgZLUj3+wKJMFDJmH5NGDD2IthJKUjGH
	SzylE0WgFfBBVZ17ogDehoux9PZayY8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023016; x=1785559016;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Gx3K9nc7SbqS7yUYzPYGDFgIwtQFFxvIkExs4HbX0c8=;
  b=La4S1M2/p/1lrELmJWP7zhCh7Kqs+c1mpbZPLRjMP6Bhd3jmIEFOsnHd
   iULAORxvbydxrtqDldAAB9nnhhHdZo53TDyJxdS+6QXoQo/XMkltME/xD
   uAfcudv7OoiyfIOK2yy5CEI9txVJcp8Z14S3NW+XqzZZLgPbfbpj1XTRU
   w7HAWny4R7oriZplgnPGC6y+1UfAZtBgJVaDMX4vGK38u7nQiewbyp4aw
   oB2qAt2mrdeEHaXQHropaJGPaCLk/m+O7oLuVDPLuC/6b9N/EnbCBjpFZ
   lJbyyGIRjic6s/OWVi06eZ7rA0avcTK8n2be6RRtny5rU6fdrSkaTCw1Q
   A==;
X-CSE-ConnectionGUID: djDUSp3gRFmh68UY0wP3Tg==
X-CSE-MsgGUID: IPwnL4ZDRx2gQIjIiXEV0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820321"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820321"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:46 -0700
X-CSE-ConnectionGUID: XWPtbTfHQgu+DgyqPU6tlg==
X-CSE-MsgGUID: 11JsMHtRTsenZH6/gt4+cQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796277"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:45 -0700
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	21cnbao@gmail.com,
	ying.huang@linux.alibaba.com,
	akpm@linux-foundation.org,
	senozhatsky@chromium.org,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v11 14/24] crypto: iaa - Enable async mode and make it the default.
Date: Thu, 31 Jul 2025 21:36:32 -0700
Message-Id: <20250801043642.8103-15-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E9DBC140007
X-Stat-Signature: ynwhu86f76gw9rh1c8wfs1k4yy3669my
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754023015-470520
X-HE-Meta: U2FsdGVkX1+soqRFl7cdejbneHoAaZLALIxe2ZD/WD93X75J0abypwRrabDR5joNqp/0GfZuLvhow7zF0invf84kp+ynU3sP9qaC4H976sV4iazTvoOUcIBe+EXTWApZgGuONnTgVVqmNVwTTLf1Bm0Ssk97Zu80ZBIcP1kQXXJ7OXiyTCZcVFh57ccjYyMKDlQUH+5B3YxIgIiQBfWwJDA/ipc9FsqG/QxfeATDkUxUkWuIshXrxwxMRMqb5hKr/QcSZ2nJhe1TlD/m2ph9s14tvD+jxZwskyRhG5fVpdsaZ4OCo5d1JcVEldpsm0te3+DjkqTXpFpGbDngT80rFYyRN6CHrTbUY1klbRdmoap4bSJtpc6V6H2SuYjnOeMRn7T/GUUdgBd3MnaXJTpMFcEywDubTmcytLagLTxZTtnKdvd2mmhLp4KkiB68wLiTZcu8UIdlRrM+1oxH8jRW7tOxpf7iLMIO4IhjChs1KqhulH2X+6QE0bQO01O79nAWN7OItqzFsyMeftg4tyZ8yMLU4vFBmWJ99eq44Z90thvU06eRQQRHwq403O+ib518kbA2VNktoQdt1fL/7NZiA1QVPxsADtbmrHOeY7kjzfpVUDzSpd+cfaBE0uAgj6iFDHxx2/k09vU4lf1EZ+7YPO2aPxQShEIvk4Bkvu4kcQO9f/69/VSdu/Bwj25mPJFzKUIKkgaEa1TGepEuPH7wAZ2KxSdq2CEWPl9BBsOZIBbjNGUVHpQcrAQ2nI/iLEHisg1Qh/OLi1n60fAln1EvXM9rd/EA2tRMvFkP5CTIpPLlCbo7OU5d8tSCaCQxtgTrdOJO9sEB5aeMzuWtRcexZeLlhvqSP04mJJsh6L6ZsNZ3DJYMJqsPfAz+oI6i+BU7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch enables the 'async' sync_mode in the driver. Further, it sets
the default sync_mode to 'async', which makes it easier for IAA hardware
acceleration in the iaa_crypto driver to be loaded by default in the most
efficient/recommended 'async' mode for parallel
compressions/decompressions, namely, asynchronous submission of
descriptors, followed by polling for job completions. Earlier, the
"sync" mode used to be the default.

The iaa_crypto driver documentation has been updated with these
changes.

This way, anyone who wants to use IAA for zswap/zram can do so after
building the kernel, and without having to go through these steps to use
async mode:

  1) disable all the IAA device/wq bindings that happen at boot time
  2) rmmod iaa_crypto
  3) modprobe iaa_crypto
  4) echo async > /sys/bus/dsa/drivers/crypto/sync_mode
  5) re-run initialization of the IAA devices and wqs

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 Documentation/driver-api/crypto/iaa/iaa-crypto.rst | 11 ++---------
 drivers/crypto/intel/iaa/iaa_crypto_main.c         |  4 ++--
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
index 1c4c25f0dc5e4..4c235bf769824 100644
--- a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
+++ b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
@@ -272,7 +272,7 @@ The available attributes are:
       echo async_irq > /sys/bus/dsa/drivers/crypto/sync_mode
 
     Async mode without interrupts (caller must poll) can be enabled by
-    writing 'async' to it (please see Caveat)::
+    writing 'async' to it::
 
       echo async > /sys/bus/dsa/drivers/crypto/sync_mode
 
@@ -281,14 +281,7 @@ The available attributes are:
 
       echo sync > /sys/bus/dsa/drivers/crypto/sync_mode
 
-    The default mode is 'sync'.
-
-    Caveat: since the only mechanism that iaa_crypto currently implements
-    for async polling without interrupts is via the 'sync' mode as
-    described earlier, writing 'async' to
-    '/sys/bus/dsa/drivers/crypto/sync_mode' will internally enable the
-    'sync' mode. This is to ensure correct iaa_crypto behavior until true
-    async polling without interrupts is enabled in iaa_crypto.
+    The default mode is 'async'.
 
   - g_comp_wqs_per_iaa
 
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 19f87923e2466..7b5b202a8021a 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -152,7 +152,7 @@ static bool iaa_verify_compress = true;
  */
 
 /* Use async mode */
-static bool async_mode;
+static bool async_mode = true;
 /* Use interrupts */
 static bool use_irq;
 
@@ -206,7 +206,7 @@ static int set_iaa_sync_mode(const char *name)
 		async_mode = false;
 		use_irq = false;
 	} else if (sysfs_streq(name, "async")) {
-		async_mode = false;
+		async_mode = true;
 		use_irq = false;
 	} else if (sysfs_streq(name, "async_irq")) {
 		async_mode = true;
-- 
2.27.0


