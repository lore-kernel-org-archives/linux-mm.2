Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 180DEFCE082
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 13:44:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A9E76B00A0; Thu, 26 Feb 2026 08:44:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57D996B00A1; Thu, 26 Feb 2026 08:44:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B41E6B00A2; Thu, 26 Feb 2026 08:44:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 354206B00A0
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:44:08 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DBD981B5751
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:44:07 +0000 (UTC)
X-FDA: 84486726534.27.1B20F05
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	by imf15.hostedemail.com (Postfix) with ESMTP id DAEFBA000B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:44:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=a1olVQSt;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772113446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RiW9GHemN6Ann66iA0XbJEcnWOl2O4mI5KnopxyGsJg=;
	b=qAQxk6EZJQTLF+DPisvtmhz5c96S//XU3crUdMs/FQmFXTpFUWIfcFAXO7OoEU0EOju//I
	/bnIkkerL6zkFpkE6nqfksEWwVN2vWgCWH2SVGCoYqgqmztpOtTqOygg02y+IDaipsZq3x
	YEFJJ9vQEBuUQEAFLYvbuguRU0xvv1g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=a1olVQSt;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772113446; a=rsa-sha256;
	cv=none;
	b=lyhS5d6Ve9USK/NfIliSfN/aRh3bAN51vcVSjmLYP+ECBRrleyJNr+3IgJfV7pBvgo0T0U
	mGnvSxa5rap8MksQhm146Hiz42c9yg5kJGOWA6E4mBosXwsnpb+7mYcBybp8Gwtrq2GpCd
	Do6OYDx4VCJ2GVZpd7L5Xqxi6Akecec=
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-4830f029407so1641075e9.2
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772113444; x=1772718244; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RiW9GHemN6Ann66iA0XbJEcnWOl2O4mI5KnopxyGsJg=;
        b=a1olVQStVTuuOfmJBFHpkc+ohbxDhnSm20p/9ULXev4jNHxUvHc40uhg/RM9bfJSQX
         b2EKKxu2qgH6kjy1lNP9xI+7SRtsNeiozEc8w5geVlcuezxR23e5EQhSYrrLI/cwQJii
         SlPERFFlGIrPXdD05l6/uz4dKW39h5kjYMgq9Oo23v43SBp0lGPUsq3eIrfQ+h8xNIaF
         /dajcYpyx/YHWMrKESmFpgTrkEVq7VeGWV330fdhlnJCBjwdgM7yi8edTerTKrxx41b7
         WgSLEFEoNqEvaXd+nI+V9JUGUS6WmRsK8FNTL+DSNEt3ryvWvoqmoho7oKMZiOEF9Sn8
         Ikkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772113444; x=1772718244;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RiW9GHemN6Ann66iA0XbJEcnWOl2O4mI5KnopxyGsJg=;
        b=DhUQVf1lHz9iq5eUmRVIJ78+tM/UOlBJ0SndnfCFL64i/213MsY7CDl3tXskNZP/dB
         C92yqAJcKaG5boLRDKFFm2FSb4kIEXgao2dSvxmaoR9Fhl4c59M5dMJNPKHJSOrJSo97
         VZenRzmRkePNySJGw5h2CKlHXNoYqIaqMf3R4MFsc+lAWcXla34mu5bjtpvJFFEHIYy5
         91PVwbCT/Wety3ljwqea2kTU97G8dK6grJLvMbF1C14DRMKR3PvmyvlwPjyHsK01f3yb
         xrIMf5kX6z0TXGu3/MHM+cWliKDEMug0/zd2lMC55XO4Wv3jCofratSYXybEtlGKyUOK
         j3/g==
X-Forwarded-Encrypted: i=1; AJvYcCWCZ7MQnD2VwOq71TYw34rDr06P1G+x/eLI0OGdRmTlWd6H1nrW7yDTclOuGHrCE1Vpxkti9W4jJg==@kvack.org
X-Gm-Message-State: AOJu0YzdSm9g/4gcSmYxzbBg53q1gHFoNDXB5XkqTzZUzVxZrXEQtHpl
	uV2Vcw1j+n+Cp4CJP7uf2SyJiSrLQlHm4sbaese6EgQGVJRFMLflyctyrDSsnz5bFro=
X-Gm-Gg: ATEYQzyHbuZ2fjYFLq84y3Q6z3ZO/p06Fk7W69MNuyuATJkJAws4a2yOjL3IBzSPje0
	u5jWCFFGPRrbDGfngfgWvlo7z4MPq7RzFj2n7iMcyV9J9SwQ4Aj/VUVEO5gQOJlfFv1UAMCz9EK
	jPVhxPJwUW1nx5R4avYU9LJf/Wpbhwipe4kWWoPiufZT5DIDZ2BXADnlP74bmWxgbVfxspIPSJ1
	N+UGoPUfCsgoik0EJTtEsQd1SVe4U2wP0NYJZ15PoRi6YXy76Kbco84FfcokhRCzqq29/Z904GM
	ZzUzmy/XSMtTp2rhWjTMhKy/ev7EIPQ4k2q/2bJnEwvzfWq1HAPOGHP4GvzFpRjWTUeXJQXRV6q
	RlZrNnZnPIOtAbLkilyp3cYhYussrpp4Wlv+I5XT9QLwtXLanKXJZI3DyDQRFs97zjy98UTiZfh
	Y5IkQjA6YG08vkGIzTZ0gyymfV7dH/Vtvnwkt17rnxedUE2f0izNLZpwZcjhe2vm00l8VP
X-Received: by 2002:a05:600c:34cb:b0:477:a16e:fec5 with SMTP id 5b1f17b1804b1-483a9555ad9mr192713905e9.0.1772113444133;
        Thu, 26 Feb 2026 05:44:04 -0800 (PST)
Received: from ?IPV6:2001:1a48:8:903:1ed6:4f73:ce38:f9d4? ([2001:1a48:8:903:1ed6:4f73:ce38:f9d4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bd6f3124sm141938035e9.1.2026.02.26.05.44.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Feb 2026 05:44:03 -0800 (PST)
Message-ID: <e759dd9b-0857-4155-b570-cd002155f123@suse.com>
Date: Thu, 26 Feb 2026 14:44:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] memcg: fix slab accounting in refill_obj_stock() trylock
 path
Content-Language: en-US
To: Shakeel Butt <shakeel.butt@linux.dev>, Hao Li <hao.li@linux.dev>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 vbabka@suse.cz, harry.yoo@oracle.com, muchun.song@linux.dev,
 akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260226115145.62903-1-hao.li@linux.dev>
 <aaBM0fN8fqER7Avf@linux.dev>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <aaBM0fN8fqER7Avf@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: DAEFBA000B
X-Stat-Signature: oei8rowq44smpqd411wgoumauftxrfgb
X-HE-Tag: 1772113445-852348
X-HE-Meta: U2FsdGVkX1+W+C1F3gCYZOmJFIxGOYonXV+Q68iMaty/1NBMqadguCpYfEoyYYoCgU13jkPYgEVlfE5rCVEvo9GS7nYFIAmH2mB74eMBdV1JWTL5B74NI3KdXNNkJL+gEccXLlhIuBAKO41OCKCgZCU1E/O4brptgZB8CCQFeT+7t4xutBy2cihwP6ypBFuIALq279Wpqxj6ZTh8SkBYGsCIP5qWdxJMAj1S+YHIWTiRqMP9SNWsy/QJ1LenrvUFZ8WrMxHdgf05X5HXSREXPall6nHNwNMcEvQUZhDk2MbGRv9OroossIr0SR4byCfbTuhfhHKU5NYukHXkVv6ECA5IhprbzWRYgysxBBU+LssHqV7CM7AcRaJPdWGN8O1qVXRC98rLkSAxFtTB6vpyDI1AQL9n8nQumovp6IcHc7iN8IUpAWT/g6eRXvDCXyEG2osqARzEhiSEu2DkzcaLQfyLYFds1nIGDhQ3ccEkamihiTORdyjY3ZWrLm/JuDgtjWCuV1nIYunW1I99948GVQBYfqkWPizMuu1Ir4nMmi7bl30lqddJTNk91B7AuRkfJ7QbEKbmGjNfrqvZqjVy0B4cr2hQg1opfE0N7Q8eD0VRAnQ/4ljrrU82C9SjruS94rTsbfazyfn7Op0UvVdWhOEDaliEvPSRZzNIWp0WD4CGk6COmQObDKEyT//BC8RVyuJRCYoWCFxcPrLkTg37rOYAchiRyKtYLICb6XQ6rSRPvHQQrAXEFSN9EFIt33vs5Z1Y+0uk/YgTMDSRPqwKfi/1GVQW9BnzeA7UdAUZ8yjgMoYBfg4LksFcwYEWLTLhiWezfu51y/PMkKnQZW7uGKO5SuK+uEdslnd8GpR7J705uUeDHamxJ/5vp0Ququxrx6kIoEcxkIHzokKfcmxErvP4uahSnzi+GtMl5uiRqwlYGmD3yhhCIntKUKWBEP9AXofIv7x8CNS3loYdzoU
 I543ZP0l
 cdFAskVCpwPicL6hbC72HfHXCTr1cZtb2bSLVM8bQVfuH+66XfcLH9YedORxyiGslx9sJTARmVXvaBKqIQATg7IiMHOfnofI4Ly0Ulpqo5+ADzIIL5v0nCRhlD45wCGkyhFD7qSszsK23xdMy/VE42miCDrFibIjg+OWnqklLdgDKM5PT6I6Jew2JbMwBgBUrjBoAWmiLowriHhp7ZRk5vtezZSMjqCy+Fg9zWg3y3G/d4LdtB+blEKkLqF2ay4SHCUZ4ZJuExe1QGGmJUUW1QaogsNGcBOrrcp33MP0bkxGl7527i7yrpzIWVAIDZKanUexSo8Br8qOvL8L4ZodwCJvbsqykkgVGv/IqLWTn+iBXIWC7ojZoz/fZ4Sih7/dT4Cz1KyNl4S9Kf8KpxSxBck87nXfUB87koqSJ4ifG+/JmpiKijkkeTMEIWCv/B9LTV8FM8Rc6oYZPI+HlekogzaPPyo9PuRaP+U9Lgh7fUxkxxkEdKDM3G4AmiwcfY3tV/sphsGXxJDzTqBg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 14:39, Shakeel Butt wrote:
> On Thu, Feb 26, 2026 at 07:51:37PM +0800, Hao Li wrote:
>> In the trylock path of refill_obj_stock(), mod_objcg_mlstate() should
>> use the real alloc/free bytes (i.e., nr_acct) for accounting, rather
>> than nr_bytes.
>> 
>> Fixes: 200577f69f29 ("memcg: objcg stock trylock without irq disabling")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hao Li <hao.li@linux.dev>
> 
> Thanks for the fix.
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

What are the user-visible effects of the bug?

