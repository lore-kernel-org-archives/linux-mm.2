Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C328C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 21:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2084E6B00A1; Tue,  7 Jul 2026 17:33:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E0A46B00A2; Tue,  7 Jul 2026 17:33:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11D376B00A3; Tue,  7 Jul 2026 17:33:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D25896B00A1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 17:33:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 562D7C3A94
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:33:01 +0000 (UTC)
X-FDA: 84963280962.20.E16A939
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by imf21.hostedemail.com (Postfix) with ESMTP id 98CA11C0002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:32:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of 3inBNagkbAPktz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3inBNagkbAPktz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783459979;
	b=15fiaCnHiLq8mOxp91gbQC86CqNYIArETbh/aUyplnNPxyYb6cgXRylteQnQ7yAnPuhtQn
	qbreCKo5TDQAshlWIBuC33GxZ7XK2TEA23CY+YVP21OnyKQ5TvHyK5bQSZjoBLH2FMPqu1
	4DW6Vadv9dwj34F+iP0yRUjoxFLkL5c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of 3inBNagkbAPktz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3inBNagkbAPktz0lbmmfsbqqje.hpphmfvtfsdpoufou.dpn@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783459979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=ZbjaYNNT/DAa2ZgxKUTDH5wk4uWoo8h75GUG/OWPB4w=;
	b=sjwwLNsY6U1IZtyCvdSdVVpsEWhEFT85r8n3WQNABFdkDcTsaaBco/O3avuKMIvpV/HjOQ
	l5LOhAprUgyFdLwwtipWJkU+SOs9LCs0s0SavpyfDx9eM/xwhaSwhUaC4qqsSB0omB0445
	5nk49t8dt+ZNxRVV2FnM51PYwiR9+kQ=
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7e6b59d85dcso92604a34.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 14:32:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783459979; x=1784064779;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ZbjaYNNT/DAa2ZgxKUTDH5wk4uWoo8h75GUG/OWPB4w=;
        b=KtjMaTqIP8pBGbcitu4W1DQ8oWfBEjOcCyQkEH9tpDiZ/w5ZG4oR4aK+i4Dh9vwl7U
         IzbSy9NehuNWKrX3RSsT9uZUr5L7gby3n1a50Mo3ZBG+aVkR57jWyRxK5ubRkQ3AZ80c
         U6M4DexotbRH6HbwUV3Ogzya+6QaTx7ddiT0F/NH7TDgXZEcXHgaIWgqaYCqaSz+LyiH
         YKn0MtZ3s6vtWRhnXlms8Faoptq3C02k8Z9VDx6arxfjw8oApnrf08y+bYOYm7+d1sbV
         Jp8393iCVXmKRvAnz2RvEp8nSNjgzBmQ0mroPjWIoZXMiMv5Kd9Ya4dsQKQiPhIMtx9M
         eq+Q==
X-Forwarded-Encrypted: i=1; AFNElJ+IDLKM0IAwbxXdCJ5n2tZTUa8B3arF88K7dOsJ7Y29jnulTG464g4scE7B4n9sHufnp9bnH5WIKg==@kvack.org
X-Gm-Message-State: AOJu0YxT/OhpTRvdHHrBr/+IdeLZmQkfw6t+WrEBN/kkwFZkLXgMzS9u
	BnWAz6jNHHb75nLZJQ7Q2l2E70lABftl40NpGoCtIxhaJQSgE/AhuSgOKfsd0IyOx/R+QBITOuo
	ePiTM0Hha2J30OBVCT5uWZOaJxtUXbaY5LX2P0lFeJvvPy7kKp7Wj2Yp5nAQ=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1995:b0:6a1:5ca0:d52e with SMTP id
 006d021491bc7-6a355246c2emr4441088eaf.7.1783459978731; Tue, 07 Jul 2026
 14:32:58 -0700 (PDT)
Date: Tue, 07 Jul 2026 14:32:58 -0700
In-Reply-To: <20260707063308.29176-1-tao.wangtao@honor.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a4d708a.a1ad617e.25832.000c.GAE@google.com>
Subject: [syzbot ci] Re: mm: rework anon_vma and remove anon_vma_chain
From: syzbot ci <syzbot+cie73eac57e65eaf28@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, bp@alien8.de, 
	byungchul@sk.com, catalin.marinas@arm.com, chengming.zhou@linux.dev, 
	damon@lists.linux.dev, dave.hansen@linux.intel.com, david@kernel.org, 
	dev.jain@arm.com, dvander@google.com, gourry@gourry.net, harry@kernel.org, 
	hpa@zytor.com, jack@suse.cz, jannh@google.com, jgg@ziepe.ca, 
	jhubbard@nvidia.com, joshua.hahnjy@gmail.com, jparsana@google.com, 
	kas@kernel.org, kees@kernel.org, lance.yang@linux.dev, liam@infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	luizcap@redhat.com, matthew.brost@intel.com, mhocko@suse.com, 
	mingo@redhat.com, muchun.song@linux.dev, nao.horiguchi@gmail.com, 
	npache@redhat.com, peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, 
	riel@surriel.com, rppt@kernel.org, ryan.roberts@arm.com, ryncsn@gmail.com, 
	shakeel.butt@linux.dev, sj@kernel.org, surenb@google.com, 
	tao.wangtao@honor.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 98CA11C0002
X-Stat-Signature: in3ph177wp6q1865gz8gediu8easw8ft
X-HE-Tag: 1783459979-15279
X-HE-Meta: U2FsdGVkX1/fAsjyHaRRiTrlIO9GL0DBFJLEiCEtQ+eyz+UuSEPMzLKnItMQcXOitM+edzoT+UaTQ5BKJXJF3uYgi07/w+tjwQvhrFZvV34ak1d5pgStC3itxp4iovB4yCC1e/klQYS+ahK1H7ff9eCRTdwGSxqTwKZDg25pCxWII8Gq+VDwIa6Jd7vfUF3yrgB7sKH24aL39+4GBn/WgniWaPk5utJS7Evj22FcGbHcgcywMcttRHp+GfxoWxd3P0EsAQMngClto1jjxNhSUY0tpwLNekgtfFEyNr6d5pfYrOYACFX8ombKDRrODjGP5OzmA9r1G3arK+JlyEwsv5TK5U6YPUTxALyJ3VwLj6em6Xnb2U+R7HdOPZVlzJVTm0AG8EQKoTd4Hk4dAV9kqBbQEEtUaUHYgdgdZAZ3VpeKt9OYwYx3XkfAoCu9x9k9SOUBQKR8v1tdwnBAuYG9PnBHyh00T3dts2BGgSV/L7IsHTjpnfepmkxnVtSy0q6uAQNJV1kOMEnb8clKRyf+XaQfEUA84kGFv0L6KCemocJWfZ5TI/51hOgM3z9sYdVI/kpcXf1X/rLfQSqZ+wlftd4prmjU4sDkVKDvkC7VQfcokyPTA5mWj/4upzULdY6Gm9FYwId251oX9l37h7EdGD44AtGZcg4EL9hY0xzmEB6Yid/tx1dce72xbJMStM8v9sIdtFuIAz2q5U7aYPf28SshANGwA3PyvAgSEuFDKsuGQdBEwRhoxufHhdTDBd/dKcuDIcyWLqS9uFaxfnezfJj0ioMGXV2X8jDFl8epb/xrCRV8dTpD+1aoGt3FdpjWcQx2gV9idpzOsVRzZXT+imv8clBWCfPVD7cULspWQ2LB8+5NjOqGs4F712lMwk3v/9KaOC3FzGkG9CHI7S7WXu/9y+wuT2QjJjYWMMScTDfnmNhHFVIdTrnL/VSLM31HZVVPifcoOzOMQpb90uJ
 XumpGcev
 pwpeYeRXrFVPXK6l9UXVJdT5z+hJFxBozBDT2TZhwp06a032NnzorO81tU9n0TQ6i3NbmE0Mapb6vaxnvrmRvNShD7LFJT/Ab5RT7zCMNbzUFZ+nbEB9xONqC2KNKxBSXwpTPnRoLE7W4cpheZCmI/Llq5O50VtrJji8yJFB1j9hsU6InX89rZv4PpoCOYONFqEZOKHIMCVl9TF7IraZu03ZVLBtx4KMyjtrkHbFHY102M8E1mYhC2Kj5yidIsNUjKprUaqy0JFGGHTJdAvxSUhZvL/oPUpheFKU5GMu4+YaHmX7h3NEfDhWI+pohNb2XXvFi/eL0oKmXAcThSQLrYoUIkWacA5A884A/dXdKCzyURYtMCZT3xwfhdCDJYhC1n+9l7+VpKXclAnmI0hJc/a4DQvH7vWdwytcx+SQqbBU/nfa/MqwC+TVZekenNjsKOjz9NK/V6t09mXae5Hqyk6BE+4Cj0vruyETng9rPoAOq+ccokcQL/Gd1LiE0QDQtWZ8PeefVdvFwGTwHCcX7kljHGBuZ2dd/hQAkYPGq3dYgdol1ozi24pUfte7A+GM+6oSYbHfIuTxDXmFFV6mdje6dI3vQODFWZdGSY7Q1nKsbxZSIyxX7Y+fEN1bG5aWgfSEKTAb7OOL8JmlerjmQ9Np3ZUJf+JD8RBhRQmRjGe6c0ICNpJcpQj7XZ2eeKPTwFuM1wkHQYvXMP3+2qAjNLIn4OCMzKtPV0C8C8gTOpIUU37wv1iyJ2Lm+kvZQU5Z3lJyifqxysjRw1we5mG5XcePpBCd1wrrUNiamsxkmWYXRZds/HnUSVjkBsu65K8g3bRZklsi21dPYddVrK2mN1qUBddbT4B67Q4j40/a5QX3DtnorC0s+Q5YJr9S/uvPdmqHwKoEA+BxPmnTYf6k2N+8uQYlR3qsveoI/+za6VK/SzZsJrRvOhZNNgpVGfAAH/QebPn2xVK48HrQ0S09wsuLVRyPW
 WKeGPF5s
 WnuEcfFuqjMDBo/+oVA9YApd2J7ew6IilYEcViiLHB5Hrim/83W+czH7W5liH8jmltdjtFIHuSe96J8Ztg5Gg5EMLtmylVQR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v2] mm: rework anon_vma and remove anon_vma_chain
https://lore.kernel.org/all/20260707063308.29176-1-tao.wangtao@honor.com
* [RFC PATCH v2 01/13] mm: add CONFIG_ANON_VMA_FRACTAL
* [RFC PATCH v2 02/13] mm: implement helpers for ANON_VMA_FRACTAL
* [RFC PATCH v2 03/13] mm: implement __anon_node_prepare for ANON_VMA_FRACTAL
* [RFC PATCH v2 04/13] mm: implement anon_node_clone for ANON_VMA_FRACTAL
* [RFC PATCH v2 05/13] mm: implement anon_node_fork_with_prev for ANON_VMA_FRACTAL
* [RFC PATCH v2 06/13] mm: implement unlink_anon_nodes for ANON_VMA_FRACTAL
* [RFC PATCH v2 07/13] mm: handle rmap_base changes for ANON_VMA_FRACTAL
* [RFC PATCH v2 08/13] mm: implement anonymous folio rmap for ANON_VMA_FRACTAL
* [RFC PATCH v2 09/13] mm: prepare anon_node replacement for ANON_VMA_FRACTAL
* [RFC PATCH v2 10/13] mm: replace anon_vma with anon_node for ANON_VMA_FRACTAL
* [RFC PATCH v2 11/13] mm: optimize rmap for ANON_VMA_FRACTAL with PVL
* [RFC PATCH v2 12/13] mm: shared semaphores for ANON_VMA_FRACTAL
* [RFC PATCH v2 13/13] mm: Enable CONFIG_ANON_VMA_FRACTAL by default

and found the following issue:
WARNING: bad unlock balance in exc_page_fault

Full report is available here:
https://ci.syzbot.org/series/39466cf1-707b-420e-8f1e-11735bea6c66

***

WARNING: bad unlock balance in exc_page_fault

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      8ff49efd1cf18086320f3b43d1bd483c0b9e7e58
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/c3a229e4-b949-4889-b309-dbdd1fadd95f/config
syz repro: https://ci.syzbot.org/findings/29b52ad4-b463-41da-877c-4138356e3960/syz_repro

=====================================
WARNING: bad unlock balance detected!
syzkaller #0 Not tainted
-------------------------------------
sshd/5593 is trying to release lock (vm_lock) at:
[<ffffffff8bb5032a>] handle_page_fault arch/x86/mm/fault.c:1483 [inline]
[<ffffffff8bb5032a>] exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
but there are no more locks to release!

other info that might help us debug this:
no locks held by sshd/5593.

stack backtrace:
CPU: 1 UID: 0 PID: 5593 Comm: sshd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_unlock_imbalance_bug+0xdc/0xf0 kernel/locking/lockdep.c:5298
 __lock_release kernel/locking/lockdep.c:5527 [inline]
 lock_release+0x1f1/0x3c0 kernel/locking/lockdep.c:5889
 vma_refcount_put include/linux/mmap_lock.h:216 [inline]
 vma_end_read include/linux/mmap_lock.h:264 [inline]
 do_user_addr_fault+0xab0/0x1340 arch/x86/mm/fault.c:1345
 handle_page_fault arch/x86/mm/fault.c:1483 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
RIP: 0033:0x5583206de68b
Code: 04 25 28 00 00 00 48 89 44 24 08 31 c0 48 89 e2 e8 8c 5b ff ff 85 c0 78 13 31 c0 4d 85 e4 74 0c 48 8b 3c 24 48 89 de 4c 89 e1 <f3> a4 48 8b 54 24 08 64 48 2b 14 25 28 00 00 00 74 05 e8 5e 17 fc
RSP: 002b:00007fff02a37e60 EFLAGS: 00010206
RAX: 0000000000000000 RBX: 000055835a20d6fe RCX: 0000000000008000
RDX: 0000000000000000 RSI: 000055835a20d6fe RDI: 00007fac5106c010
RBP: 000055832073df00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000008000
R13: 000000000000005e R14: 00000000000000b3 R15: 00007fff02a37f88
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

