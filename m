Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D701CC61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 16:14:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA46F6B008C; Fri, 28 Aug 2026 12:14:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B52B76B0092; Fri, 28 Aug 2026 12:14:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1D306B0095; Fri, 28 Aug 2026 12:14:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D9D26B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 12:14:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1F2ADA3E18
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 16:14:02 +0000 (UTC)
X-FDA: 85151174724.23.7556F26
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf05.hostedemail.com (Postfix) with ESMTP id 84BB610000B
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 16:14:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="D7QqSm O";
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787933640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2TOHanlDmqs1MCHJU5mQ5YIvRXJl2lupzJtXXmLOVuc=;
	b=r/Ld4KcOLiMhwcpES9NH3CwcMXI3pkLuFiyC28+o9lfUjF4mfeDulx67VwSNsA6UmYquf9
	qjKbFnG0AVYFmh3A1fTZ50MNSdgM7o/HLGa5HFE9QElT0DGOasgLOqv0iwn0jDLLLLWj/9
	ONRfNh3UK15H9Zhc55UxO0w4vDLSbD8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787933640;
	b=YvWKZ9Ov10/9HWNdj7AyVuDupTNydIhsLVjsyaGTOOlhPVe+AFeh3KfkuTUWxVM5YEwyNI
	fVu0W2/XKDkSqQ6wsZPj7zf8hd1EmgO19pXWttEbMmZvWvvWxQDbPeKOrcS6JQ71BnIAE4
	fuTL/VkEvXD6CogWqg7i+pKvgL6i2E8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="D7QqSm O";
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=2TOHanlDmqs1MCHJU5mQ5YIvRXJl2lupzJtXXmLOVuc=; b=D7QqSm
	Ob0+hY6lYjhI0Mzw0AH2csJnCE+N3S4MXGbqzhQ59iETcGH/paxg1sekw1Ygx1ZKzTXEhTRgQGH74
	2+Hjj+2rJ31B4kZ6geCR5VjVJ1ECb5Y4zN2O61xgAyM1pECogqFvNTczfLyeY5zUhLzYI5xjGZDl+
	rDEyeUw+8BQx91da9opjZX/b5GK0YyyTWRKNs6kmDjvgN0yc5KhvnFDayjmbz9rpytl+SpzPzmOFP
	KcZMn+JX2emjqoo9RBmWuAxjyi71NAC5WTDZ0daFU2aTGlu+Gifv053Xdb3qgbTPgih7rDEqpnvGi
	Nog8LJW6h20W4JwnPPoFtvH0VH1Q==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wzzDA-0000000927k-3eII;
	Fri, 28 Aug 2026 16:13:48 +0000
Message-ID: <35008c3b1d00766116bc9b6768d42238099117b8.camel@surriel.com>
Subject: Re: [PATCH] mm/memcontrol: avoid stuck FLUSHING_CACHED_CHARGE bit
 on isolated cpus
From: Rik van Riel <riel@surriel.com>
To: Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song
 <muchun.song@linux.dev>, Andrew Morton	 <akpm@linux-foundation.org>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, 	kernel-team@meta.com,
 stable@vger.kernel.org
Date: Fri, 28 Aug 2026 12:13:48 -0400
In-Reply-To: <apGro0MJ-brPJfoa@linux.dev>
References: <cover.1787890328.git.riel@surriel.com>
	 <a611f2bc40d30f9c14a6f41b173185975c46a203.1787890328.git.riel@surriel.com>
	 <apGaZdxAPH68kkCc@tiehlicka> <apGro0MJ-brPJfoa@linux.dev>
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
X-Stat-Signature: 6hs3a311wht84awqqzjqwdmq3jkizihm
X-Rspamd-Queue-Id: 84BB610000B
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787933640-887501
X-HE-Meta: U2FsdGVkX19qAH6pebQuXhsT/xC1sU7cn5ZVTkp0sED9DTnD34cYlWIUFNHuToGAIolsClqtHEpUvCd2yHojPOcuKd8rcUaXWloA+0NP51/GtWvGgo0+GYQ7XPqFqdv8ump5Dsw5jN9o2iAVal2+UwW7FTT4bJWC6u+pYBH2C6Ib15VMjjKSAk788IHuLso1kAAhAUSqEf6a3ATu8WP6obzPPJwkJEtXqsa6NBC7f185nRl6iwBZUktMoITvH8dk1xcg0KI75KF9NtMtDzYNeXHXbT7ca2OiMEvM+50WL9yxeObasyWrQq/nEu+HdoZKKuNPXcrMgf1mvhsCRLKaBLZ/WLsoUbTxi05+6MeBU6T6xFpi+ai2ErTMt/cujE35tMyrY4rWojy7pWqP0bdoGj9JXL2y15CX3nwyRNJeIPwzo6Vc8yNAGJfp0FutlC2S0efKqrd2Wy8RRgfFRhjCHllnxptt7UlLF4C6cmajmsTtV3NSGvfCoEpDzCT53Iv8kEkIVoe9gg7GqeubNXDqZ0lrmze9rT6YYOh/o4lIYW6N8nvVR0JzlN4kkRY+9lz6XRJjYW9GjO74akGsAetfBrZb6ZI3cplcC+kWEcAdozvVi1AA03OJP34f9QXToUYyo/+RaKegle0NgyRYPKqnLjkP2xCTlyXEH0OxuD7LgdlRhEIC0fXIR56UVap1XdH1NcFvI9NXw0Wp7K7/n4cnkuRdaIfl9eKcpetGvCeIrBjom11r9gGtYINLYOY2RUQaMALyVLo4uUUu20KYxNKgk0GDdoyJT9ThvYLcHgeIXKQSPvmuWe6UOGEHhjpPskLRaYIjkMt7iyPsZgyRwH+MutPV24Ftawpv+ltVWCsERNFyvF1aZb/QoXoiui5eXVBriiAV9WVKx8zXqGKvY7tZkfJ9UoCc5AT17npl13yjVMWUbwEFPb5ccVrhALJKvQlIildTAdWda02y9+xZOOC
 wEE3jC7m
 u9yt0yuVaFBoQHNe2OKJspOCHgIDV8V3Vu2EnwAGAQIv/W85FC9d8S9rb+IWSDfdmsS1LAAX1tjdiSdkKW7UCiVeXs5638PVVjbGFbY8GgiB58fgEQLB6tWnw9ismix129CkH5ccDtEbbdB0afmywG6NvzELSQZ3HWpatdw0hJC+A7g1FavpGm/+ttxSRXIxrL6zGu+hfcV8UL2us60SAI6ku77jDD8zdNmKWLmH3fWe91dgV9+0iNb/IaijiOrQowraqN3RKb/H1Ds/xJUV8yF1F9sqYO4K8LVB52W+8WjEDVpBeeuysMC+ZR0sXfgD1v/CMbMesY8cnhMk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-08-28 at 08:41 -0700, Shakeel Butt wrote:
>=20
> Let's go with this patch. We can simplify above by inversing the
> check:
>=20
> 	if (cpu_is_isolated(cpu))
> 		return false;
>=20
At that point, we could also clear the bit here, and
have the function return void again, so there's no
duplication of that check and clear in drain_all_stock()
> =09
> 	queue_work_on(cpu, memcg_wq, &memcg_st->work);
> 	return true;

Let me send that.

--=20
All Rights Reversed.

