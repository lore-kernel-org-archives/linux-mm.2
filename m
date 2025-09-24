Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B68FCAC5B5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 10:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C95078E0002; Wed, 24 Sep 2025 06:17:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6C458E0001; Wed, 24 Sep 2025 06:17:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA9198E0002; Wed, 24 Sep 2025 06:17:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A95E18E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 06:17:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 44B035B01F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:17:06 +0000 (UTC)
X-FDA: 83923740852.07.A057479
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4BE2D40006
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:17:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="n T0Sarp";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=JldBqo5T;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758709024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JDTtAbQOmZtZk8z1Mcd5kf03E8S/F8hNJ0v+YQG+MwE=;
	b=6rWhKrZsgfgG8J8Op+w9QxUWOnR7sN/AqxSRe/+/lyVnVFF//83UYMlTZkTB8P2to5YZMY
	3yRJHNKF6bBa2VuaWSbWK6KZ8joW4gUr7mCCw1hYIwL9HZZ4kNf9qchsj8kHZ+KtMGeBeh
	+xkH09US0kXxP8wbBGhK6pkOyFisM5M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="n T0Sarp";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=JldBqo5T;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758709024; a=rsa-sha256;
	cv=none;
	b=2//BO5fBrtCF4FvM27H0leLFpQkXLRGCmpOK0KsCODgfgN3e/WEzlhqSkZZhLJwLuDJNkX
	VeVVdTd8av+V2KuNJirkqpOsA4hzTtCZB3DjDFTSKa9ybq8mXyadVxRB1VJWGuoLj8mWyF
	i0vBpI1smJwqxZVWCp/yWcpbic5G0PU=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id B033EEC0183;
	Wed, 24 Sep 2025 06:17:03 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 24 Sep 2025 06:17:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758709023; x=
	1758795423; bh=JDTtAbQOmZtZk8z1Mcd5kf03E8S/F8hNJ0v+YQG+MwE=; b=n
	T0Sarpa/KG1+uAkBBQqbXY4rEH/R2AorxuNHbF0W558Z4sbBbe0Z0+rZF8OYQsZK
	BU+mCgZFhEOq7OntNt+IksY1Vx9bkdnsFIavtxbpntIGjMNPBMYCZUSnu8/ep4aP
	7DQ9ogy7n/M3zv3OcTbQLrMxjVteBUcqU+eXf/NsGWj+ARXx0Mu+ZDXTn6KDBnWT
	AzyMEwpVKQWae2P6ZSnjxG6ydKd0vHoSxcwW3qJ9GDGTTYTF1aAv0vEcPPorpfd6
	wKV+ezp0sWgtqlot/6kGFxkoozo5mPCGDJeU6HKobCO2Aegu4x52bpWiXW9vc3f0
	qPL9SNjH/oThyUZaO1Jyw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1758709023; x=1758795423; bh=JDTtAbQOmZtZk8z1Mcd5kf03E8S/F8hNJ0v
	+YQG+MwE=; b=JldBqo5TO55HJf2/UnRQWnRhe5UJYTVIDlVKXKfbfdFTDbdejoL
	DCSH9xcw8jrDOn82r//G6rIotADGSWUQQkm48dIzfNjfKlFVr5KEHKflvRrNzg9N
	suvcs53R0h1iGMV6IcWSgoB9YOES7uPePyzOGabU3RFp2Dw14oSCZpRV3/auKtjZ
	amxi4JHd1KrMxMq3e+k4/WnRBlPbf7SDp4Ky1YQsRGDDZZQHWsDj+XguAtTbJ6dJ
	kG9RkaE6s+l1j//gRfVIb25dKx3GttQblSiYzwyHW9iD+nFMLej3lRpvZRyTaA+f
	0+hIEqFDURGCSkT2R3bGnhl9gt+yanpJ/eQ==
X-ME-Sender: <xms:H8XTaGGdBKmDLwL8l8Syo9qC6GNAyyrH6pRH1EQLYLwqh-dQh776RQ>
    <xme:H8XTaE_jZ51a-AoPPsU73w0AwDU3jz1Tfg2-7gFsezGxUyauG9Wt_I_1qqVNjHFaO
    ziGcD88gtDBzB282dnSiQuUkNvYRBot18MZyFJlOaZvBm4tpMofBmNY>
X-ME-Received: <xmr:H8XTaHhUgTkXh7FsUx97x1ij0ymi8FMEXeRiBYLorV48iYiCYvQuQ_DwnyS3Mw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeifeefhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepfeeg
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtg
    homhdprhgtphhtthhopehlrghntggvrdihrghngheslhhinhhugidruggvvhdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    eplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghpthhtohep
    lhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopegsrghohh
    hurgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepsggrohhlihhnrdifrghngheslhhi
    nhhugidrrghlihgsrggsrgdrtghomhdprhgtphhtthhopeguvghvrdhjrghinhesrghrmh
    drtghomhdprhgtphhtthhopehhuhhghhgusehgohhoghhlvgdrtghomh
X-ME-Proxy: <xmx:H8XTaISTvG4b3JkljYyYanWghsQ4CeXpHgOJvgqXm1dsCx6-8Z78NQ>
    <xmx:H8XTaEAfaxIgpR_50G_AoUmiSrRTKSvo4e-G7nnT-RhDE0K7KSZbUQ>
    <xmx:H8XTaC9PP0gPhVI_IzpB_VI5dR-uVXnR1CTTabcXNBwlBo_5uoQLcA>
    <xmx:H8XTaO07S3C9iemYfZQB6v5XV81GaRnlIWtWUbZGz5QGxZ2n3c4ziQ>
    <xmx:H8XTaOxgtZpX59qH382vwNfECxNqEQUeW0miHTVU5pUtEdsl9OiAcefK>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 24 Sep 2025 06:17:02 -0400 (EDT)
Date: Wed, 24 Sep 2025 11:17:00 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, dev.jain@arm.com, hughd@google.com, ioworker0@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mpenttil@redhat.com, npache@redhat.com, 
	ryan.roberts@arm.com, ziy@nvidia.com, richard.weiyang@gmail.com
Subject: Re: [PATCH mm-new 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
Message-ID: <2i5t62obfweid2zrt33vo3boviw4okha4d3gglw76eqv43ofky@pdv3evw5yjmh>
References: <20250924100207.28332-1-lance.yang@linux.dev>
 <1282de5a-3dce-443d-91d1-111103140973@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282de5a-3dce-443d-91d1-111103140973@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4BE2D40006
X-Stat-Signature: zanhoib9tp5sxk4hm5x5847pia7b8nab
X-HE-Tag: 1758709024-734904
X-HE-Meta: U2FsdGVkX19AEnCZtjxQ47s8J4SzeWV7FoSoasyrqLogD+cNK6xT+6xxLUBdzU0nz0CY+cTRg6Fux2SGhc9WoDyvexN6gja1BvLk8ArndBF7rdEvaR/LhcsjByywg8zN41Qm3MgQMwZw1S6X8U/hw1YA0O5VXzgNAVkvrk5eNXg4HnCo34Dwkx6dNQDiJvuVvYJxo9JDNqq5DCIL1wlengNsPi/FLp5XWWHdylz8kXQOJhMOJ0nOM8trOAl/fodbjukiSKb1gtEr/Zxw+qc5/vbJS5RS/eJgrG+cqbKzmHJV6BvfuwIDg0W6RS8q17SsJ6FSUieFxC+4HL/jAUrAobME9+YIDMDI7VSotKuTFPi44YzjEjH6Ijz14j0yBnkOzxquxpLWr/Vu6Kon4hZyAy1dZIo8eTT9cu4Oin+nOcQYE2qkjZNEMdd1xh8Pxuvgdq37LOZzyctk92UGX7Qxwmy3YZIzPiruMEW6iBr/DH0GCAJXf/onm4ar8xM+gOIImEfQG9P3ezHMnRHnHRI1X6yIlsI4+L5sf1jN2nxMgM/XS1RbT25lfk9UArfOgrrIWOvP8OVCQU8jjzS7Lqbqog3+v/LOkoWq/4uIVXRUI/9bzKDKV2nvBtOFcijU4TWCMW62w1zTVKz9hlljfv5HDSrulghewNUSTMHtGo1xlV6P4kvi/px1/M/fOn6DdCcmPjDn0VYWfQv4iOwtgztYVp1BMqkUeUv75rJDXTo/qlo9iyk7xp2v4Se+nfkVEJ0a2G0XAsxnYDT07D8i/EPAVEHOZskIc0Afn9bpAe5ZPK51D+Eokr0arq7SBAmjjaGn3ZAtRo0wk7EmVmMqgvacKX8vt+0P8i8LZ11+JYClkj6ZX39fS2c5HS37+yxtQHthmu+yem955Kc+LpPUka/+nDzkR4OjaVkHbh163QPuzFdkBEXVqBizGCQaVxD6fF1Vg2jv+ajth5nLzO/3D+o
 Mnf2sVqh
 AeqNNILyKSbFmRN3V5aORwoA/2ux/t4j9M9MReuCfKgh1epdr1a9IX/f2IPD31wkMRQvQqILG03WlAaF5rWeAc6/Yj9jmH8ft7DyPVcSq/30NfkVyJhTPmX2EUIE7RBw6kbXTi4Ork14o3x+vw5v9lVM2kkA1kAhPiExmgaYmKlDs5vxiI/XxksyZBStY6ejayPsytIedo/3gpfNjvqeOc6LVYHDScOkJ2gRHISSaMg7Ds44QH8W8KsWYc85Qcz0yhumFfye7alfndho7k2YUSjnQROhLTHL7RUC+OsuKgP+Rq/sdTVpSTjGFXOCB8aYHtANH2q8NeJWwAZuGDhNCvJZG0B2vg6Qb2RbW64SlKpTsjksSh0V4vdUvcxSCu61ccFx0PMajODf0qi1ZcVWoDlOUJepbWSywZ4e0I803K3pWr8/Zl2opYAZjoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 12:10:47PM +0200, David Hildenbrand wrote:
> On 24.09.25 12:02, Lance Yang wrote:
> > From: Lance Yang <lance.yang@linux.dev>
> > 
> > The existing check in hpage_collapse_scan_pmd() is specific to uffd-wp
> > markers. Other special markers (e.g., GUARD, POISONED) would not be caught
> > early, leading to failures deeper in the swap-in logic.
> > 
> > hpage_collapse_scan_pmd()
> >   `- collapse_huge_page()
> >       `- __collapse_huge_page_swapin() -> fails!
> > 
> > As David suggested[1], this patch skips any such non-swap entries early.
> > If a special marker is found, the scan is aborted immediately with the
> > SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
> > work.
> 
> Note that I suggested to skip all non-present entries except swap entries,
> which includes migration entries, hwpoisoned entries etc.

Hm. So swap in is fine, but wait for migration to complete is not?
Seems odd.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

