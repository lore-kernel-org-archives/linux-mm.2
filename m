Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D799FF886C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 08:37:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 731526B0088; Tue, 28 Apr 2026 04:37:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E21A6B008A; Tue, 28 Apr 2026 04:37:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F7E66B008C; Tue, 28 Apr 2026 04:37:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 510546B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:37:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ECBC51B94A4
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:37:18 +0000 (UTC)
X-FDA: 84707310156.29.71E8195
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf27.hostedemail.com (Postfix) with ESMTP id B1CC740007
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:37:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=c0dpP7Hg;
	spf=pass (imf27.hostedemail.com: domain of feng.tang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=feng.tang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777365435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=myH3QOIFz0y2hknBNFxgLWJcfHd2Xwb17shw2Tk83v4=;
	b=XjIFYOvKMuFlYMNjJljGliziUeFD1kt27qjEIB51hIDmMDD4qzow6BKI+d4JYDOXDcfK1g
	t+2LPzqcmRWzZc6P/DP/MI6RtAq4npXXTVrmoUTnOY5N99Nuz/XcIFIAS2gchUs7St9dCV
	P079WQUuHBNDmd8b5UnJI+YVT/Vid+E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=c0dpP7Hg;
	spf=pass (imf27.hostedemail.com: domain of feng.tang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=feng.tang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777365435; a=rsa-sha256;
	cv=none;
	b=xJkNJa1WER8NAB4wDkIxvBux02KT75z16i+5or8FKZO7S3/E/KYKdAdZNZezs9oifiSEFM
	PLregDD6RIGDeQjkQk5rd+or3HBUOCArzuDu7Zve6kUpWD9B0/TFdeE4L20tjVEGvAaZ0b
	s8eoBi1iCUEDdQ4/RyhKCWRA4WQtG3M=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1777365430; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=myH3QOIFz0y2hknBNFxgLWJcfHd2Xwb17shw2Tk83v4=;
	b=c0dpP7HgfFGKLpB3nC8dqF8ECTViQSdBko6BVwsog6umbc+Tdru+hlO5mmjw89srBSqgs/ThxKM4GRjnFN3EXollXAyRjAXmLMu81EIyx0N8+I6AZTJ9L7vepsTTjrIas22gUAF9i9A09xeHVJlfl3FXkTsa75x06TLhigBbe2A=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=feng.tang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0X1txRAC_1777365428;
Received: from localhost(mailfrom:feng.tang@linux.alibaba.com fp:SMTPD_---0X1txRAC_1777365428 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 28 Apr 2026 16:37:09 +0800
Date: Tue, 28 Apr 2026 16:37:08 +0800
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
Message-ID: <afBxtIdWqv8pD8YE@U-2FWC9VHC-2323.local>
References: <20260428060550.7167-1-feng.tang@linux.alibaba.com>
 <6dd52f8b-7092-4d02-ba24-f8b55409b7b6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6dd52f8b-7092-4d02-ba24-f8b55409b7b6@kernel.org>
X-Stat-Signature: cqkof8dc7fbbu6f98erj7pfzwu4p9jyx
X-Rspamd-Queue-Id: B1CC740007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777365434-43289
X-HE-Meta: U2FsdGVkX1+8jsyqZLKOr5xJRyS75JXQEdCVuyyRPXvSbYhHytIvhbFTcAAr8ii4f/6kg7cE19GfSjMU9One+rJpwktE2MP2qolSKQYPQZB7EBaNuY8dMuA3wRCw0GAH/Lv1ylKQrKKhkYvknBvB8huIk69ThSS2bSiIaSwjxlC7T9hrax/xJrPZ0ZxTcS74xke2Xd/idz9vYaLTZGx1T5ZZrY6gmQHU2XkftF1Gj4mIUM54ncXmjaBAzbOdawg5/XqdhPbPtRvGW4R9kI+yP1MsIBHIPNQRliNtByMS6NR1vqBD9gNkywlWFJA6MBDr9WFYDk2+kID/wPvqVVscjkkMHyKwfHiL4hG9duhw/M3mZp7Pmnv0CEwyNZTcFaJAbs9HY1so5QAconkE1KAQK1X7lzm8pjHlR6b9COvy3TNvEzl9nPBq4QiWWcsahkSk4ZUzYBMUyT6uwmHf9fgk8pCEZtK2sfe9ryp9c+39TC57lfc1/MAuXe38YQwgvUx6pcG5bNpzAfVpqD5yPxzDyNyaXQS9YrgHr1fjYfi06bFzgvap2sR1ulT4qpjOeGyYvF0B4dfQOntzgSxr91P4sE2j555B9L5KrrvUH9Evtn2VimmK7pVJl15VmYaqJAc6XX84DrhDhtSku3d2aWRhdJKH2bxoZBSpaq5PGiZKSlGlectaoHhWcsngtsjwXDDpBasKzOrd4ZVeXaHzo2OOuCkvjD7Rqivqf4LyIzyLu7f+4AwPszAVxgu3vL+BRSkLgAfjO7L/+IJGnwsu1s8zIj6RlpdXSgTqy51WPYW3wQiek6dWWQtf/NstZjH17i6kU8yWf21bw04Mewwwnjm2BSfEOGuEbmvk4Vj7RPQoGzuKtej5exuV4AWSmyCQh51cGNCtrUaUalV5TtT2JQomIxTA1ax93kM8ajytbNUCPu/n11jiRTMC6fSJapM/IVIwhaIJfERoUUdEuAFda5q
 /nN3kcsa
 lwjaMy7PP/mV/VXsri74kRA/lO+o8z7AVjkxgIen/JvOAnuH+MFpSLRBA+iJv78godoblI/l/3XlI6e4l+d3uMjXddzbG8E3PJrL+EEB0C5UyD2QckUHY4NFOYsVt2bsZ+D/z8585RHCwE2xkjeMwej9Egcsm4Cc5iw5FJRojJbfJOkBX40aH1yEf9zWlLzVRCUIlWH1MEC48B9wfRIkibPw8u8W4bN2SPyAPndqHpO6/T5CcHap7fvMEdaIwMi+KAjLXwb5sq1Qf0u55+EtPMxNrqZVRiT7t8ViFQUKA2tajlNTG7jGJxd5cqdjDE7XISJ2+qxjOd+hG4JsJR/EPnDVoxs2bbqg4u6gNXR89MjkSvzTNUWh03a4AiTuiUJbFpcbsgv8u3zPFpsp17n23wChaJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

Thanks for the review!

On Tue, Apr 28, 2026 at 09:52:15AM +0200, David Hildenbrand (Arm) wrote:
> On 4/28/26 08:05, Feng Tang wrote:
> > There was a report on a multi-numa-nodes ARM server that when IOMMU is
> > disabled, the dma_alloc_coherent() function always returns memory from
> > node 0 even for devices attaching to other nodes, while they can get
> > local dma memory when IOMMU is on with the same API.
> > 
> > The reason is, when IOMMU is disabled, the dma_alloc_coherent() will
> > go the direct way and call dma_alloc_contiguous(). The system doesn't
> > have any explicit cma setting (like per-numa cma), and only has a
> > default 64MB cma reserved area (on node 0), where kernel will try
> > first to allocate memory from.
> > 
> > Robin Murphy suggested to setup pernuma cma or disable cma, which did
> > solve the issue. 
> 
> That sounds like the obvious approach to me.

Indeed. We also gave some of them to the reporter once we got the report. 

> > While there is still concern that for customers
> > which don't have much kernel knowledge, they could still suffer from
> > this silently as some architectures enable cma area by default (not
> > an issue for X86 though, which set CONFIG_CMA_SIZE_MBYTES to 0 by
> > default) for most Linux distributions.
> 
> Okay, so on x86 it is not silent, because they don't even have a default CMA area?

Right for default kernel configs.

In kernel/dma/Kconfig:

config CMA_SIZE_MBYTES
	int "Size in Mega Bytes"
	depends on !CMA_SIZE_SEL_PERCENTAGE
	default 0 if X86
	default 16

config CMA_SIZE_PERCENTAGE
	int "Percentage of total memory"
	depends on !CMA_SIZE_SEL_MBYTES
	default 0 if X86
	default 10

> > 
> > One thought is to follow the current cma reserving policy for platform
> > with 'CONFIG_DMA_NUMA_CMA=y', that if the numa cma (either the 'numa cma'
> > or 'cma pernuma' method) is not explicitly configured, set it up
> > according to size of default 'dma_contiguous_default_area', while
> > skipping the numa node where the 'dma_contiguous_default_area' lies
> > in, this way the default behavior of platform with one NUMA node is
> > kept unchanged.
> 
> So, the kernel is configured to have a certain CONFIG_CMA_SIZE_MBYTES size, but
> you go ahead and multiply that by the number of nodes? Sounds wrong.

Yes. I thought about that, and didn't have good solution, and used this
given it's on a multi-numa-node machine, which may not be too bad
regarding memory usage.

Robin did concern about the memory usage for embedded/small devices in
v2 review, and we change to v3 to not affect them.

> 
> The whole proposal here looks rather hacky.

I agree :)

> Wouldn't a default for e.g., pernuma_size_bytes make more sense, that users can
> then overwrite on the cmdline?
 
This sounds good to me, if no objection from others. Maybe default 64MB
or more. One good part is, all these setup is under protection of
CONFIG_DMA_NUMA_CMA. 

> > 
> > To get the node info of cma area, add some helpr funciton and setup
> > in cma code.
> > 
> > Reported-by: Changrong Chen <chenchangrong.ccr@alibaba-inc.com>
> > Suggested-by: Ying Huang <ying.huang@linux.alibaba.com>
> > Suggested-by: Robin Murphy <robin.murphy@arm.com>
> > Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
> > ---
> > Changelog:
> > 
> >   since v2:
> >     * setup the numa cma are following default cma, while
> > 	  skipping the node holds the default cma (Robin Murphy)
> > 	* add cma_get_node() help and related code
> > 	* add reporter info 
> > 
> >   since v1:
> > 	* don't use the original way of adding alloc_pages_node()
> > 	  before trying default cma node (Robin Murphy)
> > 	* setup default numa cma area if not configured (Ying Huang)
> > 
> >    v2: https://lore.kernel.org/lkml/20260423095243.14239-1-feng.tang@linux.alibaba.com/
> >    v1: https://lore.kernel.org/lkml/20260414090310.92055-1-feng.tang@linux.alibaba.com/
> > 
> >  include/linux/cma.h     |  1 +
> >  kernel/dma/contiguous.c | 14 ++++++++++++--
> >  mm/cma.c                | 11 ++++++++++-
> >  3 files changed, 23 insertions(+), 3 deletions(-)
[...]
> > +extern int cma_get_nid(const struct cma *cma)
> > +{
> > +	return cma->nid;
> > +}
> 
> Why do you have to store the nid instead of just looking it up from the base_pfn
> in here?

My thought was 'struct cma' already have 'nid' member, and when CONFIG_NUMA=y,
it may be useful to save the 'nid' info instead of NUMA_NO_NODE for the default
cma area (cmdline like cma=XXG@YYG could make it on different node)

> 
> Also, what is the expectation when the ranges would span different NIDs? (is
> that possible?)

Per my understanding, it won't. There is a cma_validate_zones() to prevent it
from crossing zones.

Thanks,
Feng

> 
> -- 
> Cheers,
> 
> David

