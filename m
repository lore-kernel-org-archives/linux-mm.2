Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3252CCA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 08:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B17FE8E003B; Wed, 20 Aug 2025 04:54:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF1928E0037; Wed, 20 Aug 2025 04:54:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2CF98E003B; Wed, 20 Aug 2025 04:54:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 91BC78E0037
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:54:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A789160409
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:54:22 +0000 (UTC)
X-FDA: 83796524364.17.52F1A04
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf07.hostedemail.com (Postfix) with ESMTP id E959540003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:54:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755680060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y94xWgJkWzyiG2PFh43lADMURu7tuZZhBa0gZwmOVXo=;
	b=oBD2D3N4FSDfhC5fRp1ZORdWythsnXgrCGjUIzmF445GNNjTQkPtN/aVQPPS6/vD3IpzJX
	yZI1PfTxkZMpK7HoHM78O9Kq5oeZebS1NqKeOh9O069PUgw12ijMzK6xxcU3x4a1YN9dwl
	R0O5Iy70ncz/t//DvyZUs7VC+sV2H3c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755680060; a=rsa-sha256;
	cv=none;
	b=ipx6Frm50nKkWBLoTkckityQO6d5eiRiXkjcvIHQG1zoFHMdVhtJskKEO17BOPt2HXrKh6
	nEteqnA4BtmVt0dauN02FVXMDNNwsnPEkn8DrIVzMaqO9Wuqqq0RG+HNDF9xST8z0whItk
	OXebSkPF3OvXqLVc5M2ZaNL8r70nhtI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4c6KtT2CW1z6FHD3;
	Wed, 20 Aug 2025 16:51:13 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 07A5D1402FB;
	Wed, 20 Aug 2025 16:54:16 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 20 Aug
 2025 10:54:14 +0200
Date: Wed, 20 Aug 2025 09:54:13 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Mike Rapoport <rppt@kernel.org>
CC: <shiju.jose@huawei.com>, <rafael@kernel.org>, <bp@alien8.de>,
	<akpm@linux-foundation.org>, <dferguson@amperecomputing.com>,
	<linux-edac@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-doc@vger.kernel.org>, <tony.luck@intel.com>,
	<lenb@kernel.org>, <leo.duran@amd.com>, <Yazen.Ghannam@amd.com>,
	<mchehab@kernel.org>, <linuxarm@huawei.com>, <rientjes@google.com>,
	<jiaqiyan@google.com>, <Jon.Grimm@amd.com>, <dave.hansen@linux.intel.com>,
	<naoya.horiguchi@nec.com>, <james.morse@arm.com>, <jthoughton@google.com>,
	<somasundaram.a@hpe.com>, <erdemaktas@google.com>, <pgonda@google.com>,
	<duenwen@google.com>, <gthelen@google.com>, <wschwartz@amperecomputing.com>,
	<wbs@os.amperecomputing.com>, <nifan.cxl@gmail.com>, <tanxiaofei@huawei.com>,
	<prime.zeng@hisilicon.com>, <roberto.sassu@huawei.com>,
	<kangkang.shen@futurewei.com>, <wanghuiqiang@huawei.com>
Subject: Re: [PATCH v11 1/3] mm: Add support to retrieve physical address
 range of memory from the node ID
Message-ID: <20250820095413.00003bd7@huawei.com>
In-Reply-To: <aKV6dVkPiBPw595T@kernel.org>
References: <20250812142616.2330-1-shiju.jose@huawei.com>
	<20250812142616.2330-2-shiju.jose@huawei.com>
	<20250819175420.00007ce6@huawei.com>
	<aKV6dVkPiBPw595T@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.66]
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 frapeml500008.china.huawei.com (7.182.85.71)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E959540003
X-Stat-Signature: zh9tedayeyiuqdqepuwds1djauna6sfe
X-HE-Tag: 1755680059-830761
X-HE-Meta: U2FsdGVkX18NuwAN6fIOYG8TEJAw9pCwBJ5V/+y79bO9L2Y7wNuJOdRat03zFKzp1Vz5rDHhZYkG5jm1xOQXSLxQn88PabjTdDvJvjgxXtkaA6ifV26+4OJrYXdcSQVHp4o3NhV3I6o6mpDThPMso5FWCe3iDSdPsH31h31Tsk/Ra1qZhtSqVGbJV08vjHHO8IizBcNuYenKsB9n9BSKthV5NVdb6NU5alvGWLRgI6Sn4jzZ0zlF8KpqioJYgXpNBUDZ3Tot+ePIaojnUq9E9qrG/wJZq710X9ji6pIVi/K5hTNgjJeMLOy3P3f6HmjJRnvqndPNvLNC4mogPhSSttBwbiyP72ZJGDz+uLbYnYQXlKHxdV0f8BFnZyfHLymHws8gyP+/p/3pKJfDWS/BU3U1dSa1MhrcRlAjA2nVpkIivdEuARN8zZ9GAi/C2kaNh07D+tE5kRxDW6l3OyRkCaWHy1id2q6QbxfCU9EEydZWGA4xXPo6lcb+oLonZxAT3AMTbfimad7UykN39avwKYqAJc4KluCpDF/bNpSwI/ehirz3KE7+vcQpsKup42qOj3sorsbd7gRGbqBUtoAi42pDAPAQ9R4flALI7OqyLbiIQ88TWTUaC1aJOJGA7WU4Nceg9Z3URneTiDfo2ngeRJrxlHE/TKEv/9YTH139En7njda3cLeSN1XOW9PvxAx94SV73jCu2tk3FqwRWxYO5ASzAM5b0QD2Fa1ceQtYsZZpXdncGRzqbLvNFaHFBg0upIuxFSYoOa3Qr53Y3kg6HgYgg0UfnYRS5gMoHWqJNvPMzUhBAB5Iz1ivRToWnwgrML0C0Qt8gGyGSM3dw1RuzYVm6BPJ58SNtOZLBOtaFeLjR/AmhvqywWwwIEk73KFZzE514TrAwx+6HbktpEXWkbZoKwQs08Gp8modCzoRlMqWd+psVyd9YHZLZG5S+njQ0mKXDSFqGNEgpKmSCcV
 xKZ4Y6/x
 xb3WU+VEVLj1CsIUAoIBu3QzRN7lmZCaYMHnbVQNWNGK1CAl0mfjcx61SEN+mjLwTmNxJaR22k/vfJn8cU4tkB0i+djExehoOw8av1suyZiRiL6GXlwq3gxdlN08Vl8yuahhpu5pItJzO1gvLCpk3QLinRMFcSDpaU8XaToF5pEhpIh6CJUA6ut3o8+0fBf18INcEQRTVBTncxf0iMfhM5bRhRNg4XjO0O6wpaFPrbbvmr1kYlMZ5h0ufQx4OFxU5DHfxT2rJruWsc/pnYHLBCawMQPKQnxX3NVAnvc67Rhinjh4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 Aug 2025 10:34:13 +0300
Mike Rapoport <rppt@kernel.org> wrote:

> On Tue, Aug 19, 2025 at 05:54:20PM +0100, Jonathan Cameron wrote:
> > On Tue, 12 Aug 2025 15:26:13 +0100
> > <shiju.jose@huawei.com> wrote:
> >   
> > > From: Shiju Jose <shiju.jose@huawei.com>
> > > 
> > > In the numa_memblks, a lookup facility is required to retrieve the
> > > physical address range of memory in a NUMA node. ACPI RAS2 memory
> > > features are among the use cases.
> > > 
> > > Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> > > Signed-off-by: Shiju Jose <shiju.jose@huawei.com>  
> > 
> > Looks fine to me.  Mike, what do you think?  
> 
> I still don't see why we can't use existing functions like
> get_pfn_range_for_nid() or memblock_search_pfn_nid().
> 
> Or even node_start_pfn() and node_spanned_pages().

Good point.  No reason anyone would scrub this on memory that hasn't
been hotplugged yet, so no need to use numa-memblk to get the info.
I guess I was thinking of the wrong hammer :)

I'm not sure node_spanned_pages() works though as we need not to include
ranges that might be on another node as we'd give a wrong impression of
what was being scrubbed.

Should be able to use some combination of node_start_pfn() and maybe
memblock_search_pfn_nid() to get it though (that also gets the nid
we already know but meh, no ral harm in that.)

Jonathan




>
> > One passing comment inline.
> > 
> > Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> >   
> > > ---
> > >  include/linux/numa.h         |  9 +++++++++
> > >  include/linux/numa_memblks.h |  2 ++
> > >  mm/numa.c                    | 10 ++++++++++
> > >  mm/numa_memblks.c            | 37 ++++++++++++++++++++++++++++++++++++
> > >  4 files changed, 58 insertions(+)
> > > 
> > > diff --git a/include/linux/numa.h b/include/linux/numa.h
> > > index e6baaf6051bc..1d1aabebd26b 100644
> > > --- a/include/linux/numa.h
> > > +++ b/include/linux/numa.h
> > > @@ -41,6 +41,10 @@ int memory_add_physaddr_to_nid(u64 start);
> > >  int phys_to_target_node(u64 start);
> > >  #endif
> > >  
> > > +#ifndef nid_get_mem_physaddr_range
> > > +int nid_get_mem_physaddr_range(int nid, u64 *start, u64 *end);
> > > +#endif
> > > +
> > >  int numa_fill_memblks(u64 start, u64 end);
> > >  
> > >  #else /* !CONFIG_NUMA */
> > > @@ -63,6 +67,11 @@ static inline int phys_to_target_node(u64 start)
> > >  	return 0;
> > >  }
> > >  
> > > +static inline int nid_get_mem_physaddr_range(int nid, u64 *start, u64 *end)
> > > +{
> > > +	return 0;
> > > +}
> > > +
> > >  static inline void alloc_offline_node_data(int nid) {}
> > >  #endif
> > >  
> > > diff --git a/include/linux/numa_memblks.h b/include/linux/numa_memblks.h
> > > index 991076cba7c5..7b32d96d0134 100644
> > > --- a/include/linux/numa_memblks.h
> > > +++ b/include/linux/numa_memblks.h
> > > @@ -55,6 +55,8 @@ extern int phys_to_target_node(u64 start);
> > >  #define phys_to_target_node phys_to_target_node
> > >  extern int memory_add_physaddr_to_nid(u64 start);
> > >  #define memory_add_physaddr_to_nid memory_add_physaddr_to_nid
> > > +extern int nid_get_mem_physaddr_range(int nid, u64 *start, u64 *end);
> > > +#define nid_get_mem_physaddr_range nid_get_mem_physaddr_range
> > >  #endif /* CONFIG_NUMA_KEEP_MEMINFO */
> > >  
> > >  #endif /* CONFIG_NUMA_MEMBLKS */
> > > diff --git a/mm/numa.c b/mm/numa.c
> > > index 7d5e06fe5bd4..5335af1fefee 100644
> > > --- a/mm/numa.c
> > > +++ b/mm/numa.c
> > > @@ -59,3 +59,13 @@ int phys_to_target_node(u64 start)
> > >  }
> > >  EXPORT_SYMBOL_GPL(phys_to_target_node);
> > >  #endif
> > > +
> > > +#ifndef nid_get_mem_physaddr_range
> > > +int nid_get_mem_physaddr_range(int nid, u64 *start, u64 *end)
> > > +{
> > > +	pr_info_once("Unknown target phys addr range for node=%d\n", nid);
> > > +
> > > +	return 0;
> > > +}
> > > +EXPORT_SYMBOL_GPL(nid_get_mem_physaddr_range);
> > > +#endif
> > > diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
> > > index 541a99c4071a..e1e56b7a3499 100644
> > > --- a/mm/numa_memblks.c
> > > +++ b/mm/numa_memblks.c
> > > @@ -590,4 +590,41 @@ int memory_add_physaddr_to_nid(u64 start)
> > >  }
> > >  EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
> > >  
> > > +/**
> > > + * nid_get_mem_physaddr_range - Get the physical address range
> > > + *				of the memblk in the NUMA node.
> > > + * @nid: NUMA node ID of the memblk
> > > + * @start: Start address of the memblk
> > > + * @end: End address of the memblk
> > > + *
> > > + * Find the lowest contiguous physical memory address range of the memblk
> > > + * in the NUMA node with the given nid and return the start and end
> > > + * addresses.
> > > + *
> > > + * RETURNS:
> > > + * 0 on success, -errno on failure.
> > > + */
> > > +int nid_get_mem_physaddr_range(int nid, u64 *start, u64 *end)
> > > +{
> > > +	struct numa_meminfo *mi = &numa_meminfo;
> > > +	int i;
> > > +
> > > +	if (!numa_valid_node(nid))
> > > +		return -EINVAL;
> > > +
> > > +	for (i = 0; i < mi->nr_blks; i++) {
> > > +		if (mi->blk[i].nid == nid) {
> > > +			*start = mi->blk[i].start;
> > > +			/*
> > > +			 * Assumption: mi->blk[i].end is the last address
> > > +			 * in the range + 1.  
> > 
> > This was my fault for asking on internal review if this was documented
> > anywhere. It's kind of implicitly obvious when reading numa_memblk.c
> > because there are a bunch of end - 1 prints.
> > So can probably drop this comment.
> >   
> > > +			 */
> > > +			*end = mi->blk[i].end;
> > > +			return 0;
> > > +		}
> > > +	}
> > > +
> > > +	return -ENODEV;
> > > +}
> > > +EXPORT_SYMBOL_GPL(nid_get_mem_physaddr_range);
> > >  #endif /* CONFIG_NUMA_KEEP_MEMINFO */  
> >   
> 


