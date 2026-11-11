Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E53C606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 20:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E9fGcD86
Received: by kanga.kvack.org (Postfix)
	id 9191C6B05B1; Wed, 11 Nov 2026 15:58:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C9146B05B2; Wed, 11 Nov 2026 15:58:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B9336B05B3; Wed, 11 Nov 2026 15:58:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 550CC6B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:58:48 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E3853A7F78
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:58:47 +0000 (UTC)
X-FDA: 85424052294.20.291A2E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2A9541C0008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:58:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E9fGcD86;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794430726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ds6gjgiS3vY0BGdY0DRhZwlXVM0IcXWHW91s2wNzqW8=;
	b=Tqh1w7xKh4oW2G3Vq9sfpz7R8EmgtFkCIGdLqoZ/n/+/+EWo6ize1mHX3GtT40EXS1IWGM
	6oq9ww+LaRcVpNR+fPWGhlElMth1mHZ06Wdru2TANWMtVGKRg0qrYwKuxvjFmc3G5IO5gE
	F4CZfhfULXt1Xff1KATzHbU8VGASfMs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E9fGcD86;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794430726;
	b=SMGG+QETg3ifw+YPnpldBb3uZZy+U45TIqHfoVtgeSK1+rjO31NrqawZ8RMxdLUj6zRpra
	0bYkeWYkXpEoTUDJcINeKfn6YxSp7OtkqjQOonDnGhpIvAo6hlIKklEVkdOE8FTdLojjDQ
	pSqZU1wsLKeeMAk08d4nwbagiuleSoo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0758141397;
	Wed, 11 Nov 2026 20:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9797E1F00A05;
	Wed, 11 Nov 2026 20:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794430724;
	bh=Ds6gjgiS3vY0BGdY0DRhZwlXVM0IcXWHW91s2wNzqW8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=E9fGcD86Lx9XaWIpof0R7WUxZBmGxJ67mAfGNyxR1VMoMYLYRYiqCdyL00LjShnRG
	 70cfe5mHbIJaOOM9q5iRijQ8mzdENzfPv3fQ3OVRiqnKTb/JdmquA+tEVlZk/9AJCr
	 VC27Rtvis8BoRNO634nMCsXM+sZ6+dg5WRXuYrO4dv66qPbaAFDSjHP+Ot9FMMXqYL
	 zMsn5dgo/uBFv1zS4YgMVA7Xe94gz/jZS4h6/GH1cdyfNi3dPNvOB79WAqdOeamWSy
	 BorNP6QWpar3MvsLNku0jhe8L7Cm/mwBlttLWHXD0svE7jyliIAmGRDt6G/Tc6/kWh
	 cAV5vKYxwjCsw==
Message-ID: <4df90a0f-0bba-4899-9232-e3e968b55138@kernel.org>
Date: Wed, 11 Nov 2026 21:58:33 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory: drop PROCESS_PAGES_NON_PREEMPT_BATCH
To: "Garg, Shivank" <shivankg@amd.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "ljs@kernel.org" <ljs@kernel.org>
Cc: "Rao, Bharata Bhasker" <bharata@amd.com>,
 "rppt@kernel.org" <rppt@kernel.org>,
 "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
 "vbabka@kernel.org" <vbabka@kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "surenb@google.com" <surenb@google.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "Salunke, Hrushikesh" <Hrushikesh.Salunke@amd.com>,
 "liam@infradead.org" <liam@infradead.org>, "mhocko@suse.com"
 <mhocko@suse.com>, "bp@alien8.de" <bp@alien8.de>,
 "Nayak, K Prateek" <KPrateek.Nayak@amd.com>,
 "pfalcato@suse.de" <pfalcato@suse.de>, "x86@kernel.org" <x86@kernel.org>
References: <20261109-clear-pages-batch-v3-1-6693efe18dff@amd.com>
 <20261111124006.GI2668564@noisy.programming.kicks-ass.net>
 <avRnJiDLdGcbSW5d@gremlin>
 <20261111132105.GJ2668564@noisy.programming.kicks-ass.net>
 <261ef956af0843f414b4def58b13dae003c933ac.camel@amd.com>
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
In-Reply-To: <261ef956af0843f414b4def58b13dae003c933ac.camel@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2A9541C0008
X-Stat-Signature: ej4rh76oxhs8khwczhajmuji3p91jmnc
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794430726-48224
X-HE-Meta: U2FsdGVkX1/HpzKjcQ2OVgF/U32XWuffvMD5GNWfsoF7lWcjFookFZTt6toWKoc65Si9VTYlQjlIzjcTYpzhLgWkwQYR9ZILvdhNHuCTFGMbcDel0Vp4nTIxa+5vDlfYpbvrFtWnmi6w69cLoVel+9Rmma0A5jBYADGcd+FvQ6BPWSiYgsrbFmetP5zfnI72Uy5Q7gtyZumL37AnrZIyacbhF6vLO8T/SEEeLGpb63Jbunlh4sTldzeuey+Kc+Y8GrdLxhuI3UWo6pVIj5KFqhRo+fGt4vYZCzoFVKQTRmAOG22nSuh8uFwS/UUG4Jx6PcTVawvdl/0wdbHPfY7iVVGrj7eCHXu+qlfTWNwr+d5twJoA5/XCgFjFMPMrISB4RsgCAQIWbvEQ4kE250QxQgBoPwvF4NZB3sUZGlIkFkzgizq53NeQbLEE5CF45picqCwTnAci1HVTqK3gZBqyjUbuSYtFk4ppN92d8PcoOW4cYjofBCCo4O5kVZ85WzH3gPI4IesqI6tFu0OfBSz5qKVIyTn2UbVKMFIp7fM0gOglbR0O/q+yxTBFaCIemqkl02/FewXvaEsMdNG8AuXj2alQ2QqFZnJjrvXw2ho1w1jvyKiYpiivI3hKBeW/1ZbQoe2XyQ+gyohaWmRzS+jW4ViII/GeTwWCSYidHJ8GnTtDpWNV/eU7BSVhGMybAnZN2U4ldSEUoJc1r6RlZMSMcWETH21KMDKBAgJrRrZZU/7g3iM122Xlxx9ltOkVAxFKzGJtxqLERYRMkFrERzEnSG2HJFMG0vnG8Rrt3zPyFMPf5j/bkp/KJj6YQ9dWgXbJILKNbEgLnhgPjRxsxbc6YicFdwOIvwlmoNg07uGxEDFBYqGlYDdgDSQEmWJGSzl4VuTMhB1e/fbXhyNRxtzxVX7VmvVcU9EbW5ERF5w4eyOluIMXpSoZZAUZFmEV9YGDR2JbLuAJHwf/Bj57udo
 zyV4ylPI
 eDMgzcVcNkWu/zbp9pwi4AKrPvZewb1bjxjyZDfy49+ny/0eY5DpTyOr6Ffi5ViDgzFGfboMt6dJzCiSYxrCDteUgxPErxZQu2pEmFGIjD3UHR0q9FgQEH0P75oExjytSuq9hB8GQCJjGZeUhCSX3nfuvEwY6nzSMBBugaS4wt5LbNtCuu2Miw6lssLCBRmjnWgYR7tA6fXvGZXHCJgy7gRxW1iZxuePleMIiwWzebVzhefs31seGZ2KP1z/BDkJ36VgzyZIRM1W/Vzf+4zDAzF0b8ie2/gD6I6KkWhmlbrhPpMvUQC2z3ZeEp9x8diLmReJTQPGaOoRrW94TJ6D7crFuTi2/0In2D5LPs8lmiN9Qzca8D/NRgfim5mNEvv6r1LgCrMetvTFzVkF2L9ClsD9GKrGPDgItqsYMjqoQ7MeCY4I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 20:07, Garg, Shivank wrote:
> On Wed, 2026-11-11 at 14:21 +0100, Peter Zijlstra wrote:
>> On Wed, Nov 11, 2026 at 01:12:06PM +0000, Lorenzo Stoakes (ARM) wrote:
>>>
>>> I guess we all got used to the existing patterns and I for one only
>>> recently found out (doh) that this was legal in kernel style (because I saw
>>> it used in KVM)...
>>
>> Right; which is why I keep reminding people this is now 'legal' :-)
> 
> 
> Thank you, Peter.
> Good to know this and I'll keep in mind for next time.
> 
> btw the patch is already in mm/core.git. I don't have a strong
> opinion on this, but I'm happy to send a V4 if you'd prefer.

I can fix it up, but we can also just leave it like that. (I tend to prefer the
old way of doing it, but in the end I don't care :) )

-- 
Cheers,

David

