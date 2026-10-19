Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52C6ECCF2D3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 08:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2FA46B00C5; Mon, 19 Oct 2026 04:20:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0DCE6B00CD; Mon, 19 Oct 2026 04:20:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1CA56B00CE; Mon, 19 Oct 2026 04:20:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA3026B00C5
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:20:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D5E8280659
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:20:26 +0000 (UTC)
X-FDA: 85338678852.26.8BCFF53
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id EF4E7C0004
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:20:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RwoCg+St;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792398024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dETs3b2ome9uziZhue1inxGS0jrP6uSNFUFfPPGZ4os=;
	b=vt+4DpmScTc6COBabMz2UDsdFOoO8kuI3LbXh6RhUPIswfUsP/4wCq2C6V6sEGXD0Ao/1c
	A0GW0MIIrYFwwmTqG+T4AkfFuOckoldPwnfYSgfm42TFlcac36m1c2gZE9uARLJ+XYfyt9
	GLCFvjB3m4hCZ03rOTCU+VhQIgqz3Zo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RwoCg+St;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792398024;
	b=UH6Vrep3XdL/VcCxpRExdkBo42/pTljio73b7y5DxxFWp3vAIxbxcSb5aHh1UH3mhihQRv
	Ab+ZDdkab2gkewdWgFj5QnoelHuTasG57eO6lGgK1ymhvwvr2dfzNYV/BAVsnO8BJO+VVg
	tJxKcbRr+FGG2A6Rey3jjOojVSjt4K8=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a0286c981dso19404795e9.2
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792398023; x=1793002823; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dETs3b2ome9uziZhue1inxGS0jrP6uSNFUFfPPGZ4os=;
        b=RwoCg+StkYJj8iCjuU0Wls89uwnaI07TQ9t+XCvev1gueWm2ctNJC88ewb9EnUGv0a
         gocp1TfFvMEuYvM4adKRzJuGMI2JEgNeiV94v+uDvum+6TGmeDMroxQsDkYrMBgREdUL
         9i0TApkm/eSzbj41ogztywEKj/a295XhuRVhoe3DCCbrggbqfeE80P4mqQB1ci0wNMEw
         iDoUGZxqjkEf97VLa5xMKvNUrUCXFuCXSLSWSYdes9iXqXLo+DXEpijXg9A21urQO71H
         hhB0Ifc1Q9ilfXUn0Hyx7/MJM9TWbGxQOb4zcHaFAWRMD/A05EOYIxuRR0RVwcj8vDzf
         VQZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792398023; x=1793002823;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dETs3b2ome9uziZhue1inxGS0jrP6uSNFUFfPPGZ4os=;
        b=dmbkLhu1jYFrRU7gEii6RNk5wiTtKnmN2NICozmlJ2NunUarkDdmME9aXA5t51Mj/l
         NI9h/KQgpCcS6gmo7hvSww41/rvk/WN6LlHT1iNwow163SbUdRjw+XCpgmB4dMwxa4/n
         +ybyn1S6Iq785NwgJoEinMVKX6kK3htRTjT9Ypg5l72GPn1EYiAKO34w/yjDRZ28t1tY
         8lZ+PP6LZO3Pr2yVNB8YOsOyKI2JL2u6O996BVblcXN9UmRZYQgXwTkrgMlLa9Ym8ujw
         ASytRkZ723T4bQkXEjFwmeeQeKX7CHzRPcOIbWmBulKiPnimJG8LHN2LpRRS9GyafuhB
         G20g==
X-Forwarded-Encrypted: i=1; AKwUvBxzKtSiNVqWcFljGtkbCw4EO9oOD4GZLdQEobqn4z/ye19fTiEgJRVnnC2RqT6wYz6gRRhdk0jqYw==@kvack.org
X-Gm-Message-State: AFq9FYLTQQClEmMhNjo/JnIaKhb7QzgMn4Zr0u0slP2d0Yom7oINeEpk
	BTaTgUs9Jc7Zp4OjUHAaNQDtqtvo75wCb80jk+B2Cj0MAEZtnsOYCLop
X-Gm-Gg: AYBFou1Zk8JVqU/SDpZE5yiTYYR114c3KWYDJp5/bIIEwFw5AnUa1WyZ+ESTKHW2e+J
	LJuaPr9l4P8nQCHZhQbuB7Bup3FrdD16fDZQSwgiWZ5XbPt9523alSEAWckQ8+ReuQ3adzLj5EY
	R3CuEI+75m/iicl+PqkleirqpJCc9ZE9jgErSW+BfOVXOpEbb43AIIOU8vDuVbIFGCVkWq1ljDh
	hH7263Z5pVydilQxGbUgTVnDWnL59WLRqjG9Qtbh0B9kwmCHqbnT8Es2G2Zs2dgKA3AGSfFJuno
	K0UFu8wuWeSvZ5OjHOvt0qbB3f1XLgIs1P+Rkq2+S4TRxYW0pHWsMjiwLVS0p9If9IAMDOj5Vz6
	MGmKXrX7R+l+BxtWv9Q+id0dyeasYMQFqiJtLxXRBYXgZQIbdSMwLSoLCEVb5MAZmXS0hpray2q
	2P76+4YNut8NDspPVqLjueq2hVyS5F2WtyAjDm62jEunsbYG2OCeLWw4/Gk7+jTTUa0FE=
X-Received: by 2002:a05:600c:8b22:b0:4a1:8627:aec7 with SMTP id 5b1f17b1804b1-4a1d75e6fe3mr151926975e9.5.1792398023183;
        Mon, 19 Oct 2026 01:20:23 -0700 (PDT)
Received: from [192.168.1.18] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd9b8ebdsm385910145e9.10.2026.10.19.01.20.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2026 01:20:22 -0700 (PDT)
Message-ID: <988249c7-abf0-4f4f-9386-27e835a4d2de@gmail.com>
Date: Mon, 19 Oct 2026 10:20:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] mm: hugetlb: add CMA support for PMD-sized page
To: Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Qi Zheng <qi.zheng@linux.dev>, osalvador@suse.de, david@kernel.org,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1792136742.git.zhengqi.arch@bytedance.com>
 <FA455F0C-0A46-4B5B-AB50-E9968001D2C9@linux.dev>
 <4a7ad39d-fee6-4390-beff-d40ecf49cbdc@bytedance.com>
 <BEADD50D-94AA-4B05-B9AD-136E37247FDD@linux.dev>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <BEADD50D-94AA-4B05-B9AD-136E37247FDD@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EF4E7C0004
X-Stat-Signature: q9sxuxgkdxsonep56g8fzqpgtayeyepd
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1792398024-415210
X-HE-Meta: U2FsdGVkX19tmm90zfR91po6sHiPqkTL2p36+8H0IOQJniYnq7X9ZTWNXSDIQcUXMCCZ8gatwA8aIyNNVUx9Ycu3pWMW/PYyo/0fp85bjbPpHGORbrFcOBzDnzLRd2ia8EN0E5R+TPMrwXD+t6LDOi/XeiYPXIIiQ7N8XZjaXjZbnFgVI/xM1exgcCodg7LKOtrIyl+3HAjK0Fe24S3qZ1SncUyCDI6M3es5bwZVVWMeshxy4tbmfAFCUXjUpvGn8nBN/QRFUZonHMQ8sXUQqcnWCMxCd2C3qKL3JpZUv4panMj2k7yf6Cs7SaVkGr2VR8sG6SvfzgKA8nBdvBXKlk/EJnzahiiD0dLQJ/IkauKkTh3v6lArtcOsT47wNm7HaaAa/u5LZNDnSBhOoXSe1VaUqEJcaYIgZol1a/i1fKwVexmVyOSLMkZy7BTJF9z/lh3k3MzK3yrQBWwbouEjU6WmbjRMfbfnHyigDPZP7Ri04VIHYLi+yuJtEUKmDMD2osvtlgSXvHafG+usgans0lyMEAjZTUdQ/c39EV/wb5EaYMSpa6i6q6vi7I3LHL7jFudweZZdNhASNxwT/ru1FFXJVI1aqYKzS6ulBtA3jzpRumbqGfEzjaDPJpS3u5A9EMlo8fKW7zSTyVGKKecR71vDZAJcwfKuCo+I6AW1a1zRrxeube0uF7ka10KBlUG7+kEJflL/udkmxxke625zfeGsNqystXKIOQcTVe7iVd8jqjPG16qu/DpMMZx7vevAOVY8NymFQawf/vaACJt5PnXzM5HZzB9kluZd7D1cgwMjVbf9+fUcTfy94dLZjENhbYqOJ00xOerEdM2bfNCQUdjtniPL4kanTXrrB+SrcAr2/6iNyeDQinOa2niCcb9goETf85GH2KuAqMfbJOU1sy2VOubOumchSc9EXWqnefopQCI4A3PBK6gR5UJIYiqVH1I6UREDHuZHeUFtECb
 /sibWKhc
 BFzOWoxDy8Fmit2RhxcLUeTkm3m1fIyzLTVWUu6oYUAEweqDJc8ZKBWkU9kUhMRGeIeuzYRR4VcSfAEqImHqpLjMN37k4wkBJ0PpiOax34Gb/xkOZYwy50oj7yh5ewJERgRYyD+QRKh6pqvVU5PgqYCBNv2GJ14HzO2pFWTKg/BIZwZnwi/fxCqliim/esVR5Bp2GBZN6gF3CKI2N4u7DhFokdXpAK+rFa5r9q8LHH1Jv4l0lKVWC3NWP2UZDIMc/4vbU64zZSAKf7g8adqWVEqbmFoAZjEilaxEB6WhiNQTY2tw43eF3smWwY8rvd8cmXjrH3LQxrfCXOsx+SBPQr2XoavSO1xUCPs3GlbFLYEv//wD+9xziSty3UPP707MjFHeGoAKBskuaBrCQl9vFojPDf9tHDqiVZLHtX9gVZ+xxGDMvuBt/6VEtSrTA5sbtcKs4dogGuiJMP4iqYt4WK0o9uJiirTnR8rZNCMDIb93gbX/dkCPwGOpy4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/19/26 9:50 AM, Muchun Song wrote:
> 
> 
>> On Oct 19, 2026, at 15:37, Qi Zheng <zhengqi.arch@bytedance.com> wrote:
>>
>> Hi Muchun,
>>
>> On 10/19/26 2:50 PM, Muchun Song wrote:
>>>
>>>
>>>> On Oct 16, 2026, at 18:07, Qi Zheng <qi.zheng@linux.dev> wrote:
>>>>
>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>
>>>> Hi all,
>>>>
>>>> Allocating PMD-sized HugeTLB pages at runtime can become slow or fail
>>>> as physical memory becomes fragmented. Reserving HugeTLB pages at boot
>>>> avoids this problem, but keeps unused pages unavailable to ordinary
>>>> allocations.
>>>>
>>>> Live upgrades are one example: they need additional HugeTLB pages only
>>>> during the upgrade. HugeTLB already supports CMA for gigantic pages,
>>>> but reserving a CMA pool for 1 GiB pages can fail when physical KASLR
>>>> and other early reservations leave too few suitable 1 GiB-aligned
>>>> ranges. At runtime, 1 GiB allocations can also fail when pages cannot
>>>> be migrated out of a suitable contiguous range.
>>>
>>> Yes, that's our use case at ByteDance. Allocating a 1GB HugeTLB page from
>>> the CMA pool is more prone to failure than allocating a 2MB one. To improve
>>> the probability of successful allocation, we typically configure the CMA
>>> size to be larger than our actual requirement, keeping a certain margin to
>>> handle cases where temporary kernel operations (such as DMA) prevent successful
>>> migration. For 1G HugeTLB pages, since the margin must be an integer multiple
>>> of 1G, the extra memory configured as headroom is also relatively large,
>>> making it less flexible than 2M pages.
>>>
>>>>
>>>> Extend CMA support to PMD-sized pages so their backing memory can be
>>>> reserved at boot while remaining usable for movable allocations until
>>>> needed. This relaxes the reservation alignment requirement and reduces
>>>> the contiguous range required per allocation.
>>>>
>>>> The series adds an optional @<page-size> suffix to hugetlb_cma and a
>>>> separate PMD-sized pool. For example, on x86-64:
>>>>
>>>> hugetlb_cma=4G hugetlb_cma=1G@2M
>>>
>>> Different sizes of gigantic pages already share a single HugeTLB CMA pool.
>>> Given that, why not let 2M pages also reuse this same pool? Would that make
>>> the overall code implementation simpler? And if it does make things simpler,
>>> should we go ahead and do it first?
>>
>> Sharing the pool would simplify the implementation. My concern is that
>> small PMD allocations could fragment the default pool and prevent later
>> gigantic allocations.
> 
> Yes. However, the premise is that there has to be a mixed-use scenario.
> I'm not sure if this kind of mixed usage is a common scenario.
> 
> Of course, we don't have much experience to draw on, because on most
> architectures there is generally only one kind of gigantic page, and
> prior to this, mixed-use scenarios could not arise.
> 
> Therefore, I think that before the need arises, a simpler design is
> easier to maintain.

wouldn't a shared pool still be sized and aligned for 1G? then the 2M
headroom stays a multiple of 1G and the 1G-aligned reservation can still
fail, which is what the series is trying to avoid.

-- 
cheers,
jose a. p-a

