Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E1DFD3C527
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 03:40:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FBD26B0006; Tue,  9 Dec 2025 22:40:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 785206B0007; Tue,  9 Dec 2025 22:40:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64E696B0008; Tue,  9 Dec 2025 22:40:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 504346B0006
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 22:40:52 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E35F2134841
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 03:40:51 +0000 (UTC)
X-FDA: 84202159902.16.EFBE1E9
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 20ABF140003
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 03:40:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vdGc9NdR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765338050; a=rsa-sha256;
	cv=none;
	b=F3eNQ2AWjYJ2GRdu1PaGJSXXJqnh78jrgTvYQkz8vqtR2Fulr/ec8VrI0kOAqOFOUfPjgZ
	DX8gcz2oB9J+LeaLVlvl/CchRc8fDrEMIxwEX8sUPuikCOwDSzzFZyfrx8+CqcIyVu8rHh
	4F890Q/TGQlit9mRsVQlq56kYORIMMQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vdGc9NdR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765338050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IahRfcaN/wS2F2zk9l8Y+MJaaILKyAdPoMXUoKo0oyI=;
	b=g9i9xdObqOTkywLQCIQ8b2RiCwA6YQTfvO8qahLfO3L9xQ4/zEyfx0K9Nhux6QUW1S/RZh
	AxoURhShr6gLqm9719qWmEd0IzCOf6YN/6MMim9iD8PFNLbSCmZyWnPjac3zF0Orf/WAJD
	DlX+wFZg15fEF1FFt68p8Gj8n4ePUck=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765338047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IahRfcaN/wS2F2zk9l8Y+MJaaILKyAdPoMXUoKo0oyI=;
	b=vdGc9NdRghRFW2WaxuBMxyBRdc7LD97X3/mLwh/Fq9xTvIPkoFOgRVcgW9iXUb83kxN3GP
	SHStxRL9KXc6pq7Zj/MUAPXKmHvWlozOKiLi/iyMAAwhxIcbBGXLZgJlrjnPcuRo+i1lYQ
	KzUmk/xoVjnRUbCu1Gz2BVLPzgsPhdU=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCH 00/11] mm/hugetlb: Eliminate fake head pages from vmemmap
 optimization
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <m63ub6lxljw7m2mmc3ovbsyfurl7hp4cvx27tmwelcxxrra5m3@eva5tqcdjxtn>
Date: Wed, 10 Dec 2025 11:39:24 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Wilcox <willy@infradead.org>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 Usama Arif <usamaarif642@gmail.com>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6396CF70-E10F-4939-8E38-C58BE5BF6F91@linux.dev>
References: <20251205194351.1646318-1-kas@kernel.org>
 <4F9E5F2F-4B4D-4CE2-929D-1D12B1DB44F8@linux.dev>
 <m63ub6lxljw7m2mmc3ovbsyfurl7hp4cvx27tmwelcxxrra5m3@eva5tqcdjxtn>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 20ABF140003
X-Stat-Signature: orj37m3gyhi98oar5ddfh94yqwxkk9mc
X-Rspam-User: 
X-HE-Tag: 1765338049-328450
X-HE-Meta: U2FsdGVkX181VGZOOJi7Q7i1HR9WeQS3jrsq/Xu/PBNoFVoNuUbl7wa1Qvzg50iEXG+mQTW430e8ntJBQdyxDuEHeC5ogvTBt7VAla75GVngyMYRS9XnXIlFs1ampAL6wbDBag2zWmFlhiO9NmPdN4Sb81UCem4vgfign2dwmi4SrFikIK7zawvaBznB3rgqmv1lnERwPjn/bp26TOSfyDQ7BstjlXeVE+J6ji0iPbU+8PteRmQcPbfrUBC5keSLELdSQVNJMEgGxu8gvBUsGXjz6a4BNAHfjyhgXAzNG/iEafZ9PO31ss94yLX+g0OQduLuCwxQskdZ4ZFKH/8+ANNlCOSYNyJJopCWpTF8s+Qqef+GUqnwWwPDvOOm9OwoyLjlKMRw744Nnau4XTjJozVKD3c2pJlnodT9SXxodH3D76Wqnub+Ajjqy7Ag761NLdOgRXPcgM1IBy3SmXsNhTW4ADGb5VPA8wkOxiaDcQZUJkAmtzb6PEPScoOPu5FPf6E2FW1jM+VJwGMqflOD3CC53JnnepBgRRYhPIMcHhpZx6TeRcQPQE4Nl9BoV6x3Fhv/WvNuJAJgtF8j7RA7Ebt85wpGLgSUDVf4vXasSB6Sbpl8ImG6TG3xaYSfvnGm2y5e6DM4DSf+4qNkEEOuuGl5qeAiYs1+nBn9ROGIurRCDqnlT9n06P38X+k+vKT7NriS6fT7/BODJkClgq3pTA7U0vSPucnfDY23Qkl5mNfdTGrbDiTJL0izscyoBqBSoPTf4dmMBrqGfAR9ANRGZJWjvwNqoA5C6VORE9WCreY/tar3iU/BbJkXOP2TwCKdBirD3LQGlzyC/mQEDmYOQuwfoAw3fSgMyJYG5zhHb84d2dRuvQY7rti9RXtD3S5YfU33gJUzfTBDyGont1sPBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Dec 9, 2025, at 22:44, Kiryl Shutsemau <kas@kernel.org> wrote:
>=20
> On Tue, Dec 09, 2025 at 02:22:28PM +0800, Muchun Song wrote:
>> The prerequisite is that the starting address of vmemmap must be =
aligned to
>> 16MB boundaries (for 1GB huge pages). Right? We should add some =
checks
>> somewhere to guarantee this (not compile time but at runtime like for =
KASLR).
>=20
> I have hard time finding the right spot to put the check.
>=20
> I considered something like the patch below, but it is probably too =
late
> if we boot preallocating huge pages.
>=20
> I will dig more later, but if you have any suggestions, I would
> appreciate.

If you opt to record the mask information, then even when HVO is
disabled compound_head will still compute the head-page address
by means of the mask. Consequently this constraint must hold for
**every** compound page. =20

Therefore adding your code in hugetlb_vmemmap.c is not appropriate:
that file only turns HVO off, yet the calculation remains broken
for all other large compound pages.

=46rom MAX_FOLIO_ORDER we know that folio_alloc_gigantic() can allocate
at most 16 GB of physically contiguous memory. We must therefore
guarantee that the vmemmap area starts on an address aligned to at
least 256 MB.

When KASLR is disabled the vmemmap base is normally fixed by a
macro, so the check can be done at compile time; when KASLR is enabled
we have to ensure that the randomly chosen offset is a multiple
of 256 MB. These two spots are, in my view, the places that need
to be changed.

Moreover, this approach requires the virtual addresses of struct
page (possibly spanning sections) to be contiguous, so the method is
valid **only** under CONFIG_SPARSEMEM_VMEMMAP.

Also, when I skimmed through the overall patch yesterday, one detail
caught my eye: the shared tail page is **not** "per hstate"; it is
"per hstate, per zone, per node", because the zone and node
information is encoded in the tail page=E2=80=99s flags field. We should =
make
sure both page_to_nid() and page_zone() work properly.

Muchun,
Thanks.

>=20
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index 04a211a146a0..971558184587 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -886,6 +886,14 @@ static int __init hugetlb_vmemmap_init(void)
> BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
>=20
> 	for_each_hstate(h) {
> + 		unsigned long size =3D huge_page_size(h) / sizeof(struct =
page);
> +
> + 		/* vmemmap is expected to be naturally aligned to page =
size */
> + 		if (WARN_ON_ONCE(!IS_ALIGNED((unsigned long)vmemmap, =
size))) {
> + 			vmemmap_optimize_enabled =3D false;
> + 			continue;
> + 		}
> +
> 		if (hugetlb_vmemmap_optimizable(h)) {
> 			register_sysctl_init("vm", =
hugetlb_vmemmap_sysctls);
> 			break;
> --=20
>  Kiryl Shutsemau / Kirill A. Shutemov


