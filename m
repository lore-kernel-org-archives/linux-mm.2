Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2FBBCA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 11:33:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB0B06B0088; Thu,  1 Oct 2026 07:33:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B61196B008A; Thu,  1 Oct 2026 07:33:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A767D6B008C; Thu,  1 Oct 2026 07:33:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 82AF16B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:33:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ECC09C03C1
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:33:14 +0000 (UTC)
X-FDA: 85273846308.11.9354283
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 324461C000B
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:33:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iD53Oifp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790854393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b2hY2Lwa9e4ug6tiGWzP7cLmTEKbjt1EVVbwD8WgJqc=;
	b=tU78WWvD2vWONlXmpwzGuIZDBhgxrJSRCvnB3Y9lnu96vkqlZFi5O8kadjktdAAe6EVcJl
	m9lOSK5c0U+x9vxjVKNfMFKYr9deZYlIzjfVT3065d1oUvRBITA8kKQPMh/1ww37oH/Xqp
	AtVIfXac1g1416/w2T/4yqTJtUpS+Dg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iD53Oifp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790854393;
	b=wLnR5s930a43HBwey4OSB/s165QPSeRUOHl+Uf+f1tw5thoLVOG/Y6NPgTPkkTmNTi+7fr
	wIjIQC3gGfvwYtKWjMsyAEmBf+gvxa21NxJJHQV2sATmJDbEFCuZ2KTTzbf93hJNnWUgus
	2iRamoryNQkH/hV7BP/3bh6jodQff8w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B306360A55;
	Thu,  1 Oct 2026 11:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3039A1F000FF;
	Thu,  1 Oct 2026 11:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790854392;
	bh=b2hY2Lwa9e4ug6tiGWzP7cLmTEKbjt1EVVbwD8WgJqc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iD53Oifp/0W8HMOSNW9RLwVbugDqNyDtJoq4TPv4O2H+BOf7+CcJKqPB1nG0G9tg4
	 Ou+C2O2JlfDb7vpzb7HfDkraQyJ++Upwa8X8TTgcD6F+Ze956QW97elz7kK4l/gbzY
	 SWdxBw6KMHjiH6PnnGJhkq1Sjz751s1sMCP4N/GD1rEBqE5j4tjvdsDniB+5d5JStZ
	 ygajxJTAvJFlo/QWoLABdpjnQ0OIGs1pIeksWHX1R8jWoMvp1fKOpKwMd24oe1/GeU
	 MfPXizuEjQRxBTnxQy6GWVhaO3YwSTyWDkV6mriRPMOVVa1Xc9P2kVv7Wefp7PZRR7
	 /qs2Z/i1dQ5zA==
Message-ID: <7454d7a3-57c6-4883-a66b-26129e633c6e@kernel.org>
Date: Thu, 1 Oct 2026 13:33:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] maccess: Use a scoped guard for page faults
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>,
 Ihor Solodrai <ihor.solodrai@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 "moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)"
 <linux-arm-kernel@lists.infradead.org>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:BPF [GENERAL] (Safe Dynamic Programs and Tools)"
 <bpf@vger.kernel.org>,
 "open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>,
 Viktor Malik <vmalik@redhat.com>
References: <20260824160523.3907021-1-usama.anjum@arm.com>
 <20260824160523.3907021-5-usama.anjum@arm.com>
 <79daa73b-0d34-4e84-8450-56f90bc700d4@kernel.org>
 <98e9ac67-7df3-4c0a-8814-37e196d94020@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <98e9ac67-7df3-4c0a-8814-37e196d94020@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 324461C000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: znqgwfic3wefdmq3d5yc1rzsq8d9t8pw
X-HE-Tag: 1790854393-9296
X-HE-Meta: U2FsdGVkX1/Dfu1HnA9EhYvccOBpR5iRlckVeqH0hELzHNeuLrRcjZ1/QYAF9+9mJV0ouMorCnPht4OvXLiUWsYR0RGZCMJDRv1THeD+rkAkDSZFC6su2DJv6Qtg5c5mogZshriMWtwWN9Tic1iEAJvz/++o9ttke16bJxynFE/TOh4AyHPjum8kXFh73KLsF9uQ04gNNvHwWroK3/A007dWkFtZZIKDtAeqqgdoxd1ycMTUC1iASYKnbGKCONbwOqszYc7larvVw/whjMKs3LodZ9LCdU9iWD0206Z3EKOceUfiqXmjJvRA64CjbejZGcYWr9+2BizS3w1LBvT1DiAL9wMvgqJjfA2t/6qiHG1ZE4J44Jfr/q/fPBULD/QEDJ6/jrNz4upjJ4HNpDEfNzPfZi3XnA9WyqhSJ7EV5BO6ceG3rbVFl4zSM5CWSJ5c3J+fkRlyMJbaNjT57Ht8Qip5nRuJJIhF0iozqn7kB1zR4tdiWm7AH8dOz8K+bdFmu2Kmm6q6NbSVPz93kHQ0gPoBnWWTbvj21UUYVVS9A6n+apScdskKyZUNh5E5tp2zglU2n8wyaoSovb/DjdvUYS8MjzmRDZsCKY0QntmxrdnMZB+F5JJ5agJmvtvdBTsgC7swhUWw0uniswzUKELYCYx58Sd4iZQUoxfN/jVjWue/HkKvY8rCIh3pIAHjonRaSGUiXOTQt1FGLII7XtAgPncVAEXxjkSITlDk0dENUCgyOoLOgSjqduiSbjjuoKnPQSi+Yy08b6UGEWQ6VPYr1zUwsr0eOAZsicLiYeG3WekkQBIesV30SEpn5MDPJfCaSvDJ4Ds7YAQ3dovy253lURpOWKCe++N8SVA7HgNma5IbGYS/PQJuoK0ASjlc23tCofjwaXWWdoKm2NrU3xAyrSSfNDu3LgzvAQijlfm7yQJwpAss4/sfdwr+TXWUlPCso1uVlFG/Tpt1kRV44im
 +G+vxOGT
 7S1pRjrBxGMangbi+Iwf0XZpTQNxsrgAApMAubFW5kH74w316koyMUavqNlA6aGMBCL6RKrPttI2/6JIVcLUMjA4SSjprF7Axnc+RGCCJEcXUuCim1o8gjhTSL1DDr3/G512wpnf21FBbucSpx5LCkIPbjzZNMXbpXgTVSlzLSeOMOe5Y2Sz6G0kd1B1zju0wtfocvUA4QUdygjLhnEBI6oleksgOPLOXVTYGhedTj+gAMu509upxSYE4ATVMuJ6QA8N4hXceqj9FRnhcw0XMVGweAA0JvbklZmOCGdgA3HMDkNxt1CGOyyWfW+XSuUO68t8S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/26 14:07, Muhammad Usama Anjum wrote:
> On 25/08/2026 11:36 am, David Hildenbrand (Arm) wrote:
>> On 8/24/26 18:04, Muhammad Usama Anjum wrote:
>>> Kernel nofault copy and string paths open-code page-fault disable and
>>> enable around label-based loops, duplicating cleanup on success and
>>> failure.
>>>
>>> Use a page-fault scope guard instead. Leaving the scope now re-enables
>>> page faults on both paths without separate cleanup at the fault label.
>>>
>>> No functional change.
>>>
>>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>> ---
>>>  mm/maccess.c | 53 +++++++++++++++++++++++++---------------------------
>>>  1 file changed, 25 insertions(+), 28 deletions(-)
>>>
>>> diff --git a/mm/maccess.c b/mm/maccess.c
>>> index c59a0e092d24a..f695ceefe6fcc 100644
>>> --- a/mm/maccess.c
>>> +++ b/mm/maccess.c
>>> @@ -38,18 +38,17 @@ long copy_from_kernel_nofault(void *dst, const void *src, size_t size)
>>>  	if (!size)
>>>  		return 0;
>>>  
>>> -	pagefault_disable();
>>> -	if (!(align & 7))
>>> -		copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
>>> -	if (!(align & 3))
>>> -		copy_from_kernel_nofault_loop(dst, src, size, u32, Efault);
>>> -	if (!(align & 1))
>>> -		copy_from_kernel_nofault_loop(dst, src, size, u16, Efault);
>>> -	copy_from_kernel_nofault_loop(dst, src, size, u8, Efault);
>>> -	pagefault_enable();
>>> +	scoped_guard(pagefault) {
>>> +		if (!(align & 7))
>>> +			copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
>>> +		if (!(align & 3))
>>> +			copy_from_kernel_nofault_loop(dst, src, size, u32, Efault);
>>> +		if (!(align & 1))
>>> +			copy_from_kernel_nofault_loop(dst, src, size, u16, Efault);
>>> +		copy_from_kernel_nofault_loop(dst, src, size, u8, Efault);
>>> +	}
>>
>> While I understand what pagefault_disable+pagefault_enable does, it is
>> completely unclear what scoped_guard(pagefault) does.
>>
>> Should this be scoped_guard(disabled_pagefaults) or sth like that?
>>
> 
> The `pagefault` guard is already defined in `include/linux/uaccess.h`:

Ah, sorry, I thought this was added in this series.

It's completely confusing.

	guard(pagefault)();

meaning "disable pagefault", what?! :)

CCin Viktor: I see that the patch that introduced that has no acks from MM. I
don't blame you, because the file is not actually listed under the MM section.

I think this really needs to be cleaned up to clarify that we *disable* pagefaults.

Usama, can you throw in a patch to clean that up? (calling it nofault,
disable_pagefaults or whatever)

-- 
Cheers,

David

