Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48E70C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:34:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 526046B00D8; Mon, 20 Jul 2026 05:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FE096B00D9; Mon, 20 Jul 2026 05:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 414536B00DA; Mon, 20 Jul 2026 05:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 144816B00D8
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:34:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A117B1607D7
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:46 +0000 (UTC)
X-FDA: 85008645372.07.457E268
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id F376B160004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Gw/SPV54";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784540085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ov4tquAahGBcZiHmeEOUu3SlaUbolIjXy+o6OPsoFIQ=;
	b=EihvaflGOA5k48v3tnc0BT5LutvLJQt6rcho28lZMh0++Eimn8oogHmswKjYDSJMTBVrkk
	ssojA7OFgM9fpbznVWze9xoZMFksGRHhnbJueREeR4hwUREBOWWOVRvMo5wp6QihAVgoEj
	l3VNalJvX8dUNG2b0huQugkntaOl5N8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Gw/SPV54";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784540085;
	b=rQMQSf5w9aTqiuydhqHoad6kO03wS0V5u/rXTAQrrLS3Vhrw5asu5LLLW+Su+lEDUqIQAl
	Om3ywLg8/DRUhrna1rLPrLxZyxnDQS9xUF8gJog5NemY9w4cUYgY/bcfbZ9KFI+9AcV0l0
	exQolXgA2liG0cXHRHCFbQB1i3EfXFI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 81A0260103;
	Mon, 20 Jul 2026 09:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81EAB1F000E9;
	Mon, 20 Jul 2026 09:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784540084;
	bh=ov4tquAahGBcZiHmeEOUu3SlaUbolIjXy+o6OPsoFIQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Gw/SPV54Jh88N/SB9KjV5oR15mFAZH3ZYpfEeTRx62Q10MTu/mG2b4gNb1xKAu8MC
	 ARMZVm93/IjlGE7AE6NEXXrXL1or3H6CBvk80yYflz713jyASIhmUYkFRaE1cFEq5+
	 aewn5WwNgvc3fQV6+RtmP3keLCjPc0zhfCNS7y6bD6h4xI3MIrdOxn6yKIRAB2uJ7c
	 5WCyxwEMGs9Afxy2inVl6xaAAmiaOHEYVNvQ1QngJ3BLne++MRKNNSW8LSMxFq0Bvl
	 jZ3G+iT16/WOqlLq1nB3wuUq98tbBvcZ4HCo2mOPLEi+eydRyCXEGNejvFttq0xwXA
	 A/0zQd0UTH2oQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 20 Jul 2026 11:33:37 +0200
Subject: [PATCH 14/21] selftests/exec: test the transparent binfmt_misc
 mode
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-work-bpf-binfmt_misc-ptinterp-v1-14-ddb76c9a508e@kernel.org>
References: <20260720-work-bpf-binfmt_misc-ptinterp-v1-0-ddb76c9a508e@kernel.org>
In-Reply-To: <20260720-work-bpf-binfmt_misc-ptinterp-v1-0-ddb76c9a508e@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=16946; i=brauner@kernel.org;
 h=from:subject:message-id; bh=AM15bcA1VzjVrQWbKZKfiVmo8DosxAfjEl+xEJJ+L80=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTFvm46ZH9x5eT/4iFnlf8rS7Zs6MsQX3jr2IGf9f8yl
 scvub90V0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBE6psY/mdozjVwy9Cf38uo
 1cX/M8JUzzWpuZVTQ/THi7d/vk7u7mX4X3pe4tPvH/+1Hlze0fDPY3mhlu2fHbf4dj1Z1ShqnWE
 RwwUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F376B160004
X-Stat-Signature: 3pmaf7kguwn7jphgamoaia6yr8g9t8du
X-Rspam-User: 
X-HE-Tag: 1784540084-845665
X-HE-Meta: U2FsdGVkX1++HEcCU9Q3aICNtkqAs+gSuUxEYKZQzudruLCzFiimXX2Vkg9o3UYYOoumA9sE9/vC9nppEYi7SYdxdsXVQysXll4W36+9Kjj8MQ5jjt0A5cM5wOCCQUmSGhthbHKqRqNb8xgpKs5bQ1agTdu2mV74BEgLaqGuTvgom1RYhxKwYD40KycNx/J1BfjOx9oWlwaBq/V7U3cdvqbGSOMmnLjwbkJFHc+oRTKxTc3LjgWojqxHLeKOEqD4px72MdDgxm2X5Oye1rW1AJKeCuwAMQtaTH81y43AYP8umUzo7KN94EwsoH1NyAw76dG0Jbuicw9wHmqptiY6PmCklfzwbwX0E6WP+yC5dF1DjbnzjYePFBGNfnMd9D6a3oHX96FVFk+NGGmfTZlMVjZEcapy6xy60qmT0KKVh3O78/1EmUOmA4LmCvnLExmg1Tkffads7WlB/xUYVj0wdZqIzsDlJLSs7Fz7BeClSBIvnqzKzYKE7Ji8lT+cXYW/G0ydg495ZLzpxkO2QNrJx6xicHMe2s170iMJsNuksxdcBZ8asen0SGX+yenis8+6mJRIkiJg1AQ/MN8ZAT1BpDJMojbD9dBgUMzIV6grpWsQa0tygfxFoQxRzTKZRkJNDgGbIfB5vdWEmUCxUg44ssfLzjpTfB/iLLDe7Jpy1FP0BwJw0eKrSi6QxbUPSwtHifiMkblTAwlanQIUKvc/YrEZOyIIYA5Nta8pKw16QABe/E+g6l1V1rkKhgKkGplCFpYpWBrRHK00k5CMkcCm9JPnm6XkNjVciyZfiX2g4wjOceq6LnWmLz18AxvqO+GlfWr7OfuxfFbc8q7fj8dZ7sfgCzIrxJwlJtHpM5Orw8seCMYGc4epvv6sexBOTBozQVrmMugter7qR79KF4YEn1VPs9dWQq4wIwbthpw1bHhd+3PlBrZdByNg71r1s08QgLY0FmUqlMpGyF12UgU
 tmysSUMu
 9I1L0IGZyRf+BiK8ZZhwxl+kMtMR9Tyh8hfizLE2fXyXLiGmcCzaJYMV8EiC6LTdm7Dv+vqKPwaBw/LuMrbbdB85sxx56iBnMV6RlLPHnClcauNubAwsoT+cQMHXIuU3Cj3IMnqR4hQAVPnXt6fV988V9odjjkjjzKmOuC2nljwtGNUCUmnIVypUmexl6SgE/fHbIvb/kDOMG5xjBauaK2qHI0YnkM+Y5BGSXkkZ0GQT4NQn0rWk3P6Kqq4+11YnconDsrjaR21rsN4bUkXNsIcq+sJNJNVbvgRscAu+QgOvaRNLBP4N5jQr03qdGOuvsjWk4uOro1Xo2RNFf2887+qKCMIY6vOM/Vx/Z66sxWrbFdIdUc0a4D8ECVQ==
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
 tools/testing/selftests/exec/Makefile              |  10 +-
 tools/testing/selftests/exec/binfmt_misc_bpf.c     |  47 +++++++-
 .../selftests/exec/binfmt_misc_transparent.c       | 108 +++++++++++++++++
 .../selftests/exec/binfmt_transparent_interp.c     | 130 +++++++++++++++++++++
 tools/testing/selftests/exec/transparent.bpf.c     |  57 +++++++++
 6 files changed, 349 insertions(+), 5 deletions(-)

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
index fb5ca59af51d..6c2fdb674695 100644
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
@@ -99,6 +104,9 @@ $(OUTPUT)/binfmt_misc_bpf: binfmt_misc_bpf.c binfmt_misc_common.h
 $(OUTPUT)/binfmt_bpf_interp: binfmt_bpf_interp.c
 	$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@
 
+$(OUTPUT)/binfmt_transparent_interp: binfmt_transparent_interp.c
+	$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@
+
 # PT_INTERP is set to the literal "$ORIGIN/binfmt_bpf_interp"; the nix_origin
 # handler resolves it relative to the binary at run time.
 $(OUTPUT)/binfmt_bpf_app: binfmt_bpf_app.c
diff --git a/tools/testing/selftests/exec/binfmt_misc_bpf.c b/tools/testing/selftests/exec/binfmt_misc_bpf.c
index 7954c6274623..483c46e13410 100644
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
@@ -36,12 +40,15 @@
 #include <bpf/libbpf.h>
 
 #include "binfmt_misc_common.h"
-#include "../kselftest_harness.h"
+#include "kselftest_harness.h"
 
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


