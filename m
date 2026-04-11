Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7A35F3ED58
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 16:25:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAE2C6B0089; Sat, 11 Apr 2026 12:25:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5EDD6B008A; Sat, 11 Apr 2026 12:25:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4E076B0092; Sat, 11 Apr 2026 12:25:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C0EE06B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 12:25:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5564D160656
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:25:16 +0000 (UTC)
X-FDA: 84646799832.29.774F5BB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2B3768000F
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:25:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FZSj2LDX;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775924714; a=rsa-sha256;
	cv=none;
	b=br7GR0PVR73YC8zTxrg00I7duXqCZmOyhsOKZ8Y4NW7+fnasoEAIiXrl667BRB3VZ269B/
	HIjbI5IMrchkbUUpjMzS+oTXqD9LRgjRrBYO3GIPjvaZXjdaFiOd+gmr4K+YWKTttDFnho
	L3ZZoICRwpsjE6ERJY58MKMf8vxGNmI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775924714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3hYzqFMWYjB7ljXo7Ekuc4zp6U/9QcKFUbixu2ngG5Y=;
	b=iRqQrky4eTp2mvcNKzgbBZBg0qoElhdmMhxS1dRGP9gdG4DWYCgnKxKlyjlw9ROu/ZhT0h
	zvvqQ0k+93/TXbgfWCrgz8qbKvwH9C4q1xyIKXgDjrZhb9XCkGVc60ju1pnFy8LtE/B4Lp
	7YfPz9rfVi2URfgHNbEL6VwtCKlyKUE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FZSj2LDX;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C0EB52A68;
	Sat, 11 Apr 2026 09:25:06 -0700 (PDT)
Received: from [10.163.141.179] (unknown [10.163.141.179])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 798AD3F641;
	Sat, 11 Apr 2026 09:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775924712; bh=oIFdnuJfX6Nf+HUO8Peh4nR4V7I3Rf/8uLFtEFBelMQ=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=FZSj2LDXpGjhCtCg/x/W96bE8B56H/pxgEPw1dkQM8Cr/OKutb+g500StKOBRUu0D
	 h0aG71SmxvVM5gFTqjewruCpdW16564Dx3AtrRO9u5L5cptTry20P6YToynKe0Sx0J
	 VfMAGjczu7EA6YKKHV/6RidGt4xeQ7TmDcTd0ins=
Message-ID: <c1a3434b-6f98-48f4-8c53-355649d1eb53@arm.com>
Date: Sat, 11 Apr 2026 21:54:56 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/9] mm/rmap: refactor hugetlb pte clearing in
 try_to_unmap_one
From: Dev Jain <dev.jain@arm.com>
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, hughd@google.com,
 chrisl@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 riel@surriel.com, harry@kernel.org, jannh@google.com, pfalcato@suse.de,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260410103204.120409-1-dev.jain@arm.com>
 <20260410103204.120409-3-dev.jain@arm.com>
 <CAGsJ_4zK1W71iSP14gi=8yWSg80EjgYiBXqLChB2i+X+RSTWcw@mail.gmail.com>
 <caa7c455-7472-48eb-a5dc-145e587d67ba@arm.com>
Content-Language: en-US
In-Reply-To: <caa7c455-7472-48eb-a5dc-145e587d67ba@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2B3768000F
X-Stat-Signature: wpzx6pmfjs14hjnt48dtm96fgu75y6c6
X-HE-Tag: 1775924713-732390
X-HE-Meta: U2FsdGVkX1+OtXepc6m4NTP6BT6r44X8/uv1epXj5UrFK22DQ0lZp8lywakQmZIGeQkONWXO6VJDNUOPEtzt2P91+E48CFM3f87DufE01kRSh/7rLIoWt0z/sUtvhBCAIeyVbH6GHAx80aa783H50Z8auxI5dPIdacNsc0egC88dEJxlltSHAXpuamCv6e/uwPyfZhoMVqG5rgZkujSgRvteE4p61nWoRXH8Xajow/tFiPwFTI3NYSyee0+RtlXSo3Od/aQVjNIOlnSWGqc7Mt9OUAJ+B7Cve038/HJVhpj9jK51PGMaVRj6r/g5whMeTe4a1JlzxF0FEUlgMXoNYLgW82G7lfYkbilQN/gqAlxST8YQgzGUywuvj8Hz5B05W2hY//w1gb0DlIhtdXr/JI1j7qKRerfq84Xw20BXHM7mGv8XLbtF4dJnw4wL9SKsm5BFp2oERGNd0r6oYMTiPtvWrF8PXgVgj4x7mdstJuTpGWvwyRTkZEqcRg52/7bHDdAfxdsYtEANt5SKbQZ5pWzXRegxCsv9ixZMCWPgjCAm4EyqfgNWkhsNaTjdZLQ0je9Yg5er4I9BjHXTK0gH04rrfzWU4RtCWom4S28bYYwXA/S0TbTUfPpvzl8r9uKUUt/ckSzkJqBkfKRO4caHiw+Xm7919mQhX2NP9qORjOYOtlB56eaFQtypCC9q5O0ACpTGY0S2ptWIW+sHMzUOEv2AhbQBOy1xURa96sIj5DmhX6x6sa0qsXXGHGYq6+XMrA/rPY+/TbzfHISZBeuRfcCu9FqPXcXu2BmW3Wthncv2yfJZggX8WMpKDaZpuixDD7UqbOyjG/KVeToQO7Lhr0yf+2aCdq6wSfrelMLNgOJYgzljMZ1ljb+56/om7dCcInxScpUwA1O/jogRcBXQm6wtywxHpje+hNckiCe/kvZfmy3ju2w1EMksddCjyAuoggSLqzB/qWB0mnjoAOb
 wandf1mj
 Dz9mnKyFq3nnOp/MCcmI8q6rHjUPjGVuGNa8H2apGGaNk8iKP1z5GYvZjq+XLKVjzEKP/45cEbiFBh67fYEQBhpMTn3oTW+7TVd7SH6uTevOxLy2slFgbGxTo+03bCY3SMOCUHajtovTHRaL7+JNrRhUQh4yvYSDIBBF6sOQ7sZIPstO55QJ3woAWgO6Wkvx58QB5Fgkw8kSA5rwe2P6P5Tqr7BAoGh83Zage4FgmqtSSqF944XIjJF5RKVYyFur3KDfSJ2iCAp0uuUCH2b+z0gDnqGbvETj2P4PrhDkrd4iIt03SbZ2L1+HeRgoxLtQkuagSD+gNchnHi0oVCM9ciYKWsmsT9f7QqOdpuPCe1Ls6KtA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/04/26 9:35 pm, Dev Jain wrote:
> 
> 
> On 11/04/26 2:25 pm, Barry Song wrote:
>> On Fri, Apr 10, 2026 at 6:32 PM Dev Jain <dev.jain@arm.com> wrote:
>>>
>>> Simplify the code by refactoring the folio_test_hugetlb() branch into
>>> a new function.
>>>
>>> No functional change is intended.
>>>
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>> ---
>>>  mm/rmap.c | 116 +++++++++++++++++++++++++++++++-----------------------
>>>  1 file changed, 67 insertions(+), 49 deletions(-)
>>>
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index 62a8c912fd788..a9c43e2f6e695 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -1978,6 +1978,67 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>>>                                      FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>>>  }
>>>
>>> +static inline bool unmap_hugetlb_folio(struct vm_area_struct *vma,
>>> +               struct folio *folio, struct page_vma_mapped_walk *pvmw,
>>> +               struct page *page, enum ttu_flags flags, pte_t *pteval,
>>> +               struct mmu_notifier_range *range, bool *walk_done)
>>> +{
>>
>> Can we add a comment before the function explaining what
>> the return value means?
> 
> Yes I can add that.
> 
> 
>>
>>> +       /*
>>> +        * The try_to_unmap() is only passed a hugetlb page
>>> +        * in the case where the hugetlb page is poisoned.
>>> +        */
>>> +       VM_WARN_ON_PAGE(!PageHWPoison(page), page);
>>> +       /*
>>> +        * huge_pmd_unshare may unmap an entire PMD page.
>>> +        * There is no way of knowing exactly which PMDs may
>>> +        * be cached for this mm, so we must flush them all.
>>> +        * start/end were already adjusted above to cover this
>>> +        * range.
>>> +        */
>>> +       flush_cache_range(vma, range->start, range->end);
>>> +
>>> +       /*
>>> +        * To call huge_pmd_unshare, i_mmap_rwsem must be
>>> +        * held in write mode.  Caller needs to explicitly
>>> +        * do this outside rmap routines.
>>> +        *
>>> +        * We also must hold hugetlb vma_lock in write mode.
>>> +        * Lock order dictates acquiring vma_lock BEFORE
>>> +        * i_mmap_rwsem.  We can only try lock here and fail
>>> +        * if unsuccessful.
>>> +        */
>>> +       if (!folio_test_anon(folio)) {
>>> +               struct mmu_gather tlb;
>>> +
>>> +               VM_WARN_ON(!(flags & TTU_RMAP_LOCKED));
>>> +               if (!hugetlb_vma_trylock_write(vma)) {
>>> +                       *walk_done = true;
>>> +                       return false;
>>> +               }
>>> +
>>
>> Sometimes I feel walk_done is misleading, since walk_done with
>> ret = false actually means walk_abort.
> 
> I'll rename this to exit_walk, so it doesn't collide with
> the label names.

But then

if (exit_walk)
	goto walk_done;

also looks weird.

I think I should do

if (exit_walk) {
	page_vma_mapped_walk_done();
	break;
}

The mess here is that we have a label walk_abort which
is literally ret = false + walk_done.

Perhaps we can remove one of the labels, have a single label
exit_walk and inline the "set ret = false/true and goto exit_label"
for the discarded label. I hesitated in doing this because both
labels are being currently used at a good amount of places.

> 
>>
>> So another option is to make this function return a tristate:
>> WALK_DONE, WALK_ABORT, WALK_CONT. Then we could drop the
>> walk_done argument entirely.
> 
> I thought a lot about how to refactor try_to_unmap_one() as
> a whole, and couldn't come up with a good solution.
> 
> There are these conditions:
> 
> 1. ret = false => page_vma_mapped_walk_done(), break
> 2. ret not decided, "continue"
> 3. ret = true
>    a) exit the while loop naturally
>    b) exit prematurely -> page_vma_mapped_walk_done(), break
> 
> I had thought about the refactoring method to have an enum for
> all conditions. So we can refactor bits of code, return an
> enum, but we will still retain ugliness like
> 
> if (ret == WALK_DONE)
> 	goto walk_done;
> if (ret == WALK_ABORT)
> 	goto walk_abort;
> if (ret == WALK_CONTINUE)
> 	continue;
> 
> This seemed more of a forced-refactoring to me, IMHO doesn't
> reduce the complexity of the function at all.
> 
> I don't have a clever solution to get rid of all the label
> jumping, so I refactored what I could.
> 
>>
>> Thanks
>> Barry
> 
> 


