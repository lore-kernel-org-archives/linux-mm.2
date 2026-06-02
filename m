Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78319CD6E67
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 03:17:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3DFA6B04CF; Mon,  1 Jun 2026 23:17:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCA236B04D3; Mon,  1 Jun 2026 23:17:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90476B04D5; Mon,  1 Jun 2026 23:17:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92C9A6B04CF
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:17:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5C55B161A46
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:17:40 +0000 (UTC)
X-FDA: 84833512680.25.9EE5840
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9B76EA000D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:17:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Sms+erqv;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780370258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZ44uuKaEudMkx03Nujcoh6Uuv+6Qpcd4aVYSw8wkq4=;
	b=Iw/Oa98vKJRz24yA9sgmIwOm8w9j7LagZe0ME7tY1gD/WLBdGH7Xg9nuEpFt4rHzGbNp7r
	tuwpDZZGd4cte0SBEVD58cveeFQvH4R3r88j9E0FcsANt/h3h9OkPKNEQUl+YJ/cauWBmP
	xHn+9ZRH5jYljkBYtpfnWDAkqP3yi4s=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Sms+erqv;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780370258;
	b=gyJ+IxhucJ+PZp82fWbqcbCP2P1HHpCR4r8rncyRNzpZSh9CV3lT5kKJAu8lIQKFK4UI65
	vRvKpCBoKsRaZyYvnqR1PpaRnpnZZQ9FnLUe8/Ysy+yonbtUl37KaxmdLHFvG1lXEC/HT2
	8PS0m1Aim9CrZhuaIRH/uHMznjehrA4=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5176096116fso10257841cf.0
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 20:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780370258; x=1780975058; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LZ44uuKaEudMkx03Nujcoh6Uuv+6Qpcd4aVYSw8wkq4=;
        b=Sms+erqvXzKAUbtGcQIxg7nXfXadDRd3RucqqGHD5eNHesVu5bdEebSSlN1RGPzq2G
         AdHDYEeOhk4aAHzAv7TZsy4jWnQ97KyPetXyzkXlfSTxBfYsPEVueDkjcr769sUnC8PR
         lLH4mjNZ3Ssxx5hY2A0oCSgqldxt+iftPtnhMCq5B+6Hgf/vr/61ss3ivNwCMN4u53MX
         Jqc0mgJ5vcAMCaDw1ea08pB2MTldCSOvqgGntJmcFIJ1nomgp5//VBjbGoYe3VKa5Vkn
         R3oZW2bLXC0u4TSrtdH/uzk4+1DRCAoHGpG/oKzFTelKFgto2juHg015KtngEcTVxu7q
         wyhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780370258; x=1780975058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LZ44uuKaEudMkx03Nujcoh6Uuv+6Qpcd4aVYSw8wkq4=;
        b=lkp0hHJN4B3+3grcZIAZ4Ru37F1x8agbYjGpDB0rIcnZDfwZfFrpA6tZPd7tHtnv3S
         xYWcuzze8ZIpu/R4ligQs1wklEiGPObu4QNfbX3vWrOtzhjphe4S66LUADDayfNDS21C
         vGBjFma5U7fe0oUkx1HYH+2g/Dby8bQpGW2Lp2CCftKe8y4BldWZkCKWYUVcXQ1vESz9
         C7KyaKo4kpt+qtChbMbJlnSsC354fLPCzIjgrJbIolOi4nxpn5EiN4YPJXSZ6ZeDM9sc
         OkNMva/R1VpX46XF8A6S+SFbmBDXmLaRJqIgVb7VfDF//wMV4GJfQhRwKhJULnVlyJq/
         yh5w==
X-Forwarded-Encrypted: i=1; AFNElJ/7hWM0vJHD/cwsQI/Zl7JuVcyfUjasbLlkt4L7oSN8SzFXkUMklChRBDA4wvpqxUBCOO9jsyUMow==@kvack.org
X-Gm-Message-State: AOJu0YxfyjUHCpg2j32E6yx17rYAMw2r5gRN8iFYs8w2wYo4ueKyNtL9
	l4bgsf8+1H5Gend0+m2yDO8QiBaUQvOaZRUfqtfjJUHfU8CjLujNG4n/FnA7sQiOkxQ=
X-Gm-Gg: Acq92OHRMMBf3rd/OxEpVf/+MbnxZIBpS7x6kh58xZuDlLYTEeMHXsNza/kPRZ8CuNL
	aOMwJ9Oi+19Vfd0ry72RG6ZK6RN2rIpFhb66h9FkzWZiXzeoT3NcngTzZK+blTXeNS00uSU8LoB
	bXg+OZuNupJMN9FbY5y+RFxCdSHAUVcyW6MCJdoEK+lgWV7q6TWr+13pKeUTL7of7VIXEr8OJis
	B4cWCYN+e8CRoxV+qf5UfMLsZozSDr3EHvJfY0fHe8yMACjOcBDpD6D4FdJsB6pEEclPfNp4ghf
	Yw20kgzKfarsHNPhi2o9652nKBwcmsOUtAqsqDQvxsvD5qeH6Et/T9eAKYvdWE+efoLsDhnoTli
	6vkoesRpC1Dvn+9EcLR4WXGutV4dBd/nsA4t4yTpCy+L47uCwhEVwQMKXysDrJ0nD4ctKdEJyGA
	QS3+E859kvXd2B9SOlCExhwc7nbXvvwfjCzy2pGTj/u0yUccVQTFZpQMsZ1VBeysqFLofVDSc0
X-Received: by 2002:a05:622a:1f9a:b0:516:d781:589a with SMTP id d75a77b69052e-5173a73b0aemr208229881cf.22.1780370257673;
        Mon, 01 Jun 2026 20:17:37 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51741b29745sm71219081cf.8.2026.06.01.20.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 20:17:37 -0700 (PDT)
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
Subject: [PATCH v5 13/13] selftests/liveupdate: Add stress-files kexec test
Date: Tue,  2 Jun 2026 03:17:17 +0000
Message-ID: <20260602031717.197696-14-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260602031717.197696-1-pasha.tatashin@soleen.com>
References: <20260602031717.197696-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9B76EA000D
X-Rspam-User: 
X-Stat-Signature: spa3iayieg8yosakmew51d8wxd5dtmfy
X-Rspamd-Server: rspam09
X-HE-Tag: 1780370258-897248
X-HE-Meta: U2FsdGVkX1903AML/O0S8bcSLr7d6Y7CgjUbTP1MEsw3uBvzBqmJsIEjepYO1pJ7Vm8PL6gcm1OrcCH4QBalgfdJpRvEKU1SLNy3ToatW2/GK2rtcsLLYoOFS4qWV+Z8SzUq19YMAPbv6K5693WCKSZ7BkaQz/sWHFG54+06bvBq69LX2XfQfpMXr62Y46hh6va8qKiobJ6LqxEZ9A46AsglNmMxHp/KNPuDd92xOlZBrT9LNipszDsuCVTCdrClMl2F7mHgm9dedcAO/BJcYvoN3qADzcgh5tJEWQdj6W7Kf6dmwUdqIdPH/a//TpPCknzFfoPGotowIoRTznGS4W5kDy9UToktUdVVcjTxskykTB+lWHLQ2uxnVZUYtsNV3F67rmPRjDOKrVoBdH9qCHV4yoI6D8sMtEtjrpdsKuc51Tk08Ffjs+aL/lSDx+y62wNZl0TKdLhAFgN0W8gF6Dwn368xrKlt9X/pVlIpL0LfXoT6Bw4FxO2IJpsrT3hpYLrBz3zc1CIcuMNg4egaNH72ct6lmfpCW2v2S2+70MYoNydYTRuGHykFu+/aRwQrmu/SZOocum9vn3WWmh/+viDnSJ1/emyWYBAV/GGFrP4B0jEGRZeofhmSkPgD0zoGplvlnaTy5zI701Gbn00pN/VEiulJmV6YPf1ILp7AHv8PYTKTjGMy5WSARwir0bcvxqUBQlL0H2al6xhSd1RNcFeawxBweXcsURPHHOnwDJOcN4pkEwDSmBEvBqFaniqlTVCS8qaakYdaT6VQ9DALhpmil35v+IiLkpkAwULQ5aFH/w6ZrJ8rg4zz4kdIKAVNW5ESbdvqobVh3LoHAxCCUhRh6kszHNwkMe+9g5p6VaKvx/1g7L2zPUp8fECVtwfBSQ5L4t/jJq4nwm8C9NmJ676MhpGFsZg806tVGTIZtlnpoGfFdcdDCpcBBlvRXr6HjfTQ7oJAUVVhYADBDJb
 qKl1abj6
 mmgQiQkNXbPv0+8+ea702ED52Pf4Yltu2W0n2WzCbeY8A32xYpz88ovdj4Dvtw4b0c2MKwhu7wuTkrWB/yW59gFdkGWB9guYwbjk8kEjxhqlRw7FyIimOyU4sqDyKxOkNVWzj614d4sq224GLBGxd218vL8DENj93k5lFYT9kdoJgxv3ymutXWfh6Jqb35DmiyypQSfOjJKATYPXyT3D9TIjicJjdd3ikLv/CM2JARmRzh+lSHFxuiIpyhPu+vq6EgbMiPim00HU8XdtpxKScG3SYVpvUWpTeEkUJDiFE2V6TNxufkDGvu60Sa6i6/QqDb+V6PgI2XilUKo5kPedNhqVU9mEG99zbmyps
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


