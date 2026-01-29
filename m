Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F2A7D73E87
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 22:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE4FC6B00A9; Thu, 29 Jan 2026 17:21:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A92FD6B00AA; Thu, 29 Jan 2026 17:21:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 995346B00AB; Thu, 29 Jan 2026 17:21:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8BB406B00A9
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:21:05 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1CEA4B9A89
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:21:05 +0000 (UTC)
X-FDA: 84386422890.17.CDA5D42
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8004514000A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:21:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H8vMkgeK;
	spf=pass (imf23.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769725263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OzCjHmVAQweLDeAgMXn604IuDbxXOjQ1F/BmrNJ7Wjg=;
	b=kp15lwMVctOfobqVxKPkH7vHk72XRUrhsvo3wSxoE2Z8ubkI/S9w2ouhI/Q+jLDe4CqNdP
	rHscFreGremFPPBNr3Dis3ZiJHFFUzK4mrUM7Y4mgqLq/+dIwFfhQy0iR3FsBb6KWneu4O
	418u4mm/YuHd2rBZ2QVgt0IPkSi8wQ0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H8vMkgeK;
	spf=pass (imf23.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769725263; a=rsa-sha256;
	cv=none;
	b=LF2TXh7v821Hh2XuxZOEyuXqqAgvY0Rxqy+9szbIBV6n5NjotjNzS43VeAASc7ZX3x3wVd
	2WoAAsjuHkKBmMcwaKfTKlNwWXrasSY8+AlfY0Vnt2ZBEKXbeJYXe32Nnq6rwLwxTTHf99
	mFSwIw2V4dMNcVQOFV/oGRjgTFsM3q0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C953B60125;
	Thu, 29 Jan 2026 22:21:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721F6C4CEF7;
	Thu, 29 Jan 2026 22:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769725262;
	bh=Posmbe8NRA7G0It215WCxGe1hRREd15vgUGpBqnnnpo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H8vMkgeKVcy5lKEZp01o61YHZIl1gz4QvqJ2uEZB98oboavk2QUkITkulFzRfQYGW
	 bRertZklRSKjj56tPjT/040aLWZN6AADFD4yT19hNqTk5XmpkCRnFaLA6IHxMTCueL
	 aNW+xlVFo9tscW6gYv7yDevBTHF0g2RbkzG2/tK1/XiB93AsUFVtGpu5ibs8tS3/sW
	 O+Lsi1nWrPQnfD/AOYB0zUr+QNFmLoT0L5+8qU6qPB9oOY/GxsFft+7ou+OMzlibmw
	 M7s9AsVkvdJQO8DC7QbquohDjuhcre6fFC/Vp4IiQ+6nLxzdPyY0fjfEp6Enm9sNch
	 2744U5MxvXBdw==
Date: Thu, 29 Jan 2026 14:21:01 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com,
	david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
	hch@lst.de, ritesh.list@gmail.com, dave@stgolabs.net,
	cem@kernel.org, wangyufei@vivo.com, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v3 5/6] xfs: add per-AG writeback workqueue infrastructure
Message-ID: <20260129222101.GD7712@frogsfrogsfrogs>
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
 <CGME20260116101259epcas5p1cfa6ab02e5a01f7c46cc78df95c57ce0@epcas5p1.samsung.com>
 <20260116100818.7576-6-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116100818.7576-6-kundan.kumar@samsung.com>
X-Stat-Signature: g8cmdinmie9ohqe9gw7qjsffqtqgo39a
X-Rspamd-Queue-Id: 8004514000A
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769725263-796528
X-HE-Meta: U2FsdGVkX1+u30zQ5L0Eve6GEgpiv+KR5YWBfYtLsZVsRgx7F6kPdJ4bnQaXv83w1OOF1OYlKPgrCb09FF48t1mZnGKzL4Fg6SjtIiRzCl8g4EdxgAcQ5WLyU5vvdyO2XTZVaclu4tX0dIrUTnHBfgMBgk9F8EFqhyG8hCHDHGHGlm4hWX0XC0feEi74Uf0yvu6hRloUuG+C83d6oYFRFMCugTDaz/6bQ8jCMXScfNx8Q/AMs+onaBPVe7KKnmIlrorxbQW/krx/1ALmbdSzlPODtHXZ93/C62BLzlV2tVJEppYm+mc7Io+EtT5q6QJexGcYyz16fmcU3elnCyR5lVztTy2EBkjOZeRuRPsqCqiYt6qE9CSSFbspLZyC9hXzFaNwqggPAzsI5bgVstSHrlW+92s5gD86a+4JkAHJYwg3rSgwhfbMJIBVfp3SRzfLN7f8FY/jap3P+noS7czQ0lIb7fG+VqTLUPObGVDnE6QOUUWVatTMpfVu9v/josn5ZKu6CUDxHtXs/D8aC+fdrAdRR+6NjmSauA+MyM+YQxR/9ntsPaC5gqmGlI7xQf8I6qYMrWNaI+nU5/vo8Q7rImkm2TWijFftZzugdpspHdalx8YxywZb390lva3oYiIVmjWOEigRy7igWrPnOEAVU5F1jQH3MNCdp0E8O8Lp6PEPMWb28KWUkKctw2NNuw9se5uAw8Ui+n4hEKuXVOaESnpkQKedZmMF8TvxcM5ZxFKxrFY35JEGVyBIDEZz2ulYzFU2ETvvHH85BY6RT4cLuq84I2o+VLVQOb0Qxu6Kl+uzMS/uHqfWC2OpWxxEFBofP4ev7W61s3uSj5uHsf8SYDsB2m/pCQC7x2/g9Wegm54taFlID7avgZ3Y2E7jg9nCXf3lNPmqFncMQr3c1VtSLAwnSmbG8mDsPVrM89/xJ9jDHS0ZOD10XqQOMkopoMzThs/XPZqsckrloUed6KF
 4yRB8kS+
 yy8zGhlt3RfIV1o1daebbbUQLa15jFPOV4HFMa6cBA97KOxajLS1VB8AhFd/uXqoD/Sz1kE2wU6n+NCdRIjk6HcFTBmyFl+GYvmHkwJg/VwimnzX/IsUIrSN0W0bjf7F5jA6XkJ1oZS1TUO/un379dvHjivjS0SPYDEKMsn7BxLakrqWqXUBI4UtI7Vs0emqeEjIo8HIdEYdtsuYzJ+JMvLOBwmWMxxlWitIS9BTLtAwThNfv7N2Kq1ljf6OtbWBBmbbV+1+aj1EPvv+O9U/a6jsfwtoEYQNogpZHYIZktW5JlOreI8mhijOqSyNlorSRYioza0K/r9UdQf2bYQwBg5puTg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:38:17PM +0530, Kundan Kumar wrote:
> Introduce per-AG writeback worker infrastructure at mount time.
> This patch adds initialization and teardown only, without changing
> writeback behavior.
> 
> Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>  fs/xfs/xfs_aops.c  | 79 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_aops.h  |  3 ++
>  fs/xfs/xfs_mount.c |  2 ++
>  fs/xfs/xfs_mount.h | 10 ++++++
>  fs/xfs/xfs_super.c |  2 ++
>  5 files changed, 96 insertions(+)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index a26f79815533..9d5b65922cd2 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -23,6 +23,23 @@
>  #include "xfs_zone_alloc.h"
>  #include "xfs_rtgroup.h"
>  
> +#define XFS_AG_TASK_POOL_MIN 1024
> +
> +struct xfs_ag_wb_task {
> +	struct list_head list;
> +	struct xfs_inode *ip;
> +	struct writeback_control wbc;
> +	xfs_agnumber_t agno;
> +};
> +
> +struct xfs_ag_wb {
> +	struct delayed_work ag_work;
> +	spinlock_t lock;
> +	struct list_head task_list;
> +	xfs_agnumber_t agno;
> +	struct xfs_mount *mp;
> +};

Help me understand the data structures here ... for each AG there's an
xfs_ag_wb object which can be run as a delayed workqueue item.  This
xfs_ag_wb is the head of a list of xfs_ag_wb_task items?

In turn, each xfs_ag_wb_task list item points to an inode and
(redundantly?) the agnumber?  So in effect each AG has a kworker that
can say "do all of this file's pagecache writeback for all dirty folios
tagged with the same agnumber"?

<shrug> It's hard to tell with no comments about how these two pieces of
data relate to each other.

--D

>  struct xfs_writepage_ctx {
>  	struct iomap_writepage_ctx ctx;
>  	unsigned int		data_seq;
> @@ -666,6 +683,68 @@ static const struct iomap_writeback_ops xfs_zoned_writeback_ops = {
>  	.writeback_submit	= xfs_zoned_writeback_submit,
>  };
>  
> +void
> +xfs_init_ag_writeback(struct xfs_mount *mp)
> +{
> +	xfs_agnumber_t agno;
> +
> +	mp->m_ag_wq = alloc_workqueue("xfs-ag-wb", WQ_UNBOUND | WQ_MEM_RECLAIM,
> +				      0);
> +	if (!mp->m_ag_wq)
> +		return;
> +
> +	mp->m_ag_wb = kcalloc(mp->m_sb.sb_agcount,
> +				sizeof(struct xfs_ag_wb),
> +				GFP_KERNEL);
> +
> +	if (!mp->m_ag_wb) {
> +		destroy_workqueue(mp->m_ag_wq);
> +		mp->m_ag_wq = NULL;
> +		return;
> +	}
> +
> +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> +		struct xfs_ag_wb *awb = &mp->m_ag_wb[agno];
> +
> +		spin_lock_init(&awb->lock);
> +		INIT_LIST_HEAD(&awb->task_list);
> +		awb->agno = agno;
> +		awb->mp = mp;

Can't you stuff this information in struct xfs_perag instead of asking
for a potentially huge allocation?

> +	}
> +
> +	mp->m_ag_task_cachep = kmem_cache_create("xfs_ag_wb_task",
> +						sizeof(struct xfs_ag_wb_task),
> +						0,
> +						SLAB_RECLAIM_ACCOUNT,
> +						NULL);
> +
> +	mp->m_ag_task_pool = mempool_create_slab_pool(XFS_AG_TASK_POOL_MIN,
> +	mp->m_ag_task_cachep);
> +
> +	if (!mp->m_ag_task_pool) {
> +		kmem_cache_destroy(mp->m_ag_task_cachep);
> +		mp->m_ag_task_cachep = NULL;
> +	}
> +}
> +
> +void
> +xfs_destroy_ag_writeback(struct xfs_mount *mp)
> +{
> +	if (mp->m_ag_wq) {
> +		flush_workqueue(mp->m_ag_wq);
> +		destroy_workqueue(mp->m_ag_wq);
> +		mp->m_ag_wq = NULL;
> +	}
> +	kfree(mp->m_ag_wb);
> +	mp->m_ag_wb = NULL;
> +
> +	mempool_destroy(mp->m_ag_task_pool);
> +	mp->m_ag_task_pool = NULL;
> +
> +	kmem_cache_destroy(mp->m_ag_task_cachep);
> +	mp->m_ag_task_cachep = NULL;
> +}
> +
>  STATIC int
>  xfs_vm_writepages(
>  	struct address_space	*mapping,
> diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
> index 5a7a0f1a0b49..e84acb7e8ca8 100644
> --- a/fs/xfs/xfs_aops.h
> +++ b/fs/xfs/xfs_aops.h
> @@ -12,4 +12,7 @@ extern const struct address_space_operations xfs_dax_aops;
>  int xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
>  void xfs_end_bio(struct bio *bio);
>  
> +void xfs_init_ag_writeback(struct xfs_mount *mp);
> +void xfs_destroy_ag_writeback(struct xfs_mount *mp);
> +
>  #endif /* __XFS_AOPS_H__ */
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 0953f6ae94ab..26224503c4bf 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1323,6 +1323,8 @@ xfs_unmountfs(
>  
>  	xfs_qm_unmount(mp);
>  
> +	xfs_destroy_ag_writeback(mp);
> +
>  	/*
>  	 * Unreserve any blocks we have so that when we unmount we don't account
>  	 * the reserved free space as used. This is really only necessary for
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index b871dfde372b..c44155de2883 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -342,6 +342,16 @@ typedef struct xfs_mount {
>  
>  	/* Hook to feed dirent updates to an active online repair. */
>  	struct xfs_hooks	m_dir_update_hooks;
> +
> +
> +	/* global XFS AG writeback wq */
> +	struct workqueue_struct *m_ag_wq;
> +	/* array of [sb_agcount] */
> +	struct xfs_ag_wb        *m_ag_wb;
> +
> +	/* task cache and pool */
> +	struct kmem_cache *m_ag_task_cachep;
> +	mempool_t *m_ag_task_pool;
>  } xfs_mount_t;
>  
>  #define M_IGEO(mp)		(&(mp)->m_ino_geo)
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index bc71aa9dcee8..73f8d2942df4 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1765,6 +1765,8 @@ xfs_fs_fill_super(
>  	if (error)
>  		goto out_free_sb;
>  
> +	xfs_init_ag_writeback(mp);
> +
>  	/*
>  	 * V4 support is undergoing deprecation.
>  	 *
> -- 
> 2.25.1
> 
> 

