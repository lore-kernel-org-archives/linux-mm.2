Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D23CFCA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:37:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60F3C8E0028; Mon, 11 Aug 2025 05:37:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E5F58E000A; Mon, 11 Aug 2025 05:37:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 523338E0028; Mon, 11 Aug 2025 05:37:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3F7B48E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:37:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F1052117326
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:37:44 +0000 (UTC)
X-FDA: 83763974448.22.AA6C91B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3810F4000F
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:37:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DqRU4AKC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754905063; a=rsa-sha256;
	cv=none;
	b=GB/Vh66NUVrYsNwgZaBk8Ow32NKUm1jUx4wc1F/wvoyaXHEBKHcYumt9cT/0E1JkmQ1Bpd
	xKVejdXC9Xngs8h8emHxUaAhxCdWoWZjMcXReJKOA0uWdLKvoij+A/dJIeSOqx2H4SHR0B
	M3EssC6p4Iv1VIwubmU2r3bZYY6wZYw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DqRU4AKC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754905063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BwbecPE/ff6XX4Zs0sD5dic2QdgsaosDcGG5OZGZH6U=;
	b=7+3kUqzzxbSpf+Kw2PhGNxrUYSgEkrL1umroPZXuRJu7zDGkjW5bl8BMFNbZfN39kRx+OZ
	8zSt+Jjv8+dEASdjt7eERsBAhunnybnrzRTS6QTEzqSIbXH2YC/S12c0EqUfoCcD32FEad
	0uUv1pQrI676+TcQUvvlwSFjAB2Gdx8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 18482436DB;
	Mon, 11 Aug 2025 09:37:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F5BC4CEED;
	Mon, 11 Aug 2025 09:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754905062;
	bh=/6rqaVzkcLqKJt+RONzwleWy3O1JwLSdS+WsTVizHyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DqRU4AKChCeCXcAUEBbuEgv5eIzCLDRq+eEVCCwFshbb+yaKivcXn0h1hJPpLuE2L
	 XUiK7OtQb9QiWROoqkLxg9ks5w/DgkZK0++fF+9rwVZf12xb7i3c7FVrOUoJrhef0A
	 Yfv0nXpD+NTl++CFUiSHCGnsuZwpHFHqMyVM3HOo7WKiyEOonHxwy5LhGvNnfaTCcd
	 TLbr4gtlCk88lLGyLIGlNZ+LaezjlTovdORwRzVEGtsAq90eFGvhIEzjeP/piNvs62
	 W9qx3RJPXYDqApCLczBHLuwbpPeQ1FqiMAUBL5com96oOy54mhwKnC7jmEBdD3Ex0A
	 0tZ0ioKOBtlQw==
Date: Mon, 11 Aug 2025 11:37:35 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v4 1/2] man/man2/mremap.2: describe multiple mapping move
Message-ID: <s2lpafv4ldpmwkx2455t3l566fnkrlid7upwfuebod3lyy25hm@lvokcxytqow7>
References: <cover.1754414738.git.lorenzo.stoakes@oracle.com>
 <53e4284ffe80a63260c957369ccacea8f5c16adc.1754414738.git.lorenzo.stoakes@oracle.com>
 <ekjakm6zburrawhk34smm3fd43zufzguisfean4hmv7vyjp7fq@uvy6n47qbydl>
 <664b00e3-69a0-498a-a7dd-a3d294c0c188@lucifer.local>
 <iny6ro5f37vcthqwscklqx73jscahodilug5d6umleyzq6a67k@ecoey5ud3aer>
 <39fb9e1b-b806-47da-a711-20c6cc12913a@lucifer.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="plqexovqttxwvaev"
Content-Disposition: inline
In-Reply-To: <39fb9e1b-b806-47da-a711-20c6cc12913a@lucifer.local>
X-Stat-Signature: 9hkj1aeo516yf6etr7m3yf7tgd4eo7iy
X-Rspam-User: 
X-Rspamd-Queue-Id: 3810F4000F
X-Rspamd-Server: rspam02
X-HE-Tag: 1754905063-676188
X-HE-Meta: U2FsdGVkX1//ix+I+Je4JPYygkWTWzSa0xDAGMFWBpIOsW6KtBek+1F56hquQvL242hzO1dYStF4tYBT8sZvekW6eQIVLNhkE48egLWhY9PO+ub30MXQXWD3q+9pqPkc+D9kEMwYmFccekg7Qzyva2f0Qza4D59S+K6h7tJrUmcrH/FJpZziuKbue75ZsXFdzpw+fhhaTj+s/f2a7cihbjF/YQWAWzr9MpX1i4bGIsH1MZ55PMitqCuy9nngNQsU8YDNYfAgux8ua8bkO1qno7lzWNeFAoZYXiQs/Y6B0zal4gEotu4D1F0yO3a4tCbTcJmLm34pLjikSeqLooHCNt6BupV8QWuhc8dGbLXOhcbU0OJuHdQGMcNA1uu2tuZOR2ddri2wfQIbaQm8W+WVr3dMZkI62H652ZfBleRuEk6DVI4YSFtiZoSWmSCzh3bghw0rqKoCbmRU6ZUyA9d/yVIBoEAsBDw6Hl0wuxm9atZ2skc8SvXJlBHADOH7shjKOjKdnXNfzaBS6fHNHDJOnVsNvixiCcyOIXM5hSPh8dfk6gGXTAfILKXFEg+mjBk+6bpv/TM/QXfERPPlty1QiYoOASjUd6vHooyyFB9BOoPeBMJhFZ/0Cfeeq1erHVVmpxl8yYzWOm8W6ClU2Pdatmc6lMtdwU35N0SGpyRhHLXTi5uutvb2jb/7xh/4YNIymm3QnE2cysQHfArHQv0jcZ3xW7wUzu+rELudRooM92XdGiIhEWGYSO16TBMRT0IDibalsac7E8yLjYsA9P388M0Rs/resCknTLDI0MaifrDz5Q3PPe7RLvJp2YfIgpsZGH02JBidLCgIypGuAWwoac6MVLAqz/FGGxNks/ATMn3xxR9F+P6bExa2Bdzp1k14P8wLTAEvmD697mr0su0R1jAJL2fgyPKTFziSWtFadcJ35086W6A0QujDC9wfdftHdf5tHfywVx/1picRhvz
 ErRd2ZzA
 CS2rt8kaE3QFJ9Wdv4773PGAy659PUL2YzM971InunaZo6R6wjs/UAR1G7PiYkCcQjRFU+b6p0aLJnKPEGL0iiHUM6khGdXiUF94plJ6AzHDwwX+X42n5Fwb6BxMqg3C8c9Ijf0oY+pypD7b+bBioPi8Cl4IEy2iKn2VMO8agVgjuhFPQXxnMtt9rLkGwfoD7vOlqhur1Zyjdpg5FePcfk/vNjdflZiUbzn8H8sCUqtgfQL4lXBQPX92Yzx29CyuV5x8hTrLxOS/kG3A7egmY1yauE0t5hV0lKl7L2IgR1EtEF/QD7SXAq5BkvYn7x5xN1WCwOYV9YtjA1H+NyOjwBzbz023/Rv4tw/bc9vQvVIE65o9cvV4nA/aBE7rdNwwVqo4TcpahCBSo5mmqzE9rIEBf5M6juT3oXK3s
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--plqexovqttxwvaev
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
 <iny6ro5f37vcthqwscklqx73jscahodilug5d6umleyzq6a67k@ecoey5ud3aer>
 <39fb9e1b-b806-47da-a711-20c6cc12913a@lucifer.local>
MIME-Version: 1.0
In-Reply-To: <39fb9e1b-b806-47da-a711-20c6cc12913a@lucifer.local>

On Mon, Aug 11, 2025 at 10:25:56AM +0100, Lorenzo Stoakes wrote:
> On Mon, Aug 11, 2025 at 11:20:05AM +0200, Alejandro Colomar wrote:
> > Hi Lorenzo,
> >
> > On Mon, Aug 11, 2025 at 06:30:38AM +0100, Lorenzo Stoakes wrote:
> > > > > +Mappings can also simply be moved
> > > > > +(without any resizing)
> > > > > +by specifying equal
> > > > > +.I old_size
> > > > > +and
> > > > > +.I new_size
> > > > > +and using the
> > > > > +.B MREMAP_FIXED
> > > > > +flag
> > > > > +(see below).
> > > > > +Since Linux 6.17,
> > > > > +while
> > > > > +.I old_address
> > > > > +must reside within a mapping,
> > > >
> > > > I don't understand this.  What does it mean that old_address must r=
eside
> > > > within a mapping?  It's a point, not a size, so I'm not sure I
> > > > understand it.
> > >
> > > I think if it were a size it would be more confusing no?
> > >
> > > It's an address, the address must be located within an existing memor=
y mapping.
> >
> > What I don't understand is: how could you not comply with that?  Could
> > you pass some old_address that is in two mappings?  Being a single
> > address, that would be impossible, right?
>=20
> It can be in an unmapped area. It's either in an unmapped area or a mappe=
d one.
>=20
> I could simply reword this as 'old_address must be mapped'?

Yup, that seems better.  Thanks!

Cheers,
Alex

> > > Will replace with 'located' for clarity.
> > >
> > > >
> > > > > +.I old_size
> > > > > +may span multiple mappings
> > > > > +which do not have to be
> > > > > +adjacent to one another when
> > > > > +performing a move like this.
> >
> >
> > Have a lovely day!
> > Alex
> >
> > --
> > <https://www.alejandro-colomar.es/>

--=20
<https://www.alejandro-colomar.es/>

--plqexovqttxwvaev
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmiZud8ACgkQ64mZXMKQ
wqlkrA/9HAR2TApLusgtvOtIEcmvr4OYlHs/NINEq18TtxegAhOR+eqw3RgcWSq5
PcISRO1HRAXmI1HosvRBCncEWWByjgZapSkVkePnr/B0TlOvB4uORY6pErLZEiCc
W5f0n8ZADVwuZJk4Bn13mk4i024SMdbBqpz9L9i/vLB2SsqffZkJ+s3G4oCMyjId
aUejJ4wN0+yNHBIA0uDECodHjLONBm5DFMrw7JGP88jwT6lV8oEHRdcpzPEuvqWk
Oq8R59G34BqkuBKL6yYADGl6iJwY0wcLJts1GT11++ZUqUokd/Nc4RQyHg9tYZOm
OgNCg2RhL/Atpv3ReCoyVYpe3ua0etI0HXk+yC8GU8MfcVEYsE2ORf6Dg9cLONu9
Zx961jOxrNFqmFWV5UZ3c7XBdX7WjlTZHwq2bblbzeJxcz0tYJicePrOWVPtmAb4
D5eisEdofSjNXLoS4QzTpGvwGXxj4n4LYvrXWdShhm+B8NojdNxw8eIZy7dBvzpC
rrbBN1DHwbT26Sp6kcZok3nflq06f0RKzcfypdwkVIBQQ9b5NNMpo3qPEegUtuCS
B5odiQcif7jiIZuwh1BhDeQHNxmQ/gyT+Ioh8AitjU0m56aM3KWbLNh/Ow9MPO0E
72Kw79HZxpm8d228vOzwmpEjoMAwvZnoX+rHzLEpxrJXrQYZNAE=
=QY0W
-----END PGP SIGNATURE-----

--plqexovqttxwvaev--

