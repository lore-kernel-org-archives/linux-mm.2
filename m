Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8E3DD1CDB9
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 02:34:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC8F86B0024; Wed,  3 Dec 2025 21:34:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0426B0026; Wed,  3 Dec 2025 21:34:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDE1D6B0027; Wed,  3 Dec 2025 21:34:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD3E86B0024
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 21:34:36 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1665813BC28
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 02:34:34 +0000 (UTC)
X-FDA: 84180220068.03.A4DB6D7
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4B6E710000D
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 02:34:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=Ep2HXzrs;
	spf=pass (imf14.hostedemail.com: domain of skhan@linuxfoundation.org designates 209.85.210.50 as permitted sender) smtp.mailfrom=skhan@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764815672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J15Qzup8zpCFV/gNARQXdZ6OyPMzPDnFJCLC0cemZ8E=;
	b=6s4HpK3E9hwiArZJFOeOYH26rIdQ41kMq8koxD6OE7gPJ7JmievceA9CJbYfJG7Tv+bmsR
	M78eyIFazWlwQW+UV3yYYNaKbT+nSQF9Q/P+hS8fl1yyGzNkoyj3jeOdbXWkbBX6c19AQq
	zUJ6IldaDdhI1ZRLzZI5WUL1dawQJYY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=Ep2HXzrs;
	spf=pass (imf14.hostedemail.com: domain of skhan@linuxfoundation.org designates 209.85.210.50 as permitted sender) smtp.mailfrom=skhan@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764815672; a=rsa-sha256;
	cv=none;
	b=ntI3vEaNbKjMpBbA+zH7T/GXSFciYx8/afhrZKXE6gPQ+nC5SegBETaxn5U1tC+lt8Kcdf
	QuRifX5N6ms6VmQGtedYAaRg7ebLnwzqhasHuD66vHevTqLXJvkttKSFwWeuJTT92ymvUa
	StuM3rHzSg/zYL+HMyl976K7xji5Qj0=
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7c75dd36b1bso340777a34.2
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 18:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1764815671; x=1765420471; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J15Qzup8zpCFV/gNARQXdZ6OyPMzPDnFJCLC0cemZ8E=;
        b=Ep2HXzrsWLZ0DDYjK+UQekmwdzGFizVlZ0oLzpgib0vt+G6BCqwegTKGB6ekzk5NJy
         orA2rND5yGCSTrpDw+5nU7Psr0QOVnYKQYhSL6Ajop8ONy1w/UR/qQtPcPmfKRhcXlyS
         fga3HeY+oWX0RGCWjHn+8GHdi548DkLAtxCdA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764815671; x=1765420471;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J15Qzup8zpCFV/gNARQXdZ6OyPMzPDnFJCLC0cemZ8E=;
        b=myFZB5scwixDiQs4KporUEPCmH8nm2ZWfP57T7U05vFkJ0ZUyP9OOCSRUUwLKxnaKj
         aIArxlAvXnufgmuUFf6R9n3toh0wteH6iMZKP9olu12zDuOy+kLCj5ZA79vn0qU3BAvJ
         8jVPmz5N8Oap6PsS0DJE9z+dGTFghafbrCuWWuvh8GwSpnvyQgs//VQjS3g7O1qJ4RuL
         RUSY5gsUZg7WbLoWyk+G+Pl1Jbu6aTGXTiHazelDKMum5NRyQwlymqBb+liJFf8L076g
         AC1AmqVSSv7tkqW+ZgNC7QEH5cFaFschqFix/zVqZwd1SoyaZIZkcY3BkHpdGiRPzR0r
         3scQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1xM3xoVi9NCLIvA9t20Y9Z0S9OGP/89C4JEn6JZoQAWv2MKtvz9eW3qnj8u8qpLIYFJf/Z7YRNA==@kvack.org
X-Gm-Message-State: AOJu0YxSltscVcQCzpZyfMixxBwbrvoHhzOTRQHYzUSPTYZalAXhp48I
	1VGu5Ojv2UVsguYI8i+1JBN3jJwqp+BTeBD1IA411ng18X7aQCYGs2EHgZ7gDoSnIAE=
X-Gm-Gg: ASbGncuJbFtHXk+r6IPNNaOwciOa2HiK44YZLsUmrkBmdPLSqnS5Qt7meyJpPDrArpa
	TIhV9I3CouAX+IS4rdMOPX1R9p2y81mlPyq7VqrMT+X8TdPAconDikemejaQqmvSXD20sFGpUQc
	IzZjqp4kJfanl8KMR75xhQtxeJICSv/gJUj6ZZWkEDjA9kmG2JeXwuG1pfGx3cCHSF56Rypev+E
	YL5Jz1bDnhGUhLq4Ub0X5q1Vj2AXf3n3O28V+ueXcpPyOfxPEzh17Lkx7kr813NugbTZhcmv4WW
	JaMAXJHCXHU/EH+MKaU8vj4f4CvdIdPB0kE3CHq7kE1IcKRNYY4TrrX/HZsgaNkjnj8/EEncMm/
	jzE9/0npN6+zWzs6cf0Eu01cp0g93HgBzeAf5cCtyr3QVn0iwYbDiF3qa8Ppc28Lg+gIhS6x+gC
	jR77tGBs4wrT47nj8R600aiU0=
X-Google-Smtp-Source: AGHT+IEWnMa2HXMsFLErerMFo+SUotzMPb4bdwSPX42eEhpYWTcWb/bFzyKol4nu8Pe7T8YoPPT7HQ==
X-Received: by 2002:a05:6830:411a:b0:799:de78:29d1 with SMTP id 46e09a7af769-7c958b91783mr870804a34.15.1764815671317;
        Wed, 03 Dec 2025 18:34:31 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c95ac84d2bsm415620a34.18.2025.12.03.18.34.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Dec 2025 18:34:30 -0800 (PST)
Message-ID: <5af4522e-30ab-4eec-a861-c2760cdabd4f@linuxfoundation.org>
Date: Wed, 3 Dec 2025 19:34:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Linux 6.18 amdgpu build error
To: Linus Torvalds <torvalds@linux-foundation.org>,
 akpm@linux-foundation.org, david@kernel.org
Cc: Alexander Deucher <Alexander.Deucher@amd.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 amd-gfx@lists.freedesktop.org, dri-devel <dri-devel@lists.freedesktop.org>,
 Guenter Roeck <linux@roeck-us.net>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Shuah Khan <skhan@linuxfoundation.org>
References: <74032153-813a-4a40-8363-cce264f4d5ea@linuxfoundation.org>
 <1eb24816-530b-4470-8e58-ce7d8297996c@roeck-us.net>
 <0425d7b4-76e4-4057-83a5-a7b17a051c54@linuxfoundation.org>
 <ec77d11a-7613-4b75-8c9e-f2bba1595f0f@roeck-us.net>
 <9d520a1d-0b8d-4d30-b29f-230fc0f92b8a@linuxfoundation.org>
 <1f31b86d-283c-4878-92d0-ab90aed0c58d@roeck-us.net>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <1f31b86d-283c-4878-92d0-ab90aed0c58d@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4B6E710000D
X-Rspamd-Server: rspam02
X-Stat-Signature: xa58hz6i8i5srfpctiz7jjo4znczed8k
X-Rspam-User: 
X-HE-Tag: 1764815672-12106
X-HE-Meta: U2FsdGVkX1/VJb2pb88Aw/YNF37iaCXcQ/cVjErjsYkg/wtQC63K4S3avJ5VpVGQbg7ff+6pxPShQoZF1pml6LqD6bCoLsqgkNy8NGTzUr5DYI9Iz0Rkjr46zGrzNNHKHSakbpZfDuZEf1fCG+0Nqnm2PNP2yw2H+y3vjpUhfjnOzEuCCly7DsP5cHgYIjfBEfxesW4cJaeFmoRUtUOlk8RNRtxZGBohi4NjoJZL+a8w1aMEt1oPfOqaclHG3Pl3fSqgOoyOS5pd6K4vwiLn4FiL5xH9Ce5zJ1X/HQeO5pf1SLvXjaZHk3HWDbw6cVrLZAv9VzoV7RgORiapRErZZYZ6MyXqRdUbzIN0Sb4TVn8LHBlvIgHLPiJjx22PpNWNhguG9YFPHDIuI52KgusZ6Xi7uZdeeLHPuvk2qZQds4S3rlzUf/fAGpOLOZYVY3RflXaklFmYxgNbn9eMAQG6dEU5cfIQ+1nslgTKPAf4r/tLIVA5516pJykCyfRI31tkfSeJ2wh9k0KWncGlgMuud8VB+w2RkIhaW19C3/ph+qTH458YTX9VEVpCgVZa1soaRF4F/n3EkvjgIvmwyYLEJdBS6tCwkxmWoJy0b+5O0BblzsoRSOrVWOHL/yAoYdBCTGl1kRWeX1ql7pf8031mpOCWqtrEfxKSwhJtjgD3B0uH9puAFiVDKSqkSnvvDFCpNGBvg6pdWO/N/7PY2qJzcN7UR/ZisZyceaYOsZ/MUHu3NVVlTWQMmuNpWCAZ3l+jYwyMNd7I5BIW+cfyW3s4qgEMeAIgMXcBYWTTl6unpmZf06Z7F6JbXncftlctp8Xpz+xhdwU/0+EhIJJdNnUO1KlJV8eU2f0Cp1pLjpGo+yv1Q9hUm5F6TnBwVhskdKbbRM/7Uj/06K7QkiUtL8ccXwEck+k4Ju6eVl2wLqfNb0n+sLIUcIp1MZGFwplshC0pkffD9A8SsEG/qoZyK9c
 tDPcCnPr
 oB60Pe7k7bYHAtmerNHgLhxXGR7pQ4/2oiTirmEmM98LW7eXLEFCR7R326Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/3/25 18:06, Guenter Roeck wrote:
> On 12/3/25 14:16, Shuah Khan wrote:

>>
>> CONFIG_RANDSTRUCT is disabled and so are the GCC_PLUGINS in my config.
> 
> I guess that would have been too easy...
> 
>> I am also seeing issues with cloning kernel.org repos on my system after
>> a recent update:
>>
>> remote: Enumerating objects: 11177736, done.
>> remote: Counting objects: 100% (1231/1231), done.
>> remote: Compressing objects: 100% (624/624), done.
>> remote: Total 11177736 (delta 855), reused 781 (delta 606), pack-reused 11176505 (from 1)
>> Receiving objects: 100% (11177736/11177736), 3.01 GiB | 7.10 MiB/s, done.
>> Resolving deltas: 100% (9198323/9198323), done.
>> fatal: did not receive expected object 0002003e951b5057c16de5a39140abcbf6e44e50
>> fatal: fetch-pack: invalid index-pack output
>>
> 

Linus, Andrew, and David,

Finally figured this out. I narrowed it to  to be the HAVE_GIGANTIC_FOLIOS
support that went into Linux 6.18-rc6 in this commit:

 From 39231e8d6ba7f794b566fd91ebd88c0834a23b98 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Date: Fri, 14 Nov 2025 22:49:20 +0100
Subject: [PATCH] mm: fix MAX_FOLIO_ORDER on powerpc configs with hugetlb

This appears to be large change than the powerpc scope. It broke my workflow
completely. I sent a revert so this doesn't cause problems for others.

I can reproduce this problem om two systems - with this commit

git fetch-pack fails when cloning large repos and make hangs
or errors out of Makefile.build with Error: 139. These failures are
random with git clone failing after fetching 1% of the objects, and
make hangs while compiling random files

These failures are random and confusing sending me down the path of
looking at tool chain. Without this commit, I can clone and build
kernels on the two systems I was seeing problems.

thanks,
-- Shuah



