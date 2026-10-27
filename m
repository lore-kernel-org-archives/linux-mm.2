Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43245606A33A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S0xegcMv
Received: by kanga.kvack.org (Postfix)
	id 39EFC6B0712; Tue, 27 Oct 2026 08:58:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34F516B0714; Tue, 27 Oct 2026 08:58:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217FD6B0715; Tue, 27 Oct 2026 08:58:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EBB776B0712
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:58:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6649D120A51
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:58:13 +0000 (UTC)
X-FDA: 85368409266.10.AC4414B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id A43FA100006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:58:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S0xegcMv;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793105891;
	b=J1c/Q5mIUOe0/9ulZQWQfZEtgyX7Ix7kzRJXPrgu7tooVc2ObP7k5ADyib3LAvHjJv2nY7
	qrexRHBvVzjMqI6VyfFwEN9SLID2TkHqGCltYljM/b7u2X7cN7xVj6iIwpyDpu9PFFkqi8
	s9dUtUMT+bEaoaFf07MRm0hPhL1IXSE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S0xegcMv;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793105891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2qo0Fds2+mYFVrZRAJ8lmAwaqUsuanIMWx5DL5WUc/I=;
	b=K9mFvmyAd0jo7R7Ea+zLUPebD6+e9Im7SU9xXZ869O3LWHJAZgXBFY3rdKNHVi19OkyPWj
	FQp9OhQkAippX35pd9TmDrPtIEGCCNxB4IyTs7gEYvb3vVmIvXz2iK51XrjitHd9CK7qXn
	zKJbhNmYdIY7TkEN5ajjImNvJgxwt7Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F0F56021D;
	Tue, 27 Oct 2026 12:58:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C2C1F01828;
	Tue, 27 Oct 2026 12:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793105890;
	bh=2qo0Fds2+mYFVrZRAJ8lmAwaqUsuanIMWx5DL5WUc/I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=S0xegcMvB3vaMSGrnrPh/wkamJQSwPrkkfuF2Kw75WfR03KJfD4IOUdA+PcoQs7yi
	 bnTII5sJUgEX6cD/0Aj25/PTp9/yyvKS0Ycgs2qbKm9Ndj4Nwyod4OK8wlt7Q0ftYj
	 JvsWQ7XWCCRARuJNEOMACCfJiswERXgOBVaIGZMWK8T8qkv3gDmIAICof/BPyrgomE
	 LXZUoTVJ06rcHporAuBkxK1n42uq83vfPCfEvEqzKSfnh6hdPnVcYlmqeovXH1uj2m
	 IvCBH8EheSB3VwaRbprItF7Bnn2KsfKJ3u4dUXd1KrXv+NDN64O5UXb03eEZ9MfWbd
	 85NfjscKJ2WlA==
Message-ID: <1de9a768-5cb3-435b-8a36-d8b590c8a33e@kernel.org>
Date: Tue, 27 Oct 2026 13:58:01 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv7 13/18] mm: Drop fake head checks
To: Peter Zijlstra <peterz@infradead.org>, Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>
References: <20260227194302.274384-1-kas@kernel.org>
 <20260227194302.274384-14-kas@kernel.org>
 <ebc7bde1-f52e-4da8-b16f-822d6c0a4d74@kernel.org>
 <at_f43oDv73y-t7O@thinkstation>
 <f97a8d33-50b2-4a86-8381-ee840cdfa2f9@kernel.org>
 <20261027110028.GH2668564@noisy.programming.kicks-ass.net>
 <auCKv_omLGRc6wv2@thinkstation>
 <f3f3aca9-bdb7-4aec-9099-9fb63a60e61d@kernel.org>
 <auCZFckDfBMrlfxV@thinkstation>
 <20261027124716.GC2668804@noisy.programming.kicks-ass.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20261027124716.GC2668804@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ozwmznswqjb4qxfqpojko3xoye3h9ygx
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A43FA100006
X-Rspam-User: 
X-HE-Tag: 1793105891-106976
X-HE-Meta: U2FsdGVkX19jwqoyJNRpoJEyhj90lm0zofIY/rsCQGxyUrMBLA7zhbcc9pldJLl/YnPuF8WE1TwzjvGlHmP0OniSklHRcQzhHLIVmOJ0a3sSbQqaj8EpZXmlDQoEX0dFshF/oQw86MmzQFBaADi0rhrht8nhkJM74TXIHphI00uQ5AZGja40TceyhF4XmYwRTiOuJxrbuZSZKx94jcIv6e682TaxoV941+iNHP7L4GNmFkCNG94FVT0tjm2eKs9x/l74zX4lUGPpWrVV0DxtECIFqD6qOzp3WmdjvHL/IKGe0u++EwUL+gCA9nBvS7OEpzNm2jtz1zS0MQ+6F9rGhZKsHI3k9XbT6ZpgZCdeO76kxC+xHf1Hx9/IguZ2V4lYRH0YHIJiLMkAbcOPrQ9ZzL8DJlCF2cnWDlb5bTUI8Dk93GzU/jgZRcVctGeXVcwJQkBDoftZmVr60+2pu6Il74v934hckPrI/L5uy22B6N6Q/H4AZUMWzabu2/tAJB2whTYkAsaISurAt5H+eJm0Zq//ebvcMf3MXk7HYdmusplOpD6FNlUDo/i/HE1CWEt/P7tjJWxDCSoiehp5vw3E3MY9Vy5CC/UhQhb3YwJ5Xo+deIXW1dTUWqcwYEvgrsPwEmWR6cofXI/qkzWZfu3rSrfAnfbVVyhWPNXooi1smxjP9kjv5EXiYwFAuMCGOc7XcVEN21rOaKMbx28+sROVqGVqDbzWFV7889i1kUPNvSjgulEyRHYDHn7P/Wapf1EkHx+VtF4sdkSHCMRW2NiHfb7Heu7uCfJKQecmt9v5vUxfQK6my6GM9WF+WnqlOe9SnrkO/ezim5fC90bSNRxY913fQ1w9OWu2RTvQIBMvT7DDlj5W1JWxay2D5OYQ8UHWCz7pAOxoD4prUs/thSj1MzwEa3L4EQlOWdv1ZKg02cw9oFi3w4L7++H1Jt/EEu+JjWAasBw9Lf82OwtP2BT
 ZbaHyo6e
 pbEo1Re7LBpVqnkrXr44bydvEQBrSOcgFjrXd9AxXibULrLcMsLNyJRVlYxXnt94NCN0nqMQpSufj+USbL8Ys/SnI7vymi4+kzx/dSj4ekN+gCKycQSwvV+lrOV3t8irMTQX/j+kwY+x/KrPFZ9hyTCR96Mj0avv13YXTHT2jzeAni9EwY2vEvY4jeWNz4AxBaZnKxpFgC1aBc5NRx8YS/DJFU2BTJVDtDkzLXtSBDNJLMBq9bdE83jf3o5jmFEYb/cEs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 13:47, Peter Zijlstra wrote:
> On Tue, Oct 27, 2026 at 12:31:09PM +0000, Kiryl Shutsemau wrote:
>> On Tue, Oct 27, 2026 at 01:05:58PM +0100, David Hildenbrand (Arm) wrote:
>>>
>>> Right. Without HVO we would just corrupt pages in the single folio (which is
>>> also not nice).
>>>
>>> I'm also questioning whether we need this RO protection all the time active.
>>
>> What do you have in mind? RO only under a debug option, or switching the
>> tail page to RO some time after the remap?
>>
>> If it is the delay, a grace period alone does not close the race. We
>> would need rcu_read_lock() back around the get, and then it is the old
>> scheme with the wait taken off the allocation path.
> 
> So it used to be; back when Nick introduced try_get_page, that it was
> only allowed with IRQs disabled.
> 
> And looking at gup.c now, I see gup_fast_pgd_range() still has
> local_irq_save/restore around it.
> 
> So what do you need that rcu crud for?

Pagecache lookup (and other speculative page table walkers) call it as well.

Some with IRQ disabled, some with RCU, others with no protection.

-- 
Cheers,

David

