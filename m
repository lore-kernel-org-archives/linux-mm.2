Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C63BDCFD30D
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 22:24:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A94B66B00AD; Sat, 22 Nov 2025 17:24:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A44376B00AF; Sat, 22 Nov 2025 17:24:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 871676B00B0; Sat, 22 Nov 2025 17:24:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 71D946B00AD
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:24:43 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2E50FC060C
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:43 +0000 (UTC)
X-FDA: 84139673646.21.72ECC8B
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 53F8910000E
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JcBKAuhO;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763850281; a=rsa-sha256;
	cv=none;
	b=KhuvbJVS9Fc70UuWgGXeRrbCBcwdtMqJUio1eeYLbt3UtIHGxpNE8N/DaExL4PprKqn6r9
	O+L+RbLW1ZWC27BgCKvY/MAfyZGVKVgJy6bIhmQbTNTt8VLD3hp3um+jFHNC0Ha2yhDhab
	4YDg8peW6tNNC2eFHz3woLVdF3z8hjE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JcBKAuhO;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763850281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SLgQGl+Hg4wswsvyxx4Nha11zmSlja8dA+7nO+BHML4=;
	b=gPZ6lfvog/B9CApp3UjeD1HlF91CAeEaMMs/jWDnGc1YG3SWLrhyvRbxQ6Ivl3QCtxQkdG
	zkFc4holhlnFgn8yc8PskIhMvPD+AhsaHglOXAH+DzK1W4H0TmSdHsHI2BW+9APQiSJN7L
	dU9LpG1NAjTkBbhlRKRzXkJQHG5rLVU=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-787eb2d8663so47348997b3.0
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 14:24:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763850280; x=1764455080; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SLgQGl+Hg4wswsvyxx4Nha11zmSlja8dA+7nO+BHML4=;
        b=JcBKAuhO7faej2Zij66C1M6D9zrWDkO+VyVnHpBv2hjboPJO1/7mtzdU7eVEluJDBK
         P3U9JTkX85UwDd1DdCAqwlZUHkaOcBrFsBNCDh2d4ZV/KtzLWLYKwhwtrZMhYZvXCRY3
         tj37ylZYWI9X2hHWa7ZYfuLWGqGwT/+9+CEL26NY7Nb1+17pLsf3a+OgyBkImWcJMw3k
         6QmJ9wUen+I/U9oevMirSHQ94ywvNmI3J+8ip06exYpffXE++HIttHwCCO87mbOiZC41
         7XiUEc2RM2L56yNIPpMeZClS9N2/Ys2H485alOXmmQ578Ri2QTAcsbG+9Et42FdHi0HT
         ebTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763850280; x=1764455080;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SLgQGl+Hg4wswsvyxx4Nha11zmSlja8dA+7nO+BHML4=;
        b=hRoWUvO4+Q5Y25FE9vwCiWM1XfFQ//w1tKLX+JT6Z6IWY9vKno7K5TmodmF3HwGwal
         3KSUu0kvVgJW4CmD1OV+I5+WQo5NusEjxgBAAvsC1Nd26d2ZZR4EtTqYDYvyK42XGmOd
         emw6LuOxC9iO1mPkfAlj3l05Ueziq090GVinS1sRTZSoEkEt5ppWRvkvbBNbDdRFlmTY
         586aLznpXA6M3qD3b3COaI/dYAYn2ivqElq175f5b0bI8xtHv63VvkToqgCijFjPIq2J
         cNPeEv3KLKJfRb8/AetK8xZfWZKk0wy/2tbV4A3fZHGHK4Pk4LB8jHCCq8enam67tR3f
         cicw==
X-Forwarded-Encrypted: i=1; AJvYcCW0HOBCyJYD0YNGDIHBNT4C17LjpcOHVIrpONYTnHNfoDfJVUYTMpSKe6VkoyaSTXRffCfdIcN9ZA==@kvack.org
X-Gm-Message-State: AOJu0YxjE9zWJZpuALQSW97c+aRDozExMq7S453eMbtPoEDKrZc1Ljtp
	nvjcKuUfsNXEQlQ4u5F0U2YoPFLKQ5pgtE202nOajFtk+XQqmW5Je/NI2sdXB6f8Bg8=
X-Gm-Gg: ASbGnctqZIfYLRe85RQdR2K1Htx8h67Rn2U+s/iNyVzzeY6fQ48b2bSwwPNLnhUuqKy
	GKHpp41ZvP1S2u9fXzYM2/Z78tPEweYIleaoec8vggwEpMHjjbxVx6kAm4Ae87sM3mTgSUGa6gY
	dM5DV3gyz7dIpQr75AAmXSZlNLg3wHBt0vkPcBI7zpMIREUMBxfh4SPf1ahyozm4C0sO3LxsWF0
	L9tzjQcJv9OQEPgQEZ4ODYm4SZ61zxMnzeORZjtG+z3Fxga9p6rM/7qyajhVVqznj/ywQSkf86I
	uOM9k+p0qKaHwuhtE60Lq1J5YKgvGrztpAWf5btZWV4SIo0rXfwX9QRUX1YjiqTsmztOcf+TqRW
	cHVYO5xCJS8ZaC0oLcKoCTNRmfLoejTOJeLTUUOgUmtgo6dbEcVW5HcVu3LyfxpugV11nqo3g1V
	/x9y1Zts2Lb1rAoFV/Lqy84djJT0azHbj5na9zRwQWBXBjZLS+WHx3xl3i1sDIV7Fai7QtKDxIP
	iBbMLA=
X-Google-Smtp-Source: AGHT+IFmO7ei26IBOwPIpZvds7E8L4kuDdnTnNInwjnST8wDDHfpSKCkMuKQ93csT8hxrCzaE1kAPQ==
X-Received: by 2002:a05:690c:6e03:b0:786:4949:b18d with SMTP id 00721157ae682-78a7b9ba83cmr88000807b3.4.1763850280347;
        Sat, 22 Nov 2025 14:24:40 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a79779a4esm28858937b3.0.2025.11.22.14.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 14:24:39 -0800 (PST)
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
Subject: [PATCH v7 22/22] tests/liveupdate: Add in-kernel liveupdate test
Date: Sat, 22 Nov 2025 17:23:49 -0500
Message-ID: <20251122222351.1059049-23-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
In-Reply-To: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 53F8910000E
X-Stat-Signature: ktr1xwsjuemfaoq5un6wdnbh6msiby7p
X-Rspam-User: 
X-HE-Tag: 1763850281-259635
X-HE-Meta: U2FsdGVkX1+qmS5ESc73vqMUENtW0pnMFvJyvK6/3e2XZLyjgIv0QkKoXWwL2BNNY1+SjcCnjJE4vp5oLb6ojFTVxaV0f3gMdd/OgdRCg/wGM+1tByaVyHIgCnZPXenGwi5FqcTEuEfyRQpiboeKC6T5sR4Hv5VCAc+QhdzQ+UPytRgYwTn8Gibbd7wi+YfEMEyAxU0IPs/5blwEv3KxzyZw6s0buvD4wINQ5N1qjKvxfq3/Uh9hLBS/M8InvuToemsBh6ViA25zmR3YCsygowZ/7W1x+0tnsbHvQgkwB7E99nETzGXALBVhbnhxYu0nK0XyCGGZPIXl+uOzBaZcidXjGrIlg/tPDe1ydLgwt2rKegaTO9GxWizq7bfsDQeQk2NZSevzAW2h6iryXsm/diwcii0XNy8cJDPboYoXrOXfQMhI6eWKe0Wp4WDCRRveQ9lRIHq5viQmH+m/cJevkLQSxQCCSA3PH1Oef4PXUrfCtY2KP3a7aUWquKcxDDoS/hCHbm//MSsVWEtz5kcqCcbmk4iI7jJlIK2ORVDQji575YHRXgxogSMlMLEewldcs53nXg9fgPIdRwjpiBK2z7wgSANL66No82BnGbCKEEuotAZ0hVwpJM+J9mPqU/S9A8NovE6lXteaMCv9j9715+eOxNEiHAz0WFXFXObNtvJ0mBCyJvXa1IDVDMSdaBqDn+eTn5q/xf7/+/QagnEodL8cp7RG6LPqsqKujbcFe5PiKCcBHXMNVYJpWSQjk0hWYW0hx/kvA9+lOP7cff8uYlY/FfYH1kFApkmOYHTaTq0z2FrSuZYyq+d5HnhCNMjRtmyT5IFHrZxj8QMw7eOn1d7XUoYy6MO/k3IWDAdKlsHqIIGDIMpaSiAwBCH6a7TcQJx8lEo638EjO0LHOdFaRZNk9MJ1n+k86meIlid5QhN8QXyG0PSL6XbSB4GzKhRLPES+gNIPFr/GdBM6wUg
 kHjNROa+
 tHbRosr+LMtN08aUUaNfPospY9VfkzQXoe9yVnWnao6fipa16bp+j4VRHpUGxyF8BYu2ciiRmd2tsPxiP67KRBlpiTXHor1Z25StlNvS/7hAzdNyr8dEy8MF+9jGRNMzSYFWAHElGNpAXRAIJ/k+aQXJwkAHPcGodFc2RKpVwYs17Xr8/93FwY43vXhnorCIwS6/VZug9PRSdqsM4E4/UeWxt9bDWYtgnQD//czLzlzDBtlbteKitsXCJi7jeO8p6NvcFV5mOr2cfniAo44IMhRMVwQU6QnOEKGSnmYTB8VBJYnHNZ6asQBcuRqUDMk6SifkF+00D+H1Y5lRuxS4VmluUb8l0M8lWkhbv9KLIfX1UkHAvpfBjSURwnodMk3z+tzYIWHMq42RoS51DmXzMOKIR6A==
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
 include/linux/kho/abi/luo.h      |   5 +
 kernel/liveupdate/luo_file.c     |   8 +-
 kernel/liveupdate/luo_internal.h |   8 ++
 lib/Kconfig.debug                |  23 +++++
 lib/tests/Makefile               |   1 +
 lib/tests/liveupdate.c           | 160 +++++++++++++++++++++++++++++++
 6 files changed, 204 insertions(+), 1 deletion(-)
 create mode 100644 lib/tests/liveupdate.c

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index ea21ad1535bf..db2fd9611334 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -235,4 +235,9 @@ struct luo_flb_ser {
 	u64 count;
 } __packed;
 
+/* Kernel Live Update Test ABI */
+#ifdef CONFIG_LIVEUPDATE_TEST
+#define LIVEUPDATE_TEST_FLB_COMPATIBLE(i)	"liveupdate-test-flb-v" #i
+#endif
+
 #endif /* _LINUX_KHO_ABI_LUO_H */
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index ecaa93bbcb12..94eb8a13676a 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -868,6 +868,8 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 	list_add_tail(&ACCESS_PRIVATE(fh, list), &luo_file_handler_list);
 	luo_session_resume();
 
+	liveupdate_test_register(fh);
+
 	return 0;
 
 err_resume:
@@ -899,8 +901,10 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
 
+	liveupdate_test_unregister(fh);
+
 	if (!luo_session_quiesce())
-		return -EBUSY;
+		goto err_register;
 
 	if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
 		goto err_resume;
@@ -913,6 +917,8 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 
 err_resume:
 	luo_session_resume();
+err_register:
+	liveupdate_test_register(fh);
 	return err;
 }
 
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index fa9d2a77c394..ee1db7ebee4e 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -130,4 +130,12 @@ int __init luo_flb_setup_outgoing(void *fdt);
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
index 000000000000..cf30d53668b0
--- /dev/null
+++ b/lib/tests/liveupdate.c
@@ -0,0 +1,160 @@
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
+		err = liveupdate_flb_incoming_locked(flb, &obj);
+		if (!err) {
+			liveupdate_flb_incoming_unlock(flb, obj);
+		} else if (err != -ENODATA && err != -ENOENT) {
+			pr_err("liveupdate_flb_incoming_locked for %s failed: %pe\n",
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
2.52.0.rc2.455.g230fcf2819-goog


