Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5238ACCD195
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 02:02:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 214CB8E0003; Sun, 19 Oct 2025 22:02:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ECB28E0002; Sun, 19 Oct 2025 22:02:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12A238E0003; Sun, 19 Oct 2025 22:02:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 01D568E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 22:02:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 87E488869E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 02:02:27 +0000 (UTC)
X-FDA: 84016843134.11.6F72236
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf19.hostedemail.com (Postfix) with ESMTP id 873731A0010
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 02:02:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hGc9e1Ii;
	spf=pass (imf19.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760925745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wvw6EEcLVS321+82zeKA5qCqsquigv/cxrzA5Vq7LGo=;
	b=ZHFAjHEwZjwS8e2FrXXC5YmgBN69Q7LlCZZHkotIZyaX0AvqBSi7n98jxK1+C3e9XegwOg
	BwAPUBCkDRm+cLRolYEXL1vrMNrGoTkZDscK9Od6t5Ojphq0OtrrbYFF9C0NBrPbZb9L+M
	O0eegieBPr5y8hTUySCe3ChGrVEklHw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hGc9e1Ii;
	spf=pass (imf19.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760925745; a=rsa-sha256;
	cv=none;
	b=05hESLw4afkhDAl/iR6nze4zYg6fRjtU0atkwv06lR1O5aSHu/LrrHUF7WNNR5Jk+FbW9A
	kLc8fZx3l+ITW6bC+w7KPvB1/aNrtYeKlPyuOBXbiYxA9GCc878FpmohlU/1x5SzosT1R4
	ajKG7QuDnt1GgtjvjnRrbBe4EkOapl0=
Message-ID: <3efc2a94-54c7-48a8-a804-c231d06b5ed5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760925743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wvw6EEcLVS321+82zeKA5qCqsquigv/cxrzA5Vq7LGo=;
	b=hGc9e1IiLST/psAYvB/aakCsP4XWX8OkVLTCEs0D0o0PKzJbXKei56mJzB8lGov+Y3y6o7
	Dag7c4YvbxLjuBbfOKPzW9XAxDi9ovSSPNYx1a9bDt5F6iiq0yqlCPxGeo+EshhCkcvhkk
	qdozeyfCimZd3viWAswm9uEhGE4jHBA=
Date: Mon, 20 Oct 2025 10:01:27 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] slab: Avoid race on slab->obj_exts in alloc_slab_obj_exts
To: Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hao Ge <gehao@kylinos.cn>
References: <a9ca7cc6-f4d1-4fba-a9aa-2826b9a604bc@suse.cz>
 <8F4AE1E9-7412-40D6-B383-187021266174@linux.dev>
 <7791b2b8-5db8-458c-89e2-49a0876c13a3@suse.cz>
 <CAJuCfpEWGujJe3JOjmiKLOUr49Hw_3smT6iatY7kaRBPPCWpNg@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpEWGujJe3JOjmiKLOUr49Hw_3smT6iatY7kaRBPPCWpNg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: e8amyoagzxersims3pb6cce94wm4mh1d
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 873731A0010
X-HE-Tag: 1760925745-417138
X-HE-Meta: U2FsdGVkX1/A3cdCcgK285m5Rl0HlyjKCOwYnETdLSOWbDE/9vzM134f/WdirPdNWHtbTYGn8qibgYaa+sLIbiOAanAHVcNntdWlpSjcaY0cpNoffdgzTlVfHeL0mOJrLbkL3o8kIQCUBjrfzOLAr3bA0YiQgi2GaLZ1wQd/5dQEudAIKbPMHlNmhW0uN+ntM8b6bUnesysfBhPhOcxJSszfgqmCQx1Bkub7tcr6+dBlG1uWkP9zxW2UkGta6gpazB22ThoAIdQcg1icZpQkzcwFkSajqKcsd5U3KnQlgwnS/+7UBOyKWpyiUT4skqOIq757WBqw2Ud9K6bWPDHmJi2vsHACrzZ16NLxhAFccRrbXu2lCt/uaczdEEpO2cndJJUtKYEfapkfZBbMG+5MDyKrk5+zgwIUfQ6ngvHeuKGWqewqjpJGtcwLybMJ/6fzD/cEDxyhc6z0kLSt0Pyv0M1UdZVC8Gwa5UA2vIQYJ56x3+s38qlFs6y6KF7TuzVWvwEkyeL8bzmiChT6+SbRmGgPyVHLpXbHYigt3ln1dPBD5VkZuEBeEpbA/2I+86ySqvHzA3mCtjmPg/baQ0HgC95Fg4f2f5q2qiOtXQ6enoacWZim6ow8Yx3YUv0uwmcIIbLKlYi8YYwM238LWcltY0Q1bqatN/oIrhEjDoWw+wOMuUR1gMxJJ/rp0+kZ83vX0sauqM9lN3lf++0dMyuo95rgzyglbqtBXOhZJ9Ez/qRl6DJSirEncnFtLKCg+spwHetyXVvT5kRvQ03s0eFKQ944+4W1Iq8o9456NwB8A0Qwxb6CvgnEzYE+TOrx1YhL3SHd8V4pKoZ96hpyyeNAkxcqghbvaaFJVOhx4/TUxMhV013r4JHQ8Q8JH3tE9I/9NGRykXAqqmVXqb7EU5s2bAIdPAHh+RiS9XTIwuIc/8ULn5wXxqjaPKHxAzl6ux07IREA0pkCPIHMVxQMdt4
 QvskZOqq
 ER1xryEWqunoKRF1YoAMXXwXm/oT16gbrKejuhKdoqATDamY7XtbwxjZ2pctvjvtacViJiwXelm3UllUJ0qWV56xcN6s/IgrVyJbNqtPb/QPAKoQeou0cIFoCXwwQv3/L8Tc/O57Bwo0XCeQJwDPkeVDISfM8zz9oX59dEzXIUeMsiBXJI7gwih1bGXKAvBElJQeicCArIlFESDBr/BIe06w3CHB97QIdcKLdDM8T8ctzvOnS1JxYJfDU/qnQyDLNr6FkOKzglhdaq5o10B6d2N5EIA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2025/10/18 05:52, Suren Baghdasaryan wrote:
> On Fri, Oct 17, 2025 at 3:40 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>> On 10/17/25 12:02, Hao Ge wrote:
>>>
>>>> On Oct 17, 2025, at 16:22, Vlastimil Babka <vbabka@suse.cz> wrote:
>>>>
>>>> ﻿On 10/17/25 09:40, Harry Yoo wrote:
>>>>>> On Fri, Oct 17, 2025 at 02:42:56PM +0800, Hao Ge wrote:
>>>>>> Hi Harry
>>>>>>
>>>>>>
>>>>>> Thank you for your quick response.
>>>>>>
>>>>>>
>>>>>> On 2025/10/17 14:05, Harry Yoo wrote:
>>>>>>> On Fri, Oct 17, 2025 at 12:57:49PM +0800, Hao Ge wrote:
>>>>>>>> From: Hao Ge <gehao@kylinos.cn>
>>>>>>>>
>>>>>>>> In the alloc_slab_obj_exts function, there is a race condition
>>>>>>>> between the successful allocation of slab->obj_exts and its
>>>>>>>> setting to OBJEXTS_ALLOC_FAIL due to allocation failure.
>>>>>>>>
>>>>>>>> When two threads are both allocating objects from the same slab,
>>>>>>>> they both end up entering the alloc_slab_obj_exts function because
>>>>>>>> the slab has no obj_exts (allocated yet).
>>>>>>>>
>>>>>>>> And One call succeeds in allocation, but the racing one overwrites
>>>>>>>> our obj_ext with OBJEXTS_ALLOC_FAIL. The threads that successfully
>>>>>>>> allocated will have prepare_slab_obj_exts_hook() return
>>>>>>>> slab_obj_exts(slab) + obj_to_index(s, slab, p), where slab_obj_exts(slab)
>>>>>>>> already sees OBJEXTS_ALLOC_FAIL and thus it returns an offset based
>>>>>>>> on the zero address.
>>>>>>>>
>>>>>>>> And then it will call alloc_tag_add, where the member codetag_ref *ref
>>>>>>>> of obj_exts will be referenced.Thus, a NULL pointer dereference occurs,
>>>>>>>> leading to a panic.
>>>>>>>>
>>>>>>>> In order to avoid that, for the case of allocation failure where
>>>>>>>> OBJEXTS_ALLOC_FAIL is assigned, we use cmpxchg to handle this assignment.
>>>>>>>>
>>>>>>>> Thanks for Vlastimil and Suren's help with debugging.
>>>>>>>>
>>>>>>>> Fixes: f7381b911640 ("slab: mark slab->obj_exts allocation failures unconditionally")
>>>>>>> I think we should add Cc: stable as well?
>>>>>>> We need an explicit Cc: stable to backport mm patches to -stable.
>>>>>> Oh sorry, I missed this.
>>>>>>>> Signed-off-by: Hao Ge <gehao@kylinos.cn>
>>>>>>>> ---
>>>>>>>>   mm/slub.c | 2 +-
>>>>>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>>>
>>>>>>>> diff --git a/mm/slub.c b/mm/slub.c
>>>>>>>> index 2e4340c75be2..9e6361796e34 100644
>>>>>>>> --- a/mm/slub.c
>>>>>>>> +++ b/mm/slub.c
>>>>>>>> @@ -2054,7 +2054,7 @@ static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
>>>>>>>>   static inline void mark_failed_objexts_alloc(struct slab *slab)
>>>>>>>>   {
>>>>>>>> -    slab->obj_exts = OBJEXTS_ALLOC_FAIL;
>>>>>>>> +    cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
>>>>>>>>   }
>>>>>>> A silly question:
>>>>>>>
>>>>>>> If mark_failed_objexts_alloc() succeeds and a concurrent
>>>>>>> alloc_slab_obj_exts() loses, should we retry cmpxchg() in
>>>>>>> alloc_slab_obj_exts()?
>>>>>> Great point.
>>>>>>
>>>>>> We could modify it like this, perhaps?
>>>>>>
>>>>>>   static inline void mark_failed_objexts_alloc(struct slab *slab)
>>>>>>   {
>>>>>> +       unsigned long old_exts = READ_ONCE(slab->obj_exts);
>>>>>> +       if( old_exts == 0 )
>>>>>> +               cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
>>>>>>   }
>>>>> I don't think this makes sense.
>>>>> cmpxchg() fails anyway if old_exts != 0.
>>> Aha, sorry I misunderstood what you meant.
>>>
>>>>>> Do you have any better suggestions on your end?
>>>>> I meant something like this.
>>>>>
>>>>> But someone might argue that this is not necessary anyway
>>>>> if there's a severe memory pressure :)
>>>>>
>>>>> diff --git a/mm/slub.c b/mm/slub.c
>>>>> index a585d0ac45d4..4354ae68b0e1 100644
>>>>> --- a/mm/slub.c
>>>>> +++ b/mm/slub.c
>>>>> @@ -2139,6 +2139,11 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>>>>>         slab->obj_exts = new_exts;
>>>>>     } else if ((old_exts & ~OBJEXTS_FLAGS_MASK) ||
>>>>>            cmpxchg(&slab->obj_exts, old_exts, new_exts) != old_exts) {
>>>>> +
>>>>> +        old_exts = READ_ONCE(slab->obj_exts);
>>>>> +        if (old_exts == OBJEXTS_ALLOC_FAIL &&
>>>>> +            cmpxchg(&slab->obj_exts, old_exts, new_exts) == old_exts)
>>>>> +            goto out;
>>>> Yeah, but either we make it a full loop or we don't care.
>>>> Maybe we could care because even without a severe memory pressure, one side
>>>> might be using kmalloc_nolock() and fail more easily. I'd bet it's what's
>>>> making this reproducible actually.
>>>  From my understanding, it only affected the obj_ext associated with this allocation, which was subsequently deallocated, leading to the loss of this count. Is this correct?
>> Yes.

In that case, we may really need to handle this situation and require a 
full loop.

In theory, this scenario could occur:


Thread1                                                 Thead2

alloc_slab_obj_exts                               alloc_slab_obj_exts

old_exts = READ_ONCE(slab->obj_exts) = 0

mark_failed_objexts_alloc(slab);

  cmpxchg(&slab->obj_exts, old_exts, new_exts) != old_exts

kfree and return 0;

alloc_tag_add---->a panic occurs


Alternatively, is there any code logic I might have overlooked?

> I think retrying like this should work:
>
> +retry:
>           old_exts = READ_ONCE(slab->obj_exts);
>           handle_failed_objexts_alloc(old_exts, vec, objects);
>           if (new_slab) {
> @@ -2145,8 +2146,7 @@ int alloc_slab_obj_exts(struct slab *slab,
> struct kmem_cache *s,
>                    * be simply assigned.
>                    */
>                   slab->obj_exts = new_exts;
> -        } else if ((old_exts & ~OBJEXTS_FLAGS_MASK) ||
> -                   cmpxchg(&slab->obj_exts, old_exts, new_exts) != old_exts) {
> +        } else if (old_exts & ~OBJEXTS_FLAGS_MASK) {
>                   /*
>                    * If the slab is already in use, somebody can allocate and
>                    * assign slabobj_exts in parallel. In this case the existing
> @@ -2158,6 +2158,8 @@ int alloc_slab_obj_exts(struct slab *slab,
> struct kmem_cache *s,
>                   else
>                           kfree(vec);
>                   return 0;
> +        } else if (cmpxchg(&slab->obj_exts, old_exts, new_exts) != old_exts) {
> +                goto retry;
>           }

Agree with this. If there are no issues with my comment above,

I will send V2 based on Suren's suggestion.

Additionally, I believe the "Fixes" field should be written as follows:

Fixes: 09c46563ff6d ("codetag: debug: introduce OBJEXTS_ALLOC_FAIL to 
mark failed slab_ext allocations")

Am I wrong?

>
>>>>>         /*
>>>>>          * If the slab is already in use, somebody can allocate and
>>>>>          * assign slabobj_exts in parallel. In this case the existing
>>>>> @@ -2152,6 +2157,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>>>>>         return 0;
>>>>>     }
>>>>>
>>>>> +out:
>>>>>     kmemleak_not_leak(vec);
>>>>>     return 0;
>>>>> }
>>>>>
>>>>>>>> --
>>>>>>>> 2.25.1

