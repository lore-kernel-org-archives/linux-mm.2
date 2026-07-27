Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D355AC5321C
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:13:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD7046B00D4; Mon, 27 Jul 2026 08:13:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A61BE6B00D5; Mon, 27 Jul 2026 08:13:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 928A96B00D6; Mon, 27 Jul 2026 08:13:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 680886B00D4
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:13:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0091B806E8
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:12:58 +0000 (UTC)
X-FDA: 85034445636.03.9832A23
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4A2541C000D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:12:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cJUiNzz1;
	spf=pass (imf20.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785154377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NuMpyXi203gMNqb11rcfOKZmtmuJN0EPDdTrfGAbmqA=;
	b=ri1/xd/hkbY4ocgjdCG/orvBKBuJLU4KSb6OttfgDUwbPOhKFgoDmbWiBK9Rmnj4n3Jj2b
	Ey87HPW/DxrhmuLLFv1zRbicieqGIH0tV8iMsccHgSLCgYNlAXktMBGk7nsCVy7NZlXtVP
	E96M5A6E9wP0KY7DJogy5Mf2TnRcQQE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cJUiNzz1;
	spf=pass (imf20.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785154377;
	b=C29Gasgb5zYleAuZD/2clIDaXfVc2mYN80UVS/TGAbL6pcPr5neoCnGB2bwymDcD7TtbK4
	KJwu9L5hGWfI0hRhNJehsvvS3hUMcvrH1rNpzjyoApWk9YuKbClvYlso201oTqfTcrd/As
	H8msXby4DKCpWFO4UkSMkkmheheTVGU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DAC743950;
	Mon, 27 Jul 2026 12:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0753E1F000E9;
	Mon, 27 Jul 2026 12:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785154376;
	bh=NuMpyXi203gMNqb11rcfOKZmtmuJN0EPDdTrfGAbmqA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cJUiNzz1prDmu0GWRwCZ182TsRp83BQvTp0/rURfnkMQzP20L6fG8sazv0cYKgUtW
	 pg9MCuVlTFHqe3x/O6EVkylNOZs7wcPPsZhmCr3XEWEcOo26weH2DM61fSqQ+OmbrP
	 tvyWB2eboDXUxX9deZuSx028Hbg9foCFt8d+5Bw+IlFteVi3skzllTVeGL1XafPYbe
	 08wppeqNa8S6eH5zJPQgihAdalyGQJliwPyAS5P+AP5v8yaQxZyfcN5KNznMD5HYbU
	 HA3HDDWzzh9ixbV9ramHSWGxONVFCvMxk3yVAI+jirrpd4gfEm0DA5Mx/fNCvUjATc
	 xHtThaOzcAK8w==
Date: Mon, 27 Jul 2026 13:12:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Julia.Lawall@inria.fr, Alex Deucher <alexander.deucher@amd.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	David Airlie <airlied@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Eric Dumazet <edumazet@google.com>, Florian Westphal <fw@strlen.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans de Goede <hansg@kernel.org>,
	Hans Verkuil <hverkuil@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Jaroslav Kysela <perex@perex.cz>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jiri Pirko <jiri@resnulli.us>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Johan Hovold <johan@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Julian Anastasov <ja@ssi.bg>, Leon Romanovsky <leon@kernel.org>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Matthew Sakai <msakai@redhat.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Maxime Ripard <mripard@kernel.org>,
	Michael Turquette <mturquette@baylibre.com>,
	Mike Rapoport <rppt@kernel.org>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Paolo Abeni <pabeni@redhat.com>, Ping-Ke Shih <pkshih@realtek.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sebastian Reichel <sre@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Simona Vetter <simona@ffwll.ch>, Simon Horman <horms@verge.net.au>,
	Stephen Boyd <sboyd@kernel.org>, Steve French <sfrench@samba.org>,
	Takashi Iwai <tiwai@suse.com>, Thomas Renninger <trenn@suse.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Tony Luck <tony.luck@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Vinod Koul <vkoul@kernel.org>, Will Deacon <will@kernel.org>,
	Yazen Ghannam <Yazen.Ghannam@amd.com>, cocci@inria.fr,
	amd-gfx@lists.freedesktop.org, dmaengine@vger.kernel.org,
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, intel-wired-lan@lists.osuosl.org,
	iommu@lists.linux.dev, linux-cifs@vger.kernel.org,
	linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-edac@vger.kernel.org, linux-gpio@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, linux-pm@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-rtc@vger.kernel.org,
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-sound@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, lvs-devel@vger.kernel.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	nouveau@lists.freedesktop.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH 00/36] treewide: remove conditional returns with no effect
Message-ID: <adcfc6f2-3309-4496-8331-1ae31e85d363@sirena.org.uk>
References: <20260723184538.3888637-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2ViMWcNJN7tv3iXJ"
Content-Disposition: inline
In-Reply-To: <20260723184538.3888637-1-ekffu200098@gmail.com>
X-Cookie: It's OKAY -- I'm an INTELLECTUAL, too.
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4A2541C000D
X-Stat-Signature: p6tixq5ifc7f7sewezcr5qigmp4mcp8k
X-HE-Tag: 1785154377-496911
X-HE-Meta: U2FsdGVkX18sEALACDva2YEvqpvhfO8CM3M2xlrS6aU2u1PBsmFZjinqCCtR5PPfrMGspxJNYr97EM9EHUlw4Zf5kUcuCjHtsac209K14ZfVLJ4PGGlvsyjxTeCDblWfrs5F5Z9HgyUHEQ/U1ABKP80Sz4MDVX1dNRJuHddeGqJHVr6N7z4zgVLpcorBGYSpv1jmiS4RVxQwPT3xfYKmPFh/0nL2sxyUOHh++bJW0Xe+tflfFfjmyNG3iHsWCbhn2TLJ0k04JUi1iQLZsq2vZTnTyQS4Z7mFkRqhWjWMfGhDtWdfj/SN1ClQlYlLJIQDKNxryAcHNydyeJTyD69TISZnCmc7qoQs3EHM+UldB4CcKDijudBK8xUmQzvnEzrMCoYFr8Rl49t5WzJuMeFfrYj0e2SSXDWGWh+LHmFL2+IjEFV1qLAujYcpyMA2uogG6wdcvy+94emolbtZuRV9DSdLJE0uHng3s5INrZClFqFot3c/wBROSAsDMmxV0tOiodK3WfH0yWJ0HJVkyCyIjmjkG4RyWFcG7dCHiRjCNf86gSMnYM3NJTl8QbacbsrcMsCpPsjaILVqPuQAT8S7NtCPinDd/fxkjSVWdnBfQ0VS4jTly+iPwUTavrntbBQbezk5VzZ41JlkYleJjHa7Z80Ta30pZ0ReWJpnXTjL5dSjp+NlnZJ9+64f6z7X0giEtxiMlD5L2R5POMqvqoB1MJF4zXEtwkPS4Uxx6x5Q48FVhxrrrsYrZCelB4B0pwJp01J5UDwT/tmwyX8OoHjBXg0qeQHFUxBY3zLO0qjbrDodcSveZOMo989+L9/H4/YVHl4WaA7xRfUcu3obSeIkZNnF91vHMA5rTZvyyUOSuWSFri1v8N3SPeVlrkyLPEJKXjuh4LSV3nc0bccNoSdZ0DXDDd8vvaR6fYyy1ClQi9+H3vzgfkBb44k5rU6dXiOUsyEgeqMItIGjpeBgboe
 2sW3HCh9
 l8oDrrWOp+2sbXs8HActa37wMGsyrM++dxP6I7wHBWRutc1pAVipwxa62FLgSgSeIvhvb2K2INlYxuRuKD5+ieJ4ZcAXQ787ffjD5Yqvz8w0GO8vtyZA+Q71FKRX6PORIWYsCFHrsJQQrrqUUcsayWVqrN6QUcRSZVn2rIS8iNJw/j/j/ktvpjSi7Wm8dfNvqCrMk+cctCqCkuQtbyv4dVphxnx/2SPdN6ZKoXoqY4zOazTKHcF5R5wHIl9KYFfzQZDgNjMPp862Am2L5nOaElUW3FXQnbs1NfXPm2pqm/HwfGBMvaLUkra2lFylMW7n60WJyFwrLl6KrWRMT+MdajxhKcX6OFjttXPT1rIooB6U6WVeF2XrAfwXj4UyEjxq56ZPG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--2ViMWcNJN7tv3iXJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 24, 2026 at 03:45:02AM +0900, Sang-Heon Jeon wrote:

> All patches are independent and can be applied separately, but for
> everyone's convenience, it would be nice if they were merged through
> a single tree.

Please don't do this, it does not make anything more convenient - it
results in huge CC lists and makes it more difficult to work out who
will actually apply things.  If there's no dependencies just send to
each subsystem independently.

--2ViMWcNJN7tv3iXJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpnSzQACgkQJNaLcl1U
h9DhKwf/RoCnDee69F9hZ06/HOdC8gDpovt8IjWRgC8X3EQmHZkTxcKWoky17APD
5D8K2eKoz+FEDKrtFChR3EfGX0AhpmXhKtwaUanH/Qm+clf4ZjOTiguGtDpB4EVm
bTQ0cWSCcNpHm4yfpRk8XJVw/leZO0YIsDDi9rHzgeKJVY5zWBXi6azVk3svE2Ut
E9u3jmn1vStzN8uV36mRJ2+hgzFQOVilP6XSNNxMrdu6GJXHk/T6ZUlANNAxGcbL
/fZLJuq1gzwgfEJevdiqJ+O9U3OQl0DV9ZELQBaghYKq6Lv3nMs3PFSromeerfgv
GqK0jSpzheWN4gsenCQKqgt3POQM+g==
=WTGT
-----END PGP SIGNATURE-----

--2ViMWcNJN7tv3iXJ--

