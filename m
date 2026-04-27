Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 253B0FF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 08:53:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89D8B6B0005; Mon, 27 Apr 2026 04:53:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84ED16B0088; Mon, 27 Apr 2026 04:53:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 765C46B008A; Mon, 27 Apr 2026 04:53:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 64E0E6B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 04:53:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A594120796
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:53:58 +0000 (UTC)
X-FDA: 84703723356.05.D535AF2
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf19.hostedemail.com (Postfix) with ESMTP id 102F71A0012
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:53:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=eOmm+G3P;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777280036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nn2wJIGRY+crFZKAPwjDcRgbUW7V+wi7su4exIbXb2M=;
	b=SAdaiyO+/+nOHhM2Wdm09Bkvou7ocqQDEQr12TboFgQ6Wf4lSkUQIcVmAsFqSHwQXTFCqf
	QXaMriYWgZJFF1mmlnwmtPrOq63hvh6hzlraAI2dg20TQ5seyrma8tFMD54yizspVCf2go
	XOBMF4tT1oRQ/YsnGXCUXUgmZ+Ujv18=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=eOmm+G3P;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777280036; a=rsa-sha256;
	cv=none;
	b=oiObLFzhKmbq0HYH/ArTzRKuKyEpoqJMM2jPlMrSWHraO7UxAmd/zCmt5lD6NEjIYOoGtF
	BlqKXOivQKtaoUgRR9prr7ljdWQfk0tB6khqsZQGVSDEOQDaorl6Qc82af9x7BalqDRD+X
	hd6mBIaBLu3rXoFUQ7yeJkB2/oGN7yE=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4832c8f9d87so13095015e9.3
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 01:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777280034; x=1777884834; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Nn2wJIGRY+crFZKAPwjDcRgbUW7V+wi7su4exIbXb2M=;
        b=eOmm+G3PGTglh8CtB28lVF3jiUxk8PHBqoDbO5C8WweLl9pxdnQJkoHVL7wzw20QUo
         1GzyrVrMQ0T+G9SpQHdkBZ9Z4ppH99OX9MvvBCVszZZmOTj4IKfzkBq263qLrVaiC1Tv
         V5pgKikjK0tkEiNt58wbL0nVtpqvoJdJQo63jyOuzXrcI+kEetBIwaW3Sc0vFu5DWeFw
         sSx4yjQapfGGG8vpWT+1jl1OguPWIj7foEIX5g8nlablRzS+ZU4Orl9q067esmi7/puO
         /tu80NetCRpHiT+tzzEGeUW61TdTVv0aZRgEVvdwMx+/KwoOMUh+FxjbYPwdmmtBHWj7
         H6cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777280034; x=1777884834;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nn2wJIGRY+crFZKAPwjDcRgbUW7V+wi7su4exIbXb2M=;
        b=LuplhsJEDfqDA7VslpLKjI1mmJh5X0OJrtaYm1UbSAJGDb+AaYUBoooq+D2dtx8Dcp
         zIB+QnD4KImFvQMn0aPHLtk92x5B2EU0/LYEWHsj6A98RrxvXK8K76JCXzPceUEqRvNl
         VwsAIPeYFjGkNaXtItPHKpuv1M96ONu44OLxEfD69j/7df6nkwGYZNsuzBcmNJj1VlO+
         wobAx5el2sqwRYr6P5ADExPPsgBJ4dx3ikmzmhnx4KqQO3dBq50GGaX9NzJeDMoYhUNr
         GaXgClEYXryB6MGPKpHnCGWEXm7TTNR0t8xwJk9UN+7uYg3sldQxhL2Ch12Tz5WUyE8N
         RlZA==
X-Forwarded-Encrypted: i=1; AFNElJ8+Zm1c/oZpBrprZ2X8R7sUOLIpL/nXsPnARRsWMYpHAKbOeoj73QZmCJj06Iw8uiQVD+8wnBhjpA==@kvack.org
X-Gm-Message-State: AOJu0YzTZOnbEOqOVXNZHxszIXgwuU8Xhmk8prweYUiyWrqHrfuMhidL
	Xv5KNvQX1Mx5toTFGscp8yWHm0FXMcU281bj/biWel6hRe6DArQmDb0wrRrHzYaEWxA=
X-Gm-Gg: AeBDievYqMS4UPHGP6pMi+mifq6sHkfgzUtOsRHSVN9lzBjoF9SFeVEEIPolwt7sohL
	ziUNi0gDsn5ishBCqMEfogpt4Jhgwb5CVygFRelghck5zastXLKzcvU2Ys/AWNIPsskQHEtu+dJ
	ypG6L7sqgt7p4HCWuRuCyFl4pnoR/ZConYFrsuKx/axDG3Zf56oQP3wXJRPH1gAzOy7KiMkCzcY
	wrQvQ5p0LQsImfW3ozNkFnqhHst5XXEvWxf8p9i1JgF6MRDdM9ofqUJEM7HlrX5Oj8oQzug3bmL
	vfTc+lfVL/k7SAdcXyFZDWPDeHcqSJ6i4MQ0MIZ9LCx0XWdfB1iiaHnOeQtT1k/riH+fqd5ChbH
	VUSSI1MMt6rNNG+YBs7tItatFz3hO2QwG1dv+C4eM7rGXKmWlnn17PiAY3eaES9VNhG61+/BlXX
	wEM9fDbtCgTOEPYR0yUr4291AGTvTYsE1nGTKIWbNlfiHCb9w/fRxjkW7ZPtTMIIK8nNfB
X-Received: by 2002:a05:600c:154e:b0:487:17d:d0bf with SMTP id 5b1f17b1804b1-488fb769fb4mr267995825e9.6.1777280034268;
        Mon, 27 Apr 2026 01:53:54 -0700 (PDT)
Received: from ?IPV6:2001:1a48:8:903:1ed6:4f73:ce38:f9d4? ([2001:1a48:8:903:1ed6:4f73:ce38:f9d4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb7b2716sm248233245e9.30.2026.04.27.01.53.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 01:53:53 -0700 (PDT)
Message-ID: <4e269fb1-cd6c-46ca-ac2a-168ce9fd06fe@suse.com>
Date: Mon, 27 Apr 2026 10:53:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linus:master] [mm] c6307674ed:
 BUG:sleeping_function_called_from_invalid_context_at_mm/vmalloc.c
Content-Language: en-US
To: Herbert Xu <herbert@gondor.apana.org.au>,
 Uladzislau Rezki <urezki@gmail.com>, Harry Yoo <harry.yoo@oracle.com>,
 Hao Li <hao.li@linux.dev>
Cc: Thomas Graf <tgraf@suug.ch>, oe-lkp@lists.linux.dev, lkp@intel.com,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, Marco Elver <elver@google.com>,
 Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org
References: <202604211323.fac1b29e-lkp@intel.com> <aedvSnhOGM_mauYP@milan>
 <aehdcxC14ycvY481@gondor.apana.org.au> <aeh2Ii9CxtgfsX_p@milan>
 <aeh_2WwIb8nAIcy2@gondor.apana.org.au> <aeiHkG7X_dieMdw5@milan>
 <aemTW8yiAe6y1tsQ@gondor.apana.org.au>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <aemTW8yiAe6y1tsQ@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 102F71A0012
X-Rspam-User: 
X-Stat-Signature: b64k9jd5zz1gzxody4eppjrpioc5x8w3
X-HE-Tag: 1777280035-485165
X-HE-Meta: U2FsdGVkX1/HooiuvjP970fatgdchKY6hWypod1T8e612WrfXnIMbFXMmVet73K/PLfuizlE0i4sMS1i/OaKo8/v61kwuBp6PsVhBaEN8EtClE7AyQQQiqA638eg5T3AYd0H1f7cU+FMTPIWm2thpLH9Or3hY57LYAGp8jh6ylfED0jvaa9tEkEBh3V6Z1BsYhtgrKZ6YjWK5+mLml6d3nDRxxLKraQnhTJPLWp78m+qZm/GPhMp5EIcLyc/EsysEJQOJYsQSScSRTdRiQ+lfh5g7zzfjeBqoH3jkAXVcofk0JNuiunTSBafNCcFCHltCnRdd/t5Z42653A6rA/s5FJxFSxr8a4n70ZIiBiVt3+JmXwW4ZZDNHogXd2ygiq/8SafvKo7hSjlee0uFR+DnmG3RFr/35B/INXg/t0LuvOIvwW9jc5oyRkcKo6lzicPbEVxGdKhoN77cBmuRhKyVfuAQcH38A0Pzn2iRJ0m/vdJEvJ2ITd5tVAIp38LZz6HEjeXkjm3gHudSbVt198HZLr1jCVpqhCTiWQ3PaxmYWYVVomRTVCCXR7EUAyiVC97RRfS5NdwVuGEZMfE0XFXATszsJ2zQLFBKGXd+IeRQP6E/p6JERZnpqv+QERW0/FGB1FiU3Jut5kHo7FzoGC1Sec4TRSnZ9H79tZh0/qKhiYYwfea2Ert7fTgKSwgWU85u1THGN+e6E0FRryajooNasYfaKx5Hq7KUpEilWVu9kjYeUlYAoH5ur+AuYYCfYSWWy12dRryDNaEqhKWIDaxEyIxHIaLb9odEDc/n6pvHXgZ/vMk6/HUUlEEFhOYNRn+vemGarXjPf+GJV0m9TbfehBwRcpNZ0D/rD30Tm3itlfg7Ux6P7IUAh9X7oH00uUpN0wfwUdWRemxZ0vzWTqapx2x5j6ePgc4FyTKHFbiNaJaDPfbJRWf5icjwhocl81U7Y05635atsIPXJhn57I
 tqQ/SzFy
 aA74xEID7+Z5xHX/KaKwgoUX+t9rLpez2urUcHM5dQp7hZ/TzZqa9+Qy3pshDMSf/GspXraOVJeRZv0Zzzt1v0Q66iLPAkWVfCKR7QfL1/7YvZyl3l0ICuSx3Q8akxgMS3F134dNxFa5piPyv/yCz4XpQFqVIJ1HbwLCKpHENMcgNfsOFoDCBHIm2Ogn/EDsu66Sk/Ez2h9xixfPybEwkzqStM1a9/eS1ZOyEOGlX8KWB5AjOgrX1IBzplDKaqISGIOYr9MS5yfoyHWyfxCJO8tcNDb2oEZ4M5iqQvngZbSoKzRENliOXnpEhQBVSyicUQ/5tIekODiq0rQYnCCiwe8qoBMKzEW5E0UBkEiQbJVxcbmBxOgXzToOfQxjfBOnX/cwDXApkaG3orZUoHOVpZ8wabs7Gqdsqua1Hj8PXkk4hZ3RRhJ1Hy1eIJ5fw6CqmYdZjP3qmzg9jDwzTuFwv4qwqCS4Md+8b1lrRPeMASIaZpsJCntdEvQ/SSdUnWlTf7y4JK4T8KtlF68PzLxPAz8VbIE5y5EPhC+u3UMPH6WcMdbAqP8qDb9cteg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 05:34, Herbert Xu wrote:
> On Wed, Apr 22, 2026 at 10:32:16AM +0200, Uladzislau Rezki wrote:
>>
>> We have added non-sleeping flags for vmalloc() to extend kvmalloc()
>> functionality as folk need those.
>>  
>> Another option, would be: always use vfree_atomic() from the kvfree()
>> path.
>>  
>> Any thoughts?
> 
> Perhaps add a kvfree_atomic that just calls vfree_atomic?

kvfree()'s comment says

" * Context: Either preemptible task context or not-NMI interrupt."

so this is neither. It might be ok then to create kvfree_atomic(). Always
using vfree_atomic() from kvfree() might be wasteful.

> For rhashtable it really makes no difference either way.  But it
> would eliminate the unsightly call to is_vmalloc_addr in rhashtable.
> 
> Thanks,


