Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2A3EE88D97
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 10:25:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42B8A6B0089; Sat,  4 Apr 2026 06:25:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DB646B008A; Sat,  4 Apr 2026 06:25:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CC616B008C; Sat,  4 Apr 2026 06:25:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1D18D6B0089
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 06:25:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CC1221407B5
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 10:25:07 +0000 (UTC)
X-FDA: 84620490654.29.8371B77
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 46AC7180007
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 10:25:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j1xr4ow1;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775298306; a=rsa-sha256;
	cv=none;
	b=Yy7inJ7qVgXLBwLKUwHjIczpMwqSJf2KKncinBLifdk93wfMC+LfnxYZ7sc2PH9i0a6agK
	bHIBUor/GsPrFsK1Qgxbt3DgS3TyIYJk1qw6c+xUT99QVltK9qxBifSbszZU7R+8pDMkOQ
	pYmHKqV516AHj+H5kRbW/fI8ExGJhds=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775298306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gGvZiap95bL0UbUpGV9hhZsAAM5MZG1zd+tczOvTmkI=;
	b=JQ5zdRyxekWxcZd9J+CahggIxVXvzzA+HZ2WeJQKPIcKE/C7efkjqZSMph+jpbBoYhhKFX
	jFGq2wQLXn+5AFGhdpHr3QBAQC9qlWV6tfnxbw0DyFgPk96kQ9PXL6EQrUhMp/xKGNVGDg
	MX6lUJ8VZUUSZ/qiVTcMx9ZXqbqQEGA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j1xr4ow1;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3969443834;
	Sat,  4 Apr 2026 10:25:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B93C19425;
	Sat,  4 Apr 2026 10:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775298305;
	bh=/EUjIrH0nCwQKenCVjkx2cRPuoQiXcxmaLv25odT908=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j1xr4ow13eYqPzo66Vy7ar9HIiMtgRGMDsnKwNvIASkjsql8yqCEakVNO1Pv2rBhe
	 aL183bC/PXsEwZZFmWvwz/XivGToT7uyDgmXzJPsrn3sqaxTrpEBqQSHT/zLZdDMoo
	 AuKQwlKDV1wQBYhYDT/hDJPFjV+2Z5C2JqO7P1RF2gywkf+6Zu66QgSrha64T5/3u4
	 vq1zFsskLW5KQtI5VIgRfidZRWs5DENxK5TsIvH+zwuI9MBksbIT18PQbSygstt5aT
	 2xPO0Lr1s/uOqZ/9UEPJuS9mJotn9KpZ4l8KFjJYKmJRSOqjBGqaJSr3lXDYDOrn+3
	 RkgyjKWYlkchw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usama.arif@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 1/6] selftests/liveupdate: add framework for memfd tests
Date: Sat,  4 Apr 2026 10:24:44 +0000
Message-ID: <20260404102452.4091740-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
In-Reply-To: <20260404102452.4091740-1-pratyush@kernel.org>
References: <20260404102452.4091740-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 46AC7180007
X-Stat-Signature: o78oifzju1igwzzzm3g63gkqo5cws8fc
X-HE-Tag: 1775298306-490300
X-HE-Meta: U2FsdGVkX1+HryXwMNKEz0Kat4brYFG1kBLQq2L70Nb5QYlG7ADPE5XfN5JS2Mt5ZHTA5GtGiCxXkAaSvlgynCcpHCBL0QjVJNdnC1TpI67hUWyb7VU4D/dEqse0fViZ/Xk0URM/s7nPVb6xBQY+JQsk/yHPn6RcFXkoz1c800LupFNqYaTFXxVgsvi16rjZQWLDA9mz6GBELke3Dp+5wF0jE1G5f2KKpT6CkoJ4p/UBHSwsX5T6JIUtYxOUbPPHflQUlj7q+OyMF8gS93xHxA6TWmO3oXZOKED75OHrI/y/Cr/re7C3p3VXC8P1BnHzHNYmausvkU1xOE9HkEvzqoBGEIBXi7YDL6+xPE2A5H/mZURqw60qx/7edzXTIuUJM9Bz0KuYmPegZq6r29qiNLvIoEcb7C1DmhRVJduKhsUSJDMAxeRLvNYY1e1mF8nlFLtZd6GCcAgOaAbbjytnz02Hej6ae9vrs/8n36fBb/4Xezj6dr0gNV4EGu+Er9fhdZDr0QoABlNYKC9MzfYGbANmE80TlkigTAK6xvvhNrUBNwFhJs99XfRVDj8Cbsqp+62B3Irzm2ocr4QLDNjeY/7rcA8JYjSm0qzslWdovRe+omExmg7egfeH5/wl2CW+Uu+ybDyAWdLAr0qwbFqnht/uy3RojJDsz3P+oe1gL8n2Tbf5/JDpLAs+YtY29N04zKQG0zg2l5YieZwNa4WBhIT+0XpTaeacqa7LT2aAMvCMn3fwFSNqeVYQrJ0n1XLashIYNipEZ8g+/Gu5YMLziGMm7cdXIIp1qfpw+DJfNN42pcsXqnD4a++8LKWQhPzfetDm4i3NiW9CyFbhYGh1Cxvoxf2fyGD9Xv1X4bps95ZnR5IimZccwRYC1kqrSS1luyQa4QrnkPKUsTGVN8QKaGTiCnP8peetT/BND5EJfWli1FwgIsJzeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Currently memfd preservation using LUO is only tested indirectly via the
luo_multi_session or luo_kexec_simple tests. Their main purpose is to
test other live update functionality.

Add a framework for writing memfd tests. The framework hooks into the
kselftest harness, but adds some things on top to make it suitable for
live update.

The LUO FD (/dev/liveupdate) can only be opened by one process at a
time. Each test runs in its own process. This means the LUO FD must be
owned by the main process and shared to children. main() opens the LUO
FD and shares it to child runners using a global variable.

Live update tests run in two stages. One before kexec and one after.
Detect the stage using a special state session. If the session is
present, it means the test is in post-kexec state.

Additionally, take in an optional --stage argument that lets callers
specify expected stage. This is useful as a safety net to catch LUO core
failures. If LUO core fails to preserve the state session properly, this
option can help detect this and fail early. Since the option is not
recognized by the kselftest harness, remove it from argv before calling
test_harness_run().

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 tools/testing/selftests/liveupdate/Makefile   |  1 +
 .../testing/selftests/liveupdate/luo_memfd.c  | 78 +++++++++++++++++++
 2 files changed, 79 insertions(+)
 create mode 100644 tools/testing/selftests/liveupdate/luo_memfd.c

diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
index 080754787ede..051daae55eec 100644
--- a/tools/testing/selftests/liveupdate/Makefile
+++ b/tools/testing/selftests/liveupdate/Makefile
@@ -6,6 +6,7 @@ TEST_GEN_PROGS += liveupdate
 
 TEST_GEN_PROGS_EXTENDED += luo_kexec_simple
 TEST_GEN_PROGS_EXTENDED += luo_multi_session
+TEST_GEN_PROGS_EXTENDED += luo_memfd
 
 TEST_FILES += do_kexec.sh
 
diff --git a/tools/testing/selftests/liveupdate/luo_memfd.c b/tools/testing/selftests/liveupdate/luo_memfd.c
new file mode 100644
index 000000000000..c1f3275963dc
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_memfd.c
@@ -0,0 +1,78 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pratyush Yadav (Google) <pratyush@kernel.org>
+ */
+
+/*
+ * Selftests for memfd preservation via LUO.
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
+#include "luo_test_utils.h"
+
+#define STATE_SESSION_NAME "luo-state"
+#define STATE_MEMFD_TOKEN 1
+
+static int luo_fd = -1;
+static int stage;
+
+int main(int argc, char *argv[])
+{
+	int expected_stage = 0;
+	int session;
+
+	/*
+	 * The test takes an optional --stage argument. This lets callers
+	 * provide the expected stage, and if that doesn't match the test errors
+	 * out.
+	 *
+	 * Look for the stage. Since test_harness_run() doesn't recognize it,
+	 * once found, remove it from argv.
+	 */
+	for (int i = 1; i < argc; i++) {
+		if (strcmp(argv[i], "--stage") == 0) {
+			if (i + 1 < argc) {
+				expected_stage = atoi(argv[i + 1]);
+				memmove(&argv[i], &argv[i + 2], (argc - i - 1) * sizeof(char *));
+				argc -= 2;
+				i--;
+			} else {
+				ksft_exit_fail_msg("Option --stage requires an argument\n");
+			}
+		}
+	}
+
+	luo_fd = luo_open_device();
+	if (luo_fd < 0)
+		ksft_exit_skip("Failed to open %s (%s) device. Is LUO enabled?\n",
+			       LUO_DEVICE, strerror(errno));
+
+	session = luo_retrieve_session(luo_fd, STATE_SESSION_NAME);
+	if (session == -ENOENT)
+		stage = 1;
+	else if (session >= 0)
+		stage = 2;
+	else
+		ksft_exit_fail_perror("Failed to check for state session");
+
+	if (expected_stage && expected_stage != stage)
+		ksft_exit_fail_msg("Stage mismatch: expected %d, got %d\n",
+				   expected_stage, stage);
+
+	if (stage == 1)
+		create_state_file(luo_fd, STATE_SESSION_NAME, STATE_MEMFD_TOKEN, 2);
+
+	return test_harness_run(argc, argv);
+}
-- 
2.53.0.1213.gd9a14994de-goog


