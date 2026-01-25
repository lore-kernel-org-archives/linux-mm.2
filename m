Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73261E63C86
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 03:36:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416D86B00B1; Sat, 24 Jan 2026 22:36:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DE846B00B2; Sat, 24 Jan 2026 22:36:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C4E26B00B3; Sat, 24 Jan 2026 22:36:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0E2166B00B1
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 22:36:11 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C68A358C36
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:36:10 +0000 (UTC)
X-FDA: 84369072900.23.3CFF5DB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8EA23140006
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:36:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=c0VCBxFH;
	spf=pass (imf23.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769312168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OBkYWI62w+GLsNuPUOylWalmCr9sPlCP/apxMu9aVMA=;
	b=pX03+T7dC5EjvkFdfPW4o9W3CNAVg7T5g9IoBSrG70xYsbV355ERYSwrnnehBtVQZ31J1Q
	TBVOqpGoSrqrSz2XQHTaPcJlgwCdb+0FwMZQBp+Xrk0Q20It0Jx9q5BXLeR6fIyi4UPSBa
	BsR4iFd3+r2DnPubFYyZLIQaTTpdUGI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=c0VCBxFH;
	spf=pass (imf23.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769312168; a=rsa-sha256;
	cv=none;
	b=scpxVBkTl7wGAsJH0uC+pXoaiUeAYBTOWsGbBHXHAQ78IbLHxgtq7ADTlar68SxS9lQCG3
	Vfz4sGa9xEg/w9u3nSwzjbTH8mNozZcE1Fqys5atFkICNfEscWOaZ0nfaaBoyYu3jriv44
	d3g0q1c/nTUCLlQbNFsdH2PJJ1aoHqA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312168; x=1800848168;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BTzto9LJZ4dLalRZ5djoz1jmTvw0aNZ/Qf035G+8x48=;
  b=c0VCBxFH3e9sdnGp+UKmZKw9zaoUoyFHXfw6ruCCr4fUkXXMEaX7XRGW
   senZcH7cuP9wxSJn7LAHSgkUlyi1e3sNNSfDaSeetv7KCVtwSDLcdsvY2
   OxWFySdJrBRYJo11Gsds4YHGjCfap+lJv05S7/mIvod/9+4OLPPbDvRBu
   TNgL8cePDnegSRF4et5RMDj1jxErdJiT4GlELB6P2ewx7wAdWzgqjyRDv
   IF+I7MhDaw3uBAsQp7hERpzgblAbAXAyRDWg5SP2VDIO05C3esss9y3O/
   8DBamE+xGgCzwXjSl1FcIAbS8CGATGLJPXahCrLq23tQ6tPaq608uB23G
   A==;
X-CSE-ConnectionGUID: FN+LEUZJQje1t8F8VQYxvw==
X-CSE-MsgGUID: aPBt1CE+QReNW2ROEJLdeQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887606"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887606"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:36:08 -0800
X-CSE-ConnectionGUID: asSjYB5sRwCnHWdNtxnXag==
X-CSE-MsgGUID: KwOt10VzRiyXQir+QElPeQ==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:36:06 -0800
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
Subject: [PATCH v14 20/26] crypto: iaa - Disable iaa_verify_compress by default.
Date: Sat, 24 Jan 2026 19:35:31 -0800
Message-Id: <20260125033537.334628-21-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8EA23140006
X-Stat-Signature: twk3mc8n9fprmoppmwmipinfbc9axs4t
X-Rspam-User: 
X-HE-Tag: 1769312168-935942
X-HE-Meta: U2FsdGVkX1+in0sbwGacuOnvRfLmkIRoiGJiMN9tJrk/uKvjzCXcyNGgHm4t3schyi7joJd0RKs/s3N8GVLcUb0SMzUb1GjuaW1i0jwT/YcSl0ERpJEVN8JS/Ua8QE5gARm/pYdsqU+0FVTJOVWQJ1U4cMfLiCpsa08iPxCTAPbVv3RlsbGEtHl1U4lh39x9Gn1e4w5zhqL7g1VGyXFuQX1n4KHHrnuRTY6bxck8MAC46mqMrUkWowcaZF7iaoF8RWvzlVxUNCgPQ/0FbARER2msI4Zkxu+GNfliX15bsOD+c8NgJwQJdm67CV4xT06NtdnogkUKTsmZ7akBLAVbDQipmOBp7zCV7pUR1C/RPQWclKAXR0BSgPwS7kzeoApHPJqKdFXwzilMHD2Qywhl+d0iG99gg5IG4TREr//mEqVjtjYiESg1KTUhkH7JjrananZcZCSmBEWXpS779DjkdocSGd/qHiC3nCgkutwnUuejCy5/l9LD38j4PbhBjXHcZlexKzgLxDe/gXcQgx1KC9GNfq7bNQZyvirhDjzXaBrF5LC8V+fBFeCoyNK50xdavcGgPNMtzYz2oZ039as2Ngp3LVisp3mUWmyU/I0y0Yj5AW5KqqUOb+KerVSE0M/URa9L/+ao/ehNG77p6r1VOyJ5KCDW2DbNaOjUNCwKWaKdBlGMCINV/UU+HMJ2fK2kK2cqwvvmJNZfz2f/NA6lbv9PjU32tPqkJ82CgMwSV7E0JfhUS7mcIZ2lDX+zy+7kwBP5tJ92PNOzFn6Hkk2hD90IBO9yYQVrgiQ4WqgJYTe2q42mFeE6urku3MSWeOOHJ301Vr9XWJUr8kNwjfw+1lWg9UzQ/m7y+O3Rsuyi7ultxJRpij1WqEu4j5PR43YiJvdYqBB8gzOMgCnCbcgBfhiIoxzJ/I5SfckQA6uDzaD7tJsk+OC9X3Lx7hFLr6WMOrlfx8GEkTmMJg2lHUg
 EE0NlHg5
 fYYG91oTF8i82YwLyWdu4BNCFMLnb2h7/zI4OZtO/FJLrexlBPJNlbnb8YB8VbN4G7BhmKT+ZAvwVoCAiHXE0bJKiv0IYfTsAy3aNAxWOO4VyXRtBIpTuUpqV9pYrlvgqHhpdtCf/6Bzl/nFXdBoLYoGnSNdbyiFjZqporUP61y/D6sbJhrNyK2CIo8hwFncX+aA4N9Jc64pngG3Xk+w7P8NrIyKHU34uBO2K
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
index f6e18f458fbf..7bc4a80bd68b 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -121,7 +121,7 @@ static bool iaa_distribute_decomps;
 static bool iaa_distribute_comps = true;
 
 /* Verify results of IAA compress or not */
-static bool iaa_verify_compress = true;
+static bool iaa_verify_compress;
 
 /*
  * The iaa crypto driver supports three 'sync' methods determining how
-- 
2.27.0


