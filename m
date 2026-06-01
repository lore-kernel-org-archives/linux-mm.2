Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90BD9CD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 08:39:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2A336B02CF; Mon,  1 Jun 2026 04:39:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDB3C6B02D1; Mon,  1 Jun 2026 04:39:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC9DD6B02D2; Mon,  1 Jun 2026 04:39:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC4E76B02CF
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:39:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 31767140601
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:39:42 +0000 (UTC)
X-FDA: 84830695404.15.A7557BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 30A4F1C0006
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:39:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BIajcTU1;
	spf=pass (imf21.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780303180; a=rsa-sha256;
	cv=none;
	b=agNg7ZgdbeeJxaNo1JB8KZW0s+gEq+ukYAzCKG/sKroNiTmvo9ZtoffzvHlDDw3lONK6Nb
	l2XFTLItbjQUoHwI3Ny4agW6w7XZqFOekSxIXBjntrzya/Mg47AtUT92u78u3ExJrNtsXq
	xAT3kmLiguh28f0ziA4WGHGZtvi+aGs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BIajcTU1;
	spf=pass (imf21.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780303180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mHwvm0ceQ16bc0KPGoKmLlizlFpB9HdRz+GeUdDPkMs=;
	b=hPNwIKGtKOgV8zl7KXVWBACy3XCki1no+iAHEbuua23qtucHMbnEW65hOwckMqmIWr8gmz
	XG+klBHZpuCfPyytJoMaNpNEUfS0WV9MTdp1h6rKQzQvelXb0/oDh6Elm5r8mr5uxBJEQc
	Ylfc08Q54+w+EGs+FV4UOYRRqcNZAwM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 54B3440433;
	Mon,  1 Jun 2026 08:39:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323671F00898;
	Mon,  1 Jun 2026 08:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780303179;
	bh=mHwvm0ceQ16bc0KPGoKmLlizlFpB9HdRz+GeUdDPkMs=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=BIajcTU16E6+znd1woyWqwS+BBAXycYib81QTECMvG/hOX7aZ/uAFzUwcG45xTfmE
	 tf9W8LCSvBW58JUM8ZTWSrrXbLk0LG/A9CbVmZDLsUnNcIKGjoSFHcopw37zuAQt6y
	 RIY9JP+XwgZ5srpA1V/U8jYqz9skUUFQEayYx+3cQ8cSBbgYMpZL7YB6RZ+WvHuKNl
	 xobhQrpcyjJAAEcf6rM17filotw9MPbTMYAvB8r+SlaKWN902CDEBOWqHYS62X36aE
	 PcZxo0yOoyvxuNXSnl1mzVQ0fQljIeH4pq619zUO14fnF4R5pDVaQp4lvtAdeXReT0
	 dQ8dGv2+1ro4g==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 50A6FF4007F;
	Mon,  1 Jun 2026 04:39:37 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Mon, 01 Jun 2026 04:39:37 -0400
X-ME-Sender: <xms:SUUdatExvFUiJvS4G-rzO5_b5_EVmBhCXGARrlUlPj68OMh2yNTgcw>
    <xme:SUUdatLPHZy6k7_jINeuCht2x1mIk3Xr7QLvpOruxv1mcZD7GTPOuGWVZwlv6UYag
    OjFQQepcx8WzwRHCk-aGrvn_hm4_qXnHUJ8uPUX6RNK62HXeHqgHAQ>
X-ME-Proxy-Cause: dmFkZTFDC9Qzla6YzRXCvg4qTqKRR/eKrKImym43jg5ea5Q5vrrQ+EjGg3N8fUKPpOxQR7
    TVq7XrIvj0z7DAz3z9X/juKhZVusgVnRCAtCCeFytlNFAPMtvvDQ4+dCYC6Q160toXzz4S
    XcVkttubPD2UxW685/k+uwu828S96nFll5al0jdDPfemCpkea8rdrbikQF2sFrnI6Lx04Q
    ONcYXSZ7HopdtHuW9piPefNoaIy7sVQliTdskqwc8awOiZFnU9Huwjva5c/7y1USlJ5DUY
    k6FOaBFlQ2WNslwPaZEZYp/rw/tHbsVDON310YOAcdFHjy7Nk82hy9tZEWwE6x8YVDQlsz
    Er9z8/znGDaObvUGVeBIVOThm1t//PeZFcWtIXC0I8cmehM+jGn2DjoVIYSv9Bmez6tW/2
    lKEfzUiJm3ZQGRDPcgLG+ZMhTLydaOy+jpqN+Hnf2ZdB/T1FYFwgfkHnjgZvpC5CuiX6I2
    pIW+EqzFuec7aoIebcI5qyLXKhUbZEinA2uMEBOaMiyZVdD8y+gienLjiqOTf5L1gLH7gf
    t0NN2Fa2xUvmh4ar3+IiUQfv23rHvlzmcKEdNU4pTV3DTTP+Q8FlIOlCllFOZLg9GdTvDV
    f3mzdtyp9oqq0X+BVt1UaL10E9dRrpHGrvPsGXG9iqiktxH1IMmSepCxh98A
X-ME-Proxy: <xmx:SUUdaksQVW8_jeB3xtl55BBVE34hsX-8-aoaNg-2HQRD8qka9ZCW2g>
    <xmx:SUUdaojoWqOJ6zjg3Jg09dGqN7viRHsj2OkvQbp3YK0wAlvQJAV0nQ>
    <xmx:SUUdandTyZF7vDk-2CIxFnV8hVemnNQPBzQP3G9OX0GQCEEev5E94w>
    <xmx:SUUdatkneOE7eIzV7ZeRu8vDWuDJM4tccORPy20Qvw2xd6aPNz7ZQA>
    <xmx:SUUdahr7u1yNhqmOzp1lyByGwuiaShMyl1FtwhEyBnqzzuX7kRi1Uf9R>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 1EE0A182007A; Mon,  1 Jun 2026 04:39:37 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
Date: Mon, 01 Jun 2026 10:39:16 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Kevin Brodsky" <kevin.brodsky@arm.com>,
 "Ard Biesheuvel" <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, "Will Deacon" <will@kernel.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Mark Rutland" <mark.rutland@arm.com>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Anshuman Khandual" <anshuman.khandual@arm.com>,
 "Liz Prucka" <lizprucka@google.com>, "Seth Jenkins" <sethjenkins@google.com>,
 "Kees Cook" <kees@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "David Hildenbrand" <david@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Jann Horn" <jannh@google.com>,
 linux-mm@kvack.org, linux-hardening@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org
Message-Id: <a371089f-0d01-45d6-84bc-1fe0d78ebd85@app.fastmail.com>
In-Reply-To: <69488547-cf2a-4aa0-bca7-0cb65aa01914@arm.com>
References: <20260526175846.2694125-17-ardb+git@google.com>
 <20260526175846.2694125-26-ardb+git@google.com>
 <2a6f9f05-ac57-4ef8-9328-74cc8ccfea16@arm.com>
 <96a8b6b9-71f2-4550-bbbb-fbfa146f4e6a@app.fastmail.com>
 <b76b327f-612e-494f-b8d3-44108aa73d2a@arm.com>
 <feab72b8-2961-4145-ac5c-80e820bf1ce9@app.fastmail.com>
 <69488547-cf2a-4aa0-bca7-0cb65aa01914@arm.com>
Subject: Re: [PATCH v6 09/15] arm64: Move fixmap and kasan page tables to end of kernel
 image
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 30A4F1C0006
X-Rspamd-Server: rspam03
X-Stat-Signature: on5mwsmi41qugsx16k4eqdsqetsagxcg
X-HE-Tag: 1780303180-884049
X-HE-Meta: U2FsdGVkX1/CQn6fTUBYAD96mcSeVqUz2Ge7eoaK2p9hcMtTQjP7fumsmoPhdDYheem6j5anOQ3vFOwMwsP21DqUuWCKKiQBaehHDomBBcyKoFlIxNisJJUPqYAgX2sDogXowsUtGjIr9j16uyMEQTa6jhuHLlwJcw9RjG8voewm0MGdIL5P3fAFn84LyZAqlL2t4C8H2DoTfX5lo2KYgDPkRNZ/4CKPi2cSL1IhOiCkyaAYLP0fTGKBBtpyFxQL2phpi38wjS3EEC4Asjom+Fqy6xw6sXJCo5Dlfnp7QcxwrMvJx4Gdt4xrjz3oKbyVjHYZ0Md2vqNNewwi5wJbeVHvMGg7ZXAVDFo6jes9J7FxohKh/vbFbP6XJjsCirJ1M+HYuW0d9mV+GWgJmCxd3rOhsJ1l4zBQYvBG7Ob9ZXPjwHHyOn0HA2fqzk8mtpqxpnpdyZhG8JiNsgLBlOgB/flATlkWv7RObKW47+NweA+dN5lJu/QRKfRSfLo/fomcg9lRBUL2f/Q1lcyL2jZrilzaDNKeYtUkqGAiH4Op+AoZ6Mu9Y/47JlusRmksKrSbDLevIFWXjoo0cv86XE7qI18QygqBVUnEbQl8Vo8sN2nPCgV4rnbyAMPofhD6UTRpIQBOnR9BS23GtUySEgg/oYNBwCmTWe06ZbG50dMUpng9PLr0au+2XM10H0QglvDXUv3GiXRJyoZN+3XLiI797xftH0yrQInKwAjprHWLuNtwUMjQ45Vs0CJsIO9Eg0z1ftHK0Qs5e+tE9k9sdxmmhVAGSIa6IeTmWgIaFTk3YRWU/yeRcm75jGxStl9NJPdG5VchnqYwot0enOVIVpyOnqi/qgw4wQ2jSrZNgkshSgRqoCOBttC/5PmWc11DkdXgKI1VxZiU976NriROSu7qfz+h7uwZgw3WUCudc1V5fCYtN8P5e7MvZ2Gb663S6cy9EwSEDU7nXV5ICdtMCVG
 5tGuq7fX
 ebilR1G9nsG87xKun1yGp9VNSOFzSyxiBT1vKpKt6xoqFflBbMh1UILvKsT0eHlmGb6xYpdcG6PywVOpiBLPNbIbU0Bkzk8DAhJ50k0orp2bCrneMfDEgHu42yj2aJMsXfN9IzQufScf0jz80MdhZP3OhR6Nr5dkfkOOcUcqn8qCf4afDzv7+B5G0RnTm73+8uU3I0aIz8T2HtVOL766qJhrrcYv/ysAgZILRIfSn9JP7mng6EaOufUE1voLkW1fGSd0453yvMmwzfb9SKUjVW9a6o8cgut6zBooMoQUb+oI9v4i9JZaUMM88WFIR3H+5KF77
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, 1 Jun 2026, at 10:37, Kevin Brodsky wrote:
> On 29/05/2026 16:47, Ard Biesheuvel wrote:
>>>>>> +	/* fixmap BSS starts here - preceding data/BSS is omitted from =
the linear map */
>>>>>> +	.pgdir.bss (NOLOAD) : ALIGN(PAGE_SIZE) {
>>>>> Do we actually need the NOLOAD type here?
>>>> Yes, otherwise it is emitted as PROGBITS, resulting in all of BSS t=
o be
>>>> emitted into Image.
>>> That's rather strange, aren't the .pgdir.bss input sections already
>>> NOBITS since __pgtbl_bss is only used on default-initialised globals?
>> Not sure why, but the section was PROGBITS not NOBITS before I added =
the (NOLOAD)
>
> I've had a closer look into this. Similar sections in other
> architectures are all named .bss..<something>. If I rename this section
> to .bss..pgdir, then indeed the compiler does emit an object file with
> that section marked NOBITS:
>
> $ readelf -e out/arch/arm64/mm/fixmap.o | grep bss
> =C2=A0 [ 4] .bss=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 NOBIT=
S=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0000000000000000 0002ac 000000
> 00=C2=A0 WA=C2=A0 0=C2=A0 =C2=A00=C2=A0 1
> =C2=A0 [18] .bss..pgdir=C2=A0 =C2=A0 =C2=A0 =C2=A0NOBITS=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0000000000000000 000750 005000
> 00=C2=A0 WA=C2=A0 0=C2=A0 =C2=A00 4096
>
> And then the linker does the right thing without having to use NOLOAD.
>
> I was concerned that .bss..pgdir might get caught by BSS_SECTION(), but
> it seems that the double dots are meant to prevent exactly that.
>

Thanks for this. As Sashiko appears to be making me do a v8 anyway, I'll
rename the section to .bss..pgdir too.


