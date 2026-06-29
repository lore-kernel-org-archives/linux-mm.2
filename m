Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8F79C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 11:37:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86EBB6B0005; Mon, 29 Jun 2026 07:37:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81FC26B0088; Mon, 29 Jun 2026 07:37:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 713966B008A; Mon, 29 Jun 2026 07:37:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 445C36B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:37:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C2C021A0691
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:37:08 +0000 (UTC)
X-FDA: 84932748936.18.994C57C
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id E1C7D120002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:37:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KDTw5q8J;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782733026;
	b=jSOi0S0tRBbs4DAP7EdgyC4m/8lw7f16nhlmJbgc6HYpV57uBmIV0LF4OsqKyYBS9mIgnL
	F21bQuaX8Ep/f7XxkUh9bAIIPIlmgno0EOO/+q9Jl02zz92Yt5TKPa5NIn+I9BHvSro+SZ
	OGjpdKEE90mbchbXrOzxEoUHJhNY7EY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782733026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+TUP1LM09mE01dTMgP9xd0rTmvGkZOWNWCmE4JCIidU=;
	b=Cn6MGHMYQt5p9+wAaA0dzOeEaLFu3JRv9g/XN4IE0Zd19q2PpzlDyLG6Xt1GwYqHaqn1oG
	Q0O2H4P93ojktYx1Bzrk+B+cDFp/B5kqCMXSbjXjq3PftfTLCRRRmNAC7nAoElFCfqiirF
	cWM9Wog4BHmg1m0vUsUXyj9d+IV+ol4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KDTw5q8J;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2c9cb97e178so13230315ad.3
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782733026; x=1783337826; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+TUP1LM09mE01dTMgP9xd0rTmvGkZOWNWCmE4JCIidU=;
        b=KDTw5q8J2PwOjhP7mJCdwLMi3ub+xL0pPybdG2vCmaR/C5DEmmGorygjjaKNTJlYln
         Zp8M0SKvT+TLKGq827N/S5Ai02ao5rPqvQztebeGPz8MJnQT8yeqe+hPxYVoUgxsO8hy
         dk9KQQhde/GoOTnwYtlQ/ecIsOEIfljgJlOiY0XrHLao/DkOxJzQ9f06x0WABBrcbnO8
         YOiubb+vn9ZWxnYaAorwh/BTC0TtytS/aIHslItlMAO1WKmyoF2Ja2pDTz1hMny8ST+2
         /ZWdq7QfGuJeQ01EeQvvb7KhxtyjIByPe5wtUGIX3YiGxZPgi+Gw+czuEmLs1+QVd1di
         eRFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782733026; x=1783337826;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+TUP1LM09mE01dTMgP9xd0rTmvGkZOWNWCmE4JCIidU=;
        b=J/gGCPeISXnokvlES8pElWxCfesXwXgQ6bzTBFtA8x5kH7PUNpZMVHUrg4mDng5Jc2
         RvLiublWfBhEfr3ubyAP+Bpfv2FlzS/6J59bxAzviWR4ZcJ3CCa4jYpBKkLLPgvJYLPV
         8Bu7dZ2PON1PR+QRSVXcPjm7QvRmuqo+y/8Kw3cBhjDR+TeqWEqDo56MDlyZdsdXzi0J
         CJEhcXqomsWwGLHwtkt+9PkijTkKbaiEYYDJVGOw+HZOHP4q+bvfD0+06VHuufn87vlO
         SyCZxUTgJEHrRh2NJr68WwGk+D0Rsp9Gv0tbnS4Q2vE4EEJJijSk18ar9yNQ6M6ei4dW
         BP9Q==
X-Forwarded-Encrypted: i=1; AHgh+RpzjPD1YM+E700GJbYjBNNZCYgF/e+9/2/b+qrBgUH1Kyfv9dcsx7WPSgVeIytyYUOSueZc6xpuxw==@kvack.org
X-Gm-Message-State: AOJu0YwRwbydiSr9DIgA4OKTKCACjCx7tKpt83sd9JJydb89MtrBgFpZ
	n6FaV/kLNhf/flihewUzAedMHPqjfG6yEv3jUSvpbvZ97E885Q8VfipM
X-Gm-Gg: AfdE7cnYOYOM082bO/5IZ9iyNvdzacGTYOEaEEX2QqGJl+XuJgVUmQXNzUJnSZw1zSG
	don3OLDXxxnV379uqFyJtjyjyLN4GVDCbjoY5biK7f5PFw1UzQN1yAx3eSKh+kTAIfQ2gOy3DX0
	axVxDo7Z7JFwTGz6SDVPPxHvtFgpQIs3kq7IbrflsT+cBSfN6WBl8s4LBDt15ajVsQob6Nktdtu
	g4IDdzcW9+R5DCpF5ZbPf9+1SnN0tfaWhkgS+3fcKIttHfibvwwY3xvgxmHsJmsexLyUcKNMYIR
	7fUXk25tgdp1T2/Va4wTw4YO5QfONnGQOOipCUBps6WVZphZjL7Gut8xQnIqttBg5itB9vKMj9f
	TDJeRBiU+VNUl7oqMx9RUpIfDMyz1TgWoRE1dVM1DHkZ2V16NfpeshUnJrjajuV5ZY7YLjV/fFO
	NTSGbf7YHLjWrwnrwPfc7ljZire4tLKCt0
X-Received: by 2002:a17:903:b48:b0:2c9:e5ff:995d with SMTP id d9443c01a7336-2c9e5ff9c0bmr40545955ad.31.1782733025674;
        Mon, 29 Jun 2026 04:37:05 -0700 (PDT)
Received: from [10.125.192.77] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c9b43af119sm43120405ad.48.2026.06.29.04.36.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2026 04:37:05 -0700 (PDT)
Message-ID: <db3b3d03-61a9-1c88-4e8e-c9319b048626@gmail.com>
Date: Mon, 29 Jun 2026 19:36:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v4 2/5] mm/zswap: Factor writeback loop out of
 shrink_worker()
To: Yosry Ahmed <yosry@kernel.org>
Cc: nphamcs@gmail.com, akpm@linux-foundation.org, tj@kernel.org,
 hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org,
 mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
References: <20260618044857.69439-1-jiahao.kernel@gmail.com>
 <20260618044857.69439-3-jiahao.kernel@gmail.com>
 <ajnGTt8tkbAWX8Oc@google.com>
 <0916e673-861f-b472-7417-afbffbcc98ad@gmail.com>
 <CAO9r8zPSZLaqLXw87V3q4tZa8WD7xCympKqfLMLB+o-++GksJQ@mail.gmail.com>
 <91297bc0-268c-e9c2-57ae-6066eee5df2f@gmail.com>
 <CAO9r8zOYgjbuG5i+LrCcMK764nVpOS+muo-5Q45ZFdiVus-dTA@mail.gmail.com>
 <f1cd1ec9-48b0-1b03-0514-6c9958f3c77f@gmail.com>
 <CAO9r8zPVzMKFbCixxD-qgtRrkFxWVrHiZZeLc=eyTPKPVQgX4g@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAO9r8zPVzMKFbCixxD-qgtRrkFxWVrHiZZeLc=eyTPKPVQgX4g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E1C7D120002
X-Stat-Signature: hecqmwi54dzo4r4cobeaomf759npundw
X-HE-Tag: 1782733026-657183
X-HE-Meta: U2FsdGVkX1/FDUU8aaoP1Zvk7AsxGM3/nXEmRV9wPnWElA+OIu2jd2lnWfNM2fS4JF28IUHGRUr2M/+MjGsxbxW2CQ+2rDg/rtYYQ9EWwgONos8TCburajnaNnODBKp8EB1rD22MG8quu2FbNPeUlq69SVQZNFedDdTjxetzOHw115vmELRdX3U3r/tTFCfB10hddtQv839AvaAu6dSYyCSzGbEEHGk14iRKOM0u0IkW9Ihwf5qJnReaHssz7UVG87mjk7Bv3AOAiVtQe6it3Lr7i9YvHNjK0CDGjh5WDSjOLOWhapciV1Sg2ZyKvAGmZw431JymkzTKygm//fKzjyDUsTjJaxfcYbs0VvpO6GpfobpmvK1Yv2hcESBjjDtGYykRS/lt06vNK7yC/80PaMlZKkXx4Dk2nATU3ky9EOd1dPan90VBBxiv7/Ropp5l4mbWOhUjJaPsxRSfmmF3KsCAXLOpJqYPvJreVcH1DoiiXoNKLg2rf4xMyAOts68pwkFFC/YhxT93boWP5nrg6f8nKdApLqJOpsnRU2bZYC8BpC0oxghPOF+RZcnEJ73pcilnkDYvuzfktc5QBbiNyHV74t3MhVH52u6FT+NABNEtx///fwF5LvJ6OQ9gz1MS2FPkcVhZAOqNNnn1j4xmCmZGRzXdeSUD7d6L4WosEK9BnnLJJR9TKMIQjj9ca0ThNi/Z/GnOry12lLOA20b51GbA72qByUj9A9uxT9BYrilBQKC0YG2Ym8N/7Ewl9/gFDWty0jzzOq5Cra5lOC5Fg7pG65/Ze7I2WGKfXkuE/UePYz9v51Q3HyZygnKrnzu7e5XjYYRwA73jbQK5XYhTpkgTeOZIvEJZIK2bNz2PkemqZfW01xXxswidLZnsLcoKywPF0oeVJEbNlgiuXsW2kiWzTBKgTTpUWkIu90n0pT0NDcg44AQe/nErWsZ6dqtldmxvISEZdGhKCIEB0Bh
 gx2xckIG
 LUjl69x9dsLyI05SBUEUqnMOiBvj/Ia5fQn9Qhzy90iDPvxql/Wb45u4HjdxpfLMW7OKXxH1DCPmRXu32wAbea2LxZiXvubYKJ5c45Qvb8dNDDEiqJcLpdS+9afS2kre7ANFw1tRHHq/E7gTL5vvtCtdstnKgJkWfbh3G8B+L7b093mDDgubuh9KqKE4l1xAR0wvFbb17RwYCi5gV0xo/4my0eWwnD+z6LdvSUWcnwGRDFR/I8ra3qz0keY/iG+PUKu4Aa/wfG5l7B39m2Liv0QhJOG/IsNk3jQso55R/pMZNk4qoRyhkSij3d91Woq/7FA0jRJcZNXlNvIVf7S8K8y4MW19xy/LxAGkPZu5ahH2K1l9//v+U1pk56ETPhQFV1p9pMSy+yBynZsdgFk4qRpVjViZShbKZKStnhY0EYsq17Y4lr2I2r0cUWt//PQEk6HAJaF08RMKtrs1MA7ywY6lxulOpfSczVA75AkMroE0vu20l+vRQCLbbrlRbody7QszTHBenQf+6z3fr3zBtMW5M4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/27 01:09, Yosry Ahmed wrote:
>>>> /*
>>>>     * Take one step of a memcg-tree writeback walk driven by the caller's
>>>>     * iterator, and fold the result into @s, the retry bookkeeping shared
>>>>     * across steps. @memcg is the iterator's current memcg, or NULL once
>>>>     * it has wrapped around after a full pass over the tree.
>>>>     *
>>>>     * The function returns -EAGAIN to signal the caller to abort the walk
>>>>     * after encountering the following conditions MAX_RECLAIM_RETRIES times:
>>>>     * - No writeback-candidate memcgs were found in a memcg tree walk.
>>>>     * - Shrinking a writeback-candidate memcg failed.
>>>
>>> Orthogonal to this patch, but I wonder if this can be simplified. I
>>> wonder if these two conditions can be replaced with "shrinking a memcg
>>> that has zswap entries failed". The "no writeback-candidate memcgs in
>>> the tree" case seems like we should abort right away instead of
>>> retrying?
>>>
>>> Nhat, WDYT?
>>>
>>
>> Perhaps something like the following is what you had in mind? I've
>> drafted the implementation below to make it easier for Nhat to compare
>> with the previous behavior.
> 
> Hmm I think if we pursue this it should be in a separate patch or even
> outside of this series, ideally with numbers/proof that it's not
> introducing regressions to the scenario that lead to its introduction.
> 

Got it. I will temporarily leave this part out of the current patch series.

>>
>>
>>>>     *
>>>>     * Return: The number of compressed bytes written back (>= 0), or -EAGAIN
>>>>     * once the retry budget is exhausted and the caller should abort the walk.
>>>>     */
>>>> static long zswap_shrink_one(struct mem_cgroup *memcg,
>>>
>>> Nit: zswap_shrink_one_memcg()
>>>
>>> BTW, the existing writeback logic has been broken for a while now when
>>> memcg is disabled. I think we constantly hit the !memcg case and run
>>> out of retries. Not sure if your patch changes this in any way, or if
>>> you want to fix that while you're at it :)
>>
>> Yes, I'd be happy to do that. However, would it be better to submit a
>> separate fix patch or combine it with this one?
> 
> A separate patch. Feel free to send it with this series to avoid
> conflicts, but probably as patch 1 as we'll want to CC stable on it.
> 

Done, and I've just submitted the v5 patch.

[v5] 
https://lore.kernel.org/all/20260629112032.20423-1-jiahao.kernel@gmail.com

Please take a look when you have a chance. Thank you very much for your 
review!

> [..]
> 
>> /* Track progress of a memcg-tree writeback walk. */
>> struct zswap_shrink_state {
>>       int scans;
>>       int failures;
>> };
>>
>> /*
>>    * Take one step of a memcg-tree writeback walk driven by the caller's
>>    * iterator, and fold the result into @s, the retry bookkeeping shared
>>    * across steps. @memcg is the iterator's current memcg, or NULL once
>>    * it has wrapped around after a full pass over the tree.
>>    *
>>    * The function returns -EBUSY to signal the caller to abort the walk when
>>    * either of the following occurs:
>>    * - A full pass over the tree found no writeback-candidate memcg.
>>    * - Shrinking a writeback-candidate memcg failed MAX_RECLAIM_RETRIES
>> times.
>>    *
>>    * When memory cgroup is disabled, the iterator always yields NULL. All
>>    * zswap entries then live on the root list_lru, so NULL is treated as the
>>    * root memcg and shrunk directly rather than as a completed tree pass.
> 
> I think this chunk should be moved above the code returning -EBUSY
> when mem_cgroup_disabled() is true, and probably made more succinct as
> it should be obvious.

Done in v5.

> 
>>    *
>>    * Return: The number of compressed bytes written back (>= 0), or -EBUSY
>>    * when the caller should abort the walk.
>>    */
>> static long zswap_shrink_one_memcg(struct mem_cgroup *memcg,
>>                      struct zswap_shrink_state *s)
>> {
>>       bool disabled = mem_cgroup_disabled();
> 
> No need to store this in a variable AFAICT, it's a static branch and
> it's clearer to just call it directly in both call sites imo.

Done, and I've just submitted the v5 patch.

Thanks,
Hao
> 
>>       long shrunk;
>>
>>       /*
>>        * If the iterator has completed a full pass, update the shrink state
>>        * and check whether we should keep going.
>>        * With memcg disabled the iterator always yields NULL, so fall through
>>        * and shrink the root memcg directly instead.
>>        */
>>       if (!memcg && !disabled) {
>>           /*
>>            * Abort if no writeback-candidate memcgs in the last tree walk.
>>            * Otherwise reset the scans count and continue.
>>            */
>>           if (!s->scans)
>>               return -EBUSY;
>>           s->scans = 0;
>>           return 0;
>>       }
>>
>>       shrunk = shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
>>
>>       /*
>>        * There are no writeback-candidate pages in the memcg. With memcg
>>        * enabled this is not an issue as long as we can find another memcg
>>        * with pages in zswap, so skip without counting it as a candidate.
>>        * With memcg disabled the root LRU is the only target, so we should
>>        * abort if it has no writeback-candidate pages.
>>        */
>>       if (shrunk == -ENOENT)
>>           return disabled ? -EBUSY : 0;
>>       s->scans++;
>>
>>       if (shrunk <= 0 && ++s->failures == MAX_RECLAIM_RETRIES)
>>           return -EBUSY;
>>
>>       return shrunk;
>> }


