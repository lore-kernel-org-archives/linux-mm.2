Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 607D2CA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:20:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E71CB8E0023; Mon, 11 Aug 2025 05:20:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E49A78E000A; Mon, 11 Aug 2025 05:20:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D86D08E0023; Mon, 11 Aug 2025 05:20:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C9C0F8E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:20:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E2C71172FC
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:20:17 +0000 (UTC)
X-FDA: 83763930474.28.EA00ED9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id AE1A016000D
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:20:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=us2Nv7Wy;
	spf=pass (imf08.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754904015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+IGhFVZjnGQTTGWbvjtNXdT0TAeXuT55OSF2qA1nVZE=;
	b=OasMWjFJ+aLWS9aSr6qEJhWNLDaATinIdH2toMyHe6KsuahKRmLH4W5kNxJxYGxoX3iutB
	t2es0uiwajMQE/S7vMceQkAED5yoAcDSHUCqWI0cjn7wQRRvFwW4TM4iDuPZCzmlVCOQQe
	YzIi0uQhXBOvfEkwZZ9leLnswLKgxzo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754904015; a=rsa-sha256;
	cv=none;
	b=C6FyoWzYiJ4vUyKPQCCl1ly/9s5qMC//8IYtuFZFPsV0qmuVk1JdBFwF5dVg0fzrF6B0u/
	cnXerAh+UYA7LEK1mcPdXZ5w8ZFFWdZ130cHppbhe9wFyd61dYNEdFL3awM2r2xwovEUUN
	7K40hrcn74ocIgOBRJbopcQXnpmEUMk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=us2Nv7Wy;
	spf=pass (imf08.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A41743FB4;
	Mon, 11 Aug 2025 09:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8B9C4CEF1;
	Mon, 11 Aug 2025 09:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754904014;
	bh=IisbMyFzOG6KFUHxBroQ9SRvxbYwsiMzA2NJsWQimZw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=us2Nv7Wy6katcp580pTEPrY1kWZQXR+xMd1P09aJ0eldB//eTqvUA25zKrLOs9L1J
	 sXvQ6jUhIpG5Mhl2j5F/4Of7ukYmCGbasgKPVxmS4W9mUKXA05r9VzUWobBRc70f/v
	 ZmmWlDiO4JNPt9RgMFfsdRx7euCE1s9/JJRUDg6TN0cvkKCHnvyrFG2IfFzEytcgI8
	 yXnJk9E37oBjlsU+gpZoYJJvchHYNtlfYdBwOk8ZjsUK8+Cjxrk2rM85xtpuDO0kB+
	 oBUVkq6R90jM5XW76uVmZCMdJRPN8hRMKtZyWdNPfumR7m35ZbtRN9Qybmy3p7TqcY
	 93NdBt4s1PfLA==
Date: Mon, 11 Aug 2025 11:20:05 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v4 1/2] man/man2/mremap.2: describe multiple mapping move
Message-ID: <iny6ro5f37vcthqwscklqx73jscahodilug5d6umleyzq6a67k@ecoey5ud3aer>
References: <cover.1754414738.git.lorenzo.stoakes@oracle.com>
 <53e4284ffe80a63260c957369ccacea8f5c16adc.1754414738.git.lorenzo.stoakes@oracle.com>
 <ekjakm6zburrawhk34smm3fd43zufzguisfean4hmv7vyjp7fq@uvy6n47qbydl>
 <664b00e3-69a0-498a-a7dd-a3d294c0c188@lucifer.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="k342krn5dolsa74h"
Content-Disposition: inline
In-Reply-To: <664b00e3-69a0-498a-a7dd-a3d294c0c188@lucifer.local>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AE1A016000D
X-Stat-Signature: npto9o33khb3i86z9mfpimtke47sudmn
X-Rspam-User: 
X-HE-Tag: 1754904015-572612
X-HE-Meta: U2FsdGVkX1/QBlq4iOvcWIP6JCeiIFNe8cgaMFzZRUE8Fb8A6gTE+wB7EiIMHk+fWcOx8m84jYxsNpK8NZu3Rgh19OLW9dvcOfKZihs1PpZliOpSPdLFjpDRPbHrsPXHITzInG4OcYZj0Tcc+IABZJoCbV5HvFbueklHhz4EAwtdpBbS4GhfKrZzrbo1lKRC5qqeLQI7H3Hd9h3jxwQrM9dG6tRqpma1VdGvX8l6ylp8/qEzaw1XMTpqf93SVNl5YU4WTGgIhP5/w8PLAMAxsS/AbErHM03zkYPvFUWdoMz/K6iiyw5Rj2POKD1Z6/a1ceiS/5sOl9B3n1W/qZH/SDqYaq2907S/G9QPMIc8GrLG33i3RaXYp0mkbofBwDSbEckon8fYrNURe6bFYDjrLtUu24k5JE9a+XhJAalzMotcO24xG1JQv79VyZ7KZhVxSiNDwH8mJ0AAV+uXpQ7m/VhgBLvrHI/G2QIp7Y3S3ZOY3MAvfAEO77V3ZSWiRmKBNSk154WIAY5Ae6+H1aolLBPTbhvoqmXNbLBtB9tY0pHtXPvhi+adfTV9K5B8inE3fB/8HkZ3/Jhh3cagIUrhoW20ltYMq0GKUiAyglLg/D7mTBxENSdnzTJWKbfud831YFF/E29cbbadzgZh35goYRL4vxNQcBhZmZBc8UW5isqIBok7Ld0NIxG++6n02C+TLUP4J+EvueJPRQD9Jf7jKjJRZ4yTND56DgzCZCJYMvsm2qKkJJIWAr0SRZWLE6oAR9zsRM9Dy+L2PnIlXLOExbaU4GnXWtSE1mcjFW+bpODlGQlcwjWRKq1TVujV+4Qv3Z7S9wmA93P7bS/fLawAx4Hhks/K3W3gWkl39L5zc3flSycnJ5yzG4131pMr9ifeMU2B7MDXpM+o8FLbDtUdaau5HlG65ZtDMOR2qz89susdzfs2StshllG85e5oaFzZfiWiTG8xijhwgSn00g8
 NoTMG4yQ
 LYnpZ/WjiNsbW951wAxhB97Cq/FJInBBxE5LaoKCygrKhJxJqz5grzVjkIDW8AJfZoQm96ZF7DaPPS0VME8fELLOnUxMw6VzVmulqiiLaa7yg62q8CZpnQVq8FUG/qcw8qETCOPejj7NfIzzKPDHeD0IMWaC1Zy1x4mt7LVx6SiT4u4rqxhQs0dfA699ZrelKJS3ZkSwfheSXRGtdTnqEfpibfxwPWE7ESZmyJUluDk++UdHDLUaZodNq7YTiciq6ko5LaM+Oiojrk28+5PbMvMshHwuI/gVlbykkzt4LwtgWrPZr/FG/q/gYs70kyMqe0fifAD3T3i22oAT8lEee50xPDfPnX73ISc2B0ktoRIklchclHds7TDMSTQEdu9Tnr5+W1XqnwMDmtqMWyAmxWfb9L7yINfN43zq4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--k342krn5dolsa74h
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v4 1/2] man/man2/mremap.2: describe multiple mapping move
References: <cover.1754414738.git.lorenzo.stoakes@oracle.com>
 <53e4284ffe80a63260c957369ccacea8f5c16adc.1754414738.git.lorenzo.stoakes@oracle.com>
 <ekjakm6zburrawhk34smm3fd43zufzguisfean4hmv7vyjp7fq@uvy6n47qbydl>
 <664b00e3-69a0-498a-a7dd-a3d294c0c188@lucifer.local>
MIME-Version: 1.0
In-Reply-To: <664b00e3-69a0-498a-a7dd-a3d294c0c188@lucifer.local>

Hi Lorenzo,

On Mon, Aug 11, 2025 at 06:30:38AM +0100, Lorenzo Stoakes wrote:
> > > +Mappings can also simply be moved
> > > +(without any resizing)
> > > +by specifying equal
> > > +.I old_size
> > > +and
> > > +.I new_size
> > > +and using the
> > > +.B MREMAP_FIXED
> > > +flag
> > > +(see below).
> > > +Since Linux 6.17,
> > > +while
> > > +.I old_address
> > > +must reside within a mapping,
> >
> > I don't understand this.  What does it mean that old_address must reside
> > within a mapping?  It's a point, not a size, so I'm not sure I
> > understand it.
>=20
> I think if it were a size it would be more confusing no?
>=20
> It's an address, the address must be located within an existing memory ma=
pping.

What I don't understand is: how could you not comply with that?  Could
you pass some old_address that is in two mappings?  Being a single
address, that would be impossible, right?

> Will replace with 'located' for clarity.
>=20
> >
> > > +.I old_size
> > > +may span multiple mappings
> > > +which do not have to be
> > > +adjacent to one another when
> > > +performing a move like this.


Have a lovely day!
Alex

--=20
<https://www.alejandro-colomar.es/>

--k342krn5dolsa74h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmiZtb4ACgkQ64mZXMKQ
wqn49Q/+NB8XLwGQzYhv4WN/bq4ZSt0ZGgTcrkoQ4WoYE7viHa9oedvqtA7Hr+KN
SCvHXNO2bKEuYfFmrySCT5e+Qjc1G5EwK8ChVJSj0mNuwX9vxEmCHIYW4+OgU05r
pIqGrg05z5xjZxkDjvXuZgmfjU1q3SgM3GU39vDS64j2jWPhff/tWKPNt+oV+54w
o75W1lDsQcyPVvAOX7ge74+JUeKBG9x1P1+9Ou67ruZidsXPxOWtB8rvD/3BPGXO
LiyxA8q0YnM4SeJaHKAfg2xNGFJkv9GLNp2VZE01ZTGjLlWl1znMnOW1uq51dzhj
XvtL9cZNrVc5r/lRUs2lTF3B5GJ8HnLi6dDZ7nIqB7wscLzSeSMea9rbcyrqLm+o
BtWg0kxnu1BLG77HH484MA+R04fN9+/eN3D+iiw/5Dj/pTmWVFu4Ht0PyycJywKa
1SrT3tSfjCe1CPcSAPO8bt8bFNNVO0MsoyYLKdPfXL1g/ePKzDR0kOmzqRyvOulv
omW3lTp6Dmh3B/cMxZ0gy8LhYLWgWZq2FCpoDHfwgoWJtcJhqpSLJIklfiWoi6Ol
4SsCBs6odpUlhdnd6QV+BFYWnauU2vLfJtZ3nMZt4MvUudg1FHkee5dPf55DGNk9
XHrTt5vNlUzrABzJiWwZLBeVDZjyDi3QCmE75IjrUtMxycgFYDw=
=zIS3
-----END PGP SIGNATURE-----

--k342krn5dolsa74h--

