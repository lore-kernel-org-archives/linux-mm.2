Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 670EACDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:45:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 436BD6B0093; Wed, 24 Jun 2026 10:45:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40EF86B00A1; Wed, 24 Jun 2026 10:45:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FDDF6B00A4; Wed, 24 Jun 2026 10:45:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D8736B0093
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:45:18 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 91FC38D795
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:45:17 +0000 (UTC)
X-FDA: 84915079074.21.EDA3A6C
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4DE8780011
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:45:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=SfAnQDLj;
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782312315;
	b=mw8ESH67900JlGDTh69GOpqyTZ+QJH74B9dxg6x2ajmewUdkJFgNuXr2eAUgYlhcfp6HCW
	HMttDtcKLaQScDce11xOxl5w3B3K1KR5AosKEOQ6YPRoZCNtt3G4raC4vrZReGGAcJDo0W
	1D5OynYX2hwehmVH4XHU/Lm1c7v3w84=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782312315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wVHL6dNX3n7r+4CMxQlhF34InM0ZtmF2WvKJot0jDCY=;
	b=ocTIsvc3FLxsL7V+e6Ol2qwAYHJsX701f+/2fnkAoOYM1780F0LCyL5bWMUX7CcKI9Tbwy
	Z9jTNvRP/L8TI+Brge/FtiEwEvJzx5AG6HWtOb40lOSO/6q5+pYXzLCJzsfiEilI6iJ6U3
	SZYM0Y29axyfMsr8Qx/Zr8XA5T5O+R4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=SfAnQDLj;
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wVHL6dNX3n7r+4CMxQlhF34InM0ZtmF2WvKJot0jDCY=; b=SfAnQDLjyks4iVnfjPMSmwBwcE
	pI6O0c3Mm9qB2rzbC/gbho6xWZUqwzDU2x1INjpfNAT9SFAcZFuZ/zcv5lO0zd0i6AM5VVML3tird
	jr+ZzFY1nRGYKurHINka7k2ah+jijis6cIePNgJ+kT+k7T67C76SRJg7zUXFCJLIkOIGcM/8wY3nK
	BxE3JMWV9McHNXFwwGCAAVq1ripEwsaoDSZrdB4tVCI8XssJ3M/YcMtbW1V2UFlOHrbMtiJDPAvDn
	JY1BK5K56JFe4nhCAAQpRyEipz71TaJL547OD5Odj4GJI6F7xYLU4dLQMqoDrK4fPjeb6pOx0xEb/
	0seyqxtw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wcOpw-000000005xR-1YWm;
	Wed, 24 Jun 2026 10:44:20 -0400
Message-ID: <da460b26bef42152bf23d395f845503ad8eedc4d.camel@surriel.com>
Subject: Re: mm/hwpoison: persist poisoned PFN list across kexec via KHO
 [RFC]
From: Rik van Riel <riel@surriel.com>
To: Pratyush Yadav <pratyush@kernel.org>, Breno Leitao <leitao@debian.org>
Cc: nao.horiguchi@gmail.com, linmiaohe@huawei.com, david@kernel.org, 
	lance.yang@linux.dev, akpm@linux-foundation.org, baoquan.he@linux.dev, 
	rppt@kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org,
 rneu@meta.com, 	caggio@meta.com, kas@kernel.org
Date: Wed, 24 Jun 2026 10:44:20 -0400
In-Reply-To: <2vxzse6ckqfg.fsf@kernel.org>
References: <ajut_LDQGYCShApx@gmail.com> <2vxzse6ckqfg.fsf@kernel.org>
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
X-Stat-Signature: apr4hqiupk9jsqnbbigs3e6uuyu3cdi7
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4DE8780011
X-HE-Tag: 1782312314-891998
X-HE-Meta: U2FsdGVkX19MAWyXSHrpeeIzzy6rtCop5+2Pk8f57Tbxo2idCH5dL9sDvPbIMR9Qr9yIJz6uDdJneKGZRUn2ZPaSHVX8fvf/3Y7IBiRrKzQ2lQfDpFqdgNSvM6nuWhXRoboHTV3KxVcPTIQB+lp/UqAjcniatSGiS3xEgCKtNAduHeW+I36DvM6CbPK3ZRIF1gF4uK6FZ66neWTsoroPJgpUJWUXVT4ffyXkAd0j15W7Bsqh0fAL9c3ouSo3vQOSx6Jb7Hmct/hB/NQIr/pIta8smG5KbqhJrTeAc0tXqbaroqIgBlu+VNGjYtSkytrBMw3ROzX89BNjd6Hwebh4xT9LxDd+t05F/WGPMtYYTPK6eqEgkpKR1Mk6JleJsuCgudkeMfiftDbrg7nq79mIVoXVt8paR+ciBM+ictKAL/Y/0QlgmaeXgLIPG1aGYUgw54fpqyxlWYnKnXYLEdxzf6egfTh2WqFNN5JHm00KuuQXZ+Fb6ZE+qPzwyBF1fB4xG9mEf5quU0d1eoiUkVPLo+Aw10pPjr+czfGjUfCoaAr1xMu5AvFkHwW8Sikoyb3152sk0y+iSKaLjpi3RSvASP4JXujuKL2OlLsNjW1WQ4Fl89zQgwsqH/Gb0Aw7rNRruCAXLq9FCylhfod9McDh08dfnQB+j8n2d53397U7EZu9rmLfNe0EaRmln7AeYmrpN3nIypJvbVGDMEtvmDZqwVnkqqKMUASIyHdf2Hr7bA5GWpWJA07EgEVc4TofzAXiv91/C9b8OImlOHi1KqRSqKX6RyPgudJ+SxfP0k2ht0iDJ+A1EiKjMq41bOWx9e/GDE3MWhEDJeoqluFn/83BsyxZz+hra7OgoiE5B/kH/OxMZucTQcoIf+F79QFUVPi4/XCeXenFUu07Uj0c2auW9SOzwqyK1yv7vwByu8Rqx2RBJTWTWJfSvBRIPPIk4oIelfL0dE0PwAa9CVUu6Oo
 4ssCfILq
 KbF7GEBlKKRKrjGKp1vZn85nt/VYp6/1rXyJGa21+yOJYBIA4Yt/iumFfTkA2cRIAaUAcrJqEZkEuEGL9+cvhLHrRzh1C7qcOqrNim9NksvVGHApABWzRPCKaunt80NuFHoHrg4dRad2ahmE1iozVDiGwMET25ir9SWoLHc6SDPTw3BLpkbSvlK+1tuuhv8ACF0qcK7AHa1pcA2RLZjZW6dkULfWQrlAL3hd40BC/9SYxny1jXcvAcDyw9ZB05EftxFQS2O26WjlLNHG7MjFQ36AUyJjzj9YZB41W481L6/zAejc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-06-24 at 15:40 +0200, Pratyush Yadav wrote:
>=20
> Also, what happens on cold reboot? If the HW does not remember bad
> pages, won't the kernel be in the same position? How does it know the
> bad pages on a cold boot?

Some modern server hardware will simply unmap known
bad pages from the physical page map, so they will
not be exposed to the OS after a cold reboot.

The hardware keeps a log of uncorrectable memory
errors somewhere in memory, for example in the SEL.

>=20
>=20
> >=20
> > This PoC
> > =3D=3D=3D=3D=3D=3D=3D=3D
> >=20
> > =C2=A0 * Makes hardware-poisoned pages survive a kexec, using KHO (Kexe=
c
> > =C2=A0=C2=A0=C2=A0 HandOver) to carry the poison list between kernels.
> >=20
> > =C2=A0 * Producer: hooks num_poisoned_pages_inc()/_sub() - the single
> > =C2=A0=C2=A0=C2=A0 chokepoint for every poison/unpoison event - and rec=
ords each
> > =C2=A0=C2=A0=C2=A0 poisoned PFN into a vmalloc array that KHO preserves=
 across the
> > =C2=A0=C2=A0=C2=A0 kexec, described by a small versioned "hwpoison" sub=
tree.
>=20
> More of an implementation detail, but with vmalloc array, what if you
> have too many poisoned pages?
> >=20

If a very large amount of memory is broken, you
should probably just repair the hardware.

Page poisoning is good for localized memory
failures, but not for failures that extend across
much of a memory chip.

>=20
>=20
>=20
--=20
All Rights Reversed.

