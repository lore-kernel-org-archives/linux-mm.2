Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92572C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:49:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6FA76B013F; Wed, 23 Jul 2025 10:48:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1FFF6B0140; Wed, 23 Jul 2025 10:48:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A99836B0141; Wed, 23 Jul 2025 10:48:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9515B6B013F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:48:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 460301606CD
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:48:03 +0000 (UTC)
X-FDA: 83695809246.26.C42EA59
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id 678C3100004
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:48:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=D75HdSuQ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282081; a=rsa-sha256;
	cv=none;
	b=ESIwAzt51wx7Tr1huG5xNGDWCDs+Iv/bFzr/OtLdfCIFr4xx9hp2Qyql06t7HmFxAjwsBD
	xnlL++RT77KZbIfceJvx5Eq2kt8l7uNyNL9MyU1Kgm7CXAs4tugNXaJEGf2hkToErsf2RI
	MfOceJzfAz37W65dDA6P+MK3gcT0L1g=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=D75HdSuQ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=60o0+pILn7oYpaQU4GzfpCaIJI/wVLOztDCQbTE/8Fw=;
	b=VLzpsBNgeisYlAwOJnFgH3fHqaB0clcvStpkxM93uwYtMPozJ8ZMMhklYhGUj6+NLYoiXw
	WDi6CozdP3TBGjDrfMxwKc0AGKJsyLJBXQsqKN6fl3CWG9B5FoeQ5tCDW2+5kHbnUFXeLM
	iIS4HU49P4/UMgXwS5RYFt0kY7gvqVA=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-70e75f30452so44742967b3.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282080; x=1753886880; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=60o0+pILn7oYpaQU4GzfpCaIJI/wVLOztDCQbTE/8Fw=;
        b=D75HdSuQHoZ4LrlL7+8j9JBWK9HU6m2xY0Zkc2+/pkighrtP6Rfu083uJxWpeBxTQF
         FrMRelztGDvMY5QmwLs2peC4PrLptiQwbTJUK183LFIBvQD+EAVwsiYvSrkXF2mJkrRx
         +TdLMF5lrJR2riXZA+Ces3g1QHHkZ9hu0h9f3UEw+nsQjEuIOPq4OD3yQpVadlrFV7mx
         UvW7sWGvHyw2/IpbfBvYDUsLaA/oGgExaOvR88Jufb0Bkak4UgFTh4HXSHsfszo9XOI6
         JwHaCwmpmHPasBJGEDZDhQ3Zz1mdg0f/iul+j8k/mfvYEHN7w8fMy/xcrLl64Y++KiCn
         6wYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282080; x=1753886880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=60o0+pILn7oYpaQU4GzfpCaIJI/wVLOztDCQbTE/8Fw=;
        b=mF776QOGalZF2YzApUkzQ1RNZKOLlTnHuC7jQQOhrM4fXCnThy0XMpwFZyKaFYccgQ
         F64QjxMOKulPYU/6B5YtjZE8CLN0arlKQsxdSK/rZ6r+UUx1WBm3Fl26c4CC4oo62moI
         MKxzF6O5JNSw+8SqLEq7vRx/2TLPSODHf4h9YB2lE5KfuQbhelF713YuAko+9vKnqMqh
         JSY68DUo61dkpxX/eqMHT5fXLnJp8N7/pYZCgl4AqROBEja09/3r5+NImEiJrOS4EwYe
         w9dK9AwltNmFm8dzQ/ytFW/Hj9gJNWfX1vasYVzxemWohe+Ls65K3n1QSe2Z6SE6yeoj
         BFIg==
X-Forwarded-Encrypted: i=1; AJvYcCXUqQ+Ehxjs+9XM6RotTR6an6+FopcadXTeAo6K9RIe/IiIWpzGV68fNpyge9TmQzImJPmncrAPPQ==@kvack.org
X-Gm-Message-State: AOJu0Ywr78KWKdLbDygR2xWNPzU33g4NSWrPHw8+gKc5no7+nBqXl/9L
	5Zu7JTpHrUerVwD/o0pE2aavz2cp0c6ZuVmKpjt6RLYF8k2VlasN3NxxFZ1U/F1Oyfs=
X-Gm-Gg: ASbGncvnpvfengtJ8DNs9UTOT6B6lUvsKoQPi9LByHN95g5nUVsR+ZLbxIbKLGFQ0ZF
	/CLI0wVPZfdnKX0DCFRH3Jd9ZT+HtTJVK5blI/v84VNyeJsz5dA8tcGfglm+1FA8tUevmX68dZ5
	kZI5FTuGVExkzPsrMhjiCkru6IfREhAe3nE1zAzPLNwlq/fz008c6d5YbjwVw8+ZyC4hhAnknZO
	pVdhiPayH9u6BMfy2XXstOM6Xx5pgMgdrhytMrFKKDYLtfT1Zl/hzacGUxh4B6qqu9McLvTwlaX
	QCigdpSVAox6ir9NK0mLhsRUXGefnAiz5V7Bru9T0tkXvWhhYcrZUR1vUBeAVN8zq2+zncvUxXV
	PNgaQHtkXMFDj5NQQl2l3qY7aiLIRkfkd6LJ+70ABWD9NMFWowbU+7vWvdrj7avOBRnJ54tQeKu
	TIj/JcOhyqID4Nsw==
X-Google-Smtp-Source: AGHT+IEHR5YhXNXKqQu5cYnYQfYX3NmO3Uw1youtd2STD6HMFKwDB0cE2+RVBh3uuo0TCOuCIAe/Cw==
X-Received: by 2002:a05:690c:3391:b0:717:b35b:94d1 with SMTP id 00721157ae682-719b42089f0mr42556337b3.9.1753282080302;
        Wed, 23 Jul 2025 07:48:00 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:47:59 -0700 (PDT)
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
Subject: [PATCH v2 32/32] libluo: add tests
Date: Wed, 23 Jul 2025 14:46:45 +0000
Message-ID: <20250723144649.1696299-33-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 678C3100004
X-Stat-Signature: g65ugiz6wxn8qd13sx9qioi8ws7d93ui
X-Rspam-User: 
X-HE-Tag: 1753282081-343907
X-HE-Meta: U2FsdGVkX18WOQTklrIq1fwCBVn1UaEuzQx6DgaCzAvglnUBjkBOYezIjIE4QapB/nLP8I+JpomrRumYkzDc3SCSnQgLPg8QOL6QS3nJNi1lASDtjFOAu+pobEQAKEgUuMTQ01EuNBU4lw6elbbyi1HBMVyJP59MeW3IJ5yL5oYCx8qCIj8jL1WwAlLm+as5ahfxIlQIkuiuPUTYLoFcsawuwDGBKQtbcEGl6Xl2jqWpFvG2kMHbEjlKH7gTCRVytl7gKeWxYUECpav49x3kANpC+Z29vMpdR+SVS51SofgRHSScwB5Q0y6kd9EE8m1C5P+zorjCF8N73h8jJSbcGk0ClTge/z7UGGQNk+9ZCTgIcoJ34N7vIHtZQ9uMFzpQMJ2g//zukuBMC3w4/i1O9s1+btJhGgU34l8PdQ0vogwp3HZKZKzJedGTVJtMqpMXZkxw+sBOky3zhWizTWBH9AwDRUwztco6gXy96G3cxkDvPMGzf2Yc/1O6UW/BkfZKme8zOZhvGPO8Y/FN7bIseBGeQYQzvIr0MAXn6osiXZBuJqkgWXoEQr6CfBTvW4a03UKMsuYEiMte7cIRR3ZIKlQAyWY8uLeg374RjjYMb+SLuqGKuAr34o5owhz0xDujabZhSgisLTAb0DjkCcu46D/7Z3JtWLeL7zaLcu+rB3XgNNJQdO8Ma3EGntRiSukHJc7qVlcydtw8dABUy+ru4OeygZFd/e7+MqOx/oOdCEEfeaJ+yNconkCcDBvt5Le1oF9eQhHRX7VeQUvX21SrzQDC3xlWXSGo9szqeCAca/xIoEx3/RVTgGK4uLmn/Bhg+ix34bsExNzRGjhb4Cl73tPASNIUGYJ8GnjcmtRIiYLl9LqiIoW7mMwGVnFVq7xDGge2Fg27NDJxj/dvzw1jrJAD8ZJK9AypQkR0zfVj/7JsWiy/k9qeRsxaRFZxwNUweO1BNVQ/x60bg6K7/sI
 XEEcxI9c
 v0yTZqf+ipXtI/R6x69meJi3DbGcvqjlTv9vs/Bs+teux8qnA/yerEqDaKSIDosDb+3yE8gFbl8m4HmFUJ22QIrJK9N4HUOWtuuduypVuRYZajadTvA8SudCCZ8puO5Z8mu9l+5iewRI0Z/obHY7eVTRdJUfLPvYXmJl4hHfQ/o5J5YZ1hJF+shMBl9WtumeIPrWv+O7txmBCpw3V3AMoKRNZ3R4I501RHFkCV1ZHmeigHJ0RMSE1k2MrIbEa5sumyYiPcqGI6ZXbUaaLhB4Syh0TV3OBBLLjPABB3wS2Z1cw12UhScK9xj9kYtNyaXqVnI/daEMAphuvd1WkG7ohcSNcmEDG5D6N+Cx68etcURiVJJOMNQNPq7/6owBghCRAprTxsq0NFrWjzBxqPc5nb1kFLEH42ZxYCi5HBXXECeDzeq1chCA8yRa4LJIKMGP5LGSXnrT6S2w3TFeWOkpxL+f7elmdl3erBeqGXFP4ibOGQG7t6VSxviFSBnFfn7apl3RCC0pqrAfutgI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Yadav <ptyadav@amazon.de>

Add a test suite for libluo itself, and for the kernel LUO interface.
The below tests are added:

1. init - Tests the initialization and cleanup functions of libluo.

2. state - Tests the luo_get_state() API, which in turn tests the
LIVEUPDATE_IOCTL_GET_STATE ioctl

3. preserve - Creates a memfd, preserves it, puts LUO in prepared state,
   cancels liveupdate, and makes sure memfd is functional.

4. prepared - Puts a memfd in LUO enters prepared state. Then it
   makes sure the memfd stays functional but remains in restricted mode. It
   makes sure the memfd can't grow or shrink, but can be read from or
   written to.

5. transitions - Tests transitions from normal to prepared to cancel
   state work.

6. error - Tests error handling of the library on invalid inputs.

7. kexec - Tests the main functionality of LUO -- preserving a FD over
   kexec. It creates a memfd with random data, saves the data to a file on
   disk, and then preserves the FD and goes into prepared state. Now the
   test runner must perform a kexec. Once rebooted, running the test again
   resumes the test. It fetches the memfd back, nd compares its content
   with the saved data on disk.

A specific test can be selected or excluded uring the -t or -e arguments.

Sample run:

    $ ./test
    LibLUO Test Suite
    =================

    Testing initialization and cleanup... PASSED
    Testing get_state... PASSED (current state: normal)
    Testing state transitions... PASSED
    Testing fd_preserve with freeze and cancel... PASSED
    Testing operations on prepared memfd... PASSED
    Testing error handling... PASSED
    Testing fd preserve for kexec... READY FOR KEXEC (token: 3)
    Run kexec now and then run this test again to complete.

    All requested tests completed.

Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 tools/lib/luo/Makefile         |   4 +
 tools/lib/luo/tests/.gitignore |   1 +
 tools/lib/luo/tests/Makefile   |  18 +
 tools/lib/luo/tests/test.c     | 848 +++++++++++++++++++++++++++++++++
 4 files changed, 871 insertions(+)
 create mode 100644 tools/lib/luo/tests/.gitignore
 create mode 100644 tools/lib/luo/tests/Makefile
 create mode 100644 tools/lib/luo/tests/test.c

diff --git a/tools/lib/luo/Makefile b/tools/lib/luo/Makefile
index e8f6bd3b9e85..ef4c489efcc5 100644
--- a/tools/lib/luo/Makefile
+++ b/tools/lib/luo/Makefile
@@ -29,9 +29,13 @@ $(SHARED_LIB): $(OBJS)
 cli: $(STATIC_LIB)
 	$(MAKE) -C cli
 
+tests: $(STATIC_LIB)
+	$(MAKE) -C tests
+
 clean:
 	rm -f $(OBJS) $(STATIC_LIB) $(SHARED_LIB)
 	$(MAKE) -C cli clean
+	$(MAKE) -C tests clean
 
 install: all
 	install -d $(DESTDIR)/usr/local/lib
diff --git a/tools/lib/luo/tests/.gitignore b/tools/lib/luo/tests/.gitignore
new file mode 100644
index 000000000000..ee4c92682341
--- /dev/null
+++ b/tools/lib/luo/tests/.gitignore
@@ -0,0 +1 @@
+/test
diff --git a/tools/lib/luo/tests/Makefile b/tools/lib/luo/tests/Makefile
new file mode 100644
index 000000000000..7f4689722ff6
--- /dev/null
+++ b/tools/lib/luo/tests/Makefile
@@ -0,0 +1,18 @@
+# SPDX-License-Identifier: LGPL-3.0-or-later
+TESTS = test
+INCLUDE_DIR = ../include
+HEADERS = $(wildcard $(INCLUDE_DIR)/*.h)
+
+CC = gcc
+CFLAGS = -Wall -Wextra -O2 -g -I$(INCLUDE_DIR)
+LDFLAGS = -L.. -l:libluo.a
+
+.PHONY: all clean
+
+all: $(TESTS)
+
+test: test.c ../libluo.a $(HEADERS)
+	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
+
+clean:
+	rm -f $(TESTS)
diff --git a/tools/lib/luo/tests/test.c b/tools/lib/luo/tests/test.c
new file mode 100644
index 000000000000..7963ae8ebadf
--- /dev/null
+++ b/tools/lib/luo/tests/test.c
@@ -0,0 +1,848 @@
+// SPDX-License-Identifier: LGPL-3.0-or-later
+#define _GNU_SOURCE
+/**
+ * @file test.c
+ * @brief Test program for the LibLUO library
+ *
+ * This program tests the basic functionality of the LibLUO library.
+ *
+ * Copyright (C) 2025 Amazon.com Inc. or its affiliates.
+ * Author: Pratyush Yadav <ptyadav@amazon.de>
+ */
+
+#include <libluo.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <errno.h>
+#include <sys/mman.h>
+#include <getopt.h>
+
+/* Path to store token for kexec test */
+#define TOKEN_FILE		"libluo_test_token"
+#define TEST_DATA_FILE		"libluo_test_data"
+#define MEMFD_NAME		"libluo_test_memfd"
+
+/* Size of the random data buffer (1 MiB) */
+#define RANDOM_BUFFER_SIZE	(1 << 20)
+static char random_buffer[RANDOM_BUFFER_SIZE];
+
+/* Test IDs */
+#define TEST_INIT_CLEANUP	(1 << 0)
+#define TEST_GET_STATE		(1 << 1)
+#define TEST_FD_PRESERVE	(1 << 2)
+#define TEST_ERROR_HANDLING	(1 << 3)
+#define TEST_FD_KEXEC		(1 << 4)
+#define TEST_FD_PREPARED	(1 << 5)
+#define TEST_STATE_TRANSITIONS	(1 << 6)
+#define TEST_ALL		(TEST_INIT_CLEANUP | TEST_GET_STATE | \
+				 TEST_FD_PRESERVE | TEST_ERROR_HANDLING | \
+				 TEST_FD_KEXEC | TEST_FD_PREPARED | \
+				 TEST_STATE_TRANSITIONS)
+
+/*
+ * luo_fd_preserve() needs a unique token. Generate a monotonically increasing
+ * token.
+ */
+static uint64_t next_token()
+{
+	static uint64_t token = 0;
+
+	return token++;
+}
+
+/* Read exactly specified size from fd. Any less results in error. */
+static int read_size(int fd, char *buffer, size_t size)
+{
+	size_t remain = size;
+	ssize_t bytes_read;
+
+	while (remain) {
+		bytes_read = read(fd, buffer, remain);
+		if (bytes_read == 0)
+			return -ENODATA;
+		if (bytes_read < 0)
+			return -errno;
+
+		remain -= bytes_read;
+	}
+
+	return 0;
+}
+
+/* Write exactly specified size from fd. Any less results in error. */
+static int write_size(int fd, const char *buffer, size_t size)
+{
+	size_t remain = size;
+	ssize_t written;
+
+	while (remain) {
+		written = write(fd, buffer, remain);
+		if (written == 0)
+			return -EIO;
+		if (written < 0)
+			return -errno;
+
+		remain -= written;
+	}
+
+	return 0;
+}
+
+static int generate_random_data(char *buffer, size_t size)
+{
+	int fd, ret;
+
+	fd = open("/dev/urandom", O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	ret = read_size(fd, buffer, size);
+	close(fd);
+	return ret;
+}
+
+static int save_test_data(const char *buffer, size_t size)
+{
+	int fd, ret;
+
+	fd = open(TEST_DATA_FILE, O_RDWR);
+	if (fd < 0)
+		return -errno;
+
+	ret = write_size(fd, buffer, size);
+	close(fd);
+	return ret;
+}
+
+static int load_test_data(char *buffer, size_t size)
+{
+	int fd, ret;
+
+	fd = open(TEST_DATA_FILE, O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	ret = read_size(fd, buffer, size);
+	close(fd);
+	return ret;
+}
+
+/* Create and initialize a memfd with random data. */
+static int create_test_fd(const char *memfd_name, char *buffer, size_t size)
+{
+	int fd;
+	int ret;
+
+	fd = memfd_create(memfd_name, 0);
+	if (fd < 0)
+		return -errno;
+
+	ret = generate_random_data(buffer, size);
+	if (ret < 0) {
+		close(fd);
+		return ret;
+	}
+
+	if (write_size(fd, buffer, size) < 0) {
+		close(fd);
+		return -errno;
+	}
+
+	/* Reset file position to beginning */
+	if (lseek(fd, 0, SEEK_SET) < 0) {
+		close(fd);
+		return -errno;
+	}
+
+	return fd;
+}
+
+/*
+ * Make sure fd contains expected data up to size. Returns 0 on success, 1 on
+ * data mismatch, -errno on error.
+ */
+static int verify_fd_content(int fd, const char *expected_data, size_t size)
+{
+	char buffer[size];
+	int ret;
+
+	/* Reset file position to beginning */
+	if (lseek(fd, 0, SEEK_SET) < 0)
+		return -errno;
+
+	ret = read_size(fd, buffer, size);
+	if (ret < 0)
+		return ret;
+
+	if (memcmp(buffer, expected_data, size) != 0)
+		return 1;
+
+	return 0;
+}
+
+/* Save token to file for kexec test. */
+static int save_token(uint64_t token)
+{
+	FILE *file = fopen(TOKEN_FILE, "w");
+
+	if (!file)
+		return -errno;
+
+	if (fprintf(file, "%lu", token) < 0) {
+		fclose(file);
+		return -errno;
+	}
+
+	fclose(file);
+	return 0;
+}
+
+/* Load token from file for kexec test. */
+static int load_token(uint64_t *token)
+{
+	FILE *file = fopen(TOKEN_FILE, "r");
+
+	if (!file)
+		return -errno;
+
+	if (fscanf(file, "%lu", token) != 1) {
+		fclose(file);
+		return -EINVAL;
+	}
+
+	fclose(file);
+	return 0;
+}
+
+/* Test initialization and cleanup */
+static void test_init_cleanup(void)
+{
+	int ret;
+
+	printf("Testing initialization and cleanup... ");
+
+	ret = luo_init();
+	if (ret < 0) {
+		printf("FAILED (init: %s)\n", strerror(-ret));
+		return;
+	}
+
+	luo_cleanup();
+	printf("PASSED\n");
+}
+
+/* Test getting LUO state */
+static void test_get_state(void)
+{
+	int ret;
+	enum liveupdate_state state;
+
+	printf("Testing get_state... ");
+
+	ret = luo_init();
+	if (ret < 0) {
+		printf("FAILED (init: %s)\n", strerror(-ret));
+		return;
+	}
+
+	ret = luo_get_state(&state);
+	if (ret < 0) {
+		printf("FAILED (get_state: %s)\n", strerror(-ret));
+		luo_cleanup();
+		return;
+	}
+
+	printf("PASSED (current state: %s)\n", luo_state_to_string(state));
+	luo_cleanup();
+}
+
+/* Test preserving and unpreserving a file descriptor with prepare and cancel */
+static void test_fd_preserve_unpreserve(void)
+{
+	uint64_t token = next_token();
+	int ret, fd = -1;
+
+	printf("Testing fd_preserve with freeze and cancel... ");
+
+	ret = luo_init();
+	if (ret < 0) {
+		printf("FAILED (init: %s)\n", strerror(-ret));
+		return;
+	}
+
+	fd = create_test_fd(MEMFD_NAME, random_buffer, sizeof(random_buffer));
+	if (fd < 0) {
+		ret = fd;
+		printf("FAILED (create_test_fd: %s)\n", strerror(-ret));
+		goto out_cleanup;
+	}
+
+	ret = luo_fd_preserve(fd, token);
+	if (ret < 0) {
+		printf("FAILED (preserve: %s)\n", strerror(-ret));
+		goto out_close_fd;
+	}
+
+	ret = luo_prepare();
+	if (ret < 0) {
+		printf("FAILED (prepare: %s)\n", strerror(-ret));
+		goto out_unpreserve;
+	}
+
+	ret = luo_cancel();
+	if (ret < 0) {
+		printf("FAILED (cancel: %s)\n", strerror(-ret));
+		goto out_unpreserve;
+	}
+
+	ret = luo_fd_unpreserve(token);
+	if (ret < 0) {
+		printf("FAILED (unpreserve: %s)\n", strerror(-ret));
+		goto out_close_fd;
+	}
+
+	ret = verify_fd_content(fd, random_buffer, sizeof(random_buffer));
+	if (ret < 0) {
+		printf("FAILED (verify_fd_content: %s)\n",
+		       ret == 1 ? "data mismatch" : strerror(-ret));
+		goto out_close_fd;
+	}
+
+	printf("PASSED\n");
+	goto out_close_fd;
+
+out_unpreserve:
+	luo_fd_unpreserve(token);
+out_close_fd:
+	close(fd);
+out_cleanup:
+	luo_cleanup();
+}
+
+/* Test error handling with invalid inputs. */
+static void test_error_handling(void)
+{
+	int ret;
+
+	printf("Testing error handling... ");
+
+	ret = luo_init();
+	if (ret < 0) {
+		printf("FAILED (init: %s)\n", strerror(-ret));
+		return;
+	}
+
+	/* Test with invalid file descriptor */
+	ret = luo_fd_preserve(-1, next_token());
+	if (ret != -EINVAL) {
+		printf("FAILED (expected EINVAL for invalid fd, got %d)\n", ret);
+		luo_cleanup();
+		return;
+	}
+
+	/* Test with NULL state pointer */
+	ret = luo_get_state(NULL);
+	if (ret != -EINVAL) {
+		printf("FAILED (expected EINVAL for NULL state, got %d)\n", ret);
+		luo_cleanup();
+		return;
+	}
+
+	luo_cleanup();
+	printf("PASSED\n");
+}
+
+/* Test preserving a file descriptor for kexec reboot */
+static void test_fd_preserve_for_kexec(void)
+{
+	enum liveupdate_state state;
+	int fd = -1, ret;
+	uint64_t token;
+
+	ret = luo_init();
+	if (ret < 0) {
+		printf("FAILED (init: %s)\n", strerror(-ret));
+		return;
+	}
+
+	/* Check if we're in post-kexec state */
+	ret = luo_get_state(&state);
+	if (ret < 0) {
+		printf("FAILED (get_state: %s)\n", strerror(-ret));
+		goto out_cleanup;
+	}
+
+	if (state == LIVEUPDATE_STATE_UPDATED) {
+		/* Post-kexec: restore the file descriptor */
+		printf("Testing memfd restore after kexec... ");
+
+		ret = load_token(&token);
+		if (ret < 0) {
+			printf("FAILED (load_token: %s)\n", strerror(-ret));
+			goto out_cleanup;
+		}
+
+		ret = load_test_data(random_buffer, RANDOM_BUFFER_SIZE);
+		if (ret < 0) {
+			printf("FAILED (load_test_data: %s)\n", strerror(-ret));
+			goto out_cleanup;
+		}
+
+		ret = luo_fd_restore(token, &fd);
+		if (ret < 0) {
+			printf("FAILED (restore: %s)\n", strerror(-ret));
+			goto out_cleanup;
+		}
+
+		/* Verify the file descriptor content with stored data. */
+		ret = verify_fd_content(fd, random_buffer, RANDOM_BUFFER_SIZE);
+		if (ret) {
+			printf("FAILED (verify_fd_content: %s)\n",
+			       ret == 1 ? "data mismatch" : strerror(-ret));
+			goto out_close_fd;
+		}
+
+		ret = luo_finish();
+		if (ret < 0) {
+			printf("FAILED (finish: %s)\n", strerror(-ret));
+			goto out_close_fd;
+		}
+
+		printf("PASSED\n");
+		goto out_close_fd;
+	} else {
+		/* Pre-kexec: preserve the file descriptor */
+		printf("Testing fd preserve for kexec... ");
+
+		fd = create_test_fd(MEMFD_NAME, random_buffer, RANDOM_BUFFER_SIZE);
+		if (fd < 0) {
+			ret = fd;
+			printf("FAILED (create_test_fd: %s)\n", strerror(-ret));
+			goto out_cleanup;
+		}
+
+		/* Save random data to file for post-kexec verification */
+		ret = save_test_data(random_buffer, RANDOM_BUFFER_SIZE);
+		if (ret < 0) {
+			printf("FAILED (save_test_data: %s)\n", strerror(-ret));
+			goto out_close_fd;
+		}
+
+		token = next_token();
+		ret = luo_fd_preserve(fd, token);
+		if (ret < 0) {
+			printf("FAILED (preserve: %s)\n", strerror(-ret));
+			goto out_close_fd;
+		}
+
+		/* Save token to file for post-kexec restoration */
+		ret = save_token(token);
+		if (ret < 0) {
+			printf("FAILED (save_token: %s)\n", strerror(-ret));
+			goto out_unpreserve;
+		}
+
+		ret = luo_prepare();
+		if (ret < 0) {
+			printf("FAILED (prepare: %s)\n", strerror(-ret));
+			goto out_unpreserve;
+		}
+
+		printf("READY FOR KEXEC (token: %lu)\n", token);
+		printf("Run kexec now and then run this test again to complete.\n");
+
+		/* Note: At this point, the system should perform kexec reboot.
+		 * The test will continue in the new kernel with the
+		 * LIVEUPDATE_STATE_UPDATED state.
+		 *
+		 * Since the FD is now preserved, we can close it.
+		 */
+		goto out_close_fd;
+	}
+
+out_unpreserve:
+	luo_fd_unpreserve(token);
+out_close_fd:
+	close(fd);
+out_cleanup:
+	luo_cleanup();
+}
+
+/*
+ * Test that prepared memfd can't grow or shrink, but reads and writes still
+ * work.
+ */
+static void test_fd_prepared_operations(void)
+{
+	char write_buffer[128] = {'A'};
+	size_t initial_size, file_size;
+	int ret, fd = -1;
+	uint64_t token;
+
+	printf("Testing operations on prepared memfd... ");
+
+	ret = luo_init();
+	if (ret < 0) {
+		printf("FAILED (init: %s)\n", strerror(-ret));
+		return;
+	}
+
+	/* Create and initialize test file descriptor */
+	fd = create_test_fd(MEMFD_NAME, random_buffer, sizeof(random_buffer));
+	if (fd < 0) {
+		ret = fd;
+		printf("FAILED (create_test_fd: %s)\n", strerror(-ret));
+		goto out_cleanup;
+	}
+
+	/* Get initial file size */
+	ret = lseek(fd, 0, SEEK_END);
+	if (ret < 0) {
+		printf("FAILED (lseek to end: %s)\n", strerror(errno));
+		goto out_close_fd;
+	}
+	initial_size = (size_t)ret;
+
+	token = next_token();
+	ret = luo_fd_preserve(fd, token);
+	if (ret < 0) {
+		printf("FAILED (preserve: %s)\n", strerror(-ret));
+		goto out_close_fd;
+	}
+
+	ret = luo_prepare();
+	if (ret < 0) {
+		printf("FAILED (prepare: %s)\n", strerror(-ret));
+		goto out_unpreserve;
+	}
+
+	/* Test 1: Write to the prepared file descriptor (within existing size) */
+	if (lseek(fd, 0, SEEK_SET) < 0) {
+		printf("FAILED (lseek before write: %s)\n", strerror(errno));
+		goto out_cancel;
+	}
+
+	/* Write buffer is smaller than total file size. */
+	ret = write_size(fd, write_buffer, sizeof(write_buffer));
+	if (ret < 0) {
+		printf("FAILED (write to prepared fd: %s)\n", strerror(errno));
+		goto out_cancel;
+	}
+
+	ret = verify_fd_content(fd, write_buffer, sizeof(write_buffer));
+	if (ret) {
+		printf("FAILED (verify_fd_content after write: %s)\n",
+		       ret == 1 ? "data mismatch" : strerror(-ret));
+		goto out_cancel;
+	}
+
+	/* Test 2: Try to grow the file using write(). */
+
+	/* First, seek to one byte behind initial size. */
+	ret = lseek(fd, initial_size - 1, SEEK_SET);
+	if (ret < 0) {
+		printf("FAILED: (lseek after write verification: %s)\n",
+		       strerror(errno));
+	}
+
+	/*
+	 * Then, write some data that should increase the file size. This should
+	 * fail.
+	 */
+	ret = write_size(fd, write_buffer, sizeof(write_buffer));
+	if (ret == 0) {
+		printf("FAILED: (write beyond initial size succeeded)\n");
+		goto out_cancel;
+	}
+
+	ret = lseek(fd, 0, SEEK_END);
+	if (ret < 0) {
+		printf("FAILED (lseek after larger write: %s)\n", strerror(errno));
+		goto out_cancel;
+	}
+	file_size = (size_t)ret;
+
+	if (file_size != initial_size) {
+		printf("FAILED (file grew beyond initial size: %zu != %zu)\n",
+		       (size_t)file_size, initial_size);
+		goto out_cancel;
+	}
+
+	/* Test 3: Try to shrink the file using truncate */
+	ret = ftruncate(fd, initial_size / 2);
+	if (ret == 0) {
+		printf("FAILED (file was truncated)\n");
+		goto out_cancel;
+	}
+
+	ret = lseek(fd, 0, SEEK_END);
+	if (ret < 0) {
+		printf("FAILED (lseek after shrink attempt: %s)\n", strerror(errno));
+		goto out_cancel;
+	}
+	file_size = (size_t)ret;
+
+	if (file_size != initial_size) {
+		printf("FAILED (file shrunk from initial size: %zu != %zu)\n",
+		       (size_t)file_size, initial_size);
+		goto out_cancel;
+	}
+
+	ret = luo_cancel();
+	if (ret < 0) {
+		printf("FAILED (cancel: %s)\n", strerror(-ret));
+		goto out_unpreserve;
+	}
+
+	ret = luo_fd_unpreserve(token);
+	if (ret < 0) {
+		printf("FAILED (unpreserve: %s)\n", strerror(-ret));
+		goto out_close_fd;
+	}
+
+	printf("PASSED\n");
+	goto out_close_fd;
+
+out_cancel:
+	luo_cancel();
+out_unpreserve:
+	luo_fd_unpreserve(token);
+out_close_fd:
+	close(fd);
+out_cleanup:
+	luo_cleanup();
+}
+
+static int test_prepare_cancel_sequence(const char *sequence_name)
+{
+	int ret;
+	enum liveupdate_state state;
+
+	/* Initial state should be NORMAL */
+	ret = luo_get_state(&state);
+	if (ret < 0) {
+		printf("FAILED (%s get initial state failed: %s)\n",
+		       sequence_name, strerror(-ret));
+		return ret;
+	}
+
+	if (state != LIVEUPDATE_STATE_NORMAL) {
+		printf("FAILED (%s unexpected initial state: %s)\n",
+		       sequence_name, luo_state_to_string(state));
+		return -EINVAL;
+	}
+
+	/* Test NORMAL -> PREPARED transition */
+	ret = luo_prepare();
+	if (ret < 0) {
+		printf("FAILED (%s prepare failed: %s)\n",
+		       sequence_name, strerror(-ret));
+		return ret;
+	}
+
+	ret = luo_get_state(&state);
+	if (ret < 0) {
+		printf("FAILED (%s get state after prepare failed: %s)\n",
+		       sequence_name, strerror(-ret));
+		goto out_cancel;
+	}
+
+	if (state != LIVEUPDATE_STATE_PREPARED) {
+		printf("FAILED (%s expected PREPARED state, got %s)\n",
+		       sequence_name, luo_state_to_string(state));
+		ret = -EINVAL;
+		goto out_cancel;
+	}
+
+	/* Test PREPARED -> NORMAL transition via cancel */
+	ret = luo_cancel();
+	if (ret < 0) {
+		printf("FAILED (%s cancel failed: %s)\n",
+		       sequence_name, strerror(-ret));
+		return ret;
+	}
+
+	ret = luo_get_state(&state);
+	if (ret < 0) {
+		printf("FAILED (%s get state after cancel failed: %s)\n",
+		       sequence_name, strerror(-ret));
+		return ret;
+	}
+
+	if (state != LIVEUPDATE_STATE_NORMAL) {
+		printf("FAILED (%s expected NORMAL state after cancel, got %s)\n",
+		       sequence_name, luo_state_to_string(state));
+		return -EINVAL;
+	}
+
+	return 0;
+
+out_cancel:
+	luo_cancel();
+	return ret;
+}
+
+/* Test all state transitions */
+static void test_state_transitions(void)
+{
+	int ret;
+
+	printf("Testing state transitions... ");
+
+	ret = luo_init();
+	if (ret < 0) {
+		printf("FAILED (init failed: %s)\n", strerror(-ret));
+		return;
+	}
+
+	/* Test first prepare -> cancel sequence */
+	ret = test_prepare_cancel_sequence("first");
+	if (ret < 0)
+		goto out;
+
+	/*
+	 * Test second prepare -> freeze -> cancel sequence in case the
+	 * previous cancellation left some side effects.
+	 */
+	ret = test_prepare_cancel_sequence("second");
+	if (ret < 0)
+		goto out;
+
+	printf("PASSED\n");
+
+out:
+	luo_cleanup();
+}
+
+/* Test name to flag mapping */
+struct test {
+	const char *name;
+	void (*fn)(void);
+	unsigned int flag;
+};
+
+/* Array of test names and their corresponding flags */
+static struct test tests[] = {
+	{"init", test_init_cleanup, TEST_INIT_CLEANUP},
+	{"state", test_get_state, TEST_GET_STATE},
+	{"transitions", test_state_transitions, TEST_STATE_TRANSITIONS},
+	{"preserve", test_fd_preserve_unpreserve, TEST_FD_PRESERVE},
+	{"prepared", test_fd_prepared_operations, TEST_FD_PREPARED},
+	{"error", test_error_handling, TEST_ERROR_HANDLING},
+	{"kexec", test_fd_preserve_for_kexec, TEST_FD_KEXEC},
+	{NULL, NULL, 0}
+};
+
+static int parse_test_names(char *arg, unsigned int *flags)
+{
+	char *name;
+	struct test *test;
+
+	*flags = 0;
+	name = strtok(arg, ",");
+
+	while (name != NULL) {
+		test = tests;
+		while (test->name) {
+			if (strcmp(name, test->name) == 0) {
+				*flags |= test->flag;
+				break;
+			}
+			test++;
+		}
+
+		/* Check if we found a match */
+		if (!test->name) {
+			printf("Unknown test: %s\n", name);
+			return 1;
+		}
+
+		name = strtok(NULL, ",");
+	}
+
+	return 0;
+}
+
+static void usage(const char *program_name)
+{
+	printf("Usage: %s [options]\n", program_name);
+	printf("Options:\n");
+	printf("  -h, --help                 Show this help message\n");
+	printf("  -t, --test=TEST_ID         Run specific test(s)\n");
+	printf("  -e, --exclude=TEST_ID      Exclude specific test(s)\n");
+	printf("\n");
+	printf("Test IDs:\n");
+	printf("  init        - Test initialization and cleanup\n");
+	printf("  state       - Test getting LUO state\n");
+	printf("  preserve    - Test memfd preserve/unpreserve with freeze/cancel\n");
+	printf("  prepared    - Test memfd functions can read/write but not grow after prepare\n");
+	printf("  transitions - Test all state transitions (NORMAL->PREPARED->FROZEN->NORMAL)\n");
+	printf("  error       - Test error handling\n");
+	printf("  kexec       - Test memfd preserve for kexec\n");
+	printf("\n");
+	printf("Multiple tests can be specified with comma separation.\n");
+	printf("Example: %s --test=init,state --exclude=kexec\n", program_name);
+	printf("By default, all tests are run.\n");
+}
+
+int main(int argc, char *argv[])
+{
+	unsigned int tests_to_run = TEST_ALL;
+	unsigned int tests_to_exclude = 0;
+	struct option long_options[] = {
+		{"help", no_argument, 0, 'h'},
+		{"test", required_argument, 0, 't'},
+		{"exclude", required_argument, 0, 'e'},
+		{0, 0, 0, 0}
+	};
+	struct test *test;
+	int opt;
+
+	printf("LibLUO Test Suite\n");
+	printf("=================\n\n");
+
+	if (!luo_is_available()) {
+		printf("LUO is not available on this system. Skipping tests.\n");
+		return 0;
+	}
+
+	while ((opt = getopt_long(argc, argv, "ht:e:", long_options, NULL)) != -1) {
+		switch (opt) {
+		case 'h':
+			usage(argv[0]);
+			return 0;
+		case 't':
+			if (parse_test_names(optarg, &tests_to_run))
+				return 1;
+			break;
+		case 'e':
+			if (parse_test_names(optarg, &tests_to_exclude))
+				return 1;
+			break;
+		default:
+			printf("Try '%s --help' for more information.\n", argv[0]);
+			return 1;
+		}
+	}
+
+	/* Apply exclusions to the tests to run */
+	tests_to_run &= ~tests_to_exclude;
+	if (!tests_to_run) {
+		printf("ERROR: all tests excluded\n");
+		return 1;
+	}
+
+	/* Run selected tests */
+	test = tests;
+	while (test->name) {
+		if (tests_to_run & test->flag)
+			test->fn();
+		test++;
+	}
+
+	printf("\nAll requested tests completed.\n");
+	return 0;
+}
-- 
2.50.0.727.gbf7dc18ff4-goog


