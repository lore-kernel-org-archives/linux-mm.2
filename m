Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AE0DD10F40
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 13:03:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA8496B0007; Wed, 26 Nov 2025 08:03:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7FB56B0012; Wed, 26 Nov 2025 08:03:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A95956B0022; Wed, 26 Nov 2025 08:03:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 95E8C6B0007
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 08:03:50 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 07985598F7
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:03:50 +0000 (UTC)
X-FDA: 84152775420.12.8F165CD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id EBA2E180026
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:03:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764162228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=slZU0MWBWHwn9Hj2M7wh8L8yac1q3hwMahFEQjO39IA=;
	b=DThldArV3ORFBHYJopwIMsjiEjdCDaVMa2usNmDRLEAbeTspTb2aYqc/84E5Io6MjWD53+
	bBNWayT3nFHahCu5ITMboWHjHPH6cdf3dpHbzl9AXrK5IVMUjPqpSDu1s+zRgKRSLHDtnx
	ZYugXLu4Fwp7Qk3tE1zrhrm76OiYNeI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764162228; a=rsa-sha256;
	cv=none;
	b=DRKvjTw4wzKQNjkYCeL0C0AyhWgaBiNMJxrNsJn0XG5ulTHXIgaWV3MVcL342fChBe008p
	+GqLXqpaxHG/GRcFWF2F6LA9l6ZcoC/SUAXovKmriMo2nWDVAAVvF/bucJ2x0p3O25DZl3
	hIYXfkhPN2B16dRkarnMns4rS610Paw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5553A168F;
	Wed, 26 Nov 2025 05:03:39 -0800 (PST)
Received: from [10.1.33.153] (unknown [10.1.33.153])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1FDE83F66E;
	Wed, 26 Nov 2025 05:03:44 -0800 (PST)
Message-ID: <c0818f5b-b8a1-4730-aa1d-df0f547a3d47@arm.com>
Date: Wed, 26 Nov 2025 13:03:42 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/22] mm: Always use page table accessor functions
Content-Language: en-GB
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Samuel Holland <samuel.holland@sifive.com>,
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
 <71123d7a-641b-41df-b959-88e6c2a3a441@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <71123d7a-641b-41df-b959-88e6c2a3a441@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ofny6qkbgg3zgw6m6zh478ezb6w8hecg
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EBA2E180026
X-HE-Tag: 1764162227-165
X-HE-Meta: U2FsdGVkX19oskPSctiblkvVb2W4pWxsC/85P7fR7XuMYUnTmYh5gZFz0I+GT1x1m6WTlprOHNBsYah4r4mP3R/MGbSd/0fbwy97O8KISs+C0OAZwzrAgqsqKPQQGUuOeRwCG4+cQMPmZ3zl57mN6vs8kN8KGNJIpPWZL1kAETvk9gSaci6xiFc4s0fBGYxnrmSlmG6I+bDBmdPHC2kPvLmYagV+CinF8RrR3vFIktYPfirknmZjUYbX560gKf3B6fOGOwHwHsYslN3PJay1rG/pObOCwQNlw8Uciaegwx/hdtE8dWdd/fd1Az4aO7hcnlVJGcidOhfVzNN4du0ua6gcerZFYOfX/tuKrX4WvjfO8RW9tdDNNlnqVDNnPuzGZ0G5UqA1YLD0U7dK8hv/ta7ciaW0lvn1myP1I2BounnYqFCqPhTeTp8dbvEY7CznbhPk4E8NmPEesY3Hlb73DV0BRq405eU+NMkkRlCtLZH6iVTqNgz397KuIai8rQXMUDLhH3IrZbOcj20NOrQeBbUtO7a1X/KKFVLneODxhoMYhSA4CiKQilGBUosIPI64ba7B1p8rgzeP6lH+LvFjQJkeyUwWEf3766j7SWS7RUL0YVv+Cag2C3fehoiq3jqhkgKqWB3uy6N0HP9fXrVE15i3nfbPDazGN2j/4SB12WlGD36RjFlLeL2hSqA7pB34OxK5mg9BWmCrRlXDAheejWZAohr3KC4gHQaXLMQf0yPbWwJNYm8gZ4NlS/xob6+/TC5LISq/DIa+IoVoJtdwK0OyZG8CR5D6c9Z4K7lmzfypxZg7p44gR3G8z80zWbXUG+PyKCUK/I3wVFyjl/z0pKBzAvgu02LukbZNxUfHOc8jV4CtVazHNpAX3GVw0+BfxS+P5WKxnUm1lMrUXgXRjUeHfRUTFuOlOsw5uKu8vXCMkdAMocrhE/U/xtdtcNefk7qQTekGZZJGTlI/mtr
 F5sAqwKk
 bbLG7nI8+2Gfr71jNCp2unCboTgXtf4ZN70iMidJ/bQC126Ea5UQcxuCwE7tJGccs4JkemBDAidxVh6kVI5thPJBeOUR+iwOIalIPw89TdAWgz0iLZkobGGJZgepA2x16AkmSGU/gH1RGVquqm4JXN2qd7H/Pqfw14pK3Mo593ZV4LiYTYXB97g1hdecfxsavoEYUj0WAyVYKilEMW6rTeiMqTAJO4Ij855p4SxMKYY1eNN1q8rx/KIjGs/BEP/LqYPrcFgD4+FOwWYXgdM30/UlwVOBByl+96mL4fMRmheaVTBx2p/8yoVHBs8E8frJ+mUxS75ZWQvGNEEzg8WsM7bWCWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/11/2025 12:35, David Hildenbrand (Red Hat) wrote:
> On 11/26/25 13:27, Lorenzo Stoakes wrote:
>> On Wed, Nov 26, 2025 at 01:19:00PM +0100, David Hildenbrand (Red Hat) wrote:
>>> On 11/26/25 13:16, David Hildenbrand (Red Hat) wrote:
>>>> On 11/26/25 12:09, Ryan Roberts wrote:
>>>>> On 13/11/2025 01:45, Samuel Holland wrote:
>>>>>> Some platforms need to fix up the values when reading or writing page
>>>>>> tables. Because of this, the accessors must always be used; it is not
>>>>>> valid to simply dereference a pXX_t pointer.
>>>>>>
>>>>>> Fix all of the instances of this pattern in generic code, mostly by
>>>>>> applying the below coccinelle semantic patch, repeated for each page
>>>>>> table level. Some additional fixes were applied manually, mostly to
>>>>>> macros where type information is unavailable.
>>>>>>
>>>>>> In a few places, a `pte_t *` or `pmd_t *` is actually a pointer to a PTE
>>>>>> or PMDE value stored on the stack, not a pointer to a page table. In
>>>>>> those cases, it is not appropriate to use the accessors, because the
>>>>>> value is not globally visible, and any transformation from pXXp_get()
>>>>>> has already been applied. Those places are marked by naming the pointer
>>>>>> `ptentp` or `pmdvalp`, as opposed to `ptep` or `pmdp`.
>>>>>>
>>>>>> @@
>>>>>> pte_t *P;
>>>>>> expression E;
>>>>>> expression I;
>>>>>> @@
>>>>>> - P[I] = E
>>>>>> + set_pte(P + I, E)
>>>>>>
>>>>>> @@
>>>>>> pte_t *P;
>>>>>> expression E;
>>>>>> @@
>>>>>> (
>>>>>> - WRITE_ONCE(*P, E)
>>>>>> + set_pte(P, E)
>>>>>> |
>>>>>> - *P = E
>>>>>> + set_pte(P, E)
>>>>>> )
>>>>>
>>>>> There should absolutely never be any instances of core code directly
>>>>> setting an
>>>>> entry at any level. This *must* always go via the arch code helpers. Did you
>>>>> find any instances of this? If so, I would consider these bugs and suggest
>>>>> sending as a separate bugfix patch. Bad things could happen on arm64
>>>>> because we
>>>>> may need to break a contiguous mapping, which would not happen if the value is
>>>>> set directly.
>>>>>
>>>>>>
>>>>>> @@
>>>>>> pte_t *P;
>>>>>> expression I;
>>>>>> @@
>>>>>> (
>>>>>>      &P[I]
>>>>>> |
>>>>>> - READ_ONCE(P[I])
>>>>>> + ptep_get(P + I)
>>>>>> |
>>>>>> - P[I]
>>>>>> + ptep_get(P + I)
>>>>>> )
>>>>>>
>>>>>> @@
>>>>>> pte_t *P;
>>>>>> @@
>>>>>> (
>>>>>> - READ_ONCE(*P)
>>>>>> + ptep_get(P)
>>>>>> |
>>>>>> - *P
>>>>>> + ptep_get(P)
>>>>>> )
>>>>>
>>>>> For reading the *PTE*, conversion over to ptep_get() should have already been
>>>>> done (I did this a few years back when implementing support for arm64
>>>>> contiguous
>>>>> mappings). If you find any cases where direct dereference or READ_ONCE() is
>>>>> being done in generic code for PTE, then that's a bug and should also be
>>>>> sent as
>>>>> a separate patch.
>>>>>
>>>>> FYI, my experience was that Coccinelle didn't find everything when I was
>>>>> converting to ptep_get() - although it could have been that my Cochinelle
>>>>> skills
>>>>> were not up to scratch! I ended up using an additional method where I did a
>>>>> find/replace to convert "pte_t *" to "ptep_handle_t" and declared pte_handle_t
>>>>> as a void* which causes a compiler error on dereference. Then in a few key
>>>>> places I did a manual case from pte_handle_t to (pte_t *) and compiled
>>>>> allyesconfig.
>>>>>
>>>>> I'm assuming the above Cocchinelle template was also used for pmd_t, pud_t,
>>>>> p4d_t and pgd_t?
>>>>>
>>>>>>
>>>>>> Additionally, the following semantic patch was used to convert PMD and
>>>>>> PUD references inside struct vm_fault:
>>>>>>
>>>>>> @@
>>>>>> struct vm_fault vmf;
>>>>>> @@
>>>>>> (
>>>>>> - *vmf.pmd
>>>>>> + pmdp_get(vmf.pmd)
>>>>>> |
>>>>>> - *vmf.pud
>>>>>> + pudp_get(vmf.pud)
>>>>>> )
>>>>>>
>>>>>> @@
>>>>>> struct vm_fault *vmf;
>>>>>> @@
>>>>>> (
>>>>>> - *vmf->pmd
>>>>>> + pmdp_get(vmf->pmd)
>>>>>> |
>>>>>> - *vmf->pud
>>>>>> + pudp_get(vmf->pud)
>>>>>> )
>>>>>>
>>>>>>
>>>>>> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
>>>>>> ---
>>>>>> This commit covers some of the same changes as an existing series from
>>>>>> Anshuman Khandual[1]. Unlike that series, this commit is a purely
>>>>>> mechanical conversion to demonstrate the RISC-V changes, so it does not
>>>>>> insert local variables to avoid redundant calls to the accessors. A
>>>>>> manual conversion like in that series could improve performance.
>>>>>>
>>>>>> [1]: https://lore.kernel.org/linux-mm/20240917073117.1531207-1-
>>>>>> anshuman.khandual@arm.com/
>>>>>
>>>>> Hi,
>>>>>
>>>>> I've just come across this patch and wanted to mention that we could also
>>>>> benefit from this improved absraction for some features we are looking at for
>>>>> arm64. As you mention, Anshuman had a go but hit some roadblocks.
>>>>>
>>>>> The main issue is that the compiler was unable to optimize away the
>>>>> READ_ONCE()s
>>>>> for the case where certain levels of the pgtable are folded. But it can
>>>>> optimize
>>>>> the plain C dereferences. There were complaints the the generated code for arm
>>>>> (32) and powerpc was significantly impacted due to having many more
>>>>> (redundant)
>>>>> loads.
>>>>>
>>>>
>>>> We do have mm_pmd_folded()/p4d_folded() etc, could that help to sort
>>>> this out internally?
>>>>
>>>
>>> Just stumbled over the reply from Christope:
>>>
>>> https://lkml.kernel.org/r/0019d675-ce3d-4a5c-89ed-f126c45145c9@kernel.org
>>>
>>> And wonder if we could handle that somehow directly in the pgdp_get() etc.

I certainly don't like the suggestion of doing the is_folded() test outside the
helper, but if we can push that logic down into pXdp_get() that would be pretty
neat. Anshuman and I did briefly play with the idea of doing a C dereference if
the level is folded and a READ_ONCE() otherwise, all inside each pXdp_get()
helper. Although we never proved it to be correct. I struggle with the model for
folding. Do you want to optimize out all-but-the-highest level's access or
all-but-the-lowest level's access? Makes my head hurt...


>>
>> I find that kind of gross to be honest. Isn't the whole point of folding that we
>> don't have to think about it...

Agreed, but if we can put it inside the default helper implementation, that
solves it, I think? An arch has to be careful if they are overriding the
defaults, but it's still well contained.

> 
> If we could adjust generic pgdp_get() and friends to not do a READ_ONCE() once
> folded we might not have to think about that in the callers.
> 
> Just an idea, though, not sure if that would fly the way I envision it.



