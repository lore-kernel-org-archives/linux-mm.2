Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04777E94626
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 00:39:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB9D56B008C; Mon,  9 Feb 2026 19:39:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B917D6B0092; Mon,  9 Feb 2026 19:39:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8FC16B0095; Mon,  9 Feb 2026 19:39:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 953BD6B008C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:39:44 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2655616031A
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 00:39:44 +0000 (UTC)
X-FDA: 84426689088.10.2071563
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 17C2F1A0011
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 00:39:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=r+2akQlZ;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770683982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qLzFv/iaTtm6O5tzZ+GpAratMNjp1TNVZjLH5IvnkwY=;
	b=jz6jszwdTr93AWd1KYH/YIaBoztUS1oZgB/xoi8V1QYshdnEbOe6oWmkp55i1zWxvXNK3W
	1CHmOQmRxv3N2pCLG05GakaV8v/kjrqZTCSJK6pXhaYYJyEldUduw6EmZ3OIHar+63oK68
	Nv7B/eoiXa5DUFu7H/zdC+67xtfFVCw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=r+2akQlZ;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770683982; a=rsa-sha256;
	cv=none;
	b=xjytFz/zSlZQS4DMgZGUJtpiUmIBIv038s4xa3ux6soSSD+Tnsv+ZsLUgyUZwFbeV8eQyG
	EFbfRMfFg2Kmj78UcuMPbWl4ML2eS7t0Xs27WeAeA4ooP/R2+SlnFyQEP4N2OIs1kSJA8r
	RpTRBceYfTZIiWnl+XamASMnelUAKlQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770683977; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=qLzFv/iaTtm6O5tzZ+GpAratMNjp1TNVZjLH5IvnkwY=;
	b=r+2akQlZ8BcNVqdDclph4fyHCzGqnniyTuSRhjNASYfVYqkxsMNZ6MYaP2yzUYv43y3GKblIP3dZf7U3WFeLzFqjCUaEVIRNnJmtXLT+vjKSM1cNoLrUsewLo6XCYkftg1rEoD08JVDa4dbmQh6Wn6gLKUNNn1NUPahyA+NJKc4=
Received: from 30.74.144.109(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wyx2lhG_1770683976 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Feb 2026 08:39:36 +0800
Message-ID: <48e27f5e-d47a-4d53-bc64-6c6a22db9180@linux.alibaba.com>
Date: Tue, 10 Feb 2026 08:39:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/5] arm64: mm: implement the architecture-specific
 clear_flush_young_ptes()
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
 <ce749fbae3e900e733fa104a16fcb3ca9fe4f9bd.1770645603.git.baolin.wang@linux.alibaba.com>
 <10f061c9-5c9a-4e8a-8790-a2a68b38ff33@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <10f061c9-5c9a-4e8a-8790-a2a68b38ff33@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ke5pt1inkwtpaumhykncy79e4yfcnw7p
X-Rspamd-Queue-Id: 17C2F1A0011
X-Rspam-User: 
X-HE-Tag: 1770683980-265178
X-HE-Meta: U2FsdGVkX1/sWiCetjY3oKHchhLC6ik5M33PT7F3X//HJyINfVxgn+9n4jTywfLIjsyg4ePKIToIKCZi0Ejm3OtHjYUDgiuB47EdZ/fxg6RBlkEr32gIvOYZLSqHcefWLAaqP6tCmlgMK3nXKcED0mHRHSJrvoG0N8a8z8aFofHIsYislzqya09yG1WaXKcvx+SLNyabAC7IlpprBPhpbs1OyJOsMBYCglU1FW6Z7QaSxxEPen3FGOrfd96/GLCDIeluBnbjvjuSNAu8KeeSTyPlTuJPkn8avacfdycEZ/QuRTw5j8d+FMemOrRoCKmin79s21qIB6qtZmHntEljIRvEm6jNqhoeJc8O1Buh2LFQoSE+dxKfvjR+P5b5Bwp2cDZlMXpZh9jpcWZlCSFLtOrlF1aFRi6I/oLf37/RyL61lC0S7Xyk9SowGczKU1K0hkDGrORdG/aUjD+b/xco8K3x45swx9Ccz7A9PrLhKK47ZMIhppooUEQ/t2Uyadko9ozAauu1fwRufZZShPnTGix6Xn1flG+jks2/Id12pXMzF2kG6Vi4kuoH1PiBftzxlxIzjzUTaDc5chvMBtvW7cIx4zmiD9LkKyxgEBYcK12b2Jvw1tmFlw1cVjDxAmth4Pfomr2KYlglTbCKLfkkWLJPTU7atXjGLHntrgD1/cx9SWaxERzr2yfc9kwbD7I3/QqrVSF/BnKENfBWzSguXGGRrJV5m4hDXi8N7WC6pYQ3k+EBGqBc6ovAUCDglDg1G/wmr1LyWSpBP10D/cmnelUqan3vXOtykP9UQLqAamtmmC/sBNkbj9ni2TBJicoDZiAidUqVrp7AX7hM1kck8oJpd1njyncvZYrPp3+aSSXmMn0PCdrOC24ks5U9Eenld9jMZQhtF78XwGdtqFb61fFQdqNtjfRg0SerAr7LF/2sp47X9AOr3+lsQNqoQ/tz9RGAVjx74FytlMgUqWU
 gphzp2zE
 ldrChFX+uikz+uYjcyDT/fK910GbcZ3cAQShXEstFxyX1VJQM78MyHWsJxlPXrFbJYnErzv4HZEXQRuSpS7z5m2hYIdMANMAxquvNqJZfJsJJwNzKwALZfXK078GMgyHfOuWs1hZOCowtsUNLXo6d6bvEXCNejreIuDpBN5dcjNSetT9Fx41qw4ncVezNOHfUyz6oOzPr6O4NGUT9b83pbLLWTDu+lCZMYd89raI6nvmtN3w+WJ0XYBUZeNsY0JBGsDYtJw7e2SowD1Dki8ekSla6Lt5pzXcN6ZF1zJZZ4737IOr2LevqF4aSJq/Hq02SGWRaoW10ikrubEISTfmhRH/BzqD130iyMtBPakAXQmANGVTwAO9FPZbNpGoGDA1HJjoK2BwT30+lwvuZxnBKujE3XQLOTtd6ti0y5EplvrjPzlwtdL/zpyZK9PpEQ7Lql/1M1qIDiUw6zCQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/9/26 11:30 PM, David Hildenbrand (Arm) wrote:
> On 2/9/26 15:07, Baolin Wang wrote:
>> Implement the Arm64 architecture-specific clear_flush_young_ptes() to 
>> enable
>> batched checking of young flags and TLB flushing, improving 
>> performance during
>> large folio reclamation.
>>
>> Performance testing:
>> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, 
>> and try to
>> reclaim 8G file-backed folios via the memory.reclaim interface. I can 
>> observe
>> 33% performance improvement on my Arm64 32-core server (and 10%+ 
>> improvement
>> on my X86 machine). Meanwhile, the hotspot folio_check_references() 
>> dropped
>> from approximately 35% to around 5%.
>>
>> W/o patchset:
>> real    0m1.518s
>> user    0m0.000s
>> sys    0m1.518s
>>
>> W/ patchset:
>> real    0m1.018s
>> user    0m0.000s
>> sys    0m1.018s
>>
>> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   arch/arm64/include/asm/pgtable.h | 11 +++++++++++
>>   1 file changed, 11 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/ 
>> asm/pgtable.h
>> index 3dabf5ea17fa..a17eb8a76788 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -1838,6 +1838,17 @@ static inline int ptep_clear_flush_young(struct 
>> vm_area_struct *vma,
>>       return contpte_clear_flush_young_ptes(vma, addr, ptep, 1);
>>   }
>> +#define clear_flush_young_ptes clear_flush_young_ptes
>> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
>> +                     unsigned long addr, pte_t *ptep,
>> +                     unsigned int nr)
>> +{
>> +    if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
> I guess similar cases where we should never end up with non-present ptes 
> should be updated accordingly.
> 
> ptep_test_and_clear_young(), for example, should never be called on non- 
> present ptes.

Yes. I already adrressed this in my follow-up patchset.

> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks.

