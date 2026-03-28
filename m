Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1380F10F3DCE
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 04:12:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72AAA6B008C; Sat, 28 Mar 2026 00:12:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 701B86B0096; Sat, 28 Mar 2026 00:12:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63E6E6B0098; Sat, 28 Mar 2026 00:12:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 519A96B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:12:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0BFE5C48F6
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 04:12:58 +0000 (UTC)
X-FDA: 84594151236.13.C56BF00
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id 96EEE40006
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 04:12:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q5e5vjdl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774671174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jwH9djlM7EeldEvmT12J+amit/qHM19CLj9Hfcbnv6A=;
	b=B3G1DZV6VYWx9H4IfiwoL2Yh9dWJY4qfP8CRYgLjFahvrxpctyERuTuR/XeG4Sw5rfiEG6
	Bx4ClHWPg9leA3OYF8jaN9ZYWvY21HZWvqq0QhbdA8zhohzM5E/46Dy/0No8JqPsakjLS7
	aUTbXNKfFZHig2BXc1fxiR6Yr0RYdI0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774671174; a=rsa-sha256;
	cv=none;
	b=g6k8dX/iwg4354HjIIMrsqCtwJ1oGpKBGOZTnu5ClNuOHhtf0VF1aX7iF+BPDjWmeeInNL
	Ry+FRrmLXzFTuD41QcRUIuhXi3iCla5VPSZlGTOg8sWZihMtsOY/lY0qkZ00MmZNbLlttg
	Ck5345odX/vfnqKbJQ6HjSLmjz4+dO8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q5e5vjdl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=hao.li@linux.dev
Date: Sat, 28 Mar 2026 12:12:42 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774671173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jwH9djlM7EeldEvmT12J+amit/qHM19CLj9Hfcbnv6A=;
	b=q5e5vjdlc+es4dIZkNqfTSQAgfkrqcruuQ7cX7MIYdTRgEU/AatvbRrFWGM4+yyb8rrFDD
	9cA+t2kcLFKyRQ+fgcLAyDvOf3rhUNtOjUkPl1m5UpfJA/sR9dJJz3Ln70Ey3hlAVSR7LL
	nje6uALOeF3MkyLtDwYv5dDAbUyxm4o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>, osalvador@suse.de, 
	akpm@linux-foundation.org, vbabka@suse.cz, harry.yoo@oracle.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH] mm/memory_hotplug: maintain N_NORMAL_MEMORY during
 hotplug
Message-ID: <2rzg3awmws2odvgysb4ty73nf4nrqfvpzosdlexttn7hsvyfkd@x7lkzb2y3ugs>
References: <20260327143823.3063541-1-joshua.hahnjy@gmail.com>
 <c8d9fba0-a001-42b0-b0e3-323235cb652b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8d9fba0-a001-42b0-b0e3-323235cb652b@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 96EEE40006
X-Stat-Signature: 65rgcao1tc7ozyt3zjx19q1duxjktw6f
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774671174-745741
X-HE-Meta: U2FsdGVkX19aFYj3lBLf1ZHirCJVnA72hvIQxzRd3N9/5Laq/rDJXrGH9piQi1aI1dkxdS8ogXUQi8ULwqsnaJbm/iYFZo0rpuZdGo43N+A0vZ9SR0u+0mEdW08ilqQTplF+kWy0iTRCY2HbMLuwtzDmovtrK+K6XmiSPShJfiQx2H/5ia5BVZ5iNteZkHKZ31Y8eh7kbMQ+lLzn8Y88UZA9SXG88V9pGrLMdodY1qr/ym+EFGczqnwP2MSRLaYNq3Kx5c4b9hOeqY2BvDjGdfcL0HsZ6Jd8NSc9U2f9xwxRHV3cBCXb2LhbkiNIcjIf8UFudx1MRb77G5GS+VRwKICDliOT6r+9lWrOjZqsZKAIMd1GZAHeOY2OqLOC99Ww6UeMcY9MuO50pH35wQVVuSgQCq3xRfjeIQW/ufyfVGLYjdCmtqztAygdbKt3dQhrTwLhs/dZDzhb2WYqkp9XFd6H4NoXm2texvMMsWXTphdKnwwFlISSl2NV38BmaM0mPPGmjtU5VANvyD+PN8Tw+pUASIJltPrNcuxo8yTDBW9JCODcDrq1audLP70mw/l2TvRhfZIpO971Yj52U2l9fjcegKJyhzsCJN/a31aaqMwoyeq/Kz9pFdIABzjUkcdu7SWfGetH7+F4aBsdB/SGgoLrqP5JaJHf0vzw4qYLcBvkmQhYJpNazs1+tPB5Cx46OgqEfvIm1Ohg3sLZp/+4rwPa+XUkIvdOzMhHJOFEfN1wq+tGE29wRX4vXTe39BOh0ZctfLj2g1a02ghro8qavmTSjrChSLlbhCCZMKQkAULXaW+Exns+wsFTLae2HbA2E69r4y+FbMUlvMmb/Phv7e0jexDsj9ETd09aA50P5ediAFrerfKChtnNu1QS92oUBQVYZigLleiqYUoPY/h2rgTnVlBFJAew8U+o+GEJKF/JXA66icdn78XWCBm9nzPEKn5i62X+Uu9c9OQTcJ8
 o+mg3evE
 cCYFKcp5xrUD5r9ZADAZpVEExYfSiuKjopalPGAMIbJX1RM5mN1KUii62zpWnUiM/xk+ooUDeivLpD7/xOMtblx1Da6egYChG0HSGUVy266DwR+zYAU/h1TmgpcFgbLVDWe3IJFwYWePu/jRKD4ruOPumDdaAmjql+5YnJu7+AKyuEXNBkPhka21B2VCPLvCu8M5TxLXugFeiZJZdofYruECZjlzS1UX+riMzzDVYf1lDKECfZms+i2oZdYAfLEIfJ2oxnKj/07ULzj8sAcE9Bhe8FuxHcD93ptoz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 04:28:53PM +0100, David Hildenbrand (Arm) wrote:
> On 3/27/26 15:38, Joshua Hahn wrote:
> > On Fri, 27 Mar 2026 20:42:47 +0800 Hao Li <hao.li@linux.dev> wrote:
> > 
> > Hello Hao,
> > 
> > I hope you are doing well, thank you for the patch!
> > 
> >> N_NORMAL_MEMORY is initialized from zone population at boot, but memory
> >> hotplug currently only updates N_MEMORY. As a result, a node that gains
> >> normal memory via hotplug can remain invisible to users iterating over
> >> N_NORMAL_MEMORY, while a node that loses its last normal memory can stay
> >> incorrectly marked as such.
> > 
> > The second part feels more important than the second part, doing a quick
> > glance through the code I can see a few N_NORMAL_MEMORY iterators that
> > are in some hot paths like shrink_memcg. Iterating over nodes that don't
> > contain any NORMAL memory seems like an inefficiency rather than a bug
> > though. 
> > 
> >> Restore N_NORMAL_MEMORY maintenance directly in online_pages() and
> >> offline_pages(). Set the bit when a node that currently lacks normal
> >> memory onlines pages into a zone <= ZONE_NORMAL, and clear it when
> >> offlining removes the last present pages from zones <= ZONE_NORMAL.
> >>
> >> This restores the intended semantics without bringing back the old
> >> status_change_nid_normal notifier plumbing which was removed in
> >> 8d2882a8edb8.
> >>
> >> Current users that benefit include list_lru, zswap, nfsd filecache,
> >> hugetlb_cgroup, and has_normal_memory sysfs reporting.
> >>
> >> Signed-off-by: Hao Li <hao.li@linux.dev>
> >> ---
> >>
> >> This patch also prepares for a subsequent SLUB change that makes
> >> can_free_to_pcs() rely on N_NORMAL_MEMORY to decide whether an object can be
> >> freed to the sheaf.
> >>
> >> ---
> >>  mm/memory_hotplug.c | 22 ++++++++++++++++++++++
> >>  1 file changed, 22 insertions(+)
> >>
> >> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> >> index bc805029da51..5498744aa1f1 100644
> >> --- a/mm/memory_hotplug.c
> >> +++ b/mm/memory_hotplug.c
> >> @@ -1155,6 +1155,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
> >>  	int need_zonelists_rebuild = 0;
> >>  	unsigned long flags;
> >>  	int ret;
> >> +	bool need_set_normal_memory = false;
> >>  
> >>  	/*
> >>  	 * {on,off}lining is constrained to full memory sections (or more
> >> @@ -1180,6 +1181,9 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
> >>  		if (ret)
> >>  			goto failed_addition;
> >>  	}
> >> +	/* Adding normal memory to the node for the first time */
> >> +	if (!node_state(nid, N_NORMAL_MEMORY) && zone_idx(zone) <= ZONE_NORMAL)
> >> +		need_set_normal_memory = true;
> >>  
> >>  	ret = memory_notify(MEM_GOING_ONLINE, &mem_arg);
> >>  	ret = notifier_to_errno(ret);
> >> @@ -1209,6 +1213,8 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
> >>  
> >>  	if (node_arg.nid >= 0)
> >>  		node_set_state(nid, N_MEMORY);
> >> +	if (need_set_normal_memory)
> >> +		node_set_state(nid, N_NORMAL_MEMORY);
> >>  	if (need_zonelists_rebuild)
> >>  		build_all_zonelists(NULL);
> > 
> > Do we need the flag here? As far as I can tell, we can just skip this and just
> > directly check whether this is the first normal memory we are adding to the
> > node here and set the bit. Then we can remove the flag and the extraneous
> > check. We won't do any notifier work so I think it should be OK.
> 
> I assume you simply mean:
> 
> 
> if (zone_idx(zone) <= ZONE_NORMAL && !node_state(nid, N_NORMAL_MEMORY))
> 	node_set_state(nid, N_NORMAL_MEMORY);
> 
> That looks m uch better!

Yes, this approach is elegant! Thanks.

> 
> > 
> >> @@ -1908,6 +1914,9 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
> >>  	unsigned long flags;
> >>  	char *reason;
> >>  	int ret;
> >> +	bool need_clear_normal_memory = false;
> >> +	unsigned long node_normal_pages = 0;
> >> +	enum zone_type zt;
> >>  
> >>  	/*
> >>  	 * {on,off}lining is constrained to full memory sections (or more
> >> @@ -1977,6 +1986,13 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
> >>  			goto failed_removal_isolated;
> >>  		}
> >>  	}
> >> +	/*
> >> +	 * Check whether this operation removes the node's last normal memory.
> >> +	 */
> >> +	for (zt = 0; zt <= ZONE_NORMAL; zt++)
> >> +		node_normal_pages += pgdat->node_zones[zt].present_pages;
> >> +	if (nr_pages >= node_normal_pages && zone_idx(zone) <= ZONE_NORMAL)
> >> +		need_clear_normal_memory = true;
> >>  
> >>  	ret = memory_notify(MEM_GOING_OFFLINE, &mem_arg);
> >>  	ret = notifier_to_errno(ret);
> >> @@ -2055,6 +2071,12 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
> >>  	/* reinitialise watermarks and update pcp limits */
> >>  	init_per_zone_wmark_min();
> > 
> > Same here, couldn't we just iterate through the paegs here and accumulate
> > node_normal_pages and clear the memory here? We can get rid of the bool and
> > also keep node_normal_pages defined inside an if (zone_idx(zone) <= ZONE_NORMAL)
> > check as well.
> 
> Right, all we have to do is check for remaining present_pages in one of
> the nodes IIUC.

Yes, we can simply sum up the remaining present_pages and check whether it
comes out to 0. That feels more straightforward and direct.

-- 
Thanks,
Hao

