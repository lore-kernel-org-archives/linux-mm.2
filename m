Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DC5DE63C85
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 03:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4CE86B00B0; Sat, 24 Jan 2026 22:36:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4B356B00B1; Sat, 24 Jan 2026 22:36:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A376F6B00B2; Sat, 24 Jan 2026 22:36:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 90A686B00B0
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 22:36:09 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6003D14043F
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:36:09 +0000 (UTC)
X-FDA: 84369072858.14.72ED070
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf06.hostedemail.com (Postfix) with ESMTP id 57F1B180010
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:36:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MZcVOQBs;
	spf=pass (imf06.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769312167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jxv8m5eWKMlk/xVM+9wJ4GMknwddkqrfTEUsNesHluk=;
	b=Gy7Tio07VOQW4ObCma0s5hm4FSXRKtBztzGVqQF00pzof4qMHf8N7z+76RUD5AegFLA5hI
	VesijuO42mhdctZg1By4VZ3SSQTtJ1+rdq/IR/6x3B1BG6y2oYzNSHhHJ6aaGMt89XPFR5
	T8VtkZCruB7bLzcQ6eJXEKfvjGazlss=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MZcVOQBs;
	spf=pass (imf06.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769312167; a=rsa-sha256;
	cv=none;
	b=Tz995pg7liJFt2gJLwjnk4LBSCtXSENSBHMEh6XS6Ty86vhGlLmYSpbbANKzBL3Y7kpoyk
	tAIUy9LWal57HOWHoUVgh7DI2HLIca40Q+n00+8EEqZQEVD8U5y2UV4XUhA+gdlvOc6hEh
	W760oRD1RJjEjltw48hatoUgGu2EHsM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312167; x=1800848167;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q1mVf0QKYvPJ+4NSUc+0SqCKPiVImrf5Dhf0M/kxVrY=;
  b=MZcVOQBsNfilAp+5u4+5lX8XZPFkhbwv+ZD6sgK9Yo7LKpATGznoJd5Y
   XcHLKp6EjVJn8gDEV91Rc2jx9yMn38fPsqwwM/ElkeZe6lfmTCs92B766
   TGdkSWyBBxvBZ1MH9ywH7lTRR7SN93HlSGzPxs7yEhrGywGH3r178uVAt
   Hs3CmEnRNX/H/aO4ldYq8BL2RwgYifTE/Q/+1GfgYz2XS+8ntbffugOsc
   Seo0pM8T0+qm8bFm69EIsvkSSfknC7IxM0M2zhHP1VUZB+QsQFMLyX8tm
   ipysvmpAUs2cEic90VSPSmMYAMUoPNAVEUXg/9FPmy0vy9zcH4cMbuzjP
   w==;
X-CSE-ConnectionGUID: dnsIGKeQT7SDdgS7cDIwuA==
X-CSE-MsgGUID: s4SzRWg6TXKK7R0XHmZoWA==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887591"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887591"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:36:06 -0800
X-CSE-ConnectionGUID: 5/eD9vAJTqqE4jtBlE15YQ==
X-CSE-MsgGUID: COri05SvQWSM2HYSqWh0YQ==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:36:05 -0800
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
	vinicius.gomes@intel.com,
	giovanni.cabiddu@intel.com
Cc: wajdi.k.feghali@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v14 19/26] crypto: iaa - Enable async mode and make it the default.
Date: Sat, 24 Jan 2026 19:35:30 -0800
Message-Id: <20260125033537.334628-20-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 57F1B180010
X-Rspamd-Server: rspam07
X-Stat-Signature: 9r8pd1eddymbdi5zk7a85qq51n6izpr5
X-HE-Tag: 1769312167-432245
X-HE-Meta: U2FsdGVkX1+CEvYNuc0N6eJltyamfC0TfH6RZVVWxxmEH2DLdfDCTKatoOLY6QrlAQVwVb+pBFbL4Ro48LAKi2fQFwkt0WME1Y+qV2rfzQ4a5axN77p/JXbAcqHfYiuBKKjVn2+qe2ylHfNPeCxzLM+eP33txbb9Cco6GM3CbRr66/p7V+LcfhzbRTPqtoFjo0QCbe273ZJufXfL+/QFEprBT3im8uqgdG2W5vZ0cfw6QFGddUZnXwi/XjBgX/ViXavK/lPX4MFrPh7MldLRluWuIc+804/yoc++EBi3+7hstuT/Z4A6X2HJELLiwCcnF/rZgMkmwAMPQ5zHNDkSiHOTDIu4wjQbNQVxoRj5jhRC22JZ7RCjungGd2CWQWH3OGsJEy79p4A4NRMHX/6QeXwLic2P2kI36SBeL+h6txoKefd4OvemtcHzuG5IoK4rBkgp4k7O4qHaMFjhUJZzRwMmOPYB9Y+go52oUvLM8fkYio/w14OK3ldoiri1VuPPhDRoDtRk0/gLUZvCOhtC16UJFx2qyH4/KuKUSEEfxRvh4ZZR2b2VsPyQ4GP6scXk3LQIxLhVegwEFVEztR2rBTE2VnkIKWu4DoogOlkBAiNhp4MdliaRRfkRGG1XPVtZpEeCuoTipGFOexj+AyoENX9DteqPyd5PMIq5alFMYMGUJYsfSGPreOj9QgxB0vmZRlpdqb5CnYgu8jr9Cax5QKjKc9Tn660RIQnaBKI3FJhw1lVgMbGopubGLFtEhw4TuHNCMW5NOF23XNbkppN3Q+BlgkyhWykJFAoXr26keEz0D5VFA1EeVENcBbdwtC8CTopLf7G1vpj+C2qdOYvITTkNB6ai2Ba3hVRJNuRMb5Uo2f4iUhi+571pZlHp2E1S6sRIVTduPbr7d2K/tNTVqtVAVlA9b4IHmDvqD4IpeDapin0zLGuQWHu6YzZYMWAKOfGUoE4IEkZ4GKShRUF
 fJTmx0Bw
 zSdEkX+DGB356URHJ0dZbcCL4OA1FNO8Cy8rqvs/+D5BzJd5sjPY28XvrFZwPxGcwC8ADekZaTqWWH69OjCVdMzyqpiQhPykVm3vBSA1RfRqQ+YMfpEm7x4ng9wHEtB+0AUO9LM3vpg/R4RGN1BDsh4qdbVjLeRBLAXn/e7VRsq63GT7cgJos/fv1aA==
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

This way, anyone who wants to use IAA as a zswap compressor, can do so
right after building the kernel. Specifically, they *do not* have to go
through these steps to use async mode:

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
index 915bf9b17b39..f6e18f458fbf 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -153,7 +153,7 @@ static bool iaa_verify_compress = true;
  */
 
 /* Use async mode */
-static bool async_mode;
+static bool async_mode = true;
 /* Use interrupts */
 static bool use_irq;
 
@@ -207,7 +207,7 @@ static int set_iaa_sync_mode(const char *name)
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


