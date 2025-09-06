Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 649A6CA1002
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 13:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A56B28E0003; Sat,  6 Sep 2025 09:31:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2E948E0002; Sat,  6 Sep 2025 09:31:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 944CF8E0003; Sat,  6 Sep 2025 09:31:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77C748E0002
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 09:31:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 13ED61A0502
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 13:31:26 +0000 (UTC)
X-FDA: 83858912172.22.5DBB81E
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	by imf08.hostedemail.com (Postfix) with ESMTP id 53564160013
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 13:31:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of penguin-kernel@I-love.SAKURA.ne.jp designates 202.181.97.72 as permitted sender) smtp.mailfrom=penguin-kernel@I-love.SAKURA.ne.jp
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757165484; a=rsa-sha256;
	cv=none;
	b=PEFkO8uOGkz+HdYGY0DUjgRMXH32kNNT4+9jSxrt49eFYeDI1OgijWU3BYmFIyLvf+7oSi
	tupSBebA+3eVBzds/0vVyd2sZZM1NUSfpHneLQrkuDsqv2B5xPh7exokhW9wIprfNUG5Bw
	XEr0tyW9AaDvVcLyiuVLmdgtuq9oMss=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of penguin-kernel@I-love.SAKURA.ne.jp designates 202.181.97.72 as permitted sender) smtp.mailfrom=penguin-kernel@I-love.SAKURA.ne.jp;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757165484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W3RV8h8t/3UWT+BdhuejOemKXIuu7PzIp9vQ/OYcUwI=;
	b=lO6iBDvZx6Sw64jT2hw6Z3CoE7eh8fRtJO+UTmCahYeizzm97NHeArEuLBGnu0fPJVjz7k
	Pjim9BT/1bPDbF5rkDvNFH/q+xSXIbv4RewHywnRfY6v7JJU6qi+tp2CD2NjyaeuKnLB5D
	6RM/RJaJcoefc2APkqOebtnb0/m6xL8=
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 586DUZVP092719;
	Sat, 6 Sep 2025 22:30:35 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.10] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 586DUZ8m092716
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Sat, 6 Sep 2025 22:30:35 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <fa7b2e99-f91d-4126-9d0a-1b0330023394@I-love.SAKURA.ne.jp>
Date: Sat, 6 Sep 2025 22:30:31 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [hfs?] INFO: task hung in deactivate_super (3)
To: syzbot <syzbot+cba6270878c89ed64a2d@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, brauner@kernel.org, frank.li@vivo.com,
        glaubitz@physik.fu-berlin.de, jack@suse.cz,
        jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, mcgrof@kernel.org,
        shaggy@kernel.org, slava@dubeyko.com, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk, willy@infradead.org
References: <00000000000091e466061cee5be7@google.com>
 <68b55245.050a0220.3db4df.01bc.GAE@google.com>
 <20250902144655.5em4trxkeks7nwgx@offworld>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <20250902144655.5em4trxkeks7nwgx@offworld>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav203.rs.sakura.ne.jp
X-Virus-Status: clean
X-Rspamd-Queue-Id: 53564160013
X-Stat-Signature: i7mw9hr3zrpgzikdnjsdejp44xdony55
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757165482-374090
X-HE-Meta: U2FsdGVkX1/mCE8Eq9DHkchGLi68iBY/suNwheCHmPMFr6Emr79fFcq2pbtQVR/oVm9ZeV3ETc00T4wAmA0LOMAJnQO1Smmh7KeEIL/bgrY+TPBFGKh70RwKE0G2rg2ItPBKoXL77ShHvLZn3yH8ULojBXHWblJXVndeMX5Gnt1TgWOgU0PBY2l2TmvHuftb/Pfdq7V+DWlMNPi06UpuFZ3AACDk0z0123XhgJqOZIaXgOXGRP5wQgJB4N3oMDhLxZEAvL4bFE+2DvOyuoDi8tZdefSfgLwermJ0gbtxmrl2vrMl+0D54WPAhikTnC3//w58n20psMWFNhip4WOoCLCt5FRz2zIDmpdG4FVH9RdsQsiN6btzwCMtfLJByf9bPm7cbrtCd/ba3V+9GoJqtV3q0O/hlCNu14160pSSVqIAcy9OsZkH4nUOry+9TgQzOY5Zb+YR58/veiEq7rEiw3WjcU/uBoUItD7/MMDePeJzWRdtOGb6mWyn8t7JNfANlG7XQj1f3gkm8a0Xzod8xpvcJ4xhIH4hiN185IlXgQObYc/99J8END3K43UPTZrVL6KDCgR+pBNuJDi7yZtd9Os5Mr6lmm81F7MewYF1FLf36s7ztgReVAVzDvKgqHSlIoI2wA0BtsgcPVxzwwXHfgAcIOy0+Z8wTRWeDO2etdd0JRWuLVA5SfBvdGWS9gfHdUjwzElkFfIydnE5Qvi0hB7sjCNG9jFmNwiRIJVT9OorN+1eC+H4WmiD1q0tCibYIQ2D+dMIcbowO/nxPRx2s85l3Qo3CW1mDE2vFrMftl6IATrEItlfiDB+6ZX4GhiszUCbdcg8YgVt9F5e97Sk32d6BT8Qg8sCTt+7Nd6GycysbmygCfw7kt+HQy+yV5jSe7WPqX2VEe5My0Jn3zM2mMr7l+aMKmD8kpFAX6twQDQQ7QhhVDLWz9owm4c8NtzH/e/Ng6ZcAx0PIhoBFzW
 GO1Yq7a1
 a+SqG7IGwLorynsrZfunBjWoPtkKCo7+LodxudIUS+erOhfRDY5DMsww9ChhIHKtSf1oqFlUd0uPzmFCeQN1+I/ZDTsghkuBZQfa8+FmnDqss6gMwOyNXnJNmE9hm5VcgpmPFCln2T/5twq+CWglV20NsolfD0FbBm7qc0TFNeWbzkPSZNJkIM5MCDHOsmWRz3j7JYY0Lt6jKAMzJfkJyxnUFYuHlpDq6wWJbrdYSOq6Wbb3D1itYLblCyjjDlyzlE6ZYDhh//Bn9sSlh/AQaKxIk8/B1IInXDyQGhlH74elSwf9DEZY2lpQ3bEM3PZxitAfvbvaR5AhqWyap/0hikXSeZE+dfIxkoNb0oBa+fjwM7ox+xIvj63BUfWyoIxMtxy0yk7ilr6DOLzJijcsS9RSEgFN4jqDDilIBjjYkE2rr5io=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/09/02 23:46, Davidlohr Bueso wrote:
> On Mon, 01 Sep 2025, syzbot wrote:
> 
>> syzbot has bisected this issue to:
>>
>> commit 5b67d43976828dea2394eae2556b369bb7a61f64
>> Author: Davidlohr Bueso <dave@stgolabs.net>
>> Date:   Fri Apr 18 01:59:17 2025 +0000
>>
>>    fs/buffer: use sleeping version of __find_get_block()
> 
> I don't think this bisection is right, considering this issue was first
> triggered last year (per the dashboard).

I think this bisection is not bogus; at least that commit made this problem
easily triggerable enough to find a reproducer...

What is common to this report is that deactivate_super() is blocked waiting
for hfs_sync_fs() to complete and release sb->s_umount lock.

Current sample crash report (shown below) tells us that PID = 5962 (who is trying
to hold for write) is blocked inside deactivate_super() waiting for PID = 6254
(who is already holding for read) to release sb->s_umount lock. But since PID = 6254
is blocked at io_schedule(), PID = 6254 can't release sb->s_umount lock.

The question is why PID = 6254 is blocked for two minutes waiting for io_schedule()
to complete. I suspect that commit 5b67d4397682 is relevant, for that commit has
changed the behavior of bdev_getblk() which PID = 6254 is blocked. Some method for
reporting what is happening (e.g. report details when folio_lock() is blocked for
more than 10 seconds) is wanted. Of course, it is possible that a corrupted hfs
filesystem image is leading to an infinite loop...



INFO: task syz-executor:5962 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor    state:D stack:21832 pid:5962  tgid:5962  ppid:1      task_flags:0x400140 flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x16f3/0x4c20 kernel/sched/core.c:6961
 __schedule_loop kernel/sched/core.c:7043 [inline]
 rt_mutex_schedule+0x77/0xf0 kernel/sched/core.c:7339
 rwbase_write_lock+0x3dd/0x750 kernel/locking/rwbase_rt.c:272
 __super_lock fs/super.c:57 [inline]
 __super_lock_excl fs/super.c:72 [inline]
 deactivate_super+0xa9/0xe0 fs/super.c:506
 cleanup_mnt+0x425/0x4c0 fs/namespace.c:1375
 task_work_run+0x1d4/0x260 kernel/task_work.c:227
 exit_to_user_mode_loop+0[  309.321754][   T38]  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop+0[  309.321754][   T38]  exit_to_user_mode_loop+0xec/0x110 kernel/entry/common.c:43
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
 do_syscall_64+0x2bd/0x3b0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff4a4aaff17
RSP: 002b:00007ffe8b16a008 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 00007ff4a4b31c05 RCX: 00007ff4a4aaff17
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffe8b16a0c0
RBP: 00007ffe8b16a0c0 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 00007ffe8b16b150
R13: 00007ff4a4b31c05 R14: 00000000000257d4 R15: 00007ffe8b16b190
 </TASK>
1 lock held by syz-executor/5962:
 #0: ffff88803976c0d0 (&type->s_umount_key#72){++++}-{4:4}, at: __super_lock fs/super.c:57 [inline]
 #0: ffff88803976c0d0 (&type->s_umount_key#72){++++}-{4:4}, at: __super_lock_excl fs/super.c:72 [inline]
 #0: ffff88803976c0d0 (&type->s_umount_key#72){++++}-{4:4}, at: deactivate_super+0xa9/0xe0 fs/super.c:506

INFO: task syz.4.168:6254 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.4.168       state:D stack:25800 pid:6254  tgid:6254  ppid:5967   task_flags:0x400140 flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x16f3/0x4c20 kernel/sched/core.c:6961
 __schedule_loop kernel/sched/core.c:7043 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:7058
 io_schedule+0x81/0xe0 kernel/sched/core.c:7903
 folio_wait_bit_common+0x6b5/0xb90 mm/filemap.c:1317
 folio_lock include/linux/pagemap.h:1133 [inline]
 __find_get_block_slow fs/buffer.c:205 [inline]
 find_get_block_common+0x2e6/0xfc0 fs/buffer.c:1408
 bdev_getblk+0x4b/0x660 fs/buffer.c:-1
 __bread_gfp+0x89/0x3c0 fs/buffer.c:1515
 sb_bread include/linux/buffer_head.h:346 [inline]
 hfs_mdb_commit+0xa42/0x1160 fs/hfs/mdb.c:318
 hfs_sync_fs+0x15/0x20 fs/hfs/super.c:37
 __iterate_supers+0x13a/0x290 fs/super.c:924
 ksys_sync+0xa3/0x150 fs/sync.c:103
 __ia32_sys_sync+0xe/0x20 fs/sync.c:113
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f35c0abebe9
RSP: 002b:00007fff821c57b8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a2
RAX: ffffffffffffffda RBX: 00007f35c0cf5fa0 RCX: 00007f35c0abebe9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f35c0cf5fa0 R14: 00007f35c0cf5fa0 R15: 0000000000000000
 </TASK>
1 lock held by syz.4.168/6254:
 #0: ffff88803976c0d0 (&type->s_umount_key#72){++++}-{4:4}, at: __super_lock fs/super.c:59 [inline]
 #0: ffff88803976c0d0 (&type->s_umount_key#72){++++}-{4:4}, at: super_lock+0x2a9/0x3b0 fs/super.c:121


