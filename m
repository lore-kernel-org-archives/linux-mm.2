Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89CE2D10F33
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 12:35:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2AB86B0010; Wed, 26 Nov 2025 07:35:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C02166B0012; Wed, 26 Nov 2025 07:35:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF0D86B0023; Wed, 26 Nov 2025 07:35:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 973E76B0010
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 07:35:27 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4EFCC160535
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 12:35:27 +0000 (UTC)
X-FDA: 84152703894.20.49A25B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 897FBC000A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 12:35:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ueGpeTww;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764160525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0+k5Uvo+0Fz/UjD6mpCNRfoSzvuUllnUyaEGWAa9EzU=;
	b=uj7R3zBxOQV9cetZatcO5pL/xAF+/zCbyWBKGZR5YQzYzHL0pnnVoztsqJVSR8asmeWa0C
	kOow360kmTo6F/ypbPRgWaPeG0o4TR0pKirP6VfolOIlvd+ZWtTmOz/0uA/BoIZ0JRAhIe
	nx3DV5HNchMN5I5XLxyi8GpVQHncKXI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764160525; a=rsa-sha256;
	cv=none;
	b=hMbUQ8ulrXRwRtjEJ4yAoIdhyrpivZE39/lUjbgZqhPgPFor3tljp3zEAA57mHH8s402AS
	iPZFNq/U79p0It79qdh9MfSEopT6hFvIlD+8lqUZU4gXaHbROmI8u2eOy6AK1228wruyhr
	tOpiD/D6W7w9gFpH/YLw10B4fnSeN5M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ueGpeTww;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FE11439DF;
	Wed, 26 Nov 2025 12:35:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C6FC113D0;
	Wed, 26 Nov 2025 12:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764160524;
	bh=rXwhATyOSB0m9x5O2nBFhUNTR3ETov+bBvaSAYz2hFU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ueGpeTww704+deIDOHRU6afye/CjFOPnI68YfLCYGwa2NIBPqhUBIG9JbhbzRNOlQ
	 MDosOn8WFxDBLdQjMUPJzxabKUIYqrxykB8/Ijg5DJ97xWCgkyH+V3/uZfH2HEiV48
	 2K+AvWiwMmOZWZgAuUZU1DF7SHQ6rB99llGyPyoUHqmCcwWWeXDZuerABOAfmckBoB
	 Fz49pQs3cVvv03oyAhYOK/uOX3N7UpWpjPxK1Rru+yGugebJwEwZR5a0azN71kSdh8
	 Ygm00azLCFgyKYsfXl3GthpfDfeTd+HRtirSPED6tqpjyHwnLb5PXOKwpEB/boWyFp
	 eWdeSrdF4KsLw==
Message-ID: <71123d7a-641b-41df-b959-88e6c2a3a441@kernel.org>
Date: Wed, 26 Nov 2025 13:35:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/22] mm: Always use page table accessor functions
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
 Samuel Holland <samuel.holland@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org, devicetree@vger.kernel.org,
 Suren Baghdasaryan <surenb@google.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Conor Dooley <conor@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Alexandre Ghiti <alex@ghiti.fr>, Emil Renner Berthing <kernel@esmil.dk>,
 Rob Herring <robh+dt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Julia Lawall <Julia.Lawall@inria.fr>, Nicolas Palix <nicolas.palix@imag.fr>,
 Anshuman Khandual <anshuman.khandual@arm.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
 <20251113014656.2605447-7-samuel.holland@sifive.com>
 <02e3b3bd-ae6a-4db4-b4a1-8cbc1bc0a1c8@arm.com>
 <bc88d132-452a-42a1-9ee5-5407334d8aac@kernel.org>
 <df7d10ba-bb42-4ea1-8c5b-5db88a18eccb@kernel.org>
 <6bdf2b89-7768-4b90-b5e7-ff174196ea7b@lucifer.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <6bdf2b89-7768-4b90-b5e7-ff174196ea7b@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 897FBC000A
X-Stat-Signature: igso53c6ty8u95kooryp3of87r57syab
X-Rspam-User: 
X-HE-Tag: 1764160525-678770
X-HE-Meta: U2FsdGVkX1/o1pzPymSX0OkPX/6m7p3kXQfuOJtCW3UNz77/elMnF/7aPi4+oWoKUHQBSn+jW6QU47DBwR5073PrptklTKabb5TDZnWpUI9nJJzJOtNTLheDWgmixGv8ZxWDPu3IMqkjjo5AAR2ErB4Gg114pyUAWZe+6SBWhtSsYkHlUgVxzu0NMsQlPy9SuVKdiVtqHAicjYR5GdG73w8kYYcVEqf045FaDoYwghpyheIcl+PeNNBkOf43PryJhbdiMzAq1B0DM53H49ukVtv0ARXwfJ70oZjCv+FbcCu3/kdLurqHvlAnWpv4esGIej+UvoJdVhYecJe5fFRX5LZRqNSEjurwQgW0eiYTedXl2pZLUf7uPPIedzxSJdy6dFgs5z8OaBCjhqoyH7hhQfwmhC/q3e1vEgaUnV+Ih8tAZz3NRE2YF8zbMW2cx1urMszoh9MElIztejx718IAipfdO0xIG15GJJ62uwnH0fRpqpttqqOdNXUw00qeRGbSDOsW+7f/kt1nw1qAMOoSrisFz/yfGmijGCzPyWgzlz5I9v+x464XHoEqGQla0ircauxGD84yTeuH0fP9zxxJpTs/CDrC/aqzcOkChYzKreXuULAfljo2bqyLbjqvMzPJzGYH6d5p1ojodYbxhi5pmBXViqpNTQ2zaQrLLVeigYb+L5j4d4YhT6+Z8fSkTPr+gx1Gy3f2obg/REsF3qh/AXYZ7hUiSolHs0/zQ4JI5SuBQetjM0QVVzrFVzBJppAG/sjJ9Fj2GR+W0LxZSFNz7CCaXI47F/61qEUxUl+E89srCgETew2dbKEg0k0DXKGCN6+p5BXe82OhfeICaIC3JI2mUQdcemdaaVdZ4dpnazv0fulFYcTaDY4qNP3aJAcT0/nUpBgYLyie8GxZ5tE3sDsXPn0NMOT9mm8CJKqenJy6st19Mh6N9l7T23leHsWdmJFBVIWCAzoWJxdTKP9
 aoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/26/25 13:27, Lorenzo Stoakes wrote:
> On Wed, Nov 26, 2025 at 01:19:00PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 11/26/25 13:16, David Hildenbrand (Red Hat) wrote:
>>> On 11/26/25 12:09, Ryan Roberts wrote:
>>>> On 13/11/2025 01:45, Samuel Holland wrote:
>>>>> Some platforms need to fix up the values when reading or writing page
>>>>> tables. Because of this, the accessors must always be used; it is not
>>>>> valid to simply dereference a pXX_t pointer.
>>>>>
>>>>> Fix all of the instances of this pattern in generic code, mostly by
>>>>> applying the below coccinelle semantic patch, repeated for each page
>>>>> table level. Some additional fixes were applied manually, mostly to
>>>>> macros where type information is unavailable.
>>>>>
>>>>> In a few places, a `pte_t *` or `pmd_t *` is actually a pointer to a PTE
>>>>> or PMDE value stored on the stack, not a pointer to a page table. In
>>>>> those cases, it is not appropriate to use the accessors, because the
>>>>> value is not globally visible, and any transformation from pXXp_get()
>>>>> has already been applied. Those places are marked by naming the pointer
>>>>> `ptentp` or `pmdvalp`, as opposed to `ptep` or `pmdp`.
>>>>>
>>>>> @@
>>>>> pte_t *P;
>>>>> expression E;
>>>>> expression I;
>>>>> @@
>>>>> - P[I] = E
>>>>> + set_pte(P + I, E)
>>>>>
>>>>> @@
>>>>> pte_t *P;
>>>>> expression E;
>>>>> @@
>>>>> (
>>>>> - WRITE_ONCE(*P, E)
>>>>> + set_pte(P, E)
>>>>> |
>>>>> - *P = E
>>>>> + set_pte(P, E)
>>>>> )
>>>>
>>>> There should absolutely never be any instances of core code directly setting an
>>>> entry at any level. This *must* always go via the arch code helpers. Did you
>>>> find any instances of this? If so, I would consider these bugs and suggest
>>>> sending as a separate bugfix patch. Bad things could happen on arm64 because we
>>>> may need to break a contiguous mapping, which would not happen if the value is
>>>> set directly.
>>>>
>>>>>
>>>>> @@
>>>>> pte_t *P;
>>>>> expression I;
>>>>> @@
>>>>> (
>>>>>      &P[I]
>>>>> |
>>>>> - READ_ONCE(P[I])
>>>>> + ptep_get(P + I)
>>>>> |
>>>>> - P[I]
>>>>> + ptep_get(P + I)
>>>>> )
>>>>>
>>>>> @@
>>>>> pte_t *P;
>>>>> @@
>>>>> (
>>>>> - READ_ONCE(*P)
>>>>> + ptep_get(P)
>>>>> |
>>>>> - *P
>>>>> + ptep_get(P)
>>>>> )
>>>>
>>>> For reading the *PTE*, conversion over to ptep_get() should have already been
>>>> done (I did this a few years back when implementing support for arm64 contiguous
>>>> mappings). If you find any cases where direct dereference or READ_ONCE() is
>>>> being done in generic code for PTE, then that's a bug and should also be sent as
>>>> a separate patch.
>>>>
>>>> FYI, my experience was that Coccinelle didn't find everything when I was
>>>> converting to ptep_get() - although it could have been that my Cochinelle skills
>>>> were not up to scratch! I ended up using an additional method where I did a
>>>> find/replace to convert "pte_t *" to "ptep_handle_t" and declared pte_handle_t
>>>> as a void* which causes a compiler error on dereference. Then in a few key
>>>> places I did a manual case from pte_handle_t to (pte_t *) and compiled allyesconfig.
>>>>
>>>> I'm assuming the above Cocchinelle template was also used for pmd_t, pud_t,
>>>> p4d_t and pgd_t?
>>>>
>>>>>
>>>>> Additionally, the following semantic patch was used to convert PMD and
>>>>> PUD references inside struct vm_fault:
>>>>>
>>>>> @@
>>>>> struct vm_fault vmf;
>>>>> @@
>>>>> (
>>>>> - *vmf.pmd
>>>>> + pmdp_get(vmf.pmd)
>>>>> |
>>>>> - *vmf.pud
>>>>> + pudp_get(vmf.pud)
>>>>> )
>>>>>
>>>>> @@
>>>>> struct vm_fault *vmf;
>>>>> @@
>>>>> (
>>>>> - *vmf->pmd
>>>>> + pmdp_get(vmf->pmd)
>>>>> |
>>>>> - *vmf->pud
>>>>> + pudp_get(vmf->pud)
>>>>> )
>>>>>
>>>>>
>>>>> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
>>>>> ---
>>>>> This commit covers some of the same changes as an existing series from
>>>>> Anshuman Khandual[1]. Unlike that series, this commit is a purely
>>>>> mechanical conversion to demonstrate the RISC-V changes, so it does not
>>>>> insert local variables to avoid redundant calls to the accessors. A
>>>>> manual conversion like in that series could improve performance.
>>>>>
>>>>> [1]: https://lore.kernel.org/linux-mm/20240917073117.1531207-1-anshuman.khandual@arm.com/
>>>>
>>>> Hi,
>>>>
>>>> I've just come across this patch and wanted to mention that we could also
>>>> benefit from this improved absraction for some features we are looking at for
>>>> arm64. As you mention, Anshuman had a go but hit some roadblocks.
>>>>
>>>> The main issue is that the compiler was unable to optimize away the READ_ONCE()s
>>>> for the case where certain levels of the pgtable are folded. But it can optimize
>>>> the plain C dereferences. There were complaints the the generated code for arm
>>>> (32) and powerpc was significantly impacted due to having many more (redundant)
>>>> loads.
>>>>
>>>
>>> We do have mm_pmd_folded()/p4d_folded() etc, could that help to sort
>>> this out internally?
>>>
>>
>> Just stumbled over the reply from Christope:
>>
>> https://lkml.kernel.org/r/0019d675-ce3d-4a5c-89ed-f126c45145c9@kernel.org
>>
>> And wonder if we could handle that somehow directly in the pgdp_get() etc.
> 
> I find that kind of gross to be honest. Isn't the whole point of folding that we
> don't have to think about it...

If we could adjust generic pgdp_get() and friends to not do a 
READ_ONCE() once folded we might not have to think about that in the 
callers.

Just an idea, though, not sure if that would fly the way I envision it.

-- 
Cheers

David

