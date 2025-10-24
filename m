Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67CACCCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 12:17:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7BAB8E0087; Fri, 24 Oct 2025 08:17:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C52E48E0042; Fri, 24 Oct 2025 08:17:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B69768E0087; Fri, 24 Oct 2025 08:17:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A55C38E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:17:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3E423140E51
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:17:05 +0000 (UTC)
X-FDA: 84032907210.02.E89784C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9779040010
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:17:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761308223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cvFdvuPr794gDedSFsrccdsdKFYkvyjvhZA7QrQhBgQ=;
	b=EEBEgRexsg0iTWHzXU7alGeyvyLgqaHJ0vs07Lv8IE1tDfIvV4JeHH7WsCoJV8/iAqC0G8
	FhsBZLvWnSz0kXNRaeAGAmgr4iUiIq3GCSqU7pdtPDYqzGsP7jVAYFHRAPj1F52kdZr8YL
	97xBXq92pw6BZOT/H6JPyGSf8CG/UIY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761308223; a=rsa-sha256;
	cv=none;
	b=fTlDcK59ozjYA4+8Uc3MFTt5jdjyYkftcwxSVv62dGdff0ZrcLCp8qImmw9EJigjnw4gN2
	R5bxEpwRVut+EBauxYfkLvg0aLEqM2vW2K8ZIXxHr3Fb6854ENJ5fqEkZSCWSXyH9Riilr
	qe57KFuI5JL0CPWzHupiBvqUwZh14p8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 03DAB1D34;
	Fri, 24 Oct 2025 05:16:55 -0700 (PDT)
Received: from [10.44.160.74] (e126510-lin.lund.arm.com [10.44.160.74])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 44C443F66E;
	Fri, 24 Oct 2025 05:16:55 -0700 (PDT)
Message-ID: <451403ce-f250-44ac-8e2f-b7b27ee9f588@arm.com>
Date: Fri, 24 Oct 2025 14:16:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/13] powerpc/mm: replace batch->active with
 in_lazy_mmu_mode()
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
 <20251015082727.2395128-10-kevin.brodsky@arm.com>
 <8d5243ec-3edd-49a6-ab51-16643a709d84@redhat.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <8d5243ec-3edd-49a6-ab51-16643a709d84@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9779040010
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: z1e33xdg3b8hjiqsox7o6m7s1mfakefr
X-HE-Tag: 1761308223-391492
X-HE-Meta: U2FsdGVkX19iTzUlIt31eKf/RfXCrDr5Toy3KYOfwo5kAmt/LJKutNJ4RcXBF1Z2pFFN2lvrHKWUTLHpFnxPmvwwqoPlNv/8ksPpENUMYRyc4LEoe0y1N45vekkoStFlTWUurzIK0aZs6S1goJunheiSiUP0z9afYIli8iGtOhwBcyekOPem3mAYjJ5OFY+OD+rngzlSYm+hfKvsrZCD93Tlq73AGRasI/4oKlTaIAa8PZtfUJfalemk1xiXAvAL8xgTueITgU85GPJ45Hf4sp/NSVuqID1Oizq3JuUvOj2m1+kwQQVywRDY0WzGCid8dkISAY7QxCSgAnMmhdJfTdGX6x/hbph7IJRPS2lvjOnqvyFIuvVKVjCFkKIoZgEoJHRVGcgUkuTj7fNxTdgXyzOyIMpftCQZZkozAVOpCsHse32XBoTLpoGmdeCGXTsOtIzfIzTv5AlR6kqUMcnfHL8voHQ7yPqzon1RQX7o2IeZe5C0Ad0LHugrTrbpzanJDaJb/dg6HmG1+ekP0LqK2IZA+FfYHv74NWmfbRjeYpn0BgT/PXFm6m00Gzyg+hloPuFRw/d9VbKvCQhrkqQnwAot3ukG264gVefBjmHZj7Aya20BOOvbVjR2xJWSMFOyC2Ng8CW/Q7qrhuvrTSv7+6B2jCQsnHesQ9ogUvTwZ/dA8vWn8ATtBVR3phBu5Hn7v22R8QH6L4DvLsO8Ej3X99kcPL0BykV0N3EiVB0GkiigdxfP7byLMgLbMDcQ4pTxx/DdxwbYueum7hJnIZQIdQ7XpCR9GnCHP6l8u/YFcl7mwDgH3fq8yXjJiq8MmTbKralCn/O/C1JTuVVBl69Tcw0gRrqQkRmu4OyoKV7J/cJmJxaWM1ktYJOEgQbON2nxffsnRcPcB78/j8HA1c4fghwliTkEkvEvjaAiqV6FxNECvs1veRtFfGvmwmXopjb7hv1Hq9arZNm4LTVUbos
 hc5W9+JU
 8dKN8Hvx3N+e61nvHl0YQXjyDW0FROrM7Sev1rBBbFu6bvbSzn0LCYbZlLOvOJfP/qsoQal3hth5VJM6wDkHMMjFKaA+vG7RmkiEV7EVTSQ6eh3pL7lGQaKjQmECP8nlZbr0q2LGu2b0wj1GBE2W5kc9OQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23/10/2025 22:02, David Hildenbrand wrote:
> On 15.10.25 10:27, Kevin Brodsky wrote:
>> The generic lazy_mmu layer now tracks whether a task is in lazy MMU
>> mode. As a result we no longer need to track whether the per-CPU TLB
>> batch struct is active - we know it is if in_lazy_mmu_mode() returns
>> true.
>
> It's worth adding that disabling preemption while enabled makes sure
> that we cannot reschedule while in lazy MMU mode, so when the per-CPU
> TLB batch structure is active.

Yes good point, otherwise this change doesn't make sense. I'll add that.

- Kevin

