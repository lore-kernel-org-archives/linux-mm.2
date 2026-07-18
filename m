Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D424C4451B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 14:41:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D0EC6B007B; Sat, 18 Jul 2026 10:41:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35A2A6B0088; Sat, 18 Jul 2026 10:41:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 271B06B0092; Sat, 18 Jul 2026 10:41:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0FC46B007B
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 10:41:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 60E2940452
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 14:41:14 +0000 (UTC)
X-FDA: 85002160068.29.6AEDE57
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9EBD0120005
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 14:41:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QZ76ERXN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784385672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+z+H4leLiOLRAPj1zKzpTJK7yHucKt+8tLj4TVPgNos=;
	b=cVB4vLY01ziE8+8SdZOCovEdKulRrLct7d3Aut2xRJCBY9mRkG5vnQIB5urB9jarHwBfI1
	nGpWXBzOW9tt6pAvOOPjM8Cf+qLruKrx6X4O+TWS/uYpvRQpkb+2q/2Ayo9etmQztUYAaf
	f49a1ZvNpCzIoo1Me8KdU7eSP3HIyek=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QZ76ERXN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784385672;
	b=75MgNce4Nn7Qww2fAV93QyNxwQVl8iG0nZg6CXcZGTvwwK7ebNpIBc13t0rafbK44yRhpy
	C03ZESheLqznY3DyDEBJRRt36ttUWXgeYeamkKKLhn1MrsUDgKWCHAEM53G4sfOLxWdppb
	SDUAaCfqavGBk0BIklzoCyJJZnKWvyY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 91697409A4;
	Sat, 18 Jul 2026 14:41:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3591F000E9;
	Sat, 18 Jul 2026 14:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784385671;
	bh=+z+H4leLiOLRAPj1zKzpTJK7yHucKt+8tLj4TVPgNos=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QZ76ERXN3CqNkTHz6lrgB9bhhRA0s5Tfsivc+Rts46JJM2WYSf86KNqfagabPVKzH
	 7tNmHik+ed/ZUJ+8j+C1xL9ntaIRa+mEajpgW3/gFUw0Kjav2mYRae0K8971srxjFt
	 BKJ153gUQIIx1G7Ec2Cl1Zh03VJ1TeY6KlnIzVE3decfMgOryoz87ndGv2RjRFxzNc
	 O2tyhUsRk00UkENWYHukI+cRdh5lscn9Dg4b7Ylfkhsicel9xiIWweapWJDB1aozQR
	 Nlp/VKyBTeNcUh0TbO8ktGceFqhf6CauVQgo3KkMezvJBpOtNrQB1FQfMW8TxXk1qM
	 YPuwg7GYYO2MQ==
Date: Sat, 18 Jul 2026 15:40:48 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: syzbot ci <syzbot+ci64ff753c2913b080@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, arnd@arndb.de, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	chengming.zhou@linux.dev, david@kernel.org, dev.jain@arm.com, gourry@gourry.net, 
	gregkh@linuxfoundation.org, harry@kernel.org, jack@suse.cz, jannh@google.com, 
	joshua.hahnjy@gmail.com, kees@kernel.org, lance.yang@linux.dev, liam@infradead.org, 
	linmiaohe@huawei.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, mhocko@suse.com, 
	nao.horiguchi@gmail.com, npache@redhat.com, peterx@redhat.com, pfalcato@suse.de, 
	rakie.kim@sk.com, riel@surriel.com, rppt@kernel.org, ryan.roberts@arm.com, 
	surenb@google.com, usama.arif@linux.dev, vbabka@kernel.org, willy@infradead.org, 
	xu.xin16@zte.com.cn, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: mm/rmap: index MAP_PRIVATE file-backed folios by
 virt pgoff
Message-ID: <aluP2cYA4dPVLdZ8@lucifer>
References: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
 <6a5b2176.5028b7d0.1f0bb.00e1.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a5b2176.5028b7d0.1f0bb.00e1.GAE@google.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9EBD0120005
X-Stat-Signature: 48nnexqug59niga3w4uwyn4pmdfdb4jk
X-Rspam-User: 
X-HE-Tag: 1784385672-543310
X-HE-Meta: U2FsdGVkX18c5fQ6F37p51T7BLz8k+EWphSarHwRNWKfaw667UimqvPG7oXPt3V7fQ3hmr0aiOVItwHr2Sx2q3sCLfHpFzbF5xuN3JqW3zNypnUqem+fVj1tJI6v8qcnVBN1p/1/06Y11SVf/TKnOav04QjT58yvpRe/o8t1fyaPwNGP+jJnsKey/K6Ikkf/nL+o+sk3vK9unxXWlOtUkhkfENFbEEbVWdL4GnIGg93CZQGEcD7SA74pXaMVliegWP5nYC4hAqtNe1tnYSPJsEVOvM+Vr4BzlhkhXYZILrfvjATud+l7fROR4ji6IqbVArgPGpttELHExRGdMsihXiTCZlJ1caLi1hpFs4gewk+38P11TmNXMySpBrjqb6nb/28RuweW75YJeW0Q7pqhWEMtDVLqYXGQGO/VnYVFYIZ8a2evMkTkclwkWo7h4pC+obQRqnuMkB3cqa0wK/r59M36My9So9s09Qlf6gSo9YRA7YREEIXReioWi6Y5otKHS1qhsmcwz21Y/+GOGtABv8jSL8XH0pZl5npqW8dGQJqoGamVzUqNcCzMdCmgxrlKKtYKCZW0zNtuWGzw3JR6JXEwZr4Zwe94HTo0ojzjWlsUuZmi7E6eVA1k3PPGIHoAYlPtaJ5orePBc3mtha0MdSTHMsMzO69rgBdQHJfa9mCx+flybk1/Y79sKOoAapptdVrchNV2D2VAOjf9MlVctBRW59s4zs+FbvBMUuwzK6ibkPxqZH3dDu6OqBlxbEZVBiEZFMncUD64wKbfIzsqStGXuMHE8QzGVFgQwq/CliRi4Hr2BDzYY6zKc0ePNNsyv997m6jZLToPgYxIg+adEbGtjSkFUyOzEEb0c6VzSm9Dy6CKPIh2AFpB3pRXLHVC06IHn2V7zFRstwHHBZr5LyKnwitWKqnGkrMn4K5sr26f3peU/fhMDnHUo/eZCd1IfUVgfBari+RPHvHKe8k
 3AjUo55N
 O6AUi4lX3BRUxJrahbOgSvZeb//hlerr9mi2vR8pOxW0ruD5WKowpWXUsTdRBj6r0u10oSgw9hxToVYu93RZx5wf/KDfeK2emdYaLxWGniKhpgpo80F6r+7a4E+EuKgZkXPL8p+6o7wT6NpLdzuP9RxSDNIzS4TKcwDw8GB40m6IhYDSJgIVy+8cAex8uo8ja7HhuHiEeoNjHhtMIn4CNRvUSpPAb/BnOLYNFHrKvm85l/8iLdiI9KEc0o4TwjRqLhN0yR2I+AZ+Qfuj/otYSQg1DJe5dVwdPEmF8L6P1+3xUtCVtJvKpkx4vLO6dQNMl0t0bn8v3B9xVToEoYCrPQu6LTohCthsLsa4jtuJL8lSFPVHq80ogO/iHaQcVpNC7Xst+Eh1BES//ghWylzVSEyl7UFv9F4bmrSXvkFniG5mLBqt87rR2vTz56aK970U0hxxl6eWYlfgwrR08V8Ix0Qm13fZXi17KOesJl17w8mcHYDq2EtN6RCasxt8LO1olzwVMrjZWSSRrZyX2q7KSHsg+AV8xhP1wYy7OEUvJQAahHc1W8QP5hj+ak1uO7+Om3wUltbKd2ItTdrlR7wb1NdBSulkxegLRXJFHbm7PNQLZuBNpkNfMk2SsoyYxkxPKj5V0KGaUSeYm7dQeyFpQpWjOAG78B1hAMMQ7+1vwcwkaQcHnbJc/dX1fdA7AJuweHCGN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 11:47:18PM -0700, syzbot ci wrote:
> syzbot ci has tested the following series
>
> [v1] mm/rmap: index MAP_PRIVATE file-backed folios by virt pgoff
> https://lore.kernel.org/all/20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org
> * [PATCH 01/15] mm/vma: introduce VMA virtual page offset field and add helpers
> * [PATCH 02/15] mm: introduce linear_virt_page_index()
> * [PATCH 03/15] mm: abstract vma_address() and introduce vma_anon_address()
> * [PATCH 04/15] mm: update print_bad_page_map() to show virtual page index
> * [PATCH 05/15] mm: introduce and use vma_filebacked_address()
> * [PATCH 06/15] mm: propagate VMA virtual page offset on map, remap, split + merge
> * [PATCH 07/15] mm/rmap: track whether the page VMA mapped walk is anonymous
> * [PATCH 08/15] mm: introduce and use linear_folio_page_index()
> * [PATCH 09/15] mm/rmap: use virt pgoff for MAP_PRIVATE file-backed anon folios
> * [PATCH 10/15] tools/testing/vma: expand VMA merge tests to assert virt pgoff
> * [PATCH 11/15] tools/testing/selftests/mm: test virtual page offset merge behaviour
> * [PATCH 12/15] mm/vma: only permit MAP_PRIVATE /dev/zero to be mapped anonymous
> * [PATCH 13/15] mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings truly anonymous
> * [PATCH 14/15] tools/testing/vma: add test to assert MAP_PRIVATE-/dev/zero is anon
> * [PATCH 15/15] tools/testing/selftests/mm: add MAP_PRIVATE-/dev/zero merge tests
>
> and found the following issue:
> general protection fault in mapping_wrprotect_range_one
>
> Full report is available here:
> https://ci.syzbot.org/series/b5c827e8-78a4-494c-b925-417c34a60e85
>
> ***
>
> general protection fault in mapping_wrprotect_range_one
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
> base:      5093dba1014c1d7f7e247fd118f0fa8f22136046
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/0d856612-f1b4-4e6e-86af-4ed3215225aa/config
> syz repro: https://ci.syzbot.org/findings/3484dc14-c12f-477e-b14a-6b249c47b2fd/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
> CPU: 1 UID: 0 PID: 32 Comm: kworker/1:1 Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> Workqueue: events fb_deferred_io_work
> RIP: 0010:folio_test_anon include/linux/page-flags.h:718 [inline]
> RIP: 0010:mapping_wrprotect_range_one+0x147/0x230 mm/rmap.c:1246

Ah yeah, this is:

	VM_WARN_ON_ONCE(folio_test_anon(folio));

In mapping_wrprotect_range_one() and... this test is completely superfluous
actually :)

The only caller is mapping_wrprotect_range() which literally passes a NULL folio
NULL to __rmap_walk_file() (with mapping_wrprotect_range_one set as the
rwc->rmap_one).

I'll ping on the relevant commit and ask Andrew to just drop this line.

Cheers, Lorenzo

> Code: 7c 24 40 49 8d 7f 28 ba 18 00 00 00 31 f6 e8 e0 2e 14 00 48 c7 84 24 80 00 00 00 01 00 00 00 49 83 c6 18 4c 89 f0 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 f7 e8 ea 2b 14 00 4d 8b 36 44 89 f6 83
> RSP: 0018:ffffc90000a777c0 EFLAGS: 00010206
> RAX: 0000000000000003 RBX: ffffc90000a779e0 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90000a77840
> RBP: ffffc90000a778e0 R08: ffffc90000a7783f R09: 0000000000000000
> R10: ffffc90000a77828 R11: fffff5200014ef08 R12: dffffc0000000000
> R13: 1ffff9200014eefc R14: 0000000000000018 R15: ffffc90000a77800
> FS:  0000000000000000(0000) GS:ffff8882a920c000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f84a91e9c38 CR3: 000000000e746000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __rmap_walk_file+0x4cd/0x6a0 mm/rmap.c:3116
>  mapping_wrprotect_range+0x110/0x180 mm/rmap.c:1294
>  fb_deferred_io_work+0x15a/0x310 drivers/video/fbdev/core/fb_defio.c:399
>  process_one_work kernel/workqueue.c:3322 [inline]
>  process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:folio_test_anon include/linux/page-flags.h:718 [inline]
> RIP: 0010:mapping_wrprotect_range_one+0x147/0x230 mm/rmap.c:1246
> Code: 7c 24 40 49 8d 7f 28 ba 18 00 00 00 31 f6 e8 e0 2e 14 00 48 c7 84 24 80 00 00 00 01 00 00 00 49 83 c6 18 4c 89 f0 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 f7 e8 ea 2b 14 00 4d 8b 36 44 89 f6 83
> RSP: 0018:ffffc90000a777c0 EFLAGS: 00010206
> RAX: 0000000000000003 RBX: ffffc90000a779e0 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90000a77840
> RBP: ffffc90000a778e0 R08: ffffc90000a7783f R09: 0000000000000000
> R10: ffffc90000a77828 R11: fffff5200014ef08 R12: dffffc0000000000
> R13: 1ffff9200014eefc R14: 0000000000000018 R15: ffffc90000a77800
> FS:  0000000000000000(0000) GS:ffff8882a920c000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000025d35e991000 CR3: 0000000110c34000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:	7c 24                	jl     0x26
>    2:	40                   	rex
>    3:	49 8d 7f 28          	lea    0x28(%r15),%rdi
>    7:	ba 18 00 00 00       	mov    $0x18,%edx
>    c:	31 f6                	xor    %esi,%esi
>    e:	e8 e0 2e 14 00       	call   0x142ef3
>   13:	48 c7 84 24 80 00 00 	movq   $0x1,0x80(%rsp)
>   1a:	00 01 00 00 00
>   1f:	49 83 c6 18          	add    $0x18,%r14
>   23:	4c 89 f0             	mov    %r14,%rax
>   26:	48 c1 e8 03          	shr    $0x3,%rax
> * 2a:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1) <-- trapping instruction
>   2f:	74 08                	je     0x39
>   31:	4c 89 f7             	mov    %r14,%rdi
>   34:	e8 ea 2b 14 00       	call   0x142c23
>   39:	4d 8b 36             	mov    (%r14),%r14
>   3c:	44 89 f6             	mov    %r14d,%esi
>   3f:	83                   	.byte 0x83
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.

