Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDBA9C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:53:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 724996B00A7; Tue,  8 Sep 2026 09:53:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FCC26B00AA; Tue,  8 Sep 2026 09:53:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6125A6B00AB; Tue,  8 Sep 2026 09:53:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 307666B00A7
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:53:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C6334406B4
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:53:53 +0000 (UTC)
X-FDA: 85190738346.16.FB5DD88
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf18.hostedemail.com (Postfix) with ESMTP id EEB1F1C0006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:53:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HWnpEhGn;
	spf=pass (imf18.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788875631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6KgsraBrUcToWRNGkqj8MPFUdOM/wW4nUtZo/xB90w4=;
	b=tzIZDTOiMKwjHkiNj1bkn2EgGrKdWwSv1/3mB10/e8alVU8zhO5XhcPNY1X/dWto6HxLd5
	n01j29KBW+Z3c3HkvogZQX4BBH9jdYs7ywXmkSWgrm32FV7Pk8SdKJKizBGFfteMcG6x0x
	XygzDJhyPHceNFHXmlRqsew1c/SN/nM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788875631;
	b=7OlCk4HMLLOIyz10gXnRVRobvqOOC5MQ2wV+HIMvm58itECbHhuHdg9GE4MkjYTpNO2O8T
	uDYTXyKj4oT32FIZNMGlmFtgHGOfBiOFFIk9kVyGr9jZuh/I5OaVWf0tQMze1sH4K28lAW
	PlSm+mCP7fcNiMAFVS0HoLlokMH5sb8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HWnpEhGn;
	spf=pass (imf18.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49954b88fffso34598315e9.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 06:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788875631; x=1789480431; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6KgsraBrUcToWRNGkqj8MPFUdOM/wW4nUtZo/xB90w4=;
        b=HWnpEhGn/snB48xiqhzzDEDjdzXYIAiL06a/OjhVaU+68E6fM24Sr/k+qLbEpE/lX2
         IWOpdqZ7YCxvsDTd3P3XjQlXTpDDxtTAF2415RLfzHymVg4i4wppHJI4E8MkYoiNEN1i
         tZE+8Ctb5DBfHgkRvjfGA11em5IS2ktGVcZ5TJamf3aksKloJBHQ/Mg6y6hakR9hKVVP
         dcmShSJAjRi0MR2JJYNadRvrYTaNCobtmO6+2KIpWhre/YR2WWioyd0AH60+7cvwniZK
         TtcSRtLoAEIsPZkziSS0GaltPWzSBTRRXG/lzUpwVjZgZAGcUE6hCaNRz/CT8L7ZHj4i
         SuxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788875631; x=1789480431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6KgsraBrUcToWRNGkqj8MPFUdOM/wW4nUtZo/xB90w4=;
        b=Jdp+i8PvaXESJC7IiZW5ErAILojer6evJJpK+cnuTfwa4TkIa2Zl587LOLMO3Lw7D/
         MH4mXxum6iAYNBxcZOYpO0qdCnr6XlBVjYZgsDosO+eodFhw0KjueX7JAu/iLNpwexzW
         XeZbVUZ3HZEr0LEqUJawXboa5UNOxxldS7oLaQ4R3GZPx/2CVJ9FxFZGDyLDsZ1on1UL
         9AaCqaIEY4dcZKH5eS6eE8nF2BP9JkaTPkWVNgqfrLQpHSXx9gPuiaBE5ZyIxHMJpkMX
         TNpybGd2oN/wdPh48L8yT4EJunS7AWK7BOnFZYvDBIruL2uu6/m1dE+vk8qsZWvsL7BP
         VFjA==
X-Forwarded-Encrypted: i=1; AKwUvBzMQTVZMECCofaKFXWSShD0tTyTqYBKsDfqWAehAKFDiviKajyqCNdU60dc8fGPUFtYIxKVjBQ5vQ==@kvack.org
X-Gm-Message-State: AFuF++ljsaPkmj7BXsd0+RCLs5XL0IzoVvXvNKUN7kb5hSQGYJ7SOr2Z
	Wtft5UOHRZtAbId+qk1l4tQ2ScThyAKniTUL4Y5A10XUUUhy+DE/aNxg
X-Gm-Gg: AYBFou3OVtaCss5xusMsWCInMEfW4FDOFHE+95ySMizx+ehhUYuSD6iIBf+D6JFIb0d
	BEwsdRzuDzHv6NK6z7zwFJo9rEgrMuw6pCosTzQqSKe75EcCiJZ2EIUbln7ORYTEgJyXp6y4/4R
	rcYNkblpj9dTJ/I4v9H2sW+BlTeMx3MNkjU37N7qdJtCyLXUecypf38pDbjy2MD1xvq0LUNzhNj
	GAzaWmoYRCcs4v9Ens6giWEjMwY+DmRUhRZDx4gsmuJQIgoym0WGT73tGQJgiR8T2EUK5h5tP0Y
	HX4Mqc1zJk5GagUoXv2z/reEn0JBsg7AuqN+vVy398oXNd3VVsf6X/rL0yHvpf5p0lwKHrq5f+U
	jrRn4CRxBfYdJ6WykYK4bKuewPpbn3Y0UVgvX0+N7MmzDZaznP0eptj0u0MUSCQMogRbLjbnLnB
	5qOVg4ZgNE/Qpyem3UMmNK0aZftjHRNw9whg3e7/1krb7aWFnMQNQB9uVzD+m2k21yc5au8ZLC3
	A==
X-Received: by 2002:a05:600c:5493:b0:49b:8f18:714a with SMTP id 5b1f17b1804b1-49cf824a6c5mr305378825e9.12.1788875630341;
        Tue, 08 Sep 2026 06:53:50 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ce5533ffbsm377235005e9.3.2026.09.08.06.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:53:49 -0700 (PDT)
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
	utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk,
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next v6 5/5] selftests/bpf: Test mm_struct user memory kfuncs with linux_binprm
Date: Tue,  8 Sep 2026 16:53:02 +0300
Message-ID: <20260908135302.74963-6-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908135302.74963-1-tasos.papagiannnis@gmail.com>
References: <20260908135302.74963-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 87s1aq1htxai63r7zpbc6npgwc9xxikm
X-Rspam-User: 
X-Rspamd-Queue-Id: EEB1F1C0006
X-Rspamd-Server: rspam03
X-HE-Tag: 1788875631-993620
X-HE-Meta: U2FsdGVkX1+KkYuRYrlv5Rlkjz/rWCu2GmtVcVtDwLlvHh+E4SZMBMNGmVupBqWnlHZEfZq1c5jyJyAsvfIzUtdfE2JsvVOycDYpmcVFYtO0afw2Lken92r7rTN4FYXtrU9u7CzTyqdtHmjPmAIBEzulknrsfXOHeqtcmbvyI7w4u7jErxF6blr5F/ZNnCx9sRS/hi6geDS/CGvNyIeqSlPqsQDnl1HmVk9UNgmg3WSqdVKTnqqurG7hvjUVEQkWL4VkpKZ22e/WD6jp5TGbZU1HYpc3zFYVn7sJwrHWy70/+KreFHh+8sZ73VB6GUiPiLa/566Dx9FkiQwiMLSXckbbMXd6QcNYkZcgscKyorRbcLdU9hPDEFlfFgcESzNQj7jOaVgv69CUCLEUWDDn3Lb8U1vuZ/RNFYNq83lSVE/qkDGd2OAowp+RWonBJPGtpP9NbLXLHGqMB34/NbM0Oc1gs6dUwiBpmsZWg/PHmXUYBWcHgIvcSendkvTyE2NSvPjDHrH29/ys4YhhM8xCBf/1Ipo4byRn7GP3DOmI13Wt3Kh0uxk125lZ5B+61T+jLfVkhovPVL6lSnO9Ie1F+SDrBk9I46/Z9/qIowOsvOtwhanDPTyp492EFKT/ONMKEBAUNkYtCOEUiTU3Ah/BLzpgMC5F2DLCrhBEAAOUqt2EO+0zF759px6JajKX30VCcFdsglp67mIFbmmyAhfBFjAU0lel4x6PY6GdP6GVa1MsSy1yp9SpKeOSeqhR7HdH4/WC1EQPfz4KL7JzcUwWWY/tSZLQ0jQHsQsSciCaOH8den2/FDPAo+ogwzOyqgmeCSRk3THppQWB73KigaObZvIZV3FlyCSXythxw9AGRI6LbBAJX0TNN9PsUctX3ZFzdFgWFtEXOy8kkA0Glbw8Ws2DBI7ijV4x49iAPJPCMm/I46HmxCHx1FOhduF8C/wqHN1CunLaJOhiYIZkgCY
 XMrf5UVj
 JybmNYslG7Hzd18heEiiManKvLOcwNJSzEedqFHSAx8zq8FrFrmYpX202SDHBONzSSpkCONh9zD8Wd6IiOZT0F+lBIZI1j0BOPhrTbnUJrhpfsMTcNS2XhdlAKq+RUSg/J6O+f+VDcu1th66DzpDX7WAM1hgDw7hDcDMpyd4GCa/A0gr2CM+uVz4YnbFcXgPmTcMri75ZXhE7fBB1/CvLS5lo9lsY1pUUefZ9xEnJkgSTX3uRE41yJ4Mv0/MdDFhImxr7gmjqMoNx5hPk3k6usSHOfe28Saqj15yF4+ykusHEtFvYej4tp87mmF0p0UoBMqXLPhm37mh9ukviqDtjyq4EhrlT+ZOUWiCAYpwPncRQ1SXHT+52E5W4YFmeNR1C4McuIck73a0C2Hg/ilP5r9ZeNcwgVIN+4aNZ+fBjovX3j7Gup3VrN708SiL4EclEsZTdnQwaIR1/wPah9smTgGc6JUoBpDM4L9KLTBTlbymMRRZ/EGziHdeT+mRP3IdYc8XStCH3W2zh2Je/N5EUHoZ2cYc+1mjbTiKG
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


