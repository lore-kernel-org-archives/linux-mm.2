Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D9C9CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 08:47:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 770358E000B; Thu, 23 Oct 2025 04:47:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 721228E0002; Thu, 23 Oct 2025 04:47:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65DA78E000B; Thu, 23 Oct 2025 04:47:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 566958E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 04:47:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 261C9160457
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:47:49 +0000 (UTC)
X-FDA: 84028751058.19.5FE37A9
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id 46AC080002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:47:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iHF5CACX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761209267; a=rsa-sha256;
	cv=none;
	b=oQqmMYgGs35EpEEMeSB9EYQzi5sPjGMCOK+aqyGrDKm/rJFCGNzfBtEH0V6mRL/Nalefu5
	8aBvSn/HbIA/ubQj94at1ewaxcRmDLREE7Lzmbhu2Pbtj4F+druLO/TT/Khlm9O2J3Mi11
	Mbo3OoF1ByeOr/8fIEMErX+Wt6ckBqU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iHF5CACX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761209267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5CO9JUnFW5uKy5VvVF8W1FG0awi4JoMoz5N1pXPIqZU=;
	b=hxYhKkZ6bt5JCWBAKqajXFtGC60iRkZGNymYNmkdMNo+SrDV+WuPlIdfrclfc+wXD66ZNO
	nSfCyIafNIHYFmQfpbtUCVql9SWvl2wg2VWa1yUFYK3UXETF/T199WQmlqBPDTBIolwz+y
	YFjtJ5I1V0y+W317bxZITrihDv0JMbs=
Message-ID: <abc7bc71-c9a4-4a19-a47f-f6d6f40608fb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761209265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5CO9JUnFW5uKy5VvVF8W1FG0awi4JoMoz5N1pXPIqZU=;
	b=iHF5CACXnrJQQWiRMI1Yp5/2Be2BFxIX8fXmBkMFWrJADJckfgPzF/ig7uhZWykPqfLWM0
	Zc0X1L6GlGjGTEOSiVST+Bz5PJWy5gbA1jQhqIaD1/ymBJ/HTQYEBIf1sPBpoGqO/iRlbP
	g8wN1v/jVa14BXdLvLLEaQMfrSRc8P4=
Date: Thu, 23 Oct 2025 16:46:42 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] slab: Fix obj_ext is mistakenly considered NULL due to
 race condition
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hao Ge <gehao@kylinos.cn>
References: <20251023012117.890883-1-hao.ge@linux.dev>
 <aPmR6Fz8HxYk4rTF@hyeyoo> <b8c90552-7be6-45bb-b586-ee21f63499c8@linux.dev>
 <aPneQRY5ei-zvSGQ@hyeyoo> <cc961fad-f9bc-4c5a-a7f1-ea3842aefed3@linux.dev>
Content-Language: en-US
In-Reply-To: <cc961fad-f9bc-4c5a-a7f1-ea3842aefed3@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: i38x9iyu1gb97iim7fqmwscybae1p9g3
X-Rspamd-Queue-Id: 46AC080002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761209267-291936
X-HE-Meta: U2FsdGVkX1/C1FeAjhC/LuDw03FCk/CyO6hcsLHGdtPyPMGEBR6erOobCw6eGo6jmrpsceuJTo9p5eMjPNR6kB5u+BF7vgezZQn/D3eJqY+31ZzLpqmmCR4z3k+5TUXNbpTqCeSDdCcOw7GrrmHhTRAzYeOdkhKUADMkrO/rX5pqsaBKZ1KeLavHjwJ4BslH+i97HceJbohaqYdGraR7upgJHwWkcIyBxc6YMs8lWjxxbqOB1h/q3j6ImaX/B7Hl1Cw87+5jdCW+xd3GzKSK0gJSqfWReJeHlC46B3zV7e9tQQRIHUWPofjq8SV+kMDvQis8VzIC3lnr7CpcxhVsye2MkNOmpB21HvuW62LevegtvTPZ/6x/QVSaZvDesRGSvWv151pvKgethZut5BQxfeMqL4Stegs5IUXi3vKr3kGxnndPpDPKOtfFTl/cjr038pg/cvITlEgh5S2ZXQXMk7lPCRWkbkOs4sDd2A7mvw2c2//YhwoEC9N2N4R7l30OYlu4BlVY1uByI2NH44XN1n6OqcFXkDTXiGW1p9auiOiavbvVmY5+5ce7Duf7ugF6GIvMC0AYWJWp6lVEVqSF2cJ+Gj34CDTuHIg6QeDPfOQgmNLk7v/kPUl7/JeoI+eya5nie1/+PFH9EGoicUEH2Uu948596L9PUf5Lnyk9EHajZX3W2rEgWa2D9gCPAF/TlAdrW6EvnkEbDkzgI7H6gzJT2Lhyevw0hnC3dInrzUENLyZugd5CiRF0rlKumIMW709uFV8Dv6M5S47GzyhENKjxuixYySw0H12aJMV5l0ksR/DB3Rorp6LuiDm4JjfiDZwNs9OZAmtkGP1QD+g8yMIZbG8areQNk9/0Rag6yzMnsfof6NrMzuccs0NbgNpPtVOwzrzv01Tnjsl6wdlk1GM1CBLbeuSJHJ70ETpa74yH4MVNJQ5aTFds0ysg96TLlqikyJmtGPAlsYUYMny
 qHUbGt/r
 zOJVIThZClKHknXTtOzpKml8NkGca2ztaHyKVwLZ7Kr6NWvS/jHuT/BCC2FKzomK989RCQKz6I1ojrDNV+vK2ZcYLrH5ms2kO91S5b4FWO+LW4rhPPmIev35PWAoX6zTP4Acz2xHtFd4XVBSP+bRjVFNlPAf2dOuL0yv0WkfA79XUBClm8JtkMTpHdTKcMnrrGi9MH4OmlS1fgScFCwtMPETFUJHcAgZGn3HDko4DhCd7kaG7LlQQ0i8sRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry


On 2025/10/23 16:23, Hao Ge wrote:
> Hi Harry
>
>
> On 2025/10/23 15:50, Harry Yoo wrote:
>> On Thu, Oct 23, 2025 at 11:11:56AM +0800, Hao Ge wrote:
>>> Hi Harry
>>>
>>>
>>> On 2025/10/23 10:24, Harry Yoo wrote:
>>>> On Thu, Oct 23, 2025 at 09:21:17AM +0800, Hao Ge wrote:
>>>>> From: Hao Ge <gehao@kylinos.cn>
>>>>>
>>>>> If two competing threads enter alloc_slab_obj_exts(), and the
>>>>> thread that failed to allocate the object extension vector exits
>>>>> after the one that succeeded, it will mistakenly assume slab->obj_ext
>>>>> is still empty due to its own allocation failure. This will then 
>>>>> trigger
>>>>> warnings enforced by CONFIG_MEM_ALLOC_PROFILING_DEBUG checks in
>>>>> the subsequent free path.
>>>>>
>>>>> Therefore, let's add an additional check when alloc_slab_obj_exts 
>>>>> fails.
>>>>>
>>>>> Signed-off-by: Hao Ge <gehao@kylinos.cn>
>>>>> ---
>>>>>    mm/slub.c | 9 ++++++---
>>>>>    1 file changed, 6 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/mm/slub.c b/mm/slub.c
>>>>> index d4403341c9df..42276f0cc920 100644
>>>>> --- a/mm/slub.c
>>>>> +++ b/mm/slub.c
>>>>> @@ -2227,9 +2227,12 @@ prepare_slab_obj_exts_hook(struct 
>>>>> kmem_cache *s, gfp_t flags, void *p)
>>>>>        slab = virt_to_slab(p);
>>>>>        if (!slab_obj_exts(slab) &&
>>>>>            alloc_slab_obj_exts(slab, s, flags, false)) {
>>>>> -        pr_warn_once("%s, %s: Failed to create slab extension 
>>>>> vector!\n",
>>>>> -                 __func__, s->name);
>>>>> -        return NULL;
>>>>> +        /* Recheck if a racing thread has successfully allocated 
>>>>> slab->obj_exts. */
>>>>> +        if (!slab_obj_exts(slab)) {
>>>>> +            pr_warn_once("%s, %s: Failed to create slab extension 
>>>>> vector!\n",
>>>>> +                     __func__, s->name);
>>>>> +            return NULL;
>>>>> +        }
>>>>>        }
>>>> Maybe this patch is a bit paranoid... since if 
>>>> mark_failed_objexts_alloc()
>>>> win cmpxchg() and then someone else allocates the object extension 
>>>> vector,
>>>> the warning will still be printed anyway.
>> Oh, just to be clear I was talking about the other warning:
>> pr_warn_once("%s, %s: Failed to create slab extension vector!", 
>> __func__, s->name);
>>
>>> The process that successfully allocates slab_exts will call
>>> handle_failed_objexts_alloc, setting ref->ct = CODETAG_EMPTY
>>> to prevent the warning from being triggered.
>> But yeah I see what you mean.
>>
>> As you mentioned, if the process that failed to allocate the vector wins
>> cmpxchg(), later process that successfully allocate the vector would
>> call set_codetag_empty(), so no warning.
>>
>> But if the process that allocates the vector wins cmpxchg(),
>> then it won't call set_codetag_empty(), so the process
>> that was trying to set OBJEXTS_ALLOC_FAIL now needs to set the tag.
>
> Yes, the case I'm encountering is exactly this one.
>
>>
>>>> But anyway, I think there is a better way to do this:
>> What do you think about the diff I suggested below, though?
>
> Sorry for the delayed response earlier; I was trying to deduce all 
> possible scenarios.
>
> It makes sense to me, and I will submit the V2 version based on this 
> suggestion.
>
> Thank you for your help.
>
>>
>>>> diff --git a/mm/slub.c b/mm/slub.c
>>>> index dd4c85ea1038..d08d7580349d 100644
>>>> --- a/mm/slub.c
>>>> +++ b/mm/slub.c
>>>> @@ -2052,9 +2052,9 @@ static inline void mark_objexts_empty(struct 
>>>> slabobj_ext *obj_exts)
>>>>        }
>>>>    }
>>>> -static inline void mark_failed_objexts_alloc(struct slab *slab)
>>>> +static inline bool mark_failed_objexts_alloc(struct slab *slab)
>>>>    {
>>>> -    cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
>>>> +    return cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL) == 0;
>>>>    }
>>>>    static inline void handle_failed_objexts_alloc(unsigned long 
>>>> obj_exts,
>>>> @@ -2076,7 +2076,7 @@ static inline void 
>>>> handle_failed_objexts_alloc(unsigned long obj_exts,
>>>>    #else /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
>>>>    static inline void mark_objexts_empty(struct slabobj_ext 
>>>> *obj_exts) {}
>>>> -static inline void mark_failed_objexts_alloc(struct slab *slab) {}
>>>> +static inline bool mark_failed_objexts_alloc(struct slab *slab) { 
>>>> return true; }

Maybe it returns false here.

When CONFIG_MEM_ALLOC_PROFILING_DEBUG is not enabled,

The following condition will never be executed:

if (!mark_failed_objexts_alloc(slab) && slab_obj_exts(slab))

if another process that allocates the vector, we will lose one count.


>>>>    static inline void handle_failed_objexts_alloc(unsigned long 
>>>> obj_exts,
>>>>                struct slabobj_ext *vec, unsigned int objects) {}
>>>> @@ -2125,7 +2125,9 @@ int alloc_slab_obj_exts(struct slab *slab, 
>>>> struct kmem_cache *s,
>>>>        }
>>>>        if (!vec) {
>>>>            /* Mark vectors which failed to allocate */
>>>> -        mark_failed_objexts_alloc(slab);
>>>> +        if (!mark_failed_objexts_alloc(slab) &&
>>>> +            slab_obj_exts(slab))
>>>> +            return 0;
>>>>            return -ENOMEM;
>>>>        }
>>>>

