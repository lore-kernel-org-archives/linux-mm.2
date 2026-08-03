Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F1CCC55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 12:57:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 852A76B00B3; Mon,  3 Aug 2026 08:57:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803C56B00B4; Mon,  3 Aug 2026 08:57:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71A006B00B5; Mon,  3 Aug 2026 08:57:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5456B00B3
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:57:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 436A212063F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:18:26 +0000 (UTC)
X-FDA: 85059407412.02.8164C7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7D350A000F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:18:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IrdoSGOU;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785748704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xn83HI99RLRyM9dqp7AW3fodbu0QXo8i20/TewQSCBY=;
	b=rz0owRurZpeS03WqoQtANwCIufdT5ZDou4OMoVDlRd4NUogKEHMfLKhrkylxCKdsLMSnKq
	QFCslgj6+rpJ9lmCsY4h/BQq2zr8U4flr58C7Y8B5iJ+Y1yDgegPXSTZumiA3+CJj4qTZt
	RTmU+3cgTSmT+vpWJLOaoxth8XTtNm8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785748704;
	b=xgTYiHx3Et+jooiQdlZslFrRsS6fRktkk/F5yz1yzhWquvTVcoM012D2ioHhaOLA85nbNY
	QPlGlaWig8ImftPMG3EG5lpAZEwLIvct90x85ND9ZfagC1TxckJqtkQixcfBlD1FUwVSYL
	lR11uJWSWd5P3Cxyq7O2ia30d6G+g7Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IrdoSGOU;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8928E414CD;
	Mon,  3 Aug 2026 09:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF211F000E9;
	Mon,  3 Aug 2026 09:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785748703;
	bh=Xn83HI99RLRyM9dqp7AW3fodbu0QXo8i20/TewQSCBY=;
	h=Date:Subject:From:To:References:In-Reply-To;
	b=IrdoSGOUS0xaPyg8WtkUJkOsN2a/zrc6MvPRN+6nBMwQUfWmqunWVRFyNm4Oz5NPQ
	 t8lwhdEtaflQhWnAB+iYx26+VKdhh/zqF8PhOeydSCsWofdNfNLgCOB4jDOmAL7c5P
	 05OquVmtuWbMYhVw096tU9tL2Q2OwC31WH7LNbOtw+jQp/Yn1tHTDCznKmNNTQf6HV
	 z2xNfHM6kKwO+xJr0onXItJjpe08nEo45cKobjImwhZCQO40kGv7XJlExgQwcaHXqk
	 6L6TP5z243QYVWCJZbRSoZcbv1UTAsU0xRH7YLoj3jRioGF362hCTH+5eKeBA7TQC+
	 +0H2K9VDucM/Q==
Message-ID: <f679cc17-643d-4c39-8bfb-9816e5f4b5a0@kernel.org>
Date: Mon, 3 Aug 2026 11:18:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: TLB free bug in 4c640eb4181c ("mm: move pte table reclaim code to
 memory.c")
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>, zhengqi.arch@bytedance.com,
 "Liam R . Howlett" <liam.howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Linux-MM <linux-mm@kvack.org>
References: <CALCETrXbj__SFQMzPZhES5y6-sh4np-ZHY5T_=4QY5+Fn8BM4A@mail.gmail.com>
 <f2eb26f4-62e2-4a16-a56b-706adf230cb6@kernel.org>
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
In-Reply-To: <f2eb26f4-62e2-4a16-a56b-706adf230cb6@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7D350A000F
X-Stat-Signature: jxj3mtbiewsweir7urrb4c83tw4o1tym
X-HE-Tag: 1785748704-510654
X-HE-Meta: U2FsdGVkX1+IcU/hACBqzEbuovOkinla4KbsLx+1Sc0nEzBYrLPkrScMGyPREEUO/XHsi/kJaszveJpKM3I+YU5dAYDdtTrr/4pfc1yldlcAXRwS/Bd2xroqiM27JALDJBr/WN5xys4xOPbYLN0O3+LJo2BF2CoUC0l0q0V9bOF5YLlkNnxLglLsuxJH1TgBq2coM9CaWbTvXPn7xE3FDqYnmxiqah55ozWduphqlv3WjLbDZFF/Wu6RmuLu8E8Zqj4bTDM9hhpKivhjogkksmT7ETCWcc2OM1sMEHcoj9r56wFPL7eJhQ7EqmEL3hNzEGoKrogFIDI5P6MxQ55jP49ozzpYPwn25gW+WXKU2jQNQnL83dAT7ujUNo7xxNOsaDi7JQOQsrzRihaP2qVsKT3/nkZvuvSv/mtcpKy/d0Oyt/n5fbthhvuJbOd15BAxVnqu8QdkJJdJaQkAGwnenzv67b1dmuAhAl+ezLVzqfurILjNaqlLChp4175d5UIG5a3tJsB74sdrnW5Xdj808hMgzc9KuOxjXVKvelJu+4UPo0hHK5LvYl4HPuoE62K+WCOdEaReBk9TSLEGZdz7DdW3v6WD79JN2o1KP94+kAE0eCNe5KoaHMPJnjZhYoLZgehE24iOpazeBJGeOjf4k8CdVPNxyawLsNEPeFWwFkOVuh3RNvz3SsAJKo49WHAKod3iI44zT2dinkTJIkTkTTLGouDaBgcRSuYQhe3q9opGwcsx1oEYWrPh+XgpZtO6ZIF6nhaRRzdT40+OZWZGeKC3FqjDJua/CJ/405241o/HsOSCAaZHzsm5kPGRSbWtheFds/GNYCKOZBoivCX/72ZHhJGyior9G8uShg1mBqg9TcBH3PbVzW52fdrsKgbVbcJfj5jc5Jh0bG1T28VGGZWM/kIHeVO0FhEJfZjrfIyL0IaenA6sw1ri3zCoS+UZjSmLoCRuRYnSxYEFt6o
 TJuY/YIL
 BkP2e59BEcHsN7WtnmFIOpti81BP5CsugrFFYhedKvWNAiGaL3U5g8FUEhPDVCW0/TuCuvi4nXNQQnSQQZyf+33q7jilcZR9B+awskrKTkwea5wjmZ2A9azWviy91fW/KAesgs5ldqJuDRdaEfK4AvsuiOV6t0ph7+m/dYdXXnbdj8R2I52pt8UfvVQNglvbLCoDxuqJ/aiDPo2l3LfLQGZu9hL85VisA/vV/9JbRLA6sJ3mPuyfp6sx1I+aNdE2H3jJmd4zPxbmjqmfNnx9iXZZLvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> Original report here:
>>
>> https://github.com/BurntSushi/ripgrep/issues/3494
>>
>> I haven't sent a patch because I *still* don't pretend to have
>> followed what all the tlb_ functions promise to do, and I don't want
>> to submit a subtle patch based just on an LLM telling me what *it*
>> thinks those functions do.  I could trace though all this mess
>> manually, but I bet that one of you actually remembers :)
> 
> The memory.c code is definitely broken. I guess the real question is,
> what the effect of that is.

We should end up in tlb_flush_mmu_tlbonly(tlb) -> tlb_flush(tlb) ->
flush_tlb_mm_range() with the wrong range, so yes, please send a
fix asap, thanks!

-- 
Cheers,

David

