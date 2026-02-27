Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75581FEFB47
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 13:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4F1C6B0005; Fri, 27 Feb 2026 08:30:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD2136B00A7; Fri, 27 Feb 2026 08:30:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DE426B00A8; Fri, 27 Feb 2026 08:30:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 86A816B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:30:35 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A11F1B7B4A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:30:35 +0000 (UTC)
X-FDA: 84490321230.30.E6718ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 912E8180002
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:30:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F9ZwxSbT;
	spf=pass (imf24.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772199033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=98QeL5EOgKUfD6Y7Tfg8Kr+z7WT1vD+vkh6/6nXWf9w=;
	b=D1dZOPkJPaphDQUACWurGjnOHqE/VlQzsQHC4Qe06N+pEZu49hkFA1SNQ8M37n+BzhoYC/
	vEa2XBObBMLYWn/ed/+hdU4FvIgL4z9b8bv/NoOvuBqC+o95vMVj6kC+WcPG0z5hDJiAtR
	If/VnmLohHywE8SnR2w/+rwoykLZgmo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F9ZwxSbT;
	spf=pass (imf24.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772199033; a=rsa-sha256;
	cv=none;
	b=rihOg1P6oGAvzeGvHXWU2IZwnhJ/H241w/6oUWHpQFcxzw2EQYzt0kuHXpX2+gG0+DE7Pg
	9FqFOBUs4F0ngnqw54e9r8X6xnP3GI+eFP0x8boSpsR1VHRXWxXx9PI5MYSvHgHbC3BZYy
	wewOFmzJVaeCkCH/wOsEDS8TU2YaGdE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 04B5F60008;
	Fri, 27 Feb 2026 13:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD5CC116C6;
	Fri, 27 Feb 2026 13:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772199032;
	bh=n4yX5l6q7fUwZBwFYRwfHjLdICdDCZUGrXzVl1z1sXg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F9ZwxSbTgLHYJpVWUuDP8wbZwcQB05N9yCc139iBS4j42M6KY7s3p9hu4NaBCEhuo
	 nm64rd+BuFeAnRt6r+oAAilijlNBgCpQX/8Vios1yk4BLbTekn169/1BPUBUTrR+T6
	 1g+44JrAY8+QcLwWcfR3VxE5sd7R3JpFvEq6uKMV8Bri2YlpIDYwvuMsAwFXM3JWGm
	 pewISR+4xeDio4bgZyALFItTtDfth0boMVvgA/jMury2H1cdCtzDDjLySkXPykIZDr
	 GGH1R7bvtv2st3HjQYncwcWM8GG61yNVbeKUuKLEXbAjzt1mCuvoy/MV8W1sqRTXFA
	 7QBd9EokKi1AA==
Date: Fri, 27 Feb 2026 14:30:29 +0100
From: Maxime Ripard <mripard@kernel.org>
To: John Stultz <jstultz@google.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	"T.J. Mercier" <tjmercier@google.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
	iommu@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH 0/7] dma-buf: heaps: Turn heaps into modules
Message-ID: <20260227-psychedelic-tireless-herring-0adfa9@houat>
References: <20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org>
 <CANDhNCqk9Uk4aXHhUsL4hR1GHNmWZnH3C9Np-A02wdi+J3D7tA@mail.gmail.com>
 <20260226-adaptable-vermilion-nautilus-0aa6f0@penduick>
 <CANDhNCrpNU7QJgu+0CZRvdxLwKp8VNxZoG_zDo7qqxaE0mjoTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="ybq2aqmqnxghgoih"
Content-Disposition: inline
In-Reply-To: <CANDhNCrpNU7QJgu+0CZRvdxLwKp8VNxZoG_zDo7qqxaE0mjoTw@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: 7szk1887ztdt69y66syw94zjo384w1zf
X-Rspamd-Queue-Id: 912E8180002
X-Rspamd-Server: rspam10
X-HE-Tag: 1772199033-840226
X-HE-Meta: U2FsdGVkX19IuB/axhj0if111JQotO0q2Cd8hw6lpIHsqqf3ZX7A/QEFwQwd0o+R3QXGyhavSOv3l0XfgxfJm96+NxQmMAFDHbNMlIZ/3YkgFhinWGNVjJIJwERzSjeksXCwk00/Uh3RfDAJEQJUEaMslJmWu1/a7YOzSqtMBR9uWyY5Eny1PU2g/sYq2Kkv7ds2fVfvw6T48gfS+JhFr0FpTrnU3nT6Lq7QjjW221ioF22Il3eXb7tF1uLVT3S1CU0BjEy3aSG51RKKmrVA4uxNwFkUFb38bkDp9FdvQKfEori6R6A4Vw1/CyyO+njPi71vR51cGELOfnPVYl43bJlQFcR8QmUPslRQbtK3/ZWvt+IwodGZA0lwR+lVpva4iYmhphCDJECWj4ul+XlWeVmjdYpGHqGnXoOLHnXIqNus0WSoMRCI1+YcsnYDzI7zhH/x8N1SwOkNfUuxE+sjVVgcJQ1ezNuElrN4TJ4RmznwrAgE3QIw00IZNeFpcc+HoklYs0SEEnnRPQFjUxdXZCvDDi+OPAdYy3QtGPEfYwrNNHJBsY5nWPWaTHeXJ7ZojKcQv48rS2aaH3oYb0yWfRm0/KIFImFVv2A/o0PiX2aj4BeuvJikPNrkJdQ5g1sfTbSpk5nJ70p9TPCuChqW+yjYgS81p7yXeCqTuaTNW23CUKbOkIt8lqNV2cx+m0Y144pPb0zpM6sWsrNDPWt/YAOqchY1bYLemywYgtao13L9+CfZKauEBKkH4jbfify2ET8tzBwRGE3eba4kr+k1TTKn9hIdhZImL/PloomzdUxGwUOIN3WMiIxy5k6YpBMGD7HAJ1WFhdld5Y88BuhbN7VkPa3OklP1fCOT3zM84sAPeDwNkrKPhShC7febcwa5hMPqCAvk6Hh3KZSu+103hbZmZXCBUy/Q3nj0F71qW0GD19yEO74LfMyndVMJPqtZwTD+Pi106oJ8575MG9W
 VG7NpQlu
 hS/WZW+kpmNd8a7VYKeO6ZOaXtXbhELZivVKVjQTaX1rkonpQiVB4nBgYBH3oHqatApLYTLqU62r3F4klSfxNGh1ZpfbsgVXWjW3CN6bIqZIsaPjZpt5zCA13qoP07kXlNuUVDn8JY6Uz2euCKfLG09RLU4NwroysFzqwYxVG+GFYRuoxz4VyT0jSsxh8kx5W5PhpAOflMcCHm6/3WtZaFnxlVbHCh8QJH8zLKQP07kLxd0Ls7hfwoXwXD2172a10//PKaHx6CHyb5fC+S2dnB3mEPTyMKp513oAW+bIHG73TS9lgKUS8ZEZCnhUD6F/cqtQCfxdQ6lw6GgFZC92aaTR9nl5ifOHp3qiPXfNthtQYF4yIJRxsOGfcYtnJtK/GGZuFdO3OX6rLBITTzITbhskZHkx3y7b7kE3deDP82IrV+WWhuz1bu2HbbX8hQEIBKRx7ObX2qeiJvwb5id4aIr++fWKHFh6TUKvi7hw4QLHYrdQMz9kw0FJehw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--ybq2aqmqnxghgoih
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 0/7] dma-buf: heaps: Turn heaps into modules
MIME-Version: 1.0

Hi John,

On Thu, Feb 26, 2026 at 10:03:21AM -0800, John Stultz wrote:
> On Thu, Feb 26, 2026 at 2:18=E2=80=AFAM Maxime Ripard <mripard@kernel.org=
> wrote:
> > On Wed, Feb 25, 2026 at 10:51:30AM -0800, John Stultz wrote:
> > > So heaps-as-modules is common in the Android kernels, and was
> > > attempted to be upstreamed long ago:
> > >   https://lore.kernel.org/lkml/20191025234834.28214-1-john.stultz@lin=
aro.org/
> > >
> > > And it got a fairly chilly reception, but maybe having the additional
> > > optee heap (as well as other proposed heaps) might sway folks on this
> > > now.
> >
> > I didn't know that Android was using heap as modules only, but I'd say
> > that it's even more of a reason to upstream it then.
> >
> > > There is also the kref bits you might need (which Android still carri=
es):
> > >   https://lore.kernel.org/lkml/20200725032633.125006-1-john.stultz@li=
naro.org/
> >
> > I'm curious about this one though. It looks like you add refcounting,
> > but never really get the references anywhere. What was your intent, that
> > on every allocation the buffer would get a reference to the heap so we
> > avoid removing a heap with allocated buffers?
>=20
> Oh, apologies I mixed this up. You can ignore that suggestion.
>=20
> In Android, once folks were familiar with thinking about dma-buf
> heaps, some (out of tree) drivers wanted to be able to internally
> allocate from a given heap (somewhat of a hold-over from the old ION
> drivers). So we have a convenience patch to provide that:
>    https://android.googlesource.com/kernel/common/+/8e1ec97355ef9927e82ec=
18c98312bdcd80bf289%5E%21/
>=20
> And since we return a dma_heap to the driver to allocate against:
>   https://android.googlesource.com/kernel/common/+/fc1310ebf8fe25ea7b9834=
00e6fa41f5a6d11966%5E%21/
>=20
> The kref bit is to make sure we're doing proper reference counting on
> that shared pointer.
>=20
> This ended up getting bundled together along with the heaps-as-modules
> changes in our out-of-tree changes, and I just confused its use here.

Understood, thanks :)

It looks like there's some people interested in doing what you described
though, so we might need your patch still.

Maxime

--ybq2aqmqnxghgoih
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCaaGcdQAKCRAnX84Zoj2+
dlInAYDiZPR1HyqxbwSMVJaP54olybYOcsMkzhKqdmUzzyNp1PJL2iscONIeEv0g
z3hqowsBgJDNhcz09KstrR3FmwlC0rN908FYO2XMXAIcrplcSndu1qOliyhSfM9Z
3ioBgkbAMA==
=BqyY
-----END PGP SIGNATURE-----

--ybq2aqmqnxghgoih--

