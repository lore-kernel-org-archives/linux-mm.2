Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 967B0C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 04:37:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 903D06B00AC; Fri,  1 Aug 2025 00:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88DC06B00AF; Fri,  1 Aug 2025 00:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B7CD6B00AD; Fri,  1 Aug 2025 00:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 578E96B00AA
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:37:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 219CA114F9A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:37:02 +0000 (UTC)
X-FDA: 83726928684.08.5A78410
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0714A40008
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=oCvxb8Bm;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754023020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4PuaNovjeXJXf7wYS3HUQ0iGH3mWYTZFFxs+y7APhfw=;
	b=4nXOLevg/s6whLwZKI9rUSUYPqpinI7wLDUy9S3iJzVHIRUY0t8fzJ2AUAgZVYihs5CMEi
	XyVGrnjpZYPWHcjfsJjOV6Xr5t21pLj3Z5osznJM+SOrr4xyvQ7Y0SSzTU43E8gevi6r9F
	xoq4T+V6L3NwyQBYOQOKLjmpdBq/Hb8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754023020; a=rsa-sha256;
	cv=none;
	b=LfDffkG8Wgg9mCMWSxt6YCiKBJx6RPEqgIthwlfrUit5pnDWHu5l5KFqF85IPCBKSGHk/e
	jKklBBUKCz0VMBkh7dCm/FZP5RB23iwRQWVZKCWaD3casJPI49zvthdVBiMykga0HrGNHy
	7N59vp7Q3N+IeLAJyiT8BE+3mFRza2I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=oCvxb8Bm;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023020; x=1785559020;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bc9zoKzIVBnGxpwUL5rpg1l1pe/k7F1rcvDEigNKHfQ=;
  b=oCvxb8Bm+kT4Mp10X4bHT0Mi+c2J74yXx95m0EOTalMe68cJpLEHIAMG
   QLWdh59lDT4vWh4lPMUl4nGGlND6YIdxAaA0ST1B95ivMHYl2E5VLQFy0
   TieN0WsJCWm798sCXJOrJJ1am4EqkBW6OLr0xdlzh0ZG/9FMO3OrBT1by
   cEO0YM4Ps5EKBnBpcAnF0bMfXJhXYC+ItZXX7QrhDOeHu+uzrV75CudH/
   xw7LnSlsTywPMernv76ygyfavU2GvbXpSKbfLtJxv3dYQHadyG17TqzC9
   l9ufZr7ydiGZQfahB6pLPryeN48sNB8+BG5DYEoYm+nNHb0whxCdDrhqI
   A==;
X-CSE-ConnectionGUID: gXVGkZkyQ3uSOH92guq5EQ==
X-CSE-MsgGUID: GgGrjDzMTEe08M2zaDukKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820391"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820391"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:47 -0700
X-CSE-ConnectionGUID: o0cLFII2TvernnpSjip6ZQ==
X-CSE-MsgGUID: UqWXAbUASByFcDRRjbcZ0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796301"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:46 -0700
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
Subject: [PATCH v11 19/24] crypto: iaa - IAA acomp_algs register the get_batch_size() interface.
Date: Thu, 31 Jul 2025 21:36:37 -0700
Message-Id: <20250801043642.8103-20-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0714A40008
X-Stat-Signature: kc6cs9ega3wjrapcznepc7je36b7mawa
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754023019-410778
X-HE-Meta: U2FsdGVkX183tafaOpEm0VRk2kd+ZPOB6+glbX5FGdg8TMsoOqteCJOkeOQfZ7Uftn7D6UZGxo55Y0ZYcnPSGm7Q7wBcsuNDaQqbP3jix/NuObExehHgPCY+VMqlbVGaGl1DWFoaC6MMi/GpCDBwqrdQyCkg/lV4qT4YouhXuk2WWyuZbdv0LWfw9JMNSsG6joaCEcPT5TJ7BjIpJPOMGkVELOCfmu4LxTsHTHg2EYzoGnHHNatZAGrZ/bViZbALvfg0V7hfqK/yQXp5DQFH4bzHpafIjRPZffgiC0O0WWYq98flSjqLEXE8sbw8W1FkxeBYrhHNYypNIwkDD99p2Z0wxCKZNsnPRnatKguLmjQCMRpQV3U2pNGr6xY+HFcRiif5UK4BSC+2CYvIVZHC9d+PeKFg9rN4tpwyG8RaulEan+VzfZtzgGC1Wrf7cbrishZsbdSRvOc+0O1f4bEDc2TXnOGim3zOds5Y1RJDVG2wa7Bu3kVPcdn0ocCg27R/YO8HLN21iVElZlAlWVN4vU/f0JZ/4wIXSrc6c3dFUcU41D5eqd3AIZrNg+zEcYVyFhGcbOHMSe0VYbBddNyLyD4thx09ic56nCKaSIqaTrbCfvO/f5FoyrEWxk6wkCd3zKjBGqGpuCS2JsuUZ+FS8vL88lGSH0yD3j22sI3BXEOKUhh86deB2gzD8bYIxVR0lwbWaLZIU1UBromVqnqB1bp58r6V9LVqT6Hjq3aEzN6B1/DlrdtFmx7d2CjgTOMG8ItyPcMsGqXkkYw5+jQYNx8gs7jZMse/jTNaTORFGZufcEZqjbOYSivSorD0fRMO9T9zjkoWwEe87EGvwbziw64ifvISTJTIZpm1mXYwchFJg8EI/ApQdWRmH1IUxRcA0sq/85B9lNmS4Fyl/5VNNupColrPlN9efpv9jbqmd54JTcyNTc+/ePELsptGpc95M2U3LvxPZj+t/75ez3L
 gLz48MKD
 TqBndxbvNdBlOebb4wtpqmI17AYDJI7NCe962xtjq1DbhKrObWFOuGGc+qjvonaaXj4TmOyVR7L81f4GLG7E7VbFToXhDpP/ggPS0nvIKQN19mAGqUnQQw1iEENS/s+0+82k/TzujN20R172wrcFKFRb/fDUFjd1oq88BQl7+13h4wQixgmN360jKrjRV11ZzEctQVJVd2Xy8GqsRiajgwz7eDi0moqJ68bXA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The Fixed ("deflate-iaa") and Dynamic ("deflate-iaa-dynamic") IAA
acomp_algs register an implementation for get_batch_size(). zswap can
query crypto_acomp_batch_size() to get the maximum number of requests
that can be batch [de]compressed. zswap can use the minimum of this, and
any zswap-specific upper limits for batch-size to allocate batching
resources.

This enables zswap to compress/decompress pages in parallel in the IAA
hardware accelerator to improve swapout/swapin performance and memory
savings.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 480e12c1d77a5..b7c6fc334dae7 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -2785,6 +2785,7 @@ static struct acomp_alg iaa_acomp_fixed_deflate = {
 	.init			= iaa_comp_init_fixed,
 	.compress		= iaa_comp_acompress_main,
 	.decompress		= iaa_comp_adecompress_main,
+	.get_batch_size		= iaa_comp_get_max_batch_size,
 	.base			= {
 		.cra_name		= "deflate",
 		.cra_driver_name	= "deflate-iaa",
@@ -2810,6 +2811,7 @@ static struct acomp_alg iaa_acomp_dynamic_deflate = {
 	.init			= iaa_comp_init_dynamic,
 	.compress		= iaa_comp_acompress_main,
 	.decompress		= iaa_comp_adecompress_main,
+	.get_batch_size		= iaa_comp_get_max_batch_size,
 	.base			= {
 		.cra_name		= "deflate",
 		.cra_driver_name	= "deflate-iaa-dynamic",
-- 
2.27.0


