Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6C93CD5BD0
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 22:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6B4D6B00C4; Sat, 30 May 2026 18:20:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1C216B00C6; Sat, 30 May 2026 18:20:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BBA26B00C7; Sat, 30 May 2026 18:20:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75A4A6B00C4
	for <linux-mm@kvack.org>; Sat, 30 May 2026 18:20:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3774E4040A
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:20:08 +0000 (UTC)
X-FDA: 84825505296.30.8FF6B7C
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7197520004
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:20:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=U5U61tLv;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780179606; a=rsa-sha256;
	cv=none;
	b=smuKl9jxeP1EkyBGgRAhmhakhFfZ9qHe3GrN/rR08cn348Zt2uwnE3cPiu9qWuk0jovJ+J
	aQoff4pkheIhpgGEinj2TZdpOi/mc5XSA6b1dhv0AhTWo7oUXYhgdNVq4hpQyVCmjkaogO
	cS10A7VWcXubgVOLK5gRK/gIdZ4zMNU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=U5U61tLv;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780179606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZ44uuKaEudMkx03Nujcoh6Uuv+6Qpcd4aVYSw8wkq4=;
	b=NyDFOwSPknTHBEPCSYsc7sQSdMlUoEcS1Lt8vkcZwe56BNeyzLI2WtwiMnF5nqH3thvucI
	4AW/CMfJMrRI8hzkl7i7Hk37k+vrnMhH13keVllPCd1CqWovkb/0/QcmRkPJCtuSyeWbCC
	nftRi3tsXGENuuQDNnPiYD3qMSTcqYY=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-914bfa75911so948821285a.1
        for <linux-mm@kvack.org>; Sat, 30 May 2026 15:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780179605; x=1780784405; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LZ44uuKaEudMkx03Nujcoh6Uuv+6Qpcd4aVYSw8wkq4=;
        b=U5U61tLv66Rq2ayDqIdBWZBCTZnZw9hWR4eCGhVMithlR2M4R6PT1ocMadTJS3mnsB
         8s1u6Vi12A/rpl4mKysHBsKpE9Wefld/vbklIVaRzzFu6VmCXZ98hvBNs0zmby8iXlrT
         go3a3lR30gJ4S4Vriv0tH5HMKHRkEmI2dlK/VRxhHngCpa56iqM7RfMg612MaQFamtAb
         nA5snHRzGEHEoZrOZ+4YyrpZTqRXCeO/HQPFbCPRSJP9bWAYN635s3qbA0BzmW48pdxV
         VGN//vIX9qfPkwT+RyC0HOwgC9JSzvZVfmMU7KD8PnHoLt+wQMm3FhvnKvKEu7o5/ul5
         PyOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780179605; x=1780784405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LZ44uuKaEudMkx03Nujcoh6Uuv+6Qpcd4aVYSw8wkq4=;
        b=bjnqdjiJrY1WZzOTUP9eKIIlnmHuUoBx8UPhoZbi8qy4RT4wbwknF5idwkVeiKqNck
         3zaI8k4oe3PDcDXca6SHO+Xdwrnb3GhBMkCSS4wbmUu3XHWYKWqlZZ8ndbc50N+msqYy
         RJWHTWyqeXoBiNsBqPcScH9E+52Mxi6fkP1PdGKSNS31YsIo5ENJmgWGXEdUKDXcewuh
         NgrM0dfN7vAUxf+mScCRDmQeaViqhIo929+jN1ZlHXt+a1d1c76AGmBScZZ3UunyGhHN
         yacWvURV5W7xr0sMyvQDoRu7+lXtmZd9PcFC30H6VmQNzaI2688tJ+1Yp8kRsYUj4Q/x
         NzWQ==
X-Forwarded-Encrypted: i=1; AFNElJ/EG+RpUafDV+lSlwT65TxO2exo6xZXR2qgCwMfIgTC11sWILAZI9cG5IMSmPjfc+gL83Xx1C4/7Q==@kvack.org
X-Gm-Message-State: AOJu0Yzr88EZ/f/dCQPv96ohEjqTAM/inGUSpGpb5Q4J4NRSUz6I73bt
	+zBw8JeN18/RTda+NqFsQgwQf+++eX+HWMirYkM76O2ntgFeLel3dHEZmSMDIR/iQrU=
X-Gm-Gg: Acq92OGSRkfsIplDhLg+mfGD7aW0ilLD+BWsi0e6oFnvInIbJ98FwZJjdF462CQY1L0
	omNxab6lpYNI/2+r1FjoYhYjFZnH/ZtUDVDhQwIJo/e/4jsxYPLrMn/FZXqifg6i2/buAdpkGl2
	2xYBp7ELWZ1dg5sy7cm37VitlG+wZBI5bU0aLvzIAO0AywwsDF9bGqGAk5PBSEUF43Y/33+H7bw
	SrZ76/0fI+TSYCrmPUK4nkua4wIG7H502VrKZtacYh3HjdbRcFAtqpzMe+IHUfgB5hbuWJjsgcm
	Ct6BCtYdsW7QtLmpvDCqPh+Vog52af/OTd1EV1NcN9AJ/6dfw5WQxcu3wzPb1BOGfk1aAlRpq4L
	ArVWuZmnaziYurxpIIZDPGd1nGHhtAVHWT1aRLFgs58BhAqk13g/XkAfycbKT2ycHwqLELCrt5/
	wqBtz7OL8C/jrTarnoB+x02KCwZvOkR8IYrTfLbFjry7Z2KC7ytdV8hYiyipUiMw==
X-Received: by 2002:a05:620a:29d5:b0:90f:786c:4a82 with SMTP id af79cd13be357-9152fa29820mr1006065185a.39.1780179605586;
        Sat, 30 May 2026 15:20:05 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-915324868a0sm651790085a.18.2026.05.30.15.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 15:20:04 -0700 (PDT)
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
Subject: [PATCH v4 13/13] selftests/liveupdate: Add stress-files kexec test
Date: Sat, 30 May 2026 22:19:38 +0000
Message-ID: <20260530221938.115978-14-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530221938.115978-1-pasha.tatashin@soleen.com>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7197520004
X-Rspamd-Server: rspam03
X-Stat-Signature: px13zd3u3hqpb3abrx61trsafyfkj8a4
X-HE-Tag: 1780179606-575136
X-HE-Meta: U2FsdGVkX1/nFP7Byl6fLDXcSgea5O7/HgM5k191ZKmhgnSZoF6wtVeTJSO8iDzyDa1oTf6xW4BZMTur0v0R7jFJJ8U2MnRPiymbGnPKJ1Xmp2+JlkLBWue4AXi1MgqKc1RStLfuI/qSmMtoq7ksqZdjrnOs8eIruDuKEAtKZLa2cd2++M/wLsXL8FQuYKYsBJH9y7PslWhZCYPXc+B+3spd+RGbFeMwhjIU/Wgl1j5rl2Ru7taxdtOfxm/TqhP5bXJrqyCMrhYJ/CxqmlRORwbanhNE5AosaORMXhUIl8voW8OZq4lno7SGnKKX853wSm34G4VdMHs0m4OYrytgAGPGuCQzRxBp/ocZwr+IJ9D5PxJUi7vobdn3+8uLo/+D2P/XXgHggxlqyqo+cTNBzD9V+kY01sPtxSB3mSP1QvrA+gs8CKZ0TJJjjkb/u6F42W4sCC+lUGdGNO0E2Xyu0zasbvR3KlIphw3Uy2v2x1rYVDAnOSTqdngD4V1XSWeUQXyVT078Qy+9JCKgoIjDWW3mwzgY2hh6qKTC59jLz4OE/+vhgdyVw/MI/US+7Me0oaWRsZLwuID6n6mfq2TBc3AZ+aMOMM1ab7omdGQUeAmtzWiFhAlEPVuJ5K05WYIQWRTOzs8g1HYP0R3ncLCjFQTNUKkYzH2qN0inCM1r58TfgH2lWw5c26HeJ7nhzfF/wZzaNGKXLYbBoaK3tLbJa3DM40/LH8TMuV//8p+daiNmJwoTbrro0zC5DRuL7LJsD4PY/rX4dRR9QSQCPr/vLO8VZZGBYKDqehhl7bNjvFCHwCQ4w8K9dFR5Ih9BsFXB23KfEeUbisML67hFN3+lel9pXKeaJqpa7FC3aJtimW8OvVJYY8QpjO5ucb5S7QdEKDhR8Z5EVotxn/9CUq7xR48qUo3G+NU64ZK7E8Y5tfI6wK+C/4576X8AXQvFHlG9wi4HZ+Ghhu2MOGf6m+D
 OMMtN1c+
 E6+R++3vnv4oUlVdkk5dXZrHijJOs94y2pn5it3mfuY9P10EsG8gQ58N5TKz4HniLGfxp+Sxo3v9Ye2awKZfZW0lb6GswleEwNZbUPMC2nx1I7udnhaTfP8Rx3Zh9rm+CtlavfVatvMXinTED4RuBFoLTeC3YiKTbzvSv0xcW1Lsrewptydaum73TkJQyljBMvsDDTmCDNROWenROgB6oYjVZWprn0IxeGKrHNHpVw1syP5JpXATQwmK1hQCLDn5belSX8cVHrKu9ZdECaHpIBJHn94S/T5TJMEozOLp7VQZRnvV6gIjBmmNXq0ISYQtZ4mICCySYXID0N6lMbuY4O85oxmQ0UG2c/T9Z
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
 tools/testing/selftests/liveupdate/Makefile   |  1 +
 .../selftests/liveupdate/luo_stress_files.c   | 97 +++++++++++++++++++
 2 files changed, 98 insertions(+)
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
index 000000000000..0cdf9cd4bac7
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_stress_files.c
@@ -0,0 +1,97 @@
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
+	int session_fd, i;
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
+		int fd;
+
+		snprintf(data, sizeof(data), "file-data-%d", i);
+		fd = restore_and_verify_memfd(session_fd, i, data);
+		if (fd < 0)
+			fail_exit("restore_and_verify_memfd for index %d", i);
+		close(fd);
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


