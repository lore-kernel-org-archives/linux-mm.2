Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09DDC606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 13:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E9BteXLT
Received: by kanga.kvack.org (Postfix)
	id 2DDF56B05B3; Fri,  6 Nov 2026 08:11:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B5DB6B05B6; Fri,  6 Nov 2026 08:11:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CBCF6B05B7; Fri,  6 Nov 2026 08:11:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC04E6B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:11:27 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8E39440DBF
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:11:27 +0000 (UTC)
X-FDA: 85404730614.23.B8D226F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id F0627C0008
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:11:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E9BteXLT;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793970686;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r05KjIaky8vd387v1sUpB/cEZd4wDF7ZmrnvdsQX3M0=;
	b=H4s037vu2af58KjG4Tdefcl683h125OIycFDpG1mQjlmk6Gd98tlA2nlUqqxAnZRPqkjL4
	OFmAauOwhR78zHkcgKlZasNCMGyXpakGuCaAthyuCEvvumvxfBFAM1UH2LRV3u+lToNE+L
	9jt4rf7+n63MUNd/6W5mqJnUA9SE1TQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793970686;
	b=BDJPPOn31SOte62OdMiGB57XzoEo94EY3ARxnWtFVJnfVt12CYGdxVKWK3l6UCOx2ajnt7
	LjmX8e2NktfWn/yw8SSQsycZvwO1fm9bWnfG6irPvhOjJ6JSAI6mgxSKqefz3j4zv5IDLh
	jb5aNC8jYIu7XpEmRLdNheBILEPHU3g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E9BteXLT;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 68101601BF;
	Fri,  6 Nov 2026 13:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0391F0089F;
	Fri,  6 Nov 2026 13:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793970685;
	bh=r05KjIaky8vd387v1sUpB/cEZd4wDF7ZmrnvdsQX3M0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E9BteXLTvyCKEJOTFQuvbld5a1HvPSVwFlWKdnTlhqwRIN1eLkaBNpZCgGVLG1rmO
	 z/rQ3S1pFoK/FhHE9wgPMy+m3zkCBELSLBjMuTQcajy9uKTmFeGLEaLnQ2eY8T7dzv
	 dPk0TH3cS99x4h9Kn2vDFJaJlAObvB2xDzEJJO5yfs+V6P4NY3KnLO6iOqjnEUsIi8
	 rd973tt2VJbymUQAa+7f/j7bdVcvPCh7vYf9Ytf8OvtA7e4xuE8WCOMXnJLdnx5Lr1
	 yDHCDz6wOynkazyVcSCMfs+GM5MNhWdEwSUXs82S6HbwEzK5zvwmogYlXE5OZdYcp8
	 68DGE1easc73g==
Message-ID: <sashiko-outbox-201442@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/5] mm: limit pagecache folio refcount when mapping
 pages
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?RGF2aWQgSGlsZGVuYnJhbmQgKEFybSk=?= <david@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>, "Jan
 Kara" <jack@suse.cz>, "Zi Yan" <ziy@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Matthew
 Brost" <matthew.brost@intel.com>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Byungchul
 Park" <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Peter Xu" <peterx@redhat.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Song Liu" <songliubraving@fb.com>, "Rik van
 Riel" <riel@surriel.com>, "Hugh Dickins" <hughd@google.com>, "Will Deacon" <will@kernel.org>, "Aneesh
 Kumar K.V" <aneesh.kumar@kernel.org>, "Nick Piggin" <npiggin@gmail.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Kevin
 Tian" <kevin.tian@intel.com>, =?utf-8?b?Sm9lcmcgUm9lZGVsIChBTUQp?= <joro@8bytes.org>, "Robin
 Murphy" <robin.murphy@arm.com>, "Steve Sistare" <steven.sistare@oracle.com>, "John
 Hubbard" <jhubbard@nvidia.com>
Cc: linux-mm@kvack.org, "Chris Mason" <mason@kernel.org>
In-Reply-To: <20261105-refcount_overflow_stable-v1-1-70b9c655da3e@kernel.org>
References: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
 <20261105-refcount_overflow_stable-v1-1-70b9c655da3e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 13:11:23 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F0627C0008
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: ha9jdntbpkipps7krenqohhte956s4ey
X-Rspam-User: 
X-HE-Tag: 1793970685-6325
X-HE-Meta: U2FsdGVkX194ZtcM4huCf5cE6U5sWE+LPFNbicP44730CZXO8eoj265GBaPluYnnaIaWcJUUZMEv+NohL659qvwGMk93344a+2PIIV+1uB1ESYTc8Ny61a+sdVnUBstoCsKlAYzat83ood1+zylxYGzmHltwywUWfo5RjQMcWRxQLFYzrRqTFAv8u+F73kCbuCFsyXroqtLPUnTMQUxA5613hpa4lj6iu/tmkC+QH7gcABBgkjdPXC/Idz7ofMdsRwDN60ao96sGpFnFb8S2k/HEaMU+CeLd8ii2lPEQfRfFOl7rn8xhMI57R44oVIqMzMPRBMAcFN/q3rieqFSf5cHMVbKr0v4bm2d5IB6EWLgiK2pKzDrlYI4W1yIjeCQlw1OQTVAoLAE9E0U4ZBAVrNHC6dYtCxKbrldpCogKRknWUY5MxyCOyV0AnyhmgLuCKcMP6vFSbKJ6pkeuiX3MbAZWpePJcYZN/l2GlPigId6WIDBOv/wFP9QXvpG4zpyxBSrsfDy3oQmPK0Be4dvYmZWIO/VRCLmSa9yhmdtTR3MII5auBkKfKrTwk0gi3p+Ejx9XrCXx08kml96929sMhcaXAOb6af/dmgFXsUfsOmn4HMrVQ1UeMriwoxEWI58GC3QsiYdyofi7P052tQIPxms1LaFc/dtVVREHVsAj3A62xS6W8vbWvzIFYFvza26aZ5JVzlG98izQD2Rn078V+/0qf6sCW9K0AnQbCdQ5Xf57DFGFuBglm+sHryhVQ5PtsTehZAulilo+xsPI4bhmpGuOnu0p1M34GryjZVDGJU83O64ykQWlcPmZ+kCBQx/1Cr/Y+QyBnI9111y9kObmM8mxDNZ6EyUn1OQA8S2wLf55AmNIA0YOQx4J1byMdoMnOofsurOmFTlD3AIXsTCNLLB4NfE/sNraifBjjRE8ilWzX7GauiNg53Zw98o4DBZexN0H9A29hTzrvDYcRE6
 MZrNXD5Z
 3+MsljJ9pWGAPPdkukEqMXnzgXbbkuTnieEFiIREpZQLak5SgcOoNNA1p4i3PPIBnKO1ExjpYmmwPFthWcSMozVJX9S/rk/WfgL3qeP7v4GcWnSlrdRNa108UZyRKlgasLiGIE0XWSMhEfTfA7nL8w6GN30BdHn0y5mNXWj1nElTasVLvzZMJLLW9OADKnH2Jslj0GRsgUQlrbaHAeu3rpZfS1azPtKlEHfK/Kj+OKpoJfVRinSOidQYxu4z3s1QS7pJl2bC6SPnWdGdKdPMYGzAoHIHK8lQsvMEi6JhqiNnqrJH3+vD88e6sOhkvOrUjQpYMCwDinMS5jZvT9IvhqpMUPDJM9rE9Jf05WbMJIETMXhjtuJRNw00I15gJBueo+6blrZNE5Eawmu4JwxXYraAVgeR2lRMwECY3KT75FPckrHHgnaYX2C9YEnPnq4Nj7Tk9LjV+KHvTnrxWgbUAG+j2gjzvaK3Hce70AgoVUY29sBfhgviYPTBGtfR7ht56hcHtWPJxz2Xcj98K7fpxuWpr2qmyeoeaEvcIGpe+qicGJsUw+XeKK07YJNrBsSWEAfFvF7LnQlFSkVoE3E6giHMmbZ9hf1pvD+JDpRyrQxKt18VxzGi3VA5cvI5n68SCwFQeyneFIzvCD9RIPzW5ydUFfCBC1YUreB8uQXVz+rjsoAggn8NbeBqtBMhT5G8/IB7KxqUNsTZpf94=
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
- [Medium] mm: missing folio_ref_count_over_limit() check in
  copy_huge_pud()
--

commit f7e3ed38c742cda863dfe55787d1e17c689cd9cb
Author: David Hildenbrand (Arm) <david@kernel.org>

mm: limit pagecache folio refcount when mapping pages

This commit introduces FOLIO_REF_COUNT_LIMIT, FOLIO_REF_COUNT_ADMIN_LIMIT, =
and
folio_ref_count_over_limit() to prevent large pagecache folio reference cou=
nts
and mapcounts from overflowing when adding or duplicating file mappings.

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index d0e19d9e6b651..2596ff0f0e185 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
[ ... ]
> @@ -1784,6 +1790,10 @@ static vm_fault_t insert_pud(struct vm_area_struct=
 *vma, unsigned long addr,
>  	if (fop.is_folio) {
>  		entry =3D folio_mk_pud(fop.folio, vma->vm_page_prot);
> =20
> +		if (unlikely(folio_ref_count_over_limit(fop.folio))) {
> +			ret =3D VM_FAULT_SIGBUS;
> +			goto out_unlock;
> +		}
>  		folio_get(fop.folio);
>  		folio_add_file_rmap_pud(fop.folio, &fop.folio->page, vma);
>  		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PUD_NR);

[Severity: Medium]
The commit message notes that each folio_add_file_rmap*() and
folio_dup_file_rmap*() call needs a prior folio_ref_count_over_limit() chec=
k,
and insert_pud() is updated here accordingly.

However, when forking a VMA that passes vma_needs_copy() and contains a
PUD-mapped folio, copy_page_range() -> copy_p4d_range() -> copy_pud_range()=
 ->
copy_huge_pud() in mm/huge_memory.c also increments the folio reference cou=
nt
and calls folio_add_file_rmap_pud():

mm/huge_memory.c:copy_huge_pud() {
	...
	page =3D vm_normal_page_pud(src_vma, addr, pud);
	if (page) {
		struct folio *folio =3D page_folio(page);

		folio_get(folio);
		/*
		 * TODO: once we support anonymous pages, use
		 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
		 */
		folio_add_file_rmap_pud(folio, page, dst_vma);
		add_mm_counter(dst_mm, mm_counter_file(folio), HPAGE_PUD_NR);
	}
	...
}

Should copy_huge_pud() also check folio_ref_count_over_limit(folio) and ret=
urn
-ENOMEM (which copy_pud_range() already handles) before calling folio_get()
and folio_add_file_rmap_pud()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-refcount_o=
verflow_stable-v1-0-70b9c655da3e@kernel.org?part=3D1

