Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EDFCE7545C
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 15:25:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DB6E6B0098; Wed, 24 Dec 2025 10:25:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B3126B0099; Wed, 24 Dec 2025 10:25:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B1D36B009B; Wed, 24 Dec 2025 10:25:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39DF76B0098
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 10:25:24 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EA13616030F
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 15:25:23 +0000 (UTC)
X-FDA: 84254738526.28.4C56ECB
Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	by imf02.hostedemail.com (Postfix) with ESMTP id 34CE280011
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 15:25:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf02.hostedemail.com: domain of 34QVMaQkbAG4eklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.78 as permitted sender) smtp.mailfrom=34QVMaQkbAG4eklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766589922; a=rsa-sha256;
	cv=none;
	b=Dvlubvs8hNk3rroYb4gJGUYqBmdWyfPhy69ahe5m8+dlCIRyK3vZ1XKPyezkRmbSj+p9od
	I5Ph0hOWjycC6RRw4redEKM/voz7L/7hpeu39+GT70Ajp95ERG9YFQHUY0vdrkLp/x6XWz
	AkHbEbg5fBibST12AXx7Q4u4MthuxRQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf02.hostedemail.com: domain of 34QVMaQkbAG4eklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.78 as permitted sender) smtp.mailfrom=34QVMaQkbAG4eklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766589922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=/ox8S7gTIUIUZSQcWC/phhJJaHgd9U81iBlsDZhBEfo=;
	b=HHtB2ZwG87bva8Ly3f7OlnczAWCgJmLo6sVY6vORVyAyc2t+P2O8/UuaAz77y78uym20jx
	3CrNVqnRpA7BqjsULckfkbFtk3K/4JqdKyWzgPMLrKc+rJ0VberAL2uZbxmJxO0kdXn12j
	mr7RnhK3wHVPYqqAIlrK0+1B0fLMFHE=
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-656b7cf5c66so9272057eaf.2
        for <linux-mm@kvack.org>; Wed, 24 Dec 2025 07:25:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766589921; x=1767194721;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/ox8S7gTIUIUZSQcWC/phhJJaHgd9U81iBlsDZhBEfo=;
        b=jZWpCMob8/ni+Y5vUglrVFjIQW42d15n/TIzcpaxukzlUGLzY412Cgu6JRoWa6nkoD
         SJj6XVPbliMb+uvwUcCtr9kHHW7/Yj/A95JrFRyag8NGmHsnb6P1pEexMqHtIsydImcp
         /SM46InfApYTyLre2oOGLHT6a9uyXtiSNHqEHopBNsn5KUf1+O06H8U/nhdsatvcifS4
         yXD8g0826dpt13q1Z9La9raOlPBz4+OcvQOMp9GMm8N5jLrP4iAbyF5K1aekv9nYtNxZ
         htPWjpIQ17avlxgu7FbzXLKMNBdqIqgmob3Zynj8j+bL2nYUtzc6XQeLA8t5mThWxcwd
         Uhcg==
X-Forwarded-Encrypted: i=1; AJvYcCXRs1+oSDz9idFAGUOmB0PlXHEReAdh++MTBZWF2PbBCtdGVP1jVnm8AM8SKIG5R59IeEMBoe5+Xw==@kvack.org
X-Gm-Message-State: AOJu0YxBt5UFBKVE8NZKiJscuJxk49bIzeQBtUWTlEH76m7Q1E5IUK4j
	kFfJuJiwKuJ22JqkCd2MLXW9mBQ3vSLunPQfux740tLmgYkT2PbpSHF8ADtxI/Kqhf8UWa9GVRG
	Ncadw8s9VKJbyPCjvNpI+y/e8LU4tnvpPa0UkgelyBCddyEkd3/46GcH6J98=
X-Google-Smtp-Source: AGHT+IGGJerQR6o7Ua4aZzUGyPp4T9WFTNphfH+6VcsBkSYTfxxDEPZAcHfKE1hEDPFgFSOME4c3klVwZXqczoYlksa7oizf5TUb
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c89:b0:65d:1bf8:bb74 with SMTP id
 006d021491bc7-65d1bf8bdd5mr6076402eaf.61.1766589921283; Wed, 24 Dec 2025
 07:25:21 -0800 (PST)
Date: Wed, 24 Dec 2025 07:25:21 -0800
In-Reply-To: <6948bf8c.050a0220.1b4e0c.0030.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <694c05e1.050a0220.35954c.001f.GAE@google.com>
Subject: Re: [syzbot] [tomoyo?] [mm?] INFO: rcu detected stall in sys_newfstat (4)
From: syzbot <syzbot+5fb7dcd004f42cb418d7@syzkaller.appspotmail.com>
To: jmorris@namei.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, paul@paul-moore.com, 
	penguin-kernel@I-love.SAKURA.ne.jp, penguin-kernel@i-love.sakura.ne.jp, 
	serge@hallyn.com, syzkaller-bugs@googlegroups.com, takedakn@nttdata.co.jp, 
	tomoyo-users_en-owner@lists.sourceforge.net, 
	tomoyo-users_en@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 34CE280011
X-Stat-Signature: z4ub59c1temqu3yp4jdtnk71zac1xbo7
X-HE-Tag: 1766589922-530843
X-HE-Meta: U2FsdGVkX19pYfJBBaPLP32r5zdA6mvc0g89vcP648rSKDcRNLZmlZiJaOG3W/89ebdwmu042FwrGRIMylfjPn6xVteQzdw0gb7zVMbinKTkGpa/Oy6iHPu3YNvGGVsLQm9vf9RU6MdGS7VO+cjVogi4Ww1PlRMXBhVM0zOxguSUk3FuE5W8zytIxnJRHBj+Wys6Z3NdE9yDjMnb/cnUU2SxFRNlS5JRcT41zQZeHj6L72tzRwIdgpNKkH3Y2+um9YqCcLYmZQ8+CclYKUVILzg824P6isbdJrEwJWbQG6Falu1rmt8G0Am/ftGtWIne23buRLHis06h/7DDSIyPKmZ3iLpAYoUnAWFeH8Byg3nE/XPzX3hl96Etu8ETZcJYDoRDOl1I2U9ITYuSr8I8F+rx7X4XOj60FRMXEFjLMNwpcIpDN80FXb50OgM7LpMaoxEzqF6dDyqqrRYARczuMy6JGAKA+AxmSyl/xxvcS3ug/ypeLTkxoCFNxUwZsU65oyYBmzS5ZiMzSwDxunTgoAbE+aavbgPaO4vm7av3gKlA2tRaFEsRPh54SPA4CVc7kmDpxlXzjos6mK3D7ezDc/KJnGWIxm7xsTf+A4RGjD0I3EnBKSvhNWW1g4tsHqv3vUnSyNat1PbkatLnxZ28q///A4BpTFJb8S6EfpFpJeTciitl0x7jJixe+V+Yb0Z/LDhRdsuNjSiUDeYNsQDlE2UpvPXTLvdTno83eW2kTX9eH5A0SJi64kf8UT1DG3XZFK3fqrAZWg9EWR6fm6XiliAUIINdvlT388GZlPW6PU/HkI1uMzWZ463wK0WGEKXPGstYArp3DyyUiP6mwOBQPOnECrHSrOoPNr+oB6qYAhq2IBjPTFLv9elQ24skmoNSI/DqyYs+4m269jDhQ5LqBzhsJqwZ3ugY2efgKgYVxbnHdbePvnLcW/OBzH8CbhYKYqbE4Bpp2AUUw25gJv3
 1rCIvkr9
 K/PeGMXC/L5sBb2BPAeif5Dn99vatIadcIQgT1L/JOq4+p5HTVNH1zRANRvi54tuoiuMTXj9YuBNhMz8b4gN8X6kZnhw80Tm/UPlMNN++G/GTNpmLBuYmE2vtoEmNLov5qH2UXl2gtfr7o3LWDfTrHAAmPDjZTAl04x8n/YmNx8PVw7X1BS5v8TxSa7lMUbUceSfD5e7yZyZzUHC0ykVRaI+O6h9WdmYs9Big8JAMV3zL6F1tRZk42qCXzfdwzMu4F8chyDH2mnOTIaPFaWaQwXJBJ1WlbSXw+F/4G/sr01AAos0OWE+7ReeVBC+frjf8tyEI5S7i1RUiO9IozJcwlcMLFO8UT6exWfoyxA66fdw66WtYHrRBXckEcsasAIRXg5SyF+kMMKzj8fc8cAAKLBxtU3H3vOAphhyUfumnqeSA01iE1TmWnRcOJ3/LOuvzx+RiyzHR+jY3JAHmM49YzDyupR6SXJiadstuYKDXyT2ZdaBFNLEA07I3vToLK3wBrdtWf1tU6eknflOqBK1onF4mb3f6/UWkFeAbGYwxsfsvSGU/3Lan1+FS+2EkkjcOxrl61rzja/gl92UEdcis3a01beRIN7tp3IquxHSr0bG0FJFBAjywZAmsMxXwhdH4I6nLp4DLKhmD+ikR95lDZsHjNb1NIopbtuqRJk6/3toQTcbfwZfNLy6oZVTPJRfnZMri/hOO9+KR94KcU+MEVdRjdpzWV9LqHYiqoCJkjXTqwVx3rvcU1PECoJJofddLweR6lmi8G35naFvJAkNmzi6JN9uXsy4MIeF/e7GJ7npbVXdyr9XolRW2K8soFoKcBziz36EyZs9Qz044OpjHMTwjzThfFrPsyp1zI2ogXm1KfQs81NGZl02S/5RY9mt06VA1IOSzzbnPBiGzngDIwkWkh5yh9no6hviYLtzUXmGKA60M/alGXHus0CWD33mk7mOppWQUhW28GGcDzciiaaLkFLr3
 z3a5MtS/
 00YaXOnAkpNJJvOqVzXQKVNa4fOo9p/fSOHN0Mh+pUOSAVxObrj1lWDWJr3nLairJ2u3SUnIQ1d07ibJYlwQtASC01PLIObSOpQPsUbSO2sTixscbBuT4soU3nqcC2m3yf98KEi51YCFKVMZjkiVOLbvVkp2oksrC3cW/G8RVtofsmPmTOVSMUnOiXEhULus7gdy+bBWTHW7YeE385mHAtS1TuJ3136Nu4HGT1uN9zvkYqJBkdOtepfyCyOqabFSunouAMX5lMQIN57Ls/Kli8m++zwWwmH+gnm/osfRmxTPJtbWjWkHPT81X1qapUoBF3PLcvNfiXW13lFlUtID4NqiWnPJClp6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    cc3aa43b44bd Add linux-next specific files for 20251219
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12ee209a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=da1bc82c6189c463
dashboard link: https://syzkaller.appspot.com/bug?extid=5fb7dcd004f42cb418d7
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=148ccf1a580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10af90fc580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/30bf539e6f28/disk-cc3aa43b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0e2f8b08e342/vmlinux-cc3aa43b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ec7ee6ece11f/bzImage-cc3aa43b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5fb7dcd004f42cb418d7@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P5874/1:b..l P5857/1:b..l
rcu: 	(detected by 1, t=10502 jiffies, g=11205, q=25 ncpus=2)
task:udevd           state:R  running task     stack:25240 pid:5857  tgid:5857  ppid:5198   task_flags:0x400140 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5258 [inline]
 __schedule+0x150e/0x5070 kernel/sched/core.c:6866
 preempt_schedule_irq+0xb5/0x150 kernel/sched/core.c:7193
 irqentry_exit+0x5d8/0x660 kernel/entry/common.c:216
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:debug_lockdep_rcu_enabled+0xf/0x40 kernel/rcu/update.c:320
Code: 48 0f b9 3a 90 eb ca cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 31 c0 83 3d 17 78 44 04 00 74 1e <83> 3d 2a a7 44 04 00 74 15 65 48 8b 0c 25 08 b0 9f 92 31 c0 83 b9
RSP: 0018:ffffc9000425f510 EFLAGS: 00000202
RAX: 0000000000000000 RBX: ffffffff8228283e RCX: f504a25577f97f00
RDX: 00000000c1e3b5cc RSI: ffffffff8db7ed49 RDI: ffffffff8be07960
RBP: dffffc0000000000 R08: ffffffff81742f85 R09: ffffffff8e13f2e0
R10: ffffc9000425f638 R11: ffffffff81ad9d50 R12: 1ffff9200084bebd
R13: ffffc9000425f620 R14: ffffc9000425f5e8 R15: ffffffff81742f85
 rcu_read_lock include/linux/rcupdate.h:868 [inline]
 class_rcu_constructor include/linux/rcupdate.h:1195 [inline]
 unwind_next_frame+0xcb/0x23d0 arch/x86/kernel/unwind_orc.c:495
 arch_stack_walk+0x11c/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x9c/0xe0 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5661 [inline]
 __kmalloc_noprof+0x41d/0x800 mm/slub.c:5673
 kmalloc_noprof include/linux/slab.h:961 [inline]
 kzalloc_noprof include/linux/slab.h:1094 [inline]
 tomoyo_encode2 security/tomoyo/realpath.c:45 [inline]
 tomoyo_encode+0x28b/0x550 security/tomoyo/realpath.c:80
 tomoyo_realpath_from_path+0x58d/0x5d0 security/tomoyo/realpath.c:283
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x213/0x4b0 security/tomoyo/file.c:822
 security_inode_getattr+0x12f/0x330 security/security.c:1869
 vfs_getattr fs/stat.c:259 [inline]
 vfs_fstat fs/stat.c:281 [inline]
 __do_sys_newfstat fs/stat.c:555 [inline]
 __se_sys_newfstat fs/stat.c:550 [inline]
 __x64_sys_newfstat+0xfc/0x200 fs/stat.c:550
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2f2b711ad7
RSP: 002b:00007ffeeebbb7b8 EFLAGS: 00000297 ORIG_RAX: 0000000000000005
RAX: ffffffffffffffda RBX: 0000564ba16cb8a0 RCX: 00007f2f2b711ad7
RDX: 00007f2f2b7efea0 RSI: 00007ffeeebbb7c0 RDI: 0000000000000008
RBP: 00007f2f2b7efff0 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000297 R12: 000000000000000a
R13: 0000000000003fff R14: 0000000000000000 R15: 0000564ba16cb8a0
 </TASK>
task:syz-executor360 state:R  running task     stack:25816 pid:5874  tgid:5867  ppid:5855   task_flags:0x400040 flags:0x00080800
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5258 [inline]
 __schedule+0x150e/0x5070 kernel/sched/core.c:6866
 preempt_schedule_irq+0xb5/0x150 kernel/sched/core.c:7193
 irqentry_exit+0x5d8/0x660 kernel/entry/common.c:216
 asm_sysvec_reschedule_ipi+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:unwind_next_frame+0x18cc/0x23d0 arch/x86/kernel/unwind_orc.c:-1
Code: 30 0a 00 00 4c 89 e8 48 c1 e8 03 0f b6 04 28 84 c0 0f 85 43 0a 00 00 49 0f bf 04 24 48 01 c6 4c 89 f7 48 89 da e8 84 0d 00 00 <84> c0 0f 84 47 01 00 00 48 bd 00 00 00 00 00 fc ff df 48 8b 44 24
RSP: 0018:ffffc9000436f2b8 EFLAGS: 00000282
RAX: 1ffff9200086de01 RBX: ffffffff90315ccc RCX: 0000000000000001
RDX: ffffc9000436f3c8 RSI: dffffc0000000000 RDI: ffffc9000436f978
RBP: dffffc0000000000 R08: ffffc9000436f978 R09: 0000000000000000
R10: ffffc9000436f3d8 R11: fffff5200086de7d R12: ffffc9000436f3d8
R13: 1ffff9200086de73 R14: ffffc9000436f388 R15: 1ffffffff2062b99
 arch_stack_walk+0x11c/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x9c/0xe0 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 unpoison_slab_object mm/kasan/common.c:340 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4953 [inline]
 slab_alloc_node mm/slub.c:5267 [inline]
 kmem_cache_alloc_lru_noprof+0x36c/0x6e0 mm/slub.c:5286
 alloc_inode+0x6a/0x1b0 fs/inode.c:346
 new_inode+0x22/0x170 fs/inode.c:1175
 debugfs_get_inode fs/debugfs/inode.c:72 [inline]
 __debugfs_create_file+0xb8/0x400 fs/debugfs/inode.c:433
 debugfs_create_file_full+0x3f/0x60 fs/debugfs/inode.c:460
 kvm_arch_create_vcpu_debugfs+0x41/0x160 arch/x86/kvm/debugfs.c:61
 kvm_create_vcpu_debugfs+0x138/0x1a0 virt/kvm/kvm_main.c:4167
 kvm_vm_ioctl_create_vcpu+0x62a/0x930 virt/kvm/kvm_main.c:4271
 kvm_vm_ioctl+0x7f7/0xc60 virt/kvm/kvm_main.c:5180
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa7ebb76d89
RSP: 002b:00007fa7ebb05218 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fa7ebbfb3f8 RCX: 00007fa7ebb76d89
RDX: 0000000000000000 RSI: 000000000000ae41 RDI: 0000000000000004
RBP: 00007fa7ebbfb3f0 R08: 00007ffddfa031f7 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fa7ebbc72e4
R13: 0000200000000000 R14: 0000200000000140 R15: 0000200000000040
 </TASK>
rcu: rcu_preempt kthread starved for 10587 jiffies! g11205 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:26264 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5258 [inline]
 __schedule+0x150e/0x5070 kernel/sched/core.c:6866
 __schedule_loop kernel/sched/core.c:6948 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6963
 schedule_timeout+0x12b/0x270 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x301/0x1540 kernel/rcu/tree.c:2083
 rcu_gp_kthread+0x99/0x390 kernel/rcu/tree.c:2285
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:pv_native_safe_halt+0x13/0x20 arch/x86/kernel/paravirt.c:82
Code: cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 66 90 0f 00 2d 33 9e 2a 00 f3 0f 1e fa fb f4 <e9> 48 ee 02 00 cc cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffffff8de07d80 EFLAGS: 000002c6
RAX: e8fee117958a6b00 RBX: ffffffff819786ba RCX: e8fee117958a6b00
RDX: 0000000000000001 RSI: ffffffff8d997e54 RDI: ffffffff8be07960
RBP: ffffffff8de07ea8 R08: ffff8880b86336db R09: 1ffff110170c66db
R10: dffffc0000000000 R11: ffffed10170c66dc R12: ffffffff8fa22f70
R13: 1ffffffff1bd29b8 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff888125c25000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa7ebb2da90 CR3: 0000000074c04000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 arch_safe_halt arch/x86/include/asm/paravirt.h:107 [inline]
 default_idle+0x13/0x20 arch/x86/kernel/process.c:767
 default_idle_call+0x73/0xb0 kernel/sched/idle.c:122
 cpuidle_idle_call kernel/sched/idle.c:191 [inline]
 do_idle+0x1ea/0x520 kernel/sched/idle.c:332
 cpu_startup_entry+0x44/0x60 kernel/sched/idle.c:430
 rest_init+0x2de/0x300 init/main.c:758
 start_kernel+0x3ac/0x400 init/main.c:1208
 x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
 x86_64_start_kernel+0x143/0x1c0 arch/x86/kernel/head64.c:291
 common_startup_64+0x13e/0x147
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

