Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08740EE0AF1
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 22:25:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 327376B008A; Sat,  7 Feb 2026 17:25:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D4C26B0092; Sat,  7 Feb 2026 17:25:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B67B6B0093; Sat,  7 Feb 2026 17:25:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0ADDC6B008A
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 17:25:36 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AAF9E58EC3
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 22:25:35 +0000 (UTC)
X-FDA: 84419093430.28.D32B3AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id F28CE18000C
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 22:25:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LYG6CnCE;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770503134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UwJ5tpkIUfMrEgfmaMb15Kt86mZHDr2aFW+Xc7GpCPs=;
	b=S4ZbhULxu4bcFt2ogd0R0O4Bcti1+5vNptVFya6dqW+fNaqxNqy5vhzD+J8eLd7uZ2TLfO
	HdghI6JiuBKQtA/UVkuzpvXiTj5yTJ3985mCJcTbOsBuWOaABzGSsAq1W3d0ZOEo+pYNaj
	n5K/YlPEx06vTb31BUfHXHfMqFM5g0Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LYG6CnCE;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770503134; a=rsa-sha256;
	cv=none;
	b=EBA5se31j75QPR1b92nC8utPjsTUdZ4nuaI3WNTG86ljP099kGilioNQG+OS1U7j0Hj6To
	lOiIfw8frET6dQq/CNGoBpqcR33525bnVc99wEV/I8xTGkt1De8gyPpijeBjkM6f+3p9B4
	pIGA4EWFe3n5E4QiPYeENEGwY1ZzN7U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FDEB6001D;
	Sat,  7 Feb 2026 22:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CC7C116D0;
	Sat,  7 Feb 2026 22:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770503133;
	bh=ra7xZIlMpNJbLN33wpK06wXnrGKXCoVlzpHXODuN2HI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LYG6CnCEItvZ1t1f0fNdIfFH2mgnPJbb9AqdB7VhYKVsu39rSOmUgAmG/clAtfthW
	 vSzhfhgtykCg3u9tj10zNhGIdH8SzlZseFkVnb4QNHDJR8IfnV21np3aiuMDg1p03A
	 mvYL1VxU1p/cNMwiSgXaoDERPwg/F09NKkTDrk8YCR4RDwA/xbawGp8Bc/fHlbLwMY
	 3gYjch89ARZNLG18rZH1y9xcKaIdh4HBo9xE1p190YRP7bP5N3OCKEMm9p1bweCANc
	 bZaWN4C0EBhJHSFUakxRzsxmfBV+rfdLVs/5SeFCwaRW/G4xamXt4KkExx1YySTy81
	 GGOPFr0FvFZ0w==
Message-ID: <bfda8f27-cd2d-43dd-9fdc-cebf7b7cd7f8@kernel.org>
Date: Sat, 7 Feb 2026 23:25:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v7 4/5] mm: khugepaged: skip lazy-free folios
To: Barry Song <21cnbao@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>, Vernon Yang <vernon2gm@gmail.com>,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 dev.jain@arm.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20260207081613.588598-1-vernon2gm@gmail.com>
 <20260207081613.588598-5-vernon2gm@gmail.com>
 <CAGsJ_4zxAmDS+FWzfX-670W3H3LM=nUZ-gGe3jMV9tYM0E_EaA@mail.gmail.com>
 <e106bb45-5563-4b9b-bcb5-defd6e204c79@linux.dev>
 <c1280171-b9e7-4f10-adb5-b6a8ed69e54b@kernel.org>
 <CAGsJ_4yEfgipUe37_k5rArrYMPY_31JUKQGjRk+NNJTK9QhBWQ@mail.gmail.com>
 <bd36d92d-dbf1-4818-bb31-0330c1f53577@kernel.org>
 <CAGsJ_4zBpL6a5ORAQUFwZMM+ikmMS8JSo9enLDZ7VFT9kkge+A@mail.gmail.com>
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
In-Reply-To: <CAGsJ_4zBpL6a5ORAQUFwZMM+ikmMS8JSo9enLDZ7VFT9kkge+A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: edawes46g6h8b5ou8e34cfk9snnr48rg
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F28CE18000C
X-HE-Tag: 1770503133-713411
X-HE-Meta: U2FsdGVkX1/8cjU2yu3kSwF+nlAA+ab1sainGuA56cM1xQquskyi64jcXx1kwMQLFXH4MwNLCXwQCewNP8X+0N4VZVVTolU5klK3vhVhbePggh82BrajU1jkdiLQGvVzDimaf43lptbHVeCerErpDFrKMx7teLqdVUKGloIpr7O3/EOFflIQhYDqjhCMfIPpvpWn9b9/jLxwmCfCA3aDqk6u3QYNYsBRa7EsOS6NkoPtIVsNfMmhF0T9KFSEwlSCzDiqiKGx7f3vDsrGZVIZkj9k4sqjy75mW9NYY+8AnHS+BkuVtrSSOT1zBGnqENI69L/KaSL17t0IrkUN2Dc8cjT1hEJRobQT4f8SO+a+keeSMgTxvKs9KH6TziTqxiQanHbbHDgrok5lRoBB+LaOnXtUvYpIaXrgxAve5nKV4OLn9ME4rZjLI8P3rsp9JOrh+A3YYXQO4zEqJxtEUM5avSOu60l0kOyF2SLEtcScyD+zXh0bAW46GF/uomaNF3SREITfiCOXPLqvnrSlH+RY6NNVYjOBQU/FepHfMXykvCzchIJznnvekMIycv7kAaGNUZWDyn4cDcQrCwEEnErmpxKTYr3Ezh1jJOzVYj3Zt/QwyPXG51lXagzQkZ3J/QIP3digQy8p/WjUD6PBFeuw4JkTsDPkSp1FQJeffPaY4Dda2hdy4nFN4utL4jQU+ZP1NmemSDUxK2REMX1wdRhojdVWNX4BVHhAd70S1KFffC/YuFnZjbU5YQhDSJi6uK4O58X5AwkMt0/Q1++Vmk8lxPKE5k0npK6/jFqrLDmbmbEueYCeFgVMf08WkYXmt64BvjuFUSNouBjQStWPESNUYDNAcxrVh7Lsl1u3VKYq5o0lU1FMj5SZpr81uSi6TCZfbnXgQJP1FBEg/Vx7xLiG3G7kEuvkjMX/aWH3l2jFqyPl+uH0lSy/hTJRwPIxQGZL6/lRFCdpGhxTQA7Q/co
 /7j+E+q7
 dICR4ZRfC6OdeJuZuN7rlxSrdDS3FMAlaqhwhICXf7y1a68TA1hYrvKgbXfypMKkmCBvqABp6EyOTgrum8GSJjFDns00VAx6uyajlBuH4O4T4+xeBEAe6NxZz2/hU81cHlaQkvTZ7nm2QNzjR5vzyjO0IsccMqevoqzKS7OJOflBsvOITbNOueBFl4zaAdtnr7DxYUH7bGtAy8T4eABKx0dTliy3phddcPcShHXJr5GAkebxaXUoUaB+qm/sN6ZlVq+YB0EmdcMtv2pq+jJVXtfT8lyzZ9ClX5/MTGqb+Wex3pQd2mP5RfLA6kg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/7/26 23:17, Barry Song wrote:
> On Sun, Feb 8, 2026 at 6:05 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> On 2/7/26 23:01, Barry Song wrote:
>>>
>>> Maybe change “just not skip” to “just skip”?
>>>
>>> If the goal is to avoid the collapse overhead for folios that are
>>> about to be dropped, we might consider skipping collapse for the
>>> entire VMA？
>> If there is no memory pressure in the system, why wouldn't you just want
>> to collapse in a VM_DROPPABLE region?
>>
>> "about to be dropped" only applies once there is actual memory pressure.
>> If not, these pages stick around forever.
> 
>   agree. But this brings us back to the philosophy of the original patch.
> If there is no memory pressure, lazyfree folios won’t be dropped, so
> collapsing them might also be reasonable.

It's about memory pressure in the future.

> 
> Just collapsing fully lazyfree folios with VM_DROPPABLE while
> skipping partially lazyfree VMAs seems a bit confusing to me :-)

Think of it like this:

All folios in VM_DROPPABLE are lazyfree. Collapsing maintains that 
property. So you can just collapse and memory pressure in the future 
will free it up.

In contrast, collapsing in !VM_DROPPABLE does not maintain that 
property. The collapsed folio will not be lazyfree and memory pressure 
in the future will not be able to free it up.

-- 
Cheers,

David

