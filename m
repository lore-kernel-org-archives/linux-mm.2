Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFA77FC9EC3
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 02:14:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEC756B0005; Fri,  6 Mar 2026 21:14:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9A2C6B0089; Fri,  6 Mar 2026 21:14:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7C4D6B008A; Fri,  6 Mar 2026 21:14:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C69F46B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 21:14:49 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 51B0913B1C3
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 02:14:49 +0000 (UTC)
X-FDA: 84517648698.22.88EC2D7
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 07F87100013
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 02:14:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=b5iI7z+7;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772849684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TUiYVvq51PhsvRNPGgaHEtOWm+s6zhtlXs4s+mHmblo=;
	b=bnn3X4LHTwAaSpIAtDGZInhEB3E3G/Coy00sK6xFSHGuzAExYbFNJ0wXIzFyc2S2gLTS/g
	0e0QTc/pPqGiV3sd74Eb+I+rEez61yLhnYfw/u+h7tY3Z6Seb277tP7tFMyH/bTgMqk/GR
	XiVJWiceSkcqVuQwroZjazl/gjLQyy0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=b5iI7z+7;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772849684; a=rsa-sha256;
	cv=none;
	b=tc9FX4cQDETBCnZ68d4SgWBwphfzuuEENFnc3JligU2lLme0KEGFt0yLDLjYpc1fYYIy4N
	MsgoOrPIucHhrWop72Fcef8L0gPnk+2A+gEjbDQA/YFq0U/ShrEfNNSLB0GiuI0/p9ro7g
	czFNonfyoHurIK9FotqOOX0DEywzboM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772849676; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=TUiYVvq51PhsvRNPGgaHEtOWm+s6zhtlXs4s+mHmblo=;
	b=b5iI7z+7TMUzwsCsWnedhDFcmPs3CnrJzDjSeCin9BN1obx7hqyYCtk+0T1mHklsGHNSYTdJNTurY9exJNRpDhXzvqRvf07iLaPkUeys7m2rZXi7bcwuPThX8MMtXNPxG88lL13Xr2ikHxRhCZmng4u72EEWm/5cIMYq6uBoPV8=
Received: from 30.42.98.36(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-Ob2yS_1772849674 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 07 Mar 2026 10:14:35 +0800
Message-ID: <721abb6a-93a0-4db3-9e69-ef23b253e4f5@linux.alibaba.com>
Date: Sat, 7 Mar 2026 10:14:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/5] arm64: mm: implement the architecture-specific
 clear_flush_young_ptes()
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, dev.jain@arm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
 <ce749fbae3e900e733fa104a16fcb3ca9fe4f9bd.1770645603.git.baolin.wang@linux.alibaba.com>
 <CAGsJ_4wA-bpCaY8uLnwmzDT40s4RbsOXdRutvj5bZU+Em6cFeg@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4wA-bpCaY8uLnwmzDT40s4RbsOXdRutvj5bZU+Em6cFeg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 07F87100013
X-Stat-Signature: gwmcwgytbh586yei4zz1bo9fg74cdaeg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772849680-559557
X-HE-Meta: U2FsdGVkX18/WC9fkhrRlgQDddBEL0Lzlqf84IYvJmxY1Gb+02NWxz1xHjv6O07ZP7i3qnB0gB1joz0UYQE9wHRXHywLsAaje1MgvpCyDgnP6XIQNp+SLlNsmLTE7R24YgFoIjvMiBr23WIuGe2ZyBtybEev70DX3s3GEKRuD97nzqigecVsu6RrnVmHRvEDoHFUu0jEkAH2Qy6b4nruUsFpvEw82Gzjqr+GLCqUH/i6af1d4Q+f9DfBkgRgKQhL7BpOVmFfftUKIhhAZFOFrdktjLZfLacLo44d6QasTTDAQZ2b6ZODXlAKEi4de4q2Qep0CA4RiVuX7300CT9maHkFbe5vPct+dZN/OWDi5WfSZR8v5pKI4dtBBEoPxprQL3JPmBRqFXXJNakoeDNGt+YaSg7k+YU2B384ekB6aRVVNl1XrKhy9FSwmw0APVkrbKIOkWVfwBbaUz62pVnCfnPx8caGSU81XOD/WDomaQra2ZXTDfVTb1tAHT16jX69x1AuwUxXNtkFsGvWI8KrSli4f+r+zOS/bmOk97BbaHlUPJHrXR96TlzjydhlICf2b9E0m0rwXIC5ITnEZ5M/cwGcp7rjjGBGP/QvYl+MTlkEYbL8z5fMmOiFqWaDSzn0LY7La4HXR8c1ecB+eE99i8B4R/wBKOfvyVI9GZq27sLzB1sYGHNAKqwO/ZcsLdZaF1PnKk/9axaElC8QWHUvCjRVqR93wV7vPTQG+KL/VYKPC6eQJCegfett0F6hHfhJ9+TWILzmcBHxeCw8OxTo4nsDseyBxipsVnLvZSaNBB+IQrgzmXvtNgiLSrLTbXhHtd1fy53NMAda825KDVirMhCsyxnJ+Hlv/gVCR4uDryEWG99lFA/iF4yDDmyR/e4V3ll0rEc4LCedeAdj63e90L1+BCePmqhk5qiTqTNvVPGyTdPTLzlCtTsC0HmFRiImjkDTWA88Ev7ITBwTBhF
 7sSjrtWL
 RWtypqqOZadpVgeeXV7qqHh3+wAHR8l97SJYrKlB1LSEEamLwvUR3qrDO5/267CmpnLmYkHQKu9mHsBDrGL8qc1qO3kBcMg7+NmJIIz3dlsr1Tf24HXoDY2+7FRPy17abMzl+6jrgFE1dzKRCyn8rC2Cfx5tboWKCQ48ccMnSTYqUzvQcU6JUJKRHUCjf6U5ZA+ZpVJ7UXXt37rDbCERdBFScZEFKwzdAtFZld+RvTMNlLFNuOsJiQPanBlWvxGy/RYxvTVQqvuqnAS6bbCJncG5pE32t6J49tyrpybOaZ7cdIWKxq8g2iXZ2bBUIEulfxNoivUQpv/Qw2aDPEvhWb7NRSbUEl9VlrH9SJjC/3+sWR0YU3vRvmwwY6Yho+TOmO8FO7imlOwjL1dC04TqNwhvoVZa7SPav07gR91BEhBrd/pDNR4cZMOVBtlWxUeGuQDqBGos2L1yRq9M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/7/26 5:20 AM, Barry Song wrote:
> On Mon, Feb 9, 2026 at 10:07 PM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>> Implement the Arm64 architecture-specific clear_flush_young_ptes() to enable
>> batched checking of young flags and TLB flushing, improving performance during
>> large folio reclamation.
>>
>> Performance testing:
>> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
>> reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
>> 33% performance improvement on my Arm64 32-core server (and 10%+ improvement
>> on my X86 machine). Meanwhile, the hotspot folio_check_references() dropped
>> from approximately 35% to around 5%.
>>
>> W/o patchset:
>> real    0m1.518s
>> user    0m0.000s
>> sys     0m1.518s
>>
>> W/ patchset:
>> real    0m1.018s
>> user    0m0.000s
>> sys     0m1.018s
>>
>> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> Reviewed-by: Barry Song <baohua@kernel.org>

Thanks Barry. But this series has been upstreamed, I can not add your 
reviewed tag.

> 
>> ---
>>   arch/arm64/include/asm/pgtable.h | 11 +++++++++++
>>   1 file changed, 11 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index 3dabf5ea17fa..a17eb8a76788 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -1838,6 +1838,17 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
>>          return contpte_clear_flush_young_ptes(vma, addr, ptep, 1);
>>   }
>>
>> +#define clear_flush_young_ptes clear_flush_young_ptes
>> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
>> +                                        unsigned long addr, pte_t *ptep,
>> +                                        unsigned int nr)
>> +{
>> +       if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
>> +               return __ptep_clear_flush_young(vma, addr, ptep);
>> +
>> +       return contpte_clear_flush_young_ptes(vma, addr, ptep, nr);
>> +}
> 
> A similar question arises here:
> 
> If nr = 4 for 16KB large folios and one of those entries is young,
> we end up flushing the TLB for all 4 PTEs.
> 
> If all four entries are young, we win; if only one is young, it seems
> we flush 3 redundant pages. but arm64 has TLB coalescing, so
> maybe they are just one TLB?

We discussed a similar issue in the previous thread [1], and I quote 
some comments from Ryan:

"
My concern was the opportunity cost of evicting the entries for all the
non-accessed parts of the folio from the TLB. But of course, I'm talking
nonsense because the architecture does not allow caching non-accessed 
entries in the TLB.
"

[1] 
https://lore.kernel.org/all/02239ca7-9701-4bfa-af0f-dcf0d05a3e89@linux.alibaba.com/


