Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD722CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 03:05:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2571D8E0013; Wed, 10 Sep 2025 23:05:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22E5C8E0010; Wed, 10 Sep 2025 23:05:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16B9E8E0013; Wed, 10 Sep 2025 23:05:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 06E0B8E0010
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 23:05:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 950CA119A6A
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 03:05:17 +0000 (UTC)
X-FDA: 83875478274.23.0FB5721
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id BDC55C000A
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 03:05:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mq1KZfJy;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757559916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9T9VUgZB4FkXCXqmZCRFSIgZN/NB+DPn0gz88Z9lruY=;
	b=rKsOw5qpvZ0xFsBsREq9mEDqOi8H2juHk23AnM1tJ65ct/T6pVehGz4P391VKNCJpxwVI7
	BqIZrhm+ynDfot0WqMYUuPgKAyH499s+Gh4Xv/OuEc1+jWUGkMxg15OWxuRKwVVq3YWPD+
	g66nT/bLty0G7ztcBHUEMAAdQlm/DZE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mq1KZfJy;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757559916; a=rsa-sha256;
	cv=none;
	b=1RmLJW5wdVY3b1gbq5KttKZiXSL4K+GXFN6mQRFYHoqwFLYeHinAjlzNIWP2a08G6Y+RQJ
	ilQqaKboGEEvSb3Sex/6SEHMsbIPHiTDjYJpbh+9cESSFTk91qbsO+2pIPNVQeQcGDRduE
	CTvXaEp4QktlZU5Y2ozUiJgJEVLWh3A=
Message-ID: <f1b2fe3d-e8d4-47a7-b369-ee826fec0e7c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757559913;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9T9VUgZB4FkXCXqmZCRFSIgZN/NB+DPn0gz88Z9lruY=;
	b=mq1KZfJySR1GsrdLS/vyU1/YzvGVT859oA5mxcagNE4baLrGHdnZHnTOwg/0IGaV075piA
	RATnyx24do8iwRkHvAEVXabMu0YLLSWSz2uR6KaKXiP+rxVO8WxCS8kFcxHvsdzsaWlaCD
	1vz/9+SZQcqDilMFaMIE2QeNQD6fpLM=
Date: Thu, 11 Sep 2025 11:04:58 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v7 mm-new 02/10] mm: thp: add support for BPF based THP
 order selection
Content-Language: en-US
To: Yafang Shao <laoar.shao@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, hannes@cmpxchg.org, usamaarif642@gmail.com,
 gutierrez.asier@huawei-partners.com, willy@infradead.org, ast@kernel.org,
 daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com,
 rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com,
 shakeel.butt@linux.dev, bpf@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org
References: <20250910024447.64788-1-laoar.shao@gmail.com>
 <20250910024447.64788-3-laoar.shao@gmail.com>
 <CABzRoyZm32HT2fDpSy_PRDxeXZVJD35+9YqRpn9XWix8jG6w8g@mail.gmail.com>
 <CABzRoyYqGsABGVgXbH3Sts3yBsk7ED=BsKbcP3Skc-oWeFsN_w@mail.gmail.com>
 <ac633edf-4744-4215-b105-c168d3a734ce@linux.dev>
 <CALOAHbAfzDNdx5LTUhH+eMgVfdG35gAM5subeByP97x53=CWLw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <CALOAHbAfzDNdx5LTUhH+eMgVfdG35gAM5subeByP97x53=CWLw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: BDC55C000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: r7d6n76h9j57omy96m7uwau474kk6oft
X-HE-Tag: 1757559915-3604
X-HE-Meta: U2FsdGVkX198grcf/1tIQEubFvQvi5OhcOeUXQ4gxAXi+ZnjduQU9lFiUYSrhWcN0ku6UB+VI85kd9KCpSWhDvjj9v+cldkl+HkThlEfne62kLkc5ETqeCX2eHOsug8JaHgbvVdjiDmvAfKHUw/dRB6JYYnQ9spnB8kkQ1YU9+snbTwKbAf+0X+w0yRasIx4UPGKZljbO6Q6tqIuuxkvd7hcZhBq4zQRsChOLjyARyp3LvQSEP00uo439owCE1Jt4Fj9k24wrGlP3SdrWaO/zR7rda5t2MWEHZhSMcQY1qy4NmMrwfgGeMc8gCJizd9waqNOZ9kJ+bEGqrDmHb01KDRITkDgS89SLq6nasebrNt0aw+OZ3R178nwWJl80bLVRS4XwPLRHGruwsu0PYH3R6KKtgg4n8BUEUqUHL+p8O8oCPnRvG2oS+aX+rowiA8j3+0gPBra2yeAMR/MA6BjuYkupQXOVhZjGBeAQQha+2s5QUU01Pc35bICuEOLrxjYYxHPhSdEpWZ32i5/UYDuhd1tfo3Kp/vQQmta4b6b7kO32XAm9UvstiZ1xjgfcjNYLQumTuJ09+W4zDzSJNi3iFRQrhhrJhLvdE1wW6akSli9nJfQf75kNfr/bX5ERMwSfqiJ2tOQBD5XbI6uOAmHFmNHJ8PP/Na9y9ou48/5CDfUddM4L7ayjehp24AUl0wcvkwkgnB/EwtciBofy83mEdBhg4QS1MyDfsLvhVapb/3s5s/7OKjTYcJyWUUXRwVFY2NS3/KGGjXupZ5TaO1QVZZ1iTTeaPaYsPmSkCTcoXLgLal23avOqWh6kVvLUE0n3IYiiJ/vx49FuuyFx10EVxyd7j87ngsafisE1kJLH7aJ0s6wgfu7vBo1VORtfLwjIGNKOhyjLWDbHS2jN/AE76n2PfL0S7gB9L036t5AmDPauZ5qzuDyh9IVsB0yyK7onIo4S8cqIr9q3ekC8vb
 LI83lA/F
 xb4/64XAKjGrA7VJHOm4I/DHIoWL5IsO7lg0gGd0FWRDFG1q6kp5tfvBj7nvOD5/V8U5Q5XJWnFMEzs3CZCMjoOGIo9bT3XeJOEHTkSKs1+F4qGKvFK21XHCXphUIJ/8SQI3QgS9TmyEWOD495w8nnulmvzlsPnUTQr7vxd6OKJn0yRhK0LAcccnpAFByhKdUEHmFxRTwnEsysa3wgKYjXoe2Isbp7OZIX8Eay9AphUuFDu6olreFkbaY2Fmo89j4Ki+1OJiCdFpiRAef9d5uNgexggKTQGGwgJnYYFSGYSlNvHSYboo5N0ttR5BaCQazaYn7mRAzEKw/Wucxar0FyVsX/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/11 10:48, Yafang Shao wrote:
> On Wed, Sep 10, 2025 at 9:57 PM Lance Yang <lance.yang@linux.dev> wrote:
[...]
>>>>> +/**
>>>>> + * @thp_order_fn_t: Get the suggested THP orders from a BPF program for allocation
>>>>> + * @vma: vm_area_struct associated with the THP allocation
>>>>> + * @vma_type: The VMA type, such as BPF_THP_VM_HUGEPAGE if VM_HUGEPAGE is set
>>>>> + *            BPF_THP_VM_NOHUGEPAGE if VM_NOHUGEPAGE is set, or BPF_THP_VM_NONE if
>>>>> + *            neither is set.
>>>>> + * @tva_type: TVA type for current @vma
>>>>> + * @orders: Bitmask of requested THP orders for this allocation
>>>>> + *          - PMD-mapped allocation if PMD_ORDER is set
>>>>> + *          - mTHP allocation otherwise
>>>>> + *
>>>>> + * Return: The suggested THP order from the BPF program for allocation. It will
>>>>> + *         not exceed the highest requested order in @orders. Return -1 to
>>>>> + *         indicate that the original requested @orders should remain unchanged.
>>>>
>>>> A minor documentation nit: the comment says "Return -1 to indicate that the
>>>> original requested @orders should remain unchanged". It might be slightly
>>>> clearer to say "Return a negative value to fall back to the original
>>>> behavior". This would cover all error codes as well ;)
> 
> will change it.

Please feel free to change it ;)

> 
>>>>
[...]
>>>>
>>>> Also, for future extensions, it might be a good idea to add a reserved
>>>> flags argument to the thp_order_fn_t signature.
>>>>
>>>> For example thp_order_fn_t(..., unsigned long flags).
>>>>
>>>> This would give us aforward-compatible way to add new semantics later
>>>> without breaking the ABI and needing a v2. We could just require it to be
>>>> 0 for now.
> 
> That makes sense. However, as Lorenzo mentioned previously, we should
> keep the interface as minimal as possible.

Got it.

[...]
>> Forgot to add:
>>
>> Noticed that if the hook returns 0, bpf_hook_thp_get_orders() falls
>> back to 'orders', preventing us from dynamically disabling mTHP
>> allocations.
> 
> Could you please clarify what you mean by that?
> 
> +       thp_order = bpf_hook_thp_get_order(vma, vma_type, tva_type, orders);
> +       if (thp_order < 0)
> +               goto out;
> 
> In my implementation, it only falls back to @orders if the return
> value is negative. If the return value is 0, it uses BIT(0):

My bad, I completely misread the code last night ...

I see now that returning 0 forces a base page (order-0)

> 
> +       if (thp_order <= highest_order(orders))
> +               thp_orders = BIT(thp_order);

Yes, this is exactly the behavior we need. It will allow us to dynamically
disable mTHP for low-priority containers when we need to, which is perfect
for our use case!

> 
>>
>> Honoring a return of 0 is critical for our use case, which is to
>> dynamically disable mTHP for low-priority containers when memory gets
>> low in mixed workloads.
>>
>> And then re-enable it for them when memory is back above the low
>> watermark.
> 
> Thank you for detailing your use case; that context is very helpful.

Cheers,
Lance

