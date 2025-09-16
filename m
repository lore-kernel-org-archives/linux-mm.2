Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A9D5CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 20:25:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 886D78E0008; Tue, 16 Sep 2025 16:25:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85DFD8E0001; Tue, 16 Sep 2025 16:25:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 774A18E0008; Tue, 16 Sep 2025 16:25:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 65B6C8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:25:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1CDE9160303
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:25:33 +0000 (UTC)
X-FDA: 83896243746.09.D6A2BAC
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9DCF1C000D
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:25:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=jxhD2jXX;
	spf=pass (imf10.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758054331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VrrA3GHnJGk6gH4rg+SR+QXFsrBpgZZ6IRWvVmtTOOU=;
	b=jNeKSd7mNu3qWORVLELXUXp6DU61EsX4p8MzFVIM92DXxmKqG1tswANeWmu7uCwdJvDQdM
	5XmopZGapVuCNxkmTGAh8SEMrJl4hVnSEbf3QPwHXYIqOY9cl/5QZhvpOqiAYIO9SY7utS
	84zRIbFX/tMDSQeVWLSheTNCaOT7Wng=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=jxhD2jXX;
	spf=pass (imf10.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758054331; a=rsa-sha256;
	cv=none;
	b=pH51sRFbW36Rwx/dKQgaZ5f5iVzkKlBdbj/2Ho8eGb2J7/GxTITEeEFZ3WBBPqZxOeuiMH
	5nrn1N3uXwdrKGmBKzHFsLXSu2Vs2te8UTCLTMqQbHSEJuQteYOZUCGJNlfXxaDxtyOZQw
	jl6UTKINpsFH11k+9nnBnQU7WZn3H1M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VrrA3GHnJGk6gH4rg+SR+QXFsrBpgZZ6IRWvVmtTOOU=; b=jxhD2jXXthqh0ICJCAQC2ecIWW
	CRzXt+3lfIOoJSTkHddIwPxFqJ1csHBaxaqlnQfMUwy5YZF9pWS+qlIB6cSAdLHq7clHjQpcGsu+H
	kCZnCLAhTNVAqeBYJxtCujTsHjOblc3OaB9n2NoiAWjg9pYp61ScdQMwxtDbNOwQC4YPokegSAqWN
	QZVkvQRIkUBLWtE7n6XdxFIv+Y6uIYdelQpQAQV94m2skQVkvrOAbbXBI+pJy7f06HEkgbNjsxGIQ
	aP4XmlVg+vbuBvonpcQ16OMsP58U7m9KgI2ATQfBHGjRSw5zWozFmGnZgoGRuxAOasY0UGgBCiXuN
	W1nj1oZg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1uycEu-000000008Rw-1ZY4;
	Tue, 16 Sep 2025 16:25:24 -0400
Message-ID: <34637892ccb9b4e4247103a7b141300c90cf2e42.camel@surriel.com>
Subject: Re: [RFC PATCH 02/12] mm/cma: clean up flag handling a bit
From: Rik van Riel <riel@surriel.com>
To: Frank van der Linden <fvdl@google.com>, akpm@linux-foundation.org, 
	muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, david@redhat.com, roman.gushchin@linux.dev
Date: Tue, 16 Sep 2025 16:25:24 -0400
In-Reply-To: <20250915195153.462039-3-fvdl@google.com>
References: <20250915195153.462039-1-fvdl@google.com>
	 <20250915195153.462039-3-fvdl@google.com>
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
X-Rspamd-Queue-Id: 9DCF1C000D
X-Stat-Signature: eazhh3pz49fr4u1zktpwq7jzj5h9dzpe
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758054331-874941
X-HE-Meta: U2FsdGVkX18odLYTGUnFYbVY4zAqD08VdVAM5NIC+28LlnyhDsvDqc7AHWd0gh/n8lDci8UumPhC+XN8IYdz8FqeSqWU4VHsRIQabof+FECJ0uiexHUsfN8nIWc7sjMdQfHYOvDewgppKIHQqwpyIzwuGGPNKAHZLaqF484YMfunB+KrEwzGK/FtJQ0+N+avm5ax2UDhD5SoAm4BPDPvhEOXKuisXthXohDPRow4yz8YE9HXSFkAjIGKDGWczRDoinDpq686Yd1ggGlSu6kVp7CW6n5tSoEk0joJwnGygTOPLnBlDzryTF86d1nnqeyqrkscCgz/jOcK5YahDZN5z0AABW/MmcexIHHk5HpgcVAdd1JecITJR0W4oBqAqA9MxsZQSxrzMnShB2RqvhhcIHD+rBNsqjmkkz2Gm3pTnFZDNheHYekncUCGmQBZI+MTefg3X0cr4fnmAU03IoKXJJpVJxETwy4RvFNIbDdsl0eyt3JGTHuRg7adYvLRO0WPmUadHXhRRZeDsAjoF5+ToU8x2nh6YMBnWwQVA52yOp2nE3GFtrWIqTgqm1j8O8UZrKqcxfjD/ReJVDTV4XtNV2mjlEi5WRE5sNXJqCN7Gepc2wAySfzqDWqzjwjsC4VeFF7ZXAGu68Q1Wj0x3TsOWQol2LK0wOSGSXB++IDA3d60NWWC/wQjadttCLSehqBIVpygVIjRVb+kWM/TixCBP+nfWFVr/NbKBRwaqObH09R8sPjDkVgx4HIyiEvlviZgo/SZZ3RwvrDoJBS6032qSzbXWSm6ffnnTZ5MFMmHLhDiLKFMuZwHqcZvBfX67vTbbR15z9bK6DPNHcB2CA23Bnnf1o/YAkup7WqqdDHBYihDrkPQpbDeNRPrcwDk0Mrdy1uvB6Ep1miuA39Am4zmkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2025-09-15 at 19:51 +0000, Frank van der Linden wrote:
> Atomic bit operations aren't needed for the cma flags
> field, so switch their manipulation over to normal
> AND/OR operations.
>=20
> Also export the bit values in linux/cma.h, as we will
> be adding publicly used values later.
>=20
> No functional change.
>=20
> Signed-off-by: Frank van der Linden <fvdl@google.com>
>=20

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

