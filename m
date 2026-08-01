Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3328CC55171
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 00:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12F486B0088; Fri, 31 Jul 2026 20:24:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E12F6B008A; Fri, 31 Jul 2026 20:24:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F39236B008C; Fri, 31 Jul 2026 20:24:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB5CF6B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:24:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 635DF1C01F9
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 00:24:32 +0000 (UTC)
X-FDA: 85050804384.20.1549B37
Received: from mail-oi1-f206.google.com (mail-oi1-f206.google.com [209.85.167.206])
	by imf06.hostedemail.com (Postfix) with ESMTP id C20BE180007
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 00:24:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of 3vTxtagkbAEY067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.206 as permitted sender) smtp.mailfrom=3vTxtagkbAEY067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785543870;
	b=Kp2circ1kUVF2HJtRMvtn/xDGIdtzuwX659LcH8L6RARbifHwhuHo2ZIHsdf29gyRHgxpw
	2s+UJDZ0PqwO/cCBJh+COIkVqM34v99xspymJPfiZ5veP7F5WeutWtwo5OQ0o0ECL6+gcc
	dvgOvAZqm8loqZ+LmSXJBA/DReLDkU4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of 3vTxtagkbAEY067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.206 as permitted sender) smtp.mailfrom=3vTxtagkbAEY067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785543870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=qVd58TPnt7YWORxKDPFmEH4Zsye0rPYQgz8PIgkDcCw=;
	b=LEZOrjXcGreY6pbgUKhLOpvE4EFvkhRyjQ1/rsRxIaMkXffqekVxE7yD3ggzlOmrAu64+n
	swnRX4kT8dvKAnFNkke9Q0UifONYHxeC/kgy4rLW74Ta580cibCsbesDfS5B6nACPtwmB5
	eYepcxbmawWyI8YyIUVmpaF9g+8zLQY=
Received: by mail-oi1-f206.google.com with SMTP id 5614622812f47-4a485034d01so2322983b6e.3
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:24:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785543870; x=1786148670;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qVd58TPnt7YWORxKDPFmEH4Zsye0rPYQgz8PIgkDcCw=;
        b=m86JSY53MI+VD3+b6P2ryU1ZH0Y6t0xbkbdjbdc9hdjfjTPlA6bCHDSCl5a41oGX0B
         nCb+KVmTbrlCry9WThWFbTO+jr3dsvgGMTxm7R6pd3XU8i/Dxy064qsZQNBCQfqFXtAp
         Za0znMwTlQXo9EkG3RWfU708W9AU8x+mvfCL95V378Z01Q5h5GldM/8WksgQhRcrcplJ
         G8HXUaLdhDL0VOF2p6blS6ZTKbBTawMpLSEGhzZliulzKz6dLDogO6XVmWGcpdm5eO7W
         cn3VmMfGdKF8Lw1UpAV4z0Jr4RFSeGkYauJCEkt6veizQJdFTxxiBejIDnZDddqY8BwN
         Q5yw==
X-Forwarded-Encrypted: i=1; AHgh+RonLiCiUL2fCmWNwTgwghVjIzx7648d8NtvG+zkUizqjE7qPuMnvDoVqf4zTF7DZRVw2EmPUVYAqg==@kvack.org
X-Gm-Message-State: AOJu0YzU4b/YrOsYcCFEuLs2ZftRh/98iepxGSJ+qIJHtLODgzTUEBZw
	D14Czw+iBUSM4nCTcubMHpD7sS2krdWrVQIsEvrVJZ6LxWEBDvKNrKXHXC+BblyRPl8zM+kupk7
	JJsvYipfDXVBKnemwodPISh9aZdGM9BNRyBYOMgnFGB/gl/iFqGUudxePZHo=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:d52:b0:497:deab:2bfe with SMTP id
 5614622812f47-4af5dfb3c0dmr3861203b6e.1.1785543869869; Fri, 31 Jul 2026
 17:24:29 -0700 (PDT)
Date: Fri, 31 Jul 2026 17:24:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a6d3cbd.6ce73036.24301b.000e.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in va_alloc
From: syzbot <syzbot+61c997e6be1d9bb300ba@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, bsegall@google.com, david@kernel.org, 
	dietmar.eggemann@arm.com, juri.lelli@redhat.com, kees@kernel.org, 
	kprateek.nayak@amd.com, liam@infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, mgorman@suse.de, mhocko@suse.com, 
	mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org, rppt@kernel.org, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@kernel.org, 
	vincent.guittot@linaro.org, vschneid@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C20BE180007
X-Stat-Signature: ser4mtome4ragicf8rs4jhfzxu453woa
X-Rspam-User: 
X-HE-Tag: 1785543870-789466
X-HE-Meta: U2FsdGVkX1+ub4iq2Kci39o6DLnMbOqG33S7BG9FTCltXrmpstxtW7ToaveTXV8tsfPE1eheRnaYxXVxbYF5ZvmForygTe/1UlbUD4HLkC7DdzMyQD3vJuSCzMbX2xiLWJoiEvT0VJDFzC74vgefu5LiWkLnM57YWSJmqaEcT8QlkWKUc+t2PGBJV2ILbNVr96tmEmNPV/f5QiF8ASIrHVGvWW0x3iR4yeFthinGF1N9lOtC+vtsjMiVOyLB4GYRX0zh43fME2t4/Ea/zBCQijrO78S/ZU3SYT2a7GDLr/AsEa0zNMsXYqmZjxlK8E+VBiN/AuIn7OSZTGSKsmgxYY3s62PV6V4CcaMJlC5X/wFc+2oD6pREWhpV5Aza2Wsw3K2Nwkd/CiaALwbEIIc0sGM8WWd1WhWGmxMW5ytEEq5YTYeH5rFyWTIRYlmLGnKbKgrVYjot1ePpJyo4NrwYEqy0IyXFh0PuTNLYWKOlhHGtv4Ef3c3sZQ+Inv2NYddAj7cHGeOjnHYMVMGWrzaKLCexAuNeqiPVqDi64pgzZKaiEfcB1iOvYsXapvI4O+Z5XXreqakAbB4OC6CwVC1iZ0rbwafQEQClkfujtzbQ3/MDVZ/diuEhjqkweeUJHpqPCOfQ9Sk86flIHXvmTprwyWMv4XbuvHtiKZ3q1uh1IQ/OppkJgbhuj9en9AEpCt3lsJiIjS2HxjUvhrrzESL+xTd5VkjGDGz+mgwEWdiR/YSXiIHH25I1T8K1vf2cJHYtpOhA6iqlzs4o71+BorB2dmcgkCOIAIXfwmrIbSwHY3IxzPBa6ZdpVwAm/dXL+tfSXJh9xYamnTW2qA8huAVHWtUOzcuKhIx+zUMIVTw3O1fMpgUkyTmOhdBfT4ZhwhP02ZZj7xb1QjSv2THmmB4w3SGw/dMUZGzXax/PlCj2xAmYYfJotbsQfqHnqFJ4Cowy9qi1fkVt+HfCBybbBc8
 JGcWQ4/a
 mlYtyGksPI5nayzDbbUfCQF/A5W3x9fJyOQtC73XhnZcP+zlffKW62BUgDADjnwGSR+n3ZoA174eyDcKdm4+UIik8VgQjnn+3frcYR7XCJ+/4Xwcf0iz4CTvEeebFngQDhNTlNhik6EgnnmuauogvB6lf0bxZxpclZqUJxhHuuBXmuR2MC4+F1Se0Ru88dNBf5QeIEbbZKrxcO81ZKio3/d58UCDAYAARKGS57gYrsmPitP7gXd2G9D6+VXMG8aAWXFMMJdcc00Tq6nyi/m2q3EUxeiiAiK6qkIrvJWx8NbLR+s9v6uxEwgABTN50MVriwoDvgFFGJtOgcF+RwPDMd+2vEffe/IBa3phDOlcdcguwtg/8ymSQipTRkvttzSgUGPcB7LvteXdgGb7e8d7kqrQoKlBUe+L74FPego1nDc+SbQpAuAYqg0mmcK1ih5K5Hjy9zbCR9h2lPbn2CrPj3qU/enuoC7KpFAy3+man11nZjnVUkh7JUSFtim9W4fOtlzmV63OnLjyRWsP7AXq7llxUaM54oMukghEXHH5bHLoZSfII8NDrCr4e8E07CQCxiUtfJQEfswIlmCr/dlhQy68jkEZKxFEyUErdv4Hn56YHjJskJF7MMe5jSyQyIulE6TTv4AoJwmA3y7EqfHdKiAmenG3yXu7w2gYMWyeJuZIlBw9nzPvbeQq9wnrJe0NQXUTG2Z/GwbW+wkt3NQBg+E5ry2i0ayWFfw9ecILTUOEjbvQW5+6mWlS/ckodMmKwuuxxcdIbvsnkh4T2kJGLc+K7UknVbWa8nm7l8xICCXa7/3ClaYwCTPoOhOKbvVD+kKE0k/KBPwyjUJv5S/v0xSBA0MWRup9M5YvU6ve0BIcZbbQnc88+y5QsYxpfeUFPljRTllYO4ImvM05HecNhKpGmBITKXZAvDdv3hRWCESqzkxfJ0jtBKaVYJKMk/KnmLWTuE8kCsJssBW8cvr8/Yl6X+TMz
 +nCxKthW
 WfJ0C3CUQhGqoF28lxyu1vrsZLp08wvBxApqfJ14WBl1f7ap/GJ0g/qoJlqt5YOHMhUZhbs6CDD4O60zJyN+t8jik7i4xUzJO2kLl9b1F6GJO0r++CQcxucxbcDhAtUIBH8WRSAiBtSdvfv5yKyLvZHoGk9/H73Sml2Voh3VbyJb7U3iMBES7Xyr75oY5XjOPaZM6siyAKh0XklWXHBopf79wXKU/x9zA/eDrl5cj7gXbYFBJDbQwyCtcx6K4P7q6hRSvn+0ShTWm07p1Ek0z8rAq8q96v0SsDYRFCXWYrn4XYyJUzmcZGpAI7ale6iqKX0V15XpapcQ6Kv3elshLTGBL7UU6f/ZoSQbARQsjl20T9xx16cD74w/QVLQOh7yUr2V4nG/dxCcX7ikRBhkLUAMzftJCaRJDXkloyvzIu4nfM8kZZHiiccK189sjrQF8WxDcAA1Dl18uvZH9tsofA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    11028ab62899 Merge tag 'probes-fixes-v7.2-rc5' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16efd632580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c05be6c9b0d36cb9
dashboard link: https://syzkaller.appspot.com/bug?extid=61c997e6be1d9bb300ba
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-11028ab6.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/511647651d7f/vmlinux-11028ab6.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1c76180d0109/bzImage-11028ab6.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+61c997e6be1d9bb300ba@syzkaller.appspotmail.com

FAULT_INJECTION: forcing a failure.
name failslab, interval 1, probability 1, space 0, times 977
CPU: 0 UID: 0 PID: 5320 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 fail_dump lib/fault-inject.c:73 [inline]
 should_fail_ex+0x40c/0x560 lib/fault-inject.c:174
 should_failslab+0xa8/0x100 mm/failslab.c:46
 slab_pre_alloc_hook mm/slub.c:4539 [inline]
 slab_alloc_node mm/slub.c:4897 [inline]
 kmem_cache_alloc_node_noprof+0xb3/0x610 mm/slub.c:4989
 preload_this_cpu_lock+0x49/0xc0 mm/vmalloc.c:1902
 alloc_vmap_area+0x3c3/0x1420 mm/vmalloc.c:2072
 __get_vm_area_node+0x1f2/0x300 mm/vmalloc.c:3226
 __vmalloc_node_range_noprof+0x358/0x1730 mm/vmalloc.c:4042
 __vmalloc_node_noprof+0xc2/0x100 mm/vmalloc.c:4143
 alloc_thread_stack_node kernel/fork.c:359 [inline]
 dup_task_struct+0x2a0/0x8e0 kernel/fork.c:929
 copy_process+0x820/0x4390 kernel/fork.c:2115
 kernel_clone+0x2d7/0x940 kernel/fork.c:2748
 __do_sys_clone3 kernel/fork.c:3050 [inline]
 __se_sys_clone3+0x33c/0x360 kernel/fork.c:3029
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9d8f39ed89
Code: 90 b8 01 00 00 00 b9 01 00 00 00 eb ec 0f 1f 40 00 b8 ea ff ff ff 48 85 ff 74 28 48 85 d2 74 23 49 89 c8 b8 b3 01 00 00 0f 05 <48> 85 c0 7c 14 74 01 c3 31 ed 4c 89 c7 ff d2 48 89 c7 b8 3c 00 00
RSP: 002b:00007fffcf746358 EFLAGS: 00000202 ORIG_RAX: 00000000000001b3
RAX: ffffffffffffffda RBX: 00007f9d8f35a320 RCX: 00007f9d8f39ed89
RDX: 00007f9d8f35a320 RSI: 0000000000000058 RDI: 00007fffcf7463b0
RBP: 00007f9d902776c0 R08: 00007f9d902776c0 R09: 00007fffcf746497
R10: 0000000000000008 R11: 0000000000000202 R12: ffffffffffffffe8
R13: 000000000000006e R14: 00007fffcf7463b0 R15: 00007fffcf746498
 </TASK>
------------[ cut here ]------------
ret
WARNING: mm/vmalloc.c:1820 at va_alloc+0xeb/0xec0 mm/vmalloc.c:1820, CPU#0: syz.0.0/5320
Modules linked in:
CPU: 0 UID: 0 PID: 5320 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:va_alloc+0xeb/0xec0 mm/vmalloc.c:1820
Code: 08 4c 89 ef e8 16 98 10 00 4d 8b 7d 00 48 89 df 4c 89 fe e8 97 69 a1 ff 4c 39 fb 76 27 e8 2d 67 a1 ff 49 c7 c6 ea ff ff ff 90 <0f> 0b 90 4c 89 f0 48 83 c4 58 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc
RSP: 0018:ffffc9000f5e74b0 EFLAGS: 00010293
RAX: ffffffff8225caea RBX: ffffc9000f679000 RCX: ffff88801fae2540
RDX: 0000000000000000 RSI: ffffffff8c4bed60 RDI: ffffffff8c4bed20
RBP: ffff88803f07ef08 R08: 00000000ffffffff R09: 1ffffffff1d94962
R10: dffffc0000000000 R11: fffffbfff1d94963 R12: 1ffff11007e0fde1
R13: ffffc9000f670000 R14: fffffffffffffff4 R15: 0000000000000000
FS:  000055557c363540(0000) GS:ffff88808c543000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9d90277d58 CR3: 0000000012236000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __alloc_vmap_area mm/vmalloc.c:1855 [inline]
 alloc_vmap_area+0x907/0x1420 mm/vmalloc.c:2073
 __get_vm_area_node+0x1f2/0x300 mm/vmalloc.c:3226
 __vmalloc_node_range_noprof+0x358/0x1730 mm/vmalloc.c:4042
 __vmalloc_node_noprof+0xc2/0x100 mm/vmalloc.c:4143
 alloc_thread_stack_node kernel/fork.c:359 [inline]
 dup_task_struct+0x2a0/0x8e0 kernel/fork.c:929
 copy_process+0x820/0x4390 kernel/fork.c:2115
 kernel_clone+0x2d7/0x940 kernel/fork.c:2748
 __do_sys_clone3 kernel/fork.c:3050 [inline]
 __se_sys_clone3+0x33c/0x360 kernel/fork.c:3029
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9d8f39ed89
Code: 90 b8 01 00 00 00 b9 01 00 00 00 eb ec 0f 1f 40 00 b8 ea ff ff ff 48 85 ff 74 28 48 85 d2 74 23 49 89 c8 b8 b3 01 00 00 0f 05 <48> 85 c0 7c 14 74 01 c3 31 ed 4c 89 c7 ff d2 48 89 c7 b8 3c 00 00
RSP: 002b:00007fffcf746358 EFLAGS: 00000202 ORIG_RAX: 00000000000001b3
RAX: ffffffffffffffda RBX: 00007f9d8f35a320 RCX: 00007f9d8f39ed89
RDX: 00007f9d8f35a320 RSI: 0000000000000058 RDI: 00007fffcf7463b0
RBP: 00007f9d902776c0 R08: 00007f9d902776c0 R09: 00007fffcf746497
R10: 0000000000000008 R11: 0000000000000202 R12: ffffffffffffffe8
R13: 000000000000006e R14: 00007fffcf7463b0 R15: 00007fffcf746498
 </TASK>


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

