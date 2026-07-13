Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A9F0C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1942F6B015E; Mon, 13 Jul 2026 12:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1454D6B015F; Mon, 13 Jul 2026 12:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05BD36B0160; Mon, 13 Jul 2026 12:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAAF66B015E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:53:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B5668BA32
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:53:47 +0000 (UTC)
X-FDA: 84984350094.25.1358707
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8A4F4C0009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:53:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QwlCxO0T;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783961625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RUky49EZFMYWVAE4S2Lncj1iWmkgCf5kuOOfACz5DKk=;
	b=DuCm9wUe8saKDHUuEDRVzXFxf+VOVpKZKIVvimAxBH9FEi4xoQ/Xbn4LpgGs2208EkFBSM
	9SMXh8N+VKG5zJ4/wiMFvORvJHKI5KeARB9sui7mmbWnQtc/Ac6L+zlDCeUHdYWToiN8jN
	pLRoxW3FfstNgZ6B86ABz3egl+63vZ0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QwlCxO0T;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783961625;
	b=ugvYi/IOmgSSGLkqBzp69ArC+MAxGsQrch7XDdNOda9L0J2zXRbsElB3aEwH9Dl8ibnfK3
	Mzv2g/JYgvwAfGbhg/YZK+egnjPm0TKbm8+UKTu7MDsVG3YQXqUZQubzOTpRMVsG5EYqw9
	0Savd9crX2VP5F8KmdBxzRMvS0Azu5w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A222341807;
	Mon, 13 Jul 2026 16:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4381E1F000E9;
	Mon, 13 Jul 2026 16:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783961624;
	bh=RUky49EZFMYWVAE4S2Lncj1iWmkgCf5kuOOfACz5DKk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QwlCxO0TNXvbai08wj9mItkuAJ900VTA+rygyaR2RP6rN7HGawq1A+/fZ0K6vrd+2
	 XxACCZ/t4zcCLMBvSvculez3o+YELTcxId09BMSupkMYtaXlqPcFtEHUWez6wkdzFk
	 6MlrriLDnfTq9fwG7S7GUp+XVXoKnWQFyHY3kPsgaoT+cu3gSlew72sFcT6tUMuCDb
	 8tTXEzPpgbviFGztKnUXF1wirPFHi7NSlimIj+5RzpkjhfyuLLRUVg3nGB3a3ksxIh
	 Qr1KGPdiibbcSQ7AiL/ugLL8D5Zrb/maM0DZ2sl2x2m0dhZhmT28Tuv/CvbYlHGfOP
	 5u8+fQRnQ0S4w==
Message-ID: <d6b1bd1b-3800-4bf2-bd0d-f0e6201810f3@kernel.org>
Date: Mon, 13 Jul 2026 18:53:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] slab: don't assume alignment on allocators that may
 return ZERO_SIZE_PTR
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>, Karl Mehltretter <kmehltretter@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>
References: <20260712120728.96628-1-kmehltretter@gmail.com>
 <f2def8bd-4eb8-4e5f-a22f-4061297ddb03@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <f2def8bd-4eb8-4e5f-a22f-4061297ddb03@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8A4F4C0009
X-Stat-Signature: 5dyga313hdbiah8zkyjzqa8ewtn8t7gi
X-HE-Tag: 1783961625-581800
X-HE-Meta: U2FsdGVkX1/39u3PaGayCouAh/cNUvgUlM9KeQ3ZExI34O1i3xnrXOetF6Pjm3ka5xq2nogWPxvGtnsognz3C4oYt8cM8ckZceTC22psM6Kc/ZdSiGwivByJgPzptB/S4FCM+V61G4uQJ+uVruVHi3ShFCD1jWkq86G9wmv8zkAAUhfpAzVUUMw7HX8LG8EGlvW0kgM5i33KT7GVol1ZtcWPOuAuqBLliKrhGn6fh/MseGGizqameEzYFLVsrokCtTSNl361EboOUvqWuFvQDAzFIZo8kCGf7bGxuGNsGTg+gI75yHy8zcoX/BcWZkJohaWTpkP7dckZNA7HHwE19JGO+ADR67oRLwmllJ8yd1cNDMzFS4Gqd+Y+fMgIdaOnfunWWy5qmod/LubAQAM5J7kfxHZOrefQaBZ6yS+AhM62B0PgnNE8ocHRYGw4cFDdZx1woeh+Ip4HctUKvDAmajysoqF95q8V9Oywotf7sBJW5HzfCLxvZJObsTVKtDrgFaMPy+iNbFmaD2e5YC7JtvkfOx9D0D0ZECT0oj4VgDK2rVXtF+R9X84aPqGFqzoirFspfnP2TY8/XW6PbBXiOpF5X3uWHJ5hrPsWYZhO/yLMBZLqQIywqm5D/x8niMQ2USTyuDURetLUulmGcr107OOGMuVNaUBZMpt8VArTY5V8K+VQFZEYuEZvrNjkOVtfzDlLc/PmgkGuACqXLvB92C6hjuP+UVpZO9Ol8ApXsRar1EAc2E3MVTj7/9suXTyR3Vq/yynxGNxs7wFrXD09sf1h54qEVVDwAKU6IYr+5QlPUHtIHr7eURvGz+9GcJAMqEl+MJPeg3E29Y7hUllsXHRDK32XL2tg4IOKKfHVzPpA1XG36ifu0yuW4SK3Vdp0CeIeoXWwM1Duvako30RujMETYLV4oQ9UjZ2MtAFXcNgwO3UwrfLmXkoU30FPtOrVDZkCzt1sRMIzkxileKD
 mBy+flUs
 4SwzcMVsCRfYs8oOb2sdGAxgwC+rdNl9JTF8sHkPbpLmQljZI6RVYWKkbUZ9td7fYR4Jw9/cv8LzI2J1rGwrykBYfNPS0xQc+7893FR2RlIMSFxpAGsLH61j/CeajdEa4QmvSrLKWwPX3LXrjQE/kRZp9MzOJALWG00sUpOa3GaJTHUJf25by87a/UN9iP0gqyJVO9SzdHowfGJo2mwbVnxKA+jntfQ6G+d7wg5sNU6SQaY5+B0q7aHYVqz/eE1dmgfOsEdkJO7EuM39Wf4s94lX/TK5p/h4WPH0eMUNi9OdsfC64t6ncm2sSTc+1daxU1dCKGovBskwYxc/ZUbpa5w/V5+hH6rIY2EDg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 07:18, Harry Yoo wrote:
> 
> [+Cc Catalin for ARCH_KMALLOC_MINALIGN bits]
> 
> On 7/12/26 9:07 PM, Karl Mehltretter wrote:
>> __kmalloc_noprof(), __kmalloc_node_noprof(), and __kmalloc_flags_noprof()
>> are annotated with __assume_kmalloc_alignment, which expands to
>> __assume_aligned(ARCH_KMALLOC_MINALIGN). All three can return
>> ZERO_SIZE_PTR, currently (void *)16, for zero-sized requests. When
>> ARCH_KMALLOC_MINALIGN exceeds 16, this contradicts the annotation.
> 
> Ouch.
> 
>> Compilers may use this false assumption to reduce ZERO_OR_NULL_PTR() to a
>> NULL check, losing recognition of ZERO_SIZE_PTR. Current GCC and Clang
>> retain the existing range check through kmalloc's inline wrapper, so no
>> functional miscompile was reproduced with the current source form. However,
>> both eliminate an exact ZERO_SIZE_PTR comparison on the same return value.
>> With Clang, UBSAN also reports the invalid alignment assumption at boot.
>> 
>> Changing ZERO_SIZE_PTR to satisfy the annotation would make its value and
>> the range accepted by ZERO_OR_NULL_PTR() architecture-dependent. Avoid that
>> semantic change by dropping the annotation from the general kmalloc entry
>> points. Retain it on the cache helpers, which cannot return the sentinel.
>> Allocation behavior is unchanged.
>> 
>> Kernels before v7.2 do not have __kmalloc_flags_noprof().
>> Backports to those kernels only need the include/linux/slab.h change.
>> 
>> Fixes: 94a58c360a45 ("slab.h: sprinkle __assume_aligned attributes")
>> Fixes: f6d50ab29afd ("mm/slab: introduce kmalloc_flags()")
>> Cc: <stable@vger.kernel.org> # needs adjustment before v7.2
>> Assisted-by: Claude:claude-opus-4-8
>> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
>> ---
>> 
>> Notes:
>>     This is RFC because the alignment contract can be corrected in three ways:
> 
> I think it's still worth having at least a weaker alignment guarantee
> and would like to vote for option 3 (or option 2, if 3 turns out to be
> infeasible) unless there's something unexpected that prevents us from
> doing that.

Agreed.

>>       1. Remove the annotation from entry points that can return ZERO_SIZE_PTR
>>          (this patch). On armv5 this increases .text by 1120 bytes (0.02%);
>>          no measurable change was seen on arm64.
>>     
>>       2. Cap the assumed alignment at 16. This preserves some alignment
>>          information but couples the annotation to the current sentinel value.
>>
>>       3. Change ZERO_SIZE_PTR to satisfy ARCH_KMALLOC_MINALIGN. This makes the
>>          long-standing sentinel architecture-dependent and either expands the
>>          range accepted by ZERO_OR_NULL_PTR() or requires changing that macro.
> 
> Some code (e.g., kmem_dump_obj()) performs (addr < PAGE_SIZE) check
> either NULL or ZERO_SIZE_PTR) to see if the address is valid.
> 
> Bumping ZERO_SIZE_PTR to something smaller than PAGE_SIZE should still
> work: (addr < PAGE_SIZE) check still works, and accessing it still
> causes a fault. No arch should have ARCH_KMALLOC_MINALIGN >= PAGE_SIZE?

Yeah, I don't see why anything should mind if the value changes to a larger
one, if it's still well below PAGE_SIZE.

