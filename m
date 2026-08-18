Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EBBCC5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:15:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B5556B019A; Tue, 18 Aug 2026 10:15:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53F226B019B; Tue, 18 Aug 2026 10:15:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B99B6B019C; Tue, 18 Aug 2026 10:15:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 077EC6B019A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:15:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 844A81C0CBB
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:15:40 +0000 (UTC)
X-FDA: 85114588440.27.0A2B4F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id A92EC10000F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:15:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J4txqm8P;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062538;
	b=19ms+CvF1K+9RK/b11xd9DjXsjMllb5CR30PkTXvvIlnlqwTcvDvCj6fYUEPGjzlhkANg/
	Nu7FHrvqALTa0fe9ZyUSQCdnizzPpL77ygKMlcEntbqOWSNivaoONltKpj3x1N91zJRh/X
	0EMuICFP7KVYhf9cHB0o6eM4UG7lQEE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J4txqm8P;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qx7Q9Tkm+30Vy5GpQNpuwA2/ZGcx6zXr2iqGQrjyaow=;
	b=oqI7AWDtD418KkKZ1EURrbnyZjduiswQcvIB5869QQYRn80A3t+g7x9v1yL0Oesrg0QLSE
	Y1uXhxg1m4cyiRsbE09yJG5dyOLvyLhyVPKO0KDs5RDQhJjgoH7RTM5lz+tQ/NaeedcXSC
	9WrA0BZB2hoCojDgI4VKb0k5ItoCmFA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3245260204;
	Tue, 18 Aug 2026 14:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528441F000E9;
	Tue, 18 Aug 2026 14:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787062537;
	bh=Qx7Q9Tkm+30Vy5GpQNpuwA2/ZGcx6zXr2iqGQrjyaow=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=J4txqm8PSDHPtAGQRTxTA5BirFk7+ogzhOIXx818dDoEykvFj2mrVFD5zdFYcfFJ0
	 /jprkZRDFxQc8+QCcmNb0ApwCPKRCXrDv8FdOKGTuzZSBcmf10N4ZNE2LUmmbewdbR
	 j4nU0aKvIRwA6/P+7rKRyvxb+WqvxxEYHHG++dyYmXrcmPJ4wvxfPuZA75WpgPVgxs
	 f0B9a3AoNrZyoj+6NB3OnEml7VuMxDNvR+DUcxVjWZC/C0Sw9hEPBcvxjPfQATlp3A
	 n0QvsdIbuzJrd8r8lo//noi6umHRcuvqsDdZ55Q9yQZXT5rNReYRnMfBHGHAV80cYT
	 U4t5de0eRoHxA==
Message-ID: <99138bda-55ba-4c58-9b79-b76e9daecdde@kernel.org>
Date: Tue, 18 Aug 2026 16:15:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/57] mm/collapse: rebuild collapse on migration
 primitives
To: Kiryl Shutsemau <kirill@shutemov.name>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, nico.pache@linux.dev,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
 rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com,
 usama.anjum@arm.com, agordeev@linux.ibm.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 jannh@google.com, willy@infradead.org, pfalcato@suse.de,
 rostedt@goodmis.org, mhiramat@kernel.org,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20260816224609.308019-1-kirill@shutemov.name>
 <aoLAly-oL2OAa4n8@lucifer> <aoLkMUtmzRVuv2Hx@thinkstation>
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
In-Reply-To: <aoLkMUtmzRVuv2Hx@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A92EC10000F
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 4kcmrwogwj56k4a6u17ho69emjrsxbm6
X-HE-Tag: 1787062538-778333
X-HE-Meta: U2FsdGVkX19bCoXtBTqthGkuZhiel6JwO6RhkRvWT/nuHH4oj304eGljtq2ut4bjaogSTn0eQyjM6YhQ7ZhZPClAEjTFc7pU5uf9uN8B9y2gBxq2e1vDWkhKCN5u6tV05B5Fn1ax3qMgZru4xT9iuBsUm/xhbBCFEYoL5JQN2lzXUFHWwZaRDK6jyIwEi8ZmAaBxg1D+GBc8/BghOKAsH7X0wQLjAi/EXsIpuxsLkcWx20oPmTUuqkf1NM/rOcavlk6rLFscf/+lUb+QZir1QTiAaYCs6tuAQ+uX9RiBGME0uqhvSrCDYxACvrhshPXMP7eQwu1/vIeEjEE6Xu2j+v3Yb8TYTdMBwDkGvRNwBasRRKQn2XCIAJOuON0bwW0qC+GOS80nq50oZyTaU9P71g2SfVVQSqbKqRPp7jKT+1YyUbIo35kxoU5NT8Ute/AFU/lffaxeYu4LRnP0Xz2R5L1jlye0qqic3x1MdDHRdUn4/plzoGVMCq3hLAJVZpwHqFsKIOd2+J77tbnivMRTIxGmqd4oHB1wbqnRbG16MYXsGvYTPeous7P6ounGxy73/tMqrRvGrKC7OcVNmjf4pydKHrKHdJ4ZsZthBLSQnlUKaZWLAP0K11zUEI8vp9opFH203OsD0SLUKVMtuPz4M2IX+pctP2XO/gopgMC+uNdE4UFCDY7TODE7aivI7R6q/aaAUbfqNAFK+udvcutkVgSmYIcFBiTG1mwhKbVjzxofne5onB+MqrCOQexIrc0zqpMmtGD4bL65UT+zy2QwYGuEj/7y/VxKBV3nWUgDL6a+hwmhq0N6LHUIHnajgTHYJfsfewM+JNf1QE74xOL0O9Mhg7JmS8s2a9b4mq6NjaOXq0JYPex3m0RpZbHRrr9tA/Eu9kLjr1dMABNqPaNaf2t6zeCTuH0QFquwpB46skqpQ9vBg9eAC33ZQzo+p0aizLxfQSf+cGTVoAW7Kul
 rrnyc/Y7
 nzQ413mYX1oECU8KUg3UQgll9AwW1SWgUxmEjYaHlDXX7snx/+kQtdD2oCbH4uNuuK4njNY7MwXDTwCjGh45fokZF06htaxyc+/am+v/8XFyYBgR9+2NpMtYpo0ZbCjsCjhFGsQireKNbIPBTUYdCOKQ4/1EKbDhycFBVue6jKNkOgOTwuzfP+zTZ1zp7eZSy1aybVCBrv0J1N1KthkN3Gwv16pHuF/KOav9KI/vpdvMsfAxDlhmmGDoSAwpS4K469HYu9dPmeYYRy2VOe54Nm3WMRQTS5IrgffYnM17bc88wNN1FcFweY5v30A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/17/26 15:38, Kiryl Shutsemau wrote:
> On Mon, Aug 17, 2026 at 09:52:13AM +0100, Lorenzo Stoakes (ARM) wrote:
>> We have a THP cabal meeting every couple of weeks where it would have been
>> useful for you to raise this first.
> 
> Fair -- though my invite is on my old @linux.intel.com address.  Could
> you forward it to kas@kernel.org?
> 
>> In any case - this series is not something we'd consider at the moment,
>> even broken into parts.
>>
>> David and I have put THP into feature freeze - until the codebase is
>> subtantially improved we're not really interested in seeing significant
>> development.
>>
>> The technical debt is substantial and has to be paid down first.
>>
>> See [0] for a rough list of TODOs in this regard.
> 
> I read the TODO list and I'll pick from it -- though I notice the
> technical debt section includes "Literally all of the code in
> mm/huge_memory.c and mm/khugepaged.c", which I'd argue this series is a
> fairly committed attempt at :)
> 
> One clean up I wanted to do is consolidate code by functionality, not by
> the THP/non-THP split.  Move all page fault handler code into mm/fault.c,
> unmap code into mm/zap.c, fork's copying into mm/fork.c -- mirroring
> kernel/fork.c, so the mm half of a subsystem sits under the same name.
> Large folios are an integral part of mm nowadays and I don't think we
> benefit from keeping THP in a separate file.  It is also an opportunity to
> shift away from mm/memory.c being a kitchen sink.
> 
> David and I talked about this at LSF/MM. 

Ah, I missed the context in my other reply. Lorenzo already had some patches at
some point to split up mm/memory.c into better chunks that will also better help
our subcomponent maintenance model.

I think the challenge is how to handle huge_memory.c, because ideally, we'd not
have these stupid callbacks into huge_memory.c once we make PMDs just a
first-class citizen.

This is, unfortunately, also something that needs more thought, because we don't
want to end up moving stuff back and forth.

-- 
Cheers,

David

