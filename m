Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 358E5E9A02B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 18:01:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1F2C6B0092; Tue, 17 Feb 2026 13:01:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB9C96B0093; Tue, 17 Feb 2026 13:01:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBD076B0095; Tue, 17 Feb 2026 13:01:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9FF656B0092
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:01:20 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 59C1CC16B5
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:01:20 +0000 (UTC)
X-FDA: 84454715520.29.0C8915B
Received: from mail-oa1-f74.google.com (mail-oa1-f74.google.com [209.85.160.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2FB0D40004
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:01:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GJFs6x8N;
	spf=pass (imf12.hostedemail.com: domain of 37KyUaQYKCOsNiNTVaTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--avagin.bounces.google.com designates 209.85.160.74 as permitted sender) smtp.mailfrom=37KyUaQYKCOsNiNTVaTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771351278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2fimtsUyJng+2uYEqG9RtpHODLieBKKBpfLX8kY/jM0=;
	b=L0uCBmyYMGy2ddDWC6DQup2h7yZrNI9+B87QrA6F7Ayw9MrPUm5abMK/fBsgoytlo/eAJN
	GWL+S8lxS3A9PUpu147h3eFgeW6u1+VS8PEWItHT/dEGOBxmiFpskxxkzrbeIldZhMXbOa
	8oj5SFDpqrfu53wMjPjv+VCUEFDpgpE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GJFs6x8N;
	spf=pass (imf12.hostedemail.com: domain of 37KyUaQYKCOsNiNTVaTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--avagin.bounces.google.com designates 209.85.160.74 as permitted sender) smtp.mailfrom=37KyUaQYKCOsNiNTVaTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771351278; a=rsa-sha256;
	cv=none;
	b=OiQbbodef5r/Uv/E5zoBG2+tBy7xffKymweGTrvkZGw6yl9cVQDBqB2fey1kCdaEyw2l4T
	sQZLJR3PigLaQwUb7eau6MpOt6K0QajvAVYb+vEhJiBNjrB7gvBiswYOVAzggMLqPTrAOw
	m6OuBjYyAr8C4KyMah38cQxBjCW8fPo=
Received: by mail-oa1-f74.google.com with SMTP id 586e51a60fabf-40f192cf4b6so10448159fac.1
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771351277; x=1771956077; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2fimtsUyJng+2uYEqG9RtpHODLieBKKBpfLX8kY/jM0=;
        b=GJFs6x8NtgQFZILxjvIdyY8cibciHh4HrhamOfSssyxhCPTS/LqrkoaSRWqsrDZl5d
         oO5hzQOa6VwP08dlVVA41GMx7BVaVt6GNgIa848f0Zb5mmmcZr9KSQUq4QpZ5+npnrE5
         70IzpFaXEXsZUZEvWyyPaV59bqJ1HrBIXP54YuY9nuTqVNTT6y7eYKSXiZiZA2LuTIOd
         1QZqtK4+M0czAQQIAamSFutpQCuyNUHXgCnGO4PuIWie0AUNxgq7VzC9M4g/r+Mauv4D
         3ny0jG0630OHJzOGH+8Hx9MBLwBDHCfYP0wwYtOH7J3YeeviZzSQVhBsjs/mJqO6P2aC
         zR5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771351277; x=1771956077;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2fimtsUyJng+2uYEqG9RtpHODLieBKKBpfLX8kY/jM0=;
        b=ZTAyoWiTj5WhHTC6oFhUAwgBUBXaALj2fKM3ifBGTeNK38eXNHTzxTjt7fh/BjHplf
         q4Ft+hnIbHRydpVv7ExUbKaK6nyKSbHaYY7zVbv3URhTU/mx8xDbI8YkmyZcV7FofN+6
         bjauxqbdQK5dPO7WwyyLyvZQ5Du8YCUoUKQ4XkZhhoEf7qfO4bJbIbXlpIWsaCZC9qxe
         0rLpOlaVZfO/O/GYaaWVCS/WP71m0jcFJj5EszIlYXqFeU5QOoDnLYzEtKYjl5qyhnhX
         d7k1k20G2w1nJ1TQuEO+xR8bUrSfUOPyBAwXD7w2MY59PvRwH884jPu90xJW6C77JDE0
         vRDw==
X-Forwarded-Encrypted: i=1; AJvYcCVajByEeVhuWmqc1PvZUrBPlZSf5VZcZtd8rw12jGtyxn1Ak+UXD5FTO9z+mikfwPJzAK8/EvLQbw==@kvack.org
X-Gm-Message-State: AOJu0YzIQpURna5YLYsMANbGcjFdKubxzD4IvPRc5UKMckP2eUD/EIz8
	Vbh9YUH/xyTdY5dJcvRyuOvTYbC1BBQl9Zf1rCww4Kv/quc7/HbMM6v5OKmJwedBTWgNsMVU64Z
	Z/Qie/w==
X-Received: from jabel13.prod.google.com ([2002:a05:6638:4d8d:b0:5ca:f895:d03b])
 (user=avagin job=prod-delivery.src-stubby-dispatcher) by 2002:a4a:ec44:0:b0:659:890b:3f9
 with SMTP id 006d021491bc7-67858ef3a65mr6049899eaf.4.1771351276862; Tue, 17
 Feb 2026 10:01:16 -0800 (PST)
Date: Tue, 17 Feb 2026 18:01:08 +0000
In-Reply-To: <20260217180108.1420024-1-avagin@google.com>
Mime-Version: 1.0
References: <20260217180108.1420024-1-avagin@google.com>
X-Mailer: git-send-email 2.53.0.310.g728cabbaf7-goog
Message-ID: <20260217180108.1420024-5-avagin@google.com>
Subject: [PATCH 4/4] selftests/exec: add test for HWCAP inheritance
From: Andrei Vagin <avagin@google.com>
To: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
	Alexander Mikhalitsyn <alexander@mihalicyn.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Chen Ridong <chenridong@huawei.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Eric Biederman <ebiederm@xmission.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Koutny <mkoutny@suse.com>, 
	Andrei Vagin <avagin@google.com>, 
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2FB0D40004
X-Stat-Signature: c8o5pcq4wo3mmug18wk7wkd6rfyuze9y
X-HE-Tag: 1771351277-468449
X-HE-Meta: U2FsdGVkX1/nPdyj7visMnAsNaFKbRxQTgc95laeoixz1HiAvT9iEKNNibUO3xaR8C/Qtw+t/akyJiNHaKIOEacSzu7KKhfI1rKdZ06xxNXpL28wq555ojt7efzX4NZJ3xDtgcLG/Hr6nyNlBqP0Qyr2wq89OVvMIudcjYKnrdb+UGO93lbOM8cN0fFvgXPmaqsqQ8mXvS7xtJ6Supnhd4C1cStG38uSCCI5/ozhoBVfFvTwS+pmYF9pX47ZbF4EGIm6jDxKhDUcFHmFYzEoO48I3w1xBQFwTqJRUirrZlbp6m40sSt7MOVN9N5jk8lrbzBzOymQCUgiS569lAD9d64S/H3+8yOs+1NVIa9wrigwJaAESqeQYgTHQyPzNArbo36nnW8nNowiieK3U5AB7v5bCG2bcsi31eVSpMy+wIbxLFcj/T1nS39P1dJjUf+h5IxavUTkPujTEn10NC2v8dVzsHmO068FnqFhr5gLeOuShmuU+f+DR2p7WWFEazXwxX9rWwbHd/aYXRkNfi6afP+q7RdF/HuM1O+MhTWGraokytp0gTKJq46ixZkCr4QVrAv+Q6UWGNrapwC05hUemjedEgFFb+/sYX7bpEACMZniYp2+tRhfTOEfyzKZeAFUcA9PpnL16Yto6Kxfdqt+aOPDHhaNCHEYkEvCLUY6VPtvwM9dWK+SC8BJ2BB5Axy/FxjODtR3kJVwU8Ni10AP+YX9voNzGtiICKl4DPNrYE/jJ8BwEJiJedKo32k69xzVg/eu8Ki8NZF8mrhGVuYeDg+/Hog+m1NOR08piAXJgNhn9QancXiMx034S8QRXHyev/SLMpCqmGvT/y+eeKe1x+YB3VaeXP2Z/bLDAHNJLEL6HcRJ7IEpTbicRHMQ3J3xowOJnwNTWUo7bhuGZ1gppitou5KOIulwVmxPHrJ9uOnJpIoedn3i5rIP/HZzpIrBS87Cl0DI2v0n/l+CH//
 fnTma2nz
 xsZTRz3KhcxGF5MCFZQfx4GgaKyevlIIEhB4CKzKeJp1qdyEm1aSQPp7qFzFhFAw7u9mSUC3UhBIUSzxJS89yHq4Uh/ImRrKg0G/Y0Ek0xV5rsi/Ts2jtxHaQD4eoWD/KAuvzIcCBxS/bG4kz8eP6XIiiJdmRh8+5rbZeAGCM1r18Z16eteTpUMGeTMCU7v07YEmlnhblBdxSmNa8AUE3/QaAgwDTigI0mURUWKeNcoy5ts2/RYJO3rcOe3zMRgWhmuLh7mTvypYtjUFsQql8B9UIUjYNB1+KO4lG5i8Wv4Bd/ZH7dy54yQ4Wuf0/k5mCCRSI4qQKVeFiTfA1HJO4f5hTOWrZTEmOiflDNM8cFhkpOkipYDsBbm0eRtgAisp1gY++PaLgmrUH+Zf4uyw8c2Nsjg/17KVueHMhIYu+G80TnOqjC0kZxIvrWlgHAvda7VzOI0kt3Inblfuq/89aRv5I3v0Odnn2wkscDT9zsW4WT7KdGChnLzvJUfnaw09SY/e+pExFDkYq1f7A1ZS5Wpy1ouyVEzehbsq0Jw8Y9W6tQKC0DwDSpPYuqagwwzUIZqZr/Se1zKvCc9uno9nhrSVpZHksUdMtjAlFmGADrM8LPYmmPBHimzImLRPjbgCclkaOvoWLl/DzLKsWHEDGJMrz44TgfG4xpkWA1sj17uugb0U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Verify that HWCAPs are correctly inherited/preserved across execve() when
modified via prctl(PR_SET_MM_AUXV).

The test performs the following steps:
* reads the current AUXV using prctl(PR_GET_AUXV);
* finds an HWCAP entry and toggles its most significant bit;
* replaces the AUXV of the current process with the modified one using
  prctl(PR_SET_MM, PR_SET_MM_AUXV);
* executes itself to verify that the new program sees the modified HWCAP
  value.

Reviewed-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Andrei Vagin <avagin@google.com>
---
 tools/testing/selftests/exec/.gitignore      |   1 +
 tools/testing/selftests/exec/Makefile        |   1 +
 tools/testing/selftests/exec/hwcap_inherit.c | 105 +++++++++++++++++++
 3 files changed, 107 insertions(+)
 create mode 100644 tools/testing/selftests/exec/hwcap_inherit.c

diff --git a/tools/testing/selftests/exec/.gitignore b/tools/testing/selftests/exec/.gitignore
index 7f3d1ae762ec..2ff245fd0ba6 100644
--- a/tools/testing/selftests/exec/.gitignore
+++ b/tools/testing/selftests/exec/.gitignore
@@ -19,3 +19,4 @@ null-argv
 xxxxxxxx*
 pipe
 S_I*.test
+hwcap_inherit
\ No newline at end of file
diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index 45a3cfc435cf..e73005965e05 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -20,6 +20,7 @@ TEST_FILES := Makefile
 TEST_GEN_PROGS += recursion-depth
 TEST_GEN_PROGS += null-argv
 TEST_GEN_PROGS += check-exec
+TEST_GEN_PROGS += hwcap_inherit
 
 EXTRA_CLEAN := $(OUTPUT)/subdir.moved $(OUTPUT)/execveat.moved $(OUTPUT)/xxxxx*	\
 	       $(OUTPUT)/S_I*.test
diff --git a/tools/testing/selftests/exec/hwcap_inherit.c b/tools/testing/selftests/exec/hwcap_inherit.c
new file mode 100644
index 000000000000..1b43b2dbb1d0
--- /dev/null
+++ b/tools/testing/selftests/exec/hwcap_inherit.c
@@ -0,0 +1,105 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+#include <sys/auxv.h>
+#include <sys/prctl.h>
+#include <sys/wait.h>
+#include <linux/prctl.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <errno.h>
+#include <elf.h>
+#include <linux/auxvec.h>
+
+#include "../kselftest.h"
+
+static int find_msb(unsigned long v)
+{
+	return sizeof(v)*8 - __builtin_clzl(v) - 1;
+}
+
+int main(int argc, char *argv[])
+{
+	unsigned long auxv[1024], hwcap, new_hwcap, hwcap_idx;
+	int size, hwcap_type = 0, hwcap_feature, count, status;
+	char hwcap_str[32], hwcap_type_str[32];
+	pid_t pid;
+
+	if (argc > 1 && strcmp(argv[1], "verify") == 0) {
+		unsigned long type = strtoul(argv[2], NULL, 16);
+		unsigned long expected = strtoul(argv[3], NULL, 16);
+		unsigned long hwcap = getauxval(type);
+
+		if (hwcap != expected) {
+			ksft_print_msg("HWCAP mismatch: type %lx, expected %lx, got %lx\n",
+					type, expected, hwcap);
+			return 1;
+		}
+		ksft_print_msg("HWCAP matched: %lx\n", hwcap);
+		return 0;
+	}
+
+	ksft_print_header();
+	ksft_set_plan(1);
+
+	size = prctl(PR_GET_AUXV, auxv, sizeof(auxv), 0, 0);
+	if (size == -1)
+		ksft_exit_fail_perror("prctl(PR_GET_AUXV)");
+
+	count = size / sizeof(unsigned long);
+
+	/* Find the "latest" feature and try to mask it out. */
+	for (int i = 0; i < count - 1; i += 2) {
+		hwcap = auxv[i + 1];
+		if (hwcap == 0)
+			continue;
+		switch (auxv[i]) {
+		case AT_HWCAP4:
+		case AT_HWCAP3:
+		case AT_HWCAP2:
+		case AT_HWCAP:
+			hwcap_type = auxv[i];
+			hwcap_feature = find_msb(hwcap);
+			hwcap_idx = i + 1;
+			break;
+		default:
+			continue;
+		}
+	}
+	if (hwcap_type == 0)
+		ksft_exit_skip("No features found, skipping test\n");
+	hwcap = auxv[hwcap_idx];
+	new_hwcap = hwcap ^ (1UL << hwcap_feature);
+	auxv[hwcap_idx] = new_hwcap;
+
+	if (prctl(PR_SET_MM, PR_SET_MM_AUXV, auxv, size, 0) < 0) {
+		if (errno == EPERM)
+			ksft_exit_skip("prctl(PR_SET_MM_AUXV) requires CAP_SYS_RESOURCE\n");
+		ksft_exit_fail_perror("prctl(PR_SET_MM_AUXV)");
+	}
+
+	pid = fork();
+	if (pid < 0)
+		ksft_exit_fail_perror("fork");
+	if (pid == 0) {
+		char *new_argv[] = { argv[0], "verify", hwcap_type_str, hwcap_str, NULL };
+
+		snprintf(hwcap_str, sizeof(hwcap_str), "%lx", new_hwcap);
+		snprintf(hwcap_type_str, sizeof(hwcap_type_str), "%x", hwcap_type);
+
+		execv(argv[0], new_argv);
+		perror("execv");
+		exit(1);
+	}
+
+	if (waitpid(pid, &status, 0) == -1)
+		ksft_exit_fail_perror("waitpid");
+	if (status != 0)
+		ksft_exit_fail_msg("HWCAP inheritance failed (status %d)\n", status);
+
+	ksft_test_result_pass("HWCAP inheritance succeeded\n");
+	ksft_exit_pass();
+	return 0;
+}
-- 
2.53.0.310.g728cabbaf7-goog


