Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6F6A606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 01:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=evm/S/UF
Received: by kanga.kvack.org (Postfix)
	id E1A536B0B4A; Wed, 25 Nov 2026 20:47:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF1876B0B4B; Wed, 25 Nov 2026 20:47:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2D686B0B4C; Wed, 25 Nov 2026 20:47:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A9D5A6B0B4A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 20:47:49 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1FB85C023A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 01:47:49 +0000 (UTC)
X-FDA: 85475583858.24.E4772D8
Received: from mta0.migadu.com (out-108.mta0.migadu.com [91.218.175.108])
	by imf31.hostedemail.com (Postfix) with ESMTP id E197320002
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 01:47:46 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="evm/S/UF";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.108 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795657667;
	b=iwbfQg/LRpy146PNi1L70aczgQSbA7t19T3FnxWDNwHs4xNFHvXrRtMZQpgY2izxBp3A5k
	V6/1FWMVRo2kQMnlIvczZ7XCHbfUauCVTB/JYEHj0j6dv5LZG4k+0xoZDFQb4TMmOrh3p9
	c/7CMSEL04sCpEtm/t96agx/YTGR5JI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795657667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mb15UcfveKlfqCEVgqDRD0tZugI6epRX52mAuCN9OyU=;
	b=z3f8ct+a6q+XUYDh/EdxyeBvs8PhafU4v58lVch+sB/x81+wBAJgP7SL06OTS+Dt4Ydwv3
	1xiM6dSYYvfy0X6qCSVbmDvhgSX4iAQ3+md2k3Qk+qs6T3G5TuXcXUG3jFQeogldnlm/PE
	33HCKKnNei2cdXoXRHuB7M1l5UDlbPE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="evm/S/UF";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.108 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=I7u+gRQ+y6tZqnBiz/yfcLTETEoXo+FFQlNVsHLgCm0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795657665; v=1; x=1796262465;
 b=evm/S/UFpM+/sktJBfNHf00wjaiSoIaOYa8G3Z9pFgIKmrW60gqUrppfJw6xFMwah30aopi+
 V4+Yl6oG3tCHCiRqaeAk8WHK12SF6hc5MDd+1STO9XCIMKsr5PdiGf6lQjn/QS57DYaWo1O0UGK
 Bxi5hnKlGXdDSw/qiVZ1r8iI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0d3f34471a6ddac6;
	Thu, 26 Nov 2026 01:47:44 +0000
X-Mizu-Trace-ID: 0d3f34471a6ddac6
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v3 16/19 DO-NOT-MERGE] arm64: Implement
 try_populate_vmemmap_pmd using AF trick
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <CADrL8HXtwnZ4P7E4OhMKs03b2zgzfxnmAHMw4mknjivAk+FVKQ@mail.gmail.com>
Date: Thu, 26 Nov 2026 09:47:30 +0800
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
Message-Id: <F29037A6-A177-4DFD-9864-285E9566D7B8@linux.dev>
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-17-jthoughton@google.com>
 <sashiko-outbox-228645@kernel.org>
 <CADrL8HWNAByKifcNgre_YAX3M+bwAW0BgMrfPmWHubOEs+AfDQ@mail.gmail.com>
 <5028917F-EFF3-488C-903E-9E19E5DDA3D1@linux.dev>
 <CADrL8HXtwnZ4P7E4OhMKs03b2zgzfxnmAHMw4mknjivAk+FVKQ@mail.gmail.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User:
X-Stat-Signature: q7wemndw7ijjr4jwxfifz1sen4jbj4kh
X-Rspamd-Queue-Id: E197320002
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795657666-503579
X-HE-Meta: U2FsdGVkX19ww5WI1QKVf7XhC0Z0KLMXkMo7T5u1XAMNIIX6jwO2IvDLpUPvEvjaMhnntEnGJCO31sHP9ZntHDmbbxyJHaPGOLOtif7KsYqqbFnSasGcko/n0LrZEw0ro6Hwh4kpsp1ZCQZlfW0Cu9lAj4zAXuzo0S85cgKson5JVuyAClnZqkdlSyuq569JczU1vFB1z0Bn6YcIPe5xa7+0xP91+exbuN2v06XQ8D9cB7qIzHL5B2OTrp8D0fNSl5xNbeZ8KKy/73QWXaSLVvRUTB3H6qTJf++tWRddCLtkguagQSU/Y3ZAdgaZSRor3O76Lb3ILitVyzMQHAg9oq6fYJ/rgwaIJFXoZvJdvaOaK+S03Of94TZPl6Ijk4qZklHQBxmj2GyyoibOtDbPQrP2E31Bw1U2fbUTF4qKWDvfD3WOh8bMEr7WcQSmPMkm4/fUgW/avorZ9bt2eAo39gJZTE54YZpazljOQGQDGsdrU2Ao7a7vgqI/13P0KF7Ssx6yZ+QHau3ctN8zLC65vJ4KRz/nnpiRkVF1+2g0BOx3BOI8B4EID+mkdXmUEh95a2NT6zhYaCl4l1M6gpT2wQqust02YIoNGGw6AGLkAbgGdDljJnD4GZDJOX7rxba1q4wdyASKsXb88s7m8GCjobhSSfL6UFASkHCTKlY2T+h8CMHheq6kwMKTE5ZS5WVruoNitl5aq13jh169KixZO6JQstupotqAgt0xu4WCqky4gTWRD5VXQbE36xlW4XiP4Rgw17fiO4vXq3eJkyl2bR+P/KbO/+kSa+v0tSxRm0LjMhhdud6LLHtkMYa/P65h7P2jCRx1htyeyqiwCHeypZltB4+1MvIJSTQtfhoh2vQ5w5ztl9CkqQH5KTHcpsw2DwuJbNKBtrOiIZkbBPDW7W55EfZnkREoWbVCoOoVWO1THDUKwb4v3RORmJzkrguXXsrJYozo9ZNCEsB28ux
 OG4m03Ey
 IfA4yUmVBRniw4wHxNlvkOHsaaXRi4ZWIR56HHOyKlc+6xUlTlVLy4d8hA8R8T3fbnjpdoqB3ZBmPRA0b+S9+x39Wk/bVdWJwkZPHcvK5C6ig5MXZkiFqosoYNmJk8Ax3HRNfwMwJ+3gswKYv+jXRz8KmgpYYQJ+VIfI14IFLQDLDPYHZKtLUQty8WbdHE95x9JSsjKJia0bYMJBLhCsH9D2G8hqtT2bL5QctvKVA5Yl2vq31iR7yxyXwWMmbnXRaTVr8UeNEKYqKpgSaKaqNYEkhO36MPyBnCk599l+YCw6UUOd3y6esHIsx2+2RFcCqEn9quk7CA6tIojyEVuDVwv0MDMvXpl4p4jT4u2tPOQg1sS/CRKjFwX1oZmU/DgO6RhbSlOaZr5SZB9Jv5ifE0sKu0WdkjhRc9WcnYUcQVdhKpnGAO23REllnDtlngW4g7P2tp+dR3dZhkGr8N4POWvqrlCUx6nrGqsq4opOiZRwjop+bCPl9rYzcKLkiiaxY8PyCWUnzXNviUN5gEO+ENMwHwrHnrOquUBnobCZGZ88CKJ/1+ijfR5V3YDw4A7BWHwt9o/Hzb9Cs6bVaFC/KA56Nl3i9xZSVBKrkAyDiHZyDlcjr9Q5BzwUbSn8abasa+Bxp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 26, 2026, at 00:35, James Houghton <jthoughton@google.com> =
wrote:
>=20
> On Wed, Nov 25, 2026 at 6:32=E2=80=AFAM Muchun Song =
<muchun.song@linux.dev> wrote:
>>=20
>>=20
>>=20
>>> On Nov 25, 2026, at 01:39, James Houghton <jthoughton@google.com> =
wrote:
>>>=20
>>> On Sun, Nov 22, 2026 at 11:08=E2=80=AFPM <sashiko-bot@kernel.org> =
wrote:
>>>>=20
>>>> Thank you for your contribution! Sashiko AI review found 2 =
potential
>>>> issues to consider:
>>>> - [Medium] arm64/mm: over-broad TLB flush in =
try_populate_vmemmap_pmd()
>>>> - [Low] arm64: direct AF=3D0 block-to-table transition in
>>>> try_populate_vmemmap_pmd()
>>>> --
>>>>=20
>>>> commit 1319c4a7862ad5f3b810c4beca866ee98bd48fd7
>>>> Author: James Houghton <jthoughton@google.com>
>>>>=20
>>>> arm64: Implement try_populate_vmemmap_pmd using AF trick
>>>>=20
>>>> This commit implements try_populate_vmemmap_pmd() on arm64 to =
replace
>>>> in-use leaf vmemmap PMD block entries with table entries by =
clearing the
>>>> access flag instead of using a break-before-make sequence when =
BBML3 is
>>>> not supported.
>>>>=20
>>>>> diff --git a/arch/arm64/include/asm/pgalloc.h =
b/arch/arm64/include/asm/pgalloc.h
>>>>> index 0263329fb7b30..7e304f01ce6d5 100644
>>>>> --- a/arch/arm64/include/asm/pgalloc.h
>>>>> +++ b/arch/arm64/include/asm/pgalloc.h
>>>>> @@ -124,9 +124,54 @@ pmd_populate(struct mm_struct *mm, pmd_t =
*pmdp, pgtable_t ptep)
>>>>> static inline int try_populate_vmemmap_pmd(unsigned long addr, =
pmd_t *pmdp,
>>>>>                                        pte_t *pgtable)
>>>>> {
>>>>> -     /* BBLM3 is required. Its presence has been checked. */
>>>>> -     pmd_populate_kernel(&init_mm, pmdp, pgtable);
>>>>> -     return 0;
>>>>> +     const int max_attempts =3D 16;
>>>>> +     int attempts =3D 0;
>>>>> +     pmd_t old_pmd, new_pmd;
>>>>> +
>>>>> +     if (!system_supports_bbm_through_af())
>>>>> +             return -EOPNOTSUPP;
>>>>> +
>>>>> +     if (system_supports_bbml3()) {
>>>>> +             /*
>>>>> +              * BBML3 allows block->table transitions if the PTEs =
underneath
>>>>> +              * do not conflict with existing, potentially cached
>>>>> +              * translations.
>>>>> +              */
>>>>> +             pmd_populate_kernel(&init_mm, pmdp, pgtable);
>>>>> +             return 0;
>>>>> +     }
>>>>> +
>>>>> +     new_pmd =3D __pmd(__phys_to_pmd_val(__pa(pgtable)) |
>>>>> +                     PMD_TYPE_TABLE | PMD_TABLE_AF | =
PMD_TABLE_UXN);
>>>>> +
>>>>> +     old_pmd =3D pmdp_get(pmdp);
>>>>> +
>>>>> +     do {
>>>>> +             if (WARN_ON_ONCE(!pmd_valid(old_pmd)))
>>>>> +                     return -EINVAL;
>>>>> +
>>>>> +             if (WARN_ON_ONCE(!pmd_leaf(old_pmd)))
>>>>> +                     return -EINVAL;
>>>>> +
>>>>> +             /* We should never get a contiguous PMD here. */
>>>>> +             if (WARN_ON_ONCE(pmd_cont(old_pmd)))
>>>>> +                     return -EINVAL;
>>>>> +
>>>>> +             if (pmd_young(old_pmd)) {
>>>>> +                     /* __ptep_clear_young() returns the =
overwritten PTE */
>>>>> +                     old_pmd =3D =
pte_pmd(pte_mkold(__ptep_clear_young((pte_t *)pmdp)));
>>>>> +
>>>>> +                     flush_tlb_kernel_range(addr, addr + =
PMD_SIZE);
>>>>> +             }
>>>>=20
>>>> [Severity: Medium]
>>>> Should this pass addr + PAGE_SIZE instead of addr + PMD_SIZE to
>>>> flush_tlb_kernel_range()?
>>>>=20
>>>> Invalidating a single non-contiguous PMD block entry only needs one
>>>> overlapping page-granular TLB invalidation, as in
>>>> unmap_hotplug_pmd_range().  With a range of PMD_SIZE and stride of
>>>> PAGE_SIZE, pages equals PTRS_PER_PTE (MAX_DVM_OPS), so
>>>> __flush_tlb_range_limit_excess() returns true on CPUs without
>>>> FEAT_TLBIRANGE and escalates the flush to flush_tlb_all().
>>>=20
>>> Oh! I didn't know that!
>>>=20
>>> I will change it to PAGE_SIZE instead of PMD_SIZE in v4. Neat!
>>>=20
>>>>=20
>>>>> +     /*
>>>>> +      * Translations without AF cannot be cached, so we can =
replace
>>>>> +      * them without BBM.
>>>>> +      */
>>>>> +     } while (!try_cmpxchg_relaxed(&pmd_val(*pmdp), =
&pmd_val(old_pmd),
>>>>> +                                   pmd_val(new_pmd)) &&
>>>>> +              ++attempts < max_attempts);
>>>>=20
>>>> [Severity: Low]
>>>> As reported by Catalin Marinas on v1 [1], this rests on an =
architecture
>>>> detail the review could not confirm from the kernel source: can a =
CPU
>>>> walk cache or TLB retain information from a valid leaf block PMD
>>>> descriptor when AF=3D0, or is a TLB invalidation and =
break-before-make
>>>> sequence still required before converting a valid AF=3D0 block =
descriptor
>>>> into a table descriptor without BBML3?
>>>>=20
>>>> If it can, skipping flush_tlb_kernel_range() when =
pmd_young(old_pmd) is
>>>> already false or directly overwriting the valid AF=3D0 block =
descriptor
>>>> with new_pmd leaves stale walk-cache or TLB state active while a =
table
>>>> entry is installed.
>>>>=20
>>>> [1] https://lore.kernel.org/r/aoSJcAFMNJ1nPl2H@arm.com
>>>=20
>>> Yeah, this is why these final 5 patches are marked as DO-NOT-MERGE.
>>=20
>> If we aren't sure about the hardware behavior here, why don't we just =
drop
>> these patches? Once the initial support of HVO for arm64 is merged =
into the
>> community, we can bring up this uncertain part for discussion. =
Wouldn't that
>> be simpler for this series?
>=20
> I'm including them for three reasons:
> 1. I want HVO to be supported on as many systems as possible. At
> Google, we have systems that we want to enable HVO for that do not
> have BBML3.
> 2. I want to provide the Linux code to potentially facilitate memory
> model discussions regarding the AF trick.
> 3. My interpretation of the Arm ARM is that the AF trick can be used
> like this, so that the final 5 patches are in fact correct.
>=20
> The series can always be partially applied.
>=20
> I am happy to drop these if they really ought to be sent separately or
> if they are genuinely incorrect. I hope some of the arm64 experts can
> chime in. :)

I'm just wondering: once we merge the deterministic patches, would it be
better to submit the second half separately as an RFC series?

I'm not an ARM expert, so until I'm certain this behavior is correct, I
won't review this part of the series.

Thanks,
Muchun



