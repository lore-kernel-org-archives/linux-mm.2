Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A31D6C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 13:42:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4100E6B00C8; Tue,  4 Aug 2026 09:42:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E8116B00CA; Tue,  4 Aug 2026 09:42:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FF466B00CC; Tue,  4 Aug 2026 09:42:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 139C16B00C8
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 09:42:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D262120178
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:04:13 +0000 (UTC)
X-FDA: 85063605186.01.D44A2D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 05A478000C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:04:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aZ8xZk5P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785848652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7WVi0zd6LcUoDLabZYLULWttoR4Wlz1WJNokp6HKtFM=;
	b=tz75yCHqtG7V5BQcjQRSZl0RQ8D1snMVIoykM5znKL5B3GpAtbF5C4txGUBq1QNBotYYzx
	7qk7yak9QSOw1uEH5sMb+BdI7A9rHqrAsRp8oA7cXjpz7jwRc63e+uTnFSlGfU6zHESmhA
	mRduyD59lEHhjbPQ0I16t4mI8QGidP8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aZ8xZk5P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785848652;
	b=hp77iQhcNwkfj/hfvUYmMrB4vhG1wZjl8t9pboIk+5npmPyFvMMciR/YYciloyzEOn4GZD
	4jICgQFK8aJucprc+2XPZdxGmkE8W0O+GA5p9MmofsDoj+DNWqQfatjPRRxXUpNy25cASI
	RsneURbG5TFSg6MOI5gt2EafJUfifmY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BD1460A7E;
	Tue,  4 Aug 2026 13:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41DAB1F00A3D;
	Tue,  4 Aug 2026 13:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785848649;
	bh=7WVi0zd6LcUoDLabZYLULWttoR4Wlz1WJNokp6HKtFM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aZ8xZk5PzuGz/b2moWBb4VVtz0n3Ung2XSO7gIhRagGOIZjNIMkuzHy6jFMeVHTWF
	 nA1BvJi/iE2VrsC4XD17lCgxplfi63Afoif31Yj2W0EGlxUQiKtKFRwnI+14Z77Zm/
	 wyREeQLepUuHknwIHKHs5MtSxkyB6+MmQecXZ+aqfDSvp48OtiFS+A/zUg63hoVMix
	 vyCQNYITywtcPJ3HpjO2neSJHyvnHkv687QC8xcOOIa/gki5DxBEwggQe/7XGb0akN
	 nzWsq0j8rO5RTc990ehdmT0keE1zCMZ4cmTlxK1aOc4jA6KVyjsh2uKeL8OyzltUDm
	 Jyzl0tvAyFYNw==
Date: Tue, 4 Aug 2026 14:03:47 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Helge Deller <deller@gmx.de>
Cc: Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	John David Anglin <dave.anglin@bell.net>
Subject: Re: [PATCH v2 2/6] parisc: Drop own implementations for ptep_get()
 and ptep_test_and_clear_young()
Message-ID: <anHi9n3_8bLjAsxy@lucifer>
References: <20260803164400.531199-1-pfalcato@suse.de>
 <20260803164400.531199-3-pfalcato@suse.de>
 <anHHyiHqYf3yLf2K@lucifer>
 <anHcJZYyz9Zrshdm@pedro-suse>
 <anHd7ho3daZFZ-4r@lucifer>
 <e7ac6f83-72ff-43c0-b67b-6b17caed995e@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7ac6f83-72ff-43c0-b67b-6b17caed995e@gmx.de>
X-Stat-Signature: gy7hua9jj8fh6uuczy58w11h3pn89au1
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 05A478000C
X-Rspam-User: 
X-HE-Tag: 1785848651-569544
X-HE-Meta: U2FsdGVkX1/qz3UX6rFIvmlpoh0DYpyIj94MPcy4GTX1Nm0g1l+lVl/ShBNYLnrTpvdQPj88ajba3Rp18lnaKhNtLOKYxyQspgqNaiXA6iNMYiz9CniN4/cDCZwzN4OIoEuUuNX3BkJLTJPmrgptUMggLExa3JzWIxh7KM5njF+4KblLu90Zy62SVHitputKQ4Gv72GxZMLdgvUJcgJGlaVIr3lP1SLIh6YCmwYjwlPYQ/e3MOyoIbV17SHD+kAVu60f4XsiQcvBV2tDzga635GoThnZcBJNstjRcQaVcTzUt2nznaKnJ2pHT/oyn+L8nxPLUTdEP7OgwV/pWB/vXWkuxqZqy+FcLUwhLM/0A3w4VqsFdJes+EaDyk0itPvBQ/k5VFwnb8oeknhErDmz+haF9/zwRauAIGnv6ZKjzbDTQnNCG/JxOvB5cifN1WVJtQXsjxp5C4GNJAWlYmcNbvDIkm/Z3xiNHmVc/qrzVrpRjC27dFc/3aiX5nKOcKvzgzjXmOyOwn9QTEyPzNOZxUYD+TcbvyG6YMoN+ODGyvv8WqbFB4Mm0RpIu41GvP5fBSCLmEs3UOOcZpyCm10QPJp0SN2ebpD/1+A/WN7Qh0YyvVjkgy3D0XglXGNDqOetRP5vzk4SbLXXpXwLM6OUchlkyPDMx54I2XG7J204YfZScbcTXSVB0xUz0Fc/VYV49oIMq0lIG4odYGp5ReyWoef4mhnZNQ2x/nu1clmcp2qQYpaCRyAevMlcRGv31x44yB6RitJQTbPsScMu1bmGc0TOW1rmA2R8amXf/4FeTfV2XTwo1ticwFx2r7ubtb3uONRi1KcVrVJgdlVChKrNj2MBH3GKwZuyUAodB5md4I0Y3fb6kdcLsE8Gn6cqZrUcDGXNl0o9j9zU32Cd2Auc75R3o5UHlnW9IqWb++z24cgcfZFp6dETqGrBNktOUmE6oH42q7g0ylaH8lKcLGj
 7effXlSq
 iEDvPg3ltuPDDW3VRkgTRNQevWs6G2yM6q1YEvQTjVr/FNos7C+pmoivDbyYkJs5NOjcrKP4N0+Gbcj8R9lqsTbXSjB1YPDqr3sZElNnTzgcHyHE7pkjlf8XmwfE9//LUzAWZhHD/STx6agY2WM3Bf3NZQ4RJoMLlB+9a0JvyIZo3q/UaFz/h0DKQnD5aCbcZpG6jFNhiehkWfLp5cCnpKHQm0fu/MmeXwkz/nDR9VH1LqaljFRhlzDBwjREiDxerPt2JX94Dp7fEGAFvrwGF9wdv3j0vqPQxjMwwpdUVaaGFbnpt1bYEDQOEyiX88E/NvwPz5GcosougAWPaR5X4gNhkGNQkkVTdZQK7l0Kf7R28CaIFwxm4NnE02A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 03:00:43PM +0200, Helge Deller wrote:
> On 8/4/26 14:42, Lorenzo Stoakes (ARM) wrote:
> > On Tue, Aug 04, 2026 at 01:34:41PM +0100, Pedro Falcato wrote:
> > > On Tue, Aug 04, 2026 at 12:11:08PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > > On Mon, Aug 03, 2026 at 05:43:56PM +0100, Pedro Falcato wrote:
> > > > > From: Helge Deller <deller@gmx.de>
> > > > >
> > > > > Switch to the generic implementations, which are identical.
> > > >
> > > > You sure do like succinct commit messages :)
> > >
> > > I didn't even write this one! See the From: :))
> >
> > Lol well then feedback addressed to Helge ;)
>
> Noted :-)
>
> > > > Maybe worth saying by dropping the __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG and
> > > > ptep_get defines you get the generic versions from include/pgtable.h which are
> > > > functionally identical.
>
> Isn't that basically the same as:
> "Switch to the generic implementations, which are identical."
> ;-)

I am being _exceedingly_, possibly outrageously pedantic here :>)

>
> > > I can touch it up though, if you insist.
> >
> > Yeah, I'm being pedantic here it's not vital to have this change :) but be nice
> > if you could, I'm sure Helge probably wouldn't mind too much? :)
>
> Yes, I'm fine with any cleanup/rephrasing of the commit message.

Thanks :)

> Thanks!
> Helge
>
> > > > (Being pedantic, they're not quite strictly identical as the
> > > > ptep_test_and_clear_young() generic function does some weird unnecessary
> > > > indirection with a local variable and the single {} is dropped etc.)

--
Cheers, Lorenzo

