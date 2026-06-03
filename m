Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDF4ECD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 15:46:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 406E96B00B8; Wed,  3 Jun 2026 11:46:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DE816B00BA; Wed,  3 Jun 2026 11:46:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F43F6B00BB; Wed,  3 Jun 2026 11:46:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E3AA6B00B8
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:46:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC641162617
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:46:40 +0000 (UTC)
X-FDA: 84839028960.25.23385EB
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0A2BE40012
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:46:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kw5AnKii;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780501599;
	b=4DWSbU0FVspwCnHF2c5z0H07hvb9glHRelvxQtwqPHoIApWnc7Jn3JUXkgU+Z8LBRCJupI
	TTieblBYrzztUvK0njd6WbCHqKMSK/PVWYRD4wurGabN/k1cHvgOl8WZjjr8F3MPArpZ9N
	VOQ7fVmRowFkB5KwwbqITEO3IMYoX+k=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kw5AnKii;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780501599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZ44uuKaEudMkx03Nujcoh6Uuv+6Qpcd4aVYSw8wkq4=;
	b=005R3E3JdjDyJftT8IhlFvq2844Kox0RnDyXb6ruM4MoImUlk4iBRfBJwGCcVt8a7hq7ll
	aMBLR/CeT6vCdEdu+wFplqSH8fWnkyZdSht/aig6rLA3mcmiZmWoWayQHX9Bk5CksTWFCb
	hmLpKUBeyoDtrBOLuXzjaXVJ6F6naNw=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8cceaacd07bso54075676d6.3
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 08:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780501598; x=1781106398; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LZ44uuKaEudMkx03Nujcoh6Uuv+6Qpcd4aVYSw8wkq4=;
        b=kw5AnKiinu9GsW9kWANYXrEHo1FbyVm9GT8LuZFxcblyJmsdH9J7w1O2rSB2WpSZgu
         OO2YFJmJZtcYBHVrDEcGmPx0xhFw0zleCvNKI7VPbHFzs3LcnmleT+0eZy5Y987Czhiq
         6nq5QFUVExJ6r7mKIXnqTyjKI1Q7OL9q5pe9L/npYWI1VSocyE8K2xByE2EDGBgQw1nS
         J/6Bf/6i3eQJR7wkPUEUdFnZay6EmgSvXAdlyyQk4n7X3FRFhm/Hx7+Pn2yuzDKLyxho
         RSWMlS81d+gDqiqfAZ9QPlxbaMhSjdoF2eebycvxQI/7VuqVuvUgKpVQOndSSu1TMMYK
         wKmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780501598; x=1781106398;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LZ44uuKaEudMkx03Nujcoh6Uuv+6Qpcd4aVYSw8wkq4=;
        b=D3R4uNKEcLnB8SeqzaPsQdGdO9VMmioxpE/r3wKGSTAmk48ZaxG4YAeGQBB2uKVE5S
         sKjbY6z9rTgo7NZyQJyTodpV+9TFqaiJ8DaVoGX7ZonCxoAgwuEJfg9AdWGg1Byqj9an
         d/MnJUSeqgC3kFxj3f5yZbogMqmgpYmd/PARJA6XK+BpSZbHphdUtPUIDP0Ivm/cl0gf
         hHwShgFjBqceZs9yFcqLiCtoB7SnPq9ADa/zELe3iubInqrEKll4QrRJ/bGMb46+p/Yf
         W/lpBNaQgEjPHgCA0i9Y7wa/E8SwIMNCjJFpoyX0Wu3Vcj1tKL/ksAjBVXT9OkeqJHe3
         vqZQ==
X-Forwarded-Encrypted: i=1; AFNElJ8SKrCPRclzn3mtoa5InhN5clNyeIH644MTI6p9A/kJKg6xzJpUKV2By7zsGVKClvnS+lBagzJIDA==@kvack.org
X-Gm-Message-State: AOJu0Yws6t1i+TLDgYYzgSswh2oC2s5okCXKM6Wmi2W+24e4wywpB7vW
	E+Gjq7mDp6RNyf44y1MEd63pYBk719i53AtlcL6tmMT5O8gnyPir4odPneb49NujFVY=
X-Gm-Gg: Acq92OH7RdD0dAYciyxasUzju+5C1pFWnTqdXS3sn7iCxTZPDVrdAf4PCqRzJzn8LRK
	qbipqJlvEu4dE5smtl7IDNgCEUN4U7Cwwop1stFHopzRMTxB9XRt7AcqsvkPfc5fDxsjTg5iRfS
	NpLyATk+UTOki3mHMtMauLshNHA1N6d1Q2LsXe2Iy8IhCKx87LYNh5rfDNoQ+axW7iBclnWAyuR
	T5XnD1HCRHVAwGCfRsWy9Odt70RJjOMk8xXiyfP+5XX+otJFTdoReoxFma+RMkWuqyv/t9D+ZXj
	G/gS9uNk6OfwgMUT+85vS1kLz2irydVRQ3zNPGWAGtM9e+DbYSWY0kUSaX/wwBbcSFVI1Sf8uiB
	2XJwNmA2lFv+e7I0FP4jc/iT6uWnN6x6QmKwMak3FP+sP/XXyRK1p00MEHPfy+mOXwArLaom/l0
	HsQecunbIlwFizXJxl/8HpXkygqlstC5YJl7XZ9HvASajI35+kvQoYG6gquMK+2pCU2RGQfsYu
X-Received: by 2002:a05:6214:dce:b0:8ac:a6bd:503b with SMTP id 6a1803df08f44-8cecde9c8admr53195506d6.15.1780501598131;
        Wed, 03 Jun 2026 08:46:38 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd277070sm22665326d6.48.2026.06.03.08.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 08:46:37 -0700 (PDT)
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
Subject: [PATCH v7 13/13] selftests/liveupdate: Add stress-files kexec test
Date: Wed,  3 Jun 2026 15:44:02 +0000
Message-ID: <20260603154402.468928-14-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603154402.468928-1-pasha.tatashin@soleen.com>
References: <20260603154402.468928-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0A2BE40012
X-Stat-Signature: regm5yqyg5q465e1cc8tkwm6htuz1z9f
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780501598-115731
X-HE-Meta: U2FsdGVkX1/UdU0y98JaeLCDe5IW8Ry/KUaETloJmFheC8Vi3qf1zlKXdu8JQJLFVcAxxRzGzeGEeAaApVZiEyEbmtmJ/qN0DeKq1gcsqJ1c3Jps8uXICKXXmVLEzlBIt5ax8PeHwyLVkctYW+Y0W7wP+wdTBNxujTGcWDIxYCgnblbFRJpZWoO6Qsv8pMuKaK+vLYuBRwrVre2Aap1OoabZA4AR1fYSkiq2DaDNOwsvc55XoAu4vsrEQEO4qkgq8aC+TBQaoSszbQz9iOFblDx70TePIcGXlKrRFryo/euGj1Ch3hghvVuyL3opq8vdZwpkS22eOPeeO7qQPopi2Zg6DMzH1allv/t59dFj+g1ddxv5tHBKPj0wMf+tYa/HCTqKt3unuZEO3i2VEAnkMPyAg1WXg+XZOS05hL+xwG4X5l5+TscwtZLgD4DIcjSElosnQx1BdB+Ptm2t/j/4AzAUOw9xvL8TABI9saSVgiGsvb/2fWRplzpj8lyGus+qOgf1o1UWxjnY1EF7qIGsmFybDeyqc2fDJ9CE0TVkh60Ybd+i0J8pciVYuzwb6HdLfjdt3/k2ZX+cPkxwO23Oy8iZZc0keU/xu3sW63eSE6PNcaV7BFVEV3wDxw6PFY6L1fpkntrucaxD2UlPl9WKmMOkfBmAOkYLa5zvuLcxfGYKAsODq0ufoXaNT9Mh60oXY5bMxJMjKPyLPYqMgp+b3hV71Ac9qcXzsLkiOjyTUFx1B9YHp6J5xWtDoPSNaRMNnZ26AFkzAm48ANq7ekTZOxRf6N5dnU2UqC8YuN1/EbPLaggyFAYPCL64EChg0+qmIvZJRN4WPitp1Y+eSHgDeLnjqqA7/5+Yu+gYYZtef9InDhePNTYJWnugm7Kgko/9i6J1ZKu1crKieicsAYmfo7A7fPWdbEiuQq9kf3YoKGAZkcR9CNdsGZHKmuMNkTCxq0PA6MyPf2E4fnZMGDu
 BUDjEL39
 uDfdCaeeMwM3YyYqi4W2sp1ZyFOB9KdPqX1egpUHpwy3xo1AUSPlKG9EoWWvrigI4nZRO15ZbmfuD/xCZPgLjt5tipxek+65i2Wge+fJaaOTiA48BrMWd9jILO9BgeChujUQb9BTBKutehjlpBWKlV5ZtryOOW4FBY0odcCGVcK/TOzttIHQS4VlNN9GlvAkSaNKXx7PjHLLv+dmkxHzA1h/acHgm/duqeqSmF11lGJyEhlWO8LUmv3p2BQ1uVhcCNkOUbNUEOaC5hPFr434eTDNIyhQSEtJPLUO+Rv9R7Wd4iKzit9RoYYldE6/AbP4xnYaerV6FenRoKidzcdAII4gwT3yqRAgMEE8t
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


