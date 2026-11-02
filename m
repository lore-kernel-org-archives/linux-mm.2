Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3A28606A32D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 13:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FzcHPsnW
Received: by kanga.kvack.org (Postfix)
	id DEA736B05BC; Mon,  2 Nov 2026 08:59:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2546B05BD; Mon,  2 Nov 2026 08:59:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB1246B05BE; Mon,  2 Nov 2026 08:59:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D3786B05BC
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:59:04 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 450241A00E8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:59:04 +0000 (UTC)
X-FDA: 85390335408.17.3F3E854
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 59499140008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:59:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FzcHPsnW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793627942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z636TFZ8J/efy6KD/Zz0HvIWw5738nMcZMSYjKsuO7c=;
	b=LzvNQvQmVveinR55ybTF4Fwhk6u6PKMv27S6bfMpFlNn0Ku752UqYQmJVpDUtqkuzrpZMe
	kqWKxwOFhPkdxsPWcQeUA6RpbRuh79hIyGd/zpxjrpT8fsPklEQHkOZDKWmIFkNgqHZBP3
	fcXdOsaUeJS7t/SdvoPwKPke/zyomjA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FzcHPsnW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793627942;
	b=cpBnQq8pZS7d0xPA2F1XItRrxGUFN2yn4DeF8WO8MYFkb46g0WcNdzYTOzsht3zhmpRvte
	k0ofytN+NimSEWYhY7q5EOqvKC57kE3H3+O0NjTYIOdD+EKJl/BR3d4jefXz601w5E3Mei
	GtqdMJSAkHokuRXuqpxq5+rgJMfRwcQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 75D4C40A6A;
	Mon,  2 Nov 2026 13:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937F81F00A16;
	Mon,  2 Nov 2026 13:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793627941;
	bh=z636TFZ8J/efy6KD/Zz0HvIWw5738nMcZMSYjKsuO7c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FzcHPsnW3q2Ej26Y0zaezRttXCpKyXZgRQDIf+oVdbAVrSZaxa1hA/SK5uxM8Rvm1
	 GlxTZeqVxaGdnr0YMOrx+aT+lopuJLxihXARc85ukL3YNWVWpR5L0XcmA7mfHXvCZY
	 tR0thba+KGUt3MK+UIAJdOHxdOXhuLGy3yPb0X9eZIb8Lj82rNQAAWX+1xQ+6aiurr
	 jatLzVB4HkltRc2BiHB220Su1xQU+VGmGNrXwa1B11UVDtNPJ5z3fkqPSMCWHAPuOk
	 eOUNc1cJ+V201OX46HZdhjN17mVI15v6lKpWnyLaONRebUkhyD48rIgyeBRYlnCjcF
	 G70TdC+KKv87g==
Message-ID: <804d9f27-bfb0-4621-b394-fa88709a90d3@kernel.org>
Date: Mon, 2 Nov 2026 14:58:58 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mm: tmpfs: huge=always Kconfig help understates severe space
 amplification
To: Dmitry Ilvokhin <d@ilvokhin.com>, "Artem S. Tashkinov" <aros@gmx.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <b42192af-d9b6-4820-bff3-e3b6c6ce9bf2@gmx.com>
 <auiHxos_Dr1PXEB_@shell.ilvokhin.com>
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
In-Reply-To: <auiHxos_Dr1PXEB_@shell.ilvokhin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 59499140008
X-Stat-Signature: 5ayzwf4z3deh6ne85smn1rm1ahz5ddr1
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793627942-624965
X-HE-Meta: U2FsdGVkX19K+DEiiIqGVYpZ+DhNoKFotwN6JQ7al6jxB5s+E7GPjOQA4WIjUx3Vdgd7IBQ1/4UFlcfuKgbZouipYDGfjdb5eaLjamRA0OmMePz/3N24FMzhOfLS7N5TFaILnPvUSKAmA/+vkidbpIcZMa9ZN9BN6fhmko5OAmAky7sr4VCbSNsjKvfCQ18L9/Ps7OdcRiTXF7H+pMbvYDXpR55FAqf3hSEyxHxsYXy5kOkzhKF1n88Vxdq4xIuvX4FMdrqBCQcSLuMs2Qt6/7gd6f+mbzmlLpr07JpOXFj2HAwyg9OFll1INX81aslqoqr2lRDE/7Yo+7bglUwuCpF5I5zClTVJTTfh6cjjVMpyiMaeNJRmJKpGGSgD/OcMXLYsKwzA4ImK5NAq+MjP6JNmsKIz1sjbBbosdR+n8Dczeih9ayaqiHHaHlpzYhNWwplQxmZKy6QUQy3A+lM7iDUiUjw4o1dO6vNrmwuzPQyhZRQ1s+WPITaOCVHscAFqAOBJI4JmjdNvziC2duNBU57RYsNVgqKXOKhtM/7UzPdyk+RJmW/Li2WvB6dHZtl4H/dq18PZnRjEY1f25FYdnGFN7woYZySlxBTNzw+gyu5DBU/zN0C83LM0terDV8O4GDZCO2nEA7vexN627tPjhd+miqYH2HT1X7DkqJKCccRpl2mkUJahA9unHyCgeIahvPHzIeeeswd8SDX7Bbi1R9kLgXT8v4IzURTSCID3AqWvG/6OJF7XdZezbOLUwqdNlEr+4S76VTw8/xYpLI01yJnZ9/VxgSZvxZlAZmngB4gKVCeTeWBbBHdvMuRS4eZMtCloDFffR/65nUxfPw045bTbMwSkRq9ck97nznkdZDySJvq2Dco7wfaV8EYmkjj7bAZvZKj07DpaLsaA7MjcOb7lnNw2rGIWqylGTfBzYnHe+PfCBHk2qwX0z9GIdhhkadIvgI/qApW8iN7bMDu
 C4SIOGQ8
 sd+xQg1ngpPjf9Z437RJ7MxaHqiods9qjCX5XpaydQaf7zhEjDh4CCbh9raBsVPp0Uj467aM786u1ChdNt7vxVQFjPqbubstEYZBRgpMpFumoAQQbGYzIfbgyDzR94nxHnIj30i7pc1PDWbyhsIZ58Q8yk9dFm7P1vHsZm82S9taB894d3oaecY5jI3gvILzi9zb3YhHIL0vrN/fWoKx0QhPpyCg4jMY33tCeubWpDhL6xOzh1r8x8/3P5SfwGRXm0H9x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 13:53, Dmitry Ilvokhin wrote:
> On Sat, Oct 31, 2026 at 03:19:08PM +0000, Artem S. Tashkinov wrote:
>> Hi Dmitry,
>>
>> I'd like to raise a documentation issue with the Kconfig option introduced
>> by your patch:
>>
>>     mm: shmem/tmpfs hugepage defaults config choice
>>
>> Specifically, CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_ALWAYS.
>>
>> The help text currently says:
>>
>>     Always attempt to allocate hugepage for tmpfs mount, can
>>     increase the memory footprint of applications without a
>>     guaranteed benefit but it will work automatically for all
>>     applications.
>>
>> I believe this substantially understates the potential consequences of
>> selecting this option, particularly on general-purpose systems where /tmp is
>> mounted as tmpfs.
>>
>> I recently encountered the following situation while extracting a Fedora
>> filesystem tree under /tmp on an x86-64 system running Linux 7.3.
>>
>> The tmpfs mount had huge=always enabled.
>>
>>     $ df -hT /tmp/Fedora
>>     Filesystem  Type   Size  Used  Avail  Use%
>>     tmpfs       tmpfs   48G   47G   925M   99%
>>
>>     $ du -sh /tmp/Fedora/usr
>>     45G     /tmp/Fedora/usr
>>
>>     $ du -sh --apparent-size /tmp/Fedora/usr
>>     1.4G    /tmp/Fedora/usr
>>
>> Even more strikingly:
>>
>>     $ du -sh /tmp/Fedora/usr/share/man/man3
>>     7.5G    /tmp/Fedora/usr/share/man/man3
>>
>>     $ du -sh --apparent-size /tmp/Fedora/usr/share/man/man3
>>     7.8M    /tmp/Fedora/usr/share/man/man3
>>
>> Thus, a directory containing just 7.8 MiB of apparent file data occupied
>> approximately 7.5 GiB of allocated space.
>>
>> The overall tree occupied approximately 45 GiB despite containing only 1.4
>> GiB of apparent file data.
>>
>> This is consistent with severe allocation amplification caused by
>> transparent huge pages, although I have not yet established the exact
>> breakdown of huge-page allocations and other tmpfs overhead.
> 
> Yeah, I think one can expect up to 512 amplification on x86 in the
> absolutely worst case, based on the ratio of pages sizes:
> 2 MiB to 4 KiB.
> 
> I suspect the magnitude can be even bigger on aarch64.
> 
> [...]
> 
>>
>> For example, the help might say:
>>
>>     Always attempt hugepage allocation for tmpfs mounts.
>>
>>     WARNING: This policy can substantially increase memory and
>>     tmpfs space consumption, particularly for workloads creating
>>     large numbers of small files. Allocated space may greatly
>>     exceed apparent file sizes, potentially exhausting tmpfs
>>     capacity even when relatively little file data is stored.
> 
> I would probably drop "WARNING", since there nothing to warn about yet.
> Also, second sentence communicating the same idea as the first one, but
> with different words.
> 
> Probably, something like this will be enough: "This policy can
> substantially increase memory and tmpfs space consumption, particularly
> for workloads creating large numbers of small files."
> 
>>
>>     This setting does not guarantee improved performance and
>>     should only be selected when its memory overhead is
>>     understood and acceptable for the intended workload.
> 
> This part is already mentioned in the current wording: "increase the
> memory footprint of applications without a guaranteed benefit".
> 
> Anyway, I think documentation edits are always welcome, please, submit a
> patch :)

Agreed.

BUT, one interesting detail:

On small files, the shmem unused shrinker shmem_unused_huge_shrink() should try
reclaiming such THPs that expands beyond EOF to reclaim their memory.

Artem, does that work in you scenario when there is actually memory pressure?

-- 
Cheers,

David

