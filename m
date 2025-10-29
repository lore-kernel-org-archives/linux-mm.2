Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9F5FCCD1BF
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 02:09:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 120EB8E0028; Tue, 28 Oct 2025 22:09:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F8858E0015; Tue, 28 Oct 2025 22:09:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00EA88E0028; Tue, 28 Oct 2025 22:09:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E44888E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 22:09:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8628EBA7FC
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 02:09:54 +0000 (UTC)
X-FDA: 84049521108.10.35B102A
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf19.hostedemail.com (Postfix) with ESMTP id 31F621A0005
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 02:09:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=erUOGeef;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761703792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wZ1yjYC/dgXU0FjIkqKm9KU8zUcua/YDv5tCcHYwZT4=;
	b=vg8dGXoNEq3WLSuU536IZLNsnn5Z5szxm7t2cxbwAEHGq3yfXfcvoMGdC+X82O6CxB4/rM
	mXCpB+eSEltnqCXMqgVLgy/1k1f24XDWNp+IrbgGDJuqGcY7rviOMb+0l6GXA6+CVhkR54
	UPYruJeh/WhpQUCjEYZs5N0MEmvB70w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761703792; a=rsa-sha256;
	cv=none;
	b=yOIT7oLTMKy7AALCMHFXdfG/CmY+jwRwcxCK3cDiLxlUMuxP2ovBPzXzeCYqchfeL3hiy1
	nAj2I/akfWgI0PNwjGmRBNjh1ybirhcbLK2s4xe3P7SjD9+gxhUQa0sfaNghyangryG9no
	fhTNyqaFikKFXFr1dbSQXQEKOGy2czw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=erUOGeef;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761703787; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=wZ1yjYC/dgXU0FjIkqKm9KU8zUcua/YDv5tCcHYwZT4=;
	b=erUOGeefFEpUwOP/TG7jfJBOlTa7YDr428HFXar8/PwJhKSuAut1zANmr4/5y0pUwbHmfFiggPSd7lvE23ml+26uyRQ7KDJGc77kZ58iYjM/DnpoZ+8X62xdHfRuZrH0eC8dPDxhYN0AE0YlzeSYNJfJHfgmqJHmHDHVCWMokqA=
Received: from 30.74.144.125(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WrDxfxu_1761703783 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 29 Oct 2025 10:09:44 +0800
Message-ID: <b1f8c5e3-0849-4c04-9ee3-5a0183d3af9b@linux.alibaba.com>
Date: Wed, 29 Oct 2025 10:09:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 David Hildenbrand <david@redhat.com>
Cc: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, ziy@nvidia.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-7-npache@redhat.com>
 <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local>
 <CAA1CXcA4AcHrw18JfAoVygRgUZW3EzsN6RPZVrC=OJwSNu_9HA@mail.gmail.com>
 <e69acbc5-0824-4b07-8744-8d5145e2580b@redhat.com>
 <e66b671f-c6df-48c1-8045-903631a8eb85@lucifer.local>
 <74583699-bd9e-496c-904c-ce6a8e1b42d9@redhat.com>
 <3dc6b17f-a3e0-4b2c-9348-c75257b0e7f6@lucifer.local>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <3dc6b17f-a3e0-4b2c-9348-c75257b0e7f6@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: hb6ini6se74kdhhbq5tk44q9hoptnefq
X-Rspam-User: 
X-Rspamd-Queue-Id: 31F621A0005
X-HE-Tag: 1761703790-272756
X-HE-Meta: U2FsdGVkX18CMRZ8XcPuF7Lbod6j4mb5i7m1QnnMvds0iyE+fJzbneovok1fwdfASe+qTIMp6OpzMLQC8vOatDYgHffY/zyfqeOCSF5SDaqkSiDUY6F3RzasbZa+8Kyud9QcSNFFR2AgsavelO/NYPSXnX0feFEt9LfdU2XndQaT5Kbdh1G53nHnhzIDRV/7mzGGAPCpCfsdCtj/ApB7YQabJT5nmnDxJvmpzCGgTqTkIULYms7uWcFhkYKGQzVAynO0lfNyHqKXvydCfinkNapFPexbsQl0kAxM6H2GTz454Bgm+TaTx5QC1PbiY7uWhvA0AI/4UvblIynGvJDym6Qah5JZGweTNkgGH9ti+oZyQ0nkcXKElRTD0g5MYYiQQG3d1N/cBfU0raeMULAYRQkMteoN7M9czjb7wtluHrsbANemAfQ4cpm1ViEizWwBMsvi+hoQf98KznoXbcRs+ujSNTUNPdUo1KwWihwGtYE2G9lBXkSp8InaAyqu6dQ7CrXNwBPSBFIEZWilSDptRbNbDiYCC19GZhkyQBW9dzuIpVb4ILMImolG1r4UW1RkghBIfF4gmDp9TnOVtwMkFSaiaL61MB27XEUQmrKQn2thLna6rmfDABEQNq9ZH1RSDlRon7f+o3MkTm9Iik7Hlo75i5Wh6qxtfW6PsiEjyN/TCtP0u7U5vV8Vj+2Wbg/pndDouI+c1nKShlAgz8LO3zzvh5R/HDMXwVIW9OaSbWz38xs92FYYTOR4GjtaYJYgVAOIOdEQPmc0ZAQ3kke4CfFZBbJm/YOosSnt9ZbOSVukJvQRwrCx1ozme4K1gAwU4rLtsxcuz3SsjnHtWRLvHSkNKnotdaD9FRJD0X/AMjjtgM7e1Eu9Xou4MFEkMOEsLUeS/cXDjbCs5uL2QClX7c+iMbM52xYATPnqOuNMiFF/JHknb4w9ieBBKm6S2rBdk4sgTcDSyw7GPoXdPob
 eT5/01Ba
 O4RkfsV8Dp9Cv77ij0g9gyyQP+zpJvxUIwG2CVuuV6pjdmK5ZBAjVMjCF6pWp35+wz9hclabq6CSRYCf4N7/2StHoGj25CclrHv7jzP8q6JZPPJUQ/kJ2lRiAiZTU+3f19aH8RvtrCYsZzfaNRu+Y8n4Pc9ev7lLZyNEeju31dc8kvaz7cT3YjztaQrc6UXZYeAkuriDtnHANjrJeqB47xYzSwOyVMZMCvWEPW7WidTPyVtLIiw+PqW0WLYPxb2aU65PqEkgi0xs7NenxuUU0/EOJdydojH2oKmWupgeTcPqUCU1uQ6XNUowuQAU8zHbKdpY6HuWgWfXg8ff7l5ZyYDvKS4o+Y4SMzeLbiAP9AGlc/EjEVyBozy+MvNHlEh677jUMNya8Bs344uwwQtNilD7js4LoyrhXoLPbsjj1koTzdEg/aMVwhAHOuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/29 02:59, Lorenzo Stoakes wrote:
> On Tue, Oct 28, 2025 at 07:08:38PM +0100, David Hildenbrand wrote:
>>
>>>>> Hey Lorenzo,
>>>>>
>>>>>> I mean not to beat a dead horse re: v11 commentary, but I thought we were going
>>>>>> to implement David's idea re: the new 'eagerness' tunable, and again we're now just
>>>>>> implementing the capping at HPAGE_PMD_NR/2 - 1 thing again?
>>>>>
>>>>> I spoke to David and he said to continue forward with this series; the
>>>>> "eagerness" tunable will take some time, and may require further
>>>>> considerations/discussion.
>>>>
>>>> Right, after talking to Johannes it got clearer that what we envisioned with
>>>
>>> I'm not sure that you meant to say go ahead with the series as-is with this
>>> silent capping?
>>
>> No, "go ahead" as in "let's find some way forward that works for all and is
>> not too crazy".
> 
> Right we clearly needed to discuss that further at the time but that's moot now,
> we're figuring it out now :)
> 
>>
>> [...]
>>
>>>> "eagerness" would not be like swappiness, and we will really have to be
>>>> careful here. I don't know yet when I will have time to look into that.
>>>
>>> I guess I missed this part of the converastion, what do you mean?
>>
>> Johannes raised issues with that on the list and afterwards we had an
>> offline discussion about some of the details and why something unpredictable
>> is not good.
> 
> Could we get these details on-list so we can discuss them? This doesn't have to
> be urgent, but I would like to have a say in this or at least be part of the
> converastion please.
> 
>>
>>>
>>> The whole concept is that we have a paramaeter whose value is _abstracted_ and
>>> which we control what it means.
>>>
>>> I'm not sure exactly why that would now be problematic? The fundamental concept
>>> seems sound no? Last I remember of the conversation this was the case.
>>
>> The basic idea was to do something abstracted as swappiness. Turns out
>> "swappiness" is really something predictable, not something we can randomly
>> change how it behaves under the hood.
>>
>> So we'd have to find something similar for "eagerness", and that's where it
>> stops being easy.
> 
> I think we shouldn't be too stuck on
> 
>>
>>>
>>>>
>>>> If we want to avoid the implicit capping, I think there are the following
>>>> possible approaches
>>>>
>>>> (1) Tolerate creep for now, maybe warning if the user configures it.
>>>
>>> I mean this seems a viable option if there is pressure to land this series
>>> before we have a viable uAPI for configuring this.
>>>
>>> A part of me thinks we shouldn't rush series in for that reason though and
>>> should require that we have a proper control here.
>>>
>>> But I guess this approach is the least-worst as it leaves us with the most
>>> options moving forwards.
>>
>> Yes. There is also the alternative of respecting only 0 / 511 for mTHP
>> collapse for now as discussed in the other thread.
> 
> Yes I guess let's carry that on over there.
> 
> I mean this is why I said it's better to try to keep things in one thread :) but
> anyway, we've forked and can't be helped now.
> 
> To be clear that was a criticism of - email development - not you.
> 
> It's _extremely easy_ to have this happen because one thread naturally leads to
> a broader discussion of a given topic, whereas another has questions from
> somebody else about the same topic, to which people reply and then... you have a
> fork and it can't be helped.
> 
> I guess I'm saying it'd be good if we could say 'ok let's move this to X'.
> 
> But that's also broken in its own way, you can't stop people from replying in
> the other thread still and yeah. It's a limitation of this model :)
> 
>>
>>>
>>>> (2) Avoid creep by counting zero-filled pages towards none_or_zero.
>>>
>>> Would this really make all that much difference?
>>
>> It solves the creep problem I think, but it's a bit nasty IMHO.
> 
> Ah because you'd end up wtih a bunch of zeroed pages from the prior mTHP
> collapses, interesting...
> 
> Scanning for that does seem a bit nasty though yes...
> 
>>
>>>
>>>> (3) Have separate toggles for each THP size. Doesn't quite solve the
>>>>       problem, only shifts it.
>>>
>>> Yeah I did wonder about this as an alternative solution. But of course it then
>>> makes it vague what the parent values means in respect of the individual levels,
>>> unless we have an 'inherit' mode there too (possible).
>>>
>>> It's going to be confusing though as max_ptes_none sits at the root khugepaged/
>>> level and I don't think any other parameter from khugepaged/ is exposed at
>>> individual page size levels.
>>>
>>> And of course doing this means we
>>>
>>>>
>>>> Anything else?
>>>
>>> Err... I mean I'm not sure if you missed it but I suggested an approach in the
>>> sub-thread - exposing mthp_max_ptes_none as a _READ-ONLY_ field at:
>>>
>>> /sys/kernel/mm/transparent_hugepage/khugepaged/max_mthp_ptes_none
>>>
>>> Then we allow the capping, but simply document that we specify what the capped
>>> value will be here for mTHP.
>>
>> I did not have time to read the details on that so far.
> 
> OK. It is a bit nasty, yes. The idea is to find something that allows the
> capping to work.
> 
>>
>> It would be one solution forward. I dislike it because I think the whole
>> capping is an intermediate thing that can be (and likely must be, when
>> considering mTHP underused shrinking I think) solved in the future
>> differently. That's why I would prefer adding this only if there is no
>> other, simpler, way forward.
> 
> Yes I agree that if we could avoid it it'd be great.
> 
> Really I proposed this solution on the basis that we were somehow ok with the
> capping.
> 
> If we can avoid that'd be ideal as it reduces complexity and 'unexpected'
> behaviour.
> 
> We'll clarify on the other thread, but the 511/0 was compelling to me before as
> a simplification, and if we can have a straightforward model of how mTHP
> collapse across none/zero page PTEs behaves this is ideal.
> 
> The only question is w.r.t. warnings etc. but we can handle details there.
> 
>>
>>>
>>> That struck me as the simplest way of getting this series landed without
>>> necessarily violating any future eagerness which:
>>>
>>> a. Must still support khugepaged/max_ptes_none - we aren't getting away from
>>>      this, it's uAPI.
>>>
>>> b. Surely must want to do different things for mTHP in eagerness, so if we're
>>>      exposing some PTE value in max_ptes_none doing so in
>>>      khugepaged/mthp_max_ptes_none wouldn't be problematic (note again - it's
>>>      readonly so unlike max_ptes_none we don't have to worry about the other
>>>      direction).
>>>
>>> HOWEVER, eagerness might want want to change this behaviour per-mTHP size, in
>>> which case perhaps mthp_max_ptes_none would be problematic in that it is some
>>> kind of average.
>>>
>>> Then again we could always revert to putting this parameter as in (3) in that
>>> case, ugly but kinda viable.
>>>
>>>>
>>>> IIUC, creep is less of a problem when we have the underused shrinker
>>>> enabled: whatever we over-allocated can (unless longterm-pinned etc) get
>>>> reclaimed again.
>>>>
>>>> So maybe having underused-shrinker support for mTHP as well would be a
>>>> solution to tackle (1) later?
>>>
>>> How viable is this in the short term?
>>
>> I once started looking into it, but it will require quite some work, because
>> the lists will essentially include each and every (m)THP in the system ...
>> so i think we will need some redesign.
> 
> Ack.
> 
> This aligns with non-0/511 settings being non-functional for mTHP atm anyway.
> 
>>
>>>
>>> Another possible solution:
>>>
>>> If mthp_max_ptes_none is not workable, we could have a toggle at, e.g.:
>>>
>>> /sys/kernel/mm/transparent_hugepage/khugepaged/mthp_cap_collapse_none
>>>
>>> As a simple boolean. If switched on then we document that it caps mTHP as
>>> per Nico's suggestion.
>>>
>>> That way we avoid the 'silent' issue I have with all this and it's an
>>> explicit setting.
>>
>> Right, but it's another toggle I wish we wouldn't need. We could of course
>> also make it some compile-time option, but not sure if that's really any
>> better.
>>
>> I'd hope we find an easy way forward that doesn't require new toggles, at
>> least for now ...
> 
> Right, well I agree if we can make this 0/511 thing work, let's do that.
> 
> Toggle are just 'least worst' workarounds on assumption of the need for capping.

I finally finished reading through the discussions across multiple 
threads:), and it looks like we've reached a preliminary consensus (make 
0/511 work). Great and thanks!

IIUC, the strategy is, configuring it to 511 means always enabling mTHP 
collapse, configuring it to 0 means collapsing mTHP only if all PTEs are 
non-none/zero, and for other values, we issue a warning and prohibit 
mTHP collapse (avoid Lorenzo's concern about silently changing 
max_ptes_none). Then the implementation for collapse_max_ptes_none() 
should be as follows:

static int collapse_max_ptes_none(unsigned int order, bool full_scan)
{
         /* ignore max_ptes_none limits */
         if (full_scan)
                 return HPAGE_PMD_NR - 1;

         if (order == HPAGE_PMD_ORDER)
                 return khugepaged_max_ptes_none;

         /*
          * To prevent creeping towards larger order collapses for mTHP 
collapse,
          * we restrict khugepaged_max_ptes_none to only 511 or 0, 
simplifying the
          * logic. This means:
          * max_ptes_none == 511 -> collapse mTHP always
          * max_ptes_none == 0 -> collapse mTHP only if we all PTEs are 
non-none/zero
          */
         if (!khugepaged_max_ptes_none || khugepaged_max_ptes_none == 
HPAGE_PMD_NR - 1)
                 return khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - 
order);

         pr_warn_once("mTHP collapse only supports 
khugepaged_max_ptes_none configured as 0 or %d\n", HPAGE_PMD_NR - 1);
         return -EINVAL;
}

So what do you think?

