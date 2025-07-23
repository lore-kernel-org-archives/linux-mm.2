Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3FBAC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB8466B0125; Wed, 23 Jul 2025 10:47:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E68C36B0126; Wed, 23 Jul 2025 10:47:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE32D6B0127; Wed, 23 Jul 2025 10:47:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B790E6B0125
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8E9B4133799
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:42 +0000 (UTC)
X-FDA: 83695808364.04.FD27771
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	by imf11.hostedemail.com (Postfix) with ESMTP id AAF4E40003
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=AifVGBGh;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oWmBXVjGh1wc/IzDBDeCQXSx4hXhB+JQyCN77jCTWMc=;
	b=A1vgdMAlKZnqzf8Gf5uVvrNbiOHhn+AWr9JKUZmqwXVGxmL6ezb1T5mmXt2ZHTusJUBYvT
	dCT5+s2koc0+4nSr8jmvnFWLDPsZHOpy8FrLg9w89awwx2WeZa0wYMovGA3vhJjxXsqFBH
	yuUZWF9QIhMrBwzI+nRIn7P+RRLSq/A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282060; a=rsa-sha256;
	cv=none;
	b=T29xxJgj+UMgvPxwdiUtA1NK6H+ocyLLW7AAVXzwTrBAHEAIomdkP0Y8E8HMLatvWWofAk
	0vM03/hstHTtZAYA0ITemYVeM6UMhx7hao9tdzwL+MCHCWdtZ3pevUjl7cLACM/xZBcx2P
	PtHdxBb+ZKscU8aOwkLhI6vdu6HrPrA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=AifVGBGh;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e8d7122c3a5so5872691276.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282060; x=1753886860; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oWmBXVjGh1wc/IzDBDeCQXSx4hXhB+JQyCN77jCTWMc=;
        b=AifVGBGhNtcRl4emuxed0ksSTC8aOMnhT3BrfnbnJjNnasr/AqC+LJzjqKX7p6qKF2
         E+NgJglQ967DxYFjxQTkKUfAoci+i9n0zdPal1wr+qVfy2D6M1t+K1gK5GMVmW5S2b/q
         YXlFwWcMeYS//EUQ2jqsbihcvbaH/F0p5dMvr0uY/a6bMOCsMxv1ezrXPdFvraXOkhq2
         DPxqxbpaFjQayXrva+DZp6JHMB6ptKgmC6B4tfoyWwN9KEkg5WrUF9r44LTujq+R1dj8
         z8VLidXjVaAonI9rQr36g7DtMybdP1IR5KztGIdOYtz6o0i9ZnDuV3jXHakE08FeA3yZ
         tIWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282060; x=1753886860;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oWmBXVjGh1wc/IzDBDeCQXSx4hXhB+JQyCN77jCTWMc=;
        b=dH3zNIKkIUzTwscHdkpxOFZrsc6DXg6l3vsYmbR1jze98Fk0Z54nOSzdPIQe9QSe27
         skTuO5mqfVPX+fPtZP9h0fqMkD34eJTF0Y4kRTUPhuE+Rkq6QrGLiI1ydNNxsIEaxyWS
         XS+u01hDY6zQREsBDUt68lpCkrFcrnl/8W5UEhNJNXlQJ7f6rncMNox+or+QV70crVC2
         Tf6jvAePj2EOiqq2iUb5c9R88bzo+ucwfR2BU7ElbxcmUv0xBL58pYfXIhqXNdL2bxO9
         Cr1sRQpI5Zn3V9KLKiuHxFfV3tMC4fgs5WXo9A26wPbgT1uBsyiB6Ne/px86n/6iMPu6
         hznw==
X-Forwarded-Encrypted: i=1; AJvYcCWh99OIS/1LIrEcDbkjEuvi2A3x7DhXSymEio5K/9aXMXHfKAG5RLa0rms1zfdagByFFtStFAwodQ==@kvack.org
X-Gm-Message-State: AOJu0YzFG8oWU50JR5DXTgNotD74MZBwEawUslFD428rM0r/0vdbJJ0w
	vS/xuuCAAPClVap+ncVQvpOQThbm3keuhKSF9tXXfJlg7PKacqE9wWSdKKHVelcQ6Qs=
X-Gm-Gg: ASbGncvHPv3Tz+OxXHuc3rZtLel5/g/76uhySNdpmsn38uWNW7BAtR6/yX9GkU9yR3D
	yhtdEQlYb10qPaGlPAU9r/RPwidEMprmCWWX6+STxe3SNZsKHvRVBeXYKF8/BzWVgnrpCE3zl+N
	xCtAFsjw6rWmeaRnrKCJyfGpJDjKZJANd7ZrUSHzo4hDtYoub24tZGAnh5GX27Al7VcGC2BP9FC
	H4SosTYdM8FpQQBpo27a92Yth4YTJcU89zYn2Ie2XCCYa188OmD2rGrjrdPtEPzP1+2hnyCc/7E
	1C+450cDCd4buEn+zp4AEzaLBdmJ+zOXP2+DIMNVllPcQk/GU/avQkHvufNX13vdHGnnOOkVF0U
	L8U39n7ImZvu7tcPh63oGmv9ozM7y9KO19DUiMaN5AGBYr/956YVeqjCUUvDjm6hdHTsLNRppke
	Df7ey/Sg+UgRTtog==
X-Google-Smtp-Source: AGHT+IEBhojheZGJ6Q8/J2Jc3qfebiDxZt2nYMumXzSS9twbam4ZudlzHL8AvgdpH7YpzOzJmZiVmA==
X-Received: by 2002:a05:690c:6087:b0:718:a975:d4f6 with SMTP id 00721157ae682-719b424d291mr46021797b3.31.1753282059487;
        Wed, 23 Jul 2025 07:47:39 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:47:38 -0700 (PDT)
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
Subject: [PATCH v2 22/32] selftests/liveupdate: add subsystem/state tests
Date: Wed, 23 Jul 2025 14:46:35 +0000
Message-ID: <20250723144649.1696299-23-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AAF4E40003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 4ds574x1t9zheefzfwjy13o3hwz3tdw1
X-HE-Tag: 1753282060-747037
X-HE-Meta: U2FsdGVkX18FnsnyWejGuXDuX43l0Hd2wGaN2aqPmLyHAlUlAoL374ElR5yQS2Z75ri322uwxrGZbNXu/XBBUFWslwHuR+fTIqNtxacB+lRroFUfE9Y7Sq9h8tYlwfEQcSQt9epwHtaQ2QBB0j5GkvDENcJ8QJv/XrIqrIb0SoiNbHUBSRbMOS7QV76Kpq4i7j9GlsmAPsReEmIYkUGLhUc8I6v4Ll5pmjtX/CsMaOBnZwKEhLc7S3N2Ys/kMCnL2TX8uE4pw3RdEmfPIwHataGjVGghTl/BpSm9cGaadxoAqxuBLGmu6IB3XxnLnlf61FYPmtFZi1yyWGn9jR8Uhu59mgKe1gulQgDM1/kfo+LfM3fspVeczRjTEZBQD/0IKwDs1NVLK9tWz/DEbHVzRz2655HPipC8+xzNyCiWSxppPQxKeN42WwlQq2utWScQalzOtfGF6nYZAk+87h3Ihx1Dsw1ZOg0UJb7yGWeV2Kel8P+XzZ03IyGKr6kpzlxmRExJDpxeUclxc24sxjk3MYiOZsmyFQ3dxf3xWgAy6kKiUvA+kA6osY621c1u2VAIxYU+Q7x74bh67K/pHVs5TFDNmVhCSQVZuIp/Y3Dj4iNjqGyrua/QK/+IAOpvZ9JHOOvXQsyizVa5RGYTUy8hKHb/YCbfZMh1B+LLTC+T+r2D4BCOt/XDzJFpV6y5blMoMclL8pEbJb/hDmGIM6UKh/Y/6g3Fh1aXF8bnqEGETVWKmv3oLMHlXMz0OdYRKleB8o+MjwJa5Y+KqLGIjmm9bWR9ETFhDctT01wcmuVjbgeMorgE3wRKlUX/b79KoHplPJDQvqpxtsPx2EVOwXNUJ4JjCs3XYjyy/7OUjgcoSORcOlX4fCi82jqg5DAVCHcBnVbQCD0o/FYLkSsIxCeYtWdADfqFGnXfAuygUyBA1WUynbX9YyiNihDOBvPufHY5zMDlntqLR4NykWVTlyV
 hMl2zrj+
 L9QMPd/LwLpzuaGbe4IKks1iM08e5hRvFZXObnIurgsxtz1VFiEqUybBfN833xKLtgMJvbjhbL2jk1fqSVvQ7R+jNXR3BIRaofMXhAoQBbb5kKLO7bEFTgAH5belO/EtfG+cOJhGnZgMbGA058nLyfsuVayMNJgoHshEjSfKlDqknRetLz7CErDGIIeYZewOIYZlthuTqjEvdFnfQobL+1xHDSgAsTiD4ntuQHXb0B5HYBqgjAWkpT8dz7HSTH6AVHwE1tMxGqohvHF52h21DEDDHM8IkKffTYKiW7C1l+G0BSG2PGXxelJW5v1aVKk27pMxhmxJLjhYoQnSJdhdgH/zVX4sLXEPtGhtYK9isyBBTLz+dOGlyIfi+8H6O+CKE55YBxkF5il+YTiqkj/vBhXjxBd0G4UhQj0Tx1F04JZFdhG7J7FfAqkhluTjGAvfLAZ8mtrS5/ajOtgrNwSJHMenUCW/Pzl3dLX7NOMfwPumb4adBy4+nWZV8qw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduces a new set of userspace selftests for the LUO. These tests
verify the functionality LUO by using the kernel-side selftest ioctls
provided by the LUO module, primarily focusing on subsystem management
and basic LUO state transitions.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/liveupdate/.gitignore |   1 +
 tools/testing/selftests/liveupdate/Makefile   |   7 +
 tools/testing/selftests/liveupdate/config     |   6 +
 .../testing/selftests/liveupdate/liveupdate.c | 356 ++++++++++++++++++
 5 files changed, 371 insertions(+)
 create mode 100644 tools/testing/selftests/liveupdate/.gitignore
 create mode 100644 tools/testing/selftests/liveupdate/Makefile
 create mode 100644 tools/testing/selftests/liveupdate/config
 create mode 100644 tools/testing/selftests/liveupdate/liveupdate.c

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 339b31e6a6b5..d8fc84ccac32 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -53,6 +53,7 @@ TARGETS += kvm
 TARGETS += landlock
 TARGETS += lib
 TARGETS += livepatch
+TARGETS += liveupdate
 TARGETS += lkdtm
 TARGETS += lsm
 TARGETS += membarrier
diff --git a/tools/testing/selftests/liveupdate/.gitignore b/tools/testing/selftests/liveupdate/.gitignore
new file mode 100644
index 000000000000..af6e773cf98f
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/.gitignore
@@ -0,0 +1 @@
+/liveupdate
diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
new file mode 100644
index 000000000000..2a573c36016e
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0-only
+CFLAGS += -Wall -O2 -Wno-unused-function
+CFLAGS += $(KHDR_INCLUDES)
+
+TEST_GEN_PROGS += liveupdate
+
+include ../lib.mk
diff --git a/tools/testing/selftests/liveupdate/config b/tools/testing/selftests/liveupdate/config
new file mode 100644
index 000000000000..382c85b89570
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/config
@@ -0,0 +1,6 @@
+CONFIG_KEXEC_FILE=y
+CONFIG_KEXEC_HANDOVER=y
+CONFIG_KEXEC_HANDOVER_DEBUG=y
+CONFIG_LIVEUPDATE=y
+CONFIG_LIVEUPDATE_SYSFS_API=y
+CONFIG_LIVEUPDATE_SELFTESTS=y
diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
new file mode 100644
index 000000000000..989a9a67d4cf
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -0,0 +1,356 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#include <errno.h>
+#include <fcntl.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+
+#include <linux/liveupdate.h>
+
+#include "../kselftest.h"
+#include "../kselftest_harness.h"
+#include "../../../../kernel/liveupdate/luo_selftests.h"
+
+struct subsystem_info {
+	void *data_page;
+	void *verify_page;
+	char test_name[LUO_NAME_LENGTH];
+	bool registered;
+};
+
+FIXTURE(subsystem) {
+	int fd;
+	int fd_dbg;
+	struct subsystem_info si[LUO_MAX_SUBSYSTEMS];
+};
+
+FIXTURE(state) {
+	int fd;
+	int fd_dbg;
+};
+
+#define LUO_DEVICE	"/dev/liveupdate"
+#define LUO_DBG_DEVICE	"/sys/kernel/debug/liveupdate/luo_selftest"
+#define LUO_SYSFS_STATE	"/sys/kernel/liveupdate/state"
+static size_t page_size;
+
+const char *const luo_state_str[] = {
+	[LIVEUPDATE_STATE_UNDEFINED]   = "undefined",
+	[LIVEUPDATE_STATE_NORMAL]   = "normal",
+	[LIVEUPDATE_STATE_PREPARED] = "prepared",
+	[LIVEUPDATE_STATE_FROZEN]   = "frozen",
+	[LIVEUPDATE_STATE_UPDATED]  = "updated",
+};
+
+static int run_luo_selftest_cmd(int fd_dbg, __u64 cmd_code,
+				struct luo_arg_subsystem *subsys_arg)
+{
+	struct liveupdate_selftest k_arg;
+
+	k_arg.cmd = cmd_code;
+	k_arg.arg = (__u64)(unsigned long)subsys_arg;
+
+	return ioctl(fd_dbg, LIVEUPDATE_IOCTL_SELFTESTS, &k_arg);
+}
+
+static int register_subsystem(int fd_dbg, struct subsystem_info *si)
+{
+	struct luo_arg_subsystem subsys_arg;
+	int ret;
+
+	memset(&subsys_arg, 0, sizeof(subsys_arg));
+	snprintf(subsys_arg.name, LUO_NAME_LENGTH, "%s", si->test_name);
+	subsys_arg.data_page = si->data_page;
+
+	ret = run_luo_selftest_cmd(fd_dbg, LUO_CMD_SUBSYSTEM_REGISTER,
+				   &subsys_arg);
+	if (!ret)
+		si->registered = true;
+
+	return ret;
+}
+
+static int unregister_subsystem(int fd_dbg, struct subsystem_info *si)
+{
+	struct luo_arg_subsystem subsys_arg;
+	int ret;
+
+	memset(&subsys_arg, 0, sizeof(subsys_arg));
+	snprintf(subsys_arg.name, LUO_NAME_LENGTH, "%s", si->test_name);
+
+	ret = run_luo_selftest_cmd(fd_dbg, LUO_CMD_SUBSYSTEM_UNREGISTER,
+				   &subsys_arg);
+	if (!ret)
+		si->registered = false;
+
+	return ret;
+}
+
+static int get_sysfs_state(void)
+{
+	char buf[64];
+	ssize_t len;
+	int fd, i;
+
+	fd = open(LUO_SYSFS_STATE, O_RDONLY);
+	if (fd < 0) {
+		ksft_print_msg("Failed to open sysfs state file '%s': %s\n",
+			       LUO_SYSFS_STATE, strerror(errno));
+		return -errno;
+	}
+
+	len = read(fd, buf, sizeof(buf) - 1);
+	close(fd);
+
+	if (len <= 0) {
+		ksft_print_msg("Failed to read sysfs state file '%s': %s\n",
+			       LUO_SYSFS_STATE, strerror(errno));
+		return -errno;
+	}
+	if (buf[len - 1] == '\n')
+		buf[len - 1] = '\0';
+	else
+		buf[len] = '\0';
+
+	for (i = 0; i < ARRAY_SIZE(luo_state_str); i++) {
+		if (!strcmp(buf, luo_state_str[i]))
+			return i;
+	}
+
+	return -EIO;
+}
+
+FIXTURE_SETUP(state)
+{
+	int state;
+
+	page_size = sysconf(_SC_PAGE_SIZE);
+	self->fd = open(LUO_DEVICE, O_RDWR);
+	if (self->fd < 0)
+		SKIP(return, "open(%s) failed [%d]", LUO_DEVICE, errno);
+
+	self->fd_dbg = open(LUO_DBG_DEVICE, O_RDWR);
+	ASSERT_GE(self->fd_dbg, 0);
+
+	state = get_sysfs_state();
+	if (state < 0) {
+		if (state == -ENOENT || state == -EACCES)
+			SKIP(return, "sysfs state not accessible (%d)", state);
+	}
+}
+
+FIXTURE_TEARDOWN(state)
+{
+	enum liveupdate_state state = LIVEUPDATE_STATE_NORMAL;
+
+	ioctl(self->fd, LIVEUPDATE_IOCTL_GET_STATE, &state);
+	if (state != LIVEUPDATE_STATE_NORMAL)
+		ioctl(self->fd, LIVEUPDATE_IOCTL_CANCEL, NULL);
+	close(self->fd);
+}
+
+FIXTURE_SETUP(subsystem)
+{
+	int i;
+
+	page_size = sysconf(_SC_PAGE_SIZE);
+	memset(&self->si, 0, sizeof(self->si));
+	self->fd = open(LUO_DEVICE, O_RDWR);
+	if (self->fd < 0)
+		SKIP(return, "open(%s) failed [%d]", LUO_DEVICE, errno);
+
+	self->fd_dbg = open(LUO_DBG_DEVICE, O_RDWR);
+	ASSERT_GE(self->fd_dbg, 0);
+
+	for (i = 0; i < LUO_MAX_SUBSYSTEMS; i++) {
+		snprintf(self->si[i].test_name, LUO_NAME_LENGTH,
+			 NAME_NORMAL ".%d", i);
+
+		self->si[i].data_page = mmap(NULL, page_size,
+					     PROT_READ | PROT_WRITE,
+					     MAP_PRIVATE | MAP_ANONYMOUS,
+					     -1, 0);
+		ASSERT_NE(MAP_FAILED, self->si[i].data_page);
+		memset(self->si[i].data_page, 'A' + i, page_size);
+
+		self->si[i].verify_page = mmap(NULL, page_size,
+					       PROT_READ | PROT_WRITE,
+					       MAP_PRIVATE | MAP_ANONYMOUS,
+					       -1, 0);
+		ASSERT_NE(MAP_FAILED, self->si[i].verify_page);
+		memset(self->si[i].verify_page, 0, page_size);
+	}
+}
+
+FIXTURE_TEARDOWN(subsystem)
+{
+	enum liveupdate_state state = LIVEUPDATE_STATE_NORMAL;
+	int i;
+
+	ioctl(self->fd, LIVEUPDATE_IOCTL_GET_STATE, &state);
+	if (state != LIVEUPDATE_STATE_NORMAL)
+		ioctl(self->fd, LIVEUPDATE_IOCTL_CANCEL, NULL);
+
+	for (i = 0; i < LUO_MAX_SUBSYSTEMS; i++) {
+		if (self->si[i].registered)
+			unregister_subsystem(self->fd_dbg, &self->si[i]);
+		munmap(self->si[i].data_page, page_size);
+		munmap(self->si[i].verify_page, page_size);
+	}
+
+	close(self->fd);
+}
+
+TEST_F(state, normal)
+{
+	enum liveupdate_state state;
+
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_GET_STATE, &state));
+	ASSERT_EQ(state, LIVEUPDATE_STATE_NORMAL);
+}
+
+TEST_F(state, prepared)
+{
+	enum liveupdate_state state;
+
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_PREPARE, NULL));
+
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_GET_STATE, &state));
+	ASSERT_EQ(state, LIVEUPDATE_STATE_PREPARED);
+
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_CANCEL, NULL));
+
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_GET_STATE, &state));
+	ASSERT_EQ(state, LIVEUPDATE_STATE_NORMAL);
+}
+
+TEST_F(state, sysfs_normal)
+{
+	ASSERT_EQ(LIVEUPDATE_STATE_NORMAL, get_sysfs_state());
+}
+
+TEST_F(state, sysfs_prepared)
+{
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_PREPARE, NULL));
+	ASSERT_EQ(LIVEUPDATE_STATE_PREPARED, get_sysfs_state());
+
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_CANCEL, NULL));
+	ASSERT_EQ(LIVEUPDATE_STATE_NORMAL, get_sysfs_state());
+}
+
+TEST_F(state, sysfs_frozen)
+{
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_PREPARE, NULL));
+
+	ASSERT_EQ(LIVEUPDATE_STATE_PREPARED, get_sysfs_state());
+
+	ASSERT_EQ(0, ioctl(self->fd_dbg, LIVEUPDATE_IOCTL_FREEZE, NULL));
+	ASSERT_EQ(LIVEUPDATE_STATE_FROZEN, get_sysfs_state());
+
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_CANCEL, NULL));
+	ASSERT_EQ(LIVEUPDATE_STATE_NORMAL, get_sysfs_state());
+}
+
+TEST_F(subsystem, register_unregister)
+{
+	ASSERT_EQ(0, register_subsystem(self->fd_dbg, &self->si[0]));
+	ASSERT_EQ(0, unregister_subsystem(self->fd_dbg, &self->si[0]));
+}
+
+TEST_F(subsystem, double_unregister)
+{
+	ASSERT_EQ(0, register_subsystem(self->fd_dbg, &self->si[0]));
+	ASSERT_EQ(0, unregister_subsystem(self->fd_dbg, &self->si[0]));
+	EXPECT_NE(0, unregister_subsystem(self->fd_dbg, &self->si[0]));
+	EXPECT_TRUE(errno == EINVAL || errno == ENOENT);
+}
+
+TEST_F(subsystem, register_unregister_many)
+{
+	int i;
+
+	for (i = 0; i < LUO_MAX_SUBSYSTEMS; i++)
+		ASSERT_EQ(0, register_subsystem(self->fd_dbg, &self->si[i]));
+
+	for (i = 0; i < LUO_MAX_SUBSYSTEMS; i++)
+		ASSERT_EQ(0, unregister_subsystem(self->fd_dbg, &self->si[i]));
+}
+
+TEST_F(subsystem, getdata_verify)
+{
+	enum liveupdate_state state;
+	int i;
+
+	for (i = 0; i < LUO_MAX_SUBSYSTEMS; i++)
+		ASSERT_EQ(0, register_subsystem(self->fd_dbg, &self->si[i]));
+
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_PREPARE, NULL));
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_GET_STATE, &state));
+	ASSERT_EQ(state, LIVEUPDATE_STATE_PREPARED);
+
+	for (i = 0; i < LUO_MAX_SUBSYSTEMS; i++) {
+		struct luo_arg_subsystem subsys_arg;
+
+		memset(&subsys_arg, 0, sizeof(subsys_arg));
+		snprintf(subsys_arg.name, LUO_NAME_LENGTH, "%s",
+			 self->si[i].test_name);
+		subsys_arg.data_page = self->si[i].verify_page;
+
+		ASSERT_EQ(0, run_luo_selftest_cmd(self->fd_dbg,
+						  LUO_CMD_SUBSYSTEM_GETDATA,
+						  &subsys_arg));
+		ASSERT_EQ(0, memcmp(self->si[i].data_page,
+				    self->si[i].verify_page,
+				    page_size));
+	}
+
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_CANCEL, NULL));
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_GET_STATE, &state));
+	ASSERT_EQ(state, LIVEUPDATE_STATE_NORMAL);
+
+	for (i = 0; i < LUO_MAX_SUBSYSTEMS; i++)
+		ASSERT_EQ(0, unregister_subsystem(self->fd_dbg, &self->si[i]));
+}
+
+TEST_F(subsystem, prepare_fail)
+{
+	int i;
+
+	snprintf(self->si[LUO_MAX_SUBSYSTEMS - 1].test_name, LUO_NAME_LENGTH,
+		 NAME_PREPARE_FAIL ".%d", LUO_MAX_SUBSYSTEMS - 1);
+
+	for (i = 0; i < LUO_MAX_SUBSYSTEMS; i++)
+		ASSERT_EQ(0, register_subsystem(self->fd_dbg, &self->si[i]));
+
+	ASSERT_EQ(-1, ioctl(self->fd, LIVEUPDATE_IOCTL_PREPARE, NULL));
+
+	for (i = 0; i < LUO_MAX_SUBSYSTEMS; i++)
+		ASSERT_EQ(0, unregister_subsystem(self->fd_dbg, &self->si[i]));
+
+	snprintf(self->si[LUO_MAX_SUBSYSTEMS - 1].test_name, LUO_NAME_LENGTH,
+		 NAME_NORMAL ".%d", LUO_MAX_SUBSYSTEMS - 1);
+
+	for (i = 0; i < LUO_MAX_SUBSYSTEMS; i++)
+		ASSERT_EQ(0, register_subsystem(self->fd_dbg, &self->si[i]));
+
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_PREPARE, NULL));
+	ASSERT_EQ(0, ioctl(self->fd_dbg, LIVEUPDATE_IOCTL_FREEZE, NULL));
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_CANCEL, NULL));
+	ASSERT_EQ(LIVEUPDATE_STATE_NORMAL, get_sysfs_state());
+
+	for (i = 0; i < LUO_MAX_SUBSYSTEMS; i++)
+		ASSERT_EQ(0, unregister_subsystem(self->fd_dbg, &self->si[i]));
+}
+
+TEST_HARNESS_MAIN
-- 
2.50.0.727.gbf7dc18ff4-goog


