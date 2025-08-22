Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE2BECA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 21:42:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2F718E000D; Fri, 22 Aug 2025 17:42:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE11F6B00EC; Fri, 22 Aug 2025 17:42:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF5BC8E000D; Fri, 22 Aug 2025 17:42:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9EB7E6B00E9
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:42:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4256458914
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 21:42:44 +0000 (UTC)
X-FDA: 83805718248.21.B20BF4A
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf30.hostedemail.com (Postfix) with ESMTP id 62CE280007
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 21:42:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=OmVyCrAa;
	spf=pass (imf30.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755898962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dx0ZmPP36PUthq9WgX18jt0ATxpXQol7Z82Al7MjsWY=;
	b=4cUkkc7a/KzYPYUNR9/9sb1G5onLt9/WMsg+/92yiIm0pk9K2alRMEVfyaRDMF2l+LtZQK
	xOAL+lRtbTbMIDKJ7lBv15a5oFieQvz0zi3qFRvpUFm0rk5F00l81s0/BfnUV+6NfqqGCg
	WJYkxPckbgqJPDb6t9N36ucOtuJ+om8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=OmVyCrAa;
	spf=pass (imf30.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755898962; a=rsa-sha256;
	cv=none;
	b=TpItznMWMtgth3fmHT1mfyx9yP3falcxh0pPyle35GIIiShiOgagNn2TwGTmPrlUbAKL+d
	a9ap5CQHJ2Yjiu6LlkNCdTl2ufzIO1GgzQaDirL1qZ7Kuz8u4b4cRMYX/RnXYLrZgUUA+c
	SaSynxeD1h3y4wk2UEpGSiMKOkC66Fo=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20250822214238euoutp029b6c89fa7385fccd7b8a5b07e384bca6~eNMzCjpr23123631236euoutp02o
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 21:42:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20250822214238euoutp029b6c89fa7385fccd7b8a5b07e384bca6~eNMzCjpr23123631236euoutp02o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1755898958;
	bh=Dx0ZmPP36PUthq9WgX18jt0ATxpXQol7Z82Al7MjsWY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OmVyCrAaFVEznrRnFPcMsVHGsbytQF4Kc6TLjJ5mxoOyng4aiNF9TvUSj4XO8+UQ0
	 AN/5h51AVJxBHQ2v0PjMnLbEDsN+xpWk4RoMSPYyS1LBNXN9HRT2RWxsVKjxn/FKnR
	 xe5+LOZv9Lbxmvt2g2/bwAUXByisnZg9sLi6pAHM=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20250822214238eucas1p16934a3c0a9575e6044b61e11f3635af0~eNMyasDET1601216012eucas1p1T;
	Fri, 22 Aug 2025 21:42:38 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250822214237eusmtip1fb955c175b6ebe784beb9e12ceb3ed1e~eNMxoaVER0144901449eusmtip1R;
	Fri, 22 Aug 2025 21:42:37 +0000 (GMT)
Message-ID: <2acaa457-2c9f-4285-8403-2896a152f929@samsung.com>
Date: Fri, 22 Aug 2025 23:42:36 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v2 2/2] mm: remove BDI_CAP_WRITEBACK_ACCT
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Joanne Koong <joannelkoong@gmail.com>, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, david@redhat.com, willy@infradead.org,
	linux-mm@kvack.org
Content-Language: en-US
In-Reply-To: <a91010a8-e715-4f3d-9e22-e4c34efc0408@samsung.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250822214238eucas1p16934a3c0a9575e6044b61e11f3635af0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20250822214238eucas1p16934a3c0a9575e6044b61e11f3635af0
X-EPHeader: CA
X-CMS-RootMailID: 20250822214238eucas1p16934a3c0a9575e6044b61e11f3635af0
References: <20250707234606.2300149-1-joannelkoong@gmail.com>
	<20250707234606.2300149-3-joannelkoong@gmail.com>
	<a91010a8-e715-4f3d-9e22-e4c34efc0408@samsung.com>
	<CGME20250822214238eucas1p16934a3c0a9575e6044b61e11f3635af0@eucas1p1.samsung.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 62CE280007
X-Stat-Signature: nnmr1d56t4bfdc64zp9hs8zdmyeiezko
X-Rspam-User: 
X-HE-Tag: 1755898961-752585
X-HE-Meta: U2FsdGVkX1/l+nXJh/M4rj5VbwJW7iH4FfBFgoz9keiJtUMI4ap6N0YfONGmGUpcsuWKObavucxiofbl0AvurWsH8fxVUwkva/wBnD6Np6RnW/lhXGQX4QU2dvVwckDBd6ysZ9W67BnQ/fC1Ry6h6W8U9tKQj/X6bBWH89B1Ct+tJRmC/zoN9YZPN2/abrHbvrEJu17dpXpOyGaucR0vZVukuVvUKZif7QBw1anTaxevbyU98Pmf1M45B8JuoGdp6SV76Mu9wdS5Nb5xQvfBvbl6/z+2a0IlLBQmxAt4m/gRntgWf/TlQ1kOu0/k+qir920dP+F2LH11aBBEMrNzX/vE4DQKusM6nt/JNXctu/ulQ1zc6leaciBIJMTP+nQoFfwwkcwTONnpcmkB65rO41Tufb+3kF/wm7TskdwNPIEQQWGl6eziVj5QN4O9UfsYfiox+X3btmSM3Cz5ec6gOQLqANGsdy9F/vabdSHFUH3dOwSmIJ5+lE9dhsEsaZbwkqef2BRhmgj5EAe5xtvpBmVElZ3WK30/xaDiEg54TsyGfYvyn1QC9/yRX6wa6W8SsVYpE72QaAScgJ/bWalYQylicERQ/omfIFlh1n26BmHp76D+tf33DcY9ntXaRde+nmowxMFFXCd7Ev/9YkXh2ADBwrgXuoP1ra61j47XHyIF+IGYIMEwOJYGFZ1pl4x9RYgOLfDfjzdOnPlBmMNyo9EHsWm0MCL0J7POgbAh6xCTrXIRF6X4aKg9lpryrCO6Eu2t6MwFcRlANlMeYq6YNYLVlSeZ/rYxVAfWedJuOG/p9+h0imd9ONwB+1cRmwCl1YB/NgTCfJO7nmGgrzRPL6cBwQyKZCLfChQNNcjFxeKnqzwhNXJMzo2bAOzJb+FZr8ylwiBmQVi8NxGP2+u4ND1RZgFxHGO1NTjp4A/lclWPnve3SrfrrZ8I3YK+04g5io5ZHDPdrgMPrRzkRtq
 a7WReM2a
 5WzqTuF8khDHVX9I5R4ibBTgYr0TflqnIfQTEoVWSEUVczmdcDdCtd8AATgH+whcvJc2CBVqnmi5T/6sSjDyacwEq4qrUb8vOTXBmgw3nhwvZfuJhpxmc3V9dO1A2L2U6tT8FrRTUgoC6IuIbpOuQ3dXg2JCcLhuJm/IX3IsKxWcB5xE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.08.2025 13:01, Marek Szyprowski wrote:
> On 08.07.2025 01:46, Joanne Koong wrote:
>> There are no users of BDI_CAP_WRITEBACK_ACCT now that fuse doesn't do
>> its own writeback accounting. This commit removes
>> BDI_CAP_WRITEBACK_ACCT.
>>
>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
>> Acked-by: David Hildenbrand <david@redhat.com>
>
> This patch landed recently in linux-next as commit 167f21a81a9c ("mm: 
> remove BDI_CAP_WRITEBACK_ACCT"). In my tests I found that it triggers 
> the ./include/linux/backing-dev.h:239 warning. Reverting $subject on 
> top of current linux-next fixes/hides this issue. Here is a detailed log:
>
> ------------[ cut here ]------------
> WARNING: ./include/linux/backing-dev.h:239 at 
> __folio_start_writeback+0x25a/0x26a, CPU#1: swapper/0/1
> Modules linked in:
> CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted 
> 6.17.0-rc2-next-20250822 #10852 NONE
> Hardware name: StarFive VisionFive 2 v1.2A (DT)
> epc : __folio_start_writeback+0x25a/0x26a
>  ra : __folio_start_writeback+0x258/0x26a
>
> [<ffffffff80202222>] __folio_start_writeback+0x25a/0x26a
> [<ffffffff802f3260>] __block_write_full_folio+0x124/0x39c
> [<ffffffff802f4b6e>] block_write_full_folio+0x8a/0xbc
> [<ffffffff804dbf42>] blkdev_writepages+0x3e/0x8a
> [<ffffffff802030fa>] do_writepages+0x78/0x11a
> [<ffffffff801f2e0e>] filemap_fdatawrite_wbc+0x4a/0x62
> [<ffffffff801f6d66>] __filemap_fdatawrite_range+0x52/0x78
> [<ffffffff801f6fdc>] filemap_write_and_wait_range+0x40/0x68
> [<ffffffff804dacae>] set_blocksize+0xd8/0x152
> [<ffffffff804dae18>] sb_min_blocksize+0x44/0xce
> [<ffffffff803a0c7a>] ext4_fill_super+0x182/0x2914
> [<ffffffff802a72e6>] get_tree_bdev_flags+0xf0/0x168
> [<ffffffff802a736c>] get_tree_bdev+0xe/0x16
> [<ffffffff8039a09e>] ext4_get_tree+0x14/0x1c
> [<ffffffff802a5062>] vfs_get_tree+0x1a/0xa4
> [<ffffffff802d17d4>] path_mount+0x23a/0x8ae
> [<ffffffff80c20cd4>] init_mount+0x4e/0x86
> [<ffffffff80c01622>] do_mount_root+0xe0/0x166
> [<ffffffff80c01814>] mount_root_generic+0x11e/0x2d6
> [<ffffffff80c02746>] initrd_load+0xf8/0x2b6
> [<ffffffff80c01d38>] prepare_namespace+0x150/0x258
> [<ffffffff80c01310>] kernel_init_freeable+0x2f2/0x316
> [<ffffffff80b6d896>] kernel_init+0x1e/0x13a
> [<ffffffff80012288>] ret_from_fork_kernel+0x14/0x208
> [<ffffffff80b79392>] ret_from_fork_kernel_asm+0x16/0x18
> irq event stamp: 159263
> hardirqs last  enabled at (159263): [<ffffffff805e7e4a>] 
> percpu_counter_add_batch+0xa6/0xda
> hardirqs last disabled at (159262): [<ffffffff805e7e40>] 
> percpu_counter_add_batch+0x9c/0xda
> softirqs last  enabled at (159248): [<ffffffff8002e972>] 
> handle_softirqs+0x3ca/0x462
> softirqs last disabled at (159241): [<ffffffff8002eb72>] 
> __irq_exit_rcu+0xe2/0x10c
> ---[ end trace 0000000000000000 ]---

I've played a bit with the code modified by the $subject patch and it 
looks that the following change fixes the issue, although I didn't 
analyze exactly where struct bdi_writeback is being modified:

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 99e80bdb3084..3887ac2e6475 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2984,7 +2984,7 @@ bool __folio_end_writeback(struct folio *folio)

         if (mapping && mapping_use_writeback_tags(mapping)) {
                 struct inode *inode = mapping->host;
-               struct bdi_writeback *wb = inode_to_wb(inode);
+               struct bdi_writeback *wb;
                 unsigned long flags;

                 xa_lock_irqsave(&mapping->i_pages, flags);
@@ -2992,6 +2992,7 @@ bool __folio_end_writeback(struct folio *folio)
                 __xa_clear_mark(&mapping->i_pages, folio_index(folio),
                                         PAGECACHE_TAG_WRITEBACK);

+               wb = inode_to_wb(inode);
                 wb_stat_mod(wb, WB_WRITEBACK, -nr);
                 __wb_writeout_add(wb, nr);
                 if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
@@ -3024,7 +3025,7 @@ void __folio_start_writeback(struct folio *folio, 
bool keep_write)
         if (mapping && mapping_use_writeback_tags(mapping)) {
                 XA_STATE(xas, &mapping->i_pages, folio_index(folio));
                 struct inode *inode = mapping->host;
-               struct bdi_writeback *wb = inode_to_wb(inode);
+               struct bdi_writeback *wb;
                 unsigned long flags;
                 bool on_wblist;

@@ -3035,6 +3036,7 @@ void __folio_start_writeback(struct folio *folio, 
bool keep_write)
                 on_wblist = mapping_tagged(mapping, 
PAGECACHE_TAG_WRITEBACK);

                 xas_set_mark(&xas, PAGECACHE_TAG_WRITEBACK);
+               wb = inode_to_wb(inode);
                 wb_stat_mod(wb, WB_WRITEBACK, nr);
                 if (!on_wblist) {
                         wb_inode_writeback_start(wb);


> ...

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


