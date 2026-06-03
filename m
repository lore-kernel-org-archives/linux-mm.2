Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 871C0CD6E6A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 09:57:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C1906B008C; Wed,  3 Jun 2026 05:57:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 998C56B0092; Wed,  3 Jun 2026 05:57:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B01C6B0093; Wed,  3 Jun 2026 05:57:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 796826B008C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 05:57:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 204161202BC
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:57:19 +0000 (UTC)
X-FDA: 84838148598.17.7B17352
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6B967180006
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:57:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fazpvtii;
	spf=pass (imf06.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780480637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h79u5wvPs/2j+iDBVrKy4zYMNVex5xBYWpPHS0lfIyw=;
	b=4H265mrECJXAZK8crW5p4xoaG1DV/KKXsujQRzX9QMM9M/3YkTcLZvx7QI0SgiilsCNmTo
	Bxnay76PfWWwRY3Lgy7D2QZVGCdWXWfivHs1ApOixJ2IpWb68PlMJqhw2IncfnN1VamPMT
	gfPiaNkhWllfh/Pqd4t3sJae9hqOP1k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780480637;
	b=THqT9InfA0HpWsW33jTQZqr213gKPBYDs+u3bd97++MP5OQuBDaisD0ZwowbfbEYCCh7FV
	KZCdfOblvbmfhxKJqRre8sTjciwAVkkeYUNTCgpHE9HPqhYv7LQQdLnhEwDak2VyX/mAFT
	Ew9CrDmb1+G3iYUpNXFcDl/+oQdw6ds=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fazpvtii;
	spf=pass (imf06.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E672060218;
	Wed,  3 Jun 2026 09:57:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2DD1F00893;
	Wed,  3 Jun 2026 09:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780480636;
	bh=h79u5wvPs/2j+iDBVrKy4zYMNVex5xBYWpPHS0lfIyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FazpvtiipGEEqGV18a7y0zKWUs6NbXwoMehsoqFHK7tFgDKIh0iLUak7m0QBFcMTz
	 HCrTiCJWGtZoBYvN1XEeLo5DiMqc+JeNwEplxEmBOFmxavf4B3C/fkQiZGNZimkQ7g
	 DUx998nKZduHNpZG5kv3UT0X5VeYjCu0ZyX9pHJr5XaBZlBTKbe6qM+i0Sd/o7gYaP
	 T1xfNGM1svxnhLKh3i/0Q5s7usxJmPutwc3IolIoaKIqTotFaikNVZwsAshe+cpolv
	 CVntxP+8tqQNcCgAf1rkvZipN7/8e18xxAET/TadPsp9xN13Q/K5COwDYHc0NU4nzo
	 ZrUc4Fy01wCWQ==
Date: Wed, 3 Jun 2026 10:57:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Nico Pache <npache@redhat.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	liam@infradead.org, mhocko@suse.com, vbabka@suse.cz,
	willy@infradead.org
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
Message-ID: <0560f9a3-d8d2-4f9e-a7e8-9da3512ce9f0@sirena.org.uk>
References: <b45f9b55-5143-4387-aa98-e077390d542a@kernel.org>
 <ah2ndruO3RQGtePP@lucifer>
 <506fed6b-8954-40fa-8b5e-c8bd8c0d004b@kernel.org>
 <ah2uDhs3a0bFcRNG@lucifer>
 <ca37b7ce-76b0-4825-b238-b504dd499d3d@kernel.org>
 <b5b1a7bf-de6a-488a-a011-673c37bd24d1@kernel.org>
 <07334dc3-79ba-407e-96be-21ceb2eec00a@kernel.org>
 <ah8Tflgn50DTMvwl@kernel.org>
 <ah_ML-Wm3B92ZniC@lucifer>
 <ah_oJEODZJp12oDl@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="pIjCxBIkFLkSIORI"
Content-Disposition: inline
In-Reply-To: <ah_oJEODZJp12oDl@kernel.org>
X-Cookie: Tom's hungry, time to eat lunch.
X-Rspamd-Queue-Id: 6B967180006
X-Rspam-User: 
X-Stat-Signature: ytz4ij4kg5yhjegbsbs383p77e7si937
X-Rspamd-Server: rspam08
X-HE-Tag: 1780480637-451938
X-HE-Meta: U2FsdGVkX1+HoLuaqplbBoRT1CGoQX0e4zFlLx5B00ewDH+UiIxRuSccBtByZ8ZC1x0DhEsOKktXlvdfOOAv8OrwboK+EATljVoEKfLTXlx1xPoNt88RmQtlAU63XYnEUUwMPNVMpxDWJAvX8buTiHdQxn5SUM9KhXNsE/19EVJVv5kubhW4/T17v3CD/fwQ4KvX++HnKdbZvFx1SBAOSKSdRhHLQMk2mTioamRxE57uvppWWKHS7JT3qcytM8O3aa/grX4/p8Mhm85oLETQQWgQgiSWKEBQr8ewUY2+6AveeyOfuQRM8vN+SnzcaB8KzRicIL8YbyNxR7A6TZy+1/Pw/mrEAvIeK/bGlIicnFlNp3Vj7dI5rUspt9UBF5L5M10jHin9MeUbDLxqRQgdUsmWY0x/tB9LFWlK8z2cIL2r4w7G5mpQU0QbiNnbuEjtuwtnZ70fk0BS3rwC2vJML5oJwz9ELWo/6NlriCWqRbkYV79D7dsW4nwuCWnO4pL8nHT/QJJLs5dt308xrDtgTvd3mi8aX6FEt91cc5Lcy5/kUv5dDDsVgY7XS/a3jcgA+l456+6aLiVUaBlQD3ME07fGUuA540qqBdyym24BIudsSmJLEFhtuAvd5uehj/DHR8U7VPsVFk8I02t+fJE7qDy+beGdn7BvlQnHPrtm8b9NTYs95RtWlQZN5r1rmhELoyPchHoh+W5gN15nQBnv9x6mTfn4s2Lq8Nbesm2VgGQ5W31Z1I+kkl6VDXc8nlLfyrTLISnYeX1eGJ3432qotbJIJ4n7lF30O1AOXq1aash12Y5AF1PMZ1uoOhOka+XHWufo+DIdWVdZQG5fLypU4sxIe9acqukTjUI4Y/ZxP+pVYCg6FHqQwAFWkeKLvPEMv+rv9nTP8hQpsCGOZQKlCbD+/ln6GBaIsQ3aNB15CYql9Fln5i/NiaO+731+M8taZ4b72BhuJ6iw7J6CIbK
 HS1SELJ9
 I+b836o7djRC9zoLnH4Jnh9pq3+dD6nEJ07BfmEJl+3SqwKZ9uEVNO3RqpMA0y4oFyT890TJThGl+ckWWzU97XNGT4L7DvVGOzdUNLxFuk2O8fjvaGMBZoVwtRCST2qqre7LMAFlMdBDXTnwv+0ong+VQs0w64RBqSQaf9H95fUxBiIzkdfjgBx+rcyHHROo6Z2HuGhQG7ZnDPrGTo4eE8I0XW0MfmVZ2zs7M7dteaO3Xls7elI9eVuShi3kduxa9twX9Vul9/Nmz4ytjpW5XT/HWpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--pIjCxBIkFLkSIORI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 03, 2026 at 11:39:00AM +0300, Mike Rapoport wrote:
> On Wed, Jun 03, 2026 at 07:48:46AM +0100, Lorenzo Stoakes wrote:

> > - It makes it more difficult for us to yank things

> git rebase -i

Remembering to add signoffs if you're rebasing something someone else
committed (probably the most frequent cause of missing signoffs in
-next), --signoff helps there.

--pIjCxBIkFLkSIORI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmof+nYACgkQJNaLcl1U
h9D0fQf/ZPzXPD4YO8daH3L8QLNzZjkJT5KghMzc9aH7zD1njgKG/JvuC7CkiEZw
/nu1R78WnpyhNcmDI8YFkdv8tBiej38S31S7KnsedgIZwOmTkn+TlTYQjOkZyRFs
XpmsaJ5kRNZ7TfX1y0k0cFex3VUzD811kq1Zki5dIkC0hseh5/UidmHlyuRNR+mP
ZgPqSMsx1OyoWM+7QLHhZIN4WS7vLhaQUV1f9hXUqFNkIvIzLI/d4ceb7HtfIXTT
dbLpaUJHPCPgE2qLG09HhRFUNtyS9HJ+Y4CVCpgy2NMGYD8xx3gpqk5iJOH6MAbD
wxvUunMUtJiZm+wKRkHxcbEu+krzkg==
=AYbg
-----END PGP SIGNATURE-----

--pIjCxBIkFLkSIORI--

