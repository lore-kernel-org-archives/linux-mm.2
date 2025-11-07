Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49D93CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 21:06:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0FA68E0020; Fri,  7 Nov 2025 16:06:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A98758E001A; Fri,  7 Nov 2025 16:06:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8764E8E0020; Fri,  7 Nov 2025 16:06:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5F0CB8E001A
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:06:14 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 233C413B72E
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:06:14 +0000 (UTC)
X-FDA: 84085043868.27.CD2E92C
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2AA5C18001A
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:06:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eGhfTqWG;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762549572; a=rsa-sha256;
	cv=none;
	b=69E6iRz0azpM+JaQDgCIbmDsmPsI7puOuShIZxsBq4GEEaxzsRRSqqreDsiaGV3WjuYElR
	d+CqVRBL88ouxtrs/oDqXc9TPdRGQ6FchErj1i+ZhSBewQl4pXxiQWv1GPp1jbJxOXpaLC
	czU1lIEeo+QiPYjmPG92hvDwrbQqX1k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eGhfTqWG;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762549572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wMSpKE1l2D+pbDUsxKcM6He86wroChEvKIhAzF63c/s=;
	b=wrQDI967q2ck8narGqsC1t8ASLkc3PanJ0t6J/1cFPn97/3jkNRCnqju1f9l6WgOwPJmt6
	GqBBxAqwiC6vPwYufiTJBC6iHK7uOHlI668xJEBRlETawwiQBI5u5uNl9eyYE+6X6CPqxQ
	2ufbYmocFjVa5LwKAEVu7waIcIxLUM4=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-7869819394aso11261247b3.3
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 13:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762549571; x=1763154371; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wMSpKE1l2D+pbDUsxKcM6He86wroChEvKIhAzF63c/s=;
        b=eGhfTqWGFth4vlR3kiYliuuOxgTeomsyRdCVlp6E0HBtHYVx5RbGpMiUkcPIxm7lP0
         30NHGfJs8TztXJfaMm8VY4AMwBZmpqmpHTzK1hx8dPyc5fhAtTA/oiFkJrnhJU2hPj47
         85cQRinrbh/56M7VYp2NzU5AtE47ZM5+5o9VQyLtjZRNFXDQdPF/CUj7kkUVr8F/r5Qw
         EssYFXoE/UQF9DuaCKjB+oqKO899xO4FaxlnwIaWMT+T9MJEmQnDwZvOlT4OB3FkCYkP
         meX6TSixiOT+V73eWbzHOe4jBJG3ccgQQeRF31GZVWIBg9DTslPhiT0NYId/Z10LGDoR
         kCVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762549571; x=1763154371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wMSpKE1l2D+pbDUsxKcM6He86wroChEvKIhAzF63c/s=;
        b=L29XC5bM4Mqc4BeUxNmlz+xwqkLjdzTOYYQ49t6GO9a4JPzZSeCsSgGOi4FL4d9Ws3
         If81fAxsX8QTEq1zBFXKhrFMJzF4YNHpumP/kt2FVcuV6CkufhbTr7KmmSu5KJnbkDpB
         eMgu5xSoXF5xnST11170pvWfp2LtNVcHC580DQ5JUN6p9IHVWnW1kbn7g0VHkONMYAe4
         PpBjUEGNdhAEprzGArJtLZrnVU5MKIKNhuE+IoK7txKOij8O4AMtH7hah8t124R3lHs2
         mW9ro4I4DZT/e6GUXH/weOafuCgHp0cyRFT9XgZYWp1bihz4lFqsiVrTyiOHd28BjNAb
         EzDw==
X-Forwarded-Encrypted: i=1; AJvYcCU3tXEYAAtgbbgJh0p1tuNL8SlIst8ouQGY7fmUil2sUfESOqGvNGIY6E1p9KE+r457ldfkk4qShw==@kvack.org
X-Gm-Message-State: AOJu0YwzJ5zmHviXVGEa5Kce+Bkb/ry30zbsMM9w7pqTiaqVTYiLQL2u
	lwMYM1duhR8rAqpSPOiQyLF/370ZDhxzfgX+X+BKZDd5CUrzkJGA9zwPz9o7U5INFnw=
X-Gm-Gg: ASbGncv7qWoCzgWVBcEud9yn8upe8LkwLDR9oHGzRuYLx+Jnzkf8fdRHlN1vJxN0Av5
	xNsCFKwNU+iKeasl39fvHyY3VMqvcRSZd7H3rBBT9n3vZn5RtodJYESZPW6zG3cNx/xu1ECejh1
	rcgM/RIQPnORtrhHDq+sPHRSvvb2NTgt/JaA4384cjXIO7Cg+cwH6Ik17XDScDjA49wNSoJGsRx
	g7Wqw7YNbXOcoO/4ZhlK8lhPQXsbKZNxznDpUTtUSU+7olbBQJuFimWnZ7Or2SXDDw8zhd0Vi1B
	PnRtNq7vOOonrq7JdGOZwQsfUacLYQ47jAY5nmXeT/Bhw1dCzuXnvSOMPlSW0e81yLUTVryP0aT
	PArocr04K4J0YG8r8T25gJ9rNhVysxH4nH6LkkP01Ma2QzUkuEZ6KnUoahBEPK1qity9SDdFJWW
	FsPymkOhGyWScOH5dkI/0FL9SDB1fRYw7oXhgOkSY4bCB9gs6ptlWv+Fe/dUeeEr0=
X-Google-Smtp-Source: AGHT+IFflyRO6w1q3DXVe7O2dxbNRv5YmoMD7A2svs64snuag/XfdkXNTRwcLqUkAwpierKFK5vHIg==
X-Received: by 2002:a05:690c:4d09:b0:786:4fbb:642 with SMTP id 00721157ae682-787d548410fmr7640347b3.60.1762549571027;
        Fri, 07 Nov 2025 13:06:11 -0800 (PST)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787d68754d3sm990817b3.26.2025.11.07.13.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 13:06:10 -0800 (PST)
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
Subject: [PATCH v5 20/22] selftests/liveupdate: Add kexec-based selftest for session lifecycle
Date: Fri,  7 Nov 2025 16:03:18 -0500
Message-ID: <20251107210526.257742-21-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251107210526.257742-1-pasha.tatashin@soleen.com>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2AA5C18001A
X-Stat-Signature: 4o1aftkz3egca7gxme5ktwhfwnxzsit5
X-HE-Tag: 1762549572-893204
X-HE-Meta: U2FsdGVkX1+LMHMwLmV/7M7lgZGgjpdX2kxNdU9qi939Ue6UK+bP3V3HJCWOIZmPh/tHpB6vXgioUogvxe/fP4xEKt6uX0HJRJdnMo6tnuwqRZFgqWWBQEaMME9yIeoQsas32dlg4L148DeAqWaoBehPiw3l8EIchpGPZaf6ID6ek84TK3G3anknXTfFZrU1HPI9HbXHyufXFexHmy/NIW2qLYFn6+7gjqcmYnHHev2dx2Z0z4GoT4opJWUxC7oO1jGxv+7D1KXh9BUijxML+9WKWSyndnJhRQ5SADGdZ6AsJunB2gk7detuBiqIG8mBnLLrH5fjtlJKrgVJbWGjp9HPvJhUW2fZXduwhJLAtKARbHDZgS6hxwAGPZ+2Nso8boD37pqlZd/ClRUs0CRfMgMlGa0Vd8b7Z4PkJsLWhNHPaR51opdyLDufYQJ9ZroyDLcd0ePWPHvGsNjLkZLDv9c0IIjEsMBC/lFpYnDp0+L7W9vwqKdWEjd9n9ejK4w+cfRTf646c1okUVyBDtvQ8XzaJW9blUXYWCb81b6OHAlh/oEIx58fhH/OSnNnEiHGDPCksIt438RvXje/tFrfEhJaWSSwaPUYh7KlJnV/XPVW3zgQSb1QQiSm7/MevzafOO1KHgeZ7E2Ixu5g0Me+NbRkHdhaTiHjXPNRUOGi8KzqFzWNq6Ta0vYdUtKdS3AZY2yt5YFMYaY2W7vDjFWSmSZd7bdZKhsVskDseUD660EIQtLvQdrYMj3TcTh1i8MPjNOBH/6pQwgGI3dKy57/gw17daoxZ4Wdg0yGT7HOWz7fv/Yy8dWqZ/wgTLVSgam3iQaHNFIBKxc5b0t0UTCqplKvSrsz9vYVJ6s7TFsiCVYlPxYXA/PsEk4JJGLcKtHHjiBhXVtWqVfyJXs+w3i7rUWGCM3jQMVMF2VxAAouz1PjTJQIktS3WoQHwKCiR4V/Hs+qczsLqXwtFM4KIbr
 ZfYj0ROW
 GLyc1kyo8imApfro73FXaVhnxoROQZEdwpAuHuw+wEA71ivzmP19fxvF8HvjIuqfMmBQl7agfe2Qpy1Rc2+4+OcMtxBtOYMo1eqjg1Gyspb45hJyujYxo379YVBTBtSrOvcyKnOxv4TTVuD1XNws29ndRIGenuZGlKcOtarF4Wd4m9HYHCHlxGP4GULghvEpnbapgbZ3FA0Ds+L04qpXdyly2FQ+zGOCO7WL/6nSaDjeQIIU3FCX0X3ENX2lnDvNSt4P6kY+pR0OFq6P9S8PTGPndi/6J4E5aFK5xjxR3UQ02Jg9RCYyhqeNXwijhoUTV0F+I4i6L3VKzF9CeYO4FcoNGyyWgNge0iEIid42PnPT/R8aHVuJDF9V6GxhXV1sV5JpxdJ6HCZn9m7NOxQ9pNGoricKjF93uzFOLqymbV4qePN3dvby4OCOxwA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a kexec-based selftest, luo_kexec_simple, to validate the
end-to-end lifecycle of a Live Update Orchestrator (LUO) session across
a reboot.

While existing tests verify the uAPI in a pre-reboot context, this test
ensures that the core functionality—preserving state via Kexec Handover
and restoring it in a new kernel—works as expected.

The test operates in two stages, managing its state across the reboot by
preserving a dedicated "state session" containing a memfd. This
mechanism dogfoods the LUO feature itself for state tracking, making the
test self-contained.

The test validates the following sequence:

Stage 1 (Pre-kexec):
 - Creates a test session (test-session).
 - Creates and preserves a memfd with a known data pattern into the test
   session.
 - Creates the state-tracking session to signal progression to Stage 2.
 - Executes a kexec reboot via a helper script.

Stage 2 (Post-kexec):
 - Retrieves the state-tracking session to confirm it is in the
   post-reboot stage.
 - Retrieves the preserved test session.
 - Restores the memfd from the test session and verifies its contents
   match the original data pattern written in Stage 1.
 - Finalizes both the test and state sessions to ensure a clean
   teardown.

The test relies on a helper script (do_kexec.sh) to perform the reboot
and a shared utility library (luo_test_utils.c) for common LUO
operations, keeping the main test logic clean and focused.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 tools/testing/selftests/liveupdate/.gitignore |   1 +
 tools/testing/selftests/liveupdate/Makefile   |  32 ++++
 .../testing/selftests/liveupdate/do_kexec.sh  |   6 +
 .../selftests/liveupdate/luo_kexec_simple.c   | 114 ++++++++++++
 .../selftests/liveupdate/luo_test_utils.c     | 168 ++++++++++++++++++
 .../selftests/liveupdate/luo_test_utils.h     |  39 ++++
 6 files changed, 360 insertions(+)
 create mode 100755 tools/testing/selftests/liveupdate/do_kexec.sh
 create mode 100644 tools/testing/selftests/liveupdate/luo_kexec_simple.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_test_utils.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_test_utils.h

diff --git a/tools/testing/selftests/liveupdate/.gitignore b/tools/testing/selftests/liveupdate/.gitignore
index af6e773cf98f..daeef116174d 100644
--- a/tools/testing/selftests/liveupdate/.gitignore
+++ b/tools/testing/selftests/liveupdate/.gitignore
@@ -1 +1,2 @@
 /liveupdate
+/luo_kexec_simple
diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
index 2a573c36016e..1563ac84006a 100644
--- a/tools/testing/selftests/liveupdate/Makefile
+++ b/tools/testing/selftests/liveupdate/Makefile
@@ -1,7 +1,39 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+KHDR_INCLUDES ?= -I../../../../usr/include
 CFLAGS += -Wall -O2 -Wno-unused-function
 CFLAGS += $(KHDR_INCLUDES)
+LDFLAGS += -static
+OUTPUT ?= .
+
+# --- Test Configuration (Edit this section when adding new tests) ---
+LUO_SHARED_SRCS := luo_test_utils.c
+LUO_SHARED_HDRS += luo_test_utils.h
+
+LUO_MANUAL_TESTS += luo_kexec_simple
+
+TEST_FILES += do_kexec.sh
 
 TEST_GEN_PROGS += liveupdate
 
+# --- Automatic Rule Generation (Do not edit below) ---
+
+TEST_GEN_PROGS_EXTENDED += $(LUO_MANUAL_TESTS)
+
+# Define the full list of sources for each manual test.
+$(foreach test,$(LUO_MANUAL_TESTS), \
+	$(eval $(test)_SOURCES := $(test).c $(LUO_SHARED_SRCS)))
+
+# This loop automatically generates an explicit build rule for each manual test.
+# It includes dependencies on the shared headers and makes the output
+# executable.
+# Note the use of '$$' to escape automatic variables for the 'eval' command.
+$(foreach test,$(LUO_MANUAL_TESTS), \
+	$(eval $(OUTPUT)/$(test): $($(test)_SOURCES) $(LUO_SHARED_HDRS) \
+		$(call msg,LINK,,$$@) ; \
+		$(Q)$(LINK.c) $$^ $(LDLIBS) -o $$@ ; \
+		$(Q)chmod +x $$@ \
+	) \
+)
+
 include ../lib.mk
diff --git a/tools/testing/selftests/liveupdate/do_kexec.sh b/tools/testing/selftests/liveupdate/do_kexec.sh
new file mode 100755
index 000000000000..bb396a92c3b8
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/do_kexec.sh
@@ -0,0 +1,6 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+set -e
+
+kexec -l -s --reuse-cmdline /boot/bzImage
+kexec -e
diff --git a/tools/testing/selftests/liveupdate/luo_kexec_simple.c b/tools/testing/selftests/liveupdate/luo_kexec_simple.c
new file mode 100644
index 000000000000..67ab6ebf9eec
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_kexec_simple.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * A simple selftest to validate the end-to-end lifecycle of a LUO session
+ * across a single kexec reboot.
+ */
+
+#include "luo_test_utils.h"
+
+/* Test-specific constants are now defined locally */
+#define KEXEC_SCRIPT "./do_kexec.sh"
+#define TEST_SESSION_NAME "test-session"
+#define TEST_MEMFD_TOKEN 0x1A
+#define TEST_MEMFD_DATA "hello kexec world"
+
+/* Constants for the state-tracking mechanism, specific to this test file. */
+#define STATE_SESSION_NAME "kexec_simple_state"
+#define STATE_MEMFD_TOKEN 999
+
+/* Stage 1: Executed before the kexec reboot. */
+static void run_stage_1(int luo_fd)
+{
+	int session_fd;
+
+	ksft_print_msg("[STAGE 1] Starting pre-kexec setup...\n");
+
+	ksft_print_msg("[STAGE 1] Creating state file for next stage (2)...\n");
+	create_state_file(luo_fd, STATE_SESSION_NAME, STATE_MEMFD_TOKEN, 2);
+
+	ksft_print_msg("[STAGE 1] Creating session '%s' and preserving memfd...\n",
+		       TEST_SESSION_NAME);
+	session_fd = luo_create_session(luo_fd, TEST_SESSION_NAME);
+	if (session_fd < 0)
+		fail_exit("luo_create_session for '%s'", TEST_SESSION_NAME);
+
+	if (create_and_preserve_memfd(session_fd, TEST_MEMFD_TOKEN,
+				      TEST_MEMFD_DATA) < 0) {
+		fail_exit("create_and_preserve_memfd for token %#x",
+			  TEST_MEMFD_TOKEN);
+	}
+
+	ksft_print_msg("[STAGE 1] Executing kexec...\n");
+	if (system(KEXEC_SCRIPT) != 0)
+		fail_exit("kexec script failed");
+	exit(EXIT_FAILURE);
+}
+
+/* Stage 2: Executed after the kexec reboot. */
+static void run_stage_2(int luo_fd, int state_session_fd)
+{
+	int session_fd, mfd, stage;
+
+	ksft_print_msg("[STAGE 2] Starting post-kexec verification...\n");
+
+	restore_and_read_stage(state_session_fd, STATE_MEMFD_TOKEN, &stage);
+	if (stage != 2)
+		fail_exit("Expected stage 2, but state file contains %d", stage);
+
+	ksft_print_msg("[STAGE 2] Retrieving session '%s'...\n", TEST_SESSION_NAME);
+	session_fd = luo_retrieve_session(luo_fd, TEST_SESSION_NAME);
+	if (session_fd < 0)
+		fail_exit("luo_retrieve_session for '%s'", TEST_SESSION_NAME);
+
+	ksft_print_msg("[STAGE 2] Restoring and verifying memfd (token %#x)...\n",
+		       TEST_MEMFD_TOKEN);
+	mfd = restore_and_verify_memfd(session_fd, TEST_MEMFD_TOKEN,
+				       TEST_MEMFD_DATA);
+	if (mfd < 0)
+		fail_exit("restore_and_verify_memfd for token %#x", TEST_MEMFD_TOKEN);
+	close(mfd);
+
+	ksft_print_msg("[STAGE 2] Test data verified successfully.\n");
+	ksft_print_msg("[STAGE 2] Finalizing test session...\n");
+	if (luo_session_finish(session_fd) < 0)
+		fail_exit("luo_session_finish for test session");
+	close(session_fd);
+
+	ksft_print_msg("[STAGE 2] Finalizing state session...\n");
+	if (luo_session_finish(state_session_fd) < 0)
+		fail_exit("luo_session_finish for state session");
+	close(state_session_fd);
+
+	ksft_print_msg("\n--- SIMPLE KEXEC TEST PASSED ---\n");
+}
+
+int main(int argc, char *argv[])
+{
+	int luo_fd;
+	int state_session_fd;
+
+	luo_fd = luo_open_device();
+	if (luo_fd < 0)
+		ksft_exit_skip("Failed to open %s. Is the luo module loaded?\n",
+			       LUO_DEVICE);
+
+	/*
+	 * Determine the stage by attempting to retrieve the state session.
+	 * If it doesn't exist (ENOENT), we are in Stage 1 (pre-kexec).
+	 */
+	state_session_fd = luo_retrieve_session(luo_fd, STATE_SESSION_NAME);
+	if (state_session_fd == -ENOENT) {
+		run_stage_1(luo_fd);
+	} else if (state_session_fd >= 0) {
+		/* We got a valid handle, pass it directly to stage 2 */
+		run_stage_2(luo_fd, state_session_fd);
+	} else {
+		fail_exit("Failed to check for state session");
+	}
+
+	close(luo_fd);
+}
diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.c b/tools/testing/selftests/liveupdate/luo_test_utils.c
new file mode 100644
index 000000000000..0a24105cbc54
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_test_utils.c
@@ -0,0 +1,168 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#define _GNU_SOURCE
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <sys/syscall.h>
+#include <sys/mman.h>
+#include <errno.h>
+#include <stdarg.h>
+
+#include "luo_test_utils.h"
+
+int luo_open_device(void)
+{
+	return open(LUO_DEVICE, O_RDWR);
+}
+
+int luo_create_session(int luo_fd, const char *name)
+{
+	struct liveupdate_ioctl_create_session arg = { .size = sizeof(arg) };
+
+	snprintf((char *)arg.name, LIVEUPDATE_SESSION_NAME_LENGTH, "%.*s",
+		 LIVEUPDATE_SESSION_NAME_LENGTH - 1, name);
+
+	if (ioctl(luo_fd, LIVEUPDATE_IOCTL_CREATE_SESSION, &arg) < 0)
+		return -errno;
+
+	return arg.fd;
+}
+
+int luo_retrieve_session(int luo_fd, const char *name)
+{
+	struct liveupdate_ioctl_retrieve_session arg = { .size = sizeof(arg) };
+
+	snprintf((char *)arg.name, LIVEUPDATE_SESSION_NAME_LENGTH, "%.*s",
+		 LIVEUPDATE_SESSION_NAME_LENGTH - 1, name);
+
+	if (ioctl(luo_fd, LIVEUPDATE_IOCTL_RETRIEVE_SESSION, &arg) < 0)
+		return -errno;
+
+	return arg.fd;
+}
+
+int create_and_preserve_memfd(int session_fd, int token, const char *data)
+{
+	struct liveupdate_session_preserve_fd arg = { .size = sizeof(arg) };
+	long page_size = sysconf(_SC_PAGE_SIZE);
+	void *map = MAP_FAILED;
+	int mfd = -1, ret = -1;
+
+	mfd = memfd_create("test_mfd", 0);
+	if (mfd < 0)
+		return -errno;
+
+	if (ftruncate(mfd, page_size) != 0)
+		goto out;
+
+	map = mmap(NULL, page_size, PROT_WRITE, MAP_SHARED, mfd, 0);
+	if (map == MAP_FAILED)
+		goto out;
+
+	snprintf(map, page_size, "%s", data);
+	munmap(map, page_size);
+
+	arg.fd = mfd;
+	arg.token = token;
+	if (ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &arg) < 0)
+		goto out;
+
+	ret = 0;
+out:
+	if (ret != 0 && errno != 0)
+		ret = -errno;
+	if (mfd >= 0)
+		close(mfd);
+	return ret;
+}
+
+int restore_and_verify_memfd(int session_fd, int token,
+			     const char *expected_data)
+{
+	struct liveupdate_session_retrieve_fd arg = { .size = sizeof(arg) };
+	long page_size = sysconf(_SC_PAGE_SIZE);
+	void *map = MAP_FAILED;
+	int mfd = -1, ret = -1;
+
+	arg.token = token;
+	if (ioctl(session_fd, LIVEUPDATE_SESSION_RETRIEVE_FD, &arg) < 0)
+		return -errno;
+	mfd = arg.fd;
+
+	map = mmap(NULL, page_size, PROT_READ, MAP_SHARED, mfd, 0);
+	if (map == MAP_FAILED)
+		goto out;
+
+	if (expected_data && strcmp(expected_data, map) != 0) {
+		ksft_print_msg("Data mismatch! Expected '%s', Got '%s'\n",
+			       expected_data, (char *)map);
+		ret = -EINVAL;
+		goto out_munmap;
+	}
+
+	ret = mfd;
+out_munmap:
+	munmap(map, page_size);
+out:
+	if (ret < 0 && errno != 0)
+		ret = -errno;
+	if (ret < 0 && mfd >= 0)
+		close(mfd);
+	return ret;
+}
+
+int luo_session_finish(int session_fd)
+{
+	struct liveupdate_session_finish arg = { .size = sizeof(arg) };
+
+	if (ioctl(session_fd, LIVEUPDATE_SESSION_FINISH, &arg) < 0)
+		return -errno;
+
+	return 0;
+}
+
+void create_state_file(int luo_fd, const char *session_name, int token,
+		       int next_stage)
+{
+	char buf[32];
+	int state_session_fd;
+
+	state_session_fd = luo_create_session(luo_fd, session_name);
+	if (state_session_fd < 0)
+		fail_exit("luo_create_session for state tracking");
+
+	snprintf(buf, sizeof(buf), "%d", next_stage);
+	if (create_and_preserve_memfd(state_session_fd, token, buf) < 0)
+		fail_exit("create_and_preserve_memfd for state tracking");
+
+	/*
+	 * DO NOT close session FD, otherwise it is going to be unpreserved
+	 */
+}
+
+void restore_and_read_stage(int state_session_fd, int token, int *stage)
+{
+	char buf[32] = {0};
+	int mfd;
+
+	mfd = restore_and_verify_memfd(state_session_fd, token, NULL);
+	if (mfd < 0)
+		fail_exit("failed to restore state memfd");
+
+	if (read(mfd, buf, sizeof(buf) - 1) < 0)
+		fail_exit("failed to read state mfd");
+
+	*stage = atoi(buf);
+
+	close(mfd);
+}
diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.h b/tools/testing/selftests/liveupdate/luo_test_utils.h
new file mode 100644
index 000000000000..093e787b9f4b
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_test_utils.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * Utility functions for LUO kselftests.
+ */
+
+#ifndef LUO_TEST_UTILS_H
+#define LUO_TEST_UTILS_H
+
+#include <errno.h>
+#include <string.h>
+#include <linux/liveupdate.h>
+#include "../kselftest.h"
+
+#define LUO_DEVICE "/dev/liveupdate"
+
+#define fail_exit(fmt, ...)						\
+	ksft_exit_fail_msg("[%s:%d] " fmt " (errno: %s)\n",	\
+			   __func__, __LINE__, ##__VA_ARGS__, strerror(errno))
+
+/* Generic LUO and session management helpers */
+int luo_open_device(void);
+int luo_create_session(int luo_fd, const char *name);
+int luo_retrieve_session(int luo_fd, const char *name);
+int luo_session_finish(int session_fd);
+
+/* Generic file preservation and restoration helpers */
+int create_and_preserve_memfd(int session_fd, int token, const char *data);
+int restore_and_verify_memfd(int session_fd, int token, const char *expected_data);
+
+/* Kexec state-tracking helpers */
+void create_state_file(int luo_fd, const char *session_name, int token,
+		       int next_stage);
+void restore_and_read_stage(int state_session_fd, int token, int *stage);
+
+#endif /* LUO_TEST_UTILS_H */
-- 
2.51.2.1041.gc1ab5b90ca-goog


