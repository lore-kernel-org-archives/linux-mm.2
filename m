Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2D4AF3ED40
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 16:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B84F56B0089; Sat, 11 Apr 2026 12:06:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5C016B008A; Sat, 11 Apr 2026 12:06:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4AB36B0092; Sat, 11 Apr 2026 12:06:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 956846B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 12:06:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 240B98C2F1
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:06:02 +0000 (UTC)
X-FDA: 84646751364.27.E1BB382
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 92D8AC000D
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:05:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="l81/NQEP";
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775923560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ndwDV3JX9+bxxGWaRghScUGc0HTBLPLRolB2DRAuhQ=;
	b=X7rOSnT7zbznVX4+7XmBToIcIPXq9y2iH8DAduJp5rxlJ1Ixsyp/cDQivSc+lb2f3B/69+
	/5Lqf6sgYk42ufGUQ1DOtG5dc7gj12en4lTb91D76Ss8CIuGn4EgtyEURR3rrTuXP/Szch
	KxmcwEoiN06pCy1pRpumUkhq7/x8hig=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="l81/NQEP";
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775923560; a=rsa-sha256;
	cv=none;
	b=ew9sAHIQ6qouOhinPoF4fgdXZHGjjUNiGaOq/bx2yBcwB6TiOp3ejbRoT5aCBhHbPzAw00
	dZTZs5ANwBY7l5QpVGvXi6PJw/lPH1KiboZIk/1qKIyOu4SxLkyFCo27FcStj4M/sPq6nG
	PzTWMNiT4OCQhH3UsfWbAnF7CLtJPsU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F8DC1AED;
	Sat, 11 Apr 2026 09:05:52 -0700 (PDT)
Received: from [10.163.141.179] (unknown [10.163.141.179])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E860A3F641;
	Sat, 11 Apr 2026 09:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775923557; bh=YgGoVGTSUFJQ2wjFuJc6O6sq01Ubnj51Q2u2XY0BNqM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=l81/NQEP3YyzwME1xAv3gfRk3cZAmVh8Z3BO7/U06YFd+LFGAzZ828zTKUqISKPQc
	 Z/QLwB5+otpl5v3ME0lGnnBF+Z2cLZeahS58c5qJ1x2AvPPgvAgI8NtF2jB9jA2byl
	 1HGDDBsJbjAED6Wo5Fhv/vKC+J5b32N6aBu4mOvU=
Message-ID: <caa7c455-7472-48eb-a5dc-145e587d67ba@arm.com>
Date: Sat, 11 Apr 2026 21:35:41 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/9] mm/rmap: refactor hugetlb pte clearing in
 try_to_unmap_one
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
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAGsJ_4zK1W71iSP14gi=8yWSg80EjgYiBXqLChB2i+X+RSTWcw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 92D8AC000D
X-Stat-Signature: tkszfjz7m447rjwdekjmhmijrczmre5r
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775923559-31858
X-HE-Meta: U2FsdGVkX186cKy8AnlakBTg/CckK7i15ZTAKpnKLcLH9lUPQwXmoxytnQAIxRU8jiwwqLxG2CZ6WwHtrQsLmx2njLf2XotClzd52cC0NyzU3Qdb7MfzcWqHG5pU4b2o6U346JQQmDVD1J7hyCHqtG2LCMV6CPKqKh905Z6iw+Ptd2Fo+58zKrtAjjTMjc8Otwwmeusk72OtU76hGaRQ3g361dtAbU77vz8Uk58hapt2RggiAs/mwhyfhVS5r6RnAfKmVJtxWVSOJp+Z2EjiHb4NEfxrrgZV9nlaAMonMy8Y1sY/yZnCeYGc62adOjzZrbf4d0ApcjcIbPfeH7ksQczffKQ3Km1GRM68kIygrKw7xMuApSrcn3/72Xfi2QwmKeopvcAG+x2mkZ5fxtu5nC3jZarQFfQV5oZsoF4MhJZD0/+ANcLov259fXfgelU98vpOUGsEGn80wO/G0092y+z2vRDmIgt6Q0Trt4WNY7roxMGch6Kmj69unMU1/NcPHu7et7+IZ4Lf4fkxhEQ5/wO0LuI4vAUGXVePvW5fD9u3vmKwDxpvvkpHoQaxBgvRzzfErYi5XqsWhuzO1BmfXXbRPDyNXMwN52U5lhTC0cEcSlv5AAQb4cp1RaYOsvGonyCODmseqxXZ12ABvkjj408fF9hVLJ07QrApyw1+liTMSbNIlc9BB0FB9NN+lIRS/SiCx7NCSsh9P+3omimQ8jnvx9nZKgY3u/Yo5fFBaNGHVqgqQvYiWDovjgsAF9tANebL6+fwuS4VUrUYySkcjjUZ9FLa9VCWAHbw+jTYJv7MHvUZlJZmgu1CcCUt1hMGTo0uPKGsjh6Y1t44nlNXaQakujQnE0nhLqItxkVPHmyOqYwOvboa3lkg66RJssxC324xHVEil+ytH+4VHn/obecuaNeEEFI7hLGJrT+Oiucxs0/klU8gt45eWyn33oE3cSicsew+4CniiwpRrlf
 NFh3k6h1
 R/9d2L59N/GL33DD8H8JWqoDiHN8HGBiWeB8zP6A4o481Mg/48M8GO1WaOEODuV5adYFFMh+vnlqcmElhxvetuyRQalLf+I73Ufw5KS7h9hbQm8tbsPlUDd/7D7YqE0hab9kCXA4IkvLt7BO3GdIwhL5RcTSHpfOadGj9CJI7paRdMk8F7wfBYVHiM7F8QQwGozJdpWeHgGEnTOzF3fKlf1XEiA90iQmS7W6J7RF6bgzmsaQn+N8DUY7xMC3JkoMPlvfB4FEfxzfYi3p8MyNimRsrBMxzML/dbwCn1rNHxhHsWLQoBDySeaEjUV8BXnl3jI+ccVIpiuS8Bidb+7xzLsU89zL4HjfOJKbF9adFXUXY0Ib4ZWyO5S0JxSNWOjpRJKmrTrJ0cCwPBMWS+W1NvWVxaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/04/26 2:25 pm, Barry Song wrote:
> On Fri, Apr 10, 2026 at 6:32 PM Dev Jain <dev.jain@arm.com> wrote:
>>
>> Simplify the code by refactoring the folio_test_hugetlb() branch into
>> a new function.
>>
>> No functional change is intended.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  mm/rmap.c | 116 +++++++++++++++++++++++++++++++-----------------------
>>  1 file changed, 67 insertions(+), 49 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 62a8c912fd788..a9c43e2f6e695 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -1978,6 +1978,67 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>>                                      FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>>  }
>>
>> +static inline bool unmap_hugetlb_folio(struct vm_area_struct *vma,
>> +               struct folio *folio, struct page_vma_mapped_walk *pvmw,
>> +               struct page *page, enum ttu_flags flags, pte_t *pteval,
>> +               struct mmu_notifier_range *range, bool *walk_done)
>> +{
> 
> Can we add a comment before the function explaining what
> the return value means?

Yes I can add that.


> 
>> +       /*
>> +        * The try_to_unmap() is only passed a hugetlb page
>> +        * in the case where the hugetlb page is poisoned.
>> +        */
>> +       VM_WARN_ON_PAGE(!PageHWPoison(page), page);
>> +       /*
>> +        * huge_pmd_unshare may unmap an entire PMD page.
>> +        * There is no way of knowing exactly which PMDs may
>> +        * be cached for this mm, so we must flush them all.
>> +        * start/end were already adjusted above to cover this
>> +        * range.
>> +        */
>> +       flush_cache_range(vma, range->start, range->end);
>> +
>> +       /*
>> +        * To call huge_pmd_unshare, i_mmap_rwsem must be
>> +        * held in write mode.  Caller needs to explicitly
>> +        * do this outside rmap routines.
>> +        *
>> +        * We also must hold hugetlb vma_lock in write mode.
>> +        * Lock order dictates acquiring vma_lock BEFORE
>> +        * i_mmap_rwsem.  We can only try lock here and fail
>> +        * if unsuccessful.
>> +        */
>> +       if (!folio_test_anon(folio)) {
>> +               struct mmu_gather tlb;
>> +
>> +               VM_WARN_ON(!(flags & TTU_RMAP_LOCKED));
>> +               if (!hugetlb_vma_trylock_write(vma)) {
>> +                       *walk_done = true;
>> +                       return false;
>> +               }
>> +
> 
> Sometimes I feel walk_done is misleading, since walk_done with
> ret = false actually means walk_abort.

I'll rename this to exit_walk, so it doesn't collide with
the label names.

> 
> So another option is to make this function return a tristate:
> WALK_DONE, WALK_ABORT, WALK_CONT. Then we could drop the
> walk_done argument entirely.

I thought a lot about how to refactor try_to_unmap_one() as
a whole, and couldn't come up with a good solution.

There are these conditions:

1. ret = false => page_vma_mapped_walk_done(), break
2. ret not decided, "continue"
3. ret = true
   a) exit the while loop naturally
   b) exit prematurely -> page_vma_mapped_walk_done(), break

I had thought about the refactoring method to have an enum for
all conditions. So we can refactor bits of code, return an
enum, but we will still retain ugliness like

if (ret == WALK_DONE)
	goto walk_done;
if (ret == WALK_ABORT)
	goto walk_abort;
if (ret == WALK_CONTINUE)
	continue;

This seemed more of a forced-refactoring to me, IMHO doesn't
reduce the complexity of the function at all.

I don't have a clever solution to get rid of all the label
jumping, so I refactored what I could.

> 
> Thanks
> Barry


