Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D0B6D3B9AB
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 00:29:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D4C46B0006; Wed, 10 Dec 2025 19:29:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9858B6B0007; Wed, 10 Dec 2025 19:29:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 874B66B0008; Wed, 10 Dec 2025 19:29:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71AFD6B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 19:29:38 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2361C604A8
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 00:29:38 +0000 (UTC)
X-FDA: 84205306836.02.2CCE366
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0B640A0012
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 00:29:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=R+9YAy+F;
	spf=pass (imf15.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765412976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hph6c6mLrMrxrVM4J3elgrKqEusrkULz2AJc0PIUBG4=;
	b=HqVYWrx+V93c2p8oFi+LVlRHEBaCLMWVBboTEmI3WC4cwqnJ87TVZRdDWFrJ0kLL65tfFy
	hDDmub/+eazqbqWzpbYidhKE6b4xVDaIB6R06PBvitUHnZ6KJyeSrRM+xnFqpz7ipb1pqs
	vziUs42LXpov9fIJ3kuIWO9JrrO+Xok=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=R+9YAy+F;
	spf=pass (imf15.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765412976; a=rsa-sha256;
	cv=none;
	b=pnfY6cmmuSf2JC20AWwULjUYJzDeQkSk6ro4c6jzgJ0J0PVxcvr6bpvTKOEaXBKP5Sxm0t
	8eJGYeOc5280FroqRnmaCdt3cNjP2FepqZpVF1/qTWuXNh+h0qYyOlO098W/orxvfa66rH
	skw1DxKOM2rD0WWH5zYuNvIxdZeskEg=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-298144fb9bcso4296975ad.0
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 16:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1765412975; x=1766017775; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hph6c6mLrMrxrVM4J3elgrKqEusrkULz2AJc0PIUBG4=;
        b=R+9YAy+FhtVAXQbc3YGNEAjN01cmeULdaQGwUAhTpbDiA4+YC7ZeNrzdmlFfQxvZ4p
         N0Xy7FgOoUDyWHsBSeGbRfNMKR3xgDKQvyhuPok5UO7KXskr5DcGw/5RIes9pFsVbz/D
         pyKSEYPbMoGljzK/CPYhVyzsVY+iV0kOiKlIJmKnZVW4YpyWXd8AhkmdnXL1MC/D7HhB
         s8q6pAGaIfmPARCjVUeQI6dgMsmIND2Fd3aSPVuUBJAOiMiVJpzv3iXp+YPWw+uQo42e
         LgWd2acjnL7g2NzUAs3Esvj09wAABC4A4ESf0N/7/MtsjQO3d6EjZV7teECvaTB3qN4o
         IbaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765412975; x=1766017775;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hph6c6mLrMrxrVM4J3elgrKqEusrkULz2AJc0PIUBG4=;
        b=EIOCmstWY/hRG6U1eP4ZJUMAFZO+MLfEJJ88VTsevRRm5zm+HkviFVVC/tECi/g3dJ
         8/LnM7wBcsOepXlsdZAk5rZmpJH0nLGcC5MaEfWDTt3GRc+/fY8h0gKg2dn8/p1YJbjd
         kRqAsUj5TfYsJsyjfLu1oLonLXvlIMJ+K6+1AoR5h8GhYjv59TdTYs62YfAinePyE4rK
         Qwr+o1Qn8ApW3xOPkr/og87yYKC7z6nrlaXJegCBvrd7CFgrkzQR3EtPcfbfsP9SAOKL
         jNnMhz0ISWtdBACvb/WEaC/MSzREG2a/TumQAJWvt2wD5pgBC2AErn53ag/MCTG3N2ou
         W/mA==
X-Forwarded-Encrypted: i=1; AJvYcCXTUgiubsUlcGGyMC8BOncjKYv7yvjyJqTq/w5gljcfTZer1NH0+ed3HtsK9op5cUbxBWvkHH5/PQ==@kvack.org
X-Gm-Message-State: AOJu0Yy2v4N+N/kT9aJLwwCMYphOg0LXp9lXLdB9ZD5CD6laSaGjU1DW
	OyeAEHCZsNtvRjHgA58P00b6eYqeIiOJOf7aPyGeFNCZaIVwhpG4wpdAb1cEY9QlsCs=
X-Gm-Gg: AY/fxX4U2EBXs9Dsgiojfh1aBsLtskANzsOrFW3tSE6QXdqUDaMxsQ4RJJZRa1l1pYT
	twsU3Qa+X0ZSAhFzHQ/yuAv6BmGcwCt2V1t5WxgR+CRryxE213IPlcyX7nyagcgE7D/Dg1iNscx
	L65dGzkEo3SXuxYOZ2FwsRAeTxfO1yTkmULTtvUwlqz07aqUJUghQRIg2meujZaLOK6xYPDxVPr
	JsYGnilOwgozCUX9F0A08kcEPeQGK75eWZoQEE3j1YHSc26XuBqYWbH2+Oy7zellQmyv6tRbuYv
	GY8OpdGpWzfPOPpjOZq7TSpZQJW8P2gh4P6NFF0w7FgOoy0f2oA/0WefdIINcFQq2HiQULne7UW
	Fj5o8Y532BjTG4imbLcrVeBo0l2XcjNTqc7c6KYy5u28HH4jQJa7v6QPt/ZUX6/xsHcvrC1KVvi
	aGoBB3x7pcvO/3HPyIfLpjTI0HMNrPjQ==
X-Google-Smtp-Source: AGHT+IEqajP6+u4eTxzUYHfF6PVb972s/3Qa3UlhPbS0/TAJuALl6ObT5PUNXanFEPyHtJ8XnDuE7g==
X-Received: by 2002:a17:903:234c:b0:299:e041:ecf6 with SMTP id d9443c01a7336-29ec27ce2b4mr43176775ad.40.1765412974654;
        Wed, 10 Dec 2025 16:29:34 -0800 (PST)
Received: from [100.64.0.1] ([167.103.29.104])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c0c2b8e0fb4sm539653a12.25.2025.12.10.16.29.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Dec 2025 16:29:34 -0800 (PST)
Message-ID: <818ba76e-0553-459d-b956-520f23762034@sifive.com>
Date: Thu, 11 Dec 2025 09:29:28 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/22] checkpatch: Warn on page table access without
 accessors
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Joe Perches <joe@perches.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <pjw@kernel.org>, linux-riscv@lists.infradead.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: devicetree@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Conor Dooley <conor@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
 Emil Renner Berthing <kernel@esmil.dk>, Rob Herring <robh+dt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Andy Whitcroft <apw@canonical.com>,
 Dwaipayan Ray <dwaipayanray1@gmail.com>,
 Lukas Bulwahn <lukas.bulwahn@gmail.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
 <20251113014656.2605447-8-samuel.holland@sifive.com>
 <1dfa1e3566cafbe43a1d4753defef9c82ddb3b64.camel@perches.com>
 <a6e7a571-91d2-4e66-bc86-ba30f624294b@sifive.com>
 <273b638e-8251-4faf-929a-87432a48abdc@kernel.org>
From: Samuel Holland <samuel.holland@sifive.com>
Content-Language: en-US
In-Reply-To: <273b638e-8251-4faf-929a-87432a48abdc@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hbgoti6n3jwudu5eb6xkq9zfhbuwkgz7
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0B640A0012
X-HE-Tag: 1765412975-103994
X-HE-Meta: U2FsdGVkX1+vwBWFZnuJJ+7HF8IRIRHK0R47pHEscZ55A3pGUIRNckzv5vsBcNsAAsFCbzWJd8K5Dm7AuhP6B5Wy+9uBkA9VY/mUfVPjAuY8Hs2VDmrpeUdUI0ng7/RXdTCX6GSPsjgRu8U16jNGrm+fvJkT5UhWwQCn7QMidlhGktmq7kZmh9+4NH1lDq/zQQfCDYL7oPJ3YSKqiiDBTeJ1E+bEs8SgHHhFgdYcX5nUX4g2nN7yextMOWT4Yw3KnH2jef1OWutYqy2lY2eQBgBi1rvxirF742TZpM1lbqgPL/Cj9PJ56xxwzbl6EOvmNXD16gN1P7RUfgLO6J2dXVAXkMjdCRF0iyHTONMPgwXxTqsgb5ajTaBEusTKi+zcNbHKKP8Cet8HLWHULmXWTviDu63ZC7N19hXcPpmXeI2DaQl1Xf3ZDAWkcvURi2ajdTYrWzA9dRRWMy3275mSJm53xwJ8eOsar+xlqyPhhvsyGNAa9nTx6cclpkdqs3L8gn7v3rT6Rb/FFatrhiC61380BU4SjXWxPnRPAUyzKHs4pK+bKP+0knNC+e/PmIDRVNZ1qx+soc4LYk5K1KdKJEkyIaNEdgB7ohN+obPaIX7DpOr4Ra8p25Y76idReaJYZg1MrpcJ28x4yUo2hTFb5jX+yodACIFFQBTm7xigYg5+cndEIZBIGtKI/qW0iG+vyp1QGk7IcNdGGaF+Gan+CSpyAr/qeCIZrWDR/hi62XJplJydja0DKb89m7WUJZFJrhlsVl1GPMiLROt98Ra0REDWDfx8uoCQdxrMCuP0QOI5FAaRexdDmjadRpwVkfqvhYTjEdvnfQpzWvM0jIB987H7LwA+xHvgMkQjrlcVxMMXMDbjYdkcYmvNa/xukV94dfw3KGLzHRKuhaR7ld52X/Bb6egIJpBYXgwAZk7L/EFoQbPDqrw64s+WF4OXAg0nR0jV95IYYVjAhva3Zwi
 2Y4RXn2C
 W6PwgbZMxOhuODUV1yl8Rp+e4P4PsVuIHox8fNWMXkuLGtiNnw/aKuhTo0ctL30UOqXFMs4gw5MDuVJyRQ1DG6hiTxL6By0MP36daZJ28IWNibkPhHvr1QpzPPSO/q9er7mSDZ14DZf/PWG0N8NVtFVnB7NAAn47aTC8a8PWQw3LtScEfPaXMzj/QHTm7vuRlXzTvg2xUvA2kg5U9m9TXAMja02BeQujgxJ2/v4XyaefmEjQhbr92lZr/eZOG9oO4i3Q3k7wOlwrMF+i0hY+UFEkXqcfDlHkHnO6IrFskLG6/999bp7HEz0J/gvxP65bGBCTdn1mcdJbimobUSB9W9+r6qWy1QhLSSQuDBUlbJrEqwDPi5860ngKq5BYO9Oz1E7hg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-14 4:17 AM, David Hildenbrand (Red Hat) wrote:
> On 13.11.25 03:36, Samuel Holland wrote:
>> On 2025-11-12 8:21 PM, Joe Perches wrote:
>>> On Wed, 2025-11-12 at 17:45 -0800, Samuel Holland wrote:
>>>> Architectures may have special rules for accessing the hardware page
>>>> tables (for example, atomicity/ordering requirements), so the generic MM
>>>> code provides the pXXp_get() and set_pXX() hooks for architectures to
>>>> implement. These accessor functions are often omitted where a raw
>>>> pointer dereference is believed to be safe (i.e. race-free). However,
>>>> RISC-V needs to use these hooks to rewrite the page table values at
>>>> read/write time on some platforms. A raw pointer dereference will no
>>>> longer produce the correct value on those platforms, so the generic code
>>>> must always use the accessor functions.
>>> []
>>>> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
>>> []
>>>> @@ -7721,6 +7721,13 @@ sub process {
>>>>                   ERROR("MISSING_SENTINEL", "missing sentinel in ID
>>>> array\n" . "$here\n$stat\n");
>>>>               }
>>>>           }
>>>> +
>>>> +# check for raw dereferences of hardware page table pointers
>>>> +        if ($realfile !~ m@^arch/@ &&
>>>> +            $line =~ /(?<!pte_t |p[mu4g]d_t |izeof\()\*\(?(vmf(\.|->))?
>>>> (pte|p[mu4g]d)p?\b/) {
>>>> +            WARN("PAGE_TABLE_ACCESSORS",
>>>> +                 "Use $3p_get()/set_$3() instead of dereferencing page
>>>> table pointers\n" . $herecurr);
>>>> +        }
>>>>       }
>>>
>>> Seems like a lot of matches
>>>
>>> $ git grep -P '(?<!pte_t |p[mu4g]d_t |izeof\()\*\(?(vmf(\.|->))?(pte|
>>> p[mu4g]d)p?\b' | \
>>>    grep -v '^arch/' | wc -l
>>> 766
> 
> That is indeed concerning.
> 
> I recall that we discussed an alternative approach with Ryan in the past: I
> don't remember all the details, but essentially it was about using separate
> types, such that dereferencing would not get you the type the other functions
> would be expecting. Such that the compiler will bark when you try to dereference.

Even if some functions a new incompatible pointer type, don't we still have the
problem that neither type would be safe to dereference?

A similar option to a new type would be to add a sparse annotation to the
pointers that reference hardware page tables, similar to __user. I have
prototyped a coccinelle script to add this annotation, and the sparse checking
works. But I don't have the coccinelle expertise to automate the whole thing, so
there's a lot of manual cleanup required. And this requires touching all
architectures at once to avoid introducing erroneous sparse warnings. So I did
not include this for v3 because it is quite a lot of churn. Is this something I
should try to fully implement for v4?

Regards,
Samuel


