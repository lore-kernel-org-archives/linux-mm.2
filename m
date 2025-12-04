Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24132D2444A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 17:40:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C4146B00B5; Thu,  4 Dec 2025 12:40:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7740A6B00B7; Thu,  4 Dec 2025 12:40:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 663916B00B8; Thu,  4 Dec 2025 12:40:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 513836B00B5
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 12:40:35 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DA3C7C032B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 17:40:34 +0000 (UTC)
X-FDA: 84182503188.17.F815F36
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id CDC8740008
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 17:40:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=hyuUpEMs;
	spf=pass (imf11.hostedemail.com: domain of skhan@linuxfoundation.org designates 209.85.210.42 as permitted sender) smtp.mailfrom=skhan@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764870033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7Rn5OHlrxb2qkeqjO8QCULVMCiSnHuDaJSd7PMI+Cc=;
	b=C/Z2j9540EtM6xB2TJN1YONlkJ/zVgcFGKkVWN0raioglbFONeejvseRbim5CL6MCBTFDy
	azwXzP1XspCNfryxKOexr9gpMnp6UFJS+6nx2gr4JLZgHZJ2BgGINWKJ9dvivOLUsYz1FN
	X1adY+TgrjflY1UgZRQhHD9pCqZ8njI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=hyuUpEMs;
	spf=pass (imf11.hostedemail.com: domain of skhan@linuxfoundation.org designates 209.85.210.42 as permitted sender) smtp.mailfrom=skhan@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764870033; a=rsa-sha256;
	cv=none;
	b=VFFmd5PZIjP0KWryMV4Ox3G1xuhbq3+QmI0KO9ZxKjIM2NhKv6MLG7LRrzXFEkOSaHn3dW
	5nJSj0x9CPmqifpPfqlZtXGbBbiW1YkE9j/HHCXVk5VOu0kh2ckeY48ub92vej/K5OpavN
	B1HiK9Nv/KKkQKfmv0Ael6zHW6tEqvo=
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7c6d3676455so614754a34.2
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 09:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1764870032; x=1765474832; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s7Rn5OHlrxb2qkeqjO8QCULVMCiSnHuDaJSd7PMI+Cc=;
        b=hyuUpEMspKJduBClD5mkubRdL5rQTaSLx8RA4kMdfwF04zwhoZX8aH3ZnfnxBy5a/H
         fTHJEYtML9FLOqH+fSGKPubDHXPzPH/ixP/iAtmQWg3aVx8hh5GZxMOrJYtMWeiNkINW
         tyerEf6m52Do7JhINJSVzga3d078j4xgOPH30=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764870032; x=1765474832;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s7Rn5OHlrxb2qkeqjO8QCULVMCiSnHuDaJSd7PMI+Cc=;
        b=sGLG1kMqu/dBmoRWZHsfLGPBn2yGsa2LWSaZ9hx7mOXaGpu6jbLmZMRhtNKDG0ppVG
         Gtj6//2sHutpVbEQKZunZ6fBO9194k2rOsEj78qMXYUwZUe3eQAQbYhjnfO4zeXYMqI9
         63m5FQWjHOHatomyHBs6zosBFIxgybm5DsWCTixrCl1DmVvIIjvU2sNiIexPrCrdwU4X
         of/CP5CcmihE7snHWOkygl3coVLQaRsAzxgRxA80aXc98zNyTLNc44Gd1PMcWt15Jgim
         Ytm/EPIJlYqasXTHdK/b1KYao65eK3zJQNSRaTO3AIYmU3J6gBYLxEzKBTEph8JNkoZg
         gkuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjoCI3mYT7LL8pHI/zTky+82FuIXseB8LkzwjXYbgl7q86hgTRjY8CcqO5t+oCwR8vnNM3KtuoeA==@kvack.org
X-Gm-Message-State: AOJu0YyH1+zFPChDXuZ7vk7J5d65uQ8QlChE6NqMWZ67IiMc/vTcZQ5B
	qLRfvxhHamAKRJ3RiTwsLUxHasSzlEniOajmxfbb++dujDBgxvoGSggyR6kdSvpiuXI=
X-Gm-Gg: ASbGncvxPLmKTWRioJYV8+XPs+NC9xSqe5VCYeJpAldKXmuWbSlAcFLnx4BV1zvODz8
	3WJm5wVZs6VJIx4KoPCXH3yaf2l6364FYifwvyvvYb64d7GcEI9X9z2aA2F/Dbuk5HAIZ6bZJ06
	v0ef3EsYaMJb4EQQZrTgvLlzK4iS+LNO96kJbMuBXWD/s2M0jWBwVN6rRNF4pwFP9nvSJe48Qz6
	zXgXINFtzkHPW/5Rt963kPXDAXy6Z3Tr5CIJ8HE8kDpIzLoGtKu8cUpY+KuLlJQPCiz9Dvl4Aow
	1zdZgDbLdbKT0jiWoCGgNoDIwZP4k3n/H0mhvgvviAhHLMu1WTK6Cl7/QmKs4DUVPpNHF5GnDQx
	dw1k4xYvZkD+CvHZA1n8eXsyTfvkrZn9dj2TbCiI0iXtS4y0X88aK7onWRaxEeWDfPsUw4gyq5G
	4A8lLEYAA7Gn9f75whzO1U5uQ=
X-Google-Smtp-Source: AGHT+IFXMYm8uo/02RyQ9KYlJ4KVuvzBZjjPLJoJhlhqhfro08LIJnMS5kW+39YjCpGAgxuJvojUKQ==
X-Received: by 2002:a05:6830:2406:b0:7c9:5c77:54da with SMTP id 46e09a7af769-7c95c775a7amr2219135a34.17.1764870031834;
        Thu, 04 Dec 2025 09:40:31 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c95acff1bfsm1802681a34.31.2025.12.04.09.40.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Dec 2025 09:40:31 -0800 (PST)
Message-ID: <b24fc85c-0e6d-42f9-a6b9-05136409098f@linuxfoundation.org>
Date: Thu, 4 Dec 2025 10:40:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Linux 6.18 amdgpu build error
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org
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
 <5af4522e-30ab-4eec-a861-c2760cdabd4f@linuxfoundation.org>
 <2bc690ca-fa57-46fa-949b-28b5441cd364@kernel.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <2bc690ca-fa57-46fa-949b-28b5441cd364@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CDC8740008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: e7rrsuf34iost9pbjm7yxuz5jeqe4k9w
X-HE-Tag: 1764870032-248383
X-HE-Meta: U2FsdGVkX1/TbL/Lci7/OKbu+L9CqREfOCas9rKtZRcYaQG7sOdLMPZmovGbVstiAkPBsNqWjoc0Vzeayv8rObQly5I5jpEt0JHkFxz68+s8qxPR6FlgkgKziRpLJzP3SgaQIKEl3xtx+rpNCTUZpvg245mhxAGHhuCMOMRfNJe/4gPKPgYcafEnSVBYGkbUa7HP6sv95pfm+xb10jvLUD1ssioiBvWM1+xPJUus8pf5QCYx1kXMmtzjA1oPtBAUndENo28JZkyPch1iZHN9oxnjK4X3GTIeF8fqgtLVWGhT6QDz09lNs8ID971tnrkJ7n5YVZl4fNwRU1hHkdF8ja38KaVvkRr/Qxt/v/zayr3i2IZKh+HfSV1CnqEBwgTZZURLTLHKEeGcOFRmauOrRFcSR9tEKI3CzaA4HreVXuuwJ4RJwVLBDPloc9QlEhBHK9iZg6B4qJGWcB9PBvUA3HHhvdvOOYN36RjuvPkzX2fNurB8Hn7bjBOkOO33EHE1P57C25GN7ff4q9N7CquZmgAV1nVOtuTXdOiLW2hWfjd6WsMIu/nwqu++GDwPFp1HudJO1syM+yy6VXFPD/Sg3uvgv+RWGbEkxp4ThOANmBtkciIUpW150MlZ/BruMX4GxWI+dBjsD3/MaXni+LS8XIeLGDsef6WsZPN365ck6IlqFsi3UTErPJxuwgG/mRDcN/HZRJ/FT2l5CuukkB3xyigxu7LO3YYnZixwli1GQlCGsUvwyU3qBtwikrE0Qq5L2LOI8iRRJq4NK0zmLhEI5zfk6Q2hzcVNp4jg05zHrBGxQ6J2JUpjFgnjX5IiL9oHAHFS6GGV8GrmWdhwuSk/Qx5GpsM+PDKnnoQv/w0d+75mwYM7p9dR4QrlRG1fk3KAtBaptBBsMDrTVtunqRfx9u2DOF66oF6/qSrHsGLqeQXzSx/H/I6e+lkPJIMgUXaYfyaS1CdTniDdbk5808h
 s08ZVX5S
 TMls2Ugn7/yt6jTF8gCGc/STkkn6U3A5Ql6BSoLMuXlGsVmQlfksAyGSwxkgz1hH38+530KKmYS7NU99M00Mn6LQM26CsFDM9NR2qdaREZGP2yWxvcsDl1RdRWbwGXEnnJjWlIYtUiQLY5TqmCZaDwxE5GikHPVvnsW8e/2F/E+TLPpFnljCHIQCOPqDTgAcUmygWsUXUg2kF50t2uK+s7lLzhPwFAF1SDPq1dkYmCOkR20a6Ey8J+Eb0Ar7HUaYMiYAH2ch5SRZ/3CgZVJuVOTeH6/GBBAPJrF/Fd8fnhya38Mw+S6kOJStWyD8m345t2Ye9FAiy8vnssNBNDIeHFX2isn2T6gOkzWtEwbdmh+Cjmu31cw7JAHjJ30VwYpr+bBA22eDXPUxJECw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/3/25 23:05, David Hildenbrand (Red Hat) wrote:
> On 12/4/25 03:34, Shuah Khan wrote:
>> On 12/3/25 18:06, Guenter Roeck wrote:
>>> On 12/3/25 14:16, Shuah Khan wrote:
>>
>>>>
>>>> CONFIG_RANDSTRUCT is disabled and so are the GCC_PLUGINS in my config.
>>>
>>> I guess that would have been too easy...
>>>
>>>> I am also seeing issues with cloning kernel.org repos on my system after
>>>> a recent update:
>>>>
>>>> remote: Enumerating objects: 11177736, done.
>>>> remote: Counting objects: 100% (1231/1231), done.
>>>> remote: Compressing objects: 100% (624/624), done.
>>>> remote: Total 11177736 (delta 855), reused 781 (delta 606), pack-reused 11176505 (from 1)
>>>> Receiving objects: 100% (11177736/11177736), 3.01 GiB | 7.10 MiB/s, done.
>>>> Resolving deltas: 100% (9198323/9198323), done.
>>>> fatal: did not receive expected object 0002003e951b5057c16de5a39140abcbf6e44e50
>>>> fatal: fetch-pack: invalid index-pack output
>>>>
>>>
>>
>> Linus, Andrew, and David,
>>
>> Finally figured this out. I narrowed it to  to be the HAVE_GIGANTIC_FOLIOS
>> support that went into Linux 6.18-rc6 in this commit:
>>
>>   From 39231e8d6ba7f794b566fd91ebd88c0834a23b98 Mon Sep 17 00:00:00 2001
>> From: "David Hildenbrand (Red Hat)" <david@kernel.org>
>> Date: Fri, 14 Nov 2025 22:49:20 +0100
>> Subject: [PATCH] mm: fix MAX_FOLIO_ORDER on powerpc configs with hugetlb
>>
> 
> Unsuspected and confusing :(

This commit has impact on all architectures, not a narrow scoped
powerpc only thing -  it enables HAVE_GIGANTIC_FOLIOS on x86_64
and changes the common code that determines MAX_FOLIO_ORDER in
include/linux/mm.h

> 
> Let me take a look at reply on the revert.
> 

Sounds good. Reverting or finding a fix is good with me. It definitely
impacted two of my systems and the problem was introduced in
Linux 6.18-rc6 and is in Linux 6.18.

thanks,
-- Shuah


