Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E9AFCCFA00
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:13:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95DD68E010E; Tue,  4 Nov 2025 04:12:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8725D8E0115; Tue,  4 Nov 2025 04:12:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 712958E010E; Tue,  4 Nov 2025 04:12:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C5A18E0115
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:12:50 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 18C5513AEA3
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:50 +0000 (UTC)
X-FDA: 84072359700.25.E5382B6
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0EE0D1C0007
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BLShkpsS;
	spf=pass (imf20.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762247568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=alrRUUWSGvwmVIDJEpaZK7dtK4Vv0EdvSBSNKCk5+GI=;
	b=EcuoHXAn3VzbKnm60SRvj1mvLp8BNknU1EksAdpkdNUssDkqRB/NlH14MsGCLJ9hbmxsnr
	anoxa55VnOnlPq9HgpsVTL//lIDDE24dF3khpWPRjyGFNfi/MZgDCQGw/VEbS9ZthaPcuH
	yDjPMXS4n/5rMS2huDyGPcfS2Ivi1tU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762247568; a=rsa-sha256;
	cv=none;
	b=u6nbkb8kk5zEa/imYxEJ98JcsQkWpz+EwDgUBuI6TFL0FKLUoLFg5Q6sHcHSzUbzgfadS7
	vKmnhT8lsfEkVi8q1BCfcryWDrwRJCsA4hb6BVd6CG6Ukn66Z1l5b8Fkloc63fDI0hJmiN
	w9r/UA6WW0fJ+TMpMJ6LViFzu7wow4s=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BLShkpsS;
	spf=pass (imf20.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247568; x=1793783568;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9P9wKFrNJfPIpXmyA+iBMEWI3wiIcFTfyNcL9Mq5cwY=;
  b=BLShkpsSH5p3Ckxo2fAoPcnXwr4hRwSqQaCIMAhEVM7NBUsdCxNXXZdy
   gHF8+CFdJ27RAL4Rq4mvDNEjWbC5Frbe+Jua5bCXkAjzQX3HDHf23CYZg
   MxjziJ+ZosTEDyEKZZwcrN3qzDva/ecsSescsb3vCSk6JENnjplYhvu0p
   1bVlCpmjURF7jMRSw55FyaWhb86ND8HgNh9PxIHmmO9EyMPRUmzPjifxi
   vSCZP1Q8PmoUrFe8OGMluCbxywL6or7XvpoOtU1CHOUx30QZOEFYXJUjz
   CDTcC41A5TcYafywnR7CBQIupybOMcNHGoCzNTjn2umUwmbfx0uFZH9kX
   Q==;
X-CSE-ConnectionGUID: ORFFEudDR12104xMuSenMA==
X-CSE-MsgGUID: 5vtRQjGhQC6TTiyVIxRQmA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64265194"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64265194"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:38 -0800
X-CSE-ConnectionGUID: yWAMtL9kQPGGUXHGs045lA==
X-CSE-MsgGUID: mcfHprBDQO2DIBpU0fv1wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795820"
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
Subject: [PATCH v13 15/22] crypto: iaa - Disable iaa_verify_compress by default.
Date: Tue,  4 Nov 2025 01:12:28 -0800
Message-Id: <20251104091235.8793-16-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 0EE0D1C0007
X-Stat-Signature: q4z88sjc49s8iqrxrxce8jq84zdjjq7b
X-HE-Tag: 1762247567-32226
X-HE-Meta: U2FsdGVkX1/epzKHG36ijpFm+MfKxn9tvpiaQKmvfP1bSAUjgt0T9x+O9bKTPEyO05xllw/juVeGiBgTIsIZnUNCmkRLV/VSkLNaqkeNvVeZIbLaxjvJyQmSddvIBpTYxn9Th71jaNHo422asbj/jT5fvMbIPs/bmtgbkLBhYbiJqGXvxPR264QPLRPEEujgP72ImozAhIGn37wCWi1XMIcYS++NxIbE64J/EFUtAJb9h49IIVhk7v8VLxbDJ9qb6OpO3fZtY6nSjd9KWOA7EsH9JBklUIIcCyj74VN6lP6fbzGWA80Kbkccd0pSbRTOSacY2M417H8SKnLv+0yozFeTU1+AG4XMkz9vDA45bPFwmIjQt7I6P8cJWAG1eEnPJz8UhppatEVpG5x9W33p8MIdERIIeZIIuh6wbSfFmDPcJCpHWimpmUJfwomGAaAVK4X1opOpuMw0tARZJOI+Xd8R2y7yQFuX+xE4r3GlBSF2E5A6T2ZEZ6TulGoixr7ef94F1q0mOmPZwososNllf1JBv/yd7lgJuCxIiFNMGAKNnO4ahEvTZC7/2vQ6BU71UofVHoSFc0YAoRj7W/0ouh7/32X84HkyGB0LXr+4WjT5Yvpk7NXhLNmOY8yIvenLXuIUBalkCaLuVEVQi+gQRrkBhqDgtRPgeusdkKs6KFsXbQq0/ws+rlkWnnOLG9xBXeKFnPRCf8XvifvQpwrUcwJvnZydzzi4/AzpXHHuFOuFfA2w+mhGvzjkQsRSnga40vD995GXj1s3nEE91Nb8wS9XVcG/ArpDmSuv07ZFqZ+He2GvdbDe2NZvnXUQHZ4su21MwDqE9/l3XYIzGhgHukWN3ML6LOZhHFApyPcaFaodUE7cIxgqa1zSHVKp5pfNtNW8eRXNvLb0CartPu6Y6cfxiLhZblJsoBC8knaz+eFy4dtoRXB7/lPCKDfCU73srKhngpQEf8RYOdwndM1
 ag0snltx
 Lyga+uMRQwCagYJd9TCP8h0PXjIo6c4S6TwPAQMD33Z9H74zsQtOjr6u/e6ez0dOWtLXkDqmcCTdBN0i7PKMGRE6FfJZprn261D4XY9wORUor/raJXolAAwbSrvGQ8dalPxAr/T1i1x3YiVeEYbM4YXXqon1+RfYaMyJZzyJpBiNfJWf3/MqJx1uFqw7WEdnXGADaSL4e1kTlXZO3omPP0jVpsTT5E7XbZb7v
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch makes it easier for IAA hardware acceleration in the iaa_crypto
driver to be loaded by default with "iaa_verify_compress" disabled, to
facilitate performance comparisons with software compressors (which also
do not run compress verification by default). Earlier, iaa_crypto compress
verification used to be enabled by default.

The iaa_crypto driver documentation has been updated with this change.

With this patch, if users want to enable compress verification, they can do
so with these steps:

  1) disable all the IAA device/wq bindings that happen at boot time
  2) rmmod iaa_crypto
  3) modprobe iaa_crypto
  4) echo 1 > /sys/bus/dsa/drivers/crypto/verify_compress
  5) re-run initialization of the IAA devices and wqs

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 Documentation/driver-api/crypto/iaa/iaa-crypto.rst | 2 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
index d5e610ef4612..81a7dbd15f8b 100644
--- a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
+++ b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
@@ -239,7 +239,7 @@ The available attributes are:
 
       echo 0 > /sys/bus/dsa/drivers/crypto/verify_compress
 
-    The default setting is '1' - verify all compresses.
+    The default setting is '0' - to not verify compresses.
 
   - sync_mode
 
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 8f477577dbd1..349fea0af454 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -120,7 +120,7 @@ static bool iaa_distribute_decomps;
 static bool iaa_distribute_comps = true;
 
 /* Verify results of IAA compress or not */
-static bool iaa_verify_compress = true;
+static bool iaa_verify_compress;
 
 /*
  * The iaa crypto driver supports three 'sync' methods determining how
-- 
2.27.0


