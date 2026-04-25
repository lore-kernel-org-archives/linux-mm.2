Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11311FF885A
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 03:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14E846B0005; Fri, 24 Apr 2026 23:06:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FF9A6B008A; Fri, 24 Apr 2026 23:06:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 014386B008C; Fri, 24 Apr 2026 23:06:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E42EC6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 23:06:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C04691B6E83
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 03:06:20 +0000 (UTC)
X-FDA: 84695589720.06.1A5B098
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id A10AC140002
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 03:06:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B19j9Sh9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777086379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LS6FCqD8VSXr924Q4YkPV/vRhy4BlRM8EbIWjkTCfxQ=;
	b=z1n1I+wreCDJ/x3IISM4QN3Fx4lLgrY/H9z6r5COvv/xSrrJaXmAUeK7U4WFhpncYFfsb9
	20T3KwIhcffZrC9944k78mjDNMTG4bIcQ7GEQwxlA9apE3fYF5/tPWIDL/B6SxV7+SCx0x
	AK4WMmE6YaPhjeRhtpkB4Nuz19Vai6I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777086379; a=rsa-sha256;
	cv=none;
	b=T6pzJv9bC2i61YMfIPaxVXql5yvKhmxXMQX5lcLnUbXOKIu5aStOoIesi7NJ9y17CBOwoB
	QPTxBoC6bbshdWhN9PsxWKorPLZ/pAffT0mXu4lQfgP86twfYYQv7koXdkwh7lLAXm03Fu
	ohdTkBoC4DPhpeh9pGS8C2kTP5kJBBE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B19j9Sh9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777086376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LS6FCqD8VSXr924Q4YkPV/vRhy4BlRM8EbIWjkTCfxQ=;
	b=B19j9Sh9uoyXQoT2jp7I4pOlIjQZYabWyU3GKN59qbm6g12VJj3lhVYjDoCrWYP4/xTSij
	gLNZZdLCkzFGTjkwSlTZuOJUQWEfwwmKiZ0zKs6/nksrzMF/ZYksFvgyyNoBbjTnjk9Q+h
	W1DXvgmK08TwKJnZu+cKBozIo3rbYpQ=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v6 4/7] mm/sparse-vmemmap: Fix DAX vmemmap accounting with
 optimization
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <0fe62163-cdfd-47e4-bc88-df7a69dc5a6d@kernel.org>
Date: Sat, 25 Apr 2026 11:05:38 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4C6CE53F-918C-4D03-9DBD-1745E28A2D9E@linux.dev>
References: <20260424025547.3806072-1-songmuchun@bytedance.com>
 <20260424025547.3806072-5-songmuchun@bytedance.com>
 <0fe62163-cdfd-47e4-bc88-df7a69dc5a6d@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A10AC140002
X-Stat-Signature: 1hukj5rgi4zio4yj8wsjx9iyo9gdxdq7
X-Rspam-User: 
X-HE-Tag: 1777086378-417173
X-HE-Meta: U2FsdGVkX1+hq583X5fmhOcJDlhj16MXzxTLGMeQHQEfL4d8uu1efV8MXx3EvKoWIbaD86g3jj5MKIYXzYyE817lops0wI3ZGJ3GahBto7bNJwiQWnwZ7D6+SUG3oAJNe22LbaS9jep4xSFPkwsymDlH24XQ6VDQhfuvfF7r1LBArKH8Fj3tpuZiePb+BpYImxE5Gvw+hYeFEfEmFNpQtOyL85gyX0uPFxQ4lOAJgNvXporTyWb6+kgw/1ZWeYD9y6IDxwdh3KCO53kJxZ7Gm+awIcAz+YuyYqIHX5InpEQncK8ddquZwKHEagEwsRDyRJnAuxdJjpcHLpd6TzMQHWu/UHY/boDCiJpl1vXTalLAMB0F41kzxw9BsVb8Hd9081g0LPGSi063+uqY986k6lt0E9l/EKC7uPQUMo4oP2X9OthjhYuFniHkwqYsWjWHZ5r1kix6mUQELqPwB7+tCVBldfFj12rmdVPKoUGDEQgIOQPZNxPsd2S9rwMBAkid8KowjJKjm+JUJb5/KrOAVb0zVpDE8qYfIx8F0HteGz6kolAtN/1/gLY3d/iGcaaTOpOUImGMC+xmP3+AqzAowoQ96bMvpe1DxLcQKrLeY4hQaweFRgcA41Czci6serRt7R2sNiqzVx/J7Wqhm+24zZDec+Fi2jdJ77CxZq7fM4RN52cueLrndDSURlB///7R3e0oZPd8HhHCX1Bu9IoPAGdzyM5GOHNmw6oEa7KkyqBqSItdYIZaQwCUGWgjNh956C7dKTbxxibMhCGLIK+fm0GD6feVFEeyaMj9iIQr9ig6vn7XWVOvfedLQ1Mr/XdABPnVoV6Ib00au+Jd9Y1RsK2oQIJM9Zcjp4llcvO3HvhEb6n8t3bRNmrbTDW7e1fsRnpTyqHGvaslsHbVYwbX9wIf/UgtIIN/YZhgjWu9nnbPq32OpN0svFO16XTiA8D+6OMtWnOPYz/BjV1t57b
 dt6svHPT
 sFlKRbfhiTFpf8fsC3dK0gCgbJpy8mGKtkzbaP9IvDdx+1xQ7v8I94U4FFwOHJB3RHwbRdxIGtg5rOUk8qGpkbGug+Pnt3mrxWTh23vLoddGqIAYI9129HFB4RO5EmuNnATFjFOvGJzfoBXVTpWIt6fOqrmew52oYY8DIlZhjOlxFLRB1VBlNbr4NXXElcL9hKCYIx6kMbLMFtlAcmmAwBMVHEn6x/zz7cEgE27A1AZna2GHwNFTVctuZuZe/o5Aagtxv6Khs2ohuizgw1vd8Er7yOaP5NlIHe/W9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 24, 2026, at 15:33, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 4/24/26 04:55, Muchun Song wrote:
>> When vmemmap optimization is enabled for DAX, the nr_memmap_pages
>> counter in /proc/vmstat is incorrect. The current code always =
accounts
>> for the full, non-optimized vmemmap size, but vmemmap optimization
>> reduces the actual number of vmemmap pages by reusing tail pages. =
This
>> causes the system to overcount vmemmap usage, leading to inaccurate
>> page statistics in /proc/vmstat.
>>=20
>> Fix this by introducing section_vmemmap_pages(), which returns the =
exact
>> vmemmap page count for a given pfn range based on whether =
optimization
>> is in effect.
>>=20
>> Fixes: 15995a352474 ("mm: report per-page metadata information")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> Acked-by: Oscar Salvador <osalvador@suse.de>
>> ---
>> mm/sparse-vmemmap.c | 31 +++++++++++++++++++++++++++----
>> 1 file changed, 27 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>> index 3340f6d30b01..2e642c5ff3f2 100644
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -652,6 +652,28 @@ void offline_mem_sections(unsigned long =
start_pfn, unsigned long end_pfn)
>> }
>> }
>>=20
>> +static int __meminit section_nr_vmemmap_pages(unsigned long pfn, =
unsigned long nr_pages,
>> + 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
>> +{
>> + 	const unsigned int order =3D pgmap ? pgmap->vmemmap_shift : 0;
>> + 	const unsigned long pages_per_compound =3D 1UL << order;
>> +
>> + 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages,
>> +    			min(pages_per_compound, =
PAGES_PER_SECTION)));
>=20
> FWIW, I though the right thing to do here would be:
>=20
> VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound);
> VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION);
>=20
> I don't really see how PAGES_PER_SECTION make sense given that
> PAGES_PER_SUBSECTION are the smallest granularity we allow =
adding/removing.
>=20
> Also, the "min()" implies that there is a connection between both =
properties,
> but there isn't to that degree.
>=20
> If order =3D=3D 0, then you'd only ever check alignment for ... 1, not
> PAGES_PER_SUBSECTION, which already looks weird.
>=20
> So you really want to check "max(pages_per_compound, =
PAGES_PER_SUBSECTION)", but
> just having two statements is clearer.
>=20
> Or am I getting something very wrong here? :)

Hi David,

Sorry, I missed the 1GB hugepage scenario earlier. Given that =
sparse_add_section()
operates on a scale between PAGES_PER_SUBSECTION and PAGES_PER_SECTION, =
the pfn and
nr_pages parameters wouldn't be aligned with the hugepage size =
(pages_per_compound),
but rather with the PAGES_PER_SECTION boundary. Do you think this =
explanation makes
it clearer? In the interest of code clarity, do you think the =
modification below
makes it easier to follow?

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 2e642c5ff3f2..ce675c5fb94d 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -658,15 +658,18 @@ static int __meminit =
section_nr_vmemmap_pages(unsigned long pfn, unsigned long n
        const unsigned int order =3D pgmap ? pgmap->vmemmap_shift : 0;
        const unsigned long pages_per_compound =3D 1UL << order;

-       VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages,
-                                   min(pages_per_compound, =
PAGES_PER_SECTION)));
+       VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, =
PAGES_PER_SUBSECTION));
        VM_WARN_ON_ONCE(pfn_to_section_nr(pfn) !=3D =
pfn_to_section_nr(pfn + nr_pages - 1));

        if (!vmemmap_can_optimize(altmap, pgmap))
                return DIV_ROUND_UP(nr_pages * sizeof(struct page), =
PAGE_SIZE);

-       if (order < PFN_SECTION_SHIFT)
+       if (order < PFN_SECTION_SHIFT) {
+               VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, =
pages_per_compound));
                return VMEMMAP_RESERVE_NR * nr_pages / =
pages_per_compound;
+       }
+
+       VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));

        if (IS_ALIGNED(pfn, pages_per_compound))
                return VMEMMAP_RESERVE_NR;

Thanks.

>=20
>=20
> --=20
> Cheers,
>=20
> David


