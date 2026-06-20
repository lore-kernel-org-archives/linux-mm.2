Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 502AACD98E4
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 03:58:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB6EE6B0005; Fri, 19 Jun 2026 23:58:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D67866B008A; Fri, 19 Jun 2026 23:58:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7DF96B008C; Fri, 19 Jun 2026 23:58:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 90B486B0005
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 23:58:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DA44A405D7
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 03:58:25 +0000 (UTC)
X-FDA: 84898933770.28.724017A
Received: from mail-oi1-f207.google.com (mail-oi1-f207.google.com [209.85.167.207])
	by imf21.hostedemail.com (Postfix) with ESMTP id 40C1E1C0003
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 03:58:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 33w82agkbADAeklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.207 as permitted sender) smtp.mailfrom=33w82agkbADAeklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781927904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=Lo1BGMAuxmegwNBn3SWnedPduG928rlaMvwjWR8I/rc=;
	b=J6T9tKjDyVdK/MI5Wvm/VDmzpXq1vcTKakxQeDqKLaU5NK/+QHeqyKmuhdu1UtEldAgpAL
	0jnjb/G1lziaN4UU0v5v2Hbs2pWoP8jkHTG8GyKcX+oX8xWUwfG7OQODuXPaFNJYxpaNgG
	k8fqma8PrcADSH5Bq4AAo4wJuBLZGSc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781927904;
	b=bWJCWANODYlYEZTZGzXs/td+0RIOU5Qwy/X/x+oUsgEBpkdVWi3Ccgn1HJ1Lv+yexrgCpM
	zHsMIBP94U5WGrwK8B5qdqwJ4gJGK079wbQCa9Pu8uyJNt+imt3jhH12WhMG7YQW5OBXlL
	CaEDFnKttp0XZuUZmEg7O4IldPYDV/w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf21.hostedemail.com: domain of 33w82agkbADAeklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.207 as permitted sender) smtp.mailfrom=33w82agkbADAeklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f207.google.com with SMTP id 5614622812f47-48b22ea31f3so244574b6e.3
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 20:58:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781927903; x=1782532703;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Lo1BGMAuxmegwNBn3SWnedPduG928rlaMvwjWR8I/rc=;
        b=XnGDTKOc/rvTF1oSO4tvp1lmmAoxPPT6bZcMaV/lrcBsuREy3XT4MDMgKjy0+7gPH8
         dny8APRNisc7gZhLK0J1DQ3QJFufkbO0JALZe8GJHNvaT3/zqCOlPViXjPv6Vpp1EQaW
         BO6hOa6LH6xyvmK6wmofKdFrNjF0XUYOpOufXdVz3SpaOor1zd9SrWh3OlGM6787nrrI
         qICInxGW8EHluq/u1N+ahmxGxjZJpepY9gUWNcEqDwNMoTfHB8h0qPBNItCGgIz0/ei/
         DqPQHgMajaf4M+D51+4HcJ04fNv5NEGpZ4yIDVV3xoujtL/r2EQD93hH0UVMsykxItcv
         Mw+Q==
X-Forwarded-Encrypted: i=1; AFNElJ/oYjFQfJWGaj/1jdPiY0Y4OpBisGC8rY/XN0/Ibh4mUE8AraiH0910D7JMLrod/2KFUIhA9X6Mew==@kvack.org
X-Gm-Message-State: AOJu0YzntC9zn/oh45Iieu3W1ayBla/zQi7X4OCXgtywWkwLU+PlaZEV
	mqR4LHQPacvpS8cc1zruI47B0GYJ4PPhknaQCMPXfrIBTHd7/xGNNpu3nCgGcVgZEEUrjZqa8mH
	Gx5x8fWcs8hn3Xbl4sp2I80tczfHOQJmoC81k4o3Xf3T5t8lyzOpA+YQlnMU=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1a29:b0:47b:bd7b:10d0 with SMTP id
 5614622812f47-4896aa24c4fmr5106313b6e.13.1781927903317; Fri, 19 Jun 2026
 20:58:23 -0700 (PDT)
Date: Fri, 19 Jun 2026 20:58:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a360fdf.871e809a.2d6dda.0001.GAE@google.com>
Subject: [syzbot] [fs?] [mm?] INFO: rcu detected stall in dentry_kill
From: syzbot <syzbot+0635dc2e2c3c21a6aa04@syzkaller.appspotmail.com>
To: brauner@kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 40C1E1C0003
X-Rspam-User: 
X-Stat-Signature: 4kmkqob38he7s7eb8qtm9i6tqmbpj8bm
X-HE-Tag: 1781927904-382893
X-HE-Meta: U2FsdGVkX19RZYomLuL50kIyfO6yZNVssiz9RvJmK6zEJOtv+2CY8ts9AtoWBsFDu0Y3cGvOZYE67x7FoeAZJKu1VX2+1bS4jxvaO5VMsOdthMNgJOdnycepTBBMT7/Mdc2lZce6plxwc9i5r8Mz9HHjOX3hm7ia4mC12DT00pMo/gAewGqSAU2hPXgjWSBykMI6A7YQuQmErNhgzgc1E0DxsDLhzCgxpPUeslM/CZLfWro5Lxlz4bf7o1G92doHv9bGITT50Bm5LT7oKeDABQizlLP+KwDZ9ypo1JHU1/31BgCXtWXKNQ+kZbWSjy5YMcTimUgL4cGKf7SjJ2NgPyYyzEc1NzQ7ZPJaiyQhNW9W6c5NALUf1k0mqRP7/ccyRTkoa7dQZejqXQlclj+XDqIcudfBDx3oSThT/mnYnB1AkF900s+UVaJUFk2T7lAKuxigEPo7cFToByfVMLEMtExEAPU9WNEJHijCiYcDYDGr2sIabAIsu8Wm1x1Nfwrq+yM7A5d7DTJ1KV3s0wpd9zgb3krgzLUwn57rbiOTaWF203QtvekPeEWMgBp2lf4bRzusUPLKiuCKDsqfni/BM2m68I2lpNiMzggQpVpcMlp5fC0XKAspr2xKGx8br+0VOzV3NE/FrStuwmdRupljiM7p1nVkJapxxeL3ZRlzPbthIL7a0k9kWOZdyM7PWNYQQZP95ePc2GSJJH1B+ObzG4qgHx2EOa/ZKxhZ6tQHPGtxYd9LeIfQrNk1Xom0sbISnlHpe305fRYHHU+KKoYlAMRFpop0RGIIhdBrkzxUOr8BJZLykbeF4QfJE+9YjSspBUipr2BD1XQuPng32mVHUsmZAthlYm50Byve/QVencwZOB5esZ4w0I4kRQ1K8+SXxtRjQOo5diisdbTdvL7E/XvbKce70vVxol6ELe5HyJ9dRn/iyjWHARTBhSMSyKEwfEZXX4CGdd7NxNjLekc
 k+GlU6cP
 y/v6gy+XItCcamdaDiBRIWVyxTE9ISDsGKrxiVnikit+JmqyjzrWocsAoKAi4/sOxZ866Rk/J3JLEbQtH2PfQrXYMbo5pVDKVdkQpiKe91Tq8SYjJhVtOb/DPwU6ReRxYBCzKGPmVt7ATnGvpNGkPqRvJGbwSCVymMEEV17gSX3SlJJqA34DVZXFCFKAU35SG+7zzqBgNbywkD6UGo1n/28cDJUASIJh3aC9PjCHL0Ya4btCNh3Zh3P3H7X5thHoZRSiQaq3dJtdG4TWihj0JUY3S8995Be8LBpkvq51rLOqo8D9MTXiW7seU5Vcz7I1EE46JQ/Rv1x7VNXQzLVCOyW0fO+5sISaa3StqCUqLOKlCredkwsZHTeijrW+YIzB3XJlDtnIZDXv+mSYmxqvI42LZp8vwteC+Xj166a0MrtuTbOS+fljeRr4jr1sC63BCMkPffv3rwA+QJoNvJqxR9KtyUXi0I9w81jJ+6tkbzqqrXYy3XRIbksHDMASnP90CFCk2UbgKTKIV1d6ENioJ3bHGjm5nz/UXkAhWG4MhSlkTRt8Qhrr7Vr8rKAqbgHf3SMGh0a5UFzvDaGbSxBfzAt31Io46tsHUNe9479kJ95SKjseOD+yK4ML/J1XinddaTsJ/wwK4tVG/XlAcisJBo3nUGDQdxQqE5NRHQlYFBire0siSu0zR0Rb+CL6BNj9gbK7omYj+wPzYUbSLhR1aej/q7fNqWTmcamY6GrYuQ91uflvVWg58fya4jEk3ssNaZ5u9ib2sW88arVIQcjgGHusZXtVsymYgobl48QWU+M94l5fXe6UZ35NdkGPZ2XwYVMPPn+r2UhXSiGm70gVD09p9XYbDScZOSuC8NNudqE9P8OffNHU/91/IybNyJAeyT8RugBD8nApCGeZv0UDEgnkpFVU4dxcWVZqMOi027FxV2bRjPxDsrleGygfzmtHd6jAfAsqPdD3sTOr4LCT5wgmnBO+s
 20KbyMNS
 bEXH5revfor65FjxJYTSPvOlpawR9U/6sgSRsvhSZuBpJfZemXWOxZ4GNEYmFOpVhHMVwi6D1RWtV8fhExKbtYErBnUqzqH3WmAwtQu4qkHkGKINZlS8v3kesk6gsDqdS7bYdEe1CvCid6LiuTcE9Lta6W0EKQflR6uAoF2skYxT7/Uw+FGY84PScX8w4kJT/k0OxHtACjS4wzQcwvx1enkS9oxzWbyhD069C1Tj39AjgO1HCgxfibpxFrpurDAR/dYenpyxJpuCjruPDqBeiEE0i8Nyyybs/A9hTTMaePyFzx0Ja0+sUHNjAeHkQDFrzD+uuswy+hAFrPaLDMixc/xZRPqIJtDAPvbhN1pHgYQPOd2qwScEW3Y3/Qc2nx7nVDLsfx03OUa+T1RJvoCO79Hj/HFlEkEI8F/3I6K+8SxEBFJLqKCqWG4BOb9s6zRv07kZVCrWcuA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    b85966adbf5d Merge tag 'net-next-7.2' of git://git.kernel...
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15ffe3a1580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9a9f723a32776544
dashboard link: https://syzkaller.appspot.com/bug?extid=0635dc2e2c3c21a6aa04
compiler:       Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1192ccfe580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10dec2ae580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d65306d96573/disk-b85966ad.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ef43139aab0e/vmlinux-b85966ad.xz
kernel image: https://storage.googleapis.com/syzbot-assets/26d4d1ab67c3/bzImage-b85966ad.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0635dc2e2c3c21a6aa04@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	0-...!: (1 GPs behind) idle=8aec/1/0x4000000000000000 softirq=15232/15238 fqs=0
rcu: 	(detected by 1, t=10502 jiffies, g=12001, q=779 ncpus=2)
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 5691 Comm: udevd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
RIP: 0010:lock_release+0x2d3/0x3c0 kernel/locking/lockdep.c:5893
Code: 65 c7 05 2c 91 98 11 00 00 00 00 eb b5 e8 45 d1 05 0a f7 c3 00 02 00 00 74 b9 65 48 8b 05 45 4c 98 11 48 3b 44 24 28 75 44 fb <48> 83 c4 30 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc 48 8d
RSP: 0018:ffffc90000007c98 EFLAGS: 00000046
RAX: 2f357cb7f4202a00 RBX: ffff88803147f2a8 RCX: 0000000000010002
RDX: 0000000000010000 RSI: ffffffff8c291100 RDI: ffffffff8c2910c0
RBP: dffffc0000000000 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff52000000f90 R12: ffff8880611c6000
R13: ffffffff89b61a3a R14: ffff88803147f2c0 R15: ffff88803147f300
FS:  0000000000000000(0000) GS:ffff88812527c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000564961a89a38 CR3: 000000000e746000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 __raw_spin_unlock include/linux/spinlock_api_smp.h:167 [inline]
 _raw_spin_unlock+0x16/0x50 kernel/locking/spinlock.c:190
 spin_unlock include/linux/spinlock.h:390 [inline]
 advance_sched+0x99a/0xc80 net/sched/sch_taprio.c:988
 __run_hrtimer kernel/time/hrtimer.c:2032 [inline]
 __hrtimer_run_queues+0x3bc/0xa10 kernel/time/hrtimer.c:2096
 hrtimer_interrupt+0x448/0x910 kernel/time/hrtimer.c:2215
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1051 [inline]
 __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1068
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1062
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
RIP: 0010:__unwind_start+0x514/0x660 arch/x86/kernel/unwind_orc.c:-1
Code: 10 42 80 3c 28 00 4c 8d 7b 38 74 08 4c 89 ff e8 12 7a ba 00 48 8b 44 24 08 49 39 07 0f 87 b6 fb ff ff 48 89 df e8 cc d0 ff ff <48> 8b 04 24 42 0f b6 04 28 84 c0 75 11 83 3b 00 4c 89 f1 0f 85 5b
RSP: 0018:ffffc9000432f590 EFLAGS: 00000282
RAX: 00000000f218b401 RBX: ffffc9000432f5e8 RCX: 0000000080000001
RDX: ffffc9000432f601 RSI: ffffffff8c291100 RDI: ffff888034f03e00
RBP: 1ffff92000865ebf R08: ffffc9000432f5d8 R09: 0000000000000000
R10: ffffc9000432f638 R11: fffff52000865ec9 R12: 1ffff92000865ebe
R13: dffffc0000000000 R14: ffffc9000432f5f8 R15: ffffc9000432f620
 unwind_start arch/x86/include/asm/unwind.h:64 [inline]
 arch_stack_walk+0xe3/0x150 arch/x86/kernel/stacktrace.c:24
 stack_trace_save+0xa9/0x100 kernel/stacktrace.c:122
 kasan_save_stack+0x3e/0x60 mm/kasan/common.c:57
 kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
 __call_rcu_common kernel/rcu/tree.c:3159 [inline]
 call_rcu+0xee/0x8b0 kernel/rcu/tree.c:3279
 __destroy_inode+0x2a1/0x630 fs/inode.c:365
 destroy_inode fs/inode.c:388 [inline]
 evict+0x8d4/0xb50 fs/inode.c:852
 dentry_kill+0x1b9/0x880 fs/dcache.c:826
 finish_dput+0x1a/0x260 fs/dcache.c:1001
 __fput+0x675/0xa50 fs/file_table.c:520
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0x73a/0x2360 kernel/exit.c:1004
 do_group_exit+0x22d/0x2f0 kernel/exit.c:1147
 __do_sys_exit_group kernel/exit.c:1158 [inline]
 __se_sys_exit_group kernel/exit.c:1156 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1156
 x64_sys_call+0x221a/0x2240 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbd5bcf16c5
Code: Unable to access opcode bytes at 0x7fbd5bcf169b.
RSP: 002b:00007ffe420f4688 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000564961aa4f80 RCX: 00007fbd5bcf16c5
RDX: 00000000000000e7 RSI: fffffffffffffe68 RDI: 0000000000000000
RBP: 0000564961a80910 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe420f46d0 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
rcu: rcu_preempt kthread starved for 10502 jiffies! g12001 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=1
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:28040 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5504 [inline]
 __schedule+0x17d9/0x56c0 kernel/sched/core.c:7228
 __schedule_loop kernel/sched/core.c:7307 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7322
 schedule_timeout+0x152/0x2c0 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x30c/0x11f0 kernel/rcu/tree.c:2123
 rcu_gp_kthread+0x9e/0x2b0 kernel/rcu/tree.c:2325
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
CPU: 1 UID: 0 PID: 5689 Comm: udevd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
RIP: 0010:csd_lock_wait kernel/smp.c:342 [inline]
RIP: 0010:smp_call_function_many_cond+0x10b0/0x14b0 kernel/smp.c:892
Code: c0 75 73 41 8b 1e 89 de 83 e6 01 31 ff e8 98 02 0c 00 83 e3 01 48 bb 00 00 00 00 00 fc ff df 75 07 e8 44 fe 0b 00 eb 37 f3 90 <41> 0f b6 04 1c 84 c0 75 10 41 f7 06 01 00 00 00 74 1e e8 29 fe 0b
RSP: 0000:ffffc9000430f840 EFLAGS: 00000293
RAX: ffffffff81b9f7f7 RBX: dffffc0000000000 RCX: ffff88807f020000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc9000430f970 R08: ffffffff903116f7 R09: 1ffffffff20622de
R10: dffffc0000000000 R11: fffffbfff20622df R12: 1ffff110170c85c5
R13: ffff8880b873c2c8 R14: ffff8880b8642e28 R15: 0000000000000000
FS:  00007fbd5c388880(0000) GS:ffff88812537c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000564961a89a38 CR3: 0000000044280000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 on_each_cpu_cond_mask+0x3f/0x80 kernel/smp.c:1057
 __flush_tlb_multi arch/x86/include/asm/paravirt.h:46 [inline]
 flush_tlb_multi arch/x86/mm/tlb.c:1361 [inline]
 flush_tlb_mm_range+0x5c4/0x1090 arch/x86/mm/tlb.c:1451
 flush_tlb_page arch/x86/include/asm/tlbflush.h:345 [inline]
 ptep_clear_flush+0x120/0x170 mm/pgtable-generic.c:104
 wp_page_copy mm/memory.c:3941 [inline]
 do_wp_page+0x3d52/0x4c70 mm/memory.c:4336
 handle_pte_fault mm/memory.c:6443 [inline]
 __handle_mm_fault mm/memory.c:6565 [inline]
 handle_mm_fault+0x1490/0x3080 mm/memory.c:6734
 do_user_addr_fault+0xa4d/0x1340 arch/x86/mm/fault.c:1339
 handle_page_fault arch/x86/mm/fault.c:1479 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1532
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
RIP: 0033:0x7fbd5c3ada9a
Code: 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 53 48 85 ff 74 2f 48 8b 47 08 48 39 c7 74 21 48 8b 1f 48 39 df 74 19 48 89 18 <48> 89 43 08 e8 8d d9 ff ff 48 89 d8 5b c3 0f 1f 84 00 00 00 00 00
RSP: 002b:00007ffe420f4620 EFLAGS: 00010202
RAX: 0000564961a8a0b0 RBX: 0000564961a89a30 RCX: 0000000000000000
RDX: 0000564961a95430 RSI: 0000564961a91f60 RDI: 0000564961a8f4e0
RBP: 0000564961a8f4e0 R08: 0000564961a91f70 R09: 0000000000000003
R10: 0000000000000000 R11: 0000000000000297 R12: 0000564958c24588
R13: 00007ffe420f46d0 R14: 0000000000000000 R15: 0000000000000000
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

