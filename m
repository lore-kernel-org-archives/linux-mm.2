Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E444CCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 13:58:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A6438E0017; Thu, 28 Aug 2025 09:58:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17E0C8E0006; Thu, 28 Aug 2025 09:58:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0941F8E0017; Thu, 28 Aug 2025 09:58:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EB4CC8E0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:58:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6EEA81401E7
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:58:32 +0000 (UTC)
X-FDA: 83826321264.11.187DC68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id A5762180003
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:58:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WrfsVLpI;
	spf=pass (imf24.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756389510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v3VuByd6TpXp1woUbPf4Xz104wlSdpf9S97PbQir7pU=;
	b=N5Na9FJWSdDIT1OKQJLfvhaF+6LrrGwr/80oxlqs5J1DqXyCxt5IdYIk93D0KUDfXx/A3S
	sP+HW+f0v6HJQxabQ+JPU7T5kFhxJONuMyJiNjc5z8nGNWbR21OCsX2eXHLyw3TnBxjA/Z
	1u5O8z+oX8654fpGgP4ghTI1CKODSYE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WrfsVLpI;
	spf=pass (imf24.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756389510; a=rsa-sha256;
	cv=none;
	b=vPiRRTwVBqLqBnMLCagYWvN2JIVIXAwzAccGMmLDGAPOK97D9DOsFX5oSU3R0XBeDWyPlI
	X7WWhgMFb/IF8NGaVUw6Jp1yAgzPajGIqL0joTAt1ZI8mDTtVeNm6RfvIcdc77sgRF9IKt
	p4Sj+55vLculLPRCi0a7EPClYk4ZCzY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 532DE40A4A;
	Thu, 28 Aug 2025 13:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8348AC4CEEB;
	Thu, 28 Aug 2025 13:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756389509;
	bh=iz346w1pfi50rQscMVqR3cBscGG9b/CJpfDF1KlI9pQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WrfsVLpIbrUkGgAu+200k/PsHzJAQOdhV7UtqX4U+r7efW+IZ3Lnx2YIzXWD3ehCr
	 FShLiemmKjyveYW7Y/Sn1aIqQcsHOx7hDhRUOu0yih3CJv+K7HiSt/xKdvRpLAxBK7
	 uNiOwHMzb3OmXsJPNOhSRmiKonF3mXegdbFfPK2XTyGjwDdsc7uxL7mtSZJj8gMwgf
	 ru2WWG4VEML2FiOwAISMO7D0Asg4S5Lfbd+5Mv+WUnOUKCg5D9d1TtIOlGGBDWkvKj
	 PHobj0Z/9HWALPe1v3/XjzRpAl3KnDm7V0af1GHnhlPvABhPasAswK4de7YkxXCluB
	 bnGI9WAIBQVYQ==
Date: Thu, 28 Aug 2025 15:58:25 +0200
From: Mark Brown <broonie@kernel.org>
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Linus Walleij <linus.walleij@linaro.org>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
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
	Danilo Krummrich <dakr@kernel.org>, linux-gpio@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-mm@kvack.org,
	imx@lists.linux.dev, linux-omap@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v5 00/15] pinctrl: introduce the concept of a GPIO pin
 function category
Message-ID: <aLBggd4rGHV_5zQ7@finisterre.sirena.org.uk>
References: <20250815-pinctrl-gpio-pinfuncs-v5-0-955de9fd91db@linaro.org>
 <CACRpkdaDGmdhaik+1saRv7Ts4myQ+tg1aQqGU3xQyT7ma8dJFw@mail.gmail.com>
 <CAHp75VephepLq61HrVy=PX2oKUQd5NK2qS-vOC5h_NR65td3Uw@mail.gmail.com>
 <CACRpkda4soRCLF5=W=6R4wnwT3pjk743j022XfJxjTTQzuarAA@mail.gmail.com>
 <534ad082-08fa-42c0-9c24-f0c11af7d5b2@sirena.org.uk>
 <CAMRc=Mdn0_yPXyYq4sbvH4P9-h71vEc4arLPBfSk1PiEFaB7jQ@mail.gmail.com>
 <1804d9dc-8814-47d4-af88-c819c3f17bc0@sirena.org.uk>
 <CAMRc=MdKgqa+vjhHvD2+Tjw5NwBtFv-0aUivi5UuEQd+n4KxmA@mail.gmail.com>
 <aLAYoDyz8Xie4Dhb@finisterre.sirena.org.uk>
 <CAMRc=Mdd3fmKjFAfbUB-AAhx-5_CR+c7f36pePkF1k_2LDoORw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="pdNHFBtb1jUgefWr"
Content-Disposition: inline
In-Reply-To: <CAMRc=Mdd3fmKjFAfbUB-AAhx-5_CR+c7f36pePkF1k_2LDoORw@mail.gmail.com>
X-Cookie: Filmed before a live audience.
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A5762180003
X-Stat-Signature: h68f8qr9iamkidgwjxrtai6uwr4odftm
X-Rspam-User: 
X-HE-Tag: 1756389510-326473
X-HE-Meta: U2FsdGVkX18snd+LtXRSkVwecGEY0lQLZlrBHDYT9nEXwsuj5TiIXeCwcMA1o2EgsKRQHffBv/B4Ccf/G9W3pfK2+VzeK56e4953L5xy1OBPKvqsE6+WftfnvOuFe6xRGWV830ySCyvBKcdBcaIVtGWzuH1EiWe7yA/ZrA9cvuZOq5kSreWS6PuIFh7sniebEuSxT/hGGVEgtMDJfxge+A3UEbEl7mEPczPWBFFr0h9chw4fRGbOXw0+jrUqiYFZKT9D4f9SCEXLRO2IiqJbzV2iWvzu31F4ro9zKPLrojFZ496o8bO7bmwh8UtDuCggNHXA1o41FsLkwR4zOFLyNu/LxkJtSYxg8rmuCdYT4vAzVP684f9tVFHjExUU9+h+zgqzysokuYnpYbpgvuzAXnhnX3tovMnjiiJTa0LBokbUhc+pDXBiB+25ltI4x5spdEUKG1AIC9SY4dZvzNL+1pABJSct1+NZvUiMM8h8O8AUmakaE9YKh6AgWa5E1AIVIxy82qQ/NRnOco68dBcolifkClo4jkl8T78zKni10412Ju3hcpo3BAro9UaxMSyftHx/6Jepy1Uq4NOqmvkwx1CB7YZcG+ISB/4KoWicZ1yTeNBus4w3EYp+OLAKF9Kky0Ts/cQOnLas/N7jm1f9pOPUkmx2oRyTdF8fQxOzAUUjoXqRzTWKjSqSqjmtwvxhpx7Bo/S7OVSVz5FxcnN2UdX8OK2yPh1qWDre904k4gXcEhAzC6yvc+baQnO5FouH18rlAd3cWJ6LJlTU3rdnvWROw1xoZehHX8kc1+YNl9nfM+8doDfEG6h6jMmX5ZJfx6RJVa85MGOSdZcVag+hDcxIeM/IV3Q1LSp4HycDAdMn6Or8ci7MvmlnzdmoWpWA6AZ9C2Mn7xV6D+Eh5gPBttoRb4gPhssczYEpW3zQmoY4eoMRp3ae86Lt+tFmFDPsHuNIZTPBPuccYccBq2R
 Ap9THPKt
 wAn/zd209CNrxROjH0dxrQ3nxhe7062hQj76y0UGXi9tLumhwcuXFuQFW4AZOw30s2MMF6k9CFJ45dylLNwA79RDqFJ8oyit4IrdmEVq7637LTk0sn2p5Sg1QsV7pLhycyaTEF2OFLzVEPAmiGkGKD4G/17OwBfV8bN8Dn2q68y8yqIAHG7q9/u4cHZITi2vUesIx/MHU5C2oUgjweIqPgC5Byqoqt/QoEYcSgrjf2RmeAbZHO8Pe/w+29R1JzhHsWdiUmApsajpM2lMKCixtU0eMHuqvazxzaQ+VIr8r8o+seGlURYFlq/AsTegGOfgZkIhllzvb+aDxCUpFWmTQ5iK/QG6J6+wxdlOW1phjwBYKqQLTa+r91RNEcCOFlzHQKbpzJOsEAz34+5CaRi7kJ0K4GF20oKx81VDEfmTH0LH/KEPCP52FJ4DcR0pymdHtp2ZBkKcg2DLAmCgjJQY2rxFQryhayjjrvcmi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--pdNHFBtb1jUgefWr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 28, 2025 at 03:36:43PM +0200, Bartosz Golaszewski wrote:
> On Thu, Aug 28, 2025 at 10:51=E2=80=AFAM Mark Brown <broonie@kernel.org> =
wrote:

> > It's failing prior to putting any output on the console.  I was also
> > seeing an issue on i.MX6 so it might be all i.MX boards, same issue:

> >    https://lava.sirena.org.uk/scheduler/job/1697667

> > so it's possibly all the i.MX platforms failing.

> Not even with earlycon? That's weird. There are no smatch warnings on
> this patch and I can't see anything obviously wrong upon visual
> inspection. I fixed all other issues but this one I can't test. :(

This looks like it has something:

   https://lava.sirena.org.uk/scheduler/job/1747304

--pdNHFBtb1jUgefWr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmiwYHoACgkQJNaLcl1U
h9BglAf/Y29OWtMPmosc5BXwhhJ/DB1eMOx6Pwt45/ZIIP3KfZVtcP8ChTwYJTVE
u2ABb09S26V06eZAT7LKYhtQG4rTpgpT1XsEFPRjINGsorTtjmkb2mzyjol9redt
4hX8VqvBozyttsvveKI5gz99QgrRzWP4qG9el23QmBXNPHXepE3zj7DQSLv/N4js
iYFSgrRlkcyUCfoQDicck2S46lGl+7Beb4HcbRWieaQf381fgBqewrDFc6Kjd4Dd
ZCuh/UCjOU4bfLFrD+7777yJnSa5QysD5PyWqvByJ3vcoCQ1dwjDDIvbFevoe8yD
Xy0drJVTnqFyVOPssrxiz7IHh1kaHA==
=VMqo
-----END PGP SIGNATURE-----

--pdNHFBtb1jUgefWr--

