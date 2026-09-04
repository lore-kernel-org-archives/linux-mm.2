Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1989C79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 14:54:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FB416B00A2; Fri,  4 Sep 2026 10:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 385516B00A3; Fri,  4 Sep 2026 10:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24CDE6B00A4; Fri,  4 Sep 2026 10:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F23D66B00A2
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:54:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8145AC01FA
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:54:42 +0000 (UTC)
X-FDA: 85176376404.25.5E18AA4
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf10.hostedemail.com (Postfix) with ESMTP id B3806C0003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:54:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OOysHydY;
	spf=pass (imf10.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788533680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6KgsraBrUcToWRNGkqj8MPFUdOM/wW4nUtZo/xB90w4=;
	b=BBi/6iZRVoNcqKzpaLnAtaS23JJVRCSrp4mrAmpuoTHGGe/3g+Yj0H/f3Fnajc9WKK9qa2
	lCSWOEaBZ3zjGi9ZT8HV/WvMIgFn6AsSZV5wnsPYBO1V6fvtZHeR9kOGxbXJX4IZIPn5lN
	Byi5jjANnBYWO9FmftgS9aWEgGi2a5g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788533680;
	b=ZjgASn9d9P0bvotMnS3F97bfvNz8c1MqbLl/mhGLGUhfMWh6m02Ty/wfppqTaA3S/+zWfy
	aB6SdOBBQ0UARCRRCWNi8ZuaU18P5wTahNiZTrqlTxIWHg3x5IB4wrYA1o4sQx+4jJsb7Y
	jnt7e0xD14j8eSKBNe3S7c1s/aVrM3o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OOysHydY;
	spf=pass (imf10.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-485850cbac3so713103f8f.3
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 07:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788533679; x=1789138479; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6KgsraBrUcToWRNGkqj8MPFUdOM/wW4nUtZo/xB90w4=;
        b=OOysHydYAi5pK+16L1OXH6WxYFIX+yf+QwBMKJlCxiBOxRPSva0X0Ym9R32BpQmUjk
         HvAuEFlmwD/FaOuyf7LNURTq1yvyBxozfjzx7J4l7Yuvz4tUUnE8KrMbXbYTA3+u+Bqp
         ZaOty8jnXoFZaLqBSN/B9y985rmjUXTa5EltKn/fCCJjZq5jTVHgL1kEV8uCVwv9YfbY
         8FWj0umifjDlOJ8DxvaRXRRCHFXJi41udBW9Lk0XUS8XoTiGrQYsH8nyt/KqmtAK3x6S
         qSmyG0jRClSHN5yhY+rslKFEAhIl2Ei4fDJDTj3M89DKbscq8LJUAqgTr4wLDTZrkpCm
         H20Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788533679; x=1789138479;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6KgsraBrUcToWRNGkqj8MPFUdOM/wW4nUtZo/xB90w4=;
        b=CBD57mwCYeonYTV07aySygtNa1OO4S/EAKfWBU1TcKZ0dKM+GujHFd4FPrVODf6SEU
         hnoLy813Ypj6yE1ERrZUWdAdRHDo3gNF1PnMbFjwnhkRQGcayYG/2c2TBHt4dDIgI9ln
         0Jyrg47nPZKTPaiD0MCkzyHV+3kbnOktK53WXh2zCkqCyCTL0/gix/fUPiN7nRVZafgb
         hu5ePnmq7Eegtgq2EAZFm0XbB6/z1MtNvdjWl+1IXi6YwVU84oTgmyYBWxFN6ZYJfKP6
         QG/1SAfiH3D6jn62JnAAQ6ZcbZ3DWl8a4LeRFAoTZwuHCgCCMZkxrJMGcjHgXPYstHUp
         9pvw==
X-Forwarded-Encrypted: i=1; AKwUvBx+Cxo4Bun2X+KqX+hHedYJR4vC6MWBrRNjpQ4XQ5roTuiYU3bMo555J2XV6khkwkpG9/nXuPRqKA==@kvack.org
X-Gm-Message-State: AFuF++ksT+Pj7knAuyGi7cAXFmy9+41Zf1fAx798HbtWR9yqBtW/05o4
	3BF1iDEn/arHTFLcpEzNbx1GI+EgRyZSbBITp5fDo826z1MFMwp5Jvkv
X-Gm-Gg: AYBFou1uOF5KT3eGdDxVQugTehSMaKDoqiLcGnfKKD79AA3p+7/ZSVofNZMMM7enbNI
	HTUfZbSPsNXB+OtT3cmNco7+RCgyrH83Cjan/vVdpv5JXQw+NW8CcgtpoMgK2IcvoqvuYJGBJjh
	xPXlIGy2nWN+NGuVWVJf9e3Z81+0kEZVuqo9+4w0ajEPVsWEqg8RIgiSMNvIycNauWLSWG1DkuR
	akKvia5QG2ujEkVgoaEAGcpXu0FwQ2ItK6+cb0ZG8UVK460/pgim8h0k2Mt4LYA0zO4Dsp8EcO5
	oHRSiumrRHvr9DQ94Ny8RNGpc/eEZLAKw51jq5s5vYWfAjuakyTxHCGaV14MqjlqxkZ8+pEWfNc
	6/j3VzByCPYK6QaMUB7R6gVTsrfA+dN5C0jR0wPWMfNa1sNTxFQKgdeiVfZuavXLF+nuQgN5X0p
	SsY3EueeIFgure3LsmAMM3r0shna8IDnqd3D6funRA5gT+Yp5qnY2wXkXKOt1a3P4DTZWESG3la
	w==
X-Received: by 2002:a05:6000:25fe:b0:485:8cb8:b838 with SMTP id ffacd0b85a97d-4858cb8b900mr3127211f8f.7.1788533679283;
        Fri, 04 Sep 2026 07:54:39 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485885cb03asm6802799f8f.37.2026.09.04.07.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 07:54:38 -0700 (PDT)
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
	sun.jian.kdev@gmail.com,
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next v4 7/7] selftests/bpf: Test mm_struct user memory kfuncs with linux_binprm
Date: Fri,  4 Sep 2026 17:53:40 +0300
Message-ID: <20260904145340.40212-8-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904145340.40212-1-tasos.papagiannnis@gmail.com>
References: <20260904145340.40212-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B3806C0003
X-Stat-Signature: 513duudfpws51ocbfjxd8desz5mt4zee
X-HE-Tag: 1788533680-394654
X-HE-Meta: U2FsdGVkX1+Hr0NtCB1128+IRQVmcgYPq6ZYpbhG9O2FWgfI/TnXII/e//AjV26Vfy4YOs4EBkF09tC2rRzL/ft48lzAtSKvuqNWvBzansj3hCfWg3aeQm5G0qoWtjCU4Tep8+h32x2b1BGkk5u2FVbQpi1S8TfX7h0mE6e6MtEEBoiJSp0VGobotS6wKuF3vFcrKGEta1YB56cPX94NfdJb+ETjC45OFGaukqhwfy2ny2iILfv7csvSIAdyTcvyVGBgj1A7lxwx2K0/6hNFV/kpm6zb8MeznnODcjccGOGK51uT3g9uS80wviMw9AQsYJHbmBz3vINXaEkkHV/0mNIJXAZuTXfhReo3ozu0oY8Slhw9/aqzATTrYfenk2nOKUOe/U3oPgDVmYUJarRbxnjElx1T26CW7n9MSynWQjIiJJGZLfxvaIirbfcKLSnRCWVKZOnVn6TgFiBRcLr7oEvYCXinc8SjQ1WB33VRGl0E9/RBxkM+Jz9RM4GYKPQZoGeOr54geE/psWx8jLs+bs+XFnhO/CSa7SrDIciTGyyyfE4cZWh+alaKTnbp6o2FTXfrZ/wY4J6m0ly4spdXxsiXfMFVn1CH8Fz/b5iEvBWhWmAkv6yskB5ZEPk8dlGYwG1OOTuR+fvTUjOzY1Q9dlIFvjpUFZZcL0xkQlegG3aZ3iUnOZYT0XJqUewIkc2vgt7nWSPBFrwBm8C8UO3HWnaHgRg0+kdEmtvGeAk2X1bmsci331Svw6SFvAYbGTXiskNp6lc8lHkc4k0N/x4Jcu7TzOhMOs+lDqzgcaluKpLJG1ZDGkWpCq39GgMYeR5sSLXFqwAWAkUHgcQdQRZMPt3W0n1xSRV0Nrq8rmE//zm1FICjhahQyTI7+ZsP7OWZmW5MAnI4J60getlBeVqbmIpXm5Fqx2oHABesL9XtuG8rSc7awn+Ejy5Elk9Q6Jl9i19zLdtoajTTHoONioJ
 ifO+Ttvt
 IEu7wGm6CKg7lT4HmQeWJiigKv64HAObY/AtlZdTunMYG74pNEAKIzPqd3TLLAZG4GlkI2Zn9ldOdTqxc+q+kdR+I/YBTCbbe3ypPN0Wt6yrQyYpPFOkyTqvxpT7rPk6wYUhWxaolgr6+QcAONgvQXDUbF2YZ7o25DXsOc4/V6iuXdHSlmR2gVjVXziq8//PTVkmn/Fx/3YyWWHTyJnNE5zCLtG05oIiOT538Q67d8OYFFDSfsee3JcUUyQBxyX3mLp4Z+mSxowLLKr6VKV2+kp97OR0vZgOEM6vDwb/DzJB/oxvrYf/XEeIr72hVHIB6iwPwZwDZpGIecMOTGgAop62YB+WXCPv/EOWU8ZwJX4DP0ZWt4CcXTxD2P1dXP5J7ydyXtSmhGgiKpOusuGh+LksAqlfW/ITBtse/UjCAFkRwTGCT2nRhjoxADJ4Ry4PdWC4ev85JrQcpmyH+RURVkcGFQD+LkZcD0r6wmG4K7m5jfP9uDGwgIR2Zo/hqcttiyMPx/BarvXAOQ9TvOm5CrsvQcEloIxgUkfyg
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


