Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16FFBCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 10:22:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A0636B0278; Wed, 27 Aug 2025 06:22:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4781E6B0279; Wed, 27 Aug 2025 06:22:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B5686B027A; Wed, 27 Aug 2025 06:22:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A6A16B0278
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 06:22:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A63C7160538
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 10:22:06 +0000 (UTC)
X-FDA: 83822147052.10.02058E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C63BDC0015
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 10:22:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CMY73pat;
	spf=pass (imf28.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756290125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=feIeFoFe/NIkaHWsBJ6sykJyPk/bFO1DqGerlF+Pkfg=;
	b=vlaLf0l5fZQxZo7tZMcduGzR0Lgqp+WpjKTh02ZSCbZPtO9EtdwVs3ExNaxJtkJZe5GBd8
	hn0OKL042mfCWxOf/m+gzl6NMQYJj98FLCR+iWSDl7p2ex16Dvf4RA9zyMS0qdiBugdyMC
	DHiifgiLV5belldOh8ZyEmoudYqfLzI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CMY73pat;
	spf=pass (imf28.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756290125; a=rsa-sha256;
	cv=none;
	b=RLjJRxkor2gVzQ0Y3guaiQAPwJL9N6vsPh5TIFM8OgG/QxlLWsLwgV0ho5BiOgb9/fKpEd
	QT4tBHFmhDO06KQSixIK09JKeBONZWThuG8oSp55cRBjRcldHB/kS+KV7ZBTjxvBLvpjOQ
	6952weYsvbQxaWlhSb3gkCOMi2M/lzM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E3E344A47;
	Wed, 27 Aug 2025 10:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E6FC4CEEB;
	Wed, 27 Aug 2025 10:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756290123;
	bh=feIeFoFe/NIkaHWsBJ6sykJyPk/bFO1DqGerlF+Pkfg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CMY73patfhFBm1cWrO0GjSOUppBTmRm9w9tK3Op5eYvw95EorabzAemE8TKMQjBN0
	 AFJLkvpc/07xvzw49PtfcXgo1jyfgqSIyA3tv8EQho2HxgcPu5RJ7YIj6+5ZO0Jjfj
	 ejeS0GRY1n7Mq9lcoiSrFgud7UC1CHzgBEAzXF9wgw4H35uLjqwGgcAgwRdWTSnps4
	 uVbcQD9zxttmWF0K8GiZTPHDS7eDEZN1k6CLQV5sYnoFYmqneHGPBxowx91U05F03k
	 g5jrxQjovkqZ6CO/JHFUeS2pHASrfBK5fwYnJi/a4eamilP7bDZYeUuhHoJFoX+o0y
	 IaB8i4S88yEdA==
Date: Wed, 27 Aug 2025 11:21:46 +0100
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
Message-ID: <1804d9dc-8814-47d4-af88-c819c3f17bc0@sirena.org.uk>
References: <20250815-pinctrl-gpio-pinfuncs-v5-0-955de9fd91db@linaro.org>
 <CACRpkdaDGmdhaik+1saRv7Ts4myQ+tg1aQqGU3xQyT7ma8dJFw@mail.gmail.com>
 <CAHp75VephepLq61HrVy=PX2oKUQd5NK2qS-vOC5h_NR65td3Uw@mail.gmail.com>
 <CACRpkda4soRCLF5=W=6R4wnwT3pjk743j022XfJxjTTQzuarAA@mail.gmail.com>
 <534ad082-08fa-42c0-9c24-f0c11af7d5b2@sirena.org.uk>
 <CAMRc=Mdn0_yPXyYq4sbvH4P9-h71vEc4arLPBfSk1PiEFaB7jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2cfgNcmAX2xoMgwh"
Content-Disposition: inline
In-Reply-To: <CAMRc=Mdn0_yPXyYq4sbvH4P9-h71vEc4arLPBfSk1PiEFaB7jQ@mail.gmail.com>
X-Cookie: Most people prefer certainty to truth.
X-Stat-Signature: tunsjt9nnwb9jmojxzjctc34kgkbxpns
X-Rspam-User: 
X-Rspamd-Queue-Id: C63BDC0015
X-Rspamd-Server: rspam05
X-HE-Tag: 1756290124-281788
X-HE-Meta: U2FsdGVkX1+dIwCSLqam9gtjzFS9ijVq+T2tDn00ebdCnMrvxHg0AlHm7upxymWkt8vOPHLEdM3EsRPn/5sBfmZFeC9RVFxvHc4RKuodv6iNB4O4vTFgtTzYUBQZjN9+9RdeYtrEEIFVCHgoAihrsTAAsuPlgsz1KTINNC5lgju4JbEaJLKj1xGrYyWDLvXp8SPYcIHnvKtH1qO9bjhhJf2o5hLIYmkMLBJlvF37N1f5j4UlqfuSQufeyOx2ahhVONkvu/TSsUBHfyGUEOEeQndjHUnwFy5/LuJOlwpRrDnjn6jD4cxi/W/whfR5rAMc/PPTWaBwBSevlWeRQtn2P5sWb7MKvZuAL70qLTKfL49zDCW/wA2vQ0i2lljrGVl6sWwgxPZSa6d7BneFoNM/2f6XueWfUWCoFk93Qlps6pMlD9rTnnBlKJwsxyP1BDOqVfjnoTNApymTfWNUlqMQ25ZmDHO/Z8OSw21ypC6rgOvHfihy695+7+b3XkxW/t4G+0FveE7g31/MOUh/CtBzyJdoZLzxrJcUdjoRLDg1WfuBbCYeQoqT356N1SrMWCjqoHT6XJO99qRR3EejbwPazaHCG2bpR/z7Wyf/MOyi+LwqVEwHpOKQvJzlsWYv++Fgf3x4pFMIAXrjn5Et9AotFz5KITUx4PnTYbROo1Qz1rh5VAcJ47OiS8LXKCx19knJ7iSd70SsDuBFQo/G1F8Ihyh+uPsdPw9xADktxq/BpTYqNW+RbIxrS6wcxcKcmxltqQYe/IOnjlNReFJSlYnjHM0vh/5M0BEjLeWIofrBi2Rxn9ncGRx8jygHMQkmcTxfjkbdTPuCiIFULyaAAfgbHyAxnKurigtPyZ1EDNAoXw0M+EFe5jC8Uuy8CZgOfEuvYYFYyJTkVuyKKa2xPDc0A9OuOXXmSWq6m4uVndqppWjXsuIjylh66FjyAU/ref/+mO9fkwba9INcRsdUb2m
 6qTsCL9U
 YU/NyVZkC2hxpAGogBqncmDiE++YhZDTv9FDBEQXQpiF2gHe7L5E0DguZ6ma9SIKLCx98NQJw/5/WlYxh58BcBihDkI95tippygwkROv0Gr3rNSPuRZuTA6EfF8V05CK2XewZirSeUgR77sHbOKtoqimnOgSaQmeIYKpmEo16yIfLLOXu02Z91Bg64MOibcNofN9XRvWIanJSBHzddRFkCTcRahey3jMADAjS0XCnhowt0/MAXrIL4l/liBdDnvNZnteR8Ozq+SL6wdtq5EXWB6nGwRtpw3uDdgrisX4OGJgV5jNPJrSTvd3nUfOwoglZBbJWA0T4nXDGRTGb9KWBEkP/a/J3+SiV0rgvXQP8eyF413knTfg5HcLNU49pi4Q/4rBFSGLKttlcm9TagY0CvvVQw0vfI4Q/Tt1A+ep48Dr+4k4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--2cfgNcmAX2xoMgwh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2025 at 08:19:37PM +0200, Bartosz Golaszewski wrote:
> On Wed, Aug 20, 2025 at 8:41=E2=80=AFPM Mark Brown <broonie@kernel.org> w=
rote:
> > On Wed, Aug 20, 2025 at 09:12:49AM +0200, Linus Walleij wrote:

> > > The qualcomm 32bit platforms fail in next anyway so I dropped the pat=
ches
> > > for now.

> > FWIW the i.MX8MP also seems to have been broken by this:

> I can't test it unfortunately - would you mind sharing some info on
> what's failing exactly?

I've just got the log I linked above.

--2cfgNcmAX2xoMgwh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmiu2/8ACgkQJNaLcl1U
h9AN7gf9EwrkCMDKQJ3+l64opijlSNrt1Fb1YRWh9KvdN/1+7aQ7T/xu5C8tCq/f
8Egc7c8xmS27/9OO0NDM90NRmoDvRBfCYsrX0yqXzJ/SMQ27wrw9H/OnNqrrq9V1
OU0NsJVeKrt5FELD7Zd1UbdrMmQXQlJeWx80plpgQDCxBzBliPEFiSg3OkTc+mqd
Ef9KfjLAlIwsCVBOC1uwPq3Z0vsIDMzbxXq/e9R6nmwhHZMI3puSNp8ZmUBXBSeq
D8k41vgIAo2YLmAdLfeiepGWT3CcfFlmbEHdeRIRVUS4zoUK0u0/OIedQnCwXknI
ucg20UGLpA7K1JhJlA678HGIBlpJcg==
=VNoC
-----END PGP SIGNATURE-----

--2cfgNcmAX2xoMgwh--

