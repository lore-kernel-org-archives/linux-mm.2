Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F20EFEEF49
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 15:00:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BB886B0096; Tue,  7 Apr 2026 11:00:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 745F76B00A1; Tue,  7 Apr 2026 11:00:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 635066B00A4; Tue,  7 Apr 2026 11:00:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 531CB6B0096
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 11:00:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0AC5EBB678
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 15:00:12 +0000 (UTC)
X-FDA: 84632070264.01.2776B56
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id AAD05C000C
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 15:00:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="MU/N+J+f";
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775574009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DG4Uvg/M+J/Lyp98ptQKMucHexjwQy0gGH+BivvzSZ0=;
	b=yZKJxWeN3j7iZkJYgOBsFJzVZMYl2kmr+w3vb5mOQNqMtneOCg7nm0Gv3ccCzAcT9Omr+G
	9zDYeT1mkBcW3vOWVbQ6uPa9ZlgViR+hphxUTAUqItJdgBrcE9Ky6fT+YbvKyxu9gaZXNQ
	w5WRldvlBv/cHibK0hKrTdqneJcxZwE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="MU/N+J+f";
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775574009; a=rsa-sha256;
	cv=none;
	b=R2BiO8E/Jb65jlMLI63h+UKMniKN/jzXT5OEhtbTaNGyvMzQEN5TWhdF4uedpUFKNK5m2Q
	qY4cTjrAQVLrYFzW3feuakV3UtfXSxfZXPF8VWPfAmHYVajIk/aeKs+km/NVDjyGc8CYAF
	tSODpuc4iBn6XQfotfoyntChtCp4+RI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 24ACF60127;
	Tue,  7 Apr 2026 15:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F242BC116C6;
	Tue,  7 Apr 2026 15:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775574008;
	bh=AUjPs1pXAg+cemiogxGwMvKSzf13rZ7r7rdPLUFs4nk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MU/N+J+fpUR5yRHF7vZJwWV1SL9ejrPGZHTnhoITcVf6+Efy3EQJexo8qZ51aBwHk
	 6xnHXayzDnSp4PN0CwVLWHtcMvTR9ifTWXmk0SaFkjgCi+MTncPwfXQ7n79gRAqzU8
	 GAeRLTFFUca00AwoTo4Gauy6iuFZV16YqUB7iPw2RKuIdZxiNCOz4YD/5Y+f4wfMc1
	 B57jgPu69YzAas+jCOpEFY1kCyhf/faENxiQ/pfdNgJJxrS1XMzCSUQa8AlDPJeRKi
	 ABGa3iEQ+LjhmCK/pHgLQF8LgVFoqcuL3vOxRpaprxxUh+36HW4C1z+55oDdiDr1uM
	 caJ4/5l1+ihlQ==
Message-ID: <a14a89ba-e870-47d2-a903-564332da9877@kernel.org>
Date: Tue, 7 Apr 2026 17:00:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ksm: add mremap selftests for ksm_rmap_walk
To: xu.xin16@zte.com.cn, hughd@google.com, akpm@linux-foundation.org
Cc: michel@lespinasse.org, ljs@kernel.org, chengming.zhou@linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260407140805858ViqJKFhfmYSfq0FynsaEY@zte.com.cn>
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
In-Reply-To: <20260407140805858ViqJKFhfmYSfq0FynsaEY@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AAD05C000C
X-Stat-Signature: chhmscpeugybi95ufcut7mmq9e97fzpu
X-Rspam-User: 
X-HE-Tag: 1775574009-482734
X-HE-Meta: U2FsdGVkX18jGyJU28EsTq+Z45ZYJd0udOnwu+h9jphdqMQGnEfKDj9l0GA4lIsrRjhxC2A2AsqxS/JC/q48JAQ1bfeA45P9oqgIyLC1TGsFfRxwiKQi+MCIWV9KpsOdQ4XS9h3GVC6Pippo8czI4kujhBDv2NwwAOScx4QVt5g5WfICE8ZU8pRiJIC60GCU6pB1e6rtcLS0k0ZB3aM1lZHq0DkR7E3kWU88Lrrw87GdLQ8Tl1cPlFomFlpRzMcS0+1Xfec5dMcjqPiaOVzpLhoXzJQqYFKIgPgFn/MpnavbAMFt9vBaPt80JAlv5H85Z6LnJxzF2b6MjqG8u7Q4EJmnG/s7G5EZiFnm3yndAt630g6cM6vK6Du2MJznJVPCREZdBUZPHBWfG9tBEWHw2mbW6mi6tA/OVRuYejcoW6ZN9+9j/6czSchQwXqJGVSxrezEN5JRkBnejlUt6YwvzullWa/3J9zVRcXfzmXLuBhl/AZraTceJPNvNK6R8GeSv8H9PFVeTY63A1dS2+Bp/H4uaIct2+efv9oBxnQ8/3WA/0opHiU6sFofrBWGh633E0dFrz8+XLkzhXndVzl9DRM0X68EGz3FR8ilUeJE35DNZKRIj7ap2uxVeqfsf5xDqwnmHdGy7KmQnJ39EI3S1BRQJZLMAMN8z8UaeZ64OMy/CVafOyJVNpmAIuDTU3PcSZIhSHwVg6mHXmb47k/AnZelKkpTM2lBdrlQaTvzfJaSSYfrPbyqlfVb2D4Bafq1KIs2nHcNHTmYepMQpPcuaZiYktvgDf0k0ns6Fi67KPmt8iElIWFyag9JSHRKV2X+suspSNg0Ggj4jpdLgkzENsLtx9swJyWHbJ73n0MJ7acmXdiRPmNdtZPpjcEIV7e9z7tAOM9rECYns4lOIcQaV26FZ5q9mH+X8He1H8EVrEu7y3w3UeByHyp0jjePXcVuw7v/zilzH/IWGFx4//A
 HlmS9efq
 JJnjzM+SDtZijM2p4RkDD+CbLgL0+Jb62TdZwxylmPir3MgKx8bXkOKogFb0kLrodQbvN0EqAjyrPWjHPqOKzp4UqQqHWuR+9ig07PXo8gxTBsSB82tne0H/dJzACWNn3LGsYZCgF3h3LzdCcwsGwrV9yRgaR/P1qqbsF+4Y7ihcD3Cay7urt25kFvs8Bd8iegLlaczojX4lS9wBt0uoCgIbvIpeYMNwP/9BAUE7XIaHQefm2/MKntyYDsVQS7zIi0RmHbSoWlbF/IyU58qKgC+I74sNQ2RyI+WOf5bUG71RjwTucYkam4kLi3mka7tQG5fd18MhQMoLr3fWlxEAQBRQpPES++VKOQO6mqxCAOORQxFngxiHdUY5trYjrpsztiQLU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/7/26 08:08, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> The existing tools/testing/selftests/mm/rmap.c has already one testcase
> for ksm_rmap_walk in TEST_F(migrate, ksm), which takes use of migration
> of page from one NUMA node to another NUMA node. However, it just lacks
> the senario of mremapped VMAs.
> 
> Before migrating, we add the calling of mremap() to address mapped with KSM
> pages, which is specailly to test a optimization which is introduced by this
> patch ("ksm: Optimize rmap_walk_ksm by passing a suitable address range")
> https://lore.kernel.org/all/20260212193045556CbzCX8p9gDu73tQ2nvHEI@zte.com.cn/
> 
> Result:
> TAP version 13
> 1..5
> ok 1 migrate.anon
> ok 2 migrate.shm
> ok 3 migrate.file # SKIP Failed in worker
> ok 4 migrate.ksm
> ok 5 migrate.ksm_and_mremap
> 
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---
>  tools/testing/selftests/mm/rmap.c    | 69 ++++++++++++++++++++++++++++
>  tools/testing/selftests/mm/vm_util.c | 38 +++++++++++++++
>  tools/testing/selftests/mm/vm_util.h |  2 +
>  3 files changed, 109 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/rmap.c b/tools/testing/selftests/mm/rmap.c
> index 53f2058b0ef2..65470def2bf1 100644
> --- a/tools/testing/selftests/mm/rmap.c
> +++ b/tools/testing/selftests/mm/rmap.c
> @@ -430,4 +430,73 @@ TEST_F(migrate, ksm)
>  	propagate_children(_metadata, data);
>  }
> 
> +/* To test if ksm page can be migrated when it's mremapped */
> +int merge_mremap_and_migrate(struct global_data *data)
> +{
> +	int ret = 0;
> +	/* Allocate range and set the same data */
> +	data->mapsize = 3*getpagesize();
> +	data->region = mmap(NULL, data->mapsize, PROT_READ|PROT_WRITE,
> +			   MAP_PRIVATE|MAP_ANON, -1, 0);
> +	if (data->region == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap failed");
> +
> +	memset(data->region, 0x77, data->mapsize);

What happens if you mremap() after faulting, but before merging?

rmap_item->address always holds the user space address of the entry in
the parent process. It must match the one in the child process, because
mremap() will unmerge/unshare in the child.

And it must match the one in the parent, as mremap() would similarly
unmerge/unshare.

Maybe doing the mremap() before merging (but after faulting) would
trigger what Hugh described.

break_cow() and friends don't care about the rmap, as they simply jump
directly to the user space address in the process.

In rmap_walk_ksm(), I think the concern Hugh raised is that we are using

	const pgoff_t pgoff = rmap_item->address >> PAGE_SHIFT;

but we'd actually need a pgoff into the anon_vma. Without mremap, it
does not matter, they are the same (tests keep passing). But with mremap
it's not longer the same.

I think one could store it in the ksm_rmap_item, but that would increase
it's size. It's essentially the folio->index of the original page we are
replacing.

Or we could just remember "pgoff is not that simple because mremap was
involved, so walk the whole damn thing".

We could also just try walking all involved processes, looking only at
that user space address (but that gets more tricky with rmap locking etc
...).

Anyhow, I think that's the concern Hugh raised, IIUC.

> +
> +	if (ksm_start() < 0)
> +		return FAIL_ON_CHECK;
> +
> +	/* 1  2 expected */
> +	ksft_print_msg("Shared: %ld (1 expected) Sharing: %ld (2 expected)\n",
> +		ksm_get_pages_shared(), ksm_get_pages_sharing());
> +
> +	/*
> +	 * Mremap the second pagesize address range into the third pagesize
> +	 * address.
> +	 */
> +	data->region = mremap(data->region + getpagesize(), getpagesize(), getpagesize(),
> +			 MREMAP_MAYMOVE|MREMAP_FIXED, data->region + 2*getpagesize());

There would not be a KSM page after this mremap(), no?


-- 
Cheers,

David

