Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03B4B606A338
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 07:25:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17CBD6B05B9; Thu, 12 Nov 2026 02:25:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 155086B05BA; Thu, 12 Nov 2026 02:25:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06A546B05BB; Thu, 12 Nov 2026 02:25:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D19006B05B9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:25:27 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7638B80239
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:25:27 +0000 (UTC)
X-FDA: 85425631494.21.621AAAA
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf08.hostedemail.com (Postfix) with ESMTP id C101216000B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:25:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf08.hostedemail.com: domain of 35Wn1agkbAOwgmnYOZZSfOddWR.UccUZSigSfQcbhSbh.Qca@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=35Wn1agkbAOwgmnYOZZSfOddWR.UccUZSigSfQcbhSbh.Qca@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794468325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=wjEUB4xwOQ+z3iLncf90mEYp39goyjluFTd4fV3fH5g=;
	b=DGxzxKnxQMvUbNXtg8pGddw3nilku3mhXT7CelKBKd1vnMNtsbsLrzPf5Yl1u/T6yadhmg
	qBUaCLMeDU9poS2funljfpFZQYoFIg5ljorClOUEmpnF9EmsrQDKp7jc3GFK7+s5rKGjbx
	DkSaFNKIUeLRClvjwve1ubKVPVEdZXE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794468325;
	b=DD0+CoIY14WyOw49z3Q5K+GpSDHywXFbuka8nhBKUsWtBqLUcyCOPCdeM0n/nwHP5C5fHK
	Sarlc3/8pX2kj2Oyw9N4JpaH/fpPUzr3VO++o2sr6d9yuz9d0lBui4Ujcjwh8X4hKCd7W1
	aKMxleB225RwH03/ZCGMJeXp46Po6Pc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf08.hostedemail.com: domain of 35Wn1agkbAOwgmnYOZZSfOddWR.UccUZSigSfQcbhSbh.Qca@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=35Wn1agkbAOwgmnYOZZSfOddWR.UccUZSigSfQcbhSbh.Qca@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-540537f959fso4463525b6e.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:25:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794468325; x=1795073125;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=wjEUB4xwOQ+z3iLncf90mEYp39goyjluFTd4fV3fH5g=;
        b=CR3/wBwh1qLa1qvOm6g8CnCy8hkU/qx0tiINqO5RUFDZXGobq/mTEb4/66Pt3c1/6o
         mn+D4WtffhIteyyjM9i0MW8P6aVE8Z3nwyWYfV8flofUaoO8Jh1Yt8gnI5ovQv1LY3/X
         uzm3zRN+bQRq3s81uAt7KWhbU9vqOwC5a/43rrS0Du3n2vgCn1PNRZeeEMCbT5KMXkCC
         xWlPUFEpD0KPSdERdzHHe/6drfgIbFfZDeGj7Pl8jTrUcs2s0AIPXcEOdWyy7Y9ZemoJ
         QSOCoh352U3GyjIaG8l0gQBTCr52OtpEYsdiYJC/0H90h98hr9qrMNVGRuBNjvequbaG
         vIjw==
X-Forwarded-Encrypted: i=1; AL+hErF0jNitCVs2WmBHQbmKI5wdt/+MfTO1a2KB4ltFjNrcpzZN0zSfqDaWkfkOSbixLXJ7WYHHs94BbQ==@kvack.org
X-Gm-Message-State: APuU4Z/EmUVdg3GbMcxyjw67zaegy+vsL7glZW/GvkHHLOh8sfcEHMvI
	du4f2qMBT6w48si9GRvKvcBOxll9ByE01NvA5gq9iLaSXeyHzwWXrc1Par+3nJMoeYMYUZfVzXk
	M6PJMLCU4o1i3v5A7n71ar1MFwy2uSlskmU8RJ8LYnSzNNR3EuOt1IxIHB4o=
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:15aa:b0:4e8:e73e:e945 with SMTP id
 5614622812f47-56b9872af1dmr5151136b6e.63.1794468325005; Wed, 11 Nov 2026
 23:25:25 -0800 (PST)
Date: Wed, 11 Nov 2026 23:25:24 -0800
In-Reply-To: <20261109055455.536925-1-baoquan.he@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6af569e4.ad703688.70d19.3c73.GAE@google.com>
Subject: [syzbot ci] Re: mm, swap: extendable swap devices (xswap phase I)
From: syzbot ci <syzbot+ci2f12bcc59adcd0ab@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baohua@kernel.org, baoquan.he@linux.dev, 
	chengming.zhou@linux.dev, chentao@kylinos.cn, chrisl@kernel.org, 
	corbet@lwn.net, david@kernel.org, hannes@cmpxchg.org, hebaoquan@kylinos.cn, 
	kasong@tencent.com, klarasmodin@gmail.com, kunwu.chan@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, nphamcs@gmail.com, 
	youngjun.park@lge.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Stat-Signature: m4m8791bb9jum73ayfdezmaqonrsujn4
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C101216000B
X-Rspam-User: 
X-HE-Tag: 1794468325-853433
X-HE-Meta: U2FsdGVkX18TM5GnDLCtFbLPvP6a4tceJAzOCuUgaPPXMf3quRLtyxHpvQiVQEuR16Lsm0syZuAS+JsTYR2TD/idRsJ12fOgYqBkhFhYCdPmZuOZUj/nrdmGQCRWhQfVe0SQ3PGczQ7yTS3dMv2z4tI5/4lI8kpHUg//jWi00jc0Wv1RHmqgo0n3RCv+0crmWztdqi9nZmaSnXppFqKp8nBpaeCAH1nFHRxjg2JI6Y9AFDOaLsaLHRJ8TADaXs9+UEPypQSr9VdawnJI+MFZpgHKPwv1f8Rkm5vutJrArSu6rbZeyB6igE6h0svfzKoMvz2oRKaFQcnLebowyZ0Ex82Cnqapc1xwvsMC3YLslY/6mIyQ8wHh4nOS7UHS/1bkFdHjKeZDmJi/8RRSIf8BVVI0wwNbwcaMqhwfAQl/kXzF5QdIDs+a3c3Ti+2zvtCdHgs3jtee/Dl+KaWmrKYB7iJYKMNmsqDNPq9sOuyH7+Jf2Y0J4cNy6bWFtQVY3wPSh09+HcIh6uugz/MqOk+8Pe5hlNRRs4wryzaf0r408dDCe626TvOaLH8M2HLbqLUMFMJ5u9ucHO4EfAOJ3ATS4pCCKh5vyDawAxoJP+HkVPjQGw01ZBpdxL2/OrLEPaCUZf9Ea/yyrrWvtqUVGwEgyAhe4XwMhQeRTleKG2i6ZPibkabgkbpuVyA+88qR3VGuLing1xcxTWYsMwM67+kMRgL4wI4TS/bMgw6/BFNX0haYtDCdTUY0D7xWrjEAgmQBUdz86W9jUaPnIJQ8GlUDfsZ1pf2b6bbDigdYtuQvwouKlBN60+OSCr1d2dE7pvDFlxkQ98SFihwutpUg1NO+tWE3n+phP5QznrwM15i0K0yDh6/E+F/V1fuBUYUj/TM4ZlRXZugWkZOPnwC7OsCJZrFW/LwW1wNk6/J0TCaLSQrUHuzTiH/SU9TLVK9TgBFtAPvGH7MDexEn4qJrFHC
 V3s6tTXV
 7DZ+P2qBgb5euBGp5SugB77+Qjf6L5xqajnN/TsCbHWE7z8euF72rxGlO/Ha3k5ExnW9Fep/EsBXpAOP6+2Ld3wObu6KA53ysPzVOrsRvpAW9zrOWUQDRtl29oMED9ae1o8T9IW9owZjtPWGWhNI5a3wHrv71ItnV9UsmgdijTeQvBb28VgjmdH84pMLuSmUSfrLs/TDOzp+YYFxXTGIbfSbJjXR77EQCm8/HSs+RDEfkinNeiWinVMaMFvfd2I/p3VWGir6bEgCwxPIEn6ighSM73GbPuLroKNkFXgmrZ9JG1WvPq88g28BJt0Z4n9aaaAJ/e0AW3Mk1mK/ca6SCxAurNau8NDJrvbFzVS7cdmBnCs1UYXdnuRIZ9K2bmV9Pm20IZy2RAvq4XmtPnfGtTXb/tQvfvdmMLcJWhxgT3u22F+54ayuL3ZoHs72ewErDKgbldN3zqQINyRs+mRINx2IWb4BycMUPLTKu/WTBoae1yftpbmSskXwy9JVQ9AfYgxUGMiFk08y6CZctLUCvXMQrN74IyrTjz9mM0DyQyFpmdTURE0c6f/DkAqgwYksEiL7a56etCRSTA/BqreSI+U8yycarTyxquZCx59bu+cetyQYmnLXsaQqZha5AyUnKE41fIdF7va9/m4kVLYRw55ecQO1UEV0Ze3lE6E/AEPMV/9Ulc25Zrdc+9+qnlHEXM/IpEfANntB0BnAgevsEtzd/cdsRKhWq33NN3z1498RUL09JYGBeYNXdKg7Ab04sP8jA4/YIq4Cjfz31NOKAniQByZad6iNsTclebqPtdRvGEDj8/uhO3CHAvRuOlEky1gc/Cq0b8aGsJMYKKpd/5QuielYqGHxLG0XPZ0amn1ib+eV/kQfgTt0M4cHETtW88rpU9YWX2JHZQO4tvNOIt1VAubr8T7sxblQuid+LvE1uaW0acSt0BUIVI9m65+10yL5yNhCRN7L80cNDH5KoTSEnXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

syzbot ci has tested the following series

[v5] mm, swap: extendable swap devices (xswap phase I)
https://lore.kernel.org/all/20261109055455.536925-1-baoquan.he@linux.dev
* [PATCH v5 01/19] mm: xswap support for zswap
* [PATCH v5 02/19] mm, swap: refactor free_swap_cluster_info to take swap_info_struct
* [PATCH v5 03/19] mm, swap: add VM_SPARSE cluster-array helpers for xswap
* [PATCH v5 04/19] mm, swap: use a VM_SPARSE cluster array for xswap devices
* [PATCH v5 05/19] mm, swap: widen swap_info_struct max/pages to unsigned long
* [PATCH v5 06/19] mm, swap: add a sysfs interface to create xswap devices
* [PATCH v5 07/19] mm, swap: refactor swapoff and add xswap_destroy
* [PATCH v5 08/19] mm, swap: require zswap for xswap devices
* [PATCH v5 09/19] mm, swap: use a stable id for xswap devices
* [PATCH v5 10/19] mm, swap: let the command line set the xswap device size
* [PATCH v5 11/19] mm, swap: add CONFIG_XSWAP_DEFAULT_MAX
* [PATCH v5 12/19] mm, swap: let swapoff destroy xswap devices by name
* [PATCH v5 13/19] mm, swap: add xswap grow trigger on cluster allocation
* [PATCH v5 14/19] mm, swap: add debugfs counters for xswap
* [PATCH v5 15/19] mm, swap: make xswap cluster_info accesses RCU-safe
* [PATCH v5 16/19] mm, swap: prepare xswap_unmap_clusters for range shrinking
* [PATCH v5 17/19] mm, swap: add xswap shrink trigger and defer it to a workqueue
* [PATCH v5 18/19] mm, swap: do not give an xswap slot to a cgroup that cannot zswap
* [PATCH v5 19/19] mm, swap: skip the overcommit probe when removing xswap

and found the following issue:
BUG: unable to handle kernel paging request in swapoff

Full report is available here:
https://ci.syzbot.org/series/88bad2a7-a1dc-4686-80c1-647e34e90e37

***

BUG: unable to handle kernel paging request in swapoff

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      2dc0136b1fdac153434ab02778fcdb32db5d0dae
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/5c923c30-8b6d-49b4-8bbb-014cb85737f7/config
syz repro: https://ci.syzbot.org/findings/f14c26d8-d891-4444-9227-d55cbaf2adb7/syz_repro

BUG: unable to handle page fault for address: fffffffffffffffe
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD ff4b067 P4D ff4b067 PUD ff4d067 PMD 0 
Oops: Oops: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 5894 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__do_sys_swapoff mm/swapfile.c:3743 [inline]
RIP: 0010:__se_sys_swapoff+0x233/0x610 mm/swapfile.c:3719
Code: 99 90 ff e9 42 ff ff ff e8 2a 99 90 ff eb 6f 4c 89 e0 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 e7 e8 72 c7 08 00 4c 89 64 24 10 <4d> 8b 24 24 66 43 c7 44 2f 04 00 00 43 c6 44 2f 06 00 4c 89 3c 24
RSP: 0018:ffffc90003d1fde0 EFLAGS: 00010246
RAX: 1fffffffffffffff RBX: 0000200000000000 RCX: c8af1e162af39c00
RDX: 0000000000000000 RSI: fffffffffffffffe RDI: 00000000ffffff9c
RBP: ffffc90003d1fee0 R08: 0000000000000003 R09: 0000000000000000
R10: ffffc90003d1fd40 R11: fffff520007a3faa R12: fffffffffffffffe
R13: dffffc0000000000 R14: fffffffffffffffe R15: 1ffff920007a3fc0
FS:  00007f5ca62c96c0(0000) GS:ffff8882a7806000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffffffffffffe CR3: 00000001023f4000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5ca53a8f19
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5ca62c9028 EFLAGS: 00000246 ORIG_RAX: 00000000000000a8
RAX: ffffffffffffffda RBX: 00007f5ca5625fa0 RCX: 00007f5ca53a8f19
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000200000000000
RBP: 00007f5ca5437f6d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5ca5626038 R14: 00007f5ca5625fa0 R15: 00007ffce4301208
 </TASK>
Modules linked in:
CR2: fffffffffffffffe
---[ end trace 0000000000000000 ]---
RIP: 0010:__do_sys_swapoff mm/swapfile.c:3743 [inline]
RIP: 0010:__se_sys_swapoff+0x233/0x610 mm/swapfile.c:3719
Code: 99 90 ff e9 42 ff ff ff e8 2a 99 90 ff eb 6f 4c 89 e0 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 e7 e8 72 c7 08 00 4c 89 64 24 10 <4d> 8b 24 24 66 43 c7 44 2f 04 00 00 43 c6 44 2f 06 00 4c 89 3c 24
RSP: 0018:ffffc90003d1fde0 EFLAGS: 00010246
RAX: 1fffffffffffffff RBX: 0000200000000000 RCX: c8af1e162af39c00
RDX: 0000000000000000 RSI: fffffffffffffffe RDI: 00000000ffffff9c
RBP: ffffc90003d1fee0 R08: 0000000000000003 R09: 0000000000000000
R10: ffffc90003d1fd40 R11: fffff520007a3faa R12: fffffffffffffffe
R13: dffffc0000000000 R14: fffffffffffffffe R15: 1ffff920007a3fc0
FS:  00007f5ca62c96c0(0000) GS:ffff8882a7806000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffffffffffffe CR3: 00000001023f4000 CR4: 00000000000006f0
----------------
Code disassembly (best guess), 3 bytes skipped:
   0:	e9 42 ff ff ff       	jmp    0xffffff47
   5:	e8 2a 99 90 ff       	call   0xff909934
   a:	eb 6f                	jmp    0x7b
   c:	4c 89 e0             	mov    %r12,%rax
   f:	48 c1 e8 03          	shr    $0x3,%rax
  13:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1)
  18:	74 08                	je     0x22
  1a:	4c 89 e7             	mov    %r12,%rdi
  1d:	e8 72 c7 08 00       	call   0x8c794
  22:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
* 27:	4d 8b 24 24          	mov    (%r12),%r12 <-- trapping instruction
  2b:	66 43 c7 44 2f 04 00 	movw   $0x0,0x4(%r15,%r13,1)
  32:	00
  33:	43 c6 44 2f 06 00    	movb   $0x0,0x6(%r15,%r13,1)
  39:	4c 89 3c 24          	mov    %r15,(%rsp)


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

