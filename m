Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 193EECAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:38:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 755CC8E0005; Mon,  8 Sep 2025 11:38:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 706218E0001; Mon,  8 Sep 2025 11:38:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CE5A8E0005; Mon,  8 Sep 2025 11:38:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 44B148E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:38:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C3DCF56C56
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:38:13 +0000 (UTC)
X-FDA: 83866489266.13.8125DB8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 083614000E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:38:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ep1EYedZ;
	spf=pass (imf04.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757345892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JWsWuN49CsQ3Cv8+OWvSzAUzcn1tVdZvcQPIarsGqQc=;
	b=VYWQ6aETXuV70MZ+iYHOUj72BFQ/fpatiGcJJp2DN6brVKCH7dBGKD0iQBL6w/3c5Z0fML
	hd9Tt5pmbFHZkxQTmLejBFV7RQWSaG0MHSeStY0N0Fco+WaZGA/eO5XFNU3re2PceY6r1q
	EumGbwq5yplgHjIRQuM4qTA7DenP4AM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757345892; a=rsa-sha256;
	cv=none;
	b=aCoOFutOCOWXrL/xLxOMbd2JGCO/FL4sQs1CT0ma1MR2GVJK8/XVKiXuiHnEuzgMDrrPeu
	87uV528xlJ9qbpWGoYQteqoXVnfsRoHgpJcVCXTXR/0mBLMfJx6qtgqUQH3y2isOZ+KFyE
	wFdtKTmbOCMTjhix64OIJiwvG+rebk0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ep1EYedZ;
	spf=pass (imf04.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5253960145;
	Mon,  8 Sep 2025 15:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD347C4CEF5;
	Mon,  8 Sep 2025 15:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757345891;
	bh=oarmcvIm1kef6CmcsianKwOkYkE4XFEwSbH1MfeQkz8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ep1EYedZ6Ec5TwvGsFIhH4bfdCRa3Al1hhJLIEPRFPaZmx2PFFJLOHx2+PsYoxPuQ
	 9SdkOxvuaOl7VEhV+W0G7k6h3CZwVU5npM87W6mNJMrvGbpJq1kKbN4ojpNMBX6icC
	 VQkzL8f5e9C+JErhGyJSNtVRKduuvkBV++VcSCdNEojPexWQhCyFlI+RCWvjdZKTtt
	 qwCJVL4FXuMV+LXKGgDu51ADdbFlqXmWvEdfjm1NHrFafa59yPCSZm2iwRdDcLTqJd
	 YwhpntsNBNfTcSuzzldNyIsAK1r78Z7OZ8Gsy/xor7kxAIWc1R5oODYoBpJEAdYNiT
	 H+jOajvRkJ20Q==
Date: Mon, 8 Sep 2025 16:38:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
	david@redhat.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	corbet@lwn.net, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	hannes@cmpxchg.org, baohua@kernel.org, shakeel.butt@linux.dev,
	riel@surriel.com, laoar.shao@gmail.com, dev.jain@arm.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
	Arnd Bergmann <arnd@arndb.de>, sj@kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	kernel-team@meta.com, Aishwarya.TCV@arm.com
Subject: Re: [PATCH v5 6/7] selftests: prctl: introduce tests for disabling
 THPs completely
Message-ID: <771871a1-9ee7-472d-b8fd-449565c5ae80@sirena.org.uk>
References: <20250815135549.130506-1-usamaarif642@gmail.com>
 <20250815135549.130506-7-usamaarif642@gmail.com>
 <c8249725-e91d-4c51-b9bb-40305e61e20d@sirena.org.uk>
 <5F7011AF-8CC2-45E0-A226-273261856FF0@nvidia.com>
 <620a27cc-7a5f-473f-8937-5221d257c066@sirena.org.uk>
 <abe39fc3-37a3-416d-b868-345f4e577427@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hfwXTexgNKMLpchl"
Content-Disposition: inline
In-Reply-To: <abe39fc3-37a3-416d-b868-345f4e577427@gmail.com>
X-Cookie: Air is water with holes in it.
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 083614000E
X-Stat-Signature: mai7f1w5pwdpr5xx63uugtrt1n7n9sdc
X-Rspam-User: 
X-HE-Tag: 1757345891-567623
X-HE-Meta: U2FsdGVkX1/VX+R1vz+UjSjtxqAkug6xAWKz+MIxxKLv69tZ9ltQkeWKvfXXx7K9o5R525hlVqOLCyrzA3ABWmsS0Dkxds6YeU/3GA4V7bDph5OUMfOy0AckBhe5Sp28rA1zPcnjdAQ22TReWY/brHcQ7QqAUje8uc+iczaBiD7aFml+zuuIiWikDaYFdCj60E33iBvpKjxsbUrsaines4NYOL/saz99BKBGXPkuswzGLYCaLxA0c2oWj1eNThH7kgP3zGm/u5f+wno5EYskMt/ssBzBlT1bDacqnM8veCKjb3tj1rKcfHiJruMaZvML/ia/lZCBW6iwsi8DtAhnTLJ2xZWp1gsELr+e+jGOLXvnPmeTIDq/QIrnNG95VTJgxado5t0zSi0wSH8DNNv1ZUyZiOLOTa5CbbWFE1hvz+19XJBFDxlDK4vH+Iqu/Jd15pWjFboWD/6+XHQI/xu3DldXl57zkAPJ+R3Njcahih5MIZqgGgBO/o/9V1LpAS40VZI6gEmw1/1lZKY0mtQijDZU/s8mgsLNiGql1gujqqtmzKF8V2i8vY42wbHYGLtuN7R8qreMlIIGByyBpL4b3kpC+ok0+ENA7EEZPfSWQ2HWoUd5WeN4/i4M1ykLybKhivOUoNpATcFFXl9yRLRPX9UWW+0Su7MClOC6VbkOEsAQf3yScMo4gYxpqlW911NXp+sepxtVwvRslE2JTDBAf0ORbbEWI/cXW/3HittG0irall1lNKK6u0W5RGLAL2MCWFoakoUURH3oI/RaJmIFSEwLV54VIZ0ISVQoy6wF1B10a05ZEt2MdrV3H3oPBrBB5X1If3j10pAEBKqxcdO16J6vVQxIqDuutw6zRSgdUJRyJvfjBChPQdRqh6u6mq4dFem+aPcDYrmWb3yjPYgoJkzsh+2YqeUoxxsTHXGdCwLqRV3mQVusYAeKSlmdNcn7+FtkyuVyA00Zoq2m62o
 gfXN5CL6
 KtE7xzdQI+7jPQbfbtld05qPth1NfB4xOtQM0Xd49c8IX+2dGFS98zZH64sCLfxO8d/OXHZKqmJVNbIxZgI+b2LSXJjKHhqSJA1NKB5l15bO8/xU3k7TtgnqnKu8LCMdYSdfW5hv1E4+L5VL0tc063Sw8jsSEEUj38nlOxuonyHtacG1qPsBiquPaoy49R5hAtWxrXw4ZN0fzVB2zTxHU/giuxQgyCAosw/3291LKyUO+56+5JKwRrC7akJT0CgohjPbKk4HvyUGcCHkDXieE5l+4TV07J4SL86mql2llgsfKKXKqBN/+T0sZ78vyEt77ndPmNjPY6pkSDIcZyZAbFYahZd7SkqjBSfMGmENvk2JksYY4cX9biZHJ8/+Y/7Xi+Pyp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--hfwXTexgNKMLpchl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 05, 2025 at 08:40:25PM +0100, Usama Arif wrote:

> diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
> index 89ed0d7db1c16..0afcdbad94f3d 100644
> --- a/tools/testing/selftests/mm/prctl_thp_disable.c
> +++ b/tools/testing/selftests/mm/prctl_thp_disable.c
> @@ -9,6 +9,7 @@
>  #include <string.h>
>  #include <unistd.h>
>  #include <sys/mman.h>
> +#include <linux/mman.h>
>  #include <sys/prctl.h>
>  #include <sys/wait.h>

> should fix this issue?

That seems to do the right thing for me, I'm slightly nervous about
collisions with glibc in future (it's been an issue in the past when
they're not using our headers) but I guess we can deal with that if it
actually comes up.

--hfwXTexgNKMLpchl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmi++FoACgkQJNaLcl1U
h9CQUAf9GffZCLtWduDOey9wyk38tq59lJt4ncsVhdGdlf8P9K1mRKQ0QbwiQ8WK
IcvgFV17rPnWluoFp1fMi1Sr4QTodXu0Mh/9Nwi1WePdL7oN3qIPJc0vVpS77hSb
/n9SoSTWu/wTR+aC7MUbNOhybPJ51EmWgKu9OjRjiaTPhZkcgsnmf/UdbrfxIo4B
/r8mDK+0ueEU7f4cNotXEHwX368l7XaxAS4eUZYA3G+dt4KOd870SmQoNm3XvFHO
aR56puJdfE5dssvWD4SwFfG42uuwRv36s3tS8zftcU/TM7bSCFLscYEy/GjFXjtj
yxPy8DivYxW2jew8K9YE45p3LMK7Lg==
=ts8T
-----END PGP SIGNATURE-----

--hfwXTexgNKMLpchl--

