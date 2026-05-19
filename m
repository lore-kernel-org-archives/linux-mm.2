Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33CB3CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 09:41:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8337F6B0005; Tue, 19 May 2026 05:40:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E4596B0088; Tue, 19 May 2026 05:40:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D4106B008C; Tue, 19 May 2026 05:40:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5BA836B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 05:40:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 06053120265
	for <linux-mm@kvack.org>; Tue, 19 May 2026 09:40:59 +0000 (UTC)
X-FDA: 84783675438.27.37477CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2E4A620010
	for <linux-mm@kvack.org>; Tue, 19 May 2026 09:40:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uhx90dnE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779183657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MIrObDOfXFbZhi/VTwXhO6qhI6xDdMal5EyvLao9RFM=;
	b=1Kd1Ic1Io3Bjo55Sge7mXSsuWRCY3TFxhGWsbG4pkZV4Ksn0kiqSnR8Q6vsEouuy3Aoi5A
	U8klfq5MfAQoKVBmRcjUdHlVjRAPdbENYDdialwWJ2vw6AYONDifI3JGySe0rGOkHL8Qz6
	wkDVqWM/qHmcSqHgbWJPRiSj1bP+rOI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779183657; a=rsa-sha256;
	cv=none;
	b=rk4Nod8RATZneW05e30H7oXV0VsAQWuZFT8JnZxC+JW6KuP61MhKgShvWtesGZvBZ8+qjt
	IudpskOIDeMmz+HTjCV9EuIOdBxFksdRpiBSdDai9XEGm41rQbZMw2LKSTStWsGpLLSYIM
	qUcsKptwnli4KO/HMdzF5VDjDIzoGWM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uhx90dnE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 06F5041531;
	Tue, 19 May 2026 09:40:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5028DC2BCB3;
	Tue, 19 May 2026 09:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779183655;
	bh=fkmrgQQrDeNLvc7UDu335ZGUAhYjlNgB6Tk2RSRZEeY=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=uhx90dnE2FxSA1Q+pm9JvVN1iC6B44MyYb2rgxqeF/jFZZvJnGvxX/RrMmMGlpiAD
	 z8QqfdXed3V1eWPHiuooTxUNB0Y/uXpHXH2nmVTBz5KeS04T0iSmkIemcc+0zlm/eh
	 QxDDEW7LtG49E+rRDf0qC8dnFLgvsJVtnbB8BVSEqOluCl9EU6lTqHYSC4/hNSq4vr
	 BYeaMktKuUf+zZNNuqvZzyH3EVXZyJTQeiac2BnOHdR3Vm2JDTjWSAUCk+maErkUhZ
	 Fis5VxTYy5VHxo24pyKKrgJsaIvBZ3cIu4NEeBEmEY34qRWOaG+VRXfqU40Mn0njLS
	 n7tmGSmkK0D3g==
Message-ID: <5590fd3d-dae1-4070-b52f-bc40982ac678@kernel.org>
Date: Tue, 19 May 2026 11:40:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] mm: Add ptep_try_install() for lockless empty-slot
 installs
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: David Vernet <void@manifault.com>, Andrea Righi <arighi@nvidia.com>,
 Changwoo Min <changwoo@igalia.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Martin KaFai Lau <martin.lau@linux.dev>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev,
 bpf@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260517211232.1670594-1-tj@kernel.org>
 <20260517211232.1670594-2-tj@kernel.org>
 <9ba50fd2-077e-4291-9276-9adb18186873@kernel.org>
 <agtuPrgIDNKSu2Oo@slm.duckdns.org>
 <2f02d90d-cdc9-48ef-abe3-99e00f22595f@kernel.org>
 <297658c4ae2d6e7103f5968efc936224@kernel.org>
 <04b03066-86d3-4c0b-b077-307fd0f3bc9c@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <04b03066-86d3-4c0b-b077-307fd0f3bc9c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E4A620010
X-Rspamd-Server: rspam04
X-Stat-Signature: ybahfww4ku5syf78cju61sb3xy4ypexz
X-HE-Tag: 1779183657-368350
X-HE-Meta: U2FsdGVkX1/tAd9VRe4RqFpDWRRBPBfUxSQgR5a9eL8HXiduROhW7b0cwkHFCc17tsAtQbeK5mzk+bfEYNdYNiuYSbeFiy3EFPQuH98o/m9takAe7VaT/Xo6OoHGOStr0eSt2I0qEQWzBReR/BC+3+zaDW6xYcCf7TWdHO1jsDhHuAdtwCZ6t0EIhebOi73cF4uQsUsh1UkIGaG9E7jPBrbUsM35tlQsKSL3gLj0I9LXSb4943hukGuG79SXzQ9ppEbRW/X337TVC/q3hfJ7gxW1ocOGR3fyMWxMhrFP689naAgW3zVF8kqqaCYZp1whJfKcns0pfILPM8N01rq+Rz+bGOzllZaoKdm8Ko1uqM26r0VX/32Ay2/WHZ2/WSNaggFQAOBcnyK4EQivz1raKQETFhmxeQ8/dmRpompsd62I85Td1KoQZ5ogG3hfKIJa2Bp429RLQKYNgWIZxzA+Cm9miuM9Q/S6VdRqqRijacOklOxAAGLKHWmrDp5rzCuByucnGMtZBBs8ISPtWAz5MfNPkHmrfu4NVlNK/SAi4B9ErXymG5l9ygv9TtZtgWSaB+BVawUMNuvqHJ5yoiEqrUEXmV8hpzakQx7njWhapRjhtmLeprryyhl2guXYlXiN2r7zHKMAiO/QssIU/BkdHaNABz4D/nedJbh9+FsVHyM/qDg6GvWR+bMbzhPWZnWy+fjzZw3g4/7+SyQ2MetCTVV2ddlXyGuEdRnW5tVQ4C3vewgQJAaJq/tCxtBEVkyA2PbTdsf9Y1cjNhx9nxy4NbaW/3jhScxWv+vu+qRQrcuY8dmozgC7AVGLivGXGZwhvHVzx+4/CFTBV1R8jIK7WoZcj93kGKD+RLtsFet15cmdeikRX86/90Wr5+1C3obDNt5bzVCSFZR5zaGtebS3GYQqMdcbHtLoJwzLzQ/zX1DsvN5cjCXJkqzMgrLCL4ZzF9uZSc//qNC/jjQaMPk
 GaO2fPUV
 QFoKhk4LaxaAbjDlLXMaWaeglIWD22ASA71F1UdOhJg/gDC9vPqX3bXfmet564Wd4M6XZA1IA44LPuBTfc9fUL9CvE5zFFhHLmfV/AZ93lgrsKXWRTuXBigciFsuISok2Wv+JjDGYHX0FUrmiIc6NKo0Et0Tv1L2THRkw7ap1cTJOqBUEYBDHYFlTIEckAvZReJm0BCXq00M84/sTDLsNalpDbxGazoOW2Cv7dBgF5Y67hsTxCzgzCpeYV6qlLPTyPBNh4+LNkvnk2TmL/mWyyeV8klE38RGmm7WcTbkGhIqSs1VrE+soaTFk2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/19/26 11:05, David Hildenbrand (Arm) wrote:
> On 5/19/26 10:58, Tejun Heo wrote:
>> Hello, David.
>>
>> On Tue, May 19, 2026 at 10:00:39AM +0200, David Hildenbrand (Arm) wrote:
>>> Is that really possible? I'd much rather prefer to trylock and retry, unless
>>> that can really result in deadlocks. But I have the feeling that such deadlocks
>>> should be impossible here.
>>
>> I'm not well versed in either mm or BPF, so the BPF folks will have a
>> better take. But here's a scenario that seemed plausible to me:
>>
>> 1. A bpf prog calls bpf_arena_alloc_pages() on its arena. The kernel
>>    takes arena->spinlock via raw_res_spin_lock_irqsave().
>> 2. Under the lock, the alloc path goes through bpf_map_alloc_pages()
>>    -> alloc_pages_node(), which fires trace_mm_page_alloc().
>> 3. A BPF tracepoint program on mm_page_alloc that shares the arena
>>    starts running with the lock still held.
>> 4. The tracepoint program calls a kfunc, passing an arena pointer
>>    one entry past the array it meant to touch.
>> 5. The kfunc dereferences. The kernel-side address is unbacked, so
>>    the CPU faults.
>>
>> trylock + retry at 5 would A-A deadlock.
> 
> Okay, so removing that specific tracepoint (or rather, any tracpoints under the
> lock) would solve the problem, right?
> 
>>
>>> For example, staring at apply_range_set_cb(), what prevents:
>>>
>>> (1) apply_range_set_cb() finding pte_none(ptep_get(pte)
>>> (2) apply_range_set_scratch_cb() succeeding ptep_try_install()
>>> (3) apply_range_set_cb() overwriting the pte with set_pte_at()
>>>
>>> Between (2) and (3) CPUs could access the scratch PTE.
>>
>> Scratch only gets installed when BPF passes an unallocated arena
>> address to the kernel side, which is itself the violation, reported
>> through the program's BPF stream. Behavior at that addr is then
>> undefined. For scx, the scheduler should be aborted and torn down.
>>
>> The only requirements are that the kernel doesn't oops and the
>> violation gets caught. Beyond that, behavior at the address is
>> unspecified, and which installer wins the race doesn't matter as
>> long as kernel integrity holds.
> 
> You'll have inconsistent TLB state.
> 
> I really don't like that approach.
> 
> We should really try to just take the lock, and remove any code under the lock
> that could trigger such unpleasant deadlocks.
> 
> Is that feasible?
> 

... or can we run into similar problems with kprobes? (I am obviously no bpf
expert ...)

-- 
Cheers,

David

