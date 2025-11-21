Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78C7BCFC29F
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 19:02:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98B526B0007; Fri, 21 Nov 2025 14:02:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 962E56B000C; Fri, 21 Nov 2025 14:02:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89FD36B009E; Fri, 21 Nov 2025 14:02:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7A8BB6B0007
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 14:02:26 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2FBD91A06AA
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:02:26 +0000 (UTC)
X-FDA: 84135535092.01.ECB62EE
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4D44E180020
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:02:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jkNC9aRI;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763751744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XskgFTM52lEmG5o0DJaVTV/tHkCxB5mh+eImQRX5RZI=;
	b=NSrA2uRceXSkbNwlw6LFt38kOZPhQqm2ml1C7LK3KmFADasbFNmdGChDlQUGyK/4j6ncFS
	rm1FYeke2BwSALT2w9FEBJ2m8u648ZgGLd2npr9YZqXahysS32mHXiE6NMrxzduAoC3T3i
	/KB9GlKeUZuoK63QFlvMOa5KNHAO2WA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763751744; a=rsa-sha256;
	cv=none;
	b=DsRqVm+d4UBBMzKo7/j+WFHPwYZPAyI9MYpRW0KSh9ZK8b803Pj4/rrQvgQtIPnDfLARvB
	z3KhB4J3JRLJShDd4qJQyhlMtOS9KyNPqR17AVRTlqqPn905pBbcE8VGc9WF1Ouk6R8TOP
	UzWGXvDKYw4033MyrBJaXhewwX2LU2Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jkNC9aRI;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XskgFTM52lEmG5o0DJaVTV/tHkCxB5mh+eImQRX5RZI=; b=jkNC9aRIba3baxQ5ooUUSf9IzV
	gPJ+0Xh6koQa3D5YokIYPlpZXDsuTp1WZ7Mf4bdO7Q2FeNX2uRZbUrGBNYSIrM10MRtBiLyFhU4ke
	nx6OaamIl2/cdBJ6FjxkePbI54XlyOGPYoiFS+YTaDgoxVCfaBxZXPVU24VjwvwXk55bXu0u0+T1d
	bFXlBHl5q/m86FN4vUVGKt3/XsmqDY0CAXiklq8y1nBQFvrP38+gN7siYQh4IK3L17CZyeBz9Xz58
	hTw6Uim8saDBwoj4ZnOVw0U9hDLPxEMZv1FS0dY5aBdpK6lAYrEwNERd+U/IqT4/Rjs3iIQP1mf0h
	IJ+Di/5Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vMWOg-00000003KRt-305g;
	Fri, 21 Nov 2025 19:02:19 +0000
Date: Fri, 21 Nov 2025 19:02:18 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+b0a0670332b6b3230a0a@syzkaller.appspotmail.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [ext4?] WARNING in __folio_mark_dirty (3)
Message-ID: <aSC3OsxouD7lFKEy@casper.infradead.org>
References: <691f44bb.a70a0220.2ea503.0032.GAE@google.com>
 <20251121101155.173d63bd6611cd3c4aa22cf9@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121101155.173d63bd6611cd3c4aa22cf9@linux-foundation.org>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 4D44E180020
X-Stat-Signature: ufnrcawhrufjh5ufgse9fso7gqtxbbbj
X-HE-Tag: 1763751743-145731
X-HE-Meta: U2FsdGVkX194F3cwOgZSOTmYet+Mz4GzaPIAP+m+xXlRsYkb9DYUL8yEnyJooYRYk6lhUbifo7taZIXfolN9bkMJuRpT2dNPGHolCNxdsG8/Tqo+KwmDSnCaZhi2LE8sVHb95cax45IfDaAaX1eDKEFU3q8UaUAAiP0MYXE24OgmjMunFgusEwgE7mZFxOGcc4QDvg7taT5Nar4CuPUpW8ypbc8wTGyVmEu4wamHaAS5mrkNunprpu7c1Cbpz5ULZwFQ4jg3aO2tdQLFmc0oAPPdmvwypeHREZY8Ul46x3lZg9wMpdmALeoxQmiq1xeFdnstrTjnYLUfU3NgEpSrFBdYRjuXdYA9rxqLG56MPRSDS5E4crEK7nIRnCELKtJKiinRRLHFTthv4ozc4FMHafhxLiu16F3anVrOUhXm2cOWEaZPPf74hy0muTqLHJb/Q2USpfNtTKKtmxp0/aFm+QWg7pOVW/g3EeJ8REv+wywhywp7rpK1I8v9QmEXA7aatIZW/Ej98JrWL5iFxEknb1CkymqsmUXULIxkZAGRxDT4oTAMLOqx0XEJ+IvfY0T8ctBP/fxVrELtbFi5cDPZvPa3ED/YFU9rdI3+3ucOIbnqGtXmqe/HrIAE88pbNVses4L7hDs0zVdvDdnbAn/zWJE/6yG4Dfp/40v/GGnkURKtr3OvWzN5QLkSHmPplLpsbuZiVTK9AyR96ef60CRgAf7gS9Z8eM1RT5e2iSVL1RUN0nuutZeGI6ArDbnHWQIQopS8CMlY/9oTL8JF2M0efc0lP0NymfigFjEKMe6vvJwFxuyGTfYlwHmFD3yv8H/i4Z7dEwKuYE/0pFaL5HbhJLRx90rzvDa17WirRXhPN6L9J1EWpW/jJx0DJMLvR1YIcs7+2neWSnV7brUljvlIlF3BFsMP52hAUFFu7O6GGeRSNoX13/leIlc7v8lJNSP8n3dugorV2faW9pLXGK6
 qOSw7YAe
 9kZPl5mcuSMRhPTjaV22OIcjvpQbpiHXQ6kb3dCen2gpEdURkSOLvCEbAk4fw6Nvw31rwc64tmsMy4v4V7QCyQvBn0O1OHC9McLQoAwWI4rSJNE7WOP6t0iCSRXOJbhppjXg8V3fZGAcy+jDiGcuoqZTvCfLrpH/DZCJrGjVDd9rNhNp/p8qqF+dcgK1xbEQgn6rllAJTMcFyrpPcyBPofv+7PzOs6f9L7wsAv5JfqbtpWuADif7YzgcYdKJIvcQShM0+FcPm1OlifSyi6Kw3/+SVwbUOJVFAu308wNdDIq3U+1Jo9KUggNfeeV7X1B24qS0BLwYW00jULUQ+CoTscaFu0e6hrJ8GKlmxXCAnjQtHd6pt9FWd2lIKEbYtIoWxQ7e6eZ+m0ozb7KrtRlgxItR1l89c4Jh9PRTXa23NQTvkJPjAzy8vmznZGG2Sp8r5wa29/WTgdUL4apAygPoh+LDZGpcuvxfsI2LAib5VkQji92ILHuA5XCqFTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 10:11:55AM -0800, Andrew Morton wrote:
> On Thu, 20 Nov 2025 08:41:31 -0800 syzbot <syzbot+b0a0670332b6b3230a0a@syzkaller.appspotmail.com> wrote:
> : void __folio_mark_dirty(struct folio *folio, struct address_space *mapping,
> : 			     int warn)
> : {
> : 	unsigned long flags;
> : 
> : 	/*
> : 	 * Shmem writeback relies on swap, and swap writeback is LRU based,
> : 	 * not using the dirty mark.
> : 	 */
> : 	VM_WARN_ON_ONCE(folio_test_swapcache(folio) || shmem_mapping(mapping));
> : 
> : 	xa_lock_irqsave(&mapping->i_pages, flags);
> : 	if (folio->mapping) {	/* Race with truncate? */
> : 		WARN_ON_ONCE(warn && !folio_test_uptodate(folio));
> 
> this
> 
> : 		folio_account_dirtied(folio, mapping);
> : 		__xa_set_mark(&mapping->i_pages, folio->index,
> : 			      PAGECACHE_TAG_DIRTY);
> : 	}
> : 	xa_unlock_irqrestore(&mapping->i_pages, flags);
> : }
> 
> I'm guessing that ext4 permitted a non-uptodate folio to find its way
> into the blockdev mapping then the pagefault code tried to modify it
> and got upset.

I think you're right, but the reason it's upset is that it found a
!uptodate folio that was mapped into userspace, and that's not supposed
to happen!  Presumably it was uptodate at the point it was initially
faulted in, then (perhaps when the error happened?) somebody cleared the
uptodate flag without unmapping the folio.

Hm.  I wonder if we should do this to catch the offender:

@@ -831,7 +833,17 @@ static __always_inline void SetPageUptodate(struct page *pa
ge)
        folio_mark_uptodate((struct folio *)page);
 }

-CLEARPAGEFLAG(Uptodate, uptodate, PF_NO_TAIL)
+static __always_inline void folio_clear_uptodate(struct folio *folio)
+{
+       VM_BUG_ON_FOLIO(folio_mapped(folio), folio);
+       clear_bit(PG_uptodate, folio_flags(folio, 0));
+}
+
+static __always_inline void ClearPageUptodate(struct page *page)
+{
+       VM_BUG_ON_PGFLAGS(PageTail(page), page);
+       folio_clear_uptodate((struct folio *)page);
+}

 void __folio_start_writeback(struct folio *folio, bool keep_write);
 void set_page_writeback(struct page *page);

... it doesn't actually compile because folio_mapcount() is in mm.h
so the declaration is out of order, but I can invest smoe effort into
making that work if you think it's worth doing.

> > EXT4-fs error (device loop0): ext4_ext_remove_space:2955: inode #15: comm syz.0.51: pblk 0 bad header/extent: invalid extent entries - magic f30a, entries 2, max 4(4), depth 0(0)
> > EXT4-fs error (device loop0) in ext4_setattr:6050: Corrupt filesystem
> > EXT4-fs error (device loop0): ext4_validate_block_bitmap:441: comm syz.0.51: bg 0: block 112: padding at end of block bitmap is not set
> > EXT4-fs error (device loop0): ext4_map_blocks:778: inode #15: block 3: comm syz.0.51: lblock 3 mapped to illegal pblock 3 (length 1)
> > EXT4-fs error (device loop0): ext4_ext_remove_space:2955: inode #15: comm syz.0.51: pblk 0 bad header/extent: invalid extent entries - magic f30a, entries 2, max 4(4), depth 0(0)
> > ------------[ cut here ]------------
> > WARNING: CPU: 0 PID: 6107 at mm/page-writeback.c:2716 __folio_mark_dirty+0x1fb/0xe20 mm/page-writeback.c:2716
> > Modules linked in:
> > CPU: 0 UID: 0 PID: 6107 Comm: syz.0.51 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
> > RIP: 0010:__folio_mark_dirty+0x1fb/0xe20 mm/page-writeback.c:2716
> > Code: 3c 38 00 74 08 48 89 df e8 52 a7 26 00 4c 8b 33 4c 89 f6 48 83 e6 08 31 ff e8 d1 ed c4 ff 49 83 e6 08 75 1c e8 66 e8 c4 ff 90 <0f> 0b 90 eb 16 e8 5b e8 c4 ff e9 7e 07 00 00 e8 51 e8 c4 ff eb 05
> > RSP: 0018:ffffc90003a079d0 EFLAGS: 00010293
> > RAX: ffffffff81f9c4ea RBX: ffffea0001213400 RCX: ffff888025260000
> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
> > R10: dffffc0000000000 R11: fffff94000242681 R12: ffff8880416cb4f0
> > R13: ffff8880416cb4e8 R14: 0000000000000000 R15: dffffc0000000000
> > FS:  0000555587ebe500(0000) GS:ffff888126df7000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000200000000440 CR3: 000000002e288000 CR4: 00000000003526f0
> > Call Trace:
> >  <TASK>
> >  block_dirty_folio+0x17a/0x1d0 fs/buffer.c:754
> >  fault_dirty_shared_page+0x103/0x570 mm/memory.c:3519
> >  wp_page_shared mm/memory.c:3906 [inline]
> >  do_wp_page+0x263e/0x4930 mm/memory.c:4109
> >  handle_pte_fault mm/memory.c:6211 [inline]
> >  __handle_mm_fault mm/memory.c:6336 [inline]
> >  handle_mm_fault+0x97c/0x3400 mm/memory.c:6505
> >  do_user_addr_fault+0xa7c/0x1380 arch/x86/mm/fault.c:1336
> >  handle_page_fault arch/x86/mm/fault.c:1476 [inline]
> >  exc_page_fault+0x82/0x100 arch/x86/mm/fault.c:1532
> >  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> > RIP: 0033:0x7f385fe87398
> > Code: fc 89 37 c3 c5 fa 6f 06 c5 fa 6f 4c 16 f0 c5 fa 7f 07 c5 fa 7f 4c 17 f0 c3 66 0f 1f 84 00 00 00 00 00 48 8b 4c 16 f8 48 8b 36 <48> 89 37 48 89 4c 17 f8 c3 c5 fe 6f 54 16 e0 c5 fe 6f 5c 16 c0 c5
> > RSP: 002b:00007ffd3b8738f8 EFLAGS: 00010246
> > RAX: 0000200000000440 RBX: 0000000000000004 RCX: 0030656c69662f2e
> > RDX: 0000000000000008 RSI: 0030656c69662f2e RDI: 0000200000000440
> > RBP: 0000000000000000 R08: 0000001b2d820000 R09: 0000000000000001
> > R10: 0000000000000001 R11: 0000000000000009 R12: 00007f3860115fac
> > R13: 00007f3860115fa0 R14: fffffffffffffffe R15: 0000000000000004
> >  </TASK>
> 

