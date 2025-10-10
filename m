Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECDD1CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 18:01:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EAAA8E000C; Fri, 10 Oct 2025 14:01:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C3E78E000A; Fri, 10 Oct 2025 14:01:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D7C28E000C; Fri, 10 Oct 2025 14:01:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E89A8E000A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 14:01:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A3F1211A192
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 18:01:40 +0000 (UTC)
X-FDA: 83982972360.12.2915FDE
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9015640019
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 18:01:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=mCeoaMhF;
	spf=pass (imf04.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.166.46 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760119298; a=rsa-sha256;
	cv=none;
	b=E9F2QSb6x+UQA3nLSgGtc5CD7Mca0eZ0XX/zMb/rIFbmkkHmqZcyAAjpGoXvX5lH7/qjGw
	E4FSzuNTgvP2mxspIo3UWuyqOywnTgS/ngAjBX8pNh5um+mIUHtDIeSfNDqrCZ3V7KJHXk
	8Q6+rS21YArETBAeUkJ0148iEAP6ZiQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=mCeoaMhF;
	spf=pass (imf04.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.166.46 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760119298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LcZRKSK4PXETXkF9exJHZznRCpFqtWz78yHtguUg1Eg=;
	b=SkFn8nyUKG2GLc6ejKApiiG7M5bG/QfrcpjPFIucJJgadVt6fDtWv/e/4Lfg58S3Y22wDP
	1zDZUFLyh8xCnVj65bHFpPqtYHXMzqs38C1NXmBsE2DIYKgwQq32GtVFyjOn3EJkcazalS
	LHQc+ySRbF6n6KLnOL29Uasoa7A96Ps=
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-9298eba27c2so101269039f.3
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1760119297; x=1760724097; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LcZRKSK4PXETXkF9exJHZznRCpFqtWz78yHtguUg1Eg=;
        b=mCeoaMhFYvszv8RNDRXKWFWRKQj1689WPTOlrtrWuQ/76Hk36sHgztPWGGQm2nZxik
         zTrmOK62vA1U8xRXZt2IsU4VD2BOyoDZzy+G7umHUWPGgaX0BYOPYme7YCvfbGzYAs/L
         Z/9L3Vj/siIpOLAhGHBrFCI0Ap9c/kMejdP4y+KoTPw/0joCJH5FskgOJtRCo96cwF1R
         hyEDykMyRJke9c/FpG+i1rOHOauzFa9b9xrC0aZG/MDWbyTrIulPEfe9WlsH2t25hV31
         gpyyjHa3gnaPSQX0wO5REYekcn2RtQAisInQpIIbMCyotcn+IdEPFNw6taK2ucyfnSOr
         LCyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760119297; x=1760724097;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LcZRKSK4PXETXkF9exJHZznRCpFqtWz78yHtguUg1Eg=;
        b=Z1KTmT1jsEjGP+xw3HWUFAMc8lAR65kPoIU5bI3TCqvmPVhAqEa8Nkh7HLsIetPfnv
         7OZeaO0M+zNQiAPenvtemdGHJqzjk+xYemnrTOXvEfGr+8yuZtFpXwSuWW2XYiYHf7+D
         fIhKcAOhvOH7P5KQit8UfTnX9ZbHwv6Asj6O0v0fUP4O4/B5TCAaQu877AyXMo1NIbqI
         pwfPRouNiJvViiBDRu5foblAIqMqBwG7N4WOzVLHSE8arxVlN81Dwmh7zSuQOQi90O9P
         VlkuPKBxbjppxyoxNKYW4NThkKQ77IbP1ufKlZOFrsLh6nFs8lm6vkhUCBz1sHE4wekh
         TamQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtVilKAyEHr3v54TmMPFvxVYITrbnoz1t6ISSBM8SvUXkxw5d4U82ghhlbdZn+0b4bH28yZyDUjA==@kvack.org
X-Gm-Message-State: AOJu0Ywo442wEOzqdPZnDFqtwZsMoYIOtmeL927phDZ01EnEvTAN5Jx6
	j+KkhGCw+MuDRHT26ENsGVHGtgzquaSgUO9T7UxoSwRg7I58qSVxtebBhm/i2+4XEqs=
X-Gm-Gg: ASbGnct1hX+cEY78YyCTa1tmlIYnJk8BwRj3RL6I7mm0NJL7Gsy54D9xChfdoHqjJve
	3YYL+ew3nrk08Xg8mp2eAhq7C2Hg8E4SvspnMUTKqvkd3nZdCuZ/hMZei3amG3PTwGgOUdwzbCP
	T1nzqye+oEXMmgjctnjD06xREx0xjafbtTjBkxDh83cBCO3ygM8+Z00PoZXOi+HXrb0S83MFTrd
	y7pKjsqYVno2oFXOuGsUjl1eZChQOOl2rKdN1cH1sjh9F7hIIJDNcXuI/XMmrmSUNRza70IlR0b
	gJfzF6YbeMTJR2aR+fNvkmDdL372eyOsTp++77mDufzjdM4kzlih2ryG7VRZSQu2hp9/f5imJYD
	0a5p0Mtg7M0JhfYHsm4CuSWAWIs1Hn72ptpspSOhl9BWICl98I1ObRoydOw==
X-Google-Smtp-Source: AGHT+IEBjqYLg0XLwORZyVN3qQnBYBCNWqLCOzyqFwj64pAzvRZBLWpl1DIWXO+pr6Q6ErFNviLU5w==
X-Received: by 2002:a05:6602:b91:b0:93b:c3cf:9873 with SMTP id ca18e2360f4ac-93bd17ec199mr1511233839f.8.1760119297356;
        Fri, 10 Oct 2025 11:01:37 -0700 (PDT)
Received: from [100.64.0.1] ([170.85.6.207])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-93e25a95cbbsm116859739f.22.2025.10.10.11.01.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 11:01:36 -0700 (PDT)
Message-ID: <178f4daf-c752-457b-8f0c-c6273f3a63dd@sifive.com>
Date: Fri, 10 Oct 2025 13:01:35 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 16/18] riscv: mm: Use physical memory aliases to apply
 PMAs
To: Emil Renner Berthing <emil.renner.berthing@canonical.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Conor Dooley <conor@kernel.org>,
 Alexandre Ghiti <alex@ghiti.fr>, Emil Renner Berthing <kernel@esmil.dk>,
 Andrew Morton <akpm@linux-foundation.org>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
 <20251009015839.3460231-17-samuel.holland@sifive.com>
 <CAJM55Z9kRpc53s3Kip=U-CcDxAX0UZD5AbTBy_owU8xPEYH5MA@mail.gmail.com>
 <6fa3c728-5048-4d26-9b6f-21757320caad@sifive.com>
 <CAJM55Z8masgGn4vVe_2g1e9WXnLu0Vf5oGxbiniGpsbOhYPLRw@mail.gmail.com>
From: Samuel Holland <samuel.holland@sifive.com>
Content-Language: en-US
In-Reply-To: <CAJM55Z8masgGn4vVe_2g1e9WXnLu0Vf5oGxbiniGpsbOhYPLRw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: xhapc1cz6jdeaf1oznyqbwd4ojspddru
X-Rspamd-Queue-Id: 9015640019
X-Rspamd-Server: rspam09
X-HE-Tag: 1760119298-867733
X-HE-Meta: U2FsdGVkX1+DS+szegqgrLbXsiwCysDHfY/WHt0Rn2FbbfwiUrcxvn2eW/S74jkG4MdryPqK3BJEM0u+/vhrcr8iIPvjQwe3X/DhhLZ7H7XEhLSbIFizR25A9la/rfRZdtM/abPVLqB7Yh4LoeZZZChg1qJh1o1slu/BeJC+cIOnHj9VF5Heyb6MgrqcBfiEkaNFNZvDvKc0b2auLP16FvcwWWyFgNE5uCPd5QJa7njoNEdfo7H2cLk8B8CIVd6fi1Mx9zF5pli7FEnHrpRjyqScL4qO8YpdF/WCoIoL6layscDRDXspZIlNVoB46OAwz3PesRILKLbWS9e4M9SMunGCwMBrfxENZNOQUIA2Ak51E5ZQxQYLjLfTkmURUBkKx4t2pzYO5I7m6yvtYQksu1nYzSs0ve2ndQLUEAu7yqxDa+UOlq7xm2Hf8Zbg5xlzAho5UQ2DcKmkqCN2rQxAZ25/L0XPyigeIIjGjAvrCkWYpBaGRGRk5/4RkWML9vlWp7QfU33L3iRDrQthcK994oh5pFyCzELnYc9KzDLDjDVYRdjCImJOH24afNh30QgqbUoEVJbHX35DyyBTw8YmVyIauAFVRyOFj8FYYoXdUKDrqTlcy4gBK6TQjFoxUjI9NIy+bX1TfVpiJYZPCMQDPK6tUVZGrlhjBW1GmeWjkdk7T5+qZc4sco54GqlShpUG9Y0ABnIuA3H10ic+zkRCW5VBDla4icRHcm2kSoWzjXCT5B3UGXXjZO3PfLIO3URkr1sbVqP5EjQ6oYxo4q4YnAUV3jsmiJf7WprRUpDDJthgL8NbaOE2MkgFyz/Ur08hezJsi9813G3BAhHQELXqdlYR68lwE4DCbmEY2RgKM8svdNtOZg7z7hPQh3lKhuWEa+Y0P5jeX+GhKAEywnnQjv6utcheho843hB6CASSAThRzXscn53R8WMIENHOAYzauiWEwnbEJl3rY5pLupy
 cJXEIrRP
 o4OQ8i4YW8o86fsPgrPzER7rDfnwgRW0ETMXBL6ncUGQ3HMikd8FOJ6k6mJIDPnAfEVd5reHHvTbppy1dbVTcXTuFbxqs9iPxqebd2k2YLt7O9vCjdR09ef+jhV55Aa5JD8Qs0OUEr44VEfc2gz6jatAls6EmTClmbxJYHeLSt0vbOBFDK8rKasqsFsUzmjlIRNnlDj4X7SlhK2KG+I2mkzRSb9aa0CN9QS8458R0+lDw9Djy71BArpidx1BuDbEsTsfdNMqMp6924pyxDkRbok5ewRv1EAGcmSGaNCOiuT69XqjuwPKuDk3cbran9Z7XhbCQdwmcn/qpyzQXSPqhUZMdRLpsdaS3R606/QeX9vau8vPzFc/lrhfF7ISmhQxA+Fl05wnOm/K7824=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-10-10 12:04 PM, Emil Renner Berthing wrote:
> Samuel Holland wrote:
>> Hi Emil,
>>
>> Thanks for testing!
>>
>> On 2025-10-10 10:06 AM, Emil Renner Berthing wrote:
>>> Samuel Holland wrote:
> [ .. ]
>>>> +
>>>> +void __init riscv_init_memory_alias(void)
>>>> +{
>>>> +	int na = of_n_addr_cells(of_root);
>>>> +	int ns = of_n_size_cells(of_root);
>>>> +	int nc = na + ns + 2;
>>>> +	const __be32 *prop;
>>>> +	int pairs = 0;
>>>> +	int len;
>>>> +
>>>> +	prop = of_get_property(of_root, "riscv,physical-memory-regions", &len);
>>>> +	if (!prop)
>>>> +		return;
>>>> +
>>>> +	len /= sizeof(__be32);
>>>> +	for (int i = 0; len >= nc; i++, prop += nc, len -= nc) {
>>>> +		unsigned long base = of_read_ulong(prop, na);
>>>> +		unsigned long size = of_read_ulong(prop + na, ns);
>>>> +		unsigned long flags = be32_to_cpup(prop + na + ns);
>>>> +		struct memory_alias_pair *pair;
>>>> +		int alias;
>>>> +
>>>> +		/* We only care about non-coherent memory. */
>>>> +		if ((flags & PMA_ORDER_MASK) != PMA_ORDER_MEMORY || (flags & PMA_COHERENT))
>>>> +			continue;
>>>> +
>>>> +		/* The cacheable alias must be usable memory. */
>>>> +		if ((flags & PMA_CACHEABLE) &&
>>>> +		    !memblock_overlaps_region(&memblock.memory, base, size))
>>>> +			continue;
>>>> +
>>>> +		alias = FIELD_GET(PMR_ALIAS_MASK, flags);
>>>> +		if (alias) {
>>>> +			pair = NULL;
>>>> +			for (int j = 0; j < pairs; j++) {
>>>> +				if (alias == memory_alias_pairs[j].index) {
>>>> +					pair = &memory_alias_pairs[j];
>>>> +					break;
>>>> +				}
>>>> +			}
>>>> +			if (!pair)
>>>> +				continue;
>>>> +		} else {
>>>> +			/* Leave room for the null sentinel. */
>>>> +			if (pairs == ARRAY_SIZE(memory_alias_pairs) - 1)
>>>> +				continue;
>>>> +			pair = &memory_alias_pairs[pairs++];
>>>> +			pair->index = i;
>>>
>>> I think this needs to be pair->index = i + 1, so PMA_ALIAS(1) can refer to the
>>> first entry (i = 0).
>>
>> The code here is as intended. It's the PMA_ALIAS(1) in the DT that I should have
>> changed to PMA_ALIAS(0) after I removed the special first entry from the
>> riscv,physical-memory-regions property. Patch 18 also needs this fix.
> 
> Hmm.. that doesn't quite work for me though. Then the "if (alias)" above won't
> trigger with PMR_ALIAS(0) right?

Yes, you're right. My fault for trying to be clever last time, where the special
first entry meant PMR_ALIAS(0) would never be used. (And for not testing with
the same DT as I sent, since EIC7700 needs downstream DT changes to integrate
noncoherent peripherals.)

For v3, I plan to make PMR_ALIAS(0) set a flag so it will be distinct from lack
of PMR_ALIAS, and keep the indexes zero-based. For now, you should be able to
test by keeping PMR_ALIAS(1) and adding a dummy entry at the beginning (for
example by copying the first entry).

Regards,
Samuel


