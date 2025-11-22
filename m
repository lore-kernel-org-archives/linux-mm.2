Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66764CFD313
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 22:24:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F01396B009B; Sat, 22 Nov 2025 17:24:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED8616B009D; Sat, 22 Nov 2025 17:24:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2A7B6B009E; Sat, 22 Nov 2025 17:24:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B77A26B009B
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:24:34 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 891E61A02D7
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:34 +0000 (UTC)
X-FDA: 84139673268.07.BDD1B42
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id CA26140013
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Cuc1y7+7;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763850272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4XTUTAjFFy7b91C6Dw70mD3UF1HxwVkQgHbYFhkd9nI=;
	b=o0zG6WDTJAplSFjCsm3BDnDfDssxqmyDhHjVoKbyo5V19EYWxuCt8v9jtx52xQW2QIt8Bd
	zmrOmi4JRpUJ7C6cQ5/e1gVQRcxiEd+h+WgiRe8fTjwz0cVgioE4AsFbGVKOesrz9J4L3S
	o743H9ieAu89/6p4v1iNqKhf1h19uvg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763850272; a=rsa-sha256;
	cv=none;
	b=HVT+YTjK+aenc9yveYYUxGe2GvaNHz5ueemWNI30A4E3gOb09xxeTt3p1JLN12mU2Ak+UU
	zT8/fiSEcUUjVm0dRtWR6h8au+/Hk3K0SWhuyn1s0MZ9kg/DAjROzaq1WbHj2LelwXJmRj
	tyluHQUVXj/lSn0bUTqwTS8QbdpyWf0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Cuc1y7+7;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-787e35ab178so30360097b3.2
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 14:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763850272; x=1764455072; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4XTUTAjFFy7b91C6Dw70mD3UF1HxwVkQgHbYFhkd9nI=;
        b=Cuc1y7+7pjcB2XswLKOlQEpPNx7DZ/CEWXvzU5ISkC72ksIJXX79X0CyUz8yvOoPr3
         qH+TXvJCwDAnd5bejG31rkI20mNDsTZ9Y5Obb8YhsHIca8/z//tVgvT4gUpOWNSsUOKB
         4Qb1y4ECeXKSWQLEYlBiz20oecUqELDTQot6HguaVE8MCqfcwMIOWGzBoKjYBZxzSLXq
         zdjuavmx0drCD0GKwQwFh6hzRVd6ZxjY/0pP+AImxGqbheF4Drlw5nsqg6qyPKyuxA+e
         ElBbPKQXr6+p9tRuRQBdROPsFBnRW7832aHMIJYX6nl7scTr1pRGbv5GAQ1kGZvegJ9n
         UBqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763850272; x=1764455072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4XTUTAjFFy7b91C6Dw70mD3UF1HxwVkQgHbYFhkd9nI=;
        b=Gv/kefGVKDz6chBhy76Iv4gm9Lfl3TvP9TNG5cFEldNTL+6mdABlZXgvApTslc3e4P
         8YRGpFn8whozm3ZTGy9RB1SICkE2cXNVkIg1cmLDMjUAV9pzRpx+jZDc+ASWIsMZl5m3
         7c0Ft19LV336p5L64DKgFtgGYuI1Zy8LLNZVzNVMMVv9RbhMoFcgrWBGJEcEv3GIx951
         UsHqOGB8u0V6TrYOxC3MpRlvXYMDRbnB1DUg8KceCkhJr8bC2mfNkqyPrOJuQOazpo2G
         YSEhGLbP5G7q3hCbyh9vA19hh3O41yeF3c5AhfZelq+9JvJ82eTLNlTPEcMi90Vh5s7B
         6T7g==
X-Forwarded-Encrypted: i=1; AJvYcCWbqRmB8bLF8VkaBS7W9OG+8YdKYtSFoWOjm68+Pj5Vddhm2aR4jeG5EkYUK+g0HOcc8Ozd5nTnDg==@kvack.org
X-Gm-Message-State: AOJu0YyBx6Hbn4nr4JrrxTOH6AXDbyUEeckm+YSq7CWflMzd8HfZYISx
	CkTXuTiY+C/eafU8WRkjeC85b8UDkuAn/VHXRiy6uN9Tzz8gITsxbr9cPSIP/0OEfk4=
X-Gm-Gg: ASbGncs22y37js19lw6HTJj0dCz8GqHNxmY42Sh3mcDoqf3T1OHWJlLc+MdQEKcaN4p
	XLqOJjTb9/ypOMmM2PLAklu76TUW/UIEkZORhkqffx7nJ5zUPHNOnqnHgDLdSztEzJnJmIFlozb
	kc5WIIHCPO5beLwxy3wWD4Vkdyq9m0AKgzdgwcHoSOiQmh3sZLkm60QS9i5vJ2c/5Xhl32gsC8B
	q0iJBm+ZwazyUzlraAW8nklIEZ2/F63O4qAUnN7beTopX3XCKCY38LpLaXHh+1Sa33APAiWWkHL
	/OdtjAfMVRkP+2VqtEWIkBMEs6nATiZHaYjcWFfzDuv7h+0/twPPc30oVEfdETzjatqHBP8vc1N
	otYG3JpbChWmL1QMnF8Xz7wrJDiVqxPcswJbkpjmDO+ozcIbcc4PSiFC0jLBGBm1uCmqJOG+zVa
	Eeace130ZhAfKn1j3JKQbL8tHlBesgq6qsKtQPwsoQAEFisDLu0mlJyFMbzjiMo7iplLjLt9qJI
	fXRU6U=
X-Google-Smtp-Source: AGHT+IH/eqBoS3mqhMhh4qvlka6WRIlDgWiw3QW9H2yTNLjxyq2DnfCNF4kdPEPBkXHTMSk/UtfxGQ==
X-Received: by 2002:a05:690e:4286:10b0:641:f5bc:6960 with SMTP id 956f58d0204a3-64302b3f670mr4232320d50.76.1763850271944;
        Sat, 22 Nov 2025 14:24:31 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a79779a4esm28858937b3.0.2025.11.22.14.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 14:24:31 -0800 (PST)
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
Subject: [PATCH v7 18/22] selftests/liveupdate: Add kexec test for multiple and empty sessions
Date: Sat, 22 Nov 2025 17:23:45 -0500
Message-ID: <20251122222351.1059049-19-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
In-Reply-To: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: abeuewjzebncwsf5b7mz1nd7tiwa7hkt
X-Rspam-User: 
X-Rspamd-Queue-Id: CA26140013
X-Rspamd-Server: rspam01
X-HE-Tag: 1763850272-212026
X-HE-Meta: U2FsdGVkX1+8xckxh0yPn+DVUkTXgxkt9vMCjDHK4CUbfNPw7iD0ESDYSZuXpXlkYRhkN0lYKIKXlj7NZaqiq16eLO7+qD1WQBixILQhvOGr+7oxewkUdysXS6N3sk+ywzp7ieFXI61m7DfbDL/AyjFzP9rWHGj2RhKSWB38uVTHAQJA181kZxAif1IXMojfoDp+NzTaFexqCmNJIjDlRxTPkydaA/feMd4zZLAZa5U/V0W3tmL7LQSYTarHRHFe04n57p3roBqn70DK+Hw9ZfOmljEEa5ZIB3vTlOV9vDSdxkZJXd/psDnr2geY/A7euV4VIi6n8X2ac5jjtW0fmF6UwQDwirKj73z+BmYs1pHLvmzM4PVRBGwMOHbR7hslDGdyzC1vs+rhjSzEDVDHGWLcJAqbHaTYMqdYlgKp7njMj2ux+hXP/LQefAYFmA2Crp9Hk9LzTDc+ldWVn363deExWmQPLygu4cYylZUeCIPaMwiQHPSjTqDqRyd3/Q3PYhdndos5TxGcK/uO5RBJ9fSRu0soKn+9GuhoLxxbZ0IaoTuwFqHcWD7niwUtbo574NJZMUMKet87ql64PanQZbQpeSpKHlPBLFP214rlbErUFiSSbHOg7IcI+Va5WS9coKw5P/AbIRR4MoMWlh37wt2pRZS9JQedzVtAJR69EfIzyfJvtjHAsvmmc0l5FAgGAG+rHuNTvv83ZXdSOheoXfdAZ2CyG1oxHuFDPH+OgstFPUNW02XCRmc1durkRlcwdgKEchUQNO6Obb/q6d4R/T9WRfORso9ZBovVJ018WoK5d5NchYfGVMUyy9bh3bXn/SIJVb29BMA0Sm+cSSrARN1GqGVaSXaNuvhc/Eq0ti/E7juGzCCbUtOpiauSJoKaiK3djl/c2H+ZGfxneGf3xTz00cDrsrsSbj2ECOkSyXKreQCr/SurVIBE0puchNvlwMXKMqXwLdNrE6aD+lN
 NorI9JJq
 XfEm4NP71yFOlujZdBUTDjkmZBN7Tfbl52xi6sy7R/l6g9f5yPdEv7Be8R3BzdEu+yMlJMc7lTSbQlFHuG/1BmhXJIFlNxnV3JjahXiX0OVG+n0zqYQtHmKHleBNeFwMlqAYhQZ8lJqmIxl2Yv5iwcbYEVl9woOBkvTDHNuIygYwki+lpiXyWvP5dV2AXeiQ6uHHbDccG4/IGrG8uTBGg24oLj++kSUfRgY3u1qoHiGmhdunCUE7uhTOqYmgqHf3srUlU3hWZ0Y2e7TuIvxgfyGP8yvijVlBEJl/L+WSaeCsW55hjzii+wG5TUZifaCR8yyhHcTNfVNhRpopebzkAci+ECTQgZ3Xwx70hOt8sBwUajs3+QeIol5NSkpfCO4xMT9CZJJjJaaNmpFk=
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
 tools/testing/selftests/liveupdate/Makefile   |   1 +
 .../selftests/liveupdate/luo_multi_session.c  | 162 ++++++++++++++++++
 2 files changed, 163 insertions(+)
 create mode 100644 tools/testing/selftests/liveupdate/luo_multi_session.c

diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
index bbbec633970c..080754787ede 100644
--- a/tools/testing/selftests/liveupdate/Makefile
+++ b/tools/testing/selftests/liveupdate/Makefile
@@ -5,6 +5,7 @@ LIB_C += luo_test_utils.c
 TEST_GEN_PROGS += liveupdate
 
 TEST_GEN_PROGS_EXTENDED += luo_kexec_simple
+TEST_GEN_PROGS_EXTENDED += luo_multi_session
 
 TEST_FILES += do_kexec.sh
 
diff --git a/tools/testing/selftests/liveupdate/luo_multi_session.c b/tools/testing/selftests/liveupdate/luo_multi_session.c
new file mode 100644
index 000000000000..0ee2d795beef
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_multi_session.c
@@ -0,0 +1,162 @@
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
+	close(luo_fd);
+	daemonize_and_wait();
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
+	return luo_test(argc, argv, STATE_SESSION_NAME,
+			run_stage_1, run_stage_2);
+}
-- 
2.52.0.rc2.455.g230fcf2819-goog


