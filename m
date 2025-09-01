Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92BE6CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 14:38:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD3A88E0055; Mon,  1 Sep 2025 10:37:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAAF08E001A; Mon,  1 Sep 2025 10:37:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E8498E0055; Mon,  1 Sep 2025 10:37:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8F3748E001A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:37:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0EC2385F5B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:37:47 +0000 (UTC)
X-FDA: 83840935374.08.BEBEA42
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 51DCD20008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:37:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DJgb866O;
	spf=pass (imf13.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756737465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eDBs7h7WrM7l69Eva8SJd0Cr/dn27ADGm+SkuMR5gmc=;
	b=GA0kK3V4KV9WqiqlW7Pi7/DyFQ8nwgC6j4aJROyVmgb8UzTy4QrXIZL0b+Sw5O4LveLmrT
	y0NwcCZfXIqAnFVkBpi3q6bXNbpvHLWA6OYkAquEf5L3ASPi2Lp0MddZ8I7A4z8IG2wKlW
	yYItudNRTsQePLz3cW5AOnyZ1Dr9HXo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DJgb866O;
	spf=pass (imf13.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756737465; a=rsa-sha256;
	cv=none;
	b=ocqUCEeMzdvWoBGnPg0CyJHx38m+N49t81eu8jqh5XrQJSdL6SlTWos9p2QBruPZQANy8/
	ZLnZ5Fhuh6OwZKFB8JqyVC95Lhg+Uu3SFKi9qJWwQeZf8XpUNSZh3hO2DpRiz/vVLV/J8u
	ErkVeIaMA4E3V2lSyuwJ/KsS8sZvX1o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 939CA60010;
	Mon,  1 Sep 2025 14:37:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91158C4CEF0;
	Mon,  1 Sep 2025 14:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756737464;
	bh=gIvp8Vp/E1swy4wyBXx3jb2SoCxt+LuCiS4lw6AuyVU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DJgb866OavVlQXKjEcSDRgX01RL+TgYXMilYRhox1DG2A4pbmL/EMuUOSPQkhKm9y
	 ZvbgzuWzlkHcKChIVmdcfSamTbXnIcObi8vEvl5/9muDCgJpxid02CByyOsACIh1yU
	 OKX98+D8HARzpuduhCAuxsNQWh5qbLNOOQS83t6frONv3iLVNfsFrehXLjwvOHBqVS
	 gJYuwaea4P7AtESKCzphgnRjeu3/3j4HbVoPTYqH34hpPGEiqkEowrs9BdVtPLHybV
	 TE95H7tVbki8s9jUEg4vMUHVN4eZ+ZaHfW6KZvrIPhItfOg2iPgxsvk5RylWjzgxwD
	 tuJt2jvYGPKOQ==
Date: Mon, 1 Sep 2025 15:37:33 +0100
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
Message-ID: <4a633387-08a9-43c8-81d7-488e7222aeda@sirena.org.uk>
References: <20250828-pinctrl-gpio-pinfuncs-v6-0-c9abb6bdb689@linaro.org>
 <20250828-pinctrl-gpio-pinfuncs-v6-6-c9abb6bdb689@linaro.org>
 <61bad868-d976-4f49-805c-8d14d4d8b3e4@sirena.org.uk>
 <CAMRc=MfB_3e0sjCpV+XaKcKvit7Opk5LczH2wsxO=RftrAabjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="j8LdXSlZH7SdW4XI"
Content-Disposition: inline
In-Reply-To: <CAMRc=MfB_3e0sjCpV+XaKcKvit7Opk5LczH2wsxO=RftrAabjg@mail.gmail.com>
X-Cookie: Auction:
X-Rspamd-Queue-Id: 51DCD20008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: n3cduzicd76m7on54prrmet9dn9y3yjk
X-HE-Tag: 1756737465-936088
X-HE-Meta: U2FsdGVkX19pQ7vSXDTX4OoCAv4H/YxYD5GO+98LTSMZre5VXVMQb44T71Uthx9Y+b6retAGglzrUWfSqUy6s946YQopxY5EwrBARevEwY10qJ2hBxdbqI/l3h/EB5IzUfdpBAsDty/PTQhoEgIbwdQMe3gl8TTYzA5ut9VSILtARv7fd0DYUqurdw6/2ftDyWAfeTirciG8Ylb/x2HjC4xMAtFsewheUAV8JC4mUrT0VZlL8uua4HwO5/dNSJmcIkpH4TMczfRSrfB/Yd7w8NBy1+creGb6Q7lyGV4Fh7oq9Mk2616SO1a9idjcVelkYz7cc8B8Bv1XcrGclKrn6SIrixWIKvyDxjXTE8Sx+SRP4qNzlKDhXhrNru6C34wGLZWgbzED751UXGH6vg+TkkhSJh/pqc232lVysZ6AcBDLXYUogD5JaYyMS9p8mwP8/8n8497FwyZOOwDiq3EFC0Qm/zaRVMUNsmZ+gRaXI8GOmBrWamQ72b7nsUhd2zslkkeNP1VZgBUYzmcv4kx4FQ691CUV0J+YnFX+nC025AQ4UeLNFj7NCjY7OU9mOWeam69zUScY2vVMM4x+SdCjlsijR3HqkSVR3Z9QELl4Y40RER+oynt7VowDZOkH8lZy+qDin30SFX9TRwWVxpjbmTkvlQfWpio+8xnVog/FIKdPoIWHfGtm9YVVKMOWZnKPlZAQ/Rgo4fD2SfBcQxDnDHli03jcOZnacD2+f3xzyDKhTTwm0rSg13iRZLXk0DEwNMkuBEOWFm0ikueo9scNMoXRjl+EVtLYPGkmzCw10XTpYJEd6lLVMhy6fPCwqALjO+93FoPMnjjEjivIap0PHidTrdzb4DTS2tH51GGx6mJUDvDFAMsI8xqwmB5255Da+FBc0rt5gAeZ2k4DKbDbI+GJcM8P3sxIkLySGemSy4uD0hPCRdI24tCGZTUP6E+Wko/s3xKWvSDIMRkB5oj
 HQNr9DYz
 geDQs7ByH6jDDmJ+W03DGiWeNUuHCNHFW8umfbhnTRdq/BpxQDBaKeNsykzxyPgFYLYJt7ngT2DVBWg0siE50p21f4Xp528L7d2x7SHWqJWwK+i2FhU+x1mDx6ANmStUXOxKt2CTAxDBEDqbeeXRubwudZzGtG1qE857b5BBL+N1ZycbdDZhrK6TpN0CXYwLR9Y+6Ytb1N4bcbjRSUgKCiDXn7E96GdKrBFGOOvApkFURDJMYbUpR+jpWni4H9yDKXwa39J8gp3hfhHAKbN+6Af4oekYwHZwJf6oCQwiZsN1y+BlFQHMcv8d8/eqkGo8Tos4qSF3SWY4tRkgSl55EoKSuUNLsMbf/nWxS3f6PhvGU7zHq4QllsNn2WdMrMrZQb4mu90nSiIL9a81uWbDgoEo4Wv+AQ34b4OVTlcMLNBMWCxbiYh2xuFtjvhgS71QBwS6nvZMaVzRtreg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--j8LdXSlZH7SdW4XI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 01, 2025 at 03:20:44PM +0200, Bartosz Golaszewski wrote:

> That's not a lot of info but it fails in strcmp() which - I suppose -
> is the one in pinmux_func_name_to_selector(). Any chance you could
> check what the value of np->name is in imx_pinctrl_parse_functions()?
> Is it NULL for some reason?

[    0.628245] imx8mp-pinctrl 30330000.pinctrl: np->name pinctrl

https://lava.sirena.org.uk/scheduler/job/1758947#L705

--j8LdXSlZH7SdW4XI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmi1r60ACgkQJNaLcl1U
h9BW/wf/VkjCjvE+ktBljc+ZJ9dT0UQZrXYUDHUyuCETxomTnFA+SILt5aJ5bGe/
iD8AWBpbbDsJH4vnF0ozS/kwuILQKFDettcRtaH7dIBsn/izkOQipQk8GdpbQ8WM
hWYcC4httv6HQ2rMJMgKMjRxy7L5L6xf+VRzgPc8X+0GfzYeCig6jLv6tX80PLkO
kOxJn1iP3VVHkXsDCw2fENaiXRuUOaSlrbwkkvBihKNbrM0499j/uQ4hwqAT8bTa
9ubBJhS8X9FGO12dl2qkEJPtjal2M0Vf4H4PoJilobNInq/WByIDsQANxJC8XDhG
4/h5vZiPNAzd8Qj8VQAkfeNquySq2Q==
=Lt5F
-----END PGP SIGNATURE-----

--j8LdXSlZH7SdW4XI--

