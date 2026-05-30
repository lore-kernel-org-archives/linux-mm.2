Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E87BACD6E52
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 22:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 058166B00C2; Sat, 30 May 2026 18:20:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFD256B00C4; Sat, 30 May 2026 18:20:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB32E6B00C5; Sat, 30 May 2026 18:20:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B16876B00C2
	for <linux-mm@kvack.org>; Sat, 30 May 2026 18:20:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 76FE71C06B6
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:20:06 +0000 (UTC)
X-FDA: 84825505212.28.98E53EA
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id A2DBC140005
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:20:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gW2cX+KO;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780179604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zMNVhv3SnOTuZ3xqpMfMs2g7riJHPagItEAHtnUEWTI=;
	b=hlWq6SUVAMBsc+NTIa/qd/B5jdezkekkfeBmd3jGrwL0WefzRsREP91BXGQ57nv2OaYN3i
	q7cuMK9ryh+PviagULeEb4tYgqTBWdYbn875opjdDLc/REAySD70i3pIXJFT3dNGGSE0+f
	LkUPHJF5IDN4n8BSY8ODOxBTDtFPj1w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gW2cX+KO;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780179604; a=rsa-sha256;
	cv=none;
	b=UL/QfWd5FNwOC/33bW8B3DZyHX3wX38sygqlOKDBo/1ylHPXMEYaz4XerAKj1+8NegkldG
	rqqZCeEWQ0dhsJYy5b7ax0+zADNB0dKo147tFsJvp9YheTM6u9oygMBNMfrIVD+ARFDbSz
	bNiNeuDXQu8hQ3PTBwy9Rc1hNh/8ENo=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-914bbfc2464so693728385a.1
        for <linux-mm@kvack.org>; Sat, 30 May 2026 15:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780179604; x=1780784404; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zMNVhv3SnOTuZ3xqpMfMs2g7riJHPagItEAHtnUEWTI=;
        b=gW2cX+KOoMhWqhANJOr5CdYbKO7V+j88TelI0RqsD96u5nqJrzGJRxKdUleraRgQMH
         /MR7DlRQzSUi6MXg/yspeoFashj+qDVg/LEK0MkOBkNCaUyZqyQZwJhfWVvA2XccIlJw
         lX2HI3skDS707WhhvIqtfKqr6e36JedwnHL6iezYihjoAJkB0qW3KvSvrdAJaS272W2k
         nGPRStbsq86O18VnLiEXfszBCj0jdEXrrXNMFe6vAS4OwKxt7r4YsPMEh5QFfrwcIUWw
         EchIfVllzOFKRpUpdQ3YFxqYGCp6AogkjwHO3VztMddJJmSbd97/ax2t41kmjHwhm437
         Qr7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780179604; x=1780784404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zMNVhv3SnOTuZ3xqpMfMs2g7riJHPagItEAHtnUEWTI=;
        b=K8r1JaTHdwD28D7C2S9fFluElzp7iLJpbFxnHxb+e3YxoLuMZz6VtuZh6i1L2aB6/d
         UTHnlZA9VqTSJPZyLor9Kn346nOUw9C63LG3yklCMimCnIB8qu26ZORRo7ZJ9GzIPxdY
         hulQnws3lDfOVVQAOHxOZX7dymIZK2/zTBaYNMCyU7P/InxscGbCZh95HryatL34ttlk
         M/jQT2wrQdapGx3XMOhUyTISdPoy0lh1mjMvmHDbphL2aKQSGxMNkMTbCoHf+CJlACa2
         RHDhVZquzig4kvfYynFkix7FTkA/iN8/oz/g20WCv9jYaIJTPV0Y0dJ2A7uG82REZaAc
         YDIw==
X-Forwarded-Encrypted: i=1; AFNElJ/2oGPaiFop+hYZrPaJ26Px24xYeQES4pswDQfTIeuL3VszjV0/M8NNaEegVgpYf0j0jo5/ZFsuUA==@kvack.org
X-Gm-Message-State: AOJu0YwjNmsDB0pRB2mnUPEOwThyWbcFEk/nmBPQrIXjZMqsM1QA/j/E
	tl5AJ2FpJSO/rbibOViYJ0i0CFfpRt6gOLe7SS6lWqResHaLlTwb/C+STYIMxM4cpkk=
X-Gm-Gg: Acq92OGzyIlLAvzB7u1cwSuuEvsoY7gNU6pbcmgjCRwoo7QQBE0ekhttyqOYmlQ3XRx
	SS7lZqmgAH47EBMcNxCTZvSTbf/aVLBv84FvXW3lx5DyB0JE2X7e/n7LgAPJ4AhdWWMyyaAV1Ns
	rKDu0LK0Opxxq7QtQsdYm/LICANLs3svNe2tFbSY/zmO9g1Jtp9LeWsh9Uf8hEX0j5txKD4TB55
	f8StA0JYOTZ8SPBHBF8LHPMa0VRX7MZS6C36RB5NdR0kUi5BCgHM5GfoSSm/6O8NoT4FWwYOten
	QVithZ7amtP5j5mcS8NkeIPh/wL3SGbqhirZFVce1x8Ai+DTxor/bVPnM0deRuJ8qp10TJYlQPw
	XWdqiTCPE28TFmwwqMLIS59XRT5QvRd8HYvb7D14tsTAZbWItPddHrE42pJ2O+TXQsXmF/aLSXI
	6UMlAGiU682us7mB0/ftqeMk3APsPuYuWQQ45NyF2NJGawqppBirZx6uOvqHlekw==
X-Received: by 2002:a05:620a:178e:b0:912:67ca:bac6 with SMTP id af79cd13be357-9153d98adc6mr770549985a.26.1780179603772;
        Sat, 30 May 2026 15:20:03 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-915324868a0sm651790085a.18.2026.05.30.15.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 15:20:03 -0700 (PDT)
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
Subject: [PATCH v4 12/13] selftests/liveupdate: Add stress-sessions kexec test
Date: Sat, 30 May 2026 22:19:37 +0000
Message-ID: <20260530221938.115978-13-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530221938.115978-1-pasha.tatashin@soleen.com>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A2DBC140005
X-Stat-Signature: eoutx16zuyqhuo8ph76fbtmabp8j4grh
X-HE-Tag: 1780179604-100637
X-HE-Meta: U2FsdGVkX1/0sdLBv7Dkeue384GinniI14xjgmKOXWmVnVe74P76ieeozhGxmgifeKrCo5sGD9KsSlGiE1F3jcOwZBobyg041QflhCkZ3mP0nhRJUsAzxX2hyWXZVl/qIr90EgUWEUe5/OSTEPERf9INVtuGXg5Hw4iZ4KYIq2kyrjhjEW5IzsgrHyrBcWSigxam05LqPnzLX/M3y/87g6V0ILluDHiWyE7WT1WrGUJzU6ZqBqTu0lFJrbBV+DF8xa6tLtTgnY/BElqwd8l7wMYVsi0m5HhN9k2sq9YHSgWCLnyz5hunojMTxTVqNm05+SASeJW/Tr/TW2NNLTzpxXZKrd2sxaWQZ8t7Y4pk5RnUQZjFWcQSsvyNl1ic5uGU0SAZWenf/kFUadL2w16pvygLqqdebG9wIq9qtTnKhUn5SL0T/iXiRbfuaz4nOV/NghCaL0IhsG9fwGnvWQSCMhcS9WDJr63hmEJT/nprNC5syp0TJlRPVJ6fuJVDTMtkKDs0OWmgk0Rk1ftph0EuNRuYi+g+cnqTtptNv3AelqXLsSg6MdfJiErICKxAtvf1ZB2QWpZ8CruglgEr45Qe+sk5nwoE7E8U0c7vkqkYe+Kkks6RWGsmOaMnn9JP5bV3eGRLkDNHJf9leuDHyFUscPgiYCdzxw3MTb9GGmSvHkx8tQ1+QcuWyle5blJXudFmE+nJs8IAYHxeAr87z+k4KC0wWWvDa0EPG6pUcdu3xaMayGNy5JhoGlou8Xzs1Qwfn0Skjxd8cy4ZxRfr3yCQro+rHB9DbUIWio6JCJ9Gjiw45kPhpyiGZtS3pFxza0CkKDwlBS1zTDr2HmiVT+Hk1+iKp7zbMyfewQIpvmuBkQfMBup1z3tTsL5i1Y1nTgURkWxp5iUfnYJ6aIYuGLYVBcqEW5u3afKak6UjqnNnDQkZVYojT/FWG8+23WIh5ReAuYGUpDMXBMpS+zw4LSQ
 XrV1gO0E
 rwfmMTrTqN5g1H9cPVN2O1GELP2nM7rJjj+FJ5BvfYez+HASUFwrC+NCMMNo0clzgdkuIK7cG/n37LOsIWVntT094XxcPkfHwk0ufQB15y+m925Wja13z6LND78Du6ZDA9+M2BMIFu/w37Bi1ICXgoGZfvuS2EqZbtH0+/h1q/4+UNGZgzVUaX09C1pJVBKY2FnoJPQdTmxk4CiDzx5F7HJFo7L258Edqt4bpj6trY1sIhrUzz+tpySSuDGVX7GsKbtwTEd11yEbO6zhI3nwy4o8/3WbPQ+YXJjwSxuvWFMePE58d+jV18yVmVhT75EJyPUdZVHWv32YVLXrPQKC8NOoDrp3t7st+YqKQ
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


