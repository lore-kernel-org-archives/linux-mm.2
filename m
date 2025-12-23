Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A93A8E6B26B
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 01:07:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 194D96B0088; Mon, 22 Dec 2025 20:07:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 118596B0089; Mon, 22 Dec 2025 20:07:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 016AD6B008A; Mon, 22 Dec 2025 20:07:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DFEB36B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 20:07:34 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 74FC414043E
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:07:34 +0000 (UTC)
X-FDA: 84248948028.28.C584656
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id DCF7A140006
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:07:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CrFyOnk8;
	spf=pass (imf26.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766452052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s75WwS6zHxjLmxYTad6FpYF2GMJBMtpUdtAWmDGLC5o=;
	b=GRm0XKNNXfAFFSfXVz1sSw9/6vkWJlfTqkFHlYYW7vuGfkpIgiIMLq7PMcLZoS3QVbJvOB
	3X8FmywvT5gXCGMGfY6OhoMaGu6EB+Z7IJkeOujcVHsGKSy2kELHki2ciNkrZnKvIEvO6z
	rSGUITnExUlhRnag+MwJuPDsqiARbAM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CrFyOnk8;
	spf=pass (imf26.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766452052; a=rsa-sha256;
	cv=none;
	b=eb4Q+D7PF8AK/u6GrRiPgtnLwM7ODIK9cgHsZTSXqSNrXoHfNke1wUzhKY1w9Vqx/3DbWG
	uMquDB6xOn8kq9SW/tT6r+1QNG3FmNoDD3A80aJO4ltPQ8pc91CmEAvDqA3vq0JlNX/MHZ
	JrmWIfUofxHFWC8jsQdM1RTn7TvjPl8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 481F160136;
	Tue, 23 Dec 2025 01:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244AEC4CEF1;
	Tue, 23 Dec 2025 01:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766452052;
	bh=8HLJDJzqJpZNyDjxm0GPb6san6RSllNRbd8BiJb/m3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CrFyOnk8xn0XnO9L2YfHDvLC3fVAb6sjS2M4lUZyTjaUAtCPJP4KMlIeAojFHmGjx
	 Ej5DoYnq8xnh1lF3dhyspVDaD4HoyWUZ0Lw3QnJvM9FW9sGdB26jme6vv67KzDcNCG
	 ejKU5u+0QKpmnVhUh+Ry4YueyBFCk+wq1THPLhaI/c/sBBsnGfWbpWZ9rgAoimrz+n
	 fx7ypuNkmcmkJoza+bhHXo9fNHEIYovQufpz98k8AGD8b4qOXdYHM8PV+bB1W20q7r
	 umK5u65js9ektIXsnVyIKXLg7Wtp8pAg37OHdZ4gQQPF0FUUsZBclpJyCQ2qAm2E8a
	 esUXDwYfWvPVg==
Date: Tue, 23 Dec 2025 02:07:26 +0100
From: Alejandro Colomar <alx@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	"Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: Re: [PATCH v5 4/4] mm: Use ARRAY_END() instead of open-coding it
Message-ID: <aUnpiDyge6VdsnpB@devuan>
References: <cover.1758806023.git.alx@kernel.org>
 <cover.1765406336.git.alx@kernel.org>
 <e7bde864b0394dd0946b5227c6afac7c05560654.1765406337.git.alx@kernel.org>
 <A17C0418-E304-43DF-A6AB-0F142D7B8764@kernel.org>
 <lo6fdczvfjb5q44euckxi5thjrply4wqk62ori4slz54ivdswj@3c234g733gzq>
 <202512101736.DE24BE89@keescook>
 <aUf6xwicMCxL28Yp@devuan>
 <202512221517.E1B039879E@keescook>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fod4yrxti6hqvgsb"
Content-Disposition: inline
In-Reply-To: <202512221517.E1B039879E@keescook>
X-Stat-Signature: 7pc8f1smfpcfts1e88776z56z7xyfcr8
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DCF7A140006
X-HE-Tag: 1766452052-696741
X-HE-Meta: U2FsdGVkX18jguD6muydkJTZNTeswLc0ncwCn3UA6VJnopiq59okjMBw6qG865UZVe2guqCc9IVpLdDF7OdGpb8UmnzZ12DZNiBHPBhzQaumJ81bsw+quSRsZhkJ+hlkVLGA7z1Y538ADPYnoM4UvW1AAA3p52cLK0VEmPIH/QREzKciuw1j1fF3HapohxYobnlQwUBfU55GYW/QtFD+BhMJ1go1qtdeBAladW7zgTwRuXNAtFSMjze1ag1bawNE5KmON8gXKFYv+qyj2hYIAklLA8HJPqSo+j3Jo96RaHYzY6DNrC4LrZHU0qHMQQCYFEJUCGg3o3Vku1DJTEeB5vfBGmgnmD9E9+CU6/zHH/oOiROSEQrndYu5Y6zGJEKYTYjIMOEVvXeVV2ErKgY1ycM10CaiOVi4PVKm529OJMtmSKtBwwH9Vh8hyGHVviqzS3PkDQjUPRge5DmDXhLAjUPML90/F0naX0oL2m+S+VdfB8I3H10vkin5KcRqHo7tvQ3wHAC2hAc+J5QFbyvhjTTZQvW/2rMHL5QfQjOqCw13Q+dMmTyvLZg20TjtThTQc8sKRViAKeAFvBkaJNQ2u0UX3+5wN42AHtxACQAam25/lW2Ct4kxa0vtF8vqjZWkEt2YLv57F4VP/pG0upr2q3QX6xSGN2zXBDf4eOwYoWM65r6dW7gptGbLYW/IZS7s+mdpk4hCq+GUvky/1r9SEepnOIZiNqyl76YQXCd9EhrlNRuWoKV/y2YAekPbxi2VQmdqiU0WrGNMpIPbKP62ryZBHvkaRsB9kiJxMkOjPtNKATgL8KeeXWvwrFmGo3hPqBRBtVVOGyK5+T3igEYu1IS5U+epPSai6rCCc5Xb9LqQbhaD9u2O+FJXXrm/WBqQ/hTQ1lkKKolHEovxh3UJPCbEyJrLzKd3c0q7PK08x8PM8RSBWY1t1rNHd4PPWFqCXnLmWGmq8hE23NFePo0
 HYSaoE6P
 CkbzrkMRhHR6/5uCsu+oLRL3BvtSJbIshxRtRtVnOAMsgP6lsUH1Rr1Q4jI35zxKvtVhXPP1SyHsUGhQKOCHVRaFOWfYZ3TYbjQJb/AqycsEr2rJTD8YNnMgysrmwwugAnn2mfEdkbgbUz1NXT4WlxDZ9/sOwtQ0oIWQuE/DrHwJoBiuwjNUT8i2uch2F6kI94mwtefLiyNY8nXxqG1SD4ZcT3+OQn7IRxalOgitoCycXiO6cSZ7oMl40GBoHOVsIGUqzVKGpcSz8HW5Y9zgFLYbzUBxIA50k9Z73BL4V+EmrHIrrAlIrF2I1rFzjWqFcw2tzN4iDu24Kyog6NiTtfyHaLBWgxmKstMlRsjSwf9ac7QfRUt7RAtp4muq+AlEqq77Lt2t80590SnroXAfIbj5oY2r8ByPEQZIbLSVv09Q0bKvBxneZAqyBZvz/FUj7oPVDP6fnzP+Sg6KcGNxFgC+FKpg2nXdD1TWlT3k5BsCXAUUjqScFDg5TyuqqX0FDT9wYhLwkdGDe+FeXVw7urSott0GSS5y4oWQgPMPO3r2REITTp94yQTAFaHbxQVjFDCbntXQo9oIHQmE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--fod4yrxti6hqvgsb
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	"Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: Re: [PATCH v5 4/4] mm: Use ARRAY_END() instead of open-coding it
Message-ID: <aUnpiDyge6VdsnpB@devuan>
References: <cover.1758806023.git.alx@kernel.org>
 <cover.1765406336.git.alx@kernel.org>
 <e7bde864b0394dd0946b5227c6afac7c05560654.1765406337.git.alx@kernel.org>
 <A17C0418-E304-43DF-A6AB-0F142D7B8764@kernel.org>
 <lo6fdczvfjb5q44euckxi5thjrply4wqk62ori4slz54ivdswj@3c234g733gzq>
 <202512101736.DE24BE89@keescook>
 <aUf6xwicMCxL28Yp@devuan>
 <202512221517.E1B039879E@keescook>
MIME-Version: 1.0
In-Reply-To: <202512221517.E1B039879E@keescook>

Hi Kees,

On Mon, Dec 22, 2025 at 03:21:21PM -0800, Kees Cook wrote:
> > Now that the first patch set has been merged, I'm working on a second
> > round.
> >=20
> > I've written a semantic patch:
> >=20
> > 	$ cat src/spatch/array_end.sp=20
> > 	@@
> > 	expression a;
> > 	@@
> >=20
> > 	- a + ARRAY_SIZE(a)
> > 	+ ARRAY_END(a)
> >=20
> > 	@@
> > 	expression a;
> > 	@@
> >=20
> > 	- ARRAY_SIZE(a) + a
> > 	+ ARRAY_END(a)
>=20
> I think you can add parens which will be silently removed but gain you
> the commutative behavior:

Ahhh, thanks!  I was wondering how I could get commutative behavior.

> @@
> expression a;
> @@
>=20
> - (ARRAY_SIZE(a) + a)
> + ARRAY_END(a)
>=20
> I *think* that'll cover "a + ARRAY_SIZE(a)" too.

Yup, it works.  :)

> Anyway, looks good!

Thanks!

> You could send it directly to Linus at the end of
> the next rc1, and he may take it.

I'll send a draft before that, just for you to review the actual patch.

> If not, you'll want to split the patch
> up and send to subsystems after ARRAY_END is in Linus's tree. I use this
> tool to split a large single patch into per-subsystem patches:
> https://github.com/kees/kernel-tools/blob/trunk/split-on-maintainer

Okay.  I can do both, anyway.


Have a lovely night!
Alex

--=20
<https://www.alejandro-colomar.es>

--fod4yrxti6hqvgsb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmlJ60gACgkQ64mZXMKQ
wqkiMA/8DGujTyeC67FKUmw35SWj8WOq/Bpjhy2WiicfTsQcoLblao7BrO+2OPqR
b6eE+86SJsaM7XcZ3+L8TxwK3X7OcADezT5WdnG7S61OmxjdwLQtWgoLPFNr92zj
AJqU8uEQ8yIDdLv8NKMWt3TrWwgHXsxoTI+BXZPJFajkGjqjbX9d7Y/+2Zy5TUQ6
b7L45gkWMK8W6qMdKJI/X/WGQP/Vde8yyzKzLt8JUSpg7ZxjH4hILe+PbmGcPAjH
ip9BPvaeBFhRAZoPGM+NgQna+kzG/IMAG0hdwEiOwzjWkhw7LdJlhs0zSgjFjOS5
By8fSBwmOU+ttynHHYloPM8HgjwMVOjnYm9FeH1i6AL5T4I6lo5eOlaz5WTGvXGq
eh1VAGBZdSCz3IEag/WWjuHZXNkvShgmJ55lctJE+zGZpaaw+Hh8NKzDRj1Fjv5C
sYmkjJRcRDbCGAP5QbmtAQAS1H0FtTd2SGIYzMfS1YQhP/+uBlyfe7ubFrQb6ks0
Hlhb+7NCwRiP3m2v++UBa2gWOIRaSHYqbsO6A9LH9tN+YNCKrwObqcdibVVRVy5e
ZMBMDHLo4/YGyTDKdWd1gkfBwPqjQfABgzMgxJQ295V7yAsJuuhNVzLrJFeiZg9F
c0N9Gt5E962MTk+DAZ5cI/zFpY7jwLYfmG9V2nftvaaF7w5Slj4=
=AU3k
-----END PGP SIGNATURE-----

--fod4yrxti6hqvgsb--

