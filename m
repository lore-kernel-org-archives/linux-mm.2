Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AAB7E8305C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 07:40:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C5606B0095; Tue,  3 Feb 2026 02:40:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29D056B009B; Tue,  3 Feb 2026 02:40:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C9D56B009D; Tue,  3 Feb 2026 02:40:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A9AF6B0095
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:40:39 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B36A913A80A
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:40:38 +0000 (UTC)
X-FDA: 84402348156.14.647F764
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	by imf16.hostedemail.com (Postfix) with ESMTP id 30ABE180005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:40:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=AFf3iwO0;
	spf=pass (imf16.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.33 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770104436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3i42AQPiswee7v6oGNd7Mvy98fe3Jj+1YRuDJvSk26M=;
	b=SBOLIW/TFwQmiv4tuVJW3wVXnuKw48EENqqhN7LCtJMsdwPsOu2G1RbTPmMFWVKVvvf+m8
	JCGgLgkkdtBQFsou+rTm2Vn4JZJ6g9G10AGFQujfdBdCrQ3bijmeE3sfxeCJO38wxrtk16
	P8ZBtVZVHSIcJmqViP/5cMsRs6g4qsY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=AFf3iwO0;
	spf=pass (imf16.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.33 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770104436; a=rsa-sha256;
	cv=none;
	b=hEeBwiuJKrhCIEfeWDG95NFsPTdpES3Ig5oNQb+MkE7m1CAzqnStYJDqvkbivFqyZWJgnx
	6/edPHjDAH0dYXFbHovV9NyzuEdVecUZrcYUAE7O/jCASPEXZDiA6A5YX5M7jDuNGOv77k
	rMiJRVnOt/B0xe5t6LwPnaHjyoYZhVE=
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260203074031epoutp03ac1c65d0bd71d57b32aaeec95d637829~QrJomh9rU2745927459epoutp03I
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:40:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260203074031epoutp03ac1c65d0bd71d57b32aaeec95d637829~QrJomh9rU2745927459epoutp03I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1770104431;
	bh=3i42AQPiswee7v6oGNd7Mvy98fe3Jj+1YRuDJvSk26M=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=AFf3iwO0Kj+DXTMR/Wgb+/IvCdajP/R/nA9rkWojBJtQ17dF08adb0mmKPg2nGTpT
	 ZMAMuqckShdL7vqMWVdQowO+cNpqXani8sOs7VlWoPvIFqxtcYBqadprgJupf17rii
	 f/3H7ITTQQt9KCd3sE48y1Fotnv+Offc31e02TIM=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260203074030epcas5p42de397f727c1b41ad428522b9dd8d241~QrJn8FKKv2876728767epcas5p4n;
	Tue,  3 Feb 2026 07:40:30 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.91]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4f4wPn5Z5lz6B9mL; Tue,  3 Feb
	2026 07:40:29 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260203074028epcas5p22debb465f62585a9da0582f1c0c8c227~QrJmEnXRz3059230592epcas5p2a;
	Tue,  3 Feb 2026 07:40:28 +0000 (GMT)
Received: from [107.111.86.57] (unknown [107.111.86.57]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260203074025epsmtip2d3fda19efcf042063b8e8f9ff1cd1b27~QrJi_HYYn0567805678epsmtip2k;
	Tue,  3 Feb 2026 07:40:25 +0000 (GMT)
Message-ID: <1eb3e208-f207-4a04-adbd-9ca143c4f869@samsung.com>
Date: Tue, 3 Feb 2026 13:10:24 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] xfs: offload writeback by AG using per-inode
 dirty bitmap and per-AG workers
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com,
	dave@stgolabs.net, cem@kernel.org, wangyufei@vivo.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, anuj20.g@samsung.com,
	vishak.g@samsung.com, joshi.k@samsung.com
From: Kundan Kumar <kundan.kumar@samsung.com>
In-Reply-To: <20260129223421.GE7712@frogsfrogsfrogs>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260203074028epcas5p22debb465f62585a9da0582f1c0c8c227
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260116101305epcas5p497cd6d9027301853669f1c1aaffbf128
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	<CGME20260116101305epcas5p497cd6d9027301853669f1c1aaffbf128@epcas5p4.samsung.com>
	<20260116100818.7576-7-kundan.kumar@samsung.com>
	<20260129223421.GE7712@frogsfrogsfrogs>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 30ABE180005
X-Stat-Signature: u6jjqn513pzpnjbtjptn4w3rzqxxcadb
X-Rspam-User: 
X-HE-Tag: 1770104434-663523
X-HE-Meta: U2FsdGVkX1/DImnm5rdNQ0llQjvciiDpgoEh/ca5AnEW5AjPqmO/7WnopwudEu21t/PXkEHAL/jPiry+pVtMxqt4+VMrcQk0x+e1Hywon8/vfHnysuOlaE+LFfyxqiJ1Yz6ly7wg0T5dpiAUK7cdmfGtA3pRfnmnObX/cUzVXhje9xPbBtV7m/Ai5oUAXeJT12L4Re+3CDgmlmgB+biIkudxdY/3Fy6A/feEy6eXJ4Z2Z380rflrtshMjn990otv3MiGmv1z+eiRkWOj5FiR3NBwEpjR17QvbIyYLigXkRIBiB3a6x4o+nZCuDORC36t1soxeJxnhU9hjz9u5FQE+t8izmh8o9T514OZ49CtDPptBsjAFuXGwt8QTzvHzdicmAYaF4KkH2so9P6NfcMUhkp7xXzU+WTK1R3HGNCNmUv+8/WFEwOCHg0gNseFGhH/q33Qiv4IxOCOM4ntKpMmPhSiFZ9GcGf1qgZLuwviyquPvWgpZQJ1VqsOyytFymXoRDRzb3Rsxf7puneE+13k82KwPXTF1jUaIuGFF0p8oeHj5Z80oWetzJOtuNleATbrTJiashG6oIkY5jMgWvZrQi5iwrupXjpAS+jtIPIHP+uVuj5UEyTVPW1FNcrs3S+okywWjL5xWhoW/80RiuUI6yDrISaOtuZsQPGjcEse2kJVsLHjS80ZDa1Zo6n55Qovr0wyal0OUuA/cXeKrymCJplR/HTbLiFEqcF/OXdhxC3bOGsSp888OdJbeSPbSaYakJFlCefWOss7hVbI5uILEV61ycE55Tm4YS6j4uQJIcrwwQMnVAK3vTwlWyskvX8ElPohqjvwUg2KXssRE7kway4N25vAOeRAlQsRIl80M7S0QyKPdinBm7OQwzFtdjInVq421p0IGcEuiNlqkiPncECcMwF0cyt1C8Q6ZLcY4TvTpKgwGv+mSGxyQs1JK1awbWU9c50OTFU6mDShdIi
 2cTsTPsF
 IlMlEI8tv/xw+76O8MGvm3ZpbaaDEqaEt2V5bR9dh3H/9VmcL95TtSryCcBRe8lFm4hXI1q+z9V6rH7pyTjnZBoCHfYbjfT2R2b8Oll5yxeZtLTxtCFhWm8csJoJwxQWQdKrbGTmgbwljbCC9pKAHBFTPfQtnn5EpBbOjPRpAKnFHfiMWkVH9Wql0xktQRznTpt9FD5w2kTRTjY0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/30/2026 4:04 AM, Darrick J. Wong wrote:
> On Fri, Jan 16, 2026 at 03:38:18PM +0530, Kundan Kumar wrote:
>> Offload XFS writeback to per-AG workers based on the inode dirty-AG
>> bitmap. Each worker scans and submits writeback only for folios
>> belonging to its AG.
>>
>> Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
>> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
>> ---
>>   fs/xfs/xfs_aops.c | 178 ++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 178 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
>> index 9d5b65922cd2..55c3154fb2b5 100644
>> --- a/fs/xfs/xfs_aops.c
>> +++ b/fs/xfs/xfs_aops.c
>> @@ -678,6 +678,180 @@ xfs_zoned_writeback_submit(
>>   	return 0;
>>   }
>>   
>> +static bool xfs_agp_match(struct xfs_inode *ip, pgoff_t index,
>> +			  xfs_agnumber_t agno)
>> +{
>> +	void *ent;
>> +	u32 v;
>> +	bool match = false;
>> +
>> +	ent = xa_load(&ip->i_ag_pmap, index);
>> +	if (ent && xa_is_value(ent)) {
>> +		v = xa_to_value(ent);
>> +		if (xfs_agp_valid(v))
>> +			match = (xfs_agp_agno(v) == (u32)agno);
>> +	}
>> +
>> +	return match;
>> +}
>> +
>> +static bool xfs_folio_matches_ag(struct folio *folio, xfs_agnumber_t agno)
>> +{
>> +	struct xfs_inode *ip = XFS_I(folio_mapping(folio)->host);
>> +
>> +	return xfs_agp_match(ip, folio->index, agno);
>> +}
>> +
>> +static int xfs_writepages_ag(struct xfs_inode *ip,
>> +			     struct writeback_control *wbc,
>> +			     xfs_agnumber_t agno)
>> +{
>> +	struct inode *inode = VFS_I(ip);
>> +	struct address_space *mapping = inode->i_mapping;
>> +	struct folio_batch *fbatch = &wbc->fbatch;
>> +	int ret = 0;
>> +	pgoff_t index, end;
>> +
>> +	wbc->range_cyclic = 0;
>> +
>> +	folio_batch_init(fbatch);
>> +	index = wbc->range_start >> PAGE_SHIFT;
>> +	end = wbc->range_end >> PAGE_SHIFT;
>> +
>> +	struct xfs_writepage_ctx wpc = {
>> +		.ctx = {
>> +			.inode = inode,
>> +			.wbc = wbc,
>> +			.ops = &xfs_writeback_ops,
>> +		},
>> +	};
>> +
>> +	while (index <= end) {
>> +		int i, nr;
>> +
>> +		/* get a batch of DIRTY folios starting at index */
>> +		nr = filemap_get_folios_tag(mapping, &index, end,
>> +					    PAGECACHE_TAG_DIRTY, fbatch);
>> +		if (!nr)
>> +			break;
>> +
>> +		for (i = 0; i < nr; i++) {
>> +			struct folio *folio = fbatch->folios[i];
>> +
>> +			/* Filter BEFORE locking */
>> +			if (!xfs_folio_matches_ag(folio, agno))
> 
> So we grab a batch of dirty folios, and only /then/ check to see if
> they've been tagged with the target agno?  That doesn't seem very
> efficient if there are a lot of dirty folio and they're not evenly
> distributed among AGs.
> 

i_ag_dirty_bitmap is a hint populated at write time to indicate that an
inode likely has dirty folios tagged for AG X, so we only kick workers 
for AGs that should have work. That said, folios may not be evenly 
distributed across AGs, so a worker can still end up scanning and 
finding few or no matches in some cases.

>> +				continue;
>> +
>> +			folio_lock(folio);
>> +
>> +			/*
>> +			 * Now it's ours: clear dirty and submit.
>> +			 * This prevents *this AG worker* from seeing it again
>> +			 * next time.
>> +			 */
>> +			if (!folio_clear_dirty_for_io(folio)) {
>> +				folio_unlock(folio);
>> +				continue;
>> +			}
>> +			xa_erase(&ip->i_ag_pmap, folio->index);
> 
> Why erase the association?  Is this because once we've written the folio
> back to storage, we want a subsequent write to a fsblock within that
> folio to tag the folio with the agnumber of that fsblock?  Hrm, maybe
> that's how you deal with multi-fsblock folios; the folio tag reflects
> the first block to be dirtied within the folio?
> 

The primary reason for erasing the entry is to keep the metadata 
bounded, once the folio is written back and clean, there is no need to 
retain any AG association, so we drop it to free the per-folio state. On 
the next write, the folio is re-tagged based on the iomap for that write.

This also helps with multi-fsblock folios: by re-tagging on each 
clean->dirty transition.

>> +
>> +			ret = iomap_writeback_folio(&wpc.ctx, folio);
>> +			folio_unlock(folio);
>> +
>> +			if (ret) {
>> +				folio_batch_release(fbatch);
>> +				goto out;
>> +			}
>> +		}
>> +
>> +		folio_batch_release(fbatch);
>> +		cond_resched();
>> +	}
>> +
>> +out:
>> +	if (wpc.ctx.wb_ctx && wpc.ctx.ops && wpc.ctx.ops->writeback_submit)
>> +		wpc.ctx.ops->writeback_submit(&wpc.ctx, ret);
>> +
>> +	return ret;
>> +}
>> +
>> +static void xfs_ag_writeback_work(struct work_struct *work)
>> +{
>> +	struct xfs_ag_wb *awb = container_of(to_delayed_work(work),
>> +					     struct xfs_ag_wb, ag_work);
>> +	struct xfs_ag_wb_task *task;
>> +	struct xfs_mount *mp;
>> +	struct inode *inode;
>> +	struct xfs_inode *ip;
>> +	int ret;
>> +
>> +	for (;;) {
>> +		spin_lock(&awb->lock);
>> +		task = list_first_entry_or_null(&awb->task_list,
>> +						struct xfs_ag_wb_task, list);
>> +		if (task)
>> +			list_del_init(&task->list);
>> +		spin_unlock(&awb->lock);
>> +
>> +		if (!task)
>> +			break;
>> +
>> +		ip = task->ip;
>> +		mp = ip->i_mount;
>> +		inode = VFS_I(ip);
>> +
>> +		ret = xfs_writepages_ag(ip, &task->wbc, task->agno);
>> +
>> +		/* If didn't submit everything for this AG, set its bit */
>> +		if (ret)
>> +			set_bit(task->agno, ip->i_ag_dirty_bitmap);
>> +
>> +		iput(inode); /* drop igrab */
>> +		mempool_free(task, mp->m_ag_task_pool);
>> +	}
>> +}
>> +
>> +static int xfs_vm_writepages_offload(struct address_space *mapping,
>> +				     struct writeback_control *wbc)
>> +{
>> +	struct inode *inode = mapping->host;
>> +	struct xfs_inode *ip = XFS_I(inode);
>> +	struct xfs_mount *mp = ip->i_mount;
>> +	struct xfs_ag_wb *awb;
>> +	struct xfs_ag_wb_task *task;
>> +	xfs_agnumber_t agno;
>> +
>> +	if (!ip->i_ag_dirty_bits)
>> +		return 0;
>> +
>> +	for_each_set_bit(agno, ip->i_ag_dirty_bitmap, ip->i_ag_dirty_bits) {
>> +		if (!test_and_clear_bit(agno, ip->i_ag_dirty_bitmap))
>> +			continue;
>> +
>> +		task =  mempool_alloc(mp->m_ag_task_pool, GFP_NOFS);
> 
> Allocating memory (even from a mempool) during writeback makes me
> nervous...
> 

Agreed. We'll remove this allocation entirely. Instead of allocating an
xfs_ag_wb_task in ->writepages, we'll maintain a mount-wide list of 
"active" inodes (those with a non-empty dirty-AG hint). The offload path 
will only enqueue the inode on that list and kick the relevant AG workers.

Each AG worker will then walk the active inode list and scan the 
pagecache, filtering folios tagged for its AG and submitting IO. This 
keeps thewriteback path allocation-free and avoids mempool use under 
reclaim.

>> +		if (!task) {
>> +			set_bit(agno, ip->i_ag_dirty_bitmap);
>> +			continue;
>> +		}
> 
> ...because apparently the allocation can fail.  If so, then why don't we
> just fall back to serial writeback instead of ... moving on to the next
> AG and seeing if there's more memory?
> 
>> +
>> +		INIT_LIST_HEAD(&task->list);
>> +		task->ip = ip;
>> +		task->agno = agno;
>> +		task->wbc = *wbc;
>> +		igrab(inode); /* worker owns inode ref */
> 
> Shouldn't we check for a null return value here?  That should never
> happen, but we /do/ have the option of falling back to standard
> iomap_writepages.
> 

Yes I will fix this in next version.

>> +
>> +		awb = &mp->m_ag_wb[agno];
>> +
>> +		spin_lock(&awb->lock);
>> +		list_add_tail(&task->list, &awb->task_list);
>> +		spin_unlock(&awb->lock);
>> +
>> +		mod_delayed_work(mp->m_ag_wq, &awb->ag_work, 0);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>   static const struct iomap_writeback_ops xfs_zoned_writeback_ops = {
>>   	.writeback_range	= xfs_zoned_writeback_range,
>>   	.writeback_submit	= xfs_zoned_writeback_submit,
>> @@ -706,6 +880,7 @@ xfs_init_ag_writeback(struct xfs_mount *mp)
>>   	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
>>   		struct xfs_ag_wb *awb = &mp->m_ag_wb[agno];
>>   
>> +		INIT_DELAYED_WORK(&awb->ag_work, xfs_ag_writeback_work);
>>   		spin_lock_init(&awb->lock);
>>   		INIT_LIST_HEAD(&awb->task_list);
>>   		awb->agno = agno;
>> @@ -769,6 +944,9 @@ xfs_vm_writepages(
>>   			xfs_open_zone_put(xc.open_zone);
>>   		return error;
>>   	} else {
>> +		if (wbc->sync_mode != WB_SYNC_ALL)
>> +			return xfs_vm_writepages_offload(mapping, wbc);
>> +
>>   		struct xfs_writepage_ctx	wpc = {
>>   			.ctx = {
>>   				.inode	= mapping->host,
>> -- 
>> 2.25.1
>>
>>
> 


