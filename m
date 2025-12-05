Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24EEBD37497
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 20:33:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AB356B02E6; Fri,  5 Dec 2025 15:33:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 382FB6B02E7; Fri,  5 Dec 2025 15:33:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 271C06B02E8; Fri,  5 Dec 2025 15:33:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 167366B02E6
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 15:33:38 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BC46F13A8AB
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 20:33:37 +0000 (UTC)
X-FDA: 84186568074.28.9B10705
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id CE93340013
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 20:33:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BUk3epvr;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764966815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8xgvH2EHBDtZY3kjjHDJSqalUqEes4vEoI+pPqwi+Ag=;
	b=27nE3mIcC3plTYOOVtTNeT8xEZiyuxhQJmb/doKKkrlUXEhbUfgFBnuCnb/I+gPffmNxJc
	suj1qfbzMUoP+kDNERMvAR36X+pYCB+h6H8IaZg9uCIkQX62V0ZbZG2cihkja7xjC3ja5U
	44WEvMt/oeovCm3/Q1/klu48hWc8uo4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764966815; a=rsa-sha256;
	cv=none;
	b=iR1+i54F0uthU0DzgFPovnR7p4st9su6p41VWyjMqBrFibGIYZxilXT0nQbg3Vnj2Ed1de
	QVjs/99ev8uHxIEVvZMkKpNJxhgDUTWSAS6lm5vw5gPSHOQEcANpm3abE9JbFpmMLt+m5t
	17E+5gvhsOE02SyG2j2yaFUvYiuLOz8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BUk3epvr;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 465AF60010;
	Fri,  5 Dec 2025 20:33:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46377C116B1;
	Fri,  5 Dec 2025 20:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764966814;
	bh=xhGlEmAWqnSy+8gr4vj1cz9rV+6yNQAySY4hUU4VR+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BUk3epvrOvhjhOPMD+eL/H/4doXstHmZ2gSEaIgronqjx/FxpEi9nzF+iExr+//p8
	 3fEHSFq/p/wsdUE7TvZkQrO9o95uvcwCG6iEMMIPlRCGJT+D/IZOX6A/WFo598xpwO
	 5U2+z4/EkrfKyURHwuJ7+jnYNXotW9lcvL0Wx/qzVaELR3bqWxlAavj1fn1PzbQegl
	 25hdt8x/2fmB6ooQuCUoZ1MeYjmj2hNMkucm6KfzGN9w2O/XE52sJA17wvkL7D2Iyr
	 JQuLu8yRz4bgCmhDH3vaJww4IeSQKsoS3D2YnpOzo/kc+wv9x/E0qFJ+LP6ssoixPu
	 ONCjn2TvLlDRQ==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 8A6F3F40077;
	Fri,  5 Dec 2025 15:33:33 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 05 Dec 2025 15:33:33 -0500
X-ME-Sender: <xms:nUEzaToK8vfqo6dh409MXSk_OjeCWqLA6qZTx3dgMbPGWy7Tg1BXYg>
    <xme:nUEzaUfc1mSZHxmqEEFe1sig3AudEfXOMPH9M_I1Fk4rO3VD_-AEH0M2a0TYfj05U
    -2YDZ5JcH8_i4wL2LpAY6_5EJVbuH1EZFaBsyv55GoGwqc4sPyjVeg>
X-ME-Received: <xmr:nUEzaZIqZXpIRQjeR7qmZX3_7BJ4uqJk3RfTWpaJRs0GsTnKUY-MsrI0uEgeEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdelfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnh
    epheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilh
    hlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheehqddv
    keeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrg
    hmvgdpnhgspghrtghpthhtohepfeeipdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugi
    dqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepmhhutghhuhhnrdhsohhnghes
    lhhinhhugidruggvvhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorh
    hgpdhrtghpthhtohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehr
    phhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtg
    iipdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhm
    pdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:nUEzaZsX7POKH__6uLu-qVHKCjFoiDHVVMf0YcoaUvNqpxLjgqxORQ>
    <xmx:nUEzaXLST0XHQL37-mMZGOi1CiNdUJ0KOo6Bjbe9LYTr6ibLVXkZyg>
    <xmx:nUEzadBuFXreBMVNhYRmDxOcBBRhJnmQP_Zg83fXVFA3uoJqshiAJw>
    <xmx:nUEzaUVLL89j3kcpCsuyBngO2nJ5IEL7rnYulH7RlIX7ftE4K9HvDA>
    <xmx:nUEzae5SyIGyHDxUGRWipE-aji05Lwsd_qAaKBd4Dtc-9iFujFKMcP-A>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Dec 2025 15:33:32 -0500 (EST)
Date: Fri, 5 Dec 2025 20:33:31 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	Usama Arif <usamaarif642@gmail.com>, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 00/11] mm/hugetlb: Eliminate fake head pages from vmemmap
 optimization
Message-ID: <bdie34dgpltxd5ayvjvqkusx4thdrrebgllvwp333psfuu4vgj@bkfxg2c5sfr2>
References: <20251205194351.1646318-1-kas@kernel.org>
 <e1c50f7e-cec4-4676-b5d6-f6446cd64ba5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1c50f7e-cec4-4676-b5d6-f6446cd64ba5@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CE93340013
X-Stat-Signature: tkyejodyxftydq55hxeoxaqkaxiu59hc
X-Rspam-User: 
X-HE-Tag: 1764966815-795752
X-HE-Meta: U2FsdGVkX18djDlvc0MOiYFouLcNiwjm+IdcaiKcWvWI3UKspFKswa7GIj9EkQc/Jmxm+zjwLJbY+b17igkY6UDgqDYFI/nPThQxy0C7PWL/THLUxw3iKb2qBJB+UibJnzylWVTz3ySDLOHP60OiTe6JX9hBFA1j3cHUuhTkIozpurE4kQCU9KnKwKdwQpC+GmxizzVegt2pcwVjfjJIkrIk6gQAsWcyOpppCBV+k29A5u1kCJvX+6MTorKdJRUnqDtuGH8lXWZfQgF892j1Jvx3iAaY4Zr3pRI2vxUnq7gXi49Ao5lPGPSLUm6F+FeptX77NvyxZk0g2RBGflj+iQTGKyy9DMmlYxc1NRttUjASStUqntFubm6YCrczXYt/RWNryNyzvn8001kRoEjcwoZyZRXl5e9dxkQoGAU3a/Va9zB/sdlNwF+tqhKKAehRoczOW57Iki5l0USmVjupS14v5e8tjeV6B9tZIMOiHw1MX2jzRFDEh1onLkgvNH8Bf7DF4coFzEc7WoO3nkvt9FDzsnriJqg8eXZjt6X5nQk8cT4coAi8cHK//DWuJT5E+3jCryCOygpi+z5TxhVPVuk53i/shvBHULJqigrB8IQXaUNhWk5s5ZXPgISSxevIM3XcRY84XQsy9NpyntOrML/ASqFfIJ4X828zPSqFF5JHu+Vcy7chPiEXpJg0vnhVsddOUfiDw8snhCFEDSbdMyAfsa81MYJ6FGcRRAV23eaREMZTPz0YammuLxwhtuad2qtRxE5wyUk2kOb4kKUco0sAaMo6D8Irkj64bPS1hETYMsQERXTZFAc0Bcui9kjdW9ZzpFY3tEmJV8dG8zylxtZesRTiHQgNJ07u7+HwNY86C3LiFnMNk2/2omrTSpe2ok4PJcH5/uTcS8Rzc4swwJLjFqxTp5phMG/T3pEosiLassne8ZW0iO6CCG4Lsg31YxL8L4+JBHW7eLbGBB2
 CATu6yCj
 r+rLaHN8oG81l1stnAmwoIMbbcDOMBg4fB8eD+EwVuwa/KLZs3TedDXAP1hhry1m1feA0iKgskeSwpmhbOc+1X6ZpV6cg/MF2OBBD/mNJtpqP+kp1NaNoGLG2gnJn7HbNg2hHR1g+bFT/JYwMmrb+qcmaSsTTL2r6REqLkXrCZ9eikM59X60l9PZMy/Ble+9fnXRkdgunJvWM6WW0m8jZXTAZDUrMJVJJdh96HeJIQaREaHF/Ioc2hQW6jFUMjJcWgouidUFoYrAk4170BB+2nqgK/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 05, 2025 at 09:16:08PM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/5/25 20:43, Kiryl Shutsemau wrote:
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
> 
> (we're in the merge window)
> 
> That doesn't seem to be suitable for the memdesc plans, where we want all
> tail pages do directly point at the allocated memdesc (e.g., struct folio),
> no?

Sure. My understanding is that it is going to eliminate a need in
compound_head() completely. I don't see the conflict so far.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

