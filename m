Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F427FED2F7
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 09:14:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E4996B008A; Thu, 12 Mar 2026 05:14:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8929C6B008C; Thu, 12 Mar 2026 05:14:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79E356B0092; Thu, 12 Mar 2026 05:14:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 661A16B008A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 05:14:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 826ED140865
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:14:21 +0000 (UTC)
X-FDA: 84536849922.05.939493A
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	by imf14.hostedemail.com (Postfix) with ESMTP id BC34D10000A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:14:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of 36oOyaQkbABE9FG1r22v8r66zu.x55x2vB9v8t54Av4A.t53@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=36oOyaQkbABE9FG1r22v8r66zu.x55x2vB9v8t54Av4A.t53@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773306859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=PXzO07whrtPhoQq8HgioNxbytU69pEY6YZdifs1dY58=;
	b=vFZupYck8dd6AsSt3FlOeCxcDdpi3cYuhnMzKNExvWceBf+ILkR+zUTZRJz51z62y7ZDlH
	cYIzI7VAbkHEjq58nJ6MtveQP2jx23A8g8wFaY2jMl0WDxLd/LFSgkFluKfDG5CTSCgrMa
	MC3HjPWjRdxtOe7ovkPsueNiGsfndVw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of 36oOyaQkbABE9FG1r22v8r66zu.x55x2vB9v8t54Av4A.t53@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=36oOyaQkbABE9FG1r22v8r66zu.x55x2vB9v8t54Av4A.t53@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773306859; a=rsa-sha256;
	cv=none;
	b=VH3O/Hj3V7hdOVfej4tTG7UuXdIUX6xl0GDEKOwk3GCxRMkIQWDkklK38R75wQULb5mgKE
	g9S4jISi4wT+/9s6wCtdQ9LCTcHFXUUEMdowktl0H0FLKP+MahOWQ2uFQxAK/afHhgmEPf
	bCwxSduUQQoUIJ1Wdf/Qiog6VHajF1Y=
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-67bb5810407so13358182eaf.3
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 02:14:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773306859; x=1773911659;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PXzO07whrtPhoQq8HgioNxbytU69pEY6YZdifs1dY58=;
        b=s9unjGIK58OM6L2RfFY1wJ22xZHrXC5cfppQbBzWbkAw4aMGEs8JpR1IF3SBcYMqjb
         cZn34VdQGR04R7CO7JZCVwPNPqFz6WdzLy1UJqPnV4Uhxmsq3SUL/hUHFksBMs7PDEOI
         xjM7WxPP9tbXcNOOF1N3k0+8akMFMPOt/ie7UaSVx54B+P3pUuAvQ1kUpu0CCvNPJtFG
         FnALFM5eLGwsHS9QH4htkthv8LLZiYhK4Li+N396/VtPjPGFtqnMIMBJpW4b/HHt84Z5
         BhtHmixJrlOEG+XQFs4wAvWri9pT/XEs8K3AknzEpUx1f7sCzjpgWBAaiX31mOLGlJ7H
         7bGg==
X-Forwarded-Encrypted: i=1; AJvYcCVVUsctxAfDQPX+BrEccLvNpsvYDYz/sP1TXa4ZG1aCDI7mb+IgyxTcZdSlor6kNZNjz0HJR+48kA==@kvack.org
X-Gm-Message-State: AOJu0YyLVRhA38duGjrvIzDY2sWPDJ1SebR8rbPH5DomvdEM2LbKLaNA
	XCcwPOzKA3UbSLKDLqjyaVUpLxnqCQbA9dFEcCXjrVaf9F4/8pCv1FlSkpFnF77kwGQKIWOB8cD
	GkrNeteEe3R6t+51oKg+R6SRHqyM7eiaGlhChSN5sL+3rtWo5xmnoPzRKqls=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:16a3:b0:67b:c7a0:e4ec with SMTP id
 006d021491bc7-67bc88aa4c1mr3506972eaf.22.1773306858736; Thu, 12 Mar 2026
 02:14:18 -0700 (PDT)
Date: Thu, 12 Mar 2026 02:14:18 -0700
In-Reply-To: <20260311154358.150977-1-hannes@cmpxchg.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b283ea.a00a0220.707e5.0011.GAE@google.com>
Subject: [syzbot ci] Re: mm: switch deferred split shrinker to list_lru
From: syzbot ci <syzbot+cif35a646f5f2a4a9b@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@fromorbit.com, david@redhat.com, 
	hannes@cmpxchg.org, kas@kernel.org, liam.howlett@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, roman.gushchin@linux.dev, 
	usama.arif@linux.dev, ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 4bip7r3nfsgi4tmrj8ztoe7xn7cdbp54
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: BC34D10000A
X-HE-Tag: 1773306859-773212
X-HE-Meta: U2FsdGVkX18CoCqwBQSJLty7GL+rYtBfogcOJVzQ30iOrSzjnkT/Q65DDAekGJxRXsRJgkolsc9+ug2FRT5qp3L+HazG9NzbbSbiJCIjE0oC+UJfzbdQT8groHPi76FBW8vJgL0kIVKCzuUqc20ANGfRKrgH7EotNC3XIGVUF/RTI4KgQj9nJ7FUEYFnhJvVxISCJa8JyfVAWcwDJF0imz/ohRYr7o3YQmiALf6rcu+3RDbCZCq5278DIwbfHvo0qk/IzdMOYUpEYQB/FJze5fHTu9V6dDrTI58uT35Wn5fVZn+PcIQsClDTG3vQqjYcwLAPcRf4fIpCAl13ptl6sx5Nu4QmpzCDHL93ZHBtKHNwmvxUtcsIjRT47eCXEABpWJSqpH8mEz5qZWFrLFhP39OhiwO1I1RlsVgleiH+3RhSgWOWx/tyLCr2VQ3kO0Cm7bkj9zXo4Ys4IWJZzsqyJfyVP10NzQrXkAJ+VPLf4JpHL+T1EV5qaxexq602wE3L8LPXrVRq9CVdsVmRd0yPUrICg/yPdPnL9eQj3BicvFGpwCz8dI5WIKL6FSRchrlvzP+7Jrb4Cm28VMFuZl8Cc3TK/lRfvzr5Tq49ys3IcN9ZPrXW27LpBg0xgLfifNVl73guvjTdJKsrVGSkUgbG3Jl2r+Xj/lADS8Z7JNmZppORPpI+9zNI+pTwpCLXMTyNgrPSLyHW3fUMlfO+wk7v5anCI1WsLbM83D4t1HOmI2FAc09ZT0mt06KpDisqiYnjgZeVspxu4+/wj2Pxc7CRMDUbZLoEsqRmqyPlrQoLqoXhax5phfDryUgyjUgfmPFhX4UeWtrAVyLDwMchRKm8wxGPKkcf5mXDk+kqCBdqPKW64tgMff9jqqpTVa6vEoQwaYREWSyegZdqjzpNmcIixEqdmiIYxiV91v4bs31K+TEzS3NIDewoMReJPHTClUHWS/e6ED8wCuxfBwEBPJB
 zxtEbUtP
 3CavQM7XYHSUEpf837qgH24MfAzxK38Bz8GQiLB7Sa1Ba9rMMGDwaW9GpbQfLAWGSZiSEM9ATv+Qon8MUEhGCxF3RLGP7N3BV7+nbvqtlESCyGbfqsClfHoezbl7wXBdDvGZZ6j4iILHjcyS4MNJ7RYzSzrRj1E+4/9E7ETXBMrQfGJFe8sxVScvX4896JUTim1Te3X7kfzTCgV0gtd+ruB0IGmDs22JIEVWUB/PzxoDUQ3PqbMTwuK+BTf7cHwxm7IJKrU46Zn+2uALdbYQOAJqyu7MbsW0TRpv3yOvfXzF6yXj1OkuPR++ACf2h+ZQ9U+RuvEkNU1Um4RC5nH2JOqaveXUAZ/piXpB8ot929FEOxbGKR4ehKCbK6gWKtDmtHafGG80fVBBxjo1GGmeJ5nIxHEEInESc323G7tu5O7srG2pZOwxNRNk0rfYAQxor66P+mMsWEux30virkI829JfRJ9q39jMF20bHQsLnnq+lDdfxppVJEw/TOJZu0r4V18HYP5N6Ee2aG7VrwSI1hNp15IFxjbS6jwpZmiDSLDRAUG+JLZija9IPEM+5+F2rRIh6KVGFYZ6XpnoadVN+Wb3LAQDZpCM/m4jBfKI3K8IFbo7MvigNT7YczyGF1RTkVkEf7fodNTcQG6fbAk6Y0S3nEwa7GwHEr2kjCvmpM/RpPkDA4eMEkLefZmJ+/7OOZ0s87TgN2XZYdXRdHGrcY+CRGn9WzTdTCY+kahtsAOjDuA4TRWYMEbGhSoP1MatxoagxrqWkd6lVAxI7AKXbRO+/JSd+KDFRTobhP1KhezTiq4MYaUYafMKHTknFEqZRiHWPQDXrkqul7cVK6D3tYTesLwnDxp5lgGmTcz8PojKfoymAS07quMsDdRPWcikyd8lEkSdFJ67vYui0pUWXCF7ol4FQtM5+r88vBe0++u+FvQlRF/iHcUTh3JNt6sk7ik0CTnDLzz60cE7+7n67AtBHiZLN
 SFTxu6Cw
 oaS/7lm6K0jm3byWXUm/IsJreb3XnQKPh7PXcER7Er72G3tobUIhFiGLyxpWIsHKz9fdTiGWEEczTzqfrA6M2CnMdazgJF2NF8c67X217a1CYEbkpGX6hA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] mm: switch deferred split shrinker to list_lru
https://lore.kernel.org/all/20260311154358.150977-1-hannes@cmpxchg.org
* [PATCH] mm: switch deferred split shrinker to list_lru

and found the following issue:
WARNING in folio_memcg

Full report is available here:
https://ci.syzbot.org/series/3cf5ecdb-21ef-4894-a22d-6eb1eb437395

***

WARNING in folio_memcg

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      f543926f9d0c3f6dfb354adfe7fbaeedd1277c6b
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/6c96ae71-4f8b-4153-8306-440a79f2b2e8/config
C repro:   https://ci.syzbot.org/findings/25285d24-81d9-42b6-b715-1749d43db688/c_repro
syz repro: https://ci.syzbot.org/findings/25285d24-81d9-42b6-b715-1749d43db688/syz_repro

------------[ cut here ]------------
debug_locks && !(rcu_read_lock_held() || lock_is_held(&(&cgroup_mutex)->dep_map))
WARNING: ./include/linux/memcontrol.h:376 at obj_cgroup_memcg include/linux/memcontrol.h:376 [inline], CPU#1: syz.0.17/5956
WARNING: ./include/linux/memcontrol.h:376 at folio_memcg+0x148/0x1c0 include/linux/memcontrol.h:430, CPU#1: syz.0.17/5956
Modules linked in:
CPU: 1 UID: 0 PID: 5956 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:obj_cgroup_memcg include/linux/memcontrol.h:376 [inline]
RIP: 0010:folio_memcg+0x148/0x1c0 include/linux/memcontrol.h:430
Code: 48 c1 e8 03 42 80 3c 20 00 74 08 48 89 df e8 8f 59 fb ff 48 8b 03 5b 41 5c 41 5e 41 5f 5d c3 cc cc cc cc cc e8 b9 39 92 ff 90 <0f> 0b 90 eb ca 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c ef fe ff ff
RSP: 0018:ffffc90005d86b98 EFLAGS: 00010093
RAX: ffffffff823359c7 RBX: ffff8881749d1080 RCX: ffff88817250d7c0
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffea00068f8007 R09: 1ffffd4000d1f000
R10: dffffc0000000000 R11: fffff94000d1f001 R12: dffffc0000000000
R13: dffffc0000000000 R14: ffffea00068f8000 R15: ffffea00068f8030
FS:  0000555584c04500(0000) GS:ffff8882a9466000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2e563fff CR3: 0000000175ed0000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __folio_freeze_and_split_unmapped+0x1db/0x31f0 mm/huge_memory.c:3766
 __folio_split+0xa99/0x1570 mm/huge_memory.c:4029
 madvise_cold_or_pageout_pte_range+0xe3b/0x2220 mm/madvise.c:501
 walk_pmd_range mm/pagewalk.c:129 [inline]
 walk_pud_range mm/pagewalk.c:223 [inline]
 walk_p4d_range mm/pagewalk.c:261 [inline]
 walk_pgd_range+0x1032/0x1d30 mm/pagewalk.c:302
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_vma_unsafe+0x309/0x410 mm/pagewalk.c:714
 madvise_pageout_page_range mm/madvise.c:620 [inline]
 madvise_pageout mm/madvise.c:645 [inline]
 madvise_vma_behavior+0x2883/0x44d0 mm/madvise.c:1356
 madvise_walk_vmas+0x573/0xae0 mm/madvise.c:1711
 madvise_do_behavior+0x386/0x540 mm/madvise.c:1927
 do_madvise+0x1fa/0x2e0 mm/madvise.c:2020
 __do_sys_madvise mm/madvise.c:2029 [inline]
 __se_sys_madvise mm/madvise.c:2027 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2027
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb99159c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc93688748 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fb991815fa0 RCX: 00007fb99159c799
RDX: 0000000000000015 RSI: 0000000000002000 RDI: 0000200000f0f000
RBP: 00007fb991632bd9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb991815fac R14: 00007fb991815fa0 R15: 00007fb991815fa0
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

