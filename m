Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C679CCD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 11:25:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39F716B009B; Mon,  8 Jun 2026 07:25:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3505E6B009E; Mon,  8 Jun 2026 07:25:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23ECD6B009F; Mon,  8 Jun 2026 07:25:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1639B6B009B
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:25:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B9969C340F
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:25:26 +0000 (UTC)
X-FDA: 84856514652.09.4597111
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7991020010
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:25:24 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fE4DBX64;
	spf=pass (imf31.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780917924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xurYlXvWLJ9GjSBtu9rVSl+ehqIUCbcLF6nAPKhBUtQ=;
	b=XnaDz8f90x+KEoGL95efWzkDHyH5ORY0IpkV376T4jQq8Pu3sPrTYIikmG8AMzzksmQivL
	XMFmE+us1ocq96Nu1MIuzbHOseamaNKRyzgP9VmbCsxyq1qSCq+tC6SY/zXz+trDTufpQ9
	lhtWsvZ230ty4y0Uo1/lif3cj+M8sr8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780917924;
	b=ZgaLw6R9wNcJkV0ijCNz8s6A10aiAGBCQT0/YuE8Z75rOPzbO7L4KmiVOBKDMzCQ0ZD2qC
	vVS9qhMdTLOvxtJuJHYshwjE7XjpvwdNMHijt3gdMqb4Usi5+4lYx+aicmag5wd73lFOhZ
	O6SqRlQJYkaZsqHcpotFb26BILSNMK0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fE4DBX64;
	spf=pass (imf31.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780917923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xurYlXvWLJ9GjSBtu9rVSl+ehqIUCbcLF6nAPKhBUtQ=;
	b=fE4DBX641qqWFn1uzlkm+uZDboX6v6rlncB/dtOviY7uvvAyy0FvxfUvEe7Rd5S5G3RjI3
	eNA/uQAmtbrRl6Cv//ea6S2OORz4WY4VhxyJvQqWslUHgxHcdEa1BKVtd2ye5Gn4RACv4a
	RPsUG4qmEyyF/zUuKq4BlwHGikCvqHI=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-438-IQKiR4n2MG-o510Su5F9BA-1; Mon, 08 Jun 2026 07:25:22 -0400
X-MC-Unique: IQKiR4n2MG-o510Su5F9BA-1
X-Mimecast-MFC-AGG-ID: IQKiR4n2MG-o510Su5F9BA_1780917922
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-660d7828a5bso8395447d50.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 04:25:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780917922; x=1781522722;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xurYlXvWLJ9GjSBtu9rVSl+ehqIUCbcLF6nAPKhBUtQ=;
        b=Sr9ORl7d2gWw24EecIxwapj2LsDsI4JFwmvw16hLPxNDMELiNO7XYY4IMfjFcTdCKc
         gSMzOQk3RUwqDTElyu3/GAHXXSJVWq2AkDFDzRYA/MhyE5Ay1DeqL0FHk4JGA7dQbV4o
         +0K3vn4cklsUxoFfXOBMcoAlNhyEXcthSXimQExjGxaEU16yG+NqU87u1flGsThzMCBj
         HYREpWoOAEkrb3ZLpnhFLuzeH3T/o+ld1/fLya9XpyG4ZPDFogH0qkKdgkoQmvoTqTsh
         NrbkZsfDTXasCtS7H0fp51KiX3hyR3Nc4t8Iv45Kfr+jYI2zcZcBIbPFep+McWGkW2uX
         cYsg==
X-Gm-Message-State: AOJu0YzJQOcRts/Uv/JeJnU2HNm8COzoN5j0WLD8AkqGqQ7igWLKUORw
	woKyPr7kkOwyTaN6A9HaoW3egQ44gl3MsB1f7oo6U2/kY7Yo4JTXbU3W3hbopJgXDpYce9Z/53y
	bBgjKvMxDbJPKM3f9UpfdN8wSr/mQwN73CX8SS5CK/NKHgQhzhfWK8Gh0v3H1M8WndXEa948Aci
	HSTJhwcsRcZX+yYWB7lYudYVRGjY8=
X-Gm-Gg: Acq92OET5e6cMz6ie7fE6bmIaKrnqK2xl+L65BQdpOTfjMxgTsv/czg9KHfBEcapf+T
	6Y7v6KZeNyQXDeXPcO5P0VXrwQlwJqfHCSZfgHdfNztg2hJRG9sPpOLwCAihnXliBBj4KZB213M
	vFtzvWZbTSa79QPtdHbicv6Xmfnt/D4pAlG09o2qP/66EIW/69fOcxd1JTjp3dyheE9+KLmRtBh
	ADbjs1fel6ER/8=
X-Received: by 2002:a05:690e:43d4:b0:65e:3d3a:de1f with SMTP id 956f58d0204a3-6610a792a7dmr6176195d50.26.1780917922233;
        Mon, 08 Jun 2026 04:25:22 -0700 (PDT)
X-Received: by 2002:a05:690e:43d4:b0:65e:3d3a:de1f with SMTP id
 956f58d0204a3-6610a792a7dmr6176183d50.26.1780917921716; Mon, 08 Jun 2026
 04:25:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260508170509.640851-1-npache@redhat.com> <04ea0e68-de56-49c4-8c9f-1734139d5e7f@kernel.org>
 <CAA1CXcCj7gbcdcuFQ2Zg3fTxys8NRteh4XH36pwQ5=BX6uUasA@mail.gmail.com> <377d571d-0c41-4d08-90a8-d198e1658358@kernel.org>
In-Reply-To: <377d571d-0c41-4d08-90a8-d198e1658358@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Mon, 8 Jun 2026 05:26:07 -0600
X-Gm-Features: AVVi8CcBC5N2PmDv3Wx-YkIyCo8KXcACc0NWIuV1m0CyEszunc5giQd0z6EKlFs
Message-ID: <CAA1CXcAYyZ1eBzyR56nmF1KUyXOHvQyDEMY0P5pw7pW-SB_erQ@mail.gmail.com>
Subject: Re: [RFC] mm: restrict zero-page remapping to underused THP splits
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, yuzhao@google.com, 
	usamaarif642@gmail.com, lance.yang@linux.dev, baohua@kernel.org, 
	dev.jain@arm.com, ryan.roberts@arm.com, liam@infradead.org, 
	baolin.wang@linux.alibaba.com, ziy@nvidia.com, ljs@kernel.org, 
	akpm@linux-foundation.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0RXcZiTTzr3U-HvlbBJHFr0TQPhsYdLexunn8ScACV4_1780917922
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7991020010
X-Stat-Signature: kb6fkcymb88q4748rn8pgcudoraid48i
X-HE-Tag: 1780917924-835712
X-HE-Meta: U2FsdGVkX1/dR2bPpXF42IBDylF/FWvGA+4kYiiv6dX8EiOz7aVRv6ld3yV+nMKzbZzYOgcdWkN/R4YqgjqPgM/1RO5Zl7i/yP+Z39CYN+ejddrxecAnh37GJfiRKTFOIWZWd95s4EkKUuYRSSdm4OkGcYClZJkoi6rPFJsE3CvufK4NX4g0bsPMzF0lRdeoUCuqEhyNK6+RQ4n3WUnrnIKmXL21f1RzHl80SRl1V1FL+34VQoHzjKiIxN1CzmHUYtEmqwQ8JXRrPKepdxq/xvIpTyi+c8oTAU3O11Svc/m37WhPgecOpzgQ1w4dwgN1KhcoIbi0HGQpUdjPooM0uV/zZMmp5wlnQeTcjanhMXdoVMKJUJmr5g6uTXlUTNtZFR5Ot0pqxLvXHNnPL+oYSbyqYw2lG4Sddl0AWiVU6ELhoB0n9dG+cb7RIxb8NA7dLJli/he9T6WdBsU9zVR9RWgk07gjO47JA//pvq6T1ZUx8Ge+ewNQgoRdrQb8gugaGGmz8gR2hshM+h+VR8yITk32KFykWFBQ30obzWh+thaLogJojfz6TbyXmxeN2zpyLOZZzdvImR+34IEt9QLGgRHf5K72900K0iwCBqNAawYehHF7Xl8hSsBq5upsfKO2t8gR9zp6otBGMQV5iRP6yP1Pa9X/NWDzfmnPFkMxTXU5na686KnOd4TUs7aK0o8F42d3fR+O2W3AkenePq5fqD88zwQa88/L7zf+iTFFRG2mGjJZ1IPNxI4XDX1Ps4nsd3z4fiuyHVqTpyumYJntKGvfSyvPiP26joMv0f2J+l7Z3R6XGKTDWSI8cERD7ZeF+F/jTXGbOq+T8UvMDBmnCKt3A4XZQqcAN6/JqCdOiDrpvAIByeu7IDp1w3SxEQl/7DrLmDZyn4DWfgtoJ1+QzvZ6FSEI2NdCzS51N8cCju63R1Y/GjINaJEv35Zadek9qdB8WS5dP15oOGdGpBW
 p1zwt82B
 +xnAAGvx/V/IoX3WSl0szmX3Y7jRUOaBl0wNrKwPX7e7YeowmlJ86UxaRCkMcu9L+2OjlpBtv3rWZlCdRC3SyLsi3v2XocjE1PUaXJ7tPBPq/HCHpYKhzzR4nyV1COmi5JfmcsnJNbvojNjhWe+XkFzDJTo3ZoSpXhKQ2EHt7fkF/REPUcBq/kcL3xJjHmz6LNA7A/J4DraHAYFgH24jt+dwgxOf4PjyWovxK1J6yJhfG5I/VIBvnZ4vjpAetug10N+JxqFJYWqfF6RCs2pvGpFqGFmWhBdvH9jz1TRdbtfc16QndNqk7gXKgx/WgxAViBnyHNU45g9W61UY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 8, 2026 at 5:14=E2=80=AFAM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 6/8/26 12:34, Nico Pache wrote:
> > On Fri, May 8, 2026 at 3:32=E2=80=AFPM David Hildenbrand (Arm) <david@k=
ernel.org> wrote:
> >>
> >> On 5/8/26 19:05, Nico Pache wrote:
> >>> Since commit b1f202060afe ("mm: remap unused subpages to shared zerop=
age
> >>> when splitting isolated thp"), splitting an anonymous THP remaps all
> >>> zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPA=
GE.
> >>> This flag is set unconditionally for every anonymous folio split,
> >>> including splits triggered by KSM.
> >>
> >> And even when the underused scanner is effectively disabled on a syste=
m. Hm.
> >>
> >> I don't quite like that we scan for zeropages when nobody even request=
ed us to
> >> split because of zeropages.
> >>
> >> I can see why we would want to scan for zeropages in a setup where the=
 underused
> >> scanner is active, even when the split was triggered by someone/someth=
ing else
> >> (below).
> >>
> >> [...]
> >>
> >>>  /**
> >>> @@ -4340,7 +4341,13 @@ int folio_split(struct folio *folio, unsigned =
int new_order,
> >>>               struct page *split_at, struct list_head *list)
> >>>  {
> >>>       return __folio_split(folio, new_order, split_at, &folio->page, =
list,
> >>> -                          SPLIT_TYPE_NON_UNIFORM);
> >>> +                          SPLIT_TYPE_NON_UNIFORM, false);
> >>> +}
> >>> +
> >>> +int folio_split_underused(struct folio *folio)
> >>> +{
> >>> +     return __folio_split(folio, 0, &folio->page, &folio->page,
> >>> +                          NULL, SPLIT_TYPE_NON_UNIFORM, true);
> >>>  }
> >>>
> >>>  /**
> >>> @@ -4559,7 +4566,7 @@ static unsigned long deferred_split_scan(struct=
 shrinker *shrink,
> >>>               }
> >>>               if (!folio_trylock(folio))
> >>>                       goto requeue;
> >>> -             if (!split_folio(folio)) {
> >>> +             if (!folio_split_underused(folio)) {
> >>>                       did_split =3D true;
> >>>                       if (underused)
> >>>                               count_vm_event(THP_UNDERUSED_SPLIT_PAGE=
);
> >>
> >> In general, this looks clean.
> >>
> >> But imagine the following: someone splits the THP for another reason: =
for
> >> example, because migration is unable to allocate a 2M THP, or because =
we have to
> >> split on swapout etc.
> >>
> >> Not freeing the zero-filled pages means that these pages cannot be rec=
laimed
> >> anymore easily. We split a possibly underused THP but didn't free the =
memory.
> >>
> >> The only way to free the memory would be to wait for another collapse,=
 and then
> >> have the new THP be detected as underused.
> >>
> >> Hm.
> >>
> >> (1) As you say, the alternative is to let KSM say that it wants to han=
dle the
> >> zero-filled pages itself. I'm not a the biggest fan of that approach. =
We still
> >> have two mechanisms interacting to some degree.
> >>
> >> (2) Another approach is to just let KSM handle this in VMAs that are m=
arked as
> >> mergable while KSM is active. That is, we check for VM_MERGABLE and ks=
m_run =3D=3D
> >> KSM_RUN_MERGE in try_to_map_unused_to_zeropage() to just let KSM do it=
s thing.
> >>
> >> That really just stops both mechanisms from interacting.
> >>
> >> (3) Yet another approach I could think of (in general) is to disable t=
he
> >> underused handling in a system where the underused splitting is entire=
ly disabled.
> >>
> >> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >> index e9d499da0ac7..5eca99271957 100644
> >> --- a/mm/huge_memory.c
> >> +++ b/mm/huge_memory.c
> >> @@ -82,6 +82,14 @@ unsigned long huge_anon_orders_madvise __read_mostl=
y;
> >>  unsigned long huge_anon_orders_inherit __read_mostly;
> >>  static bool anon_orders_configured __initdata;
> >>
> >> +static bool thp_underused_split_active(void)
> >> +{
> >> +       if (!split_underused_thp)
> >> +               return false;
> >> +
> >> +       return khugepaged_max_ptes_none !=3D HPAGE_PMD_NR - 1;
> >> +}
> >> +
> >>  static inline bool file_thp_enabled(struct vm_area_struct *vma)
> >>  {
> >>         struct inode *inode;
> >> @@ -4188,7 +4196,8 @@ static int __folio_split(struct folio *folio, un=
signed int
> >> new_order,
> >>         if (nr_shmem_dropped)
> >>                 shmem_uncharge(mapping->host, nr_shmem_dropped);
> >>
> >> -       if (!ret && is_anon && !folio_is_device_private(folio))
> >> +       if (!ret && is_anon && !folio_is_device_private(folio) &&
> >> +           thp_underused_split_active())
> >>                 ttu_flags =3D TTU_USE_SHARED_ZEROPAGE;
> >>
> >>         remap_page(folio, 1 << old_order, ttu_flags);
> >> @@ -4497,7 +4506,7 @@ static bool thp_underused(struct folio *folio)
> >>         int num_zero_pages =3D 0, num_filled_pages =3D 0;
> >>         int i;
> >>
> >> -       if (khugepaged_max_ptes_none =3D=3D HPAGE_PMD_NR - 1)
> >> +       if (!thp_underused_split_active())
> >>                 return false;
> >>
> >>         if (folio_contain_hwpoisoned_page(folio))
> >>
> >>
> >>
> >> I tend to like (2), and maybe (3) on top. Opinions?
> >
> > Coming back to this.
> >
> > for (2), I have to export the KSM run state, which may be fine, but it
>
> Right, you just need a simple helper.

ack. Ill add that peice back! thanks

>
> > introduces a race window. If a user disables KSM, a split occurs, and
> > then re-enables it, the bug will present itself again.
>
> Who cares?

 Haha, okay, fair enough-- was just making sure before I resent.

>
> >
> > Would it be better to just check if its VM_MERGEABLE?
>
> Some user space unconditionally sets VM_MERGEABLE, even if KSM is never e=
nabled
> (IIRC QEMU, for example).

ack! I'll keep the is_ksm_running() check :)

Cheers,
-- Nico

>
> --
> Cheers,
>
> David
>


