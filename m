Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0334D0EE0F
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 16:59:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BA2A6B00A3; Tue, 25 Nov 2025 11:59:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8906D6B00A5; Tue, 25 Nov 2025 11:59:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7592D6B00A6; Tue, 25 Nov 2025 11:59:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5525A6B00A3
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:59:45 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2263C1602A3
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:45 +0000 (UTC)
X-FDA: 84149741130.03.BDA2123
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id 430AD14000A
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=M6a8JFpm;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764089983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6vFlri8REH/qac3zTP1mpTsu23ZBhs3xYfWJv9me6+k=;
	b=AeDN09lvvV/WkmmVMrmImo1XPAtQF3phE7xZP+n63q15bk4iyJucn0K3SxjFemP1KsjVEn
	D8n9Fax9wJIL7nN47iPRDNxHp3U3h6XpXFHAboKRrKUlq9ZQkQin84D0zOjEU+cpP28nsy
	c6ij8gQsQjJLpw6xdKNy7en3XUDbdck=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764089983; a=rsa-sha256;
	cv=none;
	b=Xxw6G/x33w010689NmY35SbkgsNkxHporAqF/EAMBB+eLiVgQ0fQLnEIwr+ESePZZYyLk8
	PcFuMGBjoIXsxVv/dGLaF2HVQkqcDtOXq875cVwScnxD+wwmyntryacaRzx8AM5gAJtTNf
	BXS9U0XpNHM1XvsDLlSvXR0gBQoDYB8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=M6a8JFpm;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-78ab03c30ceso19923197b3.2
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764089982; x=1764694782; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6vFlri8REH/qac3zTP1mpTsu23ZBhs3xYfWJv9me6+k=;
        b=M6a8JFpm9s1BvoJTf/Q/o1u4Jfdrk6zYebN01Bnshmnln16zCLsquI+YS4hMvvjqBL
         ES5krLJHrcHDgaDy/Ek7jb0EyLkyGmmI/bwhMcDgvTWYIDUWAbAzIwx1mSUdtRA3goxS
         2RMOFKSlHaVSyBt43sJGxos1VAvD30x21dNB/vppu87/QQCUhED4lG2x6XZUw1jdRWly
         40ueA8p1IA3U4IHDxzNyjZ2PsQa+DWHsj/vKR4Rk//xuwkV834kCH4/NQBg/DnsPBY4A
         3I7jPEiczak+dx7TN6QdCIWoPCIMVxMJG7tjvV9DxHuqqhEDHk1+dRGwkr8kRqm2cMZN
         8e0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764089982; x=1764694782;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6vFlri8REH/qac3zTP1mpTsu23ZBhs3xYfWJv9me6+k=;
        b=Rhj7PyRf0zQpfw/eFEIpJONk6ST+ftPm3dNp8dpb9pXYli+TkfASJtYqfGoec5VpuR
         QeGA4MtUm5OXFrdduebMVOcBX8DdIBphPdMSOm9BnYxvaGDIk7QFGtM2V1Y6CEzNryVz
         JAGF1pB/vQOuQNogwySRE5YiLZDrMj2YwT+oS/XyYYfQZjJF9jVNAWg1w6M8f/is3/bo
         kb9y6jtcPKp1o1oaRtLJDIk6N5g4CJVv/Npzn0O87OC2rb4Zr0M7CxgvpqF7tONErnlU
         ebfm52Jbtvk1vJ+dzW6aCOCbPnI5m51FC2G2zq1srz0+xTvRTkoxpLVH7AGleUvy3pk6
         2+QA==
X-Forwarded-Encrypted: i=1; AJvYcCXAzl43B3o4NWN4EF1HZh7l0OxqJalW+rBf+8Q+5BssBpfX0QyWfjePxYJgN9JzuNtD5AHUb6bdTg==@kvack.org
X-Gm-Message-State: AOJu0YzfMswiIKH8gJnAqd/E8y9zLRkwC+P/bt/Pz0pbzJ1LNPBsvNpN
	Xzw04nQ79/i56jHynCPDz7iK/g11WxxlGWz2aAhS+KiUcktGMtgf9BWDapegd4ZsqPk=
X-Gm-Gg: ASbGncteVnZHXH73VjTFKgPyRtVXpntxWIUCU8uVWTcd8O0CpqEQ6874poQBN7Xws49
	qk14ClIt2572nFhsa58U4Sf0/OdUKvVBAs8Twz3DWlvM9tvIG4sA0VvE4wZ7t6Gs9Fy4Gy/lPsx
	cwFp20/coZbFoQ7FDeqHwPN35BQKhv/Wz+U+gKMMo+38iCiJ2JTTPucP7UAmKrQZEOxIeUm82eN
	O+pbX/syYMZLJhgLy7SqIqZgaiNLGgMq5dPA/ttXdxmAuVbtyCyDUT090FtqQHXUsS/01Gezoum
	rGFqEXpQl3h0/aqY8WbKB18/A0dABWpgQwA6YDHSuYVPpQ93FA7XFim8zz7fOGlhNaZx7z/vGpE
	HMbBH4aboRI5msLmM0R/vINlMf5dlUjWZTbWlw6/q/o0e5KHnVL1r1vqlz/A2oUiSBor/8Pr6Mg
	qC4l5zj0DnFGWgurGLzubmlkbZKOrV2/j22FifFyCeJz6CAnW/+KR+0TR5s2lc8Ug9QgU3Bvi1Q
	IA=
X-Google-Smtp-Source: AGHT+IHRC9KjSLkE1gdlWKz3GVcjnQbHxjnBnEjPOoxO9pY/zLR64stKUm4wy05jQAzAnoAL6WDFUg==
X-Received: by 2002:a05:690c:6c90:b0:783:7143:d825 with SMTP id 00721157ae682-78a8b497584mr142558557b3.25.1764089982243;
        Tue, 25 Nov 2025 08:59:42 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a798a5518sm57284357b3.14.2025.11.25.08.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 08:59:41 -0800 (PST)
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
Subject: [PATCH v8 18/18] selftests/liveupdate: Add kexec test for multiple and empty sessions
Date: Tue, 25 Nov 2025 11:58:48 -0500
Message-ID: <20251125165850.3389713-19-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
In-Reply-To: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
References: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: p9i8igmgw6eyns7aqmeh7tndyhiginj1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 430AD14000A
X-HE-Tag: 1764089983-583565
X-HE-Meta: U2FsdGVkX1/V7NKXMRFWT0e8jL0Ml8kDzLvaifaDNFkKvmw4Xw7gZvn/LfSV1HgDSMHSfWdzH4x1sjbNxfqpkF9vLlhlIuedV9uEVQfG1pKydyFKggW/6N11GrAHx9dpVgRlu+94CMFc8z42M2zW3Qy6ys2RJ5QXCyM4iLBfRS4BSVXaceckzsKMNrdV1WAXR603XJnAcIKMWNJR4uPAfwb6kNlOu18Fdd2FAA+RRqrup6PdKloOfFk6Cu13Hf8PEQS9o0hRCoTat5681LstSYFmuyFEC3gUsHF+EZJtEcMJKmK1aBkVYOpTktRZqqfJODoBtGcMnJPNso52MdtR+ngvCsNfNDur46GdU9m9T+F9lUQd1Myg8Wby+69I0TaCu950Gr6L088czEmO1NZU0XaVzxosldzKI8mzVm+tvugf/PJQXIlMuLxAuDnP20g4Ucz4F40EcP1HlFvKbWPVyxhfA+bTez6pEmWdmB5dbInT7rI/QmRHitqX1A4exj7zqKG1RZ2Ro1Lz6By/gyh28p29nIpLJ/lSm0xweV/E0FmJrSbu+5TaAqP+PgcY4VlY0wmwRCf7nvMky8xBgcraOpt5ZsL5wd8MVVVi+FUFw8EtKrbOferauwj6FqHPvoTD9xbsf8zHqTDwPsC4jVwG2DhAUbOaKwAuNSvhqbGLfWGxh+DoQ5KHuQZmgYN0kdrlCC+0vDzCSFl3SfDZAh+fXNeYtXIlpT/ggleD1lNXda3fxBGE5eG9KUCx+p3D/j3ry+rmob84L1aUtqxSNu2YhxP/6gy90qF2tSydEK74y8J4sEPEgSyMiJL6M7SXiAERyQRH6FzWXvojflSyQExYNF6SMlZ7rW48umIYHsx5ny5F7EHuk7twzofMwIwvtoqJnYjz8czzY/k3KlVazBK3uQNWgwQdeBX375OiF0BRLD0jUsIMqO1o5xG2+MvS7Yje8Vu9PL+yKtJuSwLlXVM
 Wv2yxXrI
 ov+FsZnM/1onb0perZuZuECM1Eqvhbe61fhkuFc+CUSHqaZ5XuoW+Fn/LaLf/ySaUuuFDLLYDTWyQuCP096I4KU2BkKdnYIizbSokNIuktryTd5IvlkP8fvTE2Xg2P3mYC+reZhLSQZWXgW0gGtc3RRCAFKgKgSvrqK1BY7L4Ho7ZgAoMvaqNwB4sHAGAz/n2yWoCYvLNwafkCHQ86VcXBoOeda0StCNVYB4z7gQGTHb7skzPEI7/GvZWIxkN0fPsyNNogt3TTJkPGqasIQq1xKDlU2xuTwHTih3bRy79X9JZxOeGQxIA4AxE57TWsfkLal9z412UwWwWF1dgcVYF8EtP4X7GaQz9r52xbjy0YtJ3NNpaxJ0/ZeVcmP55ZQuPECmFL25akin/vA4qqk3fUnDF9Sxj9AYTfO63+PyHq+BYPU4=
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
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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
2.52.0.460.gd25c4c69ec-goog


