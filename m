Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DB17606A32C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 12:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cNoUt+Ay
Received: by kanga.kvack.org (Postfix)
	id 25A6C6B05B0; Sat,  7 Nov 2026 07:04:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20C356B05B1; Sat,  7 Nov 2026 07:04:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 124B76B05B2; Sat,  7 Nov 2026 07:04:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D6BC26B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:04:30 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3A72C031A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 12:04:28 +0000 (UTC)
X-FDA: 85408190616.15.4A082B5
Received: from mta0.migadu.com (out-151.mta0.migadu.com [91.218.175.151])
	by imf22.hostedemail.com (Postfix) with ESMTP id AE6BEC0008
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 12:04:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cNoUt+Ay;
	spf=pass (imf22.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.151 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794053067;
	b=yXbkRvWlaudGBstC/pb9rFChR5qhtYwceXKYGcYxEEsEHYLdN9zu0TxyBbhk+TSzZN5mce
	9c+7HFfb1pJAyjm7oYzm/qzJnUAOr7K2stRndzVmTdXPAgsvs+8KzO5AGDi58Z21qCr14c
	GaKqHpgVVresRRZVnP7b2tIxaj1pRcQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cNoUt+Ay;
	spf=pass (imf22.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.151 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794053067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fehvpwKLkvAzp8Ic92lGZjTmUddHTM0YOLXxTp5AQBo=;
	b=xSJgq0K/JaR7VQmF2KKZ8jIbv0qsDMSb9GTSOFJ/+fhOUo3jXJe2Pct6qfjbZCra19kfu9
	2xic3KSBO76Y9kj23ctwSoRTAPfTT6QgVWNRRlz/+hw54uG8r6B6vspTpgb0FcueMc7+z9
	n5L/TuprL2kooH8W72K919DxUidDo14=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=E8Yy5bgEjYt6pYSaf6glxvsg2jFl/7uxBAsGhxtzXs8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794053063; v=1; x=1794657863;
 b=cNoUt+AyDRYJYww4eWAnV245h4ALVh+CDwe4HlIqkLVef4mf5Oz0ja/yCE+a+1Psw2NqeZcM
 1zegAI+cNaLKutgSwSX0RLjDlyXpIRDn5VmmHodYWqrTVK12WFNPeeL50FHSL3tgmOslFlwLURC
 dQwjHEapxMo4n3ei4MWQjXpY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3d9503d94a972e62;
	Sat, 07 Nov 2026 12:04:23 +0000
X-Mizu-Trace-ID: 3d9503d94a972e62
X-Migadu-Flow: FLOW_OUT
Message-ID: <ad63bf38-d3c8-4977-8582-60a65815887c@linux.dev>
Date: Sat, 7 Nov 2026 20:04:10 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/3] mm/mglru: skip the flags cmpxchg when nothing
 changes
To: Kairui Song <ryncsn@gmail.com>
Cc: David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Joanne Koong <joannelkoong@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20261105132220.2233677-1-ridong.chen@linux.dev>
 <20261105132220.2233677-3-ridong.chen@linux.dev>
 <CAMgjq7DtU+tSOgQWgTaV0obLwkkUwQqgvtTXjG2qf8L+iPXbiQ@mail.gmail.com>
 <57d2a4ca-8edc-4291-a919-8a74abda94a5@linux.dev>
 <CAMgjq7BtS6KKqdq1oVrvrO9FcTEkE4HNJe02dA87n6Zm7FFrww@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAMgjq7BtS6KKqdq1oVrvrO9FcTEkE4HNJe02dA87n6Zm7FFrww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wdmnwyesbwqu5sg76n9oxfif19fdenes
X-Rspamd-Queue-Id: AE6BEC0008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794053066-523401
X-HE-Meta: U2FsdGVkX1+TG36d+pnogQvu1tYxfrFg7o2dmBa01rdMrP736cZktLAfiW+MectScK2NrR9CrJe/5LWLikr7BLrxLLUvI4zaSWAO0GpyaXKMZECqIVvTJVaxgcYwgDq431+K2XEveURi92nkqCc4oz38BNjbyqnXF4ncNIBraRcTCNaHJvDCAVSAjIMwZ2DwjsnBmmk4z5el/C5gNw/IaLSxsanLcsDOjIFjEr6vsyp0r4ghY3kVp/FpDJtsNRhcb+WZQdBGTBipzNNNG2X9n6S2OOeP7i3u+Bc/a+Gi9unevXj3E1UU8+I52jdEBmcqb5ROBhOzhhAtoDL51g3Y4iXyYLG31YEMsh2JqrDdf2dSNaCjyqJxFQdP3IIpksYpD5Y7wzEPWfpjufTpjVN4eUHVgvdjMz4Vm7WgeCyH4AYUhS8AaFJzOK3luaW6ZxWc+IY3PfEe9UHwczf2yb1W1t9e8oUYa6s1AhiOQOxVWQmWs5FyKOQ6jtqbD7cYhBll3+RP/9TMEl2PrbSJVNzJMXfqkyeS3Szzyl8Mryw4NiNo88y3OMNk0BH+1XyA/+1STsKvQKc64o5k2cRR9AYHRtkJKw3v0HyY3thz5QaTCO8mziBq9+PrS8MFSJepOSfM2Z6xZ1I6ETRV1qm1PGtbMwJ6WQfh/SYd/kRorsUk+pHW9PzgkN5A8ZfxcZBpq2AP7U6sFAN1/YNDdUXAVnWY7PQBBJXq9zYiYL3cLxoZIzNpEU/IA4wNqd6qH3cD88KVkROXw+sSedYNmMk7bALK73bvxzlNOi++zUNdYLyuTt/3knrkEiFwRaJdJvvAg3fOjdQI/4t0sT4CqtupPPbEjhVCQKGqPIoWyG2LH2TOrCqKDEYRM73eUIT/+kVF+9C9wvUHbbStD1iES4toou2cWV3q51vmisyRGXPcORHR2/vkaq9yMDKk5EEWwB5N7ohaq3QrkntS8+xM687u7fG
 NViDRRtN
 oHp840TOJvgS0waFoYDdxd7SyWp5jbQpQv/dsSPbv/cC6zqH5VO53vCNglcHifsUW861yz7jsSkBb39ufSpYXsCWMQG4kIZAK/B4d9XwfN6YjexsnTGH7BwPFdSuK2nwiPGIOsnJlzof+24FbzGo9gs/NLfjorfNt/Mx5VU/RL6fBRVJyvOwL/Uq1UEc5nKXbA4oRpld5F7s3mz6W1XgExH1cHpJnd0EtwVKuZFSPofItBOljQp5nV5A5mn3wjKZqIMRpIXX82VzufNY9XnH1dMshHt6nMLMyzhZ2uAugwxhzaqpLtJOPkCHFi48NXdoAzJncCTie8rpkH11TwGSE56Rvcbga7A09zSH84Qb54Sl4UfmH/OwlW55Ruw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/7/2026 6:39 PM, Kairui Song wrote:
> On Fri, Nov 6, 2026 at 9:44 AM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> On 11/6/2026 12:21 AM, Kairui Song wrote:
>>> On Thu, Nov 5, 2026 at 10:11 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>>>
>>>> From: Ridong Chen <chenridong@xiaomi.com>
>>>>
>>>> folio_update_gen() and folio_set_lru_refs() always end with a
>>>> try_cmpxchg() on folio->flags, even when the new value equals the old
>>>> one. The locked instruction still takes the struct page cacheline in
>>>> exclusive state.
>>>>
>>>> That is common in practice: a folio mapped by many processes is visited
>>>> once per mm during a page table walk, and after the first visit it is
>>>> already in the youngest generation with refs cleared and PG_workingset
>>>> set. isolate_folio() and the eviction paths also call
>>>> folio_set_lru_refs(folio, 0) on folios whose refs are already zero.
>>>>
>>>> Break out of the loop when the flags would not change. The result is
>>>> the same as a successful no-op cmpxchg. The only difference is that the
>>>> full barrier implied by the locked instruction is gone on that path.
>>>> No caller relies on it: the eviction and isolation callers run under
>>>> the LRU lock, and the others (page table walks, folio_mark_accessed(),
>>>> lru_gen_clear_refs()) only care about the resulting flags value, which
>>>> is already in place. Note that lru_gen_inc_refs() already returns
>>>> without any atomic when refs is at LRU_REFS_MAX and the folio is in
>>>> the workingset.
>>>>
>>>> Tested on an i7-13700HX with turbo disabled and the performance
>>>> governor. N processes map the same 2GiB tmpfs file (huge=never) and
>>>> read every page, then one aging pass is triggered on their memcg
>>>> through /sys/kernel/debug/lru_gen ("+ <memcg_id> 0 <max_seq> 200 1").
>>>> Time per aging pass in ms, median of 5 runs of 10 passes each, averaged
>>>> over 2 boots of each kernel:
>>>>
>>>>     processes    base   patched
>>>>             1    32.9      31.7   -3.5%
>>>>             8   195.1     160.2  -17.9%
>>>>            32   755.8     592.2  -21.7%
>>>>            64  1597.2    1260.6  -21.1%
>>>>
>>>> With one process, every visit changes the generation, so there is
>>>> nothing to skip. Before the patch, perf annotate attributes 53-58% of
>>>> the walk_update_folio() samples to the lock cmpxchg in the inlined
>>>> folio_update_gen() in this test.
>>>>
>>>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>>>> ---
>>>>    include/linux/mm_inline.h | 2 ++
>>>>    mm/vmscan.c               | 2 ++
>>>>    2 files changed, 4 insertions(+)
>>>>
>>>> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
>>>> index b3d85fe91385..4ba9079f4dc8 100644
>>>> --- a/include/linux/mm_inline.h
>>>> +++ b/include/linux/mm_inline.h
>>>> @@ -244,6 +244,8 @@ static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
>>>>           do {
>>>>                   new_flags = old_flags;
>>>>                   lru_set_refs_flags(&new_flags, refs);
>>>> +               if (new_flags == old_flags)
>>>> +                       break;
>>>>           } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
>>>>    }
>>>>
>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>> index 50c352e9ffef..3fa76715382d 100644
>>>> --- a/mm/vmscan.c
>>>> +++ b/mm/vmscan.c
>>>> @@ -3398,6 +3398,8 @@ static int folio_update_gen(struct folio *folio, int new_gen, int *type,
>>>>                   lru_set_gen_flags(&new_flags, new_gen);
>>>>                   lru_set_refs_flags(&new_flags, 0);
>>>>                   new_flags |= BIT(PG_workingset);
>>>> +               if (new_flags == old_flags)
>>>> +                       break;
>>>>           } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
>>>
>>> Hi Ridong,
>>>
>>> I had the same idea in V4 of MGLRU-FG which is posted a few weeks ago,
>>> with the same code:
>>> https://lore.kernel.org/linux-mm/20261016-mglru-fg-v4-4-2106750c0bfa@tencent.com/
>>>
>>> + if (new_flags == old_flags)
>>> + break;
>>>
>>
>> Hi Kairui,
>>
>> Oh. Sorry about that. I read the series a few weeks ago, but as it is large
>> I missed this change. I should have checked it again before sending.
>>
>>> I didn't have time to benchmark that one function but the e2e test
>>> showed very trivial improvement, it's a good improvement though. Feel
>>> free to add:
>>>
>>> Reviewed-by: Kairui Song <kasong@tencent.com>
>>>
>>
>> Thanks for the Reviewed-by. If you don't mind, I'd suggest merging it as
>> a separate patch, as the test shows the benefit of this small change,
>> which makes the code easier to trace. I will also mention in the commit
>> message that it is a small part of your series. Does that sound OK to
>> you?
> 
> Sounds good to me! No need to mention that, though; I believe you came
> up with this idea by yourself. And that will make the change more
> traceable indeed.

That's very kind of you. Thanks.

-- 
Best regards
Ridong


