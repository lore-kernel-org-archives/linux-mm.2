Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F29B606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 05:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=luoyeHPH
Received: by kanga.kvack.org (Postfix)
	id 63BC26B05F3; Wed, 21 Oct 2026 01:36:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EC7C6B05F4; Wed, 21 Oct 2026 01:36:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5032B6B05F5; Wed, 21 Oct 2026 01:36:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D9026B05F3
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:36:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 134481A02A0
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:36:31 +0000 (UTC)
X-FDA: 85345523382.10.F973253
Received: from mta1.migadu.com (out-34.mta1.migadu.com [95.215.58.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6C8E5120007
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:36:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=luoyeHPH;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.34 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792560989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o3QDH4GHZKZklfz0YvP98XXlcOQ9C0e/UzN3/wc5PoU=;
	b=4CzeSjiVulvqJAuaxuvc653uSzcly4B2unvSvfHu4gfaELjSvqp5Ca+eMEz8GQ+AtXyz2V
	1RZJrqIv0EHPm4Loxaex6hbhTkF+BuQHW+M74xsJLmkz8+Lf6gjSMLf4fijguwkpq2p5fu
	E7LBMXGf5GOLmZKZGhSbx/d1bc2rfU0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=luoyeHPH;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.34 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792560989;
	b=4B8292Nh4NXfMgY+TqmzUW+rMYTB/KAx57go5K233mm7eoMGA5CWxuwAHBVhT8pvvMzrqW
	CYvGaGKF+byBR/40uCwrQBmYbRjpbxriOlI14Iqwgs5TgIMC0M5rwBXVMCvz3lJ6JKD1lZ
	RVlTNaIb3JTkgpNiXwe8wuPcVTRDXuY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WRus9dGBDYjUeT/LwFm/stq6NmRjNXUQhGme5JxIkOY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792560982; v=1; x=1793165782;
 b=luoyeHPH6x3yhOyE2QrOEiKTsuLBH2bb4PQiEdYqtGEvh0MnnaAj9tJrZ1HAb9qYsR/qASIa
 5/u3IENo3j1lgFPUZgjyzZXsf8dzM+USSkRXGxSHBywXQcifyHvlfirzE0YNM/BfclNUKNi3lAs
 zpgrmirXOdkoONjWDJweCQ/k=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 3d92309cb2c66050;
	Wed, 21 Oct 2026 05:36:22 +0000
X-Mizu-Trace-ID: 3d92309cb2c66050
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 1/4] mm/sparse-vmemmap: map shared vmemmap tail pages as
 read-only
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261021045744.93554-1-lance.yang@linux.dev>
Date: Wed, 21 Oct 2026 13:36:00 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 akpm@linux-foundation.org,
 david@kernel.org,
 osalvador@suse.de,
 maddy@linux.ibm.com,
 corbet@lwn.net,
 ljs@kernel.org,
 liam@infradead.org,
 vbabka@kernel.org,
 rppt@kernel.org,
 surenb@google.com,
 mhocko@suse.com,
 mpe@ellerman.id.au,
 npiggin@gmail.com,
 chleroy@kernel.org,
 ritesh.list@gmail.com,
 sshegde@linux.ibm.com,
 skhan@linuxfoundation.org,
 rdunlap@infradead.org,
 qi.zheng@linux.dev,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <F19AE41A-8150-4444-B18D-824BB0CECB82@linux.dev>
References: <20261019090830.1917657-2-songmuchun@bytedance.com>
 <20261021045744.93554-1-lance.yang@linux.dev>
To: Lance Yang <lance.yang@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6C8E5120007
X-Stat-Signature: o5e8k76aej6auwzsoy4ebroxoyka94ci
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792560987-483736
X-HE-Meta: U2FsdGVkX1+cybmrThcCHpxo7alSUm2MSv0RgNInlj0vgkz4uq3B5ZugFqw80S57FxX7gQpLIozq0R8QoKDj+5k5hajrorClwQvusFLp3iln8qcJ7LhJ5hyPFOliczPsjI78C/iVLEHd5FP3sUi18IHu11HVa40++DsBqLxlgJ9wAEARTc2DV4BDVtoZ2QQcGlHo4WzcdNfCkQu9hYDMAix2QaqDMRFfuV3N2JiUkF3EXinlonOmnK9p+m4DxrJTbU1doqDMvt49/ZUQFQPrAwKVu+x1PSfsNAJpLk8ZR3ozdH+g3novRP2EEVw0yQJYsq1h/rE+pvbUxE6wrhYJvronXQiZniENVvj4mdpfe1QsdZa69yUz7R80SgDkIBNVR+UNR7O4LtQ1FCjZEAOO3QB7iV66/Hxdi+pypHRlYa0jePJf00Hgi+jrbOTNpLqmdvtlB6TJ23tPPD6Em/McNECI1h1YII+NTSvU4r0OQIK29jeM+03oaALzTb8nT9ctMZ2D7xuWlYOABLQag+tDOkA2fUkg9KGX9qnr7vUZ+NE+5EifB92AG0lF4h/lFPEa05/vtJTy8RX6IsNw4lXEyImkPMaFr/r5RlXVXm1BPZomwz4tLcP43YwhOYqYbK134WuHJOJljoqvrur182bT7aW1ZClCie43YhHoovx7KUfEWf9zof0x91zktqQDBr3OvzxvDAbhjV/4vupSbJYyKHMukHHgg2QSC9EysmJ/mPio9h9yhLutfhbRrwfcdaDfCUSj97C4KRcooB8lfjTSErQnRnOzRK4F/0XHLCe3Gj95YEhJGXogTL35CVITMC6NzKgy3uBCFP80Nj/TCFGWYpUw82s0JTDpSTipcOKQ1gK7NFXS3aCaa8ZPEmSy0igA82FFblkJ269BZ0yC3e8dhic8DIXBaAIwGWfyjkPDVKDgEIzmRif+7OdRqm8bJo1O1sbqicw7LjX7E2o9/uP
 KqzE1RET
 dZSVul0ypX6xlXbGcxenw0I9MBdHYQUDufMf0P1JkY/SmMPpXS3CwIVf8NYdsdxfXRQm/0bYqgqQIRhQ3BvK2XAv1pBkLuAPFUafqU8HWVqcDaopMqRUvsC38fHGXVE91R8hRsdaiiVZEmk/wIQuc0tj4OcTlKelv+AK4d24873DD5mZV57r5I8JOLa/7pWGBhSMW/NsKmbVanssvjFQVsxDlXP5kSnSN9FuzH/9jPLEtOKn97htPWzgF4zS4439CVcmYNOUEXpwWTMpqDAADzC8CrL3bLuWjHMktzE7UHqmjcKKR51A2TCUYj17cAWzKQmZScfLDm+nKcpK84+kEfrWAj4pSHhbESkv4CXhkvJR9XrU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 21, 2026, at 12:57, Lance Yang <lance.yang@linux.dev> wrote:
>=20
>=20
> On Mon, Oct 19, 2026 at 05:08:27PM +0800, Muchun Song wrote:
>> Both early HugeTLB HVO and device DAX use the common vmemmap =
population
>> path for shared tail mappings. Map these pages read-only so that =
illegal
>> writes fault instead of corrupting metadata shared by multiple tail
>> pages.
>>=20
>> For early HugeTLB, this moves existing write protection into initial
>> population without changing the final mapping. Device DAX gains the =
same
>> protection.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> Documentation/mm/vmemmap_dedup.rst | 3 +--
>> mm/sparse-vmemmap.c                | 3 +++
>> 2 files changed, 4 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/Documentation/mm/vmemmap_dedup.rst =
b/Documentation/mm/vmemmap_dedup.rst
>> index 8c287ae3f86c..76f903975a40 100644
>> --- a/Documentation/mm/vmemmap_dedup.rst
>> +++ b/Documentation/mm/vmemmap_dedup.rst
>> @@ -193,5 +193,4 @@ There's no remapping of vmemmap given that =
device-dax memory is not part of
>> System RAM ranges initialized at boot. Thus the tail page =
deduplication
>> happens at a later stage when we populate the sections.
>>=20
>> -Deduplicated tail pages are not mapped read-only. The mapping layout =
is the same
>> -as HugeTLB.
>> +The mapping layout is the same as HugeTLB.
>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>> index 40eba70c0048..ba0496daf4de 100644
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -295,6 +295,9 @@ static pte_t * __meminit =
vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
>> return NULL;
>>=20
>> 	entry =3D pfn_pte(PHYS_PFN(__pa(p)), PAGE_KERNEL);
>> + 	/* Map the shared tail page as read-only to catch illegal =
writes. */
>> + 	if (vmemmap_optimizable_pfn(pfn))
>> + 		entry =3D pte_wrprotect(entry);
>=20
> LLM pointed out that an AO MCE before bootmem gather could still reach
> TestSetPageHWPoison() on a shared tail, since the head isn't marked
> hugetlb yet.

Compared with the RO problem, a more serious issue may be
that the struct page has not yet been initialized, and the
MCE preprocessing flow may all be problematic, performing
various operations based on an uninitialized struct page.
However, this problem is not specific to hugetlb; the same
problem exists when CONFIG_DEFERRED_STRUCT_PAGE_INIT is
enabled.

>=20
> Wouldn't that trigger an Oops ... Anyway, I wouldn't expect to hit =
that
> during boot.

Therefore, I do not think this kind of problem during the boot
stage is a problem, because we have no way to prevent it.

>=20
> Reviewed-by: Lance Yang <lance.yang@linux.dev>

THanks.

>=20
> [...]
>=20
> Cheers, Lance



