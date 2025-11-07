Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 107D1CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 21:06:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE89E8E0022; Fri,  7 Nov 2025 16:06:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4B0D8E001A; Fri,  7 Nov 2025 16:06:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89D9F8E0022; Fri,  7 Nov 2025 16:06:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 716608E001A
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:06:18 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3C62212CB28
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:06:18 +0000 (UTC)
X-FDA: 84085044036.20.78D5EC4
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6790B4000C
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:06:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LC1gHQ4U;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762549576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zzZNGPgWx94ISN9X3lQ14PyLWRhGYF2GiiJN7CqbrDw=;
	b=y8zEoxoWwGODuXJtEQc/ErTmUtj+NJFExEj9SyRNjmM4icYss0pcsozDgEjMsoh0dzz9AX
	rHlk8eAaezTUl0jIV39+cO2rH9F058w5/W7T0i4RHIBq8XfEokyOTgYBjT+lBWzuh5Pi9i
	G2vFgFQnwHI3ErVPPTxeY3fpVQj5KME=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762549576; a=rsa-sha256;
	cv=none;
	b=lxe9Hl0JzRWTu4Ul47QXXCQO6i4Qi39sOmyiBKdJEpwKNCJ4Syk5EOXFrGODKzODzgc40I
	CuY8RRgTu7W5bLRs9MeUOZ9L1HHA/6+ElObX1VC02QSFy/4vnL7JZbXgF/rK0AvqKZBEJc
	VjepRicSFiBWD0MPRZBHMPA2x8xAmrQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LC1gHQ4U;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-781421f5be6so13910097b3.0
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 13:06:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762549575; x=1763154375; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zzZNGPgWx94ISN9X3lQ14PyLWRhGYF2GiiJN7CqbrDw=;
        b=LC1gHQ4UZK53jNLKhqb0+s1ia0oj3MtGTKCf2Z5O4ZNABN+/6TnEmWwqZkMiFcUDHK
         VApTszPBtbHXZppHbpO+MD4M3UprCJ/yNfAsHt6KFahSEXzhvE4Cgg6kzMIGzK0zTXfM
         IZotsXt1pa9kJPh8AIzcGksmZGxNhdm+tQrG3/J5S4Gv2acqTiQxS++ZbJiXqUN3G3ds
         lx1xH1Ovvwq+h60nLFDpINHbOC7dOQW29wQ0sQTKMcSlqfDRJCXo6+PeGRasbOaH9Y72
         H6WlwwkqTNH8oKO/gnqVfbzg389c2tQTkE6wpxi5eoiopw6B6NQxgRbjjO4RRLJOSMx1
         dqXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762549575; x=1763154375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zzZNGPgWx94ISN9X3lQ14PyLWRhGYF2GiiJN7CqbrDw=;
        b=eLKI4PzrAFEULMP4RYaAETQI0Uzez9anXKlT77qcCerb/iYbogkAjGbXNmwVsVRf/N
         ubL+T8jbIWaDLAYe4EtrME/d0vIhbm/u61tZl/Vso7Xf980LZIAarj3ELh8Kwv65niyX
         24lZOLphBQpVYbpZ41FPf0GKevGc8yfzi3kRTPs+ssBtI08tRzv7gHjAHvi2w3auf+YU
         SO3sMgk4IQ0hCZFWDd36/rEUXbPwDSJBmAObsN9mG7WIjLN1+x9sKqHClAQ+Q/BHdzsR
         8uJLgSVM6HvRjWrX6kJb4vBTAHoxWwomlQKy9NWAQTD7QFL05ktJSql9oO46XV566+pX
         YUmA==
X-Forwarded-Encrypted: i=1; AJvYcCXnjotDeBaQfsavAQKxtdmNinXtq00zdq3lt+KQ7sbNGYm7edDin5LoxXt1fQagUXpzuaYOnAu1TQ==@kvack.org
X-Gm-Message-State: AOJu0YzF5S9ewG91aa1+nbYZwM7fRN9+FLsfCT+dF88kzn/R/Q2N70b/
	JbzN0egxB6HIpF7lRUNlFkF9J1hRVMj/pHtp5gOiqJ4CwKZx1iWTIJ1atLKb/97Qtno=
X-Gm-Gg: ASbGnctEhKElHzDCZa4pdXuQpAwVhiTGpsSz8ZHXxxW+1/cQk+FLOjVNQ61PbCA0oKH
	+Txj4mrob29zpuWPewPQClPT4zQsVxUVKNTjYbqWoRvDLOKZo0dSkc3tM043YuCFMKx4h1ZHFrG
	/bpIaJB8FUKwbSz5ZWCMD2PpROgdwjjRRCdBiufaXyWtQKsfHPAn9byZtaKHQjeqzC1LfEKSzHR
	HRe/NHyRh6OByQKcSMBfJme44euUcSI7iFc/H7I/wNW30vb6dZUA1TB+P/mmE3jX3r9Ki3oFZ0d
	A2I+iZxTQT7J2K6HYsU0M+hMjL3ZrP/D4uj+4STVgVq5KTFWwvGEMceHCalfaK9pTemR3BQCWqv
	p9ftrpsPZSDN6ScIL35d9vsU+EONZZt4UXbZXhYlmYZ61ay34GmYrwhSQJOO4IbESQ2gpOrmcq5
	psIwzKjC7Wj179jw+UX4P0LsT49t5ykGjNsR96U6HjSp60zx9amONgmbKWWZnZ+giunqi1YRTK/
	A==
X-Google-Smtp-Source: AGHT+IHOz7qc/OdNH+hwEFR2mgMLzMFENl/tjweqpUXWP41GYcTPchZvuPAXTMaj9WvfxwDjBEwMvw==
X-Received: by 2002:a05:690c:690b:b0:786:6df0:8a36 with SMTP id 00721157ae682-787d53afd94mr7203087b3.29.1762549575032;
        Fri, 07 Nov 2025 13:06:15 -0800 (PST)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787d68754d3sm990817b3.26.2025.11.07.13.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 13:06:14 -0800 (PST)
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
	chrisl@kernel.org
Subject: [PATCH v5 22/22] tests/liveupdate: Add in-kernel liveupdate test
Date: Fri,  7 Nov 2025 16:03:20 -0500
Message-ID: <20251107210526.257742-23-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251107210526.257742-1-pasha.tatashin@soleen.com>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: thgcwab3w7edecxk1bgbpztt8diztj7y
X-Rspam-User: 
X-Rspamd-Queue-Id: 6790B4000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1762549576-92844
X-HE-Meta: U2FsdGVkX1/IXTzCpuSmswbSsmfwG3C8Vk8YPISLUddTOq6JVE1PihDkMTE/0B/RJBohNmVIrGlarB/LI53hF9m4N7xST9uvPXHZNNuu1Bqk0650KHnGFDK0h3tkbfU7ewX00oZOkyZ7LnJQGRNXvId4Ekrine1dkQCDarJfppNr9Z5jsE6rILDXjy+ejmFHhEEo2WKz8DihycKtL5wfwnfMsCekPZN8s5s4iwlv9v7d+eZC850UrjQr6oWSMcGif4lpoFe0GgIMQ9Akq7AcPPcva73CLx68BYAGpHrTNiPYqglDmy7qYki4i0IbIC1h0uolA1x7IeauilpkjWw8gztIYnUZxYiQhebCxDiaz2E7kbco71o7kdw8nmbiJVwo158YHLUSyOv61vo0jHTXs6zWyTj/wKhBfKwrFw/Ln8fFcvcxdeXX8yHJYFhKOZnhcfKTYqU+D3Sv+qQ09kOr/mnzxHp669DeOIzMSU1UYD9zTkLbSQq2+GeZcUnThRGjw0fh2hkysdpxAqQaJtVd2O9JRRogXrR+krOqwDiZLgg0ct9rjY82tm5quSR0AxBjDN2x9Hhg++H0/oI0dDafXGeQCTEBKfzfC1Iux2NDQ2wZGFXsTMBgMK2UFCTr+4L/UnjOVipcV76ukOKVk9qXNZyZuIwTpC4hVPF+Pjw9iMTO7gHc2AIvfGf3QGPLicC5dksLWmKyezx3loyDePUCfP7WNfOn270rmxUFWlYaOGqqlx81bzCLOfkYthgzP3kAi+ULKubsRF6GHRJZj7pm69Tixj6lhpMmILfS0b41wi8UqUDKkCL/dOXbPyRZTfJvRMOV5DgAmF9SbjbXNxlQxJPWNWJnMBztz7kvpRY+jauJ8f3w/kg85iu6kQpQtE689uDSfLgm8m9E1aYBofCo+4Ycb3vnHcARL7+9jTpi2O8Gop9lf5bWiOGPKZ7PuiJwvZ1TiwDkaR8FVD6S7Bq
 ACC0xOzG
 ZPuPJ3ZWq4J+JSxqqXyiqApC4kP50zL/YVgCv2rEoEvAWmOsbIsM0Ctgxdnw2oBEd3QLxmM60jdiG5FwZABsfHcMyxkCRNpUHdUpRd9p7pp3EeAFXys1bmQKx4TRqOzbQvDf7Vx3Q47Jqh5YE3AGxkIPC1/2uCRHGf2hChFvdy2okohWbzWEoppC+nFsuo0mZomGCyNbqMrKHRmYS4U1ZGDzM2sCsmt77OD83Wptx+N1ad/EWR3vdIQ6LweLWlbocwOemUBPpYfDwASRQVWg3yxEaUN0H/MWXzX8TeB5RUD6SdHnZhBGasLH4mGHOaY3JPJWuR+5m94lYFA1HRDylSitbsYEGOE4nf13dcx2e+k67sMsgoEWJigyRMy0DIkZIBYP9le4m+9CCg4I3510tkDBqrw==
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
 kernel/liveupdate/luo_file.c     |   2 +
 kernel/liveupdate/luo_internal.h |   8 ++
 lib/Kconfig.debug                |  23 ++++++
 lib/tests/Makefile               |   1 +
 lib/tests/liveupdate.c           | 130 +++++++++++++++++++++++++++++++
 5 files changed, 164 insertions(+)
 create mode 100644 lib/tests/liveupdate.c

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 713069b96278..4c0a75918f3d 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -829,6 +829,8 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 	INIT_LIST_HEAD(&fh->flb_list);
 	list_add_tail(&fh->list, &luo_file_handler_list);
 
+	liveupdate_test_register(fh);
+
 	return 0;
 }
 
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 89c2fd97e5a7..be8986f7ac9b 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -90,4 +90,12 @@ int __init luo_flb_setup_outgoing(void *fdt);
 int __init luo_flb_setup_incoming(void *fdt);
 void luo_flb_serialize(void);
 
+#ifdef CONFIG_LIVEUPDATE_TEST
+void liveupdate_test_register(struct liveupdate_file_handler *h);
+#else
+static inline void liveupdate_test_register(struct liveupdate_file_handler *h)
+{
+}
+#endif
+
 #endif /* _LINUX_LUO_INTERNAL_H */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index ddacf9e665a2..2cbfa3dead0b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2813,6 +2813,29 @@ config LINEAR_RANGES_TEST
 
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
index f7460831cfdd..8e5c527a94ac 100644
--- a/lib/tests/Makefile
+++ b/lib/tests/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_LIST_KUNIT_TEST) += list-test.o
 obj-$(CONFIG_KFIFO_KUNIT_TEST) += kfifo_kunit.o
 obj-$(CONFIG_TEST_LIST_SORT) += test_list_sort.o
 obj-$(CONFIG_LINEAR_RANGES_TEST) += test_linear_ranges.o
+obj-$(CONFIG_LIVEUPDATE_TEST) += liveupdate.o
 
 CFLAGS_longest_symbol_kunit.o += $(call cc-disable-warning, missing-prototypes)
 obj-$(CONFIG_LONGEST_SYM_KUNIT_TEST) += longest_symbol_kunit.o
diff --git a/lib/tests/liveupdate.c b/lib/tests/liveupdate.c
new file mode 100644
index 000000000000..62c592aa859f
--- /dev/null
+++ b/lib/tests/liveupdate.c
@@ -0,0 +1,130 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME " test: " fmt
+
+#include <linux/init.h>
+#include <linux/liveupdate.h>
+#include <linux/module.h>
+#include "../../kernel/liveupdate/luo_internal.h"
+
+#define TEST_NFLBS 3
+#define TEST_FLB_MAGIC_BASE 0xFEEDF00DCAFEBEE0ULL
+
+static struct liveupdate_flb test_flbs[TEST_NFLBS];
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
+static void test_flb_retrieve(struct liveupdate_flb_op_args *argp)
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
+	}
+}
+
+static void test_flb_finish(struct liveupdate_flb_op_args *argp)
+{
+	ptrdiff_t index = argp->flb - test_flbs;
+	void *expected_obj = (void *)(TEST_FLB_MAGIC_BASE + index);
+
+	if (argp->obj == expected_obj)
+		pr_info("%s: finish was triggered\n", argp->flb->compatible);
+	else
+		pr_err("%s: ERROR - finish called with invalid object\n",
+		       argp->flb->compatible);
+}
+
+static const struct liveupdate_flb_ops test_flb_ops = {
+	.preserve	= test_flb_preserve,
+	.unpreserve	= test_flb_unpreserve,
+	.retrieve	= test_flb_retrieve,
+	.finish		= test_flb_finish,
+};
+
+#define DEFINE_TEST_FLB(i) \
+	{ .ops = &test_flb_ops, .compatible = "test-flb-v" #i }
+
+static struct liveupdate_flb test_flbs[TEST_NFLBS] = {
+	DEFINE_TEST_FLB(0),
+	DEFINE_TEST_FLB(1),
+	DEFINE_TEST_FLB(2),
+};
+
+static int __init liveupdate_test_early_init(void)
+{
+	int i;
+
+	if (!liveupdate_enabled())
+		return 0;
+
+	for (i = 0; i < TEST_NFLBS; i++) {
+		struct liveupdate_flb *flb = &test_flbs[i];
+		void *obj;
+		int err;
+
+		liveupdate_init_flb(flb);
+
+		err = liveupdate_flb_incoming_locked(flb, &obj);
+		if (!err) {
+			liveupdate_flb_incoming_unlock(flb, obj);
+		} else if (err != -ENODATA && err != -ENOENT) {
+			pr_err("liveupdate_flb_incoming_locked for %s failed: %pe\n",
+			       flb->compatible, ERR_PTR(err));
+		}
+	}
+
+	return 0;
+}
+early_initcall(liveupdate_test_early_init);
+
+void liveupdate_test_register(struct liveupdate_file_handler *h)
+{
+	int err, i;
+
+	for (i = 0; i < TEST_NFLBS; i++) {
+		struct liveupdate_flb *flb = &test_flbs[i];
+
+		err = liveupdate_register_flb(h, flb);
+		if (err)
+			pr_err("Failed to register %s %pe\n",
+			       flb->compatible, ERR_PTR(err));
+	}
+
+	err = liveupdate_register_flb(h, &test_flbs[0]);
+	if (!err || err != -EEXIST) {
+		pr_err("Failed: %s should be already registered, but got err: %pe\n",
+		       test_flbs[0].compatible, ERR_PTR(err));
+	}
+
+	pr_info("Registered %d FLBs with file handler: [%s]\n",
+		TEST_NFLBS, h->compatible);
+}
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pasha Tatashin <pasha.tatashin@soleen.com>");
+MODULE_DESCRIPTION("In-kernel test for LUO mechanism");
-- 
2.51.2.1041.gc1ab5b90ca-goog


