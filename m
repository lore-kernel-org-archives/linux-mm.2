Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B4FAC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:39:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1534A6B00A6; Wed,  1 Jul 2026 05:39:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 103F56B00A8; Wed,  1 Jul 2026 05:39:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F37506B00A9; Wed,  1 Jul 2026 05:39:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDA1F6B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:39:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 56A661C6E12
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:39:36 +0000 (UTC)
X-FDA: 84939710352.15.5B6B341
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7E4FE40005
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:39:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PuUNJRNx;
	spf=pass (imf17.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782898774;
	b=7XD8/mj49InLeFmINDw49XF28WJER6oubbHfsiMmU5KtPj6OkMudPJOcGLIR+TGVdU2SNu
	VJH6Y9S0v0v4MdKWHetDgdnLhdKBoL6C4SIF6vrD1CgXCKvPrPYKA5oG2SMGCHre8Q60pk
	mDfWfaWyevK6TNGDSteX3P2gxTuGPIc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782898774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oqs6VzWQewb1OvRu2nCVMyJUKa4LqJKmS9q20XGY1/U=;
	b=RXfxkAsaqjKlZlhJ6r17MpAYrb1ZfxltZcDTvgTVvYUalbCfY5VYZuqCGT+FeOD/qN9Tqq
	Jxz9KyyeWn0+YP/Eyqo1M4w2eBr5hH2MDhvYCe07Z1CUk2csSzvbkm9dWTh+YMu38rQx2b
	SCyBa5Y1xGnDh8+j5QmqVHfsstJtBwA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PuUNJRNx;
	spf=pass (imf17.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2c9b19bbaefso2792045ad.0
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 02:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782898773; x=1783503573; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oqs6VzWQewb1OvRu2nCVMyJUKa4LqJKmS9q20XGY1/U=;
        b=PuUNJRNxFhuCd10Zx25qJ5nAoGopjOg5UU3W+qcpubQV0CcxdwcRW0xqmONgw93yz3
         bQiYC8V6oQNrz36U0+50mfihI8cCdg2p308kmxv5DVGMF3xGd50Spx0+um2C8zb2OClf
         0F0R+xpKamyYfwZyE5HbCBH1+xbNXOCvE/npqrCKGP0zPn5FWhc3UwyRG0tYGFZIWr3d
         xYjmOqbXFI3dxgi/pf2Jo1bYewWj1q9XQrAhkkSW91sE2++8jVshE8ODWg0YgQ5H0Fcl
         d1TF8BHh0wdN7613GbIfOc+SlHTfBqEjrljbPQ5Bsa7RDJrH4+tzprLymBWJRWTdQ/k2
         cGOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782898773; x=1783503573;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Oqs6VzWQewb1OvRu2nCVMyJUKa4LqJKmS9q20XGY1/U=;
        b=j77x+LC7i6IM0hvktApowq+dKDyHs59FzhlBLV6HUBo7WXWGyIMEeOSrIB6xFm0ZEv
         r514crrXXZhbJWwCWDUCgCwX8jh5rwvN6o4syUCnP5PQCHzVtYLE6PJoQanV4+7wSjsQ
         4UR7cbp0OM4J2lgYdJDlR4ry2uPnxQJbrROyQWhbkPXNl+sPi3vHFa9gKNAqTsilU1CE
         SiOs2SJNOYeQXCr1XAwA8BBodMFYDqfhzdDLc6B/2MeJwKwWkuMszxQbepZPD7MRBKhY
         +7Fo2S3Ob4fB2kCDoRpgMiyAs8z3+2P4Kh4KwvpB6oBingaA7xZNwD3wXJMU4IyWBhVZ
         ZB5Q==
X-Forwarded-Encrypted: i=1; AHgh+RqD83M7oLOP1gvE6hQICo9M01UgF47nzDXGCZEQoUOBZbhrCu9HdiXRr2xLmvDnMv0ydUiohtR0qQ==@kvack.org
X-Gm-Message-State: AOJu0Yysv1bhsjpnGKCx0lu1MiKlFsvi+LIginofhlOs5r81wYmK+L/w
	myPkYXxuwW/tz7HdCFEWuxqTMTYSRhWpk3H5TwTUJNGs+CoKiWVHg5Jn
X-Gm-Gg: AfdE7cneuvYWMzSPCDHzHAve26yFCLznY64tah3W1U2BBFdY4gZ9DSKMD0aPtM4NFCr
	KBzLToVYoHhWHEtMEbcnjOaCMxL1T5MnMlO/RSEcyyYsE2w4ZCh/cX8VesZ7N6LP7+ZEOLTk6eg
	mVGCiXie6Jl9Pl9KO6vO8iJmYyw/GbsQLwCmejnIsn+2YbqTeUb4G2rTAqTMCeDktQYBOAksDyK
	S6ElRzkFS70w9f1L1vu7jG2r2MYkaTcOdUz9Q08IzV1eHf1wIv0ov3YMMjYGNXqNylCpPz5INVE
	YLNLaZjSNvH6BT5KQ9AcXNXQufcxi4Agv7v/s+rDMdjzmDv1QKSeLWzCm3JQ3T2POPngAN4r1+n
	LF6PhvC0S3IUncuBJk5V8FEO3Aj/0iswwqcU3DZkT4MOkQGSMnJS2XK61MEqVjhgO+qat/MpOtP
	EUea18gK1xSNlD+SFpogY4wLuM/HmUnFVd
X-Received: by 2002:a17:902:da8b:b0:2c9:9a2e:dab0 with SMTP id d9443c01a7336-2ca7e71509cmr10989425ad.3.1782898773219;
        Wed, 01 Jul 2026 02:39:33 -0700 (PDT)
Received: from [10.125.192.77] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca382acd0csm29148225ad.62.2026.07.01.02.39.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2026 02:39:32 -0700 (PDT)
Message-ID: <e2ec0924-52b3-25f3-8432-4b8e33a101dd@gmail.com>
Date: Wed, 1 Jul 2026 17:39:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v5 1/6] mm/zswap: Fix global shrinker when memory cgroup
 is disabled
To: Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, tj@kernel.org,
 hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org,
 mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>,
 stable@vger.kernel.org
References: <20260629112032.20423-1-jiahao.kernel@gmail.com>
 <20260629112032.20423-2-jiahao.kernel@gmail.com>
 <CAKEwX=MniM-4-aV17aH3UiDd_Xd2RH743fFZaxEnYX9qvnokeA@mail.gmail.com>
 <fe15eb9f-0b6c-dcaa-d0a7-5f08c3f92bfb@gmail.com>
 <CAO9r8zPBe9BPwP8NXz7pdH7T+8HLNsRAckL2Vfcnz0c23TH=iw@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAO9r8zPBe9BPwP8NXz7pdH7T+8HLNsRAckL2Vfcnz0c23TH=iw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7E4FE40005
X-Rspam-User: 
X-Stat-Signature: zmome88rc159zaok3gdeaqtx7zyt33nm
X-HE-Tag: 1782898774-644281
X-HE-Meta: U2FsdGVkX18EnZmY0w0QC3aeAmg5Oq3lETaelJ8mrz2xnMsuBg55T0IY8Ah2Q990KdQLjvefE2mv1KBro5qvM7VBL2KbHPBgO0srxEhh4JnKU6aIRTpIgpsquRKMylAEfqoE1uKvYF4wkjPFoA+kUXgxuLkq3XOywzE7qZTWNMuUtV00XX9briTPc+7Gho5AzQVH/HFwTHTlKIHCMk70Q2AF0Ax7bgl4RR/qVn2VVpklZ3gQl66gKmFi0qZgsYKnZPG3XFgTd30SBb+jGzZLRdznOqF/7wZ2FYf/viNjxhMcsRuSgrTMTOHz9UXkrx7ZaujUPRTqm7UbZSGivARnjtl1I56wvFPSu+XhfVYnGVcUXGr7L5kh1LF+0uXtVXl4ELZ4l0pegjz2BYBpjHENKK18MgR/UbvdeXan+rNmvsKQi1eAc7P3HRgfvxop0i4oM+QGHSBRc5j2p3U7Sdh2y6YINGn9rC37s7n4gvWTPULhIvFQpPZllZp+uDUw3D73okz55e1wgqt4QEKkzYKH44l2FIiBqpkq+Exd8ujmsBehTwGaomOtLOJY/CB0eFYZf5zg3FexHbBcVFuVR7J9Yy04Mv/rj1H1pggnm9yoctc9AuJ7cG08LSdlG7PhlnAoSAd9FoEi6OoqzIc7I/aRoLRx1l4malqbl22QZOZ9aHI5WhFtqPggN4fslOcRD0X7TGtLKsGUDdmldaJrSuDyZiwaT3ZHuLw5W13sCMKTNX/btq1MWRYBaJiEHjop2o12qlIQMGbzV0IeLWyh7nRBxBcXJk30JItma529J0wdXZ5JVxk04oenPyAqRpdo7EZKLNqI6bDHzCiRJlSgW9QI3gJeVMaVEbDwL6wXfnJhDY3xMy7hGDCx7J/1wfMlWY32B6/VEFffMrZyHI+2lZvZ0Z04AUMHTdwR5W7li6AorHB6tbzdu3X5pGAnTikaOKCSDnBEzoAv/zNYMciRUjG
 eso+fAwZ
 wj0ll5vQ4u6BF201ybeRgtc9Lam9SeADHy/jVU+ojIIWsCKDOQQ0dgcIQ/BcleQMR7HDfJa8XE3SzbMKi7bHVzqiHQn8LFK082ZSP1rzHZw4YXM34tG1yqQsbfuXeNBHax3KGyH5tQyaUKRZRvuH9U3RGLdb84D6gloMpAubiq00gurVtu7AEm4UtGFq90nWGQF9u8hX4zvZdaOVYHN4GwZilwuNHwmmt6jPrPicvd7UQSyTx7gGbjwQMDRm3MqBQkdUGCey2H7zXWEalezhA/ELYBDIG+qtXiq0CGqTH0g2Tu+10HUJbwIjKQQ4PVXMr3Bdh0JTk8HuOcyJyzSK27S6uRxbAGbChQxsYg5q8F857USNMTE98CdR4X27QWPlcbvToZc8YR3MuDEoxg55PPRH3KFtKjiFYggflQIw1VhOjZvSm1dEzgIHf5439UWkpBKREazLf8t+TMC4KMOfHpASRV1hp9TiyTVlCUF3LEdQfq/px1eL+2+Ax5Q895Z1oH860PcHSUaGSs1HGWYdr1HQf3mCuqXf8sgCsjNWbWtJ2yug=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/1 00:02, Yosry Ahmed wrote:
>> How about something like this? If there are no objections, I'll fold
>> this into the next version.
>>
>>       mm/zswap: Fix global shrinker when memory cgroup is disabled
>>
>>       When memory cgroup is disabled, mem_cgroup_iter() always returns NULL.
>>       Therefore, the global shrinker shrink_worker() always takes the !memcg
>>       branch. After MAX_RECLAIM_RETRIES empty walks, the worker simply
>> gives up,
>>       so it fails to write back anything.
>>
>>       Therefore, when memory cgroup is disabled, fall through with the !memcg
>>       branch and shrink the root memcg directly.
>>
>>       With memcg disabled, shrink_memcg() only returns -ENOENT when the root
>>       LRU is empty, which means the total pages are already below thr.
>> The loop
>>       then safely bails out via the zswap_total_pages() <= thr check. For any
>>       other return value from shrink_memcg(), the loop is guaranteed to
>> terminate,
>>       either after MAX_RECLAIM_RETRIES failures or once the threshold is met.
>>
>>       Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
>>       Cc: stable@vger.kernel.org
>>       Reported-by: Yosry Ahmed <yosry@kernel.org>
>>       Closes:
>> https://lore.kernel.org/all/CAO9r8zPVzMKFbCixxD-qgtRrkFxWVrHiZZeLc=eyTPKPVQgX4g@mail.gmail.com
>>       Signed-off-by: Hao Jia <jiahao1@lixiang.com>
> 
> Feel free to add:
> 
> Acked-by: Yosry Ahmed <yosry@kernel.org>

Thank you for taking the time to review this.
> 
> A small nit below.
> 
>>
>> diff --git a/mm/zswap.c b/mm/zswap.c
>> index 4b5149173b0e..9d4f19fc440e 100644
>> --- a/mm/zswap.c
>> +++ b/mm/zswap.c
>> @@ -1361,11 +1361,12 @@ static void shrink_worker(struct work_struct *w)
>>                   } while (memcg && !mem_cgroup_tryget_online(memcg));
>>                   spin_unlock(&zswap_shrink_lock);
>>
>> -               if (!memcg) {
>> -                       /*
>> -                        * Continue shrinking without incrementing
>> failures if
>> -                        * we found candidate memcgs in the last tree walk.
>> -                        */
>> +               /*
>> +                * A NULL memcg ends a full hierarchy pass (except when
>> memcg is
>> +                * disabled, where it is always NULL: fall through to
>> the root LRU).
>> +                * Count a failure only if the pass found no candidates.
> 
> I think "last pass" is clearer than just "pass" here?


Will do.

Thanks,
Hao


