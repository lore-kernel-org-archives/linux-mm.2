Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43E26C88E5C
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 02:18:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BBAB6B008C; Sun, 13 Sep 2026 22:18:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16C526B0092; Sun, 13 Sep 2026 22:18:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05AE36B0093; Sun, 13 Sep 2026 22:18:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C511B6B008C
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:18:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 218B9140EB1
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:18:38 +0000 (UTC)
X-FDA: 85210759116.03.40F833D
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 99A3C1C0004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:18:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=lejk5gDm;
	spf=pass (imf18.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789352316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DxBEauNnCmvuxYQWGMnLgbbVInndKO4lO+HSKGFpeVU=;
	b=GOy7L0sCFawQ295QE6cUeG7LbWACw51b+gociyYrIQCRl/CEqrnYKzYt82fpD1445Pu/Wb
	R+YOX6A5h5db/0hMwtnUM3LeRIlJEjGh93ZqHylRk1UnRvrnz2r+ed4zX5us6gvoA6cMgT
	wDu6tHK1SYDUI/VAnTzb6UJZMC045VM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789352316;
	b=JMP5QiADDJfIJYh/q5vfLroDAX7xA1Cdbv3R0NSR6F2DywtPNTdZl+1AUEvNWero7pjonj
	TIcjSAtqDkzKUX2W6mBddV8QZmeqbVrOXx2U110tE3uxKRiClm051XE2AFIE2PnTUfJ7Mu
	C2PtC+EstMbXDIObFntJXxUYjwKayUQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=lejk5gDm;
	spf=pass (imf18.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8520161fdb9so3242292b3a.3
        for <linux-mm@kvack.org>; Sun, 13 Sep 2026 19:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789352314; x=1789957114; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=DxBEauNnCmvuxYQWGMnLgbbVInndKO4lO+HSKGFpeVU=;
        b=lejk5gDmCRq10JjgL9cvBXK9Fn00nuusXgnWt+iEA16IBztuxfXYIXPPaj31/XGxIJ
         IEILtctF+ZJrMCy6dsAO1/qCoFQG64HxKfmbabJBxhl0yKthJf4RFAw3Tb5Xgy/NR9TS
         9lvSV5MN7yftVQlwRnHMa45on46tEFM5relIWwz1a0LXZYnsvf7r/BCQgNoArQKPNFPn
         1RYzqt8mkPCUbEpiHAx6QKbDIzoJv3MHsY3KbJbnbA8Dqdmkh7DfOA7rdupsBtvg5Kf9
         CDPExWN1KZiPnytMl7pKWLWAHawIRcJZG62ZcsXzy1vxNY+7h4b03d5E+UFv6MekQ/ao
         VnvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789352314; x=1789957114;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DxBEauNnCmvuxYQWGMnLgbbVInndKO4lO+HSKGFpeVU=;
        b=sKU6S6Mh/y2yfxEiUhdH9LEUAJsNr/yoFTKMocbpCBiS/0KXO+UrYJfxab26HTQqwS
         LLD+o1Hu7CZSy7qkSjzzTsZ8OMtNO49kZdfuXq4sABiZNHY9TfTc6FxDUc16KjzOeWBD
         B+l3oGXmjkK43L14kWcPNq6IyIawkltT7MxKfqPApVAbBtt2ChetcL5Nt1+ynEznXEhO
         F/ZkbZnEd3fMz2yaP0aCoFbPpfl3adxpPLX0CQBpBw0wE8tOnOr/rcbmnVTF1gcHCMIB
         VE0ibkyM+vwcbOnV39cYJ9Yd16AwOaquv4/H0XWqskuzymn3k0TE7yoS/yOierm+tqPi
         HEQw==
X-Gm-Message-State: AFuF++kpqhTJzMnwQRy82BvURDHSV1tVL4y3fLB5rF+21ldOGxzXrnok
	5fyKdV7cl8/G+hwxSRXo/myOa4P6NX6sEtIF+Kk9vreeCWBFs9f3+BF+m4CVRduMuD0=
X-Gm-Gg: AYBFou0Sfko9Q/H9SQrUfS99nl6nmTT82K8Uc7jnrWzdyozlVl3zYBMySETLJ2lZNBC
	gq+dXT6ppEIEAufEyTqonPgSlhqgMi+4240OFdLbDisNAam0MqcMrYWDKeitbsZGUoYg3tt52aY
	HdRCqKLkt8kaeLspRNxjGIdNwAmeacMDbzEZHIAktxsapNRgiq7LSMETJGLjZTkEkhJ3T+YUB9H
	Mijl7lolrrXKuRlrAq2aewRjdZA1YW9qL9VKPCkyI03zlegdYcedmMgI9kxFXdFCtPdLn/MPKgX
	iRF/W1gLsfSp5ch/8mOzqB7SK/B/cjR8+mPMoxWQyFN5rFBhzG/ShT32pPj1V9g6CSFVp33vjIT
	gDIQx2abkDIhNMK0OPlLb68nKeE8+pofQwKGwYpxc60GUmgCY01h+M/DNem69UNDGMBU6emBKft
	43Qz1TLyOFFrXHLHILPxqi7perBWLy8Pq2IMQE6YHkujvcHT1Rl8gKAH5a0L+bXvtWJR8YPUldI
	taHU+1m/NF6H2SAsQVU4PcM09/UDwbtIC0j6DeHPaQ=
X-Received: by 2002:a05:6a00:950b:b0:851:d12e:389b with SMTP id d2e1a72fcca58-86f854fa179mr1418104b3a.14.1789352313961;
        Sun, 13 Sep 2026 19:18:33 -0700 (PDT)
Received: from [100.81.12.150] ([61.213.176.57])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b291c06e0sm3752158b3a.28.2026.09.13.19.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Sep 2026 19:18:33 -0700 (PDT)
Message-ID: <e55a7422-1871-4a03-80bd-09cedf9630dd@bytedance.com>
Date: Mon, 14 Sep 2026 10:18:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] writeback, memcg: skip foreign dirty tracking for bdev
 inodes
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, akpm@linux-foundation.org, axboe@kernel.dk,
 tj@kernel.org
References: <20260909034343.340703-1-sunjunchao@bytedance.com>
 <iqvi6yo62ydxzshad2mhi55rxhyskfsoo62ji2curbldrg5cc4@z3wju4r6c3ab>
 <CAHSKhtcvaWgGHY_NWW242vYHHiSet0v-qsj4MsXGiwZJFrdUnQ@mail.gmail.com>
 <ekylbhyzseq25nxq2yivmmdt5xl5glum5proueyd5mrqfux2y6@fpvflg4crr2i>
 <db6d62f4-34f0-4237-ab58-c21b0968bee7@bytedance.com>
 <l2awpukcp7lorvujvwdoqnlwlkkjl6e2kef6tnjvdw7qve2fni@vh4lspozoytt>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <l2awpukcp7lorvujvwdoqnlwlkkjl6e2kef6tnjvdw7qve2fni@vh4lspozoytt>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 99A3C1C0004
X-Stat-Signature: ygwiiwhiytjj77wpuayngoujsxzj351u
X-Rspam-User: 
X-HE-Tag: 1789352315-314084
X-HE-Meta: U2FsdGVkX18xC/V/UTcCU8e6/RuKzwjnL3E5Z99WbIkBKM0ah0n4DjWKkm6hQ526v6MtJMU4Q9tMDSK+34B4MUIorXuBL04YmnBWeot+h+gcGaFI3l8hGHnuKQAKh2dc536PvjUXCiMONE8dYpXcO1D/2mz+yDu8DO9zLzhFdRmaMiatpIv70dUiEI1691HMQ85/K6XY7Bos9HRMGjZ7zcVdNAIZrhRamHxRBtMH/OkRy6ZCLdjq9AWstZa6V/YF4ZdnbI3Spqn4YiADDd1SCufhkKP4CiSLi5ShCitdgqhBfDKGfc+pp5HLen1dO62ZO7qq975g9Ei7o8PUA9weQoqKeqUAeB9eIAZxevb7+pGGCzYwy+dj6strdoRw8+4ZQ/QPCDa1y7h64ubbJZUzLIlv0wWk1l+LvC/Ui9FoApB7wsvJvAJ/LBXfSQ4ioILure1V2vAxoQ6gZdcvwdda2BVLQLx7glKtCFTt9bFwug7m+FqxZRZZr3pQ63V1BJirvtD8HkYwMUplpDn98ziSaFzosDK6R+39WtlBHpDkaeawsVFvI532bP7HG8vzybrUL3zoD0vLSHy682B55dlATVoEiVaqwNgtPTz1szZCRtzWspT4uBY5Ky0Y9m5EkfyEjpoUUoDCcFPmjXvT8j8mpE74MUHtJqPOukBOY+aIP/tYnQE8cwKZMoLEWGktXqJspBuKPzy/QzrLSgAuWiQUQs8W0+rP8dvezP0dnGh94+WRW0fH4loJRfBYWCK7fSntrupipt/hvaPzjpPsZo2bag99L+y0T6G023PaJoma0eUt+uNVA8cUvWyukS+PotcZ7V6buVaeTKDh+TwX+fNQZBiqFGZ25RXxc5QPFnQkBeguCbkGjOCPmPps46b5MxCu29ZCAyQjxIVbF35RvbRwtPWBYShHOhCDIvAnAIOs7ed6JAf4gn5z5SeRsyyXbAQv05cWJhwQ4L0d9FxCD+L
 VQDyE3Zk
 1fjuZ88JZe2AftqoGbquj02bmV/W1NOf1flaX9bA3ZW7a8RJ8o6hT2k5IuKbuBFxeOILDOB5E+6sA89eLgQrnsWf0ljMDyqwnGRA6A1FFdr4E9Ora/GoruzuhDbY6qM7YhBrdZvo0bizw0Vfe72NmQGKfqIGUfwr32RlTj/itaRod4uSZerBX3dgV3b3THzYdoy+zRf459v23pETWv29Yvk2B+KGkL0WhWY6PDZ3EXQ1kg2U4qjkMISmhdqAEdMxJxYMaRKCGf7k5B6T4GMtteE5MODhzqN4Oxu27u0DQoDGnnHpe5jq7Bvv3GzF5HY3HbJ52r4OosjwOnqEcWTW0t6190rTo3K/iRludKAJln5V2SDZ4NWN6Toc2MI76C110yzd1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/26 11:39 PM, Jan Kara wrote:
> On Fri 11-09-26 19:39:42, Julian Sun wrote:
>> On 9/11/26 7:20 PM, Jan Kara wrote:
>>> On Wed 09-09-26 21:18:11, Julian Sun wrote:
>>>> On Wed, Sep 9, 2026 at 7:13 PM Jan Kara <jack@suse.cz> wrote:
>>>>>
>>>>> On Wed 09-09-26 11:43:43, Julian Sun wrote:
>>>>>> The expectation in wbc_detach_inode() that "concurrent write sharing of an
>>>>>> inode is expected to be very rare" does not hold for bdev inodes. On ext4,
>>>>>> metadata from many memcgs shares the same bdev inode, so dirty throttling
>>>>>> in those memcgs can repeatedly trigger foreign flushes of the owner wb.
>>>>>> These flushes can also write ordinary file data, reducing overwrite
>>>>>> coalescing under continuous buffered overwrites. The resulting extra I/O
>>>>>> leaves less device bandwidth for other workloads.
>>>>>
>>>>> Hum. Are you aware of [1]? The guy is from the same company so I was
>>>>> assuming you two are working together on the problem :).
>>>>
>>>> Yes, Xin and I are on the same team, and we are looking at different
>>>> ways to mitigate this issue.
>>>
>>> OK :).
>>>
>>>> We will continue trying to gather more evidence from production to
>>>> better understand its actual impact. The number of calls to
>>>> `balance_dirty_pages()` and the time spent in it might be useful
>>>> metrics for this purpose.
>>>>
>>>> Jan, if we can show that this patch provides a measurable improvement
>>>> in production, would you consider accepting it? Or do you think we
>>>> should still look for a better approach? If you think there is a
>>>> better way to address this, we'd be very interested in your
>>>> suggestion.
>>>
>>> I definitely acknowledge that there's a problem with foreign flushing due
>>> to bdev inodes that needs to be fixed because as Tejun wrote, bdev inodes
>>> break the fundamental assumptions of foreign flushes. But so far I haven't
>>> seen a solution which I'd definitely support.
>>>
>>> Having data from production to understand what exactly is the practical
>>> problem will hopefully help us understand how the solution should look
>>> like. Is it just that we trigger too many flushes and that slows down
>>> things? Or is even one foreign flush of the whole wb due to bdev inode
>>> making performance bad? Is it that we have many foreign pages and foreign
>>> flushes fail to properly write them?  These are questions we need to answer
>>> to decide how the solution should look like. And the solution could be
>>> anything from just limiting number of foreign flushes for a wb to 1
>>> (because there really isn't big point in more of them being queued) to more
>>> involved foreign page tracking for bdev inodes so that flushes can be more
>>> targetted.
>>
>> Hi Jan,
>>
>> Thanks for your feedback.
>>
>> All the foreign flushes we've observed were triggered by bdev inodes.
>> What we've observed is that the bdev inode has only around 10 MB of
>> dirty pages, but it triggers writeback of around 40 GB of dirty pages
>> across the entire wb. The actual foreign pages account for less than
>> 10 MB, yet flushing them triggers writeback of the whole wb, and this
>> happens repeatedly.
>>
>> This appears to cause significant write amplification.
>>
>> Limiting foreign flushes to one may not be sufficient in this case,
>> since even a single flush can trigger a large amount of unnecessary
>> writeback. I'm currently working on tracking foreign inodes so that
>> foreign flushes can target those inodes specifically.
> 
> OK, good, these are already some tangible data to use :). So in that case
> I'd maybe just:
> 
> 1) Avoid adding 'wb' as foreign just because it owns bdev inode where we
> are dirtying a page.
> 2) Track that we have some foreign pages in this particular bdev inode.
> 3) In balance dirty pages queue flushes of bdev inodes where we have
> foreign pages (besides queueing standard foreign flushes).
> 
> I didn't put too much thought into how to integrate this in an elegant way
> with the current writeback infrastructure but something like this shouldn't
> be that hard and it should help you with the foreign flush issues you
> observe.
> 
>> The impact on production workloads is not easy to measure directly,
>> which is another challenge we're facing. We've had reports of slow
>> dirty page writeback from production workloads. Although we haven't
>> established the full causal chain yet, we suspect foreign flushes may
>> be contributing to the problem.

Jan, thanks for the suggestion. This approach makes more sense.
I'll implement it and send a patch after testing.
> 
> Just being able to measure that "with these patches we don't need to flush
> 40GB of unrelated data in foreign flushes in our production workloads" is
> enough to convince me they bring some tangible benefit for your workload
> :).
> 
> 								Honza

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>

