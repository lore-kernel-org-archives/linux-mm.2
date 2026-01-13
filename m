Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4921FD2F345
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 16:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AC346B0005; Tue, 13 Jan 2026 11:57:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3848E6B0089; Tue, 13 Jan 2026 11:57:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2906D6B008A; Tue, 13 Jan 2026 11:57:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1BAC16B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:57:05 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A56A91AFEB
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 16:57:04 +0000 (UTC)
X-FDA: 84327545568.05.6DF5440
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id DD35340009
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 16:57:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sv3mUq8d;
	spf=pass (imf01.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768323423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6nlCx1Czo/tThW8qWEmSkue4Y9kkAzvQ3yldSDom184=;
	b=8VjP6eaakVTdPLI57XrHp79t2GlSafSRZtnqF8s9aVSb7PZvMd0Sum10NboI/E+00q2KWi
	SgKv6tVKvFbG1BuTWuk4vc16eH3HLkCDvTC0H5LH5hjJVr/BCD7pSToqZY2IOeytPvNRpN
	WBQAwgYNLuSS9sVTstTUqq9iVfPOCgg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sv3mUq8d;
	spf=pass (imf01.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768323423; a=rsa-sha256;
	cv=none;
	b=sSfzIWGrDrvjYTdN53rvPw12X2XwoaDZwmdlzZ7ieBqRpCAQykT5VMves82TbOEXVTSjq5
	NvjcRxOUVL0dF9UpfEPWe2A3icHXhYO4K+8EzoSJQl9tl1a3W3lbkV5F4v9NEjX4Ehtn5G
	l/AIDo/CY87DZ9h9aym8UUeKmGq2YDI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 94293416DD;
	Tue, 13 Jan 2026 16:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14341C116C6;
	Tue, 13 Jan 2026 16:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768323421;
	bh=Yl0lMpNMVQ/naErct5zxjs7FtqTJZfyUzVDb81q07Mo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sv3mUq8dQz7F/PY89TtNV9yNAowCM5dKV0dwRPMV8CJwOlUq7/hn6zfsLHc7FY+NW
	 WIzURftHjIL9d7TEQsOOngFezDFkR44AEclc9iJM4WAGC8piBbjkl6Q5ETZlHj1qqX
	 nX4GjGSkYC7nl4BsHKPbx2EnFQskaVm3q4VB0tdxpMJ2naqU45qRUlkvEU5TUCVRQN
	 GgMrh4JTE/vAsiWSezGjtsmcT0IgooOPhjhiUzrRENLZhjiUPDv92Kp66iQI6RX39h
	 c+XWMYttQeXAb+BaT6QQlZ7wmOkjHFt5micjazQZ6XUIiIVxYa77kT0OaJ5S5gHdEF
	 PTMVu2A59YeBw==
Date: Tue, 13 Jan 2026 16:56:56 +0000
From: Mark Brown <broonie@kernel.org>
To: david.laight.linux@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 30/44] fs: use min() or umin() instead of min_t()
Message-ID: <62097ec5-510e-4343-b111-3afee2c7b01e@sirena.org.uk>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
 <20251119224140.8616-31-david.laight.linux@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fwrXW7fUl9Ff/6Yg"
Content-Disposition: inline
In-Reply-To: <20251119224140.8616-31-david.laight.linux@gmail.com>
X-Cookie: As seen on TV.
X-Stat-Signature: xnub6cgqq6mzrauftuj8fmag1dcjckf9
X-Rspamd-Queue-Id: DD35340009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768323422-180369
X-HE-Meta: U2FsdGVkX1/3pIWjlae+yoZOKx4JAEZZ2VZtaeu0NTJWLH69U0uwgNWcJx2gOP/WbQLop6BmgCgAhyE0gNMfmjRRJPvznaPPncXDAryh3kLnrS1uzB8nKkNnmhFV2eb3EOH/ithyoF7tZbun2Y7OqOwDttq+u16apxXz+rki7VMb0FoTm7LXrcg261j2cjlzVLs9LU9rbNluDeGoet8xI3eyC0TC/Nf/ykHPvnqh3VP83mcVOaqwp0coPpbIGnopshtcYfiv/cVqS6K03z4OMpE8tI/oKdKRmDKlXRPp1KfqVGeluS1o/3YwjYhRCbw0AWXlixCrPyUI1N5ZfQOitQo/sIhpsPJ6RTE5mE3jI7V2hy8VO8v2bSm0LRAde7OaKUOD0ap5ZY+GFDHTsQ7lCcQvSe7QQDF4IMiqPAKSO/LqiWaN2mQlscrr0+YldnLFMwcGdialVfYj6BMMwTG01Hshd7cU+MJCMAC49LFcPOTdxG6Uan12WwViS/SbCTxev9sboxzxc2QkJMU4QhelJFHk4d0/BAWOGyV+5YvRXH+tmOTTgbtFYialIgCp9lie/9F+UI7Mzb9hVLtEaKwVObEl/Zn28hVAMIs6C7R39QWI+SGgLeEZlJgO3AkiiB0yXUoqBoCSkHQdhXYCmihur0ldv5c3Jq66aEYXg4znzV1EEocQABtjHA17n4xGVU6GxgezL0ce+YKL/Z/dU4SlPTLwKgWOftRmoOezjMaAkm2t18Y818HJe0AyIALsdFH3AZET/DqP/WYg/8jpXfYyTxGga2dDt+r0Cb6D0ahbuzG3/USj0AWtWxBHIzRHPRVAVU2goOnMqSzK83G+UG+QpdIxDh147ctRBLtlz02V2f7tgAy3ghwTU360zT67JPkg/uTVl01Lnff1zFF+2aCiBjLto2+qbWehqhfixDIQAp6N2HANq61TKaczGVjc31FwYoMUCnGlcqfcZgMQAd/
 av16J0FH
 hWI7yBcVQKvHp7Hcm+d+XRxpu456Nnv05gRt0EqmQx3wvuKmnJxhAn8Io/RLLX8b2U6CBT8Dj5JCGJKmqYyZ2MU21IJNJW/czcgQItSMlKfc7XlebcMmveFVlo+dc14qJL8iRPmuZAOLfbsmhc7+SIgCWfNTjSt7swVZEI8ZxiGLrQjN/0c93jkjN1LV3Kstjkp4tMViBMJSW2L+US7SImPv3Nwv6GQpk6/nJ3LDn+FN7DF0OHNbY8Dmw96k1rYD4JypAjFCIYERFPgeIevdyvo3Oum6KgdVBTOS7T/jPXnSKVT7Jhgrt9K4Gj+6l93PA47okqtWyouf3onO6J7dmUKMlxDSeju6yqfWM9y0eut0Ac18cnqKW0Tnm+6vFtkvo1w+RmQtGLOo43FghsNkpYsgo1MiX6v8oQ7fL3P1RHH9cBwzUjU6hhoELjfmaWeB91GDzei7sa41M5cY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--fwrXW7fUl9Ff/6Yg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 19, 2025 at 10:41:26PM +0000, david.laight.linux@gmail.com wrot=
e:
> From: David Laight <david.laight.linux@gmail.com>
>=20
> min_t(unsigned int, a, b) casts an 'unsigned long' to 'unsigned int'.
> Use min(a, b) instead as it promotes any 'unsigned int' to 'unsigned long'
> and so cannot discard significant bits.

This breaks an arm imx_v6_v7_defconfig build:

In file included from <command-line>:
In function 'fuse_wr_pages',
    inlined from 'fuse_perform_write' at /home/broonie/git/bisect/fs/fuse/f=
ile.c:1347:27:
/home/broonie/git/bisect/include/linux/compiler_types.h:630:45: error: call=
 to '__compiletime_assert_434' declared with attribute error: min(((pos + l=
en - 1) >> 12) - (pos >> 12) + 1, max_pages) signedness error
  630 |         _compiletime_assert(condition, msg, __compiletime_assert_, =
__COUNTER__)
      |                                             ^
/home/broonie/git/bisect/include/linux/compiler_types.h:611:25: note: in de=
finition of macro '__compiletime_assert'
  611 |                         prefix ## suffix();                        =
     \
      |                         ^~~~~~
/home/broonie/git/bisect/include/linux/compiler_types.h:630:9: note: in exp=
ansion of macro '_compiletime_assert'
  630 |         _compiletime_assert(condition, msg, __compiletime_assert_, =
__COUNTER__)
      |         ^~~~~~~~~~~~~~~~~~~
/home/broonie/git/bisect/include/linux/build_bug.h:39:37: note: in expansio=
n of macro 'compiletime_assert'
   39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
      |                                     ^~~~~~~~~~~~~~~~~~
/home/broonie/git/bisect/include/linux/minmax.h:93:9: note: in expansion of=
 macro 'BUILD_BUG_ON_MSG'
   93 |         BUILD_BUG_ON_MSG(!__types_ok(ux, uy),           \
      |         ^~~~~~~~~~~~~~~~
/home/broonie/git/bisect/include/linux/minmax.h:98:9: note: in expansion of=
 macro '__careful_cmp_once'
   98 |         __careful_cmp_once(op, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y=
_))
      |         ^~~~~~~~~~~~~~~~~~
/home/broonie/git/bisect/include/linux/minmax.h:105:25: note: in expansion =
of macro '__careful_cmp'
  105 | #define min(x, y)       __careful_cmp(min, x, y)
      |                         ^~~~~~~~~~~~~
/home/broonie/git/bisect/fs/fuse/file.c:1326:16: note: in expansion of macr=
o 'min'
 1326 |         return min(((pos + len - 1) >> PAGE_SHIFT) - (pos >> PAGE_S=
HIFT) + 1,
      |                ^~~

--fwrXW7fUl9Ff/6Yg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlmeVcACgkQJNaLcl1U
h9BxQAf9HGqurLEC/bAa5+GdCUPrgVdNex+JnRAXx13wodsJ//7gbnkF7ruYTjXG
uHxd08MpP9HpJI5fAUXFGOnVc3ikYOj/ClD+HbJPrDeCIUTdVFddGzresI6lJilL
hYLOAIKo07m87eTkKRA7HNg3XVTi007RZJFitH6OBtsXnZ159j4NkDdrOIpl9CFp
kc6sOejpQVd6rktrhECe0R+PxjpYQIY2EBTe/MeE3ajRyyUK9ULoB476IxYgqGg9
KxXIZD25WeoDpdOFqwy4UD/8b72twg5OQ6QvzBNrUHFU2bhC9qr5r2OpjodbeGI1
NKW0tC0CEzSMpSsUNGuea3HdJ4HcAQ==
=6EHM
-----END PGP SIGNATURE-----

--fwrXW7fUl9Ff/6Yg--

