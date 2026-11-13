Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB0CE606A327
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 20:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TkRewpdm
Received: by kanga.kvack.org (Postfix)
	id 63F5F6B05B8; Fri, 13 Nov 2026 15:43:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 617C86B05B9; Fri, 13 Nov 2026 15:43:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52DCB6B05BA; Fri, 13 Nov 2026 15:43:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1594A6B05B8
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:43:26 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0FCBDA01DE
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:43:25 +0000 (UTC)
X-FDA: 85431271170.14.C26A7BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3745740011
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:43:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TkRewpdm;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794602603;
	b=8jZnk6KHCzXHS/OyurJK2L8SJ9LoSqOR1JB5lZ09fvat9Jy9q0K1PYpHctUgczSam1VuWa
	eblLf0Q+Fot7SJE7RPiUhgYmMf4iBx3UvAEEO7kxckttuL/A/ph3/6n2tqhxUMFeIKl6y0
	6SO7V3gTl7CDxPsbS9ilj5FdJyegzhY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TkRewpdm;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794602603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WQVMt8UwvudH8TaHQHEsYhCm9PnCiBATdVeZIT82eUQ=;
	b=tIuokvZmXl1AhlQ5kDa9DHzNXs1ruvFNrP6UxISoxIv7daJBMEJr+FF5a2ycL42pr6oPLX
	wNnBvivaAjKPxEbe/BHdoK3EWhPoS+iYdMk5k3INCbkfPkGVZFKvK1Q2MZTd13kjuB70qa
	eVqsQHhJXidbXvMJ4LxSO5JNZE7wJY8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A0B04173A;
	Fri, 13 Nov 2026 20:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EA11F000C4;
	Fri, 13 Nov 2026 20:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794602602;
	bh=WQVMt8UwvudH8TaHQHEsYhCm9PnCiBATdVeZIT82eUQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TkRewpdmKQquXBoRiB+TY45EdHLGle0SIIFE7N0XtJ8UJ+njGsrFBuXf7wIV9Wq5O
	 PFWu5Y/6MrdjcwDhZQr+B6T+281YWMlvsxFeU3TukSYVVaubSLlv5Qv0hfMEwvb1nK
	 zRfTN5X2fenTOiNVY/H9HTepeu4jRReizTn9d2TUUFLlr+KsxB3CkO3cUUgy5/SRg4
	 pgsck9UgFYqF7275Hp0SeaEL1vf9wSzeXajGi74JWJfxdmQ9d1k0CQVO0n/7XV77hY
	 xhp/KecGEGf5xEFOM/v47zBD5NjAH/Ns2Lp1mLKiJQzVwtu0SzEyvxu4/x31IuKi2A
	 +fUql5sA5wENg==
Message-ID: <9ec3e8b9-064a-47a7-8d00-566ff371b846@kernel.org>
Date: Fri, 13 Nov 2026 21:43:17 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hmm: skip NUMA balancing on protnone faults
To: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Matthew Auld <matthew.auld@intel.com>, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 Matthew Brost <matthew.brost@intel.com>, =?UTF-8?Q?Mika_Penttil=C3=A4?=
 <mpenttil@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>
References: <20261112-numa-v1-1-ad9cbca8f49a@intel.com>
 <b32fb02a-68b4-4db9-83dd-254147dbf215@kernel.org>
 <1993e931e6a4b0cda5c04e72b1a8d5fb924f950a.camel@linux.intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <1993e931e6a4b0cda5c04e72b1a8d5fb924f950a.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zhs93rfucddsrgk4two6ubst11szuzfx
X-Rspamd-Queue-Id: 3745740011
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794602603-782645
X-HE-Meta: U2FsdGVkX19oU6ZRU58X4U1GQCXf/e+OcZdLXk+taxqe8YRJBvjRuwK17fKaPOPfNnQnFo84tBNz4IiaOwtPBUmWKbxLgaoiCDaKzWvmeEkkuhq2wCK1De9kzGLCZEzc4Rb9RZfLBshjAuRj07pfvAf7daPHke+LmDG1JdUwFr8iyXNcFlUjTeZAf75Z3jcm/4pTCLs7Cmjw+rp9N/66TjcX/RNTKiFMdUtWk9R58hnLfw/0NKi5TDoLjagQC4IKgthPafU5PzAiQhPuLeh8xIQ8LSWuTsRJ6nmtUmRoMiVGbPbWCHq4nlG0eQ2ZqWUQ6QONrGG3zhi/PcOrtBAEsdAAlg9/ixtNofpUGXcmEJNuuOf+eovD9p4uQIX79xhjiw9cjlWSRULDbBmDxq2VihkJ/WwcHKceZPlx/i+j68vDq8/nJ81k08EnCx6TB9WORqBu4H2OnxUxpKqo/5ej8V3UBtmwqnNTd0Mw5xzTjmNNEzbS2YMQCL7EyyATvYjXspE1qKTfX71lEXzqhumknff0i7UdweGd9so6RLtFEU9zC0F3ulLtJeBOIPRDwQDlnFIRO1vSlJ69Xw3BcA2VnkASdp1g7CpY0dYtbU2DH0w6hyMmr7rPqnTAieDtyTIafHN5ZSmQ9PLpW2kaeY8E0g4S01T8s3YFzI6+OY0N1/6G4W6vOxI4fUhDFsyh7/IYGK4Fo/0bZoMljf2VX7LdcfKeoAxtVUh2EEur1TrH9K3NSRtbaLyuKX4FeXIxzlvAeVslwAFAuFCbFbuadyYemVScLvNQlHr+zLz2FUm7IcWZozGOy10/6B5uB7grk6KTVR0eINluz+nd7zWLcZlT4E1fMh0TG7g9yirDGu7steOIUMvpgCWCzOaEAqzg8A/6kzPaHMbz9LILpr7dFqeDAirLCG0Z3JQ8fdgVscAJrVacOr6c/MpQFjZ+poZfsA/8TfRThJ6dNOw436u6hvk
 Z4GFMpd4
 9zbfFmK8XH+OFVV7A1lmKuN05jOLVbYqupUix0b9pLs8jhcIje7LGauX9wP2eJCV3+y5VlCM6NGyQ46gxGyDFKXF6MlrDu3xWM5skMdJC0SW/gck7DZ1nZmpf3Sg/ItvfAIhPpJTP+pZSgErlfV6+gH4LuHcfqQjQHrSe96NPE2iA/kCEL/DIDmFLtRv+iQ/SA8n6PHlfJzg9rkrRsF7HLZL8dpd6qPlRfUV1ih0vUtd0XkTVpwk1nm9Ob1mYUxs9Hy//Zu4K/Ad2iWqTMLD01MW8ht6biaWLfBjX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 21:34, Thomas Hellström wrote:
> Hi, David
> 
> On Fri, 2026-11-13 at 19:27 +0100, David Hildenbrand (Arm) wrote:
>> On 11/13/26 17:25, Matthew Auld wrote:
>>> When automatic NUMA balancing marks a PTE or PMD as protnone
>>> (PAGE_NONE), hmm_pte_need_fault() requests a fault to restore
>>> access
>>> permissions, including _PAGE_RW when write access is needed.
>>>
>>> Calling handle_mm_fault() from hmm_do_fault() currently triggers
>>> NUMA
>>> balancing in do_numa_page() and do_huge_pmd_numa_page(). When
>>> hmm_range_fault() runs from a device driver or kworker context
>>> (such as
>>> a GPU SVM or userptr rebind worker), folios get migrated toward the
>>> CPU
>>> node executing the remote fault.
>>>
>>> Also, each folio migration invokes try_to_migrate_one() ->
>>> mmu_notifier_invalidate_range_start(), which invalidates the
>>> caller's mmu_interval_notifier while holding mmap_lock. That causes
>>> hmm_range_fault() to abort with -EBUSY after every 2 MiB PMD and
>>> exhaust
>>> its retry timeout on large buffers, which has been observed with
>>> large
>>> imported Xe userptr buffers.
>>>
>>> Add FAULT_FLAG_NO_NUMA and set it in hmm_do_fault() so protnone
>>> entries
>>> restore PTE/PMD permissions in-place without performing NUMA
>>> balancing,
>>> matching GUP's default !FOLL_HONOR_NUMA_FAULT behaviour.
>>
>> Ehm, that's not how it works.
>>
>> GUP will not trigger a "special" fault and will try not triggering a
>> fault and
>> not restore permissions.
>>
>> It will try continuing, leaving the protnone pte as it is.
>>
>> See gup_can_follow_protnone().
>>
>> For read-only access that should always work.
>>
>> For write-access we always trigger an ordinary fault and do NUMA
>> migration etc.
>>
>>
>> So FAULT_FLAG_NO_NUMA is doing something completely different and I
>> don't agree
>> with it.
>>
> 
> There are two major problems with the current behaviour.
> 
> 1) The work item executing hmm_range_fault() might have no affinity at
> all to the GPU about to access the memory.
> 
> 2) If migration happens, then hmm_range_fault() will stop and retry
> leading to excessive execution time.
> 
> While perhaps Matt's commit message doesn't correctly describe the GUP
> behaviour, do you have any alternative suggestion than to avoid
> migration in this case? I think it's a reasonable idea given the
> problems with the current code?

Adding fault reasons that hack around NUMA hinting such that a actual CPU
accessing it later will not trigger ... NUMA hinting?

I might be missing the "reasonable" in here :P

I recall that John (cc) kept saying "GPUs and NUMA balancing is inherently
incompatible, you have to disable NUMA balancing".

You could likely implement something similar to GUP, where you would allow for
bypassing protnone for reading.

That wouldn't give you access to the writing side. There might be ways to sort
out some of the writing (similar to FOLL_FORCE handling in GUP), but I'd rather
not go down that path. KVM also doesn't seem to need that.

-- 
Cheers,

David

