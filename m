Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C05081098781
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E19B56B0088; Fri, 20 Mar 2026 09:17:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCA396B0089; Fri, 20 Mar 2026 09:17:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDF5C6B008A; Fri, 20 Mar 2026 09:17:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BFFD76B0088
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:17:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 764A51A01C4
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:17:53 +0000 (UTC)
X-FDA: 84566494026.26.C764BFD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E05DF180011
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:17:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CtYoB3y3;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774012671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HlmfTtyiH5gdbbADDpPY8SlsXeBHiWyWEiFnhuAEVDI=;
	b=OppsPJB6Sv8kVjtSHj0157O2jEE9ZLFkgJBWNQY47Lw/9R7DRUpLX+lq/kAP+U8Sa8rDXd
	66ifAGV7l+6IC0d5NK7mUd9rc26DGLPM74wxGtxhydG2/xnJa/N3CBgzFUloBgQK7lyhaa
	x+UGoZUkKDktSZ2u/7pvTjTPM7zMsuo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774012671; a=rsa-sha256;
	cv=none;
	b=7wxa2Umop6hIIeh4BkU0zJet1KawGrSN5Kc74mXPU+yAwkAdW46E3BghQNt9a4XKudYt7Y
	4lk/uX1p98ZkzCQlJ9wpExfi7QEdcSf0l0MyNexYvyS+zi661EwGTdB30qKGTTTGydPEuc
	Hgx/YcexrcODvQyg6dnB+yclPUG86qU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CtYoB3y3;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3936D60121;
	Fri, 20 Mar 2026 13:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6014C4CEF7;
	Fri, 20 Mar 2026 13:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774012670;
	bh=sS5dUb8WPlOcj7M/qOAafAQepwZu/bfgqgNiCm6w+8Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CtYoB3y30j9TjJgMFoD49UfnFLrlSld+STHYXHy0kRMzHdzwtT/+xIxEqfftEBSnz
	 3DqkuE1x+k/A+eqjJuNUH+8+FQUUeKhqsCUNx5hufzBFednrY57n5JiYHeWuJL8o8n
	 GLPeDzmo8D4o2BU8f8LAMYufwoaoeVM1EMyR1D356Q5Cl3dHUFS+X4G5Bfar5rZAeV
	 VKHu3CuUGXHAKpS5iAWaGPe7Hf4xtXCa/QtNcWKn5WEv03mICCkIpDvlqFsaMZW3f5
	 ElHConVDeXdd/GvU+HPLu0UnNmdW2DJ1J/WWP9bUN9ogq1szr8uIqhNrOQzulA0thG
	 3E2mZfQpyGCUw==
Date: Fri, 20 Mar 2026 13:17:45 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: syzbot <syzbot+8961cb270ae74b4129fb@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, lance.yang@linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, npache@redhat.com, ryan.roberts@arm.com, 
	syzkaller-bugs@googlegroups.com, ziy@nvidia.com
Subject: Re: [syzbot] [mm?] kernel BUG in collapse_scan_file
Message-ID: <6ff97738-33f9-4450-adf8-c3cf251d82c7@lucifer.local>
References: <69bba3c0.050a0220.227207.002b.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69bba3c0.050a0220.227207.002b.GAE@google.com>
X-Stat-Signature: nwp8gdaatz6b5q9w7c8wxzn6iux7bcy3
X-Rspam-User: 
X-Rspamd-Queue-Id: E05DF180011
X-Rspamd-Server: rspam12
X-HE-Tag: 1774012671-549526
X-HE-Meta: U2FsdGVkX19s1wlPZP1qscfV1h+T1fUD0ajx5F+P35a9mzRhh+58ohVE8rklBV02S9NgrcSyWb9vJv6JK2rTcCmhyLQdMR/t76kkizq7d6uj3etRsaCI7WfZsdYk1BL1017+w5MeRx8+Hmc0zyu29pmKHaU+ul8iVxYITNFocEmMbwoMWsHaNfIEUYMwAczAmoHLfHgUg1TWVro2t63EPvgxmzWFRtlkQHnHw0AwKuMVEtvX62hj9qONiQ3hyj4VyNxrCnsm0GyUDMxZ1BA3Ez8Uwt+85IN/7pf+e1nM/viJklKcS/674QBXR9r2P8X7etSna5r1TGAgmiwXANIgdRvtG0rYaUWbIZbBHtCNXKSSPPYUh2IHQy/X0tnUz+DCP2ag5g8Dv9s5sxljtfhAwxoacsJf95tCF8txlWsr9k7GwKgmdf50LOu3x2eyZl32kQNENFQu7C79Wk2TIciZ7VW9iavr7EGIaOWeFEq6j+nhtRCSA9vgoOtJ7wHQzJsVsC7rsdD2yCrF78xfGGWCfDAfuuLed6Nz8v55q99Q6qkBGyl/TyQltPL2zzKFdrTxYJ7EKNY7Ge6cTuBFWQTefl4EjJGxyc9tm7tHXjsxzNWqe7qtuZUyOq/LmzwFRFqS5kN+Fu2bzfhkqHTVIcbzkeHoACMPeyomLNscXjPbUE4f/xSV4gwIGPd0HJesdxBDO7B6gv02ZkXRv6gSX1FoyauqNbO1/E1BS1qK0Pw4iaDLSlVxCDmnsE6UyqMbfR2FpvVP7CUzwdMmW9Xr9qwnJe9IXNS99iZnIcIFoIG7VZgRBRNyRZBjSbEuahNqaAnq3ly3XdfHNcLZVAbc3SE73c2jz/q2RemO/prutQWb7NX1/abp9Xh41LV/VA10MPsR1D1Yj6keis/uLhMfEZoosJYmzfpj5wgRWh492z9bC0Lr3vTN4go6O4Od/rJK8TVAy4IpJ2Pd1foR7ddKOoX
 YcCNy1iq
 F/jMDRpsYBpx9mQ6BHf7NDRf/OSgaw+TwrtZ68nITAPCzrUrvwBEcMkD3G6z1okzacSVq9h4ctyUU+QSrltCI2UynW++tLqd8vCBBt7h5dmYnFv+uoQL9h25llfRaeyznzIE8DE83wiBKIqyMscB0meGba2VPWAPviwalmGZfU1u5fBq9h0JQ+q1NN3ToaDmGJvnQXtQkhXMfSzQYErzjplhZzayekiR9VC0tOUplEdW0zS+jkLaI+2ZuVpAeXMXby0XjK2XqRB4LBBkEGGvvC4KKvxOyivnu/ny4t75RknSkRoIrol08WRSm6O/VUOrdgcIMXKMaVKQ7TgX/GpFYu72hzI/30PfbAIMgupDetjwF4P6Od6Mcz49nnYKxAeHKNXRnwSd7auAP97RHnaAOPdi02xRDSuxo7Cjg6zsGR2pPI0IsOMrfdQtJcLN0a1e3fddDLA40R5bgEDt6eS3jJSbvpW7rpJZplTYl9bogFsCgu8JsJoiNbq49vnRDpUSt4Pvr0UzNK4n6tKDpoF653Jn5hXKtQu0jcfrnaetL0ja4id6PKdRpouOjcj3oG1y4TgBXM4TWjVyh+/gyBEejWJCGu9ZVJSciWqvTO8B1b9Lx45sGFOydTyVbOPPdlLvWHAOwb3rxuotXQaUnRn+CL47qq+ejoqall7wQw0h9EeDURx0xjxCOUP2pSwGdShiuawWi6P8to9o4oIQs/dfdiKch9/KAXrYwgQH7u6X+S3Gjly3JP13w6X/Sbk1j3HOD8VRQlotZpl1+iD/F3EXDB/QnMNyqQ4v6MHiSTFQToikcDrNrk5EGUNOVbhmB1gL1Ai8DcQNrxwWFPYDB5xpEFZ5AHUruQZ11xTjcnIR+wfilp0gOYejjsAWY8ZII5tS08jAHxM2zgtdNOyhE41r3nPO9uVCWLiEGnAppHsHeTuoiq2910s20qgJ/xjJY8puHD+51iQR1YpnugA900pKnH9kA155r
 +EjVC9Q5
 6donbXmRZjjrNoBXnoLqz8/5GPNG2PU2PUken/KA6gyFN/nI5fiz27sblkjRokgC/zeVvOxq8baB0XkocpERzbtLVjuvWTkVlkegPZYXsJl76LDZD9aVEpPoZylN5NCuytFh0dbv0iI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 12:20:32AM -0700, syzbot wrote:
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    95c541ddfb08 Add linux-next specific files for 20260316

This is pre- Mark dropping the xarray thing from the tree....

> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=15ccc216580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ed431987028345c6
> dashboard link: https://syzkaller.appspot.com/bug?extid=8961cb270ae74b4129fb
> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f778da580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12cc006a580000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/c40f27ad73d8/disk-95c541dd.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/bd811888f684/vmlinux-95c541dd.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/3b72363d7dbd/bzImage-95c541dd.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+8961cb270ae74b4129fb@syzkaller.appspotmail.com
>
> node ffff88805d558b00 offset 0 parent ffff88805d558840 shift 0 count 3 values 0 array ffff88807a8195c0 list ffff88805d558b18 ffff88805d558b18 marks 0 0 0
> ------------[ cut here ]------------
> kernel BUG at ./include/linux/xarray.h:1441!

...Presumably the same potentially broken xarray debug we were discussing in [0].

[0]:https://lore.kernel.org/linux-mm/69bba3c0.050a0220.227207.002b.GAE@google.com/

Cheers, Lorenzo


> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 6001 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
> RIP: 0010:XAS_INVALID include/linux/xarray.h:1441 [inline]
> RIP: 0010:collapse_file mm/khugepaged.c:2055 [inline]
> RIP: 0010:collapse_scan_file+0x4f98/0x5230 mm/khugepaged.c:2404
> Code: ff 4c 89 e7 48 c7 c6 60 b2 dc 8b e8 82 62 f1 fe 90 0f 0b 48 85 db 0f 84 03 01 00 00 e8 71 e5 8f ff 48 89 df e8 a9 20 7b 09 90 <0f> 0b e8 61 e5 8f ff 48 89 df 48 c7 c6 60 b2 dc 8b e8 52 62 f1 fe
> RSP: 0018:ffffc90003826e20 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff88805d558b00 RCX: a13f20bd39c5a100
> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> RBP: ffffc90003827130 R08: ffffc90003826ba7 R09: 1ffff92000704d74
> R10: dffffc0000000000 R11: fffff52000704d75 R12: ffffea0001b678f0
> R13: dffffc0000000000 R14: 0000000000000000 R15: ffffc90003827010
> FS:  000055557e3c2500(0000) GS:ffff888125437000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000020000000b000 CR3: 000000007ac66000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  collapse_single_pmd+0x22b/0x4510 mm/khugepaged.c:2437
>  madvise_collapse+0x34c/0x820 mm/khugepaged.c:2859
>  madvise_vma_behavior+0x1094/0x4460 mm/madvise.c:1362
>  madvise_walk_vmas+0x573/0xae0 mm/madvise.c:1711
>  madvise_do_behavior+0x386/0x540 mm/madvise.c:1927
>  do_madvise+0x1fa/0x2e0 mm/madvise.c:2020
>  __do_sys_madvise mm/madvise.c:2029 [inline]
>  __se_sys_madvise mm/madvise.c:2027 [inline]
>  __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2027
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f90d419c799
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd50711398 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007f90d4415fa0 RCX: 00007f90d419c799
> RDX: 0000000000000019 RSI: 0000000000600003 RDI: 0000200000000000
> RBP: 00007f90d4232c99 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f90d4415fac R14: 00007f90d4415fa0 R15: 00007f90d4415fa0
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:XAS_INVALID include/linux/xarray.h:1441 [inline]
> RIP: 0010:collapse_file mm/khugepaged.c:2055 [inline]
> RIP: 0010:collapse_scan_file+0x4f98/0x5230 mm/khugepaged.c:2404
> Code: ff 4c 89 e7 48 c7 c6 60 b2 dc 8b e8 82 62 f1 fe 90 0f 0b 48 85 db 0f 84 03 01 00 00 e8 71 e5 8f ff 48 89 df e8 a9 20 7b 09 90 <0f> 0b e8 61 e5 8f ff 48 89 df 48 c7 c6 60 b2 dc 8b e8 52 62 f1 fe
> RSP: 0018:ffffc90003826e20 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff88805d558b00 RCX: a13f20bd39c5a100
> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> RBP: ffffc90003827130 R08: ffffc90003826ba7 R09: 1ffff92000704d74
> R10: dffffc0000000000 R11: fffff52000704d75 R12: ffffea0001b678f0
> R13: dffffc0000000000 R14: 0000000000000000 R15: ffffc90003827010
> FS:  000055557e3c2500(0000) GS:ffff888125537000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f8156602000 CR3: 000000007ac66000 CR4: 00000000003526f0
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup

