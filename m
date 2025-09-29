Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3A29CAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:04:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F4378E0019; Sun, 28 Sep 2025 21:04:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02F4C8E0006; Sun, 28 Sep 2025 21:04:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEA578E0019; Sun, 28 Sep 2025 21:04:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C146F8E0006
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:04:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F2261A020E
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:40 +0000 (UTC)
X-FDA: 83940492720.26.225A46D
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf11.hostedemail.com (Postfix) with ESMTP id D3E5240003
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fX3Tk8qS;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SG9/lgBnsjBu7n3rYE1T/HXPjWC8Lull3DU31VlVdZs=;
	b=e9S026Mc+MvR73A3FDfSDRmO/5cYnZmaPoZaz6NFTr9RLMycTjiokfAJGT78++bnnCbCpl
	19RFqApF9+UTOLyR3HJM6thwm5aXHUukjyqmeXwJ+MVZs2+SMMiXHldkAlm52M3PDoaG0h
	yZXxhQEtVY8gZyt0Osw53MPXrF9RuIE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107878; a=rsa-sha256;
	cv=none;
	b=0I6tDvS6LobfS6jSWC7h9yW6pfP//7UyaenDdFAy6oqhRxRqOY45+OGuPlvmCIfTWGqsBg
	l37pl1Lp48/80NSL9twvubXX8bFSeUlNRJilc/oZCUaBEALxW6hQWf6EtYcA+FvuxP7f65
	1b0+CJurnSlcl35ZPHLyerTDpapkHHU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fX3Tk8qS;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4da72b541f8so51428791cf.1
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 18:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759107878; x=1759712678; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SG9/lgBnsjBu7n3rYE1T/HXPjWC8Lull3DU31VlVdZs=;
        b=fX3Tk8qSP+7Klqlwg0qyRHBDh/yjcS9sARjoQrm36FLEG0K+rgBvuqLBSl8JPrHyNK
         vyR4HkEEcxrtuqALf7u7ejGpIT8GED9jVrTyYSFv3pBfy5EawgN30JpdoVoa4JaQYDeA
         pEI068xoKV59z1MPRwUuPjouuS8ZmXU227PMedLzBYFeGrDhRl0qi/mZKM9lc79prNO9
         IqSl8C+d333JY2VmCkZkrRYRT17YhKRIEsgYI4tRGUesDI7TmqC/2HLNrZc6l/Gm+Xcs
         OmA5fl5OHkeVeKiB3146K/Ed6eRCXM2FlUGk0DvTrC4eOPRVa1+tP83sW/EcVsCZCMIp
         P13g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107878; x=1759712678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SG9/lgBnsjBu7n3rYE1T/HXPjWC8Lull3DU31VlVdZs=;
        b=JtgEXZjt4RMAwi1MuXfemkZSVIXaJiFDA6pyuwt+wC+jhYdhJXRy4vDlj7ktLNm+PP
         A7IF42NEm682nz8ug/R/BdRyLMZd/SqJl7TCukIqjHY6TpS9YImsLvg5/Gbcj0s5w6xv
         3FUE0EGyVkItECJ/TgI5Nm9PDEwyshBYbPPUICCzublh+ElK9J0J/NBc9fR3gHdWaP4U
         IX4Sj452RCVvFGf6XW0o7nhF1RfahXUAh0hPUX+IZkd1vCb/5r1SJ9mPtRCmbrgdF++s
         7ol23k2J2Lojn0uy5wdzvKAf/bWRKmwhnt0+QaiItsDddYows0HqArb7nyQY34VxNQYL
         yCpw==
X-Forwarded-Encrypted: i=1; AJvYcCWvdSJAu2l0DEu1sov9Q5Jrk+I50lyw27um7wao8gHcyfh2c9c1cnFn/xqL1tfDYnqViAQh6J1H0g==@kvack.org
X-Gm-Message-State: AOJu0YzbWQ5DstkwVE1MKUUF/0oHso4xGxzZptXCbELjTKlZ66tjqmsr
	xpUUmuw7iIVWPO4O4TTAQHtqPKyJAfV+emEadK32PH3nfCcXzB2obRLZ0y0stmRSg6g=
X-Gm-Gg: ASbGncsMgoRSoBXhrua5F5Fe7GPBnKlbLhZ2SWL8ZXio0vsCCeFO+9Ap/EdNY/TzIpT
	IIVDDbFnH0UKumt1FGhuO0EyoEqti0F7WK3M1aaNh5p6GUdSGzNPCmgoqAQ5LFNYuxRyx+NLAl4
	eh8rtCAjH/Sly2/6wP2LcxfQBSvGV15MK+sbRWrQCRacC78SiTDBfyJtBiuLbOYvCPI0cdhmBrj
	4Mzqxi92tvJwczXOAXzNL6APR0kHxfvkX6LKNP3TFbiWHFmiDHbBrIFnW1EamY8P6/3tFoDRNUn
	2Gjlp7l8d/S0XbSQvVTysrYSKaiB84Miv+9gd0rD1Ew0Us16o+EKJqujXouh1b3iFXeMfI5QRxr
	gsvsaGk3QABUOMMNXigZdWlxtd2A2zEEnQhLdSLvOSiPH4BKbz4TlXi06um6yQTa9x+R346raQo
	3phorN9qw=
X-Google-Smtp-Source: AGHT+IFBSJGsiJuTnL3aTk6ORRLg5HvmtexVkNoDC0xgqOUWiBHy/Femj87R1xZ3CMujKVmOA+t67A==
X-Received: by 2002:ac8:7e89:0:b0:4dd:c935:93cc with SMTP id d75a77b69052e-4ddc944e0d0mr126398441cf.84.1759107877691;
        Sun, 28 Sep 2025 18:04:37 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0c0fbe63sm64561521cf.23.2025.09.28.18.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 18:04:37 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
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
	zhangguopeng@kylinos.cn,
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
	chrisl@kernel.org,
	steven.sistare@oracle.com
Subject: [PATCH v4 17/30] liveupdate: add selftests for subsystems un/registration
Date: Mon, 29 Sep 2025 01:03:08 +0000
Message-ID: <20250929010321.3462457-18-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D3E5240003
X-Stat-Signature: p5xmsrex699e45np679xpjreozrtiwjy
X-Rspam-User: 
X-HE-Tag: 1759107878-500073
X-HE-Meta: U2FsdGVkX18XJ3ZqnDTUv03x3zOCA0PT8kIam73YS6FyHu0jfhFSd8muUbfy0nXlbNFNE+sAzdn5452a5ReP6EzLcHNHbOwAFn95+DDWf9otZCzPQp10y+cloARowySUCUIjwcG/1D4UkvKqGRQIP02ZwxrmD0SMxZZTxdLbRnA+i9P+8BJjxx1urEN/iSZlWQJbnVENs66Ex6xQATd6PGWL65PlpKi4wCvFzlV1nQcXCUo7xHfskkKMhFcdF754T+cqV1BgQ+FzKyFkwqHicIG/E2o+DyLbLVzB8U+BPbPCSTK6y/XitK49d3NqACeeIGqX4J4o/5pXIROMerV12Ib2fX6Vz3P4sT0if3Vq/mdrPjm4trqTuQvBe1f1yadEJg+o0jObZYhXe/LjV47ep1yIvwR+1XpX0voFTkEW3KRU3RHAV9xIFcGnengQx6ehGOSsnpaoyUVm2t2ArtaHxeosXlCfpF+j6o2pcVumbspQJULC5u1/xI76U7uE5JC9vIp3pDG7C1VRqOX1sl+L+zWrNMfoKrSSnlQX8xIKh53ifyuVglqqxnOFDj6MBNhg1LJN431lh+ftlJIK+w6j0OhwpMjms29ZBg2zvk+xrvkf03tOONhBZJiAupSRGx/YYIzrWPq70P6h51M8psBtsr1DUSZ69TiVe+OnvKZ9wQkQovMnmpLb4B3DHiyN1/El/ss2kcFuGI3Cqvl8mVuH4voYv4SjxcopbXHNctZM8JAyIcoAy2u3VldeqxTpiclNDTRriDA5Us/OBR82OaB7NEe50gtKXZYWeTcAI5wa+ZiqfIg0ovt8bCamHohaTpKwvpbfF8aXKQ2DkLiMQ5afjUndbF7hwI+5Jwn3amefMYKzE0tVZ/glYazm3+lMxMC2TC2KTvj9fYBzwySNe8L/ixdIJC/xMy0TO9mpoXKg+HhrCVRyqFEnRzEs7CkqkHDDh0aunRWSOo62t2qsMtL
 ++xutD+e
 tr29rhCJCiVhKRV2P659NlLDG0QrnOuDa/wsajt+GVa6frtXDHvjn1zFuqNDhBHDRId+8IGjYA1fWyN/w2KW2dlmxqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a self-test mechanism for the LUO to allow verification of
core subsystem management functionality. This is primarily intended
for developers and system integrators validating the live update
feature.

The tests are enabled via the new Kconfig option
CONFIG_LIVEUPDATE_SELFTESTS (default 'n') and are triggered through
a new ioctl command, LIVEUPDATE_IOCTL_SELFTESTS, added to the
/dev/liveupdate device node.

This ioctl accepts commands defined in luo_selftests.h to:
- LUO_CMD_SUBSYSTEM_REGISTER: Creates and registers a dummy LUO
  subsystem using the liveupdate_register_subsystem() function. It
  allocates a data page and copies initial data from userspace.
- LUO_CMD_SUBSYSTEM_UNREGISTER: Unregisters the specified dummy
  subsystem using the liveupdate_unregister_subsystem() function and
  cleans up associated test resources.
- LUO_CMD_SUBSYSTEM_GETDATA: Copies the data page associated with a
  registered test subsystem back to userspace, allowing verification of
  data potentially modified or preserved by test callbacks.

This provides a way to test the fundamental registration and
unregistration flows within the LUO framework from userspace without
requiring a full live update sequence.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/Kconfig         |  15 ++
 kernel/liveupdate/Makefile        |   1 +
 kernel/liveupdate/luo_selftests.c | 345 ++++++++++++++++++++++++++++++
 kernel/liveupdate/luo_selftests.h |  84 ++++++++
 4 files changed, 445 insertions(+)
 create mode 100644 kernel/liveupdate/luo_selftests.c
 create mode 100644 kernel/liveupdate/luo_selftests.h

diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index f6b0bde188d9..8311c2593d32 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -29,6 +29,21 @@ config LIVEUPDATE
 
 	  If unsure, say N.
 
+config LIVEUPDATE_SELFTESTS
+	bool "Live Update Orchestrator - self-tests"
+	depends on LIVEUPDATE
+	help
+	  Say Y here to build self-tests for the LUO framework. When enabled,
+	  these tests can be initiated via the ioctl interface to help verify
+	  the core live update functionality.
+
+	  This option is primarily intended for developers working on the
+	  live update feature or for validation purposes during system
+	  integration.
+
+	  If you are unsure or are building a production kernel where size
+	  or attack surface is a concern, say N.
+
 config KEXEC_HANDOVER
 	bool "kexec handover"
 	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index 282d36a18993..2df7dfdf45c1 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
 
 obj-$(CONFIG_LIVEUPDATE)		+= luo.o
+obj-$(CONFIG_LIVEUPDATE_SELFTESTS)	+= luo_selftests.o
diff --git a/kernel/liveupdate/luo_selftests.c b/kernel/liveupdate/luo_selftests.c
new file mode 100644
index 000000000000..a476b88468fa
--- /dev/null
+++ b/kernel/liveupdate/luo_selftests.c
@@ -0,0 +1,345 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+/**
+ * DOC: LUO Selftests
+ *
+ * We provide ioctl-based selftest interface for the LUO. It provides a
+ * mechanism to test core LUO functionality, particularly the registration,
+ * unregistration, and data handling aspects of LUO subsystems, without
+ * requiring a full live update event sequence.
+ *
+ * The tests are intended primarily for developers working on the LUO framework
+ * or for validation purposes during system integration. This functionality is
+ * conditionally compiled based on the `CONFIG_LIVEUPDATE_SELFTESTS` Kconfig
+ * option and should typically be disabled in production kernels.
+ *
+ * Interface:
+ * The selftests are accessed via the `/dev/liveupdate` character device using
+ * the `LIVEUPDATE_IOCTL_SELFTESTS` ioctl command. The argument to the ioctl
+ * is a pointer to a `struct liveupdate_selftest` structure (defined in
+ * `uapi/linux/liveupdate.h`), which contains:
+ * - `cmd`: The specific selftest command to execute (e.g.,
+ * `LUO_CMD_SUBSYSTEM_REGISTER`).
+ * - `arg`: A pointer to a command-specific argument structure. For subsystem
+ * tests, this points to a `struct luo_arg_subsystem` (defined in
+ * `luo_selftests.h`).
+ *
+ * Commands:
+ * - `LUO_CMD_SUBSYSTEM_REGISTER`:
+ * Registers a new dummy LUO subsystem. It allocates kernel memory for test
+ * data, copies initial data from the user-provided `data_page`, sets up
+ * simple logging callbacks, and calls the core
+ * `liveupdate_register_subsystem()`
+ * function. Requires `arg` pointing to `struct luo_arg_subsystem`.
+ * - `LUO_CMD_SUBSYSTEM_UNREGISTER`:
+ * Unregisters a previously registered dummy subsystem identified by `name`.
+ * It calls the core `liveupdate_unregister_subsystem()` function and then
+ * frees the associated kernel memory and internal tracking structures.
+ * Requires `arg` pointing to `struct luo_arg_subsystem` (only `name` used).
+ * - `LUO_CMD_SUBSYSTEM_GETDATA`:
+ * Copies the content of the kernel data page associated with the specified
+ * dummy subsystem (`name`) back to the user-provided `data_page`. This allows
+ * userspace to verify the state of the data after potential test operations.
+ * Requires `arg` pointing to `struct luo_arg_subsystem`.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/debugfs.h>
+#include <linux/errno.h>
+#include <linux/gfp.h>
+#include <linux/kexec_handover.h>
+#include <linux/liveupdate.h>
+#include <linux/mutex.h>
+#include <linux/uaccess.h>
+#include <uapi/linux/liveupdate.h>
+#include "luo_internal.h"
+#include "luo_selftests.h"
+
+static struct luo_subsystems {
+	struct liveupdate_subsystem handle;
+	char name[LUO_NAME_LENGTH];
+	void *data;
+	bool in_use;
+	bool preserved;
+} luo_subsystems[LUO_MAX_SUBSYSTEMS];
+
+/* Only allow one selftest ioctl operation at a time */
+static DEFINE_MUTEX(luo_ioctl_mutex);
+
+static int luo_subsystem_prepare(struct liveupdate_subsystem *h, u64 *data)
+{
+	struct luo_subsystems *s = container_of(h, struct luo_subsystems,
+						handle);
+	unsigned long phys_addr = __pa(s->data);
+	int ret;
+
+	ret = kho_preserve_pages(phys_to_page(phys_addr), 1);
+	if (ret)
+		return ret;
+
+	s->preserved = true;
+	*data = phys_addr;
+	pr_info("Subsystem '%s' prepare data[%lx]\n",
+		s->name, phys_addr);
+
+	if (strstr(s->name, NAME_PREPARE_FAIL))
+		return -EAGAIN;
+
+	return 0;
+}
+
+static int luo_subsystem_freeze(struct liveupdate_subsystem *h, u64 *data)
+{
+	struct luo_subsystems *s = container_of(h, struct luo_subsystems,
+						handle);
+
+	pr_info("Subsystem '%s' freeze data[%llx]\n", s->name, *data);
+
+	return 0;
+}
+
+static void luo_subsystem_cancel(struct liveupdate_subsystem *h, u64 data)
+{
+	struct luo_subsystems *s = container_of(h, struct luo_subsystems,
+						handle);
+
+	pr_info("Subsystem '%s' canel data[%llx]\n", s->name, data);
+	s->preserved = false;
+	WARN_ON(kho_unpreserve_pages(phys_to_page(data), 1));
+}
+
+static void luo_subsystem_finish(struct liveupdate_subsystem *h, u64 data)
+{
+	struct luo_subsystems *s = container_of(h, struct luo_subsystems,
+						handle);
+
+	pr_info("Subsystem '%s' finish data[%llx]\n", s->name, data);
+}
+
+static const struct liveupdate_subsystem_ops luo_selftest_subsys_ops = {
+	.prepare = luo_subsystem_prepare,
+	.freeze = luo_subsystem_freeze,
+	.cancel = luo_subsystem_cancel,
+	.finish = luo_subsystem_finish,
+	.owner = THIS_MODULE,
+};
+
+static int luo_subsystem_idx(char *name)
+{
+	int i;
+
+	for (i = 0; i < LUO_MAX_SUBSYSTEMS; i++) {
+		if (luo_subsystems[i].in_use &&
+		    !strcmp(luo_subsystems[i].name, name))
+			break;
+	}
+
+	if (i == LUO_MAX_SUBSYSTEMS) {
+		pr_warn("Subsystem with name '%s' is not registred\n", name);
+
+		return -EINVAL;
+	}
+
+	return i;
+}
+
+static void luo_put_and_free_subsystem(char *name)
+{
+	int i = luo_subsystem_idx(name);
+
+	if (i < 0)
+		return;
+
+	if (luo_subsystems[i].preserved)
+		kho_unpreserve_pages(virt_to_page(luo_subsystems[i].data), 1);
+	free_page((unsigned long)luo_subsystems[i].data);
+	luo_subsystems[i].in_use = false;
+	luo_subsystems[i].preserved = false;
+}
+
+static int luo_get_and_alloc_subsystem(char *name, void __user *data,
+				       struct liveupdate_subsystem **hp)
+{
+	unsigned long page_addr, i;
+
+	page_addr = get_zeroed_page(GFP_KERNEL);
+	if (!page_addr) {
+		pr_warn("Failed to allocate memory for subsystem data\n");
+		return -ENOMEM;
+	}
+
+	if (copy_from_user((void *)page_addr, data, PAGE_SIZE)) {
+		free_page(page_addr);
+		return -EFAULT;
+	}
+
+	for (i = 0; i < LUO_MAX_SUBSYSTEMS; i++) {
+		if (!luo_subsystems[i].in_use)
+			break;
+	}
+
+	if (i == LUO_MAX_SUBSYSTEMS) {
+		pr_warn("Maximum number of subsystems registered\n");
+		free_page(page_addr);
+		return -ENOMEM;
+	}
+
+	luo_subsystems[i].in_use = true;
+	luo_subsystems[i].handle.ops = &luo_selftest_subsys_ops;
+	luo_subsystems[i].handle.name = luo_subsystems[i].name;
+	strscpy(luo_subsystems[i].name, name, LUO_NAME_LENGTH);
+	luo_subsystems[i].data = (void *)page_addr;
+
+	*hp = &luo_subsystems[i].handle;
+
+	return 0;
+}
+
+static int luo_cmd_subsystem_unregister(void __user *argp)
+{
+	struct luo_arg_subsystem arg;
+	int ret, i;
+
+	if (copy_from_user(&arg, argp, sizeof(arg)))
+		return -EFAULT;
+
+	i = luo_subsystem_idx(arg.name);
+	if (i < 0)
+		return i;
+
+	ret = liveupdate_unregister_subsystem(&luo_subsystems[i].handle);
+	if (ret)
+		return ret;
+
+	luo_put_and_free_subsystem(arg.name);
+
+	return 0;
+}
+
+static int luo_cmd_subsystem_register(void __user *argp)
+{
+	struct liveupdate_subsystem *h;
+	struct luo_arg_subsystem arg;
+	int ret;
+
+	if (copy_from_user(&arg, argp, sizeof(arg)))
+		return -EFAULT;
+
+	ret = luo_get_and_alloc_subsystem(arg.name,
+					  (void __user *)arg.data_page, &h);
+	if (ret)
+		return ret;
+
+	ret = liveupdate_register_subsystem(h);
+	if (ret)
+		luo_put_and_free_subsystem(arg.name);
+
+	return ret;
+}
+
+static int luo_cmd_subsystem_getdata(void __user *argp)
+{
+	struct luo_arg_subsystem arg;
+	int i;
+
+	if (copy_from_user(&arg, argp, sizeof(arg)))
+		return -EFAULT;
+
+	i = luo_subsystem_idx(arg.name);
+	if (i < 0)
+		return i;
+
+	if (copy_to_user(arg.data_page, luo_subsystems[i].data,
+			 PAGE_SIZE)) {
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int luo_ioctl_selftests(void __user *argp)
+{
+	struct liveupdate_selftest luo_st;
+	void __user *cmd_argp;
+	int ret = 0;
+
+	if (copy_from_user(&luo_st, argp, sizeof(luo_st)))
+		return -EFAULT;
+
+	cmd_argp = (void __user *)luo_st.arg;
+
+	mutex_lock(&luo_ioctl_mutex);
+	switch (luo_st.cmd) {
+	case LUO_CMD_SUBSYSTEM_REGISTER:
+		ret =  luo_cmd_subsystem_register(cmd_argp);
+		break;
+
+	case LUO_CMD_SUBSYSTEM_UNREGISTER:
+		ret =  luo_cmd_subsystem_unregister(cmd_argp);
+		break;
+
+	case LUO_CMD_SUBSYSTEM_GETDATA:
+		ret = luo_cmd_subsystem_getdata(cmd_argp);
+		break;
+
+	default:
+		pr_warn("ioctl: unknown self-test command nr: 0x%llx\n",
+			luo_st.cmd);
+		ret = -ENOTTY;
+		break;
+	}
+	mutex_unlock(&luo_ioctl_mutex);
+
+	return ret;
+}
+
+static long luo_selftest_ioctl(struct file *filep, unsigned int cmd,
+			       unsigned long arg)
+{
+	int ret = 0;
+
+	if (_IOC_TYPE(cmd) != LIVEUPDATE_IOCTL_TYPE)
+		return -ENOTTY;
+
+	switch (cmd) {
+	case LIVEUPDATE_IOCTL_FREEZE:
+		ret = luo_freeze();
+		break;
+
+	case LIVEUPDATE_IOCTL_SELFTESTS:
+		ret = luo_ioctl_selftests((void __user *)arg);
+		break;
+
+	default:
+		pr_warn("ioctl: unknown command nr: 0x%x\n", _IOC_NR(cmd));
+		ret = -ENOTTY;
+		break;
+	}
+
+	return ret;
+}
+
+static const struct file_operations luo_selftest_fops = {
+	.open = nonseekable_open,
+	.unlocked_ioctl = luo_selftest_ioctl,
+};
+
+static int __init luo_seltesttest_init(void)
+{
+	if (!liveupdate_debugfs_root) {
+		pr_err("liveupdate root is not set\n");
+		return 0;
+	}
+	debugfs_create_file_unsafe("luo_selftest", 0600,
+				   liveupdate_debugfs_root, NULL,
+				   &luo_selftest_fops);
+	return 0;
+}
+
+late_initcall(luo_seltesttest_init);
diff --git a/kernel/liveupdate/luo_selftests.h b/kernel/liveupdate/luo_selftests.h
new file mode 100644
index 000000000000..098f2e9e6a78
--- /dev/null
+++ b/kernel/liveupdate/luo_selftests.h
@@ -0,0 +1,84 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#ifndef _LINUX_LUO_SELFTESTS_H
+#define _LINUX_LUO_SELFTESTS_H
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+/* Maximum number of subsystem self-test can register */
+#define LUO_MAX_SUBSYSTEMS		16
+#define LUO_NAME_LENGTH			32
+
+#define LUO_CMD_SUBSYSTEM_REGISTER	0
+#define LUO_CMD_SUBSYSTEM_UNREGISTER	1
+#define LUO_CMD_SUBSYSTEM_GETDATA	2
+struct luo_arg_subsystem {
+	char name[LUO_NAME_LENGTH];
+	void *data_page;
+};
+
+/*
+ * Test name prefixes:
+ * normal: prepare and freeze callbacks do not fail
+ * prepare_fail: prepare callback fails for this test.
+ * freeze_fail: freeze callback fails for this test
+ */
+#define NAME_NORMAL		"ksft_luo"
+#define NAME_PREPARE_FAIL	"ksft_prepare_fail"
+#define NAME_FREEZE_FAIL	"ksft_freeze_fail"
+
+/**
+ * struct liveupdate_selftest - Holds directions for the self-test operations.
+ * @cmd:    Selftest comman defined in luo_selftests.h.
+ * @arg:    Argument for the self test command.
+ *
+ * This structure is used only for the selftest purposes.
+ */
+struct liveupdate_selftest {
+	__u64		cmd;
+	__u64		arg;
+};
+
+/**
+ * LIVEUPDATE_IOCTL_FREEZE - Notify subsystems of imminent reboot
+ * transition.
+ *
+ * Argument: None.
+ *
+ * Notifies the live update subsystem and associated components that the kernel
+ * is about to execute the final reboot transition into the new kernel (e.g.,
+ * via kexec). This action triggers the internal %LIVEUPDATE_FREEZE kernel
+ * event. This event provides subsystems a final, brief opportunity (within the
+ * "blackout window") to save critical state or perform last-moment quiescing.
+ * Any remaining or deferred state saving for items marked via the PRESERVE
+ * ioctls typically occurs in response to the %LIVEUPDATE_FREEZE event.
+ *
+ * This ioctl should only be called when the system is in the
+ * %LIVEUPDATE_STATE_PREPARED state. This command does not transfer data.
+ *
+ * Return: 0 if the notification is successfully processed by the kernel (but
+ * reboot follows). Returns a negative error code if the notification fails
+ * or if the system is not in the %LIVEUPDATE_STATE_PREPARED state.
+ */
+#define LIVEUPDATE_IOCTL_FREEZE						\
+	_IO(LIVEUPDATE_IOCTL_TYPE, 0x05)
+
+/**
+ * LIVEUPDATE_IOCTL_SELFTESTS - Interface for the LUO selftests
+ *
+ * Argument: Pointer to &struct liveupdate_selftest.
+ *
+ * Use by LUO selftests, commands are declared in luo_selftests.h
+ *
+ * Return: 0 on success, negative error code on failure (e.g., invalid token).
+ */
+#define LIVEUPDATE_IOCTL_SELFTESTS					\
+	_IOWR(LIVEUPDATE_IOCTL_TYPE, 0x08, struct liveupdate_selftest)
+
+#endif /* _LINUX_LUO_SELFTESTS_H */
-- 
2.51.0.536.g15c5d4f767-goog


