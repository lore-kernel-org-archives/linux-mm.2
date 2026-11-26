Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35922606A32D
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 01:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HJFjtV1d
Received: by kanga.kvack.org (Postfix)
	id 543AA6B0B47; Wed, 25 Nov 2026 20:31:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F4A96B0B49; Wed, 25 Nov 2026 20:31:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E27A6B0B4A; Wed, 25 Nov 2026 20:31:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1733C6B0B47
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 20:31:59 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9BD62A0246
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 01:31:58 +0000 (UTC)
X-FDA: 85475543916.03.4EB99B2
Received: from mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
	by imf11.hostedemail.com (Postfix) with ESMTP id 65C9840005
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 01:31:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HJFjtV1d;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.24 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795656717;
	b=RhnU8kpEYqBb3GhqZurFi6k2VkoI76SdU567tupdiQqT+V3T6iBYDP16Qg11kVHGvrth7L
	hPBhYmKpP72uviLnV2r0LfbFG0EAnvnlCi5FTyIUc850AYBlyz97UWEdisPbrxO0Wxkzv6
	MZnN8H30SipjR9AVeiS89/ugjGn4e94=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795656717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wde9udkd5zQ9CLQ7aWUsNIZCwjF2DEOdelZVAWlC9I4=;
	b=tb/lUAIguk8woJJhGGUU6YRjucz+xxSJZf1dmvYV7XU0pWQvBAucG58TZqeRqQQXQO+oRm
	84AaP8XyMH3pzAehnmrWpr0E1XHELh5g5RY+hyzds5gS1JCPifUBKLNLIE7C1uOERlE8wL
	2NZd0WCV9KPnxHsyx8GR9wgpqWNmX6g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HJFjtV1d;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.24 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bBmr2JO5Sg+M7romhELnWXSnHAmxM4rIPKq9RYfx+nY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795656714; v=1; x=1796261514;
 b=HJFjtV1dTYydkzGEtv/b2Sr+dk9hFl8SG3iK5Z9j1eeEe15YaPQaPaMm8TG4dxqOHB2HdHPI
 Bnw/nM7PCPB/oObULZvFtxfVoeEqwa+39mgndLuf2WgNsmDTezN/PCUPdJyPQOlNsNRbia0Xkr0
 voSglgB1vqTsssuY7epghzSY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1454f8f9569628e6;
	Thu, 26 Nov 2026 01:31:54 +0000
X-Mizu-Trace-ID: 1454f8f9569628e6
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v3 06/19] hugetlb: Optimize bootmem folios that were not
 pre-HVOed
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <CADrL8HV2m6DO=r-mezNONV_w0BtrN1_7Wph+mHUsAsYBf5FR2g@mail.gmail.com>
Date: Thu, 26 Nov 2026 09:31:37 +0800
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
Message-Id: <82B8672D-CB14-4765-A541-67D574382F86@linux.dev>
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-7-jthoughton@google.com>
 <CF94E7D7-87D2-4523-9343-512EE00094FA@linux.dev>
 <CADrL8HW8+eFt5f1VBQ0zt-ioiU3X150W4ROaKf2Nzw4j9+0i_Q@mail.gmail.com>
 <09A53080-61DE-472D-9A37-38B524C76FF9@linux.dev>
 <CADrL8HV2m6DO=r-mezNONV_w0BtrN1_7Wph+mHUsAsYBf5FR2g@mail.gmail.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User:
X-Stat-Signature: ehiguc1xchw8hjzewue7ckrhzn59eais
X-Rspamd-Queue-Id: 65C9840005
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795656716-877080
X-HE-Meta: U2FsdGVkX18k5Rojmk9ZasTdAzkgZrVowe0aLrdgYmqoQBiBhxVPXLR3TPcBEkIps8NQ2J+2rMIuiCdddsrPxCZwMDBFIJjwLfqIV0QthFEkvzF3zxmO8rKuoUCoq1/jiSfIwduIF4RZFBT1glvVKlQnWrWJG3efkqHXA+v/xajADPuIH2skqf11hsPr//9PlNFaCogclDZrHpy7ZSl3tananp9Z5Odo5v3e0zafPsSHXfhwttQS+Sli/W692Er2tiLqw1Z7qtcAhOFtW987CnXhy1CK4wj4mq8sbMELxo6JF3tdDY+vBI21tjhC12IbPV6rmyfguAa3EGyjQbJvuQDgwT694OMDgjWW5+aL79hpDS9VtmKKXxhJfo8h0Rlunk4D6pErcs4mibHn1w1QruoeEYt6bW3J1kZbab9mnZauLTMtMCofy7DIz3NN0ksQRyZ9gZJZu5qEORVk7oyAVzgwx9sEepcRN033BJP1GDdBFznXGUZZYhiywgCOylP+n84k4yeD9DnhQLMtMoEuTD4w0BAXYCN4lujrKD2ch2tvZ/LsUoOB9grrCFsQzOmyUvoQN/TpEVIKPvBNB/75p1ELORBul7KbFKzS3VZUdFXh2aIwWM+i63LeEevBjDn7s7k4oI86R6Prt2tOosISxPUmLIZy9TxqfGdDEL/uNElUXilHQsNP1H7GWqRvB1hCOn9JNaWeXjP6HmOvYcD8sdN7zLhEajzygkHMfi4McLF0txOvDxw9ly4ELON7XGEfvWqHzNgqTHbn0N7kn5VL9tr/yh56NRf3rr9UBGvxhnkHXWfvcFVjLugOjl/U5oxX5YyIx+ixZ1FMgrNENebJxzUAzb7qVCPxdP0GIz2P0RAwzRsyW8eQDJ9WfU7c5Fy8LAa8XknCJPieDXKnECWvcdqO+RuHrs9XYkyDDLiYC7cA0iDoWHljo/G8Xx+JbpjhyTC1WXEohtTc2E5B9kP
 4st9rD60
 lJA4lQuqMlCpAjasR51p61GZcFxTUIjyK6/kEq1kK53xp83ZgoiiUNiLrNua1jGIDqG+1UplZWDJ2xqI7jcSYRq8M+x/XQNyNZUxWADwXeKJ5HwalwzMvubGcIKwUeAndBjXnFTEa9kuTd+ey7HJndjctn2d2xlfCkkG3xyVcn1JdPJrPf9xCLA4j18Msb3aV3IWm5cHNQyND7gFLDFhpWH1yaaMdGo80sdlcqNaIeeA/k+V3FROnUCSMXMdtMkVc3Te31GgFzozpQExHqYxml0DSKhkNwS55AiXHKUxHyMuRkxgHqZ44SdUlXLiFGd8fVaTjzAgzG2y+f5iOiTkv0UaHQUY79A1GjNPWiXrV3t8qAyUCM0SRbhSpHZwkX/hn6vXlw5bFKo6cDSRGed4d/vvwMTrtE8sZhotfL9fjfVrRsP/kjSm6dCqaf3rcNl4boME4WcE2II3MwBILoGuH2IhxU2RQap+QARUJ4L81hz/2aeooZDI4HVc54qEwFEqOfUoQcD6mNseKt17kWsTXEuVZmvwImxbBQJB2qLE4KE3Mt6M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 26, 2026, at 00:09, James Houghton <jthoughton@google.com> =
wrote:
>=20
> On Wed, Nov 25, 2026 at 4:37=E2=80=AFAM Muchun Song =
<muchun.song@linux.dev> wrote:
>>=20
>>=20
>>=20
>>> On Nov 25, 2026, at 00:58, James Houghton <jthoughton@google.com> =
wrote:
>>>=20
>>> On Sun, Nov 22, 2026 at 10:11=E2=80=AFPM Muchun Song =
<muchun.song@linux.dev> wrote:
>>>>=20
>>>>=20
>>>>=20
>>>>> On Nov 23, 2026, at 02:44, James Houghton <jthoughton@google.com> =
wrote:
>>>>>=20
>>>>> Boot-time gigantic folios are expected to be pre-HVOed through the
>>>>> section-based vmemmap optimization, so the bulk optimization pass =
for
>>>>> bootmem folios was dropped.
>>>>>=20
>>>>> However, arch_support_vmemmap_remap() may not yet
>>>>> return true when bootmem folios are allocated (e.g. on arm64, =
where
>>>>> support depends on a system-wide CPU capability), while it does =
return
>>>>> true by the time the bootmem folios are gathered. Such =
architectures
>>>>> disable the section-based vmemmap optimization in their vmemmap
>>>>> population path (see section_vmemmap_optimization_disable()), so =
the
>>>>> folios are not pre-HVOed and would never be optimized.
>>>>=20
>>>> Yeah, when I removed support for this part of the code, I figured =
you
>>>> might add a new patch in the future to add support back. It is =
fine.
>>>>=20
>>>>>=20
>>>>> Optimize such folios when gathering bootmem folios. Their tail =
struct
>>>>> pages have all been initialized by memmap_init_compound_page(),
>>>>> as they were not pre-HVOed. Pre-HVOed folios are skipped by
>>>>> vmemmap_should_optimize_folio().
>>>>>=20
>>>>> Signed-off-by: James Houghton <jthoughton@google.com>
>>>>> ---
>>>>> mm/hugetlb.c | 11 +++++++++++
>>>>> 1 file changed, 11 insertions(+)
>>>>>=20
>>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>>>> index 72839e98f998..8756c0206922 100644
>>>>> --- a/mm/hugetlb.c
>>>>> +++ b/mm/hugetlb.c
>>>>> @@ -3325,6 +3325,17 @@ static void __init =
prep_and_add_bootmem_folios(struct hstate *h,
>>>>>     unsigned long flags;
>>>>>     struct folio *folio, *tmp_f;
>>>>>=20
>>>>> +     /*
>>>>> +      * Bootmem folios are normally pre-HVOed through the =
section-based
>>>>> +      * vmemmap optimization. However, an architecture that can =
only
>>>>> +      * determine whether it supports HVO after bootmem =
allocation disables
>>>>> +      * the section-based optimization (see
>>>>> +      * section_vmemmap_optimization_disable()), in which case =
the folios
>>>>> +      * were not pre-HVOed and must be optimized now. Pre-HVOed =
folios are
>>>>> +      * skipped.
>>>>> +      */
>>>>=20
>>>> I'd like to condense these comments to something like:
>>>>=20
>>>> /*
>>>> * Some architectures do not support section-based vmemmap =
optimization,
>>>> * so their bootmem folios should be optimized here with folio-based
>>>> * optimization.
>>>> */
>>>=20
>>> Applied in v4, thanks!
>>>=20
>>> Also just so you don't miss it, would appreciate your thoughts on my
>>> reply to Sashiko's comments on this patch[1]. Let me know if you =
would
>>> like me to do something different.
>>=20
>> I think the diff below might be a bit simpler. You might think that =
when
>> HVO is turned off, it could still cause some unnecessary TLB flushes. =
You
>> don't need to worry about that, because I've added a global guard to =
make
>> sure it doesn't happen. Take a look here [1].
>>=20
>> [1] =
https://lore.kernel.org/all/20261124110530.3004071-3-songmuchun@bytedance.=
com/
>>=20
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index b2c14f4f99b7..69a7d4ca8b1b 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -3345,6 +3345,7 @@ static void __init =
gather_bootmem_prealloc_node(unsigned long nid)
>>        LIST_HEAD(folio_list);
>>        struct huge_bootmem_page *m, *tm;
>>        struct hstate *h =3D NULL, *prev_h =3D NULL;
>> +       unsigned long vmemmap_unoptimized =3D 0;
>>=20
>>        list_for_each_entry_safe(m, tm, &huge_boot_pages[nid], list) {
>>                struct page *page =3D virt_to_page(m);
>> @@ -3368,6 +3369,8 @@ static void __init =
gather_bootmem_prealloc_node(unsigned long nid)
>>=20
>>                if =
(vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
>>                        folio_set_hugetlb_vmemmap_optimized(folio);
>> +               else
>> +                       vmemmap_unoptimized++;
>>                section_set_compound_order_range(pfn, nr_pages, 0);
>>=20
>>                list_add(&folio->lru, &folio_list);
>> @@ -3387,6 +3390,8 @@ static void __init =
gather_bootmem_prealloc_node(unsigned long nid)
>>                cond_resched();
>>        }
>>=20
>> +       if (vmemmap_unoptimized)
>> +               hugetlb_vmemmap_optimize_folios(h, &folio_list);
>=20
> This hunk needs to also be added to the `h !=3D prev_h` piece inside =
of
> the loop, otherwise we could miss optimizing folios for some hstates.

Oh, you are right.

>=20
> I prefer the early return that I've re-applied. It's a lot more

LGTM.

Thanks,
Muchun

> straightforward for me. Let me know if you really want me to switch it
> with your suggestion.
>=20
> Thanks for all the feedback, Muchun! I really appreciate it.
>=20
>>        prep_and_add_bootmem_folios(h, &folio_list);
>> }



