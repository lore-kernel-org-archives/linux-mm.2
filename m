Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91BCFF9D0F9
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 20:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9878B6B0096; Tue, 14 Apr 2026 16:02:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95F156B0098; Tue, 14 Apr 2026 16:02:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89BEB6B0099; Tue, 14 Apr 2026 16:02:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7D3B56B0096
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:02:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 01694140217
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:02:49 +0000 (UTC)
X-FDA: 84658234500.01.D82AA55
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id 362CCC0003
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:02:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=I6v0q1ji;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776196968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9TjUnXkwrio/0RMOWx8bIqnkUDx9TXK82cA2FHqDPhg=;
	b=ZvX247emFfpMBo4LBVkwx9TgtGGGG+6u37FlIT/Fysf77aBWtp5thlm/rUQf84jJ84O5Ek
	gAKEvwYj+QDJsPLwbknXnPmJNs80FXUVDuJmViFnwddrnbnUNFyiwLYVsvtwBPNeFiU6W9
	Ywp9jEX8LwgtvUwcyed1I3L6XBcB8B0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=I6v0q1ji;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776196968; a=rsa-sha256;
	cv=none;
	b=Pza184I8sCkMLoqRkzdjfHwBJJ9BWi5SaZiYjPZNhBrdbqTy7eqRTJGbix28MmQ9/AWH/Y
	/Hr3yOy49pwSkEL85jpXHRluSm1cXrKB9FLEMZq3J6ic3SshbeSylE8l6o0kPaJYT+NYU+
	NWxDyYT8DYGaSKo0qnAzUZamF4OQrYI=
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-6102bac3752so1601821137.3
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776196967; x=1776801767; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9TjUnXkwrio/0RMOWx8bIqnkUDx9TXK82cA2FHqDPhg=;
        b=I6v0q1jien92v67kciss5jfwfAHwdR5PRzUPEJx+kF1CSXojXWCxTi9P8PtCIp8gu4
         zLZ/K5jdISfFOXX9HCJuOwEOSDD522U6yB1dMqOGySUsZHbEkXFwWawGiSQWcbZbSS78
         gwICO/dO+GXsdAyz92WN3wjogbNIdFrRYrAy7ESB96BHTLRRzoage22t8YkBKXMfNo4V
         /HYZm5oqqi5CjmtXmVhdZbh8AA2GnD5cGzsbQ6ZKFyyImQ/3p0I+jBF88XYMS71wz8Q/
         mBbpelsXEEb+xsxuLXktuYHakyKoqomnEnK2ocqfK3YYUBhDQgsmi9GhRVUqPl1W/jyt
         qf5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776196967; x=1776801767;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9TjUnXkwrio/0RMOWx8bIqnkUDx9TXK82cA2FHqDPhg=;
        b=B+U215NlQa3LEpG8hdW9MQ9U7PC3YnbHhsabAf4pSZLqwjIHRoA/tAi25QdfCL1nxm
         86f5dk7FSMBw0VbEh2sdGWIh8zvpWt1uOf1Rnzqc8LhSWHoQBJ8/dsyT4llC4eak7Xn8
         KJi7iU2GiwKFVGpErC9NJ5gmVEYohmh5wuECpwtUj7EeBPUxaU8Wo69JAGfGaRwZcSGY
         PmkZAfH3XhloqeuEBSlZcAY9jHOtGV8eY2TnOQ1edcXY52ye700T4ghSXWzCi3LJPDgZ
         foM316EeFv3wqiE732oI8CtDRSyZlIY5nzKXKIGjkqzfvlJL3q9zcwi5S7r6hJqUN7cE
         Hm5w==
X-Forwarded-Encrypted: i=1; AFNElJ8d84VmMiJUydCoYrQo+Z2hAzjMV1k5aYgr+lQfUqXbqaiWJ1v/aJw7rb+j7AAcc3HIntURZZNrwQ==@kvack.org
X-Gm-Message-State: AOJu0YyT63BEsVGLGpd4/jDgKkCPVRsuazbqn+wgYEp9KqBznOs32oqU
	OIyFVSY69r3s/Fu/Kqf7Ndrm4V9143UnUWwHvoG6NGgvSb5hM3Hct1e3xlf6r+XmEDM=
X-Gm-Gg: AeBDieuq1LwZzAXplDBtmjOjVkbdQ07lGvfMikRUeaC572rlmS7CWyR/d//13YIr8Ah
	YoeTqOprqwxoiADnKDAlt53/NSV62Crcr3w4EccuZK9UzMe+Krazff0mDuo21IRA4wWNXx3welw
	b9c9W2qHc94Cb7OPwRsDbyoMKKSsKaDq7jP8QaKgkEJugryVI42wbOk/apxY6MmhQ2VhHLrP7OF
	VEaH4hbwMKU8v7QkhI024F1zf4Nxw7wSlNgoyFK67KcPo6dny1nCpuLSEZ1DNXYRCv/v6HkNkdR
	TxE+3MMiELuD78Oays5xi7iUtabSsVzM6Hjj8HOZFVVPsx/di9Vo9UCRF1SLshUDhKkSqqejlZv
	MNHnYUA1pwMAa5P1n7ZaTbTk1OODB6ERZUXn7A8IRN4BaxPZC2G25WahnMHWQkAI54u0F5NOqz4
	GmXgBk/Apcun9lHnY98xZYKHFextl4EOMID3ws6/yr2aQglTZ8q3JvZ4Ua0aT+g6bO1rNCd67a4
	698
X-Received: by 2002:a05:6102:2c16:b0:607:95f4:53b5 with SMTP id ada2fe7eead31-609fecbd99dmr8981083137.4.1776196967110;
        Tue, 14 Apr 2026 13:02:47 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ac84a180a2sm132213656d6.15.2026.04.14.13.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 13:02:46 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH 5/5] selftests/liveupdate: Add stress-files kexec test
Date: Tue, 14 Apr 2026 20:02:37 +0000
Message-ID: <20260414200237.444170-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260414200237.444170-1-pasha.tatashin@soleen.com>
References: <20260414200237.444170-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 362CCC0003
X-Stat-Signature: e7iwbqit9xwoix7u4i7osgz5xy1xyk1m
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776196967-876421
X-HE-Meta: U2FsdGVkX18Kut86hoZhHlAPMChbSKxaaLIsuROIrBmfO/tmtbn+ZKRK9R558Hsofms0RAc9kGSZEJrFp6fHtz96/HoZ/x+YN1PwfdGP5lI3VjXy8PHE21GWCWYmi7JxrIlmFjGo7zJCFzPr+o3NCHxAPQH/m8GwjdVp3/25wOpFc+5anNHwnANTloFhLQepq3eeeZ3m3bmN2RHbf6bhIyWzlIaOh8+ek/PZG3JEkrdbCTaEO85/mrg3NkbYcW91cCsGkZQ3F0zTPg699o5ila8u7yAZfNb/klndoVVRRxXrDInc+hReIQhA3RrXHTTGCUmlM3lPYQXSU0PY16UNaDIoyaRN4Nc/D4/yWyK4oGmhavXYmcQbqBy64l8eHgP5lUTmC+W0kGIeRGYcI/p8Nk9zWej5ok5oqpezqaZ5/FhFRH4R4LsuGTMtHupZkN9k9iAVnRguOo3+Mk6/jN37cYm0QeDsj4Fu/kPXQVd19Ura0ad6/RXB79ZX3I3b2zzYVT/fpwzXw4ijWYUnJKH/34fFv9Z7tWpmT05FoNFkdHbb84FGn62SzPbv10ydGj4stL4IxtzTFepfrr57UHBlgQ8ZGt4GIcjX+xR9Huj7I8sXMO0ggYYqXZXR0cLginjGyR4Bv4O6FvPdhMbRDO1AYeNzbUFkNr+xSEnyrqcMZiHM1zOk0tXev/HzNrtaXBzs473PwKlR0toJKcL+M7FNV01TzKiSa2778wtu04/+J3DceqmfbKC2Verba1NehA0c6TKrw0Yftxczg/pg6gYrkXc9+4tXId6LsoJe6uydnu4HOrhuaYKTIKudiJWuEGzDAjcRRwQQwaM15COL8MtWZBh7aumg2XXHtaFzwkgPQ6lhKGuWebIX4eyKG8a3CXI0x3+DBr3jA5Ox3nrYj7qD07/GZJUhJ84cOf0i6yYb/UcgfBUnia+IDpsipRGf1VngAQ9vF1IjiTuESPZDiEB
 D3EoBXcu
 C+MOyOULtZMEJ+UV3bGWKROy4WeEyc0wfhngQJdpxf5AQ3G5W8IHmV7EuGYMSOMZ3VqPka+eC0H+4q+G6junDYveSg4tEzHCLEhrc8rDwsgD08gSg6g2dQ1h/jT9NeW6q6XIw9Y8rXMOEX/GWLaYDnc3JVeYDHPo55eXt01WXAqX1d7Io3iECvtlDPvzPxTUVsuFEAVi4GgASEMhAFjADEzc94PKa5nzN81Lu/AnPXm5iwbMprj3gZmyVzFpxMA3YZ/X69QbloBUwYXmN2WbeQrya1kznpCyFVv59YeYNMWSGFNsabkKfOSnbRFolT/kARvJV9wMuQBJYEuk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new luo_stress_files kexec test that verifies preserving and
retrieving 500 files across a kexec reboot.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 tools/testing/selftests/liveupdate/Makefile   |  1 +
 .../selftests/liveupdate/luo_stress_files.c   | 98 +++++++++++++++++++
 2 files changed, 99 insertions(+)
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
index 000000000000..6217122b92f4
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_stress_files.c
@@ -0,0 +1,98 @@
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
+	int session_fd;
+	int i;
+
+	ksft_print_msg("[STAGE 1] Increasing ulimit for open files...\n");
+	luo_ensure_nofile_limit(NUM_FILES + 10);
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
2.43.0


