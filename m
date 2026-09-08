Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05A51C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 01:21:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 777926B008A; Mon,  7 Sep 2026 21:21:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 728526B008C; Mon,  7 Sep 2026 21:21:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63E126B0092; Mon,  7 Sep 2026 21:21:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 30C546B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:21:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 90563120341
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 01:21:27 +0000 (UTC)
X-FDA: 85188842214.02.EAE5785
Received: from mail-oo2-f11.google.com (mail-oo2-f11.google.com [74.125.231.139])
	by imf05.hostedemail.com (Postfix) with ESMTP id 02A5B100006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 01:21:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of 3FWOfagkbALQmsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.139 as permitted sender) smtp.mailfrom=3FWOfagkbALQmsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788830486;
	b=uTfNduNmBemHEXj10/hOaf8p5MLxr/c1HarYuoccPLHWwsox/vRrcCneyFpCrImmzAtX8P
	zwRpnrCFRWCcK8zgbpZfXWc7wK+Isj166ruddyvSOD2aRk1wNY7Y1brSuBoe3G+E2Qi8uG
	cm4AKvqlplmJBlno15B+bpsLX64iiyU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of 3FWOfagkbALQmsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.139 as permitted sender) smtp.mailfrom=3FWOfagkbALQmsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788830486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=/QSud1Qdfk+ScoqbW7iGZusn2n1W3X5f04d+3HD3u1I=;
	b=vhBzUc4X4XAxlWXE3uRnl0gwRs8XZSwbL9MdNJujGuyStB+EtHwI/ukZeWV/XrZiXu9uyD
	Dii246/KUmevoPSKW8Hyo7zXHrGXqgThzky/UCi87biNsHCVs0hzO9EYb4H4pfIIg+ObUA
	sgmxAh3fiMNT7m+zhhXEkxnMwhkTcrM=
Received: by mail-oo2-f11.google.com with SMTP id 006d021491bc7-6aaf6076546so2141624eaf.1
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 18:21:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788830485; x=1789435285;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/QSud1Qdfk+ScoqbW7iGZusn2n1W3X5f04d+3HD3u1I=;
        b=W1hQHQGuan41XI7XwZfleOOD9V6cS6fAQAijKH9ZZh8sIoW5fquwb7L3OjtsUqj/d3
         MzazkDdBeH6v+4/3wszuYkSSMnn5IRNwTNi6948/+xAHtCNphP+WpsdlK+o/risv4NAV
         KVGLx+5MqX1LeIf92Db9LGvKPzDEJUfHwkmCoJZZvblYS688v/0a7tJTT6GD6aq4S3r9
         tUg74md9G6M0mRM7alnjd1swKPVMumhIlrupr0wwZQUpdIoHGU+88Gy4dDoYJ/MiOqSB
         bNHP0Q7GOcRl6twhcfzU78w4j94wHecyvFTKdMXRv0vBjCn1uTbDoLb8k77JARTB9KJq
         ALwg==
X-Forwarded-Encrypted: i=1; AKwUvBzjTgWrkPARIRRrKDbmlMd2uhXr9MOnbGqfJYRHwMNoOsfnU3Pgu/mPnis25OaqEO7WIlYMitkOJQ==@kvack.org
X-Gm-Message-State: AFuF++laGExrOst2iKjlldwYAEgRWjWAT0TbvEC7t0k9ACr7Rhq6FutL
	MAiXcBCEgmXqEYrKK9fna/OFzfui7wx/h0kRFwk6cSSRcbeDmMIDb6/27deh/1++dSi6YBEUfLn
	6A/buUB4wJdN80ScDFAV5cNVRtBSfoclzOR8x5gHPF0UjMcHGMQGQspOE1fM=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:624:b0:6b8:ef7d:e181 with SMTP id
 006d021491bc7-6b8ef7de33cmr8964649eaf.54.1788830485042; Mon, 07 Sep 2026
 18:21:25 -0700 (PDT)
Date: Mon, 07 Sep 2026 18:21:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a9f6315.6e6c5f9e.28f11f.0002.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in vma_add_pgoff
From: syzbot <syzbot+c6879dc677a017f0a21b@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, jannh@google.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	pfalcato@suse.de, syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 02A5B100006
X-Stat-Signature: u4ypjxszba1pyogckwbqx63d7xqhha8i
X-HE-Tag: 1788830485-860969
X-HE-Meta: U2FsdGVkX18q9NlKnznDGsO9f3erbTKXoL+msGAADj8Tai7TwSVYboPZzGLF4Evh53tVoVDVqsnj2P8CSqMtbxxv7LH4UkA7v8qtpt7mpp47CixknJZYY2pVyt9diRCIMSYN+pgUnnQC1D2jRfeC16AZgeOLQGoptrpo9EwmbHmtpNlLXH9FgVx5n7mtNl0VKPiJS760ODr2FIcI3aJtKbSs1LZZpxDZxAJ9yxajBE3JHpNLWR02PHwwesJnBErvfimz7WXhXL5IHfnFSDBaHrYBEVslpCtB85KKIwZitK18n2pBZVT55htjrPmQerfcya9KgjC7W6HNdZCdhZwgtb/E6xw1kqtkH1odfreNQXtcVLTgPZ+4Z6W3FbVYkmnl4SKVqHOxZiNuOABLpiQbjeaB5WiCAVnu2dnxNRqiVcGi9lDBPYeqPU2JKyhM7YgaANiHKVSEVuEkzVoHxXgQIaRqRdpBewzNi4RIXp/z+AGSL5uvRpoqyMHvyLwV38QqDriR0cOBrXZZBDwSIHurC23Xu5VBQudz3riVcA859KdRBq5bwRmaoM/+Os2EL/5gxjutatHLs5PTKGxwv1BSbErznlQDCJdVBbEGAuD8snm4zsTcIqn6v0doP6QvsRSO5TcreRWbMEFxiNrJjZB7gBBurCgj5qFGg3iL4yHXnRcoKUKfxNqqQwphvz0/NvRC0dgfHIXV7uHCHotfJNtKDxK+svegg+2tTyfJ5cityLjF/hIB925r7i35WNexx21xYFDyFg9ELogWtzmjRAFFD7QGG7bfgQEa4rDKVDIfl+4rxBYqyssEzF6An6wMwD2nxlefWGMLiPv6x+nhRWTsbzemfGZIiKynxHev39Bng438jQcHP48JcAwZfEmyHoWhC/Hq7v3PToSuCAy+yIX28/j0eRFyorjdDZcAN9o54qnpptS9rmUCpSLQTM6kL5b74f0kWCTyyxQQ/qVUTp6
 62YWqvq6
 YX01adxwxF3aQBc2SS+8Qs8DXPHpNL3eGuHa/DmpxTpaME5KWh0Ptnz9rQ+r7PfTQX0ocj3HyiOBJsU5UsjAKy4Ns4MhZHCvQtIo6cJteDuqryHw5CpM2m7Zj0+T5npjqA99CHnOEJVNcVKCsDh9y0ZI0NcRwEiOclIbtVcsIpf//5e5zGLRzJpM7Yyx2/S9g33BrM/cpVJejOGDhAzg/4xAnRSslfSMQ3lVKfZcKYr3nvJbdcekEz6YU13PqbjS7hKULwC4j6lPsngynD+BZ126VrZc2bvM8PdeIxTOBWYBftZQczFiMv+s/TviZaUZTps8OJQux21fGJrXrLDe8UtJcW7LxR7EkU4YTkXO0jUJH7lY7S5taCHiC4TQogOd4JnBBa2LgGuJMx7u+hzTeS6cyIQQSjw51EHWW4PZ0CCVoxxtwWkwicDkX+YlJCvo4L7e/+ajge43IlRH42B9qrP869a/E+5mYenAmWcI5Dr/oYm++SdiQYctXp44PmaP3A/a6vB4rVIjfhQdWJ7VhWCknAqf44xL/cGNDhbnjJ6C/akOJwcikfciQrsYzf1Dq5GowFcfopyoYQEIdiRIFSv5Qvir7akSVqIqh8bfXMiJoyUTgtojvAAlDghhh0iMNOahdlkGiUVMhY6EHLX5VUsmEFUj2YbmIx3+lYisnK8xpenkXdvRFdv8OJWxyb8anpNYp+B9/75fJMxuX1FTTAvRMGM77viBYhonCN1lQAlytSTTh1DmZre+0ruBV11EqRsrB3E55eGruN/sMhgG/yy4K0F8sIwJCl1LiWEq4c+wA5a5wX9j2a2+jMr2mBEkLkE+hm+DK1LRkyVDkaYKB0LhAGgw+T4EovPddLg7erTtm0+Q2flq1BlGXYcTd+gEuYjTDiSdkgg81cVi/qSuOazxW4dShq44gZc0GcwYYsNGqz1PUisI8f+t66MGQZbO9vHU2LYgNyrhhK57i81S/bl/8/z/5
 +o4FGCYc
 xQJ4l6N+1ByBjcp+MVuc6K53qY2Zf1pjchvv25N70TZXm4Dut4Tkv9b3vGeWSUzeurEyDIozksRgP9Q+KyBLsRgFT34CgwO+f0xsABNN17Ffudf3kxymhWk9Vlr9JkvKGRKr8h4PZ759I3L1dD0kiYmwt/jjf4FO71tVkXeb4u5gqtJ6r5nYEZS3QPMZ47YA8gZlsqQfv5wTixxu3jDom9xQIjd3VbdwDSyQwEozKDJSjgOK1WvjLylk9rvVpGicz4Ivmw/E7xBvtOnF3BnWYiIkSEAJ3uJh4SvoFgCmNiJetI0U3vktKLSaQPSK6IbRrFfSQmFCF1kRohebABeHrPINgVMuG1IgUY4MMH0Cy9eftcRUp4rWI9SGUcKhDJOzj/ETsEOheEFUvljBZEI1Te+uN/ilbozaKvPJ7egFftfbQ7HLACbg1RBPSdTNPeP4UJv0cTGO3bdhygdXoGA8QPhEYZWY8JzK3ddUveqJ5hI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    5445d6419962 arm64: Don't read GMID_EL1 when MTE is disabled
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1517ecf9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=56ed23170c168d4c
dashboard link: https://syzkaller.appspot.com/bug?extid=c6879dc677a017f0a21b
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=147ad125580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=127ad125580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e8b70e3bd109/disk-5445d641.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e5227e56ac93/vmlinux-5445d641.xz
kernel image: https://storage.googleapis.com/syzbot-assets/54905f78be59/Image-5445d641.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c6879dc677a017f0a21b@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: mm/vma.h:277 at assert_sane_pgoff mm/vma.h:277 [inline], CPU#1: syz.0.17/4912
WARNING: mm/vma.h:277 at vma_set_pgoff mm/vma.h:283 [inline], CPU#1: syz.0.17/4912
WARNING: mm/vma.h:277 at vma_add_pgoff+0x50c/0x700 mm/vma.h:314, CPU#1: syz.0.17/4912
Modules linked in:
CPU: 1 UID: 0 PID: 4912 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/07/2026
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : assert_sane_pgoff mm/vma.h:277 [inline]
pc : vma_set_pgoff mm/vma.h:283 [inline]
pc : vma_add_pgoff+0x50c/0x700 mm/vma.h:314
lr : assert_sane_pgoff mm/vma.h:277 [inline]
lr : vma_set_pgoff mm/vma.h:283 [inline]
lr : vma_add_pgoff+0x50c/0x700 mm/vma.h:314
sp : ffff8000963176e0
x29: ffff800096317700 x28: 1fffe00019d174aa x27: 0000000000000001
x26: ffff0000c659b700 x25: dfff800000000000 x24: 1fffe00019d174b0
x23: ffff0000ce8ba580 x22: 0000000000020a97 x21: ffff0000ce8ba548
x20: ffff0000ce8ba500 x19: 0000000020001000 x18: 1fffe00035ba3828
x17: ffff800080adeaf4 x16: ffff800080addecc x15: ffff800080b8bf18
x14: ffff800080b96bac x13: 0000000000000001 x12: 0000000000000000
x11: 0000000000000000 x10: 0000000000000003 x9 : 0000000000000000
x8 : 0000000000000000 x7 : ffff800080bee7b0 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffff800080ae89e0
x2 : 0000000000020001 x1 : ffff0000c825bb00 x0 : 0000000000000000
Call trace:
 assert_sane_pgoff mm/vma.h:277 [inline] (P)
 vma_set_pgoff mm/vma.h:283 [inline] (P)
 vma_add_pgoff+0x50c/0x700 mm/vma.h:314 (P)
 __split_vma+0x6a8/0x83c mm/vma.c:607
 split_vma mm/vma.c:643 [inline]
 vma_modify+0x11ac/0x18f0 mm/vma.c:1771
 vma_modify_policy+0x210/0x2b8 mm/vma.c:1834
 mbind_range+0x160/0x3e4 mm/mempolicy.c:1061
 do_mbind mm/mempolicy.c:1563 [inline]
 kernel_mbind mm/mempolicy.c:1760 [inline]
 __do_sys_mbind mm/mempolicy.c:1834 [inline]
 __se_sys_mbind mm/mempolicy.c:1830 [inline]
 __arm64_sys_mbind+0x5c8/0x994 mm/mempolicy.c:1830
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xec/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:758
 el0t_64_sync_handler+0x44/0x104 arch/arm64/kernel/entry-common.c:777
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:590
irq event stamp: 928
hardirqs last  enabled at (927): [<ffff8000869a9950>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:210 [inline]
hardirqs last  enabled at (927): [<ffff8000869a9950>] _raw_spin_unlock_irqrestore+0x38/0x98 kernel/locking/spinlock.c:221
hardirqs last disabled at (928): [<ffff8000869841d4>] el1_brk64+0x20/0x54 arch/arm64/kernel/entry-common.c:445
softirqs last  enabled at (208): [<ffff80008013891c>] local_bh_enable include/linux/bottom_half.h:33 [inline]
softirqs last  enabled at (208): [<ffff80008013891c>] put_cpu_fpsimd_context arch/arm64/kernel/fpsimd.c:251 [inline]
softirqs last  enabled at (208): [<ffff80008013891c>] do_sve_acc+0x32c/0x4b8 arch/arm64/kernel/fpsimd.c:1349
softirqs last disabled at (206): [<ffff8000801386fc>] local_bh_disable include/linux/bottom_half.h:20 [inline]
softirqs last disabled at (206): [<ffff8000801386fc>] get_cpu_fpsimd_context arch/arm64/kernel/fpsimd.c:234 [inline]
softirqs last disabled at (206): [<ffff8000801386fc>] do_sve_acc+0x10c/0x4b8 arch/arm64/kernel/fpsimd.c:1325
---[ end trace 0000000000000000 ]---


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

