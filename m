Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 744A0CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 14:35:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFD648E0008; Fri, 12 Sep 2025 10:35:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD54A8E0002; Fri, 12 Sep 2025 10:35:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C4038E0008; Fri, 12 Sep 2025 10:35:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 885518E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:35:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 28F5316080B
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 14:35:37 +0000 (UTC)
X-FDA: 83880846714.13.366073C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 41F21160003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 14:35:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bvDvHAON;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757687735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ckjDlliM6xiCnAs/DGKyhXAvuQzEhuF006ocd16nT00=;
	b=gBkINk2d0pEOBnJBci4fw/3SlB0BI5f4IozYec2ByN7hdLzX7qm829CbHk+9dYdvkPN/zv
	A57e0k4S5W8ExTDedlZ730rJCNviH/Aw3aoTe1XqaENQDxMjkqa0YO3+h26v91QGuqgfsU
	7IaVJF8/8SzhXF418OxEuHHvDtszL/E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bvDvHAON;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757687735; a=rsa-sha256;
	cv=none;
	b=Q4UfW/A4MU4B0km7RcC1clyjMKym5y8oIe/eAyzzck6rJJtEmZbjjvWD88/+SCypHgGZz8
	xw7N/JILRnL30zbsc+0zw7YS91/C5UR6RON92nw5veFhEyut/KVGzoi8d4nuktcTB/yMYQ
	c/hT/9RmYV1k7INFis7AoXKnYvI7AUU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 75CAC601FE;
	Fri, 12 Sep 2025 14:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D93C4CEFC;
	Fri, 12 Sep 2025 14:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757687734;
	bh=ZS7rP4uNGEsC6E4oWHILrKqyLsgRXKFtB76mAodhYY8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bvDvHAON2qhhpTtNm4cLZ/qjALTvAXwPoELKCBLQ9osYbWLqELlI9L/W5guiu9ysT
	 Bzu+pALpNnx7Gpx540xIDpm70XTlKzsMhsEcWS5iczEGni5LxIc4Q4Mwc5xFTTN1BY
	 JR9gkD4IRHT1Tr/Wcvnv2TEgnx7DKTvcIoT+IwsypT2ODztwGBSly5SyP8qjjP5dA4
	 RZeVgpjgkgGCG0iZpitwdR96YqEP5DXLwI/zkoG7jbRj6MQJaXE/EXRONJzX1qKacm
	 8KCIK0Tf4RTbv5usJNMHAt+PFnQPXZl9NSR1mNHP5rQDjktKVLteOhSBXSFlekWOMC
	 9QXE+259h65ug==
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfauth.phl.internal (Postfix) with ESMTP id D1459F40067;
	Fri, 12 Sep 2025 10:35:31 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Fri, 12 Sep 2025 10:35:31 -0400
X-ME-Sender: <xms:sy_EaIOFVP8TFbUVTr3M1hLM62MVAOKgDByS_aczWYuKrY66etkvQA>
    <xme:sy_EaMw-CYop6ykTCd7xbwny6NtaPItW2sfRBJsD2AqEeyBakCiyiq9sSD4I2ZrZ8
    0EOX8rSQyNgOwk0O90>
X-ME-Received: <xmr:sy_EaNEE_dt9BsbRhcSnetlFx8viyIF2X-cR9O_4RQejA7BzgjEZNxGcPjXMeg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvleeftdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehieekueevudehvedtvdffkefhueefhfevtdduheehkedthfdtheejveelueffgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeelkedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohepnhhprggthhgvsehrvg
    guhhgrthdrtghomhdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdp
    rhgtphhtthhopehlihhnuhigqdguohgtsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhr
    tghpthhtoheplhhinhhugidqthhrrggtvgdqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhmpdhrtghpthhtohep
    sggrohhlihhnrdifrghngheslhhinhhugidrrghlihgsrggsrgdrtghomhdprhgtphhtth
    hopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:sy_EaAmxvA8o9_BHxY-OQnobzIiZhPsKsPuNtnqReZ5bOGcvwh474g>
    <xmx:sy_EaKp3BAE6_gjy-zS7AYs7Bj7CZV5N_FJtGJNQVJ9t5qw1AikzVA>
    <xmx:sy_EaDLqBIhr9fE2udYB0c4LPnib3YjCh9yEomGSqm0hV0dg8fzlNQ>
    <xmx:sy_EaAVLrTry_swTdUTik2eWBdy0SXF2Of3dstHY8M8jzbt4H_u2oQ>
    <xmx:sy_EaIpOoTWlPsROLlgNbu1iSSSKPIivBreFLf3igkQmOpWorIzzL6ol>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 12 Sep 2025 10:35:30 -0400 (EDT)
Date: Fri, 12 Sep 2025 15:35:28 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Nico Pache <npache@redhat.com>, linux-mm@kvack.org,
 	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, 	ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
 corbet@lwn.net, 	rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, 	akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 	wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, 	vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
 	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
 dave.hansen@linux.intel.com, 	jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, 	zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 	rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 	lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 	pfalcato@suse.de
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
Message-ID: <rapl4xr55zv2nq3jh5ulk4wvfyxa2kmbnnb4uram6q43y4cbwn@dv5m52ocyqne>
References: <20250912032810.197475-1-npache@redhat.com>
 <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <43f42d9d-f814-4b54-91a6-3073f7c7cedf@redhat.com>
 <ab8c2e03-53fb-402c-a674-c2c6ab11f54e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab8c2e03-53fb-402c-a674-c2c6ab11f54e@redhat.com>
X-Rspamd-Queue-Id: 41F21160003
X-Stat-Signature: 7iie78y4jbef1wf4p3wwca8utja1wb5x
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757687735-258425
X-HE-Meta: U2FsdGVkX1+aQYiKFUhyTYt0JDZMeXL4lNnbJ9I1+d2+XxrE5p+rLwQsH9+Ic5Mzun6FI9wBO0+FkuXJgZPDFmhtnApgEwD/UmY9HrB3GnHgKop9MqX7G1NT7+ccI7K15AN3keRn6soxcVaMJUjk3P+4swzAy93KzWT4XY5OsvhV4dMahSGepu2aUsvEmQeNTFJpRXA31bAxqq+ZWmr8Z2NeFDPQ0BP1mAPB4RJLF5Vbj1U2jh5Vby6bOagqhJvTBO+NjWVGuxxjsocPjCMUd9pOl+0jGqsp/R1g2OdjCbwHbJAA6nKrDUtZyd/HznBMKCcDm9Zg5dXi1fhiuQK7LGO0u+z2lsdtLqNK7ZFnkefzDB/kis7LGH6PNcNXJLhoGEdWx8Q19hvInAZHQ8w9pDmFi0i9mGYW7TLwnUFVAQbOpgHMUidWD1XkJpWQnxfgBArBo4wBlu1yFNUNX8a0Z9MLm35tXedO0qOPA5JviGPihuRBU0xYOa7hO4/k63fw3G9TRY1RwFMmPkZNv3QVO8OY7K6KsxlsC9NGJ0u2CPiHTQzuQmjiapBQeGdYofmdgix3nNDE1tfOrMRLpljCeyPIhpoJjHhEMe8TKtGFXW/p40+p+UFs6wUkX8TQkMN98rN3Yd7nHrA7ePgTHHjvpiK9D7xu/vyQXueNzlroNe9BIbcehLQd+Gp+wTvU/7pNS1iYPQWdsH633ttfeW/sWUHC1YpZQZ2BH0f5q6il3kVI6LmgN02vgD3KsBXL9ZlT1xuZL0nIsYo4C1SuDTBVwPySqLB5W40nh2xc4qzmBbDmTwc+qOzQYmoEJpxdWhjdmMBxoZWwSQdQW+rl6gdRsKQmrHHC+RMC8EeiGclbeKh4PKFVk4omygoqdNEnlmoBsWfwo3ME+CTjnDGpfM2cXEy99HdO2Mr/wnwLTMpRVc8ozKtMm91ahD8WVR+C2/KvdVgnqVsCQX63mAj1yt1
 gHA66S3Y
 ro1gQnMPdmBouPZGa2przy78Nb+A4JQyvWW2lkCNT0aAqwirugeio2zXrOFDrygR4MCLLaWvUbqtTW9al/OfBYQkdyBj6GeerD+ghu+CW8jzRxUbQAnBZhPWY1BX/iRQFoXxZvOjdmIxGDe6jGwh8fvbfO52ENDAmV4dlTbBhl0WpHSXuW6WTpmTv7FovxkQqbGG9XPKPcp1+dWEhPpc8FD/RqBFn60LDhAralIg0DLJ6VpL2TuWD9YUJDJ4MhhHnHPLJ8RCpqrGHnPdCVoRZdvf+YFTRRI5qIiAE4cQwNQfLhoTZe+/FXGHvBvCrOEbZPzgU6HOWEkvT/IuUcNBJKAjn9KLD+CiKH3Zb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 04:28:09PM +0200, David Hildenbrand wrote:
> On 12.09.25 15:47, David Hildenbrand wrote:
> > On 12.09.25 14:19, Kiryl Shutsemau wrote:
> > > On Thu, Sep 11, 2025 at 09:27:55PM -0600, Nico Pache wrote:
> > > > The following series provides khugepaged with the capability to collapse
> > > > anonymous memory regions to mTHPs.
> > > > 
> > > > To achieve this we generalize the khugepaged functions to no longer depend
> > > > on PMD_ORDER. Then during the PMD scan, we use a bitmap to track individual
> > > > pages that are occupied (!none/zero). After the PMD scan is done, we do
> > > > binary recursion on the bitmap to find the optimal mTHP sizes for the PMD
> > > > range. The restriction on max_ptes_none is removed during the scan, to make
> > > > sure we account for the whole PMD range. When no mTHP size is enabled, the
> > > > legacy behavior of khugepaged is maintained. max_ptes_none will be scaled
> > > > by the attempted collapse order to determine how full a mTHP must be to be
> > > > eligible for the collapse to occur. If a mTHP collapse is attempted, but
> > > > contains swapped out, or shared pages, we don't perform the collapse. It is
> > > > now also possible to collapse to mTHPs without requiring the PMD THP size
> > > > to be enabled.
> > > > 
> > > > When enabling (m)THP sizes, if max_ptes_none >= HPAGE_PMD_NR/2 (255 on
> > > > 4K page size), it will be automatically capped to HPAGE_PMD_NR/2 - 1 for
> > > > mTHP collapses to prevent collapse "creep" behavior. This prevents
> > > > constantly promoting mTHPs to the next available size, which would occur
> > > > because a collapse introduces more non-zero pages that would satisfy the
> > > > promotion condition on subsequent scans.
> > > 
> > > Hm. Maybe instead of capping at HPAGE_PMD_NR/2 - 1 we can count
> > > all-zeros 4k as none_or_zero? It mirrors the logic of shrinker.
> > 
> > BTW, I thought further about this and I agree: if we count zero-filled
> > pages towards none_or_zero one we can avoid the "creep" problem.
> > 
> > The scanning-for-zero part is rather nasty, though.
> 
> Aaand, thinking again from the other direction, this would mean that just
> because pages became zero after some time that we would no longer collapse
> because none_or_zero would then be higher. Hm ....
> 
> How I hate all of this so very very much :)

This is not new. Shrinker has the same problem: it cannot distinguish
between hot 4k that happened to be zero from the 4k that is there just
because of we faulted in 2M a time.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

