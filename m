Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC7DED1489D
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 05:08:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50C466B0096; Thu,  8 Jan 2026 00:07:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CC866B0098; Thu,  8 Jan 2026 00:07:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3503F6B0099; Thu,  8 Jan 2026 00:07:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 256F76B0096
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 00:07:58 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EA7A91AAA21
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:07:57 +0000 (UTC)
X-FDA: 84307614594.25.C7B954D
Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	by imf22.hostedemail.com (Postfix) with ESMTP id 31920C0008
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:07:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gerN3Fq4;
	spf=pass (imf22.hostedemail.com: domain of 3qztfaQYKCPASnSYafYggYdW.Ugedafmp-eecnSUc.gjY@flex--avagin.bounces.google.com designates 209.85.161.73 as permitted sender) smtp.mailfrom=3qztfaQYKCPASnSYafYggYdW.Ugedafmp-eecnSUc.gjY@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767848876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q1hhEQ/dcIyjHD8R0p3IwfdlLsdWEz7YcUZfHbTaGDU=;
	b=igl6MV/5+WdRoNbnJ1mjQi49fT55Rw8fX3/Zt/dWUyvFFo9Z99qGCiPmGg2Mu3knYC6Vxa
	dMdsjNQjQoiQKfTaHlzN27zOOQsWiZPgCBukmiStjYgIPXn7rhun5ziGEQ3qN0L8zhcmwh
	Rq5eWP1/jbu+cgXcZHE5ctRzHA7/lUM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gerN3Fq4;
	spf=pass (imf22.hostedemail.com: domain of 3qztfaQYKCPASnSYafYggYdW.Ugedafmp-eecnSUc.gjY@flex--avagin.bounces.google.com designates 209.85.161.73 as permitted sender) smtp.mailfrom=3qztfaQYKCPASnSYafYggYdW.Ugedafmp-eecnSUc.gjY@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767848876; a=rsa-sha256;
	cv=none;
	b=2Hd+w4OUMCyl8crFEbgfZLp6QLgWFVqJk0Q8oGUbIo1B8hmBpW3p7rUEHx/uroLHczcGha
	BWR8dIOLv3DyYV+rJb8VkKyZX//+iGSVyXBseXqwe2kS8lfNaNbYsdK06FMCqNclniA/Bd
	PmNoJHa8vyLlUFy1h3zAaWsf7g33Sp8=
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-6574475208eso3093912eaf.3
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 21:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767848875; x=1768453675; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q1hhEQ/dcIyjHD8R0p3IwfdlLsdWEz7YcUZfHbTaGDU=;
        b=gerN3Fq4Vz/Wsa1x844rNia89MIj2L/Rr2kyABl+PnwH1SENb0OPBILNhMxuS/S+dD
         zdAKbeTGnG4BCSDxeYumrPg8OQPUhYMSI94X6l1mIw16tMKRHm67yK5iTeBqtBZleYAr
         j2M3CLI1PJq0+Tv5tXryVbi30tgJRmDaXzsGxkVGDVfEFti0v4GuZvRB42kvvvoPBW5Y
         Z7U8rJV1HIKvygbBfNzWyTzlCBnlDg4DV3l898HrPCa2hzkG2Qlf8fJIpqRDcIGpAK4a
         9fvT/n64RxHH5rWe1jU8nXi6b7F8YzUYA4IaVYlZIsMcBVzKjpOqpNIXQggdDAhsBSU/
         cyCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767848875; x=1768453675;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q1hhEQ/dcIyjHD8R0p3IwfdlLsdWEz7YcUZfHbTaGDU=;
        b=GySOVAnikH393sEh3ni3WmfiWN+c17SMtm0/ffaxIlJQEhjUnVhu0X+4snJ3LG8v5b
         QeBNqJiwAtO9G99QAhVA6t2MIzVRcmwXYFgv7K+TQlgZsIZMBFIGAXtNsJebcttJMwPc
         +ZYDszfkKJpe7gyU4vtAYkOHHMGmOeW8Jv90J/iQ6TOum7RF3sVyz5w4JHD9rUkRWK8S
         MeXUuKgF7pR1xXuJc4QMAmcoiyI68xiZqH5qoQUXgWn+AACyDsUJxgu2JISMjHF/Cgz+
         f0PIqgleG5PmQEEeUv4xpTXnx/O+6BuOCuKPEPAT9EmLoKJs0WDV891vQK8D3f3q4WUC
         hNZA==
X-Forwarded-Encrypted: i=1; AJvYcCVZk8zTflMxETzUB0R3ntZXDMwzswkrUEyufJ2/TLb+lGRnPxbDuCUv2MZz8JCbZd7conSHTbW06g==@kvack.org
X-Gm-Message-State: AOJu0Yw+910IcVqQShU2WXWH3J01kcWReVwA0oeAC8vqrkXdXmaYkLzt
	kHy+0TECkqFDQUlV5snfASvSBt5nNwbf4LLsmpSkbh0iebcpeNPwTxfFosMwjJ1udBmOYtwZ9fs
	Wj9AfYQ==
X-Google-Smtp-Source: AGHT+IG6PRfdl7A+xXyBMjsVyyTg1K6TF0yM6mRQxM81LAutvzKwdfc7WseETy3uSVVUyTVIXphzxa2bYvw=
X-Received: from iobid13.prod.google.com ([2002:a05:6602:6a8d:b0:954:45e5:5098])
 (user=avagin job=prod-delivery.src-stubby-dispatcher) by 2002:a4a:cb10:0:b0:65b:38e2:33b5
 with SMTP id 006d021491bc7-65f54f7b279mr1489724eaf.49.1767848875303; Wed, 07
 Jan 2026 21:07:55 -0800 (PST)
Date: Thu,  8 Jan 2026 05:07:48 +0000
In-Reply-To: <20260108050748.520792-1-avagin@google.com>
Mime-Version: 1.0
References: <20260108050748.520792-1-avagin@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260108050748.520792-4-avagin@google.com>
Subject: [PATCH 3/3] selftests/exec: add test for HWCAP inheritance
From: Andrei Vagin <avagin@google.com>
To: Kees Cook <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, criu@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Chen Ridong <chenridong@huawei.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Eric Biederman <ebiederm@xmission.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Michal Koutny <mkoutny@suse.com>, Andrei Vagin <avagin@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 31920C0008
X-Stat-Signature: mrq453rfytenm3d6j5aetqzhb4i1h9kd
X-Rspam-User: 
X-HE-Tag: 1767848876-25137
X-HE-Meta: U2FsdGVkX1+k8MhFNPMch5jUBaKcqHjhV8WZeptxC36JSlatUQr2KmmdOCzUMos/UjWW7LpXnYT8QwZpxs1VMt7RaeztClMEQtqSTwSRPpIwGjOSJVInOcuQLDrxzZG8QTlCtgYUdG3hwRXc0MNQWgbSa/yi3y2QqrRlSzw4yjqZNT0/FTYp3Ml6Imj8Tl+obhBkqfv2rirE5D2V/TmIxCogDWjPk7CHN6OeuK6ogyLjWm+iHUHyxH+KWRyGZeozlbXQts37t4+uyL8GFnw1jmEkK/zEfALYzpcHsg3MOMlsIMG8dOUJnmUWxMjO357Og+uEpuHGlAl4MiboxOQfUgpyP0sRChSXBZdWtcVc0cWd/4+Wu+S36YtTgamGboCOQGGLjSm6jsGDK9nPz8bPWiHOqrdWEqlkz3eQ0uRa/mZGaD8igsmQonPs1NIU/cmadGGGHxV4jz3gIErF0WT4PCc7qRCTsn1umlqwd11aWI8WfK8S3Ob7Hl9Q3cylSXa003wSyCEbRA9kAqBLSxQLMmWJIq/Eplsv+TVqOkpntvk+rJQ506zb4ysvb94hsTfKY6i1lyyuHwEwTzMRH5YZJB81oqFUzDj4uUyf4E9cWBttkLnbOwkyksSc5ZgZc80c6q4yrW3+cBNH9y07ZtJtxCTiz2aT66LYCm62x/SO+zZBvUo2xJcdN4S+ysJ2DlgbKUbty+cKgP6A5R40r5cyVatBJ2Ui5ukq5QX2YMQgSKYqLfitXBaqzjbjDJqyVtG3GNKMWsg8lZv5qXRLHOSpt3plAh/4DA1yMmTnvt7AV3GBbzN1k1L8XBACFX3EyOG2cF/Ma3qNHC22JFxhuU6ATkcoFGSYmIYn6voHQ9a3vfAZFJQUsAHnsbMnNjuDAo2KvAnTKenEyD5uBBodRRdm0FfP6VYlngN9RxTMj192B6WWQocbp5XlldLqUOUcqeSi2K8eqOz3Ewoxy8/F4um
 GoTaypdZ
 XXUyrj+0cwPYOH97CxfOKkSUSPtpOscT+Wta0inqif/DM2wVsUOqDlq/HbapGi94OErKDuOCiMlcO90DWVfx3kvGInrBxMCWH8fYB2/YJR/WxLEmQj+3994NW/zfzt217Npubv+sHXMaFaBdNvGV9kF9l71VZ7xz+qJkgER1+gb7M+Z/3O9y8CrB4NaUmilN6IPuFkxBlTKE1XWIYSpnattvVUysE+ovjBQGCnXoc/565K9dE563TJo1bvDP/g/WfETCpgnS75iDUkQ7t5PolaJed5sgyOMlPe1rkVuLtQWASTUrZF1sCSkwc6SPIbtHvhX7pFC4nDLql9/rd8VTxuS6RDfnUtrs9XFJt2OCtyKeOfNo2yEkR520ZqXEHJfyx/u6n9LQwKxX1n1xyM7HB/a66lQYylZyNKYNQYiAgaNW6+N9jmKYSt2nuyqIeGLM8M4eZVheM5IUDkJq0OVvEEoBO8IQWDaBTAXso6OKhbRxHJziU9HUZLVOpSi8pvQHlY8e2vLHMZ2t6h9G0uAjDm6TjpXfXpqon39OkCe195YZQ9LYU9pC3VHU33OEpS7kp1qOb3VcssmTU3lZE54+HDXxcBT9y4e95k9cLWSSy2CF3g8kbqxyA2e8kSqUUJeHFNCyZ
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

Signed-off-by: Andrei Vagin <avagin@google.com>
---
 tools/testing/selftests/exec/.gitignore      |   1 +
 tools/testing/selftests/exec/Makefile        |   1 +
 tools/testing/selftests/exec/hwcap_inherit.c | 104 +++++++++++++++++++
 3 files changed, 106 insertions(+)
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
index 000000000000..ef80a010765d
--- /dev/null
+++ b/tools/testing/selftests/exec/hwcap_inherit.c
@@ -0,0 +1,104 @@
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
2.52.0.351.gbe84eed79e-goog


