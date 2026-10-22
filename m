Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1BB7606A321
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 01:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=k2y4toCv
Received: by kanga.kvack.org (Postfix)
	id CC2FE6B0288; Wed, 21 Oct 2026 21:58:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9ADF6B0289; Wed, 21 Oct 2026 21:58:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8A306B028A; Wed, 21 Oct 2026 21:58:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 887296B0288
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:58:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EF0EB402AC
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:58:19 +0000 (UTC)
X-FDA: 85348602318.30.1F2205D
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf19.hostedemail.com (Postfix) with ESMTP id EF3C61A0002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:58:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k2y4toCv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792634298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n8r7pDVOusRHhAi6AWaHRjxliQyrc7O0YU7BolzZRrw=;
	b=o2Efa+Bbyzh0gLWyMeSANNvhv8Q/703qsvZ55xCODcVYMHP4yR0An/35126x0AfRdeF99v
	NbTVwBUK4VOE/ADcab8RW1QygI9Y+3791R0DH7kpaTDEEZPZEH4Eh+jU7hZ+wEq4gUiUoP
	T9lQX74pQRV89KiPa1hjY+dniev0REs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k2y4toCv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792634298;
	b=FasJZXqyNkcdv/hJ2E1hxxJb2hXj9IWL7iFkXMzGvuULRg+aJ4aMd5dbUxHy8GbMGU1/Hx
	2a93a2/hICZ78MJLZ0MFc0h3wtrLL0GfUKGvpaWPx9VjXHobggELK4FTdQJRhcAYmaFftG
	xS5F8Lh0hUNMIYDNYbdQ72XDrkHu+hg=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8a070755c8cso665892b3a.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792634297; x=1793239097; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n8r7pDVOusRHhAi6AWaHRjxliQyrc7O0YU7BolzZRrw=;
        b=k2y4toCv/8XFSw29Plr/eNhFE2iiJPePzePE2PvhhY5atGxV+ijz/pE420YK2asEFT
         d+5mTxralG0i2ihL01E9RfjsgT5XskTiN2vK6vWWooa5NeElrqFUUAa771hdBLgJBvlZ
         lgmQ5JMN60OzSaUpG1vcM8Oxq/3ncfQQxM3Tumxi7dJ8fW/HN/ZljJfwOYBRMHXLkNXo
         KnkwjoOmPKOb8lIbkZkjUENNOsOzO/wGCMe2Ex6oo3gysYp8rL143sMylxOsZ/ETXM3b
         EX0GRpTmOjB2nKInr08IiwS732ql1PFXlVogarTO9nsugX7Vzcz4lqPlVdybdiLW89h4
         CJ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792634297; x=1793239097;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=n8r7pDVOusRHhAi6AWaHRjxliQyrc7O0YU7BolzZRrw=;
        b=PrGmlo0qwcE0QXRRlEFNFXVxikIjyZMZQ9bx4oTRaztOfL4FXem737afUzveB1Rgiw
         qj4Ur2IB7BHW+Whz+hWRTq79XxgOqrnLXZ1LilvNxWlJ9PAkV+2ziR0oyXfBSPAlHplX
         Z9p99LylZuQMwsdMrKbyfVNT4536eUN1JTxdIR/tzLoTl/ObUD7G7Unws4ujViG7oetm
         d+VJhdGJ8rYqE1rO8UYbJWOwP7ci4sy4TuoDtJovrTZ99yMSKSUwFu7m69PealuNENVE
         A8NbOq/zL6cV2oeLYUIpD47d7Hr66BVdNSvjxw0Slj/8W6Z9h42zkP6z5J3HPCJl9VEN
         0oBg==
X-Forwarded-Encrypted: i=1; AKwUvBzh48w/g8LOW/lHFLMMFIPwXfYIG4xSWu+up0OZpBu4qGGV/ggBZ1/J+x19QVZW7uaQsglqY5fgzg==@kvack.org
X-Gm-Message-State: AFq9FYITIIyAOhF1R7MLAp/qMDcb/UpUSbg4IpEPx+rmL8lp8RfqVGWP
	gLYpfXMSvlfR7m2PK36w/pRV9HB6yreD7U2hB7stO2FbYdlK82nVj2cz
X-Gm-Gg: AYBFou0yGo0zm7QNJpZ1b3qTgs/hhZm9Dz3mba2lovaPIEq292FZEwRj/anIxXaz+MG
	2Z4S99znQKT9n71Q0GSVM2kXU+tBjgb5mNAF9dKQIZKTTxxtu7gBKPbxgzlkhihf9eriLCgCl1X
	UUUxKP9RDGwCdgyonzTKJTJF6UUfv8DF3YFRVRGPgtLo8uoOPhLnwjpANIrRFKn/E7pal77tCJt
	jHzyfk2Kz+D05El7Gj5n5HkGGGyHLg1A/+L7MxK5060xM1IZvGE7bFtiXCM+kkykAx8hckNKMQb
	PeZxPWWgoAdLy+NgGV2axdQCQKMe7/BLs9arApZtV64ByY97aOmxrFS6L8CRYP78BjkVtAiNWnl
	GES/rrXpTMf5WMBaRl29XMHZjvDvxX71yEVGd/G1cHpNddH/yQPCgB7wjm99noLHj5AIp2ulImy
	4Vbp7HATqS85+Q4FPIaTN4j5TVPMx44q1LquMRb3j7KWBA0lHMr7d9AhAjY9pyGUDIbncn5Yb2+
	NhmC3ypHfRMvIIWvelsvMlQHJyBlpyz5FhrfSOtS/I34wuQ2D4sHvrP8nbjJ8syFw/qmPVQoZSQ
	NVI2FrEpTOHo9xToI9nfNlrBd2iyt8HRcUySjmHeBMtZeLFWPH5ae35TanQKtP3HnnfhuhSoKU5
	NnmU3i/GTrJx+r7CSq4GYOu4e
X-Received: by 2002:a05:6a00:27a6:b0:878:3538:8f77 with SMTP id d2e1a72fcca58-8a089e90ad8mr3119416b3a.37.1792634296297;
        Wed, 21 Oct 2026 18:58:16 -0700 (PDT)
Received: from coder-ast-ast-dev-ml-0.tail2dda0.ts.net ([153.61.198.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a0894b37c5sm1470060b3a.11.2026.10.21.18.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 18:58:14 -0700 (PDT)
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: bpf@vger.kernel.org
Cc: daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	oleg@redhat.com,
	peterz@infradead.org,
	mhiramat@kernel.org,
	jolsa@kernel.org,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	surenb@google.com,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	hughd@google.com,
	kees@kernel.org,
	mingo@redhat.com,
	tglx@kernel.org,
	x86@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 9/9] selftests/bpf: Test uprobes and fork() with busy mmap_lock
Date: Thu, 22 Oct 2026 01:57:12 +0000
Message-ID: <20261022015712.1297331-10-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
References: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EF3C61A0002
X-Stat-Signature: qpwkhhwymfefd64xyu751az9o3hxcaiq
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792634297-786926
X-HE-Meta: U2FsdGVkX1/FLYdiJqCnm8AfvNWmC/gdSboXN3eHRivb54qGlKNpJXoaKmYpGYGzkhQsHri3fvDkhuN8lSnwi3u/15R1FF8qAvcZzbhaVdFEeyk6kYA78GTPXaY63UukG5vqDc1rLyRrU55weFV32ncmDQJtI8sZQOVhr//mp5KrmUcEc4zRGxLp3xZenpyQeozZnAQwe7L1YUIbClVe2BM+kGWy7T769idTXr4ja9uUDxNYVefHTdduPnKG0g7pyKxXuxYAUgdVL86P1+BwvBxTs47uPdksOQvHey7IH+oZafwW5FdPsgFjpkWVr4R23KkmpFyuE4F1zQL/CCrOboeWDHTSnZG9Pv15XaIQcpKvA9QryeoYnEVmpVCJPWALEzwQ613Tx91DZXEW3TjlXIOHFbgq3n8PrHQ4pg0usiBDXhKi+5rChRIvKYRbDQrRGwZ3fYLPu+FsmSchfMSFrXMJlCuVLXAcl6aqx4kBfVCB13ypZncGyI7KifmKsTkP+37lUmdbjykK05guSv+rKSSG9XJBgUXqcAQpMuaysy7RPRYhil0MlTuffNMnYwSpy1bxzYs76p0l+j39bKMMk/vCiAKmILm0USZZuWqRbu9oIm3VFKeCaULm8GppDiZ7MjJ/+CneT6tUVHXw7pTzhMN0h56Nr9z5SXciSdn1Aah010lD2jsRCt65NuSBKXf4aBwLpTIrQXXCix7B0Z0Sz0V0rTD2HKfHgbeLqReJST9qOAFx3M8tF2rOJcdUt/3pFJjjY0NF6rrOUnB/4prFKu70Fw/VQsfvDf1NOCtn0vsqM4kL50yLLj8RBaUgGcaA8BKAGeSGWmCVBhgbmldTPQNOqW7nIE8/7mRDnkZfQIafv+Gu3akrhF1mdTgGSu9E/UFYYil1g6hiKlSxP/U4xAvr4TBjS1UgIPbGkm6m1K/VvFECxWtTvGP3J76KZ3MTHpDVdjbUSEF4alZszxj
 jJ4r0jUB
 WFUq8avFgDQMK20sn+jt3pKqN/2TefxjXMVpu3v7z8DE5aY8jQOas4y8vc4snhJce+JDvNiWC3rrZ2/p5MyTkmy/DbnvrsJpHdfVwP+XbsoEV6voXuuWrMo1Ltyag8O65IRbHQUsExa28AR/bAUANX0X8W/6Rx+tm1mpiG6OtXE+HoE2TrX5eGD6o47cYhLVt5XNUZNCQB11BMND3m/yU483ENKIwMa0rcuzSyrZGnopREJuRoL3adMlv1y5kLouuKvry3rEvSCa03SGEy3n3nGXJ/uLXm4LX8aTqKpr1sZhMuxzHOVpwQKGXBEbk4Uxj79U4oW15uQRTWOQT2Vp/bi+fKej1nZCLj0NmevoLU2TUh0pnQf+iCLItPqDBzyhEBeL3fmrDf4IgUlp9XbggkmBsu01NTAaCc9u7QxI/IiDSdIWJpbjk1fTP8KEuR+37Cm45RMwB3W55akdVDKZsu+CpDv7+BRk1ewwMU4s2R3wENwO/fNjGHL8d/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Alexei Starovoitov <ast@kernel.org>

A process keeps its mmap_lock busy with MADV_POPULATE_READ of a large
read-only anonymous area. It maps zero page, so it costs page tables only.

- fork_multi, fork_perf: the busy process forks while uprobe is attached
  and detached. When attach is over the child has the breakpoint. When
  detach is over the child doesn't have it, and can call the function.
- fork_not_blocked: fork() of another process returns while attach is
  waiting for mmap_lock of the busy process.
- attach_not_blocked: attach to the file that the busy process doesn't map
  returns while fork() of the busy process is waiting for its mmap_lock.

The last two compare the order of events, not the time they take.

The test is serial. The busy process maps test_progs, so it would delay
uprobe attaches of other workers.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 .../selftests/bpf/prog_tests/uprobe_busy_mm.c | 447 ++++++++++++++++++
 .../selftests/bpf/progs/uprobe_busy_mm.c      |  22 +
 2 files changed, 469 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/uprobe_busy_mm.c
 create mode 100644 tools/testing/selftests/bpf/progs/uprobe_busy_mm.c

diff --git a/tools/testing/selftests/bpf/prog_tests/uprobe_busy_mm.c b/tools/testing/selftests/bpf/prog_tests/uprobe_busy_mm.c
new file mode 100644
index 000000000000..30614e8b92cd
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/uprobe_busy_mm.c
@@ -0,0 +1,447 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Attach and detach uprobes while a process keeps its mmap_lock busy.
+ * Other processes should be able to fork, and children of the busy process
+ * should have the same breakpoints as everybody else.
+ */
+#include <pthread.h>
+#include <sys/mman.h>
+#include <sys/prctl.h>
+#include <sys/wait.h>
+#include <test_progs.h>
+#include "bpf/libbpf_internal.h"
+#include "uprobe_busy_mm.skel.h"
+
+#ifndef MADV_POPULATE_READ
+#define MADV_POPULATE_READ 22
+#endif
+
+#define LOAD(x)		__atomic_load_n(&(x), __ATOMIC_SEQ_CST)
+#define STORE(x, v)	__atomic_store_n(&(x), v, __ATOMIC_SEQ_CST)
+#define INC(x)		__atomic_add_fetch(&(x), 1, __ATOMIC_SEQ_CST)
+
+#define AREA_MAX	(64UL << 30)
+#define AREA_MIN	(64UL << 20)
+#define MAX_CHILDREN	8
+#define MAX_TRIES	10
+#define TIMEOUT_NS	(30 * 1000000000ULL)
+
+struct shared {
+	/* written by the test */
+	int stop;
+	int gen;		/* odd while attach or detach is in progress */
+	int attached;
+	int hold_ms;
+	bool do_fork;
+	char insn[4];
+	/* written by the busy process */
+	int ready;
+	int hold_seq;		/* number of times mmap_lock was let go */
+	__u64 hold_ns;		/* for how long it was held the last time */
+	int in_hold;
+	int in_fork;
+	int forks;		/* number of times fork() returned */
+	int errors;
+	int checked[2];		/* children that checked their breakpoint, by ->attached */
+};
+
+static struct shared *sh;
+
+static noinline void uprobe_busy_mm_func(void)
+{
+	asm volatile ("");
+}
+
+static __u64 now_ns(void)
+{
+	struct timespec ts;
+
+	clock_gettime(CLOCK_MONOTONIC, &ts);
+	return ts.tv_sec * 1000000000ULL + ts.tv_nsec;
+}
+
+/*
+ * MADV_POPULATE_READ holds mmap_lock for reading while it maps zero page
+ * all over the area. It costs page tables only.
+ */
+static void *hold_mmap_lock(void *arg)
+{
+	size_t size = AREA_MIN;
+	void *area;
+	__u64 t;
+
+	area = mmap(NULL, AREA_MAX, PROT_READ, MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
+	if (area == MAP_FAILED)
+		goto err;
+	/* EINVAL without CONFIG_TRANSPARENT_HUGEPAGE */
+	madvise(area, AREA_MAX, MADV_NOHUGEPAGE);
+
+	t = now_ns();
+	if (madvise(area, size, MADV_POPULATE_READ))
+		goto err;
+	t = now_ns() - t;
+	size *= sh->hold_ms * 1000000ULL / t + 1;
+	if (size > AREA_MAX)
+		size = AREA_MAX;
+
+	while (!LOAD(sh->stop)) {
+		STORE(sh->in_hold, 1);
+		t = now_ns();
+		madvise(area, size, MADV_POPULATE_READ);
+		/* before anything that can fault and wait for fork() */
+		INC(sh->hold_seq);
+		STORE(sh->hold_ns, now_ns() - t);
+		STORE(sh->in_hold, 0);
+		madvise(area, size, MADV_DONTNEED);
+		STORE(sh->ready, 1);
+	}
+	return NULL;
+err:
+	INC(sh->errors);
+	STORE(sh->ready, 1);
+	return NULL;
+}
+
+/*
+ * fork() began while attach or detach was in progress.
+ * When it's over the child should be like other processes.
+ */
+static int child(int gen)
+{
+	bool attached, bp;
+
+	prctl(PR_SET_PDEATHSIG, SIGKILL);
+	if (!(gen & 1))
+		return 0;
+	gen++;
+
+	while (LOAD(sh->gen) < gen) {
+		if (LOAD(sh->stop))
+			return 0;
+		usleep(100);
+	}
+
+	attached = LOAD(sh->attached);
+	bp = memcmp((void *)uprobe_busy_mm_func, sh->insn, sizeof(sh->insn));
+	if (LOAD(sh->gen) != gen)
+		return 0;
+	if (bp != attached)
+		return 1;
+
+	/* SIGTRAP when there is a breakpoint without uprobe */
+	uprobe_busy_mm_func();
+	if (LOAD(sh->gen) == gen)
+		INC(sh->checked[attached]);
+	return 0;
+}
+
+static void busy_process(void)
+{
+	int status, gen, nr = 0;
+	pthread_t thread;
+	pid_t pid;
+
+	prctl(PR_SET_PDEATHSIG, SIGKILL);
+	if (pthread_create(&thread, NULL, hold_mmap_lock, NULL)) {
+		INC(sh->errors);
+		STORE(sh->ready, 1);
+		_exit(1);
+	}
+
+	while (sh->do_fork && !LOAD(sh->stop)) {
+		while (nr && waitpid(-1, &status, nr < MAX_CHILDREN ? WNOHANG : 0) > 0) {
+			if (status)
+				INC(sh->errors);
+			nr--;
+		}
+
+		gen = LOAD(sh->gen);
+		STORE(sh->in_fork, 1);
+		pid = fork();
+		if (!pid)
+			_exit(child(gen));
+		INC(sh->forks);
+		STORE(sh->in_fork, 0);
+		if (pid < 0) {
+			INC(sh->errors);
+			break;
+		}
+		nr++;
+	}
+
+	while (nr-- && wait(&status) > 0)
+		if (status)
+			INC(sh->errors);
+	pthread_join(thread, NULL);
+	_exit(0);
+}
+
+/* The busy process gave up or is gone */
+static bool busy_process_failed(pid_t pid)
+{
+	siginfo_t si = {};
+
+	return LOAD(sh->errors) ||
+	       waitid(P_PID, pid, &si, WEXITED | WNOHANG | WNOWAIT) || si.si_pid;
+}
+
+static pid_t start_busy_process(int hold_ms, bool do_fork)
+{
+	__u64 t = now_ns();
+	pid_t pid;
+
+	sh = mmap(NULL, sizeof(*sh), PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+	if (!ASSERT_NEQ(sh, MAP_FAILED, "mmap"))
+		return -1;
+
+	sh->hold_ms = hold_ms;
+	sh->do_fork = do_fork;
+	memcpy(sh->insn, (void *)uprobe_busy_mm_func, sizeof(sh->insn));
+
+	pid = fork();
+	if (!ASSERT_GE(pid, 0, "fork")) {
+		munmap(sh, sizeof(*sh));
+		return -1;
+	}
+	if (!pid)
+		busy_process();
+
+	while (!LOAD(sh->ready) && !busy_process_failed(pid) && now_ns() - t < TIMEOUT_NS)
+		usleep(1000);
+	if (!ASSERT_TRUE(LOAD(sh->ready), "busy_process_ready")) {
+		kill(pid, SIGKILL);
+		waitpid(pid, NULL, 0);
+		munmap(sh, sizeof(*sh));
+		return -1;
+	}
+	return pid;
+}
+
+static void stop_busy_process(pid_t pid)
+{
+	int status = -1;
+
+	STORE(sh->stop, 1);
+	waitpid(pid, &status, 0);
+	ASSERT_EQ(status, 0, "busy_process_status");
+	ASSERT_EQ(sh->errors, 0, "errors");
+	munmap(sh, sizeof(*sh));
+}
+
+/* Returns hold_seq of the hold that has just begun, -1 if there won't be one */
+static int wait_for_hold(pid_t pid, bool in_fork)
+{
+	__u64 t = now_ns();
+	int seq;
+
+	while (!busy_process_failed(pid) && now_ns() - t < TIMEOUT_NS) {
+		if (!LOAD(sh->in_hold) || (in_fork && !LOAD(sh->in_fork))) {
+			usleep(100);
+			continue;
+		}
+		seq = LOAD(sh->hold_seq);
+		/* let them get into the kernel */
+		usleep(10000);
+		if (LOAD(sh->hold_seq) == seq && (!in_fork || LOAD(sh->in_fork)))
+			return seq;
+	}
+
+	return -1;
+}
+
+static struct bpf_link *attach(struct uprobe_busy_mm *skel, bool multi,
+			       const char *path, unsigned long offset)
+{
+	LIBBPF_OPTS(bpf_uprobe_multi_opts, opts, .offsets = &offset, .cnt = 1);
+
+	if (multi)
+		return bpf_program__attach_uprobe_multi(skel->progs.probe_multi, -1, path,
+							NULL, &opts);
+	return bpf_program__attach_uprobe(skel->progs.probe_perf, false, -1, path, offset);
+}
+
+/*
+ * Wait for a child to check its breakpoint in this state. fork() that began
+ * during attach or detach may sleep until the next hold is over.
+ */
+static void wait_for_check(int attached, int checked)
+{
+	__u64 t = now_ns(), max = 2 * LOAD(sh->hold_ns) + 100 * 1000000ULL;
+
+	while (LOAD(sh->checked[attached]) == checked && now_ns() - t < max)
+		usleep(1000);
+}
+
+static void test_fork(struct uprobe_busy_mm *skel, bool multi)
+{
+	struct bpf_link *link;
+	ssize_t offset;
+	int i, checked;
+	pid_t pid;
+	__u64 t;
+
+	offset = get_uprobe_offset(&uprobe_busy_mm_func);
+	if (!ASSERT_GE(offset, 0, "get_uprobe_offset"))
+		return;
+
+	pid = start_busy_process(20, true);
+	if (pid < 0)
+		return;
+	skel->bss->hits = 0;
+	t = now_ns();
+
+	for (i = 0; !busy_process_failed(pid) && now_ns() - t < TIMEOUT_NS; i++) {
+		if (i >= 10 && LOAD(sh->checked[0]) && LOAD(sh->checked[1]))
+			break;
+
+		checked = LOAD(sh->checked[1]);
+		INC(sh->gen);
+		link = attach(skel, multi, "/proc/self/exe", offset);
+		if (!ASSERT_OK_PTR(link, "attach"))
+			break;
+		STORE(sh->attached, 1);
+		INC(sh->gen);
+		wait_for_check(1, checked);
+
+		checked = LOAD(sh->checked[0]);
+		INC(sh->gen);
+		bpf_link__destroy(link);
+		STORE(sh->attached, 0);
+		INC(sh->gen);
+		wait_for_check(0, checked);
+	}
+
+	ASSERT_GT(LOAD(sh->checked[1]), 0, "checked_attached");
+	ASSERT_GT(LOAD(sh->checked[0]), 0, "checked_detached");
+	ASSERT_GE(skel->bss->hits, LOAD(sh->checked[1]), "hits");
+	stop_busy_process(pid);
+}
+
+struct attach_args {
+	struct uprobe_busy_mm *skel;
+	unsigned long offset;
+	struct bpf_link *link;
+	int done;
+};
+
+static void *attach_thread(void *arg)
+{
+	struct attach_args *args = arg;
+
+	args->link = attach(args->skel, true, "/proc/self/exe", args->offset);
+	STORE(args->done, 1);
+	return NULL;
+}
+
+/* fork() doesn't wait for attach that waits for mmap_lock of the busy process */
+static void test_fork_not_blocked(struct uprobe_busy_mm *skel)
+{
+	struct attach_args args = { .skel = skel };
+	pid_t pid, child_pid;
+	bool ok = false;
+	pthread_t thread;
+	ssize_t offset;
+	int i, seq;
+
+	offset = get_uprobe_offset(&uprobe_busy_mm_func);
+	if (!ASSERT_GE(offset, 0, "get_uprobe_offset"))
+		return;
+	args.offset = offset;
+
+	pid = start_busy_process(300, false);
+	if (pid < 0)
+		return;
+
+	for (i = 0; i < MAX_TRIES && !ok && !LOAD(sh->errors); i++) {
+		seq = wait_for_hold(pid, false);
+		if (!ASSERT_GE(seq, 0, "wait_for_hold"))
+			break;
+
+		args.done = 0;
+		if (!ASSERT_OK(pthread_create(&thread, NULL, attach_thread, &args),
+			       "pthread_create"))
+			break;
+		/* attach waits for RCU first, fork() isn't blocked by that */
+		usleep(LOAD(sh->hold_ns) / 2000);
+
+		child_pid = fork();
+		if (!child_pid)
+			_exit(0);
+		ok = child_pid > 0 && !LOAD(args.done) && LOAD(sh->hold_seq) == seq;
+		if (child_pid > 0)
+			waitpid(child_pid, NULL, 0);
+
+		pthread_join(thread, NULL);
+		if (!ASSERT_OK_PTR(args.link, "attach"))
+			break;
+		bpf_link__destroy(args.link);
+	}
+
+	ASSERT_TRUE(ok, "fork_not_blocked");
+	stop_busy_process(pid);
+}
+
+/* attach doesn't wait for fork() that waits for mmap_lock of the busy process */
+static void test_attach_not_blocked(struct uprobe_busy_mm *skel)
+{
+	const char *path = "./uprobe_multi", *sym = "uprobe_multi_func_00000";
+	unsigned long *offsets = NULL;
+	struct bpf_link *link;
+	bool ok = false;
+	int i, seq, forks;
+	pid_t pid;
+
+	if (!ASSERT_OK(elf_resolve_syms_offsets(path, 1, &sym, &offsets, STT_FUNC),
+		       "elf_resolve_syms_offsets"))
+		return;
+
+	pid = start_busy_process(300, true);
+	if (pid < 0)
+		goto out;
+
+	for (i = 0; i < MAX_TRIES && !ok && !LOAD(sh->errors); i++) {
+		seq = wait_for_hold(pid, true);
+		if (!ASSERT_GE(seq, 0, "wait_for_hold"))
+			break;
+
+		forks = LOAD(sh->forks);
+
+		link = attach(skel, true, path, offsets[0]);
+		/*
+		 * attach that waited for fork() returns as soon as fork() has
+		 * copied mm, maybe before the busy process bumps forks and
+		 * hold_seq. Give it a quarter of the hold to do that.
+		 */
+		usleep(LOAD(sh->hold_ns) / 4000);
+		ok = LOAD(sh->in_fork) && LOAD(sh->forks) == forks &&
+		     LOAD(sh->hold_seq) == seq;
+		if (!ASSERT_OK_PTR(link, "attach"))
+			break;
+		bpf_link__destroy(link);
+	}
+
+	ASSERT_TRUE(ok, "attach_not_blocked");
+	stop_busy_process(pid);
+out:
+	free(offsets);
+}
+
+void serial_test_uprobe_busy_mm(void)
+{
+	struct uprobe_busy_mm *skel;
+
+	skel = uprobe_busy_mm__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "uprobe_busy_mm__open_and_load"))
+		return;
+
+	if (test__start_subtest("fork_multi"))
+		test_fork(skel, true);
+	if (test__start_subtest("fork_perf"))
+		test_fork(skel, false);
+	if (test__start_subtest("fork_not_blocked"))
+		test_fork_not_blocked(skel);
+	if (test__start_subtest("attach_not_blocked"))
+		test_attach_not_blocked(skel);
+
+	uprobe_busy_mm__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/uprobe_busy_mm.c b/tools/testing/selftests/bpf/progs/uprobe_busy_mm.c
new file mode 100644
index 000000000000..c07a9961db13
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/uprobe_busy_mm.c
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+__u64 hits;
+
+SEC("uprobe.multi")
+int probe_multi(struct pt_regs *ctx)
+{
+	__sync_fetch_and_add(&hits, 1);
+	return 0;
+}
+
+SEC("uprobe")
+int probe_perf(struct pt_regs *ctx)
+{
+	__sync_fetch_and_add(&hits, 1);
+	return 0;
+}
-- 
2.55.0


