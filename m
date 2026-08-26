Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 758CCC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 11:41:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AF9C6B008C; Wed, 26 Aug 2026 07:41:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 687E56B0092; Wed, 26 Aug 2026 07:41:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59D876B0095; Wed, 26 Aug 2026 07:41:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 296F26B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:41:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 75C791C125C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 11:41:49 +0000 (UTC)
X-FDA: 85143231138.24.55D553A
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf19.hostedemail.com (Postfix) with ESMTP id AF8331A000E
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 11:41:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cT7WRmeR;
	spf=pass (imf19.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787744507;
	b=2dqVwnOmr7fDl0hvdwAa5xzCW0PQN2wCV3os63L0YtntDAZBa/e9yik7Iy9Gdmr0QpQnmx
	ITc1hsl6peXxOepGmBWvCApbwQhaVeH6C6srZH/MqtK5Q+5VSxRqZAcQ1vItTpe4ePppQP
	dUMc4BueG+Zm4RkQzVhFVUsDziKjylU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cT7WRmeR;
	spf=pass (imf19.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787744507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fHRm/8l8Lx1n15ZBXu5Lns0HIeJPog3QvH466YrJxBs=;
	b=kN+pC0aY/zh021+tT1FinpDaBfncK/Md5xNRNT2IFP2QrwQIhIubLvF3joG3SDj6CrsZTX
	5C9IzzztI0ZZKQP8xirO0E01Pp7JG0196JnOytNxbPEAZhG/EBZ+z3moT8peEMnmhCaSBX
	+OXJK0u1Jm9mFcphmNV9XUbfNlMV0i4=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cc891373e0so11537005ad.2
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787744506; x=1788349306; darn=kvack.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fHRm/8l8Lx1n15ZBXu5Lns0HIeJPog3QvH466YrJxBs=;
        b=cT7WRmeRgnq/KJc4942Who6SvL/y9HrSfhf+RxBo39gcxdzMVLzoflS8N+CXvyumwh
         9L3ZJfejTYaRYlVxcE+lOksmePavv2X89X8dECVhKgjNBXOY8hJxXNAj+ANoFuu5vNH1
         9FmZXJmFc67Jw52VZ9u2oaF/O6H2jjxI8th1z/IUoe1EKhO7NF2nrdiBApWXDrZT/mWs
         1qP9uR1JxwOr5cyuXibfjWN1LroBORkau5LC1ZU6R892d3QbNR8LUcsKnxgG1udyMDCz
         HmRBG9+DNSgn4C5iXuxU9QK0ovWi7e+a5BVwDUIPUaOLOLvRItxEO73k3KeELUEbRpjq
         u1PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787744506; x=1788349306;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fHRm/8l8Lx1n15ZBXu5Lns0HIeJPog3QvH466YrJxBs=;
        b=ceGTi2aWT4YjdmSbGem+rgH7iiAJeKPTsMkQwBy//XFOaxgjtVRnw7Me9II9a5+7ba
         VyZB1YZ9Afi1Rhzj87Ie54SDAnyDEpNeoOBeu1G98a7+NtkdVIvypLNCbdc57eJLQc89
         LWi8ieYzxsXe5orMkWbvVVKwMdELCQzowyCZPFeid5OHBMWYia7pi+vBv3UxMFDKGjk7
         ROjFj8IKgqHigJnrNEug9Phdz7gzmL/ByZYjaHkHVyNkp4pMGe0jEttA/FoprjPy4/iX
         QV/8y36JYGpZPFZeaG0PTQjiLCJmwbBfckoYwdrE+2GVTVjDR7WSHWSHs3zAdACM/xH9
         Wdag==
X-Forwarded-Encrypted: i=1; AHgh+Rrlx9sthz0MRTW4bSEqm+aAxOGwr05e8JFqsivrcdeHcbmoR01QBsCAdfcAHVG6t9UM6QAQOwOxVA==@kvack.org
X-Gm-Message-State: AFuF++mAvLFEtB1rgiSRf4bCfuimTmS6VUbsPt2Qlv8Vk18whLBh3v6d
	b35RnZNdz4DMsOvIztMOVFw8+usdroYZgCS/Bnh0H+hINiOBJgVQz/cB
X-Gm-Gg: AR+sD11wFAes2uuDtIzO+4Ck8VAH5ePs96FKPOGuwDpJ57jnZ3/2a68Ux+Z+J+E6WS+
	URdasC7q8fcqQlm3ZPAW15ea5yEcO4NAelgNVvg2v6gXpVAcYBgVrxq10A+jLF3jdyeE9J00vxV
	lPnXgvPot3FMGVqqDwPlCzf0eW2nW0WuWqSx3OB/9SXHvW47j8ap7a7RYVrVR5AFemMiT7IF3KI
	NdCJZZgViVTdnTXkJuxQ9rjbW2OfVRK9Zilx7flfaSk+DhEyeSospq0HY98Xbp+TNjVVihk/Fs0
	L5SAQgmW6gcZQRQZzwsU8dkWJmdzbgS+ENkCB3/20N18LtTY34ZXG6/dhvPYCOEwRQzLSymLdEg
	bKbV9oOsid+UIjgx0xd+o35lw27V1Ks6bw5EXh0MaGS1oUsZ6AdTQ53ysW7y6jWH3W75Bp1/cLg
	ytFrczCrq5wr8sRKKj+bH3OP11it1AKp6KK6+g6gmdaYY+D7LqKcJ4ADkrv9rc5TwK4uikhsYHX
	5XFJnk=
X-Received: by 2002:a17:902:f789:b0:2d6:5beb:8692 with SMTP id d9443c01a7336-2d707a89d51mr110948915ad.6.1787744504064;
        Wed, 26 Aug 2026 04:41:44 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d7147b6d64sm3349365ad.80.2026.08.26.04.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 04:41:43 -0700 (PDT)
Date: Wed, 26 Aug 2026 20:41:38 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: Thomas Gleixner <tglx@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Kees Cook <kees@kernel.org>, Christian Brauner <brauner@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
	John Stultz <jstultz@google.com>, Ingo Molnar <mingo@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Hyunwoo Kim <imv4bel@gmail.com>
Subject: [PATCH v2] posix-cpu-timers: Dequeue per-thread timers before
 exchange_tids()
Message-ID: <ao7Q8miiuLAPVnWv@v4bel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: ugtjjak9r17bkzfzm3whcx6miodwmmwt
X-Rspamd-Queue-Id: AF8331A000E
X-Rspamd-Server: rspam06
X-HE-Tag: 1787744507-155625
X-HE-Meta: U2FsdGVkX18lmIR+cCPgPMYuWcapLTUWDo2H/O0S2/EH1d28o2NF4EnqfBXnGHykJzNZy611CfnirjfgA/qQB4QgMU1mLImBH8K/rS14Z+tuKF6A5RrkaFbIb/sAKk15dXCOrQWJH1vIFyUeGOf/I19Ye7Tb5jDBQ8Rvak+iVN1FcDs5wOju7sjBd3gUu7mmAagGok/39Eg5fCbLmGhimZS/S+fmroRtN5tVtKWFoZNj/IH8akekbfDhNLrTwCucpQTBWL1Q0VyBwvCpaidLG7PIcG3da76xz+lQ/yyiRhkuuD6Taivwtz/QgBZZzcNM4BV7eB7GPanS5F51gUhH0SEhAC6ef41s5tTLPVVNnyN3JQnBRmrLawNKvwtQG+kZE5Di5WDroIlZSrtHHLbuWIYHiZFM3wEHakto90tioX3L16skr1Lf8OxYHqmv7w4mArVG2NVPKMZzS4MG0RZgZI5CjB6HCMGLVhn2q5EFmHs8e8v18/uxtX/tTdOQQk++3sqlBPN0isbZX4O1tjY2OMges8fGCuk/s+iVIhImPM8XmDkmiYljNSWyJphJ8sfrvI/SW6fpNKW+3J4pDVLhkiVA5y/tfGHkxA6bqjf0b1g5g66kDwovtiG3DJFo/QYt6OP4Oz2+jaHuKQJNSwe9HTIUq4Dzb48/9ltyHoK0hPmf6zVU7AwH8qyIUlttJ4I5T8wm1fQzOLEhJvz/9Wc/P1SesMSfQ7cRBVWlAXcHSlO6MabbCpnqldnqXJ8fxTw8Q8KZAcM1XRsO2yTQnTbeuW5bVSjbofxdtFh2ZArqFCE7DcU2Hr+xOF57+mwxtWpsIlUA7fg7fxzRNgrbGZJu1JZPr0bAYaMK/8bW9vfEHIUsGEFHLs9XHkutdnPdASyodii/f2+JpYIR/nMFGrkYBXy4YNyNzL/cSU+kiR1PAcmYT5+AhpxU/LuChTT/ZKcAAiK86JjMg/PgOVx2nYc
 9qSIv7vk
 IGK63eondzAuEf/KF2vYI6Xccn4b8H7vtK4T7GbGR7ZPpxTZcAnWKqlrM4fYyLUlJx136zlruFuLfpEKe+4aACvAhFXUCIwlrBXPZiyJIlRi4whXc5zsZwimqkVX+FUwRdYO8MKdCDdjTM9TG2Fabeiiat9LhbGbJpMCaQQlm59253A8AzYJZygQPf4E0UiSpcJdEAlgdONWUMyxerlQAzW2L3N84zoGep7cenfrrktPY41Xuds1BHClns7JwT2USo7nAHKFAF1knvtvka3XQccMGmd3vfXS/vhdY1CjvMhG0Kr+vIT9W8SKftd29BfJ7KYmHl/j9ng7GPCqMz13ZImDYquWyItzVCM5xBtMN7DomzhKBmWsypRfyzwAGEj2mh8lVZnDfVd8XNj+qI2FJ0XmisP1xUwWLgAxB+/7Q4WW2xClsbSlFrrTis2ECeG2F6unluIdbagA+/OZExde0f+J4o7j6LRZ4caWNzd7KcXL0AwAPypZ3ejqmxpLwFO3nGJfadVBCphpVDl1YNksVbWMDfx4F+7vi5fZLN+lIfRq7tJs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A per-thread CPU timer holds a reference to the PID of the thread it is
attached to and, while it is armed, its node is queued in that thread's
posix_cputimers. The task is looked up by that PID.

When a non-leader thread exec()s, de_thread() changes which task owns
that PID. pid_task(timer->it.cpu.pid, PIDTYPE_PID) then returns NULL,
but the node is still queued on tsk, which is alive. timer_lock_sighand()
takes a failed lookup to mean that the node is already dequeued, so it
has nothing to undo.

begin_new_exec() calls posix_cpu_timers_exit(me) right after
exec_task_namespaces() and that removes the leftover node, so the state
normally stays invisible. But bprm->point_of_no_return is set before
de_thread(), so if unshare_files(), set_mm_exe_file(), exec_mmap() or
exec_task_namespaces() fails, the task dies before it gets there.
exit_itimers() then frees the k_itimer while its node is still queued,
and reaping tsk later erases that freed node from the rbtree.

In short:

      the non-leader thread B           the parent

  timer_create(CLOCK_THREAD_CPUTIME_ID)
  timer_settime()
    arm_timer()            // the node is queued on B
  execve()
    de_thread(B)
      exchange_tids(B, leader)  // B's PID now belongs to the leader
      release_task(leader)
        __exit_signal(leader)
          posix_cpu_timers_exit(leader)  // cleans leader's queue, not B's
          __unhash_process(leader)  // that PID has no task anymore
    exec_mmap()
      mmap_read_lock_killable(old_mm)
                                kill(B, SIGKILL)
      // -EINTR
  get_signal()
    do_exit()
      exit_itimers()
        posix_timer_delete()
          posix_cpu_timer_del()
        posix_timer_unhash_and_free()  // freed while still queued
                                wait4()
                                  release_task(B)
                                    posix_cpu_timers_exit(B)
                                      cleanup_timerqueue()
                                        timerqueue_del()  // use-after-free

KASAN log:

  BUG: KASAN: slab-use-after-free in timerqueue_del+0x59/0x80
  Write of size 8 at addr ffff88801090e7e0 by task poc/99
  ...
  Call Trace:
   <TASK>
   timerqueue_del+0x59/0x80
   posix_cpu_timers_exit+0xa8/0xe0
   release_task+0x1c6/0xa40
   wait_consider_task+0x922/0x15f0
   __do_wait+0x3bc/0x3d0
   do_wait+0xba/0x1d0
   kernel_wait4+0xfe/0x1d0
   __do_sys_wait4+0x10b/0x120
   do_syscall_64+0xf9/0x540
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  ...
  Allocated by task 114:
   kmem_cache_alloc_noprof+0x143/0x3d0
   do_timer_create+0x156/0x890
   __x64_sys_timer_create+0x113/0x130
  ...
  Freed by task 104:
   __kasan_slab_free+0x43/0x70
   __rcu_free_sheaf_prepare+0x5c/0x260
   rcu_free_sheaf+0x1a/0xc0
   rcu_core+0x3d1/0xdf0
   handle_softirqs+0x133/0x400
  ...
  The buggy address belongs to the object at ffff88801090e700
   which belongs to the cache posix_timers_cache of size 384
  The buggy address is located 224 bytes inside of
   freed 384-byte region [ffff88801090e700, ffff88801090e880)

Dequeue the per-thread CPU timers of tsk before the PID changes hands, so
that a failed lookup again implies a dequeued node. Process-wide timers
are looked up with PIDTYPE_TGID and transfer_pid() moves that link to
tsk, so they are left alone.

Fixes: 55e8c8eb2c7b ("posix-cpu-timers: Store a reference to a pid not a task")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
Changes in v2:
- Add the trigger sequence and the KASAN log to the commit message.
- v1: https://lore.kernel.org/all/anfgrsPlUdwBhdrp@v4bel/
---
 fs/exec.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/exec.c b/fs/exec.c
index 745f6eb5279e6..9b2d140bd9f2a 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1003,6 +1003,18 @@ static int de_thread(struct task_struct *tsk)
 		 * the former thread group leader:
 		 */
 
+#ifdef CONFIG_POSIX_TIMERS
+		/*
+		 * exchange_tids() hands this thread's PID to the old leader,
+		 * which is reaped right after. The PID lookup in
+		 * timer_lock_sighand() then fails while the per thread CPU
+		 * timers are still queued here, so dequeue them first.
+		 */
+		spin_lock(lock);
+		posix_cpu_timers_exit(tsk);
+		spin_unlock(lock);
+#endif
+
 		/* Become a process group leader with the old leader's pid.
 		 * The old leader becomes a thread of the this thread group.
 		 */
-- 
2.43.0


