Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8363EFCD9E
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 11:54:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BC2E6B0089; Mon,  9 Mar 2026 07:54:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 515146B008A; Mon,  9 Mar 2026 07:54:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 340386B008C; Mon,  9 Mar 2026 07:54:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1DD026B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:54:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C720E16014A
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:54:55 +0000 (UTC)
X-FDA: 84526368150.12.84D33CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 20EC6A000B
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:54:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QdRW6ZzK;
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773057294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hxncm0MuN/XyAdr0kGExvOJPKEgg2c0ZDcSpaZvAHio=;
	b=LeIDFTYveciRE2fHPb72KYV1YAQ1Q+yUC+4kUi2Ygr9BoRr8Lk4cIBkAUH2wfE/uiSxoPR
	oeB0t3ltCb9rKPkJjGdrVhGMnJ3xMUCQfg1oyPImj3ft3iVyqvFaeLMGwtKtrgIJkUtVQn
	+j5Y+kdUwhIjz3+TIx947mpARc6baZU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QdRW6ZzK;
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773057294; a=rsa-sha256;
	cv=none;
	b=xxNrISKUtmJOhQU5u44ouPL2AVcNG8PYUsIQseu9hT7SJT1uU2oQyJuy1AxC6KWdMNkIxC
	g5wIoVZExxsR11eEMFPqEKgH4vb8XUK1vvjklooJ1ukcEuNF0XGP+XO1o0GEc5AX3rbcRe
	IlJZJnzxzqO9hO3KAv2neLyOeM0oyDg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B89E43740;
	Mon,  9 Mar 2026 11:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4A7C2BCB0;
	Mon,  9 Mar 2026 11:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773057293;
	bh=dv/kbGgCScvzX+VINvVvCUHC1AHbYmECjaCbqTlfAsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QdRW6ZzKPvM1Ns6+2p0lvKAMpE0RLu0wOtgXUj+oduazNRj6Twou+nxnPz6miimer
	 9Wjfn+JFs1AzaWmo4sguLDjSnoKsVDRzxrZlBAQkud8p2Gs4v/NIyiSYJRhZVChtfu
	 6N2CQFTIskLmov4Nn7Pk/jm0AxlfAg2a07L8m/zz4pPWKLlTFzl9DV4ZUKPRmweszo
	 vRbHWgX/7X+ZK7fMj3j1BeGSG62kXZw5Sbi0BrQtWQqsVJfk5v0fwo2BpU6eogWK90
	 kCQ9mxUVUTYIKE2pHg3Qlgi2QE3bDUtwQWEpOOEmu9c+3QJ/P+2G19PbiN5luSvvdw
	 9BM5cjNtcOa5w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/6] selftests/liveupdate: add framework for memfd tests
Date: Mon,  9 Mar 2026 11:54:34 +0000
Message-ID: <20260309115441.266805-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260309115441.266805-1-pratyush@kernel.org>
References: <20260309115441.266805-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 20EC6A000B
X-Rspamd-Server: rspam07
X-Stat-Signature: ak53jysgta85ik7ogruke6wkkgapmidy
X-Rspam-User: 
X-HE-Tag: 1773057293-616230
X-HE-Meta: U2FsdGVkX197tg+9cVSkprH2/w7nPMgYtGHu8mjHqO0+iyuj9R3W+tIM2e4cG3OJukVpxabypWYjjjuQiN3t6GPXTSlKqh88x1OJD6MUBvXsQvsgv5CUGa27ujZ4Vc66Ne3xwk5Fe6hQSRkj5WYJeZ8rdEkIaCoYTG8cXXzzD63U9nwLIyqttcuuWHEnv20J0PG1guzfW19TY3iCpjTDouIXiGQhnELWh+JXXwXJGeIf3kQjiiXrdDUMfvFiy9PLsAlrUqwPHOPEpeX6CUGgWWRxiCuNtn6Kbg/H4WNSAIKQl7Xbb0XHHT/9o6TInUhgrntBkv4ONblsHDcUXyzl0Fb3VMt3P2VX0/JLXhtxZCLn+8AmlcvbVXPPcyfs1HAgN9Fc1NhEjn3vd5FCENfeOKS2qufWLJ8eV9L6GZ2l1e7pwo1/Fu8l8/hliduoKvsBb/Q0PtImwrnEAfUuXoneszzADXalM1Eoqtu8WThtbU6S+0We9KnN7YNhneb1KJCT79mU1H8GBpiON77qGLm/4/lequkCLrdZ/PQB5v13rk59HL3cmM9xBXUKXWPQibEEnMXvmsx7UkGCcd4XFh4n6CXuyszR9RdT4N1h2YggXmNDh5932NDc3zzqn5+VviZY8jVUFU+UFQqURSuGg3gOCXoP2UWtQoGaCRLvi2MMsWU/dUW5iiGMz6PLTll4hV7STDnV7m/zMDn45NyXrCsuwJS0qMamq3iGtk63LlXCbrWJT4nf8r67dmeMRS1fLTxqjJXmOjMiBrS6PDQaCnKl0R3y+A6qYS5tW0wVKLivbjEk4UivCa2uSjL50sWAE828Nz4Svk8WH0HXVtzvFD+OO8lEJNuBU4lEyzhE4ECV7C4xh2dcebkDhfzTyhNkcyyPhj68MFbcgb8/Ip1CdcVKxjDpz8OAYq8DGQKxxCXYOKWBTc03EMYMUmMSKYrA7mZ+MgO0KgYUY+OlEc/UJcl
 RQsrbs8A
 f3sIDgy7mC5zh34nugoqmL+4YylVx9mioY0OSutBdJOIYhqsW3AT/Fnl0h+PmebV9CynXdHeMeiZ4bm0g54lyLgbnvFdk4Iu33CxZ0tJFu/53e28eXrwKbae3wHfDzOI25p+xEi4bM8UNe4R6dp2siRSVL/dAOInzKtA8+9oVREs27Y96qI2VJH1jY8RTl+f3Km0pHw9+uVK7f2IBGLFBdVrt2HiX+rBBti2zgR1Mp26A6vA=
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

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 tools/testing/selftests/liveupdate/Makefile   |  1 +
 .../testing/selftests/liveupdate/luo_memfd.c  | 77 +++++++++++++++++++
 2 files changed, 78 insertions(+)
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
index 000000000000..b779eee18387
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_memfd.c
@@ -0,0 +1,77 @@
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
+#define LIVEUPDATE_DEV "/dev/liveupdate"
+static int luo_fd = -1, stage;
+
+int main(int argc, char *argv[])
+{
+	int session, expected_stage = 0;
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
+		ksft_exit_skip("Failed to open %s (%s). Is the luo module loaded?\n",
+			       strerror(errno), LUO_DEVICE);
+
+	session = luo_retrieve_session(luo_fd, STATE_SESSION_NAME);
+	if (session == -ENOENT)
+		stage = 1;
+	else if (session >= 0)
+		stage = 2;
+	else
+		fail_exit("Failed to check for state session");
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
2.53.0.473.g4a7958ca14-goog


