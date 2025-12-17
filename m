Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E58AD6552C
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 10:01:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70CDF6B0098; Wed, 17 Dec 2025 05:01:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E4C96B0099; Wed, 17 Dec 2025 05:01:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F1016B009B; Wed, 17 Dec 2025 05:01:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DD7F6B0098
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 05:01:42 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 02548BBB41
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 10:01:41 +0000 (UTC)
X-FDA: 84228521244.20.2887602
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3C1FA40008
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 10:01:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765965700; a=rsa-sha256;
	cv=none;
	b=tWxWXecUpmnB4hMdH2uZBfL8oc5GYBIkFl58BkqM5TFtknS9ZkXXgXLq4coho+HcH45mX9
	F3IWHmIPl7HtMhE1Sr7XHmLykqOWIQLdUZ89bHGVgUf67/eCOzmrIKWbmGy7yllu95La9f
	rBjfEA0c0tYLzJZzTMDbvk0lcYcdBB8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765965700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7x4f8BY8GynScz5iUPqtBGCKWxEIeZZAw/o0QRcMsU8=;
	b=MCnVZJy6j78LAwUtXO2ILLuVigFK4++GJLrQ7ZgYeQE8aqbvxdLtPO1hiEdwAaSuoPSmuS
	bn0bjgUlA0vkav93XpZu7mF0PBqwSVsPX5k/2+mPagW95Nbd2ZYOkp7XCjRP7ujjkmIm8O
	HshGVkTTp6mJD6jdRDJmN2x1fW1taUw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 326E314BF;
	Wed, 17 Dec 2025 02:01:32 -0800 (PST)
Received: from [10.57.91.77] (unknown [10.57.91.77])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B4ADE3F73B;
	Wed, 17 Dec 2025 02:01:32 -0800 (PST)
Message-ID: <ca0da7fd-245c-4d52-8f4d-f8fce4717494@arm.com>
Date: Wed, 17 Dec 2025 10:01:30 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 14/14] mm: Add basic tests for lazy_mmu
Content-Language: en-GB
To: Kevin Brodsky <kevin.brodsky@arm.com>,
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
 Peter Zijlstra <peterz@infradead.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251215150323.2218608-1-kevin.brodsky@arm.com>
 <20251215150323.2218608-15-kevin.brodsky@arm.com>
 <20251216201403.4647a4f9861d3122ee9e90d7@linux-foundation.org>
 <f9550d22-8810-4145-aaa8-48961f6ea35e@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <f9550d22-8810-4145-aaa8-48961f6ea35e@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3C1FA40008
X-Rspamd-Server: rspam03
X-Stat-Signature: gy8nrrbkjam61o7pgc49dk5jm68puunj
X-Rspam-User: 
X-HE-Tag: 1765965700-721332
X-HE-Meta: U2FsdGVkX19HKvF6vv3UmvyALmeP3+U1zat6U2XagZBqjIT/rKQ49IuCIlfZ8uXUlen4k/0DezIc7+qdqZygENtVhp4ndaKuZSpT/IJtzwphjAiQEZ3fd9/3I4UcKiExpRUN4bdFuQ9u/6wxIUmiBM+tCssFOE3hiKoxjJslBhXMKSvT04DL8eC4S0v79mhSpFiDxNshdBVLo5TyiqaNKSwLIZ7qMkhr22aefexMxXbnBzWzUEm5xDu33uSfizHoWJ7slww7J9NihbYKyA83HPzNIrX7OjDGpCTc96Ft2av98EtJBkv83fBy0bYPyxHwJv1Pez+ruUHj+N8ZA7EaCdNhjNpy565VbWnTdixX595j497NvZQ4eug0lDB86+RR9QsIIpkdEGhm0rDGtAP4rjtTpPKZNkXv1iNqdLnyjI68ix29O+w8u04OeGQ9UdXmaKnYYv0wTZky+adWyD+IpVTkjDAzNh4gNPCk4ya8RyI0QW4G/gFxwCH22dhrBNxwoorth96rPhbfPyNjWb1jeuOm5UfJyG04AaK8F2tkZJyDxF6L958CVvMD5I68lDKd6WWVSMkDBWJMkbKilyFB4wv0HqkAKYNHKIhGr2OGy++Ncr5RgxbMTcLNEUdB+ko+sf+JNJ2WyUWSOg1sjTkLuln/+PD4K0T6cQAEEx01DlKFXa/S88jl4PTN4Ub5PsRE2s8efk5qW4/x+QAg3QitUSZvZgeQjqfjBpxQfYWt7F/vRpKkzeiNgNZFZchWDbLM28mwVomhSOurv5N6Mvd8C7EgsvfXlnmBxo+SVcg7pPj6Gyx4GUiIu3IrqkksyyqAlj75r/GvWf1QrzA9BLKz2397S921HHa+2s1dgDd98pk6Quh+kJeNqbQOZe05VQ5G/o2XU2bJyzUOeMuNHqMMjfhxZRmW2CHlVVM+hWu2UgtlHKits68uo2YkHNZSK2Zyqvmdy+lWmwC4kcYQM6Q
 hYSSL2e8
 YhrHIb1fa2QlV82xijM25Obp63vj7p5aJHQOq+gCsRPVmFsAiiTwgfUHeR7N4/2OJYeV/5LgS7EPtuVn+0OWGgMfZLPaJmcZQKc6P/An1PRhLL0afNKt57BfD8RsMhhz/rMJdq8KTqZV2bbUJDr8nDMGJ6PEPp84IGL9zdclPW2pUm/BN3UkFk35i7EZh2+lQoTsI/qNmyMr84Rac9eiJ8chLzEsiTLIBQp3ypAkQTmgCNfw3pDdy9WxIzjk4uiUF2rYgKYLTlFgnkDHM8NewFJ0RKTBzym8Dm8WIw/03Z70t8lhI/xvaxnJrDEbsWCOD1oS4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/12/2025 09:26, Kevin Brodsky wrote:
> On 17/12/2025 05:14, Andrew Morton wrote:
>> On Mon, 15 Dec 2025 15:03:23 +0000 Kevin Brodsky <kevin.brodsky@arm.com> wrote:
>>
>>> Add basic KUnit tests for the generic aspects of the lazy MMU mode:
>>> ensure that it appears active when it should, depending on how
>>> enable/disable and pause/resume pairs are nested.
>> I needed this for powerpc allmodconfig;
>>
>> --- a/arch/powerpc/mm/book3s64/hash_tlb.c~mm-add-basic-tests-for-lazy_mmu-fix
>> +++ a/arch/powerpc/mm/book3s64/hash_tlb.c
>> @@ -30,6 +30,7 @@
>>  #include <trace/events/thp.h>
>>  
>>  DEFINE_PER_CPU(struct ppc64_tlb_batch, ppc64_tlb_batch);
>> +EXPORT_SYMBOL_GPL(ppc64_tlb_batch);
>>  
>>  /*
>>   * A linux PTE was changed and the corresponding hash table entry
>> @@ -154,6 +155,7 @@ void __flush_tlb_pending(struct ppc64_tl
>>  		flush_hash_range(i, local);
>>  	batch->index = 0;
>>  }
>> +EXPORT_SYMBOL_GPL(__flush_tlb_pending);
>>  
>>  void hash__tlb_flush(struct mmu_gather *tlb)
>>  {
>> _
> 
> Oh indeed I hadn't considered that arch_{enter,leave}_lazy_mmu_mode()
> refer to those symbols on powerpc... Maybe a bit overkill to export
> those just for a test module, but I'm not sure there's a good
> alternative. Forcing LAZY_MMU_MODE_KUNIT_TEST=y is ugly as it would also
> force KUNIT=y. Alternatively we could depend on !PPC, not pretty either.

Does EXPORT_SYMBOL_IF_KUNIT() help?

> 
> - Kevin


