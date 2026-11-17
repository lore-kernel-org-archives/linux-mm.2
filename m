Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0DF560A3810
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=v/loGHrK
Received: by kanga.kvack.org (Postfix)
	id DD39B6B05B4; Tue, 17 Nov 2026 11:17:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D36616B05B0; Tue, 17 Nov 2026 11:17:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFC1A6B05BB; Tue, 17 Nov 2026 11:17:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 925F16B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:17:24 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 10ECD1C3CF8
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:24 +0000 (UTC)
X-FDA: 85445116008.09.29B0A84
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf12.hostedemail.com (Postfix) with ESMTP id 729CE40009
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:17:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="v/loGHrK";
	spf=pass (imf12.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794932242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Y/ijzipXaXnoXOLHV52Sh9vsSMoQjLwzHp6q5TSfpno=;
	b=gWHfgO2hy3my+Nd8O9KE4ZFUUSL3BDwnstNbd4vglTg4grjbBd2cDRZ5iO0my/tA0NKlgF
	bjR2buRoRKG47EnlrOSdC2WqYwFWiaQw6m8s5WeayS6iOv3n8wu7GMtTaHKukiaWVUn3gA
	YrUYSqAdQOrYvNQl9+EbROVW7BpF7/s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794932242;
	b=apPn9TWYdc4jFwmax94uAT3tob49J5UhPkWQ113n0DZyTai/gECl0EW5yOxKmahkErBLe6
	yeDrA1hJGd8s3WsK+SJpt4vVCyNDZHbcHAS6O6S2PSJVtSDf2ZMjooAtbHORBfuR3Xtefb
	wuixmpyisE4F7gFVL6bPgjrtovo7Rbw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="v/loGHrK";
	spf=pass (imf12.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794932241;
	bh=Y/ijzipXaXnoXOLHV52Sh9vsSMoQjLwzHp6q5TSfpno=;
	h=From:To:Cc:Subject:Date:From;
	b=v/loGHrKnnGsv0sMIlOTpNV9tuB/Zn+gINtQpAYdGamDd/kFJ5UAS5mWDUYeEVEF7
	 3ag6Uty5k/BEUOV/S9xW7MaT9vJPWlZUCKdpD97gOqyaia2Tsd0GvlKL08whypTaoj
	 VCBvfl1GHcPfNYNqNIy5dpNCdIPUAVi3DcVSLFgpHozrFVInrHnOJzRuhvn3qa/Bul
	 SXXD2W4RFiuiP8EKXR5pqdNy3/CVrTnxua2HHPH/8mUqXPn/JX/i33OLz82zo1PXs3
	 hWVhLACdkUiq6Ilohsu2ixlICroZX6ZoPbQSNY+qAODWMzwx3j/JH/7OFwz1DrEE1T
	 ZBkmTkD8Nj02g==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTVHj2dxpzR8M;
	Tue, 17 Nov 2026 11:17:21 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: tglx@kernel.org,
	peterz@infradead.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	paulmck@kernel.org,
	boqun@kernel.org,
	shuah@kernel.org,
	kees@kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	oleg@redhat.com,
	bestswngs@gmail.com,
	xmei5@asu.edu,
	xujiakai24@mails.ucas.ac.cn,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 00/17] sched/mmcid: fixes for execve, mode switches and affinity
Date: Tue, 17 Nov 2026 11:17:00 -0500
Message-Id: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3wiijzbddaqu95t54dsbwyzyk8sycqyg
X-Rspam-User: 
X-Rspamd-Queue-Id: 729CE40009
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794932242-163923
X-HE-Meta: U2FsdGVkX19E5/ugAfHfEANAfSYQWZCUAxS2PBznSoS8Y4z3tHe81dv6ymFmV5+FJrXU7IAjzzs12FyBc+zjXRbL0sgTbFc9wnOPN0X6WNH2ti1RcJunJlL/kFMuw649d9CgS7hS5RXG/4z+xcJ4Jn2ix7HgLN/OgijzgUKkT85JEgTHOM+W6GVJKgKXYzv9BcW5kZmJGpsx/zsr9nq1w0R9kweUfxvXfsFb16NASRqJdD6UmSaRzBYJ11yxyUaUWz9mDi1uHbSu2nL6MsI8W37QAlidTZ85NGZBrwaLu6S5iVmePPYyzIZk2W0H0BbuHUbmXifCfR59fu3DYX0tAXP1RS4AQ33QwZKEaHO/b/vYt57U/Szn9avMy2WSkDsmmgixJXYa2+9eDNbfENGBA5fqb6bQqh5+LWs2tL/Dmx0cnT78gb8iNuy5Xov+XGjJQ25D4R0BKem4lTYFhMShjJyuhEh6834DYGFVgahRg+LAYahJLk4YNUDTUgmkJtxdxzzMYsqcIkk/P8gqPGX8GQ3FctoY1iA7BXXchdeZWyvHyyWUy3GY1+xDxx/vyPcf9lHHPDXdwf+d0tyaMrWJXlm+UOXYlGZIJd3wr9rv0gTvZ6FEbXSnOO6g2TRMrLJKyxaogpQzyR0lK45kx8GZmHEnuvq9l/Mh44AwhPSVnRxIFxgLY/GP76fdkwRcrmzrs2cs9bgX7NJf/R06Tg0DGUUmNGjUzGOWH7LzaOyofjR6LoSIXmsy6o7zVPBbVJm7MlUUURkfeeBBI2dPrWreIpjQ7EuG16ohmBlM1QgpKlWBL0TNg86F7BGbLG9WwhtQyzwpedv3LpqYjaX7pxdFQjHb5rtY8bJl61MGEdWAhfC+WDYI/Q0llXj8e35y70MYVhw9qIWt+LMCVaMjWlPlzEtgMe113ap5ZCDx0/QsqgwKioUOgMoEzergsk954AXSf2SEneyv3wBWYdxoH4E
 YxmcoAwy
 N0/UflIceMk8FqRTSsxOMYh82LTCraOu98b/HM68AwP3mjpMATzfBdx4rSzlFnWcxeJw1voa10Poc8XrYEwncemefbNQt9F4VqolpuhUA9zxtd1Mm7dwKkxHYvOBbNr1cWPiqHxBFKp+m9BSreJo1/LZfCDkEpK8IMImEmciHEAS1UOPtjvxj8SMfmdkNtYpOcJ1+Leum3O6nfjYOVQbQEri3cQb4viROzpatr1njRVyoM4Mm9bSG6V9c6U0WarKnU8wv9e8rPT2rY4h1vvhLwAhpLDavEuQ9EbAAUyZQ/Io8Qv+IcvI1VOZB3yjqHqH0ZHXGDj0wo4ghcf2+08t9C6RnB9AAUuBIP8Zx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Thomas, Peter,

This series fixes six problems of the rseq concurrency IDs (mm_cid),
and adds selftests for them. I looked for cases the existing tests do
not reach:
- a thread count that goes up and down;
- exit, fork and a failed execve();
- affinity changes made by another process.

The fixes come first, and all six are marked for stable:

  1  Give a CID to a task that joins its mm while running. A failed
     execve() then no longer returns to user space with an mm_cid of
     0x80000000.
  2  Give no CID to io_uring and vhost workers, so that they do not
     take IDs from the threads of the process.
  3  Reset the stale per CPU state of an mm when its first user joins.
     A machine with two or three CPUs no longer locks up after a failed
     execve().
  4  Keep a running joiner inactive until the fixups are done, so that
     it cannot loop in mm_get_cid() while it holds mm_cid.mutex.
  5  Add the allowed CPUs of the first user to the mm when it joins.
     An affinity change by another task during execve() is then not
     lost.
  6  Fix the use after free of the old mm in set_cpus_allowed_common().

The tests, all in tools/testing/selftests/rseq. Tests 7, 8, 12 and 17
fail without the fix they check:

  7  mm_cid_execve_test: the mm_cid after a failed execve(). For patch
     1.
  8  The last user fails execve() on another CPU. For patch 3, on
     guests with 2 and 3 CPUs.
  9  mm_cid_transition_test: threads count per mm_cid while the thread
     count crosses the mode thresholds.
 10  mm_cid_bound_test: the largest mm_cid stays below the possible
     CPUs. It prints how far the IDs go above the max_cids target.
 11  A transition case: affinity changes made by another process.
 12  mm_cid_exec_affinity_test. For patch 5, on guests with 4 to 64
     CPUs.
 13  Transition cases: threads created by several threads at once, and
     threads migrated by another process.
 14  A bound case: the IDs after the affinity is widened. It prints
     when they are not compact.
 15  mm_cid_window_test: two directed cases for mode switch windows.
     For patch 4, see the last point below.
 16  mm_cid_teardown_test, for patch 6.
 17  A second case for patch 3, see the first point below.

Points I would like your opinion on:
- Patch 3. Thomas, this is your cleanup from the thread "[PATCH]
  sched/mmcid: Bound the CID allocation busy wait", which you preferred
  to my fix. I wrote its subject and changelog. Change them as you see
  fit. Without your Signed-off-by, the patch carries my name, with an
  Originally-by: tag for you. If you send your Signed-off-by, I will
  make you its author. Three remarks on the code:
  - From patch 5 on, the cleanup runs in sched_mm_cid_add_first_user(),
    under t->pi_lock and mm_cid.lock. Its loop over the possible CPUs
    then runs with interrupts off. It could move out of the raw locks:
    mm_cid.mutex is held and the mm has no user.
  - The cleanup copies the allowed CPUs of the task when the mode is
    not 0. Patch 5 adds them at every first join. One of the two is
    enough.
  - The stale state is not limited to two or three possible CPUs.
    mm_cid_calc_pcpu_thrs() also returns 1 when the mm counts one
    allowed CPU. Test 17 gets a CID leaked that way on guests with 4, 8
    and 64 CPUs. It needs an affinity change that the mm missed during
    an execve(). So it fails only without both patch 3 and patch 5. I
    reproduced the lockup itself with two and three possible CPUs only.
  I did not show that this lockup is the splat of that thread.
- Patch 5 has Fixes: b0c3d51b54f8. Part of its window is older and
  dates from commit 7e019dcc470f ("sched: Improve cache locality of
  RSEQ concurrency IDs for intermittent workloads").
- Test 15 passes on a kernel without the two fixes it targets: its
  windows are a few instructions wide. It fails there only when the
  kernel makes the chosen thread sleep in the window. I did that with a
  local debug prctl(), which is not in this series. The test marks the
  places with "Delay injection" comments. Would you want such delay
  points upstream, for instance as fault injection?

Testing
=======

All tests pass in x86-64 QEMU guests with lockdep, with 2 to 64 CPUs.
Also:
- Without patch 4 and without delay injection, the sequence of test 15
  hangs a guest with 2 CPUs when a SCHED_FIFO task preempts the joiner.
- Patch 2 has no test.
- I did not reproduce the use after free that patch 6 fixes. Its exec
  case needs CONFIG_FUTEX=n. Test 16 passes on a KASAN guest with
  CONFIG_FUTEX=n and the fix, with no report.
- Tests 11, 13 and 16 are stress tests. They found no bug.

A Spin model of the mode switches found the problem of patch 4. It is
not part of the series.

How this was developed
======================

An LLM coding assistant reviewed the mm_cid code under my direction. It
wrote all the patches, their messages and the tests, which I reviewed.
There are two exceptions. The code of patch 3 is Thomas's. Patch 6 is
Weiming Shi's, carried as he posted it. Test 16 follows the shape of his
reproducer, and takes no code from it.
A reproducer that stops failing shows that the symptom goes away. It
does not show that the fix is the one you would have written, so I ask
for a careful reading.

Based on tip sched/urgent, 006991aa8997.

Links:
- Weiming Shi, "[PATCH v3] sched/mmcid: Synchronize MM teardown with
  affinity updates":
  https://lore.kernel.org/all/20261110183809.3308868-1-bestswngs@gmail.com/
- "[PATCH] sched/mmcid: Bound the CID allocation busy wait":
  https://lore.kernel.org/all/87mrs8bhp4.ffs@fw13/
- My reply in that thread, with my variant of patch 3 and the
  reproducer:
  https://lore.kernel.org/all/bd4c03e6-7ea6-4a21-9a3e-74ea9d36fe17@efficios.com/
- Thomas's answer, which prefers the cleanup:
  https://lore.kernel.org/all/87eccossye.ffs@fw13/

Mathieu Desnoyers (16):
  sched/mmcid: Give a CID to a task that joins its mm while running
  sched/mmcid: Give no concurrency ID to user workers
  sched/mmcid: Reset stale state when the first user joins an mm
  sched/mmcid: Let a running joiner take its CID after the fixups
  sched/mmcid: Take the allowed CPUs of the first user when it joins
  selftests/rseq: Test the concurrency ID after a failed execve
  selftests/rseq: Test the concurrency ID after the last user fails
    execve
  selftests/rseq: Test the concurrency IDs across ownership mode
    switches
  selftests/rseq: Test the upper bound of the concurrency IDs
  selftests/rseq: Test affinity changes made by another process
  selftests/rseq: Test an affinity change by another process during
    execve
  selftests/rseq: Test concurrent thread creation and forced migration
  selftests/rseq: Test the concurrency IDs after the affinity is widened
  selftests/rseq: Test two race windows of the concurrency ID mode
    switches
  selftests/rseq: Test affinity changes while a task replaces or drops
    its mm
  selftests/rseq: Test the last user after an affinity change during
    execve

Weiming Shi (1):
  sched/mmcid: Synchronize MM teardown with affinity updates

 fs/exec.c                                     |   1 +
 include/linux/sched.h                         |   2 +
 kernel/exit.c                                 |   1 +
 kernel/kthread.c                              |   1 +
 kernel/sched/core.c                           | 151 +++-
 tools/testing/selftests/rseq/.gitignore       |   5 +
 tools/testing/selftests/rseq/Makefile         |   5 +-
 .../selftests/rseq/mm_cid_bound_test.c        | 441 +++++++++++
 .../rseq/mm_cid_exec_affinity_test.c          | 283 ++++++++
 .../selftests/rseq/mm_cid_execve_test.c       | 685 ++++++++++++++++++
 .../selftests/rseq/mm_cid_teardown_test.c     | 396 ++++++++++
 .../selftests/rseq/mm_cid_transition_test.c   | 511 +++++++++++++
 .../selftests/rseq/mm_cid_window_test.c       | 485 +++++++++++++
 13 files changed, 2942 insertions(+), 25 deletions(-)
 create mode 100644 tools/testing/selftests/rseq/mm_cid_bound_test.c
 create mode 100644 tools/testing/selftests/rseq/mm_cid_exec_affinity_test.c
 create mode 100644 tools/testing/selftests/rseq/mm_cid_execve_test.c
 create mode 100644 tools/testing/selftests/rseq/mm_cid_teardown_test.c
 create mode 100644 tools/testing/selftests/rseq/mm_cid_transition_test.c
 create mode 100644 tools/testing/selftests/rseq/mm_cid_window_test.c


base-commit: 006991aa89974378ee579416dba87adc22cd60fd
-- 
2.47.3


