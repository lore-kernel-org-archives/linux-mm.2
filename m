Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0D3A606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 01:04:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 882F66B05B0; Fri,  6 Nov 2026 20:04:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 833CF6B05B1; Fri,  6 Nov 2026 20:04:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 725786B05B2; Fri,  6 Nov 2026 20:04:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 331786B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:04:49 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B14F2140252
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 01:04:40 +0000 (UTC)
X-FDA: 85406527920.09.2145E2E
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by imf29.hostedemail.com (Postfix) with ESMTP id F413A120008
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 01:04:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of 3JnnuagkbADEflmXNYYReNccVQ.TbbTYRhfRePbagRag.PbZ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3JnnuagkbADEflmXNYYReNccVQ.TbbTYRhfRePbagRag.PbZ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794013479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=aQAkv1Ch1hBWt9F5oKlCKZa1WGD0uucsNqTVeJRSM+g=;
	b=l28w3xLxv5bw9arjGISvDZK1g5GhQhrjduLaZIKOXRVe3fZKOFtFJSe4qzVOMcd8JDFhaI
	w+X8EgeLpyKXUoRA/y8ML+3vxkQ96pBIlfsQ8V/GbXD+8y5FgZwrwVUp6gDuKYbcqcQGsd
	tFzhw8UK+L2nD9wTl3kSdhRew5NzP6I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794013479;
	b=OOVQfO/0hI0wjCaTpT/dk+cytQAPwYE66Si6yWAvRhYRIndnRHJVxhAOwy1POHSHuJFhaS
	2mgzRS2JubCurar5R65zrx6I4TIMR+BvSU1/VzywQzp3buVC3ZCnuiQQUY9TBxrRQNwRlq
	878AZ99hX/+7SfwepQKr7akSpVzmIpM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of 3JnnuagkbADEflmXNYYReNccVQ.TbbTYRhfRePbagRag.PbZ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3JnnuagkbADEflmXNYYReNccVQ.TbbTYRhfRePbagRag.PbZ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-85d502ea62cso1737434a34.3
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 17:04:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794013478; x=1794618278;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=aQAkv1Ch1hBWt9F5oKlCKZa1WGD0uucsNqTVeJRSM+g=;
        b=tZtD0TCm/1c8A6cMKy6QzLpYT58Xxv96dHWwYZ+qdiAonKTJHLwdVd6YA+bK0/knf0
         et3N69Rn5K/SvwXsBGQmLaA6RHSQo/ueB5x4ogxnQznvzIC/HsDbUxMC3xUH8VFBCdRX
         kpXd708zdfB1RHgdwl47bRTurcf0NUe3pFRQK/eslXP20ITTC8qBmvsTCWy/HixTwzx9
         ThkXwUqMVBwGoNDCCQI29G8Il+KNbOIs/ltJO7xI57zWVvjqCdjMEMf4M7sQwpFi1ZRo
         iTmxFGPmcmNu/6DHRTMfqTaKzOUyEVzKBSfzSsH+r73WYZoUIHIMTIRFKt21UQUufUDF
         CIMw==
X-Forwarded-Encrypted: i=1; AKwUvBwP+/1Ig0ls6+TKg7hW3qNltMQlzQNkgpfQtcqpSNHkYARMdaTCVGiZx8hdDw31Z9CkchgtGU+CuQ==@kvack.org
X-Gm-Message-State: APuU4Z9CunD3ns4QCUmdfFXJiQqKwd0VAsecuawQkEy0+rlp+iJ5Kvj/
	CNFwPkAB8WF4+mQKOranPFCgb4fO0nO759WNQyjpHLwhg+9Ayc6+LqgJkuFIoC6GO2gdBwpaOs+
	s2Gc1teMX/CuqsvnPW+4xnsd+snHkB4p23J5Lxa/kX+NLLB6jundEdkdUiX0=
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1987:b0:4f4:d7:b15b with SMTP id
 5614622812f47-567e0997171mr3468472b6e.4.1794013478283; Fri, 06 Nov 2026
 17:04:38 -0800 (PST)
Date: Fri, 06 Nov 2026 17:04:38 -0800
In-Reply-To: <6aec6433.0ce67c00.35143.0001.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aee7926.45cab1c5.12a849.0002.GAE@google.com>
Subject: Re: [syzbot] [mm?] [fuse?] WARNING in shmem_initxattrs
From: syzbot <syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com, 
	brauner@kernel.org, fuse-devel@lists.linux.dev, hughd@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mszeredi@redhat.com, 
	syzkaller-bugs@googlegroups.com, syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F413A120008
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 1xaywntucbjbi6rysu3d5519ian5dajy
X-Rspam-User: 
X-HE-Tag: 1794013478-702114
X-HE-Meta: U2FsdGVkX18dCWntgKTcxQyNGdftmpC0Cxjyn6pN/ZLPL2UWyCLdyk4aooXdE2dXqWPeqb0kMLi4vQyXkp0y6x6brwkCoUl/P1ty2bs0pEYUacAUqm/52TwG29A90veoFfk7NXSx5r6VEU0NbTwJY3TK3xaDX58RsXtdXMPrgA6jxHphMNoyHOmeSbb1BHiSo3XFDwy00nei2PvsRtyekZVydzlCxXj9QL3XXuNGS+wRElP1bS22PLNDTodknUbjf1UeVoVMUqZu0wF2YxVNgS6hMzmd5/51xhpyjQzlG+2xz7dhU1uaT8YQjah1EyVNcbYrEwu1rLdWo/cteNvigKK/UvI71LsQLtV2FzseIJnHhIu1oKe7hKZO0ygyxYN1jo45rEOF+Go2x3WR1Ef54noh/CRGnU58pG0kzUGX6c/tbu5EOEf77sT1lNunTgD/zylrc8DzYWRldx9gkwut19Qr9glh+HFMQrWzxWIbegjzPVW8o53C4Fu+YTjMs6TQfqDTvBGpJySbMjucNuH4MM3yAMlUElfH4bSYME3dBjGAIUCT0Tj8lHZCP1FD/nOIkXfdiBG419Els2DNBkNO8xOca1IQjKDWsSrsRawICXE3mGTeCOLUBxU/YtyFCVpT6hblWTiBzWKMoA4XDzAnFYUkMVK2NjLFrwOtTd5eWLQJ5bunDtLiZE662EG++Cu82n+hl2flt0n9aUyfRydX6L5ji2LxESIUcSGdJDZLXmqR0faRUGWonfH0TVbr0vAdC3KD4EAMN33AA2aYtPMDu7L63hNwWgOx+U8plVIYC/iApRle1Gke5iFDzrThWtCPHP06fLuTJt3AGLHHkyneW3Y8dxQlTIHdrfVf5RpqpfNVBxejeyMbAGsIKfGQn5j47Z4RmoJ/jtSWOrG8IzoogSLsqe/Sz4KAbAQHPNXSrIwpW+byyeZvhMSUzH4r8KMpWIlZ+7tOkhq9VF3woB5
 Jfjir4QT
 iy4XYWsai35qnbKprJXGge6fWBRDDHuoOeFn0eJ0OHo/jTSV7wnH1iPi3kKoXsN6Alj24qFUk4Zw7dgbaRPQb+mFSWJcFR5jncZUp/CfNahw+C9Aw1/1euLCpn1ldP/VAylgdAngJpEZUUZNrJkzTGu8Dg54XytYDvMa89rUDSnWAEXNf1owt1rJzugxPV6BlE8Kpqjr762pdmmnF+0iIbsvxuq5ISK4SYFEQTtEB2hn5HO6A+kJyrw8Onjy69zYz5096Bcl2huKpYgu4+7uR4fY+kB8fTNJCbq0hMP0J0DpsVl0+EHgnt2BQ5J+edQ/XI4lwvHGDUhoN1KIb+2EWXScJed5ssZaj9BDWsUCWugEYckK9IqHa4wAHju0xE+4uPrTcnrZplMgata2HlJmq0m/T9TOGGDYgWgG35Ua/uCTw4m0WFHBYJCZ3UN+2mbvJrP9d6DPmMZSqbwrKxrDWLKOZo7sjHb5RWdiDSwsfXSv3QhMLZ6w9fy/OXoEC74SNbzFYvGdI3CqbLTZX/9e+gHE7+WQMLfB/q+mDNFscQngzdGYK+pr48f0x1/TDxX8lqGQllgTTKK0LDJVntWD+bnJgV4GN7pEONpZWJdH/2K1m3q8v2QKfXMgP0kUKNaA7eTrBHH6iKn95meTug9/s6g2m2836ejVlBfLbMNKe44l6LuiUPo05i9PflEldLoQHbM0CuFcbfhWvn6wUE2+ldyrDNotB9ZHauSl4Jp/YUO9hqtEza7fNFTsTrNd0VAAXZ29BjwzTBEBFZGDbaPLdOtZ6sUkVOmOZslVwF0+nFRNm1ZS9qJCNWe9B0IQLQDp87Hj1EWydVdNUlt3hL7523/lzb+ryrwPAn/MLf4CqOU/8P9XFO6a1kT41Na9QbbeL1+pIzNoJzYoG+eRed/njsr9UElRbZ8ToJKecdKRxtly3Dwdf/jrguwEd6y20Rr5CkiRQT43/LmahujJXLBw6W5ObUDWc
 RA/jc/1P
 J5xEbG2k7cVu6xgRK2WvBOhMkVvzhItFMV+3PsTLia0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

syzbot has found a reproducer for the following issue on:

HEAD commit:    f66469d9905b Merge tag 'net-7.4-rc2' of git://git.kernel.o..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=110ad735580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1cf189394a856f11
dashboard link: https://syzkaller.appspot.com/bug?extid=4324f771847cecb27c54
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13bb58d9580000

AI-generated root cause summary:
In mm/shmem.c:shmem_initxattrs(), the initial reservation of inode xattr space
(ispace) from sbinfo->free_ispace is gated by 'if (sbinfo->max_inodes)', and
subsequent per-xattr subtraction from ispace is also gated by 'if
(sbinfo->max_inodes)'. Because sbinfo->max_inodes is accessed locklessly and can
be concurrently modified to 0 during a remount (shmem_reconfigure() with
nr_inodes=0), ispace can be reserved when max_inodes is non-zero, but fail to be
decremented when max_inodes becomes 0. Consequently, after all security xattrs
are successfully allocated and added, ispace remains non-zero, tripping the
WARN_ON(ispace) assertion.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=4324f771847cecb27c54

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com

------------[ cut here ]------------
ispace
WARNING: mm/shmem.c:4499 at shmem_initxattrs+0x3f5/0x650 mm/shmem.c:4499, CPU#3: syz.3.20/6999
Modules linked in:
CPU: 3 UID: 0 PID: 6999 Comm: syz.3.20 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:shmem_initxattrs+0x3f5/0x650 mm/shmem.c:4499
Code: 03 80 3c 02 00 0f 85 5d 02 00 00 48 83 3b 00 0f 85 fd fc ff ff e8 eb 3b ae ff 4c 89 ee 31 ff e8 81 36 ae ff e8 dc 3b ae ff 90 <0f> 0b 90 e9 dd fe ff ff e8 ce 3b ae ff 4d 8d 7e 78 4c 89 ff e8 12
RSP: 0018:ffffc90004fa7bb0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888031a28818 RCX: 0000000000000000
RDX: ffff88803397a580 RSI: ffffffff82603cc4 RDI: 0000000000000007
RBP: ffff888037912b00 R08: 0000000000000000 R09: 0000000000000053
R10: ffff88805aa5a973 R11: 0000000000000000 R12: dffffc0000000000
R13: 0000000000000053 R14: ffff88805aa58000 R15: ffff888037912b30
FS:  00007fd3ae9026c0(0000) GS:ffff8880d4775000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fcb0d7556c8 CR3: 000000001d7a3000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 security_inode_init_security+0x242/0x370 security/security.c:1384
 shmem_mknod+0x2ce/0x480 mm/shmem.c:4087
 shmem_mkdir+0x31/0x80 mm/shmem.c:4142
 vfs_mkdir+0x36d/0x8a0 fs/namei.c:5428
 filename_mkdirat+0x4c4/0x630 fs/namei.c:5461
 __do_sys_mkdirat fs/namei.c:5482 [inline]
 __se_sys_mkdirat fs/namei.c:5479 [inline]
 __x64_sys_mkdirat+0x89/0xc0 fs/namei.c:5479
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd3ad99fb19
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd3ae902028 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
RAX: ffffffffffffffda RBX: 00007fd3adc26090 RCX: 00007fd3ad99fb19
RDX: 00000000000001ff RSI: 0000200000000800 RDI: ffffffffffffff9c
RBP: 00007fd3ada37b70 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fd3adc26128 R14: 00007fd3adc26090 R15: 00007ffcae78f808
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

