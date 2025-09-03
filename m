Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94A0DCA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 12:07:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECC9D8E0011; Wed,  3 Sep 2025 08:07:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2EAD8E0001; Wed,  3 Sep 2025 08:07:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF67F8E0011; Wed,  3 Sep 2025 08:07:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B26388E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:07:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 471DA14061F
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:07:47 +0000 (UTC)
X-FDA: 83847814974.02.E54325D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id A3B36100005
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:07:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ixEbLi2A;
	spf=pass (imf14.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756901265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m1Ang/Ev5msbe29qUOK0afUPlJKTCWi4jjZ05SuuqY8=;
	b=OvTEkbvyKnYR4bC6Apt1qc4o3fIkHdn8vegj/OhpU17WzEJf/r/zLShj8HvqG+ySR9U0gR
	7LqEmKBKQDltZKvi4s1MxoGWqd5O5pM4pEwXO9Z/Fc5AsD/GHxPkcwrIYprda0ZkCpKiC/
	hTXH59h+aSlWsnFadkG98w5UlyTw8DM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756901265; a=rsa-sha256;
	cv=none;
	b=EXwEuAwK+wmV7ovOV5rSlp7teb+FSEB9htYsZLJPhenY2RH1Qrml++AQcG+cn8xgHmizb4
	WiCtOqerSxBgrDRgBCg8+LnA3P5isFcdeIrnzlURuISRVmJ3ib4HZya99HQMa2W/r7iEug
	/m3tLGudmSGS5N+Oe9Y3liYZBsfKhcA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ixEbLi2A;
	spf=pass (imf14.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D0CB16025A;
	Wed,  3 Sep 2025 12:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5248CC4CEF0;
	Wed,  3 Sep 2025 12:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756901264;
	bh=m1Ang/Ev5msbe29qUOK0afUPlJKTCWi4jjZ05SuuqY8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ixEbLi2A6jjg3LDOMR+jiLI0kr10I8xn9VvAhh0P7/z4DH0i1kyknq5gSkeU0VCh5
	 i7tl5kkxInZ+7hYu+tRelEpYAuP8FN2uFIlm5P42FO3SelGzylxnLKF/pNSR2m1aFw
	 RE/5Os5QrL3UByY4KoMftxBxXI8nABa43VeNvttCKTwJnSRMLLSkAAqu3VLPfLy7vD
	 AeMa8NriBmA/D6erdbbe4fr51rNUQY9oaQtg+HQjcR31u8e8fIRtxBTyJgVpc39MZw
	 KS0+rKXi8YwhnPg5XMTY+J7MPSqIPKFVJNPfLuAXIVPCyL2HDJsMj/a8wFJkAKiMQ+
	 b2BQwIrvDUtwA==
Date: Wed, 3 Sep 2025 13:07:33 +0100
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
Subject: Re: [PATCH v7 07/16] pinctrl: imx: don't access the pin function
 radix tree directly
Message-ID: <bfb9a2f0-92b4-4f68-ba54-2c01e93eee97@sirena.org.uk>
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <20250902-pinctrl-gpio-pinfuncs-v7-7-bb091daedc52@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="LMkJw+F2UT+cDaFZ"
Content-Disposition: inline
In-Reply-To: <20250902-pinctrl-gpio-pinfuncs-v7-7-bb091daedc52@linaro.org>
X-Cookie: You were s'posed to laugh!
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A3B36100005
X-Stat-Signature: nss1qk5gbamht11i3xwqfjfkjrdkmw9c
X-HE-Tag: 1756901265-955611
X-HE-Meta: U2FsdGVkX1+la+vXr+CM4ylPSu/+p957xxVyyenEc1vK1jbunmOkUloun64+Wzwy5ylwzqZbZo4EIjg4jIvKNMcoGJTLfryry8YwHLqMQrO6vtycsvompoMInQmKA8/GQpfim5HoajnKDTGOW7z9YycXN793uJoYu2FqMSydu1wh2dxJc877UJMhKZl1NxXQheg1P1AosKAbUYr2juzmnU1NC8wOiccga5M3j5Llhx2woP23+nX1enGmpzGrZV+wpf177ZexXp0Oh6P2xivtFT4nLYibvNC9sE1gGUvM9KtdX72Sa17W2bxACMTjcSfImGQGSrzXC+BYvcweN1w7ZTlo21NT1Pe0c17RHhQUGnC+jtSrhaPy4M47IQIEmJUu/Kbk3DatRH4bUH6tffCwxgt6apn7YbwW4qQmeecDwXfcs2Fd8DBLTtScKK8VTQHs3rofaf0ZmC7CsFrG6VKb6/LHuG4y2CS4nM7fClIiqHPAZC92EC8NbAit5odvtgleTS3SeseXuCBzTQ/kLG/Pjhzv8sk3hqTNUXY+tvXi70oF8t8pEnkunxkYB/nVpDoyc5tznSmkl5+uGMy3DDfEQSO/HiusoBorQiiMJwuLNNopHoxWczCq3ZYQk+wN3HS5fE44zDcJuXsY814W/QXw4o6qQt5eCCjCMeHLetaiL7nSNl0DUbbz1QjaiiQ9rHoTnEdsrZ5N62b8NiLCaxKzDCEc0uLDBv3bW6Yqzt+unGw/KGfK+JCiHSE1dtJKAjIzLuzGSKzSr6W3xhv2EKbNkdC+/3iZrmkG3QeuZOCUmbTCDVVPzsRyIF7coQLXw7rS9iQuO3JIo1ZDTgskwbGinzJPA/t7EEwxtQcLPwWziQ1h5rttvP5L+AiJ8GJfJ7sJLUP/xefl1l6kCCaKc4JMXu8mm8BTZSNmYMqVhzuTiH5sd0dr6pQkIvT7tSHfB8b4WMfqnR/CV43tMczlV1x
 1k2Qtq8b
 S0yuVDVsPwDNRwsv0n+YD7F/bPPkPNpbyxOIJ+FwQyYOvFmiMQD+HAZI1ZR3KTXC8+2D5lmbXV9I7G7suaM9Y3lG7MvJu5REGCL/lqltxrUtY4SwjsKtEiajUBez7UIeW84T15rGOt/ROrGp3vy2CMxFkkffkbgsmNqPYhBlWHEsBDPvP783H+qNssTpuJOwuj0ajTyDWXxMtT/y+lfXP5sFsIc1kRC8BGbeK8Jbl18u42zztVjf4SN0o6wAe8C99q6HxqAo+gdbyQBMtn58DQlPfjQd/CuYWGV0PsZtIfhhpnIXiYDxe186GBbLvTXZKUxbYKC4Uoy6VSX+ST/SU7TCpVLV0SZgOeBGFH08eZlvHaLogxEESvgiBBMnFs+46X9RRTs6ao/7rTN4JojEIZ12VdVSTMwq7kS/Us2izVb8gYfA0W4WnBAo+hDloE8q5sAerZEMTn7AonSnejH8IeYnymxTsCaVeL9LS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--LMkJw+F2UT+cDaFZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 02, 2025 at 01:59:16PM +0200, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>=20
> The radix tree containing pin function descriptors should not be
> accessed directly by drivers. There are dedicated functions for it. I
> suppose this driver does it so that the memory containing the function
> description is not duplicated but we're going to address that shortly so
> convert it to using generic pinctrl APIs.

Tested-by: Mark Brown <broonie@kernel.org>

--LMkJw+F2UT+cDaFZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmi4L4QACgkQJNaLcl1U
h9Cofgf+Nx2+OT+tp4D5FUxhtTOmhW7sSoV0qG4ncMEPM9CqTpXL04wbbzyJxjJi
x44Lzl7dhYejlq1ljZcrLRtyyOEx2GJmVq+XHynLGl0+WRR2yx5BIF/VZUKrpjdp
Rd7Wd/4PDIWu+9AdKJ05UjqdXCojpVhxUDMFoha24910w0dlC3/GOS+5CLd3t5nP
o8DekdJ0fH6kx1PD4bw8qgA54bkwX/A1xWWTNxpAg/4zlmNuqFrT48Nuyz9AxY7W
KRh+JFWffC6f3gBQeYYoJOJsaSojIuYpDVDTTwkkrtr0ZmxbYGan3Gfw+uDC2O8W
SI38WHTPgNA+BpMaBE3K/SB/spudUA==
=Wljw
-----END PGP SIGNATURE-----

--LMkJw+F2UT+cDaFZ--

