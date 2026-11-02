Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BAD860A260E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NCtOhPVF
Received: by kanga.kvack.org (Postfix)
	id 523376B05B2; Mon,  2 Nov 2026 09:08:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D5456B05B9; Mon,  2 Nov 2026 09:08:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39CD86B05BB; Mon,  2 Nov 2026 09:08:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D1B76B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:08:47 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 92BD9140130
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:08:46 +0000 (UTC)
X-FDA: 85390359852.03.BB89614
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id D98CDC000E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:08:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NCtOhPVF;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793628524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gFg/Tdvcadu+bbQIpwDGp1z4MOgwjS63ACXXbVbRR4U=;
	b=4ACiR8YrnRP2gauYGOSLYHwREj1laaz1L8bSegtOz0vnrWe5v1CVrxrrjvtlMHOWkVecv3
	36jF1UXiuCw+4aQN4BiE+TkQs9LDPgcYe4IeNK1Otw1vkTSCXjOsi4rXF+KV//zawRFSRu
	JRdOTuTEWEndmsQoZXN9yGFbi027DLc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NCtOhPVF;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793628524;
	b=8NSbGtk3RrkIbh8CH41lr5/XUDazb16jkKN3TXEddFLqWNdyJRUGEx1FNaR0ztNXtzm44I
	de1V699IQnuvgc8K8cZrglr8a+opot1Vi8e91AIxSAy5F9c4C8ce645xYvmazpHJ2RYeOT
	kwaM9tYCwRDXRb+RZ6ahX9taQdxmbuk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 652366004E;
	Mon,  2 Nov 2026 14:08:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CD51F00A16;
	Mon,  2 Nov 2026 14:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793628524;
	bh=gFg/Tdvcadu+bbQIpwDGp1z4MOgwjS63ACXXbVbRR4U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NCtOhPVFEwSBtJaSBNfCfpGnqt+/ADTCt3Ao8FMbknvMwL7pSjoPXdy04Uis1zz02
	 j/nws3s+kshXJiofBqenjemLGmEZdTahf7F+HYUR1YCiNfQzQYPC07EtmWMleofsSi
	 4on0Xf9nRBY1Z0K4ggEcstabIDDetsuVcgjEMJVtOqQgEu2FOhRw/DsG8CKsEBUTul
	 2/mYYlO9OoOyj/17lI/RVQ/HUMOoCzJ2gLD1PM0qhoLBWOAuv8JXqGjJCFc49gLNr1
	 6+6TK6xoGj+T/0NmcjU6tgW/Ct46eDO+ayxHWVzXl7Rd9RrMkfMpkOWMsA8HlftSQS
	 vlkD8+1bgnOKw==
Message-ID: <d70b6ac2-a8b2-4c34-acc4-ee421eb70aac@kernel.org>
Date: Mon, 2 Nov 2026 15:08:38 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm: internal: fix inconsistent in
 folio_pte_batch_flags() for shadow stack
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Rik van Riel <riel@surriel.com>, Yuan-Hao Hsu <aa9736195201@gmail.com>
References: <20261102-refactor_gup_fast-v2-0-bc1ac018c834@arm.com>
 <20261102-refactor_gup_fast-v2-2-bc1ac018c834@arm.com>
 <85c4a87b-2c8b-4ef5-bb30-6518080f8be0@kernel.org>
 <auiI8jzumVHmmSV9@e129823.arm.com>
 <9a67e7f6-0ec6-414d-8689-c70eeed6100c@kernel.org>
 <auiZFJ7Bb6cQnqtX@e129823.arm.com>
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
In-Reply-To: <auiZFJ7Bb6cQnqtX@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D98CDC000E
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: m1ea4z6h5nn67axm7xspdkjqedqizbe6
X-HE-Tag: 1793628524-103856
X-HE-Meta: U2FsdGVkX189H5XewegO/JcA0Q+eRbamhLZFc2pd0fRTBPH1h0AJINrv5bvM0likluEm8S+WWZGFdeZQek6d+R5KmFJ96DIBgu0hLAk4hto3dpowRf5sne0pV+Uq+8xa3/1Lf8fTwTdIkOPIUkogBNNb+sX0arn0No6zitLMmJWiv4mQi2XFrW/24JoDrF9fg/MG4PCqyU0iaDijg3P+KSmrd7K6u854/+u9uAFzchaRAIflD7GT/jt8+xlstEHu0WE30VF+m2OXk98Vs+eo1YeNOKWzIaf8qgmhdlOCVQnCmAFRE6vQTMhs357Ta1xxXaJsTu6lfZL1VPB9dOr3dvZ7rE5SDusP3CXutVLvRcizH/77m/5/c0hMiD7kRN8THkHq25c5M0ZX2pjLJJHrymcG8/E50NlAX7I8gcg9TJfu9LrJTLpRGNcoQzLevbbuCYQOK3c4IYnQj1bB2hXi5iHTg8ywL1fIiAKE6jYtp33E30TCkBNYn9XAapb+4t3tFX2ZFP0QxnNu6pEfiU4w9z9fqh2y7d2HyYbqB3zNHxYAWGH+NAgf+HAXaWRnD2l9EO7VIWCVCaKz0+SeQGlUriI/GsvINDaL3Mgmq/g7DtU1DAtTjJEwFTMFCdRt+9AT4xj00z09KLNE3I12pSxqWMAZCenKXqA6nYfpTh6/+bYha/yShzWDyCoagH4POytYEXV3qMOBlt3Wx7iZJSdJ3+kfWNBbJjtWi5QLbOvnjmp4hHsAWeYyOwy0Ompluu25GT+sf8+Jc9qJbqRo6ipFBn0zNkO5EpuVXoSQagHNeEJrxZPVM+d2ElrGz0/AzzuzkPpIgCVi76vGfBSeiNaFNLtiCjKOy2+sm3OnH7ottseWkhIGkqn8oLCncoUIa0+wn9w89r+LjLLeY4QNl0GTDK7IWbcIEc1ExtUbcwUpccWFVFQbJNOzFOkjNOA1u/nvHtOnnLeVXHQYANrSuvs
 UCt3o5G9
 LAK93PORmR1ElgXXu6hTSK9gW+z/ElGKQdgPnauayCYLiO3Gc4RFy08C5YAYaeOD5e84vWhqQhhmxHI4iYpf46Zesyfpsw9DHHngeA9XibIu2bj3tx9dJBVbKWI7NUJIrX/2+1F3q3iWh7w7e7d13DQDdIfCja0LfjEEqUT9kyfAy1T3mqh/S3kSnkVssaegrV/t+R6gleZl4rRNgKkrJb6qp7ejsmQ8ZPnFHL19Hzs5uvI/Kg0DV8RhShexzYuBKL3MeDTrDqGKKrD61FPuThENq+zNgcx64zEZuD4oOrdALUa6I1fvi0emGgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 15:07, Yeoreum Yun wrote:
>>>
>>> Sorry. But I couldn't follow. If we accumalate with any_unwritable
>>> and check it out of loop once only, we couldn't properly nr value or
>>> Am I missing something?
>>
>> Ah. The idea was to simply reject the batch entirely if that happens. It would
>> only matter if some folio PTEs are writable while others are not ... well, ok,
>> there are some cases where that can happen, but it's not really the common case.
>>
>> I think we should simply disallow ever getting large folios into shadow stack
>> VMAs for now. So I'd prefer the fix below.
>>
>> Thoughts?
> 
> That's my preference too and we've discussed :)
> I'll repost with below unless anyone has any strong comment.

Yes, best to wait a couple of days for people to catch up.

-- 
Cheers,

David

