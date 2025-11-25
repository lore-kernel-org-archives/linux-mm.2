Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1BE6D10368
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 22:50:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EF1A6B0022; Tue, 25 Nov 2025 17:50:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D92B6B0023; Tue, 25 Nov 2025 17:50:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62EA56B0024; Tue, 25 Nov 2025 17:50:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3BFBC6B0022
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 17:50:16 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F28328ACFC
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 22:50:15 +0000 (UTC)
X-FDA: 84150624390.07.B117B8B
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id 30FD614000E
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 22:50:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=k5ZbzcZi;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764111014; a=rsa-sha256;
	cv=none;
	b=d8f69j34XyUuJxjTnPoUsvjmKJ5xjQK9wy9xeNVDAX20OXvel4rCViq4LTeENy2+vVRGP7
	Ih3OfnmALrwj2c7h+AjhrzZDSZKsOmSdgdPeAEj3jwPuI8de4kikkMQifzRGMEJ1LigYYz
	4UTvov/Dx+z0fGXtci6MoVbLsIBl3FA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=k5ZbzcZi;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764111014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WhjNI5+EJ9ljnjKwa2s5cY5pXpLFdeBfNK5SlWfnyu0=;
	b=X9Xc+SEZJ6LN3D+bWTXtMNG0xke4eqgc9DDC67lKdkMqtYYdaPjrlzqMvbylTgPsVjDSIH
	CKplbbb/YI7mHydMdqsGdVbFQ6VOjaN2PwuaH/x+mc/3iGVQodBOO9a9E3mTt5CwZgpmUk
	b2ZKDlE2veFL0UHFCiCfyHxnp83AUg0=
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-640f2c9cc72so4519432d50.3
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764111013; x=1764715813; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WhjNI5+EJ9ljnjKwa2s5cY5pXpLFdeBfNK5SlWfnyu0=;
        b=k5ZbzcZiT2aBE/jAxZK7+zDhqOA/ojRIoTka1aImzqiMQzCo+ukUg2POc3HiTWdUvI
         OiZh4E26DwHKrA9f8GgxMl7tkkp5Qx2h0oO4zPkKQu9/gESWrQoNfFDffrdsggwp4JZf
         AGkobGn9j+Fb4GkXofBTweR4R0kdvK5Xyp9pfoa8wPoSBIVHvpwPRJCiwcG3UoZ6k4YI
         niHe9PR8QgRWkLtQunjzCCjmzOsEnUgf7BiT6fPXIkylnS84/OK0RU4r9yFPmknL7UC1
         j4EQUcmaafEDkNW4tqdqMaBTtP6LnXNAaLkNF1+JopEE7ycpwa9hQDBjBDE/TO00Hkw2
         lqxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764111013; x=1764715813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WhjNI5+EJ9ljnjKwa2s5cY5pXpLFdeBfNK5SlWfnyu0=;
        b=bWj1r7RfRyJ3+gb/65xOK6nydggY5aOnRNJFiAiyp8RF6aR1hG+ID24sjz8AdePncS
         onRALiAoHBXmkEgu+ts/7lQnNy0hJqTPxDu2NmTtUd1AoKSgEmbpWVKCPvgCWkazwUgr
         WpYVbKsZcVqy8ypMm6iLc8r/cPwgBI8fppcA57jAdiiGNLRVTI6hDhNqR/HSj031ZpYL
         0RNRfWIuhIDEG0maP1Iemx/ncuD2nfDUqnObu/LP1jB9QTxq5MVlyPsSP34uLEjv7Cug
         gXo+eJ/UfZHu2LFgyzqoqxtnZYD8GBrE6FuXZBQF20RpOZcmhzBRVhTIBLPV9fX0DE7p
         eUig==
X-Forwarded-Encrypted: i=1; AJvYcCXt4oXReCG1+bktVwpPJd7m4sRCS7IcOv7mVpg3kX9/2XuMZjVNkmLy9yxCpVkW4yH6yJ9qMxml3Q==@kvack.org
X-Gm-Message-State: AOJu0YxM0ScEFl17uc9EFZy2hyeFBj1qDzwQ+Q781BQTS5fXeQhDjEGf
	5dDMntJQEKwoexzFBL4XVuAbfQLA7euIrW9dkDe5cVEPQnXHy8bXncGE3Qr4JSyUs0E=
X-Gm-Gg: ASbGnctm4ivR/jYlkLyKfQofdTAmixz01eXSgmb443ckuhm7s1zsTCMPBCU9/D9R2Gn
	nlXRCqrncqcqRt13IxRg7hGnhT9k34EnMxSULo+ymYlQ+7sd7ErR4J76AZG+SWr9lz/3uDEVxKj
	kZA3vTe0vL8kQOIOfhj+qU1D5pXT4IiJb6Tcv8fLTl5tc7muKmRHzsrDamb0P0qy0eHDDatBpY5
	XoRRytGk671/zQBcVzb+dCBX5Qv6bSaJ14nQTA3tzZDj6REyxl4ifj2oJlTmjFUfSvfzO+0xiF8
	xhAdeROJ66xF/mH7hBENoO9sW/XqRMaFAThPrT9HxTb1Z/cYEPOf0rcdoK0EZE9tDBSAWvgKqug
	TsiPbLu/juDOjYQhRjDuKn4eFOO5w+rs37/4sacVyPRsKs1GUKXuPm69F2DlXanNje2Hm195Izx
	iz3eB9WK5a/poxCP+KcYOgB4fWRBMOxDEDEkBbuo8C6fWNJFmseP5ud2PgveJW0kzfDKqUpq0xT
	7YsB3Q=
X-Google-Smtp-Source: AGHT+IHN1T8IjsJLPeQFfxJ0zE12+tdXYu3bnT6rjJ5iYU6llFZIq22ymrAKFvFStVURlAQL0Q1stQ==
X-Received: by 2002:a05:690c:f83:b0:722:7a7f:537a with SMTP id 00721157ae682-78ab6f01706mr75241757b3.38.1764111013150;
        Tue, 25 Nov 2025 14:50:13 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a79925ba4sm60138167b3.26.2025.11.25.14.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 14:50:12 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	skhawaja@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	akpm@linux-foundation.org,
	kees@kernel.org,
	davidgow@google.com,
	pmladek@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v8 2/2] tests/liveupdate: Add in-kernel liveupdate test
Date: Tue, 25 Nov 2025 17:50:06 -0500
Message-ID: <20251125225006.3722394-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
In-Reply-To: <20251125225006.3722394-1-pasha.tatashin@soleen.com>
References: <20251125225006.3722394-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 30FD614000E
X-Stat-Signature: 9xnki45mdez44n8n3ffbtq3yk4kqzwu6
X-Rspam-User: 
X-HE-Tag: 1764111014-106755
X-HE-Meta: U2FsdGVkX187aKpLJN5LDC49ef6ewUaaFDsgEwzrPZPv0mZlMlLg+crfIWXOaBiSpR4RaIB8dPfzVbhz/b9sLrvs3KLLAGYeRZGiH6o9qZC02DENDw9I8XmlcA1vhKiDIC5anok6woGRkMwt41TMTGcFwr2PUMTSANOEcHcGuL/If2RERhd1RCb+JSs1LMjWDqRPNEvM4walNDvZ3Kan0M4Gm5zQ6zk4B/oBkX+p2C9tSHzzKOHxKuxyf57guNmAge8cDOCU4JTQeKUkt86zub+MIMHZhSPK0le4n1lTa49YpV8KHP/1BW7v3Vs/ccLwoKp0C3gtyvncIYbhVzs/oNimNrCYTYxh8Oa9fcoaECEJNZgvkd6B6gyRL34cNPlVIbO8p88RiTRfw378Yqc7mGjVKObYnrGQFRcTz5PqMmgHyv72z5yjOnw5SyzxMmiNxnhjK4E+kK8h1Hao8W0U3eYzZuDrSLs8A/gaeWbwf8YqokfA8TuNfgZUpyNLcDV6/Lk4vJGU9+brI0qUKFLA2b5hZJCq7Xxar3lj6jYgLROPafWp3HbqyX2IxtEAO/QA1Nakq22srhOGZ0AMCLhc0BVA/lPz60ow0+v+tyWd53zGjXy2bIEYte0fNGhWNGIZsePRdE8CMevvtEKXhUYOARrmlj2NU644jpFPCRBi8cslocjzmvvDzDXbcq8k/gS2Iw/sD1BPYPvvKjxnkzQ31JbdTdP2AYjt8mgeDsCC4j3+NNPZXUwFqa3mb8cEawxE69XZZ1ZZVBDGFRw5NkjdWo+2Q8kWTj+iHGif0WEwtIe8niycevKXsFzTOrQ4MHphxKnDJJ8/tkNC0cKhvaC69a01USbLa+Tg8RuutOPE6HFhLn3bqJUBI7P8t62CTXKsg9Z3R0nb0FogcQRP7cmKPoL6I3aGL7B1K8I2+4c6ramOkFoOoYSyBcyqYmyJ0R0SD56hRp7eoW+1AdVQaJF
 01+dQ4C+
 8xSW3smyj8n+Ov1coR1ksCbysA9IIShdO8UZNKdf3Y2BetGJxriPwhPsrbVffuenoZfrNl+az7mugKrCdfiy+SEHVXI2LWWW0Qyxgn9uGkr+lHzjsESCNeztygK0qU3fbTZhNuTFLtChf64hTFBZls3p3JMZrc7/SL7QMug6mIeDOy7t0dmlCYbdpO4GHqZQN2J3HsgtThZUbyZMaMT744tkEOZl4zt93+/hlVIYt2v2/5OD6Tm108Q7f4PQ+ugjOjJfziGEe1kCNYfMYj6+8zxOS2+TEISyKPIqx1w5irQwy9FnjBAli3mzbKWaSkhjhuCT8qWaQcTkN+PY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce an in-kernel test module to validate the core logic of the
Live Update Orchestrator's File-Lifecycle-Bound feature. This
provides a low-level, controlled environment to test FLB registration
and callback invocation without requiring userspace interaction or
actual kexec reboots.

The test is enabled by the CONFIG_LIVEUPDATE_TEST Kconfig option.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 MAINTAINERS                      |   1 +
 include/linux/kho/abi/luo.h      |   5 +
 kernel/liveupdate/luo_file.c     |   8 +-
 kernel/liveupdate/luo_internal.h |   8 ++
 lib/Kconfig.debug                |  23 +++++
 lib/tests/Makefile               |   1 +
 lib/tests/liveupdate.c           | 158 +++++++++++++++++++++++++++++++
 7 files changed, 203 insertions(+), 1 deletion(-)
 create mode 100644 lib/tests/liveupdate.c

diff --git a/MAINTAINERS b/MAINTAINERS
index ce2da2d39786..2722f98d0ed7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14479,6 +14479,7 @@ F:	include/linux/liveupdate.h
 F:	include/linux/liveupdate/
 F:	include/uapi/linux/liveupdate.h
 F:	kernel/liveupdate/
+F:	lib/tests/liveupdate.c
 F:	mm/memfd_luo.c
 F:	tools/testing/selftests/liveupdate/
 
diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 2734d1020dda..4a1cc6a5f3f8 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -239,4 +239,9 @@ struct luo_flb_ser {
 	u64 count;
 } __packed;
 
+/* Kernel Live Update Test ABI */
+#ifdef CONFIG_LIVEUPDATE_TEST
+#define LIVEUPDATE_TEST_FLB_COMPATIBLE(i)	"liveupdate-test-flb-v" #i
+#endif
+
 #endif /* _LINUX_KHO_ABI_LUO_H */
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 6a29d20e9ed9..fca3806dae28 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -860,6 +860,8 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 	list_add_tail(&ACCESS_PRIVATE(fh, list), &luo_file_handler_list);
 	luo_session_resume();
 
+	liveupdate_test_register(fh);
+
 	return 0;
 
 err_resume:
@@ -891,8 +893,10 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
 
+	liveupdate_test_unregister(fh);
+
 	if (!luo_session_quiesce())
-		return -EBUSY;
+		goto err_register;
 
 	if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
 		goto err_resume;
@@ -905,5 +909,7 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 
 err_resume:
 	luo_session_resume();
+err_register:
+	liveupdate_test_register(fh);
 	return err;
 }
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 9732a7ca3d5f..6115d6a4054d 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -114,4 +114,12 @@ int __init luo_flb_setup_outgoing(void *fdt);
 int __init luo_flb_setup_incoming(void *fdt);
 void luo_flb_serialize(void);
 
+#ifdef CONFIG_LIVEUPDATE_TEST
+void liveupdate_test_register(struct liveupdate_file_handler *fh);
+void liveupdate_test_unregister(struct liveupdate_file_handler *fh);
+#else
+static inline void liveupdate_test_register(struct liveupdate_file_handler *fh) { }
+static inline void liveupdate_test_unregister(struct liveupdate_file_handler *fh) { }
+#endif
+
 #endif /* _LINUX_LUO_INTERNAL_H */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index bd3bb7a0c801..59b5ce8f89cf 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2803,6 +2803,29 @@ config LINEAR_RANGES_TEST
 
 	  If unsure, say N.
 
+config LIVEUPDATE_TEST
+	bool "Live Update Kernel Test"
+	default n
+	depends on LIVEUPDATE
+	help
+	  Enable a built-in kernel test module for the Live Update
+	  Orchestrator.
+
+	  This module validates the File-Lifecycle-Bound subsystem by
+	  registering a set of mock FLB objects with any real file handlers
+	  that support live update (such as the memfd handler).
+
+	  When live update operations are performed, this test module will
+	  output messages to the kernel log (dmesg), confirming that its
+	  registration and various callback functions (preserve, retrieve,
+	  finish, etc.) are being invoked correctly.
+
+	  This is a debugging and regression testing tool for developers
+	  working on the Live Update subsystem. It should not be enabled in
+	  production kernels.
+
+	  If unsure, say N
+
 config CMDLINE_KUNIT_TEST
 	tristate "KUnit test for cmdline API" if !KUNIT_ALL_TESTS
 	depends on KUNIT
diff --git a/lib/tests/Makefile b/lib/tests/Makefile
index 601dba4b7d96..ab0173e6e8b0 100644
--- a/lib/tests/Makefile
+++ b/lib/tests/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_LIST_KUNIT_TEST) += list-test.o
 obj-$(CONFIG_KFIFO_KUNIT_TEST) += kfifo_kunit.o
 obj-$(CONFIG_TEST_LIST_SORT) += test_list_sort.o
 obj-$(CONFIG_LINEAR_RANGES_TEST) += test_linear_ranges.o
+obj-$(CONFIG_LIVEUPDATE_TEST) += liveupdate.o
 
 CFLAGS_longest_symbol_kunit.o += $(call cc-disable-warning, missing-prototypes)
 obj-$(CONFIG_LONGEST_SYM_KUNIT_TEST) += longest_symbol_kunit.o
diff --git a/lib/tests/liveupdate.c b/lib/tests/liveupdate.c
new file mode 100644
index 000000000000..496d6ef91a30
--- /dev/null
+++ b/lib/tests/liveupdate.c
@@ -0,0 +1,158 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME " test: " fmt
+
+#include <linux/cleanup.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/liveupdate.h>
+#include <linux/module.h>
+#include "../../kernel/liveupdate/luo_internal.h"
+
+static const struct liveupdate_flb_ops test_flb_ops;
+#define DEFINE_TEST_FLB(i) {						\
+	.ops = &test_flb_ops,						\
+	.compatible = LIVEUPDATE_TEST_FLB_COMPATIBLE(i),		\
+}
+
+/* Number of Test FLBs to register with every file handler */
+#define TEST_NFLBS 3
+static struct liveupdate_flb test_flbs[TEST_NFLBS] = {
+	DEFINE_TEST_FLB(0),
+	DEFINE_TEST_FLB(1),
+	DEFINE_TEST_FLB(2),
+};
+
+#define TEST_FLB_MAGIC_BASE 0xFEEDF00DCAFEBEE0ULL
+
+static int test_flb_preserve(struct liveupdate_flb_op_args *argp)
+{
+	ptrdiff_t index = argp->flb - test_flbs;
+
+	pr_info("%s: preserve was triggered\n", argp->flb->compatible);
+	argp->data = TEST_FLB_MAGIC_BASE + index;
+
+	return 0;
+}
+
+static void test_flb_unpreserve(struct liveupdate_flb_op_args *argp)
+{
+	pr_info("%s: unpreserve was triggered\n", argp->flb->compatible);
+}
+
+static int test_flb_retrieve(struct liveupdate_flb_op_args *argp)
+{
+	ptrdiff_t index = argp->flb - test_flbs;
+	u64 expected_data = TEST_FLB_MAGIC_BASE + index;
+
+	if (argp->data == expected_data) {
+		pr_info("%s: found flb data from the previous boot\n",
+			argp->flb->compatible);
+		argp->obj = (void *)argp->data;
+	} else {
+		pr_err("%s: ERROR - incorrect data handle: %llx, expected %llx\n",
+		       argp->flb->compatible, argp->data, expected_data);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void test_flb_finish(struct liveupdate_flb_op_args *argp)
+{
+	ptrdiff_t index = argp->flb - test_flbs;
+	void *expected_obj = (void *)(TEST_FLB_MAGIC_BASE + index);
+
+	if (argp->obj == expected_obj) {
+		pr_info("%s: finish was triggered\n", argp->flb->compatible);
+	} else {
+		pr_err("%s: ERROR - finish called with invalid object\n",
+		       argp->flb->compatible);
+	}
+}
+
+static const struct liveupdate_flb_ops test_flb_ops = {
+	.preserve	= test_flb_preserve,
+	.unpreserve	= test_flb_unpreserve,
+	.retrieve	= test_flb_retrieve,
+	.finish		= test_flb_finish,
+	.owner		= THIS_MODULE,
+};
+
+static void liveupdate_test_init(void)
+{
+	static DEFINE_MUTEX(init_lock);
+	static bool initialized;
+	int i;
+
+	guard(mutex)(&init_lock);
+
+	if (initialized)
+		return;
+
+	for (i = 0; i < TEST_NFLBS; i++) {
+		struct liveupdate_flb *flb = &test_flbs[i];
+		void *obj;
+		int err;
+
+		err = liveupdate_flb_get_incoming(flb, &obj);
+		if (err && err != -ENODATA && err != -ENOENT) {
+			pr_err("liveupdate_flb_get_incoming for %s failed: %pe\n",
+			       flb->compatible, ERR_PTR(err));
+		}
+	}
+	initialized = true;
+}
+
+void liveupdate_test_register(struct liveupdate_file_handler *fh)
+{
+	int err, i;
+
+	liveupdate_test_init();
+
+	for (i = 0; i < TEST_NFLBS; i++) {
+		struct liveupdate_flb *flb = &test_flbs[i];
+
+		err = liveupdate_register_flb(fh, flb);
+		if (err) {
+			pr_err("Failed to register %s %pe\n",
+			       flb->compatible, ERR_PTR(err));
+		}
+	}
+
+	err = liveupdate_register_flb(fh, &test_flbs[0]);
+	if (!err || err != -EEXIST) {
+		pr_err("Failed: %s should be already registered, but got err: %pe\n",
+		       test_flbs[0].compatible, ERR_PTR(err));
+	}
+
+	pr_info("Registered %d FLBs with file handler: [%s]\n",
+		TEST_NFLBS, fh->compatible);
+}
+
+void liveupdate_test_unregister(struct liveupdate_file_handler *fh)
+{
+	int err, i;
+
+	for (i = 0; i < TEST_NFLBS; i++) {
+		struct liveupdate_flb *flb = &test_flbs[i];
+
+		err = liveupdate_unregister_flb(fh, flb);
+		if (err) {
+			pr_err("Failed to unregister %s %pe\n",
+			       flb->compatible, ERR_PTR(err));
+		}
+	}
+
+	pr_info("Unregistered %d FLBs from file handler: [%s]\n",
+		TEST_NFLBS, fh->compatible);
+}
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pasha Tatashin <pasha.tatashin@soleen.com>");
+MODULE_DESCRIPTION("In-kernel test for LUO mechanism");
-- 
2.52.0.487.g5c8c507ade-goog


