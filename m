Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A39AFD2CE17
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 08:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 761E96B0005; Sun,  7 Dec 2025 03:55:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 739D46B0006; Sun,  7 Dec 2025 03:55:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 677716B0008; Sun,  7 Dec 2025 03:55:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5407E6B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 03:55:29 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF4221A072D
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 08:55:28 +0000 (UTC)
X-FDA: 84192066336.11.99A4939
Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	by imf14.hostedemail.com (Postfix) with ESMTP id 29ECE100008
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 08:55:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf14.hostedemail.com: domain of 3_kA1aQkbAKUXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=3_kA1aQkbAKUXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765097727; a=rsa-sha256;
	cv=none;
	b=pVYvWHqXZPbqz5plhkeBg0qGCnQkJfGpaPj5pmoFEz8Rjr+TObcZIESOaBTYkNS/ZHc2L+
	tAEHi2oifeP5GdVDtrlIF6VSPi6iqytvVwGoiHSmt1f0kTlK4lNsDgbR/xE3b4GBdrwVeW
	lWrtHw2b+KQT8QwGn0LOjmGJO3vYop8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf14.hostedemail.com: domain of 3_kA1aQkbAKUXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=3_kA1aQkbAKUXdePFQQJWFUUNI.LTTLQJZXJWHTSYJSY.HTR@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765097727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=Rg3NpO2qsBNiFF6xlTcbeS7yfrEriXZCD0JTQIYZjKQ=;
	b=8MQKFlG0NwiZTEVaCNVwp1YWzn3DX2FCzmI7FebflXZeG3+NL2TiY5K47/inhj/oPw7Beh
	VHUZ5scozO55U6iT1l/HKW3QpA0ztBJoZHPnxHiNniO2tAFcpGcgaFnGHeLWOkrqCZd612
	+32+2eo7fcY22ptqTqeuzMp3JJXq8zo=
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-65747d01bb0so5373839eaf.0
        for <linux-mm@kvack.org>; Sun, 07 Dec 2025 00:55:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765097726; x=1765702526;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rg3NpO2qsBNiFF6xlTcbeS7yfrEriXZCD0JTQIYZjKQ=;
        b=j39LPxRBdENi/nFjLkHmwzDq/QGrQHUsSMtQFJmnj2s4+x5Y4dlnektSjz8wPcuneq
         KHp7NJk7xqktepMfFXy82PtTy7lQHG2WiLAsJL6xeAsAeGLHw8wnsUIgruZzZxKIyJ2M
         VRJHPELwaqxRjE0+6rZQIqnsbj222u+XhDnllutDxPzx1AtAdyS0N8geZUJ8s+T+SJRm
         DtZRXBzg6HkHfe2R5bPiVeSJ312RH3XlneOfEJvf3W6mqs8c8XS0ZOAFtU/FE6OU4Yjk
         GWgXKhfEv/wHzVzyalu9cxRa1EaElJA59CKGYOaI5fXGnvN4F4ObcUf/mJcqsf+CutZ2
         XgWw==
X-Forwarded-Encrypted: i=1; AJvYcCWNGaGR1dgw01cxJFo+MvBEdQ+H28CJGpCBBMfVaRg1mih9qDPf0Qy650iA0FQcZa9DObwNPQDyyg==@kvack.org
X-Gm-Message-State: AOJu0YxKBrCnMRep7cnf2kF4B/TEMn2ZxCW/4TkeUbvN9Mxwv6vutDQF
	l+Eptx5Ga/QmItuM6L5YTPvqMnYOhnEPx9bBgLb+dKwVDEGpb78L2AF9F5a+uvPgADPVA1V/v4Z
	Ku6Q1UEQSlzreYVd6znnG6pr+rH1dZ509yydcZq0Gj/LI9tjRMy1kSEmg2W0=
X-Google-Smtp-Source: AGHT+IHVK+oaWYxHEadC5NNhsPw1HdmPhptHVRCyjazvlI4ChZAHNuTSFIdFwEwt0ocKs9fANO0NecW0qePdhCSwhKjQtkORS1y7
MIME-Version: 1.0
X-Received: by 2002:a05:6820:160b:b0:659:9a49:8ec5 with SMTP id
 006d021491bc7-6599a9792ccmr2050790eaf.73.1765097726197; Sun, 07 Dec 2025
 00:55:26 -0800 (PST)
Date: Sun, 07 Dec 2025 00:55:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <693540fe.a70a0220.38f243.004c.GAE@google.com>
Subject: [syzbot] [mm?] general protection fault in lru_gen_test_recent (2)
From: syzbot <syzbot+e008db2ac01e282550ee@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, david@kernel.org, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, mhocko@kernel.org, shakeel.butt@linux.dev, 
	syzkaller-bugs@googlegroups.com, weixugc@google.com, yuanchu@google.com, 
	zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: krhwwijwjws7t771issmdpj9qqcms3r9
X-Rspam-User: 
X-Rspamd-Queue-Id: 29ECE100008
X-Rspamd-Server: rspam01
X-HE-Tag: 1765097726-249732
X-HE-Meta: U2FsdGVkX18Kd/yR1v5yY1GY6BKemkA9r2RTlqQruD3CfAAtWnPHKLX+GtCFYL3FXXIXIf0gxZmFo7J6dsaCsOmxnMV9tqm4XRVjhKTz+acgBfsX6bcEPRsLweb5/aSnYLBeqkFYORyl0HbVfHwSrcpv/qjA1hJC6kDP+MFqBBFfnwwSnCG393ic4V8EejZ/7eqnpIUksR2EasoqpIRPljX8k1nVrHVkzu3d5m4wQ0ZpTMxEGZnOjpPSzaeza9vvwHj9CQwDkRGAIHT8C51kpKCtjX21EUjYY6RWHu/3KqB4e6nOoI3maHj3WN5cYPKlJcief/cCyiuEpI/gpDd64pPRT/O5oXpv6JqIQa0jF59Eoc1MtcWeW9pBZK1rU8mTJUGNz/jVGouDsbiKx0Fii9S8SqUr8gJKdxvLhGvfsYX30tH6+8i+f8RohsUDMTTOPa9NID15ovA9gVDKE2i+iGAZoQFvo64dC/RNVw+oRFxO0fv9krrdLiiDHzTrtCnBIG4eEJ3qUZWvoY7KBy+toQzYugN48fcVxgl/sO6IKh70dsZ41xyXRFWNZcqXkKg49ZD5dNAFkVAbwpPA5iY2x+TZ7Xr6sVBy6fRg4ySMLiB4g+oJE1B1vZTM4ynj3jfGQDF0mp2d56n5im/bVahdOroafIEpjE6bGgqLpTlSUm+6gXq70LdCcnS/c7KDmsMfStoJqUM/s7NDhqCSNRMs004FlT5Oj/rRRq1Q1thYReg5LB5bPcCLMVnk80vG1KEACxELNu33rxguRo+IIFCEGVXCZu6Ait+jylAcOO/kLTyMlONqknWGd/BqLP0ddGOCXQb7tj+hMr4pTDVWsDEoATOBcKiQRCkOhAryfeGx6wbHQ6DM+AP33E9njEF5LQrkCDsgwPjorwPgpixMiENxfuXJIns7zZIhAwYcjXz7/s0XEKtp4/MexcyAwHGPbPcpNqcsgQRqyS48yOOtNYa
 j2N/r52Q
 GtFAMlaEx7SkTBjxyjpxPRJ00l5KVI88wA6rOYa1xxbUZMzgN1Qucvh8irXV+enGmOKnlnInmnFnGXMwRJhPd+lcETe2G0xUxwEzPC2Zd5IVTFGlvNByrw7Mi5ITM6AqtjBcLnlqDiNWDFJ+PQnB3X9OlWEAzml4NxvSSbmT+6d/5eh/IeATn4L5cr68LUpacVpraMODsrKB9aKLb3UtmaIxpMe5GLx8hY2TMH+jnsJQUtf4nj6hhoSHWSZi6m3pL8NyRWyujf6ofbCKr7BaHAwXmLMVXFv4Nz+Ru969xHRhhC1zPOwzw8wxLfYv6/dWk8Y6eSzzUhYmEZh1+Qy6rWZn7TBUNbBGI6r4/Niqr9V2jjUopuHVWvDfYFRuB+wIO0AiY1GmCJxGIARqIpHZxRp4p90OMTlKFNmaPZ3R8jOiNWjM7H7luT5kTFYQULflWUE+IiSncouK2iPRlRTABmBhRqG/ZKTbHx3wF2fsNAoje9RuQt302h801a1rQ6jafLovUTErcE8rvlpYpe+LU0Ogn1wDthTo8iHA8aWQRAuLMyQPrDgbSFUmZ8hxwdZL6QIncyar2RiOdFcrYn5PxTwhmqFPHOJyEhKxOuwvpmxW1SGxXeRFKfd7Z2uEuZTldd4FRI8IFQNZCTH2qcBgpu7VAzTwXnCL91szU4ZMJBuuZapczNxc+T4lVUZS4CvRTskx8RGUqwrTtX9z+I3uWu0XRd+Cj+8ZLZtcmW/dizmq8dlD4rdvs5x+Do9fxnRREg/I+veI1cMREyp3ePbVZnAD6YskUj6I1Pcrmw8pwNF5DjOGMQHRTpipD4DMxYJMzw5vwiuqT8NFRRBU/MBgIAq0y5LkPKrX8H5XbRoZ9DX7AENuaEyJIwhBPCn7MjYXz/GYoG5a8QdS1Yv8L549nCFapEYQNphfdxESmsDWtNXR9lRvLvSpNUyPjcayIM2L9d/Pjm97NasVIhyK+WdO/8vG9QOrB
 hnky1Hlx
 zklv7423f3KfUTjO1QMRSrfKaIEMUNwsQ2gIVHOY3rH+o1TKitCVntiUpw/1isQmBtWm0x6FRH2Se5ZgDQb8zUME4vEiICfNJmFsQePisjVCi2u5LMDKw9T/0eksAhlhdbilvlAB3K8wKu1M5SPMJ2IrJaYKbh58VL6IbaC14Y898qbLxZG+falaM1snliKyCxwm7/wQZzn/vSRuDdIQWqe29O7/Q5X3COZVW40coDSmXR0Sx9Xr26GyGG6B++fDdgwhPl6JtlvISssJ9RuU75qjtbEdk9Lu78AdHVwIpMe9mI/7f1AWZn3B2NjKhLqdOMxGtKj4ya1/Arch0HLBbd0U7QWtm6BVo3Jb1tevmp4q9h9DZKkiBqVzKHVJV8tgmiGIBzyFiOJYF1EHPEWyviE25689oVwjC82zcCSwZTGgmqthgDh1KMb7h2pppHfYNE3piAGVJ7eBkzmfEqNKJdcRFeSbAJX2qp8P/S8oS4QMG0kj9VFs/aQ5mpGpMNSY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    c06c303832ec ocfs2: fix xattr array entry __counted_by error
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14cbfc1a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5aef7d5187304591
dashboard link: https://syzkaller.appspot.com/bug?extid=e008db2ac01e282550ee
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=127f2992580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15cf4eb4580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-c06c3038.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1a5115eeda38/vmlinux-c06c3038.xz
kernel image: https://storage.googleapis.com/syzbot-assets/98eb17e54bb8/bzImage-c06c3038.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e008db2ac01e282550ee@syzkaller.appspotmail.com

Oops: general protection fault, probably for non-canonical address 0xdffffc00000009c0: 0000 [#1] SMP KASAN NOPTI
KASAN: probably user-memory-access in range [0x0000000000004e00-0x0000000000004e07]
CPU: 2 UID: 0 PID: 6121 Comm: syz.0.27 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:mem_cgroup_lruvec include/linux/memcontrol.h:720 [inline]
RIP: 0010:lru_gen_test_recent+0xee/0x320 mm/workingset.c:275
Code: 38 80 b5 ff 48 85 db 0f 84 79 01 00 00 e8 2a 80 b5 ff 49 8d bd 00 4e 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e a3 01 00 00 4d 63 b5 00 4e 00
RSP: 0018:ffffc90003e17828 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffff888100068000 RCX: ffffc90003e1772c
RDX: 00000000000009c0 RSI: ffffffff82096446 RDI: 0000000000004e00
RBP: ffffc90003e178c0 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: ffff888028282ff0 R12: ffffc90003e178e0
R13: 0000000000000000 R14: ffffc90003e178b0 R15: 0000000000000000
FS:  00007f6361dfa6c0(0000) GS:ffff8880d6b0d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000409000000 CR3: 0000000039516000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 lru_gen_refault mm/workingset.c:296 [inline]
 workingset_refault+0x251/0xca0 mm/workingset.c:546
 filemap_add_folio+0x23d/0x610 mm/filemap.c:981
 do_read_cache_folio+0x23c/0x5c0 mm/filemap.c:4063
 freader_get_folio+0x33a/0x930 lib/buildid.c:58
 freader_fetch+0xbd/0x740 lib/buildid.c:101
 __build_id_parse.isra.0+0xdd/0x6c0 lib/buildid.c:289
 do_procmap_query+0xb0e/0x1080 fs/proc/task_mmu.c:733
 procfs_procmap_ioctl+0x9d/0xe0 fs/proc/task_mmu.c:813
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6360f8f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6361dfa038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f63611e5fa0 RCX: 00007f6360f8f7c9
RDX: 0000200000000180 RSI: 00000000c0686611 RDI: 0000000000000003
RBP: 00007f6361013f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f63611e6038 R14: 00007f63611e5fa0 R15: 00007ffe36ff8138
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:mem_cgroup_lruvec include/linux/memcontrol.h:720 [inline]
RIP: 0010:lru_gen_test_recent+0xee/0x320 mm/workingset.c:275
Code: 38 80 b5 ff 48 85 db 0f 84 79 01 00 00 e8 2a 80 b5 ff 49 8d bd 00 4e 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e a3 01 00 00 4d 63 b5 00 4e 00
RSP: 0018:ffffc90003e17828 EFLAGS: 00010206

RAX: dffffc0000000000 RBX: ffff888100068000 RCX: ffffc90003e1772c
RDX: 00000000000009c0 RSI: ffffffff82096446 RDI: 0000000000004e00
RBP: ffffc90003e178c0 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: ffff888028282ff0 R12: ffffc90003e178e0
R13: 0000000000000000 R14: ffffc90003e178b0 R15: 0000000000000000
FS:  00007f6361dfa6c0(0000) GS:ffff8880d6b0d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000409000000 CR3: 0000000039516000 CR4: 0000000000352ef0
----------------
Code disassembly (best guess):
   0:	38 80 b5 ff 48 85    	cmp    %al,-0x7ab7004b(%rax)
   6:	db 0f                	fisttpl (%rdi)
   8:	84 79 01             	test   %bh,0x1(%rcx)
   b:	00 00                	add    %al,(%rax)
   d:	e8 2a 80 b5 ff       	call   0xffb5803c
  12:	49 8d bd 00 4e 00 00 	lea    0x4e00(%r13),%rdi
  19:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  20:	fc ff df
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	74 08                	je     0x3a
  32:	3c 03                	cmp    $0x3,%al
  34:	0f 8e a3 01 00 00    	jle    0x1dd
  3a:	4d                   	rex.WRB
  3b:	63                   	.byte 0x63
  3c:	b5 00                	mov    $0x0,%ch
  3e:	4e                   	rex.WRX


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

