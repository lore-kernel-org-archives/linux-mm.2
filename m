Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB8A3CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 11:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 480CD8E0009; Wed,  3 Sep 2025 07:07:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 457F88E0001; Wed,  3 Sep 2025 07:07:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36E328E0009; Wed,  3 Sep 2025 07:07:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 240188E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:07:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E3DB159FB9
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:07:09 +0000 (UTC)
X-FDA: 83847662178.22.06B9156
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1BB2BC0009
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:07:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="X8WNaEN/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756897628; a=rsa-sha256;
	cv=none;
	b=ft+fMqVlL8kRiDuEyEsjS8Uq4F97/QrZFFO55rpp3tEk8x9mvW0vAmiDU1CEuV8XxQ8SVS
	4VH+Nxlgbh1RxwH2M3BmpMZzNbE/9qzTU4WSiLY5gxB2k/2CoWHDDX/rQlNEgSAke/X1HU
	GIQOFJD3QzKk8lQZ4sd3w0/9eRqfCak=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="X8WNaEN/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756897628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BZXz+xk759zPv/VLZPRnNX9kRrlEZgEOWXXiOzKQHdU=;
	b=OtoIT2b+2xchqdYSaYJ8zwM/CmqUWLIXHjh78KcKtXZtdxqAcv+/oDv5iTiCmGF6O+YnDE
	Yx24cmHtnXG/I1mTHd5aIH/hWkwvx9TUgxGIqv6EB8Z3fhr50q4A4Kd8roz0ipUlnCTw6M
	vyq8Jji7tDJMEvphdYq10rBDhm1I2KM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 09A04444B8;
	Wed,  3 Sep 2025 11:07:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F797C4CEF0;
	Wed,  3 Sep 2025 11:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756897626;
	bh=virt440YX1VkOxJaTmEr80xjwMryJlZsQui9kt/izTs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X8WNaEN/VwOhZmnWe6N6MP7x5vfstlLdgDw2eZrZCeb3sK1BIcrWgrADCpGviGRw8
	 9eXvp6RGfYqzwQ3VPiDQd1B0QvXzi2heoZ6QyApM39eJFhuewyi6wxiMUciaaG9Gtl
	 ySaWqYLyotZFWePjR8RceMk+5F4IfB4wX7CeIOfoFScC9w4l8RLBt534eUcMHkCOt7
	 DX47DcrOhsixkweNukJ8QvVSuquvQ0MAr/z2JRSSosFemG4LpXfRE/5tOgHWF6DyYM
	 +s7K/ZK1BTWNET730nOALste8EyPz7s8CKPbsVudE05b7jj44zK/1ERrqX5vQoyh+C
	 V1+KewudYEZXA==
Date: Wed, 3 Sep 2025 12:06:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
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
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v7 16/16] pinctrl: qcom: make the pinmuxing strict
Message-ID: <8a54bbbd-2b7a-482f-9ab5-eac83264b1f6@sirena.org.uk>
References: <20250902-pinctrl-gpio-pinfuncs-v7-16-bb091daedc52@linaro.org>
 <aLcBcjvMbrxoDYoC@smile.fi.intel.com>
 <CAMRc=MfcFMgkNqWNZV5o0NxkAvxBTjC3vv56Cr98n0R2CkxuPw@mail.gmail.com>
 <CAHp75VcgaqnDrPH27wxfgyK6zz4RAKJQB0r7G2vbTONTxkEzTw@mail.gmail.com>
 <CAMRc=MfhhX2NJ0fhhX8u+7=sdyUy0G27n7caGf9=TpHxUDJVxg@mail.gmail.com>
 <aLgW7J-j4nn0u8uo@smile.fi.intel.com>
 <CAMRc=MdA21fwnamymG6YhqBjKDso_nJs_4xefPNONQNfEcPHXA@mail.gmail.com>
 <aLgaoivmBUgoeO6B@smile.fi.intel.com>
 <CAMRc=Me84OX=UEmAXxmwE8oOH=1UBsyHe-7XmU0c8a2gG9JnCA@mail.gmail.com>
 <aLgeDNLABpmkShIU@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/BwkSBKy/i3w/XmA"
Content-Disposition: inline
In-Reply-To: <aLgeDNLABpmkShIU@smile.fi.intel.com>
X-Cookie: You were s'posed to laugh!
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 1BB2BC0009
X-Stat-Signature: nqwac1d7ktprbm9cp6uxyf1eiqfjwr6i
X-HE-Tag: 1756897627-169141
X-HE-Meta: U2FsdGVkX19jGT8ryVom9oQXi3O0fNQ7twbFDYqVikSIm9OTJ9mQ1hzA3TK9yK9JNap7iXdCMayAdgZi4PF0VChNe6AVnRCP6uInh/VeiHAv2SFsBVzYxtWxFIuGarrOx6+AsF++IiejKOLqjvv4LFxN6GggZhxbsvI5Vl5pFpDMPsYb8qP1JjkCCX1Bk7UxRo125QuJpuXmwNqtNO1U659uVs6M+DyMyBCkecra05JjL+tXJTjW1FdHSGHh3WhfyCZi/yuJWcfPhSPiAFyEPpz8kXN17ZeX5XSeqNVeXeOuepGr550ar9NjFMQCxJSTbXFKhyHh+tsJGDYl5YtEB57Po3G7IwxLHApoSsNQcKmU1DliGxWoAM4wVDUVX7CQNaLGYpD64uy602Ahud7dnMigJIF3B/TclSlsJyfo76rl67h28/+yggwCN3tvPzR26bHYYw5wiu3NhGa0GrJqJz9Vx5n4KvNn88YUF37G4vbzgfp2y1/FZ/HZlb6zillMtsiJJj1Uki29F6im9GyY+rX6P9fZFysbe5Gbh4BI6GyxqI/9ak6YDUVjHL9h48xGTexvOTAfKYTLIhmIBdZtkQfzk2685c/EjK1uz8a4dNfaaTY2jJ5Nxq/Shtt1yA7pZeicH6jaX5fSycy6348opKDCFSzEcMmiaixf71fJfLPuedOKWATB8bg9jp1wuhcxjGmzQcoMUwH84zPyFBxlyrlmGt6Tcszc2R7BbbzvX395NcGCT4pdiB8wLHKUBpJqwUdHEWQSj6nQQTrICysN4xVJ8PYBldeV7hwlGkZfjrLPME+jRagj/FchEd0SfGNM4X0RHEOc2lwzjPASC6kOEluImCzdQuPAmpShtPI+xHHJnZG4DBH5ya4L7fvVGg6IljmkMcnooBM/OuMPZFP9wqAo4tlUB+yZngJpkcrorEeDoFmyWCDx4l2UQgTkzt04Iy5YVWBrD6bUOrwy7+9
 MauKFut+
 X0RaiRmf1VLHoS7Xc+ioVE5g6gARCK/D2QShBp0sv1HSfFKKCovpnN83YFHKYUAHCiDyV6t3oM3IU33vY1utI+9WnmBfaiAvdbr6o7/R7iL5zvIyPGBNnoxwOPjSLKjC7rB8jrc5qJd6OKjGa8nmlPSeEra3ytKYKDk0Woeza6cHriEjeJJumQBbCBUTD8D2bXxAbnrZk9MlBbC+UZzQgqU1AzXGE51aovZPO+oLfhIwL2n79CpUJA5sdPolxxzrbcsOU3Jc9FGcVi9G1qjQeyTUhxIBFiGfAz13ewM/VE5uYNMGN9w6Dg+Wg8hELeA/O12NZ2BCEIX3E5nCtZX4dhReNnsx1rMdmZSDscwIGcxcmHTBrGmndvEs6STAI6r95xP69MLaLtoWoEwGP4+zIkdDJIUZV9h+F+cX8hlO3qkbprhA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--/BwkSBKy/i3w/XmA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 03, 2025 at 01:53:00PM +0300, Andy Shevchenko wrote:

> (Not sure, but SPI DesignWare requires programming SPI native chip selects even
>  if the GPIO is used for that, this might have also some implications, but here
>  it's for real 'purely speculative'.)

It is very common for SPI controllers to absolutely require setting a
chip select in order to do a transfer, when using GPIO chip selects with
such controllers the standard practice is to just not mux out the chip
select signal from the controller and do everything in software.  The IP
will be doing it's thing with it's chip select signal but that signal is
never actually connected to anything.

--/BwkSBKy/i3w/XmA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmi4IU4ACgkQJNaLcl1U
h9AQfAf/cIyTMUWIKvnzF/bbQpaevTEUa1OBu/7ZBFg8nC5nbLhvhVdYli97003E
aKUauEzD22LQFP4msSIUEmLifRDXBb4pRIP4hVwWteB+GakiyOdtVyAxV7uySCKT
95KpISbIE8ooH7RkAXe8N1iYnqwy9VRmdjYa2FdzpLuCPCawD0+YiYWzPPLLVtgA
quzmvAfna367i9/zeuRw6JPL7bZOm3lq0EAs4Y/xEDQVXW2aVcW5K8mzJqoBJot+
gjs2B5fH1gVJxjLMx5QO/i7tktneqkpdo3YQhL8m9VKl7/DAuBacjsHoBN7exY4u
23ENTRMf7dNs8GE3wrhuLAFBjmihdw==
=ZPrJ
-----END PGP SIGNATURE-----

--/BwkSBKy/i3w/XmA--

