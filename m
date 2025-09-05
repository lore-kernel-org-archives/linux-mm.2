Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCCA2CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 12:11:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24FF38E0006; Fri,  5 Sep 2025 08:11:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D9AF8E0001; Fri,  5 Sep 2025 08:11:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A1E18E0006; Fri,  5 Sep 2025 08:11:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E72668E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 08:11:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A1BD4140156
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 12:11:54 +0000 (UTC)
X-FDA: 83855082948.01.E8F6FE6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 83F11A0019
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 12:11:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757074313; a=rsa-sha256;
	cv=none;
	b=dyNEu037fAgj/hQ34XHL7p10kscCM03AADxRUjPer7CK4KCsLqSGgbTh/4OkBHqwAlt/LQ
	VnSweVm0kZmf1/jCehA2yA3LY/pcnrFWVsyGKXfaTOIknUz/VOwgmDGgg/bPlKskZVjMqL
	NJFW6e91cP+RuA0EYy9wvGt8F0GuSDo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757074313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AYbnAayVJ5j0xB1k23z8SMycFu9vSF8PiQYLB5iMyog=;
	b=aCnvvb342fs5ZTE3zQDQ1YM3le3VeaL28LeLWO55qrZeb1eNU1syd/kemYtnSJIGdB4/YS
	5iNLRnwYDZGnqfk6R4KDofY5HUpMLsmHLawgvHja6YC78rHmqFXl84nyb8LJewlqpA9A4k
	pnptO3iwkOsHJ8DGXHf8q5MSt1y/Yqk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F0A1B153B;
	Fri,  5 Sep 2025 05:11:42 -0700 (PDT)
Received: from [10.57.60.42] (unknown [10.57.60.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 65F093F63F;
	Fri,  5 Sep 2025 05:11:45 -0700 (PDT)
Message-ID: <66335cf3-d49d-4b27-a37b-0a8a5e2c5d78@arm.com>
Date: Fri, 5 Sep 2025 14:11:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] Nesting support for lazy MMU mode
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
 <9fd076c7-f163-4b92-8201-d8a259a338c1-agordeev@linux.ibm.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <9fd076c7-f163-4b92-8201-d8a259a338c1-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 83F11A0019
X-Stat-Signature: 8xgnd676h45cfhcboj5bxqi116hm5ano
X-Rspam-User: 
X-HE-Tag: 1757074312-163821
X-HE-Meta: U2FsdGVkX187B8KCY5dDhpcrPH90XXxeMVPttsZObfdLr020q41URNfaKaQ6yCFt46lq6JuAT5sPS5g8bZoQVvgXGPFK6utdyYqa4cGa2QbNR7j1J6ySilMZ9gWJ5MhQdSjaKp/km9AzaZZVGZaHF29keu3id7wvuOtPhh6qRhfIdNSHUR5OD/NhGT2qIbD4Tv0BlSHbELOWlikJ3l7QbQ2rt/uX3b6Kx5N/eIPu6FSSt7zQ9dtU7c37i86dggOqf5OWD1dJduhTBovNoMDIwhMg6blkUQfjp8bUyZpvTO/PYSaAXW8/Q/kQan+8SwWzqrvxD0K49wiIrrtP4HEhD6Hbcb/EGL9WX1v57ZPon9NYhYWT5UKVTbQcdNd1x0IuwMu/pkL+vTxrEmhiS3JaKOJGM13FP9s+6eMf2IxLq5edznNZElC8UcrOGfcOKbgWAqOymzDtye1B+E3FFCYvhdwMHewSSMPrzgIeGFm9HzANPRkPIa0TsBPcPBkpEye8Qb9dErrKAlguSysLjDgCIOyUqA5coDLkTGa47osc8e2pg5WFjIj++Q2CmN3T98qhuaBi63R2gJFFZkB30gj1CZWjMDEZUhjU5M8d6ip2W1LSKu9CRdwucHhm+OdJe0h95r5xyfblsR+ozQ23o/4HuXMYAg4HIEb8DoRxDoJ31q5Px4wQ5rOuQ/kWarT4vC+bQnCLRFszY1JbBGK3wisdS8ZDrz5JhRmZ93csxipSzewm+3kFHsfJDGz9s8i4HNMSvCR/pwqxmT1rznHgLxWUT4uyWxa6Etntx1I5eC2IDZe5yxFMaDVqz4fXVa8Yw8ekJtxOAG42/lysnrhvpM7BZlxxqhLC686J4TXIYhMMGpafgs5AVeZ11k7rHqvKutbl/FU50p9Tuj50Hmpm9JIF6uLeT9ABALSUCnVqcyr9VKqdr908i3a70WLS9FTul64zUQokJQhe83YV3YHFZiA
 xKxtjZfF
 41BKdWqn94waFRvO0pg4+vREil7VboYat03Gdbjisq1pk/csL+SPhHP6bhytVaoqB4ftTS9zGDgMTrLZJNxjtPRLVJBz3/Awip0fPoBEvwFO6CluUVwM612LNFTbPLviNppUU6qzH2XbnhbkpwyT/UUJsPyt3SDDuSah5oH+lwdEdljwATAn5+YuAcV02PjZ1lFn7Usj/0wqfI4XGbHOc/4VuvT4r+LFXfkEu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/09/2025 11:46, Alexander Gordeev wrote:
> On Thu, Sep 04, 2025 at 01:57:29PM +0100, Kevin Brodsky wrote:
>
> Hi Kevin,
>
>> When the lazy MMU mode was introduced eons ago, it wasn't made clear
>> whether such a sequence was legal:
>>
>> 	arch_enter_lazy_mmu_mode()
>> 	...
>> 		arch_enter_lazy_mmu_mode()
>> 		...
>> 		arch_leave_lazy_mmu_mode()
>> 	...
>> 	arch_leave_lazy_mmu_mode()
> I did not take too deep - sorry if you already answered this.
> Quick question - whether a concern Ryan expressed is addressed
> in general case?

The short answer is yes - it's good that you're asking because I failed
to clarify this in the cover letter!

> https://lore.kernel.org/all/3cad01ea-b704-4156-807e-7a83643917a8@arm.com/
>
> 	enter_lazy_mmu
> 		for_each_pte {
> 			read/modify-write pte
>
> 			alloc_page
> 				enter_lazy_mmu
> 					make page valid
> 				exit_lazy_mmu
>
> 			write_to_page
> 		}
> 	exit_lazy_mmu
>
> <quote>
> This example only works because lazy_mmu doesn't support nesting. The "make page
> valid" operation is completed by the time of the inner exit_lazy_mmu so that the
> page can be accessed in write_to_page. If nesting was supported, the inner
> exit_lazy_mmu would become a nop and write_to_page would explode.
> </quote>

Further down in the cover letter I refer to the approach Catalin
suggested [4]. This was in fact in response to this concern from Ryan.
The key point is: leave() keeps the lazy MMU mode enabled if it is
nested, but it flushes any batched state *unconditionally*, regardless
of nesting level. See patch 3-6 on the practical implementation of this;
patch 7 also spells it out in the documentation.

Hope that clarifies the situation!

- Kevin

[4] https://lore.kernel.org/all/aEhKSq0zVaUJkomX@arm.com/

