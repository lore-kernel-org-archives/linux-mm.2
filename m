Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D816CCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:13:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CD828E0114; Tue,  4 Nov 2025 04:12:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 209E78E010E; Tue,  4 Nov 2025 04:12:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0356C8E0114; Tue,  4 Nov 2025 04:12:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF7198E010E
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:12:49 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B7AD588AF0
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:49 +0000 (UTC)
X-FDA: 84072359658.19.43E6DC2
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf28.hostedemail.com (Postfix) with ESMTP id D4A5FC0003
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SESBu01r;
	spf=pass (imf28.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762247568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mm3OWtbMenvARoQizCzN4adequUQIcuvB+3Y+KCz1CE=;
	b=6vbJDZRwBIJAKJA0BBLj5lc25RE0+7VFZcL1qia+nlB4ql+GSZW8apjx4u28Q6qYW71rT7
	+7E7UpEHExP+dk/zivQq+HZG5sswz2tpe/ZzXfhWyRQCdNzpVdsd4S9c9HTEHGSnWyjAfZ
	uW9iXEsXLt1Fyssniv6RYIzA/GE90Ds=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SESBu01r;
	spf=pass (imf28.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762247568; a=rsa-sha256;
	cv=none;
	b=JTt+S/G3d0Yz18kjFrNS5VPdcdhIDb+uLgU7ye3PBR8JVJSBdjtDT83XFcKlpvRSOOw0Af
	tOXanoa2Wgs1NTP5cnE/qoBBBvAvrtBackGZHUDllSp3wlvlLGb03amKV+XVAl7VYiY9QC
	rJgNWS+EKvvB0bTRWGOzSly16eNjvvs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247568; x=1793783568;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1IH/u0z2lEAANJnIItHftCiWrnwwoKC3dUTlINqv6Go=;
  b=SESBu01rBfO5UPQTJo9Gri1whmrcI+m3svbxe890mAX64XdJvEiqkzn+
   v6EPfbz7oEj6uUZE0moDo36k46tPg6kCqlgAnAQtft7Y67NJ9s3Kf3Riy
   26Omr/3EsKX/zxDvwPYeDUoUGlopJtYGfnSo5GOs1vZizRQxS9zy/QCGH
   HL37Hn9rE0Rj/YBv6tXfKdSVGpZSOyLvG5BdvZcthkfd/HNQgBdG7Lt9G
   5SrGED9FY/QU/VXqCwW5p/Ld6iTuCZgNJc/q2GODqvMy4GjDnYPZjr0A8
   9dY2c1izHGu8WMnco5+2GKv+NWIJPQTfnDAStFrRnNQ7YhsKBYY+oYrAM
   A==;
X-CSE-ConnectionGUID: e3QDoeXmTWypltd0RmXN2g==
X-CSE-MsgGUID: IP3rhvVWTyawfByZsdbYew==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64265192"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64265192"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:38 -0800
X-CSE-ConnectionGUID: A1gZJX8ySVC5vBc37FP5yw==
X-CSE-MsgGUID: QnTC03PvSNGQq81wbKKUkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795817"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa009.jf.intel.com with ESMTP; 04 Nov 2025 01:12:39 -0800
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
	sj@kernel.org,
	kasong@tencent.com,
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
Subject: [PATCH v13 14/22] crypto: iaa - Enable async mode and make it the default.
Date: Tue,  4 Nov 2025 01:12:27 -0800
Message-Id: <20251104091235.8793-15-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D4A5FC0003
X-Stat-Signature: wauarth9q8zzc9jayom74gyzej9ky9mt
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762247567-960793
X-HE-Meta: U2FsdGVkX18Je0TiB3DlikBl+ZpOCYr3FFRrDqHTyFi1UGICX3UkqxKJHwdVhUrmysYIY1MPV40Fi30pWezYI6uQ9nytjbddVY1WIxMYYbhqxaVF15E3nwXPYYO+w7jvI6U0I/mWstY1PcmEJgCK/ipIucFolfctmFQwZ+QIT/NEJUMhtXNXygw3P8e/N0J6J/oTm8rmn/J8JmjqWH1aHezAIj9nBA7y7801tPDcUAmw84bNEi4ajCP8HPcR6F4fazFzOxNZq8kfPouSAsBjWBxzUyIxamf50iadhLUgwP4SKE7WOiV6rh85EJEDFX7AzBZ3xlbYo1UcXlp/64EWP6r96OvPhSqKJlbc63mqa4ba998vFtHIeLKRIbq6C5PmQEs6IewZALLU583BR55B5vRxikk2RGfbawKz8Zd3HV4fSDQHPPzNqRaYx+fbZebL1FtvQwnGF0fMXHB/L/A8Tm49mB/9jf/ayAOFam5ECor/puZOGf7Ig40Tiqqv2NUGdvLZJ5kA8ZOgfQVBGLU5tz0kxJrZuHFX0j8g1dadd27hj0yJ9vZEB7C9J6VSaGVfVYPyQ/klYiy9Z4niLKkHc9NqRXpK5Yl7XOxi0M9bRrNZu8ZhlI4B2TspCH/3D9JmZFCkL3/4iaoqx3Cy+9n4fq574CxviOx4hBgspNkjM1l56j+kYyNR5mnuWLDYkT4qqb2sfrtP/spaTugx3GfGOqU2zxxORJPZixFUb31LPc26iLY+KUWWrrSRQDSR0fzikM0EMVsV6Uqs4KXzQYbiwdOQBtaEUg5OKRynKvodteCcN9zo9t9VseMp/3w0HROJgRgi23MvIHx3MTN1Y7wB9e+wieYuluPKSJKOce19qQqrJxtZCFQxG3LNuSziSxFb
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
index 0ff4ec603b43..d5e610ef4612 100644
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
index 910598405c5c..8f477577dbd1 100644
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


