Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C9C5C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:15:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4C886B00BE; Tue, 21 Jul 2026 10:15:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD5836B00C0; Tue, 21 Jul 2026 10:15:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC5F46B00C1; Tue, 21 Jul 2026 10:15:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 79CC46B00BE
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:15:32 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 05CD21201A7
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:15:32 +0000 (UTC)
X-FDA: 85012981704.01.8451555
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2D50C20006
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:15:30 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gKYi9WU8;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784643330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3zsrX8rm31ZH6Yry5EwAViRyO62WwkhFlatqwEfblEk=;
	b=G7QjajoZ9xF9M2VhHbYIpbV+R0CG6GYUHYkBhFlECRrwH/LNnzy6tbVHDnTlQUKoip5Nrn
	KcT9qWz9qX5hmjfeVtQMSZK0ZLobw0FuA0PFng2n015njA0VERoxvAT8Gg8hvaI1wvMsBA
	K1sQ1ArB874r9M5pc8iK7i4WhozY+xg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784643330;
	b=iNP4WDPYFxPNTsdFHi4UAbgmCHxf8QQm/HxvvmlWFbXpyKyVo8lhkq6SwpVmw54w98KDi4
	71PoWouOjnIydFiiWEFMoyuud499bVGqhxuv5JupAq6PdnsFypGmfFYFihfjGNEiXJI1C6
	YlXVZmF5J/+Hln9uRc+XVAJLnz3S3Kw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gKYi9WU8;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8735840181;
	Tue, 21 Jul 2026 14:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44171F000E9;
	Tue, 21 Jul 2026 14:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784643329;
	bh=3zsrX8rm31ZH6Yry5EwAViRyO62WwkhFlatqwEfblEk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gKYi9WU8aoDkWkjVt616J1UNLiE45SUzb3MIGBbqDh8+5y7hRFb+wpvGGWwNntXJy
	 fGt1V6aYZ/NHrJHWH4isiyYdcOxDbunW32PqqhigQb78FUri06ssOE0gHxvQVMz2pi
	 orRrT401zfhwL15f/9xHbcNDqQwFeUqfxj4+6hTsy+95j8np/2ZFEWxKrV+NAR4y+I
	 0+n5qk5QnaPtN8nPlNIN11Tn3Z1YjCIggtLn7bnFdJfkfcS+T3jXlF//vE/qI+cIwG
	 BPZi7almtCZCPg2r7JybfwgqByEfL5sFrKGdHhGbSWXAM5qdeUv4zhMMDV4h1dK+Q6
	 NtQBNFJHKztmw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 21 Jul 2026 16:14:02 +0200
Subject: [PATCH v2 20/21] selftests/exec: test binfmt_misc loader
 substitution
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-work-bpf-binfmt_misc-ptinterp-v2-20-e57866e4ae0f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=32116; i=brauner@kernel.org;
 h=from:subject:message-id; bh=laWi8kCacYMPZcxdxXFBZ0bgtiUaweYGsHHbReyrQqQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTF1x2Q1ktku5KbJnvhcYD3twOCh6d8OeB+90P7queP0
 zROOWjc7ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhI7k1GhjM/A7aYW619P5v5
 6KsXHcdWT7pidf+Fm7KP/lHf0PU7A+MZGRbvTFGsWHI2Qt5E36Sx7VW86rmiS2tq/FQCUm6x9Jz
 x5gEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2D50C20006
X-Stat-Signature: tpn6bcpjawbe6nwqoinp5mdynt67kuxc
X-HE-Tag: 1784643330-344209
X-HE-Meta: U2FsdGVkX18bEf8cZGBPaj8WedrBPPejI3qb2Ci1Rwimd23owT6Pozsvgk5A0OFhLdHxqBErZRLKNh8mqnbRmw3KF4S0e7nyZLVqCTyBZFPd+VwYIz1tWZlmvYVwwee+rmnIctgaGGNEOh5trFuy59drmAMKMhwikxeKeLa2BTowGPMGSpz+oBp00UCa1pSbX9V6ZpodY5q1KEMjqILRQBLP78ifW1Gp3b4W0FnACSnCivliz7FA/7JEyZ0Nw2AspDxxP5B0jsREer3hMiAH9+YCMmZphNXUrdd36e4e6mBUZY31cnXUZY+8mYJ0pbQDPiMsAiktaX/TymUBV7PK5Ek2xdAl/SHkYI52yyLcHx2p0mwXUq9Y90AHSSQ3POIqtUlwSXKO7dtqov//dV/Lr4//H66KzRh64LdtKCHSwNaA6a8l/7cUYPFoQspvYASPPVwb+9KtJQ+CB9Pk9LsZMZxbFncEHBc0zulrjW9+tWNXnqB7o9eouH4py2IMRwMLuXVKmTzisBVHqkxHGsGZjhPpD48ZIMxx3WEI5HdboS1L7Pv2TA7xz6fdidzacw3yKRD7WjwKSw8TNooQJnJnq90372835sTMuUm0j4v7wNNImRZXL4eqU9Ff5cKSY+dxLJeweN9ZqUVOBUSJOdPLENz7tvd+m8LGXZC34tveUDvzv2jvXJlApSPGMlZObK2VQFJKtosBBBYL+pTSdyFZ5DywT8iB55gUhR2hhLn/V4818BRkt940y4g8mlzLEcvjoOZ3ZJHXSq+vsEe+LydVAu/gFZzldooQxtdE4yeAXO2ivATZ3EmDNlc0pM9nyowmtEeQhqyXywV6Cb5+EJ5jjQD/gd75a+T2pLQZpAR/Evn/33hPChp6gsE33YcesWoarUD+IvP5QdakKH/6xedGCUS4lqILFjVt+1kusmv1w1l/HXXKFh4leOuARcn+W7Rv3fQH25jLvUf6BmOmn8k
 Fw3iT9H4
 dgPSYk7siwLrJbsTJO3H/eqEyP1x1B+WqKJraibRMS4oHAP252+wCbQJGcd6Vve1zV1nwqDTjm8zH8o+KqzVnWHLUaCDnFHA02b4+wsCd7U+p7y5FJyKd6BnCeixi4llv8uHdKh7o8sMxoVUHMLOA2sIcEaDioNu+tmpD6nED91nlvnEwMQznKoEvCKYHJlSfIq5T+dNVZVS/HjqeB/BA7X9UdcypZtl2+rn/3stvW4y9f7GnxYqj99rVEhxaXCcWBdc5D0WkpxEgyDIEsgi2b9u4APnuHCIWrN78JIdQumor8IFHedG3O63467sDwaS/oOK1aUShEvY7srcyq+Nq+hNj6RILGeFVPaGMd3S1YaAej5eR7uLLroYAjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Exercise the 'L' flag end to end. The payload runs as the main image
with a copy of the system loader substituted for its PT_INTERP, and
asserts the native identity from inside:

- argv exactly as the caller built it
- no AT_EXECFD
- AT_FLAGS clear
- AT_BASE set but outside its own image
- AT_PHDR/AT_ENTRY inside it
- /proc/self/{exe,comm,stat} and AT_EXECFN all describing the binary
- ETXTBSY on the running binary
- the substituted loader visible in /proc/self/maps under its real path

Magic matching pokes a marker into the ELF header's e_ident padding
(EI_PAD, offset 9), which sits inside the match window and is ignored by
kernel and loader alike. the same binary is also matched by extension.

Two cases cover the paths where the substitution does not happen. A '#!'
file that matched an 'L' entry is claimed by binfmt_script rather than by
binfmt_elf, so the staged substitute has to be released when the
interpreter replaces the file; the test opens the loader for writing
afterwards, which fails with ETXTBSY if the write denial was leaked
instead. A relative interpreter path is rejected at registration for both
'L' and 'C', neither of which may resolve one against the working
directory of whoever runs the binary.

The bpf-side BPF_BINPRM_LOADER path shares all machinery past the flag
mapping. A harness case for it can join the bpf runtime coverage of
the transparent series.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/exec/.gitignore            |   3 +
 tools/testing/selftests/exec/Makefile              |  14 +
 .../testing/selftests/exec/binfmt_loader_payload.c | 167 ++++++++++
 tools/testing/selftests/exec/binfmt_misc_bpf.c     | 112 +++++--
 tools/testing/selftests/exec/binfmt_misc_common.h  | 107 ++++++
 tools/testing/selftests/exec/binfmt_misc_loader.c  | 371 +++++++++++++++++++++
 tools/testing/selftests/exec/loader.bpf.c          |  56 ++++
 7 files changed, 808 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/exec/.gitignore b/tools/testing/selftests/exec/.gitignore
index 94b9ab4eb46c..fbbb1600ddb9 100644
--- a/tools/testing/selftests/exec/.gitignore
+++ b/tools/testing/selftests/exec/.gitignore
@@ -24,5 +24,8 @@ binfmt_bpf_interp
 binfmt_bpf_app
 binfmt_misc_transparent
 binfmt_transparent_interp
+binfmt_misc_loader
+binfmt_loader_payload
+binfmt_loader_payload_static
 *.bpf.o
 vmlinux.h
diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index b316ff46d03c..b05b82ceae42 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -26,6 +26,13 @@ TEST_GEN_PROGS += check-exec
 TEST_GEN_PROGS += binfmt_misc_transparent
 TEST_GEN_FILES += binfmt_transparent_interp
 
+# 'L' (loader substitution) binfmt_misc test: the payload runs as the main
+# image with a copy of the system loader substituted for its PT_INTERP and
+# asserts the native identity from inside; the static build proves the
+# override is dropped for a binary without PT_INTERP.
+TEST_GEN_PROGS += binfmt_misc_loader
+TEST_GEN_FILES += binfmt_loader_payload binfmt_loader_payload_static
+
 # binfmt_misc bpf-backed ('B') handler test: a libbpf harness plus its
 # struct_ops objects and the test interpreter/app it routes between. Only
 # built when clang, bpftool, the vmlinux BTF and libbpf are all present
@@ -41,6 +48,7 @@ HAVE_BPF_TOOLCHAIN ?= $(shell command -v $(CLANG) >/dev/null 2>&1 && \
 ifeq ($(HAVE_BPF_TOOLCHAIN),y)
 TEST_GEN_PROGS += binfmt_misc_bpf
 TEST_GEN_FILES += bpf_interp.bpf.o nix_origin.bpf.o transparent.bpf.o
+TEST_GEN_FILES += loader.bpf.o
 TEST_GEN_FILES += binfmt_bpf_interp binfmt_bpf_app
 else
 $(info exec selftests: skipping binfmt_misc_bpf, needs clang, bpftool, vmlinux BTF and libbpf)
@@ -104,6 +112,12 @@ $(OUTPUT)/binfmt_misc_bpf: binfmt_misc_bpf.c binfmt_misc_common.h
 $(OUTPUT)/binfmt_bpf_interp: binfmt_bpf_interp.c
 	$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@
 
+$(OUTPUT)/binfmt_loader_payload: binfmt_loader_payload.c binfmt_misc_common.h
+	$(CC) $(CFLAGS) $(LDFLAGS) -fPIE -pie $< -o $@
+
+$(OUTPUT)/binfmt_loader_payload_static: binfmt_loader_payload.c binfmt_misc_common.h
+	$(CC) $(CFLAGS) $(LDFLAGS) -static $< -o $@
+
 # PT_INTERP is set to the literal "$ORIGIN/binfmt_bpf_interp"; the nix_origin
 # handler resolves it relative to the binary at run time.
 $(OUTPUT)/binfmt_bpf_app: binfmt_bpf_app.c
diff --git a/tools/testing/selftests/exec/binfmt_loader_payload.c b/tools/testing/selftests/exec/binfmt_loader_payload.c
new file mode 100644
index 000000000000..9396e9fdf264
--- /dev/null
+++ b/tools/testing/selftests/exec/binfmt_loader_payload.c
@@ -0,0 +1,167 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Payload for the binfmt_misc 'L' (loader substitution) selftest. It is
+ * executed as the MAIN image - a fully native exec - with the registered
+ * interpreter substituted for its PT_INTERP, and asserts the native
+ * identity from the inside. Exits 0 when every surface checks out.
+ *
+ * Modes, selected by the orchestrator via the environment:
+ *  - default:                full assertions, path-based ones included
+ *  - BINFMT_TEST_MEMFD=1:    executed from an inaccessible memfd, skip
+ *                            the path-based assertions
+ *  - BINFMT_TEST_STATIC=1:   static build; the override was dropped, so
+ *                            expect no interpreter at all
+ */
+#define _GNU_SOURCE
+#include <elf.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/auxv.h>
+#include <unistd.h>
+
+#include "binfmt_misc_common.h"
+
+/* Start of our own mapped image, courtesy of the linker. */
+extern const char __ehdr_start[];
+
+/* An image is never this large; used to bracket "within our image". */
+#define IMAGE_SPAN (16UL << 20)
+
+static int failed;
+
+static void check(int cond, const char *what)
+{
+	if (cond)
+		return;
+	fprintf(stderr, "[payload] FAILED: %s (errno %d)\n", what, errno);
+	failed = 1;
+}
+
+/* Return whether /proc/self/maps names a path starting with @prefix. */
+static int maps_has_prefix(const char *prefix)
+{
+	char *line = NULL;
+	size_t len = 0;
+	int found = 0;
+	FILE *f;
+
+	f = fopen("/proc/self/maps", "r");
+	if (!f)
+		return -1;
+	while (getline(&line, &len, f) > 0) {
+		char *path = strchr(line, '/');
+
+		if (path && !strncmp(path, prefix, strlen(prefix))) {
+			found = 1;
+			break;
+		}
+	}
+	free(line);
+	fclose(f);
+	return found;
+}
+
+int main(int argc, char *argv[])
+{
+	const char *binary = getenv("BINFMT_TEST_BINARY");
+	const char *interp = getenv("BINFMT_TEST_INTERP");
+	int memfd_mode = getenv("BINFMT_TEST_MEMFD") != NULL;
+	int static_mode = getenv("BINFMT_TEST_STATIC") != NULL;
+	unsigned long self = (unsigned long)__ehdr_start;
+	unsigned long base = getauxval(AT_BASE);
+	unsigned long phdr = getauxval(AT_PHDR);
+	unsigned long entry = getauxval(AT_ENTRY);
+	unsigned long start_code, end_code;
+	char buf[PATH_MAX];
+	ssize_t n;
+
+	/* The argument vector is exactly what the caller built. */
+	check(argc == 3 && !strcmp(argv[0], "payload-argv0") &&
+	      !strcmp(argv[1], "argone") && !strcmp(argv[2], "argtwo"),
+	      "argv was rewritten");
+
+	/* Native from birth: no execfd, no dispatch marker. */
+	check(getauxval(AT_EXECFD) == 0, "AT_EXECFD present");
+	check(getauxval(AT_FLAGS) == 0, "AT_FLAGS not native");
+
+	if (static_mode) {
+		/* The override was dropped: no interpreter was loaded. */
+		check(base == 0, "AT_BASE set for a static payload");
+	} else {
+		/* A loader is mapped in the interpreter slot, not our image. */
+		check(base != 0, "AT_BASE missing");
+		check(base < self || base >= self + IMAGE_SPAN,
+		      "AT_BASE inside our own image");
+	}
+
+	/* We occupy the main-image slot. */
+	check(phdr >= self && phdr < self + IMAGE_SPAN,
+	      "AT_PHDR outside our image");
+	check(entry >= self && entry < self + IMAGE_SPAN,
+	      "AT_ENTRY outside our image");
+
+	/* The code statistics markers describe our image, natively placed. */
+	if (stat_codes(getpid(), &start_code, &end_code) == 0) {
+		check(start_code >= self && start_code < end_code &&
+		      end_code < self + IMAGE_SPAN,
+		      "stat start_code/end_code not our image");
+		check(entry >= start_code && entry < end_code,
+		      "AT_ENTRY outside [start_code, end_code)");
+	} else {
+		check(0, "cannot parse /proc/self/stat");
+	}
+
+	if (!memfd_mode && binary) {
+		const char *execfn = (const char *)getauxval(AT_EXECFN);
+		const char *base_name = strrchr(binary, '/');
+		char comm[32] = "";
+		int fd;
+
+		base_name = base_name ? base_name + 1 : binary;
+
+		/* exe link, AT_EXECFN and comm all follow the binary. */
+		n = readlink("/proc/self/exe", buf, sizeof(buf) - 1);
+		check(n > 0, "readlink /proc/self/exe");
+		if (n > 0) {
+			buf[n] = '\0';
+			check(!strcmp(buf, binary), "/proc/self/exe");
+		}
+
+		check(execfn && !strcmp(execfn, binary), "AT_EXECFN");
+
+		fd = open("/proc/self/comm", O_RDONLY);
+		check(fd >= 0, "open /proc/self/comm");
+		if (fd >= 0) {
+			n = read(fd, comm, sizeof(comm) - 1);
+			if (n > 0 && comm[n - 1] == '\n')
+				n--;
+			comm[n > 0 ? n : 0] = '\0';
+			check(!strncmp(comm, base_name, 15), "comm");
+			close(fd);
+		}
+
+		/* The running binary is write-denied, natively. */
+		check(open(binary, O_WRONLY) < 0 && errno == ETXTBSY,
+		      "no ETXTBSY on the binary");
+	}
+
+	if (interp) {
+		int found = maps_has_prefix(interp);
+
+		if (static_mode)
+			/* Nothing was substituted, nothing may be mapped. */
+			check(found == 0, "loader mapped for a static payload");
+		else
+			/* The substituted loader shows under its real path. */
+			check(found == 1, "loader path not in /proc/self/maps");
+	}
+
+	if (failed)
+		return 1;
+	printf("[payload] native identity checks out\n");
+	return 0;
+}
diff --git a/tools/testing/selftests/exec/binfmt_misc_bpf.c b/tools/testing/selftests/exec/binfmt_misc_bpf.c
index 483c46e13410..cb06c3ac127a 100644
--- a/tools/testing/selftests/exec/binfmt_misc_bpf.c
+++ b/tools/testing/selftests/exec/binfmt_misc_bpf.c
@@ -22,6 +22,10 @@
  *      asserting interpreter (binfmt_transparent_interp) verifies the
  *      identity the kernel constructed (exe link, argv, cmdline, comm,
  *      AT_EXECFD, write denial) from inside the process.
+ *   4. loader: the load program sets BPF_BINPRM_LOADER; the payload
+ *      (binfmt_loader_payload) runs as the main image with the selected
+ *      interpreter substituted for its PT_INTERP and asserts the native
+ *      identity from inside.
  *
  * The first two route to a test interpreter that prints BPF_INTERP_RAN,
  * proving the program's chosen interpreter actually ran.
@@ -49,6 +53,8 @@
 #define TRANS_PATH	"/tmp/binfmt_bpf_riscv"
 #define EXPECT		"BPF_INTERP_RAN"
 #define TRANS_EXPECT	"TRANSPARENT_OK"
+#define LOADER_INTERP	"/tmp/binfmt_loader_interp"
+#define LOADER_PATH	"/tmp/binfmt_bpf_loader.ldrtest"
 
 /* A minimal 64-bit little-endian ELF header, padded to the read size. */
 static int create_fake_elf(const char *path, unsigned short machine)
@@ -109,49 +115,80 @@ static int check_output(const char *cmd, const char *expected)
 	return strncmp(buf, expected, strlen(expected)) ? -1 : 0;
 }
 
+/* An attached handler with its 'B' entry activated. */
+struct bpf_case {
+	struct bpf_object *obj;
+	struct bpf_link *link;
+	const char *entry;
+};
+
 /*
  * Load @objfile, attach its struct_ops map @handler (which publishes the
- * handler), activate a 'B' entry named @entry that references it, run @target
- * and check it produced @expect.
+ * handler) and activate a 'B' entry named @entry that references it.
  */
-static int run_case(const char *objfile, const char *handler,
-		    const char *entry, const char *target, const char *expect)
+static int bpf_case_start(struct bpf_case *c, const char *objfile,
+			  const char *handler, const char *entry)
 {
-	struct bpf_object *obj;
 	struct bpf_map *map;
-	struct bpf_link *link;
-	int ret = -1;
 
-	obj = bpf_object__open_file(objfile, NULL);
-	if (!obj || libbpf_get_error(obj)) {
+	c->obj = NULL;
+	c->link = NULL;
+	c->entry = entry;
+
+	c->obj = bpf_object__open_file(objfile, NULL);
+	if (!c->obj || libbpf_get_error(c->obj)) {
 		fprintf(stderr, "open %s failed\n", objfile);
+		c->obj = NULL;
 		return -1;
 	}
-	if (bpf_object__load(obj)) {
+	if (bpf_object__load(c->obj)) {
 		fprintf(stderr, "load %s failed (check dmesg for the verifier log)\n",
 			objfile);
-		goto close;
+		goto fail;
 	}
-	map = bpf_object__find_map_by_name(obj, handler);
+	map = bpf_object__find_map_by_name(c->obj, handler);
 	if (!map) {
 		fprintf(stderr, "no struct_ops map '%s' in %s\n", handler, objfile);
-		goto close;
+		goto fail;
 	}
-	link = bpf_map__attach_struct_ops(map);
-	if (!link || libbpf_get_error(link)) {
+	c->link = bpf_map__attach_struct_ops(map);
+	if (!c->link || libbpf_get_error(c->link)) {
 		fprintf(stderr, "attach struct_ops '%s' failed\n", handler);
-		goto close;
+		c->link = NULL;
+		goto fail;
 	}
 	if (register_entry(entry, handler)) {
 		fprintf(stderr, "register 'B' entry '%s' failed\n", entry);
-		goto detach;
+		goto fail;
 	}
+	return 0;
+
+fail:
+	bpf_link__destroy(c->link);
+	bpf_object__close(c->obj);
+	c->obj = NULL;
+	c->link = NULL;
+	return -1;
+}
+
+static void bpf_case_stop(struct bpf_case *c)
+{
+	unregister(c->entry);
+	bpf_link__destroy(c->link);
+	bpf_object__close(c->obj);
+}
+
+/* Activate @handler, run @target and check it produced @expect. */
+static int run_case(const char *objfile, const char *handler,
+		    const char *entry, const char *target, const char *expect)
+{
+	struct bpf_case c;
+	int ret;
+
+	if (bpf_case_start(&c, objfile, handler, entry))
+		return -1;
 	ret = check_output(target, expect);
-	unregister(entry);
-detach:
-	bpf_link__destroy(link);
-close:
-	bpf_object__close(obj);
+	bpf_case_stop(&c);
 	return ret;
 }
 
@@ -250,4 +287,35 @@ TEST_F(bpf_handler, transparent_dispatch)
 	unlink(TRANS_INTERP);
 }
 
+/* A per-exec loader substitution: the payload runs as a native exec. */
+TEST_F(bpf_handler, loader_substitution)
+{
+	char src[PATH_MAX], loader[PATH_MAX];
+	struct bpf_case c;
+	int status;
+
+	if (find_loader(loader, sizeof(loader)))
+		SKIP(return, "cannot determine own PT_INTERP");
+
+	ASSERT_EQ(copy_file(loader, LOADER_INTERP), 0);
+	ASSERT_EQ(artifact_path(src, sizeof(src), "binfmt_loader_payload"), 0);
+	ASSERT_EQ(copy_file(src, LOADER_PATH), 0);
+	ASSERT_EQ(patch_file(LOADER_PATH, EI_PAD, LOADER_MARKER,
+			     strlen(LOADER_MARKER)), 0);
+	ASSERT_EQ(artifact_path(self->obj, sizeof(self->obj),
+				"loader.bpf.o"), 0);
+
+	setenv("BINFMT_TEST_BINARY", LOADER_PATH, 1);
+	setenv("BINFMT_TEST_INTERP", LOADER_INTERP, 1);
+
+	ASSERT_EQ(bpf_case_start(&c, self->obj, "loader", "test_bpf_loader"), 0);
+	status = run_payload(LOADER_PATH);
+	bpf_case_stop(&c);
+	EXPECT_EQ(status, 0);
+
+	unsetenv("BINFMT_TEST_INTERP");
+	unlink(LOADER_PATH);
+	unlink(LOADER_INTERP);
+}
+
 TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/exec/binfmt_misc_common.h b/tools/testing/selftests/exec/binfmt_misc_common.h
index 854c7a6d34e1..a797577ecf29 100644
--- a/tools/testing/selftests/exec/binfmt_misc_common.h
+++ b/tools/testing/selftests/exec/binfmt_misc_common.h
@@ -3,19 +3,29 @@
 #ifndef __SELFTESTS_EXEC_BINFMT_MISC_COMMON_H
 #define __SELFTESTS_EXEC_BINFMT_MISC_COMMON_H
 
+#include <elf.h>
 #include <errno.h>
 #include <fcntl.h>
 #include <libgen.h>
 #include <limits.h>
+#include <link.h>
 #include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <sys/mount.h>
+#include <sys/types.h>
+#include <sys/wait.h>
 #include <unistd.h>
 
 #define BINFMT_DIR	"/proc/sys/fs/binfmt_misc"
 #define BINFMT_REG	BINFMT_DIR "/register"
 
+/* Marker the loader tests poke into the payload's e_ident padding. */
+#define LOADER_MARKER	"LDRTST"
+
+/* Exit status run_payload() reports when the exec was refused with ENOEXEC. */
+#define RUN_ENOEXEC	42
+
 static inline int copy_file(const char *src, const char *dst)
 {
 	char buf[4096];
@@ -95,4 +105,101 @@ static inline int artifact_path(char *out, size_t sz, const char *name)
 	return 0;
 }
 
+static inline int patch_file(const char *path, off_t off, const void *data, size_t len)
+{
+	ssize_t n;
+	int fd;
+
+	fd = open(path, O_WRONLY);
+	if (fd < 0)
+		return -1;
+	n = pwrite(fd, data, len, off);
+	close(fd);
+	return n == (ssize_t)len ? 0 : -1;
+}
+
+/*
+ * Run @path with the canonical payload argv and return its exit status, or
+ * RUN_ENOEXEC when the exec itself was refused as unhandled.
+ */
+static inline int run_payload(const char *path)
+{
+	int status;
+	pid_t pid;
+
+	pid = fork();
+	if (pid == 0) {
+		execl(path, "payload-argv0", "argone", "argtwo", (char *)NULL);
+		_exit(errno == ENOEXEC ? RUN_ENOEXEC : 126);
+	}
+	if (pid < 0 || waitpid(pid, &status, 0) != pid || !WIFEXITED(status))
+		return -1;
+	return WEXITSTATUS(status);
+}
+
+/* start_code and end_code are the 26th and 27th fields of /proc/pid/stat. */
+static inline int stat_codes(pid_t pid, unsigned long *start_code,
+			     unsigned long *end_code)
+{
+	char buf[4096], path[64], *p;
+	ssize_t n;
+	int fd, i;
+
+	snprintf(path, sizeof(path), "/proc/%d/stat", pid);
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return -1;
+	n = read(fd, buf, sizeof(buf) - 1);
+	close(fd);
+	if (n <= 0)
+		return -1;
+	buf[n] = '\0';
+
+	/* Skip "pid (comm)", then start_code is the 24th field after it. */
+	p = strrchr(buf, ')');
+	if (!p)
+		return -1;
+	p++;
+	for (i = 0; i < 23; i++) {
+		p = strchr(p + 1, ' ');
+		if (!p)
+			return -1;
+	}
+	if (sscanf(p, " %lu %lu", start_code, end_code) != 2)
+		return -1;
+	return 0;
+}
+
+/* Find the system loader through our own PT_INTERP. */
+static inline int find_loader(char *out, size_t sz)
+{
+	ElfW(Ehdr) eh;
+	ElfW(Phdr) ph;
+	int fd, i, ret = -1;
+
+	fd = open("/proc/self/exe", O_RDONLY);
+	if (fd < 0)
+		return -1;
+	if (pread(fd, &eh, sizeof(eh), 0) != sizeof(eh))
+		goto out;
+	for (i = 0; i < eh.e_phnum; i++) {
+		if (pread(fd, &ph, sizeof(ph),
+			  eh.e_phoff + i * eh.e_phentsize) != sizeof(ph))
+			goto out;
+		if (ph.p_type != PT_INTERP)
+			continue;
+		if (!ph.p_filesz || ph.p_filesz > sz)
+			goto out;
+		if (pread(fd, out, ph.p_filesz, ph.p_offset) !=
+		    (ssize_t)ph.p_filesz)
+			goto out;
+		out[ph.p_filesz - 1] = '\0';
+		ret = 0;
+		break;
+	}
+out:
+	close(fd);
+	return ret;
+}
+
 #endif /* __SELFTESTS_EXEC_BINFMT_MISC_COMMON_H */
diff --git a/tools/testing/selftests/exec/binfmt_misc_loader.c b/tools/testing/selftests/exec/binfmt_misc_loader.c
new file mode 100644
index 000000000000..fdf643a253a0
--- /dev/null
+++ b/tools/testing/selftests/exec/binfmt_misc_loader.c
@@ -0,0 +1,371 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test the 'L' (loader substitution) flag of binfmt_misc. A matched
+ * binary runs as the MAIN image - a fully native exec - with the
+ * registered interpreter substituted for its PT_INTERP. The payload
+ * (binfmt_loader_payload) asserts the native identity from inside.
+ *
+ * The substitute is a copy of the system loader found via our own
+ * PT_INTERP; magic matching pokes a marker into the ELF header's
+ * e_ident padding, which kernel and loader ignore.
+ *
+ * Needs root for the registration; no bpf toolchain involved.
+ */
+#define _GNU_SOURCE
+#include <elf.h>
+#include <link.h>
+#include <signal.h>
+#include <stddef.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/mman.h>
+#include <sys/ptrace.h>
+#include <sys/syscall.h>
+#include <sys/wait.h>
+
+#include "binfmt_misc_common.h"
+#include "kselftest_harness.h"
+
+#define ENTRY		"test_loader"
+#define INTERP_PATH	"/tmp/binfmt_loader_interp"
+#define MOVED_PATH	INTERP_PATH ".moved"
+#define TARGET_PATH	"/tmp/binfmt_loader_target.ldrtest"
+#define STATIC_PATH	"/tmp/binfmt_loader_static.ldrtest"
+#define FOREIGN_PATH	"/tmp/binfmt_loader_foreign.ldrtest"
+#define SCRIPT_PATH	"/tmp/binfmt_loader_script.ldrtest"
+#define M_RULE		":" ENTRY ":M:9:" LOADER_MARKER "::" INTERP_PATH ":L"
+#define E_RULE		":" ENTRY ":E::ldrtest::" INTERP_PATH ":L"
+#define FL_RULE		":" ENTRY ":E::ldrtest::" INTERP_PATH ":FL"
+
+/* Execute the binary from an inaccessible O_CLOEXEC memfd. */
+static int run_memfd(const char *path)
+{
+	int status;
+	pid_t pid;
+
+	pid = fork();
+	if (pid == 0) {
+		char *argv[] = { "payload-argv0", "argone", "argtwo", NULL };
+		char buf[4096];
+		int in, mfd;
+		ssize_t n;
+
+		mfd = memfd_create("loader-test", MFD_CLOEXEC);
+		in = open(path, O_RDONLY);
+		if (mfd < 0 || in < 0)
+			_exit(125);
+		while ((n = read(in, buf, sizeof(buf))) > 0)
+			if (write(mfd, buf, n) != n)
+				_exit(125);
+		close(in);
+		setenv("BINFMT_TEST_MEMFD", "1", 1);
+		unsetenv("BINFMT_TEST_BINARY");
+		syscall(SYS_execveat, mfd, "", argv, environ, AT_EMPTY_PATH);
+		_exit(126);
+	}
+	if (pid < 0 || waitpid(pid, &status, 0) != pid || !WIFEXITED(status))
+		return -1;
+	return WEXITSTATUS(status);
+}
+
+/*
+ * The differentiator against the transparent mode: at PTRACE_EVENT_EXEC
+ * the identity is already complete - exe, auxv and the stat code markers
+ * are mutually consistent with no window a debugger could observe.
+ */
+static int ptrace_probe(const char *target)
+{
+	unsigned long auxv[2 * 64], base = 0, entry = 0, at_flags = 0;
+	unsigned long start_code = 0, end_code = 0;
+	int status, fd, execfd_seen = 0, failed = 0;
+	char path[64], buf[PATH_MAX];
+	ssize_t n;
+	pid_t pid;
+	int i;
+
+	pid = fork();
+	if (pid == 0) {
+		ptrace(PTRACE_TRACEME, 0, NULL, NULL);
+		raise(SIGSTOP);
+		execl(target, "payload-argv0", "argone", "argtwo", (char *)NULL);
+		_exit(126);
+	}
+	if (pid < 0)
+		return -1;
+	if (waitpid(pid, &status, 0) != pid || !WIFSTOPPED(status))
+		goto fail_kill;
+	if (ptrace(PTRACE_SETOPTIONS, pid, NULL, (void *)PTRACE_O_TRACEEXEC))
+		goto fail_kill;
+	if (ptrace(PTRACE_CONT, pid, NULL, NULL))
+		goto fail_kill;
+	if (waitpid(pid, &status, 0) != pid || !WIFSTOPPED(status) ||
+	    status >> 8 != (SIGTRAP | (PTRACE_EVENT_EXEC << 8))) {
+		fprintf(stderr, "no exec stop (status %#x)\n", status);
+		goto fail_kill;
+	}
+
+	snprintf(path, sizeof(path), "/proc/%d/exe", pid);
+	n = readlink(path, buf, sizeof(buf) - 1);
+	if (n <= 0) {
+		failed = 1;
+	} else {
+		buf[n] = '\0';
+		if (strcmp(buf, target)) {
+			fprintf(stderr, "exe at exec stop: %s\n", buf);
+			failed = 1;
+		}
+	}
+
+	snprintf(path, sizeof(path), "/proc/%d/auxv", pid);
+	fd = open(path, O_RDONLY);
+	if (fd < 0) {
+		n = -1;
+	} else {
+		n = read(fd, auxv, sizeof(auxv));
+		close(fd);
+	}
+	if (n <= 0) {
+		failed = 1;
+		n = 0;
+	}
+	for (i = 0; i + 1 < (int)(n / sizeof(unsigned long)); i += 2) {
+		switch (auxv[i]) {
+		case AT_BASE:
+			base = auxv[i + 1];
+			break;
+		case AT_ENTRY:
+			entry = auxv[i + 1];
+			break;
+		case AT_FLAGS:
+			at_flags = auxv[i + 1];
+			break;
+		case AT_EXECFD:
+			execfd_seen = 1;
+			break;
+		}
+	}
+
+	if (stat_codes(pid, &start_code, &end_code))
+		failed = 1;
+
+	if (!base || execfd_seen || at_flags) {
+		fprintf(stderr, "auxv at exec stop not native\n");
+		failed = 1;
+	}
+	if (!start_code || entry < start_code || entry >= end_code) {
+		fprintf(stderr, "auxv/stat inconsistent at exec stop\n");
+		failed = 1;
+	}
+
+	if (ptrace(PTRACE_CONT, pid, NULL, NULL))
+		goto fail_kill;
+	if (waitpid(pid, &status, 0) != pid || !WIFEXITED(status) ||
+	    WEXITSTATUS(status))
+		failed = 1;
+	return failed ? -1 : 0;
+
+fail_kill:
+	kill(pid, SIGKILL);
+	waitpid(pid, &status, 0);
+	return -1;
+}
+
+FIXTURE(loader) {
+	bool have_static;
+};
+
+FIXTURE_SETUP(loader)
+{
+	unsigned short foreign_machine = 0xdead;
+	char src[PATH_MAX], loader[PATH_MAX];
+
+	if (getuid() != 0)
+		SKIP(return, "test must be run as root");
+	if (!binfmt_misc_available())
+		SKIP(return, "no binfmt_misc");
+	if (find_loader(loader, sizeof(loader)))
+		SKIP(return, "cannot determine own PT_INTERP");
+
+	ASSERT_EQ(copy_file(loader, INTERP_PATH), 0);
+
+	ASSERT_EQ(artifact_path(src, sizeof(src), "binfmt_loader_payload"), 0);
+	ASSERT_EQ(copy_file(src, TARGET_PATH), 0);
+	ASSERT_EQ(patch_file(TARGET_PATH, EI_PAD, LOADER_MARKER,
+			     strlen(LOADER_MARKER)), 0);
+
+	/* The same payload with a machine type this kernel cannot load. */
+	ASSERT_EQ(copy_file(src, FOREIGN_PATH), 0);
+	ASSERT_EQ(patch_file(FOREIGN_PATH, EI_PAD, LOADER_MARKER,
+			     strlen(LOADER_MARKER)), 0);
+	ASSERT_EQ(patch_file(FOREIGN_PATH, offsetof(ElfW(Ehdr), e_machine),
+			     &foreign_machine, sizeof(foreign_machine)), 0);
+
+	self->have_static =
+		artifact_path(src, sizeof(src), "binfmt_loader_payload_static") == 0 &&
+		copy_file(src, STATIC_PATH) == 0;
+
+	setenv("BINFMT_TEST_BINARY", TARGET_PATH, 1);
+	setenv("BINFMT_TEST_INTERP", INTERP_PATH, 1);
+
+	/* Everything below needs the flag; find out once. */
+	if (write_reg(E_RULE)) {
+		ASSERT_EQ(errno, EINVAL);
+		SKIP(return, "kernel without the 'L' flag");
+	}
+	unregister(ENTRY);
+}
+
+FIXTURE_TEARDOWN(loader)
+{
+	unregister(ENTRY);
+	if (access(MOVED_PATH, F_OK) == 0)
+		rename(MOVED_PATH, INTERP_PATH);
+	unlink(TARGET_PATH);
+	unlink(STATIC_PATH);
+	unlink(FOREIGN_PATH);
+	unlink(SCRIPT_PATH);
+	unlink(INTERP_PATH);
+}
+
+/* Grammar sanity check: the same entry without 'L' has to register. */
+TEST_F(loader, plain_entry_registers)
+{
+	ASSERT_EQ(write_reg(":" ENTRY ":E::ldrtest::" INTERP_PATH ":"), 0);
+}
+
+/* 'L' is a native exec: every classic-dispatch flag is rejected. */
+TEST_F(loader, rejects_classic_flags)
+{
+	static const char * const combos[] = { "LT", "LP", "LC", "LO" };
+	char rule[PATH_MAX];
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(combos); i++) {
+		int rc;
+
+		snprintf(rule, sizeof(rule),
+			 ":" ENTRY ":E::ldrtest::" INTERP_PATH ":%s", combos[i]);
+		rc = write_reg(rule);
+		EXPECT_EQ(rc, -1)
+			TH_LOG("'%s' was not rejected", combos[i]);
+		if (rc == 0) {
+			unregister(ENTRY);
+			continue;
+		}
+		EXPECT_EQ(errno, EINVAL);
+	}
+}
+
+/*
+ * Without 'F' the interpreter is opened when the binary is executed, so a
+ * relative path would be resolved against the caller's working directory.
+ */
+TEST_F(loader, rejects_relative_interpreter)
+{
+	static const char * const flags[] = { "L", "C" };
+	char rule[PATH_MAX];
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(flags); i++) {
+		int rc;
+
+		snprintf(rule, sizeof(rule),
+			 ":" ENTRY ":E::ldrtest::binfmt_loader_interp:%s",
+			 flags[i]);
+		rc = write_reg(rule);
+		EXPECT_EQ(rc, -1)
+			TH_LOG("'%s' accepted a relative interpreter", flags[i]);
+		if (rc == 0) {
+			unregister(ENTRY);
+			continue;
+		}
+		EXPECT_EQ(errno, EINVAL);
+	}
+}
+
+TEST_F(loader, extension_matched)
+{
+	ASSERT_EQ(write_reg(E_RULE), 0);
+	EXPECT_EQ(run_payload(TARGET_PATH), 0);
+}
+
+TEST_F(loader, magic_matched)
+{
+	ASSERT_EQ(write_reg(M_RULE), 0);
+	EXPECT_EQ(run_payload(TARGET_PATH), 0);
+}
+
+/*
+ * The differentiator against the transparent mode: at PTRACE_EVENT_EXEC the
+ * identity is already complete, with no window a debugger could observe.
+ */
+TEST_F(loader, exec_stop_consistency)
+{
+	ASSERT_EQ(write_reg(E_RULE), 0);
+	EXPECT_EQ(ptrace_probe(TARGET_PATH), 0);
+}
+
+/* A binary without PT_INTERP drops the override and runs natively. */
+TEST_F(loader, static_binary_runs_natively)
+{
+	if (!self->have_static)
+		SKIP(return, "no static payload built");
+
+	ASSERT_EQ(write_reg(E_RULE), 0);
+	setenv("BINFMT_TEST_BINARY", STATIC_PATH, 1);
+	setenv("BINFMT_TEST_STATIC", "1", 1);
+	EXPECT_EQ(run_payload(STATIC_PATH), 0);
+	unsetenv("BINFMT_TEST_STATIC");
+	setenv("BINFMT_TEST_BINARY", TARGET_PATH, 1);
+}
+
+/*
+ * A '#!' file that matched an 'L' entry is claimed by binfmt_script, which
+ * sits ahead of binfmt_elf. The substitute the entry staged has to be
+ * released when the interpreter replaces the file, not leaked.
+ */
+TEST_F(loader, script_claims_the_file)
+{
+	static const char script[] = "#!/bin/sh\nexit 0\n";
+	int fd;
+
+	fd = open(SCRIPT_PATH, O_WRONLY | O_CREAT | O_TRUNC, 0755);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(write(fd, script, sizeof(script) - 1),
+		  (ssize_t)sizeof(script) - 1);
+	ASSERT_EQ(close(fd), 0);
+
+	ASSERT_EQ(write_reg(E_RULE), 0);
+	EXPECT_EQ(run_payload(SCRIPT_PATH), 0);
+
+	/* A leaked substitute keeps its write denial on the loader. */
+	fd = open(INTERP_PATH, O_WRONLY);
+	EXPECT_GE(fd, 0)
+		TH_LOG("loader still write denied (errno %d)", errno);
+	if (fd >= 0)
+		close(fd);
+}
+
+/* Nothing needs the binary's path, so an inaccessible fd works. */
+TEST_F(loader, inaccessible_memfd)
+{
+	ASSERT_EQ(write_reg(M_RULE), 0);
+	EXPECT_EQ(run_memfd(TARGET_PATH), 0);
+}
+
+/* The whole exec of a wrong-arch binary fails as if unhandled. */
+TEST_F(loader, foreign_arch_enoexec)
+{
+	ASSERT_EQ(write_reg(M_RULE), 0);
+	EXPECT_EQ(run_payload(FOREIGN_PATH), RUN_ENOEXEC);
+}
+
+/* 'F' pre-opens the substitute, so it survives losing its path. */
+TEST_F(loader, fixed_interpreter_survives_rename)
+{
+	ASSERT_EQ(write_reg(FL_RULE), 0);
+	ASSERT_EQ(rename(INTERP_PATH, MOVED_PATH), 0);
+	EXPECT_EQ(run_payload(TARGET_PATH), 0);
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/exec/loader.bpf.c b/tools/testing/selftests/exec/loader.bpf.c
new file mode 100644
index 000000000000..108e51dd4961
--- /dev/null
+++ b/tools/testing/selftests/exec/loader.bpf.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * binfmt_misc_ops handler for the loader-substitution case: match the
+ * marker the harness poked into the payload's e_ident padding and ask for
+ * the selected interpreter to be substituted for the binary's PT_INTERP,
+ * so the binary itself runs as a fully native exec.
+ */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+#define EI_CLASS	4
+#define EI_PAD		9
+#define ELFCLASS64	2
+
+extern int bpf_binprm_set_interp(struct linux_binprm *bprm, const char *path,
+				 size_t path__sz) __ksym;
+extern int bpf_binprm_set_flags(struct linux_binprm *bprm,
+				enum bpf_binprm_flags flags) __ksym;
+
+SEC("struct_ops.s/match")
+bool BPF_PROG(loader_match, struct linux_binprm *bprm)
+{
+	if (bprm->buf[0] != 0x7f || bprm->buf[1] != 'E' ||
+	    bprm->buf[2] != 'L' || bprm->buf[3] != 'F' ||
+	    bprm->buf[EI_CLASS] != ELFCLASS64)
+		return false;
+
+	/* The harness marks the payload with "LDRTST" at EI_PAD. */
+	return bprm->buf[EI_PAD + 0] == 'L' && bprm->buf[EI_PAD + 1] == 'D' &&
+	       bprm->buf[EI_PAD + 2] == 'R' && bprm->buf[EI_PAD + 3] == 'T' &&
+	       bprm->buf[EI_PAD + 4] == 'S' && bprm->buf[EI_PAD + 5] == 'T';
+}
+
+SEC("struct_ops.s/load")
+int BPF_PROG(loader_load, struct linux_binprm *bprm)
+{
+	char interp[] = "/tmp/binfmt_loader_interp";
+	int err;
+
+	err = bpf_binprm_set_flags(bprm, BPF_BINPRM_LOADER);
+	if (err)
+		return err;
+
+	/* @path__sz includes the terminating NUL; 0 commits the selection. */
+	return bpf_binprm_set_interp(bprm, interp, sizeof(interp));
+}
+
+SEC(".struct_ops.link")
+struct binfmt_misc_ops loader = {
+	.match = (void *)loader_match,
+	.load = (void *)loader_load,
+	.name = "loader",
+};

-- 
2.53.0


