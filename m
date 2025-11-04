Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D89ECCFA00
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:13:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 553B98E0109; Tue,  4 Nov 2025 04:12:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42F988E0110; Tue,  4 Nov 2025 04:12:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AA298E0109; Tue,  4 Nov 2025 04:12:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2A848E010E
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:12:45 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B891D12BA11
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:45 +0000 (UTC)
X-FDA: 84072359490.27.E0BCE98
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf28.hostedemail.com (Postfix) with ESMTP id CAE37C0003
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LXj1JQJ1;
	spf=pass (imf28.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762247564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pq/Ickmbo2D8wq3c9tb6j2Z+R6bkXrRbNBhnSOG5foU=;
	b=AXTt1QjPUgrwV/JYpHaqke7stKuU9wIk/w1avwR74WFSCk0RvU2eKFJB+FgoMFuWjMNzy0
	tz3Av+tFe1vgqD8XiPoN57JS5fi1GN8qW5erl8oBHzMnBJa9Hgjz/aEv4oEO9upWW+g9x4
	lhgonvLF5bAh0kxVN+qas4u9oSTmQaI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LXj1JQJ1;
	spf=pass (imf28.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762247564; a=rsa-sha256;
	cv=none;
	b=FNngebK8Q29hfByEsRXFo3qq+mo68UIA8mcngVnO5iuSgVO3dMjsQ7Irj0+hYjMpATaaD2
	zIZPPqa5Cq4SvhT7YPxGppqD84JMTtwFPareKlY6cbINV9qAd5RtQi1lsALSXw8Fd9YlWE
	Ss4IHEGIh70Vvx/5KdiI8DhPQ091n4U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247563; x=1793783563;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qAiUTova63rL/1VgEjqH4x6ChPRA3PyKHw1bynlcMTs=;
  b=LXj1JQJ1zCug6W7CysYpyEaw6kE0AMtEy5ULZ06WYIx1pJ3cDlZYNGM0
   W7hFqJFTS2r+5Nh1QVJowt3gf4rG1xvhkZEnfg+0LrlQaBzZOtv7KzC5S
   Imu7GezAm6EfwW5i4XhRV95bh9135pFLtWp5Y+xgogduv5n10+c8b13wv
   JHa2uvwgF7wp4VdjFHQGEy4WdNsY/uxtBbr7Vim4ShOVoMqe60t4poFbA
   WYHS7iWeMr30Q3b7H6q6x+pyr5WJtZKIgCb+uLTQR9fdNHxKIsaDX6Vqk
   Bieve1nWs3qGcdXFTmZXFf7GSLfJn0S7ntWSc+uLC17zrCYGY7+SmaH7q
   g==;
X-CSE-ConnectionGUID: a3IAXVNbTJ2/3oIH3E2uvw==
X-CSE-MsgGUID: 2vsIHhEiSseIDFkKsve6WA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64265181"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64265181"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:37 -0800
X-CSE-ConnectionGUID: 3Tmk03wfQbaSMzQHuNOn2A==
X-CSE-MsgGUID: lfDcB0TETkerpu7hqFNktA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795802"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa009.jf.intel.com with ESMTP; 04 Nov 2025 01:12:38 -0800
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
Subject: [PATCH v13 09/22] crypto: iaa - Deprecate exporting add/remove IAA compression modes.
Date: Tue,  4 Nov 2025 01:12:22 -0800
Message-Id: <20251104091235.8793-10-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CAE37C0003
X-Stat-Signature: 7po75ikuqin9bnzg7pnbkjmnfzf5xtou
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762247563-816422
X-HE-Meta: U2FsdGVkX1+2PPcnemwu7FKxeVpbvq84Xso/hhoP8GL60inRU/HnjDx+A5KhZ6nKurCStEOfW3u9x0eu9xlGwMpSwuw8gF1yTSvNJTEHwcro7OF7exWotY62VYTYZ2D93WbVZQ4BZJmv/DyKBu+JSGX6ybcXBWnyDhKXHRUN6zBiKJyDSBLCB1WM7MK/cifrin3O8DAP9Cr2G8tZ/suFu5iA/38m47npwj1SmRWip8Mi7lnbh/8qXPRf4xY0FIK3eYjcY1dinDxlWh0iULKZlzELA0ilxDjvq9jem2hbmBn7JzNOGHQd3mdpRJ4bsIr4PegE6QEylF+EYfvUo5jwHI3NZAS7LDLuxfLgyLOzMbnL99CDoY5pTNfthtXRFqtG4r1Pp3Ai0zuwec7FrIdEMKA3xzu1ZMpMR6XggIXFffNT+L6B5SfENVlgMD42QEtyMDRE50dZ/dwwcje9376cCvUJgCL4xbY9BuIbi8c8xRdBWhP7MwT+TqFTY9XTvhOcbpQ0fEIL5lRcyaVncrlMn8rlRbCLe6sOAR29EzZJ8PzB2VfXCk9tdaheWTfoCEHUHCKpbgwf2iXjRQIazZnLLF4A/7VEv0jCSpmPlj7KHzXysxr/M3zVdBb1Zr6ptA/G/yQS1mWW9SpN35TWNwPYiNOIGXD+5JyQLu/xaunT0+Sx765RfBxeS2rmUUXrlgsHxCZEekfENNYLKe5crnkwb8m+sAF48sIzyYQimLoTYYHmLgcc+5ygnsBnTo1Xiz2ox5b+XhoS2STSu+E+D5aJA6P6KpLWqhvPP0vkBBuiHEls0DNJmXANAWtzQxyNdsuXeCEC0qt1zNHm+8KSYBWlPnNFIazGJ8kUnkM3GLQjWa9oOwJ2OOuneaMC6V11bqAS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no use case right now for kernel users to dynamically
add/remove IAA compression modes; hence this commit deletes the symbol
exports of add_iaa_compression_mode() and remove_iaa_compression_mode().

The only supported usage model of IAA compression modes is for the code
to be statically linked during the iaa_crypto module build,
e.g. iaa_crypto_comp_fixed.c, and for available modes to be registered
when the first IAA device wq is probed.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index dfc67109e81e..061e3403d365 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -367,10 +367,6 @@ static void free_iaa_compression_mode(struct iaa_compression_mode *mode)
  * These tables are typically generated and captured using statistics
  * collected from running actual compress/decompress workloads.
  *
- * A module or other kernel code can add and remove compression modes
- * with a given name using the exported @add_iaa_compression_mode()
- * and @remove_iaa_compression_mode functions.
- *
  * When a new compression mode is added, the tables are saved in a
  * global compression mode list.  When IAA devices are added, a
  * per-IAA device dma mapping is created for each IAA device, for each
@@ -404,7 +400,6 @@ void remove_iaa_compression_mode(const char *name)
 out:
 	mutex_unlock(&iaa_devices_lock);
 }
-EXPORT_SYMBOL_GPL(remove_iaa_compression_mode);
 
 /**
  * add_iaa_compression_mode - Add an IAA compression mode
@@ -481,7 +476,6 @@ int add_iaa_compression_mode(const char *name,
 	free_iaa_compression_mode(mode);
 	goto out;
 }
-EXPORT_SYMBOL_GPL(add_iaa_compression_mode);
 
 static void free_device_compression_mode(struct iaa_device *iaa_device,
 					 struct iaa_device_compression_mode *device_mode)
-- 
2.27.0


