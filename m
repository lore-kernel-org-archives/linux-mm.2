Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 792C5D41D74
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 00:25:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 724666B0005; Thu, 11 Dec 2025 19:25:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D4416B0006; Thu, 11 Dec 2025 19:25:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 611546B0007; Thu, 11 Dec 2025 19:25:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4DDF56B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 19:25:28 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0E55B134A79
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 00:25:28 +0000 (UTC)
X-FDA: 84208925136.15.2F0EF0D
Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7F60210000E
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 00:25:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf05.hostedemail.com: domain of 39WA7aQkbAPQouvgWhhanWlleZ.ckkchaqoanYkjpajp.Yki@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=39WA7aQkbAPQouvgWhhanWlleZ.ckkchaqoanYkjpajp.Yki@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765499126; a=rsa-sha256;
	cv=none;
	b=pnGwR6nGWJPeox+Ew5W+UROHWt6ibgxWXlILoeyFortPkV6OzyFSnBN+FIzmpKm87S5KzF
	09214jeIIcxXP544yLYF2Y9TgH/9MYbq62WIkszxnYfstSdd5s5voa027SK96HvdBJ0UTi
	/j5QRfLkdzdYm24wTb0OMzsXTn0cIIk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf05.hostedemail.com: domain of 39WA7aQkbAPQouvgWhhanWlleZ.ckkchaqoanYkjpajp.Yki@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.79 as permitted sender) smtp.mailfrom=39WA7aQkbAPQouvgWhhanWlleZ.ckkchaqoanYkjpajp.Yki@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765499126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=p/NrCdqDUZtACZsrvy+EiQLkTmBHiqI3EaCw4Sv1I0g=;
	b=We0NRtIdCw9IAGWqc1hbgzC9cSHQUr73/YnQCKBlLGOhv+ZsVUw6PA7hdGwKXBKxYVgbFy
	V/vmK7l9C3u5GDq+f8r8AmVZI0Dd1+pGcAG0dXfMqwYl0NfWAuNFv0sEIz8fBey1L+UKz1
	uVz777PPGaYe0KeE0bhdo2gCgIEgtmI=
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-65b3208d4deso1116635eaf.1
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 16:25:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765499125; x=1766103925;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p/NrCdqDUZtACZsrvy+EiQLkTmBHiqI3EaCw4Sv1I0g=;
        b=qLbVHdRJg1LLQOxS5MeKp/mM6shS6MCBzP3CJFUortON4q86hyWImOoQ6yti+ymwIt
         Z1ihrwDN9///vz2+Brzr/FaoL0yw5J3Pr5FqybCxt9SpZimZia5ZfsrvT7aOUGycJPtS
         eR2vzI1EHo8cuKfycT6hjNP3NLVjAqpJfu8tkxwYCYIYoI90KIKuSRvRgIWqLxLlRVFU
         oWd7VsqScds0h/Q9Re090iyXF8lO5kuDBGzFl6d0aKnGwG8DXYMVHXyqF44ASDDFApQk
         0RA+JGuQU+U8pg23w65IGT5eSV+mfox+4RQ1bvtdzSUup8wbKFYLTs+mzwLUGjs2mloz
         Mlng==
X-Forwarded-Encrypted: i=1; AJvYcCU+WjeX0HPAHyd71MkC6/j8INNqQao6+IncUeZGHW2gQMk4o+n7Lo3PmS0katUaFYbWHV/eCbTXIQ==@kvack.org
X-Gm-Message-State: AOJu0YxqueIcYO05rS1uXocT6Jjt+FxwbPfQ5dImQC/QRC5kOwRuUCYP
	0aA8UCJxlGznx7RAclkU74m7AOwqjvJyqy2yJuy4xCNMDG5Jql5uQseXkoCm+O9X7R5kI33np8D
	KmJL2wrLFCRCaTNH5vuo6v64G3r6PIvBKPcGRUPnYls9Kv3FiWV3Xh+UIV/g=
X-Google-Smtp-Source: AGHT+IE96IZQqt2rK1+9HkR+Ou2xxjyLstdmoZGNVd8+7uYY2fEtqwNOquuUPK1gB4Vk2Mh2EXmKXYoB8Y4oWDL4EL06ZGd+32wA
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2905:b0:659:9a49:8f74 with SMTP id
 006d021491bc7-65b45736683mr126458eaf.57.1765499125456; Thu, 11 Dec 2025
 16:25:25 -0800 (PST)
Date: Thu, 11 Dec 2025 16:25:25 -0800
In-Reply-To: <692fc776.a70a0220.2ea503.00cb.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <693b60f5.050a0220.4004e.04c5.GAE@google.com>
Subject: Re: [syzbot] [fs?] [mm?] WARNING in sched_mm_cid_fork
From: syzbot <syzbot+9ca2c6e6b098bf5ae60a@syzkaller.appspotmail.com>
To: brauner@kernel.org, jack@suse.cz, kees@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 7F60210000E
X-Rspamd-Server: rspam03
X-Stat-Signature: 5h7j9mjbjwyrme4f3djy1yorupdukf6f
X-Rspam-User: 
X-HE-Tag: 1765499126-138769
X-HE-Meta: U2FsdGVkX1+lBV4pEtfNwDRjrric07B0+eFtL1V4s6Xf6OkCja4YH8ZYfrM2xX0k8f4+Cd9uOBEs/d1nwobujq1S9B+YXK9jnMsdgyrTg5FU/7gGI80d19v04diAd4sf6r4e/t4FMPLN1uPedMNPgxycH/OeD+aslelTcpJHoiqHg8CIymhegNDgSmWWWJpEB34C2HHZvSLJFBmoVE71xkq5xItb/ClxEt1KMHp1PRRGZNxmlqkjaoqaz6q4t/t1rXiwpfb4OGC+CI8TDY8gjP3h6pMVr1OhvZnXOLyzB1gr77eTxgJ0ARsTPvuA8VL1L4PvnEh4TeDRbiEMws9VZcYUs1Xgv7peYUy9mNOoHKjc5XusUsIw9wWDlh+9exwPhVIegSA8bMeQbbbXZbzyN+TRQhGW9ix3CATb0GUexxg1eLD8668dH+P3IIvCbIsygUGUAuXaRl9Q481CqyxsWoaJvYVJhHABUIDmkOaWDDkBGUTj4XWEaEEl4J0Cbp+UIwY5XEp32X58whIn8rA85CSHA/W3RPj1w2VKfhbcNIO0ugCz9SgmurNKCSz3DVjo31k8xosGO1l48b02kImulUpFk3ulpV4Mq7Qj0jCKysJ4LfIbymlBgUnjiriWGyBZy5pGLvS5l/X8Hpg0CuOUzPfN8b2mWvsMIncUaWnQKUqg+TUPYu8BRAtiSTIjD8v9dl9swWwd+gNxkDhTlm7tq5Q7JF6PzPuejvHxk/cK1BTWrZVo/YhzB6IFVVCscjv+CBcbO5e6k0PX1CoVg7fi0ikeUcOea5SlO8f7i3+eWcdcUtRUuwIWuvEO4oLdWzlIKRcGxcWzVxeOqMd7lV2SLYEDg9/nG/3hW/9CCEPq9UxDqRZrwMQXe3QjG2JeYXVWLxXadXpIoTZr71+dNOtMaEDDF8dvWDkmaFDvMQGkJgyr9ejwfoXparp6+Y3q0yOOyMkbr2Jg2mOM786Qyz7
 GbpWgypo
 L1Has0Zm2Q5w/tdGziNZWPmg36+IPTa2H1ogAQhIjnptE/uVd5KLmuK2rEVnS0kdwbyEtnXbTHdgGO/FFOGriOzuc6jdb3kYDD8SMLyCfS8ykJRUEwvWjsKvjeozcl0Ar/JU7gNlnMutYpWYHIS8eRv3In1FKOmWM4/UNF8jZgzLeHdGSzWAkDXN3g0sorKHKzYD4tlE+dSbRmrQWtMB0MrcFqnmYSdtWVoK2A++5Ciwy9XKyHjIIOXivORNm4eL/gWVlpwXQa1tuRD6pvcxVmKxf2VBOi8A1Tikix/c2Wo+eBxPCb/w4IyXq06K8mDcglUIuXl/hhiNkqB2D5avct2eIvRLhYt96eJyhsFo2QEeumlpzNaHAhK/B1N9smD8x7yk/sQSxneP3KqpmdHwSCsT0pKwZfXLXxNjvUYwqpEPtioyy/pg5ahJzDEv8E+5L6jNuC/r2HPjr4IoCD+sMMcySo6Nsgunaqd+JIjonY3/g9lYdYQOTxs6a7FHD7itK8YBPMgTkigHbfXy2pmPFYNosK7PTitPqdE02skgsC7xZSG0k/gWOmwV37U415kzWjFZyf2B4oGpiybJsWvKyFfCEWRy7puF4ybnRzBW8tS3yET3CxxKxkNEoZWpR40rsJm1F2xU9/NNRKDylHVM0Ihy8KmegvJlPDL2S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    d358e5254674 Merge tag 'for-6.19/dm-changes' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11c0d1c2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=de48dccdf203ea90
dashboard link: https://syzkaller.appspot.com/bug?extid=9ca2c6e6b098bf5ae60a
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=144621b4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=124621b4580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-d358e525.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3fa1d04c1a85/vmlinux-d358e525.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a9b253146e36/bzImage-d358e525.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/4a5df3575982/mount_1.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=11119592580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9ca2c6e6b098bf5ae60a@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: kernel/sched/core.c:10569 at sched_mm_cid_fork+0x66/0xc30 kernel/sched/core.c:10569, CPU#0: kworker/u4:4/5674
Modules linked in:
CPU: 0 UID: 0 PID: 5674 Comm: kworker/u4:4 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:sched_mm_cid_fork+0x66/0xc30 kernel/sched/core.c:10569
Code: 4c 8b 3b 4d 85 ff 74 21 49 8d 9d d4 15 00 00 48 89 d8 48 c1 e8 03 42 0f b6 04 30 84 c0 0f 85 13 0a 00 00 31 c0 3b 03 70 04 90 <0f> 0b 90 49 8d 9f 00 01 00 00 49 8d bf c0 01 00 00 48 89 7c 24 20
RSP: 0000:ffffc900036cfbd8 EFLAGS: 00010246
RAX: 1ffff110067b79e3 RBX: ffff888033dbcf18 RCX: ffff888033dbc980
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888033dbc980
RBP: ffffc900036cfd68 R08: ffffffff8e295e83 R09: 1ffffffff1c52bd0
R10: dffffc0000000000 R11: fffffbfff1c52bd1 R12: ffff888033dbc980
R13: ffff888033dbc980 R14: dffffc0000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88808d22f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6ad913e000 CR3: 0000000041a50000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 bprm_execve+0xd88/0x1400 fs/exec.c:1776
 kernel_execve+0x8f0/0x9f0 fs/exec.c:1919
 call_usermodehelper_exec_async+0x210/0x360 kernel/umh.c:109
 ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

