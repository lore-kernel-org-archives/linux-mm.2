Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEA2CD6100A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 11:36:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDDB26B0088; Thu, 29 Jan 2026 06:36:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C61586B0089; Thu, 29 Jan 2026 06:36:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6D826B008C; Thu, 29 Jan 2026 06:36:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A6CD96B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 06:36:17 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CF5A160972
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:36:17 +0000 (UTC)
X-FDA: 84384797994.12.76B3FF4
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3870F180009
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:36:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VLRUTcDO;
	spf=pass (imf06.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769686575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wI26mgk49lgLhCsakpVqc1lnp0wxouQs7L+0UFUDFuo=;
	b=ui6qColX6FHhlSpWCGzqS75FjEMgRRfynPoLsaaMoeFs8uhLsiswc/41RMUr22iduVOePd
	Yo8vHJs3QUA4uXQubdQuK6FmIDcWNtYswtO51vhVO9sTDBVcZu/LMTav9HTRLNeX0EdPlZ
	ZD4SX2RW33Z94lN4wG57pYjHrKySV7Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VLRUTcDO;
	spf=pass (imf06.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769686575; a=rsa-sha256;
	cv=none;
	b=TRAz94yrFcqlunUH8JsUrGprhS7FV+uoe7cD5mm/H8vvid8n8jM8gQyC/Zn9jeZq9nckUe
	CptvKNYa05o1RnHoNy8/YVQaVQOxM9JiPMrFL2hVqSLgIFl5KOccjU68Z/HQLTW24FD+KU
	nlbBn0oQnzPiSUseglPhMlEbsN8BvtQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769686570; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=wI26mgk49lgLhCsakpVqc1lnp0wxouQs7L+0UFUDFuo=;
	b=VLRUTcDOC6sdDDZoNGp/5LTM95JVuf8oiKV84vOZX3OoPIfAB7K0LLLqwHuMptcDYeG+dFBM+p7P61Fe26ZHNMQCLnNMUZxZRksYWu5uiqv5oJh8RhfMZpjGAZZGYWgGR4goFl54NMdbdsMAXd7pRxJS+41ljtPrkTpVMQykgOg=
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0Wy7EuPK_1769686569 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 29 Jan 2026 19:36:09 +0800
Date: Thu, 29 Jan 2026 19:36:09 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com    >
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "D. Wythe" <alibuda@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dust Li <dust.li@linux.alibaba.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org, netdev@vger.kernel.org,
	oliver.yang@linux.alibaba.com
Subject: Re: [PATCH net-next 2/3] mm: vmalloc: export find_vm_area()
Message-ID: <20260129113609.GA37734@j66a10360.sqa.eu95>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
 <20260123082349.42663-3-alibuda@linux.alibaba.com>
 <aXPEFdEdtSmd6AzF@milan>
 <20260124093505.GA98529@j66a10360.sqa.eu95>
 <aXSjm1DXm6yP62tD@pc636>
 <20260124145754.GA57116@j66a10360.sqa.eu95>
 <20260127133417.GU13967@unreal>
 <20260128034558.GA126415@j66a10360.sqa.eu95>
 <20260128180629.GT1641016@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128180629.GT1641016@ziepe.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3870F180009
X-Stat-Signature: jyx4oxqafhedrpwc43h1yieqnhim5het
X-Rspam-User: 
X-HE-Tag: 1769686573-849563
X-HE-Meta: U2FsdGVkX19C3KfMPIkx4jCOFK3WKGSohpuMkeO3F7HmGPN0A+yswue6iB10aoy7pv2MNUuPkB6nbUuMPHIuit3B2jWlRpcHAllNkf8FZyBIJXfaR4m7svR+B7ZUl2zUVf3sc7uCcscrFxa5jFTi7EWZPuLTa7eRG5mFwzcbA76X7YLFtGlN+VdAAXRZWsWH4L58ZA8FT3sPuEBRHcXo5ZWLAE8HXOI7bvceCahgQFJaBUhMO4JKZU1BdAor2u5UEqxL0JmwUuIvBnqZUKPA6StZsySek+QleikU10yCXhdpGKcaKS5cnjTOCru7FPFbppQgBcdNm87AlzGqZhjvx7Nz96ceTHBj/AOftG59rS9w8jfxFfCzeGtYWQpykEnsPZUrOBU4Ai+VILos4xBpcf/zs+WRDl8HPmc3pnxZCqoku/TEqyZhTSsQZRTPR9DrQfB6LxGSY5mhaPYcp/WLCinEKFO+AfZg/m1BeqlhLQbOFvQeRwygIPbE7QOVMVoY0lMWh7uVlPoQ8/oFyF3kOEK+TZlBhEH/80hfDBSwGS9KeQWHNXubQM7VRivHtIoWrlFlGmU8e/RJgWZRiMJQId94jMImm2Jb3+rWDv+p/66mZ6L9FqgYcvxwDDqPZ3HodrsQeyDHkPd78dAFQkdHj9sYWFswil9j9kEhWOSgDp8S6+nInbe/KJqZshRVlBm8Oto5A45OKUZ2wFHBSNm5SSNgK1LeWlhSRLiwiOCJrTbG8XiXj17U4Q83IYKab9PZQ82Jj8pc5kIhyPi32HB7qIEweIxylBQ436no8HnM6ADs/QUzsW4+LugDTXyBRHRqB5sh3tgvg+l1yi3lk6p+2m6ua45hMUeqXu//+0K1oUkVxqx9ghsRHf+NTpAyEN5h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 02:06:29PM -0400, Jason Gunthorpe wrote:
> On Wed, Jan 28, 2026 at 11:45:58AM +0800, D. Wythe wrote:
> 
> > By leveraging vmalloc_huge() and the proposed helper to increase the
> > page_size in ib_map_mr_sg(), each MTTE covers a much larger contiguous
> > physical block.
> 
> This doesn't seem right, if your goal is to take a vmalloc() pointer
> and convert it to a MR via a scatterlist and ib_map_mr_sg() then you
> should be asking for a helper to convert a kernel pointer into a
> scatterlist.
> 
> Even if you do this in a naive way and call the
> sg_alloc_append_table_from_pages() function it will automatically join
> physically contiguous ranges together for you.
> 
> From there you can check the resulting scatterlist and compute the
> page_size to pass to ib_map_mr_sg().
> 
> No need to ask the MM for anything other than the list of physicals to
> build the scatterlist with.
> 
> Still, I wouldn't mind seeing a helper to convert a kernel pointer
> into a scatterlist because I have see that opencoded in a few places,
> and maybe there are ways to optimize that using more information from
> the MM - but it should be APIs used only by this helper not exposed to
> drivers.
> 
> Jason

Hi Jason,

To be honest, I was previously unaware of the
sg_alloc_append_table_from_pages() function, although I had indeed
considered manually calculating the size of contiguous physical blocks.
The reason I proposed the MM helper is that SMC is not driver, it  utilizes
vmalloc() for memory allocation and is thus in direct contact with the MM;
from this perspective, having the MM provide the page_order would be the most
straightforward approach.

Given the significant opposition and our plans to transition SMC to newer
APIs in the future anyway, I agree that introducing this helper now is
less justified.

I will follow your suggestion and update the next version accordingly.

Thanks.



