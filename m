Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F0DDECD6DA
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 18:24:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64F9B6B0005; Wed, 11 Feb 2026 13:24:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FDB56B0089; Wed, 11 Feb 2026 13:24:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FFC76B008A; Wed, 11 Feb 2026 13:24:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3DABB6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:24:38 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 092F1D6BB4
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 18:24:38 +0000 (UTC)
X-FDA: 84433001436.17.4244C95
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0944BC000C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 18:24:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YSwi50FD;
	spf=pass (imf28.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770834276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8MvqNmSQwpT4/+ikv8C4uKJXx/Cpay4DtAwscanL//M=;
	b=DWgrpm2OWcT8OcZz92KH0pFBiZEM0L4wl9z4yoM8yy5j1RNqryPqWYqRl8WeUat2xkfqZW
	hpKHG9xEvhGXSRqeJgPpfUUVyCLMUCIIWHUi0+wFIsWBGhMeB3H7UfQ+tER7uZ3UmWjzAn
	eAnTKv+ELUWjlbuUSarc3GyulFgMv50=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YSwi50FD;
	spf=pass (imf28.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770834276; a=rsa-sha256;
	cv=none;
	b=QfkRHySQL7yPsK4ERzVm6bvuli3VqY3ADX52/tj3ZS7quGY4pYV2HYPnOfJ7R5PkIvpzgb
	wJg3PKOUiFuHCF6FyO3zqe8ktGiGQaUzNsw34HppsV17QGm9kWdhYE1IIwS3ZlynfPS84K
	e3WXaR83fWJFF8pytfKAHcVFe9Xxcyo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5FB2360122;
	Wed, 11 Feb 2026 18:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28370C4AF0B;
	Wed, 11 Feb 2026 18:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770834275;
	bh=HpiSg+mkwqHgx2x64frOPx+L7lBkmxTpS7thY1MR8H8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YSwi50FDOsk1M8piqFrSGHTqEtzTxSyhZiXCPiXDV2um4XknRBy9JTiuLBRG+UaBR
	 PaoxsAxaF81vnYM6yDQspUdBCwORgF9i7ifnYPM1PHNyPiC+GBgPeXFkFgMHfUQIgH
	 zt9F7PzzjlutkStzFYa5U+En1y5JyWALfn15c18mWq9NiYYyyRSAl1geZc9saD1UwA
	 gCtdofuUrjwyZ2m8+huGmuGbw/4zIvnTVy9OFE1TLbkhOy3aaAmjDyloG54c5wC+jT
	 mtKB5TC5OLBf50JrCdrzQQvKM+UJVhFO/1Pi+jOSogEZt6r7U9uHOBbO+8pArzRPn2
	 6BuhTa3Ew8jpg==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 46457F40068;
	Wed, 11 Feb 2026 13:24:33 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 11 Feb 2026 13:24:33 -0500
X-ME-Sender: <xms:YcmMaXsPKu4C8fwVMBpmz_YXB1komgXe9Z1xKGRHCvUfmGV8c5M32A>
    <xme:YcmMadUMhiP7rNy62978_pU0TBQ0PLdEVjgD3Cs0Ny9rhg6bTfsW8MEabjuu3DYdV
    rVzs8Iknza-eVX5Fw_bHNZIxOdgxNOmfXpaji6vznzZDvKEg_mG>
X-ME-Received: <xmr:YcmMaYXlInLkzrqucIVl0_oP0vvECdZTaR0kagIsSnTeYMqqtMiTHGKyhZOeDQBVk_bPlSUaXro6D_YHBySFr1kYW6E5fuzY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvtdefvdeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpeeuohhquhhn
    ucfhvghnghcuoegsohhquhhnsehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnh
    epteelkeejledtledtvefhhedtfeeghfeuhfeljeevffelgeeltefhieefvdeuteehnecu
    ffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshho
    nhgrlhhithihqdduieejtdelkeegjeduqddujeejkeehheehvddqsghoqhhunheppehkvg
    hrnhgvlhdrohhrghesfhhigihmvgdrnhgrmhgvpdhnsggprhgtphhtthhopedvgedpmhho
    uggvpehsmhhtphhouhhtpdhrtghpthhtohepthgrmhhirhgusehgmhgrihhlrdgtohhmpd
    hrtghpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphht
    thhopegrlhhitggvrhihhhhlsehgohhoghhlvgdrtghomhdprhgtphhtthhopegrrdhhih
    hnuggsohhrgheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepohhjvggurgeskhgvrhhn
    vghlrdhorhhgpdhrtghpthhtoheprghlvgigrdhgrgihnhhorhesghhmrghilhdrtghomh
    dprhgtphhtthhopegsohhquhhnrdhfvghnghesghhmrghilhdrtghomhdprhgtphhtthho
    pehgrghrhiesghgrrhihghhuohdrnhgvthdprhgtphhtthhopegsjhhorhhnfegpghhhse
    hprhhothhonhhmrghilhdrtghomh
X-ME-Proxy: <xmx:YcmMaYQHUOxucR5jbTDRgfmIKNOkSlP6eFGjLJ1UIeSXp7L-srXKCQ>
    <xmx:YcmMaXEkzIYMXeXUGXuM44BUwS-TDtJV8poDPC6b3zhxc68GIBiqbw>
    <xmx:YcmMaYRR_zENEXjwshpBzZUAoaDwYzFhbjOnjNJ0iMkaUz8s_vSF7Q>
    <xmx:YcmMaRqNX5MFLBFMC_9fwT-e3Xts55hgf99nzMI8U0BufmbIlZbGrg>
    <xmx:YcmMaeqASKp3Dm0cX16EDAZKK5w2uE65TScbe4pAKAN3TLcSNNxChRD8>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Feb 2026 13:24:32 -0500 (EST)
Date: Wed, 11 Feb 2026 10:24:31 -0800
From: Boqun Feng <boqun@kernel.org>
To: Tamir Duberstein <tamird@gmail.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 05/12] rust: xarray: use `xas_load` instead of
 `xa_load` in `Guard::load`
Message-ID: <aYzJX5OML418GYsg@tardis.local>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-5-f777c65b8ae2@kernel.org>
 <zqo3qcdqlrxnqxl63kqeuvdacpbbywdrcir2kfwh7j6zvbfuq5@wspy4e75axfz>
 <CAJ-ks9njGhT85pgUSahki989Y9vn3XOBNO5wxB8wE+KvbL00wA@mail.gmail.com>
 <6sd4numrxigibwynr2lfmtdj5uabggrx2l57igtjbnq4uwddrm@wipmwcmqbkjn>
 <CAJ-ks9knC3pKpiMaG6f3C1Kr6su9p26hM7YvVMzsVwYVHGtm2Q@mail.gmail.com>
 <CAH5fLghKwNEdVeRi3H3LQ9NTPYprpAeY41-jgfq8YEST9PaGdw@mail.gmail.com>
 <hq46fcdy6zvwcwlbtbjynqadiwy3wjs7raxioime2et5amzez6@wvzzlkiijwvf>
 <aYzDzeh1cTN2TEVz@tardis.local>
 <CAJ-ks9n0-Uy0n7CsZwPr37PSc_wo5qYG2YGVsGN50oPZN4MrSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ-ks9n0-Uy0n7CsZwPr37PSc_wo5qYG2YGVsGN50oPZN4MrSg@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: 4ua99r5b3rths3sbuzo8dyhek8gimfds
X-Rspamd-Queue-Id: 0944BC000C
X-Rspam-User: 
X-HE-Tag: 1770834275-388645
X-HE-Meta: U2FsdGVkX19pBusMpFoBoo0pMItRKrPO6mduqOtlH/l/sdXY8Irqa3KbX8lQCsiU4xg4RvsBVo/97EUBHchGyZzfGIorVB5782gCn6vJkUe3x3DQNQyDoVBCMPbZTikaP7Dui6eSKBxwuG1HHuFXp3kTd9yP0T7tTIWVvbvgIELZu6yUo1Sk/7JXnV16bJ7iP2ys56+NniRKkCBNlLK7Fiy6iWXajH/1+Vxa5aMm+lRj6viEmiE3h5HngKeSAjcUWevdzUY/TFh27AWHWfXgqdm0Gk78yqGvXmmlI+jPVPj1qpqtBvk6Yea410aVTd+xORea+brnAvD+Ax9q1IwSG1+Fm16dAl5RjYt/KyxNxJ61qRG5bj/385KIZQy51KdplctRd4wnCXPzeUv3x2DfYGL8Yh+Zilgrl9xDmHHsUVp2+NHZzwGyBShdrAgd6Wcj0Uc2MMAu8AAMsDjhoUUSymYvAf1yqesQOANz2RAA4pGuUsdBR94X1l8/6V0z92R9ssQOdEUmB8t6K8Id1WQlY+uS3JrUxYjLuG5Nb5+BKl3YaV/xCiXeAIMpJwNi30a7/o7IFlAjggDjpiCFp4t+ghM6JA14XU8kLScGWVTBjDmj744NnWG7blNwrrYT5DY+rxU4Hf2XlwscV6th0J5VVV8fZ+X9jCi0kmKU5XF+JP4BzvXYHnxL3PO46F6M+YSzLHIpQZiLcX5DQPZrDgFuLCdvmDoX+Mc8kyOrhf3IWUFkBF7BxgG63953EBiDl38TPN1mJpIOBhQ4ZG3rdPCeVzJbMTLj9Sm3YKhqdqycbzg6z6cxwLU7imnwB9GOy0P8FG1ciSFWl78syPaJxLjcO8/2H0/UKoDAQcaJr4LdFv/KgL1GzM/P3oL+jziRaxAy5uHBN/O6pOKaHj7inSCWysaiPQXwOovoj/bAgzJxZMBi0DGmQx7Il32Deu22bS9cWj/Bv5fbcErhqnK1JpL
 MQEKIe3M
 L294E9uRGBmTV/2EcoU5IrQSN2X+mFzkwBnM5A2Xahq7R8YOAK3G3sfDGDkB1k+T/YrQNWKCa7htCnRUqaKDaHKHKeyOg73ApUWheEdasdvkek7HWkxV3oHEhVQ3mVKm9iiotFnMjWbULqVlVMigSYR604zMk/H/roY+sDY4rO92+5A0Sq7l+lOS1C3YwkEXnak/ThGd+mRLkNJQM83ZMK5QpWavLdNQZTrK9gHmDpy3P5JII8ugdKXJc5hMPIEczdz3tvXiPj9zdDMjDxHLUhbU1/v3ze6fYOV2JzDtZRfirxgtkg/M1q8oZKduJxTXWLIO5owMBjRBxH2OZDf0sSvGR4Gcn5OVO5/3H/3XgaPqI3xOlrABnjaqPdtBroTmv8PpzU1m0qm5bWIAVrvKcKd3lTMAR65waj+IZ/FfYCr7jf9dAV3nm9Q6jqhm5aUAIbjQl8lETET2SDqs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 01:19:23PM -0500, Tamir Duberstein wrote:
> On Wed, Feb 11, 2026 at 10:00 AM Boqun Feng <boqun@kernel.org> wrote:
> >
> > On Wed, Feb 11, 2026 at 09:32:36AM -0500, Liam R. Howlett wrote:
> > > * Alice Ryhl <aliceryhl@google.com> [260210 16:34]:
> > > > On Tue, Feb 10, 2026 at 10:23 PM Tamir Duberstein <tamird@kernel.org> wrote:
> > > > >
> > > > > On Tue, Feb 10, 2026 at 12:59 PM Liam R. Howlett
> > > > > <Liam.Howlett@oracle.com> wrote:
> > > > > > Is this a temporary limitation?
> > > > >
> > > > > Maybe? I don't think RfL has good abstractions for RCU yet. For
> > > > > example, exposing load directly on the xarray using xa_load would
> > > > > require a way to guarantee that the returned pointer's target isn't
> >
> > Well, if we only return a pointer, we don't need to guarantee that,
> > right? Because it's up to the user to provide that guarantee. So we
> > could have XArray::load() (not Guard::load()) that just calls xa_load().
> > Also see below.
> >
> > > > > being concurrently mutated (e.g. under the xarray lock). I'm not aware
> > > > > of anyone asking for this, though.
> > > >
> > > > It's relatively easy to add an rcu-backed load using the RCU
> > > > abstractions we have today. I already shared an RFC containing such a
> > > > method for the maple tree, and it would not be much different for
> > > > xarray.
> > > > https://lore.kernel.org/all/20260116-rcu-box-v1-0-38ebfbcd53f0@google.com/
> >
> > I need to point out a difference between xas_load() and Alice's usage
> > (also what Tamir mentioned above) there, what Alice needs (at least from
> > her patchset) is the existence of the object is protected by RCU, i.e.
> > if there is someone else dropping the object, a RCU read lock would
> > still guarantee the access to the object is valid.
> >
> > However, the internal RCU usage of both xarray and maple tree is to
> > protect the *internal* data structure if I'm not missing anything, i.e.
> > an writer may change the array or the tree while a reader is reading,
> > the internal structure itself is still consistent and valid. But the
> > nothing guarantees the object you read is still valid. For example, you
> > can have an xa_erase() racing with an xa_load():
> >
> >         <writer>                        <reader>
> >         ptr = xa_erase(xa, idx);
> >                                         ptr = xa_load(xa, idx);
> >         reclaim(ptr);
> >                                         use(ptr); // <- object may be gone
> >
> > the users of xarray needs to use other mechanism to guarantee the
> > existence of the object.
> >
> > In Alice's case, she in fact used an RCU read side critical section with
> > a larger scope to protect the object as well, which is definitely nice
> > to have, but not only way of using maple/xarray.
> >
> > > >
> > >
> > > It would probably be worth having two loads then, one that does
> > > rcu_read_lock()/unlock() and one for writer/advanced users like we have
> > > on the C side of things.
> > >
> >
> > Agreed. But we may need more ;-)
> >
> > Here IIUC that Andreas does is adding a `load()` for `Guard` of
> > `XArray`, which is the load for a writer and most certainly you won't
> > need to take an RCU read lock for that. The load of a reader can be
> > added as I suggested above (similar as your "rcu_read_lock()/unlock()"
> > suggestion above), but no object existence guarantee. We likely
> > need a third API that can provide the object existence similar to what
> > Alice had in maple tree.
> >
> > > Or at least name the load() function to indicate which is implemented
> > > today?
> > >
> >
> > It's a namespace thing ;-) , the function in this patch is
> > kernel::xarray::Guard::load(), and as I suggest here
> > kernel::xarray::XArray::load() should be the same as xa_load().
> 
> Just to clarify: `kernel::xarray::XArray::load()` does not currently
> exist and no one has yet asked for it.
> 

Yeah ;-) I meant to say we can add it if there is a user and we can use
xa_load() to implement that.

Regards,
Boqun

> >
> > Regards,
> > Boqun
> >
> > > At least on the maple tree side, we have both interfaces and users for
> > > both.  I just found the change to remove the rcu safety odd because I
> > > assumed both are needed.
> > >
> > > Thanks,
> > > Liam
> >

