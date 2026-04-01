Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E23AED35167
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 10:16:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5806F6B008A; Wed,  1 Apr 2026 06:16:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 558BC6B0092; Wed,  1 Apr 2026 06:16:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46EEE6B0093; Wed,  1 Apr 2026 06:16:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 36D496B008A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 06:16:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 56F205AC95
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:16:52 +0000 (UTC)
X-FDA: 84609583464.25.992EEAC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8F28AC000C
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:16:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JjJ+mT3h;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775038610; a=rsa-sha256;
	cv=none;
	b=WkwtAdz20EDtqFY/R5nZZiqB1NQDsTYiFAMA1BwFd7JbPCvaIUPewznt4ENjwSN1XxgsBp
	dSzObb/fLTo/LGgKZDYHLQ8VFkBVQATwyl1s4LcmWP1sZlnVoyuFvWRz+lHdrpmJEmzyY2
	CTf1WHcj4TyeSj8KQxV5oQBgqpZxFfE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775038610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MSuaGKOGqXrRSjDtrIxErtqb0z2XFcaRnKGz3BkvtXc=;
	b=Y42ERBFCAnUf0c9erKCvYKqZ111/3p63LLXFtl2XJQUDFQEpbtL3u1wK469eHCnWYAV6Ge
	XnmN10Nu2HfZKQTBqRKWvlnti/ow6PJ9sGiWZlysGVDCSbHD9HOxKE0tFBoIhG8z7IP6yA
	gHZJmSN0MF/1qFs6fHYvY/Fnt/31UrI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JjJ+mT3h;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E5D216012A;
	Wed,  1 Apr 2026 10:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA42C4CEF7;
	Wed,  1 Apr 2026 10:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775038609;
	bh=cQCM2qWJDrNfgdMABrM+bkhdmw2bA6at0T/aCdtK3tk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JjJ+mT3h6/rDx2gU5dycfDH9JF3uPLt1aPNaP5QZBz9eb3VyvotV46XF//pzWQJMs
	 Xwvqgthq3Ro1T0EAjreScp99HJUDM1P/TNRbnHGrlyaWkkNfCgeQiPJJM6X5WRSjrM
	 OhNkEFCOPH4m54pkvKgNYK1eYxDfE/kiAVjwhqbd0LPd89vGHGvGViQ4eiSODSCbXJ
	 xN90JhhRao/NBp2LX9O3Ze0pwuRullloov1s4/2TNwq6OdFEqs1i0OkHi9flb/1x51
	 4jlbbpxh44Y4lzWdyHPErfBfpW+DVHIJIjwfUBDfY7BuCpTzl+9qhMoT3U1SFq1yax
	 olLaqGzO+prkg==
Message-ID: <27d742c6-631a-4878-9c44-bf49bcce9510@kernel.org>
Date: Wed, 1 Apr 2026 12:16:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in deferred_split_folio
To: Lance Yang <lance.yang@linux.dev>, usama.arif@linux.dev,
 Liam.Howlett@oracle.com, ziy@nvidia.com
Cc: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com,
 akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 dev.jain@arm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, npache@redhat.com, ryan.roberts@arm.com,
 syzkaller-bugs@googlegroups.com
References: <20260401081025.68951-1-lance.yang@linux.dev>
 <20260401085932.20945-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260401085932.20945-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8F28AC000C
X-Stat-Signature: j4pihqe1yq7d967q4ep4xd7qwskrr1t9
X-HE-Tag: 1775038610-541429
X-HE-Meta: U2FsdGVkX1/NRqKjwJzScP2TLWW7AVuiS9K4pG3oW4EYIcwnnIi7YAQWLUHgnueiC28JE4ELcUSq8VtgL8JlMInDlY6+zrklkkG3pVN9AowJ4smDs0fUEapyDPfFsoWULXxPVLhYx1YtxHRSAiXtTCh734igbouNAoOWG/OuCWg051Cy9kq8B2lpEU23325dKAzEgoGFcxQtwA/gcSeQ9go+CIwXWY401sAGR8Q3vvPJ/ZtIJD0GOpEHAcd01n088vfpDDtV2kg4cwcUjTNU4UfCOaF9kiPrpjI91h9ppGFNspB3pYZGJfvA3+EN7QApVbz1FnEmEouDHcVXHxOVJYv0YG959BLaUVJenx961OhT1tVb+NRInklZvNGoVzPe/MEGkRsC/bKksZ/vLfDBwNJyMQghzksG+BEfdTl9oO/jipr1hFmqOdQLXUoem86i3blfpbB4mP1j+RXUeAbko1CzZlal1ftsthBW5fipMg0C1sU4dpJl0q67CGlOUHlWINnogD4aG+jutt/UjCC1NeilNNDWG+z+EegluAPuVgvRpuYo9d8TDtjeebtdOWrDLd8p1r8t25DtZKxTibQZOAMOMO87SeVj5aWKBbxp+FpF/fxSwC+3RYpJKn+F45QYokZA0cnRacXye0PQginYwCohxcwWkBg4kEoHc1Wy7ENC4iBKtJFyi2oQSUCxSsFdSldAmAlR7J0alkvYsXzJtalJSd9BFW/FX3SnZCgTwA4etQDPipvhkiyDXLD5ADvttYLW1Tu/rULDcqE9SQdeDFX8cR+lUFILs6RvmAkzjXyHxKP5UvDMH6KUsllWRt90s66dXt4fGTHbg3SCT9AFtu8YldOqULeYMTIhfhQvUFsy+Y15u/bCpa+xx5YAwReqOpNsOnXl3Cs++KUbPZfsdST5m7fEOKfEMZtvusO2QYF5EZH2+jl8s+pWxZX+1PyWQhmjy7jajF2TalW7vle
 LU2vGZhj
 dc/rV2MWAmCMAhSmG5oA9SCEqiRtlpCI6UkXc6prlDg600WAXXF0bLcHL7dx3jj5t5SlV08Ur9UdXSILmFf/NmvqecWrLT5vL1Y3mEGKvFbbTBZ4gA9y8RPUCk81tGZ4u70OYGfFX9WRIV0kNZyNeZE7blw98jB0pMGviu1NiQZrqXsp5kfXjq0dSVCawNudmEw5RUq+TTD0n1ox+3Tz9sHr4bmwssgB+LW4YJ+ZqbQlwaJPA60jhO3RrBzlrU0TYoEgvwOF2HiGdJyGqCcuBjfsnQZ7/ZVrh3yGfJTsp4lJywglCCMs5DSbUWbj0R7TeHw90LYrPHGbMVI/GXZJrDqx5PmIArLVfOo52Oh7uKc8HhOIhHMoOiib1izNNetW0posKt6+XICp/z6aN99yPBE0/+s3CDeMp/IDwt5c2OdSwh7imNLGvoQ2X9EYt25RtxcDeOWzAoB3p25kW+jlpG4OGOn8bKRfdjYoWvGyWRaTsjNhdYOrXbPyEgqN2Y/iTdKUaC5TtycwEXrQFdPary3RaX4nxUCrjCdXDAW+Cf/gJAzUDIJ0DhAa+UdMaAE8x0vkqFAwtokQi+XAy7lzgNg0UTmU4/vsl3CHhYnrOwGBhOsZZgkgurXn/AWb8RCW6ZZUM8+nTMp8FofqkXhzqLW/L4nQjQ5CGOzGMaOYfo9bPcdBjDaj7BNfedOUMAgoxV3KW5/o+CGliEHtXf8TEmUkjf3Et4qAZmEus6ED8McsrbkfaYEaFSd9nwynilrxnxLMfatbouLW+GYsOab6Snha7BqdOHRVzutBZ5Bwys2sQrP9UuWafaDTF+rJ85ogLx3hzghyoIl14wPiHSVU2alLQreOlCFiOkcDSBeIvuVH4EzoNON/j2ylSxiife+4VLjfp8rUpvUU0dpRxjrPPSzVDM6t/4vnXcxr46V0UUp9tIV6rliv29blhbo2NtVPJYnk57E/ESVAJ6YTj3FX6GwWszzwr
 Bmxyrx7S
 1yGLlBdSIVu9k9nuVhbxoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 10:59, Lance Yang wrote:
> 
> On Wed, Apr 01, 2026 at 04:10:25PM +0800, Lance Yang wrote:
>>
>> +Cc Usama
>>
>> On Tue, Mar 31, 2026 at 11:08:27PM -0700, syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    cf7c3c02fdd0 Add linux-next specific files for 20260330
>>> git tree:       linux-next
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=154ee46a580000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3944d875fa9bfb67
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=a7067a757858ac8eb085
>>> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12c846ba580000
>>>
>>> Downloadable assets:
>>> disk image: https://storage.googleapis.com/syzbot-assets/053d3b49a360/disk-cf7c3c02.raw.xz
>>> vmlinux: https://storage.googleapis.com/syzbot-assets/faabb37d41d0/vmlinux-cf7c3c02.xz
>>> kernel image: https://storage.googleapis.com/syzbot-assets/8d47fe92aaa8/bzImage-cf7c3c02.xz
>>>
>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>> Reported-by: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com
>>>
>>> free_pages_and_swap_cache+0x2b9/0x490 mm/swap_state.c:401
>>> __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
>>> tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
>>> tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
>>> tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
>>> tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
>>> exit_mmap+0x498/0x9e0 mm/mmap.c:1313
>>> __mmput+0x118/0x430 kernel/fork.c:1177
>>> exit_mm+0x18e/0x250 kernel/exit.c:581
>>> do_exit+0x6a2/0x22c0 kernel/exit.c:962
>>> do_group_exit+0x21b/0x2d0 kernel/exit.c:1116
>>> __do_sys_exit_group kernel/exit.c:1127 [inline]
>>> __se_sys_exit_group kernel/exit.c:1125 [inline]
>>> __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1125
>>> x64_sys_call+0x221a/0x2240 arch/x86/include/generated/asm/syscalls_64.h:232
>>> do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>> do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>>> entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>> ------------[ cut here ]------------
>>> 1
>>> WARNING: mm/huge_memory.c:4371 at deferred_split_folio+0x974/0xaa0 mm/huge_memory.c:4371, CPU#1: syz.3.1110/10500
>>> Modules linked in:
>>> CPU: 1 UID: 0 PID: 10500 Comm: syz.3.1110 Not tainted syzkaller #0 PREEMPT(full) 
>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
>>> RIP: 0010:deferred_split_folio+0x974/0xaa0 mm/huge_memory.c:4371
>>> Code: 31 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d e9 c2 67 8d 09 cc e8 8c 73 93 ff 48 89 df 48 c7 c6 20 5b fc 8b e8 dd 2b f5 fe 90 <0f> 0b 90 e9 d4 fe ff ff e8 9f 7a 8a 09 e8 6a 73 93 ff 48 89 df 48
>>> RSP: 0018:ffffc900047ef540 EFLAGS: 00010046
>>> RAX: 1c05fb65cfaab100 RBX: ffffea0001840000 RCX: 0000000080000001
>>> RDX: 0000000000000002 RSI: ffffffff8e4da1c7 RDI: ffff88807d6f9e80
>>> RBP: ffffc900047ef610 R08: ffff8880b87247d3 R09: 1ffff110170e48fa
>>> R10: dffffc0000000000 R11: ffffed10170e48fb R12: ffffea0001840040
>>> R13: 0000000000000000 R14: 0000000000010000 R15: 1ffff920008fdeb0
>>> FS:  00007f32e32a76c0(0000) GS:ffff8881250e8000(0000) knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: 00007f5825757930 CR3: 0000000034ad8000 CR4: 00000000003526f0
>>> Call Trace:
>>> <TASK>
>>> migrate_folio_move mm/migrate.c:1411 [inline]
>>
>> Looks like a race introduced by commit[1] ("mm: migrate: requeue
>> destination folio on deferred split queue").
>>
>> Between folio migration (mbind) and rmap removal (exit_mmap), I guess :)
>>
>> migrate_folio_move() snapshots src_partially_mapped from src before
>> migration:
>>
>> 	if (folio_order(src) > 1 &&
>> 	    !data_race(list_empty(&src->_deferred_list))) {
>> 		src_deferred_split = true;
>> 		src_partially_mapped = folio_test_partially_mapped(src);
>> 	}
>>
>> Then move_to_new_folio() eventually unqueues src in
>> __folio_migrate_mapping():
>>
>> 	folio_unqueue_deferred_split(src);
>>
>> After that, migration restores mappings to dst:
>>
>> 	if (old_page_state & PAGE_WAS_MAPPED)
>> 		remove_migration_ptes(src, dst, 0);
>>
>> At that point, dst is already visible again. A concurrent unmap path
>>from another sharer can then remove some of those mappings and reach
>> deferred_split_folio(dst, true), which sets PG_partially_mapped on
>> dst.
>>
>> Migration then resumes and does:
>>
>> 	if (src_deferred_split)
>> 		deferred_split_folio(dst, src_partially_mapped);
>>
>> If the earlier snapshot from src was false, this becomes
>> deferred_split_folio(dst, false), but dst may already have been marked
>> partially mapped by the concurrent rmap-removal path, so the WARN in
>> deferred_split_folio() fires:
>>
>> 	if (partially_mapped) {
>> 		...
>> 	} else {
>> 		/* partially mapped folios cannot become non-partially mapped */
>> 		VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio);
>> 	}
>>
>> [1] https://lore.kernel.org/all/20260312104723.1351321-1-usama.arif@linux.dev/
>>
> 
> Perhaps the WARN is simply too strict there :)
> 
> Migration already holds the folio lock on dst, while the competing
> rmap-removal path runs under the page-table lock. So once
> remove_migration_ptes(src, dst, 0) makes dst visible again, this race
> looks hard to avoid.
> 
> So maybe the simplest fix is just to drop the WARN in the
> !partially_mapped path:
> 
> ---8<---
> Subject: [PATCH 1/1] mm/thp: avoid false warning in deferred_split_folio()
> 
> From: Lance Yang <lance.yang@linux.dev>
> 
> migrate_folio_move() snapshots src_partially_mapped from src before
> migration and later requeues dst after remove_migration_ptes(src, dst, 0).
> 
> Once dst is visible again, a competing rmap-removal path can legally set
> PG_partially_mapped before the migration path reaches
> deferred_split_folio(dst, src_partially_mapped).
> 
> Migration already holds the folio lock on dst, while the competing
> rmap-removal path runs under the page-table lock. So once
> remove_migration_ptes(src, dst, 0) makes dst visible again, this race
> looks hard to avoid.
> 
> So just drop the WARN in the !partially_mapped path and preserve an
> already-set PG_partially_mapped bit.
> 
> Link: https://lore.kernel.org/linux-mm/69ccb65b.050a0220.183828.003a.GAE@google.com/
> Fixes: 8a8ca142a488 ("mm: migrate: requeue destination folio on deferred split queue")
> Reported-by: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>  mm/huge_memory.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 745eb3d0d4a7..8ea8e293dc7c 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4433,9 +4433,6 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
>  			mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, 1);
> 
>  		}
> -	} else {
> -		/* partially mapped folios cannot become non-partially mapped */
> -		VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio);
>  	}

Can't we simply move the setting before restoring migration ptes?

diff --git a/mm/migrate.c b/mm/migrate.c
index 05cb408846f2..5f222cb0ca90 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1385,6 +1385,15 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
        if (rc)
                goto out;
 
+       /*
+        * Requeue the destination folio on the deferred split queue if
+        * the source was on the queue.  The source is unqueued in
+        * __folio_migrate_mapping(), so we recorded the state from
+        * before move_to_new_folio().
+        */
+       if (src_deferred_split)
+               deferred_split_folio(dst, src_partially_mapped);
+
        /*
         * When successful, push dst to LRU immediately: so that if it
         * turns out to be an mlocked page, remove_migration_ptes() will
@@ -1400,16 +1409,6 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 
        if (old_page_state & PAGE_WAS_MAPPED)
                remove_migration_ptes(src, dst, 0);
-
-       /*
-        * Requeue the destination folio on the deferred split queue if
-        * the source was on the queue.  The source is unqueued in
-        * __folio_migrate_mapping(), so we recorded the state from
-        * before move_to_new_folio().
-        */
-       if (src_deferred_split)
-               deferred_split_folio(dst, src_partially_mapped);
-
 out_unlock_both:
        folio_unlock(dst);
        folio_set_owner_migrate_reason(dst, reason);


-- 
Cheers,

David

