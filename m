Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC143D10F2E
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 12:19:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 135806B0012; Wed, 26 Nov 2025 07:19:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10DB86B0024; Wed, 26 Nov 2025 07:19:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 049836B002A; Wed, 26 Nov 2025 07:19:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E630C6B0012
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 07:19:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A226BBA098
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 12:19:09 +0000 (UTC)
X-FDA: 84152662818.06.6B92C8C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 016EE20002
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 12:19:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D3f6skmv;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764159548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GnuTBUFiTOii7bEWgu34YA9oYZXdXca5vfZZiN9Tsyo=;
	b=dEw1iNslEEVqPPMSSWd0nUH+/JnXecfhU6wPbbCaSMfJ7AYBta+W8oBykpcaAJGdPLucbt
	CwzYEGOxf8tYHmpZknf74QcFQ2PcU3RCwg4QaHuP1FGERWU6gANybzhoKU0gixWpfeoUBp
	2VD/GjjWY8stfuEQBubAtgG6Fl1cykQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D3f6skmv;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764159548; a=rsa-sha256;
	cv=none;
	b=JejwMhZRfTw4MpCMVr2k3tYHSaLPe7FkxMke9u92LE9fmfhVAgE/mgwQbH85u6Fek9RiXn
	inOO0NK41EOfoJD36ih/H8/IpqEoQcU2VZft+OSRZJGr2Rk47heaWtAqu212n52p2NlfAg
	NoHZbr0ky60KPVWuRSqxGp3SjXELA1c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5CBB0601A0;
	Wed, 26 Nov 2025 12:19:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7348C113D0;
	Wed, 26 Nov 2025 12:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764159547;
	bh=ma7x77mcp++yOaA+tQf5VwWQgC8A62xYMabV/ICqieo=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=D3f6skmvyEwFQ6GcsmWCUMpDzR29kqNoSz21S697+cgAnHCPtqAVpRK5FO8n0foRk
	 w+p7odI+hZYN1BUGcWGQV8rSriDIOZcp+2yPlOIQLhxb+ZRzKQLvLS9FtvhfrVLYZe
	 BCdgexPlLZxAjWXXkGVxlHnxobkWy1eCXPed4keEvMN3sB7CUnBt+VuRfkNrS4RU60
	 clLCupwtRNlxZy1OKldXhxUwjyJawrzwni1O+v6XadG6I3G3HoqR9INyVC3ziWPWc/
	 UWP35qM1Ub+uCKi0VmFEur1VMa3LH4V9IgB3w1XS+sJeJylKus4fIhzYikGMuB8Ibe
	 JxOtv+pp0YMcA==
Message-ID: <df7d10ba-bb42-4ea1-8c5b-5db88a18eccb@kernel.org>
Date: Wed, 26 Nov 2025 13:19:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/22] mm: Always use page table accessor functions
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: Ryan Roberts <ryan.roberts@arm.com>,
 Samuel Holland <samuel.holland@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org
Cc: devicetree@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Conor Dooley <conor@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
 Emil Renner Berthing <kernel@esmil.dk>, Rob Herring <robh+dt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Julia Lawall <Julia.Lawall@inria.fr>,
 Nicolas Palix <nicolas.palix@imag.fr>,
 Anshuman Khandual <anshuman.khandual@arm.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
 <20251113014656.2605447-7-samuel.holland@sifive.com>
 <02e3b3bd-ae6a-4db4-b4a1-8cbc1bc0a1c8@arm.com>
 <bc88d132-452a-42a1-9ee5-5407334d8aac@kernel.org>
Content-Language: en-US
In-Reply-To: <bc88d132-452a-42a1-9ee5-5407334d8aac@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 016EE20002
X-Stat-Signature: z1jtxfn6jia3hyqbhn1w7fwzx9km1ysi
X-Rspam-User: 
X-HE-Tag: 1764159547-54422
X-HE-Meta: U2FsdGVkX1/MA9SqcqjyrxH+feJVAhKNS254ytIc9nCl2oMkZB6bX2Wf+G79m0P9sg2Ou0/Ex7odlQVMtvsGOMtz7jRtYvIIaREOfcu97tMNevAdLsnUMbQm28EV95Br6Hh0OUQY09SWszkw8Su1g/yILS9DhA1vcj3KQEhAiLDAMPPb++G4PPO9BMBh++h8UZbMXXyf5CXEWRrQzp8FDmh/WhEzlfRt5ucx91jC7Lv4JZvkJ5I/dqI2CtIj/jOSTCOSznVRR1a8ZNc6QgIA0C87r4FuZ0YApJRZ1RW3b/+JU26dHRwkOcCY/wMZXC0igUpzTyO+wATWPSmpbW59Tzk8VBxxHdrqgVq/vGgBvbCOQt42ks4JkO2Ony1g9vWflPuW6q3IODT5pKdtyXluzvxI0NbdQEq/dcxnjVkLp7h6/pY/Gz9wPDHAaU0LEouKb6zJwFjbr/UfhDzuZjN7boo7uKr2dQQQBUsnZlGOeV7Srvgz3d1FddCKIBKUpQZd4tFtvNoFXFZ3DJq3u8Z2c6+qBnRm6tBi7kzTyoKiMEu+qXU3K3FunnNYyXWaKyTahE+DG7Xvy6pnRMJlUEkRe9602DziUd9+gVYPv9KCs0GPksPV9QJWIAVhlwu773tqnZZ5rhmQttbs+oVzffu7eXE85CSq+oWkJfr5OWKMYGCATZ/LqVRsrOVNivs7Xn2nvJRALgjzqq8JgwFFsZ5btzs/WZH86U4KQMj77rAaTnqPjWh5LfeKmKiJzrYdPqgGzrXXZpFWntFwiLJV81T1h6Wz0t+zz0qXnhQHekkpMjOaIpoOM9WEQqzcGgdkak8fTNfCmYQhrPj7ywKEmGH6QqhgrX/xGpRi67kln2gnXRH8oorrARPMuGANHPpb9aKrGNH3HNtgUsfxA7ZJRMm3zI0kWB9WfPPbiV+U/vC6UWL8CdhSj9ppPpfMpq+Zl0Qxw3oCfb6hhdQIsFBJIW7
 3BUVAq04
 sxcC/56waYtV293lvm+8WSNTXGrYf2ZOM2zteG10lpYbMdOhh/Tjo5KRA+MBc0TQ3OlcyYGwqf+QFkfXRSbjLjSuf70+X3tzHOAzmBYUh+bRWiqiWAtCc6TONfWemk7K8d5pB9PZ7AEbZxg0pMOcugOVQSzY+9VOFGRtZfMCbcQnNdEfJeCu6khMwhRd+sBnA9PpTQKTKPe6h3oZAKreT043VKreXFSdqoFyyVbGo9ORd50bgwcQk3MvHCkdR8KTeSC1Af2AyiIIfzn8c1oDyQUcmSfYegOiJOPzqGNpJOP2aLZF0jL3ZthzGra/EAokrcSVvfcZyvsRuaiYSiR12sDofVNDIxNIa31s0SDKKXTmG1O6oyoq9O/hXc/1BXt92wvxDctTN5EUTUC+RWPE/f+BQsY5fUpDxS2eOKkpJq9enPR1RC/MqxH5WLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/26/25 13:16, David Hildenbrand (Red Hat) wrote:
> On 11/26/25 12:09, Ryan Roberts wrote:
>> On 13/11/2025 01:45, Samuel Holland wrote:
>>> Some platforms need to fix up the values when reading or writing page
>>> tables. Because of this, the accessors must always be used; it is not
>>> valid to simply dereference a pXX_t pointer.
>>>
>>> Fix all of the instances of this pattern in generic code, mostly by
>>> applying the below coccinelle semantic patch, repeated for each page
>>> table level. Some additional fixes were applied manually, mostly to
>>> macros where type information is unavailable.
>>>
>>> In a few places, a `pte_t *` or `pmd_t *` is actually a pointer to a PTE
>>> or PMDE value stored on the stack, not a pointer to a page table. In
>>> those cases, it is not appropriate to use the accessors, because the
>>> value is not globally visible, and any transformation from pXXp_get()
>>> has already been applied. Those places are marked by naming the pointer
>>> `ptentp` or `pmdvalp`, as opposed to `ptep` or `pmdp`.
>>>
>>> @@
>>> pte_t *P;
>>> expression E;
>>> expression I;
>>> @@
>>> - P[I] = E
>>> + set_pte(P + I, E)
>>>
>>> @@
>>> pte_t *P;
>>> expression E;
>>> @@
>>> (
>>> - WRITE_ONCE(*P, E)
>>> + set_pte(P, E)
>>> |
>>> - *P = E
>>> + set_pte(P, E)
>>> )
>>
>> There should absolutely never be any instances of core code directly setting an
>> entry at any level. This *must* always go via the arch code helpers. Did you
>> find any instances of this? If so, I would consider these bugs and suggest
>> sending as a separate bugfix patch. Bad things could happen on arm64 because we
>> may need to break a contiguous mapping, which would not happen if the value is
>> set directly.
>>
>>>
>>> @@
>>> pte_t *P;
>>> expression I;
>>> @@
>>> (
>>>     &P[I]
>>> |
>>> - READ_ONCE(P[I])
>>> + ptep_get(P + I)
>>> |
>>> - P[I]
>>> + ptep_get(P + I)
>>> )
>>>
>>> @@
>>> pte_t *P;
>>> @@
>>> (
>>> - READ_ONCE(*P)
>>> + ptep_get(P)
>>> |
>>> - *P
>>> + ptep_get(P)
>>> )
>>
>> For reading the *PTE*, conversion over to ptep_get() should have already been
>> done (I did this a few years back when implementing support for arm64 contiguous
>> mappings). If you find any cases where direct dereference or READ_ONCE() is
>> being done in generic code for PTE, then that's a bug and should also be sent as
>> a separate patch.
>>
>> FYI, my experience was that Coccinelle didn't find everything when I was
>> converting to ptep_get() - although it could have been that my Cochinelle skills
>> were not up to scratch! I ended up using an additional method where I did a
>> find/replace to convert "pte_t *" to "ptep_handle_t" and declared pte_handle_t
>> as a void* which causes a compiler error on dereference. Then in a few key
>> places I did a manual case from pte_handle_t to (pte_t *) and compiled allyesconfig.
>>
>> I'm assuming the above Cocchinelle template was also used for pmd_t, pud_t,
>> p4d_t and pgd_t?
>>
>>>
>>> Additionally, the following semantic patch was used to convert PMD and
>>> PUD references inside struct vm_fault:
>>>
>>> @@
>>> struct vm_fault vmf;
>>> @@
>>> (
>>> - *vmf.pmd
>>> + pmdp_get(vmf.pmd)
>>> |
>>> - *vmf.pud
>>> + pudp_get(vmf.pud)
>>> )
>>>
>>> @@
>>> struct vm_fault *vmf;
>>> @@
>>> (
>>> - *vmf->pmd
>>> + pmdp_get(vmf->pmd)
>>> |
>>> - *vmf->pud
>>> + pudp_get(vmf->pud)
>>> )
>>>
>>>
>>> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
>>> ---
>>> This commit covers some of the same changes as an existing series from
>>> Anshuman Khandual[1]. Unlike that series, this commit is a purely
>>> mechanical conversion to demonstrate the RISC-V changes, so it does not
>>> insert local variables to avoid redundant calls to the accessors. A
>>> manual conversion like in that series could improve performance.
>>>
>>> [1]: https://lore.kernel.org/linux-mm/20240917073117.1531207-1-anshuman.khandual@arm.com/
>>
>> Hi,
>>
>> I've just come across this patch and wanted to mention that we could also
>> benefit from this improved absraction for some features we are looking at for
>> arm64. As you mention, Anshuman had a go but hit some roadblocks.
>>
>> The main issue is that the compiler was unable to optimize away the READ_ONCE()s
>> for the case where certain levels of the pgtable are folded. But it can optimize
>> the plain C dereferences. There were complaints the the generated code for arm
>> (32) and powerpc was significantly impacted due to having many more (redundant)
>> loads.
>>
> 
> We do have mm_pmd_folded()/p4d_folded() etc, could that help to sort
> this out internally?
> 

Just stumbled over the reply from Christope:

https://lkml.kernel.org/r/0019d675-ce3d-4a5c-89ed-f126c45145c9@kernel.org

And wonder if we could handle that somehow directly in the pgdp_get() etc.

-- 
Cheers

David

