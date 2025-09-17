Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCC12CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 20:40:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EE858E0071; Wed, 17 Sep 2025 16:40:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19F7C8E006B; Wed, 17 Sep 2025 16:40:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08E1A8E0071; Wed, 17 Sep 2025 16:40:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E85BC8E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:40:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A271D1A0696
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 20:40:32 +0000 (UTC)
X-FDA: 83899910304.29.9DD9046
Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	by imf25.hostedemail.com (Postfix) with ESMTP id DD60BA000A
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 20:40:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of 3vRzLaAkbAHAgmnYOZZSfOddWR.UccUZSigSfQcbhSbh.Qca@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.80 as permitted sender) smtp.mailfrom=3vRzLaAkbAHAgmnYOZZSfOddWR.UccUZSigSfQcbhSbh.Qca@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758141630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=KUCYj0fhxjvce8cBgXv45Gpv57iRXT6SbAGiU7Ajbu0=;
	b=Aox6JnzGPueXnkx+NSPYOMDw8r918O6TlId5n5B93slu9/qdK1KDpGt2Y4+GcrLWgpCXlF
	7hP73vGXbdrEvBwwl3SOCo/O2jAFWLebyITP/ME/o8hqazTkpze9d7UKRXSLHeqOOqnJWg
	O8O0g0LsttwElV9wlIagn8MMfsOt0m4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of 3vRzLaAkbAHAgmnYOZZSfOddWR.UccUZSigSfQcbhSbh.Qca@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.80 as permitted sender) smtp.mailfrom=3vRzLaAkbAHAgmnYOZZSfOddWR.UccUZSigSfQcbhSbh.Qca@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758141630; a=rsa-sha256;
	cv=none;
	b=KmFIU8yoEhkxtRAtQY+VMzN4FHyWbpD9rB0u60oKBOLo0po/jXRQWP19UaafTGjgIetudE
	2P4NndCWAl3Ul9OH4jeQuWZtthSM3tEqwwE/Tnp6rGrXzw419apDSlcG+qzIqCKOfbjDMY
	7MjHKjNi7avgOSp8HWDYj8mot1fz7TA=
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-8a559429a55so27354139f.2
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:40:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758141630; x=1758746430;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KUCYj0fhxjvce8cBgXv45Gpv57iRXT6SbAGiU7Ajbu0=;
        b=W6bqKCbLXoytV2OaH9vF9O8/6NQ7pVVZ0BgglioFHBbZ4LzHardN0k9o7Hvf2m46TE
         EZd4IGT9uu1HyVxtplE00RdEDBpeKICQOlVQUrIhP5LSdWqhzJZ334spZkp0pXK6zTQK
         QFVkIdhRSNjjAdlBSBT4ZMJCf/hNQHza4OV8uxGah4fqlBv02OsnoTQdIuUCHcumTIjJ
         cwO7R1SqnBvkaVsxAVXA5mgVxgVxwiR/OaKCAA9bxdJbxf3Qb0io0fytyz+7v+lhUcv7
         k6COjpNWNrQjcVqMtukXV0mRQclr8S11euadNQDGCHSTNAD5dpMrBo+KzWvHy3oEXAPH
         9iYA==
X-Forwarded-Encrypted: i=1; AJvYcCXKMi0EP2au4ox390qt6WURR5gBLX7q1shAW+ornHsqtYvNB2e2AN3KpxkMGzP3QqOnQSh+sRX+bw==@kvack.org
X-Gm-Message-State: AOJu0Yze8FE/gl67ETGN+tWLC/1fYfY5ZICZBYF/9XmqU1w8LogJ1hIZ
	Sjysu61tk/C32Ne1+22SOomO7sA8oTsuO978C10da2yiDWSdIYNzQa1cb9G2ZZcVHRsMdWlUUd7
	yh5zI0KS8X+aZ8ww7ULPB6qlkDRIDZekyVh82vr1dL9ONQjjD5J3Z4yBf4B0=
X-Google-Smtp-Source: AGHT+IGdPxS4H9dRvFlHe6Wk8P+TELA29Ig2qHHSvPSczHZXvjurzZu60fowB+sTUUIXjlKJVMIyB7j3CQDGyoJXkfcafvV894vG
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:17cf:b0:423:f9c6:f21b with SMTP id
 e9e14a558f8ab-4241a4deb08mr46830165ab.8.1758141629862; Wed, 17 Sep 2025
 13:40:29 -0700 (PDT)
Date: Wed, 17 Sep 2025 13:40:29 -0700
In-Reply-To: <683adb33.a70a0220.1a6ae.000b.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68cb1cbd.050a0220.2ff435.0599.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING: bad unlock balance in copy_process
From: syzbot <syzbot+80cb3cc5c14fad191a10@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, bsegall@google.com, 
	david@redhat.com, dietmar.eggemann@arm.com, juri.lelli@redhat.com, 
	kees@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, mgorman@suse.de, mhocko@suse.com, 
	mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org, rppt@kernel.org, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@suse.cz, 
	vincent.guittot@linaro.org, vschneid@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DD60BA000A
X-Stat-Signature: djuso8dtswqaimaj4qmgtwx5oo1pdsqz
X-HE-Tag: 1758141630-441180
X-HE-Meta: U2FsdGVkX18DMWM+bXAliBCHZWnWvWm97mUjGq2mp/+nWPTRJzT8QbDu9VfRVEJf9HeWf+FvwcIkJMj0edmQaYTCm3cj0B60Y1vLYwzLuadMGv2UxFCokKkcQ+5T20NH4v4AjwQoQyb/4Tu34+kRSKX1hDhcBETWQ6KZ9rKvz9MYG5yhb0DVNMJitf4Qrfn/aYIWN9gTIEV5uD54BuoqxAk9bm9TmBLyPPOIfFsGtBbBJFt+/GF9ll9Y1bZ3NNB+OJT2/Q5NXxUVxVVpujSxxeSY/j+Da2Mh+d4a4xKQ6tg1xjxNslZK5h3lcIov3c7MBeqj8AnOPEfh2eCkQs6DYVyU6zlwhKeKOwXC+22sxIVVy2ADXVCtQ8yYmK7G9uPePue25RiVnFo4liEY+PuJhJ3dYiqWz5Khw5pJLzVVGZo17yPNCxEv4RUk2+DzCm+omL6uVFCJD/ycLbkgDn25kli4O0Ul43GiZASziyO0uznjus/XLkBqzg7xKf5Z5GGRQc+c4SbXYAj/fJK2NXdtUEz/yiAHemd39k8w0lq2RueNdnhx3OCtMxi94mF44wAr/apzdh5BySSkh+8u5zvcNS12kPzfDczXTrTs1K14IYB573P/d+Z2aQ6jwtPwK9qKnhlHF7y6lzrCG1401t9KlOfYv/VhdRT4uA83GrIhYVyrZRCrQeDTmD8TXCUo8eGTCPbfDPTGZdEqIWIYz/9EzwXpi7itllq5JyFu4ldhxI9DthjFlhhAjmbAKHwSq3x4/i6McdQto73SQdU5oDD08Yn5ac1w3YDFR+1bkfJU0z2trXXdJV86ukU9zyn6xVA7Xfr+hCbl6wS48JDHrr/L5fJ/eG3jYdRlwrLuMR0DN3CQejd4EaaUNSWM//+6aKmYYp4dy0XsIq4XTdRBaR2g4IS8nbIXmEMWTxRpRRKLCGiXt9LumAgqQAcKMD9BFCiZmN2YcwWWXyhxblnCuCe
 Vs5AcLea
 NRGNlHrbIsMbebybaxG3w3oXFNrWm2e0uLlRWmGLyJ7ngL/wAmJVz2AYyJY65U0tfQywttf+tL6PUMZBMhNXBVW+sSprFJ3//DpNSWrctWCKaoTQ3H6a/ew4v6cx3+gM3anBVH0Y/kmf1SAJANrvaYn7PKFabjpq+NBeSlsV2X6FxZe6xek3HEAHL0d8zlzhEf5WF6lFAm6lhkUt4NNYeJbjMb5dDhHCMM0eLjTQptvA874xE+fYmMj/yIC38Ia+fA7xpnb/z/vphlM6wP89fC5VBxmCZVIoJPXh9CjHkuFquN3zLkbgJx+ZkeTRV2j5i9erQn2NP+apkwVpC/73mRSEXKN0Xfdvi5+amBNVsNxiyMf5ecflFbJ1oRcIfxz7Ok5Iz4pH2Z4LBs5QlHb4tH9BUIS4he5k9YxJMgEBAgKsJr8OQZbVXlVfwWYU5Cj6NEhf0G9RMacharU08XZO+W5M04l90S5bxLJN7fzHW9JWRDlbD3xOqHP4TEwRizwCZMgkdKAHaPayvvm+KTEuULdfLZT3VXONMIKpoCLGMJw71lQsSlJBarki7vNuxbfbF/Af//kfjnSTxJlsP6W1AQYjzrtRaBoWmKaTzB8XPqImLp5tgTz8uY8P90tKANnUIR44dYK/RRXKAKR2n5k/rNgQTpvPLKpO61rpyFnaxLFVPVyZx0WuMw4sM2GyUjFEUb5zWVxFqnc2EFy6OXKbSP7h50M4SkNAvdpojZe4qdV3l3d6VraxrGPTEG3bfQPAmd6fQtLV9FHO04PtmbW6/i4dop5JbaBTqJzxzp9/exl/Xe1u4Ii1Dk3P0KkVkbrsJB0TS4qVi+jVEnawzZYuvMbEq9OhYpAhZqdmjVYyhvYHRfGEsslAcqVMdlhuEy2wgRU4OvFnUui2Btb3Mh4GtLx4YVosaT2h9LIYncCct0s8i0cn6uyCRGvhttwrw8BmOMv8ANUWdQP5EqaZgeiiBuDuPiCsv
 1Sjsmkj8
 6pR2mJwygsUyHpZULZ5+HlCo422/OizxdPMW9K+IdcN2EBHyge03pdlIj5NRGHdDr4PN9jFyFvU+wu6+72yOnhv/73auEZpS8Ak72DA7hZEcojCjs1pdp/q+RFJzxBJ+AWwOQnV6Whx1s7mkWeEXJ8Q0KVZUIDhUsIvevWMX7d2Qy3zddrtTIff9kG2mXzfhzzIsSjK9H/KKB95gcfYYfQY9Bhm8n2DUPz4/zVeTVevoYNqw9zc4ClFcrKmLtKiQdXu0B1ZXAHhue2+qucsVIpfcJdk8faWmJYY250uoV/d78kSoVOyKtdK2EbSBkOcHC5QZzP3yvY0gJ2v8LzkOvsCdmE8VYCZ90j0W76B6GmihE/Ie5vw+V7p+CNx/Tr47e1F8Aelw5pAHd23Cr7F2ZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    6edf2885ebeb Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=16d14c7c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b8b6789b42526d72
dashboard link: https://syzkaller.appspot.com/bug?extid=80cb3cc5c14fad191a10
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=179d9f62580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11d14c7c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c72239eb6d76/disk-6edf2885.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b67e9820b2be/vmlinux-6edf2885.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0c4ab7e562f6/Image-6edf2885.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+80cb3cc5c14fad191a10@syzkaller.appspotmail.com

=====================================
WARNING: bad unlock balance detected!
syzkaller #0 Not tainted
-------------------------------------
syz.1.48/6865 is trying to release lock (&sighand->siglock) at:
[<ffff8000803b8634>] spin_unlock include/linux/spinlock.h:391 [inline]
[<ffff8000803b8634>] copy_process+0x22d4/0x31ec kernel/fork.c:2432
but there are no more locks to release!

other info that might help us debug this:
1 lock held by syz.1.48/6865:
 #0: ffff80008fa00450 (cgroup_threadgroup_rwsem){++++}-{0:0}, at: copy_process+0x2228/0x31ec kernel/fork.c:2274

stack backtrace:
CPU: 0 UID: 0 PID: 6865 Comm: syz.1.48 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 print_unlock_imbalance_bug+0xf4/0xfc kernel/locking/lockdep.c:5298
 __lock_release kernel/locking/lockdep.c:-1 [inline]
 lock_release+0x244/0x39c kernel/locking/lockdep.c:5889
 __raw_spin_unlock include/linux/spinlock_api_smp.h:141 [inline]
 _raw_spin_unlock+0x24/0x78 kernel/locking/spinlock.c:186
 spin_unlock include/linux/spinlock.h:391 [inline]
 copy_process+0x22d4/0x31ec kernel/fork.c:2432
 kernel_clone+0x1d8/0x84c kernel/fork.c:2605
 __do_sys_clone kernel/fork.c:2748 [inline]
 __se_sys_clone kernel/fork.c:2716 [inline]
 __arm64_sys_clone+0x144/0x1a0 kernel/fork.c:2716
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

