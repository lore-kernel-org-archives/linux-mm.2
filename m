Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20379E6749E
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 12:18:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 554526B008A; Mon, 22 Dec 2025 07:18:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 515456B008C; Mon, 22 Dec 2025 07:18:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44FC46B0092; Mon, 22 Dec 2025 07:18:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 348B76B008A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 07:18:26 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 02787C14B9
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 12:18:25 +0000 (UTC)
X-FDA: 84247009812.12.E2521F1
Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4D8D01C000A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 12:18:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of 3DzdJaQkbAPImsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=3DzdJaQkbAPImsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766405904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=rief4koibS//EOgg16U4TRHGdnZV+IxeLjv0V1PbYuw=;
	b=7PI8VAoAXwUXV2BLs8y2c721357Yv3jwl3ZslAmpMU1Qu3h8u+5m73p6Vn7shP9Ifebyc8
	rmekdYxuaKMR9Sv9LaZcwnrhWzbeSK8HSs+tW8SCHS1ofY57GwKW3EzKMuuZn6OBUYdYqY
	goRL+mezHor5bhxG9xNXKoyIFSVLNtg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of 3DzdJaQkbAPImsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=3DzdJaQkbAPImsteUffYlUjjcX.aiiafYomYlWihnYhn.Wig@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766405904; a=rsa-sha256;
	cv=none;
	b=nR/b3lEHrkX1RvE6hO1Hqed4wMR4kIZqBul10OVZWmQduQOiGMdyheDZ+tVXUyRbwIsjNR
	G1qlxSr0JrORXMpNuHgjlOeQVLX06I/H/ICbTN+jGb36DZ2LK1OQ+ZusTTWt/yjk02Fb05
	Zbqmv+Tv3D3FD7V2DvcADMiNSGOVe+Y=
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-65744e10b91so3477712eaf.0
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 04:18:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766405903; x=1767010703;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rief4koibS//EOgg16U4TRHGdnZV+IxeLjv0V1PbYuw=;
        b=Qb12HeoqYpLGFhTyuawXLB/OwtGj5kvun7c/P1PC71pyCGLlowNm/5v5t/xU5WNthv
         NWjWeTNp/uHibhX70l1mDasuc/hd49HchGtgwhMSEykMTiW/5tv7gdfWhfOfv0YbSLL8
         p6e4F72r4f3WwiX0//Vkx1/tgg/q2PLpJQ5Af28wS9mac6DmdWE8lmJsWd/bIQj7NhOV
         BZtMzLk4nB+pWWkG9EE//Q9YSu0adkWiEW6FoFRjyEl93dh0/zoGq1w808zgAvwfmUGL
         LVw43XcPgwaJswOiahNtatwL91la5CHMgMXNa9EOMC5r6xfKT0Wbl+KfFKVCVVUqD6e8
         kR9g==
X-Forwarded-Encrypted: i=1; AJvYcCW9U+2jJluxEzC/D0jq8ghpV6TBdQhVYQGklOLF10+xWrGbjFEeHCoLaDHpSDT2EG/Z6c0o88wfDg==@kvack.org
X-Gm-Message-State: AOJu0YwjrdOdxfUgxd4O6sTadPNRMIW+iwPWzywB5lEtF3dkXFSaW2WK
	1gagCR3BxMfNHdJD6/MJ34+nhlW47z3wy5spqEQjkVLrLkz16z76Ua08+K+9znHDpe7Yr7Z7cv0
	sIMfFOxkMmfBi3AE41OxjsPtMH0x69Vsw1PKIHKsQ5qpPz3zvzfPXZ+8oLn0=
X-Google-Smtp-Source: AGHT+IHJAeBTknAqZdLgB2cQs9bOeo5V1penQ+v8OvcHKVUnjEiNzgymfcCZNchI8xytL8pDQlwn8Mj4B19QINHIdJygSn9lnR9s
MIME-Version: 1.0
X-Received: by 2002:a05:6820:812:b0:65d:2d2:6d4c with SMTP id
 006d021491bc7-65d0e96d58fmr4143164eaf.22.1766405903359; Mon, 22 Dec 2025
 04:18:23 -0800 (PST)
Date: Mon, 22 Dec 2025 04:18:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6949370f.050a0220.1b4e0c.0038.GAE@google.com>
Subject: [syzbot] [mm?] KMSAN: uninit-value in swap_writeout
From: syzbot <syzbot+178fff6149127421c2cc@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baohua@kernel.org, bhe@redhat.com, 
	chrisl@kernel.org, kasong@tencent.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: i6mysyy1e5m6uc5mzkd5nzzqbnbpkxa7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4D8D01C000A
X-HE-Tag: 1766405904-363935
X-HE-Meta: U2FsdGVkX18vBqMj6KSDR0fyeO2m1lliB6wGkpskCPY50Ym/5zkhyRdI366NubFogcmwrPyJpBW+fS+5Vsln41ed6n4k/KLrBcVsR550f7dWyQXDc5h/f0iQpAtcn1X73jvQYgnIpJ+ZtOLwPkwl66pUEJnArV47nQL/43W1m33Uk7bGRaSEyxuhbW7CikNk5jFqhkyXd+BYTHeNpcBHFdQcrEeuD7lgPZAmw8AjlgLdD5XAXUy/oYWvgwL0KCbHx6dcE7bp/BZozZ9ktm9ydkeCvpefr1fHDxZT7r6+mDq4uoMiPNaWvQjZmf+L3hBe0NilEyFC0ovIzgjRHYx3gJasAFUfjyNHjkncDoQOP1ccPe4tnBCtthVkb9UY5vbjWhNyPP/RxeFJURkPyG4O7AkCSvtZdbnKK8sQQD6IDTTUJTIK6OzcvVBdSkls01qFLyt0Ju2HMDbuVpKd6pkCv7pDCIqLxJpcvLXkefEIv2B07udXyYXYcFFKFCEJyYu7HLCseB/Mw1oPcTDEUcX66xPnHar2AAYLMXiH0hqhSztPRycHzxbe8eBVivdr105K73zolacuCRpISfT65mxExRCQqMCMbTnfcAXYVsXSOlNBdtBrigcxwf80KJETtbAZrRGbNyhdOiH+lJOUYxdE73sSTeKMWq0aCirmtIxmkSwasBUDhOpCCbq92qDN4uxa5AQq+9CR/Cem8U1yCFDiTG8Q5B6oqEkAVPnx3krGpIJnzwLWtVUwXgynhzwrXERr3bHCP4yRRWFlN7wIKKRpwCNcMF1enLRXTe9eAMqcfgxJ+CK+UlCss3bASKxx2M66snTSkNCuOXqKbEc0YeFruWwZBRxj3kIrjqQW2ZLUkPt290tnM8UDTtvx/QA0tHSp2kOJHb73jh1CsNL1/B7VBHTxOdqlv2xjG/2XIKAPCzeC3bLmgjqUKMTYHWdo95/Noz2hlWIWpWe29S/gBZh
 OXjyx88s
 FAt3KTojxbZWjJM+uj/xDYKeOpkWWGEfpl/sRuQjyhxnamNqnbNpcERtgLng505JqXdVUmjigG8bqVwDA7Gn0Lx92vxOaAZxtb3JsO8ubYV6HsVuy4lYyrmmomn+3pCV3xg8UE4jUgE66kWU1we1SLaqKz4417/iq967qWOPWCMyyE1VXF6yI65c+dLx20b/bnBQyp+nusHWNMaJwE49dETI1UvKERZB8F89oLXD54n26O5x3gdnHHNhYfkjQ4W4DhzRXP2abOr4QccBGl0Veh2rwVDvmJEWBw+fqOZmF3hTidC28irAqzMOUslxY64KdAtJ6e2X7+wk6CWRhi/Q820Yks0oOHHyl35x6k7c1wBLLr1T2r1pb+QHwSrT4SngUP012QggbtBHqXWcmADPXfGzlbNiBwKjNsm7XoVYjte1fgXCemN8dUFrAHZ5KLpWgu70HPzUokCF4XuSq1ux1Vf3l+kWjw0Jtp2a7zygU/QbcjbnV7n7koe2WwEp1ofbFyhhD1KtyofCl2rSUhEA/VHZL7IqiKndUOoWpTPl2wY3yXvCEQ1h00o8kcbiD2OKU66+6tba1Gt1pusg0PhxVu14PWthPfQxDJJTzxSq5Jw6C1XuLUIf8xPOIfrLmywSJvuepcc+vhE4B682PRLj5gNBon77X534cEF7QHpomfRCgt7GkjzOZaLy2EEZcTbadU9OCv0UFlQp103A/SUCV5QQ2BOkGUKmJhUPN0uc6GJgW7Y2KS6SRbvlDuX1VIZFlWZWYt8bfXR4efDdcr7uR3C98BsB7m1dSsoVXLJ9khDztbUoxvhxCB7FB8o077+A96SdmvBaSSv64dPXZ2QjHjH+gXu2PAAzshjI7xieMTOmCEcVFUWMd06Bi8uMcelgbwcCfwWCkgJr0BHHEEAh2MY3gkA6Kr2vlguExat+ptj5iTz2k0keMgrIjtZSK3eyS6Ph63omovQDK6HdziZt4Qm5uC/zP
 ko9PU/sM
 j0Dlwce9kT1+y9cwLY+jhyu6hlFo4se5xVyTyXrJHfSL5hzikYFaxym9JNMPbr4GldFUOhzChxoH9DsSuHcV7JV5AEPsqO8EWHqSm3kKraRpXhWww+UW/jm1//7A5fksCJim36B2xk9a+j5qOqs3kz2VdpSL3y5mfAHyGjtjrqFn6qGfcLEHKvpjBnoQ4hwnDS2jW4UkbZFazSNHjCsggqTFnegIp+0iksuPhtzsM9KPpNtc+y3UR95d57Zg4FYK/grZgMzoPBM3eCJI1sSYGe+hMR9m7ttBft00kXDxWi0e5BWdthUBqZqIVryBBvUVQhO335zGDZ2V0DwvU91T3CacAqRUIqbQNpdjOTxh96hUQVwfUNJfHNARwyFssAkG5xmorhDHXpJrJmApUL9BJDX9UupNPKNJ+SsRydcNw0c3RmGPYVhn2rRfbG7H3Ic7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    ea1013c15392 Merge tag 'bpf-fixes' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11d2e31a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b3903bdf68407a14
dashboard link: https://syzkaller.appspot.com/bug?extid=178fff6149127421c2cc
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/27172fba4316/disk-ea1013c1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ac8c65aa1d08/vmlinux-ea1013c1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/42241f684d1d/bzImage-ea1013c1.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+178fff6149127421c2cc@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in is_folio_zero_filled mm/page_io.c:188 [inline]
BUG: KMSAN: uninit-value in swap_writeout+0x468/0x1390 mm/page_io.c:263
 is_folio_zero_filled mm/page_io.c:188 [inline]
 swap_writeout+0x468/0x1390 mm/page_io.c:263
 shmem_writeout+0x1abb/0x1f60 mm/shmem.c:1662
 writeout mm/vmscan.c:649 [inline]
 pageout mm/vmscan.c:698 [inline]
 shrink_folio_list+0x5920/0x7fc0 mm/vmscan.c:1418
 evict_folios+0x999d/0xbf30 mm/vmscan.c:4711
 try_to_shrink_lruvec+0x12b6/0x17e0 mm/vmscan.c:4874
 lru_gen_shrink_lruvec mm/vmscan.c:5023 [inline]
 shrink_lruvec+0x46f/0x4f10 mm/vmscan.c:5784
 shrink_node_memcgs mm/vmscan.c:6020 [inline]
 shrink_node+0xf1e/0x51e0 mm/vmscan.c:6061
 shrink_zones mm/vmscan.c:6300 [inline]
 do_try_to_free_pages+0x849/0x26b0 mm/vmscan.c:6362
 try_to_free_mem_cgroup_pages+0x3ae/0x950 mm/vmscan.c:6690
 try_charge_memcg+0x80f/0x1c50 mm/memcontrol.c:2388
 obj_cgroup_charge_pages+0x2ed/0x600 mm/memcontrol.c:2823
 __memcg_kmem_charge_page+0x14a/0x4c0 mm/memcontrol.c:2867
 __alloc_frozen_pages_noprof+0x3ba/0xab0 mm/page_alloc.c:5227
 alloc_pages_mpol+0x328/0x860 mm/mempolicy.c:2486
 alloc_frozen_pages_noprof mm/mempolicy.c:2557 [inline]
 alloc_pages_noprof+0x102/0x280 mm/mempolicy.c:2577
 io_mem_alloc_compound io_uring/memmap.c:30 [inline]
 io_region_allocate_pages+0x164/0x900 io_uring/memmap.c:165
 io_create_region+0x6d0/0x830 io_uring/memmap.c:220
 io_allocate_scq_urings+0x1e3/0x8a0 io_uring/io_uring.c:3379
 io_uring_create+0x7b5/0x1040 io_uring/io_uring.c:3643
 io_uring_setup io_uring/io_uring.c:3718 [inline]
 __do_sys_io_uring_setup io_uring/io_uring.c:3752 [inline]
 __se_sys_io_uring_setup+0x3f0/0x410 io_uring/io_uring.c:3743
 __ia32_sys_io_uring_setup+0x76/0xb0 io_uring/io_uring.c:3743
 ia32_sys_call+0x2c57/0x4340 arch/x86/include/generated/asm/syscalls_32.h:426
 do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
 __do_fast_syscall_32+0x15a/0x330 arch/x86/entry/syscall_32.c:307
 do_fast_syscall_32+0x38/0x80 arch/x86/entry/syscall_32.c:332
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/syscall_32.c:370
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

Uninit was created at:
 __alloc_frozen_pages_noprof+0x421/0xab0 mm/page_alloc.c:5233
 alloc_pages_mpol+0x328/0x860 mm/mempolicy.c:2486
 folio_alloc_mpol_noprof+0x56/0x1d0 mm/mempolicy.c:2505
 shmem_alloc_folio mm/shmem.c:1890 [inline]
 shmem_alloc_and_add_folio+0xc56/0x1bd0 mm/shmem.c:1932
 shmem_get_folio_gfp+0xad3/0x1fc0 mm/shmem.c:2556
 shmem_get_folio mm/shmem.c:2662 [inline]
 shmem_symlink+0x562/0xad0 mm/shmem.c:4129
 vfs_symlink+0x42f/0x4c0 fs/namei.c:5514
 do_symlinkat+0x2ae/0xbb0 fs/namei.c:5541
 __do_sys_symlinkat fs/namei.c:5562 [inline]
 __se_sys_symlinkat fs/namei.c:5559 [inline]
 __ia32_sys_symlinkat+0xf5/0x180 fs/namei.c:5559
 ia32_sys_call+0x385e/0x4340 arch/x86/include/generated/asm/syscalls_32.h:305
 do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
 __do_fast_syscall_32+0x15a/0x330 arch/x86/entry/syscall_32.c:307
 do_fast_syscall_32+0x38/0x80 arch/x86/entry/syscall_32.c:332
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/syscall_32.c:370
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

CPU: 0 UID: 0 PID: 7862 Comm: syz.2.517 Tainted: G             L      syzkaller #0 PREEMPT(none) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
=====================================================


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

