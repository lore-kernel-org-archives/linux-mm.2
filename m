Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68117C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 12:45:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CFF16B007B; Mon,  3 Aug 2026 08:45:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 180AD6B0088; Mon,  3 Aug 2026 08:45:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 096A16B008A; Mon,  3 Aug 2026 08:45:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB4356B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:45:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F83E1206C6
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:45:06 +0000 (UTC)
X-FDA: 85059928212.19.191F9E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id A50CC40011
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:45:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eqZwxJrd;
	spf=pass (imf01.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785761104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HLCj5xwTRyex8jZdnwDMK0YActuPwnD6AwN+TvSUMFw=;
	b=ZfucUpIqpwL06vEKm3+ZRxZT/g0qhRGclVnM/wR1uvOwYBgMhVb9EQuoCx6Y2SMZFYwysL
	HkOsJkF8EWhuoaLL+8JOZzs3AoQEhUO05e4KkWW+ljvwqcPoGlf2f/9Hm1ChDyT2rX9aF7
	HnKpzb3jBnw2WQ0wkJeSvEPZqW9hlYU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eqZwxJrd;
	spf=pass (imf01.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785761104;
	b=vRvxdnyJ45Pcg4p7yxX2ii41b5fH4285esoLqzkFbBwcMrA8cBZxIhStsn3c0yP3s7LFx6
	3vZhl2Q4GOmporR/1yMuHb5E2LeOf+UhyLGVpZ5Gs7GtdqrwDSsWlv5la8BFg3os4MFwBO
	fME5hjDnb4iRwrHfujv9nfbQzeEQdTk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C189A43BBF;
	Mon,  3 Aug 2026 12:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA9C1F000E9;
	Mon,  3 Aug 2026 12:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785761103;
	bh=HLCj5xwTRyex8jZdnwDMK0YActuPwnD6AwN+TvSUMFw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eqZwxJrdOdlQPa3rTnZkA47Gq/L0PaeFNiSJz1c4/XlpmuS3bS6xnG5l87VMHfS9I
	 yjcLzHTl+q+VTapdxsE8dgUi1/hW4FC2ogP91/11Zony0BnBrI2oKX6u/Q28GkEbV/
	 0IOpO/GWFHjs5heWTFmZR/3aMurhG0JoXjdGryUyAOV014k0/HDZRcSJvZwPFN9G+k
	 84Hd69Fr9xMkObH9MTm4zZJO28/RzfW8HRPdOMKtCVYaco10OObbDEPF/96fhka7Q8
	 +u7dPKI4/GVlCGIGChv5RCdaja44tQzIZRexFW21sE2AdQEOmfQur8JO7+EJ1FSQGX
	 OpmYlee+PwrJg==
Date: Mon, 3 Aug 2026 13:44:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Leon Romanovsky <leon@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/6] tools/lib/mm: move hugepage_settings out of
 selftests
Message-ID: <58fe5c12-bebc-47a4-957a-ddc27706e2c7@sirena.org.uk>
References: <20260730140825.238130-1-sarthak.sharma@arm.com>
 <20260730140825.238130-4-sarthak.sharma@arm.com>
 <178574760162.1561566.5251738533303087247.b4-review@b4>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mUCfwMo8GRiVCaVh"
Content-Disposition: inline
In-Reply-To: <178574760162.1561566.5251738533303087247.b4-review@b4>
X-Cookie: Prunes give you a run for your money.
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A50CC40011
X-Stat-Signature: uyhqscp4pecqwj5uemf3c85dbcu3qi9r
X-HE-Tag: 1785761104-86237
X-HE-Meta: U2FsdGVkX19WYSXvoZInub2jieT6kiw8Rweu759Q8upmJMxsVB6pCFAwKuzHbinneCvnpT5oRrXABAfQbyL4O5Nw/Bx+d5BJm4/IPktgRLW5yoj1BBuabpzfheZK+kL3IS1WRWvdUwWle/2/VQ+G8WNICvJvU34zAGKcekuYfti0Ug4NdQYleLFQ03gqUROEcpeVbb3B/fAvp0lvJEQEhfjZ+KFVAzR7x6csmKGd4k9AzwCBDsbLvkP3/lUtfeeBqxZyq6cOIY3iihA0mmYiAD8nO/clje/dg0ahILHZzZSP2M/o8i49CmRyNiCFMjw10E0Nrnxj70F64aryCHZJxl5oy8LeHzp3qmybr8CaRaBtOL3SV3T/IR+tSGNoDGQfrnpamU+BQRazUnGmqIJI8u1dKUOf6aoZi6tGYYOqeYwpaiGH7YvZqFaBMDZNHurIttSDku540+5CKQtspppvbevkZ5rGrqQaW76tF8puArZFKn5NMzKIwq0i5wGPAKdgryKUpZLHMRRgEUw2IUyPCCxJFdcAjBCFCIzUQxPBEx/gXS3o/o7GDqFqr/OcafAB3uLP+sRfe8JivVXaOfLILOm94VOumKeDPyHmowndmaMrJp+WSZeji43697TNVYbdmMOkN/l4D5GO6JlfK55UNS5rKi0AUWmR8ZEjR4W5IjZsENuEBe/0xfgZ2e0WTmHH/C/j/Tcs6EBKOt3eNZc1jkbUnQtyHVsKGGkvlTW6XSoWvRapk6Ha9EulVJIuhMkRPMXPBc7iVKCKLr+nWnsd0MRLxho5A+yAysN7Ejqx9O0wqLhF0MlWKO8McNjmJ/MN1a4H240UEAh+x4+fkSXVwOGPpAMz/U9hrMi+Z14QBz3gQQabbd2cmESMlJR+0JI7vV1qk9Rs+RqALrozizUl/Kj1+uUg4F0vD+Hkyq3RJ8IWmJZZ3Lg0JAow1neIhbZZDZ4BL/wdcdEtapK03ef
 /aBkH/bo
 MM295rhmuCns+t+zrn6wPDLW68YpZiPEsHFG4sha7jcdOYRpL7oHI7l+yWaXjcg948FvnJ9vQENsAzUwEqarVt1RIVQ5IXVkNq0RIZA33zLhW7Ij0TvHNj2Ohm6890c0VfAsFiBwy+1T21giUKwi2JWRPqHs41oYiIiu4OH50B/Jl/gqX4AdFOAnNfcld5zYc83g1GzjexPla98ik+89i6hOM5wcSsmGOcwoKihZ7jP94MyYwPGwFdKz13fEIKkiAlCeK6aDhYCqK3E9ARc6gmXWt5xFEYyk1ty9sd5zdyRsMKdvazgjICOjuLjRxLyteayqoX9oKuPaRo9I2c96fYDRPrcriutc/3xRKLOhcMJk23Dw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--mUCfwMo8GRiVCaVh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 03, 2026 at 12:00:01PM +0300, Mike Rapoport wrote:

> > +#ifndef ARRAY_SIZE
> > +#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
> > +#endif

> We already have ~20 of those in tools, so one more won't hurt :)

> But really definition of ARRAY_SIZE() belogs to a header, maybe
> something to cleanup later.

tools/include/linux/kernel.h.

--mUCfwMo8GRiVCaVh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpwjUcACgkQJNaLcl1U
h9Bazgf/cfngbg5pby7Dmm2KlNQ9Z/Bg05gwuy7n/bFSKoqTanPLPUsK2h3toKB/
jpfIOXduwVufNrBBmQuAk6JyRkP7+xWNndv/fGM0rl62lHYSmo8Gf2Ug1TRT97rg
Ky1y3S1B9Wgk9ad+miUVsrt6ApWZbw3pZfOp8B0ZBERSVxuc0FqOmI/1MX2K6Mse
DwdMrkaLMKJNNW5nAM4RRoXQRIOVVQuDFsCNHIHJ8g41t99NS5vaifWGjSzAT3cM
JVn+Y4HnDZgCcpnEIBE+PG14rSBJS4IFwDbGbottbT+McBooSwJgJ8I01uGT+Lph
ES38vtIFI6V/90ilKpcxRYWSzpwzLg==
=I3v/
-----END PGP SIGNATURE-----

--mUCfwMo8GRiVCaVh--

