Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1644A606A32D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 20:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=jbypRHMI
Received: by kanga.kvack.org (Postfix)
	id 43F816B05B3; Fri,  6 Nov 2026 15:57:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F1666B05B4; Fri,  6 Nov 2026 15:57:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30B4B6B05B7; Fri,  6 Nov 2026 15:57:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9EF86B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:57:48 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2C2771A018A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:57:48 +0000 (UTC)
X-FDA: 85405905816.07.DC357C1
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5AF36C0002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:57:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=jbypRHMI;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf10.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793998666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QlZfCydMdiZJG6iKdjekNCpuqnBx+M7L7gaCG7InoYA=;
	b=ppEGHSk+3+pCgUGXo3ehTrcr7D6vLujNgIdPHxTIrmyiLAUuGV32Zqck3LdkkPvHCgo4nZ
	k/sAJorFjiEoEJRvmHEnclP4w5HNYrDn1EUMY54JXF7og+SqtqI5IdIxhmPE6dguEig6np
	PUvg2Ma5JgcOQyZpo1TPF/WRaeJs+x0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=jbypRHMI;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf10.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793998666;
	b=cVmIvlZzvJ6sk3R84VRnAknzPaR+TJM7Wh0yDkHYhOvJSD8Hb/hYa0RQ7AJxa7HrqT4Ai7
	HTeki1bBu/1agiu6e4led3CKSg1RdzUB1Gj8HbzJOj/ZUuUAgtgTBZgJpcuq2H1N/NXJ5B
	+gIZOJEKjxam+jEgBWSdhIyddltTe9I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=QlZfCydMdiZJG6iKdjekNCpuqnBx+M7L7gaCG7InoYA=; b=jbypRHMIVpVutCK8Nol
	Tan4TShI831g7CfN/Mo2Nd0qav2Ss/+ZlydhIURkJEda6ycqz0+j7ehj+V/J0iUiSO2t2y8kgVp7x
	P/KClbHbZgldSMh3T4vdfSXdYbEb0eY5X89BRKekg+p9RK176e3TWoP+YT8h5FkWf7VYDQI0ql3/h
	XTE3FdJLDFNT39N1jEOWl0sNRnWSeLzLvQQIaE/y8v1EZRs1DrqWQpCl4A4orQ1CuyJ4P0XYl2st7
	D4wiQhA3qnuv+LYa6GdVrBR00ugw+oNt6hMn3vcljrKVLt9H398TqLUU9c5itXVicCCKYa+qgTqA8
	loW3UjLHi9GpvQg==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xPQwJ-001xD7-0l;
	Fri, 06 Nov 2026 21:57:39 +0100
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Fri, 06 Nov 2026 21:57:38 +0100
Subject: [PATCH v2 2/2] selftests/exec: check the errors of an unloadable
 program header table
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-b4-prep-vstor-149847-binfmt_elf-enomem-load-elf-phdrs-v2-2-1c8b7b1dae5c@virtuozzo.com>
References: <20261106-b4-prep-vstor-149847-binfmt_elf-enomem-load-elf-phdrs-v2-0-1c8b7b1dae5c@virtuozzo.com>
In-Reply-To: <20261106-b4-prep-vstor-149847-binfmt_elf-enomem-load-elf-phdrs-v2-0-1c8b7b1dae5c@virtuozzo.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, Paul Burton <paulburton@kernel.org>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=13649;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=Z5LQpkRS8qi5xVqPX8O16A4VfgmR+BUDze/ifhqek3Q=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq7j9GdrJFhg85nhzAWbIE1poVOskcQev2YnF+Z
 Mf8HCQUNHmJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCau4/RgAKCRBRlgpH+WFc
 Kk1cD/9+mHZPI4GROV4icAfXOUXn0rO1zrLPRK9xOObLQi+AgwbMtW9DstFpKZ3BL7Sao+30vmn
 0H9AYo8+MqOqxYhY+KS+wUKhY9AI6ygViz7ObKj2dGyN7QNBw7NmAB+4U9yHi/Aab7WrBcSiCTt
 pyxhc32Ii98TEXPAO1MR/LD9HQvkcgwW71fYNYsNY51yp7Vqz9kRjTBPMgh9JIMN8QhHMB5q4WA
 ucc/UR+mZdqyXxNudiF54dJ1xp/eNLXcQ58smNCUdBoEP4VyGOZr3VTwXnlEXMhvMAVogJIKI+i
 1rMAW29rGwkoW99+is86Thdlm63YVEzpUMzBOwRLke1GdY++1mu/kboOhV3nrIS/emfQl1c8mVf
 MjF9/7IggZoc8PLQdMV2JmiUL3AA82wcBslkzJya4YTubBTZ/9QmGOydvThTSJuO2Rxq7R+dgMz
 cpcKwdRvI7Ccy0o79ikxP3MQJ8bBNlyrI+LJMwHViQhJ9YCZ1F1fJ/HqZVhLotmJ17wdSrp6HE6
 Uvw5MCMyqKf9muYG1Olv5K4QNIzfzOQRXQnXhyVZHT16NDkHmD9DKAW2Qh+lxV5ee26UGD50MgE
 eSEf+SctpXakaGLepHfQDIIowtcf9F6wd1l+qMzDUMyt3+h5TYL0q1C3dSVZtSuX5gjCyHCVzl0
 qR6OPxBk4OC3DLQ==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5AF36C0002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: qi6irt711jytzg1roxy6kxsocdk7fx7o
X-HE-Tag: 1793998666-623511
X-HE-Meta: U2FsdGVkX1+mbfuWI6Kgz+CJUcMTJMgyzgX00/DCxHt8o06ejw+MPR8ObAvMwv6OfzocGuVbC8o/VzlGT43fW+Y6owGeOuV+rHqqcWhZtgdqDoomi9+dCNPMbdOMshKxfwO8FD0A233esTDzcUoTTQdNIbyS+wziom0PWwqTS0m0zWjU7ay9wNfMq73CvV22Lr2pOrAKEukk0/B6c4iRFY8nxBncDm1Qw2OZ7w/7GEYMRUCfBd8U6XatHvc1/xNRy4eU2CSUnEYr7aD6Y1SnwILZLOiArnuR1MKdRiEthL0C48gNkjfcxi6mABD+4rEUa8Xvg13whhnfFE8OgW+q/7TEFDTcwKl0ojDhq2b3yZ94ZYVkah0CXA18WmxPmjBtMLSVBqehN7pDoibeN0iHSrZd5yO263ZXdlvAVPTMKHv3OL3x3qvIXYAPEgEfJNWb6D6GQlPu5i46dOpfmt1zxJ723He61KOmf2mWzRXLDQflFHVO0ycaT+M5alo1jCjmwktu0Sig44Dw/PCXyknSSew2qLJFZQvTwNyz5qhoMFIrqr5jPjDcnOUKCdn9F31XPh13e/0RlT7TDVYIwnTCu6Ka0dKvXoZcvxla+PywODlpwlkgZ9JSNld69+wF1Kmys/mEafU+6Z3iaf+o1HJJ5KMS63AxhI/UIQ+ZpVp0zSHALVM/ml52i8VxUZyLBnpwjc7duTSuasQ2KA43bWWwmwj+QEPCF+Ig7B6GMSBl8r5r67iUFG1SKl8ETOTvAfeozQCzK2ue3X/ewzThFkmPCojldVWcklz/R7jG9lRqAgXFMsHhX+25XMD30GrTcDxMS/MopL6LXdYbfVX1Shd23H8i79SQ/tHFqBKF75mENXKT3aNCz97O1UOwl5QDBqRXdYMF/KM8HpephW1cSfB/jAJ8GCYbphg2eakuiN9ycHoavkKFN3WqoTK05GrT74uyeT3B9kcaIdYK2FsW7aP
 2kxyEm/N
 goPTmcR9O/+XMRuTyPZsT9Vh9+SBj76CUIU/f+KR/UabZQult+hOaxLMD9O/LR9iyKt5E6T9Enkkcud5wMZWRR2P+ZT9pHymo7hNT8cP2PFz8GKPdztyWuP913+o1mMuuAE1dnWPZH3gkBZHslcS/7ONc6NJPKkDAKqj/TGAvGLnNzC6oKpaBadI9zQw5wx5CCwI5c1nXXd+DX2OrChOOrBNFXGH1UNxfY4vuBvZf8MrQDNMpD9dhs7HwGM3uM5yJaLfGOOgHQhF072Qr2Yks//trog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

load_elf_binary() reports a program header table that it cannot use as
-ENOEXEC, and as -ELIBBAD when the table is the interpreter's. A failed
allocation of the table says nothing about the file and has to come
back as -ENOMEM.

The test builds ELF files whose table is malformed, placed past the end
of the file or cut short, both as the executable and as the PT_INTERP of
one, and checks for those two errors. As root, on a kernel with fault
injection, it then fails each fault injection point of an execve() in
turn and checks that none of them comes back as -ENOEXEC or -ELIBBAD;
without root or fault injection that case is skipped.

Fault injection here means CONFIG_FAULT_INJECTION, CONFIG_FAILSLAB and
CONFIG_FAULT_INJECTION_DEBUG_FS.

Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 tools/testing/selftests/exec/.gitignore       |   2 +
 tools/testing/selftests/exec/Makefile         |   4 +
 tools/testing/selftests/exec/load_elf_phdrs.c | 399 ++++++++++++++++++++++++++
 3 files changed, 405 insertions(+)

diff --git a/tools/testing/selftests/exec/.gitignore b/tools/testing/selftests/exec/.gitignore
index e42ecd4c908d1..3736834117f7c 100644
--- a/tools/testing/selftests/exec/.gitignore
+++ b/tools/testing/selftests/exec/.gitignore
@@ -11,9 +11,11 @@ non-regular
 null-argv
 /check-exec
 /false
+/false-dynamic
 /inc
 /load_address.*
 !load_address.c
+/load_elf_phdrs
 /recursion-depth
 /set-exec
 xxxxxxxx*
diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index 91decfa8ff2c1..607f5ecd9d76c 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -20,6 +20,8 @@ TEST_FILES := Makefile
 TEST_GEN_PROGS += recursion-depth
 TEST_GEN_PROGS += null-argv
 TEST_GEN_PROGS += check-exec
+TEST_GEN_PROGS += load_elf_phdrs
+TEST_GEN_PROGS_EXTENDED += false-dynamic
 
 # binfmt_misc must not be reachable as an exec source or as a stacking layer,
 # or an 'F' entry can pin the instance that owns it. Unprivileged, no bpf.
@@ -98,6 +100,8 @@ $(OUTPUT)/load_address.static.0x%: load_address.c
 		-fPIE -static-pie $< -o $@
 $(OUTPUT)/false: false.c
 	$(CC) $(CFLAGS) $(LDFLAGS) -static $< -o $@
+$(OUTPUT)/false-dynamic: false.c
+	$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@
 $(OUTPUT)/inc: $(CHECK_EXEC_SAMPLES)/inc.c
 	$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@
 $(OUTPUT)/set-exec: $(CHECK_EXEC_SAMPLES)/set-exec.c
diff --git a/tools/testing/selftests/exec/load_elf_phdrs.c b/tools/testing/selftests/exec/load_elf_phdrs.c
new file mode 100644
index 0000000000000..7d888a3e9d7f4
--- /dev/null
+++ b/tools/testing/selftests/exec/load_elf_phdrs.c
@@ -0,0 +1,399 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * execve() of an ELF file whose program header table cannot be loaded.
+ *
+ * A malformed, misplaced or truncated table fails with ENOEXEC, and with
+ * ELIBBAD when it is the interpreter's. A failed allocation of the table is
+ * reported as ENOMEM, never as one of those two: checked as root with
+ * CONFIG_FAULT_INJECTION, CONFIG_FAILSLAB and CONFIG_FAULT_INJECTION_DEBUG_FS
+ * (so CONFIG_DEBUG_FS), skipped without them.
+ */
+#define _GNU_SOURCE
+#include <elf.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <link.h>
+#include <linux/magic.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mount.h>
+#include <sys/resource.h>
+#include <sys/statvfs.h>
+#include <sys/vfs.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "kselftest_harness.h"
+
+/* The test itself could not fork or arm the fault, as opposed to an errno. */
+#define SETUP_FAILED	(-2)
+
+enum table {
+	BAD_PHENTSIZE,
+	NO_PHDRS,
+	TOO_BIG,
+	HUGE_PHOFF,	/* on 32-bit only past the end of the file */
+	PAST_EOF,
+	TRUNCATED,
+};
+
+static int write_file(const char *path, const void *buf, size_t len)
+{
+	int fd = open(path, O_WRONLY | O_CREAT | O_TRUNC | O_CLOEXEC, 0755);
+	ssize_t ret;
+
+	if (fd < 0)
+		return -1;
+	ret = write(fd, buf, len);
+	close(fd);
+	return ret == (ssize_t)len ? 0 : -1;
+}
+
+static int read_ehdr(ElfW(Ehdr) *eh)
+{
+	int fd = open("/proc/self/exe", O_RDONLY | O_CLOEXEC);
+	ssize_t ret;
+
+	if (fd < 0)
+		return -1;
+	ret = read(fd, eh, sizeof(*eh));
+	close(fd);
+	return ret == sizeof(*eh) ? 0 : -1;
+}
+
+/* An ELF header for this machine with one program header, then that header. */
+static size_t one_phdr_image(char *buf, const ElfW(Phdr) *ph)
+{
+	ElfW(Ehdr) eh;
+
+	if (read_ehdr(&eh))
+		return 0;
+	eh.e_phoff = sizeof(eh);
+	eh.e_phentsize = sizeof(*ph);
+	eh.e_phnum = 1;
+	eh.e_shoff = 0;
+	eh.e_shnum = 0;
+	eh.e_shstrndx = 0;
+	memcpy(buf, &eh, sizeof(eh));
+	memcpy(buf + sizeof(eh), ph, sizeof(*ph));
+	return sizeof(eh) + sizeof(*ph);
+}
+
+static size_t bad_table_image(char *buf, enum table table)
+{
+	ElfW(Phdr) ph = { .p_type = PT_NULL };
+	ElfW(Ehdr) *eh = (ElfW(Ehdr) *)buf;
+	size_t len = one_phdr_image(buf, &ph);
+
+	if (!len)
+		return 0;
+	switch (table) {
+	case BAD_PHENTSIZE:
+		eh->e_phentsize--;
+		break;
+	case NO_PHDRS:
+		eh->e_phnum = 0;
+		break;
+	case TOO_BIG:
+		eh->e_phnum = 65536 / sizeof(ph) + 1;
+		break;
+	case HUGE_PHOFF:
+		eh->e_phoff = (ElfW(Off))1 << (8 * sizeof(eh->e_phoff) - 1);
+		break;
+	case PAST_EOF:
+		eh->e_phoff = 1 << 20;
+		break;
+	case TRUNCATED:
+		eh->e_phnum = 2;
+		break;
+	}
+	return len;
+}
+
+/* An executable whose PT_INTERP names @interp. */
+static size_t interp_image(char *buf, const char *interp)
+{
+	ElfW(Phdr) ph = {
+		.p_type = PT_INTERP,
+		.p_offset = sizeof(ElfW(Ehdr)) + sizeof(ElfW(Phdr)),
+		.p_filesz = strlen(interp) + 1,
+	};
+	size_t len = one_phdr_image(buf, &ph);
+
+	if (!len)
+		return 0;
+	memcpy(buf + len, interp, ph.p_filesz);
+	return len + ph.p_filesz;
+}
+
+/* Returns the errno of a failed execve(), 0 if it did not return. */
+static int exec_errno(const char *path, char *const argv[])
+{
+	char *const envp[] = { NULL };
+	int pipefd[2], err = 0, status;
+	pid_t pid;
+
+	if (pipe2(pipefd, O_CLOEXEC))
+		return SETUP_FAILED;
+	pid = fork();
+	if (pid < 0) {
+		close(pipefd[0]);
+		close(pipefd[1]);
+		return SETUP_FAILED;
+	}
+	if (!pid) {
+		execve(path, argv, envp);
+		err = errno;
+		write(pipefd[1], &err, sizeof(err));
+		_exit(1);
+	}
+	close(pipefd[1]);
+	if (read(pipefd[0], &err, sizeof(err)) != sizeof(err))
+		err = 0;
+	close(pipefd[0]);
+	waitpid(pid, &status, 0);
+	return err;
+}
+
+FIXTURE(table) {
+	char dir[64];
+	char exe[96];
+	char interp[96];
+};
+
+FIXTURE_VARIANT(table) {
+	enum table table;
+	bool interp;
+};
+
+FIXTURE_VARIANT_ADD(table, bad_phentsize) { .table = BAD_PHENTSIZE };
+FIXTURE_VARIANT_ADD(table, no_phdrs) { .table = NO_PHDRS };
+FIXTURE_VARIANT_ADD(table, too_big) { .table = TOO_BIG };
+FIXTURE_VARIANT_ADD(table, huge_phoff) { .table = HUGE_PHOFF };
+FIXTURE_VARIANT_ADD(table, past_eof) { .table = PAST_EOF };
+FIXTURE_VARIANT_ADD(table, truncated) { .table = TRUNCATED };
+FIXTURE_VARIANT_ADD(table, interp_bad_phentsize) { .table = BAD_PHENTSIZE, .interp = true };
+FIXTURE_VARIANT_ADD(table, interp_no_phdrs) { .table = NO_PHDRS, .interp = true };
+FIXTURE_VARIANT_ADD(table, interp_too_big) { .table = TOO_BIG, .interp = true };
+FIXTURE_VARIANT_ADD(table, interp_huge_phoff) { .table = HUGE_PHOFF, .interp = true };
+FIXTURE_VARIANT_ADD(table, interp_past_eof) { .table = PAST_EOF, .interp = true };
+FIXTURE_VARIANT_ADD(table, interp_truncated) { .table = TRUNCATED, .interp = true };
+
+static void remove_files(FIXTURE_DATA(table) *self)
+{
+	unlink(self->exe);
+	unlink(self->interp);
+	rmdir(self->dir);
+}
+
+FIXTURE_SETUP(table)
+{
+	char bad[sizeof(ElfW(Ehdr)) + sizeof(ElfW(Phdr))];
+	char exe[sizeof(bad) + sizeof(self->interp)];
+	size_t bad_len, exe_len;
+	struct statvfs st;
+	int ret;
+
+	ASSERT_EQ(0, statvfs("/tmp", &st));
+	if (st.f_flag & ST_NOEXEC)
+		SKIP(return, "/tmp is on a noexec mount");
+	bad_len = bad_table_image(bad, variant->table);
+	ASSERT_NE(0, bad_len);
+	strcpy(self->dir, "/tmp/load_elf_phdrs.XXXXXX");
+	ASSERT_NE(NULL, mkdtemp(self->dir));
+	snprintf(self->exe, sizeof(self->exe), "%s/exe", self->dir);
+	snprintf(self->interp, sizeof(self->interp), "%s/interp", self->dir);
+
+	if (!variant->interp) {
+		ret = write_file(self->exe, bad, bad_len);
+	} else {
+		exe_len = interp_image(exe, self->interp);
+		ret = !exe_len || write_file(self->interp, bad, bad_len) ||
+		      write_file(self->exe, exe, exe_len);
+	}
+	if (ret)
+		remove_files(self);
+	ASSERT_EQ(0, ret);
+}
+
+FIXTURE_TEARDOWN(table)
+{
+	remove_files(self);
+}
+
+TEST_F(table, execve)
+{
+	char *const argv[] = { self->exe, NULL };
+	int expect = variant->interp ? ELIBBAD : ENOEXEC;
+	int err = exec_errno(self->exe, argv);
+
+	ASSERT_NE(SETUP_FAILED, err);
+	EXPECT_EQ(expect, err) {
+		TH_LOG("execve(): %s, expected %s", strerror(err), strerror(expect));
+	}
+}
+
+#define DEBUGFS		"/sys/kernel/debug"
+#define IGNORE_GFP_WAIT	DEBUGFS "/failslab/ignore-gfp-wait"
+#define VERBOSE		DEBUGFS "/failslab/verbose"
+
+static int read_str(const char *path, char *buf, size_t size)
+{
+	int fd = open(path, O_RDONLY | O_CLOEXEC);
+	ssize_t ret;
+
+	if (fd < 0)
+		return -1;
+	ret = read(fd, buf, size - 1);
+	close(fd);
+	if (ret <= 0)
+		return -1;
+	buf[ret] = '\0';
+	return 0;
+}
+
+static int write_str(const char *path, const char *str)
+{
+	return write_file(path, str, strlen(str));
+}
+
+/* errno of execve() with fault @nth injected; 0: the new image exited, -1: it died */
+static int exec_fail_nth(const char *path, unsigned int nth)
+{
+	char *const argv[] = { (char *)path, NULL };
+	char *const envp[] = { NULL };
+	int pipefd[2], err, status;
+	char buf[16];
+	pid_t pid;
+
+	if (pipe2(pipefd, O_CLOEXEC))
+		return SETUP_FAILED;
+	pid = fork();
+	if (pid < 0) {
+		close(pipefd[0]);
+		close(pipefd[1]);
+		return SETUP_FAILED;
+	}
+	if (!pid) {
+		struct rlimit no_core = { 0, 0 };
+		int null = open("/dev/null", O_WRONLY | O_CLOEXEC);
+		int fd;
+
+		/* Faults past the point of no return kill the new image. */
+		setrlimit(RLIMIT_CORE, &no_core);
+		if (null >= 0) {
+			dup2(null, STDOUT_FILENO);
+			dup2(null, STDERR_FILENO);
+		}
+		fd = open("/proc/thread-self/fail-nth", O_WRONLY | O_CLOEXEC);
+		if (fd < 0 || write(fd, buf, sprintf(buf, "%u", nth)) < 0)
+			_exit(2);
+		execve(path, argv, envp);
+		err = errno;
+		write(fd, "0", 1);
+		write(pipefd[1], &err, sizeof(err));
+		_exit(1);
+	}
+	close(pipefd[1]);
+	if (read(pipefd[0], &err, sizeof(err)) != sizeof(err))
+		err = 0;
+	close(pipefd[0]);
+	if (waitpid(pid, &status, 0) != pid ||
+	    (WIFEXITED(status) && WEXITSTATUS(status) == 2))
+		return SETUP_FAILED;
+	if (err)
+		return err;
+	return WIFEXITED(status) && WEXITSTATUS(status) == 1 ? 0 : -1;
+}
+
+FIXTURE(alloc) {
+	char ignore_gfp_wait[8];
+	char verbose[8];
+	bool mounted;
+};
+
+static void failslab_restore(FIXTURE_DATA(alloc) *self)
+{
+	write_str(IGNORE_GFP_WAIT, self->ignore_gfp_wait);
+	write_str(VERBOSE, self->verbose);
+	if (self->mounted)
+		umount(DEBUGFS);
+}
+
+FIXTURE_SETUP(alloc)
+{
+	struct statfs st;
+	int ret;
+
+	self->mounted = false;
+	if (geteuid())
+		SKIP(return, "needs root for the failslab settings");
+	if (access("/proc/thread-self/fail-nth", W_OK))
+		SKIP(return, "no fault injection (CONFIG_FAULT_INJECTION)");
+	if (statfs(DEBUGFS, &st) || st.f_type != DEBUGFS_MAGIC)
+		self->mounted = !mount("debugfs", DEBUGFS, "debugfs", 0, NULL);
+	if (read_str(IGNORE_GFP_WAIT, self->ignore_gfp_wait, sizeof(self->ignore_gfp_wait)) ||
+	    read_str(VERBOSE, self->verbose, sizeof(self->verbose))) {
+		if (self->mounted)
+			umount(DEBUGFS);
+		SKIP(return, "no debugfs or no failslab (CONFIG_FAULT_INJECTION_DEBUG_FS)");
+	}
+	/* The allocations of an execve() may sleep, and a splat for each is noise. */
+	ret = write_str(IGNORE_GFP_WAIT, "N") ?: write_str(VERBOSE, "0");
+	if (ret) {
+		ret = errno;
+		failslab_restore(self);
+		SKIP(return, "cannot set up failslab: %s", strerror(ret));
+	}
+}
+
+FIXTURE_TEARDOWN(alloc)
+{
+	failslab_restore(self);
+}
+
+TEST_F(alloc, no_enoexec)
+{
+	unsigned int nth, clean = 0, failed = 0, wrong = 0;
+	char path[PATH_MAX];
+	ssize_t len;
+	int err;
+
+	/* Dynamically linked, so that the interpreter's table is allocated too. */
+	len = readlink("/proc/self/exe", path, sizeof(path) - sizeof("false-dynamic"));
+	ASSERT_LT(0, len);
+	path[len] = '\0';
+	strcpy(strrchr(path, '/') + 1, "false-dynamic");
+	if (access(path, X_OK))
+		SKIP(return, "false-dynamic not found next to the test");
+
+	/* Done once the faults to inject lie past the whole exec and exit. */
+	for (nth = 1; clean < 50 && nth < 100000; nth++) {
+		err = exec_fail_nth(path, nth);
+		ASSERT_NE(SETUP_FAILED, err) {
+			TH_LOG("fail-nth %u: fork or fail-nth write failed", nth);
+		}
+		if (!err) {
+			clean++;
+			continue;
+		}
+		clean = 0;
+		if (err < 0)
+			continue;
+		failed++;
+		if (err == ENOEXEC || err == ELIBBAD) {
+			wrong++;
+			TH_LOG("fail-nth %u: execve(): %s", nth, strerror(err));
+		}
+	}
+	ASSERT_EQ(50, clean) {
+		TH_LOG("no clean exec after fail-nth %u", nth);
+	}
+	if (!failed)
+		SKIP(return, "no execve() failed: failslab did not inject");
+	EXPECT_EQ(0, wrong);
+}
+
+TEST_HARNESS_MAIN

-- 
2.43.0


