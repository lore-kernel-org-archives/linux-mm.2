Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84F24C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 16:31:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E9E76B007B; Thu,  6 Aug 2026 12:31:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79A116B0092; Thu,  6 Aug 2026 12:31:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68A346B00A7; Thu,  6 Aug 2026 12:31:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 476A06B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:31:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F9E31C009F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:31:07 +0000 (UTC)
X-FDA: 85071384174.05.074E477
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id A40B01C0016
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:31:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P1kXRt+y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786033865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mVTwW0b2WURKlJNz5W6ur6Q9trw1irf346v/mtsQRWs=;
	b=cKHk5ulmEDmhESZBu01ruMiMJRVTYHQE0v6TYTcq7XYhNuk1VB8Z5Svu9U6zuCR2aSRf9b
	COP6Ho6Bj89LZGbDiefYMEAna9GMdQPNY1G0sjB8RBPejEw535UAIpQPxNkvPzUAY4mUKS
	GJrMVnqayTMgl1SMjuWOscj5prwCB4M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P1kXRt+y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786033865;
	b=t7i0uq+MonifIgpHPORJ9gZUAD/hNmLKZV1euHkE8lr5oWpJcWxghq76yVKPD8lLka/S20
	NYvPnQ5QCtM5ssYH159yaFfAC1gD4Ej9Lj+0HNzHRv5RfaUoff0svyZeEJRqnI7C28MPjP
	rwvJzuNGAcQEhh316cQdKKJ8gQBpvHs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1092360AB0;
	Thu,  6 Aug 2026 16:31:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135FF1F000E9;
	Thu,  6 Aug 2026 16:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786033864;
	bh=mVTwW0b2WURKlJNz5W6ur6Q9trw1irf346v/mtsQRWs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P1kXRt+yoIsWD7ulhfbS3urOuVuE0SbPvMDxieMb81wACWsaIkq5JOoANzW7S8NWx
	 J4fqscMVF4IvMA4A+ZyRcGi0cMYWRm03UyH3hRQu7dJiZRCTeFLT3MM1bCRaAr1/dQ
	 Wzyv+1ZLBNqWJj5KtPgT6L6qt2ViX4mrbhABS0c2K59hQ/rk5vF3QtJfGoYwVTs7Pm
	 8qo2h9eKBwfZAv5ivqMMODftIZf+/eIV2YydgQxJmFW66KSbq2aFP8It6DXFMsSP7E
	 SJIUOL5KNIfVP1j2jZc4I9RAWvtZYm1iUOuYSejOF40J37fdh5bmrCbSSKxhHw9NgD
	 YOSMfYvvnXfgg==
Date: Thu, 6 Aug 2026 18:31:02 +0200
From: Thierry Reding <thierry.reding@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Jonathan Hunter <jonathanh@nvidia.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Sowjanya Komatineni <skomatineni@nvidia.com>, Luca Ceresoli <luca.ceresoli@bootlin.com>, 
	Mikko Perttunen <mperttunen@nvidia.com>, Yury Norov <yury.norov@gmail.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Russell King <linux@armlinux.org.uk>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Robin Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
	linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
Subject: Re: [PATCH v3 06/11] mm/cma: Allow dynamically creating CMA areas
Message-ID: <anS0nxAwCXGWZRl9@orome>
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
 <20260701-tegra-vpr-v3-6-d80f7b871bb4@nvidia.com>
 <b1c1693d-02b4-4c5c-bb0a-1c2d87258d30@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rscp6jw7dv2pn33g"
Content-Disposition: inline
In-Reply-To: <b1c1693d-02b4-4c5c-bb0a-1c2d87258d30@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A40B01C0016
X-Stat-Signature: atm13jfu7qirg77inff4g1ingsrbr35k
X-Rspam-User: 
X-HE-Tag: 1786033865-311910
X-HE-Meta: U2FsdGVkX19zK+cr3A+vmlaWZP7/ETA8QjxeU2dCUzxMGuPouPLtdlfRHVOZnrDffNKhb9NdMqF0FQACCNcF4dUyvDFRZAi3JhUBN55k2sLy4Y80tbY+redUM4ch2SZ9sRZ2sndwQXxohWxSLZ8e1bsOi12lc67V+fnDL4an8prChLyQpMYY5puFkGJdQjva4rlSoN/4fstHjO+tBrbOYuBvhki20G/2jSnbAoe4pLUJawU3Ete5pVT62QhVjHeH5U1+AvIsyhjq7Ggx8A610SbjSN44XPMhTvaRG3elt8F31zCQnWgVwFQaDKZBnsb7yIKDN4SVaU11BwkoUCtewo6qpc2AydR4LMWxLHTcP6vXmu+uzL4a8xmoLXyQ8B+qZ0YRh09JqYR1H6zBc95cWQiyOb3DU7E6kclG59YR9/HxRGbu/XkTRfnaxHFwlwTKBlds9yegAnQvzw8cDCYubxbe0QPdJrPgzF3ElSlnQcMjBjcaGoFmUhhQc5D0DKYGSv7kBBsny3gNnmbJFL5mXSby4DdRVg4y5Aoey9nZmsKSWaktEUAG+3SPTHweKPQpbt1PeMHG+K8IJ0oT41fMA/eu6HykHnrBUMPQhO7gcYOTBt1oahVe2JDJK/9Is8AsrN2kSHo1PqWPl0fPqVhixu4/dn791cHVCVvuCtqkMkbsQaFYSt1GFnMeqZENez7nt9ktzDY52yAqaGSSQ5xUbSkwm/zWXq/f2NoFB39Juiq2Bansu/8yBB+4FuhC4jhSHxcgfzzvM+6+m7GiHD4e7ln8RAfepjti9ROQbsKAQ1Gm86gfhK6875c/R7iLXCzPoQzQ+mz88MI0kcw9OIdbVJd6OyFgl3NiSCESqZ9SAvWBspwK8JW541BJg0Zd8zACkPyPf8JDzffGiUMB/SztgiZ0dwXOJjRlf5UG+O8qWId+pql9PSYlhCbX5KJIhF7csM+rfvasrJJYVVqg3lZ
 gCh6cHsN
 z78OlyNtWUDtXu81HudZ7kQ3eCMQRJKrGvUzm5POCdKlXOsPLE0fpJpYkyHUGyp+qUH9n0ZKBE0ZZ2gDjhj/iuv2/Jhp021ouMcFA08XaE2DwHRM8s78GQsmtf1Gz7ZADvG0BB+73TBRfD8bhoO8k0UcRVCmwg01j6yHMUpVryL9jC61XyasX69QG2Lfp5mhX1opGlyGUKuFCkmw8Nvw+hiu8n41hIyFtJw2I+A71K5MAxC0NqR5QxLhhPmi1NFDknroZE9YE5YrBrMIZ1dVn/oSQ2ZhbSVlhoImJH3mmfE5oQcE/KXFQuODZ9tuoSoY8nXaPWJ3kojz/emUVc9whoslqDcuvGcvtIjnu5yiywQ2/q5T5vxL4uNUVIaDDcrStFmjzHzREJTapQLhD0o8mZC4FNcqdG5Zd3ViAxKDBWeSV0JUgexrru9VnQkXDUa0KyAY8u7CtoonZAMUx1okSDOmahJjBiS39gyDfVcCA16+bTSM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--rscp6jw7dv2pn33g
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3 06/11] mm/cma: Allow dynamically creating CMA areas
MIME-Version: 1.0

On Wed, Jul 08, 2026 at 10:59:46AM +0200, David Hildenbrand (Arm) wrote:
> On 7/1/26 18:08, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > There is no technical reason why there should be a limited number of CMA
> > regions, so extract some code into helpers and use them to create extra
> > functions (cma_create() and cma_free()) that allow creating and freeing,
> > respectively, CMA regions dynamically at runtime.
>=20
> I'm confused. We still allow cma_create() only during __init, right?
>=20
> Would we expect callers of cma_free() after __init? Or at which point?

The idea is to allow cma_create() at any point. I forgot to properly
remove the various __init annotations to make that clear. I've done that
for the next revision.

Technically cma_free() could happen any time a user no longer needs it.
While we currently only do this on error-unwind, the Tegra VPR driver
could technically be turned into a module and the entire region be torn
down at that point, including calling cma_free() on all the chunks. I
don't think we ever want to do that and it'd require a bit of tweaking
to the OF reserved-memory code, but generally speaking I don't see why
we wouldn't want to allow cma_create() and cma_free() at any time after
__init.

> > The static array of CMA areas cannot be replaced by dynamically created
> > areas because for many of them, allocation must not fail and some cases
> > may need to initialize them before the slab allocator is even available.
>=20
> We can start with a memblock array of an initial size (like we do today).
>=20
> Then, when you need more space, we can double the size (copying content a=
nd
> exchanging the pointer). Either allocate from memblock or from slab, if
> available (slab_is_available).
>=20
> memblock does something similar, see memblock_double_array().

After replying to T.J. I think this static array is actually a nice
feature in a way. It allows us to more easily make a distinction between
the regular CMA regions created from reserved-memory regions that
represent classic carveouts, and the more versatile CMA areas that could
be used for any purpose.

Telling the two types apart could obviously also be solved using some
kind of flag stored with the CMA area, but at this point I don't really
see a reason why the two lists would need to be unified.

Thierry

--rscp6jw7dv2pn33g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmp0tsYACgkQ3SOs138+
s6EDqQ//VPlX14ZCCWQFTzMM+CH1U7z90n2OI2r6sVAf3mIXAqF56hCOe1TSTHch
SLJpzBAU/F15bA6jirr2jOS8SHr7N0C+ox5M2yoEGywgGsbTEOjWSvejWrHWkJ9m
7fdcdEl/hB7yzbpBvDMxGiATg+0SwQrhy4Sp7105QzaPpE3/9dS5UXbQuhsbCcAy
4fU7Xd3wOOLcxg5u7Fl0ggfWHiAX68o32alTzPijPaVubxFJ1RnLQLeNhTdwJv03
nvh3RVR8dpDTY7hZbsTr/4r5+4L3ktGvufT5m3K0lImfKVb5hklsKVbNTnQMtJ+i
nAC+BTofn33vMautsZwPhhAQeesfMSJkuNASPD9kqZ0U+b+W7XtmmkmwbigS2r9u
1lajCmiV77/KeZazBydPFJzqt+0lEkLAwWtBAk+M/Fw0Lsx3/ycfApXqEtCv/Jfw
G1oTIraXEv0tXgSbl0Q0zAY/TKTgTmtNqVNbLJh2VxhQiicJGiEYZ9w7i971TlUs
obsrwFtpOrWdkBI8VFGUm59sNK7yjrl2XWpejZ+xmhY4GanpuNYf/Ki6nBhTn39r
qUNyB63c492tlL7PYUHVx1tMFCMwDBPw9wg5Dn57++j5s3gmoAmgqaAykpl/tuhB
lRoRWYWo4mgQ/C62svXRtyqVx5TMhQpRLrpQOAGdx4y6SF4GmGk=
=TjKb
-----END PGP SIGNATURE-----

--rscp6jw7dv2pn33g--

