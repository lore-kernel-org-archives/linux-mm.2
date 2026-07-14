Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDB9BC4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 19:58:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4237A6B0093; Tue, 14 Jul 2026 15:58:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D4146B0095; Tue, 14 Jul 2026 15:58:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 276666B0099; Tue, 14 Jul 2026 15:58:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DDE116B0093
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:58:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 55FC7404DD
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:58:55 +0000 (UTC)
X-FDA: 84988445430.11.FDC3041
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8DEFA40008
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:58:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iD4hLB+q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784059133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DVnDcell1AXZ56fbD85GqRLSDLbnP8N0LCG4fSHEjNE=;
	b=F/Yz17JFbc/C0HjCDxU+zhlK+9GzC5TBjK9EehBSUM9TCEBkNCwbz5XpAjqRDXOQG5m+O6
	wx7T8P16p7MicgCR/tfHGoV2GDs7uCLya9LXi9BjsSqP5GUbf8GmFadq9in8jrxxQt9Oek
	DAyR3T6QsJBQf6BQRe1MSO+6esjXqGI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iD4hLB+q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784059133;
	b=JQeRF3/P3uP+AfMzPkgSuvguyLt6U6iCXa8Bayoqq/geMS74D+JbA8I90w2SWw5L3BEVjW
	pXDIa90CIyaCKjaR3OjzG6IfJF3xQLxA2W9PUGDz+atV6Hz4HoLR6oLWbYbz3/m+1HnZCT
	sD+K3NIaFHlBgNKW87cu0US2Odu9HBQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 24019601D9;
	Tue, 14 Jul 2026 19:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470EA1F000E9;
	Tue, 14 Jul 2026 19:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784059132;
	bh=DVnDcell1AXZ56fbD85GqRLSDLbnP8N0LCG4fSHEjNE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iD4hLB+qvJJuNX0FD9ME6LSyAnu7WzYp5zSGnY4pXhqtGajDiNUC5Q2bPQcM3MB/9
	 wOMSUGsZs6cHFDBNUQ78LIEyXrG0Y7lqryIGatcO+gSk+SMX7H6DWBwc4stfH/nZRh
	 uYjQH46Y7/i1grNY97qKGf8iTAJZnTZN7ZzuzWZoLI7TPDm/7OvEw5+ZepS6eVBYKz
	 gUgAzQgah+Qe7Lg8ZCqEfSkCiatLxXh4XXut57hkMZrzGZkX8yucTnMKmS//Nvkj7B
	 k0rQohonchvkrMDRRBaYlZqZxT+FXqhhUCHzOr/LtuPf/JriP/0pgPfwf9wd9Mr1iy
	 Z75O5lGjlQaVg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 14 Jul 2026 21:58:14 +0200
Subject: [PATCH v2 9/9] selftests/exec: add binfmt_misc bpf-backed handler
 test
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-work-bpf-binfmt_misc-v2-9-57b7529c002c@kernel.org>
References: <20260714-work-bpf-binfmt_misc-v2-0-57b7529c002c@kernel.org>
In-Reply-To: <20260714-work-bpf-binfmt_misc-v2-0-57b7529c002c@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, bpf@vger.kernel.org, jannh@google.com, 
 mail@johnericson.me, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=24996; i=brauner@kernel.org;
 h=from:subject:message-id; bh=NUUkPazWlizWyjQOPBZfC7jPXqndtIt9ObH/4ybErFs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSFTbkc7XdvzWMZwZKWT6kJ1b0PGrtXdAln8hcqC5V5t
 ThclGbsKGVhEONikBVTZHFoNwmXW85TsdkoUwNmDisTyBAGLk4BmEhaOCPD71dXvH8t0Z6/fpbC
 tkizAF8z4wTf++5P2+9J9ts6RCc+ZWS4LDrHPPR7s5Y8k6HV0iyn1b08O4Sfu1XcjGrUDdb40cc
 DAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: htb55gxm9ytpbgrmnf87aa8t3xjtme5u
X-Rspamd-Queue-Id: 8DEFA40008
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784059133-673965
X-HE-Meta: U2FsdGVkX1+72t43hAIO0cTzmoCVgZ6mfexovhCs/pu1mwuVZPoalrir/f2zgDRiS801kg2Fc78HZ0tmU0OkZJW6lcHIohKT8ICJesy2eJ0Oqs/b4XuZLvqfSabXRTz1fcNyaMjlk9WTHwyPaOUo8wK/swdX9ZGdWA7/cBUTTgkbsAfjq1MZCcnDfyk5nRM5FX3rB36QK3tS3/vo23AcQjABMHWYI8QNQeYbv4klDBs0eWh94ohKCUSjbFWnNaipcwKUfT/UaOwVwaEzqkTRmCbv03Im+Bc8q9nJfjbsY8YcdBhemKWTNZNNZ5xykKg0tKQ5bhb0nr4J+Zl/NsrY//exrIvNpHIelh3HEhS798P4fHAEJIyUERr0fuoSbntvXfx+89RIJ1CoudxVma4jcFAHo1ON6qyRemmQDz2D8deY/Td+ECv1GsODhXu8DVYqgo0E/totnzqv2Rp+savm6aHjMNTm7E4hEFlqsVuc5Td8KYH2/tUZd/vgbdJrOcrV3jvX4j19zF/vAtGlYXoyq9xn9nW2al/sXAbXX1JSG8v2DJKRNt+BjlpFi4GPpcL/pHMxi3zPJa8n89NE2WwU4I0/Xb5m1kwJqioV4Mtg4WD/q/WixL/5RS1Y5cR+bE07dMiUv+xjRW8YEatRSv1Nj+MKyha6bXse3Pv4KDffirB1XYaTlqoqln0x1OGZDUoKJe+AIprbgg6Hz/YHDJXJK90L3xIayv+DMFgg69cMqmefF7hrfoZ993Dgo3VDh3dFrKZ9laKsJSIICzL7sGu+VR9NC+U/q/OvI7ZkiRZ4UFRcckKLMzzwp4PL9KgJ2CWUH4UJBAhyXvl1XEHi8bpeDBNmw6IHGVwQKsg6ZAXnxZaH1rrH66qYBKbYERE+5h+/fCGnt0OT/ytCGshoxPC/GZANbWNnO49PKpZ7A4AXn7wXKC0uz7lnYR/3A6gOTC3R15cuBHJKT9ezz3sTaS9
 +B23+esU
 4yhMirId0M+HtYAzvsI91Jp+aL9zxuZRQkbXEj3oFk9eGbLPs4dsvTaleEuLFGOdr2wIYG/rwvxOOgRpDi2Z+7PW9pU6DIATw2wmWQuPGXyWoJ73P3N4OrcmMCLooSi3SDXVe+qZ1g3QJedq4mnIQaa9RpzxhILn9wOKa9Rbp0/UnjIhaUJIZsd2If/CO5QFYjX8vzwZXh8gni8tt8z8tttgwMq1uLDSwYdstRpQ6KnbBbvSSBihLe+2FDr9qg5262yO5MtI0itZqR6nu659APVoZCUOpzO97CtVTZ1WnbeHebGfrBYY7KZmYZDVFYK+7IurW9GvZLKJp8zdhTwn4hxUziheCvT8LJZDNVRFOjN+ysNLfDVFJ9KjyT4tAeqi3wo5CtLijkbZGxkE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Farid Zakaria <farid.m.zakaria@gmail.com>

Exercise the bpf-backed ('B') binfmt_misc handlers end to end. A handler
is a struct binfmt_misc_ops struct_ops map; the test loads and attaches
it (which publishes it by name), activates it with a 'B' entry, and
checks that a matched binary is routed to the interpreter the program
selected via bpf_binprm_set_interp().

Two self-contained cases are covered:

  - bpf_interp: the match program matches a synthetic aarch64 ELF header
    from the prefetched bprm->buf and the load program routes it to a
    fixed interpreter of its choosing.
  - nix_origin: the match program parses the program headers to commit
    only to a "$ORIGIN/..."-relative PT_INTERP and the load program
    resolves it to an interpreter co-located with the binary -- the
    relocatable-loader case the kernel ELF loader cannot express. The
    relocatable binary is linked with PT_INTERP set to the literal
    "$ORIGIN/binfmt_bpf_interp" (-Wl,--dynamic-linker), which the kernel
    cannot resolve on its own.

Both route to a small test interpreter that prints a marker, proving the
program-selected interpreter actually ran.

The bpf objects are compiled against the running kernel's BTF: the
Makefile generates vmlinux.h with bpftool and the harness links libbpf.
Override CLANG/BPFTOOL/VMLINUX_BTF/LIBBPF_CFLAGS/LIBBPF_LDLIBS as needed.
The bpf pieces are only built when clang, bpftool, the vmlinux BTF and
libbpf are all present (HAVE_BPF_TOOLCHAIN=y forces them) so the other
exec selftests keep building without a bpf toolchain.

Christian Brauner (Amutable) <brauner@kernel.org> says:

Adapted to the two-op contract: 'B' entries carry the handler name in
the interpreter field, both programs are sleepable, the match programs
decide. nix_origin reads PT_INTERP from the match program and load
returns zero on success. Skip on kernels without binfmt_misc_ops in BTF.
Build the bpf pieces only when the toolchain is present and gitignore
the generated artifacts.

Signed-off-by: Farid Zakaria <farid.m.zakaria@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/exec/.gitignore          |   5 +
 tools/testing/selftests/exec/Makefile            |  48 ++++
 tools/testing/selftests/exec/binfmt_bpf_app.c    |  12 +
 tools/testing/selftests/exec/binfmt_bpf_interp.c |  15 ++
 tools/testing/selftests/exec/binfmt_misc_bpf.c   | 277 +++++++++++++++++++++++
 tools/testing/selftests/exec/bpf_interp.bpf.c    |  61 +++++
 tools/testing/selftests/exec/nix_origin.bpf.c    | 224 ++++++++++++++++++
 7 files changed, 642 insertions(+)

diff --git a/tools/testing/selftests/exec/.gitignore b/tools/testing/selftests/exec/.gitignore
index 7f3d1ae762ec..8b93b405c424 100644
--- a/tools/testing/selftests/exec/.gitignore
+++ b/tools/testing/selftests/exec/.gitignore
@@ -19,3 +19,8 @@ null-argv
 xxxxxxxx*
 pipe
 S_I*.test
+binfmt_misc_bpf
+binfmt_bpf_interp
+binfmt_bpf_app
+*.bpf.o
+vmlinux.h
diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index 45a3cfc435cf..ec66c1fecfc0 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -21,6 +21,26 @@ TEST_GEN_PROGS += recursion-depth
 TEST_GEN_PROGS += null-argv
 TEST_GEN_PROGS += check-exec
 
+# binfmt_misc bpf-backed ('B') handler test: a libbpf harness plus its
+# struct_ops objects and the test interpreter/app it routes between. Only
+# built when clang, bpftool, the vmlinux BTF and libbpf are all present
+# (HAVE_BPF_TOOLCHAIN=y forces it) so the other exec selftests don't grow
+# a bpf toolchain dependency.
+CLANG ?= clang
+BPFTOOL ?= bpftool
+VMLINUX_BTF ?= /sys/kernel/btf/vmlinux
+HAVE_BPF_TOOLCHAIN ?= $(shell command -v $(CLANG) >/dev/null 2>&1 && \
+			command -v $(BPFTOOL) >/dev/null 2>&1 && \
+			test -r $(VMLINUX_BTF) && \
+			pkg-config --exists libbpf 2>/dev/null && echo y)
+ifeq ($(HAVE_BPF_TOOLCHAIN),y)
+TEST_GEN_PROGS += binfmt_misc_bpf
+TEST_GEN_FILES += bpf_interp.bpf.o nix_origin.bpf.o
+TEST_GEN_FILES += binfmt_bpf_interp binfmt_bpf_app
+else
+$(info exec selftests: skipping binfmt_misc_bpf, needs clang, bpftool, vmlinux BTF and libbpf)
+endif
+
 EXTRA_CLEAN := $(OUTPUT)/subdir.moved $(OUTPUT)/execveat.moved $(OUTPUT)/xxxxx*	\
 	       $(OUTPUT)/S_I*.test
 
@@ -55,3 +75,31 @@ $(OUTPUT)/script-exec.inc: $(CHECK_EXEC_SAMPLES)/script-exec.inc
 	cp $< $@
 $(OUTPUT)/script-noexec.inc: $(CHECK_EXEC_SAMPLES)/script-noexec.inc
 	cp $< $@
+
+# --- binfmt_misc bpf ('B') handler test ---------------------------------
+# The struct_ops bpf objects are compiled against the running kernel's BTF.
+# CLANG/BPFTOOL/VMLINUX_BTF are set above next to the toolchain check;
+# override LIBBPF_CFLAGS/LDLIBS to point at a libbpf install.
+BPF_CFLAGS ?= -I$(OUTPUT)
+LIBBPF_CFLAGS ?=
+LIBBPF_LDLIBS ?= -lbpf -lelf -lz
+
+$(OUTPUT)/vmlinux.h:
+	$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
+	sed -i '/__ksym;$$/d' $@
+
+$(OUTPUT)/%.bpf.o: %.bpf.c $(OUTPUT)/vmlinux.h
+	$(CLANG) -g -O2 -target bpf -mcpu=v3 $(BPF_CFLAGS) $(LIBBPF_CFLAGS) -c $< -o $@
+
+$(OUTPUT)/binfmt_misc_bpf: binfmt_misc_bpf.c
+	$(CC) $(CFLAGS) $(LIBBPF_CFLAGS) $(LDFLAGS) $< $(LIBBPF_LDLIBS) -o $@
+
+$(OUTPUT)/binfmt_bpf_interp: binfmt_bpf_interp.c
+	$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@
+
+# PT_INTERP is set to the literal "$ORIGIN/binfmt_bpf_interp"; the nix_origin
+# handler resolves it relative to the binary at run time.
+$(OUTPUT)/binfmt_bpf_app: binfmt_bpf_app.c
+	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,--dynamic-linker,'$$ORIGIN/binfmt_bpf_interp' $< -o $@
+
+EXTRA_CLEAN += $(OUTPUT)/vmlinux.h $(OUTPUT)/bpf_interp.bpf.o $(OUTPUT)/nix_origin.bpf.o
diff --git a/tools/testing/selftests/exec/binfmt_bpf_app.c b/tools/testing/selftests/exec/binfmt_bpf_app.c
new file mode 100644
index 000000000000..472270f148bc
--- /dev/null
+++ b/tools/testing/selftests/exec/binfmt_bpf_app.c
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * A relocatable binary for the binfmt_misc_bpf $ORIGIN case. The Makefile
+ * links it with PT_INTERP set to the literal "$ORIGIN/binfmt_bpf_interp"
+ * (-Wl,--dynamic-linker), which the kernel ELF loader cannot resolve. The
+ * nix_origin bpf handler resolves it relative to this binary's directory and
+ * routes execution to the co-located interpreter.
+ */
+int main(void)
+{
+	return 0;
+}
diff --git a/tools/testing/selftests/exec/binfmt_bpf_interp.c b/tools/testing/selftests/exec/binfmt_bpf_interp.c
new file mode 100644
index 000000000000..2db205f095b2
--- /dev/null
+++ b/tools/testing/selftests/exec/binfmt_bpf_interp.c
@@ -0,0 +1,15 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test interpreter for the binfmt_misc_bpf selftest. A bpf-backed 'B' handler
+ * routes a matched binary here; printing this marker proves the program's
+ * chosen interpreter actually ran.
+ */
+#include <unistd.h>
+
+int main(int argc, char **argv)
+{
+	(void)argc;
+	(void)argv;
+	write(1, "BPF_INTERP_RAN\n", 15);
+	return 0;
+}
diff --git a/tools/testing/selftests/exec/binfmt_misc_bpf.c b/tools/testing/selftests/exec/binfmt_misc_bpf.c
new file mode 100644
index 000000000000..cb89d2766fe2
--- /dev/null
+++ b/tools/testing/selftests/exec/binfmt_misc_bpf.c
@@ -0,0 +1,277 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Selftest for binfmt_misc bpf-backed ('B') handlers.
+ *
+ * A handler is a struct binfmt_misc_ops struct_ops map with a sleepable match
+ * and a sleepable load program. Attaching it publishes it by name in the
+ * caller's user namespace; a 'B' entry referencing it by name in the
+ * interpreter field activates it:
+ *
+ *     echo ':name:B::::<handler>:' > /proc/sys/fs/binfmt_misc/register
+ *
+ * Two self-contained cases are exercised:
+ *
+ *   1. bpf_interp: the match program matches a synthetic aarch64 ELF header
+ *      from the prefetched bprm->buf and the load program routes it to a
+ *      fixed interpreter of its choosing.
+ *   2. nix_origin: the match program reads the binary's program headers to
+ *      commit only to a "$ORIGIN/..."-relative PT_INTERP and the load program
+ *      resolves it to an interpreter co-located with the binary (the
+ *      relocatable-loader case the kernel ELF loader cannot express).
+ *
+ * Both route to a test interpreter that prints BPF_INTERP_RAN, proving the
+ * program's chosen interpreter actually ran.
+ */
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <libgen.h>
+#include <sys/mount.h>
+#include <sys/stat.h>
+
+#include <bpf/btf.h>
+#include <bpf/libbpf.h>
+
+#define INTERP_PATH	"/tmp/binfmt_bpf_interp"
+#define AARCH64_PATH	"/tmp/binfmt_bpf_aarch64"
+#define RELOC_DIR	"/tmp/binfmt_reloc"
+#define BINFMT_REG	"/proc/sys/fs/binfmt_misc/register"
+#define EXPECT		"BPF_INTERP_RAN"
+
+static char testdir[512]; /* directory holding this test's built artifacts */
+
+static int copy_file(const char *src, const char *dst)
+{
+	char buf[4096];
+	int in, out;
+	ssize_t n;
+
+	in = open(src, O_RDONLY);
+	if (in < 0)
+		return -1;
+	out = open(dst, O_WRONLY | O_CREAT | O_TRUNC, 0755);
+	if (out < 0) {
+		close(in);
+		return -1;
+	}
+	while ((n = read(in, buf, sizeof(buf))) > 0) {
+		if (write(out, buf, n) != n) {
+			close(in);
+			close(out);
+			return -1;
+		}
+	}
+	close(in);
+	close(out);
+	return n < 0 ? -1 : 0;
+}
+
+/* A minimal 64-bit little-endian aarch64 ELF header, padded to the read size. */
+static int create_fake_aarch64(const char *path)
+{
+	unsigned char hdr[256] = {0};
+	int fd;
+
+	hdr[0] = 0x7f; hdr[1] = 'E'; hdr[2] = 'L'; hdr[3] = 'F';
+	hdr[4] = 2;			/* ELFCLASS64 */
+	hdr[5] = 1;			/* ELFDATA2LSB */
+	hdr[6] = 1;			/* EV_CURRENT */
+	hdr[16] = 2;			/* e_type = ET_EXEC */
+	hdr[18] = 183 & 0xff;		/* e_machine = EM_AARCH64 */
+	hdr[19] = (183 >> 8) & 0xff;
+	hdr[20] = 1;			/* e_version */
+
+	fd = open(path, O_WRONLY | O_CREAT | O_TRUNC, 0755);
+	if (fd < 0)
+		return -1;
+	if (write(fd, hdr, sizeof(hdr)) != (ssize_t)sizeof(hdr)) {
+		close(fd);
+		return -1;
+	}
+	close(fd);
+	return 0;
+}
+
+static int register_entry(const char *name, const char *handler)
+{
+	char rule[128];
+	int fd;
+	ssize_t n;
+
+	snprintf(rule, sizeof(rule), ":%s:B::::%s:", name, handler);
+	fd = open(BINFMT_REG, O_WRONLY);
+	if (fd < 0)
+		return -1;
+	n = write(fd, rule, strlen(rule));
+	close(fd);
+	return n < 0 ? -1 : 0;
+}
+
+static void unregister_entry(const char *name)
+{
+	char path[128];
+	int fd;
+
+	snprintf(path, sizeof(path), "/proc/sys/fs/binfmt_misc/%s", name);
+	fd = open(path, O_WRONLY);
+	if (fd >= 0) {
+		if (write(fd, "-1", 2) < 0)
+			; /* best effort */
+		close(fd);
+	}
+}
+
+static int check_output(const char *cmd, const char *expected)
+{
+	char buf[128];
+	FILE *fp;
+
+	fp = popen(cmd, "r");
+	if (!fp)
+		return -1;
+	if (!fgets(buf, sizeof(buf), fp)) {
+		pclose(fp);
+		return -1;
+	}
+	pclose(fp);
+	return strncmp(buf, expected, strlen(expected)) ? -1 : 0;
+}
+
+/*
+ * Load @objfile, attach its struct_ops map @handler (which publishes the
+ * handler), activate a 'B' entry named @entry that references it, run @target
+ * and check it produced @expect.
+ */
+static int run_case(const char *objfile, const char *handler,
+		    const char *entry, const char *target, const char *expect)
+{
+	struct bpf_object *obj;
+	struct bpf_map *map;
+	struct bpf_link *link;
+	int ret = -1;
+
+	obj = bpf_object__open_file(objfile, NULL);
+	if (!obj || libbpf_get_error(obj)) {
+		fprintf(stderr, "open %s failed\n", objfile);
+		return -1;
+	}
+	if (bpf_object__load(obj)) {
+		fprintf(stderr, "load %s failed (check dmesg for the verifier log)\n",
+			objfile);
+		goto close;
+	}
+	map = bpf_object__find_map_by_name(obj, handler);
+	if (!map) {
+		fprintf(stderr, "no struct_ops map '%s' in %s\n", handler, objfile);
+		goto close;
+	}
+	link = bpf_map__attach_struct_ops(map);
+	if (!link || libbpf_get_error(link)) {
+		fprintf(stderr, "attach struct_ops '%s' failed\n", handler);
+		goto close;
+	}
+	if (register_entry(entry, handler)) {
+		fprintf(stderr, "register 'B' entry '%s' failed\n", entry);
+		goto detach;
+	}
+	ret = check_output(target, expect);
+	unregister_entry(entry);
+detach:
+	bpf_link__destroy(link);
+close:
+	bpf_object__close(obj);
+	return ret;
+}
+
+int main(void)
+{
+	char src[600], obj[600], appdst[600], interpdst[600];
+	char exe[512];
+	ssize_t n;
+	int fail = 0;
+	struct stat st;
+	struct btf *btf;
+
+	if (getuid() != 0) {
+		fprintf(stderr, "Skipping: test must be run as root\n");
+		return 4; /* KSFT_SKIP */
+	}
+
+	/* The kernel must know struct binfmt_misc_ops (CONFIG_BINFMT_MISC_BPF). */
+	btf = btf__load_vmlinux_btf();
+	if (!btf || btf__find_by_name_kind(btf, "binfmt_misc_ops",
+					   BTF_KIND_STRUCT) < 0) {
+		fprintf(stderr,
+			"Skipping: no struct binfmt_misc_ops in the kernel BTF (CONFIG_BINFMT_MISC_BPF)\n");
+		btf__free(btf);
+		return 4; /* KSFT_SKIP */
+	}
+	btf__free(btf);
+
+	n = readlink("/proc/self/exe", exe, sizeof(exe) - 1);
+	if (n < 0) {
+		perror("readlink");
+		return 1;
+	}
+	exe[n] = '\0';
+	snprintf(testdir, sizeof(testdir), "%s", dirname(exe));
+
+	if (stat("/sys/fs/bpf", &st) < 0)
+		mkdir("/sys/fs/bpf", 0755);
+	mount("bpf", "/sys/fs/bpf", "bpf", 0, NULL);
+	if (access(BINFMT_REG, F_OK) < 0)
+		mount("binfmt_misc", "/proc/sys/fs/binfmt_misc", "binfmt_misc", 0, NULL);
+
+	/* Shared test interpreter. */
+	snprintf(src, sizeof(src), "%s/binfmt_bpf_interp", testdir);
+	if (copy_file(src, INTERP_PATH)) {
+		fprintf(stderr, "cannot install %s\n", INTERP_PATH);
+		return 1;
+	}
+
+	/* Case 1: match a synthetic aarch64 header -> fixed interpreter. */
+	printf("[*] case 1: match aarch64 header -> program-chosen interpreter\n");
+	if (create_fake_aarch64(AARCH64_PATH)) {
+		fprintf(stderr, "cannot create %s\n", AARCH64_PATH);
+		return 1;
+	}
+	snprintf(obj, sizeof(obj), "%s/bpf_interp.bpf.o", testdir);
+	if (run_case(obj, "bpf_interp", "test_bpf_interp", AARCH64_PATH, EXPECT) == 0)
+		printf("[+] case 1 passed\n");
+	else {
+		printf("[-] case 1 FAILED\n");
+		fail = 1;
+	}
+	unlink(AARCH64_PATH);
+
+	/* Case 2: $ORIGIN-relative PT_INTERP -> co-located interpreter. */
+	printf("[*] case 2: $ORIGIN interpreter resolved relative to the binary\n");
+	mkdir(RELOC_DIR, 0755);
+	snprintf(appdst, sizeof(appdst), "%s/app", RELOC_DIR);
+	snprintf(interpdst, sizeof(interpdst), "%s/binfmt_bpf_interp", RELOC_DIR);
+	snprintf(src, sizeof(src), "%s/binfmt_bpf_app", testdir);
+	if (copy_file(src, appdst) ||
+	    copy_file(INTERP_PATH, interpdst)) {
+		fprintf(stderr, "cannot set up %s\n", RELOC_DIR);
+		fail = 1;
+	} else {
+		snprintf(obj, sizeof(obj), "%s/nix_origin.bpf.o", testdir);
+		if (run_case(obj, "nix_origin", "test_bpf_origin", appdst, EXPECT) == 0)
+			printf("[+] case 2 passed\n");
+		else {
+			printf("[-] case 2 FAILED\n");
+			fail = 1;
+		}
+	}
+	unlink(appdst);
+	unlink(interpdst);
+	rmdir(RELOC_DIR);
+	unlink(INTERP_PATH);
+
+	if (!fail)
+		printf("[*] all binfmt_misc bpf cases passed\n");
+	return fail;
+}
diff --git a/tools/testing/selftests/exec/bpf_interp.bpf.c b/tools/testing/selftests/exec/bpf_interp.bpf.c
new file mode 100644
index 000000000000..8df2d2d01e25
--- /dev/null
+++ b/tools/testing/selftests/exec/bpf_interp.bpf.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * binfmt_misc_ops handler for the selftest's fixed-interpreter case: match a
+ * 64-bit aarch64 ELF header from the prefetched buffer and route it to a fixed
+ * interpreter chosen by the program. This is the portable, self-contained
+ * equivalent of routing a foreign binary to an emulator: it matches
+ * programmatically and computes the interpreter, but points at a test binary
+ * the harness installs rather than a system emulator.
+ */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+#define EI_CLASS	4
+#define ELFCLASS64	2
+#define EM_AARCH64	183
+
+extern int bpf_binprm_set_interp(struct linux_binprm *bprm, const char *path,
+				 size_t path__sz) __ksym;
+
+/*
+ * A magic-style decision needs nothing beyond the prefetched bprm->buf,
+ * even though the match program could read the file.
+ */
+SEC("struct_ops.s/match")
+bool BPF_PROG(bpf_interp_match, struct linux_binprm *bprm)
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
+	return machine == EM_AARCH64;
+}
+
+SEC("struct_ops.s/load")
+int BPF_PROG(bpf_interp_load, struct linux_binprm *bprm)
+{
+	/*
+	 * Keep the path on the (writable) stack: bpf_binprm_set_interp() takes
+	 * a sized memory arg and the verifier rejects a read-only .rodata
+	 * buffer for it. The harness installs the interpreter at this path.
+	 */
+	char interp[] = "/tmp/binfmt_bpf_interp";
+
+	/* @path__sz includes the terminating NUL; 0 commits the selection. */
+	return bpf_binprm_set_interp(bprm, interp, sizeof(interp));
+}
+
+SEC(".struct_ops.link")
+struct binfmt_misc_ops bpf_interp = {
+	.match = (void *)bpf_interp_match,
+	.load = (void *)bpf_interp_load,
+	.name = "bpf_interp",
+};
diff --git a/tools/testing/selftests/exec/nix_origin.bpf.c b/tools/testing/selftests/exec/nix_origin.bpf.c
new file mode 100644
index 000000000000..378e22a4c43b
--- /dev/null
+++ b/tools/testing/selftests/exec/nix_origin.bpf.c
@@ -0,0 +1,224 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * nix_origin.bpf.c - $ORIGIN-relative PT_INTERP resolution
+ *
+ * A binfmt_misc_ops handler that makes relocatable (Nix-style) ELF
+ * binaries work: if PT_INTERP starts with "$ORIGIN/", the loader is
+ * resolved relative to the directory of the binary being executed and
+ * selected via bpf_binprm_set_interp(). The match program reads the
+ * program headers itself, so anything else never commits to this
+ * handler and passes through untouched.
+ *
+ * Activate with:
+ *   bpftool struct_ops register nix_origin.bpf.o /sys/fs/bpf
+ *   echo ':nix-origin:B::::nix_origin:' > /proc/sys/fs/binfmt_misc/register
+ */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+#define PATH_MAX	4096
+#define EI_CLASS	4
+#define ELFCLASSXX	2	/* ELFCLASS64; flip to 1 for 32-bit */
+#define PT_INTERP	3
+#define MAX_PHDRS	64
+
+#define ORIGIN		"$ORIGIN"
+#define ORIGIN_LEN	(sizeof(ORIGIN) - 1)
+
+#define ENOENT		2
+#define ENOEXEC		8
+#define ENAMETOOLONG	36
+
+extern int bpf_dynptr_from_file(struct file *file, __u32 flags,
+				struct bpf_dynptr *ptr__uninit) __ksym;
+extern int bpf_dynptr_file_discard(struct bpf_dynptr *dynptr) __ksym;
+extern int bpf_path_d_path(const struct path *path, char *buf,
+			   size_t buf__sz) __ksym;
+extern int bpf_binprm_set_interp(struct linux_binprm *bprm, const char *path,
+				 size_t path__sz) __ksym;
+
+struct scratch {
+	char interp[PATH_MAX];	/* PT_INTERP as embedded in the binary */
+	char path[PATH_MAX];	/* d_path of the binary, becomes the result */
+};
+
+/* Keyed by pid: execs run concurrently and the programs can sleep. */
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 512);
+	__type(key, __u64);
+	__type(value, struct scratch);
+} scratch_map SEC(".maps");
+
+static const struct scratch zero_scratch;
+
+/* An ELF64 binary per the prefetched header? */
+static bool is_elf64(struct linux_binprm *bprm)
+{
+	return bprm->buf[0] == 0x7f && bprm->buf[1] == 'E' &&
+	       bprm->buf[2] == 'L' && bprm->buf[3] == 'F' &&
+	       bprm->buf[EI_CLASS] == ELFCLASSXX;
+}
+
+/* Locate PT_INTERP; false if the file has none or looks malformed. */
+static bool find_pt_interp(struct bpf_dynptr *dp, struct elf64_phdr *phdr)
+{
+	struct elf64_hdr ehdr;
+	bool found = false;
+	int i;
+
+	if (bpf_dynptr_read(&ehdr, sizeof(ehdr), dp, 0, 0))
+		return false;
+	if (ehdr.e_phentsize != sizeof(struct elf64_phdr))
+		return false;
+
+	bpf_for(i, 0, ehdr.e_phnum) {
+		if (i >= MAX_PHDRS)
+			break;
+		if (bpf_dynptr_read(phdr, sizeof(*phdr), dp,
+				    ehdr.e_phoff + i * sizeof(*phdr), 0))
+			return false;
+		if (phdr->p_type == PT_INTERP) {
+			found = true;
+			break;
+		}
+	}
+	return found;
+}
+
+/*
+ * An ELF64 binary whose PT_INTERP starts with "$ORIGIN/" is ours. The
+ * match can sleep and read the file, so the decision is made here and
+ * regular binaries never commit to this handler: later binfmt_misc
+ * entries and binfmt_elf see them as if we did not exist.
+ */
+SEC("struct_ops.s/match")
+bool BPF_PROG(nix_origin_match, struct linux_binprm *bprm)
+{
+	char prefix[ORIGIN_LEN + 1] = {};
+	struct elf64_phdr phdr;
+	struct bpf_dynptr dp;
+	bool ours = false;
+
+	if (!is_elf64(bprm))
+		return false;
+
+	/* The dynptr must be discarded on every path once requested. */
+	if (bpf_dynptr_from_file(bprm->file, 0, &dp))
+		goto out;
+	if (find_pt_interp(&dp, &phdr) &&
+	    phdr.p_filesz > ORIGIN_LEN + 1 &&
+	    !bpf_dynptr_read(prefix, sizeof(prefix), &dp, phdr.p_offset, 0))
+		ours = !bpf_strncmp(prefix, sizeof(prefix), ORIGIN "/");
+out:
+	bpf_dynptr_file_discard(&dp);
+	return ours;
+}
+
+/*
+ * The match is committed and already vetted the "$ORIGIN/" prefix, so
+ * everything here reads the file again from scratch: -ENOEXEC only
+ * covers a binary that changed under us and stopped being ours.
+ */
+SEC("struct_ops.s/load")
+int BPF_PROG(nix_origin_load, struct linux_binprm *bprm)
+{
+	__u32 isz, sfx, rsz, slash;
+	struct elf64_phdr phdr;
+	struct bpf_dynptr dp;
+	struct scratch *sc;
+	__u64 id;
+	int ret = -ENOEXEC, len, i;
+
+	if (bpf_dynptr_from_file(bprm->file, 0, &dp))
+		goto out;
+
+	if (!find_pt_interp(&dp, &phdr))
+		goto out;
+
+	isz = phdr.p_filesz;
+	if (isz <= ORIGIN_LEN + 1 || isz >= sizeof(sc->interp))
+		goto out;
+	/*
+	 * The range check above compiles to a test on a zero-extended copy of
+	 * the u64 p_filesz, so the verifier does not carry the bound to the
+	 * dynptr_read() length below ("unbounded memory access"). Mask isz to
+	 * the buffer size (a power of two) and force the masked value to be
+	 * materialized with a barrier so the read uses the bounded register.
+	 */
+	isz &= sizeof(sc->interp) - 1;
+	barrier_var(isz);
+
+	id = bpf_get_current_pid_tgid();
+	if (bpf_map_update_elem(&scratch_map, &id, &zero_scratch, BPF_ANY))
+		goto out;
+	sc = bpf_map_lookup_elem(&scratch_map, &id);
+	if (!sc)
+		goto out_del;
+
+	if (bpf_dynptr_read(sc->interp, isz, &dp, phdr.p_offset, 0))
+		goto out_del;
+	if (sc->interp[isz - 1] != '\0')
+		goto out_del;
+
+	/* Not "$ORIGIN/..." anymore? Then it is not ours anymore either. */
+	if (sc->interp[0] != '$' || sc->interp[1] != 'O' ||
+	    sc->interp[2] != 'R' || sc->interp[3] != 'I' ||
+	    sc->interp[4] != 'G' || sc->interp[5] != 'I' ||
+	    sc->interp[6] != 'N' || sc->interp[7] != '/')
+		goto out_del;
+
+	/*
+	 * From here on resolution failures fail the exec instead of falling
+	 * back to binfmt_elf, which would resolve the literal "$ORIGIN/..."
+	 * relative to the caller's cwd.
+	 */
+	ret = -ENOENT;
+	len = bpf_path_d_path(&bprm->file->f_path, sc->path, sizeof(sc->path));
+	if (len <= 0 || len > sizeof(sc->path))
+		goto out_del;
+	/* Unreachable or unlinked ("... (deleted)") binaries can't resolve. */
+	if (sc->path[0] != '/')
+		goto out_del;
+
+	/* $ORIGIN = dirname of the binary. */
+	slash = 0;
+	bpf_for(i, 1, len - 1) {
+		if (i >= sizeof(sc->path))
+			break;
+		if (sc->path[i] == '/')
+			slash = i;
+	}
+
+	/* Splice the suffix (leading '/' and NUL included) onto the dir. */
+	sfx = isz - ORIGIN_LEN;
+	rsz = slash + sfx;
+	if (rsz > sizeof(sc->path)) {
+		ret = -ENAMETOOLONG;
+		goto out_del;
+	}
+	bpf_for(i, 0, sfx) {
+		__u32 s = ORIGIN_LEN + i, d = slash + i;
+
+		if (s >= sizeof(sc->interp) || d >= sizeof(sc->path))
+			break;
+		sc->path[d] = sc->interp[s];
+	}
+
+	ret = bpf_binprm_set_interp(bprm, sc->path, rsz);
+out_del:
+	bpf_map_delete_elem(&scratch_map, &id);
+out:
+	bpf_dynptr_file_discard(&dp);
+	return ret;
+}
+
+SEC(".struct_ops.link")
+struct binfmt_misc_ops nix_origin = {
+	.match = (void *)nix_origin_match,
+	.load = (void *)nix_origin_load,
+	.name = "nix_origin",
+};

-- 
2.53.0


