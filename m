Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 007C2CE9D74
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 16:10:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65DDA6B0005; Tue,  6 Jan 2026 11:10:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60A6E6B0088; Tue,  6 Jan 2026 11:10:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5411E6B008A; Tue,  6 Jan 2026 11:10:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 428BE6B0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:10:49 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 812251B54D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:10:48 +0000 (UTC)
X-FDA: 84302027376.12.4BEC620
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0FAAB40013
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:10:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KMfitq5q;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767715846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p2Cxn3EwhDHfjbIl/gQOEzsQers63B4LPHPOwWIVtEQ=;
	b=IuAz3fPRQG2vvjtSrV/Hq6lnUkmUSa4CvlV6bYym++vihYa/Lt+JJd91dOUaX0/KAZDDFr
	ZC9h0FxTx3gRP1hdhNsu6CPhKAJqrpblZu9uw5vBkIaRRdvL3BwRlOCX0335rBdin4YtEe
	v+UFSXUL/SaXjrkUM1qSgNIqtN7nVC4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KMfitq5q;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767715846; a=rsa-sha256;
	cv=none;
	b=ZFyGyCCgYwFIJy4lou36a7x8inVubh4jTAxNpJ/arHurVoFDWNsLtG5TxjyP+YELfS92rD
	7AotxZF0/9zVr4xFZVTqr06S7AOhnrMDAADeVtAS6NsGXJ6Im3Y+uIIZkPOrv0UMh2BAN8
	Z147DAhCGaV8ttctQt6p0NYWWvTvfts=
Message-ID: <7472056a-3919-429a-845d-c2076496d537@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767715841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p2Cxn3EwhDHfjbIl/gQOEzsQers63B4LPHPOwWIVtEQ=;
	b=KMfitq5qykqtSP82o+xKD9KMrBh5LLQ+BMtIueS1XaPfvKYYuLI/cEv8q892u//dY1od0g
	LO0YM3SIAu7Q9S0iBF/IKhT8smwFrozBqukDDTU7JjgH1HSDVGwkdIraim4N1etNoNULLe
	0HuFBMpjKHsPFeFGdcxksdb5Q6B3nZs=
Date: Wed, 7 Jan 2026 00:10:16 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RESEND v3 1/2] mm/tlb: skip redundant IPI when TLB flush
 already synchronized
Content-Language: en-US
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: dave.hansen@intel.com, dave.hansen@linux.intel.com, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, peterz@infradead.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, arnd@arndb.de, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, shy828301@gmail.com, riel@surriel.com,
 jannh@google.com, linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com
References: <20260106120303.38124-1-lance.yang@linux.dev>
 <20260106120303.38124-2-lance.yang@linux.dev>
 <da1e8a00-99fe-46d9-b425-c307ea933036@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <da1e8a00-99fe-46d9-b425-c307ea933036@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Stat-Signature: no44wmbizaif4y8cm39n6q9ch48188zb
X-Rspam-User: 
X-Rspamd-Queue-Id: 0FAAB40013
X-HE-Tag: 1767715844-48678
X-HE-Meta: U2FsdGVkX18LpFqiCWkJYIgqti6bvAq8xfRlipC9+G4vwgjElGX3Tx6qN3+SzIUAocuZEqzunc1i9vWIYrw7A41q92BUInN19TLaowO7nbEuXEwGJgFfBgQjD89ULNkUhcg0YmQ4JEdMSht5Rib1DJwZX4DtH969oNUpT1YJZmivIfKdw4Be5rpNZ1jM1fBgS/sONiPpYk+z0jitcyP7bB41qX6hVdJMiN8vPhDEXDevpeaOqrtO6eC33SgawugKz/W7x/RlHFZNEa2lE+hQaCZku0X1NoZL1doHUdOim5l6zGG4QHSYyNOwjtR7L+aPPOuQcRjolF505zPsj18tJEfR/5QuzlnLzdnjoU/b/QdeBFa3MQss7GxLSvSmDGGVOszIZre3QQZDR0QplD34rYkfW/PoXhI5xE7S62qqURehaFNQOKTZ26vZyXy8V4CnSQ0tAHlOUNJS+xzEh5EYH8G0UM1AfvFsIBJKruSJt3AK3iGKDpARv3FMQIGIUlYcpWZFmKM7KoUTWg9yyLwn8ERWg4qJLj786zdLyqR4CJTkBC2vFjqIM4QEfsC+/G20TKRPCKarwPzeigv7So/227x/2w58EFnNt2wSTxi1m8qHTAZYqXhVF9xWOQjNTsA7wAFHJvRdBb60ydK/FJL5P+s+iFXP7jnNI8k5lgGhf0bYj2wYSKw9yDCCBOAfoM/MsM0E50zI6h0saLbrW4iTME60JLkKklHH0ApwoPpwRzUMTKCpCWNFYmIoGMF/RHwZ/gfa/LnL3D53DGvLR+jM7pEU/78bXgJwDUG3v/4LcR2hA2UH1X9wQXm4/ldGCZqlcWtsroiGZNbxLMpwR/unlsI8iArMFtPs4wH8wyAKljA5LjsNMiiSLOERvVLXo9CneAz/yNqqapvSUn8PzP/8iHRFST8skHHK19vt4QXb5Hzi4zeLY9XUnkAhUTUO2kgYnqjBc75Q2h2ewGqIJgN
 xHfGOvdL
 3cxrolcRSimkJ1y2waK2JUKmaNMB7/kYYXWb1e52L/yq+kKMVdQ5nVFwiaabUvFnq3IogZrJVb/XqinExMu2OZhIeKQSp1cLumxICJDu8aMPfKoN476II1wCucTayaLtZl+TTdPyipoX4V9IfzJAMQppY5EobPHe5szD47sPJCN+4vhpBSECEulbbmPv5XXLM8kuloyLioVYtYe4sWN4pe681pdZQUYiuXo5GcrvQPVVWTfc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/6 23:19, David Hildenbrand (Red Hat) wrote:
>>   static void tlb_table_flush(struct mmu_gather *tlb)
>> @@ -367,7 +378,7 @@ void tlb_remove_table(struct mmu_gather *tlb, void 
>> *table)
>>           *batch = (struct mmu_table_batch *)__get_free_page(GFP_NOWAIT);
>>           if (*batch == NULL) {
>>               tlb_table_invalidate(tlb);
>> -            tlb_remove_table_one(table);
>> +            tlb_remove_table_one(table, tlb);
>>               return;
>>           }
>>           (*batch)->nr = 0;
>> @@ -427,6 +438,7 @@ static void __tlb_gather_mmu(struct mmu_gather 
>> *tlb, struct mm_struct *mm,
>>       tlb->vma_pfn = 0;
>>       tlb->fully_unshared_tables = 0;
>> +    tlb->tlb_flush_sent_ipi = 0;
>>       __tlb_reset_range(tlb);
>>       inc_tlb_flush_pending(tlb->mm);
>>   }
> 
> But when would we have to reset tlb->tlb_flush_sent_ipi = 0 later? 
> That's where it gets tricky. Just imagine the MMU gather gets reused later.
> 
> Also,
> 
>      +    if (info->freed_tables && info->tlb)
>      +        info->tlb->tlb_flush_sent_ipi = true;
> 
> in native_flush_tlb_multi() misses the fact that we have different 
> flushing types for removed/unshared tables vs. other flush.
> 
> So this approach more here certainly gets more complicated and error prone.

Agreed. Tracking the flag through mmu_gather lifecycle does get
more complicated and error-prone ...

> 
> tlb_table_flush_implies_ipi_broadcast() was clearer in that regard: if 
> you flushed the TLB after removing /unsharing tables, the IPI for 
> handling page tables can be skipped. It's on the code flow to assure that.

v2 was definitely simpler.

> 
> What could work is tracking "tlb_table_flush_sent_ipi" really when we 
> are flushing the TLB for removed/unshared tables, and maybe resetting 
> it ... I don't know when from the top of my head.

Not sure what's the best way forward here :(

> 
> v2 was simpler IMHO.

The main concern Dave raised was that with PV hypercalls or when
INVLPGB is available, we can't tell from a static check whether IPIs
were actually sent.

Maybe that's acceptable, or we could find a simpler way to track that ...

Open to suggestions!

