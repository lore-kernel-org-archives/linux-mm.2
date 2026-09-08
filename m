Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27F91C79FAA
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 07:53:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12B4D6B0093; Tue,  8 Sep 2026 03:53:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DCA46B0095; Tue,  8 Sep 2026 03:53:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0F936B0096; Tue,  8 Sep 2026 03:53:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D15126B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:53:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C1A98015B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:53:40 +0000 (UTC)
X-FDA: 85189830600.24.3A23335
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2A83180006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:53:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pYSSX4rY;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788854018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/m0UGCD1rNVi71mlkVc+SVKZMBJRDxUcU5AjaBUwxy8=;
	b=XG181d+bAxUOURQ/eKPpdUBaJEDpEcLn2V8mVqej0MoPQV9i49s/HKK5AxWyG8z1aH2Roh
	XpSLsZ9NmPH3BsbUo1v33X3hnj28GY6ikCIJYHZRSauT6ZGNd0ymYK/XCX7QpYzNFGQ8zf
	A3WBKJwG+xVYLUzbdgadtfVvTfOAKNA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788854018;
	b=fKijlCcWq5tljw2cMTdVAo0zytAXwWVRGmRM4gyGpWOjQj+dK1DMChBlgxSIuTd90sa2yw
	sLomWC9t4TjbFJKe6zN2DrSd72B+2lffOeSQpcJw+Ok6ZBGBXfENGConWPk69FOvMMtZuD
	caRC6mF2NAHqFBpkqabRYFRDZk44f7M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pYSSX4rY;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788854014; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=/m0UGCD1rNVi71mlkVc+SVKZMBJRDxUcU5AjaBUwxy8=;
	b=pYSSX4rYfUhdiym4uGGOLp2wmrjR2dIKvphMZ8uIWdzntMQmUfVArURDpTcZ11EV/ahehwM6g4Y3AzKM2zAjGOERg8YvpJfPMY151fy5gtGYW+6gX7F5i6ZzxhSukzTJleuCMoDi+ndtM+LJxxyw+r1XAz6THXsq4fyEzMvFNvw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R851e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XAamhBZ_1788854011;
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAamhBZ_1788854011 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 08 Sep 2026 15:53:32 +0800
Message-ID: <ccb8e121-bf5b-4bb4-a9de-fb5290998ddd@linux.alibaba.com>
Date: Tue, 8 Sep 2026 15:53:31 +0800
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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <ap-yQOH0pni-mfdf@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fiq8zio1ct4qfbf9sxhsypcu6d3xd9nh
X-Rspamd-Queue-Id: 2A83180006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788854016-473881
X-HE-Meta: U2FsdGVkX1/ktgbDE28wJbrO9ot0ZdfxfnhKQqLLR2S2NvQqtjJyCbv/GaF9IvvaGKPI8tdCrda7cP9D0KuaZqpHYtL4dE740NprLm7xG7z9XsYAdLpzAcd8/Y20vBf1tfudJEG8Zwj55e4IqZSOR5E3HbyajE+KW+RqUChg6pYQOWXcDGVEDfy0kMgrEOyebdhoiYaR337dODLboGcyLghDSYrHaBuQOOTJwzreb7jRJxTVwTY9Yu89cum/ZgAO3EpAJbCZ9xN/k5hVWthuCNFb48i1U5cpZ5Pj3GxrGcaNBb8hfukb9eGggKwKWpZoRFP/+zdKnjfwXOlTjTs9vcYk8C6mOo7IM3RZhYhCfyduh2s5KabYVFq1Z2DZPLYv9a2UUEDqyNmBELkxG7sfwndmaeAWyvAprfdSUSa4sgcM7sNXBX1nanL/ymEBh/Udgb81wq+itHwHec/3bSMkTSqmhSpLBVKXnmP9fibLYA4jPDAY//xXuK3yaocf9gDvtpMBMf7QYcc193OaRUuMuTRbH5LKJvKrc6ReXmUQvAxeYfKmvcJwfnCoXK4yqF2reF6tsK93CDGTJGHwPmR+Y+7Ei6vbYFncYcwUXIFGqU0Dr+gupkXxtbZwruXW+Yw4s9E+gSbQJHvmzgtYMLjQlvSItg4EhwEOS45OGq9S/hMXuasWzCGwLWPjRc3hb/FNI7nspokaqyxvXjHBE6uIiaEeoVNgd6bKWIdJ0qIwYtTBVc6WEffyfahwAa3bqv2+unfAZHq5a9HaC8o8RkuXpiMyBqE1qE2PyX4JCg8t3n0XcetCFXW/UBiQa0KG29Zg6AbAK9/eUhVCO33P4pqnnGOJFSLb/H5cY+LWhJqvokbdDvLC8b3vg6yxfgalu5wsagDtRVtwFlfEIsZJE9CPApIUlGV2mmX/56xALtT6JspR5G/XcZLVkMlTZt6vhJvaqNlh0/Du6YjwkMP0xt5
 HFPDF2Py
 qKGevarZjIOhhHUokE5k1qkJ1lZHJrvotvDWip1MH5ZgtQomW3YL4PvNgqnQIWf5W5D3FJDBWq/SHY0L0n8FF2AemL2uA2Qz9LLfFmHS8vvUxvfvm2C9vhdVCbI5UdSjHgm2Iu2CJVtrT55ASCXzz0bWfCQKlNL1PWCiSgdXLPGutfpKQEsglMNGjk1zNg+fXln13s5PhVRg9uwRn0pOUzwg/olIOzsJBtsIq0GxPF2E0qjsbOGJJaEWbFMzLMZGcnA8g7mNo46oJ+vdk38V+UUStwamGJ3h3p2WoSyxp26lKyUD6F81Zd4cL1yQxPAL8YPjFrschWpudpxR3/SJo+Di07P8mMGIqACKQ8O4EWVYsnbk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/8/26 2:59 PM, Baoquan He wrote:
> On 09/08/26 at 12:01pm, Baolin Wang wrote:
>>
>>
>> On 9/8/26 11:03 AM, Baolin Wang wrote:
>>>
>>>
>>> On 9/8/26 10:34 AM, Barry Song wrote:
>>>> On Tue, Sep 8, 2026 at 10:30 AM Baoquan He <baoquan.he@linux.dev> wrote:
>>>>>
>>>>> Hi Baolin,
>>>>>
>>>>> On 09/07/26 at 11:25am, Baolin Wang wrote:
>>>>> ......snip...
>>>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>>>> index 40d3f1b48a74..42c0a09938ab 100644
>>>>>> --- a/mm/vmscan.c
>>>>>> +++ b/mm/vmscan.c
>>>>>
>>>>> Well, this seems to be based on Andrew's mm-new branch. I usually track
>>>>> mm-unstable branch. Maybe the subject should be marked as below?
>>>>> [PATCH mm-new] mm: mglru: clear the reference counter for rejected
>>>
>>> ACK.
>>>
>>>>>
>>>>>> @@ -5021,10 +5021,11 @@ static int evict_folios(unsigned
>>>>>> long nr_to_scan, struct lruvec *lruvec,
>>>>>>                 }
>>>>>>
>>>>>>                 /* don't add rejected folios to the oldest generation */
>>>>>> -             if (lru_gen_folio_seq(lruvec, folio, false) ==
>>>>>> min_seq[type]) {
>>>>>> -                     folio_set_lru_refs(folio, 0);
>>>>>> +             if (lru_gen_folio_seq(lruvec, folio, false) ==
>>>>>> min_seq[type])
>>>>>>                         folio_set_active(folio);
>>>>>> -             }
>>>>>> +
>>>>>> +             /* See the comments on LRU_REFS_FLAGS */
>>>>>> +             folio_set_lru_refs(folio, 0);
>>>>>
>>>>> This looks like a great catch, while the code change could bring issue.
>>>>>
>>>>> Because move_folios_to_lru() relies on folios' flags to decide their new
>>>>> generation. You just cleared it before move_folios_to_lru(). This is no
>>>>> problem for rejected folios that are determined to be put into the
>>>>> oldest generation. But for those rejected folios that are determined to
>>>>> be promoted, this could be wrong. E.g currently gen window is 4, and a
>>>>> folio is referenced, lru_gen_folio_seq() decides its new gen as 1, which
>>>>> is the 2nd oldest generation. While folio_set_lru_refs(folio, 0) clear
>>>>> referenced bit, this causes it being put into the oldest generation in
>>>>> move_folios_to_lru(), this is not expected.
>>>
>>> Yes. As I discussed with Barry earlier, lru_gen_folio_seq() also needs
>>> to be reconsidered regarding whether it should rely on PG_referenced
>>> [1].
>>>
>>> For commit 6cbdd9726fb5, we didn't discuss the impact on rejected folios
>>> either. Before commit 6cbdd9726fb5, if rejected folios did not have
>>> PG_active set by shrink_folio_list(), evict_folios() would set PG_active
>>> on these rejected folios.
>>>
>>> [1] https://lore.kernel.org/linux-mm/20260901220430.79810-1-
>>> baohua@kernel.org/
>>>
>>>> The original code looks quite weird. It even prioritizes folios
>>>> that won't be promoted by `PG_active`. Do we need to change all
>>>> the cases just to call `PG_active`?
> 
> I would agree if we can. While I have one concern. A rejected folio that
> should have gone into the oldest generation is now being promoted to the
> 2nd newest generation. In the original code, referenced folio is only
> being promoted to the next gen. I even think this is not a bug, but Yu

That's not quite true. Before commit 6cbdd9726fb5, a rejected referenced 
folio was also put back to the 2nd youngest gen.

> Zhao intentionally did it: the coldest folio is moved to 2nd newest gen,
> referenced folio (hot folio) is moved to new gen but carries the referenced
> bit. Both of them seems to be treated somewhat equally.
> 
> To me, I would rather move both of them to the next gen, while keep their
> refs untouched.

IMHO, I strongly recommend not doing this, and that's exactly the 
motivation behind my patch. Because this is also being treated as a 
promotion, it should behave like folio_inc_gen() or folio_update_gen() 
and clear the refs after promotion. I think this is a fundamental 
principle of promotion. Otherwise, ref-based promotion is already 
completely broken.

Next, I also plan to clean up refs in lru_gen_set_refs() as discussed 
with Barry.

>>> Yes. Regarding this concern, I plan to change back to the original
>>> behavior:
>>>
>>>       /* See the comments on LRU_REFS_FLAGS */
>>>       folio_set_lru_refs(folio, 0);
>>>
>>>       /* don't add rejected folios to the oldest generation */
>>>       if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
>>>           folio_set_active(folio);
>>>
>>> What do you think?
>>
>> Just FYI, after above changes, the performance improvement on zram is no
>> longer obvious either. I think this also answers Kairui's earlier question
>> about why I saw a performance improvement (which seems related to commit
>> 6cbdd9726fb5). Also, there is no obvious performance regression either.
> 
> Hi Baolin,
> 
> Not sure if it's convenient to do a little more testing in your side.
> E.g rejected folios are moved to next gen, but not clearing their flags.

I'm not sure what you mean by "next gen" here. If you mean the 2nd 
oldest gen, I actually tested that too, that is, clearing refs after 
move_folios_to_lru(), and there wasn't any noticeable performance impact 
either (but the code was a bit hacky, so I didn't go with this approach).

> Then we can at least know which one is more efficient on yout testing
> platform.
> 
> coldest folio      referenced folio
> ---------------------------------------------
> max_gen -1         next gen + referenced kept
> max_gen -1         max_gen -1
> next_gen           next gen + referenced kept
> 
> Thanks
> Baoquan


