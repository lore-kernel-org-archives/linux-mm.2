Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E12FAE7E0AF
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 09:43:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D756C6B0005; Mon,  9 Feb 2026 04:43:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D23D26B0088; Mon,  9 Feb 2026 04:43:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2F986B0089; Mon,  9 Feb 2026 04:43:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE84C6B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 04:43:12 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5350F8C3D7
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:43:12 +0000 (UTC)
X-FDA: 84424429824.07.DD8D820
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0775810000F
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:43:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=K0EOFNQ8;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770630190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UBI+jRRyuRr+QajwiPV5bCA0PKZRJLu20S4RKTSvJt4=;
	b=HiAcLtsKBldXxwgz3wmR5zp32+3z0+Wcv3oNerMH8RcMgbjLJhT8Ygc1usmy5VzeLFHWoW
	SFM1qYsZR9uiNW9AOKj7O02nf28+4gjLMkYU7grIywng1cdpiLI4GoeOceTzest1ssoozQ
	RThlnNjHFiyq2fQ+MTEe0FYFMw8D4Fg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=K0EOFNQ8;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770630190; a=rsa-sha256;
	cv=none;
	b=oMAXOyhv5ZOmFE/al6WyLia8aneGy7Se/hjc2EpHqHZDL7zwsTQAQQE5ZCkz1fIZP3Q3gy
	KX4qllR9Ltb6ONJO00J8ajprsLFoX6dW85M9TxzehupIHjoyF6HpqNEpTj32/NmkQa6q0v
	ga93qAAZIbrjHIWbDUIBj6tCvjAzyi4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770630186; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=UBI+jRRyuRr+QajwiPV5bCA0PKZRJLu20S4RKTSvJt4=;
	b=K0EOFNQ8rrGZUkjWUCNo81GcEfXGpTuJIlIG2dpmQO2L5Yqj0y6mFiVJs5lwEds4/ascn0O9J2WF0WexLCfayuRA6M7cPkkVQwcADSkvx/Gik6Ze8k5H3srCzcObkj92ogvwURmLCo9QCCJ7Y9HQmDFu4dd8RK7PYh4Qan9gSIE=
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WyqXdyS_1770630184 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Feb 2026 17:43:05 +0800
Message-ID: <ddedb72a-d24f-48bc-88b2-f6f99f3d45ad@linux.alibaba.com>
Date: Mon, 9 Feb 2026 17:43:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/5] mm: rmap: support batched unmapping for file large
 folios
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
 <46d0b6bf-db7e-418f-a497-983db4d4d786@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <46d0b6bf-db7e-418f-a497-983db4d4d786@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1aw7psnmqg6mjm6aqywsycyea79ditaw
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0775810000F
X-HE-Tag: 1770630189-892668
X-HE-Meta: U2FsdGVkX19eK4j2n4DiJp3MgrcPQTUgVIzbfaW6kkqrlbqj+uuxwVLWzfoRVh8kub3z9DKYmIpg+SKS5diroPC1V7pHhDXhKwoUfbu2xEMJu+1jb9ymTF74BbYu74p7ePE3p/Tfas2oCJwNMX4GQ4ikk7yqfsAzeG4oXfeRW2hjYNPXdhWCx8t+YF3e1QCmG6lBdi6xd4hTpQIW9d0FEQT67xE3pzjOqfxHG+MLi1+Vvbm+TJq/V2wAcytPrYBmFoz3Tq8gpfCwhpxK0NYzPKgIYjrh2uzx1Bw3z2ehLi5hAArr6iaxBsD9YbMr3984g/Clx8DAlkryy76bMmBq81GIbm949bM2Yg1Yfn9EkC0TbwZDI/FW0GEb8br/x/kZw8RJsmheCmcLkg2x3mQRwlMv+mRKH36XDCcMVxzLbqF572tKxb27pOzq3L2vy8jR/lhsG5umdcTTkQXOsVG10HF4VtHD19cELAGJuhDtQtasq6UfGENads8jotTYTS7IuzI4p4CLcxtmzOXAqKUUmyr7byuvCPhIeDUdN4O4G2OSOFlqqeQGtus8jgVZnWXL2/vqZbKDLBpDtt74VP22La+WkAZPHH08PygYkGW2L0iTemxce8s1rXE9SNSp3vEvMzfcfe1Y7DVrMw34jHMA7p3kW9l6B3QQ2ukXWU7mYh0rJyJE6AHKU0ROCvrJyK6/nUa70eM13ENR+U8wG0yHCH5r+RSjEkhX+dhJA2Cxh92IjtzcybDmOBxiTuIGs+X+WGT8ICtPQj2OYhOKPMGD7OPPFMPb2tnWQsAGKiO5drN1CR8c8+v7r3oY6ffpYxcwI7rKNZX2QvLAI0qJs1uVCbm0/TgbNGJC/XDX7EjO6JUsF+Ebvl3V2Hu9LBzadTdygUwQEjkd/Dm+rPH6ik7v9NYBzkV/+xbg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/9/26 5:38 PM, David Hildenbrand (Arm) wrote:
> On 12/26/25 07:07, Baolin Wang wrote:
>> Similar to folio_referenced_one(), we can apply batched unmapping for 
>> file
>> large folios to optimize the performance of file folios reclamation.
>>
>> Barry previously implemented batched unmapping for lazyfree anonymous 
>> large
>> folios[1] and did not further optimize anonymous large folios or file- 
>> backed
>> large folios at that stage. As for file-backed large folios, the batched
>> unmapping support is relatively straightforward, as we only need to clear
>> the consecutive (present) PTE entries for file-backed large folios.
>>
>> Performance testing:
>> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, 
>> and try to
>> reclaim 8G file-backed folios via the memory.reclaim interface. I can 
>> observe
>> 75% performance improvement on my Arm64 32-core server (and 50%+ 
>> improvement
>> on my X86 machine) with this patch.
>>
>> W/o patch:
>> real    0m1.018s
>> user    0m0.000s
>> sys     0m1.018s
>>
>> W/ patch:
>> real    0m0.249s
>> user    0m0.000s
>> sys    0m0.249s
>>
>> [1] https://lore.kernel.org/ 
>> all/20250214093015.51024-4-21cnbao@gmail.com/T/#u
>> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
>> Acked-by: Barry Song <baohua@kernel.org>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   mm/rmap.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 985ab0b085ba..e1d16003c514 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -1863,9 +1863,10 @@ static inline unsigned int 
>> folio_unmap_pte_batch(struct folio *folio,
>>       end_addr = pmd_addr_end(addr, vma->vm_end);
>>       max_nr = (end_addr - addr) >> PAGE_SHIFT;
>> -    /* We only support lazyfree batching for now ... */
>> -    if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
>> +    /* We only support lazyfree or file folios batching for now ... */
>> +    if (folio_test_anon(folio) && folio_test_swapbacked(folio))
>>           return 1;
> 
> Right, the anon folio handling would require a bit more work in the
> 
> 
>      } else if (folio_test_anon(folio)) {
> 
> branch.
> 
> Do you intend to tackle that one as well?
 >> I'll reply to the fixup.

I'm not sure whether Barry has time to continue this work. If he does 
not, I can take over. Barry?

