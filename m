Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEF84C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 14:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F039F6B0095; Tue,  8 Sep 2026 10:06:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB47A6B0098; Tue,  8 Sep 2026 10:06:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA3A16B0099; Tue,  8 Sep 2026 10:06:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C13C56B0095
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:06:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 639D48067E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:06:22 +0000 (UTC)
X-FDA: 85190769804.25.413AFD2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id D735010000C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:06:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788876380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4+u2yXTlOWKcqkeqK6YRaaFUGKsrCjZSa2GeIvnymUI=;
	b=8nqWqwk4UCFp2CopYga0x382oEPGV0CoEeS4YohA/9cwsLHh1oRB1OUFYr9fokmY15EaM+
	DMSLDZBl7MGAVxdxxPr5JjOi8VIKsm3eqfIA7TLJ6dqLrFlrkzOlqyNhnyt3HTO/xeawEv
	xVfE6QyUQ/56gyz5YgeLC5xMg9B0VT8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788876380;
	b=qkEYV84Q3z+oKSuBIeCAZU9HBwpKvMbe4mb9yCxb/aN7UmQ8aKJpJVAwZBioV9ZmA9RlZq
	jjrcokbM3rbxCUTu0jTfK+7EQhCzs5l52gv6LcOl1slgZw9ebDAaAA+UzvmL66JCCobyUN
	FcJMaoGgDVPBp3n6Bg5yqLJOe+THJ3o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 343DC601F7;
	Tue,  8 Sep 2026 14:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66881F00A3A;
	Tue,  8 Sep 2026 14:06:08 +0000 (UTC)
Date: Tue, 8 Sep 2026 17:05:44 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexandre Ghiti <alex@ghiti.fr>, Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Len Brown <lenb@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>, Pavel Machek <pavel@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>,
	Will Deacon <will@kernel.org>, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pm@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	loongarch@lists.linux.dev
Subject: Re: [PATCH v3 4/6] mm/vmalloc: make set_area_direct_map HUGE_VMAP
 friendly
Message-ID: <aqAWOKZDiHE9ksrM@kernel.org>
References: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
 <20260903-execmem-set-vm-perms-v0-2-v3-4-949b64a9f755@kernel.org>
 <2b0f5877-e71a-4824-adeb-5af2dd8b0269@kernel.org>
 <ap_tjOTR48tja_8e@kernel.org>
 <d379aae2-4249-4c6a-a748-5419d4f74f34@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d379aae2-4249-4c6a-a748-5419d4f74f34@kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: x8f6o5mhh1z448z4jnk38ycwgja8mict
X-Rspamd-Queue-Id: D735010000C
X-HE-Tag: 1788876380-507027
X-HE-Meta: U2FsdGVkX1/cgG7S1raPQG/cz6qhaB3VFc9BDv0nUCefEPv7Ef4WZS7oOnt70/sJ3DvzpZBJHUA44DoL4cT6hYlefRtoxKsByolVDyH9Zahcv4DuXcYNzatlxwWYoKA4MyZyBKY8SjbLEnl20wNhpntB5l7f5b6zaB7SlBxFbodbPPkr8Hs1lanS9nuqKrNgp5qi6+F6ktjivQp9UW0QlNl2ErAM/PXnxcKXlfro7Vu401I+05egCgyLf64WqL+AKVv6O2VJLPsx7dWXg31xLuq+nktPlVjPbUN5E4RnLM2m+cBLNcN2Tx4AIEqY+oy4tHdZyt7u0zz4IrigwTr8heH2uQL8L10BGXawJNg4X36BBoVh34e5Su7II3CVd3mRB9XD4jHlo/ZUqdh2p/0c81mZYXrCsCMnjxd5IHr5arWwwWhn5aAFaHLvSRqpqUGyv8zAG52jnRYlVl5PZuE+foHtAAcajsBf9bkEs9lGlMUkAsfT3U31ebOsubzRuA3xDP2zEqpCcmTQ76WiqpoxExPduiwFVpFYmfqkriyeSvkIruvVjXQ326YPK8+eLM8PCz+zaUbduI+4klEtQ+fy+2GzgWYbomVvWHH9zoviMQVLGM+50HnIxS9xddU0wZPf3iDlSGZYQ8iasvOqig81Yh3C9AH+NlVTCgsVcBIhYHhwj5RMwfcEE75RNl1/qsVYjqcQshi7D2onY5dRXQFYNcODW+GNHe9H5ren8vCuBP0+tG+bPJCqguLdzNcAGKBO1P0mw+lySVd/tVhBB+/FHLB3mR1lgJhIuP4KxhsL5Jh4aJ67kF4jdJ1NBigV9bIuXlCf/59DAWmLXRorB4t7A7is3cpHZmZKNIO7eO8NvoFn6oOIyDPmmnjmdGXWYHE+TQfLr/yyBgbFp0BhEvgzVNQwD2Sw6cZ2dYty4c5409sLczLITgK0rASim7LwSzA89M/vxzsUSwa/Xj2bOQX
 upIb2LZ4
 uam+vcp2hJ03jJ/mxOF9/RnpOCPb9lUKHLqxV77pha6HJFTV+0+oYuNfXMYt1CG+NTVIuhqnnXVDPEVuUZIMFmpnzXuzGnUVs/bolz9jpOpi0yINsNr8X0+0QQbJ6A0JFHmjng59pC91e2KRt8XEFla5bFzi7H0Ggiazs3olKaV+MFA/wqYHajUGpxkNZFfyImCANRrDBsgtvst/EQaN1G3t+ZyNk+FCI1F/p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 01:48:36PM +0200, David Hildenbrand (Arm) wrote:
> On 9/8/26 13:12, Mike Rapoport wrote:
> > On Tue, Sep 08, 2026 at 12:41:48PM +0200, David Hildenbrand (Arm) wrote:
> >> On 9/3/26 11:28, Mike Rapoport (Microsoft) wrote:
> >>> set_area_direct_map() always updates direct map alias permissions in
> >>> single page increments.
> >>>
> >>> For HUGE_VMAP areas it's suboptimal. Not only the loop in
> >>> set_area_direct_map() needlessly has more iterations (e.g times 512 on
> >>> x86), but it also causes fragmentation of the direct map that could be
> >>> avoided for the HUGE_VMAP areas populated with large pages.
> >>>
> >>> All pages in an area are always of the same order: either same-order
> >>> large pages when VM_ALLOW_HUGE_VMAP is set and all huge pages were
> >>> successfully allocated, or order-0 page when VM_ALLOW_HUGE_VMAP is
> >>> cleared or when huge pages allocation fails and fallback path is taken.
> >>>
> >>> Instead of updating the direct map permissions for every order-0 page in
> >>> an area, use the area's page_order as the loop increment and update the
> >>> large pages in one call to set_direct_map_{invalid,default}_noflush().
> >>>
> >>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> >>> ---
> >>>  mm/vmalloc.c | 13 ++++++++-----
> >>>  1 file changed, 8 insertions(+), 5 deletions(-)
> >>>
> >>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> >>> index 5506b180f5c27..6ed6c160abed7 100644
> >>> --- a/mm/vmalloc.c
> >>> +++ b/mm/vmalloc.c
> >>> @@ -3367,12 +3367,15 @@ static inline void set_area_direct_map(const struct vm_struct *area,
> >>>  				       int (*set_direct_map)(struct page *page,
> >>>  							     unsigned int nr))
> >>>  {
> >>> -	unsigned long i;
> >>> +	unsigned int nr = (1U << vm_area_page_order(area));
> >>> +
> >>> +	for (unsigned long i = 0; i < area->nr_pages; i += nr) {
> >>> +		if (page_address(area->pages[i])) {
> >>> +			int err = set_direct_map(area->pages[i], nr);
> >>
> >> Do we really expect some pages to have a directmap and others not?
> > 
> > Every page in the area can be allocated separately and
> > __vmalloc_area_node() has
> > 
> > 	if (!(gfp_mask & (GFP_DMA | GFP_DMA32)))
> > 		gfp_mask |= __GFP_HIGHMEM;
> > 
> > so generally speaking yes :)
> 
> Ah, I was thinking in terms of HUGE_VMAP, because there we sure would expect
> all-or-nothing, right?

Even with VM_ALLOW_HUGE_VMAP an area may be backed by highmem pages. When
huge allocations are disabled either because an architecture does not
support them or nohugevmalloc=no, vmalloc(VM_ALLOW_HUGE_VMAP) silently
falls back to order-0 allocations.
 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

