Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62294D10380
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 12:16:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7FCF6B000D; Wed, 26 Nov 2025 07:16:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2FCF6B0026; Wed, 26 Nov 2025 07:16:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96CD16B0029; Wed, 26 Nov 2025 07:16:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 852BB6B000D
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 07:16:45 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4AAE5C0595
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 12:16:45 +0000 (UTC)
X-FDA: 84152656770.08.5353919
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id B9FBD100015
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 12:16:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TACbEM73;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764159403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ISCGPG3uyAGgpSFFTKfFc5w7MeIST0ynEGlJ3WgYudo=;
	b=3ijSTMfhcmstB8KSrCX6uTk3k2RTTCx0r5RQ9Fp9ZrBXvZ1OCP0MLg6ZDclRtB3ICiht4h
	zPQlba8OBHmWyoJJ7HGYrnynPNXQPVhIz9IDDl7WF5/AvMHYK85wfLVxho+kHUr98IZUW2
	FD+CZ+MTlICFsWXTLbuEbNMnHp32daA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TACbEM73;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764159403; a=rsa-sha256;
	cv=none;
	b=jJI1stAEsn2z9wiPljXHWhf+Y6hpWjeu25Ie+enfAOaZKCGoJgzuU5mz7YkgQG01+B8LTB
	YKObzNFHwSw/dAwVpZhPX4LhmjPwoCj40Pfn2GzNTDkCV1tH0lxRsekv5W9n0JrxF3QPYz
	zoncMBZx0Q2jjxbALyomwesYZ68SObA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 05E38601D3;
	Wed, 26 Nov 2025 12:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365DFC113D0;
	Wed, 26 Nov 2025 12:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764159402;
	bh=569JL8Idd3SiwMOD93rNhvlIpUh+BPTaH7EbV9ymg/w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TACbEM73IGgECtM+Jde3dTQ6OgN+Wh3e9eSceZE9/38PANZYd9Dm5t5nHqzypK0NH
	 XTiCzEQCy8XCf+z2hzbZjcFdNTkGDX4ngF1SbU0txbSHPmQp3ZThXVE6Xh6sD6sU52
	 83TDBRfkmuGwfkNbxf4rvLFAgMgQM8VejwxYHgd6gXyEGnPMIo1fsAskyUH6dr92Nh
	 CYen0EIEPfkFy72coiuPo4TWQSB+ayBrz5FnlYBq2yPe1Z4Bg1TXVk8DfLWPqaI2zx
	 B7dp28/HSQqCOi6qVLdB518TEL6vYLFhMIh6kiB72HzuAeAefTha1GwkvD7PlB3KlW
	 vDM+ci1MJj66g==
Message-ID: <bc88d132-452a-42a1-9ee5-5407334d8aac@kernel.org>
Date: Wed, 26 Nov 2025 13:16:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/22] mm: Always use page table accessor functions
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
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <02e3b3bd-ae6a-4db4-b4a1-8cbc1bc0a1c8@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B9FBD100015
X-Stat-Signature: w33jxx59m1xxzhzjxjxh1d44oxz7q8n9
X-Rspam-User: 
X-HE-Tag: 1764159403-182846
X-HE-Meta: U2FsdGVkX1+GmL/yqTuQZVy8s3bjzWDAjeFvnH12X4hpkguaDJPKOHA9TpJsUBeJIuMVhIQt/zfa8GkiOJnwlyo4I4VwHlSQCNUk98nB9LOO780Z8TDxDJ8Wp+v9JDKXL5G5roU0BTVAPWZN1S5t9ZiP2M98meptIZpzqSNyQqBEjVUA62W8Pre6757j/CTMcDK4hTXmYiuxyQROcvFrXu45GgyUTlng4Gon+G0nKYsAMbpGzmoP+nTQg5pSYdZbq6dAQ072b0z3wKDjSjVYfUoe2LR/3t2SdTUTPTWEA+otDHfF7XyOnDs5U1RElM9FEoDf8VXVgrVN5/X8C5QhSKQSvNlbV49V7EoLSwpJnixQctKTw8F9vSkP12dg4PEZQMXMCiVlKagijvw0F8n1uNELyCd9c0GPND5IwgWso/gkV/t1yIBplXB6PGAa6kSBz2SZfKUoePBN3TfDyEKrw3dUyABJ6aVZ7yc8ragMtlNDiAXXaCdcZ2qEEVZzW8dTad1b+iOi53egqq4GUH+FEFlUO0Bc5bp/fplBTjwjytWXx7RgAm8MmYEAP3HD1bE/3mCPTRYrM/uEDRXNvp4AV5B8PDaZSuJ54in7MPePmkqokEzasiE0nObFJp9VoR+vbTd1Ro9ETqYtOLyNK7ZhpJLF/H0BKbQsgB6geBa1d8Z77nPfYzMKQaMcLMoMm5UfqhK49/cB/D18uOJtb2d93QPEZIAQ+RjAeC3zKqEogdoSCyua0+CxpsUPRBdOkhqi8WmHQIDggS308ex1R7LsK7QgIFYnkPIJY0cZmwJLsZomKBgGjXHlJf+//ZvMeY0fhIPVJahTep7TmptfdFkLY5GTkeqWgWkqJbsTgeRlqp142XIq/9tpgNmNiPcGv80dCg1tV2xV2AWyJ8DUy8f1angWTH0kubIC3vE3FfVIxp+g6BY1Con5bpp1mzQ1xS/18p78jVRX48lItakvB6L
 bsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/26/25 12:09, Ryan Roberts wrote:
> On 13/11/2025 01:45, Samuel Holland wrote:
>> Some platforms need to fix up the values when reading or writing page
>> tables. Because of this, the accessors must always be used; it is not
>> valid to simply dereference a pXX_t pointer.
>>
>> Fix all of the instances of this pattern in generic code, mostly by
>> applying the below coccinelle semantic patch, repeated for each page
>> table level. Some additional fixes were applied manually, mostly to
>> macros where type information is unavailable.
>>
>> In a few places, a `pte_t *` or `pmd_t *` is actually a pointer to a PTE
>> or PMDE value stored on the stack, not a pointer to a page table. In
>> those cases, it is not appropriate to use the accessors, because the
>> value is not globally visible, and any transformation from pXXp_get()
>> has already been applied. Those places are marked by naming the pointer
>> `ptentp` or `pmdvalp`, as opposed to `ptep` or `pmdp`.
>>
>> @@
>> pte_t *P;
>> expression E;
>> expression I;
>> @@
>> - P[I] = E
>> + set_pte(P + I, E)
>>
>> @@
>> pte_t *P;
>> expression E;
>> @@
>> (
>> - WRITE_ONCE(*P, E)
>> + set_pte(P, E)
>> |
>> - *P = E
>> + set_pte(P, E)
>> )
> 
> There should absolutely never be any instances of core code directly setting an
> entry at any level. This *must* always go via the arch code helpers. Did you
> find any instances of this? If so, I would consider these bugs and suggest
> sending as a separate bugfix patch. Bad things could happen on arm64 because we
> may need to break a contiguous mapping, which would not happen if the value is
> set directly.
> 
>>
>> @@
>> pte_t *P;
>> expression I;
>> @@
>> (
>>    &P[I]
>> |
>> - READ_ONCE(P[I])
>> + ptep_get(P + I)
>> |
>> - P[I]
>> + ptep_get(P + I)
>> )
>>
>> @@
>> pte_t *P;
>> @@
>> (
>> - READ_ONCE(*P)
>> + ptep_get(P)
>> |
>> - *P
>> + ptep_get(P)
>> )
> 
> For reading the *PTE*, conversion over to ptep_get() should have already been
> done (I did this a few years back when implementing support for arm64 contiguous
> mappings). If you find any cases where direct dereference or READ_ONCE() is
> being done in generic code for PTE, then that's a bug and should also be sent as
> a separate patch.
> 
> FYI, my experience was that Coccinelle didn't find everything when I was
> converting to ptep_get() - although it could have been that my Cochinelle skills
> were not up to scratch! I ended up using an additional method where I did a
> find/replace to convert "pte_t *" to "ptep_handle_t" and declared pte_handle_t
> as a void* which causes a compiler error on dereference. Then in a few key
> places I did a manual case from pte_handle_t to (pte_t *) and compiled allyesconfig.
> 
> I'm assuming the above Cocchinelle template was also used for pmd_t, pud_t,
> p4d_t and pgd_t?
> 
>>
>> Additionally, the following semantic patch was used to convert PMD and
>> PUD references inside struct vm_fault:
>>
>> @@
>> struct vm_fault vmf;
>> @@
>> (
>> - *vmf.pmd
>> + pmdp_get(vmf.pmd)
>> |
>> - *vmf.pud
>> + pudp_get(vmf.pud)
>> )
>>
>> @@
>> struct vm_fault *vmf;
>> @@
>> (
>> - *vmf->pmd
>> + pmdp_get(vmf->pmd)
>> |
>> - *vmf->pud
>> + pudp_get(vmf->pud)
>> )
>>
>>
>> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
>> ---
>> This commit covers some of the same changes as an existing series from
>> Anshuman Khandual[1]. Unlike that series, this commit is a purely
>> mechanical conversion to demonstrate the RISC-V changes, so it does not
>> insert local variables to avoid redundant calls to the accessors. A
>> manual conversion like in that series could improve performance.
>>
>> [1]: https://lore.kernel.org/linux-mm/20240917073117.1531207-1-anshuman.khandual@arm.com/
> 
> Hi,
> 
> I've just come across this patch and wanted to mention that we could also
> benefit from this improved absraction for some features we are looking at for
> arm64. As you mention, Anshuman had a go but hit some roadblocks.
> 
> The main issue is that the compiler was unable to optimize away the READ_ONCE()s
> for the case where certain levels of the pgtable are folded. But it can optimize
> the plain C dereferences. There were complaints the the generated code for arm
> (32) and powerpc was significantly impacted due to having many more (redundant)
> loads.
> 

We do have mm_pmd_folded()/p4d_folded() etc, could that help to sort 
this out internally?

-- 
Cheers

David

