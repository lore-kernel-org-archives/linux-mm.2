Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED3DFC982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 07:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D49786B00C1; Mon, 21 Sep 2026 03:38:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D20CE6B00DF; Mon, 21 Sep 2026 03:38:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C36D26B00E1; Mon, 21 Sep 2026 03:38:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A0E176B00C1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:38:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2970D1605ED
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:38:05 +0000 (UTC)
X-FDA: 85236965730.18.231969D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0B52C80003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:38:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=l6ko2rle;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789976283;
	b=i83OwbS0nYW7cDP9sFLKlspgCIJNROk8prKx1rHrPMz6MmpBT2+WUAoFrz41kDIo/uABHh
	zKM1OzyNuOQDiNiJcTAjOVXlkiFMX1j1ruCgStl+N/qLKFJRBcbY4T0R5YkCEdGIDN6ujH
	uq5LSgVrYJVCjBryENDYO3vMHG7OT8E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=l6ko2rle;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789976283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qcNAYLYdiq5rOSe15EFUoU8/lzxAYix9CpJvkQBhqoE=;
	b=DkPNhXiSbcpTA+6jBVg196uq843LWd6KIm7gKBgptCT+7cPuXkQzXsz3G6UJq1nK9jGCZr
	cwtjEvenyfsoUNhVpYrdOLzpuVaqenHdRSlaWmTQrHBB+aNd9SnhU3XS7FUFSxo9ABq1/9
	jkjIowwoH8AL1IW+WtZ5cWS6JK/IeAU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5BB42175A;
	Mon, 21 Sep 2026 00:37:58 -0700 (PDT)
Received: from [10.57.83.12] (unknown [10.57.83.12])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DC0733F86F;
	Mon, 21 Sep 2026 00:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789976281; bh=nrUjuFhT3s2+v/gwSala4pCbrkVM+7IhP9tittz2bGU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=l6ko2rleUboMNNtjiHiGjklemMccKDrVkhFCxBZ8Sdh5DR4atC+hN8GMVuMwMP5mz
	 35t8eGH82Xntk2lduJ6VuzvD4tP1J1d2XqoJr0PaLohuTpW2PjZwo3fxqWq6vXhlxV
	 DDTrpBYl7OVsuGeT/5runOY5gbLovztguwJGGIsY=
Message-ID: <8d36a988-f6e2-446b-92fd-dc13a4fa691a@arm.com>
Date: Mon, 21 Sep 2026 08:37:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] arm64: use hw_pte_t for fixmap HW PTEs
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
References: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
 <20260914-pte0_arm-v1-4-bb53b663e396@arm.com>
 <829523cd-85a4-4f8e-b9f2-f3c1d7ce4fb1@arm.com>
 <1d1e38d8-cc1a-4a53-80c7-c0ef75a70105@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <1d1e38d8-cc1a-4a53-80c7-c0ef75a70105@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0B52C80003
X-Stat-Signature: fesmybdp1umakjjopgztkjc97t75d1s7
X-HE-Tag: 1789976282-689779
X-HE-Meta: U2FsdGVkX1/30AHsY1vk76bPb5P3oyCP+1jQkQ/z6gf02kA5dvVV7f2Qed3sqsTq1BGKe0b0eMMIbXbwIyM1QrznIUcTVrNIPYk5eqJybGp0noFWZCDBAMt66btHnqH/AjswCbx416Sj3/6PTDsAQKM0PJA0kca+liNmRKVvyu/wCvtOn2pb9tueT00g+gi1ES6CUzO7+R3BssD+qW/WRsP/Dag4dxDv19v9YYa55vwEheFa95341kc/6q2RX/ywuojHFQ6FequeIgb6VwgKjZCFLAuk/5jwkd9ZGuCb+uaz11mQIkd9uSGLDNbNrFkH7ZsXe5ewy7va4VrpZZ4NeDydhNssrP4qGcMBvsmzfY/HdbB6iJT/RXwFDAEaa5H/lq7sTzDNZZ3roSP9IZZ73SohztoYk59IQwRLXRAb73cL/L5elw+hoQrY/GaN7THflOne3QV2Pe/RCFMMxLJIbg7pgwbBu3vNV6tozJOD6DpaQS0BfeuoPlgMzyGQ8+se8YXEewVzPbvMFu5So2FUrVcCVKi813IIqfuPOBN6KVeshZsPLryvVytmGHGXIUFsOVnQ49bvJbaFtaUHpI96ktIwKK8hU9CVdSaPEbRoMvAtjsfhxvO9ct54DPakxNLfbN1PXTLFWicMLt1quKF+aXuZtCwdIyjNfVDeOvWdEDwkfGJQcbL/bkGK7DlRLafuBAKf7dNP0WGue+Kg+Ys2497+h6ZeeBTo7A65ID6SvNTeezgQ74E0PQcFAct+sVnL4iKF8KVJ+yKxO/r+X7K3lAmBP6SKOJpYFmJM36fn/wVokD7rOFyR60DCuZ+nnZxwEc9lR72VseBLX5xdel/+VV1k4rzNR+srm7Eh0v5KoBd7GRCr/7/ff7hBaoEjXCrX6TjK3rzFwU8Wi5dVbSuXNvFULPnSYgZXGuiwlCe4Q0ytYAoOYTtwElvQLExBfh1buRwNJ/JPAfh4tNYoOc0
 R72CfyYO
 CFpRy0chCSq4LGU+SUW0opwuAZhH2ltt8zBdAeqhzPkUoZwOgMObWSo7UCtsQxBfInHPGsvyC3YDqlug/4yRT2qJWFyc5LwgP+MAmgtEtOWPvoHAKKAO/VbyE2bE6DxeHw+qpOnbFSUKcVTj/gSfJ+8EXl6l0YSI3dHD37oB5gpOmywj8AlDAqEsz9W71r8OIbYHKTAng1qla3btI5fnXQk2LT1nIsW0E2eMvapIyzeY81A50sCJUmjbQgIM4TK+l0AkVdBbA12/APJUpEd06PptRJFYxnOrMgiyXkrfF0R+24t2hJ4xiBIYRIikk/LWVTFxiSwlmjWDm9pOnG0Wch42Ouuyw3+cF/WUuAN16ADP8qMqExJ/2oWzMGkvkjDLejDiv4JI4k2QGVxnEa3LwJPXCG7eRayptm3qX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/09/2026 21:00, David Hildenbrand (Arm) wrote:
> On 9/18/26 18:03, Ryan Roberts wrote:
>> On 14/09/2026 14:51, Muhammad Usama Anjum wrote:
>>> fixmap_pte() returns a pointer into bm_pte, and early_fixmap_init_pte()
>>> installs those arrays as page tables. Their elements are therefore
>>> HW PTEs.
>>>
>>> Change the element type of bm_pte to hw_pte_t so it matches the HW PTE
>>> pointers returned and passed to the accessors. This is needed before
>>> ARCH_HAS_HW_PTE_T makes HW PTEs and SW PTE values distinct types; the
>>> array dimensions and placement are unchanged.
>>>
>>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>> ---
>>>  arch/arm64/mm/fixmap.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
>>> index 237a9136bc73b..709a97fe327d8 100644
>>> --- a/arch/arm64/mm/fixmap.c
>>> +++ b/arch/arm64/mm/fixmap.c
>>> @@ -31,7 +31,7 @@ static_assert(NR_BM_PMD_TABLES == 1);
>>>  
>>>  #define BM_PTE_TABLE_IDX(addr)	__BM_TABLE_IDX(addr, PMD_SHIFT)
>>>  
>>> -static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __bss_pgtbl;
>>> +static hw_pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __bss_pgtbl;
>>
>> I think in my original proposal it was impossible to have a hw_pte value; only a
>> hw_pte pointer was possible. Being able to create hw_pte values means that it is
>> possible that a hw_pte_t pointer is not actually pointing to an entry in a HW
>> pgtable. The main motivation for this is that we want to dereference neighbours
>> of a hw pte based on it's pointer and be confident that it is safe. I think this
>> removes some of the safety.
> 
> If you follow some of the related discussions on the core-mm series, there is a
> path forward to go further into that direction.

OK, as long as we have a path to the "full" solution if we ever need it, then
sounds good to me.

> 
> People instantiating a hw_pte_t on the stack are not really a concern right now.
> 


