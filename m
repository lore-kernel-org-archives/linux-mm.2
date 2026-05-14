Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9411ACD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 22:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A56386B009E; Thu, 14 May 2026 18:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2F0F6B009F; Thu, 14 May 2026 18:26:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 859886B00A0; Thu, 14 May 2026 18:26:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6A8E66B009E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 18:26:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2166A160DFE
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:26:52 +0000 (UTC)
X-FDA: 84767461464.03.E3250FE
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id 42F3A40005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:26:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="cF+8Bs/f";
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778797610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZIrwM3YYxVlDXZ9UztplnfGrca1M/xZmJnShxYpBntg=;
	b=AC7ntx8qhwE+QzAYiD60tlxRHYfzKVj4JIisrKm72+M+GMBC2dxF+Th6fjJLAOWd6jsDX+
	D+tzRZti4smXzC4sYeUViEUZhqU4Nf4Yq/1z1Ax/y5lm1/Tm8RyFlYOh/MoJ007fyYKGQY
	4kcdEuE7u9PEqSpuaswV14ltPx2mp4c=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="cF+8Bs/f";
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778797610; a=rsa-sha256;
	cv=none;
	b=hD6KrCwxRJbq/Gj+xbpjDKWbYehzW0CFCH9Uyuwow74LPH/hIuaGET98W3bmLttwYe2TDi
	lBv76ptA0LTFgBj58vhblQcDanz4SpxBSqu0nhzEl/yvokYgjoIoaM9A87/fMqs7EGTwME
	N+3UPZjX65AF2XbyZtjzc6j5IcNUmek=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8cb5c9ba82bso1228874385a.2
        for <linux-mm@kvack.org>; Thu, 14 May 2026 15:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1778797609; x=1779402409; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZIrwM3YYxVlDXZ9UztplnfGrca1M/xZmJnShxYpBntg=;
        b=cF+8Bs/fI4oqojcolUzIZfKQ5qKs26hyyfhrjmEw5H63kWHExaFlXzxG7r1BYxtVyp
         hjMksQ7+/+y6ZRJY1B/DTCpRp/mGrWYitqABNXaApuz1F7UGSl40Maog4Wy7XP3hb532
         PNwM5FEc1LYqg5vE1+4HLrXtpTaFcsdiN7UwqPpARyBqNw9xtTWtEAdy64ad+uHRdIWH
         +d0jkDyW6NwIFWRwgCbaAc1msW+FTaAbJiuZIYApWEiUmIY1sQsEDB0yTJU0tNeF4Qz/
         wRLXLz6pZJlYEo9R7jWJOUFTXFlW9Fs7hrSujXtr1LkRISQnAKm6MYOfVBZDY/hVTrhg
         LpWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778797609; x=1779402409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZIrwM3YYxVlDXZ9UztplnfGrca1M/xZmJnShxYpBntg=;
        b=K2YPacM3tKTyf+C+dr+ugL2aXRe31VvMqb/uqIWfAzHQv8+HDTa2QUAcxjkzLlZI6a
         IoHDSMW6dYykjGnquhfk0TPckCEn2OrBKEj12or2nky/JC0Q3AFwCSLsH6F36Za0boaq
         ZPUwgdvaESNTo4lf8lmBW90dmuNHwQyAsYohJTIoXYGNJcem4cGnF9NXOcXBMqt5WJIF
         LfPoacsnDaYI+zPiiGixWlPfwHnGRKNui6TL6WEGFc9eVxG519kXQYxcf1P+dlZFOLvh
         tfpAOIaCWeWbzGl4qGLlVGh2w8INGYhrS/k7LK+N5wt4IXyhCXgDeBvRmDNixzOmCJgB
         WbpA==
X-Forwarded-Encrypted: i=1; AFNElJ8qPmuIh/zro3iRb0Gqe+NcMQoE6J0i7HXikpX3TDhCGPVi8BplCiZR58Mv1bm6tjlkzvEge4BRtg==@kvack.org
X-Gm-Message-State: AOJu0YxlelXdQhgGwjv/e3YQJ+5BBJvIjL7y154npmipAukWAov2rzH7
	DrpHPu5x7AuOqYTN/qnuzglUaW1s0mUT2CGDNY6ez8Jykl172VyQ2KNhEqK+K8hYVag=
X-Gm-Gg: Acq92OFb2gA4OHU41HJb94+wg4DKiOOL9d6yijo5QTwY4cDTLSzUTtWTVNVKzemHcev
	cYE+Dsn80b9ccsm0PYdR1tP/ht7VzRg3F1ozh2TT5Q3wM1iiG2Y7DEUSmIIhkh7TiKz9w9ZJpuB
	GmZJyVJ8An+YtUlXCF4ONETsdPUfn8Drlp3kpYFYDjjan2hobltYnHE31R8XTQzjRPHHvQhG27k
	7m2lqYbU5VwPjNoFGJR1n9aVUcQMqbQXbDNaFbIOFnBHOEMh5FOwxhD4pqhWHBgAG156XV+OWXg
	i/aB6WxE9YIVAg96ux7qnDiF9z0bilEGUmCj23nQjGhgNxSn6UEC1Sv0ldGI755arNOFhg3gPtw
	J4ie+710y4bQ6+U17D1Yo8TTKx72rQ7qCvKk5qoC/b2xTuLVuDG7NqMdTIKzK9TJlmXXteClLbo
	sZTrBmUETfvWOzCKRuSM4wi4k9CXyu/fdVoxKD2ZmtuA3yPFHQoaU=
X-Received: by 2002:a05:622a:2445:b0:4f1:ab79:fb18 with SMTP id d75a77b69052e-5165a03e931mr18328421cf.25.1778797609141;
        Thu, 14 May 2026 15:26:49 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516456ba92fsm28671901cf.9.2026.05.14.15.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 15:26:48 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH v2 10/10] selftests/liveupdate: Add stress-files kexec test
Date: Thu, 14 May 2026 22:26:28 +0000
Message-ID: <20260514222628.931312-11-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260514222628.931312-1-pasha.tatashin@soleen.com>
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 42F3A40005
X-Rspamd-Server: rspam06
X-Stat-Signature: d3uoy6d3ypzt5s1qkfi3fmo46g83ursr
X-HE-Tag: 1778797610-491032
X-HE-Meta: U2FsdGVkX19y1H4LvFWM3R98uGUgs4UR6WURLsIxxw3IukFxU64CSAwmVYS4Cz8kx7eRReNcZ9TBAob1x3k/Qi2C7No3fco0Xkuldwr0AUIOnTw1i4mXl0OoMB6pXzCiI1/89yj52gqe+4EUn88cn+XtjYRPAQ++kOw50dbxiwCmxwYBgoja70syBcvsDN3x60Yc7hpM40JjCbpZ3rswXUG5CGJo4tqPmm1jk1PKCDR5ZvBnTkgtyjj1MsEh4treimwUwPcRONynbYunSzm8nvG+tBzSVqPiME669Mu9FM+6hnUPaZJtQIiLO5VzhaXLXh0p163QRE23+ykuV9M6yIJuS8PDa0isQ+43uoyomS+if6rWCEwRoVZMbaIaqt84FaTvs55H+c+Jb6ZFxVdNDRWuGFaF//4z+vrLzRMgroC+52w+krP66a7SxC/aQKwh8olnG9Q2t6DTcEg+yBDBXQzwpp8qmRpy0tKjItjwa33xObb1ZZAe6/O9wGU996JHyiqRQ1h3AgWUYG2a1hzc8VYWxO9y4HGrUfoyOyxQdIObtXtiY02vk1bkq3Y45/3EWvJRGx2oTucLn6j82Nmr8auxEnWcXvOlRNm+D27/VNke/xK8SGz89By+vUMjx7WFz0OXB039/rR3yXy6uOY7ex2H0Ghv5/2GpoAZ146pXRi8+AOX5SYBE0W130o/xPa8Z7nREOIgwvbzMGa/QNMZ2NlFiS7CCCgKH42S3DXSIKDSfDWJOADaTHVBn7i4PdIPHiddlZAPSjFqxzxBfxlPP6FHvhS7OzcX7OMmcrxDf5XfJinPwD+qx2IHgokIKNCEo7djXmi7bKt5UjBKIC6Fp+OjB5guTjsFGIhzAiQPWYwlwK/HFHHr/ARTATkzIpFWUnYnXTOuz+XoV+antLyVxtufFq5/C7PR64iHb3cSarEODsi8CnnI9OiZevvBZubHwzh3O5hRFqykUj7li2y
 oy94vosA
 QwcSwdPR1gmLX+KWJRjujDMffsYY/rHcFl5aD3TsvRu/K4CPyRUHIpfifPHy4mzA4d83gv5jSQGz2Bdp4un8v+KaHC/JUhQx9zSQfOGHsFn4bpbHC8EN7dxGJzG7FY6zo653AzpKo8C7x6ih87zXO5F5r77kYNmABoEIELATSfc7Y9IYIU2MNSHg87PkHyaj9l6ri8vXggw5HkGbIGexB7E3GxM2xcypU8KMvy+BNn+af1lZHDJtfqjT7DdUAFAHExqF3S7nByrTILOLOcjYV7rwvrOum5a3cbRRr2tYX4XVsF2xZHRogTSIe0x130itaUkubBMcCodaDHopxZImDEP9JRu6OIv7fXZ2j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new luo_stress_files kexec test that verifies preserving and
retrieving 500 files across a kexec reboot.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 tools/testing/selftests/liveupdate/Makefile   |   1 +
 .../selftests/liveupdate/luo_stress_files.c   | 101 ++++++++++++++++++
 2 files changed, 102 insertions(+)
 create mode 100644 tools/testing/selftests/liveupdate/luo_stress_files.c

diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
index ed7534468386..30689d22cb02 100644
--- a/tools/testing/selftests/liveupdate/Makefile
+++ b/tools/testing/selftests/liveupdate/Makefile
@@ -7,6 +7,7 @@ TEST_GEN_PROGS += liveupdate
 TEST_GEN_PROGS_EXTENDED += luo_kexec_simple
 TEST_GEN_PROGS_EXTENDED += luo_multi_session
 TEST_GEN_PROGS_EXTENDED += luo_stress_sessions
+TEST_GEN_PROGS_EXTENDED += luo_stress_files
 
 TEST_FILES += do_kexec.sh
 
diff --git a/tools/testing/selftests/liveupdate/luo_stress_files.c b/tools/testing/selftests/liveupdate/luo_stress_files.c
new file mode 100644
index 000000000000..b6a0c3899890
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_stress_files.c
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * Validate that LUO can handle a large number of files per session across
+ * a kexec reboot.
+ */
+
+#include <stdio.h>
+#include <unistd.h>
+#include "luo_test_utils.h"
+
+#define NUM_FILES 500
+#define STATE_SESSION_NAME "kexec_many_files_state"
+#define STATE_MEMFD_TOKEN 9999
+#define TEST_SESSION_NAME "many_files_session"
+
+/* Stage 1: Executed before the kexec reboot. */
+static void run_stage_1(int luo_fd)
+{
+	int session_fd, ret, i;
+
+	ksft_print_msg("[STAGE 1] Increasing ulimit for open files...\n");
+	ret = luo_ensure_nofile_limit(NUM_FILES);
+	if (ret == -EPERM)
+		ksft_exit_skip("Insufficient privileges to set RLIMIT_NOFILE\n");
+	if (ret < 0)
+		ksft_exit_fail_msg("luo_ensure_nofile_limit failed: %s\n", strerror(-ret));
+
+	ksft_print_msg("[STAGE 1] Creating state file for next stage (2)...\n");
+	create_state_file(luo_fd, STATE_SESSION_NAME, STATE_MEMFD_TOKEN, 2);
+
+	ksft_print_msg("[STAGE 1] Creating test session '%s'...\n", TEST_SESSION_NAME);
+	session_fd = luo_create_session(luo_fd, TEST_SESSION_NAME);
+	if (session_fd < 0)
+		fail_exit("luo_create_session");
+
+	ksft_print_msg("[STAGE 1] Preserving %d files...\n", NUM_FILES);
+	for (i = 0; i < NUM_FILES; i++) {
+		char data[64];
+
+		snprintf(data, sizeof(data), "file-data-%d", i);
+		if (create_and_preserve_memfd(session_fd, i, data) < 0)
+			fail_exit("create_and_preserve_memfd for index %d", i);
+	}
+
+	ksft_print_msg("[STAGE 1] Successfully preserved %d files.\n", NUM_FILES);
+
+	close(luo_fd);
+	daemonize_and_wait();
+}
+
+/* Stage 2: Executed after the kexec reboot. */
+static void run_stage_2(int luo_fd, int state_session_fd)
+{
+	int session_fd;
+	int i, stage;
+
+	ksft_print_msg("[STAGE 2] Starting post-kexec verification...\n");
+
+	restore_and_read_stage(state_session_fd, STATE_MEMFD_TOKEN, &stage);
+	if (stage != 2) {
+		fail_exit("Expected stage 2, but state file contains %d",
+			  stage);
+	}
+
+	ksft_print_msg("[STAGE 2] Retrieving test session '%s'...\n", TEST_SESSION_NAME);
+	session_fd = luo_retrieve_session(luo_fd, TEST_SESSION_NAME);
+	if (session_fd < 0)
+		fail_exit("luo_retrieve_session");
+
+	ksft_print_msg("[STAGE 2] Verifying %d files...\n", NUM_FILES);
+	for (i = 0; i < NUM_FILES; i++) {
+		char data[64];
+
+		snprintf(data, sizeof(data), "file-data-%d", i);
+		if (restore_and_verify_memfd(session_fd, i, data) < 0)
+			fail_exit("restore_and_verify_memfd for index %d", i);
+	}
+
+	ksft_print_msg("[STAGE 2] Finishing test session...\n");
+	if (luo_session_finish(session_fd) < 0)
+		fail_exit("luo_session_finish for test session");
+	close(session_fd);
+
+	ksft_print_msg("[STAGE 2] Finalizing state session...\n");
+	if (luo_session_finish(state_session_fd) < 0)
+		fail_exit("luo_session_finish for state session");
+	close(state_session_fd);
+
+	ksft_print_msg("\n--- MANY-FILES KEXEC TEST PASSED (%d files) ---\n",
+		       NUM_FILES);
+}
+
+int main(int argc, char *argv[])
+{
+	return luo_test(argc, argv, STATE_SESSION_NAME,
+			run_stage_1, run_stage_2);
+}
-- 
2.53.0


