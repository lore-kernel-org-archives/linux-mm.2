Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B078E63C85
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 03:36:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F9656B00A1; Sat, 24 Jan 2026 22:35:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B86D6B00A2; Sat, 24 Jan 2026 22:35:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6288A6B00A3; Sat, 24 Jan 2026 22:35:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4643B6B00A1
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 22:35:57 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1BBBD1B01D2
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:35:57 +0000 (UTC)
X-FDA: 84369072354.09.3FD5C6C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0897E140010
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:35:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FsKDj2bp;
	spf=pass (imf23.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769312155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ikZjRnCGDQf2OO/1H0XKXqhRfCUF8rGchlGRRA9b7Oo=;
	b=CSAFOYM2DgRXelVQUVccS8PK2lqWeWeqOkzNB/qPTWR5X75SGDMVcPR70aUf0w68uDdkv7
	IruKX8+7uAKYlXTYuj/baFBUdZmPCifbeYOD+by54fYYbj+Z3TSxP27tsEOqJcFDSzpxKa
	YvhK0sfUmpIYn1v+dKssfBthOcdSvl8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FsKDj2bp;
	spf=pass (imf23.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769312155; a=rsa-sha256;
	cv=none;
	b=ym5LZ0tqgdQT3A76T/ND+MNczQVSSMQiyl6Qb5P9fkQ51nC5FwLyjaN4iQ8lxC8aH+vk4F
	SaavkdAT70FSKQrWgXMFfoTOnUf2j3GM5REKVtYJWZdCWoeGzTZF+5wbJn0HNRCO3j5Yjh
	fdo5SCIw+A41fV2GAc8q2HV2g3a1H4g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312155; x=1800848155;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XyBt7r+Eb/CYW6xzj2tc3tA7d69o/dOC+UBy7xbkrX8=;
  b=FsKDj2bpMgiLpmYbPF1dGzmvOMq7m5jgXb0Cajdp2L1TLFnbMGWmyqDb
   lZFjONgWEkT941pMndLZoD2am1+v9ti/53eP3AIPY7CWlVIQzYNasXMon
   7kXi7yIvRxfXRTOzcNnFOyy2vVeOaz7xyw0hoQZKA27sNZEdxC4ye4+Q9
   pmIoMn6iYK3jidm4Rl+p5bqXb9atT7L1kXmJHIiLEwA1EZ6APSrnLn4o+
   a6Xu/lDDeqviWTobr41Td9WLm4R0q6Uj4H3YHnDbQK1N/wtsLUEdWcqOC
   4PCq77htj/WhL8spC6K6jbQOl9CCJPA1XrAyDXpfBWOx+hTVyRJWEMl9v
   Q==;
X-CSE-ConnectionGUID: W3Jc50oSQfadUK6WwFTlPw==
X-CSE-MsgGUID: K266MBwiTJyW+03j4sKKVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887452"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887452"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:35:53 -0800
X-CSE-ConnectionGUID: 8ztUVJHXT8GZ08qRPJ5kqg==
X-CSE-MsgGUID: t76tzkzVRW2oXqaAnEWu3A==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:35:52 -0800
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
Subject: [PATCH v14 10/26] crypto: iaa - Deprecate exporting add/remove IAA compression modes.
Date: Sat, 24 Jan 2026 19:35:21 -0800
Message-Id: <20260125033537.334628-11-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0897E140010
X-Stat-Signature: bycsu45wr3jaxc338miysjyokgyraiy1
X-Rspam-User: 
X-HE-Tag: 1769312154-688679
X-HE-Meta: U2FsdGVkX19erd1wShWCyY2OSWrYqAqsbgTGEO4tM3ayYmDz8KbXP/lfv/bc0Ihke6x9tDB+GMQiQtJxDRFStpxlLvXHI16YGqh1gDLUyE3mNbBbm8Gw3fkNqg7nQgr7ZN5tppyRQ549a9uFfcpB5yfMGIZ3hXUoCOLGj/SD3K2nLNgsRxtPxjfv8A6ZTCjSQoNE1+GhETbZ77G35SLan4r3Roj9xgmF/oT7CBwEvY5mn/KNWN2R0N3ACMYaiaOJqO0Ah8+r39lg+Sh+Os29QbGPXf9WseJMKWVEo7LC2tNwOWkD24Tqss+kGKA8wbxx/BD/yT4q9f6DGLjokVGw+BA+cZ4Gl5JZnEjw1/a7/fn+mKqb6D/bu0Y5NcBNckZBWqMilziOh9D2hbf02e88Imccx7md5R7D0FxmBtkYsWrP0RTyGV17FTm2w1wAc8/L3mTt+fQETAetXhKUk2hh86fUhhe3uAIx2L3XafeoZwW6+FCiaqdBj0DRUEnc5gZ8OKLEOQaUgr8g9mKJrjExmQTAyd1N5L+ncSq0Vmx0762dRv9ourBx4zGqrBsahH821dATz6/M7YMxBn3V4FTJGaw69qIWozeYAWo1svTGvun68z2znozDshzh+3jHFpJBFDA2O0kjkYkgaDJuuHnciK/G1T/FdFqMWociDcAe6BM9pFKImC+tPQvnoNkLncSdSY5Yb0YOO4lzpAy4MftQTSmzRcYz9Tct/TTGXlJjpew6unTElPGeiYpApXF7xtH9YHOo32JksVEiHMySDMEQ+Pu2yhHDEqK82zyzPwBuw6mIOAHDYq3XRdwe03hdVkU6QTpji+elIWSiUbDewY/JgPxSAarWnwH4H1Xj3rrIJlzdxkFisc/vFbLus4I4dTvaW0Mp3v86Il4iPVr23bQYIs9uo93qJxA1CXhIzhhmLR61NmJlY8fGGDi8zU22otF618ilpxs/Enueqybly6E
 /Bee9aV1
 URLXuJuRNYFPN9V+Qkp/ej9BUtlvr341Qyx7L/L3o0qz+qDTg4G9E/4YmDhYPkaeUFR6soH7WyiFB+T2EyU8tmrZIaeu0XnO+xuYlyAbkaGC9aZEzjuLVWL3x8JIJeQGJ8WgiHk8PaJDNgxUMwst9IGhCHf8KoKWWLJaAv33Q0J7bYTG5uAcQ9jma7Q==
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
index 4b275cc09404..1b44c0524692 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -368,10 +368,6 @@ static void free_iaa_compression_mode(struct iaa_compression_mode *mode)
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
@@ -405,7 +401,6 @@ void remove_iaa_compression_mode(const char *name)
 out:
 	mutex_unlock(&iaa_devices_lock);
 }
-EXPORT_SYMBOL_GPL(remove_iaa_compression_mode);
 
 /**
  * add_iaa_compression_mode - Add an IAA compression mode
@@ -482,7 +477,6 @@ int add_iaa_compression_mode(const char *name,
 	free_iaa_compression_mode(mode);
 	goto out;
 }
-EXPORT_SYMBOL_GPL(add_iaa_compression_mode);
 
 static void free_device_compression_mode(struct iaa_device *iaa_device,
 					 struct iaa_device_compression_mode *device_mode)
-- 
2.27.0


