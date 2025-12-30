Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2439EE57C2
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 22:02:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 435CB6B0088; Tue, 30 Dec 2025 17:02:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40CD86B0089; Tue, 30 Dec 2025 17:02:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 319846B008A; Tue, 30 Dec 2025 17:02:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F9616B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 17:02:27 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BDBDC1A080B
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 22:02:26 +0000 (UTC)
X-FDA: 84277511892.01.D4B8513
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id DB561A001C
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 22:02:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RpkbdY7T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767132145; a=rsa-sha256;
	cv=none;
	b=gFkLyaPycpKIofhgkix94OP9DRXw/RqpPHluVd0O58khwhiFe/Ypq5FR68vQLLT62QC7x0
	WCzHzebGCQ49dhYF21Tt4tBzRN4vL2i55EX3Mi5FAbQjaeqGYInoUBDyJI251rKkAAkmV6
	s6mhIkihUTkl9uQSIXJ24gkoQ6WemaQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RpkbdY7T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767132145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zYun/YeddNnYvSiBalp5RAIdD8quOD/DFu8uj7yME4I=;
	b=1cWGH51kTFPHTO9SWYPL6RSDtNuIO43mG/ANJwhzDn5BYwHlw6L+wCOn1hF7J9f5qGcS+6
	a3PRGIUmzhpI93s211qtheYfIjVwDmF0TIuFofD5ezjF5u7v+unAzJSNuUAr1rbu7tRiZP
	jEeSfL4aYHGHy3Q6TPepByG1KAkGrUI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 02FBC43D1C;
	Tue, 30 Dec 2025 22:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E765C4CEFB;
	Tue, 30 Dec 2025 22:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767132143;
	bh=qMZnY2LPlhyNsR3ghVPr24HRKEYMR+wHAj9eT5hWNlQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RpkbdY7T4rPeO9v4fRt+LnxZo7qvgP8wuOEgu/M0zb2g41avE0vp/uLctG6x0H85A
	 +CqM7cqHii/g93EkuvLax/8XwytlRrmMW+/F3AlDBsxSEG/L/nNQWt4FjB4Awmb4I5
	 WXAXyHJSvCUbZ625ZOUdjTYj0no7uIB8IBQTaKOAOT+PxzL1GpBJa/2kAzzoX2K0M9
	 3FKbd2MrSUq7xs6SezJQHx2iBgIC5smO8bkDWB0LT+Np7ci2NY2favGDY0ohkjR0y7
	 muylK8yqEmNfajAZl7J4g6d6xn/nhHkxarENPj3/lHrc3WJyoBlY5kI9FY3OSHrBeN
	 MMfPvxs94h7MQ==
Message-ID: <5f05de8e-04e5-490b-ab5b-0260d17d3b3a@kernel.org>
Date: Tue, 30 Dec 2025 23:02:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in folio_remove_rmap_ptes
To: Harry Yoo <harry.yoo@oracle.com>,
 syzbot <syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, jannh@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, riel@surriel.com,
 syzkaller-bugs@googlegroups.com, vbabka@suse.cz
References: <694a2745.050a0220.19928e.0017.GAE@google.com>
 <aUt7jbCP_KQtjSbH@hyeyoo>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aUt7jbCP_KQtjSbH@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DB561A001C
X-Stat-Signature: f4nnjqyz17xnzu93ey57gnj8z1hn8ojm
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767132144-392901
X-HE-Meta: U2FsdGVkX187y1dcVmZJExiSUiYQR6XvVADZ6VyWCvh7NPzmji+UEMKVXRrs/7T1vm/u6dRo/ZJm3igDOaQc26xQ+NJWRxoRYPzE9CW7lVIOnaAHmpKtKOaWT6wqUtOtuXAAI2291CoCdV1zy4JuNYPT4BcTbD1rkWAftUf37OyJWtdTMklpfxoI05m5uhMVr0smbuBdeYUB5ait8farzqePzgFm9lYOT5EnWtm1nJLcMUPrbAGvGh6OS343TwZ4Mza+hswgaWfbjEZqkmf6JBECFG25De20mIrinUqDUjQCyL0GCyKyDZ1DCXujvPoWMOVys+KCKq5+8QW/igrgLI4r4wgDqYuhvEa70l12jESMwCCd2Nu+2DEF2Cel2EFd7/60xzTFdF4l383Fct52KgNw+xG8bLIV7V+VQ/u8Y9cJsqa0PN45DMdlIOTl/XgCTgGoS6os9gqcpnzQyCkjWkW49yDApFfrctmp9bgHjvJGdlj+YxzWgPo4ggK9htiQwLxnsQzezQBeO7SZPZRCF7udG6H+O/i6sWqb48sLpOizWlZ8Ri8qRUeBzZjAF1V4W9gYc4bhmyYheCiIGvJVMd8wRi6Idl5y+ngl4kC3ILQwQFgZgA2K3SMmx6MQ2uSHHrTNwHXp829AkWXVGCScF0pEGt8+Aru8TmiQJxfw/Zl81r86UpZ66SKWPm2MZQl+lxlaptYPdFAZUfg7iILHadJhVqO518lFUyUc4MO008aVy5OP/woPBfLml3zPRTW2AMSAgiAevJgbamHVlJ+5JEFsBeImJOTQo8L4e251+xomcrA/7sgab7BDbuXdJtz/Y6LoJxcS59ZCA6WgHzQZ1Yo1g8JKLOTJAD2jlMOsFrG1dcKcVAxgRp7hUJw79nHgn3VmDy6VL+Nwfqn8NUWyX9gekEEQsQZR8MRW6W/A/4KKkbo/gGQsndQDZEN1oj90kT8yJrGuigkKiRoYJg7
 ELf0K/t3
 NjvBqUd2ok6Jj1tA0mpNEWPgJ+luAZLIvSQC4rg0aaYiLpDTRVRdAOrMDr6/gigrEXrufsq2/IS4VosDWyp3Tc24ZYYJ489ghC0cSWSa10a3ZTYf866BYbY6GdaViXWHT/TMmKzkKml7BfbXfLYNUzawl2oCj+eBF3y99Z7N06nLW9jDdZkInC9CebqmG15nuAeWr41H36AtYolzExfHB5/6mLpEeVplByN0Xe4udHcrJ+iNEHwo8e6UNtM7WFEDjkh7NJGwyNoaDVe15/TQ5XdPm1IPz0mnw8VjKJ1da4/SMXhq7bjrRKrAqNRTndUgQZYj14huRCc0v8RKcIfMqtO3FbxVWUnO9znHpRSC9mRzYMpPpk/+6H89N1AeIfCe9fjHV8QVdVR2GdukNxsn+5ln1oJaCEmSPrQKiJvVQY1vnarK5KizrUt5IS7uiq1GJiOFwKVmJcsSKOgRkAdWw8wr4ZSwGqx8mkjb/z0KEGkW2RlEGVTjHEQ9Ae+rbOkL50uvp7Z2JtKtY6epo23SMgMeyYxEh2j8piJtq0beiU7G47roXglrMygCs88P5wof2fyZnsY3pb58Bc0K0sceZlcbgN7Rym3rSYdO+zGfSLcNvnj3HRhBB2BloSPIjpx2m2vrbV/LvkZqLa83brcFZrxotLmJv+J5qbDYALsyyeaEqlhLr7dbof6kEAU1M89bepWPSNoCgPHbiJqJS7vO5ekoI14685ZV1kVxYGfIoyw+OO+Mq5TmjOfUAvqgmbUTdDW4YWx49GD288bugbuq/018oGd8hApHevLGT0SwrnQTUXznRANPG99r7bMZ7JGy/hMks3zByBSKMd5rK/RTz+aISEAZ7G/Pxm2RFfLQrtXO5dry0Lu//bim2/2ATY1izqVpoypXd581IdoXamfB8dPi+ZsI2jEhVK6Rpe0OSDcMjHqmjRNg5oCeHAgpnEYcIRH7z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/24/25 06:35, Harry Yoo wrote:
> On Mon, Dec 22, 2025 at 09:23:17PM -0800, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    9094662f6707 Merge tag 'ata-6.19-rc2' of git://git.kernel...
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1411f77c580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=a11e0f726bfb6765
>> dashboard link: https://syzkaller.appspot.com/bug?extid=b165fc2e11771c66d8ba
>> compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11998b1a580000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=128cdb1a580000
>>
>> Downloadable assets:
>> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-9094662f.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/5bec9d32a91c/vmlinux-9094662f.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/3df82e1a3cec/bzImage-9094662f.xz
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com
>>
>>   handle_mm_fault+0x3fe/0xad0 mm/memory.c:6580
>>   do_user_addr_fault+0x60c/0x1370 arch/x86/mm/fault.c:1336
>>   handle_page_fault arch/x86/mm/fault.c:1476 [inline]
>>   exc_page_fault+0x64/0xc0 arch/x86/mm/fault.c:1532
>>   asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
>> ------------[ cut here ]------------
>> WARNING: ./include/linux/rmap.h:462 at __folio_rmap_sanity_checks include/linux/rmap.h:462 [inline], CPU#1: syz.0.18/6090
>> WARNING: ./include/linux/rmap.h:462 at __folio_remove_rmap mm/rmap.c:1663 [inline], CPU#1: syz.0.18/6090
>> WARNING: ./include/linux/rmap.h:462 at folio_remove_rmap_ptes+0xc27/0xfb0 mm/rmap.c:1779, CPU#1: syz.0.18/6090
>> Modules linked in:
>> CPU: 1 UID: 0 PID: 6090 Comm: syz.0.18 Not tainted syzkaller #0 PREEMPT(full)
>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
>> RIP: 0010:__folio_rmap_sanity_checks include/linux/rmap.h:462 [inline]
>> RIP: 0010:__folio_remove_rmap mm/rmap.c:1663 [inline]
>> RIP: 0010:folio_remove_rmap_ptes+0xc27/0xfb0 mm/rmap.c:1779
>> Code: 00 e9 49 f4 ff ff e8 a8 35 aa ff e8 c3 55 17 ff e9 98 fc ff ff e8 99 35 aa ff 48 c7 c6 80 b7 9c 8b 4c 89 e7 e8 8a 12 f5 ff 90 <0f> 0b 90 e9 5a f6 ff ff e8 7c 35 aa ff 48 8b 54 24 10 48 b8 00 00
>> RSP: 0018:ffffc90003f5f260 EFLAGS: 00010293
>> RAX: 0000000000000000 RBX: ffffea0001417f80 RCX: ffffc90003f5f144
>> RDX: ffff88803368c980 RSI: ffffffff8214b106 RDI: ffff88803368ce04
>> RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
>> R10: 0000000000000001 R11: ffff88803368d4b0 R12: ffffea0001417f80
>> R13: ffff888030c90500 R14: 0000000000000000 R15: ffff888012660660
>> FS:  00007f98fd3fe6c0(0000) GS:ffff8880d69f5000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007f98fd3ddd58 CR3: 000000003661c000 CR4: 0000000000352ef0
>> Call Trace:
>>   <TASK>
>>   zap_present_folio_ptes mm/memory.c:1650 [inline]
>>   zap_present_ptes mm/memory.c:1708 [inline]
>>   do_zap_pte_range mm/memory.c:1810 [inline]
>>   zap_pte_range mm/memory.c:1854 [inline]
>>   zap_pmd_range mm/memory.c:1946 [inline]
>>   zap_pud_range mm/memory.c:1975 [inline]
>>   zap_p4d_range mm/memory.c:1996 [inline]
>>   unmap_page_range+0x1b7d/0x43c0 mm/memory.c:2017
>>   unmap_single_vma+0x153/0x240 mm/memory.c:2059
>>   unmap_vmas+0x218/0x470 mm/memory.c:2101
> 
> So this is unmapping VMAs, and it observed an anon_vma with refcount == 0.
> anon_vma's refcount isn't supposed to be zero as long as there's
> any anonymous memory mapped to a VMA (that's associated with the anon_vma).
> 
>  From the page dump below, we know that it's been allocated to a file VMA
> that has anon_vma (due to CoW, I think).
> 
>> [   64.399049][ T6090] page: refcount:2 mapcount:1 mapping:0000000000000000 index:0x0 pfn:0x505fe
>> [   64.402037][ T6090] memcg:ffff888100078d40
>> [   64.403522][ T6090] anon flags: 0xfff0800002090c(referenced|uptodate|active|owner_2|swapbacked|node=0|zone=1|lastcpupid=0x7ff)
>> [   64.407140][ T6090] raw: 00fff0800002090c 0000000000000000 dead000000000122 ffff888012660661
>> [   64.409851][ T6090] raw: 0000000000000000 0000000000000000 0000000200000000 ffff888100078d40
>> [   64.412578][ T6090] page dumped because: VM_WARN_ON_FOLIO(atomic_read(&anon_vma->refcount) == 0)
>> [   64.415320][ T6090] page_owner tracks the page as allocated
>> [   64.417353][ T6090] page last allocated via order 0, migratetype Movable, gfp_mask 0x140cca(GFP_HIGHUSER_MOVABLE|__GFP_COMP), pid 6091, tgid 6089 (syz.0.18), ts 64395709171, free_ts 64007663612
>> [   64.422891][ T6090]  post_alloc_hook+0x1af/0x220
>> [   64.424399][ T6090]  get_page_from_freelist+0xd0b/0x31a0
>> [   64.426135][ T6090]  __alloc_frozen_pages_noprof+0x25f/0x2430
>> [   64.427958][ T6090]  alloc_pages_mpol+0x1fb/0x550
>> [   64.429506][ T6090]  folio_alloc_mpol_noprof+0x36/0x2f0
>> [   64.431157][ T6090]  vma_alloc_folio_noprof+0xed/0x1e0
>> [   64.433173][ T6090]  do_fault+0x219/0x1ad0
>> [   64.434586][ T6090]  __handle_mm_fault+0x1919/0x2bb0
>> [   64.436396][ T6090]  handle_mm_fault+0x3fe/0xad0
>> [   64.437985][ T6090]  __get_user_pages+0x54e/0x3590
>> [   64.439679][ T6090]  get_user_pages_remote+0x243/0xab0
> 
> woohoo, this is faulted via GUP from another process...
> 
>> [   64.441359][ T6090]  uprobe_write+0x22b/0x24f0
>> [   64.442887][ T6090]  uprobe_write_opcode+0x99/0x1a0
>> [   64.444496][ T6090]  set_swbp+0x112/0x200
>> [   64.445793][ T6090]  install_breakpoint+0x14b/0xa20
>> [   64.447382][ T6090]  uprobe_mmap+0x512/0x10e0
>> [   64.448874][ T6090] page last free pid 6082 tgid 6082 stack trace:
>> [   64.450887][ T6090]  free_unref_folios+0xa22/0x1610
>> [   64.452536][ T6090]  folios_put_refs+0x4be/0x750
>> [   64.454064][ T6090]  folio_batch_move_lru+0x278/0x3a0
>> [   64.455714][ T6090]  __folio_batch_add_and_move+0x318/0xc30
>> [   64.457810][ T6090]  folio_add_lru_vma+0xb0/0x100
>> [   64.459416][ T6090]  do_anonymous_page+0x12cf/0x2190
>> [   64.461066][ T6090]  __handle_mm_fault+0x1ecf/0x2bb0
>> [   64.462706][ T6090]  handle_mm_fault+0x3fe/0xad0
>> [   64.464562][ T6090]  do_user_addr_fault+0x60c/0x1370
>> [   64.466676][ T6090]  exc_page_fault+0x64/0xc0
>> [   64.468067][ T6090]  asm_exc_page_fault+0x26/0x30
>> [   64.469661][ T6090] ------------[ cut here ]------------
> 
> BUT unfortunately the report doesn't have any information regarding
> _when_ the refcount has been dropped to zero.
> 
> Perhaps we want yet another DEBUG_VM feature to record when it's been
> dropped to zero and report it in the sanity check, or... imagine harder
> how a file VMA that has anon_vma involving CoW / GUP / migration /
> reclamation could somehow drop the refcount to zero?
> 
> Sounds fun ;)
> 

Can we bisect the issue given that we have a reproducer?

This only popped up just now, so I would assume it's actually something 
that went into this release that makes it trigger.

-- 
Cheers

David

