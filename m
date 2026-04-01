Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5837D35157
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 08:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33F1F6B0089; Wed,  1 Apr 2026 04:10:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316C66B008A; Wed,  1 Apr 2026 04:10:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22C646B0092; Wed,  1 Apr 2026 04:10:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0F7266B0089
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 04:10:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7569B8C296
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:10:50 +0000 (UTC)
X-FDA: 84609265860.07.C8F8D4C
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7343A140006
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:10:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sMLGq1lB;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775031048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+MX+RoBiY5GwiGP2B5rBEJoBhjbFGz1wfvNFGjyXQdU=;
	b=Hto+aplsme95EVXrDITty5lIixupUiW+pF1JOYuqN2mHL64sh5FQ/F5YhfXAaZX2cY9r6w
	nVY4ObFsoGnzrxFNZPcf6siyvH9GwfJnynSvhenA9EQ16U8fqUonY5yD+zzDlAmMq+YcV9
	4nB598zehbh4tB1ccyTmdohrl+KdBp4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775031048; a=rsa-sha256;
	cv=none;
	b=ungvcgH5wvRs/kSW2/YPWtfKpIuj0GNmd8wlkYCqS3zCXmVno7nM02vigiCm0F5W48JP2Z
	zzYmF2F5aouL707LDY+wtuLAr2O8DDVvZ6TEoj0YAeanNfX/fk8VHmHtYd1lQEve/Z+wTn
	Zkb2YZv5NDWJ6Ro/B9Clp7TAybF40Lg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sMLGq1lB;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775031045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+MX+RoBiY5GwiGP2B5rBEJoBhjbFGz1wfvNFGjyXQdU=;
	b=sMLGq1lBOjKwNfxhwTIsTvcB2Yx/li/jpYvuuC6BF76iXh1NTBHs3zvmAYdxQQmznyGBLt
	40k+kUzCzRxIg1JvfDNh73zhOK2DMY/jarvGN3WLZ5whjUHuYSasY89rIKrtZ9PKZzAbIg
	+kqut5ByqxmuDP4Ddnyw5f3CdH+3+ZQ=
From: Lance Yang <lance.yang@linux.dev>
To: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com,
	usama.arif@linux.dev
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	syzkaller-bugs@googlegroups.com,
	ziy@nvidia.com
Subject: Re: [syzbot] [mm?] WARNING in deferred_split_folio
Date: Wed,  1 Apr 2026 16:10:25 +0800
Message-Id: <20260401081025.68951-1-lance.yang@linux.dev>
In-Reply-To: <69ccb65b.050a0220.183828.003a.GAE@google.com>
References: <69ccb65b.050a0220.183828.003a.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: bhrdtfmog9w181zauhrp4k3wbpir5qwt
X-Rspamd-Queue-Id: 7343A140006
X-Rspam-User: 
X-HE-Tag: 1775031048-485112
X-HE-Meta: U2FsdGVkX19hLBYwQSQsoyMmmQORDG7CS0ng2QmgElWbj/9rNuA1RWuyvzIIwgUW5pVA1j6QvrLXD71vvMCNMKoYoLilF0DoKb4mPAX54w/eqhwW+oka2L8jMLv3vT2gg6Gyd5JNq7Xs9wAke5kPKDJOioHuALQU9N9r9EX1U8Ihkx3TeT8vtuJRwVBoD2/JooEsiZneJK2mZ9gRwklWLfxy4hENkvhHOsHwAAklBc/nrQL8KmkaEfEO+LIDubjlYkZX5RM6vI+WC2LKlEi1PixWmsT/3uGhZFHIoiO1pkXSvPCnmWBxu6MjoFLpQoRNIf4BSb5LvT8TDQM5j5BQNP9LUg2O0x3HIBzNh1fZHhemg+HmUbTOgAehZ84lVvO9p8MqaeMwQBzJNr0OwnlMCFOA41TjptVB/lphUdFP6tmiCdtEVpiR33RfaR84QwaxOqh4saBI9CtSJT1j6oUlHDhYhBFejpPwVWbPo3gpoPEWPfxFmld9pdosfzX2lY4zlqvyxk+Nt1ahbV6UCK/hAbe+VQELkbUwhC3UedW8pIHJQMri6w1CFZlHzWFR/9pgoYBfzmVp//bRSld9umLLZalDsKWSxWQml3fUQ2/uqFtgw6KdZdmArJnW8IlDC9T41JF8tI+esI88LS0hYXgE6+pC5hBw95lIxWTcBX31BJWJTEoox70BkckeJsgA2rM6dY5BS8S/JAhzNoT55uIx3Do1ecTe3BIYlIX7gD2WdifCSguyTsOqoSvgsivstkWuIhsbnV+wRCx3lPShzDqrcAIYG7nB6ONGzsxMg8panqPmzLBOMswq7x6TSAObdbN05uhRR/TxOqMSB0H1d/QvTcMwyQ0Tn+JLzM++2qE/JgIQNfTGzcmrrezne2rws4L5Vxc3e+rqLux3A85mnasYnL+7kZIv4JE5N2EQtk9LBEZYiKFxoruniX6r1bsYh+W2aTp9yHvlpTTBpd+2JRj
 U+/oRl8s
 kOU17mocD/yc57B9c0jNaFNJQDI4C+E0dq6DmREnWtRSQmeIHZsyFQobExib1xERQfA9rBYS2pGzq414gFyi6FxaESz45KrHQQ0UMQ7IWAwKub2tO8gNNC9xenKgeBFP0Kvq5jmRqdyIgXqj5Dscg27Ttqfb0exCU4BDEAXfob+3WdqyoKGxwzYcofZBzSc7qdTm7VRnO43/vXw+5WdXmKH2Jrz6W8lw+OfTba8RzlV1VPynrjsAeVQ7LWepsS7V1C2J+9NXSTA1PZOtVazhdvO/qTcoJe0UsW/UP94/KlYTL06dDloQWkLkpOe4shJoJWwGbCwu1ZuDt45DA1bmVPx4Rf23d9O8FBNNjcLoXWiulCvDBhYyCE3k7dkQZqoSXrLy/TOtU7Vf6uOAqtikGyYA7oDFDI+b4FopuH9xn7k3kVKmSWu9AXr0toYrdwP7Iok6gbQ+6ZyxuIW8S5jaXrQokDfcAoZ90iprb3uq8M91ZIRhnEZ17Hy3Ics06RainaFoITHLHtkeFSyBPmgKdItu1Hh1Eapd5hlY3DGRDU4jXMj4/sNW0XWpGelxN2aCrhSZSuBrMpmbMvDAan8eD7F7o7wu5hZzAo+I6HbQYVD3fBBFUD6GFQiQ10D2jrGuFup7gtimJIQ5ffUOmfNi7/IrM9ewkElmRB8xnQndlszD3BHnHbmIkmhsrwEb5arJZ3vWeqF7uvCxFHi919q5MW1yMhmoq+qJ+FtSMx/Q21o/epEAe5OEYLbnyroXtW0qloCuj/KggTIR5BEvhbLadeXF2ufhuqkmDsxV2oN4yZAjeuTdsVD7By6E49nef63ggpEXYiGCi9fdq3NWFZ/A4UwAWMVs/ElH3xj1P9Yn27eMY1TjGphH/C/RixfQRdt3N1gVUlQYy9rCNx3I4dtyszaxty5YBGTPL4LUBX71yhkfUPl323p8ax9BN1xoLexjRP7/rWab4GD6vmaGLR90iIh7Xyy/V
 RrebFdP4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


+Cc Usama

On Tue, Mar 31, 2026 at 11:08:27PM -0700, syzbot wrote:
>Hello,
>
>syzbot found the following issue on:
>
>HEAD commit:    cf7c3c02fdd0 Add linux-next specific files for 20260330
>git tree:       linux-next
>console output: https://syzkaller.appspot.com/x/log.txt?x=154ee46a580000
>kernel config:  https://syzkaller.appspot.com/x/.config?x=3944d875fa9bfb67
>dashboard link: https://syzkaller.appspot.com/bug?extid=a7067a757858ac8eb085
>compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
>syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12c846ba580000
>
>Downloadable assets:
>disk image: https://storage.googleapis.com/syzbot-assets/053d3b49a360/disk-cf7c3c02.raw.xz
>vmlinux: https://storage.googleapis.com/syzbot-assets/faabb37d41d0/vmlinux-cf7c3c02.xz
>kernel image: https://storage.googleapis.com/syzbot-assets/8d47fe92aaa8/bzImage-cf7c3c02.xz
>
>IMPORTANT: if you fix the issue, please add the following tag to the commit:
>Reported-by: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com
>
> free_pages_and_swap_cache+0x2b9/0x490 mm/swap_state.c:401
> __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
> tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
> tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
> tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
> tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
> exit_mmap+0x498/0x9e0 mm/mmap.c:1313
> __mmput+0x118/0x430 kernel/fork.c:1177
> exit_mm+0x18e/0x250 kernel/exit.c:581
> do_exit+0x6a2/0x22c0 kernel/exit.c:962
> do_group_exit+0x21b/0x2d0 kernel/exit.c:1116
> __do_sys_exit_group kernel/exit.c:1127 [inline]
> __se_sys_exit_group kernel/exit.c:1125 [inline]
> __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1125
> x64_sys_call+0x221a/0x2240 arch/x86/include/generated/asm/syscalls_64.h:232
> do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
>------------[ cut here ]------------
>1
>WARNING: mm/huge_memory.c:4371 at deferred_split_folio+0x974/0xaa0 mm/huge_memory.c:4371, CPU#1: syz.3.1110/10500
>Modules linked in:
>CPU: 1 UID: 0 PID: 10500 Comm: syz.3.1110 Not tainted syzkaller #0 PREEMPT(full) 
>Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
>RIP: 0010:deferred_split_folio+0x974/0xaa0 mm/huge_memory.c:4371
>Code: 31 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d e9 c2 67 8d 09 cc e8 8c 73 93 ff 48 89 df 48 c7 c6 20 5b fc 8b e8 dd 2b f5 fe 90 <0f> 0b 90 e9 d4 fe ff ff e8 9f 7a 8a 09 e8 6a 73 93 ff 48 89 df 48
>RSP: 0018:ffffc900047ef540 EFLAGS: 00010046
>RAX: 1c05fb65cfaab100 RBX: ffffea0001840000 RCX: 0000000080000001
>RDX: 0000000000000002 RSI: ffffffff8e4da1c7 RDI: ffff88807d6f9e80
>RBP: ffffc900047ef610 R08: ffff8880b87247d3 R09: 1ffff110170e48fa
>R10: dffffc0000000000 R11: ffffed10170e48fb R12: ffffea0001840040
>R13: 0000000000000000 R14: 0000000000010000 R15: 1ffff920008fdeb0
>FS:  00007f32e32a76c0(0000) GS:ffff8881250e8000(0000) knlGS:0000000000000000
>CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>CR2: 00007f5825757930 CR3: 0000000034ad8000 CR4: 00000000003526f0
>Call Trace:
> <TASK>
> migrate_folio_move mm/migrate.c:1411 [inline]

Looks like a race introduced by commit[1] ("mm: migrate: requeue
destination folio on deferred split queue").

Between folio migration (mbind) and rmap removal (exit_mmap), I guess :)

migrate_folio_move() snapshots src_partially_mapped from src before
migration:

	if (folio_order(src) > 1 &&
	    !data_race(list_empty(&src->_deferred_list))) {
		src_deferred_split = true;
		src_partially_mapped = folio_test_partially_mapped(src);
	}

Then move_to_new_folio() eventually unqueues src in
__folio_migrate_mapping():

	folio_unqueue_deferred_split(src);

After that, migration restores mappings to dst:

	if (old_page_state & PAGE_WAS_MAPPED)
		remove_migration_ptes(src, dst, 0);

At that point, dst is already visible again. A concurrent unmap path
from another sharer can then remove some of those mappings and reach
deferred_split_folio(dst, true), which sets PG_partially_mapped on
dst.

Migration then resumes and does:

	if (src_deferred_split)
		deferred_split_folio(dst, src_partially_mapped);

If the earlier snapshot from src was false, this becomes
deferred_split_folio(dst, false), but dst may already have been marked
partially mapped by the concurrent rmap-removal path, so the WARN in
deferred_split_folio() fires:

	if (partially_mapped) {
		...
	} else {
		/* partially mapped folios cannot become non-partially mapped */
		VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio);
	}

[1] https://lore.kernel.org/all/20260312104723.1351321-1-usama.arif@linux.dev/

> migrate_folios_move mm/migrate.c:1740 [inline]
> migrate_pages_batch+0x319f/0x4c40 mm/migrate.c:1996
> migrate_pages_sync mm/migrate.c:2026 [inline]
> migrate_pages+0x1c74/0x2a10 mm/migrate.c:2135
> do_mbind mm/mempolicy.c:1614 [inline]
> kernel_mbind mm/mempolicy.c:1757 [inline]
> __do_sys_mbind mm/mempolicy.c:1831 [inline]
> __se_sys_mbind+0xe89/0x10f0 mm/mempolicy.c:1827
> do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
>RIP: 0033:0x7f32e239c819
>Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
>RSP: 002b:00007f32e32a7028 EFLAGS: 00000246 ORIG_RAX: 00000000000000ed
>RAX: ffffffffffffffda RBX: 00007f32e2616090 RCX: 00007f32e239c819
>RDX: 0000000000000000 RSI: 0000000000800000 RDI: 0000200000001000
>RBP: 00007f32e2432c91 R08: 0000000000000000 R09: 0000000000000002
>R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>R13: 00007f32e2616128 R14: 00007f32e2616090 R15: 00007ffe30c61cc8
> </TASK>
>
>
>---
>This report is generated by a bot. It may contain errors.
>See https://goo.gl/tpsmEJ for more information about syzbot.
>syzbot engineers can be reached at syzkaller@googlegroups.com.
>
>syzbot will keep track of this issue. See:
>https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
>If the report is already addressed, let syzbot know by replying with:
>#syz fix: exact-commit-title
>
>If you want syzbot to run the reproducer, reply with:
>#syz test: git://repo/address.git branch-or-commit-hash
>If you attach or paste a git patch, syzbot will apply it before testing.
>
>If you want to overwrite report's subsystems, reply with:
>#syz set subsystems: new-subsystem
>(See the list of subsystem names on the web dashboard)
>
>If the report is a duplicate of another one, reply with:
>#syz dup: exact-subject-of-another-report
>
>If you want to undo deduplication, reply with:
>#syz undup
>
>

