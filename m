Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9B1DCAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:39:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 136F26B0028; Fri, 12 Sep 2025 11:39:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 107EE6B002A; Fri, 12 Sep 2025 11:39:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01D056B00A4; Fri, 12 Sep 2025 11:39:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8E646B0028
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:39:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 941301DF966
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:39:07 +0000 (UTC)
X-FDA: 83881006734.30.0C9E363
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7E77B14000C
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:39:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d78ruUZV;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757691545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4FdOWgPfPKGFXHEB+F41uMQJIdUeaBXwJyF+RF3bPRI=;
	b=j+b3PDGl8CTlEYXLQuZaKWGC48jMcwnHaCGK3qhOCTXKxxvN4tot00VxbKjuDh3QQeGOBu
	ZD/OY48DfwXIYBGVO+uqHCpZhV9B80I2mXQXV2k7X4PYU7fXEtX1IX7jrTxjIneVAOE07J
	7z/ButRylRB0qFdivkB3TBacrcUZiVo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757691545; a=rsa-sha256;
	cv=none;
	b=ACAhausD/v1hirvUdm6gEmR2K3p98kNA60Tz6Qqz9xkr6epGNhhP0A01Z4lzhx1z722QK7
	UUDzdAzo3N3pn71wCg3jepFdVeJq7X0eHqLkbh8DoWGRztOcCnzCaf8FJkbwHl/Zg6DzW+
	qHHMx8vsGUYwQAfdzf9UNS9I1CO675g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d78ruUZV;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B7DC44915;
	Fri, 12 Sep 2025 15:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC001C4CEF4;
	Fri, 12 Sep 2025 15:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757691544;
	bh=MqWqEVkiavY1Oa+6UsdYHS5X7LREs3JN+4OZa8gJU1s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d78ruUZVhOjeYkF1ayZ7BTafwkKl5MtnhcQA3vyg9+Z/zGFyr6Cv6IY/37xaGE5KA
	 E2UkLzMuS2a6hOoIETtRjkX0Sy31SXpDxIFcZTIgSjZBQB/qphjykl+uv4LHXYsnvt
	 HRRW8MD6nr6f02XVFgHfXUIkddJ8xL8bqKfZQ9iLdyBF0D7OCELuwFLYYot1h6C+aB
	 ELsGSe8jzThCmeUPoqwIoY8JRjIwnXNcX3UUJt/3eYy+0ph3CEVbQzGkwKg5xaokRV
	 nX5ZLdmIWk1p6q3fNYntpdLe+DsKzkpRGJSZdX1pzBYXDZO3Y8MlHwsgEZM+t0iB4F
	 2P163fhRC1y1Q==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id E95DDF40068;
	Fri, 12 Sep 2025 11:39:01 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 12 Sep 2025 11:39:01 -0400
X-ME-Sender: <xms:lT7EaHmd6YseUp8_myHE6QI5XITPd40RhUlV69wM0VdVN1w-u43ghA>
    <xme:lT7EaHrCEItqTX1gDappaQb9WOxjSOCiBzqu9SDmnA6QuXyW-v6mcJPa4yU7sHpza
    iF3vywUwrDTXhY7LtI>
X-ME-Received: <xmr:lT7EaP5HVr1QBClyORn4Xn1cbEHmjCW3UzoAcg1kG90YM1IHJo9VktilHoK9Mw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvleegfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehieekueevudehvedtvdffkefhueefhfevtdduheehkedthfdtheejveelueffgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeelkedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepphhfrghltggrthhosehsuhhsvgdruggvpdhrtghpthhtohepuggrvhhiugesrhgvug
    hhrghtrdgtohhmpdhrtghpthhtohephhgrnhhnvghssegtmhhpgigthhhgrdhorhhgpdhr
    tghpthhtohepnhhprggthhgvsehrvgguhhgrthdrtghomhdprhgtphhtthhopehlihhnuh
    igqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopehlihhnuhigqdguohgtsehvghgv
    rhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvgh
    gvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqthhrrggtvgdqkhgv
    rhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepiihihiesnhhvih
    guihgrrdgtohhm
X-ME-Proxy: <xmx:lT7EaPvb5YgSO-BnFXc5GNkonXqhrxEzv9gl9ZO5OcMhkpTc8h9W2w>
    <xmx:lT7EaK9myZsXSE11OMxOm9GP9D8cWKgR7IF0PS-QeUE18mBYBBh7tA>
    <xmx:lT7EaD6aalZPZm7Wy-Nn5NxqjbeTxzw5DSTmNlaytsOtiXB9WUadVw>
    <xmx:lT7EaM8_9ZA0Vty_GXNotMrr7XBmMeXwptz08uyaQT13YdpSdBFJYA>
    <xmx:lT7EaD-QWgKjY6rpuxP47U04xMwQlWW3OD-igRLAeIY6Jry9BD2K-Qr5>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 12 Sep 2025 11:39:01 -0400 (EDT)
Date: Fri, 12 Sep 2025 16:38:59 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@redhat.com>,
 	Johannes Weiner <hannes@cmpxchg.org>, Nico Pache <npache@redhat.com>,
 linux-mm@kvack.org, 	linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, 	Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
 	rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, 	akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 	wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, 	vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
 	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
 dave.hansen@linux.intel.com, 	jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, 	zokeefe@google.com,
 rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org,
 	hughd@google.com, richard.weiyang@gmail.com, lance.yang@linux.dev,
 vbabka@suse.cz, 	rppt@kernel.org, jannh@google.com
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
Message-ID: <k54teuep6r63gbgivpka32tk47zvzmy5thik2mekl5xpycvead@fth2lv4kuicg>
References: <20250912032810.197475-1-npache@redhat.com>
 <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
 <20250912133701.GA802874@cmpxchg.org>
 <da251159-b39f-467b-a4e3-676aa761c0e8@redhat.com>
 <hcpxpo3xpqcppxlxhmyxkqkqnu4syohhkt5oeyh7qse7kvuwiw@qbhiubf2ubtm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hcpxpo3xpqcppxlxhmyxkqkqnu4syohhkt5oeyh7qse7kvuwiw@qbhiubf2ubtm>
X-Rspamd-Queue-Id: 7E77B14000C
X-Stat-Signature: uh6ucgeppgrxwo4s1kax5f3bqb599w5u
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757691545-371602
X-HE-Meta: U2FsdGVkX19qK1+pqoRYckiVBZ9WxOC7r7FP+xrOHhkW8XZKvV/qUyzriWaRybHH0Ra0slH0oBXpGqHtGp552IdhUesv+LjETTUa6TI9of5FYdwpjvh8qPNZzQ2JbeThc8/IZulJxjJ61ulk9GmZEAvyZMZg7qCyH5Xafsr3i/eYCXDyvUqkP3FiV/O9Wf0zwqdzpgZ/lJYuJ9DwiErnCVc47WMX7RP3SGDTxuHYlIDNf7fTzSJCvzm/x4p6VwotFBiYvMbvaGbaIB92PzYcI5UqBQTCaMs4pXIf2Qg4xFg0CRq+hPp6HaS3A5hYlENP0C5GIoy/WHj2cl0dScFqFGIoxagk2ahf9rthOS1k6c/Li10xgS89VUqQeePbgui7YjJJXkNjZWjXer1wZuW/Tw+Y0j4HM7UA/2AI9mJDdDVPx2uDwC28S1CDlzwFsqsTUoj0GIKMTfvp5WyH0j6ofjChDkx0vwvpNOD1QPA9p7J3ItaiNtOUQkBI+zSvobueZqCMqd+51084fpHE6rrWbFqfIKiEJV2y2i1/3xYty5NWeDCSFbJEtcjdEHwFAnvnvEfI2iiUuraIHxf+l7KPl948ClcddWjzYirlIlHjAa+qX1jcqd9vqDO7TcmQnj7eY3PebOjfPjMDKpDGFfWKE1zkmWASF3kN9y2Ci945beb9naf1VpD4ADStwApxk4iCVWLw+8DpmgDKE46a+zskT8VDx1Q7PzAMYyiPEFxnMU8PaREJXkVe4oPb99PHZXoyXR13qjmi5tmVL6BrNgaIsVG1e6qU7W9NwnklBWqYEXa3XAP/OvDBh/M/zox+EsiePC+WoA0HZZK6LdnKsj/Ny2ZfHXVRPWBXZZ+2dWWct36chzUGH0A2Q4mM0udAuaeO43uU0mXqLhy1d6i9YYGrBDqTJrNglrCZFze9+AwBKNj3E1JRDRXSGfE4v2qBmUsLWKuGV1GH8sBhp3aByRw
 jlOpXIeN
 fg2cUxeXQyfYERquRr+lVT3h/39KEH56Py/ciKzWq1+XHKp+nndWoAIuEH9r8duReiAXVuncuIuNeur+X4YE9/SxnUo6PTagD0eByO7w4ucpsi61qltsXccOveEgD8ZEW7f4+VjrfwdDMpxwOyxkY2i5ZUnnlQ8cm0Id+fyEDm9DUXGtWlMXOxTnvSo4QRu7okmCxTyAxLuZJi3Z6hquidME25Ol82D821Y8KtOrn7kAxUYCABAqsmSsQhRQ8Hz6CzQlF68sdfyLnPesFRKbcidvcLfvZ7D6O+CSfKpMJF5AlSR1aHS6ZIk+oRTu0LXbr9nxoHbJUjcqEOcofWNeO/9w/COtGyROb80zJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 04:15:23PM +0100, Pedro Falcato wrote:
> On Fri, Sep 12, 2025 at 03:46:36PM +0200, David Hildenbrand wrote:
> > On 12.09.25 15:37, Johannes Weiner wrote:
> > > On Fri, Sep 12, 2025 at 02:25:31PM +0200, David Hildenbrand wrote:
> > > > On 12.09.25 14:19, Kiryl Shutsemau wrote:
> > > > > On Thu, Sep 11, 2025 at 09:27:55PM -0600, Nico Pache wrote:
> > > > > > The following series provides khugepaged with the capability to collapse
> > > > > > anonymous memory regions to mTHPs.
> > > > > > 
> > > > > > To achieve this we generalize the khugepaged functions to no longer depend
> > > > > > on PMD_ORDER. Then during the PMD scan, we use a bitmap to track individual
> > > > > > pages that are occupied (!none/zero). After the PMD scan is done, we do
> > > > > > binary recursion on the bitmap to find the optimal mTHP sizes for the PMD
> > > > > > range. The restriction on max_ptes_none is removed during the scan, to make
> > > > > > sure we account for the whole PMD range. When no mTHP size is enabled, the
> > > > > > legacy behavior of khugepaged is maintained. max_ptes_none will be scaled
> > > > > > by the attempted collapse order to determine how full a mTHP must be to be
> > > > > > eligible for the collapse to occur. If a mTHP collapse is attempted, but
> > > > > > contains swapped out, or shared pages, we don't perform the collapse. It is
> > > > > > now also possible to collapse to mTHPs without requiring the PMD THP size
> > > > > > to be enabled.
> > > > > > 
> > > > > > When enabling (m)THP sizes, if max_ptes_none >= HPAGE_PMD_NR/2 (255 on
> > > > > > 4K page size), it will be automatically capped to HPAGE_PMD_NR/2 - 1 for
> > > > > > mTHP collapses to prevent collapse "creep" behavior. This prevents
> > > > > > constantly promoting mTHPs to the next available size, which would occur
> > > > > > because a collapse introduces more non-zero pages that would satisfy the
> > > > > > promotion condition on subsequent scans.
> > > > > 
> > > > > Hm. Maybe instead of capping at HPAGE_PMD_NR/2 - 1 we can count
> > > > > all-zeros 4k as none_or_zero? It mirrors the logic of shrinker.
> > > > > 
> > > > 
> > > > I am all for not adding any more ugliness on top of all the ugliness we
> > > > added in the past.
> > > > 
> > > > I will soon propose deprecating that parameter in favor of something
> > > > that makes a bit more sense.
> > > > 
> > > > In essence, we'll likely have an "eagerness" parameter that ranges from
> > > > 0 to 10. 10 is essentially "always collapse" and 0 "never collapse if
> > > > not all is populated".
> > > > 
> > > > In between we will have more flexibility on how to set these values.
> > > > 
> > > > Likely 9 will be around 50% to not even motivate the user to set
> > > > something that does not make sense (creep).
> > > 
> > > One observation we've had from production experiments is that the
> > > optimal number here isn't static. If you have plenty of memory, then
> > > even very sparse THPs are beneficial.
> > 
> > Exactly.
> > 
> > And willy suggested something like "eagerness" similar to "swapinness" that
> > gives us more flexibility when implementing it, including dynamically
> > adjusting the values in the future.
> >
> 
> Ideally we would be able to also apply this to the page faulting paths.
> In many cases, there's no good reason to create a THP on the first fault...
> 
> > > 
> > > An extreme example: if all your THPs have 2/512 pages populated,
> > > that's still cutting TLB pressure in half!
> > 
> > IIRC, you create more pressure on the huge entries, where you might have
> > less TLB entries :) But yes, there can be cases where it is beneficial, if
> > there is absolutely no memory pressure.
> >
> 
> Correct, but it depends on the microarchitecture. For modern x86_64 AMD, it
> happens that the L1 TLB entries are shared between 4K/2M/1G. This was not
> (is not?) the case for Intel, where e.g back on kabylake, you had separate
> entries for 4K/2MB/1GB.

On Intel secondary TLB is shared between 4k and 2M. L2 TLB for 1G is
separate.

> Maybe in the Great Glorious Future (how many of those do we have?!) it would
> be a good idea to take this kinds of things into account. Just because we can
> map a THP, doesn't mean we should.
> 
> Shower thought: it might be in these cases especially where the FreeBSD
> reservation system comes in handy - best effort allocating a THP, but not
> actually mapping it as such until you really _know_ it is hot - and until
> then, memory reclaim can just break your THP down if it really needs to.

This is just silly. All downsides without benefit until maybe later. And
for short-lived processes the "later" never comes.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

