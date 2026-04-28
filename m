Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBDB7FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 07:22:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27DA36B0088; Tue, 28 Apr 2026 03:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22E7A6B008A; Tue, 28 Apr 2026 03:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11D0C6B008C; Tue, 28 Apr 2026 03:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 002F56B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:22:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B43EF1B95B7
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:22:51 +0000 (UTC)
X-FDA: 84707122542.15.038F98A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D5CFC1C0010
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:22:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j1CbOAWd;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777360970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RVmdzGrG8Hu1v1sBTVzfOUPkhhKPq/vYiEiQCyrrjsY=;
	b=TUQHJDqt9wMVAx63FReJXFs6a2S9Zl6lVkonYlr/RFWP3XYsBIVlgjKZ2+tk8JPNPC8WJQ
	8bw/KH18AugVj6FctZywVHZerX1wv2niCQWzPJTIJbWoyEahk9l0JIliKNzcuJT92D12Ut
	6+yMeJazDbLJA2TBW4LVZPnMY+7xUoQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j1CbOAWd;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777360970; a=rsa-sha256;
	cv=none;
	b=gW8w/j/GI/0tLEunDPMIQZkkheCg3sU8PJpFp6RPEyKdSb450c5NPTVlc+kk8TWZ9nc9eN
	KIW+MiFUrU4okd2ex+fzzV8CzlsCCwzYiiEOIGbiAWZY8FhKnaEbqlbXavzNMcrA54RFPD
	rPa/Jie8osCV8GWVgBemZE8+Vk/N5aU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DB9B640612;
	Tue, 28 Apr 2026 07:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B33CC2BCB5;
	Tue, 28 Apr 2026 07:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777360968;
	bh=ktIwTruvdUPR15+1BVf46NWNOvuJrHgMfoEzxe7/KDA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=j1CbOAWdTJgWDbXADf+gegoEyDq9vEtgk5f877a9NZtckD11eaWom58G6G8WEFzWK
	 9Xc5Ph618r2P/vR1MYM7xDroA72f5T/3mLgTzKNBwJ9P3g4PWGCcn+NmyAvLv6JFWP
	 9bNMrVBPr0Xvmt2JsbrRFB9qCp6sMiZIxNq31437cuLbfMN1jdonzaIYWiUUWxofyI
	 PhWcK0MmAx2dGm4Z+F091ftUojoVtq2ILnxggqIypAiRbIlF3LGQXnND2nIXs5GuWh
	 dKxdzz9KhKCq5clj3xvuwvpEANqmzxvsFCm9iQz5/5TkB2x8XTUssBGnEUaM7/WWWs
	 TbirLzXjpVIHw==
Message-ID: <63befc48-8173-4ad3-917b-e09c55dd3191@kernel.org>
Date: Tue, 28 Apr 2026 09:22:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 4/7] mm: add page consistency checker implementation
To: Sasha Levin <sashal@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, akpm@linux-foundation.org,
 corbet@lwn.net, ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 skhan@linuxfoundation.org, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Sasha Levin <sashal@nvidia.com>,
 Sanif Veeras <sveeras@nvidia.com>,
 "Claude:claude-opus-4-7" <noreply@anthropic.com>
References: <aeuFnuiYDBjttEKt@plex>
 <12985b32-88b3-47ab-8292-2e0ec6f5fbae@kernel.org> <aev-DS4YTp5soVPd@laps>
 <3146ebcf-5649-44a7-aa21-163bf404c42b@kernel.org> <aezt96xgz_qyf4d-@laps>
 <f910969d-1071-4174-bd42-da45cb6f9749@kernel.org> <ae9ucgtCNf0JQtGu@laps>
 <c50aeb03-538b-4dca-9a81-ab84bc19a333@kernel.org> <ae-xXHUGfDiFcBUk@laps>
 <36d82055-67f3-4c29-a605-a9848a28f7cb@kernel.org> <ae_wPuqYpVxicOUq@laps>
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
In-Reply-To: <ae_wPuqYpVxicOUq@laps>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D5CFC1C0010
X-Stat-Signature: f5qq8ey6taqhbbnjyucog6e75irjnkis
X-HE-Tag: 1777360969-928454
X-HE-Meta: U2FsdGVkX18nxnsIQHomj3MVc80fbNIVUibr889jaXQmZrhxEM0jvqR5xRn5VDQMysGZKqzhWzWvSWaGEWQGoekSDt60ggA2ianwD/z4urjUhbrGVg8YzCaLBvd380inK6T3QTf3bt9SKsgvId5br68vx+8EF8GT4EmyNnjMuqkhb2dYYVHTxtBMHOSirIEwJeAtB6WzlIFb8yc4Wp00PJiqi+XPko9kC+DW6eEMhL0ojO6+UTnPY7aX2f71c9G40GDJD0tpFpZZUVvhnnnaoP1dpsa7TbGPpOVuGoYXd0zfsWtzEDa5bDEzjOdShuDD6OzojFLdKjKCkiyIztrQsu1LVU27H+veuG25sDmV1JmyWkqdRBtptTSDTP2dcxnxo4/cfFc3HkvwLDzq5P/HGLKPMBDpDELTSLxnDj4C4Ro0QrfsyMR/L+Ow7J1THrm7L/vjWuacFK/Rqt4tZx4HIX9J8sQn+6zCACfkxWIUvW7jtztR3fg0WWWKcOvBLA2craLTipjk3YnfMSVfEjF4k2spOIeOsG0o2eNY6Lhpb8FyqrqhcGNU5tjTFi0qkigbf5vqZ/0OD/ZkSpSdxGPbhJvQdJIVt4ZnUOEH65OlbRFSbXNVkvO4QfN88svaGhgQLDv613xDC8rRSXkVBwysAvG2I8LpUCuZ0PzM3AJ1D1e++NYJzV4AaYkrZ5CUNRCP8++DLMHe+7lsrYDd/89BWIorvCr/VDbpU+Xh95SwVP71eBGV3SX47xVrYdTNCvnlthK/csSPFpn24FPWIlZYvNECwcDsW9bicZ+hrjGVbYJ+8qdK5u/ajWBs8u/VDeD63M1saVZiMDGh1Dj2DpgsnUsIEXvBGVfoqm38PXKbqyJg0j58OLN0EDhDxwQZKYLkGupq7IbyzxuF+0FvFnBt6ZrUhk4670j2d8AETU3R5QBn+vHBCZSR5+hIC+5i1XPDGly6uoK3irPA8tY/X33
 SLTMV9TI
 DNHTtFgoPVs6zyzouXNCt/8F0JQGXYoRBkG0mkPQ7KDenA9WxtB1uJASlgaW3ByOenjbuyggoQfVqMyfFnnFKhCGdE49nilf4mV12Ik/Tz+UPAThcye7rua7X/bM2UNXAaav7so/gwe9LDk70SeYkwhs8P1LsXN73eAnW3KZRG7nthHXMbCU/NDchmPizbR/E68J/brK4CCUdWqQ/zf8oJ/quRZjO5nxMYvbtuLHkheQhBsx2lhxbk4TAUZE0CqwBMbr/yXBMRxkI8O/de4SXjZjDtQ/FVbNicDvn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 01:24, Sasha Levin wrote:
> On Mon, Apr 27, 2026 at 09:37:02PM +0200, David Hildenbrand (Arm) wrote:
>>
>>>
>>> We do, but self driving safety requires way more than the current hardware can
>>> provide.
>>>
>>> I'll point you to https://dl.acm.org/doi/10.1145/2775054.2694348 , which
>>> researched these issues in a datacenter environment (so no sun exposure,
>>> temperature controlled, designed to avoid electromagnetic interference).
>>>
>>> "We call a fault that generates an error larger than 2 bits in an ECC word an
>>> undetectable-by-SECDED fault. A fault is undetectable-by-SECDED if it affects
>>> more than two bits in any ECC word, and the data written to that location does
>>> not match the value produced by the fault."
>>>
>>> [...]
>>>
>>> "A Cielo node has 288 DRAM devices, so this translates to 6048, 518, and 57.6
>>> FIT per node for vendors A, B, and C, respectively. This translates to one
>>> undetected error every 0.8 days, every 9.5 days, and every 85 days on a machine
>>> the size of Cielo."
>>>
>>> [...]
>>>
>>> "Our main conclusion from this data is that SEC-DED ECC is poorly suited to
>>> modern DRAM subsystems. The rate of undetected errors is too high to justify
>>> its use in very large scale systems comprised of thousands of nodes where
>>> fidelity of results is critical."
>>
>> Yes, I read before that ECC is insufficient to detect certain bitflips.
>>
>> But I don't understand how this patch set here is going to move the needle in
>> any reasonable way?
>>
>> You have your magical self-driving car algorithm.
>>
>> Bitflips can corrupt your algorithm, your data, the kernel image, your user page
>> tables, your kernel page tables. Even a pointer to a bitmap :)
>>
>> ... and we worry about the state of allocated vs. free pages.
> 
> Do we agree that this is one piece of a (much) larger puzzle that we would need
> to tackle?

Once you solved the real hard problems (corrupting random page state, page
tables, all of that) we can think about whether adding complexity to the page
allocator to detect possible corruptions.

As you state in your reply to Vlasta, the buddy keeps free pages in a list. So a
pointer corruption there would be rather fatal, and I don't follow how the
approach here makes things any better.

So for the time being, I don't think this proposal moves the needle in any
reasonable way, and I don't think we want this any time soon.

-- 
Cheers,

David

