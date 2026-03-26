Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD089109E556
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 07:41:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F01D6B0089; Thu, 26 Mar 2026 03:41:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A08F6B008C; Thu, 26 Mar 2026 03:41:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38FA96B0092; Thu, 26 Mar 2026 03:41:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 243AA6B0089
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:41:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ABCE5160C55
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:41:38 +0000 (UTC)
X-FDA: 84587419476.30.B076249
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by imf10.hostedemail.com (Postfix) with ESMTP id E7598C000E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:41:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf10.hostedemail.com: domain of 3L-PEaQkbAF4OUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3L-PEaQkbAF4OUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774510897; a=rsa-sha256;
	cv=none;
	b=y25p3TIC10ckWxAgF5j/4t0Gl1ikjlxuOSAZrHcPpb2Tc6ta/fERTgrqC0BrVYg0hLRNh1
	Q42hSBcTWInR0Uc21i5ZX0O/qQzkeD2XOjKWOvHtnlCnK1Q0BBGeYnutQ+OdhHEKXPy3CV
	BIWFaiCx0vPo9JAx0AYAe+hbfdUFuZ0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf10.hostedemail.com: domain of 3L-PEaQkbAF4OUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3L-PEaQkbAF4OUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774510897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=zZZ5EaHOzm+qNrXdSfZ5XAFEz3HOXnh1h44VtF1Qhog=;
	b=pE6JyJgVictzwYv5ExSu0nDcUt1Nni9vJjZZ8IQBjkan9rEWlW6aeru/6BWc4sEKFP9mxY
	09DawUEG+cgp0RQxZmcc/DBbufKsouAAFE/ORlZzvrm8Z/pDUBLdjpPAVoAnfSKFA6HNXk
	+W6LpqY7mXk70dYBKiOBU6QePOl05nE=
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7d7cfbcb7c0so1454177a34.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 00:41:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774510896; x=1775115696;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zZZ5EaHOzm+qNrXdSfZ5XAFEz3HOXnh1h44VtF1Qhog=;
        b=Zvvgyyuy8lHqq2fhh4rCapI+1jkVQF2svS6zuAFOzivbjMjjI3x3qqqfaWh1urXw74
         jp8K/nB6WGKq5LuR2E/69PojUJcXCRpUbqvxenJaB3tryVflRTGzH8CX+/OHSyzom7lc
         vXlF08X2nHU2oEe1oFhhb/aZPM0OHKmF539gH14xF3QTE/e4MeBYHn8V2Liwvx2EJ80e
         ISxGFZjafsXFyQTptMccFB9tRgFvliZpNH+mYAgLeJGu782VYpP8pLoxcAJfPpRQ9T0c
         2MhWC0+HpfDOJq8ZWy8HrJcdnDRFBF7rIhaTz3qEM9prJDvpPNjJGBUzr0awOku7ojJL
         JQ2A==
X-Forwarded-Encrypted: i=1; AJvYcCWl06iReGN6t44+oaXiR8ZEUwURYVkGt8HDF+rsxwONnHom8B7C+SQKTGAgBNhkORzGp8Zq22vAqg==@kvack.org
X-Gm-Message-State: AOJu0YxfHZ/UY/6OOT5YtpZw8uLW6iHtKPq3bhs6V/VIsaXzlJX1s8ku
	uwa1hqnsAcsUO6/4QXjrFIeUYwdzoO0TBaL+Q9B29OAOaLhG0z9DBnRQ53U+bwePH2WN31ZoUVY
	zgZNYwvZJq/9DrMpsLkvpxHq+u01B9ckQKMugDICv3AOisJC04CtLAu//aM0=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2912:b0:67e:aa1:882e with SMTP id
 006d021491bc7-67e0aa18df9mr1504176eaf.62.1774510895883; Thu, 26 Mar 2026
 00:41:35 -0700 (PDT)
Date: Thu, 26 Mar 2026 00:41:35 -0700
In-Reply-To: <20260325175453.2523280-1-youngjun.park@lge.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69c4e32f.a70a0220.23629d.000c.GAE@google.com>
Subject: [syzbot ci] Re: mm/swap, memcg: Introduce swap tiers for cgroup based
 swap control
From: syzbot ci <syzbot+ci687e6f97bd3a602d@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baohua@kernel.org, bhe@redhat.com, 
	cgroups@vger.kernel.org, chrisl@kernel.org, gunho.lee@lge.com, 
	hannes@cmpxchg.org, hyungjun.cho@lge.com, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org, 
	mkoutny@suse.com, muchun.song@linux.dev, nphamcs@gmail.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	taejoon.song@lge.com, youngjun.park@lge.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: E7598C000E
X-Stat-Signature: 8egbjbxuws34sjxrk3wgthf3ztp968do
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774510896-386838
X-HE-Meta: U2FsdGVkX1/0a/4StO56ed8IE6LTHDAxb+RkxQbSR6iBMRCCQOzeakb8oLRM/wq88mNq668DmeFhrvBi0dWo8qfqpn7hLODYCbYXRZXPEBxksMg1AKNQsZmBmHRessELOuvfe0eSY4+NvFxTiBUlIiewckxsFzpU0709KbsCltv177c7ca6Kc4CZ8p7g3qnc9GuyqAjyWngXH18HwYULEhplduInHhqIkDxKtprjFSlSTiSVWdkkWGAt8muuXBEioGo/2/LTtQDtttbkHTaK8DvOwjFEch0V8WTtydZrFfOF5u7Y4fAjQ5JrE1dEHryZ4xYTtqqZv9EEPfkj5U1fjRx2tEz7HrvErHLexROH9oH6eqIphJ1eg1rI5z4VDuhlw6qccgzqJCuHlQ+ntPDhJkmBi1ehbkygYlVBGr6CvR8AO1frUuaCCFtEQUJpFsk+RMfjU/NGVCKGYXEj9V6syYu6X+T0HjDJHQcadwND3XMYATFM9Mv/axbCE5Qp4KcORC4vdJ5vK0C985frEfymloWRihigrE4mbrFCk40ky4kl7wcNJDPtilIcq9xd6Nycwf0nv3MoAOHQBMuLODXG4Fd6nYZMP5LqeTc2EZPaCtMpXaHjmJj9Y5QooDXKNcnSVg0YazwZLdv0SskmOvg99LlLgKgD5LmsbAc7gjq07sbQqJhv7ZFi3B99wgx8e/KMYSy4QibC8WY+Q0R/3IzKF+DkzwwKp3+wU1QNEOVVsQ4ACUQ/l1u5kRQ20zJUkKduxuUysrEblFoWuwsocC2nwfyxiq9VbCllElxsinAmZ+6goW38a000Lc6qElWFmO3qBgO0Y0R1zOLI+EE8C5lrqAQIpUugRRm+37OSDRP3iGmK/hbCGnwYaZapYdwZkMAXlALfQRPpEBa1awjd2Z093eHWP2Cjwe1DEzDlOl5Yy3w0VMjPu+lAMGVaogIP0n2plUuESzEjhU8lIRjrgVw
 TurwGJxq
 tScVx0bLMLxBxhk6YWFwaSdzBa9hwNxphVR3Cd+dNtQPdYDtCZm8Ih320MyzL68JUC0/jXAcIfM3uhX9CNes6J1b+f70tMde07Mx3sz/958RyCzByQMYQ3guDXuBr8sB7Up+nqNhmkvQvPokz04JxRxwaXzT8cd8BNTtxaVRYyZxSxDE6McJ6igylNnkArCJVsgBfhHtDu8yqS7mxBHZE6yHMdTu7KXbhXNI56BcMOLTxkoN72h8EvI6XqdPV9gqeCANS4K91/PJJtrtb9KvEztmKiOJh21O26GIuNdQTWshiaE/4NHgYsdL+qSMyHv3YNDxRC973KaEq4QxN/il7B9xeZgHk1TwIfCGbFWdLcb9tAxzpz0EViNcqE3fPjUWL46zCYaTTk+z2kFBb4j9+WiqP41YEXOfnSUjqTFkXtxXwGvwzhEcSJyoYkfLFGScfTPWpJXMBLUAnWD0NDt0O6sB/xh5a2hS+zfnicpR+qYM3Vh7u/jALOKOIPFOw4GvLdxtaE9wcY76XMk2tvj1I4tBd3b3jg/FYU6xbxN3AAhVksE/Y2UqK8mGvN13iXSC0eJK56gPb4AcyZN2Lem9Ed/XPqKJNM7g0SdJ4sgKVRw7N/X6bZqtHt2Cnkvp4WQWHHEg1bHdTTzR64ez0GW4UlUXgXHjs0Gk1/KrESsvAcQW3Jtc1El0bPP6GNyuoF+B4zvyxjXIgWzXxCmZpt2pHUk0cVFIr3m7sE0YyOVPsXhMWZYOltpCaeCmV6o/vAjoLVQjima8bCDJfBI/YS4kppRyuqaYlLNJe8P2p/RjPsColkWEcTi9/vnqaANh0vXEeIPr4/yMvQL8LhDubKNgK4yTWZCOcYBappYPXHfgJk/aI16yjLgCfHD3h/FpK2cEGdpKRHYptAmENKQlfqoZi5EQpnPVXqsECHfsJ8fBE7z2HGuxDuaoBPgJULFg3t7rYfU8sfPEABHt5Jz0GR08Rv0noqimj
 PbwdFPsm
 96YMPYU1V4HH1j/4LsCwo+Ld7sIZvM3s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v5] mm/swap, memcg: Introduce swap tiers for cgroup based swap control
https://lore.kernel.org/all/20260325175453.2523280-1-youngjun.park@lge.com
* [PATCH v5 1/4] mm: swap: introduce swap tier infrastructure
* [PATCH v5 2/4] mm: swap: associate swap devices with tiers
* [PATCH v5 3/4] mm: memcontrol: add interfaces for swap tier selection
* [PATCH v5 4/4] mm: swap: filter swap allocation by memcg tier mask

and found the following issue:
WARNING in folio_tier_effective_mask

Full report is available here:
https://ci.syzbot.org/series/6ed50ca2-a106-41e9-aa4d-7c46869e0011

***

WARNING in folio_tier_effective_mask

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      6381a729fa7dda43574d93ab9c61cec516dd885b
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/e5c66fa8-a7fd-4809-9564-448847b5f230/config
C repro:   https://ci.syzbot.org/findings/d64cc6fa-636a-40a0-b131-d02ce1129494/c_repro
syz repro: https://ci.syzbot.org/findings/d64cc6fa-636a-40a0-b131-d02ce1129494/syz_repro

------------[ cut here ]------------
debug_locks && !(rcu_read_lock_held() || lock_is_held(&(&cgroup_mutex)->dep_map))
WARNING: ./include/linux/memcontrol.h:377 at obj_cgroup_memcg include/linux/memcontrol.h:377 [inline], CPU#1: syz.0.17/5955
WARNING: ./include/linux/memcontrol.h:377 at folio_memcg include/linux/memcontrol.h:431 [inline], CPU#1: syz.0.17/5955
WARNING: ./include/linux/memcontrol.h:377 at folio_tier_effective_mask+0x175/0x210 mm/swap_tier.h:63, CPU#1: syz.0.17/5955
Modules linked in:
CPU: 1 UID: 0 PID: 5955 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:obj_cgroup_memcg include/linux/memcontrol.h:377 [inline]
RIP: 0010:folio_memcg include/linux/memcontrol.h:431 [inline]
RIP: 0010:folio_tier_effective_mask+0x175/0x210 mm/swap_tier.h:63
Code: 0f b6 04 20 84 c0 75 6b 8b 03 eb 0a e8 04 b8 9e ff b8 ff ff ff ff 5b 41 5c 41 5e 41 5f 5d c3 cc cc cc cc cc e8 ec b7 9e ff 90 <0f> 0b 90 eb 9b 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c c2 fe ff ff
RSP: 0018:ffffc90004bee6d0 EFLAGS: 00010293
RAX: ffffffff8226dd04 RBX: ffff888113589280 RCX: ffff8881727b8000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffea0006c62207 R09: 1ffffd4000d8c440
R10: dffffc0000000000 R11: fffff94000d8c441 R12: dffffc0000000000
R13: ffffea0006c62208 R14: ffffea0006c62200 R15: ffffea0006c62230
FS:  00005555771cb500(0000) GS:ffff8882a9462000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2ed63fff CR3: 0000000112d86000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 swap_alloc_fast mm/swapfile.c:1355 [inline]
 folio_alloc_swap+0x392/0x13a0 mm/swapfile.c:1735
 shrink_folio_list+0x26a7/0x5250 mm/vmscan.c:1281
 reclaim_folio_list+0x100/0x460 mm/vmscan.c:2171
 reclaim_pages+0x45b/0x530 mm/vmscan.c:2208
 madvise_cold_or_pageout_pte_range+0x1ef5/0x2220 mm/madvise.c:563
 walk_pmd_range mm/pagewalk.c:142 [inline]
 walk_pud_range mm/pagewalk.c:233 [inline]
 walk_p4d_range mm/pagewalk.c:275 [inline]
 walk_pgd_range+0xfdc/0x1d90 mm/pagewalk.c:316
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:424
 walk_page_range_vma_unsafe+0x309/0x410 mm/pagewalk.c:728
 madvise_pageout_page_range mm/madvise.c:622 [inline]
 madvise_pageout mm/madvise.c:647 [inline]
 madvise_vma_behavior+0x28b9/0x42c0 mm/madvise.c:1358
 madvise_walk_vmas+0x573/0xae0 mm/madvise.c:1713
 madvise_do_behavior+0x386/0x540 mm/madvise.c:1929
 do_madvise+0x1fa/0x2e0 mm/madvise.c:2022
 __do_sys_madvise mm/madvise.c:2031 [inline]
 __se_sys_madvise mm/madvise.c:2029 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2029
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5e5af9c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff0c8e2708 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f5e5b215fa0 RCX: 00007f5e5af9c799
RDX: 0000000000000015 RSI: 0000000000600000 RDI: 0000200000000000
RBP: 00007f5e5b032c99 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5e5b215fac R14: 00007f5e5b215fa0 R15: 00007f5e5b215fa0
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

