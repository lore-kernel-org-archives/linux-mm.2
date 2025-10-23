Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C79A5CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 10:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C0978E000E; Thu, 23 Oct 2025 06:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 071B38E0002; Thu, 23 Oct 2025 06:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1D38E000E; Thu, 23 Oct 2025 06:35:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D2B888E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 06:35:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 72AA44913A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 10:35:14 +0000 (UTC)
X-FDA: 84029021748.19.6C43928
Received: from flow-b4-smtp.messagingengine.com (flow-b4-smtp.messagingengine.com [202.12.124.139])
	by imf27.hostedemail.com (Postfix) with ESMTP id A05D04000E
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 10:35:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="Y 2TNMu1";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=bkGTLclj;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761215712; a=rsa-sha256;
	cv=none;
	b=L4lZyKYQUugq/nrDRHXP/azJbXSXHLVL1K5uG9XlgFb55TVdTJF+ZoZKcpXTN+tPgHPt27
	g5wICSsokjenTTFrMVjkBPeCm67LQhw3s7CIPRgD+UYBu+Br925akHcT3iNWTt9JF/S2Zx
	AsQ55ns1kMKRZPwaRQZOX149XYmMjRo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="Y 2TNMu1";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=bkGTLclj;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761215712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bYmq2ugvpkpXSrVwqUBpprPYISDR+qbKwRgzp5kUFsU=;
	b=lP7lUxoZcZ7VGoyvQvYIFmsHmCR0xWYZp2bRv7lhE4Y9SJMlR6ICzolhsR7ulKiwgOEfEu
	251N7he4L9ak+G269LcrVYw3bHYWlQPoenF+Atx6t2VCTAJV/9FAgVS5JXXYkcf+BFxqg+
	E0BOyf5JpGLVTn3L3ysgp996YUi+v04=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id B3F211300A8F;
	Thu, 23 Oct 2025 06:35:10 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 23 Oct 2025 06:35:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761215710; x=
	1761222910; bh=bYmq2ugvpkpXSrVwqUBpprPYISDR+qbKwRgzp5kUFsU=; b=Y
	2TNMu1R/Hmaxixa7EY9KFKJn7u9r7hsO+JQ5asjhvqpcB46WSh3NNlgph4rDacf6
	t8KM0o7BdHtBNDPB9oZthNfJ6FPpGAz82uOtOiGrqJnjCC6LcsPXjJGbQ/jfg1OG
	H68EfJeTwjAx06MJoqNTply+A5OgftFdEDieXOG7xbiYYdzmWyU7rKPrEclNf6XG
	+9e449UpGPkJMs0ybRbPEmAgdyeiiVPKJ32HH9jXnQ93cLfa6MHBnH4PbP2gFTca
	TYOC8wdC7nwtqGYnfwtNaE2IymNCC3sG17+zTUELRe3CXMGNQnejWEB7WcNwQtV4
	wkGaTMqOy1AO7ZGG9wHlA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1761215710; x=1761222910; bh=bYmq2ugvpkpXSrVwqUBpprPYISDR+qbKwRg
	zp5kUFsU=; b=bkGTLcljrPmX4vdyZOKSSNoYkIcFwE89tt6AJEXq6lmrM6pm+8m
	FHY+XlvDM/lU+lgNd+u/lBo46MuFbFVua907mZFqRTI0EFJO+GWVwn5QY5LXQa8P
	99tqgFzZn3vFhkCPnveTuhgRwg55IwlNxox7iKuh5WyeFdTjgvxoY+iPo5MlV0lx
	kl1znRafVbu6k5KHQBMhavXxq7tYpJn3Gpd6B/IJ8o5hrD+/YvGHBQyliZTO1rGh
	4P1ZV7czuMwqgQv0G6eQwJShWQsiB2M5KzI3oPhwU1iYF0lkLEC/oaUT6nFLrkXq
	gKpx2sM3pJc74HKyEY7XX1/4wjRq9ch+13w==
X-ME-Sender: <xms:3QT6aDgv3Xg8jV1cRGYBv2byRNBlDfxiZNTnYKqRsj2026byvJzSeA>
    <xme:3QT6aBiHAAgUxITThuMDB2_jMTdSUBo4qN1ZLu_WvxQ5UBHpryXYun8R1rvzo4yca
    ebRlfi_-zuHMBT4UHGjS0tFyY11c9Y_nQpmoFJcg4lIva1jvx22wQs>
X-ME-Received: <xmr:3QT6aLuj0fAmu5U_e8ZOKYsXnJnyfFmOvNEMqGDocytIYTTyoHV-8e1O57wWxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddugeeivdefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeeg
    iedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepuggrvhhiugesfhhrohhmohhrsg
    hithdrtghomhdprhgtphhtthhopehjrggtkhesshhushgvrdgtiidprhgtphhtthhopegr
    khhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvh
    hiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohephhhughhhugesghhoohhglhgvrdgt
    ohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtth
    hopehvihhrohesiigvnhhivhdrlhhinhhugidrohhrghdruhhkpdhrtghpthhtohepsghr
    rghunhgvrheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhorhgvnhiiohdrshhtoh
    grkhgvshesohhrrggtlhgvrdgtohhm
X-ME-Proxy: <xmx:3QT6aCTLGULRLFLKch7HbZR4TKR9zTiyjLngH7649pjWnJ2k1Agl2Q>
    <xmx:3QT6aEEQLhacD3wRELmrGgrBxzKQU8aJK1m0APZ5MhYVX7LI870guw>
    <xmx:3QT6aEiX_vBkQ4dzeoH32eZgFFhm5d_pjAhMCiEJDDsHDgS-8a2ZHw>
    <xmx:3QT6aCgQEOejXwzF0EJlnh_6rx8N6289dCUVp_oSVPIRU-Ti6ao_kA>
    <xmx:3gT6aGrl_OOIC_ym-3o_L0rAdx9CNBYWTKFTHCmpPaqJKiK-E8avBF_A>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Oct 2025 06:35:08 -0400 (EDT)
Date: Thu, 23 Oct 2025 11:35:06 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 0/2] Large folios vs. SIGBUS semantics
Message-ID: <lv74va34dbeyacenvdzulfudgsvntuu2u7jutpjjysfl42kkro@vvkzmctnilnp>
References: <20251020163054.1063646-1-kirill@shutemov.name>
 <aPbFgnW1ewPzpBGz@dread.disaster.area>
 <d7s4dpxtfwf2kdp4zd7szy22lxrhdjilxrsrtpm7ckzsnosdmo@bq43jwx7omq3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7s4dpxtfwf2kdp4zd7szy22lxrhdjilxrsrtpm7ckzsnosdmo@bq43jwx7omq3>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A05D04000E
X-Stat-Signature: 5gawqt6ac3e5hjrwidmhgpj5o7yjhk6z
X-HE-Tag: 1761215712-907632
X-HE-Meta: U2FsdGVkX1/4A88ppVDQSlF3PRk+P0UaVjHrX6zjNWBjLEk3W5xjESzcR0MMG9Vuqa03JKA1Wz3k0GdwxRQ3qlyp1htV/x6/9NWoutiJP7yV5/gET5Tbux1fzHNyBL1gWUlOMatvCx8JoyX0/dESBV7bCSl/MZr7tCUCM4MEunbTOYroNDv3Tyes+u7jsGZWt6EpyQgRSuoYey/3Vofn6xuZErG/vdMtxdhw4lDPiO2MUu4IB5FPAO9MjF99S1mazgc4Mcma3etJaevpAutNoqCS70kylPrtvLjRGtPrF0ep/EfMnJZvgvdrJAb0gFY4DzfqAHfv00ICWfbmYxvet7c1U4TnhSBIhyzoJWRhfVphHA+kTfx2fMyHKzfia1mGwdMomezxfwdUL+1xnHy2p9Tbyum+FnPMNSIwTyc/9EE5nwkNsAxtZz+/o+Hz/HZXGp9HLlTM4pCP6Kj0MBezWaCPxt7xgTnx7/naJH1YxWxXFvb8AmjDPGrceQKccR8jfv++hkMUO2x6e65qLZLFletJQhxSQoqpmJGs3y8Abi31XVXKOhI7QT0DjjDdXPz5vINJN0gds4FrYoEH7mDs7j9QezXRPn/8pf3Uj3MciHlQjhDKFlJwU6B8qivBJX2++8W2jhzxRQ5BMeOX4R3ae29ly0wcn89EkRFbI10Gvmbqe2Nh2Oy6hmu6mQ3e6T0R404l3xAZQKw/L4zr7IN0XR4cYqKiYN24p2Y8LPsmCxfd43eRvbullLp3hOC2OSMzKQVKZqUo0xwbLI8G031FscR2vIn4DwpTwtGSOakm5UhZijAQu+Nsd8VIWQ85TwT2hYzDPagr7P1f5fsDxFCPdSNAxpQXQcQa0sDe6aKx9xlz2KEz5mtwzRkxxz/R7FORrKs0oJgR6NGtS2lAK07/13U+oQ63JpkKXNg2dgr5YNZmUYxJPjsZMJJTNNRoAVTyrUTOvYBxxx2gEZJjeQ4
 GyuASBCJ
 GFoD3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 07:16:33AM +0100, Kiryl Shutsemau wrote:
> On Tue, Oct 21, 2025 at 10:28:02AM +1100, Dave Chinner wrote:
> > In critical paths like truncate, correctness and safety come first.
> > Performance is only a secondary consideration.  The overlap of
> > mmap() and truncate() is an area where we have had many, many bugs
> > and, at minimum, the current POSIX behaviour largely shields us from
> > serious stale data exposure events when those bugs (inevitably)
> > occur.
> 
> How do you prevent writes via GUP racing with truncate()?
> 
> Something like this:
> 
> 	CPU0				CPU1
> fd = open("file")
> p = mmap(fd)
> whatever_syscall(p)
>   get_user_pages(p, &page)
>   				truncate("file");
>   <write to page>
>   put_page(page);
> 
> The GUP can pin a page in the middle of a large folio well beyond the
> truncation point. The folio will not be split on truncation due to the
> elevated pin.
> 
> I don't think this issue can be fundamentally fixed as long as we allow
> GUP for file-backed memory.
> 
> If the filesystem side cannot handle a non-zeroed tail of a large folio,
> this SIGBUS semantics only hides the issue instead of addressing it.
> 
> And the race above does not seem to be far-fetched to me.

Any comments?

Jan, I remember you worked a lot on making GUP semantics sanish for file
pages. Any clues if I imagine a problem here?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

