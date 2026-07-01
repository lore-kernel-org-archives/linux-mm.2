Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D31DCC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:36:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8772C6B00A6; Wed,  1 Jul 2026 05:36:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 827CA6B00A8; Wed,  1 Jul 2026 05:36:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7404D6B00A9; Wed,  1 Jul 2026 05:36:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4116A6B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:36:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CB91C1C6DEB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:36:19 +0000 (UTC)
X-FDA: 84939702078.09.DCA6706
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf31.hostedemail.com (Postfix) with ESMTP id 02E9E20002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:36:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sUuGA1v7;
	spf=pass (imf31.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782898578;
	b=ay3iaM5FxiZxdsuF5zRuV9UUzyCpBlK/7APsmEAe809qwlVXCnKKHFyNEfNBn+rymDZTds
	3JD7/IDZNp1aui3RuD1XQnC69WGHLQPC4jgAgLpQSjeSB1D2tDFMea4wX6VGN7C1cfQyOg
	TDJXVv8M+WOyXcslqpwj57KTTBfshiU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782898578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RZ1T1yMzReBxlyUrs6yfTSt/QEbowwV85eIIRt2ArQ4=;
	b=UVubJayz9I2ZySFyRgjr3xXqsccagRV0mGjpIU9YT3oZFgZvW/B1eUb3JJVfnlomg9JJMh
	X4edtFMA8MX/kO3TYdH7TO0/ktAKgPxbGsOUgsrdpseO3VrVX3TwYh81WxYIGvLUoilXpX
	W7iWAAfD6V3yMdGwIV3r2B54RgooreU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sUuGA1v7;
	spf=pass (imf31.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-37f7a5a217fso304586a91.0
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 02:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782898577; x=1783503377; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=RZ1T1yMzReBxlyUrs6yfTSt/QEbowwV85eIIRt2ArQ4=;
        b=sUuGA1v7vBUYhR0kErhqH5f1/NzmqrzEYcBozc8QxxsKUaa/ifXlhpTE4olP8mOs5J
         uL6ruP5s8rE2HSRM4sjySdt5tVXhLC71/4MNR14VF7AeGCfh7yaiVmPYPl4aBV8ztrA7
         MBbGGPn6x309//ty8bpsHOl05fmWOU1APLHaJenCyKl4BccfSBuyHeyts4eheHs68aJW
         DjuieqG/Zljn1wiWTJu8E8Whfc9OTsLwYD6nD6NWcZ67UeJkr5dMJuvtjnYTswJmaV4J
         NRDzeiRNu++e9H+Nxtr5IHMmGRCBrOUWOr4IL13hupABmOng+gR5rMfgSDSzmRDWHD8d
         gwBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782898577; x=1783503377;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RZ1T1yMzReBxlyUrs6yfTSt/QEbowwV85eIIRt2ArQ4=;
        b=iTUaANoYXcVw4CnW7nqaCKLnt7+F44XvYFkAfom7GsrA7neJCmoWi0fgu8iAVTBhSy
         qiCxcuLjbhg/NqIikuY0NtdlLmlmGwZ1hZFcsbumwbY138jmjKfXcQlbXB63FYDdtQdf
         6BMY4V+2WJCM+cLRyvlGjLN6H5G7DmNGE5p3+N6xfSVF8LNwy/JqEkJG5Vcbmsiz636d
         EK0/PYiZKfFiV1OcO2uZKAM0/0W8oNZ6/F/l/woVqYhUybc5LvXuyPWn5AyRdVYRMj9B
         hCo9yCE3BkUIYO3bN9MyugObpfwlc6GAxJKdXo2BV9qHr9oJ2WnPXOP+ipKMt2AdtphR
         Gsyw==
X-Forwarded-Encrypted: i=1; AHgh+RpyRbQah/oDjHB3GaApnGLpy45VLkep4WrYOj5LeEWgfzf89ke08pLBru9GSapd/j43KH6YPO7KqQ==@kvack.org
X-Gm-Message-State: AOJu0YxghnupPol9xcZGn6Y4Vs9FCBo5GszDgxgVVDqNI70VYlFnfwe6
	RKdJvC8NXd0Up6DipaZXRtyI4TMn4OyA1vIG9xfwqp5JVkvkb7T0X719apmjtw==
X-Gm-Gg: AfdE7cklENzabZar+a/5a9Bk522uYl7rlWR+gYl9+urMtOcvAOitmg9cweB9yVcjMC2
	3gmVkyyb9jJQ/9+9KthsmEP2mIWjGEHNrEC/gXMnS3I4RiYHQAPOWaWij0ugDdqttuuVlu53nGr
	H/xVUs7gHCYrg13JI5YCnWEITp45KTcQpyrDENROMXGSCkbwpZayBe9yHCUo/kmQ4tPeqTEgJ47
	W3hOYwrxVRdDLKlItnG2UBYpOdFvOsH4NTYhOyx4Ea7Fvm8IYFX1pLSpz9/qT7HGqg9Z5qPNXYs
	xM1/zOZQaYfxFfHpFSRtcZHbuI/71Ajcij88StTAv6MYzGBbcJwok7B/ta6r+FZO3kxKgeXQT0K
	kC0cAAXNQi3FmgSzzp487xSTGEZPax40loZdZacXW4PhTASDekwcAMvXkYBsOetjpWIQvpsKt5W
	uA3LvojJHRa5SFBP6EtcXOyoAs/WJwXh91
X-Received: by 2002:a17:90b:2687:b0:37f:caeb:69e3 with SMTP id 98e67ed59e1d1-380ba8fb076mr96356a91.23.1782898576891;
        Wed, 01 Jul 2026 02:36:16 -0700 (PDT)
Received: from [10.125.192.77] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38097da4c32sm717511a91.2.2026.07.01.02.36.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2026 02:36:15 -0700 (PDT)
Message-ID: <a1c139d9-08b8-9631-7a85-697df4c23d52@gmail.com>
Date: Wed, 1 Jul 2026 17:35:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v5 4/6] mm/zswap: Implement proactive writeback
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
References: <20260629112032.20423-1-jiahao.kernel@gmail.com>
 <20260629112032.20423-5-jiahao.kernel@gmail.com>
 <akMJ8UfeZXrVe5LN@google.com>
 <cbbdf506-b67d-193c-2c94-bacf828d559f@gmail.com>
 <CAO9r8zNCEis2QHROEsM5QZsb_H4ofNjA_sE-pM7SVxtgHg_rqg@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAO9r8zNCEis2QHROEsM5QZsb_H4ofNjA_sE-pM7SVxtgHg_rqg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xei3ubw7pq63npg7o99w4a8saucjz6is
X-Rspamd-Queue-Id: 02E9E20002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782898577-352289
X-HE-Meta: U2FsdGVkX18JF2lZjlhPX/Ndoof0XQLtjOYQuJn2Bme3mf2m8Z7ANcV7AsNi77oUEvoOkDILCBK7O+zS5Vdb5PZjZOAbKGSJMBNmaWFd9WXdF8SFZc/L22/09lx4Q3vRwVLCnh+80hOhmG/zamHp4dh+d+jIzdQ/+pLow/pn1OOA+399tgzS0JBLKp0s2FxA9r62eyGdvxqnuCJWyuMNIPLmZug4A4DVysLTyGitj77mHNsmzRfH4A2SwsePzcSt0JN6NrwzvsD+2IV5Imxty2uszwHR6U/6NYpVpMt07JI8PwInOs+Rs0ZuSxwEsXB+Y0iloYJ4tSe2EwVdoIKggrWlbYtd7XgKVrAqBewgNOas3lyrcYm2E3/GGlWy69VqE0OdhcmFWG01+TetLMKvJ9XT3zmnrVcE3+JDWy/bu3kjTUhqieBLkD0Cu4fjQEWa4GzgwD3YmntWy58SiIofWTvK4FoSS2z9yKVPki3V1jOoUXEJlNTI5Oy+mIneT8Imcp7VaHcKX3H3OzDXbyUiGp2BV6q8m60i1iOUse3aaF10LmL+s0PRqO8hNb1OH4Xl6nTc0Hxs05HDL7O/mofZ8SSCRfjR/sPjqUMonD3a9J1XyzYvtZsCcwVvrdD/yzcj3dvi4NoasmP65NcS/qAZDA88FVliMvx3euj3bx1NiF2apGg3M0UoYel9Y5IAt3x3ZlRkBPhV+PJxHIiEj5YaL62tnv6UuQWH/Vzh5pQUn/BNeAgLr0/luJAwKTiNclfmUJ4v1GKxcdwzT2xavLKGHy+vg/VBkCTqvFXGsskuON7dxug1W6l8Bdjc+H9gP4kcPhRBdp54UhZu3dVHqN+bRwznOLbIEYTXuf4mXxSuDTWocB6ZAMoYNWSLwh4O13auRcHDdNxczDOT8pLVLs168gF2gfSEvD3i0pONoozq5QUO9ho6jkxdu5CSxhCDqY+HWK41Z4IZtSFWWaIvRNY
 F/0yJYtM
 1uWxE/g2gR9M9+69+gHxyiJs2nvteZQYWBd/gMZjWFSr+Lk6naI3vS9dUbEyeeaSwTrfITL9k48O4C+e7XqMOq1DDQMuYiDouFlCG7ouUAiauRwbADmssoMCbmp83n/hjLxQbMnipDoENk2aFwsFvrujRWiVJpjjjtTGhzbYRZ3Eud73wDNlGbLOUu1HPHqufi/VZllIoetbHf7IbU3j47OJ5Vpe5rVM/VnlKEFUtRE4/tuox+/xDvM5dtZSmWDaOvkgf8v2SbS2BMucYwyLsv5lXEBOq9GEXcH7F474aDOz8JSjfN0d+wKLge4L5zi8ZMo2A/WP6ftGoHMO496ypI6xsuXMfw/b0HzdKJ+J2Tw7wypGT3tvJ08rGUPKTIG/UcFR1C8rOYlFLRG/rZI5GFOGDT1zjpBuAU2BNFRjSaDFZZOzWBHDNCh3I9cnFuSW9SHLpDpZbeN6xfjLrqrYPR/gIIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/1 00:10, Yosry Ahmed wrote:
>>> Before going through more versions we need to figure out if this will
>>> pivot to be a proactive demotion interfcae for swap tiering.
>>>
>>
>> Yes. Should I drop patches 4-6 in the next version and wait for swap
>> tiering to be finalized?
>> We can try to get the non-memcg parts (patches 1-3) merged upstream
>> first. This would also give them plenty of time to bake and catch any
>> potential regressions. Thoughts?
> 
> Patches 1-2 can be sent and merged separately, yes. For patch 2,
> please include some numbers for the writeback performance before and
> after batching.
> 
> Patch 3 does refactoring in preparation for patch 4, so I don't think
> it makes sense on its own.

Will do.

> 
>>>> +int zswap_proactive_writeback(struct mem_cgroup *memcg, u64 bytes_to_writeback)
>>>> +{
>>>> +    struct zswap_shrink_state s = {};
>>>> +    struct mem_cgroup *iter = NULL;
>>>> +    u64 bytes_written = 0;
>>>> +    int ret = 0;
>>>> +
>>>> +    if (!memcg)
>>>> +            return -EINVAL;
>>>
>>> Can this ever happen? It would be a bug in the caller.
>>
>> IIRC，Writing the following to the NUMA node sysfs entry triggers this
>> check:
>> echo "10M source=zswap" > /sys/devices/system/node/nodeN/reclaim
> 
> Oh yeah, I forgot about that one :)
> 
> If we keep this, probably combine the !memcg and writeback check below.

Will do.
> 
>>
>>>
>>>> +    if (!mem_cgroup_zswap_writeback_enabled(memcg))
>>>> +            return -EINVAL;
>>>> +    if (!bytes_to_writeback)
>>>> +            return 0;
>>>
>>> Do we need this? I think the loop will just never enter and
>>> mem_cgroup_iter_break() will do nothing.
>>
>> Will do.
>>>
>>>> +
>>>> +    while (bytes_written < bytes_to_writeback) {
>>>> +            long shrunk;
>>>> +
>>>> +            cond_resched();
>>>> +
>>>> +            if (signal_pending(current)) {
>>>> +                    ret = -EINTR;
>>>> +                    break;
>>>> +            }
>>>> +
>>>> +            /*
>>>> +             * Use a local iterator to walk the memcg and its online descendants
>>>> +             * in a round-robin manner. Upon exiting the loop, mem_cgroup_iter_break()
>>>> +             * must be called to drop the iterator reference.
>>>> +             */
>>>> +            do {
>>>> +                    iter = mem_cgroup_iter(memcg, iter, NULL);
>>>> +            } while (iter && !mem_cgroup_tryget_online(iter));
>>>> +
>>>> +            shrunk = zswap_shrink_one_memcg(iter, &s);
>>>> +            if (shrunk > 0)
>>>> +                    bytes_written += shrunk;
>>>> +
>>>> +            /* drop the extra reference taken by mem_cgroup_tryget_online() */
>>>> +            mem_cgroup_put(iter);
>>>
>>>
>>> Can we just use mem_cgroup_online() instead since mem_cgroup_iter()
>>> already graps a ref?
>>>
>> Will do.
> 
> If you're looking for another cleanup to do, shrink_worker() should
> probably also use mem_cgroup_online() and avoid taking/dropping an
> extra ref :)

IIRC, this might not work because zswap_next_shrink is a global variable 
and is accessed outside the lock during reclamation.

Consider the following race condition between shrink_worker on CPU0 and 
zswap_memcg_offline_cleanup on CPU1:


           CPU0                            CPU1
spin_lock(zswap_shrink_lock)
memcg1 = mem_cgroup_iter()
   memcg1.ref = 1
   zswap_next_shrink = memcg1
spin_unlock(zswap_shrink_lock)
                               zswap_memcg_offline_cleanup()
                               spin_lock(zswap_shrink_lock)
                               css_put(zswap_next_shrink)
                               memcg1.ref = 0  <--

shrink_memcg(memcg1) *maybe UAF*

Thanks,
Hao

