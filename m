Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8BA3606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 04:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GG4676F0
Received: by kanga.kvack.org (Postfix)
	id 195366B05B6; Sun, 22 Nov 2026 23:08:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 125E56B05B7; Sun, 22 Nov 2026 23:08:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F024B6B05B8; Sun, 22 Nov 2026 23:08:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4A186B05B6
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 23:08:54 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 55C8B807A1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:08:54 +0000 (UTC)
X-FDA: 85465052988.23.3C216FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id ABF44C0007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:08:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GG4676F0;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795406932;
	b=JJZhjPnf+UfshZ8sBy53vw4AAowm4bufojP1NeqmptkRzM/iFvbd2RNa2YgEoHGIoePJEd
	ph7YJ4nlCUbxP7iKRjdD0AbRQbZp1NpxWyw/RSduiNl4R1ZoerNEvId3JFSy0iuxzPbse6
	S2e0x2QGgMybl+VfpAx0Tk/F6GD5fzY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795406932;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iA3cMRrtWJN3NtSutJrk+CK/oZO8uPKymZjjiZefjrI=;
	b=MGqoKNi0OqxyJhjyU5aPMbP85VbGnDmqTE7EGRkPEJCmrpT3qL2eRYpTNErGaRe532IwId
	JKMuTSI2QPE7OYuceMQM2tpseHe+z26JudGqPhBZqXs9fv4bRHzHMuBQkI8txevgsqe21L
	tAxifGDOTx8yfgGqZrpbXglgJlY3XBU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GG4676F0;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E8DCC44D6B;
	Mon, 23 Nov 2026 04:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8389C1F000C0;
	Mon, 23 Nov 2026 04:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795406931;
	bh=iA3cMRrtWJN3NtSutJrk+CK/oZO8uPKymZjjiZefjrI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GG4676F0e6R2KofNtLDGdwgjsvKbS3u3e5jCRhshR5u1wndcQeheowt/gDEo7eb69
	 YclKSNwF9j/+SOyJDEmKiAUZdFmXGdBiRy/iCc82GACBvGVekaaVu6zkrJnSs5NPAs
	 NQmRL8gwg+Nlzxu8iJb3nfnTKVjScyprhY1g5sCEtLxgRsrQro/dICuX3Y9cja5Pkp
	 fLyi47vLalUSLbEwQQo/0kKmGM6mhOyNJ2R7QTZK002rN9HjI1vA8LOEHfEkaxJTvF
	 LHrxSySfSz2w5cQYXKqKIXc4l4titkGWJhI9601/blGPZf3ajnOlFwCznj68CBSjmD
	 tZSBDaFjxOOCQ==
Message-ID: <sashiko-outbox-228641@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 12/19] arm64: Support hugetlb vmemmap optimization
Reply-To: sashiko-reviews@lists.linux.dev
To: "James Houghton" <jthoughton@google.com>, "Will Deacon" <will@kernel.org>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Muchun Song" <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Kefeng Wang" <wangkefeng.wang@huawei.com>, "Nikos Nikoleris" <nikos.nikoleris@arm.com>, "Linu
 Cherian" <linu.cherian@arm.com>, "Mark Rutland" <mark.rutland@arm.com>, "David
 Hildenbrand" <david@kernel.org>, "Ryan Roberts" <ryan.roberts@arm.com>, "Nanyong
 Sun" <sunnanyong@huawei.com>, "Yu Zhao" <yuzhao@google.com>, "Frank van der
 Linden" <fvdl@google.com>, "David Rientjes" <rientjes@google.com>, linux-mm@kvack.org
In-Reply-To: <20261122184453.2668189-13-jthoughton@google.com>
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-13-jthoughton@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 04:08:48 +0000
X-Rspam-User:
X-Rspamd-Queue-Id: ABF44C0007
X-Stat-Signature: j4fenujy7ea1mf5z4nyfm4izi8s163yi
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795406932-119940
X-HE-Meta: U2FsdGVkX184Y+/sWEvNYDMwuomcWl1gajRdH/+JNNV3NI2fd4L9TD9fBzrzOi4wjqOJN6oMz3gJXtPj7LMETzsZp8RDRejoxRcfBC2NFOME/UUjgnbvxbCppRNA2P0kzBI0Ne0zSMHYyXwZVoc0N0FTCA2afbRTOFwDRMLdzUA+m0QOcJf2CdN4Y7dYGbm/fsBJyAOnMEKMGyoHwwIy9lDnD+s4RByP4RvIKsnmCKIswJ3LBwDtuSxWea+jx9ipQ8+opH0KZ5W3cPgUYtpf6DU4LsRL5LLaXgsgmDoDNnOd/mY/ZjaOoQWJHYIFPunN8DNe0TMrsl4l+9G1EyBcji0GU4Fl6TTsBh8HgFASs+1iFQ174vhbaO62ld1rA9MVjpd1ebCrKopjiczVb2Z+q6EF9cVE5rKeLAESp2e7eaUkHq32vVfy4aE/5aXLChrcY2fCVcSn/2DDO5CZPEm10Xx3YDi+NWc8ckHbzrN9uTdlFLTEgMDBvHcHqm0AF0Ch+xh+PXL6t/kdeOKtypDSU7SGckQXZmHzZVVCkL2vRufva5UZ/uGJJ+q6eDhP1GQONJGxdD4ieUe1r4ST7tJR5f4FnzMhBVnLfpXqGZKjsNTJU6WzDyIBe0cgtWinH3JzZqJI+nBeUm5VzEc2Q/7CTKBu6Fy3rtrijLCDbsJX92MhY3WENw8LWiSX4FGg2G+SEQUr7Y1pLa/w96hV4hYzhZzuNB+/UeIqG8c2kxUNeW8FxDjNQXQADEzBzZNbaPCoMtcizOlfjmVlJ7QzGBSoWKW6Zi2V1SX339GPgiK3j1oXFmTskJJDMPhq3CttMOO3rAeLCACxTHhglqCyxe+Rvc0W0Vyp3wn2l/cq/77MwdMyZdn6df2h2PJiVBFBQtG1GXW18Cq0V36zh8Jd3WeEMxzpIgqToqMXzrME0zKPXWT0+685fu3sbeismo/Gset5VbbCF760yXnK7UML37K
 5LulTrQZ
 0nKO4dgI5/C9ZfJTE/EQ2p8tH9hqMqMnA+rUad02rRKs1/4JLMCFnzf5UftHiQPmjC+7hAD9Azakf+O8+qYvowqkrjVOxk1puOaAmInZwn8pWQz8TpRuiUNs8DfynEdT9QPWKRml6dvxxoKghWLhqbo/RdLmeoJiBBir/NJNDsq4bPG09C73d4pKE2WKqTZnTe9U20r1cMZvez5GFXZcdaMcOMjE5At+JDpc77QBWrzigNeGhGHPha8UG6zQDXY+jPOrwetLHLQpw/zWBuC29lxzYV5aDMRDxbnogYxgjKWVxYduumDU+up/N/eu8CmUmGlfhD70FjPBCuyfLfEocTzwqaIxZjFQKCdj0lVk2/LHbxi+6UIubnYMQaiOqEJjG/4NH/Kuj5OdYMMNHKU513agQULjsd2jVwONgOP1RTf9/pKbts8KCtlk7tVQLalySNBtD6/iOJXYevqQ5Ay0/CnA896At1FaDi6ap8rp7v0plMgKbnjpnKTLcSiqJnKjPjTZTjQoeJ/UaKeWVmXZfsLcFMf1upn916e/vIsJFtU+/N4IFjiQhFSmASNo4OEIRr628y3E9+qNdy+6uac2ITSliVqPYEE3k8ZY4B8Kq6h05vM2rdtfmGBrQgsTNzlNF15YMu0Rg11/X1Z3VWRjMHTeSFrXAAgFl8amTiyZqXSfSXSYljRkN+773EwtwhRoSYgQuZpnI/6mmU6DcqQaoRoiKu3UPVIBprSItYn8hX4MnJsiUGoP7oi78Du9wewiuOBORH1aTq2WTlzbEduA2lpXwAKNtTOF8xRmycvNumhACcEUq+/pDSd+aTX4ROt+kYlj7
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
- [High] arm64/mm: arch_support_vmemmap_remap() only checks BBML3 on
  boot CPU
--

commit d9205a2d3f06bed3d56fccb15aefe364db523337
Author: James Houghton <jthoughton@google.com>

arm64: Support hugetlb vmemmap optimization

This commit enables HugeTLB vmemmap optimization (HVO) on arm64 systems
that support hardware access flag updates and BBML3, disabling early
section-based vmemmap optimization in vmemmap_populate().

> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pg=
table.h
> index 7421c0a048ffe..5dadaac54bef5 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1931,6 +1931,12 @@ static inline void clear_young_dirty_ptes(struct v=
m_area_struct *vma,
> =20
>  #endif /* CONFIG_ARM64_CONTPTE */
> =20
> +#define arch_support_vmemmap_remap arch_support_vmemmap_remap
> +static inline bool arch_support_vmemmap_remap(void)
> +{
> +	return system_supports_bbm_through_af();
> +}
> +
>  static inline int try_update_vmemmap_pte(unsigned long addr, pte_t *ptep,
>  					 const pte_t pte)
>  {

[Severity: High]
Can arch_support_vmemmap_remap() return true on heterogeneous systems
where the boot CPU supports BBML3 but secondary CPUs do not?

ARM64_HAS_BBM_THROUGH_AF (added in commit "arm64: Add bbm_through_af
capability") is registered as ARM64_CPUCAP_SYSTEM_FEATURE, so
has_bbm_through_af() is evaluated once with SCOPE_SYSTEM during
setup_system_capabilities():

arch/arm64/kernel/cpufeature.c:has_bbm_through_af() {
    ...
	return cpu_supports_bbml3() && has_cpuid_feature(caps, scope);
}

While has_cpuid_feature() checks the system-wide sanitised
ID_AA64MMFR1_EL1 value for SCOPE_SYSTEM, cpu_supports_bbml3() only checks
ID_AA64MMFR2_EL1 and MIDR_EL1 on the local CPU running
setup_system_capabilities() rather than checking
cpus_have_cap(ARM64_HAS_BBML3) across all early CPUs. If a secondary CPU
lacks BBML3, vmemmap_split_pmd() can still perform live in-place PMD
block-to-table transitions via pmd_populate_kernel() without
break-before-make, risking TLB conflict aborts on the vmemmap region.
(Note that commit "arm64: Drop BBML3 requirement for HVO" later in this
series removes the cpu_supports_bbml3() check, though that part of the
series is marked DO-NOT-MERGE.)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122184453.2668=
189-1-jthoughton@google.com?part=3D12

