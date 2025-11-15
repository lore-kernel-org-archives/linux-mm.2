Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB3A2CEBF88
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 23:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E18198E0028; Sat, 15 Nov 2025 18:35:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA1088E0007; Sat, 15 Nov 2025 18:35:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7E618E0028; Sat, 15 Nov 2025 18:35:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 97B948E0007
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 18:35:02 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C65D5B95D
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:35:02 +0000 (UTC)
X-FDA: 84114449244.23.99EE88F
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id 844A580004
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:35:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=frE6a7sV;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763249700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CSlG1Y2+SXL2yTQcBXyPgNZX+KSmTJRUknMQAnDq5UM=;
	b=Gp/hAfQmVtgywE758yg3FPW33dxAWM6s+YbJgjZFoInRjSiqPpNHpWhai+fV088APboabC
	YP8MTu7O+lAxIrsvwP7+HMCFVEa75AT3tV1RftdqTuXecvxNfBdVCDGry+JRD7vKgngWUt
	yNo13qS9zy/VkcYdjTLEzIySSDn+ZZE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=frE6a7sV;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763249700; a=rsa-sha256;
	cv=none;
	b=XMDQFNiFIv3Nk6oSph7L6LqYTiguisg8z+mOcrGBEyx6pnskUFCckrzyZe5+qZ8E8RfV1F
	y83GTYI+/GrS9w0Kzl949MGLOyljObMrajbSAhj1Dod3YpObyBNLUnA+pxsdY5GPRwiSaH
	M7+I+ijIVcXCzW1j77HJyx38JWlLKfg=
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-78665368a5cso30706867b3.3
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 15:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763249699; x=1763854499; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CSlG1Y2+SXL2yTQcBXyPgNZX+KSmTJRUknMQAnDq5UM=;
        b=frE6a7sVDSXvTfd7IqDLfda4XqYFt+gJ1nPDFxr9ZUQ/UlQxFYSmzsz5eaoZeYKm7F
         SGRcf40eQGtIsttlsZUoR2uMuYxT1MnnZutUzgjK558dn/kcWiWVZdxsAB/P1vxTc56e
         0FwjZfJF3UnmhkAYidbuY0JLn+kWmHTDCmqFKkNVOnG0sh75aWnDENgtbPv4ew3hXBkx
         g6XFT8ktDEH3rBJ6qwKB1WDRE0Ux9qFcd56oVMYUzAI8mYAA0vlNthuP+txFRi/ujPU0
         xGZlazSCa9URtpizFhF3nxsIAw7d9xqc6W6wuAjabrWgrvELWr13HjawOctCbYA2k8qb
         3YOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763249699; x=1763854499;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CSlG1Y2+SXL2yTQcBXyPgNZX+KSmTJRUknMQAnDq5UM=;
        b=H2hpjk1KUfUsBzuH1PYQfd+2HuvOUlWFqVY9Ea8FXbxn7D9ivjojjLOrisNZ6yVVha
         /8uE3KlhvE6iWXfsenO7AYtB9Ky3I6puKdqTY0ssRl0FnAsbKrYZcaTsn6O7PvTmNCdT
         gQZ3xAKvD2FRJf9kkOpbaXRaWNSC78rj2Bj7nThmBSYPuUFjBDu+FNZVxQr0OBgxaVax
         NqN3A3VSO6QrXhEwo3Wk+WNUbTa7u0D2RjrsI796GNjEKDhIIH8BnScvHAJC7vsMUv3s
         qRP/InNiiOx97pHlHFNt2aYkcq5FXQX99du7z23uCGyc6K+VQAVX6y7xD9SQKKUtsAPX
         O7PA==
X-Forwarded-Encrypted: i=1; AJvYcCXHdnCQQYjr3WLxmi90oTcdjRs7dX9l1NI4yJBwMorWH/E8A/OP1AsN0Kr/JV67G9Rxwlkdhzx7dw==@kvack.org
X-Gm-Message-State: AOJu0YxYA4ZpQShinwQRiHKrNKRnWqgnXnAQ9ZvvN55eB1neaYdUo8n8
	/geiAUKVufVEEFFTsj+54LPQFyegZrziLEIi60UQnB3SEnMTW8pP3gzgQHFoVEiCxb0=
X-Gm-Gg: ASbGncvWvTZ4DVu+vB2121S3yjcbt8x0PW1mjhV54SZGYrChQyFg++Wb2P/REUKS9yj
	AMwhKLZTbemqvtHN1o/4iGJFnWNKoPbA3MNPSx+JFo5r9RzXmWBwY7nkdfEob/auR0G5Ujcbdcz
	a42TSpy8uFwjiYjeF9lOkwva1RFxZKCZdBgGZDfDBcjwTecc+4gPw+Tck3xqLTqc4I1YpZJSBez
	v42ORVyYMixsqe5AtgniKzmdYWDrK3d/Sg6/0Jt8kfOkSmalnQMA01mnGECXG2kTY21BRo1pBdR
	Bm282ZuYJuVb+iLZVEcxQ53LiNPJW2jlFUeoZDITVxjSpOFpa2MU1gHNqcFQ8P1gXqFaEBlkExt
	jTiDuXAK0bnHvtd6l2w6cF26qvTO+Yv7SLmFADdy3DWALzedWPaysTCKgo6GxIdksUuz/REmwL7
	K7K8CX/scyxqJOd4XU+FVWNnfSdcv+VivtV8hlz8Sz+3+A0BJnQUsfIeEPcMZl7SIaCmyP
X-Google-Smtp-Source: AGHT+IEO3oC5wpp8HE7J5E7WMHVnu7uEdSDWxH1HLV0XnEzmxGRKeC/y8GCb0/gJtHYw7ZpQFatLjQ==
X-Received: by 2002:a05:690c:6c85:b0:786:522f:f5b2 with SMTP id 00721157ae682-78929f4237amr78850027b3.63.1763249699523;
        Sat, 15 Nov 2025 15:34:59 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7882218774esm28462007b3.57.2025.11.15.15.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 15:34:59 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org
Subject: [PATCH v6 19/20] selftests/liveupdate: Add kexec test for multiple and empty sessions
Date: Sat, 15 Nov 2025 18:34:05 -0500
Message-ID: <20251115233409.768044-20-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251115233409.768044-1-pasha.tatashin@soleen.com>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 844A580004
X-Stat-Signature: apxucynfuykd8yu35joro5hedcmk7kog
X-Rspam-User: 
X-HE-Tag: 1763249700-822617
X-HE-Meta: U2FsdGVkX18DRkpI36QvFYouWfqENpI7xx+cIr6lUuxsuCB+N+yK21Phlhnialq2uPbspJprewvmcy+9IUBS7pRNf+FsSK1IfRKsxeLV2eBa+xgi7YMGw4cJZucC5kasC4mDkREi0XKXrUnbC4jZvQv4CgEhO1AbQ/k+lnnEnkTdPj2kV60fUIbLQp82jKZaumlGoIMOUaQEbUMoH+IC16fjbonvLHqvuQOWt7ylp/QCv5lfuAExbPqb0LsdpP2jATEoEFS8/smuIqyqC21W47ScFVaqOvFa/MYvvF5lVKwwGNSxysLQEjc2ER43zpVKyJ+KvF71c160kCEyJLb8LUNfFOOHf3AhbNPN2rXO1V8z6DAThX52PeSVtUXfr6ojskB4NahH6Dg/EvqR0JtkOb19Cgu334glE0i3KveRkNH7gfbV+Ae2Qfo3pxgwfYgnQgmtLtu2jcSXUzH31eLwcsIJn/28JA1PVf8q9e8YNWNSG5p+g1iMVYYRstC6oKmZEArgUg7nQtn3y/PR4brXMAypMDCLiqOp6GaOFH0yvRSTbjdMbcX2bxIHPtEw9qj91SvbOeTQGnttKpsJKw5LPpaUWLPZPJE7m+U/cUGGmVycqGQCskbW2MJSpRpkKOe5pKXN32kidiBHWo+YUiAif11PPZV+aFFwgtJiXgXzrLg59jlSS/HUA2rJXAfEIOLBvcugdpMKcpwSDEZIKb/LmCUHvCvmWt4mRx0/vKhZ3/2Dne1b/+lRbr4jRe+WtG527JLiyFWt7yiR8UwNnbk5KDWduqJ5klytL1SA/vOCrn72hcSUw6hUvvNPTiyP2vNQbMobaXCWiLgJ2YVmKX1M94UzX9qw0gmmezmKcUIXt6y4lz9XAn49zjmgaumFMIwCmEWTCGvJnboqbhdEfsDbOkmb41W8hJM+EmQNZiBwWHKa5VlG6U4H//fsWsW/w/rt885nfSuY3bRWJUOtpPZ
 CswJ0O8Q
 jpE0lTEHRfqNe/71UwXbNxMfIChkb6EGHfn7kiPFJDAq5SkAFzQmXtl7+Zak6BlJ8Qti/XwiIVJlLgFfP2AQX6c3gaRctMqsnt6lHUSwPBo8zxmLM+idRcTjklrIjv7JFYzOQRK/RQzPKN2jjBmWwdFUORO6qqa/o3lLvIkJXvrulQbYcvVpMN0JJ8umGmvGIkNvJrfGEQFr1KR1qMz1v/XZJ44f42yoqpThYZyEETu9WgJPuLEQBipm6oLalVIchy44QOmuqyxIgeogUZYTmLNKsjDROir9FjLbvKgCa278gEFenvpcIXSyEOw1H44NIUE4IBFz+eAiRcWquLvOmePLftkUxZUdkbuVirhoBNPV3Gl7VXlYCbFrKxgFG2lJwy8W1OCofLqoZlLWIrJSW2UyUUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new kexec-based selftest, luo_kexec_multi_session, to
validate the end-to-end lifecycle of a more complex LUO scenario.

While the existing luo_kexec_simple test covers the basic end-to-end
lifecycle, it is limited to a single session with one preserved file.
This new test significantly expands coverage by verifying LUO's ability
to handle a mixed workload involving multiple sessions, some of which
are intentionally empty. This ensures that the LUO core correctly
preserves and restores the state of all session types across a reboot.

The test validates the following sequence:

Stage 1 (Pre-kexec):

  - Creates two empty test sessions (multi-test-empty-1,
    multi-test-empty-2).
  - Creates a session with one preserved memfd (multi-test-files-1).
  - Creates another session with two preserved memfds
    (multi-test-files-2), each containing unique data.
  - Creates a state-tracking session to manage the transition to
    Stage 2.
  - Executes a kexec reboot via the helper script.

Stage 2 (Post-kexec):

  - Retrieves the state-tracking session to confirm it is in the
    post-reboot stage.
  - Retrieves all four test sessions (both the empty and non-empty
    ones).
  - For the non-empty sessions, restores the preserved memfds and
    verifies their contents match the original data patterns.
  - Finalizes all test sessions and the state session to ensure a clean
    teardown and that all associated kernel resources are correctly
    released.

This test provides greater confidence in the robustness of the LUO
framework by validating its behavior in a more realistic, multi-faceted
scenario.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 tools/testing/selftests/liveupdate/.gitignore |   1 +
 tools/testing/selftests/liveupdate/Makefile   |   1 +
 .../selftests/liveupdate/luo_multi_session.c  | 190 ++++++++++++++++++
 3 files changed, 192 insertions(+)
 create mode 100644 tools/testing/selftests/liveupdate/luo_multi_session.c

diff --git a/tools/testing/selftests/liveupdate/.gitignore b/tools/testing/selftests/liveupdate/.gitignore
index daeef116174d..42a15a8d5d9e 100644
--- a/tools/testing/selftests/liveupdate/.gitignore
+++ b/tools/testing/selftests/liveupdate/.gitignore
@@ -1,2 +1,3 @@
 /liveupdate
 /luo_kexec_simple
+/luo_multi_session
diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
index 1563ac84006a..6ee6efeec62d 100644
--- a/tools/testing/selftests/liveupdate/Makefile
+++ b/tools/testing/selftests/liveupdate/Makefile
@@ -11,6 +11,7 @@ LUO_SHARED_SRCS := luo_test_utils.c
 LUO_SHARED_HDRS += luo_test_utils.h
 
 LUO_MANUAL_TESTS += luo_kexec_simple
+LUO_MANUAL_TESTS += luo_multi_session
 
 TEST_FILES += do_kexec.sh
 
diff --git a/tools/testing/selftests/liveupdate/luo_multi_session.c b/tools/testing/selftests/liveupdate/luo_multi_session.c
new file mode 100644
index 000000000000..c9955f1b6e97
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_multi_session.c
@@ -0,0 +1,190 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * A selftest to validate the end-to-end lifecycle of multiple LUO sessions
+ * across a kexec reboot, including empty sessions and sessions with multiple
+ * files.
+ */
+
+#include "luo_test_utils.h"
+
+#define KEXEC_SCRIPT "./do_kexec.sh"
+
+#define SESSION_EMPTY_1 "multi-test-empty-1"
+#define SESSION_EMPTY_2 "multi-test-empty-2"
+#define SESSION_FILES_1 "multi-test-files-1"
+#define SESSION_FILES_2 "multi-test-files-2"
+
+#define MFD1_TOKEN 0x1001
+#define MFD2_TOKEN 0x2002
+#define MFD3_TOKEN 0x3003
+
+#define MFD1_DATA "Data for session files 1"
+#define MFD2_DATA "First file for session files 2"
+#define MFD3_DATA "Second file for session files 2"
+
+#define STATE_SESSION_NAME "kexec_multi_state"
+#define STATE_MEMFD_TOKEN 998
+
+/* Stage 1: Executed before the kexec reboot. */
+static void run_stage_1(int luo_fd)
+{
+	int s_empty1_fd, s_empty2_fd, s_files1_fd, s_files2_fd;
+
+	ksft_print_msg("[STAGE 1] Starting pre-kexec setup for multi-session test...\n");
+
+	ksft_print_msg("[STAGE 1] Creating state file for next stage (2)...\n");
+	create_state_file(luo_fd, STATE_SESSION_NAME, STATE_MEMFD_TOKEN, 2);
+
+	ksft_print_msg("[STAGE 1] Creating empty sessions '%s' and '%s'...\n",
+		       SESSION_EMPTY_1, SESSION_EMPTY_2);
+	s_empty1_fd = luo_create_session(luo_fd, SESSION_EMPTY_1);
+	if (s_empty1_fd < 0)
+		fail_exit("luo_create_session for '%s'", SESSION_EMPTY_1);
+
+	s_empty2_fd = luo_create_session(luo_fd, SESSION_EMPTY_2);
+	if (s_empty2_fd < 0)
+		fail_exit("luo_create_session for '%s'", SESSION_EMPTY_2);
+
+	ksft_print_msg("[STAGE 1] Creating session '%s' with one memfd...\n",
+		       SESSION_FILES_1);
+
+	s_files1_fd = luo_create_session(luo_fd, SESSION_FILES_1);
+	if (s_files1_fd < 0)
+		fail_exit("luo_create_session for '%s'", SESSION_FILES_1);
+	if (create_and_preserve_memfd(s_files1_fd, MFD1_TOKEN, MFD1_DATA) < 0) {
+		fail_exit("create_and_preserve_memfd for token %#x",
+			  MFD1_TOKEN);
+	}
+
+	ksft_print_msg("[STAGE 1] Creating session '%s' with two memfds...\n",
+		       SESSION_FILES_2);
+
+	s_files2_fd = luo_create_session(luo_fd, SESSION_FILES_2);
+	if (s_files2_fd < 0)
+		fail_exit("luo_create_session for '%s'", SESSION_FILES_2);
+	if (create_and_preserve_memfd(s_files2_fd, MFD2_TOKEN, MFD2_DATA) < 0) {
+		fail_exit("create_and_preserve_memfd for token %#x",
+			  MFD2_TOKEN);
+	}
+	if (create_and_preserve_memfd(s_files2_fd, MFD3_TOKEN, MFD3_DATA) < 0) {
+		fail_exit("create_and_preserve_memfd for token %#x",
+			  MFD3_TOKEN);
+	}
+
+	ksft_print_msg("[STAGE 1] Executing kexec...\n");
+
+	if (system(KEXEC_SCRIPT) != 0)
+		fail_exit("kexec script failed");
+
+	exit(EXIT_FAILURE);
+}
+
+/* Stage 2: Executed after the kexec reboot. */
+static void run_stage_2(int luo_fd, int state_session_fd)
+{
+	int s_empty1_fd, s_empty2_fd, s_files1_fd, s_files2_fd;
+	int mfd1, mfd2, mfd3, stage;
+
+	ksft_print_msg("[STAGE 2] Starting post-kexec verification...\n");
+
+	restore_and_read_stage(state_session_fd, STATE_MEMFD_TOKEN, &stage);
+	if (stage != 2) {
+		fail_exit("Expected stage 2, but state file contains %d",
+			  stage);
+	}
+
+	ksft_print_msg("[STAGE 2] Retrieving all sessions...\n");
+	s_empty1_fd = luo_retrieve_session(luo_fd, SESSION_EMPTY_1);
+	if (s_empty1_fd < 0)
+		fail_exit("luo_retrieve_session for '%s'", SESSION_EMPTY_1);
+
+	s_empty2_fd = luo_retrieve_session(luo_fd, SESSION_EMPTY_2);
+	if (s_empty2_fd < 0)
+		fail_exit("luo_retrieve_session for '%s'", SESSION_EMPTY_2);
+
+	s_files1_fd = luo_retrieve_session(luo_fd, SESSION_FILES_1);
+	if (s_files1_fd < 0)
+		fail_exit("luo_retrieve_session for '%s'", SESSION_FILES_1);
+
+	s_files2_fd = luo_retrieve_session(luo_fd, SESSION_FILES_2);
+	if (s_files2_fd < 0)
+		fail_exit("luo_retrieve_session for '%s'", SESSION_FILES_2);
+
+	ksft_print_msg("[STAGE 2] Verifying contents of session '%s'...\n",
+		       SESSION_FILES_1);
+	mfd1 = restore_and_verify_memfd(s_files1_fd, MFD1_TOKEN, MFD1_DATA);
+	if (mfd1 < 0)
+		fail_exit("restore_and_verify_memfd for token %#x", MFD1_TOKEN);
+	close(mfd1);
+
+	ksft_print_msg("[STAGE 2] Verifying contents of session '%s'...\n",
+		       SESSION_FILES_2);
+
+	mfd2 = restore_and_verify_memfd(s_files2_fd, MFD2_TOKEN, MFD2_DATA);
+	if (mfd2 < 0)
+		fail_exit("restore_and_verify_memfd for token %#x", MFD2_TOKEN);
+	close(mfd2);
+
+	mfd3 = restore_and_verify_memfd(s_files2_fd, MFD3_TOKEN, MFD3_DATA);
+	if (mfd3 < 0)
+		fail_exit("restore_and_verify_memfd for token %#x", MFD3_TOKEN);
+	close(mfd3);
+
+	ksft_print_msg("[STAGE 2] Test data verified successfully.\n");
+
+	ksft_print_msg("[STAGE 2] Finalizing all test sessions...\n");
+	if (luo_session_finish(s_empty1_fd) < 0)
+		fail_exit("luo_session_finish for '%s'", SESSION_EMPTY_1);
+	close(s_empty1_fd);
+
+	if (luo_session_finish(s_empty2_fd) < 0)
+		fail_exit("luo_session_finish for '%s'", SESSION_EMPTY_2);
+	close(s_empty2_fd);
+
+	if (luo_session_finish(s_files1_fd) < 0)
+		fail_exit("luo_session_finish for '%s'", SESSION_FILES_1);
+	close(s_files1_fd);
+
+	if (luo_session_finish(s_files2_fd) < 0)
+		fail_exit("luo_session_finish for '%s'", SESSION_FILES_2);
+	close(s_files2_fd);
+
+	ksft_print_msg("[STAGE 2] Finalizing state session...\n");
+	if (luo_session_finish(state_session_fd) < 0)
+		fail_exit("luo_session_finish for state session");
+	close(state_session_fd);
+
+	ksft_print_msg("\n--- MULTI-SESSION KEXEC TEST PASSED ---\n");
+}
+
+int main(int argc, char *argv[])
+{
+	int luo_fd;
+	int state_session_fd;
+
+	luo_fd = luo_open_device();
+	if (luo_fd < 0)
+		ksft_exit_skip("Failed to open %s. Is the luo module loaded?\n",
+			       LUO_DEVICE);
+
+	/*
+	 * Determine the stage by attempting to retrieve the state session.
+	 * If it doesn't exist (ENOENT), we are in Stage 1 (pre-kexec).
+	 */
+	state_session_fd = luo_retrieve_session(luo_fd, STATE_SESSION_NAME);
+	if (state_session_fd == -ENOENT) {
+		run_stage_1(luo_fd);
+	} else if (state_session_fd >= 0) {
+		/* We got a valid handle, pass it directly to stage 2 */
+		run_stage_2(luo_fd, state_session_fd);
+	} else {
+		fail_exit("Failed to check for state session");
+	}
+
+	close(luo_fd);
+	return 0;
+}
-- 
2.52.0.rc1.455.g30608eb744-goog


