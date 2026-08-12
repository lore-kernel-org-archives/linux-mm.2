Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D51A8C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:26:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B21906B01F7; Wed, 12 Aug 2026 08:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD1656B01F8; Wed, 12 Aug 2026 08:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E6B56B01F9; Wed, 12 Aug 2026 08:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 75C866B01F7
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:26:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 134DD1C0B7A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:26:27 +0000 (UTC)
X-FDA: 85092540414.12.3105F7E
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4B88F180005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:26:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf06.hostedemail.com: domain of 3cGZ8agkbAIk5BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3cGZ8agkbAIk5BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786537585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=KwBwo9L8xQyqtv/i2/6defD8MNdrwToASIU8rpL79rQ=;
	b=dGOnjeL+hWyU0GS5CLoXqPhlLgvRFyoGKro+R48mNq1MDQmW+35i2v+70jzCZhMtqYOCHF
	YWE9XAaZsi4cg1BO0Qu3PZLSPhPgZGn6w3y3nTWI6QnEgdrUfAtr1ELUUo+tRInKfcsEw7
	AY6IE/o4aQEVEqoCW4mgkXFL6SIIt5g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf06.hostedemail.com: domain of 3cGZ8agkbAIk5BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3cGZ8agkbAIk5BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786537585;
	b=QKOqqjhJ4GgPyANFzsjgO5CH/iyT+kRZBXc5IRdkl9JrjlM7xVUC8ntmHEsTqE+Gx/ZRln
	iHn597Ym8J6NDS+3ldlJ4W4QsYW8aWY5ufPSnvyldkAUUoUmVqPSCWm59JTV1hl0hgembK
	X8ewNof1pUcp7RvU9bD5CvPxPRC5PDE=
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-49d4cb3ca23so1150987b6e.3
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:26:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786537584; x=1787142384;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=KwBwo9L8xQyqtv/i2/6defD8MNdrwToASIU8rpL79rQ=;
        b=qBRyfIScBfEIVwznuRuR2fkKrUEQLOp1/7Jhf7uNOkFQC7ZhLFZ1ZExAWygSfj0dXh
         JEZOglvVRjOU5g1afIdbL0FwDgxVVrS6/SBB2nbRBhmiYGxDMnNiVW/NthJRp0a0Mz8q
         hsKd3SDKN0smQ7J0DgJOYEHqyrurXBdB6EhTqjq95xuEv3pRb6YPIDqlq55awsOCJg+6
         RCDn8keHxAnBDo0RwQCx47gKNQw/qGzxE8CKWQRBr0x62RtrZk5b0NV2ty4J/TG4glpr
         46cluzcBuza5O6znV0DBPCJ5JaLbWUaK82LeYRMJilkCHGEy/mi+kytZ2813ga3UgR01
         rAGA==
X-Forwarded-Encrypted: i=1; AHgh+RqW6bZToXYjicob87laUH/eK5JLzD68heV465fq/2Gu7Y7MKtyVfazKiVfTOhdzyux/a0X3DGw4/w==@kvack.org
X-Gm-Message-State: AOJu0YwRp65hu8Xuz+1Qvx5ulz+Ts65xfY4ovkYQldvaLEsT6EWeodX1
	xsbGvKbKAlansfv1gKX2Xu7EM1Vtb7/NpLfRbJofywiWAWlzTUsDi43cFu1EAwzbV2kHL3I3p6+
	qtt879ovTUjPIK26OlE7p2tTAmDCxI0J6KqY5Ae7/4NWcFZpHr2lHWGcRCUc=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:c97:b0:69e:98c0:4bd6 with SMTP id
 006d021491bc7-6b0b2490e00mr3827700eaf.1.1786537584398; Wed, 12 Aug 2026
 05:26:24 -0700 (PDT)
Date: Wed, 12 Aug 2026 05:26:24 -0700
In-Reply-To: <6a7a6929.b50370da.49fe0.005e.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7c6670.3668565d.e8814.0012.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in set_mm_walk
From: syzbot <syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, cgroups@vger.kernel.org, david@kernel.org, 
	hannes@cmpxchg.org, kasong@tencent.com, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@kernel.org, mhocko@suse.com, muchun.song@linux.dev, qi.zheng@linux.dev, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	syzkaller-bugs@googlegroups.com, weixugc@google.com, yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: pb8wqcki16sywk3aqd6ycnb4t6yi486h
X-Rspamd-Queue-Id: 4B88F180005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786537585-173877
X-HE-Meta: U2FsdGVkX18SZvlGwAoaNo6w8xeCeluxcO0gkpksdR6lqEJme7EBXscqZ0JV4KbeAw6A3Jx0aF7EgZU1klxM6sNjxkm/bho22r8hjqpkebtIHumbDjOtBC2TmKGngzHhh6ZNRnm1aIuDjUzvQ7LYWOtbb0hSYPtVOp1BLaeDZhjj8lC1BC+Y43As95dxL0PLJZOsvqQ7Sd6i/e5c72dz46PZUxojXeEx5IpvJJo8m/mkoZtFqOCejmzWhVfTloPuaUES3vsxZuIiacAJ4A6iULFXWra97tAwdocZqnxj3tKgUXbGJVaBedatLGp8Mmx3p/48G9FSN+h5wTRrOXYWoXQBNjQpJpQic9B4bMHUimxrpmOhYqrzbnYDiXcgPQR9XA9XCmXeUXA8eiWuQBfkLvR/kDqh2mfmkF4UmTG7ypOso1fvD2sCWZrafQjHKKCKg+CoSns7jfSlHcIHxWjDyfEJgAhWnSXJwWVQ2crUinrqVVOvqa00Z4QkioNR92fhwZnDu/GD/SjmmsQ6mekIYboxMnyPngdOmCPA/HvB8qlThcY4oj37TOaGmjZd+p+WdaIaRHF4aIOrL3C+/iAl0jS8geqKvmVgWOw5TB7pWItLi3p7R/843bT66aT7D07Ebjvuxokb+pWC/TcQF7lQa7R+oOeGAak9/x/5A/QONGUX2O7p6XZKkN/Qonsb+x0IulbrYF0LFzwVJvFBiqvYt9Cn9HK12auU3oGdkXBJ2bCUGOMjsua/YymcNv1TaGD+xKA/f1lD2114/z78kHEprS+RytE5eYvRrzqK7e2JDX0KDLOUA8aPGdva9+HpIDGBJG8XSwc8q/Vgx+P4J4x9NZ6919/gcHebypaW/l6XvW0ztKAnCdK4K28v1dKQyBuzeyBUskRcYbuXtYJxlfn1Xfh6VDnmrDK3kesC2zm5Mwp0vbDGeDlrF+rSuvONfcodUX5mWv2My0Sn8Xj2PSo
 jeYqVien
 AB7uvCBvuE+R9eRoMvCqluCR+NqK7/wHzKJFen+iP6YUNDSiWvYCtKsqReYNpIGecGG4eoHrCccYPn3BHKirCol4aTTRrumpa4JfDYlXz/+tvXppntVPn+cN3gVy5emqvW/Ww2ujOW7yp2EGVyZMxzFwSDXYrfmbRHgpXIVkf5p0zQY89ihdbgSmZCljR03r29RfpYZPiFvCb4obrSWFsAHPXIf9bGdGh5HDxpTNTZZextfChCmADcc5Ogrn4DsDNUEi6bEc+mMIXDyx0GEnr92NbY2AdlL79CjByf9eSFeX5WlzpmyAEMWuYQqbkkl2QjMPnIEp1Aunyy7+d/fRpGczH5Z3Ngy6Q7qqa4Xwu04KpGRCZueNxD8NnXqZk4AVfh4ndQOkKP0g6BoZCzAphFfhjkTvuGEtu6hGam86nj0m8gKmR81YCUoqGMPjgu7yr8ElLmcw0bEGtYCCgOHnQm+gygvzNPfkELoK3OFngJuXqJ7Jimfe3/mVNEjl9ihgtVzW80WO1P2hGlAp2YzZbw1vbENNoNwPEF1lgCKXJ9r5lpLpY8kiJc6cFibHJFemInUbX7//8sG12SldR4UrqlXNekmnbsFmqd1XAZicroOF76PqwwIYzAGZeUGbJ4jhIX+CksOkWdhhSowasA+UuFLfdXi4jWmJVY3w00yxDMB3Ilq9dyk/tTlsdtZ4rPYCSs7BzEhdmWlJyoLPp2KjnM7UtrUPn488qV7X/wiL9P2phBHV0vG0Q8LteBOs552fckQhxTHtORMcr4Cjlwbv8H6ntXsDEiO852bRs4Fjfk52QV4GkpSBrXk5QGrt/x5F5gHEVX2Duvhp+lF2QHu1Tj7P3s39Ocz4/Ypw4lDyoKrUw+Wc+5QCkGWL361FLfXVO24eIT3xwq/53sXsBicSz501kpRlQX1HZ4uGkee3HANVSkRRgnAmWuRNTpgeAa73Vw79m/awZXIUa2uW3dzeGWW4+F0ab
 YbNnrnl8
 F9IksIp9AqXilThFE8VtSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    f5bbbfec59b4 Merge tag 'probes-fixes-v7.2-rc7' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11f44c79580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c44651ea7dd2f307
dashboard link: https://syzkaller.appspot.com/bug?extid=12ee2725d5fde63a9c96
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d11149580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com

------------[ cut here ]------------
current_is_kswapd()
WARNING: mm/vmscan.c:3800 at set_mm_walk+0x210/0x270 mm/vmscan.c:3800, CPU#2: kswapd0/111
Modules linked in:
CPU: 2 UID: 0 PID: 111 Comm: kswapd0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:set_mm_walk+0x210/0x270 mm/vmscan.c:3800
Code: 13 00 00 4d 8d 7d 08 e9 f7 fe ff ff e8 19 f7 2a 00 e9 b7 fe ff ff e8 7f 68 ba ff 90 0f 0b 90 e9 d2 fe ff ff e8 71 68 ba ff 90 <0f> 0b 90 e9 74 ff ff ff 4c 89 ff e8 20 f7 2a 00 e9 4e fe ff ff 48
RSP: 0018:ffffc9000272f2b8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888023f04a80 RCX: ffffffff82500a88
RDX: ffff888023f04a80 RSI: ffffffff82500b0f RDI: ffff888023f04a80
RBP: 0000000000020000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000020000 R11: 0000000000000000 R12: 0000000000000000
R13: ffffc9000272fc38 R14: 0000000000000001 R15: ffffc9000272fc40
FS:  0000000000000000(0000) GS:ffff8880d5fec000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005643a2ed4168 CR3: 000000003c7ec000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 try_to_inc_max_seq+0xf0/0x1090 mm/vmscan.c:4023
 try_to_shrink_lruvec+0x4bd/0x6b0 mm/vmscan.c:4977
 lru_gen_shrink_lruvec mm/vmscan.c:5128 [inline]
 shrink_lruvec+0x31e/0x25b0 mm/vmscan.c:5888
 mem_cgroup_shrink_node+0x227/0x6a0 mm/vmscan.c:6753
 mem_cgroup_soft_reclaim mm/memcontrol-v1.c:312 [inline]
 memcg1_soft_limit_reclaim+0x2d5/0x830 mm/memcontrol-v1.c:362
 balance_pgdat+0xa11/0x1f00 mm/vmscan.c:7177
 kswapd+0x556/0xb50 mm/vmscan.c:7462
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

