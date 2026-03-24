Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AFB5F532EA
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 08:05:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3B876B008C; Tue, 24 Mar 2026 04:05:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC5776B0092; Tue, 24 Mar 2026 04:05:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDB166B0095; Tue, 24 Mar 2026 04:05:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ACA986B008C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:05:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 554901B9E51
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:05:50 +0000 (UTC)
X-FDA: 84580222860.18.9525D7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6319E18000D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:05:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=goE3OWbq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774339548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BofAPnpPiZxoHh9sLYeRdTHI78bSXG0jS3FZFaG1vUA=;
	b=vgmCcatHOqjZq7ssQADwyZmYC1c1dV+CRkN/egdBb4IgL/BKTJ0jGrp0XTwd9I7qkyOSSd
	jwinpA8SeID7Fn3J5EHvoezsxQZjUC8QaSjHU+aL2aYLUie1jbCTLCxwE/Tc5SL0yTp3Tl
	4xzIDb2C0uXxt0LFEl9taZ2NOCZpWtI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774339548; a=rsa-sha256;
	cv=none;
	b=Y+ve7DlLL7rpcigqB9Q1YqY7sdssgmb/q4NBVTodWvt7S/ZquHYMrsYwvnrz1SnjReoPO+
	oet9l6mfKFw3m7DrTmDpqvD/quHAwLNQeWMoriiUglZ1fxZxgCpmRyZjFbXKNYzWuMp5h1
	UqmoZXGJWP4YvwIJgWUxCgMynZ3W0y4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=goE3OWbq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 67E4443B38;
	Tue, 24 Mar 2026 08:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38E7C19424;
	Tue, 24 Mar 2026 08:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774339547;
	bh=R3tUPav66vuh2+XNlYS0TIlLO+2gZChki+fScnkn0+o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=goE3OWbq+wiuW7jn3ojwJ2aTTY3bepFl3ITL6wOa9ecfISbctDqFx0fDwqDYbZMgI
	 mY8GssZHDoARjvmjQjN04YED+wZsyAXGuYgCAXTrt1K8/QbAhX2xbw0G54tDycbYoJ
	 HT2LSHIQplpmbAPpJ5ya+feBbIN/2z/TAsysqFDwL8NQSG/RHRIlkMUfL8BjUVwgQT
	 GQqIQDYV4u0uk6y+AQ7MBUZxFygEklypAhv0pKEOLnRJZoD9Hayno5z3plsaLQE0uh
	 lue6CMPXDV9Q34VMIYC8z6Ijwc0wOEZ1CpmC0d+nM4rbffwjlGPDjQTO6osa6J04wp
	 kNMg/i54lGekA==
Message-ID: <3ddd7629-7282-4ce9-9de5-9de201ea395d@kernel.org>
Date: Tue, 24 Mar 2026 09:05:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory: fix PMD/PUD checks in follow_pfnmap_start()
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 Alex Williamson <alex@shazbot.org>, Max Boone <mboone@akamai.com>,
 stable@vger.kernel.org
References: <20260323-follow_pfnmap_fix-v1-1-5b0ec10872b3@kernel.org>
 <47346263-ee56-4a78-b55d-7f28c617c673@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <47346263-ee56-4a78-b55d-7f28c617c673@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6319E18000D
X-Stat-Signature: coe6ezn9xa6xxgmpwt9z39e4fkoynq4a
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774339548-810073
X-HE-Meta: U2FsdGVkX19Uk5lHBTTiozAZA2yuswcc8xryLIRq1DC32wJDAeACZVM1ji8cw6erBXdOgTH8zJ3Gsic4Bybv+O8RwzAixbF5F7M823NId5bYU+qvh83YbVLTzuxgTWGhA9xcOs0SUhDqJw2Lu8HmHnr9/krRX3T0LsrV2NlBBbfP9MT3pnKOpQm+tWR6kpSBfLEvpGPavH+jmcmyamtRMejF/nlMjyLK8tE6nLG5ELOkPQjyMis3H3J5o3xemIVeWx3EExD+Txzwgnc2jnTRvli7I67jQ6sVR09VbHHuS65u2ZWQ5ABNTppL+43errjE+fwJd9Jhw6WtezlG9+f6Y7M4yAo8fAbGrV6wT+Qzmp2qoCCLlvjqwBWJukWrfGMWnWnbQ7oAATC0GusoWdozMAS/rF+D6ULpqKpZ+pZEyL0e6OmrhcSlBGkZpHS8aPtaYqThTZEykabAxJcHl1Rarft/MG6XDvsttrlvYlg2v+b0rA6StHNy4E6R7VvEWnSVEo8ENNohcuofT05EpbQSHr3+hBjF3e3xPEZ2gHOB/oXuTEVM+02+Qi2r3f7+SSN3NgOC4cPFzwBmyO9hfCGirwIS2njK8SJ5g6+3h5XCruglMJlcL6CjtUbdxos6oFX24/HAZTx4RkM5eqg7AdJjxL2LLirDVyYmZpx+SO76A8WIuxfJ23tcUl2aYWbIo8Ce25RxUinSI8iYgnsNBr4uK2yBLpQErmiekTsRMkn4hZCBl0VTyYePyGljjXlEV9Ff3kEKd9jvkXfFOuP973akd8l8ChI5NoJ2OXrsVTJKw2yUTmDc+Fgmt2hMViCy0PzRJPSX3cyPYI+ocM/WNJmbvXE7N9RzUJQtyR2AgcmTNoeR+xwYV4nHZxL38SgrRIKfJRRu6fbcQa4Id081BlISWyofpnxzdqQ1Mgkn2fcBgkRJHncti5a1YaOCp+/EAhoifKRTRbqgG+X6x0EFO1K
 R5eQKTqB
 vKEib4q2RQQOtb8QdZknEUrVT2LrzrPB7ZxJ81zKOWoM85PFSskDwo1qnh1AK8scgcaF1XfCmiI9XlQIMDgOQ1ZDdSVZybW3fBsCuRSUJA5ZcZiPI8a6aBF7i4DogG8byBu7SyiyPU6HjOV27KMqRFOokdejgOa3AFv1sTFI7E7cHw7TDCnse5rzKc5XAJ8miuP0eBi9W5RY4GAuijlsLJxdkCAxMhyeGJBIgrgY3bqSOEtdIqyFyWeUYvNUHjYg3H5CeFVT7wHdMVIZTX8M778k2a4RrafLQ+pPZ5NxAFmq6JRTv32TnHjAb7yKRQqwaShEXujZ0qN40Yks=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/24/26 08:33, Vlastimil Babka (SUSE) wrote:
> On 3/23/26 21:20, David Hildenbrand (Arm) wrote:
>> follow_pfnmap_start() suffers from two problems:
>>
>> (1) We are not re-fetching the pmd/pud after taking the PTL
>>
>> Therefore, we are not properly stabilizing what the lock lock actually
>> protects. If there is concurrent zapping, we would indicate to the
>> caller that we found an entry, however, that entry might already have
>> been invalidated, or contain a different PFN after taking the lock.
>>
>> Properly use pmdp_get() / pudp_get() after taking the lock.
>>
>> (2) pmd_leaf() / pud_leaf() are not well defined on non-present entries
>>
>> pmd_leaf()/pud_leaf() could wrongly trigger on non-present entries.
>>
>> There is no real guarantee that pmd_leaf()/pud_leaf() returns something
>> reasonable on non-present entries. Most architectures indeed either
>> perform a present check or make it work by smart use of flags.
>>
>> However, for example loongarch checks the _PAGE_HUGE flag in pmd_leaf(),
>> and always sets the _PAGE_HUGE flag in __swp_entry_to_pmd(). Whereby
>> pmd_trans_huge() explicitly checks pmd_present(), pmd_leaf() does not
>> do that.
>>
>> Let's check pmd_present()/pud_present() before assuming "the is a
>> present PMD leaf" when spotting pmd_leaf()/pud_leaf(), like other page
>> table handling code that traverses user page tables does.
>>
>> Given that non-present PMD entries are likely rare in VM_IO|VM_PFNMAP,
>> (1) is likely more relevant than (2). It is questionable how often (1)
>> would actually trigger, but let's CC stable to be sure.
>>
>> This was found by code inspection.
>>
>> Fixes: 6da8e9634bb7 ("mm: new follow_pfnmap API")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
> Should we also convert pgd_none() and p4d_none() checks to X_present() checks?

For these, we don't really support non-present entries yet (excluding
hugetlb, hmmm)..

I have some more cleanups laying around here, I'll throw that in as
well, thanks!

-- 
Cheers,

David

