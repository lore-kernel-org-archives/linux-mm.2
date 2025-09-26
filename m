Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8297FCAC5B5
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 03:35:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88D6F8E0019; Thu, 25 Sep 2025 23:35:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83D858E0013; Thu, 25 Sep 2025 23:35:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6427F8E001A; Thu, 25 Sep 2025 23:35:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A7E38E0013
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:35:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CF0D611A4AE
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:21 +0000 (UTC)
X-FDA: 83929986042.09.35E5952
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf29.hostedemail.com (Postfix) with ESMTP id A2E1D120009
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZF3cp2lN;
	spf=pass (imf29.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758857719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7wftOFX6uIqRCqELL2jztJ7JXaVKa3cVa3hGo6RP3Y=;
	b=QUmCTu/A9DFgqHEYPMmDzbpRP0zhr0Az8ahbKeRet0p8rYH8h+my7d0T7BUPqlOp/0DHlQ
	eTL2jQcyK+O0o+BCqEfn8/k/jB4ahEYrKR0Xn+p7MnVpnsd+TQmgIaUIyc6nB4iJX5o9Bt
	exKJNv7zbbe00BNU9g1KexW0FezfVps=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZF3cp2lN;
	spf=pass (imf29.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758857719; a=rsa-sha256;
	cv=none;
	b=u9ORYgZm0OxyfR1NbOgnf7z+/43Y/3BNV7PN6dNgvNkzpKynWFFfVM7NcYaksvbBQzHP5y
	x6nwfG5aDow07+1QRTVUlKBx/HnjsV/Rqa+NUlYDWQm5FGYBg4tfXYneuqzPBEAan4YPV1
	4ySUlWBxXhKVYXPt9kDL6tfZmrCBCvA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758857720; x=1790393720;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dRlpVlM91EY2UmAflAtlYIoSrF1HS7+q+5czUjAJLDU=;
  b=ZF3cp2lNsZI0iqaoUqdKg78YkFiOb6G+feJxGQK2zFZoiLpxIVULpTp4
   DX0hjb8lBwFHRqmnXIeFGFBdV6z80nKGL1QrMOCYmUigXQ35brampg3+q
   2p6VHeKWZ7GwGvtAv4B1Y8C4vyiXQ69W1XpXniJSRkBZPjWhyTLo3+NL0
   EMGnZUWOOojJUL3Hi6ItWSnVy2y65hnTSofVE3MBzRrCWLbu7r0l2PEP8
   RYDniGA8rnygglQLMorOjZgTtyvRSJ5gr2hINRtrbWLJOSuKYWTk0aCKO
   S/tXoHLQMeECQZ2Vb+uoLFlcM5uUQUzT6x6hRveR35XrFUMZCSB35E+BQ
   g==;
X-CSE-ConnectionGUID: O/zkcdi3QP+llxxYMRPAFQ==
X-CSE-MsgGUID: G3cWoy/ZRjybf49rI6bGug==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="63819618"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="63819618"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 20:35:07 -0700
X-CSE-ConnectionGUID: xkKr1NNhQJW1leB93+byNQ==
X-CSE-MsgGUID: 60oS/FuYTWqw+ZeslG2Hig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="214636598"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa001.jf.intel.com with ESMTP; 25 Sep 2025 20:35:06 -0700
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
Subject: [PATCH v12 16/23] crypto: iaa - Disable iaa_verify_compress by default.
Date: Thu, 25 Sep 2025 20:34:55 -0700
Message-Id: <20250926033502.7486-17-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A2E1D120009
X-Stat-Signature: qecjy99hy9q8umfz6wy8zjgq3kfgatrh
X-HE-Tag: 1758857719-106287
X-HE-Meta: U2FsdGVkX1/uB91UuMiLw4z3l3yJqYzjj5A2Rwe0K9jixBBdxcliFM6W07/iuaSJk+MM4kWzG6LvsaKSNY9koehK/igbHSQyPA1QnubqspjSBxrkxwhfMQY+w1GWZkN05lr9XCWFkNTlbt0uBu/vUqsk2tBMZp8YPIgsv8QU70OroWW2qlER36so1Cin0i+Atdnvr65cORJF4lO63wTckuDYaHgWnuZ0FKsA4Sm4mptjqHW6uYZu1oURf6y4n7+LkSK4kPeFIuDGouNecUU0Q/RqrtiYYCqWic4N/xMGrWRPxmoVmRayVaZKRoT6EZ+YEQqk7n5Gm8JcDQ81D9Emy1d1GwlYuJin39FD19yirFxIj2887Sv5kEEL+9cC/vlB2jJds9b7rLwwwaQn/DH/rtlodbdsfovWkPWz4f7a7YxLEzNlhUE0DMrQ9yMa7WjmBuukJafbrOBsxybltQPBOiRxgW9Uwwsl77gjx8/c4W7UXsYFk8bg5/tgcpche77CvgxJoy6E1qfDBxmT/CgMcXajqgMgsonuD3tXho9YmuIAhPoS3lfFNUJp0WqQ5LZwL49YqtSdH3BsBPqv7V8yNMJEKR2nteqw5jgT0pXFNiliun4+T6w7nUu5Kf3Unpa2J5wbRQR6G0a4KwpneT6W8Rie7QEqEKdsAOXYYOdRNdx5PelBhQO4LT7v1/sAdlGSeAL2q1uTC/jjloTWypo2dxQXZXWx3xgxnXIVeyIks/fsNUaxprK6ZqyGtWSkw5TvQolvLSSFPHWl48bB5Ps4eiHAmDSz7EIkwwQ3oxpR0y3PLDBDUQO5YpjRb49PKQUCom3fNVD+gR9Cg4Zy7DdMMoZpWQUDxPnjS2KN+G8X6iJrFfLk2PE/aCSSGRcVKbEz1LtVmwz3/4ayHjc/wXp5ZrPBSHo+7a2TQvBHgtgy9+8tCa+9N2RCW1kT4uD87slX6tCxpsRisBeqppnNuyM
 VGvozbTe
 VN0mwgucn9Q5J93vfqT5eR9M9bVXQg21srxop9Dur0sMYk5/3/4tBCGkgXKH+eORYpBgleMbH/vcbqN6+khwrAyqyWCtnCtwlaWE98h+bVy5OcSsUZOy4FV+Tc6Fl7tVaNrb671ObU80WQcGHBv/+cvNcH/1A0jpy4qvUtG7Pj9mWDFmFT8KO3RpCN2Ak3DRUJCowSukjqpnMuuYLlWPPP6Z7HkBnLJmjkC6F
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
index c4f40984e9bf..5b933c138e50 100644
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


