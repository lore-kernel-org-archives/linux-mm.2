Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FE5AD41D4C
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 15:03:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FB746B0007; Thu, 11 Dec 2025 10:03:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AB7B6B0008; Thu, 11 Dec 2025 10:03:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89A7F6B000A; Thu, 11 Dec 2025 10:03:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7576F6B0007
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:03:04 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EFA461A021B
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 15:03:03 +0000 (UTC)
X-FDA: 84207507846.21.8349D21
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id D556D14001F
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 15:03:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c64mCKe7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765465381; a=rsa-sha256;
	cv=none;
	b=Bm9EtlQoKMczMJcn8WkxeSrevioycf2dj3sH1AoBDpS0qsgY6lG6ciwV1I7mLNnGLXquoT
	YlIteIQzFHtnK5fCn2XPEjDeHIgoJqOpWeA7LDjB0b2nhn5/3eim7wXIHLtiMeLfzFs+7B
	ZX8BWJtmFjGvBORKUnKE+2eWoDS4uuI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c64mCKe7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765465381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m3AgACAxPT+VC827snBHyiIOuK1PWVQkXRgkvI+ouKY=;
	b=1m55zQXJdDfVAP0bfugCGOD6o7r5wG9bl/0lxshLgaD+/L0QYOOHCazxuiza60ZrbcO6ds
	5raUNjs5Cb1NgVDtS26EMkSS7uOC8UBkYA+LIFFPu1R/3JgmOG4ovhHK3lou3LR3D5qP0/
	7ou2xnHCdOIm5ocs59Cw6qZbPXcd0XU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 24AF060137;
	Thu, 11 Dec 2025 15:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CA8C4AF09;
	Thu, 11 Dec 2025 15:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765465380;
	bh=xlZUXqejsN7ctbfX3Kr79uQ3a9/b8Jw3fxqYjPtNYZI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c64mCKe7kMYKCv2CvPl1RxrhxfCX0G8VRyGr0fGzLeMT7Nae8IkPcPgBRx/SzGPX1
	 TD0lXkIyPc4s4Z1distMh41pR5C1S0Aa60X2PpIF8/52lKG9/AT8DcB8bccfHFpWRF
	 AV8rHiRvLsXxqBZdYeGOmCtgysyCg+FlyjdD8wxWVOp5o6OFuuj/vx09mGlIsxL1H5
	 cXGz/SGiZzJIUYU0iH89wpNDPBhIRO3F/xYcLHLgY84slbdeHYk+9hLwyLfPxrSesJ
	 n0QZjKjzkgwh+25dQ6qpESBsZCiIud7TcBe3VkP29s9FPGLoAXoIUjyIdIEaKxvjLO
	 7Iyw1qgH1E4XA==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 9913CF4006A;
	Thu, 11 Dec 2025 10:02:59 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 11 Dec 2025 10:02:59 -0500
X-ME-Sender: <xms:I906aUhnw_m2u3AylnCxsUtuWhQyc9OxdIPfG1KxQX0NWRPi7qcQ9A>
    <xme:I906aYbInKvW5YPfJYzAnpNeaETDytsONHczLwD2eedTf08auvNpqR7xNWwiLA871
    akWfYXe6dggkzIBYpNr-yxBkFrqBidkZ-ndOQgVrf-g3XhUs-6mpQ>
X-ME-Received: <xmr:I906aVfLIiqFe88uvNNhArAalczm6TtaSwKjG0PRZYWc7g7iBc65vwbosyle9g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvheeiudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtugfgjgestheksfdttddtjeenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepvddufeetkedvheektdefhfefjeeujeejtdejuedufefhveekkeeffeetvedvffek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpthhtoheprghkphhmsehlihhnuh
    igqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehmuhgthhhunhdrshhonhhg
    sehlihhnuhigrdguvghvpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpd
    hrtghpthhtohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhp
    theskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgiipd
    hrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhr
    tghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrgh
X-ME-Proxy: <xmx:I906adAFII0_3HQJ3ch1hllQct13BtZQQ-7617jSBs_hpTRYkVT79Q>
    <xmx:I906adVERJ2GsWK-l9HkA9St0MWKEnblXxNHA8FlY5_x3iDQJv5VKg>
    <xmx:I906aaXWqRQ6ELJDY6QFMQLrYkNzBl4qe4Ism8jUJzmFL2DW4BCtCA>
    <xmx:I906aY9sZiGQ1pLrfN5cNBF0a4KmiybyotA7q98aOpOzU_UCK1OQhQ>
    <xmx:I906aY8NXSe1T15uWMvWV-zrf6XdIiBCr7-GFiU0wGoM5afbXGFK2wB0>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 11 Dec 2025 10:02:59 -0500 (EST)
Date: Thu, 11 Dec 2025 15:02:58 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Frank van der Linden <fvdl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, Usama Arif <usamaarif642@gmail.com>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 00/11] mm/hugetlb: Eliminate fake head pages from vmemmap
 optimization
Message-ID: <ackz7hv2oskh4yx4ebk6pkalt3i6buulcn23celgqfqrbkn2hi@hlrsm4ugw66n>
References: <20251205194351.1646318-1-kas@kernel.org>
 <CAPTztWaWnurc=9fOBpPO25JoZu6PHU6c7AYNJbE+xdWV4gwskA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPTztWaWnurc=9fOBpPO25JoZu6PHU6c7AYNJbE+xdWV4gwskA@mail.gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D556D14001F
X-Stat-Signature: 4ngqs5zo597easm14i5zri6uhjd1eamw
X-Rspam-User: 
X-HE-Tag: 1765465381-486395
X-HE-Meta: U2FsdGVkX1/AcLWGHmYo1OJSwIy2UnzNaAgGNQxW9uEBoKW85Do+QgW7RLlywxKgoVYSP7g8QS7+1BZxPQmSUpvgI45H9OvttPogydvNdjqVCKAi16vWiG/Ll33cT61fhiQVVDZ4kEt3j49xOo8GHEoPC7SCfEuwr8JRPMkM4YC6H5AgbD7EEJ1WQ2+ZoP7J4igYytvfOrfD5AZ05f3dqH3CgSCMjbErFQOoIzF/uR32SSL+PT0rIG4Vibiq3fIjGeUD/1uMsSdi1Sqx9KI0P1kWmiXOgqvKC++43mLNcnWWJaKUVKQcW+fcgWvbxk9I5A6MfU+p8KDGFyC8z1fg9CmD8O62XNcSR+jMA2kd6lrrp0th59n8thtRmPT2hf72X2ayGZ8fzS8k2W3EBZdgX/GOo0sdmAnv0D/CW6zVgooQOnyrjJNctxpJsLE3Ma6jgcxULZHIPtlCDESpG/hp5IFCnnOi49VUb8Fhw7pqu3addYTn7ck32ClNUqbkh1l/hqq4EMOxqOmtPGKfppRvFRYoU9PzOtusRXjNGpcyl0lsT2ciNqdm0Kf4DMgwPBAzTP+4fWZyD87Uxabw5bCa1zgTgUPzEIbP1qHPcIuaMW2zJHJatHR6hAFxP3JaRS4AinTqODQHKNx2uZchBaTK3h8LUxMqr+fNRG4e+ke5t3IcfXdAdB8m/IGKildEVcqKcNskfNSvEgDzxTCMx0vb6GEV7CPv4WL3m17OWNaCrip8ii2ifJWGjLTGtQTyjZtQj9m6AgXl+8pMXmPVoMXdX704lcZIvpMAcIjKgRhaCnnuU1gn8LV1pk83HkplQUIxl+qkpPHaJIDXS4wyHZFXDp8p92UIIdd5LjMTvkmVP5IcBGWt9Hax57thmdNtC09lrRb5QRgkLMPfkNjgGtv/9zKuwPlT1k5zHomsQKY/Hm2kVZoDSv6S9/PBFoKvwrdPjLVno5/0ZanHeH8XlzG
 6DlDWuhR
 EyNznlBLEq9H7gMgFiHHZl0hA5c2EVk7IQFN4Pg0ABENdnLjFfIUUcJ9ISJNaRMh/UsoQIaxWnDy2mQWMdcWVBIg5LwVgj299HsBQ9Edr2sY8BWqvIYWGbto2wJLdjZlU7ecFjLm0XhRyD5P4I4vG+tDvtN6woC7285ApSE5BDjTyNZn9oaXRcbpuIzKBFtWZnESiqwG7T4GC8anX5w7GkiOAXWmWemJtLpQpjHC0wXZjBZ0BIW3w/MwYBzXpkC4VgnUQ3FLIMrRDPFEomPAEx97lK8wMMfl5eUy7qS4P9q3AWDDe6MZHTKVfcXNlR5qljtZI2IR1Y5fzMvQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 09, 2025 at 10:20:14AM -0800, Frank van der Linden wrote:
> On Fri, Dec 5, 2025 at 11:44 AM Kiryl Shutsemau <kas@kernel.org> wrote:
> >
> > This series removes "fake head pages" from the HugeTLB vmemmap
> > optimization (HVO) by changing how tail pages encode their relationship
> > to the head page.
> >
> > It simplifies compound_head() and page_ref_add_unless(). Both are in the
> > hot path.
> >
> > Background
> > ==========
> >
> > HVO reduces memory overhead by freeing vmemmap pages for HugeTLB pages
> > and remapping the freed virtual addresses to a single physical page.
> > Previously, all tail page vmemmap entries were remapped to the first
> > vmemmap page (containing the head struct page), creating "fake heads" -
> > tail pages that appear to have PG_head set when accessed through the
> > deduplicated vmemmap.
> >
> > This required special handling in compound_head() to detect and work
> > around fake heads, adding complexity and overhead to a very hot path.
> >
> > New Approach
> > ============
> >
> > For architectures/configs where sizeof(struct page) is a power of 2 (the
> > common case), this series changes how position of the head page is encoded
> > in the tail pages.
> >
> > Instead of storing a pointer to the head page, the ->compound_info
> > (renamed from ->compound_head) now stores a mask.
> >
> > The mask can be applied to any tail page's virtual address to compute
> > the head page address. Critically, all tail pages of the same order now
> > have identical compound_info values, regardless of which compound page
> > they belong to.
> >
> > This enables a key optimization: instead of remapping tail vmemmap
> > entries to the head page (creating fake heads), we remap them to a
> > shared, pre-initialized vmemmap_tail page per hstate. The head page
> > gets its own dedicated vmemmap page, eliminating fake heads entirely.
> >
> > Benefits
> > ========
> >
> > 1. Smaller generated code. On defconfig, I see ~15K reduction of text
> >    in vmlinux:
> >
> >    add/remove: 6/33 grow/shrink: 54/262 up/down: 6130/-21922 (-15792)
> >
> > 2. Simplified compound_head(): No fake head detection needed. The
> >    function is now branchless for power-of-2 struct page sizes.
> >
> > 3. Eliminated race condition: The old scheme required synchronize_rcu()
> >    to coordinate between HVO remapping and speculative PFN walkers that
> >    might write to fake heads. With the head page always in writable
> >    memory, this synchronization is unnecessary.
> >
> > 4. Removed static key: hugetlb_optimize_vmemmap_key is no longer needed
> >    since compound_head() no longer has HVO-specific branches.
> >
> > 5. Cleaner architecture: The vmemmap layout is now straightforward -
> >    head page has its own vmemmap, tails share a read-only template.
> >
> > I had hoped to see performance improvement, but my testing thus far has
> > shown either no change or only a slight improvement within the noise.
> >
> > Series Organization
> > ===================
> >
> > Patches 1-3: Preparatory refactoring
> >   - Change prep_compound_tail() interface to take order
> >   - Rename compound_head field to compound_info
> >   - Move set/clear_compound_head() near compound_head()
> >
> > Patch 4: Core encoding change
> >   - Implement mask-based encoding for power-of-2 struct page
> >
> > Patches 5-6: HVO restructuring
> >   - Refactor vmemmap_walk to support separate head/tail pages
> >   - Introduce per-hstate vmemmap_tail, eliminate fake heads
> >
> > Patches 7-9: Cleanup
> >   - Remove fake head checks from compound_head(), PageTail(), etc.
> >   - Remove VMEMMAP_SYNCHRONIZE_RCU and synchronize_rcu() calls
> >   - Remove hugetlb_optimize_vmemmap_key static key
> >
> > Patch 10: Optimization
> >   - Implement branchless compound_head() for power-of-2 case
> >
> > Patch 11: Documentation
> >   - Update vmemmap_dedup.rst to reflect new architecture
> >
> > Kiryl Shutsemau (11):
> >   mm: Change the interface of prep_compound_tail()
> >   mm: Rename the 'compound_head' field in the 'struct page' to
> >     'compound_info'
> >   mm: Move set/clear_compound_head() to compound_head()
> >   mm: Rework compound_head() for power-of-2 sizeof(struct page)
> >   mm/hugetlb: Refactor code around vmemmap_walk
> >   mm/hugetlb: Remove fake head pages
> >   mm: Drop fake head checks and fix a race condition
> >   hugetlb: Remove VMEMMAP_SYNCHRONIZE_RCU
> >   mm/hugetlb: Remove hugetlb_optimize_vmemmap_key static key
> >   mm: Remove the branch from compound_head()
> >   hugetlb: Update vmemmap_dedup.rst
> >
> >  .../admin-guide/kdump/vmcoreinfo.rst          |   2 +-
> >  Documentation/mm/vmemmap_dedup.rst            |  62 ++---
> >  include/linux/hugetlb.h                       |   3 +
> >  include/linux/mm_types.h                      |  20 +-
> >  include/linux/page-flags.h                    | 163 +++++-------
> >  include/linux/page_ref.h                      |   8 +-
> >  include/linux/types.h                         |   2 +-
> >  kernel/vmcore_info.c                          |   2 +-
> >  mm/hugetlb.c                                  |   8 +-
> >  mm/hugetlb_vmemmap.c                          | 245 ++++++++----------
> >  mm/hugetlb_vmemmap.h                          |   4 +-
> >  mm/internal.h                                 |  11 +-
> >  mm/mm_init.c                                  |   2 +-
> >  mm/page_alloc.c                               |   4 +-
> >  mm/slab.h                                     |   2 +-
> >  mm/util.c                                     |  15 +-
> >  16 files changed, 242 insertions(+), 311 deletions(-)
> >
> > --
> > 2.51.2
> >
> >
> 
> I love this in general - I've always disliked the fake head
> construction (though I understand the reason behind it).
> 
> However, it seems like you didn't add support to vmemmap_populate_hvo,
> as far as I can tell. That's the function that is used to do HVO early
> on bootmem (memblock) allocated 'gigantic' pages. So I think that
> would break with this patch.

Ouch. Good catch. Will fix.

> Could you add support there too? I don't think it would be hard to.
> While at it, you could also do it for vmemmap_populate_hugepages to
> support devdax :-)

Yeah, DAX was on my radar. I will see if it makes sense to make part of
this patchset or make an follow up.

Other thing I want to change is that we probably want to make
vmemmap_tails per node, so each node would use local memory for it.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

