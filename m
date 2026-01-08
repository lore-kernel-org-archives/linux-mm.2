Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA821CF6A88
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 09:14:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D61516B0092; Thu,  8 Jan 2026 04:14:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0F0D6B0093; Thu,  8 Jan 2026 04:14:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE2B26B0095; Thu,  8 Jan 2026 04:14:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A89336B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 04:14:35 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B5F08C0F5
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 09:14:35 +0000 (UTC)
X-FDA: 84308236110.22.C6496F1
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1895440007
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 09:14:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="EU/Wnth7";
	spf=pass (imf12.hostedemail.com: domain of konradybcio@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=konradybcio@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767863673; a=rsa-sha256;
	cv=none;
	b=IB2MtS2z2dfp+D3H6/BGbPIKF8NobAGNVZbnX++FzH6YYb9i0safDQBqkTGmTJyVmdnI6T
	zuszl+fGgJDwCNgfl5kbIqXLKlN9dPGpkv3tZaXNRO7qsspMxRVftG5cKAGTU10x8MhsMO
	SzYAWj364YdeHkKihh6Si5BBmZqCDiw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="EU/Wnth7";
	spf=pass (imf12.hostedemail.com: domain of konradybcio@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=konradybcio@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767863673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TvT6iham5Ww2/L84OBKgeQ/5bsD2mDpDZmqVTbCTOc0=;
	b=IEj9CJegqxODd6NI3Go1tlI7vxpQF1bgrT4I0J8Mi9Gs+PkY2eF4DDRK3/6GH+tVWMd+dv
	7UTbxDqI7zWCr5yvj+IkYIgXS0vvRPu0dDKxyJVaXfKbZNY8cMAesHybDWXvCMDBcb7/cJ
	+c7o+UmD1dHlag42kqOXbym6hKF9/ss=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-64c893f3a94so2671278a12.0
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 01:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767863671; x=1768468471; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TvT6iham5Ww2/L84OBKgeQ/5bsD2mDpDZmqVTbCTOc0=;
        b=EU/Wnth74MUETjme19LiNeeFHaCkd6WG9q8ZaeVEvYT+/kzmmnS2gmDdruJfQ1GcEB
         ur45K1h2etZMr8ju08L8KyicB7hrlZB/toe2MWtNKWjzaU+sUAnSXC53pWVZpaLNk74N
         Bh1dEnFeaQaFjUh74XdNoNDH97UvMd8Owm+GUdXJtM9JzsxyfxoLh7ocO9RE2vKcZh7Y
         7WkLVD6mABqow9eIE0MexctgZoqaS21GHqXgnRo1SpXc5gstaAfGs/aP6W0TzkPfyqQ7
         C4UkiU9ejcKAfxgVwRjX2ekC3o/43oLT9MWxPZA4AAC5BBVuCH54wqujbrRIeIAam8JL
         Ml/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767863671; x=1768468471;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TvT6iham5Ww2/L84OBKgeQ/5bsD2mDpDZmqVTbCTOc0=;
        b=hY2aMoROcsuv7OCv7VJ4WL5EnKRlLtKpKXq9poGY/lpDoHSEv2cuDEYdsqg33uH4zN
         1aCA3ngQz/MXlSMZtzc+hhcELku1UrTVzLkDBxy37CW0gF/V/OL8ED9lN7evKmMStZr1
         5O1pHEaceXIA40E8uw2RKRy0iUV9/aB2L6d51mYLHI4qX1LZoeOQ64frsQX7Aqda7uGW
         z/XlHB9dTr8JOkplXEQ5lab7DR6MwhgKjDzMH66qWkwVPN105QX9tTW2Lx4TJUUMAgLD
         JVTl7gOM8ajwjuyltGKP4LwraqdcjIU8uQHaMpFw18fyiwE1VHrbNGQ1wDHPg7JNatgh
         f1qQ==
X-Forwarded-Encrypted: i=1; AJvYcCXh2JL8LRzFUVs2EbWEtnQsUrNHSsrS+m+z24++qytCD6kLbvsjofsIoH1kxROnL5+os89Oc5PCmg==@kvack.org
X-Gm-Message-State: AOJu0YwSANAPv/2kL2EOiai9VYMJ2a4GNhk3c7QuYpO3y/e5CnPVVFKT
	Ip5+qkG3Zj0SZhxUvIq/YxYrF5VPWJlWHHq6aEgOKLkAtBm7wnGw5sf3
X-Gm-Gg: AY/fxX6qgYDHbbAiDtV+bETse2fqaZsAT49v3Qfkc9q2vM4rVZ0fpcqG2iByoi6hHgn
	7drb0fdrdJ4BPw94tYBM2OdYFH6Xxv2mj6mGoLjq1TAOou03k9eynKtYNBd8kMIutIt/8TXXfde
	2ZduKTJem28QAEEJY0FlxY+Ji0KYtO+OY+TR0qQDK8Ltxqsgl/WeDwhdNxjV316oevENiCeIsuP
	rRdDPEPR6dY2Gt38lK6dgD1zH/ttkbQrUiEfx63LNMKyh/IWeRHgwbx1QALIDjJjzggwd/jfxs5
	NbFBga5JC9wvAqBEEWFV6EKGFayALz8OX5s5DoKQKczY6Nyzh59jutDfJoX4MdT2DX/OBdfZ06Q
	DHIgzU0q6DiukqhU8zKYZgI0REvDHCSaT1Qj7E0R09Fm8LzJ6sxvdV3flCpndJCOhi0396WO03x
	yauJ/3JlCFq5NQIs5kngyS5PLu3yXwbSJ65IfAnug8Em/V9We4oKO7TF+s
X-Google-Smtp-Source: AGHT+IE5MxZ48wZVCbAJv0tXqges6F+BClCxqoh/5Ucc6OW9J6EO7DAwQFoEFR5x72E9cV+XRrv+ww==
X-Received: by 2002:a17:907:3e1a:b0:b76:b928:eba1 with SMTP id a640c23a62f3a-b8444c59b86mr531643666b.7.1767863671000;
        Thu, 08 Jan 2026 01:14:31 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a27c8f3sm754691366b.16.2026.01.08.01.14.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jan 2026 01:14:30 -0800 (PST)
Message-ID: <acf3ae82-2cf3-4c85-bbb9-bbcbe2b7be3c@gmail.com>
Date: Thu, 8 Jan 2026 10:14:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 mm-new 0/6] mm: hugetlb: allocate frozen gigantic folio
To: Zi Yan <ziy@nvidia.com>, Mark Brown <broonie@kernel.org>,
 Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>
References: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
 <4211be25-3fc0-4395-9b24-a5ff0b3caa34@tuxon.dev>
 <13ad5888-2d53-40c8-9269-22bc6001754a@sirena.org.uk>
 <7253A444-97D1-4256-9AD9-BCFF66437510@nvidia.com>
Content-Language: en-US
From: Konrad Dybcio <konradybcio@gmail.com>
In-Reply-To: <7253A444-97D1-4256-9AD9-BCFF66437510@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1895440007
X-Rspamd-Server: rspam04
X-Stat-Signature: 47eyr64ithggf6ewgcsigtnhwatgdwnh
X-HE-Tag: 1767863672-818618
X-HE-Meta: U2FsdGVkX1/Y6W+GA2A+7uMlK6NgCqov1r+SLEv1KLu1Nzum3J1tBNirSoh52p8sm2DXpxvsNaczYDD/ahmU5sh8Qz6nLt8P4KlIQvK/BE65fmUGgdNpgZibIFnxMBwzhqGP+nryd1+0JWYPyEBMxYPFkGxDlqX4WzRV4pys7TAUaPotFH8EngXQd4LIaEFhrZm6RNw12vri7oYZ4S/c8tIyaV5UGv9yf1A/J2hHX6IH1kYBEFccFuY3nUhlrsANEEa97FE+grtPK38O/Rh8bYaRy+C/8kO1ert+HNiL34WWZWLXeo6sYgY3lBHxDTGnLujURUcb2QeV83RGF+XnukFN9ccBNG0uRIQNX5WB+rFD/cZkzbyUiIX+3z7tpiZoyP52v1Y/sAqiZBNchjHMbiDrS8IsCSwIMoI2QzG1CZ/gzdxpV51wXyV7/Di+qRLB5azljiMShBUca5dOiFOfgI2A/qm5nThbBh5E1UXvM8qtfknRWINKP64I8UyDZPBSu9vUbZkx6JG3ypXEikzgT4gjaleQ3AFY6+5Nvcq4xD1sG4v+zj2Q8d/LdYA4sBW44yQu2eYvC0XlSdBF57YkSQDPK8bjmRHTGnjgb+/9TurNtHDXOfbFAbXNxHtd1YW6xPJ0o0c4SEBVs3hFT+ykzR/Qf5e1Z4VsiziKudl3a/nNFI1eJZkSZ6ZabcAMCWQBGQpKGuxP9eOoyeUvOByvyO32R7L7i9K4+6xdNdrcl0JCugptN+lPq34Y5d0Kt/3unTPqKqU8+IC7gO+an67p2cX4jw+m8N9VYTnubJzmYXutZ3qOdbC3F2Fdj9HI/7gaZsgdmD8BnHlWt2HtMfgIORh1aifyRotC5Js8Lipn0LSqjBDj1jSoadiT5xjNAoAIkwInt90l6YDS85lzXSYZVwjnUbz2GeFUeqY0uBXY2tLxy3tbDigwfsKLg6jKT/EwOaznu4pXsiP5kZmPhk7
 sLc5X+9+
 MJl4rQ3kicGfTIgNbveZLGv2GWQXdQUD/am7dqzCh6dPY5fH3P8IfOrsxaGT03Cgsnp8/NWXBCCnury9PJKvwYS1y7f6IF0LmnQ4piJy9kGiUkpyQseyL/vobV075uaEon+imi6f62dYzOJuEX0tXiBXDRpT/PX4IinRU5AzYGVGWyFLsWN07rgXwYcEojc/CZht1wXXi7yH7FhjXM1J9rieMQzcFrbvJVgkiCFoiJ1tKGIn4Eh6dLVU4f5Krg1YrfSFIy2TOBSELzGeGAC7Jt1kkGyW9MovKFsU+1EDafccAYFPPpzB1L/x7wz3N66/saXXaQ1uX9RYXzSGmxd6PhQyxEunq1sEraTyhmsUMXtlzoZIE8N/gknMJYOBWAfcEoCcx1wrpvTMqbLgj33jxTi1rzmJFLt5qMCK0PWd1VznAV2gsY+SRNP5b81J+E3wXd1n8uFBTcFpM2wY+CQaj9GJLIGfb2/U02zREctyPUYcvwLNs9jMR1scptkssGFSx+4BrtR7Xs6xa21XUrFZ8wC3fWT76Y5LJ9WwwvYIWMuo7nVo3hdb7OjsUNoA8cugjDceNkQLNlBCDDi0otCU9bzSWluUUxtunPXSbzoUV7onqGTBHCce45dzMHKqAACcXEqsk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/7/26 8:38 PM, Zi Yan wrote:
> On 7 Jan 2026, at 13:39, Mark Brown wrote:
> 
>> On Wed, Jan 07, 2026 at 07:31:30PM +0200, Claudiu Beznea wrote:
>>> On 12/30/25 09:24, Kefeng Wang wrote:
>>
>>>> Introduce alloc_contig_frozen_pages() and cma_alloc_frozen_compound()
>>>> which avoid atomic operation about page refcount, and then convert to
>>>> allocate frozen gigantic folio by the new helpers in hugetlb to cleanup
>>>> the alloc_gigantic_folio().
>>>
>>> I'm seeing the following issues on the Renesas RZ/G3S SoC when doing suspend
>>> to idle:
>>>
>>> [  129.636729] Unable to handle kernel paging request at virtual address
>>> dead000000000108
>>> [  129.644674] Mem abort info:
>>> [  129.647456]   ESR = 0x0000000096000044
>>
>> This is also introducing OOMs when doing at least audio tests (I don't
>> think these are super relevant) on Raspberry Pi 3B+ running NFS root
>> (probably more relevant):
>>
>> [   64.064256] Unable to handle kernel paging request at virtual address fffffdffc1000000
>>
>> ...
>>
>> [   64.087583] Call trace:
>> [   64.087586]  kmem_cache_free+0x88/0x434 (P)
>> [   64.087598]  skb_free_head+0x9c/0xb8
>> [   64.087608]  skb_release_data+0x120/0x174
>> [   64.087615]  __kfree_skb+0x2c/0x44
>> [   64.087622]  tcp_data_queue+0x948/0xe50
>>
>> Full log:
>>
>>   https://lava.sirena.org.uk/scheduler/job/2341856#L1721
>>
>> Bisection identifies:
>>
>> [fb9a328d30400dbc8b2ea5a57daeb28bedac398b] mm: cma: add cma_alloc_frozen{_compound}()
>>
>> as being the comit that introduces the issue.  Bisect log with links to
>> further test runs:
> 
> Hi Mark and Claudiu,
> 
> Can you try the patch below to see if it fixes the issue? Basically,
> in cma_release(), count was used to drop page ref and decreased to 0,
> but after the loop, count becomes -1 and __cma_release_frozen()
> is releasing unnecessary pages.
> 
> Thanks.
> 
> 
> From ece23da65ea7210e1fcb51ee9c27aec19b84811c Mon Sep 17 00:00:00 2001
> From: Zi Yan <ziy@nvidia.com>
> Date: Wed, 7 Jan 2026 14:23:15 -0500
> Subject: [PATCH] mm/cma: fix cma_release by not decreasing count to 0.
> Content-Type: text/plain; charset="utf-8"
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

This also fixes booting on a number of Qualcomm platforms

Tested-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad

