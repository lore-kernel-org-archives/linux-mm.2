Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8B63606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 11:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Dwjp75Wa
Received: by kanga.kvack.org (Postfix)
	id CB0BC6B09C1; Wed, 25 Nov 2026 06:33:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C87AE6B09C2; Wed, 25 Nov 2026 06:33:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B76786B09C3; Wed, 25 Nov 2026 06:33:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 909106B09C1
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:33:01 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 220691A0DE4
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:33:01 +0000 (UTC)
X-FDA: 85473429762.29.AFC207D
Received: from mta0.migadu.com (out-225.mta0.migadu.com [91.218.175.225])
	by imf15.hostedemail.com (Postfix) with ESMTP id D2812A000D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:32:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dwjp75Wa;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.225 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795606379;
	b=disxR8p2YS0sZPHjC3eqH1ySZWCRKlGszST+y9ktD1CiCjWchnxiKTTuybGMf2Yz+SkvCA
	d82eSLNIETfGyu8LdWY3y95QnKAxo8OJVQR7TWf8ssAG221u3ebXKBE958uMjhQMX90DO9
	vKnJMRaYWOSsvKfvOiXEx7A//OMOXqM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795606379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0V6f85LpMW4xwrS3x6+t74PKgkFqxH39qfpnircqYfU=;
	b=jOFg1Xx9AmAwiKwDqciDmKeWOq9cyWb5GGe6Y+XlKpmnLzdxCY8iA1uykUHZdhrZ9J9Sto
	jpTycW+W5agIBanMQkg9yKoVkLqTqxLqmC8nUOfwIubcd+5AagDIpUC6XV9yvkXZyvrvAO
	IwvUfUPVFFYFdw+QFkq6dmiXsZdeZxg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dwjp75Wa;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.225 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=DeSjNojkk4MD/tKsHkRDT7b8MjIXbSU/jX7LSyciBWI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795606376; v=1; x=1796211176;
 b=Dwjp75WaPQLe2GefeA80kr6niIOaCdkb8YzS1evkZiW/zoA/ncTRFFzSlMJtn+YbTNEPRe6j
 SpeTFw+wyiOQxcTg0NyAOu3DzKLpbREWLtDtZRsubcVBMVg2KI6SGKjWHy/04avRnknTZpqQ2n+
 orEqGU+oOWBeu8RPeqWpSxP8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 92cb8adb5f7c7ac6;
	Wed, 25 Nov 2026 11:32:55 +0000
X-Mizu-Trace-ID: 92cb8adb5f7c7ac6
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v3 16/19 DO-NOT-MERGE] arm64: Implement
 try_populate_vmemmap_pmd using AF trick
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <CADrL8HWNAByKifcNgre_YAX3M+bwAW0BgMrfPmWHubOEs+AfDQ@mail.gmail.com>
Date: Wed, 25 Nov 2026 19:32:37 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 sashiko-reviews@lists.linux.dev,
 Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kefeng Wang <wangkefeng.wang@huawei.com>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>,
 Linu Cherian <linu.cherian@arm.com>,
 Mark Rutland <mark.rutland@arm.com>,
 David Hildenbrand <david@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Nanyong Sun <sunnanyong@huawei.com>,
 Yu Zhao <yuzhao@google.com>,
 Frank van der Linden <fvdl@google.com>,
 David Rientjes <rientjes@google.com>,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <5028917F-EFF3-488C-903E-9E19E5DDA3D1@linux.dev>
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-17-jthoughton@google.com>
 <sashiko-outbox-228645@kernel.org>
 <CADrL8HWNAByKifcNgre_YAX3M+bwAW0BgMrfPmWHubOEs+AfDQ@mail.gmail.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: D2812A000D
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 4u3tjsctqff9engizs35uwih4jc5gooo
X-HE-Tag: 1795606378-723707
X-HE-Meta: U2FsdGVkX19ePGYoeLonu8al4gum8VYd/R6TosqjoNIuHS6z88no7nylNwPtQq27JITs/Xwq66Xs6vLQzIDDDVSI7R4BtZaLN1nxf7aJS7/pFvHa0qEbXabV5nMm0wXjlWkDSoVsnUPDK0MOtb3VQZBaDs4+XAxixbVxHxQ29nZBpDLd8nUkRaPID7i/y9hhezIcbN6VtxFRt4qQ6cTvi+V7PIdIks5wqf6f1IkJxEOYf6nYQTdFdhd4h6eaQVKKi0837YruH3+KHlc2RSONYD9paGYUBy61YY7ngNRxGSmIplHr5o/4IHldErT2ynyYf4nV55Ii+cueVkYXrnUvmeUrML+vdq/XkrIpzy3dRbrWfPPyjOUkvyoyidplqE4jZ8HajW71tZQeqGBtPjCSe75N8Zt8H2HM/dtj3SHADee1Wn0QPAFpg8/8L1w2dYP/k3IvUIGsV6NbpaUiCncMPlyq/r4a2Kv6TEtXvWMo6TgZwgEvQGagtu+DthUJDqne9BwJBoOcDo57LmBWiQqY7mqqhMEppQLNGlsOLQdZAHub91/FSYbSu6uve/5YeYRa63L2xiDojz+5Fw1ErBRLaTsUyRhDZ/+Rv9TGPG60UIx6+E5uyBM5btAUHyi9oe7AIp7MoR9+v4y7XlEbSxp5fqCJ8gc0Hgohbxwe6XX2Y5EaRz9D7phMzAqD7Em5yWUHB8rZcG7tMIGMi0bA+9DawQEPoKtTkZ9jSzqNX5LOUnwzvNon9xdn8R/RxnX/ir7rCg7yLqhJuYj4EbgTvmVVnZGlqEu6aeVW+Rm0CCR1mT8ovwNcXuC7uK6vDwLvvdxD7RiNQ48Si2EhsQts0xspB0IIJivM7tT5PpdWXOxEXnWXNQD2FwjYkHNjyBPSwcMkJgSAgLHFqhTuHc7IqNbOZZV+Iu9jBaol5dDR3Rc9Ylz6f7xwikrfugZ9gUlDLqXTb1uPZiClxgjRA5M5SIS
 u2+rQItm
 mXObyFPb083PGWJC1M7HGVq0Cr98/2TyJHeSS2tXC5LSfI/gL43EDILzHUomTrScte6iIo8YH0Ap8/TtCQIfBZB0YpOGqyb4/EhzpfjUBMS7yCkPythRSko+ajigQ303eFfqL8BachLILY+dS72U5cQYgL7t/asZ4o3/1TF0a9FzDMIwSNEBgl3TVgtXsotyp2o9COex7pUJtMWHyjXLYUYeHqJqVLdv4REqAGwCJ2NJXhZaP99D/lGBCGWoFNoJOabwdkchXq/xpBBztfyGOL1YBjzoZVM8cUa03KHf5CdIGTWfeX2LRGzwPbkPBiAJBPrx35ZIJmMcQA9EQCTzIUw0aeA/S6keyBfH132y5uz0PeVEYZanJpe4DRzlXG19RgC0FZQ95UJ8nnNr/gFIk5haPYt2/vPYdJ6PpAvArOdQjogMUZL5oh8Wo9rvHw62bCtGXcHVVCvRsLrAlXm49uoGnrXUgufIZA0SoN2meAj6rLSc2vfrfohNHAbZSZaqipoq336xhiSoq9B5PULCCkIN4elYUdpCoEIFzs3wsWxTpBVDydnVAw/3zdwYMn5fGqJV/qDkdnT7iKy121gvnMfdBTW3/9o0Bm36h+MUU/NI+EGj1LCmjK3vnpO8gN5elfSpTJD49ZZ51BX2VBt9Ii+dVLenzjc7gFzSdr+/ENxKioEXyLxWklORnKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 25, 2026, at 01:39, James Houghton <jthoughton@google.com> =
wrote:
>=20
> On Sun, Nov 22, 2026 at 11:08=E2=80=AFPM <sashiko-bot@kernel.org> =
wrote:
>>=20
>> Thank you for your contribution! Sashiko AI review found 2 potential
>> issues to consider:
>> - [Medium] arm64/mm: over-broad TLB flush in =
try_populate_vmemmap_pmd()
>> - [Low] arm64: direct AF=3D0 block-to-table transition in
>>  try_populate_vmemmap_pmd()
>> --
>>=20
>> commit 1319c4a7862ad5f3b810c4beca866ee98bd48fd7
>> Author: James Houghton <jthoughton@google.com>
>>=20
>> arm64: Implement try_populate_vmemmap_pmd using AF trick
>>=20
>> This commit implements try_populate_vmemmap_pmd() on arm64 to replace
>> in-use leaf vmemmap PMD block entries with table entries by clearing =
the
>> access flag instead of using a break-before-make sequence when BBML3 =
is
>> not supported.
>>=20
>>> diff --git a/arch/arm64/include/asm/pgalloc.h =
b/arch/arm64/include/asm/pgalloc.h
>>> index 0263329fb7b30..7e304f01ce6d5 100644
>>> --- a/arch/arm64/include/asm/pgalloc.h
>>> +++ b/arch/arm64/include/asm/pgalloc.h
>>> @@ -124,9 +124,54 @@ pmd_populate(struct mm_struct *mm, pmd_t *pmdp, =
pgtable_t ptep)
>>> static inline int try_populate_vmemmap_pmd(unsigned long addr, pmd_t =
*pmdp,
>>>                                         pte_t *pgtable)
>>> {
>>> -     /* BBLM3 is required. Its presence has been checked. */
>>> -     pmd_populate_kernel(&init_mm, pmdp, pgtable);
>>> -     return 0;
>>> +     const int max_attempts =3D 16;
>>> +     int attempts =3D 0;
>>> +     pmd_t old_pmd, new_pmd;
>>> +
>>> +     if (!system_supports_bbm_through_af())
>>> +             return -EOPNOTSUPP;
>>> +
>>> +     if (system_supports_bbml3()) {
>>> +             /*
>>> +              * BBML3 allows block->table transitions if the PTEs =
underneath
>>> +              * do not conflict with existing, potentially cached
>>> +              * translations.
>>> +              */
>>> +             pmd_populate_kernel(&init_mm, pmdp, pgtable);
>>> +             return 0;
>>> +     }
>>> +
>>> +     new_pmd =3D __pmd(__phys_to_pmd_val(__pa(pgtable)) |
>>> +                     PMD_TYPE_TABLE | PMD_TABLE_AF | =
PMD_TABLE_UXN);
>>> +
>>> +     old_pmd =3D pmdp_get(pmdp);
>>> +
>>> +     do {
>>> +             if (WARN_ON_ONCE(!pmd_valid(old_pmd)))
>>> +                     return -EINVAL;
>>> +
>>> +             if (WARN_ON_ONCE(!pmd_leaf(old_pmd)))
>>> +                     return -EINVAL;
>>> +
>>> +             /* We should never get a contiguous PMD here. */
>>> +             if (WARN_ON_ONCE(pmd_cont(old_pmd)))
>>> +                     return -EINVAL;
>>> +
>>> +             if (pmd_young(old_pmd)) {
>>> +                     /* __ptep_clear_young() returns the =
overwritten PTE */
>>> +                     old_pmd =3D =
pte_pmd(pte_mkold(__ptep_clear_young((pte_t *)pmdp)));
>>> +
>>> +                     flush_tlb_kernel_range(addr, addr + PMD_SIZE);
>>> +             }
>>=20
>> [Severity: Medium]
>> Should this pass addr + PAGE_SIZE instead of addr + PMD_SIZE to
>> flush_tlb_kernel_range()?
>>=20
>> Invalidating a single non-contiguous PMD block entry only needs one
>> overlapping page-granular TLB invalidation, as in
>> unmap_hotplug_pmd_range().  With a range of PMD_SIZE and stride of
>> PAGE_SIZE, pages equals PTRS_PER_PTE (MAX_DVM_OPS), so
>> __flush_tlb_range_limit_excess() returns true on CPUs without
>> FEAT_TLBIRANGE and escalates the flush to flush_tlb_all().
>=20
> Oh! I didn't know that!
>=20
> I will change it to PAGE_SIZE instead of PMD_SIZE in v4. Neat!
>=20
>>=20
>>> +     /*
>>> +      * Translations without AF cannot be cached, so we can replace
>>> +      * them without BBM.
>>> +      */
>>> +     } while (!try_cmpxchg_relaxed(&pmd_val(*pmdp), =
&pmd_val(old_pmd),
>>> +                                   pmd_val(new_pmd)) &&
>>> +              ++attempts < max_attempts);
>>=20
>> [Severity: Low]
>> As reported by Catalin Marinas on v1 [1], this rests on an =
architecture
>> detail the review could not confirm from the kernel source: can a CPU
>> walk cache or TLB retain information from a valid leaf block PMD
>> descriptor when AF=3D0, or is a TLB invalidation and =
break-before-make
>> sequence still required before converting a valid AF=3D0 block =
descriptor
>> into a table descriptor without BBML3?
>>=20
>> If it can, skipping flush_tlb_kernel_range() when pmd_young(old_pmd) =
is
>> already false or directly overwriting the valid AF=3D0 block =
descriptor
>> with new_pmd leaves stale walk-cache or TLB state active while a =
table
>> entry is installed.
>>=20
>> [1] https://lore.kernel.org/r/aoSJcAFMNJ1nPl2H@arm.com
>=20
> Yeah, this is why these final 5 patches are marked as DO-NOT-MERGE.

If we aren't sure about the hardware behavior here, why don't we just =
drop
these patches? Once the initial support of HVO for arm64 is merged into =
the
community, we can bring up this uncertain part for discussion. Wouldn't =
that
be simpler for this series?

Thanks,
Muchun

>=20
>>=20
>> --
>> Sashiko AI review =C2=B7 =
https://sashiko.dev/#/patchset/20261122184453.2668189-1-jthoughton@google.=
com?part=3D16



