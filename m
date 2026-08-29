Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F7EBC61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 17:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2997B6B008C; Sat, 29 Aug 2026 13:52:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2229F6B0092; Sat, 29 Aug 2026 13:52:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EA716B0095; Sat, 29 Aug 2026 13:52:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D61E46B008C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 13:52:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CFD821C080F
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 17:52:28 +0000 (UTC)
X-FDA: 85155051576.19.31F5380
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3DB6740003
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 17:52:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of 3WhyTagkbADspvwhXiiboXmmfa.dlldibrpboZlkqbkq.Zlj@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3WhyTagkbADspvwhXiiboXmmfa.dlldibrpboZlkqbkq.Zlj@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788025947;
	b=e/ctsYKfu3aUNOxLjXopsc/k/5RlQVkmqdIL5mlIVKLsIM2gC0oXnK/bRQvX0O7a3xht6U
	MOpqV28IbWN02MIAUCfvGCkbHziMJWIRhl0ZQsXeSUOII9uZLKsZpK56WQM/AS6eKFyZpH
	QVwy4VB2nYfBwAxPyUap286CKHUZ7oE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of 3WhyTagkbADspvwhXiiboXmmfa.dlldibrpboZlkqbkq.Zlj@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3WhyTagkbADspvwhXiiboXmmfa.dlldibrpboZlkqbkq.Zlj@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788025947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=G/oBzRnbhFxdqSVA70kptLmynzwRlanOYaz1/Oy6KYM=;
	b=QlfI6GyR/v8TSXkHUkWPSJKHVO0sJxQvRQIlaoIEDAZDoYT6nYF9l9RxWPoBl9LdQskZQo
	oEjXhU3tyPzh+sG6LWxBhvnFoZJZP+IgQQZqHGA/s3HdEOSo3CGqGOYorRNj/53Sj2TyXi
	4MbP/rUIxc9RQRtGXCqxOTOvxin8yI8=
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4a7de733fa9so3153609b6e.3
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 10:52:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788025946; x=1788630746;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G/oBzRnbhFxdqSVA70kptLmynzwRlanOYaz1/Oy6KYM=;
        b=f0BljQBuai/qP18Yhp2gzk0gyOQB+41uV2xWFIumL76ISUnIUKoTFlLoEs6kGSwbfV
         WRU2XcnSfI7hsPs/ry0GQSp9/q8RlVqqfy+Ygxp0xRO2kOe3R6zZLHf5ToW9zcDFNw3V
         Qmc7N9LfVKqvR0ZXMMihVlSCTmdo6aHNb5EuDTUFmiHiO0XCFmFFNVgWVBofyIooKGVP
         o40seTnoMM5Q3cJTvzAbxJtKrxRt+mak9A+sqrRfAegC+6Gc+m6o8HAejRefpnoGtB1d
         KpULORhPTsq8FF2N5aOW1y5BvKoz7cBBSVbFzOArdr4B/aKtcXrcO82+UUCRjlBjoAWp
         5C4Q==
X-Forwarded-Encrypted: i=1; AHgh+Rr7VMuPFa88pDnN8ezOPXe5381EetuOpE8JuHZlHsgFT2aPDizJSb/CnvIO3h0f2+aiejojD1h54A==@kvack.org
X-Gm-Message-State: AFuF++kUvkneN22+2FDY2R1FOkjqDmm9HNOkeDQ49TtIEWTQEfc/HfgP
	uy8I4/WLuv1yPbY4C9i6Ehc8OWQXGbttT+v8NWMCw0wCl+prDozIiW3/Y9M2Aa7ffFOdsHoIt1S
	u7nqlGs1mfdl2yTt75j1ZLwG+Smmt24SeEIOMLaIpix/dN3XK9Q8/7mWh2XQ=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c2f9:b0:4a3:fefb:899b with SMTP id
 5614622812f47-4b3980186d4mr17637489b6e.7.1788025946389; Sat, 29 Aug 2026
 10:52:26 -0700 (PDT)
Date: Sat, 29 Aug 2026 10:52:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a931c5a.08e933ee.dbf97.0093.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in __mod_zone_page_state
From: syzbot <syzbot+cd2073ee6d958a8d0fcd@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3DB6740003
X-Stat-Signature: 6oumttcr4g4wg8faxrf8nyzpcxtic4ra
X-HE-Tag: 1788025947-487521
X-HE-Meta: U2FsdGVkX1/mHyS5HEohDLP6ccN/aMtlrsGm3k6QBSnyLbDsIWTYi6J2o39oirn2dbxqDZFHWAbLTBwHNlO5pOQjH0WC9+Ba2liJLtU/5685lIL6QUD84I9LI6XJdlq5J4+MWqUPd/4Quu+rb9RUcmHbXbsvlQuI1lQLvs/8z3lxRGZx7A6DrYZKspVBpSqnPAFego0O0myE9JniIjBKyRdw1ls13OqfxL6f3lM9xutOOm/jYHLHzEnKuBkbxLqy3+lUmLvLTiZK1idR9oOTA29RKOpX+rMFzWMTEAarCbUdroDintene4IizVywUrfX2RCn7i+axl8f+JdbkTx5Knqr9sLQm61uxrtOycW3CRR3VtVr+kz6p+X0qBd1woG3LUAKrIigPztPGIuWB0AGKvb8RhKwjCZDcwNdfETBisypYHdjZ3J6Zl9uEy6CyKdqYMj8lOcRRyt3pnKdc+HsXplO2zpns5s5zwU37Fur56W8QU80Nq+vycIb84AKwaZBIHiT38WrWXO0ClFofSZmq9c1FhDeeSYvoar2+8tWh2Tn8mW+R8wY82l8YlwxSRzGkJCIxH4Xwb1RX3MxyReoMq4LXFPupQLX5dddMT27piq4y01oxJTbx798stlGt4WvkOTGq9ED/kU6otFfn5bHm8ZCdZAOgfwZG5edOEQAP+ooBSSsIFiMqMa+kaCHARa3ZkbYq1AFz9hlHD4PKjzbfpbhn4v1IgbfUXBD7cFbNXF4SpIGlSGPaSIgT9BRjktauguoWyV7NcmAYwHDdhQFxl6+OXCSf7nz3grAek9IT6GjTfYKzKJsUj18876Hos9OY8zumeXyOt995HxvYmvbKkDNm+/9LiYxsdu1DR6TyZBrcSFDpcz54Ip98cLDWLtaRMlKokWBrWtFAhz52SIYVu5MIXfDKG6V4eO3sgKeMm/4c25rBFLqf8SNtQBn5K3TzyWMKWqm/NPKANOR9BS
 jVTaAO/I
 OWDQOXI3LCM3vwp3D4ox+fY37ju+orS0s+oYAmtMv2y70htKH5RhuDdjM3uqLmppQ1Q34zDMC8nwE7ZQaby2CxXG9UiZ98V+kzD81b3mJ6dNZoYf5rjX+MNF5h8cY8ZNTevfRU9Qojk6h19PbBiRDiMtgMp5LYnBdDaAfoLWRxOy9J01rFPhD92toYPriferv5td74QPUQX8b6vLFidRJsJzp5jZXlVp5LBV3tUY3SAHJyY2Tz194AENGd6CKCVTWa2hBM+nB57pSqw8SF+MNpoIC9X6LNsLKAzHV5GKv1uZ4yriL4wDUMpv/w0J7pDAA1dp8EyY1AbpMS/Fcvlyqxzrefbhsu4K0WQhYm9fCTdfRT2c9l6inpEyrFE+712ap3Pe4xOMzD/5GWM2eTwcXS6XyZfeK1i2ARgIS+bZXcWoRKOnsKIonMaDxqnY04OcYaHzkRRhmvBEjlk9jX4zhws1qJuCeIXbqvlR0Cpab8cy58VUJRxMc96pFxOzLJC6KwO0w5VsmsRE+J2GZB2kIciocz7Jrk34oqsZ9hqCEirVBb3M/POXtaRbCAF2bmqQd3fXiaS8SN+0KI+kLexp6oKNH1e72SAz32YzrYS1/OeYZGXMnRStlMVV4H+gAwf5hSZPnFls6rfLbDK4a4LBd+5Yk9vfa0iqxhkz0rlvU+gQkUPSseuuVAgZaYPkpo+BGx7+2sPn7kNHDYMDBrykM1WyvcwZZ1Xhk6jDdlygdQbgxDv+gxz4iiwZF5Cs7jcLYe7iZKNcF9sCksuCOJHU+l7zx4AC+03RQl8jeD45m4RwtvDLy44fDl4eZJNWjFGfbz3Q3RkDZqR+Z1OzfAwpYtksmqjBz2M2dd/mlCBWAcBT/z78avqwF5pPopzp8XvhCjFFp3BXP6pcXSuifc+Fpkcev/oXa5TCzzvcyAPJTZVC3Q+u3R5CjQk7SMYoGsrI7NjTsXn71B5Gdpu0gPGIZrz7w+5Ag
 7Jtq2+pV
 jMUVTxgjU3nyl6GFHy1JpfbhNKeeG+x12V4IUwasujyja5oK676MVYFgS7adAIAIyoy0Amd6SF3R7zlr+FFO/zZVEIiOJO65iK/IXST9vXTGrM2nq8cMo+YIiaQuFqqWxH3qSGbJJFwFtzKPm5+dYc6UwGMy15Xch3/Sv724solUFy/lEH+dC8erAKmtm/KImMa+Hssbdh8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    818bebeb63dd drm/xe: Don't hand out the flat CCS storage a..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=10286d79580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ccca94d2c01b9e78
dashboard link: https://syzkaller.appspot.com/bug?extid=cd2073ee6d958a8d0fcd
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13cf7625580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cd2073ee6d958a8d0fcd@syzkaller.appspotmail.com

smpboot: CPU 1 is now offline
------------[ cut here ]------------
IS_ENABLED(CONFIG_PREEMPT_COUNT) && __lockdep_enabled && (preempt_count() == 0 && this_cpu_read(hardirqs_enabled))
WARNING: mm/vmstat.c:361 at __mod_zone_page_state+0x96/0x190 mm/vmstat.c:361, CPU#2: syz-executor412/6040
Modules linked in:
CPU: 2 UID: 0 PID: 6040 Comm: syz-executor412 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__mod_zone_page_state+0x96/0x190 mm/vmstat.c:361
Code: d0 00 00 00 8b 05 3e 44 ea 0e 85 c0 74 1f 65 8b 05 87 e0 2e 12 65 0b 05 d0 99 2e 12 75 0f 65 8b 05 d3 db 2e 12 85 c0 74 04 90 <0f> 0b 90 48 c7 c7 c0 e7 ff 8b e8 3b b3 6d 09 65 48 0f be 5d 00 48
RSP: 0018:ffffc9000627f8e0 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: 1ffffffff2287150
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88807ffd79b8
RBP: ffffffff9489f448 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffffffffffffffff
R13: 0000000000000008 R14: ffff88807ffd7940 R15: ffffffff9489f440
FS:  00005555785ce400(0000) GS:ffff8880d5da2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005608d531ffb8 CR3: 000000002cb7c000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __zone_stat_mod_folio include/linux/vmstat.h:410 [inline]
 __munlock_folio mm/mlock.c:144 [inline]
 mlock_folio_batch+0xf97/0x36e0 mm/mlock.c:204
 mlock_drain_remote+0xe5/0x140 mm/mlock.c:230
 page_alloc_cpu_dead+0x16/0x130 mm/page_alloc.c:6468
 cpuhp_invoke_callback+0x3b4/0x9a0 kernel/cpu.c:194
 __cpuhp_invoke_callback_range+0x158/0x1d0 kernel/cpu.c:972
 cpuhp_invoke_callback_range kernel/cpu.c:996 [inline]
 cpuhp_down_callbacks kernel/cpu.c:1386 [inline]
 _cpu_down+0x523/0x1020 kernel/cpu.c:1457
 cpu_down_maps_locked kernel/cpu.c:1483 [inline]
 cpu_down kernel/cpu.c:1491 [inline]
 cpu_device_down+0x82/0xc0 kernel/cpu.c:1508
 device_offline drivers/base/core.c:4283 [inline]
 device_offline+0x2f4/0x400 drivers/base/core.c:4267
 online_store+0xd1/0x180 drivers/base/core.c:2883
 dev_attr_store+0x58/0x80 drivers/base/core.c:2509
 sysfs_kf_write+0xf2/0x150 fs/sysfs/file.c:145
 kernfs_fop_write_iter+0x3e0/0x5f0 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x6af/0x1050 fs/read_write.c:687
 ksys_write+0x12a/0x250 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f90996d005e
Code: 08 0f 85 f5 e2 ff ff 49 89 fb 48 89 f0 48 89 d7 48 89 ce 4c 89 c2 4d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <c3> 90 41 57 41 56 4d 89 c6 41 55 4d 89 cd 41 54 55 53 48 83 ec 08
RSP: 002b:00007ffd7eb94578 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00005555785ce400 RCX: 00007f90996d005e
RDX: 0000000000000002 RSI: 00007f90997150ff RDI: 0000000000000003
RBP: 00007f90997175e0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f9099717578
R13: 00007f909971509a R14: 00007f90997150b9 R15: 0000000000000002
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

