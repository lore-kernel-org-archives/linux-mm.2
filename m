Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D04BE674B8
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 14:52:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F06726B0089; Mon, 22 Dec 2025 09:52:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBD666B008A; Mon, 22 Dec 2025 09:52:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBFB36B008C; Mon, 22 Dec 2025 09:52:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD5046B0089
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 09:52:25 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5D2F8437FB
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:52:25 +0000 (UTC)
X-FDA: 84247397850.12.46D0114
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 68E431C0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:52:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qaHRa2RF;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766415143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rKIFO72OG+Fhg8pv51IfRkPKfQwBlZbOh6oSMM2rGqE=;
	b=VAs+4hGC8EK6aBru5jlvhR4Gv12TN9Dks2q/7t9+d3JJRLxjtygzq75QrGFvkjn45J8tn9
	YoPCk7xHfh8xs9DD140SAC47iTgyzb13qbosp1xwllEssTrxACh6q2aLocvSc1dO3yCkuP
	kMBbQ5Rk2eicDZmSHFDhMbmb+OQRnBs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766415143; a=rsa-sha256;
	cv=none;
	b=PBqRei9Fb+OtfXOVSr/z1pHJf4c/7JpdJ8gUpxB4tOa6WFejVMSVV4vm0jYX84EMWyvDS3
	T/AfvlgStwk17KbJTmAuPAg7OO78CvOo1FmS7x3N/qJ7x3D73s0M1rYK0x6P90sDfnkiZ9
	wwdGhOuVUHdY8exwD1JkzqjH61jvfBM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qaHRa2RF;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7AE806001D;
	Mon, 22 Dec 2025 14:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD08C4CEF1;
	Mon, 22 Dec 2025 14:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766415142;
	bh=LxpT0xwEZp0OshbwMp3ZnX/N3w4Cls4+fhHuEvVMmIM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qaHRa2RFU8+HqIIb2PIHFkpAabd1Je1CeVbMgQLJvsnew+XW82hHeJPygR/E9oj31
	 kAGNjUXsmULzc8v6wjGF4zzE8QacPYQSDgCqFLOuawI0aQ0f4ubryaY3T9of6Chyqi
	 Ts50MZWPnvsOcZylN8nPBmHiVQ+IP52rcIBww7sir9gWMxwUHUwcaOwaF+/EkykGet
	 znnwkq9ozr1UiCzw/WyPVoNWEjOU05pxJ/B+Hys2vqKEiCSGJMMMxnpkYycBb9NmcF
	 15D3d8RJJ5Xe+isbziJmKoR/3mdgzwmTVOlj+MKusg8Jo0PmIpxM4mD0SGY3XAfgGP
	 hwsThEm2nrPKw==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id B3D3BF4006C;
	Mon, 22 Dec 2025 09:52:20 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 22 Dec 2025 09:52:20 -0500
X-ME-Sender: <xms:JFtJabWcW4NqPOSYVBylgF3WTXMh3M2hwYkU-hHTl0q9YOs6LhjKhQ>
    <xme:JFtJae9158c4yiXslpx6CLORmpxvBQ6Of58OqECFKDMID4mIq16WO6M8D1x6NPESo
    MNYnB82VQyUyt2xTfxDvA7qM6AJxYOAhi3eT-FJoufhac0iNpzr71Y3>
X-ME-Received: <xmr:JFtJaQz3hjiBb0FzniDb2nZ2_uFz62HKLbpfvY0K-VWz3PH2QGaQWzZxaqrnEg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdehjedvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtugfgjgestheksfdttddtjeenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepvddufeetkedvheektdefhfefjeeujeejtdejuedufefhveekkeeffeetvedvffek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopeifihhllhihsehinh
    hfrhgruggvrggurdhorhhgpdhrtghpthhtohepmhhutghhuhhnrdhsohhngheslhhinhhu
    gidruggvvhdprhgtphhtthhopehoshgrlhhvrgguohhrsehsuhhsvgdruggvpdhrtghpth
    htoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehvsggrsghkrgesshhu
    shgvrdgtiidprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvg
    drtghomhdprhgtphhtthhopeiiihihsehnvhhiughirgdrtghomhdprhgtphhtthhopegs
    hhgvsehrvgguhhgrthdrtghomh
X-ME-Proxy: <xmx:JFtJaeE_5-2BnXckVp5f_Eb0ScrQGWz251EFJaXeykioHTOZZmgF2A>
    <xmx:JFtJaRJE7xWqTKFB69WX53AZp2EuWjIj-DUBdFwX3_0c9wv-gml6Bw>
    <xmx:JFtJaZ5RBUm8poiTu6Y4EKsP_ZB1JIZcVTLTqzMS-27i0KYONPIdFw>
    <xmx:JFtJaZR-YeiVh7P9OFrFEmeWytjehqvYVvnEyqCOoaISq730oEOi4g>
    <xmx:JFtJabA3EGU1VsrnwVz3zFHk8rkp5xgwQvkUmvzvPSJUoQRxT3FsJq73>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 Dec 2025 09:52:20 -0500 (EST)
Date: Mon, 22 Dec 2025 14:52:19 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, 
	Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Usama Arif <usamaarif642@gmail.com>, 
	Frank van der Linden <fvdl@google.com>
Subject: Re: [PATCHv2 02/14] mm/sparse: Check memmap alignment
Message-ID: <mqvgofzudkucibhyr7gsjgtb47rjibqkqce3wdd62p6kqzosxb@tv4fkzewgkt2>
References: <20251218150949.721480-1-kas@kernel.org>
 <20251218150949.721480-3-kas@kernel.org>
 <430d554c-840f-4813-b715-5191d74571a0@linux.dev>
 <4ctnfkw5zqneume6px2wqgdgusfdricr4uuonv7bfjheknrt2g@fdb5ceiiar4q>
 <3b758468-9985-49b8-948a-e5837decf52d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3b758468-9985-49b8-948a-e5837decf52d@kernel.org>
X-Stat-Signature: xkc41j4wgh7jdb7k3q6bmmhddatehtph
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 68E431C0005
X-Rspam-User: 
X-HE-Tag: 1766415143-761597
X-HE-Meta: U2FsdGVkX182mfW3zXB57bEsdH4WGJ9dGPtW127QEPHjERRExz2JegxrU/3BnEv7R6DUxWp/QBTbCQSRYEfx2l2hE7vJBGnAJnrQyH2brLCbvySeJExbt3VLRDymnDLFbAecG9dW5DmMsJqEMxk29xLSUoUaYxhmqsywL2q6FyZjaVdwggjq6VrMd7tYDfcn19jcoZNHMXVu8BY+p0SzlcrvS7TEtCpDFBop+uLcJWYTEgEijZuilHRSgcyA0a+wbm84x2U8HmeuD+vdfeYqR1tXLlijgy2ow8j3lPo33fKVaRt56ZO+T45EmJxxqJ6PexaOTl8Fu0UZ1/hnK2M2QQM/73Tt9gJHIuVLnOtHY+NIv5IdYIKmkCgyIGNiaoVXGFnb1Pul6GrcNODOzhP7wuyqLP3FRq9yQZBWzan9+KK2T2AABQinsHECrBkESX5HmpmXOCPY7PovIkUQHqHuvEd110tmDTbEsO6v7H+WqLgEFYl4eVpwpUGTge6DW4mPl6ts17SGBnthZMkwlYPW4bebJrgd2/Acj1W7Bd6MMA9z/bn8sM1QNpKgN+M6SaH15iyIBPoR5JFtmb0Mss/Rkid2i9bKd+lFB0/s/oTAuBKubsaUqzo8vPYmRaIrgVciZBtOE0By+zyoC1eIazwBjO5v/nLMdFmZcx0lX1JU92Z4NqLU5SSd4YXCXbwX9NEhqUSfZEJ+SNBK1xe44mF3crDejzQmZA3dj2oWEzTeLSnnabEpRs3RUKmTSAbJNcpnpyQWYWip7xiGwJYSfgU8WzebRKyHJjtL/7Tdwdt4w6JwGm13oIblYV4+lfbDlMdOokNhKgCU8KcsAyDo8yDAjAVqOyANi9zKAwfN740cJyYTLesiCGnsAU3AxNgQ6RO8Bnxvi+lnYC/vKgfhg0eaN+deob93WegSpb7ENBwHYajhpQ7qa0kq5+GzkJaaG8dLN984bd68kiv6ZITtC0f
 0HcLAo1E
 brWVwZc8jTOKb0HlutTOhy+Jn34BZATKCB8xuXkjNVrGOKDpKDP0h+9tdaTm7/h1MPI3NF/AkFnKIg71/qXWXJJKaqJtuJeLO1/36CRooaTkr+a+3GYF91GeOo/lAhPDJxWyvh8j1gapcdlxk6esvM5D1EbqxX2XYDbEHoONWxIce8IyBXIYEAcQTgwe/YmEyvWlWdE2RkAH5Z7mpbiA95XXBgIAus0XDs/9hAkW681SCreQOpAX7Ul5d743WTapMn2GfJnMGRdNCpV8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 03:18:29PM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/22/25 15:02, Kiryl Shutsemau wrote:
> > On Mon, Dec 22, 2025 at 04:34:40PM +0800, Muchun Song wrote:
> > > 
> > > 
> > > On 2025/12/18 23:09, Kiryl Shutsemau wrote:
> > > > The upcoming changes in compound_head() require memmap to be naturally
> > > > aligned to the maximum folio size.
> > > > 
> > > > Add a warning if it is not.
> > > > 
> > > > A warning is sufficient as MAX_FOLIO_ORDER is very rarely used, so the
> > > > kernel is still likely to be functional if this strict check fails.
> > > 
> > > Different architectures default to 2 MB alignment (mainly to
> > > enable huge mappings), which only accommodates folios up to
> > > 128 MB. Yet 1 GB huge pages are still fairly common, so
> > > validating 16 GB (MAX_FOLIO_SIZE) alignment seems likely to
> > > miss the most frequent case.
> > 
> > I don't follow. 16 GB check is more strict that anything smaller.
> > How can it miss the most frequent case?
> > 
> > > I’m concerned that this might plant a hidden time bomb: it
> > > could detonate at any moment in later code, silently triggering
> > > memory corruption or similar failures. Therefore, I don’t
> > > think a WARNING is a good choice.
> > 
> > We can upgrade it BUG_ON(), but I want to understand your logic here
> > first.
> 
> Definitely no BUG_ON(). I would assume this is something we would find early
> during testing, so even a VM_WARN_ON_ONCE() should be good enough?
> 
> This smells like a possible problem, though, as soon as some architecture
> wants to increase the folio size. What would be the expected step to ensure
> the alignment is done properly?

It depends on memory model and whether the arch has KASLR for memmap.

> But OTOH, as I raised Willy's work will make all of that here obsolete
> either way, so maybe not worth worrying about that case too much,

Willy, what is timeline here?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

