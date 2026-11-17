Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57CBB606A323
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 12:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vs/Ttq+W
Received: by kanga.kvack.org (Postfix)
	id EC8D76B05BD; Tue, 17 Nov 2026 07:50:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E53506B05BE; Tue, 17 Nov 2026 07:50:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA53C6B05BF; Tue, 17 Nov 2026 07:50:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9269F6B05BD
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:50:06 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 08A341403B8
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:50:06 +0000 (UTC)
X-FDA: 85444593612.19.958728D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5AEDB40005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:50:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Vs/Ttq+W";
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794919804;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+gMfPP+/wfx4oq0DEqnz4800oywzmrTuNd7xV7OGuCc=;
	b=YDccX2JHiHRl8oWdgpUpOMkMY6IFhszYamqIpwqKeJgQJ1wUfwf7DiAI9IVJZRMk/LZ1Pl
	F0RmGwj87I3ZDA2/Y4QUUb3JoZ4pu1EiUXhetjVoiG/zXj98XfCZdKFB887G7DzZWnmHRQ
	AcJYPqSOawkg3LfB8m/VW2zEAJW64bM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794919804;
	b=ZavqISILG64x16JzZyOgFBhUqd9u+wDz8jXAIihnpB/gr+L3H5MMC+xX3FI5lRGSPhoC7o
	Cs8BdSrlaKPIVW0YRrmPoFR5/bkaIuNnTnOEptL32g++FuMm7tvIQh8SoJly+6b3nnSNwI
	QNc8gWHhZjywz8q6trqQXG3ylJC4VX4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Vs/Ttq+W";
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 760D945769;
	Tue, 17 Nov 2026 12:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1231F000C5;
	Tue, 17 Nov 2026 12:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794919803;
	bh=+gMfPP+/wfx4oq0DEqnz4800oywzmrTuNd7xV7OGuCc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Vs/Ttq+W+qwBjZ4wm/flY08kuFJn3j3qpaR+m7kBbH55LOkEJmVE2IllJiqqzlsdM
	 Ih4WYUO6YK9hLwhTOuEAXLBO3URLEQMaW5BB7EwBZ2qFG7zUuDbMms10gJq0syKgvM
	 bJS78w+sECk3gF9dWiFEPZll9+yC13Quz/0nYP6zHw64yicPLNPhcKezJ/mz2r3gtl
	 2UnM7a2RkKPRxiZIo/oWS0rKPdiWX685TDuuQ1GxkXNLKpzLwQLBFd3Zs9OYRTQnaN
	 ViFBY0tyWP6F4xzjZnSmmwfiYx0RxiM1uaqopUmIstAsRadQNWVqU8txuN3OKrxeAn
	 MCtTmIINrV8Ew==
Message-ID: <sashiko-outbox-218805@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 10/10] mm: print pte in
 __print_bad_page_map_pgtable()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Arnd Bergmann" <arnd@kernel.org>, linux-mm@kvack.org
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Andreas Larsson" <andreas@gaisler.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, =?utf-8?b?Q2hyaXN0b3BoZSBMZXJveSAo?=
 =?utf-8?b?Q1MgR1JPVVAp?= <chleroy@kernel.org>, "Dave Hansen" <dave.hansen@linux.intel.com>,
 =?utf-8?b?RGF2aWQgSGlsZGVuYnJhbmQgKEFybSk=?= <david@kernel.org>, "H. Peter
 Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@redhat.com>, "Jason Gunthorpe" <jgg@nvidia.com>, "Linus
 Walleij" <linusw@kernel.org>, =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>, "Lucas
 Stach" <l.stach@pengutronix.de>, "Madhavan Srinivasan" <maddy@linux.ibm.com>, "Malin
 Jonsson" <malin.jonsson@est.tech>, "Matthew Wilcox" <willy@infradead.org>, "Michael
 Ellerman" <mpe@ellerman.id.au>, "Michal Simek" <monstr@monstr.eu>, "Mike
 Rapoport" <rppt@kernel.org>, "Nicholas Piggin" <npiggin@gmail.com>, "Nishanth
 Menon" <nm@ti.com>, "Richard Weinberger" <richard@nod.at>, "Russell King" <linux@armlinux.org.uk>, "Thomas
 Gleixner" <tglx@linutronix.de>, x86@kernel.org
In-Reply-To: <20261116124832.662455-11-arnd@kernel.org>
References: <20261116124832.662455-1-arnd@kernel.org>
 <20261116124832.662455-11-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 12:50:01 +0000
X-Stat-Signature: cb44stk64wrtx7z69b5hxi5955fq3q4r
X-Rspam-User: 
X-Rspamd-Queue-Id: 5AEDB40005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794919804-854904
X-HE-Meta: U2FsdGVkX1+Q4/Mt4E1sXqPCA63fn+TsAhmOHfRw3ug6cZmKl9xIYiG5h65p5sNN0El31rO43iya46cylHzmjRt+N+QNmktpoygltP1YbTLjzlPW6WuPxLbNhx/b3vSiqqlfmJ/DKTfhCrtk2uU6V+FxCuMYH+x/PdawGupmw9wLF62YfAMzohkNXZeRe2Ttm7K9Dglhi7iO0GZT6/iUkEmp27EK6BhDMKjwp1l9Wit2ETIvFqdu15tN9ddZKT7TFG1zIl3uMuYcsPhHlFHUsI/ZcmMSZMv0C8LR5tmzzaLYFCNrASBBAqhtTYG62m1VfeeG2bZBSOm1D5dcL/ZAaWf+rjLwpTUFqdsMCrEB4NmKT5ZNUGT6IjL9VMrSuXrCTBsHrTfaIkLWGCFWSa/LR0sIVvN5nXeB0Gs4HcabKaB/tkzzjb+7o5ejgBqBuXK53xeM+u0IqWjIu4LXmnd/74X6baXrQw/2yKFPQX+goTkdmRkknBP/914AJlM7IHdMDwLAO/LXnwADrGDBdKxe1fCLBNEPQ5fln83zQ59E6qkdmWGpttp0bgcRS1qEIUqg934UX5YqYxIFXG8eBMj/oft0nVJ/05f8DqBhrArpGe6yhSX/gIZ07L91kAD59XrMertO1c3zab02r+dM6P7djZHRZfZMEuMQ7ERqhRmmaBR8C6VWFfdN5LU/hXjZghVbPHdSmPIFMeohH7e5cBBU5siwnxZxZPfem82hvjvAxd3cwi1bLpyJzP/bKLRAi1yJJ7TATaR9qTrI2/OKLYJ2ZZAGrGGJW58vwuuIUiSzNpkNWnwnQgN+A2CbRBXbPB+lmISkUcpSfw56+T6W/yOD3NYbOZr999gXlQGUpEYQCcVzpcVO8YruXXy/ZUmvVdbNz/I0RTyxC+8qhxTacG0YJrBUhY/6BrX8tZVwu5VD8urIbXKdQF68d6P3CFgVwpEpiEB+CjGgbqT6mJTXykg
 fJqp/ueK
 QP8m5Yq8S6NLEMZCYKUWwGmWFncwzcS3kcK33R96H6XdAvFO1Ndd4Ri5+L9IXA/GCyuMuUK8K4pvFFRYfJRBVgLfxaKCPxk81ZTggbxtOjRkCBEBAoN6/7rWuMMUgxvEq0O0PK9CittaI0+lg27GFQG63lo3CbJ46UypEMC9Qc1xK4Ii8IRDXyeAgEs981Bkt0m7JASL3IfWQ5T2mwnwwRKpZYla5q7rQe3YQ4OLUUht6J6bRJz7NXhfvJse5hSAVp3AbX8yI0ntk6W4exMLWg4tcT/V57PkpI/9RjEOKQnGdkql6PA5IgL+HRX5GdtcijcCdC15909TuuTmDFA5SXEwaFaKV8krJd9LbjwrpmBuLFxzmZ1oHDkVqs7By4QQVdx1VNz4JgS4+NC2+tz0NbCf9EIbLTnYACHFyxedf4ye+Gh87zoDePqCv11sahZVlOWdOOmtgCPjJT0ZCGDyy/tyTVltzMCoAojQO+C1D6mNLPofrSlyC0xaqypsnkqzcE1CWTrtma2AlG7tnrpfRH92lvxYIRQfQHjc4JbNIFRbUKxxG5EEGoK3Rw6RCjWeBrqJ2/PAGsNSaepsCtvc9oWZIUseF9nrAqXzd2uXyuv5/Q/Mx0Pi8UJ1Xy2LSpjO0crZ1r8WGzFXEXpDW+jXfM1wBLdlW88PZ6NYUtO6r9plp8dM=
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
- [Medium] mm: TOCTOU race and missing RCU protection in
  __print_bad_page_map_pgtable()
--

commit ba4bdee29bb52c7a53d86e0e93403b7b06ce3b2f
Author: Arnd Bergmann <arnd@arndb.de>

mm: print pte in __print_bad_page_map_pgtable()

This commit extends __print_bad_page_map_pgtable() to also read and print
the PTE entry alongside the upper page table levels.

> diff --git a/mm/memory.c b/mm/memory.c
> index ec3d9d99ccee2..6404bb447d9c7 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -528,9 +528,11 @@ static void __print_bad_page_map_pgtable(struct mm_s=
truct *mm, unsigned long add
>  	char p4d_str[PTVAL_STR_MAX];
>  	char pud_str[PTVAL_STR_MAX];
>  	char pmd_str[PTVAL_STR_MAX];
> +	char pte_str[PTVAL_STR_MAX];
>  	p4d_t p4d, *p4dp;
>  	pud_t pud, *pudp;
>  	pmd_t pmd, *pmdp;
> +	pte_t pte, *ptep;
>  	pgd_t *pgdp;
> =20
>  	/*
> @@ -567,13 +569,18 @@ static void __print_bad_page_map_pgtable(struct mm_=
struct *mm, unsigned long add
>  	pmd =3D pmdp_get(pmdp);
>  	ptval_to_str(pmd_str, pmd_val(pmd));
> =20
> -	/*
> -	 * Dumping the PTE would be nice, but it's tricky with CONFIG_HIGHPTE,
> -	 * because the table should already be mapped by the caller and
> -	 * doing another map would be bad. print_bad_page_map() should
> -	 * already take care of printing the PTE.
> -	 */
> -	pr_alert("pgd:%s p4d:%s pud:%s pmd:%s\n", pgd_str, p4d_str, pud_str, pm=
d_str);
> +	if (!pmd_present(pmd) || pmd_leaf(pmd)) {
> +		pr_alert("pgd:%s p4d:%s pud:%s pmd: %s\n",
> +			 pgd_str, p4d_str, pud_str, pmd_str);
> +		return;
> +	}
> +
> +	ptep =3D pte_offset_kernel(pmdp, addr);
> +	pte =3D ptep_get(ptep);
> +	ptval_to_str(pte_str, pte_val(pte));
> +
> +	pr_alert("pgd:%s p4d:%s pud:%s pmd:%s pte:%s\n",
> +		 pgd_str, p4d_str, pud_str, pmd_str, pte_str);
>  }

[Severity: Medium]
Can pte_offset_kernel(pmdp, addr) and ptep_get(ptep) race with concurrent
PTE table reclaim or collapse and read a freed or invalid PTE table?

pte_offset_kernel(pmdp, addr) dereferences *pmdp again after the local pmd
copy was validated, and accesses the PTE page table without rcu_read_lock().
Although print_bad_page_map() assumes callers keep the leaf page table
mapped, callers such as do_swap_page() unmap the PTE (dropping both the PTL
and rcu_read_lock() in pte_unmap_same()) before calling print_bad_pte():

mm/memory.c:do_swap_page() {
    ...
	if (!pte_unmap_same(vmf))
		goto out;
    ...
		} else {
			print_bad_pte(vma, vmf->address, vmf->orig_pte, NULL);
}

Other paths such as get_gate_page() and hmm_vma_handle_pte() also call
vm_normal_page() under pte_offset_map() without holding the leaf PTL:

CPU0                                  CPU1
do_swap_page()
  pte_unmap_same(vmf)
  print_bad_pte()
    ...
    pmd =3D pmdp_get(pmdp)
    if (!pmd_present(pmd) || ...)
                                      retract_page_tables() / zap_pte_range=
()
                                        pmdp_collapse_flush() / pmd_clear()
                                        pte_free_defer()
                                        /* RCU grace period elapses */
    ptep =3D pte_offset_kernel(pmdp, addr)
    pte =3D ptep_get(ptep)  <-- bogus address or use-after-free

If CPU1 clears *pmdp or replaces it with a huge leaf PMD and frees the PTE
page table via RCU between pmdp_get(pmdp) and ptep_get(ptep), CPU0 will
re-read the modified *pmdp and dereference a bogus kernel address or freed
PTE table.  Using pte_offset_map() and pte_unmap() here avoids re-reading
*pmdp and keeps the PTE page table RCU-protected while reading the entry.

Also, this isn't a bug, but the early-return pr_alert() above adds an extra
space in "pmd: %s" compared to "pmd:%s" in the other messages.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116124832.6624=
55-1-arnd@kernel.org?part=3D10

