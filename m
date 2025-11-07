Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12FA2CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 21:06:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C73858E001F; Fri,  7 Nov 2025 16:06:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DDE68E001A; Fri,  7 Nov 2025 16:06:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47EE98E001F; Fri,  7 Nov 2025 16:06:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 27E748E001A
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:06:12 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4BC7BA410
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:06:11 +0000 (UTC)
X-FDA: 84085043742.29.BC9FC4F
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id 27E9FA0012
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:06:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Beejb8FL;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762549570; a=rsa-sha256;
	cv=none;
	b=w6Jxe0eAf77k9wK017uRU8e1D4URCyWC6t039gHx6GZe4vBXPgPz0zcZ53NZPiZvK3WwV9
	DTJXL7ZHaFaxNE2D+WywMISIZjM48LIYTLlwx5+lWh2iBZBspH+9ZQ8/UGsNAIAnjHPo+h
	+dx+a7ejWzJ8YV/BPrnjX4J98h7zk64=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Beejb8FL;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762549570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2SXDWAbA53PdIOw33GR0LKCvwxTUGeSycQUW5TmKy64=;
	b=KgPGykJFSF/CDN96rhZjzw/mv9453Lc9QM5m7k/OL65PURLunDD1uUtZxtcAi1ztdoX1gk
	qZNLAF8vK+yYJaueTD1IlllLukY3puaF6/gNxQtr2Bcx2/lB059IsCP91TMuac8Aw6VPI8
	4Sxa4PghIZxiOQVZ9wn7sVO7Bku6SZs=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-7868b7b90b8so12003487b3.1
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 13:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762549569; x=1763154369; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2SXDWAbA53PdIOw33GR0LKCvwxTUGeSycQUW5TmKy64=;
        b=Beejb8FLLkH0dsRTNTHtDU8h7ZnpbK+JBGFGP+Cmmw1HRpCFaK2oMBhB8TxGuhdtNA
         6e45xCbT6+M+JFpMwgxe7X6Ysq+g0ZrV1M0EUlE/vdwrIVwN1L8yiG6r2eVr9Rpe+0KY
         rJ9UDdLfN04Me7XcNSb2EQtucXXr2HB8MhvSRqCaqESyzQ9dBOmBU+v6QRhF4f+mTFzh
         hEoMsTlRWIKOAxYdM3zs+H+DyAA7pf8t4STF3j6Mn6iXNooxRkpL8PXoMNYjtldFhwtr
         XgyKcq5RYQtJf1gxwpFVGV2akuV3vGg3JpvvZiqhA81nNMIIAbFm1FYPUB+oLcZqelze
         lV0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762549569; x=1763154369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2SXDWAbA53PdIOw33GR0LKCvwxTUGeSycQUW5TmKy64=;
        b=UgBT06F0n8+SWInWEkTNdrfq5v+vmDGg/l5kxPpPpHNnxxmwz2zvX4JKSKOyuZFFdT
         ekEGSZLkE6FgsSIS/bYi3UcL/MrwpLKz+Jq/XhURXvyJ/Ps0zyzIQ8wrjfMUjY7jQWyv
         FI/7mx/ArrY0RYhUSOGajsoxQh3ceKI8Pk+akrSjTzaDzO0mNmxglGoV4eVer9Lq7ynQ
         ic1XncZXTQ6JvaFD+/oOqJBmpBaHr6MBKCWXq42WafusCNnEhBmQD6xskcJxNewasZGr
         Cx8bBHaFMktJYHOIB0ho5qQfw/splGHFjSXj2Jua0m6J5Jh3clJRydUfaPOIssF1rhIL
         tHAg==
X-Forwarded-Encrypted: i=1; AJvYcCXC7aH32B8TvWAHzWgOI9NG3fDm87/7m6Bs/m/ieR90ACydP0mol9gbCXEt/NMh3hSOqhNYhN4R6Q==@kvack.org
X-Gm-Message-State: AOJu0YzAYoeghzsqTJECVHVm0P+2vpgU4ldS+XjuoXCizAUlEAl5uh+t
	FqxIVHZgSnYNWPAE5zsFzmTehBn5qPCeCfHab1KAd1As0o7Ngy9MQgo+gBRWMBcVMV0=
X-Gm-Gg: ASbGnctqEOivXZ7VjiarDUfiVeO0NXmEwgYJlYJ4EtDiygO2jJVz8T5XZhH5GmgvU5G
	Sq1L3b1XSv4Riiu8SgzU/nL9k04x4tuIHBspuDqXHB5g9onfcnRKyXspFvWpBNxq27mcVmq7aYg
	0Rd6MYaiu++xpa22h8iHChXePr5A8ge5s5AFvipBMQ4BF0D+I+SoskXHB3Ro9qZfBpQW+ch8s2q
	/7zyfRHxB7YXT2vudwawJ//Fma38YOacCNFPYp9nJdm2deDbyfgG1EsRE+fBvzZF86N3p53nqmb
	NXpq12dOwsrDRrmjTe76GmPeW0QsA3Fhfh/ArOo788zDDwo0+YDz3r1+ov7GyPel/35QWWXBQeK
	f9SJuzD2wZNy/CwpI+1/9PW965oA1P6hhA7N+rlOKlZN6nvb16zpFgUezkdVu3mUL9jfWRs0Rh6
	wWPhxDBAt3u8u3QzarF/V5LbOsqU1NJbOnLxSnHyXCLwqwaXqAdBKK7VcOUk82wJU=
X-Google-Smtp-Source: AGHT+IG8hOr8PcT4Gk3FevcQPhtl/97Z8re6SN0GLBa+Vgcg2v8tRAI+kF0AjkpM6DM+zrl2P2CK9A==
X-Received: by 2002:a05:690c:a741:b0:785:cecb:4b19 with SMTP id 00721157ae682-787d536404fmr6385657b3.5.1762549569068;
        Fri, 07 Nov 2025 13:06:09 -0800 (PST)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787d68754d3sm990817b3.26.2025.11.07.13.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 13:06:08 -0800 (PST)
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
Subject: [PATCH v5 19/22] selftests/liveupdate: Add userspace API selftests
Date: Fri,  7 Nov 2025 16:03:17 -0500
Message-ID: <20251107210526.257742-20-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251107210526.257742-1-pasha.tatashin@soleen.com>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 27E9FA0012
X-Stat-Signature: mactzsbwjz4u38jbzz9axrwm4coorh4t
X-HE-Tag: 1762549569-553949
X-HE-Meta: U2FsdGVkX18giEXMW/2NPDQ3gF0NGaUrlNWEwWLQZJ2aG8YThvy6If/l67nHh9RZt15H4mO4jeT1Dw+PCC+cayoFi0xRbTFBZlxN1DuOnz6YCiIzkvA4AdXuo6qIkdFafHB51Fywp3sKNssl1PGSvxx1VqQW5QnCmZgdAdCT9om7IPwYKrfF7xTsdwcMgA6Fmx2eh7bOLd70QyhWLLAkdqWSkeFtjRS95yB5UJ0apND0bmAW1HZvELOM5kIs6DXKycdpVBy7MYONC7mbNzXdVT/09jatT2AEHUEfI2TRYhAm/sJ5dG7TCjBRvU2t2vff6IpliE5XGO4CG1hASwKKAFVGHx2Ss8M9wKYgNTOHs7Cv1gkXmZftmLoYFxkbkpwrzwzQMipxfJxUOtCSOhmRE7t02YUt88FfTs/0SaNHQkO+ffHazC0q9ofYhzDikOH6trZsp5ovvnLVPXLifSsgOp0zjXQHy5FKCGdiCD5kxMlHK9ollNoAUUTa2vAtEaTGaZE1B/FevT2VwnRv40lm/6fdSvmf4k4wQnIRHlajj0AqJBDG/vjwK8b2qKNCrdGV9ljghzkxacs81MTeiD+i3I+jx2JS9wCNbE85VLEVUqWOhd/CubGEvU3katUKGAL2wd05Qhu92+UAQk52w+5kc9CtVXBMWwCb2fAEKOSRjM9LPMxTiTog0iynVhZmXC6sdv9jT/Ovs3+VbEd9mrhaOrNweCYPNDit49EKV+i5a3j2S8i+cXaLs180VTXmGkwIJ65EZGqp5ICf/VI6cRl0mcxzqvTYKOfzykFsHLeeEwpCvKxxO2bqkKS9Dyme8Py6VXmw4FworHqIW7yOAAyMqteop+MZvmp772Kozd1XbsALYukNHJkim0bRnLNYO8LWrqtoZkKCJyaB+R2VFBDDKz018ftnyUf3KHXW22aJjS75FJ8kplawft6q30CClQynGBZpf6G889uXSl3jG+N
 9OpUMsH0
 3SXYK69xb8detVXL6gyRJlteDnsyw+lAkw7y+D6TivdAliUOlQwJ6Mgy5g/H/6iBRNK2ZsHV/oapRk2AsnvGAmaBRgHwO/HOA852AjNy5duzjnkgK35omKKI4qH7wxR33r2vhTL6t3CZNkQscMH5/Whwg8WdwGEZtErfLXYaBnPpnU+NBnqki0qi2OzuD+KTdLBx8PgFx7XTaw/cieq4n1CUgwswXhKCMPEwuopEgJoEWQyAZvAfuupzysN6LUEh5eHpP5fUnlZfDcZ7GpCtt9v5iZ7o4OQz1LepuZUZLeD0py9V+gejvoaxyv75cOsAiPcOuB3D5ZGfLkDaxVuCYjQRYROQvUKKd/uciZ/iwtHigYWB2XKdst5ilZw+a8vuhdJu08w1ZYH0OWA33zkdm2rXWvtCgDwLduR/eTEdcQIRzDno=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a selftest suite for LUO. These tests validate the core
userspace-facing API provided by the /dev/liveupdate device and its
associated ioctls.

The suite covers fundamental device behavior, session management, and
the file preservation mechanism using memfd as a test case. This
provides regression testing for the LUO uAPI.

The following functionality is verified:

Device Access:
	Basic open and close operations on /dev/liveupdate.
	Enforcement of exclusive device access (verifying EBUSY on a
	second open).

Session Management:
	Successful creation of sessions with unique names.
	Failure to create sessions with duplicate names.

File Preservation:
	Preserving a single memfd and verifying its content remains
	intact post-preservation.
	Preserving multiple memfds within a single session, each with
	unique data.
	A complex scenario involving multiple sessions, each containing
	a mix of empty and data-filled memfds.

Note: This test suite is limited to verifying the pre-kexec
functionality of LUO (e.g., session creation, file preservation).
The post-kexec restoration of resources is not covered, as the kselftest
framework does not currently support orchestrating a reboot and
continuing execution in the new kernel.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 MAINTAINERS                                   |   1 +
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/liveupdate/.gitignore |   1 +
 tools/testing/selftests/liveupdate/Makefile   |   7 +
 tools/testing/selftests/liveupdate/config     |   5 +
 .../testing/selftests/liveupdate/liveupdate.c | 317 ++++++++++++++++++
 6 files changed, 332 insertions(+)
 create mode 100644 tools/testing/selftests/liveupdate/.gitignore
 create mode 100644 tools/testing/selftests/liveupdate/Makefile
 create mode 100644 tools/testing/selftests/liveupdate/config
 create mode 100644 tools/testing/selftests/liveupdate/liveupdate.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 3ece47c552a8..21cd3c6181c4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14525,6 +14525,7 @@ F:	include/linux/liveupdate/
 F:	include/uapi/linux/liveupdate.h
 F:	kernel/liveupdate/
 F:	mm/memfd_luo.c
+F:	tools/testing/selftests/liveupdate/
 
 LLC (802.2)
 L:	netdev@vger.kernel.org
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index c46ebdb9b8ef..56e44a98d6a5 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -54,6 +54,7 @@ TARGETS += kvm
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
index 000000000000..c0c7e7cc484e
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/config
@@ -0,0 +1,5 @@
+CONFIG_KEXEC_FILE=y
+CONFIG_KEXEC_HANDOVER=y
+CONFIG_KEXEC_HANDOVER_DEBUGFS=y
+CONFIG_KEXEC_HANDOVER_DEBUG=y
+CONFIG_LIVEUPDATE=y
diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
new file mode 100644
index 000000000000..eec26288a102
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -0,0 +1,317 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+/*
+ * Selftests for the Live Update Orchestrator.
+ * This test suite verifies the functionality and behavior of the
+ * /dev/liveupdate character device and its session management capabilities.
+ *
+ * Tests include:
+ * - Device access: basic open/close, and enforcement of exclusive access.
+ * - Session management: creation of unique sessions, and duplicate name detection.
+ * - Resource preservation: successfully preserving individual and multiple memfds,
+ *   verifying contents remain accessible.
+ * - Complex multi-session scenarios involving mixed empty and populated files.
+ */
+
+#include <errno.h>
+#include <fcntl.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <unistd.h>
+
+#include <linux/liveupdate.h>
+
+#include "../kselftest.h"
+#include "../kselftest_harness.h"
+
+#define LIVEUPDATE_DEV "/dev/liveupdate"
+
+FIXTURE(liveupdate_device) {
+	int fd1;
+	int fd2;
+};
+
+FIXTURE_SETUP(liveupdate_device)
+{
+	self->fd1 = -1;
+	self->fd2 = -1;
+}
+
+FIXTURE_TEARDOWN(liveupdate_device)
+{
+	if (self->fd1 >= 0)
+		close(self->fd1);
+	if (self->fd2 >= 0)
+		close(self->fd2);
+}
+
+/*
+ * Test Case: Basic Open and Close
+ *
+ * Verifies that the /dev/liveupdate device can be opened and subsequently
+ * closed without errors. Skips if the device does not exist.
+ */
+TEST_F(liveupdate_device, basic_open_close)
+{
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist.", LIVEUPDATE_DEV);
+
+	ASSERT_GE(self->fd1, 0);
+	ASSERT_EQ(close(self->fd1), 0);
+	self->fd1 = -1;
+}
+
+/*
+ * Test Case: Exclusive Open Enforcement
+ *
+ * Verifies that the /dev/liveupdate device can only be opened by one process
+ * at a time. It checks that a second attempt to open the device fails with
+ * the EBUSY error code.
+ */
+TEST_F(liveupdate_device, exclusive_open)
+{
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist.", LIVEUPDATE_DEV);
+
+	ASSERT_GE(self->fd1, 0);
+	self->fd2 = open(LIVEUPDATE_DEV, O_RDWR);
+	EXPECT_LT(self->fd2, 0);
+	EXPECT_EQ(errno, EBUSY);
+}
+
+/* Helper function to create a LUO session via ioctl. */
+static int create_session(int lu_fd, const char *name)
+{
+	struct liveupdate_ioctl_create_session args = {};
+
+	args.size = sizeof(args);
+	strncpy((char *)args.name, name, sizeof(args.name) - 1);
+
+	if (ioctl(lu_fd, LIVEUPDATE_IOCTL_CREATE_SESSION, &args))
+		return -errno;
+
+	return args.fd;
+}
+
+/*
+ * Test Case: Create Duplicate Session
+ *
+ * Verifies that attempting to create two sessions with the same name fails
+ * on the second attempt with EEXIST.
+ */
+TEST_F(liveupdate_device, create_duplicate_session)
+{
+	int session_fd1, session_fd2;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd1 = create_session(self->fd1, "duplicate-session-test");
+	ASSERT_GE(session_fd1, 0);
+
+	session_fd2 = create_session(self->fd1, "duplicate-session-test");
+	EXPECT_LT(session_fd2, 0);
+	EXPECT_EQ(-session_fd2, EEXIST);
+
+	ASSERT_EQ(close(session_fd1), 0);
+}
+
+/*
+ * Test Case: Create Distinct Sessions
+ *
+ * Verifies that creating two sessions with different names succeeds.
+ */
+TEST_F(liveupdate_device, create_distinct_sessions)
+{
+	int session_fd1, session_fd2;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd1 = create_session(self->fd1, "distinct-session-1");
+	ASSERT_GE(session_fd1, 0);
+
+	session_fd2 = create_session(self->fd1, "distinct-session-2");
+	ASSERT_GE(session_fd2, 0);
+
+	ASSERT_EQ(close(session_fd1), 0);
+	ASSERT_EQ(close(session_fd2), 0);
+}
+
+static int preserve_fd(int session_fd, int fd_to_preserve, __u64 token)
+{
+	struct liveupdate_session_preserve_fd args = {};
+
+	args.size = sizeof(args);
+	args.fd = fd_to_preserve;
+	args.token = token;
+
+	if (ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &args))
+		return -errno;
+
+	return 0;
+}
+
+/*
+ * Test Case: Preserve MemFD
+ *
+ * Verifies that a valid memfd can be successfully preserved in a session and
+ * that its contents remain intact after the preservation call.
+ */
+TEST_F(liveupdate_device, preserve_memfd)
+{
+	const char *test_str = "hello liveupdate";
+	char read_buf[64] = {};
+	int session_fd, mem_fd;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd = create_session(self->fd1, "preserve-memfd-test");
+	ASSERT_GE(session_fd, 0);
+
+	mem_fd = memfd_create("test-memfd", 0);
+	ASSERT_GE(mem_fd, 0);
+
+	ASSERT_EQ(write(mem_fd, test_str, strlen(test_str)), strlen(test_str));
+	ASSERT_EQ(preserve_fd(session_fd, mem_fd, 0x1234), 0);
+	ASSERT_EQ(close(session_fd), 0);
+
+	ASSERT_EQ(lseek(mem_fd, 0, SEEK_SET), 0);
+	ASSERT_EQ(read(mem_fd, read_buf, sizeof(read_buf)), strlen(test_str));
+	ASSERT_STREQ(read_buf, test_str);
+	ASSERT_EQ(close(mem_fd), 0);
+}
+
+/*
+ * Test Case: Preserve Multiple MemFDs
+ *
+ * Verifies that multiple memfds can be preserved in a single session,
+ * each with a unique token, and that their contents remain distinct and
+ * correct after preservation.
+ */
+TEST_F(liveupdate_device, preserve_multiple_memfds)
+{
+	const char *test_str1 = "data for memfd one";
+	const char *test_str2 = "data for memfd two";
+	char read_buf[64] = {};
+	int session_fd, mem_fd1, mem_fd2;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd = create_session(self->fd1, "preserve-multi-memfd-test");
+	ASSERT_GE(session_fd, 0);
+
+	mem_fd1 = memfd_create("test-memfd-1", 0);
+	ASSERT_GE(mem_fd1, 0);
+	mem_fd2 = memfd_create("test-memfd-2", 0);
+	ASSERT_GE(mem_fd2, 0);
+
+	ASSERT_EQ(write(mem_fd1, test_str1, strlen(test_str1)), strlen(test_str1));
+	ASSERT_EQ(write(mem_fd2, test_str2, strlen(test_str2)), strlen(test_str2));
+
+	ASSERT_EQ(preserve_fd(session_fd, mem_fd1, 0xAAAA), 0);
+	ASSERT_EQ(preserve_fd(session_fd, mem_fd2, 0xBBBB), 0);
+
+	memset(read_buf, 0, sizeof(read_buf));
+	ASSERT_EQ(lseek(mem_fd1, 0, SEEK_SET), 0);
+	ASSERT_EQ(read(mem_fd1, read_buf, sizeof(read_buf)), strlen(test_str1));
+	ASSERT_STREQ(read_buf, test_str1);
+
+	memset(read_buf, 0, sizeof(read_buf));
+	ASSERT_EQ(lseek(mem_fd2, 0, SEEK_SET), 0);
+	ASSERT_EQ(read(mem_fd2, read_buf, sizeof(read_buf)), strlen(test_str2));
+	ASSERT_STREQ(read_buf, test_str2);
+
+	ASSERT_EQ(close(mem_fd1), 0);
+	ASSERT_EQ(close(mem_fd2), 0);
+	ASSERT_EQ(close(session_fd), 0);
+}
+
+/*
+ * Test Case: Preserve Complex Scenario
+ *
+ * Verifies a more complex scenario with multiple sessions and a mix of empty
+ * and non-empty memfds distributed across them.
+ */
+TEST_F(liveupdate_device, preserve_complex_scenario)
+{
+	const char *data1 = "data for session 1";
+	const char *data2 = "data for session 2";
+	char read_buf[64] = {};
+	int session_fd1, session_fd2;
+	int mem_fd_data1, mem_fd_empty1, mem_fd_data2, mem_fd_empty2;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd1 = create_session(self->fd1, "complex-session-1");
+	ASSERT_GE(session_fd1, 0);
+	session_fd2 = create_session(self->fd1, "complex-session-2");
+	ASSERT_GE(session_fd2, 0);
+
+	mem_fd_data1 = memfd_create("data1", 0);
+	ASSERT_GE(mem_fd_data1, 0);
+	ASSERT_EQ(write(mem_fd_data1, data1, strlen(data1)), strlen(data1));
+
+	mem_fd_empty1 = memfd_create("empty1", 0);
+	ASSERT_GE(mem_fd_empty1, 0);
+
+	mem_fd_data2 = memfd_create("data2", 0);
+	ASSERT_GE(mem_fd_data2, 0);
+	ASSERT_EQ(write(mem_fd_data2, data2, strlen(data2)), strlen(data2));
+
+	mem_fd_empty2 = memfd_create("empty2", 0);
+	ASSERT_GE(mem_fd_empty2, 0);
+
+	ASSERT_EQ(preserve_fd(session_fd1, mem_fd_data1, 0x1111), 0);
+	ASSERT_EQ(preserve_fd(session_fd1, mem_fd_empty1, 0x2222), 0);
+	ASSERT_EQ(preserve_fd(session_fd2, mem_fd_data2, 0x3333), 0);
+	ASSERT_EQ(preserve_fd(session_fd2, mem_fd_empty2, 0x4444), 0);
+
+	ASSERT_EQ(lseek(mem_fd_data1, 0, SEEK_SET), 0);
+	ASSERT_EQ(read(mem_fd_data1, read_buf, sizeof(read_buf)), strlen(data1));
+	ASSERT_STREQ(read_buf, data1);
+
+	memset(read_buf, 0, sizeof(read_buf));
+	ASSERT_EQ(lseek(mem_fd_data2, 0, SEEK_SET), 0);
+	ASSERT_EQ(read(mem_fd_data2, read_buf, sizeof(read_buf)), strlen(data2));
+	ASSERT_STREQ(read_buf, data2);
+
+	ASSERT_EQ(lseek(mem_fd_empty1, 0, SEEK_SET), 0);
+	ASSERT_EQ(read(mem_fd_empty1, read_buf, sizeof(read_buf)), 0);
+
+	ASSERT_EQ(lseek(mem_fd_empty2, 0, SEEK_SET), 0);
+	ASSERT_EQ(read(mem_fd_empty2, read_buf, sizeof(read_buf)), 0);
+
+	ASSERT_EQ(close(mem_fd_data1), 0);
+	ASSERT_EQ(close(mem_fd_empty1), 0);
+	ASSERT_EQ(close(mem_fd_data2), 0);
+	ASSERT_EQ(close(mem_fd_empty2), 0);
+	ASSERT_EQ(close(session_fd1), 0);
+	ASSERT_EQ(close(session_fd2), 0);
+}
+
+TEST_HARNESS_MAIN
-- 
2.51.2.1041.gc1ab5b90ca-goog


