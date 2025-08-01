Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACAEFC87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 04:36:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 580E26B0099; Fri,  1 Aug 2025 00:36:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BD036B0098; Fri,  1 Aug 2025 00:36:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35FDE6B0096; Fri,  1 Aug 2025 00:36:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22B4D6B0093
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:36:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C3568114EF1
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:50 +0000 (UTC)
X-FDA: 83726928180.13.4575B22
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf04.hostedemail.com (Postfix) with ESMTP id 97C8B40003
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="c6r/2kY5";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754023008; a=rsa-sha256;
	cv=none;
	b=rH8H7kuftK3RUHkCWI6MbdMZjRZ563+kWaaUYaJDbPimE47Kkym2z0AjOs2/TWKupTqGzW
	0dwSIVGxhfgsL1M39K2DjZFpWdYrrjok0zWhlcnoCl+KfAiy7T2iLRsvdC1fg6SyrcCVwy
	X2T9lUDbolN3+Wo3GyQ4y8SW61dcw6s=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="c6r/2kY5";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754023008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fAQffcty8lXJB5XvEn+1uuAgsotG3mw3XEtPGOkKlNs=;
	b=BSVH4gPIiM+6i/8Lk7zFrvFozdXGXRlHmNoJse5yXdpfuQlBOryJUqm8RET8MnSM6cVqdO
	04iAo741Onrq/61wD11TRfBnXl1grNjZdn49HdJhmh0TMXHudpF/cabdqbRUBc/h47u5A0
	G12+ZHt+VJesUZJnkSlLspBLjt2IRB4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023009; x=1785559009;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CYuNizBLF9iN6xWYMJDtHneeaOOS20GoAAA6zSvZMns=;
  b=c6r/2kY5VcqbRxhP1RA66yJ8c4+hYB/7HR9qDvQOWrzwH7119fmDpVH0
   QI+rIF8BaBfaCbEO9sA9nq5MmVnzGa2pKh/MPznMOKZ4/NJ0+cgSrdUde
   gxfvxADUvrMQUgcV23Ie5qTU/tDFm++790Mbhoz46vBQ4X8GImP073eW2
   x+GNJiobcRUKfR6yDukr+r3dNi0oza7RLDxOMaY2jAWlEVjI9m42iXJeQ
   Eb75cuTGr2yxEaAPoX3L6G3d3kNIX69dHiQYs4Txz5+pFhz7Jt1lwuAcl
   uZAOAo1R4liwZGt9Xj+/N5Gs7e2cCuc5WGrXmx/1guCsXBOPIfF9hpYxV
   A==;
X-CSE-ConnectionGUID: ZRlixWoCSdSENc+s9eOCBw==
X-CSE-MsgGUID: Hy1EekK0TVa7h+5PKj2m1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820141"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820141"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:43 -0700
X-CSE-ConnectionGUID: RX6C/9qIQSSkA4CALe3Cyg==
X-CSE-MsgGUID: wG1x6ZZqTNSOu8H0/jyqZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796222"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:42 -0700
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
Subject: [PATCH v11 01/24] crypto: iaa - Reorganize the iaa_crypto driver code.
Date: Thu, 31 Jul 2025 21:36:19 -0700
Message-Id: <20250801043642.8103-2-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 97C8B40003
X-Stat-Signature: rm3ifjkupb1n4ikwsim5ihtn3r3f3wec
X-HE-Tag: 1754023008-793073
X-HE-Meta: U2FsdGVkX18fQXxvbfTcpbeXB3u4zHeyqRbuRuQJoGtg4AZVELKxY0+C3iO94ZV7l00QjbroTQExTAXlk9iI08HG7xC7ClIT2Xyk3jUC5tHDCELQhyO2VsRTIp4i1bTCEGBDEzf6OWnfCNdpiUHsIdt334k+l2LyrRgDHbOV4fuUNJa5meStlS0nr710ZZJSjDX6l8Ejc/1i8EU2PhugsUTbmX9PhPp7vKbjTcivxMP511FXBfQtvayIQ0L6+pfm/N0LHM2szqLTPSAwcYeLkdPwbGEVLPDQOATApPtK6cqobz4r+3ZfHm4PUJtorls/T9CHWORvMuml/+yzPYKseNb0x1hKgCsaZIIhMZf8CQNl3g7fKScBYcVxv3K1TC+p+DImxE7ET5pf8latRA1ZSEE+zahJKW4pmt0lHdewlbjJDi7uSyXxpX4tmy2vCr4PPV8DQ5zku4rAx0ymDi+VtJkgVZF5WQ6IaVjNLG9Xi5vbXiGAHrXzbc4NARetSmg8l9vfBq12Mwn5g+MdR6/HxapPVGCyRGcmjhH1NwsjIwoNntOwoQ2nDmBHEoDKAYQEJJKFNsogs4b7KqvatmCmheTesSUSGg2dkUFiESrg1eKPwv8AbkoNxKVawN83pJjyK12LL4eIZhRf1eyGyXeYWIl3bzfkTf8hUfE8/Tg/JIiTCwC5sXuJQpkwP3u+AZYX8gRXtcIn3rfEcXbqygw4JsgIM9Tt6tPGM2NrCQ8kz2w3ThT6f35SdWkybym0aRxp6GKPpFzDYHwzueWHLppI06bnFGV8ATLMf2EnV+oDVoM+RFJKTLnM4F4UW2q87JrnGkMePwz3sMh2a02cJH05p+VO2joGQHWVfKxQ91P/Hv2p1PGkRNH1Uo+Hxfjf6YgA7/7bfLNhz5DuAzVB3dRvgIjjvxU4arnForgr07xltQiZvoV1FQMGSalFcSDWPdQXn/v1eFaFHfBtur2ec7+
 zQWS+AL4
 OX5c2bE05qAA6OOzXrLcTsFxoRYcqH3TXTJETAHSa+yiLYm0H0LaBez+tG01F3RUtFAH8dRWDf2If2+nxfYAmIW8gsVkH32J9h2dYUVOnqCGRIegrYwSIRsC4LL3PZMHvqSKJfKbgEW6KqghdApe6BaG3az9MCamahIoVjg7DVZ0VDtH3PWatqkxe+r11YC/SdlbY6UtMcvC8wPBQk/Epln04TZEMaBp6hRzM0/7Bf3fdMqIpKna41J/TMQs3WvgK9Iq5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch merely reorganizes the code in iaa_crypto_main.c, so that
the functions are consolidated into logically related sub-sections of
code, without requiring forward declarations.

This is expected to make the code more maintainable and for it to be
easier to replace functional layers and/or add new features.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 677 +++++++++++----------
 1 file changed, 350 insertions(+), 327 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 23f585219fb4b..760997eee8fe5 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -24,6 +24,10 @@
 
 #define IAA_ALG_PRIORITY               300
 
+/**************************************
+ * Driver internal global variables.
+ **************************************/
+
 /* number of iaa instances probed */
 static unsigned int nr_iaa;
 static unsigned int nr_cpus;
@@ -36,54 +40,6 @@ static unsigned int cpus_per_iaa;
 /* Per-cpu lookup table for balanced wqs */
 static struct wq_table_entry __percpu *wq_table;
 
-static struct idxd_wq *wq_table_next_wq(int cpu)
-{
-	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
-
-	if (++entry->cur_wq >= entry->n_wqs)
-		entry->cur_wq = 0;
-
-	if (!entry->wqs[entry->cur_wq])
-		return NULL;
-
-	pr_debug("%s: returning wq at idx %d (iaa wq %d.%d) from cpu %d\n", __func__,
-		 entry->cur_wq, entry->wqs[entry->cur_wq]->idxd->id,
-		 entry->wqs[entry->cur_wq]->id, cpu);
-
-	return entry->wqs[entry->cur_wq];
-}
-
-static void wq_table_add(int cpu, struct idxd_wq *wq)
-{
-	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
-
-	if (WARN_ON(entry->n_wqs == entry->max_wqs))
-		return;
-
-	entry->wqs[entry->n_wqs++] = wq;
-
-	pr_debug("%s: added iaa wq %d.%d to idx %d of cpu %d\n", __func__,
-		 entry->wqs[entry->n_wqs - 1]->idxd->id,
-		 entry->wqs[entry->n_wqs - 1]->id, entry->n_wqs - 1, cpu);
-}
-
-static void wq_table_free_entry(int cpu)
-{
-	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
-
-	kfree(entry->wqs);
-	memset(entry, 0, sizeof(*entry));
-}
-
-static void wq_table_clear_entry(int cpu)
-{
-	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
-
-	entry->n_wqs = 0;
-	entry->cur_wq = 0;
-	memset(entry->wqs, 0, entry->max_wqs * sizeof(struct idxd_wq *));
-}
-
 LIST_HEAD(iaa_devices);
 DEFINE_MUTEX(iaa_devices_lock);
 
@@ -91,36 +47,11 @@ DEFINE_MUTEX(iaa_devices_lock);
 static bool iaa_crypto_enabled;
 static bool iaa_crypto_registered;
 
+static struct iaa_compression_mode *iaa_compression_modes[IAA_COMP_MODES_MAX];
+
 /* Verify results of IAA compress or not */
 static bool iaa_verify_compress = true;
 
-static ssize_t verify_compress_show(struct device_driver *driver, char *buf)
-{
-	return sprintf(buf, "%d\n", iaa_verify_compress);
-}
-
-static ssize_t verify_compress_store(struct device_driver *driver,
-				     const char *buf, size_t count)
-{
-	int ret = -EBUSY;
-
-	mutex_lock(&iaa_devices_lock);
-
-	if (iaa_crypto_enabled)
-		goto out;
-
-	ret = kstrtobool(buf, &iaa_verify_compress);
-	if (ret)
-		goto out;
-
-	ret = count;
-out:
-	mutex_unlock(&iaa_devices_lock);
-
-	return ret;
-}
-static DRIVER_ATTR_RW(verify_compress);
-
 /*
  * The iaa crypto driver supports three 'sync' methods determining how
  * compressions and decompressions are performed:
@@ -155,6 +86,37 @@ static bool async_mode;
 /* Use interrupts */
 static bool use_irq;
 
+/**************************************************
+ * Driver attributes along with get/set functions.
+ **************************************************/
+
+static ssize_t verify_compress_show(struct device_driver *driver, char *buf)
+{
+	return sprintf(buf, "%d\n", iaa_verify_compress);
+}
+
+static ssize_t verify_compress_store(struct device_driver *driver,
+				     const char *buf, size_t count)
+{
+	int ret = -EBUSY;
+
+	mutex_lock(&iaa_devices_lock);
+
+	if (iaa_crypto_enabled)
+		goto out;
+
+	ret = kstrtobool(buf, &iaa_verify_compress);
+	if (ret)
+		goto out;
+
+	ret = count;
+out:
+	mutex_unlock(&iaa_devices_lock);
+
+	return ret;
+}
+static DRIVER_ATTR_RW(verify_compress);
+
 /**
  * set_iaa_sync_mode - Set IAA sync mode
  * @name: The name of the sync mode
@@ -217,7 +179,9 @@ static ssize_t sync_mode_store(struct device_driver *driver,
 }
 static DRIVER_ATTR_RW(sync_mode);
 
-static struct iaa_compression_mode *iaa_compression_modes[IAA_COMP_MODES_MAX];
+/****************************
+ * Driver compression modes.
+ ****************************/
 
 static int find_empty_iaa_compression_mode(void)
 {
@@ -409,11 +373,6 @@ static void free_device_compression_mode(struct iaa_device *iaa_device,
 						IDXD_OP_FLAG_WR_SRC2_AECS_COMP | \
 						IDXD_OP_FLAG_AECS_RW_TGLS)
 
-static int check_completion(struct device *dev,
-			    struct iax_completion_record *comp,
-			    bool compress,
-			    bool only_once);
-
 static int init_device_compression_mode(struct iaa_device *iaa_device,
 					struct iaa_compression_mode *mode,
 					int idx, struct idxd_wq *wq)
@@ -500,6 +459,11 @@ static void remove_device_compression_modes(struct iaa_device *iaa_device)
 	}
 }
 
+/***********************************************************
+ * Functions for use in crypto probe and remove interfaces:
+ * allocate/init/query/deallocate devices/wqs.
+ ***********************************************************/
+
 static struct iaa_device *iaa_device_alloc(void)
 {
 	struct iaa_device *iaa_device;
@@ -513,18 +477,6 @@ static struct iaa_device *iaa_device_alloc(void)
 	return iaa_device;
 }
 
-static bool iaa_has_wq(struct iaa_device *iaa_device, struct idxd_wq *wq)
-{
-	struct iaa_wq *iaa_wq;
-
-	list_for_each_entry(iaa_wq, &iaa_device->wqs, list) {
-		if (iaa_wq->wq == wq)
-			return true;
-	}
-
-	return false;
-}
-
 static struct iaa_device *add_iaa_device(struct idxd_device *idxd)
 {
 	struct iaa_device *iaa_device;
@@ -560,6 +512,27 @@ static void del_iaa_device(struct iaa_device *iaa_device)
 	nr_iaa--;
 }
 
+static void free_iaa_device(struct iaa_device *iaa_device)
+{
+	if (!iaa_device)
+		return;
+
+	remove_device_compression_modes(iaa_device);
+	kfree(iaa_device);
+}
+
+static bool iaa_has_wq(struct iaa_device *iaa_device, struct idxd_wq *wq)
+{
+	struct iaa_wq *iaa_wq;
+
+	list_for_each_entry(iaa_wq, &iaa_device->wqs, list) {
+		if (iaa_wq->wq == wq)
+			return true;
+	}
+
+	return false;
+}
+
 static int add_iaa_wq(struct iaa_device *iaa_device, struct idxd_wq *wq,
 		      struct iaa_wq **new_wq)
 {
@@ -612,23 +585,23 @@ static void del_iaa_wq(struct iaa_device *iaa_device, struct idxd_wq *wq)
 	}
 }
 
-static void clear_wq_table(void)
+static void remove_iaa_wq(struct idxd_wq *wq)
 {
-	int cpu;
-
-	for (cpu = 0; cpu < nr_cpus; cpu++)
-		wq_table_clear_entry(cpu);
-
-	pr_debug("cleared wq table\n");
-}
+	struct iaa_device *iaa_device;
 
-static void free_iaa_device(struct iaa_device *iaa_device)
-{
-	if (!iaa_device)
-		return;
+	list_for_each_entry(iaa_device, &iaa_devices, list) {
+		if (iaa_has_wq(iaa_device, wq)) {
+			del_iaa_wq(iaa_device, wq);
+			break;
+		}
+	}
 
-	remove_device_compression_modes(iaa_device);
-	kfree(iaa_device);
+	if (nr_iaa) {
+		cpus_per_iaa = (nr_nodes * nr_cpus_per_node) / nr_iaa;
+		if (!cpus_per_iaa)
+			cpus_per_iaa = 1;
+	} else
+		cpus_per_iaa = 1;
 }
 
 static void __free_iaa_wq(struct iaa_wq *iaa_wq)
@@ -655,6 +628,75 @@ static void free_iaa_wq(struct iaa_wq *iaa_wq)
 	idxd_wq_set_private(wq, NULL);
 }
 
+static int save_iaa_wq(struct idxd_wq *wq)
+{
+	struct iaa_device *iaa_device, *found = NULL;
+	struct idxd_device *idxd;
+	struct pci_dev *pdev;
+	struct device *dev;
+	int ret = 0;
+
+	list_for_each_entry(iaa_device, &iaa_devices, list) {
+		if (iaa_device->idxd == wq->idxd) {
+			idxd = iaa_device->idxd;
+			pdev = idxd->pdev;
+			dev = &pdev->dev;
+			/*
+			 * Check to see that we don't already have this wq.
+			 * Shouldn't happen but we don't control probing.
+			 */
+			if (iaa_has_wq(iaa_device, wq)) {
+				dev_dbg(dev, "same wq probed multiple times for iaa_device %p\n",
+					iaa_device);
+				goto out;
+			}
+
+			found = iaa_device;
+
+			ret = add_iaa_wq(iaa_device, wq, NULL);
+			if (ret)
+				goto out;
+
+			break;
+		}
+	}
+
+	if (!found) {
+		struct iaa_device *new_device;
+		struct iaa_wq *new_wq;
+
+		new_device = add_iaa_device(wq->idxd);
+		if (!new_device) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		ret = add_iaa_wq(new_device, wq, &new_wq);
+		if (ret) {
+			del_iaa_device(new_device);
+			free_iaa_device(new_device);
+			goto out;
+		}
+
+		ret = init_iaa_device(new_device, new_wq);
+		if (ret) {
+			del_iaa_wq(new_device, new_wq->wq);
+			del_iaa_device(new_device);
+			free_iaa_wq(new_wq);
+			goto out;
+		}
+	}
+
+	if (WARN_ON(nr_iaa == 0))
+		return -EINVAL;
+
+	cpus_per_iaa = (nr_nodes * nr_cpus_per_node) / nr_iaa;
+	if (!cpus_per_iaa)
+		cpus_per_iaa = 1;
+out:
+	return 0;
+}
+
 static int iaa_wq_get(struct idxd_wq *wq)
 {
 	struct idxd_device *idxd = wq->idxd;
@@ -702,6 +744,37 @@ static int iaa_wq_put(struct idxd_wq *wq)
 	return ret;
 }
 
+/***************************************************************
+ * Mapping IAA devices and wqs to cores with per-cpu wq_tables.
+ ***************************************************************/
+
+static void wq_table_free_entry(int cpu)
+{
+	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
+
+	kfree(entry->wqs);
+	memset(entry, 0, sizeof(*entry));
+}
+
+static void wq_table_clear_entry(int cpu)
+{
+	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
+
+	entry->n_wqs = 0;
+	entry->cur_wq = 0;
+	memset(entry->wqs, 0, entry->max_wqs * sizeof(struct idxd_wq *));
+}
+
+static void clear_wq_table(void)
+{
+	int cpu;
+
+	for (cpu = 0; cpu < nr_cpus; cpu++)
+		wq_table_clear_entry(cpu);
+
+	pr_debug("cleared wq table\n");
+}
+
 static void free_wq_table(void)
 {
 	int cpu;
@@ -739,92 +812,18 @@ static int alloc_wq_table(int max_wqs)
 	return 0;
 }
 
-static int save_iaa_wq(struct idxd_wq *wq)
+static void wq_table_add(int cpu, struct idxd_wq *wq)
 {
-	struct iaa_device *iaa_device, *found = NULL;
-	struct idxd_device *idxd;
-	struct pci_dev *pdev;
-	struct device *dev;
-	int ret = 0;
-
-	list_for_each_entry(iaa_device, &iaa_devices, list) {
-		if (iaa_device->idxd == wq->idxd) {
-			idxd = iaa_device->idxd;
-			pdev = idxd->pdev;
-			dev = &pdev->dev;
-			/*
-			 * Check to see that we don't already have this wq.
-			 * Shouldn't happen but we don't control probing.
-			 */
-			if (iaa_has_wq(iaa_device, wq)) {
-				dev_dbg(dev, "same wq probed multiple times for iaa_device %p\n",
-					iaa_device);
-				goto out;
-			}
-
-			found = iaa_device;
-
-			ret = add_iaa_wq(iaa_device, wq, NULL);
-			if (ret)
-				goto out;
-
-			break;
-		}
-	}
-
-	if (!found) {
-		struct iaa_device *new_device;
-		struct iaa_wq *new_wq;
-
-		new_device = add_iaa_device(wq->idxd);
-		if (!new_device) {
-			ret = -ENOMEM;
-			goto out;
-		}
-
-		ret = add_iaa_wq(new_device, wq, &new_wq);
-		if (ret) {
-			del_iaa_device(new_device);
-			free_iaa_device(new_device);
-			goto out;
-		}
-
-		ret = init_iaa_device(new_device, new_wq);
-		if (ret) {
-			del_iaa_wq(new_device, new_wq->wq);
-			del_iaa_device(new_device);
-			free_iaa_wq(new_wq);
-			goto out;
-		}
-	}
-
-	if (WARN_ON(nr_iaa == 0))
-		return -EINVAL;
-
-	cpus_per_iaa = (nr_nodes * nr_cpus_per_node) / nr_iaa;
-	if (!cpus_per_iaa)
-		cpus_per_iaa = 1;
-out:
-	return 0;
-}
+	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
 
-static void remove_iaa_wq(struct idxd_wq *wq)
-{
-	struct iaa_device *iaa_device;
+	if (WARN_ON(entry->n_wqs == entry->max_wqs))
+		return;
 
-	list_for_each_entry(iaa_device, &iaa_devices, list) {
-		if (iaa_has_wq(iaa_device, wq)) {
-			del_iaa_wq(iaa_device, wq);
-			break;
-		}
-	}
+	entry->wqs[entry->n_wqs++] = wq;
 
-	if (nr_iaa) {
-		cpus_per_iaa = (nr_nodes * nr_cpus_per_node) / nr_iaa;
-		if (!cpus_per_iaa)
-			cpus_per_iaa = 1;
-	} else
-		cpus_per_iaa = 1;
+	pr_debug("%s: added iaa wq %d.%d to idx %d of cpu %d\n", __func__,
+		 entry->wqs[entry->n_wqs - 1]->idxd->id,
+		 entry->wqs[entry->n_wqs - 1]->id, entry->n_wqs - 1, cpu);
 }
 
 static int wq_table_add_wqs(int iaa, int cpu)
@@ -930,6 +929,44 @@ static void rebalance_wq_table(void)
 	pr_debug("could not add any wqs for iaa %d to cpu %d!\n", iaa, cpu);
 }
 
+/***************************************************************
+ * Assign work-queues for driver ops using per-cpu wq_tables.
+ ***************************************************************/
+
+static struct idxd_wq *wq_table_next_wq(int cpu)
+{
+	struct wq_table_entry *entry = per_cpu_ptr(wq_table, cpu);
+
+	if (++entry->cur_wq >= entry->n_wqs)
+		entry->cur_wq = 0;
+
+	if (!entry->wqs[entry->cur_wq])
+		return NULL;
+
+	pr_debug("%s: returning wq at idx %d (iaa wq %d.%d) from cpu %d\n", __func__,
+		 entry->cur_wq, entry->wqs[entry->cur_wq]->idxd->id,
+		 entry->wqs[entry->cur_wq]->id, cpu);
+
+	return entry->wqs[entry->cur_wq];
+}
+
+/*************************************************
+ * Core iaa_crypto compress/decompress functions.
+ *************************************************/
+
+static int deflate_generic_decompress(struct acomp_req *req)
+{
+	ACOMP_FBREQ_ON_STACK(fbreq, req);
+	int ret;
+
+	ret = crypto_acomp_decompress(fbreq);
+	req->dlen = fbreq->dlen;
+
+	update_total_sw_decomp_calls();
+
+	return ret;
+}
+
 static inline int check_completion(struct device *dev,
 				   struct iax_completion_record *comp,
 				   bool compress,
@@ -990,27 +1027,132 @@ static inline int check_completion(struct device *dev,
 	return ret;
 }
 
-static int deflate_generic_decompress(struct acomp_req *req)
+static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
+				struct acomp_req *req,
+				dma_addr_t *src_addr, dma_addr_t *dst_addr)
 {
-	ACOMP_FBREQ_ON_STACK(fbreq, req);
-	int ret;
+	int ret = 0;
+	int nr_sgs;
 
-	ret = crypto_acomp_decompress(fbreq);
-	req->dlen = fbreq->dlen;
+	dma_unmap_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
+	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
 
-	update_total_sw_decomp_calls();
+	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_FROM_DEVICE);
+	if (nr_sgs <= 0 || nr_sgs > 1) {
+		dev_dbg(dev, "verify: couldn't map src sg for iaa device %d,"
+			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
+			iaa_wq->wq->id, ret);
+		ret = -EIO;
+		goto out;
+	}
+	*src_addr = sg_dma_address(req->src);
+	dev_dbg(dev, "verify: dma_map_sg, src_addr %llx, nr_sgs %d, req->src %p,"
+		" req->slen %d, sg_dma_len(sg) %d\n", *src_addr, nr_sgs,
+		req->src, req->slen, sg_dma_len(req->src));
 
+	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_TO_DEVICE);
+	if (nr_sgs <= 0 || nr_sgs > 1) {
+		dev_dbg(dev, "verify: couldn't map dst sg for iaa device %d,"
+			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
+			iaa_wq->wq->id, ret);
+		ret = -EIO;
+		dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_FROM_DEVICE);
+		goto out;
+	}
+	*dst_addr = sg_dma_address(req->dst);
+	dev_dbg(dev, "verify: dma_map_sg, dst_addr %llx, nr_sgs %d, req->dst %p,"
+		" req->dlen %d, sg_dma_len(sg) %d\n", *dst_addr, nr_sgs,
+		req->dst, req->dlen, sg_dma_len(req->dst));
+out:
 	return ret;
 }
 
-static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
-				struct acomp_req *req,
-				dma_addr_t *src_addr, dma_addr_t *dst_addr);
-
 static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 			       struct idxd_wq *wq,
 			       dma_addr_t src_addr, unsigned int slen,
-			       dma_addr_t dst_addr, unsigned int *dlen);
+			       dma_addr_t dst_addr, unsigned int *dlen)
+{
+	struct iaa_device_compression_mode *active_compression_mode;
+	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
+	u32 *compression_crc = acomp_request_ctx(req);
+	struct iaa_device *iaa_device;
+	struct idxd_desc *idxd_desc;
+	struct iax_hw_desc *desc;
+	struct idxd_device *idxd;
+	struct iaa_wq *iaa_wq;
+	struct pci_dev *pdev;
+	struct device *dev;
+	int ret = 0;
+
+	iaa_wq = idxd_wq_get_private(wq);
+	iaa_device = iaa_wq->iaa_device;
+	idxd = iaa_device->idxd;
+	pdev = idxd->pdev;
+	dev = &pdev->dev;
+
+	active_compression_mode = get_iaa_device_compression_mode(iaa_device, ctx->mode);
+
+	idxd_desc = idxd_alloc_desc(wq, IDXD_OP_BLOCK);
+	if (IS_ERR(idxd_desc)) {
+		dev_dbg(dev, "idxd descriptor allocation failed\n");
+		dev_dbg(dev, "iaa compress failed: ret=%ld\n",
+			PTR_ERR(idxd_desc));
+		return PTR_ERR(idxd_desc);
+	}
+	desc = idxd_desc->iax_hw;
+
+	/* Verify (optional) - decompress and check crc, suppress dest write */
+
+	desc->flags = IDXD_OP_FLAG_CRAV | IDXD_OP_FLAG_RCR | IDXD_OP_FLAG_CC;
+	desc->opcode = IAX_OPCODE_DECOMPRESS;
+	desc->decompr_flags = IAA_DECOMP_FLAGS | IAA_DECOMP_SUPPRESS_OUTPUT;
+	desc->priv = 0;
+
+	desc->src1_addr = (u64)dst_addr;
+	desc->src1_size = *dlen;
+	desc->dst_addr = (u64)src_addr;
+	desc->max_dst_size = slen;
+	desc->completion_addr = idxd_desc->compl_dma;
+
+	dev_dbg(dev, "(verify) compression mode %s,"
+		" desc->src1_addr %llx, desc->src1_size %d,"
+		" desc->dst_addr %llx, desc->max_dst_size %d,"
+		" desc->src2_addr %llx, desc->src2_size %d\n",
+		active_compression_mode->name,
+		desc->src1_addr, desc->src1_size, desc->dst_addr,
+		desc->max_dst_size, desc->src2_addr, desc->src2_size);
+
+	ret = idxd_submit_desc(wq, idxd_desc);
+	if (ret) {
+		dev_dbg(dev, "submit_desc (verify) failed ret=%d\n", ret);
+		goto err;
+	}
+
+	ret = check_completion(dev, idxd_desc->iax_completion, false, false);
+	if (ret) {
+		dev_dbg(dev, "(verify) check_completion failed ret=%d\n", ret);
+		goto err;
+	}
+
+	if (*compression_crc != idxd_desc->iax_completion->crc) {
+		ret = -EINVAL;
+		dev_dbg(dev, "(verify) iaa comp/decomp crc mismatch:"
+			" comp=0x%x, decomp=0x%x\n", *compression_crc,
+			idxd_desc->iax_completion->crc);
+		print_hex_dump(KERN_INFO, "cmp-rec: ", DUMP_PREFIX_OFFSET,
+			       8, 1, idxd_desc->iax_completion, 64, 0);
+		goto err;
+	}
+
+	idxd_free_desc(wq, idxd_desc);
+out:
+	return ret;
+err:
+	idxd_free_desc(wq, idxd_desc);
+	dev_dbg(dev, "iaa compress failed: ret=%d\n", ret);
+
+	goto out;
+}
 
 static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 			      enum idxd_complete_type comp_type,
@@ -1226,133 +1368,6 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 	goto out;
 }
 
-static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
-				struct acomp_req *req,
-				dma_addr_t *src_addr, dma_addr_t *dst_addr)
-{
-	int ret = 0;
-	int nr_sgs;
-
-	dma_unmap_sg(dev, req->dst, sg_nents(req->dst), DMA_FROM_DEVICE);
-	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
-
-	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_FROM_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
-		dev_dbg(dev, "verify: couldn't map src sg for iaa device %d,"
-			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
-			iaa_wq->wq->id, ret);
-		ret = -EIO;
-		goto out;
-	}
-	*src_addr = sg_dma_address(req->src);
-	dev_dbg(dev, "verify: dma_map_sg, src_addr %llx, nr_sgs %d, req->src %p,"
-		" req->slen %d, sg_dma_len(sg) %d\n", *src_addr, nr_sgs,
-		req->src, req->slen, sg_dma_len(req->src));
-
-	nr_sgs = dma_map_sg(dev, req->dst, sg_nents(req->dst), DMA_TO_DEVICE);
-	if (nr_sgs <= 0 || nr_sgs > 1) {
-		dev_dbg(dev, "verify: couldn't map dst sg for iaa device %d,"
-			" wq %d: ret=%d\n", iaa_wq->iaa_device->idxd->id,
-			iaa_wq->wq->id, ret);
-		ret = -EIO;
-		dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_FROM_DEVICE);
-		goto out;
-	}
-	*dst_addr = sg_dma_address(req->dst);
-	dev_dbg(dev, "verify: dma_map_sg, dst_addr %llx, nr_sgs %d, req->dst %p,"
-		" req->dlen %d, sg_dma_len(sg) %d\n", *dst_addr, nr_sgs,
-		req->dst, req->dlen, sg_dma_len(req->dst));
-out:
-	return ret;
-}
-
-static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
-			       struct idxd_wq *wq,
-			       dma_addr_t src_addr, unsigned int slen,
-			       dma_addr_t dst_addr, unsigned int *dlen)
-{
-	struct iaa_device_compression_mode *active_compression_mode;
-	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 *compression_crc = acomp_request_ctx(req);
-	struct iaa_device *iaa_device;
-	struct idxd_desc *idxd_desc;
-	struct iax_hw_desc *desc;
-	struct idxd_device *idxd;
-	struct iaa_wq *iaa_wq;
-	struct pci_dev *pdev;
-	struct device *dev;
-	int ret = 0;
-
-	iaa_wq = idxd_wq_get_private(wq);
-	iaa_device = iaa_wq->iaa_device;
-	idxd = iaa_device->idxd;
-	pdev = idxd->pdev;
-	dev = &pdev->dev;
-
-	active_compression_mode = get_iaa_device_compression_mode(iaa_device, ctx->mode);
-
-	idxd_desc = idxd_alloc_desc(wq, IDXD_OP_BLOCK);
-	if (IS_ERR(idxd_desc)) {
-		dev_dbg(dev, "idxd descriptor allocation failed\n");
-		dev_dbg(dev, "iaa compress failed: ret=%ld\n",
-			PTR_ERR(idxd_desc));
-		return PTR_ERR(idxd_desc);
-	}
-	desc = idxd_desc->iax_hw;
-
-	/* Verify (optional) - decompress and check crc, suppress dest write */
-
-	desc->flags = IDXD_OP_FLAG_CRAV | IDXD_OP_FLAG_RCR | IDXD_OP_FLAG_CC;
-	desc->opcode = IAX_OPCODE_DECOMPRESS;
-	desc->decompr_flags = IAA_DECOMP_FLAGS | IAA_DECOMP_SUPPRESS_OUTPUT;
-	desc->priv = 0;
-
-	desc->src1_addr = (u64)dst_addr;
-	desc->src1_size = *dlen;
-	desc->dst_addr = (u64)src_addr;
-	desc->max_dst_size = slen;
-	desc->completion_addr = idxd_desc->compl_dma;
-
-	dev_dbg(dev, "(verify) compression mode %s,"
-		" desc->src1_addr %llx, desc->src1_size %d,"
-		" desc->dst_addr %llx, desc->max_dst_size %d,"
-		" desc->src2_addr %llx, desc->src2_size %d\n",
-		active_compression_mode->name,
-		desc->src1_addr, desc->src1_size, desc->dst_addr,
-		desc->max_dst_size, desc->src2_addr, desc->src2_size);
-
-	ret = idxd_submit_desc(wq, idxd_desc);
-	if (ret) {
-		dev_dbg(dev, "submit_desc (verify) failed ret=%d\n", ret);
-		goto err;
-	}
-
-	ret = check_completion(dev, idxd_desc->iax_completion, false, false);
-	if (ret) {
-		dev_dbg(dev, "(verify) check_completion failed ret=%d\n", ret);
-		goto err;
-	}
-
-	if (*compression_crc != idxd_desc->iax_completion->crc) {
-		ret = -EINVAL;
-		dev_dbg(dev, "(verify) iaa comp/decomp crc mismatch:"
-			" comp=0x%x, decomp=0x%x\n", *compression_crc,
-			idxd_desc->iax_completion->crc);
-		print_hex_dump(KERN_INFO, "cmp-rec: ", DUMP_PREFIX_OFFSET,
-			       8, 1, idxd_desc->iax_completion, 64, 0);
-		goto err;
-	}
-
-	idxd_free_desc(wq, idxd_desc);
-out:
-	return ret;
-err:
-	idxd_free_desc(wq, idxd_desc);
-	dev_dbg(dev, "iaa compress failed: ret=%d\n", ret);
-
-	goto out;
-}
-
 static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 			  struct idxd_wq *wq,
 			  dma_addr_t src_addr, unsigned int slen,
@@ -1662,6 +1677,10 @@ static void compression_ctx_init(struct iaa_compression_ctx *ctx)
 	ctx->use_irq = use_irq;
 }
 
+/*********************************************
+ * Interfaces to crypto_alg and crypto_acomp.
+ *********************************************/
+
 static int iaa_comp_init_fixed(struct crypto_acomp *acomp_tfm)
 {
 	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp_tfm);
@@ -1864,6 +1883,10 @@ static struct idxd_device_driver iaa_crypto_driver = {
 	.desc_complete = iaa_desc_complete,
 };
 
+/********************
+ * Module init/exit.
+ ********************/
+
 static int __init iaa_crypto_init_module(void)
 {
 	int ret = 0;
-- 
2.27.0


