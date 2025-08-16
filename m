Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A43ECA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 06:40:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1939E900260; Sat, 16 Aug 2025 02:40:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16BB08E000B; Sat, 16 Aug 2025 02:40:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00B7D900260; Sat, 16 Aug 2025 02:40:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E574C8E000B
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 02:40:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8B1B61D9674
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:40:46 +0000 (UTC)
X-FDA: 83781672492.30.923CA07
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 02CDDC000A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:40:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MkfFOXav;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755326444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpRMVDaaLqCDMC4grBCrsBXEgRiflpzfM+Z/fw5Kj/s=;
	b=RV7ItdhvNPsuW2TVTmNPBNBxa4eUz2GdM5IA1G/SLjv9Jpw1EFZXUVo9b0abIVJJN44qkN
	CUgJp2Go6FdycehOv8+wI0twdQrdVaSevz3FzF/WT+8fjQpsSNqyq2TdP0aUqyx3qTCUG/
	QzZcBlovvlArOMdTkKq0VLWD8VGJBBI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MkfFOXav;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755326444; a=rsa-sha256;
	cv=none;
	b=xix7q7SW2cPwA6NXLRcuoGghp1YqhVoAVa6LsmgVKkMxAUhAr5FhQL+ymsf4bAcnIKkY45
	E5JoveEWELS+mX62OyJUGi1ytG5Z9+82fPOL0f4MUD45Xg+3UVTuwqr9avnBz/iFjp9tce
	BYCzoQS+sw1uK06Q3E/Y3HZSoFfQieQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755326443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jpRMVDaaLqCDMC4grBCrsBXEgRiflpzfM+Z/fw5Kj/s=;
	b=MkfFOXavwjY4PreLhz3s2ESeaBCw0MRbdnv5fo7Nmt1gWouxJYfzGqQSSmlU9A8Gv4wg+e
	K0rb2lCNyTleqZIPgIKCo4wEQ3nVi7tK+YhxpAVUQVqxiWmWZfELlmvDgzFCl5vAUjrX9u
	I/xDwGjD1aLwQ65nn1Q1InBavlKTcMk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-373-gMhBP9kTPYGsLN20e3cqnA-1; Sat, 16 Aug 2025 02:40:41 -0400
X-MC-Unique: gMhBP9kTPYGsLN20e3cqnA-1
X-Mimecast-MFC-AGG-ID: gMhBP9kTPYGsLN20e3cqnA_1755326440
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b05b15eso17786875e9.1
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:40:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755326440; x=1755931240;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jpRMVDaaLqCDMC4grBCrsBXEgRiflpzfM+Z/fw5Kj/s=;
        b=Vhf+x3Lah62RjhKswh/PawrQV5dP+fmoi/1XDVB7lJwoFoUUep67tgZ/XJd2VjCd+c
         DcMSBjBS8w1MoEXJzby3VaRBe+RP1ZJS/PC4waOzPg0KU+FPmFjVMCRLGukENQKidJa4
         wUALBZsL+RHUKc+LBEwCwyZuM5uLK/Of5aBjjci1+viz1Uz1SXqx7uzXsK1EPn4Uqb8b
         2wnlM7TIm6AvJ+4sEYyKuBnPeTkFgpkN9DftftkS0WJEkz4xFpoBVEDR+FJRoKIyx5oq
         CKXUK7psFdy9rmLvRU4jOJQq9U+RD6JarOPlEkldN1GSzk2sv9Pwj8cH6oLgoTVnYwe6
         5b+Q==
X-Forwarded-Encrypted: i=1; AJvYcCX9zNM56wyXs5xibVwjQX41f1e9ZlEaxE/zxu/LSDEUpbMZNs5hIEpH0aBoztY+soUoy1U5NpsY1w==@kvack.org
X-Gm-Message-State: AOJu0YxDTv/TvA3GUm4Ge9KKfKzU/yb92S15PMwhFKPRpiKRPsrTZVon
	CXNuotnSqFgtCeU2Rep023wnsOkAiivmINkddNS4rpHVbAgk71Yw9K/k3+r05qVlK07hgrTHAYH
	6XGeci8+GvVPUGRc/EtZvgMzHPLAq2AO9Z9gEaSgZpr54y/A0G3s8
X-Gm-Gg: ASbGncv/yTEhT9QNpzDz2AKldkJDUR4hglrS45HNLUlX1DzeQDPHCckXrWLzXUr+XwJ
	Nxwje4c3hMYHSRpGo99UCxh5vZgOEGdPE0nPGCfDPEaES1ZquCM+47mLP7pznFpXU2qYSdT9Qnn
	hoAvP9g3NCLuGEf+LyqGT14eN+8CwihN6GKlSB2ahqGfahIMwjs2DJU4JFilLYZ9vNnX0vBMgWU
	Bmz4ouDKKwlAKnhBAEHrltBBG1iRk/VZ9ycH/0S4vzcKzjLhUSviZnRouo6nR9Mma/msX2cbca9
	WP+32oqjIrniqPWKJW+VU4EYmWlP7RoEX7uXDAm/OJve7+iydWTUF2Ipd4OJAkk3rYe4MdXdPy1
	cOzvREnjuI5uh1Kc7lLzvf1EEuZ71PNjYo5YQ+l0iPODRw6284936YYKSj8gSk8ABSKU=
X-Received: by 2002:a05:600c:4ecb:b0:43c:f8fe:dd82 with SMTP id 5b1f17b1804b1-45a2677e60amr10342525e9.18.1755326440256;
        Fri, 15 Aug 2025 23:40:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEpfUkhjb1UsDmaY7WU/zF1Z7iPtlNuRIErvYfv3ZUEuiVzH0icWl5g9qcQkZoeYwyzg2Na9Q==
X-Received: by 2002:a05:600c:4ecb:b0:43c:f8fe:dd82 with SMTP id 5b1f17b1804b1-45a2677e60amr10342355e9.18.1755326439560;
        Fri, 15 Aug 2025 23:40:39 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:c700:d8ae:41bf:492a:9e4c? (p200300d82f23c700d8ae41bf492a9e4c.dip0.t-ipconnect.de. [2003:d8:2f23:c700:d8ae:41bf:492a:9e4c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a22210ab4sm44725805e9.3.2025.08.15.23.40.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Aug 2025 23:40:38 -0700 (PDT)
Message-ID: <dfbaa342-632d-4911-a0c5-f1ffe32f9e57@redhat.com>
Date: Sat, 16 Aug 2025 08:40:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 6/7] mm: memory: add mTHP support for wp
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 glider@google.com, elver@google.com, dvyukov@google.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, muchun.song@linux.dev,
 osalvador@suse.de, shuah@kernel.org, richardcochran@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250814113813.4533-1-vernon2gm@gmail.com>
 <20250814113813.4533-7-vernon2gm@gmail.com>
 <226e21a5-8a8e-43a0-bf5f-12a761f49a27@redhat.com>
 <aJ9QJ2V0WQ5XneJx@vernon-pc>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aJ9QJ2V0WQ5XneJx@vernon-pc>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: s0mPT71fOCqstOoNOs_G7dhJiMmQW8ZitLEnol_5ouM_1755326440
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: q4epbrxsxfxezpye94mnji4u77e95yia
X-Rspam-User: 
X-Rspamd-Queue-Id: 02CDDC000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1755326443-367576
X-HE-Meta: U2FsdGVkX1/+g+IZgxMBVye+YdWeCEgfUT5zMxEAhFydJm4lUAMSm2uxstHvuFMxs9Qsj4i51/txc17wdZs6wJMZ1AUZP81AlZjWLP7CdhQMEr9DUO5HBQq7fxB7wyiimLxOoLWK306NtPtBBkjd3EnBQAY83Ze9tsGD5ahqyNU0OW53nQ/gTzgWHm0OFA4Cgp9t3p6SdjmRMTckk6KoeT5moxNE4HhwPEkijycuKOpAV68u3KPvd2o+z+SQM+EkQF7fCUMKm3+tWrCp1QJ6gMSX4zbkosDJqxUAgRHqlVh+TiQ97Ke9zlxusroyzVucuzzcREpXcZWij/kLTWH44Jqt5V/ni8cyPYFv9LTyqE+dkn9vQEsPE1WOe2F08iTczv9vlXl3hnOoeQzTg785jtgp+HnSQ2nBmtPbT5Xu6dT3wEf1TjCmHIQa128jZDivAZVDT0UQ5c+rWct/LQrzTzlq5Z0TFlg+dyPb1tG2XUWqtIoSuvEeqkIQfP6maN/5ggqtarCG7EaCRoMzOeZkdamRbfCwdV0m28PDTUwWXG3IhBmKnFCJxUaUzBI2RQ7eETEogOmiT9ZwGe3Oz474EdnL2le+A1hqNi7wZVVY3nmXsqMF7uPu2qo6c6oqFyKuml9qvuhLqBEeeb3uYYS5KV2sbC75W98ORB98nCLurDyvV7YcwcTqFb9oqer4pw+8I20vkHxOjbPJTFSahYViEHaITnZ5+SdstaVugqKpmT79P1Q50GIuS/hWXDaZGq/fPVOzSdqDPN6+7FcRmkWzk2nWbd/DMJMxeUuKK4ZFUiIT5kTbd2D3C/2gHXcyq7ZyRRxC/CmPKV1Orxx5yYY/DduLkzfJRKmd5RakzccBSr0CpI2w6KwQZEJVFkI0ugc86ZmpUf7T3uE4fyDBRvJ29FMted9bHlDU+qj6nmtrKD6YI4g9Z/xD8ixHgxOw+0+YmJMDmIxek53Bu9U7J+c
 OufGzV3M
 /SdHJ3dgGS3U1F+9JViiLg1UcG1YkjItSxB2+38crC69DTvp+GOCaIvTB82SHv0uRjk8UzGEwS/br248njsrXe4R/iISGGMlCqfWGaYnCgKlZ6BZbm22lGX4pFL6KZIJXNvs2miSkNOfaKTZpO6KbAmSEUt3ETmB9Rfps78sSNHIGztUQOEJm7J3+NWJJVbm4xo+Ad4cip+ALOXveMiMU2lwC2kJf/LE6P7CEUYbmWSPkDEjO8Iog69R1HaPJtBeKudjBkpRT79uPqx4oLQ8lsEr/mHT58FsqQVqsPXOBhnJthtn+ChwhFJQC/o823ku42TUGeNSSV/V233jhLAB5kylTQWHzyx6gHA0NSBAQj2CDHINK2/GBKBQdcItLcaDX71MtwTkh1ilxCGwj1FUMA9K34ibEoLd1dMylbbUMNvLxleHI57S468NgYHYohuCa3fCm3JXMlQZ5DWhIN1Jm1rfv+zA4p6kRMVxEjSIxNMoUu2PnwuDz7kQFztRfti+5/JJGN8NDWJH/rkQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.08.25 17:20, Vernon Yang wrote:
> On Thu, Aug 14, 2025 at 01:58:34PM +0200, David Hildenbrand wrote:
>> On 14.08.25 13:38, Vernon Yang wrote:
>>> Currently pagefaults on anonymous pages support mthp, and hardware
>>> features (such as arm64 contpte) can be used to store multiple ptes in
>>> one TLB entry, reducing the probability of TLB misses. However, when the
>>> process is forked and the cow is triggered again, the above optimization
>>> effect is lost, and only 4KB is requested once at a time.
>>>
>>> Therefore, make pagefault write-protect copy support mthp to maintain the
>>> optimization effect of TLB and improve the efficiency of cow pagefault.
>>>
>>> vm-scalability usemem shows a great improvement,
>>> test using: usemem -n 32 --prealloc --prefault 249062617
>>> (result unit is KB/s, bigger is better)
>>>
>>> |    size     | w/o patch | w/ patch  |  delta  |
>>> |-------------|-----------|-----------|---------|
>>> | baseline 4K | 723041.63 | 717643.21 | -0.75%  |
>>> | mthp 16K    | 732871.14 | 799513.18 | +9.09%  |
>>> | mthp 32K    | 746060.91 | 836261.83 | +12.09% |
>>> | mthp 64K    | 747333.18 | 855570.43 | +14.48% |
>>
>> You're missing two of the most important metrics: COW latency and memory
>> waste.
> 
> OK, I will add the above two test later.
> 
>>
>> Just imagine what happens if you have PMD-sized THP.
>>
>> I would suggest you explore why Redis used to recommend to disable THPs
>> (hint: tail latency due to COW of way-too-large chunks before we do what we
>> do today).
> 
> Thanks for the suggestion, I'm not very familiar with Redis indeed. Currently,
> this series supports small granularity sizes, such as 16KB, and I will also
> test redis-benchmark later to see the severity of tail latency.
> 
>>
>> So staring at usemem micro-benchmark results is a bit misleading.
>>
>> As discussed in the past, I would actually suggest to
>>
>> a) Let khugepaged deal with fixing this up later, keeping CoW path
>>     simpler and faster.
>> b) If we really really have to do this during fault time, limit it to
>>     some order (might even be have to be configurable).
> 
> This is a good way to add a similar shmem_enabled knob after if need.
> 
>>
>> I really think we should keep CoW latency low and instead let khugepaged fix
>> that up later. (Nico is working on mTHP collapse support)
>>
>> [are you handling having a mixture of PageAnonExclusive within a folio
>> properly? Only staring at R/O PTEs is usually insufficient to determine
>> whether you can COW or whether you must reuse].
> 
> There is no extra processing on PageAnonExclusive here, only judging by R/O PTEs,
> thank you for pointing it out, and I will look into how to properly handle
> this situation later.

Yes, but as I said: I much prefer to let khugepaged handle that. I am 
not convinced the complexity here is warranted.

Nico's patches should soon be in shape to collapse mthp. (see the list)

-- 
Cheers

David / dhildenb


