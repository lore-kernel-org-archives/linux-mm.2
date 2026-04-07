Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A3E7FF5131
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 17:53:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AD056B0088; Tue,  7 Apr 2026 13:53:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75DFE6B0089; Tue,  7 Apr 2026 13:53:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674276B008A; Tue,  7 Apr 2026 13:53:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 569256B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 13:53:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB16F1B6C77
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 17:53:26 +0000 (UTC)
X-FDA: 84632506812.27.239D41F
Received: from mail-ot1-f79.google.com (mail-ot1-f79.google.com [209.85.210.79])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3A1C0180004
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 17:53:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of 3lETVaQkbAMc5BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.79 as permitted sender) smtp.mailfrom=3lETVaQkbAMc5BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775584405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=0xNeqTXuG3fa9wSy2SvZqFSjE6EAjRf8K1JT5r8HsbU=;
	b=AR/HiQsVFNJcsPfKGTDWk+lea6SaUWUPFgS1eGk2wPS/FYzlt614tE0GGw2Rsur1U+yLhS
	TmdYOB77R7y239xZqPNr6ze3dSnWz9xM0Jtp0bWyS7/0LCdkOJ98GEtoGMkl94W9cM52MG
	SNnw0GXQ0wlATQxhvqMGEFiyIdWMKlY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775584405; a=rsa-sha256;
	cv=none;
	b=yV0E75CEUPXQRcsb+uVU4SkCRhxj4k8X/ws1fAeOnxina4UlwJZbM09OyfU8KmlItyVdL+
	U779c/NUAIr72w6andwPFELb4Ffa4v87K63CF4FUKpDMAUWrJhleov2L3trMeXo+xi6L5Y
	jgUPFMpHRVqVQkBY+FL9ZmyMW2umndo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of 3lETVaQkbAMc5BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.79 as permitted sender) smtp.mailfrom=3lETVaQkbAMc5BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-ot1-f79.google.com with SMTP id 46e09a7af769-7d7df10ae0bso10449014a34.0
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 10:53:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775584404; x=1776189204;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0xNeqTXuG3fa9wSy2SvZqFSjE6EAjRf8K1JT5r8HsbU=;
        b=L7dHw80xyptEAsBz+qJMkatcE5D/hLMVYXY+OxQZjeEL4agNHRko8PddBjM/zNFObn
         KRJJxM3XXSql/IuPSnxxw1016HNaVKYqbdVvXyBDKQ0U57Sg0iKtBwQI3zCLNWLJE6jD
         6Llx+3BatJG/Uu1Y2vqZqI9OA4dQFCV1st3gDRg1Nvo52WLUq0UqvEbpc+0TNjKVHIZJ
         GPENubQCLmXndS5TLQ5rM4p+wykO5gwWUujZOx6XnzpmYhENrliLFUaBgjAZoeeBNqoj
         MuoU+LX+YwFyAOcG4O9sPM1r1+mtxnpRX80KrqkVOON5dvib2aSsjN1eA1qaHIP7sW20
         xr1w==
X-Forwarded-Encrypted: i=1; AJvYcCX/pr7z3NKVMsdCe8CVjKuzlRViXCLp+MiIklPolll65BgVSHiptnMJHtajxtcwI8cFI0FwCkSY2g==@kvack.org
X-Gm-Message-State: AOJu0YwMlua2zYHNMgafVdK3sez6uRQvvgchW8/9QBmL1jK75EVANElZ
	XexyYm5OZ70AQc0L+cnS7ganMNWTaD5EeockzXgQHTp4PPktquNibpzt0/PU+NpkdAtdiC4600F
	KWpMujyCuWSFVZcQamNk0AC7IS5UtflhtnWrDsFDVEpPRY0EY8HKfBtP1cF4=
MIME-Version: 1.0
X-Received: by 2002:a4a:e90d:0:b0:687:a318:a2e6 with SMTP id
 006d021491bc7-687a318a77emr2671591eaf.31.1775584404155; Tue, 07 Apr 2026
 10:53:24 -0700 (PDT)
Date: Tue, 07 Apr 2026 10:53:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69d54494.050a0220.3030df.0002.GAE@google.com>
Subject: [syzbot] [mm?] [cgroups?] WARNING: bad unlock balance in lruvec_stat_mod_folio
From: syzbot <syzbot+1a3353a77896e73a8f53@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3A1C0180004
X-Stat-Signature: cq6onoeopfqsnicthgoemmaw7umrjcyc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775584405-531843
X-HE-Meta: U2FsdGVkX1+qEDLWl/BVtGN46NlP4QAcsJayjFlcbe1saJcDz7jctYimL59LIU0OSW84ozKsNxXgsdLBIxmLE/cMYMNY2gktycatNxO66iuTwn8c05S2ESGRNp+3bDzY9it+fyz5do+CMFzgFA8L5OOKH7kYv5W8kjHvZ5at6njOq7NKeUYwwGV8PRcH+tLNSXHLOs2r3UW+438daxbdiUrtMF5Cr69MpnnP9RHfPtpiLbZudT6StvRbMY+jyhNK9vYLttfaC458KlPILZ79Maya9QqXomx62ViiBuqkTp03d3M3GeYrEXpBh6VB0SCjbOBLHKdEvwD5Ozd/JRuU3iG0JEGvS0HvlB4QstIty9XM3Qsp98ygYAYFRTS1FWnj5X6ZdV2/Vi5aewPy0UZMUIP/NSoMBFohcC4/U/0CP1ua/IaazJa5/530kS0Kj2VmQezldGgu9yarsa7cpI4T5hv45OJaXxHfA0tH283Gaq5VHHbauHmYpn/UVOiX+wqxjJ3lYol4+TPCVZbuGOPWJzL/a1iSLjesvknva5MAqxulIKdNQs575+CzOn3OV54tWUrqw1aNkLKUYh4crWrVnVoWMIxRNG8pH9lRYzCyHSSqQVFaOI5PR/1ECNaPWJpaU3lfzO0gEBOALU+M3Z3KR/23kwmEETz+MIaTzQ8pRmOXgApC5Lnqdje6Ytcoac8oa1dTx1Vp4iVzS6doQQMf7BZLE6ANDr+O05tQgpJ6U/I+K1jgXn+/+FDe7zZv97nYkJi7ZpiQYXQgYhqfGbAm8pXMj31uNbj1d3iFI1g//TByvswIeNfMB9km7upOGBGz33OKxsLKmHlSv+lK459IsOrbz809Pss8ZYEI23Hsd8JJHKXBIDHAmcXgBtOvWL2rt+hUJjwltKpUvikEJsjzQ5jsplpZQC0YscGFulCo3ahh3dWOFyrVs7GAWkv0pT8zjjMogNApkWtQf5vgw5Z
 upEjHNKo
 DLtaN/SKGuty1k9TeTkS+UP/Vs7+3kvKzqYEyDtIry2XSG6F0nSkifr0fTgrwZoFpIr69h35OtgKCrBPFBi+uZ1rwWuKXfg3KzNyrH8zGOUDVAVfmfX+9F7yB55OmbftUPZGXi4dGQ/yYwgJ2mp26yIMkMAht03bvHhPKkWvpZybZbmi3QF419bEboKrxxXh4+92W5nilMLKXsd7WZcJnegrzXmpFe66vzQ64HcwaFwPPkDCDF/xzQjEnsSQ59FBx+9tRLm95qQqy80hzFMN71DcEdlKphrG2Cr2P0+AWKuyW/0CuO+EZiOkjFTcZi7w/xCzhe9+YSITq7xqkgKBkhjbkcMg85v3ze0+ytBZ+PgoIyOBCZ29tS8mUruxrEWheu87ij4t9m/SsRcc+vShjzlHP/ASTTkr6h0+p3ZyzVFdO3butu9/VQefaFDeV9fvVzYTMATjeTAQBo3rUs7o0a6RLNSCboAvCXV2hQbLBL1gdGSRkLigJ5aggUCZYqBmO5rRfG7gZN5A/lpTCq6L02cxdSvUkZ7lpt8W4SSfuSf79RMsU+7mxL1AFORsZwlhucwqQUFVFWPwCAc1AWVvgGqFBNOkcTX/BNwlE//gr0CZOCL5E0WbcGgMW1vnPJfSTgf4ojBoh30yh+5ozZnj1XMqDPJgCXrbzgcgjycYJw7V1DAAxk/+i+bUFPs9ZnvCL8oirqT443c8tpTyTk+tVGuqRhBwmUsPzQP1RmsZACJgO+Z0UBvE+WaRmA2ZxQoPSS7NNu6uZgFrRH2W5yEfWyjKZw+K1e7zJ5gem4mLHm0eD5eULcRjrIa0XN4IMSJyYzdLqyNPABQ+I2EcPTwZy5w12q6jrF166hFN6OtnIEr9xkUkwbbjY3x/1iO7UkBnjQmQTTxbbwcGaaBJ4Qo2ZYSs5VNyBI9OFlG9vDpyTLm0IvkIy3ulxe1dKnOKGoMioZAj49q5p80/1QJYh5BYuU1nrT3cX
 XIeXwkXn
 ZWuSQ/wS2yVpY2t9H1vNOuKA8DkqEzDo5mxtjD4S1Q5rLvm2qMtg/MFalk83spceUFN0fFbbpkWqE+dNgDS4PMYFB6KK8SqqBrDZe/6lktQq/wLNFrHRhE6Vf+kQuuiYOfJdN2L1oflnj66Kjjj8lmpMcYR8y00l5Qu1090N2Eu6oyfoxujCivMqRsmLPWOk6ZOrSXeey8iV+s9qen5bOhB0Wcm6NMrb6CrYn2RK9U1lXE4spp8x6mW11bcaZs5pcLpQjvqyKA31bwyQoh2G4d4RI8pFc57j6msSyviLlqXqHzm5+pstS19k1vvwvESoMq95ph3Rxtet8PLQoVxGkLBlRJSQbA8x4Sg1FmrlV8r4sWmPlCefnSFlYCZhWkXZr0rn4urVXPpoQPu8pWuSECxn2ckC9SrxoQ5p2dWEvuPkApHAuzZI4iHlWXnMgtoyY6J0CxA9aLUbDozmIkdYmeByBKvAO50g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    cc13002a9f98 Add linux-next specific files for 20260402
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10d8946a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4e6c8be618ab359
dashboard link: https://syzkaller.appspot.com/bug?extid=1a3353a77896e73a8f53
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e804756158fe/disk-cc13002a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/be49b7dca580/vmlinux-cc13002a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5cb3fb091ba3/bzImage-cc13002a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1a3353a77896e73a8f53@syzkaller.appspotmail.com

cgroup: Unknown subsys name 'cpuset'
cgroup: Unknown subsys name 'rlimit'
=====================================
WARNING: bad unlock balance detected!
syzkaller #0 Not tainted
-------------------------------------
syz-executor/5830 is trying to release lock (rcu_read_lock) at:
[<ffffffff8237872e>] rcu_lock_acquire include/linux/rcupdate.h:312 [inline]
[<ffffffff8237872e>] rcu_read_lock include/linux/rcupdate.h:850 [inline]
[<ffffffff8237872e>] lruvec_stat_mod_folio+0x6e/0x3e0 mm/memcontrol.c:974
but there are no more locks to release!

other info that might help us debug this:
3 locks held by syz-executor/5830:
 #0: ffff88802cb7f588 (&ima_iint_mutex_key[depth]){+.+.}-{4:4}, at: process_measurement+0x7f1/0x1c80 security/integrity/ima/ima_main.c:319
 #1: ffff888077946ff0 (mapping.invalidate_lock#2){++++}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:1094 [inline]
 #1: ffff888077946ff0 (mapping.invalidate_lock#2){++++}-{4:4}, at: do_page_cache_ra mm/readahead.c:333 [inline]
 #1: ffff888077946ff0 (mapping.invalidate_lock#2){++++}-{4:4}, at: page_cache_ra_order+0xad4/0xe80 mm/readahead.c:538
 #2: ffff888077946f50 (&xa->xa_lock#10){..-.}-{3:3}, at: spin_lock_irq include/linux/spinlock.h:372 [inline]
 #2: ffff888077946f50 (&xa->xa_lock#10){..-.}-{3:3}, at: __filemap_add_folio+0x9fe/0x1330 mm/filemap.c:876

stack backtrace:
CPU: 1 UID: 0 PID: 5830 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_unlock_imbalance_bug+0xdc/0xf0 kernel/locking/lockdep.c:5298
 __lock_release kernel/locking/lockdep.c:5537 [inline]
 lock_release+0x248/0x3c0 kernel/locking/lockdep.c:5889
 rcu_lock_release include/linux/rcupdate.h:322 [inline]
 rcu_read_unlock include/linux/rcupdate.h:881 [inline]
 lruvec_stat_mod_folio+0x28b/0x3e0 mm/memcontrol.c:985
 __filemap_add_folio+0xceb/0x1330 mm/filemap.c:924
 filemap_add_folio+0x264/0x530 mm/filemap.c:967
 page_cache_ra_unbounded+0x494/0xa10 mm/readahead.c:282
 do_page_cache_ra mm/readahead.c:334 [inline]
 page_cache_ra_order+0xae4/0xe80 mm/readahead.c:538
 filemap_readahead mm/filemap.c:2664 [inline]
 filemap_get_pages+0x897/0x1ef0 mm/filemap.c:2710
 filemap_read+0x447/0x1230 mm/filemap.c:2806
 __kernel_read+0x504/0x9b0 fs/read_write.c:532
 integrity_kernel_read+0x89/0xd0 security/integrity/iint.c:28
 ima_calc_file_hash_tfm security/integrity/ima/ima_crypto.c:222 [inline]
 ima_calc_file_hash+0x446/0x860 security/integrity/ima/ima_crypto.c:280
 ima_collect_measurement+0x51d/0x9c0 security/integrity/ima/ima_api.c:300
 process_measurement+0x12cd/0x1c80 security/integrity/ima/ima_main.c:425
 ima_file_check+0xe1/0x130 security/integrity/ima/ima_main.c:685
 security_file_post_open+0xb3/0x260 security/security.c:2653
 do_open fs/namei.c:4701 [inline]
 path_openat+0x2e4d/0x3860 fs/namei.c:4858
 do_file_open+0x23e/0x4a0 fs/namei.c:4887
 file_open_name+0x162/0x1c0 fs/open.c:1322
 __do_sys_swapon mm/swapfile.c:3471 [inline]
 __se_sys_swapon+0x84a/0x2090 mm/swapfile.c:3436
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7efed519c7d7
Code: 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 a7 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc370182b8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a7
RAX: ffffffffffffffda RBX: 0000000000000008 RCX: 00007efed519c7d7
RDX: 0000000000000000 RSI: 0000000000008000 RDI: 00007efed5232e5b
RBP: 00007efed5232e5b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000246 R12: 00007efed53e63e0
R13: 00007efed524dd26 R14: 0000000000200000 R15: 00007efed53e63a0
 </TASK>
------------[ cut here ]------------
rrln < 0 || rrln > RCU_NEST_PMAX
WARNING: kernel/rcu/tree_plugin.h:443 at __rcu_read_unlock+0x79/0xe0 kernel/rcu/tree_plugin.h:443, CPU#1: syz-executor/5830
Modules linked in:
CPU: 1 UID: 0 PID: 5830 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
RIP: 0010:__rcu_read_unlock+0x79/0xe0 kernel/rcu/tree_plugin.h:443
Code: 75 66 41 83 3e 00 75 27 43 0f b6 04 3c 84 c0 75 41 8b 03 3d 00 00 00 40 73 0f 5b 41 5c 41 5d 41 5e 41 5f e9 59 12 11 0a cc 90 <0f> 0b 90 eb eb e8 6d 00 00 00 eb d2 89 d9 80 e1 07 80 c1 03 38 c1
RSP: 0018:ffffc90003b863f0 EFLAGS: 00010086
RAX: 00000000ffffffff RBX: ffff88803567a344 RCX: 0000000080000001
RDX: 0000000000000000 RSI: ffffffff8e37db44 RDI: ffff888035679e80
RBP: ffffc90003b86588 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1d06db0 R12: 1ffff11006acf468
R13: dffffc0000000000 R14: 00000003fffffffc R15: dffffc0000000000
FS:  00005555886db540(0000) GS:ffff888125304000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f36450057b8 CR3: 00000000762a4000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __filemap_add_folio+0xceb/0x1330 mm/filemap.c:924
 filemap_add_folio+0x264/0x530 mm/filemap.c:967
 page_cache_ra_unbounded+0x494/0xa10 mm/readahead.c:282
 do_page_cache_ra mm/readahead.c:334 [inline]
 page_cache_ra_order+0xae4/0xe80 mm/readahead.c:538
 filemap_readahead mm/filemap.c:2664 [inline]
 filemap_get_pages+0x897/0x1ef0 mm/filemap.c:2710
 filemap_read+0x447/0x1230 mm/filemap.c:2806
 __kernel_read+0x504/0x9b0 fs/read_write.c:532
 integrity_kernel_read+0x89/0xd0 security/integrity/iint.c:28
 ima_calc_file_hash_tfm security/integrity/ima/ima_crypto.c:222 [inline]
 ima_calc_file_hash+0x446/0x860 security/integrity/ima/ima_crypto.c:280
 ima_collect_measurement+0x51d/0x9c0 security/integrity/ima/ima_api.c:300
 process_measurement+0x12cd/0x1c80 security/integrity/ima/ima_main.c:425
 ima_file_check+0xe1/0x130 security/integrity/ima/ima_main.c:685
 security_file_post_open+0xb3/0x260 security/security.c:2653
 do_open fs/namei.c:4701 [inline]
 path_openat+0x2e4d/0x3860 fs/namei.c:4858
 do_file_open+0x23e/0x4a0 fs/namei.c:4887
 file_open_name+0x162/0x1c0 fs/open.c:1322
 __do_sys_swapon mm/swapfile.c:3471 [inline]
 __se_sys_swapon+0x84a/0x2090 mm/swapfile.c:3436
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7efed519c7d7
Code: 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 a7 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc370182b8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a7
RAX: ffffffffffffffda RBX: 0000000000000008 RCX: 00007efed519c7d7
RDX: 0000000000000000 RSI: 0000000000008000 RDI: 00007efed5232e5b
RBP: 00007efed5232e5b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000246 R12: 00007efed53e63e0
R13: 00007efed524dd26 R14: 0000000000200000 R15: 00007efed53e63a0
 </TASK>


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

