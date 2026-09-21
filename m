Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D2DAC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:45:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BA716B00C2; Mon, 21 Sep 2026 09:45:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96AED6B00E1; Mon, 21 Sep 2026 09:45:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 833006B00E2; Mon, 21 Sep 2026 09:45:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CF996B00C2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:45:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C40F51201BA
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:34 +0000 (UTC)
X-FDA: 85237891788.07.83D370F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 09CA210000C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pmfck5Q1;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789998333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/1BanrR0bEaNM0ANpLadkWf2SynUvHsGYYo3gSkKut8=;
	b=BDKeeiV2ABUESxxGml7ue+iXWma0eApLQfjghFblWE7IUXQXEhJ9hSrSr5+lDj3LkMfzU6
	kRzg4ziGAwXuZyNcCdvzPEHu9IWbnQIMmcXQMwK1jDpWewdWZQqepYL+xhACXqY9GVs1ef
	8Zhan7VV8JzpuwBW06mGP+rE/q491gY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pmfck5Q1;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789998333;
	b=tsPg3CTSATVVT7dOnvhCLwdDBNRBe8k1bGONQn8BBXqW0cX1BTOIyjcWS1ZKioQSAM4Ux6
	KFffne/sfyRc6KW5T9aipWNhAdnClPOvhVZOEOZs/0ptf2XEL5NIlHPYztW8C0YDgiwxhE
	EZcDXgTtdxo+ljGV3h09oMdBB8t9iq0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A377F601F0;
	Mon, 21 Sep 2026 13:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D23C1F00898;
	Mon, 21 Sep 2026 13:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789998332;
	bh=/1BanrR0bEaNM0ANpLadkWf2SynUvHsGYYo3gSkKut8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Pmfck5Q1hr/Yx7jfVeDnT8LVpiwSzMf7eFW7nK93xNMWhIoB5/tzeCrLYo5iu7XAH
	 89bzw9T7RxA9xAAw0JQjKsvsLeorLNG4KUl3kJRIDmGDFRwloHcDlf/Z1sHk+qmRsj
	 IVhrkt/cFEZuWKGJSGkQ7HTHY7Gs6B58EhjuzYraL7ITnpC2axmVCX9elZ3S4gTSVJ
	 WDbFh5WZdGWNLx+fIZjwamtKYPc1zlH58KlYQV/VowhjiG/OIVAlWQbbI3nHCq9DOj
	 L2lzdtm8snI0OfqWquIVbZV5oy/4xqtz9m15I2WgzsIeSrvLECj91POQTee1+KKCkO
	 rIiO1AoJHW0RA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 21 Sep 2026 15:44:56 +0200
Subject: [PATCH v3 07/17] fork: release the files of a failed fork after
 sched_cancel_fork()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-work-coredump-fixes-v3-7-8e4adb1619e6@kernel.org>
References: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
In-Reply-To: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Chris Mason <mason@kernel.org>, 
 linux-fsdevel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 linux-mm@kvack.org, io-uring@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=2806; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ewDsuLMI5Aha0m3J9gayD6hgJ7X0BeQSbg3MKkl5wZg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRtNLlz44ymZcCmDuNsnYhpUV1ZKqHe0Xd5dySxvcmU9
 Hf5H7u8o5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCKcHAz/DPb4mFvPdHux9MOf
 zxpzH69pFt/Fls5wT/PZjuRVxh8uvmZk6HhyfUpd8L/PR88an+TZ1vaiXrU1w/qNkozMlP1OwsF
 PWAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 09CA210000C
X-Stat-Signature: 83i8bba1r47ijwxyhm74hd1ig6d4atyd
X-Rspam-User: 
X-HE-Tag: 1789998332-879988
X-HE-Meta: U2FsdGVkX18dHw3fiTbXCWKBMhWzPeSKRIlH6mYx3jdyuYCU8c+7o1sHenV+Sa0zAD63RMSXhT6QgIMzLTia3oyYzCzjMfQWeYi0qKkfe+n3xBw8+kLTbC0wi0+8h0aj6PzhPBDVVYgcCHHvaAhg9TnBvwmeTVjzNTYX0LONvYsiNh7CjA/yh0xNP37hU8Gw6SFCgJrUeivV+qhwjE78mgK0axN6qR6cvu2j/4kH6ZZtAbjF+E11uXjp44qUKoDA2uCFY2nSJPK6oVdjJ/PhNpQQvmmffVZ7/WkSXesJ1NqbUZHVHSe7tA6t7IovMwazB2CoQQcbok97BFilGPANUWKyYC/ZJWKCQa4FP4hDH2nMiEOUQOiooaAH+s6ZK5bfBWvRNR6fM2S51ctqCWaayJHe+8exfTBT6lSUYalpFWJOLtjH8Gdm4+4OV5UePRBg2nIgGgMl3BC0SeyWCfrAJS35aXdNtLyMQAuG9w+L2g73pEUyjUebDXoj++AO15sVsX5HewzPlw9fGM9G04lx/CG/hakAb+bxTkHcYiVb7twC6q/VoM4SyvzOz6xiea9qzGuqpIYgmd6y+p1RNceuCffZRVIVtnJlnOcTUzSdgkt03tdHsAjOyGo6+Qz2NnvXX62izcByXdlAVq8eT1O+oXG8NNhaZl5tB7U9ZobBm+hQfSnT8V3EgMr2khJjUfPvNiz3mXl01TRpY4nRAqOIiyDQUXIksrxQrLqGBeO5fTtgPebU74I3E+lEGunc5IDMC/JMNcwfQwmpVfkA70bpUQaohrdblPWkCT2Y+DBz5glO0JLh+Li7OgouCcAx0sxDkqbtogzmHAIKQcPp9Q4osxZrzblEwM5JHisdvc7Y5e/4FLJdo22n+KhiN2BbAsLc1WvgUqcShiVVX9nAAuShGGNF7NqG0uKY5RY3EmsHrYgLT0DtG2QFRGXUbhlKRPQ6V6wbBonsxlEaEJZcOdw
 KyMXavpb
 QOZPXEQUIwY6sWgw2pAB2HFXllSI3FaleKitonM/6lDqCrpv56S+rXLjFcuUrCl0biOe0jrYiciYPaAAwWADf2Z/NGX831ndeMt4fZHWJbgVFabEHJ3tTTB79ClIorsr6etGez918qV9HpwHYVlsvkApgEMRq0CUJF/GaJvbfY30HfCv5ieNFn+zKEFrCbSOMumQUN3zlTtLC6/QyGKfvoKsBA+gw/PufnoEvOrwOuc8Egu0X1wrvD/IVm7xOS8t2ij5hfu1pL4A9n8j2wSEzEkrZPqcwHy+aGmGm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reorder copy_process() cleanup so sched_fork() taking scx_fork_rwsem
scx_pre_fork() is safe and isn't held around exiting files. Right now, a
fork that fails while another thread closed the bpf link fd will
deadlock against its own read side. It also blocks every fork on the
system:

    copy_process()                  holds scx_fork_rwsem for read
      exit_files()
        close_files()
          filp_close_sync()
            bpf_scx_unreg()
              kthread_flush_work()  waits for the disable work
                scx_root_disable()
                  percpu_down_write(&scx_fork_rwsem)

Simply release the child's files after sched_cancel_fork() dropped the
lock. The task starts out as a copy of its parent so p->files points to
the parent's table until copy_files() replaces it. exit_files() must not
run for a fork that failed before that. Clear p->files up front so
exit_files() is a no-op for those and make copy_files() set it
explicitly for CLONE_FILES.

Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/fork.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 10be4a0ecb3f..50f5b3e2ca87 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1676,6 +1676,7 @@ static int copy_files(u64 clone_flags, struct task_struct *tsk,
 
 	if (clone_flags & CLONE_FILES) {
 		atomic_inc(&oldf->count);
+		tsk->files = oldf;
 		return 0;
 	}
 
@@ -2199,6 +2200,8 @@ __latent_entropy struct task_struct *copy_process(
 	INIT_LIST_HEAD(&p->sibling);
 	rcu_copy_process(p);
 	p->vfork_done = NULL;
+	/* Set by copy_files(), exit_files() on the error path skips NULL. */
+	p->files = NULL;
 	spin_lock_init(&p->alloc_lock);
 
 	init_sigpending(&p->pending);
@@ -2300,7 +2303,7 @@ __latent_entropy struct task_struct *copy_process(
 		goto bad_fork_cleanup_semundo;
 	retval = copy_fs(clone_flags, p, args->umh);
 	if (retval)
-		goto bad_fork_cleanup_files;
+		goto bad_fork_cleanup_semundo;
 	retval = copy_sighand(clone_flags, p);
 	if (retval)
 		goto bad_fork_cleanup_fs;
@@ -2613,8 +2616,6 @@ __latent_entropy struct task_struct *copy_process(
 	__cleanup_sighand(p->sighand);
 bad_fork_cleanup_fs:
 	exit_fs(p); /* blocking */
-bad_fork_cleanup_files:
-	exit_files(p); /* blocking */
 bad_fork_cleanup_semundo:
 	exit_sem(p);
 bad_fork_cleanup_security:
@@ -2625,6 +2626,8 @@ __latent_entropy struct task_struct *copy_process(
 	perf_event_free_task(p);
 bad_fork_sched_cancel_fork:
 	sched_cancel_fork(p);
+	/* ->release() of a file may need scx_fork_rwsem for write. */
+	exit_files(p); /* blocking */
 bad_fork_cleanup_policy:
 	lockdep_free_task(p);
 #ifdef CONFIG_NUMA

-- 
2.53.0


