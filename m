Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A31FC5AD5A
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 01:32:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 020786B018E; Wed, 12 Aug 2026 21:32:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F139C6B018F; Wed, 12 Aug 2026 21:32:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E03C06B0190; Wed, 12 Aug 2026 21:32:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7C406B018E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 21:32:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 21BDE40562
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:32:02 +0000 (UTC)
X-FDA: 85094520084.01.EDB37E9
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf31.hostedemail.com (Postfix) with ESMTP id DFF2720005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:31:58 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=CuuN0OqV;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786584720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5N2fHbGlStAGOg6Xg0vdwBujOs3j6ONtsRuS3B8+Bc4=;
	b=SNauw06ldw3sfSR/fLxGuJCxPN08//NOrpKfU0Kf0sfVhmBB4n6VJAhj3qDFmTprcTjFqo
	BIi0RhnmOZ0EPuUrlqPpp4UOdYqYKxsr4DvnyazCY0k9WPEenuiiICjxDYyWZY2MjJQWBc
	cdiQO7Cb5dlLM2ztYVMmqSYxlPzZqqA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786584720;
	b=hg/PpUCt3YpqgwLHIZZyYpfBj5eBYlbjSo2Bu60jBgtfX70M1BAp0bQOND3m0yVmhwM14t
	SDObgNjeE5P2wDxM7VtjoQrn/Rvpb7nCjI92+wgy35n52FsoedTHut7t4bv2cZ4lqj0W25
	h2a2SvbmDrOclJH1o+pEU8+1p5dWKBo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=CuuN0OqV;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786584716; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=5N2fHbGlStAGOg6Xg0vdwBujOs3j6ONtsRuS3B8+Bc4=;
	b=CuuN0OqVKFjT8YalH5773XbHQ38eyB0qKtJtOm4/84PCLCuX0JXNUuJuTp4+BgTTqAeY1XjZFkr7koQDAYyj+6CQqa6yoeuMm8o24qjyIl53EJrgASqQPhKW/yadjt0w0Ak7T4j9pwYcI+hQCHh5KJxkIeQtxsRwG2mA9seFSFw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X8sfjgK_1786584714;
Received: from 30.74.144.111(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8sfjgK_1786584714 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 13 Aug 2026 09:31:55 +0800
Message-ID: <d3471389-98b9-485a-9426-1796327b69c8@linux.alibaba.com>
Date: Thu, 13 Aug 2026 09:31:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mglru: Fix young counter undercount for large folios
To: Barry Song <baohua@kernel.org>
Cc: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
References: <20260812065933.103627-1-hui.zhu@linux.dev>
 <d18ed09c-52b7-40ac-95e8-c1530246e2af@linux.alibaba.com>
 <CAGsJ_4wE7E2G8H4ugwSWbQMF+5ecx+mrYQxXa1U6HY3utuQz0w@mail.gmail.com>
 <37015686-6776-4e67-95ef-a26ac61a3b44@linux.alibaba.com>
 <CAGsJ_4z-nfbeL7VxZyiWgJ1Ut3D5P+AfMXfqqmndwqMxmmsRJg@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4z-nfbeL7VxZyiWgJ1Ut3D5P+AfMXfqqmndwqMxmmsRJg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: oxj3yxhumiy8uro7yfmb58ywgb1sd8wd
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DFF2720005
X-HE-Tag: 1786584718-121261
X-HE-Meta: U2FsdGVkX19qhpf4hI1W8IiwleLzgDhyNQUXQf7YG2o3AZ6x3oy6OFvYrPJmLn119w3ZMieTUPKga1Pj+4084KbkePyOFwXBbLP7lcu/GQkq6l9XKe2o+E1eNER32s3X+yJBRDOx+4Sb8I3eEexZSFti6hSFGcH+37EyiyBnQLw+P5bSheFvSgOVY+2jlAxYzOvQqWJlCvS9Fbm6O05aiC4ICRT4a3d94Bjw6BChgIGZEl8qmkChJoYQMNykpwIWwg9afBzi78Jv39attCNoZQYPQPCt82cko0oBIA3oULv0+pHJesHm4KvjrqLaSut5kFNHJqg3qfMkG1q1RwvfZpGaSQkhRBuijDuvnu8NS6fxmVSI/WQidwNDpfEX/izfmyeVjkTivqZ8vi//wdUnR7B2b1E+LLvkRsiNBwiONur3rWM18KehWxpS4upKQJKAPxjWy3CdctG/vYdrIprFbh4pUGGEqvkNUmcr5eKSlaYKAQliYp5Ebd3XOByRvuCFiLiAA2wX+hoYlp28IpgSZj22puPlxNvAW4qugGjBOIAiaEmTGx2MWjOX5DTw8cC14m+TWPjWVBvVt5gR7tln64ZCEJEMJuFih8JmDzNp4AhneWS/QdTE0plN3pWOZ+Lcf+PpSUHu8RRWCI2w+fRiRZMBp3XptlbK8672u3wQqN/oO8SJ30BBzZneyrpRC/HDCEurPSkIlu5IQATVLpPqYtjxQLEPmSgJidDGsNR8X/j+IelfD2exeVj7uFLTWVqcSvKykmkwCpCAp2CQHftz9V7/RUnkvnL1EVynf/tXDVbP+6gHMzy8ed6omUormda41HcDSxl+siPViBOy9zF4U5YQGN40C9xig9fiseY4ph4OsgshCuP3pmBWr+WMtEnGpEezbbPIVdAK0Jh7MPcLD6qcgLQRDiARuE1s0LvWRTbS6v0OCBFRSJqN0MES1EWQCp3w/13rKEzDelyYjOw
 6BbhgNEM
 JvmB6N6eCcPqXL/dh/3UGchKndU+xTbAMEV2y+vGbqgX26swXW7HY0TLbpO768602bN4FmwB0XA3kK16hGyVt0z2h8gJqwK3+Ej7buNpVBt4kcpsxuioV4GqgmI79ZeAY8/a/+kAOMgXLQFSvy76AWshAoe8FyayDYEbVYI3cXoXdSJeQW7WvwipmTTFUSGVS20N5CPio36ubh/9SF/6ZcqnFXBlIq4VvjZVOBRLBnxxC9LX9/rjHB1Ga6tytcoOa2NCj8/byyc2JXU9vXjkIwYGE4lBWaYxFmILsASFq/x5qsxPk3FTFvys1p1/HgViW/kXTFUYCHHrnqzYGzA/Rgwn2TqAabXy15Nfl42LpEygfXTo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/13/26 9:20 AM, Barry Song wrote:
> On Thu, Aug 13, 2026 at 9:09 AM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>>
>>
>> On 8/13/26 8:53 AM, Barry Song wrote:
>>> On Wed, Aug 12, 2026 at 6:17 PM Baolin Wang
>>> <baolin.wang@linux.alibaba.com> wrote:
>>>>
>>>>
>>>>
>>>> On 8/12/26 2:59 PM, Hui Zhu wrote:
>>>>> From: Hui Zhu <zhuhui@kylinos.cn>
>>>>>
>>>>> In lru_gen_look_around(), the young counter tracks the number of young
>>>>> PTEs.  The original folio's contribution is represented by the initial
>>>>> value of young: test_and_clear_young_ptes_notify() is called on it at
>>>>> function entry, and the function returns early if it is not young.  In
>>>>> the subsequent loop, the original folio is skipped (its accessed bits
>>>>> were already cleared), so it is not double-counted.
>>>>>
>>>>> However, young is initialized to 1 regardless of the folio size.  When
>>>>> the original folio is a large folio with nr PTEs, its young count is
>>>>> underestimated by nr - 1.  This inconsistency can cause
>>>>> suitable_to_scan() to return false, preventing the PMD from being added
>>>>> to the bloom filter and reducing aging accuracy for mTHP workloads.
>>>>>
>>>>> Initialize young to nr so the original folio is accounted the same way
>>>>> as other young folios in the loop (young += nr).
>>>>>
>>>>> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
>>>>> ---
>>>>
>>>> Good catch. Please also add the Fixes tag:
>>>>
>>>> Fixes: 56e5b60b2114 ("mm: support batched checking of the young flag for
>>>> MGLRU")
>>>>
>>>> With that,
>>>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>
>>> Hi Baolin, Hui,
>>>
>>> I am not convinced this is the correct patch. test_and_clear_young_ptes_notify()
>>> only indicates that there is at least one young PTE among the nr PTEs;
>>> it does not mean that all of the PTEs are young.
>>>
>>> Am I missing something?
>>
>> You are right. But I explained why this is done in my original commit
>> 56e5b60b2114:
>>
>> "
>> Note that we also update the 'young' counter and
>> 'mm_stats[MM_LEAF_YOUNG]' counter with the batched count in the
>> lru_gen_look_around() and walk_pte_range().  However, the batched
>> operations may inflate these two counters, because in a large folio not
>> all PTEs may have been accessed. (Additionally, tracking how many PTEs
>> have been accessed within a large folio is not very meaningful, since
>> the mm core actually tracks access/dirty on a per-folio basis, not per
>> page).  The impact analysis is as follows:
>>
>> 1. The 'mm_stats[MM_LEAF_YOUNG]' counter has no functional impact and is
>> mainly for debugging.
>>
>> 2. The 'young' counter is used to decide whether to place the current
>> PMD entry into the bloom filters by suitable_to_scan() (so that next
>> time we can check whether it has been accessed again), which may set the
>> hash bit in the bloom filters for a PMD entry that hasn't seen much
>> access.  However, bloom filters inherently allow some error, so this
>> effect appears negligible.
>> "
>>
>> Based on this, I think changing it to 'nr' is reasonable. For an
>> accessed large folio, it's better to have the bloom filter rescan the
>> PMD and keep it in memory instead of reclaiming it incorrectly.
>>
> 
> I am not sure if this is the best policy, but we don't seem to have
> a practical way to get the exact number of accessed PTEs, so this may
> be acceptable. 

As I mentioned earlier, it seems unnecessary to implement this, since 
core-mm tracks access flag at per-folio granularity. Moreover, bloom 
filter itself allows for some error.

However, could we at least update the changelog to
> clarify that this is intentional?
> 
> " However, young is initialized to 1 regardless of the folio size.  When
>   the original folio is a large folio with nr PTEs, its young count is
>   underestimated by nr - 1.  This inconsistency can cause
>   suitable_to_scan() to return false, preventing the PMD from being added"

Agree. Looks better.

> Its young count is not underestimated; we are intentionally
> overestimating it. Also, nr does not necessarily equal
> folio_nr_pages(), does it?

Right.

