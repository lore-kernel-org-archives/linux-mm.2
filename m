Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A861C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 08:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30B6F8E0013; Thu, 28 Aug 2025 04:51:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 294918E0003; Thu, 28 Aug 2025 04:51:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 135E88E0013; Thu, 28 Aug 2025 04:51:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EEF788E0003
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:51:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7D14013A4D1
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:51:53 +0000 (UTC)
X-FDA: 83825548506.01.0C07D01
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id B1C99160010
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:51:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CxUz4OE7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756371111; a=rsa-sha256;
	cv=none;
	b=487QKWI1bQ2yRemt9PyIpmnKq1G5uVdUr5xI9I2qYXsy80F9R86x+mc8kLwpYcxXCdKFrL
	zYUgBQDONTTamzUdj5TyyixBeFt7EDkHqD1w2fu9/aasnfqRjxlB36kj1g5Js9aLFuYnr0
	nPPW2ZtfzJrKdB4ptINGjmjOO0sVU7E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CxUz4OE7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756371111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u9+15MIYdLwLGdT4lDkVvncldxBvMZ11QIQ7gA1wrYk=;
	b=j/T7p2fhlyjWfhJPLjpzVkOnvzH12SQj3nTPNQPFWkSFkMLNqkcsl6aopx+0P4q0V3ntXZ
	llKSoxtuLF6BlbnndgJeo8vuRT2oLAItYu4YnJ65MIOmmxbQcrqZOzXor5xnsmDlYjySzU
	LFPivQfACzzveOJ7IRaSqujxB/7gM5s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B56534366D;
	Thu, 28 Aug 2025 08:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA74C4CEEB;
	Thu, 28 Aug 2025 08:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756371110;
	bh=3YzdMt4Qw41h9On9I6WWC7I2bIUYtljay6e0dtrlQB0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CxUz4OE7D1NGKWLHEwzYtKgtTZECCDgFwxLLFeEJiE5hR7TF/HdMp0veLk2o6qfDv
	 KrmFmQeAKMvmoCGTsN2QEpErm2Z/n46G4CUgdan/vOqQ9+XQ8CHs5YjX+RarjPGWNt
	 4fgJOJt8RG0sXbgl0kwnayykHV1vIbocYp6VitOqSIqH+RSsoJuBA8wtGEelQ3uPo5
	 xCNZZZqIFBHNQnmi6rQHhugNHWi8N0tBMVwx+A651+DQ29n0lH/uQg909DvdKUppWS
	 TcZgiGOplL37u0h/PshdhvyJVU8d5z8Os53O2PwwUjdkj2x+Ik0u8cPM+8bvR7rx0x
	 zclGiA7ZwYXog==
Date: Thu, 28 Aug 2025 10:51:44 +0200
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
Message-ID: <aLAYoDyz8Xie4Dhb@finisterre.sirena.org.uk>
References: <20250815-pinctrl-gpio-pinfuncs-v5-0-955de9fd91db@linaro.org>
 <CACRpkdaDGmdhaik+1saRv7Ts4myQ+tg1aQqGU3xQyT7ma8dJFw@mail.gmail.com>
 <CAHp75VephepLq61HrVy=PX2oKUQd5NK2qS-vOC5h_NR65td3Uw@mail.gmail.com>
 <CACRpkda4soRCLF5=W=6R4wnwT3pjk743j022XfJxjTTQzuarAA@mail.gmail.com>
 <534ad082-08fa-42c0-9c24-f0c11af7d5b2@sirena.org.uk>
 <CAMRc=Mdn0_yPXyYq4sbvH4P9-h71vEc4arLPBfSk1PiEFaB7jQ@mail.gmail.com>
 <1804d9dc-8814-47d4-af88-c819c3f17bc0@sirena.org.uk>
 <CAMRc=MdKgqa+vjhHvD2+Tjw5NwBtFv-0aUivi5UuEQd+n4KxmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="CMe5mpL7NfxBkMEj"
Content-Disposition: inline
In-Reply-To: <CAMRc=MdKgqa+vjhHvD2+Tjw5NwBtFv-0aUivi5UuEQd+n4KxmA@mail.gmail.com>
X-Cookie: Filmed before a live audience.
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: B1C99160010
X-Stat-Signature: wijp4iimwnsmt3m7oqrdyc6bbinfjwsz
X-HE-Tag: 1756371111-693945
X-HE-Meta: U2FsdGVkX19GXKJxrd0FFBcVTlpi7xFJbRZglge1XdhLy7TzqflntRsx8Xn69KLf8W1O8Rso685MJp1Me3Hi4kFK8GAuwP5lnFSC+TwjuLBvR8wRCZqrvLoIM/MWVtf4GWw/Za3nekG3/G2ldNxIPegHug/ypqoBhNPly564Y3suDhlmR6TM/b12AupgoHfzUGQiP6iljx7M9JTu0eHZ2jtDtaQ88flnS95/pL61owbaNbyqez99L4klTrPova45oFA+5iIEwMlItCeMNBAmM4aTlgSxum7cjHaZhgTls4w6ue8wQZMwdZW3YcvIpjPpI4BWaprvLzmdigvyU+yvIiPPpNq4nWM+yvrM2zDQYOBzK+FfbnNBnZlNA76H/ehvOFyx6PcbigF9+V1VbsJ+yH5wLJRPxc2efRHKftf3ioQY8iahRc3Lj9gf7HRXbEpXYUvECy8IwBrcfchMlDSgg53zqraaakBXkh09ASFRQH1t01SOu+ILnnpAQTL26Z+5bs9khnx3XjgjtAk3OomjI2/XI8IWIhNwVEadKx+D56Fs/wsCeTLG/HcHkrNQNH8Y8oPkQ662maH/ve3kb09EVezeMVzz3AymzUY6l+0BQv9zKvaZB55lPeCNGKpEvBlsjyW4GfBZqC4EYOFXLmMZNgMebP4MpAIWIKj/9m/xmHbteq/KlHsRH//Esw56Vx4tT5q6d+k5Gsy7zlTeHeWRJojOvse/gGFnBHXeHM7zjLHkPGzVAqHs6kwdEh+Faf1Uq+543KsTO8Ehk3yymCiRgN6W77B2SwJrIZpc0TpPoDnVGpn38g9sGvQ2GUot94h0JWEDFMiyQ4ZRpRz6Y0jzhIejrIS83qRBYi07wR/sREeVu6rtq89tv4E2vx0XJEte2f9hYkad1wB2TySMFwp5GRWraUn423n5xPwx9YlxMaR1kmlBWHnhr7pBbmD9AcvUJ1wz/LQh5llRoHcBeRo
 YMWfg0Xu
 V96rSqEJt8d2o5iRE6G0IncSrGrZ4Ofnq4QFdSry/UsquMRssRbF/vHXEkf/EE3LEBuZSA33a3Avx6nwQpuj7tmuMLI3HUoCZF+Ew3owPrFVhuNhkLtHK1UOY7imFbSuGJ3mCDmanfpYAEuJ771alNNp9TM8ZmJ0hrRrJw8ESIGYonjXkudTfFkNFgXwYkSnUSIdQkT9Q0y5IOoZ1sMY2Rf8pU2IbsNuyPE32Fy8xniLRi8W68FhOblSco0Ef5ZOxf+WbxtiRhoSMbPAqgqwurRFs0uq481b3hGHUtht8cQVRPpdPSche1YOlg7ob7/uMXliHv6VlgGYuf6B9MgbQrDzQ5DaGoAC/OnImz48AF+hYm0wT2mQGAajSgMMosrsxD0cbqm01VeBvUuHhszpl8lP7YiVZ2pdhU/lv9F1imhLqRaQG9k8nVMw4Jt6h34scOOBHtz/SF5AZXzOmnS9STB4K3uAjMfHoJjmf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--CMe5mpL7NfxBkMEj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 27, 2025 at 06:46:28PM +0200, Bartosz Golaszewski wrote:
> On Wed, Aug 27, 2025 at 12:22=E2=80=AFPM Mark Brown <broonie@kernel.org> =
wrote:

> > I've just got the log I linked above.

> So, I've been looking at this bisect email and clicking the links to
> LAVA jobs and I can't find anything. Does it fail to build? Fail at
> run-time? I'm not sure how to read this.

It's failing prior to putting any output on the console.  I was also
seeing an issue on i.MX6 so it might be all i.MX boards, same issue:

   https://lava.sirena.org.uk/scheduler/job/1697667

so it's possibly all the i.MX platforms failing.

--CMe5mpL7NfxBkMEj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmiwGJ8ACgkQJNaLcl1U
h9Dgwgf/cCYgHVux4WcIOpHZVKvbhmDSDtzns435zt8WkkHs0HTefX6c8qkduloE
AKCQvlOXq4w9mLYUJB73eu5lR2UZ9F/crY4Skm4QKJSl7xbmcTrUKkDh4anAgPCr
TzCuAz0wBXpZDV6rbgGsv50bHpga2TkeYe4ILfO9i5WsXq884j6qH3q37x3LK9nk
lbgltpZaBfzXdFk8ofMDg7QZQI/JDl0cR+6rsMZ60fSoehdmCHlO3Yk1ce8K2PMt
jeC24eNQXFrAPZojnEdcSiHf7+AGirU7we0+4EPcomJRcfJDrf5lr4Mj/c5ofgNV
ElALxe39ERW5FGeRn5q9m5nQ+3/dMQ==
=cP5U
-----END PGP SIGNATURE-----

--CMe5mpL7NfxBkMEj--

