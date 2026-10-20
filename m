Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32D9A606A332
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 08:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XEHHg9Ol
Received: by kanga.kvack.org (Postfix)
	id 42E036B0142; Tue, 20 Oct 2026 04:37:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 390CF6B0442; Tue, 20 Oct 2026 04:37:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20BD76B044D; Tue, 20 Oct 2026 04:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D29D06B0142
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:37:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 63DC6408FA
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:37:04 +0000 (UTC)
X-FDA: 85342349568.03.7818FED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 864F216000A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:37:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XEHHg9Ol;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792485422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WcS40+UCUrjVpcC++oCr3nHQbVKlVGoZMIffrsu1aX4=;
	b=jLs3Cz9mK7RcyQCMp27AZe7/rN90KcLRetyuKF5drnLrG6dy4LWCYeLZ0OvP+CTuxPMGeW
	lKlyu3pSIKaluDFq/fHMN2+DYixU2pxq5avuUaSNShvAeXb2SOPKmmQXVGAI2ZfBB5mQfZ
	QgRMpj4U1aifpPSlB1//y1ggN1n6ruY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XEHHg9Ol;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792485422;
	b=XnpeUJ4QtUBg7ENzp3zXZiDYNpCX43bmcXdG8hc/5U4AP+c/JXHhtLMRplUtR6dVvSYvIy
	SF+1al9NNGo4Vfm/SQo1FIECNMt4ZYYDdQCs0BS15MuqHbphe8QavVNIy2HG7SeN79pTzh
	RwjBdEBDhGH1Iey5R78xuXpk01T7rHU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C25FB405E0;
	Tue, 20 Oct 2026 08:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E8A1F000C5;
	Tue, 20 Oct 2026 08:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792485421;
	bh=WcS40+UCUrjVpcC++oCr3nHQbVKlVGoZMIffrsu1aX4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XEHHg9Olk8StMgpraNq127BzFNi/fUtG6knLn7JfC/DIIYj418LHGLGaldG/k5Cox
	 Udr65vKEX5iR/OlUG+u6a+t/7JdsbjIpal8l1bfauGXlIkkzMTRvj4iX7B6VmupVX+
	 vH55Bc8apWD8dw7+S4ufMPNujjoBbNYjAV1THtlb+eqsLoQ0/hQFam4webHHUvT0TV
	 WgdPEJvMaFedzZtA/35anUHrSww7oJ//dvAwF1CtpHi4OgshSHp7O7jXhlXTTGP+2F
	 WrViVsQuS1IWxdbJq234SGfdSPvuW2Y1KbJQrWnLFpz8DLrawVjzlkXsELS0Ta4kxK
	 mLgMf5TVBTFaw==
Message-ID: <938e215b-a2fd-4f1a-b4c5-e46b8af0f00b@kernel.org>
Date: Tue, 20 Oct 2026 10:36:56 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: memory: fix truncation removing mapped folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev, jack@suse.cz,
 pfalcato@suse.de, ayushr@modal.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <542c97482eae84f86704bcee56482633d1b32321.1791616645.git.baolin.wang@linux.alibaba.com>
 <8245424a-f068-4be5-9e58-713cbff1f8ae@kernel.org>
 <405811f5-ee36-4b3c-80d0-7dc6827ab5d4@linux.alibaba.com>
 <6660d3bb-3485-4c34-8734-3ea99df920f1@kernel.org>
 <02c9a968-92e2-49e2-bffc-74d264a5c911@linux.alibaba.com>
 <f7735584-e020-4ee1-8afb-2b5d580cfa49@kernel.org>
 <b1a9b500-0ddc-4791-9e1f-00087e367426@linux.alibaba.com>
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
In-Reply-To: <b1a9b500-0ddc-4791-9e1f-00087e367426@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 864F216000A
X-Stat-Signature: wj1gmzsno1m1sunfpkuo3wwgtgmrxr5m
X-Rspam-User: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792485422-16158
X-HE-Meta: U2FsdGVkX189eeeiKoD0OQ6cKNPVFIuQrw03i5DWEP0FcEDTottc7Iza1HZqhpWQLcRke+6K36MZv7kuz88y20mWek7d1MRGCqVYpaRwwbOFyfy1ymmFLK4du4DEn4XnRH9sJsZRxDf/IQlXNgbBAKjl8pE8gYctxRpHneUR0D3XshqTcVl7JEBsP84hxaAhlSdpUAxwMrrCUZvg8HwVa0w5uI2OPPjmNlTxd/2e/aDbZeUxOBfYxAutUXQR0fT3s1NQSqSH6K6IitQF6IDqQa+Uf1q5PxxntyblUkKru9WrbxQWpEjoaGKlebYUgIIwcfnRu6aToBsYVuO8no/goUpS9waVq4Y8RskUBlr8WZh8dm+MMy4bmtzV8V1qS6gwNzMcwrwCaurjLtYafzyn98bBEBhNP0e15ZUUCx/zr/n5+pgQa7SC6GRz5H2Ghp9ah5qc945RzmFvH/EC8XD/GcKXjidg/uhyqqFNd7bGidM9DpfNwCX9SK1J7QIE+qtbrzSoUloCsNSo7ehPec45jTf4jrO5E74TMZicUM1Uka/srdhqUtjw0NvG8++v0dUuH00AVzgMg51Mgi9Km4PIQiKdCOVsPf+WCQkZnhzKNyVsEHxV8coXt2eFpmcg1dtrbsd56kRQpAsH1Ld4ogUJZ0ZkW0h/HDvUTsB9dJj5vpmT9oDQhrOtm6rMOVFx1xzf9fEuOiKUiIIYMaokobXSZfWsTUu5Bquu87cXGoJHadaIl2EsGXVtnviWoRHhpe9YuJffRUeZ/pnyxE++8HO0l9d6Q1waBpZVX8tea33lsj/tsTs8q2NbKu9cIZIpVmEjFvfjRwDFz2nJ6hNinDa4NOWzySSmN4/xvl0B2lHI2cWVTeMmuhPWjQMbPycMBwZ9nBoouMNWiEthh+ctO7UxJ1D1eCD9UrlMzd1RTaj6TOYKgcwCb4cc7pl3V6b1KB/DVOPT++nUwiEyD8iM5jy
 XcdauUFu
 SCV3mTd//phsOfNhsaRYHlQSSltdcVboJNtXa3MzPlZZzfDmZzpPX4xgaIb05EzIuMotqpwyYAkY5xJWzV+BOqjKCt/k9l/u4zrxFzilERmgc4nlVjAy+2aJ89+udE6e9PvXOqYYYi0Z1GD+kOsCkvqWJzkaC48XmAMjopAthlQzHtmatfyEdxqr6j/MEiXAMJY3RUEekDN3zLfU2urbSV+VN3621tzHVZE53ngJQB6egst5I/FKvwJ232NF5vq8UC0wSylIniC/YsRt58wcLSDpISLp12PyX5ovj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/16/26 03:47, Baolin Wang wrote:
> 
> 
> On 10/16/26 3:00 AM, David Hildenbrand (Arm) wrote:
>> On 10/15/26 08:41, Baolin Wang wrote:
>>>
>>>
>>>
>>> Yes, I've considered that. However, implicit memory barriers give me a headache,
>>> so I ended up going with explicit memory barriers (suggested by Pedro).
>>>
>>> If you don't like memory barriers, let me re-check whether the implicit memory
>>> barriers here can ensure race safety with sync_with_folio_pmd_zap(). A
>>> simplified logic is as follows:
>>>
>>> CPU 0 (truncation)                        CPU 1 (zapping)
>>> down_read() ->Acquire A1.                pte spin_lock() ->Acquire A4
>>>                                           clear mapcount
>>>
>>>                                           pmd spin_lock() ->Acquire A5
>>>                                           clear pmd
>>>                                           pmd spin_unlock() ->Release R5
>>>
>>> if (pmd_none()) { //read pmd
>>>                                           pte spin_unlock() ->Release R4
>>>      pmd spin_lock() ->Acquire A2
>>>      pmd spin_unlock() ->Release R2
>>> }
>>> up_read() -> Release R1
>>>
>>> spin_lock(y) ->Acquire A3
>>> folio_mapped() // read mapcount
>>> spin_unlock(y) ->Release R3
>>>
>>> CPU 0 constraints:
>>> 1. R2 is a release, so "read pmd" completes before R2.
>>> 2. A2 completes before A3 (ACQUIRE vs ACQUIRE).
>>> 3. "read mapcount" completes after A3, hence after A2.
>>>
>>> CPU 1 constraints:
>>> 1. R5 is a release. Both "clear mapcount" and "clear pmd" complete before R5.
>>>
>>> According to above constraints, if CPU0 sees pmd_none() caused by CPU1's clear
>>> pmd, and CPU0 then acquires the same pmd lock released by CPU1 at R5, then
>>> CPU1's clear mapcount happens before CPU0's later folio_mapped().
>>>
>>> Therefore folio_mapped() is guaranteed not to read the old mapcount in this
>>> case. So I think sync_with_folio_pmd_zap() can work, but needs a small change to
>>> avoid the double pmd_none() check.
>>
>>
>> I'd be okay with some (follow-up?) memory barrier handling inside
>> sync_with_folio_pmd_zap(), for example, based on the folio size and with proper
>> documentation why we need the PT lock in one case and why the memory barrier is
>> ok in the other case.
> 
> I'm afraid that we can't fit all the memory barriers into
> sync_with_folio_pmd_zap(). As the current patch does, we need memory barriers on
> both the writer and reader sides.

Obviously only the reader-side one would go in there.

[...]

>>>                  if (pmd_none(*pmd)) {
>>> +                       if (details && details->single_folio)
>>> +                               sync_with_folio_pmd_zap(tlb->mm, pmd);
>>>                          addr = next;
>>>                          continue;
>>>                  }
>>
>> We do have another sync_with_folio_pmd_zap() user in page_vma_mapped_walk(),
>> does that one need care as well?
> 
> Good point. But I don't want to add page_vma_mapped_walk() changes into this fix
> patch. I need to analyze all callers of page_vma_mapped_walk() and the potential
> races. I'll look into whether it should be changed in a follow-up patch.

Yes, please have a look. I am 99.9% sure that we face the exact same issue there
as well.

-- 
Cheers,

David

