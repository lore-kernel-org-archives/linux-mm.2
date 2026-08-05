Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D769C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 04:43:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E6E66B007B; Wed,  5 Aug 2026 00:43:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 497CF6B0088; Wed,  5 Aug 2026 00:43:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3864C6B008A; Wed,  5 Aug 2026 00:43:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D8AE6B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 00:43:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B9671A03B0
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 04:43:00 +0000 (UTC)
X-FDA: 85065970920.03.75F0755
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id A29AB40007
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 04:42:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=m9o3FlBa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785904978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2fS3CRvb6lq0Iuc+rlgHm4bS9etZncctYSA+3VGd6Fk=;
	b=3kcgHX90uoHiGpPyo5mF59ajw4TnU6BHzUQMGx2Yvdz9N6qu7QSj6Nf090ARkClLyGpxyb
	xnAjVNoRWoyOGSjzFmYVZUhohvfvo4XdvC/wvSnpI+ffZbESvHHYwhwyQmJGJV1lizTzhv
	DrXQJ6aL4l5YmkyZbYYmGTcA10SyCL4=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=m9o3FlBa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785904978;
	b=YSDSU06awEgyD4xnWJBGMrqEhkwAlCA0EVVOXMfWUejvAr1m1ywVSSEpQNCertpWDYl44k
	Jn59hUHkUNnt1QCzB97ptBK+1jpjMr2W60eFAmWPOWomHkwAKPisZul2tTryHXggLSR4+4
	1cDIfUq34Joc9i3NcYM7IGXC6VlHtkQ=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5b2a8173142so3111e87.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 21:42:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785904977; cv=none;
        d=google.com; s=arc-20260327;
        b=YGsnVKD0HzOwrTWSwkSlXlDPYZZsiISOH7lTNo8gS7oXpmPJOq6/3eB+zKs/a9G3JJ
         QvPzo9TTQ+fYyh9dZQ4C10A8szK+Ym4edPgnyZULBRE6usLU8StkdH+TMo9Q5AdMktjo
         DR1CVRnTcBzYhu+BvEVmo6Etcay4Ex+tfZRdD47ELG29sca7jrKTp3tWv5ril0KXJUhS
         vEPhTlTPXRvESEW4PLyFfdD+2XLqZtZGEq/IyIQ3+O2FGqF5ctV7u1hiiu7vVGtHaLeh
         oMSocvH88OR+cP2IKT/PVY71TtX581vhv1UmZ+vzjTnpr34grpWQADB+8IuiV5XZCJ+v
         1hkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2fS3CRvb6lq0Iuc+rlgHm4bS9etZncctYSA+3VGd6Fk=;
        fh=9wh5sZMvmY8lx7n6GniBcg4Hqzm4S7Uz2EM+rP8FjjA=;
        b=SOmZfeReuQud6eHEMMXL0+69HhCR+Zq3G2Pnu7yootBsl+7J1To5IX8OYY+Hjfd/Pa
         H+/hBvInO49F5kG81h9CvU4qZ5iHN9vpebiFuR1wUhP3UMhkKgaIhV7hsAvOqSnfl3Mn
         9OCaL/XWFDiieylNxq5XbLKc4EhWF9BkaFtaoUzIhe1F4SQ22bL4FwCTjC9ao+LJAGri
         gn74IpHurOoW9fApqcJiGL0+iqD5tkq3F2qcFjL0e+2nCJrhvz6HSqJLQkRlq6/qHFRV
         KjDgmk8kvzrB1bAxY6Vod8smCPg4YU230bBZ/4ucJehlUi+4YyT9mqjqig67YHoPjYHC
         owOw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785904977; x=1786509777; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2fS3CRvb6lq0Iuc+rlgHm4bS9etZncctYSA+3VGd6Fk=;
        b=m9o3FlBaZ7qNMs9/2ywMOEGkpEVLiV4Bxu+TcyDyU7AS0C05YSklaqMHp8n3yvhPl9
         pBJncSl4b5aRDLZPSZ7Ox7yb+zUdFt5c94GlK23uCTiYtz1asSkCY2pohWV/FsrWjEmI
         Z0yOvy8apjq+uCw6QiV8A9AIatZFHD/XrdQdqkG3t9kW0GkpRAzpQGQ1XCymHTlFADYf
         bS6Tc2Lp7ZYW1iGBBQgoPdYu90ANqsC7g9vfObNBsgaiDKdqccukgqDG3vJf8CjNNXGp
         9S8ewYDN2x8Q16PAT+M9Fge04AZSISefxvD2PJSkbF0VM11l8N6Hxj+wia4FEGMs3XSd
         achw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785904977; x=1786509777;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2fS3CRvb6lq0Iuc+rlgHm4bS9etZncctYSA+3VGd6Fk=;
        b=Yw6oZQiEOrL4+RCMHX8xuu4Apth05sNtA1OfTHUem8iQ65Xh3dl5xXXmffLb2Mc96a
         y2Nv54UsGBSiylhLc/PJ12auuRG0oVjgKmhx5cCtTvGuYD622u53unDzJh1hB/cuRljo
         krRoUmAN6P+fieqljbyZlwwrz6ZCTJ/ASMrzPTUXiPn759UdiR2QxFRbZnmOaLjN0bKx
         Y3sktaa4taxQUgGyDGzsx1tb9yS0vBiawtuLBgVmCx4lXe4ezKVoI5EUeHYJk1z64UQ1
         M2qw+1hH7jArR/OKZxRDSZvK5MIlmYUauzXUMmzmYmYgK3leq5NmGCLVtahGjiP8Oy6a
         8dig==
X-Forwarded-Encrypted: i=1; AHgh+Rr1hoXSGAefdPFtf5n3pn9OVKrYeJHCJ98I0TnAlQ8UeX99FYYrpb0ZjZ6783GHSn5FCxE39UozUQ==@kvack.org
X-Gm-Message-State: AOJu0Yze+Gm/yVOFDdkj68RmWnDl55qNJFUmLL6PVvhsIL7xpzig0MXE
	6MED6dlBjUc/wCiP/BSb1uo0fe4AOsAA5I4dl4R4J98Nisvb8oPOi9m/cYVGldox+haF6RSxcWD
	re6czqRKHctT45etUINJqMCRhhDa2RH4tszyYeQvz
X-Gm-Gg: AR+sD12asXmmaveZWRcKK9/tDB7KjjRAFX/qPgO+wqmeKEa0mDfkOAln67epGSfJUTb
	ogGMcnvGOu5qJ1AKvhkRqoI8wGc9O5twmU1cBVvtJeWsxUfVNITNpIQukOTVRMdimHe0QhxG6qk
	EFam0IPf6HDs3nks/g8X4SPnGmIh2Js87D4ulWD4oPw4V5OPtdgOaCNwOmL8wbqCXjM+ymm/xIO
	IS3cbqyByj1V5Ch938BBeV8nl2UJNtE8njtA0P/TaTiO98/+YpxJMATTIcSd7yEXZrruE8vDWCc
	3Bww4ROgAyySLiEhgze8qOsP2BQgOiUEbq4l+xlaU0OPSpshqCIw3EnT8fjrEpmnRmPlUG4kxCe
	xN0Rs28hTcanWIXTWpVzoAQD6Qvfc3epLAg==
X-Received: by 2002:a05:6512:685:b0:5ae:cf5f:4a88 with SMTP id
 2adb3069b0e04-5b2f4f515f6mr147419e87.8.1785904976508; Tue, 04 Aug 2026
 21:42:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260726072935.3513996-1-souravpanda@google.com> <nuoxvxqgb453fuj5ezhjn374chawnrao53tev3wdqigpc6pfnm@q5oamexnzqdz>
In-Reply-To: <nuoxvxqgb453fuj5ezhjn374chawnrao53tev3wdqigpc6pfnm@q5oamexnzqdz>
From: Sourav Panda <souravpanda@google.com>
Date: Tue, 4 Aug 2026 21:42:45 -0700
X-Gm-Features: AUfX_mw-GmUFn6dujSkot1Lj5wsFMm0m2mFgDWsBvNUle3p6E3QAyWVH0AEGg8Y
Message-ID: <CANruzcTm5_Znta8ySQpAXJO10EXM8Nqov+SY-ZWG_6b03BTQLg@mail.gmail.com>
Subject: Re: [PATCH v4] mm/hugetlb_cma: Fix null nodemask dereference in hugetlb_cma_alloc_frozen_folio
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org, 
	david@kernel.org, surenb@google.com, fvdl@google.com, gthelen@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A29AB40007
X-Stat-Signature: 687j5cyq8nkepk9rxuap67sf8mnfkcgk
X-Rspam-User: 
X-HE-Tag: 1785904978-654151
X-HE-Meta: U2FsdGVkX1/8SL9UxoYaCKYgkB+sPhW8jF2XeuzUuJCm1m/XK2tJaHcM8hOLYBRYmId2Iog8x1hdSwdSREDg/s1K5p80UuGdmj6mj8QG7Qu1AILjK84tHgQSd4+neK/tvKx9l6VxGYgdyjznf3NQohC0HUDRNwaD215Mrvosq6fcuwPSVRJXf56jjW60lGlklehzGbmACADk2CKs+ZBLRjYKFY9tspuqNrdkNmFgvQ0JSGzqMLoaDaSVRK3PvTUhxYv7K+eerd60l6WitYmMKMkbCB0h0d7tfyIctPPUYcMjlsqUkgqqO46HOXltwZJ8xzBtu+DcQPGR2S9RC+R00sVwbMaRIt8jqnT0lAmmx47YyezeMwFc77Y7mqJX7v7+/v/kFfKxoJEd1rEqTOePdtg8hs6v9ZejVFjYHtLs/iazCy776hivOgLtHG/TiGTvG/kgWb0qSoUI3pKf7q6ai3ja75dLMvbDIdVRp742SxQD68CIynKQ2HbBMcRaUWeeWjbDs85S4T34H6OtPX2lWJthWArt5gVGOozQo7xbv4Y2edxn6TGfLxp1TLRVa0w2QyfL+obsk5VC3ydHSwS9x93HlKEk86n4mhJcO3AZU8ZMev5/5KqJ4necwYL8d4nS6A1C0ygB9qFI7muQHTXCmbfcEVD5DfYmMR13HL2OJcA6BHqcbNXCrhV6LSigjOMHfWlglACmmAVvt/fIlr9IcvrM6S3h5/Efg8J9rnkRHDqHcSaje0nBt5GK1Anr5ihsQc1foi/8Fy1WVOWyIZ4yGK7R5/bpzcLs5jm8uS6A4U+fzcZjUekPndgY7eskiAu9wAkHQWIxFlMibcgd76qPAJObFz7+hzewFBuvLAVwiJ8islkDDRT+/pDD69IGTvzL6ok+8W4UqdxA7erDHBCYTL0Z9mQy6Out+RSFFThcxLYjGJypAImWv3pVXlHLjmtg7MBMlKSz80fKVcKXLCi
 JD5NvRY+
 ulfJrjz3r7GiER66zXLaxVNLxFMt9RxSVwTiDvM7uhBiHfG+Jdkv5tZanQ4yGm24hcczATweK85+1BSAS56Ggof07CwXG3TyL1ytMPNo7G0/sg52LATwKAQ3FYf3ccuHgz7IycLMjIiVGhazDVho8rAfsy1jYQ8VwReKK4wlMFYUZeW5BOIcfVRoSfkstaFRSjJRVgC3GzZd/Y0lPayx2fP3WH2vTNZd1NFx106XYSKQ4Gf81+C1WNUkDX2fuxlEfdMRy+r4TpmzMSrkJ4IYdY9cg5ChqRP7VCh6M34kzIjGNxMm6J2NlaAtnzKFHGlex9pNFNZQLE5c5ZczSr9JiMkw0ynUfDOtbB2z0H4Atapt7qnYlSmAU4DXkvHD5oxMyPmlARgfpw8aovcyGDHdFfFYYcjBSoYVtLyHdNNNZYrEN6sBVgKmudMTa/L6vV1xBW3oR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 3, 2026 at 2:48=E2=80=AFAM Anshuman Khandual
<anshuman.khandual@arm.com> wrote:
>
> On Sun, Jul 26, 2026 at 07:29:34AM +0000, Sourav Panda wrote:
> > alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> > alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> > nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
> > the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
> > alloc_gigantic_frozen_folio().
> >
> > hugetlb_cma_alloc_frozen_folio() blindly dereferences the nodemask in
> > node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
> > leading to a null pointer dereference kernel panic.
>
> node_isset() is being addded here in this change right ? OR was there
> another path via node_isset() which could have been called on a NULL
> valued nodemask ? Although subsequent for_each_node_mask() could do
> the required dereference as mentioned earlier.
>

Thanks for the review, Anshuman!

Sashiko [1] suggested adding node_isset(nid, *nodemask) in v1 because
without it, hugetlb_cma_alloc_frozen_folio() could allocate from a node
without checking whether it is actually allowed by the caller's memory
policy / nodemask.

Once we added that check, both node_isset(nid, *nodemask) and
for_each_node_mask(node, *nodemask) became potential NULL pointer
dereferences when nodemask is NULL.

[1] https://sashiko.dev/#/patchset/20260702215713.627941-1-souravpanda@goog=
le.com

Thanks!
Sourav


> >
> > Fix this by checking if nodemask is NULL in
> > hugetlb_cma_alloc_frozen_folio() and defaulting it to
> > node_states[N_MEMORY]. This allows hugetlb_cma allocations to fall
> > back to any node with memory, keeping behavior consistent with
> > alloc_contig_frozen_pages() and alloc_buddy_frozen_folio().
> >
> > From a userspace perspective, this bug allows an unprivileged user to
> > crash the kernel (trigger a panic) by requesting a gigantic hugepage
> > allocation with MPOL_PREFERRED_MANY on a system where CMA is only
> > configured on a subset of NUMA nodes.
> >
> > This can be reproduced by booting a VM with two NUMA nodes, restricting
> > CMA to Node 1 (e.g., hugetlb_cma=3D1:1G default_hugepagesz=3D1G
> > hugepagesz=3D1G hugepages=3D0), and running a program that allocates a
> > 1GB hugepage area without reserving, restricts allocation to Node 0
> > using mbind() with MPOL_PREFERRED_MANY, and triggers a page fault:
> >
> >   void *ptr =3D mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
> >                    MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
> >                    MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
> >   unsigned long nodemask =3D 1; /* Node 0 */
> >   mbind(ptr, 1UL << 30, MPOL_PREFERRED_MANY, &nodemask,
> >         sizeof(nodemask) * 8, 0);
> >   memset(ptr, 0, 1UL << 30); /* Trigger fault */
> >
> > This results in a NULL pointer dereference:
> >
> >   BUG: kernel NULL pointer dereference, address: 0000000000000000
> >   #PF: supervisor read access in kernel mode
> >   #PF: error_code(0x0000) - not-present page
> >   Oops: Oops: 0000 [#1] SMP NOPTI
> >   RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
> >   Call Trace:
> >    <TASK>
> >    only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
> >    alloc_surplus_hugetlb_folio+0x6d/0x100
> >    alloc_hugetlb_folio+0x3c5/0x660
> >    hugetlb_no_page+0x3d9/0x650
> >
> > Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepag=
es")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sourav Panda <souravpanda@google.com>
> > ---
> > Changes in v4:
> > - Reverted the alloc_fresh_hugetlb_folio() cpuset snapshot approach fro=
m v3.
> >   As Muchun Song pointed out, snapshotting cpuset_current_mems_allowed =
does
> >   not prevent false-positive allocation failures without complex retry =
loops,
> >   and alloc_contig_frozen_pages() / alloc_buddy_frozen_folio() already =
handle
> >   NULL nodemasks safely internally.
> > - Handled NULL nodemask directly inside hugetlb_cma_alloc_frozen_folio(=
)
> >   by defaulting nodemask to node_states[N_MEMORY] (Option 2), keeping
> >   HugeTLB allocators clean and consistent.
> > - v3: https://lore.kernel.org/linux-mm/20260705175119.440599-1-souravpa=
nda@google.com/
> > - v2: https://lore.kernel.org/linux-mm/20260704174930.2885785-1-souravp=
anda@google.com/
> > - v1: https://lore.kernel.org/linux-mm/20260702215713.627941-1-souravpa=
nda@google.com/
> >
> >  mm/hugetlb_cma.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> > index 39344d6c78d8..5744de0ceeb7 100644
> > --- a/mm/hugetlb_cma.c
> > +++ b/mm/hugetlb_cma.c
> > @@ -34,7 +34,10 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int ord=
er, gfp_t gfp_mask,
> >       if (!hugetlb_cma_size)
> >               return NULL;
> >
> > -     if (hugetlb_cma[nid])
> > +     if (!nodemask)
> > +             nodemask =3D &node_states[N_MEMORY];
> > +
> > +     if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
> >               page =3D cma_alloc_frozen_compound(hugetlb_cma[nid], orde=
r);
> >
> >       if (!page && !(gfp_mask & __GFP_THISNODE)) {
> > --
> > 2.55.0

