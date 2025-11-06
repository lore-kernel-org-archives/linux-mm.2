Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A928CCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 10:33:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6F208E000C; Thu,  6 Nov 2025 05:33:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D452E8E0002; Thu,  6 Nov 2025 05:33:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C34538E000C; Thu,  6 Nov 2025 05:33:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B235F8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 05:33:36 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7D600BA87C
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:33:36 +0000 (UTC)
X-FDA: 84079820832.12.1224302
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id B02A81C0005
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:33:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762425214; a=rsa-sha256;
	cv=none;
	b=W29y9FS5Ut/IHJfboXJhzBuXNYtAURIcyIsztCg78Y+olyBhJGPOxcZC5xA5psdsfkUmqQ
	S0XNTeuqIT7W8ubb6Xeq4CquZsUKVACPcyO1DEqwCkGht4DG7x+ZQcmJSqbTQfSmK9frSl
	av4VIJAnwIobqZcksra/BsDdCeBiIOU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762425214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fkZnWIFMTgMlEtlbQgLD0HsGvOLtVXBjP58onLTqVkg=;
	b=vWxGiXF2EJ96KvYkyrBj1yazh5gKeUbAu1YzTgo15L5Cn+ng3QpGHiUqLLPAfcNXmP8ScX
	eBB5fXa5hEWO3zYY+mDTcF0jRnbd/xjHZG4OFNp7MIodSvJmXrgcN5LzcP9fUbY0OYYNDw
	tD9zZvc4S1CJ60PGhbW492avZ7SUdLA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 260141596;
	Thu,  6 Nov 2025 02:33:26 -0800 (PST)
Received: from [10.1.34.75] (unknown [10.1.34.75])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9451F3F66E;
	Thu,  6 Nov 2025 02:33:26 -0800 (PST)
Message-ID: <1ac5be9f-fc05-463f-9512-74922acf8980@arm.com>
Date: Thu, 6 Nov 2025 10:33:24 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/12] mm: introduce CONFIG_ARCH_HAS_LAZY_MMU_MODE
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-6-kevin.brodsky@arm.com>
 <87o6ph3xdq.ritesh.list@gmail.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <87o6ph3xdq.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B02A81C0005
X-Stat-Signature: sd3wheykrsnghneymfz8zupj5g3ezfk8
X-Rspam-User: 
X-HE-Tag: 1762425214-68483
X-HE-Meta: U2FsdGVkX19Fd1BuKo0Z+SRC+dOSC2buVDtPOfUqmHpKrEsxQr+pSu4zC3M9ehIXNlWtB/zWwrJG3gcKgztmxSnPehaOODSNrt9XJWukmJLPCHnfV7YqsL4bvonQWA6mKFQJKYK//GEbwEJaKkXNSVS0kjhQCbTl2pVJ+p53e+pUSjNEYY4nZDxZrk+RZsdmRzLbdppfsySA1emgqJfmhTJtMto6/Z6DkjpgOTB93AxRrODc2cmlPdco1sZX7IcXSy2/dQwfXBvCkzWvOg+2o+5EIcNrrSTc8uUtMa4SUPU3PxCyyuYV8Fue9bf3HRq7FtXcOaKUlZArWuc7llgRiafaafLaaYdkAT8HSq/SsEF2hGz82EM+5b+gLvgSbqT77B2egYvOuTK2g2FUwRBFp8f+ooXUEZSx1fHZmI/7ftINxzEv3Yuc+99uxE4yHgGBCTrSKs5uL55U8fXw58NPq7QsI3AY3hbo774PJuB25ATk7D+M02aOF9E3ljRLbkcslA6SfU/gnVNABLAwG0UbwBpqh8+grAw51fAuh2AMY1xmLF6KlYXRTUiKl/1Iq/jhx76BreiFbHp4hT/lPStndvpQpH98aoZtnI1LJXqraSWhPhok6LRenmX3R7m3h8ccj3BkYW9q/o2iy7ETDmMTbPzWhhjbLcutedljWLz+Bq9B1HnMJBYYPpP/59AUNnxpce6OhmoMLK+/1K3XcIPidK8oOc5B7MsbB6DP4kAdQaxUfxQYa31421LO+ocOb+gdkNQfyv0D33B52zDa/53P9GrKnuhMCtrmmeePp9YOdyJr7JMblnQeBnsABiflkO9CidmCuT8O+mZ9bDcLX+hx7L6OTcocM7Q+rvzJ0p4vrLenxFduTbHTyxcdYZVce80F74FOJf6EagbYt5KDvum4HmfNSVkOD9NKjjwLrJDZiOrtQR57jeLarQmjnj8vK+LaeZH1jTxoMisqzztSz8q
 OUlpxxP6
 VKqoMG3c8zGFbf3kyOTHLoMQZPG1nB5y5FwKaQLomW39u8y3lDIniSZLc5KeKYDpSFgfyl01rsVWLKgN20kx7kZNYI/Wo1aWQ8ca+1cGFQZH1x2bOIN/E/QFR8bFkHecUDxYBQYUaZ0rkG8uQJajvL1ZNwpZeMa6cXFuzfziG0jHJ7GP8GeJq4y7RSIl2+tPsrIg/Ne8sFVBL027/8J7RX5EMKtGQ2ZVlC6akSptSNw0/2qya9XQN3TvZH4nSxRnyjHIOKpn3u948FJ64pkpE131W4NCclzwtvN4ZRn2GAZ96/zV+2LgzYvL2FfManlKtV/Y0BmGu9o7P71ZOL9QysQinyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/11/2025 04:40, Ritesh Harjani (IBM) wrote:
> Kevin Brodsky <kevin.brodsky@arm.com> writes:
>
>> Architectures currently opt in for implementing lazy_mmu helpers by
>> defining __HAVE_ARCH_ENTER_LAZY_MMU_MODE.
>>
>> In preparation for introducing a generic lazy_mmu layer that will
>> require storage in task_struct, let's switch to a cleaner approach:
>> instead of defining a macro, select a CONFIG option.
>>
>> This patch introduces CONFIG_ARCH_HAS_LAZY_MMU_MODE and has each
>> arch select it when it implements lazy_mmu helpers.
>> __HAVE_ARCH_ENTER_LAZY_MMU_MODE is removed and <linux/pgtable.h>
>> relies on the new CONFIG instead.
>>
>> On x86, lazy_mmu helpers are only implemented if PARAVIRT_XXL is
>> selected. This creates some complications in arch/x86/boot/, because
>> a few files manually undefine PARAVIRT* options. As a result
>> <asm/paravirt.h> does not define the lazy_mmu helpers, but this
>> breaks the build as <linux/pgtable.h> only defines them if
>> !CONFIG_ARCH_HAS_LAZY_MMU_MODE. There does not seem to be a clean
>> way out of this - let's just undefine that new CONFIG too.
>>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>>  arch/arm64/Kconfig                                 | 1 +
>>  arch/arm64/include/asm/pgtable.h                   | 1 -
>>  arch/powerpc/include/asm/book3s/64/tlbflush-hash.h | 2 --
>>  arch/powerpc/platforms/Kconfig.cputype             | 1 +
>>  arch/sparc/Kconfig                                 | 1 +
>>  arch/sparc/include/asm/tlbflush_64.h               | 2 --
>>  arch/x86/Kconfig                                   | 1 +
>>  arch/x86/boot/compressed/misc.h                    | 1 +
>>  arch/x86/boot/startup/sme.c                        | 1 +
>>  arch/x86/include/asm/paravirt.h                    | 1 -
>>  include/linux/pgtable.h                            | 2 +-
>>  mm/Kconfig                                         | 3 +++
>>  12 files changed, 10 insertions(+), 7 deletions(-)
> Maybe we can add this to ... ?
>
> Documentation/features/vm/lazy_mmu/arch-support.txt
>
> #
> # Feature name:          lazy_mmu mode
> #         Kconfig:       ARCH_HAS_LAZY_MMU_MODE
> #         description:   arch supports arch_{enter|flush|leave}_lazy_mmu_mode()
> #
>     -----------------------
>     |         arch |status|
>     -----------------------
>     |       arm64: |  ok  |
>     |     powerpc: |  ok  |
>     |       sparc: |  ok  |
>     |         x86: |  ok  |
>     -----------------------

That's an interesting idea but I'm not sure it really makes sense for
lazy MMU? AFAIU these arch-support.txt files are meant to help identify
which generic features an arch has support for. Lazy MMU isn't really a
feature though, in the sense that what it does is entirely defined by
the arch. This patch does introduce a generic layer, but ultimately it
remains a collection of arch hooks.

> As for this patch, the changes are mostly straight forward around the
> configs part. This looks good to me. Please feel free to add: 
>
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Thanks for the review!

- Kevin

