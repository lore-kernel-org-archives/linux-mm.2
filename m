Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 894BE606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Dk66witd
Received: by kanga.kvack.org (Postfix)
	id 8D0766B05C3; Wed, 11 Nov 2026 03:32:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 881906B05C4; Wed, 11 Nov 2026 03:32:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797266B05C5; Wed, 11 Nov 2026 03:32:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DAB46B05C3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:32:36 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C27E91A019A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:32:35 +0000 (UTC)
X-FDA: 85422171870.15.9E0CD4F
Received: from mta1.migadu.com (out-223.mta1.migadu.com [95.215.58.223])
	by imf12.hostedemail.com (Postfix) with ESMTP id A4FBD40005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:32:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dk66witd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.223 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794385954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/GPPQeHUC5B+kqwljLDfgvXAOpL+49jyNjXeUp6zlqI=;
	b=w/AHQhyKekc/HGBe6RErcaCpzwNrdpX0rZt9Ydsb95A4q9jlqeM7hAZSKfvIf3bPffobdP
	wDCVIRLvSBflMa/U3j64wVyFHK4AJv4Xk2ZbvjzIk7seGfKs4N8SvdfBGbdTCbrznR2dwM
	3Bi6p34IVSQNGDxARDAio4HGe9dBwEE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dk66witd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.223 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794385954;
	b=SwRUTuhwKsG9jJNClUZNVQH50eFR6E/mOh0CWevRD+RpbSL4Xk3iONgp9XDuP6XywgOmr1
	DxH/Jb0GLO2C7/boau/kSoRVTwp17loOYdOTl3DIHR41kZjfRlDL1nxEOHMFJFkRnTVFIs
	298GlQ5MztT6b1VAA9FEkZA2ry5bod4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dhlpr5+SPOvUdYnN6WpqPYeLnGLPggshdzJrAywxpNA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794385952; v=1; x=1794990752;
 b=Dk66witdAsnLUiWP/E3/l0kL94BsXihMIlqqG2cGjwRIkFWQ8u71KHsxB3/+TAEpm7C2Jfxa
 piot+b6AIc7/7iCr+fpDbaJPprM5smshH5h4yfizXIT4uUdTvEDrlwrBTevXuQb+8sNWBEZOo08
 QCV+eO1DtIfh0J4p0Kulcc6I=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 91f71c34f96ac602;
	Wed, 11 Nov 2026 08:32:32 +0000
X-Mizu-Trace-ID: 91f71c34f96ac602
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH] mm/hugetlb_vmemmap: fix PMD split TLB flush race
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <sashiko-outbox-206969@kernel.org>
Date: Wed, 11 Nov 2026 16:32:14 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Joao Martins <joao.m.martins@oracle.com>,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C58DC8B2-F2F6-49F0-A9D4-079FA66B69C9@linux.dev>
References: <20261110112456.62827-1-songmuchun@bytedance.com>
 <sashiko-outbox-206969@kernel.org>
To: sashiko-reviews@lists.linux.dev
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A4FBD40005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 5u3ag68fgmb1nkyj8k96dgou1yd5xwk3
X-HE-Tag: 1794385953-626630
X-HE-Meta: U2FsdGVkX1/vInd5yp1EU0/NF4H7nDtf9X8RYATRAjpYVDDVEKWKzWhUUpnUN8ZVjINFkiRdGhVREOs2X8acoXt6rTyLReU+m9HQU3UHDHlBGP+7/Jrz6wpZSZRxPuVruhWG1b1SNHQz1DAuPKbuVzGA7ljNALQ6kqAS0A5201NWYLYVwug5d4maYn7FyUbm2/wTYTz0lHjhEOCrcLYQLpFXETN8k0/26sr0ZDWIwHAVHWtPrTe0uaifKPa36XAVUbHQypKfIk4rxp2SIaBOT+c4bMzg/2y/I/zj66FmXrK5GEoDwtShs4BdPftx4fGu03OqL4+4ibifq0bbxNNEwO/G++yowe1+MxP0sPLi16GV0NqKpCUYCMUQb40g586IBUaq2WoL2njiSlX0tHVVuaaVq32vO1/1wHlL3GThf5f/wOB7OliUUcaFl6ndTcZOTXIp4vvGTuTfgTK1I1dHVsFyIJuVFN0OgPTl0AHpdzezB6vOtGV+DIPH9WVsXpK3yJKLEasuduGNlABCR87jyW6t0MQLqOXMp7/tSjbzVa1gPaKJDxTTIlrvG/0lXJSjKmmj+s4kV0icGZVL7R2q9sWovyeiEp53qs69At+FTfZYth8hs5TkuLcVyJZorAMqoVLqZ2jOKbPytxm9uqnUKD5Cn1j/LbpqabEd57oY5pl9dX+RIzWLU5D/wAyrZqjZDhdSNhPzw/hpnDYW/wkWBrSKOTnUxWIBtufdRHGBggkLZzlNSBDnC7oHVqmzD/nMCx+aTGdrsX0q6XME5Yl5s+OeZlqOYlmzpjKL8UnmgCxIfr5/q5Wxp2Tw2h3joH7zlHV/40vBWmYCSCu+BjFG6UsIUUr/W2dYHGd6kvv2vl7YeGYvdiOQZG5Pz39anTw2Bdj5niInVt5aM63mdqh8z27EkUH4H+wc7sikAR0UjYcmpfMHCwWPj1Z9RFo+5aP2igRfsaU0PBxp4Qz3azz
 2zZJZSIE
 PRm2Q9NFUBiMEZaMA+HgoEpIX+ANY+cxBAkGxrq86ecHsXuj7FLNnU0Qlth+8CFhe+z2WkLUlLJFNw2z+jdctnwYUsGHbA9EmlULOltkk+09ZSD8N+gNGITbgEEh9pdbuUiHWGJAKn/nTcHs7YFwVFWStSy2LCVqcyxkclUaF1a/ptup931WbHVjIVQHtyXrcvNUWl3M25ZZOaiyyC5STDizoA4h+NvnSgOKBLBSrsUlqvyy7dK7FrgByPzCK6MmQt8Bm2w5Y5242ADQRh0BiXCuXkbflVdWdsLOMsfqjBLHV7qRGwTuonglqxfFlpW7sTYX5O4PC7mJVfoVMffzqUmb1DbysL/Y23L07KTxiuSCIfFoHyP9/PTagTuZ5F34HyJkgDwKzQqMVFDydyxJqUCIfgROZKova8yIY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 10, 2026, at 20:01, sashiko-bot@kernel.org wrote:
>=20
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] mm/hugetlb_vmemmap: deadlock from GFP_KERNEL alloc under
>  init_mm.mmap_lock
> --
>=20
> commit c4de2ad9c999ebd1524c99a20d1c19a13ab7ec8f
> Author: Muchun Song <muchun.song@linux.dev>
>=20
> mm/hugetlb_vmemmap: fix PMD split TLB flush race
>=20
> This commit serializes batched vmemmap PMD splitting and its final TLB =
flush
> against concurrent PTE remapping using init_mm.mmap_lock.
>=20
>> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>> index ba8e11e399b24..ba6559bef742a 100644
>> --- a/mm/hugetlb_vmemmap.c
>> +++ b/mm/hugetlb_vmemmap.c
> [ ... ]
>> @@ -559,6 +565,7 @@ void hugetlb_vmemmap_optimize_folios(struct =
hstate *h, struct list_head *folio_l
>> 	if (list_empty(folio_list))
>> 		return;
>>=20
>> +	mmap_write_lock(&init_mm);
>> 	list_for_each_entry(folio, folio_list, lru) {
>> 		int ret;
>>=20
>=20
> [Severity: High]
> Can holding init_mm.mmap_lock for write across =
hugetlb_vmemmap_pteify_folio()
> deadlock in memory reclaim?

A valid point, I'll fix it ASAP.

THanks.

>=20
> hugetlb_vmemmap_pteify_folio() walks the kernel page tables and calls
> vmemmap_split_pmd() -> pte_alloc_one_kernel(&init_mm), which allocates =
a page
> table with GFP_PGTABLE_KERNEL (GFP_KERNEL).  Reclaim shrinkers such as
> ttm_pool_shrinker_scan() take mmap_read_lock(&init_mm) when restoring =
direct
> map attributes via set_pages_wb() -> change_page_attr_set_clr():
>=20
> hugetlb_vmemmap_optimize_folios()
>  mmap_write_lock(&init_mm)
>  hugetlb_vmemmap_pteify_folio()
>    ...
>      vmemmap_split_pmd()
>        pte_alloc_one_kernel(&init_mm)  /* GFP_KERNEL */
>          <direct reclaim>
>            ttm_pool_shrinker_scan()
>              ...
>                change_page_attr_set_clr()
>                  mmap_read_lock(&init_mm)  <-- self-deadlock
>=20
> Because fs_reclaim nests outside init_mm.mmap_lock, this also triggers =
a
> lockdep splat on the first vmemmap PMD split (including under
> mmap_read_lock(&init_mm) in vmemmap_optimize_folio()) and can ABBA =
deadlock
> against kswapd.
>=20
> --=20
> Sashiko AI review =C2=B7 =
https://sashiko.dev/#/patchset/20261110112456.62827-1-songmuchun@bytedance=
.com?part=3D1


