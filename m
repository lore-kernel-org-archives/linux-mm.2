Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF639D116F3
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 05:15:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73BEE6B000C; Wed,  3 Dec 2025 00:15:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 714E56B000D; Wed,  3 Dec 2025 00:15:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 629776B000E; Wed,  3 Dec 2025 00:15:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 51B926B000C
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 00:15:43 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8832212DFE
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 05:15:39 +0000 (UTC)
X-FDA: 84176997198.02.2415E45
Received: from mail-ot1-f79.google.com (mail-ot1-f79.google.com [209.85.210.79])
	by imf18.hostedemail.com (Postfix) with ESMTP id B776A1C0006
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 05:15:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of 3dscvaQkbABUDJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.79 as permitted sender) smtp.mailfrom=3dscvaQkbABUDJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764738936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=5jpaUZOOq7cavjUJv5Xb6gMlLaSFoTX0r4WXny4bi0Q=;
	b=0qUmB0hRI/382Kx4/DahRnossDGThNa33blJTwZHNYGH4vOyMe4PuiVlmCkE74y98CIF07
	ZZGv+teQkDQ3LRDOYPcq6wF/6BZ+S0WIPnw6OY3Xe6dxTv8wNNV0moj5PPL2YYw9Eo7xdB
	frWbC9cP75nlpK7yxUHoKOcZRozbAIA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764738936; a=rsa-sha256;
	cv=none;
	b=VnbR+O7/HtGj8ICMNa33leTaZW5J/fgPYxTxromkUESI+ICIuaFXMN711CSCzB9LAggHAn
	/HM1GREG+Mt6xxm2ADa5J/uDXL/fxpa+rAeXQOMfX68Z4E4PqxHZx6FowzNtKO4KM53q9a
	n0g/qkDGXJX4e/shLfyWYROYlVo/LnI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of 3dscvaQkbABUDJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.79 as permitted sender) smtp.mailfrom=3dscvaQkbABUDJK5v66zCvAA3y.19916zFDzCx98Ez8E.x97@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-ot1-f79.google.com with SMTP id 46e09a7af769-7c6c91ba9caso7186621a34.0
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 21:15:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764738934; x=1765343734;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5jpaUZOOq7cavjUJv5Xb6gMlLaSFoTX0r4WXny4bi0Q=;
        b=CBeYu9BBOBFjei431b9WbFAGnO+E4DyCuJZ7CBMJLQxr6e0RN5XxRkld4MEeBD7iye
         W0ECt1exCTqKA1mYuaoM02sYTtLkmF45kth5sUlU7ltomiTqRrz39SUKkx2ONXFcfPv1
         5hqK6WFupPXG/jaMSiy5nvm0CDeYqn8NmWM9AxkW4UDcHwAMVoOk+Em1QGNqddjpiY2q
         t/LCjl0OzockEkAdJKLfIqFPa+BcUuuSxptH/Cm1xEheranO7vmYxyOijgXcUGnxZICy
         Fj8V9c2duW8FrukU7CIx97TyFNbeE1uvpGhYY2fMorFuvvCWRHEaOwgydBdUQ5pyMirA
         Emzg==
X-Forwarded-Encrypted: i=1; AJvYcCVTSWlYWtsfgOEvPwwJNhQut19Z3O/Iv5QXAk7wHNOz32LCZh1WzlMXk9GTtNX6DFL7lK44NDusIA==@kvack.org
X-Gm-Message-State: AOJu0YzqOCzUMnJX4qdHQN9+OK2fUkd97SgYysvjdel7eR24np1gmHkk
	eaBvWS7oXvB2/pDpcFkxOIboXCPYpSEYsrocaWt29w0enYaUIZL0MG5i9KJTEp5bKwEwovtoUE+
	jVlo6KwIjJ4MK6j2SS4GDkFG0LCmVfHA7NwZNpeS9d7bBr2FVzJTTRez4wMw=
X-Google-Smtp-Source: AGHT+IF8D/UvaWUn6H7GvPv1bXNJ1X3AibKG8Cy+1t4joLdEtbwXVCmVaZitPZkA0w7Bkl1Vt91KoswX9J9S+1NDGFzdz0xDqe2F
MIME-Version: 1.0
X-Received: by 2002:a05:6808:191a:b0:450:1f44:da5c with SMTP id
 5614622812f47-4536e56ea7amr479647b6e.45.1764738934684; Tue, 02 Dec 2025
 21:15:34 -0800 (PST)
Date: Tue, 02 Dec 2025 21:15:34 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692fc776.a70a0220.2ea503.00cb.GAE@google.com>
Subject: [syzbot] [fs?] [mm?] WARNING in sched_mm_cid_fork
From: syzbot <syzbot+9ca2c6e6b098bf5ae60a@syzkaller.appspotmail.com>
To: brauner@kernel.org, jack@suse.cz, kees@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B776A1C0006
X-Stat-Signature: 1a9psu84mx74rkmcjc3uojqse3qomb1k
X-HE-Tag: 1764738936-46328
X-HE-Meta: U2FsdGVkX1/PeckCb/En1vsKiNZDQm/rfTUDV58149X0+wgb2XTv6PEtzwnN9u9TFvS7rxWSoyfq2Yxhf7/giE1m4LtqmjNT1stiDcMj3+Us5UaX2+aSeNbegTk4sI5sTUeoxyLlQukU5uhlhpx/rdVcFdb/Qp3VX+ZUwgfYXPUm01EVXakM9pCJbxjm91vQ8pTD+dP6cDlTJXgC0iuSotaoR7KX6TzFK+Bl2eaPTjLYh7SE0KFNYCupjUZYLPMFL4dBnEfpdzosQdnCPlzIdQZKbFwGiZ8/HNzoeFM34klYtevc+Xl1CvDmJ9OC6KLNY24E9xPnM43VYxD/1yFXL1nG8nKd+coIs9metz3ImpiC6mLO7DqZRyE7AOd/c2CB5prLYfOp7ZCoGm3JJtV4SIcsrgJ77PIk5K52Rio185a/a7QznHIRFEaCtYICUACL3cjMpTqYFxx/2tOmb4AYd3H2AjPTL5tobNioe+uXWnoF6mfVaAq0nII/XgCYzrtvk/fIV4L1gatQ+k1Up29YMj1bb6ttMO3H6OeBW57ab6Jg1/R0WkjZFQ5IDLyzR2NTNcuroCogjCk3F+ilD8vVklXBNDYR2vUGG81K8sFLErVVZAuNc/9OUsMeG4M4flVHDFrGyO4uyRM5iPbosOXomoY6WVrD1iUIMicoNy5rQgJDgo4AbDkpRRCjKzNkfuFXrUXTO+tde+/71Bl/v4O4I6buam0mIoQsGOIWoFYl1G8jReNkbi+MWDOUf+R44l6kBIMNMsPw9vnsm0dDGY7RX9zFK7PvAPaghdi+3Zv0/TFQeJG3E1A/qSzffqymlul0ucBapTD+0ylpwOuo3y5kkKUhXmBByGPvZCkZQi2p5iaeBravPG4sbGqygv3STwkXs1Do7q3KWZpDRPxDfhPUnVDHAE1HJ6sPyP74fXwpbEDy1yCaEU6wf4Oz81aghS1iRyvkLTsIul66YjCovDX
 nCXbKlBm
 1QZz6j5q7T3wevhONph8XDM2X8N3oGFVZoBi9czxs8r+ZqWLxddLf33X8yLlOtFqaXu0p8zL4iC9tzdsdW/nXSqk3pgirZwK8xL7NWGMj3p2KWo9L+vmpLKhuihvPb28Ik6PtWhGvAwknGiCEeCMs3VSeXH6xU8ucuFw7d6fbAUIhPI/aYqZVOFVtfUr7QT8QKMBj9G6sCOfT2rxIb4TmIvfyUODFagq7J+NFYnPf/XKJO3X/oDBdyp/OOanRGBfGZnmQlsk3daQ9zz0uNUEa5NcP97Dxcy/I1UEPDnyC7DdyxPcHt9Iek55j0XJ1xUqjv0yB60vGrIYs+lfNQBf+6F4t4OVHzZu0kjJZEidjeSk2llO7OxHsy83XMWq4s4zBM+x2+jRxQqO6yGGCtoPqUtWO4ei+YaKYPB9VZxq4YvIu0NLJymLBOF8BDLqEJPBhtMQYmBw0bYdn2DHq77DcvZYorWu42bXMrmKY5iFlcCIVK7sxQnH9bGEkeOGRGOQj2C4WjdPTAUwBjYLGY1Ge264DI354k2A/JbF5mfTs5t5q1kT/Sjy+7vvGo753CwUfF/gi//vNX58LgBVPD/Mt1tI4jGhq/nmts9+UhOqjAS4bHI4Ju+R3CTpeBPe0btEkvOGsPMVw23IR3MQXDSDIQf/ZOT/pMfxXnsbpzMOeaOY4L0Hk+KJl1asfCpkev9lWqKf03cotDb/WFPV5IYMD7cBzNYn8LlxcC8eLPYhZ9lu/SApxJVz/zCvtDTLgGDAs4LQMQdRLcPrC1tO75bgQol3WVYUCVKErz88+b7KfuuqSgNORDACc8NtFc4oC0iFuy/LwTx4OeTvPiDXchMrnqBCmCYully4PHte9qNS5lNkMRZLmIsueQIhr89IVOV7WaEjDPxTkMjtN9k7CTY5QIW2JGRuIKM5HXIWKU+61jChw7n0C/+8WJfDA10N1VoAgMEAaK7novZopgECzFO7Xt0MaaPVz
 +jM/dPnc
 3kWtMrMic1+I+O677vB+c2xsP2ItNK4lnuRYcoESq9SuVvBujvNmq8z1ulHagh9O72RAQ7LWWlHU6K96Zidg1FVFSNm2cmBnLg8OctyKIUU7VgTwznoHzNfw1QqpMefse+BWDWwHOrrxEnUQMqOVTM4o1pxfCR7ZtVDCciF2Hhb6x7L91b/eDWE9NFur2R1bMe5lSswbWzR1+Fr7DKieALYI9or9sGLWEibpGz9or/k6IpwjhsYE5hRbu4Bc9GsOSXiEA3B8KWoIxfhKVPbMRoYWFZ/uYXy9QzJnkOW8/LJEY1+BMCSkeXr8GuGff59DUqJKJv3rjHF9zihW8KBuU/3HPLxLs4QVxxvRkQcwegbtqg/XKfvDdcKKNjxCFzV1pvoOGDRhpqkoFAzrl/2EsjX7Yfmo/LmglzeQ6dSHVmrugfmSbjkwZDkn+J9bRAn4Ws9Zw7gfQ7C8XxDZCy2EsUMGDFnt6apLIm5UwLfA4lt7qLCGqBRM4Rvqm5gcJvIc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    7d31f578f323 Add linux-next specific files for 20251128
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=165b14b4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6336d8e94a7c517d
dashboard link: https://syzkaller.appspot.com/bug?extid=9ca2c6e6b098bf5ae60a
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=104a30c2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6b49d8ad90de/disk-7d31f578.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/dbe2d4988ca7/vmlinux-7d31f578.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fc0448ab2411/bzImage-7d31f578.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9ca2c6e6b098bf5ae60a@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: kernel/sched/core.c:10573 at sched_mm_cid_fork+0x66/0xc30 kernel/sched/core.c:10573, CPU#0: kworker/u8:4/6077
Modules linked in:
CPU: 0 UID: 0 PID: 6077 Comm: kworker/u8:4 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:sched_mm_cid_fork+0x66/0xc30 kernel/sched/core.c:10573
Code: 4c 8b 3b 4d 85 ff 74 21 49 8d 9d d4 15 00 00 48 89 d8 48 c1 e8 03 42 0f b6 04 30 84 c0 0f 85 13 0a 00 00 31 c0 3b 03 70 04 90 <0f> 0b 90 49 8d 9f 00 01 00 00 49 8d bf c0 01 00 00 48 89 7c 24 20
RSP: 0018:ffffc90003167bd8 EFLAGS: 00010246
RAX: 1ffff1100584e853 RBX: ffff88802c274298 RCX: ffff88802c273d00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88802c273d00
RBP: ffffc90003167d68 R08: ffffffff8e093e83 R09: 1ffffffff1c127d0
R10: dffffc0000000000 R11: fffffbfff1c127d1 R12: ffff88802c273d00
R13: ffff88802c273d00 R14: dffffc0000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff888125e4f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fcc18973e9c CR3: 000000003470a000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 bprm_execve+0xd88/0x1400 fs/exec.c:1776
 kernel_execve+0x8f0/0x9f0 fs/exec.c:1919
 call_usermodehelper_exec_async+0x210/0x360 kernel/umh.c:109
 ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
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

