Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ABE9CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 16:27:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B11496B0005; Fri,  5 Jun 2026 12:26:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE9826B008C; Fri,  5 Jun 2026 12:26:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A26226B0098; Fri,  5 Jun 2026 12:26:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92D0A6B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:26:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C6891401F5
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:26:59 +0000 (UTC)
X-FDA: 84846388158.15.5942423
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 81EEC180006
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:26:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LJ5AwyI0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780676817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r2snqK5TmvBjLf7irf+fuZCEZasZ3Pbn/RhGzf37Nzs=;
	b=4vEcnZmi9vy2f7AoQTJdAJC/Pes1mMvBucYRILUKw69/VO1bykK4e83j+raTZJwDfxgQ6h
	QEsuxjTsua3kDPTb5jv5eqAOp78JBNBNctbeIGL94J5tihI7irmqLleAgZN7CtzCHoi9NO
	E5cCCaz/iuKtPwhrg2xzJCcNT0bMyPc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LJ5AwyI0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780676817;
	b=WY5HmO0Y8B1aUKTe1tRhzJuojIHQzkonaOliOfHDsy6jJOqsDBpKs56qOFdG2GKLpDL0Ri
	Ti+UjkTsaJwIeDeuJG9ycRgeiNCqONpqo+MAkkjUElXYyIwoRSIyPGNM6wd8dHqIyQccda
	VOZySLoJZsmH6ipSvHPGE6fycwa6fFk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DB994601DD;
	Fri,  5 Jun 2026 16:26:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B91C1F00893;
	Fri,  5 Jun 2026 16:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780676816;
	bh=r2snqK5TmvBjLf7irf+fuZCEZasZ3Pbn/RhGzf37Nzs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LJ5AwyI0OawYi+sL2VqoHYRDXQly81j/iq9Hu1QCyRV/oI2u+eo9HKRwCt/seMVYO
	 ZdU6gjCh3epPP4w83HFdgfua/mqbm21w206mpV8ljUXevWL42dnlA3Suzgo//DxI7I
	 exdSX9Ht4UckbFS3Yt/N7DLCSHKGx8idhu0gxBx29CuZCzwcXoJtqqrXjkIjBaxGOT
	 lrH8m8UVsyKbN2OWhs8A/Oneh86jVogUhkO87JjphEqpnAKGqdgeufNOTMLNklpySA
	 FlVFA3Q1CzPGOayBya4B24imwrQXZfdtdyUQ8YqUsnsgzWIlcrRTQJK56ddknaN3vo
	 xobc9BNb2BBHg==
Date: Fri, 5 Jun 2026 17:26:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Askar Safin <safinaskar@gmail.com>, linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-api@vger.kernel.org, netdev@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>, Aishwharya.TCV@arm.com,
	ltp@lists.linux.it, Miklos Szeredi <miklos@szeredi.hu>,
	patches@lists.linux.dev
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <1eac3b42-5dde-41c4-930a-d74cda9e6d68@sirena.org.uk>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260531010107.1953702-3-safinaskar@gmail.com>
 <d9806b34-fc73-4878-997a-95c5e8ae4b29@sirena.org.uk>
 <CAHk-=wjBZAzPdZgEeHAtSiwJpomt8ZZgKbixuiHfRm09a4=PtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="g/nnWGulOH+szEAc"
Content-Disposition: inline
In-Reply-To: <CAHk-=wjBZAzPdZgEeHAtSiwJpomt8ZZgKbixuiHfRm09a4=PtA@mail.gmail.com>
X-Cookie: Error in operator: add beer
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 81EEC180006
X-Stat-Signature: 8fc5ww9nmjs97jc3fus931kw9aaupn97
X-Rspam-User: 
X-HE-Tag: 1780676817-229718
X-HE-Meta: U2FsdGVkX1/J9nXgdlJIRzbPjgpUVOlZeQwPx1MEWxPJwYjN5OxJpHBsMj7SCcZSnZPv4yNr5DN1uJqCEl0uoLk7/2xJehnCWfp9e2P1vhDtMTbXvOsk3kPBDxP+CCMjuhKew5h3jFo2Cnxdf4h3nklFumvbOTxlj+NhaTqa0ohcZqFsxBN7y1SzXt6zSpY4zRUyv7rcbhPDquYkAoeRew7ie8dNQqIsgalXR2sz+VxZLc2/HDCW1ikGK4YhboMzQXEqilJN61DsakReFkRHA3QvTooF+zV638U8gvXOKjCWdz++b6lYiMUzQJbxxymCE+22g2nx/YN2XKU3P0Tk/swv6YSGDDJ0ktgkK8X52ntZKl8nXfkqLtXGYwVsP0lvf2/SprFjyYPxcmLvCmwQb1sAkL5UBtWFKZ5XdKDfaTtrbT3jqgoz+ass6GtPPuGJ4yysXNMd2DRw5aG7Fjl22tYiaqsz7F05IU0OHqJ11ETtpzG3BFCnabI0GmrRGSTUjnNT9/q+CZEhXrZeVvTUtcTZdkOmvx4+9wx67Psg6itcjbpZUknE4E+5vUVj/Y56BWO4ksyG5EUuU//2FSgK60I8KCfhVPoEiXbYsMD6vlFZqkGb9Xq3v8zM3U1rniKW4Dvz0KKc3H3IaZFMW4fSMcIOUUgvW6Os8BOFR4zc8fCyqpxTE+vA6Dtx9L7wmvaX9uHrrpq1yXFbixYm8kJBi5qj6tU3KxApH0KLRu5aXWInsrAxTqrO62RIlhxywhEZKz1iF+GhxjlygfWsGkHDZxJo0K3bet7/tjJaDZrUTOxpgBI2rTZE2/7HO4uolhnNIviWIe1bH0GA5lzsP5qDCBoTIg+E5GvIjf2mdrqXEOa63N2EgZh47IQEkM7Xf7ZWi2+KbuMDKxa9X8eKHfBZ7hvF0e0XKaE5YQU2zN/WNeUSMI7LyeDegM9H20AXQQVh8QrP6MN8O7R6eY6NeN/
 TRDkmt/T
 oP2qFbWgXfmzfLLB4ZRC9+X8CXnvlJYJ8BU9ZxYrB8H7P7RMUoMNnEEmX3/51r91CETDPDHh7BqWs1H0Fzligv3n5gaTOgCcLcMxah0Gwev9+YjpUIb6N2UZZ5ZFvgU700SXXgOjeKCUWMb5UKd5Z0AHp7vTijko3++/wDSGjQ+oD+xbqBoplvBiQrHRjCZK+xDYM8T1HnFBsMvYxiiPI4dUqF6grZvXKJGdGyQcDHvnMk3bnnyIx789Tm8btU9aNmVXTU8lw7wo00yvjd8vXNBVgfReWMxvl804uYou1tHqabGky/N3l5QBKrXrCvdUGnf0IFx1BC4BoGewYhMX7JftOb0p4gipxIr+Us9Mq5r+aLsA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--g/nnWGulOH+szEAc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 05, 2026 at 09:02:52AM -0700, Linus Torvalds wrote:
> On Fri, 5 Jun 2026 at 04:02, Mark Brown <broonie@kernel.org> wrote:

> > | L4472tst_test.c:2050: TINFO: Tested kernel: 7.1.0-rc6-next-20260604 #1 SMP @1780589917 armv7l
> > | L4473tst_kconfig.c:71: TINFO: Couldn't locate kernel config!
> > | L4474tst_test.c:1875: TINFO: Overall timeout per run is 0h 00m 30s

> I htink this is the same thing that Christian already noted (he said
> "reported by David", but I don't know which David ;), where the
> vmsplice() writev() emulation was done as a blocking write, even
> though vmsplice only blocked at the beginning (ie waiting only for
> _initial_ space to write, not then blocking afterwards).

Ah, yes it is - exactly the same issue that's mentioned in[1], I missed
it in the middle of the quite large thread and didn't directly find
David's report.  Sorry for the duplication there.

[1] https://lore.kernel.org/r/20260603-raumfahrt-unmerklich-ertrugen-c4ecae70d5f9@brauner

--g/nnWGulOH+szEAc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoi+MgACgkQJNaLcl1U
h9Ctwwf/XkRjB062vspvG1uidxqEpWAVutxYq5EvOG1EiujrqzC1HAdtvESiAulS
WTWxzQt+TKgaYHJ2HVDYpinhZEgTbOLChWHzER0hzObbMogvQsYUXwhn6NKNF7pa
wLasVL07aZdXilsSJdBcjzGOAkdbfpQMcPiO70YqrrCj/Dzcg3b7VDZwgWNmMJWB
ZCH7O8PaAk0UU17qB1pF7XsoK79IDMcyzwrj9XX7VqZRc2hQ3E1MU6B8vwY9QBOI
D+VetiwfTYgkb/yweZokwkAIH/o64w7mfBvi8SXnxBcKEfqvxELjjeIaD9DynXf0
GM/haoPUaOz77nGe3hZgodaEqpnoBQ==
=H14S
-----END PGP SIGNATURE-----

--g/nnWGulOH+szEAc--

