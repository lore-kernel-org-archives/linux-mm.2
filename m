Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 044CECCD1AB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 12:09:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4062B8E0082; Fri, 24 Oct 2025 08:09:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38F2D8E0042; Fri, 24 Oct 2025 08:09:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 256EC8E0082; Fri, 24 Oct 2025 08:09:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0CFA48E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:09:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9CDA1C0794
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:09:35 +0000 (UTC)
X-FDA: 84032888310.18.949E68D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 78E2116000A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:09:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761307774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vx0WzEGRG5T7hv6IU1TBe8wwTw3a6x50Kf2p0I05e9s=;
	b=8UpChff8El6hzVw5N6zt6MWtHyA5ITdOgmcUPqVygu76z+TmBLHAJHeywrvKiWK9X4HYc2
	2zjLnBveB67Y9BPZgVm2ewsDQevHUtnhAjhm0S/93UsUjcFgJdw8VJvanNfXY0EFgS4h4C
	OL+FUTd/i/tNKychJcwgq7FJSesIPfE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761307774; a=rsa-sha256;
	cv=none;
	b=7htgcSCeyD0ZkPLmDA+6FNBl94ZlgoRbQDQW7XVlKzq4d7ickR0cqGH5JPv6S1MvkAy62i
	F3XAFkLycZyA2MZPNfW5VS37HIXtR/sVMOkyTt21FUK6LGoHWzNgV8WxCCmqiweRE6Nfwo
	Q5PmcyVy7DgkQp6eQtjZ9A4EOyHzUZA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C614106F;
	Fri, 24 Oct 2025 05:09:24 -0700 (PDT)
Received: from [10.44.160.74] (e126510-lin.lund.arm.com [10.44.160.74])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1BA303F66E;
	Fri, 24 Oct 2025 05:09:24 -0700 (PDT)
Message-ID: <604f26cb-46c6-4533-8110-0b174eed821d@arm.com>
Date: Fri, 24 Oct 2025 14:09:21 +0200
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
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <60c55686-87dd-46d0-884e-80f7d423663b@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 78E2116000A
X-Rspamd-Server: rspam02
X-Stat-Signature: h5etc985e4h56w5noiqqcpkm1gr1efeq
X-HE-Tag: 1761307773-979397
X-HE-Meta: U2FsdGVkX19AOR2HQ852iEFKhQl/flmeHWE/vDoFJ7qNB60Vcghw+Fc3zv2fdW0RA9s6wBq/zGt+0mr5reqonI2hRwv+MVNX2N/DUsKoMUZw85jXjWKb1VV0mRkJ3L5wTb6th414rlmIDHtDg727lIg+4cxb5wYB0V1fcILTBxjZnfTHDPQ+hWysEzYAy7Xs/ZtU03nmZ4EYkhkylcMDieXc/UuCkHbmJWXZGBx2nymjrk25aRbpRNvBV03466+mOQ74TXHnFfIwrokBL4qxWIR/1B7J4m3ilH1HGclJjahSQBe8s07ycAM1+/Ha+zsV0WFSVj0tQ/0NzXX7oizKg2Hl1MYhwkqi2qAO972Ypa0utUCbcTi5feWL7ioFnzmd6qsLbGaC48lrmINyoiD8CWIo04kn22kHOayUAi2A0tFzhQawKW0scQYGDCVh030A9LQ2a1YNOeCW6UWA5TwZK1ls18xlXhlmf+6BCVPXFtdcOq0JsF7DtmbTnFqJX2L16SzZZs6s/2MgPQn27g9aq4x56QpqBC1YURGP9+O7OG0VtVfVz+IY2qaPwAcB3/tUXym5t8ocqJGOhavCZiDBbLM9OnDXKkZN6yGNQNJwdtjuQ4mYjUvfVXALifEX1liaEQ/ztmEi90g2iwMSKmi+qgGBSM+8SbMcWaDmQXW44oomLKkFckI1Tjn+LMpkbK4mhQJQpaCqu8f0LUqqjrZ0RtlemxSTWRJKlOlCgD4g79uLrrfGoP/OhpgYf5tBTPR3aHzt1luG6Qt2g2Ic6nwTyo1MztIel2XRbtiGOBAoh/dIF2PtLvzKYDwfd9Q2L7tvzorw9ml58nYS/geF5Ckzzog7//lJDc/1rUb1TgkSopSMBG+HHGrUrQRXqWKPad81jg+byjaLbgtaYcE9bMm0E8cl6B8mCjKLIZ0rbATkWoh49UOabFJi0G+pPczdAEhtJuoKXIHwLkW80Z+xERh
 al15x4TD
 lr82ukeXWRvrAseIz8gMzCwn5Gmj09fxKW80Mrw3DdhecpLegC9HIXvKQB8at/cNXVSgM9epNrPzI8DdU0qDepE2H6hoFR4z7oVcZ4N1vRbm9o8OsJU7ZbRxtYK6TsnluGa5n6qjisARn961kFAH4scfunPFD/6JbuFvxeBSI9TUe435fUHG5wnrznDmyrjvjEkH13Ph0wuwL7jK3ttesL7OfGw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23/10/2025 21:36, David Hildenbrand wrote:
> On 15.10.25 10:27, Kevin Brodsky wrote:
>> [...]
>>
>> diff --git a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
>> b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
>> index 146287d9580f..7704dbe8e88d 100644
>> --- a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
>> +++ b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
>> @@ -41,6 +41,16 @@ static inline void arch_enter_lazy_mmu_mode(void)
>>       batch->active = 1;
>>   }
>>   +static inline void arch_flush_lazy_mmu_mode(void)
>> +{
>> +    struct ppc64_tlb_batch *batch;
>> +
>> +    batch = this_cpu_ptr(&ppc64_tlb_batch);
>
> The downside is the double this_cpu_ptr() now on the
> arch_leave_lazy_mmu_mode() path.

This is only temporary, patch 9 removes it from arch_enter(). I don't
think having a redundant this_cpu_ptr() for a few commits is really a
concern?

Same idea for patch 4/10.

- Kevin

