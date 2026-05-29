Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C75ADCD6E4E
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 03:21:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA1206B00A0; Thu, 28 May 2026 23:21:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B040E6B00A1; Thu, 28 May 2026 23:21:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CBAB6B00A2; Thu, 28 May 2026 23:21:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8DFD46B00A0
	for <linux-mm@kvack.org>; Thu, 28 May 2026 23:21:24 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5CE0E1A1103
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:21:24 +0000 (UTC)
X-FDA: 84819006888.09.9121966
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf25.hostedemail.com (Postfix) with ESMTP id 936E4A000D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:21:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MXAWCdSw;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780024882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zMNVhv3SnOTuZ3xqpMfMs2g7riJHPagItEAHtnUEWTI=;
	b=ALR+Tdp0OexL01dCGW4jpIJbkqVocAK1doak5S4PmQa6gYs7NEB1ZWqGRvl9TjZCB2Jhbx
	B67VAaBsX+xQIixovSA8LdfjXBnrVE7usz5CKCNb2KoCUYrp8hGD9S2HixJRHdpd/ldzzH
	RcbDwg0ruz/X6RcE++jSVdIZGOVp3PE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MXAWCdSw;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780024882; a=rsa-sha256;
	cv=none;
	b=3WwAnZjTsCwP/SWJNOy+yexNMp2hyzN6lZCT0gBf9X3CyWJSdUHciO/I6eM5n3ny6/RUkT
	QJ4DJtoMJMerTu7slGLW24TL2q7jAebXmwwjId+vGUEC5G73NHPBPD6V6HzodfNp+0GYc3
	xYs0lWPBQUZDoTbGgIrij1nsxC3DKB0=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8ccda0ac4fcso11842566d6.2
        for <linux-mm@kvack.org>; Thu, 28 May 2026 20:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780024882; x=1780629682; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zMNVhv3SnOTuZ3xqpMfMs2g7riJHPagItEAHtnUEWTI=;
        b=MXAWCdSwARtwsbco0HyWvqN9A9dMaofsqsbHvav+Az33bAVKWnt+t7ZP2vrJZPBHh3
         uLHPYc4O592p3r12av9l9O6XVGN8XYiboXyjZ8W48uKOLGapOdmf/fSBQIL4ThvA3Osu
         uvqBp+nxp8jvuMcwZCsIYJtxyyqdZRJ61X2n0gfqqQu5+/VR8RDr3b2Q3zP/kxi6hveA
         o7JTVNj38xUqh/U/bB59/hGKHEC8YloeKr0LjKN1LO7nXkT2PE3nwHxRaVMtggHdj9St
         KUAK86800WeOId9+sPbNlW1VwsLHhgi0MEJyMrCPZOGqlARwEZpWXdJ6esMWmnzLaql9
         txIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780024882; x=1780629682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zMNVhv3SnOTuZ3xqpMfMs2g7riJHPagItEAHtnUEWTI=;
        b=sUY/Fl5fHN/bf1HtQIRwUZVjXph9tgwGTRMUruBvtiEvsdXmOwEHfYzCKoWdy2xi49
         E5cpRoGKHMmTDkD8Oo359fkLgdagNbYViex0PRwGJ6dH/74XfNYAGjy1KlQehrM+Hrnu
         n0d6eJVHgMfl3BkL5mEKuBy6KiwEnXuULVdm5Pe+O1+0h0iDaBU9tSKvWZlu9gm9egXJ
         96T410Q6fpq4Avke4TIFNcb1ZnK+dhBkbb5ejGuswSkcX2edVuIj2MtL9hhhtOR1spV0
         hHD97n6ANRkY4WnVg/wDrVoGafTkA3vYkqtLDQx85xg5qd053znbfTl8XhYHItJFnDuj
         tv4A==
X-Forwarded-Encrypted: i=1; AFNElJ8dsfEaq30luKHo9sVfVueUe8hZS1OH5F7MqIu8SyVT3rSL4Rw3u8BTrCU/MuiC1sFB+ARfB7RM4Q==@kvack.org
X-Gm-Message-State: AOJu0Ywib6VwcZgGjDuaG0F4FvwRZgPurkHfyj5Z6MlJ5P7auVTh51fp
	GFsNFGECwF41HI5L+6a+JYz+0G3GRnMDI4IfhiDHdf8sn7v6LwYJjCE1KGVEj4ZN/P4=
X-Gm-Gg: Acq92OEmttZxK1ZEhoIxhcxou3T/OmqORazTkMMXlTH1Sm3EEG3RvL5sYJVSwI4R4I2
	RMdniOvtMMj2ihane1g/Cy+pxbRACxO3cYw4FgXvd4oc7ggmaPVdlnT0F4fSFtimltWRSjncTgh
	yu0gXbzfMy9jyXxCyP5R2dvg1BCUpF+jVDNnG/i9H7H0ruPAo9q/1Hy9+jK6tqIxJVK/NALtCzy
	90zYIsyxdljkmT6qTA6+8yyLWcHAdHwnYcT8PjNPUnsgUbhSYU8tmLzmPETtcoZp4ARlCZDZhU/
	/jydoUl/xqubeaqXKxmKgZviQTjVcpAUNc/qQkONatMjc+qGn/9Jld3wErlwp1ioHphMxMywTHL
	y99ly4/31RJpNJWvhI4JO1+JMsUf5ej23B4wQmRRUcroU3xwoQeEaAY4A9FI4y/qP2tXXsCOk0y
	8+7v4YwzlNrrUv0DdLUMpF3RwA7t1bBXSoiERneWtZ1Hnx1KecTwrJd0h4EFny7Q==
X-Received: by 2002:a05:6214:518b:b0:8ca:deb:3f9f with SMTP id 6a1803df08f44-8cce82412d1mr11698806d6.34.1780024881756;
        Thu, 28 May 2026 20:21:21 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ccea26d286sm1179476d6.48.2026.05.28.20.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 20:21:21 -0700 (PDT)
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
Subject: [PATCH v3 10/11] selftests/liveupdate: Add stress-sessions kexec test
Date: Fri, 29 May 2026 03:21:05 +0000
Message-ID: <20260529032106.1505796-11-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260529032106.1505796-1-pasha.tatashin@soleen.com>
References: <20260529032106.1505796-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 936E4A000D
X-Stat-Signature: a687wiaqixzp3zzq5ex6zo9jf77yxgpy
X-Rspam-User: 
X-HE-Tag: 1780024882-988145
X-HE-Meta: U2FsdGVkX1/VsgDqRViuMsiLGRuGx76jziuQo1uMVEQUSPDKFzfQtbd8Gd3bYBUI6zeEKkdf1TQ19xFvbWoSxuR9secDcmvtIRUFSZN5eASKWH/AQjNDmgb38NWgO73S7QRdywSeeFQe1wBCkSExo1vDFx2h7ryi1+deVUrusyox3QlbXOotUAB7svBnbZjVCY1kA5EsjcBuJ1tYu+ptqgDIQZtUXDsYeIvG31FYOiUr77IPTqiq++4sErqG4CWdHmSBdslISlk9RodCiRCA6mnekhYlB17ZJMHYbvEQhr1GUSeth4k/S315rmSGGTRqfqFUxEKatbsCm2pgGRfBT1GXZdpolDuHTRxPX+8exUgkLMGkVB8ooziiJKH3cCsWaHGZVNnNRzu1rFiHz3LEi1CIysE8KL2iWbEyTAStXSCsjMbVKzXw+0eDRAu7ggk/oyWDJG92is0LrJ23yH1ih5j2tXfKIAbj0/oOwNO/pyTlazWS2k44ZMykXEMcIY5FZ2im6k0wjed0k3AaI9BfuE/x64HOAGSbvkkZyT2DwxceJWrmnP1TogNhESvMI4Zoux6Uol0iik0u86mAlM5eM9qKKjGwH7ZexPLAKkPOc4YAqXG0A6tglgh0lRnvQUWgtdww0KReyrhQ+mhVwZjhfPxGdtMUd1ZxZ8gCY5HZJtrkTXhyl84khfISEHl08dkECKgRVF2JVNnaCP7QM2GdesjkbQaAhUFhvTkosu+gF4elB4Hw1lSxqUmqubgihsidGwTTF4e75UCFFykGfDUY/XmykrNQwSA1VFSV/vwewk9WM0wimc/I7lWcKB8hZkUQNEcdDdTzRSDfnm0clvNY4WL2SjPjj0HUOZUzMnZrUoxOEGHUIPZ1zzqo3PCPVhLP03rY3pIbqTB6i0XQXioRuHKLDzKOtwsUYUHq8I3wqYe6cbWvjEBwYzg/yrX+3SFHeIAuQo1qq19OpFcctSi
 RkHkgIZT
 x1Slo01b2KFwEFhvpA25JRTtc9W7cnYfi4CZrJN3PH8UhNIDh1zibEk9ZFJjCn4AoCGboX5+h/tDkApSu3rgDy5b52b8pVERDlAqi9+DbM0PxNeO7E8gJC9ENMQoO0KEqDNF9xNWXuxh1rYqGCOIMQXa0KjrfQjKiWIy+nJPoImfQSGKsgft4atpg+VsaZ1GRgqvsF3R+KtxOGhuIQI60H/AwxS1RBxNdGWoNxIAP+i64rG6YfklmDx1mz2ALIRf0kS+3p9VfruUheXX4pM4LpwBUejsWp2qUX/JL7qRlr8aA/OX668xhxpcWMlFuOTthbQ3cY8nUCimoh4OVXsO4UKWHlII5p3xwFR13
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


