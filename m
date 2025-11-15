Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ED31CEBF86
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 23:35:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BB9A8E0027; Sat, 15 Nov 2025 18:35:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CFE98E0007; Sat, 15 Nov 2025 18:35:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E63DC8E0027; Sat, 15 Nov 2025 18:35:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6D738E0007
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 18:35:00 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 88676C084A
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:35:00 +0000 (UTC)
X-FDA: 84114449160.10.0B00861
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf03.hostedemail.com (Postfix) with ESMTP id AB77E20005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=U6KHTw1c;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763249698; a=rsa-sha256;
	cv=none;
	b=TPryYJyzArhSDGrwgjncie3VlA/yz4iyv9BgcxfTNfSYDMwAn9vxcEybLGjhsxOXTIC7Bd
	HH0BPxh8/6GRYQ2mVMadqmu68y2c4DCr2VBSfzmE584n4zzgG988PMV2a3vouyE3dusQf9
	Em2Jn9CrkCQPiPvXL29rxTid+SrmdpQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=U6KHTw1c;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763249698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wRnyVkZ6EghERA6gxAJfjyXqxf3e5UVSw+T69XyH00s=;
	b=4AZbMAIBMB3M/E5WFUOfHckJdYlus+i+LiMF+qkdyeaodJ4hviYjZthmkLYhARRe0qsY5k
	d45WvbkYZIlv6mjygDWdTuUq+GgXJ2k40i9OxMahlsIfN2DUvc1F1hr/pWXA915G3ny58P
	EXubcS+FvUwqx7WK58LLSjnZBJGj67A=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-78817f3af10so27574537b3.2
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 15:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763249698; x=1763854498; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wRnyVkZ6EghERA6gxAJfjyXqxf3e5UVSw+T69XyH00s=;
        b=U6KHTw1cvNWVqmNovf32Ai1FXEVl9xKeiUoDWKo9IbmsxJx2XUV1GygNBvfc9Jy3sT
         AWRBbOHJRFxu70t2eOR6TRAiEUDGGm3EyyYTSo2RldVWhn6FKOC8xV/9JFgINpftIltm
         381xN5WbYDtf+NpnFhJuSsFizipRXfvQt1/Ee3JREPLi8fxM/ug4ZaSjnHdfWJwMKSDK
         KztXhAAt8hUgpi0tm3+f7vMLv4bwMDraKSFEVyUuWaip/sshMBxqccMKm7o+TrPenlzO
         qR7to93DXCKApjRunTZ63SNSoP0V6nwJfZfx3d0ZZAblajYiQrvuzc2nx6koBrPz4QrB
         uQIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763249698; x=1763854498;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wRnyVkZ6EghERA6gxAJfjyXqxf3e5UVSw+T69XyH00s=;
        b=MIDOFtxor19LUQaol3f9MWXUe56AImhMwd32Z8958mnPgZu3GhOzka17wSMG/+aJb+
         qxuPfCkHZPH2eR610GDHrEmBr3ynC94uqqxLlyXaKYNxpdHQX7YN5USNrzxFNixctdsH
         CkVMFiMfIv/4ShgUzeBRZFnwN/6/tVesDrtmG0UpBteS2Nz8++4BqMt2/Q1ssfEgsH+3
         /R0VCpwl1Lz3R8yLjvKg99GTyzJ9JD78eBPcTnrPRKU8Gl3xffG+hTNjkjBXXpm1R53S
         +n4YhZ+iuWaCT6+8hnuRWwZGSzrizF6yYlVGnDdl07cdeiv8zjXPnUKsg1TUWaqo9Udl
         vXEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCrkLqvWkfSUBWKF1wkbpsTRpAk0+0EMy7UI9ebDROnOJfYhZcswDbb8IABWSjs6v8ELo3essQ9g==@kvack.org
X-Gm-Message-State: AOJu0YyeZppuckJJNIFw4P1RBbov0CeHvAWtJoSf+TcwUue8JccfPSMT
	sA9f72qDcmkCIovKtcoUn/NryAfiH8W35aXHKj9o9AiEr3+beqo0El/A09jAe9N8uVo=
X-Gm-Gg: ASbGnct5AAqpSe7pcoKsO2N4FYbMCWsCC008khTcDI3IDDCwi3i+tzbw8wDKA5wDD38
	Myt91pwXaRKW6YiPEU//Z8Zbt3o5kF153H6XmKjmzckX+mNGGIyb8rlhWUxrnmA0Ouop7vZpiNY
	Qy31yQIp4IRXpEEJBE8zfBbMU1MYsLCBBR040v2cqBDEwA7wqjc4QIltDud+E9/g6SISGRJmr4o
	fnRodiiREg+tJ7jxH5LagHn887yEYtKVUyDAQzHeFeEMwhoBkqX3aRURvV/9zcY1Iru3y+/jqwV
	n9INdgV2WnWU20p1pJbqN5HihWlNwTftdrtyxnrny1L9mRsdwmfPGFDNFeTgV86EAza811DvD1b
	yvigaeJgpGESOKPRHD1n4ad1TDFlUC5QHR1XjRG/Myvtv0JWGeL0stwl5skALHRXQP7HGPcG4YR
	LyrLavOf6LYgzuzfKDPz6NNsX2Z1bzURLhPakSynOjW5HBme29kHX9pdBxRa8C1fok4jmx
X-Google-Smtp-Source: AGHT+IHDs//g3Uj2SRlulGEN91ZpKSgLlg7OOvRRAkAuVjbPb4i6BumxwZieKZ9EfukQ2VNFeuNWMw==
X-Received: by 2002:a05:690c:25c4:b0:784:8cb4:d935 with SMTP id 00721157ae682-78929f17bfamr70697767b3.65.1763249697694;
        Sat, 15 Nov 2025 15:34:57 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7882218774esm28462007b3.57.2025.11.15.15.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 15:34:57 -0800 (PST)
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
Subject: [PATCH v6 18/20] selftests/liveupdate: Add kexec-based selftest for session lifecycle
Date: Sat, 15 Nov 2025 18:34:04 -0500
Message-ID: <20251115233409.768044-19-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251115233409.768044-1-pasha.tatashin@soleen.com>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AB77E20005
X-Stat-Signature: o3o9ord51c7w4nykzokacf7jd8ofqi1i
X-Rspam-User: 
X-HE-Tag: 1763249698-270915
X-HE-Meta: U2FsdGVkX19NPGM1UvZoDV8zMQBDYzQ1F/IdLvPvTgKnDBwBN/UfQET0KDvWyYW0mNbL16aN8uol3o3G5XW0jMlcQJm5ZLJRGKmoleM14jvWgWTLqC8xAiiZKRrsnMTExmIdBE8+88qTVj1mnv4OJjJND+2/noBqm0EafJQymH7mQeVkWAIKWhsXk2F4d/yFgqV1w+fmXRaSP8k/egwK6+C2RDxW3CEDWqd0zi359QZMT6YAHTudOduPVs1bSaM/REvbvRskx5r6pZkun0kI47PUfwR2t9iTKIIujNiSm/I54lQ/M+hz907y6TVAjhP6QwTjRR4zLE9dZCTTyxfnTsTbCFsP5RGpSrJgR07NK56C7Ef4y4fAO2S2sXo6xC+kGb99zfvg0k8yQ65bFUE0Ew3f17BG9M7lXN62nOjxA/P9WtFsntAsiZV72cPi13fwCrp6EVOAr22xLrdnOXT2KltPPtq1svIkhffTEz0G3d4KQf+DewLmBrzkPVpztDCD++96iI0xVzqPfng+7dKkOT73EOJbku/tUeKwJavRndGpWbN7gvjwgcwAA3+imFi2YbXIL2XbL4qQo8v6l+PLTV4z6wDCJovmxCXYePgp8lCNnn3TsxI1TbB7E1shMi4kl/q145CJlI+aKIqQ3UXMc17p1V7c6CHOr+1wjbqHLBrtvWp+9pcMgF/gSgzaKyurWS/+oqN/HhHUwRmu3WseQZs/mMjnYhJ57MFXrVe5bnrRHqDGfn4PbuCzolAF7tUvhp6NilMpiuqs16Ot99L3Q9QuXZWtGbv8wtUY0TUnq0/As/YvfqzegxNuLsTkdHAJ4RnhPELoCzbvRbyt4r9F5JTmbSY0m2ZIoGRm+TCCEjNvGegwBMS28EAr3asTe6j+m3Ee4R+GpsupT6HlEq6omoa7rq/lTa63JIUDIJA+cZ0662y5+TsCqzJeWqxoIQrbyGvu7y1c5X4BRkUaBcd
 K7luQeHh
 vFulCYKWtoiVasJY9SdTXWMLw8XcEc2t8V5FVDvtzoCXBQPcwJ+wrLjtQIkGwbKeK+0MAXU1x0AHIpsr3xPpQqkKocM4SNt3nvLAzXbf3VQEozEePCoxYgwVQxCK8UXsREqRjSo9gKvQ5S269Ts/D8qq7bCffkT/ngGBD9N4W1uIE8zMTzQAQUp7tN2K//MZJW67RGAwSi8B3FOGQBmWXlCa+VvETiFpBZGrfjW4nbqe3lLe1Qzxv+UnsCu7kswGPjOZIDy0Dznm5LVB4IdhKCJyAoPwdrcVs4jDpTOgYp0OfZIp6537n/q1+4UkG44DszmWLLMwGqJeD3RiM5u8qjHpjFUaXF+Az+Bh86zBgY7vTTHA+5VqULsQeEM4OS4J4g2zbONSRH06FEYjdsu03DHmnR0txRLsz/CzC00pSYTG0mQdxFpXDsqs5Dg==
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
 .../testing/selftests/liveupdate/do_kexec.sh  |  16 ++
 .../selftests/liveupdate/luo_kexec_simple.c   | 114 ++++++++++++
 .../selftests/liveupdate/luo_test_utils.c     | 168 ++++++++++++++++++
 .../selftests/liveupdate/luo_test_utils.h     |  39 ++++
 6 files changed, 370 insertions(+)
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
2.52.0.rc1.455.g30608eb744-goog


