Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B742CC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 09:38:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9777A6B00B1; Tue, 21 Jul 2026 05:38:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94E8F6B00B2; Tue, 21 Jul 2026 05:38:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88C9F6B00B3; Tue, 21 Jul 2026 05:38:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5AFC16B00B1
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:38:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 781451A023B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:38:38 +0000 (UTC)
X-FDA: 85012283916.14.B6125FC
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf09.hostedemail.com (Postfix) with ESMTP id CDE4A140009
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:38:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf09.hostedemail.com: domain of 3HD5fagkbAG8flmXNYYReNccVQ.TbbTYRhfRePbagRag.PbZ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3HD5fagkbAG8flmXNYYReNccVQ.TbbTYRhfRePbagRag.PbZ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784626716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=3fd5B2ZXVVbqWQT0PAZ/ak+NiXB9TRasHJOFENVDziA=;
	b=yxmeMzumo/v3vg57iqVRJRoYlvU7FD/JbWJBKRmpmaW2iESJRhz7mGwCqDtba0mLkcmqgp
	qe4O3NgXxi76OZhKpv/+vqOthTR/W1KgmD1VXGKf//89eyUQXBgbr0fh6yKB7/x+a0L4/k
	X9jHUcHqoSsR3g4gL2pqidkFf4408Ys=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf09.hostedemail.com: domain of 3HD5fagkbAG8flmXNYYReNccVQ.TbbTYRhfRePbagRag.PbZ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3HD5fagkbAG8flmXNYYReNccVQ.TbbTYRhfRePbagRag.PbZ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784626716;
	b=iJTewWkLcBr3uNP13DlE2w0hihU9NE+GQCCm8j0cHySTZY8DbQrgE5VbMfVUy5uKP2Ewa0
	AGAPDGK5EEuFuBNL5NmGtlfhtbRtcVOE05wWwh8xIVsDQgMxZRGUUvLS60dGu1wgEcecph
	L3ytFIjyPxyStwh1LTbUuSk6GlCUw3Y=
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4a5a66f375dso2153395b6e.1
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:38:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784626716; x=1785231516;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=3fd5B2ZXVVbqWQT0PAZ/ak+NiXB9TRasHJOFENVDziA=;
        b=MgdPSpl/k9b6RBHsX8kQAIZVrb2L6WPNCtoFw3kaXGWiophXHd4ioN4S6y3CDGFvDp
         QpC82ODrKyumdErReJykBiiF5Ssj7MOd5wi8/Zi4iU/4fD9KQj1NvKeHw0EqvOK+PAGO
         LZBIhBgb31iwD9tDpOraXuTh2pYysWbX229aIeTqqWfJZ2lqQD6kPSGf6bp4DmzkvORv
         emI0ZShHLCCXZndOAYwZaxL2c6WGwDf9KQMEMIssT5o2FAIwQEWahP7y8MM6MQWbPwF+
         UKRnH4szROWo49lBrKbMTj2ZP3vW8lRVbtFdZAp2/aQ8GG+NampoxfLo17J+HTa5iQpR
         QktA==
X-Forwarded-Encrypted: i=1; AHgh+RryNuBluoTnQZn17uEh0EN+/gqOQQ3aao1qndX+iK4Fmfn2v93QCNtp3i8QtVxqG7RuUJ6TKytEDg==@kvack.org
X-Gm-Message-State: AOJu0YxgOaU/E5HnXSByWusOAVcJ2zoae1b4vxRmUrLB93jHU0dQ77t8
	AqNqdye5UwN3NUoA5S7TKhJpX00vgh8295+LxyHn3xG0Gn+u/XcsDVYDiA+u6XQn8a8qQE7h5SE
	xcE9Sbxrf4VbevhJbqO1vzB/VVnxdPNlQdKw8mmiIKFy7hhk5MIvYE8G6BZY=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1b14:b0:49b:e1e2:81b6 with SMTP id
 5614622812f47-4a4d0508418mr8913489b6e.27.1784626716002; Tue, 21 Jul 2026
 02:38:36 -0700 (PDT)
Date: Tue, 21 Jul 2026 02:38:35 -0700
In-Reply-To: <20260720142913.846902-1-pfalcato@suse.de>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a5f3e1b.33ea6125.251e5.0001.GAE@google.com>
Subject: [syzbot ci] Re: mm/khugepaged: collapse_file() cleanups
From: syzbot ci <syzbot+ci026360235493b4fd@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, 
	lance.yang@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, npache@redhat.com, pfalcato@suse.de, 
	ryan.roberts@arm.com, usama.arif@linux.dev, ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CDE4A140009
X-Stat-Signature: 9c4my94xuuu8m4bhdohqhit41epzerou
X-HE-Tag: 1784626716-680327
X-HE-Meta: U2FsdGVkX1+DLBk79u2DcsxvI38OY3ozbDFmOZTO7gLcFRdagq81gyhqDWiDownUDD/raMCNwk4PpKRR/7pR+3ClNCV+pSOFR/c0V0gnug5eCdXlghsHQgldriUoNbVsM0XKz8s8cnbQSYVl2N4R7g7AoZmOTDVvPFE2EJVSBgAehH/7PaVr+tt9L3vVs++fmAnBthPv16zvsFP+OYwMK3tXLypblVfZCfNS/A/wcLJm1Bv+K33vuc5lNgAV7xZ/NY6jgbQvNPKa3BtkYIfTUZ2p3IL+f1UNF2Pn7hAWRLE4vJLTzotmoXiEoZ4Se3JLMUhw71ltl2VExFq/D/9Fi/wTZGgjNDokO3ZpiC/6KuvqMe8pU1wWRrnlJIqJdEvdBlxSIRHBzIU0rQ22AeEoqv1ID2ocnieW+haxbHqG/p/Hr1GSGZlQ7ZFD78XZhiyfn4vluYl3/TGdZExSgYQ2jx8ReZq4F1Q2Z/wXn28WfMNUrCBoM1piayxi+L7b+BkLbqMzgkmXY+ymbPbq5RZlU0jYoU9Ly5hEr14ZFMP48lbH2aYwpSgF8X0ptLSwCoE1bKeUDUvoEWkeWjwqNOW6cNa5aLUGDdgoB9cl7lbVYJ04T+ykAeV/7scFVDlypKJrWHM8P6rN+8YXy5okBK7Uo2dK+jwMJQ6uIBwqz6euyqcY+ngNmIeNjHkraVJdnnsluzzMe5vX1vboVmFWSuLMBxNFu+C2fbufXKNZM7RO/v3C4GVBiPci00bsOOAedDWG8qP77hYiwAIUt5hqsTof+hKyOvAMReMFaQDjac7ZrAvIAsXuaF1BkorsCgRerDLBAcYzxSzBWn62JWFQhNiG+3odHTGVDb5E1htVanQtAwH3igbbtso60yN+tQkFvjVu9xAAkKw4y5WziTeeiyik0M4qxFKxBhKoN9J1MgGLfgZ7UnqYC/aAAphdXOo8NiR/qWTJL1b17fVW09+f96i
 OGQZj9+6
 nOP4orAmqnukaXoZJljrnSAQ6YBDuDX6RFJbZElBRVV+zBb8jXldSvHAg8/Inz5zo1/RhM4jw/z4OUVyNCinMyr5yMUtItxxoFOdHrAWn4He+5jpPWI6UHuVdechoHiuYbZ9iJpZiSbZ9Ae1Yr8nwxn3BYqj15AnxDdcfF3kvtZmP+6s20JxrCP7D1bFuKOK9yqKzfuc9LFR44jIYN9qXx4uKAM6U5WSaYfckPy8FBLZue82WZ99qGnQE9fQCdVekAvfW/XoL7WhT8KKvT5wc7bnd7RKvtriDaWoW/WliUtTYmTeCxIGJOlpgGVzQayBCNRzBv3+v2fyu6dqdtYILva97EPBG8i2ku/g+ntG8BpMllQrXQD89YnXlJKSpI7/rab7Mpb8M6aM+2RMUip2tvoOZeURjWVdSrotpM0NlpqX75S+wyLNFy5Sbs6OQ2mRNBVQSqTkmdbRNR4/GYXVooviQaT4Cqo46Uu/MHIdHcKKkb6htz+RupwcL9YtISNZQWjd4f103e+Ji1EEM6Z9vKCnVYCdqoc3ukq3UO2i/M/FD9Tp8fkuFZnkIIhXaIiWqz9PkSMniXOsNQ74Jch5QgXlQ9ZviPVNBFOUakwACCEZAjvUUBViBF30D7j7vX8wWbEEK65MYYTY+bXTiVsy6yNwK9sUF7xFcS7z+yXMhfUZ/6X8t0P8IIrdX3LS52omoyPdr+DQnGwJOSxD0b3sK1VwC7fv9NCm7b+zFHuBpPNPhbteajmaQufBcmfHQDa4berb075GdtYijq8BPW4ipmQnCL5VlEsm8lyOjIioOMqBzpZz+g/21GQE3niHZYQ8kp+9VQ9aaZ1eNxwF/Wk4qYxuMlfsip9/Na2OTpZf1hv3vCj1abV3aOnZv5BPg/tApS6QBamcSb1pjI2ugUFflJ26pTiQv1ucBLax94gULfvgZmLqnOnx01Lp7uw4F5oMFikYc1SSo/zpMuTjQyb4+/DN7fQqa
 bYNAlzOa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] mm/khugepaged: collapse_file() cleanups
https://lore.kernel.org/all/20260720142913.846902-1-pfalcato@suse.de
* [PATCH 1/8] mm/khugepaged: separate out windy folio logic from collapse_file
* [PATCH 2/8] mm/khugepaged: factor out page cache folio reading
* [PATCH 3/8] mm/khugepaged: factor out and simplify dirty/writeback handling
* [PATCH 4/8] mm/khugepaged: simplify prepare folio locking and exit paths
* [PATCH 5/8] mm/khugepaged: add kerneldoc to prepare_collapse_file_folio()
* [PATCH 6/8] mm/khugepaged: hoist isolation into collapse_isolate_folio()
* [PATCH 7/8] mm/khugepaged: hoist more code into collapse_isolate_folio()
* [PATCH 8/8] mm/khugepaged: fix and flesh out try_to_unmap_flush() comment

and found the following issue:
WARNING: bad unlock balance in collapse_scan_file

Full report is available here:
https://ci.syzbot.org/series/cc30d9d4-857a-45de-a8e8-b99f9346d0da

***

WARNING: bad unlock balance in collapse_scan_file

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      c872b70f5d6c742ad34b8e838c92af81c8920b3e
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/e6e237b7-5a64-4732-bb37-4e62c3103d4a/config
syz repro: https://ci.syzbot.org/findings/51ee94c3-7fe6-47f6-81ed-a53cf51bb3f9/syz_repro

=====================================
WARNING: bad unlock balance detected!
syzkaller #0 Not tainted
-------------------------------------
syz.0.17/5868 is trying to release lock (&xa->xa_lock) at:
[<ffffffff823ac70f>] spin_unlock_irq include/linux/spinlock.h:402 [inline]
[<ffffffff823ac70f>] prepare_collapse_file_folio mm/khugepaged.c:2331 [inline]
[<ffffffff823ac70f>] collapse_file mm/khugepaged.c:2539 [inline]
[<ffffffff823ac70f>] collapse_scan_file+0x2cbf/0x4dc0 mm/khugepaged.c:2849
but there are no more locks to release!

other info that might help us debug this:
no locks held by syz.0.17/5868.

stack backtrace:
CPU: 0 UID: 0 PID: 5868 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_unlock_imbalance_bug+0xdc/0xf0 kernel/locking/lockdep.c:5299
 __lock_release kernel/locking/lockdep.c:5528 [inline]
 lock_release+0x1fb/0x3c0 kernel/locking/lockdep.c:5912
 __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:185 [inline]
 _raw_spin_unlock_irq+0x16/0x50 kernel/locking/spinlock.c:206
 spin_unlock_irq include/linux/spinlock.h:402 [inline]
 prepare_collapse_file_folio mm/khugepaged.c:2331 [inline]
 collapse_file mm/khugepaged.c:2539 [inline]
 collapse_scan_file+0x2cbf/0x4dc0 mm/khugepaged.c:2849
 collapse_single_pmd+0x2b1/0x3da0 mm/khugepaged.c:2884
 madvise_collapse+0x2cf/0x790 mm/khugepaged.c:3310
 madvise_vma_behavior+0x115f/0x4170 mm/madvise.c:1363
 madvise_walk_vmas+0x576/0xb00 mm/madvise.c:1712
 madvise_do_behavior+0x385/0x540 mm/madvise.c:1907
 do_madvise+0x327/0x3a0 mm/madvise.c:2005
 __do_sys_madvise mm/madvise.c:2014 [inline]
 __se_sys_madvise mm/madvise.c:2012 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2012
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb60079de99
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb6015c0028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fb600a25fa0 RCX: 00007fb60079de99
RDX: 0000000000000019 RSI: 0000000000600003 RDI: 0000200000000000
RBP: 00007fb600833eaf R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb600a26038 R14: 00007fb600a25fa0 R15: 00007ffc7db2f618
 </TASK>


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

