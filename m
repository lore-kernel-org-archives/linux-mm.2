Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D762CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 13:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C2E16B0095; Fri, 22 May 2026 09:55:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36C986B0096; Fri, 22 May 2026 09:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 281B26B0098; Fri, 22 May 2026 09:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B63C6B0095
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:55:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C3215C30CA
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:55:54 +0000 (UTC)
X-FDA: 84795204228.24.0D0BC86
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf16.hostedemail.com (Postfix) with ESMTP id 16CEA180005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:55:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=M91x+LCT;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779458153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P61U7lkls9zN8GrcHqrOCpgQWqKVFEtms/mpht+Mwm0=;
	b=kUVgmgA7VsFLuVAqgo3X6PB4atlLz6A4Kd8ypISNMwt036TOyme1gZpbrEUFXUXeN+JeE/
	QtdoYHFhOF+bTCo1eEMbP+HfPLIN1UntlzErxfYcHlPzqd9l70aEJSYCaIxlSDieD0kywd
	pkls9ZTEzuvWHn2Hb2J2yZLp2WZv9z8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=M91x+LCT;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779458153; a=rsa-sha256;
	cv=none;
	b=GDCWV9hxsFyE7gDwXv8iUDOUpXL5SviyFU0BCLflLMfFcSpMHV9GuQBco2hE8/wFP17/at
	DwY06lLdztY36unGb3827tHHJZJDpBOrXcnrW3PVfpjXR3l6e1qOoJDj2eAlovNAe69IBk
	HMmlaC1v5ZhlZnvkXYvZHq+ukEexFhU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=P61U7lkls9zN8GrcHqrOCpgQWqKVFEtms/mpht+Mwm0=; b=M91x+LCTzySRq8TTvYUZyxpaY4
	3riKnqxhPZc6qI1Lxl3jFmH3ot7B8IXmBFixGUa7+IL4Kl11C1BR4DqI5eqxiW3GCTdrh8a62xQbR
	GqscvWv+Sl7KFbqtqOC+TerCfrN08WwxxoRUEkXxyApZ5/MTrZXjLe6A1YqTsHHqwehcUWFnMuU6E
	UpW0VN2GWG4Vo/r2AOvKIoUAE7RLX7mA1OFzn8GUG74YOYoKnRQ3jgkNZM+arh0BuqDQyBJTm0FBm
	Db5SbsBGHcNiO7D4o00rd4V08dEMIdhFBdPB2yaVszOUXcnc2C9k8d1lbrfniqHsfHuvJfnTvUk2M
	ZP4OS2Jg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wQQLS-000000005EE-3wyb;
	Fri, 22 May 2026 09:55:22 -0400
Message-ID: <424ae0d6da89dcff3ef72711cc2323226e9f6584.camel@surriel.com>
Subject: Re: [RFC PATCH 00/40] mm: reliable 1GB page allocation
From: Rik van Riel <riel@surriel.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, linux-mm@kvack.org, 
	david@kernel.org, willy@infradead.org, surenb@google.com,
 hannes@cmpxchg.org, 	ljs@kernel.org, ziy@nvidia.com, fvdl@google.com
Date: Fri, 22 May 2026 09:55:21 -0400
In-Reply-To: <20260522110257.1640781-1-usama.arif@linux.dev>
References: <20260522110257.1640781-1-usama.arif@linux.dev>
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
X-Stat-Signature: jwp9pnjyqch1oke953cgkpj99isoacd3
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 16CEA180005
X-Rspam-User: 
X-HE-Tag: 1779458152-811073
X-HE-Meta: U2FsdGVkX19mcmlQoyp4dHY37DdQ7UpUsIYaQXYq2S41YDiAvtjM29O+gZDa/x7TiGnth96DrgLJW+J//rj9aoEBiGAkv+0DsqRTebOUsX0R/SZGmPfPu2Td/IlHGln9WI4rCK9ZAJnrJ165tkahXl4k/TEEwRKVDdbWIZp/iWgoPrG+SNxxUaMNl9+XWizagwU7mI4W7IdslyxEsOWJS4fKVuaLs5DWNUX8cPJqB4vrR6to1mj3YLFyyPLKi1Yx9I0uE6N6bXR9U244J2XF7cfSxz9S2o6cKZeOVVFOfoHcWbrwl4lxM/8vDYfljrAXT610+b4RsgQk/uzv9BaAvkiy+4v/quaIh5mwSn8ajHFTREREKXR7sm1G3KTnUUX7v+SHLLiz8rUa9lPlywGp1aLHt9/SapqGd4hkZhcMFykQDb8Y5nVC3iOmkb7NndoaGCjJ3ynwQvBYiXngu4ZByOdw+TN/b1isNe3e+Bdvpz/Fyt8Sqan3Ik2GPCQkuZhfKak/kVSyCz+xJXp/EnMT/bpqjM+nJqCu7DgPqJiaSl+X4W+Ya8Ov5XUSTNu39uDm0JpnU4MP5tGilVjh5TwXrp5aatgTsOXtWzqVTobZL3LvJUtVvQFq6cYU31KWiXuZxqp8cEu+eo+nA27ujZU+7Zp4SdRvG90JBPzrKtHFvbe358HfZ72sCkJf4s9rR6qQ3/VYcoryCbBd2Dwv0vAwEuixMd6ZLELv2hVx71Q97whr4SGFXnbR/9CpUvfZM7NyapuPgB/3tygb6i1kCzVU4VsmthRZjw7F45dTKbRd9jwYJmoE5wE4RIB5xpJaOQCREKui1DSeWmHGKI4mmXm4PLMeaXRIScb/2Lf0UD5zLMiSNKPpyXMOlJkCmUQ3jSaXcn/tAF2dafLN2Qr/jP56m5hxLgOoz0quGSFoep9jZOtMlZbJjLRAAN1klyg/Vpsc3JpXdNW+iEOPmI/HX61
 G2fJWEXc
 BvUkSDJaz+sQQ7ZVB+MSLEw+/PzdP6UdLcGmYG2vTKw5oM9zlgRO7lt8Vmj6vws8ZnCLM8P2PdZqT2AdhLpPLQsVoaJCM0r1Ge074tBxWK7xoVmyvEXtHY+UnTS0RgyXwGOb6/9g6crPR9JjZ4qYGx6LA1xh/vwlSJ7GMlmhobuxn3EmJL4LkW10ZWaAIytUXySd8Dt8f3t/Wxb+pm2/hSNXnMQrBmdi5QAJhxgYAIJvicNCWIqU4zDGGwVysattGTPtAX0Z2C5lX2x5kNWL27JZfog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-05-22 at 04:02 -0700, Usama Arif wrote:
> On Wed, 20 May 2026 10:59:06 -0400 Rik van Riel <riel@surriel.com>=20
>=20
> Hopefully will get to review all the patches. The above one of
> kernel allocations falling back to small pages is interesting.
>=20
> - Will it result in a performance impact as kernel allocations
> wont benefit from higher order allocation?

It might! We may well need a better solution
here, like spilling over earlier, but limiting
the number of 1GB blocks we can spill over into
simultaneously (partially used for kernel memory).

> - Will this impact 2M THP allocation efficiency due to more
> fragmentation of kernel memory?

THPs come from movable memory. With more 1GB
page blocks not having kernel allocations in
it, THP allocations should be easier.

>=20
>=20
> > - movable allocations are preferentially done from clean 1GB
> > =C2=A0 blocks, which have only free and movable memory inside,
> > =C2=A0 starting with the fullest of these 1GB blocks
> > - 2MB allocations follow the same strategy
> > - 1GB allocations start with the emptiest clean 1GB block
> > - if a 1GB block is mixed, with some movable pageblocks,
> > =C2=A0 some free pageblocks, and some unmovable/reclaimable pageblocks,
> > =C2=A0 the system has a free threshold below which only unmovable and
> > =C2=A0 reclaimable allocations can be done from that 1GB block
> > - below that threshold, no new movable allocations are allowed
> > =C2=A0 in that 1GB block, while new unmovable/reclaimable allocations
> > =C2=A0 are still allowed
>=20
> by allowed, do you mean if movable allocations fail, it will
> result in OOM?

Yes, but by that time the zone free memory should
also be below the low watermark, because there=20
should only be a few partially occupied tainted
1GB page blocks.

If the zone has 300MB low watermark, and there
are 50MB tied up in those reserved-for-unmovable
memory areas, it should not cause early OOMs.

I don't know if we can end up in a situation
where somehow the reserved-for-unmovable memory
would add up to more than the zone low watermark.

That would be bad, and if it happened we would
have to add some sort of protection against that.


--=20
All Rights Reversed.

