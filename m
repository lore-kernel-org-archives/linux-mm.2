Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBEC0C61DCB
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 20:56:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72BAE6B0088; Sat, 29 Aug 2026 16:56:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D9F96B008A; Sat, 29 Aug 2026 16:56:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F05A6B008C; Sat, 29 Aug 2026 16:56:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 382356B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 16:56:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A73961601DA
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 20:56:26 +0000 (UTC)
X-FDA: 85155515172.05.86C9E4E
Received: from mail-oi2-f10.google.com (mail-oi2-f10.google.com [74.125.231.202])
	by imf28.hostedemail.com (Postfix) with ESMTP id 00921C0006
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 20:56:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of 3eEeTagkbAK8hnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.202 as permitted sender) smtp.mailfrom=3eEeTagkbAK8hnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788036985;
	b=UWAcaEDM5Og6O4fi/jcfuP1rpBe8uTwastPitY4Hv56gD+t2XdJaHhOtm40tl4p4gwH4oS
	4Wp0RWrlMsp2eZcXHCiOSqViEnwQX+SK7agjsIczTxqg1/pZ5liiR0JbgkDMOM+JIBnaPC
	D63Sgg2bTVcSi4sBH06bxuULrgjIA5w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of 3eEeTagkbAK8hnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.202 as permitted sender) smtp.mailfrom=3eEeTagkbAK8hnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788036985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=0Ws6gQRIE8eSXPt1lDzQoqN14AzV/vLo5gDbb9DjxQI=;
	b=AkmBW3+XIZBoF/2NSDOpqeeTBaTW0PBzsgrX6smtdX3mblO0O4BNxcGqUQcRgpL4uPmmSZ
	hkEb7AQ1hPt2hkGOQtvKMmlzYHrgN2CDEJGqyUo/fsuVxrEnQL7zZHTCD1O1agJLLmfISn
	A8UggQyoAL9nWdL60G4fXxqjkywv0hg=
Received: by mail-oi2-f10.google.com with SMTP id 46e09a7af769-7f193d62888so212146a34.1
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 13:56:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788036984; x=1788641784;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0Ws6gQRIE8eSXPt1lDzQoqN14AzV/vLo5gDbb9DjxQI=;
        b=d/rlKd6dM82xxRm4Avx6Zz79x6dpzM4prYO4kh5JB+qzMuOypA9vAF60y8mbGW+U89
         8ofH1KsEjT21YDYEEUfwnZ73Tp3CSmrM0SdOseR/5ZIzo064QuuuNQMyD8UsOdPzdmdU
         ZNSMYn/wVFhPxsgjHEzF96CjR97VPimGgToLK8pN3p61wbtDSKPFhwa+z5kcqSAQ8Dv5
         4HfneFbvMitkMe+2q2m0n1KvWN2NIoCibXWywuij87tQByJUd3LfSznlFkQx9Jy69jHj
         RirFTKldGHAFUR8XlsXGCNrsPOLFl0Phj3KGcvdQpDZ0YhBj/k8ZeXULTURWQ8taotCQ
         ymOg==
X-Forwarded-Encrypted: i=1; AHgh+RoiRNZcVWxLtlVUBE28/MCV2zO5Fpu9p3cBqIZ4YG5HXuS6Cb4nyB7DLc+OIVbGUWI+gmBn/J9SPQ==@kvack.org
X-Gm-Message-State: AFuF++kr0VQqSpt1674Kktqopg3MelGYpayra83K3cxcm6SAJ1ZM5WDI
	BMeXUl+svJYeoKczSKqiOAY5dyMLHpr5IZxdwa3vVZTVW/l9EQz11PVUbzLvQ/NQ5a0dQwIny9v
	q1DBqhHRlbiSXBEKIKSk3tKumo1hqD0Gg7BxVmTvzSO/1QKL+Jizt1wJmRQ8=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c197:b0:4b3:89ae:df60 with SMTP id
 5614622812f47-4b398342e94mr17578034b6e.16.1788036984074; Sat, 29 Aug 2026
 13:56:24 -0700 (PDT)
Date: Sat, 29 Aug 2026 13:56:24 -0700
In-Reply-To: <695aefde.050a0220.1c9965.001c.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a934778.4d659fcc.734b4.002f.GAE@google.com>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in __mmap_complete
From: syzbot <syzbot+e4aa91d7f20c34417d4e@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, dvyukov@google.com, elver@google.com, 
	glider@google.com, jannh@google.com, kasan-dev@googlegroups.com, 
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, netdev@vger.kernel.org, pfalcato@suse.de, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 00921C0006
X-Stat-Signature: 8394yp6srypy6hb5fffbhwzjyyny8kot
X-HE-Tag: 1788036984-216762
X-HE-Meta: U2FsdGVkX1+FkJbf17eV5llyFVvSE0jZ7VFTPF7bLK760WxyDgxdsIE7xjODmNQYN9LH0Xao/Eo3O7Ea2FN7/4x83r0NmxCRV/tfbEvBKFUeJJnvgjE9k+g0zbDh/WcXcOqzB20irzLC6zdI/UoPiwHjQiyO7xyBaLR0MIbMn2r72kpqu0j5nqKQs+/EPwKo7coTRDbiO5dx+9LCCbBhFwoOxoiJpyak3OKaGOzqc0HxMhTXQJJn4Ys48XfIE/bvXzTgtH3CwWPqK0Vuei5BkpdRruzLw0JcDudYMqxFAyBaK+qiDgn/XUhxLmhPT0kti+6Up11Bo+Ks/QbCyA1C39Tv3aey/CG+n1pqZr4KRH7dw9A00rZPtcvpe3xv2MHdb6hspHrbcFHvdmG4V40H4YfRFkHVPOix3LxNvs0Y/c3O+aAdx2bDjaj11DTNdgVcVtPAdNZMs6v3cFf0061ypDMD/AMHDn7RU/2vr0x57aY3ckGXMKlCOzK9f+60c+T6X+TX257fa4sW6Jco3RVztVa9rqKfQzAoHNeTkSyTYkripJfKfTWCSvHj2/wOAgmMG1qDZ5MH7UkxhtiM+Kgzcfkm8XrHarYA4ExW8xhYZ7BCPbSqcsCBkxehNdlft/t4CjdJATI5lBZ2tL/5ZTTuMvsZZIW4S35R/SX/sNYBbQCLEmKbCNTF1yyLtQM1ByOwFJlCK4bukHrfmz//qam73LzMxlwkJhd+e/G+BWmo1msdt7tcxtilMu9bWXlOCfyyQ1Vhp1OfMW7eHEvw1PDrIYEg2yh4t4TB6nIf2g46Pe4gypMoOnSXLrYIqcY/4sYZ8bU3tQFfYsWLAjTzJt/GOXJCXsAZANg4NtD9TcFIrX38q/ygH40fc+mRbJJQn7i2BzAMfWeCPT7Pk/eupz/rXkQ92AeRdUCf3VMOZfhBDfdjdnQcQTMVe4qc9GzDkiUdlWXukOZnHeKu7YKUvnT
 fFISHDAP
 L0cCEG4ZqWkKEc/y7P39OxQ3AAe/1v41UAlIWv4AXv0ZF71k8kYtzS8juMiGZjV+rVzFv8NonNoKNnh9tnA6i68RbqQMD8Qw0vEfJT8B+EHnEtStWpizWfM7Vo5HJkySB+JxPKok8lBsY1n9Lxl7jSX/4wNsh6q665LnL8sWkEMd/WXdNZ6fJ2/Kqy4P/DT3Ix0CPEwV8kYf+3Xh5GRCDSScAMtW+Y1JnY4xR+hMN1gtcyjoGpmaNUREs++qwacGLSMUX7jSAIG1HgSYhmWBw21oBiuNUaekMrPnH3fAtZG6WpM13fBW7I2d3zA2U0ls51R2qdJR+nG62StgPqT1W9+r0hBlbyw4Eno9ttRoNQS3MiZH71xBeX/t1XPEjcFD/AahOWlyTEprN3GQ1LZHVVk3ZBlv7AeBgbJ/WoJaPyEw8zEu3/nOE2zELXpMoJTjawgjfFCc1Eyyfa09ylNmrDZQVTGi6qbU7B1+Itc5nJkCCkGUI1rJ4skuNGBz/da4xMG5aXjquJaDAtBc8xBY08cIkcj5UPu6y2G0+sPw1MIVKISDwQfZoQCW4fmiLHpHlJWqYKGkHj6ddzQxU+zKDpy5CgNov953y4mKm4oLtplcNrDCbYTEyuqqihlV3eS9x6lSq9nEeBX/YH7zH7uiLz8q4UORcLMoVvCdA9qIhM8rObic9+HCH77dkjhAblgsT45u1HEhuldvkhUQZGY4IZBzuplhsus/fCCa4Zc1tTMk5xEl6IOaRAGeNLZopPYykvY7FupiOVc4j8Rl1JDqfVsb9ZIMQWSIrmnVSWeMhPQvzz/X9AcP0H8CYhjYx2XQJ0TtltrK3uU1NcY2p2up4odQYpAK26vZzcN7ScgHSudqBjxxo4iqFT3p+Fz4KQ7wZisDzDuRHMhq9udOHWK/x6t0vV2+xIpTmrOrOdlQV8v+hgr0KRPdglNiHewPXLuCDCDgqNON8/VFQbDy9WopVFqIr+/d8
 VC+3p/kv
 KwFCDLXDXq0unj6HOHezTFZBBmcCJEQMxB0VmVAwUPGTrxVg/bJvL0H8tVU4W8DT8BP36xNZlHo+MeKsAtDcE1h10k3w38vXBQE/H1ZgeecDf1DawBQsq/16BMQbsfVUEnSJ7tLbi7yjC7rgp7fZkizgyuZWTMf/57xA321jAB/+f0Zm6wIk5EuOMVhNQ0soU+PWkN9Bxf1b4Fx81JMHkJb3KwumBf08a31DJ+dhNwl+zbT1NSjnv7y91SSnim8KjIl7N49jMF/nYBCKaAaLkggpUEEhQ5vg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    1b78070aaef6 Merge tag 'net-7.3-rc1' of git://git.kernel.o..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=154d7d49580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5e4e3a0e188a497e
dashboard link: https://syzkaller.appspot.com/bug?extid=e4aa91d7f20c34417d4e
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=134d7d49580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1177ae25580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/18856a03a9a3/disk-1b78070a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cc2bc68d7ef4/vmlinux-1b78070a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/05a5e00f8f91/bzImage-1b78070a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e4aa91d7f20c34417d4e@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	0-...!: (1 GPs behind) idle=a1cc/1/0x4000000000000000 softirq=17251/17256 fqs=2
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P4982/1:b..l
rcu: 	(detected by 1, t=10502 jiffies, g=15057, q=530 ncpus=2)
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 6026 Comm: cmp Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
RIP: 0010:arch_atomic_try_cmpxchg arch/x86/include/asm/atomic.h:107 [inline]
RIP: 0010:raw_atomic_try_cmpxchg_acquire include/linux/atomic/atomic-arch-fallback.h:2170 [inline]
RIP: 0010:atomic_try_cmpxchg_acquire include/linux/atomic/atomic-instrumented.h:1302 [inline]
RIP: 0010:queued_spin_lock include/asm-generic/qspinlock.h:112 [inline]
RIP: 0010:do_raw_spin_lock+0x12b/0x2f0 kernel/locking/spinlock_debug.c:116
Code: 14 04 04 c7 44 24 40 00 00 00 00 48 89 df be 04 00 00 00 49 89 d6 e8 34 c1 93 00 48 8d 7c 24 40 be 04 00 00 00 e8 25 c1 93 00 <8b> 44 24 40 b9 01 00 00 00 f0 0f b1 0b 0f 85 20 01 00 00 43 c6 44
RSP: 0018:ffffc90000007c40 EFLAGS: 00000097
RAX: 00000000ffffff01 RBX: ffff88807cbce2a8 RCX: ffffffff81a3bd0b
RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffffc90000007c80
RBP: ffffc90000007ce8 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff52000000f90 R12: 1ffff92000000f8c
R13: ffff88807cbce2b0 R14: dffffc0000000000 R15: 1ffff1100f979c56
FS:  0000000000000000(0000) GS:ffff888124ce0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2972a84000 CR3: 0000000073aec000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 spin_lock include/linux/spinlock.h:347 [inline]
 advance_sched+0xc2/0xc80 net/sched/sch_taprio.c:931
 __run_hrtimer kernel/time/hrtimer.c:2067 [inline]
 __hrtimer_run_queues+0x3bc/0xa10 kernel/time/hrtimer.c:2124
 hrtimer_interrupt+0x4cd/0xaa0 kernel/time/hrtimer.c:2243
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1051 [inline]
 __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1068
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1062
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
RIP: 0010:lock_acquire+0x232/0x350 kernel/locking/lockdep.c:5913
Code: ff ff ff e8 40 dc 3f 0a f7 44 24 10 00 02 00 00 0f 84 38 ff ff ff 65 48 8b 05 92 e7 f0 11 48 3b 44 24 50 75 33 fb 48 83 c4 58 <5b> 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc 48 8d 3d 07 23 da
RSP: 0018:ffffc900037eeda0 EFLAGS: 00000296
RAX: 27e016d3b0e95d00 RBX: 0000000000000000 RCX: 0000000000000046
RDX: 00000000e9c5941a RSI: ffffffff8e6fac39 RDI: ffffffff8c6d8b80
RBP: ffff88801df9be80 R08: 7a00000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff8ed5c6e0 R12: ffffffff8ed5c6e0
R13: 0000000000000002 R14: 0000000000000000 R15: 0000000000000246
 rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 rcu_read_lock include/linux/rcupdate.h:849 [inline]
 class_rcu_constructor include/linux/rcupdate.h:1216 [inline]
 unwind_next_frame+0xac/0x2550 arch/x86/kernel/unwind_orc.c:495
 arch_stack_walk+0x11b/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0xa9/0x100 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __kmalloc_cache_noprof+0x321/0x600 mm/slub.c:5563
 _kmalloc_noprof include/linux/slab.h:991 [inline]
 slab_free_hook mm/slub.c:2700 [inline]
 slab_free mm/slub.c:6499 [inline]
 kmem_cache_free+0x156/0x650 mm/slub.c:6626
 remove_vma mm/vma.c:517 [inline]
 vms_complete_munmap_vmas+0x897/0xbe0 mm/vma.c:1441
 __mmap_complete+0xab/0x4b0 mm/vma.c:2721
 __mmap_region mm/vma.c:2888 [inline]
 mmap_region+0x11d0/0x2240 mm/vma.c:2964
 do_mmap+0xe0a/0x1300 mm/mmap.c:573
 vm_mmap_pgoff+0x272/0x4e0 mm/util.c:581
 ksys_mmap_pgoff+0x4dc/0x760 mm/mmap.c:619
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2972aaf242
Code: 08 00 04 00 00 eb e2 90 41 f7 c1 ff 0f 00 00 75 27 55 89 cd 53 48 89 fb 48 85 ff 74 33 41 89 ea 48 89 df b8 09 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 5e 5b 5d c3 0f 1f 00 c7 05 46 40 01 00 16 00
RSP: 002b:00007ffd9a1c6af8 EFLAGS: 00000206 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 00007f29727db000 RCX: 00007f2972aaf242
RDX: 0000000000000001 RSI: 0000000000004000 RDI: 00007f29727db000
RBP: 0000000000000812 R08: 0000000000000003 R09: 000000000000b000
R10: 0000000000000812 R11: 0000000000000206 R12: 00007ffd9a1c6b80
R13: 00007f2972a83b20 R14: 00007ffd9a1c6f30 R15: 00000fffb3438d62
 </TASK>
task:udevd           state:R  running task     stack:26384 pid:4982  tgid:4982  ppid:1      task_flags:0x400140 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5520 [inline]
 __schedule+0x17d4/0x5820 kernel/sched/core.c:7270
 preempt_schedule_irq+0x4b/0x90 kernel/sched/core.c:7592
 irqentry_exit_to_kernel_mode include/linux/irq-entry-common.h:539 [inline]
 irqentry_exit+0x14f/0x910 kernel/entry/common.c:167
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
RIP: 0010:kasan_check_byte include/linux/kasan.h:402 [inline]
RIP: 0010:lock_acquire+0x6d/0x350 kernel/locking/lockdep.c:5882
Code: 9b 01 00 00 89 c0 48 0f a3 05 b7 eb d6 0e 73 0d e8 68 34 09 00 84 c0 0f 84 e2 01 00 00 83 3d a9 1c d7 0e 00 0f 84 e9 00 00 00 <48> 8b b4 24 88 00 00 00 4c 89 e7 e8 33 3a 94 00 83 3d 8c 1c d7 0e
RSP: 0018:ffffc900044df268 EFLAGS: 00000202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: 8000000000000001
RDX: 0000000000000000 RSI: ffffffff8c6d8b60 RDI: ffffffff8c6d8b20
RBP: 1ffff9200089be7c R08: 0000000000000000 R09: 0000000000000000
R10: ffffc900044df3f8 R11: ffffffff81b272d0 R12: ffffffff8ed5c6e0
R13: 0000000000000002 R14: 0000000000000000 R15: 0000000000000000
 rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 rcu_read_lock include/linux/rcupdate.h:849 [inline]
 class_rcu_constructor include/linux/rcupdate.h:1216 [inline]
 unwind_next_frame+0xac/0x2550 arch/x86/kernel/unwind_orc.c:495
 arch_stack_walk+0x11b/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0xa9/0x100 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2748 [inline]
 slab_free mm/slub.c:6499 [inline]
 kfree+0x1c5/0x650 mm/slub.c:6792
 tomoyo_check_open_permission+0x32c/0x470 security/tomoyo/file.c:791
 security_file_open+0xa9/0x240 security/security.c:2739
 do_dentry_open+0x4a0/0x1380 fs/open.c:973
 vfs_open+0x3b/0x340 fs/open.c:1101
 do_open fs/namei.c:4837 [inline]
 path_openat+0x1443/0x1d60 fs/namei.c:5000
 do_file_open+0x23e/0x4a0 fs/namei.c:5029
 do_sys_openat2+0x115/0x200 fs/open.c:1417
 do_sys_open fs/open.c:1423 [inline]
 __do_sys_openat fs/open.c:1439 [inline]
 __se_sys_openat fs/open.c:1434 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1434
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f22b3aa7407
RSP: 002b:00007fffdfe06440 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007f22b425c880 RCX: 00007f22b3aa7407
RDX: 0000000000080141 RSI: 0000559823bb502e RDI: ffffffffffffff9c
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000000001a4 R11: 0000000000000202 R12: 00000000ffffffff
R13: 00000000ffffffff R14: ffffffffffffffff R15: 0000000000000000
 </TASK>
rcu: rcu_preempt kthread starved for 10498 jiffies! g15057 f0x0 RCU_GP_WAIT_FQS(5) ->state=R ->cpu=1
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:27496 pid:17    tgid:17    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5520 [inline]
 __schedule+0x17d4/0x5820 kernel/sched/core.c:7270
 __schedule_loop kernel/sched/core.c:7347 [inline]
 schedule+0x164/0x2b0 kernel/sched/core.c:7362
 schedule_timeout+0x152/0x2c0 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x30c/0x11f0 kernel/rcu/tree.c:2122
 rcu_gp_kthread+0x9e/0x2b0 kernel/rcu/tree.c:2330
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
CPU: 1 UID: 0 PID: 12 Comm: kworker/u8:0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
Workqueue: events_unbound toggle_allocation_gate
RIP: 0010:csd_lock_wait kernel/smp.c:363 [inline]
RIP: 0010:csd_lock kernel/smp.c:396 [inline]
RIP: 0010:smp_call_function_many_cond+0x61e/0x1500 kernel/smp.c:944
Code: b6 04 04 84 c0 0f 85 d5 03 00 00 44 8b 3b 44 89 fe 83 e6 01 31 ff e8 51 51 0c 00 41 83 e7 01 75 07 e8 46 4c 0c 00 eb 3f f3 90 <48> b8 00 00 00 00 00 fc ff df 41 0f b6 04 04 84 c0 75 0f f7 03 01
RSP: 0018:ffffc90000117720 EFLAGS: 00000293
RAX: ffffffff81bb677e RBX: ffff8880b8643708 RCX: ffff88801def8000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc90000117870 R08: ffff88801def959f R09: 1ffff11003bdf2b3
R10: dffffc0000000000 R11: 0000000000000000 R12: 1ffff110170c86e1
R13: 0000000000000000 R14: ffff8880b8643700 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff888124de0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555570500a38 CR3: 000000000eb48000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 on_each_cpu include/linux/smp.h:71 [inline]
 smp_text_poke_sync_each_cpu arch/x86/kernel/alternative.c:2602 [inline]
 smp_text_poke_batch_finish+0x5fd/0x1110 arch/x86/kernel/alternative.c:2812
 arch_jump_label_transform_apply+0x1c/0x30 arch/x86/kernel/jump_label.c:146
 static_key_enable_cpuslocked+0x128/0x240 kernel/jump_label.c:210
 static_key_enable+0x1a/0x20 kernel/jump_label.c:223
 toggle_allocation_gate+0xab/0x290 mm/kfence/core.c:902
 process_one_work kernel/workqueue.c:3387 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3470
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3551
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

