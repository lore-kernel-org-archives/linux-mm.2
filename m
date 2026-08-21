Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DC1DC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 381A36B00B1; Fri, 21 Aug 2026 15:33:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 359EB6B00B2; Fri, 21 Aug 2026 15:33:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26F5B6B00B3; Fri, 21 Aug 2026 15:33:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08C436B00B1
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:33:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C465280290
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:33:27 +0000 (UTC)
X-FDA: 85126275654.26.B57066E
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf26.hostedemail.com (Postfix) with ESMTP id 03D9C14000B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:33:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="XDu8Hc F";
	spf=pass (imf26.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787340806;
	b=EKlEKhml8HFRq9AZ1QKOFO5p+TnXYwycojCcdEXwOUb/L5I5YhxWz+tS7d+MW+ybCt/8gG
	JeKlQXbNpZg0x8egPlva9ZvyUvKRM2SkKricipQUbhWa9VKoip7KWxGR50ZrrtZ4B9wXPx
	UDZ2RMFuV50yn1DVnhhYw3ImTniz/88=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="XDu8Hc F";
	spf=pass (imf26.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787340806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=izXG7K9hxhIP8tpOJdqIKgcyb6HVGLeSXQydcd+O7lk=;
	b=iwfHUJPSvVNHLgXfnWwmmZo3jPDEfKvOfL/sSQvpQxaeuC38EU6f0kXWvCb8odvIL6LQzQ
	G6LH2aO+6cP0JCT47xW6nRBfvXeak5VoGZ9EyHdDMj1rgcnOBOBJr2d2YovsOfuSW7AQ3/
	xBFMum8OzuMqOcK1Ol/su778VOAqMsY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=izXG7K9hxhIP8tpOJdqIKgcyb6HVGLeSXQydcd+O7lk=; b=XDu8Hc
	FAvbLv2xgCRKVx9AkY1Q/CyiDr/WJG9DPlX9hwPt4eODTe1pH3Zvi7X6yHoLhZfPJkRuyuRB+0HY+
	nROb2hq+osDVMCGJweAp+IG4qn/iMV6gZBp70bA0hFYMMAIOUISLAUQca3OC05lYj0oh15Ds6Io5y
	3hdz0zzi8hWs3fO9XMp05SeN+9bg55cjcL28sIw5ziNeAmhl1OX3TQoUDvghlBGDUVRAQZwDJyX3t
	CgONvcaLd0IKt2VKOafprY1HwjZfGA4bkQ5xaEf2yPapQeBQ6cVJ+KgGfbLFLvDjtowoy7TusqkN6
	C+Xk9/DyuP7Qs9RzgwDHStAJ70UA==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wxUzF-00000002AC8-1Eta;
	Fri, 21 Aug 2026 19:33:09 +0000
Message-ID: <2ffcd5408576bf02664f098427c62b37a8061673.camel@surriel.com>
Subject: Re: [PATCH v3 13/19] maple_tree: Document that erase may use
 GFP_KERNEL for allocations
From: Rik van Riel <riel@surriel.com>
To: "Liam R. Howlett (Oracle)" <liam@infradead.org>, Andrew Morton
	 <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, Jason Gunthorpe <jgg@ziepe.ca>
Date: Fri, 21 Aug 2026 15:33:09 -0400
In-Reply-To: <20260821192627.4085470-14-liam@infradead.org>
References: <20260821192627.4085470-1-liam@infradead.org>
	 <20260821192627.4085470-14-liam@infradead.org>
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
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-Rspamd-Queue-Id: 03D9C14000B
X-Rspam-User: 
X-Stat-Signature: e973juab4wifwk78h1o4gamcdtys198j
X-Rspamd-Server: rspam06
X-HE-Tag: 1787340805-567537
X-HE-Meta: U2FsdGVkX1/3ke4LzCtPbAmIbG7bKQ1hdVZuPpSkHkKFtkAumELaClI4mnS720uR/T5165+q8ttXT9WKPb7q+RIhqk7ErdaVoYqMbyn5lFuagnwzdqop+Zuuek4QoxLvDwtHOu0IGkIJx6K8wlQskYo1eB40w4ZcQH0G/c8pnnAp6IfgOyf6mzUkQt+TLrsiPSUhC7gRKiy8qOM5FWjrQQqoTI6z7i7j16rm9DG6G3sZw8ieIp+S3zINBaj0VWwTRNhr7wtcRJygQCVO8cN9WNffTAQ3pgwy1voBOO3SpCe/E+TJT5KZWnk3M8MbT2j1Wu9jaBidfwSn9S7KSY71ESjby06fTuW6q+bCE7NEdGVSl9CWsk2x0tu5/OTMotiuFnLC1GN1HKo+SuO8sKyGe8MovnUDpn+bPDx+aUAaWRHzb9fOXI6PTC029H9WPBKiM9oE/FN1Gc9YaJd1df7vIolZN6fEr2kYylHKJDEq1tESse8oOsRf/S/BUc0yMLmatG8vPktzB5cALn1wsTzXjWHXGJ7KO0Y9ihHUlwAb5dghHUEANGfaDDBevg1Ba7I0CjIYjoXxwyFpA+ccT0qChT7/5SuEGcHCcAUK5HOUZzUQl5RaFtrm0H5tkVnvw8W/85Az14Uosr/gE88oUo24Fdylz5Qtjao8v+3LgVjp7TseoWHdn2DlC2+q0BqlNu1fzXuD4UaDcddji3tkDn2CwNIrs9Na+/T7xU2RXEDg8rvQRhtuCQZR+8qteyMXCnkzNyLDJOtF8m2Og2HkE7zxAhHjTODPLAlxbwjlIH6rqNE3fXX6CG9uL0nwXCFHnlP5jBofsl1zcjrsU5WAAEEfh/tnPKx6vVZYsP+6tguMdq5OEPHBrCA1FMxI7TBO8q3OY3pBMhYDz4rsKz5cSrvP6e7P/esUdFoPBiuWWeBwkcXRvSsNysB59lSImiqUGURAVI2IcLyqmgUv+1juuMJ
 UVB0lllx
 JwZ0xlymvUPwa4Mk6sciW6hrzL2o7NyY2t2ZRpt+7bYYySa4a0h+CDdu8BiIHYre62zZ/XsdfooB3GRhTe3A9d6nKARkstX2AtVEwcp6Wt1xopdhAZQAezkjXvDRkQCJQg5KDREFvsFY4ZHF1mBiZ5QstCESw6tr9lhFSAaAarCrvpvb4UiOJpIAg6Nd0vdf4rE5JVHZsFEcP0E+AaLi9ZfLX1beNNnWNVvDsE6+lHCAFmbzmx+C8bY22ym65yzsXprNNnme1bMgA3PF/QlymyvrSpqL5vBuzvUxsXBAYIu7LTgAhvaDQaUXWPRL3jtR50z6MnM4kHsDDJhwoKht6O7YcMFONl30gs2gelNgZAQ46k9e6O0vzLO1hJBz7R6rs5xyOtHNo6HAwmVnFU3/PVS9W7WseHdwODWVCGMYbUb+5LgBghWf4JYNS0OAdHnytG3Bir8dFV5xa22q/j7Dlfg5Loi4W3zcGM2rITT0VUzm6ohKkIJvrycgCqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-08-21 at 15:26 -0400, Liam R. Howlett (Oracle) wrote:
> State that the mas_erase() and mtree_erase() functions may use
> GFP_KERNEL on allocation retry.=C2=A0 Don't just depend on people reading
> the
> documentation by adding a check that will warn of the use.
>=20
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Rik van Riel <riel@surriel.com>
> Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
>=20
This is helpful. Thank you.

Reviewed-by: Rik van Riel <riel@surriel.com>


--=20
All Rights Reversed.

