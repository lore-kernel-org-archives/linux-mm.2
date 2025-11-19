Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EF89CF258C
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 09:10:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67D866B00A6; Wed, 19 Nov 2025 04:10:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62D726B00A8; Wed, 19 Nov 2025 04:10:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51C926B00A9; Wed, 19 Nov 2025 04:10:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8F26B00A6
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 04:10:46 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5220013AB69
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:10:43 +0000 (UTC)
X-FDA: 84126786366.23.8E4FBD6
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	by imf23.hostedemail.com (Postfix) with ESMTP id 391FD14000A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:10:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ucw.cz header.s=gen1 header.b=RJRBSeAN;
	spf=pass (imf23.hostedemail.com: domain of pavel@ucw.cz designates 46.255.230.98 as permitted sender) smtp.mailfrom=pavel@ucw.cz;
	dmarc=pass (policy=none) header.from=ucw.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763543441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aKoPdmFx5HfPn5TOgKRfoxKrS5WsoaWj58t/0pgywKo=;
	b=kHHk/PWrRM8DTC7YkADcj3IiyQWKXNdkZjZLLzPd8ohztZmJ4vP2Ldum0drs+T8YIF1onf
	AZOy+O4DgshZbN+p6UXn5L4LTjEB5hbhrIwjRtFnXDdII9uUeseZxkaOMCjxuEG3o0QAaa
	/UY/gHrEKEosk4mvLnRMLEkjDmCSyBU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ucw.cz header.s=gen1 header.b=RJRBSeAN;
	spf=pass (imf23.hostedemail.com: domain of pavel@ucw.cz designates 46.255.230.98 as permitted sender) smtp.mailfrom=pavel@ucw.cz;
	dmarc=pass (policy=none) header.from=ucw.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763543441; a=rsa-sha256;
	cv=none;
	b=mhxzsyKjAf9nRo+DYIrg+r7EAuf35QJYypvqrFxP8MZmupohZDPpOc6attyAXCJR8r1eCF
	XWb6NiLQkubk6wsbdQ0E5KAodllPl2WsqcCJw+ZM5ESDvN6YUkVFjE9G7Iou+D6ReVzGyN
	eraSy14pm/s5O8nfbgB8/PF7tDEu5nY=
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 0EDD71C01B5; Wed, 19 Nov 2025 10:10:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
	t=1763543438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aKoPdmFx5HfPn5TOgKRfoxKrS5WsoaWj58t/0pgywKo=;
	b=RJRBSeANYOBxvnqyHlD+I2v3IXaMwzRsxHvxBDiIjOvVpL1DzXXNzrkwtJ+Q8P4NOyNTyK
	n/XF3RNw+GNi85nHnzcSCQ4w1iD0HcWkVtaVFqB6B0c3aPBjTfKDEToY5eRn2690EjOa0S
	XxkmAA9DvUKolt0+Vi1UBNxKPsTd0/o=
Date: Wed, 19 Nov 2025 10:10:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Richard W.M. Jones" <rjones@redhat.com>, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org
Cc: Eric Dumazet <edumazet@google.com>, Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
	Eric Dumazet <eric.dumazet@gmail.com>,
	syzbot+e1cd6bd8493060bd701d@syzkaller.appspotmail.com,
	Mike Christie <mchristi@redhat.com>,
	Yu Kuai <yukuai1@huaweicloud.com>, linux-block@vger.kernel.org,
	nbd@other.debian.org
Subject: Userland used in writeback path was Re: [PATCH] nbd: restrict
 sockets to TCP and UDP
Message-ID: <aR2JjR1yKHCCPalO@duo.ucw.cz>
References: <20250909132243.1327024-1-edumazet@google.com>
 <aRyzUc/WndKJBAz0@duo.ucw.cz>
 <20251118181623.GK1427@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aQHk9D/h+j/L8Oa2"
Content-Disposition: inline
In-Reply-To: <20251118181623.GK1427@redhat.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 391FD14000A
X-Stat-Signature: cooqcm371ufnpu91copmfqbio8m6phz3
X-Rspam-User: 
X-HE-Tag: 1763543440-499682
X-HE-Meta: U2FsdGVkX1+aFb68xu0CdjYlAL57XQQZ/TGV6T6yQiMhrnEgmAS0QDdb7IHi4AHpm0rn+TKVW0J0u3AIOTm38SoOqBV388eQqMQ/3UxzlN3W0PB+knoDQLApGjQj2f5WS5BtMrrD4HwhiejhvwOaUPxb9UJmrGlmKQiCzDbxlVIwmwaFwsynei8le2wxQ2jLNblTOI1Ed1XLcaGbubPACw9Y2pzOA4GCHg0KjSjGKWzTZd0bEDZoxyC3BeUhr4iZQOSAyJg84wxVBkh+Tet0/A8yrEvWpEtnsN5vgl5Pm+73Pq4y03qPdkxKSGhuq+KW2yq4VKIEVErYjg6rCQTZqF+pacGjbDWcZWPyLLR/pYMAvz6r/xe4VzXEiCa+lV8zk+AEsOURXejrw2xSkgsUpsqpVIKjathRvXblC37978MGMvnIvqAkdEQg/JDQ9IScCmBawhDN3r6BuBwVBVlod7oqilEUrSW1bEjxC4I/A1DviK1hdnR4dx/mBQiDcWCNcGOJvFTmcsi7A7/JcDRljeAtZ3sF+IBmtokST/CvmZQaCgL9jKciTUSsAbSMsz3p2usxM8ipx513NIcLc1wUE4HrRJYBfT7CDAuEGUzJHeUs+72e62TrAB+mEXhiwUgM858G6UdyCD940rjG8kyWvLpVAYMhGx8KTwcEE4rcL8PwYtV2aAeqEmy1V0/mTTY+R2a0PbGxm5dWXYb/B5HfMJYd8TxMdmafrnj5fjNSXnwU+4s7lGY/ZQNLXCGKpLnb28dlBwyJj17nlxwus26RQVowGqrnbJxKKjJIxQDHWcMVmQM1L1ep7jglfitxfpxQDtKKJg0I2Yx9AjquoMGGR985lL9aXpFir+T9wa6+jL2EEnASD0w8tAvANvWNpu7lmJwvRN29zlwsY9YyEF3H1Imew5qRXbTLPn0ONZjtP815CJETznvjINsCpaESCpon/Djh1xZ0hKoEY4xeosS
 hZgSol/z
 cz4qDHc7b9VgxyC5KcPZxqWt1mJ6A3/00vsVSz+Po2KqBwKYVL84tG77/OyQQ1BdQ7gaLiXS108iT/efGF0FSoHjCZvLXmU3OOe6biAKKr+9M47ZZ8pVytQo1vI6ifEjNzTZ2r5SI/W0KkM12dEbkNWi6Z2J1RwT8CPYXSCLdS+acUibaV93YzDzcIJJ536eG4AQZPHOIqfMWRz0urJRYIxvG2N0Ick5znNXJLzblh1FCyEeOw+ywyTWJy8eKBm8Sm/qoOIVFyDy4Ay6v+rZf3yO3MUhChREUUPrA07XA/98Pmz8BWSUqWKqX3VE+Qg2JGjMOuC8Ros9PR9GI74KnyzXLdFaSROtTyUwVHQ90tOke1uazXVXzTvLMHCWJWjJ8mIUsEUIIg/PV+4A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--aQHk9D/h+j/L8Oa2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2025-11-18 18:16:23, Richard W.M. Jones wrote:
> On Tue, Nov 18, 2025 at 06:56:33PM +0100, Pavel Machek wrote:
> > Hi!
> >=20
> > > Recently, syzbot started to abuse NBD with all kinds of sockets.
> > >=20
> > > Commit cf1b2326b734 ("nbd: verify socket is supported during setup")
> > > made sure the socket supported a shutdown() method.
> > >=20
> > > Explicitely accept TCP and UNIX stream sockets.
> >=20
> > Note that running nbd server and client on same machine is not safe in
> > read-write mode. It may deadlock under low memory conditions.
> >=20
> > Thus I'm not sure if we should accept UNIX sockets.
>=20
> Both nbd-client and nbdkit have modes where they can mlock themselves
> into RAM.

kernel needs memory. It issues write-back to get some.
nbd-client does syscall. Maybe writing to storage?
That syscall does kmalloc().
That kmalloc now needs something like PF_MEMALLOC flag.

mlock() is not enough.

Best regards,
							Pavel
--=20
I don't work for Nazis and criminals, and neither should you.
Boycott Putin, Trump, Netanyahu and Musk!

--aQHk9D/h+j/L8Oa2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaR2JjQAKCRAw5/Bqldv6
8nyLAJ0fg+14AbZ5oZZJCws638BzTfOy3ACfQZ9jf5rMfhYV1RriNRoroGv0JwI=
=eRuh
-----END PGP SIGNATURE-----

--aQHk9D/h+j/L8Oa2--

