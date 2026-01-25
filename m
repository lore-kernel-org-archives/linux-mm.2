Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96CDEE63C87
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 03:35:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D42D6B008A; Sat, 24 Jan 2026 22:35:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 029B66B008C; Sat, 24 Jan 2026 22:35:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E44A36B0092; Sat, 24 Jan 2026 22:35:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D30726B008A
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 22:35:47 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7CB4213ACEF
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:35:47 +0000 (UTC)
X-FDA: 84369071934.18.53A8E8B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf29.hostedemail.com (Postfix) with ESMTP id 62A45120003
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:35:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MGWEpS90;
	spf=pass (imf29.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769312145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ss6STDVeMnG9CGAAEMbxa5JHkE9Xg8BppgKou7hNE8E=;
	b=T9wuM+8xg8XQL1dpHxozDWvePxhiMDx8UieoBMT0rn5ZFLvyztridTRhOqNWfZ/fiKY3Dx
	Ul8yaZkeidaiIFHrKlOjoNC9IIq+yTIHhHUoNbiJ7eOch713Uq4n0FsdFFhAgp6fTn1QXE
	K0M/hL7zcUtTU6vaQuVClbdIQgiX1Sc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MGWEpS90;
	spf=pass (imf29.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769312145; a=rsa-sha256;
	cv=none;
	b=KyGHo6Y+VSakNLlpQROyNeDpg7gYWP5JrRYrKi5lZ0uVaUonFAjGOJEfcG087QZ7I8JrZv
	KJtxMG24/kRwmelfG7ePBvmCUDmOCEH6GCVMGFOYweek4OAyGa7aKozvAG+Tlyn/rBk/ik
	2jkehD3I+M853fE/MVxBV4vyI01tQgU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312145; x=1800848145;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HginJqtQSQq0Ia4ge8Ae50CgYR2ju2nDIKlkjuhKBrg=;
  b=MGWEpS90UdzWzm4ECR7UthHrE1M3w2/6y71YQZVYgmvB5bxsxcawuE9n
   8TrL9b77kZTurr9YltFBflWb+UmlU6uHUJ/+wTHe9afNpS1X62DiLMgnJ
   kZcgsE4Jp8Sc/qOZSYDlTYqvf1hdO+Kn72SnzhjxQR6VnWkaTSs5TUm6O
   L5KWmDuG2iwkc0ntyHgzSn5NY7RYvTOhWw4GRK13Q9IdYVW4lx5C5XlPN
   qkzlRvYdpinRGTL6VY2cid1y1ZFYoa9NyF7xL22M5ddQZ98EPAoIlB9e1
   GtLylHoB2JWgD53TxSgk8r+ibBcDoEv5fGxmXqaSLS661hxhj+sqPXh5Z
   g==;
X-CSE-ConnectionGUID: hyIRkCnITSCjVigq3G04Hw==
X-CSE-MsgGUID: UKEfo322SFaHF5pwVlJCwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887320"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887320"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:35:42 -0800
X-CSE-ConnectionGUID: +xXaY1bWTuGRO1KctRHYgg==
X-CSE-MsgGUID: 0fD2i0KTSqutMlXHxVNJRA==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:35:41 -0800
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
Subject: [PATCH v14 02/26] crypto: iaa - Replace sprintf with sysfs_emit in sysfs show functions
Date: Sat, 24 Jan 2026 19:35:13 -0800
Message-Id: <20260125033537.334628-3-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 1ds98gyt4djshbknhzdzohr1tmyhcjd4
X-Rspam-User: 
X-Rspamd-Queue-Id: 62A45120003
X-HE-Tag: 1769312145-383404
X-HE-Meta: U2FsdGVkX1+f3EVW0QcMXsaQYmbOyklZKN/dHvCxUnuGmaD27PEAhB8raDJQkwJ4XrPsZnPzbA0q9UCDDurTPdEHCHKuNvhT80y8DMVfQsBlvrjV2Li5Ye2zKhdRIgHU27LlaKxd8E8M88N7e+ETJzDnHNBq0TPIYCqycVM25ZIk1GWML4T1vAr8AlHLkzCqFwDubitnfYB3HLf4d4fE5+92RrykNqzqd+TsfdxLhm9CigDk/oMt44HHcrrmw97hp5pMuMIBzygk+f+lud/P9oBadNR2+L6YJnHe915rArXoPzlXN7yveTxWFjmDIzvCNoGEutEet8umZt8Oq0ErtXT2n0pHtp8XCUh8/JxN/b/iokKBalgzJZatIcOljM180lAj/9fKDDa5BREQY83qQRMXChtYuXb9R7813jL8wIKYFtGT2faS3OrEC5UrcpyhKeiKhar6u/IEkP8p8EgyMpTflEQhwMrRgq9o4uI7Pf7uBms4S+pbzYVayV7obPCAfjGhwF9ru7EoFHPtVg9pvmsnnh/ce8WBqi9hzioT58ZjOBUiBHC6zJ/c6Z8KYqvdfMPnFCX4LmYwd7c4xRgHKQZIlVIhBEzz5GS9NjnQkz1Wk3u41cBfRb6wD5ME4yguWQAoHJTa/jyaPB/9rW8v1w8YY4bfS7AU7i1mRVHBeCiPFXc+MYe/hXEpqveLpIH7pEiqdQF2GdEHw3BRNRaJgAGjDLwOlIogVlQk7yEP8xKPwuSC6nclADXiTStg+vOPYLpRz8403q+X0MGppbc8HSZ0psFPuh0oz59Tytxce0np1tyf9XvIstrGHJhIemXWHep3WntvsIF1i4MRiIqy8UDRBvTb5S2n3bElfyO02u/iU018J9t5KCImH7A5QPRWXVumtbVrDEiPhaPNDbKGC5iUc1ppjgtD71gZxh4XsQ01bUc2aDyC0s0+ZEmZzZRJwK07cDj8B6EX9bIrHwZ
 uBN5fD5h
 TAwAMqf6UDlP1mc1/KZZ2ovg4nMEo+dzS1cbBOlxdS74SkethpjPo4qQWYrtI3+oHqzvWtymX5RDc3jGRbaQEv8QV+NaZJM6j3kg1Hv4uirlwCxg9WcnD49p4qtKCQ0KUK3UPK/nGc8I3UZKlUaZdLJcrbCN4BPcPZg6AAK4FuUT3zcRXbytfYJYeMV0UQH9j+MzARCtO7lU6qI8YA29U3Uk3oiTIieX6DCpyyuVr2DdWLC/YkimHp4SyMDiLN8OdCpp/LDlFGh95E8UmWz2YzpALrJdEcancly9kXjIQP9lEJ/uk8KVw5jJ7SKI4zADSVZHW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace sprintf() with sysfs_emit() in verify_compress_show() and
sync_mode_show(). sysfs_emit() is preferred to format sysfs output as it
provides better bounds checking.  No functional changes.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Acked-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index e21d5fe9004c..8057e8d1571a 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -5,6 +5,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/sysfs.h>
 #include <linux/device.h>
 #include <linux/iommu.h>
 #include <uapi/linux/idxd.h>
@@ -92,7 +93,7 @@ static bool use_irq;
 
 static ssize_t verify_compress_show(struct device_driver *driver, char *buf)
 {
-	return sprintf(buf, "%d\n", iaa_verify_compress);
+	return sysfs_emit(buf, "%d\n", iaa_verify_compress);
 }
 
 static ssize_t verify_compress_store(struct device_driver *driver,
@@ -150,11 +151,11 @@ static ssize_t sync_mode_show(struct device_driver *driver, char *buf)
 	int ret = 0;
 
 	if (!async_mode && !use_irq)
-		ret = sprintf(buf, "%s\n", "sync");
+		ret = sysfs_emit(buf, "%s\n", "sync");
 	else if (async_mode && !use_irq)
-		ret = sprintf(buf, "%s\n", "async");
+		ret = sysfs_emit(buf, "%s\n", "async");
 	else if (async_mode && use_irq)
-		ret = sprintf(buf, "%s\n", "async_irq");
+		ret = sysfs_emit(buf, "%s\n", "async_irq");
 
 	return ret;
 }
-- 
2.27.0


