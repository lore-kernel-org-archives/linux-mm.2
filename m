Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0221F532DD
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 05:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2360A6B00B3; Tue, 24 Mar 2026 01:49:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20DD96B00B4; Tue, 24 Mar 2026 01:49:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14ABC6B00B5; Tue, 24 Mar 2026 01:49:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 02C136B00B3
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:49:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 98ABA5F548
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:49:31 +0000 (UTC)
X-FDA: 84579879342.06.4520883
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id 74F064000B
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:49:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J5uev0Zi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774331369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m/efI+AO/WU7EbNLcxU8hWUCzq+Ms95WwqJRGKroQR4=;
	b=EwGIqjaI09Fry1NATgqczB9I5COf2c89CHlJJj0Ji+lMVA20hDvYoLDO5g8h/lKScjEERB
	I1QOx2EGoEUgc4oMDy50b+mIelPTKhSqgrR4RAYwsoubWKfv+1l3qRm2cQ96J67D/fxuJg
	su4ggenlv7ON+Q1AWvkpjPYVoi+ULzw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774331369; a=rsa-sha256;
	cv=none;
	b=n5Ez+xF0E+MJFKIvPhk0kfHlgoXkm+IZ/jDh7E6wqQQ+aZbfvfDuvCu1KjFY5xFfOHx1P4
	tcgRhhAfI5Keb7uj2ohMoabb4RaxkYF44+e0n8dnabsddZAe4p3FY/cWDiGIjOQeoteuaZ
	9jGQwd4D2imUPlGjze/6GtjqwhjVNHY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J5uev0Zi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
Message-ID: <0c1e4a30-6ed7-4ad8-abdf-852bac34f9a8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774331366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m/efI+AO/WU7EbNLcxU8hWUCzq+Ms95WwqJRGKroQR4=;
	b=J5uev0ZiPkW3hdajbfr8ApMEN55l2NjWceK0ch0Qzj0xwLXkIHKJzDg4RTGWneoNkb1T9S
	yc7ET2XFKymZjY0/JLv59oMIHeSy5OR5Hs6L65rugvPF766nqsHzxA68fRPwbutkPSqAt4
	NnQx1Qsl120T+zJlWh2XZ/vw2yUdoYM=
Date: Tue, 24 Mar 2026 13:48:58 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v7 2/2] x86/tlb: skip redundant sync IPIs for native TLB
 flush
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: peterz@infradead.org, dave.hansen@intel.com, dave.hansen@linux.intel.com,
 ypodemsk@redhat.com, hughd@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
 arnd@arndb.de, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com,
 seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com
References: <20260309020711.20831-1-lance.yang@linux.dev>
 <20260309020711.20831-3-lance.yang@linux.dev>
 <bc8a7721-2bb9-4044-b5ec-422633690971@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <bc8a7721-2bb9-4044-b5ec-422633690971@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 74F064000B
X-Stat-Signature: 64814eiwu3xbeggo6cu8y4bj4bbizuhd
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774331369-541704
X-HE-Meta: U2FsdGVkX18EuuzESrasdb4ZcER1+oJyL/qMUBGwnnHpX36eufDKLnWd/sg7XppX3AfQikoMlMf7apcqmOTyyArrLHKC2Sid1C73Ff3ipsZAW2XrIoEVGYEo3R8NP7GASA/rr+DssUb3fJChmfPlrRFWeSuwCFjPawdECJgSnIKHPXj2Bylpnxa7bLQReAq4+pcmyV+XHRyyfsdY8vEY1ob/B5+4HrSMxLIZnQCWisqPm0/CHkSfgHmcMhqHimcq36hwdXFeYqvHeTjl30WtFEFZDaUCGlkJSUZa29GIOz5KPRBWNvkPmFQPh6HBvMUaG7AZX+02mzWDP5uh+4sQNZy1D8WyGu+bBG5xuUyHEqHFJTTTyt+sTtisUUHZH8RgykEgxa/DxND8lSEb8GU0e83j+mkx/D5f1cu0tqunDC328Yb5pDRD/BJuN8oLCgmoEiyowVZiuxaVztpU1LJtFe2ZA+UtouWBXxyFU0sTEMq5L00MPJ1BHkPdwj0hupdButsjTF7plpsOqNOAZ4vQl/JNpB+zEuBsmRZam9SPNBhEPyP8sQlusodZQGmYE31Qi0hnkMvvOAdtMCbVvOcp++/wnNZJvH55Oi5Ze4ClvnqDy8qbqtG1DRgSuuGKeTrkIKM2iLgSMj6Egp/cBT05TnswJu1SoUsBEnvxdXGiIGYtA3R/qUp42CCLYZooe5WoAFIxOFqtWbQuN4ElZc3VE17AvEyYxDvt7Fs/VQFb1n0gXBn8Dc2DrHUP6TrUHGw8Ct+IzKHx8nAvYrTg8BvPw8rasszN+dxjnV8TNlHY1jA8yC6Di5hXAq7gLtGovM/Dd1RIlXE4K+BbF21JtKKD0EXKAeVycCb1PqUQwVixOhaLVamFu7wv+2WLjJEIFtRbn5QiAyvJzdZnTL8GqmxKxdJFihtR/irmfflc6QWmPTxUuGnWvsfLyqsYpx9563bGL3BDRn0e47gsF9M+n76
 tONIHedm
 exa4dDh/eRO1zHwtqtPiJJ5Fdkigei9gtr8CZuEceYVLyD0u7pzzyfVg8j4K7dvA4kY7zhk78WBXz+DQ8MLXQ2IPEK5VUFjJMksW6zbOR6dPyza09VPDo7yQgZu0kHfuZBAnfCLOaFihlfPLd8Isl0evhPZJYkNIZbYAxetoFSiufV1giH3ul/42ilHO3Fs33ODR/WSv2tdfBpE5ofXOQkOOSMSyjXxP47gmwZSscAqomSntpF7Facmjj2qYgba3g3I3pp0SAoH+/kXBRUCDuBiD4p3Mqf5+jPEF3dR8Uc3NCprewyWrtUFSVwZzCMY30RlHHA3CoF/dxv7aQ7HU0HdXCEjCsdrQt08tG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/23 19:10, David Hildenbrand (Arm) wrote:
> On 3/9/26 03:07, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> Enable the optimization introduced in the previous patch for x86.
> 
> Best to make the patch description standalone, not referring to
> "previous patch".

Good point. Will make the changelog standalone ;)

>>
>> native_pv_tlb_init() checks whether native_flush_tlb_multi() is in use.
>> On CONFIG_PARAVIRT systems, it checks pv_ops; on non-PARAVIRT, native
>> flush is always in use.
>>
>> It decides once at boot whether to enable the optimization: if using
>> native TLB flush and INVLPGB is not supported, we know IPIs were sent
>> and can skip the redundant sync. The decision is fixed via a static
>> key as Peter suggested[1].
>>
>> PV backends (KVM, Xen, Hyper-V) typically have their own implementations
>> and don't call native_flush_tlb_multi() directly, so they cannot be trusted
>> to provide the IPI guarantees we need.
>>
>> Two-step plan as David suggested[2]:
>>
>> Step 1 (this patch): Skip redundant sync when we're 100% certain the TLB
>> flush sent IPIs. INVLPGB is excluded because when supported, we cannot
>> guarantee IPIs were sent, keeping it clean and simple.
>>
>> Step 2 (future work): Send targeted IPIs only to CPUs actually doing
>> software/lockless page table walks, benefiting all architectures.
>>
>> Regarding Step 2, it obviously only applies to setups where Step 1 does
>> not apply: like x86 with INVLPGB or arm64.
>>
>> [1] https://lore.kernel.org/linux-mm/20260302145652.GH1395266@noisy.programming.kicks-ass.net/
>> [2] https://lore.kernel.org/linux-mm/bbfdf226-4660-4949-b17b-0d209ee4ef8c@kernel.org/
>>
>> Suggested-by: Peter Zijlstra <peterz@infradead.org>
>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
> 
> [...]
> 
>>   static inline void tlb_flush(struct mmu_gather *tlb)
>>   {
>>   	unsigned long start = 0UL, end = TLB_FLUSH_ALL;
>> @@ -20,7 +30,12 @@ static inline void tlb_flush(struct mmu_gather *tlb)
>>   		end = tlb->end;
>>   	}
>>   
>> -	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, tlb->freed_tables);
>> +	/*
>> +	 * Pass both freed_tables and unshared_tables so that lazy-TLB CPUs
>> +	 * also receive IPIs during unsharing page tables.
> 
> "unsharing of page tables" ?

Yes, that reads better.

> 
> I would maybe have it written ass
> 
> "Treat unshared_tables just like freed_tables, such that lazy-TLB CPUs
>   also receive IPIs during unsharing of page tables, allowing us to
>   safely implement tlb_table_flush_implies_ipi_broadcast()."
> 
>> +	 */
>> +	flush_tlb_mm_range(tlb->mm, start, end, stride_shift,
>> +			   tlb->freed_tables || tlb->unshared_tables);
>>   }

Cool, this wording is much clearer :)

> In general, LGTM.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks for taking time to review!

