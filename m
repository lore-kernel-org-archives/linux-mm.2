Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D201ACD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:12:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FE996B00DB; Tue,  2 Jun 2026 06:12:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 388E96B00DC; Tue,  2 Jun 2026 06:12:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2508D6B00DF; Tue,  2 Jun 2026 06:12:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 108C06B00DB
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:12:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B382E1A082F
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:12:32 +0000 (UTC)
X-FDA: 84834558144.21.71F3098
Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1580C4000C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:12:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf07.hostedemail.com: domain of 3jqweagkbALkrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.78 as permitted sender) smtp.mailfrom=3jqweagkbALkrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780395151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=CQRbFmvJYEk869FT66rgZ3P3ea3IF1pgad6clP7CS1c=;
	b=p+6i3TY6DLbjY0vWc01nRQ/1GB0WzVMuzPytz43K5PhCJg1xhkepg41qMYsgDAll2GbWu4
	SWg9EZ3eBZduf5fZg0gAVqZTHaLgl5Ipi2AJoHJmhwqYj+O95J9Ni5/oASaXdHuHCcumfe
	RZJm7aPkor/zLED+7CAuhYgr3qQTIdk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf07.hostedemail.com: domain of 3jqweagkbALkrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.78 as permitted sender) smtp.mailfrom=3jqweagkbALkrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780395151;
	b=MtnC8pQKVT2j++okgQxXIpGvfpOZYdHOBgv2oaqbdXXB8JirdOg6K8vKYRgQJgDgoLpVsD
	YPfrLCQclen5mXGAgftW3woLufuT5InIfDyUny7UiPhhPHNoRqNOBoiabrWatiigJSSq93
	pt9gu7jmxYMo9N7iPKwTvjT0dKsVdTk=
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-69df6e55f3fso6319056eaf.3
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 03:12:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395150; x=1780999950;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CQRbFmvJYEk869FT66rgZ3P3ea3IF1pgad6clP7CS1c=;
        b=KTGwWqkJUHlaLltCCYhy9vEbQuApEuiopYovWVy2aAWuNmQ6cUeTqyZ/RNKSrcqU7z
         RfBR0rvaPQjodj1JYIiJmwJNIoXz9s772b0ibqtnJSGnY6j+HP6aI/PBlGFvj2Psr96Q
         rGipyVgw+RlJWhkxVLbs+mzhPHDE/yqg1gXlglYYZ327FPAvHh7k5Af0rHFQxMlDqk5k
         6u1S9TS6IDaHgwA9KTMLeVKCUbmnzXFEiXR/Z6jy88nRo4J76Nlz3ZEdtdMlmMuhO5sR
         bAZ3roSkp6U25tB9nhES907k75RdWOqEY+5dpJBdB1FKJwxBiyEtsCGJH1IG4K+H4d8e
         Fuqg==
X-Forwarded-Encrypted: i=1; AFNElJ87STr9BtytbkXl940AhW5by95Z6XyVYc6ImG0WTyhcEZLUbEFzDFu0vDzWO4t5uAMqcGb4Se7XWw==@kvack.org
X-Gm-Message-State: AOJu0Yzu+HalETWWt1po45suUCDxFmSS2KWo80f3nRdljZ8tBOyeGlr0
	ezeT3BEFESsFJhNEBwkGBtVXx0kwRZSAlGtYXvmlMXKJCFFuO4CMbZsXie9SH5/RywtIC3o20vy
	RRN/Kb7llHe8hXX71Qc0odCqkQBrXqCulzE8g/RvMCHmHLBkPjO6QymN6wrM=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4c11:b0:69d:fcab:c640 with SMTP id
 006d021491bc7-69e1059f467mr7411099eaf.42.1780395150198; Tue, 02 Jun 2026
 03:12:30 -0700 (PDT)
Date: Tue, 02 Jun 2026 03:12:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a1eac8e.fbc46276.3c3783.0008.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in swap_cluster_assert_empty
From: syzbot <syzbot+deedf22929084640666f@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baohua@kernel.org, bhe@redhat.com, 
	chrisl@kernel.org, kasong@tencent.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	syzkaller-bugs@googlegroups.com, youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 1580C4000C
X-Rspam-User: 
X-Stat-Signature: d758q1cadamqzdnzoj8am7k3n1st3x8e
X-Rspamd-Server: rspam09
X-HE-Tag: 1780395150-964810
X-HE-Meta: U2FsdGVkX1/9lhff7Dj6IgRZAtTbvJaOGHmyyzgYE/CEXI17GVj2p5HMBgtsmUka1yn5Zb5CJeIAexL3FPZBMkLf1zL4p1sonL9VSh0Tr9QEIx+7MniIovgdEJ+dNY06v/p7E8lDiGC751Z/bcC7XuQ+okiae5arkTZ7JgONIUzN7QdabzA1NWoFxiPXWEI5SD43Iw+1S75+mEExLNDIlwEltbGgY49F5vC2XVq20d2lG6+kZFwTuKfNAxvW1mMYht2zBsr/cmTxUteMMw3LuLSBTd4DeH1kBLo/ITe2yjYQHuOIV/ecfAvE0tLzG66kFfGMGR6tIZfb4gosK2dvxWViOGSQ2ljm1P/zLDifyryTdOW588v/FyZvwQbvDikAlSurJuD/e0YDaos70zJ4DtXtWO70jd5MU1Jsv+mTC22vIq4gZIxpJop4KALWFgQ040NmwlLiXaZMh+TmdsNX89WxXR/G8CrFErWDRnWSeNTLXMybIGkTheEaaMAeoIHRsJ5O6Y9OCJsmyk4ThLMSqrqZcZ5rXCOP308fqKO5FHYb4OmyU2VV+EmHs3a1rG/8hOApcLAEtm3RKaCnxuOD4GZ51ivoqC3YDOFx5n5ZGIktxSN99zyZ0T2TRdkusTgWLg3z1AyHp5VxbWAZeD2BqJSewrXtKEU048VaujyzOwBLwNsWBmJ+3juHjD7LJ5YUFkRbgFQJe5lOKVXh37FQUfE+27RMRR547ATycLMT5mogVYY1UtbDw5gwjkEjxz3L0BhfF0SZDIKCJHOoh2ztMwQQZzS8GVsqWVTRohMKlWC6dyewUnuMBcJ5XyKprvfb4y770JvS61rWfdLpZ4N45uKRk4q0wJA5XstUip5l874r2LPVYukH54n8myO0bRVEiytnch7uNKsNLAxLj+9DOv9MVT2llZC+nEr/QDDm3hZyMfWODFJ8EGP3mbIby5MnmA2vQYQfJsF3jmrO+1m
 wODEz1BD
 4cjoyzD0X24kGf72ZnT9GJtEhH3nkiIMBO9FPrBkkCpnLrO/Zp3krGOKi9TdrGLkrZ0fGdLdg1U81owhuFtTBEr2IwXDlF13kL/m23uz/xc8/PEZlPY22QeUhbOhjNonNN/r++w2rkA3uKoSCFP/eck4ZMowHlbe1YVtMQuxE6Z7GInXlvBsZc+EWtCfu4ia/Bf8zNSqeS1F0lp2xZbONLFqPbHxGCvlfEDEUmE7y3aS6AzBRu7OKZWBEvbWw0WyBZKdmIdTSdGDfjPG3/X9zoAjU3Fq5at3leskrUHXNsBOnX2NJZc2nnhRLsSkESInIC2XvuRPe3inBmKZ8BTybigfEDkgVubwo23F4/dBq2XD7oyEXai4YmBma6go88TrxzSPMN2CThsFRdoaaXT/o6DVANoiohLRlQc4jyEJ3+Iocwu2AO62MFm0OE3PRXCqkrbLFF0bzMKCD8lWHD4bRzyAxskI4ogzlR/SFVIEIPPAODAS5jTz8JwZrdROYuitN9c/ifC0TBLvZ4idgmzQRp0MNW93unhJiZjQYvYoEW+wAWo09jU/FxmyF2hC8m3a6Sq+Q/FXafPCBExoT0T7mYQLYYHhioTs/O/aUHoVQkXPZ6ByEaAt3O3Omqd50nUd3yYZlIwB3RNyU5+fbawp7f61m2WZUwXsSYwI6/FG2q9dLWqhwWzCvDYJMs75399JRWChJEwBSiq3Rk9xu84TF/wIpuhGTzFX0pxV05qYfAj+suH50q7TDxb0LPKrx12NSCeW9bo/SVqmtm+fSY4HLrzYUCXY7J7XCFVFc3C0mKFb0EZc2ZQV2vKdK9VGJmrAX9tEvUpAeypynW0MPwTalPve6JabUWSo/2QIO5klgeDVfYRXJeZx0V8/l+yQiBriplah936uToCwxa8SATi5grMxvz1PuQ80xj65DYXbhNhMLMZrIrqmyz8ZhOn33bfz5BzAQSsTnea161WfBNtDUzez25sZ1
 raO9qbkm
 z5wu7k4QG95MqQkfFduHFvvL6s8iD3Eqw23CfFaMzkrDyM92YHf+mMS+gYsAP/scQAuqiEttvprVIkzdnDnUSJYmOCcSbo36B6OoPSAAeRwU1pREwq904THYgriFj6AMC50UrEydafdBacfCvvQpzpjlfevG642MSB8iXCqDSO4WlxqOTkJ/7K8Qo8fAyqu6M0mjfK0EqZr+NKtqhMkhvPBy+byodaGkhC1X92XQjJ77Rz9AdYQPsTo5LjQGHLelPbjpp0mpdnczvnn76+lk/XfkXnCVnLAJDR2QUe82xFrz/kRyyIMVKeh/uCPQBKJ0cW8Ip6wW3grts653bZivG5gTIqbeGJGn4wC/iq413/U41QaxV13PlgDOUf4vEUDuraHm/9L0UK0zcO49OC9hqbkX1Q0Q4fRFs/nja3HFTdMC/LVCW/N7PDeKf/JRd6vvghW6vlKLskaO+0Sr/k1WxMYg54ZtUxAaunuDeNyO6Z4BnCwejNodHDHVE8NVj1QF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    8fde5d1d47f6 Merge tag 'acpi-7.1-rc6' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=118c327a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8118209836970b54
dashboard link: https://syzkaller.appspot.com/bug?extid=deedf22929084640666f
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-8fde5d1d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/529080512bd5/vmlinux-8fde5d1d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/39c09b74f46c/bzImage-8fde5d1d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+deedf22929084640666f@syzkaller.appspotmail.com

------------[ cut here ]------------
nr == SWAPFILE_CLUSTER && ci->extend_table
WARNING: mm/swapfile.c:471 at swap_cluster_assert_empty+0x2d5/0x320 mm/swapfile.c:471, CPU#3: syz.1.267/6778
Modules linked in:
CPU: 3 UID: 0 PID: 6778 Comm: syz.1.267 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:swap_cluster_assert_empty+0x2d5/0x320 mm/swapfile.c:471
Code: 9b ff 49 8d 7d 50 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 46 49 83 7d 50 00 74 a5 e8 4c 09 9b ff 90 <0f> 0b 90 eb 9a e8 41 09 9b ff 90 0f 0b 90 e9 6f ff ff ff 48 89 ef
RSP: 0018:ffffc900039d7098 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000200 RCX: ffffffff826d976c
RDX: ffff888037a62540 RSI: ffffffff826d97d4 RDI: ffff8880273450f8
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000200
R10: 0000000000000200 R11: 0000000000000000 R12: 0000000000000200
R13: ffff8880273450a8 R14: 0000000000000001 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880d6686000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b33323ffc CR3: 000000000e596000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __free_cluster mm/swapfile.c:585 [inline]
 free_cluster+0x14b/0x360 mm/swapfile.c:714
 __swap_cluster_free_entries+0x73f/0xa30 mm/swapfile.c:1894
 swap_put_entries_cluster+0x473/0x5b0 mm/swapfile.c:1584
 swap_put_entries_direct+0x123/0x1b0 mm/swapfile.c:2072
 shmem_free_swap+0x1f4/0x200 mm/shmem.c:985
 shmem_undo_range+0x3fd/0x1570 mm/shmem.c:1139
 shmem_truncate_range mm/shmem.c:1277 [inline]
 shmem_evict_inode+0x3f3/0xc40 mm/shmem.c:1407
 evict+0x3c2/0xad0 fs/inode.c:841
 iput_final fs/inode.c:1960 [inline]
 iput.part.0+0x605/0xf50 fs/inode.c:2009
 iput+0x35/0x40 fs/inode.c:1975
 dentry_unlink_inode+0x2c0/0x4c0 fs/dcache.c:476
 __dentry_kill+0x1d0/0x690 fs/dcache.c:718
 finish_dput+0x76/0x480 fs/dcache.c:927
 dput.part.0+0x456/0x570 fs/dcache.c:976
 dput+0x1f/0x30 fs/dcache.c:968
 __fput+0x519/0xb50 fs/file_table.c:518
 task_work_run+0x150/0x240 kernel/task_work.c:233
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0x951/0x2af0 kernel/exit.c:976
 do_group_exit+0xd5/0x2a0 kernel/exit.c:1119
 get_signal+0x20ff/0x2210 kernel/signal.c:3037
 arch_do_signal_or_restart+0x91/0x7e0 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:98 [inline]
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 irqentry_exit_to_user_mode_prepare include/linux/irq-entry-common.h:244 [inline]
 irqentry_exit_to_user_mode include/linux/irq-entry-common.h:315 [inline]
 irqentry_exit+0x39e/0x970 kernel/entry/common.c:162
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7f3317d9ce61
Code: Unable to access opcode bytes at 0x7f3317d9ce37.
RSP: 002b:0000000000000030 EFLAGS: 00010217
RAX: 0000000000000000 RBX: 00007f3318015fa0 RCX: 00007f3317d9ce59
RDX: 0000000000000000 RSI: 0000000000000030 RDI: 0000000000000011
RBP: 00007f3317e32d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
R13: 00007f3318016038 R14: 00007f3318015fa0 R15: 00007ffc650798c8
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

