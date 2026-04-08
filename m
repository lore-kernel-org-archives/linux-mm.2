Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCB0610F9972
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 19:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2977F6B0089; Wed,  8 Apr 2026 15:49:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26EBE6B008A; Wed,  8 Apr 2026 15:49:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 137136B008C; Wed,  8 Apr 2026 15:49:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F282B6B0089
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:49:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9D185140169
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 19:49:04 +0000 (UTC)
X-FDA: 84636427008.27.BA4FBF8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 30F771C0011
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 19:49:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VmgmjUyr;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775677742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s6lebmAFqUc0VWZTv0HOUyslnYO3ZnOF7fQDUUciAcQ=;
	b=4MZoqeks8VVFdtKt9rToy2v0EV4aPEEXWxwGRADwTdKPFluJP7RhD/dxlYrlenk4z3u6Os
	lTioyV1RIHpPE/8LnPVEeDjHAxOtKx1Cur/GuBPlb4GZgdIzeGxTe779QdWRq+oiS7Y/og
	keP/E6U5GnxUk+n1g939QZ3c1/uEU1g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VmgmjUyr;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775677742; a=rsa-sha256;
	cv=none;
	b=BiI0GQdWKg17Zp6Yx1SOgU0g1NQjdjbX1taH6o5VWWE7lCDiG7l91Wf5ua1yL7GV6CqJGD
	3OqhG4hNTd8pbuihOoyq/x8AJ1AP4om4gn3L37M/WD25O8paPf99+1LEY9USyu1onTbeC9
	dFXbxXRtqWar6wGFPsrCHogD8S/4Xq0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775677741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s6lebmAFqUc0VWZTv0HOUyslnYO3ZnOF7fQDUUciAcQ=;
	b=VmgmjUyrbHu3XU+hBtBqvlaIcHruzqZq/RFpdHVFFaxYYjNCiWKhYOd+II3TDcsNQ9REV1
	TzzGITWPW6CJtEu6Sx3Be+CD5OVhgpvGZVj2PiEqRfvovHIs1DfrG6NqMmtEAJ7tGhHwhR
	ydm38VMFMbmo6nSOfGPw351UAZeoo5M=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-379-LkUpGBY7POWTJiaLut9hTw-1; Wed, 08 Apr 2026 15:48:59 -0400
X-MC-Unique: LkUpGBY7POWTJiaLut9hTw-1
X-Mimecast-MFC-AGG-ID: LkUpGBY7POWTJiaLut9hTw_1775677738
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-65073af0a32so161164d50.0
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 12:48:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775677738; x=1776282538;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s6lebmAFqUc0VWZTv0HOUyslnYO3ZnOF7fQDUUciAcQ=;
        b=WxUH1Ga3fDaK+LDcfd1QGLAAmb5RwbXWmXrU5qBI+JM0VpPx5H2cEWQGxzkhKNvFEk
         Kp/xQHIuawv6BAYFXoBGi1NJTRrB4DUiyhPfj7U0+aj8vxvK10InAt0WPpFnKle3PZJG
         F5caevYec3TcqqEaXpa2MfJ3KfsVpEIuy3QSv3LAP5Yg2UN/w4p4qd/auhSaeO4BxAdw
         qD3woPwxWiFnnAlen1vnp1pXG7CjSPvvkJAvh5QePRxGuaIkyk+fFGY+MpHFOgLf6WR8
         2QNV6ve0/IU56mIxqT0YA3f1xFTBxJNKFH4SIcU9LqB9E14yXvfBEdanbY3vV/xt4RVq
         Yh6A==
X-Forwarded-Encrypted: i=1; AJvYcCUWuLizDKrmTakzQCw772kAsvcQm25YjaKGURT/lHfVjKVBvs2JVZ7KSoEww9kS/3qKSOkp42wf+w==@kvack.org
X-Gm-Message-State: AOJu0YwnlKYuhFDIiNHqvJ+8C4KB6MaIWcaMuzTpni+seWLuMiijSb7z
	R5/4QqDaE0CIZifAj4kfssPckDC3A05Y8qeHIdnBy+eWzvU3N/A73o/UBwMT7BTFdy5iDngM9Q8
	4Tyzlj18CdLSvnJO8It2ZvAezqd6LtN+z2iVz2Hf2hqZKJnXRVLul9VFC8SD5qNhwcElZXVqeEV
	9dGk5r5yyE9T4UE+T28Jy/tNVtgyY=
X-Gm-Gg: AeBDieu7eLj5tL489Alb+Q2k7/b5dOyHc6XzlrqzyAxV1eo+ELwQIcJyvBlLbla9aUc
	xBr0K92zExtenaGVD2wiQkBQGdbItbGw36PLh2FbfmwmCig1SYCkF/kd4jmAfQMS5SFMrugzYF5
	Z/z0sCShesOmnYsH9bMNgoiA9cwW9ZSUJsbXt/bbLyk58DVfsL4CFOZdpghrIyy7a5U57f3j3/d
	BCJlnp8
X-Received: by 2002:a05:690e:1501:b0:64e:a976:dc0f with SMTP id 956f58d0204a3-6504870ac04mr22045459d50.19.1775677738213;
        Wed, 08 Apr 2026 12:48:58 -0700 (PDT)
X-Received: by 2002:a05:690e:1501:b0:64e:a976:dc0f with SMTP id
 956f58d0204a3-6504870ac04mr22045409d50.19.1775677737724; Wed, 08 Apr 2026
 12:48:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260226031741.230674-1-npache@redhat.com> <20260226032347.232939-1-npache@redhat.com>
 <8a4568de-e0f9-471b-bc94-1062d4af3938@kernel.org> <ee39e605-0d9f-433b-9dfa-f70fd92edfac@kernel.org>
 <c4e80668-9018-48fc-883c-5d52a5950065@kernel.org>
In-Reply-To: <c4e80668-9018-48fc-883c-5d52a5950065@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Wed, 8 Apr 2026 13:48:43 -0600
X-Gm-Features: AQROBzAhFnBMl7uCD_-PNdDxiKciHJ1I9BsrODaSd6nYngTKfPDHydTd_07lxzo
Message-ID: <CAA1CXcA8nE2PZrB4J1gV5v16PeQ7X2AiwjJ3gO1Q8hW7tyTtPQ@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v15 03/13] mm/khugepaged: generalize
 __collapse_huge_page_* for mTHP support
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	lance.yang@linux.dev, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, 
	mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, 
	raquini@redhat.com, rdunlap@infradead.org, richard.weiyang@gmail.com, 
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, 
	surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de, 
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zccMndzLzcyVq_2XZZKMRVqALu96euQl2zWbIMCDrc4_1775677738
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: oto67fr3ijzxhs5xh3bxdgof73g6cmis
X-Rspamd-Queue-Id: 30F771C0011
X-Rspamd-Server: rspam09
X-HE-Tag: 1775677741-863630
X-HE-Meta: U2FsdGVkX1/B/YIdfJU/UGg4fi+dqOa+K+KATFZd8OVoN9B46MgchxPuo8fvnEwbekoeCDNdZJ1hnjTAi2RDXaqQhdgDozBbky2KpGD145bM1kLhoJTXnEA2uQaLY1guaDwJz8a4Pg+0jp3IygtMrZrIhIXIsD0Po3tCS9XgTaV26zHJR8J15amdWQirlVzqMt6xQKTFf07g/InbIYONrjzNaxbgZ95N7nRH8pY6gLBh4gFKfOrgRlrqyRujxvDKX5vQczbyzJK65TOCbox+xdZ5Ws18okZVLE88sjo551ZT6iCtXn4mmvlSOcaWo9npWPX2uVUUbPxDnSvUXh2OT3Rok/Yu+N7+nGTcrLCNESMU/VcsWXtu/nFzYf+0x5X7lMo0oCrRY9/E6fxUZc3muJbZNlAcYneydhv77u0fjlmvNuusNS8JxuL0eOcBDdot3TkCkOXJodEn7rFZcnbq+CxPLLOUcrOUpr31YC1zJ6jPSGVp9w9ujMG5MYWIxD1hk5mhS50L2H1kTB9jz/vclx8T1UCnvqH8XADOLb+rNIO8G4+Vxw4FyM5rxspXJ7bttBqak4fXt6kVuNVnOM8OTFcuzKhffh1jVqjSprvhE6dF+/m1WqDdeBqbmfHNVQ0N1FowdUopXT0rJPv/qRu5z4oDEhp4jl6rXJ0xEaMZTVsjIFXqMKzsJm2c9n6b8lUYDqJrxJKUBp7M+NLwkiATvoYy69DQ8ZZywpvNkAWC98WoYSWTlHhR6d3e4Vxpjl7KK9lNYbxLAB5c5E0FKPNVStpLyOckuMjliMCEcL66Eja7io9ebPc1qmrSSPleB4vaeuWx1/KDDk9MwKIIL1BtCHqrEmEAuARE1r2mgXGeiox96H6hjJO5UVmLUX8f8hfO+47Hm40yqupVVCUmbWRy84niiNTcDSF1u1QEQpuZwC705ttgSm6EhjGH51gPW80nw2yPTQ6B85u7sNvfjwJ
 Oa4OJ2d0
 O07+guaxkP2OspHQCxdHY0x5x2sLjXRGpb9YoGSt8NkokGNWr8AOiN65sH8ur8O3c70OgQZm+z4l5B2/N7nxgamkOse3SEBQn9MicNLUvpc9O14Mz41BpvgYU8f/AMdmQA1ru25ALZMztHupimUb5fVj8wk5eEv909UWFDWn7HxtHbuBSwL1Kp1NjIRCPWbvBKxXAJwosbbYfr4KdFDFvDynPtLPUPvsMXCBCNPlT7eP+94jpf3EjqkfGgIHKjb16Mo7z8slBMUOZ6vl61+lEv8uEHKLnYZRnYZk1ba9JQY8kOeuU2aGDCk+IOVPBnzbYeIJAdrc9T3p+nF3/ITRhvNJw1nxTn0pCl9zUtGWusdloGPNJR/XmW42bWu6xRPUhPFOgEjxfIDc0KBrBr7CtqtDD1K0OIMtjq01tZF1sE8orU0yItbsdGm9vORNlmg919Ek8c0pnK4o83DuGuKvDXs1S6lf3mZqAKCy2EozyTfaL0FCJu/LEsSVJSxcWnVHcOVh+hZHl57eW/ERVyVeApwvrXKDyh6Y4ogcRPBB4rxgmq/dgQOfSxMW//q2rfVSrKB+NrxGcJGs5/yUSIK64/qeGDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 2:56=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 3/12/26 21:36, David Hildenbrand (Arm) wrote:
> > On 3/12/26 21:32, David Hildenbrand (Arm) wrote:
> >> On 2/26/26 04:23, Nico Pache wrote:
> >>> generalize the order of the __collapse_huge_page_* functions
> >>> to support future mTHP collapse.
> >>>
> >>> mTHP collapse will not honor the khugepaged_max_ptes_shared or
> >>> khugepaged_max_ptes_swap parameters, and will fail if it encounters a
> >>> shared or swapped entry.
> >>>
> >>> No functional changes in this patch.
> >>>
> >>> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> >>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> >>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> >>> Co-developed-by: Dev Jain <dev.jain@arm.com>
> >>> Signed-off-by: Dev Jain <dev.jain@arm.com>
> >>> Signed-off-by: Nico Pache <npache@redhat.com>
> >>> ---
> >>>  mm/khugepaged.c | 73 +++++++++++++++++++++++++++++++----------------=
--
> >>>  1 file changed, 47 insertions(+), 26 deletions(-)
> >>>
> >>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >>> index a9b645402b7f..ecdbbf6a01a6 100644
> >>> --- a/mm/khugepaged.c
> >>> +++ b/mm/khugepaged.c
> >>> @@ -535,7 +535,7 @@ static void release_pte_pages(pte_t *pte, pte_t *=
_pte,
> >>>
> >>>  static enum scan_result __collapse_huge_page_isolate(struct vm_area_=
struct *vma,
> >>>             unsigned long start_addr, pte_t *pte, struct collapse_con=
trol *cc,
> >>> -           struct list_head *compound_pagelist)
> >>> +           unsigned int order, struct list_head *compound_pagelist)
> >>>  {
> >>>     struct page *page =3D NULL;
> >>>     struct folio *folio =3D NULL;
> >>> @@ -543,15 +543,17 @@ static enum scan_result __collapse_huge_page_is=
olate(struct vm_area_struct *vma,
> >>>     pte_t *_pte;
> >>>     int none_or_zero =3D 0, shared =3D 0, referenced =3D 0;
> >>>     enum scan_result result =3D SCAN_FAIL;
> >>> +   const unsigned long nr_pages =3D 1UL << order;
> >>> +   int max_ptes_none =3D khugepaged_max_ptes_none >> (HPAGE_PMD_ORDE=
R - order);
> >>
> >> It might be a bit more readable to move "const unsigned long
> >> nr_pages =3D 1UL << order;" all the way to the top.
> >>
> >> Then, have here
> >>
> >>      int max_ptes_none =3D 0;
> >>
> >> and do at the beginning of the function:
> >>
> >>      /* For MADV_COLLAPSE, we always collapse ... */
> >>      if (!cc->is_khugepaged)
> >>              max_ptes_none =3D HPAGE_PMD_NR;
> >>      /*  ... except if userfaultf relies on MISSING faults. */
> >>      if (!userfaultfd_armed(vma))
> >>              max_ptes_none =3D khugepaged_max_ptes_none >> (HPAGE_PMD_=
ORDER - order);
> >>
> >> (but see below regarding helper function)
> >>
> >> then the code below becomes ...
> >>
> >>>
> >>> -   for (_pte =3D pte; _pte < pte + HPAGE_PMD_NR;
> >>> +   for (_pte =3D pte; _pte < pte + nr_pages;
> >>>          _pte++, addr +=3D PAGE_SIZE) {
> >>>             pte_t pteval =3D ptep_get(_pte);
> >>>             if (pte_none_or_zero(pteval)) {
> >>>                     ++none_or_zero;
> >>>                     if (!userfaultfd_armed(vma) &&
> >>>                         (!cc->is_khugepaged ||
> >>> -                        none_or_zero <=3D khugepaged_max_ptes_none))=
 {
> >>> +                        none_or_zero <=3D max_ptes_none)) {
> >>
> >> ...
> >>
> >>      if (none_or_zero <=3D max_ptes_none) {
> >>
> >>
> >> I see that you do something like that (but slightly different) in the =
next
> >> patch. You could easily extend the above by it.
> >>
> >> Or go one step further and move all of that conditional into collapse_=
max_ptes_none(), whereby
> >> you simply also pass the cc and the vma.
> >>
> >> Then this all gets cleaned up and you'd end up above with
> >>
> >> max_ptes_none =3D collapse_max_ptes_none(cc, vma, order);
> >> if (max_ptes_none < 0)
> >>      return result;
> >>
> >> I'd do all that in this patch here, getting rid of #4.
> >>
> >>
> >>>                             continue;
> >>>                     } else {
> >>>                             result =3D SCAN_EXCEED_NONE_PTE;
> >>> @@ -585,8 +587,14 @@ static enum scan_result __collapse_huge_page_iso=
late(struct vm_area_struct *vma,
> >>>             /* See collapse_scan_pmd(). */
> >>>             if (folio_maybe_mapped_shared(folio)) {
> >>>                     ++shared;
> >>> -                   if (cc->is_khugepaged &&
> >>> -                       shared > khugepaged_max_ptes_shared) {
> >>> +                   /*
> >>> +                    * TODO: Support shared pages without leading to =
further
> >>> +                    * mTHP collapses. Currently bringing in new page=
s via
> >>> +                    * shared may cause a future higher order collaps=
e on a
> >>> +                    * rescan of the same range.
> >>> +                    */
> >>> +                   if (!is_pmd_order(order) || (cc->is_khugepaged &&
> >>> +                       shared > khugepaged_max_ptes_shared)) {
> >>
> >> That's not how we indent within a nested ().
> >>
> >> To make this easier to read, what about similarly having at the beginn=
ing
> >> of the function:
> >>
> >> int max_ptes_shared =3D 0;
> >>
> >> /* For MADV_COLLAPSE, we always collapse. */
> >> if (cc->is_khugepaged)
> >>      max_ptes_none =3D HPAGE_PMD_NR;
> >> /* TODO ... */
> >> if (is_pmd_order(order))
> >>      max_ptes_none =3D khugepaged_max_ptes_shared;
> >>
> >> to turn this code into a
> >>
> >>      if (shared > khugepaged_max_ptes_shared)
> >>
> >> Also, here, might make sense to have a collapse_max_ptes_swap(cc, orde=
r)
> >> to do that and clean it up.
> >>
> >>
> >>>                             result =3D SCAN_EXCEED_SHARED_PTE;
> >>>                             count_vm_event(THP_SCAN_EXCEED_SHARED_PTE=
);
> >>>                             goto out;
> >>> @@ -679,18 +687,18 @@ static enum scan_result __collapse_huge_page_is=
olate(struct vm_area_struct *vma,
> >>>  }
> >>>
> >>>  static void __collapse_huge_page_copy_succeeded(pte_t *pte,
> >>> -                                           struct vm_area_struct *vm=
a,
> >>> -                                           unsigned long address,
> >>> -                                           spinlock_t *ptl,
> >>> -                                           struct list_head *compoun=
d_pagelist)
> >>> +           struct vm_area_struct *vma, unsigned long address,
> >>> +           spinlock_t *ptl, unsigned int order,
> >>> +           struct list_head *compound_pagelist)
> >>>  {
> >>> -   unsigned long end =3D address + HPAGE_PMD_SIZE;
> >>> +   unsigned long end =3D address + (PAGE_SIZE << order);
> >>>     struct folio *src, *tmp;
> >>>     pte_t pteval;
> >>>     pte_t *_pte;
> >>>     unsigned int nr_ptes;
> >>> +   const unsigned long nr_pages =3D 1UL << order;
> >>
> >> Move it further to the top.
> >>
> >>>
> >>> -   for (_pte =3D pte; _pte < pte + HPAGE_PMD_NR; _pte +=3D nr_ptes,
> >>> +   for (_pte =3D pte; _pte < pte + nr_pages; _pte +=3D nr_ptes,
> >>>          address +=3D nr_ptes * PAGE_SIZE) {
> >>>             nr_ptes =3D 1;
> >>>             pteval =3D ptep_get(_pte);
> >>> @@ -743,13 +751,11 @@ static void __collapse_huge_page_copy_succeeded=
(pte_t *pte,
> >>>  }
> >>>
> >>>  static void __collapse_huge_page_copy_failed(pte_t *pte,
> >>> -                                        pmd_t *pmd,
> >>> -                                        pmd_t orig_pmd,
> >>> -                                        struct vm_area_struct *vma,
> >>> -                                        struct list_head *compound_p=
agelist)
> >>> +           pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
> >>> +           unsigned int order, struct list_head *compound_pagelist)
> >>>  {
> >>>     spinlock_t *pmd_ptl;
> >>> -
> >>> +   const unsigned long nr_pages =3D 1UL << order;
> >>>     /*
> >>>      * Re-establish the PMD to point to the original page table
> >>>      * entry. Restoring PMD needs to be done prior to releasing
> >>> @@ -763,7 +769,7 @@ static void __collapse_huge_page_copy_failed(pte_=
t *pte,
> >>>      * Release both raw and compound pages isolated
> >>>      * in __collapse_huge_page_isolate.
> >>>      */
> >>> -   release_pte_pages(pte, pte + HPAGE_PMD_NR, compound_pagelist);
> >>> +   release_pte_pages(pte, pte + nr_pages, compound_pagelist);
> >>>  }
> >>>
> >>>  /*
> >>> @@ -783,16 +789,16 @@ static void __collapse_huge_page_copy_failed(pt=
e_t *pte,
> >>>   */
> >>>  static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct=
 folio *folio,
> >>>             pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
> >>> -           unsigned long address, spinlock_t *ptl,
> >>> +           unsigned long address, spinlock_t *ptl, unsigned int orde=
r,
> >>>             struct list_head *compound_pagelist)
> >>>  {
> >>>     unsigned int i;
> >>>     enum scan_result result =3D SCAN_SUCCEED;
> >>> -
> >>> +   const unsigned long nr_pages =3D 1UL << order;
> >>
> >> Same here, all the way to the top.
> >>
> >>>     /*
> >>>      * Copying pages' contents is subject to memory poison at any ite=
ration.
> >>>      */
> >>> -   for (i =3D 0; i < HPAGE_PMD_NR; i++) {
> >>> +   for (i =3D 0; i < nr_pages; i++) {
> >>>             pte_t pteval =3D ptep_get(pte + i);
> >>>             struct page *page =3D folio_page(folio, i);
> >>>             unsigned long src_addr =3D address + i * PAGE_SIZE;
> >>> @@ -811,10 +817,10 @@ static enum scan_result __collapse_huge_page_co=
py(pte_t *pte, struct folio *foli
> >>>
> >>>     if (likely(result =3D=3D SCAN_SUCCEED))
> >>>             __collapse_huge_page_copy_succeeded(pte, vma, address, pt=
l,
> >>> -                                               compound_pagelist);
> >>> +                                               order, compound_pagel=
ist);
> >>>     else
> >>>             __collapse_huge_page_copy_failed(pte, pmd, orig_pmd, vma,
> >>> -                                            compound_pagelist);
> >>> +                                            order, compound_pagelist=
);
> >>>
> >>>     return result;
> >>>  }
> >>> @@ -985,12 +991,12 @@ static enum scan_result check_pmd_still_valid(s=
truct mm_struct *mm,
> >>>   * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
> >>>   */
> >>>  static enum scan_result __collapse_huge_page_swapin(struct mm_struct=
 *mm,
> >>> -           struct vm_area_struct *vma, unsigned long start_addr, pmd=
_t *pmd,
> >>> -           int referenced)
> >>> +           struct vm_area_struct *vma, unsigned long start_addr,
> >>> +           pmd_t *pmd, int referenced, unsigned int order)
> >>>  {
> >>>     int swapped_in =3D 0;
> >>>     vm_fault_t ret =3D 0;
> >>> -   unsigned long addr, end =3D start_addr + (HPAGE_PMD_NR * PAGE_SIZ=
E);
> >>> +   unsigned long addr, end =3D start_addr + (PAGE_SIZE << order);
> >>>     enum scan_result result;
> >>>     pte_t *pte =3D NULL;
> >>>     spinlock_t *ptl;
> >>> @@ -1022,6 +1028,19 @@ static enum scan_result __collapse_huge_page_s=
wapin(struct mm_struct *mm,
> >>>                 pte_present(vmf.orig_pte))
> >>>                     continue;
> >>>
> >>> +           /*
> >>> +            * TODO: Support swapin without leading to further mTHP
> >>> +            * collapses. Currently bringing in new pages via swapin =
may
> >>> +            * cause a future higher order collapse on a rescan of th=
e same
> >>> +            * range.
> >>> +            */
> >>> +           if (!is_pmd_order(order)) {
> >>> +                   pte_unmap(pte);
> >>> +                   mmap_read_unlock(mm);
> >>> +                   result =3D SCAN_EXCEED_SWAP_PTE;
> >>> +                   goto out;
> >>> +           }
> >>> +
> >>
> >> Interesting, we just swapin everything we find :)
> >>
> >> But do we really need this check here? I mean, we just found it to be =
present.
> >>
> >> In the rare event that there was a race, do we really care? It was jus=
t
> >> present, now it's swapped. Bad luck. Just swap it in.
> >>
> >
> > Okay, now I am confused. Why are you not taking care of
> > collapse_scan_pmd() in the same context?
> >
> > Because if you make sure that we properly check against a max_ptes_swap
> > similar as in the style above, we'd rule out swapin right from the star=
t?
> >
> > Also, I would expect that all other parameters in there are similarly
> > handled?
> >
>
> Okay, I think you should add the following:

Hey! Thanks for all your reviews here.

For multiple reasons, here is the solution I developed:

Add a patch before the generalize __collapse.. patch that reworks the
max_ptes* handling and introduces the helpers (no functional changes).

I later updated these functions to follow the specific mthp rules in
the generalization patch. Honestly, refactoring much of this has been
very hard without one large patch, which is why we split it up
initially.

How does that sound?

-- Nico

>
> From 17bce81ab93f3b16e044ac2f4f62be19aac38180 Mon Sep 17 00:00:00 2001
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> Date: Thu, 12 Mar 2026 21:54:22 +0100
> Subject: [PATCH] tmp
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/khugepaged.c | 89 +++++++++++++++++++++++++++++--------------------
>  1 file changed, 53 insertions(+), 36 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b7b4680d27ab..6a3773bfa0a2 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -318,6 +318,34 @@ static ssize_t max_ptes_shared_store(struct kobject =
*kobj,
>         return count;
>  }
>
> +static int collapse_max_ptes_none(struct collapse_control *cc,
> +               struct vm_area_struct *vma)
> +{
> +       /* We don't mess with MISSING faults. */
> +       if (vma && userfaultfd_armed(vma))
> +               return 0;
> +       /* MADV_COLLAPSE always collapses. */
> +       if (!cc->is_khugepaged)
> +               return HPAGE_PMD_NR;
> +       return khugepaged_max_ptes_none;
> +}
> +
> +static int collapse_max_ptes_shared(struct collapse_control *cc)
> +{
> +       /* MADV_COLLAPSE always collapses. */
> +       if (!cc->is_khugepaged)
> +               return HPAGE_PMD_NR;
> +       return khugepaged_max_ptes_shared;
> +}
> +
> +static int collapse_max_ptes_swap(struct collapse_control *cc)
> +{
> +       /* MADV_COLLAPSE always collapses. */
> +       if (!cc->is_khugepaged)
> +               return HPAGE_PMD_NR;
> +       return khugepaged_max_ptes_swap;
> +}
> +
>  static struct kobj_attribute khugepaged_max_ptes_shared_attr =3D
>         __ATTR_RW(max_ptes_shared);
>
> @@ -539,6 +567,8 @@ static enum scan_result __collapse_huge_page_isolate(=
struct vm_area_struct *vma,
>                 unsigned long start_addr, pte_t *pte, struct collapse_con=
trol *cc,
>                 struct list_head *compound_pagelist)
>  {
> +       const int max_ptes_none =3D collapse_max_ptes_none(cc, vma);
> +       const int max_ptes_shared =3D collapse_max_ptes_shared(cc);
>         struct page *page =3D NULL;
>         struct folio *folio =3D NULL;
>         unsigned long addr =3D start_addr;
> @@ -550,16 +580,12 @@ static enum scan_result __collapse_huge_page_isolat=
e(struct vm_area_struct *vma,
>              _pte++, addr +=3D PAGE_SIZE) {
>                 pte_t pteval =3D ptep_get(_pte);
>                 if (pte_none_or_zero(pteval)) {
> -                       ++none_or_zero;
> -                       if (!userfaultfd_armed(vma) &&
> -                           (!cc->is_khugepaged ||
> -                            none_or_zero <=3D khugepaged_max_ptes_none))=
 {
> -                               continue;
> -                       } else {
> +                       if (++none_or_zero > max_ptes_none) {
>                                 result =3D SCAN_EXCEED_NONE_PTE;
>                                 count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>                                 goto out;
>                         }
> +                       continue;
>                 }
>                 if (!pte_present(pteval)) {
>                         result =3D SCAN_PTE_NON_PRESENT;
> @@ -586,9 +612,7 @@ static enum scan_result __collapse_huge_page_isolate(=
struct vm_area_struct *vma,
>
>                 /* See hpage_collapse_scan_pmd(). */
>                 if (folio_maybe_mapped_shared(folio)) {
> -                       ++shared;
> -                       if (cc->is_khugepaged &&
> -                           shared > khugepaged_max_ptes_shared) {
> +                       if (++shared > max_ptes_shared) {
>                                 result =3D SCAN_EXCEED_SHARED_PTE;
>                                 count_vm_event(THP_SCAN_EXCEED_SHARED_PTE=
);
>                                 goto out;
> @@ -1247,6 +1271,9 @@ static enum scan_result hpage_collapse_scan_pmd(str=
uct mm_struct *mm,
>                 struct vm_area_struct *vma, unsigned long start_addr,
>                 bool *mmap_locked, struct collapse_control *cc)
>  {
> +       const int max_ptes_none =3D collapse_max_ptes_none(cc, vma);
> +       const int max_ptes_swap =3D collapse_max_ptes_swap(cc);
> +       const int max_ptes_shared =3D collapse_max_ptes_shared(cc);
>         pmd_t *pmd;
>         pte_t *pte, *_pte;
>         int none_or_zero =3D 0, shared =3D 0, referenced =3D 0;
> @@ -1280,36 +1307,28 @@ static enum scan_result hpage_collapse_scan_pmd(s=
truct mm_struct *mm,
>
>                 pte_t pteval =3D ptep_get(_pte);
>                 if (pte_none_or_zero(pteval)) {
> -                       ++none_or_zero;
> -                       if (!userfaultfd_armed(vma) &&
> -                           (!cc->is_khugepaged ||
> -                            none_or_zero <=3D khugepaged_max_ptes_none))=
 {
> -                               continue;
> -                       } else {
> +                       if (++none_or_zero > max_ptes_none) {
>                                 result =3D SCAN_EXCEED_NONE_PTE;
>                                 count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>                                 goto out_unmap;
>                         }
> +                       continue;
>                 }
>                 if (!pte_present(pteval)) {
> -                       ++unmapped;
> -                       if (!cc->is_khugepaged ||
> -                           unmapped <=3D khugepaged_max_ptes_swap) {
> -                               /*
> -                                * Always be strict with uffd-wp
> -                                * enabled swap entries.  Please see
> -                                * comment below for pte_uffd_wp().
> -                                */
> -                               if (pte_swp_uffd_wp_any(pteval)) {
> -                                       result =3D SCAN_PTE_UFFD_WP;
> -                                       goto out_unmap;
> -                               }
> -                               continue;
> -                       } else {
> +                       if (++unmapped > max_ptes_swap) {
>                                 result =3D SCAN_EXCEED_SWAP_PTE;
>                                 count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
>                                 goto out_unmap;
>                         }
> +                       /*
> +                        * Always be strict with uffd-wp enabled swap ent=
ries.
> +                        * See the comment below for pte_uffd_wp().
> +                        */
> +                       if (pte_swp_uffd_wp_any(pteval)) {
> +                               result =3D SCAN_PTE_UFFD_WP;
> +                               goto out_unmap;
> +                       }
> +                       continue;
>                 }
>                 if (pte_uffd_wp(pteval)) {
>                         /*
> @@ -1348,9 +1367,7 @@ static enum scan_result hpage_collapse_scan_pmd(str=
uct mm_struct *mm,
>                  * is shared.
>                  */
>                 if (folio_maybe_mapped_shared(folio)) {
> -                       ++shared;
> -                       if (cc->is_khugepaged &&
> -                           shared > khugepaged_max_ptes_shared) {
> +                       if (++shared > max_ptes_shared) {
>                                 result =3D SCAN_EXCEED_SHARED_PTE;
>                                 count_vm_event(THP_SCAN_EXCEED_SHARED_PTE=
);
>                                 goto out_unmap;
> @@ -2305,6 +2322,8 @@ static enum scan_result hpage_collapse_scan_file(st=
ruct mm_struct *mm,
>                 unsigned long addr, struct file *file, pgoff_t start,
>                 struct collapse_control *cc)
>  {
> +       const int max_ptes_none =3D collapse_max_ptes_none(cc, NULL);
> +       const int max_ptes_swap =3D collapse_max_ptes_swap(cc);
>         struct folio *folio =3D NULL;
>         struct address_space *mapping =3D file->f_mapping;
>         XA_STATE(xas, &mapping->i_pages, start);
> @@ -2323,8 +2342,7 @@ static enum scan_result hpage_collapse_scan_file(st=
ruct mm_struct *mm,
>
>                 if (xa_is_value(folio)) {
>                         swap +=3D 1 << xas_get_order(&xas);
> -                       if (cc->is_khugepaged &&
> -                           swap > khugepaged_max_ptes_swap) {
> +                       if (swap > max_ptes_swap) {
>                                 result =3D SCAN_EXCEED_SWAP_PTE;
>                                 count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
>                                 break;
> @@ -2395,8 +2413,7 @@ static enum scan_result hpage_collapse_scan_file(st=
ruct mm_struct *mm,
>                 cc->progress +=3D HPAGE_PMD_NR;
>
>         if (result =3D=3D SCAN_SUCCEED) {
> -               if (cc->is_khugepaged &&
> -                   present < HPAGE_PMD_NR - khugepaged_max_ptes_none) {
> +               if (present < HPAGE_PMD_NR - max_ptes_none) {
>                         result =3D SCAN_EXCEED_NONE_PTE;
>                         count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>                 } else {
> --
> 2.43.0
>
>
> Then extend it by passing an order + return value check in this patch her=
e. You can
> directly squash changes from patch #4 in here then.
>
> --
> Cheers,
>
> David
>


