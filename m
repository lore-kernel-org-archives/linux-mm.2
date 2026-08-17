Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A1F6C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 02:38:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F37A86B0384; Sun, 16 Aug 2026 22:38:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE8876B0385; Sun, 16 Aug 2026 22:38:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFDF26B0386; Sun, 16 Aug 2026 22:38:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD91C6B0384
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:38:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3B3C916061D
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:38:02 +0000 (UTC)
X-FDA: 85109201604.13.01CF8B1
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf01.hostedemail.com (Postfix) with ESMTP id D875840003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:37:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="SaeTQP j";
	spf=pass (imf01.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786934280;
	b=Hx+NpuvQn7pA9WxCz80cAT8Rqc+g1khRlq7OX3Zhj5kVaKQ7hNA8sqciWZ8NlF9Iee4V4+
	357gDYS3+enAGmef8EDBvoSinhDL2MbKwjpRzuwDdFYbmUEB2iFHlhPhRaSQJxirWcwEqZ
	Jv0mbFSj1ezd4qKIqXHxS+Dw7gCoyk0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="SaeTQP j";
	spf=pass (imf01.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786934280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xllxtvWrYct1HzRbWL6Jve5j+mopxShCmeLjd7RXrQY=;
	b=DEPQMRDk4/D+n3ocjIoTPFSsSYoyIbK81kn6XxVG/gYutN+JVfJJ4hW8uqfY+/YcBJU0En
	QlWEtYNOclfebPHTEghhNuSaGlCklxTprt7EubCf5OlnNzjE9UDkGM+pO+XACsFi7wvgWt
	Yz5uSd0p0I8MT968JyTtQ9lhE3CbB70=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=xllxtvWrYct1HzRbWL6Jve5j+mopxShCmeLjd7RXrQY=; b=SaeTQP
	j616rGQlUlmkn1pkLWNKw53Imb0QeAADGK0oWnAURqI6quX8S2KljU3oI89SPsF1c0saOFs2U/A63
	yQ/QEHvcO9swgZs9lcenYsYt/fLV47TNl+mEKbIQ5VQcKVzS3J2j+v51XwDIgitZBKIlQkfPIK8/m
	8snSBVzCx+ghN57rKTfPwu1/2Y/Rhh+tlwToiF/65uo0I7JuPX6VvEoypkZ7IiyWm9dGbH/Fl/aAw
	rghzlOImXvIJ0aiiswWYdZcPA/T6vlAPd0qjczVeOUnup8XlIIcLG1Rk4sIh6CvDucb+N8/zAIMRr
	6Qooxtzwf4M4aQ+YzWVsXFt5Kj2w==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wvnDq-000000014Vf-34aP;
	Mon, 17 Aug 2026 02:37:10 +0000
Message-ID: <50659b89ba88f3f9fa2708351ab5244f4a19ad2a.camel@surriel.com>
Subject: Re: [PATCH v2] mm/rmap: synchronize lock and unlock target in
 anon_vma_clone
From: Rik van Riel <riel@surriel.com>
To: Eric Kim <seohyun.kim@outlook.kr>, akpm@linux-foundation.org
Cc: david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 	harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 linux-mm@kvack.org, 	linux-kernel@vger.kernel.org
Date: Sun, 16 Aug 2026 22:37:10 -0400
In-Reply-To: <OS7PR01MB1391443074B4A2A774B7A956C96A72@OS7PR01MB13914.jpnprd01.prod.outlook.com>
References: 
	<OS7PR01MB1391443074B4A2A774B7A956C96A72@OS7PR01MB13914.jpnprd01.prod.outlook.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D875840003
X-Stat-Signature: xauhf5sphjwm33uaic7b3f9anweq71s7
X-HE-Tag: 1786934278-331835
X-HE-Meta: U2FsdGVkX1+mfo4aEhXnuBggepK21hydQ7pTofI1/Mf3bI+PeodJqACVd+HlGTTCYA5lCieDJPR2SNCndCShtUIni48cvCBWtz8RbxVt9qnAyybU+bfUqsouKVeF9HlvkskfuCwETx7Bx4a1yg3yrC6E0c3AoJf9uovC1eWp17oEQ/eRknZbN1EPXRT6DrHNvDmww4Sfy2HgLjDtlM044C5vYMUuezSr1/rDj2EpbRBHwrcLnTNRx8ZQegRZeOvSakPT84tp2zUEJrpWq7fwqU8JEo0jrIktiLLtqXvNHHM50mEiD/NsNuxZAFz+7hGq5YCAUKHLFpPPS4cbcvPJwOVYZjgeYO+D6fbIe5l25wRdp+R7vlPs1n+LQ5FHQkG133qflyp7rOvkP8cAYIc4qamrhINAIj7hQM+YhkeONEZu6wXaCUM3H6k/seo7jxA/5oHB4hr4zDVwGN9V6QIVHZhBbFQpIHSsSvT5ELuqA1MISpIg/jZyi5c5IHrkO756eFqRpAheFCrR3zxou2XGsm/BXAeIL/0gTFghSSL0uIKX+UTvbGpYvuX5HWC9DMwZob6+j73jvfxGbBiMMFwgnfn41hVJG/9Pgt/nDtQYT72kL+LE6Nc8j4+yFooQHtj5NQJnhW+tvM3l/g0TepEfxPzMhO+kLhiSlanKHEyFGi6ZJiKANcj54xgITmZgO47X2umaRR86tmDcuYqnMe1JddqcLDkPBULmVTsP/Rwld1fitid2JMW/RCEoYXhQIyq534yaQmXxfFEMj64rJQoAoHrq3UUNVEMbhM8p1xctnWs2xhzM+5qlBye9W+YrwFRxuW04ba06gq5rkS8K4TAqi+E+A1sY5777b+EarrETACiFINLL0rRIkzV0bYh5KRJm1V4xKBz1v+7KaTVfWUj5YnYeSvGWDF4W6A8fttMfPzc6M//GED254VJWPaiGbVIDKqG+Ftl1sJHOU9FRqlk
 ukL9RjRb
 QiIx8O6GU6OVW6NNqV+c+b/QNfbhnpBh32XrXF4YR72hD13n4XB8jGcAtL8eSQ+6hNC/Qv+Jgz4b4Elh3ANC96YT34iUsRm0URY/f6RoM4BUIrDkPwvpk8hBl9X5mvbLSYC1WITlhbVQkLpUz93WdJVJYaPLbFv34h1k7HoiT8vVZUUTjfl9YBc5FehhXs99jUGtS3w4aa7DBbtkavTucBslqjtf7AHPtfQxWXCOwDUL6B6k6KjkVnNWvf6WJc4PcuzchfXlcBSt5XaQoQxPzfOw87qLC5TiNkNLZai6+OeQ4FMyNjAGSfOfglZyszK3MDqsTkzkFBTsEcPmqUEjn5CkwFe8mJF6hULRFSGSjD8HMLrhQc6o3tmKExixBO2hzJ1Ph
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-08-17 at 11:34 +0900, Eric Kim wrote:
> Currently, in anon_vma_clone(), active_anon_vma is assigned from
> src->anon_vma and is used when unlocking anon_vma after linking
> new AVCs. However, the corresponding lock operation uses
> src->anon_vma directly.
>=20
> Use active_anon_vma consistently to make the lock/unlock pair
> explicit.
>=20
> Signed-off-by: Eric Kim <seohyun.kim@outlook.kr>

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

