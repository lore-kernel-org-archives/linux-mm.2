Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9366ECAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:05:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEE508E0015; Tue,  9 Sep 2025 05:05:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC5EA8E0003; Tue,  9 Sep 2025 05:05:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E02CA8E0015; Tue,  9 Sep 2025 05:05:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CC7898E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:05:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0C82814041E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:05:56 +0000 (UTC)
X-FDA: 83869129554.14.7D281CD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id DFEDA20011
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:05:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757408755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ujoZwN7+39kxKbECl/cd7bSlB0kLqKwYgSZlv4ws8T4=;
	b=BR7SmV/b3z5DwkUN+WttYu7SB4Ok0ZnRNQn3NCbpcSaaCSFCNm8uhZJYBBELdJPee/JQr7
	bPZnsdvOThd543RZIj4UedBmb513IS40YxeBYfeFmFWTd1JEpqCzR5t2GPxcHSsaH5bEFO
	KS0gPvHE/JvUTkoaAHrV3hyjkAtjZBI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757408755; a=rsa-sha256;
	cv=none;
	b=KZBqJq6XT5ZrQZ8a1jPgUg6ieIaTMWLZ9Du4o929uhdqQmAyEbRgUm8fCngRoLpYdNOZSL
	HxS6HFb1QCZNP4DJmj9w6b/BAkWtDVnf4nZHnJ5GAW5xAgNoPByPMGoeu2JdS9IF0j7ZH6
	WNgA54OfygzxN8/+Mwj0PIwLz6MFidk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E25F015A1;
	Tue,  9 Sep 2025 02:05:44 -0700 (PDT)
Received: from [10.57.60.124] (unknown [10.57.60.124])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A7EF13F63F;
	Tue,  9 Sep 2025 02:05:39 -0700 (PDT)
Message-ID: <bd3958cc-f069-40a6-b201-7cab338e0cd9@arm.com>
Date: Tue, 9 Sep 2025 11:05:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] mm: introduce local state for lazy_mmu sections
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
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
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
 <20250908073931.4159362-3-kevin.brodsky@arm.com>
 <20250908224054.0a1969b493d8a837addd782e@linux-foundation.org>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <20250908224054.0a1969b493d8a837addd782e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fc19fjewdh8nuoxmheqkf1pd8dkwbasu
X-Rspamd-Queue-Id: DFEDA20011
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757408754-230136
X-HE-Meta: U2FsdGVkX1+eDRce6OiD1P+jXff6itKKEzbZCsYnei0FIlkyIzRMs0yD5PBYgE9M0CgwFrt4fE7Sb8FQjcZRSUIbQJrTaeAjlKP+xJ+ovlhe9wAskF9aTqng+T1NfsxoqoSzPQUhXsYO2uJgSaEf4H/7E8gLHI4lhKdYQavGwEtxBx/w8OY/em4MPnLKSmHuU78dkKoBWEcu1rCa0iJ6QCpCJn4N4YiKNcPAxawzWF8H5huobzDUbj4qs43Be1ZtxZoEYjweCn6j0acAct2hXSWdReF6EbxLSdxnYrar8OqnBXCFHlJvMdS2kuU7g9KOVPHAk+fgUng5MuKufPejCiut4vqXeWwNQXb6KvvJfQBJNqI9HDyLQDxShQ34t8910tuzN+1+cVoBEClMMESzv/iHMocSyGnn7qmIzJ0kz3iT0ClekZmx500roeKY4tJ+F4veVVxkoZIGuKlwJstQg6/8li+vh2bkk8CENd3diteB39cvtGJj2egoCOIEkioC9dyYseWQwcOG/C9scb4eZAbs2Q0736fBcYGPhT4nNEMl3PCWFsteNbEWiMzxKTh9WuDQ+aXgyNpmc4TfUP4YWc7xcIXoZJJZjE6bWSclIz4ygTdVtAjhmdmPhBgZlUQ9bUTDiDSmbB0cMY1iIZ0KwsOEXWNJDJA5FaeUx/stiyYYA3yT0k23f0jSeY/ZHGUKu0JpElpMvazHNCls565pdu6Qtz0F6QyAkaYyjVC8pAw6kFGltYiAs6RvQxdOS3w71N+dL/bafAj6q+hYB28lsjWuABOqq8g0gPEA1aqNLwEs8qAnPlss6HuvEAbvQHQlzfhlgEcAI8VrFF/0Pj81f91V8dcdOUXWnFfC8Y6khm7GamVQK/17cezP8THNIGmsHCFwdHIU0UOlXxgMqVY+MS0I8dm5QNLvaEGtWmYbF3gSSlXL8iCpDQzx5E9VkqLX5bY7FsjgDB7/UgjtI48
 mLwXP+Yj
 wrVNG8JIfL2ORtXOmU2Aa77p+ROkr3KYQOOphUksEWHkydcaFxA2fnE07uA5i4bD1S46EroZSK08yF6NbmrpWOoaNt7W8Ryfa1muycnkxs3WDFTtkczDsbVfSCgQC7J1qANvZhHs4OKf2Z+v5xgVhLRmv6krA3yu5yTbx4vqwfW1/nNX7viuHwtBc7ftcAduf4sB+YHLYAxre61pqPFSNNkce1uTfvM6Gw6tNaOv30r1a/ietl+n8qW6FK6oLh9CMCXRVzJ3v/UeAb8bTj5StyM4m2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/09/2025 07:40, Andrew Morton wrote:
> On Mon,  8 Sep 2025 08:39:26 +0100 Kevin Brodsky <kevin.brodsky@arm.com> wrote:
>
>> arch_{enter,leave}_lazy_mmu_mode() currently have a stateless API
>> (taking and returning no value). This is proving problematic in
>> situations where leave() needs to restore some context back to its
>> original state (before enter() was called). In particular, this
>> makes it difficult to support the nesting of lazy_mmu sections -
>> leave() does not know whether the matching enter() call occurred
>> while lazy_mmu was already enabled, and whether to disable it or
>> not.
>>
>> This patch gives all architectures the chance to store local state
>> while inside a lazy_mmu section by making enter() return some value,
>> storing it in a local variable, and having leave() take that value.
>> That value is typed lazy_mmu_state_t - each architecture defining
>> __HAVE_ARCH_ENTER_LAZY_MMU_MODE is free to define it as it sees fit.
>> For now we define it as int everywhere, which is sufficient to
>> support nesting.
>>
>> The diff is unfortunately rather large as all the API changes need
>> to be done atomically. Main parts:
> This has a build error:
>
>   CC      arch/x86/kernel/asm-offsets.s
> In file included from ./arch/x86/include/asm/irqflags.h:102,
>                  from ./include/linux/irqflags.h:18,
>                  from ./include/linux/spinlock.h:59,
>                  from ./include/linux/swait.h:7,
>                  from ./include/linux/completion.h:12,
>                  from ./include/linux/crypto.h:15,
>                  from arch/x86/kernel/asm-offsets.c:9:
> ./arch/x86/include/asm/paravirt.h: In function 'arch_enter_lazy_mmu_mode':
> ./arch/x86/include/asm/paravirt.h:534:16: error: 'LAZY_MMU_DEFAULT' undeclared (first use in this function)
>   534 |         return LAZY_MMU_DEFAULT;
>       |                ^~~~~~~~~~~~~~~~
> ./arch/x86/include/asm/paravirt.h:534:16: note: each undeclared identifier is re
>
> which gets fixed up later in the series.

Oh indeed good catch! I don't think there's an easy way to fix this
cleanly due to the header soup. Since it's just a temporary change, I
suggest:

diff --git a/arch/x86/include/asm/paravirt.h
b/arch/x86/include/asm/paravirt.h
index 65a0d394fba1..67b9549b4255 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -531,7 +531,7 @@ static inline lazy_mmu_state_t
arch_enter_lazy_mmu_mode(void)
 {
     PVOP_VCALL0(mmu.lazy_mode.enter);
 
-    return LAZY_MMU_DEFAULT;
+    return 0; /* LAZY_MMU_DEFAULT */
 }
 
 static inline void arch_leave_lazy_mmu_mode(lazy_mmu_state_t state)


That will generate a trivial conflict with patch 4, naturally.

Should I send a v3 with that change?

- Kevin

