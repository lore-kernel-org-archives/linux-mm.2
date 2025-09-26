Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71AE0CAC5AC
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 06:44:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595508E0002; Fri, 26 Sep 2025 02:44:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 545A88E0001; Fri, 26 Sep 2025 02:44:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45BA88E0002; Fri, 26 Sep 2025 02:44:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3211F8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 02:44:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8509C05A2
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 06:44:32 +0000 (UTC)
X-FDA: 83930462784.28.D0D7357
Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	by imf09.hostedemail.com (Postfix) with ESMTP id 192CC140006
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 06:44:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of 3TjbWaAkbAGERXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.78 as permitted sender) smtp.mailfrom=3TjbWaAkbAGERXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758869071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=ML2Io1cPjRbrmnvCa63vi8bMKEa3pezrQiaB8ZHL8bE=;
	b=I3BBCTxfeQs/EVXkpblZMDgxuN4sVzCkeaN5fLH2tx7e3tZR2ksv47OJ7O4ohZL0a+G8hv
	a4q42VXknZgLEaSj3F777mmKJkGYTMHusl8Gh++znvrqeGY7nKYkbFHAdQkjwaecmSpW/r
	MOPE0nLvL8Db42KfVcsKYwGB4Ms/6aQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of 3TjbWaAkbAGERXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.78 as permitted sender) smtp.mailfrom=3TjbWaAkbAGERXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758869071; a=rsa-sha256;
	cv=none;
	b=7n9L36pSUIHVm710qzRGFxEtSPcGzV2sUWKSj5bzhjbo8yGiQlduYAHIz10N5KJFNRdF53
	DM4jQFRNxkxILKR4IloJu15hBvUO8kSG6/hqGmWSfQXQRMUF+AWYUn6HqrHAIOiTqUfWm0
	EwuJWJatQ7YvFs/t0fDGWzwc4Te+fD4=
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-90efeb58159so67142939f.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:44:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758869070; x=1759473870;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ML2Io1cPjRbrmnvCa63vi8bMKEa3pezrQiaB8ZHL8bE=;
        b=Y0kyjG2tudpItg8qGe3X05kp75JqdiA1rbHja5pzBP6CSuFLIIRc2SbcboGyGD7HCS
         NjcEMYjj25tojcgSEAtFyn7N6r4vxWp/8oqm6+zTn+zF2Zx1O4l8BWbE1SvhUi+z7q8T
         B+eQoAfLyDEL3zjFvt0T+QfCkb6l2Gb/aZh1LAzjQDa61zaPXDosQN8LxHwLqoFSVqG0
         zJR7KnV55DvXD6MfF3uN7e6bx6pNM8JzZbcctr99MSqYWWWqRAWff4lxYPNpY0Ce2fc2
         hnAz5Reeygp+qt6rp2T4PYUQn0a6Vhzs5FRZzLqiqC6u5XeIYgTe9ghzTGZXMDVu0nej
         EMPg==
X-Forwarded-Encrypted: i=1; AJvYcCVxlDX4eXXMHpK+g1/BnI0JDPvmoribn+G1VPwItiQnwI4Ke9y/iqFqEiPikUKRoB/oM/nwHoZpUw==@kvack.org
X-Gm-Message-State: AOJu0YxZadBzHHaZDThJxJvRSwbH87jAZMxQDLngQsjTsJaRIhEcL79H
	VEsxAMKeRuJ0QEcJjNRkTEb9kG45MYLW3skxJSpFF0CaTxEIpnRE/yGFv0/n/qAuAoMqHDfyKan
	hEg56JKzJ9cZqwLS3d+He0aorKoLDe2cB6OLRQAfMhv9/xvUBF8j+DghEXy0=
X-Google-Smtp-Source: AGHT+IEh0ISwvbUJiv+mpukhrPiqeMyVANfxx6o4d/yrYP7YDpxEDyf7zuRPEIGw30+QVeJNnc0H2Lq5Lr+uCQozfoYv21+QTlnw
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:214f:b0:425:8744:de7d with SMTP id
 e9e14a558f8ab-4259566cf61mr88463325ab.30.1758869070198; Thu, 25 Sep 2025
 23:44:30 -0700 (PDT)
Date: Thu, 25 Sep 2025 23:44:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d6364e.050a0220.3390a8.000d.GAE@google.com>
Subject: [syzbot] [mm?] KCSAN: data-race in try_to_migrate_one / zap_page_range_single_batched
From: syzbot <syzbot+60192c8877d0bc92a92b@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@redhat.com, 
	harry.yoo@oracle.com, jannh@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, riel@surriel.com, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 192CC140006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: y68phkhxkegg7bwce6614m7gqy1cc8yk
X-HE-Tag: 1758869070-730788
X-HE-Meta: U2FsdGVkX1+8VYGoTe4R2v8gX0lXPM9+M73b6qWM2yrkq/LZ5m7vGaTCVz4vWxSg4DQ068YbWrGmakO6TQu4hUmsPB9T+wTMudNyOt+lcJkLjyWqqil1NxxGErhjw/3o95llaqk+bkrbTC9lNm6BOHPyaoAUM18OUFLIo+u4Bj0hePjQ2/4dNrGSzDATx/57lVVvux3J1xTXlwkBQwn2upgsgdUnR+5a6v2Rt1NVZjIdFMMEpI+dR8TDt/tzMxfVelwmhwixW1jn7W3JnNM3/yMpAk1XETOU0IwJsv4P28FXxlakhj398F7ssiaH1TMFSywXsh8S83Bc0azDHsp6iDFopnFi00vBwBrVStLObQQSwddzS24sFwVlFltUPusmNmTcut9/kLQOnDUtMMmwI0iz15aF6amYa+IxGf1FvI9/Tv2qnfNJACPez7x/xmPJ2p9XPYOOMYY0OljctuBmYj83qNy6AhDC7e7QI8ddPVyDpH9zsYPZ6PjTnRltph985uCMJh/4QLOv+wePsjPo99MgWFp8uqRcQAARW4n5L763cl7PrhaWJsr21Nm+g1/QGOdUhVJhe1ZFlp+wG8rayVsCj7LHrdFdiIsFTXT12We8g3H+RRL/n2nTvXCI+RKHrisB1QoNsh5xHOyL7SIUVMAGeDUOq1sD2nUSM5u+Hph0TA1tDRsvOHOl3/HJkPScZVOkKZy/0eRxxQAVQgwF6qSdZ9YyhTLyAQolUifY3K4kCT1323LcsX4EoLzHhyshEj3JOQLnXksTYEjzaP/n25PHXycbqeZOILBFK4CZUcSP/4ciHVB4L2dBzCdMHMak1fkeKhkZXaGTD9zgtsv9wV1voTcmqo+Tq42D2lPaEH8TgOgGyBUcFyekT2xMwbFkEf+qwoKMvRtmMDATcGbdewFvb8vkmq+NVs5K8MpskC52yUNNsOr6vddBmH3JYyp1vjcU6iPV6shNN6KFKdQ
 VPLpm/vk
 i/cyfBrp2P+51fZACEmxTlFscci5ezsP40tu1UExrLThzuF2awqhDTGKoqDaXMjVI0aHEvoSc9aRJRKrz7oSCOlE4t2JcIAh5sjEN1pJ8mafSBpNiNyRUKb1hG4BbYhLP9n0WhPRaphkgkbek/srUT+shTDTSAJwxArUN3AqkEBp2D2xMtPw1YOxPQgmLsmxWj8E1zS3mwvsbhscy50NV2YKxceIQx+dEceZ5lSkigipIBy+yjrDwoEM14P6kA+lI7ZppUMl1B473eQQ2SNU/3l4tmhVdGsM1FfNrqpjr36T65gwaAiaVWgzOq9GoMhtg3axDDwYwy2oyeO49LaSRf32/shZsHu5ZVxg+fMIesqwwSnZPYoHFFuFcbKkeFemMkLyU/4WkUly/Ts18x8Y1GMKGGVFo5dhVcfnGfBvW/DoZti7omgZs6RWAWaDDUpbaWXXba23WkfGi8UT8shP3TY7xBMJW/16Y7+YbjoX912hO+WUHIY7gJVl5UCrL2N/EvwqEOzZPaTSdXV4xcgK1RBCydGC8D2A5zyhWaKtVn5j3Sez4HieQNsCVlNe8LPcbujXfXzFCbC+O0s1y5YJ4w99iO+a1kQD1/3GCn0gARx0v6jIagAbqwfR9ZJKj/XHWG1yOMHcMrIiS8GNyPX6CXufDhr6CxqWNHZrM3JWBO/Dcrp+8uKRj+l3dCwTbS91mNDU5UEe7CUkUJZguLYczAvksvebon6dnLJyXuKI2WX2j9/WgTxAbiX9ljiUjf9SGkpWQES8/Qa4SacB+tMSz5IGZJWlNzImN+v0CSm3/KCfX1cZhYLIloPTxqpl3CxKumIS2bq46VFvnWgGUfUM1U+fgupvTPIcb8f/d5sutkWCby/9lxcCpCQw4kF384ZTcJleW7geScNbxeSnZHqEIIaZCXrrTXDXhJnKwD8Lf9j/YHhC6zK27YRgB51AQ08CbeNC3SEd1DhCyOuQzZ7mR2lp7hhrY
 oDt5KQLt
 LGvOhKdZhr+g/GZo/lxHDzVW6HBduEM1tqduHShIIVvkFu3AeQ864sC94/Wg7T5r1VHeAKLbcgQuPk79KkL0yZ1EA1GigLuVg10qv95fBvFpBN2ZdPhrrwB8e2cPCTmmlac1DUup3GWUCWoFUclLPEVOpF2NyY6FMfKuaWsRjTP/dZHmsfUkOxF3TnA8500cdbrtDT+nEsWDvSVIgbQmhOBBTwkEGiQlsMPrCM+Egtir1cctommQ1puSu4xtaexC5UPRQuUSg6aLA64um5TD3iwAVFH4m2j4Rx6+zxNWvx4PBBpqhah4XpdF8+dhO/G+8TiReoAj/aqkSHukBy7i9yf3HXSqyuHmt41BN8Pu3hM/ogH4ExAse7AgstWWYXYPj1L6SWG7K2bQn8WQJwVHRdx4/YxIW+7N3BtV4zyOPMSJMAHrvNijLaWvpVmGZgPsBW2RLcp81gOVWRXbasPYpSC2Uz9mH8JZI1r3x0BBILYgEEr/UOk4iQql6B47YrQb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    cec1e6e5d1ab Merge tag 'sched_ext-for-6.17-rc7-fixes' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=145d4f12580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6e0c213d0735f5dd
dashboard link: https://syzkaller.appspot.com/bug?extid=60192c8877d0bc92a92b
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/10b7c8fdfdec/disk-cec1e6e5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cbecc36962db/vmlinux-cec1e6e5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/214f107d0a3e/bzImage-cec1e6e5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+60192c8877d0bc92a92b@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in try_to_migrate_one / zap_page_range_single_batched

write to 0xffff88810adfd798 of 8 bytes by task 13594 on cpu 1:
 update_hiwater_rss include/linux/mm.h:2657 [inline]
 try_to_migrate_one+0x918/0x16e0 mm/rmap.c:2455
 __rmap_walk_file+0x1ec/0x2b0 mm/rmap.c:2905
 try_to_migrate+0x1db/0x210 mm/rmap.c:-1
 migrate_folio_unmap mm/migrate.c:1324 [inline]
 migrate_pages_batch+0x6e1/0x1ae0 mm/migrate.c:1873
 migrate_pages_sync mm/migrate.c:1996 [inline]
 migrate_pages+0xf5f/0x1770 mm/migrate.c:2105
 do_mbind mm/mempolicy.c:1539 [inline]
 kernel_mbind mm/mempolicy.c:1682 [inline]
 __do_sys_mbind mm/mempolicy.c:1756 [inline]
 __se_sys_mbind+0x975/0xac0 mm/mempolicy.c:1752
 __x64_sys_mbind+0x78/0x90 mm/mempolicy.c:1752
 x64_sys_call+0x2932/0x2ff0 arch/x86/include/generated/asm/syscalls_64.h:238
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd2/0x200 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

write to 0xffff88810adfd798 of 8 bytes by task 13595 on cpu 0:
 update_hiwater_rss include/linux/mm.h:2657 [inline]
 zap_page_range_single_batched+0x182/0x450 mm/memory.c:2007
 zap_page_range_single mm/memory.c:2041 [inline]
 unmap_mapping_range_vma mm/memory.c:4020 [inline]
 unmap_mapping_range_tree+0xfd/0x160 mm/memory.c:4037
 unmap_mapping_pages mm/memory.c:4103 [inline]
 unmap_mapping_range+0xe4/0xf0 mm/memory.c:4140
 shmem_fallocate+0x262/0x840 mm/shmem.c:3746
 vfs_fallocate+0x3b6/0x400 fs/open.c:342
 madvise_remove mm/madvise.c:1049 [inline]
 madvise_vma_behavior+0x192d/0x1cf0 mm/madvise.c:1346
 madvise_walk_vmas mm/madvise.c:1669 [inline]
 madvise_do_behavior+0x5b7/0x970 mm/madvise.c:1885
 do_madvise+0x10e/0x190 mm/madvise.c:1978
 __do_sys_madvise mm/madvise.c:1987 [inline]
 __se_sys_madvise mm/madvise.c:1985 [inline]
 __x64_sys_madvise+0x64/0x80 mm/madvise.c:1985
 x64_sys_call+0x1f1a/0x2ff0 arch/x86/include/generated/asm/syscalls_64.h:29
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd2/0x200 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

value changed: 0x0000000000001645 -> 0x0000000000002165

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 UID: 0 PID: 13595 Comm: syz.1.3492 Tainted: G        W           syzkaller #0 PREEMPT(voluntary) 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
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

