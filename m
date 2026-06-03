Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF5CDCD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 11:30:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 370606B0095; Wed,  3 Jun 2026 07:30:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3481D6B0096; Wed,  3 Jun 2026 07:30:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25ECC6B0098; Wed,  3 Jun 2026 07:30:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 14A6E6B0095
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:30:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BC727402F6
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:30:13 +0000 (UTC)
X-FDA: 84838382706.01.3FD6E33
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id CA7D7100014
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:30:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aD2qrV62;
	spf=pass (imf05.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780486211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QbLgrUUeNFGNskm0gEJ8DV84HGEbh6GoBjogs08lHeE=;
	b=EGo0emUS21BxIrbBCRzZhIWK4cgy3u3SKDKdhPLtzSjGRE40q30FSBykOpjg5yf4R1Ob+n
	wiD9x/2VbUPIB7xlhd0YAcF1ciK1yJAPECpb7aW2kzEkg70t66XF3kassEBDGGTa0+t5+D
	Qw5A6bdnux0Btj4yd9T4zVntdYGLYOI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aD2qrV62;
	spf=pass (imf05.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780486211;
	b=hxrh+HtsADtFGu8MuyKeKXGfVzo39+Z4eqn5BA0M0m983Nz7r0VcdUdXrYz8zKhPn16k8z
	g7tIUnx1TGnPJQyOAW5iSKFsWV6a6KALnenri8woyuHztcMVTszGcL6eVh2xGKm9bFPs0T
	WJaB4kmo7GaG/ZwkWmLEAM6vxptpVu8=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-36bcf3d2565so3229517a91.3
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 04:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780486211; x=1781091011; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QbLgrUUeNFGNskm0gEJ8DV84HGEbh6GoBjogs08lHeE=;
        b=aD2qrV625K0cMpNEb4/3iimBuVEf71bbxUsqia8HVvou/OpTRQ9D4LSQjxuw/eb1Fk
         +ckgK8bkbFQNbP4dN3vMqq1+vBKW8TLOeUa+i4IqNkSYfh94iImb9SP1YKtg8NIuZ6Up
         sHfWpsG/L53cN6es1iyx7uHj7EdfxD3WJ6YqgjiFV0jouG7YR/4GtRLiHfUiSbi6ITfA
         YqnVZU869vip5080qqm6OtkGUz5lO42pAOLmhZnLx575hUEzS4/za2HAJi25o8XE9Nt6
         huEhFvOTsXOdYG6c7LoJKBRxBYVEg7tDTCBCpMn4MrN8c4NxxDBbbtbJGvJf5+dok3Bm
         u80A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780486211; x=1781091011;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QbLgrUUeNFGNskm0gEJ8DV84HGEbh6GoBjogs08lHeE=;
        b=S46QRZi+7zw5552fALscsgLfzGu/k2Y/H9u8AXiVnlDBW65UKmKInpPlO2dCTZ6Glg
         C4EvIq1fW/7M7zuZdCvL4O/IerYHwZCG74m2AUKmq4b8CGqhQSCIFKvzaBCLBj2HKTT1
         H0A6e2wz5bpV0sLBzAToZ6zZlQRMoEdPJC1840zA+7WVwtOGW5TO0e9EZgjEZ50airMD
         EJk/m6AZPYwOr2S2WlNR05hn2hDyzjiz9ASHilLvcDBO5m3IGDEsntL19E7y8TyJuKcM
         qZ/nMauZgRwtideJxzh0+AD+GJjYhS80nkUMQG0ZotzoDLC0z83Yg7yZb3uTkHQMeL5k
         h2oQ==
X-Forwarded-Encrypted: i=1; AFNElJ+M9WUBa98d1Ncp2uo/kd5kTQdmkMkS1pr5hqp0DpFvRSO1xJz6Pw/9kVffooRE/ylWDi8+nMjkeA==@kvack.org
X-Gm-Message-State: AOJu0Yw36iV1htZG3UM9JQjJyKaTbdi9hrfyPJjrEetkclOM37HVv1zH
	BjemyE4UqyW2yjtEtBysx9G2yT7JW9UiqGGTxjurMR5jQUaJEDJ7FzwT
X-Gm-Gg: Acq92OH3HU3vDRuND2KpS3sJnVZ0ZI/RLJ4IEygaAlngIfcLWvz1afQTLSmMwnUKmPN
	5J9L2NIccQISSZX0e1INK7Z7OKsZd8z9WZQAmjBLXCkhum9DokVEdz2fRY2N/5ySfA0C3gMAIoo
	4wxK3xcYHyz2i9CVU8vUntn8E1MjF3tfjszRN5Ejqs0hGE0GwfTuhRAerhvOUCsqYoqEAcp4vZu
	vUi5AktPtA0s5lFbKLY0dLclohWm/kSUV+VhZz90HOO75A7fWNgW7srDKVEqE8+OtUgHgC7AVK4
	Dgu6uoQ59Rv8+xaYHGSo9zszmK6kDzGwuh+jeeLkqDz5CMLdynQOgmjKyJqjtgfLTYXV3et61J8
	k1RyvuKRZnmXGeXaDkj4ar7beQw7xtRk6U0+UGgHsK7Rnt/YCvNm+M2Ghcc5LCbe1hr4/czehRs
	DqEcAQt/Dg+OK00PEgDQl4tM82toQUAMiyVjP67ldSQhbYCCb9eDl+zcNRBcpcz5GS
X-Received: by 2002:a17:90b:2d8d:b0:36b:e8b9:46a4 with SMTP id 98e67ed59e1d1-36e32285cf3mr3042276a91.14.1780486210499;
        Wed, 03 Jun 2026 04:30:10 -0700 (PDT)
Received: from [10.125.192.75] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36dd91820f3sm5910449a91.2.2026.06.03.04.29.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 04:30:10 -0700 (PDT)
Message-ID: <e2ddd20e-f092-4559-5d1f-d5c1130d2538@gmail.com>
Date: Wed, 3 Jun 2026 19:29:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v3 3/4] mm/zswap: Add per-memcg stat for proactive
 writeback
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, yosry@kernel.org,
 mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-4-jiahao.kernel@gmail.com>
 <CAKEwX=PcFqmsdFqUnpWxrPkoc1B-1w3CEb0ydK3df0qJGG-mnQ@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAKEwX=PcFqmsdFqUnpWxrPkoc1B-1w3CEb0ydK3df0qJGG-mnQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CA7D7100014
X-Stat-Signature: iym4thj64d3oyc8pfs6kngz5gkbf77ok
X-Rspam-User: 
X-HE-Tag: 1780486211-104007
X-HE-Meta: U2FsdGVkX19w8wviAPbAcfdd/qNAA878kotVbJI1T1sfj55jUsTyhogjp2182HezIViejTst4VVJqR+GsT22mTeUwihtYtlqgYJuQXUFzZpLH2xVcyDOtkfpEZcPTeyQmvOi9ah2n9Te97ihpiJP9lJAF9YS7kJ/TbY0pTw54yL45nNiqyoyrOTYroz0wyNEhbNygSjdtQFLwGQAyNjO/u3JJNxN8OI94Hxh789mn4ZVIVSmmz8rDbbV3HTO0b//r7aS7Zgcac0LPxEe0W85iTeUNnhLC3PmOAUMlCTggIg6EqVEgAzmifl9/v/lm7y+z4Dhx4iMG6+OJHLO7376+e2efG1utlv/VHAQv0UjEWiQ8anC/XoVRn7/kLGava6qt8/Y0pinhFPoW/8XqJ+Qjg1Fiqlh8On8z7K93B1nVlOSOfQ8zUkgg9E9omLc6cse6cVTdeawCNBSnF5tLQJGOIqnN9LIb6gO1p/fm+3lmnvwyJDZ2rsud1X5wl+sfPrSJP557WwcGOwE3m0jcXWeJj02Ga1lDbutn2lUxNuFFJFSBaRoMJbNWedILJtOEJS0bXDbi1p/o1xp1Q6E2+Q96Gyw6pG6TG16xGmfJjGaTqJwlJNAI2Stb9/eR1DrfVHpbhz5z26djuyDtLH4dd/62qNk46Wmb/8pB+f2E1IVMiGi1KVmXcN+ceTBRaRr5a2P/Ns9ii6Di01dhnge3tCI3j0WxaKvkZ+auAsE7TALgIK9KbTEs1Kq13E25IDt/jJUk4EDs+iHmT84KwBLMi5/hYgzLxgMRpuEYiFA3RQrQsdWrOR98PgLOTuf4+yKKcS4A/UiQxEtKFQS4ayMGC5Ee9YcK9Vont97jJmamwcj4h0sUerqy4VfWsSFh3VY4JSqEt6qcNpE3WiSlclr5nePhQRK0jvIwhtFgV8NuIEO4CANeiB5n1zLMogXMCqLZUe2/Xbdf4DYf9PTg/TGDyh
 jLFFODPm
 NMC5o624cfr12WYm2ZrDFz5sJcHkkjb+GYOL/Fmt4eE7xuS7ohxWjv2LStX6RApGeD2pPXlnMW/rrqxs5S49x+4YXx5sscXTHljmWlTgFlymje3L/+J1ozr5+TBGbwAY+X4nmBSxRL6430sf3GoWTIoStP5rrG6VX8qZFqcHkLP87CIqabLIP7qsOB7c5nDgLCL+FEkraqpK7VSVneBgCJJdzGcknEAsmYFmJxpy2AARykvJKkms/YM32uz7fIoJukG8mYaen+IOvxVGfEA8odPZaoRsBIswng/UveFbfx7RDTujZ1gFtNNzKxm8U1yCpp8WkOGVAoyt/XZs5g/IBFlAxKu32OoXod8tTQdN+ra6N9r60EyZjUupY4DDGgDXC+xSnfaJfI2AHRQBv99odiDQ0vYNudgUA6dezJadjTKVGH+NJdYj+k/72laQzPxbjR2yB0YrQz3qR4x8vuy2MxZh1YULzJQpTbeZF9IGWJHwux1FZYwjGIymhO/XjWNxR/G/WKkSYBFpMPYk0yKv7wRBydoBv6FYG8AhoQt2KEjSgRRk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/5/30 04:01, Nhat Pham wrote:
> On Tue, May 26, 2026 at 4:46 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
>>
>> From: Hao Jia <jiahao1@lixiang.com>
>>
>> Currently, zswap writeback can be triggered by either the pool limit
>> being hit or by the proactive writeback mechanism. However, the
>> existing 'zswpwb' metric in memory.stat and /proc/vmstat counts all
>> written back pages, making it difficult to distinguish between pages
>> written back due to the pool limit and those written back proactively.
>>
>> Add a new statistic 'zswpwb_proactive' to memory.stat and /proc/vmstat.
>> This counter tracks the number of pages written back due to proactive
>> writeback. This allows users to better monitor and tune the proactive
>> writeback mechanism.
>>
>> Signed-off-by: Hao Jia <jiahao1@lixiang.com>
>> ---
>>   Documentation/admin-guide/cgroup-v2.rst |  4 +++
>>   include/linux/vm_event_item.h           |  1 +
>>   mm/memcontrol.c                         |  1 +
>>   mm/vmstat.c                             |  1 +
>>   mm/zswap.c                              | 41 ++++++++++++++++++-------
>>   5 files changed, 37 insertions(+), 11 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
>> index 6564abf0dec5..7d65aef83f7b 100644
>> --- a/Documentation/admin-guide/cgroup-v2.rst
>> +++ b/Documentation/admin-guide/cgroup-v2.rst
>> @@ -1748,6 +1748,10 @@ The following nested keys are defined.
>>            zswpwb
>>                  Number of pages written from zswap to swap.
>>
>> +         zswpwb_proactive
>> +               Number of pages written from zswap to swap by proactive
>> +               writeback. This is a subset of zswpwb.
>> +
> 
> nit: I think this is specifically the zswap_writeback_only mode right?
> 
> Technically, normal proactive reclaim (memory.reclaim) can also hit zswap :)
> 
> Maybe some clarification here?

Thanks for the review. I will clarify this further in the next version.

Thanks,
Hao

