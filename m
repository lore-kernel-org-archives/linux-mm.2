Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 633D8C54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 07:25:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC7466B00B1; Fri, 31 Jul 2026 03:25:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9ED86B00B3; Fri, 31 Jul 2026 03:25:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB7AD6B00B4; Fri, 31 Jul 2026 03:25:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ABA8D6B00B1
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 03:25:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 33D4EA0387
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 07:25:55 +0000 (UTC)
X-FDA: 85048237470.08.0429BA4
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5B9C1A0006
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 07:25:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NkIiWxhv;
	spf=pass (imf25.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785482753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V1iIJadxoIBnwpT+OgXeZPORL6qjCPJ2u2L6lNdVtGE=;
	b=8JQgpaujFRu+2BsP6AH6x/kayOqcwosSusO+qp6B46Ho2qAQ+yZwbmhibvtt/1sNI71wVn
	c+8kmMZZwQP+rAhSZoclcJtvJ5+0PFETzXxkcwkVIT2XNxZ0/fwBXwrbr0U9Mq35O6cZ6D
	ntcZqLkEUcrs2boyQGk/B/r6GeqEmLQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NkIiWxhv;
	spf=pass (imf25.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785482753;
	b=xlt8ZY9LnolQCp/RlQg8BY+hi5zKQ1+3lzUNXSdc/3KgZ4hMDS5q7V0BpG30mjm3Skr2Mz
	q27rP8Pn+8tewsTSic+A4iG1aT9KLBIR/6KcNVTQhkAOLLCggnJ2K9MGfBuvVPBt93eRhZ
	2807tdRp+H4rDyMFESumXlz9NhZHYpU=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c9eefcf9175so551093a12.3
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 00:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785482752; x=1786087552; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=V1iIJadxoIBnwpT+OgXeZPORL6qjCPJ2u2L6lNdVtGE=;
        b=NkIiWxhvcC+N6nMP1Pv8IV8TA+znARW1Z20AGEo3jdslf1bQKI1WpvFOkC2RHkjmkk
         2/jnMHUAU4NPL2f6Q22RnQLf8C5HDM9buM8MylTtJebk5pm2xKadw+jluOyiV+P/VWY6
         q+f2hrVOdR2Ou4RWp6t2CKPFELWmurGRlmyHyC/PqK9YZrdIMXXTaMhBcIzTc+xmpBNw
         xq31x6W1z7xAwGFr45XYES8Hv0age86Na/t4gbVRqtNtppJkluDjXN9VbH2FG1j8K8Py
         ePkNlfa+leecXC8K/YsEI8+tgqtxkwAfWqwuUadg59TfDAh337g37J81T42xsbZkf/u+
         Fj7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785482752; x=1786087552;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V1iIJadxoIBnwpT+OgXeZPORL6qjCPJ2u2L6lNdVtGE=;
        b=UJE6XPz5UmQ0hIB+ray6jzuDEDDyeufN0esA9bL//dq+WV0TuKBS0Ne4SqMCVKob/s
         j+zc+WWm440Uv4CfA/GZCowDIeiPlKoxc0AisU28+LuhZn/0Q3QSa9IvsQyY13JJpCk5
         FrVfNoKU4ZPRhzNPysjMADkK31xCc5qVXS5n/Hq+zQdKi92pPRxM/wrjhWZ919ceY6i+
         DAmTd+vMatn+hiXZdpdjoKTfcHFwuS+CBK8ycKCHA0cJVL2nCk+N5QzCrt8bQU4xC4+s
         41qZ7OUj9ZsFbMUB8DJCKo9kpSBFr9MoIb5jkiJ98BU5+36vgAiOgFHNQNin8dWBwh3G
         oHxw==
X-Forwarded-Encrypted: i=1; AHgh+RodCifjYfx1cUMsjps7JvITWgzunkk6893Qi8CC95DeLpfOYU7zxONYAcg66TJa2CPo3lHZSYReDQ==@kvack.org
X-Gm-Message-State: AOJu0YzL5Aih6WlfVQa7IKoc+U/cGvj7vPnQt2T6VacUHhJD6Ufqbpew
	BLLfUC9Z6E2y28Kh29P5fE5AUwujtcvrKR2YJIG8kZsazBuRsSFVO6tT
X-Gm-Gg: AR+sD10dF/WO9+FRSkasWJ86D6I6CM+TITdyERVvwsqReKFcsW+2cvIzBa1BOXtmeK0
	T66MU7CIQz8VG1ltI7BRuHRI9RJQnp0sYCRjeE40ZBRhqi1vscYCRc28tpNzt3GpX7iJyLsfdlI
	DyVyHpamFZCm18OUJa+1MOMoZ9JlJInQ8jtYRH9vN039w9j8NtDvjjE6176g+GOijQORg1OuAV1
	Kb20H9O+7ZSt4dsQCUq6p5iJuokLUzua7Q+X+EBKG6e1A9XTXFqZZ4Oz1gWaqo4CS5ucJAgIJMG
	Qiw/Xssrl9ns9zLByL4tDRIEtjuLHFhGj/BI1jPYH7kVvajkJxkvV7pG0Dny+7KCCwMQuJ529oy
	ZIgxqIxa+ObX0CBMEBv4HF8h4+uuWq/6TO7KlGetYYkizbq26hHkyW2RKW6xQoRk9aLDB4vrv9c
	nQP3dm5yNR9aRAQGeaghOjLcDJ/9/et117ihTkW5WW32o8zm4CQCR3dW/dAstzVsDOIdgkCnAlD
	RkCHw+21w==
X-Received: by 2002:a05:6a21:62c7:b0:3c3:64cb:9b99 with SMTP id adf61e73a8af0-3c91b0de414mr911570637.6.1785482752052;
        Fri, 31 Jul 2026 00:25:52 -0700 (PDT)
Received: from [10.125.192.117] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe3963e2aasm225078a12.2.2026.07.31.00.25.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 00:25:51 -0700 (PDT)
Message-ID: <a2ca877d-52a5-15c5-b70e-2f60284d6bef@gmail.com>
Date: Fri, 31 Jul 2026 15:25:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v3 1/2] mm/zswap: Fix global shrinker when memory cgroup
 is disabled
To: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
 tj@kernel.org, shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>, stable@vger.kernel.org
References: <20260729084206.77793-1-jiahao.kernel@gmail.com>
 <20260729084206.77793-2-jiahao.kernel@gmail.com>
 <20260729155858.c7aabff48166a9bca4d68ac3@linux-foundation.org>
 <CAO9r8zNhBCghP8T_98z2p==Cfs_=kamcRN_3ROxaj3R8PN2Qvw@mail.gmail.com>
 <c4c95102-72e2-a44f-f16e-4134ba6bb060@gmail.com>
 <CAO9r8zOSTYC3D_2CxapgvXGaZRUdnGetPGz2XgdUO8OygfuEiw@mail.gmail.com>
 <amufiuAaZbuDdKkQ@cmpxchg.org>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <amufiuAaZbuDdKkQ@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5B9C1A0006
X-Rspam-User: 
X-Stat-Signature: rwzcp99c5qofb8746p1nc3fewunnp5z4
X-Rspamd-Server: rspam04
X-HE-Tag: 1785482753-728005
X-HE-Meta: U2FsdGVkX1+1QXxHTao5TgKdGbkLf+YZtJ9Zf9oXqODEfIUx1x32P9whDzx6jM3HMQlCsaCWqR8by9+FLSXI0WiuUTy8bGm37XVPwFC/iI7zJ2eMi4835V9u0NxQnGkXpe6TfOuqtxdgF5GLf8knPEkeYwsgz0hSkNLpkTYndBHiti9IntFxIoRDEWk9KprQKhihZlZs3ASutMSrZverobwwxiprORp0XgWzduG/wJF31hiVhWZhQ/niR9M2In3o7gEbaV1kHDYVlMfitPKMxkF7u8OlcL3A/H0NATJBKIBMA1zwyATC9ER3beWK5gzlJGnbSVbBeXUFi/3jS3eTqx7sKFh9rL1A7VxQ6kwXYWs+IPhqZMy6yXTeUtf1Rab/Vg/peoL/a0eMtBOms/r9Kfg9/+/CF+wV+Jmqen9dLA1Bu7REXOkk7DYuOOCRXOFOaxoMd1jCjAB2qNLtaKEPrNaxbh1YpsosCRGBcOktke+4ajO/0hdomDkeuUyVJKm+YuwKOcbfw9uqID06XC4PL8Zb/eo69h/ss827a/6/nQpOPx3e/zA32DNxuW/Ky4mLTUMapaJc3FbqA78tcSxSBiMEFxfj9EpyMId7JXoollbGDN8l2JEDG8WwTp4IAbADznvD23ZQ8TZrHM5Cr7glC9EfhlUtt6njTPB1gLkavvnV6AO38GqYX2kE132deefIGysFv59+7IWXIQih8Bn0NiLjnmvPQ+D/p9q0BEt3OXfOJaL8tKJir7glL03cAwSQPWz7RETCqGjdPsYWlKAvG4cCAfrW5l6yLASZGknvbXEN0RWPSoAvPcjgz2vhvw5Biigm1RpB2UAg7pokQMPyKTVbDw8Km1Sa009ogfoS13TI33qw96WRtD0FkkIuNLDj8sgec1vRPO6ahmZ34W9z9y/SZhZ2Mj3+XV8ZuuPIbQ2luztJry1f31gV3SPC4pRanJOaFt4F2MDRFWR+BtZ
 LUa07stC
 hq53Yo9Dqq8hPS3LjTQRClMgkMUdfxpe2X13xpuy1hrEGR5JWqfBoMMnZVaykXUKrhhPqvCZd3HUsfjvdssIJG6W2HWoyQ7DdFOwn5G/2NTTuH8ByrHpA0ESHjMTBhLyjOZxbdxdVK4hoWEded6pwiRLSTOJzs/ErzeB0sPZSrXhvfgLvo4IymqsbNGPr8cOP+FacC4pLg7SkFjH/RAWllrRaaGjKfBA7lepvsVG8wPHzEBfYX5JIR3+sU/py0dkVUkV7dND1PjgUv2pLEfG1ltHLxwvPwVVmbbHJN2wOADA0h7iVq7lxx4ZblBiogWCD3NNVdRVO29xIVw5lengLEYlwyEhT4s5Tzh3IH4StgBgmOG83ddgPTtpm8vrBthNXg1opjWarw+B4zWh3fhiq+pWm3tWiOp0XKw+AyRC9OtHVL6rB4K6VXJSDnwGyJ1CUmJgA+oP4yPzmi24KzkkKpTGpqoYt/v1jYsGRxyFKWSE7Q3oBaa6oZE7JTaF31f6p+YUq5X8QRjSchUhOpVAhgV4FZfSMtjNsr4lC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/31 03:01, Johannes Weiner wrote:
> On Thu, Jul 30, 2026 at 10:48:38AM -0700, Yosry Ahmed wrote:
>>>> Yeah, it isn't. Probably we should drop "Closes". I assume Hao added
>>>> it because checkpatch annoyingly complains if you add "Reported-by"
>>>> without "Closes", so Hao just linked to the thread where I pointed out
>>>> the bug.
>>>
>>> Yeah, checkpatch will complain if it's missing.
>>
>> We often ignore checkpatch if it's unreasonable.
>>
>>>>> AI review asked a couple of questions:
>>>>>           https://sashiko.dev/#/patchset/20260729084206.77793-1-jiahao.kernel@gmail.com
>>>>
>>>> The review on patch #1 is something theoretical, we discussed it at
>>>> length in previous versions.
>>>>
>>>> For patch #2:
>>>>
>>>>> Does this batching logic break NUMA fairness?
>>>>>
>>>>> Because for_each_node_state() always starts from the lowest node
>>>>> ID and breaks when the scan budget is exhausted, subsequent
>>>>> calls to shrink_memcg() will restart at the lowest node ID again.
>>>>>
>>>>> If the lowest node (typically Node 0) consistently has enough
>>>>> items to exhaust the scan budget, wouldn't we exclusively evict
>>>>> pages from it while ignoring older pages on other nodes? Could
>>>>> this cause LRU inversion across nodes, keeping older pages in
>>>>> memory on Node 1 while hot pages on Node 0 are evicted?
>>>>
>>>> Yes, unfairness is possible.
>>>>
>>>> For global shrinking, it's probably not an issue. We reclaim until we
>>>> hit the acceptance threshold and it's very unlikely this will happen
>>>> before iterating all nodes (given that the batch size is 32 pages).
>>>> However, with the shrink_memcg() path, we only reclaim one batch, so
>>>> there's a chance we'll always reclaim it from node 0.
>>>>
>>>> Maybe we should just drop the early bailout and accept potentially
>>>> doing more writeback than needed. Hao, WDYT?
>>>>
>>> If we scan and attempt to write back SWAP_CLUSTER_MAX zswap entries per
>>> node, it might lead to excessive writeback on machines with many NUMA
>>> nodes. Furthermore, I'm concerned about introducing higher latency in
>>> synchronous shrink paths like zswap_store()—especially on systems with a
>>> large number of NUMA nodes, where it could end up writing back hundreds
>>> of pages in a single call.
>>>
>>> Maybe we could do something like this instead? That way, in the
>>> worst-case scenario, it falls back to the baseline behavior without
>>> introducing any extra latency risks.
>>
>> This basically errs on the side of honouring the batch size
>> (under-reclaim) instead of doing more writeback, right?
>>
>> I think I prefer erring on the side of doing more writeback, as it
>> would ultimately result in less LRU inversion, and we are already
>> doing writeback proactively during reclaim through the shrinker.
> 
> Yes, LRU inversions are worse than reclaiming a few extra pages from
> the cold tail of the LRU. It's not cumulative after all, it just means
> we take a bigger bite and can take more stores before the next shrink.
> 
>> The other option we can explore is keeping the existing logic with the
>> bailout, but start iterating the nodes at the folio's node in the
>> zswap_store() path. Basically pass an nid to shrink_memcg() and always
>> start there. This will avoid always reclaiming from node 0, and the
>> node of the folio being stored is more likely to be under pressure and
>> need the writeback. I am not sure how complex this would be and
>> whether it's worth doing.
>>
>> Johannes, Nhats, any thoughts on this?
> 
> What happens if simply we do a hard SWAP_CLUSTER_MAX on each node?
> 
> With cgroups, we put the zswap entry on the list_lru head of the node
> and memcg where the incoming page was.
> 
> So if you're going after one specific cgroup, it's not like you
> *actually* reclaim 32 entries on each node of the system. You just
> write back from nodes where that cgroup has entries.
> 
> The global shrinker also does one cgroup at a time (zswap_next_shrink)
> before checking the limit again, so that's fairly fine-grained too.
> 
> Without cgroups, you could have zswap entries on all nodes. But if you
> have so many nodes that this would constitute hundreds of pages,
> presumably that's still a drop in the bucket compared to overall
> memory capacity. SWAP_CLUSTER_MAX isn't that big a number.
> 
> So I don't think we need to get fancy. Just do SWAP_CLUSTER_MAX on
> each node. Delete that nr_to_walk carry-over between them.

Thanks for the input! I've posted the new implementation—please take a 
look when you have time.

https://lore.kernel.org/all/20260731071900.38942-1-jiahao.kernel@gmail.com

Thanks,
Hao


