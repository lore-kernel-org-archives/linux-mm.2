Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37088C44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:15:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E351F6B00B1; Tue, 21 Jul 2026 10:15:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0D516B00B2; Tue, 21 Jul 2026 10:15:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAE2D6B00B3; Tue, 21 Jul 2026 10:15:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 999886B00B1
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:15:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8360F8016A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:15:10 +0000 (UTC)
X-FDA: 85012980780.19.77C4063
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 92C55140008
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:15:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WAHERU4s;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784643308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+OszQ206KVceWXoQ2WsWAjshHbg+TyWnqZYmSRC2CMs=;
	b=mFl6FzPxPPKJ2x6RHI7vsyrY0JgazRcMDVbYJ3cqj7MpYvTGbPeWeug5JrrVB8E+Jos/5S
	Snds0OCiVTyrK74GrrrRqeHH5f9CG6+PnLAuwUsH+o/Yc02SSPwHnmZRToq1dWmkL1RWkp
	h+lCS+9wgsBajwljR4cfVDUZxh36QOU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784643308;
	b=EDzjdMB3vEp53ot0Pj0+i6hnVFFPApsrAer2MdibdPTmxBpr1EiKNTpo5LTfmABLOUQaFi
	eEQLqGz8k5kVBYo5sHF+UxYtevONhPs2kh7gD3R0DLZuwnJ3YGiNcW9EzKP/s/QrvoDE11
	dywhphKANlL1QHf4UfC4EwkQUoCi6i8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WAHERU4s;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D821B4349A;
	Tue, 21 Jul 2026 14:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229611F00A3A;
	Tue, 21 Jul 2026 14:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784643307;
	bh=+OszQ206KVceWXoQ2WsWAjshHbg+TyWnqZYmSRC2CMs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WAHERU4s5WaOzYcyFJuTYGBUxTeejI1QUHyavBUgNbEeg1yCLez9RSXN+a/GcoAjk
	 8jMjwoJv/hVpfwsmD4tezMw6NFbnrR0u4m8dmPglRzMD0YjZlNYeHuYVsDMJiH+2Xt
	 670/CxWGGZ9sk2swvFA0yHX2cWXELLt40qOCd70cq6cHyK0pBteoOG5dQls46ufQsL
	 +JHd64Y3jBFAJN3Hi049Q8sUoBIbEh4hKcYreNK/ylgjoxbR9UGc9zQG8bLjZdBzE9
	 26IptFSgq3qbnq3t9WgB9iQeji4jGvvqB7nBNFaLGy5cKVSHpArzITRNCWUwxcGbfk
	 nkJT9fWZ4WzLg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 21 Jul 2026 16:13:55 +0200
Subject: [PATCH v2 13/21] selftests/exec: test the transparent binfmt_misc
 mode
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-work-bpf-binfmt_misc-ptinterp-v2-13-e57866e4ae0f@kernel.org>
References: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
In-Reply-To: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=16336; i=brauner@kernel.org;
 h=from:subject:message-id; bh=EP4EYEHqSJ073kq4i5JfQodUt7/97GxYpCBw06U1Ya4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTF1x1wzVYKuRAi909HXr6sW15E/PMJprubV76blCkUq
 iN18vW7jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgImc2MDwTyu2cEv6lzUdS6xc
 dzS4KsooHi3zyVsW/j3Y9r1risdkUYb/Lj6Bkw7s71Y4cXdr0O1V7z96Pz708qfd+5CiE+VuR1J
 SuQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 92C55140008
X-Stat-Signature: w563ex8gbhbztjmoxywxsrnr3m8ry6k7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784643308-803378
X-HE-Meta: U2FsdGVkX1+5wCcOjHb8bR4UtyEVXV9LNINK4IA6aUEElqq8OhEU+kB/15+RBE5UZGoH/9XbBOz6vnzQhjiNVNOpp5yT0HjLYM0uL89w4oyFS7TCiDYZr7IhnY5wU9WrLvQyXpI/j4SAertXZ+Md9XQ1k9nK8BTGLoN0uChhAv9CXSaOAb/7Osueu1YGN/y08xbr43NSgRDPfMUAwJmW3716rUqHWZ1ezU3orUuUW/hrPfMhtnRr9YZV0/9xbbhouck5XyV7y7DGCFgneuqRaExHpvrjpdZR4zDgIaghDyQ2P5Lxbi6ZULOx7/BkdPYxML8VQbeakmfUnTZ/4xCpru+gE0Iadm2vRPCI4IdHDo7Mj7j9ROaGRdWez5cSuXk3A6N+ZVk16omEcri8mZnk59Js47yV3y2uTNgMVd5FixgGu5P2z1TczsgIt0zr0BdAnm52TJqW3GXUqAkj6zEDnWgSbMy+sAL5YUoe9HMpi8Qp7sbft9sZyYGGdkVpl22lqrue6e0zzvplNASbqnbxA350rgKgJjQirgVkdSLZwb4rImGORG0jcZrDkyb6z7liOLYxoJddyP1hMtYOR9mSlZ8mz+3TGj5LfMIQb2bD16TJGPdfYVDPZ9hk0l+dS6jqLWorCFdumz3ZHSx4aVs9TwvL/zj8bivGqLgAoz1BPFyOqe4/896ryHnQuqjmXD12o4T+S7Vq/K4tJDYykII01Q0Zzq8FY6Al7aMIFW4r9FjKIYwDzf6od5uXQ6zlRiu7JRNg1SZ3DgL5UMV4SlsgYz47htsXsXe0qIPCh/m47JCnVuQ4R32/0uODBC69hJIsYnspFtqYKk6RY6FhlwRNElrx+WLAGZ6Enbyn/55b//1KdPc4mn2FOOG5gXQJtbF5qEqtST455rKLaG/gqufphBXIGMZ7eM3ALhn3R6/jDU/VJvKDKueZ6cEwqJbqnIL9zfd8ob0EBzBEsvk5Mlp
 EU2b2FNQ
 jIGxbxnaj9UNAmo4stJaPviBAmOe4EvmfO+LPuNi/qa5GsLhYvSHXhTWOdFkEUtICVruQFkj/1v2dYGhv9jSoLrZHMpX/DZfdc1RyiNw1d+yaHu2r3gaUYEnvSdSBXFE9ArGg2s15sqY5R5p0zpAx/ejsK/a5zS6gKDtkMOT6SVFWsnNwJe8PkZNxOKnsM0hONepkIBhWE5SrMBgKOAPGn02n5QMb60P0Hg8o34nRHBTsmCxEBGxTsC0pusVGHOpM8HADVz+jOYjLTN7CNQe6bCRI8pwNtOaQ0Ia549Nit0fUPOgwVS116IH88IFVcOsIBuG8FmTlpb6bsM8VAlszB+QfnearX4Xyi9No4bCuhxA+5xRy+JZTy2Qt1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Verify the identity a transparent dispatch constructs, from both
activation paths.

- binfmt_misc_transparent: registers a magic entry with the static 'T'
  flag and execs a matched binary with arguments.

- binfmt_misc_bpf: a handler whose load program sets
  BPF_BINPRM_TRANSPARENT.

Both dispatch to a shared asserting interpreter that runs in place of
the binary and checks the contract from the inside:

- AT_FLAGS carries AT_FLAGS_TRANSPARENT_INTERP
- AT_EXECFD refers to the very inode of the binary
- /proc/self/exe resolves to the binary
- argv and /proc/self/cmdline are exactly what the caller passed with
  nothing spliced in
- comm is the binary's basename
- the binary is write-denied while it runs

The static test also validates the registration. 'T' combined with 'P'
must be rejected. A kernel that does not know 'T' turns the test into a
skip. The asserting interpreter and the static test build without the
bpf toolchain so the core transparent semantics stay covered on systems
where the bpf cases are skipped.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/exec/.gitignore            |   2 +
 tools/testing/selftests/exec/Makefile              |   7 +-
 tools/testing/selftests/exec/binfmt_misc_bpf.c     |  45 ++++++-
 .../selftests/exec/binfmt_misc_transparent.c       | 108 +++++++++++++++++
 .../selftests/exec/binfmt_transparent_interp.c     | 130 +++++++++++++++++++++
 tools/testing/selftests/exec/transparent.bpf.c     |  57 +++++++++
 6 files changed, 345 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/exec/.gitignore b/tools/testing/selftests/exec/.gitignore
index 8b93b405c424..94b9ab4eb46c 100644
--- a/tools/testing/selftests/exec/.gitignore
+++ b/tools/testing/selftests/exec/.gitignore
@@ -22,5 +22,7 @@ S_I*.test
 binfmt_misc_bpf
 binfmt_bpf_interp
 binfmt_bpf_app
+binfmt_misc_transparent
+binfmt_transparent_interp
 *.bpf.o
 vmlinux.h
diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index fb5ca59af51d..b316ff46d03c 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -21,6 +21,11 @@ TEST_GEN_PROGS += recursion-depth
 TEST_GEN_PROGS += null-argv
 TEST_GEN_PROGS += check-exec
 
+# Static ('T' flag) transparent binfmt_misc test; the asserting interpreter
+# is shared with the bpf harness's transparent case. No bpf toolchain needed.
+TEST_GEN_PROGS += binfmt_misc_transparent
+TEST_GEN_FILES += binfmt_transparent_interp
+
 # binfmt_misc bpf-backed ('B') handler test: a libbpf harness plus its
 # struct_ops objects and the test interpreter/app it routes between. Only
 # built when clang, bpftool, the vmlinux BTF and libbpf are all present
@@ -35,7 +40,7 @@ HAVE_BPF_TOOLCHAIN ?= $(shell command -v $(CLANG) >/dev/null 2>&1 && \
 			pkg-config --exists libbpf 2>/dev/null && echo y)
 ifeq ($(HAVE_BPF_TOOLCHAIN),y)
 TEST_GEN_PROGS += binfmt_misc_bpf
-TEST_GEN_FILES += bpf_interp.bpf.o nix_origin.bpf.o
+TEST_GEN_FILES += bpf_interp.bpf.o nix_origin.bpf.o transparent.bpf.o
 TEST_GEN_FILES += binfmt_bpf_interp binfmt_bpf_app
 else
 $(info exec selftests: skipping binfmt_misc_bpf, needs clang, bpftool, vmlinux BTF and libbpf)
diff --git a/tools/testing/selftests/exec/binfmt_misc_bpf.c b/tools/testing/selftests/exec/binfmt_misc_bpf.c
index dd541c0a464d..483c46e13410 100644
--- a/tools/testing/selftests/exec/binfmt_misc_bpf.c
+++ b/tools/testing/selftests/exec/binfmt_misc_bpf.c
@@ -9,7 +9,7 @@
  *
  *     echo ':name:B::::<handler>:' > /proc/sys/fs/binfmt_misc/register
  *
- * Two self-contained cases are exercised:
+ * Three self-contained cases are exercised:
  *
  *   1. bpf_interp: the match program matches a synthetic aarch64 ELF header
  *      from the prefetched bprm->buf and the load program routes it to a
@@ -18,9 +18,13 @@
  *      commit only to a "$ORIGIN/..."-relative PT_INTERP and the load program
  *      resolves it to an interpreter co-located with the binary (the
  *      relocatable-loader case the kernel ELF loader cannot express).
+ *   3. transparent: the load program sets BPF_BINPRM_TRANSPARENT; the
+ *      asserting interpreter (binfmt_transparent_interp) verifies the
+ *      identity the kernel constructed (exe link, argv, cmdline, comm,
+ *      AT_EXECFD, write denial) from inside the process.
  *
- * Both route to a test interpreter that prints BPF_INTERP_RAN, proving the
- * program's chosen interpreter actually ran.
+ * The first two route to a test interpreter that prints BPF_INTERP_RAN,
+ * proving the program's chosen interpreter actually ran.
  */
 #define _GNU_SOURCE
 #include <elf.h>
@@ -41,7 +45,10 @@
 #define INTERP_PATH	"/tmp/binfmt_bpf_interp"
 #define AARCH64_PATH	"/tmp/binfmt_bpf_aarch64"
 #define RELOC_DIR	"/tmp/binfmt_reloc"
+#define TRANS_INTERP	"/tmp/binfmt_transparent_interp"
+#define TRANS_PATH	"/tmp/binfmt_bpf_riscv"
 #define EXPECT		"BPF_INTERP_RAN"
+#define TRANS_EXPECT	"TRANSPARENT_OK"
 
 /* A minimal 64-bit little-endian ELF header, padded to the read size. */
 static int create_fake_elf(const char *path, unsigned short machine)
@@ -77,6 +84,15 @@ static int register_entry(const char *name, const char *handler)
 	return write_reg(rule);
 }
 
+/* Probe for transparent-mode support via its static counterpart. */
+static bool have_transparent(void)
+{
+	if (write_reg(":test_t_probe:E::bmtprobe::/bin/true:T"))
+		return false;
+	unregister("test_t_probe");
+	return true;
+}
+
 static int check_output(const char *cmd, const char *expected)
 {
 	char buf[128];
@@ -211,4 +227,27 @@ TEST_F(bpf_handler, origin_relative_interpreter)
 	rmdir(RELOC_DIR);
 }
 
+/* A transparent dispatch: the process presents as the binary, not the interp. */
+TEST_F(bpf_handler, transparent_dispatch)
+{
+	char src[PATH_MAX], cmd[PATH_MAX + 16];
+
+	if (!have_transparent())
+		SKIP(return, "kernel without transparent mode");
+
+	ASSERT_EQ(artifact_path(src, sizeof(src), "binfmt_transparent_interp"), 0);
+	ASSERT_EQ(copy_file(src, TRANS_INTERP), 0);
+	ASSERT_EQ(create_fake_elf(TRANS_PATH, EM_RISCV), 0);
+
+	setenv("BINFMT_TEST_BINARY", TRANS_PATH, 1);
+	snprintf(cmd, sizeof(cmd), "%s argone argtwo", TRANS_PATH);
+	ASSERT_EQ(artifact_path(self->obj, sizeof(self->obj),
+				"transparent.bpf.o"), 0);
+	EXPECT_EQ(run_case(self->obj, "transparent", "test_bpf_transparent",
+			   cmd, TRANS_EXPECT), 0);
+
+	unlink(TRANS_PATH);
+	unlink(TRANS_INTERP);
+}
+
 TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/exec/binfmt_misc_transparent.c b/tools/testing/selftests/exec/binfmt_misc_transparent.c
new file mode 100644
index 000000000000..de59dc8c5695
--- /dev/null
+++ b/tools/testing/selftests/exec/binfmt_misc_transparent.c
@@ -0,0 +1,108 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test the static transparent flag 'T' of binfmt_misc. A magic-matched
+ * binary is dispatched to an interpreter with the argument vector left
+ * untouched, the binary passed through AT_EXECFD and mm->exe_file labeled
+ * with the binary. The asserting interpreter (binfmt_transparent_interp)
+ * verifies the constructed identity from inside the process and exits 0.
+ *
+ * Needs root for the registration; no bpf toolchain involved.
+ */
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/wait.h>
+
+#include "binfmt_misc_common.h"
+#include "kselftest_harness.h"
+
+#define MAGIC		"#TRANSPARENT-SELFTEST#"
+#define TARGET_PATH	"/tmp/binfmt_transparent_target"
+#define INTERP_PATH	"/tmp/binfmt_transparent_interp"
+#define ENTRY		"test_transparent"
+#define TRANSPARENT_ARGV0 "transparent-argv0"
+#define RULE(flags)	":" ENTRY ":M:0:" MAGIC "::" INTERP_PATH ":" flags
+
+/* The target only has to carry the magic; it is never actually loaded. */
+static int create_target(void)
+{
+	char buf[128] = MAGIC "\n";
+	int fd;
+
+	fd = open(TARGET_PATH, O_WRONLY | O_CREAT | O_TRUNC, 0755);
+	if (fd < 0)
+		return -1;
+	if (write(fd, buf, sizeof(buf)) != (ssize_t)sizeof(buf)) {
+		close(fd);
+		return -1;
+	}
+	close(fd);
+	return 0;
+}
+
+FIXTURE(transparent) {
+};
+
+FIXTURE_SETUP(transparent)
+{
+	char src[PATH_MAX];
+
+	if (getuid() != 0)
+		SKIP(return, "test must be run as root");
+	if (!binfmt_misc_available())
+		SKIP(return, "no binfmt_misc");
+
+	ASSERT_EQ(artifact_path(src, sizeof(src), "binfmt_transparent_interp"), 0);
+	ASSERT_EQ(copy_file(src, INTERP_PATH), 0);
+	ASSERT_EQ(create_target(), 0);
+
+	/* Skip the whole suite on a kernel that does not know 'T'. */
+	if (write_reg(RULE("T"))) {
+		ASSERT_EQ(errno, EINVAL);
+		SKIP(return, "kernel without the 'T' flag");
+	}
+	unregister(ENTRY);
+}
+
+FIXTURE_TEARDOWN(transparent)
+{
+	unregister(ENTRY);
+	unlink(TARGET_PATH);
+	unlink(INTERP_PATH);
+}
+
+/* Grammar sanity check: the same entry without 'T' has to register. */
+TEST_F(transparent, plain_entry_registers)
+{
+	ASSERT_EQ(write_reg(RULE("")), 0);
+}
+
+/* 'T' preserves the whole argv, so combining it with 'P' is rejected. */
+TEST_F(transparent, rejects_preserve_argv0)
+{
+	ASSERT_NE(write_reg(RULE("TP")), 0);
+	EXPECT_EQ(errno, EINVAL);
+}
+
+/* The interpreter asserts the identity the kernel built for it. */
+TEST_F(transparent, dispatch)
+{
+	int status;
+	pid_t pid;
+
+	ASSERT_EQ(write_reg(RULE("T")), 0);
+
+	setenv("BINFMT_TEST_BINARY", TARGET_PATH, 1);
+	setenv("BINFMT_TEST_ARGV0", TRANSPARENT_ARGV0, 1);
+	pid = fork();
+	ASSERT_GE(pid, 0);
+	if (pid == 0) {
+		execl(TARGET_PATH, TRANSPARENT_ARGV0, "argone", "argtwo", (char *)NULL);
+		_exit(126);
+	}
+	ASSERT_EQ(waitpid(pid, &status, 0), pid);
+	ASSERT_TRUE(WIFEXITED(status));
+	EXPECT_EQ(WEXITSTATUS(status), 0);
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/exec/binfmt_transparent_interp.c b/tools/testing/selftests/exec/binfmt_transparent_interp.c
new file mode 100644
index 000000000000..2a71c4706758
--- /dev/null
+++ b/tools/testing/selftests/exec/binfmt_transparent_interp.c
@@ -0,0 +1,130 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Asserting interpreter for the transparent binfmt_misc mode. It runs in
+ * place of the dispatched binary and verifies the identity the kernel
+ * constructed: the aux vector contract, the exe link, argv, cmdline, comm
+ * and the write denial on the binary. BINFMT_TEST_BINARY names the binary;
+ * the harness execs it with the arguments "argone argtwo". Prints
+ * TRANSPARENT_OK and exits 0 when every check holds.
+ */
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/auxv.h>
+#include <sys/stat.h>
+#include <unistd.h>
+
+#include "kselftest.h"
+
+#ifndef AT_FLAGS_TRANSPARENT_INTERP
+#define AT_FLAGS_TRANSPARENT_INTERP (1 << 1)
+#endif
+
+#define TASK_COMM_LEN 16
+
+static int fail;
+
+static void ok(int cond, const char *what)
+{
+	if (!cond) {
+		fprintf(stderr, "TRANSPARENT_FAIL: %s (errno %d)\n", what, errno);
+		fail = 1;
+	}
+}
+
+int main(int argc, char **argv)
+{
+	const char *binary = getenv("BINFMT_TEST_BINARY");
+	const char *argv0 = getenv("BINFMT_TEST_ARGV0");
+	char exe[PATH_MAX], real[PATH_MAX], buf[PATH_MAX];
+	char expect[PATH_MAX + 32];
+	unsigned long execfd;
+	struct stat stb, stfd;
+	const char *want[3];
+	const char *base;
+	size_t expect_len, i;
+	ssize_t n;
+	int fd;
+
+	if (!binary) {
+		fprintf(stderr, "TRANSPARENT_FAIL: BINFMT_TEST_BINARY unset\n");
+		return 1;
+	}
+	/* Distinct from the binary path, so a classic argv splice is caught. */
+	want[0] = argv0 ? argv0 : binary;
+	want[1] = "argone";
+	want[2] = "argtwo";
+
+	/* The aux vector announces the transparent contract. */
+	ok(getauxval(AT_FLAGS) & AT_FLAGS_TRANSPARENT_INTERP,
+	   "AT_FLAGS lacks AT_FLAGS_TRANSPARENT_INTERP");
+
+	/* AT_EXECFD refers to the very file that was executed. */
+	execfd = getauxval(AT_EXECFD);
+	ok(execfd > 2, "no AT_EXECFD");
+	ok(!stat(binary, &stb), "cannot stat the binary");
+	ok(!fstat((int)execfd, &stfd), "cannot fstat AT_EXECFD");
+	ok(stb.st_dev == stfd.st_dev && stb.st_ino == stfd.st_ino,
+	   "AT_EXECFD is not the binary");
+
+	/* The exe link names the binary, not this interpreter. */
+	n = readlink("/proc/self/exe", exe, sizeof(exe) - 1);
+	ok(n > 0, "cannot read /proc/self/exe");
+	if (n > 0)
+		exe[n] = '\0';
+	ok(n > 0 && realpath(binary, real) && !strcmp(exe, real),
+	   "/proc/self/exe is not the binary");
+
+	/* argv arrived unspliced. */
+	ok(argc == (int)ARRAY_SIZE(want), "argv was rewritten");
+	for (i = 0; i < ARRAY_SIZE(want) && i < (size_t)argc; i++)
+		ok(!strcmp(argv[i], want[i]), "argv was rewritten");
+
+	/* And so did the kernel's copy of it: the same strings, NUL separated. */
+	for (i = 0, expect_len = 0; i < ARRAY_SIZE(want); i++) {
+		size_t len = strlen(want[i]) + 1;
+
+		memcpy(expect + expect_len, want[i], len);
+		expect_len += len;
+	}
+	fd = open("/proc/self/cmdline", O_RDONLY);
+	n = fd >= 0 ? read(fd, buf, sizeof(buf)) : -1;
+	if (fd >= 0)
+		close(fd);
+	ok(n == (ssize_t)expect_len && !memcmp(buf, expect, expect_len),
+	   "/proc/self/cmdline was rewritten");
+
+	/* comm is the binary's basename. */
+	base = strrchr(binary, '/');
+	base = base ? base + 1 : binary;
+	snprintf(expect, TASK_COMM_LEN, "%s", base);
+	fd = open("/proc/self/comm", O_RDONLY);
+	n = fd >= 0 ? read(fd, buf, sizeof(buf) - 1) : -1;
+	if (fd >= 0)
+		close(fd);
+	if (n > 0 && buf[n - 1] == '\n')
+		n--;
+	if (n >= 0)
+		buf[n] = '\0';
+	ok(n > 0 && !strcmp(buf, expect), "comm is not the binary's basename");
+
+	/* The binary is write-denied while it runs, like a direct exec. */
+	errno = 0;
+	fd = open(binary, O_WRONLY);
+	ok(fd < 0 && errno == ETXTBSY, "binary is writable while running");
+	if (fd >= 0)
+		close(fd);
+	errno = 0;
+	fd = open("/proc/self/exe", O_WRONLY);
+	ok(fd < 0 && errno == ETXTBSY, "exe link is writable while running");
+	if (fd >= 0)
+		close(fd);
+
+	if (!fail)
+		printf("TRANSPARENT_OK\n");
+	return fail;
+}
diff --git a/tools/testing/selftests/exec/transparent.bpf.c b/tools/testing/selftests/exec/transparent.bpf.c
new file mode 100644
index 000000000000..7632019ebe69
--- /dev/null
+++ b/tools/testing/selftests/exec/transparent.bpf.c
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * binfmt_misc_ops handler for the transparent-mode case: match a synthetic
+ * riscv ELF header and run the asserting interpreter transparently - the
+ * argument vector untouched, the binary in AT_EXECFD and mm->exe_file
+ * labeled with the binary.
+ */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+#define EI_CLASS	4
+#define ELFCLASS64	2
+#define EM_RISCV	243
+
+extern int bpf_binprm_set_interp(struct linux_binprm *bprm, const char *path,
+				 size_t path__sz) __ksym;
+extern int bpf_binprm_set_flags(struct linux_binprm *bprm,
+				enum bpf_binprm_flags flags) __ksym;
+
+SEC("struct_ops.s/match")
+bool BPF_PROG(transparent_match, struct linux_binprm *bprm)
+{
+	__u16 machine;
+
+	if (bprm->buf[0] != 0x7f || bprm->buf[1] != 'E' ||
+	    bprm->buf[2] != 'L' || bprm->buf[3] != 'F' ||
+	    bprm->buf[EI_CLASS] != ELFCLASS64)
+		return false;
+
+	/* e_machine is a 16-bit little-endian field at offset 18. */
+	machine = (__u8)bprm->buf[18] | ((__u16)(__u8)bprm->buf[19] << 8);
+	return machine == EM_RISCV;
+}
+
+SEC("struct_ops.s/load")
+int BPF_PROG(transparent_load, struct linux_binprm *bprm)
+{
+	char interp[] = "/tmp/binfmt_transparent_interp";
+	int err;
+
+	err = bpf_binprm_set_flags(bprm, BPF_BINPRM_TRANSPARENT);
+	if (err)
+		return err;
+
+	/* @path__sz includes the terminating NUL; 0 commits the selection. */
+	return bpf_binprm_set_interp(bprm, interp, sizeof(interp));
+}
+
+SEC(".struct_ops.link")
+struct binfmt_misc_ops transparent = {
+	.match = (void *)transparent_match,
+	.load = (void *)transparent_load,
+	.name = "transparent",
+};

-- 
2.53.0


