Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3664D767D8
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 11:03:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FB0A6B0088; Fri, 19 Dec 2025 06:03:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8376B0089; Fri, 19 Dec 2025 06:03:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08A206B008A; Fri, 19 Dec 2025 06:03:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EB34F6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:03:35 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 930C660396
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:03:35 +0000 (UTC)
X-FDA: 84235934790.06.C4A8F77
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id E0320C0012
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:03:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E962sNsG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of joel.granados@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=joel.granados@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766142214; a=rsa-sha256;
	cv=none;
	b=zVr0AeeweJeqxZrL7iqc/n/rZj+hcVSs0H8lFXNWNDP5g6/PQLZypjh/lv81uVCmeLlJoA
	dwOXjgMNqWlZAccQublC1oV55NEAfl0OHYg1ynDffoL2jtjZ5+kPQmSAKjAxTSOW/z/Mz/
	RQAUPcsjLGv2hSxBmpaH4CyTfn3kSWk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E962sNsG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of joel.granados@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=joel.granados@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766142214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g14yl9i9+AK6qWvA6aeqtfF+c/gqKut5NJOpYy6/dws=;
	b=v3vAEKKzq8Jc8fi/G4XGjbEUWq6UtOZ/9KsOSmFS7POqqqMbltBYzQhhlib2NSkkiSUm+e
	pXQeWrQRFBbCWdFcJBHKvBVKuaEN0TvwYijIH7jT/Xxp/niAmIxB6ViwWsShXTevc0cXnq
	TNddtCUFQw5WohHuJd1mh1lmZ1P7MNg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A98D643DEC;
	Fri, 19 Dec 2025 11:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA33C4CEF1;
	Fri, 19 Dec 2025 11:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766142212;
	bh=g14yl9i9+AK6qWvA6aeqtfF+c/gqKut5NJOpYy6/dws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E962sNsG7HqmES7DwgBTkN28N+PdGLU4AtYL7zi/A15/UrK1O6Hn9d+TIfGujwL4A
	 L7SD+X1AgujRqtFHYjuVEpivXXRXSHjI7MH7uPNSJt3/ORBECb0Kzd8MrfnfvFunRm
	 Xzq8J5Ru0YiWvE05wjl8rm+y4crWywZpJd1Qel3nkCPDh1Un667nZa1KxaOCzd/kbi
	 e8toKnXzFDztY0xg9vdlHFU/fj+aq+zV8nD3IPb9z9pw/csnY+eb/nYrifFctxJra7
	 5hHcC/4Buui4ZRMV9gjEVg11DupMHJnOQpswsw55bov9KCptGYLnUuzwznDyjIxkEq
	 47TQFs5jjL8fg==
Date: Fri, 19 Dec 2025 12:03:26 +0100
From: Joel Granados <joel.granados@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	John Ogness <john.ogness@linutronix.de>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-hams@vger.kernel.org, 
	netdev@vger.kernel.org
Subject: Re: [PATCH v2] sysctl: Remove unused ctl_table forward declarations
Message-ID: <warv3zwcd4o3rbowav7bhziz6w6lzsuqeeiq4ekpqyj76jwuxf@jmodw3stxult>
References: <20251217-jag-sysctl_fw_decl-v2-1-d917a73635bc@kernel.org>
 <1491a7c7-3ff8-4aea-a6ee-4950f65c756f@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fod3fa63ejffuubd"
Content-Disposition: inline
In-Reply-To: <1491a7c7-3ff8-4aea-a6ee-4950f65c756f@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E0320C0012
X-Stat-Signature: db8adnb9ehkrks3jkx5w5idf7g1whicr
X-HE-Tag: 1766142213-468719
X-HE-Meta: U2FsdGVkX1/4GXfWwd2bxwm5QWFqyLEzbEkTms39PvDUsHKdx527ooIcx0WRetDPKSWDdv40hlon8hkkbmJpW1mn2BNGa5w1isCjGAxwTYfQOfncKmfhfSXNQGbi56U7VOCChL6huvExJ2sC0bXapfbjItgx7dCAKXDE+jVYBIVofJT6scRJdPD+5PSxGDKbtJvCVe6bNot2DGjeb7xQDyGSEx96KT6u2gNJFXN06s61zgXeMU22US2h/QCtbvILhujxyjYz5eACC9oI9PV5UjQrMjJw6qPOLcaCvbjD7ak0zv0XG16s9xxiL+j1WI7YqyhsDK5adINYjwb7MXvWXXiwEOnN7YkjEqvPoGtK5Mr+1y2rMIzB7H3yTU+WgPyv3iC7gV4tlqYFDObDQTlH3jMwL2OyQe27KYWE9zGH2Ve8NpLQ8WnWzNQzaW+whJoYvXOoc/x6WaKS1Jy0gUqAJ9Nog512xPGdJhMfNyVNMR7ZtHMbTzJVgCqf3UyWCTspqcbu5vsS9BGQbolnhmIDPM+e3mD6R9/fA8ZDO8PNAtofkL/maPacmmmt3h7CjQUMMaIdzmI99VoVUfL9gHEQ6AJ1mF5sNB2//NmtTUIrhkOcT9mIeZkDAXAqdWMIwWNIyZoTpfwKWM3efer8oWiztVcEGQCRBXbBPRux9cK3VEViBjItNqfA3dfoR8kwruTMqr583HrhgRaaVIo+t5Jnq9WX9fCm5Cxh3z4NORFwAteZ1SoClonmraLyxqDFjOX/l++chFOuTBYbr4dWFB2/6o9X4AdmwYYhrwu2atpMlcacfL0bemRVnMVR0zPdvr+OGZ3w6qnFgupkquYJut8LfOkcBwrPRr4qTs1VV8dLlaORLJxkrpzHgP+4GRWvZjc4/+g80PMhoD4gRQdWsVBzKyayMp4kOomnuhxQCZ/oH4bNzUdpJkfTbtWK6NBKWWji7z02jBA/EpONzf6aisQ
 BMqOlPN6
 fuHJC1cU8pPX+wYXdCA9+uHlWRv2H+8BLu1hecayZqA/yk2LQxy5etWH9Y+Fa5NO2SMOuLjl1d7PwyEi006Iw6Dmv/Gjp4mBTozO6cZoWu6zSJXzlPDLTI9LmPp/vKhFhAVd2TYTqvLrmR5tidEqONcYfAEZCrP7aLWO7zJ6mZ0ow2GvvfweQimx8M347KKGW1I7YN0azhqk7m61kwgYH125JqA99n4zExXO2/izZg5admi0GYYbrV7otwfOUIpc2DN4W7jI0X/XWeIp2KSP2rDgKQW4sSnp8ZRcoMHtHM2tfdTE2hXz4bBiUGHnW2/f6dBkegxFQylePl7PtW+4PFeQI1NGnizf6W/oEm2nNladSWAK+fhh9XpsLEFEiMWxSXwprZloR7X3hDmMmlNUkN0xMFsnGRGIcGZA+cCa4oPHfFdHdxayTzk1LbtlJ7t8LcbSsoVXoRHRIn66EJ7aT0aDqveEA8xcVXB6Jt4G2IaiPMdFneJ0Y7HnxvwgCXxQkKqO2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--fod3fa63ejffuubd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 19, 2025 at 10:28:31AM +0100, Paolo Abeni wrote:
> On 12/17/25 1:16 PM, Joel Granados wrote:
> > Remove superfluous forward declarations of ctl_table from header files
> > where they are no longer needed. These declarations were left behind
> > after sysctl code refactoring and cleanup.
> >=20
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > Acked-by: Muchun Song <muchun.song@linux.dev>
> > Reviewed-by: Petr Mladek <pmladek@suse.com>
> > Signed-off-by: Joel Granados <joel.granados@kernel.org>
> > ---
> > Apologies for such a big To: list. My idea is for this to go into
> > mainline through sysctl; get back to me if you prefer otherwise. On the
> > off chance that this has a V3, let me know if you want to be removed
> > from the To and I'll make that happen
>=20
> For the net bits:
>=20
> Acked-by: Paolo Abeni <pabeni@redhat.com>
>=20
> I'm ok with merging this via the sysctl tree, given that we don't see
> much action happening in the ax25 header (and very low chances of
> conflicts). But I would be also ok if you would split this into multiple
> patches, one for each affected subsystem.
I'll separate it, if I send a V3

Thx for the feedback.

--=20

Joel Granados

--fod3fa63ejffuubd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmlFMP4ACgkQupfNUreW
QU9qUwwAlmPvfPWAZXoczrqNX10TSmK+zcMEjDLQKvStlSwsGocQUBWnB/M8tJtm
1DYS6640oD5VprVd6eSw19rI/ahQRB6T0o8DoW2iwUN7wzaIMCEdIUtp1Zorr1fh
UWhAlu1GdFI78+PucFOwbvHuwdNpRNkyUT4lumBWNaXVijjDlq2hz9wlXPoB3deU
KsOQ+FfX2H/Znoeml2GduNPeWKXZU1kU+qi4XrAX/WHyYb6h+1Ez9CU59xvngKxL
kWKWpPc5rHlB+FoPsMiwuktdZhn0ThIIAhYTTe31QAfydLFPY8wtWRQ9XnE/jAuA
UZaGmli8UP0y38Id5gV8/mjXYyB2ovQLK5XT5XkFW6ohJscZGZ8l5EIWkHsLUInK
0/k97WE179oY00w9IBJdxO+xs5RdQvqpciXOeuAjj25vRUS4LZg2h1qlOiw16T7P
sZnkXjrb7rcUXaeM0WdpblGdKtYwKA8VATOffK6wgXLDe+gf3ISdZM8LVPmc21wK
ECPWoOA2
=E/xk
-----END PGP SIGNATURE-----

--fod3fa63ejffuubd--

