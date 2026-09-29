Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E436EC9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 07:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 973316B0088; Tue, 29 Sep 2026 03:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94B396B008A; Tue, 29 Sep 2026 03:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 887AA6B008C; Tue, 29 Sep 2026 03:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E4B06B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:53:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D240FA6A0A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:53:47 +0000 (UTC)
X-FDA: 85266035694.19.A0FCA6A
Received: from mta0.migadu.com (out-119.mta0.migadu.com [91.218.175.119])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1721C40003
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:53:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VGo4xMot;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.119 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790668426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YbS4DWLSoBn/s6Ld3krDIRwaskEMUdgjstKGe4LdtRw=;
	b=fLlNCwxb3NdFAllAl9C8qkEkRhkCRFJVb7OMbnLw1EhN3/FNMAlAzBwlSm70595A3bSOps
	0o+b08kJNQUF7semQXcMdGdD3ieMHrjuLUWfREtzzojuXeRJU/wQ2RaPwGYW/JQiNHnqpo
	A6P5CdRAYiewbpitbs8RXxP3aX7RPHo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790668426;
	b=PpKnt7TP4HGUCqoHQ2SwO4/ZtDsVgfXoIAnisdoFY4ysYJ7ECLQ0WYmhuWBQqz1SvbhEHv
	l9cAcMAi/rr46JGTXrQ/F6I32bDBRyQI21fFna5vk0J/7WOOVcH+Kutraq+R1vttRSp9zT
	IqY6gNWvKawwKDFca5J7e/1ibcWXFKI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VGo4xMot;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.119 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=UVeeOQdrWmFqZlj5Z7vC/2L8sbl3nluI5tg6Il2hotU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790668420; v=1; x=1791273220;
 b=VGo4xMotvnt/diYnBuJzrVtHR0mpf3IoNDoqbj4AGP7uvQnU1KAZY5coLCfsTkiOA1+YDjBU
 GS4MSoDq713fylYOQ6DTeVnHJJg5HsbpghXZrhYQE5dmSbaAOa9WUHV8xCx/rnFPeQmFVHv24s/
 YDHcqAZunS1ciTigsAT+Mm7A=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 36715084ceb0146c;
	Tue, 29 Sep 2026 07:53:30 +0000
X-Mizu-Trace-ID: 36715084ceb0146c
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH v5 03/12] mm/sparse-vmemmap: introduce
 CONFIG_VMEMMAP_OPTIMIZATION
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <d7a75c99-3021-495f-ae34-883d047370f3@kernel.org>
Date: Tue, 29 Sep 2026 15:53:15 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Jonathan Corbet <corbet@lwn.net>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-doc@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Lance Yang <lance.yang@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D0B0A406-100C-437D-8AA8-D276E8DA8278@linux.dev>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
 <20260927025441.741633-4-songmuchun@bytedance.com>
 <d7a75c99-3021-495f-ae34-883d047370f3@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1721C40003
X-Stat-Signature: wdwhs8omsurmw9nz7dm7h8uy84o6pacx
X-Rspam-User: 
X-HE-Tag: 1790668423-573348
X-HE-Meta: U2FsdGVkX19/zp6O5q0TbblMsqzxKCae88q2npkGSCHfmX+d5m72smcmS1HPQ5sKBpocqHSFISxxm9SbjaBAP33hlFJVMIRWG7d//MVchKarCZ13vCCvxInk6UKPzmDHo38MxKSowkjS3iOFMeV+S7gwetHXmWug6GUVQ7gD9ZA839+bg3pok3i2JLap8l+yU4a6TR5SzdJB8O40U40MuQEfbnsO9nbdfnnzt4Eevq95Cdta4M/3/KyyGv+aobnca8rmDE7F1EeHk5KggvIxxDkwPxeMyzKTMK3nTbZ3VYpU16Sk7joTqawHlZohwQ8VXApTXCG1EWhpCXg7i0dANm57KHVnuQiHLJ1bM8Yme8IVT7kqk1LIMBkSFJZ/vdPLIzMzpycBvf2yGwGxpebeBVQSvd5s54d8JLwwE1COYyGh3JtNTVhwrpA3trNTP7xqNJku9t1ObOg1CuNd5ZheJk2+SqNtg7ls4M4yhTeLWgri/Cw+9py/euCN4fscJI2qS17QNR2z7aMX+goUl/SB79gZanlgvF1T0mBNtCaXu0C/ohYaDMDQ7MkJv9seU6k1lPbgbZULHUE6mc+wN4TLOw46O3lu77bZcTpZJltok9EAoSfDAdY0AXNGJjQqEMKqqMmN0rC45vfO+Fhp/mJA2nHjjHjFCZhFg+1n2qUP3+2rHmUj/7Vb1ADMEHMMUHv2s287hFvsSpqxGDe6WYe+Eq9goZZ31aCbwBkUnAV7JzFuwcbammzEqX2/nJ9u6LFwUJdS1ULHgPzFIND93XcLhEZT0KKZTueWqZswy2JgEVlW4b8P+Cs4scE+aLPvWG2L6E+AImKPOtlcpbfSmooL18YnhESRJrmFQnrtDLXW7SXZ7PEV+vJ3aQZnIDJdQdCMcUdStxLoy62KyJhOfCpaCkNjzjcDpVnogfaAD6iiYU01q1c4313OsqHKBK+UZzW98Vjbi6pxEoC0HAaU59M
 zprBrH0v
 iw7dcWLXAausJO/ttv3eT8bAGu/J92SJxiuRHNbnEbAD0nTlFdGp3DHL3MpRRwe8LkaYkHH/9dWpPIkrFWp7FnRHGh4JbAl4W5Q9dR7Y3IpZoLzWv0/tpvWSOdoeYL6BFv097ZVLaqa3Lp2mDnL30GtftDPPHSU0tvPMHSvmebDYoJwn8yGMB/sakTlg/7HPVUjWKMi3Fk1o/WT/NyCgijKc0Fdv7XQWqq2VmdrKH5DyHp+rMcI6jaF8Y7827wDoakJaJNLw4qLK2PkoCZNdWchHLbfWhOWW8el+N0l53sP+/UYyjKk1aGEbInHhpbJU1k17PMub8POAGYSw8mhaffO9hgwaQzsQpO+1ZOsB20VOm0QwXzD8qLlYM1QpwYoaD2rUs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 29, 2026, at 15:11, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 9/27/26 04:54, Muchun Song wrote:
>> The section-based vmemmap optimization infrastructure is guarded by
>> CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP, but it can also be used by
>> ZONE_DEVICE users that set dev_pagemap::vmemmap_shift. Introduce
>> CONFIG_VMEMMAP_OPTIMIZATION as a common config for the shared
>> infrastructure.
>>=20
>> Select the new option from HUGETLB_PAGE_OPTIMIZE_VMEMMAP and from
>> ZONE_DEVICE when the architecture opts in to DAX vmemmap =
optimization,
>> and use it to guard the generic sparse-vmemmap state and helpers.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Acked-by: Qi Zheng <qi.zheng@linux.dev>
>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> ---
>> v5:
>> - Move this patch after the shared tail-page factoring.
>> - Select VMEMMAP_OPTIMIZATION from ZONE_DEVICE instead of DEV_DAX,
>>  covering all users of dev_pagemap::vmemmap_shift, reported by
>>  Sashiko.
>>=20
>> v4:
>> - Rename SPARSEMEM_VMEMMAP_OPTIMIZATION to VMEMMAP_OPTIMIZATION
>>  (suggested by Mike Rapoport)
>> - Collect Acked-by from Mike Rapoport
>>=20
>> v2:
>> - Fix SPARSEMEM_VMEMMAP_OPTIMIZATION being selected without =
SPARSEMEM_VMEMMAP
>>  reported by Sashiko.
>> - Add an explicit DEV_DAX dependency on ZONE_DEVICE
>> - Collect Acked-by from Qi Zheng
>> ---
>> arch/x86/entry/vdso/vdso32/fake_32bit_build.h |  2 +-
>> fs/Kconfig                                    |  1 +
>> include/linux/mm.h                            |  3 +++
>> include/linux/mmzone.h                        | 10 +++++-----
>> include/linux/page-flags.h                    |  5 ++---
>> mm/Kconfig                                    |  5 +++++
>> mm/sparse-vmemmap.c                           |  2 +-
>> mm/sparse.h                                   |  6 +++---
>> 8 files changed, 21 insertions(+), 13 deletions(-)
>>=20
>> diff --git a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h =
b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
>> index bc3e549795c3..72a92cb9b53d 100644
>> --- a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
>> +++ b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
>> @@ -11,7 +11,7 @@
>> #undef CONFIG_PGTABLE_LEVELS
>> #undef CONFIG_ILLEGAL_POINTER_VALUE
>> #undef CONFIG_SPARSEMEM_VMEMMAP
>> -#undef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>> +#undef CONFIG_VMEMMAP_OPTIMIZATION
>> #undef CONFIG_NR_CPUS
>> #undef CONFIG_PARAVIRT_XXL
>>=20
>> diff --git a/fs/Kconfig b/fs/Kconfig
>> index d1c210c6508f..1454b7fe9641 100644
>> --- a/fs/Kconfig
>> +++ b/fs/Kconfig
>> @@ -278,6 +278,7 @@ config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>> def_bool HUGETLB_PAGE
>> 	depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
>> 	depends on SPARSEMEM_VMEMMAP
>> + 	select VMEMMAP_OPTIMIZATION
>=20
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks.

>=20
> Is there a path to remove HUGETLB_PAGE_OPTIMIZE_VMEMMAP, and to merge
> ARCH_WANT_OPTIMIZE_DAX_VMEMMAP+ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP into =
a
> ARCH_SUPPORTS_VMEMMAP_OPTIMIZATION?

These are actually two completely different capabilities.

ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP requires the architecture
to support dynamic updates to vmemmap page tables, meaning a
PTE entry can be changed from one valid entry to another
valid entry. This does not meet the requirements on arm64,
because arm64 requires page table operations to satisfy BBM
(there is, of course, a series [1] attempting to do this).

However, for ARCH_WANT_OPTIMIZE_DAX_VMEMMAP, the vmemmap page
tables do not involve dynamic updates, so the BBM requirement
can be satisfied. Therefore, arm64 can enable
ARCH_WANT_OPTIMIZE_DAX_VMEMMAP, but cannot enable
ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP. To make the naming clearer,
I have another patch [2] that renames it for greater clarity.

As for ARCH_WANT_OPTIMIZE_DAX_VMEMMAP, I plan to remove it
entirely in the future, because architectures that do not support
it can simply choose to disable it, as can be seen in patch [3].

So in my plan, ultimately only one config will remain:
ARCH_SUPPORTS_VMEMMAP_REMAP.

I hope this clarifies the plan. Let me know what you think.

[1] =
https://lore.kernel.org/20260708031129.3503195-1-jthoughton@google.com/
[2] =
https://lore.kernel.org/20260903122128.12264-2-songmuchun@bytedance.com/
[3] =
https://lore.kernel.org/20260513132044.41690-6-songmuchun@bytedance.com/


Thanks,
Muchun

>=20
>=20
> --=20
> Cheers,
>=20
> David



