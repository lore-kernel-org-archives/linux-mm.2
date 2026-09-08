Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1929FC79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 07:09:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19A6B6B008C; Tue,  8 Sep 2026 03:09:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14C736B0092; Tue,  8 Sep 2026 03:09:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 062796B0093; Tue,  8 Sep 2026 03:09:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D208C6B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:09:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 68F011A03D4
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:09:33 +0000 (UTC)
X-FDA: 85189719426.15.1365477
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf12.hostedemail.com (Postfix) with ESMTP id 49BE940004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:09:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ESgXK0oL;
	spf=pass (imf12.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788851371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gMcPkkrsYFrDaf7KtGiUZKZ4igekg8qNltXw9MzJMyk=;
	b=5Rn3oScsvt/77bwYburEnSkcG4cJqul+4JA5WoPHZA2xmLewUEzARDMt+iaxAIIqTHRvZy
	m/CuhqDqTuYN55LOoE6QdEV0rJHpaeGRnX/+xYati4yk90yembRRXETV2qj4AE0hzhTRjC
	s+LlnGta9Sw2v5mjXUib/of5eoCu60s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ESgXK0oL;
	spf=pass (imf12.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788851371;
	b=KAxyxTdnfVQsyVseTEA+4ajrSbpyA4926uPv7sn8erGpOxsXN7OIrQhOPC7mP138BexVYQ
	lzpVXTrleHls/G6FsufqMz78rIA4TgvfI9TFvnZq6RY1bX00jKqDwOAHzz8ZLvhesSh443
	1pc/zzQ1qS6w5rC4HzuxFyAMw/oBh6g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1788851364; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=gMcPkkrsYFrDaf7KtGiUZKZ4igekg8qNltXw9MzJMyk=;
 b=ESgXK0oLUWANrK/Bcrbi66n7tfJXymtEu4XyoFluXLU4Q1JRGst+BTf1cna9B/OJBvAKQ7
 gT06CW/P1tH3kDbETPuP4N087LjFjR6nnhE7dVM7KgU+y6rY0XUDhm0lUy1e/rXu3FbRlC
 xggPP4P9kvNXxaNxd6LDG9XuWNQ3WSK9bDvhed9KQWpkGhdzH99P7cAZWi0AvTJIvWn1pa
 4fnUBGi2a2R0++dNyycYleJQhDT/8zTlzlOvRNsoADYezX9QIo0PCzuKrRNTiEL7Gh76Ni
 Q7j1VhK1sijPCp2SHxTIwj9jFCgDO9cZ02WjS0vtiz4Wwooc4++I+You/OFbyg==
User-Agent: Mozilla Thunderbird
References: <20260831091023.66581-1-lizhe.67@bytedance.com> <20260831173220.72ab28190a44a305dacf4d04@linux-foundation.org> <47a6817e-e98e-4a00-8e2c-6a66d15ddb37@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Tue, 8 Sep 2026 15:09:04 +0800
Message-Id: <874e7793-877a-40a5-97ce-11dd5b9ee9ba@bytedance.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	"Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <47a6817e-e98e-4a00-8e2c-6a66d15ddb37@kernel.org>
Content-Type: text/plain; charset=UTF-8
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a9fb4a2+e0bb0c+kvack.org+lizhe.67@bytedance.com>
Cc: <muchun.song@linux.dev>, <osalvador@suse.de>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>, <aiqi.i7@bytedance.com>
Subject: Re: [PATCH] mm/hugetlb: fix overbroad MMU notifiers for unshared PMDs
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ps6r4wi1xf53irbqqfcyk9t7f56nicrd
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 49BE940004
X-Rspam-User: 
X-HE-Tag: 1788851370-698812
X-HE-Meta: U2FsdGVkX18oHWtbl/sQhNgXcu825U9pthOWVsjeh981gmi9FoZy5PYCcujkjqx4ZD+q0r/SGuJzI/W5+edJHK6i8ze5P0yqMM2Rq4b/N8s79r0C5ppSnc9eAkID3Jk7MIvJk5/s8fBrani5up5XrEC1laIF7f+3tnNvT720TOtFVIWzaAK2hlRdvtY/RciMHPk1h1ObFfHoNPy5AWmTMXRIcjsjBj0tK8G+EbKPoxY6tYxGlXtGYIztUYyknkefGKZOnDsOsDZ2apznHlRtMQezvpji5eD0lj+In8vq8XfnAwQsLxXb0N69+XPHKzN+9JCeQxsP0pAq0seCvXAKGq63wHFVc+z3V3EjtsXQQ4uD7Ppz9isLq+IsbdAYIIXWjf7DV2+kQmq975luoeQna9XR5buU+iEG6XtVrqElAE5vvtNx38gmrh2LNTWfeRBUnrz2wf9vERTNX/WDPlugfBYkwIlpPiw2Fxftiez4rRzEsS7iU4IdxHJo8fT/ZZlzlSkT9IjgHdZ/5Vs++2FjglmSidtAoMd804tRnkkmnCr2AUwBleTuYVf2KDAzCq4ZJmTspKVdzVho/QEfHnWVFm/Y6RayZqeP70vpy/uBKTv/JRPUu1JJQis5gKKEvyHTp61IKD2c8Alz73vT7WFpi/bjwJV8LLP2lkGLu8QZRuPs4S7q4x678aKV9dC9RSarELIjuYZD2DEvIVgxYgfTURLUNWzQ7SfRq2IHfZq5KC5KbUPyE++XzUKcxc7HlPoib5Csvw56Ymw895W539TRRpUifW69UK7X94V4iyqaGTLFd8K55Vg7lDranY0RAoaJKdD4m2VzT4OPzTKoEqMAyd45tCj0wtilqMyZicnwyJFS3SdnaRx+Sss+sfairKKYjheygbGIijGJ0yFySYZn2JDKCBxTLpwePUTlw0q6UXYcljXsi8wUWLV5gfAIYwzvWZNsT/abkZmpQL9oiI0
 NXXYLmCO
 ZS6JRcc28OwRUjoC7SyfYGX1tsWiKwFbpj7g7KchH0mTYpG44rs1E4pgqDudZN33kdOvZkVaedUqfsZ4IBjSlCB0df5PtHc93aQ9cJ6gxii4b7Cj6Jv2OTNd9ubo3g7v9VNJ1c7Rz0aeTdJK3G7VbtYG/o+RRWMabgSXUT0/Z7fnOX/8xFq9aMPRZ5iiBCJfP8TBB+4FFklPYqshQW7473D8x52TpnzGC2eyBuAKCQzv74XR6xfEyclQJ7hkALcET01QfAwZbRckV14K1a/SXjtqwRwoyHimmnXU2eqXA2R/QNTE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 11:29 PM, David Hildenbrand (Arm) wrote:
> On 9/1/26 02:32, Andrew Morton wrote:
>> On Mon, 31 Aug 2026 17:10:23 +0800 "Li Zhe" <lizhe.67@bytedance.com> wro=
te:
>>
>>> Hugetlb currently expands MMU notifier ranges to PUD boundaries wheneve=
r
>>> PMD sharing is possible. That is only needed when huge_pmd_unshare()
>>> actually detaches a shared PMD page table, because clearing the PUD
>>> invalidates the whole PUD-sized virtual address range.
>>>
>>> For hugetlbfs hole punch and MADV_DONTNEED, a shared mapping can pass
>>> the "PMD sharing is possible" range test in function
>>> adjust_range_if_pmd_sharing_possible() even when the PMD table covering
>>> the target 2M page is not shared. KVM then receives a 1G invalidation f=
or
>>> a 2M operation and zaps unrelated secondary mappings, so the guest has =
to
>>> fault them back in.
>>>
>>> Fix this by using the existing cheap "sharing possible" test only as a
>>> gate, then inspect the candidate PMD tables under the locks held by the
>>> hugetlb unmap paths. The notifier is expanded only for PUDs whose PMD
>>> table is actually shared, while the other callers keep the existing
>>> conservative expansion.
>> Thanks.
>>
>>> On a Redis-in-VM workload that punches cold 2M hugetlb pages, this
>>> patch improves P99 QPS stability while punching pages, reducing the QPS
>>> degradation ratio from 7.09% to 1.45%.
>> So a modest performance improvement?
> Is that worth the complexity, though?


That is a fair concern.

I tried to simplify the approach. Instead of computing the exact PUD
sub-ranges that contain shared PMD tables, this version keeps the
existing adjust_range_if_pmd_sharing_possible() logic unchanged and only
adds an actual shared-PMD check as a gate before it.

So the behavior becomes:

 =C2=A0 - if no shared PMD table is found, keep the notifier range unchange=
d;
 =C2=A0 - if any shared PMD table is found, fall back to the existing
 =C2=A0 =C2=A0 conservative PUD-sized expansion.

This should still avoid the unnecessary 1G KVM invalidation for the
common unshared-PMD case, while keeping the range expansion policy
unchanged when a shared PMD is present.

The resulting diff would look like this:

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 816dde7..7a61fc3 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5355,10 +5357,12 @@ void __hugetlb_zap_begin(struct vm_area_struct *vma=
,
 =C2=A0 =C2=A0 =C2=A0if (!vma->vm_file)=C2=A0 =C2=A0 /* hugetlbfs_file_mmap=
 error */
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;

-=C2=A0 =C2=A0 adjust_range_if_pmd_sharing_possible(vma, start, end);
 =C2=A0 =C2=A0 =C2=A0hugetlb_vma_lock_write(vma);
-=C2=A0 =C2=A0 if (vma->vm_file)
+=C2=A0 =C2=A0 if (vma->vm_file) {
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0i_mmap_lock_write(vma->vm_file->f_mappin=
g);
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (range_has_shared_pmd(vma, *start, *end))
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 adjust_range_if_pmd_sharing_poss=
ible(vma, start, end);
+=C2=A0 =C2=A0 }
 =C2=A0}

 =C2=A0void __hugetlb_zap_end(struct vm_area_struct *vma,
@@ -5397,7 +5401,9 @@ void unmap_hugepage_range(struct vm_area_struct=20
*vma, unsigned long start,

 =C2=A0 =C2=A0 =C2=A0mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, v=
ma->vm_mm,
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0start, end);
-=C2=A0 =C2=A0 adjust_range_if_pmd_sharing_possible(vma, &range.start, &ran=
ge.end);
+=C2=A0 =C2=A0 if (range_has_shared_pmd(vma, range.start, range.end))
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 adjust_range_if_pmd_sharing_possible(vma, &ran=
ge.start,
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&range.end);
 =C2=A0 =C2=A0 =C2=A0mmu_notifier_invalidate_range_start(&range);
 =C2=A0 =C2=A0 =C2=A0tlb_gather_mmu(&tlb, vma->vm_mm);

@@ -6958,6 +6964,52 @@ void adjust_range_if_pmd_sharing_possible(struct=20
vm_area_struct *vma,
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*end =3D ALIGN(*end, PUD_SIZE);
 =C2=A0}

+static bool range_has_shared_pmd(struct vm_area_struct *vma,
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned lon=
g start, unsigned long end)
+{
+=C2=A0 =C2=A0 unsigned long v_start =3D ALIGN(vma->vm_start, PUD_SIZE);
+=C2=A0 =C2=A0 unsigned long v_end =3D ALIGN_DOWN(vma->vm_end, PUD_SIZE);
+=C2=A0 =C2=A0 struct hstate *h =3D hstate_vma(vma);
+=C2=A0 =C2=A0 struct mm_struct *mm =3D vma->vm_mm;
+=C2=A0 =C2=A0 unsigned long address;
+
+=C2=A0 =C2=A0 if (huge_page_size(h) !=3D PMD_SIZE)
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 return false;
+
+=C2=A0 =C2=A0 /*
+=C2=A0 =C2=A0 =C2=A0* First apply the same cheap test as
+=C2=A0 =C2=A0 =C2=A0* adjust_range_if_pmd_sharing_possible(). Only the PUD=
-aligned
+=C2=A0 =C2=A0 =C2=A0* intersection can contain shared PMD tables.
+=C2=A0 =C2=A0 =C2=A0*/
+=C2=A0 =C2=A0 if (!(vma->vm_flags & VM_MAYSHARE) || !(v_end > v_start) ||
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 end <=3D v_start || start >=3D v_end)
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 return false;
+
+=C2=A0 =C2=A0 start =3D max(ALIGN_DOWN(start, PUD_SIZE), v_start);
+=C2=A0 =C2=A0 end =3D min(ALIGN(end, PUD_SIZE), v_end);
+
+=C2=A0 =C2=A0 hugetlb_vma_assert_locked(vma);
+=C2=A0 =C2=A0 i_mmap_assert_write_locked(vma->vm_file->f_mapping);
+
+=C2=A0 =C2=A0 for (address =3D start; address < end; address +=3D PUD_SIZE=
) {
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 pte_t *ptep;
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 bool shared;
+
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 ptep =3D hugetlb_walk(vma, address, PMD_SIZE);
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!ptep)
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue;
+
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock(huge_pte_lockptr(h, mm, ptep));
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 shared =3D ptdesc_pmd_is_shared(virt_to_ptdesc=
(ptep));
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock(huge_pte_lockptr(h, mm, ptep));
+
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (shared)
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return true;
+=C2=A0 =C2=A0 }
+
+=C2=A0 =C2=A0 return false;
+}
+
 =C2=A0/*
 =C2=A0 * Search for a shareable pmd page for hugetlb. In any case calls=20
pmd_alloc()
 =C2=A0 * and returns the corresponding pte. While this is not necessary fo=
r the
--=20


Does this look like a more reasonable tradeoff?

Thanks,
Zhe

>

