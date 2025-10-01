Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 611C0CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 12:42:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84EB48E0003; Wed,  1 Oct 2025 08:42:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8265D8E0002; Wed,  1 Oct 2025 08:42:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73BF58E0003; Wed,  1 Oct 2025 08:42:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5E41A8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 08:42:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E48ADBC815
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 12:42:08 +0000 (UTC)
X-FDA: 83949507936.02.AC22E0C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1E159A0008
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 12:42:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759322527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I1wrTOQk3HC+Fo1aBvEzngNPe9+LVpiTcP6T08Zz9dc=;
	b=HkLx/1evv/9OgD9TT7RC85vY2zOIAkdcZTLFgLHOmbH1XbuLkFtK/wNdypHThUxpqVzjKL
	4NE2H0002kP8BsUIv0bS7Txe88lToNOOa+9ONo5Mfu0u+kZ1REt7TbK4Uwqnm36wmeXSQN
	y6nuSAaqLceJ+Cerm0TrY2NKTf0+tFE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759322527; a=rsa-sha256;
	cv=none;
	b=8fNOwq1z3zU0YE6CaJ+wUBA7iNNWNpnuFfQqLmBzDhfIl7lTWG6TFiUyyfFvkh0Y9heBil
	4jmhcQOA9S0StsEp+VeA4KogPYngBCt5MAwjHgqMFRyicVSIDEGwkjPCh6BFK28zkToWWo
	gg4xXhIxJZt0S6SZT2ws9Ry80qeOTgM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A8CF16F2;
	Wed,  1 Oct 2025 05:41:58 -0700 (PDT)
Received: from [10.57.66.40] (unknown [10.57.66.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E1733F66E;
	Wed,  1 Oct 2025 05:42:00 -0700 (PDT)
Message-ID: <6dc0b5c8-b485-4fe1-b85b-7dcd00214d1b@arm.com>
Date: Wed, 1 Oct 2025 14:41:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 00/18] pkeys-based page table hardening
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "yang@os.amperecomputing.com" <yang@os.amperecomputing.com>,
 "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Cc: "maz@kernel.org" <maz@kernel.org>, "luto@kernel.org" <luto@kernel.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "mbland@motorola.com" <mbland@motorola.com>,
 "david@redhat.com" <david@redhat.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "rppt@kernel.org" <rppt@kernel.org>, "joey.gouly@arm.com"
 <joey.gouly@arm.com>, "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
 "pierre.langlois@arm.com" <pierre.langlois@arm.com>,
 "jeffxu@chromium.org" <jeffxu@chromium.org>,
 "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "kees@kernel.org" <kees@kernel.org>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "jannh@google.com" <jannh@google.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "will@kernel.org" <will@kernel.org>,
 "qperret@google.com" <qperret@google.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "broonie@kernel.org" <broonie@kernel.org>, "x86@kernel.org" <x86@kernel.org>
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
 <98c9689f-157b-4fbb-b1b4-15e5a68e2d32@os.amperecomputing.com>
 <8e4e5648-9b70-4257-92c5-14c60928e240@arm.com>
 <8f7b3f4e-bf56-4030-952f-962291e53ccc@arm.com>
 <6e5d24de6a6661f83442741f6be8daf691a05a20.camel@intel.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <6e5d24de6a6661f83442741f6be8daf691a05a20.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z6o36dqd3eip76guyfc1pr84959dm66n
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E159A0008
X-Rspamd-Server: rspam10
X-HE-Tag: 1759322526-240049
X-HE-Meta: U2FsdGVkX19dlDhPiHfbJF1iQbpDJQWVRBa0Qpr3DMlo/f9PaJdFahbyT39XEsB0HVmxQ+oLxaWYOpFtJkaEtcueXTcQztG9NbiYIWOwuyB+HC3jpSV9FX9+HthF7B3/2B/mjxJS9wdvhUKa+3vmKAjO8R6lnhwzCv+CGTNt03LsxjEEuz4o3U7pM7NGpUMFn9CTEFLGvusuEYR8JdgIa4bhxDAESliTcobbSP6hBQr+Ac7ck4aJ4QZ6XNWqKAoclzWu/Jfe6k1Qpn4f/CB1dF+oKznzt/xAeK5zj8U6bj+UeKpIF0aZyOsZw5QAq4BGoI8OBh3VyrvuGnhswhyvQFzx7oYBMMQHkEq0q/ktGMOw+3jjHw+gpk8BSjYr29O+NIcY+3Qm4EyyRXE6oLu6AyhqOepnJrtP9n5ecR5iMr7kNw2xi/hgB1RG2HD2LB1jp9g+9QNMB0bvLjWjromRKLx0bgMGTQLJPADVH7Wz4uQ33uj3857SXngXanYQDk1hn37sYh51Fm+1u27qkXVPew+6QLjVV58+jymBy7CsbuNR+H5nc1OLzeYrwi8OjbASNT0L2rIPzAsyQcthBe0fwtNczKZWxLrhHFD/oHANQJT1FxSkGL1DxG5Gj6yyqp4tPnz0+hiyQq942WqTu88DCCjqYwv4an7yoCNC1eobeDx/xkNbnw/bNYzkP14SYnSAg8u/viN/C4B7WgV424/yAYdr/MA3hwsrXTj4R6LWRGxGF/CATkPl/vC1c2fUentXQnHx7IR64Lh36g4jC1v/w/WGaU76/+kPsaOlpUba3sfSnC9mbfUEziefNLr5HI/hZ4zrzKtXCIqXhjTSAfu9FkPD83TLRtE65/b4KVEQm456x8aiSlah0atcmmr5djBFyI7mATvPSGAUC4lfFMnVCCr1G/G0nfV7vcEh1JvRCYlrA+Gx3+Kg/sXsVVtIO0Y9cqL0rMYi1ggKEPi5ODr
 Zto/hMyx
 dP/oVLWlQmYsa8MwkYpnFBIizm+4t4dfmsDUF7yypYZvFMHy0aJG0isOnuX3Ubv6gVwe7cyjAIHplnwuy4kBU2im3rbuGZ3rHyLw7fCL4J0An/pwK3d8kMODwheMoRGeQMTAYP7exUht9FLNU3q+DgACvMKkvw4o86ItbYVQw4ioWKyG8vAEHN67mx5LGBvxqhiqyBs57rqrWk6LK6BQsTLlYRwgvYKlM/z9xZuvqnTWOAmkVEZWqZ9u0Px6dqXhA9N9qywJK62QxFus=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/09/2025 19:31, Edgecombe, Rick P wrote:
> On Thu, 2025-09-18 at 16:15 +0200, Kevin Brodsky wrote:
>> This is where I have to apologise to Rick for not having studied his
>> series more thoroughly, as patch 17 [2] covers this issue very well in
>> the commit message.
>>
>> It seems fair to say there is no ideal or simple solution, though.
>> Rick's patch reserves enough (PTE-mapped) memory for fully splitting the
>> linear map, which is relatively simple but not very pleasant. Chatting
>> with Ryan Roberts, we figured another approach, improving on solution 1
>> mentioned in [2]. It would rely on allocating all PTPs from a special
>> pool (without using set_memory_pkey() in pagetable_*_ctor), along those
>> lines:
> Oh I didn't realize ARM split the direct map now at runtime. IIRC it used to
> just map at 4k if there were any permissions configured.

Until recently the linear map was always PTE-mapped on arm64 if
rodata=full (default) or in other situations (e.g. DEBUG_PAGEALLOC), so
that it never needed to be split at runtime. Since [1b] landed though,
there is support for setting permissions at the block level and
splitting, meaning that the linear map can be block-mapped in most cases
(see force_pte_mapping() in patch 3 for details). This is only enabled
on systems with the BBML2_NOABORT feature though.

[1b]
https://lore.kernel.org/all/20250917190323.3828347-1-yang@os.amperecomputing.com/

>> 1. 2 pages are reserved at all times (with the appropriate pkey)
>> 2. Try to allocate a 2M block. If needed, use a reserved page as PMD to
>> split a PUD. If successful, set its pkey - the entire block can now be
>> used for PTPs. Replenish the reserve from the block if needed.
>> 3. If no block is available, make an order-2 allocation (4 pages). If
>> needed, use 1-2 reserved pages to split PUD/PMD. Set the pkey of the 4
>> pages, take 1-2 pages to replenish the reserve if needed.
> Oh, good idea!
>
>> This ensures that we never run out of PTPs for splitting. We may get
>> into an OOM situation more easily due to the order-2 requirement, but
>> the risk remains low compared to requiring a 2M block. A bigger concern
>> is concurrency - do we need a per-CPU cache? Reserving a 2M block per
>> CPU could be very much overkill.
>>
>> No matter which solution is used, this clearly increases the complexity
>> of kpkeys_hardened_pgtables. Mike Rapoport has posted a number of RFCs
>> [3][4] that aim at addressing this problem more generally, but no
>> consensus seems to have emerged and I'm not sure they would completely
>> solve this specific problem either.
>>
>> For now, my plan is to stick to solution 3 from [2], i.e. force the
>> linear map to be PTE-mapped. This is easily done on arm64 as it is the
>> default, and is required for rodata=full, unless [1] is applied and the
>> system supports BBML2_NOABORT. See [1] for the potential performance
>> improvements we'd be missing out on (~5% ballpark).
>>
> I continue to be surprised that allocation time pkey conversion is not a
> performance disaster, even with the directmap pre-split.
>
>> I'm not quite sure
>> what the picture looks like on x86 - it may well be more significant as
>> Rick suggested.
> I think having more efficient direct map permissions is a solvable problem, but
> each usage is just a little too small to justify the infrastructure for a good
> solution. And each simple solution is a little too much overhead to justify the
> usage. So there is a long tail of blocked usages:
>  - pkeys usages (page tables and secret protection)
>  - kernel shadow stacks
>  - More efficient executable code allocations (BPF, kprobe trampolines, etc)
>
> Although the BPF folks started doing their own thing for this. But I don't think
> there are any fundamentally unsolvable problems for a generic solution. It's a
> question of a leading killer usage to justify the infrastructure. Maybe it will
> be kernel shadow stack.
It seems to be exactly the situation yes. Given Will's feedback, I'll
try to implement such a dedicated allocator one more time (based on the
scheme I suggested above) and see how it goes. Hopefully that will
create more momentum for a generic infrastructure :) - Kevin

