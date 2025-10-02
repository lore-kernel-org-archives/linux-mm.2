Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70EE9CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 07:29:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C678C8E000E; Thu,  2 Oct 2025 03:29:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C18588E0002; Thu,  2 Oct 2025 03:29:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B07588E000E; Thu,  2 Oct 2025 03:29:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A21888E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:29:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4352B86B48
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:29:46 +0000 (UTC)
X-FDA: 83952349572.13.39A9473
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id E307680015
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:29:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Bzde3X2c;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759390184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0CSDnRn6hYSzmKVQfh+M23X97GCdHbW5ItsaS7LSYJU=;
	b=Kdpl+JYu7ZT7JhyitmI29ROV3jAlUBaR0M/szg8vlhL+5mBeHEJbbHNaxaMsdtvc37PTp0
	heixE+5Wi2ws+vApLm/0WVqkvk0AaEDV0Y6LIbDyukukoJNHpLCvU+UkzQEoMFk+UXFmjW
	t5ldalv9JxkTsmr2Oi4OovB3CwDNXpI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759390184; a=rsa-sha256;
	cv=none;
	b=weMCHiT4zSbGidG8qfOKBAlEV9tUfaHE99uN2zbbiZW4qcjYOaE2fmENE/uS8U2+auyFgL
	/Nx7ufS/4Ep5KFMamGgLUkEvHGodJi5/G1+Glbzk/gmZWoA0R2ZbpvnGqZI269DZ5+yUO3
	OtHtuhLaWaAJZZ5A4uE92GCHjhmpoyE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Bzde3X2c;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759390183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0CSDnRn6hYSzmKVQfh+M23X97GCdHbW5ItsaS7LSYJU=;
	b=Bzde3X2cSpw+E4R5ZiP32RrbikHKioPRFPsM0b2Ekr+W33D4pGjmrZUgDXz9+YaSYqfRgZ
	wyPu6Iu+fgB7+m9zfnq7vHiygcS8md26evAaU6WvZQOLsp/S3FGoCQ1j6Ln7fnod0mq4la
	lsYdeutIJkm4X9CC5r2NhcbHgHuhw0o=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-394-Vn86SziXO5anYvLGYIHMfA-1; Thu, 02 Oct 2025 03:29:41 -0400
X-MC-Unique: Vn86SziXO5anYvLGYIHMfA-1
X-Mimecast-MFC-AGG-ID: Vn86SziXO5anYvLGYIHMfA_1759390181
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e41c32209so2591205e9.0
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 00:29:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759390180; x=1759994980;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0CSDnRn6hYSzmKVQfh+M23X97GCdHbW5ItsaS7LSYJU=;
        b=Y2mg7iXrohHxNBrVRvBIK5Bc6B07r5+sFT3HTlE9yNktR9QW7omg+Qhg31Kcv0KE7f
         3jL3ydlYfo7oWEaDbrtecYGbJJIdIt5BxUe5CRTOUg1noTjB/PiyvcjBLAZRP6JZEHPs
         hxk7bSyclnYC0PXJYzd36jEdC/6lP7VNku6OXjmFQiy+3T16NV0SrT3OOBGeFhUcwPIk
         LSMKiakcl7uG98wHSf4e3Opbrj8mtK2dn1iA5UIB6EB2S41zf31rNat3ljdjWZzfJp7x
         8O4YcN9TGbBOqoaVez7AOvd/0PJ5Rr6V4TS5jS0+k+vBlmtdaijhQZ6A6hW1uWMYcDhj
         ZgUg==
X-Gm-Message-State: AOJu0Yx8pLc1LiYUljAO6GB4WIZypaDKWELLH2n0B3vHsNb5Zp9RT3ul
	aOm0KtqWUSMpeXk7TXQhTIxF3qOp85zsRBAwJyYyCQYLWCmeJUPQdzwUW1K5+X3Ifb6zhqOKrdY
	xGcjrJwcjyEMyK2tPABdAa4IhTZAJ9GkECYJHcRNomFYjhQ7LZ1n1
X-Gm-Gg: ASbGncuDDL8MXLr+cPmM5w3uDNbggUD03zUT/QuKpc0+7HI57dhQj5GmY6cHr6mNbtI
	nrRyhkp0UZyRr/woGTJrfqs6Aqf2+W/UgA7QxQOUQALrz3Eu6ILK/wEbK0Yi7UwFhnxVEc/vh47
	8k+CJZkNfafzRUJhuV/DBrXabVq0c1WubRcpXf9gq3dbATmTXRt9ndTIMwmwL3wcksXBaN/3aIz
	ijiswt0SZugpk0XzKWeda1fw7ccFL6RkNxvs7Ez0WoeYRPqhY05XSuzCbxydjDNJnJUr7I+MQ/U
	bVysgz1rVNoCD57+O1Rx6pYixjIHQaDWdP/fpMs7r94KzQlLqNNuNQ3fNPl/X7m7hQ14Mcz83BZ
	1rGtQqTU2
X-Received: by 2002:a05:6000:2302:b0:3ec:e276:f3d5 with SMTP id ffacd0b85a97d-4255781a637mr4368070f8f.42.1759390180548;
        Thu, 02 Oct 2025 00:29:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH6WQwGgDH0BtLI/Rc2UQozJzaeNJMjTwQlnd7GumY5IaNv36BcVqxzwSGHNhnqsScbI2ZF5g==
X-Received: by 2002:a05:6000:2302:b0:3ec:e276:f3d5 with SMTP id ffacd0b85a97d-4255781a637mr4368052f8f.42.1759390180165;
        Thu, 02 Oct 2025 00:29:40 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e6b23d4c5sm14487845e9.17.2025.10.02.00.29.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Oct 2025 00:29:39 -0700 (PDT)
Message-ID: <fc539c61-7a28-42ee-a28a-fef987967958@redhat.com>
Date: Thu, 2 Oct 2025 09:29:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] mm: redefine VM_* flag constants with BIT()
To: SeongJae Park <sj@kernel.org>, Jakub Acs <acsjakub@amazon.de>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, xu.xin16@zte.com.cn,
 chengming.zhou@linux.dev, peterx@redhat.com, axelrasmussen@google.com,
 linux-kernel@vger.kernel.org
References: <20251001165121.54258-1-sj@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251001165121.54258-1-sj@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oSOLLqiXUax4-EFVh4AMim1i1fexaX4_PyvXxOBVBf0_1759390181
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uw91j59hg8copba83hjy5h7t3exgiugh
X-Rspamd-Queue-Id: E307680015
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759390183-11855
X-HE-Meta: U2FsdGVkX18HOky2pbtnmzsIhkuKXCj4YWfLgyyv1hIbARApG5k8Z90kEOulQQww6EmPe2wCbwqckPnxFwcfJOo3ZhD9jSNY95e7ZFFJhGKFdPZKIpjUpUaIIWQQTDR27luN8AvHTYTYZOmL33jvrYHXISpeVs/W9aZEfQ7pah7bnQzp17NGGrSvBccd2NT8sOgyvjc0twXgQ3wmtNNv9/XO0LVmAYoLpsT+0OTXRiPChaGq0yeWvZTs16CopDb4Wxdq0ndIj/JPVjAKGnKioHsiVq8C9umV0eLAQtxFAJx+DqCPwlzbSd43JYhnZkbYBA4Q8vPFBUu+MGm2kUHZO5KfHOp5VBCknYAVLS4F2yLZtTwcJPR0P5yXSasdZX58BXayR2Ycn+z8nlugeDehg33MpXgVVCKGxYFpmQae5UPwfbG5oMUJrnK2YhM2brcxNe+VzTpefWIs5UOyYNA1SGzu4LljOIVP4JAuKNgdbi2qAh35kdPVV9Fd2Wp7k4OgspAkclvN5iFlU1bRm1SYMrqEVIBEDoIXUh8Z/SZoEQss8/rY8OCyR7Bza19ODZ7oJkhKTE4ByV0gEqCThiQDYPzTi1foP/RxjlD+7WqL45LssgaV6BaC6K9a+KWTKWBLwJGivdA+sDiUihtOT1815MLlPLgRHTFH4JDtFUuInhWIbS1SUAhXur9oNDWvmNKNaaiZ4iKq432J4pDnDACDmYTSfeZydDzeHpKmkI8Wqm1hl5Fl0zMQIDelm67dgyCtXPUQKsahBXRXjVT6hP+0VS0MjLAAXQpyM576gpz50OzlpueaxzJkkEn/ylw2G2Qne0tOHIR4Vjpf7hbvGm08uQeR6LJSLiD33WIWrFxkNidHWFyvwKm4rcTGtHTPktuP6/lPH+uphi4OU1Uvg4kJxSr/Qci+VsxnpMoKUQ6xdJm8HnmoqiTJqWiLbNPcBdOQWn1UF+5O6cpoLg9L+ao
 f3lWNDwe
 YmNPdeh/AtYnBbivKGcqGFZeCe7M7eo8/iaVl0wfO8GIEoX4qW0iUV3ECOawdxx0sUlmPjw6qtR1+5PRl130K18bmTf/5Jm/bWhkCUp6PqWtx0WDDQnXxJzLAkN7jPRXsI0XuikEuBR6MargXGhara47SkIpOXGWXYWdemqg9Fy/yK4uw+GgjagUStueVDpqGvtHlvQEZQK0IkNZtEUrsfn2+13N9YebgMJiRHzCNzOjQAeRwNAOC0C6aKFJX3V5HhS1oH3h4tj8Lfe0jV+lAxgREIei6E6HL46UjcKqlxsEvWGC5QF1Hw6AKLjRvcKqmn6sNee6ZV71Zd7Ilpiph0+xiZ1GfT6qmfHhp24s888U8exxgxqtxpgW3ahy3SrvgMf3VoK4Fb8+rS2mXzbyv80EcArVcC8U47urmNs1GwZDo1dZ3JNHxHlUAIgq/bBLqVD1IpISMMtJBFBapVmMB0/2Jf8ggTFYyKeY/CgTlF20wSY5e5eNAc1zAwSf7csg3Q7Wbpc2/gkpK+0hRPKvGm2F1ISZBaXAJ4Q/cYjpDFktAhdpqi+XCcavK12h5fKt1+Xc7I7DZ9gsXXYwjjqH7BUBhHPUWIaXq0NyPmYDNzAKzKFJwFXAyZw+tS2K+CLvLxAsfW4Za+fG1MOGv0yIq6nMH6k2RGlfXgFt8aScfYoQZm0ijrAz4270P0Ioiz+mZ1nl+ep2EVa/PqzM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.10.25 18:51, SeongJae Park wrote:
> On Wed, 1 Oct 2025 09:03:53 +0000 Jakub Acs <acsjakub@amazon.de> wrote:
> 
>> Make VM_* flag constant definitions consistent - unify all to use BIT()
>> macro.
>>
>> This is a separete follow-up fix after we changed VM_MERGEABLE
>> separately to isolate bugfix for easier backporting. As suggested by
>> David in [1].
>>
>> [1]: https://lore.kernel.org/all/85f852f9-8577-4230-adc7-c52e7f479454@redhat.com/
>>
>> Signed-off-by: Jakub Acs <acsjakub@amazon.de>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Xu Xin <xu.xin16@zte.com.cn>
>> Cc: Chengming Zhou <chengming.zhou@linux.dev>
>> Cc: Peter Xu <peterx@redhat.com>
>> Cc: Axel Rasmussen <axelrasmussen@google.com>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>   include/linux/mm.h | 66 +++++++++++++++++++++++-----------------------
>>   1 file changed, 33 insertions(+), 33 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index c6794d0e24eb..88cab3d7eea2 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -246,56 +246,56 @@ extern unsigned int kobjsize(const void *objp);
>>    * vm_flags in vm_area_struct, see mm_types.h.
>>    * When changing, update also include/trace/events/mmflags.h
>>    */
>> -#define VM_NONE		0x00000000
>> +#define VM_NONE		0
> 
> I'm wondering if it could be more consistent to use 0UL instead.

Not really required, and if we're switching to BIT already there is not 
a lot of consistency to be had. Would be different if we were avoid 
BIT() is in patch v2.

-- 
Cheers

David / dhildenb


