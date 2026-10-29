Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACC40606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 11:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WrVYzA32
Received: by kanga.kvack.org (Postfix)
	id CBAAB6B05B2; Thu, 29 Oct 2026 07:02:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C447C6B05B3; Thu, 29 Oct 2026 07:02:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE5D16B05B4; Thu, 29 Oct 2026 07:02:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 798986B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:02:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EC865120350
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:02:02 +0000 (UTC)
X-FDA: 85375374084.03.E00B5F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1FF8C40002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:02:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WrVYzA32;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793271721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OYmhv8HwvlOQOOI8sOhoeifNYQzQv5FQ9ix1RIz0byk=;
	b=I8NBDyGOLhOyerxTZq+I9R5yx2lCKWnPgfjgoJ11zd76OgDeKOUmHose1EhYwxSCu+1C8p
	ISrmo18SVHDaeFs9zaqWIJfY/Vx593t4rHma6Wl83q6QraLxWH+V9H3WYEyTAqQ3bbjAdQ
	h9qq1/8D8L7VYkSvzp0CDm92rFdZtkk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WrVYzA32;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793271721;
	b=OeP2xvlAVhPQCyMiNStC1pAX8M3KzeCfNs3EIcNDW9I+uVyw/eSgFKY3eLl9wyc4hgEgHr
	qslZ4F1DCCZAksVpCAQ/FdzzwQ09ocrOWCo8676tntLjqsZYFIqQqZziiQwszjts9V/7/q
	kDb48t02HZ+QusVuOC/n7gIv2/ZaNBo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1CDCE4039A;
	Thu, 29 Oct 2026 11:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868E41F01825;
	Thu, 29 Oct 2026 11:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793271720;
	bh=OYmhv8HwvlOQOOI8sOhoeifNYQzQv5FQ9ix1RIz0byk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WrVYzA32uJkCm0VS++wNZs3DP7uWRGdJEXgTe24KpJtmejSidIe8tQmWXTY33s0QG
	 HWa5maFNgZ9hsLBs9p6tltp+e/BdFtOGCb9jz8qmS+Cp/6fRjZJQMmzLdLwR9TfBUQ
	 sN03Re4Pf9uxJOc9kulo+S78oKrbtmqC1f9GNHIJfTsLmluP4xsQoE6hd9E9GfiCvb
	 17qs7MKo4Qvzf3fWJz3HgnZ6Q6xNSZmlIhFv32WzWDFBIhnqWNSRPfmP7RtFcf+bLQ
	 l2Tpp3alC16EanFj658aO1knHP3qQXCiprCyZR3keIAic7R0SlOv9FIqNe2jn4U8+0
	 pf43loQgoyv0Q==
Message-ID: <f9067f65-fcdc-4ebb-bbf8-84db9e22af0d@kernel.org>
Date: Thu, 29 Oct 2026 12:01:40 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/46] mm/khugepaged: check if PTE table is empty in
 try_collapse_pte_mapped_thp()
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-cxl@vger.kernel.org
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-18-6f74bec9a5bb@kernel.org>
 <179323853182.453251.8510731747954180380.b4-reply@b4>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <179323853182.453251.8510731747954180380.b4-reply@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1FF8C40002
X-Rspam-User: 
X-Stat-Signature: y79mrjoud4coyydiuwyrog5jkesohrj1
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793271720-631622
X-HE-Meta: U2FsdGVkX1/Gu6cQlK8kFu5Vlq09thZDcv+U6n5kf35/vqAkRcY109oHKiWe/ne5Dz2/MGOSRCqMCD3gT1Wj6B5sAovWLfdiMCtFAYequ5paK+c+WE7u7c0FLgeZewd3lvKUGzamlmCPZVJO+qJ05kGMSU9acDTUTuMHfj2Pcy5OLHhfOuFx0dBFq8kHmxO6QmLVRe4If4oBWHhnn/UOVxv57+DK0GsYesquznfDC7LHCyZCpg/NZeJEhFPojmJUVMCzhf1UULRY0WNXhwdCYgxBx3IkizQnPM7VyTiIt2WjMf2ifoqoM04+jTISipeBeWBH5R8aKLCjS6WXEVek2nX92E54RIo/bMUTIhR6g+bbadhh99X8DI0WYoWfyBi17EoVstr6cjSGPSkr6HMX/papuHxZijtgEB9SQOzwMCNG/qrSaqfWRGaVwRrHPEc3bsxIereGjZsrYIIfNZEaZ53sm8oNuWBoDAbSOV8eifivgCbijVi3w/ILTCeqoi0xegvcKOKnTyqbcxq9AuLSklmSaXSn2nA3P5GEzmAhjTMBjLU8k12PkASgPu4Th0gPOwwRdjgMliVDR4lZGuV8AAE1bKB8nTmouvfACeRksmBZ6Tj5baNbLgJ7allXTdF+VwMWEMFlPrl8TTo2FL+CpVda6+fECcAe941aGJrJnsm5DwzAgxORIvkYVREKIZp6lXOg+hAQgs/E9nD7ugqoPq6WI8MRnVY19gJppfqxgnBfIaZmRkIDzPQLEXILd4ss3XA2XnKYki+mI+ciKo/lNB+wWzY8sSdJc/gsZhZOr4OhVqqokbV3UxWUw9rT/73Yf78HAWez3ZVSml4rOxOqWEbVpyMKOKExJ2fWNDxcM2hTVGFdh8d5+MQZXxsCBnU4umaG33bBvQqV03X9lTL/6AJCbvBAh9lxLYdOG8lxUjFbyz9QbUy1+vgF5F1it3kEYzzCLziQP67/0yN42Jx
 4mckrot8
 cwioJauVQaTmcQidrcdmRZG5u6ewXMsSv9YzusTF0OLjlCdtCoNhqZTJJwEicGhH/kKCmeJGqA0EGF8Fg0Ta6lyR/WCgMP0htMeDJQQgtSAkqYKfZ+h6IOpLV/AvhhecJP4jwpwAtwRkZGy3ALUieYhQ1ya3ErgBeOp5SjYVBTqvb9jWsppK5KWlwSsgOnmojoVBrtMQiDiZeuyeo5wsm865Ra2kflNV7kxJF5xyIwGEO0gWsELlwlMUJlJUDDrhOSqMfWHrf8pW/D/f+iLP4Zv3tRFMv77je0yTT6REjcSYJj8Gmai25e+2+f09dViFoV3vqA0xLKQzW0AXFALFVs9xQ3/GihjMrbWVgUia9Sp3Idl88kkrzNUx6SOedwAYwFv9hh8hzau10AKVjK/F5YdiJaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 02:48, Gregory Price wrote:
> On 2026-10-27 00:17 +0100, David Hildenbrand (Arm) wrote:
>> The existing code is rather horrible and already resulted in bugs in the
>> past: we special-case UFFD inserting anonymous folios by grabbing the PMD
>> lock early, but ignore any other markers (guard, poison through uffd) that
>> could have been inserted into the page table in the meantime, effectively
>> dropping them.
>>
>> Let's just unify and simplify the locking: try to grab the PMD table
>> lock and if that fails, flush the TLB, drop the PTE lock, take PT locks in
>> the right order and check if the page table is still empty.
>>
>> We still perform the heavy lifting (zapping the folio ptes) under PTE table
>> lock only.
>>
>> Include <linux/hugetlb.h> for now, as x86's flush_tlb_range() macro
>> depends on hugetlb helpers. This dependency needs a separate cleanup.
>>
>> Both issues this fixes are rather corner cases. Let's not CC stable for
>> now.
>>
>> Fixes: f807123d578d ("mm: allow guard regions in file-backed and read-only mappings")
>> Fixes: 1043173eb5eb ("mm/khugepaged: collapse_pte_mapped_thp() with mmap_read_lock()")
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> This patch is painful. It's taking me a bit to wrap my head around.

The key here is that we unfuck (sorry) what we over-engineered before.

We just to the same locking independent of VMA flags. But if the trylock fails
(which we have to do because of possible deadlocks) we'll drop both locks and
just do another lookup.

If we raced with someone messing with the page tables in the meantime (no longer
empty), we give up.

> 
> I get that you want to avoid taking both locks while zapping, but
> wouldn't it be simpler?  I suppose we don't know what kind of
> regressions might pop up with that though, bah.

Exactly, that's the spirit of the original code. We would just block a 1GiB
range of va space for the entire operation.

If you think there is a more elegant way of doing it (while minimizing holding
the pmd lock), please shoot :)

> 
> I can say that I've reproduced and tested the before/after state,
> and it looks stable.
Thanks!

-- 
Cheers,

David

