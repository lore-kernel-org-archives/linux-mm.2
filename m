Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EBC5CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 17:50:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADA908E00E4; Fri, 24 Oct 2025 13:50:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB2098E00C9; Fri, 24 Oct 2025 13:50:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C82A8E00E4; Fri, 24 Oct 2025 13:50:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8BB2F8E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:50:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0476B499B4
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 17:50:12 +0000 (UTC)
X-FDA: 84033746706.17.28C71AC
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id DFE5E80013
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 17:50:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E7QJOx7k;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of gmazyland@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=gmazyland@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761328211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0tKDIn8Dd62bIobWa5FrOxCPkfvj/PGwj/fjdmIbdAU=;
	b=5Xod5prUaFYneiNdaM11QUrQfzt0HK3USDJqSjsrs34QYA0gjiyJY2osqBlPXzbkFiw6Sd
	tdWiKRctRQIKgJajAecI/F6bMgoqSlRye3vkQVLZg1kMKscDZWohk/kBEhe4hOe1joA9s5
	57vCdngo57kBRVY3uzUeVh8uTfrNw9o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761328211; a=rsa-sha256;
	cv=none;
	b=x4MQlX4ZU6lGXHKAuaMD43sQsXUVQn0hjwvPLPqfMeW9A+JnYImWJt1tX4ZyicYWh1G6+G
	jY5uN2nBD9OOatPwv/wCqJPHeXR8QFPJhJsfjDY68R/O+rp8ngRkT7fvY1hjrz7jlx1asa
	DT+ADqRtqWdhXv1Cfuqcca1b3tJSJSU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E7QJOx7k;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of gmazyland@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=gmazyland@gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b626a4cd9d6so477444966b.3
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761328209; x=1761933009; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=0tKDIn8Dd62bIobWa5FrOxCPkfvj/PGwj/fjdmIbdAU=;
        b=E7QJOx7kDBD8kLMrpXVgdX1b9QZ97ZtyqBxzCiFZ4xOsjLJyjhdNWfTR7Ya20knOtB
         AFn3xU/VGq4CA1qQviA4EvjwijjE9HVsTzLZtXpjTFOwK76AB47IEFKsDmGmnEcLdPGa
         MRhUjI0aCVD0Hc01tiEfzJmPDCfOPmOo1X+IGSH1nlnDRb8UVsdy6f1zTQ+hkthp+i6A
         +AKESCRlYnucsL8agJ7Ly+cF3iwskVYV2KM8tAY5mI2y9zAqfLDht9BKrc0j85wsAFOt
         7rL7VnI7HH06m31qhtKaPyIuwMlQIdsaA9I5ldhZjuKprGkMhImh/vboV+DYNXX+vDyH
         vdrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761328209; x=1761933009;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0tKDIn8Dd62bIobWa5FrOxCPkfvj/PGwj/fjdmIbdAU=;
        b=qXHiDJIAJqPscoV6XeWVDlNL7zLqaxiQQDGquJ9m0dtMy6wUmMQpw7IiisXcH5wuWh
         10pLWvynnB/vG1vWE+gZgj5W0LV22buMAPd/ifgHH0zVsSjz1Wc0Z6t+CNRWeGbo3uGv
         wGlsIZOe9BGLK2SpSppg7cWOFUd9kx2akNkx1LCXGp0viRJGy/Wi4QlhWuV3wSvbV/ov
         nFw+QLonXmk58cyVjP7mxUSjFxSU9kn7/3enAQs4scMkg5jvsOfhsNfnwQOZRK29rcF/
         4Ragvx5yaFnWJn4LXQ11aQPolIqQhwiySp+I93oOl6NU78iySVOyk4z60xn5M7Sjk6vj
         MLwA==
X-Forwarded-Encrypted: i=1; AJvYcCVk3xmTgWSdL1VIkLUl4elapoBJzl2oDQu5ufJSuEeDLJ6doAPoT1OBJfwFW7japB3h0jKc8H3ZkA==@kvack.org
X-Gm-Message-State: AOJu0YxB4VTMv2dnxW816jLnhdrNKymeHMKFg/bi0fosGFRn/ffK6WSH
	0UESdP7dVlMQOHUelDXPs6XDFeEiT8oi3B1FFP9wWshhM6NicxZf6PS/
X-Gm-Gg: ASbGncs9530m8GvU2LyYniczFocxwK+Jq8l11fBlcRKkv92zF0ZtP4WxoOPwA0PNMa8
	Vbj1KfOaiSjQNbAvuKMlLvTj2ycyAw0D4VKPtSY3LVJ7ewRYw87SD1+Y32KxSpArL+mys2YEC33
	jn35PPwLv0yYXye8U5wPF70Tt2eImjv4HEFCjXU/+GsfqcptD+ptOFfkCT02NdfOm1WAmhVighL
	N95hxpDyCpJ2T7VtsttqyxRDTyTkWmIuWxkUTt1FLTqoojySHXlU/Dy+GG3k2lAh5EEFqRE3Al3
	ZuhQ2Gi5N59A4cKnmXsJtIXlndmsL7R/a9loFH+h8eEFZSfCi6NO5eqyMfjyW5U0YcHj3J+k+Xo
	m7a8nnn6Tj7WyIz48QyXVIwFbApHrP3f9ASFYNmFiIcvkwxhYPCBCuZ5g6A9M41LLBnYqHe8geb
	ULRAbi1XA+WcFEKtHhM4qxh3oFP5VHtj8iyjsagEhK
X-Google-Smtp-Source: AGHT+IEHVSSj7rXjwYMoHcZH9vR/vm/UDZA+qYlFM+r0okKL4IfHGOhTECkjaHomhCRDjSe3Dq8uEQ==
X-Received: by 2002:a17:906:ee89:b0:b47:de64:df26 with SMTP id a640c23a62f3a-b6d6ff25f61mr303261366b.35.1761328208958;
        Fri, 24 Oct 2025 10:50:08 -0700 (PDT)
Received: from [192.168.8.101] (37-48-18-87.nat.epc.tmcz.cz. [37.48.18.87])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d5144e4acsm585057066b.63.2025.10.24.10.50.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Oct 2025 10:50:08 -0700 (PDT)
Message-ID: <5e0056d7-3550-4c40-a698-c09535d32bb2@gmail.com>
Date: Fri, 24 Oct 2025 19:50:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: dm bug: hibernate to swap located on dm-integrity doesn't work
 (how to get data redundancy for swap?)
To: Askar Safin <safinaskar@gmail.com>
Cc: Dell.Client.Kernel@dell.com, brauner@kernel.org,
 dm-devel@lists.linux.dev, ebiggers@kernel.org, kix@kix.es,
 linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-lvm@lists.linux.dev, linux-mm@kvack.org,
 linux-pm@vger.kernel.org, linux-raid@vger.kernel.org,
 lvm-devel@lists.linux.dev, mzxreary@0pointer.de, nphamcs@gmail.com,
 pavel@ucw.cz, rafael@kernel.org, ryncsn@gmail.com,
 torvalds@linux-foundation.org, Mikulas Patocka <mpatocka@redhat.com>
References: <a48a37e3-2c22-44fb-97a4-0e57dc20421a@gmail.com>
 <20251024163142.376903-1-safinaskar@gmail.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 xsFNBE94p38BEADZRET8y1gVxlfDk44/XwBbFjC7eM6EanyCuivUPMmPwYDo9qRey0JdOGhW
 hAZeutGGxsKliozmeTL25Z6wWICu2oeY+ZfbgJQYHFeQ01NVwoYy57hhytZw/6IMLFRcIaWS
 Hd7oNdneQg6mVJcGdA/BOX68uo3RKSHj6Q8GoQ54F/NpCotzVcP1ORpVJ5ptyG0x6OZm5Esn
 61pKE979wcHsz7EzcDYl+3MS63gZm+O3D1u80bUMmBUlxyEiC5jo5ksTFheA8m/5CAPQtxzY
 vgezYlLLS3nkxaq2ERK5DhvMv0NktXSutfWQsOI5WLjG7UWStwAnO2W+CVZLcnZV0K6OKDaF
 bCj4ovg5HV0FyQZknN2O5QbxesNlNWkMOJAnnX6c/zowO7jq8GCpa3oJl3xxmwFbCZtH4z3f
 EVw0wAFc2JlnufR4dhaax9fhNoUJ4OSVTi9zqstxhEyywkazakEvAYwOlC5+1FKoc9UIvApA
 GvgcTJGTOp7MuHptHGwWvGZEaJqcsqoy7rsYPxtDQ7bJuJJblzGIUxWAl8qsUsF8M4ISxBkf
 fcUYiR0wh1luUhXFo2rRTKT+Ic/nJDE66Ee4Ecn9+BPlNODhlEG1vk62rhiYSnyzy5MAUhUl
 stDxuEjYK+NGd2aYH0VANZalqlUZFTEdOdA6NYROxkYZVsVtXQARAQABzSBNaWxhbiBCcm96
 IDxnbWF6eWxhbmRAZ21haWwuY29tPsLBlQQTAQgAPwIbAwYLCQgHAwIGFQgCCQoLBBYCAwEC
 HgECF4AWIQQqKRgkP95GZI0GhvnZsFd72T6Y/AUCYaUUZgUJJPhv5wAKCRDZsFd72T6Y/D5N
 D/438pkYd5NyycQ2Gu8YAjF57Od2GfeiftCDBOMXzh1XxIx7gLosLHvzCZ0SaRYPVF/Nr/X9
 sreJVrMkwd1ILNdCQB1rLBhhKzwYFztmOYvdCG9LRrBVJPgtaYqO/0493CzXwQ7FfkEc4OVB
 uhBs4YwFu+kmhh0NngcP4jaaaIziHw/rQ9vLiAi28p1WeVTzOjtBt8QisTidS2VkZ+/iAgqB
 9zz2UPkE1UXBAPU4iEsGCVXGWRz99IULsTNjP4K3p8ZpdZ6ovy7X6EN3lYhbpmXYLzZ3RXst
 PEojSvqpkSQsjUksR5VBE0GnaY4B8ZlM3Ng2o7vcxbToQOsOkbVGn+59rpBKgiRadRFuT+2D
 x80VrwWBccaph+VOfll9/4FVv+SBQ1wSPOUHl11TWVpdMFKtQgA5/HHldVqrcEssWJb9/tew
 9pqxTDn6RHV/pfzKCspiiLVkI66BF802cpyboLBBSvcDuLHbOBHrpC+IXCZ7mgkCrgMlZMql
 wFWBjAu8Zlc5tQJPgE9eeQAQrfZRcLgux88PtxhVihA1OsMNoqYapgMzMTubLUMYCCsjrHZe
 nzw5uTcjig0RHz9ilMJlvVbhwVVLmmmf4p/R37QYaqm1RycLpvkUZUzSz2NCyTcZp9nM6ooR
 GhpDQWmUdH1Jz9T6E9//KIhI6xt4//P15ZfiIs7BTQRPeKd/ARAA3oR1fJ/D3GvnoInVqydD
 U9LGnMQaVSwQe+fjBy5/ILwo3pUZSVHdaKeVoa84gLO9g6JLToTo+ooMSBtsCkGHb//oiGTU
 7KdLTLiFh6kmL6my11eiK53o1BI1CVwWMJ8jxbMBPet6exUubBzceBFbmqq3lVz4RZ2D1zKV
 njxB0/KjdbI53anIv7Ko1k+MwaKMTzO/O6vBmI71oGQkKO6WpcyzVjLIip9PEpDUYJRCrhKg
 hBeMPwe+AntP9Om4N/3AWF6icarGImnFvTYswR2Q+C6AoiAbqI4WmXOuzJLKiImwZrSYnSfQ
 7qtdDGXWYr/N1+C+bgI8O6NuAg2cjFHE96xwJVhyaMzyROUZgm4qngaBvBvCQIhKzit61oBe
 I/drZ/d5JolzlKdZZrcmofmiCQRa+57OM3Fbl8ykFazN1ASyCex2UrftX5oHmhaeeRlGVaTV
 iEbAvU4PP4RnNKwaWQivsFhqQrfFFhvFV9CRSvsR6qu5eiFI6c8CjB49gBcKKAJ9a8gkyWs8
 sg4PYY7L15XdRn8kOf/tg98UCM1vSBV2moEJA0f98/Z48LQXNb7dgvVRtH6owARspsV6nJyD
 vktsLTyMW5BW9q4NC1rgQC8GQXjrQ+iyQLNwy5ESe2MzGKkHogxKg4Pvi1wZh9Snr+RyB0Rq
 rIrzbXhyi47+7wcAEQEAAcLBfAQYAQgAJgIbDBYhBCopGCQ/3kZkjQaG+dmwV3vZPpj8BQJh
 pRSXBQkk+HAYAAoJENmwV3vZPpj8BPMP/iZV+XROOhs/MsKd7ngQeFgETkmt8YVhb2Rg3Vgp
 AQe9cn6aw9jk3CnB0ecNBdoyyt33t3vGNau6iCwlRfaTdXg9qtIyctuCQSewY2YMk5AS8Mmb
 XoGvjH1Z/irrVsoSz+N7HFPKIlAy8D/aRwS1CHm9saPQiGoeR/zThciVYncRG/U9J6sV8XH9
 OEPnQQR4w/V1bYI9Sk+suGcSFN7pMRMsSslOma429A3bEbZ7Ikt9WTJnUY9XfL5ZqQnjLeRl
 8243OTfuHSth26upjZIQ2esccZMYpQg0/MOlHvuFuFu6MFL/gZDNzH8jAcBrNd/6ABKsecYT
 nBInKH2TONc0kC65oAhrSSBNLudTuPHce/YBCsUCAEMwgJTybdpMQh9NkS68WxQtXxU6neoQ
 U7kEJGGFsc7/yXiQXuVvJUkK/Xs04X6j0l1f/6KLoNQ9ep/2In596B0BcvvaKv7gdDt1Trgg
 vlB+GpT+iFRLvhCBe5kAERREfRfmWJq1bHod/ulrp/VLGAaZlOBTgsCzufWF5SOLbZkmV2b5
 xy2F/AU3oQUZncCvFMTWpBC+gO/o3kZCyyGCaQdQe4jS/FUJqR1suVwNMzcOJOP/LMQwujE/
 Ch7XLM35VICo9qqhih4OvLHUAWzC5dNSipL+rSGHvWBdfXDhbezJIl6sp7/1rJfS8qPs
In-Reply-To: <20251024163142.376903-1-safinaskar@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: bptptmz98mftrgne5xaa5e53gytkhn4h
X-Rspam-User: 
X-Rspamd-Queue-Id: DFE5E80013
X-HE-Tag: 1761328210-4711
X-HE-Meta: U2FsdGVkX18eE68GPmjgSOVv6dNt29az7pfUL5Mg4a13iY48ent6Cjb68GYK/01Ev7XreiJPA2nXWBd3i686JEQCZseG/tjUSlZEfLC5c0bG93OYPumDuWz54tLsJXTFAqwBVeApy7Qh/dlIjvYrzUdxNm49oSpSz4szSxPv/oBLruTOsI4zYRDjq4Zr2Mfw0LlbH/WXt9KYKZh5TGkXV3fdvXZVNcEJb9UYoQNOlRHuFrMcAllzWCjGuArtoVvSVbRkSGUDs8L1+ZoBnatWlp4ACNy5VpoKmpsSr3R9puVIXryNP4ymmHXBE9IubQ6KatrKgViESDHMTa7ttaAAq+kgwRsrDrCdFVBuD+hEhqlh9Jwkm4YkIq7QN0Nwdj+pxVpY6ve4b6vMTYqdYrdIr+wLrY/V899uO9Lruwh4gRgCfeDkYXwLH4cfrOyOlKEecF7jr0s/ZjtHRVYLghQWaFuh3/wGu07G6K7UGD5LMpGAngdWOjIZX9u1DfGsac7NB3jALepJhfdod4hRnGcHvmGy7kPyMXjdwLBCzXRbQ1hlzeCm9AFMzjuk1GFjg7QNgvqTzdPw1gWw4UtoX0HZvmko+b9aLPIMGkfiD04ycyiXPCJKhAYnrr3dJhHJjIzByY3rdrL+HvWExjmvI0+kitEdaeQCgcxVHhAoIWxf818VYlzxCS3sdwpOZ4Djis7RUxHWyLAf2g8T5NaEcZ4pIRlayIoVk2i7olxlt3JC5vxGKAOqdX3A/NzT4xfwlzuRYAARKknQ4oXGiq7kLTIqvCdZqFsvOR6+PLlwTL2bxDVMAm/Vs9tMI5pVJ3N2MPOfFl5+18FJfRts5fAPVZ/HqC0ffv43SobNKeb3Nxi7x2jjdg8fIBf+4LTSbxcH8leCG81W+y0QxiWpW8liteCRtxex2ERt5gSGnX9rrOAa8/fV85h4MAFbeJjlW5bk/ZL0frL9P09vCaqa1Jlu3ER
 2RdARJXG
 Kw9BicBzZM6uVmr77AhIN9WUDu1RP7MW/bHU7mO0Dldsyh/wCTczeOZw6Apx/nbP5Kbp5a/BasYRavgk9/DxiPYSHGX5iASX8T6AQiZxji+ChBDgmBDtybK0S/PRWf2i3/A8MkWEoD+1CmopqYwBq+y7Vc5E1/plpmTXMgYEgy4ig+WaQQA73zRiJQPMIdgw7j1phAIQcZhrq78/4waHQly1hQslqkCJN6LAkcv1Wbgzr4Hls+Cjgr+VdDsFfMMJgjzCrg5+DHPNHGYRcjCHqYQmq981Kxj/n3kTB6if+JuHSB9gatxFSIcp5lcmiasOFka8yK920/BWzFmQSTnGiT+YfoZMYLLfTcTKjctabBh90RecwsXZ3tI1ZB5lSjS1bSJ8YLdPv/9wAIQd0s2YGxwkXD11iKlMQEMmnmP/7LBkS7bsssKUH+zHSa69HrI2TU/fq99DW4pMh+I0ZtF/OiwXWCOfF0KP/6CxOfeUungg8+DJvPVJw3yXneDzk3U1a3/xLCHPPtTHyz15XYFKJliJu3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000004, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/24/25 6:31 PM, Askar Safin wrote:
> 
> Also, I saw patch, I will test it later.

Yes, please test it, you can ignore may previous comments as they are irrelevant now.
Here is the link to the mentioned patch:
   https://lore.kernel.org/dm-devel/03e58462-5045-e12f-9af6-be2aaf19f32c@redhat.com/T/#u

I think that the issue is clear (as found by Mikulas)
- DM device (dm-integrity here) does not receive the FLUSH command here.

This would explain all issues you see. If the patch works, it should be fixed in stable kernels
as it impacts other more complex storage configurations.

Thanks,
Milan


