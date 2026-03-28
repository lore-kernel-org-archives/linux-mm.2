Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2050410F3DCB
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 03:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6D156B008C; Fri, 27 Mar 2026 23:47:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD36F6B0095; Fri, 27 Mar 2026 23:47:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBE5C6B0096; Fri, 27 Mar 2026 23:47:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A693E6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 23:47:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54BEFBE9D3
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 03:47:53 +0000 (UTC)
X-FDA: 84594088026.16.FE37B6E
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id 44A57140009
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 03:47:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YJ+i6hrx;
	spf=pass (imf23.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774669671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZvGpnGl9Qm/IlUyc9WaFTWtqjjf9i8+RUwv6uPlfyM=;
	b=s+ixMRDWMbedt4QaYv1kMJits6Im9tXjgbuKmU2/uwE+Xz7oG3xRBtdTXXIgkskWWTDaXH
	+d/5qdkT9o5jDxHq3Uwd08y0FySKebr6MzSu4y8M75Un6QQ1B/Gz3bNop7A4eBIjoj//Iz
	cEVnUes/i8x4c/0LaQTH0TdEK8uu1rE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YJ+i6hrx;
	spf=pass (imf23.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774669671; a=rsa-sha256;
	cv=none;
	b=bVczsQXY2GXnHAycXK/ik67NqRbEv37kV77DQyqFvgyA0CEZ5Tb3qJ2N9z2MjbtnGndzZR
	82f7nXWbwR4lEUISvjzUPeTMTsm6Q/6lKDzdwgZfB5sEa1B4M9MUIjERph1VVpVQcyYNmf
	Eu74leLZd3ZF+6+zthz90pNjjBWU2M4=
Date: Sat, 28 Mar 2026 11:47:40 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774669668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zZvGpnGl9Qm/IlUyc9WaFTWtqjjf9i8+RUwv6uPlfyM=;
	b=YJ+i6hrxxPgwFZtF1N8rPjKOMrodTYZ4n5Wye4H+upasIGdThsQdgCCHsHD3OU24eDZLOZ
	PWphnvlDVvdeW3ad/lKvkO3BJB7tuSnw3KPP14G4MyWHtVpVLwmThfP2O6QrNv70Fm0X3L
	qxj/y89ZXhpcQLqJlusF6EVEWClWhaA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: david@kernel.org, osalvador@suse.de, akpm@linux-foundation.org, 
	vbabka@suse.cz, harry.yoo@oracle.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH] mm/memory_hotplug: maintain N_NORMAL_MEMORY during
 hotplug
Message-ID: <ayiordz2mnetih63hjtnbmnx4dllekhpo527wgl7ausk3suwkc@erjqaeuydcny>
References: <20260327124412.469833-1-hao.li@linux.dev>
 <20260327143823.3063541-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327143823.3063541-1-joshua.hahnjy@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 44A57140009
X-Stat-Signature: yrp5b9ima7k8w6euijd3du5ge3tk1tnc
X-Rspamd-Server: rspam06
X-HE-Tag: 1774669671-128778
X-HE-Meta: U2FsdGVkX1/At+kcByZ3bNRaBhB/TJHFQgt5tFJkCC/6ezS+vENZjfxXgSVdkqBUwdwW/8pLjwLxTrS55fG1cP3lKlPkbsRONDwdQo04zscL81HpHeoP0TFie5drE5h+JMx+rOOIXT7Ze18AsYj1cRUFb9m0TD1L3nM9WWBU492h6vxYjY8z/mCgZLZEbwVlex5AqV0thMhhkLJEWdB3/RK5rhsCECIcC672rvGDYrraCvML9kBeoUlwezCUiE+8ylXfnrAkb0iD3J7tq/4jbFMTFeyCyJdyzQ5u0p+AwIvnQ+wV2zF0ZPmyW3i/GH9r92Qup8/Zyigxw4BuKG4hnellHYR/Ko8T9EBLWwaRsfVs6++i90SScz42FdAuoSs3QcSQbwxYmZzqDZIapdELTQJPxxQ3N5aafZ9QLzFNrh6ui7IwQMKC8UCsj9Tc0AHAWBPAT0TOPjdzUoFsjKviOXMCOCLp/eOR/hs1e/VjewI/FCDvlX2wqFPZF7sd7MRuilkeF64YnbwWqsVOECw4o0kqYGDUWQZwR7hE5ifCh9ybS/vWiWtJfFznEa8MNQFAz98GrcFgisNvfs92F1Z6piq9yEo3yaALDvWcgqURzg+46ZAEjAjkduV+nQlLhsPfbpRldnyq5cvgIVCHZhF4juv6PwI2VcRi6rxJzu2lSkUssvkI+E2upBE44lSNHcNHvAYcXxo+pM+NlDTDyOByx/PyID4cRXhWoSX0HcidZUxrib82TVhN3IjNa1HDnIBO+V2iwx+Zq+6dW57j1SSGvSwIOWRUQCv1FguVbSVXskoHSIPl5YqKVZvZTj0FQTn/K8mWJP0E23VA/iI1GGWlmaNB4M+DPdezt/l/tb5g/rV/TkfrnhW579YLh3vTxX/Z3wYI8GiJEZVz3x9QQ6X1Q3DWgY+gkLTk7hzeaTdzQQtdNYlvZOaWWrBLlUS7oEGXFHSNIW+3fI1qiWtYj7s
 d+JG78Dh
 2vGU6G5iG9bHl+3wQNMlP83D9wmX3LTrQLRUA2sdRqp6gmNeVM1iZdG8umAbWHgZ3dqC69UPSfFQ2rMjKt5mlq2DL0WbIZmwD77Ezb3ass1Ur+hDB8vwoyHWCvegtBT940p7CWi3m7vF/cTwnCGfnibpT8km78ignGYYnmJSNnGC+Lz54HwlNfF8dIBEcn7+Y8iyR2Trm52nyvKaJ+BljXkdz/8iLvjadtDtdacTzAjoskHxT15tm0nqYia8CGlKijlHAZ6Cx9B+yYlDPvYlHC0BCovQdPxnQ9bBLgVC6mchQJy3jDAc2eMyxPI3d9qmkYF4+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 07:38:23AM -0700, Joshua Hahn wrote:
> On Fri, 27 Mar 2026 20:42:47 +0800 Hao Li <hao.li@linux.dev> wrote:
> 
> Hello Hao,
> 
> I hope you are doing well, thank you for the patch!

Hi Joshua,

Thanks! Hope you are too.

> 
> > N_NORMAL_MEMORY is initialized from zone population at boot, but memory
> > hotplug currently only updates N_MEMORY. As a result, a node that gains
> > normal memory via hotplug can remain invisible to users iterating over
> > N_NORMAL_MEMORY, while a node that loses its last normal memory can stay
> > incorrectly marked as such.
> 
> The second part feels more important

I'm guessing you mean the first part.

> than the second part, doing a quick
> glance through the code I can see a few N_NORMAL_MEMORY iterators that
> are in some hot paths like shrink_memcg. Iterating over nodes that don't
> contain any NORMAL memory seems like an inefficiency rather than a bug
> though. 

Yes, I agree.

> 
> > Restore N_NORMAL_MEMORY maintenance directly in online_pages() and
> > offline_pages(). Set the bit when a node that currently lacks normal
> > memory onlines pages into a zone <= ZONE_NORMAL, and clear it when
> > offlining removes the last present pages from zones <= ZONE_NORMAL.
> > 
> > This restores the intended semantics without bringing back the old
> > status_change_nid_normal notifier plumbing which was removed in
> > 8d2882a8edb8.
> > 
> > Current users that benefit include list_lru, zswap, nfsd filecache,
> > hugetlb_cgroup, and has_normal_memory sysfs reporting.
> > 
> > Signed-off-by: Hao Li <hao.li@linux.dev>
> > ---
> > 
> > This patch also prepares for a subsequent SLUB change that makes
> > can_free_to_pcs() rely on N_NORMAL_MEMORY to decide whether an object can be
> > freed to the sheaf.
> > 
> > ---
> >  mm/memory_hotplug.c | 22 ++++++++++++++++++++++
> >  1 file changed, 22 insertions(+)
> > 
> > diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> > index bc805029da51..5498744aa1f1 100644
> > --- a/mm/memory_hotplug.c
> > +++ b/mm/memory_hotplug.c
> > @@ -1155,6 +1155,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
> >  	int need_zonelists_rebuild = 0;
> >  	unsigned long flags;
> >  	int ret;
> > +	bool need_set_normal_memory = false;
> >  
> >  	/*
> >  	 * {on,off}lining is constrained to full memory sections (or more
> > @@ -1180,6 +1181,9 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
> >  		if (ret)
> >  			goto failed_addition;
> >  	}
> > +	/* Adding normal memory to the node for the first time */
> > +	if (!node_state(nid, N_NORMAL_MEMORY) && zone_idx(zone) <= ZONE_NORMAL)
> > +		need_set_normal_memory = true;
> >  
> >  	ret = memory_notify(MEM_GOING_ONLINE, &mem_arg);
> >  	ret = notifier_to_errno(ret);
> > @@ -1209,6 +1213,8 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
> >  
> >  	if (node_arg.nid >= 0)
> >  		node_set_state(nid, N_MEMORY);
> > +	if (need_set_normal_memory)
> > +		node_set_state(nid, N_NORMAL_MEMORY);
> >  	if (need_zonelists_rebuild)
> >  		build_all_zonelists(NULL);
> 
> Do we need the flag here? As far as I can tell, we can just skip this and just
> directly check whether this is the first normal memory we are adding to the
> node here and set the bit. Then we can remove the flag and the extraneous
> check. We won't do any notifier work so I think it should be OK.

Exactly, this is a good point!

> 
> > @@ -1908,6 +1914,9 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
> >  	unsigned long flags;
> >  	char *reason;
> >  	int ret;
> > +	bool need_clear_normal_memory = false;
> > +	unsigned long node_normal_pages = 0;
> > +	enum zone_type zt;
> >  
> >  	/*
> >  	 * {on,off}lining is constrained to full memory sections (or more
> > @@ -1977,6 +1986,13 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
> >  			goto failed_removal_isolated;
> >  		}
> >  	}
> > +	/*
> > +	 * Check whether this operation removes the node's last normal memory.
> > +	 */
> > +	for (zt = 0; zt <= ZONE_NORMAL; zt++)
> > +		node_normal_pages += pgdat->node_zones[zt].present_pages;
> > +	if (nr_pages >= node_normal_pages && zone_idx(zone) <= ZONE_NORMAL)
> > +		need_clear_normal_memory = true;
> >  
> >  	ret = memory_notify(MEM_GOING_OFFLINE, &mem_arg);
> >  	ret = notifier_to_errno(ret);
> > @@ -2055,6 +2071,12 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
> >  	/* reinitialise watermarks and update pcp limits */
> >  	init_per_zone_wmark_min();
> 
> Same here, couldn't we just iterate through the paegs here and accumulate
> node_normal_pages and clear the memory here? We can get rid of the bool and
> also keep node_normal_pages defined inside an if (zone_idx(zone) <= ZONE_NORMAL)
> check as well. 

Yes, the same to online_pages(), thanks for this idea.

> 
> > +	/*
> > +	 * Clear N_NORMAL_MEMORY first to avoid the transient state
> > +	 * "!N_MEMORY && N_NORMAL_MEMORY".
> > +	 */
> > +	if (need_clear_normal_memory)
> > +		node_clear_state(node, N_NORMAL_MEMORY);
> >  	/*
> >  	 * Make sure to mark the node as memory-less before rebuilding the zone
> >  	 * list. Otherwise this node would still appear in the fallback lists.
> > -- 
> > 2.50.1
> > 
> > 
> 
> Thank you for the patch. The rest looks good to me! Have a great day : -)
> Joshua

Thanks for the review!

-- 
Thanks,
Hao

