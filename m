Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F2C3CCD184
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 06:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11BAF8E000A; Sun, 19 Oct 2025 02:16:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C7EA8E0002; Sun, 19 Oct 2025 02:16:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E864B8E000A; Sun, 19 Oct 2025 02:16:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D99688E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 02:16:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A6070B9E71
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:16:57 +0000 (UTC)
X-FDA: 84013855674.01.7FE668B
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id ED51C140004
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:16:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Epdnp9/v";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760854616; a=rsa-sha256;
	cv=none;
	b=57ZUij+3axc3lIZeBqF8lOU2HE4SVqQ8BFOYbH+6EwnKgpklLICVmPl/S47O1cB+OTlojI
	HuxTTQv7/gu87j+78eQwdBOrKJWgbdTpOwZ9DvLf6ZRaw4gOXqNH0a+5H3WMLAukskeeuP
	4q2ZdnhVhbORLLRK+q4HkuCAK6SU398=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Epdnp9/v";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760854616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dIeDgxZ048HUq/QptiVsvTSq/SH6NNfnJz16wRbfAOg=;
	b=68kLpD9NXc7fyj33vw/Iuj+VgJoHesGam6FNLKhKWEduj9wDmswyutGowpzbSIM7+Wy6C9
	BqvAZ2oEHFo1WYrdKGtipX+zV/gn/AzdbDecIQH9D530mCZrSVsl8MbG/Qe4WlVCSEjNZB
	qUJNM9QYTOBUuab06tKSbibn1zxQZFE=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7a226a0798cso1548890b3a.2
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 23:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760854615; x=1761459415; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dIeDgxZ048HUq/QptiVsvTSq/SH6NNfnJz16wRbfAOg=;
        b=Epdnp9/v8vngqnXmKJOeDt+7Q2eQkPW+h1FtzNhBFP+6AicRq12vB4QXW0H226rvL+
         d1h466GITz8jQ8PPEi2SLgixRRipkjOwHM9wIqf1g/j5a32N/SEsTtKhunyQsSRdHrXM
         eO9cGfW0H8LtvdV7O9Tu6aNFGVqdvQ0qoyHAJdym6bqdeEm+ag2Fcc+S8LBrSs0276j6
         S2IkG0Q/7E1r5g9mI1dzw6nM0MnusfiApQr4Na3E2DSVamXD7Q6IdsBDP3A96LA3j7X7
         dN8XSjEvyGhUAKAQ0WObfynnsGxbfUCCYsuZ62FTRqHm1DOLs3XPUinXa8PN/sxz1mS0
         jXFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760854615; x=1761459415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dIeDgxZ048HUq/QptiVsvTSq/SH6NNfnJz16wRbfAOg=;
        b=P87HfH5AeQT3D3WZTSXQnjoRNVLdkB+pZEjUao4vLhxaDIhYZXtYDTWtoSlRcyPe4s
         sxGLe3Lfg9gnmZBfPVffTzXvb9I8EIpj8qK58+4zShY3PGJeYQoooioDeC3U5ttjmAW/
         l8dK98eXgYVAmDmXS/vnNzADEtRpVw5aVtCHj+B5OQaN55r7xVvxOFZ5KdRd5bhO0c9P
         RvIdxgPgaAtxECvbystB/ibvautqxdgdz0YEGGIfi1kLkAfFHeE8yVYvPp46nS+Yup+C
         tdA5IJ4xWZBbWUUnv7+1aihq8U6NpY7EugaA3e0UZnjuFZjXfKIJtMwY0qlskvP8pylF
         cr1g==
X-Forwarded-Encrypted: i=1; AJvYcCW9iX4qymz+TMXApmzeCXRBtm1VRtuJzkG+yW+GzNaxN6UOJbC46ywPR/RGGsK8ZbT9mp7Icny0KQ==@kvack.org
X-Gm-Message-State: AOJu0YyZ83WLJ551LonMSUtMozgGHkmWnOfoylgyHvR1u8JVyubIP3+7
	6FqAZIam59c7C5zqWXAJVOdxoGiMtL0/xh/ZU7zl2VxKviooA+J3x3Uz
X-Gm-Gg: ASbGncsxsTWeXAmOvvXzEfFa5zXbHBEhcEtpqYOz8ZOiqvNSqqfZHSOf+JTtlierLkb
	pxRe1r5l04ak023/LzDQH+FhxxarAfLclxmgYOW2lkCpwL+ZNXTaySdu/6SubDMIMeLLRdtaNcy
	pglfKvt6egQ1TuNmixvA7meiFtMFd6M9jhjB3rSXHGf+fuJPO9oKmDLte7mloQi6Km0nvHWILHK
	XMJjRQd6HqAPIFpSJtuhnpxkWKaCEEisArHsQizOsxz+9Yog/OaL/tKnAK3jgjLQTb+wFeKDkeC
	divAe9a6MZonxbqzz1CbSPXGUOqtDClXjY3vm0FQlt/e+EdZnqr1UscgVK7piaCasmGquCVbHiB
	4UAb76WGjeTmOEPrCGhvJw36t/AmDciUIhFhrpiwADNsdvU8cAfaTXrU3jsmqXr7N2WNxbFBjB9
	30wIqawOyCb1/x0bM=
X-Google-Smtp-Source: AGHT+IG0OBW7fmiA2YniV8ymtG2+sPiHKCxBMdY5eWEb2qkoBgohPShQvQn2sQ3XNKwAIyFsb9Df0A==
X-Received: by 2002:a05:6300:4cc:20b0:334:b4ad:154b with SMTP id adf61e73a8af0-334b4ad168fmr5911026637.27.1760854614800;
        Sat, 18 Oct 2025 23:16:54 -0700 (PDT)
Received: from pop-os.. ([2601:647:6881:9060:bc87:d8fe:3e55:7ffb])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a76b6f302sm4332032a12.38.2025.10.18.23.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 23:16:54 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: jiri@resnulli.us,
	stefanha@redhat.com,
	multikernel@lists.linux.dev,
	pasha.tatashin@soleen.com,
	Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [RFC Patch v2 03/16] multikernel: Introduce basic multikernel subsystem infrastructure
Date: Sat, 18 Oct 2025 23:16:17 -0700
Message-Id: <20251019061631.2235405-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
References: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ED51C140004
X-Stat-Signature: mw6io7b4n5gskhzkdi9tdb6gwhf1e6ad
X-HE-Tag: 1760854615-404671
X-HE-Meta: U2FsdGVkX1+VanQr6/L1He618Gp+PR5FBo9w68OpD2M/z75kXgVJRgMGicef4ozPxBsgQXzf8TNu2lOUE+VqmlaYfWv+L40S0pI+H5CkGrUlX8zGnARbGtFuQXTPAUeIPK01NXrioGX5T/EdhR1vlzmlqu/Ju7TvL6jI44LGtTLgaj0xOJhQnjXTHHSb3oz/Ms5rPpIKH9FqfwCyvP2tHXuuSEvSAuE7hm4A7mdWrWvjxyoQxN1qcJB/S609mYL4FqyCY5jvZgg+auvMO0hKA1CnLgMXgFl/7i/8cspakhlBngl0bwCcsna4yI/Aw53skzJO0iUK9gMi9VCGffy+WSCAPOcww/jhWH4267wWfP7eBeA232xl9E8WZ1BFI2trTnPce9/tTH5lWE6hxUnS7StbtWNunSo1J+vffNFt1zUYW5PGVa9ClVWf7kl3XPo0W4/X06UgeXeoh6BrnCR9roYxzZuB+IE0IniAenbjhHxgpWpxT2dammCI8q8HD7VPcpLC7vci87r6hB9ETT5DH8APV1unT+4ixqMv5hTJ7vhLAPkVFJPM146X3FB4Qx7mD2FZdMp5QwfqnD1dYeBUQLFID+X2dYqLYYGi+fQlYWrXj3YnkKV3hfsdc77No9eAdAmhyV/Nzjc0uKW8nCvFf5ynkrLZ+xgX2hAc8aAemJxrb8RDlWLW4rRbJadBePCInUdZJqstAUpobHNaY12K5ItmNhl7vyds/FBngSm5DOKCfJbRWbuQrcj3y3kiB8AiqKCqJKUvr6YACuWdXolu567la6K6dqupGvGpX/6BZwDoG4Qlh4jHJoabYbOA3NLJQ4QRwWfeKo4VXLjYIkJacQr/2bW7XD8xoUt6gB+cr4Al3WASkin3HigXJQaDZjzCXR7uJ//VUMvMa1YG/uUhMKALulHIWGYqVIZbr51/Ww8jz4jOrrgp8erKLUMn23DsvXuMR6yMco0Fh4/27Up
 Syt5ldSh
 /1/PZgcZLH/A/ZFEaZD9SuzndngH9RVWKO0xnurR9/Jzu4r3i1VT87fA9Qa1Nreb+6f+LqxxWhOdmZVkSeWFEYqz9CZAvL+KaoV/mJnpz2ytrwHuvuzM954v1QpLi9Eo9cBkG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

This commit introduces:

* Configuration infrastructure (kernel/multikernel/Kconfig) that adds
  CONFIG_MULTIKERNEL option depending on KEXEC_CORE, it will provide kernfs
  interface for multikernel instance management, device tree based
  resource management, physical memory pool allocation, and kexec integration.

* Core initialization module (kernel/multikernel/core.c) that provides
  basic subsystem initialization using subsys_initcall() to ensure
  multikernel support is initialized after core kernel subsystems.

This foundational commit establishes the basic framework that subsequent
patches will build upon to implement the full multikernel functionality.

Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 kernel/Kconfig.kexec        |  2 ++
 kernel/Makefile             |  1 +
 kernel/multikernel/Kconfig  | 20 ++++++++++++++++++++
 kernel/multikernel/Makefile |  6 ++++++
 kernel/multikernel/core.c   | 17 +++++++++++++++++
 5 files changed, 46 insertions(+)
 create mode 100644 kernel/multikernel/Kconfig
 create mode 100644 kernel/multikernel/Makefile
 create mode 100644 kernel/multikernel/core.c

diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index 422270d64820..e0fbd7e9af43 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -194,4 +194,6 @@ config CRASH_MAX_MEMORY_RANGES
 	  the computation behind the value provided through the
 	  /sys/kernel/crash_elfcorehdr_size attribute.
 
+source "kernel/multikernel/Kconfig"
+
 endmenu
diff --git a/kernel/Makefile b/kernel/Makefile
index df3dd8291bb6..017ed567f86a 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -56,6 +56,7 @@ obj-y += dma/
 obj-y += entry/
 obj-y += unwind/
 obj-$(CONFIG_MODULES) += module/
+obj-$(CONFIG_MULTIKERNEL) += multikernel/
 
 obj-$(CONFIG_KCMP) += kcmp.o
 obj-$(CONFIG_FREEZER) += freezer.o
diff --git a/kernel/multikernel/Kconfig b/kernel/multikernel/Kconfig
new file mode 100644
index 000000000000..0e61fd2e505a
--- /dev/null
+++ b/kernel/multikernel/Kconfig
@@ -0,0 +1,20 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Multikernel configuration
+#
+
+config MULTIKERNEL
+	bool "Multikernel support"
+	depends on KEXEC_CORE
+	help
+	  Enable multikernel support, which allows running multiple kernel
+	  instances simultaneously with resource isolation and inter-kernel
+	  communication capabilities.
+
+	  This feature provides:
+	  - Sysfs interface for multikernel instance management
+	  - Device tree based resource specification
+	  - Memory pool management for kernel instances
+	  - Integration with kexec for kernel loading
+
+	  If unsure, say N.
diff --git a/kernel/multikernel/Makefile b/kernel/multikernel/Makefile
new file mode 100644
index 000000000000..950bace927a0
--- /dev/null
+++ b/kernel/multikernel/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Makefile for multikernel support
+#
+
+obj-y += core.o
diff --git a/kernel/multikernel/core.c b/kernel/multikernel/core.c
new file mode 100644
index 000000000000..218424d59cc3
--- /dev/null
+++ b/kernel/multikernel/core.c
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 Multikernel Technologies, Inc. All rights reserved
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/multikernel.h>
+
+static int __init multikernel_init(void)
+{
+	pr_info("Multikernel support initialized\n");
+	return 0;
+}
+
+/* Initialize multikernel after core kernel subsystems are ready */
+subsys_initcall(multikernel_init);
-- 
2.34.1


