Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88F3FD3E783
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 01:59:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D57746B0006; Wed, 10 Dec 2025 20:59:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0E7F6B0007; Wed, 10 Dec 2025 20:59:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1E1B6B0008; Wed, 10 Dec 2025 20:59:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B1FFE6B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 20:59:01 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 595D916073D
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 01:59:01 +0000 (UTC)
X-FDA: 84205532082.22.6470A89
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id AAE0112000C
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 01:58:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c2JJnt6x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765418339; a=rsa-sha256;
	cv=none;
	b=EHuzF8AaY11PfnCKvnqlKPQ05LpTh2TOO+KvI0WUvyKEw7BNRd07VZOzVbppJ8bVauHv/2
	33baZUV4MfqJY9hKVGWcfnQlNSNJSv2c494nvDc3UL9yFb69UgYJzvZkVvF+a3pJFMa5la
	VHMgJ2xRp79npXISu3D7Gm24DA5xUo0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c2JJnt6x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765418339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kMkgRhXv/t9fhnUa8HGg3r8Ipj6G1cjjZetelmI4A6c=;
	b=Lt8ESclP+6hTY1eVIQNyuCWfHanajFJjNI0nvYUzVagEG9dihqDUFFH8EXwxp7+1e66lZV
	4RVtQxTdeE4glo3Iw+gcawk0ZhYypxuSztWciNap9Z4cLcLBxj3/0kNGCI99cF8C3YkZh1
	jNJNgleHPK7v2DVCjDeC/w0TOSfWRX8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0235C60010;
	Thu, 11 Dec 2025 01:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17CFFC4CEF1;
	Thu, 11 Dec 2025 01:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765418338;
	bh=vlF760B5VM4cBVjm5lLCjMa4CdR2bjBkUw3h2n7BWas=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=c2JJnt6x50ZeIVYp/2of259vDiRGLRdEM8mvk36W1oexnHD1wz6LWyyt4VNZc3jk+
	 tMkAu90O7wwxrgdsXqBV4yBJ4e2VzA8LvpKM3FFxqj7IFqi4IrJIR9Ut9Jf4Mja5uH
	 q4rWWOXN784TyKSxTap7GyaZmrheqcPLGjH7J4+uAEjb85shCGRoy6cs1NAVc87L18
	 LEu9M/+IttnzQiPBIzeeoS7bftUZ/pgqJd+fl0P0l6G4LGsNrTnrOat57Ji2vY5aPH
	 vB+AyOfmA/WUgHZu5fi6lv3g1foWIBcBNJWoE1LCCNA8fZ8pqCzDr00OUf52r+jj2N
	 pu34W0G6ngx4A==
Message-ID: <7b2f7f85-4790-4eeb-adea-6ff1d399bd28@kernel.org>
Date: Thu, 11 Dec 2025 02:58:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/4] mm/hugetlb: fix two comments related to
 huge_pmd_unshare()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>, Laurence Oberman <loberman@redhat.com>,
 Prakash Sangappa <prakash.sangappa@oracle.com>,
 Nadav Amit <nadav.amit@gmail.com>, Liu Shixin <liushixin2@huawei.com>
References: <20251205213558.2980480-1-david@kernel.org>
 <20251205213558.2980480-3-david@kernel.org>
 <834ec5ca-d43c-441d-a10b-ea268333e433@lucifer.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <834ec5ca-d43c-441d-a10b-ea268333e433@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AAE0112000C
X-Rspamd-Server: rspam10
X-Stat-Signature: bhbabqodhhoey6gs84ywczyz65oxcc99
X-HE-Tag: 1765418339-98988
X-HE-Meta: U2FsdGVkX1/i70XIbhhvxyjbgAu9Ef9NOJxMqZN9IG+2gc6Ly4YFo0A5M4V/Sv4pmkq6iwOU75I5TromPeSSb7vc0Cg/kt/Y8niOmMYcqN6909PV5QthDUlgSFm4M3N2+ddsLJ+s9y3O6P/FNfjqywNGPCokGGiXvaPcxZ9g8/TRTRAWV4U4/tuce1XN/qOsEddxfeJTBSLNPaw3stNltjx+NNvKEuDH86BLxbgu4hrImQS4CGViMSr6gX3ufdnPrM+ie/5BYu6ZfriTX1NtcM52NeZxOeChBUJaDK81EMaqCi3ztJF+rKedtqGfABUg5HKK7dcVSp0N8Lvo6DBuOOiLiwREGxjcPhUT0DMM/ajjXhOqhKNBpEzbtTXlnA/jQQOp448JuHtVM/yp30zS7ckLZkxryFMuABtpghNmYG5XAAPjE0baZRhhnXKEmwE30HhAh28jAmM6HNAZvG900IsIBSsDCMaSYtX+wG8wEe4mYWz2H47d6mRdwGG9ckLaCBXt2jgQ3s3FUTZHTJQpDmhp8hkeM2QiRTAwMNA2XnF0cE742khiFAecLjUHoDUJVTJ1q/z93ONFTGK2O315o5m2TCICPy4+R8YKtTWQOTWLmUals2FxYCvyuigj9w+Q5JIai7PbhYLrwrWUw/qdcjyM3Y5iEEN78a7dWd3Awz5abiAt0LsbqnCqgilmlOl3xfb84D4b55EYe6S8cHKUFfd3R0K1QU700BHga4Qepoe6SxGPJVSpGLMd+gR/GMiz8DW6E7oPkm5gJcvpBS5ZG8074YtwkRwbfGr2vFNlhhMtgPnes9z6Dp0id3LhvAkfrd3M7bMLnMb6J3TA/iIdpLej0kHPo3PeZWmNk70WvdoeTA8uFBT8mvavb2hU3ZP/MikMN0ZSoM1PjWLE4mz6AX0OWt6IBVQ0w3lc/oi5mfx+z8mKgdnTSmnE+L8ntFuZOOacDOGP53Y1f7autI2
 FXAtKJ/w
 tOYHrVNwCket1Zp+CFz3+RmAxMaGhkDbTCa7OdgN+StSCW07OwbpFRZRE/xGNclJXqD7nPqm1YSz6+8EbV4FpqHPnzuTU39SFG8PWOthHcifGL8bfb20JFZ+Ri1b9Ldtg2oJ91DWuAchU3FA+INWcs8XTchJ5yTFpLw58vSckYJ2dw9kFozvo7hDbEJ3xHumeuuPrqIeEBOfDZT2fHkZNwMqcQ/kRM5T9fwowe4HlK7mDgT9+e2Td8+1J1pDyBsLHJ9Zh9fgtX3A77rlwywYm7UcvL3S/qns0TLfqrDuxXhjXfGhU7/vosc6r0IkeEzHqCXRpfKtk0k1x8yA8JasgwYuFUSlIEoOdXbpC7PV+zNqt1pR0nNqbaDwpWHLVC+fd6FcE/TUwWseRgu3b4blFMwNKwz3AZbATiFzZqG/e3aoI2rkEuBJWNz/lGJR92Eqep4/Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/10/25 12:22, Lorenzo Stoakes wrote:
> On Fri, Dec 05, 2025 at 10:35:56PM +0100, David Hildenbrand (Red Hat) wrote:
>> Ever since we stopped using the page count to detect shared PMD
>> page tables, these comments are outdated.
>>
>> The only reason we have to flush the TLB early is because once we drop
>> the i_mmap_rwsem, the previously shared page table could get freed (to
>> then get reallocated and used for other purpose). So we really have to
>> flush the TLB before that could happen.
>>
>> So let's simplify the comments a bit.
>>
>> The "If we unshared PMDs, the TLB flush was not recorded in mmu_gather."
>> part introduced as in commit a4a118f2eead ("hugetlbfs: flush TLBs
>> correctly after huge_pmd_unshare") was confusing: sure it is recorded
>> in the mmu_gather, otherwise tlb_flush_mmu_tlbonly() wouldn't do
>> anything. So let's drop that comment while at it as well.
>>
>> We'll centralize these comments in a single helper as we rework the code
>> next.
>>
>> Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
>> Cc: Liu Shixin <liushixin2@huawei.com>
>> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
> 
> LGTM, so:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thanks!

> 
>> ---
>>   mm/hugetlb.c | 24 ++++++++----------------
>>   1 file changed, 8 insertions(+), 16 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 51273baec9e5d..3c77cdef12a32 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -5304,17 +5304,10 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>   	tlb_end_vma(tlb, vma);
>>
>>   	/*
>> -	 * If we unshared PMDs, the TLB flush was not recorded in mmu_gather. We
>> -	 * could defer the flush until now, since by holding i_mmap_rwsem we
>> -	 * guaranteed that the last reference would not be dropped. But we must
>> -	 * do the flushing before we return, as otherwise i_mmap_rwsem will be
>> -	 * dropped and the last reference to the shared PMDs page might be
>> -	 * dropped as well.
>> -	 *
>> -	 * In theory we could defer the freeing of the PMD pages as well, but
>> -	 * huge_pmd_unshare() relies on the exact page_count for the PMD page to
>> -	 * detect sharing, so we cannot defer the release of the page either.
> 
> Was it this comment that led you to question the page_count issue? :)

Heh, no, I know about the changed handling already. I stumbled over the 
page_count() remaining usage while working on some cleanups I previously 
had as part of this series :)

-- 
Cheers

David

