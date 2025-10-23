Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24357CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 11:40:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C1B38E0013; Thu, 23 Oct 2025 07:40:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5719B8E0011; Thu, 23 Oct 2025 07:40:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 438C28E0002; Thu, 23 Oct 2025 07:40:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28F1A8E0014
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:40:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B519088FE0
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:40:26 +0000 (UTC)
X-FDA: 84029186052.22.3AA1732
Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	by imf16.hostedemail.com (Postfix) with ESMTP id B40CE180010
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:40:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="B cFXvPL";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=kfZPHhYU;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761219624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TGTdiZBZdQIPrGsQYMV9BtYIorIZz8VR0jKouLljBYA=;
	b=P22DYDCTnr+phjofWPvbB/PTV/d6haEAOBRz6FCGa3KjrdBjsMmW4QHlRsaUmSegnF00bU
	nmD2R0TtMgbiPxKSgdnDohx3fZYivIvTaEFGZd/9u6T21JTKy7G/KuMOWJ7VhSlk4tVPO0
	raDIpSr71eK+kh851gdxq25FMKWShik=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="B cFXvPL";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=kfZPHhYU;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761219624; a=rsa-sha256;
	cv=none;
	b=pLSgDdl3D3vtqQLvKO9TFIl1AVZL9TS/exz4pPBSBVqCiil45/bpkp5cfyvGZDXvayFX6o
	eBaemowR7Kh6kfPSp9XIXVjqFoibYUJlo/98kR+L43F90VxfoDu8dM5GFCNflTDkD4T1CA
	DG/VA3ObWHXoOIYKDvb7+mGiJ5kGxIk=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 7E4C01D0013A;
	Thu, 23 Oct 2025 07:40:23 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 23 Oct 2025 07:40:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761219623; x=
	1761306023; bh=TGTdiZBZdQIPrGsQYMV9BtYIorIZz8VR0jKouLljBYA=; b=B
	cFXvPLWV+lXE7xxKYW4EHHbcGRD4y/L0zZR/aNG62i7HKKJruXobU/wwia0uCF+J
	RXnNJClxG/a/VXr0X00ZGhChdjCkBy9q80fvYORmVeKeN1/w+C0i5nLbHCF/KHsO
	3YCRfjMm2JlOq1flybcqNr8Y4MH4Sk+bFkDCeNMZ6/0yFgZYsQGkczEJGISv2/Dw
	tdFaKitJxKgfZHCOKni5tjTobQk1hJFJbL4pxXODR0JiNeXjdgYGjaUbUcUNbe40
	CQCFXG4Jv3QBmmdbcbheV/kQxTaOk13f37IZ/mAazckCgTSRy4qqTuzAT+Z7AFo9
	sIGm9QK2t80rbxgbURSbA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1761219623; x=1761306023; bh=TGTdiZBZdQIPrGsQYMV9BtYIorIZz8VR0jK
	ouLljBYA=; b=kfZPHhYUsLxPWhPk7mHkz7K5MpgnZuvygmW0lVAcIOuEK/6puxl
	Yk9vj6GutIb+ZRp/mdOpH+RoUNlP8g60hFkj5C1IcIcgGaTh3aXgfXz64HC/OjmH
	k2i6lOH1pPIRK/v5kCloGuBPcpT8hPinej5eGL9rA93pCtR29qAw/MuxKap+8nlT
	nIBN7K7msKtltqfJuAeUJE0OUmwsewZcrFrs+IBRUJClBH2I2pqZv8S8GOs3F9Ow
	nabZCuWL4urlHuaHFapN4tl2M+gX9/vVWE02X6DkpnewEPjPynVUDf7+dyhMKc2x
	i8lofAfzRqz3n31+J3hsUZbv0ZECU9bzbUA==
X-ME-Sender: <xms:JhT6aFysnQnFWGq2-JeJCVVkphyFFkojUUpjBT8sZ-ggIYykzN-t_A>
    <xme:JhT6aGm8ngsnaWo_y3sefXMHJygkZLr_nY6BGxsJEIobfApvSaFi_RUZcirzN5JUU
    zypiTtDWnDtocDnKH2gO_KBskMDJSHKwephWKMoFF8tQqWp43YVXGk>
X-ME-Received: <xmr:JhT6aD-T1-k7aVIcsJBgGVYvHO7PRpLYDPeO5zfvE-VLwnqeDJ2bGlaDo0woJQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddugeeifeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedv
    tddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrd
    gtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhr
    ghdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoh
    epthhorhhvrghlughssehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphht
    thhopehvihhrohesiigvnhhivhdrlhhinhhugidrohhrghdruhhkpdhrtghpthhtohepsg
    hrrghunhgvrheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhgrtghksehsuhhsvgdr
    tgiipdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtoh
    eplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:JhT6aKPz40luYy1Eie_fBiExg_G1OUu6eJvaBajwqyU3OKqYD3aLxQ>
    <xmx:JhT6aN_LXH3KHlfYxLK-t0yMrWZgibDv2Nqtgm8ID9PG_vRdYJzqiQ>
    <xmx:JhT6aCLvrS50ijCK2tLskpLEoZ62YbEDfkav7YtwiH4-nYOTlXynqg>
    <xmx:JhT6aAeh_ejRGjXaABoaNZTziegD8jdGGzkp_zGIICRuIDIX0wOEaA>
    <xmx:JxT6aB15Kpve9K8JX7w0wCcDK2CpxRUgm6z4qGAytCUixwo9jUl7PjjH>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Oct 2025 07:40:22 -0400 (EDT)
Date: Thu, 23 Oct 2025 12:40:20 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
Message-ID: <7fmiqrcyiccff5okrs7sdz3i63mp376f2r76e4r5c2miluwk76@567sm46qop5h>
References: <20251017141536.577466-1-kirill@shutemov.name>
 <dcdfb58c-5ba7-4015-9446-09d98449f022@redhat.com>
 <hb54gc3iezwzpe2j6ssgqtwcnba4pnnffzlh3eb46preujhnoa@272dqbjakaiy>
 <06333766-fb79-4deb-9b53-5d1230b9d88d@redhat.com>
 <56d9f1d9-fc20-4be8-b64a-07beac3c64d0@redhat.com>
 <5b33b587-ffd1-4a25-95e5-5f803a935a57@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b33b587-ffd1-4a25-95e5-5f803a935a57@redhat.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B40CE180010
X-Stat-Signature: 1rbz6ypotqy8u3m3ztxzo6trpxig7goa
X-Rspam-User: 
X-HE-Tag: 1761219624-678134
X-HE-Meta: U2FsdGVkX1+yIhdlbBBb9mg+nd7OM92m5APzczl5aRnTS8HENjYe03uwLoh5KpAlUTTpggCeuKc7tC0MYxIOv2wwtuX99hRfSOOsR6yP2fcy0JDmatccbiXj3yNWkT5D9A+kAe4/5xWgOpahn36Avczb24c9PyEZwLbzmv1YGyaQasblEpsaZ0wUYe4gws+vDextZkCmWAR/IeUZW6l4UpssDsPI0sSXq2DTwhIPTntM+2gVQ1w0etq5/nQ/cIuhPgWwH/ZlMqlUfUZ8tpL6a71mNbCr36TymfxyZ2hzok3ERgBxFGlq9qUNlQGfU8SP3+7DE9JmNeKnjmnLZRErqWBgolg5wHDSeWlID7r5Y8OIyRIqTx1BLn80xcTETAo1TMsMZsDbffZ1m1SoHPJEnjnD8TMGOL5NudkJz11katmbozrlW7WXfp/DHg15m1l7KOgQowa6y9KhJ3XxSuhK9nvX0ppt/UzfNtJoyZbPoKdLpVjz8TxKtXuCg5pnkBX/mF0VjWhJ+17W9VvQCb3AXrxxcP7sNnEkrCyypgzeCD/e55gzRJs6XaJQAmPkEeRa9zYJ+7OdCDQYBh6INNH/TiVtTanoyjTmujRRoIM7+tu0T3JSVZdm50+payttBav20GHChHZlyg2pJ7f1WrIBde6yR682prXszUDavPq4FmypmTQer4J94EoOFfOxciQOAPcMHatNc/nn1FFz4LKwikTzkQqrvxXtErAW4z4db1A7+yvSTTf1DSIYBhp0nMHJpNq0OalnSJ0FSQJ8Ct8SIjkF765gAecbSGWHVNDHWjfoFP9NSZw8cbIGUOygR3qZ3lAOWH5MRu0WgkrAJqVweJZqcf3cbqS25Ck8jP6x9twpJI37pupkGOIeMfqpO0trASqyEnmCFuqqDkR5PhrV1NX/yLAj0xCFD4MoZLeEe3uDkBT5/e75iTrJDJcfK9UeZ5gDsHmGSswmna6dZBf
 LXkK8CX2
 6ZEtRWiU12Q06rHiFgIhvr7WJdZrlK59YvMB4RXzIHm4I/cVFUvRRYI7YWELgyYBF3seZyWPxWjmi/HzxYKHS/vMe0A+0fU86hiYj/mtYYlH10HjgR8tQd6t6zsjqp2NT00A3jyyhEXe4juk3iKMq8N0/3eip/fjpiJe50DTqn9E4o65XAC+ynANhMOOwYSQRCXJ0gPGRunEuxwWZYlGydd1TKB6DtZ2NqFtdQUm6Hqd1RCwt1CBDkFhvrau/R+WSZ2tX/qfnDCm+odnndbv+/LO5MDYEkjoXTVOvZKBh7y/vC0SE5PoRD090ArjcvXQYQkxd1OqEX16ZMJeNqE7nyWIs5OsxQTnJ5JZpS+879W3Zso4ToUcct4C5vN2g+XvCf1di4U8PmNLCH0pm1ZrEw2i6ySKFAFrA4uDKZURIkoRO5FE7PkCrqMc/SA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 01:11:43PM +0200, David Hildenbrand wrote:
> On 23.10.25 13:10, David Hildenbrand wrote:
> > On 23.10.25 12:54, David Hildenbrand wrote:
> > > On 23.10.25 12:31, Kiryl Shutsemau wrote:
> > > > On Wed, Oct 22, 2025 at 07:28:27PM +0200, David Hildenbrand wrote:
> > > > > "garbage" as in pointing at something without a direct map, something that's
> > > > > protected differently (MTE? weird CoCo protection?) or even worse MMIO with
> > > > > undesired read-effects.
> > > > 
> > > > Pedro already points to the problem with missing direct mapping.
> > > > _nofault() copy should help with this.
> > > 
> > > Yeah, we do something similar when reading the kcore for that reason.
> > > 
> > > > 
> > > > Can direct mapping ever be converted to MMIO? It can be converted to DMA
> > > > buffer (which is fine), but MMIO? I have not seen it even in virtualized
> > > > environments.
> > > 
> > > I recall discussions in the context of PAT and the adjustment of caching
> > > attributes of the direct map for MMIO purposes: so I suspect there are
> > > ways that can happen, but I am not 100% sure.
> > > 
> > > 
> > > Thinking about it, in VMs we have the direct map set on balloon inflated
> > > pages that should not be touched, not even read, otherwise your
> > > hypervisor might get very angry. That case we could likely handle by
> > > checking whether the source page actually exists and doesn't have
> > > PageOffline() set, before accessing it. A bit nasty.
> > > 
> > > A more obscure cases would probably be reading a page that was poisoned
> > > by hardware and is not expected to be used anymore. Could also be
> > > checked by checking the page.
> > > 
> > > Essentially all cases where we try to avoid reading ordinary memory
> > > already when creating memory dumps that might have a direct map.
> > > 
> > > 
> > > Regarding MTE and load_unaligned_zeropad(): I don't know unfortunately.
> > 
> > Looking into this, I'd assume the exception handler will take care of it.
> > 
> > load_unaligned_zeropad() is interesting if there is a direct map but the
> > memory should not be touched (especially regarding PageOffline and
> > memory errors).
> > 
> > I read drivers/firmware/efi/unaccepted_memory.c where we there is a
> > lengthy discussion about guard pages and how that works for unaccepted
> > memory.
> > 
> > While it works for unaccepted memory, it wouldn't work for other random
> 
> Sorry I meant here "while that works for load_unaligned_zeropad()".

Do we have other random reads?

For unaccepted memory, we care about touching memory that was never
allocated because accepting memory is one way road.

I only know about load_unaligned_zeropad() that does reads like this. Do
you know others?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

