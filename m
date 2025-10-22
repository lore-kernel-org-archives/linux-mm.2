Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C30DFCCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 09:02:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F01398E0008; Wed, 22 Oct 2025 05:02:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB2358E0002; Wed, 22 Oct 2025 05:02:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA0C68E0008; Wed, 22 Oct 2025 05:02:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C29728E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 05:02:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 63E89160813
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 09:02:09 +0000 (UTC)
X-FDA: 84025158378.21.17738BD
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5E89580018
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 09:02:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=eAVdVxMr;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf02.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761123727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mcRDTEAbzquuDlXqMd0IqQmK0PoHGGByotq3KkqD9LA=;
	b=M/jvBco6tTNfPSehpujOTiJ3nVymvnE7CIuFONDBPkMT7OfFxgV+OkWTzZzGs4X8tVnXoM
	2/IvYUALey8QkPY4mys8EAx4eD8x6XK58Lz1DbdY6PeLtbxdll+0Jr7w+cEQdtrYBv367p
	J+TRot45BupF+EMgwl3elIdwJbOtSUk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=eAVdVxMr;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf02.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761123727; a=rsa-sha256;
	cv=none;
	b=dNGbM4H4QmRecCSE6FigBnuIELh5/mdmSCuEOikZ7+DFIuPTtjI41MvJp70P07RMJZWJye
	gP4IAXpx9LFV+R7EZC6/gn65OYdqQ479p7KTpdPBSpUrP+qzgTgtswaBc2ofF7+PF7ZRGi
	GhIZdyVhpZs9nO8deaQc854b4n2lIp4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761123722; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=mcRDTEAbzquuDlXqMd0IqQmK0PoHGGByotq3KkqD9LA=;
	b=eAVdVxMr50lan9ZF6NQ/0aXU+Shgrphp8d8T//aZHjzGlQEcpWooAYZOI338chPaCME/O6ckvZiPKEqgWeNmuPLhDcgEYl2pK+TId5kWktTC9IEZJZVj/nZx4zI8Hb7PzFu9oqVZaZEh7878iJcK+1gLfFb0dBDDO+r73xE8mGM=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WqmBveP_1761123720 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Oct 2025 17:02:01 +0800
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
In-Reply-To: <CAGsJ_4zPH0fwBOLQwh1y6jG3tCXHLGRCTyVVSCWb+NfLCEMV0Q@mail.gmail.com>
	(Barry Song's message of "Wed, 22 Oct 2025 21:14:48 +1300")
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
	<20251013092038.6963-3-ying.huang@linux.alibaba.com>
	<CAGsJ_4xaA8QRjP9H=n1hQfEfGop7vOd5Y=J+KQzuOyfa8GK-kQ@mail.gmail.com>
	<87a51jfl44.fsf@DESKTOP-5N7EMDA>
	<CAGsJ_4zPH0fwBOLQwh1y6jG3tCXHLGRCTyVVSCWb+NfLCEMV0Q@mail.gmail.com>
Date: Wed, 22 Oct 2025 17:02:00 +0800
Message-ID: <871pmv9unr.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E89580018
X-Rspamd-Server: rspam03
X-Stat-Signature: unmki1o7pe85sbg1stmiqxszo7n11z4k
X-HE-Tag: 1761123725-865511
X-HE-Meta: U2FsdGVkX19uqRz11IW45TeS8oX7EtsZXy42THpjPvgCSDPObDAS3oyk4hJ0rVKrwfd+cJUb0cjLkN89bbtrHvMw6lksJQKeXvfLCljZ76QV6m+ozry8X+rDfCQnmwbY21e5jfd1GZTWFo2bN+ZxH97pEzJ5yRTUCm3ba0CPPDGwVLjLOIi5dlpl7C2zRbjDysKcxiAMI42Anfyuv5svgnSHRbFDsGRPD3DKOWpQsyCf62xq2VoG0h3Nh2jFsg6fa/1zcQz5LWISz0LXdVWubgsiYKljGzAsoDb/0rdh11PBnaQTbusugRItUGtfsCYj9/AACRAizz8Q5nJLKf4GWb43exqga4JKaeQQvdByBTOsE3c2ARjPZvgQqSwN/FOUqxTRyfSdwNoel7/0Qf7tasPFnllhAA13P06fot5HZcbeHr1VxgAcvca3x4dLwVz2Hdgv9YQveLtkXv1gMGOWa7RNXdGBSxLnF3S5U/liZvjJ7tN3OUUVbHkw5YXz1DKLV27IpYD1bPPZvFmuUbDOxX39cVesSD2raXFyMuDLSfSRo83FIdv81dU0jpWiMdx8AKSsyeoc1410pBDo/LItJ+EYKWWjyFoIRjhL7ncai6LCZ+Oiaj2cMV6S/9/u4njsOHiFzij8wNtpKFshwbNtv/VWy7ApWpf+U3VgvA3fg6uEnAzr8pGjUEKbBj3MO4LoPtZ93hIMLPV9LDvT++3eyAQG9BdDpe2qGR/7TtA7ckhkUmXx41TXSFoKm6IZ54A3ZzbeEWN/eFAq9doYQAwG9Ab9Gciiu6q37b2+6S6igwRpo3p3FfvHUPD+LTvjqPUFnibETg0Nw9dSHNRR99CpnFYRrfq/lJt9qBFnx8mVzIciAKQm2cUOfg9rDRmySkBZx0gfPZ44ZdZ5mXpYriNtpGmHF14Ptp3i0A4OyOkSEfvbkC9LjyphmTO8UkLQRg0CWGKqc4eCO3Ul2VHOgTo
 +IllLY8b
 bpPwzkW4gOrxmViLUCipZ7SVeWyBK5u+9sKrt4YduHcgp046Y22LXfvcyGCyNrsEesgVPIsSxfyVcnLi1ATQNj75PaWcs90ixdwVutEiGRFjUmnBk0xutgFBn4QH7MfgHq7GelMxfTHYTBpvzoDBtVR5IhBu0VlSVIOsdjK93muLs/ilYFs2dkdpUuMltqzZQobGHIscAdZymqI7SKAVit8FBpRPcbxyo6yYgbdRwklgEOelkkcUQNqr/tVwe5M4Znt+YqE0JXmUrKD9eOA26PIs5Re50QiRuc9r1dPnv7xBXejw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Barry Song <21cnbao@gmail.com> writes:

>> >
>> > static inline void __flush_tlb_page_nosync(struct mm_struct *mm,
>> >                                            unsigned long uaddr)
>> > {
>> >         unsigned long addr;
>> >
>> >         dsb(ishst);
>> >         addr =3D __TLBI_VADDR(uaddr, ASID(mm));
>> >         __tlbi(vale1is, addr);
>> >         __tlbi_user(vale1is, addr);
>> >         mmu_notifier_arch_invalidate_secondary_tlbs(mm, uaddr & PAGE_M=
ASK,
>> >                                                 (uaddr & PAGE_MASK) +
>> > PAGE_SIZE);
>> > }
>>
>> IIUC, _nosync() here means doesn't synchronize with the following code.
>> It still synchronizes with the previous code, mainly the page table
>> changing.  And, Yes.  There may be room to improve this.
>>
>> > On the other hand, __ptep_set_access_flags() doesn=E2=80=99t seem to u=
se
>> > set_ptes(), so there=E2=80=99s no guarantee the updated PTEs are visib=
le to all
>> > cores. If a remote CPU later encounters a page fault and performs a TLB
>> > invalidation, will it still see a stable PTE?
>>
>> I don't think so.  We just flush local TLB in local_flush_tlb_page()
>> family functions.  So, we only needs to guarantee the page table changes
>> are available for the local page table walking.  If a page fault occurs
>> on a remote CPU, we will call local_flush_tlb_page() on the remote CPU.
>>
>
> My concern is that:
>
> We don=E2=80=99t have a dsb(ish) to ensure the PTE page table is visible =
to remote
> CPUs, since you=E2=80=99re using dsb(nsh). So even if a remote CPU perfor=
ms
> local_flush_tlb_page(), the memory may not be synchronized yet, and it co=
uld
> still see the old PTE.

So, do you think that after the load/store unit of the remote CPU have
seen the new PTE, the page table walker could still see the old PTE?  I
doubt it.  Even if so, the worse case is one extra spurious page fault?
If the possibility of the worst case is low enough, that should be OK.

Additionally, the page table lock is held when writing PTE on this CPU
and re-reading PTE on the remote CPU.  That provides some memory order
guarantee too.

---
Best Regards,
Huang, Ying

