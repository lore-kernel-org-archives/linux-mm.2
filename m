Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02BBBCCF9E3
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 15:30:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 615788E014F; Sat, 25 Oct 2025 11:30:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C5FC8E0135; Sat, 25 Oct 2025 11:30:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B56C8E014F; Sat, 25 Oct 2025 11:30:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2FABB8E0135
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C31F9139077
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 15:30:34 +0000 (UTC)
X-FDA: 84037023588.14.5302B7D
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3DB93A0003
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 15:30:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf15.hostedemail.com: domain of 3GO38aAkbADUjpqbRccViRggZU.XffXcVljViTfekVek.Tfd@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.207 as permitted sender) smtp.mailfrom=3GO38aAkbADUjpqbRccViRggZU.XffXcVljViTfekVek.Tfd@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761406233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=H4PtvkKZFEBjpaVtmYMgaiUP0rE5WRgcuVuHYkk41Is=;
	b=ZU7CwVeTqa7gJ3cQP9oyLwI8XMjYiZZkEsiHobyOH00luWwzl/nj0tzSy4r75T3R58QIfm
	XFq4ogd5f+N4EOmakShMk4V/hJ1eehOQt51RIWVvNYB7YVDHVGhhiImwTGAys7ZfSq5jmL
	FIVpDhRlM6iaEaC83zH+u6q0zhrdNJs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf15.hostedemail.com: domain of 3GO38aAkbADUjpqbRccViRggZU.XffXcVljViTfekVek.Tfd@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.207 as permitted sender) smtp.mailfrom=3GO38aAkbADUjpqbRccViRggZU.XffXcVljViTfekVek.Tfd@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761406233; a=rsa-sha256;
	cv=none;
	b=5W3ITvgZwonJJ86oGPTxfh7ylB8N3ONRzeALYVQi3z7BXBv+xDFnNBDAD23oJMt3znncFW
	YN42itGlE3hAvA+ILsGPxriY6TbvQ6i9ho7zc/8+mP4HX8F/Td13rPspW9QjSJ3naZx5D/
	taEHI69pGI3r7GitYe5uZScPMfhVVnI=
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-430c8321bc1so41474265ab.0
        for <linux-mm@kvack.org>; Sat, 25 Oct 2025 08:30:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761406232; x=1762011032;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H4PtvkKZFEBjpaVtmYMgaiUP0rE5WRgcuVuHYkk41Is=;
        b=foYl4PbJhWrS256Nz068lD8jajpWkBbnElg8XnaqZQWTL+J/3A/eP6Grlo59gMN7Zc
         oV1z/85krq68HN18a5nzrNEHDdpUDv6NkR1cwa4TTp4Sek9jQiVaHX9ZEXXmBFIrFmGc
         0HnIQf69SJhMTsc+d8WQINbXUMgDUmtd2P7wIA3LUh90yV8vOMnP88ufyU1RYy5CX7KU
         bolU9Pg1pXRgTgtZNatvxPFP5wQadWHS0t/uV1MHrU5bHTUwqtrFHF4z0dwQUBBw6pdf
         JJwgAh5Rjh4k/sbVMPr0iJhWxow/OPDZrOlu+zq1itdpXst1oiGf8JhVfWJ1w3CA5XU/
         xv9g==
X-Forwarded-Encrypted: i=1; AJvYcCUnhEWs6PYbc0SAM1yhnqErHUHYjNIJusc5NCfDxv9NMqMwu2X0B/csWMBmHXHQssvPVBOsexKkoA==@kvack.org
X-Gm-Message-State: AOJu0YxZb6/CDslodsmN2826gjnW10OzpojiN93/+C1yObmY5pSU2C0M
	8qZcQeqj2X2K667jcdn+nKduoGi3VjsO4gRQ2QKA+NG8b5sF71ZEVYJPiD1t8pNUeHQf8gPmv89
	nbeLLsutqdrtgsRa93MTl+FnVegg2S/3nduEUEw1UjXmb/htpN8z1BL8bsqU=
X-Google-Smtp-Source: AGHT+IE/mS5AInx/Fn2GfpldYfqwHT1aTDzL70mL7vQ4auUZniXaqCBaITtE4KGxBTh882iPv4MheVT5dy2uy9HDIpuf7K+7ITIw
MIME-Version: 1.0
X-Received: by 2002:a92:ca4d:0:b0:430:b05a:ecc3 with SMTP id
 e9e14a558f8ab-430c525f52amr239057035ab.9.1761406232302; Sat, 25 Oct 2025
 08:30:32 -0700 (PDT)
Date: Sat, 25 Oct 2025 08:30:32 -0700
In-Reply-To: <68087f2f.050a0220.dd94f.0177.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68fced18.050a0220.1e563d.00cd.GAE@google.com>
Subject: Re: [syzbot] [mm?] BUG: soft lockup in sys_bpf
From: syzbot <syzbot+9431dc0c0741cff46a99@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	da.gomez@samsung.com, david@redhat.com, gourry@gourry.net, 
	joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-modules@vger.kernel.org, matthew.brost@intel.com, mcgrof@kernel.org, 
	netdev@vger.kernel.org, petr.pavlu@suse.com, rakie.kim@sk.com, 
	samitolvanen@google.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 7f1r94eqdywpiukdhskjzyfshmqfgjdp
X-Rspamd-Queue-Id: 3DB93A0003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761406233-916307
X-HE-Meta: U2FsdGVkX1/kYFsXlw3ZHoYjDaq1CERw73icxObfzP5R/npqwtGrb7gQtstQgfPTV+8TsdbToIFpvh2aSr0fvIw+9YR2KXofZ/XbVfFJS53ax9dy1LcXfScU0HH+hz5WSav5zKeiu+tSs0ubiTYep2sTJSQlCegZ/OpMKFri03ROk+/H9hAoJKiFH7sb0CuhftBrehYT51HXX3pBfqfAHCxefCcJA+bvbmDFfYDIzw2q5GyteLAbu0VzGYNabx5mi32ptdd1yK1MRzBHv8YgBivETev3dVFF9nUE1FE3lOnXJebXhauFurIyzfkpFmmGMxS4b3Qa9Eu9aH0RCphoHDXfnG7WpAONoBUpDfga/5gsyFstl3NH4+AsfMSjl2dh3OL28EgR3dzytkDL+cdN8Eno2fCuJnbzBGt5w0Dy8DkwlQbClyH+0ciiG+81sWn5dp5oZ7f+yih9GzGJ95JpLDTCyqKBX87KWt7Gfq53nXdzd+xqvv30CnusDCDhxrtv/JgKc/NJH7G/+udeDWGetQI1nkYj5E0Wgqk2pqzEUnWdL2RxZIbrcm6qhM6q/hh4SMnY7BeGDlUG6inZ7cijBwqh8ke4fzxb7nu/05dbFErWPywi9KwjZf28Pya+Iis9O6kFOmjVUCbylSV8ScbvoEw3RFv8r1t6QgEtai4MoNfGs1sr8ul1j9QrAhOWUDb9yZVrDHJz1v/hR/WXHv1+zR0VWFGDRc2RNv4lxpa//5k2R+aAHC9+BJ1EvpR4t9LEKraDd4wRHyHQTUAkBJmdAVYi7EHZ1Na65/eBm/16smoM/2zqhoz1p8k+pdMRAh18saIMPKQ1CHCUocQ92ivC0r2rOqChdQ9nH8nvgqwtOmzY+ABi26kWosKMyLaCJpzZ28ZLQWx0baIj1npjVWwbzB7p4XqUJtckpA0bFYSx6FAwaO7YucWNTlZ1BS9Y6GncnC7UoGCUg70bovvEbiy
 C5Nk1XBZ
 hxwBTOj2XtAb4xxnVmHVKGZYITcTthpH7A7gLIsQwowG1OYzSeSuihtZ2eXIuL5Oei28VbAdfueB8zsKxyAbayhFIWhB73c+iw5R1QlapUBnCXUL1UfSBc0kFOogvIOrPHQdPr5HnWB6Fv3EEMqI9aL7kI9yuIHGC4/juUmrOJpnvwQiKESnXpWexfalpUBYSyb2uROeDfw28BLOnoIjxxN4eHKKIWbTP4iFZDrCaP9bB1WEaHHVadRdpUx+sg9e2gXo3aEIPLG2Npw1GD36AdEO9/591L7QCf0dIzUOJoSoXhUtSDEoVD7gVGWfJX/3T3YlOsjQ7puZOKm3ppi6p5wiH110u/kWJ+gLfmAZF97enetwsYyM9Ev4nEiQX4sXRXyevnxsVSXPN/NisNHYzYDjgn4RcK+brVCujWLk84VvLeaOlNiG4wOW1VFH1/PKEtallRMIvkbowk2MXVpPNvN/JZBs5tMsb+XXRzcVLSBiiAHDxeC+R9Y/vveDr4CjWqyLDcR8qWbvRAaGfiYf/z3/W1JyUJVC7SlAJ948eWh81vUcubr8uhI7PHwhtSbwlBhRAnUWCtWrD75oH2BuhiCTQiAqqhIm78AwSiU0VNt3WsEbYazddSWecLBknQLyL37VvCcB4hbx6kqKK8jMgn0QORopIAs5RbkmV14IjBQOpzApHxR7+Apsxg7YIg8lbGEgUzA5BxH+5UqRRwBRFJeJ87GD6kFQmPAv2Jj+kk0etHhAmjawmbhBlEPIGyBfZb2NkXLlYGoZMeAY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    566771afc7a8 Merge tag 'v6.18-rc2-smb-server-fixes' of git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15c8ee7c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8345ce4ce316ca28
dashboard link: https://syzkaller.appspot.com/bug?extid=9431dc0c0741cff46a99
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=157013cd980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=130cc7e2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/52417ef1f782/disk-566771af.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/66730a263bf1/vmlinux-566771af.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1fe0762efb1f/bzImage-566771af.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9431dc0c0741cff46a99@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P5823
rcu: 	(detected by 1, t=10502 jiffies, g=8989, q=37467 ncpus=2)
task:syz-executor333 state:R  running task     stack:24744 pid:5823  tgid:5823  ppid:5816   task_flags:0x400140 flags:0x00080001
Call Trace:
 <IRQ>
 sched_show_task+0x49d/0x630 kernel/sched/core.c:7901
 rcu_print_detail_task_stall_rnp kernel/rcu/tree_stall.h:292 [inline]
 print_other_cpu_stall+0xf78/0x1340 kernel/rcu/tree_stall.h:681
 check_cpu_stall kernel/rcu/tree_stall.h:857 [inline]
 rcu_pending kernel/rcu/tree.c:3671 [inline]
 rcu_sched_clock_irq+0xa47/0x11b0 kernel/rcu/tree.c:2706
 update_process_times+0x235/0x2d0 kernel/time/timer.c:2473
 tick_sched_handle kernel/time/tick-sched.c:276 [inline]
 tick_nohz_handler+0x39a/0x520 kernel/time/tick-sched.c:297
 __run_hrtimer kernel/time/hrtimer.c:1777 [inline]
 __hrtimer_run_queues+0x506/0xd40 kernel/time/hrtimer.c:1841
 hrtimer_interrupt+0x45d/0xa90 kernel/time/hrtimer.c:1903
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1041 [inline]
 __sysvec_apic_timer_interrupt+0x10b/0x410 arch/x86/kernel/apic/apic.c:1058
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1052 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1052
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:instrument_atomic_read include/linux/instrumented.h:68 [inline]
RIP: 0010:_test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
RIP: 0010:get_page_from_freelist+0x459/0x2960 mm/page_alloc.c:3824
Code: 8c 0d 00 48 8b 74 24 18 49 b8 00 00 00 00 00 fc ff df 48 8b 03 48 39 d8 0f 84 7e 07 00 00 48 8b 44 24 08 4c 8d a0 38 06 00 00 <4c> 89 e7 be 08 00 00 00 e8 ba 8e 0d 00 48 b9 00 00 00 00 00 fc ff
RSP: 0018:ffffc90004c97158 EFLAGS: 00000206
RAX: ffff88823fff8740 RBX: ffff88823fffc888 RCX: dffffc0000000000
RDX: 0000000000000001 RSI: ffff88813fffdf70 RDI: ffff88813fffdf70
RBP: 0000000000000000 R08: dffffc0000000000 R09: 1ffff11027fff7da
R10: dffffc0000000000 R11: ffffed1027fff7db R12: ffff88823fff8d78
R13: 0000000000000830 R14: ffffc90004c97448 R15: ffffc90004c9745c
 __alloc_pages_slowpath+0x33b/0xe50 mm/page_alloc.c:4714
 __alloc_frozen_pages_noprof+0x319/0x370 mm/page_alloc.c:5196
 alloc_pages_mpol+0xd1/0x380 mm/mempolicy.c:2416
 alloc_slab_page mm/slub.c:3055 [inline]
 allocate_slab+0x96/0x350 mm/slub.c:3228
 new_slab mm/slub.c:3282 [inline]
 ___slab_alloc+0xb12/0x13f0 mm/slub.c:4651
 __slab_alloc+0xc6/0x1f0 mm/slub.c:4770
 __slab_alloc_node mm/slub.c:4846 [inline]
 slab_alloc_node mm/slub.c:5268 [inline]
 kmem_cache_alloc_noprof+0xec/0x6b0 mm/slub.c:5287
 skb_clone+0x212/0x3a0 net/core/skbuff.c:2050
 ____bpf_clone_redirect net/core/filter.c:2465 [inline]
 bpf_clone_redirect+0xad/0x3d0 net/core/filter.c:2450
 bpf_prog_3e1cbbed0c4acd81+0x5f/0x68
 bpf_dispatcher_nop_func include/linux/bpf.h:1350 [inline]
 __bpf_prog_run include/linux/filter.h:721 [inline]
 bpf_prog_run include/linux/filter.h:728 [inline]
 bpf_test_run+0x313/0x7a0 net/bpf/test_run.c:423
 bpf_prog_test_run_skb+0xb4e/0x1550 net/bpf/test_run.c:1091
 bpf_prog_test_run+0x2cd/0x340 kernel/bpf/syscall.c:4688
 __sys_bpf+0x562/0x860 kernel/bpf/syscall.c:6167
 __do_sys_bpf kernel/bpf/syscall.c:6259 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6257 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6257
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0d40505cb9
Code: Unable to access opcode bytes at 0x7f0d40505c8f.
RSP: 002b:00007fff9d9b3ed8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f0d40505cb9
RDX: 0000000000000050 RSI: 00002000000000c0 RDI: 000000000000000a
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000006
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000001
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

