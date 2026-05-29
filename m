Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27268CD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 03:21:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 142046B00A1; Thu, 28 May 2026 23:21:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CB6A6B00A2; Thu, 28 May 2026 23:21:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E861D6B00A3; Thu, 28 May 2026 23:21:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D4FB16B00A1
	for <linux-mm@kvack.org>; Thu, 28 May 2026 23:21:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 86B66162ED7
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:21:26 +0000 (UTC)
X-FDA: 84819006972.22.A9A1CCF
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf03.hostedemail.com (Postfix) with ESMTP id BCD4820004
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:21:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fcdJCZJS;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780024884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DD7mpkHwGkKw+XnhrMPNwFwDdntpab6EeONlinrdH5M=;
	b=o7JrNI3dknfg9rv6xkEi/Ncdcqm80v+r85X1kbp+orXJVHE71pA/t3iYRKCFoxKCNMAqds
	/fYhSsJYGZ6uqlnwk1aGiq+HaSeopQ0QSyYZ0pdOcHR4QhMA/tGroMWxzcapx70mvL6GTl
	Tl2NYSJIXv5B6J4HeW4i3T3o6gnZkHg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fcdJCZJS;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780024884; a=rsa-sha256;
	cv=none;
	b=4EkQtgfDFnpdm5YB19oRgTJdGSXRfyQLqotORKbNXPnNSJn4YWiHKOF9dlKrlQ488uetnU
	9MJ9UTUdwqNUAs4iu5ZWUQn0xyMe/yFEThc7H7Qm9S2Rx1BzJO0QNo/yK6hhv7X96G6/YP
	I08WZNx7A3DZOABcIN1oKFfn0nKCswU=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-9106ea78cd8so2044178285a.3
        for <linux-mm@kvack.org>; Thu, 28 May 2026 20:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780024884; x=1780629684; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DD7mpkHwGkKw+XnhrMPNwFwDdntpab6EeONlinrdH5M=;
        b=fcdJCZJSlmBCOFOhCEOm3vRc47fFoRPB+nQCUZVRy3pH5F4qL1+o6YIlrmdmX0QtOk
         n60dpDmEQ3UfjuaG+L/0t81Et+Dr72xyjin0bVNE/Kwa9TuJatQeuLzpmG8M0DrtWyIe
         9vf8/NsQCaTEXYa4O3fRrzPu0c1Coy/+Hw/ToGI/O12Onzi43hTPENhxyAA7VljzMKel
         EwOgwtWYO6O0g6EClRbaqbQh0gMJq33jCuxKHwbfu4KO9P60kLKzZpmZQsdYNt/UPUS7
         KzKeV8Tc/qtBcj3amUnqxQHutHsE9liiiXayWf+rdE0PfK7qJw8D0ABRdUCYF7dvb7GJ
         nlGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780024884; x=1780629684;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DD7mpkHwGkKw+XnhrMPNwFwDdntpab6EeONlinrdH5M=;
        b=oFJp5p1piIjdSO7wZL2S1bryL8EL/bdbZSIXF4DJePJnrVnG+/MouUrMMAavk2fDWf
         aMUMCwgz/WOyooH5iBWjFNPccEXWYpf04AgcHezWk68EYQy8/3F8ic1up1mRgehTPRbg
         wHqTz5R8oCqbaXfumzDIqEe1B4w6p0uw0+y2Mp2/4iI40SuEbj7FiGPIBMPdjb24HBGo
         zyM19ePdejuagl+Dtwzo196JrBsF7pkwn+RGhTp6NaqAgh9xH44Z0DotfGZca1pWYWQn
         j2odrZgUgxJEB2b3bLO1Ej4WeQqGH2eUhiqcoj0eCHJn8doxY6hISDegZXQYoLb6ASxl
         VmAA==
X-Forwarded-Encrypted: i=1; AFNElJ+SJsWK1CBTDKB6CAYGSj1OF7QxzmY+etmA98Sz2Ds6g5ZCS4t06ilnxNJ8t89EWfAEyTkyOnh4BQ==@kvack.org
X-Gm-Message-State: AOJu0YxPqHcCwlH6PVKD0xaQksf/JLNrdhr8pwLYPjFIRPKpOokWiyAy
	43tcc0PFiJASGu1WEJdqHWh0cO+I7SM7WQ/eKLte/Dp+WBm80ec0FtuMr2D0pNZOBOs=
X-Gm-Gg: Acq92OFotjCPf5vcxQK42y2U4MfZqnD3HiRzghJ1mXh6/4VTxHmULup2ND4oh85I4Nl
	4zcYHSLRBTTFzfFK1N4uhIZmhryImJdCyLmrt6j4j2njJN0CGx2y3QAQ+cM90F/yOzl2Op+6Lbm
	csxd2vRjY3HpWkGj4+as9fi1mRhvaLVVPRATW3GWwH4irWg5KD0DaqFUgljuhzmyuJ0lwiCKFIV
	ZMcKQTlTG41wcUZul4LaxCQ1lbyszNx4K8FLrnjSQGFqzbq4qbtJGjtFyUgxTjWOUsObCsjchmt
	dbFdLaR2kHBr/cv9eS+1mpIm00SVa5xAr8A+1m+ZzSCPFNItY+oUF+T9qEb7ckmXg8o5eW9ErGf
	/mQWIFciab8dZADhwCdceEOxU0iPln47c3kJ4NmDjyWnHhHNY7/+NlbkHt5Cud9Q4jOJa9f3L3R
	9A5NdlySYA5Entv+HyGQLtowkq/716BPyzlLLcfgj/MJwWOZXnatVNgSdRWEYZEw==
X-Received: by 2002:a05:620a:4709:b0:914:bb8e:915b with SMTP id af79cd13be357-9152fd2fc49mr147943985a.21.1780024883867;
        Thu, 28 May 2026 20:21:23 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ccea26d286sm1179476d6.48.2026.05.28.20.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 20:21:22 -0700 (PDT)
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
Subject: [PATCH v3 11/11] selftests/liveupdate: Add stress-files kexec test
Date: Fri, 29 May 2026 03:21:06 +0000
Message-ID: <20260529032106.1505796-12-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260529032106.1505796-1-pasha.tatashin@soleen.com>
References: <20260529032106.1505796-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7n5riatoh7uc59a9jawjfcagrtdubzst
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BCD4820004
X-HE-Tag: 1780024884-687202
X-HE-Meta: U2FsdGVkX1/1OgKqeFVfZxMAVw2hJRwmmMJzViOdvfaONdG2SRb9JSZAP2+Cbf/4I+9H5UnDgGIn1W3WZUHMEtilv2aPDREHNXiTphbGnE0szqC76ksYmP7fPDuTIQbZ6gi8s6EVmEPHecaMcdtQVAh4t+rv/CFMjHXWDaf8CVP6mLYbXIRe+/jTqWKssk3aV6Rwpd138O6PmAjlOKtTi4RFNlLiYxcVWyh03mVHEpXMSBYtHJhQ6M/BgnM49W1FBsGUwPTNvGbrMrhBWB4JYBq2tV2mcgn9P0Fr4wDFwBTCFE+Q6r8PZSs5lwgUD3lqXodBKjVEHFCqxZiLXLbaE59SkM/r0Bkb+Xr2lxXEdMkmG0FV111gdqhTCHc06WMYXGFxuRa6VwGizRFt/MF7tVnZ0lqwekpjFQGfiFqWesw89H0wdwCEc8v1yLfXborzDctyWbERNC4PoEo9X6WOd+h/f7SyWMOR1bs2Ptk6NFLp7nJHZ2XjFAtlNqPDkylnPmzTkyxEvJ//a22RGfc/mTaTbDFoII0pXi3NIAv7xX0IXrmUpVscWTLnuk94NrDK3CNv52xbUHjAHyUPuJgrtvxxzlzDtjNqkSMHAZK9f4Lc0qIDHVsFaiWQOxsk8m/SxXwgkNCLAsCMB90KnykPOasWTvIMnWsT6k6LOlofQeTvqFs7kYdFOk/Njh+ztpuel+Og/d/U1YMJOI/0y3vc1Bm+dYAJJCFEW6flv5VcjIYVeu3rKHB2WCRcZmSMYbH4UfJuOjPkr5KssnP9yYUiGU9lcwHyKnZq3ZNjyhxLA0MojI7NTOJTLf0GsQDZHaM2Ucmg5wWPYko3oBikmrQtqwa9N+GhI5ciwm9T8mnf1InJhNoqLgAC/zkJl7aMVmqpCY3ciAxNeIgr/lRKMXEoMnb7eIfky59edLv55YjKKA/OWs3H1hnH3yes82ILDte/IjYY9oBLuXJ+8IR7Emz
 ERTHTdfF
 e24ClJfe+6/vXe0APTECLF80Vdzbe5zxQCsfNrDFuBong++GNi1evGnC57bwFsAK6sQ38HsBY/kMQM8Vzbw7UU2cGF2dM9mpY3nw7torUT6acgKkflfUkLPBIeX07x3RyZAX8sPTwu4jzhY8OkaKYzydXcjSYZ+tMkaQea/kIOikGVxWTGfByjZ0cp9yzAbkD48zfiwXLNvfGiS7SmY6uY219fwIRuGkLofUXJhkcZpoIpglYEMXQPs0uG/FWmOF+uMQcHxvqRUSHAeet0nQbdKTdCsFt6ohhzCQSqiRNo0h0B6+AR1SOinUBxxbSv7Ln/eCDoUA5dFQ4XaoU6RgzQMNhigbPsBbBl3uYZg6RRvshUwW34bKe3B/zkPRtBCEOOoED688Zxt1cfWxaIhs5uiR4nV2COLovDOEM/vZahctTdQrBVTisUoT/nA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new luo_stress_files kexec test that verifies preserving and
retrieving 500 files across a kexec reboot.

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
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


