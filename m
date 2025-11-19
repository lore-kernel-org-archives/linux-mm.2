Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4ACBCF3941
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EAE16B00CD; Wed, 19 Nov 2025 10:45:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29AEC6B00CF; Wed, 19 Nov 2025 10:45:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13CBA6B00D0; Wed, 19 Nov 2025 10:45:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EEAE76B00CD
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:45:58 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF18B16055A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:58 +0000 (UTC)
X-FDA: 84127782396.22.3017325
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id C5EE380009
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=vvkQ50hE;
	spf=pass (imf30.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.51 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CEWvhI86IGkr275YCXI4U9akHZM2f251P0zZm4c5HV0=;
	b=xqIK7PWYq8pbzqC5kGLDvOgMp71U2amFn2Hcn4arHVJkNE7fS90z2DnY/Rv7Rv+3mFwkJc
	LeorChm2fMTFyq3bse1kxqtbOhb7e7vztB5wFVnBxL5S57ubaSvWE2/JHE7qUrq1wYS7rE
	IGrvuuoLNLH1LOEdOWcoAbnF/oGM/JY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=vvkQ50hE;
	spf=pass (imf30.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.51 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567156; a=rsa-sha256;
	cv=none;
	b=E3uxS6d727LoFux4yrLFYO07Uac4ciZsd7Dpxy2Ay9QgFFURUjLpzGvjfpoQNQ3mXVzzdh
	DANzkn1D/NlfEqc4kGERP7egSo8tUX5PjFlCdGVP1UQHjzzdAiZpmBtFWZIOXRGq4syj8E
	0dGbZjUtMdwByXBuoCyn8nUrpCFxLgQ=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4775895d69cso36195405e9.0
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763567155; x=1764171955; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CEWvhI86IGkr275YCXI4U9akHZM2f251P0zZm4c5HV0=;
        b=vvkQ50hEM9o0baJfxgK4MZPVRxkpnfvRTeSidkjtb962ZiokTbN6mnYJa22TC8y/XQ
         ThR1elXqWKquOw8dcfLCO56bFIJmt6QxKTPktcMaB/PcflOSBC9qbD+TmHOy8qu548Xf
         lxUP9IpuNKIXtbyJOhlXdlfEDISFmI+qZwGtY+TygoBQqb40rat/07CzW6D7yQ+OHoEC
         yXomkOg5qKea5R+uPyqOv8d6YdTcfpdbhyKslzQSEmSWbLVoPYqhLQJgV/HRJ5gW+H8P
         8f0U+Lk507p0pAo2GcQqT7TXveI6n6TXXbS6FSAupWEFiKUfdKXIaz0Xz8zBB0y8US7Z
         WWNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567155; x=1764171955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CEWvhI86IGkr275YCXI4U9akHZM2f251P0zZm4c5HV0=;
        b=Cb3Vnt6lbG4H5oclcEYZyUG/cBG2B+4JvaxGO2XNguSo523l/f4keyVU7utddolVuv
         9HU3/wQmxvKoNCOv1q4L0iEkYeEBr5ooJrgtRW8KdG+P4JxXCr2ozQi512+XY3Ff58ye
         Trixn17ChyQw3+Ufuy1B267CCq/bpGKuHQmpt3fi0OORXV85cwJgdr55vTDXt+BYIaLv
         Dnj+IGIt083GimU7RiPqA4sKYoxnVdbQoVIMNMTriJpP/eZ/wzJkBgJHWz1lONchDl7M
         NbeH5Fr9ePsUkTrpWoDJOddkUFNWG1xJyHpQinJsrwifDcuELgeTAnpWHh1Vnm8wII49
         vVTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUhJ7SJ0KiUAashENfQWciedmuih1Da29wAESj7TfZHUvuUmnsF4/7hwBYTuczA62E1/WvHJpQDWA==@kvack.org
X-Gm-Message-State: AOJu0YypTpmpJHhSgnRQtcJ0oLiHJk5QVulwmQPHb2sdVwtIHm5SY6oo
	0ubvpnq/cehnA0T5kyFdLfgEFRpQgErtRD7slGhtaEsuG9PMTj2jj2jS9d+G8vz2CV0=
X-Gm-Gg: ASbGncuVSTN1P1NGoQFftcaTmeWko8Xc7R/kcxA1i+e0XYOJMADPg5syG6XnaOjTqny
	OzFtRaNanFkjFBVXmrNNt8HBwP1e4W26OSKWw87Shrre9gWD+Vf2kO4aRDDVvoQbCuMoS+liphV
	Jj9TewHbBfZJqV98UJwRqhujlD+rbarPRNQZAqZp217pKlYMk/aXQk5dIcY8oYyGLYarITrUst3
	cVNt/ntP42Cj2mrLz5dMAHsC8pelQVOsJEqyl2dQuJ/1DQN5xPvQa0aWTMTRHTy9LFODiIodg2J
	X5GPP2YqVDEc/6noFj3hU59kRyC+alywoYYY1HzVo/cibm9xe0gF3Kl17lauOoIW3wDaZYBSAH+
	PDu6ahJ+K30ulsK4IFwsv4T98+cmhE55mih2XDY0bTbmmefwS5Jxikg0BWqp3nQzHRouHw0cVJR
	jgpBweRhY5CwQG5XPbL6ATNeB9HAjL0X8huzJ883EU
X-Google-Smtp-Source: AGHT+IGkk7cUbQZnXjGag8yPABXUYogSDTvlv9CsdaEjFL1fCOMxhsVRR8P5cnyld7ERa3Ar7rkUkQ==
X-Received: by 2002:a05:6000:22c1:b0:42b:3ab7:b8a4 with SMTP id ffacd0b85a97d-42b5938b4b1mr19940877f8f.33.1763567155275;
        Wed, 19 Nov 2025 07:45:55 -0800 (PST)
Received: from eugen-station.. ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53dea1c9sm38765632f8f.0.2025.11.19.07.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:45:54 -0800 (PST)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com,
	rdunlap@infradead.org,
	corbet@lwn.net,
	david@redhat.com,
	mhocko@suse.com
Cc: tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	jonechou@google.com,
	rostedt@goodmis.org,
	linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-remoteproc@vger.kernel.org,
	linux-arch@vger.kernel.org,
	tony.luck@intel.com,
	kees@kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: [PATCH 22/26] remoteproc: qcom: Extract minidump definitions into a header
Date: Wed, 19 Nov 2025 17:44:23 +0200
Message-ID: <20251119154427.1033475-23-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C5EE380009
X-Stat-Signature: z6sa4hb6u6az4h7ehqi1ttibezfanr6w
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763567156-128710
X-HE-Meta: U2FsdGVkX19AemDnVeQvhLt6763+9sPKREAv8e26l3GWSjkqRNHMvcAm4iyUuP+TDCOIGUskskb+r4GlJAu2GVz///ZyvZ5FGGKsSDJTdJS7jWxay1YwVMvwc3CVicqh5Xo25+eKsJEdTPWgkcKqj0RY4K+WUtu5aCuB1wUO1HNLJGgegpxQ59/q/MhrpYyp+KM3uBbmKDRvmUhtI0VHGxfoz/qLgW/AO+GJmzlFX1L9nBAWsECVAkLYdtxpbPGK8BgwV9T3K6sTvGcHnNszw8oOzNF65IN4gCeN121VnzaXGwcHg8/cQOJw83oHbDbXR8/CE4kq+UoBUdF8f3xj+O96nmqQvGyW+FmB8RPts1IhijzO0DzIFhew2bMAHx5tp1+BIdJSg0z8foWN6qwy35XIG3UuXYawVoDtTBTpKWzct6KAQCC5MtW/QZscFtSzuB908Z22NuHnH6hjuAUIPA4bL6w5uFbvc1tDOQipezvDU6S+CQ/FVUMgIk5qZLs23suT0EuwCt06KGiGKXoqm2dKshdJ+TjnPPoZd7z3woWKfzorfaDMELwyRVA6DYTkr8mm57/OpSwWM8CF5Gfpjb4JlrEFE+RsPIoVFTlEIUiWQM/wKTZMZzY4GIjJ25+flFaztMgPRj2oFPK2wnaZldcQ36S4Ce9xMF0xYG7ld6k34Ut9XHB2sRQ3Cu4e+AsOkg5gAeKCbycAWSmpX67hDWyNP2svLxxsVnbH+oLwS0YmEmKCiUMFwJwmJPzKdtlDqmiV9NH2FJ6ZYH6XQ5u4c+jpdV4i0CnuWjhlUMlZy7IwaRModHgDw/uEgAoP6RlHejEkFpg4/Iw8DnosyyL10+ml1pVSZ+YtbUh0i6EjfQESByQFjU6lUdBhkk+2dvtZO1j1/97oThXnbeI7Q94byKrlotDK92yjkyccwSxnfjzixDf6OOQbfz+w2MK0NGT5orzqDMCH9yMI6IVICpG
 CPSz+YqZ
 ey+NjXeUlzNx7K/ZY+3H0Q8qETJanBbNkp5hjvJX/DiPsZXlKC7pDe50rn2iLOFrd53KuiDfMe7KeodTp5bPI/C8MuwjgfEHnjIZsbu9aftWOONHmwAMFPNQkm7CerVDP6RF1VeG0Dx8yB/Xuq7J3BfHArenJwGIRUtOQJxRMosWAl+LDp+mcYqh+H8AOKPlIhUd2NHLbO31uBoHWUHfi8ZziLdYpi27nYE+p1HS1c8EJcMrKEUzmrzbtjrpxif0eYt8ar2TW8Ku6BIGcum546UwYKpBdMbU15Ml1C1uktOWePx/nelXP8dvJRT0IWCeGkxMkeVVrW/kDxsGHzbH5gPeEwSoQ5+/e/Sngle1lI39FYjR1aZcqLyrEfUOe0zrPOPBcw1i3wArlsPlNI/tvwLnQK74gLhFIRAb1LmJNYdmX+0e6hMjPe2OqGA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the minidump definitions into a header such that the
definitions can be reused by other drivers.
No other change, purely moving the definitions.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 drivers/remoteproc/qcom_common.c  | 56 +------------------------
 include/linux/soc/qcom/minidump.h | 68 +++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+), 55 deletions(-)
 create mode 100644 include/linux/soc/qcom/minidump.h

diff --git a/drivers/remoteproc/qcom_common.c b/drivers/remoteproc/qcom_common.c
index 8c8688f99f0a..4f1c8d005c97 100644
--- a/drivers/remoteproc/qcom_common.c
+++ b/drivers/remoteproc/qcom_common.c
@@ -18,6 +18,7 @@
 #include <linux/rpmsg/qcom_smd.h>
 #include <linux/slab.h>
 #include <linux/soc/qcom/mdt_loader.h>
+#include <linux/soc/qcom/minidump.h>
 #include <linux/soc/qcom/smem.h>
 
 #include "remoteproc_internal.h"
@@ -28,61 +29,6 @@
 #define to_ssr_subdev(d) container_of(d, struct qcom_rproc_ssr, subdev)
 #define to_pdm_subdev(d) container_of(d, struct qcom_rproc_pdm, subdev)
 
-#define MAX_NUM_OF_SS           10
-#define MAX_REGION_NAME_LENGTH  16
-#define SBL_MINIDUMP_SMEM_ID	602
-#define MINIDUMP_REGION_VALID		('V' << 24 | 'A' << 16 | 'L' << 8 | 'I' << 0)
-#define MINIDUMP_SS_ENCR_DONE		('D' << 24 | 'O' << 16 | 'N' << 8 | 'E' << 0)
-#define MINIDUMP_SS_ENABLED		('E' << 24 | 'N' << 16 | 'B' << 8 | 'L' << 0)
-
-/**
- * struct minidump_region - Minidump region
- * @name		: Name of the region to be dumped
- * @seq_num:		: Use to differentiate regions with same name.
- * @valid		: This entry to be dumped (if set to 1)
- * @address		: Physical address of region to be dumped
- * @size		: Size of the region
- */
-struct minidump_region {
-	char	name[MAX_REGION_NAME_LENGTH];
-	__le32	seq_num;
-	__le32	valid;
-	__le64	address;
-	__le64	size;
-};
-
-/**
- * struct minidump_subsystem - Subsystem's SMEM Table of content
- * @status : Subsystem toc init status
- * @enabled : if set to 1, this region would be copied during coredump
- * @encryption_status: Encryption status for this subsystem
- * @encryption_required : Decides to encrypt the subsystem regions or not
- * @region_count : Number of regions added in this subsystem toc
- * @regions_baseptr : regions base pointer of the subsystem
- */
-struct minidump_subsystem {
-	__le32	status;
-	__le32	enabled;
-	__le32	encryption_status;
-	__le32	encryption_required;
-	__le32	region_count;
-	__le64	regions_baseptr;
-};
-
-/**
- * struct minidump_global_toc - Global Table of Content
- * @status : Global Minidump init status
- * @md_revision : Minidump revision
- * @enabled : Minidump enable status
- * @subsystems : Array of subsystems toc
- */
-struct minidump_global_toc {
-	__le32				status;
-	__le32				md_revision;
-	__le32				enabled;
-	struct minidump_subsystem	subsystems[MAX_NUM_OF_SS];
-};
-
 struct qcom_ssr_subsystem {
 	const char *name;
 	struct srcu_notifier_head notifier_list;
diff --git a/include/linux/soc/qcom/minidump.h b/include/linux/soc/qcom/minidump.h
new file mode 100644
index 000000000000..25247a6216e2
--- /dev/null
+++ b/include/linux/soc/qcom/minidump.h
@@ -0,0 +1,68 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Qualcomm Minidump definitions
+ *
+ * Copyright (C) 2016 Linaro Ltd
+ * Copyright (C) 2015 Sony Mobile Communications Inc
+ * Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
+ */
+
+#ifndef __QCOM_MINIDUMP_H__
+#define __QCOM_MINIDUMP_H__
+
+#define MAX_NUM_OF_SS           10
+#define MAX_REGION_NAME_LENGTH  16
+#define SBL_MINIDUMP_SMEM_ID	602
+#define MINIDUMP_REGION_VALID		('V' << 24 | 'A' << 16 | 'L' << 8 | 'I' << 0)
+#define MINIDUMP_SS_ENCR_DONE		('D' << 24 | 'O' << 16 | 'N' << 8 | 'E' << 0)
+#define MINIDUMP_SS_ENABLED		('E' << 24 | 'N' << 16 | 'B' << 8 | 'L' << 0)
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
+ * @md_revision : Minidump revision
+ * @enabled : Minidump enable status
+ * @subsystems : Array of subsystems toc
+ */
+struct minidump_global_toc {
+	__le32				status;
+	__le32				md_revision;
+	__le32				enabled;
+	struct minidump_subsystem	subsystems[MAX_NUM_OF_SS];
+};
+
+#endif
-- 
2.43.0


