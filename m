Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6D2BD2CDE7
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 23:28:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 382528D0002; Thu,  4 Dec 2025 18:28:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3327B8D0001; Thu,  4 Dec 2025 18:28:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FB048D0002; Thu,  4 Dec 2025 18:28:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0BEFD8D0001
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 18:28:39 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8609C5864C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 23:28:38 +0000 (UTC)
X-FDA: 84183380316.19.242EC16
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	by imf22.hostedemail.com (Postfix) with ESMTP id AA228C000E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 23:28:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=WXKVGmYC;
	spf=pass (imf22.hostedemail.com: domain of skhan@linuxfoundation.org designates 209.85.160.45 as permitted sender) smtp.mailfrom=skhan@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764890916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TY8vn4+rw5BlELkE55Y40GYmlU2AL+AMWiRVce63tcM=;
	b=570aJPzmKHp0UjYWYXC7ZZWv6DpiouiiFg+HDEIYzahxqNP2kItqJ+71jCJtDpYiCDXdX+
	7XBYmiX4JGfMkCFeXGCIrsUONliKoUrM7sestI3IdpAskCnxDbNwYcUp1Oq43TzlXitO4F
	+dhBi/BlfbHaBwWjHbU/O6jzgmSHzq8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=WXKVGmYC;
	spf=pass (imf22.hostedemail.com: domain of skhan@linuxfoundation.org designates 209.85.160.45 as permitted sender) smtp.mailfrom=skhan@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764890916; a=rsa-sha256;
	cv=none;
	b=72anJum+vVTXPs4nJZ6SJTu89gs+c6MrL+UTU3rZEfNF0qIGGkAqMrLN2kakL6x9TVDzkB
	EDJYHQ+YbURH2OMut9DFtHZk3wo5gecroxgHeYHZJZJFPnKhNYay/rgSyQKFKyBhol8r1l
	O6VG3iNQhU6wui0eLF50AsPL7Uahp4c=
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-3e12fd71984so1126426fac.2
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 15:28:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1764890916; x=1765495716; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TY8vn4+rw5BlELkE55Y40GYmlU2AL+AMWiRVce63tcM=;
        b=WXKVGmYCTC8nXbLnHP19W1wjR14hMeiXM7axOozpJFjVm+PWdlsqwHynIoC5cQGg29
         0ewYDMXxnLIIqV2uzE8Nib4mmbU5jN34sb8uG1sjlf7xJtAYe87NWjbVdq3x94WbBZfa
         XVFeUuXuliiKZq94wz+yefiFosZA51uBrC1Rw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764890916; x=1765495716;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TY8vn4+rw5BlELkE55Y40GYmlU2AL+AMWiRVce63tcM=;
        b=mCUABYA99RLWvvzp9BGv6h4GGGpTVFYfU5C5AVmFq9PuJ5inYwkl52X5JXPbwNLk0d
         /RGj+SC9z4dTInVIgWgUQ3tYF0j0/uM3KxiO+s91KUHy3vHtfvhnqi82jdS9VIxe0wh8
         y5yfiYMG91GuqAQqwiRd/zYLIdsDarZSx+Om3Dg8xzIoqC81cXz9LK47avICIUbKRQzm
         7Icv+ETYKeXbpAsGyecXC98lDqxWiDqFwlfYNA4q0+sWD7JxkqGQbXTDY6fZa2wYUfcw
         7pipUcdmLXA/nT6Y9iMuggBddEDoWR0paG7dROEmL9edRCiM9db4+CHwVQJ6Kfihyizx
         D99Q==
X-Forwarded-Encrypted: i=1; AJvYcCUaKPvL7ODfY0jCs9BQhfzBhqWk3+9I+kLZQ4Qbi/+eViPNgTfPdb/gbAJ+/phNySQrlm/JdCkP1w==@kvack.org
X-Gm-Message-State: AOJu0YzYXkOlG2t8Ro0gwyZkm+3oTl9O4Gide4ETh5EAqhMhVVccjE5b
	QS2psS6zG/J3PCS6J1btB5jv1DADtYV9yJB1zpYOke1qg+P8RnpszBPamhvPksJqRQLg+fUBpSK
	zTlNZ
X-Gm-Gg: ASbGnctPAC6sRmCo75+cQtJ/0Hj0gvrFKvqbI5RmVWsWczrwGCK5Ox3DoWGJJLnF7UF
	yGKF8L0+iLrTWC27LyzaqMKp/I+leUJCWWSuWv3URMa3hiq6e3q/DjvpK6SUCTDp/0ybXcxqaU7
	NegdW//FowLmKxvyTBqNm3dfU2QlzUmVi2Dax0iZvMmrwTO81qFJiQS/EBEMP6z1LBwLJN+HS4U
	qPltfgifMX5vTtsViM5YIvE3jBw2hQG3K4gIkQvBCJU8oi5qEFnht+Xtm3rxzOdt187dj+apQDW
	DsyO3+hKe4pMdym/wFmYRjxYSf/KmehVEm7AiLKU8QCWP0th0oAlq5ySCoCJOu+vVAydrO7zIoE
	82ml9usZ/kts2AN/ip+Ix2xhyz2XaRnMopDuS29WI3mvTGKbrgzcukh79SwscuwYvRJNdQyjyZr
	IIMZ5WYPrsTrXGfZJJ13IsEAo=
X-Google-Smtp-Source: AGHT+IHaMdSIvMY4kJabIh50Lp2Y7vLsnF75nwPDZ+uvTeHchqLesHf2HXJ3/okGx1/CR50Bnu4U5Q==
X-Received: by 2002:a05:6871:2941:b0:3c8:d325:b7ac with SMTP id 586e51a60fabf-3f1691860c6mr5140679fac.4.1764890915718;
        Thu, 04 Dec 2025 15:28:35 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3f50b5123f5sm2197586fac.13.2025.12.04.15.28.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Dec 2025 15:28:35 -0800 (PST)
Message-ID: <60fe7660-f3fb-4c94-b21f-20ebc9e14f5d@linuxfoundation.org>
Date: Thu, 4 Dec 2025 16:28:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Linux 6.18 amdgpu build error
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 akpm@linux-foundation.org, Alexander Deucher <Alexander.Deucher@amd.com>,
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
 <b24fc85c-0e6d-42f9-a6b9-05136409098f@linuxfoundation.org>
 <CAHk-=whd-k3GhNGvVmP7W2p1d0d4ctqJ8iCuG8DbyKzgNqCL+g@mail.gmail.com>
 <3b6d6e50-91ac-435e-adad-a67d4198a5b5@kernel.org>
 <3cd2240b-ec2c-45d0-b73b-b66c83e75b9f@linuxfoundation.org>
 <CAHk-=wiEXy+7Gd3ONQ-v0e61e6qAmrtk+WE2dpW_61p83nMgXw@mail.gmail.com>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <CAHk-=wiEXy+7Gd3ONQ-v0e61e6qAmrtk+WE2dpW_61p83nMgXw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AA228C000E
X-Rspamd-Server: rspam02
X-Stat-Signature: e7q3onbz7as3ct85cs3mo63rjxronb9p
X-Rspam-User: 
X-HE-Tag: 1764890916-384972
X-HE-Meta: U2FsdGVkX1+qaX1Un+PBumQsq5DEyfCgryHUsiMwUZr1B5UtIWtdGOvn3nAcc8NReWwoSePbwUhXB58Uz4sh+As+mpLGQspTzYJRm4G0xwLw/L3eqwGI1h0TX6LPYxUTom5H98RXySU8hArcZleSydABkt33qnMY0VGTralaS+3ZP98ZSXNYYr1MR3iGzeaOP5HHcEowanYrP29Pwzma9/fM55Aft5unmrycWiGFnJrClMinU35cxE9Z8OIgAppN8D5C5VyfUrcOv73LJkUF7jrd5KwcaOl5FR0epaAo+yFbSpf7kT4YD6vj9VZ/6uknDACqV6A1f/7C8tOL4WMZ6KoebnaIqhe1+eCbNV+2nj0IwiqOYWn+ELWVcw+VKn/B2T54KMfJ0IA7LdHOom7O9IV1ngnaFpgbQIiUn0Ow6mGJK2r7XEFDSHlGHpQgqwmVLuGIjIBJPBxgOG/opdq/iYGOfU4pJZbbHAE2Sjn83AJMcKBW0KHo0q8bekKIykNAA50qTdXtAFiW2nCDueD9aSzlaki/fayPJhbdRx2/NzlUoNF0hR2/l17NaufhL17SLaoSMEzDdAHwhwL5//zg03meG3jgrqYXAoWun0oMqBntef5nUKJVHzGThVSmOGZH7YEvqPqly5iL1ups1svfOKYj9laL7298hBWtMZGFL12PqZXTECqzfTS7lIgBmvaLHoZWMcfjAvGroIXrK6+ZOUGTv3BWSop9EuhgYV7gaenkcfqOeOfwUjygiHdqdFPijPS5aZ37KMyE4xKeCcuULdFIrPtgx0hX01S/IuiTgSopxqrBFZ3TS9CEOiW7Jhm+X1yuS2/GXh3WI27/BT0BrCoQPbpp8ERZxDkYdtSsJ6xErxWZqYvn8dJY3H4Poj2GilBUgquPqH/P2N8v9iqUfwq5OQVP04zbBN0kK9E4SgQaV0ak+2Z4gffzh7EOv4zh1Mk5uV4BX4fXiUDmdiV
 4jWVWg2s
 j2B1Pkj5ZQV1z5xXyhugSkFbEOcxgDiG90g22EiHnA62RgdTT5NKS4EYmhg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/4/25 16:23, Linus Torvalds wrote:
> On Thu, 4 Dec 2025 at 15:20, Shuah Khan <skhan@linuxfoundation.org> wrote:
>>
>> I didn't see any problems on 6.18.
> 
> Ahh. So it might be just that buggy commit adfb6609c680 then, and the
> fix already being in rc7 (and final).
> 

Yes - correct.

thanks,
-- Shuah


