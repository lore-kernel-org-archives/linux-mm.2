Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73AC9FD45F1
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 22:26:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 756A66B0088; Wed, 25 Feb 2026 17:26:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704266B0089; Wed, 25 Feb 2026 17:26:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6102D6B008A; Wed, 25 Feb 2026 17:26:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4A3F16B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:26:35 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 11AFF1A06BE
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:26:35 +0000 (UTC)
X-FDA: 84484414350.16.7DBD043
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf30.hostedemail.com (Postfix) with ESMTP id AF17B80018
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:26:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=mjCBY0xh;
	spf=pass (imf30.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772058393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fy3cH2rzILpqMLlhVdZJPMYEJrn96kG/FRu7cB1YPhc=;
	b=S3T3w58a0eMW4sJPZNOBoegxYrMbQM3qL32WxDJ1oRBEskO1U9vPFD7HXqpp4wXXTyrwVZ
	91HJflHYKjjXZ9gOEL7f1Eu4s2uV7+bSiGViGW/DJvoxwjUsk5Shu1Udr0fZ9B79juqNdo
	lndcKTOhqttq5kMNshRqMkPu77nv6bk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772058393; a=rsa-sha256;
	cv=none;
	b=oHxdc+8Zebdf8UyMN29nQ/5T2qR8pNYsHc82/pH+GPCDYoQ/yPtE9AtbvaibHDSy/PkQSI
	5ljJpF98e4Bze2U5iwHWUs4XTupjQMDWjiCykKflcBT4nhzV6U//M+i5894I/G2aRszIT9
	APGOCTI12i1U9yv4iZ2SydDZ6SDzKNQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=mjCBY0xh;
	spf=pass (imf30.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Fy3cH2rzILpqMLlhVdZJPMYEJrn96kG/FRu7cB1YPhc=; b=mjCBY0xh1Nnoc77+L4ZqWWDucC
	3RmbQIZj9JZxWebvCUqEjzH/E5pFYOAZ3MjDgs4Pq9IBbDK28l9AP5z/blC54d/Mno5zdloMEqRrg
	2oGgJA+MDFLz2kkIe2yXOIPL9XFX0GN9Q9ksN+pJPmGINnBGXqKMlVOloh2PfAcIFlU10aKTqFVJJ
	8EGBa2LBODEI2Ll2FZySxmdhhMnFH4XxKZoXhzyIW/jx24z95eOaFsDv5PMMqxJZoktS41M5YINDp
	kIAE3D4juyMIjN0118BY4L4Izjbxewkej/1TEp3q7F9CUbe4aWVoXZULO0o8o4gwYDUO/869N4wtT
	QtoIVwcg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vvNKT-000000001pm-3AfW;
	Wed, 25 Feb 2026 17:26:02 -0500
Message-ID: <9476ab2ff783c77ff4f1d323fad3e356bb172fcd.camel@surriel.com>
Subject: Re: [PATCH] kfence: add kfence.fault parameter
From: Rik van Riel <riel@surriel.com>
To: Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>, Dmitry Vyukov
 <dvyukov@google.com>,  Jonathan Corbet	 <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>, 	linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, 	kasan-dev@googlegroups.com,
 workflows@vger.kernel.org, linux-mm@kvack.org,  Ernesto Martinez Garcia
 <ernesto.martinezgarcia@tugraz.at>, Kees Cook <kees@kernel.org>
Date: Wed, 25 Feb 2026 17:26:02 -0500
In-Reply-To: <20260225203639.3159463-1-elver@google.com>
References: <20260225203639.3159463-1-elver@google.com>
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
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-Rspam-User: 
X-Stat-Signature: qwds347w1no8auhthem1ddgwtb9uawya
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AF17B80018
X-HE-Tag: 1772058391-849392
X-HE-Meta: U2FsdGVkX1/3BsMlHE2GiDJcgxZD3vIVqdKlpB4Dd1FqX5kWKN4KRCKCSgvDq13tLJXNs5k1/NTQnyzCecsxIjLQ6YkBm8RkJJtTF1DjVouH3jpiq+72ewp5UYEymVQkqctJmR7qR7bbNlWQ59ApnztDvXT7Tu/x5HJ1/pbytE+6xDGidh3GI6yu6FeaHXhjIHf7sotgFHZjsu26CLLWlNeQxYZCdnQfwlm7VA6EN+S6O7SgvlqCIDPyLKqUYibvEmZ1OF9f51dSXCsae6vD5beVLFRZpe0u4C1Kzo7W0gCmKO/AN4JLnQgEJhjN2ZidPecInmjJKT89+SV32ICTY8fQmxhuFagh6Eo++z77yr3uF0d8gFtYRBAFUI0CVKUAg/bAaRgas7jVSdji0eHtJied8BG80YpsKIsMIC25rnEzz9zlATqIU3xu/Q88kHcyPZimZMFPcfDxHH3gOCQa1cn+gw7HOjk+CeSb+LNf8pg91iKw9cnAj34oorQFy3rXq2pluwp4fiJ5/JPMT2zWF6KjWfS/NrtTccnjBr5987GnoYj7FeYsDaTyjvnSEGUCC2dFL0fX9O+pzxyjB/msnwsO+lKJABC4do2T0GE5bUlz/TXiW4rBEzenbEY4/gJaSXwFR653jFOlRcT7eX8W4QCGFFYHhMhql5sg4y399oSiync8L5XtVWcpi/VRDRhcHFlgHLI8FwooFLugwb6TeuH6IldZ6SKSZrIQQ2rqXOal8awuV/htQfVKTSqFpiTEGDPiJL9Rlwm+kjoqB+KFmsEkg28Avm8PyP/w+f8zQIfNl1O+pupHt4F1RZAjtnUghMAsAtCWY8ClDxqBn3Ys2cJqIV8SF7xKxpXE/Zwi+tZfSXiS6i2FU24nuI0K5bzF0S4mvFYzydSBFHvJ2Mqp5M954o4mRJ1wQ7Ec2OT7ewBZX4qaWZQ6dN4sQO0i1MiGEowNgaC4OQLHsXJCWa3
 5E/OwuXP
 OA7HWxbU+ivxgUpbkjvhcjJx2uUwRxl6LswqeSqqI/22RBxfA0cTbfqPyWfdMe4bdq9D7d7KTEWP0eAHf7Oct0RcZOKnJGGoEzmbqS/sUlrP9OJ7VT6jOFYs2qtJhjqaldWJPpS60foACRVfhvGtpLi/ngbM4dc43Hl+haxMkuDgHWn6cFTAV+0NR+3z5NO9AZRqFtenZ//jKRJMIMBylGJH/aOQWpXL8qxxL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-02-25 at 21:36 +0100, Marco Elver wrote:
>=20
> +static int __init early_kfence_fault(char *arg)
> +{
> +	if (!arg)
> +		return -EINVAL;
> +
> +	if (!strcmp(arg, "report"))
> +		kfence_fault =3D KFENCE_FAULT_REPORT;
> +	else if (!strcmp(arg, "oops"))
> +		kfence_fault =3D KFENCE_FAULT_OOPS;
> +	else if (!strcmp(arg, "panic"))
> +		kfence_fault =3D KFENCE_FAULT_PANIC;
> +	else
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +early_param("kfence.fault", early_kfence_fault);

The other parameters in mm/kfence/ seem to be module_param,
which make them tunable at run time through
/sys/module/kfence/parameters/*

Why is this one different?

And, does this one show up as /sys/module/kfence/parameters/fault?

Having the ability to tweak this behavior at run time, without
requiring a system reboot, could be really useful for people
unexpectedly triggering kernel panics across a fleet of servers,
and deciding they would rather not.

--=20
All Rights Reversed.

