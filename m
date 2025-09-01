Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91CF8CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 12:07:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D72FF8E001A; Mon,  1 Sep 2025 08:07:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D22DA8E0013; Mon,  1 Sep 2025 08:07:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C11D78E001A; Mon,  1 Sep 2025 08:07:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A96478E0013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:07:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 38AED5B8FC
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:07:02 +0000 (UTC)
X-FDA: 83840555484.14.5B71354
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id C6B994001A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:07:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=subnAYt3;
	spf=pass (imf01.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756728420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SaqFO0sDHbyFDKUxJaISMy1ULYDKTNlohIR8NfBhEDE=;
	b=xvw4zdGiZuWY8tUEnot3UjVIUPf33GdTMPOFfJFWaT5JwZsCwNGH71hpmArIEl4yEhPNB1
	okn9YQbrih8XrGocQu/KwvTcKfEsij0ZC1gvJq91S+m/8osH5SqZGt4d8MROiD33EQsThe
	WjrJoAJj/G8r9p9i6ANqZJ0cPqxhjhc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=subnAYt3;
	spf=pass (imf01.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756728420; a=rsa-sha256;
	cv=none;
	b=J4RtRkhm3l4AyCezgVnUdXLccO7gblGcAHa1J8j7NA/uysQ86kwKjtJ0bWhgR2MnzACjQq
	nCRdXPNCcvptK8z8q0/U8WgJyzEFvKsjl7EiW8/lr8QqT64ENYHZHqsiRYM7OeuR/x0kuQ
	p2mKq1Mwu24XnoA+uCQqUB77G/enB/w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F27CC601D6;
	Mon,  1 Sep 2025 12:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750A4C4CEF0;
	Mon,  1 Sep 2025 12:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756728419;
	bh=KLozvW2/PZEE4MLEPg7Ckr+Jd7gWELOn6bfbOk7IAwQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=subnAYt3W6iRYWiLe4R1hyk02hHWugF12CkdwNtfWO6oweESVzkr4HHQSgrGdK/hQ
	 8F1KuLkxbirhX9eTa+UlHzROt6oVHRMDVtFWN5s14w38M5Is6TmFeJ5JJ8je4krspg
	 pBRIf5eDDzE+sPD131SIUvsN9YtFG8xjdavT9OTqqYxDYZRUulC8RH0fZzQh+efv6M
	 zm0xO5wdKFGcsgmWDEVbNVw84C2PinGI3Z8RXMoIob2mUpV8kkm7QMdnJyTfUcaJ1e
	 cCDoP5GnBM8z+lPd7plFSP8PsGAkGVMDl6cqmwfcIkGDifWC/YBbKkp9x6hig/ZOBh
	 elTOdLAEWl7eQ==
Date: Mon, 1 Sep 2025 13:06:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Linus Walleij <linus.walleij@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Sean Wang <sean.wang@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Paul Cercueil <paul@crapouillou.net>, Kees Cook <kees@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Dong Aisheng <aisheng.dong@nxp.com>,
	Fabio Estevam <festevam@gmail.com>, Shawn Guo <shawnguo@kernel.org>,
	Jacky Bai <ping.bai@nxp.com>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	NXP S32 Linux Team <s32@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Tony Lindgren <tony@atomide.com>,
	Haojian Zhuang <haojian.zhuang@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-mm@kvack.org,
	imx@lists.linux.dev, linux-omap@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: Re: [PATCH v6 06/15] pinctrl: imx: don't access the pin function
 radix tree directly
Message-ID: <61bad868-d976-4f49-805c-8d14d4d8b3e4@sirena.org.uk>
References: <20250828-pinctrl-gpio-pinfuncs-v6-0-c9abb6bdb689@linaro.org>
 <20250828-pinctrl-gpio-pinfuncs-v6-6-c9abb6bdb689@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ck2hWlO4+9LtMqEh"
Content-Disposition: inline
In-Reply-To: <20250828-pinctrl-gpio-pinfuncs-v6-6-c9abb6bdb689@linaro.org>
X-Cookie: Auction:
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C6B994001A
X-Stat-Signature: t1eac1w41c1kneznigj3o3jqe1jo9z6c
X-Rspam-User: 
X-HE-Tag: 1756728420-382133
X-HE-Meta: U2FsdGVkX1+iI+oe1XGA/gELTux0ZIpQ5fjHExKKxi9lpTctDUqhrBe0oeqERdktiVDTygYPaikIU+Ee0p+FN2YAuRQKpQEKLyhtmdGkVX/lUYK19W6FFSkj1x9DCWvSyR+GSWDK4NbEBhtp02BrHNwEocbE/WyRGSpOeUqz2sRd7uwIiyHwh0zfCnQhxyItMU9tYViJx1RortpHgeSD7HJ/BoXgn7MQmrr4muSKjA06IWryXRyv0JH25hM5Vt+RUaIeHWWKUAWYmhFNgFXqvIgP0kWViykf6MabhBdUqI2k5XG8vHL0ryR5d/oyBVViENeT1mTTrBdCENBbLqM1lpsmydbtyTkQFl0y4bpKi1Bd3KMq/IxNAPrRspIHq32rgsxZVyhslMMVRVJGKhWMsaJD0Ehr5ki4InnxY7sA+iFA8v/6WrfGLIFMlkDjiyTjwmmCwjQlmnmvKWD1dTSGdmM3xacwhH4/P8xJgpcxZLbVZmWQekFhATel/Wt6FjwdOyatSHsFuh6ATECeEedUSiyZ+HFaMPBqAV5trj2ESJ2HGtVYlPzk+StKEY7CDhyvK+RkEKQEeYoIppip/3DE4wp99hZcS23s4syEp4Ayg8u8SkwNwY1iexpPpndNPOskHOAbLRYt/rhU1o0SAywRtiAz7yuqfOxmAAGgcfVkY/LLNF7E0Be7tg/7PlCnJma3fiXy/Jo2Azo5UW0Qf2WoHG1mBRQDA0FqblSMopvHycVHjilTSTV7NW3AUc62fYf+dHr/6xQLaoy+U1rsYK6xPExbbHCAJEPepkGPlUs7b2+VqxeAGmtUYXg0mzrLBRjj/O1sui9J4R7PO3ScijxQoFi9OU1jc1nTVthQnXyPN136/fTUlKTsbhX8UP1vSI7g+vVPG2B94DNbOPPJ9nvS733gFefuNrHPOudwmYkeVmwc4pPGyEt+5FJhDQAYlsItx67XXmtDbpNgDqYnLw4
 Jyxrb+0j
 IVaCo5PYCd2WRtgy7yw+enMR1v/kemY+DTpvl0Jg1xA3VWFCeYa/lIxxvrwOLufuVhO3o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--ck2hWlO4+9LtMqEh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 28, 2025 at 06:00:14PM +0200, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>=20
> The radix tree containing pin function descriptors should not be
> accessed directly by drivers. There are dedicated functions for it. I
> suppose this driver does it so that the memory containing the function
> description is not duplicated but we're going to address that shortly so
> convert it to using generic pinctrl APIs.

This is still failing for me:

[    0.628221] Unable to handle kernel NULL pointer dereference at virtual =
address 0000000000000000
[    0.636506] Mem abort info:

=2E..

[    0.801855]  __pi_strcmp+0x20/0x140 (P)
[    0.805704]  pinmux_generic_add_pinfunction+0x28/0xe0
[    0.810777]  imx_pinctrl_parse_functions.isra.0+0xf8/0x4a0
[    0.816289]  imx_pinctrl_probe+0x404/0x520

Full log:

   https://lava.sirena.org.uk/scheduler/job/1758025#L704

--ck2hWlO4+9LtMqEh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmi1jFcACgkQJNaLcl1U
h9BGhwf/dS46HMJilXSgdHmEKJbp5ioFAwW8a4pof2TF7vY7Jpo/qiFqnKkvqhYC
tZO4exJFROsDCUKlVPp+Qawyyhy3CCU2p+vHcuz8p07gmzIEOw9QkjMf8IMlPGyA
UKEr+nQae21YF/iNRFDQGH9hqHAT76YwExslci+ilyDzaJeWu6ACPhVMFMNO9a/q
BjCieo2alJTBGdLUFgFDoMmVmqebVqIBYO0m966vo/efy8UG1BTlGE++FYa1OVnt
bVDlzyyNsdl94L6s8pxhABsajGCsOXj0inSK7SXdnJ4XusoEfuSIKKSieCGsjMEG
qkdS6DTMFfXrzPQZI5S3dgsmyVchug==
=JXXf
-----END PGP SIGNATURE-----

--ck2hWlO4+9LtMqEh--

