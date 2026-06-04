Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C12ECCD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 13:07:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5E0E6B0005; Thu,  4 Jun 2026 09:07:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0EA96B0088; Thu,  4 Jun 2026 09:07:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD6756B008A; Thu,  4 Jun 2026 09:07:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A80BD6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 09:07:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4AC56C2174
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 13:07:08 +0000 (UTC)
X-FDA: 84842255736.27.1A37E25
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5B92914002E
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 13:06:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nWHP6Js8;
	spf=pass (imf23.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780578416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x/V6RPepsyqoQUt2D3lkrhZmC+vMiyf2WaK9hrkxCm4=;
	b=walvQjXyTjiODNvX4cpDD4Qg4WRDgSt92Aw8QjE83FVU2x8wAqqsYdOplWHLVAn+KC19Mw
	E7lrRKVQpBNZpUCZSwXTqaSa+pC16KEptiNQXe9BHjw/B6PkzJbbYA9NCa0GBiz+GMl52K
	HZUR27VFiXUy0kuNSTnIP+XCFxkjxq0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780578416;
	b=PlIlagdqDTfKRsntsMSrRb+j0f/Xhlmmw08UCQ7d76nBZ0VRJaEpudG3qe4EKLTygatCyN
	4/sx1BOrHiOzU/Jr8bVmjIYSB1mJD2Om2ji9cyKgQWh75EoeLrBEcqyzzxwpdSVxV1RPvS
	ozqOTttSILjoYJZcUFCeOM8BlztuNN0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nWHP6Js8;
	spf=pass (imf23.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-36bba9a1089so450633a91.3
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 06:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780578415; x=1781183215; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x/V6RPepsyqoQUt2D3lkrhZmC+vMiyf2WaK9hrkxCm4=;
        b=nWHP6Js8JAJrX93hhoIyrHGPmL5rGOdme2ne3z9syyOLtEsRqMwXegEDsbSjC7WKp1
         vBm1H0O+pNNKZRf10H/+9aqFHqW6xLGh1iHcWCQymnzw2wuMG1AV2jFwjWyVWzB7hv5q
         ZbdpFIUVsZXdyq1A29OzF5+VwxrO7xkssjil6icLgD2qApcNVWf9XyvcS50++NGIHgiT
         8djMnOAMh5HzlkAIdGkGBjFAy+IWrJAqn029Izii65DYcS1UztpE2nuciDgdCfO4n2TD
         bbZpRHsE/UrGhLGWe8+LqqdaLWPzXh4zvcQAFJBDuQvU4r2vZC/50Ehiyy04oAqk2xuk
         L8+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780578415; x=1781183215;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x/V6RPepsyqoQUt2D3lkrhZmC+vMiyf2WaK9hrkxCm4=;
        b=U1lVpM7zKH4PyT03tFJuUuBI8Rap5whd+QkKlUO4lp0v0IbL1lcyNtqTSuAMYCov0G
         2C+YF2a2esql8mZFZ5Z6g36nJpxbrxOxs1yk5FHI3rY957keRupfESpBb2fq0dt99gqb
         blIBPEs08VzpOx69Tizlsnzz4jWY85rFlejYN21DS4gPWXfbKLvwuKVPas3fyRAXdQgj
         iC0yhddp1a3Mlx2AFNlp5/RSK/XQyv80hsngN0cjnBU3+LLP6lcXZmmpvIbgP2SWGi77
         /lAEUArcA5IXv+KljxccePmUs9rasGc3xwft+sSfdqeNAr6K9pblCReRIqCp+R7oV8x6
         54kQ==
X-Forwarded-Encrypted: i=1; AFNElJ8hT98oCkxuijYxDHjwbQomvBMR4hyqtGJS5EDi3hY+brBE+UF8QKv6Gc1fpYi0zIvpUKMsAEd4kw==@kvack.org
X-Gm-Message-State: AOJu0YwmOUOecKjfnAZdLk07wTbmWAJWUcU2GyxFRXcyVtsfgwk5WDrD
	Qer+HlI0p4yUY74Gk7hUG2Dkrmqw82NS5o6950GIHL4wEHKJM7qB4cWP
X-Gm-Gg: Acq92OFYj00jJagv1BuBxAY5Ud6Y9hy7DISZrhbcHJyHusN04HBmOusdrsyktsKTkQj
	OHk32RAsw27ba9UzstHjlgG3Hzew/Or1rGLpbfoW94pbvcMFWzWW1j9VjcWT4UvcXJCQ+DPjjoN
	7jMpbPwRtmbROhLDzyMA4zM59bdE4K8Cx4dQUp4GxR8ahxQNSas3yCApT4wbp3mMNkDFPkt0+gB
	UGmLqcVsUfwn7rHDDPDjFS61TGMXdE3EcTNTiywFW2rTnSeTLsCL5G1cJ88UI5qxS7FYJ/4T1of
	ZRoIQ+a5KGfH4vw0sVdwUgpHDiFKHE3fIzWuyWuUreHIbKm8nRyEzwjO2b7Qae1HgchcAfYej1p
	6nHGGgjOre03tbMsOMcE+r75VCpOhOpNnpSEG3V/uI7/mzVw6ZbmGPJOU+3kFnf7NFGKRMsM7Y0
	Sfq+xsYtkjSfkoVqkeplokVFlKMxYOu2zxl0Ou6ZWU49X0S6Its3kTNA==
X-Received: by 2002:a17:90b:2d8d:b0:36d:ae6a:22fe with SMTP id 98e67ed59e1d1-36e32288dc4mr8152975a91.16.1780578415000;
        Thu, 04 Jun 2026 06:06:55 -0700 (PDT)
Received: from [10.125.192.75] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6bf8284dsm3942710a91.4.2026.06.04.06.06.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 06:06:54 -0700 (PDT)
Message-ID: <a60eedb6-f3fd-4092-b726-04a17a695ace@gmail.com>
Date: Thu, 4 Jun 2026 21:06:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor
 per-memcg
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-2-jiahao.kernel@gmail.com>
 <aho7nepN5jZtKmef@google.com>
 <8c0e60e1-5713-69f0-a687-088c87e75764@gmail.com>
 <ah4ZZGl7GYJf54Wz@google.com>
 <ff344c9f-51da-8b3a-e7a9-c4a7f4702ef8@gmail.com>
 <ah9i3uhh3PFiS0Uk@google.com>
 <c7870fe2-3588-79db-cbfb-bd6a2b78f594@gmail.com>
 <aiBpibRNi0BcM1Zu@google.com>
 <9898f83d-fae9-e284-6b85-c7f4089840a0@gmail.com>
 <CAO9r8zPBH6-0SQ6-_ZOhTQeyu=rz4F=ugikCrU-JR_skm6fEWA@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAO9r8zPBH6-0SQ6-_ZOhTQeyu=rz4F=ugikCrU-JR_skm6fEWA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5B92914002E
X-Stat-Signature: yq4d1pikworwosy9xmn4dz6qakbx63hj
X-HE-Tag: 1780578416-848903
X-HE-Meta: U2FsdGVkX19WkKEvlF7e2uq3onpqvNmUvf3YR1utZvcWZr6s5nfQfJAog79dXYj3mdz4Rn4scZfKI62ZIpEaBsDSwScIw1oBzkZPnr9X23aoATUbG58FqcnB41m5CjtglISeM6oOcGUFRmdRVf8SyYxGBLFRTG+0xLPAy2VGv6TbN6QnCdgMbtZ0Qamw2C2ckSHMLaL+Y/ufzDrZlyoxlwZHY4MDn7FwN4VqIpohocY3feWeZDJ2S746VTBgV8+Ss0VWTNgPCenNwQJYO6duCYwkSOpZ0+rLG9hqRNxEBFmGrPv1m+QZz5Y0e2Y06euaIG97goDI7e4A+8l1oFDA5Mnf37h7BDMsB9/daWm/JE/QsJTGfXJtyDZzLSyIbeI7afDUOMXzDeD85U43ypTNMBXwbjtCatWiLoJ6yYz+zTV1Uz6nM3TrRsuXtbC5yw6biZC/PfzeMbi90e2RgnPVFUXqWTrxr6RYv1HzgJRCAYKTynFdBA8P8GZOaw7HfjAB2w/CmqHouzjUrxnjg5dKmycYvkG1pmaB+I8f4L5equEcLzqvj38LHLsp6Jo+Fccrkqy5PVtnf7talMCVmcZHs3iIm2kVz77B8fxwFuEDwY0Jr5KdNp00TbcyxhJHbfSigH/lJaxgdRjscwp7NevCRGjQgc35kj43hHDKQCoz2rvv0D0SDHg0qBEL0uHBEeWHyyVeqMh0nu7s9sTEQ5wGk2CIZTuxqITzSFKylxGJ9UvjYp8wF4M9yPEIpXJ+74S1i79dAEMHFptqDUOHF2CfSeO+hf5yyeFedhof5zBpQIeRzlQ6AFjbRhRXNKlnttkYzTKAvckZ7HAIESL6sJ6pudRxUkygsy82EpvUrlmSHwbtOeh37IKnPObsY8/7nez+y6F9dU3wCeaEgmCBhF8W7id8Sigpk5mZLlUEGPFWHbfjN+7F1TOEdlg6dwsTrzc/i/z0X0E9Jkwu/2/p5Kl
 I6Rkry7o
 a/+l3qSnb+1kaWI1c3yhcy4ZYYDQtoYHFZ+B0N/iXCB3WXjrZMxFh1bU0ceqy7Rh8S8dliVn2+4MhovDOikoQxD7IvDin0+7f1mvE1XKvozqYyLvT2Ki3burCvmg/sFo8YlHPNbVVQdSrkFBEpuARGtAK+Ht0/lmuD2c041TrlwRFV0aOW1BiUDonJ8KXGXmvyTIkn+QWqSbG5+2sRAHwLnka7MofixNXvm31VrCYgsOTIgP9bHweeEGiE4AypVzhEZ3lMl4lgoY6xbWW0ayKYw3iXEE5lnbLgmY0UqtWoZD9av1Iu3gkso7gjm9NKsQnOvnugEnn7JLBV6kLMF6w2xQUxWKdjZ96ZshypgoGE/ocq+VCwgf7RAjTSdLdUC1mvRD4ZXWn8i9avp4TyrPb24izidypeDZ1FNjmllxiK/S5Du9JYlOqKAAJA1nuktBQUNJY4KwC7LR+QPyO1o2rbA85ib+0yBLMLZrSfRb5yOeqO3oWGLgbG4KtBOepdJ7CpgsT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/4 13:34, Yosry Ahmed wrote:
>>>> For instance, suppose a parent memcg has two children, memcg1 and memcg2,
>>>> each with 200MB of zswap (100MB inactive). Triggering proactive writeback on
>>>> the parent memcg will exhaust memcg1's inactive zswap pages. After that,
>>>> even though memcg2 still has plenty of inactive zswap pages, it will
>>>> continue to write back memcg1's active zswap pages. Writing back active
>>>> zswap pages causes the user-space agent to prematurely abort the writeback
>>>> because it detects that certain memcg metrics have exceeded predefined
>>>> thresholds.
>>>
>>> This will only happen if the reclaim size is smaller than the batch
>>> size, right? Otherwise the kernel should reclaim more or less equally
>>> from both memcgs?
>>>
>>
>> I gave it some thought. Not using a cursor could lead to unfairness
>> issues with certain writeback sizes:
>>
>>    - If the writeback size is an odd multiple of WB_BATCH (e.g.,
>> triggering a writeback of 3 * WB_BATCH), with 2 child cgroups, the
>> writeback ratio might end up being 2:1.
>>    - If a memcg has 5 child cgroups and a writeback of 2 * WB_BATCH is
>> triggered, it might repeatedly write back from only the first 2 child
>> cgroups.
>>
>> Although setting a smaller WB_BATCH might mitigate this unfairness, it
>> could hurt writeback efficiency. Let's just use per-memcg cursors to
>> completely fix these corner cases.
> 
> Exactly, the batch size should be small enough that any unfairness is
> not a problem. I would honestly just do batching without a per-memcg
> cursor, unless we have numbers to prove that the efficiency is
> affected when we use a small batch size. Let's only introduce
> complexity when needed please.


If you prefer not to use per-cgroup cursors, do we still need to keep 
the global cursor (i.e., the root cgroup's cursor) zswap_next_shrink?
I found this part to be quite tricky when trying to reuse the main logic 
of shrink_worker() in zswap_proactive_writeback().

Of course, I think we could also keep zswap_next_shrink and write a 
small helper to check if it's the root cgroup, allowing us to use 
different memcg iteration methods.


Thanks，
Hao

