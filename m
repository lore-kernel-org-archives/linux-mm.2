Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5664D35164
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 09:36:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C49376B0005; Wed,  1 Apr 2026 05:36:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF9C46B0088; Wed,  1 Apr 2026 05:36:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE8596B0089; Wed,  1 Apr 2026 05:36:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9B2BF6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 05:36:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4D6EA16079B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:36:55 +0000 (UTC)
X-FDA: 84609482790.20.1D89A81
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 85F3F14000A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:36:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jgjsYPDj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775036213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kyRgZIw9Aez7skWcXM58yH0jyO+5OrauvLPXtM/mU8I=;
	b=Hn4dGgcsmXZxax0mytVoP682Vb2Wpv+TAKOWtoIZJuBba1a2Fq2y5jd+8gOkU4AUYc/yFm
	xbJvlq3kwJM2lrUxw7t8RwqrHSdZhssP3iBOVgM76KCCqE5/VPp6RrY54O4uytV5iQqgYB
	RTySnNgrMQwfig1crDKolCWlUDXv8O4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775036213; a=rsa-sha256;
	cv=none;
	b=3MVn+cBz/0Dj9wsOSRi+pSnAJfVyiLI4204H08E2W6g4t+oAxO2oWzsOHajsBu3uq9ItbY
	LSV2OKQm13EhpHREOoOFTjTjMfKi69O9xw3dGceafW/RGffEb8H0jrgp0lPtmwS98ZroM7
	upw+x4IicgjmpWwi3F28VaPY5wSR0uA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jgjsYPDj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A656460120;
	Wed,  1 Apr 2026 09:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF7CC4CEF7;
	Wed,  1 Apr 2026 09:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775036212;
	bh=cLLbkdmrgHcSVkludMmZDV4Dvq1Ehg21aAFt6YAwwL0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jgjsYPDjfNF/sZw+LlQ3aJ1qMpDN6LUPXTSMK7iT9KLZuBA/PiuqjD2iSi6D4WD2c
	 RsjfvDVzbd/TH+WuRFXy/2fQuJr+VZ05k4UC+m0oXIYkbwQDOHpbmi9Z0OXnhB5u27
	 phkRDRSzMv1O1KzPVAGZOX6FTqFJfwtXRdAqAS97DSAwL0RuoO2zdtZcDjqaFCHR6E
	 YtOBmAKnM2lvG1jhIu27KmeZh3nk5mmZsi1Bj5QYALq7o/RJSEz2HtVLakan8mS0Xc
	 CUWTGG+rPyWit61hyiG9ovSlX8RMbrknvZXf/O6w5Yr6AElHATDCZ7F70XFthEdE5c
	 3DYLzvegxO9/g==
Message-ID: <a2d49c21-fed4-4af2-9ac9-224fafb8b7f9@kernel.org>
Date: Wed, 1 Apr 2026 11:36:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in deferred_split_folio
To: Lance Yang <lance.yang@linux.dev>, usama.arif@linux.dev,
 Liam.Howlett@oracle.com, ziy@nvidia.com
Cc: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com,
 akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 dev.jain@arm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, npache@redhat.com, ryan.roberts@arm.com,
 syzkaller-bugs@googlegroups.com, Deepanshu Kartikey <kartikey406@gmail.com>
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
X-Rspamd-Queue-Id: 85F3F14000A
X-Stat-Signature: h8jd35apt5sdtcozeq9d149tcdmq17nr
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775036213-190454
X-HE-Meta: U2FsdGVkX1+ai2GYPgCjxwkQOVRXlP8+dLSFAa+UbVuybNtYvtApEF00uKeUeRu4CWdGThgSfXPb0Yqohg9gc6pjybxwHrZnKeD8Te7EgRyXbzTGwIqrCS6tLooxM4LZfFHlPjjDUOCVFbfndIvSRKV8O+zEoA8gITlaMjLC3Co3Mpimx1dOQo32hxr36I77iNxP688It6fIb8CuMAzKfWSiEHyTXQxG7RxlCb6JTmcAWfdQZ2QIrrwpendIAgHBH03C0GeN0gAuJIXhNI8dD9ukRAsYwRHD8sURTvgDwaIuEwVam55ftLlVgs0jFtdqGmoLFg9dBAgrt6L9CDt7MDgo5X2rP1wtQ3elVzj3rtMcqEp+6g+8DUKkrw8u+p6NThRcwjhazPIyoSvUpZAxEYkQ45UwnnTibaJunQHkiBkueHe2h3jPxdSZnBYjulMwfQZTnPukINoRZuY3G93qHJUP4kSBgDD5S0rSem56FdRv3zS488ZOFW+1E5QUFZojF/bhRi5j/njw3qcW0NC2K1nn+pY9q1J49ytjUMp7bkUDfjoTUtJpLRv1VaG6Bmji0IRYH7CptNimiyBtDifXgcg+LLhetGtV3crPUtOkd+LsD2csT2Cxe+njBm1tkIvA68D6oRSsgsH17ZDaoIuDEfNa7P9yl6sYP6sD+uv5QFShfFE8Zs0a+8NHt5NsrxUFOqXqfj39ez1mupU5OQWmVeSS7yOHgskZl+CTpS6zJQ+Ck6x9hbA1Y/KKdWphJrwUHaPP6rIRPAkyc61Q8DWpN/cTeh5RqBdVxtpQ7JdH9sdJnwB0o1PxE0U+4cbSDZ+HTOSseQhbG4cni2GRQoXCUz+BR0ydTEddGT/Qrsv7JUpv93vN7vGB4clTL9UaO+/3Cy1Uev/UeJRjtlOFZu8ZyLXtvqWpxkucONgr1hrNVMxPNjtGJ3n5HQuVvqNTViY2zfKv48GAXPQ+cJ8rCUa
 sHmTXk+b
 g0NylET6z3mgQomevROqOX8bXAUX7mRWDdHavTVmOCJO0bcF5y+GIgO4HSI6siMKecZRBYPUiDRpd/l74fMRowPlRdUmeY9k1lUT/FRBBfmkN5cEjAaoL7pznOqIcJvLh8R4aNo1zCCct5GHT1mGxbVfQW95oAcNMA8IHIIjUKE/fNkXw4VNt8aUkNah9xdeLTD0ry685hAcE+YAEUla6TbP4prcUDUc+5OWKV0w/jS6yY8uH41j4jXNnpdhd0iHpC3IecHKlWe6KV9UwxyB8w40kHbWT4/NkPrANybRy3A8SEihrTL6YCLS9ulOY470L7a6uiYesNgBM5h+R+rPuLyJMoEynewPJD6rCBPbBeMX680SYiOVXtLslpLL3zzr1ku9Nst4znTcrvs36tj0dpVMdjKbS94Sax21SRXl4Osy9gSO3OQGvFG1NieKHu4FDLOZaVxmOoyTP5YpsvX7z4kUr8NuFqJNY8FTI8erR7xet5eJb92fCz6cA5vgrtbRi5zSUoLir51N7ucR59EgYlmjlygnprnMXDSrotx99yPmisnIRgiIZ/iiwPuInGNYQd5ULHd7MWgSmiVkEhP5Fv8xk7n29TprFZ+B0U80zGmhABSQHebOhvK+lrzpRBYuYfsg4eVhUxSfUbpChVEBcbrTAGVtIeqb8fB/U9SFol40uJetiNnGAsPZVO6lf8X41F2xTFs90jJdi+bxtPpYFrhDhtNqeX1ME2Y3rGg+rqsYYznoYluvNH+1I7nIG8KVYtvyB15UQe9lxn6iE+sC2Q7ATpOpMBsnp9qEPaiuIxsk+gW8a4g7iBDFpV9qM0K+BmtqUR1YoXsfAeN9ON0LiRGLqSi1NwrMlh8B/5rClAdpozrDGLahFL2XETLXJbL75zMbYmoff6NT0aL9h/zOI8JTIYRPo6s0UOP8kd9DKxiY9f3xB0lVXHQqBKFLelVU5QpaTo3qtXfzX2SYtSSt8zfjWmIk2
 hWapJlwB
 THwFnjR4Zt04ueEJmVz3e/s0c0bAbfMrktAK9hf1SBk=
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

A fix just appeared:

https://lore.kernel.org/r/20260401084116.22219-1-kartikey406@gmail.com

Have to think about this :)


-- 
Cheers,

David

