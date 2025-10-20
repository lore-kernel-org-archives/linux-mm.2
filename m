Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D903FCCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 06:43:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B4518E0005; Mon, 20 Oct 2025 02:43:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 265898E0003; Mon, 20 Oct 2025 02:43:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17B2F8E0005; Mon, 20 Oct 2025 02:43:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 056BA8E0003
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 02:43:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6B9E7140777
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:43:16 +0000 (UTC)
X-FDA: 84017550792.22.6ECAA0C
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	by imf03.hostedemail.com (Postfix) with ESMTP id A4DAC2000C
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:43:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of 3Adr1aAkbANoOUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=3Adr1aAkbANoOUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760942594; a=rsa-sha256;
	cv=none;
	b=krkiD6tbZwXKQGWBss33Vp/lw93btWNYw6KY4QoZzM1XKXzONIuVx3gd56N33+mr7cCkrH
	qXQxS62xM9Ztihe1GTebOiq1zfsQ2IsuyyvAMvottC7+OfGoIt2m2B3eJskTk0vPH+sgUZ
	CK0WVZeBAgVtmfm+8FFs/ltclEqwnfA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of 3Adr1aAkbANoOUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=3Adr1aAkbANoOUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760942594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=HqrCkr2sjCfBLL7q9AdHaNdtwcieYGi6wC0wgKB8odU=;
	b=y14mUiSoSsRtyDmMHo8dBJYOXp72QvPqqKW8H1CQuAsuzeHtDbfAHvi/a6FGwyDP2N47Ty
	AdYP5MI5yJw2+S0VmbnV0V+WusrWMJ23tiXCSk0KR5iumWgmJszh3RW/AvyQlk3b/fzHXw
	h5cVZcu7A0DVlTQhhVF8nV8QOT1QFp0=
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-429278a11f7so43229205ab.1
        for <linux-mm@kvack.org>; Sun, 19 Oct 2025 23:43:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760942593; x=1761547393;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HqrCkr2sjCfBLL7q9AdHaNdtwcieYGi6wC0wgKB8odU=;
        b=rXx87ttmKXwiG5JZ2cVCBqGoT8OQhQngMITTj4BiQl7p9yjTMmMTZ9tsT4Qv3PiY+k
         4bStThVjHEbf0BW3Ro8/Sjtfq9QeaBZYrFYk26Kv5JzE81NJJyaF3UeLLQ/kLV/Q3h+U
         niUTMvIB6UHSHY2GO6wucXL3HB98dO/yHAq8mozaYP5RQCqKA9doENEZcpYkVitQodZF
         gg5BdJxz47WwfPIGYvzuII3HNI7XL8PAfwEU7RPU/9N3rgFFQHqC0CCUR8qJJnUKggWJ
         0hFqkvf2wNfkWGoZAKJ1W+l/ll49USnMfAZrvr7nD7mtI0glwZdC/m2vKx+9umns6jKd
         1taw==
X-Forwarded-Encrypted: i=1; AJvYcCUzGEyl3XT9BFlLLbaDXwRYg40U3q1KNvKLrRotCPCfxcJlhgvwjfNiF1LYiI50135Q9MjYYB2zPA==@kvack.org
X-Gm-Message-State: AOJu0YzQ1m+nFneOnWBTknTvwiepDDXZsR8QoZ/I4GkfZiaLUNwQEjzd
	knHTXHMYQjWjMaSmMpDjC3gielBJjsg6jV9A5vHUB8unjJxQkfM84C7b8WvD3YAOir0q9hj3g+r
	MXHU063yDk9lkP4nr9OB/dW0v4oqhxQhiuNefjcyXSysL/7Cj83EmkcazTZM=
X-Google-Smtp-Source: AGHT+IFIz8Mu/jwsmlKZvzPM/2PEC3SH2VPM/vNb6A+2t3BVkUwtQATCp/9khxbUgmnGmEy2M1TnTZY5OES4n+QzTGnMT43WoKgg
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1687:b0:940:d7b0:e766 with SMTP id
 ca18e2360f4ac-940d7b0e8camr393999339f.16.1760942593629; Sun, 19 Oct 2025
 23:43:13 -0700 (PDT)
Date: Sun, 19 Oct 2025 23:43:13 -0700
In-Reply-To: <20251020001652.2116669-1-willy@infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f5da01.050a0220.91a22.043f.GAE@google.com>
Subject: [syzbot ci] Re: Separate ptdesc from struct page
From: syzbot ci <syzbot+cia36a04b74f498e9d@syzkaller.appspotmail.com>
To: hannes@cmpxchg.org, linux-mm@kvack.org, vishal.moola@gmail.com, 
	willy@infradead.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: krxc5jo7f3e76ruk5omkz67zdingrxd6
X-Rspamd-Queue-Id: A4DAC2000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1760942594-1872
X-HE-Meta: U2FsdGVkX1+awschX7M9KV5BmiVBd6AOJ3kY5dTVXLuqQyhRITUkdUFnlw9yeTORr/mKfhBrkUUdy1r9i0K/UHEBu+GTyScffiSCBE8qk8etDJw7YHHYyMBNbIh7QBi3YhTKGhEBp2vrXoo0OfC2lq2QMri+OYicwkUh7PxhGOWClCdRkat6QnY+8qIEize7KnBhYI11PL67vA9neUqqgwffzB/CiRdkJXcA3vskl2MEf6CicIT6oM+XkxE6QAUTxbOcGk20xODjlidXx4cz6l5AwWwjZzONL1Xr9TVJvpR6+MBj8OsufcLnuFsTnVAQczOGo+LOz4gpXhV3mL0FC2LY7LIDNEWY7rOyiAIMkRuOzNdlX8zgwAldU8+s0gwfU55N4Cxp9/yVBsjtOpQZQlEN24npstFn1fZCYA9jHCR7oacNV5ZRfwH79FNo7hjgfJ8chtjvUPunH7MfMnwsCNaF0Kbse2QY1TbU7ssKmDp7+nrfSqMfut1nKeJTLztNfefNJmaf7vuJ+4fF+2eD5X1dWNiChOTdk3CkCzQXYhizJ6BhNeyl+cDcsX3UXPUetleGCdaF/uuIa1FZNi5tYe2M04rvI5Ttx7YZLUfEYb1kVEXUv2hWJfUYsinFEmRKhw8jutZh5y4WBueKGE4ZpUJ/2CALF2giHwWMY+Uv1w+6SBlFnmcjptTWcEIq1b3FIkkkFCUX+NrIbYsQbUSqOforGCS18tnwC4xD3CrSCRpWxE6ZMMM6nV7Zwy0DUTYmaHEMIJ9HByXlI38ski23RNU87QKfRxF3kpfiVtqGDX+mDYUISyE60fxCMDHaVW/CwtYa7WqPm6yYWQC0aUQJH+/AohuXOU0VEEJxcHPGxFiWcEV9/CThE/kHd/B/wk1tIrPd3Vvfef6Xu/mRzv0uEt0srqufxS32LM9W8auTiNESloX6S718k2jCEGZUI4dpycYzXHRkFOQjHPjl1Uf
 1jX5f3OW
 d9zdFGoS3nm9chmg1BVZvlLcZjvIp9GEMpAPTV16t/xQyRG4W1fLXdoxLObuy48cKXQ81POmtEFMXLGSOQqYU4NauRTZyr/4jn+CiC7o3QXwdRNQH3eFDfvwaoyjYg/saMlaI7gotkFdTSKJyXbwe3jnqOxsfOmF9fTay6dy3a5syiYoLLnNaNOuzTV8zBkF8ZeKI/TA7hvt1IjmsAZw2BSwDAl7vSP8jDZgV72iOPC0kxvi5ehTDrtlTTeIKHRIqWJL/AsY6I1YbiP0rMWcsL1pHRaanFogiQDcDs9HffK3tYHp/rsKMQNgs+JVX+kReaYXMimgqf8a+76y4XgYa4EqzlcWEtn3gAW5oXe+iU8NcfcpD4BsIJmRHb0zXaj4//qjTS1Ufwy3JgKvYiJuNM9oP3jRCYpeT+b2wkjesVIROndW9Wd5xDP9JkSBRQicHCdjrVBDr6lzwLIlUdhvpnsFZg4WhqDzDS5LCsAHNCwv1yJmFf4t3euAQkL68hXc0vpJI9XurXqdR0k47OZiVt0a/7ydjDGIhpkqaJfuO0gF91vAJHiXyRWMWR0aSsbEwaFxdm9kmaA0ntWZ/O+LhoeDHoyyLxcs0b4RW9wjW49CSBrji3Nah89wFlOPTUulM+zio50V4TxS5cJAIMK/EOJG+5ksjYJ/8BdKQ3JunnikCePunEAREqRi+cTFoCkmnfgx9CVXBrsGYFBTIG9h1ltbikFnJFJqcvMWNl1nn24UceiVYoNHdFZoRadAsLkfDMPXcPgajs4YZBt1BnOExbD0Q3qeulgmlAH0/5hKzQxOACf8y9JXBXndwwspUMrMqP4E2Q63Kjeb7F/V1Dub//bPqFTUjnTC4YobYihHOcTGazFpNXlYzA4lpUlHpb1cOGwWv6xCaA/XVwO/eLKOOmr6WnzGh9NBMuFvNQBUyVYTr5X6XtKpWq5onR5TZCYxgfCUuMsDAztnf0AZoP+zCls1uVObY
 kffmLu4B
 MwjOTfTcqvAuT9R4z6mFmSSGjakB70Cuj2KC5Lh9i6H0GcvTJlZvV+4lfRvQ4vFetzsp07qOVA1LkrWvuNwtHvjZZvmynDhEG2w2EgEgAnH4QA4cvy/+NPJatledD2F4ZqGJD8M6PXs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] Separate ptdesc from struct page
https://lore.kernel.org/all/20251020001652.2116669-1-willy@infradead.org
* [RFC PATCH 1/7] mm: Use frozen pages for page tables
* [RFC PATCH 2/7] mm: Account pagetable memory when allocated
* [RFC PATCH 3/7] mm: Mark pagetable memory when allocated
* [RFC PATCH 4/7] pgtable: Remove uses of page->lru
* [RFC PATCH 5/7] x86: Call preallocate_vmalloc_pages() later
* [RFC PATCH 6/7] mm: Add alloc_pages_memdesc family of APIs
* [RFC PATCH 7/7] mm: Allocate ptdesc from slab

and found the following issue:
kernel BUG in pte_free_now

Full report is available here:
https://ci.syzbot.org/series/034eb8df-67a6-4c07-8ba5-3ac0df045a40

***

kernel BUG in pte_free_now

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      3a8660878839faadb4f1a6dd72c3179c1df56787
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/2cf2c360-080f-4864-9be9-e277d29fc594/config
syz repro: https://ci.syzbot.org/findings/1f85642a-695a-4b8d-a5ee-b95a5105cc53/syz_repro

 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:723
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1052 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1052
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
------------[ cut here ]------------
kernel BUG at ./include/linux/mm.h:2959!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 6093 Comm: syz.1.54 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:page_ptdesc include/linux/mm.h:2959 [inline]
RIP: 0010:pte_free include/asm-generic/pgalloc.h:115 [inline]
RIP: 0010:pte_free_now+0xc2/0xd0 mm/pgtable-generic.c:249
Code: 48 89 df e8 20 d1 13 00 48 8b 13 48 c7 c7 c0 89 76 8b 4c 89 f6 e8 6e 66 15 ff 4c 89 ff 48 c7 c6 00 8a 76 8b e8 1f c3 15 ff 90 <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90
RSP: 0018:ffffc90000007bb0 EFLAGS: 00010246
RAX: de62a9f92d629d00 RBX: ffffea0005ca91e0 RCX: de62a9f92d629d00
RDX: 0000000000000002 RSI: ffffffff8d9d1d2d RDI: ffff8881127ad700
RBP: ffffc90000007e30 R08: ffffc90000007567 R09: 1ffff92000000eac
R10: dffffc0000000000 R11: fffff52000000ead R12: dffffc0000000000
R13: ffffffff81a82b37 R14: 0000000000000000 R15: ffffea0005ca91c0
FS:  00007f66c98976c0(0000) GS:ffff88818e70c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f66c9896fc8 CR3: 0000000112a72000 CR4: 00000000000006f0
Call Trace:
 <IRQ>
 rcu_do_batch kernel/rcu/tree.c:2605 [inline]
 rcu_core+0xcab/0x1770 kernel/rcu/tree.c:2861
 handle_softirqs+0x286/0x870 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:723
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1052 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1052
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:clear_page_rep+0xe/0x20 arch/x86/lib/clear_page_64.S:23
Code: cc cc cc cc cc cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa b9 00 02 00 00 31 c0 f3 48 ab <e9> 8d 46 04 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc90003cb76d0 EFLAGS: 00000246
RAX: 0000000000000000 RBX: fffa800000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880123a2000
RBP: fffa8000123a1000 R08: ffffea000048e847 R09: 1ffffd4000091d08
R10: dffffc0000000000 R11: fffff94000091d09 R12: 0000000000000000
R13: 1ffffffff1b404a6 R14: 1ffffffff1b404a4 R15: 0000000000000000
 clear_page arch/x86/include/asm/page_64.h:54 [inline]
 clear_highpage include/linux/highmem.h:240 [inline]
 shmem_get_folio_gfp+0xaad/0x1660 mm/shmem.c:2583
 shmem_fault+0x179/0x390 mm/shmem.c:2734
 __do_fault+0x138/0x390 mm/memory.c:5280
 do_read_fault mm/memory.c:5698 [inline]
 do_fault mm/memory.c:5832 [inline]
 do_pte_missing mm/memory.c:4361 [inline]
 handle_pte_fault mm/memory.c:6177 [inline]
 __handle_mm_fault+0x35e3/0x5400 mm/memory.c:6318
 handle_mm_fault+0x40a/0x8e0 mm/memory.c:6487
 faultin_page mm/gup.c:1126 [inline]
 __get_user_pages+0x165c/0x2a00 mm/gup.c:1428
 populate_vma_page_range+0x29f/0x3a0 mm/gup.c:1860
 __mm_populate+0x24c/0x380 mm/gup.c:1963
 mm_populate include/linux/mm.h:3451 [inline]
 vm_mmap_pgoff+0x387/0x4d0 mm/util.c:586
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f66c898efc9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f66c9897038 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 00007f66c8be6090 RCX: 00007f66c898efc9
RDX: b635773f06ebbeef RSI: 0000000000b36000 RDI: 0000200000000000
RBP: 00007f66c8a11f91 R08: ffffffffffffffff R09: 00000000e9ba1000
R10: 0000000000008031 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f66c8be6128 R14: 00007f66c8be6090 R15: 00007ffcfaf828b8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:page_ptdesc include/linux/mm.h:2959 [inline]
RIP: 0010:pte_free include/asm-generic/pgalloc.h:115 [inline]
RIP: 0010:pte_free_now+0xc2/0xd0 mm/pgtable-generic.c:249
Code: 48 89 df e8 20 d1 13 00 48 8b 13 48 c7 c7 c0 89 76 8b 4c 89 f6 e8 6e 66 15 ff 4c 89 ff 48 c7 c6 00 8a 76 8b e8 1f c3 15 ff 90 <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90
RSP: 0018:ffffc90000007bb0 EFLAGS: 00010246
RAX: de62a9f92d629d00 RBX: ffffea0005ca91e0 RCX: de62a9f92d629d00
RDX: 0000000000000002 RSI: ffffffff8d9d1d2d RDI: ffff8881127ad700
RBP: ffffc90000007e30 R08: ffffc90000007567 R09: 1ffff92000000eac
R10: dffffc0000000000 R11: fffff52000000ead R12: dffffc0000000000
R13: ffffffff81a82b37 R14: 0000000000000000 R15: ffffea0005ca91c0
FS:  00007f66c98976c0(0000) GS:ffff88818e70c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f66c9896fc8 CR3: 0000000112a72000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	cc                   	int3
   1:	cc                   	int3
   2:	cc                   	int3
   3:	cc                   	int3
   4:	cc                   	int3
   5:	cc                   	int3
   6:	cc                   	int3
   7:	cc                   	int3
   8:	cc                   	int3
   9:	cc                   	int3
   a:	cc                   	int3
   b:	cc                   	int3
   c:	90                   	nop
   d:	90                   	nop
   e:	90                   	nop
   f:	90                   	nop
  10:	90                   	nop
  11:	90                   	nop
  12:	90                   	nop
  13:	90                   	nop
  14:	90                   	nop
  15:	90                   	nop
  16:	90                   	nop
  17:	90                   	nop
  18:	90                   	nop
  19:	90                   	nop
  1a:	90                   	nop
  1b:	90                   	nop
  1c:	f3 0f 1e fa          	endbr64
  20:	b9 00 02 00 00       	mov    $0x200,%ecx
  25:	31 c0                	xor    %eax,%eax
  27:	f3 48 ab             	rep stos %rax,%es:(%rdi)
* 2a:	e9 8d 46 04 00       	jmp    0x446bc <-- trapping instruction
  2f:	90                   	nop
  30:	90                   	nop
  31:	90                   	nop
  32:	90                   	nop
  33:	90                   	nop
  34:	90                   	nop
  35:	90                   	nop
  36:	90                   	nop
  37:	90                   	nop
  38:	90                   	nop
  39:	90                   	nop
  3a:	90                   	nop
  3b:	90                   	nop
  3c:	90                   	nop
  3d:	90                   	nop
  3e:	90                   	nop
  3f:	90                   	nop


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

