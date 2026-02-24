Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68CD2E9B24C
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 10:10:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC2E96B0088; Tue, 24 Feb 2026 05:10:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70B06B0089; Tue, 24 Feb 2026 05:10:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A52646B008A; Tue, 24 Feb 2026 05:10:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8EB786B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:10:26 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2B9F0C1EBD
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:10:26 +0000 (UTC)
X-FDA: 84478930452.05.5000674
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6C90240010
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:10:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="eUuT//x3";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771927824; a=rsa-sha256;
	cv=none;
	b=IdR3w0pDomOkJ+QWOdMeH/FI0abATT1MGzl2Mrha+r9km97PsyDjOcCg4b7W5od9yrGiFp
	I5PxCp+Lpl+s2gmP5wbluDMFroLJ5enno/1Vp5ZwqFx/pt/hKDRrqbp8ZwaKwgVNOrVeco
	KpDFD1nHDl29+9zESwEzb+64gijOj4A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="eUuT//x3";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771927824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kc91CIIl41xh+9K1iSPxDe5Eo1+2Wvj25AcgOtUzf2s=;
	b=W+r5QWjtSbPg85agY1AApvYDmKCArOBFtAViELjiKlZR4fgeL50B2ojhcHKTMD4ReuRruN
	o7BbnEVK6pjJLDlyegPkHnCVNIQWhDZEwBhXoy2jrDbH4PpmRTMfbu8RJVtCBja3tp1wEm
	Mfk4NOCqy4Ly9b0YSAPH/X76hm00RTk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B4D6C6132E;
	Tue, 24 Feb 2026 10:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A64C116D0;
	Tue, 24 Feb 2026 10:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771927823;
	bh=HLl0s56QthgFvq5ounX7gaoVLceVUg13LF70lAn+VcA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eUuT//x3T18L5U+IYW4yhBmaBd1Hs2QpYgo5OmQczVfNVug3MUE6iNZOvDyCDeD8g
	 gC5xNPPkbEHkCXbqejzoqOW7jwa5C31ubtGYhOFUmDH+BPZxhqMvHjxdNvtkFu7jJx
	 1vnTa9atEQN4TvD+WtyLtsy0vCv3GWgDnoMWpdxFxbDlwmyN9Qe5U0SeHTgrSm3TCS
	 GrcBvsCxn1SgvRRq/3L/7oK5mA+S3CdhoGpd7VtBgrCZIYF/A3GCF2cEIHcjYhy7hb
	 muv5pUvzmiIBvv5v6RcD8Dt6o5RIwsxzDuAB7IzgEzBpvMSmNwsgM3/0A/RjVz4Fhj
	 ZFWRHqNAfA1KQ==
Message-ID: <f73ced77-1dc9-450a-93c1-c7f5b58b6aa3@kernel.org>
Date: Tue, 24 Feb 2026 11:10:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v8 4/4] mm: khugepaged: skip lazy-free folios
To: Barry Song <21cnbao@gmail.com>
Cc: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20260221093918.1456187-1-vernon2gm@gmail.com>
 <20260221093918.1456187-5-vernon2gm@gmail.com>
 <CAGsJ_4z1twdSNrAVR_vZRnLW4xtsfi+vegNMCwht+RPCjy=E4w@mail.gmail.com>
 <xbej7d3uc3xzlx53djgg3to3ejcgrxotxwxvrdppqxfsgieife@5moeg6x2vutg>
 <658903fb-cf3a-43c3-b8c0-d47b63d10782@kernel.org>
 <CAGsJ_4xwTDAs-=WETGxj=dUTrvu_1oYaXZOk-r_yzJ9p2tVOXQ@mail.gmail.com>
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
In-Reply-To: <CAGsJ_4xwTDAs-=WETGxj=dUTrvu_1oYaXZOk-r_yzJ9p2tVOXQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: c8zawcs9x94b955jezqdmeoyzpfu4uyj
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6C90240010
X-HE-Tag: 1771927824-689966
X-HE-Meta: U2FsdGVkX1/IGXi+/cZC/UCZs0rfjKWV9OZCcjwcg/tx0PhoEkT/zJWf39JVhaDBX/1U129vRXKfuucM55mINUV0UIWKWQEST/OYfYv4nedeKNtd1tGABEtd/VQxJDisAmQ0CRhWnXmlc1KVNeaREJqNvi7B7I+802eUsXG7j2kh/zM5YqzBkyUWqq99wEVXd2rm/R3XnGFV4ehSNKmdXg1gh0pLtbwyhSJ4qwn0MyfW2dsn3LJAXBfFQAoQj74wckXJr2kBjszgB+pB3wzW1mdLSkWK0IMlReCCssRkVJ33sN8igZuSrd0Ja30YZqrRBAqTQOx6qGxk6TCzQWn2jAS1xUlqH2nDq4LQ0WhXXIXKjdX/tsgeP+ToqTAhtcG0lsOfNVHzBJYzjJ10tNMdzJoPlYkVThWVlio/YhF/1M3z5Z/exxSWFy6bq9MeWM98p19IzAdYfWaJrg59jDcYYnV+q9asHR5x8a92Inz7UBd58R8gkhspWi2xUVRDBL39j0WRHB4JaZA2GHMz1kxMqw7NnzN4MK5s593ynbSNS3S+zrYevDy84DqgMmCBSPuLK3hZgI2rDeTG7Khxf/NdBZq3owp0QK2yw3KslI2DeSvcLuAfGHmPjC4SE4d9NF+XEbwuzSKEtOd3TzIzDJQYhxhZwPjUe/RHLqNDMe8Or/yDKfZNbhfCwEzJshRfP4EIgR3V3Ka4mq/c8An2czgoSVTPijJ6cfomobPGkuDIKZfXb1l27QVBi7/07iHmoktUGX3oy0u/MDfNmOcC5dix7zUEcuNMbrelLVFd9PwZS7a/l/4CdnTJChpDtz6RVvC/FvdYR87Dk2zv6jWztQ4jMv8GPN3420VSpei8yaLpFDl9giKKkN6CcgU5nKbGTZkhP8YoD+acgRTow1nLBZJKSq0ELO/mYlhFdi7p5kd4tpe4BPblv19zDA8OuhfERweM6E0YIfzLlMfrpK/6XKF
 cMjKWcBn
 Z2qumq8qBtQuOA8MdXf7BXXsGo2+GEbQXI7HV0SRSt91P3kA65PzK4B6hTLgsmmzR0lxWkvcHRzJpXPaw+k9WzhorH4hswdqKSEDrMo7XUmeHztiJjNKSyih0u7gG9XdJSU6FeQGTkIsl7zxCmf6tmn6g7JJD5dMAaR9/9qhA/Av0TZ1j/n463cHQ8swxK947I591PiarRnYMIMsIJU1X536l3Ukc+HyIrxjS3hlnQyt/kjz0Wka/CqUulofElsW8UXXQEv89WSyWEFwcgYnJ6XIR4mgTCBT+Q/Lao5pT1hq5+1DZsqfbwOEr8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 21:08, Barry Song wrote:
> On Mon, Feb 23, 2026 at 9:16 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 2/21/26 14:38, Vernon Yang wrote:
>>>
>>> In folio_add_new_anon_rmap(), we know that the vma has the VM_DROPPABLE
>>> attribute, which is the root reason why Collapsing maintains that property.
>>> The above commit log clearly states "all folios in VM_DROPPABLE are lazyfree"
>>>                                                  ^^^^^^^^^^^^^^^
>>> (the "if" is redundant and should be removed), not "all folios are lazyfree".
>>
>>
>> Exactly. folio_add_new_anon_rmap() makes sure that all folios (except
>> the shared zero folios ;) ) in VM_DROPPABLE are lazyfree.
>>
>> In fact, MADV_FREE should be a NOP on VM_DROPPABLE, as
>> folio_mark_lazyfree() doesn't do anything.
>>
> 
> Maybe we could do something like the following?
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index c0370d9b4e23..173b0e5308b5 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -817,6 +817,11 @@ static int madvise_free_single_vma(struct
> madvise_behavior *madv_behavior)
>         range.end = min(vma->vm_end, end_addr);
>         if (range.end <= vma->vm_start)
>                 return -EINVAL;
> +
> +       /* All folios in the VM_DROPPABLE VMA are already lazyfree */
> +       if (vma->vm_flags & VM_DROPPABLE)
> +               return 0;

We could, but it feels like optimizing for a case that likely nobody
triggers :)

-- 
Cheers,

David

