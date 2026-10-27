Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE1AE606A31F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 21:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R6z+kAm0
Received: by kanga.kvack.org (Postfix)
	id B9A346B0605; Tue, 27 Oct 2026 17:23:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4B056B08F5; Tue, 27 Oct 2026 17:23:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12146B08F6; Tue, 27 Oct 2026 17:23:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6540F6B0605
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:23:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C40A3A888E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:23:13 +0000 (UTC)
X-FDA: 85369681866.14.C6AF0BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5F1EC40003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:23:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R6z+kAm0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793136189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9d3CjGk4IyINuQoAlcYK4HfriQfpoCwO3FN0Jov9T4c=;
	b=rg+/KwUkLSUe+Q3bOKxqNn97kRYpHNelAEEjsznKnlMznwL4kB06XOtL6kkQCNhjIUYpPW
	omjD9S+5LiAuiyYj1FcifxWUbCPuHQzLc4lLD0quc87/yW1mCchSMAPl/2HkIviuhiVf1z
	UxuBKousl+GmFWDl5ZhdvxiIxBuWdMA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R6z+kAm0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793136189;
	b=sOpXN9Oh8Pm28+O6X/QejWUxKGacW9vixiV9ymfXt1F7S+Sv7aO6hECwf3pS8Ck2MAO87X
	n73Cu02heAM/uS7Il//9lyeirEEgyd56RV0+QLamPh6bJ/ZhvQdI1W+PYLdJnJ1yHft/8S
	bOjkhbXVF3oHfkFNJGucw+tgygmdufo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E6DF43D95
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD2A1F031E2
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793136188;
	bh=9d3CjGk4IyINuQoAlcYK4HfriQfpoCwO3FN0Jov9T4c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=R6z+kAm0PuJyWoP1wDpeDsMLfxEdKmvEBBNq9ncNVSENbCX0QB2ik5uDEOmNLgJ2P
	 VjQn8CTRH1BrUxIyQVAonsw5zEoLGAz9Mo+1iV1QE4yWhK65BlHE2meFhE3PxIgA8g
	 /w44e+ZyxOFykN7XZDiFYDvmvxGU4dH81q/05iLJklEIVVEHQ1lomD5FIRAh3Mz+zg
	 L+keYsUOFf+gHec1Kcsndv1zeAUtqDN7WkbVKUcnNs52DNFvLoGFNR87W2E5YFEqGp
	 YGLXO/1Xh5JYSqvvFMXmATv4ECYgilcVloUirDQAQjuUbZ4s0DrO6SctrHKceD5mJV
	 XmNhaeI0DoOGg==
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-91befe703c4so3360456d6.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:23:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx98GpHfMn7e4uz5aW50XRTvs6sOa3xG+dVi1EnRXdlAK4ZM+cnVPQsaX+uUWpQRiq6AQh4gT6IUA==@kvack.org
X-Gm-Message-State: AFq9FYIE4U7+ip+9uCkGyxIkF627S66/25LOF8clUmVFC7Ht9eT3uzjv
	hxfkuAuPhTCnKcmZWN6ZuEY+ahgJayUYbtns5DekDMWg8Kb5Gu5M6F8qGHiFqCUeUYN40Gyca4l
	xWfLr419Lr3gQXYQ/NWWRvCtnpMoM7fI=
X-Received: by 2002:a05:620a:17a9:b0:93e:9934:d179 with SMTP id
 af79cd13be357-94408cf6b61mr29933485a.56.1793136187480; Tue, 27 Oct 2026
 14:23:07 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org> <20261027-fixes_core-v1-9-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-9-6f74bec9a5bb@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Wed, 28 Oct 2026 05:22:56 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xy0mbje=iWGNkaGKOS9BzZdu=oEhZK6zokUV5=5-sANg@mail.gmail.com>
X-Gm-Features: AclHuK-0yMwUgshVkFS8VwS5_y6OqXYnXUcZ3OjIhbezUk0HJVn0mGZCE7K7epg
Message-ID: <CAGsJ_4xy0mbje=iWGNkaGKOS9BzZdu=oEhZK6zokUV5=5-sANg@mail.gmail.com>
Subject: Re: [PATCH 09/46] mm/rmap: handle device-exclusive entries in folio_referenced_one()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Lance Yang <lance.yang@linux.dev>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-cxl@vger.kernel.org, stable@vger.kernel.org, 
	Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5F1EC40003
X-Stat-Signature: eb8mn76mkst1e58qrbjanbza4jmucrgm
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793136189-734168
X-HE-Meta: U2FsdGVkX18WAxPSNrE64yLdJUoF8swRz9gOcWYRHPR5Gziu2Hfl6U3tjvfxB2tZnuBp54OgH1Qmt3bTcepB4QsV+NEl1YxZgDLg9/EQwcjoi56+qFIobvNNkOF8sBJzw8ZY2gxZ3ecw51/8dHCwcDUDGBAPpBWY92Lu02Q+rzf21YzwJ/Q3Z0jWITxv7lN2es0zz28TzAJdZ4DfpM0y9QVSHPQlJepAJXCr2a14EcONa3CpwQ5FaGVRWIaRmv9o1CzSBEzmRU6uQoIcM7oHSw6ieQKi7r9UqDxjju48Rmd8Vj7ahh9R99MG7uYe0lGY3WwfRT5Ls8T5/pkBsD5RXTUOpAd+yvgyM74vXFkW+rMX9r25TMezPCXqLEefPFglbCCMujkZvaUXqlYcYUEwS8nVIMWu7EMExwzpcdAop2TJPyXnLPoQdlmUH38UFC5YXkiIAuTvPmDw4StEgsbIIjqoxoRf2bPVrf4Bs2ZQlnlibX1kFKCgSXfWJwja2C1yUvnoJvfGRggdJ5pTEf1oagjtrqGOWjSG9Eg8e4JD0xwZaG/XwtRKU/kEhDl2t+Ad+wC1mXZssuElxtwRWeVl1rva3A2y61MHI8XKwAqKYycxTHykG+ML0sm5G4O7GzAxKNbTKXgBIVTGzIfLpQuqnEk9+aYK5JMFvYg43lfkVwbhU0BJgqgJHtAUPRLAvxfs0VoZ4Nl7Jzzm2V1znA219VTReZ6pW9Cgs1ZwovbTiRuzbGb0F76dTtKer1NJePrjPuS2ldyRGGCfggmqXXmrd3om+vS62U2RXkKAEvsW/fXShRA9ezv3aiE0OBOS9yus7ApQ4veLhmsQ1NHqx9wJTXgeahXcZrzWZwMWwmUpYNTnKl7zexEU52bumgnHzbbKg/6ZZocxScsVxk6cSJnL5fKrVaylwYMj52H5J5EgJCICU4mhEOv8+rn49XM9BWwu4lNrNiKqhQ0ogZsTGpR
 29zkTVXE
 H077hXkUX/L+E4ofO5MMf7imtIov0qfkSGT5ilN70mofeWJBq/jpTF7x+JjGWJlDlkYYzf9F7LvcvcAqq6O9UG4Y+oWy2Y7JtN3VlguI7vGIal1rYHU/i+ADhiJb0ecqR3rXw+dEkKxi8IlxcClODwZSG6ltwNek5WI54y2aSj6rt0RFSp8bztAvDLRCY8hTfcj5vQGQ2MDZCG+4oNz4rDYquJFBEJSVZI4Izmvy90MmOv8W+fE3zuLksdpFs8W3E67P4IyvJ6b8l10LOul0thZagHRYKospnWYUDmTs/XQrmVVx0WWBKbK4HUIs9xJjza4WCWOD4hs0sRO5fMEmGWpeZBVVjQBv3M03cB60w33ZPckSurlnvMIPwnnXfbcpwfb7AT0ZolhVOEPFetayg7Qj2Sj2hQ6/X5uRW6bSI0Bnz/hQXC7OPjkwnciktnQejtbl1pADgYq25wz8c8E/0gJc1GL9QA4IPfrUlFk8ZpCKih6Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 7:20=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> page_vma_mapped_walk() can return non-present device-exclusive entries,
> but folio_referenced_one() passes them to PTE young-bit accessors that
> require present PTEs.
>
> We must neither call clear_flush_young_ptes_notify() nor
> folio_pte_batch() with non-present entries. For example, clearing the
> young bit on non-present PTEs can corrupt the entry: on arm64
> PTE_AF overlaps the swap type, so clearing it turns a device-exclusive
> entry into an ordinary swap entry.
>
> folio_pte_batch() will VM_WARN_ON_FOLIO.
>
> Apply the same approach as the previous fixes to e.g., damon_ptep_mkold()=
:
> treat these entries as old from the CPU's perspective and obtain their
> young state through the MMU notifier.
>
> Skip PTE batching and MGLRU look-around for non-present entries, and
> don't modify non-present PTEs.
>
> Fixes: b756a3b5e7ea ("mm: device exclusive memory access")
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

[...]
> -               if (lru_gen_enabled() && !lru_gen_switching() && pvmw.pte=
) {
> +               if (lru_gen_enabled() && !lru_gen_switching() && pvmw.pte=
 &&
> +                   pte_present(pteval)) {
>                         if (lru_gen_look_around(&pvmw, nr))

I was also a little concerned about the internals of
lru_gen_look_around(), since it visits a few neighboring
PTEs. But after checking, I found it is fine, by checking
get_pte_pfn() =3D=3D -1:

bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr=
)
{
        ...
        for (i =3D 0, addr =3D start; addr !=3D end;
             i +=3D nr, pte +=3D nr, addr +=3D nr * PAGE_SIZE) {
                unsigned long pfn;
                pte_t ptent =3D ptep_get(pte);

                nr =3D 1;
                pfn =3D get_pte_pfn(ptent, vma, addr, pgdat);
                if (pfn =3D=3D -1)
                        continue;
                ...
                if (!test_and_clear_young_ptes_notify(vma, addr, pte, nr))
                        continue;
                ...
        }
        ...
}

Thanks
Barry

