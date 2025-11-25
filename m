Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38629D0EE0D
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 16:59:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB3DB6B00A1; Tue, 25 Nov 2025 11:59:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8BF56B00A3; Tue, 25 Nov 2025 11:59:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 955066B00A4; Tue, 25 Nov 2025 11:59:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7AB606B00A1
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:59:43 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 465E31A02EF
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:43 +0000 (UTC)
X-FDA: 84149741046.06.35C824B
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id 53168A000F
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=coXL0rSp;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764089981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1zn01wPWOlP3y55xcUHgz6OrhAWK/GekbUUj2NOJck4=;
	b=HdirO/GNmfK7j7N3ncuqdFDN9dJ1043AyyIaFplPvs6O+3KtAnKnd3tI/Zbb2xvCbnpDwb
	IIU577WVvOeryZoHmulB/bJi8kRXeZ+Be6wNvmZ+zBnarNxmkSmsZie13O+3ArC3ODse0j
	pWuhyhSQ58M79r2XbURle+5oj38qxnk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=coXL0rSp;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764089981; a=rsa-sha256;
	cv=none;
	b=7scrVzIr1NIQUvuWx0zLzXSgqT+rDQ54Wqc2j22WvWyFBQ8sMTsRh2UQQcF1M+oUwm9ane
	MhZbPf5VXcuc7u27BfiXV8vNBh+gAcZo+JSoswoGic/Z0BoNBE/Zi8ugJ62nv+zYCghUyF
	sOn9REe+8yL/Vl3Wh5EbScTm7ePKk48=
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-6420dc2e5feso4511162d50.3
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764089980; x=1764694780; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1zn01wPWOlP3y55xcUHgz6OrhAWK/GekbUUj2NOJck4=;
        b=coXL0rSpRrirVRL0MR9if6e2L/DRrKVP6WJQWQvDNxiGqn2P1RHrShQw2M5J6sUvB1
         zpxlQFjELg+EFwYalTi19T9qLz6OPoNVxxk+HA6onJ04cUzeqcbspQLIo6FSHTVKmQnR
         L3e9aEhrQXWekcoG/TktZIAKbRBuzPhBlsU+HAvgWNwDNupjaE+8cFko/zLdB//G+mvS
         Gi74vvQRltR80JlaMeg1cX6Imht4b9vFvkwAO5Gzl2IWQerObm0XAinGg6IlxQxA72FX
         23IdFDxcFEZyrpy2VpK8n6unDf7FmHHL3kx9sw1sUy1BP4Sh8/H3uCiWaqruuK5I+ubA
         3UgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764089980; x=1764694780;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1zn01wPWOlP3y55xcUHgz6OrhAWK/GekbUUj2NOJck4=;
        b=LH1dnFyreMbibdPp+UB8YlQa0/JsjPabRDps5iEhrp7uzMiQm0lTNgMy28Ig2PLSWt
         0yPYLSNMWhuybXMD3fkwsfl10BMVt6H5i2U09paaoruenqsEcIhNbDm/v8xfuRJ7I8by
         biOC3yyTJwM9kwQBSEnCH5lK/Qzeff2qxQhSgAaFTqzUSWQPUqxYthW+ySmjUI5qRbUA
         /dqT58Vvf4m6jZU+BQFYJqNXLiRhapeZYWvpnj23KeXA3t6IfVDiL2Lm2tu2OnoTaOKr
         17NjCboW/52F8H/lBB6q4oFQWj7vmymJJkEFBwWzV0/CpEGkfEqcY2MADP/ctksOERvm
         wuJA==
X-Forwarded-Encrypted: i=1; AJvYcCUsY8lpS76GvgiQcgXvjJW4sTeY1HWZDbAtFF4bpMY95PYlc1sc83jSXeSSYVNQrKaye2WxxgaxSw==@kvack.org
X-Gm-Message-State: AOJu0YxXUtze4L1vDe09rRYGcIuwEz/ozo28ypdhuIkqbxg9Rm0rvER7
	wOVyP8yQt2msVE+UDFlIfRdUJLkjaTuh35ETaqEr7f/Hkdxsmtv2jJpWBXxu7M9Sdzo=
X-Gm-Gg: ASbGnctB+R2TKbZJAgwUcRS2nYHATjqaGEAnMvmhTfCnUaY1+oNikGbCVRRDl2oWRrV
	YZDJaCpY67TC6f2ukZOiB0Ud+lrGaFFZCaTgfmIA96YkLk9qfT5AH5mHrVPNumkRwsFrmKFFw53
	rM+Yk9kx3G8eyR0XHvnKXotaCSAYCpk5/s3c5Bs6MsnrwlLgSQQz6lfHG3GnO4Fav+BFRbOniyC
	aH/o05dzQ1pYeoQkNRD1gSG//hJ2YdTOU07gKBm07/ZyFq8vVT1Z5bffHlKNF63n+/CaU4bzS/F
	mHGWK+bj8B5IydiBGqJn10mbyrwGrCep/9eyTTe3ykElDS0paINV/b6jCB1Bf1JFCe5pMWHrwbp
	XTF07InJ3Zm6xeBZnkWbTAFf4HYprTwgGDZVpHfleZHD30uAZ+xlhKwB7Cfchon+3HHymlm4a7p
	I7hnOKcxurRrjebYViT9ufZZhT13cvrdpcTjehcpsLBur1qX04Zw+MRvfnE5dbMqH0
X-Google-Smtp-Source: AGHT+IHaLBHTW0gdKW5yIXp86TXIcw0le8lgb42O63AJOI349kwyVeCAoddVEYxKN/vR8v7sgdqIVQ==
X-Received: by 2002:a05:690e:2459:b0:63e:30e1:4429 with SMTP id 956f58d0204a3-64302abcb44mr10008545d50.38.1764089980255;
        Tue, 25 Nov 2025 08:59:40 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a798a5518sm57284357b3.14.2025.11.25.08.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 08:59:39 -0800 (PST)
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
Subject: [PATCH v8 17/18] selftests/liveupdate: Add simple kexec-based selftest for LUO
Date: Tue, 25 Nov 2025 11:58:47 -0500
Message-ID: <20251125165850.3389713-18-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
In-Reply-To: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
References: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 53168A000F
X-Rspamd-Server: rspam11
X-Stat-Signature: 4am3opnxjm4qjrwzuwgj7xnaym11yxbg
X-HE-Tag: 1764089981-739403
X-HE-Meta: U2FsdGVkX1+9vb6ZKnK7rYG21RJs7ht8PTvI3aLQjGukutlRio8P0xWI6/9xZ8UnQwrltp5f02c0koZh2FRvwrYdcI45GI9YLV49bf0J1bgo4Bc8QenidbVEOj+uN/OMLcM3lY/VUU6cHaf1J6b22l0UwFpPLbeEOGlURHyGXaVT2dJgaOBXegQv1Q511IuJvPKjrclK/dcYIUgs/F51qjMX2YsvTggj8Wm6DAAxf5/4w6QGSvq6pMoOC3bJNg5ljRIVskx98nFE1+exXbuTnvLVgamgBYxvuhTI6OSywbmR56y9hXUvEbIPCvO+2A0/fO55R7K28prWz0S4eHcW5rKH5aAdGqhuEkeyxvl2bFTreG43izk25sP+cEg1hX85WpqECJacTrYQj5vTEYEJ1fzmtMuFPIfGb2251cf+uS/qDN2/fsvgB5g1GX1r0QXs8CzQdDq8hZ71xbhpY006jsMDljYoZl47hnGOYPSKkoUdf8jUx89lQ4R8odAA2sKNfO6ZVpLl3ePVAxSOSP0fsnfCOv1Xzp6rOB/6vTC7iK8HAgvk1PcrAFyZMw5+/OSlbWQcwcc6I6+lKT0KhekvsvreFFKxgVYegOEoVJaawlCmgEl7QVDS3baTUBnpt60ldPe2UN/Pp3I3S5taf/SW+lywOqNvmQsjGwQgZZYkMXonaiDSFoampbWXe0FoahhmvpvwaAjm8Mv6r0ycu/f6NKHy7HFWaHvAnUpQkmhR+LnEQ95GuDTvdDgbIHfGb5muKviuSy8l7P6k9QAnYYqXC067n3NtTLk9aXXjVPkvmJ4KapZ8olHG9y/k1JFDQ4PlYaVGPNW9Xml8nvCGWDBqKzkk8bnMJE7FcFNUh/4KYXvt+PEKnvxDoARZwb5f+Qj0A6j/dD8W5B7goBqhJy986O1KahT9qkuRsvH+Tjhi2A3PLFXgt0dVzWbaDjo35c5hmwENsLJITu7I/dTLvTS
 dbUvlZ5y
 8PRB9rke9R4PgbRSaJH2WY88mEUqkfHzacmC9wBAiyVDNLsrk2ui0C1zn+AiQgX36FXS/2cd/Y1FT0zEKE1N3F50q5viy7N76/fhsdfnOwD1k8f5lbVJwCx1FThhkJUPYWwwnSQlhQQ242RWhkt88sD96S0/PkMV/mVo5hD4DgeZPgmLkuKcdtIhZNsRh1gMx35Wm6QWwofuJqks+t62BGNp0CFqMDnFjZ99h5llvmyMKA9r88ycJk+8NfZf6YPg9tN7uMyYDdkykWGkip/C8ptt+wvvtdBjW0hlDfCNCLJwFnFXMkuDwj7/KALcx330LKjlUrM/8Lt9R1kq2mXXiT5dtlWsmR33mOQtHLdyEhh5L/A+9Aiw9UHdByIcNDCLumfFbBo4VdSB4GZzCtBdo3XCNuT4HJ9Ruh9CoB8NfCfuvelBSPLpGX1caMiVNQxx1QjxH8GBNtaeKDLY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a kexec-based selftest, luo_kexec_simple, to validate the
end-to-end lifecycle of a Live Update Orchestrator session across
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
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/liveupdate/Makefile   |   6 +
 .../testing/selftests/liveupdate/do_kexec.sh  |  16 ++
 .../selftests/liveupdate/luo_kexec_simple.c   |  89 ++++++
 .../selftests/liveupdate/luo_test_utils.c     | 266 ++++++++++++++++++
 .../selftests/liveupdate/luo_test_utils.h     |  44 +++
 5 files changed, 421 insertions(+)
 create mode 100755 tools/testing/selftests/liveupdate/do_kexec.sh
 create mode 100644 tools/testing/selftests/liveupdate/luo_kexec_simple.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_test_utils.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_test_utils.h

diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
index 620cb4ce85af..bbbec633970c 100644
--- a/tools/testing/selftests/liveupdate/Makefile
+++ b/tools/testing/selftests/liveupdate/Makefile
@@ -1,7 +1,13 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
+LIB_C += luo_test_utils.c
+
 TEST_GEN_PROGS += liveupdate
 
+TEST_GEN_PROGS_EXTENDED += luo_kexec_simple
+
+TEST_FILES += do_kexec.sh
+
 include ../lib.mk
 
 CFLAGS += $(KHDR_INCLUDES)
diff --git a/tools/testing/selftests/liveupdate/do_kexec.sh b/tools/testing/selftests/liveupdate/do_kexec.sh
new file mode 100755
index 000000000000..3c7c6cafbef8
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/do_kexec.sh
@@ -0,0 +1,16 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+set -e
+
+# Use $KERNEL and $INITRAMFS to pass custom Kernel and optional initramfs
+
+KERNEL="${KERNEL:-/boot/bzImage}"
+set -- -l -s --reuse-cmdline "$KERNEL"
+
+INITRAMFS="${INITRAMFS:-/boot/initramfs}"
+if [ -f "$INITRAMFS" ]; then
+    set -- "$@" --initrd="$INITRAMFS"
+fi
+
+kexec "$@"
+kexec -e
diff --git a/tools/testing/selftests/liveupdate/luo_kexec_simple.c b/tools/testing/selftests/liveupdate/luo_kexec_simple.c
new file mode 100644
index 000000000000..d7ac1f3dc4cb
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_kexec_simple.c
@@ -0,0 +1,89 @@
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
+	close(luo_fd);
+	daemonize_and_wait();
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
+	return luo_test(argc, argv, STATE_SESSION_NAME,
+			run_stage_1, run_stage_2);
+}
diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.c b/tools/testing/selftests/liveupdate/luo_test_utils.c
new file mode 100644
index 000000000000..3c8721c505df
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_test_utils.c
@@ -0,0 +1,266 @@
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
+#include <getopt.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <sys/syscall.h>
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <sys/stat.h>
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
+
+void daemonize_and_wait(void)
+{
+	pid_t pid;
+
+	ksft_print_msg("[STAGE 1] Forking persistent child to hold sessions...\n");
+
+	pid = fork();
+	if (pid < 0)
+		fail_exit("fork failed");
+
+	if (pid > 0) {
+		ksft_print_msg("[STAGE 1] Child PID: %d. Resources are pinned.\n", pid);
+		ksft_print_msg("[STAGE 1] You may now perform kexec reboot.\n");
+		exit(EXIT_SUCCESS);
+	}
+
+	/* Detach from terminal so closing the window doesn't kill us */
+	if (setsid() < 0)
+		fail_exit("setsid failed");
+
+	close(STDIN_FILENO);
+	close(STDOUT_FILENO);
+	close(STDERR_FILENO);
+
+	/* Change dir to root to avoid locking filesystems */
+	if (chdir("/") < 0)
+		exit(EXIT_FAILURE);
+
+	while (1)
+		sleep(60);
+}
+
+static int parse_stage_args(int argc, char *argv[])
+{
+	static struct option long_options[] = {
+		{"stage", required_argument, 0, 's'},
+		{0, 0, 0, 0}
+	};
+	int option_index = 0;
+	int stage = 1;
+	int opt;
+
+	optind = 1;
+	while ((opt = getopt_long(argc, argv, "s:", long_options, &option_index)) != -1) {
+		switch (opt) {
+		case 's':
+			stage = atoi(optarg);
+			if (stage != 1 && stage != 2)
+				fail_exit("Invalid stage argument");
+			break;
+		default:
+			fail_exit("Unknown argument");
+		}
+	}
+	return stage;
+}
+
+int luo_test(int argc, char *argv[],
+	     const char *state_session_name,
+	     luo_test_stage1_fn stage1,
+	     luo_test_stage2_fn stage2)
+{
+	int target_stage = parse_stage_args(argc, argv);
+	int luo_fd = luo_open_device();
+	int state_session_fd;
+	int detected_stage;
+
+	if (luo_fd < 0) {
+		ksft_exit_skip("Failed to open %s. Is the luo module loaded?\n",
+			       LUO_DEVICE);
+	}
+
+	state_session_fd = luo_retrieve_session(luo_fd, state_session_name);
+	if (state_session_fd == -ENOENT)
+		detected_stage = 1;
+	else if (state_session_fd >= 0)
+		detected_stage = 2;
+	else
+		fail_exit("Failed to check for state session");
+
+	if (target_stage != detected_stage) {
+		ksft_exit_fail_msg("Stage mismatch Requested --stage %d, but system is in stage %d.\n"
+				   "(State session %s: %s)\n",
+				   target_stage, detected_stage, state_session_name,
+				   (detected_stage == 2) ? "EXISTS" : "MISSING");
+	}
+
+	if (target_stage == 1)
+		stage1(luo_fd);
+	else
+		stage2(luo_fd, state_session_fd);
+
+	return 0;
+}
diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.h b/tools/testing/selftests/liveupdate/luo_test_utils.h
new file mode 100644
index 000000000000..90099bf49577
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_test_utils.h
@@ -0,0 +1,44 @@
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
+int luo_open_device(void);
+int luo_create_session(int luo_fd, const char *name);
+int luo_retrieve_session(int luo_fd, const char *name);
+int luo_session_finish(int session_fd);
+
+int create_and_preserve_memfd(int session_fd, int token, const char *data);
+int restore_and_verify_memfd(int session_fd, int token, const char *expected_data);
+
+void create_state_file(int luo_fd, const char *session_name, int token,
+		       int next_stage);
+void restore_and_read_stage(int state_session_fd, int token, int *stage);
+
+void daemonize_and_wait(void);
+
+typedef void (*luo_test_stage1_fn)(int luo_fd);
+typedef void (*luo_test_stage2_fn)(int luo_fd, int state_session_fd);
+
+int luo_test(int argc, char *argv[], const char *state_session_name,
+	     luo_test_stage1_fn stage1, luo_test_stage2_fn stage2);
+
+#endif /* LUO_TEST_UTILS_H */
-- 
2.52.0.460.gd25c4c69ec-goog


