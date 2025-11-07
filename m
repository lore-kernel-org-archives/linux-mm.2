Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 526F7CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 07:31:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 912388E0006; Fri,  7 Nov 2025 02:31:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E9748E0002; Fri,  7 Nov 2025 02:31:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 826908E0006; Fri,  7 Nov 2025 02:31:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 730608E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 02:31:30 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 208D0140385
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 07:31:30 +0000 (UTC)
X-FDA: 84082990740.18.5574FBD
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	by imf30.hostedemail.com (Postfix) with ESMTP id A0E048000B
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 07:31:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf30.hostedemail.com: domain of 3T6ANaQkbABYEKL6w770DwBB4z.2AA270GE0DyA9F09F.yA8@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.205 as permitted sender) smtp.mailfrom=3T6ANaQkbABYEKL6w770DwBB4z.2AA270GE0DyA9F09F.yA8@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762500688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=DC5whZ6xjAg9orncDEXG9Mf4Zikpjttx0BkeAU8vHTQ=;
	b=vFk/vNrc6OHwHOM5f1zWSvhALCmWVZ22HV2ac2NALgKMBVShydEJ4cFQGZ7q6FpSBNGNRC
	3h4tUuzvJQqrGN08z5Rgast42jsKOlvc0+WQYEMbKycQ8gj3ORoBk2ZhBHTYOdZpfJeSEU
	PRRteFSjxkK536OmOnxAOApRgYSNK0o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf30.hostedemail.com: domain of 3T6ANaQkbABYEKL6w770DwBB4z.2AA270GE0DyA9F09F.yA8@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.205 as permitted sender) smtp.mailfrom=3T6ANaQkbABYEKL6w770DwBB4z.2AA270GE0DyA9F09F.yA8@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762500688; a=rsa-sha256;
	cv=none;
	b=5dpx91PFZzVEnU+7EPhXLbeeQ1Bh6tOX5GACqJn9y2W4P2qrsebhaOu8bYREXc8U4XlsM2
	FY8uyepnSX2jKyYpq/oREAXH4gNtw+L6SRRO+mQK+22qV2uu4gohb6mG1BvuGuK1MjthJu
	jxpRcVQG7OJcz/V2UKdJVnLjyaLcZdQ=
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-43327c30cb1so4338075ab.2
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 23:31:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762500688; x=1763105488;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DC5whZ6xjAg9orncDEXG9Mf4Zikpjttx0BkeAU8vHTQ=;
        b=bGjOTEQi7YGWcs/6SzTUmWNTnXte44SY1dIyLRyNejhHxzS/ldcHzBuZ/w4oV6mGDt
         f6oZrtwUzg6hBvSC6tH6POP5HBm4upTfc/luUlW+YJZkbxgY3gHt+cduWCMKa5+vRfHA
         Z4GwMgw9p/GpfrirqKj9NvjNUMh1HglIo0islxCOuzeeZrXnnZFsA657oczEQo7zfwS9
         hGrCHKDaNsC3IfnhBoAf4aV98rjnzNsecmz57wAtlBSazvrCYFHbSDXzOPW6t1k/aJX7
         oIpaWopcExtvmqfyK3tT2AIJky8GZ3B59jKMYrhjKgBb+YSqbkIe46CmZIYEIiy4mW98
         QWMw==
X-Forwarded-Encrypted: i=1; AJvYcCXVfwfkr+LJ5YfDGBaTmRorRox8iqe7X31mpYU4nx/smDwfLOZ0SVSuEKAdfN1zn0+NiPB8/IlGvw==@kvack.org
X-Gm-Message-State: AOJu0YzkDLmY5GK452QSgUFwDFbVhlapwHDjDV3albigVXX4zfXA6gev
	9450FfVHq5Hb7keLNPdcHCgcLGUJMJJrmABkUCw22R5Y5Q5YFNAgE63MI1Y7ymmuoGd2Ap6J+G0
	yOpDofA2Aev7Y7i0cBr61x+LNVgMmb7f/DyQsVKWA0aT56a86GweDihhiWew=
X-Google-Smtp-Source: AGHT+IF1mWmFU+QuzP+6G0raJVSuUbhvWf35rIhwvg/7kKBEsHrx+TEWgqipXwdks6Tvvg+v62pf8jfuYyIcJq7AP3kS3CRjzES2
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a64:b0:433:290f:c201 with SMTP id
 e9e14a558f8ab-4335f3d0389mr32665345ab.11.1762500687581; Thu, 06 Nov 2025
 23:31:27 -0800 (PST)
Date: Thu, 06 Nov 2025 23:31:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <690da04f.a70a0220.22f260.0027.GAE@google.com>
Subject: [syzbot] [fs?] WARNING in destroy_super_work
From: syzbot <syzbot+1957b26299cf3ff7890c@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	anna-maria@linutronix.de, bpf@vger.kernel.org, brauner@kernel.org, 
	bsegall@google.com, cgroups@vger.kernel.org, david@redhat.com, 
	dietmar.eggemann@arm.com, frederic@kernel.org, hannes@cmpxchg.org, 
	jack@suse.cz, jsavitz@redhat.com, juri.lelli@redhat.com, kees@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	lorenzo.stoakes@oracle.com, mgorman@suse.de, mhocko@suse.com, 
	mingo@redhat.com, mjguzik@gmail.com, mkoutny@suse.com, oleg@redhat.com, 
	paul@paul-moore.com, peterz@infradead.org, rostedt@goodmis.org, 
	rppt@kernel.org, sergeh@kernel.org, surenb@google.com, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, tj@kernel.org, 
	vbabka@suse.cz, vincent.guittot@linaro.org, viro@zeniv.linux.org.uk, 
	vschneid@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: A0E048000B
X-Stat-Signature: ygghfza85xdb6hr9qhwezo68oti51tc1
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762500688-985724
X-HE-Meta: U2FsdGVkX18/whylwtjWZVsLqr3AyBwajBNuBg93bAR0t4JrM11EAbCytYK3ej9xWGGO/mgvqubmJa0yJXQ+hd1dUEoLz6jAS+r2MGiJZGljMuVXIM3NIdccBPbO63BlYZQ1tA0+q795HX21teHds+UGYRMP1UfzXoXUtQWobJsJ7HWV2h54sjvqTUAfQ7YnaDNwaRqyt+ci6b+WckEAEMeWu7L3MEcVP6ONlkuPpyzrKemCh1aernUcOwbbjM9NRXb4exsm0eClr1jW69z3umuJYm6D3xbfYvRf9SQlUwQ6Xh41HOIDqm9u4FvyGgkOk2YSCnDErheCrytDn9azA6pDle1zvxhdVHw3VxCETxH/0oc9vY1L0k6xbfq2kmWLfCZkO/rWoVezsFaDf3LGpEAMe1OLvW903wS6SudlkWoKk47Ky7sHXSOSkfbcKo9nFVkg8mo8rrM79dOcXZq6e0jtC2lVS56SWpsOf8CrYR016XCHt9q6vqNPFKGq2vRCrqOkm3jH+5wKXyHV+Pgaem/lBnu7QoLxQAFJaGCNyvHZ/RNqbhJilzTYio3XJtL7u6dcDrmAr9ggblrvNUS5a1XoNPkZ1nd+2JMVfLZh8T4hIHDH0rNyz0u3Yx3xU7MQR+hxrLvrhauIgHZ2bBHyMFC+lLXWEISlUKu74UqaLOkZYxLZKaId1IHBHB89bp5wZu9aZr+z+V0W0kYX7mAe7PG9Ae4cvfwcl+hfe5RjlFioM5HzDuTwYaR2/3NUgVSk2kgrfWl37LLQZUA7sb78xXmUADApUbQjN3ehub+AloFVojKvoxPWCiJ+C4QAAVY6nLr9rCMMFKk/4nYTDBh+9Ja8bZaSDp5A812kacnrFziXYvyXNIHqzaakZ/TL8Qsc6YwGf1ySqa05OobN9yMC9b8IczSWnK/QM5aZUmMpBP4i+KUpYQEPfICsRP80M1SADT+VENT5bc0y0rMxn1y
 RBKMlk6q
 5edZgyw2EraX9jijBEcfb/YZmP0XqWYqN7a+5GYHI9s19LfRsmF+WWETPhRKb/g04umTCKPkjYqJyMD5zciHzf8I6i2HEn7kh+h8opGMura6L3zMiWYG/zTe0lSJ1aI5c3FymZ5J/YA+I1U0QPwnUWgXaMN56UvYekpOQfSXJ7r1lvWqAUwWa5Zt8Ppv8sHQUo9AQfA+iEulegUHiDcTevGh5LIbosoPRI5Yy9yR0ToJIDpxjeZd4GEpRDj8s3B7ytaZY1+DyFmSBsHc2//wRiaF20hx74aoYNSvTWNUrttrIvVU80Z6Ub1hSnroWACImk1Fv480dk9G0a9eLpBtl+WjVaBPIxVUXLr5sdNySY6KxV56slL1DMkrhAq80Rw97r+RIfLClkb/Qb7vq74eg0i7C87b7+GebMR+3phhzXfK1AoKYTpkX7X9VHSPR6OTnha+mZwsbnKWqPKGZF+xw9oNMcMWpCrr6p38AlbRTyJISJx7ii9i99ygK1jO4+DbonL6BHGGiGKJyGb3DQpOxnyTzsekedbg9bg2mEpk33AvoDt84gwRwwQrxin2lQ1idNzilEbZ7QSwIgd95Oos4CBQQJwvRdzWiNdebOkbq4og2k6tKRlM4ypN6tp3GbvhTa4Dl3Wxz0V/YKlswuu6l8ShZriTNXwe7R3/Kidk/wy8j4WcXzuCGxhaRG73rKMTO4LyyU9clkj1WOxqL3AmNGSsp+ksoL8zbWVjmETaZU0LVV7iRS7W5mLt2vA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    982312090977 Add linux-next specific files for 20251103
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17b2932f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=43cc0e31558cb527
dashboard link: https://syzkaller.appspot.com/bug?extid=1957b26299cf3ff7890c
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1347817c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/40058f8a830c/disk-98231209.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1d7f42e8639f/vmlinux-98231209.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d8bb0284f393/bzImage-98231209.xz

The issue was bisected to:

commit 3c9820d5c64aeaadea7ffe3a6bb99d019a5ff46a
Author: Christian Brauner <brauner@kernel.org>
Date:   Wed Oct 29 12:20:24 2025 +0000

    ns: add active reference count

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=101e9bcd980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=121e9bcd980000
console output: https://syzkaller.appspot.com/x/log.txt?x=141e9bcd980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1957b26299cf3ff7890c@syzkaller.appspotmail.com
Fixes: 3c9820d5c64a ("ns: add active reference count")

------------[ cut here ]------------
WARNING: ./include/linux/ns_common.h:229 at __ns_ref_put include/linux/ns_common.h:229 [inline], CPU#0: kworker/0:6/6108
WARNING: ./include/linux/ns_common.h:229 at put_user_ns include/linux/user_namespace.h:189 [inline], CPU#0: kworker/0:6/6108
WARNING: ./include/linux/ns_common.h:229 at destroy_super_work+0x15c/0x1a0 fs/super.c:280, CPU#0: kworker/0:6/6108
Modules linked in:
CPU: 0 UID: 0 PID: 6108 Comm: kworker/0:6 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
Workqueue: events destroy_super_work
RIP: 0010:__ns_ref_put include/linux/ns_common.h:229 [inline]
RIP: 0010:put_user_ns include/linux/user_namespace.h:189 [inline]
RIP: 0010:destroy_super_work+0x15c/0x1a0 fs/super.c:280
Code: 90 63 ff 48 81 c3 a8 fc ff ff 48 89 df e8 ec 90 63 ff 4c 89 f7 5b 41 5c 41 5d 41 5e 41 5f 5d e9 8a 91 e1 ff e8 45 df 86 ff 90 <0f> 0b 90 e9 6d ff ff ff e8 37 df 86 ff 4c 89 e7 be 03 00 00 00 e8
RSP: 0018:ffffc900030d7a48 EFLAGS: 00010293
RAX: ffffffff823a294b RBX: ffff88805639c898 RCX: ffff88802ab59e80
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000000
RBP: 0000000000000004 R08: ffff88807477565b R09: 1ffff1100e8eeacb
R10: dffffc0000000000 R11: ffffed100e8eeacc R12: ffff888074775658
R13: dffffc0000000000 R14: ffff88805639c000 R15: ffff8880747754c8
FS:  0000000000000000(0000) GS:ffff888125eda000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c008044000 CR3: 0000000077ad4000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 process_one_work+0x94a/0x15d0 kernel/workqueue.c:3267
 process_scheduled_works kernel/workqueue.c:3350 [inline]
 worker_thread+0x9b0/0xee0 kernel/workqueue.c:3431
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x52d/0xa70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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

