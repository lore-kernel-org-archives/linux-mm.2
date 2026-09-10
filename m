Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFF4CC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 09:21:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED37B6B008C; Thu, 10 Sep 2026 05:21:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA4036B0098; Thu, 10 Sep 2026 05:21:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE1E86B0099; Thu, 10 Sep 2026 05:21:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B8E956B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:21:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C3CC01A0497
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:21:39 +0000 (UTC)
X-FDA: 85197309918.23.451BDD9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4077FC0008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:21:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SWenu4/b";
	spf=pass (imf22.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789032098;
	b=4mSuOszuLvuBJV+gb2K5fdT8Hm1z94XtyYjwLFORIP+sz6n2TEIz9DlLrhGuWvFdCiBC9i
	qdPmExagtxan8U1rC/X4asvBOdbxmv8bmQGRQT4BKxR6u1cW83EHXmSdgwahFUv6zqUzv+
	HMUfCkej5S/wM05y9JZJcTFk+jpLVRg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SWenu4/b";
	spf=pass (imf22.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789032098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=etegQPhHDYYXKpgN5HhrDD3ja2BilOp/q9xebohgcXg=;
	b=f3GICh9k5x9pqlwbRdWHOHb/J95cvoj8lxW8cNLwnjgN6YPn30CTo1DdQp0hSv2zlxmpU+
	JxZ01pky6AlmugEzV7NlbQcl/yyvcCurRWlbUQ6Gx6cxr0l52oK9sIKs6Cjjtk8Qkrmszj
	puTpLekngftv3FaV3PBN2zq/jwHsmVw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B25FB600C8;
	Thu, 10 Sep 2026 09:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2DF1F000FF;
	Thu, 10 Sep 2026 09:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789032097;
	bh=etegQPhHDYYXKpgN5HhrDD3ja2BilOp/q9xebohgcXg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SWenu4/bhQp/ebHqQ47mZ8ttape8v/6aPUf2kjB/Ld/j9zBiWoVDmMFM2WXUeFpA4
	 Tz4kQl6h6D02ibEHqRfMCGmzm4F4W385fd4iPw4EV/b0R7FrEPUyPOdgqYghnwGSlg
	 wlCNkIv6fYWAYcTfK4O6DgrRMLRvCHdb42c6Z5fPxcblq5pU74lnZfaSijO4QJtgql
	 XWi5JzunvwkhvBE8/kV9Y4Q9psgLSZ8fOLaxugK+zflWpyfdSLe5ID2gv+8YzALlTs
	 DNEG/urmvrS21JPGf+b18of+CcOKc6HBFiQHYWy3kARa8VmrNDWDGEakhoATI6H2NQ
	 gKLgojcgqTT1g==
Date: Thu, 10 Sep 2026 11:21:34 +0200
From: Thierry Reding <thierry.reding@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
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
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
	Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
	"T.J. Mercier" <tjmercier@google.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Chun Ng <chunn@nvidia.com>, Mark Rutland <mark.rutland@arm.com>, 
	Saravana Kannan <saravanak@kernel.org>, Thierry Reding <thierry.reding@gmail.com>, 
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
	linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
Subject: Re: [PATCH v6 04/12] arm64/mm: Export set_direct_map_*_noflush() APIs
Message-ID: <aqJjL-kDfl2_wwHG@orome>
References: <20260904-tegra-vpr-v6-0-79042cfa8de5@nvidia.com>
 <20260904-tegra-vpr-v6-4-79042cfa8de5@nvidia.com>
 <aqJFb3VtsYtnIa1c@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nc5ni6zymi4hrk6h"
Content-Disposition: inline
In-Reply-To: <aqJFb3VtsYtnIa1c@infradead.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4077FC0008
X-Stat-Signature: 9utgqo3epw7bi3jjwwrrhcdxyz43xcsy
X-Rspam-User: 
X-HE-Tag: 1789032098-252905
X-HE-Meta: U2FsdGVkX18lUv++V2tVgFkOm5J46+fiC0yejBAJBdWz+Jp9I6g0EkjsF60TCYgdsB3HRM6vYglnIWN4A9euiYmopRPvFXDN5cjXvlQHowTX0FNmTIhbjIk/5pFEE2wCr5U95VLRqmz8hhOk6ps4q+Iaia70D/T0OjsH4dA6GsX1U7o7cnIdujw4j5G3E5W6oqmxQn6pPQaxgFMCB421O78HDI1M7kXjeYibJI7e4u0dQQlEIn7kEf6ydvom4UhBgFKWj7KWry0Y5zSQW7GTHANogT6vDSrZ/0S/EWRroFwXiGNupt4QrAN9fcxYOrr70u1wYtZkdPKr3n8MUwol2vgw1mKUX7iLckUSvBYzIMieAG9GmKlnF7Rvwz8xq+HgXU5ZvuQ2JpGwtBNg/j3Or4eVeKiwzZ6f9EwY3eWly6x9SVUu/9uMxmZJBN0gjftZ/PaZ3Tq6ewLyvQWWteTt2IwKq0LgVssHPeEa5KOENXMi8etAS74YIN7DxBSu1+p0RFxdHOCHfplVbUPJ1jt1bjDbRcNzF8reipUQvTIKAAJY8DIff/kNoDmN7AUBEU2uZllJkPHpokT2QjR452s1mpup77rN+cgXrcqsCkXxpOxRTc+e7rgqIp+5sQ/xxbN6iS3bhLdM0z7im3vK80wNRB/FRKvAvqBA45Q2lk+afLU4W58hnJ1V40KCsLGYCrtA223ZG4ww5HaETvbYqmj/F0Edh3Re5KcOCyrbeTf75fnyNOK1UO3mrMTjQkfXZ6wKVGJ16uxqymAyg4ACSYie+SMxTAjebW34NTVi//TjdrzPT0T87kd2QOpj24tIflyHUZ+Vwi9lHvZloKo/rubU/jTXhdlv8iudAJHyBSIlv5VyRq9EPp9Fhny34nD8vUEJalguMTnUWnOL2AxAgj8I7sdu+Z52wSMRXP+DD0H2SATduzgla35IfMH9UAasmwazAOmDurexTgiQnG/GTM9
 FcFlYy/2
 8wPppFMKKNN2oH05ORWX0fnVaSE1U0azcYMHV7W+p7pf4sLvFuJhqLRwtGp3E4t15h6L6nYdtlRDQr3kbLFqvjhJ4PmUchcYCFUtdOnooAS8mwmLIHM0Q/v44dePNFAfQ20wrIYdMvfzNKqVn/NUFcRoqWcmGPbivP3fx59xAFTdR34oAGblgGDOwXwYHDoJxcKy/Vk6gqy5TaeyHvKiifesehWP5kaji/tuEsIeahHvEEKimPwaKcZ1QGuBiIBuItZhyJBrJaH2+Cvd+G7gwobt2TjMM8lEqJlpE0mpUWf/jlqILtOk2IraiO5BPoLH3SqQyTrQLPWeE++FkaVCNGHlRoF81wrLLZ9A7yTjlCWtvBv3QEQl9ISqe++Oc7JHNDa6WH8PbNC90kaWY6mFJOoATRQXK42iwh7pEUxUToT20HtW379JQmx0srQVjslSVoJTSARNsm/pbZ6Gkaez9srJsMpa5vt8fvyHq26CtIMsGaQHTu7mE2kzZxsuC7bwOniVpeQLvrHmV4X3mC437ImNvHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--nc5ni6zymi4hrk6h
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v6 04/12] arm64/mm: Export set_direct_map_*_noflush() APIs
MIME-Version: 1.0

On Wed, Sep 09, 2026 at 10:51:43PM -0700, Christoph Hellwig wrote:
> On Fri, Sep 04, 2026 at 12:44:55PM +0200, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > Drivers that use this may want to be built as a module, so export them.
>=20
> That's one of the worst commit log ever.  No, we don't just export
> core symbols dealing with the kernel direct map because
> "Drivers that use this may want to be built as a module".
>=20
> For one exporting this at all needs a very good justification and
> not just hand waiving.  But more importantly if we can't avoid
> exporting it, it needs to be exported at the tightest sensible
> scope.  E.g. for a given module if it is so special, or a namespace
> if it's not that special.  But in doubt we should have a proper
> core abstraction instead of opening up direct map manipulation to
> random modules.

Fair points. In an earlier set of patches this was abstracted behind a
set of set_memory_*() functions, modelled after set_memory_encrypted()
and set_memory_decrypted(), which I think I'd still prefer, too.

Is that more along the lines of what you had in mind?

Thanks,
Thierry

--nc5ni6zymi4hrk6h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmqidpsACgkQ3SOs138+
s6GwVg//eIawY/jpVU95C05IvqaJG4LAKMlyvX0vCt0yTbFrsPQhY7RDigfanDMo
ycZhJCp/jyLprOkhxYEUmbLqCr6cn+5taI7LSQYIjkP+XRbG7rM7vYOynCANDeOS
uvUxtRu/8HlB0epcBAco9xhyX6Orb7w61HB8DspHAB/maQpHwCg8ce2/etTREXvK
qXc3uVrtfrsVNKgZgNtSuHcYX5NyIIwuNKc7rwiU+Q3EFcYAF3RpG6XCrncuKajI
GReiAWqBsyzzgM93zbemv3DKjbQkqVBl2fSZzTeguSv5KrJnFFd6n+JnHpHMPQPJ
gg6l3zWb7P8nlPRtlEJh87sNZJ3F8nVYStP5WpaCgjFDW5WrMcTTj/SBKMQqeroe
tgGkEMSMZAew1mtkyy5v0oaaialjMZ7796mpFs9J5GZv1PilvW/3Gn7D91zK4Yii
N923BVwEz9EnkPER42dP9AfLUCDE0lwc4A5t7ezgKbOKLXUIfDN6zlZe3jWQ6LO3
ALOl0JSYvlMX2izpQ4Pyl0/CSFHa5im5+5+o734Ql7U0mBOfpYYziOfPE9NJg5Xm
hINUJ4RiAi1x2e7iP05HqJutCO2hXPdalSnK5rzuosZjqma4SvMo/Ma1P7bcFkJw
2WDAAeRbtHk8qNOioz1Kp3UhdQCwFSP9Wa5RAtfvrmhE1X5Ap8I=
=EeFB
-----END PGP SIGNATURE-----

--nc5ni6zymi4hrk6h--

