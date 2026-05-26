Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E47EBCD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 12:45:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A5D36B00B8; Tue, 26 May 2026 08:45:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57D1A6B00BD; Tue, 26 May 2026 08:45:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46B9B6B00C1; Tue, 26 May 2026 08:45:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F2E46B00B8
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:45:36 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E66988DEBA
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:45:35 +0000 (UTC)
X-FDA: 84809542230.25.9CB70AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3696B100006
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:45:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NLFTsAWM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779799534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QzlfLKei3OF/tSTWl5q71VoQJ0uXecHs8Dxb+dYN9G4=;
	b=iLFZCIfLNIxlokZkX4vYfnqvpncXp0wgAC3oMm4mbWe0CjhsEwWpoZ8D63GiHC8HcQjf5z
	Y2whWVRwHa2Me2kPuHK6FcWng0wd2ltpj7qLzkQUnl114utHVm+6oqDqq3/KZ7mBHScdeb
	amp9gR5+Tpi5QnPslym4p8IYEXNWpHY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NLFTsAWM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779799534; a=rsa-sha256;
	cv=none;
	b=eR/5zW6Yxcg7qP7/fJ0C+GLL59Q0LQiKOi+VFKu35HAAP32WjNSTIMXGOibiWiNcAiGw3X
	GwVhND1hH8ALx3gaZEamAQ4TRDB4orRUqclIwVBs3iwJVPsJbQc7qCvtGZvv6wuuNePL0t
	jHFD7gw7kSxcRCcd6Ce9ShWLlcKGqzk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AE1C3601D8;
	Tue, 26 May 2026 12:45:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16F81F000E9;
	Tue, 26 May 2026 12:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779799533;
	bh=QzlfLKei3OF/tSTWl5q71VoQJ0uXecHs8Dxb+dYN9G4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NLFTsAWMim8BkpWfM13Ly59xEKPU0Gh340MP2ykVv6v7CucDM8RMVDkl0RU8kOWv5
	 ZgUwwfWA6Y0O3Bv52yc6C4UCN8Gdpv+sY73hXVMF5IgxzOyV7DHN0ywB0iBh1B5ZUr
	 sNc2S2C9x5k2lf+3OkuU1WufuYGwUvX/rfOOnQk5UGAtzhozONeCKBkr1rYaWbRIpH
	 w+1VCdz9YrDSKNgjzqz5Ja8ZI06r5AvQU0oAZl8JvkGm065SjZ/ZzTxUfO+DJUk781
	 CzaEjH5dLhj6ywN0EpBCKC7xAZ5vAHQ9Kxox4/Co/pSSg3/XNbJtrRRP14CY790KzX
	 MD8kcSakTORtA==
Message-ID: <7fd673df-22f3-4d70-a779-ea0b878188b3@kernel.org>
Date: Tue, 26 May 2026 14:45:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] bpf: Recover arena kernel faults with scratch page
To: Tejun Heo <tj@kernel.org>, David Vernet <void@manifault.com>,
 Andrea Righi <arighi@nvidia.com>, Changwoo Min <changwoo@igalia.com>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Martin KaFai Lau <martin.lau@linux.dev>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev,
 bpf@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260522172219.1423324-1-tj@kernel.org>
 <20260522172219.1423324-3-tj@kernel.org>
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
In-Reply-To: <20260522172219.1423324-3-tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ynkmzn7i616qn8md3pf6pq47kbs8xx4n
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3696B100006
X-Rspam-User: 
X-HE-Tag: 1779799534-496429
X-HE-Meta: U2FsdGVkX1/qqkIrufD++nY+d3LLZcryB9qkQI7LsbBrolZ+GJxl5Apd5yc5mw5RzuPf6cQL/s+Z7U1N4EC8vysKK7m69poQQGH+FTz+kQTLSaQx4jwT0X/nlhyFGtjiGdz45DaDu9uaXp7NBOrDCEla7+F7At8q3EzJouDCsn1kgK1SHnrFRBBK+PLpQm1ckEKC0Ef4SRdQxmZiFP93POu0lPt2LRNBjeLTRPAWRgV3dmoN8CuaNlWfHYWr/EoZPmaznNnMqFGMXWVvi/7XRAYuXmAcu8goGB5LcCSdKQbJXtn2d2svR7xjd5b6pBBez+AhLHei+7sX7zGBy6ovIPVFpYMNGxip0ryBhX5QiJ2eCzpQo+hQbL+gD22jJ3Qxx2OHW6Ut7QqTCeCJrDVCg9f137oDinOPivAbuB7Zi/oatdKw89Ap90WlaI5wAMTVUOENQRVlET4BwNuYDrd+9A0dGA44jUeGDhAIPqEksG0FWTilRPtTkJHjZ48vkBwso5eTziY8wc2Q/stMvrDvtgUQ0XaFtpv4eoQxMAKCWqVNhNZg2C3vFWBq4h++38+rTsWM5nbSISIoV7G+TfkpWEluyDXOrZT5WTJXjWO1N9P4i4hshiNY/mT7WLmYarYPEjgRdPEtRqjUXxUsa018fELrZ3dX6nQoCCaMhBplSPhaMLtcc9ESvQ86mlPt3eMVdtNPI+KBZDYA/weA/xULK07WhstJU01rQYbKgBE/tLLRV4ska+0L8x3/w9IfsO34viw++HZO8p8udS5ltVSNrWymWi5UnfXLMKyQuxMuRBmAoyHIIR1l1fLysrabVzcit+R6C6UV8gcOt1xE1VaBqOkjfgMPIEqmHBd1nyFhZsAp0V29hcb77eBsNYARm5Ko5kS+pYXVtH3MLihN98cQMNxdXhztAlUTSOR9q1eH4bgt4i+gz65HPlYTPpVpnoJOxMMaUwD8PTIeLGgBjCP
 ekaq1asu
 Ua1i9YbXtutzVgXhsh3kRi5DqbUS/3+Y/bczCnmS8cWzZov5kOtJATze/xUqOzySyKJ3l/39XjIARx4RKaejcVy8d9wRQTLls1vMTgNegB2C/9eVjjJDegaDzUwHQkDgl2Hexdd+5wL7qEI75Kg/MS/oAlOUlSCZG47C2tnEnBq4YoAzzdK5t0VnceGoae5MZ+wX2afzuVRxK9HoHZ3kwEdDsst2dHlDTjY6xuMIxuztLrOx3LJoi1swLvI9ZSAu7jy4TUT5Z4BiKicYKZUaurhQHUwWqPv4JLb0M6ssBYobb6NH6UsaVwpLEUyUnxNwinxyCwCLkJ9wZbGJNoHXbyanb3YgjjBdR3gARavys1DuTaA0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/22/26 19:22, Tejun Heo wrote:
> From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> 
> BPF arena usage is becoming more prevalent, but kernel <-> BPF communication
> over arena memory is awkward today. Data has to be staged through a trusted
> kernel pointer with extra code and copying on the BPF side. While reads
> through arena pointers can use a fault-safe helper, writes don't have a good
> solution. The in-line alternative would need instruction emulation or asm
> fixup labels.
> 
> Enable direct kernel-side reads and writes within GUARD_SZ / 2 of any
> handed-in arena pointer, without bounds checking. A per-arena scratch page
> is installed by the arch fault path into empty arena kernel PTEs - x86 from
> page_fault_oops() for not-present faults, arm64 from __do_kernel_fault() for
> translation faults, both after the existing exception-table and KFENCE
> handling. The faulting instruction retries and the access is also reported
> through the program's BPF stream, preserving error reporting.
> 
> bpf_prog_find_from_stack() resolves the current BPF program (and its arena)
> from the kernel stack - no new bpf_run_ctx state is added. Recovery covers
> the 4 GiB arena plus the upper half-guard (GUARD_SZ / 2). The lower
> half-guard is excluded because well-behaved kfuncs only access forward from
> arena pointers. The kfunc-author contract - access at most GUARD_SZ / 2 past
> a handed-in pointer - is documented in Documentation/bpf/kfuncs.rst.
> 
> The install is lock-free via ptep_try_set(). On race-loss the winning
> installer's PTE is already valid, so the access retry succeeds. The arena
> clear path uses ptep_get_and_clear() so installer and clearer race through
> atomic accessors. No flush_tlb_kernel_range() afterwards. Stale "not mapped"
> entries just cause one extra re-fault, cheaper than a global IPI on every
> install.
> 
> Scratch exists only to keep the kernel from oopsing on an in-line arena
> access. Its presence at a PTE means the BPF program has already
> malfunctioned, and the violation is reported through the program's BPF
> stream. The only requirement for behavior on a scratched PTE is that the
> kernel doesn't crash. In particular, any user-side access through such a PTE
> may segfault. The shared scratch page is freed once during map destruction.
> 
> BPF instruction faults continue to use the existing JIT exception-table
> path. This patch changes only the kernel-text fault path. No UAPI flag is
> added. The new behavior is the default.
> 
> v2: Use ptep_get_and_clear() in apply_range_clear_cb(). (David)
> v3: Stub bpf_arena_handle_page_fault() for !CONFIG_BPF_SYSCALL. (lkp)
> 
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
> Cc: David Hildenbrand <david@kernel.org>
> ---
>  Documentation/bpf/kfuncs.rst |  14 +++
>  arch/arm64/mm/fault.c        |  10 +-
>  arch/x86/mm/fault.c          |  12 ++-
>  include/linux/bpf.h          |   1 +
>  include/linux/bpf_defs.h     |  19 ++++
>  kernel/bpf/arena.c           | 177 +++++++++++++++++++++++++++--------
>  kernel/bpf/core.c            |   5 +
>  7 files changed, 191 insertions(+), 47 deletions(-)
>  create mode 100644 include/linux/bpf_defs.h
> 
> diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
> index 75e6c078e0e7..6d497e720998 100644
> --- a/Documentation/bpf/kfuncs.rst
> +++ b/Documentation/bpf/kfuncs.rst
> @@ -462,6 +462,20 @@ In order to accommodate such requirements, the verifier will enforce strict
>  PTR_TO_BTF_ID type matching if two types have the exact same name, with one
>  being suffixed with ``___init``.
>  
> +2.8 Accessing arena memory through kfunc arguments
> +--------------------------------------------------
> +
> +A read or write at any address inside an arena does not oops the kernel.
> +Unallocated arena pages are lazily backed by a scratch page and the
> +access is reported through the program's BPF stream as an error. Only
> +the BPF program's correctness is affected; the kernel itself remains
> +intact.
> +
> +The arena is followed by a ``GUARD_SZ / 2`` (32 KiB) guard region that
> +is also covered by this recovery. A kfunc handed an arena pointer may
> +therefore access up to ``GUARD_SZ / 2`` past it without bounds-checking
> +against the arena. Larger accesses must verify the range explicitly.
> +
>  .. _BPF_kfunc_lifecycle_expectations:
>  
>  3. kfunc lifecycle expectations
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 920a8b244d59..0d58d667fcd8 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -9,6 +9,7 @@
>  
>  #include <linux/acpi.h>
>  #include <linux/bitfield.h>
> +#include <linux/bpf_defs.h>
>  #include <linux/extable.h>
>  #include <linux/kfence.h>
>  #include <linux/signal.h>
> @@ -416,9 +417,12 @@ static void __do_kernel_fault(unsigned long addr, unsigned long esr,
>  	} else if (addr < PAGE_SIZE) {
>  		msg = "NULL pointer dereference";
>  	} else {
> -		if (esr_fsc_is_translation_fault(esr) &&
> -		    kfence_handle_page_fault(addr, esr & ESR_ELx_WNR, regs))
> -			return;
> +		if (esr_fsc_is_translation_fault(esr)) {
> +			if (kfence_handle_page_fault(addr, esr & ESR_ELx_WNR, regs))
> +				return;
> +			if (bpf_arena_handle_page_fault(addr, esr & ESR_ELx_WNR, regs->pc))
> +				return;
> +		}
>  
>  		msg = "paging request";
>  	}
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index f0e77e084482..b0f103ddbd23 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -8,6 +8,7 @@
>  #include <linux/sched/task_stack.h>	/* task_stack_*(), ...		*/
>  #include <linux/kdebug.h>		/* oops_begin/end, ...		*/
>  #include <linux/memblock.h>		/* max_low_pfn			*/
> +#include <linux/bpf_defs.h>		/* bpf_arena_handle_page_fault	*/
>  #include <linux/kfence.h>		/* kfence_handle_page_fault	*/
>  #include <linux/kprobes.h>		/* NOKPROBE_SYMBOL, ...		*/
>  #include <linux/mmiotrace.h>		/* kmmio_handler, ...		*/
> @@ -688,10 +689,13 @@ page_fault_oops(struct pt_regs *regs, unsigned long error_code,
>  	if (IS_ENABLED(CONFIG_EFI))
>  		efi_crash_gracefully_on_page_fault(address);
>  
> -	/* Only not-present faults should be handled by KFENCE. */
> -	if (!(error_code & X86_PF_PROT) &&
> -	    kfence_handle_page_fault(address, error_code & X86_PF_WRITE, regs))
> -		return;
> +	/* Only not-present faults should be handled by KFENCE or BPF arena. */
> +	if (!(error_code & X86_PF_PROT)) {
> +		if (kfence_handle_page_fault(address, error_code & X86_PF_WRITE, regs))
> +			return;
> +		if (bpf_arena_handle_page_fault(address, error_code & X86_PF_WRITE, regs->ip))
> +			return;
> +	}
>  
>  oops:
>  	/*
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 0136a108d083..831996c411cf 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -6,6 +6,7 @@
>  
>  #include <uapi/linux/bpf.h>
>  #include <uapi/linux/filter.h>
> +#include <linux/bpf_defs.h>
>  
>  #include <crypto/sha2.h>
>  #include <linux/workqueue.h>
> diff --git a/include/linux/bpf_defs.h b/include/linux/bpf_defs.h
> new file mode 100644
> index 000000000000..2185cd3966d4
> --- /dev/null
> +++ b/include/linux/bpf_defs.h
> @@ -0,0 +1,19 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Subset of bpf.h declarations, split out so files that need only these
> + * declarations can avoid bpf.h's full include cost.
> + */
> +#ifndef _LINUX_BPF_DEFS_H
> +#define _LINUX_BPF_DEFS_H
> +
> +#ifdef CONFIG_BPF_SYSCALL
> +bool bpf_arena_handle_page_fault(unsigned long addr, bool is_write, unsigned long fault_ip);
> +#else
> +static inline bool bpf_arena_handle_page_fault(unsigned long addr, bool is_write,
> +					       unsigned long fault_ip)
> +{
> +	return false;
> +}
> +#endif
> +
> +#endif /* _LINUX_BPF_DEFS_H */
> diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
> index 08d008cc471e..1c0b87ecc817 100644
> --- a/kernel/bpf/arena.c
> +++ b/kernel/bpf/arena.c
> @@ -53,6 +53,7 @@ struct bpf_arena {
>  	u64 user_vm_start;
>  	u64 user_vm_end;
>  	struct vm_struct *kern_vm;
> +	struct page *scratch_page;
>  	struct range_tree rt;
>  	/* protects rt */
>  	rqspinlock_t spinlock;
> @@ -118,6 +119,11 @@ struct apply_range_data {
>  	int i;
>  };
>  
> +struct clear_range_data {
> +	struct llist_head *free_pages;
> +	struct page *scratch_page;
> +};
> +
>  static int apply_range_set_cb(pte_t *pte, unsigned long addr, void *data)
>  {
>  	struct apply_range_data *d = data;
> @@ -144,33 +150,59 @@ static void flush_vmap_cache(unsigned long start, unsigned long size)
>  	flush_cache_vmap(start, start + size);
>  }

There is still the chance that apply_range_set_cb() could race with scratch
insertion, right?

Shouldn't we also be using ptep_try_set() there?

The nasty thing is handling whether ptep_try_set() actually works.

Something like the following on top, maybe?


diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 49a8f7b1beef5..086bea3f3698e 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -122,19 +122,27 @@ static int apply_range_set_cb(pte_t *pte, unsigned long
addr, void *data)
 {
        struct apply_range_data *d = data;
        struct page *page;
+       pte_t pteval;

        if (!data)
                return 0;
-       /* sanity check */
-       if (unlikely(!pte_none(ptep_get(pte))))
-               return -EBUSY;

        page = d->pages[d->i];
        /* paranoia, similar to vmap_pages_pte_range() */
        if (WARN_ON_ONCE(!pfn_valid(page_to_pfn(page))))
                return -EINVAL;

-       set_pte_at(&init_mm, addr, pte, mk_pte(page, PAGE_KERNEL));
+       pteval = mk_pte(page, PAGE_KERNEL);
+#ifdef ptep_try_set
+       if (unlikely(!ptep_try_set(pte, pteval)))
+               return -EBUSY;
+#else
+       if (unlikely(!pte_none(ptep_get(pte))))
+               return -EBUSY;
+
+       set_pte_at(&init_mm, addr, pte, pteval);
+#endif
        d->i++;
        return 0;
 }

-- 
Cheers,

David

