Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02564CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 07:16:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6BF06B0096; Tue, 23 Jun 2026 03:16:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF5C86B0098; Tue, 23 Jun 2026 03:16:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E4736B0099; Tue, 23 Jun 2026 03:16:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 706306B0096
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 03:16:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EE3981C53F4
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:16:56 +0000 (UTC)
X-FDA: 84910320432.08.D8AB60D
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf06.hostedemail.com (Postfix) with ESMTP id AC2CF18000A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:16:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jQrd2K6W;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782199015;
	b=wmaxEX3W6MWsoJh9OI2Kv6Zbu9HzOxFGu9CRSedvBXIY+Xeem3ePOQcP6wBRYYxIbQicIW
	A6IdG94V9IiaRBhr/4cT/3L+7OEl1eA4tVIKRZqq3KYZDTZkWZQgyTyDDrkbNsP4LcaRYz
	XUumU0bUL+IcewPb77nXkXZp8SQ6zao=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782199015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZ+uAaSGd3OZS1aU2uMCCmFDj6tXs2rYH2kiB6ZZtOs=;
	b=gVM5wXDxA4mi6liPk6A24h+thzbcaqP5a4SKlm4gHS0Vq/I/QPHdeAa0J9if/pdYKE5RbN
	yINP/i5BFBusS0EByootjs1Z5HGPOtn+YaS35f2Dc+tiK149pZcE+uR17frxYPFQD6o7SR
	Ensg3MKJwos8TiT5rIrh+jGPnl8NdsQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jQrd2K6W;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <d97128c0-7d89-4b5c-b891-84f9af702fee@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782199012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zZ+uAaSGd3OZS1aU2uMCCmFDj6tXs2rYH2kiB6ZZtOs=;
	b=jQrd2K6Wcjb+o/3i0dgciyF91g4QWNDhUnuaOH0U/WqJXuqyfCODDSAdXGvqwnfORs9/pp
	NoJIu+nDxRDWNjuYV3koTQWxNHMwTCB4948DzxfGQiXU4rgwzn1XJNWgfBp0ZlycHlj8Bs
	6FPTSMSFVXKDjpvJFk6zfgKzttDwzSc=
Date: Tue, 23 Jun 2026 15:16:16 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm: mglru: fix stale batch updates after memcg
 reparenting
To: Harry Yoo <harry@kernel.org>, akpm@linux-foundation.org,
 david@kernel.org, kasong@tencent.com, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, muchun.song@linux.dev,
 peiyang_he@smail.nju.edu.cn, mhocko@kernel.org, roman.gushchin@linux.dev,
 ljs@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
References: <20260623024237.45990-1-qi.zheng@linux.dev>
 <e74b0808-3bcc-414d-a037-41e479210cc0@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <e74b0808-3bcc-414d-a037-41e479210cc0@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AC2CF18000A
X-Rspam-User: 
X-Stat-Signature: x5z6465wiy14qmx6yaxrcxjqqr9wnydf
X-HE-Tag: 1782199014-614669
X-HE-Meta: U2FsdGVkX18I1/fbYGuFQlXGFvo+3JQ2jtawJR4YchrvfB59+lV3xiQEIJibzf3XY0CHM9NdEL7bvRh44o6K04//O36TeTACWAUoDq9YcxB20dXuJ3bshIj/1Tb+pj4VOPCyjTP+tTaTVaETTQHbryU0n7FGE5LqQUAOlEFNEgklI/d9TdAm1QLljYtk8shi685/DPlEAsj70GGgIfz7imtO2fl+e3XhrawTeKF2LA8SSmpYFAhWATjfVdTqYC+ThZYgS2FOUZFmg8ShZp44wIXgrgQS9+EEZuKzT+OnMVIxkJcLY+eIWaDSQj98vgHWAIuD1msCJGvm38dpMJBNPcjeKPg8d9kgdGEoeiHhIFdDEq5PAUTa7eCHF4r/KPIw3njWrNDuX8ap0AoMt3DlXRxo2IOQ9QrTCBA9EwvLkY7h3bXKGjB5B67x6GIlPuuNjtxRFZFtwMtpSh5E/zyH2c0nAWSY8jAk1+BapxXKj+3SIaObUwy8dRkWRnLTgKaFoEc0a1QMCpp1X6HCWqezBJ0OyCfGCsK979L+QTH+C/dwh7Ei+U0zGo4APHEJGacvQiljRHlAy3+MeQriypaOoBFR/e/BIfnukD8/Xsg2LdxMxlezZU2rps64c9FhKx6rq/ZNdfUgzIAigIySYTxzlAMv9lV/Szh1fyv+T1NJ+AZ/5tTEMNOFmpgKivr9bTEX3yaroL0FOzmcLhthu9hY75BTqzeFWXXEngO6+eWeLt7J0jgPIFUkT9N84bMnCKxhUb0P4QjzgrnhgA7+vD5QOS8oRLHkl2PuIHpB+vnOw/92O8P4GGw5RR0JuCt24ALh+xxh4IdWjykdedhEQN4Dr5wnM1E7+LFRKFs2HImNRWRdvL3hodUYDeOPgi7RaR3sHPCOQKaj+E8hg9IWRxjPnl/1yIuEjR7J4SakTLX2syT5475DChUZ0GkaFVPNwUeSgPRdBPwav7HQeajXVVT
 S1u5Kk8A
 N5mSod5sZfWmW5s9eqgPSzxQXi05JMW+n09caSZiirUmzQPghmULzinlpNQhfwQRYfo77xaWGGTqrrVeuoeSC1xf9bgCirMxix7Gm/vgyo3wpGOh2wZHPjUWKBMwsK/tG7jWVbdM4aW7l0vKVPp4+rCBvhWGC5D0X5zTcg3N7TfyOT5Rg5s7FuxlvGs/MMH3TxPcWbi4aHRq58wgqcI6nGXCZvZhatO0nXawZv3NxpbnV2ynzp3gBQFtro2E/msv7K1RR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

On 6/23/26 2:17 PM, Harry Yoo wrote:
> 
> 
> On 6/23/26 11:42 AM, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> The mglru page table walker batches per-generation size deltas in
>> walk->nr_pages while walking page tables without holding the lruvec lock.
>> The reset_batch_size() later folds those deltas into walk->lruvec under
>> the lruvec lock.
> 
> Ouch.
> 
> IIRC the user-visible impact of underestimated nr_pages in MGLRU
> was premature OOMs because MGLRU does not try to reclaim memory when
> nr_pages reaches zero, but there are still more pages.
> 
> Perhaps worth mentioning in the changelog?

Maybe this should be placed before "To fix it...".

> 
>> The page table walker can run concurrently with the memcg reparenting path
>> as follows:
>>
>> CPU0                           CPU1
>> ====                           ====
>>
>> walk_mm
>> --> walk_page_range
>>      --> update_batch_size
>>          --> walk->nr_pages += delta
>>
>>                                mem_cgroup_css_offline
>>                                --> memcg_reparent_objcgs
>>                                    --> lock lruvec
>>                                        lru_gen_reparent_memcg
>>                                        --> reparent child folios to parent
>>                                        unlock lruvec
>>
>>      lock lruvec
>>      reset_batch_size
>>      --> child lrugen->nr_pages += delta
> 
> The problem here is that, while grabbing a reference to memcg
> (via mem_cgroup_iter(), for example) makes sure that the memcg is not
> freed, it does not prevent offlining happening, and reset_batch_size()
> doesn't check whether the lruvec has been reparented, or the lruvec
> is going to be reparented.
> 
>> This will trigger the following warning in lru_gen_exit_memcg():
>>
>> 	VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
>> 				   sizeof(lruvec->lrugen.nr_pages)));
>>
>> To fix it, add lrugen->reparented to remember the new owner of a
>> reparented lruvec, and make reset_batch_size() charge pending deltas to
>> that owner.
> 
> Could you please explain why it is unavoidable to introduce the new
> field and why checking whether the cgroup is dying (and charging deltas
> to non-dying parent) doesn't work?

Peiyang tried doing this [1], but it doesn't work because
ss->css_offline() is called before clearing the CSS_ONLINE flag. I
also considered using mem_cgroup_tryget_online(), but that only prevent
the memcg from being freed. It's doesn't prevent the offlining.

So in the end, I chose the approach used in this patch. Simply adding
a new field to mglru to track its reparenting status seems to be the
most straightforward and effective approach.

Thanks,
Qi

[1]. 
https://lore.kernel.org/all/5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn

> 
>> Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
>> Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn
>> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Reviewed-by: Barry Song <baohua@kernel.org>
>> ---
> 


