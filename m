Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19188CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 04:28:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6D886B0008; Tue,  2 Sep 2025 00:28:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E456E6B000C; Tue,  2 Sep 2025 00:28:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5B556B000D; Tue,  2 Sep 2025 00:28:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD2836B0008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 00:28:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C0CC5C64F
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:28:32 +0000 (UTC)
X-FDA: 83843028864.05.3A90034
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	by imf17.hostedemail.com (Postfix) with ESMTP id 816294000D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:28:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf17.hostedemail.com: domain of 3bXK2aAkbAHgouvgWhhanWlleZ.ckkchaqoanYkjpajp.Yki@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.205 as permitted sender) smtp.mailfrom=3bXK2aAkbAHgouvgWhhanWlleZ.ckkchaqoanYkjpajp.Yki@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756787310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=J0b/c8OqJR/lh71Qiq/TDGznf5dadAves7tGSrZU+T0=;
	b=pi+i4c2ASU0fYw2LZQGPmepi/6TMM5+RSUwJfOGQQ3FcSFtTZVbyG74vt6OaPbhC96lh9Q
	ytqPTbjl8BQGfQtfSFVAoJd1R0eollnqnzLji2ibczTmhMJ7klQ+7EYG5cXcd9BiW0fshT
	Uh6g/WHS74+M8xiI+OvPuJuFednjue0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf17.hostedemail.com: domain of 3bXK2aAkbAHgouvgWhhanWlleZ.ckkchaqoanYkjpajp.Yki@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.205 as permitted sender) smtp.mailfrom=3bXK2aAkbAHgouvgWhhanWlleZ.ckkchaqoanYkjpajp.Yki@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756787310; a=rsa-sha256;
	cv=none;
	b=YGGLWnzkK1Hw/w9ObNBgOOioejVlZvrKRZrpLFmhtwraVyEN62jFYGoKzh09efrtpgvqEJ
	5kS6M1d5kFPUBZvCztGKkmUo+lOKKnZjt63BpQ/G+wKMdqgIsZFyOV0jk2ywQOeEJEX2ur
	as9pk+eQiD5dy4uUQKgMRlnh6sTg5lo=
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3f64e58e4easo31500745ab.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 21:28:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756787309; x=1757392109;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J0b/c8OqJR/lh71Qiq/TDGznf5dadAves7tGSrZU+T0=;
        b=CrCfp5a5A/VTPbVxifEWKvBjMlKGjpe/onGegsJz3qrjrgZTXX8IYlIWtKCBWuyqym
         TH9U96lxz4hX/jC1ipj9Hjo3iXUEBprkg4yRWv4vAziPds5KhBSptFBc6bVckF5plYqu
         Jl00LzQJDAxGW2azaYxuJ7qwBCFmXSANi5dwL/+24J5SbqkfOV/uRGBuuHYsG3B7Vtyf
         S/nWGv1tETA/ZQ3lIciw3UZlJwXE43/z/uaGw0gFMlPov8J+ncPSba/z75byJWFT5Z9I
         pmzryfmojxgRvrJtVjg6yRRhOKRmYeW6LYzYv8P7O5KPoVzQqYQAXVZA7ADVD61rdaZE
         mwUg==
X-Forwarded-Encrypted: i=1; AJvYcCWBLrzkwlHJFnV4cBmGsCbM5u9wLwcuL+woyFwRO7nABr+QtLnulJJH1tkIMZtJc9VHROr/11HCcA==@kvack.org
X-Gm-Message-State: AOJu0YxgYbUXUP4WqK6mqf5lUjIp6lm+0/IRRkmvkVzRSOW0RD3WkPA6
	IZON0CeyDhZx0hss8lzXtHhonEIKp0o3Yv+eSigyuohIckmPvVtgIyLT4nwaGXi022S1XGXiokf
	LITxiZUiKrpm8WfJwl6NWw/jCPH6M8JohnC87kIckxraHYELrvS48CEp0UZM=
X-Google-Smtp-Source: AGHT+IEAtNjKimBcWz7ySWIB2PtJ4rX2e2H0p9tHig7aJeO1pJS8UfNQgu4O+NBCy5rTzYhp+qiflmCbIJ4yQzMKj5q1QVTqsgfh
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c22:b0:3f0:af3f:e9e4 with SMTP id
 e9e14a558f8ab-3f3ffda4bb8mr185935275ab.3.1756787309568; Mon, 01 Sep 2025
 21:28:29 -0700 (PDT)
Date: Mon, 01 Sep 2025 21:28:29 -0700
In-Reply-To: <6840fdc4.a00a0220.68b4a.000d.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b6726d.a70a0220.1c57d1.0594.GAE@google.com>
Subject: Re: [syzbot] [net?] BUG: soft lockup in sys_sendmsg (2)
From: syzbot <syzbot+4032319a6a907f69e985@syzkaller.appspotmail.com>
To: axboe@kernel.dk, davem@davemloft.net, edumazet@google.com, 
	horms@kernel.org, kuba@kernel.org, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-scsi@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 816294000D
X-Stat-Signature: fro3x1mj6son1dmuncqga1shmdiryyuy
X-Rspam-User: 
X-HE-Tag: 1756787310-512849
X-HE-Meta: U2FsdGVkX1/1IHWI2A5H1GfJlIKyFdteiasnWgnlg/3qgHNtnadlbBhL41sF0bO6vzYlxxDYbarw3ySD2/6lSdsp/qQUFTdJOnCUJLQ23EHRDn4bT5AMCaBGBq/l7dswBYxDVAEfZqtZuMmIVIW+EoSU0W3aLGSpbbdJtLDuW1a7Jd3HpLCYhOb+iQ9o/ah1uqJcHzzbLdbEZiaaYCgUkNts3bp+c4UdLXrId88FSL2kNKNxx67z7YAu1Be4LyJGqaIEdd/43nBL7Ejc6icXzYoxd6IgjLl21KP6mUHKNFP4ZZzuBSeGLDX3vOkvJ6I/jBTkDyW405UXTsnmccp+mGuWMtMfxs1N0WKrZPJvfDlCCH3SD11dDsXVMO/rtaGm8D8rjb9OIxBi9eCs5boPOlDY3yVABD6o+j7yJzjSxx7Lr7xiIz9leFfyzeLXD/TBW1tMokH4NEkQSGSPfAzdn4c5Y5ifBCPo2vvnoUjg5FVu6/tNaJgzpWkBJ2ifikzX2j0TAsCJBe7pNKwj3yir1XHswnR+eDIKpDECGz8FICGHqhScOiOVjkguF1p4jyCfEXDfwj0IHfRdMQTxQaElabX92EJFCmQaQOskZETnPbhrjFtlyugUwCIVMAufqx7QENxYxXS0DDnix2KRFb8bChSxH4NwFPOxnjXH3IhDtC1j6wCznIp/COnyml+xbx5DfN27QBzXBe1V2KicY0nySR/dYsE5bzKZ8O8hT57Hhe8KreBX/iNNSb1UuN2VciPn+xxY0GaFri4SmMVocRWSegtteUP1jaIRMjZQqMaSsXFNPgeudZ6+Xb6In68Xrj1Amz89yxIdfIBiUGTwA2RNA52A2UQ+7kzMGPtPnTmYrhFpw+m41DhARI0OQiDOBVSRWwx71zd0sYtKDRWP0rN/ZwumJQUhXu9l8YOsuloO0r+6ZzBxRJclB0valZx9XPPmnxR0LBxCkhD83jkhtSH
 pdnWrY/+
 fcXei0GKjiT/Kzw9JXXni42DKknwkdbZQfzNkeb9wcdLlgM207QDbW93xSiYdfxuRV2uS02+9BVCsR8Geh4b6EhEtmVnwBXwQRI3WLeOzZy/TO/ZkjllpmdumQnAskmXdaDcomsyntMqc9vbsmmeeges0xUzDTysQZpu1iu8M9zf+59icNWLmYdIvjrBt3i7GWiG7vP1hlfqD3ka4Kxs+MDv6c+jcuSLDoy91M0ELb3Rf6x3W+6bC0UTDyRWM6klLFggPZ7XhPckMd1FqI/LuUVv7yPFCPNHHe6vZA9NOhCuKMK1RYbHGnteqylF51KMW+irmhSxJqjjIb80OriK0RMa8XAKUHMfhvBLEcW4y8kBZssuLkz405YIkyD02f+q/VVM40tgTjvzJBnGSeq9WKzCkPov/UTSb0U8YshtsioNvab5DWaeDpTNL8tNZzXbk2MtFxai2+c8arddrFFYzE4b2rKMQh7Aqmw+6bE0/Re9QGp3l/YnDy+IZ+eWW3fNEm7sH9RWHGyIpysCsbx17nMU4nFUvrScr88YH0pkXFK1LFN2Y7sqGPeYHhd8i3+Xt1mO76zqVBG+JQLqs2HD0fxWML1NpIZ0euBlh9MPJ5GOYfyJ9iZf1Hq7tsfKzS8UhWE1qgTkIDuZCbMImqkvFKtyDxYQKc6h0LpU8AZ3HwP4g9rFWQanoXB0mffvAj5AEDBX2DLtfC5AGFVOdP8jakH52d3ZbdH5NXZ1BSEwp6MReaO2lK/ayrKiAx/tHq2HRVyZZC3qrCzf3bV672/ZeSEOte1SE10zuUw4yZFTTPC30n2LZ3i5ZENppDWaWt+ALYeOF4XEQ73ZwFaQVn+lzQ6v6rHR5Zu3KjEd3u+STr2M+DhsendfQhvbgIC1+8DU4BYFRwQxZkXdb+V1WKiZCp7POoGEJXfuDVH85kzJqTWnBvumLihyykPBeymDds7hsHz+xxmTEDmgwDWcKRjYfpiN9UXZK
 ARinNyOz
 RGRM6buSEM0mIkmsbGIIXuO5Xz7eo5i8xRl8/mPlHnFohaOtIXyrDHYQaf/HvsY3CraJLbccxuUJLiVwLbum7c7ENx80bmtzubLMN7mJNeyTybAIvgeEOoDEnEa8edK6HpGynpyzzAICx7b6aXL9nzibfkYQO8qtho62oHWU/NIIlhORY1Dci1DsNs5ifkRYTkhgDmEWCY9r9Rrbxq6zyBMcRvrAruMUhHWQ3QNafu++MFbjx1k2sZs4RbGZlj/Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    7fa4d8dc380f Add linux-next specific files for 20250821
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16094a42580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ae76068823a236b3
dashboard link: https://syzkaller.appspot.com/bug?extid=4032319a6a907f69e985
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15990312580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/63178c6ef3f8/disk-7fa4d8dc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c5c27b0841e0/vmlinux-7fa4d8dc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9a8832715cca/bzImage-7fa4d8dc.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4032319a6a907f69e985@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P5234/1:b..l
rcu: 	(detected by 1, t=10503 jiffies, g=7533, q=653 ncpus=2)
task:udevd           state:R  running task     stack:26096 pid:5234  tgid:5234  ppid:1      task_flags:0x400140 flags:0x00004002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x1798/0x4cc0 kernel/sched/core.c:6961
 preempt_schedule_irq+0xb5/0x150 kernel/sched/core.c:7288
 irqentry_exit+0x6f/0x90 kernel/entry/common.c:197
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:constant_test_bit arch/x86/include/asm/bitops.h:206 [inline]
RIP: 0010:arch_test_bit arch/x86/include/asm/bitops.h:238 [inline]
RIP: 0010:tif_test_bit include/linux/thread_info.h:192 [inline]
RIP: 0010:tif_need_resched include/linux/thread_info.h:208 [inline]
RIP: 0010:need_resched include/linux/sched.h:2211 [inline]
RIP: 0010:preempt_schedule_common+0x11/0xd0 kernel/sched/core.c:7153
Code: 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 41 57 41 56 53 49 bf 00 00 00 00 00 fc ff df eb 0d <48> f7 03 08 00 00 00 0f 84 9b 00 00 00 65 ff 05 0b 76 5e 07 65 8b
RSP: 0018:ffffc900030c7540 EFLAGS: 00000246
RAX: 1ffff11008494b40 RBX: ffff8880424a5a00 RCX: aa2a76cb3742ae00
RDX: 0000000000000000 RSI: ffffffff8c04e5e0 RDI: ffffffff8c04e5a0
RBP: ffffc900030c75d8 R08: ffffffff8fe52d37 R09: 1ffffffff1fca5a6
R10: dffffc0000000000 R11: fffffbfff1fca5a7 R12: dffffc0000000000
R13: ffff88807da4ce80 R14: ffff8880424a6ee0 R15: dffffc0000000000
 preempt_schedule+0xae/0xc0 kernel/sched/core.c:7169
 preempt_schedule_thunk+0x16/0x30 arch/x86/entry/thunk.S:12
 __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:152 [inline]
 _raw_spin_unlock_irqrestore+0xfd/0x110 kernel/locking/spinlock.c:194
 spin_unlock_irqrestore include/linux/spinlock.h:406 [inline]
 __wake_up_common_lock+0x190/0x1f0 kernel/sched/wait.c:127
 sock_def_readable+0x1fb/0x550 net/core/sock.c:3564
 __netlink_sendskb net/netlink/af_netlink.c:1265 [inline]
 netlink_sendskb+0xa1/0x140 net/netlink/af_netlink.c:1271
 netlink_unicast+0x397/0x9e0 net/netlink/af_netlink.c:1361
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
 sock_sendmsg_nosec net/socket.c:714 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:729
 ____sys_sendmsg+0x505/0x830 net/socket.c:2614
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2668
 __sys_sendmsg net/socket.c:2700 [inline]
 __do_sys_sendmsg net/socket.c:2705 [inline]
 __se_sys_sendmsg net/socket.c:2703 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2703
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa3432a7407
RSP: 002b:00007ffded507800 EFLAGS: 00000202 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fa343a95880 RCX: 00007fa3432a7407
RDX: 0000000000000000 RSI: 00007ffded507860 RDI: 0000000000000004
RBP: 0000562320cd2f40 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 00000000000000b2
R13: 0000562320cb09e0 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
rcu: rcu_preempt kthread starved for 10543 jiffies! g7533 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:28008 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x1798/0x4cc0 kernel/sched/core.c:6961
 __schedule_loop kernel/sched/core.c:7043 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:7058
 schedule_timeout+0x12b/0x270 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x301/0x1540 kernel/rcu/tree.c:2083
 rcu_gp_kthread+0x99/0x390 kernel/rcu/tree.c:2285
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x47c/0x820 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 6072 Comm: syz.2.32 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:list_empty include/linux/list.h:381 [inline]
RIP: 0010:plist_del+0x88/0x3f0 lib/plist.c:126
Code: 5e f0 3f f6 48 89 df e8 56 07 00 00 4d 8d 7e 08 4c 89 fd 48 c1 ed 03 42 80 7c 25 00 00 74 08 4c 89 ff e8 0b 9a a3 f6 4d 8b 2f <4d> 39 fd 74 6d 4d 8d 66 18 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00
RSP: 0018:ffffc900030d76d0 EFLAGS: 00000046
RAX: ffffffff8b80e8df RBX: ffff8880b863a8e8 RCX: ffff888027c59e00
RDX: 0000000000000000 RSI: ffff8880b863a8e8 RDI: ffff8880b863a8e8
RBP: 1ffff11004f8b464 R08: ffff888140a911f7 R09: 1ffff1102815223e
R10: dffffc0000000000 R11: ffffed102815223f R12: dffffc0000000000
R13: ffff888027c5a320 R14: ffff888027c5a318 R15: ffff888027c5a320
FS:  00007ffbb84b56c0(0000) GS:ffff8881257c4000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000058 CR3: 000000007dd24000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 dequeue_pushable_task+0x2e/0x2d0 kernel/sched/rt.c:415
 dequeue_task_rt+0x25e/0x790 kernel/sched/rt.c:1457
 block_task kernel/sched/core.c:2155 [inline]
 try_to_block_task kernel/sched/core.c:6585 [inline]
 __schedule+0x5f1/0x4cc0 kernel/sched/core.c:6896
 __schedule_loop kernel/sched/core.c:7043 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:7058
 futex_do_wait kernel/futex/waitwake.c:358 [inline]
 __futex_wait+0x1c3/0x3e0 kernel/futex/waitwake.c:687
 futex_wait+0x104/0x360 kernel/futex/waitwake.c:715
 do_futex+0x333/0x420 kernel/futex/syscalls.c:102
 __do_sys_futex kernel/futex/syscalls.c:179 [inline]
 __se_sys_futex+0x36f/0x400 kernel/futex/syscalls.c:160
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ffbb758ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffbb84b50e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: ffffffffffffffda RBX: 00007ffbb77c5fa8 RCX: 00007ffbb758ebe9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007ffbb77c5fa8
RBP: 00007ffbb77c5fa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffbb77c6038 R14: 00007ffea00f5430 R15: 00007ffea00f5518
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

