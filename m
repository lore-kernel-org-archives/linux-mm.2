Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D0AACD6E56
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 03:29:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7766D6B00A1; Tue,  2 Jun 2026 23:29:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 727C86B00A2; Tue,  2 Jun 2026 23:29:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 617C86B00A3; Tue,  2 Jun 2026 23:29:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E3206B00A1
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:29:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 19FED1401F3
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:29:27 +0000 (UTC)
X-FDA: 84837171174.14.3B3E71F
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf14.hostedemail.com (Postfix) with ESMTP id 52C5A100009
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:29:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QGAtQz26;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780457365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=psMAwGaqe9xuyJY3Mn283ARVP/GQQXmgr+1HpWpGRKs=;
	b=u47dwwfDX61x5/O/1h5G6yT8e5tK8j49D8Jv6//+iBwPEZ9iSvcOWBIBjw5+RAA8K+hd9N
	l4F9UZdwKMwfx9VCKODqCFKaPAOZXL7/1gCK1kixFahKaABmQE32EFU8Zi0wVp63CkkRE4
	CXg5+fm7XJ8CUYgxAKzo0Vi6BjABQHU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QGAtQz26;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780457365;
	b=haIKcYnRN/dBFm6GhKUPmJANcfEeS6a/J0jWuVJ7bO9iRUnHHSlVBlDgJJ82TvPspxbSp+
	2PMk82xvMkDGAu3++DivYt3Qs+S8aBQ8veAJQUOt8AUdmxjA6ihwlMzig3KBgxjH9Xmles
	Vwb4wYwc0IKb0oLWnRZzQVMjtS5Uizk=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8cce26ee1e9so82146506d6.2
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 20:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780457364; x=1781062164; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=psMAwGaqe9xuyJY3Mn283ARVP/GQQXmgr+1HpWpGRKs=;
        b=QGAtQz26dKUsfV0LAOlO0rM6wqpKJFHtZHYD35ORmmMrcq/kRR7SoGqh62JvZ9HJuS
         ZVUDkkZDHX8Ns17uogLt2D9v1MEdltS55E+/EK7AEiqAcQ6VROqUC5PBU69rFDJnxNlB
         mIQPG1guWrFdRM7wmeK///0V2+ygb1/ygHUGY6h3zPpKY3EHRzGPxEoQNfRg54Q+LEBm
         8IvfqlD6XPY/rA3O+590VXe12GsyGgUNSr2S/DFNLhhWgqCQAKJXHMEsdPCiC0+i8nLl
         Eo8/JhFnJxA/UEmeWlfkAHvSV2pGcHVwcAOIfC9kW0xaVQlLtijeJR5wfS46s2LBNcXh
         WDbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780457364; x=1781062164;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=psMAwGaqe9xuyJY3Mn283ARVP/GQQXmgr+1HpWpGRKs=;
        b=Rc7FXQ6lBph7SCH30WAbMARPU7mu10lbPSCEyaZYmWjkOK3V1hxYvWClTFR0R+KQvv
         q57oFaqhq81QFrHOLBxw7Ktv0QwKsTrX7qOit9NllqWBzBtdNKkjfV2Jy79OKoQNKkp0
         3HKqewMssyAZnJ9KRVX4OUU5gMKe9Ao5LgGj0UXRYQgkHBLmhRBTVgOLcx7e5Fc892Cu
         ZgGoo39TCCgVQ+W9kl+/fQZTL+PgOxeLnS1JPpCDj7UtlhcjFpLEccNOP7TTJlLBcShL
         3VhRLpUNfRsMqN8IyCSOgvKAOvwqfPDZ7s0Rlsrmlw5oycE7owO4F5tN31eSMkezLYAc
         5DFg==
X-Forwarded-Encrypted: i=1; AFNElJ/LM6iPlJIpGXJAEr8UY7hSqYKxjdwVmpFkJ9fK8Q4WcQTxjD6hNLnqXZlnFOU2VBqlQWMlvxj8Kg==@kvack.org
X-Gm-Message-State: AOJu0YzRuSUK+mj9ldQ0v/vD+n/QB5mIySG8SCvXz+E2S6ezwXfR18KN
	WEM1MQY+O0mvCuhx+KvTAlndh9U6kTN3pMasg9oJyQnfQU2M8G9vkFkb9ElyR2QXDu8=
X-Gm-Gg: Acq92OGho7w2TaBA37GzeDSKQSJ3BrId/mUAKtkyzLIqbCPLeTPYdr4N/IqZz4tHsHA
	hvdcYLmQmrDmIxtMfBdEJQhpuUqXcclxhckaS+2bjAk3jDI78kd6pd2c2X3GNTzitvOSqdBT5ko
	WBH+oJhbJHcu8Q0UrXim5f+0gr7MpARpOXRLGWvH/gt0k3irAF3Cja7ypM7vzDt+FF+3fSzxE2u
	vqZ4iBFFSvY+8M0gjEuRBRt7wBP43l0HsLWakt/HHkKncD04CxfshSBhuq9vrMyn3dAJEqMpVu7
	/gvI36OfV3DkAtaLx47m0asQUVBwPisHrJdEcFmkNr9EQSg2879etS2kc9TQix5r44rdk6yvxzI
	shBU4cQJOKpW191DgHoN92X2lLaFHITvdW6o/SGwYQdW+90WXPUZCSw32clUreH7icbFBbFjJiJ
	/BKUkqVVmJCptc0wnBzaP2YwUoBu0lAcRo0owHNO69lpnNtpg062Wjs4bRbj6hkNq70aM7bXi/
X-Received: by 2002:ad4:5044:0:b0:8bd:59a6:4165 with SMTP id 6a1803df08f44-8cecdc04bc1mr16915496d6.4.1780457364532;
        Tue, 02 Jun 2026 20:29:24 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd26b3b9sm9244566d6.45.2026.06.02.20.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 20:29:23 -0700 (PDT)
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
Subject: [PATCH v6 12/13] selftests/liveupdate: Add stress-sessions kexec test
Date: Wed,  3 Jun 2026 03:29:03 +0000
Message-ID: <20260603032905.344462-13-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603032905.344462-1-pasha.tatashin@soleen.com>
References: <20260603032905.344462-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 52C5A100009
X-Stat-Signature: mmwkoyxfziom9xemebrw34wfbdp3tr1p
X-Rspam-User: 
X-HE-Tag: 1780457365-733922
X-HE-Meta: U2FsdGVkX1/esYbtMZlHydVBJ8AKIH1WTOYRrIH2rLWdFpo4OpQ/OeDijXyq4P5p+k6E38vV5HAkwRPRGs17jYSYMpb5FVskZrEtDVB1bA7khD/yar63DFMlPX5ORDoYObqAlZN8bycUOy4SP4NvjoP77oeSta3N+53UpX1ndEK3XKlYcLOCVXIGPg0HDVBIhr0ZN02+DYehd/g0Dr1sejBxD8oeJw8/o8/b2v6hwcWReFB/Oa7W1FiCmgdmwImI7Gv/J2aElLNLsjRVZ/TQhCiwoUQifCy+iP9/gXCTiR20iljcRnB34UbFCoHjmvNJZzlIljlvrwrfrBWhWSuNTXHnGTEranh7vv4104ALKPO+8FyK2AsI0UJ0kO3b82ilyLWtkQv2TA9Xagt8JFTEZ6gIgi70su8xa6L/uQr9Vfjh7QjbRzZQ5OPIUyEUvsCEDxthrMYTbGcbt0yL5xoYJAZXE04jTPvXAOujL9N2VWLLCY2oPCJmEFEucdFVO2MNRJx5RvMP9uxsk62FO67Cg4s1Gmy2ZzGo1P1Otp/NC3SrNgefZGEKHvnMEb6+6nXWzIqrsS1SsXITc7sDdif6jhUSNw8mJSHWK3hd4+RMN5OyDdYcaJpPRln1Ef1DdMQCiJTPGOMNn39OsjAhVrUeggh+I+90oI6Ku3QofS4Uf/LnwJxzjbzkhcI3Fd/UBjXAifZB4yjvwyUyfvAqO7Xj32+uCWvh017UgXMtpc5kJd6aPBxLykDaU0EBgvziK9/gyInF9bua3gu3bTKtFHu12mzWj0Cpuza2ECmZdAt9VLGxecU36wnaiWntGOG1RYakICoZFtb3YRydfAyEDRmd13Gt9R3tG/j+wEllxr6IvINqVjtogdf9CU9OROtLgtNnsd6uzfDv6f6Lg4bNHOhFuJoS99W7tOP5YABf3P4OVnrRpiQP6pmisRjeWcgtS28lZTMwqr6qqv6t7WHbF+S
 fh132yZQ
 O8Ez0xlahCXa6Z+j6998XmiuPjJVi6Mp/gpwYUdJg1dtag4OwFQ2y2VE/9xnJgZi/7kiD77vWtXYODEIrNulVvwJPi3jRKCh9sLPixAcJDCO1VOQTdqP/P8R8HM1wILj5mSHO95baIht0sXEd0QiMeO3+InZQrGgxm1O0sg0We+/jM174co6ONhceg9cFvf7GJfVd1q8zFI3EKSwTKlMG30AN5p7jW4M7PxKVidrPP5vxP1pAs8va3vtw2DkZSEBPIBmb6hEDyrvtrUCEak2jiSQZbcnCbp4zuuNCk9nrSEzVU3zyxnUXN1RpdEVH73tuP7nr3/LF3kB7LFbeTi5HMcaJg5ZnbPIDHowy
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

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 tools/testing/selftests/liveupdate/Makefile   |   1 +
 .../liveupdate/luo_stress_sessions.c          | 102 ++++++++++++++++++
 2 files changed, 103 insertions(+)
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
index 000000000000..f201b1839d1d
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_stress_sessions.c
@@ -0,0 +1,102 @@
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
+	int ret, i;
+
+	ksft_print_msg("[STAGE 1] Increasing ulimit for open files...\n");
+	ret = luo_ensure_nofile_limit(NUM_SESSIONS);
+	if (ret == -EPERM)
+		ksft_exit_skip("Insufficient privileges to set RLIMIT_NOFILE\n");
+	if (ret < 0)
+		ksft_exit_fail_msg("luo_ensure_nofile_limit failed: %s\n", strerror(-ret));
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
-- 
2.53.0


