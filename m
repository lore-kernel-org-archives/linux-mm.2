Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67FBCC88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 17:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 418FC6B0092; Fri, 11 Sep 2026 13:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C19E6B0093; Fri, 11 Sep 2026 13:52:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B0776B0095; Fri, 11 Sep 2026 13:52:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 009A76B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:52:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CAA80C0193
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:52:49 +0000 (UTC)
X-FDA: 85202226858.30.1A841BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0981580008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:52:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iOz351Q/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789149168;
	b=leyccriZ+XS+3dpR8NA0V+0HkvPrBXJgIYnZ8dzYcaQXc+UQW/kToTxBXysJ0LsD1/QJQs
	9DmExjFVDxaYqxIvQHPFxL2YNM2IOQsVt9NMGxSOQueQQ5+TqNGpbtjCZdfUkldOO2e6JE
	Ts2TLrhcqWcDriXipeVczep+wa/bNb8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iOz351Q/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789149168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iVpZfsXMVEGiEUfVriw9pLF8pscFPyVWyCdcfJ25DGc=;
	b=J3XoZOCXPXpappyAEAH2+tvg00oknBflzB2ieuwwr3QTe/97vfkvS0CeYXq0v5JzClsMUn
	+NFt+JUq9Upvt74bc3tkrybib4jO/bAcbLtaizXIruytxGriYoLmRmuVc/IFLtwvmFvqlI
	n6TaAJqEYyimw0Qrd+Lg3L3FJLkUmk4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B3B76020C;
	Fri, 11 Sep 2026 17:52:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D4F1F000FF;
	Fri, 11 Sep 2026 17:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789149166;
	bh=iVpZfsXMVEGiEUfVriw9pLF8pscFPyVWyCdcfJ25DGc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iOz351Q/hnr3UJVmku9z13YS0k8WM/um8sWugkCDEQ3q8R8SlKuwrn1Y9lnc1yzMe
	 4FriItsqCkS5TYFvlF64mmdFpYcVXCQjR9wpBEZe7Kf2QhLpFWQynplSJmn3agr/fx
	 PXiAeZgHdkJ/fmy8vLoM69lSaQXBV+UnzEcxamARhjEObcJrBsx2TkXcX62YwzMjxL
	 SwrGn7bW/qrJphLTeoAyqj9cFf6u636d3MhMHvM0MKKVPNKSGUWOgaQ5yPdx+ib9Ej
	 b6JAzN+cbNoOlbrLwew+3sDhnK/dI5sD2FRfSKXwg93F5F4n9x3RWHQtfDdv0dmPDQ
	 O/NBvf81QRXzw==
Message-ID: <eb040cfc-4038-4cc1-9220-c387c4c8a02e@kernel.org>
Date: Fri, 11 Sep 2026 19:52:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/7] proc/task_mmu: clarify shmem mapping walk
 conditions in smap_gather_stats()
To: Suren Baghdasaryan <surenb@google.com>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org,
 willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de,
 xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260910234737.1340642-1-surenb@google.com>
 <20260910234737.1340642-4-surenb@google.com> <aqQoPTTUC9M5HkYb@gremlin>
 <CAJuCfpEHeFSMamNhf=FLvFjh9D8DBwZtbKwL0zi=x-2g8B+ENw@mail.gmail.com>
 <aqQzk2AT05r6rOyT@gremlin>
 <CAJuCfpEMd=hVtwe_9Rp1kqigYJwqEUGCD+ViQmoacAZONCR6DA@mail.gmail.com>
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
In-Reply-To: <CAJuCfpEMd=hVtwe_9Rp1kqigYJwqEUGCD+ViQmoacAZONCR6DA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0981580008
X-Stat-Signature: aj4djqznf9fwwmutrdf3mbanaufoqp1o
X-HE-Tag: 1789149167-702960
X-HE-Meta: U2FsdGVkX1+1z30bchW7s/2Os4JwonG7AiwHcR7O5frIG1Hcjda5bVeaxKF4tnkzn0EHBy2M15/3eYLxCE7yLE38roD5gxI42Xf7WSMqxVVeY9p8TswkDIL40q7hSRjMaiWe3R4FmSN+INO7A9t3Afuk5uqVkH8SQmFIfsON7TdEEpEZluNzmm5uNuC6jUH+IHWv1bH18/Kgi9a889np708ZVAY4N9Ij/S+g9J4yUdLtpO8VFjty4d2a+cB5xGMFHVrKJAdq+8DU0mr7Qe5ZKMrQgFicIUsQCPGuYHc1v/aqPw32yFzS0kWyY5wwWcnOpl/t1PCv60RJ4Ob8AZI8l+5KvuLtzl5qfTri0R0h9KE2nuVnJ2tX33LC4QHhuhkF2MNsaHX12fBvuYzqX1KhzEHdpIfTnEFBB4eCWtoPkn+zN/ttZSup96Z5ynR/+2qz5obr1Hnb565MbxigK19em0/La8TX7PCIaZtWi5cKlddDOfJWn9mxM4BB+5XhnyRM3/CeTDhQOcgcw66rd0qp8bWp6LsRY9ti9Mu++/pJ+FZTw2/5NiUGXMd0zDG79IcDvE//wmT8LB+4XitHXVWt5YefZdduJBDU8sfM/evhxrDlx4pKvJUGx6ig1n3Z6qa0vjgFfXu60hwl6vTrdtrAHrU+AQpAfTvzIzXPg1mUfCw5mhcPKWuxXudWG4JaqkOa0nsOOIEx6AhcHt06r4tg0HmFPdW3xEnuui42sZ/U+ZKTNMR2ATOJGgzfbKvELquj/w48mhxkSbeEgP0E4VVny+MNZ2lspDWQNMeQ1IMp/oYGsaP/U/HcIfguRjUrTe8yrm8INPJGdolVsZIgu3ZYWytoC3wKS/TyuMdBraVYePy30mhhOOu/OczgXMAZagblu83TsstLkrfQ+nQzfu4CsrUEO4HjMdjCgw440xWeG02pLLRX3HzHpAqFDhbkU0sHFJk83Pk7LgIoj8M5J19
 kfgzRvbS
 hzzCdSUlJ1FINCpFdxBTlTJV5+jJodkodx6qoYyG/+hJJ0jaek0OkKPVU8kV91N3PBh65fvX56wctVyrG2Ykjf8o+KJah7uvjcZcH+kZ+eAqzq9ezZlg/Nu/FwSWCPJ70KFwBpJBh4xPNkp2YQ8CCbkotGI4RqGikrEZKpufgdTximKaYhHQYiuOaOK8szuv58g486PdmUtxWEqBwzfE6uNs4TKc7mYaYib0NiOkMxpyafL/OvSI7sFF5jZF6AUU29x2yYv0ds4VGvyTnGafmPrCWWh0nT2uylgTbqyR/z+mNq8vYemCel78ccFAt+NXv6YycpAZB/VyJhx0UL9mCw3n6/PFggzztb6kfsJJsDCLBnH2tQxjgsyZ1uKlOCWsAZ7o7UDHl4Ziwqmxx/bqSoxObrRVAOmTsdJL8Zz7qj2CHnZ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/26 19:39, Suren Baghdasaryan wrote:
> On Fri, Sep 11, 2026 at 10:10 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
>>
>> On Fri, Sep 11, 2026 at 04:58:40PM +0000, Suren Baghdasaryan wrote:
>>>
>>> Well, the "other" Lorenzo does not agree with you and suggested this
>>> approach in [1]. Specifically, see the comment:
>>> ```
>>> I also don't love that 0 is taken to be 'start from vma->vm_start' and I
>>> also don't love that the code in smap_gather_stats() actually special cases
>>> this...
>>
>> I'm not sure what part of this is disagreement?
>>
>> It's saying passing 0 is a hack, which is one that is still in place and which
>> this patch makes worse, because instead of explicitly calling out the invalid
>> value, you're treating it as if it were valid.
>>
>>>
>>> How about passing last_vma_end and making smap_gather_stats() more sane? In
>>> the other invocation of smap_gather_stats() we could pass vma->vm_start
>>> here.
>>
>> Yup, well me of 3 months ago should have suggested what I suggested re: wrapper
>> (I think you cut that suggestion out of my reply).
>>
>>> ```
>>>
>>> [1] https://lore.kernel.org/all/aifO_rCurVhFRTcl@lucifer/
>>
>>>
>>>
>>> See [1]. This is exactly how you wrote it at the end of that reply.
>>
>> Assuming you passed vma->vm_start, not 0? Passing 0 makes it really strange.
> 
> Ah! Now I see the problem you are pointing out. Ok, in v2 [2] this was
> done correctly and that's the way you want it!
> Okay, I agree this split was incorrect. I think I'll move is_partial
> conversion completely into the next patch and this one will only
> update the comment and use vma_is_cow_mapping() instead of open-coding
> it.

Ah, that makes sense, I missed that as I was mostly focusing on the cow stuff only.

-- 
Cheers,

David

