Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19222CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 18:36:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 256756B0005; Tue, 12 May 2026 14:36:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 207CC6B008A; Tue, 12 May 2026 14:36:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D0526B008C; Tue, 12 May 2026 14:36:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EADB86B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:36:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A5592C20EF
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:36:27 +0000 (UTC)
X-FDA: 84759623214.03.8CED391
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 66BA91C000D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:36:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HvIjWn8M;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778610985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1zrh/YeuLbDPxpuLQZUDPEKStRFPUEa2ZA8WzxcXKGE=;
	b=Gt9RpTm5b2KUITPV0zytfgjEcMwtN0gioq9pPU8L5Iq46tudbzKTe7CBK9IrDZvaN+CvjN
	REsZ6yyjgKcqJoiDlWPNUc5wUGpQM1z1s8yiEZcQtvXH3udgFqxOU+tzD4WIYxikYKbooT
	/QpCzTAgkBiLSlm7Tdc5OtRfy0A8jTQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HvIjWn8M;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778610985; a=rsa-sha256;
	cv=none;
	b=YGzVePGeE9YxbY5JW4TQ7fSMBPBulc9/vTpPuSDZK8kfZxBAcObih2u4InXwXuORWLm5Sq
	g19ayaa0KsO5XpvI043KpcfUiWpXUQqTSoF9eTju+zON4Jvfd4XkRcCfOKL4zKhdLi56pi
	Zi0loWXQN0kE9E/1LqQ4Gg8lks3LuVo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778610984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1zrh/YeuLbDPxpuLQZUDPEKStRFPUEa2ZA8WzxcXKGE=;
	b=HvIjWn8MoE5Ldm7U9UmqR2cwkjCY3PQwMFQB7Wxt/qE/rJeTJ76MSfDA1aTzSHFjXgY1Bo
	FTZDsrnbEmeJDDbCj5gHApHJBpXFYup2K3BQjGZuvRB4C1EUX4UUrCCL4trT9dt1cxhRlW
	LJ6AHv2cARscekA+odtM0qkJjcceFKw=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-MjQcZJ2KN8Cu9gyyU-IYrw-1; Tue, 12 May 2026 14:36:23 -0400
X-MC-Unique: MjQcZJ2KN8Cu9gyyU-IYrw-1
X-Mimecast-MFC-AGG-ID: MjQcZJ2KN8Cu9gyyU-IYrw_1778610983
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-65c5afaff48so5626577d50.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 11:36:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778610983; x=1779215783;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1zrh/YeuLbDPxpuLQZUDPEKStRFPUEa2ZA8WzxcXKGE=;
        b=TMB8IBPJUSZIX4/xP6gVwauN1STVSgkbF231k/cOxHZWr+z/nAPjdjT1Is0yFXYRfx
         hG9p4uZzThVr9izLNt82xFzNiT+NdT55Ld6LdcE2OJ1gVF0L0M/LfOzeX9HlTQTTbMp4
         PNFqenKYHl/G/2vVO4vF4mzbnQlavO2Z+aSRr4+NfJDgXD2qJZuoyR/Kv438oizFbeir
         gPxew+EM/FOOZboxnn0nhcyUHirkVXP/XYgAYq7czPajN0g9dPn8q6APXKX91fG7JD09
         AFZbXcV0DI2jOf6axAytI/s4mWUkICC3Xqi95WQLmh2aFRzLqatb5nwZjuYiiYfRV0zD
         62aQ==
X-Gm-Message-State: AOJu0YwaT23IOw4QhBvqLcIzoALZVMURwhz+XTgJ667cr9WGj3Mv3Xdn
	A02epHE8PXXifgW5nLmZ3jrw62cUBgnZx9BdkD2CVZZJPF91cDT6TdJ8C89/VVmjk54CFfTx+fm
	Gz0gtVBxbY7frvVUKX1In1kyA554/TYGMOxuT/O9I0lN7AX0/+Qyc+N4TkS2W2jTp0y/als9V+I
	Hs8X9PtGcI65HAB8Eo/04Nxy8Cg0c=
X-Gm-Gg: Acq92OGgrNlj0z7mROzUQgs78BJzVzpW0rIqlAGzo7GxEiMEQlWV7Cx6agWZ+sAh2eU
	gm98ugBa9s0MbEUmp512jcLmi++auJ2EUC7x3LzINGcHsB45Br/2tKkbsa7nVGSJk4CKC8YmHw3
	O0aI2Zs/5xhYyyarmNHjwp40JljODRPdYOFf30PZLAIV7pdcAvzya5w/YFbxHNf+osshXqAlyTT
	cEe
X-Received: by 2002:a05:690e:12c6:b0:65c:2ea7:3111 with SMTP id 956f58d0204a3-65df5e39e55mr203319d50.2.1778610980406;
        Tue, 12 May 2026 11:36:20 -0700 (PDT)
X-Received: by 2002:a05:690e:12c6:b0:65c:2ea7:3111 with SMTP id
 956f58d0204a3-65df5e39e55mr203298d50.2.1778610979899; Tue, 12 May 2026
 11:36:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260508170509.640851-1-npache@redhat.com> <04ea0e68-de56-49c4-8c9f-1734139d5e7f@kernel.org>
 <CAA1CXcBGEUUzUYdot9j5ftNrwhxDa+2C-aOMCtKfUBEobHP0Wg@mail.gmail.com> <2b2feeda-e4a0-49f3-800e-b2391b67e018@kernel.org>
In-Reply-To: <2b2feeda-e4a0-49f3-800e-b2391b67e018@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Tue, 12 May 2026 12:36:39 -0600
X-Gm-Features: AVHnY4K9PADgeBNzAouTU4q3Dt-bG27iK8LBE8y-RTz4SlFOYTK5V9ifDFQqS6s
Message-ID: <CAA1CXcCkd7HWH6MpLQ+EeHzjJ9D=+=CdX2OsQAb8MMWMn=Rx2Q@mail.gmail.com>
Subject: Re: [RFC] mm: restrict zero-page remapping to underused THP splits
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, yuzhao@google.com, 
	usamaarif642@gmail.com, lance.yang@linux.dev, baohua@kernel.org, 
	dev.jain@arm.com, ryan.roberts@arm.com, liam@infradead.org, 
	baolin.wang@linux.alibaba.com, ziy@nvidia.com, ljs@kernel.org, 
	akpm@linux-foundation.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: f_8CKOpJyh2LXa8xy7LEZRw7DfmtWAFQhKPaBmyQcJw_1778610983
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 66BA91C000D
X-Rspamd-Server: rspam06
X-Stat-Signature: pu6hhaf8kwmj8xyyz5cqha7ozrqnxx89
X-HE-Tag: 1778610985-575499
X-HE-Meta: U2FsdGVkX1+9zruu0NA0dTaMZCNcLHWI98cQtWp7rj5r8ctId291V9ZpOhNW53DBCH3JDSpRfBzoAeaF/rTQwXSSYIpRudRcu4k93D/9l0g6s47fvPoBG5e11BkLLtodi1MgSJm6IHp85cFEUbmzqIV48rSoItSHNvJUl3ejILbs2z90fXeuyncmsSYZvlbsSpbqryRCqJIdfOc4gb50LZhUbEfOQ/fT3wH2yBgLIdO07In0Bm+uIIqxGwXI43fbQCER3BVhRBBUJIwUG4M8qwGV2se6mis9nTOWl+iTrtDOGbjn7Xw53qjs62ViDIaD1Kx+Ge7JeAAI/l7l2iGMMaE1vIiqqLEPG4eZsEPba4Lj6hRpUIIQQdry4SnDaibThtFoSZ/WOixCB7T332CEAPtoepCAZ64zs8BFnouoN8jZz/QfZ5SWnX7hduc1T+MOzGe3SSHm6pbujysYFfpWpej1/NgJW8tOqf/giAfaMnZCfnqCvDoUsKOS1WTByCghRCYgwynhAct4z7Hs5PLVl0UjD0vTigZ6kgqji0Jl+jylgi88sOhtoW4aUDuDpq/UiYTaxf3eE6LDqIRu+imqjD2tb8kd5bAwd+GbBYyadgk/GGbaDRwKKa8A5JlwNddrGIpjTud00sB3w/JMz/RgwlWyUkWlRt2t2jC+0DQKGQyR11ms/zkr7iDOG0EMunTadYyPV+ral6O+CgEmOh6piFsXQbOszlUJnWNZtOiTrnuNj4ufIptugnHg7TxHv3naZC6FpExDMnHh6dO+Ytwz+2whHGmQM1VH8tqKWrMLgj9/GcKvvYV/mt7jDPWepkWaWgDIu0DJHk/qijcz0Vrld1Xn/SwpGhSt+AeWlt62WXhjfonzBImYiHi2ecZPsyuVqtr/QxVEBgwJ/IX70Y+pIvFmZF6GYZXHWXn7m3ALg8M6BG+iZ80hdX7Bc9UTJnvN5nDz9Gbht0tQNjX4FHO
 /VEeBIB4
 TsAQbhRqsLY9d0mLn+aXnCT/vn0gnpf3b7kXxVpvI1Iiu5dqYG7Gr6W2Rpb4qOUSIjAhsYuR4dD4Rcy2BziyHgchC+h8Aqa6TMjJ+k4Lx1vcLXQ81qJn4QAT3XVT9C7C0BOwsD4xETLz1PXCUXrvQAbmhIKTQX3I9Y9+E2DSXrsGjCBsE+YuEFB/B6zO19nl4cCpaDJ/xAImNfXOWB4izPGwgN3myqdI0E4OfAw6x/FI1JCWlQj1T8GVdUlEEg8kgP6YJ4hJwUDIqiU626Z8Nhtg6h28K5nzg8ks+hPo+C7XCRdNHUbIvNPwSsiCd/Q6qGJ/BorD/5NTEyKE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 1:05=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 5/11/26 20:40, Nico Pache wrote:
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
> >
> > And what was the expected behavior before this commit? Did we just
> > deal with the wasted memory?
>
> Before your change, splitting will always free memory, no matter who trig=
gers
> splitting. So there is no wasted memory (regarding underused THPs).
>
> With your change, if we happen to split before the deferred shrinker runs=
, we
> end up with zero-filled pages that waste memory. And reclaiming them (thr=
ough
> the deferred shrinker) first requires another re-collapse to a THP.
>
> Or am I misunderstanding your question?

I meant before b1f202060afe ("mm: remap unused subpages to shared
zeropage when splitting isolated thp"). Sorry, I should have been more
specific.

As in before the underutilized shrinker (and commit b1f202060afe), we
had the exact problem you describe above and no way to handle it.
Correct?

I guess at reclaim THPs would be split and we would swap out a zero filled =
page?

>
> >
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
> > I don't fully understand (2) but I definitely agree with (3).
> >
> > Isn't (2) similar to my split_huge_page_no_zeropage() solution in that
> > it only disables the behavior for KSM? but instead handled much
> > further down in the call path? The "fix" commit sold this as a
> > solution ONLY for the underutilized shrinker, but it is not that.
>
> It keeps other paths that happen to split the folio before the deferred s=
hrinker
> runs unaffected (see above).
>
> --
> Cheers,
>
> David
>


