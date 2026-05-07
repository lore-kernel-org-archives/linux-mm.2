Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EADC3CD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:26:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61C996B00A0; Thu,  7 May 2026 16:26:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A5C16B00EA; Thu,  7 May 2026 16:26:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 494216B00EB; Thu,  7 May 2026 16:26:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 34AB16B00A0
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:26:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F07321C04E2
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:26:32 +0000 (UTC)
X-FDA: 84741756624.23.81C2EDC
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2E1E5180007
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:26:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf16.hostedemail.com: domain of 3dvX8aQkbAKsdjkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.72 as permitted sender) smtp.mailfrom=3dvX8aQkbAKsdjkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=L2WONWyz3vyIeJgP+mk5Nk2Yi6BT4HkHvHdaFwZ2tg8=;
	b=wkqt1hVD1zBr3JlhK/8m/wIntsmyKtIsnLmW2No78G0EKy8G4QvtHOJMeD1NYxS/lArL57
	Fi80VhDp25+48sK/4ipGxrTq0F3WWAkiw77mlfc1P5V2I4tjaNfNnudo5W8k54d0tChZ/r
	zzVWUtHTTBUnzSTq8pxG1L2ZdOaqtC0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185591; a=rsa-sha256;
	cv=none;
	b=GwpXoP+GEsLr0K9vs/XyiA+ho0qVmaLm/GmjKizehWnoRVW/Ow42zKw7OUT7+VqNr+APL2
	Pwz8hDcNYp/w9kORbbhTwJaG4PyjyNSIUEhCcGbX6Z7E8JBb3vKVC35carpzYj8TNzcS4U
	nnGUjXoKqreSW/47d+qvNeaCmaS2+p8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf16.hostedemail.com: domain of 3dvX8aQkbAKsdjkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.72 as permitted sender) smtp.mailfrom=3dvX8aQkbAKsdjkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6961bda4505so1900410eaf.3
        for <linux-mm@kvack.org>; Thu, 07 May 2026 13:26:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778185590; x=1778790390;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L2WONWyz3vyIeJgP+mk5Nk2Yi6BT4HkHvHdaFwZ2tg8=;
        b=BHe82xyMmIlQK4hJQnHSJsESipfPc3zTDAo7NdyyMeN0SI/+cuHwynwzcfmAORb6dt
         4dMi4gMc51cXOQ4HkBzWWWeN3Oo/Y2QTOLKe7KAz9+GUfWjTVFdVmwQult3AtpBX1Mzl
         8H/1Mx/nEqLqkFW8K6M8oVDybCQHQ+vMcQ0ppX/0tLtiGhTeT+rUZJCYxue9MCXIZmi7
         cZTsqnFzOHxHxG3fhsYIzaPQKbPlz8A9DKqPFJk+wuXv4KOgeIeejvUDrp/YETDDX6hH
         so5fLfSW3+auVZh0uueXE5ZtRPG279aY+0GmDPnj1650pKNrJbO36odagcj8PZakpBFS
         CrVA==
X-Forwarded-Encrypted: i=1; AFNElJ9vai0ztmtf78PgOgBZ9IpvGUMmWakrDFRAINlkrH1RztAFOrMTL9mq00u6aC4aC1WNWDiexiUAzQ==@kvack.org
X-Gm-Message-State: AOJu0YzAgLI26UV8yBU4umtZ6/lgZE95WBqn+RFFmEXMmiU8Fzui2O8/
	tGJFUiw6Ci7xM80JosexsWFetCDbWaORYTtNarYSk13T93MR69sMUMfuImqRGbEgCs5aRe3PXOB
	IvGt+AaUDPzhMCFfkXGBz1T5qb2YPrUXTCyvzOInWGm0fiuD2HPtBvQsm0f8=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:906:b0:696:154b:24e with SMTP id
 006d021491bc7-69998d0da8dmr5259737eaf.32.1778185590172; Thu, 07 May 2026
 13:26:30 -0700 (PDT)
Date: Thu, 07 May 2026 13:26:30 -0700
In-Reply-To: <20260507114854.41117-1-jillravaliya@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69fcf576.050a0220.3cf765.035d.GAE@google.com>
Subject: [syzbot ci] Re: mm/vmalloc: free unused pages when shrinking
 vrealloc() allocation
From: syzbot ci <syzbot+ciac423580ac76ff6f@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, jillravaliya@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, urezki@gmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2E1E5180007
X-Stat-Signature: pxsfcorkkoxdwisbmqooraay5qyk441w
X-Rspam-User: 
X-HE-Tag: 1778185590-56486
X-HE-Meta: U2FsdGVkX182+wZEe8UFRmAkCNN4Sq4Dfaz5R+BDlJ9VBePz0Fy4GdrERm6wOlDI/ec9dbbb8zy5X487Q/8C2hHRIyKZeNa9ViYMwAgt+qb9pi+rpatvUPqZg8Tjokeq9ZCYC0oxxOwDb0bqEpblF7FOqTxXQ/7ELkiTHJYcvWHZqq2A1ARgiUHv9h5CkdhLUKmypTaKLp95HGULpbLQV5rgVz1byDuHlQfn27HtAgkB+C0zj06y1A7VVgjFYOLfKuslw0cYWF8FxTgZ+QPnuYm5E4AkyFyBSe7h17FRZoo9dP7071kdPj8GZR5Agcl+p0VWfyWg573oEVl4pK5SlLBXbcLBlPE22VpoU3dfWw0ow0VlZSZQSM01itHkT2f6F3FHmRM92YVe98Y/DTGIUTwRrMVO8ZPt7HkyYf6t3A8pJXoVPrtqytazItnXrOefu+ycuLfD8KQz58lBWx1JOR6eAu23uPhgoI9OgJnO4P+Rw8pZNzGxjTNYmCc/D8l9lBYyRPZFIGD3DXfhWQ15yG8kMGUMq2YVMqAB80XPHyRblpb0HQImWgQsiWJ6oKqFZMsCfRaviHER6SPpAD3l1NjChQ/XAfKDZsDlSVxPWw95ZAUKxaTxvN0lDFg/tXXNp8bTczWICvkLGyLys4RiH2iWNhDJe9gU4H34WVI52Bm8CtpxE0AEQgKE1RsbgNArprjgH1fi0uWJ23ncN3zezvkFAD8RJQBETnpSCrstz/GY2FMALK6sJNX8vN0IJ5dUTChZOnqQxS2Xl+qIg2dmEu+aWivmZEvjsEvKAjIhjWdkXXM97a38b4bSSWHj8Ys2j5wJLifza06HN2NmiUQS0C/pq8EFUDh0uQgwnAe08+BUNWU58lRNldo38eBUxZqXgTXpeIAFY2AYB0Hk/CHIuDkenm7hoGqeT9yULsh6fQPtV2uLUxp6bvJDg0tW/mYvH26mWLxJPvSMg4p2vMt
 5DhtbV81
 w8DAiSF+ROB+J2j3Fy6JjoCAh7ZybOK9P3XFB2w3MNAggzMcHM+7p3tU/3XoEyoF1BqMlhHE8kctVADgPaZ2XlIeNclOgtVNXU+YCueMbNCj7GtYIAWPc8JDrJMqURTdl8xZRpJrjHB/jYDFhA4aRuiZD9pjqixTD5E9luGokhDYHiUaxIYXNLOtBuPJ6AwNFWWv6c7Vl89q+0ExNQ3jK6cWApYIZsW5Ad5D4ev+zAWbHberVlXa2158EtrXgmcJAOXfm150nXExgYxbW2BJbfFUy1sBCzddNQNl0FsUVjZtDjoX1dCGgdFl2e2ufTFKuF/T/3xnT/RccYcCLEFQGCWzOe0Wxc3eDQ0326ieeWj2kaonrnXiRSP6DJlgNDpkWehUugM4a7eHzBDL0gcCmmNx1bm6sQt7p5RgIWSq4Rl8dUazI+E5Kk7df0kb5gylWVdcp1D8gErDdS2UHGIq/yRs2s+xT9jkRab3he3A/ZEbMOsC+7emsMFELzFGSa3y8//31WdWrHiWfQpqg5i0eSjFLvS/CuGB7xLUcC0bjsTmiCD6aB9SMz0g0qWaYWJJtvEoAimpXA4H6U0X739jGn42YYh0CX4/dcVoWhawLfEn5D2OdAPpCyCg/S/WUpd6A5U8OJkUa9AwQj/Uycf1EuEv1uKMhbmzLCd9OD9Ft8etMu06asiXGZaGhXLaLIA8C1r8/eCdPyTjkT1xqawhswUMmno+0Q4RxOyNG5GDTXNMGrE/nts4o8Nsb1SnudjVeZ0tVyKRqWOeq2nq4NG5Bz1p+fWsQFTu75FvtOtaTeZwLdhqyXEAsgKSVXgEOkEZdHsmI1Enl3natTGYCPGPtYu2F15X0PUqRGXMcfLlc6hyCPnA83pY1qeWIDK/ctWjHd+8mRp6xo77u++/MUqIL5ICWDF3TeHsxQRjcjsnJgMzQiECPAWy+VZTFkf0InlyBSH4PZksW4pJ9NKj0wKnTQJtklnQA
 btUmf9E+
 FDqIl/AdJZdw3JfSye51+iKeGGIDK+9X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] mm/vmalloc: free unused pages when shrinking vrealloc() allocation
https://lore.kernel.org/all/20260507114854.41117-1-jillravaliya@gmail.com
* [PATCH 1/2] mm/vmalloc: free unused pages when shrinking vrealloc() allocation
* [PATCH 2/2] selftests/mm: add test for vrealloc() shrink page freeing

and found the following issue:
kernel BUG in __vunmap_range_noflush

Full report is available here:
https://ci.syzbot.org/series/13b0874e-a9f8-4992-be93-e93cc88e5e44

***

kernel BUG in __vunmap_range_noflush

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      2c340aab5485ebe9e33c01437dd4815ef33c8df5
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/625f7138-9b20-4205-b0e7-02ed1219bd31/config
syz repro: https://ci.syzbot.org/findings/13e8dc07-d697-4345-a27f-319e9c1fe3d6/syz_repro

------------[ cut here ]------------
kernel BUG at mm/vmalloc.c:488!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 5824 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__vunmap_range_noflush+0xb4d/0xb70 mm/vmalloc.c:488
Code: 00 e9 64 f5 ff ff e8 12 8d a6 ff 48 c7 c7 a0 0e a8 8e 48 8b 74 24 48 48 89 da e8 0e c5 cf 02 e9 67 f5 ff ff e8 f4 8c a6 ff 90 <0f> 0b e8 ec 8c a6 ff e9 53 ff ff ff e8 e2 8c a6 ff bb 02 00 00 00
RSP: 0018:ffffc90003b575e0 EFLAGS: 00010293
RAX: ffffffff821f16bc RBX: ffffc900036fa000 RCX: ffff8881072a1d80
RDX: 0000000000000000 RSI: ffffc900036fa000 RDI: ffffc900036fa000
RBP: ffff88816ebb3980 R08: ffff88810007f1bb R09: 0000000000000000
R10: ffffc900036f9bb0 R11: ffffed102000fe38 R12: 0000000000000001
R13: ffffc900036fa000 R14: ffffc900036fa000 R15: dffffc0000000000
FS:  00007f4d6b8c46c0(0000) GS:ffff8882a9293000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055924f0dd8c0 CR3: 00000001057f2000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 vunmap_range_noflush mm/vmalloc.c:506 [inline]
 vunmap_range mm/vmalloc.c:521 [inline]
 vrealloc_node_align_noprof+0x4fc/0x880 mm/vmalloc.c:4346
 bpf_patch_insn_data+0xeb/0x10a0 kernel/bpf/fixups.c:254
 bpf_convert_ctx_accesses+0x213f/0x2d70 kernel/bpf/fixups.c:974
 bpf_check+0x2b8e/0x49f0 kernel/bpf/verifier.c:20094
 bpf_prog_load+0x1406/0x1a10 kernel/bpf/syscall.c:3082
 __sys_bpf+0x618/0x950 kernel/bpf/syscall.c:6248
 __do_sys_bpf kernel/bpf/syscall.c:6361 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6359 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6359
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4d6a99cdd9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4d6b8c4028 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f4d6ac15fa0 RCX: 00007f4d6a99cdd9
RDX: 0000000000000048 RSI: 00002000000054c0 RDI: 0000000000000005
RBP: 00007f4d6aa32d69 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4d6ac16038 R14: 00007f4d6ac15fa0 R15: 00007ffff714fc08
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__vunmap_range_noflush+0xb4d/0xb70 mm/vmalloc.c:488
Code: 00 e9 64 f5 ff ff e8 12 8d a6 ff 48 c7 c7 a0 0e a8 8e 48 8b 74 24 48 48 89 da e8 0e c5 cf 02 e9 67 f5 ff ff e8 f4 8c a6 ff 90 <0f> 0b e8 ec 8c a6 ff e9 53 ff ff ff e8 e2 8c a6 ff bb 02 00 00 00
RSP: 0018:ffffc90003b575e0 EFLAGS: 00010293
RAX: ffffffff821f16bc RBX: ffffc900036fa000 RCX: ffff8881072a1d80
RDX: 0000000000000000 RSI: ffffc900036fa000 RDI: ffffc900036fa000
RBP: ffff88816ebb3980 R08: ffff88810007f1bb R09: 0000000000000000
R10: ffffc900036f9bb0 R11: ffffed102000fe38 R12: 0000000000000001
R13: ffffc900036fa000 R14: ffffc900036fa000 R15: dffffc0000000000
FS:  00007f4d6b8c46c0(0000) GS:ffff8882a9293000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffdaf55afd8 CR3: 00000001057f2000 CR4: 00000000000006f0


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

