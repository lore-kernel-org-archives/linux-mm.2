Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BF25F9D0F7
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 20:02:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B82326B0095; Tue, 14 Apr 2026 16:02:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33386B0096; Tue, 14 Apr 2026 16:02:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A49F16B0098; Tue, 14 Apr 2026 16:02:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98F4C6B0095
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:02:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6A654E3274
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:02:48 +0000 (UTC)
X-FDA: 84658234416.10.1F52E44
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8D8C91A000D
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:02:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JbBfmgJJ;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776196966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ydncbOJwc9Epn5rxEKLGgwSNmxXWJlxhMwGYD93RLPE=;
	b=R3ssEU2PSFS74IYM47pW5f6MjjfuhTPhH0URZuSuqf5LSz1lkkjjNZ9LhsFg3WpYdAn27x
	X2N2vcKps9mh8gtJCGQjJ8ssyjJdpbXMevQ2vZd8n/CGpFxXN20Xqcn8+63DAaOQQMufO2
	UmqRGQnfaHjp+jV9GvAAsyclY8wMB+8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JbBfmgJJ;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776196966; a=rsa-sha256;
	cv=none;
	b=cBsv/5PnRjoYvWzgvWD/pkr0pNrDW4UrFebar6TZWsuH+x6+Q4gfbpVOsJxp0ld6ZBoT7a
	zyx1CL/FgMyNzuquQGwAkEkL6WbhPtsixv8DWuVxpSY9GAkWmyghp1TtGEwB7b34MZa/hJ
	vztZ81y532pkQqzNOISlTCgd9knUZgw=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8aca4e14411so34789146d6.3
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776196965; x=1776801765; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ydncbOJwc9Epn5rxEKLGgwSNmxXWJlxhMwGYD93RLPE=;
        b=JbBfmgJJfhHV5Ec50gqnNyLmiOWVpVgzN8H6pabGlY17zYKzKIORJEQNHdiMvcOgbz
         osXs+Z0XrSPqMnNfw90o+e9+QJaY+EnqYrpcBBxnqq/sS1f44r6JYLBDSFZFI8I5LVwl
         31hGNDCR7CW5gTqW5bOcht+CqEvP6B+FRNW6XpuvkZqpIv1cS+vIAo6ySRy/Bz+k2uHc
         5L0GJLK4qcnEua8c5zLg/Qv0TjXc8RdiohLpgny0eBd2TFt8wWR2oiejC3nePAPBm9Nt
         YCHVX/3R41yuuch+76qkAFnk4EAvI4MYeGQt4ANJMxvtinLiTN9GHmsr+G0VY54PacY+
         PCCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776196965; x=1776801765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ydncbOJwc9Epn5rxEKLGgwSNmxXWJlxhMwGYD93RLPE=;
        b=TwA4JqoiqoGp324q/T6Dhn+2u5xnrJtlC8F7C2dGOja4Md3JnHgUxy0RokFFYD3i5M
         OBHvO08IYUDLEFakFkSU8pDOLkZN8zxCxy9FoK6ZCBe3zd8utFuodrsmFaRUs4V62TSo
         fYhHkRSJ/rJzSCqC0c2vXfzGdPioF1BHhfQg6hSl4R13BOE2vaQSyd0lykDMOtdjJgLA
         9oxrL0iVsruqXDqIlf0yS6JWmIlXmn54h0JxjFH6zvS2xCA0sl+I/+P9ll/gJMGDSSRX
         a6RDnE+6/cJ1+7RpUI9j4JoMrxzZaU98kq8SFH4r2hij1pgdQpH9sZA3N6z6P1KdTRzl
         W/Vg==
X-Forwarded-Encrypted: i=1; AFNElJ93Oaxz9uMZUh/32BzzTaGHVNtzggdf7+8QCRcYpkyn4bPqSkBmxUAPtJjbJ6Ke9qAw8G6QxvpWng==@kvack.org
X-Gm-Message-State: AOJu0Yz0UvAz0fgMxh3rQ9mu6WFtEfGXGIvjaLswg2JWwkgnjD6c2Gh9
	0jpwI4gRGN8qLZIscki/XjrtIfwhJfvLnwUpbqpVwlbZH2zvHnt7y2uJnWen64fqBdU=
X-Gm-Gg: AeBDies70gHMW8QkC6www78viOB0GJPa/mzsd8121cTDdJv7CmboWLmve5p9CaEuZd5
	Nax2p/zowh10Hrid5v6G75Z9X0wOaFSksy2ZVPwtoFXznWZaDy1Y/S0kgwUxvKKeDPIsk/B/jqi
	GKAAosVeKvJolWPJrsHlAHvzrlpxQo19YqwdW1Pvac0+fqNo+do6tG6bWadL1fNTLUmZ295qdeG
	RZ77Ym0SjGZzkyMHktnx9UXXnUGs3lJrY1HkKDxxdhP2D53bwThatrrdRhMsjwCpDaSWanp5vIw
	kHPEHoHUY3yh6V+zuER6RbZecgGOagxMZlQgReH7//WrMPXP08xSWHsD2tVqu6kg762Sy8Kthm8
	WYnsEYGnO9P4UBVYWhwBQlUa+NV3lHOhQj8Ik5c+u+7UepH1R9eyKaUMd/1AQ+u86YP8V6HJz5t
	DPf734r+ejRGKcoeE4qI8jYU4ynJqrPSlQ+lCmZPM911P671eeWW4zhsgAdZysHDTbSQ==
X-Received: by 2002:a05:6214:4a8a:b0:8ac:ba63:a1af with SMTP id 6a1803df08f44-8acba63a68dmr104715286d6.53.1776196965499;
        Tue, 14 Apr 2026 13:02:45 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ac84a180a2sm132213656d6.15.2026.04.14.13.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 13:02:45 -0700 (PDT)
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
Subject: [PATCH 4/5] selftests/liveupdate: Add stress-sessions kexec test
Date: Tue, 14 Apr 2026 20:02:36 +0000
Message-ID: <20260414200237.444170-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260414200237.444170-1-pasha.tatashin@soleen.com>
References: <20260414200237.444170-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8D8C91A000D
X-Stat-Signature: t4e58fg3qqnomaq7fxiou8wykm173ug4
X-Rspam-User: 
X-HE-Tag: 1776196966-671412
X-HE-Meta: U2FsdGVkX18wZxwJVsC9eRejtgin4puW77LkCPH5JY02Gl0IGhdWEQbcEcvy0KhHNyE278ud8NDG8dyJC3TCrLVofbxE+mS9DUYeO2hWalGtINut33Cwu/BSs0/IiMdNqx/LU4niDnmT1fh6hWtYb+CGdriJNeieiwep9DI9ItUe0HhiyBtVLnlMP6QW8lhQxkwsE2eqim4Wn5GGi/8nznyH8sm/eCa6F8ehVd9uvaGnRt8Y0vy3vGPEcJJZ37T8YMOwGL+QrgHIeNFOWkrF8FNK28T8+k/HLedlAbGB44UePToHkS2NY4xYDLxqkaGin/54lPV4JVL7XFE1irxDZXLikxgiGsPKX9zRZzipFpp3fEGUBOhRXG6mjBlufJ7AZTjDSgu7awVbHDiI2YLGQg40nWkFMlZtPkeqLzsfS1Rg/LiliB7GnU6FCxor4PAtLS54M4Og4y0KWAaowVpxiuGB63FO3Z5KPbv3u9EoE98VAEngWUYVask8wfDrajEmoWRRltjTKe9s7JM9+LmD9nN+CbrVrYnWTvn0ymglV2w1bRI8prtriZIvkK2+8fRsMxcc97xr8cOfPrN+QnHY+2q+MO92MYhHLfovLp+vVPyZp4mPx+zJqidlKsXB5Y9g0AqWZrQ/K8UZzWPYWaaWh7BtjY6RxOJe3AMyTU15UREogo8ng0UmvRkI5UwrgBOuDkdGB0Qn4wicf7z98ajsSLb+lzwJfoENiYI9dFAduH/hgdhDOUDaCkr1C9jMP5KR4mpbtFf+OcvgrFiW++xPdaIZf5L/FydeXpjB+q9oc1D1eqbkOM3TQtXSkSowFIa5pqVHl+/vKfgpcFrtVxq8parTu+fWub/feApJLA02N4fUfPZwmcAKcr4LQAkewuuIibza0jKOAOAYuwxehtKa27qRVZqojIQqDc8d6DLcWaBi4FTulv7QgfKTp+LFxjWldwtm390UjqCFvaoyIiX
 PtvayZri
 5cV+4NCAVwwXMRxBAqQps7DjNXqnMTiX/XXDEMfgAvmPEGAvfV+0QeJui47lVA7Jv3tCOf2YCyAUhPdPm2Fak76wfs59dSn88EhtGUBzDX+chQra+kkTemWA+9TxTj1BzD9MWCInzfnZLZLJ5AfsA7w8JXikx5bL01z6w1mRYcmiec65GRa5gWhq8IjedIAzoU1KO+sg3YyOPskG3V8LsAijzY6Lwpc4jwevKAEl7aerKJQK8oTlzC5403wCffnIyzNux8e2AZ+fQ7n0if2qckNpi+xfYd7kPqEIP7QrWcJF1L9M9yrSB6O2DsTVRanXS6vQn+A90qofSp4Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new test that creates 2000 LUO sessions before a kexec
reboot and verifies their presence after the reboot. This ensures
that the linked-block serialization mechanism works correctly for
a large number of sessions.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 tools/testing/selftests/liveupdate/Makefile   |  1 +
 .../liveupdate/luo_stress_sessions.c          | 98 +++++++++++++++++++
 .../selftests/liveupdate/luo_test_utils.c     | 25 +++++
 .../selftests/liveupdate/luo_test_utils.h     |  2 +
 4 files changed, 126 insertions(+)
 create mode 100644 tools/testing/selftests/liveupdate/luo_stress_sessions.c

diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
index 080754787ede..ed7534468386 100644
--- a/tools/testing/selftests/liveupdate/Makefile
+++ b/tools/testing/selftests/liveupdate/Makefile
@@ -6,6 +6,7 @@ TEST_GEN_PROGS += liveupdate
 
 TEST_GEN_PROGS_EXTENDED += luo_kexec_simple
 TEST_GEN_PROGS_EXTENDED += luo_multi_session
+TEST_GEN_PROGS_EXTENDED += luo_stress_sessions
 
 TEST_FILES += do_kexec.sh
 
diff --git a/tools/testing/selftests/liveupdate/luo_stress_sessions.c b/tools/testing/selftests/liveupdate/luo_stress_sessions.c
new file mode 100644
index 000000000000..cd6e9bb0db3c
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_stress_sessions.c
@@ -0,0 +1,98 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * Validate that LUO can handle a large number of sessions across a kexec
+ * reboot.
+ */
+
+#include <stdio.h>
+#include <unistd.h>
+#include "luo_test_utils.h"
+
+#define NUM_SESSIONS 2000
+#define STATE_SESSION_NAME "kexec_many_state"
+#define STATE_MEMFD_TOKEN 999
+
+/* Stage 1: Executed before the kexec reboot. */
+static void run_stage_1(int luo_fd)
+{
+	int i;
+
+	ksft_print_msg("[STAGE 1] Increasing ulimit for open files...\n");
+	luo_ensure_nofile_limit(NUM_SESSIONS + 10);
+
+	ksft_print_msg("[STAGE 1] Creating state file for next stage (2)...\n");
+	create_state_file(luo_fd, STATE_SESSION_NAME, STATE_MEMFD_TOKEN, 2);
+
+	ksft_print_msg("[STAGE 1] Creating %d sessions...\n", NUM_SESSIONS);
+
+	for (i = 0; i < NUM_SESSIONS; i++) {
+		char name[LIVEUPDATE_SESSION_NAME_LENGTH];
+		int s_fd;
+
+		snprintf(name, sizeof(name), "many-test-%d", i);
+		s_fd = luo_create_session(luo_fd, name);
+		if (s_fd < 0) {
+			fail_exit("luo_create_session for '%s' at index %d",
+				  name, i);
+		}
+	}
+
+	ksft_print_msg("[STAGE 1] Successfully created %d sessions.\n",
+		       NUM_SESSIONS);
+
+	close(luo_fd);
+	daemonize_and_wait();
+}
+
+/* Stage 2: Executed after the kexec reboot. */
+static void run_stage_2(int luo_fd, int state_session_fd)
+{
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
+	ksft_print_msg("[STAGE 2] Retrieving and finishing %d sessions...\n",
+		       NUM_SESSIONS);
+
+	for (i = 0; i < NUM_SESSIONS; i++) {
+		char name[LIVEUPDATE_SESSION_NAME_LENGTH];
+		int s_fd;
+
+		snprintf(name, sizeof(name), "many-test-%d", i);
+		s_fd = luo_retrieve_session(luo_fd, name);
+		if (s_fd < 0) {
+			fail_exit("luo_retrieve_session for '%s' at index %d",
+				  name, i);
+		}
+
+		if (luo_session_finish(s_fd) < 0) {
+			fail_exit("luo_session_finish for '%s' at index %d",
+				  name, i);
+		}
+		close(s_fd);
+	}
+
+	ksft_print_msg("[STAGE 2] Finalizing state session...\n");
+	if (luo_session_finish(state_session_fd) < 0)
+		fail_exit("luo_session_finish for state session");
+	close(state_session_fd);
+
+	ksft_print_msg("\n--- MANY-SESSIONS KEXEC TEST PASSED (%d sessions) ---\n",
+		       NUM_SESSIONS);
+}
+
+int main(int argc, char *argv[])
+{
+	return luo_test(argc, argv, STATE_SESSION_NAME,
+			run_stage_1, run_stage_2);
+}
diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.c b/tools/testing/selftests/liveupdate/luo_test_utils.c
index 3c8721c505df..37c330b9bb36 100644
--- a/tools/testing/selftests/liveupdate/luo_test_utils.c
+++ b/tools/testing/selftests/liveupdate/luo_test_utils.c
@@ -20,6 +20,7 @@
 #include <sys/stat.h>
 #include <errno.h>
 #include <stdarg.h>
+#include <sys/resource.h>
 
 #include "luo_test_utils.h"
 
@@ -28,6 +29,30 @@ int luo_open_device(void)
 	return open(LUO_DEVICE, O_RDWR);
 }
 
+void luo_ensure_nofile_limit(long min_limit)
+{
+	struct rlimit hl;
+
+	if (getrlimit(RLIMIT_NOFILE, &hl) < 0)
+		ksft_exit_fail_msg("getrlimit failed: %s\n", strerror(errno));
+
+	if (hl.rlim_cur >= min_limit)
+		return;
+
+	hl.rlim_cur = min_limit;
+	if (hl.rlim_cur > hl.rlim_max)
+		hl.rlim_max = hl.rlim_cur;
+
+	if (setrlimit(RLIMIT_NOFILE, &hl) < 0) {
+		if (errno == EPERM) {
+			ksft_exit_skip("Insufficient privileges to set RLIMIT_NOFILE to %ld\n",
+				       hl.rlim_cur);
+		}
+		ksft_exit_fail_msg("setrlimit to %ld failed: %s\n",
+				   hl.rlim_cur, strerror(errno));
+	}
+}
+
 int luo_create_session(int luo_fd, const char *name)
 {
 	struct liveupdate_ioctl_create_session arg = { .size = sizeof(arg) };
diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.h b/tools/testing/selftests/liveupdate/luo_test_utils.h
index 90099bf49577..9174d6757a7f 100644
--- a/tools/testing/selftests/liveupdate/luo_test_utils.h
+++ b/tools/testing/selftests/liveupdate/luo_test_utils.h
@@ -26,6 +26,8 @@ int luo_create_session(int luo_fd, const char *name);
 int luo_retrieve_session(int luo_fd, const char *name);
 int luo_session_finish(int session_fd);
 
+void luo_ensure_nofile_limit(long min_limit);
+
 int create_and_preserve_memfd(int session_fd, int token, const char *data);
 int restore_and_verify_memfd(int session_fd, int token, const char *expected_data);
 
-- 
2.43.0


