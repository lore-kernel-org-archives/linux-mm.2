Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68F03E8305B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 07:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8E2F6B0089; Tue,  3 Feb 2026 02:21:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A62C96B008A; Tue,  3 Feb 2026 02:21:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 971406B008C; Tue,  3 Feb 2026 02:21:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 867076B0089
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:21:10 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36F1A14016E
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:21:10 +0000 (UTC)
X-FDA: 84402299100.05.8F2ED4D
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9DE0E40007
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:21:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=FtDqY0jO;
	spf=pass (imf04.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770103268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fU5UyW4TQBK4QZd2CbsYlFx1O86s7n1w5wLjdGsNZ+A=;
	b=pfdQvg2knn3Rlr5ytlxCQEIk8EHJNn92f03adktGR4YZ7g+aj0fHVsraApM7GihgKtaeUg
	BtTWA+U+zJmmNdrTdYqQWHDw0M/eAVuPviKwhIf3JW1ke4p0wvwG7r+hLxoVVWZSXMHzaN
	UaFZlIxtIDFWVo3PDbmGeZiXuDjMp6Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=FtDqY0jO;
	spf=pass (imf04.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770103268; a=rsa-sha256;
	cv=none;
	b=CPih82GXPvLysbmN9r0cpUjJmIg/+LSAnV9uRjRxFfp1TqtljFf8Xch6mbhvsavDwJcoaq
	b5DrrjbjuDz2F2fKflaJ0gYNs/Jm44BORZ7lVTwj1tvNSLtSFL4ITEtB5H39KgJg17iAGS
	MmtYQVBPUWBW3wFOMU6drvXXLryTVV0=
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260203072102epoutp023cffbcfea87708da5934d5456f12259e~Qq4oCU7aM1240212402epoutp028
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:21:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260203072102epoutp023cffbcfea87708da5934d5456f12259e~Qq4oCU7aM1240212402epoutp028
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1770103262;
	bh=fU5UyW4TQBK4QZd2CbsYlFx1O86s7n1w5wLjdGsNZ+A=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=FtDqY0jO+eLa9u3h4UKS4StbEmZBUfqc82VxuvSvynZ87jXBtdJdPE0cdFrSNgzuL
	 +enY5i3DeVdavugczdsrGAGQTyJ43A/YArU8TGkKv/icsvI1Yq/CFk11BBVE/Vs9ka
	 1oPd9b94SHLzqaVX5Vkx084Q68WSxqOTpLbSuXNo=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260203072102epcas5p1c5d76f538d2ab9b98fc1da3fc8f740ca~Qq4nc4qhl2896128961epcas5p11;
	Tue,  3 Feb 2026 07:21:02 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.90]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4f4vzJ60CMz6B9mX; Tue,  3 Feb
	2026 07:21:00 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260203072100epcas5p1a872be2e07362e5a2206231d7bf44630~Qq4lnf84l1044110441epcas5p1U;
	Tue,  3 Feb 2026 07:21:00 +0000 (GMT)
Received: from [107.111.86.57] (unknown [107.111.86.57]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260203072054epsmtip25565e34a3716ee5a6822dcc5c6176bb6~Qq4gwBjnd2486424864epsmtip2i;
	Tue,  3 Feb 2026 07:20:54 +0000 (GMT)
Message-ID: <2c485586-83c9-4697-91fc-7b0cee697704@samsung.com>
Date: Tue, 3 Feb 2026 12:50:53 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] xfs: add per-inode AG prediction map and
 dirty-AG bitmap
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
In-Reply-To: <20260129004404.GA7712@frogsfrogsfrogs>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260203072100epcas5p1a872be2e07362e5a2206231d7bf44630
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260116101251epcas5p1cf5b48f2efb14fe4387be3053b3c3ebc
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	<CGME20260116101251epcas5p1cf5b48f2efb14fe4387be3053b3c3ebc@epcas5p1.samsung.com>
	<20260116100818.7576-4-kundan.kumar@samsung.com>
	<20260129004404.GA7712@frogsfrogsfrogs>
X-Rspamd-Server: rspam12
X-Stat-Signature: unnpey73eppobun1da3xwrpnxx7hsp6f
X-Rspamd-Queue-Id: 9DE0E40007
X-Rspam-User: 
X-HE-Tag: 1770103266-941109
X-HE-Meta: U2FsdGVkX1+f1v2etnlLsCH6Iu+d8fyPsLLhys54HVUnDPYzpUiyHT1pUgT3+FIp0DYKtFTq3Wo8E/VvgBBKN4rnpw0KIxR8UVTCgZI/0TH8R9OQN9sqiuUTEzDaH+GL7/i0TvKguW8bUV9u99+O+kpUj3rdANxEp7nLP9a/g5UJ3V0BtVQpo+1C8WBvZwGq9Q8IRCJ55WiEdnzcawWOjg3ezkHG/gefk7BCEGRUfARUNC5tMP4i1oXkxE26DH+4oDrIWHikw6/1KvBogIv7AgMg4Yhh03SKCig9SeN8+1qdAhMo5QMt8t1x77os4mbFcKAi7e1LyiqUspMOcVnhHqTWgahwxjfAhjCL+aF1qBhX8n3L+UvT3427bx9kVkCIJcqlaU73VTgAtCjLw55RImRvlTsu++nWvZDvkrrW3fe9gz4bl4+nIZWlrvec+CGZtgmQNXZoqwSJ/KjJw/R0U7KL40vvhHq9CY2U/0pr4SBMFhy9Jq9HtTUXTAsbgUKg6V1H+p2T5HlFkdUhAUX3FhJ+ue0DDisLpaglyuGSuS0uExGMEQYTUsdocB1aXVL8YVOiYlrUbcOzpmlypdOujIAIdAmj6tYuETM2kpiQkkDVTgrtq9IHPqRp/qc7RK/opBAqvgN3IZnitoye+ky9iUA8Qzc7P7zoPMVTrGa7x3x4mR8Ckc5Rz1VzmB2nmoXeRQM9cg8sPMnmTeGRK0lmQc1TxO159fy3vYELn/AZ/9PDhvxgZNwd2W7cI7tHq6RZ5o1YN42/J3wFhe6nPvrE3id3gwOdT/OF0TchR5Qk8B56UYS+eWQTj0e8hvzJ+LgdrRGipZ4ovTbNJ2eIy3JT/ttsFyM1tT4dZhMitYd9C4Q1nT7z8aRap49/86IE+vUv/sJjzWljAuik7JJL6jn/FcDhhswrLpZrncKIewrDpjQjtCxLDjDnIOzZe0VgKySa+ZgmWqE4TvJ0I8KvBFi
 CUdAiy+r
 0K8cJyBttqefSrXxp8ZQ7f6dEFzt8hgf/a/91ilQoHdxkBaSD2EjvXDh3tou2gEYSzH+GonvWlA71rwy4+qCM8/V5Re0Yufi+coqjyPMNn9EDPdTsgmFosd88a2YMZm+huKf0vX8WFzhdB5TX5ggtxpBrnGylcuDCixd/I7hY80umymTBDHzqGAuNdBip00sE190LFRn3WrXj5+0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/29/2026 6:14 AM, Darrick J. Wong wrote:
> On Fri, Jan 16, 2026 at 03:38:15PM +0530, Kundan Kumar wrote:
>> Add per-inode structures to track predicted AGs of dirty folios using
>> an xarray and bitmap. This enables efficient identification of AGs
>> involved in writeback.
>>
>> Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
>> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
>> ---
>>   fs/xfs/xfs_icache.c | 27 +++++++++++++++++++++++++++
>>   fs/xfs/xfs_inode.h  |  5 +++++
>>   2 files changed, 32 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
>> index e44040206851..f97aa6d66271 100644
>> --- a/fs/xfs/xfs_icache.c
>> +++ b/fs/xfs/xfs_icache.c
>> @@ -80,6 +80,25 @@ static inline xa_mark_t ici_tag_to_mark(unsigned int tag)
>>   	return XFS_PERAG_BLOCKGC_MARK;
>>   }
>>   
>> +static int xfs_inode_init_ag_bitmap(struct xfs_inode *ip)
>> +{
>> +	unsigned int bits = ip->i_mount->m_sb.sb_agcount;
>> +	unsigned int nlongs;
>> +
>> +	xa_init_flags(&ip->i_ag_pmap, XA_FLAGS_LOCK_IRQ);
> 
> This increases the size of struct xfs_inode by 40 bytes...
> 

I’ll make this lazy and sparse: move AG writeback state behind a pointer
allocated on first use, and replace the bitmap with a sparse dirty-AG
set(xarray keyed by agno) so memory scales with AGs actually touched by
the inode.

>> +	ip->i_ag_dirty_bitmap = NULL;
>> +	ip->i_ag_dirty_bits = bits;
>> +
>> +	if (!bits)
>> +		return 0;
>> +
>> +	nlongs = BITS_TO_LONGS(bits);
>> +	ip->i_ag_dirty_bitmap = kcalloc(nlongs, sizeof(unsigned long),
>> +					GFP_NOFS);
> 
> ...and there could be hundreds or thousands of AGs for each filesystem.
> That's a lot of kernel memory to handle this prediction stuff, and I"m
> not even sure what ag_dirty_bitmap does yet.
> 

The bit for an AG is set in ag_dirty_bitmap at write time. During
writeback, we check which AG bits are set, wake only those AG-specific
workers, and each worker scans the page cache, filters folios tagged for
its AG, and submits the I/O.

>> +
>> +	return ip->i_ag_dirty_bitmap ? 0 : -ENOMEM;
>> +}
>> +
>>   /*
>>    * Allocate and initialise an xfs_inode.
>>    */
>> @@ -131,6 +150,8 @@ xfs_inode_alloc(
>>   	ip->i_next_unlinked = NULLAGINO;
>>   	ip->i_prev_unlinked = 0;
>>   
>> +	xfs_inode_init_ag_bitmap(ip);
> 
> Unchecked return value???

Will correct in next version

> 
>> +
>>   	return ip;
>>   }
>>   
>> @@ -194,6 +215,12 @@ xfs_inode_free(
>>   	ip->i_ino = 0;
>>   	spin_unlock(&ip->i_flags_lock);
>>   
>> +	/* free xarray contents (values are immediate packed ints) */
>> +	xa_destroy(&ip->i_ag_pmap);
>> +	kfree(ip->i_ag_dirty_bitmap);
>> +	ip->i_ag_dirty_bitmap = NULL;
>> +	ip->i_ag_dirty_bits = 0;
>> +
>>   	__xfs_inode_free(ip);
>>   }
>>   
>> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
>> index bd6d33557194..dee449168605 100644
>> --- a/fs/xfs/xfs_inode.h
>> +++ b/fs/xfs/xfs_inode.h
>> @@ -99,6 +99,11 @@ typedef struct xfs_inode {
>>   	spinlock_t		i_ioend_lock;
>>   	struct work_struct	i_ioend_work;
>>   	struct list_head	i_ioend_list;
>> +
>> +	/* AG prediction map: pgoff_t -> packed u32 */
> 
> What about blocksize < pagesize filesystems?  Which packed agno do you
> associate with the pgoff_t?
> 
> Also, do you have an xarray entry for each pgoff_t in a large folio?
> 
> --D
> 

pgoff_t here is the pagecache index (folio->index), i.e. file offset in
PAGE_SIZE units, not a filesystem block index. So blocksize < PAGE_SIZE
doesn’t change the association, the packed agno is attached to the folio
at that pagecache index.

We store one xarray entry per folio index (the start of the folio). We 
do not create entries for each base-page inside a large folio. If a 
large folio could span multiple extents/AGs, we’ll treat the hint as 
advisory and tag it invalid (fallback to normal writeback routing) 
rather than trying to encode per-subpage AGs.

>> +	struct xarray           i_ag_pmap;
>> +	unsigned long           *i_ag_dirty_bitmap;
>> +	unsigned int            i_ag_dirty_bits;
>>   } xfs_inode_t;
>>   
>>   static inline bool xfs_inode_on_unlinked_list(const struct xfs_inode *ip)
>> -- 
>> 2.25.1
>>
>>
> 


