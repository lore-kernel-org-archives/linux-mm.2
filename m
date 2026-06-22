Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9936CDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 04:39:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F1A36B0092; Mon, 22 Jun 2026 00:39:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8BD6B0093; Mon, 22 Jun 2026 00:39:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 906146B0095; Mon, 22 Jun 2026 00:39:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D3876B0092
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 00:39:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F213FA04E5
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:39:55 +0000 (UTC)
X-FDA: 84906295950.18.026B4D2
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2426F40009
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:39:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HInA5DmZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782103194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oKMHfcfhMGcxiR57N856X9q08MvdnvQ8rtbS1nGojyw=;
	b=Krw/5tNVx8sfZuJsjVrm0/xPbO2fdD4T9ghrBcUq1jNkFYsy3hrXophO8C7ZfSNMqMVUNV
	LsGcG90kGAOlVVCwxgIKgkq4i5Aeddb+3V0vJn+87/5xUUcpALe3F0o056aJYrD3cQ45fB
	SWdwR6tha0AT+drjwfK/GPCyhfkywKA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HInA5DmZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782103194;
	b=1meL/LToqpOqw6HR82wPlHu5plwoVLV2rSzXc3yjHTKu7ZJyhk7g/HSq7iYvcMy4k+0W92
	7Q9WfY32eymiVgcjuCgGAq76zPdrm39MnPojZs9jA0mKw7WOi8smnPhaGIn4huhXvcqaLO
	bpCfTfgIXcQFQvW2v2TtdufFm1sniQ8=
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7e9483cd614so1393820a34.1
        for <linux-mm@kvack.org>; Sun, 21 Jun 2026 21:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782103193; x=1782707993; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oKMHfcfhMGcxiR57N856X9q08MvdnvQ8rtbS1nGojyw=;
        b=HInA5DmZsXaL5Il3ohQingUg7FNqiB6qpjOo7zJSsZ0QCqtpTSqkg4zuHP9DxyXQ32
         NdBwIy88Vn7s52wecwEoYJ9un+uCqq682KATGlaMV0XZ1eGKRidOpy8+Zo2k57aSDiik
         ZSDbI/NKca85sPofu03P8eG+XzZObbo5dROD8P0JGtn2mtUpm8bC9rrJVTQV/SixvaJq
         hJ7052xGUYDBK4quPAWG32EddRIMPBFZcv/wRiRtP/jmMtw2ChzwHTIiJyhA9HipdUJ5
         XpvYIw9NmIoHu46eCT7bJzcJa0LY2mPFutRYRsu2MOLPrEX7xbNlaQI1HmM6IDPjB9Zk
         tx1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782103193; x=1782707993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oKMHfcfhMGcxiR57N856X9q08MvdnvQ8rtbS1nGojyw=;
        b=Z42aprdWeRm9EqUM1D9DIuVhN0Y/yXqGzbt7CtQyuZAUdGO+McHTIztK59uj2D1LDN
         TCefy5zxn743gujakT6HsuCNyd5nDJe5zKNlzXhTuRQMJ/LCbjdv1wVjppPoKmRYqm8K
         fkhlWchnUwxd3ose2Ngo74v6meReGo5BeEcicTfpI/qugpwhXDIQQXTxSFFabIM27lAL
         uruOZl7R61n5s9ECPRdihgO4Y/j2sLpm+sO7mgWJoqj2ulLxWcWnPsPJ538blB8NGLr9
         vHveF6IYjRFIeq0WaAlM10gTK0BX8pGezAWj9659FAHOQDl5ECHi71EJrixPoiOIgVTV
         Yf/A==
X-Forwarded-Encrypted: i=1; AFNElJ89i+9DWiW/me0CkKwjRaxD/zoD4II7ykHLyue21XERT21PxyuT8ETDvChR3ycOZQ7wUcHwN8+1mQ==@kvack.org
X-Gm-Message-State: AOJu0Yw4qwZg2o8xv0LndLGFV2xoL7EfmGucSJTNcvgJ6hM+OhJ6froC
	2YVPjEh22JvMCvKwnaKSlB4/ZkE0ze/4ZdaEBqk9W0+klls+Kgo4vnJF
X-Gm-Gg: AfdE7clYb+a8pGc/OUpp4liq97WBTMaBb/Q28jBIxkSEGzzzSt4IgMw+2SYZqYOaTl4
	0sqmXNSBHEYCUIoXIZWvAAFlHpd+UNs5dmud/M/uwUxKaWx989KYW3/U7JvZlj8psVihpBdR745
	wWY3OOTzAVnB6ffv1dJ6GSsY/Ck3nNlu/3YBnYMRLcBY5U+16thsHQSFL8oh4gtAopq2UbY33Mc
	Ia9uNNs0SWkXm6NAEsQ6Uw5q15FIB7A6RgvrnAOwS9cFn55Cs5C1l3V2G0xRLVVJI14cUj08485
	PhQjiLILycNpbUmlsJjc0JeCPTOJ3uFRbGQ7JVszuGPQhDO/55+6tbqZPYlZDydKbSDdpIeKJWM
	PIT9TpJPZpYVzrB+UcsCmNJuDspaPYW5JDQnHDqqZCV8vxc8PR+dmpJmfp9fpWEDgHE26KzwrXi
	ABFS3xPebYKqnxR/uy1UtGaJJLLOJI71x83Q==
X-Received: by 2002:a9d:6ad0:0:b0:7d7:45b7:ed8a with SMTP id 46e09a7af769-7e92cb41280mr6746119a34.5.1782103193153;
        Sun, 21 Jun 2026 21:39:53 -0700 (PDT)
Received: from nyx.tail25a6.ts.net ([2605:59c8:74db:6e0c:3a80:a3f:f9f0:1b3c])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e9442ea144sm5428453a34.27.2026.06.21.21.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2026 21:39:52 -0700 (PDT)
From: Farid Zakaria <farid.m.zakaria@gmail.com>
To: kees@kernel.org,
	brauner@kernel.org,
	viro@zeniv.linux.org.uk
Cc: jack@suse.cz,
	shuah@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Farid Zakaria <farid.m.zakaria@gmail.com>
Subject: [PATCH 2/2] selftests/exec: add test suites for $ORIGIN interpreter resolution
Date: Sun, 21 Jun 2026 21:39:34 -0700
Message-ID: <20260622043934.179879-3-farid.m.zakaria@gmail.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260622043934.179879-1-farid.m.zakaria@gmail.com>
References: <20260622043934.179879-1-farid.m.zakaria@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2426F40009
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: oitnr5y8a9bjj53p6grggbgpcfe3j7sf
X-HE-Tag: 1782103193-960989
X-HE-Meta: U2FsdGVkX19jOY9ejASBt+dSEanRrzGdd/tzNmhJMWM2Z+EUb2XX1hHbsUbEJDB+iEE+ju3NIIR3oqoZIFmUDVQ7aqn6OUiJe7gaYACqJw+zGKrXwu/UdwjEy2vNjy1wlJPPMx83L+aaeadAKvEgBRIvx3RUeCHyV60YL/Hhi+X7gW45uEFRmOhEmjbv7hzGyMKqrhdlIsddvQR0yqnFtd/dllyVHhTJnBz0HpI6vLBi9IzQeFU1KmkQu8EXY1QWNffyYJ4OalEeUUZ/+hpJaSBSYsu1F/+ktUoWmXBW+hOLGpVLI2+Xc5juCLzYhwrWkK7ZHJcXZpwewmvAwQVnSYR0k5FAj6Ru4O6cXyp+fSUXQJbwtvxqnsuYojCv2/Fh1GinmRn/8ci789gKbASRUBlxTT+9aAegSlsidJu4kw+8ysFWBel87TnlbmR39szoXkogLDzfIh5b4DcbdwO8p73X8ffgdxnjfckD+9jFFCqFQJ8ihtdmQBY/ekMQir9vXFfzcsG2aBOo9QzCETRZGZbhKQhLneFCH4jUAJd2ZqcEhVadLrqYJNMthhi2OK9z/dzseg2YJqzvxSx/qPSK9Fmv3xarCIbgj1jwmtDiL8DohXARB4euWyhYZ3/qLmUvuJ/M8KSgx6BL4XZEWWcVpLtlE88hV/tGmm0fAm0m7RgqCl2rM/9nwIsawmbLsFVbONo5tp+cwpVHS3qMm7Tmtfz1t+PDU8wbO1pq/IPk9drivH3uZj+9KI1+bZDHbPhN4WaqJiiHMvfW1T7ZOXR4DR8AHaQglhPwpvk0xIkMej8XV77MZj4q3CTYxjMRJOcc0I2rNstL4iJhmVCBBYN5t6qvMQqJVcJwjwcG4MO7vv0mVTNpvN0g+vHKL0gO4ui2gsI1wqrTAu+blpGXE3rJrrAmlPyAGddBT6rE9oNlLrPD+l6TJYEgdaAA9y156B9ff45u3Zn7kNh4gUBc0Bf
 6gpPfrdW
 1qLhpTmeodLxd89qf/Dh4Jvpq3pt3P+lOeawN+QWDkDgEchPMRb0lDsY7tF0HiK1rp6asfdH86oXOzNEDOUIzk6Ei7BV4preDdKGEiTR1a6bILciERB0HhqwarIYb5bOutOAmVQvyrvNP7x0LFOLR52O/z3MwIUHrspKUOWeFtY2PsBG4M5ith3WR5lPFEQ8ltjBdE9iGeVCoPmu4bwwWLHI4DrXkRzrIOUtquVjxLIeSBKXR/tnqkHTyOVfEDtCWA8zYxXnyG+M3VHAmQO16g8iXsLchQuOvU2L7akuUpzPr1gQp9tGD2O1PZgI/QrXsynyjCsGUSutKUndY3QnPMB2MwmZxZDkvDW9KQLf0u5tAvRF72O7VBorrauazC5OeJdax+z5kkv4rK0f/c3ifl6J1NfPT76jDyN7c+qk83VHAj6LzRxvuV8zRkWLFOXtI6ALspx0WOTpSfPOxo6OuTxmgrxa+jS9kPU+Tmfwtt+QDo8qfcnH9tLuvs0whQX25xJFmyiKKYHsirsu8pjcfjbqH7Ui6iSv1Wqmu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add verification suites to test the kernel VFS and ELF loader $ORIGIN
interpreter resolution.

1. Add a KUnit unit test 'exec_test_resolve_elf_interpreter()' verifying
   path resolution format logic.
2. Add a kselftests integration test containing:
   - A nolibc-based statically linked mock interpreter that prints a
     success message and returns 42. nolibc is used to bypass glibc's
     static startup code which segfaults when loaded as an interpreter
     due to AT_PHDR mismatches.
   - A dynamic test program configured to look for the interpreter at
     $ORIGIN/mock_interp.
   - A shell script harness checking for a PASS result.

Assisted-by: Antigravity:Gemini-Pro
Signed-off-by: Farid Zakaria <farid.m.zakaria@gmail.com>
---
 fs/tests/exec_kunit.c                         | 26 +++++++++++++++++++
 tools/testing/selftests/exec/Makefile         | 12 ++++++---
 tools/testing/selftests/exec/mock_interp.c    |  6 +++++
 tools/testing/selftests/exec/origin_interp.sh | 16 ++++++++++++
 tools/testing/selftests/exec/test_prog.c      |  5 ++++
 5 files changed, 62 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/exec/mock_interp.c
 create mode 100755 tools/testing/selftests/exec/origin_interp.sh
 create mode 100644 tools/testing/selftests/exec/test_prog.c

diff --git a/fs/tests/exec_kunit.c b/fs/tests/exec_kunit.c
index 1c32cac09..991b9abad 100644
--- a/fs/tests/exec_kunit.c
+++ b/fs/tests/exec_kunit.c
@@ -119,8 +119,34 @@ static void exec_test_bprm_stack_limits(struct kunit *test)
 	}
 }
 
+static void exec_test_resolve_elf_interpreter(struct kunit *test)
+{
+	struct linux_binprm bprm = { .file = NULL };
+	struct file *f;
+	char *resolved;
+
+	// Test 1: Non-$ORIGIN interpreter path should just be duplicated
+	resolved = resolve_elf_interpreter(&bprm, "/lib64/ld-linux-x86-64.so.2");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, resolved);
+	KUNIT_EXPECT_STREQ(test, resolved, "/lib64/ld-linux-x86-64.so.2");
+	kfree(resolved);
+
+	// Test 2: $ORIGIN interpreter path
+	f = filp_open("/", O_RDONLY, 0);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, f);
+	bprm.file = f;
+
+	resolved = resolve_elf_interpreter(&bprm, "$ORIGIN/../lib/ld.so");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, resolved);
+	KUNIT_EXPECT_STREQ(test, resolved, "//../lib/ld.so");
+	kfree(resolved);
+
+	filp_close(f, NULL);
+}
+
 static struct kunit_case exec_test_cases[] = {
 	KUNIT_CASE(exec_test_bprm_stack_limits),
+	KUNIT_CASE(exec_test_resolve_elf_interpreter),
 	{},
 };
 
diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index 45a3cfc43..5e2e305cb 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -10,9 +10,9 @@ ALIGN_PIES        := $(patsubst %,load_address.%,$(ALIGNS))
 ALIGN_STATIC_PIES := $(patsubst %,load_address.static.%,$(ALIGNS))
 ALIGNMENT_TESTS   := $(ALIGN_PIES) $(ALIGN_STATIC_PIES)
 
-TEST_PROGS := binfmt_script.py check-exec-tests.sh
-TEST_GEN_PROGS := execveat non-regular $(ALIGNMENT_TESTS)
-TEST_GEN_PROGS_EXTENDED := false inc set-exec script-exec.inc script-noexec.inc
+TEST_PROGS := binfmt_script.py check-exec-tests.sh origin_interp.sh
+TEST_GEN_PROGS := execveat non-regular $(ALIGNMENT_TESTS) test_prog
+TEST_GEN_PROGS_EXTENDED := false inc set-exec script-exec.inc script-noexec.inc mock_interp
 TEST_GEN_FILES := execveat.symlink execveat.denatured script subdir
 # Makefile is a run-time dependency, since it's accessed by the execveat test
 TEST_FILES := Makefile
@@ -55,3 +55,9 @@ $(OUTPUT)/script-exec.inc: $(CHECK_EXEC_SAMPLES)/script-exec.inc
 	cp $< $@
 $(OUTPUT)/script-noexec.inc: $(CHECK_EXEC_SAMPLES)/script-noexec.inc
 	cp $< $@
+
+$(OUTPUT)/mock_interp: mock_interp.c
+	$(CC) $(CFLAGS) $(LDFLAGS) -static -nostdlib -include ../../../include/nolibc/nolibc.h $< -o $@
+
+$(OUTPUT)/test_prog: test_prog.c $(OUTPUT)/mock_interp
+	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-dynamic-linker,'$$ORIGIN/mock_interp' $< -o $@
diff --git a/tools/testing/selftests/exec/mock_interp.c b/tools/testing/selftests/exec/mock_interp.c
new file mode 100644
index 000000000..9c9ca1098
--- /dev/null
+++ b/tools/testing/selftests/exec/mock_interp.c
@@ -0,0 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0
+int main(void)
+{
+	write(1, "Hello from mock interpreter!\n", 29);
+	return 42;
+}
diff --git a/tools/testing/selftests/exec/origin_interp.sh b/tools/testing/selftests/exec/origin_interp.sh
new file mode 100755
index 000000000..635a40839
--- /dev/null
+++ b/tools/testing/selftests/exec/origin_interp.sh
@@ -0,0 +1,16 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+# Execute the test program which has its interpreter set to $ORIGIN/mock_interp
+# Note that mock_interp must be in the same directory.
+dir=$(dirname "$0")
+out=$("$dir"/test_prog 2>&1)
+exit_code=$?
+
+if [ $exit_code -eq 42 ] && [ "$out" = "Hello from mock interpreter!" ]; then
+	echo "origin_interp: PASS"
+	exit 0
+else
+	echo "origin_interp: FAIL (exit_code=$exit_code, output='$out')"
+	exit 1
+fi
diff --git a/tools/testing/selftests/exec/test_prog.c b/tools/testing/selftests/exec/test_prog.c
new file mode 100644
index 000000000..451614def
--- /dev/null
+++ b/tools/testing/selftests/exec/test_prog.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+int main(void)
+{
+	return 0; /* Should never be reached if interpreter is loaded instead */
+}
-- 
2.51.2


