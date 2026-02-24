Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CE11E9B249
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 10:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9C46B0088; Tue, 24 Feb 2026 05:51:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 287B66B0089; Tue, 24 Feb 2026 05:51:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 168F46B008A; Tue, 24 Feb 2026 05:51:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 02A766B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:51:32 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8ED681604F1
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:51:32 +0000 (UTC)
X-FDA: 84479034024.05.7A765A8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id CEA7820004
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:51:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cq9o+qdK;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771930290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3FjK6tv04VG4ushX3Pg50HaYPXAO2Kg9HcVPjLjFAYI=;
	b=02d+nc0zDXn8JMQbh3QfIERcOuVWLHfvGSwXBFO6AmfYLaBG9rUx42Yc1vf9ft3nsAQ/MW
	um2LSoVCUTcHO8TBTTriXCVVjH6q/7hRB/TXdmE4pLmIiwKQqj1KCSr6MBlNHrw1DaBcHb
	9nJRBg9Z9BKI42Uy5wHyoyRurVymXkE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cq9o+qdK;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771930290; a=rsa-sha256;
	cv=none;
	b=qNdvqJVJRyHbCsS6k2Hulpr9o+zkKyQ3zVOg8mz4r81P83IyPk7B3WGNFOGsZX+UsV+0Z0
	+HAIQhgYOfb6Kg8X3xvZV83w0y2lURDZ1zZj2UJMLTTGII0nueFugoqK5bzlDIUDPOH/cD
	RQetftyDMwkfQzkw/40TXXUEAjOAMj0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DB3F6132D;
	Tue, 24 Feb 2026 10:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A148C116D0;
	Tue, 24 Feb 2026 10:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771930289;
	bh=A03/tUSiCw6xZ8+K7F5L6Id7MoV0WTpL2e0TYPyMyNA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Cq9o+qdKB669g0wfM0rojSPXacwLxsqfRMHKYCuNnN4YUTImI/Y0eqN6flYTL+L4U
	 bU74vNyexoGx61OsHBjsjmJDH6fNHMLsnw0W/rNjKb2Rzp56XvlpZ14OAlB/Z3m62W
	 6LeVcrFrf1IepTPiAQmEGaU66PY3knjLyIAfet6pbi0YrktGqp94k85g13m7ob5HSz
	 yKDdkGNA7wAwWqqnTuQs1S4pzXDTJrjF1L4KwmJ41sPjDJq9dzYq+8BtU6xGdcsJyO
	 Jjxlur43LTFIyCyRN/SGCCZpQfwBtxAJ21QU1r76Uv5TCOvF34TZLXZ0lZQlj8B6qk
	 Gb0lMFlTxEOtg==
Message-ID: <24b7829b-aaf0-42ac-b91c-916754f95046@kernel.org>
Date: Tue, 24 Feb 2026 11:51:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] khugepaged: convert redundant check to WARN_ON
To: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260219054827.4111334-1-dev.jain@arm.com>
 <20260219143327.7693e4b1474a337821e4c637@linux-foundation.org>
 <a0b4febb-d803-4c18-9211-7286d682d705@arm.com>
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
In-Reply-To: <a0b4febb-d803-4c18-9211-7286d682d705@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: u1ktx33ot57bi6dsuoahc9medy9zz5my
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: CEA7820004
X-HE-Tag: 1771930290-866401
X-HE-Meta: U2FsdGVkX19BGv5M6sUdtYuiNgF+T1WA1uRhqoz80vLST/1kRDHzdo8OzNT4L+EboR/UmSpIHwbMBaQqJghA1qlZRh+uKvEib+60M5Lj/ZfGSguDZAas3qimVM5ySqOcnpwzNWW0rQGh+mFcOY0Jv8EIkeLTjFbk1P5EOlQ8e13KrwHs7xWQvEqz/rIoISZVVafnNYPVMosHOxqdwj+bVZHkodarCqW7eiu78zJLfpduud3PgRN+kXrzoEB/OqQz9EDZoPHwu0HF24WXmuEL+FevxiyamdsXVJxNFyQ6qrSomuCs99vhcbcK9G2v+GpNVJV0N3AuMDxHTVNeAY1WcdSeBrmtV5n5KXUiTzuAOmYPpRvYk8KNZHM47pjS3Di94kGujwY3DhP1ErHhy2vVTxElwyXXOcYryU0+GX+2eJpCnO8/50DUgqWtoThNMiZp+WSTppT5/jNjO7nAZGrk+Ba5AzhOZ7xtXfz0r4eYposQzegSeJNzlFRLv4uEAnd7I0RfnOvWpwUw/fXCjbVaenl5VMl1p8bztSi/y+2r+7Z5O4/CbEFoCNiNT92RDYlC1W0omRyGJsSqz3gXNyzNoY8fb0prHya1m6XFW/VKLnW0SGj0N+GRg+0opiBUP71dLYkrHuClZN4JICrY/GGOfTNIOOnF0eQ5QN7rqLGef8CT3yEFBuw+Nm1rhEV2bZsi7QKZwsl4Ui43KzN/vDlHknmTy7tOp5/s7W/ZHEjl/WejMu/m3fUJWU0Cgb58lyCA3Z8yP5DGNud280AMCHng2noMcWtHwFhOkwJsfgQYTSCtTlSyBmY2XMrHOKM0Rr0m8/f3wkG9KPsW8NYQ8jz5PiqAr7Wiemr+t6sF/PWLaGZ5HbL2PaQb/u+aTIIyR5bIVrU1WjV77tiztnID4BlUw1H/k5tg85lcD/9iceZ7jxhTW5V8M7X/Hw226OPrM23pDpUs9nHMAGqGD0Qfy/D
 I4tmCZ6K
 4ZLKCcq79iIvTiVE9UN4+qm5SsWJxDBVTB3AuMsN1VyTeX0nwl+sPJV+vWFwyB0uqvbnjdZHe2cEs3sM7ZbaujdpVZ53o2FdegiJ6sAeAlOUF65+OOAveAJMPW8BOIE22tKucByGzkRq3On1+VXlWxmFOYTbnexKKkYGIT/0wVhsqAajsJNTQ6nG+vtibGoS4B4e8Cn7yCsiNO+pQtPX0f581RK7q0oVtlFZXChBt6phkWb8X2k/E0i4VLBVe9OX8DftwEK1xXEV/a+0Rdim2fT6WJhLCt0Xq4vEK76muOKdDPeeWpUGasboaYVBAOGId19Ink96sSwjNQ+05vC1XjhmqwPxZtkUgZOOyOiBxXJPpoD0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 05:40, Dev Jain wrote:
> 
> On 20/02/26 4:03 am, Andrew Morton wrote:
>> On Thu, 19 Feb 2026 11:18:27 +0530 Dev Jain <dev.jain@arm.com> wrote:
>>
>>> Claim: folio_order(folio) == HPAGE_PMD_ORDER => folio->index == start.
>>>
>>> Proof: Both loops in hpage_collapse_scan_file and collapse_file, which
>>> iterate on the xarray, have the invariant that
>>> start <= folio->index < start + HPAGE_PMD_NR ... (i)
>>> A folio is always naturally aligned in the pagecache, therefore
>>> folio_order == HPAGE_PMD_ORDER => IS_ALIGNED(folio->index, HPAGE_PMD_NR) == true ... (ii)
>>> thp_vma_allowable_order -> thp_vma_suitable_order requires that the virtual
>>> offsets in the VMA are aligned to the order,
>>> => IS_ALIGNED(start, HPAGE_PMD_NR) == true ... (iii)
>>>
>>> Combining (i), (ii) and (iii), the claim is proven.
>>>
>>> Therefore, convert this to a VM_WARN_ON.
>>>
>>> ...
>>>
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -2000,8 +2000,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>>  		 * we locked the first folio, then a THP might be there already.
>>>  		 * This will be discovered on the first iteration.
>>>  		 */
>>> -		if (folio_order(folio) == HPAGE_PMD_ORDER &&
>>> -		    folio->index == start) {
>>> +		if (folio_order(folio) == HPAGE_PMD_ORDER) {
>>> +			VM_WARN_ON(folio->index != start);
>> It's a bad sad to remove unneeded code by retaining that code and
>> adding even more code.
>>
>> Perhaps add a comment reminding us to remove this altogether at a later
>> date?
> 
> But then shouldn't I remove it just now :) 

I'd say, remove it directly. Even if "folio->index != start", both
functions should do the right thing.

While at it, we could heavily simplify the comments to "If there is
already a PMD-sized THP, we can only try collapsing the PTE table".

Or sth, like that.

-- 
Cheers,

David

