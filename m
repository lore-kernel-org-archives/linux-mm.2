Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B828C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:45:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 267166B00D1; Mon, 21 Sep 2026 09:45:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23F1E6B00D3; Mon, 21 Sep 2026 09:45:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12DC96B00D5; Mon, 21 Sep 2026 09:45:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E161A6B00D1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:45:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DAADFC01B7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:09 +0000 (UTC)
X-FDA: 85237890738.05.E0691AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 12444C0010
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CTElbC33;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789998308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=e4AZu4AlntNt1aYig0/jFDygUFvaCLDRa7pO2XcQvUU=;
	b=WKL0x/bkbVz6jJH5Sw3CNu5K7hC7zLlGHfB/dDsIqdcJz7PLnxML0JOZAzN1Oya4wUwwJr
	RVvYjn5dS1n1HLB/3iG9ZPBJ5PFk9yrFwdU7BNP0QA2ez2r0YWXYd8fjW/hyvk1P7Ewls5
	RN7A6u3QTZ2Mj9kZ8IHGtGyiEJlbFJQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789998308;
	b=d2dUeO+sCUqMkr2rCwdY33IGJ75B2cv//yTxgV7ANKLopXGs/0Z2HzSyxaa4k0mNfOBe9A
	kbtANgQy4hKcMuLUW2sUxkLeUDYeaRRcgJ83aOKlzfd3zk9ggV5Jzl2Mqb7WTN79mt1cW7
	VPSqJYBRoep73zUv4aP+U24dQ97RmGo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CTElbC33;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BCA16021E;
	Mon, 21 Sep 2026 13:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05531F000FF;
	Mon, 21 Sep 2026 13:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789998307;
	bh=e4AZu4AlntNt1aYig0/jFDygUFvaCLDRa7pO2XcQvUU=;
	h=From:Subject:Date:To:Cc;
	b=CTElbC33WCvK21eYsu1cvCUz+/OAaKUyDjGunBjoj3Dcxwg2gIpLoNBEYjRs5e1T9
	 1IIWTK1qe4enooe2DuMaHz8FVVp5y9mOT9febxd9ltEsejyb+9XV+Fu8oA4wFtpAT1
	 Muk5iJN0JjbzbdQC81KDOtVfLAAuYylKYAV07yerti0WXWcszEKbFdkztbdQstg86M
	 TVbdoVXwAtkINnL4RohkYYVqQIHk9FGD2t4pJG2uTSw040ORzznD3C04jHQjDGCcKC
	 T3cMPMvi1ImTtpFtM3ZRmZqslphJuY815B2ZFNNxWFNAectS+lRL2d0G0F4Lb7H6Tb
	 SXcktS3b+k98A==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH v3 00/17] coredump & signals: an impossible affair
Date: Mon, 21 Sep 2026 15:44:49 +0200
Message-Id: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/32Oyw6CMBBFf4V0bUnLw1ZX/odxUcoUKkrJFFBD+
 HcpxkQT4/LOnHtyJ+IBLXiyjyaCMFpvXbuEdBMRXau2AmrLJZOEJVu24zm9OWyodgjlcO2osXf
 wFEqzk1oyA0KSpdkhrI+leDy9sh+KM+g+qAJRKA+0QNXqOpyCNH5L47UbBySgtfW9w8e6cORB+
 X/MyCmjJs0zrTIuJNOHBrCFS+ywImHNmHxKxG9JskqEFEaXiuX8SzLP8xN/7AjmOQEAAA==
X-Change-ID: 20260915-work-coredump-fixes-edf98c80fe78
To: Oleg Nesterov <oleg@redhat.com>, Chris Mason <mason@kernel.org>, 
 linux-fsdevel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 linux-mm@kvack.org, io-uring@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=3905; i=brauner@kernel.org;
 h=from:subject:message-id; bh=5cmOqATVUXTDQgM82raywtxRqKGg+wRZ/gH8Sbkxogk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRtNLlTxbd8XWa+Kc+KiT/E91pz+7J8Ov7qyvJXT+94z
 khOaavV7ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjI/2eMDP+PuL2Sl6qrm/zZ
 2OzjVDbmL7/t903i+vJDpf3FncWnLi5iZPjJ3my/wPRveUdkuFHrju/LnFutHVxcCxeamzPGf18
 +kREA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 12444C0010
X-Stat-Signature: c3secfyssc5yc8c4hae7uzejoqcbr7a3
X-Rspam-User: 
X-HE-Tag: 1789998307-211007
X-HE-Meta: U2FsdGVkX19ugtQe2IY95uqfpRs7VrCRrqXPtZ393kCjSmlY/ehbtaddat1QxHmcAIf+ZUW8fnI1B8t2DnG5uiSYi7tW8cpXv2JJU6sa9W1w/K9+zIf+bZ2NwsrQfzf3OnMicq8/AuhLsQg+cpRivo3KrVzI867F1u5ZZxFbDiRfFNHmiUsd+ynzAo9iNuUrfCuxsbF6IJoWGtj/M8qTKpNf/vxlfDhvjXemBusxFU3qu/+tOoNza8QJXwmZwjZ2ovOBQb/0LdM4SYifn+3HWmCBelYTGWJnptmDDIOvzaeFp0lwDKlOXDuEQqFWYYrXw1Q8A6cb4HYseZ9hTo7kcqf4WqiF6ARnAkxpr/hEu5q6PUKB1KIr9RXRrMx4nPq6W/uoAboU90FK0j80l8md+CerehdGbNTRurWxq2rM1mmXVPlWGATpu4WkUidyIVPtYEWgX6Dw0PdCaILF3sdwYf3VHLlfOLiYk9ZQ1a+kt36gj760pxbGZg6e08x3P22d5kZJnqSSEwQTElK8tRhauTwEFOokwNcj4WfbCgtFGiZTQ3umpPnDhIVjPT992+zk9DXxeBuFVUQQH1ilVcl6sIippbQWtNgkK5SAq7bZtOy0bsaarVUU7+uqCygbv2LpJjjrdHQ6flDC+1j8jWPqQIsRc4XAT7uJdm3juv7iZ3vaGgDClenTwW1y+ABAjnxBJ4KqCZbINfAAi+8xi3LGMdRdcUF0/Ne9OGgVj9ZggoCkLrNNRXMjV75l78CHPxCFt2C4dCkqmXCaTT6pMNrzmaqlcdpXWqMycpkgfKgn9MARXOgmXoYOJamE7GJnjyAa6yLSZYEGQsuCBEtcZQ+xDdRNLw1dHDJSxZd8dwH4GjxHMraApeBKuzb799kiVFAmwm3ednO2ppC9MVGxr97izlKxyRqzx+TqavaiYRLXN/LAvYDdEztuYGbSdFed+Ayta4XGoL8ngz5p1SSP444
 a0tiXKhS
 qgXexZJVBieR356FEUObAyH0pp1JqtsatxME1KqQM314BBC5ReyuzW4GbJV/ZTjwZii2zABwUjG8WcLdxj4MpE2JeKv1A2ZWWtD/dXlQ8SRwoIR09GP22iaYQdmNzhK5/93jS4ugUYSQj8uj1vL/2te3ucRhgCynnR47/axyf7OWPrpC7P1jgvcnNZJrTuA1ggBJG5IO8N/sFjdBQXdhuIzU5VE8B328XVYfsTcHcoraw1juljQ2v7lPng1w4Ejk6o6qKShrrnnqi+bpfmSlAIeOGSY2XejW52x3P7uHydKjh+d4uwyFr98NW9mkBe2oTzYROBBKY7IEUYPA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey,

I asked Chris to look at the coredump code with kres and it found a few
bugs. I started looking as well and found a few more. Here's a fixes
series. I also used TLA+ modeling for this.

Fixes in here:

- UAF in coredump_finish(): a parked thread can be freed before it is
  woken
- only SIGKILL and the freezers interrupt a dump now, cgroup v2 included
- core_pattern is parsed from a snapshot instead of racing the sysctl
- the io-wq exit bit wasn't ordered against worker creation task work,
  exit could hang on worker_done
- shared signals are no longer retargeted to the dumper, that truncated
  cores
- a failed fork released its files under scx_fork_rwsem, deadlock
- a session leader's exit lost the SIGHUP for the foreground job
- an io-wq worker of an SQPOLL ring as the dumper deadlocks the group,
  user workers never dump now
- PTRACE_SETSIGMASK can't unmask a user worker anymore, the only way in
- exec cancels io_uring before de_thread(), nothing adds a thread after
  it
- no io threads from PF_SIGNALED or PF_POSTCOREDUMP creators, they
  broke threads_remaining
- descriptor tables are closed highest fd first again, the order the
  deferred puts had

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Changes in v3:
- Address Oleg's reviews.
- Add a couple more fixes.
- Link to v2: https://patch.msgid.link/20260917-work-coredump-fixes-v2-0-f3787fcda051@kernel.org

Changes in v2:
- Add fixes for retarget_shared_signal().
- Expand fixes for signal_pending().
- Link to v1: https://patch.msgid.link/20260915-work-coredump-fixes-v1-0-f354ca41780c@kernel.org

---
Christian Brauner (18):
      Merge patch series "files: make closing files synchronous for close_range(), exec, exit"
      coredump: hold RCU while releasing parked threads
      signal: only SIGKILL and the freezers interrupt a coredumping task
      coredump: parse a snapshot of core_pattern
      io-wq: order the exit bit against worker creation task work
      signal: don't retarget shared signals in a dying thread group
      selftests/coredump: test shared signal retargeting during a dump
      fork: release the files of a failed fork after sched_cancel_fork()
      exit: hang up the tty before closing the files
      ptrace: refuse to change the signal mask of a user worker
      selftests/coredump: test a user worker as the coredumping thread
      selftests/coredump: expect PTRACE_SETSIGMASK to be refused on a user worker
      exec: cancel io_uring requests before de_thread()
      fork: move the coredump and exec checks into create_io_thread()
      fork: don't create io threads once PF_POSTCOREDUMP is set
      fork: use SIG_KERNEL_ONLY_MASK for the user worker signal mask
      signal: enforce the user worker signal mask in __set_task_blocked()
      fs: close files from the highest descriptor down

 fs/coredump.c                                      |  73 ++--
 fs/exec.c                                          |  11 +-
 fs/file.c                                          |  55 +--
 include/linux/sched/signal.h                       |  19 +-
 io_uring/io-wq.c                                   |   2 +
 kernel/exit.c                                      |   5 +-
 kernel/fork.c                                      |  20 +-
 kernel/ptrace.c                                    |   6 +
 kernel/signal.c                                    |  22 +
 tools/testing/selftests/coredump/.gitignore        |   2 +
 tools/testing/selftests/coredump/Makefile          |   6 +-
 .../selftests/coredump/coredump_signal_test.c      | 238 +++++++++++
 .../selftests/coredump/coredump_worker_test.c      | 447 +++++++++++++++++++++
 13 files changed, 832 insertions(+), 74 deletions(-)
---
base-commit: dadceac9d20a1c90269aafd7746f7c0c05879ad3
change-id: 20260915-work-coredump-fixes-edf98c80fe78


