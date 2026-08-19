Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BED60C5DF88
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B16F26B0093; Wed, 19 Aug 2026 05:46:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC8296B0098; Wed, 19 Aug 2026 05:46:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B6C96B009B; Wed, 19 Aug 2026 05:46:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 755166B0093
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:46:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C38201204EF
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:46:47 +0000 (UTC)
X-FDA: 85117539654.11.CE0FF14
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id E4FFB40008
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:46:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GU3t5IHf;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787132806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LjAzNT6vBtj9gmZbzdnPdbmcTF5paC7A92/5+0dRtBU=;
	b=EZ3/H6KRSaNW+00HXinwh79mqp3Yp2Il1GTeBaar9R910lPCGg6VC2ELYYI49f5m2kffeE
	kFTJNTf0ZlAP3+CHw/hDlezquaecuUNXr+Iaix/Ve28l13kWId+Yq/dW0VFwimdIUA+wiM
	hrJqeLrg8rnUgI3sA6UtwErn4wOKpng=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GU3t5IHf;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787132806;
	b=W4JVIJhQxOoLMhAOd1RGn1uNzlsew+EFtOy7VLVt6u870Cufk/CikuwgMdkqAWz68/ZgyK
	TbTwnueOhGK6MVj4EVzC2LUWpDqU82XVNdADWhyQWPu595iok0Edf5Cst+ZbFG89dWwv7Z
	43WZ1/GfNW+XHE9XHQ9e1pNbM26L0Wk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787132801; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=LjAzNT6vBtj9gmZbzdnPdbmcTF5paC7A92/5+0dRtBU=;
	b=GU3t5IHfMIqa3Omb74Cclr3ysdw8IwSVyaLOvDyyALwoktEE4gzcrrUiR5fPBPPcNFWh/j0RvYYRCkCP6OUb9YOZAXu1m8SIfq4e+uk6uFyHcSzA50f4bWvhfdRAjWTYuWgja7ahA8hgnwPCqW0Jp0ueI/n9mrtu8uCVWMo3vW0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0X9GFJ5v_1787132798;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9GFJ5v_1787132798 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 19 Aug 2026 17:46:40 +0800
Message-ID: <e143d790-fa3f-4b68-84e7-91199d8dbb54@linux.alibaba.com>
Date: Wed, 19 Aug 2026 17:46:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] mm/mglru: introduce helpers for manipulating gen and
 refs flags
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-2-8dbbdac0d28c@tencent.com>
 <167ad235-253b-4bfe-9b60-265262be34f8@linux.alibaba.com>
 <CAMgjq7A1nK5EiRvN-o1Lg_Q2+Ek7oj4Fnm1qAy5A=ULfLz+t+w@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAMgjq7A1nK5EiRvN-o1Lg_Q2+Ek7oj4Fnm1qAy5A=ULfLz+t+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rges7116akzjqa4aa8ccasyphhuwfzd7
X-Rspamd-Queue-Id: E4FFB40008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787132803-75847
X-HE-Meta: U2FsdGVkX1+3foO+Q9d01oHAPueh/H+74Yrxjtz12z6lD4ntFQK8jMFQYdIRpSxd1uifMseh2f1OGrKLvXlDLb5xZGNUW59KIP27LvwIYKr4zOm2p7Oa7/Pt6ytatUmrWh4wURKM7EL5ShgvoqgPCJzq/Ry/IdmkWNBAXw55tp3MnNSpPeW7/cEeQhOrafVDJCmEw9NtcwwzqIKCl0vmMmhTkyrm1RvIHwK58t0prx4hgPg5syYKKXWJ6XNQJg6pUJxFoiMFlcxubRVEbjjwfrT+6AVf5+4T5aqGGiR5L7SduE1niqEm1mmIoimt0ZTxhwEJkHZy43+1GhkAmlR3SmJCfxMAc67JA4vt+mVW0mIPbzW2SkTxHfz5Bg5zN2Oko1CK/DxDUuTFURcSyIHj2NK8yIrLUyQVfIGh1BWEDFEq2GNEy1Z0lsCsIrTsOtbW5axWHLdJnmMma6nsUN1qhwLmBJulcu+04LG88A0L8WIkLLRd3nBDziLZGpHzpMjojzGJ8xmm2W6cf+aRHiF7urqOiYudDZvJilTObXCcVrjWcg1HSAs8TwNfVFpD+z65OP4Jlc4e5uiEWaSQsgJSfuf8sbqe1TMeUvySBL7l5oWsU+f5DKQdvMOBGM4kfCGgblEW98w3MvxtWukqnQCEgj2MGrlUntzs+sNRQXzJPEeDWRXxZngtKaXzIAE35ZqKz0/CNTNGhEeN5epyHnwqsHXgs/juS32PfCLCKA6Xvp7MqODpg1gG1+m5wmgX7iI3l1l4nZSs1m/3gZURgL/Nv6T9fG/crSkTkAP8rPaqrR+WxJhZ0T5MZVZUSeNPYF4tVhevqNHELtt9AJ2AabACvSDoNMdUm7uyx1Vp9HnDpi47ErLSxJGFoT1AXCTAlbA3ZWbd8lJmSzloAHHBOMCMtE8vmZPdQI7Gr9d2ul6Y4O5IoMmBekKBOSYLJoqUNWf1Iu74rZqSwyCEuyv7U3j
 5rfhBSn1
 aRUd6eHAFVI+Rt33e/A67FmQteJyYmfoRuzedor1fPp7S5XNDPeuAOrCiT6oyjiXyY30HTLrzY3s9pDlg9l4PGFzXpXs9As/0zM/YuKfKInpsEeM2jOQZQHagqmPZRVmntkbGB+Vu+UiTKLIpbO13IOqs6cgHx8eKGr2OKmlme3TdswyE6v++QFl95QIRixtHXSR9oJ2G2DARdqYfmiYhizGHjj4adaUtOqmnqmY1wG7Hl4qKew7yn4OYDEET/dO5fM2lzE0Du71z9Q0kNT7AS1TKJJu2KKH0puMvMsQUEZRbaR9iBR+RJMrq3CHIFq8zEs/YV4mVJ3o4GGL4Yzgk1HsdrKesuxC+6jAr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/19/26 5:37 PM, Kairui Song wrote:
> On Wed, Aug 19, 2026 at 5:03 PM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>> On 8/18/26 1:38 PM, Kairui Song via B4 Relay wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> Instead of doing bit ops on folio->flags.f, introduce helpers for
>>> adjusting folio's refs and gen info, make the code easier to debug and
>>> understand.
>>>
>>> No functional change is intended: some combined atomic operations are
>>> split into two, which only creates harmless transient states.
>>>
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>> ---
>>
>> Thanks for the cleanups. One comment below.
>>
> 
> Thanks for the review!
> 
>>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>>> index 94f9c3ff5416..32d9354a754f 100644
>>> --- a/include/linux/mmzone.h
>>> +++ b/include/linux/mmzone.h
>>> @@ -496,7 +496,9 @@ enum lruvec_flags {
>>>    #ifndef __GENERATING_BOUNDS_H
>>>
>>>    #define LRU_GEN_MASK                ((BIT(LRU_GEN_WIDTH) - 1) << LRU_GEN_PGOFF)
>>> +#define LRU_GEN_MAX          (BIT(LRU_GEN_WIDTH - 1) - 1)
>>
>> There are still many places using MAX_NR_GENS to compare gen counters,
>> so I'm concerned that introducing a new macro would make the use of the
>> max gen counter even more confusing.
> 
> I think I'd like to get rid of all LRU_GEN_MASK and LRU_REFS_MASK
> users, MAX_NR_GENS is fine I think? Manipulating the bitmask looks a
> bit hard to follow for me since:
> 
> set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
> set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
> set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, <number>);
> set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_active));
> set_mask_bits(&folio->flags.f, LRU_REFS_MASK, <number>);
> new_flags = old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS);
> new_flags |= ((gen + 1UL) << LRU_GEN_PGOFF) | BIT(PG_workingset);
> 
> Things like this are everywhere and I found it really hard to follow
> what is actually going on. And adding more operations to refs/gen
> looks ugly and painful to do, and, it's impossible to add any sanity
> check. With proper gen and refs helpers, we can ensure every time
> gen/refs is modified, the value is valid (in debug builds).

I agree LRU_GEN_MASK and LRU_REFS_MASK can be cleaned up further.

> 
> Mean while, a "% MAX_NR_GENS" or "/ MIN_NR_GEN" seems not hard to understand.
> 
> Oh and this LRU_GEN_MAX is only used for sanity check for now.

But my point is that people may not know when to use LRU_GEN_MAX vs. 
MAX_NR_GENS, since they seem to have the same semantics.

