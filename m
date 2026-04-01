Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83BB4D35175
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 10:53:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDF4A6B0005; Wed,  1 Apr 2026 06:53:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB7366B0088; Wed,  1 Apr 2026 06:53:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF4696B0089; Wed,  1 Apr 2026 06:53:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CEEEB6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 06:53:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 790F31A0751
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:53:22 +0000 (UTC)
X-FDA: 84609675444.19.7711F2B
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf22.hostedemail.com (Postfix) with ESMTP id 45443C0009
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:53:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q8Jv4VYw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775040800; a=rsa-sha256;
	cv=none;
	b=Kct7OLEzhCZv7NAQvDTonMQoCwHbo+/l+P+Jb6mrw8WJ2tnJBz/dqJK4uhh8qRf8vp+NB3
	LHaDfByRradnonQjuBzhqNnc0xJH+09a5z0W7sbuUfciqzUAZjwJgQv/pgUBjaol5jBQm2
	6IegSII64QE6IvvRupJU9+mz5wX+ysM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q8Jv4VYw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775040800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WZBim9gtWHodhXgNcGzA+13CjplxJjvc0Vb0+D/17xQ=;
	b=JshzCT3jq00aq0YpkjCDE3ikw8KuidL+a7arRbt0McnDGeETd17stxLKEUvE+Q57qFM9pH
	k6H2mM0cUA6YhpLbROh8ipYNX1s8Wkiqjsoo8fJQAnovj0sA0jWTgp6drAng4Ops4/RWP8
	VivLVj5yeLWFw5U96axOPPtmElZL0eo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775040797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WZBim9gtWHodhXgNcGzA+13CjplxJjvc0Vb0+D/17xQ=;
	b=q8Jv4VYwfzjeIoQLo0763TCnsDJDU6F0uofYsYoGmNA6dyEkuUTWuFWfzEOgOdZKkh3yXV
	QnIlGCUec+gb/04jKarTSedCC0KUPU//pfQWUiikZYg5CKhq0ND3d8GxCPxZ9KUkj+uILl
	fmXmfPhnTy2w0srYrPqXjo1p1naeRSI=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org,
	kartikey406@gmail.com
Cc: lance.yang@linux.dev,
	usama.arif@linux.dev,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	dev.jain@arm.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in deferred_split_folio
Date: Wed,  1 Apr 2026 18:53:05 +0800
Message-Id: <20260401105305.94886-1-lance.yang@linux.dev>
In-Reply-To: <27d742c6-631a-4878-9c44-bf49bcce9510@kernel.org>
References: <27d742c6-631a-4878-9c44-bf49bcce9510@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: bk34oinkqaz6o3fejj61errtpktr6bwb
X-Rspamd-Queue-Id: 45443C0009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775040800-608249
X-HE-Meta: U2FsdGVkX18DJgI1+eJ/SIKlk3bgmBF2u0W41bAUux73E/x3cmBasAfHyX3SVVNvKcZQ0aLoq6fVJNrEBdlHnbZXQtrda7WF8Ot3e09gO7adSRJtjFBVqIUHAdJtr9TEicAINsj28S+dNGijKVd3D2JQmumLfXL/srbGn2OHDALnCYtjSu21th0/Q+FI4zlXxGEEB0afGY5LYg5sR+N66WV3IXdNy4WI6ZX81ryHBfAMgErTZXPIGhPrwJvpWDKAUlIJZ/zEz3hxDVIc39kXBzm1rncj3okuV+lMBNneMZcZVoGvPIlm+rtb3yAxVmBkPQs3o4iX/7iXtl4fZtrtcvkcrRN4h+3FiyoPT9y7+Qm9pMI0mCzAQISu8AlbN9rc4zsBuzKFK8FPYzAJP2mYDmc2bpbCHnov4/FD5eb0eDz3zm/FY1aRKW0autLMRFQgDs7Q8XB6g2bFF3pH0jsTgPDj9afxEjrhIS9lFmf2vbSVYougyMnQIJoKoJSSzv1wtstCJUvgUsGIVkAF3iLU0KyL33vssiG08neBCfP146xMSbgfeCxZj3ZuuEZ4wzM4sQoPBjee9mw9VIXigEqRKsNM8r+CdP1AGZPiMEN7FAAyCgA94jgzqD03RxN1uJhYGQqXmtxc4mKmBOXCpH0g3Z80m7JnGsmo2j2/Ctr3/pwvVKV9+l5Bgy9k7aeqtD0QQRt17ZltvvgBvEgmxfhX9xwIkA8mftjROzEquhfm6HpLyHKB0Y015Y7OBtqLeprbeu21ZDzVNdcWP4uqnMYZBnos+HsYegZPlVmnMK6tHb7CbELP8BS56pgt0HN1TcMYrpSnTkdCuIOvIgceaJyU9AhPTUpEYdBNQNBnskUdGJ9uHVW147VYyeFcXCQkK4nUiwIdXPTTgRMu1XNrxOZS70FWeQ5HZUh1EoZKh/RL4AfkOcJbfQ46YWRytyZxt7ZCgWJ9OsmlOcnVVgFluqk
 yPVa7lAu
 5Im0n4JrTYTdFuob3aEAxjNaH/ZA1jnPOUIv2nLZj0jmv9CFtp3kSKU9B6FLHgaV2agJELYzgI+Sj6ZDeLDbrV/6enmLs2yJLi4U6I/triQMnYOsNVoRFQw+hK2CP4gM08G4co39/4w5FHNaIsUEuEbaPKzXtG7bctFP2XpedGf46L57xJv2mm0k3aejqEU6JVmK/NZzSi1R/jdR3Fm6fp19GSB9YD6WKEzIKuwEUj3ewOpfUaJFmA9TMY3i7VpD2xqRFoW6cUcvOSu6vZRuRslj7IDBNc0guYer/IzCHoTXpv2xWs+n0XnK0QUVL0DSwM++maxTykgzSxVRNmbGdVkdisGBkKiI580PXifxPY8T6PM21YjJ4cAbUEW8YPtb1+5Pj2ohXH41zJvh4Ct+0rlZZ1xl/0ameHV3co+Y+AGnN8u12Slrfyn4cNWaoV6itjQjN3TCAVTsUuiZ0jWhByiWKpbqMrJIEVxZcgEkrY8uXFvfUc0hNAagJQMQ4Mtduu0eqMcfH2Us+aujgossViz+9Ewv0uNrXPg5aB2lRRVaMbpc4IhqAJ4wcRy7JMNBAEfmuVsEpMKCCJiGqLylA41QyYTM2I9HzJDYV+CHUuomVeowr2XyYWbSbjz0i2B8L9ee362eIOqaLYH6X3OP8xPyO3y/PHrFFr7v/6dCqeDGQ5LSFaeqqWqQuROTe+xtfiuYT1Qqt2H9noPPoTgpkbGP3R3stQv6w2AOVx7awb0UIyq9zxyi5s6KST8/Z4vMr4IKx8SkHutnK//Rh0OJxVtH+qZfuC6uRX2US1EZHXkIZbh9d/ADogzxn5K/nS6/Smorwnnzx78w6Cu2qYdbV+Cv3Wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


+Cc Deepanshu

On Wed, Apr 01, 2026 at 12:16:43PM +0200, David Hildenbrand (Arm) wrote:
>On 4/1/26 10:59, Lance Yang wrote:
>> 
>> On Wed, Apr 01, 2026 at 04:10:25PM +0800, Lance Yang wrote:
>>>
>>> +Cc Usama
>>>
>>> On Tue, Mar 31, 2026 at 11:08:27PM -0700, syzbot wrote:
>>>> Hello,
>>>>
>>>> syzbot found the following issue on:
>>>>
>>>> HEAD commit:    cf7c3c02fdd0 Add linux-next specific files for 20260330
>>>> git tree:       linux-next
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=154ee46a580000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3944d875fa9bfb67
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=a7067a757858ac8eb085
>>>> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
>>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12c846ba580000
>>>>
>>>> Downloadable assets:
>>>> disk image: https://storage.googleapis.com/syzbot-assets/053d3b49a360/disk-cf7c3c02.raw.xz
>>>> vmlinux: https://storage.googleapis.com/syzbot-assets/faabb37d41d0/vmlinux-cf7c3c02.xz
>>>> kernel image: https://storage.googleapis.com/syzbot-assets/8d47fe92aaa8/bzImage-cf7c3c02.xz
>>>>
>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>> Reported-by: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com
>>>>
>>>> free_pages_and_swap_cache+0x2b9/0x490 mm/swap_state.c:401
>>>> __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
>>>> tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
>>>> tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
>>>> tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:424
>>>> tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
>>>> exit_mmap+0x498/0x9e0 mm/mmap.c:1313
>>>> __mmput+0x118/0x430 kernel/fork.c:1177
>>>> exit_mm+0x18e/0x250 kernel/exit.c:581
>>>> do_exit+0x6a2/0x22c0 kernel/exit.c:962
>>>> do_group_exit+0x21b/0x2d0 kernel/exit.c:1116
>>>> __do_sys_exit_group kernel/exit.c:1127 [inline]
>>>> __se_sys_exit_group kernel/exit.c:1125 [inline]
>>>> __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1125
>>>> x64_sys_call+0x221a/0x2240 arch/x86/include/generated/asm/syscalls_64.h:232
>>>> do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>>> do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>>>> entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>>> ------------[ cut here ]------------
>>>> 1
>>>> WARNING: mm/huge_memory.c:4371 at deferred_split_folio+0x974/0xaa0 mm/huge_memory.c:4371, CPU#1: syz.3.1110/10500
>>>> Modules linked in:
>>>> CPU: 1 UID: 0 PID: 10500 Comm: syz.3.1110 Not tainted syzkaller #0 PREEMPT(full) 
>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
>>>> RIP: 0010:deferred_split_folio+0x974/0xaa0 mm/huge_memory.c:4371
>>>> Code: 31 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d e9 c2 67 8d 09 cc e8 8c 73 93 ff 48 89 df 48 c7 c6 20 5b fc 8b e8 dd 2b f5 fe 90 <0f> 0b 90 e9 d4 fe ff ff e8 9f 7a 8a 09 e8 6a 73 93 ff 48 89 df 48
>>>> RSP: 0018:ffffc900047ef540 EFLAGS: 00010046
>>>> RAX: 1c05fb65cfaab100 RBX: ffffea0001840000 RCX: 0000000080000001
>>>> RDX: 0000000000000002 RSI: ffffffff8e4da1c7 RDI: ffff88807d6f9e80
>>>> RBP: ffffc900047ef610 R08: ffff8880b87247d3 R09: 1ffff110170e48fa
>>>> R10: dffffc0000000000 R11: ffffed10170e48fb R12: ffffea0001840040
>>>> R13: 0000000000000000 R14: 0000000000010000 R15: 1ffff920008fdeb0
>>>> FS:  00007f32e32a76c0(0000) GS:ffff8881250e8000(0000) knlGS:0000000000000000
>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> CR2: 00007f5825757930 CR3: 0000000034ad8000 CR4: 00000000003526f0
>>>> Call Trace:
>>>> <TASK>
>>>> migrate_folio_move mm/migrate.c:1411 [inline]
>>>
>>> Looks like a race introduced by commit[1] ("mm: migrate: requeue
>>> destination folio on deferred split queue").
>>>
>>> Between folio migration (mbind) and rmap removal (exit_mmap), I guess :)
>>>
>>> migrate_folio_move() snapshots src_partially_mapped from src before
>>> migration:
>>>
>>> 	if (folio_order(src) > 1 &&
>>> 	    !data_race(list_empty(&src->_deferred_list))) {
>>> 		src_deferred_split = true;
>>> 		src_partially_mapped = folio_test_partially_mapped(src);
>>> 	}
>>>
>>> Then move_to_new_folio() eventually unqueues src in
>>> __folio_migrate_mapping():
>>>
>>> 	folio_unqueue_deferred_split(src);
>>>
>>> After that, migration restores mappings to dst:
>>>
>>> 	if (old_page_state & PAGE_WAS_MAPPED)
>>> 		remove_migration_ptes(src, dst, 0);
>>>
>>> At that point, dst is already visible again. A concurrent unmap path
>>>from another sharer can then remove some of those mappings and reach
>>> deferred_split_folio(dst, true), which sets PG_partially_mapped on
>>> dst.
>>>
>>> Migration then resumes and does:
>>>
>>> 	if (src_deferred_split)
>>> 		deferred_split_folio(dst, src_partially_mapped);
>>>
>>> If the earlier snapshot from src was false, this becomes
>>> deferred_split_folio(dst, false), but dst may already have been marked
>>> partially mapped by the concurrent rmap-removal path, so the WARN in
>>> deferred_split_folio() fires:
>>>
>>> 	if (partially_mapped) {
>>> 		...
>>> 	} else {
>>> 		/* partially mapped folios cannot become non-partially mapped */
>>> 		VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio);
>>> 	}
>>>
>>> [1] https://lore.kernel.org/all/20260312104723.1351321-1-usama.arif@linux.dev/
>>>
>> 
>> Perhaps the WARN is simply too strict there :)
>> 
>> Migration already holds the folio lock on dst, while the competing
>> rmap-removal path runs under the page-table lock. So once
>> remove_migration_ptes(src, dst, 0) makes dst visible again, this race
>> looks hard to avoid.
>> 
>> So maybe the simplest fix is just to drop the WARN in the
>> !partially_mapped path:
>> 
>> ---8<---
>> Subject: [PATCH 1/1] mm/thp: avoid false warning in deferred_split_folio()
>> 
>> From: Lance Yang <lance.yang@linux.dev>
>> 
>> migrate_folio_move() snapshots src_partially_mapped from src before
>> migration and later requeues dst after remove_migration_ptes(src, dst, 0).
>> 
>> Once dst is visible again, a competing rmap-removal path can legally set
>> PG_partially_mapped before the migration path reaches
>> deferred_split_folio(dst, src_partially_mapped).
>> 
>> Migration already holds the folio lock on dst, while the competing
>> rmap-removal path runs under the page-table lock. So once
>> remove_migration_ptes(src, dst, 0) makes dst visible again, this race
>> looks hard to avoid.
>> 
>> So just drop the WARN in the !partially_mapped path and preserve an
>> already-set PG_partially_mapped bit.
>> 
>> Link: https://lore.kernel.org/linux-mm/69ccb65b.050a0220.183828.003a.GAE@google.com/
>> Fixes: 8a8ca142a488 ("mm: migrate: requeue destination folio on deferred split queue")
>> Reported-by: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>  mm/huge_memory.c | 3 ---
>>  1 file changed, 3 deletions(-)
>> 
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 745eb3d0d4a7..8ea8e293dc7c 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4433,9 +4433,6 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
>>  			mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, 1);
>> 
>>  		}
>> -	} else {
>> -		/* partially mapped folios cannot become non-partially mapped */
>> -		VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio);
>>  	}
>
>Can't we simply move the setting before restoring migration ptes?

Afraid not, it closes the remove_migration_ptes() ->
deferred_split_folio() race, but opens a new one with the shrinker, IIUC

Once dst is on the deferred split queue, deferred_split_scan() can
pick it up immediately. The shrinker unconditionally dequeues every
folio it visits:

	list_del_init(&folio->_deferred_list);   /* always */

Then for a non-partially-mapped folio, if folio_trylock() fails
(dst is still locked by migration), it falls through to:

next:
		if (did_split || !folio_test_partially_mapped(folio))
			continue;  /* not requeued, dst silently lost */

so it is *not* requeued.

That seems to recreate the original issue commit[1] was fixing: letting
underused THPs silently fall off the deferred split queue again ...

Hopefully, I didn't miss something important :)

[1] https://lore.kernel.org/all/20260312104723.1351321-1-usama.arif@linux.dev/

>diff --git a/mm/migrate.c b/mm/migrate.c
>index 05cb408846f2..5f222cb0ca90 100644
>--- a/mm/migrate.c
>+++ b/mm/migrate.c
>@@ -1385,6 +1385,15 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>        if (rc)
>                goto out;
> 
>+       /*
>+        * Requeue the destination folio on the deferred split queue if
>+        * the source was on the queue.  The source is unqueued in
>+        * __folio_migrate_mapping(), so we recorded the state from
>+        * before move_to_new_folio().
>+        */
>+       if (src_deferred_split)
>+               deferred_split_folio(dst, src_partially_mapped);
>+
>        /*
>         * When successful, push dst to LRU immediately: so that if it
>         * turns out to be an mlocked page, remove_migration_ptes() will
>@@ -1400,16 +1409,6 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
> 
>        if (old_page_state & PAGE_WAS_MAPPED)
>                remove_migration_ptes(src, dst, 0);
>-
>-       /*
>-        * Requeue the destination folio on the deferred split queue if
>-        * the source was on the queue.  The source is unqueued in
>-        * __folio_migrate_mapping(), so we recorded the state from
>-        * before move_to_new_folio().
>-        */
>-       if (src_deferred_split)
>-               deferred_split_folio(dst, src_partially_mapped);
>-
> out_unlock_both:
>        folio_unlock(dst);
>        folio_set_owner_migrate_reason(dst, reason);
>
>

