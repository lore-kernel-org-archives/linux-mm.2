Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6734AFF886C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 22:38:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBCAE6B0005; Tue, 28 Apr 2026 18:38:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C946D6B008A; Tue, 28 Apr 2026 18:38:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD0D96B008C; Tue, 28 Apr 2026 18:38:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A806D6B0005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 18:38:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 69E341A04B9
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 22:38:02 +0000 (UTC)
X-FDA: 84709428804.07.1617518
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id A459D140002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 22:38:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U9lMM1oN;
	spf=pass (imf23.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777415880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dBGbqL+hciHP6Zit4LP/VnFrR9rW+cYQnGdhbU0n0+U=;
	b=u83r1Pe1DPirWWPdvhcjrrtOQq1smGYmfsV94Tn5Gug1zyK5g2AB+AcsClsslCUZxmLjvZ
	U0qpIMeT3nqSQZ6ljNFRzjpqZYfIujAHky5l+/ByXjvZQrUpqtyr+xqdRHhbKwo/EY9eOJ
	f0qaRGBxUa84AQLSIS7MT6C+0KkJMJc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777415880; a=rsa-sha256;
	cv=none;
	b=NOpd8fYBFM7oP7UmRKQqhLlAxYHv42D0y97TSiU/1mYNiR2otocHPxos3vicECNRQrVS/r
	sEAGHEH0ZtUl4VBzr0jwC1NPkX/xk0hGmLMAPce5IWVyNLOqrtGMNfQrb5BhiBGPfcvfzW
	juXPQww7GyDqof29/tfHSkAg7ZCwy1U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U9lMM1oN;
	spf=pass (imf23.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 86E27439BD;
	Tue, 28 Apr 2026 22:37:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA86C2BCAF;
	Tue, 28 Apr 2026 22:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777415879;
	bh=6yRAJ6iKr3kWjPNrlXKo2X48nCi0v4xhOisZi6+X9Qo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U9lMM1oNq3qzKjp7GY4B2074nR2F/0prN+EBu2ms++hexCEzZyNwPlQNUSQty5Lcx
	 DDToVvh8kd35vB0U5nOlwhnEr/h9VEVBwFdX+kw7YoZW3sefo3xDnmMEvEywYTTBaP
	 lrUmNWhwbtfTzS3mG9ecYobmHI5OHtkMvdO3K6VDoO7ML4noNXx3A6RyGjaNShuSYo
	 3lOuzzKWvJVIQg/YCQ7GiRVHfM5UbKzEQehvJu6gqYEcsllRHIyBSPVHiJN9FV6DHo
	 /Fqd1PEk3LUZ/OOV0QoPTjFt+TcFzIQQmBG3ZPPR7HewVMzs1JojmWjbi4T5TC0ANX
	 d13PEytDpiGtw==
Date: Tue, 28 Apr 2026 15:37:57 -0700
From: Minchan Kim <minchan@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, david@kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v1 3/3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <afE2xchFRh2xARBn@google.com>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-4-minchan@kernel.org>
 <aesiYAumkLCyedf0@tiehlicka>
 <aevzbx_Pk5Cu5exa@google.com>
 <ae8KD_Tq0t7RvUy1@tiehlicka>
 <ae_dRZ95dCDTTxaQ@google.com>
 <afBbRUaGnE8WZIkY@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afBbRUaGnE8WZIkY@tiehlicka>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A459D140002
X-Stat-Signature: dzzd8dm3ey551pixa7zzjodoqmycf1e1
X-Rspam-User: 
X-HE-Tag: 1777415880-532063
X-HE-Meta: U2FsdGVkX1/oapcagriN4vyqcQLhTTxv1ZJmpeJ6S0VWpH9XuOSe4P2dkv9PhMTLqxTsdJ6ugS0vnrAnLtoN8Qv47NpYzm/FAScSLmET+ll8Evh0CZZFONLG1N89JQQzPIW66j8s483rDUPdxVJrZwCY6jsJ+PHEvVGTq3M5gOEzfiljLn07lNKSLi2L7zTyJgAGR4vkCD27r9P8LLYSwq/sNLuxE698h9+BPnzuQ/sG9NKcDtLDa+TyW7W/YOjdqP2Tf4g8L04l7PZDRxngfVudAhVNPZ2dzyeeu4pB3mP5dIrm7CkgSlwKVtYhxY6Sydu4d6jVcWsoxxio4+GKO1tBV9vcbl8nwSNTX+64aa7Y5Sj9d9fRa/RPV6zUS26jNUCacr8/zQCUbw3OwEAdtzC4qZiCdbd1ADHIxHdaMp0RkZ3huEIo6TNtl+lMZJVasu0ras5Mt1DW0dWyIEx3tDrTCdpViUxhqQvNyGzVBcJki9iAZHwyeKkpmjqe+q8CQtEZcmp89/81UmYPoXJEtrUjzz+f5Tu1+NZg+nrHe2jr06LDPH5RGwueUbWmOZdRIVIoF/bAIBIgBMlFo02yzr3wRXERLjpjiPWBn1mpVuZB7HXRMUJCQO5RZUzPDGVMkF8C+iLFp1RLxubLRe9Zgo4tjZVWpNpeJPTpLhmvXU/it2hMIJbejNn25exkZ2SZMbxeP2Wt1wqVhYX9RJ1OxxvMGLtyBiojKz/X2QS53ZiFz59aZMrMa1460qvQVl/m2yDa1dfx3n9B290U6DJZoQavDplmWrQvIw5RnwVsE5PqdKb0POwMsFSg1FTdHzZzAdSCMjWVt8PaPVa1pFg+4+QvPo+3RXeS+p5KKBtb5vPTYbik+xp+/Asce08oniw7s7sAqOukw+nULX4NskOP5yJUxzV93e22L9Up6Hf5EjPFy0CyRfvLz+96Q0Yke3r0lTe2fBgC3Qhj5ge9Dlr
 slIdOoH+
 6/omQ8Oc/AIFY20kkg4Jl3nZ4TCxeots8HfUcp8lYP6QhAJau0I0HbpOoLtKqszmY0RkjzBxIqRS+NqU11SLC4v56CwMHIBv39L5cm0GFGD1JY9fVAKXhAPiA5nJyUvq5rGvaK9tvaijxeRv1vEaMgA/+5cyGa4CRqeY3/9isdMIZW8EvmQSIXXhnAsnXw4MrO03yqyxXl3O5dVGDwjlB2LrXgnLEkBH14DRF3IPj5vCZcKxmi8bXYlaTvkj+osQds/Ww8gIPhVD7NujR+tUjHRNFzIWTk+Qce/FIONDr0v0SGs1n02p7LgMhUhejeiyCw+EZMGL08FftgLi9ikaJAdmNrLEeCLwnK5Ve
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 09:01:25AM +0200, Michal Hocko wrote:
> On Mon 27-04-26 15:03:49, Minchan Kim wrote:
> > On Mon, Apr 27, 2026 at 09:02:39AM +0200, Michal Hocko wrote:
> > > On Fri 24-04-26 15:49:19, Minchan Kim wrote:
> > > > On Fri, Apr 24, 2026 at 09:57:20AM +0200, Michal Hocko wrote:
> > > > > On Tue 21-04-26 16:02:39, Minchan Kim wrote:
> > > > > > Currently, process_mrelease() requires userspace to send a SIGKILL signal
> > > > > > prior to the call. This separation introduces a scheduling race window
> > > > > > where the victim task may receive the signal and enter the exit path
> > > > > > before the reaper can invoke process_mrelease().
> > > > > > 
> > > > > > When the victim enters the exit path (do_exit -> exit_mm), it clears its
> > > > > > task->mm immediately. This causes process_mrelease() to fail with -ESRCH,
> > > > > > leaving the actual address space teardown (exit_mmap) to be deferred until
> > > > > > the mm's reference count drops to zero. In Android, arbitrary reference counts
> > > > > > (e.g., async I/O, reading /proc/<pid>/cmdline, or various other remote
> > > > > > VM accesses) frequently delay this teardown indefinitely, defeating the
> > > > > > purpose of expedited reclamation.
> > > > > > 
> > > > > > This delay keeps memory pressure high, forcing the system to unnecessarily
> > > > > > kill additional innocent background apps before the memory from the first
> > > > > > victim is recovered.
> > > > > 
> > > > > Thanks, this makes the motivation much more clear and usecase very
> > > > > sound.
> > > > > 
> > > > > > This patch introduces the PROCESS_MRELEASE_REAP_KILL UAPI flag to support
> > > > > > an integrated auto-kill mode. When specified, process_mrelease() directly
> > > > > > injects a SIGKILL into the target task.
> > > > > > 
> > > > > > To solve the race condition deterministically, we grab the mm reference
> > > > > > via mmget() and set the MMF_UNSTABLE flag *before* sending the SIGKILL.
> > > > > > Using mmget() instead of mmgrab() keeps mm_users > 0, preventing the
> > > > > > victim from calling exit_mmap() in its own exit path.
> > > > > 
> > > > > Why is this needed? Address space tear down is an operation that can run
> > > > > from several execution contexts.
> > > > 
> > > > Agreed.
> > > > 
> > > > > 
> > > > > > This ensures that
> > > > > > the memory is reclaimed synchronously and deterministically by the reaper
> > > > > > in the context of process_mrelease(), avoiding delays caused by
> > > > > > non-deterministic scheduling of the victim task.
> > > > > 
> > > > > The memory is still reclaimed synchronously from the mrelease context.
> > > > > This is really confusing.
> > > > > 
> > > > > Please also explain why do you need to do all that ugly
> > > > > task_will_free_mem hoops. Why cannot you simply kill the task if
> > > > > task_will_free_mem fails (if PROCESS_MRELEASE_REAP_KILL is used).
> > > > 
> > > > I wanted to handle shared address spaces.
> > > > Even though we are okay with the target task not being in a SIGKILL
> > > > state yet (since we are about to kill it), we must ensure that all
> > > > *other* processes sharing the same mm are also dying.
> > > 
> > > Then just bail out when the mm is shared accross thread groups, rather
> > > than kill just one of them. Or kill all of them. There is no reason to
> > > play around that on the task_will_free_mem level.
> > 
> > Kiling unrelated processes just because they share an mm is too radicical.
> 
> Well, that depends on what you try to achieve. The global OOM killer
> does kill all tasks sharing the mm.
> 
> > Thinking about quick check whether mm is shared.
> > 
> > An idea:
> > 
> > `atomic_read(&mm->mm_users) > task->signal->nr_threads` to detect sharing
> > across thread groups without looping like task_will_free_mem.
> 
> We have MMF_MULTIPROCESS. Can you use that?

That makes sense. Thanks.

Then, how about this?

From be4bd22a100ed6be2d1d2599ddb9da04043143eb Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Fri, 24 Apr 2026 14:27:08 -0700
Subject: [PATCH] mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL
 flag

Currently, process_mrelease() requires userspace to send a SIGKILL signal
prior to invocation. This separation introduces a scheduling race window
where the victim task may receive the signal and enter the exit path
before the reaper can invoke process_mrelease().

When the victim enters the exit path (do_exit -> exit_mm), it clears its
task->mm immediately. This causes process_mrelease() to fail with -ESRCH,
leaving the actual address space teardown (exit_mmap) to be deferred until
the mm's reference count drops to zero. In the field (e.g., Android),
arbitrary reference counts (reading /proc/<pid>/cmdline, or various other
remote VM accesses) frequently delay this teardown indefinitely,
defeating the purpose of expedited reclamation.

In Android's LMKD scenarios, this delay keeps memory pressure high, forcing
the system to unnecessarily kill additional innocent background apps before
the memory from the first victim is recovered.

This patch introduces the PROCESS_MRELEASE_REAP_KILL UAPI flag to support
an integrated auto-kill mode. When specified, process_mrelease() directly
injects a SIGKILL into the target task after finding its mm.

To solve the race condition, we grab the mm reference via mmgrab() before
sending the SIGKILL. If the user passed PROCESS_MRELEASE_REAP_KILL, we assume
it will free its memory and proceed with reaping, making the logic as simple
as reap = reap_kill || task_will_free_mem(p).

To handle shared address spaces safely in the auto-kill mode, we bail out
immediately if the mm is marked with MMF_MULTIPROCESS when
PROCESS_MRELEASE_REAP_KILL is specified. This protects existing users of
process_mrelease() from behavior changes while preventing unsafe reaping of
shared memory.

Fundamentally, this allows process_mrelease() to trigger targeted memory
reclaim (via oom_reaper infrastructure) quickly, even if the victim is
not yet in the exit path, while reusing existing race handling between
reaper and exit_mmap.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 include/uapi/linux/mman.h |  4 ++++
 mm/oom_kill.c             | 27 ++++++++++++++++++++-------
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/mman.h b/include/uapi/linux/mman.h
index e89d00528f2f..4266976b45ad 100644
--- a/include/uapi/linux/mman.h
+++ b/include/uapi/linux/mman.h
@@ -56,4 +56,8 @@ struct cachestat {
 	__u64 nr_recently_evicted;
 };
 
+/* Flags for process_mrelease */
+#define PROCESS_MRELEASE_REAP_KILL	(1 << 0)
+#define PROCESS_MRELEASE_VALID_FLAGS	(PROCESS_MRELEASE_REAP_KILL)
+
 #endif /* _UAPI_LINUX_MMAN_H */
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5c6c95c169ee..efa6541b1c47 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -20,6 +20,7 @@
 
 #include <linux/oom.h>
 #include <linux/mm.h>
+#include <uapi/linux/mman.h>
 #include <linux/err.h>
 #include <linux/gfp.h>
 #include <linux/sched.h>
@@ -1217,9 +1218,11 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
 	unsigned int f_flags;
 	bool reap = false;
 	long ret = 0;
+	bool reap_kill;
 
-	if (flags)
+	if (flags & ~PROCESS_MRELEASE_VALID_FLAGS)
 		return -EINVAL;
+	reap_kill = !!(flags & PROCESS_MRELEASE_REAP_KILL);
 
 	task = pidfd_get_task(pidfd, &f_flags);
 	if (IS_ERR(task))
@@ -1236,19 +1239,29 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
 	}
 
 	mm = p->mm;
-	mmgrab(mm);
+	if (reap_kill && mm_flags_test(MMF_MULTIPROCESS, mm)) {
+		ret = -EINVAL;
+		task_unlock(p);
+		goto put_task;
+	}
 
-	if (task_will_free_mem(p))
-		reap = true;
-	else {
+	reap = reap_kill || task_will_free_mem(p);
+	if (!reap) {
 		/* Error only if the work has not been done already */
 		if (!mm_flags_test(MMF_OOM_SKIP, mm))
 			ret = -EINVAL;
+		task_unlock(p);
+		goto put_task;
 	}
+
+	mmgrab(mm);
 	task_unlock(p);
 
-	if (!reap)
-		goto drop_mm;
+	if (reap_kill) {
+		ret = kill_pid(task_tgid(task), SIGKILL, 0);
+		if (ret)
+			goto drop_mm;
+	}
 
 	if (mmap_read_lock_killable(mm)) {
 		ret = -EINTR;
-- 
2.54.0.545.g6539524ca2-goog





