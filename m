Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2B95D6D232
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 15:58:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F200D6B00A3; Thu, 18 Dec 2025 10:58:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E75B06B00A5; Thu, 18 Dec 2025 10:58:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6DCD6B00A6; Thu, 18 Dec 2025 10:58:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B4ABC6B00A3
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:58:05 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6DF9B12DB6
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:58:05 +0000 (UTC)
X-FDA: 84233048130.10.565064A
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id 97DB216000E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:58:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fOjOC0po;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766073483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y2GvxvWgw+C5A6znHXWAufIHkp3YvrzYE+ZzMWkjVVs=;
	b=jbzXrQWPcG9bxQK8kkOeNw1qoJSjT1cWXlh80VsutHngIfc56XGqVcmhjOIhox7faQY92M
	mDs+eIeTOBJUqJpNtcqpNkCTJeBnOE5SJy4XuTeSAGqM8bW7xgjArjVnPVDWIxQHOQxQB6
	yZqStsZmtrlXW6/e5ZrZOT5KL/RTguI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fOjOC0po;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766073483; a=rsa-sha256;
	cv=none;
	b=n1oTE8DSL6ADdSdoXqVJGBtAnJ8rJYymhA36oXBubB67J1DIppqfkbZMBUQC0kVjmUI3YP
	sqChYqqAHCbryMCeygutnC8N7pct/Ny1086OHoQWU0rRN0fyc7Zj0iGjnEtgVhcy64pjLi
	c4/qPtd9l5GSHoCuqXrJfEGAsNNvoZI=
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-64475c16a11so905351d50.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766073482; x=1766678282; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y2GvxvWgw+C5A6znHXWAufIHkp3YvrzYE+ZzMWkjVVs=;
        b=fOjOC0poCErZ1HXezy2XE5kqllypqU39HY76xJ+SEjr5y7CbNjul1UqRz5voYZCwe4
         SMZ0oEqdgGmwEMUhliLv/toB4v/zxa1nbBuZ6oNvsZHFm65XjFYb01OZvb7o+RJxAvdU
         Jw6Jody1uIcKRiYvbz/NePyNdwaDIOmX6BSszuf0DjZgaFeH2dvutb7SexfLSwb27KD4
         +IK0Nfqa+K8yOGaP814dwVlTMvYfMsMEOSbNTZ6gNrtAykAHla4rBJIXQfZFNKKzcZX6
         hhgI0+hDXpSkE0jEUascIAqEOcpGS79Ut+f8uWEsOZ09y/kBQ3eY+gzhs2ZBQUOuHCrC
         nwvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766073482; x=1766678282;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Y2GvxvWgw+C5A6znHXWAufIHkp3YvrzYE+ZzMWkjVVs=;
        b=P7zql/fD4v3RMs2PiBQwCJP4WD25dFyswYE5KReKaYseDq1b2Mstx/QBi918fcfi/e
         xem6X2Trf6COEdgtFqZqURhGZlo8cbarz2vwdsxFmSRxTSEt/WENFC7hgqurLOhGQzRu
         BSVez8xnnF/rYeH1aK6h1WUsgjiVa1lM1XGIKVLouOy+SFaI7MKfUBYSxFPHs7zegM/H
         1Yxma5S6J67mTnrFjEKuUFOWd1CBFKg1wxfBj/8P8MfUYeIarbikO4fVVPlumn9PLlfs
         +/J5dr+4y0g9QMRJy/JAhqViF6Gr+eIOIA5aOGrQFOH+ATobc7vqLQKfpdrSxq9tIROl
         bZQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCiS4JlXoKg0A0u9neOX29AkF21z680MVlqmnQQ06EaHN+Nw/gRt8nV2V471A63eSO/c10jnDV5g==@kvack.org
X-Gm-Message-State: AOJu0Yxm8bxziymg11ptAgyGVkFETF9g5Yi9WxUm2IfLutO1ZSvAOmee
	7sWKztQHyLp8EAjph6/GYr7zAszNFqPNbDmDNNHhQ16QZqVp4WK4RV5xLhDJnf30dLE=
X-Gm-Gg: AY/fxX7hLJgTU9jUIFqb7KB8omrBWo6hlTqtkBbZG7OIxr39IL01uvAExpwPavKoVP3
	8pdacFMJ2JJsE8CMgEsEnqW/Uc8sBdGEFGcikoZuT94AtTS65DJ+jiULrTf38R7YWYDjnYR858/
	wPTbPqSQU6B8uhVGVP23h9FvGwxMew1GNwBB0s+AIiWzKHm98q4FA6lnvYu6hTHS5uDQQ8S28u5
	WXTCPA6pJwcTDNlAfGQpXSucLHGDYTOD8gOtJMgLCfMXtBnLJAGGUoEztnXpnJE+Z2c1Dx64aWX
	KNK3q2T19FbCCesoJffhZqqvsdBrTc8JZFmjmPDWPD0uKXRhWxT4XQYjhUpl2O5hks1jyO2don9
	opXrRss8U9TYPCGxpIL+yp9UUlqXDsvxdLbqkYiej1VO2xmaumaUR0MA15FIQKJSZrzWfE3BHOc
	/RRJcktIpvnPqwK4+voIauXezT0aA2rXzMlrR9YcLZqFj3/Zj4vOpQWxngm3qodSB4768jR/wNK
	JBtVSQ3cuPNymnc9mjl2Gaaq4aX1Lk+UV0VXg==
X-Google-Smtp-Source: AGHT+IFmbIoqILeKHhuczXPRMgfqJxIXux1ceJzUQG9pkHU0LZvckHem2z07ZnG7v2PKrT/gLLGB4Q==
X-Received: by 2002:a53:c082:0:b0:63f:c487:17ab with SMTP id 956f58d0204a3-64555651309mr19343654d50.47.1766073482595;
        Thu, 18 Dec 2025 07:58:02 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78fa6f52bb2sm9348467b3.16.2025.12.18.07.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 07:58:02 -0800 (PST)
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
	linux-mm@kvack.org,
	nicolas.frattaroli@collabora.com,
	linux-doc@vger.kernel.org,
	tamird@gmail.com,
	raemoar63@gmail.com,
	graf@amazon.com
Subject: [PATCH v9 5/5] tests/liveupdate: Add in-kernel liveupdate test
Date: Thu, 18 Dec 2025 10:57:52 -0500
Message-ID: <20251218155752.3045808-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.313.g674ac2bdf7-goog
In-Reply-To: <20251218155752.3045808-1-pasha.tatashin@soleen.com>
References: <20251218155752.3045808-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1bk3a5uqikggw31rgne4twj5j5c3twj9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 97DB216000E
X-HE-Tag: 1766073483-981749
X-HE-Meta: U2FsdGVkX1/XA7JIpOk0X3s3k38oZ6RN98Zn4h2VRiwGjtwzQyKdtZLlRAJpoVcBGm8bvSCl7nfOCotJ2Dondb/oeNy0RxNlh1gCL+Yoi1bvaz3HIopqSMMoH8M0LDds11OjLFahe/GN6ywhLlvv2Ghcs5GGMzh9Io/UWIiddzIRPW0o6vw1fklXBou41v//Zsoiat3k3xJd/54FsftUFjTTKhD+rj3+lxzOpEJpbU0NWmbFE2bkj4KRdWAEaZmX31BBudTimuucVFvg4ZYsL9yjxyV74FJcWEvsyI7MxxLC5EpZQFCIMvH9qpxKYBQVJj1ikj/ETLVmbz52UcO4dSxR6y2BOpAZj+FiWSYqOGkwELLa+92QkVHs/1HqjiVH0gQuKJBTEGhtqUqREOV3aDYtlOuicz1OmZEog5Cn3mu8KHwxrVOyExeyDR4cGIKxlBBH7SHYTImXzmj9nOOlnAWTiuxeZmKEQOAyXxzEdI/7J3KDgmAxU5VceyrEp5rgYGDEBc2P2iztKWVNuLDh466bcbxlXV6shXr8U/zC4JOHSlJwwlA95MNPuRlzpyg2Ic42WUYtd5rpFjfgX92TaNQLfOgm+e/5Nz5ahB9SFc4ZkyzzM0mkgm+m8/x5y19PSi7ycCPwBWaEuUv97ggC9RYL3I3zxwaCHYy8vOdn7SWHsYtanqfh63iIrVB0jVsX5VazfR+zVJhr6XoXn6r54tsQ/+6ugAhkj+3FGdgH+LU4IvvXwIXTV+aNP8Cm0FfNc76vugFyfLSbd4zubvDUdxF6KnCFPI47+uyVhZI4A1lOIfThQI9Srtnt5EcMLxnG86DkLrqQZupXie3r4jyoTbQJQBAlCD1Pgwdt+IZDPvPifSth6fDvIjXIAOx/rDiE4NmbrTBX/Wv5Vxo3xFqugm8Uu93kMO9Nfyi715gdotqqZrEgV9VS82pQmkkdNbjgNngkv+hdIXDMkGEsXeG
 J+MCWTkr
 8vhEv8AW4IKhLRyBU4/a2mPV/DHBdU2m8RIJMzU8X2TYVfKLb9Jt+jFXes32WK1fJ4rgBOlhjwaxAH70Nh06KCoEmiD301YWj/+aTJcDY25Yv0DBIsYYZCNG4T0Wj4T8p4Dirdp597Z95VbgT7x/IrqrAalycm1+899sF8w3ZDghOh68j2Qs22C48j7O5n1M6y8tngG8+yaTMBm9Sl+YggZRvWM3qO3Bj7/H6r/u5D+B31ILXWoDLKM++x/TLucndXmnKhqU9wUAFpmQUhXpcRn2BpMKDG+Gk/dgI1KwncHvxge8Pgj23gF426sIOOUHVTE5ZJFZFfYf5aCo=
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
index 5b11839cba9d..dac0f87eba5b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14641,6 +14641,7 @@ F:	include/linux/liveupdate.h
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
index cade273c50c9..35d2a8b1a0df 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -864,6 +864,8 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 	list_add_tail(&ACCESS_PRIVATE(fh, list), &luo_file_handler_list);
 	luo_session_resume();
 
+	liveupdate_test_register(fh);
+
 	return 0;
 
 err_resume:
@@ -895,8 +897,10 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
 
+	liveupdate_test_unregister(fh);
+
 	if (!luo_session_quiesce())
-		return -EBUSY;
+		goto err_register;
 
 	if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
 		goto err_resume;
@@ -909,5 +913,7 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 
 err_resume:
 	luo_session_resume();
+err_register:
+	liveupdate_test_register(fh);
 	return err;
 }
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 99db13d99530..8083d8739b09 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -107,4 +107,12 @@ int __init luo_flb_setup_outgoing(void *fdt);
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
index 0760b24f7cd6..7c94961bf49d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2819,6 +2819,29 @@ config LINEAR_RANGES_TEST
 
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
index 62a7f115f622..439a99c8d32c 100644
--- a/lib/tests/Makefile
+++ b/lib/tests/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_LIST_PRIVATE_KUNIT_TEST) += list-private-test.o
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
2.52.0.313.g674ac2bdf7-goog


