Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E93F9606A332
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 23:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hoYetZWl
Received: by kanga.kvack.org (Postfix)
	id 237496B0887; Tue, 24 Nov 2026 18:00:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C1176B0889; Tue, 24 Nov 2026 18:00:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 088A86B088A; Tue, 24 Nov 2026 18:00:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C81ED6B0887
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:00:03 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 53BA480D34
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:00:03 +0000 (UTC)
X-FDA: 85471532286.01.2C3FE85
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 72775C0009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:00:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hoYetZWl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795561201;
	b=E13fMRNrxvPQuR7kYnoPlluvVb+XYebebpjTAZf4u34NT88grUyc90BP23VIDUf2qQKx9E
	ulvNDf2nVMLGTqSzQp+E/DCzkrJsEnO/ZgS1ga2Kn3XKxeXC9cyjYrTmfL+ZHbJeNzJcDp
	Qu6/QyK1PSiExkMTTTmng4qVgTeblX4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795561201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2C+rk0NMFrbNe0MIF80ZOVKYf9Ba1s/rRNRNQryPHiI=;
	b=B21jqpVbX7Jw/SLQw8Nd3WHDY8CXo6pPZ125I+t5++DEHU7IPeOaDBvSN7oVvlZCBmip6W
	dHywDpYXHk14ESrCoz4NX+PancHY2zgqJN+kHb1TfDFYXh+WOu5F9TG1YhXVQdjS3tAyFI
	w6v95myzkVt0zkQYrwP5gBqM8hqJAyw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hoYetZWl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BF476413DE;
	Tue, 24 Nov 2026 23:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAAFD1F00A03;
	Tue, 24 Nov 2026 22:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795561200;
	bh=2C+rk0NMFrbNe0MIF80ZOVKYf9Ba1s/rRNRNQryPHiI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hoYetZWllIRpmPQF74b7ybaKlEXv909X9hNNs3Vh3+uUBNryWcSAREVRtA2X8aGQK
	 R+B58C1v8sVQBTKcBmlfOmtFmKAHG8mh+5r4Z1GT4jzelIBRvs9r+JQwOOl6BVrJJ7
	 DNthuig7J98GenpKv0/mReuEIadEb9NPzjLLg+wYCQiMIZVDMBr9do2cKIK3toXV3P
	 56Y5TToG+R5vWWB67rigS/Cgv+m3XyBNFZ5qXSvLJD+gSQ4AD4pq+ECkfedjLOIYzQ
	 ZKCFxfnRWVYUFVURfD2npzjWd3OurLpzmkAlvrSy807UQlFpMqYch4YAvz20Pv9nai
	 V4uxt/vinYcXA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 24 Nov 2026 23:58:31 +0100
Subject: [PATCH RFC 08/19] selftests/exec: test exec with a shared signal
 table
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-work-exec-update_lock-v1-8-e489035395b8@kernel.org>
References: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
In-Reply-To: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 linux-fsdevel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 linux-perf-users@vger.kernel.org, bpf@vger.kernel.org, 
 selinux@vger.kernel.org, Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
 linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, 
 David Hildenbrand <david@kernel.org>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-04696
X-Developer-Signature: v=1; a=openpgp-sha256; l=9968; i=brauner@kernel.org;
 h=from:subject:message-id; bh=llT2zgJ1sk7ce873wnC1YeARhaC2FQU0cnTsE6LZXFk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSzie2PE47dV/bx2BTe7uYVVjOtjOQW+3rzuSy5uYXN+
 ZnNvIb7HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPx28nw3ydz64Pc7LnzDSJ9
 invWGixn/rbaOTqXLWnfQ7/X340zdzL803h4stxgCf+RQykSz4xL93x6o3ZwVzeP286ePu1pMYs
 EWQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 72775C0009
X-Stat-Signature: y16awezu7soe7e1c6bg1husjgmjhchi6
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795561201-850518
X-HE-Meta: U2FsdGVkX19s+YaReTIzve/EiUwvbVFBL76SJZeCNxwmuk27y8j7i/YyVohSBs6vwLev81CkL8Ossj5tWJtDL9Eizf/C+cO6Ss4qkH8aEIfLj0l5ZyXkGsx9qvxpihdczFh21NxrjBSmbegQkfcQGjdqbxu4Xa2+6hFX4XVmCV5LcjdTFm9H+mFmXOBQHnqlKYycYufTRIgifrqiVkJKSsLG1PZ2++E8bNDFzNFm745pR8fkFrMXW9xa/rQCDs6jOrZABbn1fiYh5TUUgzTtFszVVsqYhWyR6VWdMjetD5kmrLse0faxKQhGub+aHLkSU0tWIAKKYgbkQtElYu08qhz8vPm/Xm9mOXY9vSsJFWM3o5tKsNtdixVgiRfKAgnHMl5Ij8EkMxkfz+qYH4WeELqZu6yvlOqnmvHycJEqRH2oUz8HWCg0PxnMtydo3TjqisoIk8XTF1YVTb8Q4UREeWvGqhLSY5UEAqdHXDeBEav0bBTC3U4FGUcUyj66G18tcFq/LW9ledFACrMGNCgkIWdXNG4wimxnjkzhh8YuoWWXACcJc4u5CofkO9ET1Z4juJ5Zajwu8oxiD8mFF2t/TowBN54nuS9f9jIihTzxHmFXbHy2E8Ew0JiAMX5lwcRlGGN21xT3dii691zLeWXQk4XdyW+20RMMuQTgnb8dmQvn39nSRXuJdHpRvBTOzKBODN+eUILFMeXhsOSjBqPMAYDMMOtaRH2i1w5hcOtwOx2v0TlQQGPY++R27YaM/S0ECsH3aO3sYp1/eGCxOqN85UuXzsOsJE2WTcLG6jI5cTd65G0wTOuEbHN6TasaeGwb0GG6U30PwdDH/TO7z6NWwshKcUw6VM4423/qhBUt3SiEgmoOhAbsmXNpU6ZBJT9nFLzPwEHFdbLVDC82p04il1RrR6/Sy24rVcIQYcfo2xe8A81z4lxWgeT2iwDDKEnSg/TsBAYYrWLtOV9exzy
 5A9TvbxM
 Io/hotmM+kpKcTMaIR8K1q68in3ZAGXaoZBdzLjSyU2kPMupcun3zXNtJmsLBIB+BVbegFWLG6bv3yEDjJYHffIyhDBarvuIBg5VZIIynEQOg7Bk2Fa3VCWIEOp5y5r61mo07jQmtEY16L0aQChmWWbz9FRRnuYV9isnJfTe7oLkXEcIdGbbfAzh633l6TtCk6yirtS3apMl7LF5S/hxeWhBn3MjzcwjlJJpZOCYVgDvjinDHGxaTQpcpvmFb+0J4r2jqIwYzrH3GKfKbU59ndPrOwqNdKyptIiTXAvqTyhYcbFqATRwhYjaisquwsLXzE0iDdYZsNoPmk4PwSzRFHkwQybAZ+fpY5mK3IXH3vxpYbHATaYLY4v/WnTADwBDasySWp7bElPThHznuGIPusR5OdGMtxHm6w0/TNCvPXKL/drthLsyzMmSPKgIz/eD80VqHq2eSNNGdsXeHCwm6QqMHo4gR3AABabuE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Test that exec gives a task that shares its signal table with another
process a private one:

- handlers the processes shared are reset in the new image

- an ignored signal stays ignored in the new image

- the other process keeps all of its handlers

- a signal the other process ignores right after vfork() returned isn't
  ignored in the new image

The task is created with CLONE_SIGHAND but without CLONE_THREAD so it
isn't taken care of by de_thread(). For the last one the parent runs in
a realtime scheduling class on the cpu of the task so that it gets to
ignore the signal as soon as it's woken up.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/exec/.gitignore        |   1 +
 tools/testing/selftests/exec/Makefile          |   2 +
 tools/testing/selftests/exec/unshare-sighand.c | 236 +++++++++++++++++++++++++
 3 files changed, 239 insertions(+)

diff --git a/tools/testing/selftests/exec/.gitignore b/tools/testing/selftests/exec/.gitignore
index 4613c68537395..b27f4db42f87b 100644
--- a/tools/testing/selftests/exec/.gitignore
+++ b/tools/testing/selftests/exec/.gitignore
@@ -16,6 +16,7 @@ null-argv
 !load_address.c
 /recursion-depth
 /set-exec
+/unshare-sighand
 /update-lock-fault
 xxxxxxxx*
 pipe
diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index 3756a250f9591..70f090a5f7648 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -21,6 +21,7 @@ TEST_GEN_PROGS += recursion-depth
 TEST_GEN_PROGS += null-argv
 TEST_GEN_PROGS += check-exec
 TEST_GEN_PROGS += update-lock-fault
+TEST_GEN_PROGS += unshare-sighand
 
 # binfmt_misc must not be reachable as an exec source or as a stacking layer,
 # or an 'F' entry can pin the instance that owns it. Unprivileged, no bpf.
@@ -117,6 +118,7 @@ $(OUTPUT)/binfmt_misc_interplimit: CFLAGS += $(TOOLS_INCLUDES)
 $(OUTPUT)/binfmt_misc_interplimit: ../filesystems/utils.c
 
 $(OUTPUT)/update-lock-fault: LDLIBS += -lpthread
+$(OUTPUT)/unshare-sighand: LDLIBS += -lpthread
 
 # --- binfmt_misc bpf ('B') handler test ---------------------------------
 # The struct_ops bpf objects are compiled against the running kernel's BTF.
diff --git a/tools/testing/selftests/exec/unshare-sighand.c b/tools/testing/selftests/exec/unshare-sighand.c
new file mode 100644
index 0000000000000..425b46d4d5c9c
--- /dev/null
+++ b/tools/testing/selftests/exec/unshare-sighand.c
@@ -0,0 +1,236 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test exec in a task that shares its signal table with another process
+ * without being one of its threads, i.e. CLONE_SIGHAND without CLONE_THREAD.
+ * The exec has to give the task a private table before it resets the
+ * handlers so the other process keeps the table they shared. If the other
+ * process waits for the task in vfork() the task has to have its private
+ * table before that process runs again.
+ */
+#define _GNU_SOURCE
+#include <pthread.h>
+#include <sched.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "kselftest_harness.h"
+
+#define STACK_SIZE	(64 * 1024)
+
+/* Makes the exec'd image check its dispositions. */
+#define EXECED_ARG	"execed"
+/* Makes the exec'd image check the signal its vfork() parent ignored. */
+#define EXECED_VFORK_ARG	"execed-vfork"
+
+/* Exit status of a sharer that never made it into the exec'd image. */
+#define EXIT_NO_EXEC	127
+
+/* Handled before the clone. */
+static const int handled_signals[] = { SIGUSR1, SIGUSR2 };
+/* Handled by the sharer right before its exec. */
+#define SHARER_SIGNAL	SIGTERM
+/* Ignored before the clone. */
+#define IGNORED_SIGNAL	SIGHUP
+/* Ignored by a vfork() parent as soon as it runs again. */
+#define VFORK_SIGNAL	SIGINT
+
+/* How often a vfork() parent races with the exec of its child. */
+#define VFORK_ROUNDS	16
+
+/* How much the thread that holds the mmap lock has to work on. */
+#define WRITER_SIZE	(1UL << 30)
+
+static void handler(int sig)
+{
+}
+
+static int set_disposition(int sig, sighandler_t disposition)
+{
+	const struct sigaction sa = { .sa_handler = disposition };
+
+	return sigaction(sig, &sa, NULL);
+}
+
+static const char *disposition_name(sighandler_t disposition)
+{
+	if (disposition == SIG_DFL)
+		return "default";
+	if (disposition == SIG_IGN)
+		return "ignored";
+	return "handled";
+}
+
+static bool has_disposition(const char *who, int sig, sighandler_t disposition)
+{
+	struct sigaction sa;
+
+	if (sigaction(sig, NULL, &sa))
+		return false;
+	ksft_print_msg("%s: signal %d (%s) is %s\n", who, sig, strsignal(sig),
+		       disposition_name(sa.sa_handler));
+	return sa.sa_handler == disposition;
+}
+
+/* The signals with a handler must have @handled, the ignored one SIG_IGN. */
+static bool check_dispositions(const char *who, sighandler_t handled)
+{
+	bool ret = true;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(handled_signals); i++)
+		ret &= has_disposition(who, handled_signals[i], handled);
+	ret &= has_disposition(who, SHARER_SIGNAL, handled);
+	ret &= has_disposition(who, IGNORED_SIGNAL, SIG_IGN);
+	return ret;
+}
+
+static int setup_dispositions(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(handled_signals); i++) {
+		if (set_disposition(handled_signals[i], handler))
+			return -1;
+	}
+	return set_disposition(IGNORED_SIGNAL, SIG_IGN);
+}
+
+static int sharer(void *arg)
+{
+	/* The parent only gets to see this if the table really is shared. */
+	if (!set_disposition(SHARER_SIGNAL, handler))
+		execl("/proc/self/exe", "unshare-sighand", EXECED_ARG,
+		      (char *)NULL);
+	_exit(EXIT_NO_EXEC);
+}
+
+TEST(exec_unshares_sighand)
+{
+	char *stack;
+	int status;
+	pid_t pid;
+
+	ASSERT_EQ(setup_dispositions(), 0);
+
+	stack = mmap(NULL, STACK_SIZE, PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANONYMOUS | MAP_STACK, -1, 0);
+	ASSERT_NE(stack, MAP_FAILED);
+
+	pid = clone(sharer, stack + STACK_SIZE,
+		    CLONE_VM | CLONE_SIGHAND | SIGCHLD, NULL);
+	ASSERT_GT(pid, 0);
+	ASSERT_EQ(waitpid(pid, &status, 0), pid);
+	ASSERT_TRUE(WIFEXITED(status));
+	/* The exec'd image has the handlers reset and SIG_IGN inherited. */
+	EXPECT_EQ(WEXITSTATUS(status), EXIT_SUCCESS);
+
+	/* The table was shared up to the exec and the exec left it alone. */
+	EXPECT_TRUE(check_dispositions("parent", handler));
+
+	EXPECT_EQ(munmap(stack, STACK_SIZE), 0);
+}
+
+struct mmap_writer {
+	pthread_t thread;
+	char *map;
+	bool stop;
+};
+
+/*
+ * Hold the mmap lock for writing most of the time. An exec that waits for
+ * the mmap lock of the old mm after it has woken up a vfork() parent gives
+ * that parent all the time it needs.
+ */
+static void *mmap_writer(void *arg)
+{
+	struct mmap_writer *writer = arg;
+
+	while (!__atomic_load_n(&writer->stop, __ATOMIC_RELAXED)) {
+		mprotect(writer->map, WRITER_SIZE, PROT_NONE);
+		mprotect(writer->map, WRITER_SIZE, PROT_READ);
+	}
+	return NULL;
+}
+
+static int vfork_sharer(void *arg)
+{
+	execl("/proc/self/exe", "unshare-sighand", EXECED_VFORK_ARG,
+	      (char *)NULL);
+	_exit(EXIT_NO_EXEC);
+}
+
+TEST(exec_unshares_sighand_before_vfork_returns)
+{
+	struct sched_param param = { .sched_priority = 1 };
+	struct mmap_writer writer = {};
+	cpu_set_t cpu;
+	char *stack;
+	int status;
+	pid_t pid;
+	int i;
+
+	stack = mmap(NULL, STACK_SIZE, PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_ANONYMOUS | MAP_STACK, -1, 0);
+	ASSERT_NE(stack, MAP_FAILED);
+
+	/* One page table entry per page, all of them the zero page. */
+	writer.map = mmap(NULL, WRITER_SIZE, PROT_READ,
+			  MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
+	ASSERT_NE(writer.map, MAP_FAILED);
+	madvise(writer.map, WRITER_SIZE, MADV_NOHUGEPAGE);
+	madvise(writer.map, WRITER_SIZE, MADV_POPULATE_READ);
+	ASSERT_EQ(pthread_create(&writer.thread, NULL, mmap_writer, &writer), 0);
+
+	/*
+	 * The task that is cloned below runs on our cpu and, as the policy
+	 * isn't inherited, not in a realtime scheduling class. On a kernel
+	 * with preemption we run as soon as it wakes us up and it doesn't get
+	 * any further meanwhile. Without the privilege for that only an exec
+	 * that sleeps after it has woken us up is caught.
+	 */
+	CPU_ZERO(&cpu);
+	CPU_SET(sched_getcpu(), &cpu);
+	if (!sched_setaffinity(0, sizeof(cpu), &cpu))
+		sched_setscheduler(0, SCHED_FIFO | SCHED_RESET_ON_FORK, &param);
+
+	for (i = 0; i < VFORK_ROUNDS; i++) {
+		ASSERT_EQ(set_disposition(VFORK_SIGNAL, SIG_DFL), 0);
+
+		pid = clone(vfork_sharer, stack + STACK_SIZE,
+			    CLONE_VM | CLONE_VFORK | CLONE_SIGHAND | SIGCHLD,
+			    NULL);
+		/* The task has its own table. This is none of its business. */
+		set_disposition(VFORK_SIGNAL, SIG_IGN);
+		ASSERT_GT(pid, 0);
+		ASSERT_EQ(waitpid(pid, &status, 0), pid);
+		ASSERT_TRUE(WIFEXITED(status));
+		ASSERT_EQ(WEXITSTATUS(status), EXIT_SUCCESS) {
+			TH_LOG("round %d: ignored after vfork(), ignored in the exec'd image", i);
+		}
+	}
+
+	__atomic_store_n(&writer.stop, true, __ATOMIC_RELAXED);
+	ASSERT_EQ(pthread_join(writer.thread, NULL), 0);
+	EXPECT_EQ(munmap(writer.map, WRITER_SIZE), 0);
+	EXPECT_EQ(munmap(stack, STACK_SIZE), 0);
+}
+
+int main(int argc, char **argv)
+{
+	struct sigaction sa;
+
+	if (argc == 2 && !strcmp(argv[1], EXECED_ARG))
+		return check_dispositions("exec'd image", SIG_DFL) ?
+		       EXIT_SUCCESS : EXIT_FAILURE;
+	if (argc == 2 && !strcmp(argv[1], EXECED_VFORK_ARG)) {
+		if (sigaction(VFORK_SIGNAL, NULL, &sa))
+			return EXIT_FAILURE;
+		return sa.sa_handler == SIG_DFL ? EXIT_SUCCESS : EXIT_FAILURE;
+	}
+	return test_harness_run(argc, argv);
+}

-- 
2.53.0


