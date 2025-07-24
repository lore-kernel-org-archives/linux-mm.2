Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34989C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 622BD6B02CB; Thu, 24 Jul 2025 09:56:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F8826B02CC; Thu, 24 Jul 2025 09:56:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50DB68E007C; Thu, 24 Jul 2025 09:56:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3CBD86B02CB
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1611DB9160
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:30 +0000 (UTC)
X-FDA: 83699308140.18.A20E39B
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1F5521C0003
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=df3wEKx4;
	spf=pass (imf21.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.50 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XAxMtA+w51S3PCwT+VkkNqGhee+g4ma13WDPbYgGlss=;
	b=B9XqSOlPRsvd8tI0013hh066vfZJIEBqbrdUFKgNO8DroROALs0Gys5SSBlGvbCWgOIV3G
	cgEojp+OYpkh5t00cVUvl1QybkylbF0Eh7I5xlIhXcElcSssAKQBmE1BOGW+CCJYKymV0C
	aev5KyXvSiW3FiXgq4oAHAs6d+IHEJ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365388; a=rsa-sha256;
	cv=none;
	b=BdHMJR9QRuKhPBlMeHsPRDNlK+YRBLJPGNE3IZBXcAF/k9Et6Z+OjmeWYnyhSn+Npvm/d4
	qVbwx6++iBR6rfK+w3oc1dHWzmg2LmjEo5zYDYMKFxjdeIg2wKSBWg3h2gQUlpqc+NzGCe
	m8aCKVumYv4qi9Z2Elwh++/7ACieET4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=df3wEKx4;
	spf=pass (imf21.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.50 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3a503d9ef59so670612f8f.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365387; x=1753970187; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAxMtA+w51S3PCwT+VkkNqGhee+g4ma13WDPbYgGlss=;
        b=df3wEKx44p12XW7L6QWLN6gU2axjzTIdErHHA8OzjsC/lnAqj2rlfrLyv6zHWjMO8r
         XMkKAnEcQ4/JtfY2JWvA9NUSUi8OMqrdwpW4n5KYLyWtSE1n+w0AjwZS4rD/mfOyNGgw
         /D4tV7FROM06dUboIuRJPiwQM4yCgaHZkovJOQ/IOnpHJWVKfhuUA72oRzilXcgdAHVc
         eQERrG0X+yxAlXnxasFeuljzq5BuYxPAwVQAgvy63jFdYfKJgZHoZfXo7PLUp6bXrcRQ
         SkJoEm8gyEgbuvCD+F0Hi0aBirHOKvRL9nOznPRpBkPUOrDy/toD1sn6Ex9vP/YobQoz
         3cSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365387; x=1753970187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAxMtA+w51S3PCwT+VkkNqGhee+g4ma13WDPbYgGlss=;
        b=EMA9ZmED8m8oiJE8gr7+12p+5iy/K7T5tB+DkxdLFWg0GAoUQlEALgvWqaNq1qcI8A
         44c+BjNTqVRxYjunBfYSas80opiiRPjyFwZKVJk5g670vF+15atfckhy6W5WCs7kh8cG
         RUUXMFPnvLwQcVoevHvgASRO+7xI60GloRK3BLekulQc8jLNIYmpFicQgh/D4wBgT/vv
         idLF8Sp3ogT4NkiNzM76SPPFtE+VTCrVKSwxR8Wc2RpUdowB0j/bIOuUYjCOwEDknOO8
         cck8xZyAI15HeE0LfpUJIjc1gjD+upwgMXi5wd7WLXo36VHKvUnwtuKbVwh+6kYVfeoi
         A1eg==
X-Forwarded-Encrypted: i=1; AJvYcCVSGGYYp0q9Aj1UW23EVjxl9/rsHWO9G3ob7xFY+D0csWd5BC0905vXRicbEcRBddBmA2RLRDBAzw==@kvack.org
X-Gm-Message-State: AOJu0YzAgzmmfcxiLaCouLlp0Sn8CDIP42ieeduTPgPEtpyx7WBkZELI
	iFs95SalmsRSRyWvm0nXQr6/QFXMNz0Z9OAescOAMg4e8W9p5DZ0eCKCEueuqJmc2ZQ=
X-Gm-Gg: ASbGncuTjtSDCqO8DNrh1LEehaHpb3gHOiIBATBvBKHvVl2IsIsKQZU2jqKj6vNCJsT
	6mwl0Q/5efVMExlMB/5m2OBVI26FYg5yz5CX1ScyhbxkUdsBsgx/Jvy1MoCfciLStkAMuHCfF9h
	e7RA4cYPPHBKAJ/IQf1oCkeJiwxpvvsX2EUfFgywxjiUwgwjyuqBcat9+eXyyvH6iwhShFnSWXg
	kWgsDQvRXAc8dgoqWOYQXgXHTNRHfJh/f9Z3lrtS00SRt5R5JjymOMVAxTn/uHTk2bFhGUalt8s
	2KLybLnMqHkWTickUyIjEP4ghJP2PA157JWyw61yfKyVKje7W85YH5Sb4HNf8wq9pMT16O+bpZp
	NcL3TfE3EcITEYj4lbE+jk5fNqSOBjw2Hbc1y17y5yV9ttLjEx2kXNCHvjPnhvNpfqF/0HjA3/a
	t61TRskAopYFax
X-Google-Smtp-Source: AGHT+IExCYO6BdC37olS+pAbSHh4fE6RM/f8mJb61ZeZpT0dRv6iCU18YgCf/SbYinZayjVuWPfYqw==
X-Received: by 2002:a05:6000:2586:b0:3a6:e6c3:6d95 with SMTP id ffacd0b85a97d-3b768f2681fmr5379673f8f.41.1753365386507;
        Thu, 24 Jul 2025 06:56:26 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:26 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	eugen.hristev@linaro.org,
	corbet@lwn.net,
	mojha@qti.qualcomm.com,
	rostedt@goodmis.org,
	jonechou@google.com,
	tudor.ambarus@linaro.org
Subject: [RFC][PATCH v2 05/29] kmemdump: introduce qcom-minidump backend driver
Date: Thu, 24 Jul 2025 16:54:48 +0300
Message-ID: <20250724135512.518487-6-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1F5521C0003
X-Stat-Signature: miydoysr3qrifq5ukn1difcu6kqb1ypz
X-Rspam-User: 
X-HE-Tag: 1753365387-188371
X-HE-Meta: U2FsdGVkX198jOy/Tk8Dg0z1GQvjviLpB70bkX8dWeQ6MyD9oI2sj7dUozAzFMxVgf2+5oL2xqS9O1NN6wiM+Vw4kJE6gq8YPvk6KbbOAmQhmLMlUDv9aG8uuXDmebRnRhcoDgWQQDB9C7KVn30tZeNyiSPvYbYRj6OQE3vKichv9fJIOFplXEc8tlVILNOgcakgo1T9jRANTbVN1tPjaFV5bGJkntNA63yWpn1QRj/TiqWbFZIHtwOFlw1Dic2vYdKHKYLn5J8sblkgc81lVK9R/LpH5eD75rg9nNowtkWtIDREEAFrUOK2QqJ3jPT0C2AT6nMA1i5UvvlXpSwtJlmuyYa6XOv7j6XIE9MUbhKyZWiNtsnpsCxQJmg5lvvHc4a1spSOh+0dAZ9EauKn3HRtNMN7z2x7Zkzm7vuMfAr2YmqkgFt/PT8a/3iMmRnuvq+v7G603hqWeIYmN+AT3d3Yb7IQXiRnrpu+3XhA3XbTngkc7bHxzEKljUfv+DJwRBuDKm2qyMNl2YD1d9ANAVY6NExUpfWDsWnf70JSyTTKRWeu1kTQ9CLUEdsu6sc6SneOUt899zOx2/dd1ziZNDFjFzN/NLKYajA7f4Tq9GiZpJWKf2ZK8+P76Y+OehVoHzuvf6syOLiKFFsEy7Pyhmt8dWnd5vrOBjEG8ja1SDynnqXCnDKjGAqS3Dy3Dza5p0bG8PK9pFP8k3pNXZqtAe4TCMMTRGQ68nsapdzD0gjr6+Jnb2MDTopys/NqWJVCwl3Ekn7fft0jhb6nW1imzJKyusWK+CJT10zDrDMeV5thN/zWcHcoiaiTU4mRJUA2SqorTi7+uwHOeSc8OxKlWUilpKg3ZjO002+WospkGGBWlygJrYEGx3QOqxH42/SLv5Uq0J4RMhftT7sXr6+npLibk/lca8Bom+/PTJCeMBtKMCUgv8vCMd/DPeONoGigSmEM5FZ31pP583qMoN8
 aDoGYeDw
 EmwaiGg7yZZGg9bKc4h3inGiHZDIV72Cp4I4IFpH40I1uCj1L49bgkvJgKF6MBvr8jvbWBYLEIX1eBJkHtUs+h83laLeix20BcnCTTjkzMsKMRGHOdoNB80ATtHyQb2B0pRnBkJi2JGV5j0wbd2pR4XwQLHDxbG/DyoMQRXA8vmr+kMRX9lqpwZE1ZL2YOk3TKEAN3vFtkJY22ntVb5ppR9G0PGJqWUyto8WhOmW9DVkJMh4yYvg7EcGqzpnq6dYImOLzxFiZTFYUWru8yY/0Nm0sFzll0UkAsZWI2jf2FswYYoknKZGDR4V//AsZ+10aHMCrbs5AdMBJDKHPUeI1gYErdZ3/glDQqmldWmMueKHNvwEIk5yqL27HtqYEMxvwBXWDYWnodZVhvr/4lInIWzAx9ncJfx6WP5uR3+fQsmoit0vz6d+Aly+U0F4YcouqDin+k1tcS0KhPbGnjYbxPgB13Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Qualcomm Minidump is a backend driver for kmemdump.
Regions are being registered into the shared memory on Qualcomm platforms
and into the table of contents.
Further, the firmware can read the table of contents and dump the memory
accordingly.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 MAINTAINERS                   |   5 +
 drivers/debug/Kconfig         |  12 ++
 drivers/debug/Makefile        |   1 +
 drivers/debug/qcom_minidump.c | 353 ++++++++++++++++++++++++++++++++++
 4 files changed, 371 insertions(+)
 create mode 100644 drivers/debug/qcom_minidump.c

diff --git a/MAINTAINERS b/MAINTAINERS
index b43a43b61e19..68797717175c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13625,6 +13625,11 @@ F:	drivers/debug/kmemdump.c
 F:	drivers/debug/kmemdump_coreimage.c
 F:	include/linux/kmemdump.h
 
+KMEMDUMP QCOM MINIDUMP BACKEND DRIVER
+M:	Eugen Hristev <eugen.hristev@linaro.org>
+S:	Maintained
+F:	drivers/debug/qcom_minidump.c
+
 KMEMLEAK
 M:	Catalin Marinas <catalin.marinas@arm.com>
 S:	Maintained
diff --git a/drivers/debug/Kconfig b/drivers/debug/Kconfig
index 903e3e2805b7..d34ceaf99bd8 100644
--- a/drivers/debug/Kconfig
+++ b/drivers/debug/Kconfig
@@ -27,4 +27,16 @@ config KMEMDUMP_COREIMAGE
 	  for debug tools are being registered.
 	  The coredump file can then be loaded into GDB or crash  tool and
 	  further inspected.
+
+config KMEMDUMP_QCOM_MINIDUMP_BACKEND
+	tristate "Qualcomm Minidump kmemdump backend driver"
+	depends on ARCH_QCOM || COMPILE_TEST
+	depends on KMEMDUMP
+	help
+	  Say y here to enable the Qualcomm Minidump kmemdump backend
+	  driver.
+	  With this backend, the registered regions are being linked
+	  into the minidump table of contents. Further on, the firmware
+	  will be able to read the table of contents and extract the
+	  memory regions on case-by-case basis.
 endmenu
diff --git a/drivers/debug/Makefile b/drivers/debug/Makefile
index 2b67673393a6..7f70b84049cb 100644
--- a/drivers/debug/Makefile
+++ b/drivers/debug/Makefile
@@ -2,3 +2,4 @@
 
 obj-$(CONFIG_KMEMDUMP) += kmemdump.o
 obj-$(CONFIG_KMEMDUMP_COREIMAGE) += kmemdump_coreimage.o
+obj-$(CONFIG_KMEMDUMP_QCOM_MINIDUMP_BACKEND) += qcom_minidump.o
diff --git a/drivers/debug/qcom_minidump.c b/drivers/debug/qcom_minidump.c
new file mode 100644
index 000000000000..49b0b6ef193b
--- /dev/null
+++ b/drivers/debug/qcom_minidump.c
@@ -0,0 +1,353 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Qualcomm Minidump backend driver for Kmemdump
+ * Copyright (C) 2016,2024-2025 Linaro Ltd
+ * Copyright (C) 2015 Sony Mobile Communications Inc
+ * Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
+ */
+
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/soc/qcom/smem.h>
+#include <linux/kmemdump.h>
+#include <linux/container_of.h>
+
+/*
+ * In some of the Old Qualcomm devices, boot firmware statically allocates 300
+ * as total number of supported region (including all co-processors) in
+ * minidump table out of which linux was using 201. In future, this limitation
+ * from boot firmware might get removed by allocating the region dynamically.
+ * So, keep it compatible with older devices, we can keep the current limit for
+ * Linux to 201.
+ */
+#define MAX_NUM_REGIONS		201
+
+#define MAX_NUM_SUBSYSTEMS	10
+#define MAX_REGION_NAME_LENGTH	16
+#define SBL_MINIDUMP_SMEM_ID	602
+#define MINIDUMP_REGION_VALID	('V' << 24 | 'A' << 16 | 'L' << 8 | 'I' << 0)
+#define MINIDUMP_SS_ENCR_DONE	('D' << 24 | 'O' << 16 | 'N' << 8 | 'E' << 0)
+#define MINIDUMP_SS_ENABLED	('E' << 24 | 'N' << 16 | 'B' << 8 | 'L' << 0)
+
+#define MINIDUMP_SS_ENCR_NOTREQ	(0 << 24 | 0 << 16 | 'N' << 8 | 'R' << 0)
+
+#define MINIDUMP_SUBSYSTEM_APSS	0
+
+const char *kmemdump_id_to_md_string[] = {
+	"",
+	"ELF",
+	"vmcoreinfo",
+	"config",
+	"memsect",
+	"totalram",
+	"cpu_possible",
+	"cpu_present",
+	"cpu_online",
+	"cpu_active",
+	"jiffies",
+	"linux_banner",
+	"nr_threads",
+	"nr_irqs",
+	"tainted_mask",
+	"taint_flags",
+	"mem_section",
+	"node_data",
+	"node_states",
+	"__per_cpu_offset",
+	"nr_swapfiles",
+	"init_uts_ns",
+	"printk_rb_static",
+	"printk_rb_dynamic",
+	"prb",
+	"prb_descs",
+	"prb_infos",
+	"prb_data",
+	"runqueues",
+	"high_memory",
+	"init_mm",
+	"init_mm_pgd",
+};
+
+/**
+ * struct minidump_region - Minidump region
+ * @name		: Name of the region to be dumped
+ * @seq_num:		: Use to differentiate regions with same name.
+ * @valid		: This entry to be dumped (if set to 1)
+ * @address		: Physical address of region to be dumped
+ * @size		: Size of the region
+ */
+struct minidump_region {
+	char	name[MAX_REGION_NAME_LENGTH];
+	__le32	seq_num;
+	__le32	valid;
+	__le64	address;
+	__le64	size;
+};
+
+/**
+ * struct minidump_subsystem - Subsystem's SMEM Table of content
+ * @status : Subsystem toc init status
+ * @enabled : if set to 1, this region would be copied during coredump
+ * @encryption_status: Encryption status for this subsystem
+ * @encryption_required : Decides to encrypt the subsystem regions or not
+ * @region_count : Number of regions added in this subsystem toc
+ * @regions_baseptr : regions base pointer of the subsystem
+ */
+struct minidump_subsystem {
+	__le32	status;
+	__le32	enabled;
+	__le32	encryption_status;
+	__le32	encryption_required;
+	__le32	region_count;
+	__le64	regions_baseptr;
+};
+
+/**
+ * struct minidump_global_toc - Global Table of Content
+ * @status : Global Minidump init status
+ * @revision : Minidump revision
+ * @enabled : Minidump enable status
+ * @subsystems : Array of subsystems toc
+ */
+struct minidump_global_toc {
+	__le32				status;
+	__le32				revision;
+	__le32				enabled;
+	struct minidump_subsystem	subsystems[MAX_NUM_SUBSYSTEMS];
+};
+
+#define MINIDUMP_MAX_NAME_LENGTH	12
+/**
+ * struct qcom_minidump_region - Minidump region information
+ *
+ * @name:	Minidump region name
+ * @virt_addr:  Virtual address of the entry.
+ * @phys_addr:	Physical address of the entry to dump.
+ * @size:	Number of bytes to dump from @address location,
+ *		and it should be 4 byte aligned.
+ * @id:		Region id.
+ */
+struct qcom_minidump_region {
+	char		name[MINIDUMP_MAX_NAME_LENGTH];
+	void		*virt_addr;
+	phys_addr_t	phys_addr;
+	size_t		size;
+	unsigned int	id;
+};
+
+/**
+ * struct minidump - Minidump driver data information
+ *
+ * @dev:	Minidump device struct.
+ * @toc:	Minidump table of contents subsystem.
+ * @regions:	Minidump regions array.
+ * @md_be:	Minidump backend.
+ */
+struct minidump {
+	struct device			*dev;
+	struct minidump_subsystem	*toc;
+	struct minidump_region		*regions;
+	struct kmemdump_backend		md_be;
+};
+
+static struct minidump *md;
+
+#define be_to_minidump(be) container_of(be, struct minidump, md_be)
+
+/**
+ * qcom_apss_md_table_init() - Initialize the minidump table
+ * @md: minidump data
+ * @mdss_toc: minidump subsystem table of contents
+ *
+ * Return: On success, it returns 0 and negative error value on failure.
+ */
+static int qcom_apss_md_table_init(struct minidump *md,
+				   struct minidump_subsystem *mdss_toc)
+{
+	md->toc = mdss_toc;
+	md->regions = devm_kcalloc(md->dev, MAX_NUM_REGIONS,
+				   sizeof(*md->regions), GFP_KERNEL);
+	if (!md->regions)
+		return -ENOMEM;
+
+	md->toc->regions_baseptr = cpu_to_le64(virt_to_phys(md->regions));
+	md->toc->enabled = cpu_to_le32(MINIDUMP_SS_ENABLED);
+	md->toc->status = cpu_to_le32(1);
+	md->toc->region_count = cpu_to_le32(0);
+
+	/* Tell bootloader not to encrypt the regions of this subsystem */
+	md->toc->encryption_status = cpu_to_le32(MINIDUMP_SS_ENCR_DONE);
+	md->toc->encryption_required = cpu_to_le32(MINIDUMP_SS_ENCR_NOTREQ);
+
+	return 0;
+}
+
+/**
+ * qcom_md_get_region_index() - Lookup minidump region by kmemdump id
+ * @md: minidump data
+ * @id: minidump region id
+ *
+ * Return: On success, it returns the internal region index, on failure,
+ *	returns	negative error value
+ */
+static int qcom_md_get_region_index(struct minidump *md, int id)
+{
+	unsigned int count = le32_to_cpu(md->toc->region_count);
+	unsigned int i;
+
+	for (i = 0; i < count; i++)
+		if (md->regions[i].seq_num == id)
+			return i;
+
+	return -ENOENT;
+}
+
+/**
+ * register_md_region() - Register a new minidump region
+ * @be: kmemdump backend, this should be the minidump backend
+ * @id: unique id to identify the region
+ * @vaddr: virtual memory address of the region start
+ * @size: size of the region
+ *
+ * Return: On success, it returns 0 and negative error value on failure.
+ */
+static int register_md_region(const struct kmemdump_backend *be,
+			      enum kmemdump_uid id, void *vaddr, size_t size)
+{
+	struct minidump *md = be_to_minidump(be);
+	struct minidump_region *mdr;
+	unsigned int num_region, region_cnt;
+	const char *name = "unknown";
+
+	if (!vaddr || !size)
+		return -EINVAL;
+
+	if (id < ARRAY_SIZE(kmemdump_id_to_md_string))
+		name = kmemdump_id_to_md_string[id];
+
+	if (qcom_md_get_region_index(md, id) >= 0) {
+		dev_dbg(md->dev, "%s:%d region is already registered\n",
+			name, id);
+		return -EEXIST;
+	}
+
+	/* Check if there is a room for a new entry */
+	num_region = le32_to_cpu(md->toc->region_count);
+	if (num_region >= MAX_NUM_REGIONS) {
+		dev_err(md->dev, "maximum region limit %u reached\n",
+			num_region);
+		return -ENOSPC;
+	}
+
+	region_cnt = le32_to_cpu(md->toc->region_count);
+	mdr = &md->regions[region_cnt];
+	scnprintf(mdr->name, MAX_REGION_NAME_LENGTH, "K%.8s", name);
+	mdr->seq_num = id;
+	mdr->address = cpu_to_le64(__pa(vaddr));
+	mdr->size = cpu_to_le64(ALIGN(size, 4));
+	mdr->valid = cpu_to_le32(MINIDUMP_REGION_VALID);
+	region_cnt++;
+	md->toc->region_count = cpu_to_le32(region_cnt);
+
+	return 0;
+}
+
+/**
+ * unregister_md_region() - Unregister a previously registered minidump region
+ * @be: pointer to backend
+ * @id: unique id to identify the region
+ *
+ * Return: On success, it returns 0 and negative error value on failure.
+ */
+static int unregister_md_region(const struct kmemdump_backend *be,
+				unsigned int id)
+{
+	struct minidump *md = be_to_minidump(be);
+	struct minidump_region *mdr;
+	unsigned int region_cnt;
+	unsigned int idx;
+
+	idx = qcom_md_get_region_index(md, id);
+	if (idx < 0) {
+		dev_err(md->dev, "%d region is not present\n", id);
+		return idx;
+	}
+
+	mdr = &md->regions[0];
+	region_cnt = le32_to_cpu(md->toc->region_count);
+	/*
+	 * Left shift all the regions exist after this removed region
+	 * index by 1 to fill the gap and zero out the last region
+	 * present at the end.
+	 */
+	memmove(&mdr[idx], &mdr[idx + 1], (region_cnt - idx - 1) * sizeof(*mdr));
+	memset(&mdr[region_cnt - 1], 0, sizeof(*mdr));
+	region_cnt--;
+	md->toc->region_count = cpu_to_le32(region_cnt);
+
+	return 0;
+}
+
+static int qcom_md_probe(struct platform_device *pdev)
+{
+	struct minidump_global_toc *mdgtoc;
+	size_t size;
+	int ret;
+
+	md = kzalloc(sizeof(*md), GFP_KERNEL);
+	if (!md)
+		return -ENOMEM;
+
+	md->dev = &pdev->dev;
+
+	strscpy(md->md_be.name, "qcom_minidump");
+	md->md_be.register_region = register_md_region;
+	md->md_be.unregister_region = unregister_md_region;
+
+	mdgtoc = qcom_smem_get(QCOM_SMEM_HOST_ANY, SBL_MINIDUMP_SMEM_ID, &size);
+	if (IS_ERR(mdgtoc)) {
+		ret = PTR_ERR(mdgtoc);
+		dev_err(md->dev, "Couldn't find minidump smem item %d\n", ret);
+		goto qcom_md_probe_fail;
+	}
+
+	if (size < sizeof(*mdgtoc) || !mdgtoc->status) {
+		dev_err(md->dev, "minidump table is not initialized %d\n", ret);
+		ret = -ENAVAIL;
+		goto qcom_md_probe_fail;
+	}
+
+	ret = qcom_apss_md_table_init(md, &mdgtoc->subsystems[MINIDUMP_SUBSYSTEM_APSS]);
+	if (ret)
+		goto qcom_md_probe_fail;
+
+	return kmemdump_register_backend(&md->md_be);
+
+qcom_md_probe_fail:
+	kfree(md);
+	return ret;
+}
+
+static void qcom_md_remove(struct platform_device *pdev)
+{
+	kfree(md);
+	kmemdump_unregister_backend(&md->md_be);
+}
+
+static struct platform_driver qcom_md_driver = {
+	.probe = qcom_md_probe,
+	.remove = qcom_md_remove,
+	.driver  = {
+		.name = "qcom-minidump",
+	},
+};
+
+module_platform_driver(qcom_md_driver);
+
+MODULE_AUTHOR("Eugen Hristev <eugen.hristev@linaro.org>");
+MODULE_AUTHOR("Mukesh Ojha <quic_mojha@quicinc.com>");
+MODULE_DESCRIPTION("Qualcomm kmemdump minidump backend driver");
+MODULE_LICENSE("GPL");
-- 
2.43.0


