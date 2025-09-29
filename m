Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D011CAC5BB
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:05:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 588638E0025; Sun, 28 Sep 2025 21:04:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51DF28E0006; Sun, 28 Sep 2025 21:04:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EF828E0025; Sun, 28 Sep 2025 21:04:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B3748E0006
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:04:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C8DA185821
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:57 +0000 (UTC)
X-FDA: 83940493434.17.648517D
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0D6681C0008
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gJpvDY7Q;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N2v75INyzNMPI4oEdp2NmuGRVQWzF+umEVMJPwM0ApE=;
	b=oXnY6aLjSc70DTjMinQCmQrVvKC6FvFmyiP7UhhNaIhREL3itniSPT+YaQz8oAnT1mUT11
	bWLzD2wECHIVnPNYvudi71DVGejEw+xIqwcWCmwamKss3crKzvzwaTFCNx1hCRmyGPd8GL
	iYYhbPgUicCywBCCdM4FaCBrqwJtia4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gJpvDY7Q;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107896; a=rsa-sha256;
	cv=none;
	b=Lm8mau3wQkywYYmY8ia5bBU78PxXzDR23aXiNSMLjgp32vc6bCOaLtFz7iduwLE14gk/4h
	F9fWOwaGh4WVfTCrrAsqbCfPEi65pGPWvQHtvYo7eiedlBq4W8GdYbgPtm/ISCwfi5gx4M
	HoDcNmt0eR9Be3Zom3N0AvDf1U/5fso=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4dfd1f48d4cso7220131cf.0
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 18:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759107895; x=1759712695; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N2v75INyzNMPI4oEdp2NmuGRVQWzF+umEVMJPwM0ApE=;
        b=gJpvDY7QdocW0oCNenkjzsjnIsersRoI0cjP3kOMFk1auKISy7V7TMuGLInkOXe+dn
         RprRxFiF5+oA/PMjiIfUXKYlc3W66UGZYqt31uquiSSmwHnYfwRjt/8MgKPZ/UwJv/d0
         fQGqGKC21JA6GSm6dr6+x1/GxMaPSgcbLPuBwogaDCgJddn3rHjDbwbkP5sijUVYJvk0
         RWMuEwlnEBWOVWpMsmRJ0c4H9cxcnBALB+ShPmyE9OfHZEqAioW5gQrN4fINOlHXVkAD
         02WS6C/thuTK30oL3KcQE8rn1udqcb8xX93hOlJoS/URlm4po29C2N71U53LaCbD9Xr5
         uB+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107895; x=1759712695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N2v75INyzNMPI4oEdp2NmuGRVQWzF+umEVMJPwM0ApE=;
        b=AosNtqSwYRCOSFkGEWVMMRKiM1Mt8ib3jp+Qhr4NPPIzM/1g4UxIxpYFQmCGcR8CjD
         2cIGAbj8y5Svk642aR8GB6rakHEilmXn87EufjiLHYgNNbfUc1esA4KMQSI3s84JthyY
         xVej+75Lghv4WMlP7ePyxjxXOEe18SLhl8NGqGEhISrOCf6cM6axUIaKfJS/0ZAUe5fv
         wUnaU5XKCbMBKZPxkZIYxQKgMcEmKWEPv2J7nD8/706/HE1jjV24LOG7iq/rLc/LJJLF
         qkPw/YMMBVmAHjEZoxivL3vxSGV8Lq3Crt8dmwktSHXtbyyO8pmDQlI505/lhGMJErZn
         7s3g==
X-Forwarded-Encrypted: i=1; AJvYcCVDu7Y68K173Rq4vHN4+e+nQRaj/V5Y588GMX/93VP/zNLH16JfQTLGeNYjH0116lAU+cVBxleKbg==@kvack.org
X-Gm-Message-State: AOJu0YyLa7YT2RE1yK9gGcYOkxvL+ngpPpRaEgN2x8mJhUA59ezHtnuh
	HNLvuXPWPE7ONKkJUB4jMF7au3KYwvTdiFR9cMtyIT0MThIXYIPffPPA7yhKZqIaCAg=
X-Gm-Gg: ASbGncsCrZc9YmIMO1DZhdkzcamPHzva1iGCK7+HO4XeUlWZ6JGQYBROWTRQL6YoUzV
	yZa3tXMrwN0xFskrgu9sLq8M00Y6GNTL+T9/+mDm9V2f+l1dviCKhKuXaE3lY7lXYjr7imI/t9U
	nLdOT4E6G0cp0GU1bQ8LKmaF867cdd8ihsxaq6Y9TDYqfL0DUfNAo1YfRwMsDIinE2h1WqoUPjM
	C0ek2alfw2gEBxbO0Zp35uBGNUyrPAdr/yjMO3HjskpJbWxfFfvXZvilDhI54gcQ9paExh31t+h
	tjqC4kNijjUKbgV0Da8TD2QZEDKj8eMi57KbhJBGut42sL8+nddYG02AnYuy5Vp7CIoIKWpLkHx
	D9Qh2yBUOdwZaLv73eG7ZTj7dqpLLFCktAHb1iR6ZoZIF21MpdlRNj1HKrGEXjKJpoGHNWIhYPO
	J/59dDFz0=
X-Google-Smtp-Source: AGHT+IGNYpnFHhEDZ7IQxe60li51JF8Ceu8MZliO1sqTV6jJCplnwCE0LZP4epB2zRmz4aDw8ZyDcw==
X-Received: by 2002:a05:622a:1e89:b0:4cc:d6f0:2e41 with SMTP id d75a77b69052e-4da47354de0mr216005241cf.6.1759107894911;
        Sun, 28 Sep 2025 18:04:54 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0c0fbe63sm64561521cf.23.2025.09.28.18.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 18:04:54 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
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
	zhangguopeng@kylinos.cn,
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
	chrisl@kernel.org,
	steven.sistare@oracle.com
Subject: [PATCH v4 29/30] selftests/liveupdate: Add test for unreclaimed resource cleanup
Date: Mon, 29 Sep 2025 01:03:20 +0000
Message-ID: <20250929010321.3462457-30-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0D6681C0008
X-Rspamd-Server: rspam05
X-Stat-Signature: jo1g46mxr7aisn7cse7cxf7ow1iztzfr
X-Rspam-User: 
X-HE-Tag: 1759107895-831036
X-HE-Meta: U2FsdGVkX1/b/gK+/pE7EH3++TvVXL2NM0bGqQ9GDHDgWiKYc6D07vjF7wkzwH+id+El7Xp15pKN8lvbTM/35Uu3HdtXj+9ctxQFiPYA1Awk8uXkrO1lwtUujLyIwDkVnfHxhZDLlvYoGkJYJeNvKeaOSSJ9l3RfwwJBz0kk1adDg0cFxKmXhxPahtyLN2XGeyEvxLfGo1AenHZOl7oROKnOxeM49IT7zAaX3DSxMEXDZVhUSwSBadxdf2D3DbRWnz3LNtVRA7x4a0nR3Sn1lL6LdVEt/gQpG7vsk23LBBU6tQxsxvsQyUbPTD0zpGxsl7K9bwoYxQbSOhGxgDEudJ95Xeh668N8qx+vd/PGldGMG2BU9S33PdtAPfQwo4ZJvFQFfzgErYdtNMcf52sDGVw5XTJLdtih1ReEbvLdJYkHQpDGNo9plWghSBvrLnv8gdoyb/eFSfH72UBSoyAGv+dUmygw3yWwQ8EZIy+sTKP+TWyy85kvqMEHo2QTDKxgb1qUAMFhFiCZXcJ3An1KMCsiUhg5u5716wvh6IgkxvnFOFZ/OWrljdZFsc+rIcUvjfuJIJRqSmjOKpL1MybkUP5vl2PU5M+E7yNHYYM8z21W8/psowKEynUyXvxAuN5algPRB35XRvQ3uhFZ6jq781tfZHtMVz/UuQ8mR19sKDn74Z9Zl9NwKOcBIjiVNmrm+3ThFYPCQO2qCI4BfEnrxi/MhSI9nqrQpIobvYN04pv/GYpRSGVN4vyNrfIa+ochnG4ALEN/zX0YZb9m3KwC2lLAZ7vaE0JfibWldvPZXI4nR3QdsV9jcLTpyoixm7lmOvbqvZe7VhZXkLyjzIsMSoAAqzbQpNRRKvZr1xFEBnRfYfN+ZJj7xd0yvewqQAuSyLVDnoulpWfrl0POWpOrpk265SLupwy0yf19Ye+cBrGMnx1+f6MccVpnJ1BJzcXh4KMDIYPqAjndQGcNZO/
 i6zgBVXE
 mgkKAmDCR1XnXrHt+IUBJjkRyuG48x7FKoi2oDnBjaKA/xFBQjzGryzph6ygYHLwYgVHZkWaWqplzQAYrtjbhFonK8TNnukHbkEmBlmylNVbkR9vj5wTYhOQK6//N+tbUDuydoIf4RFNJz2NIVUhU68JByXgSm7Q2UUjZfG2a+twG6znElXg8wjEjc1fIn7L8oC51W7r6r0IOrGKsFMCTcEkH4YKNIonNjueKNYDkRurlTfsDGZyyN4rpKzc7C+G7a3cRhuo8Z53Sk9P7XEt8wET8NmgivIZKuVgpeGn51+cnQY4g4wImM7EQZ5k/PzjFZUonv4CtyyBEl4+5XHeBOGP6j9Y1p5IgN/NMqS9ebalka5JSE8+CwyngkRizXfJzvuKbFjl8rH4Q43f9IkgqOfDx7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new selftest, luo_unreclaimed, to specifically validate that
the LUO framework correctly identifies and cleans up preserved
resources that are not restored by userspace after a kexec reboot.

Ensuring proper cleanup of unreclaimed (or "abandoned") resources is
critical for preventing resource leaks in the kernel. This test provides
a focused scenario to verify this cleanup path, which is a key aspect of
the LUO's robustness.

The test performs a full kexec cycle with the following simple flow:

1. Pre-kexec:
  - A single session is created.
  - Two memfd files are preserved: File A (which will be restored) and
    File B (which will be abandoned).
  - The global LIVEUPDATE_PREPARE event is triggered, and the system
    reboots.
2. Post-kexec:
  - The preserved session is retrieved.
  - Only File A is restored and its contents are verified to confirm the
    basic preservation mechanism is working.
  - File B is intentionally not restored.
  - The global LIVEUPDATE_FINISH event is triggered.
3. Verification:
  - The test passes if File A is verified successfully.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 tools/testing/selftests/liveupdate/Makefile   |   1 +
 .../selftests/liveupdate/luo_unreclaimed.c    | 107 ++++++++++++++++++
 2 files changed, 108 insertions(+)
 create mode 100644 tools/testing/selftests/liveupdate/luo_unreclaimed.c

diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
index 72892942dd61..ffce73233149 100644
--- a/tools/testing/selftests/liveupdate/Makefile
+++ b/tools/testing/selftests/liveupdate/Makefile
@@ -12,6 +12,7 @@ LUO_SHARED_HDRS += luo_test_utils.h
 LUO_MANUAL_TESTS += luo_multi_file
 LUO_MANUAL_TESTS += luo_multi_kexec
 LUO_MANUAL_TESTS += luo_multi_session
+LUO_MANUAL_TESTS += luo_unreclaimed
 
 TEST_FILES += do_kexec.sh
 
diff --git a/tools/testing/selftests/liveupdate/luo_unreclaimed.c b/tools/testing/selftests/liveupdate/luo_unreclaimed.c
new file mode 100644
index 000000000000..c3921b21b97b
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_unreclaimed.c
@@ -0,0 +1,107 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#include "luo_test_utils.h"
+#include "../kselftest.h"
+
+#define KEXEC_SCRIPT "./do_kexec.sh"
+
+#define SESSION_NAME "unreclaimed_session"
+#define TOKEN_A 100
+#define TOKEN_B 200
+#define DATA_A "This is file A, the one we retrieve."
+#define DATA_B "This is file B, the one we abandon."
+
+static void run_pre_kexec(int luo_fd)
+{
+	int session_fd;
+
+	ksft_print_msg("[PRE-KEXEC] Starting workload...\n");
+
+	session_fd = luo_create_session(luo_fd, SESSION_NAME);
+	if (session_fd < 0)
+		fail_exit("Failed to create session '%s'", SESSION_NAME);
+
+	ksft_print_msg("[PRE-KEXEC] Preserving memfd A (to be restored).\n");
+	if (create_and_preserve_memfd(session_fd, TOKEN_A, DATA_A) < 0)
+		fail_exit("Failed to preserve memfd A");
+
+	ksft_print_msg("[PRE-KEXEC] Preserving memfd B (to be abandoned).\n");
+	if (create_and_preserve_memfd(session_fd, TOKEN_B, DATA_B) < 0)
+		fail_exit("Failed to preserve memfd B");
+
+	if (luo_set_global_event(luo_fd, LIVEUPDATE_PREPARE) < 0)
+		fail_exit("Failed to set global PREPARE event");
+
+	ksft_print_msg("[PRE-KEXEC] System is ready. Executing kexec...\n");
+	if (system(KEXEC_SCRIPT) != 0)
+		fail_exit("kexec script failed");
+
+	sleep(10);
+	exit(EXIT_FAILURE);
+}
+
+static void run_post_kexec(int luo_fd)
+{
+	int session_fd, mfd_a;
+
+	ksft_print_msg("[POST-KEXEC] Starting workload...\n");
+
+	session_fd = luo_retrieve_session(luo_fd, SESSION_NAME);
+	if (session_fd < 0)
+		fail_exit("Failed to retrieve session '%s'", SESSION_NAME);
+
+	ksft_print_msg("[POST-KEXEC] Restoring and verifying memfd A (token %d)...\n",
+		       TOKEN_A);
+	mfd_a = restore_and_verify_memfd(session_fd, TOKEN_A, DATA_A);
+	if (mfd_a < 0)
+		fail_exit("Failed to restore or verify memfd A");
+	close(mfd_a);
+	ksft_print_msg("  Data verification PASSED for memfd A.\n");
+
+	ksft_print_msg("[POST-KEXEC] NOT restoring memfd B (token %d) to test cleanup.\n",
+		       TOKEN_B);
+
+	ksft_print_msg("[POST-KEXEC] Driving global state to FINISH...\n");
+	if (luo_set_global_event(luo_fd, LIVEUPDATE_FINISH) < 0)
+		fail_exit("Failed to set global FINISH event");
+
+	close(session_fd);
+
+	ksft_print_msg("\n--- TEST PASSED ---\n");
+	ksft_print_msg("Check dmesg for cleanup log of token %d in session '%s'.\n",
+		       TOKEN_B, SESSION_NAME);
+}
+
+int main(int argc, char *argv[])
+{
+	enum liveupdate_state state;
+	int luo_fd;
+
+	luo_fd = luo_open_device();
+	if (luo_fd < 0) {
+		ksft_exit_skip("Failed to open %s. Is the luo module loaded?\n",
+			       LUO_DEVICE);
+	}
+
+	if (luo_get_global_state(luo_fd, &state) < 0)
+		fail_exit("Failed to get LUO state");
+
+	switch (state) {
+	case LIVEUPDATE_STATE_NORMAL:
+		run_pre_kexec(luo_fd);
+		break;
+	case LIVEUPDATE_STATE_UPDATED:
+		run_post_kexec(luo_fd);
+		break;
+	default:
+		fail_exit("Test started in an unexpected state: %d", state);
+	}
+
+	close(luo_fd);
+	ksft_exit_pass();
+}
-- 
2.51.0.536.g15c5d4f767-goog


