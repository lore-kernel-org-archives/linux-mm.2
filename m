Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90FFFD2F35C
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 19:10:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7B256B0005; Tue, 13 Jan 2026 14:10:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2F6E6B0089; Tue, 13 Jan 2026 14:10:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C31E26B008A; Tue, 13 Jan 2026 14:10:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B70956B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:10:39 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4E4711B2F5
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:10:39 +0000 (UTC)
X-FDA: 84327882198.18.4487560
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id B8C35180004
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:10:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SS6gWU8x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768331437; a=rsa-sha256;
	cv=none;
	b=BTvS9sJAmYy+La95Fx4o8PXqUbHKDSjD6+1rKR0b98XR/aip+otRkQ9vhjQTMnx4JLKS4E
	W/Q5Znv46s9nzQr6C0Dg7sLFUvIaJJswhgbO0yRbn7l7vySthWTEQmZor7QSCYw/26BzEQ
	VdJDi3q3JZKb6faeqJZ1xnAYWBPYjUM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SS6gWU8x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768331437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vm94DYUQ1nI39SPw68X0FmUruHGWhmKYLkUMubSnMAs=;
	b=5aS51NDt+iPVsoi2NW3Arp54P9G2bJzOEg9aV+CYMJJnaVXrAZRSUFA41tPsOAHq8Xns4h
	wWT0TsT2qZYeJBNApRSEy4N9rbWqekv7xq4SiESazhsxXn6U7hBsNg3Uuc38i6rK39KlLm
	zkvlwqM1XZtM4aZd9G7qW5c8DIE+inU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 65E2742D81;
	Tue, 13 Jan 2026 19:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F337DC116C6;
	Tue, 13 Jan 2026 19:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768331436;
	bh=vm94DYUQ1nI39SPw68X0FmUruHGWhmKYLkUMubSnMAs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SS6gWU8x+tekz9NkfZbMGwbM5eid/TUswOoeyExVZZV4viqTgcauuXPwpJihcdho3
	 4LjGQ0acp+JEsLaHflm3DKi741H9bhcPdkGtP3raiePxDX3weLYMh19Bm89wML4ZkF
	 FrQbA1AAN6VvUoGQgIf3x4IEQDfv4qjdWgQ6Gjh+sGyHEXe1glQ2YK9GQ4F9xKCTeA
	 VzjQpLrgZaTdhwnPjU6Fmxm4LAWMYC9YEogS2UT+wuwRpLs0+V6oprbvFcBoo22B3P
	 Vci04XvsPP0u5kNIBnLfc51WHEEkHAYIGy67fRFAQEOzq3BJws4EsgvxQWmDHDM5nT
	 btyO2dkXMwEqw==
Date: Tue, 13 Jan 2026 19:10:31 +0000
From: Mark Brown <broonie@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 30/44] fs: use min() or umin() instead of min_t()
Message-ID: <79702729-b89d-44ea-833f-505bfb8b1309@sirena.org.uk>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
 <20251119224140.8616-31-david.laight.linux@gmail.com>
 <62097ec5-510e-4343-b111-3afee2c7b01e@sirena.org.uk>
 <20260113183346.18ef7c74@pumpkin>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Nw+uksaxhjXkAeBE"
Content-Disposition: inline
In-Reply-To: <20260113183346.18ef7c74@pumpkin>
X-Cookie: All models over 18 years of age.
X-Rspam-User: 
X-Stat-Signature: gex9jbyujnyusgkfmq5nzdia9s7kmby3
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B8C35180004
X-HE-Tag: 1768331437-652037
X-HE-Meta: U2FsdGVkX19DFY6p2THiwUpu8Gq/RuTRzh1i8bMWkrwQW/VgoAwNlVfF29Zy6witdBCRuWEJ44ArvYs/Bqz9SXg9UqWvDlThGwL4DjMRAWzbQ44We9vpOvSmp0hthE78fYD0qVrP9JWfQjv9XhZC57ai11XSpNczT1/R/jNcbuF7yc9oMtwk1q7IBrrIAorRIUEjtq6+G87nj1NSNz9OmoRglJIgviKW+u0o1zxQ+Oi4mfAz0KPpoP2FHubBsCzwBQ0JoF04l/yvQKfbeuWu/TokOyIBtGdw/56zaz/xcUoS8El25iw2klFygxbx3VS7R6NuXNIks85dsPxsiXxyyubAXneI8Grs66mBZA/D15SnE723iS+yideaetedQ2V96iv36bUED7Ay84wV5j3cTunHkz0YIN7RquUI+D3hqcpe+ogAg61hZYpL5FmSWShOAmicM/2Je9yFK8o3RYiODtbkqNb+XhudxSekRY1jDEND6tQOjebH2w6vG2P3fHGPLRRaFVdbca0DQv0Ivn/FRZsI7ounNTGyGEnxZtrFZZ3jE+rU8JtWPGEuC2oV+ri3aAwSmQcwpWLA18y/soOl3FZ0OO4bAY46nti0/fzf1xRmODKTeA9KVpuHH2sIaVbUTKF4LGiA30mHELaFx+xzTrag/g1SHT3UerXRjaXgtYXlDUm8SMazb+spZHoRFlKoZIKTljqKa6wgTGhYoMy0zwlvV9Jb3KJbfH8LHQlbvKUTnuAncKonduqOsLac9jgpxvF2zSbsBIYBdv9FrQ+mqTfBa4fapxWcJt0RgzxFew0a9T0otQ3ijIqXRS28aVTKN+/derj45Kc2wmemj1zz2LVlTPLbQMHeFuh8tnrXZeWO7l1lnGibkktGgoAf94ZK9IdwfGBSTP/lyWYYE53HCGxRpgwuFBWBb4dbUzHuG5T+3ZZ2tNvJM6cVE77TSaC9AzS4OYLni5y4BUjXAyE
 l403CSBL
 /Mlhu/XxuVbbqjpMSmezuN/7ITsZtx64oFNOKP3Wdxo2vs6dpzLs34oPkS+D4NwhxRwDVqrFLCGKz3N+gBbqxizFA4Vc0eXxbLY5k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--Nw+uksaxhjXkAeBE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 13, 2026 at 06:33:46PM +0000, David Laight wrote:
> Mark Brown <broonie@kernel.org> wrote:
> > On Wed, Nov 19, 2025 at 10:41:26PM +0000, david.laight.linux@gmail.com wrote:

> > This breaks an arm imx_v6_v7_defconfig build:

> I hadn't tested 32bit when I sent the patch.
> It was noticed ages ago and I thought there was a patch (to fuse/file.c) that
> changed the code to avoid the 64bit signed maths on 32bit.

It's possible there's a patch out there somewhere but it's not present
in what's in -next.

--Nw+uksaxhjXkAeBE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlmmKYACgkQJNaLcl1U
h9CYwgf/VXAy1tb1XQ8DVlunnz3EQbeEFm55uY1CVPI/q3SIT+p7pKT+PrR93reA
k5aXe8Ssjdb4njdECEoxxNFiWFZdgtZrwS4e1cn6YejPs0Y4kPdcPhGaVvw3Rvcg
2xul2iz1N0aw4W2I5/nPu/3NhZIDpgDaHsVxC91pkzqEV0AmSpkeo0qu3/T4r0Yz
06wuJvuq4l+w2QfdUa/zc3eJlqCKuEK3ixV36jIj1qbEiAocwnqKFbhXBQAWv06A
6P6wRQqOcpI9866bMDZMS5LaR71AZBP6cS6C/dXDbXIBP+yo689c5bNgbcwCbE6K
UqJwEbQpJFtO9n7QiTNoxSacGK7enw==
=h9JH
-----END PGP SIGNATURE-----

--Nw+uksaxhjXkAeBE--

