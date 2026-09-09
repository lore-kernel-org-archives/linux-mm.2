Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 382C4C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 12:29:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B1C56B0096; Wed,  9 Sep 2026 08:29:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 462A86B0098; Wed,  9 Sep 2026 08:29:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 376E86B0099; Wed,  9 Sep 2026 08:29:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 199536B0096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:29:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6CD5A1C0F87
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:29:54 +0000 (UTC)
X-FDA: 85194155508.12.6803307
Received: from mta0.migadu.com (out-251.mta0.migadu.com [91.218.175.251])
	by imf16.hostedemail.com (Postfix) with ESMTP id 61B75180007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:29:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Sihn6XTZ;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.251 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788956989;
	b=iWjA+ew2ZHy7tkCNcUug4+jzvFZA9YIynbWNFYW3YyKFKNyle+ER7/McgmzBJWhnlKWiTN
	vd1+eiIterUOEREWIQR0+0J0SXUFnmYgeJc7P8/mwcCPLDuxaU/mePulwqL3FigtNdyJ4q
	+REsWH3tTStOPDeSEGGMMSVm1dltcsc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Sihn6XTZ;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.251 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788956989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ka2PEqj9IN0ykGYevECG6ZYsotB7P4P9zJ4w0eZnZ/I=;
	b=suYDFGG5EvtBuQ8JacuvRNLvt2dE5OZlB97G+smHhJoPt29VsB1UkwaWbDqgQDdgu6oWrU
	CHTg/AyUGc8BmKCn+4GAbU+aoKyQZdRKuJ8joLsSB0rfYFFMJsuUvlGPDbSIbRBj0jJC91
	vrMpT3iUZpuZ2mL7RYEfJzEELOQ/qEg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+c1G5fdvgYFobZQK+AOg+Lekv53bc0i4dzKelbiKc0s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788956980; v=1; x=1789561780;
 b=Sihn6XTZQrxBYZ+N1YaX4N3H9SEuYBt/W4h0c+QSqJ+FUd4gbH7MyxSFDFQoNUEwGOwj65lN
 CbDrQrdtUi/EgPGnGhSlmLZslQ+nbM+dPmiybFUQUrxaQKhI4yd4aeld4HY+MxhI5I3md51T1QT
 wPmYbmEuI1p1tsP2A2EZp+W8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 82dccf2517e47cd1;
	Wed, 09 Sep 2026 12:29:40 +0000
X-Mizu-Trace-ID: 82dccf2517e47cd1
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v5 09/17] mm/sparse: initialize memory sections earlier
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <a2016390-28ce-4199-a063-d2e9101dacab@kernel.org>
Date: Wed, 9 Sep 2026 20:29:23 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E54037CE-6CE6-41AB-A525-8BDCE55996AC@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-10-songmuchun@bytedance.com>
 <a2016390-28ce-4199-a063-d2e9101dacab@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 61B75180007
X-Stat-Signature: ne5b7o4m699q3hffq8o5aae57xc7ka37
X-Rspam-User: 
X-HE-Tag: 1788956989-244385
X-HE-Meta: U2FsdGVkX19F6Y90YxfRdoUGPMVujTYosja8FHkolK2ZwpfLiPcYQajHcO/oVB/dLa4mSTg+C/chtknrECIaR9MzYERkc1DWTTVHQsNGYLLnScnHelZJIPqMDuvy8ZVbIwIyTTP1hTSC4mAnGScPH6QNAnTlabekSDu+BzYatchT9jlUiqCaJo0nqfEtChz+v3qBKssO0aOyDiLMIyT7gIgzQ02Ug4q/48XC2GyuB4igmq1a8TaDTbKQ2kNTResGCV/77kuWO9bWBPR+BzeYHwN4eViTcMID7ZjoqcSprihLQArIpeQyL9CwXQG5n/FYqawUU2/Ep25YOIQtzasO3/xnrRdOUIfiyw4INUtgb2AQLo9OnxFpiiT5YaPLVQ/x8/1XrgLjP/XfpUZ3g9aUiVswXJNLNJCDvSAipnCUFbgtdOH9uAfvxi1oRj+imSZueEWbfUbv4GBKn0egxMRNprxviI4tNXoe6oDSVIScCBrMvcaA7RkO0F0uE7iZqOIVzB+s9CLBLwverZjB9Z8Qvrmvbojh11xUOq32W+m5fm+evQf5G9TloonEdF2CzwrS/kPsY382+ShKxN3PyNs0ogxpXscWC/JizX/60FNzT/9AUnHaSxPy4gAQGCZdC4cKeRTWuOv1zDpBcrhVvK1Qvu6n8Q3Xn8SPkJ4dQ1FbUhtRn07y3HW6l3DNYFFZ2LMp2yRYsGAqyVfQO/ZSpkF+9/ttLGf7UkxzI63mGHLcmqpLj0+hEh5GRAZxUucbf0H5P6bT4LhCCHU5vwjjzfYUdFNxWDu3Z6XZqw8iewVHxBGgfnfRdVnEFarHzuKbvrCGbMS7HWIcP7OTtgfy+TV/vnSmTT7im76zS8qGmarcoYbjMGQWWfLipfZJPTnFAGXGXtEpiSyy3aYWb/kyeVF6ohRyrSdoTqffvt32uSr0Dwq0UMiwPm4PyWJwX3GnQrDFjGrC6GortjMHXv/Cphs
 SQa5/SEw
 SHqPJ2EltCXcYocX8M1y8kbqH3tuFhMy2Dmt2lSRsnumlWasg3hCNQh86tD8r4vrazyXPr+8ifFAgYPaXgmsfnz0TtM25+2F9ZhXvNXJv5FtQB2sC8IufrXdTT76//1KN+CMdr/qd0BZiMgqvGJv7U6kd9cLIodIueknDijJ7SIwI2uaIwl8tJVE90iB5TwHP/LHtHuYdTZ6fQ25fWjKj+KrdhRvkErxrTpC9qORsfPFCxfukgkyPLBv1nz704cTdOZoxvTKDpgW3MPeZxunEbyP+r+JQtPExfoENRETVbPrv3HzGSGF/IFgJtdubYtFfk0tFAySiAgDp6aY3S7Zit/0ox4lYhebYXhZfEf2NDOXgLhwmFtyXgWbPOQrN2KbflDEUbqK9us+BQJQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 9, 2026, at 17:56, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 8/25/26 10:46, Muchun Song wrote:
>> Upcoming HugeTLB bootmem changes need sparsemem section metadata =
before
>> the HugeTLB bootmem allocation path runs. The memory sections are
>> initialized from sparse_init(), which is called too late for that =
setup.
>>=20
>> Move the code that initializes sparsemem section metadata for =
memblock
>> ranges into mm_core_init_early(), before free_area_init() and the =
HugeTLB
>> bootmem setup. Rename the helper to sparse_sections_init() so the new
>> caller describes the sparsemem-specific initialization step.
>>=20
>> This is a preparatory change.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> ---
>> v5:
>> - Collect Reviewed-by from Mike Rapoport
>>=20
>> v2:
>> - Rename the helper to sparse_sections_init() to describe the section
>>  metadata initialization (suggested by Mike Rapoport)
>> - Fix the !SPARSEMEM stub name so SPARSEMEM=3Dn builds compile
>>  (reported by Sashiko)
>> ---
>> mm/mm_init.c |  1 +
>> mm/sparse.c  | 10 ++--------
>> mm/sparse.h  |  2 ++
>> 3 files changed, 5 insertions(+), 8 deletions(-)
>>=20
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 0317fb781e77..e2a16d833635 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -2642,6 +2642,7 @@ void __init mm_core_init_early(void)
>> {
>> 	kho_memory_init_early();
>>=20
>> + 	sparse_sections_init();
>> 	free_area_init();
>>=20
>> hugetlb_cma_reserve();
>> diff --git a/mm/sparse.c b/mm/sparse.c
>> index e6cb67ca9c8d..439802e6a6ad 100644
>> --- a/mm/sparse.c
>> +++ b/mm/sparse.c
>> @@ -191,12 +191,8 @@ static void __init memory_present(int nid, =
unsigned long start, unsigned long en
>> }
>> }
>>=20
>> -/*
>> - * Mark all memblocks as present using memory_present().
>> - * This is a convenience function that is useful to mark all of the =
systems
>> - * memory as present during initialization.
>> - */
>> -static void __init memblocks_present(void)
>> +/* Initialize memory section metadata for all system memory. */
>=20
> I'd drop this comment, it's not entirely accurate. A lot more =
initialization of
> the sections happens later.

I can drop this line comment.

>=20
> What this function mostly does is
>=20
> (a) Allocate sparse-exteme metadata
> (b) Temporarily store the nid and mark the section for being present =
and online

Yes.

>=20
> I have patches to get rid of __section_mark_present() and just set =
them all to
> SECTION_IS_EARLY|SECTION_IS_ONLINE such that we can just iterate early =
sections
> and get rid of that PRESENT monstrosity.
>=20
> Apart from that LGTM, even though I don't particularly enjoy splitting =
us now
> having two init entry points
>=20
> sparse_init

Maybe this one should be sparse_memmap_init? If yes, it could be another =
separate
cleanup patch.

Thanks,
Muchun

>=20
> and
>=20
> sparse_sections_init
>=20
>=20
> Where it's rather unclear from the name what is actually happening.
>=20
> --=20
> Cheers,
>=20
> David



