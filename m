Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E9C7CF394D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 16:19:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A1696B00D2; Wed, 19 Nov 2025 11:19:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 251C26B00D6; Wed, 19 Nov 2025 11:19:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1413D6B00D4; Wed, 19 Nov 2025 11:19:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 037FC6B00CC
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:19:57 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A0EC713B2C3
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:19:57 +0000 (UTC)
X-FDA: 84127868034.03.0FCFB2B
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6620B14000F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:19:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=DpQszS2B;
	spf=pass (imf09.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.43 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763569195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s+urd6hZuWEo3shlMiSBaDb8+AZAhwgeZeQG9S0pL0o=;
	b=BLQ5rGnZTD5g/FZQaJju/XXHf38yjbB8PX6gSSrCjM2MKaSNCzG29YX6nx4ngDN3399Seq
	RJbxjtBNoXSf4JjjkFx7vXKu/SYH1QZ+mSnrXxMZ9rWbwPjCZgNfX1wlzq5WaWUIPyTjrP
	CTAFuiDvZY9gqMBZfFQrjHBR/yHRrHk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=DpQszS2B;
	spf=pass (imf09.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.43 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763569195; a=rsa-sha256;
	cv=none;
	b=z5Wi1qRen8HUke1I0Fo+N8EKQrmCqEias+jN+1gAVp1WpBNNVJ58VCwgtfQMOiR0LmkEDG
	5EdfuN8xs9HL2/zVxswVvTEU353Bf3e2jeoNGnpULSrwQt8gtJJii8L6ILHzc1MiEFlQTz
	idmjmnTzDkevKCve1QGqihJGMOiqpqQ=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4779cc419b2so48825285e9.3
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763569194; x=1764173994; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s+urd6hZuWEo3shlMiSBaDb8+AZAhwgeZeQG9S0pL0o=;
        b=DpQszS2BzZvrzQIONWbiJ/IZhUibaoooBejlGCYoZ0YWOXYP3G15qd5+NEufnLyVQD
         ceJ/KFV5ZMt5W1on3oB6i7OOgOP2E8HMYOJqsHaADKerVEMWKaR91aMjRktqcY54Z4aU
         FUGgyICmHvoDKFvWy/SUuMYSrdYyy3drLB19ff24UmOiFk/yIfFeQdgOYNWbtrioQxsb
         qN/l2ed49oT3MgQ1WZJmnzWWeuGlc7dyS66xucHXoJAMzdsoumwhaTt5hObti5V30Yji
         +BFrtwp3J1b5UV3kfgbCRAjKjofNwqXA3gzHUHkFXuIUvt7RmD66U2BpxLeUuf1eCkpe
         IbHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763569194; x=1764173994;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s+urd6hZuWEo3shlMiSBaDb8+AZAhwgeZeQG9S0pL0o=;
        b=HsP0/S4UJpbBC/5lk3yUZa1S3VfMCY53+xPT81ojFaiidnxODnnpeml2b8zQinMaD0
         L3Huef5zhfaeRCHaWF7nlT/tQg7lNUFFDMdpMnesEab8VJDiG0RpN2fc8dQGAZaKOqeE
         HZIbfFu+68JfndZO4mVDJM2VocfrXs1GUHTxjNXUc/+RQFtkHuPiIeDbkSxcSuPPSU0d
         h5yWryLWz8uaJzGZoOo5antW8SND4XMTBKM4GHr1Y8MHar887dJ5KUk5EDxNwGDJ/wt2
         q2hTjgk2LmzWezh+2AeCkhrbsJMcP47SvYZABT90nyBtRZHqztlPohBzAsFX+O/DxrT2
         0dEA==
X-Forwarded-Encrypted: i=1; AJvYcCXzoB1HR+3KzNjB9vmAtLvO218aW9LwqEWzwERbAaVqGAuxeTJ5y00y/ZxTNQJ4Hr8x6bGf5+zVYA==@kvack.org
X-Gm-Message-State: AOJu0Yyd1PK65Z2TtwEBG+b2rDsTLdHRvxjQMzu1tcFHbTOk/AzgWrEq
	0a+EG6U8TCoYmmuxEmprwspd5d0IANEunP9k9t4MfzD74dm35GflVLf10ZJUztWiO3I=
X-Gm-Gg: ASbGncvXilZ/USOXz/9knzy2V9jz2xYZNsrpieuxR31ChkE1sR37rxCy9QTPiu/dwzs
	pe+Q1jRGI1gGRvrWuTKnin2G8PAwHOToasExW4Q93JBC6RPeonT6ve247QUO+X2x9q4I+/gc/Ig
	2fbC+4Rj/WOLHAyfIvxBFYM5lREWXjW5QrrufedRzO4dk3uOXcsb/509tDLbwXnjfZy/4dQkOuD
	/r4/Aed/ARhdTUsc3J13TWAzx8zh3ZeTV1w4PJJFqmmJh6To+uW8eieUmkhEMD0Kl+hUXeuhPFt
	TJ0nhX5iFVJNNu0e1XZ5FpcxpG/wfKjb5CmBotv3ghq9qJRsLZBORNOTGhLL2YwFx3LSj5sXnca
	DfkDXcg/S3szx90MPC6/FbdJRH0P4DFth700Huz2VGTlGv1UVA2eH/TzE4bMZr9N5YaBwsuCflu
	sjUvdOe2KQdWkY64ulmvtpedUHCEZZ
X-Google-Smtp-Source: AGHT+IFwK5aAXHXIDIc3E2JseMPHhoLC/8O7sdHZVlYBJKdiPiGNYDVrkfdVj41qV4fzGcHy4cnIEg==
X-Received: by 2002:a05:600c:4513:b0:477:2f7c:314f with SMTP id 5b1f17b1804b1-4778fe5c820mr231183085e9.10.1763569190918;
        Wed, 19 Nov 2025 08:19:50 -0800 (PST)
Received: from [192.168.0.39] ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477b0ffc90fsm61424875e9.2.2025.11.19.08.19.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Nov 2025 08:19:50 -0800 (PST)
Message-ID: <060e7412-8f1f-4d31-af39-79213c560e85@linaro.org>
Date: Wed, 19 Nov 2025 18:19:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/26] dt-bindings: reserved-memory: Add Google Kinfo
 Pixel reserved memory
To: Krzysztof Kozlowski <krzk@kernel.org>, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
 andersson@kernel.org, pmladek@suse.com, rdunlap@infradead.org,
 corbet@lwn.net, david@redhat.com, mhocko@suse.com
Cc: tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, rostedt@goodmis.org, linux-doc@vger.kernel.org,
 devicetree@vger.kernel.org, linux-remoteproc@vger.kernel.org,
 linux-arch@vger.kernel.org, tony.luck@intel.com, kees@kernel.org
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
 <20251119154427.1033475-26-eugen.hristev@linaro.org>
 <e73bdb23-c27b-4a18-b7e3-942f2d40b726@kernel.org>
Content-Language: en-US
From: Eugen Hristev <eugen.hristev@linaro.org>
In-Reply-To: <e73bdb23-c27b-4a18-b7e3-942f2d40b726@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6620B14000F
X-Stat-Signature: qbrq5wue5b5e97mtyy8yp5y71jmkjfow
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763569195-674087
X-HE-Meta: U2FsdGVkX1/Vdza3m5BnOFwM3ezAazITuk4lQIPk3fLWpB3eo2O/QLJe2OuhWcWR0M/JNWtA0KNJAMnTmFZ+KvkgNLw2z/xpi0TAHIjAooK7tOJeyt0vK9XiLKJ5qxf6ovdN5s+e4qsTTJTRv8d/yH8P1S9GWJ5xmYbZVX/prWh/VhvxXBW5wefamVoJJPimMAIbJ78fujAgKPP/0Vm6zYla2GF8lpyaT2zVUvxSrfwlw9M39mPhKwqQsw7sobXDbwfi0F58Q4pWfSgODKWP9vIgjqDGGbzubQd185/meo28vHyjwbIEKf4wocR2Vs9ujcu0z385WqSaBtpjjhdVUSsQskMmjICCZEVhjovJJKbJJJbIXE4D4ud6NBKEp9mfXZAYT67Q64kXwFvQPvtDdUGu1+SNIG5u5Mv2i1zROXqUTEs05I7SCqnhxfJtsXraDgjkCesrPbk30yCY4e69jTC/cpIWsMUYtdwfQHdnMVFiuUudTSKIVs/0jzS3JTlFjFfVOdKS0qPAx/j9l5RQFOn6G/asHSaMPpqtIYIZ8nLGF5HbYUqIhFyiXgaMctEdwOOU5Iz2pQUNB24Su5+3kvC6YORcxSEndpuni/1Xr6nH6tqpckcBPlrEEBmReZvnbVFqvbH2GK6DRz8xAUySp6vhjXlTTFyR8qi4E6jM0tjwgTRdy16UT+rdodcX/ZT+q4ZrFx+dltYE/xyGuUvzT9MeXMuDZuBdlnqdkk+Q+aSS3zUUnAJa/0z3m6tDjZHbuRjSvhzYDkIjm4qZCVyIBuBHyGYQGXb7fTUQBji8JUm62rMbjxnZWk5kyIRKVcoJm9Ww7+bkmUhJOhptXOQ/5lnEGWzxjt28jWET5QW+lkxbBPpaOFCZ5QcIQ72F1s/urteBKwOsrKaxV2Tkbmboncm3F8E/GlP6Yu8Ue//IWby8hRGx9VAjaUN8RaKojx79Xlaa5v6t8KCgHg22PBF
 lRwRSy8m
 Gc56uL6255VXuDyjTm1HSUytgXxOi/+Hf9/XL+t5c5WJnrgOWnZqJ1NPnlU3KG8oFn3A7E5p06fgeZV48zxYp5tqBiz07YjH+NxDnpEeQM5kJRZ8JcCMLCE+dvZOLUYhpYKoACcB/Hwybrx8Vl3hxIH8ghyvdT6SQya0cWrBIHVjclAYJNom27T1bmMOb9AwWO5k4XcB+hNS5yeb3VtYvYEA/HvDJ2ptOidsM1TvuOlnNsOYGUMcCBlthG5dzJDkV71gMsMBe1otmpkXcwq0yiaYIuiV8QRY/2n6ryRv6SA4gqgR91nb8+gHK0tZbXRZ2xErlYMee3ZlXs6w/8iAIYyWeMd3e89CBouYNtrpNanpZMlUfxWBexPfJKTgSVAnnE6OcmRwA8n1k4IsJ+qaend5tN67EzTjyj9S9eqe9o5LP+bRvJlkQZFBCmUgp9EyiYyaABVmpXYjn/GGB18pFXaD0y/2claLa6NfCSAU350bspeUnkiPCIguxzWU0fQ/KyctxaIFT2l4VI9I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/19/25 18:02, Krzysztof Kozlowski wrote:
> On 19/11/2025 16:44, Eugen Hristev wrote:
>> Add documentation for Google Kinfo Pixel reserved memory area.
> 
> Above and commit msg describe something completely else than binding. In
> the binding you described kinfo Linux driver, above you suggest this is
> some sort of reserved memory.
> 
>>
>> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
>> ---
>>  .../reserved-memory/google,kinfo.yaml         | 49 +++++++++++++++++++
>>  MAINTAINERS                                   |  5 ++
>>  2 files changed, 54 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml b/Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml
>> new file mode 100644
>> index 000000000000..12d0b2815c02
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml
>> @@ -0,0 +1,49 @@
>> +# SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/reserved-memory/google,kinfo.yaml#
> 
> Filename based on the compatible.
> 
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: Google Pixel Kinfo reserved memory
>> +
>> +maintainers:
>> +  - Eugen Hristev <eugen.hristev@linaro.org>
>> +
>> +description:
>> +  This binding describes the Google Pixel Kinfo reserved memory, a region
> 
> Don't use "This binding", but please describe here hardware.
> 
>> +  of reserved-memory used to store data for firmware/bootloader on the Pixel
>> +  platform. The data stored is debugging information on the running kernel.
>> +
>> +properties:
>> +  compatible:
>> +    items:
>> +      - const: google,kinfo
>> +
>> +  memory-region:
>> +    maxItems: 1
>> +    description: Reference to the reserved-memory for the data
> 
> This does not match description. Unfortunately it looks like you added a
> node just to instantiate Linux driver and this is not allowed.
> 
> If this was some special reserved memory region, then it would be part
> of reserved memory bindings - see reserved-memory directory.

I sent this patch for reserved-memory directory, where all the
reserved-memory bindings reside. Or maybe I do not understand your
comment ?>
> Compatible suggests that it is purely Linux driver, so another hint.

This reserved memory area is used by both Linux and firmware. Linux
stores some information into this reserved memory to be used by the
firmware/bootloader in some specific scenarios (e.g. crash or recovery
situations)
As the firmware reserves this memory for this specific purpose, it is
natural to inform Linux that the memory should not be used by another
purpose, but by the purpose it was reserved for.
Which would be the best way to have Linux understand where is this
memory area so it could be handled?


> 
> Looks like this is a SoC specific thing, so maybe this should be folded
> in some of the soc drivers.
> 
Not really soc specific. Any soc who implements this at firmware level
can use it. The firmware can reserve some memory for this specific
purpose and then pass it to Linux, so Linux can fill it up.
It just happens that the Pixel phone has this implemented right now, but
it is not constrained to Pixel only.

Instantiating this driver with a call like platform_device_register_data
would make the driver unaware of where exactly the firmware looks for
the data. This is right now passed through the DT node. Do you have a
better suggestion on how to pass it ?

> 
> 
>> +
>> +required:
>> +  - compatible
>> +  - memory-region
>> +
>> +additionalProperties: true
>> +
>> +examples:
>> +  - |
>> +    reserved-memory {
>> +      #address-cells = <1>;
>> +      #size-cells = <1>;
>> +      ranges;
>> +
>> +      kinfo_region: smem@fa00000 {
>> +          reg = <0xfa00000 0x1000>;
>> +          no-map;
>> +      };
>> +    };
> 
> Anyway, drop, not relevant.
> 
> 
>> +
>> +    debug-kinfo {
>> +        compatible = "google,debug-kinfo";
> 
> Device node with only one phandle to reserved memory region is a proof
> it is not a real device.
> 
> Also,
> Please use scripts/get_maintainers.pl to get a list of necessary people
> and lists to CC (and consider --no-git-fallback argument, so you will
> not CC people just because they made one commit years ago). It might
> happen, that command when run on an older kernel, gives you outdated
> entries. Therefore please be sure you base your patches on recent Linux
> kernel.
> 
> Tools like b4 or scripts/get_maintainer.pl provide you proper list of
> people, so fix your workflow. Tools might also fail if you work on some
> ancient tree (don't, instead use mainline) or work on fork of kernel
> (don't, instead use mainline). Just use b4 and everything should be
> fine, although remember about `b4 prep --auto-to-cc` if you added new
> patches to the patchset.
> 
Thanks for your review and suggestions

> 
> Best regards,
> Krzysztof
> 


