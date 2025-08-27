Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E13DCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 09:16:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBA578E0130; Wed, 27 Aug 2025 05:16:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E91BE8E0105; Wed, 27 Aug 2025 05:16:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D808A8E0130; Wed, 27 Aug 2025 05:16:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C5D3D8E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 05:16:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 539B21A0521
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:16:33 +0000 (UTC)
X-FDA: 83821981866.03.0858F04
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id D84144000C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:16:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VvzSLm96;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756286191; a=rsa-sha256;
	cv=none;
	b=1B02YyB7Vj6Bf8Ed/5QM7DdLw3PUqXLYxz22BLbhswvBZCgG9rLnZq90+jl4zXkZxuiKZm
	xueDqOW8f2ec8nMs5GUMFr/qkQ79u9PcQ2cRbWLsvxm8JzVY0dDIcD0O6lFIM14lQrG4yh
	t9viOJK8LQR7fnX1vT1TxrqxbqxfAqE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VvzSLm96;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756286191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZD2WYkTm/t2ql8rfC6vZGfUAI+XdDb8psV6tcwC5U+s=;
	b=0suzdEr2wbvU/jA5y7mavyBO7DC/IQ8SdzIh2yafWUay496nDpyY3pPJmYyT1l5aF7NIdu
	HXLX+sMDeouZeX/6M7AbF27y/6G0ZyLTcrtSjFHheatxivXdtu0L80ksFcIcdW1uLOUaax
	IHPdc893LXtCz5lCy1Yzl6vL+K2rt/8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756286189;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZD2WYkTm/t2ql8rfC6vZGfUAI+XdDb8psV6tcwC5U+s=;
	b=VvzSLm96lXux5MRBzTqX1dVkvVc7LdY5U/iQAQSd2Z/0iH3COllBmHQEs+vidbPp6CbaPc
	iALp/gcjDdeR+Lu8AUVW9XTrsBSwU+yanojaYsGkwIvxCh/knig9dHuFYsKo5VIkyxddSh
	0HSUrb77I+Le0xb+dMmzWYdmluHM1hY=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-Vjuh0souPZK5_tgWe1uBuQ-1; Wed, 27 Aug 2025 05:16:13 -0400
X-MC-Unique: Vjuh0souPZK5_tgWe1uBuQ-1
X-Mimecast-MFC-AGG-ID: Vjuh0souPZK5_tgWe1uBuQ_1756286166
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7e8706abd44so1620259885a.3
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:16:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756286165; x=1756890965;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZD2WYkTm/t2ql8rfC6vZGfUAI+XdDb8psV6tcwC5U+s=;
        b=PNaSk6OOgKlThXHqVrKJnNqPq5+O1FdodgCMfsCNQ0mCQDdOVTAFv/37aYJunkrw8j
         6E/9VNeVS3H3U9tO25E4uMYEhFd0Wm3aZHvSAT4lqrbEA0846VtGVAFcBbOCFPZ5UX5r
         JOenXs4RNR9iFnQQT0NNqV6wpFn1wkSupYym5YZN6qZFIsSanZ7Iigw6dO6oQdd2r2Za
         19kclUUao5nKhISIHe0IT2zQWqzq7sYvXt/K6GtzjQTEX8ZL+E41iOQdm0L99xRPTree
         C5gkNS2zGFsk1gwvHI/pN8qC3kpqWvmAqCsgBLDKXh/tQcwctmn0V+pot89ivpYMBK1C
         em0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWb10azjvF9w8STiL8sFCXYdxzJcCqe4FOQG/pWS5ulPlMt9tAoJV5ljl1clXMKWZTJtRY9qFNS8Q==@kvack.org
X-Gm-Message-State: AOJu0YwABVFfZYT315L29fJvl1E7wqcNSz5L9tky6IULCttEodlujdPM
	khPTaKk2syf4O9RKqSuYig9hQ65ailb0D+P/AtG55YLhh7Ky+m78MsSbfgwhBSKDK/gBfXugzXM
	OAfkeUS3bS8W6ieY4h0atCFRlrfYT0wh1s6pF0qSt7oZ9GYKO1XwE
X-Gm-Gg: ASbGncuU7SGbnTFdeBeCo6CFz2ImwFMbcfhuTBAuo9JsjsVzh7sM1JroeW18f5KQuRu
	7+kCrwsjrhKBu73u8XvJCWcovDHHuKOd3G/TdMe0EqCbGyi93G56a4S/AliPV9dj538ySUyP15P
	ggE6C+GpzE60wqvCXJp56sdDw3C45FxtZmEVwZoH1cD/dU/ZF9p4jmYcYcgAeK3+/1coAoqEYBr
	gm5obUfFH4pt1ZdspR/gqU24Qcsdtma2yJWgvv351cDyC0tusP5HkteJ0Var6mc/8T5qyeG01v8
	wJqIl+IHg35CrkY9OWgDFcrnYRN0nFWY/mUptIlYIndCysvEo2WteHTNggSGQg==
X-Received: by 2002:a05:620a:a206:b0:7e7:bf9a:8556 with SMTP id af79cd13be357-7ea11096b70mr2401167285a.40.1756286165461;
        Wed, 27 Aug 2025 02:16:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGdo8H1ssGIoO0CbZN4nSHfmJO9TVTHpHsSR833V8yDL4ZpLJhI4BouKGu2PECgtRIiFA6NCQ==
X-Received: by 2002:a05:620a:a206:b0:7e7:bf9a:8556 with SMTP id af79cd13be357-7ea11096b70mr2401165085a.40.1756286164943;
        Wed, 27 Aug 2025 02:16:04 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ebf2868788sm832115085a.44.2025.08.27.02.16.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 02:16:04 -0700 (PDT)
Message-ID: <c3f5deea-4d42-4991-86b2-98d3de73afed@redhat.com>
Date: Wed, 27 Aug 2025 11:16:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2 2/2] mm/pageblock-flags: remove
 PB_migratetype_bits/PB_migrate_end
To: Wei Yang <richard.weiyang@gmail.com>, Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, vbabka@suse.cz,
 linux-mm@kvack.org
References: <20250827021121.13645-1-richard.weiyang@gmail.com>
 <20250827021121.13645-3-richard.weiyang@gmail.com>
 <9D5D10F9-0D76-4C31-B03C-27A3A2B526AD@nvidia.com>
 <20250827064352.o5vw3f332ptlemrg@master>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250827064352.o5vw3f332ptlemrg@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4blNHfsI1uGEgVa3xOrMbmqUN5WLhsLd9eLxLQ0_Oc4_1756286166
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D84144000C
X-Stat-Signature: w8zz7co6kj7c57xcwmb811u7g9xkciy7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756286190-604071
X-HE-Meta: U2FsdGVkX1+E0NplNgT0K9HxCjFX4QEHh6+R60CICWb5KxvnSeFsb1P9kUv4gVU5xQ9iZPOJgabbv0+UA/eNzVCwqq+YQS2tUPln1kWdz/OQUlbqJxI555NYzULbOFNo/JvLwsVPIwlIxAHo932Wd6fZu0WoWIFUeDp++RYqS/vxX/OtnfhL1eVKZxavBVz6b3eryvbgesth+XIR0iyF5MLKZXeKOkfQ0SwPuSOCgpOv+1bwge0UB/MCT/aHO59UHRR7c7rBvN5SnnfcxjV1A1f6np05xgrR7E6HNNjNnYCfvwL3hyMCf3J9majAwcRw3WHEMTOFj0Gkk4Lu12LZj0AZzck+obhncvpC6XQTCWm7e2XZGjRcttr9EkFltcAPwqfuW3QYl9B36OFrXelH7w/J9/iVnhZK3z1FXOM5d3p3YxuhkOkZ6KK559QCVHMHmeF+dJMrSWBrL75t39qXlYX3MHSwQEydJ+v9Zr6na/y8ey0X8kNpYMqODSBcZZ5YJ7kNjxTWWUbAEm6e31xJv1TCarVu+JL/4XjsefufBL2JEcuIhqJ7WROV0zvU6K1+o/MRRQ7hM+vZIfkLq/vN6aojuxo0/nAYsMLfDI9BZqR1uUFn8lRyZvzLZYdwCNP69M5bd57yzmblL4wy0KOCR/hSZvZ+vcaUNr8Yljimf5tZCMAOTmVvb60tI+4Z4RllV7g5qLW7TJAuYxQdeeFQjtPXygvAC/tY3EKK6aT0UuFjrCeMnj9PQX+hmVZglEpjKU/WF4C5P5JJ6RlsEJn0d+DDfRied2zDig1Qao/CBEevDXITD2x50AVvuiJ2GsFRaUTXAkxco7vuNpsj6wCHdsdN2EoTGYLo+K7mDu0JYaHYFJ4oBwohOXZ5pytaYBskbbU8DZMoj2IbAOz2gO77jn92RwfbPVeKIklCaYICyHaUcggKBuEPDX4VmPpRUVhWOpxP7tDTXTs54NELnOR
 VtR3VNtE
 HQYDMn8H/mT1DHpdcKutQagNanYnmzzAUgYdwAAUrC3kiph4epMD1GjPUepqQcREPc7fS/CdFH3YtBZqG+Dxy9oO6g5jZln3ZPibxRCvBKUT0xMD8uNl6cxax0DY5ObPymXIw2/+rdN2eq+fVU+HaFBjtGSlWm7r5JR1RmV6xT5mpqBBocwjavXR8kCdR6WFfhuKsyAMRK63tnNGrqVSQbJYLjbajKkRq7uL/an+tyWydEhRLc45H7fXQ/YzXZyI7lgXPMRbmY/llgdcHxSFB9oyfB3S26GZfE5hH1QVo75xkBD2uKb6LnhnN0UylqMO0zh31m6zl7ZNLj42g3Iom1lYnCHpkUDjaMoRh9nC7BCi+u3JGa2eu7F8NdEzJGkGeeVQW7+jRJWFb0C1mc1b2b9sYOatEE+2gAdvn+DA3zFaVYFD5imO7Bcowh29X6CTZMjkgYIYWmQJ4ncY4k30/V4Qlxir1vTGxY3JyUIgxAmBDw5Ea4Osz5F6cXY/3n3eSz141T0FNgmenXyjVtCESRCHoeEgMnh1ioEHQEchhDDkd45fWnhCJIuZtYKjRapg1m5eM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.08.25 08:43, Wei Yang wrote:
> On Tue, Aug 26, 2025 at 10:21:20PM -0400, Zi Yan wrote:
>> On 26 Aug 2025, at 22:11, Wei Yang wrote:
>>
>>> enum pageblock_bits defines the meaning of pageblock bits. Currently
>>> PB_migratetype_bits says the lowest 3 bits represents migratetype and
>>> PB_migrate_end/MIGRATETYPE_MASK's definition rely on it with magical
>>> computation.
>>>
>>> Remove the definition of PB_migratetype_bits/PB_migrate_end. Use
>>> PB_migrate_[0|1|2] to represent lowest bits for migratetype. Then we can
>>> simplify related definition.
>>>
>>> Also, MIGRATETYPE_AND_ISO_MASK is MIGRATETYPE_MASK add isolation bit.
>>> Use MIGRATETYPE_MASK in the definition of MIGRATETYPE_AND_ISO_MASK looks
>>> cleaner.
>>>
>>> No functional change intended.
>>>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Cc: Vlastimil Babka <vbabka@suse.cz>
>>> Cc: David Hildenbrand <david@redhat.com>
>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>>
>>> ---
>>> v2: remove PB_migratetype_bits and PB_migrate_end
>>> ---
>>>   include/linux/pageblock-flags.h | 12 +++++-------
>>>   mm/page_alloc.c                 |  4 ++--
>>>   2 files changed, 7 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
>>> index 6a44be0f39f4..6e4c2da15706 100644
>>> --- a/include/linux/pageblock-flags.h
>>> +++ b/include/linux/pageblock-flags.h
>>> @@ -13,12 +13,11 @@
>>>
>>>   #include <linux/types.h>
>>>
>>> -#define PB_migratetype_bits 3
>>>   /* Bit indices that affect a whole block of pages */
>>>   enum pageblock_bits {
>>> -	PB_migrate,
>>> -	PB_migrate_end = PB_migrate + PB_migratetype_bits - 1,
>>> -			/* 3 bits required for migrate types */
>>> +	PB_migrate_0,
>>> +	PB_migrate_1,
>>> +	PB_migrate_2,
>>>   	PB_compact_skip,/* If set the block is skipped by compaction */
>>>
>>>   #ifdef CONFIG_MEMORY_ISOLATION
>>> @@ -37,11 +36,10 @@ enum pageblock_bits {
>>>
>>>   #define NR_PAGEBLOCK_BITS (roundup_pow_of_two(__NR_PAGEBLOCK_BITS))
>>>
>>> -#define MIGRATETYPE_MASK ((1UL << (PB_migrate_end + 1)) - 1)
>>> +#define MIGRATETYPE_MASK (PB_migrate_0|PB_migrate_1|PB_migrate_2)
>>
>> I think David meant
>>
>> #define MIGRATETYPE_MASK (BIT(PB_migrate_0)|BIT(PB_migrate_1)|BIT(PB_migrate_2))

Yes :)

>>
> 
> Oops, I thinks you are right.

It goes without saying: please test your patches before submitting ;)

-- 
Cheers

David / dhildenb


