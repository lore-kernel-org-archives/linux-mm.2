Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2041EA8102
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 11:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0814C6B0088; Tue, 10 Feb 2026 06:56:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02B246B0089; Tue, 10 Feb 2026 06:56:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EADD16B008A; Tue, 10 Feb 2026 06:56:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DBCE16B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 06:56:23 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 930521C41B
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:56:23 +0000 (UTC)
X-FDA: 84428394246.17.46F6C9A
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id AB13CA0008
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:56:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Us+s9BFm;
	spf=pass (imf25.hostedemail.com: domain of nirjhar.roy.lists@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=nirjhar.roy.lists@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770724581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nh7yAl8rufONh7m/CgHms/EgFK1saZrvUpQU2nWdB00=;
	b=CLSPvxublERiY5wA2qGFNtXBgSC1F3sixnfzPIIppH6AvNpAhhR/9BZORSnoLcH5tyPPoP
	KrTVvUQI8VLHe49HAAXgAPxrwyU+vnzmf3BtcAD+4r4Lj6vE05WOJ4MUJqNsVbHjp8gGfD
	OBH1geWBihFWtR8Uq7LnrItFOo20DrM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770724581; a=rsa-sha256;
	cv=none;
	b=fm2/7balBZEAG9hH+ZCFvmjcY+khIYahibVOTsRU3gIwmBAPFhImdmx25buLBI2YleHWZ0
	JRgv2/rcJlWXajKacztOaekVSW4xHIdtbtYochzY0GdFMet6Kfo/mFXGRIaDhpXb5jRK5y
	ssxFkIsebLIUzVwepWBxkENVEWeXBvc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Us+s9BFm;
	spf=pass (imf25.hostedemail.com: domain of nirjhar.roy.lists@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=nirjhar.roy.lists@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-81ed3e6b8e3so1906554b3a.2
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 03:56:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770724580; x=1771329380; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nh7yAl8rufONh7m/CgHms/EgFK1saZrvUpQU2nWdB00=;
        b=Us+s9BFm1MmGvZSpCcQ9YkVuCRbiXoCk5cEu6r0vufgjTZwIub5mGSGCnrmqfcrjwP
         cycm1QzeZja3VUopyZ/li7NK7Jmx7//uAkm08UDbiR7UJlPzQfpGBhr+DgOSxH7Di0uW
         mZ8T+RaLxE5Qzit1zFefzodvNp8369F/a3hzeHsgYRvVGptUboJzUvHzA+aDUDjTldwF
         4MITx+Cz4HtxdTlfbto6RbRJJFrA4ZoABUZTJ/WER/OWjgFTWpHXQ+NOT8Z8s/9K4N99
         C28QqGHZFo3Ivh2beAo19cnQFAN6qMlROVPl3es0k/hLn4Iiduyewuw96+pRjF8jOBFw
         OlJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770724580; x=1771329380;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nh7yAl8rufONh7m/CgHms/EgFK1saZrvUpQU2nWdB00=;
        b=QrS/I2Xt3407ylUFDq8L3oozJsvZWBtFnur+i1E0NqQNUC5xMEQBPwnXIy4fg1yViA
         +jmK42q0xGEmxWDbfDWDPx5pHTsFzvM0JDGRDowrNx81DZ7zaetRq93DN4Nnrjcrm33m
         5G+JyC809c3nT0TtYv6oV+5H3s0N/P3DGGf+hf2ZmsjvFef2B/Fv9LikDy8c5Qk/GEBX
         /Onp974sKyRwM6jzttsZeVeFWgizxuh3MLSkWJpDMueff3zCqRIwmmRtInP38xO8BACY
         rjvDN/L0qnoKmilS0MzvS3wv2BM0PpEgM3YAFIjujClQlF1xTrWo9RHoNNxckvkmRKZZ
         6u2g==
X-Forwarded-Encrypted: i=1; AJvYcCVhpYY+LZ8X3J5gznwMdioQqDnhRoX+qDYFCho1+UuklJk+iNBHMyPYuH1iNjF65KaCNkZQm0MYJA==@kvack.org
X-Gm-Message-State: AOJu0YxSVFWB8G8jzeM1hKJM+q6Lvb0m70htuNfND5G1LxIf8hfQj+Az
	OB6EDqyc5EheUlu58btNDzfZ8CuoGIeH/6NNnKWDEEUTr8Eoo4rJsnyJ
X-Gm-Gg: AZuq6aJR5rky8HscnkwEy8wIzQz+1IpgNfKyGCYOPAtecyP9ob7fchUW3EhRaqaJq7w
	x3XTiWeN6L0VhAamheWN56sID0kkvMLoOGiKaYivja6/l6o9wFOebl+zZrc4KSeKguwu16L7bo/
	ESKFuq3h9Wt49/mFIaqjt4fyqsRwnwt8VzJEbT5tiIglfIW6RRdIUJ0Dbo+R6X8lZ1j6HU/2Zj/
	tnoF177DMIyU6Az9qRc4WkuN9zMKBwJyNK71F2wja6wGhNpuweeRFc/0FYX68ypC90KQNcJmlS3
	rLGgONJfB16a5GIuKmmBHvRZ1yqqr/PpNE3qKlNksl8FDtK/l/nwYMcT0zzi74oq5sEvxDVsrwI
	e75DaEJcordCfZRr6opUHpxHpvYxqfmykB/5TRvjwnAjqkdr4ZSncAZCh5euuGiuZiCJjT34ETO
	QOdzCADF0GNJ+BWnEpW3ezMRCajtopiCqM18S+3KbiYpv9ydHqOdsPsSpGcs0kGw0BTrNA+zixM
	2Ho
X-Received: by 2002:a05:6a00:4fd6:b0:81e:96c9:1325 with SMTP id d2e1a72fcca58-824417f97cbmr13212298b3a.70.1770724580368;
        Tue, 10 Feb 2026 03:56:20 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824418a70fesm12972619b3a.45.2026.02.10.03.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 03:56:19 -0800 (PST)
Message-ID: <46a56cbf1ead927d0bc109b8106ae3b5237ec721.camel@gmail.com>
Subject: Re: [PATCH v3 5/6] xfs: add per-AG writeback workqueue
 infrastructure
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Kundan Kumar <kundan.kumar@samsung.com>, viro@zeniv.linux.org.uk, 
 brauner@kernel.org, jack@suse.cz, willy@infradead.org, mcgrof@kernel.org, 
 clm@meta.com, david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
 hch@lst.de,  ritesh.list@gmail.com, djwong@kernel.org, dave@stgolabs.net,
 cem@kernel.org,  wangyufei@vivo.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, anuj20.g@samsung.com, 
	vishak.g@samsung.com, joshi.k@samsung.com
Date: Tue, 10 Feb 2026 17:26:11 +0530
In-Reply-To: <20260116100818.7576-6-kundan.kumar@samsung.com>
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	 <CGME20260116101259epcas5p1cfa6ab02e5a01f7c46cc78df95c57ce0@epcas5p1.samsung.com>
	 <20260116100818.7576-6-kundan.kumar@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AB13CA0008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: hqzfsap95rif7rmuq3pam15q1q737afs
X-HE-Tag: 1770724581-138997
X-HE-Meta: U2FsdGVkX19t2QAjg5CDGhCaM5NNsh0NvWz34O2hfHlBePMNrKiSsIskMORTC+kYzjr/oQghdDqKs1xOUD8ka2ZH5cyKl9udI5IbOuBpMAcZXYtwp4dFNF5IswZSEk+o01UHbagSMwAONVIta7fEqplBFjldU7KDlYGlFZYucaDlEGHO2SlaKX6mGWE5siotQJnwurTc5rRx8CXVvteHD/2XPj4snB+PHe0XN46PAEQwR5m5IzOhW+sI9hDXEgcXZHUI4WrI7OV9AJCX/7XM6h51tuxQV3lJhJK3kZEl9e2SKvUmr+29tjTwfT9CmrKoF8B0Ta+tAWUsnZD05hYwYUn0O8VqSufRd21tV9F5gS1SYJk5yL1XtxB9FEO8l+dzH3E8F9gTZVAOqYabRsJWxTZdjx+8xpEslSTbOHcjfrHAWTm5mv0wqi3CwfmvbDTqWGbRNtPLvhKMriXZMqM02YMUpoOVUkC1A0chrTNuQm36l4DfRNJQIZyh9knSE6Mh6n6Mol473qyATFfZf3sl7klJGi0PhjU3AGC1YgAOI4xKgEhwuPTes0M4uqfCImBUDORNWrOjHmMyIIYmKh7ye7GNcf1XT9dhvNU8cZIT1FNs0LqYQhhmeygi0knNnlfoCYPiYO1ZaKfRtsbycPNjUOtSjaEiguDIM+E30UfUJMEA7Sc+eeyU3SKzm5CkKqFWBBcbb8NdvBCXiaoZt8cwM/fDdUjZr7R9DvfnNwMuROqIc7iG9orBquhwIBRTKDyJLVF/BdBOLPRzvrMRvg5YmY5PP63800Nyu7l0R4AQ9gDIXQ8X4v9IR/XrtkdhSRyimTsXCeIzcBzOLUPA02lIIP9zy1tc6JXBqTDA1YHGfrVdAqNkDp1uVFrdLtR/2u+vTEUipa4x+xugBjASm0hI2dWvRj8vYUejl3lZqrw4vVJZk61e48pgpsGNOsYk6dR7jriPAbMMfSqwtZMYTub
 tOqpldpa
 u7T4w8p+ibQ93hpglt33958/A6gqzoJBMpEWd3WDDr2+CtUvlOzE39PJJNQ/apghiFuAvUl/vLS1Dyz1ZNuk3Ux+OD5QCC3I3zD8wTA5/kwEqoGjBtndAnOSs5uHnOZ/q2A7QX7tIvGVSzNEU/EJmWrtygnzK1+8trUEXxAmdcGiwyCXsotfGDqzBV5r8sFnUUm06GUUP0rXYWG70PCx6qvdHpwHqq+R89Z/zSBoa/B4fOnF5RTT4cnrkrZJKXcCnrqkj9PauzQTqCEL68ZvEkrIDL29EORSBsjeBtxK2GQZsZ49Iw1AlV+zZgX0acDrH700V6hItLYbeThKmc3d631+elCGqafn9fY7AX4GPTl+qUGFzahSl6ZArB/y18vqs4ezQRNYGRvJ7wfSx1ZwkmK/YDGIIcmhdGE6/rqBWo0o+zeRNFzkv5BNXFgihY6M7SosrKZhQ8t+dAtaZb+lKNWpLbi/TIADsJ+qcnAnSWDh2RUrFASfvAkpjM+gEehe3cgaEjOGgiG8vQ2xaKBBaDEN5/dKgW4YZ+/vc5WCSYsoIVxI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-01-16 at 15:38 +0530, Kundan Kumar wrote:
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

agno where the ip resides or the agno of any one the blocks which belongs to this ip?
> +};

Nit: Coding style - tab between data type and the indentifier
> +
> +struct xfs_ag_wb {
> +	struct delayed_work ag_work;
> +	spinlock_t lock;
> +	struct list_head task_list;
> +	xfs_agnumber_t agno;
> +	struct xfs_mount *mp;
> +};
> +
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

Nit: I think we follow 2 tabs indentation of the parameter list length exceeds per line limit count.
Similar comments for such changes in the below function call sites.
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

Nit: 2 tabs indentation
> +
> +	if (!mp->m_ag_task_pool) {
> +		kmem_cache_destroy(mp->m_ag_task_cachep);
> +		mp->m_ag_task_cachep = NULL;

Shouldn't we be also freeing mp->m_ag_wq and the array mp->m_ag_wb[] array ?
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

Again Nit: - Coding style - tab between data type and the identifier


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

So if we are not able to init the write back workqueue infra, we are still okay to mount the fs
except that the AG aware write back facility won't be available i.e, we aren't treating it as a
fatal error, correct?
--NR
> +
>  	/*
>  	 * V4 support is undergoing deprecation.
>  	 *


