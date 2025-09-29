Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 527A2CAC5BC
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:04:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3F4F8E001A; Sun, 28 Sep 2025 21:04:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B52E08E0006; Sun, 28 Sep 2025 21:04:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 956F58E001A; Sun, 28 Sep 2025 21:04:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D00D8E0006
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:04:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A326C020F
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:42 +0000 (UTC)
X-FDA: 83940492804.26.7392C35
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4D91B1C0007
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jsZIo2by;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hWJ63KeQmpqYfuZrXZOnIQWXyJkptFNNQr+9KCQ8c70=;
	b=Hb/2PbysAKMGsbNSlu8oFY4A4tXepmZkdFthhzbSDwQpjVtwT9a+QYsjADNHrBgfkVxHF0
	hfp3Vvw5qK5pYby2/mfYx0A5oKU3y6CYfbr2dmJltO+wZ5HalJbkkwcwFt1QTUGfxZFv4U
	PS4r67DZhh/cLQyOdvXeDKasYVvKv4I=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jsZIo2by;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107880; a=rsa-sha256;
	cv=none;
	b=j9BnjyztLeFqErfChonihv29S0QRs0wAboatpkX7k4BSZjDAmb2cEpYT8kj+IFj/75gf2F
	N8mhcOrbcPFy3cpiCyxJgUVqXU/Bb1oFn+4t4VXIxoWm38C/ffJfVsbp2sEmWIFjFy94xQ
	eFW5RTKXZ3HhMj7ALhIz4boMjsBaxLE=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4b109c6b9fcso39358901cf.3
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 18:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759107879; x=1759712679; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hWJ63KeQmpqYfuZrXZOnIQWXyJkptFNNQr+9KCQ8c70=;
        b=jsZIo2byvSW5kd2XgIA4LtH39mnjQF1xFAfez3pI+q3jkPQ8dMQRKwhL+ASqCPJkj1
         QrFKfV4Z8oMRrmIFBfsdUF+m9oCD387JtvobjhP0KtTfq5QSkkMfBY/pHLT5HugPO6pt
         4WDS2B9ZSIHYyOBvzOkaf4eGi0UYdLoDulu/QG0RzPEVI7kP+TQiuCG/jHznN0sQGmf4
         DH8WRLhxrX/KjKTJtZysPzhPfnefi4SUoVUlEwJEIFkn1l7zfDCxWA0H8dNfGpyoH7AW
         uy8LxMpe6TwO4h1Pqef1o6TWi66jR3j7qHbzH5n8+SwR2hcZkLik5NO/01I3FqWecgoQ
         9Q0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107879; x=1759712679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hWJ63KeQmpqYfuZrXZOnIQWXyJkptFNNQr+9KCQ8c70=;
        b=HG2qB71iAq0vS2j1dKGn0w2sigz+h/ISXdPw+5R/ckcgF2typzFq0HABDYGuh0hLvO
         ThO8DeyHXzFjWJeRhsNjaMp2rCKwXqkQjBvT9OBxMYYjp0wCJjzmoiQWjT493PuH7lpL
         R4yRCrGobdtkmvhItAW8g75qtuFP7gv1C6QHpVgdfgmnXhbJWKgl1GCLq09ng4290qc3
         a2JbsjWFWVl5SPnjGWjT+6PUjVr/b6T7Lapacjp1iZGLoGVXPEnJ40Z4Ui49mj3OFpb6
         0MxBXIkThYBQgK21is3Hkec9SwnY4JDb3CtuEiz4uiebqfAM3Wexl4HE0jFLXyAhBKpz
         ZztA==
X-Forwarded-Encrypted: i=1; AJvYcCUhwBJ/6QsnQ7Re5Sc1yv7S0sFA2GLCRSCzNr7iuO9qmZhuzg30X/rgVaZErn0agN2X9boJnvK7Hw==@kvack.org
X-Gm-Message-State: AOJu0Yw/1cuT/WrTv4yKT91YTl9qT7uGZyyxTebkyFxxRPopmg4GoofU
	tiEbti2EAhTiOU3B9uRVsBeCDA+6EhbxP+OJ/QGZvXSba649xnMmGrD93aR3tEZbu7M=
X-Gm-Gg: ASbGncupbSPT157ofGAaF8NcE+4zO6bjsgBVEMeQ2u2cCuHVuWSlJ2fXKoMWCOFbL4W
	2Rd/u/fi6d7Zf4cclYmsaGy6ch753Hle837e94sJGzisJ6ZSJk4toG0lf7lgAyuZ1hlzdp1L9Gc
	PbeteJC7eIN8kYQilUezco98H573E9fFZ2sRyddQwBDYaK/10n18nNSPzMrFxuDDkYdPJKKc0SG
	yUxeoM46UGXdhAgx6WGNzAhTYz6MA4Hhf9/OavvfNhVnE7cPX4eqB4Vb+C3cE7vb7+GCpLoAnpR
	7Oox1/IIbA3v/memgAyWI+8qqkke4cFqiF5DSsOg8ModGXw6Gd5l6AUpIW4XdIgR3rnBTxUqCpb
	8i5MW7prsPMAqy/Fz7VBKeL51yAxe0YnRDQ04f3o0+2zUrj0eqkpHi5Cjan70ejU0lbWYNJStKs
	TmIPknlz0=
X-Google-Smtp-Source: AGHT+IGQ9JesfWQ9VOblraXsGcOaxMqov/TZFk+utQcihiAURpdIQFxS9/FIvzoyuC4KA4xQDrrIxg==
X-Received: by 2002:a05:622a:5c8:b0:4e0:b5ef:2ba3 with SMTP id d75a77b69052e-4e0b5ef2f60mr33124721cf.37.1759107879208;
        Sun, 28 Sep 2025 18:04:39 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0c0fbe63sm64561521cf.23.2025.09.28.18.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 18:04:38 -0700 (PDT)
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
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org,
	steven.sistare@oracle.com
Subject: [PATCH v4 18/30] selftests/liveupdate: add subsystem/state tests
Date: Mon, 29 Sep 2025 01:03:09 +0000
Message-ID: <20250929010321.3462457-19-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4D91B1C0007
X-Rspamd-Server: rspam05
X-Stat-Signature: apwmj1j663cojqi8hb43kriwkieym9yj
X-Rspam-User: 
X-HE-Tag: 1759107880-201832
X-HE-Meta: U2FsdGVkX1/Qs4svdz3HemAKgZKiSSrQfcgo31cIN9I5p2qdL/L7gZ3HsuB4cZ0gkg+4YfJRNo0ZgnggHTcDu5amBwIwzKtsecSEGAuUzMl/C7vyWB9v4dFYoLEyMLF5pXNBwXrEwLT3SzXSTYRlIak0ReHRYw+6eNnr/QZW3PxTPCDdjDIJmSKiTUmsph9wimtRRAvCCCofMhzObIR7vIHqXYwPAy2dUQr4fZbjKemMtCbRugJa/z+7k9gMaIoT7tv0tZ1xLufRJ7xiqCzM3u/20MKpiLP/W5TMLT52pqAIgzBRSTG8rrujf6cWkSZTEtodjEAQhdbd08Rx+M0JNxi/YZGZLrrAfGh/voePPVgmnhEHHV4Fhzd/FU1lutdsB+kIEVzaQTr8LxUROeR+UYrPIJ1PV28ez0PNv5tc8+Kqwle/aAIBvT/RaZJV8kUnFhr1x9KAQzfxFRrXE2nr2IwymIQZqUsFI3wL/Rnm+8v10R9IJQ+8KJET6z8OsvfkktmBlD8wHrUi2PmYMSI0G8pziiN/U0mhAJN6PMn7ehwJzI6HeB6wdbkdr+46as+vt1+stH4CKoXoBDH2Z3J+nM9zfqSVCW8cJhrJ9SccJfHUSQYbgue8hm0gAFYSguu7HBTIb9TIOp6u6EglghqZ+6c7xxH7Go6N7lSIkIuAlcrvZrG1WKxSmpO2Dy/ORPa53xPD+xVOhDXA2vXtCSHI4lp7ij/l8KvL1QqWcLk0/PtRcnbO8oGNEsJ1Y3sUnToIFBlgUyJ3bXA8a0tkEJkstIfJoI/LH3mPHm28ZudHFHN2ZBhRVGxwvOAyJzT1LJRuKmgWPvH3LLTXsc6xQt5zAB9x/0pnuPP14bR5NhJ24Aqz31ykNr8XM2keG6Zk/gJrjXgbaJswlnJmexHcWWUCp3Cf5bMmsws61OtZPvbON9synqsZT4+lYJFXAEGsl3Gb+t//9RbD92StvDgEn0B
 TsJFvxc1
 prxeXuAUm7boEdfv7rGAa45QKeBXtK19wkKRRmKG15+Dkcqu5I1uNUzoA3Gb0qhMB0KOE3ypXwuS3/tNZwAstyFNLiDSBVEJMBPzt2q0XXx+mxoN7UW1tx1cIbZ7zMjiObc2mRbPoGHtsHLGp6uUy+J6YbFcv36T0vyFXkbaF0ZVLl+JmR5Q99AxwKssGUl+N65z8JPzk7c6DvidKVSHD3K2fxsWp7AXqehFX6jytg4+Jw7NuN5jp7z0pZePPxaAnch29fFky0XiuTlQ7MvE3x5lcypvzzcvPx2H618a7hpJrih9Tbz7WjeMcoqMWSw1z+UFddl34cI18ArtywIjjp7Qh/bAm1Mt5td6QRY08dmlOGsDOHvGeZTop5tgeNoUb5oxZlyxQrNOG6NQVQXGQ8H8Frg==
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
 .../testing/selftests/liveupdate/liveupdate.c | 348 ++++++++++++++++++
 5 files changed, 363 insertions(+)
 create mode 100644 tools/testing/selftests/liveupdate/.gitignore
 create mode 100644 tools/testing/selftests/liveupdate/Makefile
 create mode 100644 tools/testing/selftests/liveupdate/config
 create mode 100644 tools/testing/selftests/liveupdate/liveupdate.c

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
index 000000000000..7c0ceaac0283
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -0,0 +1,348 @@
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
+FIXTURE_SETUP(state)
+{
+	page_size = sysconf(_SC_PAGE_SIZE);
+	self->fd = open(LUO_DEVICE, O_RDWR);
+	if (self->fd < 0)
+		SKIP(return, "open(%s) failed [%d]", LUO_DEVICE, errno);
+
+	self->fd_dbg = open(LUO_DBG_DEVICE, O_RDWR);
+	ASSERT_GE(self->fd_dbg, 0);
+}
+
+FIXTURE_TEARDOWN(state)
+{
+	struct liveupdate_ioctl_set_event cancel = {
+		.size = sizeof(cancel),
+		.event = LIVEUPDATE_CANCEL,
+	};
+	struct liveupdate_ioctl_get_state ligs = {.size = sizeof(ligs)};
+
+	ioctl(self->fd, LIVEUPDATE_IOCTL_GET_STATE, &ligs);
+	if (ligs.state != LIVEUPDATE_STATE_NORMAL)
+		ioctl(self->fd, LIVEUPDATE_IOCTL_SET_EVENT, &cancel);
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
+	struct liveupdate_ioctl_set_event cancel = {
+		.size = sizeof(cancel),
+		.event = LIVEUPDATE_CANCEL,
+	};
+	enum liveupdate_state state = LIVEUPDATE_STATE_NORMAL;
+	int i;
+
+	ioctl(self->fd, LIVEUPDATE_IOCTL_GET_STATE, &state);
+	if (state != LIVEUPDATE_STATE_NORMAL)
+		ioctl(self->fd, LIVEUPDATE_IOCTL_SET_EVENT, &cancel);
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
+	struct liveupdate_ioctl_get_state ligs = {.size = sizeof(ligs)};
+
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_GET_STATE, &ligs));
+	ASSERT_EQ(ligs.state, LIVEUPDATE_STATE_NORMAL);
+}
+
+TEST_F(state, prepared)
+{
+	struct liveupdate_ioctl_get_state ligs = {.size = sizeof(ligs)};
+	struct liveupdate_ioctl_set_event prepare = {
+		.size = sizeof(prepare),
+		.event = LIVEUPDATE_PREPARE,
+	};
+	struct liveupdate_ioctl_set_event cancel = {
+		.size = sizeof(cancel),
+		.event = LIVEUPDATE_CANCEL,
+	};
+
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_SET_EVENT, &prepare));
+
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_GET_STATE, &ligs));
+	ASSERT_EQ(ligs.state, LIVEUPDATE_STATE_PREPARED);
+
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_SET_EVENT, &cancel));
+
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_GET_STATE, &ligs));
+	ASSERT_EQ(ligs.state, LIVEUPDATE_STATE_NORMAL);
+}
+
+TEST_F(state, sysfs_prepared)
+{
+	struct liveupdate_ioctl_set_event prepare = {
+		.size = sizeof(prepare),
+		.event = LIVEUPDATE_PREPARE,
+	};
+	struct liveupdate_ioctl_set_event cancel = {
+		.size = sizeof(cancel),
+		.event = LIVEUPDATE_CANCEL,
+	};
+
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_SET_EVENT, &prepare));
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_SET_EVENT, &cancel));
+}
+
+TEST_F(state, sysfs_frozen)
+{
+	struct liveupdate_ioctl_set_event prepare = {
+		.size = sizeof(prepare),
+		.event = LIVEUPDATE_PREPARE,
+	};
+	struct liveupdate_ioctl_set_event cancel = {
+		.size = sizeof(cancel),
+		.event = LIVEUPDATE_CANCEL,
+	};
+
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_SET_EVENT, &prepare));
+	ASSERT_EQ(0, ioctl(self->fd_dbg, LIVEUPDATE_IOCTL_FREEZE, NULL));
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_SET_EVENT, &cancel));
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
+	struct liveupdate_ioctl_get_state ligs = {.size = sizeof(ligs), .state = 0};
+	struct liveupdate_ioctl_set_event prepare = {
+		.size = sizeof(prepare),
+		.event = LIVEUPDATE_PREPARE,
+	};
+	struct liveupdate_ioctl_set_event cancel = {
+		.size = sizeof(cancel),
+		.event = LIVEUPDATE_CANCEL,
+	};
+	int i;
+
+	for (i = 0; i < LUO_MAX_SUBSYSTEMS; i++)
+		ASSERT_EQ(0, register_subsystem(self->fd_dbg, &self->si[i]));
+
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_SET_EVENT, &prepare));
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_GET_STATE, &ligs));
+	ASSERT_EQ(ligs.state, LIVEUPDATE_STATE_PREPARED);
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
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_SET_EVENT, &cancel));
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_GET_STATE, &ligs));
+	ASSERT_EQ(ligs.state, LIVEUPDATE_STATE_NORMAL);
+
+	for (i = 0; i < LUO_MAX_SUBSYSTEMS; i++)
+		ASSERT_EQ(0, unregister_subsystem(self->fd_dbg, &self->si[i]));
+}
+
+TEST_F(subsystem, prepare_fail)
+{
+	struct liveupdate_ioctl_set_event prepare = {
+		.size = sizeof(prepare),
+		.event = LIVEUPDATE_PREPARE,
+	};
+	struct liveupdate_ioctl_set_event cancel = {
+		.size = sizeof(cancel),
+		.event = LIVEUPDATE_CANCEL,
+	};
+	int i;
+
+	snprintf(self->si[LUO_MAX_SUBSYSTEMS - 1].test_name, LUO_NAME_LENGTH,
+		 NAME_PREPARE_FAIL ".%d", LUO_MAX_SUBSYSTEMS - 1);
+
+	for (i = 0; i < LUO_MAX_SUBSYSTEMS; i++)
+		ASSERT_EQ(0, register_subsystem(self->fd_dbg, &self->si[i]));
+
+	ASSERT_EQ(-1, ioctl(self->fd, LIVEUPDATE_IOCTL_SET_EVENT, &prepare));
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
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_SET_EVENT, &prepare));
+	ASSERT_EQ(0, ioctl(self->fd_dbg, LIVEUPDATE_IOCTL_FREEZE, NULL));
+	ASSERT_EQ(0, ioctl(self->fd, LIVEUPDATE_IOCTL_SET_EVENT, &cancel));
+
+	for (i = 0; i < LUO_MAX_SUBSYSTEMS; i++)
+		ASSERT_EQ(0, unregister_subsystem(self->fd_dbg, &self->si[i]));
+}
+
+TEST_HARNESS_MAIN
-- 
2.51.0.536.g15c5d4f767-goog


