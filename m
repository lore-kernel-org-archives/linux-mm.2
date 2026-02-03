Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18BFAE8305B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 07:35:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5284D6B0096; Tue,  3 Feb 2026 02:35:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D64B6B0098; Tue,  3 Feb 2026 02:35:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E22F6B0099; Tue,  3 Feb 2026 02:35:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2A0336B0096
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:35:31 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DA01E58B58
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:35:30 +0000 (UTC)
X-FDA: 84402335220.02.18B58C8
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3E09480006
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:35:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=hR2XnZHt;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf02.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770104128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5e6l+frt0X8jsKW5wcAhHw0CC1saut3jeRxaRHbnCOM=;
	b=wqFS0Mu/z/ufM/J16Pu6BCXb7gYOc8OTfQlFLc0SEEPWWr05YHNssyfJeIiaSB3UFzQwGB
	0pAJv7ZmhKvZTfkN5OxiGlL0y3skEa8k1sANeCnEq8XYH11DRqN0mrh1bcht1iTHmW4b3O
	RS4cYorsaCxnlTnpPcV3hsPpzdqMGvE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770104128; a=rsa-sha256;
	cv=none;
	b=MP+EDdcE8+wia/z9wgp9XTmUHLCfhWsqPO/NuFf0Kp927OlG3k7XjOLnPSaqw/Smb9UOsZ
	R5lSWkIJ/Mj6i5VG85414whdQDlL/MZU7AMnZBp9mzPUa8EcjJcmKGlqmi4HmsHlF6erfB
	X2+1F1Er1n1qc8JF3BJ2HafNJg46xw0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=hR2XnZHt;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf02.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260203073523epoutp016ff62764bf216a77324cc5992c32fb89~QrFJsEjrM2136121361epoutp01n
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:35:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260203073523epoutp016ff62764bf216a77324cc5992c32fb89~QrFJsEjrM2136121361epoutp01n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1770104123;
	bh=5e6l+frt0X8jsKW5wcAhHw0CC1saut3jeRxaRHbnCOM=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=hR2XnZHt1/E9zyyYvMnjL9UQKz/Q6HrF62DpNi5qUc6/IwAknWhmEvzCe2dUv/6u+
	 6dVXuGHDoWE94MKy9ct38OSi2jMQi+XrFwcyrDsGh9l91lWgtYJp0+0dQTJQt50+t5
	 1Q3DxF6KcLBmqeHNITIxPJVsiS7zgjt9CvuPpbU0=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260203073522epcas5p1196f2ef31bd5d09ffc122e3292a51d6d~QrFI0NeqS1880218802epcas5p1z;
	Tue,  3 Feb 2026 07:35:22 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.86]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4f4wHs3rjGz3hhTB; Tue,  3 Feb
	2026 07:35:21 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260203073520epcas5p10baf65c36e6deea9e7d4c25b68fbaee6~QrFHDTkG11658116581epcas5p10;
	Tue,  3 Feb 2026 07:35:20 +0000 (GMT)
Received: from [107.111.86.57] (unknown [107.111.86.57]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260203073517epsmtip223831a9695b31985fb20f435698e6c08~QrFD3QvYH0291302913epsmtip2S;
	Tue,  3 Feb 2026 07:35:17 +0000 (GMT)
Message-ID: <d0365256-43d1-4701-9175-5391755dc45e@samsung.com>
Date: Tue, 3 Feb 2026 13:05:16 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] xfs: add per-AG writeback workqueue
 infrastructure
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
In-Reply-To: <20260129222101.GD7712@frogsfrogsfrogs>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260203073520epcas5p10baf65c36e6deea9e7d4c25b68fbaee6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260116101259epcas5p1cfa6ab02e5a01f7c46cc78df95c57ce0
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	<CGME20260116101259epcas5p1cfa6ab02e5a01f7c46cc78df95c57ce0@epcas5p1.samsung.com>
	<20260116100818.7576-6-kundan.kumar@samsung.com>
	<20260129222101.GD7712@frogsfrogsfrogs>
X-Rspamd-Queue-Id: 3E09480006
X-Stat-Signature: hhf1fjejcjas18p4dnjsoz7ffa3tfdg4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770104126-762626
X-HE-Meta: U2FsdGVkX184hCPbFb29M45+iToOmRlrx/X8HUVWEsKjFxJ4fSOjvpmR/bLk6UY0vFxfmjln4f3ioBrZK4cWbyrEW8AsIZoV+OS0JY6rFd0YE9rGLA02BSTYAnJ5aEOfoKsXfnC3oW7Un3gVrax3Orli4M17l9X+lfsxBcyP+7agcHc0Elz36zbMFdNtYPtj18Owt1KMYvnJYfOYDJ8EjMRRenw+FSvl5ZEJxx8Ly6uvLsVAGE/SqzCOeP6sr7ZSarEhwwahdEmshFvjzumkExlJa25kgY8wxYVA7bzT6luAyYHiWMk1Bi4+Wduw5IWdk/s6mlMQTmo1q1CjTiBu1NqO/SJozdVBL/Qxu+BT2e0MuS8vNEryWaOWYqCANpt6gZQUwke3sDsssnGCx50hEFojx8OfcNaeJSzgSoBZkJmX9s+fTAiKCLjsr7T5GJx/MPVTDQf2NsFB256Gd5LtSXQrfdnwH55vMsgQ8DVqkp8w/CydKe4SQMtA8M2idF9Sw/YdZ4PpxVwVUuk2xcytmG6dCOIubjcv4yivMr3plu4DwYTGw7CNB1b2G19TqLgzJQDigBIEi6Xp8GjrnwOO/clFm4eUlwZsfukdE2dAsQY2Lo4LDV9e6kHBrapP1kwD4a8kWT6oz9K5lQDdqiYMknmXtYBycmhvttw5ASvs5JpLAoFHKuMNqp+Pozoc5YgZQaFi/pNxQDdCVUj9/g49Hk7QIfNjmPOfUCilmc3+LHpIPa3maKZczQcbFg7h0IouyEJyyJea/5hzQtbr4EIgo5uGMiYA6F+ECPNC9pxGmwTVNbfNQXzYRwDPJB6l83xwlfIqRV9IlZfZYUweJw2X/YqGnWFYodtYlEN+ZJ5TvtvG1DpwHBf/lKEvB0bhCtisMzIj0UagtKiqY2JUDj7g0sVPpR8+1RhbdqjNr4Ef0sB1UISJ21NFoLxJj0Bv7ul3+BkDKgjKIzK9dCmfCU9
 JNEJKylG
 7+WbJj80fWBB8oDu/hAcVeUNVpdcD4skeR3Ma2m5TN1XUkj/BchRwWdw5vyplqyiGc3LGhs+8Xu+5KMBx69jG9genem0lN0/Bb3MOkgopCtjiM3xdJrozTrF5KuPyShWD+APwKnlao5PPt1Na+hNewfAGE8fptLR0yojlV3IPZCZe9ECRs/U17PfOqq5o+ClLo5LA7t6WIjup0fo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/30/2026 3:51 AM, Darrick J. Wong wrote:
> On Fri, Jan 16, 2026 at 03:38:17PM +0530, Kundan Kumar wrote:
>> Introduce per-AG writeback worker infrastructure at mount time.
>> This patch adds initialization and teardown only, without changing
>> writeback behavior.
>>
>> Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
>> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
>> ---
>>   fs/xfs/xfs_aops.c  | 79 ++++++++++++++++++++++++++++++++++++++++++++++
>>   fs/xfs/xfs_aops.h  |  3 ++
>>   fs/xfs/xfs_mount.c |  2 ++
>>   fs/xfs/xfs_mount.h | 10 ++++++
>>   fs/xfs/xfs_super.c |  2 ++
>>   5 files changed, 96 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
>> index a26f79815533..9d5b65922cd2 100644
>> --- a/fs/xfs/xfs_aops.c
>> +++ b/fs/xfs/xfs_aops.c
>> @@ -23,6 +23,23 @@
>>   #include "xfs_zone_alloc.h"
>>   #include "xfs_rtgroup.h"
>>   
>> +#define XFS_AG_TASK_POOL_MIN 1024
>> +
>> +struct xfs_ag_wb_task {
>> +	struct list_head list;
>> +	struct xfs_inode *ip;
>> +	struct writeback_control wbc;
>> +	xfs_agnumber_t agno;
>> +};
>> +
>> +struct xfs_ag_wb {
>> +	struct delayed_work ag_work;
>> +	spinlock_t lock;
>> +	struct list_head task_list;
>> +	xfs_agnumber_t agno;
>> +	struct xfs_mount *mp;
>> +};
> 
> Help me understand the data structures here ... for each AG there's an
> xfs_ag_wb object which can be run as a delayed workqueue item.  This
> xfs_ag_wb is the head of a list of xfs_ag_wb_task items?
> 
> In turn, each xfs_ag_wb_task list item points to an inode and
> (redundantly?) the agnumber?  So in effect each AG has a kworker that
> can say "do all of this file's pagecache writeback for all dirty folios
> tagged with the same agnumber"?
> 
> <shrug> It's hard to tell with no comments about how these two pieces of
> data relate to each other.
> 
> --D
> 

Yes, that’s the intent. struct xfs_ag_wb is per-AG state and owns the
delayed_work that runs the AG worker on m_ag_wq. Each xfs_ag_wb
maintains a queue of pending work items that request "process inode X 
for AG Y".

struct xfs_ag_wb_task is the queued request, it carries the target inode
plus a snapshot of wbc.

When the AG worker runs, it drains its task list and for each inode does 
a one-pass scan of the mapping, filtering folios tagged for that AG and
submitting IO for those folios only.

>>   struct xfs_writepage_ctx {
>>   	struct iomap_writepage_ctx ctx;
>>   	unsigned int		data_seq;
>> @@ -666,6 +683,68 @@ static const struct iomap_writeback_ops xfs_zoned_writeback_ops = {
>>   	.writeback_submit	= xfs_zoned_writeback_submit,
>>   };
>>   
>> +void
>> +xfs_init_ag_writeback(struct xfs_mount *mp)
>> +{
>> +	xfs_agnumber_t agno;
>> +
>> +	mp->m_ag_wq = alloc_workqueue("xfs-ag-wb", WQ_UNBOUND | WQ_MEM_RECLAIM,
>> +				      0);
>> +	if (!mp->m_ag_wq)
>> +		return;
>> +
>> +	mp->m_ag_wb = kcalloc(mp->m_sb.sb_agcount,
>> +				sizeof(struct xfs_ag_wb),
>> +				GFP_KERNEL);
>> +
>> +	if (!mp->m_ag_wb) {
>> +		destroy_workqueue(mp->m_ag_wq);
>> +		mp->m_ag_wq = NULL;
>> +		return;
>> +	}
>> +
>> +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
>> +		struct xfs_ag_wb *awb = &mp->m_ag_wb[agno];
>> +
>> +		spin_lock_init(&awb->lock);
>> +		INIT_LIST_HEAD(&awb->task_list);
>> +		awb->agno = agno;
>> +		awb->mp = mp;
> 
> Can't you stuff this information in struct xfs_perag instead of asking
> for a potentially huge allocation?
> 

I can switch the xfs_ag_wb fields (lock/list/work/agno/mp) into
struct xfs_perag and initialize them when perags are set up.



