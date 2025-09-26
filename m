Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8484CAC5BA
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 03:35:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72DA98E0017; Thu, 25 Sep 2025 23:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DDFD8E0013; Thu, 25 Sep 2025 23:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AE638E0017; Thu, 25 Sep 2025 23:35:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 359D58E0013
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:35:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A8F01DC2E5
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:21 +0000 (UTC)
X-FDA: 83929986042.07.E6A8C76
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf28.hostedemail.com (Postfix) with ESMTP id EF2CBC0004
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Knxes3Ld;
	spf=pass (imf28.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758857719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ARda8hP3cceGELENrFFfq0gkkw4v8WqvDaZnw/4sIH0=;
	b=MdLs4mjRTBZ1geNwQiO/k5qy7QJ/JzwW745G3NdLdeLpktJEIIoArxR3MrMq9za0y8Ze80
	dSzQvUrl0+TXmwc2dSRJfOq1EPIaQ8UoaOH65q/3G6o/FxtXVEsGlXplV4aVwVfm1hGUge
	RkagwSD9aEtzSk9OJa2iz4saNxD4bCE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758857719; a=rsa-sha256;
	cv=none;
	b=mS4IatO270Fqom7GqVcBV1zNP0ElVOTGoI/FI5/bBMNaxXjawcEtxxtwIeGokNrHkvsUq+
	vbM6Z5mfjJqBtadMp2icLmmsUpcqpAzlH4w+hYC+oIY4bHcrRbXxF/38tS/uWjHV9r5FAe
	umeRYxdmOfIDXxzT3VoCju70JmQRfAo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Knxes3Ld;
	spf=pass (imf28.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758857719; x=1790393719;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+uznglJhVLAkGBIwRR16VJzAmGsqt4JlgKBPGDbBxF4=;
  b=Knxes3LdH97otFRCJFgIWrrcgEpyklNtlx1qOi9XKFrhC1EkSSEPNXpq
   8rj+C/T3gWinmwq0FMxd9nkV9FhQwshTnw2bh78s8GMb97CP/ztdwe1Qw
   gsUOgEfB0SVhEv6fEMeOSkClBLf2Ssfwr+Loh2w2CF7VBvvkhTHXBHn+0
   8QiLvVExKD8V44byiyentnEtl7t/aaGocsqQa9DK+csDKMMvUz3kl2s0O
   TwVgl5asnTY5iYGNm3Y89UJ6H5JdjevwHtuA5O4ZIKWlg1Js4YJdDwZOJ
   jhXu9yOWVlTfstxKpfCVGMjyDGEQ9uVz2l6rFaWpkLfAKiaohRut1a+eD
   g==;
X-CSE-ConnectionGUID: 8fhUXdDfR4iVQo3iDspLUg==
X-CSE-MsgGUID: pU/QnDJ/Q4CDanCgSyLpgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="63819600"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="63819600"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 20:35:06 -0700
X-CSE-ConnectionGUID: igqGqvaHSDWQ8xow2+RIQA==
X-CSE-MsgGUID: uN+xYXNsTeCmj2a2HrhHZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="214636595"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa001.jf.intel.com with ESMTP; 25 Sep 2025 20:35:05 -0700
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
Subject: [PATCH v12 15/23] crypto: iaa - Enable async mode and make it the default.
Date: Thu, 25 Sep 2025 20:34:54 -0700
Message-Id: <20250926033502.7486-16-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EF2CBC0004
X-Stat-Signature: m9e3rrfsoen8htkbgmybdywak7gkc7bi
X-Rspam-User: 
X-HE-Tag: 1758857718-176442
X-HE-Meta: U2FsdGVkX19CACEZ1HQ5FQ7i1l3QN3BwB4qf4uTatfP2KQsJOJvIB/jMB3s06WiXk63RhUjapaqYFpXu794i5WGxPSlJMfIjhofW+LBNpIxIbVxGJtTB6ERehb5z/C4fXn+tlyqrVcU7uYVJfwxLa+eKvI8d4jHphKWj5GQA/Uc1zMlVgTpG6AuIBiBivhC1LmP2NGOG8Dh4XB8+m3HtbQFDp5OTzLKuDX+ur1lnIVET3xr/Hj+kjlJOF/fRNi1yMBpVNc9/yQytLKdDVzb4+ICVc+vAe5K7iE0f89Wj5FNhmrd6cufMUNMzJ/wstLQGg8RUZI+3fuEsGqjZtQ2/p7aAAddMkKzrsActrAp3fY+/s74kNgOFiRHk5taUPqStN1J/EOazJ4BkF2oJTpYORBmgZ9Zyu2NY318sT6mU/+6d8VObTcPznKdzSsZlpfvj5FCosD+03UB5+cFuCSUKU9RS5p6P+6XatVvWxGIqisQYy2MkGWoHLkE30cd66pT7XhbwgObANWsEJg0N/ESs/AvgyCLAJHao/7SCjM0U8DFlkltl+NWqmKZm7/wGjr0sC21MzxXRP1catj1emLgQRKVkhF12+wpfaOeUHOx3O7YdmS9SFavXu7odfxmpfNH8/8unP6Hd/bU1JdSvmF53QaUqLh8p34gEbu1fdWcFXtw5480Tfl9nYqKKOAEpYOL+zyYQF9IdpDEm8HKuq9j/aMeoOMaopJKq0kMrkgQlL9ADgAr0avx7et76fY5Jhp3MTAqcXtYZOQq9HelK5aK2csjHa+jjwXH7r8nhD2v1buqol/nQxF42U6V9wzrM8S/cuH9t5cqsQ+WGmqE5NCxQAwSp6njKiA2sNTM3W4FgCWsgR/hvEfEILNd7qou/GgzKsnrunfmSgY5ORfff8qSz5CryLJOtzQ/gBzno1a65it4JuWAGBl/V8R9weVJ07CbmYdq5Ac4Gin1fBR4jELx
 v1zHCQoK
 vHas4mrv8mftl5Ggwy7idTrj7fAtWPgbxEUboYcJgBT4VXAUixjUinxtoBwqxK4SThqss7Xu7u5T5rIiEfZEHFMy+RkcbuLloKPa+xpeKAja52CJbwbQbOe5fFFinthtbFPpDfaQdm1vIGxqlilutiFMiKxvmnoO3RiB2z/yS4Hvz2i40j/YBx61+ow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch enables the 'async' sync_mode in the driver. Further, it sets
the default sync_mode to 'async', which makes it easier for IAA hardware
acceleration in the iaa_crypto driver to be loaded by default in the most
efficient/recommended 'async' mode for parallel
compressions/decompressions, namely, asynchronous submission of
descriptors, followed by polling for job completions. Earlier, the
"sync" mode used to be the default.

The iaa_crypto driver documentation has been updated with these
changes.

This way, anyone who wants to use IAA for zswap/zram can do so after
building the kernel, and without having to go through these steps to use
async mode:

  1) disable all the IAA device/wq bindings that happen at boot time
  2) rmmod iaa_crypto
  3) modprobe iaa_crypto
  4) echo async > /sys/bus/dsa/drivers/crypto/sync_mode
  5) re-run initialization of the IAA devices and wqs

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 Documentation/driver-api/crypto/iaa/iaa-crypto.rst | 11 ++---------
 drivers/crypto/intel/iaa/iaa_crypto_main.c         |  4 ++--
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
index 0ff4ec603b43..d5e610ef4612 100644
--- a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
+++ b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
@@ -272,7 +272,7 @@ The available attributes are:
       echo async_irq > /sys/bus/dsa/drivers/crypto/sync_mode
 
     Async mode without interrupts (caller must poll) can be enabled by
-    writing 'async' to it (please see Caveat)::
+    writing 'async' to it::
 
       echo async > /sys/bus/dsa/drivers/crypto/sync_mode
 
@@ -281,14 +281,7 @@ The available attributes are:
 
       echo sync > /sys/bus/dsa/drivers/crypto/sync_mode
 
-    The default mode is 'sync'.
-
-    Caveat: since the only mechanism that iaa_crypto currently implements
-    for async polling without interrupts is via the 'sync' mode as
-    described earlier, writing 'async' to
-    '/sys/bus/dsa/drivers/crypto/sync_mode' will internally enable the
-    'sync' mode. This is to ensure correct iaa_crypto behavior until true
-    async polling without interrupts is enabled in iaa_crypto.
+    The default mode is 'async'.
 
   - g_comp_wqs_per_iaa
 
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 0a620f2dc58e..c4f40984e9bf 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -152,7 +152,7 @@ static bool iaa_verify_compress = true;
  */
 
 /* Use async mode */
-static bool async_mode;
+static bool async_mode = true;
 /* Use interrupts */
 static bool use_irq;
 
@@ -206,7 +206,7 @@ static int set_iaa_sync_mode(const char *name)
 		async_mode = false;
 		use_irq = false;
 	} else if (sysfs_streq(name, "async")) {
-		async_mode = false;
+		async_mode = true;
 		use_irq = false;
 	} else if (sysfs_streq(name, "async_irq")) {
 		async_mode = true;
-- 
2.27.0


