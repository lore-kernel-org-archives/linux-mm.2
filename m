Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A4ACC79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:53:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 146D86B00B1; Mon,  7 Sep 2026 12:53:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11E166B00B2; Mon,  7 Sep 2026 12:53:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F28AD6B00B3; Mon,  7 Sep 2026 12:53:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C67726B00B1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5CA781201D9
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:53:17 +0000 (UTC)
X-FDA: 85187561634.23.4BFD9EB
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf17.hostedemail.com (Postfix) with ESMTP id 986EB40006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:53:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="p5Grs/iq";
	spf=pass (imf17.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788799995;
	b=Y4GBJolKGZpWNSY3SBsjl0msP5i0IASeyNst6pVSFMuAoZJeLgatp0v1TlLn+lVB/1zpCl
	aXMqilLNtnLT7U5P7y01XbuSiA4CzXY1b0LqUM/I+vIDBbP7WhZnli9nIARIIy5OHUC6qy
	G72YbsHsADFoOOGR+SR06F6AcFGSgtM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="p5Grs/iq";
	spf=pass (imf17.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788799995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6KgsraBrUcToWRNGkqj8MPFUdOM/wW4nUtZo/xB90w4=;
	b=uZOYSDwHgdfTfpfxJZVVyvZV4cZb7OlsSv0VOZQUHRmLleYuJ/R/okV5PsxDdI/NgNpf5S
	6sAlRiSoLSFznxOJciUzklOb7FbMKGH6aQNWTDB9qPQiXofWuYyC8RCFtlVtfYjiWLqTeZ
	TpImiLC5tY20hVybOujuq6r+/Iuadb8=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49b0d78a801so38077475e9.2
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 09:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788799994; x=1789404794; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6KgsraBrUcToWRNGkqj8MPFUdOM/wW4nUtZo/xB90w4=;
        b=p5Grs/iqGRVMAr5wqopoakvecNemcUSLOYwprOxFTOc2AwBg0wcxqD8Z7OWTTivtYB
         Ala8lGHjXEO9QrnQc4/u4DPRkPr2znEbzo3Q+ORWH1pd+Rn88wq+f06F4fBsdVAaXZ+g
         n7GlKzsTYu9LC3ZMckBccviUb4ROxX+Xa32mWr3P+cQ61Dv47z/2DYaaQWDgLRBFBWKm
         CKam9cLVMqxlj9TpvcSHjynn6wB5RAwH6uuzHrDnGoCkGZZHhyHvHAv7i6azW1K1De0t
         eAWu1z+5jQHB7CdFmjwSSSshur47k538bXt3GxY0W7vKTMfJEFHoDJBW0lnUXwU8f7X0
         HHJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788799994; x=1789404794;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6KgsraBrUcToWRNGkqj8MPFUdOM/wW4nUtZo/xB90w4=;
        b=rHWFV4de6IEVeVEhKZinRqC0yy1h/LBCsEYpGw5cPhh5pXW5keEuELnd22FvLQ32bF
         cGIthbU3ZjBrY+GK1rP+ovNW3RhP8I2ubiWiBaGHK2yFAFxiqOFArmtoCnND5mKK56I+
         fj36suKfzeZiABJUW7woGKU78rAd0AoZceZOCjtpwubtFN7knvatwfoipBWr4LEfqZvl
         S0L5Vj0cs6qga++d0EV+CtuahK/sUcpiMyvYDIxGJXzu5pnG6Tek87QntTGba4Agi6p+
         CaowdS/3ztRRhywgghQivQZwJ+pNr7BvrpkyoZtF/T7DSo+1BtgKoL5Ywwt4Sx7TSD/+
         fEag==
X-Forwarded-Encrypted: i=1; AKwUvBz11vYwSXKa8+TUpgwWbcnN4E3gr6gWlgKN+p0sEvivmhDcY3Iqlz3l0BpHKg77K7gPDJcgoTM15g==@kvack.org
X-Gm-Message-State: AFuF++kdDXHVNsqmEYjDdmdeo157UnakXpazX/9GekkqUUrTjDyjEqQp
	OZ/lF0e5+0UDEDNeD++1mpPZcfvdL2PQfNN/S1ONhX/jbwErQdoZvKMX
X-Gm-Gg: AYBFou2J13d+jLEPP9/ZL3RlKri8x+nFAiZ2QP10pvX5jjkRar20JR1cGR+LPqJTdst
	1g8P2cOZElHPGPuHs/rGFSJ+dhIZ10sjnxEi05BTWyaTlwONqtLNGzO0DHwBVtWpgTUs5ItxDhF
	RHB/u3hklnqQ7qOh98nvCdmg40u/88kWHBv0YMmMNRUda4E34ZtjTemVIn61VOHtRETwuVlwqoO
	HP/BMLhnhH+6oK8RaiRor6SRS9R68/K41VWM+p87OdnWteeW1r2aDiJtjgLdFKeDs+gHYEZuJ/B
	bO3mZpmD+IXsdEizmT2Ws5KabE0OWE81vDRKC5Mk3h+stBPBTBF4xdfPhbY2s4OvTcmKBCsry1P
	X14JLzbaejBizOy9kJGiawRICZakVh/UxK3nGU2MJNbXvaDAn5T2LTGJXWoRQq4FhfQPQ8eRemb
	itPRe6ZCsmdqNA99KH1u0yU8yq/e862vS6IPP3FXF0Hfhp2v3Rhb16mJkSdjYWfhvm7iKPDbmu1
	UcmJWekdBNO
X-Received: by 2002:a05:600d:650c:20b0:49c:fc6c:be08 with SMTP id 5b1f17b1804b1-49cfc6cc026mr166941545e9.31.1788799994171;
        Mon, 07 Sep 2026 09:53:14 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d03543064sm233022415e9.13.2026.09.07.09.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 09:53:13 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: bpf@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	andrii@kernel.org,
	ast@kernel.org,
	brauner@kernel.org,
	daniel@iogearbox.net,
	eddyz87@gmail.com,
	kpsingh@kernel.org,
	ljs@kernel.org,
	matt@bobrowski.net,
	memxor@gmail.com,
	song@kernel.org,
	sun.jian.kdev@gmail.com,
	tasos.papagiannnis@gmail.com,
	utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk
Subject: [PATCH bpf-next v5 7/7] selftests/bpf: Test mm_struct user memory kfuncs with linux_binprm
Date: Mon,  7 Sep 2026 19:52:20 +0300
Message-ID: <20260907165220.52431-8-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260907165220.52431-1-tasos.papagiannnis@gmail.com>
References: <20260907165220.52431-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 986EB40006
X-Stat-Signature: zoq56m3jktn4rjgqj143zja1r1dfpwqg
X-HE-Tag: 1788799995-563439
X-HE-Meta: U2FsdGVkX1//WfzzhnqkHGvxpJnHV7iQ9WqIcHjzWvt5maVQYki1BESl136tacdICPzvr7q/ziU+9mzPwAM0nIot9wQU3PlE4pnWRRjTDLnBr3LI/mf5K6+ICRW2ArdMJdqmeG54iTod5XK9pPHc6xyzGyrZI9BqjnBMX8BVgk9hGr2iACXSbiJkqDvZx+Uzx4hYypqVkxXt8xL1h09Z66DR/uR+ZKONq+5DsJ+aWVbNYpxQv/l5xipD+GX2ChVsCEa+NvI6U5cmEc9obUAFfjgz6bFfqdmmF6f/Ya44NtE2XaOgq09xBgK6h6aDvyljBXkYCGM5Wmw1BFt1U/mISl2foFGusKNmMdqNyor9dUqT40p+o996O9sFxuPiv0ntE4uOfpDzfYAwAbtC7WvzzUBNlmAYOpNyHxWc32nxq45i+99+zhn0jSTZXg0QhBs0AD442e/ldd23K6/yOH2+RpYTB/dRv/x3+Hkw1Sk3EHS+eQjrjpKu0ATwhzfZFwCeWmBJaok6bV+WFYfmeaGvtUmDJTEmEpgsFs1GmTiDU6peWC68C8F3XzAZYinCR+jKHx1n3ZnyNyrHqliSCjuF6c8Na2Wz3/WrwLZEPvuoPepyYOBMmsLBNpSgBn/QcSlS/rFioNndedZEpAmWUNyfjkDu4UImWuvJT6z/G/942yqbXzhrf2uFNhA62I/JyyVsQC1zr/qjdk6QhH1rRJXzG+qYPw3wr5LR7MBOMnyQudGzolDnNcDey63Z+wXTQGNdBLQNqaEstJHogiNLOoXE4SwC1tERyL4euM2ECjDZ4Jv+5Rt8pirfL3tKBoEl5CfZl0BhTUNEKbq+SSCxj4hS9PCg9GIHBV6oCtX6ryx+t0F6TEhCZvfdCQB6np3/wFv5IAjjhqSNxJ6+7iyeiEHcY6GL3euEVywhjEaVh/UTw4wz+tfByySqABoqB4HlMVMt2OZBOGxTvDDb+rs5ngq
 uV71KdC1
 wRPXK3z4CDRaI+ekjEpeBy7eFulzoWv8OCTfQfcgwCM5p24iJfSs3zuCNBDGVe4lHh34+xtA83Ze2gvYcSk/mw/0cA0J5sQF1tnflt0Y3jYMFTIInhtgfluk6ml9Wvukw0Z5L6hALytKkhSTedDYHkW6xkwxRDABMdAD/xCcX65WCGJv06H47lFDzeK8A8d+MTNm3l6GwqZjpK/iuLIdVjhi0dIBVJ1ggs7Uq9MoPehA3BklQ9ZYsIC0ClIY9lQC75Woh4mzaB4BnsL1YTp5VC+UeRbm3j38UkupNUitgnuXjXZX/hnnbS5Lwa/9g2gg2x8RT4oCmr4y9Jpu1lIX8ZOfJNy20a0KbIsyrNv0WanfWeTVkR0Q00aC6cGiJr0a02CWv/PFrPfzLmsEqPXeo1UwmiL41XPDxqkTejlEOAGrfdYmLJpujmAMZRJ3ao0g+0+gx/3GffLORitNxUpNHmcndQ8v2En7loLhSsQrX3xec4rtQfdO8/KdApGyxyKHVyM9gUzuNDymRC68VjlSUG43oUBLfUT8TVjka
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a sleepable BPF LSM program attached to bprm_check_security to test
bpf_copy_from_user_mm() and bpf_copy_from_user_mm_str() on CONFIG_MMU
kernels.

Starting at bprm->p, verify that bpf_copy_from_user_mm() can copy the
contiguous NUL-separated argument and environment data. Then use
bpf_copy_from_user_mm_str() to read each argument and environment string
separately, advancing the offset by the length returned from each call.

Skip the test on !CONFIG_MMU. In that configuration, exec argument and
environment strings remain in bprm->page[] until the binary loader
transfers them to the new process stack, so they are not accessible
through bprm->mm at the bprm_check_security hook.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
---
 .../bpf/prog_tests/copy_from_user_bprm.c      |  72 ++++++++++
 .../selftests/bpf/progs/copy_from_user_bprm.c | 123 ++++++++++++++++++
 2 files changed, 195 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
 create mode 100644 tools/testing/selftests/bpf/progs/copy_from_user_bprm.c

diff --git a/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c b/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
new file mode 100644
index 000000000000..b2325b193576
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
@@ -0,0 +1,72 @@
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
+	/*
+	 * On !CONFIG_MMU, exec strings are held in bprm->page[] rather than
+	 * being mapped in bprm->mm.
+	 */
+	if (!skel->kconfig->CONFIG_MMU) {
+		printf("%s:SKIP: test requires CONFIG_MMU\n", __func__);
+		test__skip();
+		goto out;
+	}
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
index 000000000000..b334a157419e
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c
@@ -0,0 +1,123 @@
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
+extern bool CONFIG_MMU __kconfig __weak;
+
+extern int bpf_copy_from_user_mm(void *dst, u32 dst__sz,
+				 const void *unsafe_ptr__ign,
+				 struct mm_struct *mm, u64 flags) __ksym;
+
+extern int bpf_copy_from_user_mm_str(void *dst, u32 dst__sz,
+				     const void *unsafe_ptr__ign,
+				     struct mm_struct *mm, u64 flags) __ksym;
+
+SEC("lsm.s/bprm_check_security")
+int BPF_PROG(check_exec_args, struct linux_binprm *bprm)
+{
+	u32 pid = bpf_get_current_pid_tgid() >> 32;
+	char data[sizeof(expected_data)] = {};
+	struct mm_struct *mm;
+	char arg0[32] = {};
+	char arg1[32] = {};
+	char env0[32] = {};
+	char env1[32] = {};
+	u64 offset = 0;
+	u64 data_len;
+
+	if (!CONFIG_MMU)
+		return 0;
+
+	if (pid != monitored_pid)
+		return 0;
+
+	mm = bprm->mm;
+	if (!mm)
+		return 0;
+
+	bprm_argc = bprm->argc;
+	bprm_envc = bprm->envc;
+
+	/* this is the total size of args and envs starting from bprm->p */
+	data_len = bprm->exec - bprm->p;
+	data_len_match = data_len == sizeof(expected_data);
+
+	invalid_flags_ret = bpf_copy_from_user_mm(data,
+						  sizeof(data), (void *)bprm->p, mm, ~0ULL);
+
+	copy_ret = bpf_copy_from_user_mm(data, sizeof(data), (void *)bprm->p,
+					 mm, 0);
+	if (copy_ret)
+		return 0;
+
+	data_match =
+		!__builtin_memcmp(data, expected_data, sizeof(expected_data));
+
+	/* arg0 is at bprm->p */
+	str_arg0_ret = bpf_copy_from_user_mm_str(arg0, sizeof(arg0),
+						 (void *)(bprm->p + offset),
+						 mm, BPF_F_PAD_ZEROS);
+	if (str_arg0_ret != sizeof(expected_arg0))
+		return 0;
+	offset += str_arg0_ret;
+
+	/* arg1 is at bprm->p + sizeof(arg0) */
+	str_arg1_ret = bpf_copy_from_user_mm_str(arg1, sizeof(arg1),
+						 (void *)(bprm->p + offset),
+						 mm, BPF_F_PAD_ZEROS);
+	if (str_arg1_ret != sizeof(expected_arg1))
+		return 0;
+	offset += str_arg1_ret;
+
+	/* env0 is at bprm->p + sizeof(arg0) + sizeof(arg1) */
+	str_env0_ret = bpf_copy_from_user_mm_str(env0, sizeof(env0),
+						 (void *)(bprm->p + offset),
+						 mm, BPF_F_PAD_ZEROS);
+	if (str_env0_ret != sizeof(expected_env0))
+		return 0;
+	offset += str_env0_ret;
+
+	/* env1 is at bprm->p + sizeof(arg0) + sizeof(arg1) + sizeof(env0) */
+	str_env1_ret = bpf_copy_from_user_mm_str(env1, sizeof(env1),
+						 (void *)(bprm->p + offset),
+						 mm, BPF_F_PAD_ZEROS);
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


