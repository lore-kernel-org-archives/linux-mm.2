Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54303C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63C2C6B009B; Tue,  8 Sep 2026 05:39:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ED206B009D; Tue,  8 Sep 2026 05:39:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5030F6B009E; Tue,  8 Sep 2026 05:39:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DC2B6B009B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:39:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 92404A499A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:39:56 +0000 (UTC)
X-FDA: 85190098392.14.D645895
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf23.hostedemail.com (Postfix) with ESMTP id E061C14000D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:39:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Cic+u846;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788860394;
	b=k9G4PL08tBz/8XAohpTmKAED3yWb9KT/ZopPRJAkwdxQ3+Fs+jD4fxppAAt4XY8VieHaxn
	6QLZnN6epUwbmm6pAMbOpqA4nTfot2qeWJsgMpx9SqQaS3gpr18P9+jzf5853n1lJbCZdB
	AIxN2yZNL6ricdWCv069BWnI5HYGDac=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788860394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PWYEPdRQ17N+5c66Weq133KixewGNO1R8mkZenc6WbY=;
	b=iI8f7/X6S81TLJGbyDIt0kJof37pwXZNMa9JX/Jll7MAETSpyTkPdggyqYPX6/H4AYAmse
	u5jZqHEerasDVM0Cz8Pv8WHCDjFPhE4uwfcKVjuwQVEloyyWC4UQwO7QJ4qBrmqSFJz628
	gr0IeO/JA2CmMAs3a1Tyg5DE/p9DwKg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Cic+u846;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788860389; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=PWYEPdRQ17N+5c66Weq133KixewGNO1R8mkZenc6WbY=;
	b=Cic+u846FrOo/HnPqczZ5svjiXr8dG6uHZLBosIuAQXmLh32R7KXq7NMhZX2Z9j9MDd+wLNua10GAnxJbknakiPteo+64KfSbcBG8tvew6p6DYcvf4AwS/ELBKEChldlkrWDD55JcyotB3SjRHq50kwGnWEzeJjJqSyurnIF9VA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XAbBF0o_1788860384;
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAbBF0o_1788860384 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 08 Sep 2026 17:39:46 +0800
Message-ID: <7d2ee486-0f59-43b7-8449-fed82b796a73@linux.alibaba.com>
Date: Tue, 8 Sep 2026 17:39:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: mglru: clear the reference counter for rejected
 folios
To: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>, akpm@linux-foundation.org,
 kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org, ljs@kernel.org,
 ridong.chen@linux.dev, hebaoquan@kylinos.cn, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <8e4db9a298c5ea6ccb192e274caed5b96f0cf022.1788751143.git.baolin.wang@linux.alibaba.com>
 <ap9zPPughaSlfXM2@fedora>
 <CAGsJ_4wn5ArqhG9w7gJY7X4G+Lg6=1teCb70dzPdN0k+5H8MbQ@mail.gmail.com>
 <67d9bbcf-2991-4867-8afb-14bad1cebf8d@linux.alibaba.com>
 <31494361-406e-4874-8a2c-2c6f5cee5321@linux.alibaba.com>
 <ap-yQOH0pni-mfdf@fedora>
 <ccb8e121-bf5b-4bb4-a9de-fb5290998ddd@linux.alibaba.com>
 <ap_GBGDHkEzZ1Osq@fedora>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <ap_GBGDHkEzZ1Osq@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E061C14000D
X-Stat-Signature: 7a1ri96igews9fgfojkytrs8gywcmwq9
X-HE-Tag: 1788860392-144141
X-HE-Meta: U2FsdGVkX18FtTvGCbggirCdytSukv9ivsftxr18ahwaJ4b8Ia22PTo0CHdinskbZvE4CC+7axrS3Dvapz8Dy9rTTe7Fg4npyCT2SccbdWgRkt+dJwFPTL+3JCKJW73+kvW3KvcbGFY92PHIzjRJfgvQt7YHqPA5TkojeH/Vr6dJNicJ/sThOqoT4yR+TKBeHOXNBosxOhPGLSlb14jEIIfo+wj7KgGsWiKd1dH40DwSxcvUYmUXvVoGbKlx2PwfWNby05wrCEtFVozt/RTqggjppBTSah+3jhzDa3kjIn8kIMmtBeJgvCkFgkhDd3/2vYrmJlGjjSF3PLHr95jw/y4j/8OIdsNL5C/UfPEw1fXiqcRQeqtLk1J3Jr1ImnQTPPzsDebYenByhMVs4ZZuqPB1xWEEs6WCj1ZS5tXIgck/xlKI3qpL4UMAVl9eNGiPW0VvMlCEaAbZq/KBa9jllwWrsrx+Bf9jmUkblk17pxw2OoydVfXKchFWSEjFNPNYYHUJVUvyNI9FSLeb7cEUXZuf8UINrWYteKXaiyRpFDySdIHrwi3jginxPjXFOU2PPKJL3rxNzl6/S2tFuioVVeYJoAJScecizjBWavJk6dP2q/k8+q6GvsStdMQP1rQ9pxVoXRoBgA5R94SGIKgZe8fHGI76T/2p8Jn+srr+TtYKFaJLtfux6tYmVlLQZOlbIoTJTFn8mTyoVy2rDsr/MeEadHDMrH3XsYVQnXZh8bdV1MMmGFxkAlnQSW9aHKk3B1/brFXPfeEmlKhkEiDCQ/YFVwzhxEMlOhpSNPchLMmhea6p14MlyGKAW9+BH4wGuErWttVbVbOW+YVMU1yjXkQRtc4OkxUSmKq0/KubMWcE3myk26Kqg//1afLl4ulwMCM6J0jpySNPoPKrPxbLzQuZoTIzVDLM2FWHiwoEVNWw20xOeQCOmiNNW8zjJv83+mDHrY90pa+vNchaiNt
 PKvVU8fw
 7Ef5zdtizd067MDHzrTPrBLldINUF7TQhCyyGzOUoF5/uLMeIitESmNM4jyvHNClobV+Q+Ni+1MluwNCr9HnwzTChEZCWrtCURm4vC6Y4WDZ+WhbRLo3/pVsf3wfaXC7UIrVsI2McdkF/XWRCvzv423ovmaq+EuxMYqi3KIX2wH6/KlpL5EO6GTXCAZqeHojsQuS9DxjsQXpz79iL1N4ee2qAy5zjGqBWiXwvTMA2MiOacI5MgmFMFEaTh7/jkIYEmyApYjWceXh5zaXcw5g2keNoL6i/W+MsAt5ZJ0HsDaqnnneatwF12L0FD46a/OCpReSgfX64l+gVLcHJofWhBuEERMwHrv2sgU+P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/8/26 4:23 PM, Baoquan He wrote:
> On 09/08/26 at 03:53pm, Baolin Wang wrote:
>>
>>
>> On 9/8/26 2:59 PM, Baoquan He wrote:
>>> On 09/08/26 at 12:01pm, Baolin Wang wrote:
>>>>
>>>>
>>>> On 9/8/26 11:03 AM, Baolin Wang wrote:
>>>>>
>>>>>
>>>>> On 9/8/26 10:34 AM, Barry Song wrote:
>>>>>> On Tue, Sep 8, 2026 at 10:30 AM Baoquan He <baoquan.he@linux.dev> wrote:
>>>>>>>
>>>>>>> Hi Baolin,
>>>>>>>
>>>>>>> On 09/07/26 at 11:25am, Baolin Wang wrote:
>>>>>>> ......snip...
>>>>>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>>>>>> index 40d3f1b48a74..42c0a09938ab 100644
>>>>>>>> --- a/mm/vmscan.c
>>>>>>>> +++ b/mm/vmscan.c
>>>>>>>
>>>>>>> Well, this seems to be based on Andrew's mm-new branch. I usually track
>>>>>>> mm-unstable branch. Maybe the subject should be marked as below?
>>>>>>> [PATCH mm-new] mm: mglru: clear the reference counter for rejected
>>>>>
>>>>> ACK.
>>>>>
>>>>>>>
>>>>>>>> @@ -5021,10 +5021,11 @@ static int evict_folios(unsigned
>>>>>>>> long nr_to_scan, struct lruvec *lruvec,
>>>>>>>>                  }
>>>>>>>>
>>>>>>>>                  /* don't add rejected folios to the oldest generation */
>>>>>>>> -             if (lru_gen_folio_seq(lruvec, folio, false) ==
>>>>>>>> min_seq[type]) {
>>>>>>>> -                     folio_set_lru_refs(folio, 0);
>>>>>>>> +             if (lru_gen_folio_seq(lruvec, folio, false) ==
>>>>>>>> min_seq[type])
>>>>>>>>                          folio_set_active(folio);
>>>>>>>> -             }
>>>>>>>> +
>>>>>>>> +             /* See the comments on LRU_REFS_FLAGS */
>>>>>>>> +             folio_set_lru_refs(folio, 0);
>>>>>>>
>>>>>>> This looks like a great catch, while the code change could bring issue.
>>>>>>>
>>>>>>> Because move_folios_to_lru() relies on folios' flags to decide their new
>>>>>>> generation. You just cleared it before move_folios_to_lru(). This is no
>>>>>>> problem for rejected folios that are determined to be put into the
>>>>>>> oldest generation. But for those rejected folios that are determined to
>>>>>>> be promoted, this could be wrong. E.g currently gen window is 4, and a
>>>>>>> folio is referenced, lru_gen_folio_seq() decides its new gen as 1, which
>>>>>>> is the 2nd oldest generation. While folio_set_lru_refs(folio, 0) clear
>>>>>>> referenced bit, this causes it being put into the oldest generation in
>>>>>>> move_folios_to_lru(), this is not expected.
>>>>>
>>>>> Yes. As I discussed with Barry earlier, lru_gen_folio_seq() also needs
>>>>> to be reconsidered regarding whether it should rely on PG_referenced
>>>>> [1].
>>>>>
>>>>> For commit 6cbdd9726fb5, we didn't discuss the impact on rejected folios
>>>>> either. Before commit 6cbdd9726fb5, if rejected folios did not have
>>>>> PG_active set by shrink_folio_list(), evict_folios() would set PG_active
>>>>> on these rejected folios.
>>>>>
>>>>> [1] https://lore.kernel.org/linux-mm/20260901220430.79810-1-
>>>>> baohua@kernel.org/
>>>>>
>>>>>> The original code looks quite weird. It even prioritizes folios
>>>>>> that won't be promoted by `PG_active`. Do we need to change all
>>>>>> the cases just to call `PG_active`?
>>>
>>> I would agree if we can. While I have one concern. A rejected folio that
>>> should have gone into the oldest generation is now being promoted to the
>>> 2nd newest generation. In the original code, referenced folio is only
>>> being promoted to the next gen. I even think this is not a bug, but Yu
>>
>> That's not quite true. Before commit 6cbdd9726fb5, a rejected referenced
>> folio was also put back to the 2nd youngest gen.
> 
> OK, I didn't follow your earlier discussion, I need take some time to
> fully understand that commit and the patch thread from Ehab.
> 
>>
>>> Zhao intentionally did it: the coldest folio is moved to 2nd newest gen,
>>> referenced folio (hot folio) is moved to new gen but carries the referenced
>>> bit. Both of them seems to be treated somewhat equally.
>>>
>>> To me, I would rather move both of them to the next gen, while keep their
>>> refs untouched.
>>
>> IMHO, I strongly recommend not doing this, and that's exactly the motivation
>> behind my patch. Because this is also being treated as a promotion, it
>> should behave like folio_inc_gen() or folio_update_gen() and clear the refs
>> after promotion. I think this is a fundamental principle of promotion.
>> Otherwise, ref-based promotion is already completely broken.
> 
> OK, it makes sense to me to make principle of promotion strictly applied
> no efficiency degradation involved.
> 
>>
>> Next, I also plan to clean up refs in lru_gen_set_refs() as discussed with
>> Barry.
> 
> Looks forward to seeing that. By the way, your discussion with Baryr is
> private or in public list, do you have pointer if public? Thanks.

I raised this issue before[1], and recently there has been another 
discussion[2] about it (we had some private discussions, but I'll post a 
new patch for discussion).

[1] 
https://lore.kernel.org/all/eb395442-0aad-428a-a5ac-9072d2d89060@linux.alibaba.com/
[2] 
https://lore.kernel.org/linux-mm/20260901220430.79810-1-baohua@kernel.org/

>>>>> Yes. Regarding this concern, I plan to change back to the original
>>>>> behavior:
>>>>>
>>>>>        /* See the comments on LRU_REFS_FLAGS */
>>>>>        folio_set_lru_refs(folio, 0);
>>>>>
>>>>>        /* don't add rejected folios to the oldest generation */
>>>>>        if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
>>>>>            folio_set_active(folio);
>>>>>
>>>>> What do you think?
>>>>
>>>> Just FYI, after above changes, the performance improvement on zram is no
>>>> longer obvious either. I think this also answers Kairui's earlier question
>>>> about why I saw a performance improvement (which seems related to commit
>>>> 6cbdd9726fb5). Also, there is no obvious performance regression either.
>>>
>>> Hi Baolin,
>>>
>>> Not sure if it's convenient to do a little more testing in your side.
>>> E.g rejected folios are moved to next gen, but not clearing their flags.
>>
>> I'm not sure what you mean by "next gen" here. If you mean the 2nd oldest
>> gen, I actually tested that too, that is, clearing refs after
>> move_folios_to_lru(), and there wasn't any noticeable performance impact
>> either (but the code was a bit hacky, so I didn't go with this approach).
> 
> Yeah, I meant the 2nd oldest gen, while what I am curious about is moving
> them into 2nd oldest gen but not clearing refs. Clearly it's conflicting
> with your plan. Anyway, it's just a brain store idea, please forget it.
> Thanks for the sharing and detailed explanation.

Thanks for reviewing.

