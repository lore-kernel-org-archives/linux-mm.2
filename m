Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDB57CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 08:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC9BA6B0005; Mon, 18 May 2026 04:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7AF56B0088; Mon, 18 May 2026 04:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C69EE6B008C; Mon, 18 May 2026 04:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B73EF6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 04:43:35 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6819D1C1E66
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:43:35 +0000 (UTC)
X-FDA: 84779901990.22.46DCD4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 80C121A0002
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:43:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iNGUBgh7;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779093813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/cYrTOCFsap+qUGfoqB3KePvim8VCAJvYx9VmvcTkc=;
	b=1vZdHD+1qNk3eP1xjWo0nq4SU3Kf4Izd8Z6c5siygCJc8tTZCf/D6Cqn06lT3+vOGPE9JK
	zqRL5Nm4cW/uLUhmE+ST+U3YCuOeZOFPXzV4GgWrclGwNEdv7jYy2Ug7g3/c47nTSDpSjb
	veA7HJs9tQnmKUu02eb6323CuQi0RHM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779093813; a=rsa-sha256;
	cv=none;
	b=LtMqQy4TgLHORsfDg16BD18lT4SAaT5em9a731qCWiNtFrBhDXX2lQQuNAvny2xlAQR1hX
	Tsx9QrBCAF3mwmYw7JIoOgeLUgdkE9k9KLxYIw6gLhiiUfgb8Re/7AZL33zjnsgTYvRCaO
	abgE3rp2UwWf0EAHn0EvxRDz3/y1dLQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iNGUBgh7;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C85242A5D;
	Mon, 18 May 2026 08:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0156C2BCB7;
	Mon, 18 May 2026 08:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779093812;
	bh=Hh5WO9rSYoc4MeLyVuH9muGrehc2Jj8o8p7T0hzyPL0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iNGUBgh7SPTuSW/PxOmGzyuSjMWm+OpaCa4g/vudm0BacYg9QFqNqeEMIx5SQ4hua
	 XAo3w/dQqQjbfMVBXisS2RVHFoxWDHUpeErwY9o1j7zxWdBdwQ4VXoaO0LGgIOUPaY
	 kyiuYYZah2bgPkIBpjQDknxGNrDI9S+SarAthYDF9KPjvtWxQ9vsdNp8/kgGzh1Z/z
	 zwEMBezoJIYWidOue1LIy7vzsPdAFUdZCNm05FLDdWUfSo3cYDVPd4KvE2176x5LRH
	 gm6rjr+EtG74dGmgmQh1fqiLFnMeL8QP+Ma0fGnXpnPPqB8LWwV+gvGWIwqHdL2EF3
	 UNFbbACsPfjGg==
Message-ID: <60fb497d-a35a-42b9-8bf1-7f9ccbde8ade@kernel.org>
Date: Mon, 18 May 2026 10:43:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/1] mm: batch page copies in folio_copy() and
 folio_mc_copy()
To: "Garg, Shivank" <shivankg@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H . Peter Anvin" <hpa@zytor.com>, Ankur Arora <ankur.a.arora@oracle.com>,
 Bharata B Rao <bharata@amd.com>, Hrushikesh Salunke <hsalunke@amd.com>,
 David Rientjes <rientjes@google.com>, sandipan.das@amd.com
References: <20260427142036.111940-2-shivankg@amd.com>
 <20260427142036.111940-4-shivankg@amd.com>
 <073e5e2c-7102-4141-b0d7-fa5635f811f5@kernel.org>
 <6a5e794a-a608-4126-9abe-0d512a57dd67@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <6a5e794a-a608-4126-9abe-0d512a57dd67@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 80C121A0002
X-Rspam-User: 
X-Stat-Signature: 7cu9ioswptyxyj61doxm9kkj81ptf3wx
X-HE-Tag: 1779093813-13991
X-HE-Meta: U2FsdGVkX198Ebmu5frJT4smzoPp4WwEQEr5nvDaLFlyLH87QbSVjhf1o6z3BZQjr8I250cJkwsx4D93tRjLCJaiINdlqtDHmhZQ8ps/SGWjXYWcIt+Z/k0yQQInr+kKdUIkl1lPYwbygLwoP1KDnhEW/FDX6wrTGxgc6qnYyqxJQLuEroOL1tsPKU/ET30CtysGwgL6XsHBCuCJ1Qbj/GZXhygyOy69Y81bcAATsth3Y+WjEMIXUMtEORGgco0AbzCwmeaoRvxgp3dWoj1lN9gLEwfK7KxhYHj7vNEwd3oGvijQ1Y62MrAxQOc8F7coECYUDyh8aJd53Pmkto9KN52d6BzVvsNP0l7ze/vz0KhCpFM9/hMjW7gVfgR2/OqTk3/UoUmuLEsJ5W6IcjZpbYj8BGxpOg2aURpk+eO/5kJ7Fm3C1Esm/8waejwWELbmKElwhgC5DDSZs0ZNCU5yFuzIwO4cLWi2mHdja2/J60xjQpLdh/trYM2gSEFWMYNpVodGesJ7dXBvcz7Em4Q+BrOiqS+68XQNpneEuLbfWTWmOWYGdIxdKq1xtsUP8tCSwm3TGLfku3VaPmh/LDPfytAizVkjhYmi6OlNyUPLFAgPk9gBWQvRzqtHrdbRFyR2GpjPCnDehnwqzTUZm1fEc5DqIIlpzSiDqPDlCaNtE/ylNjQTrIpOsS+fVLFsa6Osdx9dgm///edORh1yar2s6jsAtyOf/ComfQ2VSgF76HflERWgNRPi/ibwS6WHF9d83r8v/OLsx60cROcZW9ddtFSNtUe/l9Qp/m+ARb1YXWAETdy6ZQujQZZnhK7FqIz3Piq+vgs0EMGldtUQ5FLFZchjrqKjjb506gKMLknopITjL+psG6H6g2CzZQujOaCTAkLy0CFFkUWzsHYBnOa26PuXrVZKKKzrygB3Zv1yWUGUPSvUESngCG5/+i5IxGfR7Rmx17BMzVUHAWQMICU
 /Gby4gDF
 xbZc6efSgbRBJH6ANWRGRhC0wbgQNsENo9nzWas1sCO3vktihFxEG65MYnx9wumJmjzm2d2JpLfCHYWDDP+8+YjNR0FB7UHjbvRBCA3yyql1dqjWe8Nr/JizU3ojo145Q7mtLZuNrsKoyUKO3APJqg8eAZME6I+bkFegSATk2tfoI6guvzY203Mxkk4c+p2QB5fKgirt4wLhzvnRcoC+nEUlExX1ZVk1msPWDBs0BtCAzBH4xi78OyD8xa77T76xuPsT14fozyNoV7V4P/O5PafZne6mjNHYBXlpf7BD9VbXJEoNzPBZrCOhebUuZakAvDzbS/mvKPBx1OtQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/14/26 07:17, Garg, Shivank wrote:
> 
> 
> On 5/12/2026 3:01 PM, David Hildenbrand (Arm) wrote:
>> On 4/27/26 16:20, Shivank Garg wrote:
>>> Rewrite folio_copy() and folio_mc_copy() as thin wrappers around new
>>> batched helpers copy_highpages() and copy_mc_highpages().
>>>
>>> The current implementations iterate copy_highpage() (or its #MC-aware
>>> variant) per 4 KB page. For a single 2 MB folio that loop runs 512
>>> times and pays, per page:
>>>
>>>   - kmap_local_page() / kunmap_local()
>>>   - cond_resched()
>>>   - one invocation of the architecture copy_page()/memcpy() primitive
>>>
>>> The new helpers issue a single copy_mc_to_kernel()/memcpy() over
>>> the whole contiguous range when CONFIG_HIGHMEM is off and no
>>> architecture overrides (__HAVE_ARCH_COPY_HIGHPAGE) copy_highpage().
>>> HIGHMEM and arch overrides keep the existing per-page path.
>>>
>>> Tested on dual-socket AMD EPYC 9655 (Zen 5) with a CXL.mem node.
>>> In-kernel folio_mc_copy() microbenchmark on 2 MB folios, source
>>> evicted from cache before each iteration and measured throughput:
>>>
>>>   direction         baseline GB/s   optimized GB/s   speedup
>>>   DRAM0 -> DRAM1     18.65 ± 1.37    38.03 ± 3.21     2.04x
>>>   DRAM0 -> CXL       25.46 ± 2.89    39.29 ± 1.17     1.54x
>>>   CXL   -> DRAM0     20.61 ± 3.95    35.07 ± 0.62     1.70x
>>>
>>> End-to-end move_pages(2) throughput on anonymous 2 MB mTHP folios,
>>> 1 GB migrated per run:
>>>
>>>   direction         baseline GB/s   optimized GB/s   speedup
>>>   DRAM0 -> DRAM1      7.20 ± 0.03     8.01 ± 0.02     1.11x
>>>   DRAM0 -> CXL       11.12 ± 0.15    13.07 ± 0.03     1.18x
>>>   DRAM1 -> DRAM0      7.21 ± 0.02     7.95 ± 0.02     1.10x
>>>   CXL   -> DRAM0      9.10 ± 0.05     9.49 ± 0.01     1.04x
>>>
>>> On AMD EPYC 7713 (Zen 3 / Milan, REP_GOOD without FSRM/ERMS) the
>>> folio_copy() bulk path regresses because memcpy() falls through to
>>> memcpy_orig (an unrolled movq loop), which is slower than the
>>> per-page copy_page() (microcoded rep movsq) it replaces. 
>>
>> Do you know what the reason for that fallback is? Could it be fixed (e.g., when
>> we detect page alignment or sth like that?)
>>
> 
> The fallback is gated on X86_FEATURE_FSRM in arch/x86/lib/memcpy_64.S:
> 
> SYM_TYPED_FUNC_START(__memcpy)
> 	ALTERNATIVE "jmp memcpy_orig", "", X86_FEATURE_FSRM
> 	movq %rdi, %rax
> 	movq %rdx, %rcx
> 	rep movsb
> 	RET
> 
> AMD Zen 3 does not have FSRM, so it jmp to memcpy_orig (unrolled movq loop).
> 
> 
> On v7.1.0-rc3, I measured these primitives and the kernel's actual memcpy()
> across three CPUs, using a kernel module that vmallocs 16MB src/dst buffer
> and times each primitive for comparison.
> Numbers are mean (in GB/s) ± SD% (= SD as percent of mean).
> 
> 
> 1.) AMD EPYC 7713 (Zen 3), Flags: rep_good only, no ERMS/FSRM:
> 
>   size   unrolled_movq GB/s±SD%   rep_movsq GB/s±SD%  kernel_memcpy GB/s±SD%  
> ------------------------------------------------------------------------------
>    16B      0.38± 8.73%            0.41± 0.43%            0.43± 0.31%
>    32B      0.85± 0.19%            0.80± 8.37%            0.84± 0.07%
>    64B      1.68± 0.35%            1.60± 0.03%            1.59± 9.37%
>   128B      3.23± 0.22%            3.04± 0.62%            3.19± 0.03%
>   256B      5.99± 5.78%            5.62± 4.15%            5.93± 0.42%
>   512B     10.07± 1.36%           10.49± 2.60%           10.02± 0.21%
>     1K     14.49± 0.09%           18.19± 0.37%           14.31± 3.48%
>     2K     17.11± 1.01%           28.04± 2.37%           18.14± 0.56%
>     4K     18.36± 0.22%           39.15± 0.50%           19.57± 1.14%
> 
> - kernel_memcpy is tracking unrolled_movq.
> - rep_movsq is 1.4x-2x faster than the unrolled_movq fallback for >= 1 KiB.
> 
> 2.) On Intel(R) Xeon(R) Platinum 8362
> Flags: rep_good, erms, fsrm
> 
>   size  unrolled_movq GB/s±SD%   rep_movsq GB/s±SD%   rep_movsb GB/s±SD%   kernel_memcpy GB/s±SD%
> --------------------------------------------------------------------------------------------
>    16B      0.89± 0.93%            0.64± 0.10%            0.69± 0.57%            0.66± 3.52%
>    32B      2.08± 2.46%            1.28± 0.15%            1.38± 6.21%            1.33± 4.28%
>    64B      3.97± 2.26%            2.55± 0.24%            2.83± 0.22%            2.65± 4.48%
>   128B      7.45± 0.09%            5.00± 2.53%            5.48± 5.04%            5.30± 1.60%
>   256B     13.24± 0.01%            9.79± 0.57%           10.12± 0.37%            9.81± 0.34%
>   512B     21.67± 0.03%           17.87± 0.02%           18.43± 0.79%           17.81± 0.25%
>     1K     27.84± 1.96%           34.54± 1.24%           35.67± 1.88%           34.56± 2.49%
>     2K     32.67± 2.35%           59.58± 0.01%           65.67± 0.18%           59.35± 1.12%
>     4K     34.85± 0.64%           95.35± 0.00%           96.64± 0.69%           95.35± 0.00%
> 
> - kernel_memcpy is using rep_movsb (FSRM in use). 
> - Below 512 B the unrolled movq loop is ~20-50% faster, >1 KiB FSRM wins.
> 
> 3.) On AMD EPYC 9655 96-Core Processor (Zen 5)
> Flags: rep_good, erms, fsrm
> 
> size   unrolled_movq GB/s±SD%    rep_movsq GB/s±SD%       rep_movsb GB/s±SD%   kernel_memcpy GB/s±SD%
> --------------------------------------------------------------------------------------------
>    16B      0.53± 0.39%            0.53± 0.21%            0.55± 0.13%            0.53± 0.14%
>    32B      1.13± 1.49%            1.06± 0.07%            1.09± 0.16%            1.06± 0.09%
>    64B      2.21± 0.12%            2.13± 0.07%            2.18± 0.14%            2.13± 0.09%
>   128B      4.25± 0.12%            4.26± 0.10%            4.37± 0.12%            4.31± 0.14%
>   256B      8.01± 0.19%            8.61± 0.27%            8.61± 0.18%            8.51± 0.10%
>   512B     14.14± 0.18%           16.80± 0.24%           16.80± 0.23%           16.81± 0.24%
>     1K     22.93± 0.73%           31.70± 0.48%           32.37± 0.28%           32.02± 0.22%
>     2K     30.36± 0.27%           53.24± 1.01%           56.58± 0.22%           56.04± 0.22%
>     4K     35.05± 0.65%           80.25± 0.41%           83.90± 0.20%           76.23± 0.37%
> 
> - kernel_memcpy is using rep_movsb (FSRM in use). 
> - For smaller size, unrolled movq are close enough to be within noise.
> 
> 
> Regarding the fix,
> One option is to make memcpy() fall back to rep movsq instead of unrolled
> movq loop when FSRM is absent. The data shows the benefit on Zen 3. For
> the Intel, unrolled movq is faster for smaller sizes.
> But, I'm not sure if adding these complexities to memcpy() is welcome.
> Happy to work on this if it is helpful.

I was wondering whether optimizing memcpy() further would be of value elsewhere.

Of course, we wouldn't want to degrade it :)

Some direction from x86 folks would be nice.

> 
> Another option is to leave memcpy() untouched for this series and add
> a new copy_pages() helper that the folio copy path can use. It would
> use ALTERNATIVE_2 that picks rep movsb on ERMS/FSRM and rep movsq on
> REP_GOOD and per-page copy_page() loop as the final fallback.

That would fit the clear_pages() design we have. But if that's avoidable, that
would be nice.

-- 
Cheers,

David

