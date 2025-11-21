Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 111AFCFC29A
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 18:12:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 541D36B0026; Fri, 21 Nov 2025 13:12:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F2B56B0027; Fri, 21 Nov 2025 13:12:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 408646B0029; Fri, 21 Nov 2025 13:12:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2CAC86B0026
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:12:02 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 24B9889F8F
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:11:59 +0000 (UTC)
X-FDA: 84135407958.21.F1FE53B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 581CF40016
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:11:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="M/CsTa0T";
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763748717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+FAXtvjswW/wCOpqI1K+3TfV3O2tZX4Kx6RVInLWi68=;
	b=q7j/3TtatX2+vIdtIeBaOj3rdJNrmZaf+xRf9SXzlBUwe20OT3EP4vcEYLIocdbaNJloBv
	PZ7MrP4LVxRRyHAaVvqwIG9r5/Qr1RCxM99WLrhhQohCo8yF6t7NTmtaagm3rxRRoGhE7w
	8GSR4EpBR8NiLDmOyh+8hSb4+DnT0Z4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763748717; a=rsa-sha256;
	cv=none;
	b=BRPm97gvHsJQjmlV4HtJErE70vOmUZaEqzu7snWM8957aHB8Qvh2KudOPSI5cnwpajJMQN
	lGdfapto75F2GSikSLC+B6amg+dmg3Cf5TM/TmSnDZHwfqdkJ7/aM4j67wRKLxvbfbXTi0
	azRsVgXZiAkDL2fAZK5QN6CpTsVtklU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="M/CsTa0T";
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A692A60139;
	Fri, 21 Nov 2025 18:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B059C4CEF1;
	Fri, 21 Nov 2025 18:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763748716;
	bh=Wa6xClv8NW0RAE33MZq89ApNXSfdBaddC/8F/noLinQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=M/CsTa0TIFq6NUTlvuUwELOxq0/VnZ0IHmeC3vw88+1rL+NhflZn7WYZRE5SKyI/n
	 Tcj/gN9DyEoqzcp1LE+TKL1Tnn7bupc7UuF78MkSf6J2HjjmQdai/VgrGxLCM5GqeL
	 MC26UxPW2MYoFOY2rWVweKReidfkr+UPiaSiXIXk=
Date: Fri, 21 Nov 2025 10:11:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+b0a0670332b6b3230a0a@syzkaller.appspotmail.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 syzkaller-bugs@googlegroups.com, willy@infradead.org
Subject: Re: [syzbot] [ext4?] WARNING in __folio_mark_dirty (3)
Message-Id: <20251121101155.173d63bd6611cd3c4aa22cf9@linux-foundation.org>
In-Reply-To: <691f44bb.a70a0220.2ea503.0032.GAE@google.com>
References: <691f44bb.a70a0220.2ea503.0032.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jm88uc9gpidb7pja4t55yh9qsgs59wfx
X-Rspam-User: 
X-Rspamd-Queue-Id: 581CF40016
X-Rspamd-Server: rspam01
X-HE-Tag: 1763748717-137741
X-HE-Meta: U2FsdGVkX1/g6RFc1bWNzTPcswCv3PGy2djVTFQRb4uZ0EcYHg1fR7CnNUMQ2MdhsffaZng2Fyt77McUL21z4jQVFF3I/3JM/DGjURiMVY94cvEA774ZpveKYfMVc25anpfM6EovZLfKODldyiyDDOKlObDdega5yyWU30WQe4Aa40JhW/HNNsEfgTbcCCz6oSRiHEssvgxdtBA7ZYFX+5cHs/0FZvrjmE68br9cJB9UJyg5DCm/AgPjzrTjxGQaYrvVi36cmKkRIO9lVL+eXvB+qaUmyA05+hN4NyoZhABI/MAjCuApksdi/j1heMC0mh9tDJCrNm0Od7lkCeSjymUsDoylrIiLGm3dlkxcElbxy5N8eq1hFTgfnr2vF4/m+u9IFs8QuYVCCQQDFwGSD+IByFHZWWIuL7+i1s/zezFGq+8sEGOG0j3bT5qflPP2ZZk/VCMgkTbXPKpNfdTfMgOG35FRH7KZfvqSDrktQerNogBUBDvsPd6C5s6S69gWTB2UEwzLil4utyeh+fZ4sApWCfaA5QgsAEDO6k13zCcuB/iLiZpXmufO7Zgu9zRq9oHMJ5g6j1fVI60Zze3wLncveJLSX80SUpsGC2asfMceYTV1OSkAjRgk6+arAk8DI8K9ja4c5tXGLitCm4PRwxlITGDI6JxBzwCOkj7PmUyaLUfICA1Kt9cjvu9xoVT8+1IQShWBUgZdVLhae6+pxKxkWqbUfKQWo6Dn3CDv40MEY/vAhBwd5qrIOccq7wZ2xSXAe+6UERvH5MzTz29AGkiRInisrumXKzWFCB4+cR959dmjNMutzye7AGMMYmKqhOCy3mR8mItV4KK8OKylgtRFCOan9SPacEkDHnBIQFfLwSayQeJKGCG9qnk62uOAHeXHedsk5pnHkldE4e299o/N8jK1tUJ8uz0ag/+XuEDKD1iif24j4SpJ4VL6ev2JaZzYAygM4aUZmgJnjqL
 osuQA5LN
 5wXgqB6h+Z3udPSwjCtIo8WP8Pd/EYJ3ffZZd92+Xp1cHb5QH3e70SQ7IB70aGMwDL9x3XLRwQ1XmbWSS3PsuDN9V42Pc9yVO0Dnx69+aTwPkTwAFldwdbMjEio+eS1opGSfvSvRZXzrOjKpK0bI4gVaHLnqFgW6qcX6OcTRTUkhwVqRFKXAATniR+xhUPgB155Y8aMNZU8eCWTnmwBFEcw9rPNGr6QxLvJdQ2iHlrYRtiWA/F18lF+1qBWZR1NQhuGPSb0YFwcOZnsOj0swN7ADZ5wHjflUT+IZO0qC8/GKsSJP6numBkPIgOowR2n/R7sQbRTqCIHF0aS2jjoaNpYB3KeLk+QfZuBWbdU9e8pcwDeubYJpwLb7G+HuxRpiF0UTxz25h7BZwl17BlTLGcyihCWdEncRjV45jVRQ3Xsez39R4PkOhranl1bdooKZgd4iTEPgmQYo5200Oqj1v7hRPi6mnSlwvsn/TPKGzNmqNRe7dmeNiLnJ3/Q0E2si7IT/vjldavwjeeseGK/UuBb9YqCaJBKRb07f+G9vvjxdhvDOJuMH8dx3s2ppk/tyDzIBqPIkG71FhSa67ggI+n2nRviVHNUBXFgKRwFvn/swrWUKWfpCwGkWH06t9LsRUgxrNl/xDsotp8GaD147mlSyntEeqK3DNSwolmVgyNGe2iOnvr6YBY2Vzr+o6/5jAN0kNcdcYDWVPXH/VTsFBfFRnJRd51jyOv3AjJ6pfrC76vlzhS4nfJ09ddUief94DWwGuyRnZD8gjcpL4YxV+oPBkH2Ex2t+BiM8vNxdsI9+8aYlSmmN5W3bqxASjPmmHUhwU7vyfGa4glKYX666GXLb15VqBBtYq9QJlggAQM+AbyDsThKDskgFgK/K036JypAHwR9IJX/7DV7I7P0g1QpQq6APuZInVOlyTBvpu7UlamPFP0B1Na2UAeg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 20 Nov 2025 08:41:31 -0800 syzbot <syzbot+b0a0670332b6b3230a0a@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    23cb64fb7625 Merge tag 'soc-fixes-6.18-3' of git://git.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1287997c580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=38a0c4cddc846161
> dashboard link: https://syzkaller.appspot.com/bug?extid=b0a0670332b6b3230a0a
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=172cd658580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15378484580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/a14ebce6c664/disk-23cb64fb.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/7703c3032e2f/vmlinux-23cb64fb.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/a16c5b94924d/bzImage-23cb64fb.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/4fa9525269b6/mount_0.gz
>   fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=11d42a12580000)
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b0a0670332b6b3230a0a@syzkaller.appspotmail.com

Thanks.

: void __folio_mark_dirty(struct folio *folio, struct address_space *mapping,
: 			     int warn)
: {
: 	unsigned long flags;
: 
: 	/*
: 	 * Shmem writeback relies on swap, and swap writeback is LRU based,
: 	 * not using the dirty mark.
: 	 */
: 	VM_WARN_ON_ONCE(folio_test_swapcache(folio) || shmem_mapping(mapping));
: 
: 	xa_lock_irqsave(&mapping->i_pages, flags);
: 	if (folio->mapping) {	/* Race with truncate? */
: 		WARN_ON_ONCE(warn && !folio_test_uptodate(folio));

this

: 		folio_account_dirtied(folio, mapping);
: 		__xa_set_mark(&mapping->i_pages, folio->index,
: 			      PAGECACHE_TAG_DIRTY);
: 	}
: 	xa_unlock_irqrestore(&mapping->i_pages, flags);
: }

I'm guessing that ext4 permitted a non-uptodate folio to find its way
into the blockdev mapping then the pagefault code tried to modify it
and got upset.


> EXT4-fs error (device loop0): ext4_ext_remove_space:2955: inode #15: comm syz.0.51: pblk 0 bad header/extent: invalid extent entries - magic f30a, entries 2, max 4(4), depth 0(0)
> EXT4-fs error (device loop0) in ext4_setattr:6050: Corrupt filesystem
> EXT4-fs error (device loop0): ext4_validate_block_bitmap:441: comm syz.0.51: bg 0: block 112: padding at end of block bitmap is not set
> EXT4-fs error (device loop0): ext4_map_blocks:778: inode #15: block 3: comm syz.0.51: lblock 3 mapped to illegal pblock 3 (length 1)
> EXT4-fs error (device loop0): ext4_ext_remove_space:2955: inode #15: comm syz.0.51: pblk 0 bad header/extent: invalid extent entries - magic f30a, entries 2, max 4(4), depth 0(0)
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 6107 at mm/page-writeback.c:2716 __folio_mark_dirty+0x1fb/0xe20 mm/page-writeback.c:2716
> Modules linked in:
> CPU: 0 UID: 0 PID: 6107 Comm: syz.0.51 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
> RIP: 0010:__folio_mark_dirty+0x1fb/0xe20 mm/page-writeback.c:2716
> Code: 3c 38 00 74 08 48 89 df e8 52 a7 26 00 4c 8b 33 4c 89 f6 48 83 e6 08 31 ff e8 d1 ed c4 ff 49 83 e6 08 75 1c e8 66 e8 c4 ff 90 <0f> 0b 90 eb 16 e8 5b e8 c4 ff e9 7e 07 00 00 e8 51 e8 c4 ff eb 05
> RSP: 0018:ffffc90003a079d0 EFLAGS: 00010293
> RAX: ffffffff81f9c4ea RBX: ffffea0001213400 RCX: ffff888025260000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
> R10: dffffc0000000000 R11: fffff94000242681 R12: ffff8880416cb4f0
> R13: ffff8880416cb4e8 R14: 0000000000000000 R15: dffffc0000000000
> FS:  0000555587ebe500(0000) GS:ffff888126df7000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000440 CR3: 000000002e288000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  block_dirty_folio+0x17a/0x1d0 fs/buffer.c:754
>  fault_dirty_shared_page+0x103/0x570 mm/memory.c:3519
>  wp_page_shared mm/memory.c:3906 [inline]
>  do_wp_page+0x263e/0x4930 mm/memory.c:4109
>  handle_pte_fault mm/memory.c:6211 [inline]
>  __handle_mm_fault mm/memory.c:6336 [inline]
>  handle_mm_fault+0x97c/0x3400 mm/memory.c:6505
>  do_user_addr_fault+0xa7c/0x1380 arch/x86/mm/fault.c:1336
>  handle_page_fault arch/x86/mm/fault.c:1476 [inline]
>  exc_page_fault+0x82/0x100 arch/x86/mm/fault.c:1532
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> RIP: 0033:0x7f385fe87398
> Code: fc 89 37 c3 c5 fa 6f 06 c5 fa 6f 4c 16 f0 c5 fa 7f 07 c5 fa 7f 4c 17 f0 c3 66 0f 1f 84 00 00 00 00 00 48 8b 4c 16 f8 48 8b 36 <48> 89 37 48 89 4c 17 f8 c3 c5 fe 6f 54 16 e0 c5 fe 6f 5c 16 c0 c5
> RSP: 002b:00007ffd3b8738f8 EFLAGS: 00010246
> RAX: 0000200000000440 RBX: 0000000000000004 RCX: 0030656c69662f2e
> RDX: 0000000000000008 RSI: 0030656c69662f2e RDI: 0000200000000440
> RBP: 0000000000000000 R08: 0000001b2d820000 R09: 0000000000000001
> R10: 0000000000000001 R11: 0000000000000009 R12: 00007f3860115fac
> R13: 00007f3860115fa0 R14: fffffffffffffffe R15: 0000000000000004
>  </TASK>


