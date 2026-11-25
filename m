Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23FCA606A326
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 09:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IWSBa6bB
Received: by kanga.kvack.org (Postfix)
	id 394A56B0959; Wed, 25 Nov 2026 04:37:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31EA36B0962; Wed, 25 Nov 2026 04:37:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20E4D6B0963; Wed, 25 Nov 2026 04:37:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E56C16B0959
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:37:32 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7DCDC160D9A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:37:31 +0000 (UTC)
X-FDA: 85473138702.01.A0F6B21
Received: from mta1.migadu.com (out-250.mta1.migadu.com [95.215.58.250])
	by imf03.hostedemail.com (Postfix) with ESMTP id 689D520008
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:37:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IWSBa6bB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.250 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795599449;
	b=aw/G9vb1OCmKfBVXjPTjwYj79tLuyVQtm9vnMoVYPn90w+2whV1kCDtyFj8HREY3D24ggf
	BfTXMpigbbQsVURT2gGdyoZd7lHk+HRKv/87uDVx+qIyFHWdRTiA5GgbqmNe+K13SW7jwr
	TuZsE6ZdEb/hPcdhLDSgjsqLsqextlA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795599449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k5xHf2lhPr/RExrawLrN0PmhwGouCpcZE5UnOts9ZAQ=;
	b=6RGH8C699Lmpz74B8/zEEbsKyrwd1agJuyWL7X5dMqw+ksQ7Vb6oZFDihx2O59Loj6+u+V
	1OwuFFas/SB+xaie4jV7iylRTc/w3zFEfkg2qFKwaXctXcxBMIXsW9r8Pn15AEnCakNJye
	E0DQG8DsAkCEkzsnraad+rMjUfQ7nFc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IWSBa6bB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.250 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=qq12iW/GfAR0dRAaMy1K7AX9iuydUIvkIBU6+z/H2qQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795599446; v=1; x=1796204246;
 b=IWSBa6bBkna41jsj8ZWeTM5E9j/lXWrq4rL+MR5TuEE38yqwCk17IeysPgN915zJZvyyjZTE
 xTAr659q93oRoGQiGIJVvcObUhGC2iFfVWku0zHSXkn5GPxU0Aceu2/dlqI6DDzFwlciimXZ0a4
 zjd5hbkg/I2UmjJeu6cWafvk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 442509cce5000c32;
	Wed, 25 Nov 2026 09:37:26 +0000
X-Mizu-Trace-ID: 442509cce5000c32
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v3 06/19] hugetlb: Optimize bootmem folios that were not
 pre-HVOed
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <CADrL8HW8+eFt5f1VBQ0zt-ioiU3X150W4ROaKf2Nzw4j9+0i_Q@mail.gmail.com>
Date: Wed, 25 Nov 2026 17:37:04 +0800
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
Message-Id: <09A53080-61DE-472D-9A37-38B524C76FF9@linux.dev>
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-7-jthoughton@google.com>
 <CF94E7D7-87D2-4523-9343-512EE00094FA@linux.dev>
 <CADrL8HW8+eFt5f1VBQ0zt-ioiU3X150W4ROaKf2Nzw4j9+0i_Q@mail.gmail.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: wxw3tz1mnmskb98nsbpiz6p7uqqytd1k
X-Rspamd-Queue-Id: 689D520008
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795599448-469496
X-HE-Meta: U2FsdGVkX19DzMmyI1WrLvWcaxnH6DsUNbxfNnOfkyXIFOlC0NhLOlcemywmLDzRhb+LfD/4BsY1jHQIRbDZfm3O53Qqbpu9AmcwiYF4+6rFhLKuOFKe1Cg+WgojmIG1eY/r/iX/1dcRTynhrMXTzBpuCIXr5UFdVOqLQ2rEV7O9tfVXCZ6zrE+Bla7hXStpulL2c/MmFsk3M+iobFI1vRuQW3dXkt41mZUSNHZZpYH+C4PAJA7hRnBrPf3M5KBxboTO9oECm0pHznU9Ghz/WL5dKFKm1Srnx4nKWhnW6MOqAEOT5WywU7odt+CK4V4k621XQyF/CwdxHQmg7TSBylDtFpLxes0uiaUcd0NXE01ft0kYDk1B7ATa8aFYrIctaYCAKdBt0DlI4uKeiNSzXIFmIqbo1al7k/CBow3mABCnmJc2IL69yEeWeq2XDdVBXA17D3nttjbyJv+sNCrNNBjbP34sWwGFI36Ze9Uxpv1VoAZ0uaxprDh5cUmuqvcrjuQgRhrOKCOVSNtUbH9OV5fJERbWIrg73RkKoRWgOj1BItJRDW8a5CBZpFGBSSi4fdbHmMFxdXJcH/fOShAIJ/YcnjKkwJXhR7O1ApnW3lxec+rcVH3LiF+efjTAyxslwlHhPiGbMTau+PBmjTgAtILUXANwa5LJfDg3iWH1BzvxB8LEtVZh1wUt3GMBNtfF2Zh+u/C6FJdFGeholeCgZCIxDrPPR16u042Kl6MSIY1O2F3dj0WyJX3RFBLF9n8yL6D1C7JkTzr1L+r+qvxgseUfa4lbbEUo6RdEp+liwZ1p2IpkWRg6Me/w2+BufbhAotenQT7epTSWSqxNzPBO+ei/QywB1z2MUL++7l0I1Fl+6Q6kXFwF5P/yikapgk4GBaqfYZzdqAnkcANHdYLSuUqWKYOLaeYJCJAVxZQL0FlqJA2CL0ECzUGI7j00K4R3+/RdAjS3iOL66SiPPOu
 Tl3lJZKi
 xvUNzYmkqqMqyfEpHGuVg5RDKa7HDTqGv2yujYythSnuPQhRIv6FvaYIXNZbtksXTxmWHIHMp2Tish877TI5ben7VwNNWY+2hHxKO81J2GPTdQWPgebWMVSYaYbqdnYtfLwC9eymIxijA7mULKMlhtNsVsNl1UJqDF5Mh3kdPuJVIvOeBDKpTwKhwIoYxNoVGuxZ7+kPT/gYESlL9BueTLazckPkbGFz+PWMaUdEjX98Kf1vU/IK5U3tZR5yMVhZ9NeJ7o4Btlpg+QCz6xrERTZnw26CQ9Dobep+ZMiXG+zfanZ2MQLlEj25bsrEtEfhh9tAf+l0PiHTgbGy/k2Hn8+tqLtqnA9JTthqolrHM12VLd7jV+y8xIps38PBvCBiuQ0KHKMsJJtWI+neWNBXoK65kryGQ8VJ5BqTd7hQoTDGkvt26KJlWsQtIpFQP+7fwTw0MXIUS22359fiGPZwrhTtTJqakwuMvao3Zcr7SSlHxHfebV8vZLhdElIV5WHRQltX5g9NqzMsQwRPZ24awSQaI1sCTXqiaJnmQ4qZU0DyXjuc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 25, 2026, at 00:58, James Houghton <jthoughton@google.com> =
wrote:
>=20
> On Sun, Nov 22, 2026 at 10:11=E2=80=AFPM Muchun Song =
<muchun.song@linux.dev> wrote:
>>=20
>>=20
>>=20
>>> On Nov 23, 2026, at 02:44, James Houghton <jthoughton@google.com> =
wrote:
>>>=20
>>> Boot-time gigantic folios are expected to be pre-HVOed through the
>>> section-based vmemmap optimization, so the bulk optimization pass =
for
>>> bootmem folios was dropped.
>>>=20
>>> However, arch_support_vmemmap_remap() may not yet
>>> return true when bootmem folios are allocated (e.g. on arm64, where
>>> support depends on a system-wide CPU capability), while it does =
return
>>> true by the time the bootmem folios are gathered. Such architectures
>>> disable the section-based vmemmap optimization in their vmemmap
>>> population path (see section_vmemmap_optimization_disable()), so the
>>> folios are not pre-HVOed and would never be optimized.
>>=20
>> Yeah, when I removed support for this part of the code, I figured you
>> might add a new patch in the future to add support back. It is fine.
>>=20
>>>=20
>>> Optimize such folios when gathering bootmem folios. Their tail =
struct
>>> pages have all been initialized by memmap_init_compound_page(),
>>> as they were not pre-HVOed. Pre-HVOed folios are skipped by
>>> vmemmap_should_optimize_folio().
>>>=20
>>> Signed-off-by: James Houghton <jthoughton@google.com>
>>> ---
>>> mm/hugetlb.c | 11 +++++++++++
>>> 1 file changed, 11 insertions(+)
>>>=20
>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>> index 72839e98f998..8756c0206922 100644
>>> --- a/mm/hugetlb.c
>>> +++ b/mm/hugetlb.c
>>> @@ -3325,6 +3325,17 @@ static void __init =
prep_and_add_bootmem_folios(struct hstate *h,
>>>      unsigned long flags;
>>>      struct folio *folio, *tmp_f;
>>>=20
>>> +     /*
>>> +      * Bootmem folios are normally pre-HVOed through the =
section-based
>>> +      * vmemmap optimization. However, an architecture that can =
only
>>> +      * determine whether it supports HVO after bootmem allocation =
disables
>>> +      * the section-based optimization (see
>>> +      * section_vmemmap_optimization_disable()), in which case the =
folios
>>> +      * were not pre-HVOed and must be optimized now. Pre-HVOed =
folios are
>>> +      * skipped.
>>> +      */
>>=20
>> I'd like to condense these comments to something like:
>>=20
>> /*
>> * Some architectures do not support section-based vmemmap =
optimization,
>> * so their bootmem folios should be optimized here with folio-based
>> * optimization.
>> */
>=20
> Applied in v4, thanks!
>=20
> Also just so you don't miss it, would appreciate your thoughts on my
> reply to Sashiko's comments on this patch[1]. Let me know if you would
> like me to do something different.

I think the diff below might be a bit simpler. You might think that when
HVO is turned off, it could still cause some unnecessary TLB flushes. =
You
don't need to worry about that, because I've added a global guard to =
make
sure it doesn't happen. Take a look here [1].

[1] =
https://lore.kernel.org/all/20261124110530.3004071-3-songmuchun@bytedance.=
com/

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b2c14f4f99b7..69a7d4ca8b1b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3345,6 +3345,7 @@ static void __init =
gather_bootmem_prealloc_node(unsigned long nid)
        LIST_HEAD(folio_list);
        struct huge_bootmem_page *m, *tm;
        struct hstate *h =3D NULL, *prev_h =3D NULL;
+       unsigned long vmemmap_unoptimized =3D 0;

        list_for_each_entry_safe(m, tm, &huge_boot_pages[nid], list) {
                struct page *page =3D virt_to_page(m);
@@ -3368,6 +3369,8 @@ static void __init =
gather_bootmem_prealloc_node(unsigned long nid)

                if =
(vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
                        folio_set_hugetlb_vmemmap_optimized(folio);
+               else
+                       vmemmap_unoptimized++;
                section_set_compound_order_range(pfn, nr_pages, 0);

                list_add(&folio->lru, &folio_list);
@@ -3387,6 +3390,8 @@ static void __init =
gather_bootmem_prealloc_node(unsigned long nid)
                cond_resched();
        }

+       if (vmemmap_unoptimized)
+               hugetlb_vmemmap_optimize_folios(h, &folio_list);
        prep_and_add_bootmem_folios(h, &folio_list);
 }


>=20
> [1] =
https://lore.kernel.org/linux-mm/20261124165516.1182390-1-jthoughton@googl=
e.com/



