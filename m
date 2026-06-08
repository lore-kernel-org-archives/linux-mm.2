Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AB78CD8CA7
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 11:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADA6F6B009D; Mon,  8 Jun 2026 07:09:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB1C36B00A3; Mon,  8 Jun 2026 07:09:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C7F26B00A4; Mon,  8 Jun 2026 07:09:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B1956B009D
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:09:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2AAAA40A52
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:09:13 +0000 (UTC)
X-FDA: 84856473786.12.8476627
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 59CBC1C0007
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:09:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HICbOiY7;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780916951;
	b=5a/0tgmla3VIuojZ8BaO+v8cuWQk9ERvtNzO6lZDPMZm0AtS8AgpvOHcENo1yRDTqvER/X
	2zldxCNqGA1DKeQuhrhPzXp1SJHky8+OTJnG5eblSOVA/13ImWgOjwzH0FNYzvu/LXOie1
	GA25PazBsGP5N7fmROKCER6VEOyFlcE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HICbOiY7;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780916951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hc/qlM6AXIf4NHvVFYTmMogdhCS062x3B65dfP/PPwY=;
	b=xe0ryW/id/D0LmikElu2CW0UQJB5jdu79mUwOBFlkNjzJUBqCmXeLS2BPX9V5E/4H8TXew
	t6UWYecHvif/ZwbRiSQH//pCNA/jBYnz8OAshYzwiOmoE4lCaBfUYEJc5ShMaiKhwH4nG5
	bIvBQc1ER2yBhYZle9RL5hATLbbHxPE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2278744036;
	Mon,  8 Jun 2026 11:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CE01F00893;
	Mon,  8 Jun 2026 11:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780916950;
	bh=hc/qlM6AXIf4NHvVFYTmMogdhCS062x3B65dfP/PPwY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HICbOiY7mVbZABlmQS9r9qxSDVd/U5vhNVSwfuvEYMuSXCDxThNC+OThT/sW7pI/Y
	 ZNwf/7wqg2v+asEQ4fo+4BsLfxEEqZLyca4ZRdsvC/fhmaO4LN0v5TOM/QL4FMZwmJ
	 c0qC2GensuPyio1c7c88eZCj6BA4v7o6G7meAwBVRvSpxZ8EBV/fk17JzfHjOPq7LA
	 6+HbwLmLo9OjxiIoXNHtg7TXg8KKXfBA6Mm7B8B3qaHbEpsGe2g49jR32+2ToprIET
	 8DDevnn++18AFDXzmqdD86E1aRclyGxJ6pf8ipz8AqwUv0jz+4Ggd+HsdP5HsPU9zk
	 rKeeRLezEcRdg==
Message-ID: <64f2e580-aa82-4849-9236-b8ec4208ca24@kernel.org>
Date: Mon, 8 Jun 2026 13:08:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 07/37] mm: thread user_addr through page allocator for
 cache-friendly zeroing
To: Lorenzo Stoakes <ljs@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton
 <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 Andrea Arcangeli <aarcange@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
 <50d410b47fe3f45327783e05bd306d5eaab75e65.1780906288.git.mst@redhat.com>
 <aiaUDTeHDA45ZXFS@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <aiaUDTeHDA45ZXFS@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 59CBC1C0007
X-Rspam-User: 
X-Stat-Signature: pa6amqo8ak7eb3875dy5wnxiewtzpwjt
X-HE-Tag: 1780916951-684633
X-HE-Meta: U2FsdGVkX1+Q3ha9fpYIhIcux5g27JXgL0Sdy/41iRnBWFtBc98HSHecI82D6VG0ZDiw8YCmymuRTgWynrFg9HblA7puYI6sCmRuPBv0wW6BKTU4avXt++Cii8u5bcxP9VMLaNLH37MhpugSaUGcg4mPxVBxlrj+IWhw/uOoV2PVoo0Q8oICnEP2tL8fDZACWa5y2caQvFLyxtJSBQiTuENUNqi/KGtjy8SeVKLxWELjqB3gZ5GFLt0Gs+76M/pAKkuSbuNCe0M6G+zOJeBb1NniHcK4jiX9e+eP1tsjA7TVLJa7DwecyW7UzKanoOA04ptWQp9BtYc0XIFdnCXIYnKfmAa3XVb0eIMAkIc9NrcKzVD/RCNeVs9dRlc2yAmrpb6iBjSVOzTrrP7cPeKqFWXYN+6fJmpxItk+xXvrxzHjDan7+9ax5cOvm/quUIO24fEadpTDfCsx47JREf7Mhls6N1XRyvp3xUGSy3NodJFluqzD6u2ElDoQ4lDlMOmz/A32y8q0ZNgohSQZwCmKeWCvZAW9eQdISp3ZTOsXU4AUuTU+theM8vYAVqSsV+8tlOOZ++it6pv5daZZX+2pZqNCRlJlmWSodQvQhpQp3S9OEfj3JtdQuGyvAVR7W2AnLdC3mKWT9VOdvMmq499eyaVthZsDJ8AOEvSQ1yXxn+yB0rP+saYX1aoiRJdN+OExaXbQ/9R7qFmw4TjSvAFw7mC9ASPjjPSsZnobn7quNIuOcrAcG+zsVLc+U1LlazvS+lnb8CQnhSNJkxbdTc1zDF+M24zElPNnVhhRZzJtkxCMf8XwjKi3TrfPz7+kOFgGkF1x88pFI6oEIk0SqfO2zOV3HqKwQ0H8cr6bYoA9l74gprlLlcaV5XjDyq6IQcpi3KrAa+ysmlgKUmm5g5wGMhh5urIF3h7UzDwNZCPLcl9lL0tU99cdGHFQOtjGm/LMpzxX72TvlyXE7fnCwMY
 mlyo0RAD
 hpIt7/2dnvN4lgzdBhAGY+OfFd47oydjixQ2nJkYR3YXRp1UQePNAN0udVK5Y5ukECbxJEhQ8C1nKTvArPIn/TFbXhczd+hcXZRqs67g9Q+QYR+OWEu5TGH4taV+8es9wHqYLOf57fJi2EYHQuVt8p2YIf9I/PlxuT9qvJiiJNMYv1vgvqivXXVvUZux30sXdQqfN60AWf6l3loufc/jPI2n9A8OVJnHPCol3yy1uiChyI9WUCp2jzuAVKeJp/vicdt3Z78wj8pYdv+qSYLxfi3/T+7Od8VM4pUPJ4/sbfxBCML+2KIE8WnaiX1/5DYha0jQgIjKs03YGzQPsCX1QT6iy7pJlSI21TmgSnb76/dB7pkp+vcU11vdqoeGzDzfZV6Sa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/8/26 12:23, Lorenzo Stoakes wrote:
> I noticed this patch, again, sneaks in some additional code changes that
> are not mentioned in the commit message and seem irrelevant to the patch.
> 
> Not sure if the AI is doing this, but please don't do that.
> 
> On Mon, Jun 08, 2026 at 04:35:17AM -0400, Michael S. Tsirkin wrote:
>> Thread a user virtual address from vma_alloc_folio() down through
>> the page allocator to post_alloc_hook(). This is plumbing
>> preparation for a subsequent patch that will use user_addr to
>> call folio_zero_user() for cache-friendly zeroing of user pages.
> 
> This feels like very weak justification for code that massively changes mm
> code and makes it all much worse.
> 
>>
>> The user_addr is stored in struct alloc_context and flows through:
>>   vma_alloc_folio -> folio_alloc_mpol -> __alloc_pages_mpol ->
>>   __alloc_frozen_pages -> get_page_from_freelist -> prep_new_page ->
>>   post_alloc_hook
> 
> Is this the only relevant code path? You're changing a TON of code here
> that will have multiple different code paths?
> 
>>
>> USER_ADDR_NONE ((unsigned long)-1) is used for non-user
>> allocations, since address 0 is a valid userspace mapping.
> 
> Ugh god, so now we're passing a user address through allocation paths that
> might not even be aware of this or be allocating memory at a point when the
> mapping is known?

The original ideas was to do this only with internal interfaces. I think I
raised before to leave hugetlb alone for now.

Fundamentally, user_alloc_needs_zeroing() is something we should get rid of, to
just be able use __GFP_ZERO and do zeroing at exactly one place.


The question is how to pass that information (user_addr) through internal APIs.

I previously said, that ideally we'd end up with a folio allocation interface in
mm/page_alloc.c, from where we could get this done more cleanly internally.

But I don't want what the previous proposals did: use GFP flags+leak state or
return magic "zeroed" flags.

-- 
Cheers,

David

