Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36F2CCAC59B
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 20:23:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F7F08E0008; Tue, 16 Sep 2025 16:23:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CF7A8E0001; Tue, 16 Sep 2025 16:23:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5368E0008; Tue, 16 Sep 2025 16:23:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6DFEE8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:23:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 23357B8123
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:23:58 +0000 (UTC)
X-FDA: 83896239756.02.93D1D85
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf23.hostedemail.com (Postfix) with ESMTP id B5BBE14000E
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:23:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=IiZ4tN0G;
	spf=pass (imf23.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758054236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UFmjREzWYFiMkZWMadwN5GVfDDLgdw6R68iY+O9sTBE=;
	b=Q/17AJczOrWzIjLBUqpPvYuUZfW0Mb61Qf2l0gh0z3da/iw6adPAkSX3qFMqqLlS7vGtKz
	gmMvhZFtf0rU+wPnxffPDqdh351Yj7ltrSmtTgSFI77EC7RpWw1DJE5vZ1J5wm19zpayrt
	fVRtZaCYRY2uMNYH0u8lwOGF4HrpEAI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=IiZ4tN0G;
	spf=pass (imf23.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758054236; a=rsa-sha256;
	cv=none;
	b=FbG4bP7NoTcQJIlFjlehso3uAPOXpHuyknUmzqaBtJ5oPoedfnghasfvH7sB4anrZQ8m96
	PW5U+AMiM6pWcdpDM0t54DKXNQoKb3JLO3TR7ZvvO/hdeu5IG9e5ou7Q6JMa8n4L2Tdif4
	RBRkohNs4818MZXRirfFB/yEW7+/QF8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=UFmjREzWYFiMkZWMadwN5GVfDDLgdw6R68iY+O9sTBE=; b=IiZ4tN0GLaamaAqIZzQjs9MpgJ
	eRMp0OlPdWzEY7RNe9YBSNfeNFCcJjWQnJqvaKjeeCNxdg3DP/dPWY3/j6PY5zzIJHaeIzSTbB0Tf
	lhWGt1h9sfEr0SEnNpasHNLfv+4QDoyKCnIKAGPw6Aot3Sh12C2ctsiFgexHwAFAFxrbfrsWQArl5
	qthNs1RMeEoTxToy0kOzWGMmMU2Z2AA0H3KlUoFeYjXdtrJpoB376uqX/Pd3KQIxZx42ZcHKaJsUI
	+wOhjQYEVjNHH8uAUax9Vgq0EENk4meeE2Da7ZD9QPHrNqr14vJd0yMjcimj5Q9M0ibsh6PvHnnHz
	NXItkZUg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1uycCr-000000008Qk-1kDu;
	Tue, 16 Sep 2025 16:23:17 -0400
Message-ID: <cf407a37403360ca8c74982a5ebfd7ed1f8b34fb.camel@surriel.com>
Subject: Re: [RFC PATCH 01/12] mm/cma: add tunable for CMA fallback limit
From: Rik van Riel <riel@surriel.com>
To: Frank van der Linden <fvdl@google.com>, akpm@linux-foundation.org, 
	muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, david@redhat.com, roman.gushchin@linux.dev
Date: Tue, 16 Sep 2025 16:23:17 -0400
In-Reply-To: <20250915195153.462039-2-fvdl@google.com>
References: <20250915195153.462039-1-fvdl@google.com>
	 <20250915195153.462039-2-fvdl@google.com>
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B5BBE14000E
X-Stat-Signature: raf5anoidm1ttwt6c8tmj679x48i3rpj
X-HE-Tag: 1758054234-448293
X-HE-Meta: U2FsdGVkX19rrlmf2G4iQOYQi07Y/sNRFzljSBb7ePbWqNDIJKFqlsbUda1AWkUhBLuEm1unuU9cIcMgGjmvQoPZcj4ggPbEOUIR5MopPB/TgLEdeUp38XBeuFVNizZ31+lmvv3Bm69fbC3qb+AemtofS/WXWd6krFAyYBqvWP6JDUchbCm9zf6i9mKYFgKIlzHF9HZ8DmVeJpburCAfE0lBD8OwqF6NPdQyGBttcASP1nWOavos6NFO51olSdmL637O7KDMboeyzD66MQlNQfAXNtPbda0MKcdN6QfNtSflrsrIrqJCySwIlGqFQ3pg9DIwTZH2Wf95ad+iX4eB5F1sR0C64YhFiO2gQlfz3K8JOTv0Ps1Wd3/xTvgaaEmmSeZV+6t6yOfsSvKwmoBd+9WEl2Ho2d0238K2yR9wMp9G7A0CYPuahjzFYwUNs9SKcFk7TOlry12iDrYafCRtzf9harwV0kYdg4BdqD3I/2c6kVrhD7UOk7BKbptMiPLmKImfE9pIiog0l82OaqnGX59Ns+DzEVYpTOlDl64sVN78+Q76nQVQjLGlvPhSRzTja7DOrdLiirDF4NdakjAfAHN2DdMKmfkj0bjCoONyJcSNxxBPT4FrBVrqLFoqpMMrDnNAdyve2TbaXj3yZlLw+26Soa3cSktF8GPjpQ5jTKJeyrcChPHHVijwYmGCsFfNQ1OYOblb7JcEOTFoSvAiD6gxTPce920/qKmgeHo0aUEjN7OOzwypONtcZaXIVowYZNc7HHBm62/hWSh4/5gwxjoBIaKWxv9JFGUznLpyF2Td1nfOf9uWP+L2L4XDl2zzcx8s2hBE1x6g9YK+4xkWuN4w3uf2iEP5zyQJbX6xYbRQ7ztdX4DLbUx6Uf1Op+5358SE1HOr6ZCULouC6jUYSqCaAyvxuQQMJGiYRc+bn1BPUCHHEraIEYY8j3Ilo6tiSSG1P34SGHjQeNRNtNa
 EokiacAb
 ujKpQTEfrttD2zZ0gg/n8Zyle4nqJYHAZNELQ654bFvR9hgg/cxbwxbeHN5n6FRY47HKbnGxY0i2pFInyzcRroG9Yn9FJDjVPs1BMEcMR4pWn3AyYKZZsX+FLjFJeVyXXFb7JI3KkA9qFAUg6BOm/97g096xwARc3trDk7TODwyPaZhn2U5WsgkJPEGrRieOdhjOEU4d79XeY8mXexTLrd/jP0MXmz7pL+4VF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2025-09-15 at 19:51 +0000, Frank van der Linden wrote:
>=20
> +#ifdef CONFIG_CMA
> +	{
> +		.procname	=3D "cma_first_limit",
> +		.data		=3D &cma_first_limit,
> +		.maxlen		=3D sizeof(cma_first_limit),
> +		.mode		=3D 0644,
> +		.proc_handler	=3D proc_dointvec_minmax,
> +		.extra1		=3D SYSCTL_ZERO,
> +		.extra2		=3D SYSCTL_ONE_HUNDRED,
> +	},
> +#endif
> =C2=A0};
>=20
I like the code, but the name is a little confusing.

Maybe something like "prefer_cma_percent"?

--=20
All Rights Reversed.

