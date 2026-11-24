Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE5C7606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JDRUZ4v9
Received: by kanga.kvack.org (Postfix)
	id D48FB6B0809; Tue, 24 Nov 2026 12:35:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D20E66B080B; Tue, 24 Nov 2026 12:35:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C37396B080C; Tue, 24 Nov 2026 12:35:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9F3976B0809
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:35:57 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 25344120BE2
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:35:57 +0000 (UTC)
X-FDA: 85470715554.27.1FC067B
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0F36880012
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:35:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=JDRUZ4v9;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=jthoughton@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795541755;
	b=g4/fhBQTOhM2FLkgOiiUBc9RYNWNav3b9sunDMBB7ivMc9KenRWLQLBI4g4gzM2EBOsNs4
	kBqjyeyWgmxP6bWE2nyNWn8UGzb13wk/reIwoWkh2wS967qb+a3B1P7KmaxHQmIXhA+xr+
	p0U4aJJeoGUc+U0MBxLeyMGM2FMUWs4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795541755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/wAkO2VIXgEXGO/81/dkTBjdiCoL5B7xqkyttC27AeQ=;
	b=e9UwzKBB96nmJjxAe/uULMNoe34VKQ2/QmZuBdBn4b0IeqID1vBd7AH0TF8edRfft7fCsZ
	osHyq/JYbtfIfu4DkhXFF6Th4QFSCUKK/r/sEXm3RpQF4fcVTnBDbkn5Rq5BIFR3MSBOgS
	qlJQmkhP/jzwQbeSoW1oFsdH7nwLWjQ=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=JDRUZ4v9;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=jthoughton@google.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c505b2e1cb9so896808366b.2
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:35:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795541754; cv=none;
        d=google.com; s=arc-20260327;
        b=KzGJrQL6KUFpL7ZCnzmCEqzn5rQGLZZB4WGrCS3/g417mxeR7+1A23mu+9MsVQYPBj
         c1EMK3jpw8pgoTkAO0smsvujxiA/0QDrxPjS5Q1JzN61RhFXtgZKGyyBc/U9oFcDB2NS
         tKEfA1WrOnMPuqDV/iNbnQk8rKAB+jW+eBEJYC4Hs/jcIvH5NY7EZRtIQb5CSSfiEJHu
         3jpGEhpAN/ee2DhUQ3GnyUnEOF5H4mNAVhQcAwaigFE5PbSohIzLOVhWMGii4dzDoxi1
         DejLowtyevULcyxBQAA1O+dRY1E+MsL4zMAvrkjRHGxaFuJMUn7NeLN6qYLdW2k3liWx
         4tDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/wAkO2VIXgEXGO/81/dkTBjdiCoL5B7xqkyttC27AeQ=;
        fh=0p1TNgS5Xncb/VmkyJL1orO7wNrknn2/qNX0TlVz7Ho=;
        b=dOX5f8Rc9BR8wsGsxruKpEBmKsu9efhwWBdNmnX3N/4jGtGq/uL5IvzUc7v30yn6r0
         MfE20Nf12msFHVVg+vna15cp59RJiHXDvBVZyeks8FOIIFAxmjMIIXn6wk4iRyweUlHJ
         D5KCbGxB/pGsnwNGrPMPji5QpywqK5qeAGmHBguZejGDy/s0fybVHHTBA91Z/sgx60KW
         YXoYKUX9M+Tc4n4RGR6DyahbA/RLr2/0IGXsyrUSibQp78LPObfsMCs4kpxdIi9IA9gG
         jEiAcpthYHS2VAE2/GYXy+5jI7bs9V1LBSA7ZgbqCcIFp7cnLomDw/AZ4hCdjAjsFujx
         s4tg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795541754; x=1796146554; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/wAkO2VIXgEXGO/81/dkTBjdiCoL5B7xqkyttC27AeQ=;
        b=JDRUZ4v9rYW8LwkrLhQ7AZITBqRMuIb9j/E6e9dvYhFklGVaC4gHLSc5+jlqyEmwpH
         7ZQV8mmAfHShXAuHNCl1bCfrcbTHhQrZHGaY2itgAyRbetX1pXOeWtCHDC8uHu9fR79W
         AMsLOu/g13cc5IxUCTH388kDBw4qEmcqPhqiK/Vg9XtY1B4Q+ZWiic78MLTRm5h/rfTR
         XFxHjZ8ry7gXAcDWvp8GSrdeTm3bYDUhzrkLsi4LxJXpLfn8W5kPVoLIKszKV+gBUl4Z
         DW+74oxN7KoF8E+3Z9qEL/Kitk5s1W0sVbCP7wr9RsWbZC4I8q+bVyEncrQC7iJKbYze
         c8vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795541754; x=1796146554;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/wAkO2VIXgEXGO/81/dkTBjdiCoL5B7xqkyttC27AeQ=;
        b=g/oeRNL9tu6On+IRsxzWJSwQu+ORsj8awKGOKlBQ2ZLM1w6r4aN+ZxiYzYusq1y9Wt
         efCzYLtktWdBRgQtji1xNmDWQgQqLQHn5XTozfFNuzsCUkPqQX60PttKRf0hUu5eOctg
         HRdho/N3jRS1zWflO3cqjlCtkuvLKU2EFs2yj5l12OlJ9N3tN336xApWdmE28QN7kI+R
         AirKWLN1joVDn/5x3pnt8eo5E1nCoXaV6qHPxN0PEykL7IbGrN2BecdA9yV5g5xHIkKR
         5vNYR4gdSSQeWgsSNndOAez6HUC+WZlytJM08FpwWFJKkCbSzchHFeAAg9l+0xMSYEpn
         l4aA==
X-Forwarded-Encrypted: i=1; AL+hErFiJWRy8CtKRg/1h0Tm12WEe9INDpu+jCPY7LGHhXb6LYBb3eRzwQ06koA919oyv/T8IMbQ9nDO5w==@kvack.org
X-Gm-Message-State: APuU4Z8PGXDq7RSvXCsvpVSdQohEyo0r8pJffSxApXcVL1YEtSrmhvAL
	xmQTzJEPQ9Q7yc5U0b1HYZOQBts/DWe1AkE6itrNjKDzX4sHsXGq3blWbgf1oXmhD1pe8pWO2iC
	BU6z+jR4j6vofP0f7SVtrGHyPEBZVNkUZm1i8r7/P
X-Gm-Gg: AZFdTZdna47bFM4MlnhNxy1S8HaSyYbfVcCC6gzfXSnnIxXKtH2iP5ngPdcnjXV5Uce
	xCYKLgSEGVCAOs3zFUqQOS918C5P7z5F+tji1zSuiRC5Rb/9s+qGyFiHk5keEpPbkTNAfuH7sqr
	Fbmo9xD5tvqxpwRfv7jsq005ZDuwVRzyhRz6IbCpTpq9BzzGmVMRR72dCLEvak2PIOKlrUX4+vG
	eYEGMcq+NMRMxZb3sPDslKaVQjtdOhX4cxz2ifjO3zojm04jWUgEGaOUEvmt2LpDACHO1ED7MXf
	PFSvF7TR+FcD78YnnuGMpkBLfdIZh2VRr0M4OW7czSR0yn30cwvAwQzO+xQgvokflU5c4TFgbgP
	9rdNm9kvZeskPxUPUcxVVDwG0vUKOXTtvWrtX3jEBl2rWvJy+qJpuRXAxgMhQhlUa+Qggff8cFa
	acl1Sb9zEztH2svJ6WVciu3QpsfwgNiEDS6nlXaShxdX/mvuEnGY8=
X-Received: by 2002:a17:907:80c:b0:c31:7495:e57 with SMTP id
 a640c23a62f3a-c513acc24abmr1257134866b.44.1795541753145; Tue, 24 Nov 2026
 09:35:53 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-13-jthoughton@google.com> <sashiko-outbox-228641@kernel.org>
In-Reply-To: <sashiko-outbox-228641@kernel.org>
From: James Houghton <jthoughton@google.com>
Date: Tue, 24 Nov 2026 12:35:15 -0500
X-Gm-Features: Aa3M54qM2bzzQR-P_rcwCCOMyq5mZyshNYBv8SLMy30_0cDsEPQ8yIqkgAXCpq8
Message-ID: <CADrL8HVaMx9r0kjm3LngCG61kNmK6OekexiUAvayoqO_fdykhA@mail.gmail.com>
Subject: Re: [PATCH v3 12/19] arm64: Support hugetlb vmemmap optimization
To: sashiko-reviews@lists.linux.dev
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Kefeng Wang <wangkefeng.wang@huawei.com>, 
	Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: st6qq4ptpk89rgb17amwnboob1qtrdhx
X-Rspamd-Queue-Id: 0F36880012
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795541754-741145
X-HE-Meta: U2FsdGVkX18ZdSQJyCVnfZKDJu6fZrhAfb0VjLx10B1dccXA3ruXSYpG544J9CmqLIk7L+OjiFUlBll4qoJN+zMEsbx+Tf/4xbGInLi750seJOigsCc3Ssn1ZHznsAQ/13IVEAZof0XKqEiUNnIXkis5mFxoKhBQ0SLHa7Asnqzd8zbCNYvMV3U5vUBn3sMmAaqlTbPI5JNIWWUVNhsGIyfna+69OFz54RNIat6toRe8a9RpUxidnSnli2iiknd011qZYWR+URiIK+y5dkvAvUc/91r2MMQKvGHquQCTBGPZuTc+nLmPM/J0HY+JnqtHZaKawkpHUgMJ7iv93neicqh27IGT21FVsJtmXB+mjnjsp1Q1D6h85MZm89yS5FFnbjKSaK1e0qi7z4epVUWzKDY3KptSwcT+3Ono1hRMarI2lBI/YmjbthARG9ADFLStOZdy9dDfDbgPSye3cr7V6LJKzZHRXLFaz/ZhBDlQeeqox0ujE75tObgtWwRYC0tXoAa3bo/vHC57pfUsV1uvKxykly9iJA/TXii3tGFbuiQ2Jx0eq/rylz95JcOhRzo/sgxMK+ejXfxZPgHc7U3j27UtqYLq58qG18wzkCiODef36d5He7bDoIMecDMUwT7P3xhogHjd/u8kPxiutLJOH9d+1ZaOalfAXtFLKzW0H18RJ0tuYitWBDZcsabzyybXHj/GWN2YVKJYyx6EBNFbyMlA6gNB5cRwP2obmR6PcSLycRBtxqd+hcOtqyzS2OTt2vCvH5CUwnWDVsZLd+kPcWdFkYn0WV9tkRV1BJsrkT7tO5tZpEU3X+m2iAm3bXpG6u86xpaxhhUMAWjLLVdKGfRrziFo/aV6YbMeUqQg8ief1UX1kAdtg1lDZCmg00jh8bO0WHIpd7ptEzWZADU6e94zQNQVs3bFx+Bqqoc+QqiqnNnXW1YKHXYSR0ZtFM4haWBT0qLCE5Md1UoCYue
 AhQr7LpB
 tWTUbxsGr97AtfmXXApq8xSctvDEbKudFvrxW9VeOYXuf0GaxIM8viQ6W3u6WchZ2cAODonOWKk+0lGlABoZuO31dAqhzaoWCdEMIQ3KQIjNsBbKJ4r+WXTDQr2pCNdwqye3dqyeGN/vJSQc3g3LJJn8yqWsTd6LH18vddy6S7VHPZE53mOAiPxV2mdtGhjg346AUbx0q+9p4Kzb7LC1nBiFLlyBeULQPRwCjZNY4Epc3rVxhAH5c1cQISn/qRufMUpoDlOD1RAInEdFnXpxS1e9XdwwjJOaINGUmQv93z5qSUPNtuclCQ5sWDzQqG3SX+9BsdsmqiW1jjYegA8uXhFchgKutTXBSvqIHdBxzkgsjhkfdzAhw0wr6dw08yBMDaxS7paD4LhqpR8+0rRGFigUDTx0eYzWI5yZ37AEkr4e1fKIERfWLpMUyQHwDk+aVeNLLjK/ZtICdZ2hBkYFryEh1x33moa51Ez8+1ELlum6YxqzF9VZika5pa65uE1VfrWxTJ3R7b+Ro0RWb6CDVTkZEhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 11:08=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] arm64/mm: arch_support_vmemmap_remap() only checks BBML3 on
>   boot CPU
> --
>
> commit d9205a2d3f06bed3d56fccb15aefe364db523337
> Author: James Houghton <jthoughton@google.com>
>
> arm64: Support hugetlb vmemmap optimization
>
> This commit enables HugeTLB vmemmap optimization (HVO) on arm64 systems
> that support hardware access flag updates and BBML3, disabling early
> section-based vmemmap optimization in vmemmap_populate().
>
> > diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/=
pgtable.h
> > index 7421c0a048ffe..5dadaac54bef5 100644
> > --- a/arch/arm64/include/asm/pgtable.h
> > +++ b/arch/arm64/include/asm/pgtable.h
> > @@ -1931,6 +1931,12 @@ static inline void clear_young_dirty_ptes(struct=
 vm_area_struct *vma,
> >
> >  #endif /* CONFIG_ARM64_CONTPTE */
> >
> > +#define arch_support_vmemmap_remap arch_support_vmemmap_remap
> > +static inline bool arch_support_vmemmap_remap(void)
> > +{
> > +     return system_supports_bbm_through_af();
> > +}
> > +
> >  static inline int try_update_vmemmap_pte(unsigned long addr, pte_t *pt=
ep,
> >                                        const pte_t pte)
> >  {
>
> [Severity: High]
> Can arch_support_vmemmap_remap() return true on heterogeneous systems
> where the boot CPU supports BBML3 but secondary CPUs do not?
>
> ARM64_HAS_BBM_THROUGH_AF (added in commit "arm64: Add bbm_through_af
> capability") is registered as ARM64_CPUCAP_SYSTEM_FEATURE, so
> has_bbm_through_af() is evaluated once with SCOPE_SYSTEM during
> setup_system_capabilities():
>
> arch/arm64/kernel/cpufeature.c:has_bbm_through_af() {
>     ...
>         return cpu_supports_bbml3() && has_cpuid_feature(caps, scope);
> }
>
> While has_cpuid_feature() checks the system-wide sanitised
> ID_AA64MMFR1_EL1 value for SCOPE_SYSTEM, cpu_supports_bbml3() only checks
> ID_AA64MMFR2_EL1 and MIDR_EL1 on the local CPU running
> setup_system_capabilities() rather than checking
> cpus_have_cap(ARM64_HAS_BBML3) across all early CPUs. If a secondary CPU
> lacks BBML3, vmemmap_split_pmd() can still perform live in-place PMD
> block-to-table transitions via pmd_populate_kernel() without
> break-before-make, risking TLB conflict aborts on the vmemmap region.
> (Note that commit "arm64: Drop BBML3 requirement for HVO" later in this
> series removes the cpu_supports_bbml3() check, though that part of the
> series is marked DO-NOT-MERGE.)

This is the same issue as in patch 9. Please see my reply[1]. This
will be fixed in v4.

[1] https://lore.kernel.org/linux-mm/CADrL8HUgo0zAHe7_eF1+hfTR6jBbZ=3DUKB1q=
PpMWpksvqbNHsyw@mail.gmail.com/

