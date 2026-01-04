Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83F0BC2A062
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 22:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 945C16B00AE; Sun,  4 Jan 2026 17:55:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91D606B00AF; Sun,  4 Jan 2026 17:55:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 854376B00B0; Sun,  4 Jan 2026 17:55:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 73F836B00AE
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 17:55:29 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 01BC6CFA35
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 22:55:28 +0000 (UTC)
X-FDA: 84295789578.10.F0AB09F
Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	by imf10.hostedemail.com (Postfix) with ESMTP id 50432C000F
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 22:55:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf10.hostedemail.com: domain of 33u9aaQkbAHsrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.77 as permitted sender) smtp.mailfrom=33u9aaQkbAHsrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767567327; a=rsa-sha256;
	cv=none;
	b=2KvUgG8SAvgbKEMgy0mXZY1Z/zqeK93Y17OC8leOyuRS+KGhGazMJ0ZHfdvm4drXB/CU1Q
	sMi+ICBw4vkyIygKTS5XghfTMmgfsNppY5MrCweEAeHPpMU/6nyc5LddQ31Q2gnlUYORw/
	bLNaaIne6uuW1hUPDdHhKMrPC1bs8T0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf10.hostedemail.com: domain of 33u9aaQkbAHsrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.77 as permitted sender) smtp.mailfrom=33u9aaQkbAHsrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767567327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=0znZNcFPDKCmH0IcSRimsp85tEBTEHmi2lVRn4slosk=;
	b=ZSijGIsoVdU5i17a2enWqokGBlAJDQFLY7CS0gbt6AA+hw1bVsH4thNWbE4e8F52e7sgaV
	syg2ty69D1sjicOfL+ZutWRJZAddG2ogXjiX7qM4xfRqRjsZuesbibOalJSS1fo5F7LW9j
	0wCBQ7dvKuUMm2ri4drqU9/LTIGQ13U=
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-6574475208eso12572187eaf.3
        for <linux-mm@kvack.org>; Sun, 04 Jan 2026 14:55:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767567326; x=1768172126;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0znZNcFPDKCmH0IcSRimsp85tEBTEHmi2lVRn4slosk=;
        b=vvIeNBWs0Up9BzdN5SLbibzmV5elaePaVlbM94w4VgoH7fBHpSVFG+9i+Ctu/h++ZH
         XbTE8CCIXkwprTb+ZWPeVCckRz/08rGpbbFsfDCmS6jXGA17CouJxdI2b3JsMGiK8R3U
         L7w2qma6R7P0jj0GbeLSDDjEQsVbVlSiQlFokrslOliNzUH6ulyZN7Ter+5Wu5QmRhAE
         4Cl9p1tFKpF/4QSbr/Lychnt3c6+9apUw4xT+DzGReKHdHPzxi2mWhie4FfeeabvJVKZ
         Jz7BhrWu6CUB+goZmmKjf/A58M6XCxBWkrBCgYiFQI4Xjtyk12keMfU29Pnqfb+loZ67
         od9A==
X-Forwarded-Encrypted: i=1; AJvYcCVQbVbsWvIV+apNRX8Qmnyl+fTUJk/rv2GQGPqwoOnmeN+Mhsj9vz6BLnjWSzxnAEIwaRD2emoPqQ==@kvack.org
X-Gm-Message-State: AOJu0YwBhYEa651FsBvUaUboSDMDccVr7QatmVAfl2OgLZ/4mZ4KhFY6
	RGnA0l4A/yd/RgOeGSt3RW5OZA/zqfiF0xx8+4Ygoa5SV92yU20ojk5I4Sw6rE270DrxVZfxweJ
	wmrib8tzLrWvgFLnMoXfiujbC9oFK2wKBK+s2JqcvDCf8p84/ZKcbDQe3YAA=
X-Google-Smtp-Source: AGHT+IGEnnlbWibYXy6pKy9IHYbLw+D+VyBTDCwJWA9byN6aI2SjFQnzuJs28IC9m/27fb2DzrNfD6sGCgPm/l7AXsesiF+F2vCe
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2289:b0:659:9a49:90b1 with SMTP id
 006d021491bc7-65d0ea5b1d9mr18451783eaf.48.1767567326341; Sun, 04 Jan 2026
 14:55:26 -0800 (PST)
Date: Sun, 04 Jan 2026 14:55:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <695aefde.050a0220.1c9965.001c.GAE@google.com>
Subject: [syzbot] [mm?] INFO: rcu detected stall in __mmap_complete
From: syzbot <syzbot+e4aa91d7f20c34417d4e@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, jannh@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	pfalcato@suse.de, syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 50432C000F
X-Rspamd-Server: rspam03
X-Stat-Signature: 3yid5roggwp3b46seqcxa7x8cpwsmqor
X-Rspam-User: 
X-HE-Tag: 1767567327-707626
X-HE-Meta: U2FsdGVkX1/rdOZf2vBgEeEvh+l4LW4cMioAH86TI9H/eT5pGICeOS2foC0CAIKIg14fKwRExljfW28GY2k6xdI211WxPCZ52Cg50yvrUJaOqR61RPa0HNuRNYa+biPXZKCLcQv3PNaXVN3SUNKDyXd4cS0fOPAf30IfX95ZG0jquhpuTvy8KbBZLhjAVEPU3n7l7WK7GcwO/AUcKhDcPU30GkqN3Lp8NocmSbz9cxkJa49jA2Y40RXLVtdBBPhc6ko7cn6rBq+tK011i/dL7gRRSXl6vaSOBiwIm9Fk1USByePHE3+IMExdNBAZ5rX3A6gJDdOyRkAS7sJiASKFF4DSYvQUjWZyxQgO6/7zVNeZdNegcwEw7QsDOrY3rR5TdqTB5f8Aibn+dFPKkqQsbjkgR3S281Suir+6RvNrz+vPivTe9SFVm2DJ6nCE5n9ySvOFWkqSXyJbyRJmKFDw7xiuYQPiOAo611l7tjvaQ31aLy8uJKYnzCSe+N05WDMFXaT4n8J61JeOMmlII1ohQYtD4dFo7Ns7sRzO+PXmUMJXwO0vY0v7Kk0psgFSyLqw6FnXVCAW6pRhI4CUcwEc4jkhRSXyICcNgcOlctdHl242idsW31OnvV0pxcGLWiYU6vk+skEHS6EKir8P1HCsydzHRNlHMnxohGPpIY0a4FmneZp6RqLOlXL3fgWg+QVy+wTRVdj+0FSJdq3+j7rMtmMz6KYPBdSTgUg+f9ixQPYwGbpKmvuaOmqtB+rilaRt/0pl2Z3oQ7RAKQgR3QJs3sDkSJaOcp+pCC29jN6gN9zzWzVfklB/SuDusHt2ix/ecdwGJffyiIlJsI7Z2aJl912ChhlsK1UZqBMBAwZ4B5+BQ6O9zYVW94df5EidGi0nKx4dtI26Kx+Rcmx97vT+GIvIw2K3oxoBUb9o3cKba4Jhu8UHSaTPK8ZvHpDPVTzoq8UOYQAfvpfpF9lR92E
 wYAByb3u
 TO7oPK7cs+IlhL8TN17n/s1peMvE0uDnvtP3dDV3DdD+sL6+uMZ9e/JlGixckXwicLwISEuzSsdLNONDT/FdI+B18rmV51SGAyzcWYKDgB9uHxNhX+EpxDW9RyJCqMjLBIsm1njaE43gsBQ9OR/IqfjZgpsMe/s7dO02NDcepVY5/jDz8vnCIUSXrPzDewnq8u212qzfKEZn3q+asu1+tHW+OwF7i3N+5ntWQBNYSsqMz1RYSARUDdM2YZa5uj/fjzfzaOND8iXSs9qHy5Su+WbOtQTfHHne6M+5WGvrXkFb8BtZXm+18f5zSYMUEtQnAvWv+C9GT4LQhCP5gaMfvSFfEtuhXfBeF/0OVKunlESBZNMJxojEhwh42yOmSp5nW6N4LdoboNNVoGGD/j8BSZgk5KnNObGSOV7F0Z2IxYZPCfUHyQFpbfm8f24+xQvBYYX9nr1PLI7Tk+dAKdR+35iIVzkSVF68eRLKLRj32YBv83ZVxdTnYTTxwjyF5txTnng5jnLokuOKMLf4VsexHKxOWV82Ywia2jXIfhWBv5AyP0RqsKh1Sx2AEpVX9hA/0oIWNpMVdZL3IAOv2Y8Et+m7E3JIXi6+Wo3wGkQ8e25JJ3LyPwpBTsRypjiFyn5pT8IdjPSN/2Zz1A65eYZZGKMBsYeaYZF1rXFEi++ufY2JPzRavrexkSMNRyzEcWZrWjKMNY/+WOXLpuPsaB9kaPbdTGbTVYo5gElRgJiTmFrUKOr/mXEkj3L+H4090+kZATNaVdsL9vEW2XkmvJPVL72zYnhcYwU3ElEZrDb0CFzdTKRWvF/8MHkvJtO8I3arriGi/DYusGv7zEsPDxwCoMEyVVUmqpNLlned+yJQV/ntuMf7SX6My8SflbOVKH545g0NHP70lArKYIC0wLImnmvLCvNSyOM8Y+hIwzhgPpsNN0QmS2bFgMiaEmpb3U7loG8mDOZvxGoz940fat6Vg8OUdegOV
 56tNAPr4
 H4HouldgS/W91WC5ToYlNa9o0MSx3QTTLe97dxpNGAlCj6dGkXuc31EY84XA7FnxzZzRnMRdEZsLr0fCoL+hl9K++OiFPSV3H/QLXZtI2YaQMoaAh5WyyazOi23fFdvwcZn+uzfimQukxHaF+J0KU/ZFhedj+PhkZnjLh0UhrAlkd7c9HF2aO/r+cUnEzqCq0lg1gis/cPetN5WFBZF3qMG6GibWqn37k2HEv/m4Dbor61Jfe5oq7q0TrvIh+29Ke8pK9dLEJBXD53p3HA/OP8mKE6+HM+b526nT4n5nFXLYDpgiJpVtMyz62qfO3CA9cMhWgR0on2U6DHp23vzTaFLqjn5V1cFIfHIr/7isDtjXw3mXnglnxMwfG/D9cgzhg96FGMP3mQRS+q7viXHIRcHlR18CPXArEIEaWudVV4o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    c8ebd433459b Merge tag 'nfsd-6.19-2' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1205b222580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a94030c847137a18
dashboard link: https://syzkaller.appspot.com/bug?extid=e4aa91d7f20c34417d4e
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11e5cafc580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/499025e81349/disk-c8ebd433.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9eacf2e4acfd/vmlinux-c8ebd433.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4650397775c2/bzImage-c8ebd433.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e4aa91d7f20c34417d4e@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	0-...!: (3 ticks this GP) idle=233c/1/0x4000000000000000 softirq=15929/15929 fqs=0
rcu: 	(detected by 1, t=10502 jiffies, g=10825, q=798 ncpus=2)
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 6083 Comm: rm Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:__raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
RIP: 0010:_raw_spin_lock_irqsave+0x40/0x60 kernel/locking/spinlock.c:162
Code: a6 9a 6c f6 bf 01 00 00 00 e8 5c 85 34 f6 49 8d 7e 18 31 f6 31 d2 31 c9 41 b8 01 00 00 00 45 31 c9 ff 74 24 10 e8 c0 c7 41 f6 <48> 83 c4 08 4c 89 f7 e8 44 68 42 f6 48 89 d8 5b 41 5e e9 89 49 00
RSP: 0018:ffffc90000007ca0 EFLAGS: 00000082
RAX: f6300cf39c3c4f00 RBX: 0000000000000092 RCX: 0000000000010002
RDX: 0000000016fc2300 RSI: ffffffff8d975f94 RDI: ffffffff8bc083e0
RBP: ffffc90000007e90 R08: ffffffff8497cbfd R09: ffffffff99b67028
R10: ffff888035774300 R11: ffffed1006aee863 R12: ffff888035774300
R13: ffffffff99b67008 R14: ffffffff99b67010 R15: ffff888035774300
FS:  0000000000000000(0000) GS:ffff888125e1f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1fb067feb8 CR3: 0000000072afc000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 debug_object_deactivate+0x6d/0x360 lib/debugobjects.c:873
 debug_hrtimer_deactivate kernel/time/hrtimer.c:443 [inline]
 debug_deactivate+0x1d/0x1e0 kernel/time/hrtimer.c:483
 __run_hrtimer kernel/time/hrtimer.c:1745 [inline]
 __hrtimer_run_queues+0x2b0/0xc30 kernel/time/hrtimer.c:1841
 hrtimer_interrupt+0x45b/0xaa0 kernel/time/hrtimer.c:1903
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1045 [inline]
 __sysvec_apic_timer_interrupt+0x102/0x3e0 arch/x86/kernel/apic/apic.c:1062
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1056 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1056
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:deref_stack_reg+0x1a7/0x230 arch/x86/kernel/unwind_orc.c:422
Code: 46 49 8d 40 08 48 39 d8 0f 97 c1 4c 39 f0 0f 96 c0 20 c8 3c 01 75 30 4c 89 c7 49 89 f7 e8 11 08 00 00 49 89 c6 48 8b 5c 24 18 <48> 89 d8 48 c1 e8 03 42 80 3c 38 00 74 08 48 89 df e8 13 f4 b2 00
RSP: 0018:ffffc900031f70e0 EFLAGS: 00000202
RAX: ffffc900031f7568 RBX: ffffc900031f7248 RCX: 0000000000000001
RDX: ffffc900031f7248 RSI: dffffc0000000000 RDI: ffffc900031f7330
RBP: 1ffff9200063ee41 R08: ffffc900031f7330 R09: 0000000000000000
R10: ffffc900031f7258 R11: fffff5200063ee4d R12: 1ffff9200063ee42
R13: 1ffff9200063ee43 R14: ffffc900031f7568 R15: dffffc0000000000
 unwind_next_frame+0x18cc/0x23d0 arch/x86/kernel/unwind_orc.c:-1
 arch_stack_walk+0x11c/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x9c/0xe0 kernel/stacktrace.c:122
 kasan_save_stack+0x3e/0x60 mm/kasan/common.c:57
 kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
 slab_free_hook mm/slub.c:2501 [inline]
 slab_free mm/slub.c:6670 [inline]
 kmem_cache_free+0x475/0x620 mm/slub.c:6781
 remove_vma mm/vma.c:462 [inline]
 vms_complete_munmap_vmas+0x626/0x8a0 mm/vma.c:1296
 __mmap_complete+0x7b/0x610 mm/vma.c:2540
 __mmap_region mm/vma.c:2717 [inline]
 mmap_region+0x11e3/0x1d10 mm/vma.c:2786
 do_mmap+0xc45/0x10d0 mm/mmap.c:558
 vm_mmap_pgoff+0x2a6/0x4d0 mm/util.c:581
 ksys_mmap_pgoff+0x51f/0x760 mm/mmap.c:604
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1fb096a242
Code: 08 00 04 00 00 eb e2 90 41 f7 c1 ff 0f 00 00 75 27 55 89 cd 53 48 89 fb 48 85 ff 74 33 41 89 ea 48 89 df b8 09 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 5e 5b 5d c3 0f 1f 00 c7 05 46 40 01 00 16 00
RSP: 002b:00007ffe403d8a68 EFLAGS: 00000206 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 00007f1fb0667000 RCX: 00007f1fb096a242
RDX: 0000000000000001 RSI: 0000000000008000 RDI: 00007f1fb0667000
RBP: 0000000000000812 R08: 0000000000000003 R09: 0000000000024000
R10: 0000000000000812 R11: 0000000000000206 R12: 00007ffe403d8af0
R13: 00007f1fb093fab0 R14: 00007ffe403d8ee0 R15: 00000fffc807b150
 </TASK>
rcu: rcu_preempt kthread timer wakeup didn't happen for 10501 jiffies! g10825 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402
rcu: 	Possible timer handling issue on cpu=0 timer-softirq=3502
rcu: rcu_preempt kthread starved for 10502 jiffies! g10825 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:I stack:28008 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5256 [inline]
 __schedule+0x149b/0x4fd0 kernel/sched/core.c:6863
 __schedule_loop kernel/sched/core.c:6945 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6960
 schedule_timeout+0x12b/0x270 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x301/0x1540 kernel/rcu/tree.c:2083
 rcu_gp_kthread+0x99/0x390 kernel/rcu/tree.c:2285
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x510/0xa50 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
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

