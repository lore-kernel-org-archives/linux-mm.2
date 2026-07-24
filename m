Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFB4CC531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 00:13:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF2D36B007B; Thu, 23 Jul 2026 20:13:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA4226B0088; Thu, 23 Jul 2026 20:13:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB9C76B008A; Thu, 23 Jul 2026 20:13:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8668C6B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 20:13:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 19A28401C6
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 00:13:50 +0000 (UTC)
X-FDA: 85021747020.27.E0922FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 78AF4100002
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 00:13:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dY1l+6xN;
	spf=pass (imf14.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784852028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vV8SHVjTvcYQq16HYBY/lONPVrjZ6kNVzEGGtrciPts=;
	b=uehurojF8QcFEYbIYXhVnUIjHrA1AwA4fPgZUvi6gOj0j03k3OVeET3N9eHsXQ7eYmzemB
	GOAG7i8XRqbfT5BYeL7poceEJBWKQ/Kgog4qpAa9pDCwaulWAM4LjW5sQs2I90xk3paqjq
	N4CkmXe6sEfuxAX6bVpDZI8OuWxtCwo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784852028;
	b=VerPLNQp2MUA521gUyTo8wenPXfwqm5dQpMtR/uQ007/DZzjtnf3uzhAk7oo5lG9mW+ds0
	DJr8MvP0svQiIjDCPBEbDRKxyJ8EkWBj/3csmrffWwU6Ew238oH1i9rcJsbaTwckyDyj55
	dPnO4abeNTA+y6cQaB+fvXNn5BPgk6M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dY1l+6xN;
	spf=pass (imf14.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D639B600B1;
	Fri, 24 Jul 2026 00:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9DC1F000E9;
	Fri, 24 Jul 2026 00:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784852027;
	bh=vV8SHVjTvcYQq16HYBY/lONPVrjZ6kNVzEGGtrciPts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dY1l+6xNcFo3rz4Dt3iclqEw2EUP3Ft0aroaZGaGqL6/XjguFqJ+XWMcYGYWWfYfG
	 MNfgUiONFWs7JFanWwteVGQ+kVLIA6g9/yqBElieVwGy07CjuBsdurJY3iAFJcyaGU
	 C/qkzvreZslcgvgowrVZXciNyzkAakDqsTU0xfepRjyaV2dCVDqTLr7TtJD9ZMZW2B
	 ceze1n/B4MKPrz2a5tBh3M1memlPANA6Vxn0aIEQODZp0MQB9tJdsee3gYulDNv1tP
	 E17ArD9dgqxzy+Iu1+JINh3pn2fee9OW8j1/az4JtG/9DYjMSd0YB8I5S8v2pMckZH
	 impkerrA2eyRQ==
Date: Fri, 24 Jul 2026 01:13:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Matthew Brost <matthew.brost@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
	dri-devel@lists.freedesktop.org, linux-next@vger.kernel.org
Subject: Re: Semantic conflict between 04b177544a04 in drm-misc-fixes and
 0b6b1bb28482 in -mm
Message-ID: <93289e91-ef9f-4786-bf49-e93d91afc1ad@sirena.org.uk>
References: <20260722225605.GA1910198@ax162>
 <amFPJc1NQbuYWlSp@gsse-cloud1.jf.intel.com>
 <20260723212724.GA999236@ax162>
 <20260723160942.b58b065d771401aba117bc77@linux-foundation.org>
 <amKftG6NRZy0Ii2/@gsse-cloud1.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fKoPW98d3CeKyWXz"
Content-Disposition: inline
In-Reply-To: <amKftG6NRZy0Ii2/@gsse-cloud1.jf.intel.com>
X-Cookie: (null cookie
X-Stat-Signature: j64yocqtso16d4t7gh96sdr57ruskj7x
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 78AF4100002
X-HE-Tag: 1784852028-4100
X-HE-Meta: U2FsdGVkX18bzLkvgHTNJFqdPccM0ydOIsd/L1BNs63xQazYWKh2/6ppBVFgyGEpEEFlsGT5UUwFaApDsj6T4m66bkcWNcraC8XPApDOkjz1KUOzvWGW1SVGhJTM9wMaSng503CW8x5CA2/Q27VCGNZDCLz40e/hGSxD8Gp/wiA6f2Ji3rClDWU1uNArmLHAsyoeED3f4iR6lFRPG0pt9VAVPEIvABYOqJsf2KxvTC1739Z9A0mJOF3/+Cx8SOt6L2k45UmtkvZ/XhqNbgsARaimRZNNlmBVIIV1CK+4Tkto1FmNl01w2YSes7HtDA8xqxZUbwHKdr/0gJeuhFxrJtmikOcW3q/RwJBHVhY65OXHWJ4QTJVLbkdPXyRWigdTR448Tpne0gN2P1ggRhnxaE2gaNN2jINoKDrvbPTqM0Y7pLlmsBVWAzwZW69wl6kTGQP3Lh6LkU8Slg9PXy8c8woPGjBKpJ3Hznr9MoLSzCS+/qlpj/MMFDjfizfAUGpbuPZNgFNw6vHEZdL5GuAMU9o72ypNXpJFsUcVhQv96OY2WzvlpQWcTxZvWKnS40Bzg6DecCIvAsD3Siac3o0Wqc3fkF3p6Oy6nJGzr4m6InOanKMXCiwHa0EP+yB/5EyOpKHAuyH54RuvFAuHE89xy2VRI7sBxqjwK/5Y2lWnWJBqrg20oF6ZX1n+veSNFsWUYhoawDAiKc6TWyJi4K+UGG4DSceIDH7XlFhlN2sY/RQ64y1bD9igZo1poo6ST+SNoLZLS/cQyzeKNgjG9gvqEtK1CWIspYLmZeA8LyhMF1DcglEfbAEwUM6vU8MiMHQkwTDXxkMHLUCnm5/lFtX7Dy5lTvGAisbnnWL76KPfAC8Q3cRWg9ltMgnL8Ayy15PqhebsHkGOxlpTfoThoC02afL6A++CkR64bASwMMv4eI0fuPxi3xNvaRh2jP7NU0ihuruVx6B8c2fkAUUJbNl
 41AO6LPU
 B+yLiwkYHJl0LVpKgA6dbdFuEmo/5jwgR6F6uJXFeHnCcCdkLqRO7VLl4RAB/Ejd/6yeEshr0Q1VNYx8Z0xAkVWiQn9BgCOvs3dl8liDagGoMfMXPkx1i7J7d3Ugp/pWjyrsUaaJ1M7qYJfD+vr3Kgb7zV0SaFu5lngV1eb+sogcOL0pW1dTwD1ox54H6cTt4JMsEgjlc9lYsj53xCstFTXKzp2Olqh/GPxw0mROtOQm9njIHMyg0SAQpu9o4AEBCgxjiNiuj58+P/CvstFKRAnbimWGZlg+1vMhKFhREJwSfDTcCt6w5s6TV7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--fKoPW98d3CeKyWXz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 23, 2026 at 04:11:48PM -0700, Matthew Brost wrote:
> On Thu, Jul 23, 2026 at 04:09:42PM -0700, Andrew Morton wrote:

> > I'm fine the drm people changing things ;)

> I'll jump make a DRM change so this is all worked out when it gets to
> Linus.

So should I drop Nathan's fixup then?

--fKoPW98d3CeKyWXz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpirjYACgkQJNaLcl1U
h9AqhQf+KthYj9FPBRNjt7aix5PlE9HA5FGCZpsxTVHHy1cvEyiZw/wwp9hNVUTe
emIcdoj3CNZDT5pkVttPqtDC2T/TOi+CSQ4oA9tJjENnDXAsT/riLdxeagqz76Vo
hkwo1c3ixmlItxRnTmPAu2f7fK5WpXaJS+ra6FUmyv00wKd3nwqWG+Bk5xNUZVLU
z3sE4+IlkU/EXO51fH//NX0bqW77sLFRr40gSDzAITZmizC66LIXf2s0SGWRtJlE
nhYpApQ96bL9os5zg3RP38naQQa2ri5ibgSsQ6XAVs7L7XIQ5E0lNmwjSOl80BQu
fVPDJ/W9/bQkgUEFFfxGmM5eCiIBqA==
=lo9P
-----END PGP SIGNATURE-----

--fKoPW98d3CeKyWXz--

