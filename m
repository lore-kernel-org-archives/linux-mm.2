Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9959CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 09:12:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1DAD8E000A; Thu, 23 Oct 2025 05:12:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECE048E0002; Thu, 23 Oct 2025 05:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBD288E000A; Thu, 23 Oct 2025 05:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C6E4E8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 05:12:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6FCC013C051
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:12:00 +0000 (UTC)
X-FDA: 84028812000.12.B77ED64
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf03.hostedemail.com (Postfix) with ESMTP id 798572000B
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:11:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JOkl5iIB;
	spf=pass (imf03.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761210718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YmispLrE7a4YOiW6K5NNzShTdcLhEQ+ZufQ8+3A6y5g=;
	b=EdOVs6ldGAfipo+Jb0YqK9DfQmVcG74eI2tA0QaIvdQe5TbWfrI7pWZX3UBSo/wXENA8fM
	FqoiY0VD7hYc6dF/Xb5Q2oCV1cRDOyQNj4T5AVIHvkc7+Mm5fKMp2scuCDS36nx+MWHJDx
	PDNPOdht/bfUUTUq5irDl/QPJ3GIq2w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761210718; a=rsa-sha256;
	cv=none;
	b=ah0/tvtTaNDGA/dwU1AmP3ajJNjShDWy6YWfI2XGv8voOzP7HYjzkMgPZnuBPMfDknGB2m
	ezJ981UwKKO0vMZPmAaTcJuNGzSI5+OCBUT+mCm/SGBk4qD8wElEnh6q6+mCeKo3iH0cZk
	BTq1MFQlNW6pu5ujT5d6aOdSG6BAHDc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JOkl5iIB;
	spf=pass (imf03.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <268f8300-3be0-4b45-aa86-e11bf09c86bb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761210716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YmispLrE7a4YOiW6K5NNzShTdcLhEQ+ZufQ8+3A6y5g=;
	b=JOkl5iIBkvZqrgJUDnNLlBLRgFgyo+zC/WeZHufXVg1SvfFYeZX/4spL4xStPG7DSKuy/H
	dEhLMnEbcXA5S/7nN1CJcjkukdJyic8o2hTsLStMagyJbwTMUitKIvhLvOqXYMtkt5QjOi
	dZXEH1QcGdmi5lC0JZijQuL2Ze82lcU=
Date: Thu, 23 Oct 2025 17:11:01 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] slab: Fix obj_ext is mistakenly considered NULL due to
 race condition
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
 <abc7bc71-c9a4-4a19-a47f-f6d6f40608fb@linux.dev> <aPnv_W48rbPPmAOj@hyeyoo>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <aPnv_W48rbPPmAOj@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: exdspatch9oxdrjh3cdieqmaq1jggucm
X-Rspam-User: 
X-Rspamd-Queue-Id: 798572000B
X-HE-Tag: 1761210718-644393
X-HE-Meta: U2FsdGVkX1/BUOn685Mb5TsE1qmyW08qaW1bLb8HEBbmziLTvr+sam23bTA052YChvnj6yVUREqJWfC31SKfiTKLNZTUr+2ir6SgaMR7un+aRAMsxNdGGwOPibCSZRZaoPPymSZzrEoFFFFfwmdC1tmTaptcjiRy/ZQKE//UPIYXhhwSSyuygBRSh00qHrLz5AhBMHwcIUFUtcJzrDh+ddMoXRgPzth063gFCTkwKFYnRCjc+W9hOgB3RXSWg9Zs0MyUqgB6ojwEmIW1baJo/fD7uHC8KmUWMeGI9Amdf88mqoVYm/iw2/tAFjxOg0OALTHVLfphdpqyO8mRdYgrrD/A3jg+5c5GuLxdNDMatAzc3fkHlluniGTTil0xwKPVO1EJKyD6bBhIEIXFuGjDUOTTKvfDmFby0AdNcS92iKiUDF9n0h0JWIBWlXcIrClxWb+p/eZk/vIYxJLXkt46egcEoHeGvnrKf+5p5+tvH1G+vWeslsLrGj8vpL502O/gL0wJZvw7P0lG1EZCm3j1GIsbUV90Ton8gMNTUzAPhVoOlJZO7maPX24+bZUHUEuT49ECX8zhIHfsIhRXQIr9TtghxOIPbUjy285HxE4/3/OeZsdqf4ZpPy/IVAt0qyoU6ZlByqi9CTt6CyYz6yqqU12BCILSudOqRdygYnKdcfHs89ZGG9ocjNSkjouHOUI8njjB6LZyIJzZ7cFA7C+y3giO0dOwrFPQ++ExiamlVkFwAsT/krhuTLUEISjT7yQkbJpIJ6xXdZEZdgPNutDTUQsm9sAPu10xnjmKP82fZQEkw48o+A0KV8nZXrRviaGCqPPlUrsewcf0/F3dP/5AfjMGm1ylvjDxOf4zHRItwhhPFdR1Wgmk6gB5+DikWtmJ5i0Qq5UsE6yhOOE2DJbUPMCNvq00Qkb5wwY5lEuFZgI69Uy+AEakdecPM2aPOMopxq7VysQ30GvsGvuT/Ez
 je97fMUb
 AHdxQjs1Lsbz3zX1ToydGeS0DpJkuA/km1nAcufffmf97DSdRHvDsD6RBQX5hJZ3GVTCv4Rw/QBUUAmaQnJt+IbUdFPoKthloSUIJlolSbyeOuwfZKaQWjA+mtjFm9TgVeDGjnjg0+54SsPPVZSFXLjfg+I+cJjdnQ6zUzjIl7G3dl3NNthbIy3NnZJMhe28nXo4+04HVMy401OaHBBsLmLr4NP2dq9Kwgwrg45ZcijNXzksCd5KNfIoJnC0TO+Cf8+SUoQQGtf8VYBc9lIVjBXikIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry


On 2025/10/23 17:06, Harry Yoo wrote:
> On Thu, Oct 23, 2025 at 04:46:42PM +0800, Hao Ge wrote:
>> Hi Harry
>>
>>
>> On 2025/10/23 16:23, Hao Ge wrote:
>>> Hi Harry
>>>
>>>
>>> On 2025/10/23 15:50, Harry Yoo wrote:
>>>> On Thu, Oct 23, 2025 at 11:11:56AM +0800, Hao Ge wrote:
>>>>> Hi Harry
>>>>>
>>>>>
>>>>> On 2025/10/23 10:24, Harry Yoo wrote:
>>>>>> On Thu, Oct 23, 2025 at 09:21:17AM +0800, Hao Ge wrote:
>>>>>>> From: Hao Ge <gehao@kylinos.cn>
>>>>>>>
>>>>>>> If two competing threads enter alloc_slab_obj_exts(), and the
>>>>>>> thread that failed to allocate the object extension vector exits
>>>>>>> after the one that succeeded, it will mistakenly assume slab->obj_ext
>>>>>>> is still empty due to its own allocation failure. This
>>>>>>> will then trigger
>>>>>>> warnings enforced by CONFIG_MEM_ALLOC_PROFILING_DEBUG checks in
>>>>>>> the subsequent free path.
>>>>>>>
>>>>>>> Therefore, let's add an additional check when
>>>>>>> alloc_slab_obj_exts fails.
>>>>>>>
>>>>>>> Signed-off-by: Hao Ge <gehao@kylinos.cn>
>>>>>>> ---
>>>>>>>     mm/slub.c | 9 ++++++---
>>>>>>>     1 file changed, 6 insertions(+), 3 deletions(-)
>>>>>>>
>>>>>>> diff --git a/mm/slub.c b/mm/slub.c
>>>>>>> index d4403341c9df..42276f0cc920 100644
>>>>>>> --- a/mm/slub.c
>>>>>>> +++ b/mm/slub.c
>>>>>>> @@ -2227,9 +2227,12 @@ prepare_slab_obj_exts_hook(struct
>>>>>>> kmem_cache *s, gfp_t flags, void *p)
>>>>>>>         slab = virt_to_slab(p);
>>>>>>>         if (!slab_obj_exts(slab) &&
>>>>>>>             alloc_slab_obj_exts(slab, s, flags, false)) {
>>>>>>> -        pr_warn_once("%s, %s: Failed to create slab
>>>>>>> extension vector!\n",
>>>>>>> -                 __func__, s->name);
>>>>>>> -        return NULL;
>>>>>>> +        /* Recheck if a racing thread has successfully
>>>>>>> allocated slab->obj_exts. */
>>>>>>> +        if (!slab_obj_exts(slab)) {
>>>>>>> +            pr_warn_once("%s, %s: Failed to create slab
>>>>>>> extension vector!\n",
>>>>>>> +                     __func__, s->name);
>>>>>>> +            return NULL;
>>>>>>> +        }
>>>>>>>         }
>>>>>> Maybe this patch is a bit paranoid... since if
>>>>>> mark_failed_objexts_alloc()
>>>>>> win cmpxchg() and then someone else allocates the object
>>>>>> extension vector,
>>>>>> the warning will still be printed anyway.
>>>> Oh, just to be clear I was talking about the other warning:
>>>> pr_warn_once("%s, %s: Failed to create slab extension vector!",
>>>> __func__, s->name);
>>>>
>>>>> The process that successfully allocates slab_exts will call
>>>>> handle_failed_objexts_alloc, setting ref->ct = CODETAG_EMPTY
>>>>> to prevent the warning from being triggered.
>>>> But yeah I see what you mean.
>>>>
>>>> As you mentioned, if the process that failed to allocate the vector wins
>>>> cmpxchg(), later process that successfully allocate the vector would
>>>> call set_codetag_empty(), so no warning.
>>>>
>>>> But if the process that allocates the vector wins cmpxchg(),
>>>> then it won't call set_codetag_empty(), so the process
>>>> that was trying to set OBJEXTS_ALLOC_FAIL now needs to set the tag.
>>> Yes, the case I'm encountering is exactly this one.
>>>
>>>>>> But anyway, I think there is a better way to do this:
>>>> What do you think about the diff I suggested below, though?
>>> Sorry for the delayed response earlier; I was trying to deduce all
>>> possible scenarios.
>>>
>>> It makes sense to me, and I will submit the V2 version based on this
>>> suggestion.
>>>
>>> Thank you for your help.
>>>
>>>>>> diff --git a/mm/slub.c b/mm/slub.c
>>>>>> index dd4c85ea1038..d08d7580349d 100644
>>>>>> --- a/mm/slub.c
>>>>>> +++ b/mm/slub.c
>>>>>> @@ -2052,9 +2052,9 @@ static inline void
>>>>>> mark_objexts_empty(struct slabobj_ext *obj_exts)
>>>>>>         }
>>>>>>     }
>>>>>> -static inline void mark_failed_objexts_alloc(struct slab *slab)
>>>>>> +static inline bool mark_failed_objexts_alloc(struct slab *slab)
>>>>>>     {
>>>>>> -    cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
>>>>>> +    return cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL) == 0;
>>>>>>     }
>>>>>>     static inline void handle_failed_objexts_alloc(unsigned
>>>>>> long obj_exts,
>>>>>> @@ -2076,7 +2076,7 @@ static inline void
>>>>>> handle_failed_objexts_alloc(unsigned long obj_exts,
>>>>>>     #else /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
>>>>>>     static inline void mark_objexts_empty(struct slabobj_ext
>>>>>> *obj_exts) {}
>>>>>> -static inline void mark_failed_objexts_alloc(struct slab *slab) {}
>>>>>> +static inline bool mark_failed_objexts_alloc(struct slab
>>>>>> *slab) { return true; }
>> Maybe it returns false here.
>>
>> When CONFIG_MEM_ALLOC_PROFILING_DEBUG is not enabled,
>>
>> The following condition will never be executed:
>>
>> if (!mark_failed_objexts_alloc(slab) && slab_obj_exts(slab))
> Good point. But without CONFIG_MEM_ALLOC_PROFILING_DEBUG, we don't know
> if someone else successfully allocated the vector or not (unlike, with
> CONFIG_MEM_ALLOC_PROFILING_DEBUG enabled, we know that when we lose
> cmpxchg()). We cannot "fix" the case where a process fails to allocate
> the vector but another allocates the vector.
>
> So I'm not sure if checking slab_obj_exts() once more is worth it in
> this case, but I'm fine with either way.
>
>> if another process that allocates the vector, we will lose one count.
> By "one count" you mean skipping accounting the object in memory
> profiling, right?
Yes.
>
>>>>>>     static inline void handle_failed_objexts_alloc(unsigned
>>>>>> long obj_exts,
>>>>>>                 struct slabobj_ext *vec, unsigned int objects) {}
>>>>>> @@ -2125,7 +2125,9 @@ int alloc_slab_obj_exts(struct slab
>>>>>> *slab, struct kmem_cache *s,
>>>>>>         }
>>>>>>         if (!vec) {
>>>>>>             /* Mark vectors which failed to allocate */
>>>>>> -        mark_failed_objexts_alloc(slab);
>>>>>> +        if (!mark_failed_objexts_alloc(slab) &&
>>>>>> +            slab_obj_exts(slab))
>>>>>> +            return 0;
>>>>>>             return -ENOMEM;
>>>>>>         }
>>>>>>

