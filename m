Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 253EB606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 12:36:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3364F6B05B0; Fri,  6 Nov 2026 07:36:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E9176B05B1; Fri,  6 Nov 2026 07:36:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FDFB6B05BA; Fri,  6 Nov 2026 07:36:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E5FC96B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:35:59 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6EBB6140D0B
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:35:59 +0000 (UTC)
X-FDA: 85404641238.09.2048773
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by imf12.hostedemail.com (Postfix) with ESMTP id BC1B040007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:35:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of 3rMntagkbAFUFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.72 as permitted sender) smtp.mailfrom=3rMntagkbAFUFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793968557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=cjXBRrAj0OK3V1DSLmN4I4LSQPb4mUTR3FTdpcddQVA=;
	b=qKhzZD5IXQ/P4CvU3mSbcxmDkVdVbQHibG0saOT5f5GNJYajERNUlsRP+tvXgHsKAnhsHD
	X/NzVPtuoxjXm6YAfjrcw1Yzs3XToqovNLK0KCyZGFnVI4lbRgLpTyYbjyLc5PuBm2AVuZ
	klqbXWvWxY/E2JQSumenJXhAalLa2rg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793968557;
	b=Yq0D6/6f8wSdqJ4bmco4E5j4XIhmJrCQZhAVNppJ9UG/ABjo2x+D6L8P4xZoYH9js1ZUbz
	9mu3nV7ZWNcgJCQyWYJfKEMPkFE8b4YtQTnOJygsLE5hIg6yJiEHW75AoropsMEPuU6kil
	qZ+Nufm8th2xJG4kbgzgVI5+AESmPi8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of 3rMntagkbAFUFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.72 as permitted sender) smtp.mailfrom=3rMntagkbAFUFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-82274137201so892126a34.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 04:35:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793968557; x=1794573357;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=cjXBRrAj0OK3V1DSLmN4I4LSQPb4mUTR3FTdpcddQVA=;
        b=0MceRUaoz5lVTWuanoQ61KR2ayNgDFP9Gp+f+2A8erLVQUDe72PT3cLRNP0bPh6PRF
         o/YwUCQW0Hr3iHywEO+Ph3ixp7g6ZqNwQb2xmKbFjsttUgaKkFcVkA4xfmA597Y+Npnn
         gXHosRdeZ6lSTSrBBEDf1HYupF3PEbe3SVlDkGKnYN4SlIFkk/+7ZlbubaW/ZzQYHj7P
         woQSg5uaZQw42oNaHkc7qA5TLkL6TZb4kVyTkr6lIBxR9joM/WuLwMLOfPPzdol00PEw
         wfilxEBPPl18lYbDS0nnGxJImzi5WMKoaReO5r5xVS6XYxPgsYePbBVGDoMNjOXl482d
         864g==
X-Forwarded-Encrypted: i=1; AKwUvBxAQtdPlPXsEdLfxhYmA7HVq/tbIZ/UxA1Es7aVuWED/qwnfjlUlmiBQ+BVOA2jx+veO5I3v8letw==@kvack.org
X-Gm-Message-State: APuU4Z86Ml8RW4p82WGEKdpbkkf9b4xYHMLKdjvTigxosHRe2jECtXW/
	Kgt9vAbu5zOjjXbPsVFpleRFja4GtYEIvSU6uOuZx1XAlpVEWobq17JGxcGy/cNMq3REgNMzEaY
	3XlM2iQLi8AAouGK/p4fious6pwC1SQS16Xs0TM6IXvYyjqvivMKdoEeOIuE=
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:14d2:b0:4f4:dd0d:207a with SMTP id
 5614622812f47-567e0f327c4mr1458341b6e.4.1793968556794; Fri, 06 Nov 2026
 04:35:56 -0800 (PST)
Date: Fri, 06 Nov 2026 04:35:56 -0800
In-Reply-To: <6708ce33.050a0220.3e960.000e.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aedc9ac.8be4ead1.3b45e1.0166.GAE@google.com>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in sys_mprotect (8)
From: syzbot <syzbot+6f7c31cf5ae4944ad6f0@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, davem@davemloft.net, jannh@google.com, 
	jhs@mojatatu.com, jiri@resnulli.us, liam.howlett@oracle.com, 
	liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	ljs@kernel.org, lorenzo.stoakes@oracle.com, netdev@vger.kernel.org, 
	pfalcato@suse.de, syzkaller-bugs@googlegroups.com, vbabka@kernel.org, 
	vbabka@suse.cz, vinicius.gomes@intel.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 1suaupet9jq33wpg7m1ujj9fhbzmrxaj
X-Rspamd-Queue-Id: BC1B040007
X-Rspam-User: 
X-HE-Tag: 1793968557-476101
X-HE-Meta: U2FsdGVkX19+ZGuiLje2xEmBu1BB45uek3NIRIwh45RtrXuMPx17Qzlw6i3089IfegCVi0WdGXo5c/3ezjdRZjLRE8OiY/puqwMylr5WHbJuembzB2j7a6ia9tyylBYsQAV/YyHz0JOinHuuZmnocgP/7/mthnaDwmhx+5a0OJzY/tjUmdgCS4bBqm/8liW6Jt0jQjInu1jcKSgK8iOJ9/rRxts8Pjxoc6Ow0C81Bm3sNxgWDYYS2gn+rRGna0Lyu2xgLQt3/Thmu4iNhrrUQkZBiSAsqIzFZoTSJYRGzgzBBHGTzIAq2EKWs5hp4J05RjppLtc4SLW1h7oP5xCgC3fPFzHq9RkAVTh+cC/q1z9B1ZdB8C/QWPaVhXH3J2OeBtyKoiHE+kdFpExHYmf3jTbmmt4T51NOw75xCf1BXIqKovrmTsQ2C6gIp0Lv8MY8cbZnb/NYq9qpzkkmKEDPLtZtDZ5cWKN6VS3CxBWgdpQvsb+mABiz6LVbeDUN4tWyrshDJPP8al54mfFPxFDRyv3hYUXgtp4tRyoJiX85Y47y8Qi0JB/jfbjaICkvjW52b5mpVC1fhQJiihcDyAPK/+UVXHj9iKvt4q8q0iTJX5nneqwaKYbMLj4gPRnrYH6CiGzVtKdKeX5JyLR6U21uldgfkK+qFdSAoM1PP50nVhvp8aWIJf4CNE5pkclu3MS3oOUG95+TTRxajwABGB+nW5dKhK2Wf9ND4vqk3irxkAG/CXwfnpgBlH5YeQJK7JtKWt43OkSrTqn8oILMZ4amDjIrhBrIBCM1/Tdt1GqWJ7VVEZv0TSBI6i1n7NQeY5Y/bP8cT1y+57mHrQ+aupY71ccdpdPz8WZLtxBVn1bGuiSasiYcuNEcaqzS1VbyPt6b4+5x2Z/RcxSmMix3CVw7nIqluK+YAgcELWHSqdhv8fvRx/gPse7XQB5NoGrVDGNioQTRwqYNkr9eY/f0Ul8
 uX5gFyrP
 AHrzxHD+gS1buyp3lANiRgtcD6uAvU+kpsq/xXCYKwvrBvI/zuV6crtXb+E0Qauc2/8ttpg8jGzmcVJ8n7ab868LKULT8jdtM/z6tWc3DkE8bQR5oEaOZhIF90aK4sLC6UTvpk2KdR0Z2WoSYg8Ngb+sB/UwC+OXgaNx1k3eXro0LV2ksSnXLWfQEX0Zq/x9IYwOOjFn4q7ny12tty3wOWSaYpAeZU9Qf47neYwD1PKxlzXMbdKeCLk6t6+C7kYskN7uXjngSRBHIxn+OyLVR2cLZQ6l+gn0Ar1E8uB99Dg5VPRon5rGZ2th3WY2KHjq49uStQMXaf2bZefREPlYr1cvE0MpUcwO7yb4M+gbFhkcbJs7ob9tiXyXIqbF4AoCt1Q4vP7q9bVdAguCt5wzvoL1gtka3NndI3VqSbZZ8dos9LJx9ao5M4PFLJNjIm4LW5PXvSUzzn4IicXZYWN0OMuHi91qm16sWBwa0Xim0xZRp+T8ZdRYOqTYwUTEkyy/t15SFzLKyMwoiB9QTEIsIEqw/MKlY3GoISAs+/sYsVRO+pi21Mcox01StXRonlseRA88TsGbEh8MJCWwLZQW78X3V5PmZjbZfqJvNjlEYe4XySDjmz+1NIcDbNlci7G1KLjO9yn1Q+v9LHhOkNADKcFafeAIzrK2E27uYB0q8fFdvwBqKM1s6wTwIO44BzPSfWBfwai4zqHhh5M1oKy3/w+TlQrZsLT2hdrqYzuTnujz71/atFoNVf7xSInGwMysAjl7CWyLec/tlEbu7juJrdwniA2XxSus0jk6U+mbO+qPaX85V2ddzZ5X9uremoaCIdV60ukZniLAfdFBQDI93Gkcd+mlihJTNFff/CsNlviYLOJyAsPUo2eChbnLTe3knAiGv/0muuCfGFlFJNFVvUKlYkgK68E9E8iwAwsQ/9a+YNBddcG+axJKvRTfyAhS/0xoIVfy8LnbLTVfGH2z5oEDgHMfY
 BYe9E52Q
 LJZoTDnwmNVFlOJ7Omwso1jCQUxxIqHqR4IDs4973fzGG0MuRgzZpnHGA++ryqL4r/rHWe99ePLvDi1UJBOXEd6/h0xRaKg94iTI2MCjQtj5ROIBI2pSlSWwQab4x/yJFwcz9Jc3hnDdNo/Pi9izM4kMZYYRLqmeZABnwXgn2natO8ANha1nsx29XtJjloF9avcX+AzvasLIK3az3vbFXHUw0WzY6HBuhn0o7gfggLMKktv4kFIpxNEFsWU35QIw5RwGv5nh3tgvRhjTuw0vooTybUt5/8kXG8Qy3tEc28sTjbI1rnaROUVhh754oGkNv7stWqHlCtWxT70ToqKsuMR5GwfcM+WV+kls0Kwn924=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

syzbot has found a reproducer for the following issue on:

HEAD commit:    303d91a15925 net: ipa: Drop unused qmi_elem_info arrays
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13bf72fd580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d30e1495ee3ac817
dashboard link: https://syzkaller.appspot.com/bug?extid=6f7c31cf5ae4944ad6f0
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=108e8e55580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10b86bdd580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a7b8a5ad9a41/disk-303d91a1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/74c1d7ed0168/vmlinux-303d91a1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/65d8cd3261b6/bzImage-303d91a1.xz

The issue was bisected to:

commit 5a781ccbd19e4664babcbe4b4ead7aa2b9283d22
Author: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date:   Sat Sep 29 00:59:43 2018 +0000

    tc: Add support for configuring the taprio scheduler

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=124e5a18580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=114e5a18580000
console output: https://syzkaller.appspot.com/x/log.txt?x=164e5a18580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6f7c31cf5ae4944ad6f0@syzkaller.appspotmail.com
Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	1-...!: (1 GPs behind) idle=d724/1/0x4000000000000000 softirq=20067/20067 fqs=59
rcu: 	(detected by 0, t=10503 jiffies, g=19585, q=576 ncpus=2)
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 6050 Comm: modprobe Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/15/2026
RIP: 0010:__this_cpu_preempt_check+0x0/0x20 lib/smp_processor_id.c:63
Code: f5 48 8b 74 24 20 48 c7 c7 00 8d 8e 8c e8 e8 fc 24 f5 e8 b3 f8 2f f5 eb ae 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 <f3> 0f 1e fa 48 89 fe 48 c7 c7 80 8c 8e 8c e9 0d ff ff ff cc cc cc
RSP: 0018:ffffc90000a08cb8 EFLAGS: 00000046
RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000001000001
RDX: ffff8880247f0000 RSI: ffff8880226a42c0 RDI: ffffffff8e92d683
RBP: 00000000ffffffff R08: 0000000001000001 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff52000141190 R12: 0000000000000046
R13: ffff8880247f0000 R14: ffff8880226a42c0 R15: 0000000000000001
FS:  00007f2cd712ac80(0000) GS:ffff88812371f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2cd7492000 CR3: 0000000078d22000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 lockdep_recursion_finish kernel/locking/lockdep.c:470 [inline]
 lock_is_held_type+0xdf/0x150 kernel/locking/lockdep.c:6017
 lock_is_held include/linux/lockdep.h:249 [inline]
 advance_sched+0x1d9/0xc80 net/sched/sch_taprio.c:944
 __run_hrtimer kernel/time/hrtimer.c:2075 [inline]
 __hrtimer_run_queues+0x3bc/0xa10 kernel/time/hrtimer.c:2132
 hrtimer_interrupt+0x4cd/0xaa0 kernel/time/hrtimer.c:2251
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1051 [inline]
 __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1068
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1062
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
RIP: 0010:check_kcov_mode kernel/kcov.c:179 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0x18/0x80 kernel/kcov.c:223
Code: cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 48 8b 04 24 65 48 8b 0d 28 fa f6 12 65 48 8b 15 28 fa f6 12 <f7> c2 00 01 00 ff 74 29 89 d6 81 e6 00 01 00 0f 81 fe 00 01 00 00
RSP: 0018:ffffc9000376f4b8 EFLAGS: 00000202
RAX: ffffffff8bfb23dd RBX: 0000000000000001 RCX: ffff8880247f0000
RDX: 8000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff888077514e00 R08: ffff8880247f0000 R09: 0000000000000005
R10: 0000000000000004 R11: 0000000000000000 R12: ffff88807bdef180
R13: ffff88802ad9bc80 R14: 0000000000000001 R15: dffffc0000000000
 mt_slot lib/maple_tree.c:676 [inline]
 mas_next_slot+0x9dd/0xd70 lib/maple_tree.c:4228
 mas_find+0x6d6/0xcb0 lib/maple_tree.c:5451
 vma_next include/linux/mm.h:1816 [inline]
 validate_mm+0xff/0x4c0 mm/vma.c:680
 __split_vma+0x94a/0xa90 mm/vma.c:597
 split_vma mm/vma.c:626 [inline]
 vma_modify+0xa3f/0x1c50 mm/vma.c:1772
 vma_modify_flags+0x2a4/0x3c0 mm/vma.c:1792
 mprotect_fixup+0x539/0xda0 mm/mprotect.c:823
 do_mprotect_pkey+0x8e7/0xd40 mm/mprotect.c:1001
 __do_sys_mprotect mm/mprotect.c:1022 [inline]
 __se_sys_mprotect mm/mprotect.c:1019 [inline]
 __x64_sys_mprotect+0x80/0x90 mm/mprotect.c:1019
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2cd74c12c7
Code: 89 3d fd 3f 01 00 eb 90 0f 1f 00 f7 d8 89 05 f0 3f 01 00 48 c7 c0 ff ff ff ff eb 91 0f 1f 80 00 00 00 00 b8 0a 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8d 0d c9 3f 01 00 f7 d8 89 01 48 83
RSP: 002b:00007fff152bcf58 EFLAGS: 00000206 ORIG_RAX: 000000000000000a
RAX: ffffffffffffffda RBX: 00007f2cd74d4da0 RCX: 00007f2cd74c12c7
RDX: 0000000000000001 RSI: 0000000000002000 RDI: 00007f2cd74d2000
RBP: 00007fff152bd220 R08: 000000003de00ec7 R09: 0000000000000000
R10: 00007f2cd7205c58 R11: 0000000000000206 R12: fffffffffffffff8
R13: 000000418bb1d7ff R14: 0000000000000000 R15: 00007f2cd74d5310
 </TASK>
rcu: rcu_preempt kthread starved for 10208 jiffies! g19585 f0x0 RCU_GP_WAIT_FQS(5) ->state=R ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:27496 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5583 [inline]
 __schedule+0x17dd/0x5830 kernel/sched/core.c:7382
 __schedule_loop kernel/sched/core.c:7459 [inline]
 schedule+0x164/0x2b0 kernel/sched/core.c:7474
 schedule_timeout+0x152/0x2c0 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x30c/0x1230 kernel/rcu/tree.c:2122
 rcu_gp_kthread+0x9c/0x340 kernel/rcu/tree.c:2330
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
CPU: 0 UID: 0 PID: 5670 Comm: udevd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/15/2026
RIP: 0010:csd_lock_wait kernel/smp.c:389 [inline]
RIP: 0010:csd_lock kernel/smp.c:422 [inline]
RIP: 0010:smp_call_function_many_cond+0x61e/0x1500 kernel/smp.c:970
Code: b6 04 04 84 c0 0f 85 d5 03 00 00 44 8b 3b 44 89 fe 83 e6 01 31 ff e8 21 7a 0c 00 41 83 e7 01 75 07 e8 06 75 0c 00 eb 3f f3 90 <48> b8 00 00 00 00 00 fc ff df 41 0f b6 04 04 84 c0 75 0f f7 03 01
RSP: 0000:ffffc9000436f720 EFLAGS: 00000293
RAX: ffffffff81bca0ee RBX: ffff8880b8341d88 RCX: ffff888033b79f40
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc9000436f870 R08: ffff888033b7b4df R09: 1ffff1100676f69b
R10: dffffc0000000000 R11: ffffffff817a65a0 R12: 1ffff110170683b1
R13: 0000000000000001 R14: ffff8880b8341d80 R15: 0000000000000001
FS:  00007fe06f357880(0000) GS:ffff88812361f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000557f8f49d568 CR3: 00000000692c0000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __flush_tlb_multi arch/x86/include/asm/paravirt.h:46 [inline]
 flush_tlb_multi arch/x86/mm/tlb.c:1361 [inline]
 flush_tlb_mm_range+0x910/0x10b0 arch/x86/mm/tlb.c:1435
 flush_tlb_page arch/x86/include/asm/tlbflush.h:352 [inline]
 ptep_clear_flush+0x120/0x170 mm/pgtable-generic.c:116
 wp_page_copy mm/memory.c:4136 [inline]
 do_wp_page+0x3c3a/0x4b60 mm/memory.c:4535
 handle_pte_fault mm/memory.c:6651 [inline]
 __handle_mm_fault mm/memory.c:6776 [inline]
 handle_mm_fault+0x15d7/0x3750 mm/memory.c:6943
 do_user_addr_fault+0xb35/0x1480 arch/x86/mm/fault.c:1343
 handle_page_fault arch/x86/mm/fault.c:1483 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
RIP: 0033:0x7fe06f3f1b69
Code: 10 48 81 f9 ff 03 00 00 76 28 48 8b 57 20 48 85 d2 74 1f 48 3b 7a 28 75 76 48 8b 4f 28 48 3b 79 20 75 6c 48 83 78 20 00 74 17 <48> 89 4a 28 48 89 51 20 48 83 c4 08 c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fffe7da68c0 EFLAGS: 00010206
RAX: 00007fe06f52e1d0 RBX: 0000557f8f49d540 RCX: 0000557f8f49d540
RDX: 0000557f8f49d540 RSI: 00007fe06f52e1d0 RDI: 0000557f8f49d540
RBP: 00007fe06f52dac0 R08: 0000000000002760 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 00000000000049c0
R13: 0000557f8f4a1f00 R14: 0000000000000160 R15: 00007fe06f52dac0
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

