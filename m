Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55A8CCD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 22:26:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 379B66B009D; Thu, 14 May 2026 18:26:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 350156B009E; Thu, 14 May 2026 18:26:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A36C6B009F; Thu, 14 May 2026 18:26:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0552B6B009D
	for <linux-mm@kvack.org>; Thu, 14 May 2026 18:26:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C6E991A05DF
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:26:50 +0000 (UTC)
X-FDA: 84767461380.29.1BBE6BF
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id CF46680008
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:26:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MXlHFrVu;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778797608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z+TDIuCJZXpxQehieZyZSUnjXJ4NsIJyCoOgTpI/vhI=;
	b=e8/Gxwn555QycFY3OyZMQ12JSngO/yYuDzr+Oi9lYmXo3X0CiBtNB/MaF6byCyiqxHRsdG
	fBQRJ/AZ7SumNDZ0lrExnQ933sJoyoMDOZEu9Eo9oOPwfBUfT/F7Gx4d6w0BiMaH7mCyvi
	zMrRphjC/VNgtsIajkcZ+BSmG0bu3SI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778797608; a=rsa-sha256;
	cv=none;
	b=YtrnnmrAwNa3VH+++6JqZLQLHw9EnQVZSa6bK/ZtuFfSWYxEbaoNVvC7WBoV9qxraurGzn
	seh2dBcPFZJL/myXUWsEb4qhmJK2mJy85/5Itueqhmx0Qfo+MQgD7hVjr0+AG/BaYkGuvx
	zjqmHfq0bx83GHylZWq8S5ssJ363R/M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MXlHFrVu;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-512f09ecc67so59904131cf.3
        for <linux-mm@kvack.org>; Thu, 14 May 2026 15:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1778797608; x=1779402408; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z+TDIuCJZXpxQehieZyZSUnjXJ4NsIJyCoOgTpI/vhI=;
        b=MXlHFrVu8bazYm6lL3MBowq/GnL5XyV0MqfLgBikN6BRkOeusNnK1GmUCNH29BeB1M
         vgYdhzTFcPXktJc4ObxYaSmtRTI9OAQToyqyrfoT1eqF8Ipev6RDrZ4gW+hHWXu1RoG6
         UiMJdDC24B/MEz1C0BK6Dy7h4T9Ehoa3tpLfu+QYMxfSeYXXhywwN4TzuKRju32440tQ
         mpd27fmDRj1Bfq0Y30myP7hbqKM5UX04PnZs6F9nWYjwCfmCGYZ1XlJBskswC8xu6iGj
         jHTAbCe0xjMHzl2dxT+uFg7sdLy42SnGKIzxwoCfXwNLpgR4o6SNTB5FlRbyM/3pGPGi
         I+yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778797608; x=1779402408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=z+TDIuCJZXpxQehieZyZSUnjXJ4NsIJyCoOgTpI/vhI=;
        b=hmUqNE2inbOAts8fXdr+bVS2kru291dbdko76ulJl9bwyhUT9oPAOAoUbQ7+w87bMV
         TZmdo6b9XKdDEOQRZGwoLg6L3Fpj63wdUbKtC99aa+KA1Ye8wUnEJq9aJw84z5Pzp5Q3
         O3MnDQaGnu7/yTFccmeZ4R6rM4mWQeCcJsEpF7R5avN/3SOityvPkjq1k+9w51k30w89
         h2iV+8GYkAcyvrUjjVu0o5hcnP5WMz01zvBhdaJck93B+XGNqCK5ZA0jTZrA2e+1yciY
         JHo3EP85Oiqr2+k+sGc8xVgO+2pAknlmTfH9e4JLiDq3sVAbJElaeXguZzp9Vy9iNTgS
         KcqQ==
X-Forwarded-Encrypted: i=1; AFNElJ92z3lZQjBBgH2lvI8b3LJpo8opE+GfnAXgs1JNSgK02wQYjz/L2nMnI/wc8HDDG/Qx/YC1ZGJ/0g==@kvack.org
X-Gm-Message-State: AOJu0Ywf1Ur70BUiDUJsMwu5VeIJRloe6e83qp2mKU1x3KVz1M0kyRnj
	Xw80mayNZ9SM8mim8c9egWWv6CnsPdfX2e7EZ4ZBx68iuqZ2uIieNCIV4Mu383rfLKE=
X-Gm-Gg: Acq92OGXShbnyGkKeLFiKiD8MJfLF4WT6LXrJRlxjRRDgQbgmOSy8q7E3rFREF104zc
	CsAyYr5HRn+Jgi70M3gQ76Umd7vT3Ict+XuMkhStC6Ae/s0HlXUP0XPju+wozJSoOsNtmHf7QDc
	3iNXCMKwUo7dPKVnCz35KuSGAvd1VcNQpWDU2dv0ZrhAvsyDEW8DcLM6ha1ewlbZskeTNGA1zn0
	wldpE1zNcTAF2J9Dtwusb+4ikhqva+mGVOvT6t91fwgjFTXAOPYqY5KUaE5fg5wpk/03mq1oAMQ
	7QN0eH8cIUsD45HnLXUiQFkbnAXY1ujh+OL/R3jafJHMMbPTrlx8hZVSe8il9lRo7WG0bfKrfKZ
	aUWcvYo/R6J5saojaFyRry/PDkGuQkBf3Of4EkLvB6YHRo0FcAUuaUGUW897AipohZWa3ZDPGjF
	L5wjOVGb73SncKAGmWkF0N/m4d8SJG3O6clIBWRfZlEzeLxfdwSuo=
X-Received: by 2002:a05:622a:15c5:b0:50d:a8f5:1c02 with SMTP id d75a77b69052e-5165a219a43mr19531391cf.41.1778797607915;
        Thu, 14 May 2026 15:26:47 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516456ba92fsm28671901cf.9.2026.05.14.15.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 15:26:46 -0700 (PDT)
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
Subject: [PATCH v2 09/10] selftests/liveupdate: Add stress-sessions kexec test
Date: Thu, 14 May 2026 22:26:27 +0000
Message-ID: <20260514222628.931312-10-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260514222628.931312-1-pasha.tatashin@soleen.com>
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CF46680008
X-Stat-Signature: w8qxcs88m3wamghobibnmz976q6ypwye
X-Rspam-User: 
X-HE-Tag: 1778797608-644877
X-HE-Meta: U2FsdGVkX1/EbEDgLAcOVXlIOiIBja7hSpULXDK78H+S7BeYJSPJ1JK6PNCLQbvgjVe30AU0dTs9qfejF+2/3KV0O846fRsJGirjpACR127xXAYHvZNlQ9M6/aFPHWk2fc7+aOf8gzkiI8ONKkIGZWknqv4FWWUsybZsdFPx3R2BYxQoEOoqqF/eghHHrZiq2zX5XreS03XAFThHFA2PxkHfaEL9XPBiaKr3rOJAUY9N3HlNCR6ET9USHmvzmJK2qKzmRBRubCpsHD/aFMMRNOmJMuoVEnrssVqgl0W46S8BFrNZ6V+YIXSF5NIt+Rp5gfu+m68iErs28oV6cIToGtyrLMvaFRDdrp0938jX244cdG+XdpbqEd5W2Km0ik/1ySn+Q0wqe4yx2PSVCpgsg1q1eUcabpIAKJd4bDuhwhteUnRQkjYiPcOUbke8e+VpXjNHXcNcbdYpBSF/nCFQpuUKm6mw3qsL+6V+6TEkUQqrY+wr9jTbxAn0tYnXRomLn7bHu/Sp4FCu4JqYunp01d4yEuXyFz2JoxIaUX7bE2QNcis7SOQ/UI7ZPqDNKGXRDutrhnzuOak0U08vUVl0wJwAU+roL2AcaBJZM9JFTj7KcuiOo4Lp2rRsGGAtOdhfhkH2rsqo0JfQ5tnG3NrAsK8cVtx74LnyGyX/5fsE3aJTv1TyQY+kit//R9QJymyhd9m6+2kJdWVndBlpSTInSFB5Wg2hpRuAlIkhH5XYXUqmsJfncENcWvXPoWm9cdiauwyg6DaHJCjV09IajrT++ZbQ89X7eSDKqOOsFmmO8/JsX8PtKM1Fvh1Qvh0HRvr6dj0EbBLm2nUEC9AU83b67cKm9oQszQYmlmFkPJ/Vux0rxa21WOe9AoE9Um5i4C+CC4gNvZCjxsHO1BpTG4AL1VEhmtW448jGmR0kHVhFSAPxLlpryyivg7x3t/3qSMs+2s4YEwcX2wNslu7dLVy
 B9F78OQ8
 GSmwGrzceKdz+Oig49XRAQysflGIwQxTHrqSOQg6ROB+eLDWviqSqGC/EYe0hVCUmO5abMOp0RAGecwgyZvb6UDTC5tEFgAtspY2djU1ehLHjX4fOhesIVsiGGoWq2d7poa5JeiKwJuDrmzacnIN7579eRGhMe570EsbMU955zv0HKchwoUXXwBB5z16OjCMkqvcUmBCZLTK5cd937drWm8yIvUEHIPgD75Vv6Vj/X+araDHCHITjZiDfTCLTh/VUkjzR0EjDdCcI7qrzTEGiM1LEtjs9zdgtOELqEAWYsgAPEbaa1sVZpnKaX1LK2CeXjNu8pFJsa/CNCFU=
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


