Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62ADBC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:24:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A1066B00A2; Mon, 31 Aug 2026 05:24:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0788E6B00A3; Mon, 31 Aug 2026 05:24:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E83996B00A4; Mon, 31 Aug 2026 05:24:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE6F16B00A2
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:24:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4F4D5A3FF4
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:24:03 +0000 (UTC)
X-FDA: 85161027966.28.4E6E481
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf08.hostedemail.com (Postfix) with ESMTP id 85FA416000D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:24:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X5+8L1RS;
	spf=pass (imf08.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788168241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i8u8KeUtgM4fV7u/x1/LAbjzMrbujtoGelddq2lUEz0=;
	b=PnqprCFxn5Bezhm2F0TQtU4d3owY0TgMJ85OydWH8tmt6uWw3lwdvQI02KGj73Anwam6dJ
	Pw89APUrG459JYbMXEfPWG7HfcM61mAneiFjBwVDXnJkC0PKoHFeJgdjD8DZXt60BRwH74
	b+MJyzEzMDP64P1s4thbPU3hIs5Lyjg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788168241;
	b=geEa+PGRdUr+PhDq58u8OYP22npY10D7kPmuEXfCBE41mHWWo+Vn8r6DFlwVdkpvxq/6CS
	4mL+SVUNllQbPmB517gVHVG0bOKYk6STL0bW7tnoeS0qr3lZ4oqvw3q5QruboAuNarVTDe
	t23UWbe7/2eJ+JUEWH671osBlu8+zJM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X5+8L1RS;
	spf=pass (imf08.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-484392e3d33so585448f8f.2
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788168240; x=1788773040; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i8u8KeUtgM4fV7u/x1/LAbjzMrbujtoGelddq2lUEz0=;
        b=X5+8L1RSe1/ZSEv0/qepcfBfnB8Fzbm+qjWpw8Evx8wGLxpHySC9NteQgylk61praT
         I3RqES0Gbh7D7n5L/3nrIC3fZ0mBNX5UJ4AawSik9TJvxuzoMHWA7kg+ftTlbHhLqkus
         6XZbuuCxL5CoP9d2qVyq67Q3PyfFvvf/nlGRkyMvypYb1OPf3kSOsZWyHra2RYNFijKr
         n+BgSYM8I8hgzVmYMTMsa/fhMSUBR8VRbHJtsjTuiE3GlvIkyNgQ3FRkDHH0CwDAftfJ
         LN0587qJTfCACTSmDF2zZuNVkf/c2RbZMOMedP/5456PWvuvk+RyDXj0Kffx/mSd0d6F
         Ie3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788168240; x=1788773040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=i8u8KeUtgM4fV7u/x1/LAbjzMrbujtoGelddq2lUEz0=;
        b=L1QaXR31kYSK97q03sxaW6Fi3jYFwP6iCoaI2l6Q9WYvscITbd9nLwqmIqiOftypm/
         ZH/UK4isYoD4So9irfllhEa0llfs+TdRyJTQ5pESxF4X4+322aGTP9o+7WIJpnS+HhSb
         d/qK+jvc04X3fpA+RgZlLTG6ICI8kfHEQWRdQmSFFTsoFp0d7UoUygoBZN01UOBvX+f3
         DI430vXNbB9ZHS3ey2cUdUMmkSrZRd3mPD56bKlQ9Idl9WtV8lQTZmpRScf+9LtO9m5g
         5oZD0P4Wh8nH3U48hU3iyRd9ODjhcZg5bKZDkNWUdjQg1sJBTwU1BIjxjRsCF04ZFGIw
         mo3Q==
X-Forwarded-Encrypted: i=1; AHgh+RqwKU8LMa7i6AUaJrKPbF+cgb5MqiVTHl36ovYDZF3V/+SYo4sl3VbDgsKAciFoO1LMB9775Qz1TA==@kvack.org
X-Gm-Message-State: AFuF++lNKQxHkENegEVjD3tCOph2mSAwFch2kBPMoUCha5Q8Mt1GJ+J9
	a9KG6SCDNPBu31jeXxou3P88yTZoQxhf75hJGOPha3zkqOQIapPmCClw
X-Gm-Gg: AR+sD12QT+7aV9SQAKr9QGPa+kGiqA1H7byK77pkFsxbeZBLtcPgu6eHv1ZAhe6p4TN
	26BqCCvCYLdUe2smzgLs89zH3kStgy8vt4mfU5BoU5iNvv7lUEcdDYlPdi/Dr30cb6yl7WB8OCz
	Kd61ywg1SEBGJf8ak7lpn2CZETJwdFOPgj8B/6S2nryobGnPG3HTSBOLBbdlcC37bNmXWUyfyMf
	MQo6UMZHUTaYmOLIVJ1Oe13XNY2tPg8m1iUc8ii3HVdVNjOp2sMCv6+YGI5XOVAovpvZbk+6mVr
	aaqzxU9Ilr/dICk2gdgW1IRXJSuTB6u72BmKa6ZiKT1+TIW0tK0qPIaToiYBjoZdmz9LM5WaFUp
	r06jpuCzwwU9wH/W8k5+RicHinzg8XNXpeUdEWR7vTi9cA16Au4wQ1adFl5aRh4N5IInRaF22jD
	MEc7fq+fYtpXBSOOlWQzh/mmNq84IRlSXS0dNSO8LMCQUdB9zkVeWT4BSjVOLxB58phFGF55NOs
	g==
X-Received: by 2002:a05:600c:c4ac:b0:499:a5fc:2087 with SMTP id 5b1f17b1804b1-49b91c20e36mr367057785e9.6.1788168240083;
        Mon, 31 Aug 2026 02:24:00 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b9500c80asm318248155e9.9.2026.08.31.02.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 02:23:59 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 7/7] selftests/bpf: Test mm_struct user memory kfuncs with linux_binprm
Date: Mon, 31 Aug 2026 12:23:05 +0300
Message-ID: <20260831092305.42062-8-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831092305.42062-1-tasos.papagiannnis@gmail.com>
References: <20260831092305.42062-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 63mnowgkfck567xotq15yo5mcynkbyw7
X-Rspamd-Queue-Id: 85FA416000D
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788168241-254427
X-HE-Meta: U2FsdGVkX196rQvfLhxIeJ3+1mQDelXUGJOgwpgc2iAxvwCM1PjWShpE2E7jn0Py0aSEPbDYEbbnFX2H0SzdAPY72iF5lBIeqw92ZSY4HlbPg7P4RP7N5MCMeSonZQL1zcVtDEC22KD6Z17Wn4x4br2/TuY8ADUCbsG/NEYeIjJmP7bQSnsSP8yKUY6wLvakD3sN6fc6iBXd8DNiGqs+wxZtf7Z8q/7B9R9oIhTErMDSRT7f8OxoszNVF8x9wE9VS4phaT0kkQllOFXSHoixgln/cmVUVLK5PIjimqKi43jutzwKYc2ulA9uBACMX6clEj3n5AWDxpAhK12MiJuHkBhnfx21COMsvJRu/5ptshZzvnZVE0z1oztgZYxENCrFTCpCbVVFXLQX/5uEJF5WMSLlUZiTpougoSAzhRQwMytDgDXeZAdURqKzKKo69Wd7zv8DUmgLIkaVBXLeAEdxmUjuSDvPyk5jUFpECdkb5oo+z2cpCA5GKPUOLLK27fZPPspJlmJ0tmYbE8EOa1Sj/Ys+ayeVcvwgH06ayxVUE8RGDjgK2qkUf4KN/V/VyFs0Q5Apdk5tkt7+ZDl1e+v3knZFSwENTkOeXvnjDmK01Xn9RFDqF+Tv9QPS9kbNFMOWGSBvJNIBI5bo3RmJ07hSKUQERLDAfCpxgekYsIeLVGEvLn/gNt2EtT3MwueKhF8FemvSE2PdIB3G+cqzCRcUbhqrpLdtkqhmPdzJ3lcAbfXYkfmIHeN16rco+3qYROII33+E8m5NVL8Jq8ISGdxdnWlv/Sw9gxjyJfuyeAlJwFBfv/XilAg+oG3MGV0aBL+KJyEXbd7Mr4y1RAI2JJwXR42HPSXcKXETf11K5aGdgy/18Rs5aaFdyzRDeWKo1Ld3na/qQqL7sAN729ybRRdlbrEVQo3ketE5s+yZBiKg0TRdgmaJmY+2W3hkH2Rmsalgk+rkRi/MUJVXPL+nIaU
 8RyjKzYe
 V74ZddO29/a42N3/IZf56WvW//oKFkEdH0iQg10FHl6/x/G1MKC8dz8k8LAFoKA5SFm5j8619Tc/0CEPikdUX7BoBLkzycIbQ93TmtKYulSrNvFanZ1qI0r0mTRHViUJ39T13MBJxgu5Qt7Kdyyv9TqRKJ/yEPMWeb6tZlDyazxaib0iGKHCln/MtlM163GcqI+Qo5y8P6w9rwBvBIVHWoJPSgAqZVpb62JVf54kdI+AOMf7I9rw03ts4LALgCOB+EJ+bqiO9ZVDQJkrUDhf12zlpiNM1O0MFtwPVMAOocl2O4OjUtWqHfKT8r3uFPh1kRcfgHoCQ07HtvUcstMDFNRs/dNpoRWWRMDn4aNamQfUZj3fqDOAEUlHuKBcCVEswNph0HyfBLqNUTYI1vgt7yt5nvvxF1PtMZLkfvVyLFX/I9PjbQ/GSoQIK/2W3esrXNxo9REDxv9H3houmuW0tbHieC4+Y+8AfsCn6oickvuD+hkctMYeIpI+JmXIURGRrNlxOlnuOSTcbxWPXrZWDcg3loJgkFGTqrDmv
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
index 000000000000..a0e2d1c86c2c
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
+	char data[sizeof(expected_data)];
+	struct mm_struct *mm;
+	char arg0[32];
+	char arg1[32];
+	char env0[32];
+	char env1[32];
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


