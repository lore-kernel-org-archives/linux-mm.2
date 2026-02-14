Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A8A5EF5848
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 16:40:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F2B06B0005; Sat, 14 Feb 2026 11:40:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A0C86B0088; Sat, 14 Feb 2026 11:40:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89F2D6B008A; Sat, 14 Feb 2026 11:40:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7693F6B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 11:40:32 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 206705BA1D
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 16:40:32 +0000 (UTC)
X-FDA: 84443625504.15.72F3F81
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7238980007
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 16:40:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf30.hostedemail.com: domain of 3faWQaQkbAF4OUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.71 as permitted sender) smtp.mailfrom=3faWQaQkbAF4OUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771087230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=uPf8MT82Um0ZTVbxxH14r16T9e3M3qG/kIJLzenPqfw=;
	b=IQjdG5zBDR2p5Nbi0yMYgA9O0e4ov6BbcPpJMxB58K5pDjjkZXB32jMXcms6FamLOi4U2A
	Dzm3P1PU8AJqyaafqg1gPmUDHBbBfaekxY6hHMkJDWuW0ZO16J+MLa0MGHfUwM4tjNsk0E
	9kc0fTf8Dn2kOjE8mIo4bAm+1+YkaPQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771087230; a=rsa-sha256;
	cv=none;
	b=5fnsGW0Q+RYk5c/uCqj2zXdU4jh5KXa7RkQfowXcZdwBMDTWID6G6SKIfMDzXcXi09VPvu
	9KjL/33gVxrPyvghX70vpBFSLZest5BdQezwYobOT7SHXkWktzQGunJzuyFbjW9cclbiyg
	dIRZScP2g7s6tFN+kws6rQhSpkjS1ek=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf30.hostedemail.com: domain of 3faWQaQkbAF4OUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.71 as permitted sender) smtp.mailfrom=3faWQaQkbAF4OUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-678f3fef828so5281383eaf.1
        for <linux-mm@kvack.org>; Sat, 14 Feb 2026 08:40:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771087229; x=1771692029;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uPf8MT82Um0ZTVbxxH14r16T9e3M3qG/kIJLzenPqfw=;
        b=DSgJZfobKBEM/abc1knXRgvzp19sqSOUQbeanblF5VWYQ5KyOfWK0OOX6NY2XIS0C/
         OIwwayEIOf8+EwqkGAzNqlRx9ViuckAfWX0wa46XcpLGghBmSROU4RW+H01NIXmtrC/q
         QTgIqKIFQnaQi9gMdoa9DHFK7Bf0i+s52VD7pk7lIVQV48EmAUe7CHgry0o1d1VEwxH4
         8meEhhteKi9cWcCCiXFvsW4SGfnrrjE/UEnCYr7ESWV7w5pn47khHJ0rcE0hSA7G1Nnt
         YySzLhWfVx4o3U+RtTOL5S3pjdpgfexk9/S7/3MNY2ylHvtaeLi8Okk8oGsbd+HKhiY3
         22YA==
X-Forwarded-Encrypted: i=1; AJvYcCWHkBwXNQwt/YYgVKavvidad7PiArE5/6UW8tkk+hI8S69ZEsgvKvWjJ5miah7b3uEg6+anlV7R9A==@kvack.org
X-Gm-Message-State: AOJu0YwVe/eRu4KETYmrZaOMketkdR+renDY6qFWVc7Weo8DtWZbk/FV
	zCg/GxYlSkw2QqmMC6igx6aiKZ+CzIX/ORc/gcblrLy5FbMP4ch51SnXlMfAzel0eExh49luPQc
	fwxvbnxcIGZdvyiPreY72fXtIRw/y389SSQWmXoR1RpuRbbjXyRSCKHNYjNA=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4d0c:b0:663:1239:9eae with SMTP id
 006d021491bc7-67768ccad6fmr2550954eaf.54.1771087229496; Sat, 14 Feb 2026
 08:40:29 -0800 (PST)
Date: Sat, 14 Feb 2026 08:40:29 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6990a57d.050a0220.2757fb.0028.GAE@google.com>
Subject: [syzbot] [mm?] kernel BUG in __khugepaged_enter
From: syzbot <syzbot+6b554d491efbe066b701@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, 
	lance.yang@linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	syzkaller-bugs@googlegroups.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 7238980007
X-Stat-Signature: xuwwnucwrcrr5c9zaki8punnuxnz6fy4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1771087230-260026
X-HE-Meta: U2FsdGVkX19t0LH3y74U/oHQbGUKBfD0PJDN6h7at0dcT84+GWcUA/Zj7xmqGcTcuehXNh2T2T1olcoCk2+1icstiZ/9DaO8U/Q7swgVd3LuefXTRy2kywBru7btHZMEFEnV/4hTR2RoOwB9wRPftI+P7NxHYcXGPdPb0HWg2+s/jps4cdkhoYSo/Qc/GbuteIxG7easgli+kx3eBmM0/K2uv6afXBv16kLUQUGKhPW3pMiQc4FLuYHWHL2mWSgNfmEL0gID3K3h/yz6/EawI//xyWkQOyjhhvcNv0mbttKmQIICbJ+TKv+FdMX76wfnEJU0dGr9qCwcojCMAUGSSJTXQsBPIdeHENzCmfRKea0rEXVGQ5l/wF5IYitVxNQ+5f2LQGWLT+eGoM/0U2jHvS+F86cVpwOJj2gqfUVOsKnsu6x/48w2LKjPe5ytWpDQFhLm7k24JgrrGwrnj68N39spbQSQgfOBW56Bi6pz0rqZfNmtjzYVuB73hGolIuZECcvNisyTR+jKIL/GSVVSDV1Q0IVPqkh1VLyUC7l7+CrrCCbMR02CrwEbDJnzebOl6aFe7lr5cAIz668utRB36jUuYMOuwinwjDEPgMxKrLWEoFt2WvRp/K27SE2XuDrFpRPqQc4qIM0jAbRrNHArb12rWSyL5iDwVmP6dTtQHSFL2zVWrSxApuP7nXHcROuH5dtXuEHzyzrNtjHX7H6EkE8wyojbh7dHTpI2+VSomYlROWQRMIRVCYFT2Xq/7YUaTS7y+1DZ3t7AYLomPuyGie9xdiFw06WaCT2X4ZNxfVI6ZRiLI4XT+/OkO256+XPe1rPNSHInLvxeL27Agdqeq2bDqK+RpBPFeaic68m2kuGOKDtq7hJoYC/IbDfVMxqGQd1U+abdl29/trzpQwoOlETNDUeLj/fMX33K1KA8Z2h81iurCtkjuaTxtc+d9srIG3CBbo+pfT7wgu5z/bt
 SbyZEjjq
 DetJtQoV6wRv0IQK0Ap5zL5Esw4plVOXFuNURDtwxdt2xvETyBTVjRc9EoHitgpW9gdy+6KDIQxTacepnKsQFV1Gz+wVTtHE/eSCgUVDjgtu8B3tiz8lNdfTMHjVZ9L1fJHRev0j+vuJlIsIL38ekZe41ZeLKiPnvGvhnCRogotK8+roX4Lm+nkmzZi6SexkZEETGvMBBvzTu0Z0ITlXEbG5vtNzQ/mDCk+yfawRix9DvYi89UkdOXYDYTDjXrSaOxwlWtAoAwuVqsX7j630WSowBxmJrt/CfZ1CNJvKd1qku9wq8mmbQoaUS485HMbMIebaOx2PCSsSEsoQZfbu0ha/XlPWZ+nlhMYzwstRdLMq7fZlNx5mDGZnhz10h7hdcM50Lu3HlO/t1faQRx7THrMbth69TBEmPZcWENtsoc2Q0+XGyGbPXVbtGqcYtiEAijS9EovZde+W8SyBGO0pfaKlYN2UANozF0x2Pvw+cVb3my2F7F/dNXDYZ1ysiKBVNf9sE+b2F2EsO280ICU/j47kX4+oNBzZAOr8Gl73414UKBbASvGfegiJnkuW6yBHVfNTXexS5nMSGascm1ZTPbW8jq9IzSqwV9Rcyd8MVfQ82UJKenl4g+C+hLorye+T5tsSeqsas8ZgSyEeK1t7LUUwlDtYMpeC78kyqfRSxkuzpgJrw5QA9WjwjaE5lY8NoqSP01uF4CpazXGnOOQQ3s6bRTOZMCflOCXl0GNw6OVFqONY9FAbbd9YqEq4KATfY/lGAHRA6WlePsjafQX6CgbeAIvgDR7vBX7Wy+I1Im77Urg80iial5HmpQMgkbUfre5QSkyQLJU/34IUsHoA+PZjotNO+RlssssI05Ir2v3arRNelEyQJLOCqkw8jkpVl4M+y6AYvlswkxyu8FK0hhdh20m3T5gU7TM1W3IHa7RIVya1XcRZoQRLhvzeSzd+dVuU3LNgfqbJgTUT1lMLqcm2oMrxg
 MlXy5ySL
 BnHwmRiJTfleDwMg/uprkbNrv5+/Lf3FJ0srki6ykk2rs4JatAYnNyxZZCiR3vlYDhQg761n8ZfkTfmKCEbwHB1xns7sLJKiLC1y/81Shm2w2osMKe3CRfCCtWiDEkn5n/TDL3e3/Vb/HA1vNztS8s5l08YtLBgRYwvo8QPzLxP4ddtRW2F6yJWxiXoecFvT/f53B6ZDJFXxhr13xZJCg6Utu1igkPRdNjPGSKR9vnbSeanIELoeH/UUWdP4BhfF7bDmMSPgORlbtofzbeULNEVVRJj6wO9OwF5wYNrQKnWc7HVeS5UvmZMt1ceHtI92Kf0kAUdyxSsZZlLsbv0NnDh0cGIM3VZRb2kVT8jxx3XUe1zQkgHXv9mN4m0kcNXagD4Kx8xmorxDKTh/A2fxqqC9LfGJPhj8GfC54dArGGl5MJhDWC4sz4NOv7YKYCv5EnX4nFokWf+NszjLXZcF9ugkewaGt5C8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    1e83ccd5921a sched/mmcid: Don't assume CID is CPU owned on..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1169dae6580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=54ae71b284dd0e13
dashboard link: https://syzkaller.appspot.com/bug?extid=6b554d491efbe066b701
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ed43f42e3ea1/disk-1e83ccd5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d8af54a32588/vmlinux-1e83ccd5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/34e6a8cc1037/bzImage-1e83ccd5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6b554d491efbe066b701@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at mm/khugepaged.c:438!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 16472 Comm: syz.3.2372 Tainted: G     U  W    L XTNJ syzkaller #0 PREEMPT(full) 
Tainted: [U]=USER, [W]=WARN, [L]=SOFTLOCKUP, [X]=AUX, [T]=RANDSTRUCT, [N]=TEST, [J]=FWCTL
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/24/2026
RIP: 0010:__khugepaged_enter+0x30a/0x380 mm/khugepaged.c:438
Code: 64 7e 8e e8 a8 dc 66 ff e8 93 e6 8d ff 5b 5d 41 5c 41 5d 41 5e 41 5f e9 04 6c 04 09 e8 7f e6 8d ff 48 89 df e8 17 33 d9 ff 90 <0f> 0b 48 89 ef e8 dc 51 f8 ff e9 3b fd ff ff e8 f2 52 f8 ff e9 e1
RSP: 0018:ffffc9000e98fba8 EFLAGS: 00010292
RAX: 000000000000031f RBX: ffff888079b24980 RCX: 0000000000000000
RDX: 000000000000031f RSI: ffffffff81e5b2c9 RDI: fffff52001d31f1c
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000001 R12: 0000000008100177
R13: ffff88804adf9510 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f06093436c0(0000) GS:ffff8881245b1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff341d3f52 CR3: 00000000319b0000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 khugepaged_enter_vma mm/khugepaged.c:467 [inline]
 khugepaged_enter_vma+0x137/0x2c0 mm/khugepaged.c:461
 do_huge_pmd_anonymous_page+0x1c8/0x1c00 mm/huge_memory.c:1469
 create_huge_pmd mm/memory.c:6102 [inline]
 __handle_mm_fault+0x1e96/0x2b50 mm/memory.c:6376
 handle_mm_fault+0x36d/0xa20 mm/memory.c:6583
 do_user_addr_fault+0x5a3/0x12f0 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x87560
Code: Unable to access opcode bytes at 0x87536.
RSP: 002b:000000000000000e EFLAGS: 00010202
RAX: 0000000000000000 RBX: 00007f0608615fa0 RCX: 00007f060839bf79
RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0002000020003b4a
RBP: 00007f06084327e0 R08: 0000000000000103 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0608616038 R14: 00007f0608615fa0 R15: 00007ffee482e7a8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__khugepaged_enter+0x30a/0x380 mm/khugepaged.c:438
Code: 64 7e 8e e8 a8 dc 66 ff e8 93 e6 8d ff 5b 5d 41 5c 41 5d 41 5e 41 5f e9 04 6c 04 09 e8 7f e6 8d ff 48 89 df e8 17 33 d9 ff 90 <0f> 0b 48 89 ef e8 dc 51 f8 ff e9 3b fd ff ff e8 f2 52 f8 ff e9 e1
RSP: 0018:ffffc9000e98fba8 EFLAGS: 00010292
RAX: 000000000000031f RBX: ffff888079b24980 RCX: 0000000000000000
RDX: 000000000000031f RSI: ffffffff81e5b2c9 RDI: fffff52001d31f1c
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000001 R12: 0000000008100177
R13: ffff88804adf9510 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f06093436c0(0000) GS:ffff8881245b1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055906703f168 CR3: 00000000319b0000 CR4: 00000000003526f0


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

