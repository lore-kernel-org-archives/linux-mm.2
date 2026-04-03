Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B86BE8538E
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 19:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDD796B0088; Fri,  3 Apr 2026 15:40:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C66426B008A; Fri,  3 Apr 2026 15:40:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B07806B008C; Fri,  3 Apr 2026 15:40:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A3F206B0088
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 15:40:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 571EF138E10
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 19:40:30 +0000 (UTC)
X-FDA: 84618261420.26.5238072
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id F3C312000A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 19:40:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZoTiwGe1;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZoTiwGe1;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775245229; a=rsa-sha256;
	cv=none;
	b=fV6hxdml9dcu3VuSOnCE+wz098sMj0WvrL83kQ6ayMs8AhbjakiN2JoatT+mDtPdjWE0Iz
	fjS42JMfPMUFmk9VulUC8JK3csmhpBygQhH95FzlLpQq+A2EzvU4vVVcUyy2iuWcE59K4n
	ecfBMYZx344mzw1LPEEj218YAYYiFmA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775245229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mmoJNEQ0FJTshMy+4cXa+1gXV7M7gLfgBSqHHocoRU0=;
	b=NgW+NKNBmrnCvWVXAygEpSdeQtO+iF2Hz7+YUUcdaSSDsYfMZ/lfaTUo5KhXg0PAJ6qY7m
	sQbum6Azv/ZxL/Qap1E/DE8CEXUcveGJs0HBdVnvSn6RK3wwqno/D3SPPWLiGTOuNT4aVC
	ldWCOZZvUgkTBZgqop6Pue9CSguQBFY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 54A3460121;
	Fri,  3 Apr 2026 19:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD8DC19424;
	Fri,  3 Apr 2026 19:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775245228;
	bh=VK1HcPC/3wExF1FoSkZi5ZUUe6b5gm8f6ww+D0kO+o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZoTiwGe1QmwvyLreS4Iwrj0r8ah0hPBXnXkDtoGieRWHthFimFGI/8HyOb0NfseHn
	 U3Rfy1sk15IcwoJLlpi32RaU6sx0F/WIfS49RxgHFJmI2SxvbSHZm5RmndtmsNjjy5
	 9JIiG6ShZO2+U8SlhLW2qp5Wz8yI6r6dhBeJP+RSJae8qbTkIhHVjLhE2QHfY6aWaa
	 C4lj3ERuasJB+zfR4KTOLQqnwPHge8yRiNX736KKPZ3jlpcDYTuNkk+HAo3Q3X6n5h
	 pztj4dQayog8j5amMJ2fQgbBklDTkb0hQVeL0ucoCZF8M2p6iXp7ZJWxrIrUZlnYVp
	 v2TCiAAEh4yYg==
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
Subject: [PATCH v2 1/6] selftests/liveupdate: add framework for memfd tests
Date: Fri,  3 Apr 2026 19:40:07 +0000
Message-ID: <20260403194014.3704180-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
In-Reply-To: <20260403194014.3704180-1-pratyush@kernel.org>
References: <20260403194014.3704180-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F3C312000A
X-Stat-Signature: otiead8iggp9xi19c4mefse3ceg55icu
X-Rspam-User: 
X-HE-Tag: 1775245228-633550
X-HE-Meta: U2FsdGVkX1+zqW1GiyGkQ8e8KheLG3JkWJnXeYKeMgr2iX41jCkc2UileN3CPT4AgouzCIJJi9rS6V8pjrXmhbxEjNA2QkbeDsf8SHnmp3PORCGlWdFIGTv99sGTq20jZ7G80WdKgufxO0VdfOYH0TZx4nYmAxCPBE5GgyWfQvz4qJJKYwjHBwSwIoQBEV6hUbN1EMc5yJzkFQWHOo475gUSO9b7u53wBdaBc0XkQBmI5wi2PqRxIYgCMePe3JZm+pTPWkiAzFbnDh0zxiEo11ayGC99sjfUUxYh4uX2LJOPk6krGHDSP84W47P5uln6VxAkRdIjztL/Ubyusw9oAHa5auySxGqDGNay5ctarSlJHUhPJYHYSz3qiMfXDoa6VsEMZaalzX+OuUgOzc7Gozs1tFx5PVCdtfhoqBcZF8dSim9HSHQH/CRnQuv97d8MmQV/tIZUpcoqt2wNKOBfugiXkoQUaZMPBpJBAzeZSTK0FDlYQncAAkLjsscnA7qO8Senc13TPGHztWKmHgsbxcHz9BBk06+O7WrP3paBLLkEDiphQcdu+XPRICKwSrSovpLk2FRNGjx05FX35JcUKeOakFXcST4kOizCrReMdWgc8Xs0DkyfoQMsUoWPo2fKmWvQboXunll3t1UqF6DsknkPMHJgseeGm9ZLts61YmdBBEMarBmhAb1vTv3ZuJ9UAby/Kx5KpAH4I6t8xYLAfpOdrWKax1hfrB5Prd2EMrcHkACCqbqfridXZWwzxIdJbAD6j9bk8UJtdy2jP2158key1cTJUwwDwwfVL2bNzN7T0hlpsCahl1cl/wjEXS9GgyXtBtnztUyLYzPHGPRNt7VvPr1BM+KkKRJ/LXk096vOpEHAEoi5eI2nN1kYCGc4RlWNcV8d8Mo+yp2JVhrf7ZUYv0SIlq0oIRUBVGV/hhcr5UN3FmOzTw==
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
index 000000000000..47d2c3163b62
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
+	test_harness_run(argc, argv);
+}
-- 
2.53.0.1213.gd9a14994de-goog


