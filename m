Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19FEBD3ABCC
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 00:40:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 713AF6B0331; Fri,  5 Dec 2025 19:40:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EAE26B0333; Fri,  5 Dec 2025 19:40:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6010D6B0334; Fri,  5 Dec 2025 19:40:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4CD7A6B0331
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:40:43 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D065DC03A1
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 00:40:42 +0000 (UTC)
X-FDA: 84187190724.01.5352169
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	by imf24.hostedemail.com (Postfix) with ESMTP id 96695180003
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 00:40:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=canb.auug.org.au header.s=202503 header.b=JlTgd6m+;
	dmarc=pass (policy=none) header.from=canb.auug.org.au;
	spf=pass (imf24.hostedemail.com: domain of sfr@canb.auug.org.au designates 150.107.74.76 as permitted sender) smtp.mailfrom=sfr@canb.auug.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764981641; a=rsa-sha256;
	cv=none;
	b=jc3C1rP9YI/z8Y8i2XKOR7ZYwoeulAvbrIS61m4b2aOW/1FWL9UdCrxASLnEHQ8s8aiOWZ
	vwMhf9buJjD/Po7UJHSPBN2FqDNaExA7SfiXu7LyNHdIJyDwWGHMEyD17hu2O4FtueKPcZ
	ps/vh/OfliERW4RUOJ0nFeRDtWPYK2c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=canb.auug.org.au header.s=202503 header.b=JlTgd6m+;
	dmarc=pass (policy=none) header.from=canb.auug.org.au;
	spf=pass (imf24.hostedemail.com: domain of sfr@canb.auug.org.au designates 150.107.74.76 as permitted sender) smtp.mailfrom=sfr@canb.auug.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764981641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BtXnuTDmcEUZiOSbF4M8KvSQ+xlfsptEnFqR1tvQwGg=;
	b=u/pvK06eVlJzEPqynwuYGxkx3ZQQjN3hwEbPu/8q7RS8sC8lHr3doOneZiqem0nDx3l8wR
	sHkwAKCBVBQlklgeQ+TpOiIUp/yCYYRS8nHzk50yWheZdX2UFVIguNXk106l7T8uhu/4M/
	tdz5DYpNdL8/IkRgwPXqY9WojbMPDrg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=202503; t=1764981637;
	bh=BtXnuTDmcEUZiOSbF4M8KvSQ+xlfsptEnFqR1tvQwGg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JlTgd6m+KKY8gFS7UEpJnBHMyqLZyo+EtxCLwGpXdcgmhIZWz2cpoY3Z2WpAy5SaR
	 /Ymp4byQinbtONHj889+HME7elA/Nac2AiLmwiCWLBFqTeV9DcjSgFyie3rOgqP1Ni
	 CqJ74/d1+dUzViNyjcaJxUeNvXzlGdl01b078Q1fAmbJKk1inVdjyzZL2L4HPUodaS
	 Zo+6joFdBJE8xzo9ehrx4fv5DvqiQJCe7Dxq2Cnh2JGwtVmRWXAsfKtzOEn6P3L3ES
	 DqBmVT4Iad2kZiuyZApWcWUJXbAZqfGaqjext1svbMj2dSoZ9wRBi5FyOGJpNR4Nuu
	 dOtBbimwFYPUg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4dNTtX0sr1z4wDn;
	Sat, 06 Dec 2025 11:40:35 +1100 (AEDT)
Date: Sat, 6 Dec 2025 11:40:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, David Hildenbrand
 <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil
 Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, oliver.sang@intel.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
Message-ID: <20251206114034.24bdbf1f@canb.auug.org.au>
In-Reply-To: <20251205121501.bf47efd78d0a1a8f0370645c@linux-foundation.org>
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
	<20251205121501.bf47efd78d0a1a8f0370645c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/2k7/Wn4z0R2/dm.AyJ_l8ot";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 96695180003
X-Stat-Signature: pyshohp6a9qxgpgazg1n19geeqxox9nt
X-Rspam-User: 
X-HE-Tag: 1764981640-874925
X-HE-Meta: U2FsdGVkX1+e548uvn9ba4TxQCT6DolSBcV2xuizkwJXh9/PGV3CI6pQ4gBAbIkGJQKqEl3whDpxBB3ieGbfC1gNNgxVVjZXVSsb+EVwOv5j0j+ZlM4e2BpK8lLC2ZLNJGG5C8jq2G7EnXssOYo4nIdsoHsUl1ElsZwu8mRkr0ETZ5+dNke7RtG17ee6M9ZOr4PeCzcKy4z3AjEFNzcC2j9HZMv2yWSHlD9yIH/vWzemunZ+6sxsSGNGMXX1ejD9fUykZ8gP43J2QQYa2y6T6MEQx5ZQ9573TznUjmNWN/32XahHZSJElxJBgO9JAS4g5bFG31aejyKTbw2rYksNRsJ6qipJ3tPn2uVAHhaDxSkmbJEL8ZhIlXXrq4n54ABEdYmz26UjJZwwsXbWhesMtNM1XeSUqZzJsrHdU2qZU6ImOs/0gST+H3cJmiSHVR3LrVbOpZ/YeRmUp16t4l5iFGlgjobXiIA7vBWl0vmXmrmRJAEb6i2ocZ7mTl+TGfrDnk+MebBQ/FrUNMKOpJXC/kZeAMsQw9fO9c2FRbZjE/UoL5HMcprZrbo47+W/ysb9Tx2BL2JSW/5nsvQ7G5dFZuyVYyRWVoUmDTtGiwQmr1HN3yhUaiyZR0Z1ULXvrdUhzlHWFAI85RiCR5uNNqc9onO+kzdwskb2F7LO0Woi/xK8FiCz8eZFiiMw/RvlS/o7WUs6uDcl7DNq9p9DQxon++6SLNcjnckOVDVwdXkWpKyGhyskIJyxQgJxGBl3rM6OtGrYNJCm232c5OrYusmjPPc+21C5atnAkOFzrMsmK6gf+NXZQjGo3S4sFP80fWeTeS40A6X7OYQ4yPqOfzcZzQTY6fBxQuAW6AtmrQlKqCRYRVVvYRidbW3aBwwUXl8zzui3g3zzZVOo9GFsBxqH3bxZwya2yzYPdDwIAw6a/vN/obFlY3amaUMIkXyO7RL8sjmMqpVMb6J8mFQxCI9
 CiXR0lyG
 /ZwpPtk/PZHG+pApUatF/Bd9jusHSLewkpQ79Bq57VXq4y6I1e8Y5p7jKjKtE5fbEZiZFxPZ5m18fQ1ISKAH6TmHMawjWx+UZQVl4O4tqrWBF3BLLZJD/Y4NFf7iRJ8INjsO8LIiFJHvzPn+bH3Ey3hlSGVXsIbC7hAf+COGLsNfhQGsBjKUI7LJ7LQjpJBFYZu1XM00EOb2pXVZXykSXCms2c1PlkPhfYm3VVtlxnwFqTnq+bBTpQgIqrmjmlZ/vApWVFDikIOk1okXO9jEjqiin/JRcif4TGV4DiR1/jMd6X+M2AvQIjgBjAXEIUx4Yfe3Q2gYFc/WFkBgBU0WphWX0xPbUryi0ZaZYi0UMBzQWQk+86YnP4ZO6tg1yPYoX7K7bIlTPRZwJtTNPBEsyumMdcKsdl5JdNwGKdcRNcBF7sI6WUZNTRmM/yA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--Sig_/2k7/Wn4z0R2/dm.AyJ_l8ot
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Fri, 5 Dec 2025 12:15:01 -0800 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> I'm not really sure what's the best way to determine this.  I use
>=20
> hp2:/usr/src/mm> git tag --contains 2b6a3f061f11 =20
> mm-everything-2025-11-29-19-43
> mm-everything-2025-12-01-19-02
> mm-everything-2025-12-03-23-49
> mm-everything-2025-12-05-00-55
> mm-stable-2025-12-03-21-26
>=20

What does "git branch --contains 2b6a3f061f11" say in your tree?

In my linux-next tree it says (I need the -r to check remote branches):

$ git branch -r --contains 2b6a3f061f11
  mm-stable/mm-stable
  mm-unstable/mm-unstable

but I don't export my remotes to my published tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/2k7/Wn4z0R2/dm.AyJ_l8ot
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmkze4IACgkQAVBC80lX
0GxJ1wf9FjRXxkCifSnD2o6oPXU1dzWD12+T1qOEp+Gbgygy/V3np4Ol7YzeN6+6
Ox7m/oMSPYd2gieqDRjHn82L0qFvwJ1H3WYeao6LS7ngg7sGu1r3VI2fv9TWOk+d
8aHSspGV9Kmm5aU2tanchUj15raPNiEECRrWd90kQTCGu8K4M0vi4Esb1unNF7Hy
N7rbY3mHFsDuIRaZ/It3fjBvmemDu7O5sKrhdPxF/syfrpASBhxKMpVJqxu4aLvQ
ENW3fcZpspDHBCplTVROXXAkjtRnXXbgNZyaTX8mufVf7kqbVnbC3LiC/9DXpWN2
FNeFzOmOYEGYhN7TL7QNEiI3z6zypg==
=Vvb2
-----END PGP SIGNATURE-----

--Sig_/2k7/Wn4z0R2/dm.AyJ_l8ot--

