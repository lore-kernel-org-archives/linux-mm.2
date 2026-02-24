Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCA70F4BB62
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 17:21:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 172066B0088; Tue, 24 Feb 2026 12:21:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 120066B0089; Tue, 24 Feb 2026 12:21:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02B7E6B008A; Tue, 24 Feb 2026 12:21:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DED136B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:21:39 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A651514026A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:21:39 +0000 (UTC)
X-FDA: 84480017118.22.603DE04
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id E3F7320014
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:21:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hGmi35yA;
	spf=pass (imf03.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771953698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JTXCh3o5NHpGKxy5qsw8UYJhfhUixS4/yVU08jMlI0w=;
	b=XVICmY4sfxB0UWwor/t6IjSzl8d7VL3BgXvPZKil9KChJTJCHLICNZk8VnhmtVLIqovUef
	OHuJBd302SCpc0KCmmaJ+//UyRxMH2hiczZkBs5Drv183exLh8pcrKtMXEk6E3/K11StoA
	QxMEE9rcOMA2ZcPTjXAW5/yXve/87Q4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771953698; a=rsa-sha256;
	cv=none;
	b=8XuUDd2Tm4+p4jOOTvT78G6yJTi73VuQtkvtuJ+fk2EgxNYn4/IVr2b5L/M9wFjXWN2LLl
	84/t/76r4ryQYlgVtYA0U6CRn/I78/e5hsPlp2YCdFKsSvPYbuJfOSPm3hW4a32cgMrZoo
	Q56fN5BTc3atzCYYYu8TyDV5WPhAvos=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hGmi35yA;
	spf=pass (imf03.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D79C340B09;
	Tue, 24 Feb 2026 17:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AE9C116D0;
	Tue, 24 Feb 2026 17:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771953696;
	bh=hKcvMugV9CPhS4iyHTJvyrCkZUeZHcDYBMrFdgjRVnY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hGmi35yAEaRicTCcakwerXleGB8jK+1/DmOyph+zxATNFzz8gohfVdcDa9k7dUiwI
	 4NrDnYuB32m0Go4BCsXa/wcQky5bzNlwHeMumkbFDluctAzrOAhvuw1o9NopBac6i+
	 2kwBO8hM6R3crxX5uUW7oJVcuuHAWx7Z2RQZELHq4q5rFlP98eLmu8/ad8uep/cih2
	 V7Gasd4ceF8vnDTOkFYlSv82bTniL9sJ8MHa9q9mZQ/3DOBdyRWb8Z3bSmzJuurhen
	 MAupEBTE+k/nyEnGEe1M0VCU8jDwP3CLTCXOuDHq3FDS0+Hvcljj5E1uBAK0Yd1HPU
	 NepuPcevFhGzw==
Date: Tue, 24 Feb 2026 17:21:30 +0000
From: Mark Brown <broonie@kernel.org>
To: David Hildenbrand <davidhildenbrand@mailbox.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Ron Economos <re@w6rz.net>, wangkefeng.wang@huawei.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, ziy@nvidia.com,
	jackmanb@google.com, jane.chu@oracle.com, hannes@cmpxchg.org,
	willy@infradead.org, muchun.song@linux.dev, osalvador@suse.de,
	sidhartha.kumar@oracle.com, vbabka@suse.cz,
	claudiu.beznea.uj@bp.renesas.com, akpm@linux-foundation.org,
	pjw@kernel.org
Subject: Re: mm: Regression with v7.0-rc1 on RISC-V
Message-ID: <fef1758e-c123-4253-8fe2-aa510992c977@sirena.org.uk>
References: <1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net>
 <13b8d60d-1209-4650-9fa5-982381c53512@kernel.org>
 <1966378802.577797.1771952827516@app.mailbox.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="H+q4jLH11yLXxqL4"
Content-Disposition: inline
In-Reply-To: <1966378802.577797.1771952827516@app.mailbox.org>
X-Cookie: An apple a day makes 365 apples a year.
X-Rspamd-Server: rspam09
X-Stat-Signature: un5g9kz411p9p694mwbkor9xobsnj81f
X-Rspamd-Queue-Id: E3F7320014
X-Rspam-User: 
X-HE-Tag: 1771953697-402927
X-HE-Meta: U2FsdGVkX1/gh1l4vcEsiHlHdWJ6ZpLQfieYbAaVU3ae7ZKEvg3z57E0KyIywu9KL0cuTyTjervn4+sRSgaN2jTQnAffNrUkjN6u0J/4IrscRr6LIjIpLP7kXqaOgDVQc/r6eOffIr7CBKUmp0AaBx59OS48zjr/UYL7zjCvBrG6J3E2wZi4qRdWCT+5zJLhQ0SL3k0DJFB0+m8x0lgGRuLMedDF+zgf3gLtS+6xXhzG+2NMtQP3QX1XaulykLuP5JG3M0JSvChSbeqPzlt7BhIkiP+n7gf7R+OB+x+XgUJB2e2rwfVJZcB1RWFk66Y3EcWZ+zCqVhiCWBPjj+utIHLlOAQFBxkzKGa4Svp9vHPss2Iph4729gJAYSmvuOmGeXX/hyLTxWHzm86Bx+oSjcLTWkKjcuijXS5bZJUi0acodEeMq801TbBa8OIJngwpq++7+SNoyJnhoyYP2rkYdjAwFIG3tbCeMlLStPuIGFZdZ11MkAPxy2DYC/M1mhc78RcniDaPSuw6qCFNbrJzyEgaNcWHXQ0ZcGXObn+BSwmC+rNBESSP5nyPs0HpZ3ZDiFuH/uWuJsRwul60zxyKRRPO6wg4lhf7tRhm9rBMUw865F9nvliKmJiC9pV9+dWY2HbQOaIJUWfXDDs1aWZmXmKSnE86Uql4x3FGrqPmvxZmuObz93TcjYNW7QZj7hcl7mB2rkCxMFieMTPbuAUGBogBUrwolpQvZEIR8hFLyHAAulbzEhPbW6u0F/av/0Amd18zP9JBtfKF8aX9lE4CiDq0uZomE/j+P10KUCufSd8FEskUE1lgMczHqmUSxAHvizwfvgME7xegXIH1msJM1ABqyPFYBDhGqaqBDNTTlKZKNPvtJ0YCfjgEoO+0wWkYkm+zFXGLSnx9LwsWPdjzSK6f4w8Ld5csrucghZ3GgkehY8zMd9t6ASnl5OO6lLCyBZxV6KtXJfDqqg8Uf5F
 ZjAmdH7w
 wX0VhXKMeuIRRjcrZy8I6MxK0ti6CTwohcTWkEWOBAmrPbpzBZ4G9wdCdb7c3h8Seup+6I+XV7Azd2kcqrf6gKqZFxd5MZyVv27nqaf7H/8uSDp6/ae7Ww1sv7GilyTIcS92ubZtKRw8sg9PFb8jnLbM1yOKoiEwYrWDexvpdASOf/Icn6wLICTaZ42F9qp9LW5vB1qmEKqSjNSByDAHtWgt2PZWGYbSVEzX3LQHyaTTG0kDV2ai0phGOERYxDOckExg3YFsalcV8/Cli2qOQKzCQiypw6VjJ/nYmf5ozacKo+VisUkprPhdnIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--H+q4jLH11yLXxqL4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 24, 2026 at 06:07:07PM +0100, David Hildenbrand wrote:

>   <div class=3D"default-style">Thinking again without my computer at hand=
 =E2=80=A6 isn=E2=80=98t the call completely optimized out without CONFIG_D=
EBUG_VM?</div>

Pinged David off list about the mail being HTML - this was the new
comment for anyone else who's mail client just showed them the raw
HTML...

--H+q4jLH11yLXxqL4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmd3hkACgkQJNaLcl1U
h9Btxwf/WGmUPQHWy5O7GBCN+C37Glhe0kkbEmWgfeOPzVmJdbhpbOQcHOE3ykHJ
HjgXjJomrOb+rZdEvfBKMd/gs7kVpVcBi3OFTyFIct/dhy83OvHAss2Je2+4bf7J
kxhYIMDkHjVhK6J76Bo9t3stGpQbSCH4qHwlCaFB0iqbx9zILHaT8x6KbIv1iGJn
BFr32xQmuKqrNuE0l+/L+ZgbPqJyLCkCSsRVV2o8J/pjV4rJGvdB69//ZBABLc6y
a06SiTkBn3ur05Un3O7H8s1iZpp9wA8clIJME5h84HaKiw8GC05SOp2GX62OOWQ5
xseHJHf9gC2kr/hXSmCE3c4nLU3pHg==
=l2JT
-----END PGP SIGNATURE-----

--H+q4jLH11yLXxqL4--

