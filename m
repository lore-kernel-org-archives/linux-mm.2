Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC3361098793
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 14:53:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FAFD6B00DA; Fri, 20 Mar 2026 10:53:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D2AA6B00DE; Fri, 20 Mar 2026 10:53:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C1346B00DF; Fri, 20 Mar 2026 10:53:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 184876B00DA
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:53:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BC3CC1CC06
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:53:13 +0000 (UTC)
X-FDA: 84566734266.12.D563FFF
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9E5EB14000A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:53:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HY8UVFKu;
	spf=pass (imf26.hostedemail.com: domain of groeck7@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=groeck7@gmail.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774018391;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rTHKXCWTdDkx4cn++Ba0jyyHVgHk9d/lYR5yOZKUNRA=;
	b=SuOinLsLoH6jPq/RLgKqTBXOJHBXRkFhss3MsKYznGEYFwmqPxLI14Q2cFAYXAbdBCrnZP
	iopx/7j684wjzOV3yD36/i51psj9DCg0JTnajqv8az7TQ1mHQUlpHD/bJ7Fl5YJH/6n9Cg
	e9dEJXCwY/hRipXbFrD5G09e5vbHJR4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774018391; a=rsa-sha256;
	cv=none;
	b=wtH52785txyuJhyARPAwK++o7XRhrnthUdWn3PaC0FDZZUgzZXxQywDA+GEL4zpFmHSKfg
	eLLYp3TUoShAgr/YjiU4PyrtJojFvKb25f3AvIZAs5kavWD061X9qRuoB3jbYhh/3zOHwa
	lc2sVqcIeuUINXoDXOekMCk91MTgvfA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HY8UVFKu;
	spf=pass (imf26.hostedemail.com: domain of groeck7@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=groeck7@gmail.com;
	dmarc=none
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-829afe24fb5so591391b3a.0
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774018390; x=1774623190; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=rTHKXCWTdDkx4cn++Ba0jyyHVgHk9d/lYR5yOZKUNRA=;
        b=HY8UVFKuElSVMm26b1MRRGtc68L4r8cH8TNCAwN+RLeP0WUPj2gYmHVN3MxZkkrOCT
         JD3zFPh4HyTJEVYsVrFZNnMPSIKpRIT7sNXW4qDpRwAGTpg5dH6BTw/nzoHmgeFCNjpi
         9Y4jw0+xxb13+xi88zTFBak41KN5i0q0jPC7DYu8wkE4Co9a3pN+lVdSEwjQR3s7mxc7
         x4MTYUOEoEsll7vxEhTMPKqmRCLipdo+e1kAJelIBfiTZJCa8NFZg4WRFOsmsgotfN21
         GdfBKosP7qwtd+yuJkS8RFZeLeGx3gTtBEhGF7iR0Crwmr47+BBrJHMw/XwxbobD+wXc
         MYYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774018390; x=1774623190;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rTHKXCWTdDkx4cn++Ba0jyyHVgHk9d/lYR5yOZKUNRA=;
        b=fNhZ/r4tAxyWD6Bslp8yM1AL2dXsr8+tGFL5a2CUqPctT72rd8ne3r1XMLoLupu4Df
         hx3cvtK/QYSs44jmW5DeoS0Oeq2Dh5/M9b14Bi/C8qnP/LdAxyhv/YVhg5i1rFXvBrDk
         L8FGyf0TYfT8ziYRNxhZFXpAHkajkUhY7ZjaqBIyB0PCK5PwSug5zZpmo9leJA6Oa3go
         u39ZSihClzQuTT3ST/Zc77gZsjT3nzBrE6zPAM0+1KTcmVWclzI0YP25M0HClcp0lc9t
         muBGlZ2lDgU6NHH7aeQL3q4o/wHqlg9RRjE1xed04QQr0fAD76S+9+FMF/VQKUD+KH7A
         vH3w==
X-Forwarded-Encrypted: i=1; AJvYcCXWYz+P1NzD7uIFxI3+X/omTdqqB/d6qEQZxfyhpwmu7kytp8yTpQOqMH0AYHenSPZCmnxXansLTg==@kvack.org
X-Gm-Message-State: AOJu0Ywdl17+66mTB0CQ8GwFbEFz88/QHU7lHpn8iCbXD45HbDjHu4JQ
	kWidZYsZT6uP/+jPDKLiLoVQJMMpwId6It/wVNsEsady4dGFqJIiHaEM
X-Gm-Gg: ATEYQzwop33GWsgIz4oN9QUMYzgqDdC6/8TBJtf6Lgyd5hh9JBtCb4LKi8zXNKqygja
	KYiMXgvQPlTptLcrqWj1mJGG6jnHIqR7YuxGaXVh5pusrp1I7RhoFSiYLQj0jkeDmmBa9PPSPXs
	S5tPtXlWiY6I8cmgqXQnh32ZZM/eI3CSB2+OOPDf7u0Dn6VUB6Qxsbl1DITrGG1OZITwwhq0xmr
	ZqzvqRE1bYZIa+YD2BV9eEEMb4kaz/3/ZMfL1juEnKokB/tIHohQxAfHpmWOH3iwd4/R8HX4Sjm
	HnRe0TIWDtVaDlCShWlFcjdRWCaaYwdhGvaitV3k/KTigjhbupXc7WlXGFo/TUCn8gDtJ4VN2NK
	aqkK3ULm36bkmWM6CB7TeJbMAIKGdn4S9emxGRVFNr2Jlarw38ALXT8rwHFgQEAENPgpDzJm7Ue
	TPc16xl079uEs6Ky4jIYbfVW1FfWjUhQU1Tbez/YgFGlecmIRKMFQglhZjHNQotROdj/5il9CV
X-Received: by 2002:a05:6a00:3491:b0:82a:955:50d3 with SMTP id d2e1a72fcca58-82a8c395ad2mr2483562b3a.45.1774018390304;
        Fri, 20 Mar 2026 07:53:10 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b03bbf0c2sm2799129b3a.15.2026.03.20.07.53.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2026 07:53:09 -0700 (PDT)
Message-ID: <b58a981a-6264-42d9-b158-650dd194ca9c@roeck-us.net>
Date: Fri, 20 Mar 2026 07:53:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] x86/efi: defer freeing of boot services memory
To: Mike Rapoport <rppt@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Thomas Gleixner <tglx@kernel.org>, linux-efi@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20260225065555.2471844-1-rppt@kernel.org>
 <100b9ae1-74cc-48b3-ba63-1a72cfa2ebbd@roeck-us.net>
 <ab1U59ye2eBOz6x3@kernel.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <ab1U59ye2eBOz6x3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9E5EB14000A
X-Stat-Signature: byz1tsc9h5uiuts9u56xcgdiet8yt6nk
X-HE-Tag: 1774018391-90979
X-HE-Meta: U2FsdGVkX1+sW0BaKdLRxiPbB66JKyaeOEeKKSzu9h2ySqWwgye/stE+fWPelTGDJUojG05KIfYX+ryjR4sxMX++9ecZ/gfPvO+sFJnKazB067MGpk25Y+k0EAwSt7z+1jxSxCVPEysb4zFgmGmkfSBnvUT1kjzgPXEvt5jvKLKybYaE7YfNhfOYZFJQFS8Z3RMZvUtdI2uoH7QUEXWdWpYLRQ3U96n4GL8K50V6lgssy0SyfKa3zXYL1jTnr+h/CW1EFEOoz3Dr9u0T+DUCVlYmVan1cABceNZCW0q+AWYBcjiUdEq0TdEp8pYZGCGhPWJkrwRD3umNSja74ufAEHaP3p+k2z1JZIZK51zKwOZL/qixAbNfAnnkkFsKmsQ07NL4z80+c694LoNWJskm+Z8SJ4d5T27ByDS9VAiyVYwZw9Sbwq8EWlzISAvBwr4FrDc7Z924Szd32FBv5Lauez9Zh8oNUImDWgJok1+H91RtA+0R6EgfFS6njOi/BwJzyPZGXG3mqy84QAdZRXcC/QLmdb5tt9D5m15LbrtecC9QwsFlpLlm4czHZ+fVtaiYezjT6j34StBeV+hft6SObUiVc7b/GT6wt1FK/3fVBpXADrZH4GHbfsaba4TmyBz4LeUl5VBz5qg/2bxS91aHpU4/52yKHxcvGp/SCJfXL+jc0u623hyH3XHAsWayTcDPgDB4wj/e6zf2hVTg8K/Sc5NcH6f4hkDK3htF61K8j21dHFnWy6GUhL+ddYs8NgAPspcNWVjoMbUeyFup7dSyVFYPNHgwMk6Ws1jF3iXOV6eyiB284VVwcwqUi1zLIBxuLmTowknglOnMLDAcEvloDB3DCWUBwhc7pzkjN0/DqZqDcxwLT1NB/9pLnp7b9PdJlYZY1fWbjcab48MNLh12pK4EMC47/FXgkSO8cY8CGRhxlW/jd3FcKG+KD6nDa3RLrjy2BauEtBnh0tXt3Qj
 OHr0OVRp
 0+LfvTeSbUe+oeofP4hM/O81NFSLgPUgEIe40zLcSAyXAoD+5z0ODpBnqWPOFC0ymfzQ7HAz3vRFMAd1TXAs+rL6sHDFHSaDZV51tInCj+67lH1ogQJVoEh0cfWtQOZRb4Xu2DPWpofJTlpRwjpYQWTErOSDAXsL3lWQO8qn56G28lmLlkKT30vDgoDZWIRQD1W+YvTDSbWjZhjf3aAg5g3ingf3Eiktbj+T6diAdI1b5NBfWAbn8cqEeI/k+c8Lfl8mpxFfD1nHLu9Q4632i4zb5cqlFMVOKjNUCw8T5Uun1GkGo+qqwFye5/Te4bI9mP+0Z/hAScsYWz07g87XcJXysQHajmRXIl38mc0LfLJXE+mY0Elzhxw9X10+CCxHMevbKxG8JRlVAsMcj6QvPANIKBZrSQHZEvs3R1poOIBg0X5d/5sTgstBNRy9m7NsL41iYDs5lSJbMw0qxKrhWKQHEy187FyQLhyO7NWe6olwW1iaH7v/1edjTxfXKGhbJAaegpPni8G83vMhLQoWehGsNembgovKrni0IpVMFMjivcXrSZdwbOk2kDtkFIxnWVPKCxpUwZ7xd19ym+29Itqf+OQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 07:08, Mike Rapoport wrote:
> On Thu, Mar 19, 2026 at 09:06:52PM -0700, Guenter Roeck wrote:
>> Hi,
>>
>>> +void __init efi_unmap_boot_services(void)
>>>   {
>>>   	struct efi_memory_map_data data = { 0 };
>>>   	efi_memory_desc_t *md;
>>>   	int num_entries = 0;
>>> +	int idx = 0;
>>> +	size_t sz;
>>>   	void *new, *new_md;
>>>   
>>>   	/* Keep all regions for /sys/kernel/debug/efi */
>>>   	if (efi_enabled(EFI_DBG))
>>>   		return;
>>>   
>>> +	sz = sizeof(*ranges_to_free) * efi.memmap.nr_map + 1;
>>
>> Was this possibly supposed to be
>> 	sz = sizeof(*ranges_to_free) * (efi.memmap.nr_map + 1);
>> 				       ^		     ^
>> ?
> 
> Yes, thanks for catching this.
>   

Thanks for confirming.

Just for the record, it wasn't really me, it was an instance of Sashiko
running on the LTS backport of the patch.

Guenter

> @Ard, can you please pick the fix:
> 
>  From 8fc5c5e828e7d127e6210bc9952451300591cdce Mon Sep 17 00:00:00 2001
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> Date: Fri, 20 Mar 2026 15:59:48 +0200
> Subject: [PATCH] x86/efi: efi_unmap_boot_services: fix calculation of
>   ranges_to_free size
> 
> ranges_to_free array should have enough room to store the entire EFI
> memmap plus an extra element for NULL entry.
> The calculation of this array size wrongly adds 1 to the overall size
> instead of adding 1 to the number of elements.
> 
> Add parentheses to properly size the array.
> 
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Fixes: a4b0bf6a40f3 ("x86/efi: defer freeing of boot services memory")
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   arch/x86/platform/efi/quirks.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index 35caa5746115..79f0818131e8 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -424,7 +424,7 @@ void __init efi_unmap_boot_services(void)
>   	if (efi_enabled(EFI_DBG))
>   		return;
>   
> -	sz = sizeof(*ranges_to_free) * efi.memmap.nr_map + 1;
> +	sz = sizeof(*ranges_to_free) * (efi.memmap.nr_map + 1);
>   	ranges_to_free = kzalloc(sz, GFP_KERNEL);
>   	if (!ranges_to_free) {
>   		pr_err("Failed to allocate storage for freeable EFI regions\n");


