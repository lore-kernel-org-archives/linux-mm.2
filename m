Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12D30C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 18:58:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C116E6B0088; Tue, 15 Sep 2026 14:58:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC3C36B008C; Tue, 15 Sep 2026 14:58:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADDA86B0092; Tue, 15 Sep 2026 14:58:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88AA66B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:58:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 63C1940503
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 18:58:17 +0000 (UTC)
X-FDA: 85216907034.22.7171ED4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id C9B5014000A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 18:58:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ornEdJdU;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789498695;
	b=3A/41E8/Wq/A+j6gFrCZoYjhdumRmEsCzpfQHUDcTiQSuHLYTsHDdm6KnAJCkX9/R0bsi/
	5rUrPv3Ust1IiV04Onc4zUD0CNfCsT1/ftKue45poAF8J7614httYX+LDiz0yKDg+P3Sgm
	TYR85H2VyxGFCVxAytSy1z3cJ8kYh3Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ornEdJdU;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789498695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Adg+vPcTbfUMZ5IHqpKKaV5rPbxcS72fk9/u/WIjV+M=;
	b=1yDDjfRSgyVfMwZ3/oRi96jd4eb+F0CQpm9gYNW2TdpKy6WdNjoZNo4VCP66F93l1xnqVg
	lAOF5jFtCBrTyTPZRGoNvDvLcCJ3FNfi217447AJy9Pm4UA1h15g2mo7mIDuA4I6h5/jRq
	TDSQJYF1wjxkxwltzQQR45HS6lY8Mjc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 48926602BE;
	Tue, 15 Sep 2026 18:58:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234D91F00893;
	Tue, 15 Sep 2026 18:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789498695;
	bh=Adg+vPcTbfUMZ5IHqpKKaV5rPbxcS72fk9/u/WIjV+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ornEdJdU8li9pKZm5oIcW34Sa3zgmaht11Pxh4V83dj4oKcMfWo2Lql5P+A2DWj8e
	 qOYi8Dtg0RegxaXf46okYjSogAmttCzdkLZGpfiye2rJjA5o6QwY4G2Ul+EBAerLLE
	 AEu29/8P8nYXyn0vqC3FYMXnmPz1OfFBZQHB/HvOJONuZ5fcNq+Y1UTygQoZqvS2E1
	 DmaLXpZ/FjsI2I9dtGyFBWVD4fICo7rV1wHN5VfMgU7zDfBBDN26t2G05H7CjfYwcC
	 lXhoenDemhuneOwVhqhWq173RLTPCii/r1i8Zf86PjVb5m50R/paf+vey5FYgFWW8O
	 bbiDbDkkACiRQ==
Date: Tue, 15 Sep 2026 21:58:09 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yuan Liu <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Nanhai Zou <nanhai.zou@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	Jason Zeng <jason.zeng@intel.com>, Chen Yu <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 2/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Message-ID: <aqmVQeETYhbsl79A@kernel.org>
References: <20260914072929.1883794-1-yuan1.liu@intel.com>
 <20260914072929.1883794-3-yuan1.liu@intel.com>
 <aqjfyGeQaL4g2EcA@kernel.org>
 <209de483-a9a5-4d98-bda4-7998e8fdc7da@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <209de483-a9a5-4d98-bda4-7998e8fdc7da@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C9B5014000A
X-Rspam-User: 
X-Stat-Signature: 73j43bkq94wn8nezhqxj77b3kof7qi5c
X-HE-Tag: 1789498695-808814
X-HE-Meta: U2FsdGVkX19Er7pF9L+AU3/9IGlgiCSonuI4y/PrZIPwgj1iirUG5N/q1yWRbx717fPpj4StFgjYOj9/nPOwCkTIFty+cOt4HgdQ5s1cQHHYVq9XGGJ9sZvD+ZK4XN7pKCfYXpbDlMTW/k8rYMUPHxhagdVllROEM7fzD+7ZYZJUHEfEz3oB8aMkNuSvcIOUC+ZudyvIWo3XRwlYRXGO6mLTQ7pr4J5mLgT4FbEdyOu1yFL9/3LQcERGO1s5Rxy4skjCPlrN3EpaHRp9WkFDNnWeppP5SbrjDzo2bVzknqdBhkbIyVaX2NnR4XZ6yQuUYPn1LVIytEFxVJ1J0QO3CH72QjuyuaJ++seY6n7HMr4BF2ewQpH24V61agt/KxK0KatcnTTIDlm4X4Sq85k+4nd7ecQvcdIVmd8d0aqNGCDmO/KB8V9v/cLHy6ZbCEPNZJpWQIZtDMvXn8tHPPar5SGCrpp9RsJ/f2zBAB8VlCXLXhTTLpgiz22s+mcCwHfWSaTHFP0x1WgX5djPuQk8KQV95KEgDsd+lKznimaf8h/W4QvGprL6Vc7wr0blJLXlhKeQv4QLDQ1LNMD2qAF7WZkkguO5XSUjlLxHQnseYaMatuQGImSXGvJMNWzht0s1eUXPUd81m7vXrKFlr3vS1DilHqnu6QCg74WW0VdzCfdPi2oFmCKZuj+q1Iz65dsf/Z7E0A/8/M5FUGUWf6NoBZxJNwInelm2Yw35oON2Wi3ibsHqkHHouD0RFCu5SjTR5KrqVV/eOp3LzNI2Y7ArSrOaskUb1Bl3Xkq7WbIR2Qf6lGar0ezHN/3rm1JLCDO67z8qeAlKixUujTqA3GAoADOsk0pi9j4z833qd0CdJAHCo3ieO8Zll5XsLgxkqtzdrd02QdfY9nntA2kOs60oS/Y02WsQz468NoRCoGjgI7pIcE9XOf+5Rd4Err4wXabvw4Udm7kTIp04Jmjj5vI
 aaqXW68g
 1UqTCiORPGIIbA6iTBu7CB8C0O6vpZXb/qMb2vK94S3GWfFfQkhnE2rif9ZERGvS/U/ADNREgf6xUN1JmmSOAsKHBArO07tvjK2dkQN/0wKjVH5xxe83/3uIocSInOIwOv0bsT6UjplmCsV2U8V26gkpob8CRGq6fKFVOFApbDgunCPs42WVk01MJrGKlYP4V9Qt8jHtcaM69z2tMiroQPuydNxaZijbqF1VNrwcg9azvpT+LqFDzBYxz5ZZj29KF5Kum0h9HXYST8whvMQlE+DaAes4h7GAELH+Tte8mg8Cuwm1ilRO+s2cloFMBFHz+agB0gANgxc+O5hhR5TkveiZSyrywGZt4fxslvvrUmWf6EjDZJZm9gdKAoMS68Iu/34Z7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 05:20:07PM +0200, David Hildenbrand (Arm) wrote:
> On 9/15/26 08:03, Mike Rapoport wrote:
> > Hi,
> > 
> > On Mon, Sep 14, 2026 at 03:29:29AM -0400, Yuan Liu wrote:
> >> When move_pfn_range_to_zone() or remove_pfn_range_from_zone() updates a
> >> zone, set_zone_contiguous() rescans the entire zone pageblock-by-pageblock
> >> to rebuild zone->contiguous. For large zones this is a significant cost
> >> during memory hotplug and hot-unplug.
> >>
> >> diff --git a/mm/mm_init.c b/mm/mm_init.c
> >> index 1533aebafb68..d40a8ff23370 100644
> >> --- a/mm/mm_init.c
> >> +++ b/mm/mm_init.c
> >> @@ -817,22 +817,39 @@ void __meminit init_deferred_page(unsigned long pfn, int nid)
> >>   *   zone/node above the hole except for the trailing pages in the last
> >>   *   section that will be appended to the zone/node below.
> >>   */
> >> -static void __init init_unavailable_range(unsigned long spfn,
> >> -					  unsigned long epfn,
> >> -					  int zone, int node)
> >> +static unsigned long __init init_unavailable_range(unsigned long spfn,
> >> +						   unsigned long epfn,
> >> +						   int zone, int node)
> >>  {
> >> +	unsigned long next_chunk_pfn __maybe_unused = spfn;
> >>  	unsigned long pfn;
> >> -	u64 pgcnt = 0;
> >> +	u64 online_pgcnt = 0, pgcnt = 0;
> >> +	bool is_online = true;
> >>  
> >>  	for_each_valid_pfn(pfn, spfn, epfn) {
> >>  		__init_single_page(pfn_to_page(pfn), pfn, zone, node);
> >>  		__SetPageReserved(pfn_to_page(pfn));
> >>  		pgcnt++;
> >> +
> >> +		/*
> >> +		 * With vmemmap, at this stage all pages in an early section
> >> +		 * have a valid memmap and are marked as online. However, only
> >> +		 * subsections in the subsection map are actually online.
> >> +		 */
> > 
> > I'm having trouble parsing this comment. Shouldn't is say that some
> > subsections in a section can be offline because of holes?
> 
> 
> Maybe extending that a bit we could do
> 
> "With CONFIG_SPARSEMEM_VMEMMAP, early sections have a valid memmap for all PFNs
> and the sections are marked online. However, we might have offline subsections
> in such early sections, indicated by the subsection map. While we must
> initialize the entire valid memmap, account only the online pages according to
> the subsection map as online (see pfn_to_online_page())."
 
init_unavailable_range() already has large comment on top, adding something
like that there makes perfect sense to me :) 

How about a bit different version:

 * The function counts pages that should be added to
 * zone->pages_with_online_memmap.
 * With CONFIG_SPARSEMEM_VMEMMAP there could be offline subsections even though
 * the entire memory map is valid and all the early sections are online.
 * Count only pages in online subsections (see pfn_to_online_page()).
 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

