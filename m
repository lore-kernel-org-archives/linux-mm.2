Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C736CCD185
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 02:23:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DECE8E009E; Wed, 15 Oct 2025 22:23:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B5C38E0008; Wed, 15 Oct 2025 22:23:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F29D8E009E; Wed, 15 Oct 2025 22:23:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2AD928E0008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 22:23:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2AD4C0192
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 02:23:06 +0000 (UTC)
X-FDA: 84002379972.29.CECC9A4
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9904C4000E
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 02:23:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WnnVfRxP;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760581384; a=rsa-sha256;
	cv=none;
	b=FSZ+cIu3rd9Hlh/OPQET1t3bGA42HWBJ2A7Y+FBzejYh0pEmIhVGh7oS982ibVD9WH7mBL
	Ri2DT85VawUwJnRvPM24Y2cOuPhkD4edganPmUl/3nbLZ3zHtdFcfbnXGeV5vxSExENUZ0
	lAX34xDFq5YmPP8KzL+mURBj71Vpzuk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WnnVfRxP;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760581384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2iGb4w2CJ/xWobbduV7z9pfLjGzjU59oSShpLUnHZK0=;
	b=ud4/VMClOSzjXgM6IHYm3vZZRSk2l8Fx5L1c+quLZCiGu+LXncnk0vufybpalNKRmrJfNm
	ruhkxJ4ZpZygWXR88i/SFvKlZTKw9uoVqU6OWX0y5JOt6Vd86tmA/+vpwl5GCaRb73DzWH
	sUrBp4OoP9oU0fzH3N9eroBJ0x/9T3Q=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760581380; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=2iGb4w2CJ/xWobbduV7z9pfLjGzjU59oSShpLUnHZK0=;
	b=WnnVfRxPiTyzLzjSPcsypZI0pLFF0CRHxbgwE2EgmTELXfjYe1tgpVLpJa9DP9TZ1YaAvVjDR+S1z3MPbWzUDdGPf4AHRHgRdndjgiOZ4UzZHytt4yyFkjp16XNONH00ASQ7R6rE9HEah2KPiQvyegAQrQ6STQ9jbpOSNuO5gCg=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WqId6gu_1760581378 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 16 Oct 2025 10:22:59 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>,  Catalin Marinas
 <catalin.marinas@arm.com>,  Will Deacon <will@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Vlastimil Babka <vbabka@suse.cz>,  Zi Yan
 <ziy@nvidia.com>,  Baolin Wang <baolin.wang@linux.alibaba.com>,  Ryan
 Roberts <ryan.roberts@arm.com>,  Yang Shi <yang@os.amperecomputing.com>,
  "Christoph Lameter (Ampere)" <cl@gentwo.org>,  Dev Jain
 <dev.jain@arm.com>,  Barry Song <baohua@kernel.org>,  Anshuman Khandual
 <anshuman.khandual@arm.com>,  Yicong Yang <yangyicong@hisilicon.com>,
  Kefeng Wang <wangkefeng.wang@huawei.com>,  Kevin Brodsky
 <kevin.brodsky@arm.com>,  Yin Fengwei <fengwei_yin@linux.alibaba.com>,
  linux-arm-kernel@lists.infradead.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH -v2 1/2] mm: add spurious fault fixing support for huge pmd
In-Reply-To: <d748bc6b-2aff-4cee-a233-008f4d2555fa@lucifer.local> (Lorenzo
	Stoakes's message of "Wed, 15 Oct 2025 12:20:30 +0100")
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
	<20251013092038.6963-2-ying.huang@linux.alibaba.com>
	<4c453dcc-2837-4f1a-905b-3462270f5e31@lucifer.local>
	<87ldlcpnbx.fsf@DESKTOP-5N7EMDA>
	<d748bc6b-2aff-4cee-a233-008f4d2555fa@lucifer.local>
Date: Thu, 16 Oct 2025 10:22:57 +0800
Message-ID: <87bjm7lh4u.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9904C4000E
X-Stat-Signature: ojgqo3c84tez575abbcoa3jdwra9obum
X-HE-Tag: 1760581383-401371
X-HE-Meta: U2FsdGVkX1+KK00xwVi8wr9VC9epgr+teXvwH8otoJn9t8ovSYr55bq5cpPhY6m+54jDiWErcg+6UlK7Mij8A7u09yAYfBVMvOR6hnIR6HNJEJ0vjZF/dDLyHpBYkE3u1peBBUFHm9TH8hr+D2FWLMnBtMdoTg2rMZwp59Hw6TTO1BT18jHtKay4xF95F3bnXC+EDPV+8d857Xl15hBXdfQndpDSUNXGY+aYEZyFYcNkm8gs+sPAIDk/i4uZdyXyXCQo34GKGFzVaZID/ZYxiktHITa4W1ePab224VYAihBr0l6FSFHhjjeuaB57Ev2pkRBkfI09jo/LEtA54Fv4zUw6uLEcili5fOLb0dL+aiOP9YqV5pryjf/Qe9N+aohJgawGkvz+svjD+pHLJK44VsQB1xS6ob4YfLuVztLsVLVib85gcPM986RVH3AE4lPJaH0oTPj7c2QdMsx4Xst9+mkwn15tHZ6awdSFuNI1Vc02y0Bcl1nmI8img2CqznUEE1Fh6WmYJSaOh8767atOAO866WHAbh/SQRiOF1/aR6zQuQcLsk0BkKDdXblejybReIxfzhnF7UuVMKo0Fq7SXraygSxqp0eA1HeA8rsKNfY8Ez0l01gsq+Dm19RHB2ce4bBm2sqBN6zq2yXXa9Si15QTh8UE7vi/yas+/73UKTcwSf5X7C5eFf3lNrkINF3Tojy+1AaG+3mc5V11oik14/qiMc2qhhKbZUYljEEDziEpTS/7DFMgpBJTq9WIRaZfTgsZIIq66HHooWYywQbPAwF9jQQ8gW8CQaMoUPBU6CKiQW0871/4TWesr4B0Crh5WFnzfNa6ueN3jgGTUDkrK5zp5PG5ufe/2RIszT5IuZhO29s8aye78wjmxlYBvU9RVupTk+ZWJ6NCTfVCTS3sJUMqj9ZEyg7+BxPlv2Rsd165Hzho8t6gVO0/2goneg35aMpQWKGhHgZ1JG63iyG
 Qb9xuC84
 l75F0+wtalhGi9ybrHXmfhLFcjqquitWaMVw9tri/x5bmjfiWbSv57SX6R9u0GuzbX1xP+VDzk07J/MZ3RC3lzVT+WCw4Mb+7lJQzL5LW9c42lqmsQuYw/d+55cdH7k3EODkWy8AS2BY5Re3i3DD/He/uZNgmijPAcGZY2c23edk9/iU13uZle51ARkW8SNPFPCAz4sfh/fb0ULHyXNiBfPvxXFjj7S+biUCm13eER8P93KTL62RIoxHlJjSmCnfSW4/3SLhDBNigK3+K5eR3XMIDu+tNthOLfqu+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lorenzo Stoakes <lorenzo.stoakes@oracle.com> writes:

> On Wed, Oct 15, 2025 at 04:43:14PM +0800, Huang, Ying wrote:
>> Hi, Lorenzo,
>>
>> Thanks for comments!
>>
>> Lorenzo Stoakes <lorenzo.stoakes@oracle.com> writes:
>>
>> > On Mon, Oct 13, 2025 at 05:20:37PM +0800, Huang Ying wrote:
>> >> In the current kernel, there is spurious fault fixing support for pte,
>> >> but not for huge pmd because no architectures need it. But in the
>> >> next patch in the series, we will change the write protection fault
>> >> handling logic on arm64, so that some stale huge pmd entries may
>> >> remain in the TLB. These entries need to be flushed via the huge pmd
>> >> spurious fault fixing mechanism.
>> >>
>> >> Signed-off-by: Huang Ying <ying.huang@linux.alibaba.com>
>> >
>> > Right now the PTE level spurious fault handling is dealt with in
>> > handle_pte_fault() when ptep_set_access_flags() returns false.
>> >
>> > Now you're updating touch_pmd() which is invoked by follow_huge_pmd() and
>> > huge_pmd_set_accessed().
>> >
>> > 1 - Why are you not adding handling to GUP?
>> >
>> > 2 - Is this the correct level of abstraction? It's really not obvious but
>> >     huge_pmd_set_accessed() is invoked by __handle_mm_fault() on a non-WP,
>> >     non-NUMA hint huge page fault where a page table entry already exists
>> >     but we are faulting anyway (e.g. non-present or read-only writable).
>> >
>> > You don't mention any of this in the commit message, which you need to do
>> > and really need to explain how spurious faults can arise, why you can only
>> > do this at the point of abstraction you do (if you are unable to put it in
>> > actual fault handing-code), and you need to add a bunch more comments to
>> > explain this.
>>
>> This patch adds the spurious PMD page fault fixing based on the spurious
>> PTE page fault fixing.  So, I assumed that the spurious page fault
>> fixing has been documented already.  But you are right, nothing prevents
>> us from improving it further.  Let's try to do that.
>
> I wouldn't make any kind of assumption like this in the kernel :) sadly our
> documentation is often incomplete.
>
>>
>> The page faults may be spurious because of the racy access to the page
>> table.  For example, a non-populated virtual page is accessed on 2 CPUs
>> simultaneously, thus the page faults are triggered on both CPUs.
>> However, it's possible that one CPU (say CPU A) cannot find the reason
>> for the page fault if the other CPU (say CPU B) has changed the page
>> table before the PTE is checked on CPU A.  Most of the time, the
>> spurious page faults can be ignored safely.  However, if the page fault
>> is for the write access, it's possible that a stale read-only TLB entry
>> exists in the local CPU and needs to be flushed on some architectures.
>> This is called the spurious page fault fixing.
>>
>> The spurious page fault fixing only makes sense during page fault
>> handling, so we don't need to do it for GUP.  In fact, I plan to avoid
>> it in all GUP paths in another followup patch.
>
> OK this is great, let's put it all in the kdoc for the new shared spurious
> faulting function! :) and additionally add it to the commit message.

Sure.  Will do it in the next version.

[snip]

>> >>
>> >> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> >> index 32e8457ad535..341622ec80e4 100644
>> >> --- a/include/linux/pgtable.h
>> >> +++ b/include/linux/pgtable.h
>> >> @@ -1232,6 +1232,10 @@ static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
>> >>  #define flush_tlb_fix_spurious_fault(vma, address, ptep) flush_tlb_page(vma, address)
>> >>  #endif
>> >>
>> >> +#ifndef flush_tlb_fix_spurious_fault_pmd
>> >> +#define flush_tlb_fix_spurious_fault_pmd(vma, address, ptep) do { } while (0)
>> >> +#endif
>> >
>> > flush_tlb_fix_spurious_fault(), when the arch doesn't declare it, defaults to
>> > flush_tlb_page() - why do we just do nothing in this case here?
>>
>> Because all architectures do nothing for the spurious PMD page fault
>> fixing until the [2/2] of this series.  Where, we make it necessary to
>> flush the local TLB for spurious PMD page fault fixing on arm64
>> architecture.
>>
>> If we follow the design of flush_tlb_fix_spurious_fault(), we need to
>> change all architecture implementation to do nothing in this patch to
>> keep the current behavior.  I don't think that it's a good idea.  Do
>> you agree?
>
> Yeah probably we should keep the same behaviour as before, which is
> obviously, prior to this series, we did nothing.
>
> I guess in the PTE case we _always_ want to flush the TLB, whereas in the
> PMD case we otherwise don't have any need to at the point at which the
> spurious flush is performed.
>
> But from your explanation above re: the stale TLB entry this _only_ needs
> to be done for architectures which might encounter this problem rather than
> needing a TLB flush in general.
>
> Given we're generalising the code and one case always flushes the TLB and
> the other doesn't maybe it's worth putting a comment in the generalised
> function mentioning this?

I'm not sure whether it's a good idea to document architecture behaviors
in the general code.  The behavior may be changed architecture by
architecture in the future.

[snip]

---
Best Regards,
Huang, Ying

