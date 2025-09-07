Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6A45CA0FED
	for <linux-mm@archiver.kernel.org>; Sun,  7 Sep 2025 02:03:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D739A8E0002; Sat,  6 Sep 2025 22:03:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4AD88E0001; Sat,  6 Sep 2025 22:03:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C879A8E0002; Sat,  6 Sep 2025 22:03:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4C618E0001
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 22:03:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4370713B91F
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 02:03:25 +0000 (UTC)
X-FDA: 83860807170.07.441F40A
Received: from mail3-166.sinamail.sina.com.cn (mail3-166.sinamail.sina.com.cn [202.108.3.166])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2C5C740007
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 02:03:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=n6h8UT41;
	spf=pass (imf01.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.166 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757210603; a=rsa-sha256;
	cv=none;
	b=RmW1I0+hRMvagvSRjOuHNZ+Qd7lU5s7czCZ573oZuUUeZKNWJGy4c8O7m6qsAz47YX8OpQ
	rkSqFbaNOhHP8+UebBaCDxc+8DwAMNEWnaEBR4DeTjVJVDAvhh8vxeYdTjuUurMp3OQglm
	1+eSl7PwLBE8VO7RnShCEVfsQ2S/Gts=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=n6h8UT41;
	spf=pass (imf01.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.166 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757210603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=22TA40f9zATZiAYAph/4a9KRoNwLAcg3w+fJaxBRaqs=;
	b=FYlBqlmXLTD2U92gWmn17kzhyB0BkUDFO3kDbv5WWkj1uElxtZqwdb+lhwCJGPoboa9Cjt
	vgZikTZs8dXAo27HrYSZaTUK8QuscpexDa+pDmPmNcsi2BwvBcqzU5gcIMQdqkevWSLFnX
	ZS94o4YKSP6M6KVgyTVADMZw800s14Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1757210602;
	bh=22TA40f9zATZiAYAph/4a9KRoNwLAcg3w+fJaxBRaqs=;
	h=From:Subject:Date:Message-ID;
	b=n6h8UT41+pQzuKx7CQ/ASuUU+NLFSgYaub8fvqaao36nZM7IrsdsW4GhgWq5SP3aH
	 1rylBJ5ziqA926JDObY28yncbja0C2iQJerfGTpaJ9N5qO5vtY8jAnPYlH0jf5lJJb
	 BN0A5u1U5Oiw0bgFEcBJC5V62UrWJt1oIsoxYbHI=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.236])
	by sina.com (10.54.253.31) with ESMTP
	id 68BCE7E300005042; Sun, 7 Sep 2025 10:03:17 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 733136816349
X-SMAIL-UIID: A111DB9CC409472FB07435C46B6DE1A7-20250907-100317-1
From: Hillf Danton <hdanton@sina.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: syzbot <syzbot+cba6270878c89ed64a2d@syzkaller.appspotmail.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Davidlohr Bueso <dave@stgolabs.net>,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [hfs?] INFO: task hung in deactivate_super (3)
Date: Sun,  7 Sep 2025 10:03:09 +0800
Message-ID: <20250907020310.6559-1-hdanton@sina.com>
In-Reply-To: <fa7b2e99-f91d-4126-9d0a-1b0330023394@I-love.SAKURA.ne.jp>
References: <00000000000091e466061cee5be7@google.com> <68b55245.050a0220.3db4df.01bc.GAE@google.com> <20250902144655.5em4trxkeks7nwgx@offworld>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2C5C740007
X-Stat-Signature: k8fzds6pqfdsqhdntjqxgzgwc6ewoyfj
X-Rspam-User: 
X-HE-Tag: 1757210601-704613
X-HE-Meta: U2FsdGVkX1+9odpfQK+Wom6ZFsV+GFaaBHRGMropHop2znWkXO3yoeb2R+tefqkBxMlHwlwwAHBYZeQOt45l92PteQPTM9OYP/8D4jjdenGW5a4trXs15/Xr7KRRMjuuXapn0N1teUOIjdIBPYfxFY+E1DwhAIPB9+nJ1CEMfQ2hGnVwLkyxZF27S8/4ISAF24bhHPWwzReOPuRP54W6vmeyIR+f8KkUJEdOVee0DukQNzlsBDiguxAc92rXOLIPK+DKd5eugnPfNTXxgKeOG0W3wBc0g7tcjap/tlks6bJrOza6Zn3w8sxWDPYiCNM2SzyK51Hm2lrzcD3OkzDDMKY/Bod2DS6nzbRv9nDeEPOYNJNGEOn41CE4tcGUhE+7ZQrzRg5he3mbHyabZR4buC0cJ+p8yD5j9yfYHhyL25afMBOC1PGvZpRCL7aSdQTHrQT8J0uJ6SmmqCQ+nEhX+PBtDOnzQwX4RQ9e+kO6ceZWEy1LMdoCc6LUdXjs+/JGoO5CMgbZ5vSVY9NcQ5uf/RZthLKflvt10r7/GDznsrfK//JzCm8tIvdrLTNjxhGRAMMzy1+p9ZNDZ+dWy0CR5QnAanV10Wx/rbG8mKAC297ox41oDd9he6FrKHCO5bihRneXzKTHIsqYPdI7c3w9hEopl0l0UrtRjulpZ8dfOom6ltOOIb5eweGoklwWp0BgHp7iLtT5a2XmE3ilgMEQ8yZHZpkyrdxz9wQFPZ0tRY09+Itr3JozFPgoGdURSbmABX9OBTx2zVJs38lAmHba0OJwbiezrDO7/vU/8SprCRZcaNE7vZqn6Uo/dZpNgBU/VqR6ssyI7l7Pneeh/VM9eX4o2VBi4HolPsTWpGTKZ3D1tIBffWHFTjW584wd+L75pnAlowhGuwDBRoCEUMGd19qv6ym67s7P7Mt+3mbXgTSTVq2JOlKAjcKzfZ8iMgp1idE3IkpEHFAkjmvoPlj
 X6cZYkyC
 xSbWlaqu+tmOmCpbntxnrDw+DEurjVu5SXFjku2I9vtRd141q9YU6ZsX2uJR8cy5CY/LFkzft1y3atdjBFWqPlsr5ckAoJEPmfTwpfvwSi0DQr3EZfg7Yt3v0V3Z1IUyFJGaLZFrnEseoHmQkVTSkVacVWR+mBlHswB5ucgRu7MiT2kf/2ltTJfdTwmnxXd70VEhJeY0WqLiKYyEUZ10b4OEoEamtAdReWaoVu2FkGtjE776dSvsrMRF3afHN5f7qnofRR28lRFmJPLbsrCWFNAt8G+ezS8jWyXdaE9dr70rqhlgYzjc9sSRt47SppeUj5ETCRQpducdpegFjRPUN9KW/RNI265Zm/5ADvBuz99B/I31JCQIA2l3eVMWIdRMfbf2kmh+rcRPgqfnXssbyif3htSjju90QjEOB7gxiHM5lpmZf+kZlEr+3zIB3UaSKOpa6Qsyd0C9ZfqtMFmfAmCCnbDazlMNQQLJUxF4JTrEG3Pqsgq3m9SSqrHHMHzejpV1Lzp8B+4va7m80BMdHDJw4nNw+kE/ofcmGQNvKNPwCmSP/K3i7yElDSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 6 Sep 2025 22:30:31 +0900 Tetsuo Handa wrote:
> On 2025/09/02 23:46, Davidlohr Bueso wrote:
> > On Mon, 01 Sep 2025, syzbot wrote:
> > 
> >> syzbot has bisected this issue to:
> >>
> >> commit 5b67d43976828dea2394eae2556b369bb7a61f64
> >> Author: Davidlohr Bueso <dave@stgolabs.net>
> >> Date:   Fri Apr 18 01:59:17 2025 +0000
> >>
> >>    fs/buffer: use sleeping version of __find_get_block()
> > 
> > I don't think this bisection is right, considering this issue was first
> > triggered last year (per the dashboard).
> 
> I think this bisection is not bogus; at least that commit made this problem
> easily triggerable enough to find a reproducer...
> 
> What is common to this report is that deactivate_super() is blocked waiting
> for hfs_sync_fs() to complete and release sb->s_umount lock.
> 
> Current sample crash report (shown below) tells us that PID = 5962 (who is trying
> to hold for write) is blocked inside deactivate_super() waiting for PID = 6254
> (who is already holding for read) to release sb->s_umount lock. But since PID = 6254
> is blocked at io_schedule(), PID = 6254 can't release sb->s_umount lock.
> 
> The question is why PID = 6254 is blocked for two minutes waiting for io_schedule()
> to complete. I suspect that commit 5b67d4397682 is relevant, for that commit has
> changed the behavior of bdev_getblk() which PID = 6254 is blocked. Some method for
> reporting what is happening (e.g. report details when folio_lock() is blocked for
> more than 10 seconds) is wanted. Of course, it is possible that a corrupted hfs
> filesystem image is leading to an infinite loop...
> 
Or due to something else in your case because it is legal for RT tasks to
occupy any CPU for more than 120 seconds.
In other word RT makes RCU stall and task hung legally acceptable. That is
why running syzbot with RT turned on wastes minutes.
> 
> 
> INFO: task syz-executor:5962 blocked for more than 143 seconds.
>       Not tainted syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor    state:D stack:21832 pid:5962  tgid:5962  ppid:1      task_flags:0x400140 flags:0x00004004
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5357 [inline]
>  __schedule+0x16f3/0x4c20 kernel/sched/core.c:6961
>  __schedule_loop kernel/sched/core.c:7043 [inline]
>  rt_mutex_schedule+0x77/0xf0 kernel/sched/core.c:7339
>  rwbase_write_lock+0x3dd/0x750 kernel/locking/rwbase_rt.c:272
>  __super_lock fs/super.c:57 [inline]
>  __super_lock_excl fs/super.c:72 [inline]
>  deactivate_super+0xa9/0xe0 fs/super.c:506
>  cleanup_mnt+0x425/0x4c0 fs/namespace.c:1375
>  task_work_run+0x1d4/0x260 kernel/task_work.c:227
>  exit_to_user_mode_loop+0[  309.321754][   T38]  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  exit_to_user_mode_loop+0[  309.321754][   T38]  exit_to_user_mode_loop+0xec/0x110 kernel/entry/common.c:43
>  exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
>  syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
>  do_syscall_64+0x2bd/0x3b0 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ff4a4aaff17
> RSP: 002b:00007ffe8b16a008 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
> RAX: 0000000000000000 RBX: 00007ff4a4b31c05 RCX: 00007ff4a4aaff17
> RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffe8b16a0c0
> RBP: 00007ffe8b16a0c0 R08: 0000000000000000 R09: 0000000000000000
> R10: 00000000ffffffff R11: 0000000000000246 R12: 00007ffe8b16b150
> R13: 00007ff4a4b31c05 R14: 00000000000257d4 R15: 00007ffe8b16b190
>  </TASK>
> 1 lock held by syz-executor/5962:
>  #0: ffff88803976c0d0 (&type->s_umount_key#72){++++}-{4:4}, at: __super_lock fs/super.c:57 [inline]
>  #0: ffff88803976c0d0 (&type->s_umount_key#72){++++}-{4:4}, at: __super_lock_excl fs/super.c:72 [inline]
>  #0: ffff88803976c0d0 (&type->s_umount_key#72){++++}-{4:4}, at: deactivate_super+0xa9/0xe0 fs/super.c:506
> 
> INFO: task syz.4.168:6254 blocked for more than 143 seconds.
>       Not tainted syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz.4.168       state:D stack:25800 pid:6254  tgid:6254  ppid:5967   task_flags:0x400140 flags:0x00004004
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5357 [inline]
>  __schedule+0x16f3/0x4c20 kernel/sched/core.c:6961
>  __schedule_loop kernel/sched/core.c:7043 [inline]
>  schedule+0x165/0x360 kernel/sched/core.c:7058
>  io_schedule+0x81/0xe0 kernel/sched/core.c:7903
>  folio_wait_bit_common+0x6b5/0xb90 mm/filemap.c:1317
>  folio_lock include/linux/pagemap.h:1133 [inline]
>  __find_get_block_slow fs/buffer.c:205 [inline]
>  find_get_block_common+0x2e6/0xfc0 fs/buffer.c:1408
>  bdev_getblk+0x4b/0x660 fs/buffer.c:-1
>  __bread_gfp+0x89/0x3c0 fs/buffer.c:1515
>  sb_bread include/linux/buffer_head.h:346 [inline]
>  hfs_mdb_commit+0xa42/0x1160 fs/hfs/mdb.c:318
>  hfs_sync_fs+0x15/0x20 fs/hfs/super.c:37
>  __iterate_supers+0x13a/0x290 fs/super.c:924
>  ksys_sync+0xa3/0x150 fs/sync.c:103
>  __ia32_sys_sync+0xe/0x20 fs/sync.c:113
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f35c0abebe9
> RSP: 002b:00007fff821c57b8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a2
> RAX: ffffffffffffffda RBX: 00007f35c0cf5fa0 RCX: 00007f35c0abebe9
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f35c0cf5fa0 R14: 00007f35c0cf5fa0 R15: 0000000000000000
>  </TASK>
> 1 lock held by syz.4.168/6254:
>  #0: ffff88803976c0d0 (&type->s_umount_key#72){++++}-{4:4}, at: __super_lock fs/super.c:59 [inline]
>  #0: ffff88803976c0d0 (&type->s_umount_key#72){++++}-{4:4}, at: super_lock+0x2a9/0x3b0 fs/super.c:121

