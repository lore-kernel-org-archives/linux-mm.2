Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B7CBC87FCB
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:46:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0916A6B007B; Wed,  6 Aug 2025 21:45:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01BC36B00B1; Wed,  6 Aug 2025 21:45:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4C0B6B00B3; Wed,  6 Aug 2025 21:45:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE6246B007B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:45:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ABE721DD466
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:22 +0000 (UTC)
X-FDA: 83748268884.23.C5D19AB
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf16.hostedemail.com (Postfix) with ESMTP id D743A180007
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BiFlZHO7;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VOmTgDGmeBWmPehEZ3L8eOdNbmK4CsWM3+7RuLYUbdA=;
	b=AxxRp+aADKH3d1IQiRJ7gUqtOHlS8kLY7hXiQduzSvs5sZoC6L2RanK9pVmeeLs+zLmrTI
	S+h3rNSerTo300s0PWDeIAZ/fzZ6AJDWwYXTCjD3sFp2+g6E7iUNj89rJRwvpFH2qO3LWN
	BfZwautcM/lvMSXhVGUTZVarzFfwYok=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531120; a=rsa-sha256;
	cv=none;
	b=z4Qp6XvCtRQRzUdx8R04pjn9TY8QuuV3n0ZhgPYMbZRBPahf2X+Kl4dMLuSGX3BD/ucKqv
	Iq/sLGJPwa/Ibp8/eMeQi2t2hz4F8z9QYqq/fbn8PyCat8YNA/nVdno1kWYU9xWnfNCbeU
	3d5CWYiChP1H6Ofl+QD40kt+mW8pbus=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BiFlZHO7;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7e62773cab8so60022485a.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531120; x=1755135920; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VOmTgDGmeBWmPehEZ3L8eOdNbmK4CsWM3+7RuLYUbdA=;
        b=BiFlZHO7UQCsUvnVdcfwsjYwW/Jm4kFJh6tclNT+HZ7l8ickx0dTaxB7QdFNGaUXQw
         RDJRnQ+bxsP0e5zsFbBX3WHCJa9pfdx5HO2RtiULd1pX9TMX38xJafw98LWjfPrfj5Pv
         uLI1TjUexoRMnYb3Dt/mX2pw6ovXpi+igQOD6kBaGdKCGZBEkLtuSQ8Zs9szfT7LtA8v
         WxmHErZQA5sTA0t6oPaGTX/KdtTJtenAYPZSfF4pTWqM5BpqFwhYBFL2OO6j6BpQzgsR
         KMSWjAyAUqK1qYepuWhIHvSD+4L2GCGdLgGjl+eOY9zzxejymipvDRYW/S9n4egQj33L
         NTvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531120; x=1755135920;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VOmTgDGmeBWmPehEZ3L8eOdNbmK4CsWM3+7RuLYUbdA=;
        b=Se6GxBjImBKpuM0P8/kUWvqnOrBIBw2oUPC1RD2RYhbi7NEJmKl6Ib/HpKvWTejD48
         LWrOGrUbTHU4MMaEzpO4rlb9ISxZNCSyxDE9MtnVgBHwOGW5xSJvtPjLhDCx/fcqkdl0
         Agu49AG+migmL9xFJG7fqYh9gokMaNBJ4AQ/Dsy2z4zjZevHzyii5MvFzKkLgp8pZjUY
         7cFe2zTxP/SR40kqWkWkUXkH8nKfVMc33x67XxiClMs468ua+OgVWfn7r8a53ozbvLaH
         stUAmhLluIpoKxJlIGTQ3ChACL7/Ba8KXqTFFZHvBoX62hanRcB1c/uKa3YX0bE2aw+Y
         N16A==
X-Forwarded-Encrypted: i=1; AJvYcCW3UgIr9oOqMicioMHVRO+TIDl/QXERcKWeg+tHFNJWvWmkSh4Xi39Rdj7ECoJEKkerPuM00QMPrQ==@kvack.org
X-Gm-Message-State: AOJu0YwY/Mt9h+CgGaZCY//OhydPIRIe1IMkUzoi2kNROpHLnL9CmyyV
	q1iTHjlt10RAYHHraiuHcKtYFIfPMIMkiGN9phaAfggcrkDY8UHKszh7FIv1TOOOIek=
X-Gm-Gg: ASbGncukvhrz5HrPh3Qzgsnoxg94Um/JQnXlnh3IoUg9hzWupWMfWKJkIRs2wG7azz1
	hkKPvqS5RrRNhKSOTVtWrpTMFAdTTDzXAbrUGUL1jLfloMvbsXLvGVyM/tT31S2jssTEVcqb6bq
	tC0JYvzfk72UHBsFdBn/xvnOmyI2EOzp6Tg/tJ985ixTkCBy9cNb9YHJXGM+XvwsnKkUDgmt0zQ
	Ff5AUAWPTmyot8vzCjGdRBVt0ffEzvtX9dbw4nW0ugBgTgVC93NC9xU8xECIs42eWoT4y5XOFz7
	E2ZoEktf8pXuqXVne19QAhawJe/lg1yJgLGw4HFZESKmqyfgNStcnySZk7PFVtg/UqKehHjO/Q6
	CGF3g6X7q2RNWTaT3cwrQf89KY6o6CXjFi3/b1kST/Jcch6Pv1kLBnBXkPeUqVpxE/+J8ji4icd
	CUDTxlO4i2EBGl
X-Google-Smtp-Source: AGHT+IGa10Q9xXZTxnWqAP3/TJ/pWwwZKDNRJhQRt0NViWNtS/8r0csvFFcTyLahUM71ijfSvrto3Q==
X-Received: by 2002:a05:6214:4013:b0:707:43a1:5b0e with SMTP id 6a1803df08f44-7098a6a5940mr22300026d6.10.1754531119648;
        Wed, 06 Aug 2025 18:45:19 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:45:19 -0700 (PDT)
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
	witu@nvidia.com
Subject: [PATCH v3 22/30] liveupdate: add selftests for subsystems un/registration
Date: Thu,  7 Aug 2025 01:44:28 +0000
Message-ID: <20250807014442.3829950-23-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D743A180007
X-Stat-Signature: owt9aa7cjydmoikq93u7if1df5dokyed
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754531120-927668
X-HE-Meta: U2FsdGVkX1/Q2NK9oMbQAuwSKfjmMJ9NDvy20WwdampcCoc6ckcC0uxuuQRTn9u92tc3QceA2lrfsuKn25UKir+qFA/UPltBMaQx9QHF+2tPBynf5+PFWkDciv7AyrtdVeRIKd1D6tFeC3qqHikL5WWsdFPp7ITxyuJku9R8lKRG2P679W4LGTz2m3wDm/fSGYEAku036g56ZiOt0CzC9XZZaHpjlrGcSQZy5ZRQI/0P4Hi1scZvkXwm4hW6IxRuVStdRVFbunM+NjBfLEUg0xoiWnV6iec6o6iV415N5hphUlWV024YodHfF+X2sXIpyGoN31ULFekSUFcZbLEnFVwjJ/NmSVT4Wq05eh9ocFjN6zd39G9tMBNW9z640R0eKRzyEgLSjmDX71q5ULrHQLVEfcRVzer2QwznIKlXRbooYDNPraj5NBqptN3+nXLpE16SmS/nhKubTT+Y1SsC24QsA32Y5JOOLoEReQG+h5U6R1hjfm2uSDKL4tR8DE47QW+mXxeE5C3HItYevwWsTPQfVFfwIV0M5SzJSry+rtcKQnnttOq/dA59lGz5wKk18YOY3LsYuhEK6+QR87X2hFkFKNR9EUgGxrU/jY05YnfjwBXbDhDjQMHxFqgWLJAxuvkYI4dGURjEtIkqBbZF3FCMb8cG9mJ9BE2MeF+tqM2bP0Jp9jgwzR8HdnN/w52zCAuw8dmxFIt+hRHEg50LmY3Iq2uI+qlqFpXxJpiOR0TDzWNI6v15PV8pl1h+E9yhYmqNLQMph02Cw5NHfimYr2DUENfEmQeUn2XdUS3r4Brlh/HADwK56R7JUuHeaJ2o0AY7+fV9pxjapXOmwuoSxtIEU+ZlB//wY4wv0C/tCtkRr0DghlpEtpR3d0jB+PLWCwbzkVoPtTjXG6mlBAOBB+tuvjo2Qlm1DWLwdC+loX+IvCSuQAsbP7Zc0Fw/SpBCchxb6hnjg8WNpB0Wx6B
 9WaCKQX/
 IcSr30mAU4RMyk9qSunFOXFIkyLzE8V59aoqeiGR33nTjJmYVztpv+s5PyPEqJTatNSYJ+AWXGP4SVk0bfBWx9tsVz1/P6Sul1v5BabIt+6Iq1e1vIJ+3gsNhrILaTCeTBv6K8Kqzo8W3Eb2AumnNxA+TqlX0X1J+B+bMnB1+8W+hHmWY285DvKRCdylMeuQwRMlcFt6jK+vw7i8p5C2cafp1CVPl60JXUX888PFfKFmVC5y3ZgB8qpRPfmy00gu4SoqCsnGX83tcwIlLa+ZH0XQnQFFdLhlWQXhzZCs79dXDftpbVe8w0Y72lHh3STmkF3cuxbTQmwV7r2YSfutCv3akuioBMfCN2tHivEnSdAa1fAus4KHjB4x45yXinmYQbZ7Mli0Gqra0YLQYKgAWuWbb8DePfA8wD+PdQqfUtDygLoucCcYfa/5JTw==
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
index 75a17ca8a592..5be04ede357d 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -47,6 +47,21 @@ config LIVEUPDATE_SYSFS_API
 
 	  If unsure, say N.
 
+config LIVEUPDATE_SELFTESTS
+	bool "Live Update Orchestrator - self-tests"
+	depends on LIVEUPDATE
+	help
+	  Say Y here to build self-tests for the LUO framework. When enabled,
+	  these tests can be initiated via the ioctl interface to help verify
+	  the core live update functionality.
+
+	  This option is primarily intended for developers working on the
+	  live update feature or for validation purposes during system
+	  integration.
+
+	  If you are unsure or are building a production kernel where size
+	  or attack surface is a concern, say N.
+
 config KEXEC_HANDOVER
 	bool "kexec handover"
 	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index 47f5d0378a75..9b8b69517463 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -13,4 +13,5 @@ obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
 
 obj-$(CONFIG_LIVEUPDATE)		+= luo.o
+obj-$(CONFIG_LIVEUPDATE_SELFTESTS)	+= luo_selftests.o
 obj-$(CONFIG_LIVEUPDATE_SYSFS_API)	+= luo_sysfs.o
diff --git a/kernel/liveupdate/luo_selftests.c b/kernel/liveupdate/luo_selftests.c
new file mode 100644
index 000000000000..824d6a99f8fc
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
+	ret = kho_preserve_phys(phys_addr, PAGE_SIZE);
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
+	WARN_ON(kho_unpreserve_phys(data, PAGE_SIZE));
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
+		kho_unpreserve_phys(__pa(luo_subsystems[i].data), PAGE_SIZE);
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
2.50.1.565.gc32cd1483b-goog


