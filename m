Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D327ACAC592
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 18:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFC8E6B000E; Fri, 12 Sep 2025 14:36:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAD136B0010; Fri, 12 Sep 2025 14:36:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C3166B0011; Fri, 12 Sep 2025 14:36:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8A6D16B000E
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 14:36:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18C56C091D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 18:36:01 +0000 (UTC)
X-FDA: 83881452522.27.7953A19
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1D9A310000F
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 18:35:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=BBI5+iGq;
	spf=pass (imf05.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.45 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757702159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RTwLCqYrxP4A65CpeLdDZfX/1/5VrrEeFcGj8O2B7PY=;
	b=jkFOFTHodaTKEDtXcrTCR5C10BYzTbzMjeFjYoCLtC61lhnxqxzaDgmaynV6OKHGDUENWG
	W2FF6oNLKmcGttFNd0yZHw252vEBbbM7SdtcPgCCJKRHVHql4MqFIunuHwvEU/Q/k0O48v
	300ka9kgo0gwU/ELst0f8XS+q1nAY1k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757702159; a=rsa-sha256;
	cv=none;
	b=8Ak+Y+NVBFNjK2ipiYAyJBwIEEp0auqLuVutwDqwl25XAeA3U2Su8n4+nJF54+2Z2hVOlt
	xBZ8yDTSVy+8Qjo6ImmqDNaJck382DkbVmS1e3RoD2DPHZNlQg15AAFxdnNpyIIohimaxi
	G2Rh/C3C0HPuq+cwnihjgaHCD0oc3hk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=BBI5+iGq;
	spf=pass (imf05.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.45 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3e8123c07d7so146227f8f.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757702157; x=1758306957; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RTwLCqYrxP4A65CpeLdDZfX/1/5VrrEeFcGj8O2B7PY=;
        b=BBI5+iGqU0oVmJIxbZU5YQDFcRjB9c0rBdhpP0xGJCKc2NS6qZ+JAM3WsdioeiRY77
         FJo49UUqKXnZ5WVUKSpJjtG7FebbrsqEbmm4wbBDikGUP94Ajqmqa2OLm5SOlAELgQCC
         GY7Pa+XQCYxYWPIjBc4GPXDRIYiUf4CWjFpJDwK/LsHgahH9snLZBesWoqR6GWPn2OhH
         +TZrNXJ0AWsIi4UJFvBVa79Rvtggdr7kDUMJ5Jq36Ye9BKrIoO7fi3o/k9i6xjVC4gl1
         fy7xgA5m8SISqbwUv27RacN4oX+LcYLYRciWSryxQ5NFOH9LMUkke+zfJ6OlvlLx1Wj3
         rhRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757702157; x=1758306957;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RTwLCqYrxP4A65CpeLdDZfX/1/5VrrEeFcGj8O2B7PY=;
        b=S0oiyWU0cpmLkzRN5jowWhRNE/Ess/1EO+Sw0hkkuAzh2dKK6/HwsqyXgnJ+ybVQId
         JL7zJhrDL0o67TSy8By1Acd9a8g3iNVXuYlQyZs+NFI7HZzfEQYCHCr+7xe1jYh13syd
         GHKsyFvQx8Ja47hhTDtCx2mW27yrE3xzTpJWNwbVtC9DwWgcIV49sBYGzY/J60oec2os
         Dm7a0t7s+KUFAUZjxdZJIG+R03gJOrl1QqS3z2QIt6ujJByOC4KOueuEfPlloYzir1wR
         XlKT0DQw1nA6mzgAlHxXxskZCTuuV/9tmavRtHJH/ljgPhz1qQe7gZ5dviiAxhCoD2sJ
         6qqQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbvGbyP2D+Y2txOdfRy/aNf10yXudef12KRbpu29TVwnVbiCbzy+6gHG3t6+iccY4f4hrnfkxZQA==@kvack.org
X-Gm-Message-State: AOJu0YzwLs8PMrkHjMXC8tAMNHeBnjeIBAgedvX9WijS/r1eeHsbNFGz
	SwCM4hzhQfbM69UjBQ5UOphgG34LRLPEyJNqk3IUBcwyzyPHeQ08+U/0HF9/1pkFaUg=
X-Gm-Gg: ASbGnctJHdU3/VmkmJ7+KGOOJ0enfvG/cSjy4owYAZdCIewc3I965sXLJlEdkrie1bm
	N+SOtOkLt+P5kusM+qFuWl62pbgusWtRhwHgJjQPgFXO87lx7kbtlKHtedp6eQh+mmuTKWJP1w9
	AIQ+buIsETADgZUwisfOhDoLlSQjw2s8zbiBO4AbNvLWmwa3hi5hiLFqyaPFvy4EaSPLkY0yHwQ
	xs/DqrT+UflxdxORhr088qAsX+y8FIG0i8A8W3b4vR7VJdM8l5PjAyMRHvt51ZWi8cfTJQJDrZl
	vwAMvf11694dARKutgNXzyJ6/JsQNVpptS7PpDTwGnfcT2HCnc2uGWSwg1rHrkHtDPK/DwsF6cm
	V5TT+/8I9UzzW1/ZP0G2SXy+ZlbQ8UJEzRnWbQ+pwfqelAA==
X-Google-Smtp-Source: AGHT+IEFXfAwL8n5C3J9dCog5MqYjz/0z+tjRYy8VBux8QIcdwHNBxHHgPhwuMllRtUOig1ksCGmnw==
X-Received: by 2002:a05:6000:26c6:b0:3cf:3f1:acd8 with SMTP id ffacd0b85a97d-3e765a2367emr4237912f8f.28.1757702157424;
        Fri, 12 Sep 2025 11:35:57 -0700 (PDT)
Received: from [192.168.68.105] ([145.224.119.89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607cd0a7sm7293297f8f.39.2025.09.12.11.35.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 11:35:57 -0700 (PDT)
Message-ID: <0bc838d3-26ad-4f2f-8bb5-1c34748e1fbb@linaro.org>
Date: Fri, 12 Sep 2025 21:35:54 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v3 00/16] Introduce kmemdump
To: David Hildenbrand <david@redhat.com>, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
 andersson@kernel.org, pmladek@suse.com, rdunlap@infradead.org,
 corbet@lwn.net, mhocko@suse.com
Cc: tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, rostedt@goodmis.org, linux-doc@vger.kernel.org,
 devicetree@vger.kernel.org
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
 <9c2e289c-0258-4e25-aaeb-a97be89ebd84@redhat.com>
Content-Language: en-US
From: Eugen Hristev <eugen.hristev@linaro.org>
In-Reply-To: <9c2e289c-0258-4e25-aaeb-a97be89ebd84@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1D9A310000F
X-Stat-Signature: juwxgmcktszzxghccpdr7mnz9jxssq4h
X-Rspam-User: 
X-HE-Tag: 1757702158-419240
X-HE-Meta: U2FsdGVkX19e46oldGnHszBVqW3CbwO7qMLi1StJw7wSnWt3F8ILCwJIbxlPjt3edY53YIzRZmOUTmUMJHzaXEAlJiPodiqpS0fzD/66Q2LcWjSx0SLGfZ7tk+Stk8jcZebnrqp7C1H85nJhlrBdyC91LCnl5tpXM9QngiwFPwNPMcqcX1nFTYZOWjggWjffKbZIJNU0RTaZH6kmqTUAkzsefOYBaOERFeKazRmsKTm1/U5EvKBskdj9TC2FLMc0r6Xv8dIyh8IKtVn5cDGBaKztGJ0kXWNa4X8gVjcBWvJQ+ijtS1XqVCW0kauvqorbhWMlHN94p8JsOmEpsXU1Sy7f7b4mZAjjdsSQyvzMcnqtjFUK0YF/2ySkPHpJ6X3QMEhtQEOih+DA0lw92s5RzPl28Xk43CXdxNZlv0xhi7xGWxh51FxvpSGv7tOtuP7k7+paDJu4GgKruuon6yYzovXoYDDBiUuAB+joQgE4lGn8z88ct2rwhC3z+f6Z+I0UrWV0538CEZ7X1Td8IssIMAfYSxQfn7ABXofFvuxIrxkCAXds3lXh0jj2N3sf67hLmtKqE8jwkJbwTCwakxA7jmphOLQhpTO+M5kleK29TWQArX6mAuutqpZL3RSWFGa0qfQrt5oK5wS7dIqByEH5cxfxDYPCXjXS8meR+/YnZleNDyKGNuFZPHh0Wc9WrA/O8kfqhCtTMinCKOorns9Yj6mBi7i4tszJZytnlyFxPEbiW8evEhjxoK9TfRRifilQHl88BTXzlQHsEaDBFtS5n8nIQwQsb095Ik0jHTYqXghRh17lfOQMvgwfioBuSBL0oScrdGTxeRP5dyii3nxWjQF8xv5zeybF75Q78/d159cLLQttbXwLw+Se5+3xD4bNk2bpa9zQKH+/Mz5wNFKWTINhngztiDz7jnjo8BM1L1DNZ887h8JqJ2eGKW47iLlC5Cz3BoJTav9dg7H5tYz
 Zqn0fuNK
 0t5cySo0eicLSayd5zfwbsmB/wQf5mGrMUSL5CYOXIJ+W+06VwyjCoVJq4fHn7rUGTtfDsUAjtIFymWPmgbTLmY+2P3rXkMszDJFGn5JEZw/6ZyUmqdWMXvu9Ibpr2t4msPs2xX/vwQOfD89k4TAD8fTGBfiVt/whA732e+hHbr2HQQq3VqAtpHEelwfsogv5NKd/B/UALalQptJRLLNjf1cL51yhfLKRa6B0t4joPPkTApm8Ah1RfOmI4ARAlG2U0pG2K9958Nslr5GDJY4hpuk+KwpkkbqxpTuFAAVT2JtvVoVDD5zP0rye1VG9Su61jaSfIyFWd8Md48tkoT1QLz/nq0Vjxs2igSKMeytLa/CdWJ/YHCRiRlC4TAGOiKLPfbYC+noyDxCp4m9kzyC2YXGTCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/12/25 18:56, David Hildenbrand wrote:
>>
>> Changelog since the v2 of the RFC:
>> - V2 available here : https://lore.kernel.org/all/20250724135512.518487-1-eugen.hristev@linaro.org/
>> - Removed the .section as requested by David Hildenbrand.
>> - Moved all kmemdump registration(when possible) to vmcoreinfo.
>> - Because of this, some of the variables that I was registering had to be non-static
>> so I had to modify this as per David Hildenbrand suggestion.
>> - Fixed minor things in the Kinfo driver: one field was broken, fixed some
>> compiler warnings, fixed the copyright and remove some useless includes.
>> - Moved the whole kmemdump from drivers/debug into mm/ and Kconfigs into mm/Kconfig.debug
>> and it's now available in kernel hacking, as per Randy Dunlap review
>> - Reworked some of the Documentation as per review from Jon Corbet
> 
> IIUC, it's now only printk.c where we do kmemdump-related magic, right?
> 

Yes. The other places just have some changes such that I am able to
gather the data inside vmcoreinfo. (remove static, add some function to
get sizes)


