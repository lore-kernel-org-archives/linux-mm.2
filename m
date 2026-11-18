Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F024606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q9zFQRMF
Received: by kanga.kvack.org (Postfix)
	id 5AAD36B00EF; Wed, 18 Nov 2026 10:59:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55B6C6B05B2; Wed, 18 Nov 2026 10:59:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 470C86B05BC; Wed, 18 Nov 2026 10:59:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 130126B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:59:09 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 92E70120573
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:59:08 +0000 (UTC)
X-FDA: 85448698776.01.E8136F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id F0DC320006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:59:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q9zFQRMF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795017547;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pWrk6vf2k3AbshFjf0BbK/R6P7Yi6LZ89zMfgvqB8b4=;
	b=JKFYKEHp5GPFOAOT9ucRQ4v/pd1iJJNETtLDzyqIRADoX9Hpq4GyhwExbynZsmocfd8XWY
	dLaysK4IlWSE+4E+TXxhG/JPz3lP1YWSfx/y6N4FybcEU/NKw+GDnpjz1Q/rCNfPJivarJ
	5VYTTZ697GL4bxO5aAiiRi5eWWj++sA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q9zFQRMF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795017547;
	b=QIbK+jbVDvaRQFW+xNsxbSh6zCgrzitcquGwzo9pO5PXecnTHtSgtYFnIPgrNtByX7C2SZ
	2vmdEQ+NCczqm1MfigcYeZw1ELQsbsc0CietuzZ1qKwFK/zrnEhH6qLVH82BtXUP28TgJA
	Licf1hEKHgHiqIcdfZAx1rjEw1S2pOk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C689962696;
	Wed, 18 Nov 2026 15:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59491F000C7;
	Wed, 18 Nov 2026 15:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795017545;
	bh=pWrk6vf2k3AbshFjf0BbK/R6P7Yi6LZ89zMfgvqB8b4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q9zFQRMFQ6HhV2DEkrOYaXCITbUEUnPtKJBsai1kVu/Su8CzrFDxpoHwiKFUxINLH
	 LOKZzygkh6GiLluWkTubijMFRzzPeK7okMJDYTzhGAxoRteJHi77VXtTbQ9lcoADxu
	 XaOIgVc4FuKCLi6tqtfSaNR3DC0n83CUUJfzS5DHLagjkZ9XmUxdPnUDh2Y8QozkPw
	 +54+NQ8NQovsa4UNy88VbvQlsbMmpnrW4sET3T8H9nWlnglf6MXz+ocH/NCS8I4+pg
	 TL9tptDlaSbSzx2TNLWTLZhLt5p3rFqIXZov7pO9ZLdQu5514XYnTLRwOLzP7jJbnD
	 Qx8aWT80MYjIA==
Message-ID: <sashiko-outbox-221396@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] mm/memory: replace uffd-wp markers in
 insert_page_into_pte_locked()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TWlrZSBSYXBvcG9ydCAoTWljcm9zb2Z0KQ==?= <rppt@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>
Cc: "Jan Kara" <jack@suse.cz>, "Jingyi Sun" <1045704958@qq.com>, "Liam R.
 Howlett" <liam@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Michal Hocko" <mhocko@suse.com>, "Muhammad
 Usama Anjum" <usama.anjum@arm.com>, "Peter Xu" <peterx@redhat.com>, "Suren
 Baghdasaryan" <surenb@google.com>, "Vlastimil Babka" <vbabka@kernel.org>, linux-mm@kvack.org, nvdimm@lists.linux.dev
In-Reply-To: <20261117-uffd-dax-async-wp-fix-v1-2-c9a30f27f452@kernel.org>
References: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
 <20261117-uffd-dax-async-wp-fix-v1-2-c9a30f27f452@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 15:59:04 +0000
X-Rspamd-Queue-Id: F0DC320006
X-Rspam-User: 
X-Stat-Signature: f79zwhrnmd5714hsuz8xmwux3nx7bnwe
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795017546-973388
X-HE-Meta: U2FsdGVkX1+Uip0PyyY9AIdfxBmdPpGqdtWhsuArZSEA19xFuRxQudu+LzHCcHgSgzVW8TzUKYPRFD0jFKQyvzr9KWCbLlvfhZg+V0xaNp+ZPMojUax0oYoffvXYzPjl3K+BkOjw1ltbBt+gAJo7k3tsUuEF+S7vVan4OExX+n7pmOixMFunSRxB7gktAUvrWFbauhjmcrqDgUrSLkcoz9z/1YcObokg6p2aHNGHJ+s1iAIT43Bztu5qgBZWG/PHeWYHScMqKJzDODH6n1oZikqzYPcxsZ5G1HOjZMvYmgzgI4R1L9bXB2rVk8wCNVlgH4ralT9E787lJBUIwn1uraCE0nV6z6+QYroN54ih0IXo8EJhoktN1hcUULGXpoO3A+8LHaNu5aFi6AD651gBZiN2qmt4MGx8ZVF/naAyjpoWU9gwowM9leb1l3ZqEIOQ5clHWwYyAmswpxqWHNUmcGt5TbCHHFC4DW/YGy435NMSjc7Em34OGKCYly3DWZVdTGf7BG6zhjOqG9/hqQFxXioXXxtmjtqfQd9IaR20n6iqhKUKa5W28Fnh32LkvRoMb4jsKpkp2DIEBNE5S64Xt3yJjDVJH8r/M1LP40MCVndWJnfIQIje2EvBF/yB4Hpv4+6s3LUYmYwTnfusBqL1NGuPl2B0kAsX7OVSoUyg/jvz/WvlJbDF0AC6jvO6kPzFEuICjwztLBrZbd4MESjYuci5LwTQMKpgIUq2O0jy3BbexsQze/ye5U0LSjG4GYcBTn4WHsEHVuIALG+7vmLtnJM1D9CuXOu5InEALEka0aRQj0wIV0pFXdaYa6BrDwqfS2PW20GwrKq173hvFCPgSRsaUHBFaCFtWgR6Q4xA05IQn+QxM3PtIRIK2xIKSMv9ePh2j4XEaTc37qeuq2K4kYR+Y6BXQigZRyvPe6J04HW/OTGERLnc1wB0/oy6f9YCoCieM7O9j/CrOayronk
 ErajMbDm
 9QDd3W8DoQdWlxDvfaTFlt/QNbLKe6T11VqaCVFebaOPjJjeIDNuJGUJ8yx0CzvJcg+Z1BNvo/JDDxbIw6lUALB5+xEMvALEVTTlNtAvzbjtK6h9kF4xVfTYYquoKnWdj1GDB7s3XLVcLJj6KFcdfkALZvwLAJOz7NRdY458A7nUOt2ptO33BSeDsPMq1r4lF5/DaXB/yFoD3VREBfOFOhAPA/7Y8fniyITVK58FfT9g4NAGoIHI4fuaWu3b+mmTteyCZsNelQuD09fJ4LjKjdJUFx2HojGQjqvJ129DGl/fMRMP5q9ldh/ZjHBxPb6LwO/R0bV27nta8j9FhgZRPtW7QL+Qyfrxp0vVJBopVuKMP6Uj2PWsuIh70aTam24cjOYWmCI6wDtcDQyDAZ7c6QQJs65IPL+gWnWNlMKzBHHC1IuwcgJhnWOd6BqNde7xru9t7kt4iBXSG7xbXvNq80RJWJbkv3FrhdCclaV/LhmfPOqqXWbkw3tBYms0aHBwmuucDsxlnrmm40ZteDWhv1cN01FIhWQMWdWf1l/iN9dwgJFCaltq0AaXpWTNgd1qJUezRHQa8dUqx35j1DPUMQIj3Y64GIgdb90O9tka+pzxRFjhCx2+2m2Jrj6O0plVT8kex1odZTBX+CTp8SH3BXm5RiomqooO67ZDmpM/H4Aak5+o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm: uffd-wp bit not checked on mkwrite in
  insert_page_into_pte_locked()
--

commit 6bd6838d9e7f98f448f46bdb05cc4400045f49f7
Author: Mike Rapoport (Microsoft) <rppt@kernel.org>

mm/memory: replace uffd-wp markers in insert_page_into_pte_locked()

This commit updates insert_page_into_pte_locked() to replace uffd-wp PTE
markers with a new PTE that preserves the uffd-wp bit when handling faults
on DAX mappings.

> diff --git a/mm/memory.c b/mm/memory.c
> index f927f2241e404..66ad58429967e 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2452,8 +2452,9 @@ static int insert_page_into_pte_locked(struct vm_ar=
ea_struct *vma, pte_t *pte,
>  {
>  	struct folio *folio =3D page_folio(page);
>  	pte_t pteval =3D ptep_get(pte);
> +	bool uffd_wp_marker =3D pte_is_uffd_wp_marker(pteval);
> =20
> -	if (pte_none(pteval)) {
> +	if (pte_none(pteval) || uffd_wp_marker) {
>  		pteval =3D mk_pte(page, prot);
>  		if (unlikely(is_zero_folio(folio))) {
>  			pteval =3D pte_mkspecial(pteval);
> @@ -2467,6 +2468,8 @@ static int insert_page_into_pte_locked(struct vm_ar=
ea_struct *vma, pte_t *pte,
>  			inc_mm_counter(vma->vm_mm, mm_counter_file(folio));
>  			folio_add_file_rmap_pte(folio, page, vma);
>  		}
> +		if (uffd_wp_marker && userfaultfd_wp(vma))
> +			pteval =3D pte_mkuffd(pteval);
>  		set_pte_at(vma->vm_mm, addr, pte, pteval);
>  		return 0;
>  	}

[Severity: Medium]
Can a concurrent write fault in insert_page_into_pte_locked() mark a
present uffd-wp PTE writable without clearing the uffd-wp bit?

DAX fault handlers serialize on the DAX mapping entry lock in
grab_mapping_entry() and only acquire the page table lock inside
vmf_insert_page_mkwrite() -> insert_page() ->
insert_page_into_pte_locked().  If a read fault and a write fault race on
the same uffd-wp PTE marker:

CPU0 (read fault)                 CPU1 (write fault, mkwrite =3D true)
dax_iomap_pte_fault()             dax_iomap_pte_fault()
  grab_mapping_entry()
  dax_fault_iter()
    vmf_insert_page()
      insert_page_into_pte_locked()
        /* replaces marker with
         * present RO uffd-wp PTE
         */
        pteval =3D pte_mkuffd(pteval)
        set_pte_at(..., pteval)
  dax_unlock_entry()
                                    grab_mapping_entry()
                                    dax_fault_iter()
                                      vmf_insert_page_mkwrite()
                                        insert_page_into_pte_locked()
                                          /* pte_none() and uffd_wp_marker
                                           * are both false
                                           */
                                          pteval =3D maybe_mkwrite(pteval, =
vma)
                                          ptep_set_access_flags(..., pteval=
, 1)
                                            <-- pte_write() && pte_uffd()

In the existing-PTE path of insert_page_into_pte_locked(), maybe_mkwrite()
sets the writable bit without checking userfaultfd_pte_wp(vma, pteval):

mm/memory.c:insert_page_into_pte_locked() {
    ...
	if (pte_pfn(pteval) !=3D page_to_pfn(page)) {
		WARN_ON_ONCE(!is_zero_pfn(pte_pfn(pteval)));
		return -EFAULT;
	}
	pteval =3D maybe_mkwrite(pteval, vma);
	pteval =3D pte_mkyoung(pteval);
	if (ptep_set_access_flags(vma, addr, pte, pteval, 1))
		update_mmu_cache(vma, addr, pte);
}

This leaves the present PTE with both pte_write() and pte_uffd() set,
which triggers WARN_ON_ONCE(pte_uffd(pte) && pte_write(pte)) in
page_table_check_pte_flags() when CONFIG_PAGE_TABLE_CHECK is enabled and
breaks UFFD_FEATURE_WP_ASYNC write tracking because hardware writes no
longer trap into do_wp_page() while pagemap_scan sees pte_uffd() still
set.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117-uffd-dax-a=
sync-wp-fix-v1-0-c9a30f27f452@kernel.org?part=3D2

