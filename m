Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A490FC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 23:59:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D3E06B00AF; Mon, 29 Jun 2026 19:59:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AB516B00B0; Mon, 29 Jun 2026 19:59:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E8AC6B00B1; Mon, 29 Jun 2026 19:59:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E774F6B00AF
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 19:59:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 50BFD1A0233
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:59:20 +0000 (UTC)
X-FDA: 84934619280.22.03D5E90
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 417F1180009
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:59:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RN1lq29C;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782777558;
	b=4wjjsWHk2CGYjAtEvbFAiXDgnY4v7h3MgzRxXgyiTSEbniU7e6125KmKcOwHtBnzu3wudq
	xf/MtoCIo5v0u2YSZ5A9IlQ+Izrmzhmp2FYz+jmhQH813FrrPR9Fnu+tu9hzB5PFmJwCkT
	Z1TSkXXtfhaPR5+1Yv/QrnW0L1xnRW8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782777558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iWDzERmJnfxv+whEsh/7GBge7+WOU9S3X5W/k82/+N0=;
	b=8hMsI7rMu8tloyxGsMq7ye63DflmTrNOdcVu3soYiC6XdXQ94DslTnFTB1QcD5Q20RGnfg
	Ch05zXoMMVvAFKiJ1PU9RJVtJd178CfNC2TKCMZAH+DI91cOOqSy8zPke0UiGQyPC6fWwE
	n69aorjW9KMiK3rx/fC92SB4rsQk4fo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RN1lq29C;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A12E43BC0
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3ED1F01558
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782777557;
	bh=iWDzERmJnfxv+whEsh/7GBge7+WOU9S3X5W/k82/+N0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=RN1lq29CyE7QEGxK3c3K2wpiRY66pJXUGe4CExp7+Fy8QPlOx8apZgi0opsuFAR8P
	 lJlAQIEMqofs9WWDIBp8+oIyru5kQykw3SnV8iOaLFVfzVqV7bdMeZj8DN8qru0J/D
	 dLVll56gkoqZoE9uDf6KUPfAPwcuqfGgtWJaJsX/UNjYyFcCQ1P0i4Mc0sRhDeWCow
	 9U6h+rNi8nsfUnFiMtkbJOhyhxU82baiWJG0syjDT/FmT1n2BDC+YZOsCBqlLkf6Ks
	 Ol8vCoUk6fx3n3ilT9VGjocqwkdodl2m1mcI7W/av6eFIzZmTetTV9ezggnATfFLwD
	 Twp/B32RmYfVw==
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8efef6533aaso17782806d6.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:59:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9xV7mOB1P62i3WWnyXSq5HV1xroEO8+qBpmTiG8hz1NBN/LhyZPJOQ2KP83P1Wo5/mLjGUnlZaig==@kvack.org
X-Gm-Message-State: AOJu0Ywx7WKLhPngUXPfAOct/dFq5wE2lrnjVkpEuvclZemMrVuRTa+8
	5Cz+pwzsIunCCVEKKa4rSDo3m/2WiNEmBcr+FJfSrcmvEvVi8RCd5d5CKdbewnln6ZgvNw9qdUB
	lIn9CW4AblmGKq6lDw/otHbOS2vIVndY=
X-Received: by 2002:ac8:7212:0:b0:51c:1291:e68c with SMTP id
 d75a77b69052e-51c1291e74cmr7690621cf.30.1782777556588; Mon, 29 Jun 2026
 16:59:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260623231635.43086-1-baohua@kernel.org> <20260623231635.43086-5-baohua@kernel.org>
 <e56c4d73-ed4a-48bb-8d0a-97b1200d4a35@kernel.org> <CAGsJ_4y3yC1DCsHfCn5FP6vK3jqNRbqU5pbBqHnb5LB7GgtWOA@mail.gmail.com>
 <ajzm3pHq-wQlLNmm@KASONG-MC4> <c16bd777-6dfa-48f9-8dc5-2b56bebe67ad@kernel.org>
In-Reply-To: <c16bd777-6dfa-48f9-8dc5-2b56bebe67ad@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 30 Jun 2026 07:59:05 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xh1P1yw3JogQxTS=Vu8kLEiMMh8si2YnCc9qnoKWLwjA@mail.gmail.com>
X-Gm-Features: AVVi8CfmThe1RJa7zMoO1Uwrrl4bYmrJ6JnycciHV6KuR9d8Te05UIYNLldeSC8
Message-ID: <CAGsJ_4xh1P1yw3JogQxTS=Vu8kLEiMMh8si2YnCc9qnoKWLwjA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] mm: try to free swapcache for non-LRU folios
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	baoquan.he@linux.dev, chrisl@kernel.org, jp.kobryn@linux.dev, 
	kasong@tencent.com, liam@infradead.org, linux-kernel@vger.kernel.org, 
	ljs@kernel.org, mhocko@suse.com, nphamcs@gmail.com, rppt@kernel.org, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, 
	usama.arif@linux.dev, vbabka@kernel.org, youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 417F1180009
X-Stat-Signature: cm3brkxob3u8u96ff6ecqdm8hkkgm7ee
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782777558-959788
X-HE-Meta: U2FsdGVkX1+xIXhq7cbmEIVVB2gHMCr598RfCGxyoTWThthVqPFCykuwgH+cvseqwnaoKED/2Dih7b1R/zjSOo9WoQqmohuh+5MlUBSx+0iIu5Ns3T8wTdJ+gu1WDVVCDIlMd5v2x9RWiW77d0/xqYhcGMIUAiJOhvrn916jXd55fmPPkLeI4BRDS8DGN3tzo8VBmAzXqQc4yDZA1ok8oJlq5pZ9CE6ZEmXZ2gPyiKZ5AZ8lMyCbLh+2QFCc1DV11C4GLBMlbz4ipT6eKqWMQK6xij/TJr9bkzRQcR3dlh/4SORkb3C/ozTZDQfW+5mxGvagrD8DYAAM04qIeHfl5eeDUv9yEiTsdnXxjhRg1fRlhyy5m5ToqgAU5TlJxrFEAyuveRw6HVIBS7zZQBErggNI5wLDQzaKOT6HQPvOF7CYGzDxU4xYjFgDrFOqadBNHAr1gKpZdX8cP/ejGVWL7FRR/vS/eHqxIQoS+AQlQuE31Nh8EzruqIv6ABvccGajzS59e2G06A6ziR50kc2d/q9R1CLEhMaXvmiAyQtT/mlhtVNcRbtGZ0UhOG755mPwiDbK+UoTwBxMWYiml2nhjbkouFaw0icQB6X6AnQN0FxJIDItrALmdKN0MonNFNJ1ldFqkrxBrAtVVi21ih6qgtbOmCEP3rskleWrmA/hH9TmbSE5Gq9VjX6KoMFXHoGjLDUYcd9A3mdZneeGZTlJEKjBfho65cfhgzTCiyiqEev9AugTj7HWMx7qp3CRKKI1etyowsOqMBtEVCxMWRCk3MtUg620fKZrN+JEeOa2doUgADnAt5mWWd2deGSeDfDMb1G4VXFVhKtdCkWHb4jAi/VJDTgxkmmU6MpnX6qJzGVlOsqD536m/FqUak5kjwVlzjrZk4gEwVdvXZqiSp4s+DHkM5tMBgZ5hO0n3GmXh1pKci/YvohYJdEwUzFGr8mPYDbDWSmK4QMri7jPcGQ
 +qXZj1X8
 fflQFJnSIeHfxiMWMnSKEpFhcCOHKz0YdB3g5V8zOKbVxr+U/OJalYBuiPIwQkuPJDdK81KZXXDoxbpyeZ7iyNpbANHfgYoVVidz28IRf+FiZOigGdwYq3l/TckVuN8/4yR9m5KfiPxLzQQLK7e+1FD0e4fiimWwNYCLpwMDoWsVstdMQufCbOAsu0c6SQ4GcESjaAkxXeie9EWqtzCcuf2hfwJU6HXYXtB+3TkghxPpNcrLz64/K2/gNDf1eOUquSdoE5bF3tBaQAQ6GtBEO5Mm1kNvhJofv+p76hwSJGe6Bq49ETrgAJj+XA9PUY42Ve8HeuxRSKX2Y/GQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 27, 2026 at 12:36=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> >>> That changed that behavior such that we *must* now always fallback to=
 do_wp_page().
> >>>
> >>> What a mess (I didn't ack)
> >
> > That's awkward, my bad, terribly sorry about this :(
> >
> > I sincerely apologize for the oversight and the trouble this has caused=
.
> >
>
> All good, I was just surprised to see a previous optimization partially
> reverted without a clear reasoning :)
>
> Because it should have removed the handling in should_try_to_free_swap() =
as well.
>
> It's good that we are discussing it now!
>
> > I haven't seen any performance regression in any workload recently
> > though, or any correctness issue, perhaps the round trip of
> > do_wp_page wasn't that bad. It should still catch the reuse folios,
> > just more costly than doing things in-place.
>
> Right, do_wp_page() handles it, after the page was mapped. It adds some o=
verhead,
> but fortunately no TLB flush if we're just upgrading write permissions.
>
> The optimization dates back to pre PageAnonExclusive handling.
>
> >
> > I think we should restore the original check first. We might also want =
to
> > avoid dropping the swap cache if the folio will not be reused, which
> > was discussed here:
> >
> > https://lore.kernel.org/linux-mm/CAMgjq7BDfvNXdWH0cqarsujjUn3i3tDDhDkmS=
g01TR4h-tDorQ@mail.gmail.com/
> >
> > Maybe extracting some common part into a helper can help make this
> > cleaner.
> >
> >>
> >> So it seems we need a patch before patch 4 to fix the missed
> >> swapcache freeing on write faults, because the write bit has already
> >> been cleared by the time the folio is mapped and reused?
> >>
> >> diff --git a/mm/memory.c b/mm/memory.c
> >> index 14577c67c61a..e8fc5a86f6ea 100644
> >> --- a/mm/memory.c
> >> +++ b/mm/memory.c
> >> @@ -4752,6 +4752,7 @@ static void check_swap_exclusive(struct folio
> >> *folio, swp_entry_t entry,
> >>   */
> >>  vm_fault_t do_swap_page(struct vm_fault *vmf)
> >>  {
> >> +       enum fault_flag fault_flags =3D vmf->flags;
> >>         struct vm_area_struct *vma =3D vmf->vma;
> >>         struct folio *swapcache =3D NULL, *folio;
> >>         struct page *page;
> >> @@ -5091,7 +5092,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >>          * an additional reference to the folio.
> >>          */
> >>         if (should_try_to_free_swap(si, folio, vma, nr_pages +
> >> -                       !folio_test_lru(folio), vmf->flags))
> >> +                       !folio_test_lru(folio), fault_flags))
> >>                 folio_free_swap(folio);
> >>
> >>         folio_unlock(folio);
> >>
> >>
> >> Best Regards
> >> Barry
> >
> > Hi Barry,
> >
> > The problem is more than that, the `exclusive || folio_ref_count(folio)=
 =3D=3D 1`
> > in do_swap_page is also ineffective now.
>
> Exactly.
>
> If the roundtrip through do_wp_page() is good enough today, we can just d=
o
>
> @@ -4512,7 +4516,6 @@ static vm_fault_t remove_device_exclusive_entry(str=
uct vm_fault *vmf)
>  static inline bool should_try_to_free_swap(struct swap_info_struct *si,
>                                            struct folio *folio,
>                                            struct vm_area_struct *vma,
> -                                          unsigned int extra_refs,
>                                            unsigned int fault_flags)
>  {
>         if (!folio_test_swapcache(folio))
> @@ -4528,14 +4531,7 @@ static inline bool should_try_to_free_swap(struct =
swap_info_struct *si,
>         if (mem_cgroup_swap_full(folio) || (vma->vm_flags & VM_LOCKED) ||
>             folio_test_mlocked(folio))
>                 return true;
> -       /*
> -        * If we want to map a page that's in the swapcache writable, we
> -        * have to detect via the refcount if we're really the exclusive
> -        * user. Try freeing the swapcache to get rid of the swapcache
> -        * reference only in case it's likely that we'll be the exclusive=
 user.
> -        */
> -       return (fault_flags & FAULT_FLAG_WRITE) && !folio_test_ksm(folio)=
 &&
> -               folio_ref_count(folio) =3D=3D (extra_refs + folio_nr_page=
s(folio));
> +       return false;
>  }
>
>  static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
> @@ -5095,7 +5091,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>          * Do it after mapping, so raced page faults will likely see the =
folio
>          * in swap cache and wait on the folio lock.
>          */
> -       if (should_try_to_free_swap(si, folio, vma, nr_pages, vmf->flags)=
)
> +       if (should_try_to_free_swap(si, folio, vma, vmf->flags))
>                 folio_free_swap(folio);
>
>         folio_unlock(folio);
>
> But then, one question is whether we'd actually want to try removing the =
swapcache when
> we mapped the page writable (iow: exclusive)?

I guess this question comes from my earlier commit c18160dba5ff
("mm: swap: reuse exclusive folio directly instead of wp page faults"),
where the folio is reused even for READ faults. In that case, we
would miss do_wp_page(), which could later drop the swapcache?
Also, again, nobody has reported any regression for this.

Holding swapcache for a clean folio for non-sync swap I/O has the
benefit of avoiding a potential pageout(). Now, reuse even for read
faults and always dropping swapcache seems to somewhat defeat that
benefit. On the other hand, we always drop swapcache for sync I/O
to avoid the copy in zRAM or elsewhere consuming memory, so it seems
safe enough to always enable reuse in do_swap_page() for sync I/O.

>
>
> @@ -4512,7 +4516,7 @@ static vm_fault_t remove_device_exclusive_entry(str=
uct vm_fault *vmf)
>  static inline bool should_try_to_free_swap(struct swap_info_struct *si,
>                                            struct folio *folio,
>                                            struct vm_area_struct *vma,
> -                                          unsigned int extra_refs,
> +                                          bool exclusive,
>                                            unsigned int fault_flags)
>  {
>         if (!folio_test_swapcache(folio))
> @@ -4529,13 +4533,11 @@ static inline bool should_try_to_free_swap(struct=
 swap_info_struct *si,
>             folio_test_mlocked(folio))
>                 return true;
>         /*
> -        * If we want to map a page that's in the swapcache writable, we
> -        * have to detect via the refcount if we're really the exclusive
> -        * user. Try freeing the swapcache to get rid of the swapcache
> -        * reference only in case it's likely that we'll be the exclusive=
 user.
> +        * We have an exclusive page that was mapped writable or will soo=
n
> +        * be mapped writable (as we are in a write fault). Let's just tr=
y
> +        * to reclaim swap immediately.
>          */
> -       return (fault_flags & FAULT_FLAG_WRITE) && !folio_test_ksm(folio)=
 &&
> -               folio_ref_count(folio) =3D=3D (extra_refs + folio_nr_page=
s(folio));
> +       return (fault_flags & FAULT_FLAG_WRITE) && exclusive;

I assume you mean (fault_flags & FAULT_FLAG_WRITE) || exclusive, or
we can just remove (fault_flags & FAULT_FLAG_WRITE) and use
"exclusive" instead since we are always using do_wp_page() now,
and FAULT_FLAG_WRITE in fault_flags could have been cleared
by the reuse of do_swap_page().

Best Regards
Barry

