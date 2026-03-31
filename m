Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D7C8FF60EF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:04:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1E516B00A9; Tue, 31 Mar 2026 06:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5756B00AA; Tue, 31 Mar 2026 06:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90B3E6B00AB; Tue, 31 Mar 2026 06:04:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 801C26B00A9
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:04:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 43F2A1B9333
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:04:19 +0000 (UTC)
X-FDA: 84605923038.22.540CD5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 43DF5160011
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:04:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AKrz7BsV;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774951457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nv8OIY+mrt9w48oCp/LRbCSmlFF+b3FxCBoqhWRNVb4=;
	b=kPaHQAXRAuA7lId15/B+/iiH4wQtITOGhuQv1OJfl3hq8s+jvwGrbdkHTL4DhglUunYVGG
	bgF9MEDv2qgmZz2rgFFSvpdU3BazkkVlODnqXIacJZX0kw+e81NNE/0y+rBsGjMpGbj5Dp
	dYwaQskYJkUvr5I1OtP/Y9rv+3MfNkM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AKrz7BsV;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774951457; a=rsa-sha256;
	cv=none;
	b=qZZZvoVxoz9OiRKaYk6N82SAIieeSeXly5q3wExPIB3TpzIMkZiWQ5g/K5XvVGo1oLrUs+
	bjfj2fGsl5I25qxD9BlMDQQI0ri6sZ8yIBmaHvs8VtXQQ809iHpI7fUgSWvXZ5FO8E5BKd
	RhU1bsu7fPDqNQq/rzdl4LJaJTise7I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 407BC44452;
	Tue, 31 Mar 2026 10:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88CF1C2BCB0;
	Tue, 31 Mar 2026 10:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774951456;
	bh=49PG3nZl+98TuRwZIqz1zYmsoSpDs17xr568qzu1Eqg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AKrz7BsVVtgchEJ5poESGGoOf+5w+YoDmJiFZdfkzwcVyuGrSfpS34jmPqTXUbdsP
	 rrQaziZTzHRme5MaFUI7WpziGeuA2L8OcX2eMOi+zDrK2ljlRtAgr/C+uJn44rv1H+
	 m8sWmAapRcDZAyBJXa0M8j+v9RG4n5DiB04iFsvqwVYqKOYIjropUlljZ3SezzYE3N
	 LOjjeKz9bnI20Nu5H84DlpXk3x0cqCXfcuLODJNjmSLhiTnaBy4fWmLm600XTfI5Qr
	 NF7lRfR5azYVrL1aQAYyNklSJrDR6nse8WDe9OsyiXR9wBsj33KZwMIFjLBKzmDYGd
	 NBGvb6rxjG5bw==
Message-ID: <7dd35e65-e0c2-423d-a82d-c9e488e85e33@kernel.org>
Date: Tue, 31 Mar 2026 12:04:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] sched/numa, mm: Skip page promotion if cpu pid is valid
To: "Huang, Ying" <ying.huang@linux.alibaba.com>,
 Donet Tom <donettom@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar
 <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Ritesh Harjani <ritesh.list@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ying Huang <huang.ying.caritas@gmail.com>, Juri Lelli
 <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>
References: <20260326071216.11883-1-donettom@linux.ibm.com>
 <f41ab7cb-4430-4338-8812-eb6aa98e9bf9@kernel.org>
 <2b8f30a6-a8d1-4ea5-8078-5eec399c8609@linux.ibm.com>
 <87cy0kpfdx.fsf@DESKTOP-5N7EMDA>
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
In-Reply-To: <87cy0kpfdx.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 43DF5160011
X-Stat-Signature: e81fatr6fxoaaqiudr81xkbmeucj1rpq
X-Rspamd-Server: rspam06
X-HE-Tag: 1774951457-230472
X-HE-Meta: U2FsdGVkX1/ZBLvfqRilFbikndn0lq6MMQcf7TUw1EEn2uegQLADtljQuA81GcMwhv9dNKig0uxVpSQVdBrJqn0jjUfkt6DFiuNaUjuoD8zuvkdpB72G43UfSNOn8vBnkJzfpZ5DayXpo/HbJ0nQUa7Q1mm9r9zY/g84Sy4j0DWlzBwWDZsfPEWNYrDCcV2Uz8TGFMbPP0dg0wryvd6elJmWbGd1/VSDxlgVULXOg41rKiC3buX6qcQpQfPL9CQMqfUAqGBfprtiydxwKmrWKz9nERJpUdCl79SwauBvKeR7J9mNrJjD3dlwAv/oZOUc0tDc/+vSpJ40mfhAV8mJIC99nyjuMuAlsolj3nJFYfgdMtVJwzrDJFSGITXHPSAlDM0GFnJSqNxIE8rkNO0y1SYee8ppTSkFVjwGsPmPBm7AYnlwbM0Ei5qhMFzqvKQfgBDDqWZn1INt54Ai+NonkCdSq8YehqF8vVwI7iRIB8M3LMCrqgvd1x8wNeR3X7f/7RGNJZ32qIiGdLZ2+41D11crPz9wN1vdQuBoob0R5ebH5qV3Y5iREsEGdMzqCVOqWznd3dWBvFZMdA94/c+yO6bp3VcLgKqqi/jXtmzfcimLQQR27p7+aumTlqhHOIXf+UdyyYVXH6JOzVMvbJnrlOvsw3+XDe7LNBVaP1dotSfSIMfCbxI4/B8VE4bS4DEOYXTvbgLs3Tk88GoWccJQcVQ4C8OK38gX8AxE3lbG6/Sr9J9T2FNfppgL1yz/kz4uC3lETGpyIhNH8dDyVGOAB4jSJsxeLBOsM0iOQl/M0qKEtVh/X2zmDgRcJUzB2gDoGUDi1Dghz7Gi1KyUpx2Gw6GEQcmPes7vUcF+5OYr3Qo95eRPbfdzWRfq2rxZ5PLTdpgxD58K4tAK/SmMBk0pyHnj5FXrqp6t2hzT3iTyEwxdpLxQ8bq35Xuc96WQ2obGavr+jD5BGM38OUkzWDM
 hnUyRP+v
 BwV+BLZ9ZKjYK7gGEmdgidiQWqoMBFRebsMvptBxdvDDgMNx8Vciue7Wp4k7e18KpToDVbVKt8T/Qy9OyHewnZuZYkEv2zTmB9t2rN3KyU3jF/ToHsoECaB40OpDnBX8pstjV6d3TS/+psm2jmYsOY5imnRfWFiI1EaQXJrk2umBHCNS/4O4SjncX3CFrJYCekwV/ahM/C/7hEVhIzPW0yXis0dZOa4u3w/ZfU4GBjZRnShYUNU+cOpiwBqaRUbW/s09XQEjiKKPHDvBqV3MQrlmp5MWGS7PMFEQYNvQJRMpaCtkkcHf7hLOhBvQHP2VGjKfC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/31/26 10:33, Huang, Ying wrote:
> Hi, Donet,
> 
> Donet Tom <donettom@linux.ibm.com> writes:
> 
>> On 3/26/26 3:59 PM, David Hildenbrand (Arm) wrote:
>>> Is that measurable? Should we at least have a Fixes: ?
>>>
>>> /*
>>>   * When ...
>>>
>>> IIUC, as timestamp we use jiffies_to_msecs(). So, soon after bootup,
>>> we would no longer get false positives for cpupid_valid().
>>> I suppose overflows are not a problem, correct?
>>
>> Thank you, David, for guiding me in the right direction.
>>
>> I initially thought that overflows would not occur, and therefore
>> cpupid_valid() would not produce false positives. However,
>> after looking into it further, it appears that overflow can
>> happen when storing the access time.
>>
>> The last_cpupid field is used to store the last access time.
>> From the code, it appears that 21 bits are used for this
>> (#define LAST_CPUPID_SHIFT (LAST__PID_SHIFT + LAST__CPU_SHIFT)).
>>
>> With 21 bits, the maximum value that can be stored is
> 
> It can be less than 21 bits, if CONFIG_NR_CPUS is small.
> 
> 	DEFINE(NR_CPUS_BITS, order_base_2(CONFIG_NR_CPUS));
> 
>> 2097151ms (35Hrs) . If the access time exceeds this
>> range, it can overflow, which may lead to cpupid_valid()
>> returning false positives.
>>
>> I think we need a reliable way to determine cpupid_valid() that
>> does not produce false positives.
> 
> Yes.  IMHO, false positives is unavoidable.  So, the patch fixes a
> temporal performance issue at the cost of a longstanding performance
> issue.  Right?


Could we set aside a bit to indicate "cpuid vs. time" ? We'd lose one
bit for time, to we care?

Would make it all easier to get ...

-- 
Cheers,

David

