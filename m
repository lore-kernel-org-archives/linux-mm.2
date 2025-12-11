Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63558D43359
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 22:50:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7EC86B0005; Thu, 11 Dec 2025 17:50:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B56756B0006; Thu, 11 Dec 2025 17:50:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A93CF6B0007; Thu, 11 Dec 2025 17:50:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 97FF86B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:50:38 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 192EF89F6D
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 22:50:38 +0000 (UTC)
X-FDA: 84208686156.28.F1641BF
Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	by imf13.hostedemail.com (Postfix) with ESMTP id 747772000D
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 22:50:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of 3u0o7aQkbAI4AGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.78 as permitted sender) smtp.mailfrom=3u0o7aQkbAI4AGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765493436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=A5yDSWdBQhZN1p5pu45dzNa4E8ffTKHbWi7g1FoV7hs=;
	b=S/KSV0XoxGSUYaWoE6YBqlD5eyTgiq6c6BYOCb2P2mBax+5biQruSTLyl/mvltEH0xSNNk
	E/gx6EzU2MdwCd8li3E37EOgK66LMebx10B+KUzozrq+6djqWJffrX5YDrJWXMkF/asVsO
	iIdMOunMfJhiiRPapBga/Da49nlAKuY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of 3u0o7aQkbAI4AGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.78 as permitted sender) smtp.mailfrom=3u0o7aQkbAI4AGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765493436; a=rsa-sha256;
	cv=none;
	b=EKgTljMfg0trqYB+s11R14h9g5Yg3UIm0jCtbhzWo4lkex9ZyhXQAZYzR/Z6Hk1N4CjjiH
	++mCxbfhgTRgZRn4zYltsY4BYCoqe27ba9i7oJulx+61dEVYPxYXFySd6zl5miGyXq4udZ
	QiMt0IPRnXlnaTohUNbdEdkJZHkmSQ4=
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-65747f4376bso920849eaf.2
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 14:50:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765493435; x=1766098235;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A5yDSWdBQhZN1p5pu45dzNa4E8ffTKHbWi7g1FoV7hs=;
        b=ZPTCLKzKVnkw+ghvj62zGn9f65uK1+4kIWRSxdYD34arg80kQ+IIZmTWfs7YB7ng2O
         FpNXIru8OdC54SE+yrWbuBPQ4PHSqH8MlEIdhyY23tb0Gsc6iQfSSoNpq8XvHsBgLlYE
         zXeck8VdgxERJcOQRolEpmvQU9dXL3RjatJBL67hsr9NEZRN6+fxnGVxXYNHDNZf14Gz
         2Qe2JQNdhohNk6il5I5+Xpvgt+MIenJXutTTnZDQ3cIw1Zfyik2bRLPWdkq5tkI/N7vg
         9j8JA1hKmtpsM0+J31WT/Tb/zFmQfkZw3WZRYl3wQdlCVTh6ngQtddx4tiLxjWKWLYRQ
         fBcA==
X-Forwarded-Encrypted: i=1; AJvYcCX3A2mv0ARoj47yTmAdd0vpiB3K8w44jmI1DA0Z89mrXTL8waZiJrTG32/nK2WFCBCYzTno1rrBYg==@kvack.org
X-Gm-Message-State: AOJu0YxURGJijQ9iB4U3U4Dtr80onwuylOz478oh1QlRbrnPGMtxtg7I
	VaeHYcxGl4zao7uYv7Ya6SO5kDr9Oq1EAJidP8HV3eHz8EHv8WzN75OlFHUk8l1RJC3P8rR3Jzk
	XRuVAE9w4FozryyBvDp+VaBARyhQ6qgyuyZ10hAa2J6F9vI5HAH2qre0dftI=
X-Google-Smtp-Source: AGHT+IHUXyhtvi/hubPS1nQrbhhusnyOiD0ntKp/kY4k2bxekAwtU46M2f2+UctlAjFmdiAm8N+U9B06BWusi9Q+pvzrM3jdWnMA
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c95:b0:65b:32b4:83e7 with SMTP id
 006d021491bc7-65b451863a4mr67052eaf.19.1765493435493; Thu, 11 Dec 2025
 14:50:35 -0800 (PST)
Date: Thu, 11 Dec 2025 14:50:35 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <693b4abb.a70a0220.33cd7b.003a.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in blkdev_common_ioctl
From: syzbot <syzbot+660d079d90f8a1baf54d@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@kernel.org, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, 
	rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Stat-Signature: yn7ffdkoccrxnomqon1uout19a59t641
X-Rspam-User: 
X-Rspamd-Queue-Id: 747772000D
X-HE-Tag: 1765493436-357266
X-HE-Meta: U2FsdGVkX19YotoHX1Qx1If8G/VFjn+K/ylb7m2eTlEzcJakv9BNKs4shWHpgfv6TO9oJngNzZzsjiW88FRhu+pSe2m1lW4Yl3DyYZVvJ+1VHLllURImB00rLrzxGdxgL0teBHT4YfuUfxoVSiNrU4u2tgFR3Tp+TSX56V7C+LJur7Nf6JBcbOF+uX1PfzHUevTNnEjq120rAdsyKw1rpbXkcHinz9AjLGFqCcbRAWdS1wq3lwnXF4KMWc89G8+8xcfI8gLwlsp0Lph+JMkre5haPGQMt4tM0DwGIKZNfYat/OHEN+XhJP5H14FInnCZI9SqoknzaqV4M7BA9AErTMYTgANbmtRXuteW781SdtxnFKUThUsVgUELjPz2QpzWF4lzwO49H+KUBL42TB7LocdYXAMf0tg/dG2U2zi9jiRTRUFCc+w3uBDxaS+GOfpu6bmZCgIuiosR9OiOyw+nanL6vxJ48F988ySW2+saXjnYoT68HaQU2Dsr21rLU3C2xoCWcTnjJW1lCXSId7EL+OGyO1JzysrxhrCzHNfGMWAAz8TdeQxBeStXo0W0fZDxQ/ZrrETc8S5r3mx1AVV3Ie0WVQxsJKXWb+q7KEh5WPl3bxOmqn/VzFqXuHaYNqD3dZJFD5qwNEDfIg5wf0Ng9Y4KYcLdCzCdaSoL9NUcEYyAQtDGkbYCTd2BzK8LQmdVLkgaf2vaDCTNXuJS8RPnxDy2pp1jU1PABMiE6D5EKEuagpryCrfpRRXGaD/AhZ+zQMHXzWWLRxUDjQNSd1VVL8xvsek5oOoBt3P+OtaUkVxz2+Is9vBchH9CyQgqKJN/1onKa71WqOVx70MpTx0DngQYcQVYveFlLeo/ZQefQslu9L/7iy9n8UNYMiup7GB8PYdAY8P2QIUctAvgaL2jBVGm4VoXIq4rjlg5XiNMyBxIScxpZHXAZC4u/GRhG7vHkwSWbX1Ki301uBZe9KD
 NJYL3l6R
 jvbo+bNm+Lz/zT1DpmBCoELKel5TwEJJznSP3QXebbWTrJ+ZRJpc0gaTUI9rDICSWnr123srHENzm+npntJP2M9MV9Pyhb2JUTEHd+heB1dHWulgjWk3/HWE7gpkeN/UXL2OzygSHk+2/sMAlS9Ijuz+EwWXJMECNyGAISLWe/lYeIwhkqCnoMTN/SqHoaRe29M7RuB8KilTAnc2j7vjPwSHqsxbHITOkYakSycas1mLm/aQCwvxrH4ZhIq2jW3W7iTiQ+9TSfkFNoiXssqY3JzxXlq78+YgTg8XWobbxdlt/1A8o9bEGQcj+C1PVFX6SB9e8t85W72vn0HWjSZoHzrltPWW4fJ+bMOOhaoYP0oAQA9S7udk4dBDTobSjC4ppA96ci68nQGISi6Z9u/VdbwKyLkYKoRtHcxc8jns9C5p5TTw9SZVNwZE8P29vn5MusQGFWVnNEc1qKuYpOaxcbf4WlSrwbDqFSnHOeut+xv7zHc0nYDPbLI5cOttCL5HyRUXM5VBpGETjgWBoPrt9k8M3Obg/3UsXyUdBDJDk8hSLHUpbCWlYTHZxf/s1iShp1uDLDt26hmV6z+wlK+wDPPlqYxEaRIBfOTkfQgxfVmO7UbIDQwAcv7HKZzDc+l0btFZZtqjyUjIKts1VgH8gzdt5yly9+RJX2dOWvGl02UeSeUZXUrCLAb8tm8RVuV2newyQ4KrIBqi4fZhHdUa10E39s5apQzdjXfL3Vi2aEgW3YyBi1iZG9c0E/dNIA1BFyZ6TOIbr+p5sQB2q2s3GF8Z3JkaVDxnxL9smNgDvBsc10baru/TSS/IMAOneluI2YJQe+GonJiOf8WFZfaDyJ58QhnBZ3dOIbLq6hppWAEbty2qxuAVzPktvCWX0mEgKGIL+mHJKo4kmxHVqRb4GIWdkdpfOCPSLZDYXJqgD4UqbXln5brhvyHtFDeGEzfcbX3Vl/kOsnN2jY8umXreM7kTHko/L
 71522YtI
 XzqRKxNTcn3lQtH3ynWMmxn2pVtN/kaXv/OHdlYfhxM372Q9QqY84siiVfJ0Mofk+Ujyq0GRqeWKfVPZqAX62OyKqXJnGU8OTjvk4HQd/e3pIilzirHRhACcpB0VCTQYsdm8ETn0bs0leFJxYAx2VHozzSEo3yf8LkRPd882GFamzWyJvbdQKHwKALNZD0YRZXFNfSsWv7IXTVWHgYa28a2b9LeqcHj2SrvHBL4z0oLGz/nGUeXgBwoKUTG4G9S2IESjP52ISxRU9RStD/Pqy50zjauU5R9d3UafXl4YhkVbCQFd6c2S7Iwhqlaf/QI3lE2NeL5e4Q62qdfiN/AA5UrJXlP8ow4HvzbF/wt+LHH0iyqz1P/IjS8OcGXQOG+rNrEquTkpkEy7SovRVUYEEPaXSnrKimYxhCmiNQEM4jsaN5/Tu69nDhGhfgGqa0Xb8to/clKXmgXfOrE+CVLDPz80b3EDOAVZDZaZx0QZqDlCVeXJ2x+pu6GBOkJoXdlYhaIXAeYQdfmEmkC0Nud1j0pQ5QIqgmbWTKlbKehhwn8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    cb015814f8b6 Merge tag 'f2fs-for-6.19-rc1' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17215992580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4ba13acbacc6118f
dashboard link: https://syzkaller.appspot.com/bug?extid=660d079d90f8a1baf54d
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14d49a1a580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=100e2a1a580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/fe039b381b1b/disk-cb015814.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/499efdc87215/vmlinux-cb015814.xz
kernel image: https://storage.googleapis.com/syzbot-assets/515c65eb7e89/bzImage-cb015814.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+660d079d90f8a1baf54d@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: mm/page_alloc.c:5186 at __alloc_frozen_pages_noprof+0x309/0x2430 mm/page_alloc.c:5186, CPU#1: syz.0.17/6010
Modules linked in:
CPU: 1 UID: 0 PID: 6010 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:__alloc_frozen_pages_noprof+0x309/0x2430 mm/page_alloc.c:5186
Code: f0 5b 5d 41 5c 41 5d 41 5e 41 5f e9 d1 42 5e 09 83 fe 0a 0f 86 0c fe ff ff 80 3d 84 7b 57 0e 00 75 0b c6 05 7b 7b 57 0e 01 90 <0f> 0b 90 45 31 f6 eb 81 4d 85 f6 74 22 44 89 fa 89 ee 4c 89 f7 e8
RSP: 0018:ffffc9000414f888 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000017 RDI: 0000000000040dc0
RBP: 0000000000000017 R08: 0000000000000005 R09: 0000000000000009
R10: 0000000000000017 R11: ffff88802ffe4830 R12: 0000000000040dc0
R13: 1ffff92000829f27 R14: ffffffff9ac29ac4 R15: 0000000000000017
FS:  0000555575978500(0000) GS:ffff888124a0e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000240 CR3: 000000007b864000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 alloc_pages_mpol+0x1fb/0x550 mm/mempolicy.c:2486
 ___kmalloc_large_node+0x10c/0x150 mm/slub.c:5593
 __kmalloc_large_node_noprof+0x1c/0x70 mm/slub.c:5624
 __do_kmalloc_node mm/slub.c:5640 [inline]
 __kmalloc_noprof.cold+0xc/0x62 mm/slub.c:5664
 kmalloc_noprof include/linux/slab.h:961 [inline]
 kzalloc_noprof include/linux/slab.h:1094 [inline]
 blkdev_pr_read_keys block/ioctl.c:449 [inline]
 blkdev_common_ioctl+0x1f72/0x2b60 block/ioctl.c:729
 blkdev_ioctl+0x2b5/0x6e0 block/ioctl.c:785
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6c89d8f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffde61cdd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f6c89fe5fa0 RCX: 00007f6c89d8f7c9
RDX: 0000000000000000 RSI: 00000000c01070ce RDI: 0000000000000003
RBP: 00007f6c89e13f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f6c89fe5fa0 R14: 00007f6c89fe5fa0 R15: 0000000000000003
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

