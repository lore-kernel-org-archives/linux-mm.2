Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0172A10A3D78
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 12:04:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 345F46B00B0; Thu, 26 Mar 2026 08:04:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CFE06B00B1; Thu, 26 Mar 2026 08:04:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 197936B00B2; Thu, 26 Mar 2026 08:04:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 03B456B00B0
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:04:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7AEC85CDA4
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:04:21 +0000 (UTC)
X-FDA: 84588081522.08.3874B8D
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5C1BF80015
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:04:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=oaKtZJBA;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774526659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LWQfC+vkVg6s6Aluh+qkk7w2aQ6dzgjp3pNFuJDRRHM=;
	b=W6J7Br2eCd5Zqj3yFi5fKrkIpamhjtIkOLYhjzAoOAi+rVWkRP2A8t3ojTqSUxhnVEKKZD
	JDpBbNPa2KE5DNtAH2f3BAO3hr2YiZaQS9XMiPE4gWWnvtG3pEx5ht2/vNgdi4DTgkNOr3
	QM3k9p1ZFm6paZF1xLJilVTJwDc7aSE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774526659; a=rsa-sha256;
	cv=none;
	b=KORT8pOoXfS1NI1SrGJD8Jzd0FWA67i0GcAvFJ4AXrYn1XaJyDqbiXwzIQkyS+KcPtTCkc
	PxdnfWTZy7y0E5iK1J0r9mHClko3vCgTGn1UZca5EVrgjrhD/8ZdLPvH/Bmqw+1JfBqoZN
	C7QP6w7C+fx95ayc8hZGjX2wL5DjMK8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=oaKtZJBA;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774526654; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=LWQfC+vkVg6s6Aluh+qkk7w2aQ6dzgjp3pNFuJDRRHM=;
	b=oaKtZJBAwGp77tY10qxy/IUg+WMuIzZGDohF65UMj7Y5fPfXgogbfOl1PcDgVUz+ILDQADUSy9gvBlxw0+4HfImatrLa6QXpSZwYcBde7WbFo+GVdWUXhTYH+c9PUL62L1FKEsuktpkJXRJzVjHO7Hi8xpymjm6FROVTpzYQFkI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R701e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0X.lAXzx_1774526650;
Received: from 30.42.98.36(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.lAXzx_1774526650 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 26 Mar 2026 20:04:12 +0800
Message-ID: <aef474b9-5286-46f4-99d2-43d0b85f7176@linux.alibaba.com>
Date: Thu, 26 Mar 2026 20:04:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/5] mm: rmap: support batched checks of the references
 for large folios
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 dev.jain@arm.com, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <a4d7cf56-eab4-431d-886b-a32456e44736@linux.alibaba.com>
 <CAGsJ_4woBVQdYcCbN1Btr2vxOL8OAujaHkNZZ41=S-TdNh-wbw@mail.gmail.com>
 <d6820b1e-52ae-4ef2-8342-11818fdd0cb1@linux.alibaba.com>
 <43831628-a00f-4292-9797-cb96a029bb00@kernel.org>
 <e54e0ec1-b968-4e12-84a3-4e3d331b1c36@linux.alibaba.com>
 <86f611cb-1292-44e4-b629-6503135d33ca@kernel.org>
 <e5cb474a-a84d-4edc-8289-d68378feee7d@lucifer.local>
 <e3e374cc-ddf2-4112-b063-6cb1839ea566@kernel.org>
 <e227a7f7-0186-4d10-b7b4-c84ca8424bdd@lucifer.local>
 <bfd282b1-523d-4945-97a0-ec30fe1df577@linux.alibaba.com>
 <a0181a7c-d191-483d-bbc9-678bc355a984@lucifer.local>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <a0181a7c-d191-483d-bbc9-678bc355a984@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5C1BF80015
X-Stat-Signature: 9cwx1mizmb4yquzu5t7xwozkoktc6s51
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774526658-191302
X-HE-Meta: U2FsdGVkX19LPv8SCcYhv81UldnooVm938L0qS0708qkUzwrbWD8b7mNkIgKidCKcwm4v3s19Q6OjFm9I+8k6xDBvENdb6CWcaQJiiJjFE176CJ6LDP411Ap/m73Gy8km7U14ghKx+BQEiE81kdXwTVZz2Ls6chy7rImYTsX39W6P3jQk6P5+ZV74tPKhr74SmOTBF/zmk5B8frVuztABJOtSjtDVL8wWnGykATLnuEaZq2QNOlKGy5RsRia8gOl+2RUw0vihS9obz+XxZ4O5FF2XQyMzIYpiqZx6tT4wu1RaRdQltJ6yjyWnvCe8vOING8svEzOICsS41DjcdJmOikhGsmjG6B6PQ+JShKlYdaOoteK55v3W9tZ/xyc2oo+TkqE0NcqLOFc7cp/Tru/JAicnr9PVD+l5oTjPn2QK5lPlqKJOSBB0PNry5hwnJlo0XE+mq0xSGkBzSxi4QQwXHl9biYriZlBmIm4B/yab0d3uwBj8I9u1m90uykO3x83EwFTOn2Kid4WNikqH2ii3eX/qb14zSF3n8Yzl5FrfqJ1y+B29C2nf8QP08guLPeR6QWQykZlbt6Vh1fHHtxHmxH1L6p5KMmHNPmAUbJZI6CjsJAYMqwH4zYkbWlwS7N0PGeS1n05SwqDh0NduMeqDEHTl2+DEGbhwV+S8KS5+ZjbtUfM33wVeLAH+4peuil7DEnYJRPujWWREo2JtBqyczf9Qh8vsW+mNkWe3UUu20+/jogdt2jXuD6f1pvTWRoa4X6Dd0hCW3qoURRtIL7QMvOdOklY4cQ5swvCP0uqC4KvpSV8LJYKd/dvdUSEFt/7GGQZpIYNlcDc6gALYVBjXL0UWSAeI2Q16T2FPXbmJFJ004aqp266EoejBGAcT76K9T//35u6bbat+5ibhLG9A5DDWoRycGXRghUxABnfTNy9E53rJTqUiB20XEZrDmxdYJYPB0G7Bv8c6ahzreS
 7sE0mWSl
 /mFVYBp/kImwAFiOwS6RZsGkoEeiPvvimd8wCoCQ+PA2c26Dw6Ehvd1a/J6n8AtVf8Fwdxb+kIUuxQXfzilPiiadwH1U+AIRuZMqObWjcjtTjcF9b6GR9hO5BsR+1mdBLCNgfBN30+9SqG9yqjkf4cc8J1EvkBBt1NGZNZQ0uSzwbdFIskerBODj7uFmnDzZBja/QXi7slCT0JxNV8FdiMq5gcN+/c2QRW88XJhCsLk9yMynsw1A5RuvOMSg2NMIyvh7gJTRab1QxsnE5BVSaYl1aY9EuOK9bCwb5Pfal2cawPFVS20ChxQzcXEwb7rHb21xk/25OX2D/FJ2y7bwtoqkxRuGbp7zdM3O634xNhx5tfNOgbq58H12nInlubAZhGsKJ+sKRNJUnXx9RQY6TYxzxL8euAFtcOTWYWIykpof6aV90nverscZcnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/26/26 7:10 PM, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 26, 2026 at 09:47:51AM +0800, Baolin Wang wrote:
>>
>>
>> On 3/25/26 11:06 PM, Lorenzo Stoakes (Oracle) wrote:
>>> On Wed, Mar 25, 2026 at 03:58:36PM +0100, David Hildenbrand (Arm) wrote:
>>>> On 3/25/26 15:36, Lorenzo Stoakes (Oracle) wrote:
>>>>> On Mon, Mar 16, 2026 at 03:15:18PM +0100, David Hildenbrand (Arm) wrote:
>>>>>> On 3/16/26 07:25, Baolin Wang wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Sure. However, after investigating RISC‑V and x86, I found that
>>>>>>> ptep_clear_flush_young() does not flush the TLB on these architectures:
>>>>>>>
>>>>>>> int ptep_clear_flush_young(struct vm_area_struct *vma,
>>>>>>>                  unsigned long address, pte_t *ptep)
>>>>>>> {
>>>>>>>       /*
>>>>>>>        * On x86 CPUs, clearing the accessed bit without a TLB flush
>>>>>>>        * doesn't cause data corruption. [ It could cause incorrect
>>>>>>>        * page aging and the (mistaken) reclaim of hot pages, but the
>>>>>>>        * chance of that should be relatively low. ]
>>>>>>>        *
>>>>>>>        * So as a performance optimization don't flush the TLB when
>>>>>>>        * clearing the accessed bit, it will eventually be flushed by
>>>>>>>        * a context switch or a VM operation anyway. [ In the rare
>>>>>>>        * event of it not getting flushed for a long time the delay
>>>>>>>        * shouldn't really matter because there's no real memory
>>>>>>>        * pressure for swapout to react to. ]
>>>>>>>        */
>>>>>>>       return ptep_test_and_clear_young(vma, address, ptep);
>>>>>>> }
>>>>>>
>>>>>> You'd probably want an arch helper then, that tells you whether
>>>>>> a flush_tlb_range() after ptep_test_and_clear_young() is required.
>>>>>>
>>>>>> Or some special flush_tlb_range() helper.
>>>>>>
>>>>>> I agree that it requires more work.
>>
>> (Sorry, David. I forgot to reply to your email because I've had a lot to
>> sort out recently.)
>>
>> Rather than adding more arch helpers (we already have plenty for the young
>> flag check), I think we should try removing the TLB flush, as I mentioned to
>> Barry[1]. MGLRU reclaim already skips the TLB flush, and it seems to work
>> fine. What do you think?
>>
>> Here are our previous attempts to remove the TLB flush:
>>
>> My patch: https://lkml.org/lkml/2023/10/24/533
>> Barry's patch:
>> https://lore.kernel.org/lkml/20220617070555.344368-1-21cnbao@gmail.com/
>>
>> [1] https://lore.kernel.org/all/6bdc4b03-9631-4717-a3fa-2785a7930aba@linux.alibaba.com/
>>
>>>>> Sorry unclear here - does the series need more work or does a follow up patch
>>>>> need more work?
>>>>
>>>> Follow up!
>>>
>>> Ok good as in mm-stable now. Sadly means I don't get to review it but there we
>>> go.
>>
>> Actually this patchset has already been merged upstream:)

Let me try to make things clear.

> Err but this revision was sent _during_ the merge window...?
> 
> Was sent on 9th Feb on Monday in merge window week 1, with a functional change
> listed:
> 
> - Skip batched unmapping for uffd case, reported by Dev. Thanks.
> 
> And then sent in 2nd batch on 18th Feb (see [0]).
> 
> So we were ok with 1 week of 'testing' (does anybody actually test -next during
> the merge window? Was it even sent to -next?) for what appears to be a
> functional change?

I posted v5 on Dec 26th[0], and it collected quite a few Reviewed-by 
tags and sat in mm-unstable for testing.

Later, Dev reported a uffd-related issue (I hope you recall that 
discussion). I posted a fix[1] for it on Jan 16th, which Andrew accepted.

Since then, the v5 series (plus the fix) continued to be tested in 
mm-unstable. We kept it there mainly because David mentioned he wanted 
to review the series, so we were waiting for his time.

On Feb 9th, after returning from vacation, David reviewed the series 
(thanks, David!). I replied to and addressed all his comments, then 
posted v6 on the same day[2].

Additionally, v6 had no functional changes compared to v5 + the fix, and 
it mainly addressed some coding style issues pointed out by David. I 
also discussed this with David off-list, and since there were no 
functional changes, my expectation was that it could still make it into 
the merge window. That is why v6 was merged.

[0] 
https://lore.kernel.org/linux-mm/cover.1766631066.git.baolin.wang@linux.alibaba.com/#t
[1] 
https://lore.kernel.org/linux-mm/20260116162652.176054-1-baolin.wang@linux.alibaba.com/
[2] 
https://lore.kernel.org/all/cover.1770645603.git.baolin.wang@linux.alibaba.com/

> And there was ongoing feedback on this and the v5 series (at [1])?

Regarding the feedback on v5, I believe everything has been addressed.

> This doesn't really feel sane?
> 
> And now I'm confused as to whether mm-stable patches can collect tags, since
> presumably this was in mm-stable at the point this respin was done?
> 
> Maybe I'm missing something here but this doesn't feel like a sane process?

Andrew, David, please correct me if I've missed anything. Also, please 
let me know if there's anything in the process that needs to be 
improved. Thanks.

