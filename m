Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97F23C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:45:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 670B26B0005; Wed, 15 Jul 2026 10:45:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 620896B0088; Wed, 15 Jul 2026 10:45:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5378D6B008A; Wed, 15 Jul 2026 10:45:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 210BA6B0005
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:45:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A1DFC801C6
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:45:42 +0000 (UTC)
X-FDA: 84991284924.22.2E6EBBF
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id B366C10000B
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:45:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=efPFpHYQ;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784126741;
	b=2I2w+yACJ5EZIs9BKEuxkBioLdwfj423ualH9BJQb0nSIrs2jgJbTY7y6Qhka5b9gRUTgU
	25KoxUJz0CZFX5SAl2vOqZK+HQDOcbMxjUdZPrL1Eser6+QHW/lWz5wl+L3mR4H9A25USL
	d/UJSNOHCQ/XotgTRFql4dkprbgEW4U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=efPFpHYQ;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784126741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=keIhINC+VA871Ln1KapohfRN71O/agbmMSX+dc5P8RE=;
	b=suYGAUNYUAUXADIW46ULg/gdUG8IXI93KaaVIcIo5eBjy+/rVnDogrma9qffYyUcWcRnus
	qEhok34gBo3GGadUUnZep22swiU0/9K7bQzSD9eGBSmrtRB9VLFsLWzstvEYffaDbOjNSl
	E+DI0PzEKKF+W/BO3ysacMhX2KiTbFw=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784126738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=keIhINC+VA871Ln1KapohfRN71O/agbmMSX+dc5P8RE=;
	b=efPFpHYQe/nSz9XdIyoENtn8+CdURuOUWYnl95+Lftg7pdhFI2N8/wyWn4+j9MBc0PBS3y
	e489GVrwECSeqDhkTe2o8MY97hrD/z5/ft5LWbz3tTnMEJDeTbbSmMpiOnlQpyPMKHFAkr
	y6DSNcll+WXtdS9cptLkCNGSTlozjqY=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH 06/17] mm/sparse-vmemmap: support section-based vmemmap
 accounting
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <178409212283.638342.6610895811767474932.b4-review@b4>
Date: Wed, 15 Jul 2026 22:44:51 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org,
 Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <FB36B71D-0972-4EF4-9887-C765CAC33E12@linux.dev>
References: <20260702093821.2740183-1-songmuchun@bytedance.com>
 <20260702093821.2740183-7-songmuchun@bytedance.com>
 <178409212283.638342.6610895811767474932.b4-review@b4>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B366C10000B
X-Stat-Signature: eht3wazn3tznn5jopx7xhfhog9i83pgc
X-HE-Tag: 1784126740-497625
X-HE-Meta: U2FsdGVkX18dae63j0sWtbLXmvcr9Gtu9H5WMu8xC5BQFpuYu6WdsA3kZO1GPHw6KpKPHDaHKW/N2of5nxIhjLZwNPM+A8TQkJgP+UtLvJdS6Xfbq0Dfrnna7WEPL28xuMOhseQhEdYKVu8nwG97Q4qtbW6PWv1PLVToEN6X8pVi38GV66qqtJ62OfhP9Y74ZGQKChvrnPmb+Rf49W82zKLVKbGTJyqBab1U9gQ4lmGG+S1sirWsqL7cH+GSSEIJ9wQQ2SeFPSCUWkuCBi6ks4LJFSxIkFufZ1VbAWtG7S7M7eA45rxnlQepWVwPWCc0V9jUnOAFtpzahYHb/+f8L69uoRKLH928+XbTgo8zV+RAdgPFOxem6KQDJOIA7CRasNC5JJmuOMR7iJP5ecy8dKTc8dfVI/8Xgp2Eral794gabjuZXmlTIhLat2KBbm+DaFx3/kZFcQwCmbsD8sDkFtTEKIIp3olMqFWajG7wackUkj3VmDMas/V55lMFPD5veBhAkvgfvA13aC/0E5/8l8pdjdPWWX9d0V6hMABk+4FoeRkkLzkt+vZlARqVPzNCw658lOCbYGpVZ86Fpwh65QYCGKFv6A8aoatAdO1WhUtBfaa5ocTD1+fCsTFpZZh/LjKym6e/aJ5+e3i83XcoS0M1TPHhFxhvAxYfEfviNUPW+K1W8uCsV4c+srm7nPVvMR7M0QIkaCdCtSkxFNXckh9wF7cLxpoUwxqNc5K70/b8KgR4cwLFs7CptwwdlHMHx27Voj9O74vi5E6YoseTmsqq61CsSY6nG7Ayxhov8yYFlCwI7ORDL3pxRd461IsjzJWia335NnzEQiPp6BeZBrfMyLZU9HHg7BKRPdz1xgGM1X83n38iKM9vnxgG7evpWBYTsV5Oj2MtKHjkvtBaerT46T7GeNYwayFFX059hr+AiHUKeVqdxCF4ztJdTCNAmKXq4oRYoxXd2SjrgF9
 KDhcdy5z
 p9R4JUjWYsk9oGuZggJFiZZiq2WtH1dL0hEWajf4zKE8St8jrD7r6tKy9muWA5YFTAkPjEwMsiyJnKFn6dsXkXgcjkE+v4xWCzkEJXRYR9CU97YYl9Qpg+EwHJWmDYAzPKWWK3aQX31GDppQ/7S2j71Es5sBTZ3HCI7dK2v3zlaBCL3YP3k4soVDcPLwOh2bHjTPKRLR2XDiaFua3goMJPVpoO2oHHfMjsfdZhglvIbFFbYxeXa+NgRtta5slhUGnE2/i8mo+hELeV9ir2PXUqMiYcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 15, 2026, at 13:08, Mike Rapoport <rppt@kernel.org> wrote:
>=20
>> section_nr_vmemmap_pages() is used to account the vmemmap pages =
consumed by a
>> memory section, but it currently only understands the ordinary case =
and the
>> pgmap-provided optimization case. That is not enough for =
section-based vmemmap
>> optimization, where the compound page order is carried by the memory =
section
>> itself and tail vmemmap pages may be shared.
>>=20
>> Make the helper report the actual vmemmap footprint of a section, so =
it can be
>> used as the common accounting path for both ordinary and optimized =
sections.
>>=20
>> Teach section_nr_vmemmap_pages() to use the section order when there =
is no
>> pgmap, and to account only the vmemmap pages that are actually needed =
for an
>> optimizable section. This keeps the accounting consistent with =
section-based
>> vmemmap optimization.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>=20
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index 6fa6e7f0abf9..41a1ebbe5e85 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -2403,6 +2403,14 @@ static inline unsigned int section_order(const =
struct mem_section *section)
>> }
>> #endif
>>=20
>> +static inline bool section_vmemmap_optimizable(const struct =
mem_section *section)
>> +{
>> + 	if (!is_power_of_2(sizeof(struct page)))
>> + 		return false;
>> +
>> + 	return section_order(section) >=3D OPTIMIZABLE_FOLIO_MIN_ORDER;
>=20
> Like with page_vmemmap_optimizable() I think it's not obvious that
> section_order() is enough to gate vmemmap optimization.

page_vmemmap_optimizable() checks the optimizability of an individual =
page.
section_vmemmap_optimizable() checks whether the optimization can be =
applied
to a section. Some people may think that section_vmemmap_optimizable() =
checks
the optimizability of all pages within an entire section. You are =
referring
to that ambiguity, right?

What do you think about renaming it to =
section_vmemmap_optimization_eligible()?
Would that clear up the ambiguity? Or should we add a comment to
section_vmemmap_optimizableto explain its purpose?

>=20
>> +}
>> +
>> /*
>>  * Fallback case for when the architecture provides its own =
pfn_valid() but
>>  * not a corresponding for_each_valid_pfn().
>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>> index 77154e9da08c..99f59394feab 100644
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -645,24 +645,29 @@ void offline_mem_sections(unsigned long =
start_pfn, unsigned long end_pfn)
>> static int __meminit section_nr_vmemmap_pages(unsigned long pfn, =
unsigned long nr_pages,
>> struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
>> {
>> - 	const unsigned int order =3D pgmap ? pgmap->vmemmap_shift : 0;
>> + 	const struct mem_section *ms =3D __pfn_to_section(pfn);
>> + 	const unsigned int order =3D pgmap ? pgmap->vmemmap_shift : =
section_order(ms);
>> 	const unsigned long pages_per_compound =3D 1UL << order;
>> + 	unsigned int vmemmap_pages =3D OPTIMIZED_FOLIO_VMEMMAP_PAGES;
>>=20
>> 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, =
PAGES_PER_SUBSECTION));
>> 	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
>>=20
>> - 	if (!vmemmap_can_optimize(altmap, pgmap))
>> + 	if (vmemmap_can_optimize(altmap, pgmap))
>> + 		vmemmap_pages =3D VMEMMAP_RESERVE_NR;
>=20
> I'd put it below the next if ...

Make sense. Will do.

Thanks for your review.

Muchun

>=20
>> +
>> + 	if (!vmemmap_can_optimize(altmap, pgmap) && =
!section_vmemmap_optimizable(ms))
>> 		return DIV_ROUND_UP(nr_pages * sizeof(struct page), =
PAGE_SIZE);
>=20
> ... and make it
>=20
> vmmemap_pages =3D vmemmap_can_optimize() ? VMEMMAP_RESERVE_NR : 1;
>=20
> --=20
> Sincerely yours,
> Mike.
>=20


