Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C20660A2611
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 01:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mailfence.com header.i=brianwitte@mailfence.com header.a=rsa-sha256 header.s=20240605-akrp header.b=GrqaxEBa
Received: by kanga.kvack.org (Postfix)
	id 4A4DE6B0AA6; Thu, 22 Oct 2026 21:54:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42DBB6B0AA8; Thu, 22 Oct 2026 21:54:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36B776B0AA9; Thu, 22 Oct 2026 21:54:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09C596B0AA6
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 21:54:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F60480300
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 01:54:52 +0000 (UTC)
X-FDA: 85352222424.18.278F10D
Received: from mailout-l3b-97.contactoffice.com (mailout-l3b-97.contactoffice.com [212.3.242.97])
	by imf01.hostedemail.com (Postfix) with ESMTP id A3CCF4000A
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 01:54:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=mailfence.com header.s=20240605-akrp header.b=GrqaxEBa;
	spf=pass (imf01.hostedemail.com: domain of brianwitte@mailfence.com designates 212.3.242.97 as permitted sender) smtp.mailfrom=brianwitte@mailfence.com;
	dmarc=pass (policy=reject) header.from=mailfence.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792720490;
	b=fJQL33FKYp0x8OyQvSPVxeZ76ukCngtuHYmDJ+OQb4iUfb6AKI3DZh97BgcEEKKVwjXrWT
	XiO3PISjWZrAM+RoRyE5xweO+YVO7sOPVgBIX169uDNWINskWa1M4ESukVDB8+0/G+8hsL
	8UAxz7ycN0081j7vtOLq+SlMCHGB4mE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=mailfence.com header.s=20240605-akrp header.b=GrqaxEBa;
	spf=pass (imf01.hostedemail.com: domain of brianwitte@mailfence.com designates 212.3.242.97 as permitted sender) smtp.mailfrom=brianwitte@mailfence.com;
	dmarc=pass (policy=reject) header.from=mailfence.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792720490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4rTlpb7GfMR9wMDmMibWcW8o92S1RDunUKU4LVh+Jkc=;
	b=Lj9rUur+Db20E7bjKqpgJu3/c5W0H6f5cXJ/6Y0SpWxiHnLLgxYEcQqqrQr/DdajKzWn6r
	sM7n9yf4/E7BoWixhyQEkZ858XtoIMkDdNenoLtEfa2Hf7T+SK96mL3wey2/ovwGbgS//9
	gwb0l7OcXqsVO/Qf9li5MPq9VU+HSYM=
Received: from smtpauth1.co-bxl (smtpauth1.co-bxl [10.2.0.15])
	by mailout-l3b-97.contactoffice.com (Postfix) with ESMTP id A504660A8;
	Fri, 23 Oct 2026 03:54:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1792720486;
	s=20240605-akrp; d=mailfence.com; i=brianwitte@mailfence.com;
	h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From;
	bh=4rTlpb7GfMR9wMDmMibWcW8o92S1RDunUKU4LVh+Jkc=;
	b=GrqaxEBaVJ0nFoAhJiYPusLDk3u11s7gpqWbOgCfiXe3pfgHHdoGnhazSqCJUEb5
	fqxCG10DI8NDPxrkHUpU9zz350iA3W9YR0hCskfnaRo9p6bSgkxJXogHqn+Bq6S8HBS
	Ic5xrbpOgEbPwTU1RMSwKkdMzJBqNzSjc1G/km/Us4pYzUgSq6aTKhtvgfOJQdshV0f
	1mEl7r5Hmp1OO6vURXWsnY3Whi5KYCsoLLIh9+Ae/3W3Ym+5Id1p/cF1v/SsGsXepCj
	OdbQTkUQDC9/0Emt9r5lifJrlzQC91TaEyWUFm9XAuJrbnCsJt79FG834xcYsP0AzHP
	ajlKKIQdPQ==
Received: by smtp.mailfence.com with ESMTPSA ; Fri, 23 Oct 2026 03:54:44 +0200 (CEST)
From: Brian Witte <brianwitte@mailfence.com>
To: Kees Cook <kees@kernel.org>
Cc: Brian Witte <brianwitte@mailfence.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jann Horn <jannh@google.com>,
	Helge Deller <deller@gmx.de>,
	Justin Stitt <justinstitt@google.com>,
	Daniel Micay <danielmicay@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-hardening@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] selftests/exec: test the argument block's in-page offset
Date: Fri, 23 Oct 2026 03:54:46 +0200 (CEST)
Message-ID: <20261023015345.1594514-3-brianwitte@mailfence.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261023015345.1594514-1-brianwitte@mailfence.com>
References: <20261023015345.1594514-1-brianwitte@mailfence.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CO-INDEX: b3VYll9dFyCFFB5P1wKTKlFLR1oD9XLpGvWEKkjq9pA=
X-Stat-Signature: 4fs9ei86dnwuk5873biwakmc1o9rx4sc
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A3CCF4000A
X-Rspam-User: 
X-HE-Tag: 1792720490-577953
X-HE-Meta: U2FsdGVkX1/WSI251EutN0E0Er/QOoJiXjLxXSMufGkfI52WOHxm12EDRn5/ids1xqRNRgjXIpfVfTSCY7uGTJkEiZ8AdsRMb3hS6oO0IZnaxh/VZefeXPIz1h2PSUd2u/MvQkXOSMyGcecTI6g7YvbV6+N7oBCEV83WHkOPNUubfwOeBfu1MvERs9NhSIfNj1BXJJpaPmnk1ze0cy+z7ypftB6ZAviVa71qYgl2mHGj1RHUXA478Gnw1xfEdMm0W4VyP9pgbHm8wyaiRSp8rerf/jl1C2zRjqWYDqwG68aQ+a+ES+9AUKe3IsTlSQNEguuaRquNdrmU8VJ1xGoSepmxOn0jA61dlwBGemC09BX7h9HTf8hkSBUsCSKlNSX6N9W3PrXQTKmvR24RST+StYElG9aC73lXclVUbuhr+uJhzcO5GZ0ylaqrsKqqHpkjaxjIPcaxMenixL66g4Dlh+4F1jf9nVr2pagIq7FQHYDzAfbKgaHfXRfKSWz3B76YC+OisAoA0c8jXFduNAy0TMKyZyivYr9cIljkT1XGiRq9KplWbz2nyzUUIWEYFiByKsj5aUStRnwtiinbOY49UDZ5BfeRgB7lp6/MwM2GmYd7EE5qrKHcnvEhhx9wzTqBnuQwu15kQs3kmL+/G4ccsr5jGf87Xw/QFRVAEca9cxW+ubBmeBQb0GXuLPuGxZkEPACA0jyNYD7PYBvBvWgMvyfIkcNuTmEuh0K2rZ/y8hXn889jbxBvb+jvtOFXOhZnolfE05lDSiklXlTzKg5N7mqFFeo5ZXEcwV5+UzM/pMbXgyJG+faxiMxMpGnTAtS6/igiXlJakrTtAhXXAf9DkHo5qfXsekrVZCY8Q1LsW72q1biG4BVArSswW7vzhzcokNe8cJBqVKRBGTOThj3GZEak0/+XBAEfpNAN0nawmxrLMH05JokW+DYPKHoxf3eQuPHqRnlu1qp/XMQVbuN
 iqXcE4uD
 BQ+OCyPy0ldK7jUv59tQ2HPcn/ITA5I8D/zWYL9yyMiqaHrr1oTgXQkSPtsaMw4XxSm2YXCnp1os/Dm6Ur/BrvEzxhyDriNQ6Ni0xxHCRvnvurkDdSPVtKqQ/LCdkN+HPH51TIfE4qwcG49ULwG6xn7gLTaclK/HBQeP8mVsNnygjWP53sVIBSXKrLownhMKq7wcYO8LCfdozF2rSobjmDB9XE4OO4ifpl5VL+BKii0IWT3IW1EabO6qFGcAT8tAFVvxGeaqYFUym9CHpjMl1evfw3xass7wm0ZMjS2M34kyDaFAG7vXPMVjAv6Cw4Lvz9j5uINFfIg0rtM5e7ZZBL2u9NLgE2Koy8Z111T7qzBJRP/s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Exec a helper, argblock-report, 64 times per case. Each case checks that
the in-page offset of argv[0] varies exactly when the stack top chosen
by the ELF loader does:
 - under ADDR_NO_RANDOMIZE: fixed;
 - by default: random;
 - a set-user-ID copy under ADDR_NO_RANDOMIZE: random;
 - that copy on a nosuid mount, under no_new_privs, or in a new user
   namespace where its owner has no mapping: fixed.

The tests use the kselftest harness. The fixture keeps the copy in a
private temporary directory and removes it on teardown. The copy is
owned by the caller, so no privilege is needed.

Link: https://github.com/KSPP/linux/issues/283
Signed-off-by: Brian Witte <brianwitte@mailfence.com>
---
 tools/testing/selftests/exec/.gitignore       |   3 +
 tools/testing/selftests/exec/Makefile         |   5 +
 .../testing/selftests/exec/argblock-offset.c  | 214 ++++++++++++++++++
 .../testing/selftests/exec/argblock-report.c  |  24 ++
 4 files changed, 246 insertions(+)
 create mode 100644 tools/testing/selftests/exec/argblock-offset.c
 create mode 100644 tools/testing/selftests/exec/argblock-report.c

diff --git a/tools/testing/selftests/exec/.gitignore b/tools/testing/selftests/exec/.gitignore
index e42ecd4c908d..991097f7fc43 100644
--- a/tools/testing/selftests/exec/.gitignore
+++ b/tools/testing/selftests/exec/.gitignore
@@ -9,6 +9,9 @@ execveat.ephemeral
 execveat.denatured
 non-regular
 null-argv
+/argblock-offset
+/argblock-offset.*
+/argblock-report
 /check-exec
 /false
 /inc
diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index 91decfa8ff2c..4835c7ca4a20 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -21,6 +21,11 @@ TEST_GEN_PROGS += recursion-depth
 TEST_GEN_PROGS += null-argv
 TEST_GEN_PROGS += check-exec
 
+# The argument block's in-page offset must be random exactly when the
+# ELF loader randomizes the stack. Unprivileged.
+TEST_GEN_PROGS += argblock-offset
+TEST_GEN_FILES += argblock-report
+
 # binfmt_misc must not be reachable as an exec source or as a stacking layer,
 # or an 'F' entry can pin the instance that owns it. Unprivileged, no bpf.
 TEST_GEN_PROGS += binfmt_misc_selfpin
diff --git a/tools/testing/selftests/exec/argblock-offset.c b/tools/testing/selftests/exec/argblock-offset.c
new file mode 100644
index 000000000000..6edf9e6aadaf
--- /dev/null
+++ b/tools/testing/selftests/exec/argblock-offset.c
@@ -0,0 +1,214 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * The argument block should land at a random offset within its page
+ * exactly when the ELF loader randomizes the stack: always, unless
+ * ADDR_NO_RANDOMIZE is set and the exec is not set-id. Each case
+ * execs argblock-report repeatedly and compares both.
+ *
+ * Runs unprivileged: the set-user-ID copy is owned by the caller and
+ * kept in a private directory.
+ */
+#define _GNU_SOURCE
+#include <sched.h>
+#include <sys/personality.h>
+#include <sys/prctl.h>
+#include <sys/stat.h>
+#include <sys/statvfs.h>
+
+#include "binfmt_misc_common.h"	/* artifact_path(), copy_file() */
+#include "kselftest_harness.h"
+
+/*
+ * A page holds at least 4088 possible offsets, so 64 samples all landing
+ * on one value happen by chance with probability at most (1/4088)^63.
+ */
+#define SAMPLES 64
+
+/* How the helper is exec'd. */
+#define NO_RAND	0x1	/* under ADDR_NO_RANDOMIZE */
+#define NNP	0x2	/* under no_new_privs */
+#define USERNS	0x4	/* in a new user namespace with no mappings */
+
+FIXTURE(argblock) {
+	char report[PATH_MAX];	/* the helper */
+	char dir[32];		/* private directory for the set-id copy */
+	char setid[PATH_MAX];	/* set-user-ID copy of the helper */
+	bool have_dir, have_setid, nosuid;
+	int randomize_va_space;
+};
+
+static int read_randomize_va_space(void)
+{
+	FILE *f = fopen("/proc/sys/kernel/randomize_va_space", "r");
+	int v = -1;
+
+	if (f) {
+		if (fscanf(f, "%d", &v) != 1)
+			v = -1;
+		fclose(f);
+	}
+	return v;
+}
+
+FIXTURE_SETUP(argblock)
+{
+	struct statvfs sv;
+
+	ASSERT_EQ(artifact_path(self->report, sizeof(self->report),
+				"argblock-report"), 0);
+	self->randomize_va_space = read_randomize_va_space();
+
+	/* A private directory keeps the set-user-ID copy out of reach. */
+	strcpy(self->dir, "argblock-offset.XXXXXX");
+	self->have_dir = mkdtemp(self->dir);
+	if (!self->have_dir)
+		return;
+	snprintf(self->setid, sizeof(self->setid), "%s/setid", self->dir);
+	self->have_setid = !copy_file(self->report, self->setid) &&
+			   !chmod(self->setid, 04755);
+	self->nosuid = !statvfs(self->dir, &sv) && (sv.f_flag & ST_NOSUID);
+}
+
+FIXTURE_TEARDOWN(argblock)
+{
+	if (!self->have_dir)
+		return;
+	unlink(self->setid);
+	rmdir(self->dir);
+}
+
+struct sample {
+	unsigned long offset;		/* argv[0] within its page */
+	unsigned long stack_top;	/* end of [stack], chosen by the loader */
+};
+
+static int sample(const char *path, int how, struct sample *s)
+{
+	int pfd[2], status;
+	char buf[64];
+	ssize_t n;
+	pid_t pid;
+
+	if (pipe(pfd))
+		return -1;
+	pid = fork();
+	if (pid < 0)
+		return -1;
+	if (pid == 0) {
+		char *argv[] = { (char *)path, NULL };
+		char *envp[] = { NULL };
+
+		if ((how & NO_RAND) && personality(ADDR_NO_RANDOMIZE) < 0)
+			_exit(2);
+		if ((how & NNP) && prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0))
+			_exit(2);
+		if ((how & USERNS) && unshare(CLONE_NEWUSER))
+			_exit(2);
+		dup2(pfd[1], STDOUT_FILENO);
+		execve(path, argv, envp);
+		_exit(3);
+	}
+	close(pfd[1]);
+	n = read(pfd[0], buf, sizeof(buf) - 1);
+	close(pfd[0]);
+	waitpid(pid, &status, 0);
+	if (n <= 0 || !WIFEXITED(status) || WEXITSTATUS(status))
+		return -1;
+	buf[n] = '\0';
+	return sscanf(buf, "%lx %lx", &s->offset, &s->stack_top) == 2 ? 0 : -1;
+}
+
+/*
+ * Exec @path SAMPLES times. The in-page offset must vary as @expect says,
+ * and vary exactly when the loader's stack top does.
+ */
+static void check(struct __test_metadata *_metadata, const char *path,
+		  int how, bool expect)
+{
+	bool offset_varies = false, stack_varies = false;
+	struct sample first, s;
+	int i;
+
+	for (i = 0; i < SAMPLES; i++) {
+		ASSERT_EQ(sample(path, how, &s), 0)
+			TH_LOG("exec of %s failed", path);
+		if (!i)
+			first = s;
+		offset_varies |= s.offset != first.offset;
+		stack_varies |= s.stack_top != first.stack_top;
+	}
+	EXPECT_EQ(stack_varies, expect)
+		TH_LOG("the loader %s the stack",
+		       stack_varies ? "randomized" : "did not randomize");
+	EXPECT_EQ(offset_varies, expect)
+		TH_LOG("the argument block offset is %s",
+		       offset_varies ? "random" : "fixed");
+}
+
+/* Can this process create a user namespace? */
+static bool have_userns(void)
+{
+	int status;
+	pid_t pid = fork();
+
+	if (pid == 0)
+		_exit(unshare(CLONE_NEWUSER) ? 1 : 0);
+	return pid > 0 && waitpid(pid, &status, 0) == pid &&
+	       WIFEXITED(status) && !WEXITSTATUS(status);
+}
+
+/* Without privilege, ADDR_NO_RANDOMIZE keeps the offset fixed. */
+TEST_F(argblock, addr_no_randomize_keeps_offset_fixed)
+{
+	check(_metadata, self->report, NO_RAND, false);
+}
+
+/* By default the offset is random. */
+TEST_F(argblock, offset_is_random)
+{
+	if (self->randomize_va_space <= 0)
+		SKIP(return, "randomize_va_space is 0");
+	check(_metadata, self->report, 0, true);
+}
+
+/* A set-id exec clears ADDR_NO_RANDOMIZE, so the offset is random again. */
+TEST_F(argblock, setid_ignores_addr_no_randomize)
+{
+	if (self->randomize_va_space <= 0)
+		SKIP(return, "randomize_va_space is 0");
+	if (!self->have_setid)
+		SKIP(return, "cannot create a set-user-ID copy");
+	if (self->nosuid)
+		SKIP(return, "set-user-ID copy is on a nosuid mount");
+	check(_metadata, self->setid, NO_RAND, true);
+}
+
+/* On a nosuid mount the exec gains nothing, so the flag holds. */
+TEST_F(argblock, setid_on_nosuid_keeps_offset_fixed)
+{
+	if (!self->have_setid)
+		SKIP(return, "cannot create a set-user-ID copy");
+	if (!self->nosuid)
+		SKIP(return, "set-user-ID copy is not on a nosuid mount");
+	check(_metadata, self->setid, NO_RAND, false);
+}
+
+/* no_new_privs makes the exec ignore the set-id bit. */
+TEST_F(argblock, setid_under_no_new_privs_keeps_offset_fixed)
+{
+	if (!self->have_setid)
+		SKIP(return, "cannot create a set-user-ID copy");
+	check(_metadata, self->setid, NO_RAND | NNP, false);
+}
+
+/* The copy's owner has no mapping there, so the set-id bit is ignored. */
+TEST_F(argblock, setid_in_user_namespace_keeps_offset_fixed)
+{
+	if (!self->have_setid)
+		SKIP(return, "cannot create a set-user-ID copy");
+	if (!have_userns())
+		SKIP(return, "cannot create a user namespace");
+	check(_metadata, self->setid, NO_RAND | USERNS, false);
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/exec/argblock-report.c b/tools/testing/selftests/exec/argblock-report.c
new file mode 100644
index 000000000000..45744ec9bda9
--- /dev/null
+++ b/tools/testing/selftests/exec/argblock-report.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Helper for argblock-offset: print the in-page offset of argv[0] and the
+ * end of the [stack] VMA, which the ELF loader chooses.
+ */
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+
+int main(int argc, char **argv)
+{
+	unsigned long end = 0;
+	char line[256];
+	FILE *maps = fopen("/proc/self/maps", "r");
+
+	while (maps && fgets(line, sizeof(line), maps))
+		if (strstr(line, "[stack]"))
+			sscanf(line, "%*[0-9a-f]-%lx", &end);
+	if (argc < 1 || !end)
+		return 1;
+	printf("%lx %lx\n", (unsigned long)argv[0] & (sysconf(_SC_PAGESIZE) - 1),
+	       end);
+	return 0;
+}
-- 
2.47.3


