Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F656D2502F
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 05:33:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 665006B0088; Mon, 12 Jan 2026 00:33:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6124A6B0089; Mon, 12 Jan 2026 00:33:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5118F6B008A; Mon, 12 Jan 2026 00:33:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3BF186B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 00:33:28 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD1F4C17A8
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 05:33:27 +0000 (UTC)
X-FDA: 84322194054.21.76985F4
Received: from mail-ot1-f80.google.com (mail-ot1-f80.google.com [209.85.210.80])
	by imf27.hostedemail.com (Postfix) with ESMTP id 09CA84000A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 05:33:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf27.hostedemail.com: domain of 3pIdkaQkbAJcJPQB1CC5I1GG94.7FF7C5LJ5I3FEK5EK.3FD@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.80 as permitted sender) smtp.mailfrom=3pIdkaQkbAJcJPQB1CC5I1GG94.7FF7C5LJ5I3FEK5EK.3FD@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768196006; a=rsa-sha256;
	cv=none;
	b=OS2YxtI8TrjB83FlrjT6FfPhu85g4bymAHMjj8BTIknmGS2n2euqwbhu0+KE4TNrkaV0SP
	hqdjTsojaS6k+SKybt1fzeDox4Phs8VURWf2dh48Vhd5RG6+bSL/lNTbHy0bXRstfHBU04
	ETfRe3Fns1/5QSX5osduLROMO8H8Z8k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf27.hostedemail.com: domain of 3pIdkaQkbAJcJPQB1CC5I1GG94.7FF7C5LJ5I3FEK5EK.3FD@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.80 as permitted sender) smtp.mailfrom=3pIdkaQkbAJcJPQB1CC5I1GG94.7FF7C5LJ5I3FEK5EK.3FD@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768196006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=c6lV8w4gthx3tGLc0toodGt6zBVWLiHV1t64kPFcYOk=;
	b=twMQYhmK0Slw2sRK9cqZW71Wk0/1U5c8gwLniEReuboIPWznmFUoY+d1ICsw23djD/FJWT
	dXRRqanURagvwPwOuIRdHvY7AotUucDitDZd4AM+XzxRh9JAQ+7B5DHCoyKH7FegZiohoO
	KfUjXCZRLzmoerQPZmfD/RTtSve1Brg=
Received: by mail-ot1-f80.google.com with SMTP id 46e09a7af769-7c75290862cso18676190a34.2
        for <linux-mm@kvack.org>; Sun, 11 Jan 2026 21:33:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768196005; x=1768800805;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c6lV8w4gthx3tGLc0toodGt6zBVWLiHV1t64kPFcYOk=;
        b=fwBBkrW0iNcst+yqRA/CWAbgyMNjM69s/LhF5RQ0OG05EF3zdbjgeQy1/mIZ5hC2gv
         LdcFRr+kVQ/wZru4rQMSbllNgmHmT4zucXuFijUOguhSUE6T6R40enX8ZAtdgy1IRw5r
         pLbcB717RBfUykAVL8KLu1OP4aRMUzKKo+PK52ac/Xk4gVTbRalnHNcwHvoLyPQmVD90
         MDbSCEogUiufXm7UdinCIK+scRiDfrV3/QihUW6M0+VeAnk5s2RjqGr/yqEhixZJDTfa
         tnAhRs3GFLwhMhm0UmQ9k3bM20ouuzKWycWJKJsK1KP62yc/0L6veaQjyn0Kl4ijydf4
         +ybg==
X-Forwarded-Encrypted: i=1; AJvYcCXP9xHRXRx2DyedOJlVa4/z0WLbhenseANNRVrDTsVHOvJSOHReq53/LBawi1ohE9JAQIEvcK5O+Q==@kvack.org
X-Gm-Message-State: AOJu0Yz4o/7/ohSqpzwaoxepZs2W8Wm2lRwHj+FhEJHOQkcAwFv3ZwTw
	MSvFv6v24+Zu6RgmoecOXkCD0Pst7L4CZecLnFKp/sdEmls4mieSRoGHaL/R8nsJINCHyDSg1mY
	IF8rvP5zFG4FAEord+QsCb0Lmi9KQ9AscrpEjgVny4aXJJP15AJ6Swg9MC4Y=
X-Google-Smtp-Source: AGHT+IFJy6QnJsk85bUVHTiEUlWzvz3pEnq3AqxA2XqMX4wCVqWmPntq3cMcFwEzQJJJSlbKiKQ7ve2Cw5M3LZWDCLhIjiaGCzto
MIME-Version: 1.0
X-Received: by 2002:a05:6820:828:b0:65f:7470:38bc with SMTP id
 006d021491bc7-65f74703d0cmr2448989eaf.54.1768196004939; Sun, 11 Jan 2026
 21:33:24 -0800 (PST)
Date: Sun, 11 Jan 2026 21:33:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <696487a4.050a0220.eaf7.0085.GAE@google.com>
Subject: [syzbot] [mm?] INFO: rcu detected stall in purge_vmap_node
From: syzbot <syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, hannes@cmpxchg.org, jackmanb@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@suse.cz, 
	ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: s73uuq8q1owcnhhtchpaor8h98k8xdb3
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 09CA84000A
X-HE-Tag: 1768196005-884539
X-HE-Meta: U2FsdGVkX18GIwdeiPcCtRQSD/tbde11ttxuIMr7jWbI0NG/Gov8Wcby/fexi0r4Pz3yf1R/KcCYx6cJ1wTX79ED3q5kxnvSXwS3AVUAKYbDbH4EXBy2VjDfJdDJhHj5lblLRGK1tdIG0zg80hntjUkpA5gNb8nGNvAYm1pD5wbRhiwXAvqF06iWSqPa6yr/juwATGkeASkmhvZJroNo4AYdFcjk//u7Vuwi/TVM4LxcxS704atgo5YjC2w4b6IwYjJlY+0Kn836np2iTmeoagHgpRmh6tIqr1y/XtiQALDYz9e4jF2U1gIaKF/MKk+if8YxFxcR5AClIdDUKJ/zH1sLj5LCZOmeok7PZF4HNzArCf+81sQume4UNg77Dat8Dlk0KcRxGL4oY+xO5mVbpuu0KoXCtf7WsJUK1w9ntmj22Dt2rr8pBGcRWpnHQBThx+Cdc52MG3wKnRm62h7F9nlv6Dlu1v5xPb/0pwRZFqrU/iMsQLKOZlsZ2n/ER9WpnORdwsb0sGlz4T6prSJKbtWntKwtYN3aqvf8/Xgf1GgvOQDs/wYmnPw/MHdHzhdTs5TfpZj4hBf2ZmnwZ1FPappK3uwShk2sI/PPkMkhUBt6shRzAqigx65CPtMPNslEhkcAamyXCmJ2Xdg7EgYvQf5NgNMIlOapYz0y62HbyWeu3MD+UVw995xNd9ERyPTLf/zwLTCSZ2pLaDS5Pbixo/O+wfmbTRAEX02kFfaQlTD6Lb8HSrKrPkkEo9H5glg2UZG1jQftwrElCR0U/cXlG2Jz97jBtFg52f9crDnvKYWL54dtMHsAzGSO4kff/Py7pGZ25l+d9u5Rb0c4XB5b5ZCkrorjlnndpfAcwfpJmbAvby5jEgipxMc0fpdny3k3X0JtYHRVdDeWlcG2r5Ti9zAIZ6nUCaFc8n+1fN2/yJFelcGdFz8ZCYNiIS+a4wVTfCEPVdHL96m99weFgp3
 C7DsvCAg
 YTilMIJl9OHN7ztvAiP/h3PbI7RJ4wyrslRQVSVhwadtcz22YcGKUh/aCYb7NXmhUnnMZ/e9uu5my9nfwFy47DneD7ocXM8AeYwo0dG3WYAWjXciZ90p2N5Afo5jtFp9xe1RlhCIG5gTSuKjSbCIoZzQJ+rxQyAN/JJcmWH2KZvUzpmwxxDn5BE+HqDV5fmSmxem2oZtgcDK3NbYteQnM0tHJuuQkm+ksZOkIcAse6MHi9NpMtlYZ5dkxOvHq3dbqlSho5RavSIPmRNMqjn+Xm8DY6MBbHXfbz8aVgYWIZ503gudO3Aip49bkYI+5iyZ/dYiIVYi4WDVphDeoontAjkCJ3PtbGhsKfqZkUC0jrBBpY2kwQLob5X6N/d5TWDMekIIqfxOBlUS4mQjiFiiPhn5XtG4ZTKOnxB71Gfmw0s71fW0SvkFL8xOWlVBYEhJTy63y/y5vrtgmU1M5s2h6N0Oed5xR9v1L8to73/QGhviGa9eG+lkZnZMl4nTy4P4diBj9PkBQpLwdDyEa/Ta1eDt6foIwPNf+rMBP11P0J2+pWUIqN+KOpSyPR6nGc3l+Z8bkKQDc5v/MeoUUJp86aRrAUNHPLZ3gXi8wccvn336ZYW5+LQl9y7uSeqERmpuQeokhKyUsiRjngL3R6rNPbA/69eg7UcbmYBm8poJoHudN/JxPMMob13osdo0CQl0Y+yB8ZJOAcDStxKxObngr61WWN0P20woluR3B5IJMd8Ilj5WqxNJlAgmgUt6VezRvjRxq3NHhFCvdIf3mOJ4Llc+oqUWB2b/p9Y7eV8HD3MBnNPVIIp2ddkXfSb8qtC5NQ9NE1spZVByVJYn8l6AnOwx0kwM/04/pmFYYroeNpzqCiHuBez0CoIC1gLTl1DjPBYCyxpeOeUAdvwe4l1ru3POHlUgep7Bf3iKQVdN8qZr6qMjFCfhefsy3Y2Km/RW7j+OzyLafehkCtk9R+AUkwEL6CwFm
 BSUzjmO3
 ULf0sX+1G60b4oZHzuML41Kzv+tDOq26x+H/g4/dvg609a1w3U/5Di0CRvb2asDEZPpTXNwMdc39BQZCfIoLPR7PqB2cg2tZpa0FCAjTj3pSn3q0v2KCMlFe3lVGP/bO0w8LEPYaNMxjQZAXAkx1xxCmhUxazM2ZRV1iWFqkmS7q+nCnOs7l56aNy+u0MA2mqZRxj6+AV8f2uxCpNIGXbSKmO61F5Bfz1gzfD0YfwNSXktPOutRJ0stJfQGUVta19hBRrtM+DZ8WTJ4WauadxKe/Yh7hTsuuJAligd8QxLLuyxAk5lFVlUx6swgt3mSa4s2W662lYRJu45+KqAJzIMqrbWBhzy1h0o+Js+/nEhTxyzWicqKFA3KIPoMMHufOLjdRh2iFwHXDc5v6Q7PDKBSkNIsMLZNCFyNSA0tQUa4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    f0b9d8eb98df Merge tag 'nfsd-6.19-3' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=135c11fc580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a11e0f726bfb6765
dashboard link: https://syzkaller.appspot.com/bug?extid=d8d4c31d40f868eaea30
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12e0c19a580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=134d1f92580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4dbba2a806a3/disk-f0b9d8eb.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2a52c0f94de7/vmlinux-f0b9d8eb.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5ddf9a24988b/bzImage-f0b9d8eb.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P6229/1:b..l
rcu: 	(detected by 1, t=10502 jiffies, g=10385, q=373 ncpus=2)
task:kworker/0:17    state:R  running task     stack:28840 pid:6229  tgid:6229  ppid:2      task_flags:0x4208060 flags:0x00080000
Workqueue: events purge_vmap_node
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5256 [inline]
 __schedule+0x1139/0x6150 kernel/sched/core.c:6863
 preempt_schedule_irq+0x51/0x90 kernel/sched/core.c:7190
 irqentry_exit+0x1d8/0x8c0 kernel/entry/common.c:216
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:lock_acquire+0x62/0x330 kernel/locking/lockdep.c:5872
Code: b4 18 12 83 f8 07 0f 87 a2 02 00 00 89 c0 48 0f a3 05 22 bd ee 0e 0f 82 74 02 00 00 8b 35 ba ed ee 0e 85 f6 0f 85 8d 00 00 00 <48> 8b 44 24 30 65 48 2b 05 39 b4 18 12 0f 85 ad 02 00 00 48 83 c4
RSP: 0018:ffffc900035e7540 EFLAGS: 00000206
RAX: 0000000000000046 RBX: ffffffff8e3c96a0 RCX: 0000000019a1310f
RDX: 0000000000000000 RSI: ffffffff8daa7f9d RDI: ffffffff8bf2b380
RBP: 0000000000000002 R08: 000000007c8d0f89 R09: 0000000097c8d0f8
R10: 0000000000000002 R11: ffff888031598b30 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 rcu_read_lock include/linux/rcupdate.h:867 [inline]
 class_rcu_constructor include/linux/rcupdate.h:1195 [inline]
 unwind_next_frame+0xd1/0x20b0 arch/x86/kernel/unwind_orc.c:495
 __unwind_start+0x45f/0x7f0 arch/x86/kernel/unwind_orc.c:773
 unwind_start arch/x86/include/asm/unwind.h:64 [inline]
 arch_stack_walk+0x73/0x100 arch/x86/kernel/stacktrace.c:24
 stack_trace_save+0x8e/0xc0 kernel/stacktrace.c:122
 save_stack+0x160/0x1f0 mm/page_owner.c:165
 __reset_page_owner+0x84/0x1a0 mm/page_owner.c:320
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1406 [inline]
 __free_frozen_pages+0x7df/0x1170 mm/page_alloc.c:2943
 kasan_depopulate_vmalloc_pte+0x5b/0x80 mm/kasan/shadow.c:484
 apply_to_pte_range mm/memory.c:3182 [inline]
 apply_to_pmd_range mm/memory.c:3226 [inline]
 apply_to_pud_range mm/memory.c:3262 [inline]
 apply_to_p4d_range mm/memory.c:3298 [inline]
 __apply_to_page_range+0xac1/0x13f0 mm/memory.c:3334
 __kasan_release_vmalloc+0xd1/0xe0 mm/kasan/shadow.c:602
 kasan_release_vmalloc include/linux/kasan.h:593 [inline]
 kasan_release_vmalloc_node mm/vmalloc.c:2282 [inline]
 purge_vmap_node+0x1ba/0xad0 mm/vmalloc.c:2299
 process_one_work+0x9ba/0x1b20 kernel/workqueue.c:3257
 process_scheduled_works kernel/workqueue.c:3340 [inline]
 worker_thread+0x6c8/0xf10 kernel/workqueue.c:3421
 kthread+0x3c5/0x780 kernel/kthread.c:463
 ret_from_fork+0x983/0xb10 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
rcu: rcu_preempt kthread starved for 10534 jiffies! g10385 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=1
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:28440 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5256 [inline]
 __schedule+0x1139/0x6150 kernel/sched/core.c:6863
 __schedule_loop kernel/sched/core.c:6945 [inline]
 schedule+0xe7/0x3a0 kernel/sched/core.c:6960
 schedule_timeout+0x123/0x290 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x1ea/0xaf0 kernel/rcu/tree.c:2083
 rcu_gp_kthread+0x26d/0x380 kernel/rcu/tree.c:2285
 kthread+0x3c5/0x780 kernel/kthread.c:463
 ret_from_fork+0x983/0xb10 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:pv_native_safe_halt+0xf/0x20 arch/x86/kernel/paravirt.c:82
Code: b6 5f 02 c3 cc cc cc cc 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 66 90 0f 00 2d 13 39 12 00 fb f4 <e9> cc 35 03 00 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90 90 90
RSP: 0000:ffffc90000197de8 EFLAGS: 000002c6
RAX: 00000000000f349b RBX: 0000000000000001 RCX: ffffffff8b7826d9
RDX: 0000000000000000 RSI: ffffffff8dace031 RDI: ffffffff8bf2b380
RBP: ffffed1003b58498 R08: 0000000000000001 R09: ffffed10170a673d
R10: ffff8880b85339eb R11: ffff88801dac2ff0 R12: 0000000000000001
R13: ffff88801dac24c0 R14: ffffffff9088b8d0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8881249f5000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055555f9257e0 CR3: 000000004b1c0000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 arch_safe_halt arch/x86/include/asm/paravirt.h:107 [inline]
 default_idle+0x13/0x20 arch/x86/kernel/process.c:767
 default_idle_call+0x6c/0xb0 kernel/sched/idle.c:122
 cpuidle_idle_call kernel/sched/idle.c:191 [inline]
 do_idle+0x38d/0x510 kernel/sched/idle.c:332
 cpu_startup_entry+0x4f/0x60 kernel/sched/idle.c:430
 start_secondary+0x21d/0x2d0 arch/x86/kernel/smpboot.c:312
 common_startup_64+0x13e/0x148
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

