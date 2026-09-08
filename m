Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E691EC79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 01:22:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A86146B008C; Mon,  7 Sep 2026 21:22:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5DAD6B0092; Mon,  7 Sep 2026 21:22:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 975006B0093; Mon,  7 Sep 2026 21:22:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6115A6B008C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:22:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B6B0016031A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 01:22:26 +0000 (UTC)
X-FDA: 85188844692.02.2722A77
Received: from mail-oa2-f9.google.com (mail-oa2-f9.google.com [74.125.231.73])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2001840008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 01:22:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf07.hostedemail.com: domain of 3UGOfagkbAO8jpqbRccViRggZU.XffXcVljViTfekVek.Tfd@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.73 as permitted sender) smtp.mailfrom=3UGOfagkbAO8jpqbRccViRggZU.XffXcVljViTfekVek.Tfd@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788830545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=ZCij2SvlUZ0ciBIF3n1U915PLtoGJOJG9GMDx+Fo66w=;
	b=1WXzg+5IzIFaAh6YMzeQoHp0alRXkn10jWGOAB7uzrg+PDlnjuTtc5zsKAq3h8hOEnVM6P
	LEURnDG7Y0M1STbreVErDRX0Z8nX6cFGLGVvaqIUzerHpDrm0lV7/H1MKa5URKTUKQR+ci
	xv7fIaxAAL9/cdUWMR7jGZWVvknpGBQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788830545;
	b=gMZrp2qv9+AG5fWLa1oxbWi8v8Q1gf3JajQopkuREORtML9aMsi1FeE7OmoS9Wik6W9y6B
	Ezzm+67uxvsC9Pw2JrgkraYLA/SdnU5icqLoonFA89OUBdRi4+b7s6M1Xlbm/rLzjyZ18M
	nyx+iiXnXUJbSDWigCWwnV7030sd4rk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf07.hostedemail.com: domain of 3UGOfagkbAO8jpqbRccViRggZU.XffXcVljViTfekVek.Tfd@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.73 as permitted sender) smtp.mailfrom=3UGOfagkbAO8jpqbRccViRggZU.XffXcVljViTfekVek.Tfd@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa2-f9.google.com with SMTP id 586e51a60fabf-4667f43a4ccso1813774fac.0
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 18:22:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788830544; x=1789435344;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZCij2SvlUZ0ciBIF3n1U915PLtoGJOJG9GMDx+Fo66w=;
        b=UkU3l2/6zdoz4BsSgaDT1xtnk8DLZD0QYwvoQ/6gvP5vAqFOfgB51wlzTJ7+xUh1Ll
         BuizHMl6HVnhSqTKNn0y8JNOjndrS4BRyAMMXvwHsfTRBx9En4wkw5y+jJ2wytJwTtug
         1wb3fGIGpMZentDxem6/IkwDx1HW+JL9T4Mxyp6IeBPakq2t7G096F4cZxel6zqXrUQQ
         KNAB/7r0rwOEH1DunUOZiEOpyeOUUIYnkDfrc3VD5+T8fjobTz3Egu2QLsHfsu6w+IR7
         KxuYGruFXfRNsOzf10qp+5m5EThC1tYjIMk4v/+ij4ODIsy9nlOEijHzAsy+QlN6owmU
         6Hsw==
X-Forwarded-Encrypted: i=1; AKwUvBxnMrnaxpy6rJZmqGmUiqmpzB0sbZNI2b/YQpaScjcUg1tj/cV5h3+AkkGFmuZ+vdKtx2Eh4GtEAQ==@kvack.org
X-Gm-Message-State: AFuF++lj3bOf6WNdVwQgnLWYJe79jm4LSd+f3vQOjO1tx7cLlUhtDICN
	VkkdLc4GMfpGeFriaGeYkDa+WHKkhQqfFMvsXqQQutzNhpRxzsH5z9QiZr1sk2WJWjymCZB8QJs
	+/sdd5BvxG1uyujxmbdxfeXe4pJ5EQnswYJPBboJ0fRL5yDSc2Yba9TxkXnA=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:221c:b0:6b7:46fc:1ca with SMTP id
 006d021491bc7-6b746fc0324mr13647657eaf.41.1788830544096; Mon, 07 Sep 2026
 18:22:24 -0700 (PDT)
Date: Mon, 07 Sep 2026 18:22:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a9f6350.6e6c5f9e.28f11f.0005.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in swap_put_entries_direct
From: syzbot <syzbot+23b25ba3c6bf971f9c57@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baohua@kernel.org, baoquan.he@linux.dev, 
	chrisl@kernel.org, kasong@tencent.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	syzkaller-bugs@googlegroups.com, youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2001840008
X-Stat-Signature: p4qw4cc4cz6cca7ho4cks7mts7ud9suq
X-Rspam-User: 
X-HE-Tag: 1788830544-14700
X-HE-Meta: U2FsdGVkX19UNOIYecDJXIY54VprvAtnt0HNXzcJr050yp6ahhkleg1q63imOD9iIcrgQurwcSeRFde9oxL9jxW6uxqiHMq3c2Mv7Zci/YQLdu2/fkTLATPleVSaVg8MtPBpCAqJkHQ7Qmz1HibrNYjqXxuuWu7B1eu6DlPDRVXRmKuSraBH6OwdyKgyyuDE9uyzflk7FHVNBw6ewNWQDdu0QvzmYgTLAHvHibld92J/GtQqCtpSy8wQ8otg2YksUswVmqYUAx15TCRQv8VfjEyV+moUBkg887UgJYBgF7v/sQt9SY16dfNw/oSWX0bLAKjjE2csKHd06ORLPL7F/YUbaMF9TuMjZDlC9vQBdWj1QzD0JtuPn0dVmNsxA1qjryQHsIFQ2wCRtdLY/MJB+x0dSxbqsdrmOVIOZqu7QziM72KXtevZu0TzNs1GAKOqJF2OF23drOvM5GzzuY3UN9+Oh2SIwXzJLo5I3CJ/v3/yNB8ffYofHRVOd4IepZfBOJzZU4brqK5r3xcTDaX3FCTdy3bybQZfm4MomginHg/R2gzaE68Vm3QRJoWLu7M00oO2gSUW2o6VZmhWvIzD4dplcaX6x2z1XMTDlo2ZrH5J6CwORh+PDY66bFLbtzW2E0tmulqyWuuH2LnrO0FvYVifeoyT8WIdgl6mIK8yq4QmlvtSfeh8DznaXrIEZ0elri+L1Xu69HjyBhvNMwNIpqRKphF2YnevqBK+nvPH4804aImzYymtO9Aom7j+5CLJ3b0H22nnTXvRATO24oito7aDJ7VWEgTnXdPd8GVIMSQcw42cAipGh8PRxK0nBesDxSlt7Pgj9zX6rmDycF72EAw19qN/XWdgBTwtM1VPZOMXtB/KWxEbsrqIh1T4YdfktpSkwJ+Z7uB8Kb1TVO91A2ieUDtpeXNTiQ/KM4MiqZ53v56e7EVOi+41NIPGVDVnPAri73ql1BpLG4N8LPp
 eNM/3rFS
 2leh1z325J20zh4v2R7Cpulz/4PJsit7D2SGiVjmXoYHaEuvSBjSDSFAbENXxjSSYn9AgxjRZ/Je4yPP34eiaDqierlnZIYCafjaEvxV/XQROIzUWqezpeVBcAO97OK/yl84tozC3PWzWENHoA1ShYDH+yW6f4udNEbt7pLRayT8xvl2mUuGbmDyIlDz0naadTzFv3SLMAfHxMjVAzPk9OBWRZQDnPFzYb1Pu25/2RXdvRdv8JaKY83ebwAkEJbpOLeJuYhE2+kAyJbJanL3Fn0gaoWjHb853BQgWiOv+KgO7H/Lob5ROluFuswaKeNGQFMOEhFottfXUkc1RKXRhiHOhAvvoUqf451dUqzl3IOvkXbOfMi1AAYSXy6eAmc8Mje8A92g6hm2Azlutvqyx9q0mBYSe3SgccS4O4UFXrxrUncJBUw1BBByq//LP6rvwb6vLehhpm3QzlYsyijse2GkbugWjJgPfq+mmSradq968O3IEgTU64lBiTFASI/LG2Fx+Xt7s6yBCLj3FfwHFX4CXi6yIIbfNU4pxd5NrSa76GOB5xdGgkantA8c2tYGDdYt4dTx0/ay2gDIO5ISOWo4OvGOnbVpM2Rj99O3fephj6qZb70+O4dYH3qD2OFT94fxXyvLJb0IQh3Vai/QKbaLwKMxLzxbIo41HmaBU3S7sobU1AgWAmotHlk6uxt5X+Otyv9YHI5mC5RlvgKPabqTbVYYvzGcnldGteXVeZJEN20z2W4xbmL0Be3iLJ9/3DlXvmtEzusFWiunIHt5X8DNvQ0qkkPBoVyn+rGlmt3ZzMVmCcYLrYI1jLxDP2+Oc358FjLvABnJHE/CtCl/ECjsLeKcuY4XsMV9UyKsYqa1zZMtUCmzpTQxM65y3fFNPTdAQHZqlIs64OlBHIi13C/TyshUq5qfTTtgu43OxtoxLylAQjyJZIk/zW07hBte6aXwJMtdUkUrin0bUcwnXvkTe4mfg
 XPd0zUC2
 nGVLfIcMbTrq6MynglYatYMmZl+PYswvRtiJf9U7U1i1sI434i9eWY/ZrRkvRJJmnkvOkFlXxeYaT6Y4t6y4PcB7Stfn+d9PrrDt6dftPpgrHQhUDNn5TYWttg9GuosewLamMGS1260mEYYrqvbC9vyDpmrgXvQqwe6cszHg4Pk9GwgvQxxaiCsr9W2cmWoUlRnYUhOLDh95a4ysFR1xXATKX7wqW09FW8u52UdqZ3325KgoqW61/aQdLRJgFDXHawVgNAQ/IBvvKcM5fBM7K4V6YiCIjHCWLaN9nobaOu61Y0mtV19FeZBYLaDW7YiZG8tbo8uAXdT2mBJHKIdGGWU99U4Xxcy8xbqSuJU37BcsJGsiLrk4/G5bS0RuX8f6bTV2NFl5XuizcqAfDUSAwGfAPLgdF5XPASiNDv/IH4ekj7nGgoqxjlHtPJHjripOA9ZpKULMcAg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    8ab1afb2eb24 Merge tag 'for-7.3/dm-fixes' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1034a125580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=85bc5cc2fc7394d9
dashboard link: https://syzkaller.appspot.com/bug?extid=23b25ba3c6bf971f9c57
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-8ab1afb2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4767b33b6704/vmlinux-8ab1afb2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/aa0bdf390bbc/bzImage-8ab1afb2.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+23b25ba3c6bf971f9c57@syzkaller.appspotmail.com

get_swap_device: Bad swap file entry 7c00000000000002
------------[ cut here ]------------
!si
WARNING: mm/swapfile.c:2130 at swap_put_entries_direct+0x17d/0x1b0 mm/swapfile.c:2130, CPU#1: udevd/13167
Modules linked in:
CPU: 1 UID: 0 PID: 13167 Comm: udevd Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:swap_put_entries_direct+0x17d/0x1b0 mm/swapfile.c:2130
Code: 00 00 00 00 48 8b 44 24 58 65 48 2b 05 64 fa 15 12 75 3b 48 83 c4 60 5b 5d 41 5c 41 5d 41 5e c3 cc cc cc cc e8 74 a6 95 ff 90 <0f> 0b 90 eb be e8 69 a6 95 ff 90 0f 0b 90 eb a6 e8 5e bf 07 00 e9
RSP: 0018:ffffc90004d9f628 EFLAGS: 00010293
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: ffff888049448000 RSI: ffffffff827595bc RDI: fffff520009b3ea4
RBP: 0000000000000003 R08: 0000000000000007 R09: 0000000000000000
R10: 8000000000000000 R11: 0000000000000001 R12: 0000000000000002
R13: 0000000000000000 R14: 1ffff920009b3ec5 R15: ffffc90004d9f6e0
FS:  00007fcd01ba2880(0000) GS:ffff888096a67000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000f740d2a8 CR3: 00000000703ea000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 000000000000000e DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 shmem_free_swap+0x1f4/0x200 mm/shmem.c:996
 shmem_undo_range+0x3fd/0x1570 mm/shmem.c:1151
 shmem_truncate_range mm/shmem.c:1289 [inline]
 shmem_evict_inode+0x3b1/0xca0 mm/shmem.c:1420
 evict+0x3c2/0xad0 fs/inode.c:822
 iput_final fs/inode.c:2015 [inline]
 iput.part.0+0x989/0x1050 fs/inode.c:2064
 iput+0x35/0x40 fs/inode.c:2030
 filename_unlinkat+0x466/0x730 fs/namei.c:5723
 __do_sys_unlink fs/namei.c:5754 [inline]
 __se_sys_unlink fs/namei.c:5751 [inline]
 __x64_sys_unlink+0x46/0x70 fs/namei.c:5751
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x121/0x770 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fcd01515937
Code: 00 00 e9 a9 fd ff ff 66 2e 0f 1f 84 00 00 00 00 00 66 90 b8 5f 00 00 00 0f 05 c3 0f 1f 84 00 00 00 00 00 b8 57 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 8b 15 91 b4 0d 00 f7 d8 64 89 02 b8
RSP: 002b:00007ffc4214fcf8 EFLAGS: 00000206 ORIG_RAX: 0000000000000057
RAX: ffffffffffffffda RBX: 00007ffc4214fd00 RCX: 00007fcd01515937
RDX: 0000000000000000 RSI: 00000000000003ed RDI: 00007ffc4214fd00
RBP: 000055f191cfee00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 000000000aba9500
R13: 0000000003938700 R14: 000055f18779e100 R15: 000055f18779e140
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

