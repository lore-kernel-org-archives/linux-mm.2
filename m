Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14995C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 18:46:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C646F6B007B; Mon, 20 Jul 2026 14:46:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C158B6B008A; Mon, 20 Jul 2026 14:46:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADF7C6B008C; Mon, 20 Jul 2026 14:46:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 876606B007B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:46:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EBED41C02B7
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:46:45 +0000 (UTC)
X-FDA: 85010036370.30.DB9B6F1
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id 770BA160004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:46:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=waT3i14d;
	spf=pass (imf08.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784573204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OOPh5TJ7QQOTxu69DpiTtyBt1SBHPlcquVGb26F3iFg=;
	b=fiG+k15LBS/agwidpu8SYX+NwypGETHBEVKAATUEGlNvvR6Xg6HW/pqhUV9iO2yDOty9Cl
	0UDgjh92Ec4csYN71jhQEohF56/oJxUfLZswpD+q+PAKSylBt0NWhdPs3HMRVkaKgrh/kl
	MWuGhHTvEE68wIgfAnt8Y3icuTxePME=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784573204;
	b=UZYKAK7u5zKKm7MZ9ip8ybY6qnhw++eMT/Mq2A30yB09k2aOCR6uLnyGfwUkM7kLkh2KZi
	pofolA9WksvBylwYr1nGScq4w0Uqe3SvSAAn2lIXLmkqB5xU6KWN1uR8u18LsdEzLiZ1cX
	gDVrhOWFox9hPKg6F7LrzUanYJwcon0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=waT3i14d;
	spf=pass (imf08.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <e9703d2e-f815-4d96-b5ce-074aba281f76@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784573201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OOPh5TJ7QQOTxu69DpiTtyBt1SBHPlcquVGb26F3iFg=;
	b=waT3i14dwG8syaSu1aqMzUR8+Dpb70cNQeB16/5E+TQ2yjhDoAHJgRhg4Sfiv74p+QgSPw
	6uRBAFyBEe8+H2am6f34vBbmlpEkpWR/Wv2qaWCBCh1bDZl7pp4RZkKQpsDaVd+VqVWIHk
	9Xa39pley9bMBExsI065/Ic4TQoqxwY=
Date: Mon, 20 Jul 2026 19:46:27 +0100
MIME-Version: 1.0
Subject: Re: [PATCH RFC v3 2/6] riscv/mm: add untagged_addr_remote_unlocked()
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 kernel-team@meta.com, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, linux-riscv@lists.infradead.org
References: <20260720115741.239657-1-usama.arif@linux.dev>
 <13ec2603d5cbfdc493939f182b71e5133c26af54.camel@surriel.com>
 <46dc1b58-f2de-492a-9da5-a5c429c19a10@linux.dev>
 <51c0025d2eb885ff1f4775e4d9ffcf34f478f378.camel@surriel.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <51c0025d2eb885ff1f4775e4d9ffcf34f478f378.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 770BA160004
X-Stat-Signature: iuqy9gqaa1jtxhtf981rpbrcsa5yo4zk
X-Rspam-User: 
X-HE-Tag: 1784573203-376630
X-HE-Meta: U2FsdGVkX19WAkGE0NHPWVt/VuZZYTy0Gbm17e9GqRtWJVSXdNSPlEc1M3vcQMYqRqQXDbzpt2QJ2PATq99BjQ8tLoYe4eUd3/2fzRE+aEXofM4MRX11F/qOJZCVjq2Ox6kKZf7F9JUqk242k+HBaO+QL+3Xt8wE2lQWsBVfGJxb/gS7/vjpu0PXzhj0RLYgeVuR9N/loRh7Yuj5g/+IwyLIkp3A0tsiCs5H/AH9YzvrRcdzP+56ZkOvh+8H0OP7rANj6HzyWbLjM2fC7TpqJd7aT+4yKx6EMVYMGHK5RykylCLtIyxvDxUE3NSab42oeMGCtqjYVH2jm2uCIev0W5iU4tnh/0wzXacgjNQFhFnmma2d4dpdatSdfdTA5twae6WwFEN38KxnCjZiLP/3m/IYxW9JX+dF9zJQyK7QuypgmXhytM9vdYP7fFXUFEJAZgMDcxJs5N00mlFgSPaInMAGuSa2G+OxDRpOaz7+V9Fr6ICUj/TmHlU2Mp+yDVpL67CTt9YOOLLNfuJpuAbxtvwU8e/FiOb7vlS0REfy/3nFLO4EmhfLHTju98PcptrkaL23cwjY12QVoKJRVAdUUSmEyu0tUmu5vOzzZySkijJwxy9w9S3mQA8FgDHQnpKi4Lx7FPjwZDX0Xme2Q/49cyWWIOeKIkEkVQWw7++yWCIdCyuCKHH5Lyv6jDCWJS5NNe11dtSR06OQdURSeYTqIOGQbN3XZ3UaurMoHMSN8AzyotSbtle2t4BKpcRRwjmEkzReFnGPgoIOe0da90dE/Uf7KLj+i4hPEPiCah2fdE+3IZNU+0JXpChkcS/GILlrnB+zgoJpbJDL+X5XDTCbdLJ0nVJEJYsqGvM+aMa8Rodqpp5fGZ8JXeY0e/VlWYtzuX2ehdYu2jq3nxU++A03DXXvO382VFjBleKS8VSgMiHpII+fefUtdOWhOq0Xroc7ovSVympU5UMw6kYf6lV
 JphyHFv2
 s5AA6sdplASQfqxz1Wn7D7x+hmqm5NukZTfTHH8qaiUMtve7ZXGFZ3tcRJRPIyFNH8o22jeugYZN+Syi2ZfZvmZmPxgU3jvmWfOQB+qjTUqJp9PEXCM4gOdnEgNLVkwugpiYwSnPt5BM3t06iL8MhFuSIcOfvgmuXcGXfNRsYDN9OVk4QdyctFKfESgSXap4VwRvjP/CCopf/duXfI5rv6kjbUlVEgqhjQbsFqwN2nTHhJf0a1YW5y/e4e2Z7rMdpMWl6OGlMrWPBb2YHzx5k7FZzq5Tsp1wOqL507XJAo2FemSHEmKfNhTdzlMi1ZeAm+0IS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 20/07/2026 18:34, Rik van Riel wrote:
> On Mon, 2026-07-20 at 17:46 +0100, Usama Arif wrote:
>>
>>
>> On 20/07/2026 16:08, Rik van Riel wrote:
>>> On Mon, 2026-07-20 at 04:57 -0700, Usama Arif wrote:
>>>> On Fri, 17 Jul 2026 13:00:32 -0400 Rik van Riel
>>>> <riel@surriel.com>
>>>> wrote:
>>>>
>>>>
>>>>>
>>>>> mm->context.pmlen is set only through PR_SET_TAGGED_ADDR_CTRL
>>>>> and
>>>>> is stable
>>>>> afterwards, so it can be read without the mmap lock, as it
>>>>> already
>>>>> is from
>>>>> untagged_addr() and mm_untag_mask().
>>>>>
>>>>
>>>> I think it might not be stable? set_tagged_addr_ctrl() can change
>>>> it
>>>> repeatedly until a CLONE_VM operation sets MM_CONTEXT_LOCK_PMLEN.
>>>
>>> You're right, ARM tagged addresses seem to work a
>>
>> ah do you mean RISCV here?
> 
> Ugh, I looked at the wrong one.  RISCV is like
> x86, with a dynamic (though a limited number
> of options?) mask.
> 
> Having said that, won't a process have all of
> its VMAs in the masked-off area, so coming in
> from a remote process to a valid memory address
> should already give us a valid address?
> 

So my understanding from exploring this code is, and hopefully someone
in CC from riscv can correct me, for example:

Tagged pointer:  0xabcd000012345678
PMLEN 16:        0x0000000012345678
PMLEN 7:         0xffcd000012345678

The target VMA might be at 0x12345678, but applying PMLEN 7
to that tagged pointer does not produce that address.

Previously, the order was:

Take mmap read lock.
Read pmlen.
Untag the address.
Look up the VMA.

Changing PMLEN takes the mmap write lock. The read and write
operations were therefore serialized.

The new order is:

Read pmlen without mmap lock.
Untag the address.
Attempt the per-VMA lookup.
Possibly take mmap lock later.
Continue using the already-untagged address.

A concurrent PMLEN change can occur between those operations?



