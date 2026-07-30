Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87484C55160
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 13:34:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49B086B0095; Thu, 30 Jul 2026 09:34:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4779A6B0096; Thu, 30 Jul 2026 09:34:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AE5A6B0098; Thu, 30 Jul 2026 09:34:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DF8D6B0095
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:34:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7DCDF40150
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:34:53 +0000 (UTC)
X-FDA: 85045538466.25.77502DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id AF7B31C000E
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:34:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SD60FMC4;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785418491;
	b=ckLOkjIalg7DrIuhvlyveIqvnpNMGfYrdEeQg+RA5PuMQUbMECrNPwxQFObIoiajSkClP/
	+l3KO76CDdqhkDMVdnyXxm216+CjWy+9QJRdKQd1AFAXSJTPUgMif3Ul5VU2uJeIqANNnz
	K8KN8weuALP5nj5KEQXoLU7eHTixG0o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SD60FMC4;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785418491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3l7h1n2uv5iSYv1s38ASwG4Pmn2bVDkbvbhQiAaHrcc=;
	b=2/FuOw9sWdMbGorYgDwK4xGYJO9L3EUkIR9f542ykvG+Fq6ePIJUFksIep9XiRrCt4rDGO
	IrhHDj6iXNkVY2yfMJ7wTKRZQJHCRsypTstpup2ZQXwmEJoHsAUCmLOGWbv+ilQW10+N5M
	Tj1OzPh2gxWcffdYb+OVwjWekZDQcZ8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E683600C8;
	Thu, 30 Jul 2026 13:34:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7623F1F00A3A;
	Thu, 30 Jul 2026 13:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785418491;
	bh=3l7h1n2uv5iSYv1s38ASwG4Pmn2bVDkbvbhQiAaHrcc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SD60FMC4q1xAU3WOUv7zQzs4NxC+VEWISfF6PDFQIPO0OBCknyP2vHijal+twNuDv
	 9vdEgyCVonOjkdPw9At75zYLpIUsGU7vle4ERd/wg14wAz7J5a2zENrEijW71qZxX9
	 7arszZRlyuDnN/dbT4PnFu2vwPIy5VnDnPlTxPVVrmebEuA2eveW7R1VuHCFctLmZS
	 QyDkPi0KZ9eKkcYYJvYK/tBddBL86x943sk2YEzMLpW79zPHaDIOsSbNwpW6OUdqPx
	 9/C7dvO8di0XrfI8b8PHNXiRhm0iyNdTxO6kh7GH4/owseoSstcpdVW7DK7o+zkNyh
	 xTL5Q3eZkaO0g==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 30 Jul 2026 15:34:05 +0200
Subject: [PATCH 3/9] selftests/exec: test registering an entry disabled
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-work-binfmt_misc-preopen-v1-3-4a0b0da71f16@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8427; i=brauner@kernel.org;
 h=from:subject:message-id; bh=aS7ycWv7igG5p79cmS/9TycopAIvNRoU117UekWg3ZA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRlB72T4tn1jofnma+rSZJmrPr7E8yuMW4bN63ZfuVSO
 3fr56L8jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIm4ijAyPJA81n/3M3sNe31J
 20tzg86Eqftvl7Rct2GMka7q5zwqwMjwaBLPbs7/jJsulVYLqq8SjfYUP1126uY89vLGnP16bx9
 zAQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AF7B31C000E
X-Stat-Signature: sctj8bz471otq1utpx95zqyxigmm1ykf
X-Rspam-User: 
X-HE-Tag: 1785418491-647066
X-HE-Meta: U2FsdGVkX19JEUm3TFM43VD6lQ1eJBguDo0VJeGe4aku5HoBO3DwlukfRuZ9nbOS4A4dtK04u/z+WNoftBesk2Pmk/d+t8jhhlynYsZxLDgck80l6K8tyJ9eb1Ls348Sbnijx8Nne2pLC+ao8rV8mxffn2v0cQShyYtizq7pmcFtqcHNBBOBOBRv9CFdxX/TOWQaOkLs2dQNOReMZtTQi+i0Tq8qa9foIje3QIp2W+LxAe0sKrgI2txiWQu/WGeWeD18toEkVg7Jd6RUJtxKM04fXESLMGG3EeGjwSSw+25Vq/nzAVqOWu+Lf0d0feUFrZ2gwhyFgykOIR4KsyQGlylhrZKZsL7cB6aACEl5l9TZeqXsdBieDZ3n/Be9Q0zLbAyiPQlE3pNi3vfKclcI8adPaNUxBNNx2wAhOHYEpcdZvf+8aNYWI4QHlYT6ABIUG7EBT0Dn+O+keFlODeQoVr2vgG0M5UqkeYS7HcJUpTrR4JjoJtPPmASr6xlxoDbk/VYaylNyL66gktrLj2EVWz1ta/DaQ44w6msHGvsfxiy34OmjPLqH/agXrUabIou3lAqoQOXs8JBxBEEemGzjmYzZacLBIloW4ERiArmVY8GVlfy3psbVUbmCLWJOHyFjK8kOC5wM9EPM1pgGeektqMDYePJ2J4cOpKemNUrzPx36g1sHdsqJ0qksZvNP+uJejlyakJqMuv6cV0ZDQgTQfnvkByWNW/TkssYGCYdFa1wsoc8fjAz5ibfGxbq/GD5u2dpcNHCY3Yi+zEBch60ja8Jut9RTSa1B5jzQv1B5/pQX68lIEYWPh2IGIVWoeyCweDHtwAR7kEFlwj+ICMntze8DL5rWe955AObAwY3q3oZzYR0+rc6S+iE6Yi4KOu5WhFG8wg3/4Rvm50TxBj8CWGk7kI9IHQnejQIM+qB/Gig2QqqGp3ZX5S/RcR7fZZbEybOasxh6Pq70538XQRR
 lRbsODAK
 Y8ChXu6O9IKNfvSJs/ZF6CqT+Fp/armE1Vh9NMpB4gkKXTjsr0kLK8fveRniC5Iloled4cnKNLLY4jexgq1Mnd4R7a/jWELu4ftjaWHQbSAoPG3/421fzJKovu7791UZc1w7WPwUd0EjapMUSeVBWh8nmwsEerleuLz3ovbPfstqTm1myyDp098GIIT+JNQecWJc7UOJ+Gd+YYzEc8Z1SAdTs1ZHntC+V2DXqqKSSjheVFDbGc89n1+PsmkF2qj7TtSAqmUn1wiN0Zy9Y+kF8sg2qBp0zZynD3lv4rZS50TFqJddbS/42Qgx0O8+n4nPmmu/A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A magic entry registered with 'D' and the same entry without it, to pin
down what the flag decides and what it leaves alone:

- the entry reports itself disabled and nothing dispatches until '1' is
  written to it

- without 'D' it dispatches straight away

- 'D' is not read back among the entry's flags

- enabling and disabling afterwards works as it does for any entry

- 'D' composes with the flags that shape the invocation

- '-1' to the status file removes a staged entry like any other

- a file handle held across a removal cannot resurrect the entry

Put the entry write and read-back helpers into binfmt_misc_common.h.
The bpf suite will need them as well.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/exec/Makefile              |   4 +
 tools/testing/selftests/exec/binfmt_misc_common.h  |  39 +++++
 .../testing/selftests/exec/binfmt_misc_disabled.c  | 172 +++++++++++++++++++++
 3 files changed, 215 insertions(+)

diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index 390fe11a7bed..ec7894a802e0 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -25,6 +25,10 @@ TEST_GEN_PROGS += check-exec
 # or an 'F' entry can pin the instance that owns it. Unprivileged, no bpf.
 TEST_GEN_PROGS += binfmt_misc_selfpin
 
+# 'D' (register disabled) binfmt_misc test: an entry that exists but does
+# not dispatch until it is enabled. Static magic entry, no bpf toolchain.
+TEST_GEN_PROGS += binfmt_misc_disabled
+
 # Static ('T' flag) transparent binfmt_misc test; the asserting interpreter
 # is shared with the bpf harness's transparent case. No bpf toolchain needed.
 TEST_GEN_PROGS += binfmt_misc_transparent
diff --git a/tools/testing/selftests/exec/binfmt_misc_common.h b/tools/testing/selftests/exec/binfmt_misc_common.h
index e8d67908dbc4..745aff84dc78 100644
--- a/tools/testing/selftests/exec/binfmt_misc_common.h
+++ b/tools/testing/selftests/exec/binfmt_misc_common.h
@@ -93,6 +93,45 @@ static inline void unregister(const char *name)
 	}
 }
 
+/* Write @line to @entry's file, reporting the errno it was refused with. */
+static inline int entry_command(const char *entry, const char *line)
+{
+	char path[PATH_MAX];
+	int fd, retval = 0;
+	size_t len = strlen(line);
+
+	snprintf(path, sizeof(path), BINFMT_DIR "/%s", entry);
+	fd = open(path, O_WRONLY | O_CLOEXEC);
+	if (fd < 0)
+		return -errno;
+	if (write(fd, line, len) != (ssize_t)len)
+		retval = -errno;
+	close(fd);
+	return retval;
+}
+
+/* Does @entry's file report @line? */
+static inline bool entry_shows(const char *entry, const char *line)
+{
+	char path[PATH_MAX], buf[PATH_MAX];
+	bool found = false;
+	FILE *fp;
+
+	snprintf(path, sizeof(path), BINFMT_DIR "/%s", entry);
+	fp = fopen(path, "r");
+	if (!fp)
+		return false;
+	while (fgets(buf, sizeof(buf), fp)) {
+		buf[strcspn(buf, "\n")] = '\0';
+		if (!strcmp(buf, line)) {
+			found = true;
+			break;
+		}
+	}
+	fclose(fp);
+	return found;
+}
+
 /* Mount binfmt_misc unless it already is, and report whether it is usable. */
 static inline bool binfmt_misc_available(void)
 {
diff --git a/tools/testing/selftests/exec/binfmt_misc_disabled.c b/tools/testing/selftests/exec/binfmt_misc_disabled.c
new file mode 100644
index 000000000000..47c9e8a4ee42
--- /dev/null
+++ b/tools/testing/selftests/exec/binfmt_misc_disabled.c
@@ -0,0 +1,172 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test the 'D' (register disabled) flag of binfmt_misc. An entry
+ * registered with it exists but cannot be matched until userspace enables
+ * it, which splits a registration into create and activate.
+ *
+ * Needs root for the registration; no bpf toolchain involved.
+ */
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+
+#include "binfmt_misc_common.h"
+#include "kselftest_harness.h"
+
+#define MAGIC		"#DISABLED-SELFTEST#"
+#define TARGET_PATH	"/tmp/binfmt_disabled_target"
+#define INTERP_PATH	"/tmp/binfmt_disabled_interp.sh"
+#define ENTRY		"test_disabled"
+#define RULE(flags)	":" ENTRY ":M:0:" MAGIC "::" INTERP_PATH ":" flags
+
+/* The interpreter exits with a code the harness can recognise. */
+#define EXIT_INTERP	7
+
+/* The target only has to carry the magic; it is never actually loaded. */
+static int create_target(void)
+{
+	char buf[128] = MAGIC "\n";
+	int fd;
+
+	unlink(TARGET_PATH);
+	fd = open(TARGET_PATH, O_WRONLY | O_CREAT | O_EXCL, 0755);
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
+static int create_interp(void)
+{
+	char buf[64];
+	int fd;
+
+	unlink(INTERP_PATH);
+	fd = open(INTERP_PATH, O_WRONLY | O_CREAT | O_EXCL, 0755);
+	if (fd < 0)
+		return -1;
+	snprintf(buf, sizeof(buf), "#!/bin/sh\nexit %d\n", EXIT_INTERP);
+	if (write(fd, buf, strlen(buf)) != (ssize_t)strlen(buf)) {
+		close(fd);
+		return -1;
+	}
+	return close(fd);
+}
+
+FIXTURE(disabled) {
+};
+
+FIXTURE_SETUP(disabled)
+{
+	if (getuid() != 0)
+		SKIP(return, "test must be run as root");
+	if (!binfmt_misc_available())
+		SKIP(return, "no binfmt_misc");
+
+	/* Skip the whole suite on a kernel that does not know 'D'. */
+	if (!binfmt_flag_supported('D')) {
+		ASSERT_EQ(errno, EINVAL);
+		SKIP(return, "kernel without the 'D' flag");
+	}
+
+	ASSERT_EQ(create_interp(), 0);
+	ASSERT_EQ(create_target(), 0);
+}
+
+FIXTURE_TEARDOWN(disabled)
+{
+	unregister(ENTRY);
+	unlink(TARGET_PATH);
+	unlink(INTERP_PATH);
+}
+
+/* The entry exists but does not dispatch until it is enabled. */
+TEST_F(disabled, inert_until_enabled)
+{
+	ASSERT_EQ(write_reg(RULE("D")), 0);
+	EXPECT_TRUE(entry_shows(ENTRY, "disabled"));
+
+	/* Nothing matches it, so no binary format claims the target. */
+	EXPECT_EQ(run_payload(TARGET_PATH), RUN_ENOEXEC);
+
+	ASSERT_EQ(entry_command(ENTRY, "1\n"), 0);
+	EXPECT_TRUE(entry_shows(ENTRY, "enabled"));
+	EXPECT_EQ(run_payload(TARGET_PATH), EXIT_INTERP);
+}
+
+/* Without 'D' an entry is matchable the moment it is registered. */
+TEST_F(disabled, enabled_without_the_flag)
+{
+	ASSERT_EQ(write_reg(RULE("")), 0);
+	EXPECT_TRUE(entry_shows(ENTRY, "enabled"));
+	EXPECT_EQ(run_payload(TARGET_PATH), EXIT_INTERP);
+}
+
+/* 'D' is spent on the registration: the entry does not report it back. */
+TEST_F(disabled, flag_not_reported)
+{
+	ASSERT_EQ(write_reg(RULE("D")), 0);
+	EXPECT_FALSE(entry_shows(ENTRY, "flags: D"));
+	EXPECT_TRUE(entry_shows(ENTRY, "flags: "));
+}
+
+/* A disabled entry can be disabled and enabled like any other. */
+TEST_F(disabled, toggles_like_any_entry)
+{
+	ASSERT_EQ(write_reg(RULE("D")), 0);
+
+	ASSERT_EQ(entry_command(ENTRY, "1\n"), 0);
+	ASSERT_EQ(run_payload(TARGET_PATH), EXIT_INTERP);
+	ASSERT_EQ(entry_command(ENTRY, "0\n"), 0);
+	EXPECT_EQ(run_payload(TARGET_PATH), RUN_ENOEXEC);
+	ASSERT_EQ(entry_command(ENTRY, "1\n"), 0);
+	EXPECT_EQ(run_payload(TARGET_PATH), EXIT_INTERP);
+}
+
+/* 'D' composes with the invocation flags a static entry can carry. */
+TEST_F(disabled, composes_with_invocation_flags)
+{
+	ASSERT_EQ(write_reg(RULE("PD")), 0);
+	EXPECT_TRUE(entry_shows(ENTRY, "disabled"));
+	EXPECT_TRUE(entry_shows(ENTRY, "flags: P"));
+}
+
+/* '-1' to the status file sweeps a staged entry with everything else. */
+TEST_F(disabled, removed_by_remove_all)
+{
+	int fd;
+
+	ASSERT_EQ(write_reg(RULE("D")), 0);
+	EXPECT_TRUE(entry_shows(ENTRY, "disabled"));
+
+	fd = open(BINFMT_DIR "/status", O_WRONLY | O_CLOEXEC);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(write(fd, "-1", 2), 2);
+	close(fd);
+
+	EXPECT_NE(access(BINFMT_DIR "/" ENTRY, F_OK), 0);
+}
+
+/* A file handle held across a removal cannot resurrect the entry. */
+TEST_F(disabled, no_resurrection_after_remove)
+{
+	int fd;
+
+	ASSERT_EQ(write_reg(RULE("D")), 0);
+	fd = open(BINFMT_DIR "/" ENTRY, O_WRONLY | O_CLOEXEC);
+	ASSERT_GE(fd, 0);
+
+	ASSERT_EQ(write(fd, "-1", 2), 2);
+	EXPECT_NE(access(BINFMT_DIR "/" ENTRY, F_OK), 0);
+
+	/* Accepted like any toggle of a removed entry, but publishes nothing. */
+	EXPECT_EQ(write(fd, "1", 1), 1);
+	EXPECT_EQ(run_payload(TARGET_PATH), RUN_ENOEXEC);
+	close(fd);
+}
+
+TEST_HARNESS_MAIN

-- 
2.53.0


