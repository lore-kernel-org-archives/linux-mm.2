Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 095A4C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 08:49:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C595F6B0092; Thu, 17 Sep 2026 04:49:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE6616B0093; Thu, 17 Sep 2026 04:49:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD1EC6B0095; Thu, 17 Sep 2026 04:49:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8273E6B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:49:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 977D21C186A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 08:49:44 +0000 (UTC)
X-FDA: 85222631088.18.B8FA595
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 04C6AA0006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 08:49:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kxDyCvLn;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789634983;
	b=OabLZp2pLiYs0EXmPMkKVX5cVCSBxTa1wWc1XpdKBH6lu3gRvem70laaJTP9VlQr1dP0Mo
	IG+buzcdrSH8uBLZ6Rh7ff4GdW4/V4Yma2VboHzyvZOZchOUh/v7paGvWo7fewU8LtMlk+
	2jU7rOzukFluI/tNk15aB8VI0PxeMW0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kxDyCvLn;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789634983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xCY9xH2my2ZnWedJPgq/0TqPw8q3Z6WWbTIkvwNYddc=;
	b=PXZNdAoTWKrANhpvupbp8BoySfGUECVsLwz6CYMkllD5JI6vG1NY9vuolOp8xrRSIw23Ji
	4XojlCYUu5SowV5FjYFseLcWQ8SBcDnstFCgkTiqYp0KjNywRvXXqTHDARFPDcQoyb+dBz
	/mKcsWajphtuWG8AtEtM7LIX5zSwGOg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 18F97600D4;
	Thu, 17 Sep 2026 08:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86C21F000FF;
	Thu, 17 Sep 2026 08:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789634981;
	bh=xCY9xH2my2ZnWedJPgq/0TqPw8q3Z6WWbTIkvwNYddc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kxDyCvLnMnzBnJzFQz4yjaU0fYLwlj8qKXZleBVaEJywAYykaWGMp8RLDUbiCYxR4
	 MIFtAm1qjzUVH5dv0Q4SZw8u8jalnuENXTV9TjbxRdFj0WYCpGUkETWmQAClZ6K48H
	 dGhnNfEggRqodxZZQi9TQ14szc8PAKZpIRGr6tbtkKJ2HMGsj+JOC9CBOMDHOrafj9
	 kFRDBedtmCm723sXEGd5+KY+SOmfBOAJwkNY34hVHhdqFE4Cf++MyBLOoJfefx+aRa
	 uFOP1cUVPoAjhoTE3nagfnflHKuivDypE1MsmdCM4qCiYaC/C5QVaQsEZ+AXjVuFdE
	 8E+g02bsLio3Q==
Date: Thu, 17 Sep 2026 10:49:36 +0200
From: Christian Brauner <brauner@kernel.org>
To: NeilBrown <neil@brown.name>, Chris Mason <mason@kernel.org>, 
	Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, io-uring@vger.kernel.org
Subject: user workers as coredumpers [Re: [PATCH 1/6] coredump: don't switch
 a dumper that has no files] table
Message-ID: <20260917-zahnpasta-aufweichen-flackern-1182320f5c81@brauner>
References: <20260915-work-coredump-fixes-v1-1-f354ca41780c@kernel.org>
 <20260916194837.3732307-1-mason@kernel.org>
 <20260917-staunen-sparsam-infusion-83238c68d21f@brauner>
 <178960987412.207413.3957049392884487413@noble.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <178960987412.207413.3957049392884487413@noble.neil.brown.name>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 04C6AA0006
X-Stat-Signature: 6n7oatrabhmy59qy7jojxeq3izyoasa4
X-Rspam-User: 
X-HE-Tag: 1789634982-173151
X-HE-Meta: U2FsdGVkX1/NtRoGSt+/FYQ1qVf+lOdLmseKyt1bY/sg0g/urW0zAHHtrpAL8jgW4ECOvChEzk6hLt6Da1cOaX9bqCXWwd7yfE0ZiEjTf7aXCWPV9QYb8KK74gkOD5T0ujga6wkcIjzdehhxNqTcMUFlSgp5hWYmK2A+PifbZbZByDe4mfrG2699fa0DHoyvRUSlI7VwpuBGtXcen66TYCX8pZ5cUJlCPCn0itSkLvcyDJwp29WeiPqcO7eEvl/jufBu0eR+Vpw6S+qH3wtflSOl/lcnltHpB1Hzsbc4ENepFsk7v/+qgqg6+P+KYHOfIArKASBtsB0WD1o/XZaG8KlObf1IA/dGd6IifqGyxHcgGED2kWDRFIY1bWsOd6iOSP460JaRXOH+UME6grwp/tASqA70zhdn0Dj2j19VN/zLwkv/aknujtI+fNWVh3ZR4XUBPz/b/qDWMbX5HitgNZh9ElsPV9v3qLfi9mEOKcUzZ5MQrpJwimrFH2CXL9z3fvwAX9RdGvWeegdz61Bv0NrNnQeOGe9fkzwkesGfOG7Gfb60s21teUuP/jF6Bnlbvd2huXGAiq4JpEJSIKRcjdpPuV+IWm3iLGz5SDYzTre9c3skcHU1KbqF5Q0fqfHZK3LKjkOPTDCC1P4Ygnr+1TGOdniL/Hs9AjYRjf08C8+be4bQoVnkg0Z8D1DU8aEw0NODfFFWfFOOysNEZ9iNz7SyIX9c94hM8rIbsrWCx92Pke2NBERaNSrbypN7ZNfcxxA7JBT5UUZe3i87pAtFe0Z5v3IA5yVsr/71EgGXp0Fdzh62+uD/af0ciQJ7fauxkedhoJdS1vW1k89zagjOl6Za5VkeBO9whOuvTkGKnkLnPy88d15fQvkH4AIjl2SzhhCnHt01TIgEfjXtR60QE9xfR8mTqPRqw+Ev4i+gTC1hpt38LLrbM6vJ8B93qlHQZw5B25FB91MR5P9IjaT
 GCC03uWh
 u6e8/ScEVmdFwvtAhXIjipar59r4nfIhdj3pmapJ7FAHn4gD+QMv0F1wJy65MBURp9ftZKl4gfdfpOA5JMVsreIkC9bRf4ElBOdwj6udcFXKzNz/FNrJQw4wMhDsdZDnRVx+kNMjQr34gqH6DaSGYidlHj+DpN8Vfttx9PFQzFU5xGoahkpYzHxtxtkePbhHonxSk4Uadb9AVSFYdeg/4M4G35Wra7HB3+FieYlEyMkKdnmSuT9T30bkvzXGXPXo6xXWS1izDi7C0J3LZzNZ+tGmZFH3y193IqBDrKvOXKGqQGz1ElcZS8gh69HOOEnZVVddw3b7hMZmd9vE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 11:51:14AM +1000, NeilBrown wrote:
> On Thu, 17 Sep 2026, Christian Brauner wrote:
> > > When I reproduced this one, it ended up deadlocking with the fix applied.
> > > 
> > > vhost worker (the dumper)          sibling thread
> > > =========================          ==============
> > > get_signal() -> vfs_coredump()
> > >   coredump_close_files()
> > >     hands sibling a new table ---> switch_files_struct()
> > >     coredump_wait_inactive()         put_files_struct(old table)
> > >       waits for sibling's switch       last close of the vhost fd
> > >                                      vhost_net_release()
> > >                                        __vhost_worker_flush(): waits
> > > 
> > > AI suggests making the vhost thread requeue the signal for someone more
> > > suitable?
> > 
> > Afaict, this is conceptually a generic problem with letting coredump
> > close files for any type of user worker where the worker is the dumper
> > and the sibling thread closes the fd that causes it to be stopped and
> > waits for it to exit. So this needs thinking and we should drop coredump
> > closing files for now.
> > 
> 
> It appears to me that there is already infrastructure in place to handle
> the generic problem.  vhost_task has a "handle_sigkill" function which
> cleans up on sig kill so that siblings won't keep waiting for it.
> get_signal() detects PF_USER_WORKER tasks and lets them complete
> normally rather than aborting them, so that handle_sigkill can be called.
> 
> So the problem is "simply" an ordering problem. vfs_coredump() closes
> files before handle_sigkill can run.
> Maybe handle_sigkill() could be passed to (a version of) get_signal(),
> or maybe get_signal() could indicate to the PF_USER_WORKER caller that
> vfs_coredump() still needs to be run.

Oh good, it's worse. This isn't specific to this patchset. This class of
bugs I mentioned is reproducible on current mainline with SQPOLL:

  io-wq worker (the dumper)               SQPOLL thread
  =========================               =============
  io_wq_worker()                          io_sq_thread()
    get_signal()                            io_sqd_handle_event()
      vfs_coredump()
        coredump_wait()
          zap_threads()
            zap_process(): SIGKILL ---->      get_signal(): SIGKILL, returns
          wait_for_completion_state(        io_uring_cancel_generic(true, sqd)
            &core_state->startup)             io_uring_clean_tctx()
          waits for every thread to             io_wq_put_and_exit()
          reach coredump_task_exit()              io_wq_exit_workers()
                                                    wait_for_completion(
                                                      &wq->worker_done)
                                                    waits for the worker's
                                                    io_worker_exit(), which
                                                    runs after get_signal()

Here's a selftest to reproduce it:

From 3099604cb701a7a5242986653add8c52d4b6d2c6 Mon Sep 17 00:00:00 2001
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 17 Sep 2026 10:20:49 +0200
Subject: [PATCH] selftests/coredump: test a user worker as the coredumping
 thread

A tracer can clear the signal mask of an io-wq worker or an SQPOLL
thread with PTRACE_SETSIGMASK and inject a coredump signal. The worker
then runs vfs_coredump() itself. Cover that:

- a child keeps a ring, an idle io-wq worker and with SQPOLL the SQPOLL
  thread alive

- seize the chosen thread, stop it with SIGSTOP, clear its mask and
  detach with SIGSEGV

- require the thread group to be gone in bounded time, by the dump or
  by SIGKILL

The io-wq worker of an SQPOLL ring fails: the SQPOLL thread waits for
its workers to exit before it parks, the dumping worker waits for the
SQPOLL thread to park and the group is stuck in D state.

This reproduces the following hang when SQPOLL becomes the coredumper:

  io-wq worker (the dumper)               SQPOLL thread
  =========================               =============
  io_wq_worker()                          io_sq_thread()
    get_signal()                            io_sqd_handle_event()
      vfs_coredump()
        coredump_wait()
          zap_threads()
            zap_process(): SIGKILL ---->      get_signal(): SIGKILL, returns
          wait_for_completion_state(        io_uring_cancel_generic(true, sqd)
            &core_state->startup)             io_uring_clean_tctx()
          waits for every thread to             io_wq_put_and_exit()
          reach coredump_task_exit()              io_wq_exit_workers()
                                                    wait_for_completion(
                                                      &wq->worker_done)
                                                    waits for the worker's
                                                    io_worker_exit(), which
                                                    runs after get_signal()

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/coredump/.gitignore   |   1 +
 tools/testing/selftests/coredump/Makefile     |   4 +-
 .../selftests/coredump/coredump_worker_test.c | 427 ++++++++++++++++++
 3 files changed, 431 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/coredump/coredump_worker_test.c

diff --git a/tools/testing/selftests/coredump/.gitignore b/tools/testing/selftests/coredump/.gitignore
index c198f2ca5872..e32f6e9006f6 100644
--- a/tools/testing/selftests/coredump/.gitignore
+++ b/tools/testing/selftests/coredump/.gitignore
@@ -3,3 +3,4 @@ stackdump_test
 coredump_socket_test
 coredump_socket_protocol_test
 coredump_signal_test
+coredump_worker_test
diff --git a/tools/testing/selftests/coredump/Makefile b/tools/testing/selftests/coredump/Makefile
index bfb53f512d8e..9459ba3692c1 100644
--- a/tools/testing/selftests/coredump/Makefile
+++ b/tools/testing/selftests/coredump/Makefile
@@ -5,7 +5,8 @@ TEST_GEN_PROGS := stackdump_test \
 		  coredump_socket_test \
 		  coredump_socket_protocol_test \
 		  coredump_close_files_test \
-		  coredump_signal_test
+		  coredump_signal_test \
+		  coredump_worker_test
 TEST_FILES := stackdump
 
 include ../lib.mk
@@ -15,3 +16,4 @@ $(OUTPUT)/coredump_socket_test: coredump_test_helpers.c
 $(OUTPUT)/coredump_socket_protocol_test: coredump_test_helpers.c
 $(OUTPUT)/coredump_close_files_test: coredump_test_helpers.c
 $(OUTPUT)/coredump_signal_test: coredump_test_helpers.c
+$(OUTPUT)/coredump_worker_test: coredump_test_helpers.c
diff --git a/tools/testing/selftests/coredump/coredump_worker_test.c b/tools/testing/selftests/coredump/coredump_worker_test.c
new file mode 100644
index 000000000000..81cadde0e752
--- /dev/null
+++ b/tools/testing/selftests/coredump/coredump_worker_test.c
@@ -0,0 +1,427 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * A user worker as the coredumping thread.
+ *
+ * io-wq workers and SQPOLL threads are threads of the process that never
+ * return to userspace. They block every signal but SIGKILL and SIGSTOP,
+ * but a tracer can replace that mask with PTRACE_SETSIGMASK and inject a
+ * coredump signal. get_signal() then runs vfs_coredump() in the worker.
+ * The worker's own exit bookkeeping runs only after the dump, so a
+ * zapped sibling that waits for it in its exit path deadlocks with the
+ * dumper and the whole thread group is stuck in D state.
+ *
+ * Inject SIGSEGV into a chosen thread and require that the thread group
+ * is gone in bounded time, either because the dump completed or because
+ * SIGKILL still works. A failure leaves the stuck process behind.
+ */
+#include <ctype.h>
+#include <dirent.h>
+#include <fcntl.h>
+#include <sys/mman.h>
+#include <sys/ptrace.h>
+#include <sys/resource.h>
+#include <sys/stat.h>
+#include <sys/syscall.h>
+#include <sys/wait.h>
+#include <unistd.h>
+#include <linux/io_uring.h>
+
+#include "coredump_test.h"
+
+#ifndef PTRACE_SETSIGMASK
+#define PTRACE_SETSIGMASK 0x420b
+#endif
+
+/* The dump of the tiny child takes well under a second. */
+#define EXIT_TIMEOUT_MS 5000
+
+FIXTURE_SETUP(coredump)
+{
+	FILE *file;
+	int ret;
+
+	self->pid_coredump_server = -ESRCH;
+	self->fd_tmpfs_detached = -1;
+	file = fopen("/proc/sys/kernel/core_pattern", "r");
+	ASSERT_NE(NULL, file);
+
+	ret = fread(self->original_core_pattern, 1, sizeof(self->original_core_pattern), file);
+	ASSERT_TRUE(ret || feof(file));
+	ASSERT_LT(ret, sizeof(self->original_core_pattern));
+
+	self->original_core_pattern[ret] = '\0';
+
+	ret = fclose(file);
+	ASSERT_EQ(0, ret);
+}
+
+FIXTURE_TEARDOWN(coredump)
+{
+	const char *reason;
+	FILE *file;
+	int ret;
+
+	file = fopen("/proc/sys/kernel/core_pattern", "w");
+	if (!file) {
+		reason = "Unable to open core_pattern";
+		goto fail;
+	}
+
+	ret = fprintf(file, "%s", self->original_core_pattern);
+	if (ret < 0) {
+		reason = "Unable to write to core_pattern";
+		goto fail;
+	}
+
+	ret = fclose(file);
+	if (ret) {
+		reason = "Unable to close core_pattern";
+		goto fail;
+	}
+
+	return;
+fail:
+	/* This should never happen */
+	fprintf(stderr, "Failed to cleanup coredump test: %s\n", reason);
+}
+
+/* A raw ring, no liburing. */
+struct uring {
+	int fd;
+	struct io_uring_params params;
+	void *sq;
+	size_t sq_len;
+	struct io_uring_sqe *sqes;
+	size_t sqes_len;
+	unsigned int *sq_tail, *sq_mask, *sq_array;
+	unsigned int *cq_head, *cq_tail, *cq_mask;
+	struct io_uring_cqe *cqes;
+};
+
+static int uring_setup(struct uring *r, unsigned int flags)
+{
+	size_t cq_len;
+
+	memset(r, 0, sizeof(*r));
+	r->params.flags = flags;
+	if (flags & IORING_SETUP_SQPOLL)
+		r->params.sq_thread_idle = 2000;
+	r->fd = syscall(__NR_io_uring_setup, 8, &r->params);
+	if (r->fd < 0)
+		return -1;
+	if (!(r->params.features & IORING_FEAT_SINGLE_MMAP))
+		return -1;
+
+	r->sq_len = r->params.sq_off.array + r->params.sq_entries * sizeof(unsigned int);
+	cq_len = r->params.cq_off.cqes + r->params.cq_entries * sizeof(struct io_uring_cqe);
+	if (cq_len > r->sq_len)
+		r->sq_len = cq_len;
+	r->sq = mmap(NULL, r->sq_len, PROT_READ | PROT_WRITE,
+		     MAP_SHARED | MAP_POPULATE, r->fd, IORING_OFF_SQ_RING);
+	if (r->sq == MAP_FAILED)
+		return -1;
+	r->sqes_len = r->params.sq_entries * sizeof(struct io_uring_sqe);
+	r->sqes = mmap(NULL, r->sqes_len, PROT_READ | PROT_WRITE,
+		       MAP_SHARED | MAP_POPULATE, r->fd, IORING_OFF_SQES);
+	if (r->sqes == MAP_FAILED)
+		return -1;
+
+	r->sq_tail = r->sq + r->params.sq_off.tail;
+	r->sq_mask = r->sq + r->params.sq_off.ring_mask;
+	r->sq_array = r->sq + r->params.sq_off.array;
+	r->cq_head = r->sq + r->params.cq_off.head;
+	r->cq_tail = r->sq + r->params.cq_off.tail;
+	r->cq_mask = r->sq + r->params.cq_off.ring_mask;
+	r->cqes = r->sq + r->params.cq_off.cqes;
+	return 0;
+}
+
+/* Submit one sqe, wait for its completion and return the result. */
+static int uring_submit_wait(struct uring *r, const struct io_uring_sqe *sqe)
+{
+	unsigned int tail = *r->sq_tail, idx = tail & *r->sq_mask;
+	unsigned int flags = IORING_ENTER_GETEVENTS;
+	int i;
+
+	r->sqes[idx] = *sqe;
+	r->sq_array[idx] = idx;
+	__atomic_store_n(r->sq_tail, tail + 1, __ATOMIC_RELEASE);
+
+	if (r->params.flags & IORING_SETUP_SQPOLL)
+		flags |= IORING_ENTER_SQ_WAKEUP;
+
+	for (i = 0; i < 100; i++) {
+		if (syscall(__NR_io_uring_enter, r->fd, 1, 1, flags, NULL, 0) < 0 &&
+		    errno != EINTR)
+			return -1;
+		if (__atomic_load_n(r->cq_tail, __ATOMIC_ACQUIRE) != *r->cq_head) {
+			unsigned int head = *r->cq_head;
+			int res = r->cqes[head & *r->cq_mask].res;
+
+			__atomic_store_n(r->cq_head, head + 1, __ATOMIC_RELEASE);
+			return res;
+		}
+		flags &= ~IORING_ENTER_SQ_WAKEUP;
+		usleep(10 * 1000);
+	}
+	return -1;
+}
+
+static bool uring_available(unsigned int flags)
+{
+	struct io_uring_params params = { .flags = flags };
+	int fd;
+
+	fd = syscall(__NR_io_uring_setup, 2, &params);
+	if (fd < 0)
+		return false;
+	close(fd);
+	return true;
+}
+
+/*
+ * Keep a ring, an idle io-wq worker and with SQPOLL an SQPOLL thread
+ * alive. The last worker of a ring never exits on its idle timeout.
+ */
+static void worker_child(bool sqpoll, int fd_ipc)
+{
+	struct rlimit rl = { RLIM_INFINITY, RLIM_INFINITY };
+	struct io_uring_sqe sqe = {};
+	static char buf[64];
+	struct uring ring;
+	int memfd;
+
+	if (setrlimit(RLIMIT_CORE, &rl))
+		_exit(EXIT_FAILURE);
+
+	memfd = memfd_create("coredump_worker", 0);
+	if (memfd < 0 || write(memfd, "hello", 5) != 5)
+		_exit(EXIT_FAILURE);
+
+	if (uring_setup(&ring, sqpoll ? IORING_SETUP_SQPOLL : 0))
+		_exit(EXIT_FAILURE);
+
+	/* IOSQE_ASYNC forces the read through io-wq so a worker appears. */
+	sqe.opcode = IORING_OP_READ;
+	sqe.fd = memfd;
+	sqe.addr = (__u64)(uintptr_t)buf;
+	sqe.len = sizeof(buf);
+	sqe.flags = IOSQE_ASYNC;
+	if (uring_submit_wait(&ring, &sqe) != 5)
+		_exit(EXIT_FAILURE);
+
+	if (write_nointr(fd_ipc, "1", 1) != 1)
+		_exit(EXIT_FAILURE);
+	close(fd_ipc);
+
+	for (;;)
+		pause();
+}
+
+/* Find the thread of @pid whose comm starts with @prefix. */
+static pid_t find_thread(pid_t pid, const char *prefix)
+{
+	char path[64], comm[64];
+	pid_t tid = -1;
+	struct dirent *de;
+	ssize_t bytes;
+	DIR *dir;
+	int fd;
+
+	snprintf(path, sizeof(path), "/proc/%d/task", pid);
+	dir = opendir(path);
+	if (!dir)
+		return -1;
+
+	while (tid < 0 && (de = readdir(dir))) {
+		if (!isdigit(de->d_name[0]))
+			continue;
+		snprintf(path, sizeof(path), "/proc/%d/task/%s/comm", pid, de->d_name);
+		fd = open(path, O_RDONLY | O_CLOEXEC);
+		if (fd < 0)
+			continue;
+		bytes = read(fd, comm, sizeof(comm) - 1);
+		close(fd);
+		if (bytes <= 0)
+			continue;
+		comm[bytes] = '\0';
+		if (!strncmp(comm, prefix, strlen(prefix)))
+			tid = atoi(de->d_name);
+	}
+	closedir(dir);
+	return tid;
+}
+
+/*
+ * Attach, stop the thread with SIGSTOP, drop the signal mask that
+ * copy_process() gave it and resume it with SIGSEGV instead.
+ */
+static bool inject_coredump_signal(pid_t pid, pid_t tid)
+{
+	__u64 mask = 0;
+	int status;
+
+	if (ptrace(PTRACE_SEIZE, tid, NULL, NULL))
+		return false;
+	if (syscall(SYS_tgkill, pid, tid, SIGSTOP))
+		return false;
+	if (waitpid(tid, &status, __WALL) != tid)
+		return false;
+	if (!WIFSTOPPED(status) || WSTOPSIG(status) != SIGSTOP)
+		return false;
+	if (ptrace(PTRACE_SETSIGMASK, tid, sizeof(mask), &mask))
+		return false;
+	return !ptrace(PTRACE_DETACH, tid, NULL, (void *)(long)SIGSEGV);
+}
+
+/* Reap @pid within @timeout_ms, -1 when it is still there. */
+static int wait_exit(pid_t pid, int *status, int timeout_ms)
+{
+	int i;
+
+	for (i = 0; i < timeout_ms / 10; i++) {
+		pid_t ret = waitpid(pid, status, WNOHANG);
+
+		if (ret == pid)
+			return 0;
+		if (ret < 0)
+			return -1;
+		usleep(10 * 1000);
+	}
+	return -1;
+}
+
+static void log_threads(struct __test_metadata *const _metadata, pid_t pid)
+{
+	char path[64], line[256], comm[64] = {};
+	struct dirent *de;
+	DIR *dir;
+	FILE *f;
+
+	snprintf(path, sizeof(path), "/proc/%d/task", pid);
+	dir = opendir(path);
+	if (!dir)
+		return;
+	while ((de = readdir(dir))) {
+		if (!isdigit(de->d_name[0]))
+			continue;
+		snprintf(path, sizeof(path), "/proc/%d/task/%s/status", pid, de->d_name);
+		f = fopen(path, "r");
+		if (!f)
+			continue;
+		while (fgets(line, sizeof(line), f)) {
+			line[strcspn(line, "\n")] = '\0';
+			if (!strncmp(line, "Name:", 5))
+				snprintf(comm, sizeof(comm), "%s", line + 6);
+			else if (!strncmp(line, "State:", 6))
+				TH_LOG("tid %s (%s) %s", de->d_name, comm, line + 7);
+		}
+		fclose(f);
+	}
+	closedir(dir);
+}
+
+enum dumper {
+	DUMPER_MAIN,
+	DUMPER_WORKER,
+	DUMPER_SQPOLL,
+};
+
+static void run_dumper(struct __test_metadata *const _metadata, bool sqpoll,
+		       enum dumper dumper)
+{
+	bool killed = false;
+	char path[64], c;
+	int ipc[2], status, fd;
+	pid_t pid, tid;
+
+	ASSERT_TRUE(set_core_pattern("/tmp/coredump.file.%p"));
+	ASSERT_EQ(pipe2(ipc, O_CLOEXEC), 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+	if (pid == 0) {
+		close(ipc[0]);
+		worker_child(sqpoll, ipc[1]);
+	}
+	close(ipc[1]);
+	ASSERT_EQ(read_nointr(ipc[0], &c, 1), 1);
+	close(ipc[0]);
+
+	switch (dumper) {
+	case DUMPER_MAIN:
+		tid = pid;
+		break;
+	case DUMPER_WORKER:
+		tid = find_thread(pid, "iou-wrk-");
+		break;
+	case DUMPER_SQPOLL:
+		tid = find_thread(pid, "iou-sqp-");
+		break;
+	}
+	ASSERT_GT(tid, 0);
+	ASSERT_TRUE(inject_coredump_signal(pid, tid));
+
+	if (wait_exit(pid, &status, EXIT_TIMEOUT_MS)) {
+		/* No dump. Whatever happened, SIGKILL must still work. */
+		log_threads(_metadata, pid);
+		kill(pid, SIGKILL);
+		killed = true;
+		ASSERT_EQ(wait_exit(pid, &status, EXIT_TIMEOUT_MS), 0) {
+			TH_LOG("thread group %d is stuck after SIGSEGV to tid %d",
+			       pid, tid);
+		}
+	}
+
+	ASSERT_TRUE(WIFSIGNALED(status));
+	if (killed) {
+		TH_LOG("tid %d did not dump, the group was killed instead", tid);
+		ASSERT_EQ(WTERMSIG(status), SIGKILL);
+		return;
+	}
+	ASSERT_EQ(WTERMSIG(status), SIGSEGV);
+	ASSERT_TRUE(WCOREDUMP(status));
+
+	snprintf(path, sizeof(path), "/tmp/coredump.file.%d", pid);
+	fd = open(path, O_RDONLY | O_CLOEXEC);
+	unlink(path);
+	ASSERT_GE(fd, 0);
+	ASSERT_TRUE(check_coredump_extent(fd));
+	close(fd);
+}
+
+/* The mechanics: an injected SIGSEGV into a normal thread dumps core. */
+TEST_F(coredump, main_thread_dumper)
+{
+	if (!uring_available(0))
+		SKIP(return, "io_uring is not available");
+	run_dumper(_metadata, false, DUMPER_MAIN);
+}
+
+TEST_F(coredump, plain_worker_dumper)
+{
+	if (!uring_available(0))
+		SKIP(return, "io_uring is not available");
+	run_dumper(_metadata, false, DUMPER_WORKER);
+}
+
+TEST_F(coredump, sqpoll_thread_dumper)
+{
+	if (!uring_available(IORING_SETUP_SQPOLL))
+		SKIP(return, "io_uring SQPOLL is not available");
+	run_dumper(_metadata, true, DUMPER_SQPOLL);
+}
+
+/*
+ * The SQPOLL thread leaves its loop on the zap and waits for its io-wq
+ * workers to exit before it parks. The dumping worker never does.
+ */
+TEST_F(coredump, sqpoll_worker_dumper)
+{
+	if (!uring_available(IORING_SETUP_SQPOLL))
+		SKIP(return, "io_uring SQPOLL is not available");
+	run_dumper(_metadata, true, DUMPER_WORKER);
+}
+
+TEST_HARNESS_MAIN
-- 
2.53.0


