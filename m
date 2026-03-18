Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 475D5107760E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 19:48:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 681976B02F3; Wed, 18 Mar 2026 15:48:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 633266B02F4; Wed, 18 Mar 2026 15:48:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 521536B02F5; Wed, 18 Mar 2026 15:48:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 419336B02F3
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:48:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85B8DB61DA
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:48:50 +0000 (UTC)
X-FDA: 84560221620.25.F2D4F28
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9F77C4000F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:48:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dv40bhex;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773863328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NxmFgQ7fpSbpYBA/CZoKc2PPWfJXsxgHGKaxUKx8vjk=;
	b=K6WRRQDU7grE4viUKsqPoEHlGwKUJOmZviGpOafZtsiryptvzSH4kLDKYnCeCojYFILuPS
	RVg96nJj8oKopIP1RBOQHLcxyRI9EzaoL2hWqFH4A5f8xjDOd6EL3sS/Egob5pDiDoMZBy
	yh6T/OqiErHAT6YaAaYtJfXiVVMSiP0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773863328; a=rsa-sha256;
	cv=none;
	b=QZvWUY8GLrs39GQiL8PQuOIN6WO5xPugtt3CgmvpPk35EuiVf0LsztVy2BjF085t4PkmQd
	nD86aUY4pdRrOgRrMoUDf2LDTdVgv+4C+NhZrwTvfpV+3qT+n18l1smI46oGx31LWYqO8Z
	l4bXk40PPdB9Pso8ocA9/t76bnvql04=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dv40bhex;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E97040532;
	Wed, 18 Mar 2026 19:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C42BC19421;
	Wed, 18 Mar 2026 19:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773863327;
	bh=ro1ebNHdPGXGwrEPD80l5QdBY7tZbfdbxOa/h+jJXaw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Dv40bhexuQMuZDLtQm7he+mWmyxt193jYRqlC6QBz2puRXJzfLOClDBMF03eOc0UG
	 F2CSjew52zK9+MNmUNjFrro4uN/L6kzCnWcbwr93swceQTuKypMchzHD61opvYq1y3
	 AsSg9CM9rpAN/dHK6e/EkqB77RTVA9qK3h0WBUfh3IEy5myp6AEIlB3MMROVCrA71x
	 1uT/WWFOkbtjRtN8Eu6oouvUoQmFOK5YjhF0oujTFJm2iAUkMhnkGizS3f8HI0OV1M
	 HlDzgTt2SxWLnKuloDAzgwJQJSygqEcRnbP1QkaLkJv7pqj+d4B3DDynmCJntAe8XG
	 E7MP8Kj4SwThA==
Message-ID: <4774da78-8349-4eda-a09b-7248e82cb26b@kernel.org>
Date: Wed, 18 Mar 2026 20:48:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v15 11/13] mm/khugepaged: avoid unnecessary
 mTHP collapse attempts
To: Nico Pache <npache@redhat.com>, "Lorenzo Stoakes (Oracle)"
 <ljs@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260226031741.230674-1-npache@redhat.com>
 <20260226032631.234234-1-npache@redhat.com>
 <d8028d32-4791-4993-aae3-66506bf6d1bd@lucifer.local>
 <a9ddfa7b-5ee4-4c68-bac0-8a0c6c355bf7@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <a9ddfa7b-5ee4-4c68-bac0-8a0c6c355bf7@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9F77C4000F
X-Stat-Signature: rt1doztg84cf88go1im37y6b7ryigkih
X-Rspam-User: 
X-HE-Tag: 1773863328-780380
X-HE-Meta: U2FsdGVkX19o8LJPa7ds9fDtezSWjtEdelaURuxqFLvY3EazUUXyjO7vbeNqXst8Gcf+Rp+olGlGY4D4N/lf211XOEhgTpvYoNqLyeSbfsW1RCaNAzpt0PbG3Beo909zvGc39bG0img0U4xgwUHATfRyAOlf3tmLiQpuPtJ7lRMp1snV+3hnJyLmHf77mdiw95VJkH7bFMJrRTpP9Hk5YiXv+HonR9raLZlaHiajzpymYTw6j9Zh1lBvS2llXBNY6YCGihymoq6F6V9Ze/86Xn6PmQN9vPqSK/GpVdlNGexk/Bb0vhaVXN9ezt3yerlvPNaSGqz7a0HYpKtcw715XPzB06e/UMo04RqyEg/xsMbsVe1TAxOIQoNPoBHU1NyBsDAbXDmbjk1k3Q8WWjNtaYfqvdaqO0O5YD9tFLAQbRZAEIYTHinhnsb6xd5jdG6yMVA1Jb+Hqt0cuHT8ZlwtiM5d1nkmi/jl5oldN/eoFiDxpEPMO8Rw7Vri4dj6NsgqP5/CgTLTfFXb3GpmEQvU+0wcIRXxnswCNIFmsctygDC7op0G1odtIJZxbF+rGR3EFauH9xeBCaCo/jgSToouvqNruyzVvOYjk07ziCKFfuZPHf9JsGoy2Wi+AoSLOS00Qw/sDavIJjTZ9z0zjiZJvAQ0V1ItoZJ317ukgpv0mgq1/hUKI0jIT9Ip4rIS+2vKgVKlMho8VzzCZi90orACcBhE/Hs0v2konuhkcFuzAaR2TlTV3h8cCIluYkunaxt3QgI3IoUYALPiYCGkZHetq7JOd3qmDkD6kYqCriSMpQVvBWDKwyhwVHMVaYLssGVwlHOOKZHEXxNDUq6gAC7eBRfwF5CYcMWJjU8ZocUTIfuznxvpTOrJF2dq5sFhM6bmdrAqNx2yC5L3CnMSFebwCYazDKCJegP3b6E+w5wgkxYbQ2ksKzmyz3VWCawJubFEr0tYV3jxADMRt0Bns8e
 tnNb4t9a
 imFGKvVBNMsKOWDzHOizwUPLMpYdmS+uENTXdqERp4JiMbwVJc3u5Z1Wbmy1KpZDABwMfe4uFjzRgp9RSQIiCKyGeGsCON8pZEYzwJD50dhqPwg2jGjoMsDb20r+fAS01W6oLorBiFnIafs4XGgZQ8KxLqY+a/MQOsCPryIVRi+YUVCf9VsyBmuX6ICe/FwD69DJc3eIU95VRJZ4wWKuU9UTK3wAopkq8RnoBfpx5NhYQsAOJD0nhd4nB4gCWwmLwLFtshBjo0+H/1boExLhjSmVt63NjSduWAHAWNMoD3tGK2jtNN+3jjr0FQBR19WtQ0QyjGvR1TLis1b14j8HLDu3BuH2WcImUrP7NKqfrWPVwqc4VNPJTHIYcBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 19:59, Nico Pache wrote:
> 
> 
> On 3/17/26 4:35 AM, Lorenzo Stoakes (Oracle) wrote:
>> On Wed, Feb 25, 2026 at 08:26:31PM -0700, Nico Pache wrote:
>>> There are cases where, if an attempted collapse fails, all subsequent
>>> orders are guaranteed to also fail. Avoid these collapse attempts by
>>> bailing out early.
>>>
>>> Signed-off-by: Nico Pache <npache@redhat.com>
>>
>> With David's concern addressed:
>>
>> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>>
>>> ---
>>>  mm/khugepaged.c | 35 ++++++++++++++++++++++++++++++++++-
>>>  1 file changed, 34 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 1c3711ed4513..388d3f2537e2 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -1492,9 +1492,42 @@ static int mthp_collapse(struct mm_struct *mm, unsigned long address,
>>>  			ret = collapse_huge_page(mm, collapse_address, referenced,
>>>  						 unmapped, cc, mmap_locked,
>>>  						 order);
>>> -			if (ret == SCAN_SUCCEED) {
>>> +
>>> +			switch (ret) {
>>> +			/* Cases were we continue to next collapse candidate */
>>> +			case SCAN_SUCCEED:
>>>  				collapsed += nr_pte_entries;
>>> +				fallthrough;
>>> +			case SCAN_PTE_MAPPED_HUGEPAGE:
>>>  				continue;
>>> +			/* Cases were lower orders might still succeed */
>>> +			case SCAN_LACK_REFERENCED_PAGE:
>>> +			case SCAN_EXCEED_NONE_PTE:
>>> +			case SCAN_EXCEED_SWAP_PTE:
>>> +			case SCAN_EXCEED_SHARED_PTE:
>>> +			case SCAN_PAGE_LOCK:
>>> +			case SCAN_PAGE_COUNT:
>>> +			case SCAN_PAGE_LRU:
>>> +			case SCAN_PAGE_NULL:
>>> +			case SCAN_DEL_PAGE_LRU:
>>> +			case SCAN_PTE_NON_PRESENT:
>>> +			case SCAN_PTE_UFFD_WP:
>>> +			case SCAN_ALLOC_HUGE_PAGE_FAIL:
>>> +				goto next_order;
>>> +			/* Cases were no further collapse is possible */
>>> +			case SCAN_CGROUP_CHARGE_FAIL:
>>> +			case SCAN_COPY_MC:
>>> +			case SCAN_ADDRESS_RANGE:
>>> +			case SCAN_NO_PTE_TABLE:
>>> +			case SCAN_ANY_PROCESS:
>>> +			case SCAN_VMA_NULL:
>>> +			case SCAN_VMA_CHECK:
>>> +			case SCAN_SCAN_ABORT:
>>> +			case SCAN_PAGE_ANON:
>>> +			case SCAN_PMD_MAPPED:
>>> +			case SCAN_FAIL:
>>> +			default:
>>
>> Agree with david, let's spell them out please :)
> 
> I believe David is arguing for the opposite. To drop all these spelt out cases
> and just leave the default case.
> 
> @david is that correct or did I misunderstand that.

Either spell all out (no default) OR add a default.

I prefer to just ... use the default :)

-- 
Cheers,

David

