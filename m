Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD377CD98F2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 02:36:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D2B86B0005; Fri, 19 Jun 2026 22:36:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 982B06B008A; Fri, 19 Jun 2026 22:36:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89A9F6B008C; Fri, 19 Jun 2026 22:36:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5DD6A6B0005
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 22:36:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C17EE1205C9
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 02:36:34 +0000 (UTC)
X-FDA: 84898727508.13.BC5FF13
Received: from mail-oi1-f206.google.com (mail-oi1-f206.google.com [209.85.167.206])
	by imf23.hostedemail.com (Postfix) with ESMTP id 23452140003
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 02:36:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of 3sPw1agkbANkNTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.206 as permitted sender) smtp.mailfrom=3sPw1agkbANkNTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781922993;
	b=gf62TKQ98152vqOEoHDoZP4JI5zSsNcWx9yOhLWcPTC7MWdjKMdTGnHqhDDPLFSTGBiAfg
	xePHi5MIL5QifZT+PJSZCFUtckH2I3B7FF8rabhCCmyAZRWkgPVfd1eSDmiCa7252R4Lrg
	YXLtrP8WIHrdN4FlnqDg9BD0gppNUY0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of 3sPw1agkbANkNTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.206 as permitted sender) smtp.mailfrom=3sPw1agkbANkNTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781922993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=Bs9CejVkt7nV7CDQU8YSZBGFYo+2nll6l7lLcfg/z8s=;
	b=v5Sa/myazA45oZqk8NZCOZYX0TEmbOpI5zN4XJ0rhQmw9nZngVODS0RoRkRRWH5+KMeMSd
	bMp/drO3SuJSGH3x3cI3A0rDuvffDQ8WsHBmTl9wslshGlptxchSwpEyP8B/FNkna3D35p
	Cp5gcCDR5l7dah0g+Q8EDDHYsRklPVU=
Received: by mail-oi1-f206.google.com with SMTP id 5614622812f47-48aa4e64046so1180381b6e.1
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:36:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781922992; x=1782527792;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bs9CejVkt7nV7CDQU8YSZBGFYo+2nll6l7lLcfg/z8s=;
        b=gJd5/AjwOeF+mHR5SXfr3DH6WUpe/rFDbVFrz/n+jF47qq28i4Exz+pdUFgfrHYwrq
         CwUTuXU/1aB9Xo6jLIufk7DAU+lcgWdCTIJdQ2Tw1FAaMBuhpoJoPvxc8lt+q4EBb60T
         cN4XeXeppC9MncFo74PqE0fQLo9ayQ4ICSpTvPeARUtJ714SqNk/gYqxhEnnGhmjyFSz
         7XiDuOInWtuUIu6UU94EzkQuynTF4gPi7edlhiTN4rkP5CPRqX/06Z4Ywy4rO83TVMSg
         o8ymdcpqJYe3XPChtBTwI3JBAAmjl/ezdER2mOqR3yF5ryaI5m8k7x3d2j8lGBAwoYlk
         xe0w==
X-Forwarded-Encrypted: i=1; AFNElJ8KNJSiRH7YXgz7mla2EuISlwhpboQR1uWzmSKN7RtSQPTu6Z0bdoKDADIaSBMvLBCG3Fwr3TvTog==@kvack.org
X-Gm-Message-State: AOJu0YxQcOwIWQIqE92q9vncJo3UG4Hn39Hn7LIci++mDC4d1g2hlOnA
	e9vUwBJl1e8beRFpmtzbf3hM782GaIex0P6U4MOZTqGSFtgjAOeD1zmZrnC9w+KVvI5Wpn8s1zN
	uMA9ENh7W2fQenP37YUCtsXxa9pvUnW9pDo6yaZ2x2kVEhLcfu/Xj7Rsz6fw=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2519:b0:48a:a6d8:890e with SMTP id
 5614622812f47-48aa6d88aaamr2026959b6e.41.1781922992185; Fri, 19 Jun 2026
 19:36:32 -0700 (PDT)
Date: Fri, 19 Jun 2026 19:36:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a35fcb0.6813c476.3c3d96.0003.GAE@google.com>
Subject: [syzbot] [mm?] KCSAN: data-race in __anon_vma_prepare /
 __vmf_anon_prepare (2)
From: syzbot <syzbot+395b7abe9696862fc188@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@kernel.org, harry@kernel.org, 
	jannh@google.com, liam@infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, riel@surriel.com, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 23452140003
X-Stat-Signature: kh5t3ku7gw3hyfgayffx3jjmdp7mkufg
X-HE-Tag: 1781922992-520455
X-HE-Meta: U2FsdGVkX1++N/ToR3872AX7LF71AqiI6rmSC+2YyR5Upme+Hf+biwDyBaD8qPKALKOkZtXSC5B4g2F4m8g4cKWDB4s6sLRwUnmx5aKoZRGo7C8q02j2nOjIdu5l0lOGpX+0vS9vxVJ4rgvpn39ujaWiC3q14VUQls2Gp7rvBePyY5gysHYTV1MhyJdp6tDiS68yDhD9+D75ns3Z7PHiTPByvERailLFayOwOo0l5M8BFdzKbK1m8Vs4B7PrxrBupV15GB7QCdrMI0aw3LtqaELR+vuNypkEBajISN+3yaHpQssIl6TrvexKnie1Lr8d1XTozLUhGyqLrxpJpEsVn+EHUQgygdalqWa99w9u4Dlm/YogD6h4mBnncdn3smpkDn/IvW5mupVVOSlqCVjxr/nUi2DGeATdgeUsJMZyl8SRmJ297W5Alxr2NHMUH12N5pl8u1n0xtifIg4kXdt28+sljcdM7I44PzRVE8Bdkn0rKeWjNBNiRWFYuOFcU7wGzPi+s0jBbgIUelKh4ZRUxq7+/0Ch3z7PQHeMs6Hr9HGv4KgOWNfb7wOwaSZfa8oE7LXrfaIlJ745dGq+pZXGcZQOtJCJXSLeZ6pD9jOuWcutp+dG+n9iux0nku6PGD89q7Yv2cw2+dR4/hudN2Wa05AfPGoFvcVl2FqLHsPFqeWPsjGiUSVxpPgxmaa2vKragLrOS5laM2mhpMR+grKBbkpoYCIhFjS5l9DvTiRzIzC6tLUkj21B94jgkj2M+FI3kJcq9enT4FQgPCC5KYKqWmYi8IuPyZFVsz/qhABDbOfzrb3EREASAMUEgoIXi5kwy1gwXp5Q5KDvUVai8wYEIh4NwwDYmQKpPuBOEUFYSv/s8C8p7grKfOyw9dRx7cJpBQ0xEm05rdCrke1ST54ZLca08JGbc/e2b9z9t1Z5DW3n0TgHySWGEixGUClkA0cTagklhNRdtE22p/0F1ff
 haOfx1JM
 OJRs8Q7dHuWEtGfdEzN8R0ul6FWrgTImFMEEQusYLfUNg1dQq3FZBJb5zm9eeVQ05rl+8W3iMuvyDY7qd6xlES8gGy/xU3/sTdSUMvqAQISL0z1svEi5B93/sELhTeLUBXvv8ufwXUSNtqrNOXRIR35dFkppeBf/rzSfmAX220ODYyE39KZKAuiN9TPmFDq7ixspePSy6HJiBF6qdfPpSaaoF8Uw90GyRmjZGcCoyUrNurE+JPrs+B7ChmjKSKRsoOQbI9g899WgjI2hRxrYBDKzQCr1DC6flWR/zwYovbWrqXA60Vz6KZ8zTh6f6mCtom0VZoEi/zrc+kNu2SFb3/It8snwXQGvuILlBnVHxEckhi2zA6ttMhswhUlpH9hkbtbL2QEj99j8JzqIEzVCJoiCvtztfd/YfCySxiHwx4s91m0//GHBUpYNnEshXJXrplrknXz0wiUbyCy8QA2dBiS8ZgyzkrauU6OgoPlU75x2Rb+wbgIz1zNRlIlmRZWxgcCmf9ncYN/Qjfdm7fqNED815OsVL8ji+FgFn3fKYl7VrueRPE5DP33VVddRN3mhUkVPbQVD9LMOfBisVGT30gWNQ1H7TNelGegOv5g04hkuZV6zH5VY1cPrqiQmlG7F0htT2ord4pJzTMlWJC51QFDDtvPpIsKbAPFk1hxeSh+P1vz0XltIIA2eP9by+FoVnkvCAFXHoy3lXaqLYCGbzvYccadzT9Ai1wslMqQtAAv6DMBgApmF45vcFYcBebjvztUEIqoJ6XWwg0CE5o6otmOjP1XR/WPxDZRMgTBK9knSLuebLUi4swW286RjNMXquA1rNFLCV+U91nTdGkmvgSWibFNv8Xne8o88Bb3jYZPIFDG85+fG9bGbNOM90L8gCdO1vHRRuHGpFBqDoieXLubn8bIBN7qVKINGVevgo0Vt/jzGo8zjn0/juyvG3mqLlfTeUd3Mq4zanyci161ZEVqZjsfSs
 o+M9Ax8X
 rWRhVWR0Z6IyARxLR+lYWbBEJbz0Qp1Hc6l9xueE5U3e+jGHY4vp9JmyK54sWpYN66O4ABIhJFHd4sIBuU+x8KaAXHzJJ+2eSVm0Atziv/DxH+tPPjURDBMnhLRU3JRC4ln1OqUX8CFKPgR16Y6D6jZeYJFwSFE1rlAtWVuLGBXF1zC7fIjnV+w9nAm1B01xoX4/j9kLXw6ip46+ul5nmCxfKRRnhfBVOuljiEkZdy3o+B04ga7rW9OYHIi7Ymq54V1CNzlJmW6Ga3Bt8elVA3rE2fcg+VY+N9yuWwepFTG7rw39j3uZMfRtKN9F/yWRqfoHE/IRQTaH1podScZiRbeixDXGWmX8dfYhxpMDudKSHqP4Y2XvgNrzPcuT3DS+SHDOeaLuPiXmJXBDIIf9Wju8d8svF1ODNA88H8rsm8mf9K9HjDMxGDDaAkxF8GPn2i1iiFA9Byw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    5e2e14749c3d Merge tag 'landlock-7.2-rc1' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10e5ccfe580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b0ae27ce66b92956
dashboard link: https://syzkaller.appspot.com/bug?extid=395b7abe9696862fc188
compiler:       Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a565c60a4762/disk-5e2e1474.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e593a6eb0057/vmlinux-5e2e1474.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d24b55020ea3/bzImage-5e2e1474.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+395b7abe9696862fc188@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in __anon_vma_prepare / __vmf_anon_prepare

write to 0xffff88811a6a4d00 of 8 bytes by task 20911 on cpu 1:
 __anon_vma_prepare+0x172/0x2f0 mm/rmap.c:212
 __vmf_anon_prepare+0x91/0x100 mm/memory.c:3829
 hugetlb_no_page+0x1b8/0xf30 mm/hugetlb.c:5756
 hugetlb_fault+0x608/0xda0 mm/hugetlb.c:-1
 handle_mm_fault+0x1de9/0x2da0 mm/memory.c:6684
 faultin_page mm/gup.c:1126 [inline]
 __get_user_pages+0x129c/0x1f10 mm/gup.c:1428
 populate_vma_page_range mm/gup.c:1860 [inline]
 __mm_populate+0x242/0x390 mm/gup.c:1963
 mm_populate include/linux/mm.h:4171 [inline]
 vm_mmap_pgoff+0x23b/0x2d0 mm/util.c:586
 ksys_mmap_pgoff+0x2c6/0x310 mm/mmap.c:606
 x64_sys_call+0x14df/0x3020 arch/x86/include/generated/asm/syscalls_64.h:10
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x136/0x3c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

read to 0xffff88811a6a4d00 of 8 bytes by task 20901 on cpu 0:
 __vmf_anon_prepare+0x26/0x100 mm/memory.c:3823
 hugetlb_no_page+0x1b8/0xf30 mm/hugetlb.c:5756
 hugetlb_fault+0x608/0xda0 mm/hugetlb.c:-1
 handle_mm_fault+0x1de9/0x2da0 mm/memory.c:6684
 do_user_addr_fault+0x402/0x1060 arch/x86/mm/fault.c:1394
 handle_page_fault arch/x86/mm/fault.c:1483 [inline]
 exc_page_fault+0x62/0xa0 arch/x86/mm/fault.c:1536
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
 __put_user_nocheck_4+0x3/0x20 arch/x86/lib/putuser.S:97
 ____sys_recvmsg+0x1a1/0x280 net/socket.c:2917
 ___sys_recvmsg+0x11f/0x3a0 net/socket.c:2946
 do_recvmmsg+0x1e5/0x560 net/socket.c:3041
 __sys_recvmmsg net/socket.c:3115 [inline]
 __do_sys_recvmmsg net/socket.c:3138 [inline]
 __se_sys_recvmmsg net/socket.c:3131 [inline]
 __x64_sys_recvmmsg+0xe5/0x170 net/socket.c:3131
 x64_sys_call+0x80f/0x3020 arch/x86/include/generated/asm/syscalls_64.h:300
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x136/0x3c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

value changed: 0x0000000000000000 -> 0xffff8881020cec60

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 UID: 0 PID: 20901 Comm: syz.0.4316 Tainted: G        W           syzkaller #0 PREEMPT(lazy) 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
==================================================================


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

