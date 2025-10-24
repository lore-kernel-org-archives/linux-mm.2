Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 423F9CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 14:54:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A12B58E00AE; Fri, 24 Oct 2025 10:54:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9CE8E0042; Fri, 24 Oct 2025 10:54:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 926908E00AE; Fri, 24 Oct 2025 10:54:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D5778E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:54:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 26A08160E9D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:54:58 +0000 (UTC)
X-FDA: 84033305076.21.F244D55
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 644524000C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:54:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761317696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TLTn/UbQmcHWmadVul4cDw8XkcAbkv+aTx0AlM7M7aQ=;
	b=3VZxgo2fakhfQMgW4e8vjgAACbHiPsUWXr8/zS9gvtTSnPHc9LYz4/y/naoAzR6/1WcsMH
	Z4TMqhTF0fUy1YSL/6DNcv3O9ejbUWEOIX7sEJvTGzyiU2GzNjyLb+PeMjE8iRah0nrHzg
	ZBlwPgIyZABmkNqHqygjSEEDROwTMpA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761317696; a=rsa-sha256;
	cv=none;
	b=Ipf28UewY45cYADVq4Xpll4+PK6qVDYzoy6RvkxibXSaFHDMQGyfRVqZTDqyc36HuHERZF
	IdZHfF12T0HO68H6LQ63bXK9AWuRoLyLgIDKksvk09u3rKCtAzpK6bmSVvZSaAlSnT6kG6
	pg7P5HMj95f5Q8aXGsbW8cvG+4KZOiM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8AF2F1424;
	Fri, 24 Oct 2025 07:54:47 -0700 (PDT)
Received: from [10.57.67.38] (unknown [10.57.67.38])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 10A0E3F63F;
	Fri, 24 Oct 2025 07:54:47 -0700 (PDT)
Message-ID: <1b658758-73dc-4e53-aa7f-696f59067067@arm.com>
Date: Fri, 24 Oct 2025 16:54:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/13] powerpc/mm: implement arch_flush_lazy_mmu_mode()
To: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
 <20251015082727.2395128-4-kevin.brodsky@arm.com>
 <60c55686-87dd-46d0-884e-80f7d423663b@redhat.com>
 <604f26cb-46c6-4533-8110-0b174eed821d@arm.com>
 <5d5a85ec-0213-4af3-92a9-c02bb13da073@redhat.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <5d5a85ec-0213-4af3-92a9-c02bb13da073@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 644524000C
X-Stat-Signature: m95p9m4wqiefsgti4autyac84s5rci19
X-Rspam-User: 
X-HE-Tag: 1761317696-783150
X-HE-Meta: U2FsdGVkX1+ORzALLbU5kVYqGMUva4TMsZ3h/BTgEN3B7mR4H5t1HZC82ngxg+JL4n3za4Plib51yF8qQN64N+Tkuks5MgXE3TFynBr6G27Mj/qEi4okTK520aTNK3VnOmAdu6I7C7CVUN1zYVLuxFT8qBFez93ia63MAoh/dm5VWx/XuSqeEfYlL8gkIiRiYFfSZioVsFay18pSIsuQBzxt/NeCyR4FzbYoVAlDRs4PSmokLoLMHjBh5CMmVOrbcL2tLleFxcX0UVDd/v51v1ryRi/9L1LS7bXKgmDRdWq09rrEBHS2LQdXnjafDV5FOs4pvXsWOb/dcPBywLbZHa233qF9voJZd/K65w9Un2wNa1ngSOflnPBrwXT2ObNtO1uFOXVphsa/NiFBXG1KCPjH1k5/EisxrwbuQU69eog4KHlH5Zz/ap/aAtYhmpkSjVZlcFri7yvtg+klBNq+nP/vgdat+cXoBPi9FUEyPVPJkxggLuw990O2qXI78x8aSOFrxKgl7SedxTxnrAg5d6y02RvKzRpSOA16MjJxWsd4+Dok9X6zEZZsLBl9nN7+PZU0l7JtsO5ha++RtJg6Y/fUf4n906rNtzHGDCcXuD+Vm0MUtIejFVrwdW1GK1hDxFGMZ5pEbXlgE+d0y00iiisj9ZKmGgzFC78FU/Z2nfeMbqfW50g7CQRyjhyvKhKy/uX2k2Gj3pB0hWZccsMUZi0bDyrCgaHHcYimdYph5e0oZPnvB+ZXs7Ir73srr5ZfskOGMMN3vVgqbf71QJbMpBYm1QdNOu11gNlwljRgfrKlf0C6YFzjKc0Fy4I8/YovjviNfzcpDZzBZbl5kpv8OWHjldAW27UGmuDBui0g7hErHb2H5+PhaNkUXbPUw/7+ptnO1ClU5GsGTFb9iBjPylckdHAgMSvWo+UNenH7UzyyqtVUcv+8BqHDJLTDpYxoz7lFLXICFCCRk2dfZzM
 Fgs0ZfNg
 oaKNmTljM3xG23FRQiNEF+X8odIcUUye38siHN+HdjxXxAhRyaxktdvCdAiNvob/bVg1C2OgXyO+BX1xvJRBYe6aTVKyKEERJD4af8uffGM0/eCIOoA3ceLA6HIxQMUOJMbKTz2VXdyL6bVo3+ZLxfNWvmBq5tHmK5mYT4ymRPI1k92IIZGoUA3BnAR1/5Gg/6dZQA4MF5rBUrEtReB6MNp4J7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24/10/2025 16:42, David Hildenbrand wrote:
> On 24.10.25 14:09, Kevin Brodsky wrote:
>> On 23/10/2025 21:36, David Hildenbrand wrote:
>>> On 15.10.25 10:27, Kevin Brodsky wrote:
>>>> [...]
>>>>
>>>> diff --git a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
>>>> b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
>>>> index 146287d9580f..7704dbe8e88d 100644
>>>> --- a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
>>>> +++ b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
>>>> @@ -41,6 +41,16 @@ static inline void arch_enter_lazy_mmu_mode(void)
>>>>        batch->active = 1;
>>>>    }
>>>>    +static inline void arch_flush_lazy_mmu_mode(void)
>>>> +{
>>>> +    struct ppc64_tlb_batch *batch;
>>>> +
>>>> +    batch = this_cpu_ptr(&ppc64_tlb_batch);
>>>
>>> The downside is the double this_cpu_ptr() now on the
>>> arch_leave_lazy_mmu_mode() path.
>>
>> This is only temporary, patch 9 removes it from arch_enter(). I don't
>> think having a redundant this_cpu_ptr() for a few commits is really a
>> concern?
>
> Oh, right. Consider mentioning in the patch description
>
> "Note that follow-up patches will remove the double this_cpu_ptr() on
> the arch_leave_lazy_mmu_mode() path again." 

Sounds good, will do.

- Kevin

