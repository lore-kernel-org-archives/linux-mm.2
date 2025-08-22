Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDB07CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 11:01:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3372280021; Fri, 22 Aug 2025 07:01:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4798E009D; Fri, 22 Aug 2025 07:01:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD385280021; Fri, 22 Aug 2025 07:01:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 97C9A8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 07:01:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3EDD65ACE9
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:01:39 +0000 (UTC)
X-FDA: 83804102718.23.0BD8B26
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7462AC000A
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:01:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=XSvCLbN2;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf10.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755860497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9KskoGBFOs28/Mda6h0wj3uBIF0p2biNPs4pw1Y7qMU=;
	b=f25zsqzmahXIYSaFhm9yNXknG2CJ5cgUe8T9Qds5xV6cT16F5Tl1NRig5AwZzN/gvI1Qke
	NGS3Gb93Q04agc3k+DWbctdFlkzJaf2SzR/Iv/no63YQHJk6Fj6VY+IxjwCw+xS4JOw2Bs
	UCpA/cr8GQxxt11kGt/S3PhKY/i2Nng=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=XSvCLbN2;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf10.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755860497; a=rsa-sha256;
	cv=none;
	b=EXZ9/FRc3ZNpMdVG8kaCQXn3kphgdZT+HTbVm6npsOywnLOwnU/2tN2hTIPH2LLeSP1MIT
	ETEiyIe2j2vaLHZqFAE00sqoBl6Txte2+kFG69+0xjKLKska6iWBrIfNBLy5TPqLgb+F8O
	q3DryNk5RNTL2J0k8gDEPMcsVP0CAB4=
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20250822110134euoutp028c20660ce2dbead941645e9434b61494~eEdEHrgSU2865828658euoutp02E
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:01:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20250822110134euoutp028c20660ce2dbead941645e9434b61494~eEdEHrgSU2865828658euoutp02E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1755860494;
	bh=9KskoGBFOs28/Mda6h0wj3uBIF0p2biNPs4pw1Y7qMU=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=XSvCLbN2gOkeveRq3jDm90QxT2zPFO5+lvs7w0yr7uj7WpxPNUUyYsfjHaA/3woux
	 HBFJ00BIOa1rK+QG+mG9I21NsJRWaflrG2me6uvYKGS7juZoBQ6yl0LO59N4e6VNjS
	 3p5s3hX41XzBjaYet9qwjS47J/cm7xwyQ0TXQuvc=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20250822110133eucas1p2378459d1e802c718ef6028efc06625dc~eEdD32zgD1178111781eucas1p2y;
	Fri, 22 Aug 2025 11:01:33 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250822110133eusmtip1965119ff684e33aef3b2ab78de9aa4f6~eEdDTj8sl1109711097eusmtip1t;
	Fri, 22 Aug 2025 11:01:33 +0000 (GMT)
Message-ID: <a91010a8-e715-4f3d-9e22-e4c34efc0408@samsung.com>
Date: Fri, 22 Aug 2025 13:01:32 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v2 2/2] mm: remove BDI_CAP_WRITEBACK_ACCT
To: Joanne Koong <joannelkoong@gmail.com>, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, david@redhat.com, willy@infradead.org,
	linux-mm@kvack.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20250707234606.2300149-3-joannelkoong@gmail.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250822110133eucas1p2378459d1e802c718ef6028efc06625dc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20250822110133eucas1p2378459d1e802c718ef6028efc06625dc
X-EPHeader: CA
X-CMS-RootMailID: 20250822110133eucas1p2378459d1e802c718ef6028efc06625dc
References: <20250707234606.2300149-1-joannelkoong@gmail.com>
	<20250707234606.2300149-3-joannelkoong@gmail.com>
	<CGME20250822110133eucas1p2378459d1e802c718ef6028efc06625dc@eucas1p2.samsung.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7462AC000A
X-Stat-Signature: rsreiyqzxi5rrt7zrixcms7sgmeyy84n
X-Rspam-User: 
X-HE-Tag: 1755860496-540307
X-HE-Meta: U2FsdGVkX19SsBv7dbQHcjb7lu4Bd6xHpKSPw/yT0CmmkzMSejZXmfL7d8n0+1C2v2CHlPA2RMPDfPZy9IfjcnzsG87fKwVx+jCfhP7XGXrlf478CnhkmFeky8wEY35hOirYAdZ6ba+J7h+p5zSQZJx5T7BDSYaprGbG2a1Gnih/D6odkXgT8kHt4M6sCFaWXiE4MalXxL+dHkcNXGtVg9Bt92gR3YQaONlz/edM38lgAX7fLbSkkjxXJrXaS3YxdJHsVqBF7ltgYIuuYSwJY1IVM//WLZeUUkrtiZ1GCzKHYY2RQY2eU4fPxg6+Rf+pKTo0pEUe0DHG0pwTis/H+sE8qjiAOo4Xnbc6K0D/Pm4NUu9tQSv6omreQ6wChntmSaDqh4oRaEpOYFt0kSAG3QFXzgoH84b6+t839IBirEebv80tCIH4u8cxKP8KNkXJqNavH5JAv70oboPBIIhKzLVrWb3I7qMINlGKvfMHJYvJfpmPHM144u2NCdvRD8Dni2OIJRUa+relaUlayCDUlZoMG0dYkaEH7ZKGchKkR2SPH7PUbjGizv1eVUk2oVE6Z+UvIpih/f68aMNI4j5Sfkr4bPW6b30X4EYWInG8Ln1E0DKUjTkXkEQwLpx1nnEhtNW3hfefylmyzRyHup3I2nrHukEHhjC4Lp/nXAbVEt0x4dgUVURTqdTDFmmR3qeVXIti8on1v1Zg5RXThJnVU1aEWz7jctBHtG/7GGVBB6QOV4/hah4yXL/XWR/vF58507f8EhcvIw1U41p/Dw9xScr2lVdhRh8JnAy9ca35LNX55miUpJYg0YWWK1Sy0Y0Oz9xgKOTpnaEbo98ZAUJczC8j/WtXUI0FoKMqWwy5Turo1aVYDgXe0KrAwCjnHIwCynmeuL5T39j9EGmxZMRSrWMJIus0Hwh0+A0jSbhQG7q3f0jZtPZM+nY8fQl7Z48h8qQALPAlkN4Hqc+bfw4
 lQEt1eFn
 KdDb+HhFz/qDCTn5I2arK2TQSA8gpyEJEOY3PIo5mMC268nrVg+rrZgyoSseZh1klL8ykVmtHFs79bQ/UxetwR06FwUdl9dCvdk/b5CoSV3mpgNaYFoWeLZRAUYsLrxGM6siu3kUKag6x20WuPlDI5jFUccodTDPh1yojwmhKAqZek8Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.07.2025 01:46, Joanne Koong wrote:
> There are no users of BDI_CAP_WRITEBACK_ACCT now that fuse doesn't do
> its own writeback accounting. This commit removes
> BDI_CAP_WRITEBACK_ACCT.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> Acked-by: David Hildenbrand <david@redhat.com>

This patch landed recently in linux-next as commit 167f21a81a9c ("mm: 
remove BDI_CAP_WRITEBACK_ACCT"). In my tests I found that it triggers 
the ./include/linux/backing-dev.h:239 warning. Reverting $subject on top 
of current linux-next fixes/hides this issue. Here is a detailed log:

------------[ cut here ]------------
WARNING: ./include/linux/backing-dev.h:239 at 
__folio_start_writeback+0x25a/0x26a, CPU#1: swapper/0/1
Modules linked in:
CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted 
6.17.0-rc2-next-20250822 #10852 NONE
Hardware name: StarFive VisionFive 2 v1.2A (DT)
epc : __folio_start_writeback+0x25a/0x26a
  ra : __folio_start_writeback+0x258/0x26a

[<ffffffff80202222>] __folio_start_writeback+0x25a/0x26a
[<ffffffff802f3260>] __block_write_full_folio+0x124/0x39c
[<ffffffff802f4b6e>] block_write_full_folio+0x8a/0xbc
[<ffffffff804dbf42>] blkdev_writepages+0x3e/0x8a
[<ffffffff802030fa>] do_writepages+0x78/0x11a
[<ffffffff801f2e0e>] filemap_fdatawrite_wbc+0x4a/0x62
[<ffffffff801f6d66>] __filemap_fdatawrite_range+0x52/0x78
[<ffffffff801f6fdc>] filemap_write_and_wait_range+0x40/0x68
[<ffffffff804dacae>] set_blocksize+0xd8/0x152
[<ffffffff804dae18>] sb_min_blocksize+0x44/0xce
[<ffffffff803a0c7a>] ext4_fill_super+0x182/0x2914
[<ffffffff802a72e6>] get_tree_bdev_flags+0xf0/0x168
[<ffffffff802a736c>] get_tree_bdev+0xe/0x16
[<ffffffff8039a09e>] ext4_get_tree+0x14/0x1c
[<ffffffff802a5062>] vfs_get_tree+0x1a/0xa4
[<ffffffff802d17d4>] path_mount+0x23a/0x8ae
[<ffffffff80c20cd4>] init_mount+0x4e/0x86
[<ffffffff80c01622>] do_mount_root+0xe0/0x166
[<ffffffff80c01814>] mount_root_generic+0x11e/0x2d6
[<ffffffff80c02746>] initrd_load+0xf8/0x2b6
[<ffffffff80c01d38>] prepare_namespace+0x150/0x258
[<ffffffff80c01310>] kernel_init_freeable+0x2f2/0x316
[<ffffffff80b6d896>] kernel_init+0x1e/0x13a
[<ffffffff80012288>] ret_from_fork_kernel+0x14/0x208
[<ffffffff80b79392>] ret_from_fork_kernel_asm+0x16/0x18
irq event stamp: 159263
hardirqs last  enabled at (159263): [<ffffffff805e7e4a>] 
percpu_counter_add_batch+0xa6/0xda
hardirqs last disabled at (159262): [<ffffffff805e7e40>] 
percpu_counter_add_batch+0x9c/0xda
softirqs last  enabled at (159248): [<ffffffff8002e972>] 
handle_softirqs+0x3ca/0x462
softirqs last disabled at (159241): [<ffffffff8002eb72>] 
__irq_exit_rcu+0xe2/0x10c
---[ end trace 0000000000000000 ]---


> ---
>   include/linux/backing-dev.h |  4 +---
>   mm/backing-dev.c            |  2 +-
>   mm/page-writeback.c         | 43 ++++++++++++++++---------------------
>   3 files changed, 20 insertions(+), 29 deletions(-)
>
> diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> index 9a1e895dd5df..3e64f14739dd 100644
> --- a/include/linux/backing-dev.h
> +++ b/include/linux/backing-dev.h
> @@ -108,12 +108,10 @@ int bdi_set_strict_limit(struct backing_dev_info *bdi, unsigned int strict_limit
>    *
>    * BDI_CAP_WRITEBACK:		Supports dirty page writeback, and dirty pages
>    *				should contribute to accounting
> - * BDI_CAP_WRITEBACK_ACCT:	Automatically account writeback pages
>    * BDI_CAP_STRICTLIMIT:		Keep number of dirty pages below bdi threshold
>    */
>   #define BDI_CAP_WRITEBACK		(1 << 0)
> -#define BDI_CAP_WRITEBACK_ACCT		(1 << 1)
> -#define BDI_CAP_STRICTLIMIT		(1 << 2)
> +#define BDI_CAP_STRICTLIMIT		(1 << 1)
>   
>   extern struct backing_dev_info noop_backing_dev_info;
>   
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index 783904d8c5ef..35f11e75e30e 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -1026,7 +1026,7 @@ struct backing_dev_info *bdi_alloc(int node_id)
>   		kfree(bdi);
>   		return NULL;
>   	}
> -	bdi->capabilities = BDI_CAP_WRITEBACK | BDI_CAP_WRITEBACK_ACCT;
> +	bdi->capabilities = BDI_CAP_WRITEBACK;
>   	bdi->ra_pages = VM_READAHEAD_PAGES;
>   	bdi->io_pages = VM_READAHEAD_PAGES;
>   	timer_setup(&bdi->laptop_mode_wb_timer, laptop_mode_timer_fn, 0);
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 72b0ff0d4bae..11f9a909e8de 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -3016,26 +3016,22 @@ bool __folio_end_writeback(struct folio *folio)
>   
>   	if (mapping && mapping_use_writeback_tags(mapping)) {
>   		struct inode *inode = mapping->host;
> -		struct backing_dev_info *bdi = inode_to_bdi(inode);
> +		struct bdi_writeback *wb = inode_to_wb(inode);
>   		unsigned long flags;
>   
>   		xa_lock_irqsave(&mapping->i_pages, flags);
>   		ret = folio_xor_flags_has_waiters(folio, 1 << PG_writeback);
>   		__xa_clear_mark(&mapping->i_pages, folio_index(folio),
>   					PAGECACHE_TAG_WRITEBACK);
> -		if (bdi->capabilities & BDI_CAP_WRITEBACK_ACCT) {
> -			struct bdi_writeback *wb = inode_to_wb(inode);
>   
> -			wb_stat_mod(wb, WB_WRITEBACK, -nr);
> -			__wb_writeout_add(wb, nr);
> -			if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
> -				wb_inode_writeback_end(wb);
> +		wb_stat_mod(wb, WB_WRITEBACK, -nr);
> +		__wb_writeout_add(wb, nr);
> +		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
> +			wb_inode_writeback_end(wb);
> +			if (mapping->host)
> +				sb_clear_inode_writeback(mapping->host);
>   		}
>   
> -		if (mapping->host && !mapping_tagged(mapping,
> -						     PAGECACHE_TAG_WRITEBACK))
> -			sb_clear_inode_writeback(mapping->host);
> -
>   		xa_unlock_irqrestore(&mapping->i_pages, flags);
>   	} else {
>   		ret = folio_xor_flags_has_waiters(folio, 1 << PG_writeback);
> @@ -3060,7 +3056,7 @@ void __folio_start_writeback(struct folio *folio, bool keep_write)
>   	if (mapping && mapping_use_writeback_tags(mapping)) {
>   		XA_STATE(xas, &mapping->i_pages, folio_index(folio));
>   		struct inode *inode = mapping->host;
> -		struct backing_dev_info *bdi = inode_to_bdi(inode);
> +		struct bdi_writeback *wb = inode_to_wb(inode);
>   		unsigned long flags;
>   		bool on_wblist;
>   
> @@ -3071,21 +3067,18 @@ void __folio_start_writeback(struct folio *folio, bool keep_write)
>   		on_wblist = mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK);
>   
>   		xas_set_mark(&xas, PAGECACHE_TAG_WRITEBACK);
> -		if (bdi->capabilities & BDI_CAP_WRITEBACK_ACCT) {
> -			struct bdi_writeback *wb = inode_to_wb(inode);
> -
> -			wb_stat_mod(wb, WB_WRITEBACK, nr);
> -			if (!on_wblist)
> -				wb_inode_writeback_start(wb);
> +		wb_stat_mod(wb, WB_WRITEBACK, nr);
> +		if (!on_wblist) {
> +			wb_inode_writeback_start(wb);
> +			/*
> +			 * We can come through here when swapping anonymous
> +			 * folios, so we don't necessarily have an inode to
> +			 * track for sync.
> +			 */
> +			if (mapping->host)
> +				sb_mark_inode_writeback(mapping->host);
>   		}
>   
> -		/*
> -		 * We can come through here when swapping anonymous
> -		 * folios, so we don't necessarily have an inode to
> -		 * track for sync.
> -		 */
> -		if (mapping->host && !on_wblist)
> -			sb_mark_inode_writeback(mapping->host);
>   		if (!folio_test_dirty(folio))
>   			xas_clear_mark(&xas, PAGECACHE_TAG_DIRTY);
>   		if (!keep_write)

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


