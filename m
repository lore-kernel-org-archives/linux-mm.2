Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 245A5F589D9
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 14:14:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 434EF6B0005; Thu, 23 Apr 2026 10:14:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40CC06B008A; Thu, 23 Apr 2026 10:14:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 349D76B008C; Thu, 23 Apr 2026 10:14:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 20EE56B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:14:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB7371401B9
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:14:01 +0000 (UTC)
X-FDA: 84690014682.15.643C1AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id DA53CA0004
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:13:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tRUaMpbm;
	spf=pass (imf25.hostedemail.com: domain of vkoul@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vkoul@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776953640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PwlLVn0oLG9e+ZwLtZ+4j4cnE0wIiJdN8bQ3gDMHawY=;
	b=R2ZP4fF9tOs3SrHQzKWyMn9Ve5akwrcVZLyiaztb+BiLHs+cVzMIT1AS1Y0QQ+qh9jsukj
	AvpJdWHfKMoCr951m94eCPVD9ADXCbz0ytflFAg1Z6WTJA8bA5va9WypvzwldY+5oUCvb+
	MJ6EGfGJs46XdEGE3gN385+DN2/cc5s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776953640; a=rsa-sha256;
	cv=none;
	b=KuKxnkpDWpxdANXQBDYHGyMmaUvUXd20DQybTcp4BdTc4b2LqdJ8EdnhYeRLJYNSI30xlg
	a/jKeW++O0xQbZ3uIPxDcw1VCvyCbCsxl7eZtwXPAwSbb0UrujpwhXbSsjp1sIi0rdMnVo
	6F9DLsKhkwuR6fUacr53TE2Hbhgl+Uc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tRUaMpbm;
	spf=pass (imf25.hostedemail.com: domain of vkoul@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vkoul@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AE8ED40050;
	Thu, 23 Apr 2026 14:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D291BC2BCB3;
	Thu, 23 Apr 2026 14:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776953638;
	bh=MsOG1WoL4DthbK8BMCb1/S31UzH6r3oqgqhBEYtuyAI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tRUaMpbm3qHHCq29jygXUyj85ACEWDLUpWtgi9ly4VKD3rldB3i7FO5jOjD8S2czx
	 9ehFMySv41gDporVbxVuzH7GVwp6jA0EfpxPpQkhIpbaMilKGrgvkmFiKgLNI3heg3
	 VLCy9mj9g3c1MMYyV8YX3QFRnEFxFX7DILpZRtCuzjt3jAgfy62LwDsbEm0Zrlhjne
	 IuKMoAgo/bdfn48UPUaiJIBkLzasVl1JDBwWLxOudbPh4urFr3gs8vUPUmf5e5Pqiw
	 U5BIt8sNnXwVpsTpykztnOSMbtEMhfbqLa30Jsvb96l/E6Cd/FhuMdjfap5WluTN7S
	 1Or0tv2zPqMYQ==
Date: Thu, 23 Apr 2026 19:43:54 +0530
From: Vinod Koul <vkoul@kernel.org>
To: "Garg, Shivank" <shivankg@amd.com>
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
	willy@infradead.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	dave@stgolabs.net, Jonathan.Cameron@huawei.com, rkodsara@amd.com,
	bharata@amd.com, sj@kernel.org, weixugc@google.com,
	dan.j.williams@intel.com, rientjes@google.com,
	xuezhengchu@huawei.com, yiannis@zptcorp.com, dave.hansen@intel.com,
	hannes@cmpxchg.org, jhubbard@nvidia.com, peterx@redhat.com,
	riel@surriel.com, shakeel.butt@linux.dev, stalexan@redhat.com,
	tj@kernel.org, nifan.cxl@gmail.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org
Subject: Re: [RFC PATCH v4 5/6] drivers/migrate_offload: add DMA batch copy
 driver (dcbm)
Message-ID: <aeopIn_sCBR2CFrI@vaman>
References: <20260309120725.308854-3-shivankg@amd.com>
 <20260309120725.308854-14-shivankg@amd.com>
 <396b4be1-376b-4aac-bd1e-2854c88b3757@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <396b4be1-376b-4aac-bd1e-2854c88b3757@amd.com>
X-Stat-Signature: oup6q1kfgw3zqdiu9py9898ssf14jjsu
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DA53CA0004
X-Rspam-User: 
X-HE-Tag: 1776953639-822678
X-HE-Meta: U2FsdGVkX18JbrsF85nkTzgPul9kQzYzb/qSZhSEFvMi4KmIdVtdvcB96HaTnpnwQKglRl4flBXKYLEdtuLmD/Du/fPjL65LyeZHAOYBdPY+0E5xo2v+pS9Kc3hZoCkJZmbHEz6sV3KOBDOMCCls35w0Hy9onrvN2BzG2JxX6sK872z/zGmRGykWwx6YxtQA0wa6ULcjlPLO1pyeFfBATl5IePQ1Q+zrkd6yBMJyVCcmoVV2pj45aj/jXoAm3umQd63GC1Cbe3+7DxiMrlAuI4V3aJjoKm2XBb+ZkZ4R59ti9py79ZBG521fU4vhmZjzJllyd2+6vVnBj4264jXrAlqKTg8z4zk6yEjRp1ll7P/4LvhcYB0LiiMA+XPdaq87idrIMACdVwS9sn/BnHUnLZHI6vz/6UJffeImHlEVVvP7o/PsjvF2QFuZxLuHly9MGSh20QXfyUewbbvthmpe/RdzmN76Pp+9ETHt8r26d1/6au482KcyRZRnHMmzBedtMk+/YxkF1+T6gx/U6DeVrrSZORf+tO5b6wFll5iqnH2okyHuA4WE/cpCH8uGYLk1+YQIoMXncPMa7fc5dhlpMKYpyzIwaTi4hTPUDH6PXQe9hS8wuYJK3pVLqMYs1vwyk4ErVo/DUfYNLsWuyoAfHM5B+08P5GYHh0s/2VHFrIgm/+5VPvcKTrDzM1h+IOkZk8Xy7A9/3Fs9TdBIqPHIM6oXC7N8ISN3irLhOicoIQLzf+ThiU/2AF/9STBi3K8RjbUft2bOw/Jh7g/C8yisa2Eo9dAK4I3DywsgS9nAUytNlzufYUPU1Q20Ar8P2QO+bmbl6x7vi/u5bOjSp1B2PFvxtLPBp91Hc5wguCeIjxOcClitYQT/feKcJk0md5QLAMae4Zg/K7klnyPDdckFcFxLeV9JzyCf40CaFKt0024JqZ1jDvvTTdurN2+fxzLVLlouWTJIMnFrwHmX1MG
 zzYzMeFj
 Q+gHPWXy+RqEHetZCVVZHVyP9B5b52bSPmMo78uvGQJHoCToWlMqmE+lT7F2fnma+gDw6BpG9VQh209ag0WvTqPMMKaZufvsb+DLkd8LMw16hKWsj6G9c4he4q/eOsHuus8TcW5xt1KAAbHeNxFNHssQ9OQY+glZY9R1qOUFson9Rmi2/L36IvQSFKIQVOgRHQDKbhDxww3KKqYQ7UsLflfyRVLyTdLcz+dQ55oJjpxERdgVkBrotB++MkwwnvZJEff9p1Ht8gr9TTovfZDIAl7NP2DlkBze+c5M21jg+T2e8wmL+o2koSexlMVxg6fEEfuG31YIPL7z0MhrH+QhUD0nACNQdLyhkt2mPEZCKCShkAPbNqVlLjepmldgIupNd8mHhPPY6xDzhcYY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23-04-26, 17:40, Garg, Shivank wrote:
> Hi Vinod,
> 
> Following your suggestion at the Kernel meetup in Bangalore (11 Apr 2026)
> to check 0cae04373b ("dmaengine: remove DMA_MEMCPY_SG once again") and use
> DMA_MEMCPY_SG / dmaengine_prep_dma_memcpy_sg() (I added a
> device_prep_dma_memcpy_sg hook in drivers/dma/amd/ptdma/ptdma-dmaengine.c
> for this experiment; not posted).
> I ran an A/B comparison against the existing DCBM path that uses
> dmaengine_prep_dma_memcpy() in a loop over mapped SGL segments.
> 
> I'm using the move_pages() workload to move 1 GB data per run. I do not see
> significant performance difference, and results are broadly within each
> other's noise band).
> 
> Throughput (GB/s, mean ± SD), ITERATIONS=10:
> 
> Page     nr_dma_chan=1              nr_dma_chan=4              nr_dma_chan=8              nr_dma_chan=16
> order    dcbm          dcbm_sg      dcbm          dcbm_sg      dcbm          dcbm_sg      dcbm           dcbm_sg
> ------   -----------   ----------   -----------   ----------   -----------   ----------   ------------   ----------
> 0        2.33 ± 0.17   2.26 ± 0.19  3.24 ± 0.21   3.18 ± 0.23  3.29 ± 0.10   3.45 ± 0.10  3.29 ± 0.13    3.49 ± 0.22
> 4        2.77 ± 0.21   2.99 ± 0.18  6.26 ± 0.99   6.75 ± 0.12  8.01 ± 0.58   7.70 ± 0.64  8.22 ± 0.89    8.72 ± 0.87
> 8        4.57 ± 0.70   4.75 ± 0.83  10.64 ± 1.97  10.94 ± 3.52 10.30 ± 1.22  10.36 ± 1.24 11.27 ± 1.21   12.47 ± 1.66
> 9        12.71 ± 0.09  12.68 ± 0.08 27.13 ± 0.15  26.89 ± 0.27 46.50 ± 0.73  45.17 ± 2.46 67.25 ± 1.42   62.78 ± 8.24
> 
> Notes: order 0/4/8/9 = 4K / 64K / 1M / 2M folios
> 	dcbm     = per-segment dmaengine_prep_dma_memcpy
> 	dcbm_sg  = DMA_MEMCPY_SG / dmaengine_prep_dma_memcpy_sg
> 
> <snip>
> 
> > +
> > +static int submit_dma_transfers(struct dma_work *work)
> > +{
> > +	struct scatterlist *sg_src, *sg_dst;
> > +	struct dma_async_tx_descriptor *tx;
> > +	unsigned long flags = DMA_CTRL_ACK;
> > +	dma_cookie_t cookie;
> > +	int i;
> > +
> > +	atomic_set(&work->pending, 1);
> > +
> > +	sg_src = work->src_sgt->sgl;
> > +	sg_dst = work->dst_sgt->sgl;
> > +	for_each_sgtable_dma_sg(work->src_sgt, sg_src, i) {
> > +		if (i == work->src_sgt->nents - 1)
> > +			flags |= DMA_PREP_INTERRUPT;
> > +
> > +		tx = dmaengine_prep_dma_memcpy(work->chan,
> > +				sg_dma_address(sg_dst),
> > +				sg_dma_address(sg_src),
> > +				sg_dma_len(sg_src), flags);
> > +		if (!tx) {
> > +			atomic_set(&work->pending, 0);
> > +			return -EIO;
> > +		}
> > +
> > +		if (i == work->src_sgt->nents - 1) {
> > +			tx->callback = dma_completion_callback;
> > +			tx->callback_param = work;
> > +		}
> > +
> > +		cookie = dmaengine_submit(tx);
> > +		if (dma_submit_error(cookie)) {
> > +			atomic_set(&work->pending, 0);
> > +			return -EIO;
> > +		}
> > +		sg_dst = sg_next(sg_dst);
> > +	}
> > +	return 0;
> > +}
> 
> static int submit_dma_transfers(struct dma_work *work)
> {
>         struct dma_async_tx_descriptor *tx;
>         unsigned long flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
>         dma_cookie_t cookie;
> 
>         tx = dmaengine_prep_dma_memcpy_sg(work->chan,
>                         work->dst_sgt->sgl, work->dst_sgt->nents,
>                         work->src_sgt->sgl, work->src_sgt->nents,
>                         flags);
>         if (!tx)
>                 return -EIO;
> 
>         atomic_set(&work->pending, 1);
>         tx->callback = dma_completion_callback;
>         tx->callback_param = work;
> 
>         cookie = dmaengine_submit(tx);
>         if (dma_submit_error(cookie)) {
>                 atomic_set(&work->pending, 0);
>                 return -EIO;
>         }
>         return 0;
> }
> 
> The memcpy_sg version does simplify submit_dma_transfers()
> (one dmaengine_prep_dma_memcpy_sg + one dmaengine_submit vs a loop).

Right

> 
> My current DCBM path issues dmaengine_prep_dma_memcpy()+dmaengine_submit()
> per mapped SG segment and sets DMA_PREP_INTERRUPT + callback only
> on the last one, so the IRQ/callback cost is already one per batch.
> 
> My understanding is switching to dmaengine_prep_dma_memcpy_sg() mainly
> saves the per-segment prep/submit calls and hands the provider a single
> multi-segment TX to program.

Right, but the analysis you showed indicated the dma setup cost was
quite a bit, this moving away from N transfers to single one should have
saved a bit more...

> 
> Please correct me if the benefit you had in mind is something stronger.
> Thanks for the suggestion and for guidance.

I still feel this looks better version... 
Can you compare your setup time between the two please

Thanks
-- 
~Vinod

