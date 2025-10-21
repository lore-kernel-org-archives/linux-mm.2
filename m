Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97107CCD1AF
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 07:48:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB9578E0016; Tue, 21 Oct 2025 03:48:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E69AC8E0002; Tue, 21 Oct 2025 03:48:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7FFD8E0016; Tue, 21 Oct 2025 03:48:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C4D418E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:48:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 80CD9B904A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:48:28 +0000 (UTC)
X-FDA: 84021343896.09.5D477C0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2098540008
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:48:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761032906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=olDPgqQofSZ28TETuqHxhx6/FvLnh4130JzGH+wmONA=;
	b=xoZ5sgXGJvpuuGK5U2qAX0trtA4/Dg3hi1MQ9MIZpd+LFsNCg0UBNFVIdtzItt5OhxefgU
	WfFLNTLXFUaT4WL8+OxteL4T90c78WN6plxSTuG44AUpttMNHKM1hgnlqXb7QKmBL0v8oM
	6TMEUb86s62PKKg+3HlnAJI/952TpfE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761032906; a=rsa-sha256;
	cv=none;
	b=oYsW2OWdbE+jDoBf9yfA7kFZHanDF51kxb2aMC8LYOV/+d57c4kVywFQZdtPZQUax2/Rdl
	+oLcc0Hf3vq5+CIg0Dxjws8frveEdJbk74+7U7isJquRZIuCf5dVdo6FEmIPY6Kg4eOFKV
	Fk2KIVVtoxcSQwuLM1e9ibtoF9btTmY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 16DD71063;
	Tue, 21 Oct 2025 00:48:17 -0700 (PDT)
Received: from [10.164.18.45] (unknown [10.164.18.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0B5C13F66E;
	Tue, 21 Oct 2025 00:48:22 -0700 (PDT)
Message-ID: <5face11f-2e04-4f28-b474-7c22a10d05e0@arm.com>
Date: Tue, 21 Oct 2025 13:18:20 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/debug_vm_pgtable: Add [pte|pmd]_mkwrite_novma() tests
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>
References: <20251021024424.2390325-1-anshuman.khandual@arm.com>
 <875xc8ap0k.fsf@DESKTOP-5N7EMDA>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <875xc8ap0k.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jnpks8tgw8g98eacqmz76z4es9q7cxnr
X-Rspamd-Queue-Id: 2098540008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761032905-862899
X-HE-Meta: U2FsdGVkX18gOehMVixzGdGIAIDrb819VcoBNlEbk7qlnHyN57InzhgY2oy8eNfjLk8aBCnZd0FelhPcfwa1h/mIHArCQdmOGUzIfYwCNZR08WbUhwDNd9ts03BAwY6eEwhNBR+Pc5+4OTAhuc5FYIiu7jrcZ7P89/4n97SQuZNv1DHz6YtSrN2nair67eRYfiQ34Asd+OV6XrCTpSJ1b6jRWXBt9z3J08HrCYUXf1jJgQiAKdqfbNl7UqEQ2o9JoM7TtxIRXzE3TQTA5PoD82L7lfp8WGB8grg/ImftZMp5XljBZsRFNxIDnCHzqhKFtmCmj4tfMsBqaz/ySMhhO8ZNQygMQPnSa+UDrylIRgXV80cpL9GYWfYUp2Ihu3cV/nvDZwhjPw6laWMJrwjQbLAl1yQXzqJ5kkumhJW3Ei0nFuLnXgaQXPHp5T20MyZ9kUvazh+40gzIR5HsRkHEOvCO8z+M4XPjerU1lp+hqeO9KsQiOBs4SrHlFP7IZPUFWNXiCqrEVgmmd9rfdWjsPP5QbTjDONAMBpUQnjC/kUqa5hE4Dv8zqXzifNkSQyGll8peT+0D/k4B8EGIKaNv/30r4V2ye9U6g0XY4Kolm9g/qZJF0UQi6BQ4Lh0vzXtCCYTgpfVr2l1UlPOCFhxdrvs7p1ZrPjoHMH1VUSw69/KW4YrXIdOS+G2v9zmj0E+6pkuvhXQxcpMfcP9GfG8Jc/A+ytoE12OOYVQm9LaHDiSw+Sr9qOczrkbH390pEC5zDYZ1zFiTlGs+Takb/pAnj0HyN53BCCxWEGOO8tFMH4xPGojTC3urk6YQubbu0wVh4v5OO2AiJk796yFaeVphox588GJCdY7+Cy+jlUgMd7K2hS2rLxeE+aZOWchUlsCDdLlpjx/WNapmE+7bSv3Lz4CC+Xm6y4NfxuZDszYOvdc4z14mNj3y4LR8UnztB8ii7eSUyvPdJa1fKOMlU05
 5hDjSWBb
 A7K/O0CHA30INZOO3UOapqAKbYXDC4zTFRrtuxFfcMG08d9Mf17q0PXTs8QCVJxZu91pOIaIYDynjf0GmfsYPewB+nZGtlqeAMr9cNSkkCU0/jlJqb9KgQyBVEx0OJoeQrLYy5TS3S/RVUFr1z03EpSiDkdSn0ObVa7LrbnNQ9Bf3bHcThxansRd/Ow82HaEr6htwK0mZiVdXr15eQGqcY7hYct2qUWdk05YRo2RMdAvc/1mdCg36djWl+4hSgE93nNnaBCKtLvzhHauuQNmLWw1ngtmxSB4Fnh3IzHs6ze8Ydl03P6Elr+dAEsYQVZmmI0VNGZBX4Ex9l0H+lFYRFeCIm1jZHSM7OVHNtGoBAFdWb9KfQJgXB9U2taT4DT0RgxFDZ050UvZRo/pzrvTk/cSniDU2IzEILxpgghh7dUwvSYA9AcFKzxr5iA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 21/10/25 9:24 AM, Huang, Ying wrote:
> Anshuman Khandual <anshuman.khandual@arm.com> writes:
> 
>> Add some [pte|pmd]_mkwrite_novma() relevant tests.
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Huang Ying <ying.huang@linux.alibaba.com>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>> These tests clear on arm64 platform after the following recent patch.
>>
>> https://lore.kernel.org/all/20251015023712.46598-1-ying.huang@linux.alibaba.com/
>>
>>  mm/debug_vm_pgtable.c | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
>> index 830107b6dd08..b9cae1580782 100644
>> --- a/mm/debug_vm_pgtable.c
>> +++ b/mm/debug_vm_pgtable.c
>> @@ -102,6 +102,11 @@ static void __init pte_basic_tests(struct pgtable_debug_args *args, int idx)
>>  	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite(pte, args->vma))));
>>  	WARN_ON(pte_dirty(pte_wrprotect(pte_mkclean(pte))));
>>  	WARN_ON(!pte_dirty(pte_wrprotect(pte_mkdirty(pte))));
>> +
>> +	WARN_ON(pte_dirty(pte_mkwrite_novma(pte_mkclean(pte))));
> 
> Why not use: pte_mkwrite(pte, args->vma)?
> 
> Maybe add
> 
>         WARN_ON(!pte_dirty(pte_mkwrite_novma(pte_mkdirty(pte))));

Sure, will add the above test as well.
> 
>> +	WARN_ON(!pte_write(pte_mkdirty(pte_mkwrite_novma(pte))));
>> +	WARN_ON(!pte_write(pte_mkwrite_novma(pte_wrprotect(pte))));
>> +	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite_novma(pte))));
>>  }
>>  
>>  static void __init pte_advanced_tests(struct pgtable_debug_args *args)
>> @@ -195,6 +200,11 @@ static void __init pmd_basic_tests(struct pgtable_debug_args *args, int idx)
>>  	WARN_ON(pmd_write(pmd_wrprotect(pmd_mkwrite(pmd, args->vma))));
>>  	WARN_ON(pmd_dirty(pmd_wrprotect(pmd_mkclean(pmd))));
>>  	WARN_ON(!pmd_dirty(pmd_wrprotect(pmd_mkdirty(pmd))));
>> +
>> +	WARN_ON(pmd_dirty(pmd_mkwrite_novma(pmd_mkclean(pmd))));
>> +	WARN_ON(!pmd_write(pmd_mkdirty(pmd_mkwrite_novma(pmd))));
>> +	WARN_ON(!pmd_write(pmd_mkwrite_novma(pmd_wrprotect(pmd))));
>> +	WARN_ON(pmd_write(pmd_wrprotect(pmd_mkwrite_novma(pmd))));
>>  	/*
>>  	 * A huge page does not point to next level page table
>>  	 * entry. Hence this must qualify as pmd_bad().
> 
> ---
> Best Regards,
> Huang, Ying


