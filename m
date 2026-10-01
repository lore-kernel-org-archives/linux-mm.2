Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8700BCA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 10:45:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 821C76B0088; Thu,  1 Oct 2026 06:45:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1B46B008A; Thu,  1 Oct 2026 06:45:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C0EA6B008C; Thu,  1 Oct 2026 06:45:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3463E6B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 06:45:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CC7431A0360
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:45:07 +0000 (UTC)
X-FDA: 85273725054.01.F043142
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 00BD94000B
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:45:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AXyYcsq9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790851506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xS811ek91+cRnLcRHo+xdG9TRcDiTFjS6kYimGRgBZA=;
	b=q/dwhPkfmoxgUyA9MKM1LDlwQvbRF0C27kJ5aL7bbaRY4OmrKp2YHB0Ih6Cug83AE0z5S9
	E0sE7HPNlBuiJ/l7j95xBtLoivTQu5Ze8p5/uI3Nqu2Hg2FNF1zjZ+28CJdCgRgY3FTQwX
	UHMAzNDevHXm3rGkWOqjZucwH5hn/sQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AXyYcsq9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790851506;
	b=e15wJ9SPUha55I0kIvT4Nr4QLyB5SQZ9bhv7H7VW2tk+ckuIzNJDyDUfMFT0jz79EnNRgY
	k5TFenDrLJMq0M+bsuk0kdAp1ZrlNbf11ZiFpuXmdahFhw3kxiVhsdXrF8ezYXp17Uxv8L
	naph6OB7mDbDIlO1CZfamg1Mw9jPJF8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B6FD8601E4;
	Thu,  1 Oct 2026 10:45:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC961F00898;
	Thu,  1 Oct 2026 10:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790851504;
	bh=xS811ek91+cRnLcRHo+xdG9TRcDiTFjS6kYimGRgBZA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AXyYcsq9/FFTDLVDfuaLhYscCqLUFDph4zsoXj5QTlmOADNMX51iD0SkOytpuf5MO
	 On7NZDhoFLjM6CWVW2gzFEcvlQfJlOxXWG7tWYqM47OAMu7KAyTJd7YFvQOmfAC17f
	 pUVold2MOFnaPPOqct7QNwYVg+o854Z573vOoPA2MqB1mA056rQO7/yQCAetpOVFcR
	 DU96bxWqJMrGQzyE+IpFrPq0TBmt2WYo1ugFcGZcDcEtbALPfyGcbim8nxi0gLfM37
	 GlcYsri4WfmEBwTtjSQrTwwgvb8pzlnlZMraSyWbadX19Qf1ifbAwyTUxBkutck3ZK
	 jzOuD2flcr5bw==
Message-ID: <e1728faa-5d50-48af-8ba0-5098be9124eb@kernel.org>
Date: Thu, 1 Oct 2026 12:44:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/7] sched/numa: separate VMA placement from scan
 continuation
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 kas@kernel.org, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 ying.huang@linux.alibaba.com, matthew.brost@intel.com, byungchul@sk.com,
 apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, hannes@cmpxchg.org,
 shy828301@gmail.com, osalvador@suse.de, raghavendra.kt@amd.com,
 stable@vger.kernel.org
References: <20260930112206.205083-1-gourry@gourry.net>
 <20260930112206.205083-5-gourry@gourry.net>
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
In-Reply-To: <20260930112206.205083-5-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: a85bgycf3xit5ccbeyi3wh5ujpfdtaij
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 00BD94000B
X-HE-Tag: 1790851505-509227
X-HE-Meta: U2FsdGVkX19Y05fDTDXgd1c8cmzJ1qOYneVk58U/eaUkZ5blin5raNh6blDyuV7Bi3qeacFhEGfkgpUuYBwgLRdHeSLlLr0gCXgf53CjVdWZCG24tNEhzCcdXSeKcjQeauKNLT3XsZLFGc2UB6H+Q5eW7UikfPDrD8x1rGCGZj4UY9XM2+esdCokIlkFmOSUdOFjyA4nXahjjUW22HzkkUQvbT2H3gz/yxE49dY06Gk9PPcosWSC0QM+58evjTcGyjFivDxTj4fBeHLENkIpeYYLo2QT5TrTR2Kj+C9mvwc561HQZixfuekqP7SXA5ik4IM7y0NLtV3dI9N8B1ba7SbPuz+m6ccsxB68MRAcOkKySkyD2NEhr0jFHddm3jmj1dG2L7PAbCxbJvmRuJIXzKB91EU0uHIqmmDVmKwIwR2xn4IdbwgwXipWJtua5++7+rQZDRevo1XxOsxkYnbS7ewekeEP6GyeXheVuKjWmrxs7o42sUtu8AspBFC3DfTmOhtQF4fUI7QgcahtLS9WAQ5FLFCt1/w+mineE9SEUZUN7c1OimxjQjpu+LZ2+2zWaqNa3f+Xc7XlbPyCMfMLwZe39MnDNmvgUrcJxskuuABsACvEv3F0o/9CJmZnyLGSJmrDa/qD1WrxYh9zi4N/5rCfFefwnfpWWzOdLIKSnMCOxYiMnoXwWvRXKGKi9A3VdZ4QHrgvkkmO6VLCpZ2HrS8HgezasbS9WmKkkX8SrQZ9yvgHRzX6zfLa6u1i0Tr+53775Zb8qHRAJAiJH1VSo4jzT9E/iIwQRn5dgHL+zHuF+y9desoAGBZ8OLOrCdvDekf/zc4aFGGlcCnFfdsfhWusHyY7BMO99TNZK2RJSA5j3dva7ZdnSkh/GPZ1gl3IDb5PNu2qFLdwkFwSnfftqBawpUPna6oQ896D3QZLLFpUyDLXwmNDfGtBTNqMgayrP9HYKLDrqJStTqDvZKk
 LLWWokEU
 jM5WtZzDpEFYImVOAkzFU/uD8k8QyRnqNtJDOTBuakw5EfLVEg8dUrBc6xi6g9kIsp6NJ7lP6SccnxzUTC8gyGIv+hIADQLM74j8te4VnZJKzWqAK6QbBCMfTf8wCtziBDAGh97rjXivf7oaYDjrODydFuMm6IuFjjDks148FKpB70oPpxJ/2kGAdPGJdkNViC1sAj1YEPDO4OhAYSHqQ/SzoCEoPs1Tg3x3pU1k20ur0IcFsVBVVUWtSBONhf6Pax1YCjYn60Io2YYoDprFnH20gqkZqQzYPOHxTHxIF3QSzomN9XcngiClfY2Rrspw5L+tVhN6OprhNGKTaFMMifCudC2QWKMgSTk8ci0U9RkM7GfTStSYkfOvB+iN6iBd0ZtDyiJUV3itxEzZ7GLVv6+iPqLfyUqrq2T+I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/30/26 13:22, Gregory Price wrote:
> From: "Gregory Price (Meta)" <gourry@gourry.net>
> 
> vma_is_accessed() returns true both when a VMA needs placement
> (east-west) sampling and when a VMA is already mid-scan across
> multiple scan windows.
> 
> Callers cannot distinguish placement eligibility from scan progress.
> 
> Rename the helper to vma_needs_placement_scan() and handle continuation
> state in task_numa_work(). Record whether an in-progress VMA scan is
> promotion-only so a scan resumed in a later scan window finishes with
> the policy it started with. The zeroed initial state places no
> restriction, so a resumed scan that finds freshly allocated NUMAB state
> falls back to the default policy.
> 
> This separation allows PID-inactive VMAs to be scanned for promotion
> without treating scan continuation as evidence of placement eligibility.
> It is a prerequisite for the following fix and must accompany it when
> backported.
> 
> Fixes: fc137c0ddab2 ("sched/numa: enhance vma scanning logic")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  include/linux/mm_types.h |  6 ++++++
>  kernel/sched/fair.c      | 40 ++++++++++++++++++++++++----------------
>  2 files changed, 30 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 1bd3ca7bfff2..d0ac21d02c47 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -803,6 +803,12 @@ struct vma_numab_state {
>  	 * A VMA is not eligible for scanning if prev_scan_seq == numa_scan_seq
>  	 */
>  	int prev_scan_seq;
> +
> +	/*
> +	 * The in-progress scan of this VMA is promotion-only.
> +	 * Resumed scans finish with the policy they started with.
> +	 */
> +	bool promo_only;
>  };
>  
>  #ifdef __HAVE_PFNMAP_TRACKING
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index ab9afd3ad49b..3b30786ded3b 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4082,7 +4082,8 @@ static void reset_ptenuma_scan(struct task_struct *p)
>  	p->mm->numa_scan_offset = 0;
>  }
>  
> -static bool vma_is_accessed(struct mm_struct *mm, struct vm_area_struct *vma)
> +static bool vma_needs_placement_scan(struct mm_struct *mm,
> +		struct vm_area_struct *vma)

mm can be had from vma->vm_mm, so likely sufficient to only pass the vma?

Apart from that this looks much clearer to me

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

