Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45630CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 18:41:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81C536B0088; Mon, 11 May 2026 14:41:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CCA76B008C; Mon, 11 May 2026 14:41:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E30E6B0092; Mon, 11 May 2026 14:41:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5DBB16B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:41:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ECD501A0220
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:41:51 +0000 (UTC)
X-FDA: 84756008022.30.9E59B74
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id C103D80003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:41:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ef6DLXFX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778524909; a=rsa-sha256;
	cv=none;
	b=aSXEqaLttOq29Oc86qqWFKJDSXP6FR4qj+Bl6JaE9u9chQcHDd5+tbovbp3N5eM+EGpZ60
	gFIFhx6Qc7CpKqDZ5DwW0rCXaB7eFOR8hYolP6ip8T/b+GGodqvSEf5AwefUgN2kFoEzg9
	ggXgcJZKyY9++Yi4jR8zlyQCIGeYWMI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ef6DLXFX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778524909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ythXYl/VV6y/4QZ3z6Fr+duBWlyDuGxoU3efni6SJyY=;
	b=aRqMvz5qCcHgxV6wvCYUoOmj76aMMqm599E9uNRuMsrY/Oss12pMYJ3bPyyxrHt73w+8XY
	wGlWpPt1Fr5RUliZDAS7+Ile+xg6wo9Cpx4rCzHkxWgYMwT7MrXhsKWwZQGwk0yoepi+pY
	VXuIdONVOXFPgNqJQeAtpQA7qxErd/s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778524909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ythXYl/VV6y/4QZ3z6Fr+duBWlyDuGxoU3efni6SJyY=;
	b=ef6DLXFXIXPsnkFF/34fuENKyGyXC73jS48XZgiDqDP2RfaUaYgPWUZCdL9pLXx/aW21pw
	lHVQoVO89L7E/R++UzqGkAH450vquP0HVX6m1zyKDGYPKM2RlkymszAUGz2WN2oqPFFjwK
	GHKTlPy3saTdfavRICK8WcImUsFfQP8=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-140-O9kK4uttNo6JUJH8x_Yrsg-1; Mon, 11 May 2026 14:41:48 -0400
X-MC-Unique: O9kK4uttNo6JUJH8x_Yrsg-1
X-Mimecast-MFC-AGG-ID: O9kK4uttNo6JUJH8x_Yrsg_1778524907
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-65d7e8b971dso5950289d50.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 11:41:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778524907; x=1779129707;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ythXYl/VV6y/4QZ3z6Fr+duBWlyDuGxoU3efni6SJyY=;
        b=NnXS3odsollFgly9QLp5XoORmO3+9lyIA3b/pqL3D6TVI6+u9YHxAFBb7slnhJUoAH
         kvaImW6HuJb7KkJvG7YNDSCwzCOtQIYRrvTO1eH7DHHTY8uaU4SpR0a3ZvQ/dgUUYlpa
         80DesSfHlQ0Oey4E4D5po1IfbxzLsoIEJetoU/1tvhMPLFZf2DlPpUl1bNcU9BGc446K
         lE7Cxb52KhOqIgc1KzdLw8dax964OOE4DSY0l8NASqQwNiZ3OZXlj+94+m6tbborJBhp
         v2SXAYpxM0EVis++ryjTWLkhYLd5Be32RkzThJu6KanNGHzvZn1o2bHOMI02hiKbiIlm
         rcQw==
X-Gm-Message-State: AOJu0YxL8x1FIKoTshns1sMScwpkRIYGIvycSFN+vooaOASw3Dg2DCSh
	Ezp/v3JgM3r0nW8kZtT13BOxEoNRwODTww7cXtmG+xldCevJNaUpCQ7dG/J7cY2tL5hBVr+W6p7
	bsdgMN16HUVyaAi8I4RytlGCmmaV4tPTpPBpuknDHzD9qf1PdaEUKXSh+VqjhA7Ymr2MnHoSyeu
	3w/CZtXtxx1ITZlEqGqIaCFBEC7hQ=
X-Gm-Gg: Acq92OEAnjrkVJJMYQf66RDomaIKiqVfBALddWUWMa39aIQ8MX6n939swVDizzxU/W7
	Zk/XZOpEJ4mZjsr1iByEOsgZawrGlbxgqyvMVm44AWJtHW40/BRcDOj3pqs3ipiEjQa7EaIIeha
	21ME4V7XDNt6zlLTCbUBcNUdQFes7iYidSP8RUZcDMF1XPpBplhkNOyiloaX08sI4i3DOPYJPaT
	730
X-Received: by 2002:a05:690e:1c20:b0:65c:6ffb:303d with SMTP id 956f58d0204a3-65da855d38emr9879108d50.62.1778524907304;
        Mon, 11 May 2026 11:41:47 -0700 (PDT)
X-Received: by 2002:a05:690e:1c20:b0:65c:6ffb:303d with SMTP id
 956f58d0204a3-65da855d38emr9879066d50.62.1778524906658; Mon, 11 May 2026
 11:41:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260508170509.640851-1-npache@redhat.com> <20260509032157.61333-1-lance.yang@linux.dev>
In-Reply-To: <20260509032157.61333-1-lance.yang@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Mon, 11 May 2026 12:42:04 -0600
X-Gm-Features: AVHnY4KzuJ9xsKi2sqEIKx5NXxXPZgfbRxwWfHOj4LFys3Ualvbo2wRzFHPrpeI
Message-ID: <CAA1CXcB-HekhOXvyw-BKrQzXpqZLRhmhnQNSQHSRUd6WQnv8bg@mail.gmail.com>
Subject: Re: [RFC] mm: restrict zero-page remapping to underused THP splits
To: Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, yuzhao@google.com, 
	usamaarif642@gmail.com, baohua@kernel.org, dev.jain@arm.com, 
	ryan.roberts@arm.com, liam@infradead.org, baolin.wang@linux.alibaba.com, 
	ziy@nvidia.com, ljs@kernel.org, david@kernel.org, akpm@linux-foundation.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PIVrRXw1joG3M3PpmDihW1CYfblCFRd4oGTavSuQMmQ_1778524907
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dufa56exnbep49phydqayp4hb8udnxtk
X-Rspam-User: 
X-Rspamd-Queue-Id: C103D80003
X-Rspamd-Server: rspam07
X-HE-Tag: 1778524909-703038
X-HE-Meta: U2FsdGVkX1+8XCyARtLePviYXVn5Fj/qC/zJtYx+3snqpfiv4usII3Far04IpoZ4F1qFlcg83tbDkF2ipzaC5USeU76y/yXocWjAOkPsc3cAhvWLdewhUaXQuh8jy3oaYVN2E8MMfYKb2emNO8NUB2xYfBsTkzBTSlh+JjTBKmfVbRDBt75FJ17TVj7TDW2cmPjykhk5Dc1AZ58rrXqpk1Wc45DopSD3vEZOOPinIpbcF+WSvwmxhGGo4tbZ484Y/FpgbGpEJ56xKuTHEdzqQDiJcuuh9OuafpVtswM+Ya0x4aYqtMW8y0NHANvH6XUKnAiw0o23O8ybGjvkT3g22kXiRdO7bZ4Ft4xkGW56CKAbkP/qD92qHa0Jo+3vNtFe/jwXY5c8zbfDb3vARkT0TOoJwF4u7LfagAtDVNQ+KyhybCotjY6kNlN33jKHL2R2c75FZASR0xqGUueiCE6PTRxLD/DA4E49RQm71R/gqDxwSbf4UJDOrwdN2ctA9BQ0WA7KO0BBOPFwzeGZAzSveugY6PNfC7FVcHGmM0w2wvgRuZjN9hzGmxdMJG7nzbXU4k1aQkyYBknWffiHx3cPDykheUEgl1ckzCAHDNblA06j2fwqkKT3ApC7x1W8oCrp8JDrv7aGEVuI61XVIqKXH4CxrxMOGh3f/Y55fIKOuJ2u65C+NkQgOI8gK2Sg3GZ/538zOYdc8ywPKXy0h6wpMZap/jIGyG2H4TWNxoqVVh4Rfe+X8vPzq/Z98R//bS3Pvlwg3LkXVZTLtetg/7c2lBtx6LtiIh8wMp3/rOC579gSRcfj2YW2543ZD3prRqnigRxwtgMi8ac2bCxyNN8zmjxMa0FGcgXVCrvpm1ZU3tbWAm7/wTmMLlVrVSHVitRzD6T9TPH0Kvx6yd6bYW7Rz53IEysyAgg/5aDjAMuDPOQ8IZNfEzjLv3OM7mmool4ABXVH2uBtavlkGc7KgRx
 MK4gU3X+
 8GTg36QAZVB7UeacojdDEeGNjLLppAZV6c804tkIGai4/K3Z2L2S99XmdW40E6shQGvZOxLe8I2y/WEQlXrTsf8D3txYz2o+Yn6inp9oTZfCyAo6MOSPgXJIC/unY+UzskNH9j5yNuYdtWVEVHf2VuUsE+WHJwv9Mc9yhYVeYoQkCQ6Hb/EBSeFgfe3aT1/3K3/KWR2QPgoVL6FnaTTmmpsjmta5Uzy+6GdZXlA/zmA5wCBbvxjI+ViL1epRwzgqoxHc7HrfOUgeKpzFVZLoz5fq8RVa7HuKbPI8XYiaUVgvBLHH6NAlZ7eJ5199E5nppfEfJ06k2nLVMkXk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 8, 2026 at 9:22=E2=80=AFPM Lance Yang <lance.yang@linux.dev> wr=
ote:
>
>
> On Fri, May 08, 2026 at 11:05:09AM -0600, Nico Pache wrote:
> >Since commit b1f202060afe ("mm: remap unused subpages to shared zeropage
> >when splitting isolated thp"), splitting an anonymous THP remaps all
> >zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPAGE.
> >This flag is set unconditionally for every anonymous folio split,
> >including splits triggered by KSM.
> >
> >When KSM is enabled with THP=3Dalways, this causes two regressions:
> >
> >1. use_zero_pages=3D1: KSM calls try_to_merge_one_page() which triggers
> >   split_huge_page(). The split remaps all 512 zero-filled subpages to
> >   the shared zeropage at once, freeing the entire 2MB THP when KSM only
> >   intended to process a single 4KB page. This bypasses KSM's
> >   pages_to_scan rate limiting, causing ~1GB to be freed almost
> >   instantly.
> >
> >2. use_zero_pages=3D0: The same split side-effect occurs through the
> >   stable/unstable tree merge paths. Each pages_to_scan iteration
> >   triggers an expensive split_huge_page() that silently frees 2MB,
> >   while the scanner wastes cycles on tree searches for zero-filled
> >   pages that were already freed as a side-effect.
> >
> >Fix this by restricting TTU_USE_SHARED_ZEROPAGE to only the deferred
> >split shrinker path (deferred_split_scan), which is the only caller that
> >intentionally splits underused THPs to reclaim zero-filled subpages.
> >Introduce folio_split_underused() as a dedicated entry point that
> >passes is_underused_thp=3Dtrue through __folio_split(), and use it from
> >deferred_split_scan(). All other split callers (KSM, compaction, etc.)
> >no longer get the zero-page remapping side-effect.
> >
> >Reviewers notes: this patch is one of two potential approaches. This pat=
ch
> >turns off the zero-page freeing that has been done since the noted commi=
t,
> >in all the other callers, only leaving the underused shrinker to do such
> >behavior. We can also take the opposite approach of with something like
> >split_huge_page_no_zeropage() and call this within KSM.
> >
> >Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when =
splitting isolated thp")
> >Signed-off-by: Nico Pache <npache@redhat.com>
> >---
> > include/linux/huge_mm.h |  2 +-
> > mm/huge_memory.c        | 17 ++++++++++++-----
> > 2 files changed, 13 insertions(+), 6 deletions(-)
> >
> >diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> >index 2949e5acff35..4ae1b52d7411 100644
> >--- a/include/linux/huge_mm.h
> >+++ b/include/linux/huge_mm.h
> >@@ -378,7 +378,7 @@ int folio_check_splittable(struct folio *folio, unsi=
gned int new_order,
> >                          enum split_type split_type);
> > int folio_split(struct folio *folio, unsigned int new_order, struct pag=
e *page,
> >               struct list_head *list);
> >-
> >+int folio_split_underused(struct folio *folio);
> > static inline int split_huge_page_to_list_to_order(struct page *page, s=
truct list_head *list,
> >               unsigned int new_order)
> > {
> >diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >index 970e077019b7..91f7fad72c8a 100644
> >--- a/mm/huge_memory.c
> >+++ b/mm/huge_memory.c
> >@@ -4045,7 +4045,8 @@ static int __folio_freeze_and_split_unmapped(struc=
t folio *folio, unsigned int n
> >  */
> > static int __folio_split(struct folio *folio, unsigned int new_order,
> >               struct page *split_at, struct page *lock_at,
> >-              struct list_head *list, enum split_type split_type)
> >+              struct list_head *list, enum split_type split_type,
> >+              bool is_underused_thp)
> > {
> >       XA_STATE(xas, &folio->mapping->i_pages, folio->index);
> >       struct folio *end_folio =3D folio_next(folio);
> >@@ -4174,7 +4175,7 @@ static int __folio_split(struct folio *folio, unsi=
gned int new_order,
> >       if (nr_shmem_dropped)
> >               shmem_uncharge(mapping->host, nr_shmem_dropped);
> >
> >-      if (!ret && is_anon && !folio_is_device_private(folio))
> >+      if (!ret && is_anon && !folio_is_device_private(folio) && is_unde=
rused_thp)
> >               ttu_flags =3D TTU_USE_SHARED_ZEROPAGE;
> >
> >       remap_page(folio, 1 << old_order, ttu_flags);
> >@@ -4309,7 +4310,7 @@ int __split_huge_page_to_list_to_order(struct page=
 *page, struct list_head *list
> >       struct folio *folio =3D page_folio(page);
> >
> >       return __folio_split(folio, new_order, &folio->page, page, list,
> >-                           SPLIT_TYPE_UNIFORM);
> >+                           SPLIT_TYPE_UNIFORM, false);
> > }
> >
> > /**
> >@@ -4340,7 +4341,13 @@ int folio_split(struct folio *folio, unsigned int=
 new_order,
> >               struct page *split_at, struct list_head *list)
> > {
> >       return __folio_split(folio, new_order, split_at, &folio->page, li=
st,
> >-                           SPLIT_TYPE_NON_UNIFORM);
> >+                           SPLIT_TYPE_NON_UNIFORM, false);
> >+}
> >+
> >+int folio_split_underused(struct folio *folio)
> >+{
> >+      return __folio_split(folio, 0, &folio->page, &folio->page,
> >+                           NULL, SPLIT_TYPE_NON_UNIFORM, true);
>
> IIUC, it should be SPLIT_TYPE_UNIFORM, not SPLIT_TYPE_NON_UNIFORM ...

Thats what i had originally then convinced myself otherwise. Ill
reverify before submitting again. Unless we just end up on a different
solution like David suggested.

Thanks!
-- Nico

>
> deferred_split_scan() used split_folio(), so for the underused case it
> split the whole THP uniformly down to order-0 pages. The shared zeropage
> remapping happens later, via remove_migration_ptes(), after the split.
>
> With SPLIT_TYPE_NON_UNIFORM and split_at =3D=3D &folio->page, most of an
> order-9 THP can stays as larger folios.
>
> Then try_to_map_unused_to_zeropage() rejects those folios:
>
>         if (PageCompound(page) || PageHWPoison(page))
>                 return false;
>
> So the underused shrinker would no longer remap/free many zero-filled
> subpages ...
>
> > }
> >
> > /**
> >@@ -4559,7 +4566,7 @@ static unsigned long deferred_split_scan(struct sh=
rinker *shrink,
> >               }
> >               if (!folio_trylock(folio))
> >                       goto requeue;
> >-              if (!split_folio(folio)) {
> >+              if (!folio_split_underused(folio)) {
> >                       did_split =3D true;
> >                       if (underused)
> >                               count_vm_event(THP_UNDERUSED_SPLIT_PAGE);
> >--
> >2.54.0
> >
> >
>


