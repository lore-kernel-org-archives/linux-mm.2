Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB4FACFD373
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 03:20:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F9F96B0026; Mon, 24 Nov 2025 22:20:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D11C6B0027; Mon, 24 Nov 2025 22:20:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10E266B0028; Mon, 24 Nov 2025 22:20:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F23B46B0026
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 22:20:27 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6A31813B748
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 03:20:25 +0000 (UTC)
X-FDA: 84147676410.22.BF05613
Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	by imf08.hostedemail.com (Postfix) with ESMTP id C5E80160005
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 03:20:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of 3diAlaQkbAJsNTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.77 as permitted sender) smtp.mailfrom=3diAlaQkbAJsNTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764040823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=AAXbFASOfnneTJiE0QZ3ru2iXo4qfeyeUv4gZ03xfNI=;
	b=NpOWTYU1+OoBNCV5vHIXjZ7M09od4XlHkVAzf1BK7NrG0IVwQ1LCA4tPqh4biTjAamBIQZ
	4sXvMvOXc1x6L/8sSZrKhV19S9vaUxn9aINPvdkTchd3PKQdDCvUTK9dE6fk6QprStueP8
	v5S3RwARGzNxMJOvFXFD1lZ1Z9fRfiA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of 3diAlaQkbAJsNTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.77 as permitted sender) smtp.mailfrom=3diAlaQkbAJsNTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764040823; a=rsa-sha256;
	cv=none;
	b=r64X3MsivdF9xHhjekJxFv7sM9oZBHb4kog/GXhDS6POK4I6U48sMhrc06YtehdFgyHPl5
	YhCdyNz7Now9gPEEgdduLG6uvoLjVhTA7HDy2EKpkl/A6qf5lJ9/5L6NOkYloHMAIhFUl/
	UaSe1jPItryQMqwY1jIBjs6qHpizRx4=
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-945c705df24so521534339f.0
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:20:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764040823; x=1764645623;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AAXbFASOfnneTJiE0QZ3ru2iXo4qfeyeUv4gZ03xfNI=;
        b=VZXSKwEGpRVMljV50BwTGcEZd80hvb6/V27K3CxoNjGixJ91n3OvOSLOJzCyjAmJaB
         a0QS6e9hWBR26qs6QAtHqs2AUc+Mq+GZUe1Fk7ofgQCbDHCyljZPl2E+Kfw4xbTV3gjC
         JpDsG6WlQOg2Pjvpw34ZqeoEgc+m3tKpGuv3QT2WSKp2rIIfYDhjGn1QcMKoOqvXIG1N
         1p8ZJH6kHGsS7qVlUf1TEE28onZgaKNZ0EitW/xZC9s6kWFw8fxpE8ZHqJ1SgkeB9psX
         Fz8QOJcdwUow9/w+7cQq4Vb9lviF2y6Qltd4kDCxuoqNSh9EoOcoxuUlKr7PBv0vDwPu
         MdNA==
X-Forwarded-Encrypted: i=1; AJvYcCVsTpXTT5rvGFNsUJ16OdtrPH19caOVy1jXWzVamHI2rYaiHhFXU4dJbTGTiEmROwmO3kxBpvNcUA==@kvack.org
X-Gm-Message-State: AOJu0YzXMzPaXvTE1kblRMZfXeKrXRouZu5uuNdhq+TlzFrxEogqhrJj
	QYpck0xu7NaUu3azeX8mudYGxtZS0y5TeXmmf9oGBaN33JFZMhgPgB5AZvgwb46Dmt/ECyoBN0H
	kgj8yDe2rehgiXEj3NHIWbPqEIxuAgdctxlLxJdqjr/pp7DV6DQC6f0v4YeQ=
X-Google-Smtp-Source: AGHT+IG3AEKaJMV801D+2V4MZcFVztVGGm00tD6p6en/HDKN7TYGTPe4PF84KFnNLwIV5+lwv2DBbqrm7eBILNMOH8WXMivJaLYz
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:308f:b0:435:b3f3:cee8 with SMTP id
 e9e14a558f8ab-435b9065abfmr136335725ab.9.1764040822783; Mon, 24 Nov 2025
 19:20:22 -0800 (PST)
Date: Mon, 24 Nov 2025 19:20:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69252076.a70a0220.d98e3.009b.GAE@google.com>
Subject: [syzbot] [mm?] WARNING: refcount bug in __vma_enter_locked
From: syzbot <syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, shakeel.butt@linux.dev, surenb@google.com, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C5E80160005
X-Stat-Signature: pi7bddnqhenw1xgkiujyzaj9h1zk4ese
X-Rspam-User: 
X-HE-Tag: 1764040823-269267
X-HE-Meta: U2FsdGVkX1+cquX1NNNnI0ZafDovTTceluVAcP7nRHhhdCu4/hSQIB8IrLgIZgDxXKhdb2jxJ1MqcpMU6va9eFuVJjWZSCone1a1xOdXqaIYSKV1YiL710p9DlWwsSPW0YV7MuG0bsTbsYF2GeNXF2q9gS7lCS7iqG6KnsYM5Iqvhh1QwFcF+ukI/3S7dRal8jqYiEK3Z2TzUrRYue9/+1j1BCkEl1qXD5r0VyKtxV/A/V1tG/9cGM414l//j1hcHFcqAp2tyQjKY4kbNkU5ztklFDfY6hDAzmDhHMEt109GQ68RvlQqLCy2vnU6MNDz+CzcQkd/jWRNJDOHASk46dVRktS9mrw5xIaGvFgyJtnfE2RCG04uARh72gEzMgyMsDMgb01sPU/y2IldUwW9aJXJ/GgcSoRKzaBk679C71atCFIkQY0EYC2NBHQgs0g5ex9sQIR+cfEsgH0fAaatwddnwg7JnLmW+OAd3GqGIye+suG7UHjwbKND8gjh0ys866G2TAgU6nCT9TK4OqrpSte9RU+9ezhXVu59zQbHMPG+igO6Uh4DJu598dnLkLMezHkikb5pqs0vTvD8Fg1Mv+B1T0hINy6VzLIhrB4A43mbMxVFTGgOwlqb2JFAvoBv4sPbdT2/PYIMDtcitm+O48R+QkwcJozJPJUWq/vN/khSjpVgmMYgff4WuDVBs0np0dco6dl60tnT3le3U60CN7RikOJ4hi0XUzUzojfWrhpEyr/KItVq3wzTprkeLiHGFJIy8S3T3FXg9szZYdlckX++uK1hKtFbAFnjf8F8fVwnV5XIpMHobrJEZHnQ25X5vRNFx3PmXNM/9Ke0tYCkm1kRlGO24hm2uu4SsAwK7JnURgG1df57ID7alRgFkjdjvlblVMcmeKXQyP0bRW8XoC0KPQeVv8lwdl5TS1Urhy7PpBvNeTTHfOBUN8nj696eIqr6BLGf9s52Aw3N0wm
 OJAZfF+U
 bUHQ/GgCVEjSpdBV+W8IiVFCNjRtOaSSmLC7j5WjRM7A9KxDTtw+T1iCpmBlKhJpJeHVV1G67pJo4olq7yzDdql8/TQJze53NVqtxd//GS2h5ZwYhxsrY42NVViB80jKtwtQ8YXvlNGULwnM4bgDYHzh1L02jeWFi0GBuryVqaJdB5CVjQsOvpZ2gzcDNNwmnogo3SDKfiedcg+/HDBSktIZiEgLGGIZ/AQnW+qfJpVEysm3GNuFH28aGYNI0nTxoX9ReejX/34hNrEjA2Y0UzxgGAf4MapDWlsW+eyTbcLQO7MNc+r2A4FVlMtkZGrUcrVGRwhy17g+rbpAtEaCXBbAM41I2FREP3Qab341nqddvotLJ/RerbZHUxhO5xKmaz3G0tb+i30vhreh5Q9hMk7XWPvmeiFS1qQ3vivhOiG6xul+ZvIAjTDw/zYTOicr44Q2A1L72uhG4wDTDFNjulAgXF/j0GPEBafQwfFwfcE13tAbEjYIRJbY+3o109cX9p4ePBqros5s7rf/urZofuik6BeTN+GPBJiCgLdEod6U6gX+cTZvvUYDSgXMpEzsFqLo4RsjJIebpJaZ5/YZBV4qhuN7KoXx9ueB0dDvbl4eXzta0Y5cSoQ2ZASabeaYJl/lXTpzQhPBg7JSpvoyCM5IvsQDsYE4bGk/2mvIGGSRcYceGcYfheZK1smt+POkFPojaBM6Axa+xbJhlHIry3/GGHeh1t3NGIElp7IbEUUof9zy5mjxgPoIPOx8nJLpjmA6Httr+UPTBNxDHMWYXe5fMH3bgUyRqrpAx9vk6Z6chs+ZQbTVA6Ziq65oZpQAuesjGEV+LC/GDLxikcwjqWpWKVRAHGH41e8x0ZWqRYGVuRMwUNoLFhDB1U1+wyYuO6vfaFH3ZzuJz9WW3KcoX3W/ip2vyW4VO4B5qr6f6IUUS5PEVB2BoUYuB1B/d4bzC8RrjFI8OrVavTAyr+XW6kjMJnsyj
 luTK+0mg
 cE+QXAJFf/cT/ZV0RBM5k7prrqM62r28Cs0eoFkMIHL2ApP+C1ETObAX+ktvcCR52qfpSNkt3iIokhXLeUwygJhlbgU/+QkHqEeQvanye9CfCk6kT2r6AzgtcdMj3LxmuDDWZuHQN5jwPIf7knIC7H4q0Ej+zZENbhGxr18+gTpTe513hQhvQBZ2NM9IHzBE6zSnR5tylX8jr+byWzpqwZSEcSPlPl3IEmXQcpUvy/cei8uuAVqWDmq962SqNiqQv6Pn+v7Y0haWrFiCVnz2j9ayBJ766erOEX/ewe1yCD40dbtnoVXNLdfmDCGbJhEint02Xo0bnpjTAwgppoVD/jAhJzXSMtSI1FB8xdfNLMT967vPh+1FIBThbXRkd2MbimYaesstb0DEYkJtXexGDJcN8LHKVynQher3GUliQJvZNp4wXZv55wHl2RuVFJ/FR9rAGOXYUELtIVqD0oX3IiPytx9WiVLL0MBcUWqDh0c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    88cbd8ac379c Add linux-next specific files for 20251120
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=114d9a12580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=270004e181b25d45
dashboard link: https://syzkaller.appspot.com/bug?extid=5b19bad23ac7f44bf8b8
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=147e7a12580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11b3d658580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7d546d2103e3/disk-88cbd8ac.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/af9601889c35/vmlinux-88cbd8ac.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7747417abb8f/bzImage-88cbd8ac.xz

The issue was bisected to:

commit c52a4e7b13eaa55a2c4bb08488b2cf9bd188ea85
Author: Matthew Wilcox (Oracle) <willy@infradead.org>
Date:   Mon Nov 10 20:32:02 2025 +0000

    mm: use vma_start_write_killable() in dup_mmap()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13e9da12580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1019da12580000
console output: https://syzkaller.appspot.com/x/log.txt?x=17e9da12580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com
Fixes: c52a4e7b13ea ("mm: use vma_start_write_killable() in dup_mmap()")

------------[ cut here ]------------
refcount_t: saturated; leaking memory.
WARNING: lib/refcount.c:19 at refcount_warn_saturate+0x13a/0x1d0 lib/refcount.c:19, CPU#1: syz.0.48/6130
Modules linked in:
CPU: 1 UID: 0 PID: 6130 Comm: syz.0.48 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:refcount_warn_saturate+0x13a/0x1d0 lib/refcount.c:19
Code: e0 cd be 8b e8 17 da f3 fc 90 0f 0b 90 90 eb b7 e8 fb be 31 fd c6 05 39 0d d8 0a 01 90 48 c7 c7 20 cd be 8b e8 f7 d9 f3 fc 90 <0f> 0b 90 90 eb 97 e8 db be 31 fd c6 05 1d 0d d8 0a 01 90 48 c7 c7
RSP: 0018:ffffc9000411f568 EFLAGS: 00010246
RAX: df83eb6d8e87c500 RBX: 0000000000000000 RCX: ffff8880790bbd00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
RBP: ffffc9000411f690 R08: ffff8880b87247d3 R09: 1ffff110170e48fa
R10: dffffc0000000000 R11: ffffed10170e48fb R12: ffff888025562a80
R13: 1ffff92000823ec0 R14: ffff888025562a80 R15: 0000000000000000
FS:  00007fdb5cf9a6c0(0000) GS:ffff888125fb9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fdb5cf99f98 CR3: 00000000289ea000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __refcount_add_not_zero include/linux/refcount.h:187 [inline]
 refcount_add_not_zero include/linux/refcount.h:212 [inline]
 __vma_enter_locked+0x593/0x5d0 mm/mmap_lock.c:67
 __vma_start_write+0x23/0x140 mm/mmap_lock.c:99
 vma_start_write include/linux/mmap_lock.h:213 [inline]
 vma_merge_existing_range mm/vma.c:900 [inline]
 vma_modify+0xf62/0x1a70 mm/vma.c:1611
 vma_modify_flags_uffd+0x204/0x250 mm/vma.c:1704
 userfaultfd_clear_vma mm/userfaultfd.c:1997 [inline]
 userfaultfd_release_all+0x34c/0x5d0 mm/userfaultfd.c:2116
 userfaultfd_release+0xe7/0x1b0 fs/userfaultfd.c:887
 __fput+0x44c/0xa70 fs/file_table.c:468
 task_work_run+0x1d4/0x260 kernel/task_work.c:233
 get_signal+0x11ec/0x1340 kernel/signal.c:2807
 arch_do_signal_or_restart+0x9a/0x7a0 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:41 [inline]
 exit_to_user_mode_loop+0x87/0x4f0 kernel/entry/common.c:75
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
 do_syscall_64+0x2e9/0xfa0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdb5c18f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fdb5cf9a038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: fffffffffffffffc RBX: 00007fdb5c3e5fa0 RCX: 00007fdb5c18f749
RDX: 0000200000000100 RSI: 00000000c028aa05 RDI: 0000000000000003
RBP: 00007fdb5c213f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fdb5c3e6038 R14: 00007fdb5c3e5fa0 R15: 00007fff2e39e5c8
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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

