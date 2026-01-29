Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3D7FD73E9B
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 22:34:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 336526B00A8; Thu, 29 Jan 2026 17:34:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0AD6B00AA; Thu, 29 Jan 2026 17:34:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20D526B00AB; Thu, 29 Jan 2026 17:34:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0F2FE6B00A8
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:34:25 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A4137160319
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:34:24 +0000 (UTC)
X-FDA: 84386456448.10.3442D41
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id E39DBC0019
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:34:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k3aIfBKU;
	spf=pass (imf28.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769726063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+sL552rFOPX6MZmF9xhCboTgoxHpoeG/bwKtIJk/3Cc=;
	b=1rIAQXCO7eehjWZS4vHq8m3u27zr/VpY4AB1wKdoEdOu7gHzBsRwjqBf75HKEeiPaA/aKs
	HeyoBsgN6+DrOrjo3MOSxqWdqMxSJx3MjKzs6LSQtQyPIj79ir4+nINT9kWzbF5fWVByyr
	M6u/5V5/GPMXZCqpST1tjIJUGy9+N8U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k3aIfBKU;
	spf=pass (imf28.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769726063; a=rsa-sha256;
	cv=none;
	b=ABAs9C5xnmiWImgVnA6AYMWjmB/UyGX4Pncd+5xwI8NyzJt1PQKGBcUH1C95YzlbJ8nvYL
	pgTktWOtjY5mo7AXodAeI2M6rrCAG8YE7Dx3vJbfgE358lCgj0vcjicarcSJJ3/ip914z4
	j1GIfzvh+86wgHI+6Kt8Qv7pvKQU3m4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E6C2E41684;
	Thu, 29 Jan 2026 22:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D07C4CEF7;
	Thu, 29 Jan 2026 22:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769726061;
	bh=aAsAQr3olCVAPwtnbMv+uKrBk9dB7Xxlgu3OYuVbFgw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k3aIfBKUpMQTLAl18ZSlFFxyK4de6DV6bM0MJut9fsQbs+B9SUiM6sLpiQU5BnYg+
	 z5ZvLpTOEPD/o3Fi+TxkwSedlZosqXCT/XVjDugwguNV4l1BnIlmnp391M4iznR328
	 KMnY1pNfZgbSDdJRIbiRhXmXnU8xKLhYj5xXdtKRS7rS4aPcRgt891nTs3fglhJgIb
	 i0NEPceT8Sls/IB5ieb9pRBK/Hanu40d1jM2QvvjGK6dODI9fuaH6v8IahNbWKxJEX
	 sAEtBzUPuoBDLG+OIrSEg7744r0fgIA+M/8QS1tg8SXJqpSe1qeoqLtNX0wL3C0keg
	 IVk930WXDnc2A==
Date: Thu, 29 Jan 2026 14:34:21 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com,
	david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
	hch@lst.de, ritesh.list@gmail.com, dave@stgolabs.net,
	cem@kernel.org, wangyufei@vivo.com, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v3 6/6] xfs: offload writeback by AG using per-inode
 dirty bitmap and per-AG workers
Message-ID: <20260129223421.GE7712@frogsfrogsfrogs>
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
 <CGME20260116101305epcas5p497cd6d9027301853669f1c1aaffbf128@epcas5p4.samsung.com>
 <20260116100818.7576-7-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116100818.7576-7-kundan.kumar@samsung.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: pmi9nni1ikr985h6dm8wnzaaxwygu8uk
X-Rspamd-Queue-Id: E39DBC0019
X-Rspam-User: 
X-HE-Tag: 1769726062-97536
X-HE-Meta: U2FsdGVkX19N5B939UeuEkygSxk7dZmqJnrsrNcxt9F8O5QfWEfWUHcrKwpuxQxDB+6tWG2UnVqXTmJkWknTMd3j6GpwvtXahmMBEH14Rd8JA9QO9VvrvHsImN5C6cHWb6P8A1A9vR39xxriJ4YPgaHBBlcQJ+6oGn3isARo/jcBVWVQmBjHo2Rfwz7ksS3nyFf5QZMfL2CGVNpHRS7SJN5V2JEcO0H09l5dFfKc+O+D8Ft50mGVmrEJT/4B75FZOojYZ9Xqz0JtPje7OedNqc0xyUri+mSY2R0eFauwSN3+vIiGf52tMDLxfU/wvvEb8vX8juLXFncDLdXcK0haQ7CEnsl7BkV7QhcTm1mMbErgd/fGglvIa8+810F5QFWFmPZts6HWkZReC+IhSqUx7XW5ldFq1PmIHHkE78VVaQT63v2voZnhKCTNyPAZfeoTHfmDliApqQkzzbHAHZDvWgRM/QAELO0AvbxllU+oFlDam5rb53pZkDGVFp3d3u3Tu3cdNlCw3d5qtUqg+1kYCFNRM4NU1xE4hOak9BB+6TNnqIphWpJcsO4yuoTPzD+6qn2G11nPNDwgsVat9EbDuAX0m/QeYe18HZ0YzMgm3biYW7EsFWfB3xs2WjGsAzGWLf4OVn+3p9NeRrjV0qGbZYGzFOzcbtgaSERv2EeS12jwUZJvgpVyDlwrz6+G/0GBbQHYkOibkMEXX3V1tlg7yGIcQTkV0EVLq31d+gG5PCt5k358S4G9Eo0IVb0uuQljompQmm0T6hXp3XT0239yxOwvz3K65IkutTOFQPIKnZEjskOygEEU4tK03gHgzqrKE+JpT5A2jRc9DPSTOMXprU1AOMuyrzDaxGCKKPggg2Kxqg0p02IMgVw55nwc+vLW4UfIrtFulWrnzXB1cHVRcnrE2YmpffukBQ5VYV3Hk4dk9qoHYI/55WRIc6Gx/Wueg6mnP0WxNNb/yZDXOCn
 kp3F9rii
 HF9piQMHo+4ce2nkEAk6voGIwmooedkAHVcq/ofRTFpKbjBwcCzCTTzNxtR+tYGkjzIahSXJNQciI2Bsr7jBZ9+j9aKwfr/lCIxESiZofyQDM2WjmVWTjvTaM3ZEROzeofNZHOJXqhD21FwPZkyVfCCrzONjtc4ffH1wWAh7OkdULMtYLjSdKJt8CGGri2JQffhhmaQtYexRR7FvQJQxQtJzlUKHmeGq2L7Qb2pIxgYN4lKg+nmgxdfdphIhOR0SI1Dz/+KxMr6J4ZSG97xrg5xrAwtPxUsv9OGHd+V+6bhvkeRV9ZJMEfm5qYDVK8pxI9a/dy059VriZJ5punvaLXWCDLvtavzZeW2Ht
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:38:18PM +0530, Kundan Kumar wrote:
> Offload XFS writeback to per-AG workers based on the inode dirty-AG
> bitmap. Each worker scans and submits writeback only for folios
> belonging to its AG.
> 
> Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>  fs/xfs/xfs_aops.c | 178 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 178 insertions(+)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 9d5b65922cd2..55c3154fb2b5 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -678,6 +678,180 @@ xfs_zoned_writeback_submit(
>  	return 0;
>  }
>  
> +static bool xfs_agp_match(struct xfs_inode *ip, pgoff_t index,
> +			  xfs_agnumber_t agno)
> +{
> +	void *ent;
> +	u32 v;
> +	bool match = false;
> +
> +	ent = xa_load(&ip->i_ag_pmap, index);
> +	if (ent && xa_is_value(ent)) {
> +		v = xa_to_value(ent);
> +		if (xfs_agp_valid(v))
> +			match = (xfs_agp_agno(v) == (u32)agno);
> +	}
> +
> +	return match;
> +}
> +
> +static bool xfs_folio_matches_ag(struct folio *folio, xfs_agnumber_t agno)
> +{
> +	struct xfs_inode *ip = XFS_I(folio_mapping(folio)->host);
> +
> +	return xfs_agp_match(ip, folio->index, agno);
> +}
> +
> +static int xfs_writepages_ag(struct xfs_inode *ip,
> +			     struct writeback_control *wbc,
> +			     xfs_agnumber_t agno)
> +{
> +	struct inode *inode = VFS_I(ip);
> +	struct address_space *mapping = inode->i_mapping;
> +	struct folio_batch *fbatch = &wbc->fbatch;
> +	int ret = 0;
> +	pgoff_t index, end;
> +
> +	wbc->range_cyclic = 0;
> +
> +	folio_batch_init(fbatch);
> +	index = wbc->range_start >> PAGE_SHIFT;
> +	end = wbc->range_end >> PAGE_SHIFT;
> +
> +	struct xfs_writepage_ctx wpc = {
> +		.ctx = {
> +			.inode = inode,
> +			.wbc = wbc,
> +			.ops = &xfs_writeback_ops,
> +		},
> +	};
> +
> +	while (index <= end) {
> +		int i, nr;
> +
> +		/* get a batch of DIRTY folios starting at index */
> +		nr = filemap_get_folios_tag(mapping, &index, end,
> +					    PAGECACHE_TAG_DIRTY, fbatch);
> +		if (!nr)
> +			break;
> +
> +		for (i = 0; i < nr; i++) {
> +			struct folio *folio = fbatch->folios[i];
> +
> +			/* Filter BEFORE locking */
> +			if (!xfs_folio_matches_ag(folio, agno))

So we grab a batch of dirty folios, and only /then/ check to see if
they've been tagged with the target agno?  That doesn't seem very
efficient if there are a lot of dirty folio and they're not evenly
distributed among AGs.

> +				continue;
> +
> +			folio_lock(folio);
> +
> +			/*
> +			 * Now it's ours: clear dirty and submit.
> +			 * This prevents *this AG worker* from seeing it again
> +			 * next time.
> +			 */
> +			if (!folio_clear_dirty_for_io(folio)) {
> +				folio_unlock(folio);
> +				continue;
> +			}
> +			xa_erase(&ip->i_ag_pmap, folio->index);

Why erase the association?  Is this because once we've written the folio
back to storage, we want a subsequent write to a fsblock within that
folio to tag the folio with the agnumber of that fsblock?  Hrm, maybe
that's how you deal with multi-fsblock folios; the folio tag reflects
the first block to be dirtied within the folio?

> +
> +			ret = iomap_writeback_folio(&wpc.ctx, folio);
> +			folio_unlock(folio);
> +
> +			if (ret) {
> +				folio_batch_release(fbatch);
> +				goto out;
> +			}
> +		}
> +
> +		folio_batch_release(fbatch);
> +		cond_resched();
> +	}
> +
> +out:
> +	if (wpc.ctx.wb_ctx && wpc.ctx.ops && wpc.ctx.ops->writeback_submit)
> +		wpc.ctx.ops->writeback_submit(&wpc.ctx, ret);
> +
> +	return ret;
> +}
> +
> +static void xfs_ag_writeback_work(struct work_struct *work)
> +{
> +	struct xfs_ag_wb *awb = container_of(to_delayed_work(work),
> +					     struct xfs_ag_wb, ag_work);
> +	struct xfs_ag_wb_task *task;
> +	struct xfs_mount *mp;
> +	struct inode *inode;
> +	struct xfs_inode *ip;
> +	int ret;
> +
> +	for (;;) {
> +		spin_lock(&awb->lock);
> +		task = list_first_entry_or_null(&awb->task_list,
> +						struct xfs_ag_wb_task, list);
> +		if (task)
> +			list_del_init(&task->list);
> +		spin_unlock(&awb->lock);
> +
> +		if (!task)
> +			break;
> +
> +		ip = task->ip;
> +		mp = ip->i_mount;
> +		inode = VFS_I(ip);
> +
> +		ret = xfs_writepages_ag(ip, &task->wbc, task->agno);
> +
> +		/* If didn't submit everything for this AG, set its bit */
> +		if (ret)
> +			set_bit(task->agno, ip->i_ag_dirty_bitmap);
> +
> +		iput(inode); /* drop igrab */
> +		mempool_free(task, mp->m_ag_task_pool);
> +	}
> +}
> +
> +static int xfs_vm_writepages_offload(struct address_space *mapping,
> +				     struct writeback_control *wbc)
> +{
> +	struct inode *inode = mapping->host;
> +	struct xfs_inode *ip = XFS_I(inode);
> +	struct xfs_mount *mp = ip->i_mount;
> +	struct xfs_ag_wb *awb;
> +	struct xfs_ag_wb_task *task;
> +	xfs_agnumber_t agno;
> +
> +	if (!ip->i_ag_dirty_bits)
> +		return 0;
> +
> +	for_each_set_bit(agno, ip->i_ag_dirty_bitmap, ip->i_ag_dirty_bits) {
> +		if (!test_and_clear_bit(agno, ip->i_ag_dirty_bitmap))
> +			continue;
> +
> +		task =  mempool_alloc(mp->m_ag_task_pool, GFP_NOFS);

Allocating memory (even from a mempool) during writeback makes me
nervous...

> +		if (!task) {
> +			set_bit(agno, ip->i_ag_dirty_bitmap);
> +			continue;
> +		}

...because apparently the allocation can fail.  If so, then why don't we
just fall back to serial writeback instead of ... moving on to the next
AG and seeing if there's more memory?

> +
> +		INIT_LIST_HEAD(&task->list);
> +		task->ip = ip;
> +		task->agno = agno;
> +		task->wbc = *wbc;
> +		igrab(inode); /* worker owns inode ref */

Shouldn't we check for a null return value here?  That should never
happen, but we /do/ have the option of falling back to standard
iomap_writepages.

> +
> +		awb = &mp->m_ag_wb[agno];
> +
> +		spin_lock(&awb->lock);
> +		list_add_tail(&task->list, &awb->task_list);
> +		spin_unlock(&awb->lock);
> +
> +		mod_delayed_work(mp->m_ag_wq, &awb->ag_work, 0);
> +	}
> +
> +	return 0;
> +}
> +
>  static const struct iomap_writeback_ops xfs_zoned_writeback_ops = {
>  	.writeback_range	= xfs_zoned_writeback_range,
>  	.writeback_submit	= xfs_zoned_writeback_submit,
> @@ -706,6 +880,7 @@ xfs_init_ag_writeback(struct xfs_mount *mp)
>  	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
>  		struct xfs_ag_wb *awb = &mp->m_ag_wb[agno];
>  
> +		INIT_DELAYED_WORK(&awb->ag_work, xfs_ag_writeback_work);
>  		spin_lock_init(&awb->lock);
>  		INIT_LIST_HEAD(&awb->task_list);
>  		awb->agno = agno;
> @@ -769,6 +944,9 @@ xfs_vm_writepages(
>  			xfs_open_zone_put(xc.open_zone);
>  		return error;
>  	} else {
> +		if (wbc->sync_mode != WB_SYNC_ALL)
> +			return xfs_vm_writepages_offload(mapping, wbc);
> +
>  		struct xfs_writepage_ctx	wpc = {
>  			.ctx = {
>  				.inode	= mapping->host,
> -- 
> 2.25.1
> 
> 

