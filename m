Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ED5DCFD312
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 22:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 934566B0099; Sat, 22 Nov 2025 17:24:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90BC66B009B; Sat, 22 Nov 2025 17:24:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AC856B009D; Sat, 22 Nov 2025 17:24:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D1C66B0099
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:24:33 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 286F61A0234
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:33 +0000 (UTC)
X-FDA: 84139673226.24.8077A2D
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4DAB04000F
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="W/isA91b";
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763850271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7NyXHP81r6tLJnJ1NWALdU8H7382VS8IXYxSNq72IwU=;
	b=p9VmWEUNmjdHSsF/TpxxonS6zWTx0OB3AQ6P+dttBCUftpNrOoz7qcQyQputWAFcqUW4Oz
	C7rhPYfk0WuV5ZD39i9QxWHX0yBuXC8yvApXaFyPVbNJcFfep5glFEz4cQ0ikk+s5SBeEX
	H1RYISyAPrrvJdZIpz/W6hDmQnuLtPw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763850271; a=rsa-sha256;
	cv=none;
	b=j/t8hDxF87xGwYvcMbLVJDjY3sSTlHpuKaj0YIRvIzMBZxWiEV4GwJ55J5Ek8ZDZ652X5n
	dw14VBbAk8OxpbTk8eEZx39t3C/kbNzn6FGEpXD3qMDi6DwWesEoFRZpDG4SvcutHU0Zkr
	ly5iyXdN2348St/aYcbBFxmx/Zq1iY4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="W/isA91b";
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-789524e6719so41964527b3.1
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 14:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763850270; x=1764455070; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7NyXHP81r6tLJnJ1NWALdU8H7382VS8IXYxSNq72IwU=;
        b=W/isA91bxwXtajucLyzQW8pM7FoGaVQ7efmTaYrfuFyWr6t6o+g7oIBPu+RLWT+Wsp
         x+90YwXHdzbkvktbjSLzZDofnDuWoEnfn/eHbRTAoperPiQqMFbUdbZ3KpqH08VRIkuZ
         cmaWZ/V1nL5iEqqAxJEAdu/QA6e/KeXQJmNooIJwyzrzH+uyYli8KWq2bsa+AjqUvGCs
         IV3/QsHhZl0BC8txu913TS4gK0Nk/eKvXfDyAIW9oZ6O9kmgTd27MsBUe9t+H8vFrG9T
         6I32ytXF7XBBEualx+wDGE8jjILt78+SVvXfnGi15xAh52C1lCOdNRR0vmcKOpketq4p
         +qYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763850270; x=1764455070;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7NyXHP81r6tLJnJ1NWALdU8H7382VS8IXYxSNq72IwU=;
        b=kH2R+Bj3jo9jGjmXpGaY0ohBaUJJo1gsXn5m+DdKO/mSI1R5R8CbxNqjMhdMDgp8T9
         eg7Tfjj8lBbzrKPFWFVdTO2dTLldKaB8MR0GAWr6/8iyma0RCjXXCF48Rj5FPkZLGXf4
         R7rzr7DLnnIqYH+TaQ9F25dgCZYNpFQJ2KS+vnNA2BSwVx42x1cdVsaoLPrAoEUNIiIR
         w9LM30z2zocHFJ9sH2Eagb3uFL6RIOziwlm7BfownBY4M3PaEWPGQZFLbdN6AN/XDOWs
         HBn2xboy9YWizRQm+7GKNLx+OWyV4eBma7fURIBmEVw1hpg8iRqCV/74BbmU+Soq7JQH
         67JA==
X-Forwarded-Encrypted: i=1; AJvYcCUwG2YMpARio8LH5KkEmQqW/8HToGMRcOJOgVi6OZQinXsFBlm6yw7fkMNXslCgdl1/UUZkETeSsQ==@kvack.org
X-Gm-Message-State: AOJu0YxUtvAXbHJ8bGt+pGBPsS9fKnoha6YOCF5AUwQFHRbMEcOqcjEI
	DE9UWr7A9ROjBC70DPnMt9LD3TuI0SH43vFWv9j23GMpeUmzVCgeH7i/LQ6/LDIXOeA=
X-Gm-Gg: ASbGncsAZy27L3GZShAvFb+Rf2JJwbO6U+2FAEjULrmwghmrayDENK8kdfpkEYoy9r2
	TUtI+GiX1Oe0T1pTMoPW4Lw1wQf6Q873tX6lwC6yL9C2pEChAH9TkFPlB6RKeETE/ki+ace87ht
	3aME6DqhPnfyjVQEsJTsaGn8FjDBFrkgKjwc+YT/ra4ekB5bJ/O3R1QzIuPfFWKUmsGAD0QsjW7
	gQXN20/ZpuspyJWSDyVwGFlFfkzWnFNYQujz0V/njI5qXxHEKEY4vJYbo5pr35h6pHxfndwbd7x
	FHE+XKOay+aqTn41ufh3uHscNeojlqrgch0nzYOJwrjCHAe1X46XjPxI24zKGHFPRXwgz+JHVE+
	coDw4LZTmwqKfylnOoEM2jTyTSZITE33IOg2WlpApsV9T1A1++m01Ps0mtLJ2ld2gysPPBvw4dK
	zq4RhqHEBfXb4/pzt7KPPWAbZl/6BfGBd4mMWouUURx0GqMlWSZ6dhKOxM1ekI28mSPWj2G7h9C
	ixsFTUybwQ8mZYdrg==
X-Google-Smtp-Source: AGHT+IFzv5/avEdgd5tUHj7WacQBSkpr9v1uz6r8Nm0HQcMeUJlEAdpnS7ZckZ4AJh/RKyqcXKm4RA==
X-Received: by 2002:a05:690c:d90:b0:787:e779:9ef8 with SMTP id 00721157ae682-78a7bb5a576mr91702437b3.16.1763850270094;
        Sat, 22 Nov 2025 14:24:30 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a79779a4esm28858937b3.0.2025.11.22.14.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 14:24:29 -0800 (PST)
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
Subject: [PATCH v7 17/22] selftests/liveupdate: Add kexec-based selftest for
Date: Sat, 22 Nov 2025 17:23:44 -0500
Message-ID: <20251122222351.1059049-18-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
In-Reply-To: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 4DAB04000F
X-Stat-Signature: nf7pr1sbaqoprkpdzt1fu5q7rjypiqh4
X-HE-Tag: 1763850271-554816
X-HE-Meta: U2FsdGVkX19aoJKH96nhp3TrKUE5urGjCxRzD8UPCBnwLY3otomofT4sBTrT34Tj9gC7UViBJglCognUlzBAY2It1KpTML3f1p4qn0GbK0PoAzQ4Fp+JS+jdjXPZiVcNP/zVy16gEr3NDKt1QovX2xe3gV9GXvfd0qkFxpiz6OSOmoT63rt21D4YBRhAJj/TLMRZGWuPlqhjH3Im/wiRfzw7NAEQDNN03R+zZV/PyUBtL+j03epYTi9sJ0T9KIkh1CqCn8va85J0mkOkdjdysUt23yB/DxU+AgMpLEQdh0NAwEDIRDaMSFWuovpvy+udsLfZaNUflbLUCiUUKuntmwSltwIoF0ANyVxpOr0fLvd8U8Zzb9Osinz4Nz4ny3zwZxCjjLY8iGwsx6qL6S2R7rYymLDxPB9SO5Pkvbz+vvR7yT1gkse7m5iCUIXEgP1xVsxsEONMOhCB1BewHL4EWJNz6A9vfzjWTMB4zvnqiUlRdbPOom0/Y28LJKCAqi5AEC8Cdvqn+SRkh4q17kkqXALtMKj+mr270CIa6i7VWvsKQt7lbfQfbnP8UscbX7vpDgskncNOLzZtC+2QIZTe88HxkCrwVIHPdx9ZHFZmaRp18kA47MoPXvL9cb7L7TxB42ypJ/tJISRscZ0d/HtmTDtwKyJfwUVRZgVH6xNK/eqWmXGD7S+nt3DDmKJj6ODJTbzxaWNdEzVizEVTpT5ro2VQgsn7IcSQMKQSi8BhvKGF/YGiMjtHUqAPDDuzEZyTFIdwN3WJ4ssSZlFInNXIZCl0HlUcFUrCdBdwuDLHRBI0lOtYgOOQz/dXsHT/nokkLTjxKqpk441oJ8KYcz/0CCbap/M+23r5RIyy+i4OF6d09A4H4ta3KGF8/Wys7fu5Qzq/VuljOawCABpCW1t43gI2lFzeD/Fk9vrkRCMGVq37rnnAZ0XxQhtoxpqmsGZpR4LUd3qrY9zr4KxHbwQ
 FWQSo5K+
 lwwDtfdS07BYJXTinyQIoQUSjgYFvx5I+ijFrnxmQ6sU7p+70276Qt/1yEMTzgXplSXKrEj09DSbHxYpjkkOnipCIoiDpP1ORJeUYkDxp5qxCuuNTbg8VGXFmPlBXozTZng5+eGCkjfj5HpkHNjaGFyyJWyVS0odxEHZS0pnPmOfgUeIxB8p89SF4/wIotMf7FIhVxippUpTNedsCPNMTByAMO9sgLAT/ypUhuv3Jpju6taqhzZkUcvEvqAjl+flcWFuZToLtGN2NuAeNbeFTF977AnboVisN4zvq49YVAN1FwViFw9gdyYmP01Qji+rb9PJcZ0bU3bwo1mOktutnTm5FCPJ0jsW1FzDbIIPYLrZRrHTiMEOEsTPX0edhy+ys/j6hDEarCxWirnhzzwBw37Omo24hAWQAr9sqS3MhmufnDauav1yTMy0aUw==
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
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
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
2.52.0.rc2.455.g230fcf2819-goog


