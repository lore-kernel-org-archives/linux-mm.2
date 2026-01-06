Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85CACCEFD11
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 21:29:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 840D46B00A6; Tue,  6 Jan 2026 16:29:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EDE66B00A7; Tue,  6 Jan 2026 16:29:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F0C26B00A8; Tue,  6 Jan 2026 16:29:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5F2226B00A6
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:29:41 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 012A5160CB5
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:29:40 +0000 (UTC)
X-FDA: 84302830962.22.B00EFF0
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2E00C4000A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:29:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=miPC4uR7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767734979; a=rsa-sha256;
	cv=none;
	b=3gxnCrqcphiodNYc7IzQzA9vyFXTw4eJAxpu+wX6ZeUiYDkyPbQjwQinmfPcBMBxfD+bqF
	z6BHgIzGo5dCsH3YpW3IkTsmPc+dkcNErLKn7c9i1FJcnFJ6aa4xsaz+rKTswaP6qiBV0X
	uiN+d/FAs29lKyFW4TmnAU/2mSjqWQc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=miPC4uR7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767734979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I3zjahn8T3WCja+qS1GjQYcEO/PlU6X91htTMP5EirE=;
	b=OIoDRi2U6tiJ25AczZEtP9HGTcDnMzmfBRUF/LSyncN0rgUEzuwdS9bvemi5F5tjWYTwqx
	Yorq5Hpib9MIJY3KipPBwgldkaZDCQHV8xsUC0P87Hv4rfnthDonw1zKzyKFbU8iTyAtLn
	pIvimQg4OHcMHJeruZrsWgSjD3UWtNc=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-88a2d21427dso13972456d6.3
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 13:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767734978; x=1768339778; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I3zjahn8T3WCja+qS1GjQYcEO/PlU6X91htTMP5EirE=;
        b=miPC4uR7OGhh+J++wXKDckpPjJE0Nn5h95k5sHc2vrjXh92IBKnBmMy2xR1I+XzIrt
         rnZRDXlNqRF+zAqq2hCrioo/HB2oS9i4ToD2oaX/VPXr1jGnJKxqUlZtlFBTplabgSVa
         IKd6fE63Ml4q0fy9ifJBCBf3ZdmfTBbpB8nX+/IkeSxWkjQCBkMtkorQiDEnut0InZrb
         AlxKe0EHLjHr2mxsJCsPsKNkrQcWSFE+rG9SCuWJdNwYTBJJPiuRdhxzR7Qk5+O2S2su
         5ti9RfXATpIJPQgJXV3ArrXcvz4UIhPuw1zQ7q5CVp4UXrGPXzMS9fs0s6afZf06tYEL
         OBWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767734978; x=1768339778;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I3zjahn8T3WCja+qS1GjQYcEO/PlU6X91htTMP5EirE=;
        b=d3dwu0ofBRc2AMA+0V2jUjwfzP2O77g0MIkvjRTcVtMZNc/J8T/K4zDSCLKA5eGP/s
         QEiByLIrG13UYZ45OoCC/as8r00DkNhPEgWDI/izqOphof1EiZXGCYlzT5tFlbzxO9aa
         aF0jeN4n3/riW5i30qOpz1mx/pDzCo5EkXph2Z7sz82QqSzFRibU+JCP1ahyvotI8WGl
         OcE5wqpY6XcwjHqMFB0q+y7jpCkPc5O/AdEQkLdE2xNVhzMdiU9WGCHT1IY5sPuL8DY3
         zSgt55cOLcPfc/nMcfjAbbHonBJCMoJqMNcCVLSJ1+mr4BM/y+ztlFKStWwjSBLPX+rI
         avSA==
X-Forwarded-Encrypted: i=1; AJvYcCWc+luozd/vZCQydWxcwFVV4Kw61V4WwhxHd9BEsO3wO3jsComnfu8+jHS1OQ0yrtwYqAvv/i2ybA==@kvack.org
X-Gm-Message-State: AOJu0YxZMXYT0Ch0/+B2ZmiUO/CeDITJqPz5dB63T6ryVQG9WLwlj2/y
	zOdQjBUzTmEdn/KnLN7YcUFOoD3ipOAJo/7M0Id8hoRDQKY2BubFDUn540sIEN8kxkCB8T2x9X5
	Uh1V5e/UzgfHtHTm5TO/ZlgtD/yUt2zo=
X-Gm-Gg: AY/fxX5sBD9aqo1l6a2xjbxhSSowZ1oH0hGAxjzHgV9VZKVIRUnfv6rfG1YxT5yzj77
	g1AeRu+MIPDUGECPvfMn0B1ywt2cEIz8FyUyRRstDFJyUX3zRzMASUwoRbDq63PprJEkMwrC5EW
	+KTKlMzpNxy3uzIa4HYm9apEtuyJuNIsBvs2PPSviU+ifkIz4Qlugca3z1BdUMkTSWQSxdv/56r
	8KRRaMolspbOsM48SLuCAxYziIaIQTy7zmPO5TGq/kY9eW47Y4IEFduSBqmR8A2xFD6m5rNL4pB
	haKD
X-Google-Smtp-Source: AGHT+IFBFTBjIk61F+k7sjdbtEFqa+eDK3RQZsJs/Vz+F3rPSMTDJenxsaZritdQ4eQpFloBiKlHyEaZpqgbbWzDq9M=
X-Received: by 2002:a05:6214:5a0a:b0:88a:2b12:f746 with SMTP id
 6a1803df08f44-890842a452fmr6151926d6.56.1767734978076; Tue, 06 Jan 2026
 13:29:38 -0800 (PST)
MIME-Version: 1.0
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
 <20260106132203.kdxfvootlkxzex2l@master>
In-Reply-To: <20260106132203.kdxfvootlkxzex2l@master>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 7 Jan 2026 10:29:25 +1300
X-Gm-Features: AQt7F2rL-Zf8YqKEcucnaMZPmDexQolmxiwZjT9Pk0GgPcf0w9YhWyyrqBnVLII
Message-ID: <CAGsJ_4yKRtyADU2ZxUMgvqdrhAEL4SpZxCMRt28gNJfUf--5zQ@mail.gmail.com>
Subject: Re: [PATCH v5 5/5] mm: rmap: support batched unmapping for file large folios
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org, 
	david@kernel.org, catalin.marinas@arm.com, will@kernel.org, 
	lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	riel@surriel.com, harry.yoo@oracle.com, jannh@google.com, willy@infradead.org, 
	dev.jain@arm.com, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2E00C4000A
X-Stat-Signature: jnnythxszbpfhgysmhm1ci9arw4wo9jt
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767734979-416138
X-HE-Meta: U2FsdGVkX19dzvfwemtaBIzJ7ZgWzqzsTJyXhadrZYvJ37RDvEV1MyuV7NDABA/Iz2w00eZOKiIuOHoo2ONrugvtDmc5V/EoxuJdsdAgWSXy4bgEjErBxgO+08A3rr2Vec7mT+2wsLnpBLmz3PbF0Ajdbq51u997u1weOw04EiaA+i7ZatkOUrVDbPACorO0sSLeN0RQ0phiJvUsaouMDcLBKl2935En4N3+ZgoeP8pV0gnuiX5BkWJnnC7lFQQs8wxoUWwqtstlBEHTdZGle2OSKypMHUvEV6HQwwZPJh2i+1dWzwi6DyKq/FLbJo1DQZsbXkMtbDjzcVKVtGcOoZvb/WzKMdVwqPaPZ7i2orrGxP05RgPgt+Ma7Y2vuGuI8f6pwhHGz31Sfo6oKqpkXdxvuAiDENGiPFGAG8qyLckAps6oATZIMrYsrJmyRKUv93LfhC9QzzlVdgviAJI1aJfiFbtgXjy2iCBcjmuAe7+piNTiH4G/3Jju3KDOciyTza7W9Gmv+upuE0+QEf0lanmTmOD+sA48wn7YntRFPGXQ98ReTjgpfzYvihPJP0M+BHrLhcN6SlPKyspQYQPaq9uYdrLN8qWC6CqSKYE0GQLmCV/kAC5YxMXnTUYhf0lGrdBqakrp9KSdKpEPyfhxL/rV5yliJd7d5WnPY9bUiH5pkuwnBWwis7oz+8SgrSkVAUc+4K+WMrO6B+2tsO+Hh4gSHJlqY8OFBih7NkFSIKSFELcAgNFUlv8JvIUsmdZ2/j1HQm2qkQs5efTGIrR6w1Ohau7y+KLNm4kELx05v1i5Zug7FCuRC+3/EZ/9NnkuDtjXlV96pht13NidShsWZ4ySepJNsDN02Q5+qygrlsYyFw36MLpq8tNUuNpGZ0J4R/K0GIAGfZRuZlTTsJRV4Fe2WDs99aw77o8RwRKyKhFm+wqjqJHDmIhIb8KimV+zWbzMARq9ZT7cc+mqMmN
 TjDY2y5n
 F7D9Fi+n5rQl7K/rbUAobdcr69SmjKxDcWeIYe+EmvqFnNqtuJetqBIlkNEfjRAUXnPI2yLZPK3ooqo7guj2/O9yApq/aFNDpU6ptm5NvuIF4uG2p0rp9sGMczfyMaAqK7OES4wYDxm74MQMzEgNMOmmUYwZ1mXIaoWgh3ZlnKfPOdOIqLnsGO96ckgSMVb2sbyKvN1ohlo5O0k3LXFXL4/LcWmUFRC7hByj88+kUWgpfU+0aErLhnZCoTy4Vgo/d4gZdIgxgwMa4frwksajU4rVQsYicGIMUK8eOtQ1BAfcFI4eIrFQHVtzasJ9yt2Z/wzI5CDWPIlHkhOuAVB+Ej8fjsNZWFrcLgVVduZ/0rju6bIxeMImjDCCfTjRpAYPT4UnJ0/eK1wbl4haw1DdZ+XYfCjaMYuRHMVhileRFKv3+/zSt3tRfEiG/cpN6PZQbyv1EF8rLTykY1n+YiJgWIY3fQ3fp5ny8M43eZfm8dv8UzByyTdaPFy98U6AEFs6GnPCHS+y+P7czLFSg0Uou3b4TpXGLu3UxB4NJ+d9QqTq7D/s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 7, 2026 at 2:22=E2=80=AFAM Wei Yang <richard.weiyang@gmail.com>=
 wrote:
>
> On Fri, Dec 26, 2025 at 02:07:59PM +0800, Baolin Wang wrote:
> >Similar to folio_referenced_one(), we can apply batched unmapping for fi=
le
> >large folios to optimize the performance of file folios reclamation.
> >
> >Barry previously implemented batched unmapping for lazyfree anonymous la=
rge
> >folios[1] and did not further optimize anonymous large folios or file-ba=
cked
> >large folios at that stage. As for file-backed large folios, the batched
> >unmapping support is relatively straightforward, as we only need to clea=
r
> >the consecutive (present) PTE entries for file-backed large folios.
> >
> >Performance testing:
> >Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and =
try to
> >reclaim 8G file-backed folios via the memory.reclaim interface. I can ob=
serve
> >75% performance improvement on my Arm64 32-core server (and 50%+ improve=
ment
> >on my X86 machine) with this patch.
> >
> >W/o patch:
> >real    0m1.018s
> >user    0m0.000s
> >sys     0m1.018s
> >
> >W/ patch:
> >real   0m0.249s
> >user   0m0.000s
> >sys    0m0.249s
> >
> >[1] https://lore.kernel.org/all/20250214093015.51024-4-21cnbao@gmail.com=
/T/#u
> >Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> >Acked-by: Barry Song <baohua@kernel.org>
> >Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> >---
> > mm/rmap.c | 7 ++++---
> > 1 file changed, 4 insertions(+), 3 deletions(-)
> >
> >diff --git a/mm/rmap.c b/mm/rmap.c
> >index 985ab0b085ba..e1d16003c514 100644
> >--- a/mm/rmap.c
> >+++ b/mm/rmap.c
> >@@ -1863,9 +1863,10 @@ static inline unsigned int folio_unmap_pte_batch(=
struct folio *folio,
> >       end_addr =3D pmd_addr_end(addr, vma->vm_end);
> >       max_nr =3D (end_addr - addr) >> PAGE_SHIFT;
> >
> >-      /* We only support lazyfree batching for now ... */
> >-      if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
> >+      /* We only support lazyfree or file folios batching for now ... *=
/
> >+      if (folio_test_anon(folio) && folio_test_swapbacked(folio))
> >               return 1;
> >+
> >       if (pte_unused(pte))
> >               return 1;
> >
> >@@ -2231,7 +2232,7 @@ static bool try_to_unmap_one(struct folio *folio, =
struct vm_area_struct *vma,
> >                        *
> >                        * See Documentation/mm/mmu_notifier.rst
> >                        */
> >-                      dec_mm_counter(mm, mm_counter_file(folio));
> >+                      add_mm_counter(mm, mm_counter_file(folio), -nr_pa=
ges);
> >               }
> > discard:
> >               if (unlikely(folio_test_hugetlb(folio))) {
> >--
> >2.47.3
> >
>
> Hi, Baolin
>
> When reading your patch, I come up one small question.
>
> Current try_to_unmap_one() has following structure:
>
>     try_to_unmap_one()
>         while (page_vma_mapped_walk(&pvmw)) {
>             nr_pages =3D folio_unmap_pte_batch()
>
>             if (nr_pages =3D folio_nr_pages(folio))
>                 goto walk_done;
>         }
>
> I am thinking what if nr_pages > 1 but nr_pages !=3D folio_nr_pages().
>
> If my understanding is correct, page_vma_mapped_walk() would start from
> (pvmw->address + PAGE_SIZE) in next iteration, but we have already cleare=
d to
> (pvmw->address + nr_pages * PAGE_SIZE), right?
>
> Not sure my understanding is correct, if so do we have some reason not to
> skip the cleared range?

I don=E2=80=99t quite understand your question. For nr_pages > 1 but not eq=
ual
to nr_pages, page_vma_mapped_walk will skip the nr_pages - 1 PTEs inside.

take a look:

next_pte:
                do {
                        pvmw->address +=3D PAGE_SIZE;
                        if (pvmw->address >=3D end)
                                return not_found(pvmw);
                        /* Did we cross page table boundary? */
                        if ((pvmw->address & (PMD_SIZE - PAGE_SIZE)) =3D=3D=
 0) {
                                if (pvmw->ptl) {
                                        spin_unlock(pvmw->ptl);
                                        pvmw->ptl =3D NULL;
                                }
                                pte_unmap(pvmw->pte);
                                pvmw->pte =3D NULL;
                                pvmw->flags |=3D PVMW_PGTABLE_CROSSED;
                                goto restart;
                        }
                        pvmw->pte++;
                } while (pte_none(ptep_get(pvmw->pte)));


>
> --
> Wei Yang
> Help you, Help me

Thanks
Barry

