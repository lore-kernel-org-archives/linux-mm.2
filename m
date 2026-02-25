Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2471BFD376A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:10:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6559C6B00A6; Wed, 25 Feb 2026 11:10:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6079D6B00A7; Wed, 25 Feb 2026 11:10:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 539776B00A8; Wed, 25 Feb 2026 11:10:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BA786B00A6
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:10:29 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 313FA1C8CB
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:10:27 +0000 (UTC)
X-FDA: 84483466494.04.B0185F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 75A2140015
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:10:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lzYcXM9w;
	spf=pass (imf11.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772035825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0FjuV88iRjgFVMdtMmS1Y20Wa2wwD46YoxrvPNRD4JU=;
	b=hHW2t6gbu0Gc2GBFE3mkM6wXZnGXrRI34LyDcGdCNdDHxX8t3nerqgePb1Z8rjCfNJDM9O
	KpJqU5glKx/bv3y1hvlzS2mdRsufQI9DEobfUdieaXvk3VbSy+YuvR7WGdHjBt8gCE1yer
	sVcElLq00O9WcGx012X6IDsJf2smqfo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lzYcXM9w;
	spf=pass (imf11.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772035825; a=rsa-sha256;
	cv=none;
	b=PVKEydCqxtw+f0VqDfDCNZBgMpj0YkprQ+LYurVVLvAd8Il1ISyAlEwUER/Qa18d+lPlU+
	qDGRLIAYfT2rtC1AV93RXw23PoWQKXpqNfm7kOktrB0JVOeNhuhop++Nhsy04sOYq8+IBt
	yYtt64oXr3j2vYAtLR+EhbDmeJhBgZg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 772E4414FE;
	Wed, 25 Feb 2026 16:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98AEC116D0;
	Wed, 25 Feb 2026 16:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772035824;
	bh=0FjuV88iRjgFVMdtMmS1Y20Wa2wwD46YoxrvPNRD4JU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lzYcXM9wRwlqudnoyVaHi/I55B8Xy8UCCoz6ezH1IOtdpPvMR/sQA2F7Wrw/UjTL7
	 7qLIasgQVHpUrs9qghinkXJl463QSjytZOQuzRSoKz99Wn+M4+NT9yjxjiKrh8PGyL
	 hzd9Gs77pCf9e2fpSuPXoc5s9UfPMygz2Wvnyg7aZX68rW2tJ3pokAo/eCFMyG8zgk
	 WaypuvLE8XBEE7iRt8goVbdKWheQOUt9Wj3tNNgLx5GYaaIrt5BvuoUlalFevJXpQn
	 y0D1Ecw/aTJQAe0ibzeaN7ozxgHclMwRRrA6Ts9XzeK4ni3QX0NGqYeayIkY/QOhIf
	 qGB9IFWip9LaQ==
Date: Wed, 25 Feb 2026 16:10:18 +0000
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Deepak Gupta <debug@rivosinc.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Will Deacon <will@kernel.org>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/5] mm: Do not map the shadow stack as THP
Message-ID: <a44708a8-ec02-41fa-b870-a649f13072f4@sirena.org.uk>
References: <20260224175800.2500729-1-catalin.marinas@arm.com>
 <20260224175800.2500729-6-catalin.marinas@arm.com>
 <5570c06d-fbc1-42c9-9b27-26211e8b033c@sirena.org.uk>
 <aZ8aeHpn_KElP2jm@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="JCpLj7aWj71R06c/"
Content-Disposition: inline
In-Reply-To: <aZ8aeHpn_KElP2jm@arm.com>
X-Cookie: From concentrate.
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 75A2140015
X-Stat-Signature: cbj7pbfkz6ye3ae97muye8tiwpebyx1t
X-HE-Tag: 1772035825-518615
X-HE-Meta: U2FsdGVkX1/TGwayGtmGm/UlUpNwV9HJ9nYMLcJ3YMgEPYkJRPU1PB3NcfUiYwY1E2b27ykeaKpEV9/mQik/d7ps4te5f14Zn+gKxBz5uhkQ56r/5i36E646AkSM2DdW2yixGpr/S572RBJ9MjjcE1tUYf+xk0bGy17uJJYNO8SJGtEaAiD1AgIddVnP7Q6jowyXMoAJoc+K3SiRAQXewBIAj8vwnx0hdE13HI/SH0kv8XVMX4G9SKgPvpuTGIjcw18kBAmNoYJNy5peDEFOSchdgKZez84fr7QVx46hFjeOP5p6CX0Gp/RgSfLi8oNUqP88tJQ3YpWzmbe7vk5SW824vPgPo75kvcRHPj9r65So4qk9QaNC2kqsfgfCaD736z5e9hetGnc2U0dMD/PrwVJcHSAnj0HzijGS7JCtRxsw2kQtTf8H8HpGtgKK7oaEdnYSeGvv80nAMnolRkU433I9abgaXFIlL9qxdg2DC5mtw3HO40EHgsZ1OsJfgvjg4/Wg5+zqEWeetU+wqPSanPyvaMLVtGLtucoSC9Zr1xeaLDus1Y36sVXMhM0N/dzGcTOYP9p88TCyuyEeUcuys6ojmfaFyWqygMjS5PCqSyUQkde69SOvmtynBj1AHRs0dX5t2ElA1fPoMEc8v1OE9A6aD35x31SHhgB7cOba1MmHMsIQtUkoC4BZjRtkpRjO6rnpakpz30nZrUeEWoXgSFTWzNXluenaSxqKKoznzXOMxApTjUgm0++BgyukHkMCHo5J03FiZAfVrsEsNpam9f41sjud6+kS7GY01rfAO8a3PIqs7Q7Q1XifMg6RDpNY+3QgCo/Rqkuxfelx6xHlV/+o659pZqHYMfFwCwl65nnqxUTKuEs/pqxxyY48XzZGa0zpogeFA3sBRNnOZlzIapxyr9MO3enVITAYgP6bsc8hW9HsYUe1hXqU2nQ1ouDbtGe3uJUJot1TCNPHl2A
 gYcmvGQy
 dzEmCJ8Dgct9tcs8YkREMXpjrF00FLx3IlHuQt4QS1gPKYFe3qzyy/W47i8W7jsS+MZAcaj4eDkehfkZVWOxtbzJFoK+qOzvoTXOP+hFMEH3RS00fqrQKlVFk7Wh19o6EwibO0K2AGbOjDEIu8aZZcQ22u09LLsO49EOqpLp1MrCUl1IqPjKWjW4Oz87E82EL7kNWxooex/9lsxif8+b96ckrTo5K+rq1n71A0y5LSEkJZI5hHF0C5gG+0aisd2grIW5FmYBBuQ5uEeGJLPip8SHGEmjrFwToO7yFO8anjxzbU/ASv8x5bYEh3Gm9S5sQVpPKnd/oFUSkB4pI5x6xyI4Q051NORMY+9/9eYJh1UWcY+E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--JCpLj7aWj71R06c/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 25, 2026 at 03:51:20PM +0000, Catalin Marinas wrote:
> On Wed, Feb 25, 2026 at 01:02:36PM +0000, Mark Brown wrote:

> > The create THP and immediately splitting it pattern is very clear when
> > checking the mm behaviour on new GCSs, this should help performance.

> If the first access is a write, the kernel allocates a THP from the
> start without subsequent splitting. Also since 6.13 (commit 1ced09e0331f

Ah, it seems this has been optimised since I looked in detail - it was
something I was aware of as needing some work.

> "mm: allocate THP on hugezeropage wp-fault"), we go for another THP on
> write. It's still wasting memory and time to zero the full 2MB when
> it's highly unlikely we'd ever use that much for a shadow stack.

Yeah, for a shadow stack I'd be surprised if it wasn't cheaper to split
than do all that.

--JCpLj7aWj71R06c/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmfHukACgkQJNaLcl1U
h9BAtwf/eJiuRiBLDlc1QhGdxyYX5xad4l0NQG+kUJtFKdtf8uirsqJnCujt51Qr
oi3hYyDUFz4O/Z2t1tz7HZEzqsNg7qqSTquQry5J/pz+GNx68119fyq6YT5f17cW
KKZ6KgWRGOfLhml3l2nCxrXQRZ/tLSx1EHnN/k7n1ZufpMUFxYwRJQhY57kNKZ9y
mml970ixYEC23p4sl5MJkjWi2zFgLaBDs+aIrz/Sg+4Ge6VIh6FMFqVMuuHQJGJJ
3tfqiXcu6E2oCNv5uBt4XDKdDpxODdmi4GZfK9k6A5LdzZltcIxpv8PM+Lwc9pps
o5lAL+DVMVgg8sUCGoEI7MwS7QqF9Q==
=6VDG
-----END PGP SIGNATURE-----

--JCpLj7aWj71R06c/--

