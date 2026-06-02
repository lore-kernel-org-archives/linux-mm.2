Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BE27CD6E65
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 03:17:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FC816B04CC; Mon,  1 Jun 2026 23:17:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55F186B04CF; Mon,  1 Jun 2026 23:17:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38D226B04D1; Mon,  1 Jun 2026 23:17:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 189236B04CC
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:17:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DB6AEA07E9
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:17:38 +0000 (UTC)
X-FDA: 84833512596.23.E282E96
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2480A120003
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:17:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Seu8K83V;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780370257;
	b=fQUNSCLUGdV85pbS78btFpqlRYCQ5oTSpyMIFnKQgusAWWxNnQYe+pKtYPK/wgc5OPR0Ty
	EShj5ojYmfW+sDc1wSqlmlfk9kIU/kIRUGXDcH3QBKp7/SF9RwzxnEFY+ibx0p4En2Tt+l
	V7UTTuyCtaQElJFUmiglp8aUmHA0bZs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Seu8K83V;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780370257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=psMAwGaqe9xuyJY3Mn283ARVP/GQQXmgr+1HpWpGRKs=;
	b=UikYK61lq4zJWSQBq8/+GnkFKOOzHb42FKSjVbrs3kmOIx3qxh1fSpjJgqvfcchIuqHaTG
	2x3PPfmTKGyMbexlF2xiLix9bQuD9D3YFBYwontW4yf6PoUQ3sZdiuXmVL+NlFSvytLUDs
	8U/+lIJ4x2D6uWiUabudYfskyL5hxO8=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51764768c36so9507471cf.0
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 20:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780370256; x=1780975056; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=psMAwGaqe9xuyJY3Mn283ARVP/GQQXmgr+1HpWpGRKs=;
        b=Seu8K83VfTaZtkyo5g0L219wZlgYOBUJACQcRhbRhEjY9iY5HRbTkn/UixNsW1AX3q
         ZCuZD5yumLDhrPbwm7MY6hiy1gbwonSXat1okXQaf+6L45TrX1nJc6+oE51fk4CpCCpY
         15/JxXCekLM33w3u7qThPAXHnqVq/HluklutOFUW/DKWvDzgGUfGTo3OoGPWO8T0oLci
         LnPYxFN0FynRjWAaCWXCuG1C+jdIMOvEB/wR1JwK/fDPTxLEBfUzbJXhGLys91A6FAAy
         3S96hTQedW4F66Th1FGLVc20VlRoiJdqfECpyNTxuVimHLbmVhASoWkiPFkBJORNRWev
         J8Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780370256; x=1780975056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=psMAwGaqe9xuyJY3Mn283ARVP/GQQXmgr+1HpWpGRKs=;
        b=f6vl5ii+9kjcp8cqjezTHE4kvQYvJovspvHDzV9L+FXspavcZljeS9Mt53GFbzoyqN
         NZjVQukyAqM5DpjtpD9a9971JmU08p9T8wgMnpfFqp5IOAeR8nDt69ytn+K5ei3bm7SY
         grNCJVBcaND/NaQEkqec1n7/GkHpjxF90R9mreBV28p8wkiyiqOJwwn+mCgJNRgxIFeI
         fMgE5DYPWkFyn0r6yD/1JCCrpMBXEmg7lykXf7SjytHd+ofLdtcP0178ufoL09TFfHm2
         V/MJqqxQu5tuJPbYfWeKm7DZMPIgyeYhahfqtenLW1TQCPmwLrVuQRyLNcInI5J0uEWD
         UTaw==
X-Forwarded-Encrypted: i=1; AFNElJ8nRccQrlJU7hdE0ie6qSExfofumseJn+oiBY1b9gYGiwwkauXvjGwsIVBnh1WyJ5g+riPfc16XOQ==@kvack.org
X-Gm-Message-State: AOJu0YyHMr38PFHSqhrQXq9cBCKt+92LRA0uDKPa/9DvavyWOLB+kfN+
	dz6HXFgiHHJh7VCPWOgxhgj10kmkCPKxQ5y0Ohbt6xruAL6iQl2rIb8ORljlqEhiDRQ=
X-Gm-Gg: Acq92OH49+VQClIHrt787+uvHEGcgzWvE7Y/lY1IGmo8FJKHN0Ygukutvmf2a32hbBp
	abLtLKBFtnU8IahuXmwh0SxLUArrbxPIY2zAm28+FYwjOKYgOYdaRUZtjfWcQhTRt1XnHliIU5Q
	oeZPfRctA1FWc6pPFFzSSHQju82ifMLk3T5bdZml+goYzbGunFKavzWNo9yjdCB4SAM1D6i8ajP
	6OvznXcud0gmnRTJoV9f54Y7pu4vUVM8Qf21+H3TvTp92ZGAYh5yrTU4sA1ZbEc/g4DRdq/Wg1g
	Kdx9RY5WmGNgjd1VPNW9lazg1haO75iou4zaP+Hhr9mgr4S+Lo0AhlXMDb8MfKMrZBGLNYfz1SP
	ESCRXvzH+nIiuc883FXJCy5kdeAQpK/8b9Ej2PZL4TNscnsC0ExZ5j/e91IvxexV0qsJ1cCHHMl
	TrnfWScv4U10yGmfyroHxYg5uATbBuK5VuYTQoMloi0hcuzj7YgcumOdhwpLuiJQ==
X-Received: by 2002:a05:622a:9016:b0:50d:3e1e:7998 with SMTP id d75a77b69052e-5173a821f86mr167634871cf.37.1780370256215;
        Mon, 01 Jun 2026 20:17:36 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51741b29745sm71219081cf.8.2026.06.01.20.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 20:17:35 -0700 (PDT)
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
Subject: [PATCH v5 12/13] selftests/liveupdate: Add stress-sessions kexec test
Date: Tue,  2 Jun 2026 03:17:16 +0000
Message-ID: <20260602031717.197696-13-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260602031717.197696-1-pasha.tatashin@soleen.com>
References: <20260602031717.197696-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2480A120003
X-Rspam-User: 
X-Stat-Signature: zuuie18hp7ghek1s41keypiad4j86bq4
X-HE-Tag: 1780370256-336656
X-HE-Meta: U2FsdGVkX18pcKxHM7KVDB70cfUnSpM2wUwX7Is+OhM3Dxw36qoE7E7ztylC/FjCn0LaAMl/PCwuQCVgDKzhhAq61n5FTC0agf0pIYcD/zxoZVTv46W4NAiDE+/8mw+h+qzx3G8pvTyFLv0HIqPzKJMcKtG7iXerrNJ6Jun41Mj7InB8kId28v4tuecz762WoyodykkvOM5oOsjb3IatCIlnm1+gsk+xNPymP6k7VxSRgBkkeyKTNhT7kUXZcBCpKd67t6sARe0iRTpkMn0Vg5SHydtsq1eT+HoPSZtVI04GDN54pOkWeDYjQUurC9wRMEyjrOdoj0dE1ymOaNxfN3VjZvSYiA9PfkZwQtkfGgdy/0c67egStrM79c02QQVY3YrngIfOalS2UVfW0fxN6SEpBRWUchJYDFXDogt1fzroHqNRtzwr4/bCPKaPDgvP0Qfd88tO20GRFSdfks1ZSlIVxwpFD8RaksXjcp7C1atj6G0Ny4Mj1jtRjCJXBcG4GjkoPGan7URucKv8fHj8vx1drvwpZ7RSxglfG+tyF82sGckTgZOV7GVj3WJFdtEqpAMkzW4ODiG1Qv3mTuBqQxRmKoAtk4ShtYChYLaKdUsKDTSCaLtURXoznjlZ7NtojyUhAykHmlFs/syJAu+DTLefKYWbVKF2FVZMw/vdJ3iylqc37F1Tq48xYwOd4jiLbNb7F0zreBDLfP3bZrS6sIkeXDnYJ4ypQkJUShlM75iQ47k+KrKeLly8z4NUf7YUjJc3iiT08ZptVih8Xg3zXEGm4icJLSi4Akfc5bGBePP5D7r9bLP4JkhoL2qOENg1S8rQ52ySUucGJptvxi5zHFaFrBNO8+EGc67FXKghAJPueq6Ist/jGBEoJ0JXaD6AcQ8/RQBjzcFx4CJ7r4JCrXfNoJvLMhr/iW1qyYUhkEK9Y/n4mh93eviDmlYtW7DhyNuP60NZgsLSZOV//pA
 wf9BSDlj
 bBpbjl/bYSK9FVotbbKIdkk1aEkeMHLrolQ+laz3qa+2tWauEpcvICjbS2tOc9UptlDpZuWA7Gwhot4A1dB6u4a7FyIqmBBmE9fskWvLA9B8/cLYrNT/B8GRxIcaxaCOnQJA40vcDlrQUpn73cdvUUWEDAJKOW7cMwaQNtMNznx332R9Rt/Tk6ObuOUJ1C2XhGnVRBsJKEY3N0AgN+7esNRkV0sfd501NtZxQiIxbLFnY6eXfNwkhH7rDItYP96wy3HjZeHO4LHSY7t2f+mhHWaqbdXYDUAdUymPm3jGHLiHG7LCBvn9ZMuOND73YEEw5QPiRGYXh/YBeIvvhKAAvQR+jmI3UPlG/KsKT
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


