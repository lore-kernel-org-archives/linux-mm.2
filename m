Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D978C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 04:37:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DCB96B009C; Fri,  1 Aug 2025 00:36:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88C2B6B009E; Fri,  1 Aug 2025 00:36:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A29C6B009F; Fri,  1 Aug 2025 00:36:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 68E226B009C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:36:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 37D401DD88A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:55 +0000 (UTC)
X-FDA: 83726928390.20.7048706
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf04.hostedemail.com (Postfix) with ESMTP id 238D840002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="mq6//Tct";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754023013; a=rsa-sha256;
	cv=none;
	b=I6LNFjt97fMjcIq8U/yOpDPdGRfKXCf2r+etSU6AfPEgQRXS6e1hsSYvd7ZompzQQOj3gw
	7PDRrVbjc8JKGNeZZyYG0p6xfuwWqPA/yoHHywjSllDuJqRM7MejEQguQ5DUO+Kl8TDJPa
	xvZWUmuyIWCTVTczoyHzTQNdESOSadI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="mq6//Tct";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754023013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zxpocc86ChBHMw/TFnJii9cUVfzMBoYsAwlMEmM1mQw=;
	b=0+a+0zkRY57csIqU4KV31lc3Iiowma4V2WZmqOyq8tneGgYEWsl60tQIMKHSNoEA0LQUO2
	yjZDTAK6AwqwiwKMV8FzMC0tFjDd3IqFmThlvdMcf1UzySufDwxjCe0aUHEzcjRpiactuu
	EseLV+G9ErY2iyfXYz6IW0wjjIqF+fs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023013; x=1785559013;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P4JBrgCnTQJ+vJSFYLtwJFoo0LDT4F3zOWbqR1090lo=;
  b=mq6//TctQZW7EflwAUkeqkioYPW7B4MIFe38Vdi7sqH3rBAdNzX3H2WC
   HBh2EqzC5QSNfKXzshDuu8s/2X2mc9lz8REDYY/abUFsyEiQzn1F9nbSj
   CxTtXiL3HrXCCoxDEC8uxhK6+0N0qm1I5JRTJpUC+mtFdW/v418Emwgnj
   hSDfbes9691QSmGG7rR+TvtnGnRA5CG3LL3bbiSnRwvN6pyls1H23Neix
   KsdAjhQ9JovpQ8YGlE1ornoLP0D1FRe+mrEnOKQ6adIPI1DBmW3XbgfJQ
   Qo+urE+D0lZKi0adwu4QRXs4AwqTJuhrUuQVlO2bx0ktDaUCcAQHoXRFF
   g==;
X-CSE-ConnectionGUID: q2gr74ypTXGX6eAnLXj0pQ==
X-CSE-MsgGUID: KEOPnWCzS/ivjhTNfX3hFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820251"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820251"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:45 -0700
X-CSE-ConnectionGUID: jJmM6HxHRhqwTR4OK+OSGQ==
X-CSE-MsgGUID: UR0k20myRdinTdFYmIFb2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796254"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:44 -0700
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
Subject: [PATCH v11 09/24] crypto: iaa - Deprecate exporting add/remove IAA compression modes.
Date: Thu, 31 Jul 2025 21:36:27 -0700
Message-Id: <20250801043642.8103-10-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 238D840002
X-Stat-Signature: 16bhtrtd8kdw86gbxqar5ctfwz5d8t9t
X-HE-Tag: 1754023012-501192
X-HE-Meta: U2FsdGVkX1+M52n5o/eI6Q3CG3BHoPJsQhDSItyeOlhUYI/pdaZjzwrmFQ0k1+XTV1VmsLAoHc093YP3dXKiSMtQk/IiAYTZr+kbSJO/j+08Db0lnhsjNpvm8RcvRU7gMCR92JyEY0cA7/AsDh1WySh6+yDCmrDNpQ+0iA1DiCy43I65Kyfr3Bgvi/NAqHgGbKbzjqRyKHr5X67EpV9YEi/WoNLb0xmI0L9DGICh9So7e6kQ4hKacDjvAlAFJPzjQ6gL5uXKkxQEvlW+i+eUzz8jrZTi+8lv4klM1ZDfejPqqv6uORJlqbs3MRg7bLPxUsgAqpq7LaC/rebA3HIFtERKCx3zo41H/fhUhDzzgRn2miVAHgVOrPa29twfABg08tqNp+SLDkkHzepJlrWumi7hGRAYvhFwEtM+NWzR1Y8QelYj1an1SBPjTJyZqWRoTpQA48NapRle2LR1DpLbOxoV4T9KWSSJ/fe4V0kcMMgq4OH8/63MRR1m1fRxiJSJ1YXpu4vBruHNhwTfDcw4PWuj8Uw2rK1ITdPvU/w8q4I9XYpS3cTs6TqmSgcl9BVLbZNLAYTeuRj63ATmMpgvBOcuRkmVxwBxFJpPvz91mLTkjlsT8/xh7rPezGYMV3xi5De5qwXMvJ09qKMFSmkKL55e+ZQVRo5B3FcP1lvqwQengdHbIeq4txQKJYZNbVD6L/xtlTsIlXSK+5A+iroXzyVSbs2G9+fyJc3L8FpRI1lCqEmhACLfMSBLg4Qi3LwVOympS40pdnUKjFLIfZeNqT5gvvgx1vmHwE2VZKWC7JFjYqxneRWttM0619+VAl58xKPi0KCPHiEsTIlAYH0/tuVh9pyP5QWA8Bz0CtrmCkZslsJQrrGSEJRnzmw0nr2cQiaZa+ZX26rPWm+r9F0szb9dXL2M8wjKXZPquPEBbS0lp8qnXRL4BKXj+ZjHJqbZLwGKp8pNa9JkmMBAUO6
 D9o9TY9H
 iSQdHfcKz9Yw9Moj00rIthea6kLWO7It17MqQBk/L48+50+4rgdLKFZWhesb+b8pNVF/b3rRkyXPY9IOz6h8z/QKoXA2xoEPa51L+RRfkTmcZcgUuLhOx0PnOZp5+r0cEmxBAymCoHvwI1bB8LrRfOsPD79YA6sre7J7dlVJUt0S12sN5lWIQBxRviA==
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
index 63d0cb4015433..182c41816a97c 100644
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


