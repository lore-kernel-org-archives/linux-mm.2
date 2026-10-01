Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DAF2CA5FCE
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 10:55:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48B4F6B0093; Thu,  1 Oct 2026 06:55:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4626D6B0099; Thu,  1 Oct 2026 06:55:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 378816B009B; Thu,  1 Oct 2026 06:55:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BFCA6B0093
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 06:55:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8DB1E80334
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:55:22 +0000 (UTC)
X-FDA: 85273750884.30.83FCE4E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id B764BC0004
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:55:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OfncYfp3;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790852120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=penxqr9i9OBDqzR9Qzq1r2NHVsP0bv2yCQX2PsmhJ8k=;
	b=ThnjNV9UHFfTblXexG0VRDGxuzYisPLdVbgPhieLrCgrxLsik3GBNX6tJu3XRqCtdC20ku
	51res8WBoYq5VXJBOLjxhZadphURDdaEic4du+X80tiruuvxHHe2QCcY6M5SUM5Elf2lL+
	4gs4hXcAWuQsgCf5oJSmJPou9pkKFr4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OfncYfp3;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790852120;
	b=tHNunHww5dVzWf5oUiD9/s9SdyyW+zS25ki8LmB1J5vyZydX31NruwR3gXR1cjGt+3Xwbj
	qpv/UFIHpwRln1l2oSk26modNb4+dRpHyvvcJeTWdDspQEvgDUR+VhImVOIDoZCcvs0bCQ
	Ea7kFCVXT3lUc3fdqaLoCY1GVhmGxzc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F96841B6E;
	Thu,  1 Oct 2026 10:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63FE1F000FF;
	Thu,  1 Oct 2026 10:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790852119;
	bh=penxqr9i9OBDqzR9Qzq1r2NHVsP0bv2yCQX2PsmhJ8k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OfncYfp3EtQ5vNQxUvpMVGVjy20dPvbDUZVeNjZTTIBBMgw+tVr5rRcNDAJqCM/PX
	 A4MFsfzdj/e6giw52AZedON5aXr2t+tm3elUaBz7JDaimwLGKWwEhopgwzT9elam+Z
	 r2jAMWZWdkpgCQBTpYhE3WvmlOjNA7Xba3VRUl6r66KvqVary9j/kFBhvR0c5Uij0s
	 NhcEavOdPUuFaQ7tSOYFKJ7Qfad13KoFQiB8BvoQX1yg4DWTwTwkpa9badb9d8MiLk
	 w5W6t9g3nngB9eO+QwuatNiWEahkhk9hTZmgFxteQI2y7KwWgzD2cmE+BSKnD+w5gw
	 RxQn38HVyRYZA==
Message-ID: <e8e7bdef-8c12-47bb-8b39-54405b857156@kernel.org>
Date: Thu, 1 Oct 2026 12:55:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/numa_balancing: allow migrate on protnone reference
 with MPOL_WEIGHTED_INTERLEAVE policy
To: Gregory Price <gourry@gourry.net>
Cc: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, rppt@kernel.org, mhocko@suse.com,
 corbet@lwn.net, skhan@linuxfoundation.org, ziy@nvidia.com,
 joshua.hahnjy@gmail.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260930072617.64665-1-lizhe.67@bytedance.com>
 <cfdcaaa3-a9e7-4352-ab01-4922ebb8e0c9@kernel.org>
 <arz56nVu8TzSjqlg@gourry-fedora-PF4VCD3F>
 <ca35c989-9aa1-491f-a247-ed36724f10a0@kernel.org>
 <ar0LqjO3-cwU6-Jy@gourry-fedora-PF4VCD3F>
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
In-Reply-To: <ar0LqjO3-cwU6-Jy@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B764BC0004
X-Stat-Signature: 9sxax45ea7h7bit8fst6b4cbc1kgwbcz
X-HE-Tag: 1790852120-571795
X-HE-Meta: U2FsdGVkX1976KQK9BBJ05hDNzOYf3qxWAoOj712M97wa3ZyNPF/Ku4FPWytmcinzfK0Ls+G/JUd8S6B5zNbGRh+iAASkp4ficMqH8FmcrgykZTjOoNuAgZB4ricrMZTWjXlRQOcokOdoos2w87n0gQXxnHd0Ir0l98JV0p4EBGljFWfb4xJ1vlnn+aA/Ks8a2BOYWwRuu1NcF1RXPAxVJiu6sA5QcqTH3rxs+TM1odXqtbKgAjb4wt/qnw02KBNU3ifKI4q40pf8y5lsgrDfPVDMMjkYFg9AGp8Rbdu6sEv174b/1wJCDv9YRackaDr8pQHQ0FpVo/8xa+n49vh22s71ukM6jkY5fMKCRJup56g/RbMeHJEEgACTAmtvwxmSotl97tOPfc1rwLOjwAxAKesy82pR8pJHoLMp0E9jvUTnN/lDeTPn+0S72ZNcihpvrxgxvMzIs31ag93xVVba4sltrr4tNuGy/pD7zs5h9q7gNMOd8ieEOrIqgcC2qZOVB0t28dcSolL7AtvpDIYjGLJzJ27l7M/tCaBaWb23icJc2eATj1x8JkL8AuIQo6V6BLEHrHFqkVcP70013hhFSJqhDmL27sifS2mf3YbGgen1ukWyA+Hv9ALvMOJwuPS0f3/GTf5ygXPcHYmqVbcaenRFaSJA90AhweDvPPexrfMQquP7i0oDZSxCEXraWNFmoTYVtUjjiLfpYLGO1KVFtp1ymaoLcyK7hfuiYfQpPR3jcjSNLzRAd855LHOY04g1HN1eCAz83u+X5vYYrV4kYDSDSZzIEk3bi8eP7LNOQ8YNU6hVOOa5caQFPEzl4bBuZZqN+g81uxq27PQmIRJvSPDieXtsgpH8+hWcywLHgpb111D3T8x6KAmdynLxqkvJii7IqEFEWdNtalFajfveBa1aiwp4aSmqm1aM3ciOFxhFZZ8rc+iFQULU8TeCMnDhMT55YMnq5E19XPXlYO
 Nb4R0Pkh
 StHkPTPm/TPHmaqbOYGvun5ZCpvY5I+MQtJbWzxQzy7VjQzkYgboLdXalrGDDF7qfcWtdcxpQfnrN4AH9fGi05a3XGVlqdLx3z29oa109aHyR8G9dO5pvAN1oX75K/qZEsqqHNhYr1bnDPAE+kCCV/x6NHYNraXN4vroe6NCKs/xfBUPXGIf3xU5fyhnV8M0Ob+PjUS3ThVVunoreSP3MqRVDpizS0Bl+idmi+5Wb9YF9wCMyLuInlz2+qu16A5mjySJRnUWlAdr8Va7T7sGgiMi+LlLgx06DQHPBHAHsGhBoHp9RQmPdn8Gia0xUDyADJbREujAUH2/8VAjglYve8uFvmes2QLqdwxIRk8ogZRMwVECbL2hhtZmf49Qj5m2RDZQw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/30/26 15:40, Gregory Price wrote:
> On Wed, Sep 30, 2026 at 02:32:16PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> Right, but you're requesting this configuration.  If you didn't set
>>> F_NUMA_BALANCING then you get the existing semantics.
>>>
>>> In the existing semantics, if we're INTERLEAVE and WEIGHTED_INTERLEAVE
>>> we just always say "no tiering for you".
>>>
>>> But as an opt-in option?  I don't quite see the argument for saying
>>> interleaved regions (or tasks) to be opted-out if the user asks for it -
>>> that just seems like an arbitrary limitation.
>>
>> Just to be clear, what I am saying is: the proposed semantics are inconsistent
>> (weighted when mechanism A honors them and mechanism B doesn't honor them), but
>> once we set these semantics in stone like that, we cannot easily change them
>> later because some user might depend on that behavior.
>>
>> So you'll need yet another flag to say "NUMA balancing really also honors the
>> weights". And that's where it all gets ugly.
>>
> 
> I would agree with you if demotion didn't entirely ignoring mempolicy.
> 
> On a tiered system, mempolicy *only* applies to initial (or fault-in)
> placement, and otherwise is more or less entirely ignored.  This is
> a case where it's not ignored - which is actually inconsistent with
> the rest of the tiering tools (demotion, damon).
> 
> This is why I said this distinction may only make sense in TIERING
> mode, while in NORMAL mode you likely just want to fault it back to
> its original interleave location.
> 
> Also file interleave (indexed by offset) vs task (counter-incremented)
> policies are affected by these changes very differently, which I asked
> for some thought on.
> 
> As tiering develops, the less I think task-mempolicy as a whole makes
> much sense (because it's at-best advisory).

Fully agreed to that. I even struggle to understand how an initial placement
using the weighted policy really fits into that picture.

-- 
Cheers,

David

