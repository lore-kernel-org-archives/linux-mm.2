Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84C25C5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13B6B6B0111; Tue,  4 Aug 2026 10:47:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CB486B0114; Tue,  4 Aug 2026 10:47:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECF366B0115; Tue,  4 Aug 2026 10:47:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C403C6B0111
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:47:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 021FC4011D
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:20:29 +0000 (UTC)
X-FDA: 85063495020.07.AE514B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 71D801C0010
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:20:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CLqk64lr;
	spf=pass (imf21.hostedemail.com: domain of joel.granados@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785846028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wDC0uMZjurs3Uj84WLY9mj7POWsFSEVlaT546hjHpF4=;
	b=xqyuS1ELVgO7XBOoIspmBmMXEc52aaRf8kUUQJf7ugglDRk3C9sbG1zu66g134j5CGGg8y
	5B3MD4hjIfee0Ykn97lT1TNKm6T1d6dC5PAkdgmtPPu6iRA9ZeUSz79ybelvrmJ+OmJfBZ
	l+QkaU4eR9RUYT8acBM6spNpZOMGlq0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CLqk64lr;
	spf=pass (imf21.hostedemail.com: domain of joel.granados@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785846028;
	b=aoQPe9Z8N6pqCNCiZ83Kl50yPPYpXkrOSyeS4gY7YbtwAFhQXd9m9p9F2BNHzIPIPGcMoW
	1a7QnXPv/gHNHYbi7ilYt1WM2BFlXqKnxAdSZ7Be2q349mdNto578amsp/JkOEVHWXaquB
	KStvM9ZE4BkthBW7fGZhrTNSw1tEm2k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 14BCC60A6C;
	Tue,  4 Aug 2026 12:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FFB21F000E9;
	Tue,  4 Aug 2026 12:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785846027;
	bh=wDC0uMZjurs3Uj84WLY9mj7POWsFSEVlaT546hjHpF4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CLqk64lrwlUiW+LniTHuHSiPL4Zm0XIbOhURFl/WyhRY2spYMNwEB/vwz2OkYatpT
	 IAA8d9D3VZY5W/YB5yEf42UzMJqPhG63ocC4Jp27WAF5XOn9gh8OI31jlH3VqMZUOA
	 EdiEMY//+FE0Lgr1V31T0hODHGcZ7ThWe9QbxmJk79pfMyKWLA1m+eq3EsTbnL/WBn
	 ZWBGHGGrJ5kumLdrRNPacNFIX8tcAFbJDbXQ4pD6mYWZbfNiZl+YLHEv7ilL5FxIYQ
	 YeIjia4oZGTd8UpM14pNAkRcfLxl9DVmrbSjREoNLc63uXa762pimbE1IWZcdoZVRL
	 9vYuMUI7l25uw==
Date: Tue, 4 Aug 2026 14:20:22 +0200
From: Joel Granados <joel.granados@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jianlin Shi <shijianlin11@foxmail.com>, Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
	hannes@cmpxchg.org, surenb@google.com, mhocko@suse.com, jackmanb@google.com, 
	ziy@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/page_alloc: only update lowmem_reserve_ratio on
 sysctl write
Message-ID: <k53aljpl7v7naqs5fj4i4po6tu4grkzu5nui4h37orwt6v7bqo@sw4frf2ystmi>
References: <tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com>
 <tencent_1BB7A5C4D5EEA67346634417753190E92A09@qq.com>
 <20260801114434.232c97a74d9616c43aac2456@linux-foundation.org>
 <f983f6ca-7d45-4316-94bb-8b4d0fd58079@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="btblr7xwjmfoogpt"
Content-Disposition: inline
In-Reply-To: <f983f6ca-7d45-4316-94bb-8b4d0fd58079@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 71D801C0010
X-Stat-Signature: mjznj6sesberybogxtuifhfudk34bxic
X-HE-Tag: 1785846028-335413
X-HE-Meta: U2FsdGVkX1/gEz/N3+4duTXu7jSSxAQcV18LOQ6wZbbKgvds73++nzacjPXNBuJJj1giSVh+no9AA6ZrU+G1Crp5KQA9tWYVXvL2afz96ZScOTFRn1ZwXY8K19tsEQk+M5vL4hOYJ6F/mfdioq3j5tcDY5pLKoo+maJaX5N1tFv7mKG0pNjuWjx/fOG0zDtSEUcQq5dZcZWkukYU2QFCXYikzelJU5jxK8lOeU53Csd4BwMvGAyK9HsMwE25fcsBUqq0QB7v+ZlHFBsE3Nx1Mhva77kHBOIJ56s0/GR4XhsC5AnzgWyLQSbLcXnurIusq5RUJIBhxTpBLpmY1ITbA6sHHYfDMyE7Ri+EZw1CL0AGkt1HSQC4NOQoJe/XyCge+Wsu6NELiT4OMtHG0mmnlyP5w5q57hdTrUevhaJZIaLS+13sKzTtMRUakL+l80Uqq3c7/fulIFGGulTJAw2HmLGatF2UevqoptVVbh+Yl3eYsuaDCCyRcg72Eu1LXtDvxT5rArFQo4Hzxqh6k9veD/m9gJTvvccsZevrBo2nnOmsNZask10VZ5TCmUpthHHJhA6IvweB4Qg3Kmq/mNdlov0gYdIYtmhs2a0gt9WOjWQLTfWt7WwlEKQYskIFuzw3RbpxqHNte1fWADtcWXrjSY12fGTUbQEzcBuMViPhlYBH2veumv0zLqrffYQG8ldTkQpb1OnWuaJeAyxRoOWrdIYbng5tYC5UEAZBTgj9lD2qr/w4BksGqEAf63BOqkLij0ZJ3NY8yz2JMPgm6Rh2fNNBy2S0Zw+EMoBLu0iUTueykLwhbR6ruuNLxOn0eiEmGHFZBMT+J8nLiiRs9znRkGfp9NoCQn9N0CdQ7Llqar6rbKQ3yJ0sai3d8k3gEnddAhmR1SAxnl9NzTolv8LWF0gfRLfOoati26xsNw+o6WPBKmAyAGGsO+ZNsp/QOmw76gZBAUnHgy2mRZStfit
 hS9OaMEk
 eS/uFvYx/kTHFbegLcrBZTxRajmj0ZW598mM8Lcmc2g8RBYFytAyQW/sEWcRKSZtBm8l+Z9Z+YpaCy0q9DrIFcL8BWlRLKuL815iDyINqWlukkNbHIuSQP4+g252dVqhBcG8WUCN7tuY+ZEzDBn0V/hA+utBJaort2q1op28R/6KSA1Wyz/1YLthEKS8iFKuLsbMtEcgyOhJLuZaN0+B2EaIe2bdqkPMhjNEU8mJLnjXi04IEs7WgLBKd42UoLMz4ehM22DCUhFz/PD9NCIW5kMnWNLtzaz9RALOvxGbTifQhHPZMu54yeggUbD3qWUASWRR3KF1DdnbYpDiN1FPICeR4Wd+3BIil7UZfIRhfm1WiiPDsVfAwlqXk8XC+asUlEcKMXCIK/NJWa6gRu3Xo8KkDyWXnIdPnvSxUCN+8kNtYdbPGYeuCv4Eb17PEafRlywBpRVWGPfpdw76QSPaVC2PWMNmtqaRYUFZ++LuWOraKlXliQn7UY6ZWNEnZNMtba01Vdnoxjb07NHNvp0OeGOJNR7j9koXswXSV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--btblr7xwjmfoogpt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 03, 2026 at 10:27:46AM +0200, Vlastimil Babka (SUSE) wrote:
> +Cc: sysctl maintainers
>=20
> On 8/1/26 20:44, Andrew Morton wrote:
> > On Sat,  1 Aug 2026 23:11:25 +0800 Jianlin Shi <shijianlin11@foxmail.co=
m> wrote:
> >=20
> >> lowmem_reserve_ratio_sysctl_handler() ignores the return value of
> >> proc_dointvec_minmax() and always calls setup_per_zone_lowmem_reserve(=
),
> >> even for read operations.
> >>=20
> >> Fix two issues:
> >>=20
> >> 1. Propagate errors from proc_dointvec_minmax() instead of always
> >>    returning success.  For example, writing non-integer garbage to the
> >>    sysctl now returns an error instead of silently succeeding with
> >>    unchanged values.
> >=20
> > AI review suggest that this caused a new problem:
> >=20
> > 	https://sashiko.dev/#/patchset/tencent_1BB7A5C4D5EEA67346634417753190E=
92A09@qq.com
> >=20
> > Not sure what to do here.  Perhaps pass proc_dointvec_minmax() a
> > temporary then copy that into sysctl_lowmem_reserve_ratio if all
> > proc_dointvec_minmax() returns "OK".
>=20
> Seeing the v4 [1] it seems easier to keep the current fixup code until
> proc_dointvec_minmax() is fixed.

1. V3 -vs- V4:
  I would prefer V4 as it actually prevents the partial write of the
  vector in case of an error & returns that error back to user space.
  Whereas V3 returns the error back to user space but keeps the partial
  write.

That patterns of using a temp ctltable entry is seldom used but not
unheard of.

>=20
> > But really this is a flaw in proc_dointvec_minmax() isn't it?  It
> > shouldn't update the table data until all the data has been validated.
>=20
> I agree. What do the maintainers think?

I agree. The arrays being changed are not too big so we can easily have
a staging variable that that gets written when all validations are done.
The only "con" that I see for this solution is for when these
proc_handlers get used with temp variables; in these cases we will be
staging an already staging variable.

I have added this to my Todos

Best

--=20

Joel

--btblr7xwjmfoogpt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmpx2QUACgkQupfNUreW
QU8Qkwv/fPz+ltet7pLkvz28K9W7ZeeQ1dzKM4/bQdIYZxqlMljMlarMc8WAlm1R
7KDlkxnxe8BT2+RuQJLihpOG2lWYpyRuhBiGN/YtiM+1NJEkTtqu1gYL7C218UK6
MwRLPsaejC4WK7IqZlvC1xjTuexaNUe3RcLVwDmxNc+I+5LSjcuku/aPb0/o6i9u
MXgvxweMRhiJ3oZ0WhN+VZayLAf4Nxz9+1qV/24mU/khekmBLficWy+KbBbrKRrp
lUqNObbmUseNJPij/Vx9+SkZoq30id5jb1bOoHcoI0KmO7VbTSLoDuJxXjjy/Lnb
+yBZ5fdevWFEFdYKsvfvYMyfBMo/fcnHkuXihKbn9FG/zKRaWssr/3H8Yi4SODyl
Wk5Bpr8TFuhY7RbzJQ/rb4QgjmdYo7uaNeHz6pieddZBL9Cqj0K955Pc22Gwza+z
Jn2CgWwRkvVQnPKrbWiUYubcyf6RdN6nLTeiIMkC7wVwVrjbh/pwfUzeOUrtM4JY
rH+bzQjU
=stmO
-----END PGP SIGNATURE-----

--btblr7xwjmfoogpt--

