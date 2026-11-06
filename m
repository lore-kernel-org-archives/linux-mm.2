Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 609C3606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0ZIO5xCt
Received: by kanga.kvack.org (Postfix)
	id 752496B05B0; Fri,  6 Nov 2026 05:29:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 703166B05B2; Fri,  6 Nov 2026 05:29:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E3B96B05B5; Fri,  6 Nov 2026 05:29:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 232F26B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:29:06 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D222120CDB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:29:05 +0000 (UTC)
X-FDA: 85404321450.15.11EE925
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf31.hostedemail.com (Postfix) with ESMTP id A711720002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:29:03 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0ZIO5xCt;
	spf=pass (imf31.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793960943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4mlR8+gtgMvy46avSZaRKYsDQLl9BuorhRkyL83qQCw=;
	b=CsbQerLFLBJi6Lcyo7kOMzwjTK0CvB8M7wVT9AA5mNfzrJQI9aPUMnIOHZCwP8vierN4Mz
	dVn7X7vku0koq3n/MzBnveJSft09m0NwNInqeJHRYvPctjtIhvAUS5erkOkCae5zK6w76R
	dC3RcqUQcznbadPV/G8c8BKCZNTgQSg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793960943;
	b=Kc933e5JYpOTFTj0V2kgwwzfwEDjtUBDMPlbA72HVGDyXXA6uaIxeft7okhtfil6MDvCIb
	4Wrn+JST+wm460/R7TfDuVdQ1Ud1PrFv39HyXWPrMOs92CTOJFUJTHuXK3Jl0o2+qi/DTA
	PrNiKGK2TDWTc35VwsMnY9SCOeB2w/A=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0ZIO5xCt;
	spf=pass (imf31.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a60f9474c4so5890835e9.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 02:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793960942; x=1794565742; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4mlR8+gtgMvy46avSZaRKYsDQLl9BuorhRkyL83qQCw=;
        b=0ZIO5xCtWN+gKH73nLu/HONBq5k72k1dAYJbwH9zOPqkHkcUs5rIJRHHFn6XerkLf0
         UnryhdCAPjWJJpbJAbxxGLOHpwJiIr0daqNmIOr1CKHdJMw9brRIy5s6ZruGX63DH9tj
         6z+CRdRauxQUqvNpVDS53hYsZVjyomg1P5QpyIujxuHx9GR9BOInnGeLNmTjgv5BWYT2
         wfwdQhrsHbVhhQMooMGX6sRDwnm04iXwME6mi7zjQ4bQDtOzai37llbYd5GwjfV6k+gl
         Uecw0pxkLk+D20Fk6uOw7Y6tSnl+YPlWeTKrCS+TD0ML+esB+UOvvZNtq6QJZxXElc12
         sRZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793960942; x=1794565742;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4mlR8+gtgMvy46avSZaRKYsDQLl9BuorhRkyL83qQCw=;
        b=Oj3Z0PSgyyGGdlTyeg267agESlxFwUz8LWPRvHagtK3JaZ3jjZmECSVjSubhUegM3X
         0150wB2wxbzkIv6M4u7vjcja3bsnCzgJWRJ4YmwMOjnjwVxOwTiLCPD4fUhRKS8bOQqE
         JO5l6S3P5wspoObtNTKqOE7A3cZAaj6KqiHJDzC/Pb8LHrUMQ1RUfroXRCbrTLxCK5Cq
         F0hsTv7SlO4nwKJxj9SEddJsqbps9wEskwyfpdF3/CtSm+gPWyiftxcgmeczMkw9Kk4o
         sEz64RhY3GBJ6YqCCF6Z2xY9W/D7vA5yTS3NND2JBaGGTwEzfixMnberb66KjbM9IQu8
         qMFA==
X-Forwarded-Encrypted: i=1; AKwUvBxzOOQ1ASCc850G8D4pfsPltqgHWmSvcG91BfGNEstSExAoM8u1OCe6gO7fHwzhftz+Xv+eMGAiyQ==@kvack.org
X-Gm-Message-State: APuU4Z+9ARjh21d8SWYHwx8iiVkOkAZEjeqAfDq7U65clBlzQkzarFSl
	w9Bo2NuXpNuJpdc4V7w6BWDTsNVSlMuZL6jW75ZgH29gUgZf70R2dj1e
X-Gm-Gg: AYBFou06Lai57TaUqdkCZjKBOOFB0D2FnZuqvfuhTYCFCVUjNQiKAis7f64pLT6UTCl
	9Q5bsy5O1sh/j3WuSP5HayuazZqJda5P0PKJqjJYPaeN35cJb8F+8eHbTs0RuqxYjp+VInywfzt
	qY4s5z1iQZuEcpIiDWkFUufd4SgAlUDfsifAJUflaY6ixqWl3tjjDbNBq/pzLUZMQC6xpyb18ug
	J/eoQmAvG8Dg0Ow9gcqycyVt5/TDp4tQ7c5hhp2FntKlPmlyhRI3038Jy2rclUXgHLmYfdo6t3e
	GCUOhgwLakhZvfKIjtsrY7q8AHl9pP1IkME71amuHw/6v8Q2Am+18F095rimxJ7e91+WfbHjWbj
	fNcMuWsAnEYfdrpfRqI8DihsFSMKjGymZN0pf21FvH3omUIFpu58SOCoHeZXbk18s+P3yDg+xdO
	iTpbJfkbczHIs3epatJaFmCElM5n+it1TOG7bA/sU5zCjhB4RVv1TD3vfXRY4o9xhXHYGQpSmKp
	UyWauCj0bgB51gz3PIow1bFAoZiDZlrok7X8OiWuvLtEkm2zEdase6XdAP9qUw7v9nYagKhX1KW
	Cz3AxE2H+7S9apaCDLhY2FQ=
X-Received: by 2002:a05:600c:4694:b0:4a2:994:575c with SMTP id 5b1f17b1804b1-4b6e0454d69mr33998485e9.34.1793960941975;
        Fri, 06 Nov 2026 02:29:01 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-492d7dbb0d4sm2925477f8f.50.2026.11.06.02.29.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 02:29:01 -0800 (PST)
Message-ID: <5c084ac1-930d-40c7-b6d0-b56673da9cf5@gmail.com>
Date: Fri, 6 Nov 2026 11:29:00 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org>
 <20261105-khugepaged-latency-fix-v2-3-4384bbfe4606@kernel.org>
 <551892bd-d7ca-4c79-9c7b-9d3d08c913e4@gmail.com> <au2lAPUNPlRtaeFY@gremlin>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <au2lAPUNPlRtaeFY@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xe1bh9tgizutjj7mn133ngfoftadfc4z
X-Rspamd-Queue-Id: A711720002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793960943-946615
X-HE-Meta: U2FsdGVkX18JngCG2RK775QNOoimbV1sqmKbXWwBFuVyhJkmPwVVvOPCknepc0vDBYWJFB8xNndHRmsSkAxOT18VzcgZ9YWu7NDpSm5bF2GFVLV6yzIEawBB2Ak/0USrSeghqL6Rd0pjO0ql3LoqUMpN9XlrxnbH0OF4SWKqeSjnbh4eRD+g4TN1DAAeb6h89/pS6i00BkktOkZpan+Ex+D41qzo1FvC7LbA4HLOBn5nfbCrN4nnImUtEjgorU2LHGbRe2XHQt3fCJXoMMkz+PGoRs/tBfqFTlDyj27/xn/WpMEXgvlyH5vr3iw2kRLAkBis2EepT73c8n3WrEPgOVNqrujlZGIBIwiOCL1tXhU37wIO+CJV/XfoNe1ygLAoUnEWTXXAizgICCddaQWLNniGtAtUHZQDyF1EaZ8bC401r96sacPdo1Tt9/6/P6cYX3neZ4R9iy/EdCte2JVJv+HZMtACRdep4xHQ201fYRclAfucBPdOHFdiUBc1WtRPD5kapBN41EnfSSmMgeh5AMT/EsGLJRmYucoZvtmzqzkqUkjkuvn6PkbTsL8gylb6aaJuwUufhP+PB3mK6tLjjf5LMmDnWmlXexCHDJq9andhV49f2N4pVAUxEyHj/Lc+cnL69Ghh2Dm2cb3+jpwJ/rdghtqaGZnsnpjURqtU+uD9rh1AeefEQkHybOoU64SCoqe3SkGZgtP+Df4byEIBfhdabVnpAEiRUpL83LzTI2ECVd88UnUqkvHxhhUYzolkmOPhPssXgAWgMBSY2WCAGmMQXaRC21oRrDngH6BAsgDJofWEbYM+SF1WI1H4ht3663PMxqdXC1671DC1iPBW/+q5jGVveC0kVxJf9Rqukzbghrt199qkrGPpio+urjWdCuSqsUPtLFIQ2rgLSnJH9HtXOgRXlairnN5cnDQYtJ+GsPg5O5yfUKWzgLwG0WFXY/zOpDSuCZ55q1WW7A8
 b4/Su6/c
 Mu5yODPboBRV0PSznzcZVFGmugPZQSndjUwn7QG7XH7T9i7o+BlT3wgcfrTo3/vf+z5u+iQw7Xr1td+T2bboF5FyJjqI23QHClVSYJE0NxOSyDGScFZSqTCb0829MFAanBaleqvqE2TxY5xx+8wMQbocIVBiviOfZzHTJ2Hsbt27Ph/puSl6mDQzZRJoBawD306yO3BcCj0eSdRBnd0G8F/pst1IOPYBG3qql086+cchofgLXDv5ubm96uX9Cmh44MzLVTbBHoeusqpumcvqueCA/WFfCmhW2TDjkZTjfPv4zglGTxZk7StC+KHvmlyGgAQ+0NAq66GkiWGjrZ0qIEEken64mAazBwOUhrwRRnIQkyzMuy8RVxXucSSKVeATSzxPw9YcnxYlocFP/75GmtyrFAMoOddKaNQlRgE9mHSfPFNoRaIah+QP9xEzp4ZT0m+VgsrUqdnwksW7cW+9mMKBKSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 11:03 AM, Lorenzo Stoakes (ARM) wrote:
> On Thu, Nov 05, 2026 at 10:53:13PM +0100, Jose A. Perez de Azpillaga wrote:
>> On 11/5/26 9:57 PM, Lorenzo Stoakes (ARM) wrote:
>>> khugepaged walks an mm's VMAs under the mmap read lock in
>>> collapse_scan_mm_slot(), checking for ineligible VMAs first, and skipping
>>> them if encountered.
>>>
>>> It charges cc->progress 1 page against the /sys/.../pages_to_scan budget
>>> when these are encountered, however only checking this budget once an
>>> eligible PMD-spanning VMA is encountered.
>>>
>>> It can therefore hold the mmap read lock for a long time if there are a
>>> large number of ineligible VMAs present in an mm, over which time no mmap
>>> write locks (and thus no VMA write locks) can be acquired.
>>>
>>> Address this by checking whether the mmap lock is contended after every
>>> KHUGEPAGED_MAX_VMA_SCAN_BATCH VMAs walked, that is a quarter of the
>>> pages_to_scan budget, and if so dropping and re-acquiring the mmap read
>>> lock before resuming the walk from the per-mm cursor.
>>>
>>> As the walk is resumed from the cursor rather than the VMA that was current
>>> when the lock was dropped, the cursor must never move backwards. A VMA
>>> ending at the top of the address space causes ALIGN() to wrap the cursor to
>>> zero, so treat such a VMA as the last in the mm rather than skipping past
>>> it.
>>>
>>> This was tested locally with ~1M ineligible VMAs mapped ahead of a
>>> collapsible region of memory, and resulted in a reduced mmap_lock hold time
>>> of 170us down from 95ms.
>>>
>>> This was also observed to reduce mmap_lock stalls in concurrent threads of
>>> a similar duration. Note that a reader re-acquiring the lock can currently
>>> steal it from a writer that is queued but not yet running, so the full
>>> benefit to writers depends on the separate rwsem change at [0].
>>>
>>> Local measurements indicated no change for ordinary use cases, so this is
>>> all upside.
>>>
>>> This work came out of investigations into mmap stalls when getting latency
>>> numbers for an unrelated patch series.
>>>
>>> [0]: https://lore.kernel.org/all/20261105-rwsem-dont-steal-from-queued-writer-v1-1-275e070f426f@kernel.org/
>>>
>>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>>> ---
>>>  mm/khugepaged.c | 31 +++++++++++++++++++++++++++++--
>>>  1 file changed, 29 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 216c4b8d28c4..eaa01dae5a03 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -66,6 +66,12 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
>>>
>>>  static struct kmem_cache *mm_slot_cache __ro_after_init;
>>>
>>> +/*
>>> + * The number of VMAs to walk before checking for, and relieving, mmap lock
>>> + * contention, as a function of the pages_to_scan budget.
>>> + */
>>> +#define KHUGEPAGED_MAX_VMA_SCAN_BATCH(pages_to_scan) ((pages_to_scan) / 4)
>>> +
>>>  /**
>>>   * struct khugepaged_mm_slot - khugepaged information per mm that is being scanned
>>>   * @slot: hash lookup from mm to mm_slot
>>> @@ -2910,6 +2916,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
>>>  	struct mm_struct *mm;
>>>  	struct vm_area_struct *vma;
>>>  	unsigned int progress_prev = cc->progress;
>>> +	unsigned int nr_vmas_batch = 0;
>>>
>>>  	lockdep_assert_held(&khugepaged_mm_lock);
>>>  	*result = SCAN_FAIL;
>>> @@ -2942,15 +2949,35 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
>>>  	for_each_vma(vmi, vma) {
>>>  		unsigned long hstart, hend;
>>>
>>> +		/* Relieve mmap lock contention after walking a batch of VMAs. */
>>> +		if (nr_vmas_batch++ >= KHUGEPAGED_MAX_VMA_SCAN_BATCH(progress_max)) {
>>> +			nr_vmas_batch = 0;
>>> +			if (mmap_lock_is_contended(mm)) {
>>> +				mmap_read_unlock(mm);
>>> +				cond_resched();
>>> +				mmap_read_lock(mm);
>>> +				vma_iter_set(&vmi, mm_slot->address);
>>> +				continue;
>>> +			}
>>> +		}
>>> +
>>
>> with pages_to_scan below 4 the batch is 0, so under constant contention
>> we keep dropping the lock at the cursor and never scan anything, don't we?
> 
> This feels like repackaged AI review...
> 
> The mmap lock won't be eternally contended and if it is, with pages_to_scan
> under 4, I think that's fine.
> 
> Alternatively could make that >= an == and the post-++ a pre-++ and the 0 will
> never be hit in this case.
> 
> Or could have a minimum cap.

with >= a minimum cap needs to be 2, since the cursor can stop at hend
inside the VMA we just scanned and the walk lands on it again after the
drop. with == only batch - 1 VMAs get scanned per cycle, so a batch of 1
scans nothing, today's batch-0 loop at pages_to_scan 4..7, and a batch
of 2 hits the hend case. it's safe from 3 up.

-- 
cheers,
jose a. p-a

