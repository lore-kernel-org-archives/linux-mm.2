Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 537F8EE4988
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 16:14:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB1D16B0089; Tue, 30 Dec 2025 11:14:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5F7E6B008A; Tue, 30 Dec 2025 11:14:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96BE96B008C; Tue, 30 Dec 2025 11:14:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8772F6B0089
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 11:14:22 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 390C38A8FF
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:14:22 +0000 (UTC)
X-FDA: 84276634764.15.019E914
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8D1994000D
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:14:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="IXuWam/Q";
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767111260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nVrdMXUw00hgV69sSSBMiYwuTELWJbA+S6oR8mm1axQ=;
	b=OyQqVYFDsX/PqgN7YT3YoHUxqEa33FfBK2pZOTJYIIaWWjeJ16pQSMSVQOVsLEeFvRjT/V
	z2bJ/hNZwtVM58yo/yXKonUV9PRP0ApHnOpqPNk8ONLMiAXARL/qnvE8ekNvV0ZlaU6oV/
	EJTIJPA7hfAJlNiYsFuwKlsKjXypGxc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767111260; a=rsa-sha256;
	cv=none;
	b=3vRvD+NlDH7bR7mNLrVXkQ0M0Jxxl1M0Lo1lqzvplSG/uIcW1Yb19sbJMqxrGRrZs/Ucig
	8fsQJuUyGcjgF7BJUkIEZqEnUlf4q0XY5fY/8+HhTPiGyG7qCT+E1CPzBfZgbYmjzZhMIK
	2kzZNhU5ytNMWkq7u+5Zc8z6nYheUYg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="IXuWam/Q";
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D457E60010;
	Tue, 30 Dec 2025 16:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D5EC4CEFB;
	Tue, 30 Dec 2025 16:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767111259;
	bh=v6ym8j7jR1OnzDUiF+SxHOJ0RzBeUWzfVU7NjEmGKwg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IXuWam/Q60CMdaUb9LOVyCAv/k+xdqrez982rFsuoRV51Hsfrnw/yKmWktD1qTXl3
	 P3oqkVSHmJQtlQA940ReBDH4okDLq4fWwHP97Nf3NO1MxC7ArNmOuCiZAS5Tdccqie
	 vhAuknkHy0FizIBpyyTqB06XRtHc0m7TQYm+VZ+anGZB9rvL4wGRMXfgOpHhOJtRzw
	 5MZRGIpfyt3feaBb4NyNme2I8oIgWeLDz4WbOKbnmPZMH6pM0rhjVK/pPGKLDN7soQ
	 8arfwuwNWh9169+K28yHTHYtVwKehZZKVl+Kk1J21YRDgoZyWKqy25ZtOjKCvB9ZJ9
	 fmqNqVSyGxuiA==
Date: Tue, 30 Dec 2025 18:14:12 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Evangelos Petrongonas <epetron@amazon.de>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	nh-open-source@amazon.com
Subject: Re: [PATCH] kho: add support for deferred struct page init
Message-ID: <aVP6VO5Ycr5xynwj@kernel.org>
References: <CA+CK2bB2mn5b0N9gs1UavYLUQhbpVvdo702oHZa15E9OaZkKWg@mail.gmail.com>
 <aUUYprAotKYMiEs0@kernel.org>
 <CA+CK2bD101cSC_7+OWkMei2QvUVjSaRLy+LboLe8Sz7KS3by4g@mail.gmail.com>
 <861pkpkffh.fsf@kernel.org>
 <CA+CK2bA1kYCf0BwhX3Sg9Ur82nK-7HPzs0sg6xbVWFAJaZLhpw@mail.gmail.com>
 <86jyyecyzh.fsf@kernel.org>
 <CA+CK2bDxnTEe9Ohq5zLuyF-jqgD0DPhfdq6z=yztUsXU5p5fSQ@mail.gmail.com>
 <863452cwns.fsf@kernel.org>
 <CA+CK2bCjJWZG_rPoPsHWSxirmUCTOuFQzTCss2AKf9UqpThrdw@mail.gmail.com>
 <864ip99f1a.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <864ip99f1a.fsf@kernel.org>
X-Stat-Signature: 6ib5x9q4en8tm1zdrwk99ezp64z5mk9h
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8D1994000D
X-Rspam-User: 
X-HE-Tag: 1767111260-17214
X-HE-Meta: U2FsdGVkX1+OZk5/L4EtpKLwhmZvPdWvJlfmjjtL5NXHaBqqgamETyA079dKxb0DBNOwHlrgNY8a1+HhI7+mVpCQcnI2i0JUazZHtwx6dakniRDVvJB+cEZOswcNzZGpeKedbinTYkLqgeif3WAoG1BlieTT+H8EodC23GJx/hZhIm2zU7qdT8Dh8gUaXk60fHOkiJokkhP9hNJsjDe2OwUq7HuitGMX0ExkEfva28grPeyGr7EYxnmgbRTgZlT8Lb1xz1S83f7mTE2QjPC4MTQUouykM5eJvvEY9xqkxLt4PASgBKHgjsPNzNx5elHzqaAO4pDZkEw3+lr5mHYqU1UGNC7iVhaxKsOnIK4v17UPkuFKPvIWyn7kGltvMJRljZVzQtce0LfKfKruGyXybtSZS4hq+mgB4Zo8uDMq0dOvSQm/jJAArnB/FCEHqyLRpvzTLjMXJTx/HXFqMNQPhewmXW6MyAhks0O64J/9ukG8lZXDUuVeNDdQ852ITutZpW8lR4i7CgbtirBorb7As8CzgD7bsEhDuBZYbzNfTjJct/xdQhnkBXbuiVosD5MwsqN8CLHhQ55a1z1mPETLL8YGKr6V0QHchhLW1XVa+lv4kXjMEbw4dDSzoWr/JFC+P9C/qYkNT2bonjE1LDMShh7uE5pdoqMfP9pFM1uBQJH6jeftEDuQRnnu8+FR0XoUHTzIpL3IuburtJ0muJDP0db5HjTfIt5AcB+MH37MVZnvS5KsX8VlQtPOKGNSXLGLIOJDCtahHB1gs562PI+4KOTyDUaehZXlg3i9OhNMyyKdA67V7UKBV8ykQ1ux5Tn54YKqeBQF0ABPBpDy4yWbwwavnYb8VyWKI8fQmzfujSaaT4ar4KwpuAdl2PfT0yehku+pvpF6Jul9UEHR70OE7SNJW3ZNa483M2J+gD90RpYxriWHR11qGx3l3TDeKf44ud96UZlfugeUVJJzqVX
 WoDTawV4
 iq0bkTk0dKrxsxc682yU8rPI9LUm9Ib84UG0yZ+EUWrn0WYAK4qkyn+eu2QENiGIFxio7PE3+Jc7tA0KdiCLICH2RF4UQWhhapRkzS3aLGOtUirydBxTrwHuV7h7Gl8CyCXGVzA+jeZAkHfZkIRsm964adF2WzbIa6cEMJlA4Y+hbnj0RhFInVez/nHUHtcqPESV1vyfZ/4VFrI2O4oYBbZBu4CB0jG2MWkh5FocmiKjIrW6i7pIks5tevZWC7G8gHO5KS500hvSL4WJqVz2T/qpFPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 29, 2025 at 10:03:29PM +0100, Pratyush Yadav wrote:
> On Tue, Dec 23 2025, Pasha Tatashin wrote:
> 
> >> > if (WARN_ON_ONCE(info.magic != KHO_PAGE_MAGIC || info.order > MAX_PAGE_ORDER))
> >> > return NULL;
> >>
> >> See my patch that drops this restriction:
> >> https://lore.kernel.org/linux-mm/20251206230222.853493-2-pratyush@kernel.org/
> >>
> >> I think it was wrong to add it in the first place.
> >
> > Agree, the restriction can be removed. Indeed, it is wrong as it is
> > not enforced during preservation.
> >
> > However, I think we are going to be in a world of pain if we allow
> > preserving memory from different topologies within the same order. In
> > kho_preserve_pages(), we have to check if the first and last page are
> > from the same nid; if not, reduce the order by 1 and repeat until they
> > are. It is just wrong to intermix different memory into the same
> > order, so in addition to removing that restriction, I think we should
> > implement this enforcement.
> 
> Sure, makes sense.
> >
> > Also, perhaps we should pass the NID in the Jason's radix tree
> > together with the order. We could have a single tree that encodes both
> > order and NID information in the top level, or we can have one tree
> > per NID. It does not really matter to me, but that should help us with
> > faster struct page initialization.

To setup page links we need nid and zone. AFAIR we have 7 or 8 upper bits
free in the radix tree, so to support the general case of up to 3 bits per
zone and up to 10 bits per node we'll need to implement two versions of
detection of zone and node for a page.
I'd wait with this optimization for a while.
 
> Can we use NIDs in ABI? Do they stay stable across reboots? I never
> looked at how NIDs actually get assigned.

Node ids are assigned by the firmware, so unless firmware changes or there
are hotplugged/hotremoved memory they are stable.
And we can't really do hotplug/hotremove with KHO/LUO anyway :)
 
> Not sure if we should target it for the initial merge of the radix tree,
> but I think this is something we can try to figure out later down the
> line.
> 
> >
> >> >> To get the nid, you would need to call early_pfn_to_nid(). This takes a
> >> >> spinlock and searches through all memblock memory regions. I don't think
> >> >> it is too expensive, but it isn't free either. And all this would be
> >> >> done serially. With the zone search, you at least have some room for
> >> >> concurrency.
> >> >>
> >> >> I think either approach only makes a difference when we have a large
> >> >> number of low-order preservations. If we have a handful of high-order
> >> >> preservations, I suppose the overhead of nid search would be negligible.
> >> >
> >> > We should be targeting a situation where the vast majority of the
> >> > preserved memory is HugeTLB, but I am still worried about lower order
> >> > preservation efficiency for IOMMU page tables, etc.
> >>
> >> Yep. Plus we might get VMMs stashing some of their state in a memfd too.
> >
> > Yes, that is true, but hopefully those are tiny compared to everything else.
> >
> >> >> Long term, I think we should hook this into page_alloc_init_late() so
> >> >> that all the KHO pages also get initalized along with all the other
> >> >> pages. This will result in better integration of KHO with rest of MM
> >> >> init, and also have more consistent page restore performance.
> >> >
> >> > But we keep KHO as reserved memory, and hooking it up into
> >> > page_alloc_init_late() would make it very different, since that memory
> >> > is part of the buddy allocator memory...
> >>
> >> The idea I have is to have a separate call in page_alloc_init_late()
> >> that initalizes KHO pages. It would traverse the radix tree (probably in
> >> parallel by distributing the address space across multiple threads?) and
> >> initialize all the pages. Then kho_restore_page() would only have to
> >> double-check the magic and it can directly return the page.

page_alloc_init_late() is probably too late and some subsystems might need
to call kho_restore_*() before it.

> > I kind of do not like relying on magic to decide whether to initialize
> > the struct page. I would prefer to avoid this magic marker altogether:
> > i.e. struct page is either initialized or not, not halfway
> > initialized, etc.
> 
> The magic is purely sanity checking. It is not used to decide anything
> other than to make sure this is actually a KHO page. I don't intend to
> change that. My point is, if we make sure the KHO pages are properly
> initialized during MM init, then restoring can actually be a very cheap
> operation, where you only do the sanity checking. You can even put the
> magic check behind CONFIG_KEXEC_HANDOVER_DEBUG if you want, but I think
> it is useful enough to keep in production systems too.
> 
> >
> > Magic is not reliable. During machine reset in many firmware
> > implementations, and in every kexec reboot, memory is not zeroed. The
> > kernel usually allocates vmemmap using exactly the same pages, so
> > there is just too high a chance of getting magic values accidentally
> > inherited from the previous boot.
> 
> I don't think that can happen. All the pages are zeroed when
> initialized, which will clear the magic. We should only be setting the
> magic on an initialized struct page.
 
Currently we set the magic on an initialized struct page because we don't
support deferred struct page initialization. If we want to enable it, lots
of struct pages are uninitialized by the time kho_mem_deserialize() runs.

To ensure there are no concerns with the stale data in the memory map we
either need to initialize struct pages in kho_mem_deserialize() before
setting page->private or let memmap_init_reserved_pages() initialize them
(e.g by splitting memblock_reserve() out of kho_mem_deserialize() and
calling it before memmap_init_reserved_pages())

It seems that hugetlb support anyway requires moving of memblock_reserve()
earlier, so maybe we can do it as a part of deferred initialization work.

> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

