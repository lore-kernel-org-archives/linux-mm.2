Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2BA5C44507
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 02:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAD336B0093; Wed, 15 Jul 2026 22:21:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5E2C6B0095; Wed, 15 Jul 2026 22:21:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94CCE6B0096; Wed, 15 Jul 2026 22:21:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 58A626B0093
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 22:21:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DDC2180379
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 02:21:34 +0000 (UTC)
X-FDA: 84993038508.10.8B85437
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0E87540004
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 02:21:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cT20gZx9;
	spf=pass (imf11.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784168493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hEDMeStux/KKDKh9A+CKQwEHTpzd0skTIZYkeBHU1Ew=;
	b=mxWcuZe6xOBHqlYlmgI+ahMrLqSuVwE5wEkDaR0tFV5i8csYEYLjHUiY6q8jxPd5VMC0Ln
	ZnB30GVmt7BsNKw0kxSUwqnzpjSRs0dEBvfwwX0LPIrNe6Y6NnSayEbS7i092Gr+Mh5X1W
	aV56yqehY8J3Hg6riNInJBxIRm76bic=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cT20gZx9;
	spf=pass (imf11.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784168493;
	b=RyTxWQJZsZDT8ntwL5mYlTut9i4Lec883K4S+In6FRyVGsGfabyjWshi/ftZEZAr8ox5ST
	ptzQX9miyNHKfgbTOaH8tP3iTw2c8W5vi82bxzy/p3LvaHflbC5fLC4MXMtq0nToUaoo9P
	pMsT9k5+HhFB6+U1SZtmmQJhTlykM4g=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-38e041ea211so3502301a91.0
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 19:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784168492; x=1784773292; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=hEDMeStux/KKDKh9A+CKQwEHTpzd0skTIZYkeBHU1Ew=;
        b=cT20gZx9HcTPn3EPUutMIXqZfNA/WnjaOiqoFbHDyX363ohWj93d7fZO0rK/RD1V/A
         0o+i08gl3KKKfD2Sz8cfctv+9DcEAg7JjOV7zUCSV8jQvGTEnQTd0Z+w+CJrRwnPtcIM
         R5cilPeg/hm9O+tHWzEKY8ZycVyQL8HaiopI6Dxdo2CCm0uZ47Y4XORADjmoP7t3iovb
         /D14nmp6WCCM/Cz/hq3ZT08TPO8fQ8e+MKlkzHBt1W88rLJ/tIV6PRtWmkr37uTKGDga
         T5e3po7ZHmHKixLdIhXqRaDGMuXSCJxYsuJ2cTGw7yfaYpkfvIxkQrBNYk1fJsj/wGHn
         TswA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784168492; x=1784773292;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hEDMeStux/KKDKh9A+CKQwEHTpzd0skTIZYkeBHU1Ew=;
        b=nkdMq9HiujmKTNYs0MtbidpMjzIt8a0oImLJoM/msuTPPhSCOnoiBi/snLq+Pq/LQd
         Ur1FCdlJ7NMJXhi4olFx9XERtNM8VMR+mDh+4uKN3P3HXpd7ZnpoBO6Uv0hfNEXop5/J
         pKYiFkwhgP+o1AJMckmqsdy4gR5mVIMbrpthQB0Uq7zP2eUTfSXL+xkvmzeBeImCAjZG
         WqNVTU0w6GjUhVtJlJ4utfoWej7npGeKp3aXW8g04T97PlY892gmNUR+9FfqosU5+vhi
         eRXVk7w0j9z+KipeW72w5TE2YodMMf5SZwzsptslgzFRhSeeezfEBJZYVWVTlJKurbqe
         s2mA==
X-Forwarded-Encrypted: i=1; AHgh+RoRBEwVVnVeKwPKgmcCNBdW5D9Eom5ZzLbTVFiDzdLaP25561y53abYVdO7gh9mBvwgkq5eAJiJuw==@kvack.org
X-Gm-Message-State: AOJu0YwXY8qNZy/EcnjrvKf8XYH15QnjiI4/1moa4CGLLQzuwF+ImeCN
	oOXyTtwa7/EKjSV5J79RMPwXtkmnbeNO95CXRR/M/J48VTNjHKnWrCbU
X-Gm-Gg: AfdE7cnnrocX2KvEghA50qZW5YmRv+UbDVRD/13vbpQJ653wRSnmuAoMem3GJQTby+J
	u6q7+9VhORv1assJMNyqFU6kjwuG/sVqa/s8+zLtNJ7kMWDdHNUgOZmoNcq9FcMtoUjnvoFK0fi
	OCip2zWOawssA7gRjlXH7hM3n0h/KkZGqNvv84WtrF5t8bNksJkkYVg1H59lWUsyFouv3i9M/Tv
	sv0O5E+XOZIlYbOsbpgdsjoHBfeWDrBMSMC/IwwDXk55Y9kEELzNbtXHUdHrEEjGLL+Vd1Bu8oP
	rjCnRNcNqsscT4SXPmISkfQGKLVbKNqam1K2rm4IhyjxdZeSLjO2m+llZBZTwy7xsIYoWNZ7goa
	bIqhKu6hxRQ6nJd8BgAwUR0PPgX2cMUjS10FhniIIVPZqyTFH2hYXKae58flJMJ2X/ikSffngWx
	GOl9CDWuljsnybJWbj0zPz8fiGz/gHRetNEg==
X-Received: by 2002:a17:90b:3c43:b0:38d:f94d:4c6e with SMTP id 98e67ed59e1d1-38e1ae56689mr8553199a91.17.1784168491732;
        Wed, 15 Jul 2026 19:21:31 -0700 (PDT)
Received: from [10.125.192.114] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e3a100753sm459147a91.13.2026.07.15.19.21.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2026 19:21:31 -0700 (PDT)
Message-ID: <7b35fd4e-7662-10ae-159b-303350e4e59c@gmail.com>
Date: Thu, 16 Jul 2026 10:21:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH 1/2] mm/zswap: Fix global shrinker when memory cgroup is
 disabled
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, nphamcs@gmail.com,
 tj@kernel.org, hannes@cmpxchg.org, shakeel.butt@linux.dev,
 mhocko@kernel.org, mkoutny@suse.com, chengming.zhou@linux.dev,
 muchun.song@linux.dev, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>, stable@vger.kernel.org
References: <20260714081510.16895-1-jiahao.kernel@gmail.com>
 <20260714081510.16895-2-jiahao.kernel@gmail.com>
 <CAO9r8zM5nzDqNcx5UoDgGexvR6jf8MmJV9SomM4AS7n-rZ2o5Q@mail.gmail.com>
 <20260714193129.f81711f516504b659d544741@linux-foundation.org>
 <7a1fe347-7ca6-4768-9308-420bf1251f54@gmail.com>
 <CAO9r8zMDndmoxi_XvQv3rkkhCfb+aW3=8JdE3gAv2YOKiyiFSA@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAO9r8zMDndmoxi_XvQv3rkkhCfb+aW3=8JdE3gAv2YOKiyiFSA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0E87540004
X-Stat-Signature: 3mx15tmwcpgygf5ukm4oh5ekeyxaqmc5
X-HE-Tag: 1784168492-227687
X-HE-Meta: U2FsdGVkX19zigj0TxdeHCaEkr6gvcFrdNNNoB+jHkpl4kv8/UxlQTQ2n6MaPBZFkmROO0rvQKfJodQvQ638FNUtnYMUaJm0sw9iB11hDikXFHdJIuFbXBmu5qL3gRWu1JY+7CjN8gjGGPBtotf19QjVqNyvaLheLIODz0ekw2MlGilTC+m8hNeJKZw7J610b5MwYsQtgHJsn6K5vEgx1Vg0c6m+pVOF9dmMy0QXnf+tpSUEKdHjSF56+I0kYOz4eKA2taibssmWIHv9EGz/Xrs6m7OaoeMUFs08jNbtwXxHLpwkHo3lJYPqEjkIYAK+O0D7Bje9+hyfOhwukIHiCOI56oMtS/aRJ3x+2rZXGGwLR5MuGZ1FhIO/wvek6qRr8UqC0PXs1fBVy3yjTJd+1VApcSMILX+Q0MeiYEB8dqZits0+c3e42vmr/7PZ7c4EbkcAbLRY8pWieIL8EuScPrFi6kT1DyIjSHOwweZ8pshi40mPoMFfvHCo5D+dfsOeewBRV8WrXUrsvE712sVc1ws0Y5SR6Fv6UMA8WdRw8HgWSkyM5o9uQsu0IHkDxQBFeZH2SYaIDspEpDjRPLryNc0PVU6jZYdWW/HkzS+Q6/dYJH5/E8npw3S4ZfNJ4OXbMNWCCrK7A6QzWkg93D6T0nvqPXr2brMRmyGNpW0kKFqiB+blyXu0q1NO9hx3/P7pyQnl1MTaA+2NcfUqhO3uLVIkurAE4vpKem9EYwCX8MWqwpWuYGOdRfW+YNnn2YoVsWocSA4/g/7NchMXtJKfUmT18RJlj/MygOxDi4FmSDANSTB8w7eg7XZGyv7JQKe+JlLfW36CWSKYUfk/Qir5ugXqP+JbkFFRAzrWXshnAe3B9NXYv0vTiIA5x5mwEFkmuYmiqxDLLu2wJcKNwDeat+/JOkbJCRY6P0M14Ljcy+LaI4t5o3LuDKNw4qT6PZLu5bu5QslO+oLQUafCE4f
 XDcgHVL9
 oQZG/np/LYmxeT1hLoGw6Xpqvpet/seZL6VkRi9p9KLTFFTo9nnEMh/taAQyOQVe8s7/d0BRaqS+MEj6pWOEYkvVGVyei9NLHHSFmoRBA21Wvr+iOfb+/u3kFPFhmsqLWRZ40x9JfFkz0vlxsndLubvRFLTeCp8AwE7VuNGAiRG8eYjCW0KlVI+DkE+2DoypbErOIuzw0qJrxmhZ/fuyWhZCOjPbP8N9H2+WWvPyOBhygYihTu88l1oo+wFsZT1QQywcsg94kUXsU8Z3lvFWwhcyOXtW7LupMgVZsAxQNC8JMzBYXowspROpZSvEnC1EA0oelU2V0Gp0HqtiaUA1DsKZgvtvLR0juKVylPYFYApdKHawXUGH4pMSj5vvc7B9emiwMgvcp1lUdb8Ft4uuLYxcOdX+wiXKiIxRStdjlBtSPL3owPnN68m1jFsiYDm3PPjz6My6GovlfmMem3it7DKPuH2fWdq+AbiJ5gt0UTCX4+ZVmxSm5mfFnCCSy9HCPX0fmCed+QR2jxVTtt9S9qX2cwKRiYFzfbFs6WIWB/i+t+/QcAiQTv0kCwjQHFyXLnX3OaqOHgJVPxUzWPBf99dfOJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/16 00:13, Yosry Ahmed wrote:
> On Wed, Jul 15, 2026 at 5:31 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
>>
>>
>>
>> On 2026/7/15 10:31, Andrew Morton wrote:
>>> On Tue, 14 Jul 2026 09:52:59 -0700 Yosry Ahmed <yosry@kernel.org> wrote:
>>>
>>>>> When memory cgroup is disabled, mem_cgroup_iter() always returns NULL.
>>>>> Therefore, the global shrinker shrink_worker() always takes the !memcg
>>>>> branch. After MAX_RECLAIM_RETRIES empty walks, the worker simply gives up,
>>>>> so it fails to write back anything.
>>>>>
>>>>> Therefore, when memory cgroup is disabled, fall through with the !memcg
>>>>> branch and shrink the root memcg directly.
>>>>>
>>>>> With memcg disabled, shrink_memcg() only returns -ENOENT when the root
>>>>> LRU is empty, which means the total pages are already below thr. The
>>>>> loop then safely bails out via the zswap_total_pages() <= thr check.
>>>>> For any other return value from shrink_memcg(), the loop is guaranteed
>>>>> to terminate, either after MAX_RECLAIM_RETRIES failures or once the
>>>>> threshold is met.
>>>>>
>>>>> Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
>>>>> Cc: stable@vger.kernel.org
>>>>> Suggested-by: Nhat Pham <nphamcs@gmail.com>
>>>>> Acked-by: Nhat Pham <nphamcs@gmail.com>
>>>>> Acked-by: Yosry Ahmed <yosry@kernel.org>
>>>>> Reported-by: Yosry Ahmed <yosry@kernel.org>
>>>>> Closes: https://lore.kernel.org/all/CAO9r8zPVzMKFbCixxD-qgtRrkFxWVrHiZZeLc=eyTPKPVQgX4g@mail.gmail.com
>>>>> Signed-off-by: Hao Jia <jiahao1@lixiang.com>
>>>>
>>>> Patch 2 doesn't really depend on this one, right?
>>>>
>>>> If that's the case I think this can (and should be) picked up
>>>> separately as a hotfix. Andrew, WDYT?
>>>
>>> Please update the changelog to clearly describe the userspace-visible
>>> effects of the bug, thanks.
>>
>> I am not entirely sure if my understanding is correct here, but maybe I
>> should add something like this to the commit message?
>>
>> When cgroup_disable=memory is used (or with CONFIG_MEMCG=n), the global
>> shrinker fails to write back any pages. Consequently, the zswap pool
>> fills up to its limit and rejects further storage, preventing memory
>> pressure from being offloaded to the backing swap device.
> 
> I think you can simply write that zswap writeback when the limit is
> hit is broken when memcg is disabled.
Will do. Thanks!

> 
>>
>>> Also, AI review has flagged several possible issues, all appear to be
>>> serious:
>>>        https://sashiko.dev/#/patchset/20260714081510.16895-1-jiahao.kernel@gmail.com
>>
>> For AI review comments on this patch:
>> I suspect this scenario might only exist in theory. For zswap LRU to be
>> empty while zswap_total_pages() > thr holds true, it would require a
>> prolonged state where there are always more than thr zswap entries on
>> the zswap LRU whenever zswap_total_pages() > thr is evaluated, yet the
>> zswap LRU happens to be empty during shrink_memcg(root_memcg).
>>
>> If we want to fix this, perhaps we could do something like this?
>>
>> Yosry, Nhat, what are your thoughts on this?
> 
> Do we need to do this? The last paragraph in your changelog explains
> why this can't happen because zswap_total_pages() should be 0 in this
> case. Did I miss something?

The loop would require the following sequence to repeat indefinitely:

1、zswap_total_pages() > thr evaluates to true.
2、During shrink_memcg(root_memcg), the zswap LRU is concurrently drained 
to empty.
3、Before zswap_total_pages() > thr is evaluated again, the zswap LRU is 
heavily refilled such that zswap_total_pages() > thr holds true once more.

For our case to manifest, it would require zswap_total_pages() and the 
zswap LRU state to repeatedly hit this exact window with perfect 
alignment over a **prolonged period**. Therefore, I suspect this 
scenario might only exist in theory.

Thanks,
Hao

