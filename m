Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CC00CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 23:04:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 925A46B00AF; Tue,  9 Jun 2026 19:04:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D6276B00B0; Tue,  9 Jun 2026 19:04:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EC536B00B1; Tue,  9 Jun 2026 19:04:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6DB6B6B00AF
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:04:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 14553164EFF
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 23:04:36 +0000 (UTC)
X-FDA: 84861905352.09.0B9CC46
Received: from mail-oa1-f78.google.com (mail-oa1-f78.google.com [209.85.160.78])
	by imf08.hostedemail.com (Postfix) with ESMTP id 61145160002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 23:04:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of 3AZwoagkbADQiopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.78 as permitted sender) smtp.mailfrom=3AZwoagkbADQiopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781046274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=yLcbPIP3DqH41We2y8RFQOo6XVKoUumZBhjBdhDFF2M=;
	b=Js70XF4BSKuMCYvkJcr8dXRwJEWtKeF5BVkTuw/hU5qG+bPUL6xiPSsG/ok8WSpxQX7t8T
	yfy9Ih0VtUsAeQNGvdBYTzFOBFw+FuqTi0q2QBTfEbFRQAXlD18y0dqVrAg2fyueTJtUWh
	BMiPknyEEGziMFFtXq5Xanp6t2ZlNa8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781046274;
	b=BrWTuqFFjRWvbDfttR1rgkZAURQNriTwIyhLwkUJG7IMLWggg69IDoo1ylOYp00CRLUV6k
	Yo8kHc3ckRP+QCtqWrdO2pbi1sTbj+ODCv2Cu0hWb1d09Tm+keq9Qee20AZISL4cKFRg4H
	jBLvtD1cXQ3U8MlwjvefC3gIgb0kNkM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of 3AZwoagkbADQiopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.78 as permitted sender) smtp.mailfrom=3AZwoagkbADQiopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oa1-f78.google.com with SMTP id 586e51a60fabf-43cce86b0c4so9677152fac.3
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 16:04:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781046273; x=1781651073;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yLcbPIP3DqH41We2y8RFQOo6XVKoUumZBhjBdhDFF2M=;
        b=hQjPybTqHa/aGD2jvQosVZMcykXiguvUoa2L3yHz3cUiaxATHUJleITVAcYPckGJMb
         qBQznBv5tjMW4ELu23t6U4U5gWBo/gRBDifYlUe31xjWDsmsx2W7fZJhG5LZCu0Eky0S
         XE+K0Oqyz6PNTLLrUj4mAma47yzNXOBlELhkg4FxinSdv8aHJ3vARp8LlmWQqk2gT9lr
         wLQYt4vwFcOgfz00iE2N55RA70HHtEvgrzbOlV8LYDhoyzcGfshb93X5A9j59njcfrHo
         GgOtYBkLIueo03b7g8DmLzOJDf/rh0nRggAY4No/x2OP34pbUO3I3Z6yOZz+CY37i3iS
         cU/Q==
X-Forwarded-Encrypted: i=1; AFNElJ+CtfsxdF1ZCFcXuz4BDnRzsAawJsI3coAlPWPcWwYL2aqpNl8boiP4aVAWijzw2KczYBtkHT+qCg==@kvack.org
X-Gm-Message-State: AOJu0YyUx7tTFhwy1MJfI6MLIJZ7+7vbgVRmvr1A9+PnOGC1XsNz+2Ux
	XRzxmXnoCzJXpLICBfIxDtsMSVpkOApYxwELIArl2qsqsqnuztkDi1wjOlkR0g6E2katxhGBCtK
	kM6FOo+oIuIFe3tkw3UAks0NawwqI2O/I54bX2CHpmvNSJE5QP3erMfNhejo=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4b86:b0:67d:ea53:b9c8 with SMTP id
 006d021491bc7-69eac8d9b8dmr3506618eaf.18.1781046273469; Tue, 09 Jun 2026
 16:04:33 -0700 (PDT)
Date: Tue, 09 Jun 2026 16:04:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a289c01.39669fcc.33b062.00a9.GAE@google.com>
Subject: [syzbot] [cgroups?] [mm?] WARNING in hrtick_start_fair
From: syzbot <syzbot+2cbf10efc23b22ff9c31@syzkaller.appspotmail.com>
To: anna-maria@linutronix.de, cgroups@vger.kernel.org, frederic@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com, tglx@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 61145160002
X-Rspam-User: 
X-Stat-Signature: 5j6rz1h1wpmhfcsn1ecznyqrqgs73foy
X-Rspamd-Server: rspam08
X-HE-Tag: 1781046274-636773
X-HE-Meta: U2FsdGVkX1/naUHydapv4sWONKHnxT2k8Ip1fcMLgADXm8MQmijutWlRG+Jd8ZlvA/ccu2nIbbA8WuVK9iQZqW6kvFF1yp8MDX9pwgOlcH8vwtO1AkejSfjdeY+pHk5k0WaM65dlm3KRNBYxy20clD9ov2eCPCPLDq1omVbRVqVHtTy3m+cPTKH0v9rNLZacX3XEE6/IJtEv3HkBIhdYcUGPcZ6v1GX2QlNFExv7SdTTGjAtU6ir09W8DY02LTjDeEznheLt5NKykMaKrpQ5OvHUcdBuyxwxsHsPotX/mJ8gHn0eVGYxwvxh7BmcAqq8burmphAbyTcKcLyI4486ni4xJt8BJC59mKpVCjgqbKZ9jcd9+ZX/h7MZRx7e0zySGlNpk/rgYdmqY/l+uwAqViQKGUwmpXVObPURxxWj1gOqxVKYLsagfUrKo4/PsMVCfB4r1k7KDYKxN/CF6PBrUXcZreEoCMDVc6Y7TAILI1lC4rxphBGSFKn4EK6DmImAkXvYiTGe8j8WMJJdT2nmeiXXQNS89LGWZjJFkk+tCbtaUINV57MRUkhaGnFN7Fs4g7sywzakzuXKBctzA7BFq5Or0RHei1tVnksZbqntsXrfifsRaYLNcY+UB+8Ju/ppX/GTcXHiHtTtJ6XrnSIDReuTxDxSf/d0155YNVqiD9xNXfDzS3B2/MngJUfbeIwNqScppIF9VxGsnv9cSqNygXGQKMZCmT9UNkF9UgwQVLuA+TkoGXRj1QCSaQ/EvZrye4m02tUyy1ZAj8xvzD+fgv6e+gyhzCeEyCbUA9W8x0UXNc+DHFejKKp4Z7GcxOjhgH04NGLFA8W5CYBbWdvX1ofI5Hl0xJfY1lh5OoANS0kbcOntJGEBj4ywBR3VKuLFGIcRdY++juKMs7b4F6aWKetRc3h4vGfs6gXuCFiNOiH5hSF1+IrFIIJyMT+TAjYRqmfbrgQFjzoG5lMdhX2
 tlPndf2l
 +rkEogc6hXqTCMEDiYUFuvCoCyY5yRbZHu1LkRkiLOpfUSQZl0504jHoEy6nUrg76AS7Sd1AD8b335IAnB7mldMwv2ZbE/tCujoXS2K8oTYjZKt/A9KMxFm8ZdfZc1VGsL2FiRum62BGuhHHbfXvO4Uk6xCD7InWHU49+ajd1YsbsgUP4QkvJ1YD4ho3UxwJEoL47VhF3M1Ag7cMs6Hnrv2fC7jimE8BdMvkpKOLxjPpDrcw98SnbzCawMYf2hi9QeA20mm+j+2mOS1Yrn2ZlYdmc7AEnn7/8Asu3eTF46p78pQcqGV8V5jpeQGMOLAB1h/NxLX07PzdwUNnfk1Jr4ZMOF4aSuRasJbMONn8PHQ5SAWoOhKCaXfnDgdBDYxd85hqP0silhZuPCIQUgqzxmSZIun1NikPEBehDuFmwPPj64oDCdXUzYdnqkWFCF+Ni9nTd8XTj6D9Tjb2pyyf7a6S/EDcMGZo4gylnDgRoN5fJ1aKXFif8kpL3ANt95AgwZPsRk91+MbnPy6WXTyzN4gJbLm9R4CRCS9hjHYuJ7PPbvM5BnLUvzyP35HjwDk8ncPgpBDklz5sh/9bWOcuJe6Rl0YvKVvakI+1blfcVcWCUFYzkJJwXUPytL0g6uv5JEGBqHxhFob8LjU/2mH3Kw8w9xsgUdEzpjyXhRSIi/TpEfxiFgNmyDG3Twak8MqJckNHHfWJg1fj6c+VVKAwj39EORApBn5VUcwtMylyr6OmUrQRedLbGf0YdKwYhR9bvWVcVtUNnckIMemDZ4oijnPP932PwncRwkMZrYwCF7HuogxFDZduYwRlSBDw/qMThP6uWmWZLnwk0sj2PbLdW7rvQ51YOOXnAGCQwGRFtBaD2p58mc3QH+6bhamOhHLQNJdaHZdiSnYy1VV+bJ7omgQ9UCqmzgYF8W6g4sCE1kElxapcUYhy/XlxluZbc0PQMc6+CsDSh2c9GDRpxpCTNHLvsltIJ
 nGcQ4x1n
 YRnLzsiiqtBNBjEBCimIYIShvkAImd4cCCwdTJtrJl4ZnILjIf2ptRKiTWLgYfdPcNbeKECNj+E7/vkdT63Vm7TJmu9dm8jKfmvAhjxreHIOWwvEYJyvt9SZwHGp2iGL2RQdTyX9+bsmK3+7zgjDe7DMBsl5CbhH3hKHPEMaACntlhLU77xk4I76ITXvA+cVWHCbviFYY3nS7atcjY2hTof+c9EsnIRNcdtQBQn9gIroYnZY/rFZ58+yGzYVJDvJuibzLqMu0DzeBTLXpcUpK5Wyo7ZZItYiKMzLy47RDYwN5uaiNMaYhuPIfZaH45+RjbQ2V7+1VS4a/Chx06ktqrtOeE70LHESVapqW3vkPZnetsi8MlngLYR/2RddKH1UmMcWXroak83I1iX+BWD4ytJQEeNefIfxK3ApGriKaXp5IX6JRBeUhVXA04eXCSuSeDLXrnwCWeICSf0cZQtRTDrhAL+shsJhgheeawQfjOf1bgboWRrJ899K76Ui51+B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    a87737435cfa Add linux-next specific files for 20260608
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11715db6580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=da47745f686dc823
dashboard link: https://syzkaller.appspot.com/bug?extid=2cbf10efc23b22ff9c31
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12df60ae580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11edb0ae580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/85d19fe6bb4e/disk-a8773743.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/30c683ce26e1/vmlinux-a8773743.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4db5027513d2/bzImage-a8773743.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2cbf10efc23b22ff9c31@syzkaller.appspotmail.com

------------[ cut here ]------------
task_rq(p) != rq
WARNING: kernel/sched/fair.c:7656 at hrtick_start_fair+0x196/0x1f0 kernel/sched/fair.c:7656, CPU#0: rcu_preempt/18
Modules linked in:
CPU: 0 UID: 0 PID: 18 Comm: rcu_preempt Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
RIP: 0010:hrtick_start_fair+0x196/0x1f0 kernel/sched/fair.c:7656
Code: 42 80 3c 20 00 74 08 4c 89 ff e8 85 e3 97 00 4d 39 37 0f 85 0c ff ff ff 48 89 df 5b 41 5c 41 5d 41 5e 41 5f e9 4b 65 fa ff 90 <0f> 0b 90 e9 d1 fe ff ff 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c 82
RSP: 0018:ffffc900001777e0 EFLAGS: 00010087
RAX: ffff8880b873ba40 RBX: ffff8880b863ba40 RCX: ffffffff8197c7de
RDX: 0000000000000000 RSI: ffff88802c528000 RDI: ffff8880b863ba40
RBP: dffffc0000000000 R08: ffffffff8fcf0b0f R09: 1ffffffff1f9e161
R10: dffffc0000000000 R11: fffffbfff1f9e162 R12: dffffc0000000000
R13: 1ffff110170c78d6 R14: ffff88802c528000 R15: ffffffff8dc217d8
FS:  0000000000000000(0000) GS:ffff888125a76000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007eff95e6a540 CR3: 0000000028e30000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 set_next_task_fair+0xa68/0xce0 kernel/sched/fair.c:15058
 put_prev_set_next_task kernel/sched/sched.h:2770 [inline]
 pick_next_task kernel/sched/core.c:6443 [inline]
 __schedule+0x3e03/0x5550 kernel/sched/core.c:7144
 __schedule_loop kernel/sched/core.c:7308 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7323
 schedule_timeout+0x158/0x2c0 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x312/0x11b0 kernel/rcu/tree.c:2123
 rcu_gp_kthread+0x9e/0x2b0 kernel/rcu/tree.c:2325
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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

