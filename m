Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F244CCD184
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 01:45:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6898D8E0025; Tue, 14 Oct 2025 21:45:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 660CE8E0005; Tue, 14 Oct 2025 21:45:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 577F28E0025; Tue, 14 Oct 2025 21:45:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 45EA38E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 21:45:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CB57F5A897
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:45:33 +0000 (UTC)
X-FDA: 83998656546.19.E2CAEB2
Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	by imf20.hostedemail.com (Postfix) with ESMTP id 294D71C0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:45:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf20.hostedemail.com: domain of 3u_zuaAkbAL4w23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.79 as permitted sender) smtp.mailfrom=3u_zuaAkbAL4w23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760492732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=J366MR2M7sKoRrXuFnkKIqxbANSCO0h9QS9aVAEV1kM=;
	b=HuI3Bx92z5TAjDJ6eoFzZ7kxdHsodcq6gW6sO/mCyG7ZmnkJ9L8mIHdWZSKYGZPeA4hSbL
	fSduuPNycH+Ji095FRTKMmy4p5zowIWy7Qj3SXspRjkyGyteV+Mv19wkAGWWsRgpS1avhc
	kiHnXedpDvGhoINwwO/u1/kxGpJzkcI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf20.hostedemail.com: domain of 3u_zuaAkbAL4w23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.79 as permitted sender) smtp.mailfrom=3u_zuaAkbAL4w23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760492732; a=rsa-sha256;
	cv=none;
	b=XX7Srowr75jt49cC1kByRSfG+QknXvg+IHJMCxdDuGFlfAxSU48tn4RLPOAek9LpBMt8nd
	1/pOntupK3Bea2aHEgFH6HWTOIGB+ErRqEgDGL55q/+wIomJghU1MUbhV3HmSNFLKeAjNq
	wbKJAECoqAIMa7vXhTriAWgDTQEus+E=
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-937e5f9ea74so1262017039f.1
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 18:45:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760492731; x=1761097531;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J366MR2M7sKoRrXuFnkKIqxbANSCO0h9QS9aVAEV1kM=;
        b=sbzRvLHTNvHSNYUEZamIlzzB+UcawiyfOkvHc38FWb3Qqiz4r6ktD6Obl05AFygBos
         1PLgfflefFEVpT1V4SjUhSQkoj5whta2H1WW+0gULBX2WYoiMjDGoiR6Y6oecOnO6ZjW
         xbR1wfTwZi7zeTk5tshS26J70Km2UKtirJhj/mRoJ/DCymLSpymAusP6dvuFsEfmKneX
         wj74oyzGd1VuO0jWSs9hy/tQ7Jt8TEgBxqbG/mfU+0p3f/xWHztDAMapZfaMdkrg2SPe
         JRvSD7Roz7QAM3JhuG7EDaTHwUGygNhYnCP3Q7BrNJsoxOjwM1JRJnwfaIUGkF+/oxAM
         JTtA==
X-Forwarded-Encrypted: i=1; AJvYcCVnVDodwwdKyeeWQli3VsUc8hwtfk8Qkixw3BpMdT2P+DxZ7scWO5qzGLaQQlvC2h0Ks5VU4F0vnw==@kvack.org
X-Gm-Message-State: AOJu0YxbAYBmvyN5uknHbidgKbGkUY+VKs8Kfk3+LTd8N4b5MrUIkq2+
	GVLZM6D9ZgEBVRD3c8FOrV4ECm7Elcj5hKccCXMSvJJV69yT++qHTqRbzmWnSdoRrkllGzsyHYF
	46DP+pjowEvJ4FEg46qcRW83bhPhvJNPSX0ioyZbsFuo8KKtcFu2E6GyvqFY=
X-Google-Smtp-Source: AGHT+IFG4yP9H5c+k6xaEmWTyp3AfP2MgGIsiZlU3OcrCbCiINaRQfeZRXV2R7N4pCbai5xzJzvB1fmB/ddKLZx28OQuBTwb1Yql
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1648:b0:42f:85fb:38be with SMTP id
 e9e14a558f8ab-42f87423707mr292381045ab.29.1760492731092; Tue, 14 Oct 2025
 18:45:31 -0700 (PDT)
Date: Tue, 14 Oct 2025 18:45:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68eefcbb.050a0220.91a22.0228.GAE@google.com>
Subject: [syzbot] [kernfs?] [x86?] [mm?] general protection fault in
 call_timer_fn (2)
From: syzbot <syzbot+dbca4dcd735c25501713@syzkaller.appspotmail.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	tj@kernel.org, virtualization@lists.linux.dev, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 8h413u1mmuwfxr8ki8rpzrc8goajer85
X-Rspamd-Queue-Id: 294D71C0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760492732-134895
X-HE-Meta: U2FsdGVkX18mFDu/uxV5c/1lG8L6zV2tU0/mljm6BCcn1H+V2hlIHfmiOAdaJFgBhDrBDer6SkHPFZyhmTjuSt8djg58XDYhBpriL3pbGEaqNIK9t+QqHG2r7Q1XG/w+36yTYyQHIMnWbW06N765AdJIUqufMi46tPmBa0IRqsRxji70O7zEu38oDtEZJq8mPGxDtgWVgmj2ILfwi2HSl4bTMQbM5hbX8PS3vbyhqy9hJYNUpQuXDxSQ3CSTlNNOV1QXfcCWI9YNaxIvpEYtIzCf2PCJmcAJMe06YPqJZlZeLqdu3p59hSuHH9kVSz7jJMmsbrFdXKZwPs8sHFVxKvpdXuK4ATRiT1DmecXq1T61ztIVMwV+nfvX+BespuaCR5mvYJsJGEwhyBkqjdIBry80F5vkH30dqkX/nrQ1E9bPDJTwps6tGRxDKAUVAk159fT/iY6BU7PSO79/RBvXwuh3VaNvpeVgw/utR5GjNYQv2oUELGrsjRmilyU22SmzAl3PdahqHHfVPriXBvruoyzB7wIqg3HADoOAUTvHkYD8tdndryL10ko9b+IsxGjDEfHFOs7MmQO9XEn0QU8Tt+erI5Y1qspm1tJPLp03bjUOluTypGUBvgBWRKINPoECDGlCFD8NrwdMC1HBO4CibjN5itfaxJjl+NZe+f6onnQmKGNROTecQHj44s8vtW3IyKIeMOJacGo256FseQrl19C4tucW7ytYV/ZDU7It2Ry65xSKq4oUYxMGDNqFV9CqNB+aXWmqFVy4tpv413FiEIS03aFJxzz+sEn864jBhl+arD7Y+zerF9JEGPwvyGvZY9sDPrbWJKKMyCYdDaPuNw6CU6W0q51nNx6x83m8qHM9ShE1YjMPm3/iCmefTWOujwlj4uACaimUqSQMpe/YM6aGEuA2TTu7BL7oVj/JtCShpZto3yyBXCkfkJE99wsErfvBjnNnoATklw5gUTR
 hF5pqJfR
 yU5FFcRueakqSJ1MKDmiJZl70f0ZTGaM/ew9aHf6mPsFTEqEJ7i5YgKG6IseIZWxtS9lduqCP7Nbz0nw/kEdgrK3WCc3bKzHOoFIZ5DTcyeJVUXfOStxpJQr4CJ4iTitcofV47ZyhxcdAa/SuGhpwllHdkpJn7PSloA+f43T5vobB4OQLqKnFDW4iMQXDWuIJPcio5Mnj5F3HFrMxPmGfwAGCybvNTQrpnaoIgS+9pGjqcJ2MCWELFx43b6xo5NXhQO4mrwSAFvyF/hanrAbg/lysMDswBysnS2NdLhNM/juKdT/ER24H9TQl1ulj3Hlwm4g9lcbWbM2/+bqZ8EKKQQDGR5e5bhjCfIIt/3BFjvqwtO7X7cxwwRrEHTrvueaOpm94tsX/lwujXjO2Zw3Ek2t7DPj1HBxybNqPuBj5EukKohAw1CZnU8as0vlsA7oHFonAzYIwxPXhxO7OEQ+qJ765JSUKqNZcoH2IIn50DYTonRj2sZp1U/p4/wf9qgydbcCqph0UA8HCkKbQ1SWsfZ6hQl0a6MM9H1+Qja8ORqci1PH02jILJyPo68SXnTeJluJuOtxO5T+wtZcbOXeWl5BBqKS5TjefoCHXfoHRG9Bw+RbkWGUlpfxLeRCcH0XDK7AlToBG3GTJIHHwSBA4K4/YAIUem6XHOSjQ7HaFHlcTPgfUvgKZyiyLAHX2pH21TAfj4JnknNOgjyUzl7S31QtE8veRW6NzWqQiGKyYZttN9kKuDEXC508z/ToVLFHzNfJP3wigMYA03lv7dPxRgFmmo/T+MlnBP4bh6mFbvWzutsEPNCkB/T0xaFHgOuRRyMor7UyPm/8kvA7/g7vFvdZSOwpXS7kFB1Abd6/3CVESXNg+fzFkrFN2mLgnLSo06Wb7JZY3Jm/1JJISq0GPUChArvskVBohZ1Qy8uYrc5etBeL2djXuu0nr3QZqRZ6jN3EJcWG3GxDk5ciGbd/TBd0idGTn
 3Lg35zFG
 viOkXUU/pQRZW5Zt1n3LaPq3xsY1RjVoNsCCPbheuvRl6daKKaf6CKEVm6q6fhM4bJaaJibGH6ypehlSnksNgU7gzlKGpRrxsZdijqTcAJnShhn12SzyGByJ1OU0wj4npfZl5vyjOOdacbhZMvWGfBcAyYpQiw5XsFf89K6fQwljsUdkiVonQgCKdaubGAw2IOtc4ZKvUAXkZFycXZ8qfe+/vt8/CHGqcxk4Hy3GoY2LaFdClPU4rQ4hqNPXgYbGLUih81VGwvGQxT5MMsdzYKpoqcxgsHDp1BAMYr4TD9wAuAuw2vEg/TRBDOFKOgti7Fl4YB/pPwtAPRvDkS/ZGPuxKGKjgkZIYwTWjlkKGzWQhvkNcdZOxmlORHtEr26rJYBJcRvUPM+jYPOKh2k2uyiP3TcZ2qX1SLdSkAoNrWg6AwZtUl+7+7Pf8BFzCFo0m5CwIZWPECZmpWh3oqDuIT3Um6ifg9psdfMT4PXKrPSupx5SeGVlh19uE26ms4Vf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    d3abefe89740 selftests/bpf: Fix typos and grammar in test ..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=172edc62580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c321f33e4545e2a1
dashboard link: https://syzkaller.appspot.com/bug?extid=dbca4dcd735c25501713
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/067335e1be92/disk-d3abefe8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8ea133347d7e/vmlinux-d3abefe8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5ef631484984/bzImage-d3abefe8.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dbca4dcd735c25501713@syzkaller.appspotmail.com

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
CPU: 1 UID: 0 PID: 6784 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:trace_event_get_offsets_lock_acquire include/trace/events/lock.h:24 [inline]
RIP: 0010:do_perf_trace_lock_acquire include/trace/events/lock.h:24 [inline]
RIP: 0010:perf_trace_lock_acquire+0xa1/0x410 include/trace/events/lock.h:24
Code: 3c 08 04 f3 f3 f3 48 c7 44 24 60 00 00 00 00 c7 84 24 80 00 00 00 00 00 00 00 48 89 74 24 30 48 8d 5e 18 48 89 d8 48 c1 e8 03 <42> 80 3c 38 00 74 08 48 89 df e8 70 7c 86 00 48 8b 03 48 85 c0 48
RSP: 0018:ffffc90000a08940 EFLAGS: 00010006
RAX: 0000000000000006 RBX: 0000000000000030 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000018 RDI: ffffffff8e008e60
RBP: ffffc90000a08a40 R08: 0000000000000000 R09: 0000000000000001
R10: dffffc0000000000 R11: ffffed10044f692f R12: 1ffff92000141130
R13: 0000000000000018 R14: ffffffff8e008e60 R15: dffffc0000000000
FS:  0000555585eed500(0000) GS:ffff888125d1c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055555f2285c8 CR3: 0000000026022000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Call Trace:
 <IRQ>
 __do_trace_lock_acquire include/trace/events/lock.h:24 [inline]
 trace_lock_acquire include/trace/events/lock.h:24 [inline]
 lock_acquire+0x311/0x360 kernel/locking/lockdep.c:5831
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
 __queue_work+0x809/0xfb0 kernel/workqueue.c:-1
 call_timer_fn+0x17b/0x5f0 kernel/time/timer.c:1747
 expire_timers kernel/time/timer.c:1793 [inline]
 __run_timers kernel/time/timer.c:2372 [inline]
 __run_timer_base+0x646/0x860 kernel/time/timer.c:2384
 run_timer_base kernel/time/timer.c:2393 [inline]
 run_timer_softirq+0xb7/0x180 kernel/time/timer.c:2403
 handle_softirqs+0x283/0x870 kernel/softirq.c:579
 __do_softirq kernel/softirq.c:613 [inline]
 invoke_softirq kernel/softirq.c:453 [inline]
 __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:680
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:696
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1050 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1050
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:lock_is_held_type+0x137/0x190 kernel/locking/lockdep.c:5945
Code: 01 75 44 48 c7 04 24 00 00 00 00 9c 8f 04 24 f7 04 24 00 02 00 00 75 4c 41 f7 c4 00 02 00 00 74 01 fb 65 48 8b 05 f9 03 27 07 <48> 3b 44 24 08 75 43 89 d8 48 83 c4 10 5b 41 5c 41 5d 41 5e 41 5f
RSP: 0018:ffffc9001d826770 EFLAGS: 00000206
RAX: b973a21ede490300 RBX: 0000000000000001 RCX: b973a21ede490300
RDX: 0000000000000003 RSI: ffffffff8dba5ce5 RDI: ffffffff8be33300
RBP: 00000000ffffffff R08: 0000000000000000 R09: ffffffff825d3aac
R10: dffffc0000000000 R11: ffffed100365ff25 R12: 0000000000000246
R13: ffff88807bd43c00 R14: ffff88801b2ff988 R15: 0000000000000002
 lock_is_held include/linux/lockdep.h:249 [inline]
 kernfs_root_is_locked fs/kernfs/kernfs-internal.h:109 [inline]
 kernfs_rcu_name fs/kernfs/kernfs-internal.h:119 [inline]
 kernfs_sd_compare fs/kernfs/dir.c:349 [inline]
 kernfs_link_sibling+0xf7/0x3e0 fs/kernfs/dir.c:380
 kernfs_add_one+0x1e0/0x520 fs/kernfs/dir.c:810
 __kernfs_create_file+0x22b/0x2e0 fs/kernfs/file.c:1068
 sysfs_add_file_mode_ns+0x238/0x300 fs/sysfs/file.c:319
 create_files fs/sysfs/group.c:76 [inline]
 internal_create_group+0x66d/0x1110 fs/sysfs/group.c:183
 internal_create_groups fs/sysfs/group.c:223 [inline]
 sysfs_create_groups+0x59/0x120 fs/sysfs/group.c:249
 device_add_groups drivers/base/core.c:2836 [inline]
 device_add_attrs+0xe0/0x5a0 drivers/base/core.c:2900
 device_add+0x496/0xb50 drivers/base/core.c:3643
 netdev_register_kobject+0x178/0x310 net/core/net-sysfs.c:2356
 register_netdevice+0x126c/0x1ae0 net/core/dev.c:11189
 veth_newlink+0x5cc/0xa50 drivers/net/veth.c:1884
 rtnl_newlink_create+0x30d/0xb00 net/core/rtnetlink.c:3825
 __rtnl_newlink net/core/rtnetlink.c:3942 [inline]
 rtnl_newlink+0x16d6/0x1c70 net/core/rtnetlink.c:4057
 rtnetlink_rcv_msg+0x7cc/0xb70 net/core/rtnetlink.c:6946
 netlink_rcv_skb+0x205/0x470 net/netlink/af_netlink.c:2552
 netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
 netlink_unicast+0x82c/0x9e0 net/netlink/af_netlink.c:1346
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
 sock_sendmsg_nosec net/socket.c:714 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:729
 __sys_sendto+0x3bd/0x520 net/socket.c:2228
 __do_sys_sendto net/socket.c:2235 [inline]
 __se_sys_sendto net/socket.c:2231 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2231
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7d15f90a7c
Code: 2a 5f 02 00 44 8b 4c 24 2c 4c 8b 44 24 20 89 c5 44 8b 54 24 28 48 8b 54 24 18 b8 2c 00 00 00 48 8b 74 24 10 8b 7c 24 08 0f 05 <48> 3d 00 f0 ff ff 77 34 89 ef 48 89 44 24 08 e8 70 5f 02 00 48 8b
RSP: 002b:00007ffdb7942f30 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f7d16ce4620 RCX: 00007f7d15f90a7c
RDX: 000000000000002c RSI: 00007f7d16ce4670 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007ffdb7942f84 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000003
R13: 0000000000000000 R14: 00007f7d16ce4670 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:trace_event_get_offsets_lock_acquire include/trace/events/lock.h:24 [inline]
RIP: 0010:do_perf_trace_lock_acquire include/trace/events/lock.h:24 [inline]
RIP: 0010:perf_trace_lock_acquire+0xa1/0x410 include/trace/events/lock.h:24
Code: 3c 08 04 f3 f3 f3 48 c7 44 24 60 00 00 00 00 c7 84 24 80 00 00 00 00 00 00 00 48 89 74 24 30 48 8d 5e 18 48 89 d8 48 c1 e8 03 <42> 80 3c 38 00 74 08 48 89 df e8 70 7c 86 00 48 8b 03 48 85 c0 48
RSP: 0018:ffffc90000a08940 EFLAGS: 00010006
RAX: 0000000000000006 RBX: 0000000000000030 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000018 RDI: ffffffff8e008e60
RBP: ffffc90000a08a40 R08: 0000000000000000 R09: 0000000000000001
R10: dffffc0000000000 R11: ffffed10044f692f R12: 1ffff92000141130
R13: 0000000000000018 R14: ffffffff8e008e60 R15: dffffc0000000000
FS:  0000555585eed500(0000) GS:ffff888125d1c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055555f2285c8 CR3: 0000000026022000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
----------------
Code disassembly (best guess):
   0:	3c 08                	cmp    $0x8,%al
   2:	04 f3                	add    $0xf3,%al
   4:	f3 f3 48 c7 44 24 60 	repz xrelease movq $0x0,0x60(%rsp)
   b:	00 00 00 00
   f:	c7 84 24 80 00 00 00 	movl   $0x0,0x80(%rsp)
  16:	00 00 00 00
  1a:	48 89 74 24 30       	mov    %rsi,0x30(%rsp)
  1f:	48 8d 5e 18          	lea    0x18(%rsi),%rbx
  23:	48 89 d8             	mov    %rbx,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 38 00       	cmpb   $0x0,(%rax,%r15,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	48 89 df             	mov    %rbx,%rdi
  34:	e8 70 7c 86 00       	call   0x867ca9
  39:	48 8b 03             	mov    (%rbx),%rax
  3c:	48 85 c0             	test   %rax,%rax
  3f:	48                   	rex.W


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

