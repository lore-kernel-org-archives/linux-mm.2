Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6EECC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 13:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1834C6B00A3; Thu, 20 Aug 2026 09:18:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10C146B00A4; Thu, 20 Aug 2026 09:18:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3CA26B00A5; Thu, 20 Aug 2026 09:18:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C9AD86B00A3
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:18:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5B826C0157
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:18:48 +0000 (UTC)
X-FDA: 85121702736.08.7AFE333
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8C0B9180003
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:18:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hBGc91II;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787231926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vR40jF9Ss8LmiP9zSaPNfnunPJsok/mkpHKsfsj1AOo=;
	b=EYu0SM9k3X4fEYxvUouNK/yid6aKn6YEV6V32hMFZmhexpZlPDIZFsPoA2TcDVjr4jmcWH
	XXxYZTQJ76oAWWX9xyj89fCDcu8ZferCOBqV8kzhknOLowLGuXm1+xTY2x3o64yo0BTT1H
	WMOsBvGOJRNVKSZwLT3+2GWSmTf9P48=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hBGc91II;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787231926;
	b=ZQJuWSe+rQNRKu2lxIRFzeKQLYDQXlpw9m2heAM9ykq4d9Lolv8QlbdN9Lo3RSqpTkiJwJ
	btkYsR6oFOUrCG6+frsMgDlNJ1zC9Zd2fVzGAlETH0UevhRVadcfeuYhRWVhAaZVO0pSDo
	Ar72rW5gq/GiG5jU4nlWy7RpcjTezxM=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49554ebb87dso23525345e9.3
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787231925; x=1787836725; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vR40jF9Ss8LmiP9zSaPNfnunPJsok/mkpHKsfsj1AOo=;
        b=hBGc91IIcHyOkGnx1ivjI2lIG6HwsMo13mFy9FOhIeDQ8RrK7CtEO3827fDACDEY4v
         KCFJiqlUoyzOTrmCQWy9308C5+d90Ff8GAXncpWaMV8L3Z/Wp4Q/NLCMpSnLQO2jxC63
         SFU590R/7V657YG2IyOFjx0N5PvahRUtKDwH/lciqmRBJWb+EHZNmGCqxe8I6phblME4
         nyp+1T6ktgB+zkgZ7KgpaYq5bBOt1hnx/drRH5jIdRZJQ+k2gOoZxNMa+hrsuk08W235
         upL0jMKqDeprkei6kzc7l6k23QPEh2B8lDlFSJPlOAEKzpDctlcFNFIRponlVY1PGpKp
         +zRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787231925; x=1787836725;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vR40jF9Ss8LmiP9zSaPNfnunPJsok/mkpHKsfsj1AOo=;
        b=Zg/9D5AtATFtfauBI1GkyjxEJrg3NHjOYCG9s5VnBcq2S7NlN9B6qF/QHdlxWJijTW
         wq4+tHD0d0GewGp7Ctbyk5D6ft9uYVFG9OexDlOqM9qwJdLdqGtHZwWrqOiq90rdHeQr
         qLjrNwWPSYQatKbLB/aMh3rJo39G+byBC3Wn6Tsw+Vaf9i9epEyKWtc7RJ9kvLhIrdk5
         mRTUT43Yv1vjvULyw9jQznllgPPq1PcX918pSn55sLritjGqhGlkzNBTpKZNCtQjq6LR
         r10CSW0PQGJrhavkibrWw9kam1DHCZw8RTyR3903XinSymhNXdv4l4iDda7Uxq1Z9Rjn
         iqSQ==
X-Forwarded-Encrypted: i=1; AHgh+RrkQkiKHsROoRFp2aefcuEzXBOwiOag6wwe8NRgdSSBWrAwivX7pJbBF2DUv2KeDQv1UHYtjuF/dg==@kvack.org
X-Gm-Message-State: AOJu0Yxed7upL8su7FKeNxQ1fQpFfZyWWNRpyAleEABspfUwTsQ3OjJi
	phyiV9l4yb7qSQaUVSElXjw7bIphKJ93aWMawplGwyRG3OGXkWe45BGF
X-Gm-Gg: AR+sD10Se4gzcuOv/SlFosvPYtGoba8dZtbgOxyGeFacRw3JpNK2mjdCb3fGS+cjE3+
	uVBmjaM37r9wenHvGAIzjN0IoKmoblZbCJ50931hJRN5FEtY6WPF1UZIdWeydjlNbCcU8CBB2cR
	L1xdtpsjLpuK/iBk+Wmw6KnzvSMXTOSDHxF2isncQfPeA32huQmq68S0vk9Wp09Em41mRx5If5a
	ggv0aQD9BrOvjPZqXmoYoOdgq4FCvIs27/DiQadu8jwK9Z9EemWQoKvhu6sFRRAU67Uc9J5lCWu
	yDui43lqCGWfGmjnlSx/A8n0YRXTJyS6QO9F8tD8aomP+3I5+1P01HUiZ2CsbY0ayG0tc4g9oLs
	p/hXtCEbMXm2ACuG5As0ezJ/Pk0g2QKxFt5uHdMRtqz0IfUIqRvmc/Iprtil+6FMKCzXf1/nmD4
	HVutoUp/BxDe1ZdueT9zjNKJLDZ39mkyjHfV0qIHa0VZyqnDjJF5MEMGe2u100k+7wYYc2YWxln
	jNo
X-Received: by 2002:a05:600c:470a:b0:499:a5fc:207e with SMTP id 5b1f17b1804b1-499aa17e2bamr164727435e9.8.1787231924991;
        Thu, 20 Aug 2026 06:18:44 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5e:1100:7303:647d:7cc4:8552])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499aa0e473dsm136027275e9.15.2026.08.20.06.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 06:18:44 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	kpsingh@kernel.org,
	matt@bobrowski.net,
	song@kernel.org,
	utilityemal77@gmail.com,
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next v2 3/3] selftests/bpf: Test linux_binprm user memory kfuncs
Date: Thu, 20 Aug 2026 16:18:01 +0300
Message-ID: <20260820131801.68759-4-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820131801.68759-1-tasos.papagiannnis@gmail.com>
References: <20260820131801.68759-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8C0B9180003
X-Stat-Signature: iisrcfq756ajc5o8t9d95ipwreb4mwus
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787231926-416129
X-HE-Meta: U2FsdGVkX18rhjXihHrbWynptsP02MrltQgLXKM+2Cr8xh4pUY2oPxKQlKf6kqIwLLGzi7REEIxQSGJDff/kMHeY7k7wK1m6+A+FG0MMrgTvfMhFvySw+TSEZMIcnoYlX/ayUbUWUCKudZdtJ7z6bsX+GcnntbZLj2y0EM4PPFK+p7hFQGAp/6FKBWjIbmjyPIT4mbZsWnY/YVLsnQ1+muZTZ9eISNzQ5Vf2W8B81i/E5H2VJdRUXIy/PJff92EqcotM+qFlrtS/KwtsfVKr+HxuX8dz5MPP8yfc2tQp4OSZgTHCQbAN0JMu+oe1oaine3aiK62hL7YE6AtandD2AHRhVkXOxLOf55360d3KlF+DRJ3aieryj4bjsqjjcdtd97RWoe7C4WjuYxhaUGgB+XiElj8aW9Sb/ZMc22tz7s8r2x+bbvarBM9wway5Y2x5rApsr6RyYAZ15OSKeVkyy3z5LCs+vY+eMcukLQIUVwVZdw41CqPH+RBYBkSbuzi8gu6fhhUfxIMXMU8Bp0Gmqx2dyarfeAuB9LQmKdZZCQ30FvY3CZL6khbSYCOXY8crSJkm98B8CF4V9eRPGY7APO5tQiwn3qZFE5myA1XIYgiEERurQgh6rAYyHWB0CCmG6iFcMDZMzgEzD8zqvU43kJ44AAALrrJoMj4CeeLUW5HHwKIfjnxzJcy6WtU4jlRhw1+ZLj5p5wG9GhJW0Pz6GnSdNm5L4gxMIoLlRHQJnweIdH4bC9VrR6POuCzq3z+6dJzYBZC8CWJZllf12anWe+n2Xt8EMLznYztD+pkFrF0WZH3EeOFtC15jjyBcstsk3xabbxi5Eu4VIFebc1punXeCQl18w4NdkX+hBpLXjdlQh1FYa83dObIHlFRv5yip8coWIwhQml8lEjPNBahdigS6edD81gYAA4pjk5rj2vbNQjE6U+5J7LXZ0vS0XV+WGMXKpEpytcqIlW6Z08P
 VULsUqqM
 H2PkB6eaOm8Dl3d6gYVGOVNJ5633zoWC/T9ik/ubqbUHYqrclGrL39CxgE6JW6+gW+bg80xVwpzVDvgJtYzm7DsKGptO+BkP6koGDSkMif/3+a4fxZ/ODaGvUmnN9Vc/j/h8NtZ7jtEDFhvD5oWVgkwi0B1BEhHk16ZMk/9etoesuiIeJ1w4MFgaHsH+pbOxQNj35D8TNuZvXdY4KxFvVzAnyhxDtCqxEaxPVQugD1NUDb2Vq9m318eQZns8NEgtULMX9X9Hzg2K0Bk76SMPF189DY0oGMRBxaBW1PwiYXRprhCu8Hd0R8F6jEsDO7w9sZNDTI4OFi3/K7ArOGKwkU3UcXL4nFsu0cgnqh459lpf6d91SSZTeIQ9I2HE1PKIOKH0DgT016asTDpKGU62wET7zylK+aPGORI+wmOHX0zy8O5yRLcCHOOe/nXNL2WmK7vth6gQueM3Wne+V5N95RDEZt+xFoUpa+aZjlbJxHRuVOwqfZLR+j8YSaEq8zaFac6T0VGDUsUH2CLxi2czYnR+iMsdn1ekNaddtmGJgCG/IdkPN7s1fPRTeMVkh9Jk9NAy7pZJ49QSioK4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch adds a sleepable BPF LSM program attached to
bprm_check_security to test bpf_copy_from_user_bprm() and
bpf_copy_from_user_bprm_str().

Starting at bprm->p, verify that bpf_copy_from_user_bprm() can copy the
contiguous NUL-separated argument and environment data. Then
use bpf_copy_from_user_bprm_str() to read each argument and environment
string separately, by advancing the offset based on the returned length.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
---
 .../bpf/prog_tests/copy_from_user_bprm.c      |  62 ++++++++++
 .../selftests/bpf/progs/copy_from_user_bprm.c | 115 ++++++++++++++++++
 2 files changed, 177 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
 create mode 100644 tools/testing/selftests/bpf/progs/copy_from_user_bprm.c

diff --git a/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c b/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
new file mode 100644
index 000000000000..1007e3aec054
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <errno.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include <test_progs.h>
+
+#include "copy_from_user_bprm.skel.h"
+
+void test_copy_from_user_bprm(void)
+{
+	char arg0[] = "first";
+	char arg1[] = "second-argument";
+	char env0[] = "SOME_ENV=a";
+	char env1[] = "OTHER_ENV=something";
+	struct copy_from_user_bprm *skel;
+	pid_t child;
+	int status;
+
+	skel = copy_from_user_bprm__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		return;
+
+	if (!ASSERT_OK(copy_from_user_bprm__attach(skel), "attach"))
+		goto out;
+
+	child = fork();
+	if (!ASSERT_GE(child, 0, "fork"))
+		goto out;
+
+	if (!child) {
+		char *const argv[] = { arg0, arg1, NULL };
+		char *const envp[] = { env0, env1, NULL };
+
+		skel->bss->monitored_pid = getpid();
+		execve("/bin/true", argv, envp);
+		_exit(errno);
+	}
+
+	if (!ASSERT_EQ(waitpid(child, &status, 0), child, "waitpid"))
+		goto out;
+
+	if (ASSERT_TRUE(WIFEXITED(status), "child_exited"))
+		ASSERT_EQ(WEXITSTATUS(status), EPERM, "exec_errno");
+
+	ASSERT_EQ(skel->bss->bprm_argc, 2, "bprm_argc");
+	ASSERT_EQ(skel->bss->bprm_envc, 2, "bprm_envc");
+	ASSERT_EQ(skel->bss->data_len_match, 1, "data_len_match");
+	ASSERT_EQ(skel->bss->invalid_flags_ret, -EINVAL, "invalid_flags_ret");
+	ASSERT_EQ(skel->bss->copy_ret, 0, "copy_ret");
+	ASSERT_EQ(skel->bss->str_arg0_ret, sizeof(arg0), "str_arg0_ret");
+	ASSERT_EQ(skel->bss->str_arg1_ret, sizeof(arg1), "str_arg1_ret");
+	ASSERT_EQ(skel->bss->str_env0_ret, sizeof(env0), "str_env0_ret");
+	ASSERT_EQ(skel->bss->str_env1_ret, sizeof(env1), "str_env1_ret");
+	ASSERT_EQ(skel->bss->data_match, 1, "data_match");
+	ASSERT_EQ(skel->bss->str_args_match, 1, "str_args_match");
+	ASSERT_EQ(skel->bss->str_envs_match, 1, "str_envs_match");
+
+out:
+	copy_from_user_bprm__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c b/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c
new file mode 100644
index 000000000000..4d7e9002b45b
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c
@@ -0,0 +1,115 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <errno.h>
+#include "bpf_misc.h"
+
+char _license[] SEC("license") = "GPL";
+
+static const char expected_data[] = "first\0second-argument\0"
+				    "SOME_ENV=a\0OTHER_ENV=something";
+static const char expected_arg0[] = "first";
+static const char expected_arg1[] = "second-argument";
+static const char expected_env0[] = "SOME_ENV=a";
+static const char expected_env1[] = "OTHER_ENV=something";
+
+int monitored_pid;
+int bprm_argc;
+int bprm_envc;
+int data_len_match;
+int invalid_flags_ret;
+int copy_ret;
+int str_arg0_ret;
+int str_arg1_ret;
+int str_env0_ret;
+int str_env1_ret;
+int data_match;
+int str_args_match;
+int str_envs_match;
+
+extern int bpf_copy_from_user_bprm(void *dst, u32 dst__sz,
+				   const void *unsafe_ptr__ign,
+				   const struct linux_binprm *bprm,
+				   u64 flags) __ksym;
+
+extern int bpf_copy_from_user_bprm_str(void *dst, u32 dst__sz,
+				       const void *unsafe_ptr__ign,
+				       const struct linux_binprm *bprm,
+				       u64 flags) __ksym;
+
+SEC("lsm.s/bprm_check_security")
+int BPF_PROG(check_exec_args, struct linux_binprm *bprm)
+{
+	u32 pid = bpf_get_current_pid_tgid() >> 32;
+	char data[sizeof(expected_data)];
+	char arg0[32];
+	char arg1[32];
+	char env0[32];
+	char env1[32];
+	u64 offset = 0;
+	u64 data_len;
+
+	if (pid != monitored_pid)
+		return 0;
+
+	bprm_argc = bprm->argc;
+	bprm_envc = bprm->envc;
+
+	/* this is the total size of args and envs starting from bprm->p */
+	data_len = bprm->exec - bprm->p;
+	data_len_match = data_len == sizeof(expected_data);
+
+	invalid_flags_ret = bpf_copy_from_user_bprm(data,
+						    sizeof(data), (void *)bprm->p, bprm, ~0ULL);
+
+	copy_ret = bpf_copy_from_user_bprm(data, sizeof(data), (void *)bprm->p,
+					   bprm, 0);
+	if (copy_ret)
+		return 0;
+
+	data_match =
+		!__builtin_memcmp(data, expected_data, sizeof(expected_data));
+
+	/* arg0 is at bprm->p */
+	str_arg0_ret = bpf_copy_from_user_bprm_str(arg0, sizeof(arg0),
+						   (void *)(bprm->p + offset),
+						   bprm, BPF_F_PAD_ZEROS);
+	if (str_arg0_ret != sizeof(expected_arg0))
+		return 0;
+	offset += str_arg0_ret;
+
+	/* arg1 is at bprm->p + sizeof(arg0) */
+	str_arg1_ret = bpf_copy_from_user_bprm_str(arg1, sizeof(arg1),
+						   (void *)(bprm->p + offset),
+						   bprm, BPF_F_PAD_ZEROS);
+	if (str_arg1_ret != sizeof(expected_arg1))
+		return 0;
+	offset += str_arg1_ret;
+
+	/* env0 is at bprm->p + sizeof(arg0) + sizeof(arg1) */
+	str_env0_ret = bpf_copy_from_user_bprm_str(env0, sizeof(env0),
+						   (void *)(bprm->p + offset),
+						   bprm, BPF_F_PAD_ZEROS);
+	if (str_env0_ret != sizeof(expected_env0))
+		return 0;
+	offset += str_env0_ret;
+
+	/* env1 is at bprm->p + sizeof(arg0) + sizeof(arg1) + sizeof(env0) */
+	str_env1_ret = bpf_copy_from_user_bprm_str(env1, sizeof(env1),
+						   (void *)(bprm->p + offset),
+						   bprm, BPF_F_PAD_ZEROS);
+	if (str_env1_ret != sizeof(expected_env1))
+		return 0;
+
+	str_args_match =
+		!__builtin_memcmp(arg0, expected_arg0, sizeof(expected_arg0)) &&
+		!__builtin_memcmp(arg1, expected_arg1, sizeof(expected_arg1));
+	str_envs_match =
+		!__builtin_memcmp(env0, expected_env0, sizeof(expected_env0)) &&
+		!__builtin_memcmp(env1, expected_env1, sizeof(expected_env1));
+
+	return data_match && str_args_match && str_envs_match ? -EPERM : 0;
+}
-- 
2.55.0


