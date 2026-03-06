Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19C08F513E9
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 00:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC8F26B0005; Thu,  5 Mar 2026 19:21:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D76A46B0089; Thu,  5 Mar 2026 19:21:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C75AA6B008A; Thu,  5 Mar 2026 19:21:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B73AD6B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 19:21:23 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2ED2D13A40D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 00:21:23 +0000 (UTC)
X-FDA: 84513734046.23.84A3B45
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf07.hostedemail.com (Postfix) with ESMTP id 47A7F40006
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 00:21:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=AXjAWSob;
	spf=pass (imf07.hostedemail.com: domain of aleksey.oladko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=aleksey.oladko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772756481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=j5sV4+wUvNOc3xS7CkrG8KEGHYOk7JpcEgiSOK3kguU=;
	b=6+T7joZG5p4wXD00WQt5HGvoRPF1HI11dfg7nmouB2ifJS0TA3ItZSR9ip5OAVNVflXLsV
	cmd4cWXTXfwH4C4GhRL7hfkNof8AaXEX+8ObFi6sYezrPydgJxyAkelYGBWrqcQp04HMjg
	RClTaMlxbTeBI+G5C4GE2idlhwmP/E4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=AXjAWSob;
	spf=pass (imf07.hostedemail.com: domain of aleksey.oladko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=aleksey.oladko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772756481; a=rsa-sha256;
	cv=none;
	b=hoj70RHgnj7BQBA1sIqdlm0xNhcQn9R4tawyq0fC4krDPFso1zGr14dM2n9XjlE3QhAi3C
	wl9vHwvMCvtje+yfW7xf9b/vRVw/015rREJrqNwzH2FM3U58iez4BUETCZu0BNY0w0s1fc
	EIxI6ccVklHr0+z687Y8Kcm1F+F+4wc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=MIME-Version:Message-ID:Date:Subject:From:
	Content-Type; bh=j5sV4+wUvNOc3xS7CkrG8KEGHYOk7JpcEgiSOK3kguU=; b=AXjAWSobMRol
	20h18D2GlepRE9enrygSuX0r1WN9naeYhUBjpfWPU5RO5akN8qpT3Y0p3+wKjRVrl1d/LISqtEy/O
	7384bWx5AGh0MwexSpiRtM50XRNH8YIPWpT9fkjhgdoQOfN7dsIYhEQZDmve3pGtUZPAdElyr8jd9
	VvtKsRvrSnv/BUZpCvygoIP+huEXXUu9p8eipR+SPHHzl9VrW4fhbLMbyZjcS/5sRiWGHLykE6AkH
	DGPNFpqh2atETX9aFQAW99JVgREHT0nVJWdBM0SN1ABV7ALMqM9+g8yzSEIo5np4qYoDL+bc83ouH
	ngm/AAd0YhrMFb6LXmRJRA==;
Received: from [130.117.225.5] (helo=dev004.aci.vzint.dev)
	by relay.virtuozzo.com with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <aleksey.oladko@virtuozzo.com>)
	id 1vyIuk-006nPE-06;
	Fri, 06 Mar 2026 01:21:05 +0100
Received: from dev004.aci.vzint.dev (localhost [127.0.0.1])
	by dev004.aci.vzint.dev (8.16.1/8.16.1) with ESMTPS id 6260L6d0519684
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 6 Mar 2026 00:21:06 GMT
Received: (from root@localhost)
	by dev004.aci.vzint.dev (8.16.1/8.16.1/Submit) id 6260L1JW519683;
	Fri, 6 Mar 2026 00:21:01 GMT
From: Aleksei Oladko <aleksey.oladko@virtuozzo.com>
To: Shuah Khan <shuah@kernel.org>, Kees Cook <kees@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Seth Forshee <sforshee@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>,
        Babu Moger <babu.moger@amd.com>, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
        Abhinav Saxena <xandfury@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Aleksei Oladko <aleksey.oladko@virtuozzo.com>
Subject: [PATCH] selftests: do not override CFLAGS set by the build environment
Date: Fri,  6 Mar 2026 00:21:00 +0000
Message-ID: <20260306002100.519673-1-aleksey.oladko@virtuozzo.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z6yjnpu1adhf6ctomnfn4x8e47dgk4fg
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 47A7F40006
X-HE-Tag: 1772756481-532724
X-HE-Meta: U2FsdGVkX1/i+NK2sM+rIYEn3axjeukFZghYyRqW5RqFOME5S0Fkwmptud/lUyBz5lxsgvNTcNEF+zM01XfddzHCkybpNKNrVoYFgWR0A5j81mSEJh3rjWnjwhNsbbPJP+R++D7r3Ja37siWWfIjVYZOpNLjl5y00kfjXZI9/iq4mE//06MwjvGb6SDuxaKK0iozot4raIYmgUwYKRsYCiv0fJCmyvXK3hvFGW6jpL8vzPg/7R0Km3QLIud7rJ2kxmfUt2TK2lwWcRseoEZ8E2uG8921/csUcIMd1o4st80viEMUkyDt1c4Yc7OYex/Q2lgNoGCjAiYYG88Wp6BG0xKfLPWTh4XrVlgEEaIE7ADYrf0f0FaNOMYVogHRv8Gch/MwJdSiUVb17/nP3a1pXp9to7pE4hvdwcm7lK50UlC4bUTp574/3NAqMaXKbBlcYvrFz3ZVdapIjcmIRrFRMPivIsvc8+AFci347rE1tYg2Il+zpw5TkdbGQzWmoRTP3I3lcOOw99vIbytQ/qj2RUP5DOrR/0rnEunIa1XVxjEfYUX/aLUqAQtZzue/RpKEO7KtzN5Hd62cSiO938WnJwb3QAP+HHuqInnaxHtNGr+4s6VBIimpQ8ePt2jVdkRXZLzO4NAeZGmMMu7ylLdYtOvO6LLuE4owILz0SWRY95hbjsyihFpvjoa9Imc9doDMUUKkRGLQ8BuIKPc0lNPh73Zs406sBEg+EJH+l1BdCO+1AZsLgLZzxocTmcpCboF/EH8RFE2OSnCR1sW0e+TZaDPAuebR8QS1uyfzl0zu2XkeLCzu0Ei/MTvy4Byd3jfNoZSUvuVFSvcO5EKRfFA9OSmuwRicB/WQ3qVgdTeOpqLZA+8r5jYJ3LIaf4xhWEXsRk4tqWsV/ddQRN00mAVQJTQv6lo5b2QDu2Vee4KnO1n3kMlC3X0x2JAKTl5JJS18LeiGYpOlZl/lncC4y7d
 bHoia5J7
 nyD+LwkzV4b68OF4qO0vIjDdR08n1BSGA0YWuQoD7b48zn8F8lZT4nFv1LrTrxWd/1SQRpiD0IthdZvXSdp5YiWDFyh5KAIdic1sViKp2Ln5ndvw5MKuEy/atVYu2LKUilJ7Pe0gHGuce1IKLCUECG8GaVdrb7CwJPgVg8L2gsVuE3vKnYKd6kde0BJu/Z8c+4+VbPVjVFfNxlgaPw0U5Ohko+ikSSIF/9IySDlDVQrBOwuQEwoX6ML0ocQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some kselftests Makefiles assign CFLAGS using 'CFLAGS=...'
which overrides any CFLAGS provided by the build environment.

If the environment set flags, overriding CFLAGS may result in
inconsistent compiler and linker options and cause build failures,
for example when building PIE binaries:

  # export CFLAGS="-fPIE"
  # export LDFLAGS="-pie"
  # make -C tools/testing/selftests/ TARGETS=mount_setattr
  make: Entering directory '/build/kernel/tools/testing/selftests'
  make[1]: Entering directory '/build/kernel/tools/testing/selftests/mount_setattr'
    CC       mount_setattr_test
  /usr/bin/ld: warning: -z pack-relative-relocs ignored
  /usr/bin/ld: /tmp/ccikConN.o: relocation R_X86_64_32 against `.rodata.str1.8' can not be used when making a PIE object; recompile with -fPIE
  collect2: error: ld returned 1 exit status
  make[1]: *** [../lib.mk:222: /build/kernel/tools/testing/selftests/mount_setattr/mount_setattr_test] Error 1

Fix this by appending to CFLAGS using 'CFLAGS+=' instead of
overriding them.

The fix is not applied to the Makefiles in x86, riscv, mm, arm64
and powerpc as they fully define their flags.

Signed-off-by: Aleksei Oladko <aleksey.oladko@virtuozzo.com>
---
 tools/testing/selftests/efivarfs/Makefile             | 2 +-
 tools/testing/selftests/exec/Makefile                 | 2 +-
 tools/testing/selftests/firmware/Makefile             | 4 ++--
 tools/testing/selftests/ipc/Makefile                  | 4 ++--
 tools/testing/selftests/mount/Makefile                | 4 ++--
 tools/testing/selftests/mount_setattr/Makefile        | 2 +-
 tools/testing/selftests/move_mount_set_group/Makefile | 2 +-
 tools/testing/selftests/resctrl/Makefile              | 2 +-
 tools/testing/selftests/safesetid/Makefile            | 2 +-
 tools/testing/selftests/signal/Makefile               | 2 +-
 tools/testing/selftests/timens/Makefile               | 2 +-
 tools/testing/selftests/tty/Makefile                  | 2 +-
 tools/testing/selftests/vDSO/Makefile                 | 2 +-
 13 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/efivarfs/Makefile b/tools/testing/selftests/efivarfs/Makefile
index e3181338ba5e..f6c412059af3 100644
--- a/tools/testing/selftests/efivarfs/Makefile
+++ b/tools/testing/selftests/efivarfs/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
-CFLAGS = -Wall
+CFLAGS += -Wall
 
 TEST_GEN_FILES := open-unlink create-read
 TEST_PROGS := efivarfs.sh
diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index 45a3cfc435cf..54cdefb9ccb0 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS = -Wall
+CFLAGS += -Wall
 CFLAGS += -Wno-nonnull
 CFLAGS += $(KHDR_INCLUDES)
 
diff --git a/tools/testing/selftests/firmware/Makefile b/tools/testing/selftests/firmware/Makefile
index 7992969deaa2..dd9acf972cf5 100644
--- a/tools/testing/selftests/firmware/Makefile
+++ b/tools/testing/selftests/firmware/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 # Makefile for firmware loading selftests
-CFLAGS = -Wall \
-         -O2
+CFLAGS += -Wall \
+          -O2
 
 TEST_PROGS := fw_run_tests.sh
 TEST_FILES := fw_fallback.sh fw_filesystem.sh fw_upload.sh fw_lib.sh
diff --git a/tools/testing/selftests/ipc/Makefile b/tools/testing/selftests/ipc/Makefile
index 50e9c299fc4a..5a5577767a35 100644
--- a/tools/testing/selftests/ipc/Makefile
+++ b/tools/testing/selftests/ipc/Makefile
@@ -3,11 +3,11 @@ uname_M := $(shell uname -m 2>/dev/null || echo not)
 ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
 ifeq ($(ARCH),i386)
         ARCH := x86
-	CFLAGS := -DCONFIG_X86_32 -D__i386__
+	CFLAGS += -DCONFIG_X86_32 -D__i386__
 endif
 ifeq ($(ARCH),x86_64)
 	ARCH := x86
-	CFLAGS := -DCONFIG_X86_64 -D__x86_64__
+	CFLAGS += -DCONFIG_X86_64 -D__x86_64__
 endif
 
 CFLAGS += $(KHDR_INCLUDES)
diff --git a/tools/testing/selftests/mount/Makefile b/tools/testing/selftests/mount/Makefile
index 2d9454841644..38361a896363 100644
--- a/tools/testing/selftests/mount/Makefile
+++ b/tools/testing/selftests/mount/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for mount selftests.
-CFLAGS = -Wall \
-         -O2
+CFLAGS += -Wall \
+          -O2
 
 TEST_PROGS := run_unprivileged_remount.sh run_nosymfollow.sh
 TEST_GEN_FILES := unprivileged-remount-test nosymfollow-test
diff --git a/tools/testing/selftests/mount_setattr/Makefile b/tools/testing/selftests/mount_setattr/Makefile
index 4d4f810cdf2c..fbdb8f69b548 100644
--- a/tools/testing/selftests/mount_setattr/Makefile
+++ b/tools/testing/selftests/mount_setattr/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for mount selftests.
-CFLAGS = -g $(KHDR_INCLUDES) -Wall -O2 -pthread
+CFLAGS += -g $(KHDR_INCLUDES) -Wall -O2 -pthread
 
 LOCAL_HDRS += ../filesystems/wrappers.h
 
diff --git a/tools/testing/selftests/move_mount_set_group/Makefile b/tools/testing/selftests/move_mount_set_group/Makefile
index 94235846b6f9..8771a5491ea3 100644
--- a/tools/testing/selftests/move_mount_set_group/Makefile
+++ b/tools/testing/selftests/move_mount_set_group/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for mount selftests.
-CFLAGS = -g $(KHDR_INCLUDES) -Wall -O2
+CFLAGS += -g $(KHDR_INCLUDES) -Wall -O2
 
 TEST_GEN_FILES += move_mount_set_group_test
 
diff --git a/tools/testing/selftests/resctrl/Makefile b/tools/testing/selftests/resctrl/Makefile
index 984534cfbf1b..1d566a91faa7 100644
--- a/tools/testing/selftests/resctrl/Makefile
+++ b/tools/testing/selftests/resctrl/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-CFLAGS = -g -Wall -O2 -D_FORTIFY_SOURCE=2
+CFLAGS += -g -Wall -O2 -D_FORTIFY_SOURCE=2
 CFLAGS += $(KHDR_INCLUDES)
 
 TEST_GEN_PROGS := resctrl_tests
diff --git a/tools/testing/selftests/safesetid/Makefile b/tools/testing/selftests/safesetid/Makefile
index e815bbf2d0f4..d3811515d8e3 100644
--- a/tools/testing/selftests/safesetid/Makefile
+++ b/tools/testing/selftests/safesetid/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for SafeSetID selftest.
-CFLAGS = -Wall -O2
+CFLAGS += -Wall -O2
 LDLIBS = -lcap
 
 TEST_PROGS := safesetid-test.sh
diff --git a/tools/testing/selftests/signal/Makefile b/tools/testing/selftests/signal/Makefile
index e0bf7058d19c..6c437f95132d 100644
--- a/tools/testing/selftests/signal/Makefile
+++ b/tools/testing/selftests/signal/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
-CFLAGS = -Wall
+CFLAGS += -Wall
 TEST_GEN_PROGS = mangle_uc_sigmask
 TEST_GEN_PROGS += sas
 
diff --git a/tools/testing/selftests/timens/Makefile b/tools/testing/selftests/timens/Makefile
index f0d51d4d2c87..357077792395 100644
--- a/tools/testing/selftests/timens/Makefile
+++ b/tools/testing/selftests/timens/Makefile
@@ -1,7 +1,7 @@
 TEST_GEN_PROGS := timens timerfd timer clock_nanosleep procfs exec futex vfork_exec
 TEST_GEN_PROGS_EXTENDED := gettime_perf
 
-CFLAGS := -Wall -Werror -pthread
+CFLAGS += -Wall -Werror -pthread
 LDLIBS := -lrt -ldl
 
 include ../lib.mk
diff --git a/tools/testing/selftests/tty/Makefile b/tools/testing/selftests/tty/Makefile
index 7f6fbe5a0cd5..e9c22dafe5e1 100644
--- a/tools/testing/selftests/tty/Makefile
+++ b/tools/testing/selftests/tty/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS = -O2 -Wall
+CFLAGS += -O2 -Wall
 TEST_GEN_PROGS := tty_tstamp_update tty_tiocsti_test
 LDLIBS += -lcap
 
diff --git a/tools/testing/selftests/vDSO/Makefile b/tools/testing/selftests/vDSO/Makefile
index e361aca22a74..1f4628ceb975 100644
--- a/tools/testing/selftests/vDSO/Makefile
+++ b/tools/testing/selftests/vDSO/Makefile
@@ -11,7 +11,7 @@ TEST_GEN_PROGS += vdso_test_correctness
 TEST_GEN_PROGS += vdso_test_getrandom
 TEST_GEN_PROGS += vdso_test_chacha
 
-CFLAGS := -std=gnu99 -O2 -Wall -Wstrict-prototypes
+CFLAGS += -std=gnu99 -O2 -Wall -Wstrict-prototypes
 
 ifeq ($(CONFIG_X86_32),y)
 LDLIBS += -lgcc_s
-- 
2.43.0


