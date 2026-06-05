Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09C2CCD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 08:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 617AA6B0088; Fri,  5 Jun 2026 04:51:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C8986B008C; Fri,  5 Jun 2026 04:51:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B85A6B0098; Fri,  5 Jun 2026 04:51:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A5316B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 04:51:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 003C3140AE0
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:51:43 +0000 (UTC)
X-FDA: 84845240928.24.1CA9C48
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 432FD140008
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:51:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=de1zSMnq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780649502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IIeJ9iL/lDvJySy7dwtIphbMaPaW1rE4MmoyhmBkXhM=;
	b=V1d0oxHSlIMfMQ7q/s+ZMAKeuPCennEsVkpapzck6FIF2UJ14kyFbOod4JQJe7WAHyi5ip
	p8h8FppE8VbtiaVC3yx1uoC0gO+pFzHc3AIqzmFW4K6nkmoYfbT/12rbyEcWFBA229+UH+
	47f/0YvDY7UFwEdkkVNbOxaIan/hixk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=de1zSMnq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780649502;
	b=aFwUtTwuZYeoRb8kuq5LRvpCXce3wG/0ZCESTgciQ0MtvriJfgiRoVR2D16rnWw+YW5sV0
	cMzP/z6J9OpRzRBpd58YRnBWZE/SXjyGcSBDJL7ozC46aExt6TlTqeYiOJZSoXsDaZ+evX
	UXTQia7s7foIUU/nYCx4feWAcILknFs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 87EDC600AA;
	Fri,  5 Jun 2026 08:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1296E1F00893;
	Fri,  5 Jun 2026 08:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780649501;
	bh=IIeJ9iL/lDvJySy7dwtIphbMaPaW1rE4MmoyhmBkXhM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=de1zSMnqVEgSxN0NuY43apjjCw8weSD6Yqs0qDheynej3/5uzpJ3BcBucvOjU0FqN
	 N5O+ucZbnVM5/lKIjvqhVw8vPjrtJsckzMuhWIHkFdC77e9NNzpQ+jx60NyQAkgujA
	 I87krPuwzgTZ1Jgz/jfIBD64CKNxVAAXnWT2xt9W/6zNWz8KjkCJf74yvuGLSMwtxv
	 /jQWa6XQHhg+mPcJBlRoOhoA4uli8Kaz8VHLi5uobGppq6/NKgd7yRODnWjDediKfl
	 YHexHFXdw56TOlZOBHqPHq7toE46jHuqRbYmNrYQCt80M23BJyFm5zr6hIXrEuzXUO
	 GzdOVw5WcMD8w==
Message-ID: <ebf488ab-779d-44be-8c57-d275ec26726d@kernel.org>
Date: Fri, 5 Jun 2026 10:51:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: trace: change memory_failure_event to
 ras subsystem
To: Xie Yuanbin <xieyuanbin1@huawei.com>, qiuxu.zhuo@intel.com, bp@alien8.de,
 akpm@linux-foundation.org, rostedt@goodmis.org, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, mhiramat@kernel.org, mchehab+huawei@kernel.org,
 tony.luck@intel.com, yi1.lai@intel.com
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, lilinjie8@huawei.com, liaohua4@huawei.com
References: <20260605081213.154660-1-xieyuanbin1@huawei.com>
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
In-Reply-To: <20260605081213.154660-1-xieyuanbin1@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: s7bxemqhzhi53d7kfi4usba3qk9acj44
X-Rspamd-Queue-Id: 432FD140008
X-HE-Tag: 1780649502-736104
X-HE-Meta: U2FsdGVkX1+8cRvUlBhsgGth5lJAA3lJ5LoV65iB9oYT4hYAtyBn0tq56Ufxld7Ya8KS4CY9DyUHEzysJpVAlX2LfwNURS0Lr+8x6F7sr87gSvTlgho+dA19MrQwL5cn6mDgRIqAMkLgyiR7R8Xswo+NZysvDYEropmKeC00Sm7d+Fy8sU94uvH2qjdw7o5JnxV64gm4gGD4j/eblK3da8QAbvw1XQksiE2gfYO0blFI3gLHMGXySHPbmTPivMaMF7W2/vWVwGt6C92h+HSsb5LC7Z6cczddQPu5S3az7mT09QIDyvWVTpSh6YmAMjuUsbTyKUUG9H57vPqxBNY8w4M7x0rUAXvL0vUkHuGkyFK1Olo+GepTwXedA2frpMueHSThSBLvE/4/LFc1g812bgor11WlFkmQg9ZmTOUscb/zfPajwpUuWOUdDOKOEix1JGxf0SLg6KCsxLNYJJKhF304BZgPaPjdumVncyuqUJ43rcVNzBb4drH906u+MDUPtcmY+G2ZivHmNV6Z+hl+fvU9W/hKb/0S7GW2sI6ikohG2Jm4tV6J6I7tjWfAE2d4egeiJ3qq2Q0xpyJoaQh7GJSMxsYKKL1q+thsM+DZdJlk7baliaFn82AoENF5xX8Z2uE37OgLmZQjyUDEJB74o6URl4GMNxha7VujjCYvHpwFXYQhpeGx89V7dCotwGKTxZfbSq5fmc4hokYVFHEM8tkwq4fTmLrTgqo1dOMNcd0/xbXV3T0bWSNTVp2VFKnU117gbkt5L13MNAFIMRaW0dXT8vfD82FzrnxGjMt5kNEqGplF+VXoAmnCxmuUl/K4H3loozs05VHQpfk3+8gcgpdBeL/KXmm/6cMDSXQsZJZA3KAvXfmEU5vcJQ03f1azr4rJw3P2bManvEsrF0sq1abKAAQuuiEFsPMaEU6DzseO24f51M2EYnZFld4cy8JsMP7Ctj0qFpqOuuOFcPE
 P5aGR2+v
 DPM/iAXlpxXHYdSIApuO/5kVBmqOxE++EPP2YxAp3bwOhW4qBsL2JK8viAT/Zrh6xY918ZdTBbRqdfxg8F4mawxYdMafTOMwJgbxweedyR+6oh7gk9GnKMaF2VSN72ogwcTaQgTBb0B/CngtmQ3Pte0Hf6D1E2V3b2WqEPspVEuEs5j+RNXHb7EqU0CbZnSAEqYLZzhVT3CKu02QFU8UGys1SIlBCQuq0mnchCAYy4nP/fZyCWTE613ZcmfuJ5s27K7ZKc+FUR+3uvlUBGqgP3wpbmLFYj7V3RNJ5s5eL5hFy+lUuaJ6YwiboqvHc9Yr5ArTr805WTzgpq1do3cz92JRt2d+hbLJ/CnRZFaK4C07QDsf0DBuPJDmDLrvd03/38BxRX/pqzbe2UEzkWydDHL/Py1o4lb3Aiqk2G6dH+6IDQV8g/OgktgQEZvzaxwIiGoNWd4t0PvpQj3QvVoL3AY5QicJcixKBo85439Wd22GKPD9szLyZbnd0r8pfNSrt8MK5MFS8+t/VIX59WsIMOyJ5wvKiH3gPCnKUC5GvfOSpwbAgobrF3WCX4MaLs1Ukge2NzKnHyCGzRGbvQGE/cbQqv8Gj76mxeUkMxzImFdNmSUMSMjrMrEx2wJhD9Cz5KYop
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/5/26 10:12, Xie Yuanbin wrote:
> For historical version, commit 97f0b1345219 ("tracing: add trace event
> for memory-failure") introduced memory_failure_event in ras subsystem.
> commit 31807483d395 ("mm/memory-failure: remove the selection of RAS")
> changed memory_failure_event to memory_failure subsystem. This breaks
> the backward compatibility, some user programs rely on it.
> 
> Change memory_failure_event to ras subsystem to keep backward
> compatibility.
> 
> Fixes: 31807483d395 ("mm/memory-failure: remove the selection of RAS")
> 
> Reported-by: Yi Lai <yi1.lai@intel.com>
> Reported-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> Closes: https://lore.kernel.org/linux-mm/CY8PR11MB7134346A3E4BB28ECA28D6E989132@CY8PR11MB7134.namprd11.prod.outlook.com
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
> ---
>  include/trace/events/memory-failure.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/include/trace/events/memory-failure.h b/include/trace/events/memory-failure.h
> index aa57cc8f896b..7a8ee5d1a44e 100644
> --- a/include/trace/events/memory-failure.h
> +++ b/include/trace/events/memory-failure.h
> @@ -1,6 +1,10 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  #undef TRACE_SYSTEM
> -#define TRACE_SYSTEM memory_failure
> +/*
> + * For historical versions, memory_failure_event is in ras subsystem,
> + * some user programs depend on it.
> + */
> +#define TRACE_SYSTEM ras
>  #define TRACE_INCLUDE_FILE memory-failure
>  
>  #if !defined(_TRACE_MEMORY_FAILURE_H) || defined(TRACE_HEADER_MULTI_READ)

We should

Cc: <stable@vger.kernel.org>

given that it's in v6.19 and nobody noticed :(

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks, and fortunately now I learned about possible ABI salability of trace events.

-- 
Cheers,

David

