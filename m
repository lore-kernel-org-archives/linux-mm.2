Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B741CC55160
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 13:35:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CA816B009F; Thu, 30 Jul 2026 09:35:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97AFC6B00A0; Thu, 30 Jul 2026 09:35:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86AEF6B00A1; Thu, 30 Jul 2026 09:35:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 56E9E6B009F
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:35:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3EDBC0115
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:35:08 +0000 (UTC)
X-FDA: 85045539096.08.0F625E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 28C161C0012
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:35:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L1AZmXth;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785418507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cm7cHKzb/C1JMb8iJOvOWVjBxbTICkabR4Ia0flRQYQ=;
	b=5bxMYzjgh+/Og7tOxv6UgVm5ahp0BdKUoDDFmnHgyhIHCLHUFl6onODzhNqO362IXTmwPS
	RoIqMhPdyN4ttTd7WRaXZgR6k3bZWh7BoF8nwvW2unoqcVXOrhrjvHiAQmxTP0iZyxT8BJ
	ay3jZ9jefwzEsfrvRvZVz6bUF/b1ADo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L1AZmXth;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785418507;
	b=BKzMrYHUoIf1Gzegiw4sBemxJus0buWM9EaHzC93wSf+Qz+VRH1trNSONLqazdI2ldE/0O
	Qkz9jaezimRJoZxQ+4zxtd6A1l41XxSIT+HKsOX62Gp/lqzpW1RCPlFldR7891EubEPSku
	0GCuNTjuC1/BZDbYis3xsKgd5rw3xWE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ADC2060A6C;
	Thu, 30 Jul 2026 13:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55D31F00A3D;
	Thu, 30 Jul 2026 13:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785418506;
	bh=cm7cHKzb/C1JMb8iJOvOWVjBxbTICkabR4Ia0flRQYQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=L1AZmXthLeIrq+GfCJ7XJQIMUcMQEhYR+gRGl+qvFFYRt3Gb1bAykAljsKuUXzdI9
	 MY5R+JP50DdcvfYCJCrv+jmoNBGtpqCJQDHQghSnvCoeZJqzCCt8hwZ4tksfrq0eZj
	 7s4DraWxB0atiiJ3GPawtzmW/wc/bvFztnR5HUIOO48GvJLOPNOGh7I/kEx9Z3ND5J
	 f4y5hcAvK/I5N5yFHPyYUzb/SXsBNJ3dLQvSdRKDHzfLx9MXtOnWMWC2cTfLt5GL06
	 HK79AkPZRn3OInEC/CyChy/59I7BYntZ2ZwWU/hUlMiPZQnOUrGDcY9+pIUipShoSk
	 r3oB+sq+RmpAA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 30 Jul 2026 15:34:10 +0200
Subject: [PATCH 8/9] selftests/exec: test interpreters bound to a 'B' entry
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-work-binfmt_misc-preopen-v1-8-4a0b0da71f16@kernel.org>
References: <20260730-work-binfmt_misc-preopen-v1-0-4a0b0da71f16@kernel.org>
In-Reply-To: <20260730-work-binfmt_misc-preopen-v1-0-4a0b0da71f16@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 Jonathan Corbet <corbet@lwn.net>, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-3e0c3
X-Developer-Signature: v=1; a=openpgp-sha256; l=17302; i=brauner@kernel.org;
 h=from:subject:message-id; bh=fTXXuoo+b47PgrpKApY7cUX4eYsSgQTcjP9UfX8blKw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRlB737axXz+uTzfE4D/det6mvvGFbeKr3olMBvfm5Om
 bGTvcLKjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIk8WsjIcLda4/jDPN23ZzU/
 rVmjtaIuIO7ATMb7QS95i2s/NtZMWcHwzzLhm36g8+OwpKWJLB38micVO5aV3nBRPT4nZurNV8K
 i7AA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 28C161C0012
X-Rspam-User: 
X-Stat-Signature: 8r9cr1bjsspcxec3k1ybs1c73dj3wmss
X-HE-Tag: 1785418507-745823
X-HE-Meta: U2FsdGVkX1/VjKpZTzm2K4sX5gT+jDb6CBU9wgjfDoXOHcE+GIP+34/b4mXoad49pMZvYGNpEfwyuxrKV6KYIfsyOOxgchyPdPEAzxwXhgdPh6EVBjLZhKVYdgOKG3RTIt+8/4s/dhAKLXPSJUR+/0jeXjNntyyPHBtPQUuVQHwS3+YSbmYfITWv56PLuFY2L2B/IiL3zBMhMZ9BahtbixWgsMTWJOlaMy2QhfKK7W7TrFJ1oM1aQ0w22aBl6aYRmYrMXvXbLG7SXAv2+iV8JVnTjRyBaiGSNrTBhMZaQv/XEhjhgEY2zhphuWNApAP6baBdo2USigz0/bfGC0sZaLBTMr89tyjmZe+x+mukGGCvOraQ0u4Yyd2LsCkz0Uph9Zs3aU9iiFjpmsAyJU/syJUkcjEWadnmgdxMGYj5LGLe9cjlBb5xAMfznuJDZr4IULM32TOskV5DVF6z8hoeNuw0m4Pk9S0NtHHDmj1r+ek3Rfj8la8MPAn0tCPy3mqWXZapTOg8IhqJJIhpMvN495f1UN5VCrGzgJS2Ds1rxWg2ogkw3ZK4XYe//6DzZOjsQQS4zzuKPPW5xfXNv6CRbWN92WMM1kCOpwKTj4hQQopy41Rt3yK69AypvzYnfW/jeP6EWV6PH98ruVNwnnNW+vI+tFNzWGLfrBXLGmA9/gVXFPZfkWIs7ymCh/wxv/86mmiLBHleL55q+HJmH4W2V2yZli87fzFycMvT7B7BBdwkMvup5B+B+SFVk0O97xGWY9+Y/uPnlSMKAE+2kE0xsBG8ND01nRKQbYC8EINa3gaMiYcwy+LRpRAG0LBck5Sg+b4qw03i1o/oe5wAma25ZzioVcwGSeMdwwIeqKSqXWYVIJ3/DuHAzI5nQLuxF/MoMVtyA9ms0D9ZjXLvFV0u1OfHRg1a+d1lfEQs+w4189MvDem5NHbdosQR1CXf9Sq/2obeeFGMgZMofCACR3D
 LtmKCQjr
 pm9gek1WYB2PYm8AhEwEJrWnDJU/IQOJ2FkYnUukvczYaVdX5XhtApTPHp2AghIlVcTfQg/LLFTqNAe+W2yxzDP1bZ7cWpG6mayAVgot4axIiXjC74ckdKOjQK2YHMCX/EtQraDZkf5q06VOkUzr3lVd1Jg0HPQn7mgh47sxmOsmmR9LU1BVBzF1qgMx6jbcgZ9zMNpQHiL8Xjt3qiTMKUJ9YEQJ0Uq27QmiICNvBRWGiI3qTZM4OSxaS2cP1/cDZssGZKVpRbpFOuxSh5D8PoyxLXhz/iRo1TJD5mFj6Fz4JquasOMjqjW4oZZ210WsXOGz7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

One handler, one entry registered disabled, an interpreter per guest
architecture bound to a file one write at a time. The load program picks
one by name per exec:

- an aarch64 binary runs the interpreter bound as "first" and a riscv one
  the interpreter bound as "second", from a single entry and a single
  handler

- unlinking a bound interpreter and putting a different binary in its
  place changes nothing, which is what the binding exists for

- the entry reports what it bound, under the names it bound them as

- a name the entry did not bind fails the exec with -ENOENT rather than
  falling back to anything

- activating the entry refuses further binding with -EBUSY, a later
  disable does not undo that, and an entry registered without 'D' never
  accepted a '+' write to begin with

- a name binds one interpreter, and control characters are refused

- the command has to end at the write, bytes past an embedded nul are
  refused

- an entry binds at most 100 interpreters, the next one is refused with
  -ENOSPC

The test interpreter prints its argv[0], which is the path the kernel ran
that copy under, so one binary installed at two paths tells the harness
which of them the program picked.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/exec/Makefile             |   7 +-
 tools/testing/selftests/exec/binfmt_bind_interp.c |  14 ++
 tools/testing/selftests/exec/binfmt_misc_bpf.c    | 261 +++++++++++++++++++++-
 tools/testing/selftests/exec/interp_bind.bpf.c    |  76 +++++++
 4 files changed, 349 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index ec7894a802e0..410c93606a0c 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -56,8 +56,8 @@ HAVE_BPF_TOOLCHAIN ?= $(shell command -v $(CLANG) >/dev/null 2>&1 && \
 ifeq ($(HAVE_BPF_TOOLCHAIN),y)
 TEST_GEN_PROGS += binfmt_misc_bpf
 TEST_GEN_FILES += bpf_interp.bpf.o nix_origin.bpf.o transparent.bpf.o
-TEST_GEN_FILES += loader.bpf.o
-TEST_GEN_FILES += binfmt_bpf_interp binfmt_bpf_app
+TEST_GEN_FILES += loader.bpf.o interp_bind.bpf.o
+TEST_GEN_FILES += binfmt_bpf_interp binfmt_bpf_app binfmt_bind_interp
 else
 $(info exec selftests: skipping binfmt_misc_bpf, needs clang, bpftool, vmlinux BTF and libbpf)
 endif
@@ -127,6 +127,9 @@ $(OUTPUT)/binfmt_misc_bpf: binfmt_misc_bpf.c binfmt_misc_common.h
 $(OUTPUT)/binfmt_bpf_interp: binfmt_bpf_interp.c
 	$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@
 
+$(OUTPUT)/binfmt_bind_interp: binfmt_bind_interp.c
+	$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@
+
 $(OUTPUT)/binfmt_loader_payload: binfmt_loader_payload.c binfmt_misc_common.h
 	$(CC) $(CFLAGS) $(LDFLAGS) -fPIE -pie $< -o $@
 
diff --git a/tools/testing/selftests/exec/binfmt_bind_interp.c b/tools/testing/selftests/exec/binfmt_bind_interp.c
new file mode 100644
index 000000000000..06d65062856b
--- /dev/null
+++ b/tools/testing/selftests/exec/binfmt_bind_interp.c
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test interpreter for the bound-interpreter case of the binfmt_misc_bpf
+ * selftest. Two copies are installed at different paths and bound to one
+ * entry under different names; printing argv[0] - the path the kernel ran
+ * this copy under - tells the harness which of them the load program picked.
+ */
+#include <stdio.h>
+
+int main(int argc, char **argv)
+{
+	printf("BIND_RAN %s\n", argc > 0 ? argv[0] : "");
+	return 0;
+}
diff --git a/tools/testing/selftests/exec/binfmt_misc_bpf.c b/tools/testing/selftests/exec/binfmt_misc_bpf.c
index 71bb6d8b4517..2c7b63075f1d 100644
--- a/tools/testing/selftests/exec/binfmt_misc_bpf.c
+++ b/tools/testing/selftests/exec/binfmt_misc_bpf.c
@@ -9,7 +9,7 @@
  *
  *     echo ':name:B::::<handler>:' > /proc/sys/fs/binfmt_misc/register
  *
- * Three self-contained cases are exercised:
+ * Five self-contained cases are exercised:
  *
  *   1. bpf_interp: the match program matches a synthetic aarch64 ELF header
  *      from the prefetched bprm->buf and the load program routes it to a
@@ -26,6 +26,11 @@
  *      (binfmt_loader_payload) runs as the main image with the selected
  *      interpreter substituted for its PT_INTERP and asserts the native
  *      identity from inside.
+ *   5. interp_bind: an entry registered disabled with 'D' is given its
+ *      interpreters one write at a time, and the load program picks one by
+ *      name per exec. Replacing what the path holds afterwards changes
+ *      nothing, which is the point of binding a file rather than resolving
+ *      a name at exec time. Enabling the entry seals it.
  *
  * The first two route to a test interpreter that prints BPF_INTERP_RAN,
  * proving the program's chosen interpreter actually ran.
@@ -54,6 +59,12 @@
 #define TRANS_EXPECT	"TRANSPARENT_OK"
 #define LOADER_INTERP	"/tmp/binfmt_loader_interp"
 #define LOADER_PATH	"/tmp/binfmt_bpf_loader.ldrtest"
+#define BIND_FIRST	"/tmp/binfmt_bind_first"
+#define BIND_SECOND	"/tmp/binfmt_bind_second"
+#define BIND_ARM_PATH	"/tmp/binfmt_bind_arm"
+#define BIND_RISCV_PATH	"/tmp/binfmt_bind_riscv"
+#define BIND_EXPECT	"BIND_RAN "
+#define BIND_MAX	100
 
 /* A minimal 64-bit little-endian ELF header, padded to the read size. */
 static int create_fake_elf(const char *path, unsigned short machine)
@@ -82,11 +93,17 @@ static int create_fake_elf(const char *path, unsigned short machine)
 	return 0;
 }
 
-static int register_entry(const char *name, const char *handler)
+/*
+ * Register a 'B' entry for @handler. With @flags "D" the entry is created
+ * disabled, which is what leaves it open to being given interpreters.
+ */
+static int register_entry(const char *name, const char *handler,
+			  const char *flags)
 {
 	char rule[PATH_MAX];
 
-	snprintf(rule, sizeof(rule), ":%s:B::::%s:", name, handler);
+	snprintf(rule, sizeof(rule), ":%s:B::::%s:%s", name, handler,
+		 flags ? flags : "");
 	return write_reg(rule);
 }
 
@@ -139,10 +156,12 @@ struct bpf_case {
 
 /*
  * Load @objfile, attach its struct_ops map @handler (which publishes the
- * handler) and activate a 'B' entry named @entry that references it.
+ * handler) and register a 'B' entry named @entry that references it, with
+ * @flags as the entry's register-string flags.
  */
-static int bpf_case_start(struct bpf_case *c, const char *objfile,
-			  const char *handler, const char *entry)
+static int bpf_case_start_flags(struct bpf_case *c, const char *objfile,
+				const char *handler, const char *entry,
+				const char *flags)
 {
 	struct bpf_map *map;
 
@@ -172,7 +191,7 @@ static int bpf_case_start(struct bpf_case *c, const char *objfile,
 		c->link = NULL;
 		goto fail;
 	}
-	if (register_entry(entry, handler)) {
+	if (register_entry(entry, handler, flags)) {
 		fprintf(stderr, "register 'B' entry '%s' failed\n", entry);
 		goto fail;
 	}
@@ -186,6 +205,12 @@ static int bpf_case_start(struct bpf_case *c, const char *objfile,
 	return -1;
 }
 
+static int bpf_case_start(struct bpf_case *c, const char *objfile,
+			  const char *handler, const char *entry)
+{
+	return bpf_case_start_flags(c, objfile, handler, entry, NULL);
+}
+
 static void bpf_case_stop(struct bpf_case *c)
 {
 	unregister(c->entry);
@@ -318,4 +343,226 @@ TEST_F(bpf_handler, loader_substitution)
 	unlink(LOADER_INTERP);
 }
 
+/* The errno an exec of @path fails with, 0 if it succeeded. */
+static int exec_errno(const char *path)
+{
+	int status;
+	pid_t pid;
+
+	pid = fork();
+	if (pid == 0) {
+		execl(path, path, (char *)NULL);
+		_exit(errno);
+	}
+	if (pid < 0 || waitpid(pid, &status, 0) != pid || !WIFEXITED(status))
+		return -1;
+	return WEXITSTATUS(status);
+}
+
+/* Install a copy of the bound-interpreter test binary at @path. */
+static int install_interp(const char *path)
+{
+	char src[PATH_MAX];
+
+	if (artifact_path(src, sizeof(src), "binfmt_bind_interp"))
+		return -1;
+	return copy_file(src, path);
+}
+
+/* Bind @path to @entry under @name, the '+' command of a disabled entry. */
+static int entry_bind(const char *entry, const char *name, const char *path)
+{
+	char cmd[PATH_MAX];
+
+	snprintf(cmd, sizeof(cmd), "+%s %s\n", name, path);
+	return entry_command(entry, cmd);
+}
+
+FIXTURE(bound_interp) {
+	char obj[PATH_MAX];
+	struct bpf_case c;
+	bool started;
+};
+
+FIXTURE_SETUP(bound_interp)
+{
+	const char *why = bpf_handler_unsupported();
+
+	if (why)
+		SKIP(return, "%s", why);
+	if (!binfmt_flag_supported('D')) {
+		ASSERT_EQ(errno, EINVAL);
+		SKIP(return, "kernel without the 'D' flag");
+	}
+
+	ASSERT_EQ(install_interp(BIND_FIRST), 0);
+	ASSERT_EQ(install_interp(BIND_SECOND), 0);
+
+	ASSERT_EQ(artifact_path(self->obj, sizeof(self->obj),
+				"interp_bind.bpf.o"), 0);
+
+	/*
+	 * Registered disabled, so it cannot be matched yet and can still be
+	 * given interpreters. Each path is resolved once, by its write(2);
+	 * from here on the entry holds the files themselves.
+	 */
+	ASSERT_EQ(bpf_case_start_flags(&self->c, self->obj, "interp_bind",
+				       "test_interp_bind", "D"), 0);
+	self->started = true;
+
+	ASSERT_EQ(entry_bind("test_interp_bind", "first", BIND_FIRST), 0);
+	ASSERT_EQ(entry_bind("test_interp_bind", "second", BIND_SECOND), 0);
+}
+
+FIXTURE_TEARDOWN(bound_interp)
+{
+	if (self->started)
+		bpf_case_stop(&self->c);
+	unlink(BIND_FIRST);
+	unlink(BIND_SECOND);
+	unlink(AARCH64_PATH);
+	unlink(BIND_RISCV_PATH);
+	unlink(BIND_ARM_PATH);
+}
+
+/* Enabling is what makes the configured entry matchable. */
+static int activate(const char *entry)
+{
+	return entry_command(entry, "1\n");
+}
+
+/* One entry, one interpreter per guest architecture, picked per exec. */
+TEST_F(bound_interp, selects_by_name)
+{
+	ASSERT_EQ(create_fake_elf(AARCH64_PATH, EM_AARCH64), 0);
+	ASSERT_EQ(create_fake_elf(BIND_RISCV_PATH, EM_RISCV), 0);
+
+	/* Disabled, so it does not match and no format claims the binary. */
+	EXPECT_EQ(exec_errno(AARCH64_PATH), ENOEXEC);
+
+	ASSERT_EQ(activate("test_interp_bind"), 0);
+	EXPECT_EQ(check_output(AARCH64_PATH, BIND_EXPECT BIND_FIRST), 0);
+	EXPECT_EQ(check_output(BIND_RISCV_PATH, BIND_EXPECT BIND_SECOND), 0);
+}
+
+/* What was bound is what runs, whatever the path holds afterwards. */
+TEST_F(bound_interp, path_no_longer_decides)
+{
+	char other[PATH_MAX];
+
+	ASSERT_EQ(create_fake_elf(AARCH64_PATH, EM_AARCH64), 0);
+	ASSERT_EQ(activate("test_interp_bind"), 0);
+
+	/* Bound interpreters are pinned against writes, exactly like 'F'. */
+	EXPECT_TRUE(write_denied(BIND_FIRST));
+
+	/* Replace the path with a different binary: a new file, new inode. */
+	ASSERT_EQ(artifact_path(other, sizeof(other), "binfmt_bpf_interp"), 0);
+	ASSERT_EQ(unlink(BIND_FIRST), 0);
+	ASSERT_EQ(copy_file(other, BIND_FIRST), 0);
+
+	EXPECT_EQ(check_output(AARCH64_PATH, BIND_EXPECT BIND_FIRST), 0);
+}
+
+/* The entry reports what it bound, under the names it bound them as. */
+TEST_F(bound_interp, entry_reports_bindings)
+{
+	EXPECT_TRUE(entry_shows("test_interp_bind",
+				"bpf-interpreter first " BIND_FIRST));
+	EXPECT_TRUE(entry_shows("test_interp_bind",
+				"bpf-interpreter second " BIND_SECOND));
+}
+
+/* Selecting a name the entry did not bind fails the exec. */
+TEST_F(bound_interp, unbound_name_fails)
+{
+	ASSERT_EQ(create_fake_elf(BIND_ARM_PATH, EM_ARM), 0);
+	ASSERT_EQ(activate("test_interp_bind"), 0);
+
+	EXPECT_EQ(exec_errno(BIND_ARM_PATH), ENOENT);
+}
+
+/* Activating seals it: what can be matched cannot be changed. */
+TEST_F(bound_interp, sealed_once_active)
+{
+	ASSERT_EQ(activate("test_interp_bind"), 0);
+
+	EXPECT_EQ(entry_bind("test_interp_bind", "third", BIND_SECOND), -EBUSY);
+	EXPECT_FALSE(entry_shows("test_interp_bind",
+				 "bpf-interpreter third " BIND_SECOND));
+}
+
+/* The seal is for good: disabling the entry again reopens nothing. */
+TEST_F(bound_interp, disable_does_not_unseal)
+{
+	ASSERT_EQ(activate("test_interp_bind"), 0);
+	ASSERT_EQ(entry_command("test_interp_bind", "0\n"), 0);
+
+	EXPECT_EQ(entry_bind("test_interp_bind", "third", BIND_SECOND), -EBUSY);
+}
+
+/* An entry registered without 'D' is sealed from the start. */
+TEST_F(bound_interp, born_sealed)
+{
+	/* A second entry for the handler the fixture already published. */
+	ASSERT_EQ(register_entry("test_born_sealed", "interp_bind", NULL), 0);
+
+	EXPECT_EQ(entry_bind("test_born_sealed", "first", BIND_FIRST), -EBUSY);
+	unregister("test_born_sealed");
+}
+
+/* A name is bound once; a second use of it is refused. */
+TEST_F(bound_interp, duplicate_name_refused)
+{
+	EXPECT_EQ(entry_bind("test_interp_bind", "first", BIND_SECOND), -EEXIST);
+}
+
+/* A name is a printable word: the entry file reports 'name path' lines. */
+TEST_F(bound_interp, name_must_be_printable)
+{
+	/* A control character would forge a line into the entry file. */
+	EXPECT_EQ(entry_bind("test_interp_bind", "a\tb", BIND_FIRST), -EINVAL);
+	EXPECT_EQ(entry_bind("test_interp_bind", "a\nb", BIND_FIRST), -EINVAL);
+
+	/* A space cannot even be spelled: the path starts after the first one. */
+	EXPECT_EQ(entry_bind("test_interp_bind", "a b", BIND_FIRST), -EINVAL);
+}
+
+/* The command ends at the write: bytes past an embedded nul are refused. */
+TEST_F(bound_interp, trailing_bytes_refused)
+{
+	char cmd[PATH_MAX];
+	size_t len;
+	int fd;
+
+	/* entry_command() cannot spell a nul, so write the buffer raw. */
+	snprintf(cmd, sizeof(cmd), "+nul %s", BIND_FIRST);
+	len = strlen(cmd) + 1;
+	memcpy(cmd + len, "junk", sizeof("junk"));
+	len += sizeof("junk");
+
+	fd = open(BINFMT_DIR "/test_interp_bind", O_WRONLY | O_CLOEXEC);
+	ASSERT_GE(fd, 0);
+	EXPECT_EQ(write(fd, cmd, len), -1);
+	EXPECT_EQ(errno, EINVAL);
+	close(fd);
+
+	EXPECT_FALSE(entry_shows("test_interp_bind",
+				 "bpf-interpreter nul " BIND_FIRST));
+}
+
+/* An entry binds at most BIND_MAX interpreters. */
+TEST_F(bound_interp, capped_bindings)
+{
+	char name[16];
+	int i;
+
+	/* The fixture bound "first" and "second" already. */
+	for (i = 2; i < BIND_MAX; i++) {
+		snprintf(name, sizeof(name), "n%d", i);
+		ASSERT_EQ(entry_bind("test_interp_bind", name, BIND_FIRST), 0);
+	}
+	EXPECT_EQ(entry_bind("test_interp_bind", "over", BIND_FIRST), -ENOSPC);
+}
+
 TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/exec/interp_bind.bpf.c b/tools/testing/selftests/exec/interp_bind.bpf.c
new file mode 100644
index 000000000000..1ce45cca215f
--- /dev/null
+++ b/tools/testing/selftests/exec/interp_bind.bpf.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * binfmt_misc_ops handler for the selftest's bound-interpreter case: one
+ * handler, one entry, an interpreter per guest architecture - each bound to
+ * a file when the entry was registered rather than to a path resolved at
+ * exec time. The load program names the one it wants; a name the entry did
+ * not bind fails the exec, which the harness checks too.
+ */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+#define EI_CLASS	4
+#define ELFCLASS64	2
+#define E_MACHINE_OFF	18
+#define EM_ARM		40
+#define EM_AARCH64	183
+#define EM_RISCV	243
+
+extern int bpf_binprm_select_interp(struct linux_binprm *bprm,
+				    const char *name, size_t name__sz) __ksym;
+
+/* The guest architecture of a 64-bit ELF, or zero if it is not one. */
+static __u16 elf_machine(struct linux_binprm *bprm)
+{
+	if (bprm->buf[0] != 0x7f || bprm->buf[1] != 'E' ||
+	    bprm->buf[2] != 'L' || bprm->buf[3] != 'F' ||
+	    bprm->buf[EI_CLASS] != ELFCLASS64)
+		return 0;
+
+	/* Little-endian 16-bit field, read byte-wise for the verifier. */
+	return (__u8)bprm->buf[E_MACHINE_OFF] |
+	       ((__u16)(__u8)bprm->buf[E_MACHINE_OFF + 1] << 8);
+}
+
+SEC("struct_ops.s/match")
+bool BPF_PROG(interp_bind_match, struct linux_binprm *bprm)
+{
+	__u16 machine = elf_machine(bprm);
+
+	return machine == EM_AARCH64 || machine == EM_RISCV ||
+	       machine == EM_ARM;
+}
+
+SEC("struct_ops.s/load")
+int BPF_PROG(interp_bind_load, struct linux_binprm *bprm)
+{
+	/*
+	 * Names, not paths: each one selects a file the entry pre-opened, so
+	 * nothing is resolved here or later, in any namespace. The buffers
+	 * are on the stack because the verifier rejects .rodata for a sized
+	 * memory argument.
+	 */
+	char first[] = "first";
+	char second[] = "second";
+	char unbound[] = "unbound";
+
+	switch (elf_machine(bprm)) {
+	case EM_AARCH64:
+		return bpf_binprm_select_interp(bprm, first, sizeof(first));
+	case EM_RISCV:
+		return bpf_binprm_select_interp(bprm, second, sizeof(second));
+	}
+
+	/* The entry bound nothing under this name: -ENOENT fails the exec. */
+	return bpf_binprm_select_interp(bprm, unbound, sizeof(unbound));
+}
+
+SEC(".struct_ops.link")
+struct binfmt_misc_ops interp_bind = {
+	.match	= (void *)interp_bind_match,
+	.load	= (void *)interp_bind_load,
+	.name	= "interp_bind",
+};

-- 
2.53.0


