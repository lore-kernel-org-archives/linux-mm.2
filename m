Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92A2DCAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 06:15:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1D408E0003; Mon, 29 Sep 2025 02:15:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F4838E0002; Mon, 29 Sep 2025 02:15:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 930BD8E0003; Mon, 29 Sep 2025 02:15:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7FDA48E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 02:15:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F19DA13A336
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 06:15:33 +0000 (UTC)
X-FDA: 83941276146.11.B6FE490
Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3CA4F4000E
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 06:15:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of 3AyTaaAkbAAIu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.206 as permitted sender) smtp.mailfrom=3AyTaaAkbAAIu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759126532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=ynvbnWA1ecixqyan+LgmS5er8JTbSbCELgH2Iyhty4U=;
	b=mxLK1nxrbFYc/moVBgCaN+akIHpWpJgTUZRVXzguAaGuQK+sNzs3kfm/K/d+DplhJuS7Q1
	/5tWJ02p46ptMHikOVVPT1Vxc1xIcRTU5efFuvuflFWbI42LPgU3r790bSM6sZ9T4/or8n
	/XhGSGVg9bB4QbjtsB9Weu5xsP+dRRU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of 3AyTaaAkbAAIu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.206 as permitted sender) smtp.mailfrom=3AyTaaAkbAAIu01mcnngtcrrkf.iqqingwugteqpvgpv.eqo@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759126532; a=rsa-sha256;
	cv=none;
	b=BAM/A/g9BQ6eXT/1qyveBvvG9iUIk0gChD+uFFtQ3u/siDIvWzx8+kj+XZxvyijEy/97qA
	ZsEzL0hwGYWbewXzm6hfyV7s9T7zypZK9+GiwT0wIeLSNy70uAMkDue1tLUJZxye/XX1ph
	aKSnVg7/iVziC6EoCE+C9tbQZl1BGUo=
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-42594b7f324so79600205ab.1
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 23:15:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759126531; x=1759731331;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ynvbnWA1ecixqyan+LgmS5er8JTbSbCELgH2Iyhty4U=;
        b=CaRPkTTAd6/QQhIvk5kxXfbnkzZfpMmnWLEGOYFN8MYQ6prTdld9LuUbx8DH1/B8CI
         TjRcimjvXMtFy554rhmrsrYQpYsOyf9yB7HZ16EZSRoaOBFtYRlbP8zztwuYRHutLvFz
         /QDs2LyVXK2c0LvkMrAYG1FgHRVZNc5HWjQrn2PWCJ4lBngNNOQMOsn+BrP6t/dV9/Pq
         B8EMCL8eDcVJA9feMCRItr0vMIQLoZQ7dbW2aFyjY32i3g3ol2sQsEsn4QWjov38VnVt
         RGdvWL+dRqfQsgTx7xAlaDorFUlJU1An7tqkSSCmAvHPuD3le4hFgdGVr4UVRIjr/T4v
         8v/w==
X-Forwarded-Encrypted: i=1; AJvYcCW4B/g40R3LBRjw4LtQopXqbTThcYQ0JmcoqB/CrNPiBnxM/iZhH3YnI8yDFSiXH5AO5PK7CE7ulg==@kvack.org
X-Gm-Message-State: AOJu0YysPy1pHyTn7xFObTRldUlKgCITrGlsp6NiAkMrORfUUZnoaRJM
	Kxht9wNSlecmFFBUxmtqM7dxVkxw/NjXI/ULFI6ALYoWcKyC+GpP3xhiB0J+QEoHJbGgMxqbe1s
	2OsQ+gbOc4qe/1+7o3DHjfafR2gPE2zMyuUY3pOh/09S2WbRHtIq9QOjsCqo=
X-Google-Smtp-Source: AGHT+IELWwS0rgE9wNS6ZYg47pA+bZQLopq4RjKUbbwL/D4BniubNK9se99xRR6L4DLDgdY3JKoOc3xWMYyuI6qVNKBnMO2RhLKU
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3808:b0:425:8bfc:b7da with SMTP id
 e9e14a558f8ab-42873f48613mr113571065ab.7.1759126531257; Sun, 28 Sep 2025
 23:15:31 -0700 (PDT)
Date: Sun, 28 Sep 2025 23:15:31 -0700
In-Reply-To: <0000000000000189dc0621b5e193@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68da2403.a00a0220.102ee.0036.GAE@google.com>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in x64_sys_call
From: syzbot <syzbot+65203730e781d98f23a0@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org, bp@alien8.de, 
	bpf@vger.kernel.org, daniel@iogearbox.net, dave.hansen@linux.intel.com, 
	dvyukov@google.com, eddyz87@gmail.com, elver@google.com, glider@google.com, 
	haoluo@google.com, hpa@zytor.com, john.fastabend@gmail.com, jolsa@kernel.org, 
	kasan-dev@googlegroups.com, kpsingh@kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-usb@vger.kernel.org, luto@kernel.org, 
	martin.lau@linux.dev, mingo@redhat.com, netdev@vger.kernel.org, 
	sdf@fomichev.me, song@kernel.org, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, x86@kernel.org, yonghong.song@linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3CA4F4000E
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: qkr1pxg3qakizu5f9w3fjq45bafz64d9
X-HE-Tag: 1759126532-345059
X-HE-Meta: U2FsdGVkX1/VJ3bV6U/oSRGPiUL7lyK3TCMn8KdqTNrW3gh40/WCbytmUWPqTkc1FN9liE9F3tN/rXhRxqeHvetlEFboqEYyYA94fGRy0Kj90ettRQbUCQGEZpFG+IOFcTfDUXz+mv4E269PmWPPR8HPOd0Tj687b93R2wEuTe4igj0bl3osLeKHyNacKPq3l7KIu3hry6ANVIkFGBSqWnmGnc1psvyyu/aPuo56DF85h5jxyb0+xRcjTG8J+K4tihQfxpMEEtgpNMOLCy48AVUDQ5lugeew7GNWWnK6z38l4P9vEQcjFFy8Cu7adyg7CYT2aNbtZkO1cKqWvQHSue5zkO9M1Y1A9RtI5SGB5XGYGy0/oiRrEoZa/j6lCipdjtdN8I8xnHD/Ac3hZWQflUw3NN6ZbaE3RbVnr78o84p/Bd4gR9A9u445qdw/NxyTIboqK4d/cRmSRHxbkMoGQfYMQwrgAteMCTclo9Gxm06fMte2k3u2cJsGLpPhG7NywfofbuyHKVXmb2iz0SDDQBmqSiJygokfaTF15dW1U4grG37m7Xfefnw5e2BW7h3ks7wgtD8udh8JU2OWCr5KXe0AMncqxG+9q2kKWuCjqW/w3DfifQu+7XVZNnf+2MUFkfS/IZqTsnu7in3xW0KVBDXJg/xcE+OjjpwNLlvMg8QnK4lXDx5VHHLxOzaZ+onAVHH6dGnt7Kw4QgozPxGRJ86GMxyl55Lkufrld1ZamWNXll1UpUl6nf2Qf2HbeImrlNgiFzhTC5RX5UaV+OZ5UhSnw2H9XM0lEVJE8tAZ62bmURnWjw4jTE5YM6uycpBkHpHc7qcFrQYSRoxJh3shmh3i/fIkvCfvOR3mpg394IZ/zNBff818S4Wr0/+nPqvIn9M4r9+h2KPIjxG8A9F2MN54isZse/DWonUb1yXzBDYzPO5rNEqzqqZdl7S2UkM35yhzjR89SmSb6jNWR1e
 ZMqFWy0g
 KKXLIAt0svi1pcYCQa1/79o4PkEvqRsY/0C0YQMqQaoLBZz981dxKPiaNpWOPH+ptOHh6eJOyiw4rAAeuYWDxrc68LMpocfIKkTiV0TwGzMM8jqko6w2UJLSS79MrFksvOqa00BOAtHo4cwNTN/+6mwme49pUmPSeLtlFIFnoMWcjZNUnEzE4X6DgpHiL6Na3KUYIXiS9jWJmaF9p9JKAoiW8s8fAc5oBfcXc1W9w3WPLFEIKzhk93/niqdolPjXbPQX2zJfvrUmf02tgWQZ+lDCvdZw78H4owW+MyLU77iIj0OQB6wx+2PiD5A4N3UelCM3YHpQ3uH+JcwDi6whY2XpmFvYAz3CmIC1iXey0zlJQsteuzXuto5wlYVhl05TTL8aPNA5ACFy5nWnsT5aq6tjhIlqWgKPC9+4MIsxFOaoRnm6MpAIq9f1O94JYqHExYVGqRro8DxELnfA7DSbAMOupyTxXNDowHnNrmGWnpCQ/wr1I54brv+4KuwdZqYmBmcYrL4WdC6fxQKk9CW2G4Isq8/uzkl9tiHAYWFOseYSu21P3lvUCk/DHuqa5h32eGcN0lnyiyilBYVXe3e3Z2DPtEQ+9ZumyDTU5BqGKX16e48PQQ23jw/pMmkGljME8ZyAgmVOTacAriH0Zv0EHjA/SecuOrG6r7kj6vBaE8utnPnv2rVYRceAD55+Vpl6HHfgRrDg0WRaI/kUW6SegN0JHIxeDCV/xpRIYB2AveX+P/3eTxaIpwgHXVs0lXHqV/3ial8Yw3ZYsb2fJj8TxPC2vgvWMiyWsSeQpBRASsUww9hwvxV255ynRPZyuk3BO9COjtPMmwj4j5TDJNI0vZyQetaL/jfshMGzEfEjtwx9uQDxRxUNbAPKamQhn5jDz9F+IX1JpLWcIPdIqQ0poEbEjw9AoLNkENuKTMdsTXscOxE3dGKMprRNtLO2fQja4+H5BjI3LkJyPfIGtxOcob2vSIGDZ
 Y9Tm8iaC
 sl6/QIN+LzkMk8ka7rn23u+vLsZUqOglf3Cxc9Pe6Sv7pPUK/Xp6vUxNikRXTYmYhvEZnXYH+nisDy6Z7WQDuqZKnI7fRpEqCnvgoneaCVcE5WjbnWbzH8w8PAWFyghfQH9BFqcdMccVgyogI2pBkhzJrb21ZeLiiS9ZOKQOLPYESGFAIkjIX1VBdJ4yIAxauURH8NUA1ELGxFRslV+yDk4DmEF/52Zc+Ql6bY0Q/ypDU8mEbOHHo6TLNmDeijn5t1hc2vDzQuHnQ3hv1lBK5h0jcJwJCrpZjWJctiSd2MXM2rvWJxRnoShN6jLtMYTBrQwF9GyQ6Zh4biRTql7GFVe2EmwWqylo3UYlzohNXnFIDyXaoBCbLDS1GYb9P+xadHdJ99+lDrS3kUBtm4zSABQxTDA5PeoB/APWi00dfWlDULky11jDXEbKaFXwH2yX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    e835faaed2f8 net/mlx5: Expose uar access and odp page faul..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=136e2ae2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=15254880b29b9ff
dashboard link: https://syzkaller.appspot.com/bug?extid=65203730e781d98f23a0
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15e58334580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1005eae2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6b3cd235e609/disk-e835faae.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/180c3f29b5c5/vmlinux-e835faae.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6b8fa2c53bdd/bzImage-e835faae.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+65203730e781d98f23a0@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	1-...!: (1 GPs behind) idle=3cd4/1/0x4000000000000000 softirq=15457/15459 fqs=3
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P43/2:b..l
rcu: 	(detected by 0, t=10503 jiffies, g=9717, q=782 ncpus=2)
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 5901 Comm: udevd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
RIP: 0010:hrtimer_set_expires include/linux/hrtimer.h:100 [inline]
RIP: 0010:advance_sched+0x9cc/0xc90 net/sched/sch_taprio.c:988
Code: 24 18 48 89 f8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df 80 3c 08 00 74 05 e8 80 51 87 f8 4d 89 74 24 18 49 83 c4 20 4c 89 e0 <48> c1 e8 03 48 b9 00 00 00 00 00 fc ff df 80 3c 08 00 74 08 4c 89
RSP: 0018:ffffc90000a08c70 EFLAGS: 00000086
RAX: ffff888024623360 RBX: ffff8880246232c0 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff888024623358
RBP: ffff88807b34d550 R08: ffff8880246232eb R09: 1ffff110048c465d
R10: dffffc0000000000 R11: ffffed10048c465e R12: ffff888024623360
R13: ffff888024623000 R14: 1869abf3b67aa73f R15: ffff88807b34f400
FS:  0000000000000000(0000) GS:ffff888125d39000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055f6efacf088 CR3: 000000000df36000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 __run_hrtimer kernel/time/hrtimer.c:1761 [inline]
 __hrtimer_run_queues+0x529/0xc60 kernel/time/hrtimer.c:1825
 hrtimer_interrupt+0x45b/0xaa0 kernel/time/hrtimer.c:1887
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1039 [inline]
 __sysvec_apic_timer_interrupt+0x108/0x410 arch/x86/kernel/apic/apic.c:1056
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1050 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1050
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:deref_stack_reg+0xa/0x230 arch/x86/kernel/unwind_orc.c:402
Code: 4c 24 18 e9 f2 fe ff ff 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 55 41 57 41 56 41 55 41 54 53 <48> 83 ec 20 48 89 54 24 18 49 89 f0 49 89 ff 48 be 00 00 00 00 00
RSP: 0018:ffffc900042cf4e0 EFLAGS: 00000283
RAX: fffffffffffffff0 RBX: ffffffff9036fb70 RCX: 0000000000000000
RDX: ffffc900042cf628 RSI: ffffc900042cf720 RDI: ffffc900042cf5e8
RBP: dffffc0000000000 R08: ffffc900042cf647 R09: 0000000000000000
R10: ffffc900042cf638 R11: fffff52000859ec9 R12: ffffc900042cf720
R13: ffffc900042cf638 R14: ffffc900042cf5e8 R15: 1ffffffff206df6e
 unwind_next_frame+0x17c4/0x2390 arch/x86/kernel/unwind_orc.c:-1
 arch_stack_walk+0x11c/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x9c/0xe0 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:388 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:405
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __kmalloc_cache_noprof+0x230/0x3d0 mm/slub.c:4407
 kmalloc_noprof include/linux/slab.h:905 [inline]
 slab_free_hook mm/slub.c:2374 [inline]
 slab_free mm/slub.c:4695 [inline]
 kmem_cache_free+0x166/0x400 mm/slub.c:4797
 exit_mmap+0x53f/0xb50 mm/mmap.c:1305
 __mmput+0x118/0x430 kernel/fork.c:1129
 exit_mm+0x1da/0x2c0 kernel/exit.c:582
 do_exit+0x648/0x2300 kernel/exit.c:949
 do_group_exit+0x21c/0x2d0 kernel/exit.c:1102
 __do_sys_exit_group kernel/exit.c:1113 [inline]
 __se_sys_exit_group kernel/exit.c:1111 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1111
 x64_sys_call+0x21f7/0x2200 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd7130f16c5
Code: Unable to access opcode bytes at 0x7fd7130f169b.
RSP: 002b:00007ffca03ef578 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 000055f6efb75130 RCX: 00007fd7130f16c5
RDX: 00000000000000e7 RSI: fffffffffffffe68 RDI: 0000000000000000
RBP: 000055f6efac3910 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffca03ef5c0 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.498 msecs
task:kworker/1:1     state:R  running task     stack:22536 pid:43    tgid:43    ppid:2      task_flags:0x4208060 flags:0x00004000
Workqueue: mld mld_ifc_work
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x1798/0x4cc0 kernel/sched/core.c:6961
 preempt_schedule_common+0x83/0xd0 kernel/sched/core.c:7145
 preempt_schedule+0xae/0xc0 kernel/sched/core.c:7169
 preempt_schedule_thunk+0x16/0x30 arch/x86/entry/thunk.S:12
 __local_bh_enable_ip+0x13e/0x1c0 kernel/softirq.c:414
 local_bh_enable include/linux/bottom_half.h:33 [inline]
 rcu_read_unlock_bh include/linux/rcupdate.h:910 [inline]
 __dev_queue_xmit+0x1d79/0x3b50 net/core/dev.c:4790
 neigh_output include/net/neighbour.h:547 [inline]
 ip6_finish_output2+0xfb3/0x1480 net/ipv6/ip6_output.c:136
 NF_HOOK_COND include/linux/netfilter.h:307 [inline]
 ip6_output+0x340/0x550 net/ipv6/ip6_output.c:247
 NF_HOOK+0x9e/0x380 include/linux/netfilter.h:318
 mld_sendpack+0x8d4/0xe60 net/ipv6/mcast.c:1855
 mld_send_cr net/ipv6/mcast.c:2154 [inline]
 mld_ifc_work+0x83e/0xd60 net/ipv6/mcast.c:2693
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3319
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
 kthread+0x70e/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x439/0x7d0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
rcu: rcu_preempt kthread starved for 10490 jiffies! g9717 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:27160 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x1798/0x4cc0 kernel/sched/core.c:6961
 __schedule_loop kernel/sched/core.c:7043 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:7058
 schedule_timeout+0x12b/0x270 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x301/0x1540 kernel/rcu/tree.c:2083
 rcu_gp_kthread+0x99/0x390 kernel/rcu/tree.c:2285
 kthread+0x70e/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x439/0x7d0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
CPU: 0 UID: 0 PID: 1011 Comm: kworker/u8:5 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
Workqueue: events_unbound toggle_allocation_gate
RIP: 0010:csd_lock_wait kernel/smp.c:342 [inline]
RIP: 0010:smp_call_function_many_cond+0xd33/0x12d0 kernel/smp.c:877
Code: 45 8b 2c 24 44 89 ee 83 e6 01 31 ff e8 86 63 0b 00 41 83 e5 01 49 bd 00 00 00 00 00 fc ff df 75 07 e8 31 5f 0b 00 eb 38 f3 90 <42> 0f b6 04 2b 84 c0 75 11 41 f7 04 24 01 00 00 00 74 1e e8 15 5f
RSP: 0018:ffffc900036a7660 EFLAGS: 00000293
RAX: ffffffff81b44fab RBX: 1ffff110170e7f69 RCX: ffff888025bada00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc900036a77e0 R08: ffffffff8fa30637 R09: 1ffffffff1f460c6
R10: dffffc0000000000 R11: fffffbfff1f460c7 R12: ffff8880b873fb48
R13: dffffc0000000000 R14: ffff8880b863b1c0 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff888125c39000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000300 CR3: 000000000df36000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 on_each_cpu_cond_mask+0x3f/0x80 kernel/smp.c:1044
 on_each_cpu include/linux/smp.h:71 [inline]
 smp_text_poke_sync_each_cpu arch/x86/kernel/alternative.c:2653 [inline]
 smp_text_poke_batch_finish+0x5f9/0x1130 arch/x86/kernel/alternative.c:2863
 arch_jump_label_transform_apply+0x1c/0x30 arch/x86/kernel/jump_label.c:146
 static_key_enable_cpuslocked+0x128/0x250 kernel/jump_label.c:210
 static_key_enable+0x1a/0x20 kernel/jump_label.c:223
 toggle_allocation_gate+0xad/0x240 mm/kfence/core.c:850
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3319
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
 kthread+0x70e/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x439/0x7d0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

