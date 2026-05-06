Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D3D5CD343B
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 15:46:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A4106B008C; Wed,  6 May 2026 11:46:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5553F6B0092; Wed,  6 May 2026 11:46:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41B6F6B0093; Wed,  6 May 2026 11:46:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 313BE6B008C
	for <linux-mm@kvack.org>; Wed,  6 May 2026 11:46:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1A34A0181
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:46:24 +0000 (UTC)
X-FDA: 84737421888.05.DA99B36
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf05.hostedemail.com (Postfix) with ESMTP id 22F67100007
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:46:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="rDgRq/Bx";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf05.hostedemail.com: domain of feng.tang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=feng.tang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778082383; a=rsa-sha256;
	cv=none;
	b=fsjHOPdqfyTVrXk8vuBBNZ70fVMBzFMPUTyOnbyJOShjvnj0CJiYSwFBh7ajeHM5aA2SVr
	avHO0q7qtQS99x9sqSzYcG/cpLgc2tVcgFl0ctlv/ovjEsmYjK+JVxGnaP7d2GgTfU8N0r
	R8uxXGA/BbVwPn6QsbshKUvgV+B45Eg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="rDgRq/Bx";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf05.hostedemail.com: domain of feng.tang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=feng.tang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778082383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=raSCPl80ajnarfPmnTKHu+IU1VXBFxdWFJ0Zm2iNnT0=;
	b=l6A39Np+9aRnRvTfAlZQHvXJwryMeu8hH8Yw0ztWJn0iP5sVHsmqkGoEZE1+UHpDCZQu07
	rm2UIzDnks2PWvPPe+M4sTqjGRH+d2rEx1hK1hrSKjwU/mLKUHSwoUbkQJeDHHcaxQkYxe
	d+/UyFEpjYXpo9y1Itja1PKKA4RzQGs=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778082373; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=raSCPl80ajnarfPmnTKHu+IU1VXBFxdWFJ0Zm2iNnT0=;
	b=rDgRq/BxF0W0gWp+8zqWVn5E7MmTXuqjITexnu6h1fcV86wnasXzNNJGpaTTmeANukVbc3MfA7TMPVy62PBsQwt41WxkEqTrlgLs+9XDAiZv/KZqbDPa4qrglNGjdbblWrBIT4wAPA37MoSQbQkfIwZBiemzJxChHrhOhPH1zLM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=feng.tang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0X2Rf7zl_1778082370;
Received: from localhost(mailfrom:feng.tang@linux.alibaba.com fp:SMTPD_---0X2Rf7zl_1778082370 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 06 May 2026 23:46:11 +0800
Date: Wed, 6 May 2026 23:46:10 +0800
From: Feng Tang <feng.tang@linux.alibaba.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Liam.Howlett@oracle.com,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	Christoph Hellwig <hch@lst.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Changrong Chen <chenchangrong.ccr@alibaba-inc.com>
Subject: Re: [PATCH v3] dma-contiguous: setup default numa cma area if not
 configured explicitly
Message-ID: <aftiQuHOA0t2lfyP@U-2FWC9VHC-2323.local>
References: <20260428060550.7167-1-feng.tang@linux.alibaba.com>
 <6dd52f8b-7092-4d02-ba24-f8b55409b7b6@kernel.org>
 <afBxtIdWqv8pD8YE@U-2FWC9VHC-2323.local>
 <f900172c-341a-4956-b7b7-b297418be913@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f900172c-341a-4956-b7b7-b297418be913@kernel.org>
X-Stat-Signature: dfo7qfrcg8kw9jm35rc3whbsg8bij6wo
X-Rspam-User: 
X-Rspamd-Queue-Id: 22F67100007
X-Rspamd-Server: rspam07
X-HE-Tag: 1778082380-796896
X-HE-Meta: U2FsdGVkX19h4k+L5QTWODDkv17oDg0hLwqRoiB2s2uhfcehSOt5yMZ0YH/pETlR1WH4tRX1Ar+uQuXiB/mDuJuNmJQXmFpOSW25Y420Z7g1JnrllEqb4djJcn5Uplq1Fx/Ls23Rfbli1RAkK3c6S36XId8C8CSiS40MyVx/b56ovykTJttMHHCpke7bEU5Fk224L8C8YiTZfRBlOfzE/y5MfudaOMWMRTjq4OMIa3RazvteUb7m94IIELV8KTDhbP1h11btHAMcu6EBkDwiEsJdl/s14vuAceACo3lqz9zqhsstBilSHnHoy9b/mgbXexoywK8OD3cS1YM54BY+lpdr8rGsLlP910ufCQEp3AjkfZ+Gn8OZmRAASjruEd64DRCNe3EcmDCx5HwU6xGLT9rjdBosc+uvLBYWQcs3njJdqse6Re4PXbSWXUTifpR0AfIiUbv39CdDEYddIWpJzjg9NUQ0d+2nCz2nRq9UPvg0+XZ7SZkatP5DfW6DK2wxAlxFtGfTtwZbRWxELp5IV0khqgWcqTPjGnMwp0f8cPJqWy7k2QZH3UKi4Jit2eLdz+tvnE/qeShm5YlB122tShJtLQQo/ZbCmHAykkyl1zLbjiOhT/y0MP0ciPDK593ksFZFI0jgulmu42vFwwsnL9S2yI212M2KEVaAuytTUaXECgwe1cO9Yjxd87bHI3q7PODfIRbYe3RrCSb0y7nYBaRdrMf3oOeMbI64vv6uWCDcjwFQ5oMw/72TDS0ZkaswEscRNzgpNQW3sHUtpIi6UDg5+ulbcswSQoKBMjwJKWLoRi0o4IIhhJVk2ooqcKutZ8ZRLBHxI3V3obtodTrPJSJr1wXUe7t4vq/lr/9+Sc/gkGeGDBvIH7DaPwOzkri7yDJExcovPSHCpBPLbdCLp9spublRyrKRem8PMysEEbupldFmQmHxT7Qy7+DNCaRnxIKWUYweT0qrQ0cYGIx
 PZ39pT7o
 fYhcLO7StzMGSv3y1/GsNw1WUMclVCnQeyQ4yLsLTwkp7HaVJfbd0kDGAkoFQXIZUWYhXi22L6vU+7kixfsP7ZF7O6G0Kx+W4kJPlS4JozxaO1Be5JHVKzmFNI1w4gxz0460Ag0IDgPrxruz1yxUp9ch+6VgB6mGTCWs9hdc+l/ZIQHEt2ulRhPg/1NJ/Dn1ei0A7SnQfRkrTh/ePLCcVTehSwlNFAEOZXpKedhR/XascCCiO5AwhvtDeGk+o1gv9RilWH1fzw0GOnXaA6UE4KUCchl32YX1E8VVVHMOJo6/Hbyk2Q5uF4oryCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 01, 2026 at 08:51:39PM +0200, David Hildenbrand (Arm) wrote:
> On 4/28/26 10:37, Feng Tang wrote:
> > Hi David,
> 
> Hi!
> 
> [...]
> 
> >>
> >> Okay, so on x86 it is not silent, because they don't even have a default CMA area?
> > 
> > Right for default kernel configs.
> > 
> > In kernel/dma/Kconfig:
> > 
> > config CMA_SIZE_MBYTES
> > 	int "Size in Mega Bytes"
> > 	depends on !CMA_SIZE_SEL_PERCENTAGE
> > 	default 0 if X86
> > 	default 16
> > 
> > config CMA_SIZE_PERCENTAGE
> > 	int "Percentage of total memory"
> > 	depends on !CMA_SIZE_SEL_MBYTES
> > 	default 0 if X86
> > 	default 10
> > 
> >>>
> >>> One thought is to follow the current cma reserving policy for platform
> >>> with 'CONFIG_DMA_NUMA_CMA=y', that if the numa cma (either the 'numa cma'
> >>> or 'cma pernuma' method) is not explicitly configured, set it up
> >>> according to size of default 'dma_contiguous_default_area', while
> >>> skipping the numa node where the 'dma_contiguous_default_area' lies
> >>> in, this way the default behavior of platform with one NUMA node is
> >>> kept unchanged.
> >>
> >> So, the kernel is configured to have a certain CONFIG_CMA_SIZE_MBYTES size, but
> >> you go ahead and multiply that by the number of nodes? Sounds wrong.
> > 
> > Yes. I thought about that, and didn't have good solution, and used this
> > given it's on a multi-numa-node machine, which may not be too bad
> > regarding memory usage.
> 
> It sounds wrong given the existing config options.

Yes, it is confusing. 

> > 
> > Robin did concern about the memory usage for embedded/small devices in
> > v2 review, and we change to v3 to not affect them.
> > 
> >>
> >> The whole proposal here looks rather hacky.
> > 
> > I agree :)
> > 
> >> Wouldn't a default for e.g., pernuma_size_bytes make more sense, that users can
> >> then overwrite on the cmdline?
> >  
> > This sounds good to me, if no objection from others. Maybe default 64MB
> > or more. One good part is, all these setup is under protection of
> > CONFIG_DMA_NUMA_CMA. 
> 
> I cannot do the heavy thinking here because -EBUSY, but maybe you want a config
> option similar to CMA_SIZE_MBYTES/CMA_SIZE_PERCENTAGE that either controls that
> these sizes will be split over NUMA nodes, or another one, that sets the default
> for pernuma.

Maybe a CMA_NUMA_SIZE_MBYTES?
 
> [...]
> 
> >>> +extern int cma_get_nid(const struct cma *cma)
> >>> +{
> >>> +	return cma->nid;
> >>> +}
> >>
> >> Why do you have to store the nid instead of just looking it up from the base_pfn
> >> in here?
> > 
> > My thought was 'struct cma' already have 'nid' member, and when CONFIG_NUMA=y,
> > it may be useful to save the 'nid' info instead of NUMA_NO_NODE for the default
> > cma area (cmdline like cma=XXG@YYG could make it on different node)
> 
> Ah, yeah. It's a bit nasty that we have to handle the default area like that.
> 
> Another sign that we probably shouldn't deal with the default area :)

Yep, in v2 I didn't touch the default area, while Robin had a concern
that the v2 approach will bindly add an extra per-numa cma area for
the node which already has the default area, which will hurt those
small/embedded devices which has limited number of memory. Adding
the nid check is trying to keep the behavior of one node device
unchanged.

> > 
> >>
> >> Also, what is the expectation when the ranges would span different NIDs? (is
> >> that possible?)
> > 
> > Per my understanding, it won't. There is a cma_validate_zones() to prevent it
> > from crossing zones.
> 
> It's a bit confusing, because it ignores other nids.

I might have missed your point. Do you mean one cma are could have
multiple ranges? IIUC, the default cma area could have only one range
which was covered by this check, while hugetlb_cma could have multiple
ranges.

Thanks,
Feng

