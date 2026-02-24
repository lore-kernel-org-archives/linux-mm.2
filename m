Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4420E9B261
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 12:53:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33BE36B0088; Tue, 24 Feb 2026 07:53:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E9C26B0089; Tue, 24 Feb 2026 07:53:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F5C16B008A; Tue, 24 Feb 2026 07:53:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 096126B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:53:19 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9085C1A010B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:53:17 +0000 (UTC)
X-FDA: 84479340834.14.F345A41
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id D97BE140008
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:53:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771937596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oY8qZjUN/o3XHq+7G9N7CNri4mxEWF8OjwqSWQF6UQw=;
	b=hD8RSG8cIevkljMe+qDo8Q4jmvD3zmzmArFw3R6Xob5IqpJx1NsvYg1bZVvrQSJT3PhGhK
	7MvwFCYqeO+Ey/sOV5Ah81cnVUr82sSSS1pbbHnTnlCMeMUeoBPRjnvAN43TJ8luTkPOEW
	K/Fikhi0+PK3dKyF2vrfctMXQRa4lks=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771937596; a=rsa-sha256;
	cv=none;
	b=6W9xcTUrfHRjxGd7OJOOLuOGi+QO9zHvZHDI47i4x2blHKl0Ceqc5aME1opyunXJVDDEkP
	WHoFuxc+o3ay4OPmTa3DhxC+3m6DXZU7+uV6HaXs+Kt5nIKQOiF+qu5c8gvFTa7qlx1BMe
	O20URn7753nObV9U3cceqJ4003wZBe8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79B39339;
	Tue, 24 Feb 2026 04:53:08 -0800 (PST)
Received: from [10.163.172.181] (unknown [10.163.172.181])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C37F3F62B;
	Tue, 24 Feb 2026 04:53:09 -0800 (PST)
Message-ID: <c3b996e5-1c2f-4dea-b25b-31d24bc9620f@arm.com>
Date: Tue, 24 Feb 2026 18:23:06 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 04/16] perf/events: Replace READ_ONCE() with standard
 pgtable accessors
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, linux-perf-users@vger.kernel.org
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-5-anshuman.khandual@arm.com>
 <aZ14lUwuA86aiOH-@J2N7QTR9R3>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <aZ14lUwuA86aiOH-@J2N7QTR9R3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 58sfqjicwb41twsbdjk7hzzz8zub1yx6
X-Rspam-User: 
X-Rspamd-Queue-Id: D97BE140008
X-Rspamd-Server: rspam01
X-HE-Tag: 1771937595-43347
X-HE-Meta: U2FsdGVkX18CcgfAnIKdyJuM0k24/Qob23O9P9yF0Pz6wraLwUrjqWu1NrjvpQrtbkf5Ik3nrFMBlx6WLffPh3KY2chdWuPpzv2I91UztUYwgKniup3RYQXiUY5HWZiSpJWwgKAkwyt2vGQUrmJwQ1oTOAZU4XPufUJIkZWo5S6nbXfp8SiSdjJ4AcUSOqU1phJgEyxzwRJKY3pU0UimPziCAXplKlg3HEc/lqD3xTv9UvQkV3JGaJ/GV5si0+oprJEksCsLTpzpb6jKOMimePIKgup+jxYTb9zSaFueHGsqS7K4AFcXg2owfilu3wWCz+CGD4rF/bQdzTKo5ODQEdilS5y/MRujvwEPjxS3JvixPWbfEuYcTvTOGrC+flTu8BDJ/KtrqqeYyi6nugXWWFmagHnngT/XrSCVdDOlOqe3bEhrQMYlnjzx8r6joOQIkQ2PIw9S/51m4aU0m6lEa86YJ6bwkfv6NYF+e6J5o5g5a/1ucsQ8FN+1/Ty4KlEwoICHo9VMPw/QdpkXdLxnY4ELqOp8Oi81syrezFb/QM1JoKnZJ/b0dMTAudhKhzi51CiV+sE0GDnSiuTM2lgMqevsvglCBk+WpLiyD1oWaZmXqKCZVd3FfyxPnLUi4Cvzyd9aXk4m0B9R2rCO4w8XO3MtbT9er52/VwMbJfV2fMmPKu+LgoPBaDFBZDUZxHYc9zasTQsIvASiKI2SwkDCs2SvPQ+RwE3DkQ+XkxPj4rTsWDDghg2LWA9j9bteHGVdGUG/YD/9lZdD8AkMAdBhqPmdjWUb9jq2TiC53zIDGzsd8KqwiTtbRGB829of0NZBAf/b3QsTKVAtfS1J/HSlAS/c1wnc5AKYr13JOsR3vDsD3LGg/vGc0MvyblDB9v1pnlKL6VONzLVoidS41ZZs1ovKMR7MApWoLtETFHXDfbqzMSt0CtCGLOr+1TdsaT8ZTZvrrYX+wK5+n4b16sP
 SUtSJMRi
 GftCIMLFfLkoC/wI1MhlOstFLvBEpcwCh5o5WrIUk3Ibs7jRBdUOcPbEF4KEBMPp1JaOSSzZKKFL5OjTOWGKOgVOCHZEaXpubnImrRpOaPiMoXwyLiW1b5mu81iutd1jJfK1zOSG/e+ubJZdzKXu2y+IVogyfVCH8asXmFvY0OlHWQhEcCaQYfrl7Bo7WtnwZrHcPeGwk4zoL2u90zefJKrKrsdXZkuDWRPQe/wmjw7xM0/Ix7aBumr6iuA8XbhmaXscXz2QYgHCHqBTjFGage0CdrSgSDpjk2fDVsYMeuZItlU6ywFpyewpqIdPMfJb3Nlq7qrqs4EVB+x0FJVWQ3wAHZa9Fqn5mBYpR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24/02/26 3:38 PM, Mark Rutland wrote:
> On Tue, Feb 24, 2026 at 10:41:41AM +0530, Anshuman Khandual wrote:
>> Replace READ_ONCE() with standard page table accessors i.e pxdp_get() which
>> anyways default into READ_ONCE() in cases where platform do not override.
> 
> For each of the patches where you make this sort of change, please
> explain in the commit message *why* it is necessary to do this.

Sure will explain the intent better for these patches.

> > IIUC the entire point of this is that in subsequent patches, arm64 will
> need to use something other than READ_ONCE() for all pXX levels in order
> to support D128 translation tables.

Right.

> 
> Spelling that out in the commit message makes it much easier for
> reviewers to see what's going on, and to focus any discussion/questions,
> e.g. *why* won't READ_ONCE() work?

Got it.

> 
> Mark.
> 
>>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
>> Cc: Namhyung Kim <namhyung@kernel.org>
>> Cc: linux-perf-users@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  kernel/events/core.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index ac70d68217b6..4ee151cd2c6d 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -8422,7 +8422,7 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
>>  	pte_t *ptep, pte;
>>  
>>  	pgdp = pgd_offset(mm, addr);
>> -	pgd = READ_ONCE(*pgdp);
>> +	pgd = pgdp_get(pgdp);
>>  	if (pgd_none(pgd))
>>  		return 0;
>>  
>> @@ -8430,7 +8430,7 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
>>  		return pgd_leaf_size(pgd);
>>  
>>  	p4dp = p4d_offset_lockless(pgdp, pgd, addr);
>> -	p4d = READ_ONCE(*p4dp);
>> +	p4d = p4dp_get(p4dp);
>>  	if (!p4d_present(p4d))
>>  		return 0;
>>  
>> @@ -8438,7 +8438,7 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
>>  		return p4d_leaf_size(p4d);
>>  
>>  	pudp = pud_offset_lockless(p4dp, p4d, addr);
>> -	pud = READ_ONCE(*pudp);
>> +	pud = pudp_get(pudp);
>>  	if (!pud_present(pud))
>>  		return 0;
>>  
>> -- 
>> 2.43.0
>>


