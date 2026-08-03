Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 826F4C55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 12:54:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA6086B00A9; Mon,  3 Aug 2026 08:54:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F83E6B00AA; Mon,  3 Aug 2026 08:54:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BFDB6B00AB; Mon,  3 Aug 2026 08:54:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3AAD76B00A9
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:54:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E1182C06E1
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:15:30 +0000 (UTC)
X-FDA: 85059853620.23.725B811
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0BE5B1C000C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:15:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TkekdQCz;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785759329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=imchk58sWwG609wF4sWviopwLcUSeECBG8nRog6W56I=;
	b=RoLIR6k70UDtrVpRpfXCiV7dBmphA/jDZHoh/skRA9z8vycwHAJx21jNKCBRApgIrHMIcx
	TqvusoGg9oyjlo7o+YZEuLpDQh146tn4nJkjJVmWJoSM8WHOv4rSzrhORup+BdczkT3vNq
	zKGE8IKYL8xM4b8xLjpazHeoTwEP+uk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785759329;
	b=W/IQh4orEmjq/QBC/D+LlbH7omQ1HkfyldmcAkrhNABGY/g1Qota/tEKucKqpgms0XUufp
	H126asfGm+eEm+AaDJUenUwuHJWIlBT5T/5O4d87ojVBcghMdqa6av5/qkIWH/qeT0V6f4
	L8ypUxwrgvzgtXHyygeGkjmzywaMQPY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TkekdQCz;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A8264359A;
	Mon,  3 Aug 2026 12:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F73A1F00A3D;
	Mon,  3 Aug 2026 12:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785759328;
	bh=imchk58sWwG609wF4sWviopwLcUSeECBG8nRog6W56I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TkekdQCz6F42VNW5kcnVPdqnV8E9Dj0r/zxHqrcZzn6Laj+ioypmrHvSIFkIEbC/U
	 0/JvflWrwt62FApPeV0NGlg76Xa6MrHvRYOJsBgeDr8ugbzGPs9rB5QqrOFoK7AGcA
	 ENtUsjShnoiQfCYGXtut/IumVj11vGPkJr1lEbWLmS0QrnSwsP032G9heD849XoxR9
	 wtsheISpKpmwOq4C1Ulf9V0+vWXCZf0j1+MusQ8/9hQJ3iBOcgd1KGFXP0E3YKrrp4
	 cbmgjCDtfj4mJ7eV33oMQwW1btql/dcNPZtGmzijwZYnJJ1e7vihERV1jG96xYwmMh
	 xRyn6KyhgOeMA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 03 Aug 2026 14:15:01 +0200
Subject: [PATCH 2/3] selftests/exec: test the pre-opened interpreter limit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260803-work-binfmt_misc-interplimit-v1-2-4a2435500bd9@kernel.org>
References: <20260803-work-binfmt_misc-interplimit-v1-0-4a2435500bd9@kernel.org>
In-Reply-To: <20260803-work-binfmt_misc-interplimit-v1-0-4a2435500bd9@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com, 
 mail@johnericson.me, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-f2f85
X-Developer-Signature: v=1; a=openpgp-sha256; l=12952; i=brauner@kernel.org;
 h=from:subject:message-id; bh=nSNdnjq7YkG/2XIcevKtHnOJSe05oVkWuRmNilxKg40=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQVtIVZy1YHrr45c7Zb9vudB1vF/7Fme8Tx/N7j6NnH+
 mThpRXuHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABOx52BkePE6PveRD5PXNYXP
 Rd1GW/52tnB0N05f1bu6oTu/7eKH14wMm7bs4xWt/rdy4pWPsheeuzAtMp3L1fVURXSDnnrrq7Z
 TrAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0BE5B1C000C
X-Stat-Signature: y4zc6nh5hy6giyrjangscfe9pog94j9a
X-HE-Tag: 1785759328-763451
X-HE-Meta: U2FsdGVkX1+AaSxaVChit8Ah6oF0HjEkb0Coizw3u3lhuPXEgNIYTP1xHa7BaGqTW7q8ohCBw/J5b5JEVzqlDn29eCb2rqntnxwXQ/CN1mEZp38GW0hQlhonHq0ay7mICm8W7I8CaFPaZFhaBrzxVhOyOXWMXQv86EsepjaIB1xVsvUZcb4sCAyLl38hFGWZanKZyzzBqqxrgt7v6dyuq29hv7B00CxjaxogL8BIoSYLwrWVLJmMOhogx8zO+T6GGW4Ygav27AdW4oloy3x5p2HhMBHhXGcSNFKGtXnzZ9pBxClD6UCxTH9qyqONFtrEprvl8mg5n8TD7ItBHfcjl+iGyaKp+Ov/BEr01VWYzoHG9kPOgTti5/D9wTYgFdFWmzElgTnUPRQyc4YjVHXG2d8DLHnlT4q1cM4xNWdqU0ZZjG1j1Ouj4jObjQr8CaxC0INSkiAdkTNmDQY0z68jydE07haZZjbp6LBMXWZXoznTBIb3dNMCuyo9dapxytQ/R8/9ai4tPWqPJhDgr7mU//cTtjK3BzVrHD5funoVVOeTaPH5lk6V9zuKsu+rG2Bb77B8rTvKtAT3PPJI25n7nppVB9MyVw/RYRHCHWnYe5qhVUbnUySP+e+d0CdmYM3iOr7ecj0cPTa9aiAycgoOXgDwCPzE/aL+emmHuRV7q2CnjkDjPu8DQ/K+ovaKQAs71dK3EYOH97TZoM14n5fYyUpcSgawtAfp5IAOSJw03nJfghxFmeee1AN0xNbWcN0SfjFmFuHCIETW4tilu1ZoxEqi6qd5lg/yyvfkBei+hSkDWcNQdyc19xAa6jOx4hOxX3nQYGwVGfSE43X8Yxpmo7rf6zOK1X53Fo57WkLh9lh7RGqbLwgo++fIH3h3h8qDCqsLXNmh2dqxNn5xTMdn80x5Wrhkh7xm1QQbYZ1Hb7cnlY/W+CmyzYtzXg3XmgAcX7pAFYjTUkywhcF8D+4
 tlKNoTrg
 29qjZSFLTGhkkeoCsbny94TZsgVVxZKOjM7MQze8kNdZsJsG28hOMmBKj/R1tn/NjCUzXVVfxuHoAcHbUh2auyyeucprljV0Opd+GzT/ndZNlo84ykfS0N7OUEvYdbqgquhiAEUpXwzFDoedw9cBEsq7Z6MR3Iomu8vgo8gYVEPZokqfIHE0hf9r9KPGdxt759ROhmDipM9auexnJYliNQLTKT95ChGORhkJn+j7noxxn+n/7rH3LjiaVLwCOf8V9rmFW/SAvkIIydsIAaOo9Wl6N16NKdji8oFv1bRk41R0wafsObsJa/2xz1PB0sxZfhpsd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

- an interpreter opened at registration is charged
- an interpreter a 'B' entry binds is charged too
- an entry that opens none is not
- removing an entry gives the charge back
- a nested user namespace cannot buy itself budget by raising its own limit

Skips where the sysctl or binfmt_misc is missing. The 'B' case lives in
binfmt_misc_bpf.c because binding needs a handler. It binds from a child
in a user namespace of its own, through the fd the child inherited, so
the charge lands on the child while the interpreter is still opened with
the entry file's credentials, and nothing outside the child sees a
changed limit.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/exec/.gitignore            |   1 +
 tools/testing/selftests/exec/Makefile              |   6 +
 tools/testing/selftests/exec/binfmt_misc_bpf.c     |  70 +++++++
 .../selftests/exec/binfmt_misc_interplimit.c       | 232 +++++++++++++++++++++
 4 files changed, 309 insertions(+)

diff --git a/tools/testing/selftests/exec/.gitignore b/tools/testing/selftests/exec/.gitignore
index fbbb1600ddb9..e42ecd4c908d 100644
--- a/tools/testing/selftests/exec/.gitignore
+++ b/tools/testing/selftests/exec/.gitignore
@@ -20,6 +20,7 @@ xxxxxxxx*
 pipe
 S_I*.test
 binfmt_misc_bpf
+binfmt_misc_interplimit
 binfmt_bpf_interp
 binfmt_bpf_app
 binfmt_misc_transparent
diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index 410c93606a0c..b640af8f02b5 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -25,6 +25,10 @@ TEST_GEN_PROGS += check-exec
 # or an 'F' entry can pin the instance that owns it. Unprivileged, no bpf.
 TEST_GEN_PROGS += binfmt_misc_selfpin
 
+# The interpreters an 'F' or 'B' entry pre-opens are charged against
+# UCOUNT_BINFMT_MISC_INTERPRETERS. Unprivileged, no bpf.
+TEST_GEN_PROGS += binfmt_misc_interplimit
+
 # 'D' (register disabled) binfmt_misc test: an entry that exists but does
 # not dispatch until it is enabled. Static magic entry, no bpf toolchain.
 TEST_GEN_PROGS += binfmt_misc_disabled
@@ -104,6 +108,8 @@ $(OUTPUT)/script-noexec.inc: $(CHECK_EXEC_SAMPLES)/script-noexec.inc
 # CFLAGS for every program in this directory.
 $(OUTPUT)/binfmt_misc_selfpin: CFLAGS += $(TOOLS_INCLUDES)
 $(OUTPUT)/binfmt_misc_selfpin: ../filesystems/utils.c
+$(OUTPUT)/binfmt_misc_interplimit: CFLAGS += $(TOOLS_INCLUDES)
+$(OUTPUT)/binfmt_misc_interplimit: ../filesystems/utils.c
 
 # --- binfmt_misc bpf ('B') handler test ---------------------------------
 # The struct_ops bpf objects are compiled against the running kernel's BTF.
diff --git a/tools/testing/selftests/exec/binfmt_misc_bpf.c b/tools/testing/selftests/exec/binfmt_misc_bpf.c
index 2c7b63075f1d..b2a4518901b0 100644
--- a/tools/testing/selftests/exec/binfmt_misc_bpf.c
+++ b/tools/testing/selftests/exec/binfmt_misc_bpf.c
@@ -38,6 +38,7 @@
 #define _GNU_SOURCE
 #include <elf.h>
 #include <limits.h>
+#include <sched.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -65,6 +66,9 @@
 #define BIND_RISCV_PATH	"/tmp/binfmt_bind_riscv"
 #define BIND_EXPECT	"BIND_RAN "
 #define BIND_MAX	100
+#define INTERP_LIMIT	"/proc/sys/user/max_binfmt_misc_interpreters"
+/* Exit status of the binding child when it cannot set up a budget of its own. */
+#define BIND_NO_BUDGET	200
 
 /* A minimal 64-bit little-endian ELF header, padded to the read size. */
 static int create_fake_elf(const char *path, unsigned short machine)
@@ -378,6 +382,57 @@ static int entry_bind(const char *entry, const char *name, const char *path)
 	return entry_command(entry, cmd);
 }
 
+/* Set the interpreter budget of this namespace. */
+static int write_interp_limit(const char *val)
+{
+	ssize_t n;
+	int fd;
+
+	fd = open(INTERP_LIMIT, O_WRONLY | O_CLOEXEC);
+	if (fd < 0)
+		return -1;
+	n = write(fd, val, strlen(val));
+	close(fd);
+	return n < 0 ? -1 : 0;
+}
+
+/*
+ * The errno a bind is refused with when the writer is a child that has spent
+ * the budget of a user namespace of its own, 0 if it succeeded and -1 if the
+ * child could not set itself up. The fd is opened here and inherited, so the
+ * interpreter is still opened with this process's credentials.
+ */
+static int bind_out_of_budget(const char *entry, const char *name,
+			      const char *path)
+{
+	char cmd[PATH_MAX], file[PATH_MAX];
+	int fd, status, retval;
+	pid_t pid;
+
+	snprintf(file, sizeof(file), BINFMT_DIR "/%s", entry);
+	snprintf(cmd, sizeof(cmd), "+%s %s\n", name, path);
+
+	fd = open(file, O_WRONLY | O_CLOEXEC);
+	if (fd < 0)
+		return -1;
+
+	pid = fork();
+	if (pid == 0) {
+		ssize_t n;
+
+		/* A namespace of its own, with nothing left in it to spend. */
+		if (unshare(CLONE_NEWUSER) || write_interp_limit("0"))
+			_exit(BIND_NO_BUDGET);
+		n = write(fd, cmd, strlen(cmd));
+		_exit(n < 0 ? errno : 0);
+	}
+	close(fd);
+	if (pid < 0 || waitpid(pid, &status, 0) != pid || !WIFEXITED(status))
+		return -1;
+	retval = WEXITSTATUS(status);
+	return retval == BIND_NO_BUDGET ? -1 : retval;
+}
+
 FIXTURE(bound_interp) {
 	char obj[PATH_MAX];
 	struct bpf_case c;
@@ -565,4 +620,19 @@ TEST_F(bound_interp, capped_bindings)
 	EXPECT_EQ(entry_bind("test_interp_bind", "over", BIND_FIRST), -ENOSPC);
 }
 
+/* A binding pins a file: it is charged, and refused once the budget is out. */
+TEST_F(bound_interp, bindings_are_charged)
+{
+	int err = bind_out_of_budget("test_interp_bind", "third", BIND_FIRST);
+
+	if (err < 0)
+		SKIP(return, "no user namespaces or no " INTERP_LIMIT);
+
+	/* The charge follows the writer, not the entry file it writes to. */
+	EXPECT_EQ(err, ENOSPC);
+
+	/* The budget was the only thing in the way. */
+	EXPECT_EQ(entry_bind("test_interp_bind", "third", BIND_FIRST), 0);
+}
+
 TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/exec/binfmt_misc_interplimit.c b/tools/testing/selftests/exec/binfmt_misc_interplimit.c
new file mode 100644
index 000000000000..bf611c551784
--- /dev/null
+++ b/tools/testing/selftests/exec/binfmt_misc_interplimit.c
@@ -0,0 +1,232 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * A pre-opened interpreter - what 'F' gives a static entry and what a 'B'
+ * entry binds - keeps a file open for as long as the entry lives, so it pins
+ * the mount it came from. It costs no file descriptor, and binfmt_misc is
+ * FS_USERNS_MOUNT, so an unprivileged user namespace can create them without
+ * bound. Check that UCOUNT_BINFMT_MISC_INTERPRETERS bounds it, that an entry
+ * that pre-opens nothing is not charged, that removing an entry gives the
+ * charge back, and that nesting a user namespace does not evade it.
+ *
+ * Runs unprivileged in a user namespace.
+ */
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/mount.h>
+#include <sys/stat.h>
+#include <unistd.h>
+
+#include "../filesystems/utils.h"
+#include "kselftest_harness.h"
+
+#define MNT		"/tmp/binfmt_interplimit"
+#define NESTED_MNT	"/tmp/binfmt_interplimit_nested"
+#define LIMIT_SYSCTL	"/proc/sys/user/max_binfmt_misc_interpreters"
+
+#define MAGIC		"\\xde\\xad"
+/* Not on the instance, and unlike /bin/true it always exists. */
+#define INTERP		"/proc/self/exe"
+
+/* Small enough to fill by hand, big enough that a refund is visible. */
+#define LIMIT		4
+
+/* What UCOUNT_ENTRY() lets a namespace raise its own limit to. */
+#define LIMIT_MAX	"2147483647"
+
+static int ensure_dir(const char *path)
+{
+	if (mkdir(path, 0755) && errno != EEXIST)
+		return -1;
+	return 0;
+}
+
+/* Write @val to @path, preserving write(2)'s errno for the caller. */
+static int write_keep_errno(const char *path, const char *val)
+{
+	int fd, saved;
+	ssize_t n;
+
+	fd = open(path, O_WRONLY | O_CLOEXEC);
+	if (fd < 0)
+		return -1;
+	n = write(fd, val, strlen(val));
+	saved = errno;
+	close(fd);
+	errno = saved;
+	return n < 0 ? -1 : 0;
+}
+
+static int set_limit(const char *val)
+{
+	return write_keep_errno(LIMIT_SYSCTL, val);
+}
+
+static int register_at(const char *mnt, const char *rule)
+{
+	char path[PATH_MAX];
+
+	snprintf(path, sizeof(path), "%s/register", mnt);
+	return write_keep_errno(path, rule);
+}
+
+/* An 'F' entry: one interpreter pre-opened at registration, one charge. */
+static int register_fixed(const char *mnt, const char *name)
+{
+	char rule[PATH_MAX];
+
+	snprintf(rule, sizeof(rule), ":%s:M::" MAGIC "::" INTERP ":F", name);
+	return register_at(mnt, rule);
+}
+
+/* The same entry without 'F': the interpreter is opened per exec instead. */
+static int register_plain(const char *mnt, const char *name)
+{
+	char rule[PATH_MAX];
+
+	snprintf(rule, sizeof(rule), ":%s:M::" MAGIC "::" INTERP ":", name);
+	return register_at(mnt, rule);
+}
+
+static int remove_entry(const char *mnt, const char *name)
+{
+	char path[PATH_MAX];
+
+	snprintf(path, sizeof(path), "%s/%s", mnt, name);
+	return write_keep_errno(path, "-1\n");
+}
+
+static bool entry_exists(const char *mnt, const char *name)
+{
+	char path[PATH_MAX];
+
+	snprintf(path, sizeof(path), "%s/%s", mnt, name);
+	return access(path, F_OK) == 0;
+}
+
+/* Register @n 'F' entries, each with a name of its own. */
+static int fill_budget(const char *mnt, unsigned int n)
+{
+	char name[32];
+	unsigned int i;
+
+	for (i = 0; i < n; i++) {
+		snprintf(name, sizeof(name), "fixed%u", i);
+		if (register_fixed(mnt, name))
+			return -1;
+	}
+	return 0;
+}
+
+FIXTURE(interp_limit) {
+};
+
+FIXTURE_SETUP(interp_limit)
+{
+	/* setup_userns() exits rather than returns if this is not there. */
+	if (access("/proc/self/ns/user", F_OK))
+		SKIP(return, "kernel without user namespaces");
+	ASSERT_EQ(setup_userns(), 0);
+
+	/* CAP_SYS_RESOURCE in this namespace is what makes it writable. */
+	if (set_limit(LIMIT_MAX)) {
+		if (errno == ENOENT)
+			SKIP(return, "kernel without " LIMIT_SYSCTL);
+		SKIP(return, "cannot set the limit: %s", strerror(errno));
+	}
+
+	ASSERT_EQ(ensure_dir(MNT), 0);
+	if (mount("binfmt_misc", MNT, "binfmt_misc", 0, NULL)) {
+		int saved = errno;
+
+		/* Teardown doesn't run when setup skips, so clean up here. */
+		rmdir(MNT);
+		SKIP(return, "no binfmt_misc: %s", strerror(saved));
+	}
+}
+
+FIXTURE_TEARDOWN(interp_limit)
+{
+	/* The namespaces go with the process; just don't litter /tmp. */
+	umount2(NESTED_MNT, MNT_DETACH);
+	umount2(MNT, MNT_DETACH);
+	rmdir(NESTED_MNT);
+	rmdir(MNT);
+}
+
+/* Every pre-opened interpreter is charged, and the budget is a hard stop. */
+TEST_F(interp_limit, fixed_interpreters_are_charged)
+{
+	char buf[32];
+
+	snprintf(buf, sizeof(buf), "%u", LIMIT);
+	ASSERT_EQ(set_limit(buf), 0);
+
+	ASSERT_EQ(fill_budget(MNT, LIMIT), 0);
+
+	EXPECT_NE(register_fixed(MNT, "over"), 0);
+	EXPECT_EQ(errno, ENOSPC);
+
+	/* A refused registration leaves nothing behind. */
+	EXPECT_FALSE(entry_exists(MNT, "over"));
+}
+
+/* An entry that pre-opens nothing pins nothing, so it is not charged. */
+TEST_F(interp_limit, plain_entries_are_not_charged)
+{
+	ASSERT_EQ(set_limit("0"), 0);
+
+	EXPECT_EQ(register_plain(MNT, "plain"), 0);
+	EXPECT_TRUE(entry_exists(MNT, "plain"));
+
+	/* ... while the same entry with 'F' has nothing to spend. */
+	EXPECT_NE(register_fixed(MNT, "fixed"), 0);
+	EXPECT_EQ(errno, ENOSPC);
+}
+
+/* Removing an entry closes its interpreters and gives the charge back. */
+TEST_F(interp_limit, removal_refunds_the_charge)
+{
+	char buf[32];
+
+	snprintf(buf, sizeof(buf), "%u", LIMIT);
+	ASSERT_EQ(set_limit(buf), 0);
+
+	ASSERT_EQ(fill_budget(MNT, LIMIT), 0);
+	ASSERT_NE(register_fixed(MNT, "over"), 0);
+
+	ASSERT_EQ(remove_entry(MNT, "fixed0"), 0);
+	EXPECT_EQ(register_fixed(MNT, "over"), 0);
+}
+
+/*
+ * The charge walks the ancestors, so a namespace cannot buy itself budget by
+ * nesting: it may raise only its own limit, and the parent it was created
+ * from is charged for every binding made below it.
+ */
+TEST_F(interp_limit, nesting_does_not_evade_it)
+{
+	char buf[32];
+
+	snprintf(buf, sizeof(buf), "%u", LIMIT);
+	ASSERT_EQ(set_limit(buf), 0);
+	ASSERT_EQ(fill_budget(MNT, LIMIT), 0);
+
+	ASSERT_EQ(setup_userns(), 0);
+	ASSERT_EQ(set_limit(LIMIT_MAX), 0);
+
+	ASSERT_EQ(ensure_dir(NESTED_MNT), 0);
+	ASSERT_EQ(mount("binfmt_misc", NESTED_MNT, "binfmt_misc", 0, NULL), 0);
+
+	/* A fresh instance with an unlimited budget of its own, and yet: */
+	EXPECT_NE(register_fixed(NESTED_MNT, "nested"), 0);
+	EXPECT_EQ(errno, ENOSPC);
+
+	/* The nested instance works for anything that pins no file. */
+	EXPECT_EQ(register_plain(NESTED_MNT, "nested_plain"), 0);
+}
+
+TEST_HARNESS_MAIN

-- 
2.53.0


