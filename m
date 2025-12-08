Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26ED0D3B7DD
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 07:41:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89E186B0005; Mon,  8 Dec 2025 02:41:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84F2E6B0007; Mon,  8 Dec 2025 02:41:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 765CD6B0008; Mon,  8 Dec 2025 02:41:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5E0996B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 02:41:33 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DBEE513BF80
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 07:41:32 +0000 (UTC)
X-FDA: 84195508824.25.3D623FF
Received: from mail-ot1-f78.google.com (mail-ot1-f78.google.com [209.85.210.78])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3BA171C0008
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 07:41:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf18.hostedemail.com: domain of 3KoE2aQkbAFcHNO9zAA3GzEE72.5DD5A3JH3G1DCI3CI.1DB@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.78 as permitted sender) smtp.mailfrom=3KoE2aQkbAFcHNO9zAA3GzEE72.5DD5A3JH3G1DCI3CI.1DB@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765179691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=HAJLktDUT5UAtTvUMmyn8iaBW7gi9xsVys20jnFN8zA=;
	b=w9Mx2rPlmSG6wemWz0LYGiJE2tnxUmn8x9jMO1RYSwMkFxTmjE+fkpQE0SRzd0nWTINpVx
	7S9jMWBVNW38twEnu8UTsj1fKhjt6uY7tbLXofZx9SEmeS4ByGNY/bKFFbSfQJkfsI4LxL
	GVlwAi3fcoYefEXxTnf6mvRX5/U8vuI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf18.hostedemail.com: domain of 3KoE2aQkbAFcHNO9zAA3GzEE72.5DD5A3JH3G1DCI3CI.1DB@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.78 as permitted sender) smtp.mailfrom=3KoE2aQkbAFcHNO9zAA3GzEE72.5DD5A3JH3G1DCI3CI.1DB@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765179691; a=rsa-sha256;
	cv=none;
	b=GnXw+qKv8mSiuaBYn4KMGXjc7PdmWHG1hR+yyFufa/WDwNqiONJB0b4S6wxswbXoGx6w0g
	5LhmdI83Q6omzCf/vBl1SEoRlQsIbTSvaZ/JxRam0Pcg0uXomc7GXw3py461tk/pkc9d1D
	GPsu/Cd3rUhpMOfEWe3F9mlnuDxcQfg=
Received: by mail-ot1-f78.google.com with SMTP id 46e09a7af769-7c7046514a2so3523374a34.0
        for <linux-mm@kvack.org>; Sun, 07 Dec 2025 23:41:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765179690; x=1765784490;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HAJLktDUT5UAtTvUMmyn8iaBW7gi9xsVys20jnFN8zA=;
        b=QXWxhCMKb9hkSx3pbVxkPbc/lmbZrh37R4HktTsbFtG1hP1PxmPSi7DRbfFzZBYXKo
         AeFgaPS3rz36/+Mzqr7wEb1dWuYJwcPtHug2oe0KnN0aSFZv/5/aqbcOcub1fvxvd2cr
         l49JOmIUYiDK1FeQCFQS66na1F9BnAU0nTH5+Hbb3aqks2EVlD8iMrXcgQNCYj+h24L7
         44+APwKTzIzwm+V2+S3oVDsxFfg9GUZsCeURlv4YV+ZMIPrHEonfUmnc98TTzeFwtltt
         SwnNr1HCqagekSZpR27MjwHXrpG2mMyDdChIdFsk80aMwtFGjFJfXZNp/xkjylDsGMSM
         mjIA==
X-Forwarded-Encrypted: i=1; AJvYcCVpciRW43GeJXn/fOGTwiomBcR2x2xB1cs4wrg0Ynm8W57T6Y1u3x54/TMnlVAuKea6HLk8PAxEmg==@kvack.org
X-Gm-Message-State: AOJu0YxrnrObaHzYkNMAU6M+KT/CrBKixLJwZVl0UJdmOoscDubN1yTB
	TQiSbAc3ZiSi88X5YFRyYWpNyXEUPgmceBn1y0GDolVbDgRIB9OwTc6Eh1QJIugtFR5NJ+6eyvi
	ev7Z0f/gly/hNzUODLG6vzlMs9KeF9OCQKpMH62urczcRQ89mzy2sAiiz7VE=
X-Google-Smtp-Source: AGHT+IHHUhiHxMQodLBXeULNXQ0OrFhXJXKuhMghr5VAzQPOCwO/WjmqVlj4CKi/5XbQ01Sa2V/LDdpKuTjP9TepslLAIIrvk04f
MIME-Version: 1.0
X-Received: by 2002:a05:6820:607:b0:659:9a49:8dd9 with SMTP id
 006d021491bc7-6599a8e96fbmr2538934eaf.27.1765179690145; Sun, 07 Dec 2025
 23:41:30 -0800 (PST)
Date: Sun, 07 Dec 2025 23:41:30 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6936812a.a70a0220.38f243.0090.GAE@google.com>
Subject: [syzbot] [mm?] BUG: sleeping function called from invalid context in kvm_mmu_notifier_invalidate_range_start
From: syzbot <syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, mhocko@suse.com, rientjes@google.com, 
	shakeel.butt@linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: 4cyfhxn6hd3i7o8f9np9i33ej9oe3mfj
X-Rspamd-Queue-Id: 3BA171C0008
X-Rspamd-Server: rspam06
X-HE-Tag: 1765179691-472606
X-HE-Meta: U2FsdGVkX18DKJuxmFMpmHvHqTImrL/w10k9E1XflVc50Uee6N0HdlgnLyaLOOEueV5CyQhVq84GuZO+6divmDKRwP6BPtCnPZFJYzhKcLWf3kQ2oCnFaFV9SihMYt6g7+q0I7GwNv6m2gQXxkZno3OcsCoF145wWa/+q9RoH9uH6dw1Zzf+uKBk4DFwTgVZZ0oi4a4NVBydAGTFfZvFRpxM0BxRDsBvoRYkGdjL5F8hOyntDsPmJzK+Qgg/HALQvSUD4aiT3+7BciIRPFw90osu53YsqFqvkemHy9rTHSELcOA9WUfThaDrxFnvynl3ADIhAu7dH87HCcvkNYLeaw7Nafj9Vzhueujrit7j9/61AiSEfb1yQYj97s+GUrlK7Z7P5GJJ68cSCYNRd+sB/+58AOs/YMnnbF1hGaZHhgRmW5gaTsu95ziKmrfUn9jfhmVi/We9rllQo7nQ/oaQsLO1kt9wXy69W7dYzgC65k3sFAVrAwS7INpkBmpDfwfJyeX36jBqjJmsedvSQlgMYeAePv3bSAvmW7gbY12cDPMbckq/JMjAb8FuXoyrBts8yb/mNyBU8ltIlabPghHTFUFF3+fCTnQpGcirLYQpDstVJtobVFcAA2liEG5b0J/bo1d5g2p1EvsiV0pn12o5Bynm9BygLZOIC7IXTUwhXoJDIyk5ffRGKI8b+9OC8+/rhKmrQwue5EK7P5gZQ4+DDEFqlwHdo7WeYl/OmT2CF9ckQ6exstFxeTxbzv2LHWjv+1SgSNMn65oA+ud17RtpGu3VBgZQUyYSag0EWeKMUGWC1L8J6eW7XgoaMbKj2IMyIAQxiq+N8Ao36DUHiNzScFhQWAjtr7PHgg0imWYtwjq+HFqI3nN+xp+enSt8Ha0W1+cNCVVvLfWlkh7xp6rCydMtkO8XUv6T+PeZusmDnYR/UxKyY+0NLjk9XDX+B3wS31B3Tzpq2MO26ujujm1
 qQr0QgIV
 vN3PRW642XJpK4KX+E/JsgeRUamNTPaumFhuVpcNF9pT40fX8AluAIEnG14N6+A933jtljMAWXARrKX1d+Urygdj9aTXO69E7iJPSlMBO+N7CK2EL/dojGYSZfBUCLJJUhliXCavu2/+5k9prh2qkMfv/2JKhE/YlJB7SEhp2rpOscckzBlr8Lt41uMmhHDF1cwZJ4MzxfJ/oEQvLp7yQZ1WZPmhqo3m0OJFmCJcDC85B+W9xa/wFuFUOL+FrtBIG3OGe/kWePEQoxA7wJw6ifPJ4Z0/0uatRFkEYEGnfrS9Xtbug6pszu+liS09WeTpTUIf/8iGzelE9Y9ox0qoypEBAxtdykZ+0i1es++TK0jvu0c4ar09zrGqftUfZKg2z07bw6saRlyaxArLIVDsxyCYRVqXYJLnNs1fc+GdYqS8GDWJBhBe9LhG9NwIBNzh66z4PMtEu0oukEvq48kd0/64w/1I3DUDz2UVau8WVAqdLwacbz1ZsE5p3pxxKLpO3ILgM372sLttD6lmztVEBeIi4wEypIvIGOHqF0o1IZ1zBImxSYOse3/19IbQXAELX42eqrkHBLZQK/YMJFsxq2Ew4u6tZsSxa4j5F4KWKnqy5y1bMjBZrSCZOflpSDrIyChIfovFJudATPhLATbNBCfJ8hAvLAJy/CrgMZf/clO0+eg3HUq4EF9d7ZHfhksAt+3fuXoEJR9ObY4VFZbTCzsLxjLPAXArlZqaiLKkMjUTMLoeJ1+kNFIabiDyQDChnZbe3drCSj3C2eFg5207tqhGx8OZEva3OUNdOysKxDje6ovtSbOjWeeIn5D7MO1mHlA/vRDGaqLdKyGH8UqDqJBPlr2XlBRDiQV7N8S0f+uxevxrRAtb8lIZIJMyC8SoGvpAixro8ju6VBucmgNXKMgNn0hnF0nbiUzUFUzmbIdlwt0p20MRpgE6qJqu+swe+Af0IQoqSNNc+Sf6bsdq40KMjZ1LO
 kAIv9zTV
 0We7lzTppAchSDLRCbLLIgFYtowvJa6Lj/AYCrsklAnWmmlvnYiIyA4fWB/gUFnvqSh9wgZfHGH3wCXSWnQdNlFheNASjniYk57TMO32p5shAYmrepdWNojXoqhG7vJlwpG+/oWwpCeyCcOlA8dduqpz/TNLyJMeT0sJpPZtY2jwo8r4MoNaekAvcwus+mQrXo1J3qZXcNTwtynMze8aSUTFT+AKUnwDx69MyaJxEPboDn2MTlOLteHmNDYpQ63x6Sf7El9/5MvqWro/b21mU9AbaAFL9n3GuRCF4AD4d6sVyIUr8evQWzosY1JMKsj2cHYKw6dH30gwbc8qoNSqthdPTyBrs+Ypvo2UPLotvart0JTVJjVVuo3n69PvBa6LlofdFIUbftDlIp4bSX7XmKsb0GBXG8Mkbl8lWVLrJlSOOxMsW6XO6GV7PyzcVwfYezeN5q+nPg8bHtrSz1IiLNe/xyJq8KGoBIfQ8GaTcx7JvpYjjJxU67IHx1esDVEE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    37bb2e7217b0 Merge tag 'staging-6.19-rc1' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=159b2992580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8750900a7c493a0b
dashboard link: https://syzkaller.appspot.com/bug?extid=c3178b6b512446632bac
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/461486e4058d/disk-37bb2e72.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/844c0aeb98b9/vmlinux-37bb2e72.xz
kernel image: https://storage.googleapis.com/syzbot-assets/20fb43a5a012/bzImage-37bb2e72.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
in_atomic(): 0, irqs_disabled(): 0, non_block: 1, pid: 39, name: oom_reaper
preempt_count: 0, expected: 0
RCU nest depth: 0, expected: 0
4 locks held by oom_reaper/39:
 #0: ffff888030a29070 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_trylock include/linux/mmap_lock.h:410 [inline]
 #0: ffff888030a29070 (&mm->mmap_lock){++++}-{4:4}, at: oom_reap_task_mm mm/oom_kill.c:582 [inline]
 #0: ffff888030a29070 (&mm->mmap_lock){++++}-{4:4}, at: oom_reap_task mm/oom_kill.c:625 [inline]
 #0: ffff888030a29070 (&mm->mmap_lock){++++}-{4:4}, at: oom_reaper+0x27e/0xa90 mm/oom_kill.c:666
 #1: ffffffff8d6ce600 (mmu_notifier_invalidate_range_start){+.+.}-{0:0}, at: mmu_notifier_invalidate_range_start_nonblock include/linux/mmu_notifier.h:456 [inline]
 #1: ffffffff8d6ce600 (mmu_notifier_invalidate_range_start){+.+.}-{0:0}, at: __oom_reap_task_mm+0x268/0x490 mm/oom_kill.c:558
 #2: ffffffff8d6ce658 (srcu){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:185 [inline]
 #2: ffffffff8d6ce658 (srcu){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:277 [inline]
 #2: ffffffff8d6ce658 (srcu){.+.+}-{0:0}, at: mn_hlist_invalidate_range_start mm/mmu_notifier.c:468 [inline]
 #2: ffffffff8d6ce658 (srcu){.+.+}-{0:0}, at: __mmu_notifier_invalidate_range_start+0x30b/0x840 mm/mmu_notifier.c:533
 #3: ffff8880276bcaf8 (&kvm->mn_invalidate_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock_rt.h:44 [inline]
 #3: ffff8880276bcaf8 (&kvm->mn_invalidate_lock){+.+.}-{3:3}, at: kvm_mmu_notifier_invalidate_range_start+0x1bd/0xae0 virt/kvm/kvm_main.c:750
CPU: 1 UID: 0 PID: 39 Comm: oom_reaper Tainted: G             L      syzkaller #0 PREEMPT_{RT,(full)} 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 __might_resched+0x44b/0x5d0 kernel/sched/core.c:8827
 __rt_spin_lock kernel/locking/spinlock_rt.c:48 [inline]
 rt_spin_lock+0xc7/0x3e0 kernel/locking/spinlock_rt.c:57
 spin_lock include/linux/spinlock_rt.h:44 [inline]
 kvm_mmu_notifier_invalidate_range_start+0x1bd/0xae0 virt/kvm/kvm_main.c:750
 mn_hlist_invalidate_range_start mm/mmu_notifier.c:478 [inline]
 __mmu_notifier_invalidate_range_start+0x440/0x840 mm/mmu_notifier.c:533
 mmu_notifier_invalidate_range_start_nonblock include/linux/mmu_notifier.h:459 [inline]
 __oom_reap_task_mm+0x2cb/0x490 mm/oom_kill.c:558
 oom_reap_task_mm mm/oom_kill.c:601 [inline]
 oom_reap_task mm/oom_kill.c:625 [inline]
 oom_reaper+0x3aa/0xa90 mm/oom_kill.c:666
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
oom_reaper: reaped process 20496 (syz.8.2014), now anon-rss:24kB, file-rss:21692kB, shmem-rss:128kB


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

