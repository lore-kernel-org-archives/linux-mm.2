Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2E5BEF48F6
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 09:07:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 348746B0005; Fri, 13 Feb 2026 04:07:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F6326B0089; Fri, 13 Feb 2026 04:07:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 202026B008A; Fri, 13 Feb 2026 04:07:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10E776B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 04:07:01 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A611E1B4207
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 09:07:00 +0000 (UTC)
X-FDA: 84438853800.30.EB8CEE1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1E44980006
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 09:06:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qtYA64dX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770973619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xKpCoL1nTcfSyp6xQb0aqGH26bAtnoZMqrYFxk3T304=;
	b=MK+cte+dRTiBFNpP+7BhxXJahgcXPDV6rQWv7OjWVEXZGNq9Ajilz8nMJfZquIs48haiVn
	9NMZMPnkNiVQvYkXWf9LrydLmBrrqaVhbQ7Byayi10WCa8NdDty2vK+KMz8+voB2UamTS+
	8L/2PDN76uFzplluuP6vHmX7wawkED0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770973619; a=rsa-sha256;
	cv=none;
	b=yQ+u5csU404jg5pIZJuL2MWCAVgXyJof/zTATjlur+v936Syfgs4PJHOzrAK/YYUon+bX6
	BKfyLhB8yDDe1kMO9YbYE9Src/KL+MN2C0qC2eEUSUl8I9535HNJueU33GeHBxqCXNczJN
	th7pBFzO0gyQ0DQ3UDE158RxX4iJ5OE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qtYA64dX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 23F616001A;
	Fri, 13 Feb 2026 09:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A01C116C6;
	Fri, 13 Feb 2026 09:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770973617;
	bh=9nOpgB+2oiJLAAjO8nPt8OwgivgL6OPXtS1N7iKvB64=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qtYA64dX+fmmFALv+aBglF9HRGgNb1sEmNGdb0Cps6FtCz0iADj7FFpiYkMeAsDma
	 n63Tbn6NBf6jfQB2gF1ziSYF0laYrpOqz9EX9OUnpMuRYvyvgh6MPAXsQpsqBP/JY/
	 EifcBS22+9Ave9ThrEPvpb6gsbZyzdtEzFNfu55BQ1PQQ5Oz2SyyyCPr5AqKc6SQ2O
	 5ZWwKnJNHECiOS5Y9bsHUFegkQQFMN5KXHpWW2Kp5nwBlY4kEnW/YO++n4LAHwBrG/
	 kHGGUONP/m698cYb08coOgWRF39clbXyb4arq68v44NcR+mQhvvrPsHsLMv3yxAaA1
	 df4PQF4mb/JgQ==
Message-ID: <f3252a77-f41a-430a-bbb5-2f6d3c8a7c2c@kernel.org>
Date: Fri, 13 Feb 2026 10:06:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in
 file_thp_enabled()
To: Deepanshu Kartikey <kartikey406@gmail.com>,
 Ackerley Tng <ackerleytng@google.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 seanjc@google.com, pbonzini@redhat.com, michael.roth@amd.com,
 vannapurve@google.com, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com,
 Fangrui Song <i@maskray.me>
References: <20260209033558.22943-1-kartikey406@gmail.com>
 <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
 <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org>
 <CADhLXY5nrTXmWMPeiLg37euyVeQsNDRUvKmQaPdxtE1YhPq_jQ@mail.gmail.com>
 <CAEvNRgEoPs5ia+u0ODra6N4BdOwpYa04j8nDxwfNVyfCOWnM6g@mail.gmail.com>
 <4ed1b111-f2f1-4f89-9308-fdd9d706ca37@kernel.org>
 <8f188d73-fc97-414b-bdaa-e72032b2bf82@kernel.org>
 <CAEvNRgFw_P-GZ=Z4irGheM4O-RnXkd_bdAd0AT7fUuwXEnSqHQ@mail.gmail.com>
 <c4c06a75-e50e-4530-80e3-13724c08a949@kernel.org>
 <CAEvNRgGg245-TQn2HFSadZ7gmz-FxsAQ6=N14BUgiYGHhZeLeQ@mail.gmail.com>
 <bac19363-0705-4bb2-b022-66054e1f28cd@kernel.org>
 <CAEvNRgH6yfFtOK3E3__hCjkNTQr55y-_N=SpBBr0i9_q6E2_8g@mail.gmail.com>
 <5eb7aae7-f642-43d2-810b-d7afd867d665@kernel.org>
 <CAEvNRgHegcz3ro35ixkDw39ES8=U6rs6S7iP0gkR9enr7HoGtA@mail.gmail.com>
 <CADhLXY6zzWJnu9ZLH8jThMx=z6JpYmnB_jdxRJe=QVjEMu6WFg@mail.gmail.com>
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
In-Reply-To: <CADhLXY6zzWJnu9ZLH8jThMx=z6JpYmnB_jdxRJe=QVjEMu6WFg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1E44980006
X-Stat-Signature: uds6xbkdjoeadcwu6ozidd7ni1i91te3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770973618-5045
X-HE-Meta: U2FsdGVkX180m+e76XX+bdGxH9HP3Tm9IlNuCNiOjEAzRquSGWaZJ5ehJcGSz7f1z5CKepRdSLArHItbiOm3oXo97JH9temY63xs4odaffIO1HAEYucCqfq1m+8Dg3un7inhXaKTmZq/7OAq9rt066gXpjzGrpJftdBEtL1UMYt6V/mMJgDUa589DG7nDOPedEXODPe9D++InIZ87SlOIU7rmaQu0X4CJ6QveyXRtTW4w8+FzhsTGFbiuPfVjYEhWfocx7tWrBIxKrJosguJqiR4ErDPl9G1TPnXVR5u5C8He2SnGy+7e99pllPrzO0d+WB3oBygXMcrgu8lJcYdM6PSel2JKJk64yWW25Vx18R4YpV8KV1zcOTF6lCkvlzoZk+X1b2tgZdxJ2Kz5GcSxgtep3a8y5jXm98FJbL/6dIhwjxEtyx22avswYjz27kxslvKTCHKrluIBgtplP9mqMweRRKVd8kfN0bbXRfF4CH1MEgptd0crOXgPOIQ0WuREd2X1UFpAeeyYw3ghRj1e0N0ZDPc6UwODLma5G/ezT+QTS3nxmmOotqBqGIJcwL5NlvnQ4TnT3NoNzG3oWCssq/eg9zOtsLin5oOKOiCdXJnRY8mQH+SWnWfwf7hVwbn4XFyMkKsTai+p9ruX7AOdmhXHzWVcpB0V/e2iKUqT//z6AmjPo9HkgDJgdVCcjuBJpIEfDFPOXloFHW2OUh9th9EcFjf3QZ1UA13suiSJc821G2XCbjtTbJLejhSDEBupZHsq6dLP0jnmoXlYZtmkMCESz+FDRVfXBod8mDphDS+FUNYuv1a9LLnYiM0ix3+bVhsE9q5h8NKu/FpOXvKZqCzyI+58+bX13rO/p/3ZsTWQEBxTau0jcSaIXq9jG3EzFIlYkwpb6BW8WrRM9dsh2Btsad0t23lk98piIzLFMZOde5YPBW/f0E6q4r3DvaJ5fzT1RNvfNwUXOj1L6P
 2rBAe2HF
 t4XCqH9vrXEdB7fzfe4gcjetnoEMht1uv3OdHCZtnrwCMCD6WFA4BR8zvSsKpacUNJHP8JF7X2h+mf0znnAE4Zk6mkTG1FefCKJ1edCTj8vU1eHA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/13/26 06:02, Deepanshu Kartikey wrote:
> On Fri, Feb 13, 2026 at 3:49 AM Ackerley Tng <ackerleytng@google.com> wrote:
>>
>> "David Hildenbrand (Arm)" <david@kernel.org> writes:
>>
>> Going to try and summarize the findings/discussions here, copying from a
>> few earlier emails. David, you can jump directly to [Question].
>>
>>
>> [Bug]
>> khugepaged (and MADV_COLLAPSE) will try to collapse secretmem pages with
>> MADV_HUGEPAGE applied. There is no crash, but there is a false memory
>> failure printout that looks like
>>
>>      [ 1068.322578] Memory failure: 0x106d96f: recovery action for
>> clean unevictable LRU page: Recovered
>>
>> The correct Fixes tag should be:
>>
>>      Fixes: 7fbb5e188248 ("mm: remove VM_EXEC requirement for THP eligibility")
>>
>> I was able to reproduce this on 6.12, 6.18 and HEAD
>>
>> [Stable Backports]
>> The first stable version this affects is 6.12.
>>
>> In 6.12, S_ANON_INODE does not yet exist, so I think in
>> file_thp_enabled() we can return false if vma_is_secretmem(vma).
>>
>> 6.18 needs a fix for both secretmem and guest_memfd.
>>
>> [Solution]
>> For 6.18 and later, David's suggestion of using IS_ANON_FILE() seems to
>> work. This affects more filesystems than just secretmem and guest_memfd
>> though.
>>
>> [Question]
>> I'm not familiar with the concept of anonymous inodes. What does that
>> entail? Why is it suitable in deciding THP eligibility?
>>
>> [Next Steps]
>> I'm going to be traveling over the next few weeks, so perhaps Deepanshu
>> can help with the fixup patches for 6.12, 6.18 and HEAD?
>>
> 
> Hi David,
> 
> Thanks Ackerley for the reproducer and analysis. Since Ackerley will be
> traveling, I can take this forward.
> 
> Here is the approach I am planning:
> 
> For HEAD / 6.18:
>    - Add IS_ANON_FILE(inode) check in file_thp_enabled() as you suggested
>    - Fixes: 7fbb5e188248 ("mm: remove VM_EXEC requirement for THP eligibility")
>    - Cc: stable@vger.kernel.org

Right. Please link the mail with Ackerley's reproducers and carefully 
describe the implications. Then describe how anon inodes never pass the 
"opened writable" check and that the clean thing to do is to revert to 
disallowing anon inodes altogether.

Also describe how secretmem is not affected upstream, but triggers the 
confusing memory failure errors.

> 
> For 6.12 stable backport:
>    - IS_ANON_FILE / S_ANON_INODE does not exist in 6.12, so use
>      mapping_inaccessible() || secretmem_mapping() in file_thp_enabled()
>      instead

I think secretmem_mapping() is sufficient there given that guest_memfd 
does not apply yet.

But we can discuss the details about the backport once the upstream fix 
is in.

Thanks!

-- 
Cheers,

David

