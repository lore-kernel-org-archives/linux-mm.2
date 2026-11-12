Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD9FE606A33A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iM2T58I1
Received: by kanga.kvack.org (Postfix)
	id 3AA176B05B7; Thu, 12 Nov 2026 09:07:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 382686B05B8; Thu, 12 Nov 2026 09:07:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BF926B05B9; Thu, 12 Nov 2026 09:07:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 025626B05B7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:07:47 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8D8291C3E15
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:07:47 +0000 (UTC)
X-FDA: 85426645374.04.6065B23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id DAC2140014
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:07:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iM2T58I1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794492466;
	b=0mG9iLoiY/u6qdSf68+vA+LypFGfRFAPXJFan1OL5ym7/GB9CYiqjZNCxfJyq7wd08qv+e
	DHVGcBwhm8TjABI970RN/IkgcJNrABYUb0kZIR50g65FEj59snebwmlBV+fZuKUmw5SclJ
	1lpTiuhciNuH/BXBwVvB9MIiAPRfxQg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794492466;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2vITNF7TKhHIuFVEBTx6fH5UER1X5nNsHisBnuCAxmo=;
	b=tvQjscsmO/Nfhf1fNto+czaLi8KCGZVqazJa1z2s1IyFZsV/6Tpw1QIytGRBRh4BPDZ9mR
	Aex+9NGFymbL4izZaoc1tUcY09brbzikEiD1cE92g598SSJB0QNhat5VRsAjmcwk5GWi73
	Yb/40TND/bgNQJpSrBXkiei6482VJuQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iM2T58I1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 60B9A62DB3;
	Thu, 12 Nov 2026 14:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D6D1F00A05;
	Thu, 12 Nov 2026 14:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794492465;
	bh=2vITNF7TKhHIuFVEBTx6fH5UER1X5nNsHisBnuCAxmo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iM2T58I1YdoY5P8RZB2DkoTJQPJg54SO6aREamfdd768KpLhk40duyuyz12mVDKRz
	 l8Y3/w3251nAa17baevXY7fq9/c/0sB1yzAun7cFMMGEDXt+2CU+4XwBt7edY1wGNF
	 AbV1r16mP9AeTw1C884cv6qZGW+jYHzVWfH+s3PfGHmPWiVxl5KOlZthLaLTyIbWYp
	 cR2Ka4qS+xiakfOiCkv9uiG+vgWDOA5KM7w9A3dWxUky7kQWtsnlb7qaE4utRejzXB
	 0W67XYfHMMNYaZGJA9an9mGiCR/V+ybRpqZMnCADObHyPpMD106x/tm7O7GqzD1uKI
	 fTc+WE51K+t/Q==
Message-ID: <sashiko-outbox-211265@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/4] mm/huge_memory: don't warn when a page table blocks
 a huge pfn insert
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eliav Farber" <farbere@amazon.com>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "David Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Zi Yan" <ziy@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>, "H.
 Peter Anvin" <hpa@zytor.com>, x86@kernel.org, "William Kucharski" <william.kucharski@linux.dev>, "Vishal
 Moola" <vishal.moola@gmail.com>, "Alex Williamson" <alex@shazbot.org>, "Peter
 Xu" <peterx@redhat.com>, linux-mm@kvack.org
In-Reply-To: <20261111140655.34281-4-farbere@amazon.com>
References: <20261111140655.34281-1-farbere@amazon.com>
 <20261111140655.34281-4-farbere@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 14:07:43 +0000
X-Rspamd-Queue-Id: DAC2140014
X-Rspamd-Server: rspam12
X-Stat-Signature: 6e1z9bxdtmu4cbo8df5q8asuptje91a1
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794492465-635096
X-HE-Meta: U2FsdGVkX1+84NmMKEUk7FPAhgR0Jj4hmjQCjYZS2v1pOTwl4JOpu5COwkdTitSDpZidCRi0G/SE0Plm8MwGLy79hjXs8rCVHlEwVA2y/sQM5CmdAv6erbBsj21EDz0tKiHirxt+2/0h2OHSLTvHDtR/TStfEzRMYI5aidCWgl2Qir+k9sBj3Cz5zJJGPi+fjDGCD130vix2jt5VX89o5pqdBZo6YQFi0HhseqXSiK5rlX8ey0CgMSkjDL6RVYpw0Js2C9wWzKA2nJQsjxdoqcOHOhcIG9JD+vzOsRoDiD/QNa9UA5E+N+kapJCedP17oufk8l9FQ3mkDrEXdOJydSr/qkoJ6sy2R46yX7GTkc69z0ony+ztngxEdNC5L5WWUKBWFhfTBTBUn4uhaNkeJRhydC8gjUa08HbK8RpKCGYp1YAFMqm9nDKphLdTQt4xgStQz3PUGiKJf2TRrjDcZ05AqrADA5LGmz9IPu+nFdqkE1gGTY91qjVxF+pfrxxWzfAv+O8abAjxYjSsvDwX9RWbr7M3Q4Lmm5psP0K7lREeQXCRP45HzLbE2hQrh5Xptc8qEEo1btNxxhlnVTm+DgY5voOYDzXjesqK788Jav5VdNwqS0LvlALHU++iKQJ/qC9RV9tRFTS/IsZPlBua18fBwY55TkDGnCcj3+tv66QsL9idWMDI54dKj1wwMISkVyIH65eYlmiHCNe/A7ZOjARoiNwDNgkwgqTXJFIGvXI2cEEMPpyb5Bi2l3++M1Y58Q0TkoykxmiH85N8GT/VCzU9ycmoF8a9Iy0uJPAeM2b0qfeeLWrcI3nrrPoaZUuhGMwCYFpermjfPlmHltXqG1084xYMfHm1GgEy2RSlSbhePUERCsjRHgnODKwGuRY+d5V9VqMp10rc3AQvWEf3Haka1FEhreYBT1/nvUk1V6RLOWG7P2JZtEQHtlhFLiHJ4QoOJ9Ig9dxnV/L5S1z
 1mg2K6L0
 o/nVZ4QAf6jmdyCS4DgrulSJMBx2V45UkUQUw9/tTSUIk2xJbqABMBx5+PWs2UEyh4HmM3QvrGl//ySzzvhPBhuVwTZ76A6qr+0Me9ZUk1sDe9pa68NcMIgZLJzOWMehqfEc94kcTCEbmH0KCSH7xKULOyERXJD1Nt9yBzsFvBBf3NkMg5lDhDmFsgmB2oVZiZqzUypF2YmzU12G3bGEXDQV2B/bFTKsR52A2YMX1D8+cNR9X/jeGo7j1fa7yWjmoifn/5pHAktrtOGuDdn3WAPDHXMmvu5acXtI9yPSJpiWOK/Q7Mu2mmmtAyzx+s+LJ1jbKdpBLUJSKniBPH61jlW/YQgcm7BOC9N1FfOqrvaLId+Xzc/jybqMZnq8XapcIkGEjITDfPyZX22DLGDXN+bJqUAoX5pSZDbuswCC60NgM6xB9FSR3Pp8Wzok7ZPGdabnZXV/eKVD8ByWYLxQ0W0umnRDHQe4r2yumXl00LxN0bx+US8VMAWt0V7zlfUWXSHtK9erM/85HjG7KQd3iVOeaiZjfG8p+TrmafUHnfr9rRZTt2dUhFp0qffqW8730CdXmKJ6Dpk14XnII337lbrgiVHz5MN652VEJBo7OA4YbRMdpZBSiIfNiZ2WXC0itYFcPugy2wr7djaQbSv0dprh+uiCGsWnoUSmksIt/je5jsOMeSEpE9npPAEcBxo4e+RmzP9kt0Sg1UP1CAqBWxrMzaiW95liNDiadOKq6sB1l+9A1rR1Q6be9b9NrJSBhroYQMEtdQ1zpxLck7oWcvNzuhOjN4Yt8MhygM/8pdmi94iX3SCDQ+nOL8UmXNfmKoBQnVJl+9oXhNGXiFh6nAnAejhOwNCMrvrdDCGFVEZ682g8=
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
- [Low] mm/huge_memory: inaccurate Fixes trailer for insert_pmd() and
  insert_pud()
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [Critical] mm: missing VMA bounds checks in insert_pmd() and
  insert_pud() [1]
--

commit d9bb1ebf27a3fa3fa5849404d8b2245f291d97f1
Author: Eliav Farber <farbere@amazon.com>

> mm/huge_memory: don't warn when a page table blocks a huge pfn insert
>
> insert_pmd() and insert_pud() treat a non-empty entry at their own level
> as a leaf and compare its PFN against the one being inserted. A page
> table installed by a concurrent order-0 fault also makes the entry
> non-empty, and pmd_pfn()/pud_pfn() then report the PFN of that table,
> which never matches. insert_pmd() warns unless the entry is the huge
> zero PMD, and insert_pud() warns on any mismatch.
>
> A VM_PFNMAP mapping with both ->fault and ->huge_fault can produce the
> mixed orders: an order-0 fault installs a page table over an address
> while a concurrent huge fault on the same address reaches insert_pmd().
> Changing an mm's THP policy while another thread faults the same PMD,
> for example with prctl(PR_SET_THP_DISABLE), is enough to do it.
>
> Compare the PFN only for a leaf entry. A page table is not an error, so
> take the existing out_unlock path, which returns VM_FAULT_NOPAGE and
> lets the access refault onto the smaller entry.
>
> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> Signed-off-by: Eliav Farber <farbere@amazon.com>

[Severity: Low]
In both insert_pmd() and insert_pud(), the PFN comparison and
WARN_ON_ONCE() only run when write is true.  f9e54c3a2f5b ("vfio/pci:
implement huge_fault support") always passes write =3D false to
vmf_insert_pfn_pmd() and vmf_insert_pfn_pud(), so it never enters the
if (write) block.  The unguarded PFN checks and warnings under if (write)
were added by c6f3c5ee40c1 ("mm/huge_memory.c: fix modifying of page
protection by insert_pfn_pmd()").  Should the Fixes tag reference that
commit instead?

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1e5d68acf62a5..1ec124ea542a5 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1647,6 +1647,14 @@ static vm_fault_t insert_pmd(struct vm_area_struct=
 *vma, unsigned long addr,
>  		const unsigned long pfn =3D fop.is_folio ? folio_pfn(fop.folio) :
>  					  fop.pfn;
> =20
> +		/*
> +		 * A concurrent order-0 fault may have installed a PTE table
> +		 * here, which pmd_pfn() would report as the PFN of the table
> +		 * itself. Only a leaf entry can be compared.
> +		 */
> +		if (!pmd_leaf(*pmd))
> +			goto out_unlock;
> +
>  		if (write) {
>  			if (pmd_pfn(*pmd) !=3D pfn) {
>  				WARN_ON_ONCE(!is_huge_zero_pmd(*pmd));

[Severity: Critical]
This problem wasn't introduced by this patch, but can insert_pmd() and
insert_pud() map physical memory past vma->vm_end [1]?

Both functions only check whether the starting address falls within the
VMA:

mm/huge_memory.c:insert_pmd() {
	...
	if (addr < vma->vm_start || addr >=3D vma->vm_end)
		return VM_FAULT_SIGBUS;
	...
}

Neither insert_pmd() nor insert_pud() verifies that addr + PMD_SIZE or
addr + PUD_SIZE fits within vma->vm_end.  If userspace creates a VMA
whose end is not aligned to a huge page boundary, faulting in a PMD or
PUD maps physical memory beyond the end of the VMA, allowing userspace to
access out-of-bounds memory or corrupt adjacent mappings.

[1] https://sashiko.dev/#/bug/linux-f9c89537-a4ba-4e65-a29a-5c77e15819b6

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111140655.3428=
1-1-farbere@amazon.com?part=3D3

