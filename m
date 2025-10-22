Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68418CCD195
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 07:32:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E1AD8E0009; Wed, 22 Oct 2025 03:32:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B91C8E0002; Wed, 22 Oct 2025 03:32:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F6D28E0009; Wed, 22 Oct 2025 03:32:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F4658E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:32:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7825248B13
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:32:06 +0000 (UTC)
X-FDA: 84024931452.08.038F2C2
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 646CD40015
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:32:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=InR5naqE;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761118324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QtY8PxEyIubqCZUk80T4fMo0woyvuu6eo6/vRZ5dv8s=;
	b=aCxNbFZE+XDO2AroTFi01KBK7A20VS6Hl27q2uTYdqSTAw8FYxp6IWdqm2n/TdxTueUjL9
	2EuFgO0iMmYCGy/hg1hTgKtHXySdwrZOqeOEFF67JaRrMCDEn4nhbZNDTzZBjX5a5HU/Ti
	T1X2y0yBFSA8p3Slmfv2pZLCGi0Uv9o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=InR5naqE;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761118324; a=rsa-sha256;
	cv=none;
	b=k7Qvjq+STcZrbIs9RT6KKT4zMBNCAz0DSlPdPyFHEnadLzIcF0k1L6sBwu//PshDjHiDPe
	Oai99rDOq7A1RccRWSID3AktHRO5lBRgv8+lENm4pqtRbi+ly1ybTYkoD1mQCE9j55H+NB
	k6z0aCZUcYVSX4zGlg1UVB/u+PBlryE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761118320; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=QtY8PxEyIubqCZUk80T4fMo0woyvuu6eo6/vRZ5dv8s=;
	b=InR5naqE12shqKfMuSggTZgD8usHpAbCp1sy5++MvTHKbokmqqvBVUH0YwBcyTKGnZafGjaEYwQ0raeIVC62P8rvxIfV1tipTAe2Yl9TgkzL/x8zpphMGNC897AMkyDndkVG1Vk3jUrShQ0iSxOhuQBq5DQFJd9UoKsgBKC/HAs=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WqlxQu6_1761118300 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Oct 2025 15:31:58 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,  Will Deacon
 <will@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  David
 Hildenbrand <david@redhat.com>,  Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>,  Vlastimil Babka <vbabka@suse.cz>,  Zi Yan
 <ziy@nvidia.com>,  Baolin Wang <baolin.wang@linux.alibaba.com>,  Ryan
 Roberts <ryan.roberts@arm.com>,  Yang Shi <yang@os.amperecomputing.com>,
  "Christoph Lameter (Ampere)" <cl@gentwo.org>,  Dev Jain
 <dev.jain@arm.com>,  Anshuman Khandual <anshuman.khandual@arm.com>,
  Yicong Yang <yangyicong@hisilicon.com>,  Kefeng Wang
 <wangkefeng.wang@huawei.com>,  Kevin Brodsky <kevin.brodsky@arm.com>,  Yin
 Fengwei <fengwei_yin@linux.alibaba.com>,
  linux-arm-kernel@lists.infradead.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH -v2 2/2] arm64, tlbflush: don't TLBI broadcast if page
 reused in write fault
In-Reply-To: <CAGsJ_4xaA8QRjP9H=n1hQfEfGop7vOd5Y=J+KQzuOyfa8GK-kQ@mail.gmail.com>
	(Barry Song's message of "Wed, 22 Oct 2025 17:08:47 +1300")
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
	<20251013092038.6963-3-ying.huang@linux.alibaba.com>
	<CAGsJ_4xaA8QRjP9H=n1hQfEfGop7vOd5Y=J+KQzuOyfa8GK-kQ@mail.gmail.com>
Date: Wed, 22 Oct 2025 15:31:39 +0800
Message-ID: <87a51jfl44.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 646CD40015
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: gf1aamdbjp9q5h81q5d68skhzx8t8x3o
X-HE-Tag: 1761118323-635326
X-HE-Meta: U2FsdGVkX18X+2gOcdxAag3U7mZ+32Ph7bcJ4+Qe53AijmqHKdUQPnYNiRMNqtsuyyql5OAm08bL+iLZFzxymjOSgmmziBQXYnqiQjNMvz8Z2Emc824uwsrE/xCVVTHp4V1t023JrOg2BmSQQBVR6YbeB+GX1jLP40yylIrD5VqgzhMeuqU0UqQO7iZCPAkAKc5eau/3Je69Prq4F46LLZ6w3I2fKZw1BE8BelyuJiKSN5r8vejMRpJpiMQ3v/E4Uj2o9LfxPlmDLem7r4lO9bRaswCSLUL+YvKGA7/2i+foUcTqD+OxbtQcuwb0QUM5cPW11ATc4U/+Tm6G5s7brPRoJJFa53KguL56dfjT2mPfFFf1tByC3u0ylzixdLSmCG+wSJ8Ap6q58XAeSCZmLQW59LyAQnI9BMVTxAY08GhkRf+2//Kh2oOaRNm2TV7aHFe4uuDyDFIlZxQLBjt6xTzYeeGaNiBidtAsrkIb7DsVAUPplOteXr8MXyWAFzscpZZqorvQzdnRchNcAE599soZsCzsgSzIdfAynabzuKr13HpEBKFmfk+i+CT4DyupRQ+2//f20kk9R5ohWQMEENMe5ZeXt1rbZKIejQnK8Wb76aYB/STJSLgiiX61jyIrlze5u7NAg3gk3jnvV8nxBnSCsIVf24fD/2LSeHngK6msTDHjp78xSIZGvoiBc6OYPXGB/D5Tz1wDVubLSekOoGiAJvJsYVqVV5oC9h/6RxKMmR/B6BbSG68jL1wU5D5Ke4s3ytouUiekfB9wDWuHc6YsHDkcvZgr1Un5iIGR60qlWdwL7MRZBy2h1661qgddrDlE2Vt6iGC3O4HPTR10jlQH85cmGSt1Wob7Ejs0abFYjKD9u3wTFGrZ6v1mIgOJ8MLFeSgsrAY6q1yrvD1blwdkRC27vH0/EWCuq3Gw/rupfhlv6IDv9NCfUAA1ViywIduKBX8nmpm4fpQP0qK
 PUgNXXxU
 g+suSIF23uWB+VzqsmZn0GmR3/aNScSUNud2GSvPfsV0dbiq+0g6ZfmkIka9jV2aBHTjqPBG3PBRqd74nEcYe5LXDnYMm1UFIqfP0RSJvwvNqTwlJymkZ/BIzS4oRyGL2wGvzhLepVeUmnZ9H5lHIoD9QUU6JfsHiROsyXNyC+r/HHlbd1i8Qr1MURYtZZSxCVnF4fmbAHSRyDpU/x2NfFLYeUuENgpvmfYCB8W4D9JXSMXK6dy9+kyEpplqeaC50qPcY5WmCVJ2xD+RlqmQH+axF+9BL8o1F0A0IS/3c/nVjS4Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Barry,

Barry Song <21cnbao@gmail.com> writes:

>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/p=
gtable.h
>> index aa89c2e67ebc..35bae2e4bcfe 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -130,12 +130,16 @@ static inline void arch_leave_lazy_mmu_mode(void)
>>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>>
>>  /*
>> - * Outside of a few very special situations (e.g. hibernation), we alwa=
ys
>> - * use broadcast TLB invalidation instructions, therefore a spurious pa=
ge
>> - * fault on one CPU which has been handled concurrently by another CPU
>> - * does not need to perform additional invalidation.
>> + * We use local TLB invalidation instruction when reusing page in
>> + * write protection fault handler to avoid TLBI broadcast in the hot
>> + * path.  This will cause spurious page faults if stall read-only TLB
>> + * entries exist.
>>   */
>> -#define flush_tlb_fix_spurious_fault(vma, address, ptep) do { } while (=
0)
>> +#define flush_tlb_fix_spurious_fault(vma, address, ptep)       \
>> +       local_flush_tlb_page_nonotify(vma, address)
>> +
>> +#define flush_tlb_fix_spurious_fault_pmd(vma, address, pmdp)   \
>> +       local_flush_tlb_page_nonotify(vma, address)
>>
>>  /*
>>   * ZERO_PAGE is a global shared page that is always zero: used
>> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/=
tlbflush.h
>> index 18a5dc0c9a54..651b31fd18bb 100644
>> --- a/arch/arm64/include/asm/tlbflush.h
>> +++ b/arch/arm64/include/asm/tlbflush.h
>> @@ -249,6 +249,18 @@ static inline unsigned long get_trans_granule(void)
>>   *             cannot be easily determined, the value TLBI_TTL_UNKNOWN =
will
>>   *             perform a non-hinted invalidation.
>>   *
>> + *     local_flush_tlb_page(vma, addr)
>> + *             Local variant of flush_tlb_page().  Stale TLB entries may
>> + *             remain in remote CPUs.
>> + *
>> + *     local_flush_tlb_page_nonotify(vma, addr)
>> + *             Same as local_flush_tlb_page() except MMU notifier will =
not be
>> + *             called.
>> + *
>> + *     local_flush_tlb_contpte_range(vma, start, end)
>> + *             Invalidate the virtual-address range '[start, end)' mapp=
ed with
>> + *             contpte on local CPU for the user address space correspo=
nding
>> + *             to 'vma->mm'.  Stale TLB entries may remain in remote CP=
Us.
>>   *
>>   *     Finally, take a look at asm/tlb.h to see how tlb_flush() is impl=
emented
>>   *     on top of these routines, since that is our interface to the mmu=
_gather
>> @@ -282,6 +294,33 @@ static inline void flush_tlb_mm(struct mm_struct *m=
m)
>>         mmu_notifier_arch_invalidate_secondary_tlbs(mm, 0, -1UL);
>>  }
>>
>> +static inline void __local_flush_tlb_page_nonotify_nosync(
>> +       struct mm_struct *mm, unsigned long uaddr)
>> +{
>> +       unsigned long addr;
>> +
>> +       dsb(nshst);
>
> We were issuing dsb(ishst) even for the nosync case, likely to ensure
> PTE visibility across cores. However, since set_ptes already includes a
> dsb(ishst) in __set_pte_complete(), does this mean we=E2=80=99re being ov=
erly
> cautious in __flush_tlb_page_nosync() in many cases?
>
> static inline void __flush_tlb_page_nosync(struct mm_struct *mm,
>                                            unsigned long uaddr)
> {
>         unsigned long addr;
>
>         dsb(ishst);
>         addr =3D __TLBI_VADDR(uaddr, ASID(mm));
>         __tlbi(vale1is, addr);
>         __tlbi_user(vale1is, addr);
>         mmu_notifier_arch_invalidate_secondary_tlbs(mm, uaddr & PAGE_MASK,
>                                                 (uaddr & PAGE_MASK) +
> PAGE_SIZE);
> }

IIUC, _nosync() here means doesn't synchronize with the following code.
It still synchronizes with the previous code, mainly the page table
changing.  And, Yes.  There may be room to improve this.

> On the other hand, __ptep_set_access_flags() doesn=E2=80=99t seem to use
> set_ptes(), so there=E2=80=99s no guarantee the updated PTEs are visible =
to all
> cores. If a remote CPU later encounters a page fault and performs a TLB
> invalidation, will it still see a stable PTE?

I don't think so.  We just flush local TLB in local_flush_tlb_page()
family functions.  So, we only needs to guarantee the page table changes
are available for the local page table walking.  If a page fault occurs
on a remote CPU, we will call local_flush_tlb_page() on the remote CPU.

>> +       addr =3D __TLBI_VADDR(uaddr, ASID(mm));
>> +       __tlbi(vale1, addr);
>> +       __tlbi_user(vale1, addr);
>> +}
>> +
>> +static inline void local_flush_tlb_page_nonotify(
>> +       struct vm_area_struct *vma, unsigned long uaddr)
>> +{
>> +       __local_flush_tlb_page_nonotify_nosync(vma->vm_mm, uaddr);
>> +       dsb(nsh);
>> +}
>> +
>> +static inline void local_flush_tlb_page(struct vm_area_struct *vma,
>> +                                       unsigned long uaddr)
>> +{
>> +       __local_flush_tlb_page_nonotify_nosync(vma->vm_mm, uaddr);
>> +       mmu_notifier_arch_invalidate_secondary_tlbs(vma->vm_mm, uaddr & =
PAGE_MASK,
>> +                                               (uaddr & PAGE_MASK) + PA=
GE_SIZE);
>> +       dsb(nsh);
>> +}
>> +
>>  static inline void __flush_tlb_page_nosync(struct mm_struct *mm,
>>                                            unsigned long uaddr)
>>  {
>> @@ -472,6 +511,23 @@ static inline void __flush_tlb_range(struct vm_area=
_struct *vma,
>>         dsb(ish);
>>  }
>>
>
> We already have functions like
> __flush_tlb_page_nosync() and __flush_tlb_range_nosync().
> Is there a way to factor out or extract their common parts?
>
> Is it because of the differences in barriers that this extraction of
> common code isn=E2=80=99t feasible?

Yes.  It's a good idea to do some code clean to reduce code duplication.
Ryan has plan to work on this.

---
Best Regards,
Huang, Ying

