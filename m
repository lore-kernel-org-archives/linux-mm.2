Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10D5DCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:27:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 792AA6B008A; Wed,  3 Jun 2026 08:27:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76A546B008C; Wed,  3 Jun 2026 08:27:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 680586B0092; Wed,  3 Jun 2026 08:27:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5AAF56B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:27:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0462B401A6
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:27:22 +0000 (UTC)
X-FDA: 84838526766.01.C543A54
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3EEC220008
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:27:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cl2NQkYC;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780489641;
	b=lVOZLcV3xcL5lK90A7CHzQrTj7U4gjjO+rdmgr0UOSHfGUE4/mlyDN+AZktvPmp8mcJ3t9
	uWn31t9uaraTYgBsJ+aWPhFc/XHNBODLboE2tFHDYtCTGaLTmZV9+ISTwuoQVM9Xx09kkh
	P+ZlGBWa5KBxQvQYjZtVsSMM0/ys+zg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cl2NQkYC;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780489641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uNfk9BcPdly9aVTPrznds3uJR0OWgZjLs5X0wKssQG0=;
	b=XqfSYmhyg7iJcfEtJMYEiWhaox6KBzJDVbBINrWxFr0qBMZH0unODyJMljOaIriQfWY2JX
	jMd2dLUDPwi1s41BqfM6TgT7F9nOtYkJIdSJ0M6OnPGpukJuoUKd2ftFECx9HXGYUWaRm6
	7aVCYS2Yj40tRfa9y5j0sJbjVmwVksc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B671A60221;
	Wed,  3 Jun 2026 12:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7BE1F00893;
	Wed,  3 Jun 2026 12:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780489640;
	bh=uNfk9BcPdly9aVTPrznds3uJR0OWgZjLs5X0wKssQG0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cl2NQkYCVfoihPRZMFzihOK/KzDr1MQWeGdKvH2VD3xbr9ngUyMrQgHpzHxo87puf
	 Uhc5ydifJ8z/cw9MetJNzvcVZNyi66FkiF0YbAKt7EIBqwk7ea4vKb0HlftPvy10HN
	 C5YrywpP4xwhXtmU3t7M8AM+iDyIy8WGdebGnJvPIRpNQvy8QAV/pwCkWvFKcuu1kj
	 fsMx7i3HnwJJVyZB5QDnts8G8bCvhveQFYQxh4Lsh5p3kE5nt2NAmLyZyDxQm1G7nY
	 WTzWZVluCtSXURw5yiWS+s+iLozVM0Oa+XNTHfXV4/4p5Z5qEkdbVXB/x0BeKzXmel
	 DL7doHtiYgeTA==
Message-ID: <053db37c-bafa-43b2-ac54-717e461b57a8@kernel.org>
Date: Wed, 3 Jun 2026 14:27:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v18 11/14] mm/khugepaged: Introduce mTHP
 collapse support
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, lance.yang@linux.dev, liam@infradead.org, ljs@kernel.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, vbabka@suse.cz, vishal.moola@gmail.com,
 wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org,
 yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com,
 zokeefe@google.com, Usama Arif <usama.arif@linux.dev>, usamaarif642@gmail.com
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-12-npache@redhat.com>
 <b8380eb3-096a-49f1-9ace-99c1e75888b4@kernel.org>
 <CAA1CXcBg1su-bk3i_H+TW4-nTgvGSGqRNeC9MpQo7sGeH8ejnA@mail.gmail.com>
 <d3c2b00c-6810-434a-b837-0707b0a11611@kernel.org>
 <19639b08-5bf1-4974-9635-c458d512fa38@redhat.com>
 <ef5c470f-3c32-418d-9566-17ec01b691bb@kernel.org>
 <CAA1CXcD_Bz=Si+vP0Sg_FhAHVjbeAJ4VdvtWGM-jVYiRXFHAnw@mail.gmail.com>
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
In-Reply-To: <CAA1CXcD_Bz=Si+vP0Sg_FhAHVjbeAJ4VdvtWGM-jVYiRXFHAnw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3EEC220008
X-Stat-Signature: i61sbkmtj3bmt4j5548qn4gpisw53a6n
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780489641-907607
X-HE-Meta: U2FsdGVkX1+CrL1htqjCyj6RFHymD2o+lNm2K46Hl37iXU2fqlJus/dBK3FNDZzB2WrzJ+GQ0P//guhaSvkQfwILg9JrNUGPqPgh5NcdYABwZX+TvaTS8yLkk8VTv5R68vVOuzvK3OwEmVV0iAVsOQMmUxkqW+ewnSfRWhoBxbK2/AezGMeFx961+IE6k26Pbq1bFPoOj4cj8Z7G1Nu2Ty3Y4Ru+rkhmnO9Lsgpb9kHD/SfSEZRWY3Y6EIndR+3nw/W7ZplcnVmrr4+Z/se9Cs+7DuThLuiNpZaUsmR9osqSr3jyZRF3sphkh2LfQYA28crDAj2bnHWWCaE/e897jJwdBEZ5//bHIK9qN7TfM8wjttkOjs8xjr/jCCEOQNIbG0ANafiv11hIeiP/DICi9a/gEQefwt+Q25xlM7AzzrDY4qXgcjZ1lJE/gQeJXgKtJBuNdPAfs2AjhjjMpf1GPtYPBm4UKiQmmr773IpXBmNhhg96ZgEq+pDLpYV3bUyHf4ehTLikSlHQD1nq/jtVvvN0EqV9w81bbnGhlfHa/G2HMt9PE3tcuZe/Gebu8MbqwSBdNtnQXES73Hsi7og7KmI9N0/ZVwFREZ08RJS54eUtrvJW8TrkGOu/TXctjVP/jyezaN77XibEVhp/I+6XfRn995hN9bxY7kjWiytTGPBZQY/m7ztFZ1QujDZtV4hGNvayOzVUJpygZ7sTL5q+5nyGHgS08JbwWcAL2bmWGVRW6OQtk+QSxI1A/Mxphyc582YSZgkq3rA6RoIYJxvdNFaKVtlf8ZXqcH2kCGzOaNDMzLM5uAw3IBhV2sV5ck1wQ4VrqRGm08TCdxyzonaPeYS5luUifL2qptDrLCVQiLZ9J7JEehGpTG6QmskWq0zYDdBMd++mX5oPNMzdav7QiD4j/qUzFBhl0K7/4HWDLr1bmQQRANVQ4+RoA+eMzmzpAS5GqQAE/Smv7DrxE5R
 WTUQwQdK
 TEgm4a3HGB+sIB3JxX8FXjLMQ8mJJqzDdGpi8cpRQyeSPNYIM5TAzJzc9wbcovVoD3U3JXAHQp4QR6q1CUwDNsKo3wB+Pz5Reve/UeqG//omKY9+sYEZtsWhnASV1AIIzQZGlyrZ6pEmXVRLbs9b1+JpemE7uhWibV15a8XB3crqSo9KitQbfIrss8oWm8P4oulXKafQFwBgv1Mya39Ap6FMPbh2Y8An6BdhyKlNl0Y5frXfuTxq+oY4lMfu+qta3APo4EDYE8Pns6D7V/Ruf83IUzyujdKOiMaYpvz9CYnVMPbW3erRP+6xwIekXf0OQndZzlcTVM5MU3FOtq5vHYA/8g5iiRGHQkyGMApg4rqagwcUpAy6D1L5r5fKlGKNcOs3w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/3/26 14:16, Nico Pache wrote:
> On Wed, Jun 3, 2026 at 4:01 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>>
>>>  next_order:
>>> -             if ((BIT(order) - 1) & enabled_orders) {
>>> -                     const u8 next_order = order - 1;
>>> -                     const u16 mid_offset = offset + (nr_ptes / 2);
>>> -
>>> -                     collapse_mthp_stack_push(cc, &stack_size, mid_offset,
>>> -                                              next_order);
>>> -                     collapse_mthp_stack_push(cc, &stack_size, offset,
>>> -                                              next_order);
>>> +             if (order > KHUGEPAGED_MIN_MTHP_ORDER &&
>>> +                     (BIT(order) - 1) & enabled_orders) {
>>
>> Why not a test_bit() ?
> 
> The test bit is at the top of the loop. This adds a exit if the lower
> orders are all disabled or we hit the last order.

Ah, now I understand what you want to do here.

I guess you should add a () around the & and maybe add a comment.

And likely using GENMASK is clearer?

/*
 * Continue with the next smaller order if there is still
 * any smaller order enabled.
 */
if (order > KHUGEPAGED_MIN_MTHP_ORDER &&
    (enabled_orders & GENMASK(order - 1, 0))) {
	...
}


> 
>>
>>
>> But, wouldn't you want to skip orders that are not enabled and try with the next
>> smaller one in any case before you advance the offset?
> 
> We are currently iterating through each order (not skipping them).
> There may be optimizations to avoid iterating through every order
> (like your changes suggest), but currently, every collapse, whether it
> succeeds or fails at the bottom order, must also iterate the offset.

Right, we currently miss opportunities to just skip, that we can optimize later.


-- 
Cheers,

David

