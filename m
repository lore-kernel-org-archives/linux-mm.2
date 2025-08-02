Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D3ECC87FD2
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 05:08:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 831A56B007B; Sat,  2 Aug 2025 01:08:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E43E6B0089; Sat,  2 Aug 2025 01:08:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FD906B008A; Sat,  2 Aug 2025 01:08:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E9BA6B007B
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 01:08:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BFDE0BAA18
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 05:08:00 +0000 (UTC)
X-FDA: 83730635520.12.C737846
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8550CA0002
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 05:07:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=canb.auug.org.au header.s=202503 header.b=kLrI7spz;
	dmarc=pass (policy=none) header.from=canb.auug.org.au;
	spf=pass (imf25.hostedemail.com: domain of sfr@canb.auug.org.au designates 150.107.74.76 as permitted sender) smtp.mailfrom=sfr@canb.auug.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754111279; a=rsa-sha256;
	cv=none;
	b=HV2MTDzF5vS62E/tIIyOPTUAdQe4ZFR2aQNtz+OuAxn8vZ7fBh3GFhf0uP3gemSuzHu1kl
	7xTqx8b2pFhtIxjB3Dz1cxNBEFkNXDoYFn/4X8w891YGCZofuEhUoUHK6TmaokvvFRyJlD
	I5TZussyclEzUaA0TxFDnfEbl9WZ4tw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=canb.auug.org.au header.s=202503 header.b=kLrI7spz;
	dmarc=pass (policy=none) header.from=canb.auug.org.au;
	spf=pass (imf25.hostedemail.com: domain of sfr@canb.auug.org.au designates 150.107.74.76 as permitted sender) smtp.mailfrom=sfr@canb.auug.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754111279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rwjvQEcgaDxeOlLgdTjlpv1NgjGhPHAakQTWLZ39Tx0=;
	b=PEhfKempxmfESIoRfcOAMplf1wjAyoVLGtvkGAcW3n7D8zHsCFUjqrKkiaEfptvVdYUy3c
	rSnPuuNkt4iKXvUJe1DbPvqsPPKYADO/e6L20VluqCwMXLlTFrx/HNmz47lMqFZxwx9zmK
	ABbCFteH4Py1mkzWw7FjLoaSCyXgtEY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=202503; t=1754111275;
	bh=rwjvQEcgaDxeOlLgdTjlpv1NgjGhPHAakQTWLZ39Tx0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kLrI7spzu2rrq5UChQcgEIcNbrvjQ9diARVIoLlizdFNOTze5R7HffREm4cT8zfpN
	 Yry0T4pxpdTN27Ed3oIl+n1wAY4ueqUnkPUJANYKfgZt+hdTFu/fHkuAy0mwVIAsJp
	 gu3mlDtMRhBYd1HgCkx2t3Ixu8rFpAbJr8xBGov/oeb35Oa6SU48fq//zeSks5R8Tw
	 vcvjxJcp7DX61z24rlq0DjbX4g6Kn49PZVG2c7ajMyoA/aXWOIC1iu5c/WTLx/Epkq
	 8RUabLJb1Nz4Moy2cEUMoo04XuBkjHYk0xg9opOGX5pQUa8b7RCzz7C+XADy/HRMOb
	 0oWU5nioFmJOw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4bv9n32Jh9z4xQV;
	Sat,  2 Aug 2025 15:07:51 +1000 (AEST)
Date: Sat, 2 Aug 2025 15:07:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Byungchul Park <byungchul@sk.com>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, horms@kernel.org, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, ilias.apalodimas@linaro.org,
 willy@infradead.org, brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
 usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
 almasrymina@google.com, toke@redhat.com, asml.silence@gmail.com,
 bpf@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH linux-next v3] mm, page_pool: introduce a new page type
 for page pool in page type
Message-ID: <20250802150746.139a71be@canb.auug.org.au>
In-Reply-To: <20250729110210.48313-1-byungchul@sk.com>
References: <20250729110210.48313-1-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/9yZ=dZN+zFc/Vgnr2iwwEfw";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8550CA0002
X-Stat-Signature: cmw73789rcbfu5msqnx6oezfoot4sica
X-HE-Tag: 1754111278-396977
X-HE-Meta: U2FsdGVkX18884pxMMkt9Mkxa8K37OMZJ374UrkcO1BAQNO65df47o4e5S2ZcTogcgxRcia3laB+XvRDWB5v03QUJdzUhujzG+LhhhnffdVPfcp9YVIszAPBC3jmapExpFAhwC8bJqQW2cJMTAWiRCVMccX29mh61GkLNtqd0Ow/TsGubq8wuarZMTtfbu60FFyB5kyd4l54ldkuGs4V/fU1BDroUsS6Uwb3KKhs1AExc06kF2qFrSqetrppJmz5v97lTnz9+ba9B9KoK76Ms9poSQdnrHNR1xz3MXyZpYBiLoXBZGblnWjAurbauusKupi1vauEHIstQ3r5cwup4PvMq3lk9xdFWX8xVD8bY7Fn9hmZLcCrKDiqiM8bV8dDbzX1ADDzb/frO6/a8BVS72wTGRUFXT2vdlD8yaHxydOZDgzQ+upLVsqk0eA09HkyqFT1LGtUWalaGBIV4DqX59D3kuixRz/CekcSTYbKUBxbwtImKNwSiq8ZU79pS5c43lMFgHesnl+zkSDxZi6L4OwG8aiEZbR4IoKGUSbUlX9l6vOgfrUdyhyH422o/SUJ7TkLPdA3WyU8UQDoiO5JU+aM5ArKzx2NSOxvp3hTyUmybg5im6e0vNSHruAJCmJPPjjl6uLWb8XSrAy/HWOT3a63eEVe5h2NSaWCNB2YEYNOw0VlEp2k5QaWb3wbZ6qXbXg40IseLHZJWFfoKMIc3kxgYjbdy0kkjMl0UgV65O3vX6nWPHLhcCJCt5tA9bCa8LNfkKADN5KkDRhBihi2azqMEkLFYZMKlgl6cnA3wkHt5YsTgez6VUUrNHkTkxUlJsbubCnFp0FN+fuUTotQyl7aR80R+WqwCNABMjr2rzZaM98z4t3Yeynjn13ifZUVfEJRItUjRRXDfAZGL2976P3IUBK+QVzCBVlTJRTcSkaHwtJ2/CLdV3nA13XVeWBBadgorJalwllVhb8CsJW
 rImoo+Yb
 hy11xEYZ2Mk1twxsDgve2WatTQH9ORHN/b048fdF+ZhmCzo50Cb+fAaxg8ybcziokFAWd0NpEezPk/hhto2A7aY84hysYZGNz9gH9BdggV4VKAMBRApYDb/ntSXaHW+seKK1WMwtpQtfBM9AiHcT0wKroKTcZ9SFn5xl4US7wuUbo9gnn+A4LzxU1acL2bXsgc/pXYK4tVRlrSAWtUNWFvF1oi4z238uMI008cWNaONwHAnFnzGs3PpXeRLZMHOu6zFqE1/iueja3M3HmhtYykyy46wuETGVnOd+xQShcSF1M1wbfZG8Ol4p6XAPEjTOvjEYJWxZ6Crx4UoFAKxd81BrviFwPDvXQSzlazlCt/UkdLJ0Bnfses70+XqNd20jnyYHip4jKePNPaA53wg4hxToEEFYm69aHGcpMnhMo/JAAn3DXzI9ixDG2MZxpKutyl3MfH2KbMN01sdBrzHfgkaojzUGKr1MFE4rwEIHFexos0TSML0be3Pfcl+2gsOBi0SApmzmDKGZjaAQ82gSJGAScRAH3tCayARWqJ3JdgMfwmipisznF5++DrCYXIzb11QTeadmr2aP1n5rw0yVHw389ZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--Sig_/9yZ=dZN+zFc/Vgnr2iwwEfw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 29 Jul 2025 20:02:10 +0900 Byungchul Park <byungchul@sk.com> wrote:
>
> Changes from v2:
> 	1. Rebase on linux-next as of Jul 29.

Why are you basing development work in linux-next.  That is a
constantly rebasing tree.  Please base your work on some stable tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/9yZ=dZN+zFc/Vgnr2iwwEfw
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmiNnSMACgkQAVBC80lX
0Gwf5Af+OMS7P8r7BKoR4DA+yUDiA60JSyGPWh4mtpdZbMuKCEDcbw1mrTbju/Cz
2Wab4zw/I/sx4WbpNZXspJMAdvxoGkzZZHQ7oq/B71pkdLgmP9SslfC6HLQNfmiI
+Lmmf9g8ASSFp+zjEAW/aU6nUZPUvywvt8tu5K/CAY1wvZqeEgf7n8Plg/Ef3hoh
3A0t3a1JRLbcqHxMAXeq+2DJ0twEP2QiC8nXxqOJSzq56jMFAvliO2vjZr0XHMBT
4Rki4Rfin3TM2MNLPM+fmIbkmuUBlAMI3qzkbPPuSVVw/j6OyexXePk2cusGRtVI
o2d7E7WZVhsEtKWo5PGb/NGaJqwnlw==
=6CHZ
-----END PGP SIGNATURE-----

--Sig_/9yZ=dZN+zFc/Vgnr2iwwEfw--

