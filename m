Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 477C8EE3695
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 15:39:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADF9E6B0089; Thu, 12 Feb 2026 10:39:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A89AD6B008A; Thu, 12 Feb 2026 10:39:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9627E6B008C; Thu, 12 Feb 2026 10:39:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8481B6B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 10:39:53 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2B69D1601A0
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:39:53 +0000 (UTC)
X-FDA: 84436215066.07.62A4ECF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5FF80160012
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:39:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dBGzJzgz;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770910791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hrQnrLZGRkouZkW9Dz1FgaKn18/yK60/HNzprFfNtmk=;
	b=K0otIemEyxE2eirL00qvj3bbw+cWjDPJSi9pVZ0uOwLz7SIi4DDmJnemQP5PWl+2sO0mnR
	hRjlpxRxwgzBSyuHLGPyluEehfQGyF9aQDg9fKKG+k4JTIqjNtJfFEx3nE3qeh1nPISS3S
	C5hVPOkl4vve3CayxbSr8FJtXv82ZsM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dBGzJzgz;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770910791; a=rsa-sha256;
	cv=none;
	b=8NhuLEDJhEVwyYvkuTPlxyKt0LpyqKLWSPZFHSw3Px0Wlycb4rOJl/mHh6oNjEXr0Vh48n
	zOrOlkRPVHypjCeDUh/PfA+24dJ7q9xMFgo0wmaz63kt0doj/As+GkTgDTr2to4z0PKHmx
	pja9Z3oEEB5TID0puCQERWOKDEqSS+w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B0E8460051;
	Thu, 12 Feb 2026 15:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2372FC4CEF7;
	Thu, 12 Feb 2026 15:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770910790;
	bh=uDJdvdtdIL8nTfRDZsIpuEy7of+XLqGVIjb1L7/IFKw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dBGzJzgzSO+9iMjTj2UNcR0sC5r8JHSYQ3uy2B6LUzNIgTfbrP8Agr6brEbN4jaw/
	 HhJ8JDU2JxGY8BLCuqt/vK04qyCcfpdhULqy6yG5QGdt46x8yPnvn3zRNQQazplva5
	 7PB6l6YMhVa1KkIWwnfuDhz9rIPfHH2xdmifCv8i6E4xXJiMAfyDkmZM/gQxXekbT4
	 wgFsMwWHmOCv0C/6By+Ou1mZyYTSgUp7hF617TVZTysJv8Wkq82MBKcVW4uURngvpA
	 3VLAwJ1kpslP/ML4/IlrdIvHlCu98UbNzd8AT2+wblgqmgQnj7GreZfIDAmHi5X1vY
	 CblqO/OqoNwHw==
Message-ID: <22d65938-4569-4e5e-8f30-bfe9b38b6493@kernel.org>
Date: Thu, 12 Feb 2026 16:39:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/2] mm: thp: allocate PTE page tables lazily at split time
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Usama Arif <usama.arif@linux.dev>, Andrew Morton
 <akpm@linux-foundation.org>, lorenzo.stoakes@oracle.com,
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <875x82ma6q.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5FF80160012
X-Stat-Signature: dz3u4h7rhq7xz7ek96dotm91im1qfqnu
X-Rspam-User: 
X-HE-Tag: 1770910791-676408
X-HE-Meta: U2FsdGVkX18P0TmQ5ZISfKjMgo7leMAvyhdAFDxQSLTKlDex0Fsm9S3ouaafRNjAiZQBvFrzLsOFYXWm1DXV/p2JUU8x8JTcS5lsOXr9zEwrR1l0bmxLgxYqj9XmvOSnYnw3saJeymg5PdQbn0BjUA+Il/k9Se0RRBwt5ZWQgAmQZ6zmZfQR94FtSio1qLN8rntvtRSUiazhn4+DU0HmhUgeyYtfgu8m0Sb7KnNK2X9JE2bMA+4ErL3fRkGWb7rqZKgmpq/XwCIW5S9P3P1XAomybzWuUgh/YNHRcnk1B4TfkyGmOg7uoQWuT+s7VDMWqgL+Hm0M0sJQNepISVXPQWgwHh9Y434/yCzC6nezAYot6Ff9YVfYy7imI4P6X59/JChIrkVg1WniPr6cU43JSSclWEneyz4czA3RRx6bR5xtCkTINpX4IBoH+NIsG2otd+xFGznaRhh0KFI7jmppPb5RBWxBbGVwM3DYehg26DrA26zsD1zO/82jMQbLzkPZl5yi7odQ9bA83up4v2CLO2pLemjt7eY0a0fJZDsuF8EfS+xuPx1lsnbevTBCQPZWjwelfka3cFzoL0oLGUdBNDPgDqPIMhJDuAG6GngXoLIfKigiEzNf5R3Y7X+wEp7WnX4p3ZKyjMKjIQMJiaKLz2GaE/kDyNI1yltnhBol8ExOXT9svtLjBAwX8Czyv7WV/Wcj8VbkdmTirqsRd8GyFaZbOwUwDm5NlIHtlHa83xTwlZgCqd8m+9N4EYLRu+2K3EleNaQRx6XaBU11Pj0aU+mrE1JBDaDcMHs+1flYacdolKOoumrRVOUtFo4KPfENRcb9bRWDRxwnXt69GpprJdYlAX0EN2wBiAq9AhAa9+v7YjLAJBovu+CrFBIxLoTMD4QhXvWnktncnRJwSWmO4dnBr9fx8yf8P5wqEuauU+dx06OxmX+196d6UY6RowIDfInUgqOU33unvVVU6CG
 Dil8CM0V
 8I12dNEE95xkt/EFYD4IyA/+Va9vNKpcHUVsw9muNENvvzGjFA6tF70d0JcHsVIlG1O3S7PQ8TlSrAfTa5xLqQHZhtC/52PkNBrmaU9rSOGH+1fOp/6h90cDrxGEP5HzjKxe8r3TN7BBc5EF8gI8SvxkDvK197TyojWqtoj+HyZpP3xVXiFMERf2mYY4bKbzyYauCZS4HUNa0yEolozk8tza8uD6LQfVTeAEhGjPoYFCDT40jWvJRTYuFAXUsxZSQjbZAuPMsp+FsWhStT/z1963HZzO59ZCMAWIrd/m2iZGyRx2Xad95E2BmbnqdGyPqZFOrS5EbjSw46Ho=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> Is there a way to remove this? It's always been a confusing hack, now
>> it's unpleasant to have around :)
>>
> 
> Hash MMU on PowerPC works fundamentally different than other MMUs
> (unlike Radix MMU on PowerPC). So yes, it requires few tricks to fit
> into the Linux's multi-level SW page table model. ;)

:)

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

Ah, did not spot this difference, but makes sense. Still ugly, but make 
sense. Fortunately it would go away with this RFC.

> 
> Doing a grep search, I think that's the same for sparc and s390 as well.

... and I also did not realize that s390x+sparc have separate 
implementations we can now get rid of as well.

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

I was expecting this answer :)

> 
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

Thanks! The series will grow quite a bit I think, so retesting new 
revisions will be very appreciated!

> 
> I guess, we should also look at removing pgtable_trans_huge_deposit() and
> pgtable_trans_huge_withdraw() implementations from s390 and sparc, since
> those too will be dead code after this.

Exactly.


-- 
Cheers,

David

