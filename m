Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72832C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 11:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C7BA6B00F3; Wed, 12 Aug 2026 07:12:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 850776B00F5; Wed, 12 Aug 2026 07:12:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C98B6B00F7; Wed, 12 Aug 2026 07:12:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 396926B00F3
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:12:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C095A12028B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:12:20 +0000 (UTC)
X-FDA: 85092353640.17.A7DD4DB
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id 09216A000A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:12:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Qv8iCWCj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786533139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DniDtpSNvo/ABReRZwqLfy9Ok6b/HLHOLbbY3qeelds=;
	b=UR716QTfIiOxgt4s4vhw1zSCQEwh8v+40oZzI2kUWc+4MjjABS6rQmYHXKsoUQ+qGFje3I
	gbsFuL2OyB2bW8hqwykSuFq2aiAj31KKiVRGTNv3PdO9i4Lz/5eSiKl2h0CKBVRjwyfr8Q
	Fk8MNWX3CHkZ0J733DOfr5NIvH3pwMc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Qv8iCWCj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786533139;
	b=r9Ay2L9QU+v4EPK7laMzmGlYP7zzHQx6v5ZMWXmRTAGYGxO+nhQ5c/aYHcgdBb/n1KEG4U
	iFN9jXhDQvQa7XSqoLVGPq9U/nQfF9nbVMXGjNlB1wIyyaZcQrQiX+IjnqoIjSWTiDln6l
	LcJe8QxF7LHpQ2wSm8zGAOVHVv1HhEk=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-496bb7cdf51so9303435e9.2
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 04:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786533138; x=1787137938; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DniDtpSNvo/ABReRZwqLfy9Ok6b/HLHOLbbY3qeelds=;
        b=Qv8iCWCjXryW84bn4VmuCPeTHVeS9I/9kInLFXE40hNW/oER7TsQrk/KKPBZZy+mLp
         I9qgtE+EK/0Tg4uyz4MYHsRmX/Br/h6QLiqrkyY6Qn7Je19xKay74Vi4mfTnccu/zWW3
         rmsnEajvOtn3DeO4EwRsCJI+hjU5Ucz/r4dfD2kfphbWSIIFQBXqDfyV7VtH6HNTC+/r
         RI/+nw+e3leL2E6WIdYg2bG4H9y2tLpWWujtGKloHOjRqphJs7IcT+e6iE7LHpTIevDn
         Q6AcaH+WRM2jFFHtH49Sk+2hVy1ceOMGPqC92OjLOTY29HnhQ/VWefwWLqCpNAgSbWdX
         CWrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786533138; x=1787137938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DniDtpSNvo/ABReRZwqLfy9Ok6b/HLHOLbbY3qeelds=;
        b=fNYIe4uxG8JtVCoECBSwgUaztcqAx84ffEtVxzdv6wMkvMvWzYARElhe2xMyw8pN+F
         U3X3+Xxq1leExb7RsATEDR72WlhXhicE7NoqlwoFir7H9Dvj/GQmp0gEQbqS+fLGk8ES
         n+YgIZr1DHH9pn3gghzHG4pIlPO3IzUIuNeAMKWFm3OOinRKGaD2ST8yZvnCpXWaJ2oZ
         MMlBJn2gvkYJdYZgCdZQiVJyd80XuVte13gA68BRj+25085KZIgW3BRv0S+CsYxHqJFZ
         i9qkYYmBrqO7UVr/uOyUNhIqz6vv6gOv7DB3dhEEdy+gLmA3gFj4rPVOEXwsg0EK7GtI
         Dl7Q==
X-Forwarded-Encrypted: i=1; AHgh+Ro/7mwDqvAlmu/3pUDr/9E4XMqq+aJo/QAGhLQ+55x+H/gNQYg1h0pMvKvrG3n/4Zlgmbun6QIo1Q==@kvack.org
X-Gm-Message-State: AOJu0Yy0cTzwn+yDfv0c3v3VyCsFVexA7EkBP0wm/T+CQ/we3FZtKqwe
	nT7gR5mug7vz0IXCFlHuGBUl/7rx//iObBQ0scgpsAdOXv/1M0PLcFNj
X-Gm-Gg: AR+sD13q8CLFOl3PSjhoQliW5BcHyuPf6ypB8MOjIp9a5EhK1ibpAG/FxnJtl4kQqTp
	yxyeqzDR03JzrsKK9T6LU0VNIjJ3isL3CJWMsWxKdHarK/PnWtoNPdGVILoLAwY4JGva8oCAtvs
	tAy/4d90sacKmXaF838g3jLKk/BoQUbj7DqYOXRh1su0AbyEHqmZsh9hUDMkmGR19s5s6uBgKkO
	goin8X6CLlmZbAruXaUVZ9uD4uEyVQdy1R8rzwTLWabxooDYj/Erd+N24iwal8qfmMY8XBAjgR/
	vLoY3W2LX1f302SYSoXgoau8N24obv+9n3smEhPFelpNBDMuVnXIuVCgJgsmlNl2JwIZYeGPJ14
	Opy/gUSEJXxC8lNs1t8GJdpMYBI+n4aiQHRYTQbEAQ5OxoI93zNW+jyYDJFJaCeU04twpU8Fcgp
	5VQh3D9aR5QAF7BBHLvG6MSUDzHZ+fQcHGdGvBnLTE4hK2COdpUbcG4Fh3myBzqgwJa1d5lydB1
	S2UelOqcI/7+UA=
X-Received: by 2002:a05:600c:6305:b0:495:6396:8b67 with SMTP id 5b1f17b1804b1-4997c0d7658mr46390285e9.4.1786533137639;
        Wed, 12 Aug 2026 04:12:17 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5e:1100:7303:647d:7cc4:8552])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997c9417bcsm54830855e9.4.2026.08.12.04.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 04:12:17 -0700 (PDT)
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
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next 3/3] selftests/bpf: Test linux_binprm user memory kfuncs
Date: Wed, 12 Aug 2026 14:11:40 +0300
Message-ID: <20260812111140.7762-4-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812111140.7762-1-tasos.papagiannnis@gmail.com>
References: <20260812111140.7762-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 09216A000A
X-Stat-Signature: fk3dseamyrt4jwrz89izd1dyp1jr5jat
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786533138-591793
X-HE-Meta: U2FsdGVkX1/t6pBoPPDGBUHaBuec6TF/I5mU0zpRjw9JeCTwa1AhoapZRAyNde1N9cgXyuBvaL6t8Yj6svbAJKgP4Ak3KXPDtkF2mgLG1HEOw2tjcc+mkq/cajGGSEcOdEFMAp8diiwLxSl0869yqt1kLfKjLDOUyrsZVX6nNpi93+y2tbwWrD70EIdd7dr52X2vTDvRumiMJS/r8OMLAa9PhxvUb+DWspyXviyuCneUg+R7QIdB2sWbhSm+S6XAFZRT4on0ydfSdSdQZhKvlpxNB0RholT8iD7v/pFBejQdq0tS6eZ4Z7pL9EpdHsbrEWJpX4f4xriCyr9k14i/iBFBwek1xxXeK+6yWnfRBHsEP29nwiqeZWyvwzseZg/aNTqGAsZPXI5FMr+Dizj3ZiI0qySrV8FkuxgCOiN/Jg7goRqvH/jhgZMPg/HYSkdlOW0exHlgKuUTy+GxX7k/b9SJY311m9o9XfL6+HkMxnWeDMl+f6WEY5YQQXDcKJdosD7i/KYhqedw4uZSV3ea8NtvkEirx/SM2JN6SIyegrkGY55/GLJBTh5YIPpZmF9NCP+KUhXz6rltXPT1iQ5ednKBnGX2D+v9QLml0Ph2MoQeUN0Txu3E1MZoZDUnm80bIHLIhKmUTPiKy4S1zuo8ScPWwA2lP6Q0Hdcn2iCsTIi/8sc96ENdGaRQjJgNdl14dqO+aEQwWBqu0p+CKLVheaF9kvNOjlxF6eCDnVdyNtFdrhENmKA/vYS9gaCv7PG7ORr8LSej6N2j8p3Vs9edCHv8C93NdfPcbjJXDh0Sqb8jvZqK3n6Cqa1XDWcKAmWrMz3ep6cAhCcbJGdiluQldm7kVvZurtCcm0yfPEW2AZ4ZQONLdy0KxyMZAkFz78vvxMAum4aGIY0ekGUdqBXDCWmtfkbbc4+Qyn3NbbhYfgBhCZCobPcRUhus4M5Q+9ivpTgvO22z92wlz8bYSwi
 ojKhJ/o+
 oe0OmaMFuqDBgNcKN0GY7lVJhMe4/PVtr34/KgOG3qrKp5Fa5uv1KoLWS4Rw5hHl3S9G6Rjo6WRhoA9JeMKEOTtluI/fX/fvjj+VIeqHh9FMmOttbiWzpjyZeNuiq4ESylfliocFUmoaTK8/p154YFit25PIpiFSI+PJ+w+8nmqA/1yms1qYXZTfiY1C5PyISXjy+xvr3INmKCUZV4/hFE66eZfAG6JKbWScUq0p5CjJ6Gsozkl+kMj+ASOAm6+8bqNPp01iBSSzrFUIPcKPD96qOUj+gsYgj1qaH0m1+7b5YrdOqDcjkRgIqxi9enlPZQSgNNWz0G6p5fGiPUpX68uQVgY/ylCKM5++gv+0xXhYzSu43GvA0UZoEbKp/UE2vOCOruLQTIh7RQxTOf/ZcIDLRdzDavSsYiY8OpcfZwkrdP0INsZZq61WL/u7FDPg505bV6bHb7dXodY+bx/yPj79+Y51ABX5ObBBGm+B3CYgXuf4CpVCQry6H6zQwzJYIQqlRE+x3aiXkFqQPTfjjH18j+B2/Xi4BmEYPdpokgGYTe7AlXyLeN1gBCuUl/WlRb0vpRReMdubYC9Y=
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
contiguous NUL-separated argument data. Then use
bpf_copy_from_user_bprm_str() to read each argument separately,
by advancing the offset based on the returned length.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
---
 .../bpf/prog_tests/copy_from_user_bprm.c      | 52 +++++++++++++
 .../selftests/bpf/progs/copy_from_user_bprm.c | 74 +++++++++++++++++++
 2 files changed, 126 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
 create mode 100644 tools/testing/selftests/bpf/progs/copy_from_user_bprm.c

diff --git a/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c b/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
new file mode 100644
index 000000000000..3d5080a3975e
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
@@ -0,0 +1,52 @@
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
+		char *const argv[] = { "first", "second-argument", NULL };
+
+		skel->bss->monitored_pid = getpid();
+		execv("/bin/true", argv);
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
+	ASSERT_EQ(skel->bss->invalid_flags_ret, -EINVAL, "invalid_flags_ret");
+	ASSERT_EQ(skel->bss->copy_ret, 0, "copy_ret");
+	ASSERT_EQ(skel->bss->str_arg0_ret, 6, "str_arg0_ret");
+	ASSERT_EQ(skel->bss->str_arg1_ret, 16, "str_arg1_ret");
+	ASSERT_EQ(skel->bss->args_match, 1, "args_match");
+	ASSERT_EQ(skel->bss->str_args_match, 1, "str_args_match");
+
+out:
+	copy_from_user_bprm__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c b/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c
new file mode 100644
index 000000000000..679363811edc
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c
@@ -0,0 +1,74 @@
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
+static const char expected_args[] = "first\0second-argument";
+static const char expected_arg0[] = "first";
+static const char expected_arg1[] = "second-argument";
+
+int monitored_pid;
+int bprm_argc;
+int invalid_flags_ret;
+int copy_ret;
+int str_arg0_ret;
+int str_arg1_ret;
+int args_match;
+int str_args_match;
+
+extern int bpf_copy_from_user_bprm(void *dst, u32 dst__sz,
+				   const void *unsafe_ptr__ign,
+					   const struct linux_binprm *bprm,
+					   u64 flags) __ksym;
+
+extern int bpf_copy_from_user_bprm_str(void *dst, u32 dst__sz,
+				       const void *unsafe_ptr__ign,
+					       const struct linux_binprm *bprm,
+					       u64 flags) __ksym;
+
+SEC("lsm.s/bprm_check_security")
+int BPF_PROG(check_exec_args, struct linux_binprm *bprm, int ret)
+{
+	u32 pid = bpf_get_current_pid_tgid() >> 32;
+	char args[sizeof(expected_args)];
+	char arg0[32];
+	char arg1[32];
+
+	if (ret || pid != monitored_pid)
+		return ret;
+
+	bprm_argc = bprm->argc;
+
+	invalid_flags_ret = bpf_copy_from_user_bprm(args, sizeof(args),
+						    (void *)bprm->p, bprm, 1);
+
+	copy_ret = bpf_copy_from_user_bprm(args, sizeof(args),
+					   (void *)bprm->p, bprm, 0);
+	if (copy_ret)
+		return 0;
+
+	args_match = !__builtin_memcmp(args, expected_args, sizeof(expected_args));
+
+	str_arg0_ret = bpf_copy_from_user_bprm_str(arg0, sizeof(arg0),
+						   (void *)bprm->p, bprm,
+						BPF_F_PAD_ZEROS);
+	if (str_arg0_ret != sizeof(expected_arg0))
+		return 0;
+
+	str_arg1_ret = bpf_copy_from_user_bprm_str(arg1, sizeof(arg1),
+						   (void *)(bprm->p + str_arg0_ret),
+						bprm, BPF_F_PAD_ZEROS);
+	if (str_arg1_ret != sizeof(expected_arg1))
+		return 0;
+
+	str_args_match = !__builtin_memcmp(arg0, expected_arg0, sizeof(expected_arg0)) &&
+			!__builtin_memcmp(arg1, expected_arg1, sizeof(expected_arg1));
+
+	return args_match && str_args_match ? -EPERM : 0;
+}
-- 
2.55.0


