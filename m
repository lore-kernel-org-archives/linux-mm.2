Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90D5EC61DC4
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 02:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 746316B008C; Thu, 27 Aug 2026 22:34:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F7016B0092; Thu, 27 Aug 2026 22:34:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E5A56B0095; Thu, 27 Aug 2026 22:34:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 305A66B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:34:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B1C02A031F
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:34:03 +0000 (UTC)
X-FDA: 85149108366.02.E54A779
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0A0F1A0003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:34:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Ddrw2M L";
	spf=pass (imf25.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787884442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9wMZiDMq/rz4mdl1/IN58xfKmIEDgogb4Bj2q2MwzcQ=;
	b=d1ItX/c35Vhcp8r5I6j+mzGR5ElVGCWS2w3b116tx9jF+bKzN5Bp49SGAe04ot+e+dJGZx
	g9ZKypZrocwpY/hCuYjE9qxPEaF7qXmDUCmWVGCc5k/oK9q/DHgtJu5KoT5K0O31zebHU7
	qmMsXQiUzQB98yjNYLzUqbUbPn5Ypu4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787884442;
	b=ipaif8h8TD5IGvM8dQ0hatXSpxCOGna0FV2Z7PVY/o0ngYZlRsQE+GeOuoKlz7rxCdw+W3
	IZKdkKJVooUmWpxWGYJy0K1jrhsGuqOrpb9cuFC1t2CK+ZdhTc3xBQhDzFA2kKbbMGCLN6
	Ptu33DD8mfUVksi60GIHZCe1dx1nN4g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Ddrw2M L";
	spf=pass (imf25.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=9wMZiDMq/rz4mdl1/IN58xfKmIEDgogb4Bj2q2MwzcQ=; b=Ddrw2M
	Lk3YEBmmpXUcWQSW5Nc9gjbQV7ES9xzuPcUYu6b/UtYEC5Y6iuragnZgtRNY56RFy9I9Q61f6Mwev
	G7ginCZ2fDYuGiK4JnCbyvSax0NXYDaSIxMtvuGjPfTtz2m64iiNU82eS8IuDFr6RqC/yGotc+j3S
	/WkjHHnbnazFkWMRNtIA3on4eNt8C693Axu31t0IXcPVE0UJv1Z8lpNRmOhftmLD5Rrm3BN74GTVb
	LzxgGARBpWAuKtD6R5hunO9KGa5LohV2AB1W+i/iAkmyE6d4+BuklBc4SZ3Vr3zbcXkRVXTLK5zs2
	A0/iNxSFPSPr4hpbAWSklLkK25Ig==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wzmPa-00000008mz0-13sP;
	Fri, 28 Aug 2026 02:33:46 +0000
Message-ID: <a614ab59e1b454d21011fbbc04347b6b6c49a95f.camel@surriel.com>
Subject: Re: [PATCH] mm/memcg: fix UAF in drain_all_stock() async work
 during offline
From: Rik van Riel <riel@surriel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song	 <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, 	linux-kernel@vger.kernel.org,
 kernel-team@meta.com
Date: Thu, 27 Aug 2026 22:33:45 -0400
In-Reply-To: <20260827153527.e0e968a22717f558a22fb893@linux-foundation.org>
References: <20260827124211.3b94b103@fangorn>
	 <20260827153527.e0e968a22717f558a22fb893@linux-foundation.org>
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
X-Rspamd-Queue-Id: 0A0F1A0003
X-Stat-Signature: qcewyi3hbhrt5o7ixtybcra83odhkqds
X-HE-Tag: 1787884441-850250
X-HE-Meta: U2FsdGVkX18qCGO4yb3cg38HCUAqJpuFNMS/31TtZeUxybxaePd/y+zSrs0BS5Tmgao8PVzew4HFXWJj5XyVN7OqR4Lts79gP14Cd5gU9Ko9R1emtVuDyEKCRWbDEPKhLuAGwjouNf9d0MpPBpchLOnqu3EhMQZR9Qvh1KspbBKNzINK2TcwwOoyXYI/MY4JtTXo8p3Z1/F9ZVEkzu9PtRmIrsvOmcvO8fgHg5ROwtebaJe776Cx1AvC+QDScU/0de+9GS8W3GTfUsle9mWYN2+vSktv+REFZMBmAL8j1IDsZ7XGjgVbMP/+z8ZTm84dxqeIeVcNvHan63I/MfGld7V1t/2+kqBFBBFZBhoAquSeQX3Y/LiJYmfsb6wXvTPCF0EuLjnu2pfG+sN6aoFa9ng+QWGqkXgXpPfOeRZkyK3A5jzqm8AM/o6w+6A1yRKx9weM2VHQpz1DrlQWOgBqhY1wj8BB/sQyG9mi6oYxOVF3cRKlBNcQIiXHPMP3myV9Fc0MS57eOq51ab0F+ZArdLOF5DOFN2tyophbzuRL8T9hzgc4eo+YSahpznkEZaEHiQJoQx4oremBVIjTdwL9i+bKGo5iPJ98QXTEqLwXau9fZ09V6s2713XJuW7MTako8jTCSEX6dtRys2ySDOb8m08EQXqpLacfE7/Uck6yKWZdmrgY7hB5XBqHJKtSoiRfWoP6LN+JXbqzuCyNby2YYcg+BXroEIeviFAXIOPyWvb+qnzDsV40gwvQ1QRaopoQLdTk0jQd11XFxsPghOa6c4hG32GiLZejnFDbI+pwAfNFo4TMl/GriX/PpsUET8T9QLuQOZE2FEeHrxknsrFQlEnFzQX7C48Qi9PAc5kaEFkCrO6IORG9SU7M+0a9//UufqcZFJYIKeyjLKrFvob1pUzfvhL/5gCMGl5MO9K8ArWqF4GNQ/VfFRyE0g5cQykgcQMs68Hpmv8YR9+9ebZ
 IRo/jau4
 BuvCFtbRr6/FK66CXsFg36tjbtB3Gu0ZS+vz62cna5wJSO6EFT74CVrADxy06spaBYNpYH8BNpFszRvlFFmVl2lFB9gKoNrousVhEUFVDnxAPbtOiAV83TL+pw1gkViBmE1u/UUui2i8Fa2QP/0pIL7/16Ww/5rsaqWV1UqBbo1QEkoJIJuClJV3yewkeZkdCY/GQAh7TWJH/jTpvswJX0QzTGnUNag+5Yzl6gSwVXUJ3Hq6Wn65GkEx5g/KQurYCpVvxMe01eI0Ff5UGAuR8bvwy6zYaME7q+YIUGOhc7Xs6YJd9UwFGGnsmTfIHUca8b4fOgfLDr0+l3UpDSlwhGNbczu8kqNuwMeJQshHNG2DnyFVpWdjkzH9knZLZc4kpJDlB9KYkiqb+KPaBTQLXgq5iSHrUFQveh3AW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-08-27 at 15:35 -0700, Andrew Morton wrote:
>=20
> Sashiko might have found another thing in there:
> =09
> =09
> https://sashiko.dev/#/patchset/20260827124211.3b94b103@fangorn

Coming up with a fix for that now, and some
adjustments to the kernel-style rules about
refactoring code to make it easier to read.

--=20
All Rights Reversed.

