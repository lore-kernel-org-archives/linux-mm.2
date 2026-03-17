Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56CD8FB5EAC
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 03:49:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80D546B0005; Mon, 16 Mar 2026 23:49:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E50B6B0088; Mon, 16 Mar 2026 23:49:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FA596B0089; Mon, 16 Mar 2026 23:49:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 595386B0005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 23:49:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C6EADB9890
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 03:49:57 +0000 (UTC)
X-FDA: 84554176434.06.E08F3B8
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id B54C380009
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 03:49:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=GNbrs0uM;
	spf=pass (imf30.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.160.46 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773719395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5VINWEtY9aZvz9HaKBZW/WHE45MWpLM833fNP+ydNw4=;
	b=moaCnkeekJCBUqMoxNtqxrVi7znC9f+2upmpLf53V6eU+LvaD96myePNfkw37yoYONOBOd
	l2mBf/Rdi0c9qEsgC06JbmG8XY7x+lVcC3hf1IzvLUNT7769mrNmMSWcmS+gbLgdKpyXlP
	mSH9r+WoWEyM4ARYT1r/KTdC5y9dzIg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=GNbrs0uM;
	spf=pass (imf30.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.160.46 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773719395; a=rsa-sha256;
	cv=none;
	b=31yye+nqfq/8W9grMnvNJ5GI15MQxjaGFksWnUzO5OQgVsyCWZ/DVpyqg3O+Bo3A11vLK+
	zYVf3Wg/Uo5FbMo1Vcd9UReqVS1Vbt3NaCkerA3VAMY5+Xpcwhw8kMosQWLr+uiOWCmoSO
	UdV/kOQg3PDnK3JLCU7srJu1wQ74R/E=
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-40f1ffba6a0so3130032fac.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 20:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1773719394; x=1774324194; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5VINWEtY9aZvz9HaKBZW/WHE45MWpLM833fNP+ydNw4=;
        b=GNbrs0uMlut6xyPaSGY00dceirs2G5l6mKo5f3yWrGk5mJq96hcUGwkvdd+UZhOUf1
         2pxAGMFx8v1K3wZUntVftONiJFWVj4dGZThTZ91UiaZ4wMHIP3Ll8YPQb59LxEb1ZjyC
         B+6TdCOJe32hcYXmFwedzmlWNIIYOZUVF9FTki1GrCAjcQqCPyoZtqmsuJJ4kwErdziX
         gn+H7ZMkrw/Lc8Lmfmex44HWXL05vjqdsDzarJhqYapIGRmO8wGtF7yFqeoypY7yXuwb
         sSEwbRKxm1lYWktDug+gN5xhrX7QJCHVrT7Zw3pm+b7AJe6gv9+yoiE/E0hTZzjutr5l
         H8uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773719394; x=1774324194;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5VINWEtY9aZvz9HaKBZW/WHE45MWpLM833fNP+ydNw4=;
        b=pioKUHl3K2x1VOo/FnaxeL2IkRQEAwhPpcLb7TaJVlR0wce+Rz5eq1mm5cKCnp5mRe
         efCaYacoUHubkVb4q1ukSqX7Iagxz4XycWrDUkXI+f3imyQ1Eclmga+XL9cilBBow6fC
         0Xd89D/Bw4R78wNVP3Nsnmj2LggvS65gBpfWenEsJXq54+kr7y87x88Fv7lhBcGpTN1f
         GtEflVF0ARwYSPVbefNqCQZUJaNRknlPOEdvygXkvp18kG1+qibEAvKQUiXoUl3OaLkU
         GACChIAieFbN06Xi6sSVgKnTJQDHH2CKtwY0PAPuTPa/9tVw7HB1uU/vvzt2dra3AuAj
         8FyA==
X-Forwarded-Encrypted: i=1; AJvYcCUAQUB65VK5HLXt7HnoG23c0fmxJUAvLd//wYrOtbrSISQOYv+YJMiVLKRZdQmdJacM9ZR8a+2j+w==@kvack.org
X-Gm-Message-State: AOJu0Ywb2+gH6DQwQDk0vEWmJvYbfx9foAY54qJI90QFPH1xb/AdMy7X
	RWWUIKwX6iuAbnhFHLr3twsIJd281k9V84PG0XNdkZ3EcyskeI3A911Kw7Ja5fref9o=
X-Gm-Gg: ATEYQzxTvu87nKFGFFrnMxyxARYIgp0lxtTcDrIetpfmP3DFXCj8dTQ7Pc+S6frglQ8
	BLqBtPIU/61jd7VgUHkCiAA76kR71OXTggncqvDjiMnyW9QBbq3l6cQFkWjIeXmyTZT/0a1sXhn
	f1BD5ilil5JcqDeGZwBlr7I6biLcmpn6qYWh+hhl+iz/2V4zv3JMuHlSGdMLSS0K8PQNleldApU
	7vebMrz28iw/8vls/sNcrwB7VBYbVlxJg1rXEagu7cgyzr+FRaupSEPKrglqhsNVJm9445CDcZg
	nxDoGurvZo6TIfb9UFKY0Z/vcS8gdVW65Ydg+RjXD4lNj5w1ea+0Q6CFlrECQh+PdcHSoOxSy9E
	qULnU05f3GHWTEmlnjHabb65lEBkMJ6BkQl5ebKKk3krk/lv5pgRAsItQhsiU6X4PrCUmk/5YmG
	sLNcw+HbQP4gUIg0VTJddNdq0l
X-Received: by 2002:a05:6870:d406:b0:409:74c7:1cbb with SMTP id 586e51a60fabf-417b906d206mr9213737fac.7.1773719394528;
        Mon, 16 Mar 2026 20:49:54 -0700 (PDT)
Received: from [100.64.0.1] ([170.85.103.33])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4177e6ae0e3sm19148337fac.16.2026.03.16.20.49.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 20:49:54 -0700 (PDT)
Message-ID: <da8c8b57-6d5e-461a-83b3-9339a712aca4@sifive.com>
Date: Mon, 16 Mar 2026 22:49:52 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 14/15] mm/kasan: add document into
 kernel-parameters.txt
To: Baoquan He <bhe@redhat.com>
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org, andreyknvl@gmail.com,
 ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com,
 linux-kernel@vger.kernel.org, linux-um@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 x86@kernel.org, chris@zankel.net, jcmvbkbc@gmail.com,
 linux-s390@vger.kernel.org, hca@linux.ibm.com
References: <20260225081412.76502-1-bhe@redhat.com>
 <20260225081412.76502-15-bhe@redhat.com>
 <f7054184-dca2-4c7c-9e2e-4a5e3e1c81da@sifive.com> <abjMP58VdUu_eElh@fedora>
From: Samuel Holland <samuel.holland@sifive.com>
Content-Language: en-US
In-Reply-To: <abjMP58VdUu_eElh@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B54C380009
X-Stat-Signature: nrzwtk4et5gm544fphuh31sest9e7oea
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773719395-602591
X-HE-Meta: U2FsdGVkX18Db/mfSz7n20QLmMfoqyCEbPVkHw3ZYzN3JXzzFkCpiaJ5+99uCSA2zs+atQl2w3opzMXciFryieAr7k0blbJDNlZT7GQh9ahe5hlRuEao5bAFv+2jkKFj04/qlFu9artQgUEEXgYApVy8MJjCcGWtHwjJKTEKan4C4E/eYiD6kZorEOOyRKr6bN1jhdtT1h64p0vTUM17bus2mhNAvsJqmMBpXp0/aNJzSaLLT72rNkUYbvbf+LDVvYS7hh8Cg7N4BcY8L7xh0pdeSnXXBqbagPT23MOxi6jp/CGLe/C5FLvaSTtg8E3AsmveDKSyXJUBwHbe3NuCUFcre3WJQd88NKYEAObhw/GRvkCuAPnd735Rtxsb97LqOHUF4g/Ro+YOV8c5iUUAIEq0ssL8idPLaznhlaBexfWnXfVrdbpKCohb2O18qbw33hZ1HbFsbFcjGky0jdr3Cvi24s3Ybq1Bv/pjVnM385jgqLXHKSxJM43pWl38dXi01o2a6ZqbajTLUDPdbgBxCrrMVfhb6B2fGa2FZGIPbBYmT+dyRuUolhe/NpORpDPIvsrNBpWVNCx/ZpfJWxULgO11GLRNoUXG99EdC9QgPWpylIWnt9MM2Urz92C5i50IeFjyaRrKDy1YzNhcQiS+UlVO0j5KMXh8H2TlG10qIk1IbkqxlMEj1HElMCHwJ8DOD8yeqC+e3JIRy4QltHm5S1dwasMDpGox9/0aTsKQ0VTnxvcj5Rg8vtCBPMBwRG676dwU9/yB5QVKz/6BKlZq6jC3NAK3z/Ab+ZMq1N/wU0p5E1bU1LJjBXApdG3HnGSxzoREH80T6Pr3LbBWbpdRRDaI2CwgsH3BH+b5Dgz5SL9k65z5l91eZJSCNtQ//Ogg11IiHSuJHRToSdcUuUvcrxwuwMxnCXou4Wu2zq0xrJWa01HQSJiXDGNV09zLHBdRQvsYsG3W7Ew2HAC9MqH
 LAqaLrMA
 blO6bj6HdCu3EQcA3R945WUi1a1pxzwbFBbkzMdlI8jAnyxznE/sfaWrS2SZUNhtW2wCM+5OOK9Y9oDIxF38sQmMsEdBqgcmziiDl4LEOoO1D6iCwuuBD7qUyF/t6TldOixYNx5vt+hSf8tfmbGT3uys+nY/ggFnei7vN4VcsoKb74ieXFXUo63YIn0EawHd0vilufeR71r7etYepNNIh2tUkORpDbn6gdK9ej41nXn4r9559wtOG4EOepBGVY34CGlakhS1XulVxD4It2K6Tgu6HphzE9PtjwurnwF8wHUtME/4Izx+kgiiDgCr3NcvluHdYDPjHBpihJ8XD0XfH/XNxI9xGgM3xPJHvufMIsPwZO0qC5Ew1adVwDgIoy3t/sysuTjVUqB5KsgTEvrqWfxtqBQKyP3G1GPOD/XTghL39gY1DZTpBNhLxy8WiAKjK61/JW6pHqvMKDr8SkaCk5sjQFsdHEfm4eDCV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-16 10:36 PM, Baoquan He wrote:
> On 03/12/26 at 07:53am, Samuel Holland wrote:
>> Hi Baoquan,
>>
>> On 2026-02-25 2:14 AM, Baoquan He wrote:
>>> And also remove the relevant description in dev-tools/kasan.rst
>>> which is hw_tags specificially.
>>>
>>> Signed-off-by: Baoquan He <bhe@redhat.com>
>>> ---
>>>  Documentation/admin-guide/kernel-parameters.txt | 4 ++++
>>>  Documentation/dev-tools/kasan.rst               | 2 --
>>>  2 files changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
>>> index cb850e5290c2..e0115fad9e60 100644
>>> --- a/Documentation/admin-guide/kernel-parameters.txt
>>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>>> @@ -2899,6 +2899,10 @@ Kernel parameters
>>>  	js=		[HW,JOY] Analog joystick
>>>  			See Documentation/input/joydev/joystick.rst.
>>>  
>>> +	kasan=		[KNL] controls whether KASAN is enabled.
>>> +			Format: off | on
>>> +			default: on
>>> +
>>>  	kasan_multi_shot
>>>  			[KNL] Enforce KASAN (Kernel Address Sanitizer) to print
>>>  			report on every invalid memory access. Without this
>>> diff --git a/Documentation/dev-tools/kasan.rst b/Documentation/dev-tools/kasan.rst
>>> index a034700da7c4..eaae83fcb5e4 100644
>>> --- a/Documentation/dev-tools/kasan.rst
>>> +++ b/Documentation/dev-tools/kasan.rst
>>> @@ -129,8 +129,6 @@ Hardware Tag-Based KASAN mode is intended for use in production as a security
>>>  mitigation. Therefore, it supports additional boot parameters that allow
>>>  disabling KASAN altogether or controlling its features:
>>
>> The sentence above is now incorrect as well. I would recommend documenting the
>> parameter earlier in the "Boot parameters" section instead of removing it from
>> this document entirely.
> 
> Good catch and the suggestion is good to me. Thanks.
> 
> Is below change OK to you?
> 
> 
> From 317be48b9c1bf9d33b8d8fff5e401e3155531d81 Mon Sep 17 00:00:00 2001
> From: Baoquan He <bhe@redhat.com>
> Date: Tue, 17 Mar 2026 11:28:39 +0800
> Subject: [PATCH] mm/kasan: adjust documentation

I'd suggest something a bit more specific, maybe like "mm/kasan: document kasan=
for all modes".

> Content-type: text/plain
> 
> To reflect the change of kasan=on|off.
> 
> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  Documentation/dev-tools/kasan.rst | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/dev-tools/kasan.rst b/Documentation/dev-tools/kasan.rst
> index a034700da7c4..8e65bc04dbcd 100644
> --- a/Documentation/dev-tools/kasan.rst
> +++ b/Documentation/dev-tools/kasan.rst
> @@ -103,6 +103,9 @@ Boot parameters
>  KASAN is affected by the generic ``panic_on_warn`` command line parameter.
>  When it is enabled, KASAN panics the kernel after printing a bug report.
>  
> +The generic ``kasan=off`` or ``=on`` command line parameter controls
> +whether KASAN is enabled (default: ``on``).
> +

This is in the middle of paragraphs describing the fault reporting options. I'd
suggest to move it to the beginning of the section.

With those fixes, you can add

Reviewed-by: Samuel Holland <samuel.holland@sifive.com>

>  By default, KASAN prints a bug report only for the first invalid memory access.
>  With ``kasan_multi_shot``, KASAN prints a report on every invalid access. This
>  effectively disables ``panic_on_warn`` for KASAN reports.
> @@ -127,9 +130,7 @@ modes below) support altering stack trace collection behavior:
>  
>  Hardware Tag-Based KASAN mode is intended for use in production as a security
>  mitigation. Therefore, it supports additional boot parameters that allow
> -disabling KASAN altogether or controlling its features:
> -
> -- ``kasan=off`` or ``=on`` controls whether KASAN is enabled (default: ``on``).
> +controlling its features:
>  
>  - ``kasan.mode=sync``, ``=async`` or ``=asymm`` controls whether KASAN
>    is configured in synchronous, asynchronous or asymmetric mode of


