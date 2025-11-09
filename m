Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C0A4CCFA1A
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 12:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DE8B8E000C; Sun,  9 Nov 2025 07:30:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B5E08E0006; Sun,  9 Nov 2025 07:30:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F2888E000C; Sun,  9 Nov 2025 07:30:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BF5A8E0006
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 07:30:51 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 786A81607F8
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 12:30:50 +0000 (UTC)
X-FDA: 84091002660.12.E308B0C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id A309740012
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 12:30:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FNEr1lj2;
	spf=pass (imf04.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762691448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FKaPQ+/jyUxJhopvIiQI399smlzGultDmP1LTjPT60o=;
	b=YR8Bk/KyOGLw4yNn2s37ZIWJKdADAe4xbBV1zy6ovgEbbzPQCiDKUDO2VIqKDqbMv1d5+b
	O7W+gs56kE4B4Jps3xTlJx0Vzv6nJUqnIoJy37M+g7GNSd6i/bOLrEV6Sth5HtstaiLio3
	F1d3ARHcjJyviiqN+wIj0bWXZDsMsv0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FNEr1lj2;
	spf=pass (imf04.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762691448; a=rsa-sha256;
	cv=none;
	b=6IykxHKLm/Bn055UvzSLAOmLMEYtauLi/moIvUmuGgTEWTfgBJQV0ym1RzFl0HpbKYK0Qk
	Zbp7r9Ew4Yak3NXohei+0NhWCl6AcgahD/4vokD2Ztmdpyl5/7Pc7u3ZnT++U1II/AsDhf
	UsJHvtBGmJh/1e00Bqb7Ly80Ckw+UBc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 70DDA43A3D;
	Sun,  9 Nov 2025 12:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776D7C19424;
	Sun,  9 Nov 2025 12:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762691447;
	bh=uaAzoyaBailq2b/m0o0Kpjlu+Dde1wzPbhrBuIBEfDc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FNEr1lj2oRM9QL/mU9SWQIDdmge4KwfbwhjMVBEhst+fkf+a+ZUTpmY7ziG4zbWk8
	 o1BhVcs9yexQfaHgyOfke3dsodcmL3Wpe2mtQJap8VdLTePPm+NjV8PKzxHzCeL2Ra
	 dwgHOwrgJHw4qF92ZXTq1pLuxLIZ8ZNbohqP+hIhVACo4VH4xxHSddZeQW0GIZuzF2
	 9Z/vfA8VFioDp2BnhxijTAIGfxikPpTmcsZLVBDzNBixQo07yjWprRR3CnRuIMbfEE
	 lGE0jbdSNVReiHoKq3WObsEZkO7HdM7zIewhXozXzrmhsG/brWoDlZqT0VHVop8kW2
	 x6xPHNNnE/JOQ==
Date: Sun, 9 Nov 2025 13:30:42 +0100
From: Alejandro Colomar <alx@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: linux-kernel@vger.kernel.org, oe-kbuild-all@lists.linux.dev, 
	Kees Cook <kees@kernel.org>, Christopher Bazley <chris.bazley.wg14@gmail.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v2 1/4] array_size.h: Add ARRAY_END()
Message-ID: <hianmnv3t7xz4mf5oaicei4q7vqudrnkhmexzkoxags3gvyj2n@qvebtox3uvyn>
References: <35255c1ceb54518779a45351dcd79a3c1910818a.1762637046.git.alx@kernel.org>
 <202511091804.XUQA4dOK-lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nm4vwnmvmi2ifa5n"
Content-Disposition: inline
In-Reply-To: <202511091804.XUQA4dOK-lkp@intel.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A309740012
X-Stat-Signature: f9ar73fy6jfu7bfn17bpe5yn8xh3yopt
X-Rspam-User: 
X-HE-Tag: 1762691448-675639
X-HE-Meta: U2FsdGVkX1955yLS6676z7aP0YLY7ZHCXzeRx+lYgZHq6JZlj591RWDxj/mrO6W8z2Y7IddUflT86v6qpxd3TKg20h0Cyyg+Szqg1CJH5wKXdg+JQs+0MRF9yR+iMG+wO0/1aFGdccLUuTciKiIGUxmKQucZuS5+njEpZv0BJ9PQrFwkokzz02mCSOMaDSZcSOmCwein6WwxopB/HANZO0V0Ca6RFcLd1TD72x0qmWZpKoEDxMRF2RgYvfASnU21niXoJ+MZkj/fvQAmiHF6uM77t5uKuV7VqYqMPkOz5PtLKl4ar8xupTK1aZ8109IgcApRh+Fhs+e/Klazi81NF0oKN7CuD+XOMJsHjv1gNbUYyR/sEfBERzQkkrTqiCcwk7kUd8KaNA6HonzAElW3BAVGWsbd8VTfbXf2HtGg4WKtIBSzh41N0lqYGFpum8osmYjP9ag/JAcJ5ZfEk7dYRpT7YiZFx7iwGy3DEE8p3zOQMcyv52lYK6UT22wky5uYGwa27KqLi+e/fFCTCVaQ3zUcTWX96XxtEEa7z0Qusd9PbnZqCcxhKfR56gJ+KoxwuYTC1qX4geXbg1DUtTQFtsQGlssX7fAB+pD8SihYSubmC+bHqLLF0v0Iz2sJA51ZPad4vTeUBNZvISs7P0ygHMwWrNbWAnWvGR+kzeF8iBAzCiorNKPwwObtaf0ERb2pmkBYIGZCR4xuoikBprrGZk6LJjCx1XoDdLWuZ4fQyHljyz7PSuiTVobf0ifj4BOBlqoTBUxuEur2Pak/qxWMTc6atKa8MpdnH29sCyInJBl067nw2KXjgQSJ4Pc58wyo8FeSyQVNmgER3pHhZWve0uAhXI77GGo9eAFfz4z5o4tkosQqOT6WZ15tZ1YtQnRNwoWUDhtGgtbN1FtEgtXaAxaAFwEOhtkgzxtpNDLgp6b5899Sd4heINw9Uu+O7jAhhVKqo/+7QV0uPdUmXXi
 xNbyG8AY
 oHo6sbeN3aSVdM4dHN23JOcYLFSNA1YstB3xO41N05H/lTygRLLlLQy/7ShL3vf6hrxea2poVRiQKJMNk1bnY1EBVkg+FY47qaIQGxW5/Oz8nFcdo8+wqMgop1Tkv5nRm0x2if99yCKcopBJa5PioYLfxe1up9azc5mzFoEH8YeRNCr6QAWX4m9+xPnVEkkgZsW0eCZ1G3lyGb4aPNAChsNhVFtlKymDjGQ6cctMXE3w/1n4V1jhfbg1Wc2nuX1/1/5nLVQjyEyrRMMsGAjvWNBRZdTP8mDob8pS9wDmoMxtydnccn4pdTW2j+hWpgDAL/pkgyZp7aQV0+LDMAbYLmc7SFmXGwqtB82gogdkLC7i3/ev1M+HLmqiK7ycc3lVvsvZECKu4GvLUTi7FDukEa6n3LUnVSmYb0fRXUuIAYBuTQ2YcNDpruwwrsK9f4o3aHYA7vxfkne4TQd1p4SzwmBp44xvPldcWC/T54pOwxUyFeLDTCx+GIxT4bXAjz5LAn6ERiU9dpcSASoLMPBroGjiIf77pm5TyoP/kEY3Jdg9ug5LPJ2BfQGDQumV2Xt0ikh3iWXDmW+IV7SI1liZyjuQgPW6YwpqaC2wuCYU1vKNOmeCkuk0Kg6HpbMtO6UrtfGLWrVXL3RcdK0MjqMQGwwN9tg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--nm4vwnmvmi2ifa5n
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: linux-kernel@vger.kernel.org, oe-kbuild-all@lists.linux.dev, 
	Kees Cook <kees@kernel.org>, Christopher Bazley <chris.bazley.wg14@gmail.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v2 1/4] array_size.h: Add ARRAY_END()
Message-ID: <hianmnv3t7xz4mf5oaicei4q7vqudrnkhmexzkoxags3gvyj2n@qvebtox3uvyn>
References: <35255c1ceb54518779a45351dcd79a3c1910818a.1762637046.git.alx@kernel.org>
 <202511091804.XUQA4dOK-lkp@intel.com>
MIME-Version: 1.0
In-Reply-To: <202511091804.XUQA4dOK-lkp@intel.com>

Hi,

On Sun, Nov 09, 2025 at 06:43:46PM +0800, kernel test robot wrote:
> Hi Alejandro,
>=20
> kernel test robot noticed the following build warnings:
>=20
> [auto build test WARNING on 6146a0f1dfae5d37442a9ddcba012add260bceb0]
>=20
> url:    https://github.com/intel-lab-lkp/linux/commits/Alejandro-Colomar/=
array_size-h-Add-ARRAY_END/20251109-062234
> base:   6146a0f1dfae5d37442a9ddcba012add260bceb0
> patch link:    https://lore.kernel.org/r/35255c1ceb54518779a45351dcd79a3c=
1910818a.1762637046.git.alx%40kernel.org
> patch subject: [PATCH v2 1/4] array_size.h: Add ARRAY_END()
> config: alpha-defconfig (https://download.01.org/0day-ci/archive/20251109=
/202511091804.XUQA4dOK-lkp@intel.com/config)
> compiler: alpha-linux-gcc (GCC) 15.1.0
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20251109/202511091804.XUQA4dOK-lkp@intel.com/reproduce)
>=20
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202511091804.XUQA4dOK-lkp=
@intel.com/
>=20
> All warnings (new ones prefixed by >>):
>=20
> >> drivers/block/floppy.c:4805:9: warning: 'ARRAY_END' redefined
>     4805 | #define ARRAY_END(X) (&((X)[ARRAY_SIZE(X)]))
>          |         ^~~~~~~~~

Hmmm, nice!  There's already an ARRAY_END() there.  I'll remove that
definition.

BTW, this reminds me that I forgot to parenthesize 'a' in my
implementation.  Do you have any preference on the implementation?
I could use either of

	(&((a)[ARRAY_SIZE(a)]))

	((a) + ARRAY_SIZE(a))


Have a lovely day!
Alex

>    In file included from include/linux/string.h:6,
>                     from include/linux/bitmap.h:13,
>                     from include/linux/nodemask.h:91,
>                     from include/linux/numa.h:6,
>                     from include/linux/async.h:13,
>                     from drivers/block/floppy.c:166:
>    include/linux/array_size.h:17:9: note: this is the location of the pre=
vious definition
>       17 | #define ARRAY_END(a)  (a + ARRAY_SIZE(a))
>          |         ^~~~~~~~~
>=20
>=20
> vim +/ARRAY_END +4805 drivers/block/floppy.c
>=20
> 5a74db06cc8d36 Philippe De Muyter 2009-02-18  4804 =20
> 5a74db06cc8d36 Philippe De Muyter 2009-02-18 @4805  #define ARRAY_END(X) =
(&((X)[ARRAY_SIZE(X)]))
> 5a74db06cc8d36 Philippe De Muyter 2009-02-18  4806 =20
>=20
> --=20
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

--=20
<https://www.alejandro-colomar.es>
Use port 80 (that is, <...:80/>).

--nm4vwnmvmi2ifa5n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmkQiXEACgkQ64mZXMKQ
wqmWEBAArRv4KqHros/WN5GykK1OkUTtJHY9EMVRNzdOYuVwLFmlCcXNgJCNmkZB
OQiOvD+vb05Dz54F3QM5IEQ9b7Ucd9PnaoPFGX74T27mBkVQCQHKctCxlV4jDsTr
hc9Mlsa6P825DWNGIOUenVXZnedXYdJ6QZQBakMGmGNTmM59MO7EsOyGGAsKuSNc
g2fWS7dmuu9UsGqLChOFuIPzyYOG+zDyx/ZsqL4KuJQdmwtsqT5hS/F7MlRYCzR7
ZL0psqotrkw+J6J10eGbnG5eD1hhryhzM220njMAa2+5dHkcmlDgaGPlFVDGu36e
k32S7FDy+8ekl4bHDcWF+u3HZdQZrznMYEGI9XERB8lRy2HHKUa84/2rEHYcKMZN
/01JlnfJDdwMTXK5UPesC8JnRKxS5WgINcbwx25pjVe4DB5Llyd0ZfeMJ2A3oO6s
mNAUdAEuxQDXp5gOGt6cNp8fHJ0WRjc8/hLKRMKzdG79A99uQyhtPJIblJ+ncY97
OrYNpmLr7nqlaNUn0Q1gc68R7eJ+0CfVwPARBd/avVt4fIbhddCV01/2wOaDakOK
ejvhJgpaDWnQiI/PczyH/APqN6jQ9zYQtN/3Gdo8gYjATsNQlur3xHlX3CEJ1TPM
/6+l/fQNKftr8OB61bbZWt34ZY6RqkIosS6aTy09EQNRN5opeRM=
=smMe
-----END PGP SIGNATURE-----

--nm4vwnmvmi2ifa5n--

