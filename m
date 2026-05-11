Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82DF5CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 13:12:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBEBE6B00B4; Mon, 11 May 2026 09:12:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6F1B6B00B6; Mon, 11 May 2026 09:12:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAC286B00B9; Mon, 11 May 2026 09:12:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C8D946B00B4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:12:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8FFAE14010C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:12:19 +0000 (UTC)
X-FDA: 84755177598.23.5D58B96
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf22.hostedemail.com (Postfix) with ESMTP id D4180C0007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:12:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ivtk2zlG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778505138; a=rsa-sha256;
	cv=none;
	b=YwqgsBCeFB1HzuS4j8GNJmpz4Nne5F+w687yZ8P14PwQJD1y68GMTuz0MZFt0L8kWRnEXD
	TxREoJC22YfmplXpo3Dh61pFB+kXM1jx+1BN7C6QpedyLZhFyv1mcJ7j6YiFNaAH/SQdz9
	aKmeh9Rl7W7wOyijHCfchCxuGi5yVt0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ivtk2zlG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778505138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+BOMHgDECiBc18kMy1bAnOxhSlWyxw7BIMrtd1bfCJI=;
	b=79vErh9Sn0jUmA2m3S24fT2QfpPJxQBSOVJxt60yXLkds3EGulyA0mXpg7c4bZL75aRMmS
	GtjWelOcfCp0icR8Z51JCo7ZTA/xOAWpUyOLJpUIBwhtfLlvzjlWUJhGrssm8vthTHW/cP
	Z3G1zsDP4M7oURKQDI7ASMaKCStSexc=
Content-Type: text/plain; charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778505135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+BOMHgDECiBc18kMy1bAnOxhSlWyxw7BIMrtd1bfCJI=;
	b=ivtk2zlGe2VZOVHnnWCntXpOrUVGdOXN9qd7oWbdCxRiDKaF8nRbDymDMS6jbIAkY+qD6i
	tQ8Qw0lRgv06A1XdPxz4BSz+FgtWvU5mjrIl8sG9+cIcTmLDxHklKLws0ORaQcrWcSU2xM
	SviTM3Lkh9oaqg56vhT0K4dwcxb4SzM=
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] mm/page_alloc: Fix zone reserve update serialization
Date: Mon, 11 May 2026 21:11:40 +0800
Message-Id: <E30FECDF-EC4C-458F-866B-01BE710984C9@linux.dev>
References: <agHS2xXSgW4YxJF2@tiehlicka>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org,
 Suren Baghdasaryan <surenb@google.com>,
 Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 zihan zhou <15645113830zzh@gmail.com>, yaowenchao <yaowenchao@jd.com>,
 linux-kernel@vger.kernel.org
In-Reply-To: <agHS2xXSgW4YxJF2@tiehlicka>
To: Michal Hocko <mhocko@suse.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: zrjb7o5x1upywm7ojraoz7nh4b3r46pa
X-Rspam-User: 
X-Rspamd-Queue-Id: D4180C0007
X-Rspamd-Server: rspam07
X-HE-Tag: 1778505137-877082
X-HE-Meta: U2FsdGVkX1/w8u4NU0AIg0w7rwb+BQjruU+jcVTFzGK73C02Rk+y/+XY+OW8ajq0ARKZGYZ2ii0PUajO+wtcf5Qhy5gWTQ+lpEfJvLtkGce333smIMHPOrQnqoRN7Hrch6CSRNemJUfRf0T14CU9v56yV5r1WIFcrilmYzNwXV2ONpcMkwpL0UkMD3TMWI0Nff3wORKqVZ6WuGiS4EOAAECSLVcJaaL5d9qmUYUUGBmwZtlCNmXRbsR5vqKSE8IhsRvuQCHQYCs55nBAEOyHmEshAZy0lBDCOc8U5j7p7BRANMQLQUNBo5wCPurAcpPDiEcuSNgF5fWrW2XjsM4qhT1U2E3GnZZfRzzpYOmdu+D/MzI8pv+DvK7cH04TgnsKYfJTQpzsYk1YKgnqa37vz3sD08bFA80WJ0tHjCB/nwXp8+eTWpAH0b232e3MmbahBapEugNt2Yiua2qUCZe7IzzLbBtnaOOqfIVzpIyEQ5d9o7Qts0hGCWyoBFUCEBQRrCul3m1AvAQg3vgoNm4zbviiP1XKU3lO004Yc4eXk1wOik7WaLYcaoWas2R4IWI7PsKLOvz5xGZrd9n1QS35eHOLnWeYE7N11Djs7RAmDI51JM4dSzUQVHGpdfvAxRHSnY9qE0yE6iXCqk2XniszvVOR8swayODk6rK2nygdCBdtKX5nspNPr/FgtXj3y6zOyPmgdqS9OmgaxS8X/NzGmS/nDNrqhiCJUINcR+tGc1+H/9O6yhVAZWoff9dfob/hMRvk8zMJTbZ8u5RQF1f/PjtkUQinz/1nxQgpXy9ltlU0Ow7AeuoNBZQ28KGHJrIL1Td6aAI7Zs34ZiyU3rvSW8dU8esMU5kzxeJjvSR9rl28IqQwCAQl/nmi+zjWiZfSumoktyU5Hwe9gOiwbXCnJJ/tV/nZbTiPO0J+WYsQyQ+2+6if0yIrST34gce8paZNCQgPauwX8djjbh1eq/s
 QwcOylPY
 GJ5qJXarOGJfWdud6NTvCN04aCmDYPXrNvj4U8jtZHAikJVIJ1UYqhNmxmV/Aze437/q9lp6+ACh8EO3vfdmoLmDWJZnJa4UBv1S58BlIX3AxliE0jlPP2CMH8sfw8kScZqNmu7aHo5VswIiWGvr6zClEt2wxwW2VXZnRX+jT0M7HEC//ZoxzHI/opx/gl4e+dzD52fsiy6GpIkBf/NtWiTOA2Q9p2v7tRECSiSWBAR8goetn573uYvowfgQH+o22yt1U1p2wTOapuqBp6azus56zSZMXtrwI18x5QLjiQo3jSI58teJiDaTLpMOqnqIqjzqSczrWO0hJDIfttPQ1MpDUpu8zAzoL6ypD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 11, 2026, at 21:00, Michal Hocko <mhocko@suse.com> wrote:
>=20
> =EF=BB=BFOn Mon 11-05-26 20:53:56, Muchun Song wrote:
>>=20
>>=20
>>>> On May 11, 2026, at 20:33, Michal Hocko <mhocko@suse.com> wrote:
>>>=20
>>> =EF=BB=BFOn Mon 11-05-26 20:04:09, Muchun Song wrote:
>>>> Serialize lowmem reserve and watermark updates with the same lock so
>>>> calculate_totalreserve_pages() cannot observe partially updated zone
>>>> reserve state.
>>>=20
>>> Could you describe the problem you are facing?
>>=20
>> To be more precise, commit 9726891fe753 moved
>> the call to setup_per_zone_lowmem_reserve into
>> adjust_managed_page_count. Since adjust_managed_page_count
>> can be executed concurrently across multiple CPUs
>> (especially during memory hotplug or parallel initialization),
>> I am concerned that this might lead to inconsistent updates for
>> the following counters:
>>=20
>>    zone->lowmem_reserve
>>    pgdat->totalreserve_pages
>>    The global totalreserve_pages
>>=20
>> If these updates are not atomic or properly synchronized,
>> the resulting values could be inaccurate. This inconsistency
>> might cause issues for other kernel subsystems that rely on
>> these reserve counts for memory allocation and reclamation
>> decisions.
>>=20
>> Just to clarify, I noticed this potential issue while reviewing
>> the source code; it is not a bug I have encountered in a production
>> environment yet.
>=20
> This is important part that should be part of the changelog. Theoretical
> issue observed when reading the code.
> While it is really trivial to see that there is a race condition. It is
> much less obvious whether the race condition actually matters and worth
> fixing by introducing a new lock. So this needs much more explanation.
> I am not against the patch but the changelog is quite underdocumented.

Got it. I=E2=80=99ll update a version with more precise information in the c=
ommit.

Thanks,
Muchun

>=20
> --
> Michal Hocko
> SUSE Labs

