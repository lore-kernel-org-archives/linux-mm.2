Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8A96C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 04:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E5EF6B00A4; Fri,  1 Aug 2025 00:37:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BC4F6B00A6; Fri,  1 Aug 2025 00:37:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ACD06B00A9; Fri,  1 Aug 2025 00:37:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1D4C56B00A6
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:37:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9A0A5114EF1
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:59 +0000 (UTC)
X-FDA: 83726928558.18.1C4EB99
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7D4DA40002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GtELuotO;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754023017; a=rsa-sha256;
	cv=none;
	b=FvALnd1WAqZyILkHr7sp0W+mhui39hucrR/m/27oKMZFS/Tg7DO54m6rAJ807haMpAz9cP
	LYU22TPcjlsjvmvWqLLSVn5qDR1sg04rxk4e8/NLO34PoQ3lyB+ANC0qZpUrTq/vDp2olM
	98jOfjplhoaTZGtAOPtyYqwY4gOi2+0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GtELuotO;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754023017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sMtvFjIRvgGSdUiz26EIr5tjNStNC55Qo6HGLhbwHBg=;
	b=zxP4987wvVFdaFH2p010vDp8LxXh6fYUOFXH+fSpekKb9YSxH6Aqm62bDMKWSJNW6H4sQA
	WfVxfBTUj6pfwJ6HGY59a/EfF10J3sGB04fI5QFfWhHD8O6O8TUUNgp+svNxYjHPVKA2HH
	fHlkfrJ8neuh7G8z4qcPnRx4j7jP+3w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023018; x=1785559018;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FnlvHyECT2St8FSdBB0bYZMpc5C8/71XEdNgjsZBPcA=;
  b=GtELuotOf+A66br/esLzvLlOhOkG7BQsf/gFtCa4Vd20j+UHrHSGG3ci
   J25hBniN4nOnsb4MrlcbNb03gyqqvTPZ3NeDK2o3BDkKo9x1DgwKIUFAC
   RIk5erRSgK9Zv8oE+zwu2kinulrQUBr88cdosLaEsfzPp8vyJrR9YssRZ
   W7Cpt5CZxioFyJpyst4xwfrJIl/mjMbfIma3yS0hH1dbzZ6QobKiLjPZO
   DpAVldE+K+nYFPtILcLFmKugwx/vD8ozuvxwfC7S3WneamL8VU0HrTpPQ
   ll/waKY5uZgI4T2JSnOaaPgnt8SOHwp6v5Cu2i2gPVLdLpfD0qZn8Ks7l
   Q==;
X-CSE-ConnectionGUID: gAMVXommR5OJEEDixU4txw==
X-CSE-MsgGUID: soai9GY7RVWvNpQYlPDEKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820335"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820335"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:46 -0700
X-CSE-ConnectionGUID: jHJ3MayyQP2+4e8ADCap6A==
X-CSE-MsgGUID: gZpWz8pbQ1OwreRsJkAjyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796283"
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
Subject: [PATCH v11 15/24] crypto: iaa - Disable iaa_verify_compress by default.
Date: Thu, 31 Jul 2025 21:36:33 -0700
Message-Id: <20250801043642.8103-16-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7D4DA40002
X-Stat-Signature: a4aqun1obqj15na98wj3zgimjjcounre
X-HE-Tag: 1754023017-314005
X-HE-Meta: U2FsdGVkX19qDvZb9uKVoadcgzmAvL0Ty5v9k2thfr0O9eyiYzxPzhTjhLNGvy/whc3mM5cB14iylsxTtPo9YXx9/8D9NHWYusiG7bRgE2bOuNhrvY0kq4svs+m2IiXHQWL5w8TyXDOmyDOeNIABOjDYp3f98BY7me6NysIoE9aF4W7kVPQlueEHvUyH7FwaaVtHzTITs75XsnfnqA0rgedBNI5cHCa2DTNV3R8wfyuNgXTg6CfH8B8PAGou8W2VEsh8LH2rH9HQ5RT0Qy0fQUnN19hS2UIwSMWTlsRnQQZYWTocm3PNhPmPjbvTkeHxxmToDcdjUcqKchAo+vK9Wyty957+aEMKiZw2+BTJInaz1q+TXYU3CYoPRPgQCej209OiNUnEdqvCCHflxH1zym26zVF2kpd9qs7XSNSV2OAIAgkje4vI3SIzJYJCP8YyaKzvUgLOL1c3GUaHhTfSURFam3o1pBy2abIz9cxPGU5Kcgo2U+s2cM/yYKl6mXn+d6eFcX4CQHhD5bAEpvgQPd5NFvJZ2ctcG5o7GTHB/vLJQY76VowGN+/UOCtwSmvIz+wVJgZBFajoEYXay1LOD+C2+EL/U44RoDXGQgA0EfWPrq+buVp9sFlKqyMQUpwepBoFcda/OgWESERIZIepCiVyY+TNpVC9yL4peDSVTwx1LNV1k1sGmUJKDY9gci1N4iY+8773J9iXT7q/ZVo827aJ4DnFqNoYT4mPmSQsNV5FUrHOkLRyheG4iBCURHzWeTjaxZCsAknH0z8SVfNkHYu4/Lan3xvli50i2tPUE+S5d8gNLBLSZXjiEvbjpOGOXgTtFL8q8LPhr6ap0CaAY5dESt9DlsudoY8DH9YMRysgcUppLxtE++k3HePN071t7QiSlnaXR+9Teauxxub7aF3JNO/w6Xn2gl0+0Jsu/SujXaYgJPIuGV/wmQbjIM/Cniswe2Cr6NjlVZgdnSg
 HMcax0ri
 xSLeYXWWg2jasYp9BrUY7akGtC4Z6QCWqDMDaMRMw54nkWYe3PJGNJYa4GH35Nl/IU/9Qph2ZK3rOCSDOm19z7ems4w9w6+gPe2AxE1s47Ok7fkal2T2SCKFdDHflDkCWwA0RotlZQRmCfrsujAmkjYKtqR1t8vOQj2Zsea7UwFK1BRwCjizd6g9HzpEXJdBg7f3gixJaji0z0eVipQAvrcDK5Ya4YPxr77Rr
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
index 4c235bf769824..9d2f3f895bdd8 100644
--- a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
+++ b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
@@ -239,7 +239,7 @@ The available attributes are:
 
       echo 0 > /sys/bus/dsa/drivers/crypto/verify_compress
 
-    The default setting is '1' - verify all compresses.
+    The default setting is '0' - to not verify compresses.
 
   - sync_mode
 
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 7b5b202a8021a..1166077900522 100644
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


