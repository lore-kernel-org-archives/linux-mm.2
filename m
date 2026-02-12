Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4880DEE3698
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 15:25:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B25D16B008A; Thu, 12 Feb 2026 10:25:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABC846B008C; Thu, 12 Feb 2026 10:25:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D2C56B0092; Thu, 12 Feb 2026 10:25:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C5BB6B008A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 10:25:43 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4558B1A01E6
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:25:43 +0000 (UTC)
X-FDA: 84436179366.08.9DB2E01
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id A6A2E80010
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:25:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hjkncimN;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770909941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3md81SdFS4TjjB0AXkEg5ItTPXkzpc4iibpel7Bvl6Q=;
	b=GvDZr6jSDI0xLvrloFbaz8gvqBoxH6vw7LZ59HO3fvCYFeFf7mbPp6YZnmoIDz6nOt/YP2
	DOKbu1p9iqKU+J5bm71LWfKLp6QtkDYzrmQcsKAnFKUgPkaAr8kP5PERcCCe88ZfaRHOpI
	HiWDkVTVXHh+sYgZ7IwxDM15l+zPx9k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hjkncimN;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770909941; a=rsa-sha256;
	cv=none;
	b=Of3V82NDXFxwj9YEdqic7+8oi6+ABAk8IBTQ8H/eA6treI0Ibf0cd1qLw+C/2+0Mk0uE1S
	kTBhcy6SpPwkt82ivhYX995rF2jTz7X1h8EXDGndWGLIKaXw1D+6ZfveLPH1a4HwxatT02
	CsxrhR+uRkk/K+wRysikSjU8vj82bH8=
Message-ID: <93908945-e0a8-429c-b119-eff63ebb2479@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770909937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3md81SdFS4TjjB0AXkEg5ItTPXkzpc4iibpel7Bvl6Q=;
	b=hjkncimNaPPExvn/emeaq/h/AlfCnw+mVVCMpaG7jfK1AU3G5MNnceGQoxpZLRm+7s8TrG
	SMgyuBDmGiF9cfQ+M2rMahOUxsaiyqzUKf7jsPpmGt1bnR/CpoXyBRoS/SAaXyBEptiUA9
	w68x0WYS4Za0LU2R9RKu9ekkYbD3FhI=
Date: Thu, 12 Feb 2026 15:25:33 +0000
MIME-Version: 1.0
Subject: Re: [RFC 1/2] mm: thp: allocate PTE page tables lazily at split time
Content-Language: en-GB
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, lorenzo.stoakes@oracle.com,
 willy@infradead.org, linux-mm@kvack.org
Cc: fvdl@google.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
References: <20260211125507.4175026-1-usama.arif@linux.dev>
 <20260211125507.4175026-2-usama.arif@linux.dev>
 <13ab56cb-7fdb-4ee4-9170-f9f4fa4b6e37@kernel.org>
 <875x82ma6q.ritesh.list@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <875x82ma6q.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A6A2E80010
X-Stat-Signature: 54acnba1a39s68di7g8hpo38anfe6dy4
X-Rspam-User: 
X-HE-Tag: 1770909939-40085
X-HE-Meta: U2FsdGVkX1+0KPW4TtTEn0ZTK43AqpWIf0iT/MxeW3NpAMaJ0/gkMWuWv6obKTCbFJBGgqjUas9QYtNzpa9fAn8ZXETuiWFrRHM9V2bTfnbt8WkT32Z+mp8zbfMvuiOEJHo8b34C4Cit6aMexkQAts/+ewm3E9EJBoQF0KlH704agwNhj5EeoMNAYgyqgmgbOSCPHdhau2yFWL+usVaw3DhSrwW+d3KZ5Q6HpeBETLL2sz8NNF47eaOrjrBmREk+ZRMvxmSXYjygWBaizlQ18cJASvtvIaqhOwVTf0A1/O+smAf/qCTlcBZgHvetI4jAH/l5YfcFj2lyjkaKveJFJDVNr1G01WBEl5jhJxzOO+dg+IhvPsxypjOf1RqwM3EiGLJvZdvvmIREEMB34kfq1LHGLNSzptbnCxu5kERHzKtfJOt7V5QnvAFI+SLfkyESdjiNxMoUWsHoUy32jYTDEEXSAI71NnAuT++DMjhRQiYM5M2KmRVcVEL3bHJbjgakMXb88BYLfp9vAi2fKwve7wy13Rn63ULbW5GFC+Ytr7pTdtcEedA1xxgZ91/EnjLpfolmr5uZreM/uFiQQGQ8KEPCEPnOvvtX0NjN3gfXueJjk/4GgLKhReMGdRHOfUcqsI2vjYjzH5Y+nc0xilbeK02wnFpVk4Z6yLIabZc6nFDT5jPKRbw6++HijKbW19RwQaGg7y4WldE5+QxgnWGg2xxiUuRZTqrlYAgbUzFUCFvPll+hsIjzxgCGX7y5eZ8yyzHlo8AEL4YAsjPmMFuAU+cSc5X7tVpsVMNaSywb+2Psm18z/pBj15RgtgRciTVn4CUx8Eo0OY+FVk6IaDj26PQfrvCBWfsN+ZTLDoKUfvkoR+WWp9b+vHQw+YkUxcyeOzNU32rij6LRvapRX66dQvINz26vEFKGrcAiiqePQdXQY6g+58oQks3DQFB/2ETCwY0HICIovz71RIiwy9U
 /219UqaP
 62DrSEZycmo6N6VoGF3p265k3gLx0CP3gjrxynq0pkNzaDKldrpyZcgWfYKIouzIQR2j1E5l7zLUWrFpsiIJ+9NP1j764E3zvfoHZSCk7H59ddOVTMfAblJ8cQkBuayqTgHEFbWrQwEOjgNHDz45a1TQgdulw1jtoZll3/2BjD24eqhCAAjuenenw7k6QQuFHHUf4FWZvlt69jSDOXBLZj8w18u7700U1+ndVRI9W2el63/fQkOLWRo216Br1wvqmJV95qs/xP7mnUNqbEMsSpOHVN4DrNBkBR8HZYMtgcYnlyu9VDbfDEtmjegawSluumiS5fowzGXTM9cg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/02/2026 12:13, Ritesh Harjani (IBM) wrote:
> "David Hildenbrand (Arm)" <david@kernel.org> writes:
> 
>> CCing ppc folks
>>
> 
> Thanks David!
> 
>> On 2/11/26 13:49, Usama Arif wrote:
>>> When the kernel creates a PMD-level THP mapping for anonymous pages,
>>> it pre-allocates a PTE page table and deposits it via
>>> pgtable_trans_huge_deposit(). This deposited table is withdrawn during
>>> PMD split or zap. The rationale was that split must not fail—if the
>>> kernel decides to split a THP, it needs a PTE table to populate.
>>>
>>> However, every anon THP wastes 4KB (one page table page) that sits
>>> unused in the deposit list for the lifetime of the mapping. On systems
>>> with many THPs, this adds up to significant memory waste. The original
>>> rationale is also not an issue. It is ok for split to fail, and if the
>>> kernel can't find an order 0 allocation for split, there are much bigger
>>> problems. On large servers where you can easily have 100s of GBs of THPs,
>>> the memory usage for these tables is 200M per 100G. This memory could be
>>> used for any other usecase, which include allocating the pagetables
>>> required during split.
>>>
>>> This patch removes the pre-deposit for anonymous pages on architectures
>>> where arch_needs_pgtable_deposit() returns false (every arch apart from
>>> powerpc, and only when radix hash tables are not enabled) and allocates
>>> the PTE table lazily—only when a split actually occurs. The split path
>>> is modified to accept a caller-provided page table.
>>>
>>> PowerPC exception:
>>>
>>> It would have been great if we can completely remove the pagetable
>>> deposit code and this commit would mostly have been a code cleanup patch,
>>> unfortunately PowerPC has hash MMU, it stores hash slot information in
>>> the deposited page table and pre-deposit is necessary. All deposit/
>>> withdraw paths are guarded by arch_needs_pgtable_deposit(), so PowerPC
>>> behavior is unchanged with this patch. On a better note,
>>> arch_needs_pgtable_deposit will always evaluate to false at compile time
>>> on non PowerPC architectures and the pre-deposit code will not be
>>> compiled in.
>>
>> Is there a way to remove this? It's always been a confusing hack, now 
>> it's unpleasant to have around :)
>>
> 
> Hash MMU on PowerPC works fundamentally different than other MMUs
> (unlike Radix MMU on PowerPC). So yes, it requires few tricks to fit
> into the Linux's multi-level SW page table model. ;) 
> 
> 
>> In particular, seeing that radix__pgtable_trans_huge_deposit() just 1:1 
>> copied generic pgtable_trans_huge_deposit() hurts my belly.
>>
> 
> On PowerPC, pgtable_t can be a pte fragment. 
> 
> typedef pte_t *pgtable_t;
> 
> That means a single page can be shared among other PTE page tables. So, we
> cannot use page->lru which the generic implementation uses. I guess due
> to this, there is a slight change in implementation of
> radix__pgtable_trans_huge_deposit(). 
> 
> Doing a grep search, I think that's the same for sparc and s390 as well.
> 
>>
>> IIUC, hash is mostly used on legacy power systems, radix on newer ones.
>>
>> So one obvious solution: remove PMD THP support for hash MMUs along with 
>> all this hacky deposit code.
>>
> 
> Unfortunately, please no. There are real customers using Hash MMU on
> Power9 and even on older generations and this would mean breaking Hash
> PMD THP support for them. 
> 
> 

Thanks for confirming! I will keep the pagetable deposit for powerpc
in the next revision.
I will rename pgtable_trans_huge_deposit to arch_pgtable_trans_huge_deposit
and move it to arch/powerpc. It will an empty function for the rest of the
architectures.

>>
>> the "vma_is_anonymous(vma) && !arch_needs_pgtable_deposit()" and similar 
>> checks need to be wrapped in a reasonable helper and likely this all 
>> needs to get cleaned up further.
>>
>> The implementation if the generic pgtable_trans_huge_deposit and the 
>> radix handlers etc must be removed. If any code would trigger them it 
>> would be a bug.
>>
> 
> Sure, I think after this patch series, the radix__pgtable_trans_huge_deposit() 
> will mostly be a dead code anyways. I will spend some time going
> through this series and will also give it a test on powerpc HW (with
> both Hash and Radix MMU).
> 
> I guess, we should also look at removing pgtable_trans_huge_deposit() and
> pgtable_trans_huge_withdraw() implementations from s390 and sparc, since
> those too will be dead code after this.
> 
> 
>> If we have to keep this around, pgtable_trans_huge_deposit() should 
>> likely get renamed to arch_pgtable_trans_huge_deposit() etc, as there 
>> will not be generic support for it.
>>
> 
> Sure. That make sense since PowerPC Hash MMU will still need this.
> 
> -ritesh


