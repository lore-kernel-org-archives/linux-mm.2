Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DF2FC88E41
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 12:42:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A7896B008A; Wed,  9 Sep 2026 08:42:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 058FE6B008C; Wed,  9 Sep 2026 08:42:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E897D6B0092; Wed,  9 Sep 2026 08:42:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C52FF6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:42:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 149991201CD
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:42:07 +0000 (UTC)
X-FDA: 85194186294.08.31E677F
Received: from mta1.migadu.com (out-241.mta1.migadu.com [95.215.58.241])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5D44C12000D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:42:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="xSw/p9ko";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.241 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="xSw/p9ko";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.241 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788957725;
	b=fGLnWwmRHri1kcUXAbQPMbZkwPKrCdo+RMPOicB7ZX3+K7UpwXtwRb7EnkQgANZpui10fc
	ukIUAA0tFzRIq3Vuy1ZsbMlbIvlQ2FSi4xj9pix7kVpJQbf6LFQyezg36Yc+i2/GNrfCiK
	DudobB0J3WGPs7IGsgrernLz9uq1dsc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788957725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=snhqTz2LjFDSbLT5152KG20Lm+T1/CJL4YkuUA0oW58=;
	b=d6co8jpqKmvC6ANm1GBOs0yEsmGt5JvGUcs93444POoO4205r5rUXHQsp4HfkOdRm/ld1B
	Xnp2pOruZFVLp+y1vpfjf8/PKSFuwpYONhFOzyCUq7oh93ovm5hzuuCfLYMpOyYoX0vjzW
	w8fGXgI316hZZs+a6GL2ntg2BU37vu4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=d8jOBmpijeiru+KyfV/xClA5cJs9GP6kquk0D6tgcF8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788957720; v=1; x=1789562520;
 b=xSw/p9koyXMYiY/Qog7jA4msd62ZO1zS01MvGoNJGhzgBvgd6QI5r2qZStT2MCI0q7SVE5U5
 O9Y/pe02GxroT3564z5wwVwFuDSLUmhC/O+G+sksM2vA/ln6DkQybF6mWOisfUu406a36G5rk4E
 IENzYujCEIkY6opp74ZSb6nI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id addb3024c47d7683;
	Wed, 09 Sep 2026 12:41:59 +0000
X-Mizu-Trace-ID: addb3024c47d7683
X-Migadu-Flow: FLOW_OUT
Message-ID: <acb81c51-318b-4a00-aad9-515929076662@linux.dev>
Date: Wed, 9 Sep 2026 20:41:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/2] mm/mglru: add tracepoint for folio isolation
To: Barry Song <baohua@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260907042447.2450663-1-ridong.chen@linux.dev>
 <20260907042447.2450663-2-ridong.chen@linux.dev>
 <CAGsJ_4zT0HcbkQjdPFPBeaqbGcYp4WE6sghDzz=0evhhupCs3g@mail.gmail.com>
 <102f6ff6-46f9-4734-a056-694eb2c0129b@linux.dev>
 <CAGsJ_4wxZ0pc0UMAXe3xKW0=PTzYv31ieoJa1v01SoLczPVOCA@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4wxZ0pc0UMAXe3xKW0=PTzYv31ieoJa1v01SoLczPVOCA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D44C12000D
X-Stat-Signature: r8oxyi49s684nyf19b7b1i3z5x67z6hk
X-Rspamd-Server: rspam01
X-HE-Tag: 1788957723-114628
X-HE-Meta: U2FsdGVkX19G2kWSpKR0SgFhSB5bTvl1pyZtr9xCIsGyJ8S9w4fTNua6aE4tIyy7uspEuV/m8LnacCG8O7SKmZtWsHY6R2dOLCbeAa+9+/2jhmmLdAx9mtijrAKTOzHHJ/fdBEHonBYI5tMLZj3biiZwZiYf8kC7FOBb4pIM0+Z8DcwhDcJUjz+ltoPOocxBfKbFpcftoX/acfDhRhEoftSOy2L+YaU2EmZuKE8nWCHZ4Aull5L9EBBNJp1q+qbh4DnJNgouLOLUfrUKdy74pBLmOL4kbSQyt3QgdHjgvsKMrs9kCFf7jE72ZXN/7giXmtFRnTAhduh909lFtR81jqdueABNQnAZib6wedMYofs2N5dOrbSMfFBFhk2AJ3KYxxG7gaTvB79HDGKzG3QKqQIDGaKUqVxA0733waJ8jNU4vMrI69p1RV1iZIMk1eGRbhlO4hi/DgmXSXz3mxzw6xZ9hAb+7UpUuydUxMZlYQbK6Thiuq/JttBpzMJlnClmTwA5MhRhC98BOkN6oONsHrJ8kjKVVKCQ57Y6LEcQBqPBuV1blqlFNE8Q/xKfwSZlj9/ZZty6Dehgj5V41VHWLbvHycWGFeOOmycKNZcCcTYH6XOStHxR0I6AVSIElOq2tD04QaB1E9QQRn6V9wLwCAvUupi8+sGRxf61K/zzLJEy+CNl/xNSzITWzt8dOkn2zIVaWiLcr60yaS7BduH51AdV8BH0wWHuQOC1ZOe3rIAjH6M72Jv+KBecTYJ5wPQNhEvLAxTpIwMi5Ab+HpInBJjtnrhJl+cc05+jVUkdHJnP/lMIrDrKBevbmeoWJBGjpzlAdx88dFyFYR8hWNaxF3XZSB2ximIWwXYmj+i9Sz9xkIWODOG6nuBWNUnTuf2kXYN9KLHmRC9oNQ6F6r0okb0E3yOc14L+0VAbJgt98vIddn3Rp3PxDQ5XAN9RZSTmh7jaiEXg1p3QvjdOTUo
 mmmfmoVT
 eTs/Q5TM8hmKuvAhDaLBSrtcj+N+wksSE7IeTwXxu/NbSlquBdWHpHtHMixgpi2yGfvLcevngK9ArGKB1GB1fv1YhOlQAQSP7tjdPtLYbNUJ6mB7gckOVUXQyKUusUcH41bPFouxb8fUlrG/b0UPJHvkZc9avNj7MWEccNopc3fx1YEbo3AeclxR5rLCt0UoaOcNF5u9f7DlvdrIZRRicxC8p/cUK0VAbuznkLOf0bQco8AGFcPA/PQvLanmZIW+RJ4c2gdAb0PPUfcN6+aH0Nl4D7OKm/bMOcfUrBNG32Pee+8R5YsGnzl4aZLOoGU/yd3cIz/QacfwIG5gyryLn/uSPe969ejJCIShhfCtvw3Xg2JE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/9/2026 8:11 PM, Barry Song wrote:
> On Wed, Sep 9, 2026 at 8:00 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>>
>>
>> On 9/9/2026 2:40 PM, Barry Song wrote:
>>> On Mon, Sep 7, 2026 at 12:25 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>>>
>>>> From: Ridong Chen <chenridong@xiaomi.com>
>>>>
>>>> MGLRU's scan_folios() and evict_folios() emit the classic-LRU
>>>> tracepoints trace_mm_vmscan_lru_isolate() and
>>>> trace_mm_vmscan_lru_shrink_inactive(). Those predate MGLRU and are
>>>> indistinguishable from the classic-LRU path: they carry no generation,
>>>> sequence, memcg or swappiness context, so a trace of an MGLRU run cannot
>>>> tell which memcg a given scan/evict belongs to, nor how far reclaim has
>>>> progressed through the generations.
>>>>
>>>> Add mm_mglru_isolate_folios, emitted once per isolate_folios() call with
>>>> the memcg id, the type actually scanned, the effective swappiness, the
>>>> scanned/isolated counts, and the anon/file min_seq and max_seq. The
>>>> min_seq/max_seq triplet ties each isolation to the generation layout it
>>>> ran against, which the classic-LRU tracepoints cannot express.
>>>>
>>>> This is emitted at the isolate_folios() layer, which is MGLRU-specific
>>>> and has no classic-LRU counterpart, so it neither changes nor duplicates
>>>> the existing scan/evict tracepoints.
>>>>
>>>
>>> I have no objection to MGLRU having some tracepoints. However, one
>>> major concern is that the code is changing rapidly, so the tracepoints
>>> may not be stable. We would need to maintain them as the code evolves.
>>>
>>
>> Indeed. GEN-LRU has been available for several years now, and many vendors are
>> already using it, so adding tracepoints is a necessary step.
>>
>>>> Assisted-by: Claude:claude-opus-4-8
>>>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>>>> ---
>>>>    include/trace/events/vmscan.h | 47 +++++++++++++++++++++++++++++++++++
>>>>    mm/vmscan.c                   |  9 ++++++-
>>>>    2 files changed, 55 insertions(+), 1 deletion(-)
>>>>
>>> [...]
>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>> index 8409ea4bbf37..771fe6827939 100644
>>>> --- a/mm/vmscan.c
>>>> +++ b/mm/vmscan.c
>>> [...]
>>>> @@ -4876,6 +4877,12 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>>>                   goto retry;
>>>>           }
>>>>
>>>> +done:
>>>> +       trace_mm_mglru_isolate_folios(mem_cgroup_id(lruvec_memcg(lruvec)),
>>>> +                                     type, swappiness, total_scanned, *isolated,
>>>> +                                     lrugen->min_seq[LRU_GEN_ANON],
>>>> +                                     lrugen->min_seq[LRU_GEN_FILE],
>>>> +                                     lrugen->max_seq);
>>>
>>> Maybe `scan_folios()` would be a better place for this, as it can more
>>> directly reflect what we're doing for each type.
>>>
>>
>> scan_folios() already contains the trace_mm_vmscan_lru_isolate
>> tracepoint(traditional tracepoint), but it lacks any GEN-LRU-specific
>> information. Adding another tracepoint there would be redundant. Therefore, I
>> placed the new tracepoint in isolate_folios(), where it can capture GEN-LRU's
>> specific details. Additionally, it can indicate whether a fallback to the other
>> type has occurred.
> 
> if `trace_mm_vmscan_lru_isolate` is located in `scan_folios()`, that
> would be strong evidence that `scan_folios()` is a better place for
> adding a new tracepoint for LRU gen.
> 
> There is no need to avoid this location just because we already have a
> tracepoint here. In fact, I think this is evidence that it is a better
> place, not the opposite.
> 

Good point.

Thank you very much, that does make sense.

> BTW, `isolate_folios()` might be deleted soon, depending on how we
> improve MGLRU and on some ongoing work from Kairui. But `scan_folios()`
> should be long-lived, as we need to scan folios in any case. Therefore,
> adding tracepoints to `isolate_folios()` doesn't seem to be related to
> the stable ABI concern mentioned in your cover letter.
> 
> Best Regards
> Barry

-- 
Best regards
Ridong


