Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60124606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 19:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CFLB/cPC
Received: by kanga.kvack.org (Postfix)
	id 7FBAB6B05B0; Wed, 11 Nov 2026 14:49:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D2A56B05BB; Wed, 11 Nov 2026 14:49:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E8806B05BC; Wed, 11 Nov 2026 14:49:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A4C26B05B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:49:39 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC4FC1603BE
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:49:38 +0000 (UTC)
X-FDA: 85423878036.04.82DAB65
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D760DC0005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:49:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CFLB/cPC";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794426577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gVc6YM8M5IAHsgG4XamDTanrt4p9Rvguj7WxgEd5KeQ=;
	b=6RPtquW8cvPLB1nKbCCA3KIoxn6pJOI0FpNgrMCPjYRCLa8taUp/Ry6gDFus4JR9gFcAcv
	s1NTssJJGiMsohi+py7htwgYM+TKKeRh9TJDRjgsfYKK8klxfm7LaIXHnEqe/xTdUflcf2
	qc5ELnCwKTfDH/Dx3ouDm/HvsoMiW/A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794426577;
	b=d73CEA8nM2GNV0bEo0sG6E9W/n1IqezHDLh6YQmflY99G777XjPiMu6p12+LvFm7pU1V3v
	OfaImDRg4bcENTwb3NVHXoEr5OVSeqqoCJ+TbIbhlfoGo5DMUxp8UbGzwmn6x3ULvaXB1J
	B3mW1c7ZOevSXduFyE41RglkKCS8U78=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CFLB/cPC";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 030C745D4C;
	Wed, 11 Nov 2026 19:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65EE31F00A07;
	Wed, 11 Nov 2026 19:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794426575;
	bh=gVc6YM8M5IAHsgG4XamDTanrt4p9Rvguj7WxgEd5KeQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CFLB/cPChRYUDHwlEFHTvMKQ/okKxzi0IRhO0GRhxiBRDDZnNScQyxbPO45ZWQ6zT
	 PXncE585W0d7wWT2u3P+rDmhOotopn2mdO1EJF1peW1OhvmrVkH06SDOfnSFJiU5nM
	 ZugV5YoAyQ0b5sUvEBEZiAlzOYNlhCSoZdQTe/tkZVsHjyxo0BiYZNVQGVFuOCHmhh
	 O7ysLZ/d2PlmU+pIf/tHolLnKbhMJygw2KSRqpB7g3XzgV1FkZNIjbzIRYVKFFnRrT
	 IoCOjjd+19UnCUQkHoH9rHLVjRiK+b44FcXcFmbBtnWHyxBTn4vcZ6rh/zQVNE2m2H
	 yAJ/Io8JzD+tA==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id D8164198003A;
	Wed, 11 Nov 2026 14:49:27 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 11 Nov 2026 14:49:31 -0500
X-ME-Sender: <xms:x8b0asLLHLpPYXr9uSwDpgfI2VhUaWLEDu2DPUd2kMwCXhNHDfK98w>
    <xme:x8b0aqkenIL07D2mznlyle-qTJlZYLapb1udmcB3z__LHytYYEDy1n-84bR3FZVtV
    P-bBuR4-SpShMd3aIFwr6Z0As9QlBzII7o8f-acSYJX9pu0OyKB88ms>
X-ME-Received: <xmr:x8b0aj1rPbFagLhK8QpcWu9e1gegKpofGHhSUV9WHylbRqmqwwoykWXNQQg>
X-ME-Proxy-Cause: dmFkZTEdupPFVg3GK2wZR+bhvzM7lmON/H/kDh6eMRSZDwCb3j3MA/z6XpUq9kN9AFvMyS
    zgxK6eXvhIO/RlMkjFBwb6NDEhcxkQGM+ACP2GZ/sgZgNDe6+uGo6DY8cKIOoSXxTC7CzQ
    STnAxo1I132FTLSmWThy9YNRnudLY9EDMrsciu+IGf2CIyse2jIL7gv5MVc80vDitFJ4U+
    mJa+1MgYj2BRB9R4oUsbobDR/aJklmz1wsXV6ESw+/XNvzptwzM9MY/mDWBfhH3chRy0QJ
    y5U0sNSuNj1EezXb2QP44Q5Lkgpa6wR3t6023acNG9sJppH9oxwxd9eR591GcP2ppb1lH2
    9S2G4kR3wtXvNPsWspIA/0Gd/QUWrd1DVm0HKb0D5bu2hcxrOSzvi3/rTYfdsZTfkRpmmQ
    ezRHgRTtaXq25k0YNRxgHo7tv+NcwNnTKQJl/eLtG3FTo9aDwj95rA6naYiyotToUXuIRO
    gaW5SPyZ3wu1koL57+YZGq3K6TVfBhDja32VftjmcnB5Hk9UaDGAuM1c/Y11dPYh5Ax/CQ
    ofQjaluRH5K84DYLxfT6/EyFe0PJ3Tr8rtDbFnUcKraJd/EXdwJRER1axDZmeVoE08ZeWf
    1EYf5iUDuodS6fzd0eEafO7mRGK62lmyyrmRDkWafHh/YcasbXTWAC55psmw
X-ME-Proxy: <xmx:x8b0as8r9hmV9-rllvO-t9W7mqDVo1hVlvPS2-iC6U70Gss9wTIiGQ>
    <xmx:x8b0amy95D9K4WfMPUW_Mst5o41jiuy7O38IVKV0QfTgG97LvQiXTA>
    <xmx:x8b0aihkxcjWPXzq7khm-8R0inbu85QvxS_DuG6pVnBo_x-2nwjR_w>
    <xmx:x8b0ahNIFlM4LySNmQR9QDrxQC_zmPDZWsDxcapk7bSeaLMiaHy1ZA>
    <xmx:x8b0aganL4N1jqjRssI3B8_DwA4_oj-AQV7nrMh0J_eWvqwD2X9ht8Vs>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Nov 2026 14:49:26 -0500 (EST)
Date: Wed, 11 Nov 2026 19:49:25 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 1/3] mm: page_alloc: add a watermark check that knows
 the migratetype
Message-ID: <avTEezDIsJBhsPmi@thinkstation>
References: <20261102093939.3340540-1-kas@kernel.org>
 <20261102093939.3340540-2-kas@kernel.org>
 <auynaZkzdzL6Aeyo@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auynaZkzdzL6Aeyo@thinkstation>
X-Stat-Signature: m5smigb94yopm3imkuzbdnwiqogyxxwq
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D760DC0005
X-HE-Tag: 1794426576-801083
X-HE-Meta: U2FsdGVkX1/qT7SP2NC3gk4OTy7t4s5nv7KXDhDDK6wnrwldNd2XsV8hXcsk9b0gBvgAaOE/EgDLUwEUKkLNsKwMA5nY//AC4ybgFGbXuuJ6ljCSyvjbO1S7QYwATR3X8WnIwAFDnsQmOt/rWnI5HeRYxem3GJxLmWbDukFOrZ6A+UlA/VSisj4IyUpZje7qvfnQV6tOrKGtNG6ODyxfJ5wI/IYOrIO2UgCGQDDArNarubLvQSU+5394y1UFuYj+GV1z7HL3c6YUsa8ReQ/nhoZA9lFIHl+YQmBLzOYUej1rxy+kjPi1yNkkh07bd22LycrWEMjmbN2CFpRiAQffTELoHmMDVfxN3dq7vdnh2Aw7UG5oIcCr4WhQk+rjZ94RcQ/bsVpg/PSn5g6fQuDMC0Z2kGKl93BzmaGmuOJsC6IF7JGoXGkj4mV2MOPNJB0GVicSExjhKqrI5CErOc+JXODJtv5vorNPUrlBH6BHusQZC3WbL4gOIwl8agb54bqdSZIVWTXhJ90wIL4/J4Zv0I+awKjUv1Qa0MJOaouU2DgdFoa0V2V4fzdReoZFYyabwRdyqbS8kanNnB+NNKTkSSF44BU+cICxU1tOXIo+k8q07aM8joD3SpojnwJm4m/Dwvc0Z5ehGcYpgIqJItsNhXi5Xn3XrudnTaMFNTyJNnilE2CCqScruhJYxxJkVIMg51WPVfwd5fom0I5uRwnb9c/0O82VaWp30QloBCxR6Db9pdXZ86dVElo9bqRCS4xucVX8K3KXKzKGw+MuBzm5m0pllRLxH7O620W/zWZpfcHq38VtUO6zBFEaVKUETpjiQxvxfO3AQXMTca7svkMN6znL2g9uMISUl1dD2t7KNGrYz8XevDEJOthumYsxQRYQrq5KT95jfg4DL+kDgaKgMZuH2O7AtnQB4TXuonC6u9xIuNFT7z40F2oYz+o90B9iQjzSADQikay/nWIxUQH
 kG6C+juN
 233KkyZf0nWul488Jdq80At+AAFZUqEFpwaImdERtuTEeRiL2IflLxxZtTHJBrb+L+dw2FsPZNS88fZOKj1ub5R82QntbGvI6DzozCnJQra1sRFqNzY984jec1SmyoJGxTZIVp21dCYuu3o9zkj8nUzPe7g5SDJT7eylOUwseajlHAlOOOPP/jhaTUMtf4qL/hTEsX0PvXHpETyQxkJoEjYEuyhPDfO18O9dYqSAu9NN7AFAifYSPVUGoG+NRu2P92/xOdIAgfJZHQZCJ48Cn+q8/jXU9ZF8/hhps+tkW5bK70380B+sGHW7Y+oJbCvoEZalpi4wRTfTScHw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 05:06:39PM +0000, Harry Yoo wrote:
> On Mon, Nov 02, 2026 at 09:39:34AM +0000, Kiryl Shutsemau (Meta) wrote:
> > The high-order check in __zone_watermark_ok() accepts a free page of any
> > migratetype.  Under ALLOC_NOFRAGMENT, a request below pageblock_order can
> > only take a page of its own migratetype or claim a whole free block, so
> > the check can pass when the allocation cannot succeed.
> > 
> > Telling those apart needs the request's migratetype, but not every check
> > wants them told apart.  A check whether an allocation can be served now
> > has to count only the pages it can take.
> >
> > A check whether there is enough free memory counts every migratetype:
> > kswapd and kcompactd balancing a zone, order-0 thresholds, the
> > slowpath's forecast whether reclaim and compaction can still make
> > progress.  Reclaim and compaction work across migratetypes to free whole
> > pageblocks.
> 
> nit: perhaps we could make the changelog above bit more concise.
> 
> I think the necessary bit here is "With defrag_mode, allocations cannot
> steal a page from pageblocks of other migrate type, thus
> __zone_watermark_ok() needs to take that into account."


It is ALLOC_NOFRAGMENT, not defrag_mode: Normal zone allocations get it
on the first attempt when DMA32 is populated, with defrag_mode off. And
such an allocation can still claim a whole free pageblock of another
migratetype.

But fair, it can be shorter. A tighter version is below; it also says
why kcompactd passes MIGRATE_MOVABLE.

> nit: maybe let's set cc.migratetype and pass it?

The value is not read there: __zone_watermark_ok_mt() uses the
migratetype only under ALLOC_NOFRAGMENT, and kcompactd never passes it.
kcompactd_node_suitable() makes the same call and has no compact_control
to take it from.

Thanks for the review.

The new changelog:

	The high-order check in __zone_watermark_ok() accepts a free page of any
	migratetype.  Under ALLOC_NOFRAGMENT, a request below pageblock_order can
	only take a page of its own migratetype or claim a whole free block, so
	the check can pass when the allocation cannot succeed.

	Only a check whether one allocation can be served now should count just
	the pages it can take.  A check whether a zone has enough free memory
	serves no single allocation and counts every migratetype: reclaim and
	compaction free whole pageblocks across migratetypes.

	Add __zone_watermark_ok_mt(), which takes the migratetype, for the first
	kind:

	  - the allocator fast path, zone_watermark_fast();
	  - its recheck after node reclaim in get_page_from_freelist();
	  - compaction's up-front check, compaction_suit_allocation_order().

	__zone_watermark_ok() wraps it for the second kind.  kcompactd shares
	compaction_suit_allocation_order() with direct compaction and passes
	MIGRATE_MOVABLE, which is not read without ALLOC_NOFRAGMENT.

	Declare both in mm/internal.h: nothing outside mm uses them.

	Nothing reads the migratetype yet: no functional change.  Preparation for
	making the high-order check honour ALLOC_NOFRAGMENT.

Looks good?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

