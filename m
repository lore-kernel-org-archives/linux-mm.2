Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82D01FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 12:10:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EF636B0088; Thu, 30 Apr 2026 08:10:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C6006B008A; Thu, 30 Apr 2026 08:10:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DD136B008C; Thu, 30 Apr 2026 08:10:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B8F26B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:10:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E5FD188631
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:10:00 +0000 (UTC)
X-FDA: 84715103760.21.26DAC28
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8CC6E140011
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:09:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=YaQNUCCD;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf09.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.49 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777550999; a=rsa-sha256;
	cv=none;
	b=JU0mqDQQNFTl4DAhJi7WbUYfDpozKb2jf7V4IgiySaTCkmpbd75aRUYwz0nwyzoh1lCoU4
	p9CKWX1l0DYdzO78KKjdieyt2aB9RD/kLmWxmh5yT7KLG1ckP8yD4L3L7woJS4IWGPmnT0
	mEXTbC/V2ihv/IBEiWBuB0VCNNmNb+U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=YaQNUCCD;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf09.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.49 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777550999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BM5KrwxlYL2yWx54/IrxJMUv0ov8gisDWiwFBM3mToc=;
	b=P7aeBFgwy/Hm+PSyMwu0i4zW0Kp9SHANcVPJb33vYnTWEuHaur+b8yLhqz67AgXBbtD5Fd
	3tpPrqsjAHKQ8z+SRUmwR0Y4PrE6eyeB8gfI2DAVR9hC5vxbjBLN7T93NF9qyMs/7c3uf+
	zbmEom+xjpljFmmUdPZb5afntBUNocA=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4891c00e7aeso7561945e9.2
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 05:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1777550997; x=1778155797; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BM5KrwxlYL2yWx54/IrxJMUv0ov8gisDWiwFBM3mToc=;
        b=YaQNUCCDwv6U/J4YHOLJTOV82nhvoUNM0UnGtU4fsgYiVIvPU6tc/rbNXKzDv1VKfy
         z7URPIa8i/rebHfu0yVgJZ6dZ8bwbnUAhCJ0HrhmQIl/eilQabuPXjJ7gzGE4FfRWpX2
         ITlplgldIswP45xysnckpXCsgNo3Cs51C6qCYgVArhMy++Is+hrZSroWliSDqcyaPixb
         AtiUu2eX03ca2YZOXBJTd0u+j6CorzopYTUawbsCi6hfq3+uS/Mn7WY5DCIVnOjJGRZR
         mDXjvLF55gAjvlIltW9GDps89RaYs9ind2JkCOBS+33CTcc69rLH8tbwI81aemA2xo4p
         ZMJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777550997; x=1778155797;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BM5KrwxlYL2yWx54/IrxJMUv0ov8gisDWiwFBM3mToc=;
        b=jppdJhIJohvvGjo/clusJmiULCLBRUIQQQhdkItvVl2A/a4WulalpN7xQ9VMXoatiT
         jFuasga6bciWaeKiOjV2blGJe+nt0RG/181S78ihkeTQC95++abbG61Bu6JcQv1qLElX
         B5dVJOIjQ0JhJfDanKOLsf0wUxZVzD8KEjXYsnnidm24hyI3Ndolz4cPNBHgpsqqoZ1A
         AenWgA3oyc1W6H1dmKkwtaD0jShVkE4LgN5RzBZmEyxXH/fikAcwmPoDV7YYnXZ2lhw3
         oFVKmgjL8y0Pw3atFmmXBXVMRvWLm2i57NGohd1zEuJ5H13ak1tIvjAqZBiGfHpBc1uF
         4GDQ==
X-Forwarded-Encrypted: i=1; AFNElJ+EYFDPRt4rBZJi52jZkbqK2rvMOMWuFuXo96qlE92KcOQaqphek53F12RZ+6P+S7NJ0YWK6W8NkQ==@kvack.org
X-Gm-Message-State: AOJu0YyZo8twSyajrDJ80J2CbIlwcy6afMXnW4BdUqOUO2WheWnato/o
	itYz+d++RncVmZso5cQIXB4IJxPViqv5/C307Q4xWsy+oNr/7jXdWPogys+QxrF7B4Y=
X-Gm-Gg: AeBDieuHiPcI+9aMRScxqGnZZyjZWWNYlQ6WN7a3zbaJMxH7c9ihQQDudmTcHnRDqH6
	lJ/Zo10FBKsZ8tUGHJnbYRQumMa3PfxqixGdeuS1ZRAcXrTw+QL5s6l5rP183KCkCyV0QWcBKZj
	/cv4hdDvpQgNNQEa3kPAqOeM7hi1gy/sTtbrarZPPwNhdkqihA7/xkzsMxNX080mrSjnIB2nMFH
	E1KYCeqMGIfoCBU5aWsOcD74TsY3r7MpOjFYvZDkdAGVwCqxiQOUidpCThbbcQHqxi0J60QpHnL
	UDTPRR+9i/PdL9/l0Ag9RwVsFALA8QAlgjmgjQ9hZ/4IOMs1hw6pSIzEMjCzjJ51x8/26ptqG+R
	Qjvi1U+i2YkBNP5xqwUHiWSLKa3dX1f+Gwp5HgrVvZ8FKDLruBKRvfuNvf7YhSk8Fvyqk0lMYQf
	jfOvpq8vyM4StFuZJIMMgKR9dHcQ==
X-Received: by 2002:a05:600c:5254:b0:486:fbdb:b718 with SMTP id 5b1f17b1804b1-48a8445f451mr47883195e9.25.1777550996490;
        Thu, 30 Apr 2026 05:09:56 -0700 (PDT)
Received: from localhost ([2620:10d:c092:600::1:2d86])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a824f9f0dsm58153455e9.15.2026.04.30.05.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 05:09:55 -0700 (PDT)
Date: Thu, 30 Apr 2026 08:09:50 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
	David Sterba <dsterba@suse.com>,
	Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	david.hildenbrand@arm.com
Subject: Re: [PATCH v6 0/3] mm: Free contiguous order-0 pages efficiently
Message-ID: <20260430120950.GA1738@cmpxchg.org>
References: <20260401101634.2868165-1-usama.anjum@arm.com>
 <20260429103326.GA1743@cmpxchg.org>
 <20260429050430.d86f01dbe731edc9fa932add@linux-foundation.org>
 <9834200a-492c-4705-a2b2-e76cc0ba5392@arm.com>
 <4ff3d230-d48d-4a9c-aac8-30a7b80c4775@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ff3d230-d48d-4a9c-aac8-30a7b80c4775@kernel.org>
X-Stat-Signature: ci8dqh7tbnx7ggio4jkffosp5jx3qfgk
X-Rspam-User: 
X-Rspamd-Queue-Id: 8CC6E140011
X-Rspamd-Server: rspam07
X-HE-Tag: 1777550998-988525
X-HE-Meta: U2FsdGVkX192MgRXKSoQuGhusZ/hQXAvy8Mcfsfqsg1xrSBl9xM55VKwn/HL8CDWHS8iNIKi6HFLnQqXY8MsNKX3Q/hBLKlQUOcMUslXYjJ0Y9fyUHnTUVWK5k2BRAZjD9Md1EGzb8HE4vT4P4Vbma4JsiyWAp+1PV08Ak/m4yIv9pbOdiydULOZfo4+4UaBc/rDGaKfHM2k3OffSFqANFLJ82cHSP49ptPrgUzRyKdPGe2tzuPtbWDq0sFiZGmM0v3GSLAamPLiaXrxQ8kgXZOyuoVOClBHCFWZGjF/nwwDC8L5ej8r25ljH/49m4i4FWEZzc9H9NIRUhDTPAsEm9JT1eeqkP10Asa/k1B4S73S9zz2TGICqHnGlIeLAvcZdLngy6qXBY7mK8ZIxjV1aYOULtQe+oCfp1iFYs2qIT2a5rqpVYqk8ITUJ+YhsiHnUcuidPXKSs+9i4z372WVz3Zw5oyZPX8ikSg1NrZ7YIuCnwml55xh3sTRoIFyRKUdk/80ropNPg0dVcfutL/pgahpf0qnzCoEjsJEK8h1fu/S+sizt/rT9YRSw6ezs6TkE4PC9HkTT6FjRL6Dvb6XN90Nu/b/F/2wHqOL4ZjRJHapSWPtsu7J3tl4GPfRYQ5oP/CH8Qf1YObkVbwYyPBperphaZ0RLhfFwHL6qjqNnz5ZDVnmMeQWFYopk8dxiqwbnRkP57+cUNnC8GEMIRlNkKlnL716mwZyzCz3aHLDViibExboPR75hGhvrE3YGPjt3Z++z5/21n+hN7iyTDKQRVACiFe5VALBtNYjbhOSkQonIGbKvNXcTSA93pxcVpXXIgYZPVSAaWd+qFxEB0+zwPi+MZobGq2ypr2Lolm2tSGLDadziXdrXcWYR+Y4XKTslQmr16K9jbFYsWt1JWlMIO963kSSsySaUgnvy59Zyd64r5BMTZ6SPcqxJ1mM06jtJSMoOrnx/ZmzE7jXGQS
 S9a9ibN2
 dijebEFN7bS6AIlXHXi5rKifRU7YoEBt7d/VD7rJHmJXoxuk7aK3qEYY9z4Cu9gVZgDfnjNS0fgD+PdAnYiwfuB1uChPQYletTaI1OCDyW2WUhDiSueT2aXZ2eHnHebiXOyOVq5hXSJxUd1PjWuNV7U6L6W82Ewq7AFVL5hCrFFY7l55ua81wsIFseiR1lwkTrBJLffUaGX0LyZMPZoebEfjyWvmZL3eHcYhR8h5QfjNDGfWjZc4CXCz5JBMRZ07zYdH4oynX/9PS4YkiP50dt5WCa7/L82aRlY7dQqQ9qyffwBsstxoexBPRGQyBaLEjh+pOUvj9AxfK6el2DqWCOA63UtyHHtePWuGlAmfzqqRUerX4bPeWJ46aWb/zCqCro+JKKyaG1ODwKiWV2p1gAWHZZy6p6nrY1Psu4jDAMQXEFTuBFrrWqOLh8OPRyQCvrLrm4JV6G65qM0S/7DOWvgHs5Mbp1AvTQNevbXp9lOenZHzgVkfMNUbXRSKwtb/Tm/Gi86YW7i6T1X4ivt7VE8mBWmtSGQTQaRgp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 03:04:16PM +0200, David Hildenbrand (Arm) wrote:
> On 4/29/26 14:31, Ryan Roberts wrote:
> > On 29/04/2026 13:04, Andrew Morton wrote:
> >> On Wed, 29 Apr 2026 06:33:26 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> >>
> >>>
> >>> I think we should revert the original patch.
> >>>
> >>> The premise is that we can save some allocator calls by requesting
> >>> higher orders and splitting them up into singles. This is a frivolous
> >>> and short-sighted use of a very coveted and expensive resource.
> > 
> > I'm not sure it's that simple. First off, vmalloc has preferred to allocate high
> > order pages for quite a while, it's just that the patch you're referring to
> > makes it try even harder. So reverting the patch doesn't completely revert the
> > behaviour, it just reduces it.
> > 
> > Performance benefits because those high order pages are mapped appropriately in
> > the page table - i.e. 1G PUD, 2M PMD, (or 64K CONTPTE on arm64). So it's not
> > solely about the number of cycles spent in the allocator; the HW is used more
> > efficiently. vmalloc only splits to order-0 for the benefit of the caller,
> > because there are some places that assume they can access each returned struct page.
> > 
> > And all the order-0 pages of the original high order page are freed at the same
> > time, so it's not like we are destroying the contiguous resource; it remains
> > intact for the next user (well, ignoring that some will be freed to the pcpu
> > list - this series solves that wrinkle). I've heard it argued that this approach
> > is actually _better_ for conserving contiguous blocks because it's keeping the
> > lifetime of all the constituent pages bound together and reducing fragmentation.
> > I've never seen any data though...
> 
> Right, that's what Willy has said: allocating+freeing larger blocks, especially
> for unmovable data, reduces fragmentation as a whole. And that theory makes
> sense for me in the context here.

Do we have data confirming that it works out like that?

I think the missing piece is that as long as we still *do* have small
order requests with mixed lifetimes, they will punch holes and cause
fragmentation. Large requests need to clean them up, which is
expensive. You can of course make the argument that it's really the
small requests that are the source of the cost. And I would agree ;)

But adding higher order requests right now surfaces that cost. We've
seen that everytime in real workloads: THP, the large page cache
requests, and now vmalloc. They all increase compaction rates, cause
failures in higher-order network atomics etc.

I do appreciate it's a chicken and egg problem. But I don't think we
can justify regressions from now until there are no more small(er),
fragmenting requests.

So we should still require some form of amortization story when we add
larger requests. It's not accurate to say that they pay for themselves
right now.

And the small cost reduction in the vmalloc alloc path does not offset
the externalities of consuming contiguity, not by a long shot.

