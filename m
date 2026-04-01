Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FC34D3515F
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 08:59:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C11FE6B0005; Wed,  1 Apr 2026 04:59:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9BC06B0088; Wed,  1 Apr 2026 04:59:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A63626B0089; Wed,  1 Apr 2026 04:59:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 910086B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 04:59:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 34882160772
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:59:55 +0000 (UTC)
X-FDA: 84609389550.24.B319518
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id 51F0B1C0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:59:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UNRby26p;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775033993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qXE23v6Xe1ckxx6xxRFxCgDOboFKH33RxjSSREyXMO4=;
	b=erDc9iGGeiyYAgwQYFkOdrPHZxm8dSse5kNKA5ke94Dh1m0nS7RfAOUqm7NrfAiF/Wl263
	3Zmd2OUFjflzybJJNIBZY0qVXNbpT9JAsdBkfyhajXGsvNr96PUHhKQivEqG9AoDps4zJM
	0WEi/kkA8TKU/0R9xFZRrjF+QJrSsqA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UNRby26p;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775033993; a=rsa-sha256;
	cv=none;
	b=gJUIO/JaFWg3XpRkBFXgtTY5v3sZ1OxvxFt8oJ7vC5vhuZkcqyoe9VDX7ddy6wkM1Lna5C
	9A6PajYxlhSCTA0M+z77+/z9bIA35Lj3s4UPbHditE3uFZiZsH9vBMAYpteuXl/wC+rYHy
	Llnv6yuCjpCoy6UgN5lSu44EczToI9M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775033991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qXE23v6Xe1ckxx6xxRFxCgDOboFKH33RxjSSREyXMO4=;
	b=UNRby26p74Jodr1KsvYfZw93OYuNvsgaO2jQI8Rz/JfUbGv59xnsl2Pl1csbsZpPxn+IK+
	x+PGZQwvoGWNqVv35oOfSB/s36XKh8DcnH6Kpa37BFJY8cwUsLhMc0CW4pMfypD1NckGOO
	lAEoAE2PoMwRZJBQHV5SD9ZAiaUAycY=
From: Lance Yang <lance.yang@linux.dev>
To: usama.arif@linux.dev,
	david@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com
Cc: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	dev.jain@arm.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	syzkaller-bugs@googlegroups.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [syzbot] [mm?] WARNING in deferred_split_folio
Date: Wed,  1 Apr 2026 16:59:32 +0800
Message-Id: <20260401085932.20945-1-lance.yang@linux.dev>
In-Reply-To: <20260401081025.68951-1-lance.yang@linux.dev>
References: <20260401081025.68951-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 51F0B1C0005
X-Stat-Signature: 4c7te6rifp4wfksig7gwjh9kfykusezw
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775033993-987016
X-HE-Meta: U2FsdGVkX19TEbb+tU0fSgL1is4P7675snU3PpGdaRxobx7UImyiwik5vxhi/hNog6LYaIJLxAxvGTlFCcjh/gxLF63Y7lXMDU8OO+LS5jD48nYK4txuBt1gC27wOVqCJFHtblESzd76qiYzA1HMOe+KSNcc94OixVWkb/PjcAYKBg0i8aTD2k5AEy07FlaQ7F0pv9ZEcvnhfRPnytPZrdokbdW/dPvsk6L7PNGp+QTF2iSLkZ5PuoeM6QUqlEnG+EU79v/yGTTLhsWcMNbsjeJ3CYLizFxcScz3DkdZ+utxmGaSGaokD9t+IzZqcqjETBtTWpGVNUMmgKt4n3kxhhh9G0v2yCwHsERdEdeFEJTJVS1YtCZWRNYTXK9jx+va+x9gQEaNnOiocyPjTlfL37rEnanM8GkNZ4zO68+z7FtCW8xB34aFbntz2T5eUe9LdYbWb7VJL+d1FB6wfieR4rKEsKFWlqXxm2EFz+/Jf2ARmtyivpijXaG8BwVbsXN54vq3u2HZ+6rV+WZ9KsQfKnIiHlokKBB5iEy5m9q4zmJdVi3/FUH/2+tLnXoqq6Q7pun1lMTxZv9H+y+5gYi2q6pPSVteyEt2jyzLslL9+NwIKjVH4B4bevMMskYf2Ax7hyYlzkgSk3/Nb53yUgDWLlJr4cMEDGey0xKF7NMHSiEqG2GL0HwB6YAyZperJk9a6r4Lh3uTJt7QDvv4s6qfSOz46IVBSoXiFhfzY9S8xv41WMLcmFvCqopmTKrTFFXud90APa6Pb3NAwFqA41PRoi/3BYTHy3/AWTh5CjathaRriJfny1yV5SVyZFXAdz/s1bQbDDqWiKuYNagJZ+CLCU/QsCuRVAMEMz4N/MuAL0rihLujMMpc4EbVp1QhAVIO11mQUDxkkT5A/01WvyZZWLuv44vzxfzr6/1TCSKVdMXum6oUKo53kK0d2e0EUxXEhs1KcHNOLMnwtSec2/+
 HfP4FBb0
 VuQPfOsi3fnKD00VLTo23yuqfUBopJ3TrLcmhTMJxYyOFK3vRaWwQoDVlDnZN++yqtptsvfXbcC298sLnHrERfLOezMJozIh5Gq3EYjWZFjYO/Vbx7btqL5Xpit8Fihz37QUdWuV4RVCX4k6EvEidMZCk+vBaOsKFHkhkDDH8rKkj1plkh8r6ftjYUoTQGyy6ieo7wq+GFcxVZFkPagvmCB4Tf1U6zk/p+UHhhK6wgwx0e8IoXEEb2f1roEA9sGFP8XWuc3sHAUXVJnJf41vhV/RmxFYHhdzZL2mNDsRRXQX+oe7Z9jeWJ8y9bSXYs+Qzh/woddA/TY1xZLIsjDlVnvGbbKBv5ZEe+x9y+msXURiS213Fl+VyZi05w8q7/Pt8mZzeaU5yD98P+PvL6q9qECE3wmzlV/4Kd1mNXWCTd3J35Fk906gbyPGt/0+dW9XI9M95Y0uf/XVpgHrGYcSC1+8y/6DzsIZVbDrkaiqyQ3HGsknQiZ9C+pTJ5mOEU1ERz06HMZhmdXhkkdM6lji8STCcXsRQmqGUd49WBB54MilIDWSWEf+fpc0Jl+VXZmPDmPjIXCHZ4egnNeI1yU9YG3imFOE7KzbLxjtXx4BNZ4AZHF0wgvPm6CuK4H/ebN1jRDuQVggRcowyBiet+/26wd4lg1ityS4F2Oz6Odhu5GO91ZpR6VxVreMbUqXrCJpEWm388oY06j/PYk93RK8eCD6ItW0/DI7467YwUbQRSYF8ESqCwOiF2q9GfIVhRb0nPUqr2fLteU4OkhGG5IwpNH2c4Dwwux1vRx94bVyuwH1adD6hn9qNRU1d3Tmc6WRBUk1r2uMDzUUK5hgSxAW2p++7SA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Apr 01, 2026 at 04:10:25PM +0800, Lance Yang wrote:
>
>+Cc Usama
>
>On Tue, Mar 31, 2026 at 11:08:27PM -0700, syzbot wrote:
>>Hello,
>>
>>syzbot found the following issue on:
>>
>>HEAD commit:    cf7c3c02fdd0 Add linux-next specific files for 20260330
>>git tree:       linux-next
>>console output: https://syzkaller.appspot.com/x/log.txt?x=154ee46a580000
>>kernel config:  https://syzkaller.appspot.com/x/.config?x=3944d875fa9bfb67
>>dashboard link: https://syzkaller.appspot.com/bug?extid=a7067a757858ac8eb085
>>compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
>>syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12c846ba580000
>>
>>Downloadable assets:
>>disk image: https://storage.googleapis.com/syzbot-assets/053d3b49a360/disk-cf7c3c02.raw.xz
>>vmlinux: https://storage.googleapis.com/syzbot-assets/faabb37d41d0/vmlinux-cf7c3c02.xz
>>kernel image: https://storage.googleapis.com/syzbot-assets/8d47fe92aaa8/bzImage-cf7c3c02.xz
>>
>>IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>Reported-by: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com
>>
>> free_pages_and_swap_cache+0x2b9/0x490 mm/swap_state.c:401
>> __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
>> tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
>> tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
>> tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
>> tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
>> exit_mmap+0x498/0x9e0 mm/mmap.c:1313
>> __mmput+0x118/0x430 kernel/fork.c:1177
>> exit_mm+0x18e/0x250 kernel/exit.c:581
>> do_exit+0x6a2/0x22c0 kernel/exit.c:962
>> do_group_exit+0x21b/0x2d0 kernel/exit.c:1116
>> __do_sys_exit_group kernel/exit.c:1127 [inline]
>> __se_sys_exit_group kernel/exit.c:1125 [inline]
>> __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1125
>> x64_sys_call+0x221a/0x2240 arch/x86/include/generated/asm/syscalls_64.h:232
>> do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>> do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>> entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>------------[ cut here ]------------
>>1
>>WARNING: mm/huge_memory.c:4371 at deferred_split_folio+0x974/0xaa0 mm/huge_memory.c:4371, CPU#1: syz.3.1110/10500
>>Modules linked in:
>>CPU: 1 UID: 0 PID: 10500 Comm: syz.3.1110 Not tainted syzkaller #0 PREEMPT(full) 
>>Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
>>RIP: 0010:deferred_split_folio+0x974/0xaa0 mm/huge_memory.c:4371
>>Code: 31 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d e9 c2 67 8d 09 cc e8 8c 73 93 ff 48 89 df 48 c7 c6 20 5b fc 8b e8 dd 2b f5 fe 90 <0f> 0b 90 e9 d4 fe ff ff e8 9f 7a 8a 09 e8 6a 73 93 ff 48 89 df 48
>>RSP: 0018:ffffc900047ef540 EFLAGS: 00010046
>>RAX: 1c05fb65cfaab100 RBX: ffffea0001840000 RCX: 0000000080000001
>>RDX: 0000000000000002 RSI: ffffffff8e4da1c7 RDI: ffff88807d6f9e80
>>RBP: ffffc900047ef610 R08: ffff8880b87247d3 R09: 1ffff110170e48fa
>>R10: dffffc0000000000 R11: ffffed10170e48fb R12: ffffea0001840040
>>R13: 0000000000000000 R14: 0000000000010000 R15: 1ffff920008fdeb0
>>FS:  00007f32e32a76c0(0000) GS:ffff8881250e8000(0000) knlGS:0000000000000000
>>CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>CR2: 00007f5825757930 CR3: 0000000034ad8000 CR4: 00000000003526f0
>>Call Trace:
>> <TASK>
>> migrate_folio_move mm/migrate.c:1411 [inline]
>
>Looks like a race introduced by commit[1] ("mm: migrate: requeue
>destination folio on deferred split queue").
>
>Between folio migration (mbind) and rmap removal (exit_mmap), I guess :)
>
>migrate_folio_move() snapshots src_partially_mapped from src before
>migration:
>
>	if (folio_order(src) > 1 &&
>	    !data_race(list_empty(&src->_deferred_list))) {
>		src_deferred_split = true;
>		src_partially_mapped = folio_test_partially_mapped(src);
>	}
>
>Then move_to_new_folio() eventually unqueues src in
>__folio_migrate_mapping():
>
>	folio_unqueue_deferred_split(src);
>
>After that, migration restores mappings to dst:
>
>	if (old_page_state & PAGE_WAS_MAPPED)
>		remove_migration_ptes(src, dst, 0);
>
>At that point, dst is already visible again. A concurrent unmap path
>from another sharer can then remove some of those mappings and reach
>deferred_split_folio(dst, true), which sets PG_partially_mapped on
>dst.
>
>Migration then resumes and does:
>
>	if (src_deferred_split)
>		deferred_split_folio(dst, src_partially_mapped);
>
>If the earlier snapshot from src was false, this becomes
>deferred_split_folio(dst, false), but dst may already have been marked
>partially mapped by the concurrent rmap-removal path, so the WARN in
>deferred_split_folio() fires:
>
>	if (partially_mapped) {
>		...
>	} else {
>		/* partially mapped folios cannot become non-partially mapped */
>		VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio);
>	}
>
>[1] https://lore.kernel.org/all/20260312104723.1351321-1-usama.arif@linux.dev/
>

Perhaps the WARN is simply too strict there :)

Migration already holds the folio lock on dst, while the competing
rmap-removal path runs under the page-table lock. So once
remove_migration_ptes(src, dst, 0) makes dst visible again, this race
looks hard to avoid.

So maybe the simplest fix is just to drop the WARN in the
!partially_mapped path:

---8<---
Subject: [PATCH 1/1] mm/thp: avoid false warning in deferred_split_folio()

From: Lance Yang <lance.yang@linux.dev>

migrate_folio_move() snapshots src_partially_mapped from src before
migration and later requeues dst after remove_migration_ptes(src, dst, 0).

Once dst is visible again, a competing rmap-removal path can legally set
PG_partially_mapped before the migration path reaches
deferred_split_folio(dst, src_partially_mapped).

Migration already holds the folio lock on dst, while the competing
rmap-removal path runs under the page-table lock. So once
remove_migration_ptes(src, dst, 0) makes dst visible again, this race
looks hard to avoid.

So just drop the WARN in the !partially_mapped path and preserve an
already-set PG_partially_mapped bit.

Link: https://lore.kernel.org/linux-mm/69ccb65b.050a0220.183828.003a.GAE@google.com/
Fixes: 8a8ca142a488 ("mm: migrate: requeue destination folio on deferred split queue")
Reported-by: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/huge_memory.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 745eb3d0d4a7..8ea8e293dc7c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4433,9 +4433,6 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 			mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, 1);

 		}
-	} else {
-		/* partially mapped folios cannot become non-partially mapped */
-		VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio);
 	}
 	if (list_empty(&folio->_deferred_list)) {
 		struct mem_cgroup *memcg;
---

Thanks,
Lance

