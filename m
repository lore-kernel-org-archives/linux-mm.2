Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6728C531CB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 12:00:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A60D56B0093; Thu, 23 Jul 2026 08:00:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A394B6B0095; Thu, 23 Jul 2026 08:00:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94FD96B0098; Thu, 23 Jul 2026 08:00:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6DB7F6B0093
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:00:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E1497160480
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 12:00:09 +0000 (UTC)
X-FDA: 85019898138.15.E36F427
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id 14B5640009
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 12:00:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MHyabGz3;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784808008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c4hElVqmYpqUsdMIDfblHdUXoaZAp8PegjmWKWhCfi0=;
	b=f0PFWMOwGyUo9rrhDoUKhhxEmWx0BbWqA5JSo3S9kDMUQZg6aLYdpR9wU/oOvpDPVPGTTZ
	kMImUUCuhxAPhrVhzYmqu0IsKCkdH9nxTGWMhxqalJ+CRGBNAxNPmjVjSRBeg3dhvJsMGK
	NZwDSbDxt23F8L6g0MBDRUtDo8FCf/I=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MHyabGz3;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784808008;
	b=sOowjjFz0mnPfoRNmn0IU11lw5WXtluptuKzU01YZWSJw4tX27sy/Ge5nE8TFcvV8ZJKJm
	OXBT5Prqvh2KE2PQ3SSLdyU9OyKnD16C1HKcPD6cwFditNQKulgmYDOyaq3rt06CMPF6Ur
	beGx8QGHUK6jKvEbyfn8QCHoTic4JrM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=c4hElVqmYpqUsdMIDfblHdUXoaZAp8PegjmWKWhCfi0=; b=MHyabGz3a+YQkwKLmY93en+C9q
	V3KyBg0TsuClrun8CjqP00/AdTEnKuRdi0xjGvsJ0thjHbQPuiMXgPmZu/3ticfErRaRG+XTDJg31
	WqoM4h3w8B/SknpDK78zm6lk+beGWfs1oGFFRDgoUSS2yVqDFVGNDBiTGCGiIPNmGY5YJ9WqQIh3R
	b3Bmqvmn7Ejq0BXm+oMUDJuRBiYdLpERczqWZwKrLGutLbmpZRQtmt6saykl6+AOnzslJi43hJjit
	VBeX/GbxaWFqD8g6BNzaebWGbKWvRQwBtIoi3TS90ETdg6JGTLyAboSWSBi7IslW/LgW785QvN8Nw
	uB6TxpWw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wms5p-00000000S92-3D48;
	Thu, 23 Jul 2026 12:00:01 +0000
Date: Thu, 23 Jul 2026 13:00:01 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
	linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH/RFC] btrfs: fix folio lock leak in writepage_delalloc()
 for folios dirtied behind btrfs' back
Message-ID: <amICQYTK9Xu4KLtH@casper.infradead.org>
References: <20260721191152.101118-1-borntraeger@linux.ibm.com>
 <20260721191152.101118-2-borntraeger@linux.ibm.com>
 <b226a6e9-fef2-49bd-b17e-9f9b015626c1@gmx.com>
 <83290932-cb8b-4741-bff0-6a7d8df2c637@linux.ibm.com>
 <224d56d2-fcad-41bf-afe3-6f5f5108172a@gmx.com>
 <f12f70e5-d84d-4a9f-ac94-693be4c863ac@linux.ibm.com>
 <amC-J7yzwk4Z5tHW@casper.infradead.org>
 <ad6eebbd-07f8-41ce-b04c-edd50d91a6e3@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ad6eebbd-07f8-41ce-b04c-edd50d91a6e3@gmx.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 14B5640009
X-Rspam-User: 
X-Stat-Signature: qnob6wobb136q4648numidsogmrkdxw6
X-HE-Tag: 1784808006-670334
X-HE-Meta: U2FsdGVkX1+BN3upERoEx+wAJG8E2D54DuIE2c4QDpMmQyTt2PoF80b2EDQFPTG03Ns39khvLra2VXJsonqxFBkXy5zj/HfUVknmjxtalL9gJpfudibqvg8ya7vgmcKuc082VMXTP+VSpV3MdX0CG1oH8VjK71jpymUozjZ3C2ZzMKnEGmVQ9kznX7NSWmJ02G2fhmTrvgg06acUBT4l0l2yqnRqRnu0RbTVt2/11YuCCBCIeO4YWgVTHtUrGov0cH3bcPQaEbCXO0NXRIOxEfOBsuWFnrt5NSA5lDz0GooPy3kAjzz4jD9J52uIIqJiXt5cVv3nPEb+vhF71UTeNodx+j7WUbtdkL+ytJgXeXFkRXx6b7b+Ggx44ebGXpdjzMBwXEEXvGHxiO4YathbB8YRFNMpFdskQuzIE7IDwr6cmWszHgL1suNSI1OSCl8U7fbpL4hO1s5VbRSGXhN8Dvt7AvNeukXorV0g6McNEnIrrtM290BqD46KrCLtMfpx0AY/HbqHt92xf38deLZwCQfMGXh3dsxV5KT+QWLLvABg9IDqAAQXZqEmaTZ4bTvShHp6DPXomGHQ/iLzKOXVRh/aG6yzVMWpxETksuFT6cEnhP2v/TTACf/67S5eAj569Oa2wCsr9prkPfKL9vQaDAhfdbx2AFclB0poqpSXpWKxnuLty5v8t2PfdQv2nBXtgfbrCCmRiU5ZCkV4zoa1bDlXC5qni0Ljiv9+Z0yI/1tFN2SHpyp80RNUJOjqfcKCj9EzKfeG0H+PT5VYBrNslkoavt/Tl1KWgNd9HywUVWdFjsHlDQg9+Wv/+p/Ur6LjXk0arKac6+TfmijKT8CcFSDNdSO/cZz3oI6J8uAKRdH0FdJ3QSjVm3TYqGkhKqlgvgEHZ77eBuUkHYwDi8mrejgq60ZZLr6s2tQwplsYsgOpanMdFxCu9fQStLpPxQfz2llzVjOhMQlnADEzEuB
 l/7KzTk7
 B/PWp+ZSvtfdiVLIu8u97m7zWqaPtFBKBgPXAapr5wdcjX+I41J3dQ3WV9tZlay0LAUSa0Uhtpp8JLmiyJgyloJIblEVrHY2c/180612xkEhUXemQKAtoP1Iumu8Y9SxR6qWI/U8JfR6kHekv3P0hEXQXeblgSfOSoDbPhiTmiN+9WTO9qpuZtDGqqwhWC7o2r1aH3FUGpXLLDWH6Prnx7YQAKTTOCsrysQnocykDF0Ajk7LYY2kvegjo/D7znreWwBOPIHugf+iSmncD0ksWtPF/izBuGvzaHANrLbVzJ9IruX7MAWhfmN7OmU/ifmww6VJhFWz3WHXeCtFUAH6YX4j7ij/bqOSh9iEy5TQc8+lQro5DPPsjn5tlZRgdUhB8mri6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 10:12:27AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/7/22 22:27, Matthew Wilcox 写道:
> > On Wed, Jul 22, 2026 at 11:29:36AM +0200, Christian Borntraeger wrote:
> > >   *   4. Thread B loops sync_file_range(WRITE|WAIT) on the target file.
> > >   *      Whenever a full clean cycle (clear_page_dirty_for_io(),
> > >   *      writeback, bits cleared) completes inside thread A's
> > >   *      submission->completion window, the completion-time
> > >   *      set_page_dirty_lock() hits a *clean* folio: filemap_dirty_folio()
> > >   *      sets only the folio flag and the xarray tag - no btrfs subpage
> > >   *      dirty bit, no delalloc reservation.  See the 20-year-old comment
> > >   *      above bio_set_pages_dirty() in block/bio.c describing exactly
> > >   *      this ("other code (eg, flusher threads) could clean the pages").
> > 
> > There's your problem.  filemap_dirty_folio() documents that btrfs is
> > doing it wrongly:
> > 
> >   * Filesystems which do not use buffer heads should call this function
> >   * from their dirty_folio address space operation.  It ignores the
> >   * contents of folio_get_private(), so if the filesystem marks individual
> >   * blocks as dirty, the filesystem should handle that itself.
> > 
> > fs/btrfs/inode.c:       .dirty_folio    = filemap_dirty_folio,
> > 
> > so btrfs should have its own btrfs_dirty_folio() which does whatever
> > metadata updates it needs to and then call filemap_dirty_folio() to
> > take care of the page cache business.  See iomap_dirty_folio() as
> > an example, but many other filesystems also do this.
> 
> Thanks a lot for the advice.
> 
> However it looks like the sub-folio dirty block tracking is a little
> different between iomap and btrfs.

My point is not that "you should do it the exact same way as iomap".
Rather "the dirty_folio op is the entry point to tell the filesystem
that a folio is being dirtied".  And you aren't taking advantage of
that, you're just calling the VFS so the VFS can do its own tracking.

> E.g. iomap will mark the full folio range dirty even if the EOF is inside
> the folio, but btrfs will only mark the range inside EOF as dirty.
> 
> 
> Another thing is, even if we follow iomap to mark the full folio dirty, it's
> still not the end of the story.
> 
> We have other supporting mechanisms required to tracking the dirty range.
> E.g. EXTENT_DELALLOC flags inside extent-io-tree, indicating we have already
> reserved space for the dirty range.
> 
> Only with EXTENT_DELALLOC flag set, we will do the real delayed allocation,
> allocating the on-disk extents etc.
> 
> So even if we always mark the full folio dirty, the writeback path will not
> handle them correctly either.
> 
> 
> Finally, even without large folios, the reproducer can already cause
> problems on btrfs. E.g. on x86_64, with mapping_set_folio_order_range()
> disabled.
> 
> The symptom there is that, ordered extent accounting underflows, which may
> also contribute to the stall observed.
> 
> I'll keep digging for this bug.
> 
> Thanks,
> Qu
> 
> 

