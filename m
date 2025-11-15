Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10F1CCEBF86
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 23:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D6498E0007; Sat, 15 Nov 2025 18:35:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75FB28E0029; Sat, 15 Nov 2025 18:35:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51B778E0007; Sat, 15 Nov 2025 18:35:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3E1AE8E0007
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 18:35:05 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D626312EE1A
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:35:04 +0000 (UTC)
X-FDA: 84114449328.08.BD96094
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1D1698000A
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:35:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JxpafL0p;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763249703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=90EWWx4Mqnqhp1SMDUIMTw5wlXkO7ivVTgHSWLpFw+Q=;
	b=KWlt0Di9u2pOXy0CrpZUWhYwZP1a19Ba6tOEZtHBba7P+oqNZxSh0rVZZQFspB7tKUQk8+
	f8D8Xgj8DQOwe1fsvvEvaxgZEEnu3BqNW8rfoiFAkMigL9X7ePSiT13RjY8Vkkv9AIdhzO
	zbNKCHFY0g4j6L7HrSJlL4yax7wq8DE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JxpafL0p;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763249703; a=rsa-sha256;
	cv=none;
	b=Lnsi6jf6C3WKy7+wfkdccKsO7Ma5Z4gd0j8lHwVTJvAkjMHuuQpevANv5VmNAhnJ6q0+lQ
	V5a9909/pFUIFoxqdGIR7nfaCQtAYe1LwxIju4OdwlAluWBsMJ0Jo6OcgkM+UdaO2bl2f3
	D66/fARv2jTSQXnWcyOLWa7EOy7TuqE=
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-640d4f2f13dso3001824d50.1
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 15:35:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763249702; x=1763854502; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=90EWWx4Mqnqhp1SMDUIMTw5wlXkO7ivVTgHSWLpFw+Q=;
        b=JxpafL0pyR0fDNwK/foilrVhcWfLyrgdMQnVytmGDrB6qJ3IJGr3k6XK46+w2/sjuP
         j0+aI/J++KOYZ8ByQvbnSZqyiBx1vFePnfnWVutgBT0mvaxMFsWairmeWfsz1A3KGrMH
         WKSomSaTQzO0iLpXNqTE7+SXE//PZGiGfRg8WQdp6Ay/smmKrcXU8yW2pToirZ62AslO
         U7oV2LtR+gblhK2+2oPPptAzi2PWjFxs2hvubGwEtqhlYpp+5FgamVmGl064+tMPCrQ0
         j2Nh45DcLErZD+GtImQM/8JC0y8MQRD/yEOo1a/NikgqA3+mkUZNaloANobp8OeX51Ps
         sYYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763249702; x=1763854502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=90EWWx4Mqnqhp1SMDUIMTw5wlXkO7ivVTgHSWLpFw+Q=;
        b=rm4tF80AoUo74w5iGy/KehqODetJ1MZcNlYmkjT9WWxQS1VHU4RKXTjNnFhuzpiXQQ
         yr0t4mEccGrAz3VPY0eLGEAv+sz5wdQf81hLe3IHmRL9n3QLTenYgwWyLFhZEZlxAUYn
         Vr6SPEAYdWbrjNxT3KdozQKjkVLMhhYN+DUAMP6OJSDU9JimO3eKMB35dt69IuxolokG
         jqQdjePf/3xE/bYksT9u7dTwJQASz0rGK13Do2sGmF9krsosZbGr9pBCdCZ2WZcYm0JZ
         x6fZ2NmxWPrYt7GEwNwWzwtPfzMUUL3TIVLU2bEh2Q1/1MgqOGLQyhXK+i/Elsm1N/5G
         9wdQ==
X-Forwarded-Encrypted: i=1; AJvYcCWx87l21jaJwMkQrefNK6eivN1XQywipnVm8mIFSfSgZp6J5DkHsvCOOE+krJFCe+ksu+Q1pkVdmw==@kvack.org
X-Gm-Message-State: AOJu0YzuJCven3fHJCyMqdfwdr0ZUQeq0Eo+7iLFlbdLPwzYkvX/em59
	3YEd5PSFG+f+80eSuDES2SicyRUF0UHvnlhCSsivJnRCLMYCTVZQWuVsVKVF/RHVgYU=
X-Gm-Gg: ASbGnctonXYR9wZTdlkItLRIdCZJYRsSHf1T/Ja+nOyD1O9axrisdI7VK2/mzXFirAZ
	jx7376Gv4noHn6HazIkjm2qxmlqBzhatPzkeclzeH5WAwRmxbo81UqYo+kzkCEefDIj+PYNQmCR
	o5CxYMzSf1JWVtxinRYiDV+fRXacfquA1Tm6zkxZnkIdstLmt9feqK48Iy1q9B9EopFfW4AKxVO
	UOT7bqB2r7HmxrQXUmNJXnDU6drf4SpkNr3ldhFmXKkpgNu3BAqSFeFvUjQ3+BPTEqnQqz4BF7n
	/8i3T+UbvJRiOtRzJwFxrL89OC/58vh49T1NO7kw+Jd75hktbiL2hLeyQPRjmapp5bLv4+NwRv7
	cIE7k5FUITdyQONgSR06SmgLbzP6mI6Yt/ID9DggC871XppChDDbSJYdT1+nj0Tei+Hc6W/+1Kj
	zsp5p5a6/rrIyNjoo8Kp39shqlvglEHjFxiahvdigoV3cSExvTAD5ELAFQe4WUH7SnY1ZHdkiH4
	W9S5Wk=
X-Google-Smtp-Source: AGHT+IG/UxHvAnv9mWVe8wsyDfZKwfGnjYpnQZh3+Log3+EltTNlF7D6RJztgMPJcAoGZZph5wgzaA==
X-Received: by 2002:a05:690e:d02:b0:641:f347:5b57 with SMTP id 956f58d0204a3-641f3475ba1mr4093730d50.71.1763249702125;
        Sat, 15 Nov 2025 15:35:02 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7882218774esm28462007b3.57.2025.11.15.15.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 15:35:01 -0800 (PST)
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
Subject: [PATCH v6 20/20] tests/liveupdate: Add in-kernel liveupdate test
Date: Sat, 15 Nov 2025 18:34:06 -0500
Message-ID: <20251115233409.768044-21-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251115233409.768044-1-pasha.tatashin@soleen.com>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1D1698000A
X-Stat-Signature: 53h4c4yfsm8ztmah53ymhfka5xkb1hyf
X-Rspam-User: 
X-HE-Tag: 1763249702-374864
X-HE-Meta: U2FsdGVkX18h672T23PFp5Fwa1H+XdmbacKBPg3v7gMuP0cIpcZZWfzy9xRAlpX3PpA85mS2I3oUbDX1WH1Z5FAWVBsHlGThjSCIWUlad/YK16Jm3oaerUR6MIZGxO7sgMleRnCG9fKJE/DYUFKMX6F/0her/DBNDbREOJS6yF0DdTIVKIIo5gZCfUto0LW3lherjCYU+8M8whdFxNXUYBupoWjwD+bmyKLurgtgfdxMr6S80uovYreS/Es2cFvwQmDhITiCfphkVm9wvsMv2L+J5fFKEILC0ijKgeTo/GVB1ErEs0p9Xfj7im/19aCX3dpzhyCFGW+8pKMgFPR4gf1N3kzcOqy5SdKi/DPPry/xbopxpxVa+tY4KbI0ayESHWazST7B7gLZEHK2vEE/Cm0quK4zOun0qzxFaeTE35/0qLbTLOaM/iRNxsSUtd+9SsnP5cO4zc1V13NFto0hSE82Y61gYKbbC5ujyhKMV4hrcpPxTW+Btc+ZwT+NAVKdIaJhgbgEKGnVdib230KZiQPSZMcd8iiRsAhHQETEvTZoyC4Fh2tuqhk1oWp34DWLzrlOs51mvCGeiE3+9IzTLI2YNSSltkaSPR3ul2eCVzyJpw9cb5QDQq8s996IX6Io8zN5Aemcbws3s/vMp6AnpkXw7q9xDEygkCxtNpscnMPJ6wN5VusAI6oGH9ZnlSl2HXHrEeMsufQ9vDmJdKPdfS20BHs9tWR7A008lh2DHAitfBfShSjJCd3B2IYvM+P089B0vYmeF7IYUqJmMhevM5RHIwpnPqilPRkmQv3fxeoSgFuoKhPZOxP/QyDn4Zo+yFYUNLZQ93Bc3Lem9eWpb2inMiSkV75tvzzYfQJXdi4WwAX3mqaj9pKPnMDI6iR1QCtOKgjuoOykqd/UcwianN5Rr0wB0I1eaTZNHks35LHNK/sA2B1IGILm9XAhn8npo9cjXiaEX1j5KFP07KX
 YDGv9nN7
 n0ADfmfu9kuGtWfx92CZmIQODNfFpAkmFNeY631lUUxSNty28R8VtIgyeMf6TgTTVyoKYg3KxglrsdxFL2B+j0Ma9RfLgxD/G5ctBxaUv4vgviP/1N0AV+YygzA8cE/AJaubOBbmaBaesPcNzdKls9PX4skN4mzzKzPDJaXe2QkWbe5B9xetGzXBRORKmCa2aBeNJ/IQp0nqR/w4uY9Aavfhzr9LuQiP730sQ5jDoQN+odMX2EazNutwiM0DFPpKnwAYMpFjINIGAvCvFah5dAXesjCwsI11uTJbZqaWrHk5XJFJ2Ep9vlLwBa6ig8D5MU/JJriFI2VA3mUID1efvE3sML/LFNb/mR3ihNBSYVgFEw8oQe2FceRyI8Gf6clNYhmA8E/+KBjp8+oc=
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
 include/linux/liveupdate/abi/luo.h |   5 +
 kernel/liveupdate/luo_file.c       |   2 +
 kernel/liveupdate/luo_internal.h   |   6 ++
 lib/Kconfig.debug                  |  23 +++++
 lib/tests/Makefile                 |   1 +
 lib/tests/liveupdate.c             | 143 +++++++++++++++++++++++++++++
 6 files changed, 180 insertions(+)
 create mode 100644 lib/tests/liveupdate.c

diff --git a/include/linux/liveupdate/abi/luo.h b/include/linux/liveupdate/abi/luo.h
index 85596ce68c16..cdcace9b48f5 100644
--- a/include/linux/liveupdate/abi/luo.h
+++ b/include/linux/liveupdate/abi/luo.h
@@ -230,4 +230,9 @@ struct luo_flb_ser {
 	u64 count;
 } __packed;
 
+/* Kernel Live Update Test ABI */
+#ifdef CONFIG_LIVEUPDATE_TEST
+#define LIVEUPDATE_TEST_FLB_COMPATIBLE(i)	"liveupdate-test-flb-v" #i
+#endif
+
 #endif /* _LINUX_LIVEUPDATE_ABI_LUO_H */
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index df337c9c4f21..9a531096bdb5 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -834,6 +834,8 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 	INIT_LIST_HEAD(&fh->flb_list);
 	list_add_tail(&fh->list, &luo_file_handler_list);
 
+	liveupdate_test_register(fh);
+
 	return 0;
 }
 
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 389fb102775f..c863cb051d49 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -86,4 +86,10 @@ int __init luo_flb_setup_outgoing(void *fdt);
 int __init luo_flb_setup_incoming(void *fdt);
 void luo_flb_serialize(void);
 
+#ifdef CONFIG_LIVEUPDATE_TEST
+void liveupdate_test_register(struct liveupdate_file_handler *h);
+#else
+static inline void liveupdate_test_register(struct liveupdate_file_handler *h) { }
+#endif
+
 #endif /* _LINUX_LUO_INTERNAL_H */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 9a087826498a..eaa2af2bd963 100644
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
index 000000000000..05c05b8c1c22
--- /dev/null
+++ b/lib/tests/liveupdate.c
@@ -0,0 +1,143 @@
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
+	initialized = true;
+}
+
+void liveupdate_test_register(struct liveupdate_file_handler *h)
+{
+	int err, i;
+
+	liveupdate_test_init();
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
2.52.0.rc1.455.g30608eb744-goog


