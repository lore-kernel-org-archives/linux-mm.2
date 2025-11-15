Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1A89CEBF88
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 23:34:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E63E58E000B; Sat, 15 Nov 2025 18:34:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E14528E0007; Sat, 15 Nov 2025 18:34:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB4D88E000B; Sat, 15 Nov 2025 18:34:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AF0E18E0007
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 18:34:20 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7880512EED2
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:20 +0000 (UTC)
X-FDA: 84114447480.16.6679FF9
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id 973E4A000E
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Q6g0JddE;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763249658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DsNyMuhtDAQHyD6UHI66GVXsruEvzFMYKhd6mwZ56OI=;
	b=sntKhfPaKDCKnK4FIwJWUk0uWh+Ys1wi3V2aHjBv/sTcl/Mv1NO0EZnJEFHNZK7UAMOxGH
	rrh8UQWNBN49N4KZRodfrgV2QOQ33Fl0YuW9p+xameidHwz09FNGo65t521KiltFZczo8L
	D8YaTxcNKIhvGIwrYZH9FqN8CS1ro0Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763249658; a=rsa-sha256;
	cv=none;
	b=G/T4TdMFP3NC7ZDlbqJ8CZkWZo3uKU4GxCQDMjt6sV51iObbPiiF9wUjHQ+G5r9LDXBb+x
	EEmn8xxfZzSDk93rTJpqjjxpnpSxMu8yfPyq0xAX8EUpic+JS7GPRhyEHAxGSiC4fy+/tV
	K8Y74rm6iE8WK2U9oo2MyNj58g2+2H4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Q6g0JddE;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-787e84ceaf7so35530937b3.2
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 15:34:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763249657; x=1763854457; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DsNyMuhtDAQHyD6UHI66GVXsruEvzFMYKhd6mwZ56OI=;
        b=Q6g0JddEcb/d2U1zR8vrVDCztUWnbggih5JVc/NlblGMokw4cg5Jp4VSJ3PkJ63xQE
         CY+gfOJlfoOB5m48iiBhjZg8YwuO4Im8ftZUGYQzTzquFT2suk99xCOh1RSmn212imxE
         AmHDmMwVg5yEVzJ/rB3c0iSwe0NUoscPBJmD147Sq7DlZcU/nJO388uc9eazMqXjTc18
         aBJJb6VeKS0Z6oyKVYsHfYoQ0Mezo60pBqpRR8J3LR82n9MXJqmjO75hRrR8M+DCVufI
         Xmm0scWSu8L/sdbRS2uxMFlC5dMH+/+0Rknsj6Wvh+S21HcwSmSuC5Hm09l2uvzDq3Sp
         mwQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763249657; x=1763854457;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DsNyMuhtDAQHyD6UHI66GVXsruEvzFMYKhd6mwZ56OI=;
        b=bMBtLouGr/gSJkOdJdsJKhb0tY8TrIgJ0VAEmJ5f97n5SsSIimIqkdCkeJUerZ6tIC
         cXcA/llozsZ5O5D7Puyr5vqUxf3qEBnyTcNymT9k6eNTVpiuQRIZUefeGTt4mn+48woj
         yXWIldxWzjTb6e5dk/yuzfXJgR27OYRDvHjQhxR4hQQ9QLAi+ueLOpoOUDrQJ3md3229
         W/wSRiHWJ6guCsb5K/T9k3SngnznDaaKxnQWbDeJ6HxVtE2qAQ6mxZDpJhiPuuZ6CxNF
         BZeiScgBLKL1+yZM0J1IgSuKEECZ+AwNq+Fn3RrAR6eMOdRM4NHhJXo7KiADn+GkHZRT
         XXGg==
X-Forwarded-Encrypted: i=1; AJvYcCXngSAiG5tWNoiKWqxATjgbua7UBOA7VatDZMC/Nr40Df2t97mbzNKZ82NE/H5ub0TNUoImpDUuHw==@kvack.org
X-Gm-Message-State: AOJu0Ywf4Rm1i2n2O1cNoD8uwnuuVftKVv9w8LxD2v59rbXjGUf4UUsV
	IolOBZWeB9xoTkQRVfPunm13R5PX064xpJ3afbiYVTnqRy6xlJQClf4Xrs9Rn1JNpRs=
X-Gm-Gg: ASbGncvei6E+Nowu3r+SH8tvep8k+akkEv+Ac/eNKwaIfWp/B4Ivu3ETK64NFww08vE
	4L/D4ZccBtNprWgoNUoJN8xMv/MnNypVei8VWMZejyQ21oNM+MelhnfgG0jTzIEO/F4/D6lG/gd
	wKJijfefn2o3vS+TAYg4sSVrZTKHBrV+9Daqfcwro9at0eRIhK7YE8ORcpUI9DEmDgMa4O9KPpU
	mOrxl0roVyM3FvdZ0ttifOYK59pIKyK4eaUxyBO2T+Wu4MYZyEIYfrAeTtzXoNbfd4Cooll5lJH
	8AdXZhAJ5OZEH8FQaS1ThPb/97uxGyT9jkmx/RB+gavBZ0WHpG0p2Akw3BTsjjQoyt9ImZ0vpna
	/bWML8reT5MBuPjcnXCb8jtfZNz4Bb/jiZoOJG8ZjOoLfXk3cwsuDTQIael+iq32ZzfJaZWLJDD
	IuwqIBWwmthj1aAMPaxBddk7A/ReqLI6t+muBfPg0cFeE/V2fRjWjaDsX8VNsfbWTr5Qm0
X-Google-Smtp-Source: AGHT+IHkSgV5Rn6D+sYrviaVQ1zxvVEpwoqTPqlZvJGsTAz/bbXvFVvHMeVFqz6Pbcj3yEwUtgWUWQ==
X-Received: by 2002:a05:690c:c371:b0:788:143:27d9 with SMTP id 00721157ae682-78929eee242mr60220677b3.44.1763249657444;
        Sat, 15 Nov 2025 15:34:17 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7882218774esm28462007b3.57.2025.11.15.15.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 15:34:16 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org
Subject: [PATCH v6 01/20] liveupdate: luo_core: luo_ioctl: Live Update Orchestrator
Date: Sat, 15 Nov 2025 18:33:47 -0500
Message-ID: <20251115233409.768044-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251115233409.768044-1-pasha.tatashin@soleen.com>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8hpnrd1yfi4iumsk6cjx8q3ikktm41yy
X-Rspam-User: 
X-Rspamd-Queue-Id: 973E4A000E
X-Rspamd-Server: rspam10
X-HE-Tag: 1763249658-223017
X-HE-Meta: U2FsdGVkX18VS8YwCj/hsCLR67hZ+RpOHSDMEAuuz26pXh7xZ0Jps/wANzxNYwq74KBwpPBNLBDpY/Mazmo5KJL0wKkItxzy/5u8ByKoM0FmVsWsscmuiG7/pPjm9HFfJIY6WFxHgsPWhL7g1jUKCncd+szsPD7odnk8KFjiZugF6UwV84sVs6QAAD9LLodkNv+LiGkKGX09iCRKZmi+gWxcUUkwTWBSoD1c5b7a0zLhWouRrnhTyR8zfbnntUAK0mbd//GsW39ar4CPsw5TkR7XLX9Keao6YeGNsj3/Vw4yON/+sxvqVh3/JldfmjCTGvbOssWKTiYuRnXYTeKB/eclLT2q7RRBAUYbJg9b8N5GHRx0Cm+Av0uWaqHipsELJrhOVZlY8hzs2ollf2TWb61PTbTWFzfod7ChltN6oJY1XOXpwv2QpjmZUQ6hVpx4mvHCeotAERuXVZEO93ZC/hTWS1AydD8qDqMUb5XroHRRXYJ1lGs4Vmy6WD3P9laXw+lzFsuA/66yHUgmC8X9CLMShE6YyIB3m2O6OYoNVpvuw+omoSsIEDAWlJMGzoNKqP0UxSjvUEPIKs0WmG5X7TWox5VjBUwkYcfFF+Ki7oWi92TkbOvs1bTEwv8bpDRSLzer94KR9R/1+Jkof9fY85oqBAguBlV5zP43FHXkb/O67wPueJSI0OOFUjQoqqR19/FZ9YLWeCGib9jaNzMC7wdIc6hMHuChg8jxejp1C6l/4urynETGlzfd4yuQ2MekRYN0t9m8JSzberCAsoLMj07pFwjxxzcH0N1ttjWkVJhVlPUWHVWn2JHqzzMkSw13I6bF/nf959LMkLuLXOP8dEDvIsTurQ8nSR5h6zp7ypgdaJGYQ8HZvbjJpyIIOKq0c8UUDYXcFuLKl1qosaNah0+6i+Vml8r6KruJumkSM2mVb8D1QLsen0O3Az7RRjb3ouNNNLHuJtMraG6hl3z
 ym5e2R4B
 QxqN05FSE6Tmxqi5k8wdn9zR4m1ecRv6MFivPLtzSH2jXyPLVsH0cdbU1Qzgg5pHSPJt3I/wx442ekV6FiUDx6iBoWDtyNcJtKgppz5N25PzXY71csTvfnlHIYm216QW/JktU85KXEuPQleCkiBB0dYPKSsn7ISk86F1Hq7sE9W+9T5MNtAfezwBqQROryxzU2nJLielgjkCAUZF9a6W60KlueppHA0CN1rlyXtiWD/JS91BKbMsvi3yWmLn6Y+EmP57rt960jURpKhnjYWZtb6pCdnIoo+tk/qi00lnD2x/CSB+0vGdwrz7tVLXpGymAfqdY8o2MsFVT7qYlECxE27c89UKjHf78RlzxfcSldk/aJMZTjalWsaMfdZgUNILljNq4Xncpps36JPt6yYeVxiPqrKbh5/Bi5LS5TsRK3CWzdjg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce LUO, a mechanism intended to facilitate kernel updates while
keeping designated devices operational across the transition (e.g., via
kexec). The primary use case is updating hypervisors with minimal
disruption to running virtual machines. For userspace side of hypervisor
update we have copyless migration. LUO is for updating the kernel.

This initial patch lays the groundwork for the LUO subsystem.

Further functionality, including the implementation of state transition
logic, integration with KHO, and hooks for subsystems and file
descriptors, will be added in subsequent patches.

Create a character device at /dev/liveupdate.

A new uAPI header, <uapi/linux/liveupdate.h>, will define the necessary
structures. The magic number for IOCTL is registered in
Documentation/userspace-api/ioctl/ioctl-number.rst.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 .../userspace-api/ioctl/ioctl-number.rst      |  2 +
 include/linux/liveupdate.h                    | 35 ++++++++
 include/uapi/linux/liveupdate.h               | 46 ++++++++++
 kernel/liveupdate/Kconfig                     | 27 ++++++
 kernel/liveupdate/Makefile                    |  6 ++
 kernel/liveupdate/luo_core.c                  | 86 +++++++++++++++++++
 kernel/liveupdate/luo_ioctl.c                 | 45 ++++++++++
 7 files changed, 247 insertions(+)
 create mode 100644 include/linux/liveupdate.h
 create mode 100644 include/uapi/linux/liveupdate.h
 create mode 100644 kernel/liveupdate/luo_core.c
 create mode 100644 kernel/liveupdate/luo_ioctl.c

diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index 7c527a01d1cf..7232b3544cec 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -385,6 +385,8 @@ Code  Seq#    Include File                                             Comments
 0xB8  01-02  uapi/misc/mrvl_cn10k_dpi.h                                Marvell CN10K DPI driver
 0xB8  all    uapi/linux/mshv.h                                         Microsoft Hyper-V /dev/mshv driver
                                                                        <mailto:linux-hyperv@vger.kernel.org>
+0xBA  00-0F  uapi/linux/liveupdate.h                                   Pasha Tatashin
+                                                                       <mailto:pasha.tatashin@soleen.com>
 0xC0  00-0F  linux/usb/iowarrior.h
 0xCA  00-0F  uapi/misc/cxl.h                                           Dead since 6.15
 0xCA  10-2F  uapi/misc/ocxl.h
diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
new file mode 100644
index 000000000000..730b76625fec
--- /dev/null
+++ b/include/linux/liveupdate.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#ifndef _LINUX_LIVEUPDATE_H
+#define _LINUX_LIVEUPDATE_H
+
+#include <linux/bug.h>
+#include <linux/types.h>
+#include <linux/list.h>
+
+#ifdef CONFIG_LIVEUPDATE
+
+/* Return true if live update orchestrator is enabled */
+bool liveupdate_enabled(void);
+
+/* Called during kexec to tell LUO that entered into reboot */
+int liveupdate_reboot(void);
+
+#else /* CONFIG_LIVEUPDATE */
+
+static inline bool liveupdate_enabled(void)
+{
+	return false;
+}
+
+static inline int liveupdate_reboot(void)
+{
+	return 0;
+}
+
+#endif /* CONFIG_LIVEUPDATE */
+#endif /* _LINUX_LIVEUPDATE_H */
diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
new file mode 100644
index 000000000000..df34c1642c4d
--- /dev/null
+++ b/include/uapi/linux/liveupdate.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+
+/*
+ * Userspace interface for /dev/liveupdate
+ * Live Update Orchestrator
+ *
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#ifndef _UAPI_LIVEUPDATE_H
+#define _UAPI_LIVEUPDATE_H
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+/**
+ * DOC: General ioctl format
+ *
+ * The ioctl interface follows a general format to allow for extensibility. Each
+ * ioctl is passed in a structure pointer as the argument providing the size of
+ * the structure in the first u32. The kernel checks that any structure space
+ * beyond what it understands is 0. This allows userspace to use the backward
+ * compatible portion while consistently using the newer, larger, structures.
+ *
+ * ioctls use a standard meaning for common errnos:
+ *
+ *  - ENOTTY: The IOCTL number itself is not supported at all
+ *  - E2BIG: The IOCTL number is supported, but the provided structure has
+ *    non-zero in a part the kernel does not understand.
+ *  - EOPNOTSUPP: The IOCTL number is supported, and the structure is
+ *    understood, however a known field has a value the kernel does not
+ *    understand or support.
+ *  - EINVAL: Everything about the IOCTL was understood, but a field is not
+ *    correct.
+ *  - ENOENT: A provided token does not exist.
+ *  - ENOMEM: Out of memory.
+ *  - EOVERFLOW: Mathematics overflowed.
+ *
+ * As well as additional errnos, within specific ioctls.
+ */
+
+/* The ioctl type, documented in ioctl-number.rst */
+#define LIVEUPDATE_IOCTL_TYPE		0xBA
+
+#endif /* _UAPI_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index a973a54447de..90857dccb359 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -1,4 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
+#
+# Copyright (c) 2025, Google LLC.
+# Pasha Tatashin <pasha.tatashin@soleen.com>
+#
+# Live Update Orchestrator
+#
 
 menu "Live Update and Kexec HandOver"
 	depends on !DEFERRED_STRUCT_PAGE_INIT
@@ -51,4 +57,25 @@ config KEXEC_HANDOVER_ENABLE_DEFAULT
 	  The default behavior can still be overridden at boot time by
 	  passing 'kho=off'.
 
+config LIVEUPDATE
+	bool "Live Update Orchestrator"
+	depends on KEXEC_HANDOVER
+	help
+	  Enable the Live Update Orchestrator. Live Update is a mechanism,
+	  typically based on kexec, that allows the kernel to be updated
+	  while keeping selected devices operational across the transition.
+	  These devices are intended to be reclaimed by the new kernel and
+	  re-attached to their original workload without requiring a device
+	  reset.
+
+	  Ability to handover a device from current to the next kernel depends
+	  on specific support within device drivers and related kernel
+	  subsystems.
+
+	  This feature primarily targets virtual machine hosts to quickly update
+	  the kernel hypervisor with minimal disruption to the running virtual
+	  machines.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index f52ce1ebcf86..413722002b7a 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -1,5 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0
 
+luo-y :=								\
+		luo_core.o						\
+		luo_ioctl.o
+
 obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)	+= kexec_handover_debugfs.o
+
+obj-$(CONFIG_LIVEUPDATE)		+= luo.o
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
new file mode 100644
index 000000000000..0e1ab19fa1cd
--- /dev/null
+++ b/kernel/liveupdate/luo_core.c
@@ -0,0 +1,86 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+/**
+ * DOC: Live Update Orchestrator (LUO)
+ *
+ * Live Update is a specialized, kexec-based reboot process that allows a
+ * running kernel to be updated from one version to another while preserving
+ * the state of selected resources and keeping designated hardware devices
+ * operational. For these devices, DMA activity may continue throughout the
+ * kernel transition.
+ *
+ * While the primary use case driving this work is supporting live updates of
+ * the Linux kernel when it is used as a hypervisor in cloud environments, the
+ * LUO framework itself is designed to be workload-agnostic. Much like Kernel
+ * Live Patching, which applies security fixes regardless of the workload,
+ * Live Update facilitates a full kernel version upgrade for any type of system.
+ *
+ * For example, a non-hypervisor system running an in-memory cache like
+ * memcached with many gigabytes of data can use LUO. The userspace service
+ * can place its cache into a memfd, have its state preserved by LUO, and
+ * restore it immediately after the kernel kexec.
+ *
+ * Whether the system is running virtual machines, containers, a
+ * high-performance database, or networking services, LUO's primary goal is to
+ * enable a full kernel update by preserving critical userspace state and
+ * keeping essential devices operational.
+ *
+ * The core of LUO is a mechanism that tracks the progress of a live update,
+ * along with a callback API that allows other kernel subsystems to participate
+ * in the process. Example subsystems that can hook into LUO include: kvm,
+ * iommu, interrupts, vfio, participating filesystems, and memory management.
+ *
+ * LUO uses Kexec Handover to transfer memory state from the current kernel to
+ * the next kernel. For more details see
+ * Documentation/core-api/kho/concepts.rst.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/kobject.h>
+#include <linux/liveupdate.h>
+
+static struct {
+	bool enabled;
+} luo_global;
+
+static int __init early_liveupdate_param(char *buf)
+{
+	return kstrtobool(buf, &luo_global.enabled);
+}
+early_param("liveupdate", early_liveupdate_param);
+
+/* Public Functions */
+
+/**
+ * liveupdate_reboot() - Kernel reboot notifier for live update final
+ * serialization.
+ *
+ * This function is invoked directly from the reboot() syscall pathway
+ * if kexec is in progress.
+ *
+ * If any callback fails, this function aborts KHO, undoes the freeze()
+ * callbacks, and returns an error.
+ */
+int liveupdate_reboot(void)
+{
+	return 0;
+}
+
+/**
+ * liveupdate_enabled - Check if the live update feature is enabled.
+ *
+ * This function returns the state of the live update feature flag, which
+ * can be controlled via the ``liveupdate`` kernel command-line parameter.
+ *
+ * @return true if live update is enabled, false otherwise.
+ */
+bool liveupdate_enabled(void)
+{
+	return luo_global.enabled;
+}
diff --git a/kernel/liveupdate/luo_ioctl.c b/kernel/liveupdate/luo_ioctl.c
new file mode 100644
index 000000000000..44d365185f7c
--- /dev/null
+++ b/kernel/liveupdate/luo_ioctl.c
@@ -0,0 +1,45 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#include <linux/liveupdate.h>
+#include <linux/miscdevice.h>
+
+struct luo_device_state {
+	struct miscdevice miscdev;
+};
+
+static const struct file_operations luo_fops = {
+	.owner		= THIS_MODULE,
+};
+
+static struct luo_device_state luo_dev = {
+	.miscdev = {
+		.minor = MISC_DYNAMIC_MINOR,
+		.name  = "liveupdate",
+		.fops  = &luo_fops,
+	},
+};
+
+static int __init liveupdate_ioctl_init(void)
+{
+	if (!liveupdate_enabled())
+		return 0;
+
+	return misc_register(&luo_dev.miscdev);
+}
+module_init(liveupdate_ioctl_init);
+
+static void __exit liveupdate_exit(void)
+{
+	misc_deregister(&luo_dev.miscdev);
+}
+module_exit(liveupdate_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pasha Tatashin");
+MODULE_DESCRIPTION("Live Update Orchestrator");
+MODULE_VERSION("0.1");
-- 
2.52.0.rc1.455.g30608eb744-goog


