Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 303A6606A330
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 02:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=o83sucRy
Received: by kanga.kvack.org (Postfix)
	id 474B76B00EF; Tue, 10 Nov 2026 21:27:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FE0C6B05B0; Tue, 10 Nov 2026 21:27:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C6036B05B1; Tue, 10 Nov 2026 21:27:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0CE706B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:27:14 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00727A01F0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:27:12 +0000 (UTC)
X-FDA: 85421251104.11.48873F3
Received: from mta0.migadu.com (out-51.mta0.migadu.com [91.218.175.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2432B20002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:27:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o83sucRy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.51 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794364030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PhQURgUIcHKqh7HKNiSdZ1UHIXZTkSo2Cch6MWvnHLM=;
	b=5mkrU4/CSb3FBdeaCy+rWCbnxJxION64AqY2yK0CkMb2+NRNXxnWtSJ4voMFzZ7+V6gwpw
	DyJK8GWjvJpt8DKvZo8B+Bpdni+V9xhE2HA59CfQDQPlCu+EHcKEn9sChZGoNmdp0kTs0/
	1LXgNOgO+fkxOf9EbXQY3Cp8+yB4Us0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794364030;
	b=rrpqY3rDrZFMo1Xm96h92AGC9md+wHxHscqRp1uP977njG4lzXyBmUtOWHHOoO83sSoc2Z
	NbGOb7vwDfcc9shRpEFKSYHUCun9SDqKcg/HGpGa+zQ07ThNAe0hS9WZ6ZvEehbe+j2UUv
	fTrXqYpIMxN7pCVuYOga0p7Ih8jCZCw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o83sucRy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.51 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Wv9122kMEZf/lFR0DCpqumkP3VwnY7IyQl5g+ItEPc8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794364025; v=1; x=1794968825;
 b=o83sucRymj2LXoKiyVVIXK6LuAaOSvns2VtDfVRFXz0P/Q0LJGDkPV43/jk8YnXpMEaBMT1U
 eLwmiJYraKRvEYGWk7uFMJ+4RBKOb5oDnUmSEaw9Na7WvP6ANaOmGhQOsUejn05WeF4e8LnW5nG
 lcpBkPFkKKnLXZmXjjCrl0l4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6bcbf81a8ca16547;
	Wed, 11 Nov 2026 02:27:04 +0000
X-Mizu-Trace-ID: 6bcbf81a8ca16547
X-Migadu-Flow: FLOW_OUT
Message-ID: <b66188b8-3b55-416c-a296-9313f94b5cfe@linux.dev>
Date: Wed, 11 Nov 2026 10:26:59 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: hongfu.li@linux.dev, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Gerd Hoffmann <kraxel@redhat.com>, Dave Airlie <airlied@redhat.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>,
 Daehyeon Ko <4ncienth@gmail.com>, Hongfu Li <lihongfu@kylinos.cn>,
 stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/hugetlb: charge hugetlb cgroup and memcg in
 alloc_hugetlb_folio_reserve()
To: "Gregory Price (Meta)" <gourry@gourry.net>
References: <20261110-for-alloc_hugetlb-1109-v2-1-25795ce44f80@kylinos.cn>
 <179431474443.789062.10429880669466859032.b4-reply@b4>
From: Hongfu Li <hongfu.li@linux.dev>
In-Reply-To: <179431474443.789062.10429880669466859032.b4-reply@b4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hbx9j1xinybij4mhewp1oimuimi5mkh6
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2432B20002
X-HE-Tag: 1794364027-271626
X-HE-Meta: U2FsdGVkX1+9OGaMghs8v4LWP30ouHxux8BvGsVZLihDSl0v/0MkLKNijQF8dEsGZxZ5cVLbhMDZx9Akb2WaMUPjKk+vlnHMr5nXOATiN93ZDoXNk1zRM4TB0e9fxS5cs+XcFYralSQoOExtAWDhy5qaw3g+iKqGtEnDBYXtedVw2eAaMNut2fL8xwggOM5PfL4WhV4dtjSrT35IrY0vAA39mjdQNmqJEQ8ISeH7rLeTToand5fbqs4L57whjVkokKyGzDJGsazd+2MhhWezzT2Ge6O4oGXRdQyLo8JpCKGEY14wiGGYFCDda2+lhfjDQ9yAnlG5udku/BLAybiFx6okqAb6FD5f/5YLan8itLsizHzpslvsBa8QzHrOqYEPfZnFtGZJrCnqoBhH5QnQsOp4v3vpr/XmIjwseCKmYTmrSCeB/EuP/hwlntTQbE+KyJQ5EGT2TWW/89pUlEkD6ovZ/BtKzmh8JObG/Qg/JTbl+qLMnAeA4UMMw7IrdFjU/uK87QlKDxq70bE+ht7Xcd+qZX7rFPU3hAlt2DYdQb6jFMUEh0fxhNEsxcdXyFI/GQpt63nu0ezt2gs3sauK9hnOwCcamYrwn0ppv8k/arUN1XXfF/pqRw+L+NQzOuX7/e4fdslVFicBtmDUTgjU3EuopRubY1VmsVbvBGL3PcwB59NGcjVj74x2cIv2ZfvN1hLzyx1M+b7XMACMCot8m2no6pH3m5LhV9ZXuUOVjHvNuON9ExNAHRYjid13vaxGSRCUx9pCjYuRR3xGEomX3MH0NqL8ic6rbnxnppk/ryPvHHKy5itnQWyerViNXwk8LiB+oPNZGLev9QtKVpqJI1wOCrpugucJ8FOBkhJp1Mo8PxVw7hKZrZMbLLsxovtsAKNglejagKVFLFmQvY/i02t0r+OoAGCzb2atul7xYRcXacPGIkJ+q+iKWQzEipixQg11LxKOJ7JrHRFPemi
 eAmc3xef
 /4xhHulLPVPLqrXQ0VMHpIi7gIP3AWtihiXVOZD1JDVU1Hr9K+DZIABPEzocYD4OUTmx2VOYe6AiH2Gz1MsOT2D8KvhAP14HNXjGbWterN+sycZTw+tXwEPoEwe9mVIWt24tokQvzUQfJO9eaa3+oGrsSlrQiqL7c3I7TLg3YadOb9wr+XuOERdkd0moePDYBue78rJIs4x5Gt/Q1C0ciUdy9hjT1WoluN++L1k56x6Z2DSR0QzjrOAwS/keqzTye0nljg/cseHQV/zmbkVsn1e9tXLGjA0//HGaeeTzDXajfuifZst6bNNFOzCK6JaBgML9tI5ZIxSNSD0uY0kuMIVcRb70i/HOtu0DyBomEB5023wvKQThBNExJgJIjDYlz7LdF1CB0Mzk+vMlC7x7WyXh25bz5lk0iZ0vU8dGatHbGGb6KcJWmkSaBVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


在 11/10/26 20:45, Gregory Price (Meta) 写道:
> On 2026-11-10 14:05 +0800, Hongfu Li wrote:
>> From: Hongfu Li <lihongfu@kylinos.cn>
>>
>> alloc_hugetlb_folio_reserve() hands out a folio from the hugetlb pool and
>> consumes a global reservation, but unlike the fault path it never charged
>> the folio to the hugetlb cgroup or to the memcg.  Folios allocated for
>> memfd_pin_folios() through memfd_alloc_folio() were therefore silently
>> bypassing the accounting: they are never charged to the hugetlb cgroup
>> usage counter (hugetlb.<size>.current or hugetlb.<size>.usage_in_bytes),
>> so the limits (hugetlb.<size>.max or hugetlb.<size>.limit_in_bytes) are
>> bypassed.  In cgroup v2, with memory_hugetlb_accounting enabled, these
>> folios are also not accounted in memory.current and are not bounded by
>> memory.max.
>>
>> Charge the folios to both the hugetlb cgroup and the memcg, just like
>> hugetlb_alloc_folio() does.
>>
>> Test with a process that creates a hugetlb memfd and pins pages through
>> UDMABUF_CREATE. The counters were read while the folio was still pinned:
>>
> ...
>> Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
>
> one note below that is worth assessing but maybe not a blocker.
>
>> +		ret = mem_cgroup_charge_hugetlb(folio, current->mm,
>> +						gfp_mask | __GFP_RETRY_MAYFAIL);
>> +		if (ret == -ENOMEM) {
>> +			folio_put(folio);
>> +			/*
>> +			 * Skip uncharging hugetlb_cgroup since the charges
>> +			 * were committed to the folio and freeing the folio
>> +			 * would have cleared those up.
>> +			 */
>> +			return NULL;
>> +		}
> This adds a new -ENOMEM condition on stable which may race subtly on
> two tasks allocating against the same memory.max and cause failures.
> In testing, it doesn't cause splats or anything, it may just cause
> spurious allocation failures that fallback to other paths.
>
> This implication may be worth a comment in the changelog.

Hi Gregory,

Thanks for the review and the testing.

Agreed on the new -ENOMEM condition. It is a real behaviour change that
affects stable kernels. I will add the following to the commit message
in v3:

memfd_pin_folios() can now fail because the memcg charge fails. Two
tasks allocating concurrently against the same memory.max may see a
spurious failure. That failure frees the folio, returns the global
reservation, and undoes the hugetlb cgroup charge, so no accounting is
left behind.

>
> ~Gregory
>
-- 
Best regards,
Hongfu


