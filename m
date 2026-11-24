Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AFB9606A330
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 02:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iYxLxCy3
Received: by kanga.kvack.org (Postfix)
	id 21B806B05C2; Mon, 23 Nov 2026 21:31:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F4F06B05C3; Mon, 23 Nov 2026 21:31:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10F5F6B05C4; Mon, 23 Nov 2026 21:31:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA8466B05C2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 21:31:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3A44E1A0685
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:31:31 +0000 (UTC)
X-FDA: 85468436382.08.9C2AA15
Received: from mta0.migadu.com (out-243.mta0.migadu.com [91.218.175.243])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2AAB1140007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:31:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iYxLxCy3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.243 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795487489;
	b=S470jt3DLWioz7G+0ptLhUfRikvnsCIRSF1DwyzBPBcIs2mKoFQqmqqL4NVzXbc7IFnPyV
	sx9No7skPy9sGlxzzGAHoMYBCFlgqSLysdnp+lVc/ptvnBhkc8MtDUeazxq88wPZLQKdob
	4zG0j/FgkoWJ+mtlMBK2ODj2pxuDUuI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795487489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I6rKiuxs3a0MpULM5n+IvwORKN/28E+DHpxd239HqJY=;
	b=eiO/jGOXAe6w07HwjJ6BjlOLTA0MRl7oLGPq/J07p6k/yuVLv9cAgoSbK9qNA4zCVyeKBd
	/D1UG5k9Mi337V+CS0hrffCxknlSguM8JIbtxdDSmRPBtkFOoOOwLM0KaCWVy2wZr0my5n
	m7m/w2cH3zg0XvmammQEGINcjt0ItFg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iYxLxCy3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.243 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2EfP7VkiOHBjYmA3RrR9cYpETF6cn3Mh2yOE+dyeiAs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795487487; v=1; x=1796092287;
 b=iYxLxCy3t2iEF08iafMovc2K4VHY8fKBUZ7VF8edFul8A80rRelpSlaztFb9LX9t+/62a9Nq
 94Xq8OZUeH02HKres8yGNe60O5Igqrgxs6tTXYcoTpYutO88nTPfX4xWYR5DdC23eX5hdbPtaN/
 gtRZSjnF6p15ThHeievvt49g=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3d25bf20d01f7445;
	Tue, 24 Nov 2026 02:31:27 +0000
X-Mizu-Trace-ID: 3d25bf20d01f7445
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v3 05/19] hugetlb_vmemmap: Allow architectures to
 dynamically disallow HVO
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <CADrL8HXemwtmL_URg-WNOzdw1YCVxP3HVxX67yd=pLRGAuFyVA@mail.gmail.com>
Date: Tue, 24 Nov 2026 10:31:12 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
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
 linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B1DC7C6D-7E3F-415B-A0D7-3F355499AB78@linux.dev>
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-6-jthoughton@google.com>
 <C1CC6F31-4F75-41D8-89D8-CE43465FBB6C@linux.dev>
 <CADrL8HXemwtmL_URg-WNOzdw1YCVxP3HVxX67yd=pLRGAuFyVA@mail.gmail.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Queue-Id: 2AAB1140007
X-Stat-Signature: mwhmg9i9zbt3js3jh34dfnpzkx73uw75
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795487488-128982
X-HE-Meta: U2FsdGVkX1/lDJKEXuohgjpgRVxnF1awivxVwLm4b2Zywo3IoahKP6RVKy8sasshshQe6GXW/1HVUNVnDxOD9QA2iemoZ6QCswmJg9VORBs0IFjiUGHot9weYBN/y3aZVE4zHEH6kvgG/NbeOTjcDvgYKv+jOWDryBMJsnyKEtjpg1SFyQjl3eLqtheak0TNFgpUyLfyiJVQ/h4rOBAhxy1waqHIY5J8d9ccMm1UT8EmjWWNvozibercfaVwvxp8ojDR1hZJ8O46bqe8a7IqelHhxXipYduGmkUQf3yu/Cpbl08mVtbkEnhLca6L8plBXel0pr6SAlS/cxOcWSB1RRM86w8L1YC6wUJP7apQYlSBTuEh7LQ2m2iFTblhB0lO7Mi96mn0S4lt7PGSpiWtDMhmyMusR2sUg3JdZXYjcckfDC6E+gpHlUIBmn0LHwuqMQW3pLQEskkAuMYOgemM1/0rHQa25k5ZO9hWGF6rqTKX+WmSajPkpWUlOhx2Ug71aLZ62cP3AfiAaXmbEUUMOPMoODjeQC0Vl4liD+yb8YG++wRqwWv5528IDTc4lAXkFmlaFvEWIbgwbQWim6UkR7XblmVUUWiP00mVinVQGl2XZ+bGGMtLtkYC7psb1rLrMDZ2QFeq5A6ZRH/g6qnh9Rvcj7tGwHA/O6e0tFfr3isMOWlblMHRSUvG4fsC9dEbJpayNAZwZi9mGERM/xntsq/9iSx9s0Mono9ZXJB9f3U93Cf0ipKacbmFPmZy052Ck7wDVzu8AY0ZMUKucbqNA4iHTZ5y8C6rv+BeQuA9J6PqORkb7ztXbRozm16s6p2f5CVzl3T1c/ecWxmBd6lzTXW0JEfmiz0CETmnBHMWvWhYSZsn2Zah/hSIN5XpmcC6fzPNHk7urdVyw7S071YCKzexX2fLmquyaOxhaa1DwE0XdRjezOPvEN+tnEJ0wWf9kuvWLSaj9pp8onOeAzi
 n4cR+0hr
 PiRtz8NaWPIrQzVQujicZRkgWJoBdrZ4uIIFOezmeCZ03uniaoIpZcn+eTac8RsKqF0V3rqTnur7MfX/Kijj0YsiBzOBEzx0bKg37/u/CAls9qMrW9p7zYWefeferajiZDVCr4ZYHhmGrikdptePz+7Rob/GmhAYAgsESe47QESeHcpo/BR4t3k8ehUBxrLwKpXgbnP2OTJe0G5UkKvmEHhce0wmsEcDZLucVQaf+oMyd8HBQlxJ7Qf9apTIQV9zfwsDR2hURKCXbdPpc75viT0QwUT2cTuUHA77FLHn66tcIDRfpMcM00jWve4vf12++UTYEOdPde05qINOnYdXl1WIYvPITe8SfSueRq2hWChYV/ZeN/trXNSdr+OBykHTH4wCFrhfdGXhsps+DSu6IjEzI0IEMzm52edd4tjhsuvKt8IKcnzLF+i8pBxEJjoIC7VKia6hBH0sSQTXfyxMGEBDqkv0sVnlW13MpXZeArf1W2NmIkWfscr+GPiez2xxsxMPPqJ2UcQcRLF8Hp//AQmYAlKxSC6/rudpXK//EvMHyzu1M6MLxH0oI+F44EiwWq2uOc0yKksEVIAc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 24, 2026, at 04:31, James Houghton <jthoughton@google.com> =
wrote:
>=20
> On Sun, Nov 22, 2026 at 10:01=E2=80=AFPM Muchun Song =
<muchun.song@linux.dev> wrote:
>>=20
>>=20
>>=20
>>> On Nov 23, 2026, at 02:44, James Houghton <jthoughton@google.com> =
wrote:
>>>=20
>>> For arm64, only some platforms support HVO. Add an arch hook,
>>> arch_support_vmemmap_remap(), to prevent HVO from taking effect if =
the
>>> architecture lacks support. The hook is not HugeTLB-specific, so it =
can
>>> also be used by other users of in-place vmemmap remapping (e.g. =
FS-DAX).
>>>=20
>>> Check it in hugetlb_vmemmap_optimizable_size(), so that hstates are =
not
>>> reported or treated as optimizable (e.g. by report_hugepages() and =
the
>>> HugeTLB allocation and freeing paths) when the architecture does not
>>> support HVO.
>>>=20
>>> It may be the case that arch_support_vmemmap_remap() returns false =
at
>>> first but eventually returns true. This is the case on arm64, where
>>> support depends on a system-wide CPU capability that is not yet =
known
>>> when bootmem hugepages are allocated. Such architectures cannot =
pre-HVO
>>> bootmem hugepages, so they must disable the section-based vmemmap
>>> optimization in their vmemmap population path with
>>> section_vmemmap_optimization_disable(). Their bootmem hugepages are =
then
>>> optimized when they are gathered instead.
>>>=20
>>> Signed-off-by: James Houghton <jthoughton@google.com>
>>> ---
>>> include/linux/pgtable.h | 15 +++++++++++++++
>>> mm/hugetlb_vmemmap.h    |  2 ++
>>> 2 files changed, 17 insertions(+)
>>>=20
>>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>>> index ab33df268955..8cf44120e2ed 100644
>>> --- a/include/linux/pgtable.h
>>> +++ b/include/linux/pgtable.h
>>> @@ -480,6 +480,21 @@ static inline int =
try_update_vmemmap_pte(unsigned long addr, pte_t *ptep,
>>> }
>>> #endif
>>>=20
>>> +#ifndef arch_support_vmemmap_remap
>>=20
>> We usually add a 's' to 'support'. Like arch_supports_vmemmap_remap.
>=20
> Oh yeah, I'll fix that. Thanks, Muchun!
>=20
>>=20
>>> +/*
>>> + * arch_support_vmemmap_remap - Whether in-use vmemmap mappings may =
be remapped.
>>> + *
>>> + * Vmemmap optimizations, such as the HugeTLB vmemmap optimization =
(HVO),
>>> + * remap vmemmap page table entries while they are in use. =
Architectures that
>>> + * can only do this on some systems may override this hook. It may =
return false
>>=20
>> "Some systems" is not clear for me, How about rewrite this sentence =
with:
>>=20
>>  May override this hook based on architecture-specific runtime =
conditions.
>>=20
>>> + * early during boot and true later, once system-wide features are =
known.
>>=20
>> I think the description should be general, so the last sentence I =
think should
>> be removed.
>=20
> I think it's important to clarify that the return value can transition
> from false to true, but not from true to false.
>=20
> Okay how about this:
>   * Vmemmap optimizations, such as the HugeTLB vmemmap optimization =
(HVO),
>   * remap vmemmap page table entries while they are in use. =
Architectures that
>   * can only do this under certain runtime conditions may override
>   * this hook. It may return false early during boot and true later. =
Once
>   * it becomes true, it must not start returning false.
>=20
> What do you think?

LGTM. Thanks.

>=20
> Thanks!
>=20
>=20
>>=20
>> Thanks,
>> Muchun
>>=20
>>> + */
>>> +static inline bool arch_support_vmemmap_remap(void)
>>> +{
>>> +     return IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION);
>>> +}
>>> +#endif
>>> +
>>> #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
>>> extern int ptep_set_access_flags(struct vm_area_struct *vma,
>>>                               unsigned long address, pte_t *ptep,
>>> diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
>>> index 8b28063d78cc..440477288d19 100644
>>> --- a/mm/hugetlb_vmemmap.h
>>> +++ b/mm/hugetlb_vmemmap.h
>>> @@ -48,6 +48,8 @@ static inline unsigned int =
hugetlb_vmemmap_optimizable_size(const struct hstate
>>>=20
>>>      if (!is_power_of_2(sizeof(struct page)))
>>>              return 0;
>>> +     if (!arch_support_vmemmap_remap())
>>> +             return 0;
>>>      return size > 0 ? size : 0;
>>> }
>>> #else
>>> --
>>> 2.56.1.809.ga0b61035b5-goog



