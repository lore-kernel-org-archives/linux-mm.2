Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A3A7C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:48:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F9446B0121; Wed, 23 Jul 2025 10:47:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9756B0123; Wed, 23 Jul 2025 10:47:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 123586B0124; Wed, 23 Jul 2025 10:47:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F01136B0121
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C0231C070C
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:40 +0000 (UTC)
X-FDA: 83695808280.18.B9DD6CD
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id D60CF20011
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=d+qmeVY8;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=anrDwp0eME7u1ALRQxj17PhFcownCkP9aNfbuxryMlU=;
	b=cyJvOrH+0LdjIeDlwoRxFcT+Mo8Xb6g5m6fcVlM6YMOQohugD1zHmnPYyL1qIUWOQ6l/zx
	+wVjZ5CQ4W+I3c0E/1zqNqqRU0Ic25W4p9MWoB4PeWq7IvP/lQATgt5x4sUZtFAzsaF0tq
	zb0NHoZNHVir6i20qTk29zlTQLI5dH8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282058; a=rsa-sha256;
	cv=none;
	b=BmmRUpuZcYZC1wPV8kL/0PmqTgCZHYA9HEx4S+nJv1KFjYMunCXyHCEkoX457WRbjVESjd
	1VRr7ZKl7UB4pUyEiC7u1WYsX2yRPRzFqZ97M9o+XJojbzwYfJfW1C8++nk6zb5EyqIUXY
	UJxc0lkgdpmJncS5qemC6Kb7hdJRPE0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=d+qmeVY8;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-71841a48502so55773997b3.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282058; x=1753886858; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=anrDwp0eME7u1ALRQxj17PhFcownCkP9aNfbuxryMlU=;
        b=d+qmeVY8U2dI4KPQaMzgwtYwT6QcqfYnNBri+uGuaM/9wyCO1L232OY595JEvRrQ5+
         48wOcjSZ4zii4od8vn/mYC5ZpuAfgVGrxhsr1WAjb6o1g5FZ2RWKRW+yqN7lyRR75nxM
         vXOHNJKfTfaVVjLHrPqlv7kfmfzqvvmLBL67GNq/TTpDXemFnnay0XSXUAAxGDz0Y24K
         fhXSpwW6mk8jPfmiu2OjhXybCKAEEpLjC4qREcax8doIRHx80g7C3LZlp9+k29NFfr4b
         9olHe/E9klNNpbla12Z7d36NnpURi8ub/P7XrZGl0qMykveu938J/VjlCbPxUCIteg6I
         jbyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282058; x=1753886858;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=anrDwp0eME7u1ALRQxj17PhFcownCkP9aNfbuxryMlU=;
        b=Tor1DfH7acpJH493AvqRFAzsHcmzOXfTzIencDzVrY3G5eEB47syMFNEJqc+HojEvE
         jIFsZ58u+K+Brs2/B9pBkPcxaLISjVDDCBk2NAMYWC0RPgebkc6lJz4R1/Y1hhe+irY6
         /c2J/StN6U1njP+/j7RawZNDtnJ9AfziDPSlUjUiUUm+cmRFbUeX545pWRCPvdivvxZv
         wAwlZsLMZu8w82IgpR0mDETozEo2/L7ZXUQvU19aqAOOkxKvgL+zAbE79nFi0VBX76Pf
         CZun8hsaYC0zJ/gLawakOm7XcNTQFUEIKeZK3ZE7yaRfoemgHdARvUbH4+iyUNlA25co
         Co3w==
X-Forwarded-Encrypted: i=1; AJvYcCVzfiqRi17MEn8skCMMfZpXNyb9W6PZkCsyu+mw8ZHwYQzc6aWWp2+k9MRUxxYxD99sZQhBSdy1qg==@kvack.org
X-Gm-Message-State: AOJu0Yznm+4mGmTnVJSnR/bFDVYaJ8hYn7gSyYRL2s5/orKq5oXg3bkH
	i0lG6rIwwv+KLOdpWLThJXqhl55Isek2rz1QKjeijCi1mOos7azjdzRU0VC7HHrJepY=
X-Gm-Gg: ASbGnctOHeccBkamUdZ0G9xPfrCsPwxuYfJ8VHLkQhiLCO7LENVd+Eo5jjdPEePV3z2
	f7+F7syRfC8+nUgmes58EXaZ3whk2hrJ59b5/Ae8xjavaEBtRFZSwMGp8N6lS3jp8juW5jtY7Ib
	SCht8V0Ydiq4cjWlCUTlycVEq2jjjN5rNnbL6yJyrs02vZRjrzLccxGi+c6euSxXKI9w9SLFV8m
	NL1TAU+lfv/1zQH3xWhBrs8mekSFq3aDwWE3OfWEFkcfcQFQFjBgMMhV/07OzGwlQupHQBKz4Ms
	QwEW2tf6WhIQJ5IbZQf5yF4W/+rxdOTqxxGMEQsV3MiiCJMT+y6cdlMyuVM8umUtt4awc8VQLpu
	OeljMJtxfd7rgah/ccM/rP92cGTyWm8MOmfeP81lC8HEy0BrQLGpR1t2wfKwJA6xCpETHcG2vfl
	k3/6bJsJXCnA/Abg==
X-Google-Smtp-Source: AGHT+IEq0PV8i6iKON0XPIItsPa9CfAALAQ3IWvTSJEL0fMdHI3uPm5IDBAuVJRK3YeOMk6mgAsf0g==
X-Received: by 2002:a05:690c:c14:b0:702:d85:5347 with SMTP id 00721157ae682-719b4238961mr41715367b3.36.1753282057544;
        Wed, 23 Jul 2025 07:47:37 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:47:36 -0700 (PDT)
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
Subject: [PATCH v2 21/32] liveupdate: add selftests for subsystems un/registration
Date: Wed, 23 Jul 2025 14:46:34 +0000
Message-ID: <20250723144649.1696299-22-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D60CF20011
X-Stat-Signature: tag1fdzhuwrspx55nm73fmqfqwq8uyfm
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753282058-112300
X-HE-Meta: U2FsdGVkX18PktR+7dq6lThr4cV41Vri52EPrkcciw1tMdY6fMQIbgFlBQg5WSd2mNwvUEHRzqc1UPUAeX0yk75EjWl5ow0NvgajZAnB5Pj7MwVJaV6xIl5enemsnPGxXvSnb5XXKZJVdTD4dY5HR8/MYN5PhVaBscOj/m9kp2y59Xv9iNlmPyjAFhXagri+BN8n+0r7yOKfQyqcyGlRigTNEFDJoQBLRB9krTqVK7Z2UIjd6qVUeKVi9+qGA3qDmcV/oWLsXlRdJrhps95UeE8mp4e52I7Osu1eiFY5YYuuW03ihN8trAsZMnfp2A0IUG75XrOMJIslPnsViEvnc02MRr7RxQRvUJnYwruNXXTDe+jdKR2uYdMK8chwzU6rJc/eGODLwwKemDErTXt797BNAOEqKrpGRIxesd7IKQ60Q02gBSj3xwn4IAcbEaCVxL4CkWzLNWNfPUc3pVzMAwdP5HkJ+Kchzp0QXWtsAGnN48xMnLFTBEakXifkoQP7ErsoUrJ36njN8y4AqNfXE4kaZ328lOqMldq4Bi/F7oOH2P0sD8eiU+TOp5Whv9CHwyMP//ieYe08NWdA86T4CCuFbeM66XZT/XjIvvFpOo5j7sZRF4FgwLoTgrfwpOWB+y2of25bKklkqRY8sKmOa0LfjdiG6jN+NhyQC94kohYWxUlT5wzrvcKux42ku+ieMsRxMclJnZyzBGJKsKlZejgPq4ags8sVYE2zuSzpX9cxpx00+8YoxRHmyzMA+pcnckJNlQW0zR+w/tPiYjCKtOS+ZUfA4wCIcv4KCvWyw2VmqCL1tEg3SHz/aQ2Jcd1pQNoCOcfua2MBPy1Tfu0Ta61aAhatXdCVHc9vSRttZtps/3awCc1wy5u7RGqvPv3zz3PO0xc6tzOOWbaMjwqKzYEJaBMyvkaveLJivz8bDNo+t9uYFKyJN4z6+FTvb+CUHkmidCKPSO/iz0OEs92
 /+v1utTF
 GZPC29mBRlRexuxJ+fC3IFDTWNLyTUBJrbZkxMqshJdq5IZJX0sg5eeYcF09MzmI8jnelL0vL7SXpaxfAh6bca1H0Wsy7WLLfOvE4DIu/TRvFpxC0jKnmHGdN2YrrnA4K9kpZbFkEiJkjPKGaexeM6i8z/f6Ey2wecT3kBHSxyBPdKGtA3+1QULCne21r+ZptfQxx+PYGoiYacAyiWCYA8UqCErOqoczPvzf8AaQhdTSEXR3at/jmlDOWnJa2vRRd2BhNlfic5NFbvMynTwS1zemNfwdMO8YujfKejUOIUMP4K15k4KDk/uhbUoPqVBJLPwhM+YGE2htWuby5JHJrW5UbwERQonjP8jXcLDL91lUt7tZLGqVXCIz+WV4kDCwDxuVQYS/nA9XN0ZOAq95EfI8d6LgMrL7V+82zyLWbOW/tuinmZw5RsmGa5z5x2+v2bzp4P8GWlW0zJDxBANneu1nEEb00j22wq6mhrBk10ujZYfG7P5C9P2PP2zzevOwd1MzQjk/o+EmdzN1ALk+nYB37eA==
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
 kernel/liveupdate/luo_selftests.c | 344 ++++++++++++++++++++++++++++++
 kernel/liveupdate/luo_selftests.h |  84 ++++++++
 4 files changed, 444 insertions(+)
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
index e35ddc51ab2b..dfb63414cab2 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
 obj-$(CONFIG_LIVEUPDATE)		+= luo_core.o
 obj-$(CONFIG_LIVEUPDATE)		+= luo_files.o
+obj-$(CONFIG_LIVEUPDATE_SELFTESTS)	+= luo_selftests.o
 obj-$(CONFIG_LIVEUPDATE)		+= luo_ioctl.o
 obj-$(CONFIG_LIVEUPDATE)		+= luo_subsystems.o
 obj-$(CONFIG_LIVEUPDATE_SYSFS_API)	+= luo_sysfs.o
diff --git a/kernel/liveupdate/luo_selftests.c b/kernel/liveupdate/luo_selftests.c
new file mode 100644
index 000000000000..a198195fd1a5
--- /dev/null
+++ b/kernel/liveupdate/luo_selftests.c
@@ -0,0 +1,344 @@
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
+static int luo_subsystem_prepare(void *arg, u64 *data)
+{
+	unsigned long i = (unsigned long)arg;
+	unsigned long phys_addr = __pa(luo_subsystems[i].data);
+	int ret;
+
+	ret = kho_preserve_phys(phys_addr, PAGE_SIZE);
+	if (ret)
+		return ret;
+
+	luo_subsystems[i].preserved = true;
+	*data = phys_addr;
+	pr_info("Subsystem '%s' prepare data[%lx]\n",
+		luo_subsystems[i].name, phys_addr);
+
+	if (strstr(luo_subsystems[i].name, NAME_PREPARE_FAIL))
+		return -EAGAIN;
+
+	return 0;
+}
+
+static int luo_subsystem_freeze(void *arg, u64 *data)
+{
+	unsigned long i = (unsigned long)arg;
+
+	pr_info("Subsystem '%s' freeze data[%llx]\n",
+		luo_subsystems[i].name, *data);
+
+	return 0;
+}
+
+static void luo_subsystem_cancel(void *arg, u64 data)
+{
+	unsigned long i = (unsigned long)arg;
+
+	pr_info("Subsystem '%s' canel data[%llx]\n",
+		luo_subsystems[i].name, data);
+	luo_subsystems[i].preserved = false;
+	WARN_ON(kho_unpreserve_phys(data, PAGE_SIZE));
+}
+
+static void luo_subsystem_finish(void *arg, u64 data)
+{
+	unsigned long i = (unsigned long)arg;
+
+	pr_info("Subsystem '%s' finish data[%llx]\n",
+		luo_subsystems[i].name, data);
+}
+
+static const struct liveupdate_subsystem_ops luo_selftest_subsys_ops = {
+	.prepare = luo_subsystem_prepare,
+	.freeze = luo_subsystem_freeze,
+	.cancel = luo_subsystem_cancel,
+	.finish = luo_subsystem_finish,
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
+	luo_subsystems[i].handle.arg = (void *)i;
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
2.50.0.727.gbf7dc18ff4-goog


