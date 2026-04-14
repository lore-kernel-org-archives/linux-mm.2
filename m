Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD8F5ED7B82
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 08:07:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09AE06B0092; Tue, 14 Apr 2026 04:07:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04A7D6B0093; Tue, 14 Apr 2026 04:07:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7B946B0095; Tue, 14 Apr 2026 04:07:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D871A6B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:07:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 838B713AB40
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:07:24 +0000 (UTC)
X-FDA: 84656431608.18.350E8F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id CA2D0C0013
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:07:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fh+FFf7a;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776154042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OKd4Mksok7AI1dGnhfmbsFm5gm5hZfd39fPbnK6btts=;
	b=y/MS2Pmu5yIjnTd60J660QjKqahnVB3mpVG1WNAod4Y5txXhk2axmofifz4bb9DRtCCHaT
	U2lZM3XVjPw9WXNxhqkPJlrZFNMzzMNRyMTTHi4Jbx8fNbAIxumCJlSq8wQPoW2YnxG6F5
	BeTOAk2SojGuant5xRV/p4FeLAoDTjw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fh+FFf7a;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776154042; a=rsa-sha256;
	cv=none;
	b=jtBxt1/l0tZUcHjL3S1EGyxEpiw7l4kenubRtSgKaexLZMBO0M9gWdpgfL9LVMl4eHA0cq
	pIaDMP3iID3MmgilKcfSUN0+eE9vcGoasoahN6C3k/iHLGSlnlLo1IikyJdE/uAMl84Y3S
	x38pLQ+F4dpnB1gekhEWUjy5u+8eziA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2181260128;
	Tue, 14 Apr 2026 08:07:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C07C19425;
	Tue, 14 Apr 2026 08:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776154041;
	bh=EEMFOy0vJOWp38dmssJV2v68HZUGRwouFVNvtMsIAeg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fh+FFf7aTtBW3HLDQPM/Z31aMG/zwVJqCGSrggC0sHVtwFqW5EyKzFVrxCylgySZx
	 7kbaXpr0lPywd4svkLcFf7otbi2RLLJ/hWUIomN9UYGlzzEMBMSNpnByjCmqW5SxmE
	 zIvRsjbuInGsk1u6lzyetoJ8y9flRVCpBf5VxJ7HBwsQQTO9kZlnHZARkZLrvyyaC5
	 NY++nLjZs3x32kd0O9unk82mePtmw5V778hNAUpWRIXNj3yrXG41DZoI78sf3HkpK4
	 GgVmeQayQcKnQPvXhOka9SfD8AwxCZy3ux61gQ15KBR3zAM6uOGoB1neRZ/63B7T5K
	 OFSSBCNR/vCoA==
Message-ID: <c9a6acdb-f77e-49c4-9e70-e38dea34544c@kernel.org>
Date: Tue, 14 Apr 2026 10:07:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/pagewalk: honor action in pgd_entry and p4d_entry
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Cao Ruichuang <create0818@163.com>, akpm@linux-foundation.org,
 ljs@kernel.org, Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260414051854.18487-1-create0818@163.com>
 <453f7de1-1ed7-4785-ab95-5d63dd4a3499@kernel.org>
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
In-Reply-To: <453f7de1-1ed7-4785-ab95-5d63dd4a3499@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CA2D0C0013
X-Stat-Signature: f4rjgofz6t7pxy5376gurnzi8t5n8ewm
X-Rspam-User: 
X-HE-Tag: 1776154042-339790
X-HE-Meta: U2FsdGVkX1/k9guwYaFMXpGCaIkA4ZViEHvqRx+gcE4q85eu2xrLUDpgLisznbZAPdzAvxsnslVRoc5sEuz4Ksm2I6ti6DK/n5xyrXkXXIxwwop1fEKf5jhArzb8NTopzuLCfJlDDbzgnUSJpzOXdbEdIZfEZCIERTRRZSbBZVe66rsNx3AHVMuaqEyZrMjWvW0Zz7tX9cb7qVtefylXz2r2sq5zwpjwf0+vdLDNm3VtLv3CHEgf5fYMt5YbbRfOadCjkM4xIDxQIZv9Anq3uASQxWYvgp2utAJXkWwxFWD2D+hIRK+MkYXm445qvy68tJYlDqj4JzHAd7U/ED/u9gKcOmx2O4lVb6N8VaIvH8mleCbwKk0bwJETSV0W/Ft4PT0URp3KUfRRRFZmFdzV3/mxzsHw6hPBtquHzVfya5eQXspd7xGnMrDItCxfh3xOt59BCowuBsdNZ9A7gYxUmrRQkFfpejQP2cJJjTDGb8B3Ii4GPlfTEWkQ93/BYHa6eB/i3Og4gDyGKNueRgEgqFr4e4e0rHamHOQlwVOpLnY8GIQAT4WIBqPxNA5KlDMdKI7mUpQ/MtmvAJUduKPRuB8ufS/AjU1n4ALnFULkVE2E9wb4+tpv/FHjuMSPSfErH6G3gNkgwCw88BCrrnlcxwXWGXCo81fM2w3iMfu0R0fTzAlUjBXOnyGbBFcqsb3VZ+ERkVxWNwKhBvGa+8Uj6op2h9UkIIfGbM1FFqTBq/cPMrz8O39360vkmNSYr2ddwr40Tv1zyqgPjZw/X7aMn4iBDNWiGRklrzzddO9okx2rDv1NjzHXWRInrEmOZHb+cVyfyzAH4oFisHHURELKB/kt6uc7kiSBMgn1foO7YElk+B+YAnT3G/WkHzTuODCPVGuH+j70Fco4yEZz7beM4ZlWzKkSOpsIru1kDfBVzavMcM0JRJHoutMIftfUv8vF+468WkvK2T12RJ0xJ1p
 YxduPnvq
 98uch86JJImjEEMpyJ1x5dMrw6HCA5SkIVTQfXx3FbpGWq67DBe/peloYCbecDHZ02+FxbRkm4nIWudiXHElxAEzJ1R0U3VU94axpxgJK+dAsMFv3YWJzBdqtwYNF2ry7pF+GswDTjKuoIDviA0hMxoUTwwpYMZe2AMiPq5yob/U/UrWZ6qIsM+Did3Sw5s1NfD9hjgEykM5MQGInhDcxv3MxHdsNWvpAFm8N1zGggEOn+tbPVSLFlXD+AmAHe6/8nNX72vIBj9ixuF0Y+sp9hWTHHEFt4wZZxOc0XfKA48kGrW2lcTK29xhpzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 09:57, Vlastimil Babka (SUSE) wrote:
> On 4/14/26 07:18, Cao Ruichuang wrote:
>> walk_pud_range() and walk_pmd_range() reset walk->action to ACTION_SUBTREE and honor ACTION_CONTINUE/ACTION_AGAIN after invoking their callbacks, but walk_pgd_range() and walk_p4d_range() do not.
>>
>> That leaves the top levels with inconsistent callback semantics. In particular, ptdump sets ACTION_CONTINUE from pgd_entry() and p4d_entry() for leaf entries, but the generic walker still descends into lower levels instead of skipping the subtree.
>>
>> Initialize walk->action before calling pgd_entry() and p4d_entry(), and handle ACTION_CONTINUE and ACTION_AGAIN afterwards just like the lower page-table levels do. Also update the action comment to reflect that it applies to pgd_entry() and p4d_entry() as well.
> 
> Your LLM has broken line wrapping. But it's ok, we're not interested in
> patches produced by LLM reviewing code, with no human oversight and
> understanding. NAK.

Agreed. The educated reader would know that we never end up with p4d/pgd
leaves in non-hugetlb VMAs.

The ptdump code is overly cautious ;)

-- 
Cheers,

David

