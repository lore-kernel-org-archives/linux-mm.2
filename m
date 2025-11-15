Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BDB4CEB2D2
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 23:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1BCD8E0025; Sat, 15 Nov 2025 18:34:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCC628E0007; Sat, 15 Nov 2025 18:34:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A467C8E0025; Sat, 15 Nov 2025 18:34:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 869C48E0007
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 18:34:58 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 57E471A0868
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:58 +0000 (UTC)
X-FDA: 84114449076.19.21F6296
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id A96AF12000D
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KksZs3yx;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763249696; a=rsa-sha256;
	cv=none;
	b=pDYnSRYWQbDnCi/dfX6lkcOuBmWXWKqEOkk6m8ygGtcwWv61Xw/cSBuK0kKbnHuzcq2AMU
	1N0AmZs6X3sCnLlgRwd2zVDZ4MjUncvSmJmJk0bfQh7PVMdz0rgYpbmfszZ7ISLZzzXsmD
	lHl/bMcxY8L9JJKM+NK2EZRC5scIfLM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KksZs3yx;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763249696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f5S0vcOaGPBc/xPnnYkmK3BuBrLvlvg5l9MZinPrpq0=;
	b=aTGF8Li+kbXziqd09K1rfnf4IXJB617AIvY5faYPTsKrAN9aYB1RHMeUgcudfpB0mkPGeI
	ITohkvdwg8qmMvlEYRbyUF34Tj6RbXBIjXGpHBT9w+8iFWcEVYFkE2pmM58cC2/wiHyGr4
	bwvbfbniy6AS7i+mVmSyfAFdj1FFVBM=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-640d4f2f13dso3001793d50.1
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 15:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763249696; x=1763854496; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f5S0vcOaGPBc/xPnnYkmK3BuBrLvlvg5l9MZinPrpq0=;
        b=KksZs3yxhAEGxWcEerP1z1Picabweayf4u9LaQD0WlFn6kgNGwWV8rDSXNwizllwW6
         S15uVuHbCMIUiuEjcno6A8TKG/A/eJzCXt5dlAGw+JsUKOfFuqdpVAs5f1FW6W3q0wQn
         4mRVm3yrB4CKhUjuOcFV4TXUHjQAQaV6NeRaMrGkE+LCq3b1v0v+KzKtSQfozg+mKESd
         s7Qlon5pr6YvNCs6FE1ohs/Im+D/xDtWL78LyE3zA6lqzIcIriHIW/Nft7MDuuemr4OJ
         S8b5+ZqEspX9uOWdr7aKAyPui6vWnmgdWB8BGhUjHPtxY5W+8CJEEnn9rrmLrlE5CwrW
         18gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763249696; x=1763854496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=f5S0vcOaGPBc/xPnnYkmK3BuBrLvlvg5l9MZinPrpq0=;
        b=KyGHP2pG5gTD89c4qAYPfiHX7sOKoG05dtV+Jqcjy8mpupYlC5ejuUqxrEbKSNyFiD
         9VpqLqxG51VOibWBrkhs8AmwTVG8XHZvdFDbFl0O5/19oYyoeXYQS2q5+ev+fxeblWAu
         wAWGmDn9I+RlAqnra+K1CwC3Hq6H/cff0FmACW2Y952ipp88Nw0aPUXk743AHzDe+mDb
         fkNlgcXY6zrkMljR5eBv7L4tPTHJQSSwt9XfbE47zZP6M3g/DKyUj4ozIuw5pWZxnxBI
         rVl0PZkSQ/73gpmdb1sHh77JxPX5JHhPCFf8eOwfhDCZkDIpr5+RQhEAbbYKK6xEFyhd
         xdFw==
X-Forwarded-Encrypted: i=1; AJvYcCXq/iQ7/VT+xaEAuG5P5r4U/M25vExTnjKrlw41DCevfucAYePhyCyMVvugK1zEYR3VmkZmAIa41w==@kvack.org
X-Gm-Message-State: AOJu0YwUORytkNyqy1H8zMO3WMnLsZrR9eeKmRZIviclhlDV0KIsOO95
	hkByQmNuYPLLdX3VlZlVj5CUD81StBEcK8IkkCNRfNE8eIX3UHFMENA5FTSiB+R0j04=
X-Gm-Gg: ASbGncvVVfK8c7y3FsMs9aa7ZLHWLTzdC+x0KHvJWX/Ao1L9MOXfdAzbSR4a9Ey6XID
	oz7Qey+Reb1Ve2WO4Qbgd36cawPEo1aSVM/iTEOEHrMqlveaUkq/Ja4VMoEysChWZzsAE575qen
	kpKY8ssMcR1k1nwbRRHlb9Os3yMNV/Anw5AxJsTO3EsztbH2YpcC+pb5j7tvH8rix/n2D6Exm8I
	ZpyVAEjVdPw4/55AqXJmzxrFba78cZ7SaV9InFIlsTVoYXVpJp+ryMWv2RGN7HselTlwvkwVOC5
	PfCgqktfvM4GXTDJ6816OubdRPn+1RPoZKXchvfYKx2Q6uHHuz1ceens2vvpHnb5rw/4A00s6LM
	KYB1Txp5Y6Ex0uleYG06Rh/S6i6/w8COSpUPJvcfGdULoJwB10tNOJuy0zC5Cf9agV4gVD5Kxb5
	a/+RIDoOU2bN92HRh/Lxak+hvciIi4aQa2wtIkgheAfVOzagUMGKbNkv4gHSH4x9zCXEz6xdOzi
	pTL+6g=
X-Google-Smtp-Source: AGHT+IGi+GT9ZHanKi9MAwv46wj31I6UW4wvg+DCMOJo43hhLaMJSMVLxpTF87yQuYFejJEJXTbohQ==
X-Received: by 2002:a53:b10e:0:b0:63f:a228:1859 with SMTP id 956f58d0204a3-641e75ef062mr5298448d50.38.1763249695703;
        Sat, 15 Nov 2025 15:34:55 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7882218774esm28462007b3.57.2025.11.15.15.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 15:34:55 -0800 (PST)
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
Subject: [PATCH v6 17/20] selftests/liveupdate: Add userspace API selftests
Date: Sat, 15 Nov 2025 18:34:03 -0500
Message-ID: <20251115233409.768044-18-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251115233409.768044-1-pasha.tatashin@soleen.com>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A96AF12000D
X-Stat-Signature: rq8ifu7e9wchg9zupjpxog4erk54jnjb
X-Rspam-User: 
X-HE-Tag: 1763249696-634755
X-HE-Meta: U2FsdGVkX18WtvQ4jgl2bh4QlHvVKg0AR25KURm090lKWWwAqHEMz2a29QwyzuEgDrMuC8HrLrieOsy2OTwbc7eWtOfemSh3JdXUITuDBwozVwkixq9nj9C9RuhD3s63dcXMRrD9yedaVhjfN6GU86Y0gcm7P1v/XV4FTWH+nwNiCsI+kyrw+oPPfD2DKVhrDGO1PKnHH4T7EiFkfsA/JYpb5/U2B10Y7czMoJTZqckq/mG4Z90TCw909awYEMTE+V+FMVp9pXH9NubWXiAkTQ7cu+PD4hS1sx/+uGpsAgryBNgSQCReJ5oRB49NS/yj2tv30ghabXgYHZneT4BCWvPUkT8oBvr/CwMq1KH24Xax7KxXSn5FE4MdbIg4Bs1L2TBKlQwFP2uiQY9teYPHVU5x809cAyllmfjGSjYkA1DEGQiAHyZKRI7xq7LlZX0MU4kDj+ZgqmdvQLkq7l6MUOLxLpuuebZwBH/SorZDo40zm2YXZyimjJxY1OEE0W/rWperVAq/3XLmJNxcHeq62aVDEcJW3zW8F8+3bcvXH1qi8RHmJjC4nFBEJRXawvmHcltoQiWzMlOzwrjx3Eswd8+430mAAHPksv3gzz3ML2dlljkSmB5+QAO/a90jxF8ciZth5HkDRwFdDRNlKiHQK26EgvATDb7/QOEAQVr3cz+FXEDmSJZM0i3s/Jh8MFJlNmC4AiAMgWEeWNqv802s+z7pcViJgr+7Xz6ufEL3E1ERgZO3y6B7rdPM9CumuuUS30gG5dDbxqCsz6TLcKJSo5VsHjwk51BwLwpzcWRMStSQbeb9mpF0e9NeHhTRtnBhHgw8ULU2TDFM2j8sTIAwyr/gp0i8HUJ1uV62OqTIId9dofiYHNHGNiTJHyBQb69Ok1uWZ6U3rWyTBAv42ahJPJ19pGkxc4qi2FjdGkip1vyuE4MGJxl5Oa9GU3+AZzSPGfpiHztdqOvH2p26OKj
 nbOKrR2z
 e9pLTbL0Ox7No0dQhBqe7MYy0F/Tzfsg9paQMJJa0xq1SjxJ7Tn+U16PnxaNjZiwaFZIatiKU38DPx56t/Y1DMU2SCcP5Q9+OhfVS
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
 .../testing/selftests/liveupdate/liveupdate.c | 348 ++++++++++++++++++
 6 files changed, 363 insertions(+)
 create mode 100644 tools/testing/selftests/liveupdate/.gitignore
 create mode 100644 tools/testing/selftests/liveupdate/Makefile
 create mode 100644 tools/testing/selftests/liveupdate/config
 create mode 100644 tools/testing/selftests/liveupdate/liveupdate.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 6ffe4425adbf..5a1ed783de20 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14477,6 +14477,7 @@ F:	include/linux/liveupdate/
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
index 000000000000..c2878e3d5ef9
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -0,0 +1,348 @@
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
+/*
+ * Test Case: Preserve Unsupported File Descriptor
+ *
+ * Verifies that attempting to preserve a file descriptor that does not have
+ * a registered Live Update handler fails gracefully.
+ * Uses /dev/null as a representative of a file type (character device)
+ * that is not supported by the orchestrator.
+ */
+TEST_F(liveupdate_device, preserve_unsupported_fd)
+{
+	int session_fd, unsupported_fd;
+	int ret;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd = create_session(self->fd1, "unsupported-fd-test");
+	ASSERT_GE(session_fd, 0);
+
+	unsupported_fd = open("/dev/null", O_RDWR);
+	ASSERT_GE(unsupported_fd, 0);
+
+	ret = preserve_fd(session_fd, unsupported_fd, 0xDEAD);
+	EXPECT_EQ(ret, -ENOENT);
+
+	ASSERT_EQ(close(unsupported_fd), 0);
+	ASSERT_EQ(close(session_fd), 0);
+}
+
+TEST_HARNESS_MAIN
-- 
2.52.0.rc1.455.g30608eb744-goog


