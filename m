Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B833CFA46C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 04:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FFA46B0012; Thu, 20 Nov 2025 23:56:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D7496B0022; Thu, 20 Nov 2025 23:56:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ED006B0026; Thu, 20 Nov 2025 23:56:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F6E86B0012
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 23:56:40 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AF2FD12FDA9
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 04:56:39 +0000 (UTC)
X-FDA: 84133403718.12.07CFE11
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id E123D4000E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 04:56:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="QNfG/psd";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763700997; a=rsa-sha256;
	cv=none;
	b=43JW6yVm32CKSlf+oCxeARhCdTX3b0cU9LdLhGmmDC6F4ol0gGTq03e+dL64OvRegykTep
	fFU5hQskWpMkw9HsHVU2DbMAVV4FVxb9se0FR7g0wZMxf92jSjeX3A1bm/5lYHwvSMAxED
	sSRKc12r4vFbl6ROqqxQ/OHQjhLxx7I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="QNfG/psd";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763700997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SnW/oP8elxPhhardLem8xqk6W6mHH2t3is6Uz2HJfK8=;
	b=sxj4I0bAVT1+zdoAb1X8qkN8dT/Wql+sOjtUtrDJQUWXPaL4RywEoH2EWpZBgqCeK5fd7h
	dS2VkB5xlK2mYcUqUrSVUgKu1r+b0AvS1mogUe3W7UTVUXL3+7hIP7w+NV+5CyFSv7k9Tm
	u0NorlKLmJem25kHYyvtTJxs8sgLCIk=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8b2dcdde698so230314585a.3
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 20:56:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763700997; x=1764305797; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SnW/oP8elxPhhardLem8xqk6W6mHH2t3is6Uz2HJfK8=;
        b=QNfG/psdPC65LYmPoXPfJF62n+KUDleQZM92LQlg8Rjod5gPYMYk+iV0Vt3rNTW8z4
         h7TBNXrVYa4NJCyAvrusFa4Yz7yB8B8lcQoNlSwkesSXgcsNfYLZSJfqA3y+FrNLpqI3
         FWrbYNGDEW2Nqt0l1aqRxVAwaQaUzSFdaryyEUmZDd+AWQlXbXozdOGn14Guj6+4VXjm
         i/3qiDMidlWyd8ANMMKdD8thagVYgZeTn5vJIquQaHfE1X5H82xLk8SyKGMX4SGhhmv4
         TkJkrvgjXMKjotHDGenYd6PTCLMtvj5NoGdofhrDsj0RWaaH5J2KaV5UDNt8O1oVCxHh
         h0tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763700997; x=1764305797;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SnW/oP8elxPhhardLem8xqk6W6mHH2t3is6Uz2HJfK8=;
        b=kyrsXknpUhgk9hLE2cb+Ngu5n1kbJ+3HsLbTbEkil09gJ82vQYpDUeKrsiYaB3YItB
         rpBZFH4HJqqC8cGHvUlxB+GRkSeQnnsJ23JwuMzQ9ffHLZCNtCivuOlCupx2UGQpgNLb
         k0b85itnFm77U4GJEIDEh+aDd4/X3k5re0znrqhKJ6jVotinLXw8gXvbtldFkpDcOnH3
         7b2HTHM9LyA1+c+KpGYmHHGtjOcd3Z488rOuQP+OzLrwn25pdofvsEDcnAspR9cRX9Il
         +mVoLvuH8JTGdaNlVMIs9lTv/kV8Ov3MZDb+e5asWWVGQzwlx6iuH02HF+QtzAiVfkjk
         34Lw==
X-Gm-Message-State: AOJu0YzEWttIwEPpi+xFQ56F+dqvqKseXYCdwbE8CpWY5/haLsh7S+JN
	A0jPPEo73/g/YN/0QEqMK2+tl8cL48mpzDXmqVPLfOt5ueic0CN4LV0F3IH6kUcpSx8a1n4K5ML
	/+eqPRsYCOKd70WjMTQ2hjdAO+kE+yUg=
X-Gm-Gg: ASbGncvrlU6mXUU1JjDUjuSTIt9h7IVkTCMwuYnlo9d8kz+lASx4wZEaFQf5dPRgkOh
	vZaJCW05izP7BeYfWUVe1CuL/MznsmDDOshRFPtjtorFi1vR88O/u6YBYffw0vLJryR8RduM8WQ
	5nP82dnjV40K2DZ3wsSkfG8+6TL22mYK5Oc8eVlxT26pu3ifeqDb6O7HYKgcPBIfQa6Ga6rlE9S
	7/PsHMffNQpv2fkOxU2d7TLisG39ahggLFS4VYXbqtUDgFnlFJm5BTDAlEu6aVhP4tBbg==
X-Google-Smtp-Source: AGHT+IHhcBCsVM/g9dOhs+6ZqumVRLQ0Qwy1iOevfTs2FzlLKwwdtHXYeRy5kvvJUdBLrAbY6J73IM9YO4TrmNjD1vc=
X-Received: by 2002:a05:620a:4409:b0:8a1:ac72:e3db with SMTP id
 af79cd13be357-8b33d48394bmr77098285a.72.1763700996698; Thu, 20 Nov 2025
 20:56:36 -0800 (PST)
MIME-Version: 1.0
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
 <20251117-swap-table-p2-v2-3-37730e6ea6d5@tencent.com> <CAGsJ_4zSqQax-Ct-zz3uMZ_dD7vnvTjWZ_BsnXBnMVpVNNDYUA@mail.gmail.com>
 <CAMgjq7BYNwVSX+=KDxmdFpUZ4gnTDjA7LU_Fi=J6SFUV8pAcUg@mail.gmail.com>
In-Reply-To: <CAMgjq7BYNwVSX+=KDxmdFpUZ4gnTDjA7LU_Fi=J6SFUV8pAcUg@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 21 Nov 2025 12:56:25 +0800
X-Gm-Features: AWmQ_bmHdmJUk9oTP4ld9mjRqh04vmNXphqNqz-A32j_4zEO8dehk3t4O7lhINA
Message-ID: <CAGsJ_4y1VyyJj8zfrA7zDOUJ9OSGo6z6KO1zX6n3iigvYpYheQ@mail.gmail.com>
Subject: Re: [PATCH v2 03/19] mm, swap: never bypass the swap cache even for SWP_SYNCHRONOUS_IO
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E123D4000E
X-Rspamd-Server: rspam07
X-Stat-Signature: gkredtrirefufcetpt4nitnstbb39yyc
X-Rspam-User: 
X-HE-Tag: 1763700997-152473
X-HE-Meta: U2FsdGVkX1+bRHLAIjA7vlE1gmndYJM5SDAESU6q7ykvNYSRAwkCTiW9IXqLcItAntj7ARkFEu9G6ahemo7BNXI/QEam1JIWFiuLUkqQY8qjnw5jz9N1TknHsPV78LeiB3qix5HardZmI1cPRte3k24kSF4DxH4fxMkZhsKN/R+bDjdPAnqJpLgAYyrcejAl9VdtHdP+LKY09BytD8GvWlspCsXDjcqTskXc3Jdniy1YRqQ2pS2F7M4ZSHCiDyq7sCGCLCktJniELu8RCeCofAD1fibXLUNm9cGP3+Chkuo485CBy7wZxxXi4MNB5MVutKXo+iLWthHqVFSWU1cmh5NfY+l95TV8MSLont89Z/IsFStTCr4vV17CHV5HIi9nsS8mtUKMCd4agpDvUocLIR6kMO1rKKiRrHLHt4j6qeYv1mxkgQPUxuVqjHKQcLr+UgSkbeJWsH54zTkklwvsKdXQiNjEOWvtbitNJvuIieHYoOzYB/qlk8Qwivp7oeZG8Ig2mrYw16NhQyTog41qS5jmONQz6M0bUa1HEeCnJkgArp02tt05pON6ZSUSvvF7almhVS34W6CbJoiOC0LpQbwsVcVP5qbatUzIB3ExGa6fSfDthPZv6z8nVLE6I19w+oTWZb6M+y2Eu+rRYGv/+jOCkUuIEaDWjQVJz254eYCLSLfIxrQ6uJQIENdIkubC3v+XPMVvCBTnrDrLEztdFmmdmkW2JOJGzK4e24Kug9VVKeJSgB45ca1ti3x7CMtyxH3OGtTT1LRiuUq29cIjPSOCY9U5mB9GR1EFZ8zpTuYgHs+WqOunXvwFvDrtvOACQiVtUAhSqi8c4V5XM6Wc4HRA5ZK6Dsf+ltBJKRM1cX6Z7nnq8gf4JRUbV6ySWzZAIBTkhrKwaOPCl1PKFw6U8xRwgVWdh4biot39AIcX6394RkD0iSIKI7iFvgZnRR8D69U7WvqbmmoJ5CsSOGk
 m5pODbmx
 2OK61zj2sjDSRzTvt8ElX3gM2GfnfXTMN75bzfc1hOnhKWcylhsHqZN4zB3YrjggcxYq/grxeMWX9Q3WBqb5KK1V8tWExh0565n6yfuxgSLQe7/kJDfdQUjhaSaXgONuJCoCDaka992VzKLFChhgtDM9XYTQf8y+DgoKjUBtCAvhGlMdHNNRkeh4DCBi06JMgI6U0CVjnG4Z5LLGrwOPBWnhNGgRrJ758jElt84ZSwV2D0NcCKbyOPGuIB7p2+eUDkj2lJWxpXTYuAyNpNBxyLJ9pur4GUBu7y0d3ZmHojquCLyJbrJuE9NigAv2ioPwfiPVr5YVVa9EfTM9XbAetSMkNuW/NOMnGEnaMZumVsqykxcJMl9AMRyz93s1Ca5oWBfJIQmi26RYfJLJB73METE1GLtNt/qfTgeo7+rqYA0dKDpU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 10:42=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> On Fri, Nov 21, 2025 at 8:55=E2=80=AFAM Barry Song <21cnbao@gmail.com> wr=
ote:
> >
> > Hi Kairui,
> >
> > >
> > > +       /*
> > > +        * If a large folio already belongs to anon mapping, then we
> > > +        * can just go on and map it partially.
> >
> > this is right.
> >
>
> Hi Barry,
>
> Thanks for the review.
>
> > > +        * If not, with the large swapin check above failing, the pag=
e table
> > > +        * have changed, so sub pages might got charged to the wrong =
cgroup,
> > > +        * or even should be shmem. So we have to free it and fallbac=
k.
> > > +        * Nothing should have touched it, both anon and shmem checks=
 if a
> > > +        * large folio is fully appliable before use.
> >
> > I'm curious about one case:
> >
> > - Process 1: nr_pages are in swap.
> > - Process 2: "nr_pages - m" pages are in swap (with m slots already
> >   unmapped).
> >
> > Sequence:
> >
> > 1. Process 1 swap-ins the page, allocates it, and adds it to the
> >    swapcache =E2=80=94 but the rmap hasn=E2=80=99t been added yet.
>
> Yes, whoever wants to use the folio will have to lock it first.
>
> > 2. Process 2 swap-ins the same folio and finds it in the swapcache, but
> >    it=E2=80=99s not associated with anon_mapping yet.
>
> If P2 found it in the swap cache, it will try to acquire the folio lock.
>
> > What will process 2 do in this situation? Does it go to out_nomap? If s=
o,
> > what happens on the second swapin attempt? Will it keep retrying
> > indefinitely until Process 1 completes the rmap installation?
>
> P2 will wait on the folio lock, which I think is the right thing to
> do. After P1 finishes the rmap installation, P2 wakes up and tries to
> map the folio, no busy loop or repeated fault.

Right. The folio lock might help. But consider this case:
p1 runs on a small core,
p2(partially unmapped) runs on a big core,
p2 grabs the folio lock before p1 and therefore goes to out_nomap.
After p2 unlocks the folio and wakes p1, p1 may not preempt the
current task on its CPU in time. p2 may repeatedly fault and take the
lock again. But yes, the race window is small though mTHP might
increase the race address range.

For small folios, this problem does not exist =E2=80=94 whoever gets the lo=
ck
first can map it first.
Ideally, we would enhance the rmap API so it can partially add new
anon mappings.

I guess we may defer handling this problem till someone reports it?

>
> If P1 somehow failed to install the rmap (eg. a concurrent partial
> unmap made part of the page table invalidated), it will remove the
> folio from swap cache then unlock it (the code right below). P2 also
> wakes up by then, and sees the invalid folio will then fallback to
> order 0.

Yes, I understand this is the case for p1. The concern is that p2 is
partially unmapped.

>
> >
> > > +        *
> > > +        * This will be removed once we unify folio allocation in the=
 swap cache
> > > +        * layer, where allocation of a folio stabilizes the swap ent=
ries.
> > > +        */
> > > +       if (!folio_test_anon(folio) && folio_test_large(folio) &&
> > > +           nr_pages !=3D folio_nr_pages(folio)) {
> > > +               if (!WARN_ON_ONCE(folio_test_dirty(folio)))
> > > +                       swap_cache_del_folio(folio);
> > > +               goto out_nomap;
> > > +       }
> > > +
> > >         /*
> > >          * Check under PT lock (to protect against concurrent fork() =
sharing
> > >          * the swap entry concurrently) for certainly exclusive pages=
.
> > >          */
> > >         if (!folio_test_ksm(folio)) {
> > > +               /*
> > > +                * The can_swapin_thp check above ensures all PTE hav=
e
> > > +                * same exclusivenss, only check one PTE is fine.
> >
> > typos? exclusive=C2=ADness ? Checking just one PTE is fine ?
>
> Nice catch, indeed a typo, will fix it.
>
> >
> > > +                */
> > >                 exclusive =3D pte_swp_exclusive(vmf->orig_pte);
> > > +               if (exclusive)
> > > +                       check_swap_exclusive(folio, entry, nr_pages);
> > >                 if (folio !=3D swapcache) {
> > >                         /*
> > >                          * We have a fresh page that is not exposed t=
o the
> > > @@ -4985,18 +4962,16 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> > >         vmf->orig_pte =3D pte_advance_pfn(pte, page_idx);
> > >
> > >         /* ksm created a completely new copy */
> > > -       if (unlikely(folio !=3D swapcache && swapcache)) {
> > > +       if (unlikely(folio !=3D swapcache)) {
> > >                 folio_add_new_anon_rmap(folio, vma, address, RMAP_EXC=
LUSIVE);
> > >                 folio_add_lru_vma(folio, vma);
> > >         } else if (!folio_test_anon(folio)) {
> > >                 /*
> > > -                * We currently only expect small !anon folios which =
are either
> > > -                * fully exclusive or fully shared, or new allocated =
large
> > > -                * folios which are fully exclusive. If we ever get l=
arge
> > > -                * folios within swapcache here, we have to be carefu=
l.
> > > +                * We currently only expect !anon folios that are ful=
ly
> > > +                * mappable. See the comment after can_swapin_thp abo=
ve.
> > >                  */
> > > -               VM_WARN_ON_ONCE(folio_test_large(folio) && folio_test=
_swapcache(folio));
> > > -               VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> > > +               VM_WARN_ON_ONCE_FOLIO(folio_nr_pages(folio) !=3D nr_p=
ages, folio);
> > > +               VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
> >
> > We have this guard to ensure that a large folio is always added to the
> > rmap in one shot, since we only support partial rmap addition for folio=
s
> > that have already been mapped before.
> >
> > It now seems you rely on repeated page faults to ensure the partially
> > mapped process runs after the fully mapped one, which doesn=E2=80=99t l=
ook ideal
> > to me as it may cause priority inversion.
>
> We are mostly relying on folio lock now, I think there is no priority
> inversion issue from this part.
>
> There might be priority inversion in the swap cache layer (so we have
> a schedule_timeout_uninterruptible workaround in
> __swap_cache_prepare_and_add now), that issue is resolved in the
> follow up commit "mm, swap: use swap cache as the swap in synchronize
> layer". Sorry I can't make it all happen in one place because the
> SYNC_IO swapin path has to be removed first for that to happen. That
> workaround is not a critical issue besides being ugly so I think
> that's fine for intermediate steps.

Yes. It would be nice to drop the workaround for waking up tasks.

Thanks
Barry

