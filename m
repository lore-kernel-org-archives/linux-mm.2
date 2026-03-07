Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EC77FC9EC3
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 01:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CC5E6B0005; Fri,  6 Mar 2026 20:28:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 479F06B0089; Fri,  6 Mar 2026 20:28:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 352486B008A; Fri,  6 Mar 2026 20:28:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 236AA6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:28:39 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D48731B8901
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 01:28:38 +0000 (UTC)
X-FDA: 84517532316.03.B0B0988
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf23.hostedemail.com (Postfix) with ESMTP id 033DE14000D
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 01:28:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pyqDt5oW;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772846917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kzar5nNFlAv1Huoqo+I+k0T1XEOUIvMAuNiWgwlVg7Y=;
	b=qs4nYvn09NxTuTfyLrGyTYK0pb/OYr/6z7DxX5C/AX2++E40k1Ebo+mqAj6vJJBACfwNAB
	QluZEwYXOEkGkOkVqk+1RvJ2JowcOuU0JZtwpC5fm+ugT0iKOtsdfIJpMuSaXxThzQjRxo
	Fv135gDlMfsFku7euW+Lw+dFy+sH3sA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772846917; a=rsa-sha256;
	cv=none;
	b=unhRtUzxPj2Lu7CJj+1B8qMfY2M6RYRCKw+YCXvjHfZTE0Bjdtx75KAVpAyfIJESqLMWsy
	sP/iCDBdSjl9/wlVPcSbAmLAlDSkpiMFlmTw7N+09nxo4CBM/SnyhmNZmIIqzBGlYQ4hQI
	HGShRJRlyj46chIBKIlU8S/897fnfFY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pyqDt5oW;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772846911; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=kzar5nNFlAv1Huoqo+I+k0T1XEOUIvMAuNiWgwlVg7Y=;
	b=pyqDt5oW4P5r1c0bh+xoR2cosDq2MOaQjvch4UvhyZYaI8MQvp1OBels4i/PrwnabRecULzXJ37jPlBlMLT5JHG1baW94mDs5oX2gpa1zDBJe9vw7K7Y3atTcGaGfWUl4Ts89ASTs5kbTQmVxsQXEaTcLyiBCVq4yELZ/Out04s=
Received: from 30.42.98.36(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-OMjm5_1772846909 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 07 Mar 2026 09:28:30 +0800
Message-ID: <c607b6fd-a682-4400-a7fd-abe83152db10@linux.alibaba.com>
Date: Sat, 7 Mar 2026 09:28:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] arm64: mm: implement the architecture-specific
 test_and_clear_young_ptes()
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1772778858.git.baolin.wang@linux.alibaba.com>
 <7f891d42a720cc2e57862f3b79e4f774404f313c.1772778858.git.baolin.wang@linux.alibaba.com>
 <6305e05e-2911-42b0-b6f5-7fdde787b778@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <6305e05e-2911-42b0-b6f5-7fdde787b778@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 033DE14000D
X-Stat-Signature: zxzpqc5bddppwdt3yuxcm3kuiedx6dim
X-Rspam-User: 
X-HE-Tag: 1772846915-591902
X-HE-Meta: U2FsdGVkX1+NdjOFGnW3qRYgS1kUdI7px0nLme+17Ka92oOWt9uaxhmmECFvFoJEHFfLZw8Rl6C8TFqerCo3/JbE8r5KRBtkc27fA07mGVSS9qlboYF8lSheYC1zoZlwTmkF5zrN/Nt0Fu20U1zuDAwYSBMsVo4mZGoU1/mex+kvvNkFzPfsui9+80fCryCn+yrOJ/zuP0iKzj3KPecVnWDMPwBG5f7t37uvOqU1k9dZLKLrJfiObu+d95GIRNDd9r2zEHDbgOxX1DnK5lczMXq0uJ+rh2KhuMkw96kM1sBgD6q9VzpskvjMrozALrxcbu/m04Disz9WpZxJHkjXK3A/RQULwHBtLLSArNWS3FlaTNBT2eQkM2cHDanZ1agsmBmw1gxTJMpioAtfDYxjwPYk3aHkgHbP8Z4cFTSSiSawPdg75MRMwzrHmBT1mwa8QZzFa4c78/EBdv94sxVXUhskgGLNHRUmQpycsCXb7t/FFgOCcNlFozEtqTb3ogaNp4Ic2HIPMVjopdfra7w1DxHJYfg2ouKOIWNkoy9aUt3nQ7j18ybf9F47yd4evpEzbyp75zYAqEauPQImt7PM4mpT9fET+n45OAkD1Vn62w2TgoCobqxgLBLIiGexjyLgz+Mn+pLxlBn/9Fsv0XmmfA05yRoC8jiS+IuG1MIy+WUdBHzob3B7+tEKaTizgDyVvwIVGkNmmVDHisyKk6491f/lUAJuolp+Tm/T5P9aCpd0H23AkqbIC93AuRdQ9rMz6IO2NnR77VP/JYiEjUe9xRRlNaPutnkSowppBsc+yK7Qn2nMgSLWMUnGRVEvFD6ydjluQ9OByRP5Jl0rCTF8YQxfFvUWAUniWYkCrJ8JiGM3pOUit0w1CjCvtV0gXI/a1UgX+wbA+xDO6SEYt9zL9YbieCFpkN7zfs8Gxot3o22UzKakY94zIAy5nxs/Z8Qfc9cpnJ/OQmCB25qOeU7
 lQcoeRQB
 dGsXlFdXZ+wwpd8s53PTAY8EaX7o0jYySz8frO4YAtpT9w3AL2ofUPBhyEWBRY48HTdKDrJALPf2wp51jQsuUXCsoPybsddtDwdd9OYR5gFgwM/DvoohoVcg/+GCo6OvTGwPl3sta2lhW5858nh6tsYWWJxsRAlNzvqbUOO+GCzh8GoNwFyK4cWghcPEJ8stE1fHE8N9Hzy5cYuI/jDQ+T1oTcr/RlqpkGP/poDg7qRlBtDg+Ij/g9TLZkQMzJbLBly4ZPCRWRF9zGD8kMzqUp/oYrab1idzgQW19oqLExSumotn8XXoxWWNX3s2SE1Rn9VeENOKBs95+JBUoLlR4vjmt9h9V87DHdls6sqziPVwji1VeplDGJ0vqQYTkfrXKW+gJwQv1JCuXYBgpy6WOjKGSc2nhOXpHnETg/YzUF7hWt70gQ+m/BhVs0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/6/26 10:47 PM, David Hildenbrand (Arm) wrote:
> On 3/6/26 07:43, Baolin Wang wrote:
>> Implement the Arm64 architecture-specific test_and_clear_young_ptes() to enable
>> batched checking of young flags, improving performance during large folio
>> reclamation when MGLRU is enabled.
>>
>> While we're at it, simplify ptep_test_and_clear_young() by calling
>> test_and_clear_young_ptes(). Since callers guarantee that PTEs are present
>> before calling these functions, we can use pte_cont() to check the CONT_PTE
>> flag instead of pte_valid_cont().
>>
>> Performance testing:
>> Enable MGLRU, then allocate 10G clean file-backed folios by mmap() in a memory
>> cgroup, and try to reclaim 8G file-backed folios via the memory.reclaim interface.
>> I can observe 60%+ performance improvement on my Arm64 32-core server (and about
>> 15% improvement on my X86 machine).
>>
>> W/o patchset:
>> real	0m0.470s
>> user	0m0.000s
>> sys	0m0.470s
>>
>> W/ patchset:
>> real	0m0.180s
>> user	0m0.001s
>> sys	0m0.179s
>>
>> Reviewed-by: Rik van Riel <riel@surriel.com>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   arch/arm64/include/asm/pgtable.h | 18 ++++++++++++------
>>   1 file changed, 12 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index aa4b13da6371..ab451d20e4c5 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -1812,16 +1812,22 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
>>   	return __ptep_get_and_clear(mm, addr, ptep);
>>   }
>>   
>> +#define test_and_clear_young_ptes test_and_clear_young_ptes
>> +static inline int test_and_clear_young_ptes(struct vm_area_struct *vma,
>> +					    unsigned long addr, pte_t *ptep,
>> +					    unsigned int nr)
>> +{
>> +	if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
>> +		return __ptep_test_and_clear_young(vma, addr, ptep);
>> +
>> +	return contpte_test_and_clear_young_ptes(vma, addr, ptep, nr);
>> +}
> 
> Thinking out loud, what would happen if

Good questions, I think the contpte_test_and_clear_young_ptes() takes 
that into account.

> (a) The range spans multiple possible cont ranges (like, 64 ptes).

The contpte_test_and_clear_young_ptes() will call 
contpte_align_addr_ptep() to align the range to cont‑block boundary, 
that means the range can span multiple cont blocks.

int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
					unsigned long addr, pte_t *ptep,
					unsigned int nr)
{
	unsigned long end = addr + nr * PAGE_SIZE;
	int young = 0;

	ptep = contpte_align_addr_ptep(&addr, &end, ptep, nr);
	for (; addr != end; ptep++, addr += PAGE_SIZE)
		young |= __ptep_test_and_clear_young(vma, addr, ptep);

	return young;
}

> 
> (b) The first pte is !pte_cont(), but some others in there are?

IMO they can’t be handled in a single batch. Since the folio_pte_batch() 
will group consecutive !cont PTEs into one batch and consecutive cont 
PTEs into another (assume all PTEs belong to a single large folio), 
because their PTE entries have different CONT bits.

Even if the callers do so, contpte_align_addr_ptep() will check the 
pte_cont() of the start and end address to align the range appropriately.

