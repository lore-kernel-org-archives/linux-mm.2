Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B0A360A381C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fij9A7Cs
Received: by kanga.kvack.org (Postfix)
	id 9CCB66B05CB; Tue, 10 Nov 2026 11:03:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97EF66B05CC; Tue, 10 Nov 2026 11:03:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 846A36B05CD; Tue, 10 Nov 2026 11:03:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A2606B05CB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:03:07 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 55C3E140953
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:03:06 +0000 (UTC)
X-FDA: 85419678372.16.65F3C65
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 56096C0010
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:03:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fij9A7Cs;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794326584;
	b=p9UPxYoyvzEDklPQfaG6Hid8/ZQJdvwArDqsratSZgwlr6cerif3G5PS7vAgzrNVlq2bJB
	pfE1ArHHxRWrzJb7zSDK6zJWkcSUrImIksYeD6Bj+L5e7RDt+EB+qMheY4KVAkzNi1Q4QM
	UDmvi2lOYgMbyj5n09CKjtnqjSYzCmQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fij9A7Cs;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794326584;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z6ZGGbGpSoM/+UHOllYnr/FP0VqeEb/suB8w92bzgOY=;
	b=uvGPPE+DcbfKevEoUPg0fTSdaLopiqEghPMd2eOTbv/oYkto9hQiSMAvAEvDFMRQnsx62/
	/R28Z1QvMRUbaRTAhxF6a4E+ykC2u99pmXG9IAGO9wacbe5rWOjA2CJLuAu/hejqEDbdF/
	78q+zMi3C9YHJ2Z8bad6RxpTF7Hwl7I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 80F4D414F8;
	Tue, 10 Nov 2026 16:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C911F0089F;
	Tue, 10 Nov 2026 16:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794326583;
	bh=Z6ZGGbGpSoM/+UHOllYnr/FP0VqeEb/suB8w92bzgOY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fij9A7CskjoNLPyepSzbrScEY7bbbH+eg1vmeCQXYsrFWcfGnmQh8IVsxeTrZsy74
	 XoSOCF3rAlsathE//UXf8I1JunjgxcJOIYG+w/Dez9iGJjRWEIwbxn28fJImR3ksMo
	 qynCqQ4qsPv4GLVewV7KXatVshPgacUpRcBPTVNjAfgyrgLFqhBTOkz/bXgQs2NgjL
	 voCJ8jSFEHnpTGZvmKWjiTzRaVifUdMVZd40xy7RLJoUzxIE6bxZeCOsG3ACFomnAa
	 KQzgnlOCDSnw57kxa+PEyaHuglyYniMmVWTPFq5qFdPqGTetePwYx0lWkjSgmIr14v
	 aM+6OtLBK0yHg==
Message-ID: <sashiko-outbox-207336@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v10 22/22] mm: Add basic tests for
 kpkeys_hardened_pgtables
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kevin Brodsky" <kevin.brodsky@arm.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ard Biesheuvel" <ardb+git@google.com>, "Andy
 Lutomirski" <luto@kernel.org>, "Catalin Marinas" <catalin.marinas@arm.com>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, =?utf-8?b?RGF2aWQgSGlsZGVuYnJh?=
 =?utf-8?b?bmQgKEFybSk=?= <david@kernel.org>, "Jann Horn" <jannh@google.com>, "Jeff
 Xu" <jeffxu@chromium.org>, "Joey Gouly" <joey.gouly@arm.com>, "Kees Cook" <kees@kernel.org>, "Linu
 Cherian" <linu.cherian@arm.com>, "Linus Walleij" <linusw@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, "Mark Brown" <broonie@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Maxwell Bland" <mbland@motorola.com>,
 =?utf-8?b?TWlrZSBSYXBvcG9ydCAoSUJNKQ==?= <rppt@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, "Pierre
 Langlois" <pierre.langlois@arm.com>, =?utf-8?b?UGllcnJlLUNsw6ltZW50IFRv?=
 =?utf-8?b?c2k=?= <ptosi@google.com>, "Quentin Perret" <qperret@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>, "Ryan Roberts" <ryan.roberts@arm.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Will Deacon" <will@kernel.org>, "Yang Shi" <yang@os.amperecomputing.com>, "Yeoreum
 Yun" <yeoreum.yun@arm.com>, linux-mm@kvack.org, x86@kernel.org, "Ira Weiny" <iweiny@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Thomas Gleixner" <tglx@kernel.org>
In-Reply-To: <20261109-kpkeys-v10-22-aa6c4d9603bc@arm.com>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-22-aa6c4d9603bc@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 16:03:01 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 56096C0010
X-Stat-Signature: xk8jnnenbdopqx5cztasbw5f1ax3iru7
X-Rspam-User: 
X-HE-Tag: 1794326584-119993
X-HE-Meta: U2FsdGVkX19grie8dsljWPKT09bJElkhYU0OQCsPn1I+jFdMkA5wNlttse/YvHOjWb++VmY++oUFx/pCos8UXWTuq6DQ6gBF/UM14X2nNweqD5kfa0R4i4O6UvjBdr9C8sF3tp38Dp26YP1ZA50B5tsNjhrrdqLnoNXeX4m2ZMbmwqxia0jp4iiIuTe0Wb5ntmWu8WkJPfo9V90ljTvXo+VXS2HrYj+KVY11sfG+sXm8aO7eYwvjj0WSLFbSt3hqAwVaegJVDysLq8ArXNCy+PL/MkKP/x2050DPt7dJeGlp967MOg4qANmab+MDIQaL1KcnRl3g+cTj39DE9q/FDr9RUD+Nlb5OGHc5GNlUx78iamvvCP4nqRVGkGuewfMkzq5rvmX9b5dVE57ImuWoxDLcMWbnA8Jl9a9Xj8yQmmlfIJkmvWL7bm5RibKL8osnmH+3RdhEQf/o3waq6BD+Fh7vbhECGLAnXOtBoAlg5Rtt8t94yc1699NMIOktYJ4F762vg6ocD43pZw6hehcZgx+tJkHsEusBgI5cVXu4FxgTsKA4lpLNjUzd0MAVCu8j5j8m0Jmss3EAqW7JnSR7Nz0KKga2Mkj90TaylrfuUchIzRO6NXzxz1YWutD1LxBLWyTEysYMnHsDu+kPzf244S7PnoXpshB+tda2+To2zLi1Vcj3Clbt0ZKVEgQbiTpTnoIRs9UMfyZecJD/696Rioawa25IJQ+S9IgCBKZGiwTMHh4HMpg8CMayfhxFXlvNG+h6Frwxr/NHgNhCvIJpgmUo0PoWuY+EtkkV3CueG5H+wzn2ea+uSmPBJODEqt4XN+JSNg5SyhkLlCAh8FY+ljG/7U8YTJrhRQve2fwRxGwd1mXQgFijxTKp7jPbbiqoHgrhecitv7PcP8L7I85ic0LzxtxedlyD7xmLC1VG7ilTB5yWCtw09BXwzU/YpCDZ3bqPcRzhcxVQ1T6VwDh
 2NAdiQW+
 kAL6emrsC41KhKvAB2rvJsDdbwdwGyw+vYny7PuMfIgCG86tScLTAL97UiWSQdp3YkvXxlHrIcVKhuw3xug6CuABy0Wkqbf3a/OiD5H+1sQEXS88ZtpkvMYGdy9+GR8x+9N/GGQpRMEjao/DY50ATup6AQS6qaMkP8IR/g/xBS6FLY+SqaBy2ZlsiK08pKu2v0ZlYtP+qV7hGjCIGt90PS1uDe3anKCrQm3o2WV9lia+QPz9TRsPdxsG05wUKhep8uImP0gv2k7+pOlghd81eTPE8m01DKi6zEn/GvgAzQ7Bg7fDR8yKXazRSoOyBbnGWXSlutCq83fqDP9iWXydhlx9+jgP67vS2xdvfsPwfLV33tcDUOM5ZHn8yPVA1ob2Ydz0//l8ey5CyLWMTKtWq1g4aPPUS1mSeYoamZlkvyc1/GECH9Nf8TijdUkWCLUtkLMS3+MbSDClz6wGHqPyAjnV1Qf/OkVfvARtE9zWZhOW8xhf9JjSZImOtlVbQqzLM+mYF64omBL8okTeZZ9jqPcwOs7OjS6GQhOo6AQOdLHxXiVyylfSaKhV+ruTeqS3/V3hnjnRrdBxQoFGvfTi3TWMgjgJ/crNl8YnXZaPVWuzeJ7eI75g6lZ6fhM8aWnpwHi4LrJFoP1SPYHuezrG4J2pPq8E/+WrCfK6trK9ZQp9l9q33NQkA8iwxwlqFxNF3xosSeuRMN6DvX7Zoa/ZBH9oaz1AfuCd9GhlTk/YsJ7eAIE9el4tOTdqNYofY0prju6JX8wZySQWbsmjEyte+yfFGfA==
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
- [Medium] mm: missing folded PUD and PMD checks in
  kpkeys_hardened_pgtables KUnit tests
--

commit 2fe47b9a3fc12c652abdd8342ffe143ffdaeb477
Author: Kevin Brodsky <kevin.brodsky@arm.com>

mm: Add basic tests for kpkeys_hardened_pgtables

This commit adds built-in KUnit tests for kpkeys_hardened_pgtables that
verify direct writes to kernel and user page table entries fail with
-EFAULT.

> diff --git a/mm/tests/kpkeys_hardened_pgtables_kunit.c b/mm/tests/kpkeys_=
hardened_pgtables_kunit.c
> new file mode 100644
> index 0000000000000..b6e1eba0d9b99
> --- /dev/null
> +++ b/mm/tests/kpkeys_hardened_pgtables_kunit.c
[ ... ]
> +	p4dp =3D p4d_offset(pgdp, addr);
> +	KUNIT_ASSERT_NOT_NULL_MSG(test, p4dp, "Failed to get P4D");
> +	if (!mm_p4d_folded(&init_mm))
> +		write_pgtable(p4d, p4dp);
> +
> +	pudp =3D pud_offset(p4dp, addr);
> +	KUNIT_ASSERT_NOT_NULL_MSG(test, pudp, "Failed to get PUD");
> +	if (!mm_pud_folded(&init_mm))
> +		write_pgtable(pud, pudp);
> +
> +	pmdp =3D pmd_offset(pudp, addr);
> +	KUNIT_ASSERT_NOT_NULL_MSG(test, pmdp, "Failed to get PMD");
> +	write_pgtable(pmd, pmdp);
> +
> +	ptep =3D pte_offset_kernel(pmdp, addr);
> +	KUNIT_ASSERT_NOT_NULL_MSG(test, ptep, "Failed to get PTE");
> +	write_pgtable(pte, ptep);
> +}
> +
> +/* Worth checking since the kernel image is mapped with static page tabl=
es */
> +static void write_kernel_image_pud(struct kunit *test)
> +{
> +	pud_t *pudp;
> +
> +	if (!kpkeys_supported())
> +		kunit_skip(test, "kpkeys are not supported");
> +
> +	/* The kernel is probably block-mapped, check the PUD to be safe */
> +	pudp =3D pud_off_k((unsigned long)&init_mm);
> +	KUNIT_ASSERT_NOT_NULL_MSG(test, pudp, "Failed to get PUD");
> +
> +	write_pgtable(pud, pudp);
> +}

[Severity: Medium]
Will write_kernel_image_pud() fail on configurations where the PUD level is
folded (such as 3-level page tables on arm64, or 16K pages with 52-bit VA
without FEAT_LPA2)?

When mm_pud_folded(&init_mm) is true, pud_off_k() resolves to an entry in
swapper_pg_dir, which is not protected by kpkeys_hardened_pgtables and is
still writable when built-in KUnit tests run before mark_rodata_ro(), so
copy_to_kernel_nofault() succeeds instead of returning -EFAULT.

Similarly, on 2-level page table configurations where mm_pmd_folded() is
true, the unguarded PMD writes in write_direct_map_pgtables() and
write_vmemmap_pmd() resolve into swapper_pg_dir, and pmd_off() in
write_user_pmd() resolves into current->mm->pgd (which is slab-allocated
from pgd_cache rather than kpkeys_pgtable_alloc() when PGD_SIZE !=3D
PAGE_SIZE).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-kpkeys-v10=
-0-aa6c4d9603bc@arm.com?part=3D22

