Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09A60CAC5BA
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 03:35:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D953A8E0010; Thu, 25 Sep 2025 23:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD6D88E000E; Thu, 25 Sep 2025 23:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBEE58E0010; Thu, 25 Sep 2025 23:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9CB38E000E
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:35:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7AC001DC2E5
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:15 +0000 (UTC)
X-FDA: 83929985790.30.6E511BB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8EC79A0007
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BPusNP0j;
	spf=pass (imf15.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758857713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k+BfiJ2H7A5Is5FWsU7HDSvLYAxsaJT8kAksoW9rGaQ=;
	b=AuUiUgimWU39MXD3p6q7B0r3xGB6jzPQk7MLife+cKLeiMe46+tAq6tz+UMvKnCFMtn5xl
	OGtjxoCRSUD/hJFKEMqt73reNoPqMU3Yn3Vk761owmXGMppYlZCtJpRdPJR8uq/cg+v5bp
	OICgDl5A+fEB7e+DHTh7ZFKHDfsZAXA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758857713; a=rsa-sha256;
	cv=none;
	b=fh1sB8l7IjP6/JIdSuOBKnp4KERX3cbO1I0A6j7SCRxNeCz8NiWFAG6CEo5sjjMp9FRxBT
	orsbk53MmFYilpskScIn59SHe7nzd9WTs/QWwwQqG0Q5guecBsqhIGeHTMZXztBfZQ6u9l
	5YH/ABdge7MT/Z/JFzzz4J3xyMZjWTg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BPusNP0j;
	spf=pass (imf15.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758857714; x=1790393714;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W86GZRwDZO7beezGCFVV/NiDdvS+RJYh/KFbuBLr8uM=;
  b=BPusNP0jHuwNoJ+mJCvsOK6nWb+x3Vqg/znBxjcjjamxZmBSNz45Pipn
   6Ed0oDmGST7+atoX1PYkE7KsYR7UfOLBsDFpsCfyYtHwv4UHZqyXYzYqP
   E6ESPCiyorFHYqRF1GqP7jw8rOVv1tdBXcnuQ5JyoWlgy5Po9hlafbsuw
   1TBRtyT/kH84jssyJDCKyG1ld336Cpbx21Rzm0OakQYc0RdN6Y+p4fh62
   R++8gGW+wpTCpSarsz0JLkGxEHuxSm8MlC23p82lhoE8ad8emh4ou2oH0
   t7kAznNnG6G9WOQW2WYq4WAu0MMln+4jDbCsGyfgDv9pM72bxHGTZ1GeP
   g==;
X-CSE-ConnectionGUID: uGRB50CcT2me9vdwTkfICA==
X-CSE-MsgGUID: KM5QrxAwTKujG2rFBDpI/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="63819509"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="63819509"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 20:35:05 -0700
X-CSE-ConnectionGUID: C0oLLjWxRGqYnyTAnjQ5wg==
X-CSE-MsgGUID: RG5o64MGTdivpZT0qFXZUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="214636574"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa001.jf.intel.com with ESMTP; 25 Sep 2025 20:35:04 -0700
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
Subject: [PATCH v12 09/23] crypto: iaa - Deprecate exporting add/remove IAA compression modes.
Date: Thu, 25 Sep 2025 20:34:48 -0700
Message-Id: <20250926033502.7486-10-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hb3o1ot7n8gucefo5nazecsrhf6mgd14
X-Rspamd-Queue-Id: 8EC79A0007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758857713-683899
X-HE-Meta: U2FsdGVkX1+Jkh4bP5pZg4NcONBoBaEJgts+KRWS+eMPR95RdBvLoJGMFXyx+p2qRLqC330JiP03/Ikfko9TF/UrES6HTEgS3ZZkSS/unEvr1IGXPpaVN3frU06uYxIocd9Anf1okg76FSTb+cNWaN8F/HBFCVIphPuiFKtKECWqDbm55KTfsTwxEXzKCJ7Jk6XX5uZJW4/YhZ3quG8NaLEYGtC6qqM3Ux3Z2kmkkKl8jEz1ahoo46yyIe3kS+MdRSuyqxeACcA0FzVssdSrjTvGU/7fvle9Q7ZFxJLHWtR9VbyVU1KCg2J6Cskw+utZ8c+1iPEnaI6bbEmsKPolYcmLQjMwej/uDG3Q4O5SABiWLIQVTjtZ4+qLdLoCSoJtdUJbNxXzj9aAcZRNBWrZGSxjNwgurDSWIwQJpQFhO2H14hlt5e5poYitKO381gwhjz/tgeaYa4XMP4HXvJywSqN9E61uDYTwHNiKQXMm5LCSe4d8nT+KPv4O0g7RUSE1XcX2VDncoE6TJblEL1qyGZ9vg9gfkTzMBvOF65Q+gczHLpqfRCq6kzc1Tob7FqWdOlSJ/oJfUt2gNcfGLesVzIWr4BvkWrQU7KKGGDwlAx0DP4hVZvNsfL9YMzFksMpMIsos6ZJP5RTYQp9ZDE/iJYexVGaJ8lJygQVZbxAfxcwk9uVlqVzELKTxrERzLyLJ58Ui1y173fxMJLiOsUqbtZsAhqWVD2o2UqE1EKJPTBQM2rBAbSxyApMd92UyfhXK3pZqP81iOhh2hQtPrFGRAj7YBk1J1osetT1oFUxXdYf53IMEfZthCKYdVNB1mfEPVqzDb4y6uvdASzrIElOEiSC4zmoVh3toQ6Wb5/uQhA7/Kn3HKy6uo40VLFlAGJ4c
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
index cac39b418cf0..dd7c4831e092 100644
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


