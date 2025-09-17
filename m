Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAFFDCAC599
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 15:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 544298E0039; Wed, 17 Sep 2025 11:23:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51A8A8E0003; Wed, 17 Sep 2025 11:23:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 430778E0039; Wed, 17 Sep 2025 11:23:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 31FB78E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:23:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CFE8859BED
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:23:45 +0000 (UTC)
X-FDA: 83899112010.25.FDEDDA1
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2C62E1C000F
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:23:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Ng+nOdOv;
	spf=pass (imf20.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758122624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ISiQrcVdWLeRJhsxH1iqkkyhKFxhbNjQMJSoqqRl0Qw=;
	b=6M45Ztv8VB6ak55decAjSAobtQqob/yfYcoCsDA62drQpzRUQHCtqPW90BUz/NQKybpiNS
	Y+rtMAQVUR0iqUSA39dbNbC6UFEWoOuuCBMOWYA7uZUuLUozyVVmHigb1l1Y/zAGjV+CMC
	hmshli+6OfGrBYclfyhgw07MjvqjMaA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Ng+nOdOv;
	spf=pass (imf20.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758122624; a=rsa-sha256;
	cv=none;
	b=2KQM78eOi60t07J5l4OJHGVyZuzOKAGSOtvKv8rVgcqkg5zX2Vx6JBdXH374+Huxsy07NN
	8OSuRq1yvBEBTAMP3dBTQGgnQ36HWJFOM3nYnCFju2MR/QSQ4j9us5hPrWnQCuTWwaA4qA
	YAuZPxrXdr9+FQ5RlYhfzFF4TsLflBo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ISiQrcVdWLeRJhsxH1iqkkyhKFxhbNjQMJSoqqRl0Qw=; b=Ng+nOdOvgJJASAaP4YgZLM/a66
	Je3VLwcz1rtLpZXJ117EJswsQcpcsnV4XcrcKn7KlZhPQIo00nUxQDHUuutrZzbmtu6/XNGOl95fn
	y6DY+QcliaAW2+5RO7r4vWydfIk/ie78ohPllI3iE3OmzQSxz8R33OgfgDA5kzgub4c+Guirat1Xf
	rCoo7Dpau0+SO2YcTTd2UK/YIuJJp08TQWT3h3tzs0TyJDVx7PbVz8miYLq73Ajd3ha/Cx+7W7V9X
	OPLiNSIAwbLLZqdVbYJmrxkcZTc+s0z7y9D2kD8/lIW34uoFVrM6cqwFSPEkJ8U6vehJ7gnIiw0Uj
	7I36BhRg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1uytz5-000000001B6-1fYM;
	Wed, 17 Sep 2025 11:22:15 -0400
Message-ID: <1c799faa2a1b6d79080f4ad378b5a1d583813c2f.camel@surriel.com>
Subject: Re: [RFC PATCH 11/12] mm/cma: rebalance CMA when changing
 cma_first_limit
From: Rik van Riel <riel@surriel.com>
To: Frank van der Linden <fvdl@google.com>, akpm@linux-foundation.org, 
	muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, david@redhat.com, roman.gushchin@linux.dev
Date: Wed, 17 Sep 2025 11:22:15 -0400
In-Reply-To: <20250915195153.462039-12-fvdl@google.com>
References: <20250915195153.462039-1-fvdl@google.com>
	 <20250915195153.462039-12-fvdl@google.com>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2C62E1C000F
X-Stat-Signature: t144ooj18kb418e1tjk4pcp549sx3197
X-HE-Tag: 1758122623-891428
X-HE-Meta: U2FsdGVkX18gSaC1H/2xv7qr0I6BvTlz8g6fQZgykZ8jQbs0iTtpm6MlC0qpvl4lPn1o39Pyn/396b/D4fEF4NJYOR1Rn+TbBQ1kVfjF+PYLzP0QWmf/EMhCSgzYdXotDoIwTz+wQ769aO87czq31kDEMHYQP/BKEOcbDAzhn7TRiyBheCjmOAOO48Nd5k4iJlhpwn8/hXy7S6PmR5OezWS4CY6bV0URQbEnXuZqEVSJPGx9mFA5N2FNDhXtHUZGRGVVsBf5qOE3CSjqn/3qJFF/TlglStoSxJUb51bwANvJh60p2nsON5SdyLpxNFy5X5t2epPApdDnlBYg3rBXLyaugQ3b1NaAlAVyNiccLET1JXmsq98zPap5OCuO7Aaenz29APYG8zNcwzWN/ovOQmc5BzG49fyfYrsKwLbAu9svtdYoDLtV4oVsHQpirK0aI+FHWDuSjAglpYE3DHf1iFhtBofJXwwZRmRbH544OvurOOEP9d57Ngm2C01O/cUPr/GAv7Cgg0Wjae5Fysnx3aJJ8+W3eHHj93L8qqqmm5xWTKfLz6na+hXEhm8nBOyK+S5JmHpsdpcj0UDj3hSW8nXAAhigRH4erQ6Xa2DCv88lwRTWY/6F8LWjaSVAYJjRTjCmqKAe33Eb43hNEOlNnVuNNzhvTFU/DZCtIKrXg1KvKli9SsCE4UVwOnRr4XVIuNNATjPPCIL2UZqJcYMZ+BTQSZBAUjVUxplPMuHzluCkw9dPgfKWZWlLDaOqCuST0BtcyabgudmsuBfezWPvDCdjtK252DRk5WpVMI0KgGm4vVk50sumf3Uq50A58rCThWn4cOMOiBiuDYt2B0FYNawfGp+mqNvOZs85k2+TLxbu6McjVPBjhTSyAdQFru/to1D86eNh2neLihVMAhXCkW+jAUdPJlMQIhxyyisvqaWGLtqBkLKcJdTz/XJvCSkgGfGFyVfONMYPSJY/0ju
 o/Yykyd3
 jNqNpmw9/x0eAzoUhNDWyfHLzke2pZyd29rMXXp/Qp3V8ndEkn5kVgh7XFPaBtiILMex3AmjaVEm61kxOgJaZUJ7RM+hOC2ienuXWs+vpVRcUxtXgcvKiRWKt6hSFftM+vGA4NghyPdVn2Wur8pLbfFx16O97XbqPL12kJcno2ocXtIOOyv8l0wbGF9JiwqRomWUIQNJ5xsr9aP4kOvN8uV+whs+mSVoSjjmOJrAYDxAfbxvGAArPGC3F/ly3cQgveGn8oSUVVmWFCd4lF1N91KHdYs/twDXIfcY88EE+WHKKanm3PqB39cZ/CfSm6Y5tFFDZmMffHnn0ykTKkquoumukWBynyyeYtQuHQcVgw4oDgP37mXnWXkVDZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2025-09-15 at 19:51 +0000, Frank van der Linden wrote:
> To keep things consistent, rebalance CMA when changing the
> cma_first_limit sysctl.
>=20
> Signed-off-by: Frank van der Linden <fvdl@google.com>
>=20
Reviewed-by: Rik van Riel <riel@surriel.com>


--=20
All Rights Reversed.

