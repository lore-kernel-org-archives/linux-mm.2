Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E949FE9E2E0
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 11:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 107D86B0005; Wed, 11 Feb 2026 06:03:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B5756B0089; Wed, 11 Feb 2026 06:03:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECF546B008A; Wed, 11 Feb 2026 06:03:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D6FD36B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 06:03:45 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7A6D513A898
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:03:45 +0000 (UTC)
X-FDA: 84431890410.30.761E4D7
Received: from flow-a7-smtp.messagingengine.com (flow-a7-smtp.messagingengine.com [103.168.172.142])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6CDC114000D
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:03:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="DX5/1Dnn";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="V nJ/13G";
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770807823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K8myth/ue+5MR9IOMUfT7evtyMaEFtxllmMmJKcsp9I=;
	b=16wVk2/JEfmDvEM2px6BHom/t1T0KbrX1GUP/n6RLMg9Yo66iBFKtUbE2P/7kAhB8GFRMI
	7ErXW3O7w4svBJG365W3e1Nao7YzQGOUlKTddcEC7BaN0z1dwsY7SbMz4DPkoo2BZp+1Wm
	EHa0SXmGAbu9dKpIVmX/5jYvJqPwgVw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="DX5/1Dnn";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="V nJ/13G";
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770807823; a=rsa-sha256;
	cv=none;
	b=RfWXz6oN/zjfTFz/3MmK4vacH/kmDCT0p71+Fbq7kCN1D0srIhKiZvVzQ2WwSz1iqVciSN
	c86VzIqTwXh53i1v8gaJQT4D8C/MssYmuX/HAK5LIfjLMSSrjrsbItKicJ0Vxbn9zFBF3H
	ZnfP/peVPOzmtoitRzJoW6Z7OQaKcWw=
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailflow.phl.internal (Postfix) with ESMTP id B3C8F1380956;
	Wed, 11 Feb 2026 06:03:42 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Wed, 11 Feb 2026 06:03:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm1;
	 t=1770807822; x=1770815022; bh=K8myth/ue+5MR9IOMUfT7evtyMaEFtxl
	lmMmJKcsp9I=; b=DX5/1Dnnh2meaF/W8AjiVi9F4k9E+hSu0MnX89p8qMeS/ENL
	DSTXvE6N/of5N5/3Pozwt+TXZeTwZSsP1qqCZANGX1hIB1/aQ0CvIy6t8uerlNMi
	pZSrGOUmgxOwjXgvwuBy9JRMelkFrlYGK9YTLM9gEtGLrDHLMtQ8udAQCvoEiIlN
	VyXtvEkVzRVNr7JXV3VpV5l5GrnbsHpgF4Tbb73u5v7EiEq1whOwJrB+neb28U8U
	rVeWW/1qpT8vAqm4Ma8SouvKUCf0Q/E8gZYNL77FpuMxH2chSgZd0W6UIJ2aS6Yd
	9EaldvZBPxaGUP73YbbawzexH6/hjWJCwJpHLg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1770807822; x=
	1770815022; bh=K8myth/ue+5MR9IOMUfT7evtyMaEFtxllmMmJKcsp9I=; b=V
	nJ/13GXM9fLjSApk9IFcOu4egL6+bBpNPTw/J/IubTeeEYZXO7IdVAvgN4kUq9X1
	whNLe58ZviFT1lxRXMLOXcU4mdJzQLQKYxLOG+IMJDSHR8H3gSflh++gDkDFey7d
	B4JX53DQg+QXAkymaKrPkSeWhb1c72dgRIQR6ljsG6xCntFs4B3PT2fofg9dpTxC
	m0kc5tuGL5bLewjjscv43qZ7eUkeAVg4gw8vejMKjWpyjJg7c4E8YHzSxefQDzXc
	0V4XpTxzbDxs7Tj2inrOuQxouSToQAXxSBwmL8hrT8BLLAZZXnIO0P34CVzauQOF
	oo9Ou5t/kvOywMcDUu5MQ==
X-ME-Sender: <xms:DmKMaZWOzQatypwEeyIeaynP0Ss_LXUtgZdcCkbNxNu6vitBlvW9RQ>
    <xme:DmKMaa5Ezdhgswz90I3wO9GgZ-dlVsVmcM07UBLtj-AvqxLa2oleuJUxKru7rs593
    A4NCq5Y4wQS60usFpqPvdAZzWCUAR68HP7TIbUzV_y1iBHc1flK4ys>
X-ME-Received: <xmr:DmKMaaCWsYo1heW9neLUU7fBJG8rwru-_QIEoncPws6YigrupS-ydTrYDdmsbg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvtddvfeekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefmihhrhihl
    ucfuhhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenuc
    ggtffrrghtthgvrhhnpeeltdefvedvteeuuefhvdeutdetheefueethefgheegteeihfev
    jefgvddujeeileenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohep
    vddvpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehhrghofigvnhgthhgrohdvvd
    esghhmrghilhdrtghomhdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggr
    thhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghp
    thhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhope
    hvsggrsghkrgesshhushgvrdgtiidprhgtphhtthhopehrphhptheskhgvrhhnvghlrdho
    rhhgpdhrtghpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomhdprhgtphhtthhope
    hmhhhotghkohesshhushgvrdgtohhm
X-ME-Proxy: <xmx:DmKMafCJLOGnwljTWp3silmpVJxaUVLaMqm3i2GixF6PjQwcl5wedw>
    <xmx:DmKMaaj4SXO36Yu5KvccPpXY_LgVp_KLUM_x6JAa87bsiL4gYmqkCg>
    <xmx:DmKMabeWMpIiwpgtc-REhDjgeoUXnP01IY9TFM03fPZGZiAqogCv1Q>
    <xmx:DmKMaXjZZCr72PpqmViTHB11WQKeullGGHwhEtNwNFpMKbGmd_eseg>
    <xmx:DmKMaZMBxhPInLdbTQWzhlidKvrixAZcKLb01qm5YkUwNaEUksdBP3oH>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Feb 2026 06:03:41 -0500 (EST)
Date: Wed, 11 Feb 2026 11:03:35 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: only set fault addrsss' access bit in
 do_anonymous_page
Message-ID: <aYxhgHcTZMJx99fi@thinkstation>
References: <20260210043456.2137482-1-haowenchao22@gmail.com>
 <aYsaUOWxujne6_RP@thinkstation>
 <CAOptpSOMbj-US+qhtQ75vU7Fv9pAyK5yz+n55rX0i4wLFFRabQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOptpSOMbj-US+qhtQ75vU7Fv9pAyK5yz+n55rX0i4wLFFRabQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 6CDC114000D
X-Rspamd-Server: rspam07
X-Stat-Signature: z8dbtsmns716rg9of1kgf6kec57xbtm3
X-HE-Tag: 1770807823-68627
X-HE-Meta: U2FsdGVkX1/H0Jw6EtasGfgKck9c5C4VujlKDG0FUC4Iv83Y+RxoRXt64ZEqI/dwZQ9nsSmWhZgXh61Ir6C7VuHZ0mDRXSkX39ks9igk4XKs6OYdhGpHINrSzGItXXYAB3NFiMTjbSlWwdZAZvFjqG/VzQ4gw25o2wlzqwvk1Z6OvX6WHD0LNWWtvcKucMOocPMvZptxq2aGnVk8BvBCLfkohUzOfeeX72lyJhEcC5gdK3pCkd7WTvG7DEvmqLH4zGc4yp1jkBX/iqN0u6lzBvOPDUKVKgoXIEz0ZBw17/FlIsF5aCoRx2+QKgEvLr0tYNP0TkuUa9V2UU285KIeN9G2Itu/kuqm+/rhzUDMvLXHwvA1BiSpoq2yqkPrtO37u/zUrKNC389tMcoXtGaBnX4tMq2uc3sZhaI8QMpbKkNk0mqg/psmhqiBuAZkzEl8ucGlJgSm5Z0qjeMgdWt7CXSclsl2DXUyoqXxKL4kBaDSNn/0DCVo/A8SWJ4CkwK/mjjjD5Uix1jtWM1Kn0bXuwCVoj4pSUo/xMuuf9dIGzvmWazShwmi33y3B1yPmkvaw3/eO6NnHsHvVrLaSEFCLpZOSMvdzT7N0D3X8X3kvG1UvmK/C287lJXu45oCRKmmuq7OhmMt6px/fgTotqhjMa272McR9UzC4qHBt/hOeBH1DZ471e5Ls7zajFWPZr8lO7E9bjwfQrwj1f5ej4FUssKbDKzHWfovQFqIwhz9fYfm4TwNuNIpgRkr87ERjsxwclK70mD7vo/dpY7fMjG/rlXsYo73eCjmf28r6u26rBV2EIptNTQVk3pTo0CIxeFcuy/VYYomCFF57P0l1fh+3Y4paccAwJB4fZw9g/K6tdDhY1xKyVTtQ2rCHu+32cejvbDKdQ778fa/prwbfzAvIzwQKNai0gNg0BYyKX9qFdsR4ERGUqE/Z8JV0rxVWrbxufkG5H67cqkxVesovNH
 lyHM5C+p
 zhas4CwOCaAKjENgAymu8YAq6QgtoJmHRzYdVvr7cLYSIgJJApxrAV/wQKpd9KXoksn5328JmZkmxeZrTBXmrRQDvg11LypOGezMYh3CgKPwW8/Ci47shZHXGOUqxv0yzqmXbT88gAvx0yMrf3vE4eKWB0lcOynVoCL7/O7Mh8wLWzd65i1tBmluGNFEdz+O9Dx6uuhZTWDCG4JSiFeQm1NhHf7VvkL5JbSBQ4AjyEprKo07syMo+UnBd2QpjHYu1BY/qU+Kj6s/X2WtsZKvP723fO94pBfXszeh97LG4v5NDJqHspADzzV+9Wgt0tcne7236P6tXotamBbrfxjS7AqztbQtWHKP9YWoHKRHgYWugpGLdecDov2tZxhBBBa3bop10lFOzX6u9elP8V8P+h/t1wN1I73nWu1l+R8ZTDgrgbKgUlDeyf1fD/1DQOWXPZeXC4tBud9Z0TRI++LjQbtky3tH8gmXVCSIB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 09:00:45AM +0800, Wenchao Hao wrote:
> On Tue, Feb 10, 2026 at 7:56 PM Kiryl Shutsemau <kirill@shutemov.name> wrote:
> >
> > On Tue, Feb 10, 2026 at 12:34:56PM +0800, Wenchao Hao wrote:
> > > When do_anonymous_page() creates mappings for huge pages, it currently sets
> > > the access bit for all mapped PTEs (Page Table Entries) by default.
> > >
> > > This causes an issue where the Referenced field in /proc/pid/smaps cannot
> > > distinguish whether a page was actually accessed.
> > >
> > > So here introduces a new interface, set_anon_ptes(), which only sets the
> > > access bit for the PTE corresponding to the faulting address. This allows
> > > accurate tracking of page access status in /proc/pid/smaps before memory
> > > reclaim scan the folios.
> > >
> > > During memory reclaim: folio_referenced() checks and clears the access bits
> > > of PTEs, rmap verifies all PTEs under a folio. If any PTE mapped subpage of
> > > folio has access bit set, the folio is retained during reclaim. So only
> > > set the access bit for the faulting PTE in do_anonymous_page() is safe, as
> > > it does not interfere with reclaim decisions.
> >
> > We had similar discussion about faultaround and briefly made it produce
> > old ptes, but it caused performance regression as old ptes require
> > additional pagewalk to set accessed bit on touch. It got reverted,
> > but arch can opt-in for setting up old ptes for non-fault address.
> >
> > See commits:
> >
> > 5c0a85fad949 ("mm: make faultaround produce old ptes")
> > 315d09bf30c2 ("Revert "mm: make faultaround produce old ptes"")
> > 46bdb4277f98 ("mm: Allow architectures to request 'old' entries when prefaulting")
> >
> It does look similar—our modifications both revolve around whether pre-mapped
> PTEs should be marked as "new."
> 
> Was there any analysis into why your changes led to performance regressions?

As I mentioned, my theory was that it is due to an additional pagewalks
CPU has to do to flip access bit when it touches the memory, but I
didn't profile it to confirm.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

