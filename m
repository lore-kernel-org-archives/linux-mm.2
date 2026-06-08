Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EA1FCD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 18:40:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCE216B0005; Mon,  8 Jun 2026 14:40:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA5FF6B0088; Mon,  8 Jun 2026 14:40:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBBE16B008A; Mon,  8 Jun 2026 14:40:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDCF76B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:40:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3ED18140252
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:40:57 +0000 (UTC)
X-FDA: 84857612154.10.C65647C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id C2A3F40010
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:40:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=rWW0Da2A;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780944054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rODWarQ33toh6GcLQ0egZ0dIkhPTmQcNE0V/AVwOXkk=;
	b=TKmXbXtxISGkPnBlAKI8MpWzsZKr+dQv6xX2AP4gFc/FFh+xBi/55HkxSp4WuDCTBibq81
	ajoadfOHB0nlNZdn4x/5l4OgYhFjw4aS6nEjibcx6RcDGbcAdrUzMHGZVWUvQMn0XPBcSX
	+ApNHfr6GNrIOhKTNcPESu2SWZbkp10=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=rWW0Da2A;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780944054;
	b=4GJux01yrc63IztPryv9DumCmJkT5vY1H85nwQPM5IH3ykdMc76EI4nPz0IXLXwxcT3FNc
	mhAflQ6mnZjILXbNbmY1Qy3GrVI9yMB4WNETTlkKNjcDZLahF1t9GwwjYETlUi9g5a38Wc
	F2Ag6BewzeNI1CxtENe5ctjVz90Ytw0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rODWarQ33toh6GcLQ0egZ0dIkhPTmQcNE0V/AVwOXkk=; b=rWW0Da2AKVtPEHGBOef5L01skU
	N3t2UUEzlb7SayICRkQkZtyv0Eox7bGJhzCajVs5gnSV27boOClCc61KmNpFZRBACCFxkEFvmGkrv
	/zQTGIsktWdqxilC3t+6sFapdX3dJNBzIL1u0Uzmsm3x+AGd0NEPBJxsD2oyeb3ClNZj0qvAS640T
	w1zpRyyRV4yxNQvF5wi0wmhqHNnP5XDfQDOfmAdyxrneYMsKz4TtUX2VQDpjR3qD+2dVmHoUjwTap
	ixTgydaKkY5IrrN/U+mBDg4hNAJ8b/vIvQwr5GmlOQF9MB4UnN1j88fMYdsZq53WSyzUJkdhNjloI
	9tB51GZA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWetb-0000000EEOU-3b9P;
	Mon, 08 Jun 2026 18:40:23 +0000
Date: Mon, 8 Jun 2026 19:40:23 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Gregory Price <gourry@gourry.net>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
	linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 17/37] mm: page_reporting: skip redundant zeroing of
 host-zeroed reported pages
Message-ID: <aicMl3hPJMgOkfSv@casper.infradead.org>
References: <cover.1780906288.git.mst@redhat.com>
 <6a2f93e4447e55ada6ccf0f4d5c64e8d41a848d4.1780906288.git.mst@redhat.com>
 <aias_qh3wR-Xkf6T@lucifer>
 <aibpL3REDdQ8Vhys@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aibpL3REDdQ8Vhys@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C2A3F40010
X-Stat-Signature: eg4ehuoifapoips73huizb6pu7j4wgzm
X-HE-Tag: 1780944053-357847
X-HE-Meta: U2FsdGVkX19FmjhewbSrsdZEpjlQKWgoWjLLlJHR7nNUoCxQrrloEMjDe0zXwPbwINaMwTRaiUXKevIxq3fgmyHEE3XEXnx4bmhs+Ggt/aIZmrcFzsCEH0nNvq5tLZHAHEcO8urNoaBl05UtRqOD6PQTJ34+1ARb9yXBWpPgnOnR/rk9jwpCHa6OBKslimtyjX9Jtl6WOivMOLY6NyhcQ+N9TOF2RcvJNNXn4ZQsimOQXHmFpNFo17BujcOWaHqRZLDCSPPDbZGFUzR6RveuKhTngCKwqNqApUEN3OeA6MxTTwwvNubW3JPDRfBFV+I52AOux8SfGhpf/G9wCA34/kqKf1Qjsta6xXh/MlhtMXyhxprCn8+TyTqyVIKDKoKqtJ6cfFimOm/xjAlhE3vvQ3il41xaCzFadifohtRYGuIu8qrA9GOZguIWYrNNTBJAbGa4ULssbS4QzYtYyX3bKftfEVL9opXZbo1TLDXcKkSmRp0unf+SclCsfyVQ59heg/MNhvXvqhSJkoO5XyY8sEIW7J/nsM7aSEuZsqg0MjKmwXbkdNqbh62pXM+As9VFL66WJ6qay9/uUQD6RqhSvuzf9X2767CUJFB5Ms6DTVoUlMdyZ+9eG6e8a2zp7Mw6MakzrpqTj71nPItnK2yytlxU5+M01QY+nPP0EC4Rmp9Dh+urjQt+SsHuVq/aWpCptrXriuqOI/+rgq3fLtvNjwm0ZupDEVgONjYFvLkFEeoL2QdfFTL2cvGpTMGk61qn43Hlpq9SRS5omcnhno77dy5UBBwulh8Sptd4WC1EHzbwl7xQi8azuLuh64KT2m7BPeDTqY4TMDdL51Hb1G0POtYzLQIXkPjO9+pbTRVcPI+tx1Zn57BUX5mDAa6Nv4/mm3rroEAR+7EX9UCiq4PDyIu76pLJIQoJTjQZIVxzKbHQvntvGy2Z06UvOmtiP4a1RRYco6biX68/J0fdBL1
 zaQGi4fl
 N5/xoP4f/Iq0sdMOTF0JT6QPXB/4iGxb2AAzwLKK+si1Oh1B15kgB25Pu7G8XwhgN+qfd1QQAOw+OSO6mF8J7Sv5A6J6kpygeRUxWTCOatKq5Am0+h4n3uL6oJ6V2Q+lMvaFpnxJ3M/3HbyHTImK4JuRkBa4Qnu7DOT6IuOH8X2B8y7coryU9ZJeJQQ6L062DZfDgUDwBn0Mhcva6ZuMR7b7GSptX0zdjGetAEaiy6fHcNRUPDb6PDKtKQoAVm5QuBQwm+VP8L/mADE491/Fwp15pzNyachbY/7hqU+TkuWf+SMDQ7I8pmHKW3BgRMz4ns3+rTySAPPyuAiZYlzZbaaez8muwozA2mo+oyoTom7okNdryesarzzNW/QibJlyi670Ja9/kwf2Kaz7eh2d38+xAHXyMg/ZPFNTn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 12:09:19PM -0400, Gregory Price wrote:
> On Mon, Jun 08, 2026 at 01:00:17PM +0100, Lorenzo Stoakes wrote:
> > On Mon, Jun 08, 2026 at 04:37:48AM -0400, Michael S. Tsirkin wrote:
> > >
> > >  void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags,
> > > -		     unsigned long user_addr);
> > > +		     bool zeroed, unsigned long user_addr);
> > 
> > host_zeroed or something would be more appropriate no?
> > 
> > But in general do we need to propagate this around, can't we derive it from
> > the page zeroed flag?
> > 
> > It's really confusing as to _which_ zeroing this refers to, it seems the
> > only one relevant here is the VM host zeroing but that's completely
> > non-obvious and now everybody using these functions with the extra param
> > will simply have to happen to know this.
> > 
> > If we could find a way to avoid this propagation that'd be ideal.
> > 
> > Failing that, making it clear this is _only_ for vm host zeroing would be
> > better, but then maybe we need to think about how we could encode this in
> > some other way, e.g. passing alloc_context perhaps?
> > 
> 
> This is unaddressed feedback from 3 version ago:
> 
> https://lore.kernel.org/linux-mm/agXYbcuQYooG74pb@gourry-fedora-PF4VCD3F/
> 
> We can infer all of this from snapshotted page flags and propogate those
> around.  This is infinitely more useful than just a single flag being
> pulled out into a boolean, and more extensible.
> 
> void
> post_alloc_hook(struct page *page, usigned int order, gfp_t gfp_flags,
>                 uint64_t pg_alloc_flags, unsigned long user_addr);
> 
> 		^^^ page_alloc.c internal falgs only
> 
> Once the allocator gets a page it wants to return, it can take a snapshot
> of the flags at that point, and then doodle all over the flags as it
> goes through the page setup prior to return (include the post hook).
> 
> Haven't seen a reason why this shouldn't be done this way.

I'd tuned out this awful series since it'd become apparent that my
feedback wasn't going to be taken seriously.  Good to know I shouldn't
take it personally because he does it to you too.

I think it's apparent that Michael has no understanding of the MM.
So we should start again with the architecture.  Let's look at the
problem that he's trying to solve:

 - The hypervisor has zeroed the memory that it passes to the MM
 - But the MM then zeroes it again before passing it to userspace.
 - We want to avoid this

Let's make sure that's the actual problem before going any further.
Because I do have a design that will satisfy that without doing this
insane level of invasive change, but if that's not the problem, there's
no point wasting my time writing it up.

