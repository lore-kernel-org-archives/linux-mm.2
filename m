Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8168CA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 07:32:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0DFE8E0009; Mon,  8 Sep 2025 03:32:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBEC28E0001; Mon,  8 Sep 2025 03:32:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DADEF8E0009; Mon,  8 Sep 2025 03:32:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CA1E38E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:32:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C44D11B19D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:32:43 +0000 (UTC)
X-FDA: 83865265806.29.33CDC8F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id B5A031C0005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:32:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757316761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5MXJVs4sRjIzs/FqbYFU50YGWM5NgmUAUp6zmg3Kby4=;
	b=ph+q/+EgsCsB5pKDU56d452Y9xI5PC3dnTHfV+T5sWSpKcj4l5CbZVV8pUysucpVWOMioO
	cYRV7WP+5Zl2PtCRYoGDJFuyHkW3BaFIzWsfMrBRM7zoYT7rUOqFjvY/F3VEshPGuyWpNl
	nREJrHrRAnBlB+Od2yZfUGFKATYyMqc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757316761; a=rsa-sha256;
	cv=none;
	b=CJ6q/HpOyFIY6W197TKOPxBXJFi9xMDnDbLuCphIgUitJbpxZpfMpP0AylSjPI0nor7oGP
	K5fql3MEw02kpEx/afzPCrb+FA0ReWo5RDDwo/IDOVmkGTGPsWi5BI2j1d6cvFwkSdEeXQ
	cBjuCR/O+vZHE10B5haSTzw9QMWEuEM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 88AA2169C;
	Mon,  8 Sep 2025 00:32:32 -0700 (PDT)
Received: from [10.57.58.69] (unknown [10.57.58.69])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CFA563F63F;
	Mon,  8 Sep 2025 00:32:34 -0700 (PDT)
Message-ID: <1f822d8b-eb46-4998-b1c1-9996d70e1958@arm.com>
Date: Mon, 8 Sep 2025 09:32:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] powerpc/mm: support nested lazy_mmu sections
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org
References: <20250904125736.3918646-1-kevin.brodsky@arm.com>
 <20250904125736.3918646-6-kevin.brodsky@arm.com>
 <074ff6ab-5868-4fde-b5bb-9e17632ad817-agordeev@linux.ibm.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <074ff6ab-5868-4fde-b5bb-9e17632ad817-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zemgoo4fe3qcyu49mp4qjwj7sntpxj16
X-Rspam-User: 
X-Rspamd-Queue-Id: B5A031C0005
X-Rspamd-Server: rspam05
X-HE-Tag: 1757316761-66410
X-HE-Meta: U2FsdGVkX1/ljm5BAjpJIbQXgVS8TOMl0Dsq54Zm9iyAzsI0Wp524WuZ5MXNl85fgG2tcrEXkqJrFGADVzDLB5cNOgnUH2ZQ1wmCKKh86i8NyQ+A20u6T6xdQrw7Ukj2DSodrU6qIvlQavnCigFDb0alrMhjfyU8B/1wdpSdHNn5sgXATlgroc1UU6al8gYOrhlcYpAzzcI0bqWyrrdbHsYRLTQw4uzJfI3ZBgrIFUfDN+/7ByCVFGCnE6gtBAWmItcMYED/5P9zySfLwZRAl+WAM0pcuEjLrUuGM41aSC6i5lPc3mwYWFbkXOOTA3nsjADi1+S9dcRkNflz2AIaxyStialMYB0Vuf7OQMNkhcDXNsDgImoPZtHJRe5crkfjkXJM6HAIAyBtEm1W0BpDYQCGkCVC1pduZUaNrMFPvMYtpSAwO2rB8FHHMBB1oxX09WaqJd3fGHhmdYwBxb9MIUoi2ngMoiC1/hehVLnhPkg4UUwO3pSvHK3B72cbb0XUmJGgN4e94QtFPfUSS/PIe5CyTMADTACsB+O01djuUw/4dOIVSDPoYFOF0R2ZhqMUVMkD92HB0FthinSvFOcLOmmo7tnsLfDT1dE2lrcnt0K33y8HPcodOB6gVGVhU7KHf8HsNVHr5vVl8iMaWHEiVIxCE42nBeAy6FQjVsSVM+1XVp91N+1+0tXOwUEmAagCUqCVaVLoz1P/Xcb4EG0+R6BXytPPTPm4G9l1ncr0PdJmUTvgfBi3FbMuKgrQCbnsGGNH9KUgaCpT5LlXINZBBnMKmTLryxGQchCp8kVj97KpI/yiUdV4m8XixANPRK4rmff31SIeawKFe7Hh6NxCo/Yb8nLH3Mq86cAg29d9uiHXLx1yG5+//6Q2zVwXfk3RPI6T1Qi5LvOTAD+ycsutG72A/OgsUOnNO/Oz9ZnlwGzByT+CXGVETNuc8keROTegJcdJ0T5pPcMOjChE5aB
 KbR5DiwE
 zyxKo1CS6nbVPCsJEieaEC6RcVUVxMxpRE2F75MXAUd0bgJQsmr/km0Ks21vcVGhcq+qfR0MabDHmtBcZPsshDE9bcM8Me2A2kiGedQm3FI+USMhFqxlVfyydM67wSvyatFbIRW3SwjzxRkSZPQ8H9rO/j2Mk981SCXRMX0EGbz/pivi73390lEe6dTrV+1YMTBNY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/09/2025 17:52, Alexander Gordeev wrote:
> On Thu, Sep 04, 2025 at 01:57:34PM +0100, Kevin Brodsky wrote:
> ...
>>  static inline lazy_mmu_state_t arch_enter_lazy_mmu_mode(void)
>>  {
>>  	struct ppc64_tlb_batch *batch;
>> +	int lazy_mmu_nested;
>>  
>>  	if (radix_enabled())
>>  		return LAZY_MMU_DEFAULT;
>> @@ -39,9 +40,14 @@ static inline lazy_mmu_state_t arch_enter_lazy_mmu_mode(void)
>>  	 */
>>  	preempt_disable();
>>  	batch = this_cpu_ptr(&ppc64_tlb_batch);
>> -	batch->active = 1;
>> +	lazy_mmu_nested = batch->active;
>>  
>> -	return LAZY_MMU_DEFAULT;
>> +	if (!lazy_mmu_nested) {
> Why not just?
>
> 	if (!batch->active) {

Very fair question! I think the extra variable made sense in an earlier
version of that patch, but now it's used only once and doesn't really
improve readability either. Will remove it in v2, also in patch 6
(basically the same code). Thanks!

- Kevin

