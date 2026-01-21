Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88F0AC44507
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 11:17:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CA7D6B0005; Wed, 21 Jan 2026 06:17:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7781A6B0088; Wed, 21 Jan 2026 06:17:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 684036B0089; Wed, 21 Jan 2026 06:17:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 544FF6B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 06:17:30 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D41758CCC3
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:17:29 +0000 (UTC)
X-FDA: 84355720218.24.DA35CC9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 68C311C0004
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:17:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UWVtuXyF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768994248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZyifTjkinWiyaCdMcJeuJbbtEVf4QvaXRWBHeX9RfF4=;
	b=lqoWGUWX0wKW6nkQc3ItsZY7odbgZ1NceMudpDHGVoFlg27TWucQSwfNguzNVDB99A87Ow
	XGJxpho6Df+r70ywk5aHnNvBOf6dRJiLv8q/4xbsTzzBN2McpeyJ7KJkJylpl4Ruu4cUDu
	Cm4ofdbiYJL7i36HlK2yJQpO3i+ayys=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768994248; a=rsa-sha256;
	cv=none;
	b=t1LiLnzzC+UnBceN2CZi1zF8Um6QugdGoqcYxji4K9p/+FhaZZAdIWx9cwTdjvogsTtSIZ
	cFm5mSRLlNYNFV5odmSwB5LnxRx1TTNywU1p6HyTYPrFHk+WGJ373Lcf4iodIZhrwkYxnV
	XKd89WTAvrBoNplrT5dTa+m/Z5pMu1Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UWVtuXyF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8AADD60097;
	Wed, 21 Jan 2026 11:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A15C19422;
	Wed, 21 Jan 2026 11:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768994247;
	bh=UVjrrOUybRdchUO2zQhNsUuDB0kG8y8GNSns/te8tYQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UWVtuXyFklhh7/NH3E8DzkzMHmZPwkjCHWg7xvjvaGo0n/urnbzps3c9ASpFhOAV5
	 2S2nAa54eg5FnuTiNG5oEmMqYAiBUw1oGvIe8GxQtbM0iyORtFQGfySEZQB6aqAEpa
	 5fTJN2dKrA+qFg7JVnSRYaJEQcfDPPP8tvzpC9hNTzipRbYS+gViUCpOB+NLQo2CUC
	 pUGdh3MZsp7ZSsV9lXB8sLBIUoRJZG49qTbqTBgCm7i8LAEcTaZYingWXEXsIJUic7
	 LPnUQbnk0+Jdi3AvnO3CxgTyTxb1/NlhFn9c7ll4bb+p9tlRF5gKRV18oVfIej8I4F
	 9ntNeFqZ4FnAg==
Date: Wed, 21 Jan 2026 11:17:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: akpm@linux-foundation.org, shuah@kernel.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	nao.horiguchi@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 1/3] selftests/mm: add memory failure anonymous page
 test
Message-ID: <857ec09e-deac-4d70-af6c-5f89ba0b9798@sirena.org.uk>
References: <20260120123239.909882-1-linmiaohe@huawei.com>
 <20260120123239.909882-2-linmiaohe@huawei.com>
 <737310eb-05e5-4234-af67-9118b3f395ab@sirena.org.uk>
 <f1cb6029-9140-3784-5b44-ff58b4edde2c@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ntNwiMA8Q5N3tkRg"
Content-Disposition: inline
In-Reply-To: <f1cb6029-9140-3784-5b44-ff58b4edde2c@huawei.com>
X-Cookie: Eschew obfuscation.
X-Stat-Signature: ruoesqexba4ef9y56arkqkwzwqhw98ip
X-Rspamd-Queue-Id: 68C311C0004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1768994248-369617
X-HE-Meta: U2FsdGVkX1/nxEDypVGRVT6E1xIK+YGni6tv5Ktx1HU/xx/a4OjS1eXMSuACp2LVRyNEygUNhLI7dHvl5gqH1hdb3gNZom9vP8jZWaJO8kH23mxrBjR9LTAUg7XPEBaCAoU4/wkR07AHwYyni9sRwR+GGTcifPrfUaS4ZkgELpiNUQHbdB5LvzHcJrn60LAA6c/rsVG2F5JScASL7emKCkHqnngbj3pGypogR7cQWfAhsjz0mRVPNXAFt3nDaZPB6m0w0tPBSAG48G24x4TAiGE1/D3HiclZLN7fhnKlQHjvJz4mPUEB36DMO9Gio22jwAxTzjRUYkPb1HJOXVE2EW8zEPvRDS0SpdabM32wA5wwGZ2xf3H6yYzbkYWzf9fZgG8TdGHe7zcxZ+YhauvwPQN3lorFCSWjzfW0i87j3ExrINF6C9dIih1eSKdG5IX6Z4EIVIsLKRMvbXaMPDxFahPo2XmnNzXaCPhnVhJBVhOLhf6FLONKglnqCiq02gCOsyw9hF86MAO2Xsg3cM1iJeb4VIjL8eldZ+05leGY2A8QTuEaBtCCY5wvdAlNc+/+YxKyvcvdycnL7Rz+TAhPAKZODblfdhUD0XHq1/0AOME0cfX4xw+D8tpghIJFr7QT1L5Z0kMBxeJCi9KWt1GRn6kxDp0UMkl8UTfTgnqgldvT0WStcdXrrKioanRa1cBKpq9sKWdABrUNP6ZOlbjcds60ZvSbJeiAJ49o9U3SoBk1cY9APgnRYaB6t+mq7F1VdZ9MfvQTe4mzQzZV0IN5w5IPacVnQ33RYB0IwQdqY68Z0+WLAEZKxesN+UMnpfL8I11kxvSay7ecm1ig1PzVmsAiErkuDwjHj4EZ9+i9OZTfFMEOLnccfoHjbIOhmYZ2l4T/6I68SpvEnfuiKuW2SGwIYu3X8aDrBEsgoCncRYkdrtfN+zeEgMmQYUOFRpIli2SuZVShia/HyHplH4G
 WtZ+olY2
 h/dj1MoBN/IFg0OReQMpXHI7a5pBfE0/EB9hftLsN4mzU7nVK4OJmleENMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--ntNwiMA8Q5N3tkRg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 21, 2026 at 10:05:07AM +0800, Miaohe Lin wrote:
> On 2026/1/21 1:46, Mark Brown wrote:

> > You should also add HWPOISION_INJECT and likely also MEMORY_FAILURE
> > (which it depends on) to the config fragment in

> >    tools/testing/selftests/mm/config

> Currently if HWPOISION_INJECT or MEMORY_FAILURE isn't enabled, the test
> will be skipped.

Yes, it handles them being missing correctly - it's just about letting
people know what they need to enable so the tests get run.

--ntNwiMA8Q5N3tkRg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlwtcEACgkQJNaLcl1U
h9ALEAf9HyGTBdDStODta1E5/aFHzVxupOBCCR+llLW72boxsbuj52j1RUdv4DRJ
Yd6UuvWvt9OT0hsfHtT+HX3HJOPNRBk2Stmos6qs5js3NBCA/Yi5dHPdaOK1pRwt
sokzcj9kQtgX4piNhwnQ7CWI3V3vNvKf3kpuxI55MUsTN3pwNA6GIFLUDW0qktbR
2bCNHG5CTyUX4arR4y55v1Wem+5p0GbZXyHrlkfOuVvt2+7DiyHnoBPpQ/nRxV4G
X8ISnvlBIZLOYcFT0nyoZY69SyzAbAEhzfIDB82oxDHr3MHesVRuRl8WV+hTTJ9V
Qv3LP3X9K/eVooLQAbsJurpnEcHUBg==
=VjLu
-----END PGP SIGNATURE-----

--ntNwiMA8Q5N3tkRg--

