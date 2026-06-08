Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B1F3CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 13:18:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66E096B0005; Mon,  8 Jun 2026 09:18:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61E596B0088; Mon,  8 Jun 2026 09:18:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 534136B008A; Mon,  8 Jun 2026 09:18:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3AC6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 09:18:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BDF5F40AE4
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:18:48 +0000 (UTC)
X-FDA: 84856800336.14.8453FF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id DFF1C1C0009
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:18:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GV2KP8CT;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780924727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZN1ZvkZDY/LEZF9N0uUQfpxtoosM8iQuEpRD3wCQ7CM=;
	b=wpNfqKwo6DiSJ7Kmaq3aDyU+C3JKi93mktxKweHrmiMBPQmUjg1LVBr1GNBKJ4G6ztG//i
	kBcc0t+onZCRL9Rns5Z+PnWlMc+982RIybfoncRcNjSR/0itKMFvXK1+D5DSkKXO/Q6I/I
	k9xriY9VLF7ARfNcCO8qQPkwDAA8Y9M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780924727;
	b=G+PQRcDh+BBk0J6Ma+ByijGThuekGbW186our9eyUOOC6qcYZyUY5v5+KbjIs3deFvH0Ip
	cxh9919b1vf6YGRNDfcek38eP8aYQ5gVP1YCiaAwyuoMy7FtJk9iyshVX4x0ncA+oNA9k6
	jZzB2jXJH4tWnlp39nP/nwWHJg85X3E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GV2KP8CT;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2571540DB4;
	Mon,  8 Jun 2026 13:18:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802511F00893;
	Mon,  8 Jun 2026 13:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780924726;
	bh=ZN1ZvkZDY/LEZF9N0uUQfpxtoosM8iQuEpRD3wCQ7CM=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=GV2KP8CTIGLCohmYmuza3YMKpuABEWvhtoJg5DxLX5xkV19RoZyjxJSEQiEbthysq
	 IMNiQfGL0n+HGlGiXugLyK8iyHHMbrEb19qGYykBj4EejGVARJYNMpjyxZ3rfhNxm0
	 174zDEl65Gu0tuhkr808G0eApwPNZMGa5+xSdleI4zHCWdyXx5PjzfqNfyubqU0TIQ
	 kiA7KgTgkBcEsLQM7f2aQS1UMwmWNSdMrpco/QhtGJPZLi+FPSDDVhuxdWSX73Jd7T
	 ANH+eNWyj/PLSfAYp6+fv0LOvkT3T+8I3vCMjVhZ2vssajlbHlHTPSrk2I0o7eHuTH
	 Sedy14q9M9m/w==
Message-ID: <6a92f2c6-3b67-44fb-b645-91164118d8fb@kernel.org>
Date: Mon, 8 Jun 2026 15:18:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] riscv: mm: Avoid spurious fault after hotplugging
 vmemmap
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Vivian Wang <wangruikang@iscas.ac.cn>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260605-mark-after-vmemmap-populate-v3-1-a06001ac9264@iscas.ac.cn>
 <da19ffcf-8042-4f96-9c2d-649468dc6a0a@kernel.org>
 <953d7a60-456d-4629-b133-afce62cc5b3e@iscas.ac.cn>
 <3c88dee8-6fcd-4f72-9a73-17044214b087@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <3c88dee8-6fcd-4f72-9a73-17044214b087@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DFF1C1C0009
X-Stat-Signature: 8ugcwjknzbmywpm746egokbx4e83uo4z
X-HE-Tag: 1780924726-373038
X-HE-Meta: U2FsdGVkX19lqzGHWtfeAWbdiTb8FD/AD9ZIlcWikmmI+/AL3/sFgDT0UggLaipxHutgyTnT3+jQbIILYrOOJ9jXBwx9UvaMLnKAk/AzHKF8CVeAKsHg+kh6oM+5/3bB7ce3u7QRNMcR251S8eiC7WlBh3AQzPG+gCAkLCCqdBw9000rdGyKlw9D9yqfJnIikCPyKVsnxe4B+k3ufTK3DP3Y7vs4/Xu3sdfAOlYGJO69NyKoYBQs+6parO5JsVxysMwQp1kheoov+tS/WYWUiDRAzwfmJ5t9Yf9k/FF2cx/S8MMrvS3JJDeoIffonDYYWQ8BsRvB4uBT1Tgl1289sIQ2zVY/rfyu8kqDtYyCeAcAoLmMuEx0r+MjBv6TVGM1/Xm8dDMZJSAe2Tn5rSnbAaXXu9yOwzND0RxEOiSjI45j5T1FC3WUgeLevOlOKswd7Ce5JfP+lqIwu+A+F8r2GETUCAsLRCpfuLVeVktYvxrzhhi1YRc6snls6nzBDsf/x5ABVLASjd5DUMy3fKALJQ8B+Rq5nnXhyxy11OXsRK+hHXdp6Ds4LfQByF7Sw60hD458kEgy6TA8mC2NvOl1YrjiqouiqurJAkPTyFHc9oGYohhM1bsL8B5o3GazRp8Kik54k52rjlylv1yzMaKCvYsqLm5U8u+2vzL7IMShGs930PSo0EPat6IbHYrGaeH8zQjRl8MDBuJy5SqH1vmFn980JJK2K4SnzMgPQmrs/J3PczyF5xOlQgIi4AJArFVHB03nY82mw/FZpSQUhAHl4Bqp1FqXBVqHj/sGggvC25gl8yapW2J2jBP1uON8KoN2ummyX1I0wkvxmpLJuOrHR4qEyL/He6cceyj1FiTDXjKPTTFxWydhINdGJeBOmVqdqcmakuf92ssvjjEIP0UUBlGlySV+B7jEC5ZTb8rAFGEe7mlij+XTlN7+MtuC7w23AAYb15E6BeNpuosX2Ub
 HGYCCs+A
 mUzpUfZcHEfxW2zydL/VTJhHryaQ/jkEIevBnV0ZqHGDki4XmgBrM706VuI2mv7rz29aaCaA+m9giKIM+eV3XahRUvVHIJBieR1pXBfBoBYs44jCvaj6UjOeu/RVqyP/osZVAOmhKMu8Cs4fp+2ZdDyzsBvXok8yWnXnvySGBvpHNzO2Hl8MExabylR7LjB2AD0bwipyTq0/uWjEDXhjDlOwUq9hc7Z3emKVJgN1M9a7LybW+aA2WSBKHfWSCxR/36MAR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/8/26 14:43, David Hildenbrand (Arm) wrote:
> On 6/8/26 04:24, Vivian Wang wrote:
>> On 6/5/26 17:16, David Hildenbrand (Arm) wrote:
>>> How does mark_new_valid_map() handle concurrent access?
>>>
>>> There is some comment in there, but I am not sure if that actually implies that
>>> mark_new_valid_map() can be called concurrently from arbitrary context?
>>
>> AFAICT, yes, it is intended to be used concurrently from arbitrary
>> context, and this is why I used them.
>>
>> I had not originally written the code, so some riscv maintainer can
>> maybe chime in on this, but as I understand it the idea is that we only
>> ever set bits in the bitmap in mark_new_valid_map() while "allocating",
>> whereas the assembly code in handle_exception in
>> arch/riscv/kernel/entry.S only ever clears individual bits. So at least
>> the access to the bitmap itself should be fine.
> 
> Right, flush_cache_vmap() looks like a bitmap_set() -- non-atomically.
> 
> .Lnew_vmalloc_kernel_address does an atomic bitmap clearing ("Atomically reset
> the current cpu bit in new_vmalloc").
> 
> I am primarily wondering whether we'd want atomic bit-setting as well?
> 
>>
>> This was added in commit 503638e0babf ("riscv: Stop emitting preventive
>> sfence.vma for new vmalloc mappings").
>>
>> Do you think the mark_new_valid_map() function needs extra
>> synchronization like smp_wmb()?
> 
> Right, I wonder about atomic access, but also about memory barriers.
> 

BTW, does riscv support a better mechanism to avoid such spurious faults?

E.g., on arm64 we have emit_pte_barriers() where we issue some barriers:

"The isb ensures that any previous speculative "invalid translation" marker that
is in the CPU's pipeline gets cleared, so that any access to that address after
setting the pte to valid won't cause a spurious fault."

I assume the riscv case is different, as it's about actual TLB entries, and not
just translation markers in the pipeline?

-- 
Cheers,

David

