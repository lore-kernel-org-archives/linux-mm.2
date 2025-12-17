Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA678D65C77
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 16:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1C3D6B0005; Wed, 17 Dec 2025 11:10:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFD2C6B0089; Wed, 17 Dec 2025 11:10:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B26586B008A; Wed, 17 Dec 2025 11:10:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A00616B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:10:55 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54CD8BCEC6
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 16:10:55 +0000 (UTC)
X-FDA: 84229451670.03.D4F7AB7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 96DB140004
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 16:10:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765987853; a=rsa-sha256;
	cv=none;
	b=FkC46aAck88AiBHjQISD7L+QgmGm09MdPEwdcN7iSWprlLIvUEtXC9M/qOUw9S7f51Dna6
	tKqmlfq6i/OGQIJJtFVZj69tdKwWfufXcD623u8Xh8OdhESHsRzqzZqbCquzHu67PvrRIE
	G/OfSo3PCcYfvAB6e64bD1pXeTqZGAA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765987853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FNCYahkh/fcmBqFzNzZ6qSdYyO44Ef+U9jbV1jmR+8Y=;
	b=M8OqPFeaXh3aqUQb2ClVqrw4/U3z7gydTnr6o4CtypYb4VhK9eXeGl6cOi5S+a2Q87mSH2
	vpR98JqB08z4XQIMmJwP0qZeYcU4YxU0xNUpXhjOjhC1kfafLEY3NBS2R0mfEgk3ipCL7/
	rLkN6HxiV5+pqzbL3qesxKMWwtXBiCc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 70ACCFEC;
	Wed, 17 Dec 2025 08:10:45 -0800 (PST)
Received: from [10.57.47.3] (unknown [10.57.47.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E837B3F5CA;
	Wed, 17 Dec 2025 08:10:44 -0800 (PST)
Message-ID: <799bdcb5-cb18-4b7a-b33f-bea1553f3650@arm.com>
Date: Wed, 17 Dec 2025 17:10:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 14/14] mm: Add basic tests for lazy_mmu
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
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
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251215150323.2218608-1-kevin.brodsky@arm.com>
 <20251215150323.2218608-15-kevin.brodsky@arm.com>
 <20251216201403.4647a4f9861d3122ee9e90d7@linux-foundation.org>
 <f9550d22-8810-4145-aaa8-48961f6ea35e@arm.com>
 <ca0da7fd-245c-4d52-8f4d-f8fce4717494@arm.com>
 <87a4zhkt6h.ritesh.list@gmail.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <87a4zhkt6h.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 96DB140004
X-Rspamd-Server: rspam03
X-Stat-Signature: 4gcdnuqwfq56t4zyjfp3oxo8ehpqtix1
X-Rspam-User: 
X-HE-Tag: 1765987853-405374
X-HE-Meta: U2FsdGVkX1/w+0YiTMoc9NeehLZ/v9j2wiWymC7xndp7FQuSvY67TX47hGWp/hnTl1ek8Rf3FK1FymbG8MjLtfBN1pvyyULQ9VjhkH+wkVY2wHllewh6pFXNQsCSfFztDwIl3uyReo24uiFp8HXfSSUkvBLRfGWGO7thIzw3bCRnx4OEMLq/nqT61CGV/rPD0clv73NpcaTJATbel32AIkbihKsXzqF696k41sHRbskx322m5Ftti2Sn7aN0i8VCzg9JF/drBRGyiW2m2DH6BRn3uKuF63+D7HXlwyFNczrXA1e+rYPWsF83/luZhd1uzRQCzgzCZcELdMtZLrPCWepwDyGtcxsftmq60vxchnybudbNizM2oqRTYQQWfIqOvefjHcpCcUZj94W+LntrqTxRm0YOvjxgQeY3ulF63yQDuIJQNJmYCwqYd0NdkUMI2bNpW1FCrQIJYiPki/9CFIfKv4VxIg5Rb7G8o4EFygaq9elHAnr81HHPgJ1BzSFGTl8jOLVgo1mQNBO/bz7ISdqcqStUQ8tawMm0RfxsB03x5jMTw2i7cIMy6UgBqHyMWal0FKicuBWRWs3DFwlTElWy5v6MI4WBpMhJ2uJBIJjheb7JfcIDD7gUiJie20UQov5OHTgwmAJAyjMNDHgQXL88fB20/EWAByPs1C7zdzGwbOMOsd1beEBbv49BSI+eLjdOfGoDsltEqjmoQwrva5sOsAQ9gfBKfmMYwutVFGJRmCtT5AXwuYpkHI22Yi70yXcmVDZs1YCI2FfHgiGoBuAQgCYGVCQqTUpVt3OSQy+Z+iY95h/KyIUgaGUVKH40kyFTRAxWEpIBqLAMPejo0vGde0lXrYX/TzTXfh10fW4RZlMZpH4EaMcQlePtHP4U0Klma+agtoeE/POjRF0Wj7sp+ndjz4IMW8V8WBPrHGWPpaBSVLOmEqHb+fY+MOomUN5tOjU9JSB7j4vQd9b
 iQC3Q3wq
 8C3ogpe4OaM9W5MhzrLBDF1xjLXbMTjWk9y1Gwqi/V1PVQqgLWebfXZorWiGGVUb0swv7dCl4t2p4Tuo/tzjURZasjVDaCNuuYzxH08terGfIGbquOtWzbrU665edarb/mB9NKE9TkLYOf7PO36/KXsZtxeL/v/3kPQd2jschOLTjQ87unDTGg9OkTPCFT0gcLrjf193pzMe0Ksi2HjV9SRKzHzNow21X5iq5Bc2Oy5Ex0Nasi6aetyaCeMTBykX2+BbbncS7bFMSljBFXpRpD5SER0GPDkcI92kH3FofZ2MfpjHptSXR/uw/026yTAtF0IkEvH5ZDbF3SjZZTq1jZMAHPoBO2nbqpNyNJ75AioFnphM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/12/2025 16:46, Ritesh Harjani (IBM) wrote:
> Ryan Roberts <ryan.roberts@arm.com> writes:
>
>> On 17/12/2025 09:26, Kevin Brodsky wrote:
>>> On 17/12/2025 05:14, Andrew Morton wrote:
>>>> On Mon, 15 Dec 2025 15:03:23 +0000 Kevin Brodsky <kevin.brodsky@arm.com> wrote:
>>>>
>>>>> Add basic KUnit tests for the generic aspects of the lazy MMU mode:
>>>>> ensure that it appears active when it should, depending on how
>>>>> enable/disable and pause/resume pairs are nested.
>>>> I needed this for powerpc allmodconfig;
>>>>
>>>> --- a/arch/powerpc/mm/book3s64/hash_tlb.c~mm-add-basic-tests-for-lazy_mmu-fix
>>>> +++ a/arch/powerpc/mm/book3s64/hash_tlb.c
>>>> @@ -30,6 +30,7 @@
>>>>  #include <trace/events/thp.h>
>>>>  
>>>>  DEFINE_PER_CPU(struct ppc64_tlb_batch, ppc64_tlb_batch);
>>>> +EXPORT_SYMBOL_GPL(ppc64_tlb_batch);
>>>>  
>>>>  /*
>>>>   * A linux PTE was changed and the corresponding hash table entry
>>>> @@ -154,6 +155,7 @@ void __flush_tlb_pending(struct ppc64_tl
>>>>  		flush_hash_range(i, local);
>>>>  	batch->index = 0;
>>>>  }
>>>> +EXPORT_SYMBOL_GPL(__flush_tlb_pending);
>>>>  
>>>>  void hash__tlb_flush(struct mmu_gather *tlb)
>>>>  {
>>>> _
>>> Oh indeed I hadn't considered that arch_{enter,leave}_lazy_mmu_mode()
>>> refer to those symbols on powerpc... Maybe a bit overkill to export
>>> those just for a test module, but I'm not sure there's a good
>>> alternative. Forcing LAZY_MMU_MODE_KUNIT_TEST=y is ugly as it would also
>>> force KUNIT=y. Alternatively we could depend on !PPC, not pretty either.
>> Does EXPORT_SYMBOL_IF_KUNIT() help?
>>
> yes, that make sense. Thanks for the suggestion!
> I guess we will need a diff like this in that case -
>
>
> diff --git a/arch/powerpc/mm/book3s64/hash_tlb.c b/arch/powerpc/mm/book3s64/hash_tlb.c
> index fbdeb8981ae7..ec2941cec815 100644
> --- a/arch/powerpc/mm/book3s64/hash_tlb.c
> +++ b/arch/powerpc/mm/book3s64/hash_tlb.c
> @@ -25,11 +25,12 @@
>  #include <asm/tlb.h>
>  #include <asm/bug.h>
>  #include <asm/pte-walk.h>
> -
> +#include <kunit/visibility.h>
>  
>  #include <trace/events/thp.h>
>  
>  DEFINE_PER_CPU(struct ppc64_tlb_batch, ppc64_tlb_batch);
> +EXPORT_SYMBOL_IF_KUNIT(ppc64_tlb_batch);
>  
>  /*
>   * A linux PTE was changed and the corresponding hash table entry
> @@ -154,6 +155,7 @@ void __flush_tlb_pending(struct ppc64_tlb_batch *batch)
>                 flush_hash_range(i, local);
>         batch->index = 0;
>  }
> +EXPORT_SYMBOL_IF_KUNIT(__flush_tlb_pending);
>  
>  void hash__tlb_flush(struct mmu_gather *tlb)
>  {
> diff --git a/mm/tests/lazy_mmu_mode_kunit.c b/mm/tests/lazy_mmu_mode_kunit.c
> index 2720eb995714..340d7cda9096 100644
> --- a/mm/tests/lazy_mmu_mode_kunit.c
> +++ b/mm/tests/lazy_mmu_mode_kunit.c
> @@ -69,3 +69,4 @@ kunit_test_suite(lazy_mmu_mode_test_suite);
>  
>  MODULE_DESCRIPTION("Tests for the lazy MMU mode");
>  MODULE_LICENSE("GPL");
> +MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");

Indeed, that's pretty much what I was about to send :)

- Kevin

