Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8863EE4983
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 16:05:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D72596B0088; Tue, 30 Dec 2025 11:05:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D33226B0089; Tue, 30 Dec 2025 11:05:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5F476B008A; Tue, 30 Dec 2025 11:05:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B1E2B6B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 11:05:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32339C13E0
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:05:48 +0000 (UTC)
X-FDA: 84276613176.18.FC329D1
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf07.hostedemail.com (Postfix) with ESMTP id 37CF540010
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:05:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Gi5zblY7;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767110746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MG9ep1clevva76W2JMLv7DULyp0iwWN39Gin1y59CsU=;
	b=FECO4O9iKnlblxmnfvoebs5vc5GPTMVkVgo9ARKXu6qUzAwp5V4Jqnortia+4dUF4Bggz+
	JCtLs4f4m9oLIJQNw4nDrJ8xWNSYXOA9Hlh5NDtXaY2B1EjK8JgycWbLiqx9vdMYk+cpy4
	s6Ic14ayzsf+PiPnxr+vfDhTNFmy55I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Gi5zblY7;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767110746; a=rsa-sha256;
	cv=none;
	b=f61aRu9Z5T4Z7PXpjzl6vr6YsMo4HDpgzTWfJlkgvYCne28PA+1YSUEuQUgOxKtRCx2SyC
	M3Y27YcOptXSyqm6gExBF6iIDHW/K1AohSTwGAQ6+8Km076V37ZLBahYtkkQWi4dR1MInd
	99pJJgwHyVpQ0OwM4Od7F2x7piDrFeY=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-64d4d8b3ad7so10661759a12.2
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 08:05:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1767110744; x=1767715544; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MG9ep1clevva76W2JMLv7DULyp0iwWN39Gin1y59CsU=;
        b=Gi5zblY7gLSXImHiOorRPXwIK1pdEAkCaU/+gDfUM8kV9TR2PNsxkQORKcbBNc6vzD
         LfFiY2FN0n+Z8DV6mEGj3jC5PNe5clW/Zr8qjMk2RQ4l7JmHF60QzK52oBoB0YY7IKIs
         HqiciA0m4VMwRrXc0mTR0lhKc/FAMoFPGL0v/X57qzPLhuFdNnt2a1poIpf9aMIRLbXj
         BXQerNs9T7C7bjMZYyUtR0lWfveDIn+yDeIUY7je+RLDD2lKXst0J9tPTjW7DfRjEbXk
         MgoDsm6lU8MCugZnU6eyJkdp6d/KkNVZjrJsgULWyll80lYsBOdjUHBFgb9wmJreEE15
         Xn4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767110744; x=1767715544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MG9ep1clevva76W2JMLv7DULyp0iwWN39Gin1y59CsU=;
        b=FzNib2H2Qa2jUqYxcXDtfpORh5a5MOW0ReJp0pB3DxovRzKV579vQrf2kQBeoYQza+
         3kvohIUjhB1qOuHpu5GpLEDLacnQ/bshO2MBcIELcILxRqJABTD0vaotuRaWsncNpWpH
         xutBfPCSfn+g9ztyQV3SPoz4fQAWAtSY7HPe7qPrTupyEjUbLQZ7TwoKmtU0H4UibH8p
         EMfFCp9f6SijtArNJr5bmzr4XKX8iA/eob4Cxc4eIJzTDf1mb79dt8U5+88j1RZPGGug
         g8WSWD/b2yt5AT8NR27COjE7rQrWyPwtSJkajKi7It747qHgETwoJ5t1ztMSozoBjHmu
         qhgg==
X-Forwarded-Encrypted: i=1; AJvYcCU9m3kBEvQB5S+onpibi034A4QVfdi9OT2OlZkH593HREkoeH4LpzFmqbtw9w6ZZHdjzASWlYyqnw==@kvack.org
X-Gm-Message-State: AOJu0Yxt+mmLX2ASccyfpmDA3K5Qwp0Mx1gvOfYVEoL6MFePPvgdpif6
	tUJHd2lNwLCf56FRDwK1eqINWUMm4oHRQyTYFZ6m1gO0aR7kLIJr6blKWKg8aXlH4yn7HcDZEH9
	EBHUZBVRIhAlo39SnqTLG3pNw62YRbmGV5bxEc4ITSA==
X-Gm-Gg: AY/fxX5LkJ0WyI3trzwQMFAkdO061htQnKNfuPYZyAJnupYhbyKJShyVd4cLRy+S0KO
	jiMMa/vags2N6kib49IWyriPCL4t3ujB+onjwq+Yb73YexAPmG/ANsyxXW+bKuns3Z6UITVw/CO
	yIudrJTrgR0FBrKTCLUt8cdO6p6fi0jJsXwKNSpkvEU67JSgNEQQdrhPJ21/NXRnZniPAtSekME
	GrNRid0fc/oApX25Ph/p9q8MLi7CxauiQQN9KcCwCgRE+DlYNAJ1ivfX7QUqqsFwRoyTSqi8b2Y
	Mowmylbdvd9GybwMFwKRhIGNwg==
X-Google-Smtp-Source: AGHT+IEk6loJ8MioiHKAz7Z1lAv4Moi1oxuZ50QtEDcPJb50FtdSjNb551AAnS3pgJz8xEVU4lrLrK22GP7GJzibBQA=
X-Received: by 2002:a17:906:eecb:b0:b72:588:2976 with SMTP id
 a640c23a62f3a-b803720eb72mr3632708366b.60.1767110743871; Tue, 30 Dec 2025
 08:05:43 -0800 (PST)
MIME-Version: 1.0
References: <20251216084913.86342-1-epetron@amazon.de> <aUFJH9xzJXYOt_X8@kernel.org>
 <CA+CK2bDGvgcGJijAtSSa2k_FWjnZXm2jRiFd6Z9-XjEQ-Y68DQ@mail.gmail.com>
 <aUF4fsWwD9BswkFh@kernel.org> <CA+CK2bB2mn5b0N9gs1UavYLUQhbpVvdo702oHZa15E9OaZkKWg@mail.gmail.com>
 <aUUYprAotKYMiEs0@kernel.org> <CA+CK2bD101cSC_7+OWkMei2QvUVjSaRLy+LboLe8Sz7KS3by4g@mail.gmail.com>
 <861pkpkffh.fsf@kernel.org> <CA+CK2bA1kYCf0BwhX3Sg9Ur82nK-7HPzs0sg6xbVWFAJaZLhpw@mail.gmail.com>
 <86jyyecyzh.fsf@kernel.org> <CA+CK2bDxnTEe9Ohq5zLuyF-jqgD0DPhfdq6z=yztUsXU5p5fSQ@mail.gmail.com>
 <863452cwns.fsf@kernel.org> <CA+CK2bCjJWZG_rPoPsHWSxirmUCTOuFQzTCss2AKf9UqpThrdw@mail.gmail.com>
 <864ip99f1a.fsf@kernel.org>
In-Reply-To: <864ip99f1a.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 30 Dec 2025 11:05:05 -0500
X-Gm-Features: AQt7F2qh8Tz1-V6SEVQcAtjpTVrAQuZA4_pz9Pf3y-k5HVASt8V4EiUMlmt1L-Y
Message-ID: <CA+CK2bDDEZ5a+LJNDVMtKFtQ1D9rP6rJqU064eoru=a9eHpaAQ@mail.gmail.com>
Subject: Re: [PATCH] kho: add support for deferred struct page init
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Evangelos Petrongonas <epetron@amazon.de>, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jason Miu <jasonmiu@google.com>, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, 
	nh-open-source@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Stat-Signature: e4qr5x1i3pb5gygocqhrnp9a7bx7d8s8
X-Rspam-User: 
X-Rspamd-Queue-Id: 37CF540010
X-HE-Tag: 1767110745-590297
X-HE-Meta: U2FsdGVkX1/l+NO1KQILaE2AYcrse870OIjXWZwILr7v5jFaeC2TOx2pJCLkT1XcXbt33WkLkz09DmwfAymr+LhtWOWjzXpmqAR7U474RwrMiMax/1GM7MCqQ42e17ZstWlwDCt6lb1UINNKHBJ72a/h1EtEb4d5ZeW/VIkvzbvk9SNXwAUxzvo2h4XMROipJQVJGrbnSCm5s2Lox9xMMIv4+VC4X+753np285th1WuoAzY9m+gjXyUxkGoowb784sr/KpViAwAlMn2WVH2ijTAjuJoZww+p1D48xv3X7wD7LFQ+f0+8PJtSvum5MNN8g60mqPNwBNd4n04cUhJ0+ZHkuDbF+5ppns36/7JAqscG512L75TgZ3kt0q1il+68ULKkX6ZU/E3SCoZ4dOrhbTYuLWtSodC78wt64MGuUFhpJm/0yMVM+hIUEmAXYUF15t1ZXiW9hWr0kj4Cypv6zq9tjZWmO1PS3Q9KeML+YvL+Z2n3rEr+vfZyOaimukfvOE+iCnisUwVs5h/cjBc1onglbqE0Ovg0Nx28pvpaWbyy5sLo+naJajHhRBugUO/Plf6yFCwjnfshlGAVgUpFXgUulWobAX71jKvpFDcXa/tvg3VFWbClQjCi3emjbRr7DKTX3AHwt2SJaQj0LNx8+bkUbwJ75yAzocCbP7MZ0bC0AS5xSqUiSG+HgIqjM/RlUTdVDb5FLbw9GAJkR9CoRm+H+dDRRM8t0V0ANn9RbSmQE1tKRXIKCtCPnJ2lH1WiZk8j1/pE/DE2HpfwhXO1fTLmsgOFbKRQVQJsPxiUtgHCTs60NYBt2H+DtX/3NY0/GiC3j/V5wN7Vw7q2RCsO4h0gN8frVuWnxqAwmO0v1KSiHYXq4SmBHHheLCnaH/0D0O7UsdppAhFbTm2UPbQdaRVuUPUnL2agvucL2TVycrqEY+5Po+W3ySPA/vgUS6edaQ2eNOn8Nv90u/Nt7TJ
 c6wLIymW
 bmKqQs7YnTTca2knFY+8EFcvGYIdc1GqseH9efhzGhyJqMtsLRwx+hxK4/I2Wc0pWQ1qD9fZBppNi7rpzwyyxw6wVrkiGeMhhhGDGXosu9/25+ORoV/5K+v5f4RFX2YolTcKZ135+QS6Wf9cYeK3RtoMoi/jzg5LKBa3qTwkS3CaJTnpiR6XsTEAClNBQsU4ueHqSrhSrRiMSfkpEZ1RK6TAC3J9DVpD+cltKbVHdQrkgRZSo0R/8ybFxXZ/rpTQyRgld5t5/dlEYUPGHmfUplIv6rVH7wp52Rgwe/mTxy9PQN8g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 29, 2025 at 4:03=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> On Tue, Dec 23 2025, Pasha Tatashin wrote:
>
> >> > if (WARN_ON_ONCE(info.magic !=3D KHO_PAGE_MAGIC || info.order > MAX_=
PAGE_ORDER))
> >> > return NULL;
> >>
> >> See my patch that drops this restriction:
> >> https://lore.kernel.org/linux-mm/20251206230222.853493-2-pratyush@kern=
el.org/
> >>
> >> I think it was wrong to add it in the first place.
> >
> > Agree, the restriction can be removed. Indeed, it is wrong as it is
> > not enforced during preservation.
> >
> > However, I think we are going to be in a world of pain if we allow
> > preserving memory from different topologies within the same order. In
> > kho_preserve_pages(), we have to check if the first and last page are
> > from the same nid; if not, reduce the order by 1 and repeat until they
> > are. It is just wrong to intermix different memory into the same
> > order, so in addition to removing that restriction, I think we should
> > implement this enforcement.
>
> Sure, makes sense.
>
> >
> > Also, perhaps we should pass the NID in the Jason's radix tree
> > together with the order. We could have a single tree that encodes both
> > order and NID information in the top level, or we can have one tree
> > per NID. It does not really matter to me, but that should help us with
> > faster struct page initialization.
>
> Can we use NIDs in ABI? Do they stay stable across reboots? I never
> looked at how NIDs actually get assigned.
>
> Not sure if we should target it for the initial merge of the radix tree,
> but I think this is something we can try to figure out later down the
> line.
>
> >
> >> >> To get the nid, you would need to call early_pfn_to_nid(). This tak=
es a
> >> >> spinlock and searches through all memblock memory regions. I don't =
think
> >> >> it is too expensive, but it isn't free either. And all this would b=
e
> >> >> done serially. With the zone search, you at least have some room fo=
r
> >> >> concurrency.
> >> >>
> >> >> I think either approach only makes a difference when we have a larg=
e
> >> >> number of low-order preservations. If we have a handful of high-ord=
er
> >> >> preservations, I suppose the overhead of nid search would be neglig=
ible.
> >> >
> >> > We should be targeting a situation where the vast majority of the
> >> > preserved memory is HugeTLB, but I am still worried about lower orde=
r
> >> > preservation efficiency for IOMMU page tables, etc.
> >>
> >> Yep. Plus we might get VMMs stashing some of their state in a memfd to=
o.
> >
> > Yes, that is true, but hopefully those are tiny compared to everything =
else.
> >
> >> >> Long term, I think we should hook this into page_alloc_init_late() =
so
> >> >> that all the KHO pages also get initalized along with all the other
> >> >> pages. This will result in better integration of KHO with rest of M=
M
> >> >> init, and also have more consistent page restore performance.
> >> >
> >> > But we keep KHO as reserved memory, and hooking it up into
> >> > page_alloc_init_late() would make it very different, since that memo=
ry
> >> > is part of the buddy allocator memory...
> >>
> >> The idea I have is to have a separate call in page_alloc_init_late()
> >> that initalizes KHO pages. It would traverse the radix tree (probably =
in
> >> parallel by distributing the address space across multiple threads?) a=
nd
> >> initialize all the pages. Then kho_restore_page() would only have to
> >> double-check the magic and it can directly return the page.
> >
> > I kind of do not like relying on magic to decide whether to initialize
> > the struct page. I would prefer to avoid this magic marker altogether:
> > i.e. struct page is either initialized or not, not halfway
> > initialized, etc.
>
> The magic is purely sanity checking. It is not used to decide anything
> other than to make sure this is actually a KHO page. I don't intend to
> change that. My point is, if we make sure the KHO pages are properly
> initialized during MM init, then restoring can actually be a very cheap
> operation, where you only do the sanity checking. You can even put the
> magic check behind CONFIG_KEXEC_HANDOVER_DEBUG if you want, but I think
> it is useful enough to keep in production systems too.

It is part of a critical hotpath during blackout, should really be
behind CONFIG_KEXEC_HANDOVER_DEBUG

> > Magic is not reliable. During machine reset in many firmware
> > implementations, and in every kexec reboot, memory is not zeroed. The
> > kernel usually allocates vmemmap using exactly the same pages, so
> > there is just too high a chance of getting magic values accidentally
> > inherited from the previous boot.
>
> I don't think that can happen. All the pages are zeroed when
> initialized, which will clear the magic. We should only be setting the
> magic on an initialized struct page.

This can happen due to bugs when we use a partially initialized
"struct page", something that Mike have been looking to do. So, pass
some information in a struct page before it is fully initialized.

> >> Radix tree makes parallelism easier than the linked lists we have now.
> >
> > Agree, radix tree can absolutely help with parallelism.
> >
> >> >> Jason's radix tree patches will make that a bit easier to do I thin=
k.
> >> >> The zone search will scale better I reckon.
> >> >
> >> > It could, perhaps early in boot we should reserve the radix tree, an=
d
> >> > use it as a source of truth look-ups later in boot?
> >>
> >> Yep. I think the radix tree should mark its own pages as preserved too
> >> so they stick around later in boot.
> >
> > Unfortunately, this can only be done in the new kernel, not in the old
> > kernel; otherwise we can end up with a recursive dependency that may
> > never be satisfied.
>
> Right. It shouldn't be too hard to do in the new kernel though. We will
> walk the whole tree anyway.
>
> --
> Regards,
> Pratyush Yadav

