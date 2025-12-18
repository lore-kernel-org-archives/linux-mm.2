Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6C76D6E2AF
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 15:58:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7CC26B009D; Thu, 18 Dec 2025 10:58:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1CE36B00A0; Thu, 18 Dec 2025 10:58:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 932CA6B009D; Thu, 18 Dec 2025 10:58:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7AB8E6B009D
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:58:02 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 44ED91A01D9
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:58:02 +0000 (UTC)
X-FDA: 84233048004.14.5382053
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf10.hostedemail.com (Postfix) with ESMTP id 94901C0013
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:58:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BZUvleyA;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766073480; a=rsa-sha256;
	cv=none;
	b=hskT4IikQWR4p58XNsw5+lLYc4/5GaW1+sohpbhCz+lU4moNIVbLWcSkj8vPZHbPF6Rhlu
	jUCOiwF81RNe31ARRj1aMVpv/VIdK+8nJiCDpsrFQZ3wsC/B7oINwZws7rNCWViuw3682j
	139W6LM4H+7X+FB1P13uWW91Xe5/U2g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BZUvleyA;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766073480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AcOvnHWobOJImJ9+yLd9Iro//IQRqb2Fo3tMfUM+ra0=;
	b=KA/6UI7TABPp58oZHiOYmtLi0VJwi3KE81Dl2gUqL5upqjumiZDbssJDAC3+uZbfqlb8b+
	nM775zm4kZxsYJqx+orR4z94IId0vqa96fOrMe9SvF4w8PBbzyRW3H7OjXMNVabWb+l3gi
	UZ3VQykbEKFTuQtv8Ng/ll4yR6LQfFI=
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-787d5555274so7735857b3.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:58:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766073479; x=1766678279; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AcOvnHWobOJImJ9+yLd9Iro//IQRqb2Fo3tMfUM+ra0=;
        b=BZUvleyAIY28dEP5jTm2vMK6hwdj3Rjsa8zIWf1s/rcvlO/GRVV3Px+NnAu0c+6vS+
         L2pbw4c4pQAmfl5nFzEDbhacGzkX5PE8nNT+C+FVVGXlZSHalzz5XdvgCL8nY4MwWAGI
         X2PPNfhiRvrr3ZG+ucJrLxApIwSjJPp4ZG8tOzdHDXj2V/66sqg3av8t7H7LstIxjgXE
         IdnOduNUUZwqVKelg1rwXdDGPUF+1zi1WGbsqgmmFAk//GihhNkiarkAgcjgiwOZ4e+1
         vgy2kJ0u9oofbNvb69fA5a/01gsEH3JI/R+P3a3PMYw3vx6OWiVWPVxrTKOmjV02Oons
         59UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766073479; x=1766678279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AcOvnHWobOJImJ9+yLd9Iro//IQRqb2Fo3tMfUM+ra0=;
        b=JAKKNe0BJxstYC0gKMT7892cnTTUGioqkitvev38KZ9JYZGkfjOJ4qsExgXerCjYh7
         eZx5eKJ2NeqsTa+Ktk7bvKkA1D4klONynBSKpTkwVY1oKjxea5A1JsYEe24KhFTwjmGd
         D7oUtf3uIb/gHURYSFxBYM+KRzyruZTqrgUPOo5KXopVH+Sccva+6kYeGr+zDjinjcVX
         TGrHJrARYNbCmZF5nYpiqtBiV5T/GVIPft3W0dgJNuak8W3Neu+3ha4EJUxXykXsv+zF
         kdQlqcJXMgdvgUjO5UkW1cnnWu/kU4pvWq9R4nQuitpDKNfKopIRiMRJuPZ8l+QxyRlR
         9ppw==
X-Forwarded-Encrypted: i=1; AJvYcCW+1F4ObY3AlMsUvHVpQCo9KpPxJId89J5/6uJQ117YcTBY62CV7FFkPWr3pHrro/S1Il4JFG4oRA==@kvack.org
X-Gm-Message-State: AOJu0YxjkRevo7+CnfWr6n17uvTz0rklEIdfhJvYVv5tUIRxVmy5bxav
	nXjsonX3TGGs7fJH3jRXdTgxq3D5PuS88G9nd/oEV+KACI4XVGXRro5FrLKwvq5aqDs=
X-Gm-Gg: AY/fxX7JIYqVTZSHAdkageyvOtz7EbQktjpbRr9bSiiv6JyJz621Nu3bG7otP+5xveW
	zM+rfjKx85t7HY9dhTGtKGdxgwm6rzsxFdHuYBZsePNVI87FF/brtozsOAI1HLg8NTPnYjaQR25
	aUkUtgXztCQSWVWjeKW5qgz5DXjNVevrxJTzL+tqpU94VKXlSmAMEqONntiJw4wQDDUR6brq134
	yU8mcFczQidtWA0Af3oGooA84xeAxQX9gPoy2v8LxZKgT6nwe8By4OBRZsC+GcbWRJPsfANJT4h
	yTf6Ih5xXhe+ea9Qgk0vm3gpswXNL2+ZNbLLGRIvMkmtZx3HN7GBq2rEtDBuPDbVjZsxHZykW56
	pYOWgDw1iWTR/2UNzDPa2Yagvp3jfbXrXPdUpYgfTpQBV2uspfCoymycFoX+Dd9XjvGaRyU3vFP
	EjDi2onoMCvgb38h0wsfck3KNVpuY/cR4Bvk/dGjsPshDoSh68y42MS+rRZTNdXS2EyqCl5ep0O
	og5uowJzs4AKJuKmXT/ZFObAA4hTNeGVRb9A5FpuVWg0XbB
X-Google-Smtp-Source: AGHT+IEYVI4xmnIoyWHSo+wiOgJ8nZ11rScqcyjI/WOKq7qIsIfRW0MCIFb99g29Da6mCYYfpuOfzA==
X-Received: by 2002:a05:690c:3349:b0:78f:afb1:8cb9 with SMTP id 00721157ae682-78fafb1a6e8mr8750757b3.20.1766073479531;
        Thu, 18 Dec 2025 07:57:59 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78fa6f52bb2sm9348467b3.16.2025.12.18.07.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 07:57:59 -0800 (PST)
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
Subject: [PATCH v2 2/5] list: add kunit test for private list primitives
Date: Thu, 18 Dec 2025 10:57:49 -0500
Message-ID: <20251218155752.3045808-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.313.g674ac2bdf7-goog
In-Reply-To: <20251218155752.3045808-1-pasha.tatashin@soleen.com>
References: <20251218155752.3045808-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 94901C0013
X-Rspamd-Server: rspam04
X-Stat-Signature: k6rcpn5nqhnggo1c7tbqd7xnmw69eorz
X-HE-Tag: 1766073480-844005
X-HE-Meta: U2FsdGVkX19zgTdvAS0ysk0Xbdzz/HAbalSe13WL43lAEj2zkNjOQyGS5j4wSzIUCMonR2MtyXHzBtapIBYWJtptGP30sC8CXJX4/b+0L8or8BbqQvxbnmAyd/DTznJH0QZtngVFC7NLEUPBm4c8Prspbf5liKDKSe3qwgBfxU2VZVrGuwK4DZGoFtCSZcIZPeaCHuB1J5sDi9+YkGKh3gan8Cy5rSnumrATAXVLQlw2rFbn6rqGJO84c03vFM5bMaAnhnayqp3DjdPZ7jSGN4aLf0wX5a5EJ3OZACSiFCixsrycGD1CiFusoFL2xxNgQWlKAZ2H+QhczrbNYzwC02RJ+Rhq3ZBViRPccQzJqg5zhuIeNXD1njUeCk7DgmSMwjv8QQ6hLVY/oF29DfIpYw8JoRNYoN/UXnsgFYdA3A0Uh8TwO96SqLmZ46UU8XT9Yis9Eg9NeTNpZzRKX2R7IBas4Ot6IZhygcc2XuCeVq4eQO1FrK6OHfvLOnVbhU5ujUkEg6zXBmAMCJJzGomqvj6FCmHiEzMEU71RDIrrtECXRYAMye0H/C2NJg1SYEN8gM1xl8T+D1JUy9awku3YHkEVUjpZWEE4V56DfoB2J1aIEMXliiKaytgAsJLDJYdwqn5zzh8Bz0tnVwS5YB/OrfBiM0P7HCme/LTYEJ5PEOQEL1cSMXDCJUQLcG2dtOfwlQIr39TCGSHhmlhvf+sBE9F978SrW77VvoX9nCP1eEVkgqCzWKJmGwNPbcY3HRIUlpb8PxICGWvyX1Pw+gfsokF56uh/hhDEP3tgHPmIXtXe7FyRRMwmn7YCw0NPkGcWCS2MksWEkGPml2NrbOi3ZBPMnmxx29fM5LTqA4CFQ6e4jixiiwjyqQeaWrAILhZEM31x0coY18LiXl9BMsUfEuMmAzqYawzVIIozWrCCzzf/T0FBDYSZORxxk2vVbDgluzI7m+ZjoDaa/+v3EVY
 9n4808gv
 wxVoOwNMM9VmKb8E2ucUz68EWKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a KUnit test suite for the new private list primitives.

The test defines a struct with a __private list_head and exercises every
macro defined in <linux/list_private.h>.

This ensures that the macros correctly handle the ACCESS_PRIVATE()
abstraction and compile without warnings when acting on private members,
verifying that qualifiers are stripped and offsets are calculated
correctly.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: David Gow <davidgow@google.com>
---
 lib/Kconfig.debug             | 14 +++++++
 lib/tests/Makefile            |  1 +
 lib/tests/list-private-test.c | 76 +++++++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+)
 create mode 100644 lib/tests/list-private-test.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index ba36939fda79..0760b24f7cd6 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2780,6 +2780,20 @@ config LIST_KUNIT_TEST
 
 	  If unsure, say N.
 
+config LIST_PRIVATE_KUNIT_TEST
+	tristate "KUnit Test for Kernel Private Linked-list structures" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  This builds the KUnit test for the private linked-list primitives
+	  defined in include/linux/list_private.h.
+
+	  These primitives allow manipulation of list_head members that are
+	  marked as private and require special accessors (ACCESS_PRIVATE)
+	  to strip qualifiers or handle encapsulation.
+
+	  If unsure, say N.
+
 config HASHTABLE_KUNIT_TEST
 	tristate "KUnit Test for Kernel Hashtable structures" if !KUNIT_ALL_TESTS
 	depends on KUNIT
diff --git a/lib/tests/Makefile b/lib/tests/Makefile
index 601dba4b7d96..62a7f115f622 100644
--- a/lib/tests/Makefile
+++ b/lib/tests/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_TEST_IOV_ITER) += kunit_iov_iter.o
 obj-$(CONFIG_IS_SIGNED_TYPE_KUNIT_TEST) += is_signed_type_kunit.o
 obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
 obj-$(CONFIG_LIST_KUNIT_TEST) += list-test.o
+obj-$(CONFIG_LIST_PRIVATE_KUNIT_TEST) += list-private-test.o
 obj-$(CONFIG_KFIFO_KUNIT_TEST) += kfifo_kunit.o
 obj-$(CONFIG_TEST_LIST_SORT) += test_list_sort.o
 obj-$(CONFIG_LINEAR_RANGES_TEST) += test_linear_ranges.o
diff --git a/lib/tests/list-private-test.c b/lib/tests/list-private-test.c
new file mode 100644
index 000000000000..3bd62939ae67
--- /dev/null
+++ b/lib/tests/list-private-test.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit compilation/smoke test for Private list primitives.
+ *
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#include <linux/list_private.h>
+#include <kunit/test.h>
+
+/*
+ * This forces compiler to warn if you access it directly, because list
+ * primitives expect (struct list_head *), not (volatile struct list_head *).
+ */
+#undef __private
+#define __private volatile
+
+/* Redefine ACCESS_PRIVATE for this test. */
+#undef ACCESS_PRIVATE
+#define ACCESS_PRIVATE(p, member) \
+	(*((struct list_head *)((unsigned long)&((p)->member))))
+
+struct list_test_struct {
+	int data;
+	struct list_head __private list;
+};
+
+static void list_private_compile_test(struct kunit *test)
+{
+	struct list_test_struct entry;
+	struct list_test_struct *pos, *n;
+	LIST_HEAD(head);
+
+	INIT_LIST_HEAD(&ACCESS_PRIVATE(&entry, list));
+	list_add(&ACCESS_PRIVATE(&entry, list), &head);
+	pos = &entry;
+
+	pos = list_private_entry(&ACCESS_PRIVATE(&entry, list), struct list_test_struct, list);
+	pos = list_private_first_entry(&head, struct list_test_struct, list);
+	pos = list_private_last_entry(&head, struct list_test_struct, list);
+	pos = list_private_next_entry(pos, list);
+	pos = list_private_prev_entry(pos, list);
+	pos = list_private_next_entry_circular(pos, &head, list);
+	pos = list_private_prev_entry_circular(pos, &head, list);
+
+	if (list_private_entry_is_head(pos, &head, list))
+		return;
+
+	list_private_for_each_entry(pos, &head, list) { }
+	list_private_for_each_entry_reverse(pos, &head, list) { }
+	list_private_for_each_entry_continue(pos, &head, list) { }
+	list_private_for_each_entry_continue_reverse(pos, &head, list) { }
+	list_private_for_each_entry_from(pos, &head, list) { }
+	list_private_for_each_entry_from_reverse(pos, &head, list) { }
+
+	list_private_for_each_entry_safe(pos, n, &head, list)
+		list_private_safe_reset_next(pos, n, list);
+	list_private_for_each_entry_safe_continue(pos, n, &head, list) { }
+	list_private_for_each_entry_safe_from(pos, n, &head, list) { }
+	list_private_for_each_entry_safe_reverse(pos, n, &head, list) { }
+}
+
+static struct kunit_case list_private_test_cases[] = {
+	KUNIT_CASE(list_private_compile_test),
+	{},
+};
+
+static struct kunit_suite list_private_test_module = {
+	.name = "list-private-kunit-test",
+	.test_cases = list_private_test_cases,
+};
+
+kunit_test_suite(list_private_test_module);
+
+MODULE_DESCRIPTION("KUnit compilation test for private list primitives");
+MODULE_LICENSE("GPL");
-- 
2.52.0.313.g674ac2bdf7-goog


