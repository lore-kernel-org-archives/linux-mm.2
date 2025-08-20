Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C69AACA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 07:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 400818E002B; Wed, 20 Aug 2025 03:34:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D8AA8E0011; Wed, 20 Aug 2025 03:34:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 315478E002B; Wed, 20 Aug 2025 03:34:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F7418E0011
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 03:34:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C5C92833DE
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 07:34:30 +0000 (UTC)
X-FDA: 83796323100.04.E39CCF2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3E8BDA0011
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 07:34:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aksLANPG;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755675269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5SuTcLNdKoIAO8Og45k+YJUJstaHAJrEBeoLgMEQAzQ=;
	b=Wav0YT+W70aC6Cos0Rkjdm4J+pbCzNmWp4oopTRI51/hd84ECH3jK3expTY5Et43FD9YoR
	mlS+re62bgTsvIXfihOxjSG26j9DsCKXZoDPomjI1dXFROYrN5tcXl8Cw/iKgvD8ATXJWW
	JGtECselkclvjBR+SVzPXCTEiSeTh3U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755675269; a=rsa-sha256;
	cv=none;
	b=6qiOKZdMknABTx+6vFg6nBo023WH1yTGitV4fyPM0+nm/ZRibPRC/GiYs/Ei4xgr2I9Go+
	vVBLBnd58y8Dxadd5nzjlgegAWcfRQV5/aEIJUkVMfqnMfxwopaWusn4kGdORd99VbZJ8q
	KLy8ttiGwyZS4XDx/+JZ2s38vg+CaEk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aksLANPG;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 40068613AB;
	Wed, 20 Aug 2025 07:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E56EC4CEEB;
	Wed, 20 Aug 2025 07:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755675267;
	bh=S0V/4dKtt8sp5Rr98YYau2qnf57W5w/l2pXbvrWzIZE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aksLANPGpnI9UQe5XTTQfMLhWuAJfl4+lnUMD7idLLVt/7G9V17mbP2+ZVsieHrkJ
	 BaP2URMB7jrlbkiQnAvyih2743LQBwny1XJjC3jqtpy8q+zOBXVOjJKoY7jnyPr+/4
	 g/d7HOMIt3S/WVb2PUjeMQD8HVuB4cDz29q85/KOkhOpUpPQeg5sySUDHAB/j0qVp7
	 OPdwxIuaYdDRnSLNmiWhNPRBwYX+2JDnESggo5FwcPLsLWEWreiI9lpk3I34F4bn7U
	 D7Q2snD2Xzqdg3UGTCkZnYHRMpMkD0sP4sqvk7+576a0tL7C6KLY86LHTK9GOIjxjV
	 mEVgXf8lxy/yg==
Date: Wed, 20 Aug 2025 10:34:13 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: shiju.jose@huawei.com, rafael@kernel.org, bp@alien8.de,
	akpm@linux-foundation.org, dferguson@amperecomputing.com,
	linux-edac@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org, tony.luck@intel.com,
	lenb@kernel.org, leo.duran@amd.com, Yazen.Ghannam@amd.com,
	mchehab@kernel.org, linuxarm@huawei.com, rientjes@google.com,
	jiaqiyan@google.com, Jon.Grimm@amd.com, dave.hansen@linux.intel.com,
	naoya.horiguchi@nec.com, james.morse@arm.com, jthoughton@google.com,
	somasundaram.a@hpe.com, erdemaktas@google.com, pgonda@google.com,
	duenwen@google.com, gthelen@google.com,
	wschwartz@amperecomputing.com, wbs@os.amperecomputing.com,
	nifan.cxl@gmail.com, tanxiaofei@huawei.com,
	prime.zeng@hisilicon.com, roberto.sassu@huawei.com,
	kangkang.shen@futurewei.com, wanghuiqiang@huawei.com
Subject: Re: [PATCH v11 1/3] mm: Add support to retrieve physical address
 range of memory from the node ID
Message-ID: <aKV6dVkPiBPw595T@kernel.org>
References: <20250812142616.2330-1-shiju.jose@huawei.com>
 <20250812142616.2330-2-shiju.jose@huawei.com>
 <20250819175420.00007ce6@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819175420.00007ce6@huawei.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3E8BDA0011
X-Stat-Signature: 3uosphgjmskry3h1ni45onwdhg4n4tmz
X-Rspam-User: 
X-HE-Tag: 1755675269-354990
X-HE-Meta: U2FsdGVkX1/ueYl9aQ7dI/C1UVvbo3c+DiWgQ30DP1Ar1/xyycYdcujMAvS8aM3j3eJpp5dz6to0BZx5xfjFj1TZvJXVjXx/XArdJHFtkJxx/8z1d2wi9XPgZNQ5tCSLMT2xAf0p2CvHsI7C+wP7FOse032clbDUAUY+CCXgGkRYNi+W8D0qv3Oj3Uwb+6HoH4dV/DIHViDCP11lxKHFLOMQ1s7zEY9oZnJOSzyT53cNVM5ou7OuKgus/+QcWIHYEsKV4KDxQpcDU/U7PM03vP8LH4usPk7nAI4j3SHs6aICbeskD2QlM7OlKSwR8xivfyg3MSdV41DR1CxS+8gL0uvDGTrgFqYldc2OXUZPHB5T6/dtARhfMsuVj35YdMUReyTWWof0jBlbttbdF2/ATXtIPCwVPr+A3RIDrrqDrDsBZIPNPQdt8xTQwoc3cwADvMbCOktf75T16rQxojH1fGkP8YyilMIXvjayGw6fRfZDNtIAFgEKmk15kiqGFEuXJW4lvrdse+ficlXGwe5CHLAUBWTeiH0EKy/NTIZMU80W6Gj3EPXLLI7oz0zqxqG8WxZxgcLQUTlpx2AbbwssYgtv0YeQZBpdOcTJ9z2ckFDkHk/X+QHJMjT4VFw3/GFC2jiVyROCiHpJ0FCGzN5KO3lJHg/tVfUV3eQmA0/faCW62JpX0nhJgVHZsiv4gtSbyXhClztMcghRa4Kalu9lC0pBCqFAzpW/DhgfBRFVwxwkJu+EJ5Ycvqy3TiiFA0qxZkJ6TfDIxHqadC10C7VNsClNU8/uqufQzIgcXHdwqdugVfRAWU9J6PkBXyDK1wUkL4vB2AB7RiY3woY6tHSr3UufWXTeFDjCblipV3ddfyRZtz6zV+nCJVEAkOcGXYWKm6+FA/Qlnml/3FkBbEJcLEvKU2q8IpSnDTEz1M3lmbUNMQ5jWJIcPkuHLwd64dMT4ex7n3gIaB5rFjztSfj
 KGyqnoUn
 Wkn6BfuV4+/XGMxLTH3eGPCj189AjNpTd1aROXxDFkJcLp4eY9g//RJdNYWn/Qmy7acPK4Yc6VIf8FAxAgDx7GLAetNnNee8CeCfF1DVR00XhgUO3JJBSC+KxOppILTWtipH5BQyPpF13UI/CZslfMPGVs5xmN0MKz30ebLQ8VRgyud90+vlDX1HyB8aXmkKTgvK3p8g+LGSNVkZFsdl3cTa0lfGRkBDiJoQvNHRaUnMo9NuEgph0UArK1Wv0AWJVryWaU16aHftSNAoRj7j3QVeLFb63w3WZO9/FPGwZLMGoT1/SX9nviO3gu0tHJax+E5sHFJCd8TOVj5xIufT4OIWGBbk2qjUZnCUcPKw0aE2RQO3edpMPuVckA6pULSwL3Z0A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 05:54:20PM +0100, Jonathan Cameron wrote:
> On Tue, 12 Aug 2025 15:26:13 +0100
> <shiju.jose@huawei.com> wrote:
> 
> > From: Shiju Jose <shiju.jose@huawei.com>
> > 
> > In the numa_memblks, a lookup facility is required to retrieve the
> > physical address range of memory in a NUMA node. ACPI RAS2 memory
> > features are among the use cases.
> > 
> > Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> > Signed-off-by: Shiju Jose <shiju.jose@huawei.com>
> 
> Looks fine to me.  Mike, what do you think?

I still don't see why we can't use existing functions like
get_pfn_range_for_nid() or memblock_search_pfn_nid().

Or even node_start_pfn() and node_spanned_pages().

> One passing comment inline.
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> 
> > ---
> >  include/linux/numa.h         |  9 +++++++++
> >  include/linux/numa_memblks.h |  2 ++
> >  mm/numa.c                    | 10 ++++++++++
> >  mm/numa_memblks.c            | 37 ++++++++++++++++++++++++++++++++++++
> >  4 files changed, 58 insertions(+)
> > 
> > diff --git a/include/linux/numa.h b/include/linux/numa.h
> > index e6baaf6051bc..1d1aabebd26b 100644
> > --- a/include/linux/numa.h
> > +++ b/include/linux/numa.h
> > @@ -41,6 +41,10 @@ int memory_add_physaddr_to_nid(u64 start);
> >  int phys_to_target_node(u64 start);
> >  #endif
> >  
> > +#ifndef nid_get_mem_physaddr_range
> > +int nid_get_mem_physaddr_range(int nid, u64 *start, u64 *end);
> > +#endif
> > +
> >  int numa_fill_memblks(u64 start, u64 end);
> >  
> >  #else /* !CONFIG_NUMA */
> > @@ -63,6 +67,11 @@ static inline int phys_to_target_node(u64 start)
> >  	return 0;
> >  }
> >  
> > +static inline int nid_get_mem_physaddr_range(int nid, u64 *start, u64 *end)
> > +{
> > +	return 0;
> > +}
> > +
> >  static inline void alloc_offline_node_data(int nid) {}
> >  #endif
> >  
> > diff --git a/include/linux/numa_memblks.h b/include/linux/numa_memblks.h
> > index 991076cba7c5..7b32d96d0134 100644
> > --- a/include/linux/numa_memblks.h
> > +++ b/include/linux/numa_memblks.h
> > @@ -55,6 +55,8 @@ extern int phys_to_target_node(u64 start);
> >  #define phys_to_target_node phys_to_target_node
> >  extern int memory_add_physaddr_to_nid(u64 start);
> >  #define memory_add_physaddr_to_nid memory_add_physaddr_to_nid
> > +extern int nid_get_mem_physaddr_range(int nid, u64 *start, u64 *end);
> > +#define nid_get_mem_physaddr_range nid_get_mem_physaddr_range
> >  #endif /* CONFIG_NUMA_KEEP_MEMINFO */
> >  
> >  #endif /* CONFIG_NUMA_MEMBLKS */
> > diff --git a/mm/numa.c b/mm/numa.c
> > index 7d5e06fe5bd4..5335af1fefee 100644
> > --- a/mm/numa.c
> > +++ b/mm/numa.c
> > @@ -59,3 +59,13 @@ int phys_to_target_node(u64 start)
> >  }
> >  EXPORT_SYMBOL_GPL(phys_to_target_node);
> >  #endif
> > +
> > +#ifndef nid_get_mem_physaddr_range
> > +int nid_get_mem_physaddr_range(int nid, u64 *start, u64 *end)
> > +{
> > +	pr_info_once("Unknown target phys addr range for node=%d\n", nid);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(nid_get_mem_physaddr_range);
> > +#endif
> > diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
> > index 541a99c4071a..e1e56b7a3499 100644
> > --- a/mm/numa_memblks.c
> > +++ b/mm/numa_memblks.c
> > @@ -590,4 +590,41 @@ int memory_add_physaddr_to_nid(u64 start)
> >  }
> >  EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
> >  
> > +/**
> > + * nid_get_mem_physaddr_range - Get the physical address range
> > + *				of the memblk in the NUMA node.
> > + * @nid: NUMA node ID of the memblk
> > + * @start: Start address of the memblk
> > + * @end: End address of the memblk
> > + *
> > + * Find the lowest contiguous physical memory address range of the memblk
> > + * in the NUMA node with the given nid and return the start and end
> > + * addresses.
> > + *
> > + * RETURNS:
> > + * 0 on success, -errno on failure.
> > + */
> > +int nid_get_mem_physaddr_range(int nid, u64 *start, u64 *end)
> > +{
> > +	struct numa_meminfo *mi = &numa_meminfo;
> > +	int i;
> > +
> > +	if (!numa_valid_node(nid))
> > +		return -EINVAL;
> > +
> > +	for (i = 0; i < mi->nr_blks; i++) {
> > +		if (mi->blk[i].nid == nid) {
> > +			*start = mi->blk[i].start;
> > +			/*
> > +			 * Assumption: mi->blk[i].end is the last address
> > +			 * in the range + 1.
> 
> This was my fault for asking on internal review if this was documented
> anywhere. It's kind of implicitly obvious when reading numa_memblk.c
> because there are a bunch of end - 1 prints.
> So can probably drop this comment.
> 
> > +			 */
> > +			*end = mi->blk[i].end;
> > +			return 0;
> > +		}
> > +	}
> > +
> > +	return -ENODEV;
> > +}
> > +EXPORT_SYMBOL_GPL(nid_get_mem_physaddr_range);
> >  #endif /* CONFIG_NUMA_KEEP_MEMINFO */
> 

-- 
Sincerely yours,
Mike.

