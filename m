Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94C34CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 21:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC3F28E0006; Tue, 16 Sep 2025 17:16:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E74DD8E0001; Tue, 16 Sep 2025 17:16:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D64198E0006; Tue, 16 Sep 2025 17:16:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C569A8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:16:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 788A9B84D6
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:16:34 +0000 (UTC)
X-FDA: 83896372308.21.3FF0AAD
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf23.hostedemail.com (Postfix) with ESMTP id D04CF140007
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:16:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Aa3vxuAJ;
	spf=pass (imf23.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758057392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tPfdBXqGhZgOFxAIFq+2UhTmE/Qq9yN2R/DdfPLLnfk=;
	b=tMR+B2N3IEieZifVldTxqZSLZZaWYO0K/6Jc7rwakMZcFuS30SBAlfeJnDRqVF3YP12zpw
	8wH7AAsC3k4PZHo2V15yKMNjj6Mw2DhcY3glRHUjXDvitPUDnhxkTShNNcbT3RGTMPXXjZ
	OueT3qdDLpSgkFntM/k2xpVoH/jtjgw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758057392; a=rsa-sha256;
	cv=none;
	b=6K9T1QBYQaoCl3eRZ7aycMRXRYZ0v0gGZ2tGHD16HRJw+x8L5XUPCzjniwddiAF6H/61S+
	FA9EAcgg7nLFitMU8JC30UiQtYJqginISqfe5TFdUzRwtqmEiEYhYPJLfOO+E55V8ctzc+
	gmpy6u5HfrBTDqFpgYFhzLf+l8R4w+E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Aa3vxuAJ;
	spf=pass (imf23.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tPfdBXqGhZgOFxAIFq+2UhTmE/Qq9yN2R/DdfPLLnfk=; b=Aa3vxuAJm7ew8q/JhGxTRY/zNP
	Ag65GNHLQwM7oH+X6lGxnk2uvcN/941ShFqftP5vapjyeZ1/cwlhIFcGErVERL1oDsXiRV+UmvNiL
	0p1AXlR9/kxM/rA34/4ESAHutASljpHs1Xdww/4JKe53yOvkFrXfpI0xdA5BKFvuvu9ItYc5UXG/q
	/jAMnLYA45HfV9TN6YJBl/TbEwn+4jDiEpYFte8u1AsYpkdp7bZWOZRNGGh3qQYiOrERd6OGkJk6W
	AG1oAuW1bqdn8UvFHtwd/HlirPFzT5BEnsaobZsBYpYyznue+mGzFViByDtVjAGWyWoOevAmsM5P8
	zEU8WWeQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1uyd2E-000000000Ws-2vie;
	Tue, 16 Sep 2025 17:16:22 -0400
Message-ID: <f80841127990800d6d1fa3d68a123ba696c7243b.camel@surriel.com>
Subject: Re: [RFC PATCH 03/12] mm/cma: add flags argument to init functions
From: Rik van Riel <riel@surriel.com>
To: Frank van der Linden <fvdl@google.com>, akpm@linux-foundation.org, 
	muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, david@redhat.com, roman.gushchin@linux.dev
Date: Tue, 16 Sep 2025 17:16:22 -0400
In-Reply-To: <20250915195153.462039-4-fvdl@google.com>
References: <20250915195153.462039-1-fvdl@google.com>
	 <20250915195153.462039-4-fvdl@google.com>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D04CF140007
X-Stat-Signature: 5ch61rr4uo46sen3phxntzxz6hqcau7y
X-Rspam-User: 
X-HE-Tag: 1758057392-5220
X-HE-Meta: U2FsdGVkX1+wBfUMDRmtCIB7TzMFJIH/ex5SJQJ+CaYZ5u8/TF52llyvM2c3DdUFPy5jFCuNvgSuWncj0HkGDnzZTUvwaYAyl+4kyEF2u0oWutxeSCcQkmbMIyCugD3URl0YCfSkSsNPFDEMrMnkGKwWby1wZYW4B3FRIUiy4/gZVrj3U8HicPifLLfNFsxiBjt9w86r2ChlVkEk/qs2q2vaahG2ef5rf1EhN+5M6Wl51xnBewuFGDLclKOvsGoBU/b/DRhZf19a0gRKqLaUxt+CLKUQ214l7uJfH+/1ACG55XdQUPUxTn2vkYbIp4TNPN6xnzh5ppuA8NV3hlHwBo1h70CnD8kmD3u25WaURmGaIPifQkCEp2xxyFM3U+ujKmcopBdpdOsRPKNY39F5CtjhL+LJKZDHnyiSne1oBgHt1KPAuI6fcrQUbT7+/cvPS238+7DPOs1nDajmbNsbdEtHUUBcWmzNYLkbtyT9I2nmWC7tp36upXs+B87EL5J5p1wj8R5jlv7sNSiW2rlaEmrL07CIzAJlQTWiNiP/odV3W+QvSXvIHKNgYLseDNIMxpJGVIWOe5KQmS9Y5iX208K65S8dbC4nosDI0iXEJjVwDUF2mKUfGHxKUx77yvpQ16hl002N1pZ2lm6qVzp654xK54d/fdvNI9I8P0u4fuKjc+OAU6NsA3JACBMRgvSQzQBAZy6Y5nGCuD43HZQWl5to4ZJzeS5CJDc5W0eSmYQ6P2GLuwxjIkWZnNyoOAt/iNd21covOo0xjt01Vg/be1L57RBUgGI80iPKpGpUMqraICFPI0wrKtwbhOUPbYbumD03dQ/ioqzwl9mnqj9xYk4ijDzdh2FT8RTbrGJ0RBTQSvxEJNiyTAfaBTjuJp5jiN8m6D04TFJBXIvBnzgDBTVT0DubW38iK/fW3r7lanph8/9OhdCy2qcVzzGJiPonQQkfhv7arKVq42K7Zv9
 1O9ei6n8
 PdMMXbALq6T6nzmLOSMbV7iBec1WNj24xL3gjmanKRkFlR3bCReHuINSrb92YucQfPhL95IwPH8kKanyTeZeiOtGXOSSuWcJpDpxzBwzKtUmvRzPv5S6oepMlWGuP0LGcc2vcL5rTP3uTzsNIzGBm0jo/dAVW78mg2gIYeLUCz65d9avj3PYF0JxYAiJJJaJT2BBTV+IF0o4HgVdaKAXxhOVJsa9B/zbgZ3ECBN3dkBy8QksY/+yipTSlVeq4tu+NkhJZfHeI/UJKtMOOYnoGj3Hn/Mc6hYPjOpAu8x3hmoVNkFNbAUMJkIHdOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2025-09-15 at 19:51 +0000, Frank van der Linden wrote:
> Add a flags argument to the various CMA init functions, as
> there will be a need to pass in more flags to control init
> and runtime behavior other than just the current 'fixed'
> argument.
>=20
> Replace the fixed argument with a flags argument, and adapt
> callers.
>=20
> Signed-off-by: Frank van der Linden <fvdl@google.com>
>=20

I haven't gotten to the point in the series yet that
shows why you need this, but I suppose this looks
reasonable?

Acked-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

