Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39333CD4F52
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 08:00:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B7E76B008C; Tue, 19 May 2026 04:00:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 468286B0092; Tue, 19 May 2026 04:00:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357F96B0093; Tue, 19 May 2026 04:00:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25B006B008C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 04:00:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BBE8A1C00F6
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:00:51 +0000 (UTC)
X-FDA: 84783423102.02.6D5B722
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0DFF7140003
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:00:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I7vznwgL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779177650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RtwfT6r39WqU1vxAeKYG9k5uq6DHBy2YCymS3YntXaw=;
	b=8Y8UI/JP7yXnipel/1uTIb/Qoun32KDb0jf7AkLFRzjgnpkUqfV+4F3nC9AROpSoA+zQkN
	qhbE19T8xlW+KuHAC/cYhyr9RcIsew2ERTf+9LeGb7FtJia2BXupES7pvsEG0vGUOm3dq6
	lreCjsbF09Us4Rgqp3AxXuw56E5VGP0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779177650; a=rsa-sha256;
	cv=none;
	b=CWZOpjsv97vNBPUMsnnvJK0ad64oQSEzKjR9Lg2xHf5+2x+BRkvTYJGA8xn5SvDCqx/piN
	FUPSvCSK+gFE2hNulZcE/FGGUOeMLw2Mt8h+1gaEbDbhI2iyx+JQgj4jZESseuw7xP1nyA
	5Cc1MhxhQcWzRC1UB0vHdj18YgPTSQY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I7vznwgL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 781A360208;
	Tue, 19 May 2026 08:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FD0C2BCB3;
	Tue, 19 May 2026 08:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779177649;
	bh=jq+Ic2o6+/T6R+6rKPEYUVCfMRGyHOvp7RzEZ9FUseg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=I7vznwgLR82bFg5okwmiS44hagsTw2fpDtHv0dip23rZYyVv4Z5pV0JENKZenbEPY
	 caLAFtNgxAyhxPdG12x510QK9CG3TrZLhkbICxRov/OQDkC0s4u377E1oMvrrXwpD0
	 3EKxDFcB9Ep5YgHVziesBC27Eb10HYleQgaos3KsBrEEXh4kLkX4il/gSUs5ieJWF2
	 xTbsEghuYQZwcY1VgRfOFjtAQnl34fSLoNXrbJE8TSkf8FQx2ojuS/rT2+Y61bn+G/
	 X5e2Fd3WrZEKYAfmyYW26ySv7pM3wQ/gnB8Wl460a8i+L59que2/pHmk3jQl+hA1Vi
	 v08NGy3tgOARA==
Message-ID: <2f02d90d-cdc9-48ef-abe3-99e00f22595f@kernel.org>
Date: Tue, 19 May 2026 10:00:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] mm: Add ptep_try_install() for lockless empty-slot
 installs
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <agtuPrgIDNKSu2Oo@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0DFF7140003
X-Stat-Signature: ankxqrwt6bgh6zcku3fewe8h4kwhm449
X-Rspam-User: 
X-HE-Tag: 1779177649-276201
X-HE-Meta: U2FsdGVkX1+EUvWjHCos2XtHVMhNLMlAOqHPKuQkyTRbg7H3ktQNa3tnzc9bQ2ru5tIEc31eqKwMmf/yxcXChyXlvnS+oKLaeDbvmSPhLRYLG8PkKS3ENnpr8gVpEdrt8i9y0Juu4kf0vHGcUqj5E3fYAT9s4OEdvw3iELqUn9IqL/DYB7UuwMTpXHnRFUf40N59gGR6jAMLpNaqTR072VJGoZtx6504fPiIIDrfrcGSkloLH35u8abqGNVfRm2dnyg9KOTvTogYJRmFARpki7hWkRIHW4OghcXW/pQiEjvQi/zchZTexIiRaWibPZ0nXdaCFu2PZikdSCdC02PNoEt2iLW7BPRmgtVT5Uly0n97LKxNvheU5o49+QHWkjuMoi6dAojqPb9lqzIaOMo1frSKfoZL1oM1wxuoUe0BKH/kR9JO6q4g9J593ZTr4uhwpF96tgsZFHSpRu+Rxjv/haRm56tVRhn0+TCLCxMRuAABqleF7nWwW784Zv1T2oLk0BM09zig85j/MvasKlBZ64w7oRBLuHxs4syPzT9SrdFCyH1OaLoUAF/wf5hye+Q9Gd2PwIPFfrA68jW5bZc/hO1uzvoTuZ74Mq9ugJb5N7njgFv2MC+CpAimyrq0/6XASe13IiKgkL2N/DO/PW3sf2Ibbg/00rAQlhOQo5SGNfL+tSMjiYbj0AYcyN1561AC4q6Mwp7v0lGE+J2BhH3ulb3bYF1X7iK9nvQo/X8phcoiZidZj+A5fudySEVTWfV29gc6QmLkf/S7+vbin/JZ2upGmwGlb9X89Cnl36y4atE7d/ROlHVxbLF6/vSzQ87+z3FLLWHuI62ra7s8TfM0vQOFasm82PM0KSPQwK3e4o7IF3qoNB4HVQ/218P17yDXI9VGjMmBWCJ9I1kKzEIECdSXf6m61puM2U698dOAHeiQSfHwfF60/GUP4yewQ//RAMRx9ye1DkHmiIxiMKI
 AXG61MqH
 6tlTeOex0b+PhQ/8Fg7dxxVB1IzxYRLdwLEoEctTmQszOXBmn1EKgtyBlfkBWQa4iVW+qfd3GgwzxZGdWH7cuJYr49M38CYYkK7s/GPBLZyoPoFHv0mBXE5CovHmY9GIEof5jlJJrYH4zQZpaNrw0FyjUKemPj5bJWnDZx0o1mREiQL2mPd/HT/sf/zuYPGOmpl0IElrVk/60iBhjwjPGSLoMowcykFPwi1fpXZ+7n6wptwYbr6igOKUxR1bihkVKZBLNZufpUQoWmBixLCIJznEp7k1sH6qzomOpg4SBkIn5z14yxJd/Cbvf+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/18/26 21:53, Tejun Heo wrote:
> Hello,
> 
> On Mon, May 18, 2026 at 10:06:29AM +0200, David Hildenbrand (Arm) wrote:
>> On 5/17/26 23:12, Tejun Heo wrote:
>>> +static inline bool ptep_try_install(pte_t *ptep, pte_t new_pte)
>>> +{
>>> +	return false;
>>> +}
>>> +#endif
>>
>> Ehm, what?
>>
>> This is a very, very, very bad generic idea/interface.
>>
>> On which ptes is this supposed to be used? User ptes or kernel ptes?
>>
>> Surely we don't want this on user ptes.
> 
> Yeah, this is only for the BPF arena PTEs which are already managed in their
> own way. I'd be happy to place / gate it however appropriate.


So, we only use it within apply_to_page_range() with init_mm, where we don't use
page table locks.

Usually we seem to grab the &arena->spinlock to protect the kernel page tables.

And you're saying that we might get called from a page fault handler where that
lock can already be held.

Is that really possible? I'd much rather prefer to trylock and retry, unless
that can really result in deadlocks. But I have the feeling that such deadlocks
should be impossible here.

Can you elaborate on the deadlock situation and how that can happen in valid
scenarios?


The thing is that ptep_try_install() relies on other page table walking and
insertion code to do the right thing. Shaky.

For example, staring at apply_range_set_cb(), what prevents:

(1) apply_range_set_cb() finding pte_none(ptep_get(pte)
(2) apply_range_set_scratch_cb() succeeding ptep_try_install()
(3) apply_range_set_cb() overwriting the pte with set_pte_at()

Between (2) and (3) CPUs could access the scratch PTE.

-- 
Cheers,

David

