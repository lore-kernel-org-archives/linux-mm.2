Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F6FFEC1EB2
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 13:50:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C17F6B0005; Thu,  5 Feb 2026 08:50:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9997A6B0092; Thu,  5 Feb 2026 08:50:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A4D46B0093; Thu,  5 Feb 2026 08:50:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78A146B0005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:50:32 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1AE775936A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:50:32 +0000 (UTC)
X-FDA: 84410537904.06.1538A54
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id F3370A000F
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:50:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="nZjt/qf9";
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770299430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hBqoL9eXorWBSoq5RkUfOmJuikg1UPOT8WjMTgWgkGc=;
	b=RCVH6BgAs1bDfjkLmBOf9pxKkC+ERQw8fNhM3Rljfa/vqDUJy4Fm3bJn4pRXfcvKk/doXM
	z2w+pVylgx4CSelN4/T3NJ88UmjolUGZbtbsURhewL3Bmwjwp85hDH+UtPvMklF//T7XPa
	mahjy2poKTwH5hLeawQijm0X+2z2ZX4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="nZjt/qf9";
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770299430; a=rsa-sha256;
	cv=none;
	b=zeIFJs2W8sR8vzGsIQb4FFOAF7q1lqnnkgOb59vi0PsjnBLpzDt/4s+W/71yW24RfLLmon
	/H/WkGANLGCeCj8Wbbp32kjwSWJwoH61zM+izeunRgmscpDSrdv738np2yjvIfZQUi75GW
	PKiKsjZ6L2CUMQ/cwAwnPhOKx9FTFOc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2AA2260122;
	Thu,  5 Feb 2026 13:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D13C4CEF7;
	Thu,  5 Feb 2026 13:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770299428;
	bh=3TY2LvtZnrCiQseYdsb0tgxnCGw9BQjaOFOmpcNjY34=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nZjt/qf9VJzwFHOgqySxuAcrbSQuBulW3qm/ouJrbXrHLZ8x9pa9nwMgX+3jZo6mU
	 N4ifhi7PUe9zhliFzPLyXsxoVeLSXF0e6ob9+MuKAQ7Jn5iQvx59m8BbNQ/6fYZIVm
	 RfSeKPKJpsbdoiBt8Jne2ISM9DDP5cLeWA++u6OsBmvof7sYwh2DvltqJMX0/AGT7/
	 FyaXn8CIRNnAgm3tAUjjNoO6gUIwFlX/CNrNgoDO7hTBW0CJ3kXk4QORwkTGwf6LGu
	 v/sYAB0S2Keapjr6rAebNdO7eGUqPtTHQEhj33GWQpAsdidUkrLHNZg7J2BH4rWzLf
	 y7+WUGfjW0+ng==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 0D54DF40068;
	Thu,  5 Feb 2026 08:50:27 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 05 Feb 2026 08:50:27 -0500
X-ME-Sender: <xms:IqCEaZf6StkWfOqu8wFSOZeK9vXsBWrdIeava6LuaFgh6MhYGi-y-w>
    <xme:IqCEaQ5qls25rtsGHqFrm2Ttf2ZPHFXPplBaTUa4iYpfpLkNRd7SjVQfMZkBxqdaP
    5jbZJcwMo_ziIilnQwc0Y2dZ5ffYmh-ZBxRxDMc4_GMbK_-ACh8Ncw>
X-ME-Received: <xmr:IqCEaZebtFCUBddCzka2qZR1s7YPqIztazpkzNjE7oPAi1YH8moJgmlpqubZNA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddukeehgeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepheegpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinh
    hugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepmhhutghhuhhnrdhsohhn
    gheslhhinhhugidruggvvhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:IqCEaXAGHKZMBJS6DUsJ98T7WyuRMoEUVJhkNCQ9KG1MejXV8BfpSw>
    <xmx:I6CEaVHlKYRyqwTh2vTVJYQ9F735Nv0bH_bNCRQM-oWLhwZ-9a_fqg>
    <xmx:I6CEafjBkfUHcOHA-WfHtJvjD79HzFhOUFGs7C8chXL6k23xFLRu_A>
    <xmx:I6CEaXs9Qf8A_cpGbYT3ZbCh3Xs_yGK5n3wyq6EE5VNQ2zEc4GNTkw>
    <xmx:I6CEaV-n2W8zWDLDGHDrciU6x5-ShBKOSo7gnftoJrzCpdjBdgcLcSiJ>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Feb 2026 08:50:25 -0500 (EST)
Date: Thu, 5 Feb 2026 13:50:18 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>, 
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
Subject: Re: [PATCHv6 05/17] riscv/mm: Align vmemmap to maximal folio size
Message-ID: <aYSe0TAIzxJ9i1Wy@thinkstation>
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-6-kas@kernel.org>
 <1b80b189-b549-40ba-800c-8037ce12b081@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b80b189-b549-40ba-800c-8037ce12b081@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F3370A000F
X-Stat-Signature: xmphiocr5f5e3d16sjz43d7w6d5spfck
X-Rspam-User: 
X-HE-Tag: 1770299429-263278
X-HE-Meta: U2FsdGVkX18FqUg5e/KR+6r6FgV9pQlUtTZu4xmG4lnfnUrAD5glwHMJnlSuQlo3cJEqQXjLGB4O4xlA888EouVbsmlbPosT9CQJ0DJ3DUrgU3iNIuSupZoD0aNVgkk5jBgr5rf/bppkmig+z6Feulcfv/8PAguPv7w7IcubWnO91rMhRt8mg2Hgmg+fwmuT5PjP5pS2cmhnvMkSr5RHBezXpyHakcdKyX7Ly8ITUKBbWJJU1+dJbranNhv+sPb4ZTega1Hxqq7p2EsaxYGBmIVjdPbkQxFINnd1kI5fRAoV/w87dAdl/jzhU07KWJ2kQmRApXRvpqQ8fuRDgj/dvUl+cS+AJdqaGZjunM7ObqeLOExdiT+sMFW1DCPHYWZeIzfgf3WeC8TyBFFAPRBg1vMI+vbwIslSdqf7phMl9wd2uwfk99jciRljorMPtqaW6jkLvXLnWS8dG+Imdpa6RjL4dJfmQ8M8aw+KG3oNyPWzigZCOntZuEDs1QIM8VyTBDQg8rrgJyEoyvMzDZZqY/H9pXe+RezHJE7dnsySsKeeMtt0nKb6QZ2bMpUt93WRy3jwFuIYrbrejVxN0kWpiSFU8owhP/9mMjjDztnTPGwLnl+VZZQRHF6tbGag/cwD0+PdifgkKRMshGkADAzjxwuH6vmHDJojvZqywrSwC2igjgWXYt6heTQyR+zsIfO0dX9mR2xtUAgjjaQ1x5rg71Spl6GGimDSYaJ8JNYdj+JO723ol8KgMSfrNYSHh/hfP5m8WU+5CMuPiySuCTXcuCnyfl34RRjQqcYw8P/4nFtg8+GXd+3bLvqXvqLaOXO6CIroX0b8AAoJd2bcawAXClfC2zZqL5t+gDD02rk9UrUxWlACCsQoWXyeR5XhVG2ypmtiTDtuC7qu22YxsNwtSN7I+O4G3TA8Ugvl5s/QtxKt0rT1bYDq3gGOHZHfgfE4LDVTCKV3aDl1JfRUHk1
 hNFwFFaW
 U4OuNUyxEyQi1uLFk9ra3mvYeeD+XZBgYPmP6HINqAiAJi/xTbGD0jieuDFRY9i5XhWFwqmEzdjVPzAXMpvYIC1Q2Qsm2ykjm5Ddatg3r9JLxmxgy28q3FlPEKqqkLODInG/o9F5eCtRSPKV1tXOKPWYQoksmEbOaIGQvtdkb6YD05Te9SseXx0KSufe3ngM9tLIKiezOsJeI4zLzpL7PLGtPErxYFfy7L30f1EN7sagLloNnCnYwf+4EZR+IucOspeIN1399QbeFeTdH/PFS+uzJcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 04, 2026 at 05:50:23PM +0100, David Hildenbrand (arm) wrote:
> On 2/2/26 16:56, Kiryl Shutsemau wrote:
> > The upcoming change to the HugeTLB vmemmap optimization (HVO) requires
> > struct pages of the head page to be naturally aligned with regard to the
> > folio size.
> > 
> > Align vmemmap to MAX_FOLIO_NR_PAGES.
> 
> I think neither that statement nor the one in the patch description is
> correct?
> 
> "MAX_FOLIO_NR_PAGES * sizeof(struct page)" is neither the maximum folio size
> nor MAX_FOLIO_NR_PAGES.
> 
> It's the size of the memmap that a large folio could span at maximum.
> 
> 
> Assuming we have a 16 GiB folio, the calculation would give us
> 
> 	4194304 * sizeof(struct page)
> 
> Which could be something like (assuming 80 bytes)
> 
> 	335544320
> 
> -> not even a power of 2, weird? (for HVO you wouldn't care as HVO would be
> disabled, but that aliment is super weird?)
> 
> 
> Assuming 64 bytes, it would be a power of two (as 64 is a power of two).
> 
> 	268435456 (1<< 28)
> 
> 
> Which makes me wonder whether there is a way to avoid sizeof(struct page)
> here completely.

I don't think we can. See the other thread.

What about using roundup_pow_of_two(sizeof(struct page)) here.

> Or limit the alignment to the case where HVO is actually active and
> sizeof(struct page) makes any sense?

The annoying part of HVO is that it is unknown at compile-time if it
will be used. You can compile kernel with HVO that will no be activated
due to non-power-of-2 sizeof(struct page) because of a debug config option.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

