Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97D2FCA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 06:42:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3464E6B03EE; Sat, 16 Aug 2025 02:42:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31DC56B03EF; Sat, 16 Aug 2025 02:42:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25A926B03F0; Sat, 16 Aug 2025 02:42:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1837C6B03EE
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 02:42:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9A0FC1A0396
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:42:57 +0000 (UTC)
X-FDA: 83781677994.09.B11D237
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id C31531C0003
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:42:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mSWSKq7F;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755326575; a=rsa-sha256;
	cv=none;
	b=RN9WI5KJ/rBgzspIT8w5heyOiAiSCpyjpxOg63eCHyjIr2+Svn1fGJbZL2PpYNyd85uu0K
	bUAOf+x05bET8zBvn0czeU4opgffUsSJPhJCJyzCI8H5VwlvGrqyH/ZraAs8pwEP23UAQ7
	ri+CzbIXFzFk+Cy+own/3PWrhW6P1UE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mSWSKq7F;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755326575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JeEKBRdhTjoLFfwRtZLV9M5Ry2UMrcAVp6PSuF7j5+0=;
	b=RjwQh1iZHPPTjydcHMX0UAtl3kyokuBLi9tQnpi7AXKwPAD4zlrg/HV+NM0rEvFlsDWem3
	VfBjsCfurLiKL2UEFDLQIT75EOe7JeITGzX04+gZ1WLUnVgcIVHlCV3O7Qp17E/VHZ6B/L
	CTaark0/LBabvJ6oTRam4OjasMxL170=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3b9e4140f38so335763f8f.3
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755326574; x=1755931374; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JeEKBRdhTjoLFfwRtZLV9M5Ry2UMrcAVp6PSuF7j5+0=;
        b=mSWSKq7FSx2RQpeIcJp3YsKoMgpKCZKXH3okIxM4k44QGqsjo4D8QJCQ49KXUAkrtI
         TtfIF+thZws5DTmVLG6ZRTIGgvoF6SGjrUrLEgWfMKpw38SnT2KL+9om8UuFWuMpZbto
         bsNLBOLMPzCI8e9QkWDu/FE1+fYxeK6ml7s9Q6LVmy1sAvfG3tsv3VuQp8MBwDBQMJ0a
         anQVVF4hMD6ZVNRR2VNAuL10QUvVOVic8yvWwsoDRjaaWI0LBk12RRPSYeQfOYLhY+6M
         3zSc6sSqaOdumHY3uzRKd5JanBFrJbCNrPe6D0sJBLRIGU99xh6fV3J0gYI6YdBv6rBu
         gIOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755326574; x=1755931374;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JeEKBRdhTjoLFfwRtZLV9M5Ry2UMrcAVp6PSuF7j5+0=;
        b=R/ewcHhXztBJ4r69imf4RKJCWH43Zf6h+mUlUxvnfYrtXVVhG4GB+Snpf01iwusRYu
         NKABHXsrlPVmtq61hLPeTXminInS+PBeORp0X0RIcyVkGSvDDFA+tVD9xK+Y5zyPuvL3
         2JblUFqgYZWEyp9sTjslf3H6plFoGTeRw7QtrG5jTKJMu1K74FsfEKf2hclP2qOoKTMT
         0LJPSaCRZWvP0TMF6BhR8N/j6VBJh3j1TRgXJNzqEesOX0HAZ3YvYu3gT3yZCjCwr171
         8dC4kKmKdYBKk5SzmVE20AQPTMKMFF2zgQD9M3vUuOu/nfDhJCg6IM/Z1QhOEiSVdkpV
         ALWg==
X-Forwarded-Encrypted: i=1; AJvYcCV9ZA3I9wZ5jpI8bbWvP82B2/CtdXbmgoU/x9TM7cOLWZhcAh1iGvhOtSeX2QsobTAlQ2wm876yZg==@kvack.org
X-Gm-Message-State: AOJu0Yy24/i+4QIl4peURFlr/tefiUYt2cMwzwnK9Swz6RykLzdr50e8
	0/LkSyPiuIZlgL3L7Sf8rsNrZHdd6w+omdw2PREosZGwuKQQHgQ/HAoV
X-Gm-Gg: ASbGnctr2eXTY8FPMYwQGwrmWkRG3JuUTHtfYMSlqrZ2hBOB2jOpx+ANuChMKmLzq/y
	MxoM5Xjqo17MWSqYN6AiUOIqqyRYIQ338kS6I+hJqmb1Mu/JidB1YyXWMsheuFREUkJOypVx055
	4sGrwTB0pVAirCH4b0UMLeKR9/QMYZoeSIeHI4YMCtz6inYpEuq+mmxcBour2DAPBHPBcBYjSTa
	cIhlymmf3iVqz3kYfD7qnVQYm66bPZU8RUhq5awBmQZTPCVmtJAFyfyi+/4l9JPL1LReGOay1h8
	UfpDekiZUrI4uatWaUTHBwYelMyh+dDCivE1+oUxZBXasD3Qv2dJ9YC5dLqAZBXIpeuteBBAajO
	L2vX+gyCgdog51NuKW7LvdZsEnMTWbZxEetFWkg3yg+ZJ5+BshccJ
X-Google-Smtp-Source: AGHT+IFwBGKlpiM2gncW9DMNhxgxGnhxg0FqOQuyyKtVBQjC5y8R5nUYtXdYLoaCw5QbLrRt6oMYVQ==
X-Received: by 2002:a05:600c:608c:b0:459:da89:ae8 with SMTP id 5b1f17b1804b1-45a2395a19emr15848035e9.2.1755326573887;
        Fri, 15 Aug 2025 23:42:53 -0700 (PDT)
Received: from [192.168.100.4] ([149.3.87.76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c78b410sm88598235e9.24.2025.08.15.23.42.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Aug 2025 23:42:53 -0700 (PDT)
Message-ID: <9be479a1-ab93-4ec7-b1aa-68acd94f15ea@gmail.com>
Date: Sat, 16 Aug 2025 10:42:50 +0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/cma: print total and used pages in cma_alloc()
To: David Hildenbrand <david@redhat.com>, Xiang Gao <gxxa03070307@gmail.com>,
 akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, gaoxiang17 <gaoxiang17@xiaomi.com>
References: <20250816042842.3959315-1-gxxa03070307@gmail.com>
 <ee29262a-911b-4a97-b619-0dea3b657252@redhat.com>
Content-Language: en-US
From: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
In-Reply-To: <ee29262a-911b-4a97-b619-0dea3b657252@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C31531C0003
X-Stat-Signature: owo9i8zm9u1g149n3cm5ui9qhkissjck
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755326575-712765
X-HE-Meta: U2FsdGVkX19UA2vMDu5hQjF2zYbEQlqgl1qdBKnOq4zA7baNjp1tZY/zKXWtDPFO+kJfZsX6W6rvYGbKbLJVqbeKniGss2ebqC61hQ3Qxh57tFMk9TikMNq8At7f5cxmQONnWUUm6FWoXEZsZ5q04lpUuQaES6qMilvi5PGBmtISJ2nOebEsCqzUMA/J/6+yzZJtWKJj4lC+7x6qMbocDha5/2K6CaiaqPiavJCHRKE9BgYnEE1O4xz4I+YkRUqtOLMdgbq5Q/clRtgSyV6yH66KCxAzssIRNqVaQtRNKURCZq8p016ZuCZBZREv+jGmCTpo2QHmpvhYwDw0B4sPBQkReINQ9u13rfNPuTjY7apUKuTY/Nk8QYC+Y+KTJVs8JtzLdBEr0nBRrkU0uP2OTKx/VuXHKELKYQqLj6W9G07wm+H/jPBDfb0JwC2ZrLYqPSeG9/RdWOKVeuHToHLxi508yCXxM537y6Y6W3eNN2o7CutVkEII5gwr9uZwqZhtl/xmemz/B9bPLYvq0y5iWFdntwwko3xGsSVcNT+5qmz8/6uaQcrLXtqN8SZtbuVapNmn2bJ7ChuKxWelJf05Rnz3bsBNBcuSAliKX/8x+4VYA02N/cYbkrep+A4DvNcL0cxxVui9hgRxiOT2Qgj9UtEr2ygylea3N7PMI78y9BCjMjAqf+TVt2x5IMHXlOqymUDIz5qqiR50iJix/7DJjH+JZpDn4R5FDs1d/3/I3qKvL7sGaZw1gCurxWJVHbInHmTBxDi/Ub71MyEZdeJeenzmNrvkTX11it+njywQhvleVaDDkpsWMBwnqIHZzEwiO4Xj7kwr5Dr17q0SD6rAr6WEERYR97E7zYEnDd9Ai+r0opG4kx1rXdEi9ZwIJrLvV0cINGZ9QYsxGFS9xc9MIjUvjTh/lVe8XKN8bV428cMA+yt8E3OgEo8bnXtGKIujl70BKnEJIWyiX46mCke
 0ai6rEzb
 qb9GXfYTO5solhGsd85XD3cUr0yV90MFl4kjKudn/rxqPDet8cwpSzr8lB365ny3bZAhoq+VfpM09D/NDjbt91hR3fbC0VxUvcAw1aEHiTC8+Tyg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

What about using tracepoints?
Add a trace_cma_alloc() event that only runs when tracing is enabled. No 
lock unless someone is actively monitoring

On 8/16/2025 10:27 AM, David Hildenbrand wrote:
> On 16.08.25 06:28, Xiang Gao wrote:
>> From: gaoxiang17 <gaoxiang17@xiaomi.com>
>>
>> This makes cma info more intuitive during debugging.
>>
>> before:
>> [   24.407814] cma: cma_alloc(cma (____ptrval____), name: reserved, 
>> count 1, align 0)
>> [   24.413397] cma: cma_alloc(cma (____ptrval____), name: reserved, 
>> count 1, align 0)
>> [   24.415886] cma: cma_alloc(cma (____ptrval____), name: reserved, 
>> count 1, align 0)
>>
>> after:
>> [   24.069738] cma: cma_alloc(cma (____ptrval____), name: reserved, 
>> total pages: 16384, used pages: 64, request pages: 1, align 0)
>> [   24.075317] cma: cma_alloc(cma (____ptrval____), name: reserved, 
>> total pages: 16384, used pages: 65, request pages: 1, align 0)
>> [   24.078455] cma: cma_alloc(cma (____ptrval____), name: reserved, 
>> total pages: 16384, used pages: 66, request pages: 1, align 0)
>>
>> Signed-off-by: gaoxiang17 <gaoxiang17@xiaomi.com>
>> ---
>>   mm/cma.c | 15 +++++++++++++--
>>   1 file changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/cma.c b/mm/cma.c
>> index 2ffa4befb99a..46cc98e7f587 100644
>> --- a/mm/cma.c
>> +++ b/mm/cma.c
>> @@ -776,6 +776,17 @@ static void cma_debug_show_areas(struct cma *cma)
>>       spin_unlock_irq(&cma->lock);
>>   }
>> +static unsigned long cma_get_used_pages(struct cma *cma)
>> +{
>> +    unsigned long used;
>> +
>> +    spin_lock_irq(&cma->lock);
>> +    used = bitmap_weight(cma->bitmap, (int)cma_bitmap_maxno(cma));
>> +    spin_unlock_irq(&cma->lock);
>> +
>> +    return used << cma->order_per_bit;
>> +}
>> +
>>   static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
>>                   unsigned long count, unsigned int align,
>>                   struct page **pagep, gfp_t gfp)
>> @@ -858,8 +869,8 @@ static struct page *__cma_alloc(struct cma *cma, 
>> unsigned long count,
>>       if (!cma || !cma->count)
>>           return page;
>> -    pr_debug("%s(cma %p, name: %s, count %lu, align %d)\n", __func__,
>> -        (void *)cma, cma->name, count, align);
>> +    pr_debug("%s(cma %p, name: %s, total pages: %lu, used pages: %lu, 
>> request pages: %lu, align %d)\n",
>> +        __func__, (void *)cma, cma->name, cma->count, 
>> cma_get_used_pages(cma), count, align);
> 
>          ^ one space missing for proper indentation.
> 
> But doing another spinlock cycle just for debugging purposes? That does 
> not feel right, sorry.
> 


