Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FC49EC111D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 18:32:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADFC06B0005; Mon, 23 Feb 2026 13:32:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB4256B0089; Mon, 23 Feb 2026 13:32:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D79A6B008A; Mon, 23 Feb 2026 13:32:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B80B6B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:32:37 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 27E0614029D
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:32:37 +0000 (UTC)
X-FDA: 84476567154.25.0199AA4
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7754C140007
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:32:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf09.hostedemail.com: domain of 3Qp2caQkbAEMx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3Qp2caQkbAEMx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771871555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=7QMuhMBNjRk6WcObcYhdE75jwu9GjlU0BlV6mMFMPZ8=;
	b=TYBGbh9RLW3pdctTyW0NQ0gtT5Ah7O4CvJ5iHC/DtZxxPozjZv4+CqYz5u/0wmjkfZN8t+
	7WM4ip4NmwHGoepzByVB/aW31rWGTMfvCEzX4OO3N0mo1D9mU3Od2h8SeC3EecVGlO51Dp
	NLXMo5nyz7+OCZ+Tf08/u0qXxfKRTAg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf09.hostedemail.com: domain of 3Qp2caQkbAEMx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3Qp2caQkbAEMx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771871555; a=rsa-sha256;
	cv=none;
	b=jBMVJ5yELuW7frkbrb4B1O3uDxxuB1bTYtXNOe7thlY8zipAE3WWe/wbs26v18oL1aVVdd
	EDdXPUMGU7RhpQ3JvwtYJPVlie9J3CGfQ3ix1znQFHydMdwVvwi0OPyFvqw6EWCIefwhxV
	sgzoC26fMs3FZTqhbvSFhjFqykPGtIw=
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4639eb7bd4cso17881467b6e.2
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:32:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771871554; x=1772476354;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7QMuhMBNjRk6WcObcYhdE75jwu9GjlU0BlV6mMFMPZ8=;
        b=RmJGIiC1PFlBJiwE/K7nM/BGOdy9kJSv56MKXGpH+YrLRGEgPod2g2rMnhjb/QMYHg
         FBxzNkLZ5VL6ZkoSMh5E1KZ+dUIqt8iHP4CIVmSPmj+J8p5QAKilMuM5u7NGNvH6BYnz
         OUhB+HNAh9/kZWOL/AhYvVHAagBapXXt+9rRLWDRn6BHZ0R6VwTGRXEz+LIdGigq/YfC
         INx5IzzqJQUHE26G12OMNrtZ8yuZcySk5pJDptKlH1K/RrqsLAYpz1v8jNeoO4gC9mQ9
         91CUvxzDU0PVsC8A90JwFkE489TquE1M3Ms9F/R+ba2+UEDj+PIVdm98oe1Fe8o/ElEO
         VeiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNwRqGDUYUj34aqoI93o0BQsnRRr9zcM/aaVdH9kll09cpnyPZaHsn91U8ZO2w02hxRkpblEGKQw==@kvack.org
X-Gm-Message-State: AOJu0YxMBLp4olXJrNyW7SE+kHAYyZYp86ltGJbJvWpIbDjcNzgEPCIL
	LhFvlTJD4wCC9vVYvKY57SpzRDlW/ijHGw5RWpV36zLv3bh0HGR7OfbrEKGAk1fQZlo5foO0AZY
	vGuJSyxFoqyYQLimOzpt0BcGKwcmBf7OboUfGQ1j9AmUJOptl5dQl0TB5L5M=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1404:b0:45e:f8af:e2f with SMTP id
 5614622812f47-4644618c12dmr5948855b6e.15.1771871554530; Mon, 23 Feb 2026
 10:32:34 -0800 (PST)
Date: Mon, 23 Feb 2026 10:32:34 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <699c9d42.a00a0220.121a60.00ee.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in __put_task_struct (6)
From: syzbot <syzbot+c978a74d4872e06c4928@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, bsegall@google.com, 
	david@kernel.org, dietmar.eggemann@arm.com, juri.lelli@redhat.com, 
	kees@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-usb@vger.kernel.org, lorenzo.stoakes@oracle.com, mgorman@suse.de, 
	mhocko@suse.com, mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org, 
	rppt@kernel.org, surenb@google.com, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz, vincent.guittot@linaro.org, vschneid@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7754C140007
X-Stat-Signature: gtsdxm35tmgay1bxqgfqbxfefddnncyu
X-Rspam-User: 
X-HE-Tag: 1771871555-209235
X-HE-Meta: U2FsdGVkX19YRyAusFsOlZI35JbNA9WrAeHVqedz8eQGPx5u7bzjiGkTcdZI5qivqhJilg8bx0gVrGFmA9+8BqYMseMx39/hJsk78+14XiS/7GDf3+zDQypckzPyEi0tgHFYnSkicLon2Lr6ozHY/8UbsR5LGatyBTtWTF8tmHBtBUD360XGSLKFCkmnBKVmj7km+v2u9NbFyebfucLZ/6HsL7fC/0TcyvsUZsh/N+9cSQiPgmMORvKZTdM98J906EA/7hqbGy0ERfkRs2CfoRt6x+s2GSeusv/rI5Mmx2T+/yBIHJmxjezWR/grqNIhqbUKZB2kehwi0+daV/wgHK9V5Fc449dmNxD5LPvsi6HBQosGUnTIbWVQD7cMRsw5GNYAK7c32HgSWsRpsVJp7Zw/D1G88v9Cnkmo7mlXO7qvla9Ngi+XK6uUVsC0iBX1CdDkyB51vuyvy0O0mF0VLh95u5TFUzIIsfzwmOHPmC4nf6YmjxYqU7unlUuZtqQc5xjMUD2U3QAXFIzqngsB1/8rWymwHrPc3Mz0dOQiMzP0mtOYYiA8EBg2zK/lv9zhiNEK9l6pzsB3RRHCJ1xtvSM/8MwlXenwNJohYLg2nwxbHSha7KZzFzwJP/3FCaB2lsTVry79RjyHgTPhu1NfyYgZi8CXyBxRifj2oUEcsgr6J22+OZEfv0TFyZ/+aWNBXLfK75haya3klJPYnxwd64GdF9TQUxqkSBVkQ3jhYt9n479AqT1m1XrMQxCK5ijs64fPHrYNMwJCdpPWs9yHpXmXrRpBMkApY9BmakAiZnI2WIYRGMiF7bhrBXMrsjwFDs19flTXkqUiE6Q//nraRgk0bViGSvP2m7OnOZUrC5NqPHPUvyntr/9b8tEy9ap7teQVEwnnrrR0hgMKcF2k2JPASWSYdWf+UDmEn/vTH4Lw3zNbaF1+pQoHuKK+PVARudeY6BPvOQ6m14k7pQV
 OHgFAVWM
 /31S5TTAwcS3bakaTmOtjFmXjy2r8W08FL/ctrXTJxDQ3uMNlMHx/Bh6oya1D+sYq1GHCV2iJ0J+82sJMUCrK0XtvRUIl6UVl3qLwlRK+pEyrPxN7mfIPC3qWRwKEw2IM43dS/oZkfB0Kv7+y8YN1uyhtxCgdbgdIJnEz0Uu5bvv83nM5MnolHLpsJzyYxmAuHgnYiI3R3PjFvlyOYzF2fSfoVd7RhngBH5uH7tUgdUs0ddGujWoGvkOP8ZSYu/E4dg8WNLsWBx7ixFQmc9+qWJg7KTjwazpbjZekStF1weWhjhDAZBJNBbFzXiDXQtxrwfvrqTw3mGwfF9BXYw7xPbeg6dUuBeTwki7+aQA5fZolA8+rHA6lTYY0up6LPwRQbqphF4K0+Ag2r/L40wkl5CK+i4YPCE6c39WUJpOAgIRSWJmgvzAXKBf0SHGglNzGKGR4yOVrFz1LRNuFjsxj1+ybfPGs4j9L5nJlazEblnXCVo9AvY3RpTc2BI7yZPKGAzPupWn27pryFQiPxFtsiXaKVcV71FASg6QwH+Jt67l+sTqq0hT98t8BBZUMorTkgjiLdTaNPw8yFO6taQ93TG7SkP8nEY6GzidFALNDNnyamamRcMusorXUia9d/1akqSGQHQEVAbk8bOXTrdQEaO06nvOkxYqyB7z+94g8U5EKQ0J7yPfbbdu5adzJ6FTuU8SLNxUnWDCJ/JRGCduMYGisx9h5LS4NUw1mu45g0jBzRLu1o3fyB6+oSI8KipwEiEy49JIS3OxUSR4z+H/86HDDdkzcfghWDjmXPqUUDjU8BMljMFTD0fuMuzFSQHUjCso7rMsmulKiT97ixK/GzSxEZpgXi81gtScxtVPNBu9N5F7waCEmw6j59DIjI8Me1fzsUKgbU7sfJb6hts9+zaL0dbSXCFbuMRUVLIfVUVihlYjAVj6noQamrCUjBIWSHgDey1sAJGbD/hiMBOGYs2TQCMXj
 fmvz/Sfg
 UD8gTRYfZz+2yQ8HxOqfmqZN4Z3INxOGlZGiZtBTbVNlV6ldAP6RoIwk3k6lamPI3K8v+Xhi1Xrnh4y3zIqEtjHvBIm2KANyR/OJwg1gMswesuVTKajqMhYuSkfaQGRflDBd/hvUgozgXfiEfzaDAUhDoHy3NgqPhmpnr1o7obySUziGybu8J+nI4BiGBXZh/pfhOia9TSItF5luUawCzv6lKndIIylNafuFkwuYhqgCxjY331xK8/SCNIkzTnj8yn64LFdltCFn9KiRx23A6h5/oe+FcA+hSZOFWL11yiDNWY5087qHZEH9lUZy+culMzqg2PK/HG55hAWtC7be5m2wXFSZTOXELCZGmxJq3dGi/Tt5wFoBkIFVVTU4m0A3+fBcmM8buDkYDDUW3zvwS9h1Z1qqM0HFyzj74PwR+tv0vu8GfapG+wY+9NboskoddYjtI6dBa8vKjAN3zq4dQfaci6r0sotQWdk1TqhNUi9goRQJUMcy9Ug0wA7MFwAF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    2b7a25df823d Merge tag 'mm-nonmm-stable-2026-02-18-19-56' ..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=14573b3a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1ff39736314a9939
dashboard link: https://syzkaller.appspot.com/bug?extid=c978a74d4872e06c4928
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/10a06102f92f/disk-2b7a25df.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cb322de10b94/vmlinux-2b7a25df.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7a3e5e026b94/bzImage-2b7a25df.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c978a74d4872e06c4928@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_read(&tsk->usage)
WARNING: kernel/fork.c:779 at __put_task_struct+0x33c/0x400 kernel/fork.c:779, CPU#1: kworker/1:6/5227
Modules linked in:
CPU: 1 UID: 0 PID: 5227 Comm: kworker/1:6 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
Workqueue: usb_hub_wq hub_event
RIP: 0010:__put_task_struct+0x33c/0x400 kernel/fork.c:779
Code: 4c 89 e6 e8 b6 7e 98 00 e9 f2 fe ff ff e8 fc 7a 3d 00 be 03 00 00 00 4c 89 e7 e8 1f a0 57 01 e9 db fe ff ff e8 e5 7a 3d 00 90 <0f> 0b 90 e8 dc 7a 3d 00 65 48 3b 1d 4c 94 80 0b 0f 85 64 fd ff ff
RSP: 0018:ffffc900001a8e00 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88811283d700 RCX: ffffffff8174391b
RDX: ffff88811956ba00 RSI: ffffffff81743bbb RDI: ffff88811956ba00
RBP: 00000000c0000000 R08: 0000000000000005 R09: 0000000000000000
R10: 00000000c0000000 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff88811956ba00 R14: ffffffff81984efd R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8882687d3000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe6af2e9d40 CR3: 00000001195d8000 CR4: 00000000003506f0
Call Trace:
 <IRQ>
 rcu_do_batch kernel/rcu/tree.c:2617 [inline]
 rcu_core+0x5a2/0x10d0 kernel/rcu/tree.c:2869
 handle_softirqs+0x1de/0x9d0 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0xed/0x150 kernel/softirq.c:723
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1056 [inline]
 sysvec_apic_timer_interrupt+0x8f/0xb0 arch/x86/kernel/apic/apic.c:1056
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:console_flush_one_record+0xac3/0xe50 kernel/printk/printk.c:3270
Code: 00 e8 51 5a 28 00 9c 5d 81 e5 00 02 00 00 31 ff 48 89 ee e8 5f 62 20 00 48 85 ed 0f 85 d7 01 00 00 e8 71 67 20 00 fb 4c 89 e8 <48> c1 e8 03 42 80 3c 38 00 0f 85 64 03 00 00 48 8b 0c 24 48 8b 6b
RSP: 0018:ffffc9000362ea68 EFLAGS: 00000283
RAX: ffffffff89c75f58 RBX: ffffffff89c75f00 RCX: ffffc90012887000
RDX: 0000000000100000 RSI: ffffffff81914f2f RDI: ffff88811956ba00
RBP: 0000000000000000 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000012857
R13: ffffffff89c75f58 R14: ffffc9000362eae8 R15: dffffc0000000000
 console_flush_all kernel/printk/printk.c:3343 [inline]
 __console_flush_and_unlock kernel/printk/printk.c:3373 [inline]
 console_unlock+0x103/0x260 kernel/printk/printk.c:3413
 vprintk_emit+0x407/0x6b0 kernel/printk/printk.c:2479
 __warn_printf lib/bug.c:190 [inline]
 __report_bug.cold+0x7b/0x137 lib/bug.c:244
 report_bug_entry+0xe1/0x290 lib/bug.c:269
 handle_bug+0x1c9/0x2a0 arch/x86/kernel/traps.c:430
 exc_invalid_op+0x17/0x50 arch/x86/kernel/traps.c:489
 asm_exc_invalid_op+0x1a/0x20 arch/x86/include/asm/idtentry.h:616
RIP: 0010:refcount_warn_saturate+0x111/0x130 lib/refcount.c:25
Code: cc e8 e3 d9 e5 fe 48 8d 3d 4c 70 28 08 67 48 0f b9 3a e8 d2 d9 e5 fe 5b 5d e9 cb 6d 9f 04 e8 c6 d9 e5 fe 48 8d 3d 3f 70 28 08 <67> 48 0f b9 3a e8 b5 d9 e5 fe 5b 5d c3 cc cc cc cc 48 89 df e8 46
RSP: 0018:ffffc9000362ef30 EFLAGS: 00010283
RAX: 00000000000428c1 RBX: ffff88811283d728 RCX: ffffc90012887000
RDX: 0000000000100000 RSI: ffffffff82cbdcda RDI: ffffffff8af44d20
RBP: 0000000000000002 R08: 0000000000000005 R09: 0000000000000004
R10: 0000000000000002 R11: ffff8881f5739708 R12: ffff88810cf18000
R13: ffff88811283d728 R14: 0000000000000001 R15: 0000000000000001
 __refcount_add include/linux/refcount.h:289 [inline]
 __refcount_inc include/linux/refcount.h:366 [inline]
 refcount_inc include/linux/refcount.h:383 [inline]
 get_task_struct include/linux/sched/task.h:116 [inline]
 kthread_stop+0x602/0x680 kernel/kthread.c:786
 rsi_kill_thread drivers/net/wireless/rsi/rsi_common.h:78 [inline]
 rsi_91x_deinit+0x102/0x1f0 drivers/net/wireless/rsi/rsi_91x_main.c:405
 rsi_probe+0xd27/0x1aa0 drivers/net/wireless/rsi/rsi_91x_usb.c:861
 usb_probe_interface+0x303/0x8f0 drivers/usb/core/driver.c:396
 call_driver_probe drivers/base/dd.c:583 [inline]
 really_probe+0x241/0xa60 drivers/base/dd.c:661
 __driver_probe_device+0x1de/0x400 drivers/base/dd.c:803
 driver_probe_device+0x4c/0x1b0 drivers/base/dd.c:833
 __device_attach_driver+0x1ff/0x3e0 drivers/base/dd.c:961
 bus_for_each_drv+0x159/0x1e0 drivers/base/bus.c:500
 __device_attach+0x1e4/0x4d0 drivers/base/dd.c:1033
 device_initial_probe+0xaf/0xd0 drivers/base/dd.c:1088
 bus_probe_device+0x64/0x160 drivers/base/bus.c:574
 device_add+0x11d9/0x1950 drivers/base/core.c:3689
 usb_set_configuration+0xd97/0x1c60 drivers/usb/core/message.c:2210
 usb_generic_driver_probe+0xa1/0xe0 drivers/usb/core/generic.c:250
 usb_probe_device+0xef/0x400 drivers/usb/core/driver.c:291
 call_driver_probe drivers/base/dd.c:583 [inline]
 really_probe+0x241/0xa60 drivers/base/dd.c:661
 __driver_probe_device+0x1de/0x400 drivers/base/dd.c:803
 driver_probe_device+0x4c/0x1b0 drivers/base/dd.c:833
 __device_attach_driver+0x1ff/0x3e0 drivers/base/dd.c:961
 bus_for_each_drv+0x159/0x1e0 drivers/base/bus.c:500
 __device_attach+0x1e4/0x4d0 drivers/base/dd.c:1033
 device_initial_probe+0xaf/0xd0 drivers/base/dd.c:1088
 bus_probe_device+0x64/0x160 drivers/base/bus.c:574
 device_add+0x11d9/0x1950 drivers/base/core.c:3689
 usb_new_device.cold+0x685/0x115c drivers/usb/core/hub.c:2695
 hub_port_connect drivers/usb/core/hub.c:5567 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5707 [inline]
 port_event drivers/usb/core/hub.c:5871 [inline]
 hub_event+0x314d/0x4af0 drivers/usb/core/hub.c:5953
 process_one_work+0x9d7/0x1920 kernel/workqueue.c:3275
 process_scheduled_works kernel/workqueue.c:3358 [inline]
 worker_thread+0x5da/0xe40 kernel/workqueue.c:3439
 kthread+0x370/0x450 kernel/kthread.c:467
 ret_from_fork+0x6c3/0xcb0 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
----------------
Code disassembly (best guess):
   0:	00 e8                	add    %ch,%al
   2:	51                   	push   %rcx
   3:	5a                   	pop    %rdx
   4:	28 00                	sub    %al,(%rax)
   6:	9c                   	pushf
   7:	5d                   	pop    %rbp
   8:	81 e5 00 02 00 00    	and    $0x200,%ebp
   e:	31 ff                	xor    %edi,%edi
  10:	48 89 ee             	mov    %rbp,%rsi
  13:	e8 5f 62 20 00       	call   0x206277
  18:	48 85 ed             	test   %rbp,%rbp
  1b:	0f 85 d7 01 00 00    	jne    0x1f8
  21:	e8 71 67 20 00       	call   0x206797
  26:	fb                   	sti
  27:	4c 89 e8             	mov    %r13,%rax
* 2a:	48 c1 e8 03          	shr    $0x3,%rax <-- trapping instruction
  2e:	42 80 3c 38 00       	cmpb   $0x0,(%rax,%r15,1)
  33:	0f 85 64 03 00 00    	jne    0x39d
  39:	48 8b 0c 24          	mov    (%rsp),%rcx
  3d:	48                   	rex.W
  3e:	8b                   	.byte 0x8b
  3f:	6b                   	.byte 0x6b


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

