Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FECECDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 04:07:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 232616B0092; Mon, 22 Jun 2026 00:07:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 209E96B0093; Mon, 22 Jun 2026 00:07:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11FF66B0095; Mon, 22 Jun 2026 00:07:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB5D06B0092
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 00:07:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 60CA2140582
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:07:04 +0000 (UTC)
X-FDA: 84906213168.04.901A64D
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2688C20002
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:07:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ux2VdKki;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782101222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rOuZYODIvBG/kbzslXXXSihA6AhxcXkn77Yw1lY3LFs=;
	b=KF6DFMfC6dcK6X0BJrqL587YpnjBjYpUVXFFXxyeMdbv8bxbDK0CJZ7zo3WSo4RkgaakxV
	r2J4etooH4LUODpXuAKV6pP5wrNfJXOZIzYSO80wjv12t4hvUY0ZDkm2YEggaAF6tbq4iO
	LS1y+lWzra8gqOgSXjNjGl5UZDsMM44=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782101222;
	b=Cl3l6FF5h4VCPDo+nPKT2XTv4lI8wVEbQKVJ9kVHynNKL51obkSkEJzVpcIkqQLrZTJsyn
	IA8qRqum+KIaRZ9fsJ1duDywmzbHLqpW/BhPc9iFdvW48JN9k3abOY0OsuJCsAIZdrcCnt
	TU24sH0I01s9bZdD9vHocmb9RmfSYC0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ux2VdKki;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782101218; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=rOuZYODIvBG/kbzslXXXSihA6AhxcXkn77Yw1lY3LFs=;
	b=ux2VdKkilSC6tvQ5H9UxcR40GImrj254K29dVPBZbv1yZYQ/X8ogR8vZNmw+olIZrUqXRzKM5EvuEJpIzRRtkb6/18F5zlCGzwQctCIHiH1Gn+hTQwiN0ec+CUCHcm4BQvqqv4HxHAdigWMwmkwQ9OpEvH6q+aVO+5ti0zgykgY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0X5H70mj_1782101214;
Received: from 30.74.144.120(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X5H70mj_1782101214 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 22 Jun 2026 12:06:55 +0800
Message-ID: <c3866c25-4baf-4539-8be9-928a460e322f@linux.alibaba.com>
Date: Mon, 22 Jun 2026 12:06:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: Avoiding split large folios if swap has no space
To: Barry Song <baohua@kernel.org>
Cc: david@kernel.org, akpm@linux-foundation.org, axelrasmussen@google.com,
 dev.jain@arm.com, kasong@tencent.com, lance.yang@linux.dev,
 liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, npache@redhat.com, qi.zheng@linux.dev, ryan.roberts@arm.com,
 shakeel.butt@linux.dev, weixugc@google.com, yuanchu@google.com,
 zhaonanzhe@xiaomi.com, ziy@nvidia.com
References: <5790c4a4-d502-4180-82f5-47de5809a4fe@kernel.org>
 <20260620081017.89085-1-baohua@kernel.org>
 <6e89f868-ca7a-484f-aeea-5d8d029714f2@linux.alibaba.com>
 <CAGsJ_4w=nyJGn1uuwbMjG1JXG8TmiENBtzE0bXQN1Nd34ONdBQ@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4w=nyJGn1uuwbMjG1JXG8TmiENBtzE0bXQN1Nd34ONdBQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dphx3dhirazizoab3f9oxmu787qfqodb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2688C20002
X-HE-Tag: 1782101220-490434
X-HE-Meta: U2FsdGVkX1/3wFPTLZ4FcCzQ5PE3rPPDMAkruWAvd0ckTLw3wV6Y+HbGxTZUY7nnLyZ6h01ziunHvej1oCiADVEEcDzArCzTLSe1tdSFxtHHNZZCCNPk2f4yE7dQePi9JvQEBe+SrbRJ3PwgpOC9WPgW11/qF2O81n/6TZKjX0DVzawFEBNzzaABD0jpz9C1UdT3jMM3hSBBI/ijl+RT4tZbnvC7rba/tNF32Zgg4BAi/PcJx308dcCCqc6AjEn+uC9rdp5pZfVfXs3uqBWzE5LcWicYZVgTOMDcBmwWUBOVGk18Tkr9B2NeB6qWJ4Z6RA3YLgnu2kuBFUSV04ihbxc2k81C0iW/PP8MUnGW0+DUpWYMK1uQGXX6qL5sArOfK5dhUulQiijC8EWRCtIrPfEYbFWWCzfAjKA+X1uUw7eDqrGVQgS0mWD/ERYlrAx/34SVquQdSBXrNY4zKbR+0LiA8gklUSjhHiCys/Ldonwm2E076uGyrT3jL07ed3xmCF+RWI2xwTF1uvfUYBQlxqsX7Vavh6b3m0291pyFxYpPsWHvlVwBQatuZwNMtqREF+DIRKXS+9HuBTdgeAuyhu9ZhJSQLSJ3yl3TM0BsgYQPstend3pN3QFF2ixGFbmdxq+u2lL53rEwZpEpyY7ZG5QRgOSiu+7jxN1pwYc8K2Dllu/n09Q24HM61fDyHRxboBdUCWFGTFmBJ2MqkT5bXwf777s6WmC0dLC6TY9/O9/nW7cNvDqNsxxv068cBQKUzZYesdna2Bx61WZAq8fuhXYZ9Dbu76zSKgiI9W30c1L8T7a/zF6MjWx0JSoUYkxMR0aNtsm5tc4LyssbweN7aVXWAQYlCNkec6V6O6Vua166jsuTMkbvgHgFzh4qJA+WE/gv79abxj8nJtu8tnQA84fqB8XZcq9v6fKRrT58+C3z30TpqK+1ECN4KpOzA0DgcrTNWJhy2nd6mppKrzb
 XPSAeHnG
 aDUjNRlMzAzpD3Ela8eHVd26B9r7f04aD1PHlqVIFigbU1DmO34K8hZterx00z2bHZrgCIBWz7SgmUiNvzaOayzLSTJUGPHYxn5TT67/J+rfoAOJ/yTADHMIvWJ+f7TuyZynllQ8GR34QEKl/baQStUaY590hkPDyJRu438bjXbmFmn7SdVdyw+C4PbcfEOaZbvXx/H0nxxeMMoykWzIec6zVO77ZZfRFbSULjoE6H9hLFzMdvnYag5nbSDi2fjsuiOlfqDN1H9kPZIVnBGkp9Sryr2MbwZ0YCl+elRQwJaPSDer4fmT1iB6ZLhuAnQ4coFaY/yHO4d/Uw+cXb0fTMqbnpC5v3Sco2zk2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/22/26 11:36 AM, Barry Song wrote:
> On Mon, Jun 22, 2026 at 11:04 AM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>>
>>
>> On 6/20/26 4:10 PM, Barry Song (Xiaomi) wrote:
>>> On Fri, Jun 19, 2026 at 10:04 PM David Hildenbrand (Arm) <david@kernel.org> wrote:
>>> [...]
>>>>>         /*
>>>>>          * The page can not be swapped.
>>>>>          *
>>>>> @@ -1280,6 +1289,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>>>>>
>>>>>                                 if (!folio_test_large(folio))
>>>>>                                         goto activate_locked_split;
>>>>> +                             if (!__can_reclaim_anon_pages(memcg, sc))
>>>>> +                                     goto activate_locked_split;
>>>>
>>>> Why are we even trying to allocate swap space if we cannot reclaim such pages?
>>>> Makes we wonder whether we would want to have that check earlier, before the
>>>> folio_alloc_swap().
>>>>
>>>> Any downsides?
>>>
>>> I don't think there are any obvious downsides there. One issue is that
>>> the memcg may not be passed from reclaim_pages(), so memcg would
>>> always be NULL. However, the folio could still belong to a memcg
>>> whose swap quota has been exhausted. In that case, my
>>> __can_reclaim_anon_pages() will fail when checking whether we can
>>> swap out. But switching to folio_memcg() also seems awkward.
>>>
>>> So I feel Kairui’s suggestion [1] might be the best approach. In
>>> folio_alloc_swap(), we return -EAGAIN to tell vmscan.c that
>>> we can split the folio and retry the swap-out.
>>> only when there are sufficient swap slots and sufficient memcg swap
>>> quota do we return -EAGAIN, allowing vmscan to perform a split.
>>>
>>> diff --git a/mm/swapfile.c b/mm/swapfile.c
>>> index 78b49b0658ad..62e2c506ccae 100644
>>> --- a/mm/swapfile.c
>>> +++ b/mm/swapfile.c
>>> @@ -1755,6 +1755,9 @@ int folio_alloc_swap(struct folio *folio)
>>>                        VM_WARN_ON_ONCE(1);
>>>                        return -EINVAL;
>>>                }
>>> +
>>> +             if (get_nr_swap_pages() < (1 << order))
>>> +                     return -ENOMEM;
>>
>> Shouldn't this return -EAGAIN? Suppose we try to swap out an order-9
>> large folio but get_nr_swap_pages() returns 256, then we'd still need to
>> split the order-9 large folio to reclaim some memory.
> 
> I guess Kairui has the opposite view. Quoting Kairui:
> 
> "- 1. the mem_cgroup_try_charge_swap in it failed
> - 2. allocation failed but nr_swap_pages > folio size
> - 3. allocation failed because all devices are full or unusable
> (roughly nr_swap_pages < folio size)
> 
> Only case 2 requires splitting. __can_reclaim_anon_pages also checks
> demote which is not related to swap."
> 
> For example, if get_nr_swap_pages() returns 1, we can only
> swap out a single page after splitting. Is that really worth
> it? On the other hand, if it returns 256, we could at least
> swap out half of an order-9 large folio. Isn't that worthwhile?

The former doesn't seem necessary, but the latter might be worthwhile.

After splitting, we could potentially avoid premature OOM. Of course, 
splitting also means losing an order-9 large folio, but we can rely on 
khugepaged to collapse it into a THP again. But the consequences of OOM 
are arguably more severe?

Anyway, just raising my concern here (I don't have data at this point to 
justify whether more complex logic is needed).

>>>    again:
>>> @@ -1769,11 +1772,13 @@ int folio_alloc_swap(struct folio *folio)
>>>        }
>>>
>>>        /* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
>>> -     if (unlikely(mem_cgroup_try_charge_swap(folio)))
>>> +     if (unlikely(mem_cgroup_try_charge_swap(folio))) {
>>>                swap_cache_del_folio(folio);
>>> +             return -ENOMEM;
>>> +     }
>>>
>>>        if (unlikely(!folio_test_swapcache(folio)))
>>> -             return -ENOMEM;
>>> +             return -EAGAIN;
>>>
>>>        return 0;
>>>    }
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index 299b5d9e8836..63e8578454ea 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -1257,6 +1257,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>>>                 */
>>>                if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
>>>                                !folio_test_swapcache(folio)) {
>>> +                     int ret;
>>> +
>>>                        if (!(sc->gfp_mask & __GFP_IO))
>>>                                goto keep_locked;
>>>                        if (folio_maybe_dma_pinned(folio))
>>> @@ -1275,10 +1277,10 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>>>                                    split_folio_to_list(folio, folio_list))
>>>                                        goto activate_locked;
>>>                        }
>>> -                     if (folio_alloc_swap(folio)) {
>>> +                     if ((ret = folio_alloc_swap(folio))) {
>>
>> Also, please give shmem some love (shmem also calls folio_alloc_swap()
>> when swapping out) :)
> 
> Sure. I'm pretty sure I love shmem. :-)

Thanks.

