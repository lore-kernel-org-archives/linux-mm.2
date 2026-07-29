Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FC25C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:18:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA44B6B00E0; Wed, 29 Jul 2026 10:17:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B53AD6B00E1; Wed, 29 Jul 2026 10:17:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6AAD6B00E2; Wed, 29 Jul 2026 10:17:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E9CE6B00E0
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:17:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D239540658
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:28:09 +0000 (UTC)
X-FDA: 85041287898.18.9DEB7EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 237EF40005
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:28:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X3tXrVQw;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785317288;
	b=0QmmlVig27hVgtyHtL30u0qyv3MLw+5QE7M9GcSaEwS2ZuU4SOlvTqerXIa0Hpo4trqqbx
	YUVTpd7rY5WHjPgRU8lzxfXOiZ2MOesdMT2F/UJCZVdLqouY6Nho28GsvMyjDiPxZ5S2M0
	POqYSp9ax8kh2ZhYvkks6QqZp6YIjFo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X3tXrVQw;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785317288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=salgQx0zg68IGEBw4oYDljPNqxYepuzSJBxYIsFQ7as=;
	b=rBxFBzZeiL3ED7bReWEPsprOXaVmamO1Tlwdfcl374ziFpjDzzoEwhR+fMLK73o7oVq9xh
	f22A9N5Q1ueIhOGJjxqGIl3pyb36GyHmlTQk472EIBt0h7oy/mpq8QxNb2FwmtpIdacGt6
	KGm9BQz66xB0XeO6H8xOKVQUNDNPgyE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DB51D60A66;
	Wed, 29 Jul 2026 09:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65881F000E9;
	Wed, 29 Jul 2026 09:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785317286;
	bh=salgQx0zg68IGEBw4oYDljPNqxYepuzSJBxYIsFQ7as=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=X3tXrVQwuuxI3PfEgO8BALfQdgGKLhyvvicqZgQVGYlA2y6wCjR6m3JrM2mYPYW0b
	 6O+5/VzLaIMg56oDPvd0YtZ6hZTtV8+CoIMjOei5Xur1IrWfg6FMSQLsqWflDXPwlU
	 aAlFjOTy1+y/JzMBibjA0eHPHGYZLy2a+ujtSdVeOqU2cWpo08+fNGcFWehaJk43I9
	 ODb/WRJWjMiwNA1q/2rUa0z45XSkHlZzZLcO/YZOi+xyeji+m3Rn/WQWHVGEN1kEWm
	 lT8GjTw6ybgCRjqKYA5eF2hqwmtMqot3mq1ymA20whFGpZrAVqvOLyQbRZcX3aJhl2
	 n2F/MpYxPeidg==
Message-ID: <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org>
Date: Wed, 29 Jul 2026 11:28:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>,
 Mark Rutland <mark.rutland@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>,
 Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org, tj@kernel.org,
 urezki@gmail.com, catalin.marinas@arm.com, will@kernel.org,
 akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com,
 agordeev@linux.ibm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
 <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
 <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
 <amCPBrdltFSE_fEf@J2N7QTR9R3>
 <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
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
In-Reply-To: <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qdgqdc6w9cff8eiw9wshqu1sybj6sz8d
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 237EF40005
X-Rspam-User: 
X-HE-Tag: 1785317287-915975
X-HE-Meta: U2FsdGVkX19aBLGpIvj8fa1Oogur6SkeSpvsC1DLLwBbQm1KZE1cDoP19s7k5c4b4UHU13XhUBTVeoSy5fEzkykdnKz5hBnrNDOmWQqyEEaifp91fa3mJgM5scERBC4Np9x+1j8jCriy5j77SOZm3FyTthGgja2tieLG9TFOoXrUHcfXiXeRkGMEMStFjeurmM55IRf45rf5/E+eZI424/NQZWVYwVxTtkQC7frM6B3VCxCorJDm6okrEBqV3GFKcsONcYgC9Cssn6+4aV5XhNAzkRZmW7VwvhBtZPc2KXHRFayKIiKLZlbYyWFpCfa8H4nbOLYCDZ42g9GVuRQN1rWYFTF4pkbyBiz1M8NN6TPNRaW+0Uf/uCr6Jo0ehU0wu3TDWkG5EeMlxaRUqkkpzMflEzDv5MOHO2juipWeOPWa0RVDLHyZpBURdUidpPYTdlf7gWQuEYlUV+32qFn3HUXDXfEBWYF9K7iOJeMPSb/6+rcuetOiChtvJRpBBqTpfvgdxVaQkwWpy6BalGmLhrZcgUQ61T2dACCbb3UiMCth6eE+HGuDf04SJjEGb6HMaJ9KPcLYvwvHbD5aV/1a9xHegwctH2L800QCGUwdskmjUHR5I/tbQ7hQ/wbnmAHVWVCctTeUEOgMIN0PCMfMAn4sJ94sgwn5BJzM6ox2JmMdH0T/32hBgad4RGG36RBVH6PEsAtQB8iukIdW7ef0ljzZ304nqG2VLvJhg6TBjINDH5fdM5Wz+znpzegs6J+77uI5VFHJ3G06aXDInah7cBwC8smhGvDA5zz5wEsbF71aCZW8T9nDgD1m/C0IiCEWpzvAH80lZTpbEj29FnUFTzW+ko0wgDVmoUzLdEai87CmHE3rMehOS2s44myzBCIKctdXFijcOp7x7pAitNLVHsMNMKVPqzXMpaHJlG25NNVUb2nPh4lGgvmAu538EJn8e8shATBUSRTuDKFucW3
 8vYB+kNZ
 kcXEnai+FMGly2ks8aigWleiEjXhN6CAOog6nqb7+tLpD87D7PCUj685yp9Q1hlW9DEDeMEQW8qrqNvLpeTTy0L0WQ2kraxPyhm0O9EL7kF/HMSm3D7Fmt+hAvzqilonpsoqIKPAmmhKESBRUz88TTsF3epVHvGhMv2NEdZtxlXZCvwoKLFhciO5LxhZntRF309wKU4OlnJCOlFgLMK6tOd6WHFGa32GTQvBimSpXNIz1FDw63qQGI4E21tJqTQKXab4SohUYMo6vvVs2BmZ1lqcKZPm4KH+U7L6ndgiDJRPZeTq8hD47eBhm7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/26 00:06, Christoph Lameter (Ampere) wrote:
> On Wed, 22 Jul 2026, Mark Rutland wrote:
> 
>> I expect that should come with a reasonable benefit, but I don't have
>> benchmark figures yet as I haven't finished converting the xchg and
>> cmpxchg implementations.
>>
>>> It sounds like it just moved the cost from one place to the other
>>> place and it also seems hacky TBH.
> 
> 
> Yang Shi's patch has *no* critical section. There is no additional code
> for the RMV instruction. The RMV instruction is executed on the correct
> per cpu area. One of the reasons for the performance win is the
> eliminattion of these critical sections. Your approach still has some form
> of prologue and posthandling like the current preempt approach and
> therefore will not be able to have the same performance gains.
> 
> The code is more efficient, there is no restart necessary and the
> technique is already widely used on x86 for a long time.
> 
> Having the ability in general to map mmemory differently depending on the
> cpu opens up a number of other optimization like
> 
> 1. Per Node areas. Calculations of addresses for per node data and RMV
> operations on per node data becomes as trivial as the per cpu data
> handling. This will further reduce and eliminate critical sections
> currently necessary to handle per node data modifications for NUMA
> configurations which are increasingly becoming important for large core
> configurations on ARM64.
> 
> 2. Kernel text replication. Kernel text can be replicated per node or
> per whatever memory is closer to the executing code. This avoids transfers
> via the on chip memory busses and increases performance. We have seen
> 20-50% on that one.
> 
> 3. Readonly data replication. A similar approach is possible for kernel
> read only data.
> 
> 3. Read-mostly replication. This is a bit more complex and the writes
> become more expensive since updates have to be made to all copies but
> a read-mostly variable is rarely written and the replication will reduce
> the latencies to reach these variables.
> 
> 
> 4. Custom sets of cores that operate on shared data that is replicated
> per node or some custom set of cores. This is for example
> useful for network devices that have the ability to do I/O via a split
> PCI bus or other construct where I/O lanes are duplicated to sets of
> cores.
> 
> 
> What we are proposing here is a basic new feature that simplifies code and
> allows addititonal performance and functional features that are so far not
> possible on ARM64.

Most of the features you mentioned above are not supposed to be
architecture-specific things. IIUC, Linus strongly objected per-cpu page tables
in the past, which suggests to me that such an arm64-only thing is not the way
to go?

-- 
Cheers,

David

