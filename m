Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EBE6CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 03:29:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDF726B00A2; Tue,  2 Jun 2026 23:29:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D90046B00A3; Tue,  2 Jun 2026 23:29:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBBBD6B00A4; Tue,  2 Jun 2026 23:29:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A938B6B00A2
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:29:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A65E40159
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:29:28 +0000 (UTC)
X-FDA: 84837171216.08.BCF087B
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9C0054000D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:29:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NSTtT7eZ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780457366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZ44uuKaEudMkx03Nujcoh6Uuv+6Qpcd4aVYSw8wkq4=;
	b=WchN7Gk3Yqrgo3DnIRNNpahsG7iOUmA7Okq8V3PIID3XDgVQ/KCXHNR+2z+GOUHoX6Y6ZZ
	QbxA7tadbxOVMa7KuZNMpcuaIXblSyLZnrQ5T91mwUAuetDswKNhemccU9Sga+TUJF6p8k
	G0OWR1qGy+E/dLfyWYeOICrsn8larX8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NSTtT7eZ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780457366;
	b=46jmG7SYdOwVaS0az6k9ihX6qVL3SVMdpOD+L6OjL4dOFK+AtQgtxmpgFmkmc1BGrpsLzF
	8G17QnoTqvT0V5z/BQ7PkJD61vYaTJg4IDQZYTHLjTQbIYor8ZzHgfFuVk3mecny0EeusT
	mYToZ1n4nLufkhPAcINxv1rP4uYiy8k=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8ce9e56f68cso25595686d6.2
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 20:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780457366; x=1781062166; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LZ44uuKaEudMkx03Nujcoh6Uuv+6Qpcd4aVYSw8wkq4=;
        b=NSTtT7eZ8CnoqDlXQAtudVDlT3pNy/nUfdkHQRNtWAhFLO65nGUPz23YhY1X5U/06o
         NdJVya4IIZo4/uNASMPDHgv4opEcYIDy6DCPqi8S2LVHf6ISFo49lqV1dhcx3SQMZTkZ
         HLGJzLiYCPsShFaapg2A5nZ79/jXl+89c8Iw4tAhPEvz75h9BuM3oFOfqpd8f5O9Or+p
         FEiY45oEqM2QM1zpR62oHkzt+u6sT2xW30aTTpPdvaKdn4ke6G3mKu7K/aG6brL+9lNG
         0efU78h0bP9vu8KI6j6i7Z8uhYraxQ+Szsi1NwlMeZhW7/YgRkmDz3avibCCXDcQI+1c
         MkeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780457366; x=1781062166;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LZ44uuKaEudMkx03Nujcoh6Uuv+6Qpcd4aVYSw8wkq4=;
        b=KkioqzQ6z8GC6obkyxeerEALAeevYyVzf0tDsXBp/GwDVK3gcAmfzpjYXEc4K9JEqn
         lCDjibcFQDKOgTgryrt1u9J6BlM3OwsvdcPytI5PKmSEbWoOwdqMb8AnzgxAOIKKKAYA
         nsmE1n61pdf1dDXIiDJtObX/yPS5sHDvASkaBjhGqe8ljF8bIS36oiKqCG/j8Ab3PoG3
         9wNct6xW1WvNO7kFyPf4kcXjXsrWOq8lEsgCsASIRAyeMwNkG/XfHT4nm1Alfok4YZdv
         rrGVTAqHobWSuKoOZSIkNkPmVmtyHxRZI1TqAw6kSgfbIY0vid6PgeG/6Y29GRYcFMam
         /aAQ==
X-Forwarded-Encrypted: i=1; AFNElJ9h9MHlL8U9vbbXdIbcOlMD702dJ0oa/mtBciEeLO0GIEhIp8nBk5/BCITxIBCqzcznN2THHe/LVg==@kvack.org
X-Gm-Message-State: AOJu0YzYGtEJx8Esb714G6wT2rNxuVcI5JbfFaV0HV4i/oi3l3KRHrTP
	jgqxRNvLVAogkbQUZ/FYWtzOEhX2h8ynUlc5YeJEMKIvM9d6MvUtRGILxKxGWIo5uDg=
X-Gm-Gg: Acq92OEcHdra0BO6p7G/2fbMYG6mtHEQuxkZUBYuZcgnRokzXHeOOMhZ8/CXr44jz3F
	R49SQyhIKRmaSBCroRwCdc/zRsI0FAD0QSxEhzp8DAkc2rRJG4GdzcMbQVRT4byfzgJ995Mzdg5
	b2D1QfM/HRLqrOaYPzDNra+CPbVWrZtrnCNxTii6pFdG5gUUvgRCMicPfgMH+FydZ5JYvNlQ6jf
	HHj0k07IItTX59KRvcszjRXM99NtjU2qOLLijBdyDe5MtLTj7WhNa2FHbVHZG6FDDo/M1jWhk4P
	X/g92hY2dils/r/FgEg3agZHFNYYKOomV6JEXGSKpUZgkQtP4R6lZXvd12BNIYm/4LMxlIy6yir
	orwOc7JLBj/fVFHFc6HHB8Y/g9yOS/6H/vAZZuX0oLNtVTPqEOZf2KXQXX8z/uQXRqDC/z4QU9N
	f/d2VEwWiXcfkpqhMKLuwPRjo/OOZAG0bO3eRk7Jcn6mgU2Dk3dUUCWRFHqoUdxw==
X-Received: by 2002:a05:6214:500e:b0:8a0:4e92:c45f with SMTP id 6a1803df08f44-8cecdc18097mr21849986d6.11.1780457365747;
        Tue, 02 Jun 2026 20:29:25 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd26b3b9sm9244566d6.45.2026.06.02.20.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 20:29:25 -0700 (PDT)
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
Subject: [PATCH v6 13/13] selftests/liveupdate: Add stress-files kexec test
Date: Wed,  3 Jun 2026 03:29:04 +0000
Message-ID: <20260603032905.344462-14-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603032905.344462-1-pasha.tatashin@soleen.com>
References: <20260603032905.344462-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9C0054000D
X-Rspam-User: 
X-Stat-Signature: x8pcogoke7xmemj9hxu7fmyz9auutpr8
X-Rspamd-Server: rspam09
X-HE-Tag: 1780457366-284472
X-HE-Meta: U2FsdGVkX19r6T1VU0QGqjHS/QC56xRYaFooyZg0x69T8U882On2l4XU4v9CAqODOU3T6EHGGkZqUBwaFXZQX9MXj10ojACRARaJY/Qat21ge9pgDNfbD1zrX/mQS+tM6ujttEbuyNq2UG74zFUM3oU9tfmioa8KBIQzusj0qciQe8p0nwRl49u3x9aAMaV5n3Re6L6rWTtRflewWUgbtmm4y8zmnsw83fG0AeYLgHojWUrjZXSrsSC+4iDSdf97sbqDXf3tmC8NPp9/S1FTo+xfyuCb6HxicUOzu60Z+ZTbdklRDyzfJ5YabmwJqTEAQJYbDFz7JNPk4NZnY7myhV9bt/h3n0sIBR67FYq7QeoUGutKZsMH4L/YuQrAnWC1+WkEtuLIvNsY/DbScqZPbsiEpzaVShTWrPYoQc2qGN9BxleY6uDcLBTR/WpqcgRDIN+zonQ+NEXCqcFDXJ9//q/8Iqwqu7SoAVnRocQ7xpy8621UsbP5SvASjQcNOJLKtnlkrSTOU+q5wJ8B0suOFu1zo8H88Th9AzsA3HEnTNcpfwA4MTprN4jT2CwENRaRpUi+qAIKkvQTupq57BiP+9i7uTbyW64Ia7UgWLzAHnghdW5O/Jw+X4tO5QApOzZ0ZlGHQMWwkpKpoVNcVrqRZeFNldzSoEWiY0MmQEN5PlYPcj5ZiRl2rTQJW8zT0+nuHudsp1Z4UvbcgdDIGeufpb0Sl8azB6gD/R0kLDc8/FmFFI0btjzbFyrsMQLq/H+VYhqtI/DZZcl82N/XV36RpaaFdTP/nEJlZevTtfAQAL7FJqUppVHWLCVtPsrqCCIgF+AUa4yw6EtaPwBVIaUv3usCLddvUDMK2DXm2XkEIIG5kVNXpB/nn4uZvYBXBHU4moQGN9wdw4/a26pNJJ/4Mk9usYR/eBB5n7Bwjk6zuLVrvPqWPwdTvdxjIhahOYdoK+vH+KRESwLn9s3NXWJ
 NX92bLMF
 tO2ozS62Vjick6StRuilgOXfDngEn2w46oNdJHMEkpbBZK2wt9ijESN3KWmgseop5sVKGDJS412lDyUDpgWziNjVy3plj+AXIIIGBhKNUl6SSkW/2ek6O+ZAdPtso2XX+3Uy9377GZUJxWl5Nhv1GzHGTNxDDQ+ml/oFz7ilZUv7dFQLOX3ktn8x9YbH7WJ75akMga34XjYQftjw3/SRYQ77zo5dkAHzaK8mOAansfUXi/+Rj9rmLAl4nGaCdwtwbxVP0MeeWHMMI4Qz4Un8olx940Sb41+Ah21o5bjwDBi9OHLKTeWZCXHDJqMVbY31U3p3MBYYloSJwbCQCEdM/y/JeO5h0nOJLPPn8
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


