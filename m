Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E28CBD65C70
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 15:37:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52F986B008A; Wed, 17 Dec 2025 10:37:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C2E96B008C; Wed, 17 Dec 2025 10:37:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EFB36B0092; Wed, 17 Dec 2025 10:37:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2AEEF6B008A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 10:37:45 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CBB8B60C19
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 15:37:44 +0000 (UTC)
X-FDA: 84229368048.03.4FF8AE7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id DCC6340016
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 15:37:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765985863; a=rsa-sha256;
	cv=none;
	b=BCIbYhDPEymZbnrSLKamOL7iByrUXYH1WCOqXCLf2bC1oLLdRa4S0gz+ZLRozuazusYHB8
	7Wvxeo2R4jB25pUj1IqKc/l7VGJq6qVdmxQOKH+lYGrolp0S6cQjJRlK6dgxOfDncsv2SS
	2Pg+SQ4glrrF34SDQqwXS1bTdpFg70s=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765985863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FNXnygxVGZlNSda/Xzng+nXL6FF3ilHKktsZ5KooddY=;
	b=cW/tNEXGDrsw9t91/MpDEM41lm5cPrPwo7fbBpiAzPW7qAHTvuMdkREdvbt7JcsKDk+FgI
	38eSVpnM+cZQQBgYGv2ndV30GHwZT9A3MAwWrmAMBAir75A9uhJpdE04DNUwL2Jeud9+r/
	OW+JwwtAzP6yGguZhGyD4/sHwhplpqI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7EBF6FEC;
	Wed, 17 Dec 2025 07:37:34 -0800 (PST)
Received: from [10.57.47.3] (unknown [10.57.47.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 487443F73F;
	Wed, 17 Dec 2025 07:37:35 -0800 (PST)
Message-ID: <6afcb722-80cc-4bb2-a745-d9ad7893f0ae@arm.com>
Date: Wed, 17 Dec 2025 16:37:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 14/14] mm: Add basic tests for lazy_mmu
To: Ryan Roberts <ryan.roberts@arm.com>,
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
 <ca0da7fd-245c-4d52-8f4d-f8fce4717494@arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <ca0da7fd-245c-4d52-8f4d-f8fce4717494@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DCC6340016
X-Stat-Signature: r1zqfxtph1jbyrqiysqpwny851mo7833
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765985862-60327
X-HE-Meta: U2FsdGVkX1/g9CuRi5hCisDmuVLZvg7PI6ngKPwyDWFZj77d+FMGqLk2bi1nlKuEraqra2lELNwpKIehmHSyFAmuejESUQw9zYxBwh2T753Zh7IaWQoJvaRBkJiY8jPg/giU8sj2AWBK5lgi/Xf4+Zxwjc34hoROzxapAxJkvTNhh6lR2xItVxqwEvcTYi6pBKrc508+QGA3i1bXYz5prBmnaBxT9muiwnHMZnlS9givRifPaNKNwiV7qFW1kEYz3whvErjLCPcfRTib30V6Ihj+mx4uE7Vk01NZl4+T/UCIo/bRZk+U/lM22YPPjwd/elAh++Ovp7Y5BeDXtC60hP/ZZntIRkVuuVe8ikm+zDp3SpKWlxuL9jU7piMOnr2jJHdLdy6Stn0P+zaBpBxj0H9aUdf0mKYWD5TENEG6zawjI74j7FEUomu941qLRSVUHOx7GtfmxQ2m4Nd4Obl1hA8UlO3a4eaApuimX08MaMcgnNuE6i7jMFD9q2NY2KTdDc0Hh8srSetiNPLbKqW4NQelNW0+RIjAAOyaBOkx08FUlc0nDeP1tX6xVf4G/RL+WJSVZfT3Tyn+ixm/7TsHfdowqI/JWrguoywbe0VEkzWqIob2RK3gmnXUmI+5+RTJ2KY6gpDo9dDygFMkPkiHHNq9i5QYOwcZtweoGRXf391hcEcYCq79LBUCQbpyAftS9TBJ5HVmjcPwzOZ0QkL5vvUrlNJBPPR80oB+nNrnVjVXjtgMnXKZI6DtSxEgb63AHbfo44Wkx6RUPRfaClkLQrK4TjJi899fXI7ZLy1xLpJIJKNrLUmITT7H5kVhGv124zWK9dGt3cieWmwjrZt3JhN8CfK34c3HTH80eYKCxqoRsf2EZt0p+GKf6Wk1KuYSIRZrDCWfccneB0qLwPuj2GrBe1ckRU6tFlI7THIYZdnAGW9nJJZj2kGNU7CLMytRzFxS8w4SzJ3ovVIBf4y
 TmZI4Gk9
 gD/RYPJX3agaWVYrohuSEkD4CTrw7tK2thbq5DilZyKR9zs+GfCOxtTFzgs5UoAR+YEo0LHuSxwAyPa0tLn6QSzBA5hzkcQ0hmFCAL/AR7jhfTLxU9qltGS8pk/kUd7SZ3wfuP6zjl+NalZe4qMRA122+OEBxu0QbHPhafB5EwHW9twhsg5/pmyHmjNJ8xj/AmmAtgb8pSQ5InGyhQoz9FmB4XwuQT4aNnd2xova1tjwKd6IqYQERyflO56z6cVMeA5gZpC9w/nrNmTS2dPrHY9B7E2J5ADfPjDrmy6sG+TX/eEREhOzLE7nLg3yuhwdbIFa1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/12/2025 11:01, Ryan Roberts wrote:
> On 17/12/2025 09:26, Kevin Brodsky wrote:
>> On 17/12/2025 05:14, Andrew Morton wrote:
>>> On Mon, 15 Dec 2025 15:03:23 +0000 Kevin Brodsky <kevin.brodsky@arm.com> wrote:
>>>
>>>> Add basic KUnit tests for the generic aspects of the lazy MMU mode:
>>>> ensure that it appears active when it should, depending on how
>>>> enable/disable and pause/resume pairs are nested.
>>> I needed this for powerpc allmodconfig;
>>>
>>> --- a/arch/powerpc/mm/book3s64/hash_tlb.c~mm-add-basic-tests-for-lazy_mmu-fix
>>> +++ a/arch/powerpc/mm/book3s64/hash_tlb.c
>>> @@ -30,6 +30,7 @@
>>>  #include <trace/events/thp.h>
>>>  
>>>  DEFINE_PER_CPU(struct ppc64_tlb_batch, ppc64_tlb_batch);
>>> +EXPORT_SYMBOL_GPL(ppc64_tlb_batch);
>>>  
>>>  /*
>>>   * A linux PTE was changed and the corresponding hash table entry
>>> @@ -154,6 +155,7 @@ void __flush_tlb_pending(struct ppc64_tl
>>>  		flush_hash_range(i, local);
>>>  	batch->index = 0;
>>>  }
>>> +EXPORT_SYMBOL_GPL(__flush_tlb_pending);
>>>  
>>>  void hash__tlb_flush(struct mmu_gather *tlb)
>>>  {
>>> _
>> Oh indeed I hadn't considered that arch_{enter,leave}_lazy_mmu_mode()
>> refer to those symbols on powerpc... Maybe a bit overkill to export
>> those just for a test module, but I'm not sure there's a good
>> alternative. Forcing LAZY_MMU_MODE_KUNIT_TEST=y is ugly as it would also
>> force KUNIT=y. Alternatively we could depend on !PPC, not pretty either.
> Does EXPORT_SYMBOL_IF_KUNIT() help?

It most certainly would, I didn't know about that one, thanks!

- Kevin

